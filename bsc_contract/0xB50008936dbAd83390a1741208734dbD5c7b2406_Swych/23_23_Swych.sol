// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

import "./interfaces/IDEXRouter.sol";
import "./interfaces/IDEXFactory.sol";
import "./interfaces/IDEXPair.sol";

/**
 * @title SWYCH ERC20 token
 */
contract Swych is IERC20, Initializable, OwnableUpgradeable, PausableUpgradeable, UUPSUpgradeable {
  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
    _disableInitializers();
  }

  using SafeMathUpgradeable for uint256;
  using SafeERC20Upgradeable for IERC20Upgradeable;

  string private constant _name = "Swych";
  string private constant _symbol = "SWYCH";
  uint8 private constant _decimals = 18;

  uint256 private constant ONE_UNIT = 10**_decimals;
  uint256 private constant INITIAL_FRAGMENTS_SUPPLY = (10**9) * ONE_UNIT; // 1 billion

  /**
   * @notice The max possible number that fits uint256. This constant is used throughout the project.
   * @return The max uint256 value (2^256 - 1).
   */
  uint256 public constant MAX_UINT256 = ~uint256(0);
  /**
   * @notice The so-called `dead` address that is commonly used to send burned tokens to.
   * @return The `dead` address.
   */
  address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
  /**
   * @notice The zero address that is commonly used for burning tokens. You can think about it as `/dev/null`.
   * @return The zero address.
   */
  address public constant ZERO = 0x0000000000000000000000000000000000000000;
  /**
   * @notice The upper limit of the factor that is used to calculate the max amount of tokens a user can sell during the non-sell period.
   * @return The upper limit of the factor.
   */
  uint256 public constant MAX_AVAILABLE_TRADING_BALANCE_FACTOR = 2000;
  /**
   * @notice The lower limit of the factor that is used to calculate the max amount of tokens a user can sell during the non-sell period.
   * @return The lower limit of the factor.
   */
  uint256 public constant MIN_AVAILABLE_TRADING_BALANCE_FACTOR = 200;
  /**
   * @notice The upper limit of sell fee
   */
  uint256 public constant MAX_SELL_FEE = 20;
  /**
   * @notice The upper limit of buy fee
   */
  uint256 public constant MAX_BUY_FEE = 15;
  /**
   * @notice The upper limit of transfer fee
   */
  uint256 public constant MAX_TRANSFER_FEE = 50;

  uint256 public gonsPerFragment;
  uint256 private _totalGons;
  uint256 private _totalSupply;
  bool private _inSwap;
  uint256 private _gonsCollectedFeeThreshold;

  mapping(address => uint256) public transferTimelock;
  /**
   * @notice The automated market maker pairs.
   * @return The mapping with automated market maker pairs.
   */
  mapping(address => bool) public automatedMarketMakerPairs;
  mapping(address => uint256) private _gonBalances;
  mapping(address => mapping(address => uint256)) private _allowedFragments;
  mapping(address => bool) private _noCheckAvailableTradingBalance;
  mapping(address => SaleHistory) public saleHistories;
  /**
   * @notice Indicates by how much the total supply should be increased, when the reward mechanism is POSITIVE.
   * @return The reward rate value. Is denominated by the `rewardRateDenominator` variable.
   */
  uint256 public rewardRate;
  /**
   * @notice The denominator that is used with the reward rate in calculations.
   * @return The reward denominator value.
   */
  uint256 public rewardRateDenominator;
  /**
   * @notice Indicates by how much should the inflation increase to trigger a rebound routine.
   * @return The value in percentage of the all-time-high token price. Is denominated by the `negativeFromAthPercentDenominator` variable.
   */
  uint256 public negativeFromAthPercent;
  /**
   * @notice The denominator that is used with the `negativeFromAthPercent` in calculations.
   * @return The denominator value.
   */
  uint256 public negativeFromAthPercentDenominator;
  /**
   * @notice The time of the last reward action.
   * @return The time value as a UNIX timestamp.
   */
  uint256 public lastRewardTime;
  /**
   * @notice The fee applied to buys.
   * @return The value of the buy fee. The value is denominated by the `feeDenominator` variable.
   */
  uint256 public buyFee;
  /**
   * @notice The fee applied to sells.
   * @return The value of the sell fee. The value is denominated by the `feeDenominator` variable.
   */
  uint256 public sellFee;
  /**
   * @notice The fee applied to transfers.
   * @return The value of the transfer fee. The value is denominated by the `feeDenominator` variable.
   */
  uint256 public transferFee;
  /**
   * @notice The denominator used with fee calculations.
   * @return The value of the fee denominator.
   */
  uint256 public feeDenominator;
  /**
   * @notice The coefficient `a` of the equation that is used to calculate trading balance limit.
   * @return The value of the coefficient. The value is denominated by the `tradingBalanceDenominator` variable.
   */
  uint256 public coefficientA;
  /**
   * @notice The max permyriad that could be applied when calculating the available trading balance limits.
   * @return The max value in permyriad.
   */
  uint256 public maxHoldingPermyriadAvailableTradingBalanceApplied;
  /**
   * @notice The min permyriad that could be applied when calculating the available trading balance limits.
   * @return The min value in permyriad.
   */
  uint256 public minHoldingPermyriadAvailableTradingBalanceApplied;
  /**
   * @notice The fee applied during transfers that goes to the liquidity pool.
   * @return The value of the auto-liquidity fee in percentage.
   */
  uint256 public autoLiquidityFeePercent;
  /**
   * @notice The fee applied during transfers that goes to the treasury.
   * @return The value of the treasury fee in percentage.
   */
  uint256 public treasuryFeePercent;
  /**
   * @notice The fee that describes the amount of tokens that are burnt during transfers.
   * @return The value of the burn fee in percentage.
   */
  uint256 public burnFeePercent;
  /**
   * @notice The denominator used with trading balance's equation's coefficients calculations.
   * @return The value of the denominator.
   */
  uint256 public tradingBalanceDenominator;
  /**
   * @notice The address of the WBNB token.
   * @return The address.
   */
  address public WBNB;
  /**
   * @notice The DEX router that is used with token operations.
   * @return The router.
   */
  IDEXRouter public router;
  /**
   * @notice The address of the SWYCH/WBNB pair on the DEX.
   * @return The pair address.
   */
  address public pair;
  /**
   * @notice The all-time-high WBNB price of the SWYCH token.
   * @return The price in WBNB.
   */
  uint256 public athPrice;
  /**
   * @notice The permille value used with ATH price calculations.
   * @return The permille value.
   */
  uint256 public athPriceDeltaPermille;
  /**
   * @notice The ATH token price during the latest rebound.
   * @return The token price in WBNB.
   */
  uint256 public lastReboundTriggerAthPrice;
  /**
   * @notice The frequency of rewards in seconds.
   * @return The frequency in seconds.
   */
  uint256 public rewardFrequency;
  /**
   * @notice The receiver of the auto-liquidity.
   * @return The address of the auto-liquidity receiving wallet.
   */
  address public autoLiquidityReceiver;
  /**
   * @notice The treasury.
   * @return The address of the treasury wallet.
   */
  address public treasury;
  /**
   * @notice The person who deployed the current smart contract.
   * @return The address of the smart contract deployer.
   */
  address public deployer;
  /**
   * @notice The flag that indicates if the smart contract is launched.
   * @return True, if the smart contract is launched, else - false.
   */
  bool public launched;
  /**
   * @notice The flag that indicates if the automatic rewarding on transfers should be enabled.
   * @return True, if auto-rewarding is enabled, else - false.
   */
  bool public autoReward;
  /**
   * @notice The flag that indicates if swapbacks are enabled.
   * @return True, if swapbacks are enabled, else - false.
   */
  bool public swapBackEnabled;
  /**
   * @notice The flag that indicates if available trading balance limits should be checked during transfers.
   * @return True, if the check is enabled, else - false.
   */
  bool public availableTradingBalanceEnabled;
  /**
   * @notice The flag that indicates if the token price in WBNB should be calculated with each transfer.
   * @return True, if the calculation is enabled, else - false.
   */
  bool public priceEnabled;
  /**
   * @notice The flag that indicates if the rebase is enabled. Default false.
   * @return True, if the rebase is enabled, else - false.
   */
  bool public rebaseEnabled;
    /**
   * @notice The flag that indicates if the rebound is enabled. Default false.
   * @return True, if the rebound is enabled, else - false.
   */
  bool public reboundEnabled;
  /**
   * @notice The flag that indicates if transfer fees are enabled.
   * @return True, if the fees are enabled, else - false.
   */
  bool public transferFeeEnabled;
  /**
   * @notice The mapping of wallet addresses that are free of fee charges.
   * @return For each wallet address provided - true, if the address is in the exemption list, else - false.
   */
  mapping(address => bool) public isFeeExempt;
  /**
   * @notice The array of SWYCH pairs.
   * @return The pairs array.
   */
  address[] public makerPairs;
  /**
   * @notice The max number of makerPairs allowed.
   * @return The max number.
   */
  uint256 public constant MAX_MAKER_PAIRS_COUNT = 10;
  /**
   * @notice The mapping of black listed LP contracts that will prohibit swapping of the SWYCH token.
   * @return For each LP address provided - true, if the LP address is blacklisted, else - false.
   */
  mapping(address => bool) public blockedPairs;
  /**
   * @notice Mapping of addresses that are authorized to mint SWYCH.
   * @return bool Flag of authorization. 
   */
  mapping(address => bool) public authorizedToMint;

  // INFO: SWYCH v1.0 storage ends here. Add new state variables below. Don't modify orders of old variables to avoid storage collision.

  enum RewardType {
    POSITIVE,
    NEGATIVE
  }

  enum TransactionType {
    BUY,
    SELL,
    TRANSFER
  }

  // SaleHistory tracking how many tokens that a user has sold within a span of 24hs
  struct SaleHistory {
    uint256 lastAvailableTradingBalanceAmount;
    uint256 lastSoldTimestamp;
    uint256 totalSoldAmountLast24h;
  }

  /**
   * @notice Event.
   * @dev Is emitted from the `_reward` function when rewards take place.
   * @param epoch The UNIX timestamp of the block when the reward has happened.
   * @param rewardType The type of the reward (reward or rebound).
   * @param lastTotalSupply The last total supply value before the reward.
   * @param currentTotalSupply The current total supply value after the reward.
   */
  event LogReward(uint256 indexed epoch, RewardType rewardType, uint256 lastTotalSupply, uint256 currentTotalSupply);
  /**
   * @notice Event.
   * @dev Is emitted from the `SetAutomatedMarketMakerPair` function when the owner sets automated market maker pairs.
   * @param pair The pair address.
   * @param value True to set the pair, false to unset the pair.
   */
  event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
  /**
   * @notice Event.
   * @dev Is emitted from the `launch` function. Shows the timestamp of the block when the smart contract was launched.
   * @param launchedAt The UNIX timestamp of the contract launch date and time.
   */
  event Launched(uint256 launchedAt);
  /**
   * @notice Event.
   * @dev Is emitted from the `withdrawFeesToTreasury` function which is called by the owner. Shows that fees were withdrawn to the treasury.
   * @param amount The amount that was withdrawn to the treasury.
   */
  event WithdrawFeesToTreasury(uint256 amount);
  /**
   * @notice Event.
   * @dev Is emitted from the `setPriceEnabled` function which is called by the owner. Shows that the value of the `priceEnabled` variable was changed by the owner.
   * @param value The new value of the `priceEnabled` flag.
   */
  event SetPriceEnabled(bool value);
  /**
   * @notice Event.
   * @dev Is emitted from the `setRewardFrequency` function which is called by the owner. Shows that the value of the `rewardFrequency` variable was changed by the owner.
   * @param valueInSeconds The new value of the `rewardFrequency` variable in seconds.
   */
  event SetRewardFrequency(uint256 valueInSeconds);
  /**
   * @notice Event.
   * @dev Is emitted from the `setAutoReward` function which is called by the owner. Shows that the value of the `autoReward` variable was changed by the owner.
   * @param flag The new value of the `autoReward` flag.
   */
  event SetAutoReward(bool flag);
  /**
   * @notice Event.
   * @dev Is emitted from the `setAvailableTradingBalanceEnabled` function which is called by the owner. Shows that the value of the `availableTradingBalanceEnabled` variable was changed by the owner.
   * @param flag The new value of the `availableTradingBalanceEnabled` flag.
   */
  event SetAvailableTradingBalanceEnabled(bool flag);
  /**
   * @notice Event.
   * @dev Is emitted from the `setNoCheckAvailableTradingBalance` function which is called by the owner. Shows that the owner has changed the status of an address.
   * @param address_ The wallet address.
   * @param flag The new status of the wallet address.
   */
  event SetNoCheckAvailableTradingBalance(address indexed address_, bool flag);
  /**
   * @notice Event.
   * @dev Is emitted from the `setTransferFeeEnabled` function which is called by the owner. Shows that the value of the `transferFeeEnabled` variable was changed by the owner.
   * @param flag The new value of the `transferFeeEnabled` flag.
   */
  event SetTransferFeeEnabled(bool flag);
  /**
   * @notice Event.
   * @dev Is emitted from the `setSwapBackEnabled` function which is called by the owner. Shows that the value of the `swapBackEnabled` variable was changed by the owner.
   * @param flag The new value of the `swapBackEnabled` flag.
   */
  event SetSwapBackEnabled(bool flag);
  /**
   * @notice Event.
   * @dev Is emitted from the `setCollectedFeeThreshold` function which is called by the owner. Shows that the value of the `_gonsCollectedFeeThreshold` variable was changed by the owner.
   * @param amount The new value of the threshold.
   */
  event SetCollectedFeeThreshold(uint256 amount);
  /**
   * @notice Event.
   * @dev Is emitted from the `setAvailableTradingBalanceCoefficients` function which is called by the owner. Shows that the values of the equation used to calculate trading balance factor were changed by the owner.
   * @param a The new value of the `a` coefficient of the equation.
   * @param denominator The new value of the equation coefficient denominator.
   */
  event SetAvailableTradingBalanceCoefficients(uint256 a, uint256 denominator);
  /**
   * @notice Event.
   * @dev Is emitted from the `setReboundTriggerFromAth` function which is called by the owner. Shows that the owner has set new rebound trigger values.
   * @param percent The new rebound percentage value.
   * @param denominator The new value of the rebound denominator.
   */
  event SetReboundFromAth(uint256 percent, uint256 denominator);
  /**
   * @notice Event.
   * @dev Is emitted from the `setRewardRate` function which is called by the owner. Shows that the owner has set the new reward rate.
   * @param rate The new reward rate value.
   * @param denominator The new value of the reward denominator.
   */
  event SetRewardRate(uint256 rate, uint256 denominator);
  /**
   * @notice Event.
   * @dev Is emitted from the `setRangeHoldingPermyriadAvailableTradingBalanceApplied` function which is called by the owner.
   * @param minHoldingPermyriad The new value of the `minHoldingPermyriadAvailableTradingBalanceApplied` variable.
   * @param maxHoldingPermyriad The new value of the `maxHoldingPermyriadAvailableTradingBalanceApplied` variable.
   */
  event SetRangeHoldingPermyriadAvailableTradingBalanceApplied(uint256 minHoldingPermyriad, uint256 maxHoldingPermyriad);
  /**
   * @notice Event.
   * @dev Is emitted from the `setTreasuryWallet` function which is called by the owner. Shows that the owner has changed the treasury wallet address.
   * @param wallet The new treasury wallet address.
   */
  event SetTreasuryWallet(address wallet);
  /**
   * @notice Event.
   * @dev Is emitted from the `setAutoLiquidityReceiver` function which is called by the owner. Shows that the owner has changed the auto-liquidity receiver wallet address.
   * @param wallet The wallet address of the new auto-liquidity receiver.
   */
  event SetAutoLiquidityReceiver(address wallet);
  /**
   * @notice Event.
   * @dev Is emitted from the `setFeeExemptAddress` function which is called by the owner. Shows that the owner has changed the fee exemption status of a wallet address.
   * @param address_ The address of the wallet the exemption status of which has changed.
   * @param flag True, if the wallet address was exempted, else - false.
   */
  event SetFeeExemptAddress(address address_, bool flag);
  /**
   * @notice Event.
   * @dev Is emitted from the `setBackingLPToken` function which is called by the owner. Shows that the owner has set the SWYCH/WBNB pair address.
   * @param lpAddress The address of the SWYCH/WBNB pair.
   */
  event SetBackingLPToken(address lpAddress);
  /**
   * @notice Event.
   * @dev Is emitted from the `pause` function which is called by the owner. Shows that the smart contract operations were paused.
   */
  event Pause();
  /**
   * @notice Event.
   * @dev Is emitted from the `unpause` function which is called by the owner. Shows that the smart contract operations were resumed.
   */
  event Unpause();
  /**
   * @notice Event.
   * @dev Is emitted from the `setFeeSplit` function which is called by the owner. Shows that the fee splits were changed.
   * @param autoLiquidityPercent The new auto-liquidity fee percentage of the total fee.
   * @param treasuryPercent The new treasury fee percentage of the total fee.
   * @param burnPercent The new burn fee percentage of the total fee.
   */
  event SetFeeSplit(uint256 autoLiquidityPercent, uint256 treasuryPercent, uint256 burnPercent);
  /**
   * @notice Event.
   * @dev Is emitted when the WBNB price of the SWYCH token reaches its all time high.
   * @param lastAthPrice The previous ATH value.
   * @param newAthPrice The current ATH value.
   */
  event NewAllTimeHigh(uint256 lastAthPrice, uint256 newAthPrice);
  /**
   * @notice Event.
   * @dev Is emitted from the `setFees` function which is called by the owner. Shows that the owner has changed the fees.
   * @param buyFee The new buy fee value.
   * @param sellFee The new sell fee value.
   * @param transferFee The new transfer fee value.
   */
  event SetFees(uint256 buyFee, uint256 sellFee, uint256 transferFee);
  /**
   * @notice Event.
   * @dev Is emitted from the `setAthDeltaPermille` function which is called by the owner.
   * @param permille The new ATH threshold.
   */
  event SetAthDeltaPerMille(uint256 permille);

  /**
   * @notice Event.
   * @dev Is emitted from the `setBlockedPair` function which is called by the owner.
   * @param dexPair The address of the DEX pair.
   * @param flag The blocked status.
   */
  event SetBlockedPair(address dexPair, bool flag);

  /**
   * @notice Event.
   * @dev Is emitted from the `setRewardEnabled` function which is called by the owner.
   * @param rebaseEnabled The rebase reward status.
   * @param reboundEnabled The rebound reward status.
   */
  event SetRewardEnabled(bool rebaseEnabled, bool reboundEnabled);

  modifier swapping() {
    _inSwap = true;
    _;
    _inSwap = false;
  }

  modifier validRecipient(address to) {
    require(to != address(0x0), "INVALID_ADDRESS");
    _;
  }

  modifier isAuthorizedToMint() {
    require(authorizedToMint[msg.sender] == true, "UNAUTHORIZED_TO_MINT");
    _;
  }

  /**
   * @notice Initializes the smart contract.
   * @dev This function sets the initial values of the state variables and creates a SWYCH/WBNB pair. Emits a `Transfer` event.
   * @param _dexRouter The DEX router that is used with token operations.
   * @param _wbnb The address of the WBNB token.
   * @param _autoLiquidityReceiver The wallet address of the receiver of auto-liquidity.
   * @param _treasury The treasury wallet address.
   */
  function initialize(
    address _dexRouter,
    address _wbnb,
    address _autoLiquidityReceiver,
    address _treasury
  ) public initializer {
    require(_dexRouter != address(0x0) && _wbnb != address(0x0) && _autoLiquidityReceiver != address(0x0) && _treasury != address(0x0), "INVALID_ADDRESS");
    __Ownable_init();
    __Pausable_init();
    __UUPSUpgradeable_init();

    router = IDEXRouter(_dexRouter);
    WBNB = _wbnb;
    pair = IDEXFactory(router.factory()).createPair(_wbnb, address(this));

    autoLiquidityReceiver = _autoLiquidityReceiver;
    treasury = _treasury;

    setAutomatedMarketMakerPair(pair, true);

    _allowedFragments[address(this)][address(router)] = MAX_UINT256;

    _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
    _totalGons = INITIAL_FRAGMENTS_SUPPLY * ONE_UNIT;

    address _deployer = msg.sender;
    deployer = _deployer;
    _gonBalances[_deployer] = _totalGons;
    gonsPerFragment = _totalGons.div(_totalSupply);

    isFeeExempt[deployer] = true;

    _gonsCollectedFeeThreshold = _totalGons / 1000;
    rewardRate = 1;
    rewardRateDenominator = 10**7;

    negativeFromAthPercent = 7;
    negativeFromAthPercentDenominator = 100;

    // Rebase Disabled by default.
    rebaseEnabled = false;

    // Transaction fees
    buyFee = 0;
    sellFee = 10;
    transferFee = 35;
    feeDenominator = 100;

    coefficientA = 200000;
    minHoldingPermyriadAvailableTradingBalanceApplied = 100;   //1%
    maxHoldingPermyriadAvailableTradingBalanceApplied = 1000;  //10%

    // Fee split
    autoLiquidityFeePercent = 0;
    treasuryFeePercent = 100;
    burnFeePercent = 0;

    // Available Trading Balance
    tradingBalanceDenominator = 10000;
    athPriceDeltaPermille = 10;
    rewardFrequency = 30 minutes;

    emit Transfer(address(0x0), deployer, _totalSupply);
  }

  function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

  /**
   * @notice Gets the current version of the smart contract.
   * @return The version of the smart contract.
   */
  function getVersion() external pure returns (string memory) {
    return "1.0";
  }

  /**
   * @notice Transfers the specified amount of tokens from a function caller (msg.sender) to a desired wallet address.
   * @dev The function checks if the `to` address is valid and if the smart contract is not paused.
   * @param to The receiver wallet address.
   * @param value The amount of tokens to transfer.
   * @return True, if the operation was successful, else - false.
   */
  function transfer(address to, uint256 value) external override validRecipient(to) whenNotPaused returns (bool) {
    _transferFrom(msg.sender, to, value);
    return true;
  }

  /**
   * @notice Transfers the specified amount of tokens from one wallet address to another.
   * @dev The function checks if the `to` address is valid, if the smart contract is not paused, and the allowance of the sender.
   * @param from The sender wallet address.
   * @param to The receiver wallet address.
   * @param value The amount of tokens to transfer.
   * @return True, if the operation was successful, else - false.
   */
  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external override validRecipient(to) whenNotPaused returns (bool) {
    uint256 currentAllowance = allowance(from, msg.sender);
    if (currentAllowance != MAX_UINT256) {
      _allowedFragments[from][msg.sender] = currentAllowance.sub(value, "ERC20: insufficient allowance");
    }
    _transferFrom(from, to, value);
    return true;
  }

  /**
   * @notice Decreases the allowance of a spender.
   * @dev Emits an `Approval` event.
   * @param spender The wallet address to decrease the allowance of.
   * @param subtractedValue The amount to decrease the allowance by.
   * @return True, if the operation was successful, else - false.
   */
  function decreaseAllowance(address spender, uint256 subtractedValue) external whenNotPaused returns (bool) {
    uint256 oldValue = _allowedFragments[msg.sender][spender];
    uint256 newValue;
    if (subtractedValue >= oldValue) {
      newValue = 0;
      _allowedFragments[msg.sender][spender] = newValue;
    } else {
      newValue = oldValue.sub(subtractedValue);
      _allowedFragments[msg.sender][spender] = newValue;
    }
    emit Approval(msg.sender, spender, newValue);
    return true;
  }

  /**
   * @notice Increases the allowance of a spender.
   * @dev Emits an `Approval` event.
   * @param spender The wallet address to increase the allowance of.
   * @param addedValue The amount to increase the allowance by.
   * @return True, if the operation was successful, else - false.
   */
  function increaseAllowance(address spender, uint256 addedValue) external whenNotPaused returns (bool) {
    uint256 oldValue = _allowedFragments[msg.sender][spender];
    uint256 newValue = oldValue.add(addedValue);
    _allowedFragments[msg.sender][spender] = newValue;
    emit Approval(msg.sender, spender, newValue);
    return true;
  }

  /**
   * @notice Approves a wallet address to spend funds of the sender.
   * @dev Emits an `Approval` event. Checks if the smart contract is not paused.
   * @param spender The wallet address to approve.
   * @param value The amount of funds to allow the spender to spend.
   * @return True, if the operation was successful, else - false.
   */
  function approve(address spender, uint256 value) public override whenNotPaused returns (bool) {
    _allowedFragments[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  /**
   * @notice The smart contract launch routine.
   * @dev Is only available to be called by the contract owner. Emits a `Launched` event.
   */
  function launch() external onlyOwner {
    require(launched == false, "ALREADY_LAUNCHED");
    require(balanceOf(pair) > 0, "LIQUIDITY_NOT_ADDED");
    require(IERC20(WBNB).allowance(autoLiquidityReceiver, address(this)) > 0, "INSUFFICIENT_WBNB_ALLOWANCE_FROM_LIQUIDITY_RECEIVER");

    autoReward = true;
    swapBackEnabled = true;

    availableTradingBalanceEnabled = true;
    transferFeeEnabled = true;
    priceEnabled = true;

    uint256 currentTime = block.timestamp;
    lastRewardTime = currentTime;
    launched = true;
    emit Launched(currentTime);
  }

  /**
   * @notice Sets the `athPriceDeltaPermille` value.
   * @dev Is only available to be called by the contract owner.
   * @param permille The new value to set.
   */
  function setAthDeltaPermille(uint256 permille) external onlyOwner {
    require(permille > 0 && permille < 1000, "INVALID_PERMILLE");
    athPriceDeltaPermille = permille;
    emit SetAthDeltaPerMille(permille);
  }

  /**
   * @notice The trigger to run reward or rebound routines.
   */
  function reward() external whenNotPaused {
    bool canReward = block.timestamp >= (lastRewardTime + rewardFrequency);
    require(canReward, "REWARD_TOO_SOON");
    _reward();
  }

  /**
   * @notice Collect all fees, remaining WBNB of the smart contract, and sends them to the treasury.
   * @dev Is only available to be called by the contract owner. Emits a `WithdrawFeesToTreasury` event.
   */
  function withdrawFeesToTreasury() external swapping onlyOwner {
    uint256 amountToSwap = balanceOf(address(this));
    IDEXRouter _router = router;
    address _treasury = treasury;
    address _wbnb = WBNB;

    if (amountToSwap > 0) {
      address[] memory path = new address[](2);
      path[0] = address(this);
      path[1] = _wbnb;

      if (allowance(address(this), address(_router)) < amountToSwap) {
        approve(address(_router), type(uint256).max);
      }

      uint256 beforeTreasuryBalance = IERC20(_wbnb).balanceOf(_treasury);
      router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amountToSwap, 0, path, _treasury, block.timestamp);
      emit WithdrawFeesToTreasury(IERC20(_wbnb).balanceOf(_treasury).sub(beforeTreasuryBalance));
    }
  }

  /* ========== FUNCTIONS FOR OWNER ========== */

  /**
   * @notice Sets the authorization to mint for a specific address.
   */
  function setAuthorizedToMint(address account, bool flag) external onlyOwner {
    authorizedToMint[account] = flag;
  }

  /**
   * @notice Sets the blocked status on blocked DEX Pair contract address.
   * @dev Is only available to be called by the contract owner. Emits a `SetBlockedPair` event.
   * @param dexPair The address of the DEX pair.
   * @param flag The boolean flag to block/unblock the DEX pair.
   */
  function setBlockedPair(address dexPair, bool flag) external onlyOwner {
    require(isContract(dexPair), "NOT_A_CONTRACT");
    blockedPairs[dexPair] = flag;
    emit SetBlockedPair(dexPair, flag);
  }

  /**
   * @notice Sets the flag to enable/disable the reward features.
   * @param rebaseEnabled_ The boolean flag to enable/disable the rebase feature.
   * @param reboundEnabled_ The boolean flag to enable/disable the rebound feature.
   */
  function setRewardEnabled(bool rebaseEnabled_, bool reboundEnabled_) external onlyOwner {
    rebaseEnabled = rebaseEnabled_;
    reboundEnabled = reboundEnabled_;
    emit SetRewardEnabled(rebaseEnabled_, reboundEnabled_);
  }


  /**
   * @notice Sets the `priceEnabled` flag.
   * @dev Is only available to be called by the contract owner. Emits a `SetPriceEnabled` event.
   * @param flag The new `priceEnabled` value to set.
   */
  function setPriceEnabled(bool flag) external onlyOwner {
    priceEnabled = flag;
    emit SetPriceEnabled(flag);
  }

  /**
   * @notice Sets the `rewardFrequency`.
   * @dev Is only available to be called by the contract owner. Emits a `SetRewardFrequency` event.
   * @param valueInSeconds The new `rewardFrequency` value to set.
   */
  function setRewardFrequency(uint256 valueInSeconds) external onlyOwner {
    require(valueInSeconds <= 1 days && valueInSeconds > 0, "INVALID_REWARD_FREQUENCY");
    rewardFrequency = valueInSeconds;
    emit SetRewardFrequency(valueInSeconds);
  }

  /**
   * @notice Sets the `autoReward` flag.
   * @dev Is only available to be called by the contract owner. Emits a `SetAutoReward` event.
   * @param flag The new `autoReward` flag to set.
   */
  function setAutoReward(bool flag) external onlyOwner {
    autoReward = flag;
    emit SetAutoReward(flag);
  }

  /**
   * @notice Sets the `availableTradingBalanceEnabled` flag.
   * @dev Is only available to be called by the contract owner. Emits a `SetAvailableTradingBalanceEnabled` event.
   * @param flag The new `availableTradingBalanceEnabled` value.
   */
  function setAvailableTradingBalanceEnabled(bool flag) external onlyOwner {
    availableTradingBalanceEnabled = flag;
    emit SetAvailableTradingBalanceEnabled(flag);
  }

  /**
   * @notice Adds or removes a wallet address from a list of wallet addresses that are exempted from a available trading balance checks.
   * @dev Is only available to be called by the contract owner. Emits a `SetNoCheckAvailableTradingBalance` event.
   * @param _address The wallet address to change the status of.
   * @param flag True, to add to the exemption list, else - false.
   */
  function setNoCheckAvailableTradingBalance(address _address, bool flag) external onlyOwner {
    _noCheckAvailableTradingBalance[_address] = flag;
    emit SetNoCheckAvailableTradingBalance(_address, flag);
  }

  /**
   * @notice Sets the `transferFeeEnabled` flag which enables or disables fees on transfers.
   * @dev Is only available to be called by the contract owner. Emits a `SetTransferFeeEnabled` event.
   * @param flag True, to enable fees, else - false.
   */
  function setTransferFeeEnabled(bool flag) external onlyOwner {
    transferFeeEnabled = flag;
    emit SetTransferFeeEnabled(flag);
  }

  /**
   * @notice Sets the `swapBackEnabled` flag which enables or disables swapbacks transfers.
   * @dev Is only available to be called by the contract owner. Emits a `SetSwapBackEnabled` event.
   * @param flag True, to enable swapbacks, else - false.
   */
  function setSwapBackEnabled(bool flag) external onlyOwner {
    swapBackEnabled = flag;
    emit SetSwapBackEnabled(flag);
  }

  /**
   * @notice Sets the `_gonsCollectedFeeThreshold` threshold.
   * @dev If balance of the contract surpasses the threshold, a swapback will be triggered. Is only available to be called by the contract owner. Emits a `SetCollectedFeeThreshold` event.
   * @param amount The new threshold value.
   */
  function setCollectedFeeThreshold(uint256 amount) external onlyOwner {
    _gonsCollectedFeeThreshold = amount.mul(gonsPerFragment);
    emit SetCollectedFeeThreshold(amount);
  }

  /**
   * @notice Sets the values of the equation used to calculate trading balance factors.
   * @dev The equation is as follows: y = a/x. Is only available to be called by the contract owner. Checks the coefficients before settings them. Emits a `SetAvailableTradingBalanceCoefficients` event.
   * @param _coefficientA The new value of the `a` coefficient.
   * @param denominator The new value of the equation coefficient denominator.
   */
  function setAvailableTradingBalanceCoefficients(uint256 _coefficientA, uint256 denominator) external onlyOwner {
    require(denominator > 0 && _coefficientA > 0, "INVALID_COEFFICIENTS");
    coefficientA = _coefficientA;
    tradingBalanceDenominator = denominator;

    emit SetAvailableTradingBalanceCoefficients(_coefficientA, denominator);
  }

  /**
   * @notice Sets the `minHoldingPermyriadAvailableTradingBalanceApplied` and `maxHoldingPermyriadAvailableTradingBalanceApplied` values.
   * @dev Sets set the min and max permyriad that could be applied when calculating the available trading balance factor to avoid math overflow. The value is the permyriad of a holder's balance comparing to the balance of liquidity pool. Is only available to be called by the contract owner. Emits a `SetRangeHoldingPermyriadAvailableTradingBalanceApplied` event.
   * @param minHoldingPermyriadAvailableTradingBalanceApplied_ The new value of the `minHoldingPermyriadAvailableTradingBalanceApplied` value.
   * @param maxHoldingPermyriadAvailableTradingBalanceApplied_ The new value of the `maxHoldingPermyriadAvailableTradingBalanceApplied` value.
   */
  function setRangeHoldingPermyriadAvailableTradingBalanceApplied(uint256 minHoldingPermyriadAvailableTradingBalanceApplied_, uint256 maxHoldingPermyriadAvailableTradingBalanceApplied_) external onlyOwner {
    require(minHoldingPermyriadAvailableTradingBalanceApplied_ > 0 && minHoldingPermyriadAvailableTradingBalanceApplied_ <= 10000, "INVALID_PERMYRIAD");
    require(maxHoldingPermyriadAvailableTradingBalanceApplied_ > 0 && maxHoldingPermyriadAvailableTradingBalanceApplied_ <= 10000, "INVALID_PERMYRIAD");
    require(maxHoldingPermyriadAvailableTradingBalanceApplied_ >= minHoldingPermyriadAvailableTradingBalanceApplied_, "INVALID_RANGE");
    minHoldingPermyriadAvailableTradingBalanceApplied = minHoldingPermyriadAvailableTradingBalanceApplied_;
    maxHoldingPermyriadAvailableTradingBalanceApplied = maxHoldingPermyriadAvailableTradingBalanceApplied_;
    emit SetRangeHoldingPermyriadAvailableTradingBalanceApplied(minHoldingPermyriadAvailableTradingBalanceApplied_, maxHoldingPermyriadAvailableTradingBalanceApplied_);
  }

  /**
   * @notice Sets the `negativeFromAthPercent` value and its denominator.
   * @dev The values show how much should the inflation increase before triggering a rebound routine. Is only available to be called by the contract owner. Emits a `SetReboundFromAth` event.
   * @param percent The new percentage value to set.
   * @param denominator The new denominator value to set.
   */
  function setReboundTriggerFromAth(uint256 percent, uint256 denominator) external onlyOwner {
    require(percent > 0 && denominator > 0 && percent <= denominator, "INVALID_VALUES");
    negativeFromAthPercent = percent;
    negativeFromAthPercentDenominator = denominator;
    emit SetReboundFromAth(percent, denominator);
  }

  /**
   * @notice Sets the `rewardRate` value and its denominator.
   * @dev The values are used with the reward mechanism. Is only available to be called by the contract owner. Emits a `SetRewardRate` event.
   * @param rate The new rate value to set.
   * @param denominator The new denominator value to set.
   */
  function setRewardRate(uint256 rate, uint256 denominator) external onlyOwner {
    require(rate > 0 && denominator > 0 && rate <= denominator, "INVALID_VALUES");
    
    uint256 supply = _totalSupply;
    // check overflow
    require(supply.mul(denominator.add(rate)).div(denominator) > supply, "INVALID_PARAMS");

    rewardRate = rate;
    rewardRateDenominator = denominator;

    emit SetRewardRate(rate, denominator);
  }

  /**
   * @notice Sets the new treasury wallet address.
   * @dev Is only available to be called by the contract owner. Emits a `SetTreasuryWallet` event.
   * @param wallet The treasury wallet address to set.
   */
  function setTreasuryWallet(address wallet) external onlyOwner {
    require(wallet != address(0x0), "INVALID_ADDRESS");
    treasury = wallet;
    emit SetTreasuryWallet(wallet);
  }

  /**
   * @notice Sets the new auto-liquidity receiver wallet address.
   * @dev Is only available to be called by the contract owner. Emits a `SetAutoLiquidityReceiver` event.
   * @param wallet The wallet address of the receiver.
   */
  function setAutoLiquidityReceiver(address wallet) external onlyOwner {
    require(wallet != address(0x0), "INVALID_ADDRESS");
    autoLiquidityReceiver = wallet;
    emit SetAutoLiquidityReceiver(wallet);
  }

  /**
   * @notice Adds or removes wallet addresses from the list of addresses that are exempted from fees.
   * @dev Is only available to be called by the contract owner. Emits a `SetFeeExemptAddress` event.
   * @param address_ The wallet address to add or remove from the fee exemption list.
   * @param flag True, to add the wallet address to the list, false - to remove it from the list.
   */
  function setFeeExemptAddress(address address_, bool flag) external onlyOwner {
    require(address_ != address(0x0), "INVALID_ADDRESS");
    isFeeExempt[address_] = flag;
    emit SetFeeExemptAddress(address_, flag);
  }

  /**
   * @notice Sets the address of the SWYCH/WBNB pair.
   * @dev Is only available to be called by the contract owner. Emits a `SetBackingLPToken` event.
   * @param lpAddress The new address of the SWYCH/WBNB pair to set.
   */
  function setBackingLPToken(address lpAddress) external onlyOwner {
    require(lpAddress != address(0x0), "INVALID_ADDRESS");
    pair = lpAddress;
    emit SetBackingLPToken(lpAddress);
  }

  /**
   * @notice Pauses the smart contract functionality and operations.
   * @dev Is only available to be called by the contract owner. Emits a `Pause` event.
   */
  function pause() external onlyOwner {
    _pause();
    emit Pause();
  }

  /**
   * @notice Resumes the smart contract functionality and operations.
   * @dev Is only available to be called by the contract owner. Emits an `Unpause` event.
   */
  function unpause() external onlyOwner {
    _unpause();
    emit Unpause();
  }

  /**
   * @notice Allows the smart contract owner to withdraw tokens accidentally transferred to the contract.
   * @dev Is only available to be called by the contract owner.
   * @param tokenAddress The address of the token to rescue.
   * @param amount The amount of tokens to withdraw.
   */
  function rescueToken(address tokenAddress, uint256 amount) external onlyOwner {
    require(tokenAddress != address(this), "CANNOT_WITHDRAW_SWYCH");
    IERC20Upgradeable(tokenAddress).safeTransfer(msg.sender, amount);
  }

  /**
   * @notice Sets the fee percentage split between auto-liquidity, treasury, and burn wallets.
   * @dev Is only available to be called by the contract owner. Checks the splits to sum up to 100 percent. Emits a `SetFeeSplit` event.
   * @param autoLiquidityPercent The new auto-liquidity fee percentage of the total fee.
   * @param treasuryPercent The new treasury fee percentage of the total fee.
   * @param burnPercent The new burn fee percentage of the total fee.
   */
  function setFeeSplit(
    uint256 autoLiquidityPercent,
    uint256 treasuryPercent,
    uint256 burnPercent
  ) external onlyOwner {
    require(autoLiquidityPercent + treasuryPercent + burnPercent == 100, "INVALID_FEE_SPLIT");
    autoLiquidityFeePercent = autoLiquidityPercent;
    treasuryFeePercent = treasuryPercent;
    burnFeePercent = burnPercent;

    emit SetFeeSplit(autoLiquidityPercent, treasuryPercent, burnPercent);
  }

  /**
   * @notice Sets new fees.
   * @dev Is only available to be called by the contract owner. Emits a `SetFees` event.
   * @param buyFee_ The new buy fee value.
   * @param sellFee_ The new sell fee value.
   * @param transferFee_ The new transfer fee value.
   */
  function setFees(
    uint256 buyFee_,
    uint256 sellFee_,
    uint256 transferFee_
  ) external onlyOwner {
    require(sellFee_ <= MAX_SELL_FEE, "INVALID_SELL_FEE");
    require(buyFee_ <= MAX_BUY_FEE, "INVALID_BUY_FEE");
    require(transferFee_ <= MAX_TRANSFER_FEE, "INVALID_TRANSFER_FEE");
    buyFee = buyFee_;
    sellFee = sellFee_;
    transferFee = transferFee_;
    emit SetFees(buyFee_, sellFee_, transferFee_);
  }

  /**
   * @notice Gets the balance of a user.
   * @param who The wallet address of the user.
   * @return The balance of the user.
   */
  function balanceOf(address who) public view override returns (uint256) {
    return _gonBalances[who].div(gonsPerFragment);
  }

  /**
   * @notice Checks collected fee threshold amount.
   * @dev If balance of the contract surpasses the threshold, a swapback will be triggered.
   * @return The threshold.
   */
  function checkCollectedFeeThreshold() external view returns (uint256) {
    return _gonsCollectedFeeThreshold.div(gonsPerFragment);
  }

  /**
   * @notice Sets an automated market maker pair.
   * @dev Is only available to be called by the contract owner. Emits a `SetAutomatedMarketMakerPair` event.
   * @param pair_ The pair address to set.
   * @param value_ True to set, false to unset.
   */
  function setAutomatedMarketMakerPair(address pair_, bool value_) public onlyOwner {
    require(automatedMarketMakerPairs[pair_] != value_, "VALUE_ALREADY_SET");

    automatedMarketMakerPairs[pair_] = value_;

    if (value_) {
      require(makerPairs.length + 1 <= MAX_MAKER_PAIRS_COUNT, "MAKER_PAIRS_COUNT_LIMIT");
      makerPairs.push(pair_);
    } else {
      for (uint256 i = 0; i < makerPairs.length; i++) {
        if (makerPairs[i] == pair_) {
          makerPairs[i] = makerPairs[makerPairs.length - 1];
          makerPairs.pop();
          break;
        }
      }
    }

    emit SetAutomatedMarketMakerPair(pair_, value_);
  }

  /**
   * @notice Calculates the trading balance factor.
   * @dev A user can only sell a portion of his total balance within a span of 24h. This factor is used to calculate the max token amount that the holder can sell in a sell period.
   * @param holdingPermyriad The permyriad of a wallet balance over the liquidity pool balance.
   * @return The factor value.
   */
  function calculateAvailableTradingBalanceFactor(uint256 holdingPermyriad) public view returns (uint256) {
    uint256 _maxHoldingPermyriad = maxHoldingPermyriadAvailableTradingBalanceApplied;
    uint256 _minHoldingPermyriad = minHoldingPermyriadAvailableTradingBalanceApplied;
    uint256 permyriadApplied = holdingPermyriad > _maxHoldingPermyriad ? _maxHoldingPermyriad : holdingPermyriad; // MIN(holdingPermyriad, maxHoldingPermyriadAvailableTradingBalanceApplied)
    permyriadApplied = permyriadApplied < _minHoldingPermyriad ? _minHoldingPermyriad : permyriadApplied;         // MAX(permyriadApplied, 100)
    uint256 tradingBalanceFactor = (coefficientA / permyriadApplied);

    if (tradingBalanceFactor > MAX_AVAILABLE_TRADING_BALANCE_FACTOR) {
      return MAX_AVAILABLE_TRADING_BALANCE_FACTOR;
    } else if (tradingBalanceFactor < MIN_AVAILABLE_TRADING_BALANCE_FACTOR) {
      return MIN_AVAILABLE_TRADING_BALANCE_FACTOR;
    }
    return tradingBalanceFactor;
  }

  /**
   * @dev Get available trading balance factor for a wallet address
   */
  function getAvailableTradingBalanceFactor(address _address) public view returns (uint256) {
    uint256 balance = balanceOf(_address);
    uint256 balanceOfPair = balanceOf(pair);
    if (balanceOfPair == 0) {
      return 0;
    }

    uint256 holdingPermyriad = balance.mul(10000).div(balanceOfPair);
    return calculateAvailableTradingBalanceFactor(holdingPermyriad);
  }

  /**
   * @dev Gets the available trading balance amount in gons.
   */
  function _getAvailableTradingBalanceAmountInternalInGons(address _address) internal view returns (uint256) {
    uint256 factor = getAvailableTradingBalanceFactor(_address);
    uint256 bal = _gonBalances[_address];
    return bal.div(tradingBalanceDenominator).mul(factor);
  }

  /**
   * @notice Gets the available trading balance amount.
   * @param _address The wallet address to get the limit of.
   * @return The available trading balance amount.
   */
  function getAvailableTradingBalanceAmount(address _address) public view returns (uint256) {
    return _getAvailableTradingBalanceAmountInternalInGons(_address).div(gonsPerFragment);
  }

  /**
   * @notice Gets the remaining available trading balance amount.
   * @param _address The wallet address to get the available amount of.
   * @return The remaining available trading balance amount.
   */
  function getRemaningAvailableTradingBalanceAmount(address _address) public view returns (uint256) {
    SaleHistory storage history = saleHistories[_address];
    uint256 timeElapsed = block.timestamp.sub(history.lastSoldTimestamp);
    uint256 currentATB = getCurrentAvailableTradingBalanceAmount(_address);
    if (timeElapsed > 10 days) {
      return currentATB;
    }
    return currentATB - history.totalSoldAmountLast24h.div(gonsPerFragment);
  }

  /**
   * @notice Get current ATB.
   * @param _address The wallet address to get the limit of.
   * @return The ATB.
   */
  function getCurrentAvailableTradingBalanceAmount(address _address) public view returns (uint256) {
    SaleHistory storage history = saleHistories[_address];
    uint256 timeElapsed = block.timestamp.sub(history.lastSoldTimestamp);
    if (timeElapsed > 10 days) {
      return _getAvailableTradingBalanceAmountInternalInGons(_address).div(gonsPerFragment);
    }
    uint256 lastATB = history.lastAvailableTradingBalanceAmount;
    return lastATB.div(gonsPerFragment);
  }

  /**
   * @notice Gets the price that will trigger a rebound.
   * @return The price that triggers a rebound.
   */
  function getTriggerReboundPrice() public view returns (uint256) {
    uint256 _athPrice = athPrice;
    return _athPrice.sub(_athPrice.mul(negativeFromAthPercent).div(negativeFromAthPercentDenominator));
  }

  /**
   * @notice Checks the allowance of a `spender`.
   * @param owner_ The owner address.
   * @param spender The spender address.
   * @return The allowance.
   */
  function allowance(address owner_, address spender) public view override returns (uint256) {
    return _allowedFragments[owner_][spender];
  }

  /**
   * @notice Manually updates the AMM pair reserve balance.
   */
  function manualSync() public {
    uint256 length = makerPairs.length;
    for (uint256 i = 0; i < length; i++) {
      IDEXPair(makerPairs[i]).sync();
    }
  }

  /* ========== PUBLIC AND EXTERNAL VIEW FUNCTIONS ========== */

  /**
   * @notice Gets the total supply including burned amount.
   * @return The total supply including burned amount.
   */
  function totalSupplyIncludingBurnAmount() public view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @notice Gets the total supply excluding burned amount.
   * @return The total supply excluding burned amount.
   */
  function totalSupply() public view override returns (uint256) {
    return (_totalGons.sub(_gonBalances[DEAD]).sub(_gonBalances[ZERO])).div(gonsPerFragment);
  }

  /**
   * @notice Gets the name of the current token.
   * @return The name of the token.
   */
  function name() public pure returns (string memory) {
    return _name;
  }

  /**
   * @notice Gets the symbol of the current token.
   * @return The symbol of the token.
   */
  function symbol() public pure returns (string memory) {
    return _symbol;
  }

  /**
   * @dev Returns the number of decimals used to get its user representation.
   * For example, if `decimals` equals `2`, a balance of `505` tokens should
   * be displayed to a user as `5.05` (`505 / 10 ** 2`).
   *
   * Tokens usually opt for a value of 18, imitating the relationship between
   * Ether and Wei. This is the value {ERC20} uses, unless this function is
   * overridden;
   *
   * NOTE: This information is only used for _display_ purposes: it in
   * no way affects any of the arithmetic of the contract, including
   * {IERC20-balanceOf} and {IERC20-transfer}.
   */
  function decimals() public pure returns (uint8) {
    return _decimals;
  }

  /* ========== PRIVATE FUNCTIONS ========== */
  function _transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) private returns (bool) {
    require(launched || sender == deployer, "TOKEN_NOT_LAUNCHED_YET");

    if (blockedPairs[sender] || blockedPairs[recipient]) {
      revert("BLOCKED_DEX_PAIR");
    }

    bool isFullBalanceTransferred = balanceOf(sender) == amount;

    if (_inSwap) {
      return _basicTransfer(sender, recipient, amount);
    }

    uint256 gonAmount = amount.mul(gonsPerFragment);

    uint256 timeElapsed = block.timestamp.sub(transferTimelock[sender]);
    require(timeElapsed > 10 days || isFeeExempt[recipient], "TIMELOCK_ACTIVATED");

    if (availableTradingBalanceEnabled && _isSellTx(recipient) && !_noCheckAvailableTradingBalance[sender]) {
      _checkAvailableTradingBalanceAndUpdateSaleHistory(sender, gonAmount);
    }

    if (_shouldAutoReward(recipient)) {
      _reward();
    }

    if (_shouldSwapBack()) {
      _swapBack();
    }

    uint256 gonAmountToRecipient = _shouldTakeFee(sender, recipient) ? _takeFee(sender, recipient, gonAmount, isFullBalanceTransferred) : gonAmount;
    _gonBalances[sender] = _gonBalances[sender].sub(gonAmount, "ERC20: transfer amount exceeds balance");
    _gonBalances[recipient] = _gonBalances[recipient].add(gonAmountToRecipient);

    _updateATH();

    emit Transfer(sender, recipient, gonAmountToRecipient.div(gonsPerFragment));

    return true;
  }

  function airdrop(address[] calldata recipients, uint256[] calldata amounts) external {
    require(launched == false, "TOKEN_ALREADY_LAUNCHED");
    for (uint32 i; i < recipients.length; i++) {
      _basicTransfer(msg.sender, recipients[i], amounts[i]);
    }
  }

  function _basicTransfer(
    address from,
    address to,
    uint256 amount
  ) private returns (bool) {
    uint256 gonAmount = amount.mul(gonsPerFragment);
    _gonBalances[from] = _gonBalances[from].sub(gonAmount, "ERC20: transfer amount exceeds balance");
    _gonBalances[to] = _gonBalances[to].add(gonAmount);
    emit Transfer(from, to, amount);

    return true;
  }

  /**
   * @notice Internal method that allows to mint new tokens.
   * @param account Address to which to mint the tokens.
   * @param amount The amount of tokens to mint
   */
  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: mint to the zero address");
    uint256 gonsToMint = amount.mul(gonsPerFragment);
    _totalSupply = _totalSupply.add(amount);
    _totalGons = _totalGons.add(gonsToMint);
    _gonBalances[account] += gonsToMint;
    emit Transfer(address(0), account, amount);
  }

  /**
   * @notice Authorized method to mint SWYCH.
   * @param account Address to which to mint the tokens.
   * @param amount The amount of tokens to mint
   */
  function mint(address account, uint256 amount) public isAuthorizedToMint {
    _mint(account, amount);
  }

  /**
   * @dev Internal function to check if transfer amount surpasses the available trading balance amount
   * @param sender address of the sender that execute the transaction
   * @param gonAmount transfer amount
   */
  function _checkAvailableTradingBalanceAndUpdateSaleHistory(address sender, uint256 gonAmount) private {
    SaleHistory storage history = saleHistories[sender];
    uint256 timeElapsed = block.timestamp.sub(history.lastSoldTimestamp);
    if (timeElapsed < 10 days) {
      require(history.totalSoldAmountLast24h.add(gonAmount) <= history.lastAvailableTradingBalanceAmount, "EXCEEDS_AVAILABLE_TRADING_BALANCE");
      history.totalSoldAmountLast24h += gonAmount;
    } else {
      uint256 gonLimitAmount = _getAvailableTradingBalanceAmountInternalInGons(sender);
      require(gonAmount <= gonLimitAmount, "EXCEEDS_AVAILABLE_TRADING_BALANCE");
      history.lastSoldTimestamp = block.timestamp;
      history.lastAvailableTradingBalanceAmount = gonLimitAmount;
      history.totalSoldAmountLast24h = gonAmount;
    }
  }

  /**
   * @dev _swapBack collect fees and swap fees into WBNB
   * A portion of WBNB amount will be added to liquidity, the rest will be transferred to the treasury
   */
  function _swapBack() internal swapping {
    uint256 _autoLiquidityFeePercent = autoLiquidityFeePercent;
    uint256 totalFee = _autoLiquidityFeePercent.add(treasuryFeePercent);
    uint256 balance = _gonBalances[address(this)].div(gonsPerFragment);
    uint256 amountForAutoLiquidity = balance.mul(_autoLiquidityFeePercent).div(totalFee);
    uint256 amountToLiquify = amountForAutoLiquidity.div(2);
    uint256 amountToSwap = balance.sub(amountToLiquify);
    _swapAndLiquidify(totalFee, amountToSwap, amountToLiquify);
  }

  /**
   * @dev _swapAndLiquidify swap fees into WBNB and add liquidity
   * @param totalFee is the total percent of fee for a transaction except burn fee
   * @param amountToSwap is the amount of tokens that will be swapped into WBNB
   * @param amountToLiquify is the amount of tokens will be added liquidity
   */
  function _swapAndLiquidify(
    uint256 totalFee,
    uint256 amountToSwap,
    uint256 amountToLiquify
  ) internal {
    IDEXRouter _router = router;
    address _wbnb = WBNB;
    address _autoLiquidityReceiver = autoLiquidityReceiver;
    uint256 balanceWBNBBefore = IERC20(WBNB).balanceOf(autoLiquidityReceiver);
    uint256 _autoLiquidityFeePercent = autoLiquidityFeePercent;

    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = _wbnb;

    router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amountToSwap, 0, path, _autoLiquidityReceiver, block.timestamp);

    uint256 amountWBNB = IERC20(_wbnb).balanceOf(_autoLiquidityReceiver).sub(balanceWBNBBefore);
    IERC20(_wbnb).transferFrom(_autoLiquidityReceiver, address(this), amountWBNB);

    uint256 totalWBNBFee = totalFee.sub(_autoLiquidityFeePercent.div(2));
    uint256 amountWBNBLiquidity = amountWBNB.mul(_autoLiquidityFeePercent).div(totalWBNBFee).div(2);

    if (IERC20(_wbnb).allowance(address(this), address(_router)) < amountWBNBLiquidity) {
      IERC20(_wbnb).approve(address(_router), type(uint256).max);
    }

    if (allowance(address(this), address(_router)) < amountToLiquify) {
      approve(address(_router), type(uint256).max);
    }

    if (amountToLiquify > 0) {
      _router.addLiquidity(_wbnb, address(this), amountWBNBLiquidity, amountToLiquify, 0, 0, _autoLiquidityReceiver, block.timestamp);
    }

    uint256 amountWBNBTreasury = IERC20(_wbnb).balanceOf(address(this));
    IERC20(_wbnb).transfer(treasury, amountWBNBTreasury);
  }

  /**
   * @dev _takeFee take fees of a transaction
   *
   */
  function _takeFee(
    address sender,
    address recipient,
    uint256 gonAmount,
    bool isFullBalanceTransferred
  ) private returns (uint256) {
    uint256 fee;

    TransactionType txType = _getTransactionType(sender, recipient);
    if (txType == TransactionType.BUY) {
      fee = buyFee;
    } else if (txType == TransactionType.SELL) {
      fee = sellFee;
    } else if (txType == TransactionType.TRANSFER && isFullBalanceTransferred && balanceOf(recipient) == 0) {
      fee = 0;
      transferTimelock[recipient] = block.timestamp;
      return gonAmount;
    } else {
      fee = transferFee;
    }

    uint256 _feeDenominator = feeDenominator;
    uint256 gonsPerFragment_ = gonsPerFragment;
    uint256 feeAmount = gonAmount.div(_feeDenominator).mul(fee);
    // burn tokens
    uint256 burnAmount = feeAmount.div(_feeDenominator).mul(burnFeePercent);
    uint256 liquidityAndTreasuryAmount = feeAmount.sub(burnAmount);

    _gonBalances[DEAD] = _gonBalances[DEAD].add(burnAmount);
    _gonBalances[address(this)] = _gonBalances[address(this)].add(liquidityAndTreasuryAmount);

    emit Transfer(sender, DEAD, burnAmount.div(gonsPerFragment_));
    emit Transfer(sender, address(this), liquidityAndTreasuryAmount.div(gonsPerFragment_));

    return gonAmount.sub(feeAmount);
  }

  function _getTokenPriceInWBNB() private view returns (uint256) {
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = WBNB;
    uint256[] memory amounts = router.getAmountsOut(ONE_UNIT, path);
    return amounts[1];
  }

  /**
   * @dev _isSellTx check if a transaction is a sell transaction by comparing the recipient to the pair address
   */
  function _isSellTx(address recipient) private view returns (bool) {
    return recipient == pair;
  }

  /**
   * @dev _shouldAutoReward checks if the contract should do a reward after a reward frequency period has passed
   */
  function _shouldAutoReward(address recipient) private view returns (bool) {
    return _isSellTx(recipient) && autoReward && !_inSwap && msg.sender != pair && block.timestamp >= (lastRewardTime + rewardFrequency);
  }

  /**
   * @dev _shouldSwapBack check if swap back should be applied to a transaction.
   */
  function _shouldSwapBack() private view returns (bool) {
    return swapBackEnabled && !_inSwap && msg.sender != pair && _gonBalances[address(this)] >= _gonsCollectedFeeThreshold;
  }

  /**
   * @dev _shouldTakeFee check if a transaction should be applied fee or not
   * an address that exists in the fee exempt mapping will be excluded from fee
   */
  function _shouldTakeFee(address from, address to) private view returns (bool) {
    if (isFeeExempt[from] || isFeeExempt[to]) {
      return false;
    }

    return true;
  }

  /**
   * @dev Internal reward method that notifies token contract about a new reward cycle
   * this will trigger either reward or rebound depending on the current inflation level
   * If it detects a significant increase in inflation, it will trigger a rebound to reduce the totalSupply
   * otherwise it would increase the totalSupply
   * After increase/reduce the totalSupply, it executes syncing to update values of the pair's reserve.
   */
  function _reward() private {
    uint256 currentPrice = priceEnabled ? _getTokenPriceInWBNB() : 0;
    RewardType rewardType = RewardType.POSITIVE;
    uint256 _athPrice = athPrice;
    uint256 triggerReboundPrice = getTriggerReboundPrice();

    if (currentPrice != 0 && currentPrice < triggerReboundPrice && lastReboundTriggerAthPrice < _athPrice) {
      rewardType = RewardType.NEGATIVE;
      // make sure only one rebound is triggered when the inflation increases above the set threshold.
    }

    uint256 lastTotalSupply = _totalSupply;
    uint256 _lastRewardTime = lastRewardTime;
    uint256 _rewardFrequency = rewardFrequency;
    uint256 deltaTime = block.timestamp - _lastRewardTime;
    uint256 times = deltaTime.div(_rewardFrequency);
    uint256 tmpTotalSupply = _totalSupply;
    uint256 tmpRewardRate = rewardRate;
    bool rewarded;

    if (rewardType == RewardType.POSITIVE) {
      if (rebaseEnabled == true) {
        for (uint256 i = 0; i < times; i++) {
          tmpTotalSupply = tmpTotalSupply.mul(rewardRateDenominator.add(tmpRewardRate)).div(rewardRateDenominator);
        }
        _totalSupply = tmpTotalSupply; 
        rewarded = true;
      }
    } else {
      // if rebound, trigger reward once
      if (reboundEnabled == true) {
        lastReboundTriggerAthPrice = _athPrice;
        _totalSupply = _estimateReboundSupply();
        rewarded = true;
      }
      
    }

    lastRewardTime = _lastRewardTime.add(times.mul(_rewardFrequency));

    if (rewarded) {
      gonsPerFragment = _totalGons.div(_totalSupply);
      manualSync();
      uint256 epoch = block.timestamp;
      emit LogReward(epoch, rewardType, lastTotalSupply, _totalSupply);
    }
    _updateATH();
  }

  /**
   * @dev _updateATH updates the All-time-high price.
   */
  function _updateATH() private {
    if (priceEnabled) {
      uint256 newPrice = _getTokenPriceInWBNB();
      if (newPrice > athPrice) {
        uint256 lastAthPrice = athPrice;
        athPrice = newPrice;
        emit NewAllTimeHigh(lastAthPrice, newPrice);
      }
    }
  }

  /**
   * @dev _getTransactionType detects if a transaction is a buy or sell/ transfer transaction buy checking if the sender/recipient matches the pair address
   */
  function _getTransactionType(address sender, address recipient) private view returns (TransactionType) {
    address _pair = pair;
    if (_pair == sender) {
      return TransactionType.BUY;
    } else if (_pair == recipient) {
      return TransactionType.SELL;
    }

    return TransactionType.TRANSFER;
  }

  /**
   * @dev Estimate the new supply for a rebound
   */
  function _estimateReboundSupply() private view returns (uint256) {
    if (athPrice == 0) {
      return _totalSupply;
    }

    address token0 = IDEXPair(pair).token0();
    (uint256 reserve0, uint256 reserve1, ) = IDEXPair(pair).getReserves();
    uint256 reserveIn = token0 == address(this) ? reserve0 : reserve1;
    uint256 reserveOut = token0 == WBNB ? reserve0 : reserve1;

    // this is a reverse computation of getAmountOut to find reserveIn
    // https://github.com/pancakeswap/pancake-smart-contracts/blob/d8f55093a43a7e8913f7730cfff3589a46f5c014/projects/exchange-protocol/contracts/libraries/PancakeLibrary.sol#L63
    uint256 expectedAmountOut = athPrice.add(athPrice.mul(athPriceDeltaPermille).div(1000));
    uint256 amountIn = ONE_UNIT;
    uint256 amountInWithFee = amountIn.mul(9975);
    uint256 numerator = amountInWithFee.mul(reserveOut);
    uint256 expectedDenominator = numerator.div(expectedAmountOut);
    // calculate expectedReserveIn to achieve expectedAmountOut
    uint256 expectedReserveIn = expectedDenominator.sub(amountInWithFee).div(10000);
    // reserveIn / _totalSupply  = expectedReserveIn / new totalSupply
    uint256 newTotalSupply = expectedReserveIn.mul(_totalSupply).div(reserveIn);
    return newTotalSupply;
  }

  /**
   * @notice Checks if the address is a contract.
   * @return True if address is contract otherwise false.
   */
  function isContract(address addr) private view returns (bool) {
    uint32 size;
    assembly {
      size := extcodesize(addr)
    }
    return (size > 0);
  }
}