/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

// Sources flattened with hardhat v2.13.0 https://hardhat.org

// File contracts/Brandon.sol

// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

abstract contract Context {
  function _msgSender() internal view virtual returns (address) {
    return msg.sender;
  }

  function _msgData() internal view virtual returns (bytes calldata) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

interface IBEP20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IBEP20Metadata is IBEP20 {
  /**
   * @dev Returns the name of the token.
   */
  function name() external view returns (string memory);

  /**
   * @dev Returns the symbol of the token.
   */
  function symbol() external view returns (string memory);

  /**
   * @dev Returns the decimals places of the token.
   */
  function decimals() external view returns (uint8);
}

contract BEP20 is Context, IBEP20, IBEP20Metadata {
  mapping(address => uint256) internal _balances;

  mapping(address => mapping(address => uint256)) internal _allowances;

  uint256 private _totalSupply;

  string private _name;
  string private _symbol;

  /**
   * @dev Sets the values for {name} and {symbol}.
   *
   * The defaut value of {decimals} is 18. To select a different value for
   * {decimals} you should overload it.
   *
   * All two of these values are immutable: they can only be set once during
   * construction.
   */
  constructor(string memory name_, string memory symbol_) {
    _name = name_;
    _symbol = symbol_;
  }

  /**
   * @dev Returns the name of the token.
   */
  function name() public view virtual override returns (string memory) {
    return _name;
  }

  /**
   * @dev Returns the symbol of the token, usually a shorter version of the
   * name.
   */
  function symbol() public view virtual override returns (string memory) {
    return _symbol;
  }

  /**
   * @dev Returns the number of decimals used to get its user representation.
   * For example, if `decimals` equals `2`, a balance of `505` tokens should
   * be displayed to a user as `5,05` (`505 / 10 ** 2`).
   *
   * Tokens usually opt for a value of 18, imitating the relationship between
   * Ether and Wei. This is the value {BEP20} uses, unless this function is
   * overridden;
   *
   * NOTE: This information is only used for _display_ purposes: it in
   * no way affects any of the arithmetic of the contract, including
   * {IBEP20-balanceOf} and {IBEP20-transfer}.
   */
  function decimals() public view virtual override returns (uint8) {
    return 18;
  }

  /**
   * @dev See {IBEP20-totalSupply}.
   */
  function totalSupply() public view virtual override returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev See {IBEP20-balanceOf}.
   */
  function balanceOf(address account) public view virtual override returns (uint256) {
    return _balances[account];
  }

  /**
   * @dev See {IBEP20-transfer}.
   *
   * Requirements:
   *
   * - `recipient` cannot be the zero address.
   * - the caller must have a balance of at least `amount`.
   */
  function transfer(
    address recipient,
    uint256 amount
  ) public virtual override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  /**
   * @dev See {IBEP20-allowance}.
   */
  function allowance(
    address owner,
    address spender
  ) public view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev See {IBEP20-approve}.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function approve(
    address spender,
    uint256 amount
  ) public virtual override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  /**
   * @dev See {IBEP20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {BEP20}.
   *
   * Requirements:
   *
   * - `sender` and `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   * - the caller must have allowance for ``sender``'s tokens of at least
   * `amount`.
   */
  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public virtual override returns (bool) {
    _transfer(sender, recipient, amount);

    uint256 currentAllowance = _allowances[sender][_msgSender()];
    require(currentAllowance >= amount, 'BEP20: transfer amount exceeds allowance');
    _approve(sender, _msgSender(), currentAllowance - amount);

    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {IBEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function increaseAllowance(
    address spender,
    uint256 addedValue
  ) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {IBEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  ) public virtual returns (bool) {
    uint256 currentAllowance = _allowances[_msgSender()][spender];
    require(currentAllowance >= subtractedValue, 'BEP20: decreased allowance below zero');
    _approve(_msgSender(), spender, currentAllowance - subtractedValue);

    return true;
  }

  /**
   * @dev Moves tokens `amount` from `sender` to `recipient`.
   *
   * This is internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `sender` cannot be the zero address.
   * - `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   */
  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
    require(sender != address(0), 'BEP20: transfer from the zero address');
    require(recipient != address(0), 'BEP20: transfer to the zero address');

    uint256 senderBalance = _balances[sender];
    require(senderBalance >= amount, 'BEP20: transfer amount exceeds balance');
    _balances[sender] = senderBalance - amount;
    _balances[recipient] += amount;

    emit Transfer(sender, recipient, amount);
  }

  /** This function will be used to generate the total supply
   * while deploying the contract
   *
   * This function can never be called again after deploying contract
   */
  function _tokengeneration(address account, uint256 amount) internal virtual {
    _totalSupply = amount;
    _balances[account] = amount;
    emit Transfer(address(0), account, amount);
  }

  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
   *
   * This internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
  function _approve(address owner, address spender, uint256 amount) internal virtual {
    require(owner != address(0), 'BEP20: approve from the zero address');
    require(spender != address(0), 'BEP20: approve to the zero address');

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }
}

library Address {
  function sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, 'Address: insufficient balance');

    (bool success, ) = recipient.call{ value: amount }('');
    require(success, 'Address: unable to send value, recipient may have reverted');
  }
}

abstract contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor() {
    _setOwner(_msgSender());
  }

  function owner() public view virtual returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(owner() == _msgSender(), 'Ownable: caller is not the owner');
    _;
  }

  function renounceOwnership() public virtual onlyOwner {
    _setOwner(address(0));
  }

  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), 'Ownable: new owner is the zero address');
    _setOwner(newOwner);
  }

  function _setOwner(address newOwner) private {
    address oldOwner = _owner;
    _owner = newOwner;
    emit OwnershipTransferred(oldOwner, newOwner);
  }
}

interface IFactory {
  function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IRouter {
  function factory() external pure returns (address);

  function WETH() external pure returns (address);

  function addLiquidityETH(
    address token,
    uint256 amountTokenDesired,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

  function swapExactTokensForETHSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;
}

interface IPancakePair {
  event Approval(address indexed owner, address indexed spender, uint value);
  event Transfer(address indexed from, address indexed to, uint value);

  function name() external pure returns (string memory);

  function symbol() external pure returns (string memory);

  function decimals() external pure returns (uint8);

  function totalSupply() external view returns (uint);

  function balanceOf(address owner) external view returns (uint);

  function allowance(address owner, address spender) external view returns (uint);

  function approve(address spender, uint value) external returns (bool);

  function transfer(address to, uint value) external returns (bool);

  function transferFrom(address from, address to, uint value) external returns (bool);

  function DOMAIN_SEPARATOR() external view returns (bytes32);

  function PERMIT_TYPEHASH() external pure returns (bytes32);

  function nonces(address owner) external view returns (uint);

  function permit(
    address owner,
    address spender,
    uint value,
    uint deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;

  event Mint(address indexed sender, uint amount0, uint amount1);
  event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
  event Swap(
    address indexed sender,
    uint amount0In,
    uint amount1In,
    uint amount0Out,
    uint amount1Out,
    address indexed to
  );
  event Sync(uint112 reserve0, uint112 reserve1);

  function MINIMUM_LIQUIDITY() external pure returns (uint);

  function factory() external view returns (address);

  function token0() external view returns (address);

  function token1() external view returns (address);

  function getReserves()
    external
    view
    returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

  function price0CumulativeLast() external view returns (uint);

  function price1CumulativeLast() external view returns (uint);

  function kLast() external view returns (uint);

  function mint(address to) external returns (uint liquidity);

  function burn(address to) external returns (uint amount0, uint amount1);

  function swap(
    uint amount0Out,
    uint amount1Out,
    address to,
    bytes calldata data
  ) external;

  function skim(address to) external;

  function sync() external;

  function initialize(address, address) external;
}

contract BTIX is BEP20, Ownable {
  using Address for address payable;

  IRouter public router;
  address public pair;

  bool private _interlock = false;
  bool public providingLiquidity = false;
  bool public tradingEnabled = false;

  uint256 public tokenLiquidityThreshold = (1_000_000_000 * 10 ** 18) / 100; // 1% of total supply

  // Launching
  uint256 public genesisBlock;
  uint256 private deadline = 3;
  uint256 private launchtax = 99;

  // Addresses
  address public constant DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;
  address private _marketingWallet = 0x75155138284131Be4f2C04f857f23739b686F25B;
  address private _developmentWallet = 0xd23a59F2Aa38c132e0134559176b81F3F19E77b3;

  struct Taxes {
    uint256 marketing;
    uint256 liquidity;
    uint256 development;
  }

  Taxes public taxes = Taxes({ marketing: 1, liquidity: 0, development: 1 });
  Taxes public sellTaxes = Taxes({ marketing: 1, liquidity: 0, development: 3 });

  mapping(address => bool) public exemptFee;

  // Anti Dump
  mapping(address => uint256) private _lastSell;

  modifier lockTheSwap() {
    if (!_interlock) {
      _interlock = true;
      _;
      _interlock = false;
    }
  }

  constructor() BEP20('BTIX', 'BTIX') {
    _tokengeneration(msg.sender, 1_000_000_000 * 10 ** decimals());
    exemptFee[msg.sender] = true;

    IRouter _router = IRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    // Create a pancake pair for this new token
    address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());

    router = _router;
    pair = _pair;
    exemptFee[address(this)] = true;
    exemptFee[_marketingWallet] = true;
    exemptFee[_developmentWallet] = true;
    exemptFee[msg.sender] = true;
    exemptFee[DEAD_WALLET] = true;
  }

  function approve(address spender, uint256 amount) public override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public override returns (bool) {
    _transfer(sender, recipient, amount);

    uint256 currentAllowance = _allowances[sender][_msgSender()];
    require(currentAllowance >= amount, 'BEP20: transfer amount exceeds allowance');
    _approve(sender, _msgSender(), currentAllowance - amount);

    return true;
  }

  function increaseAllowance(
    address spender,
    uint256 addedValue
  ) public override returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
    return true;
  }

  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  ) public override returns (bool) {
    uint256 currentAllowance = _allowances[_msgSender()][spender];
    require(currentAllowance >= subtractedValue, 'BEP20: decreased allowance below zero');
    _approve(_msgSender(), spender, currentAllowance - subtractedValue);

    return true;
  }

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    _transfer(msg.sender, recipient, amount);
    return true;
  }

  function _transfer(
    address sender,
    address recipient,
    uint256 amount
  ) internal override {
    require(amount > 0, 'Transfer amount must be greater than zero');

    if (!exemptFee[sender] && !exemptFee[recipient]) {
      require(tradingEnabled, 'Trading not enabled');
    }

    uint256 feeswap;
    uint256 feesum;
    uint256 fee;
    Taxes memory currentTaxes;

    bool useLaunchFee = !exemptFee[sender] &&
      !exemptFee[recipient] &&
      block.number < genesisBlock + deadline;

    // Set fee to zero if fees in contract are handled or exempted
    if (_interlock || exemptFee[sender] || exemptFee[recipient]) {
      fee = 0;
    } else if (recipient == pair && !useLaunchFee) {
      feeswap = sellTaxes.liquidity + sellTaxes.marketing + sellTaxes.development;
      feesum = feeswap;
      currentTaxes = sellTaxes;
    } else if (!useLaunchFee) {
      feeswap = taxes.liquidity + taxes.marketing + taxes.development;
      feesum = feeswap;
      currentTaxes = taxes;
    } else if (useLaunchFee) {
      feeswap = launchtax;
      feesum = launchtax;
    }

    fee = (amount * feesum) / 100;

    // Send fees if threshold has been reached
    // Don't do this on buys, swaps etc
    if (providingLiquidity && sender != pair) sendFees(feeswap, currentTaxes);

    // Rest to recipient
    super._transfer(sender, recipient, amount - fee);
    if (fee > 0) {
      // Send the fee to the contract
      if (feeswap > 0) {
        uint256 feeAmount = (amount * feeswap) / 100;
        super._transfer(sender, address(this), feeAmount);
      }
    }
  }

  function sendFees(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
    if (feeswap == 0) {
      return;
    }

    uint256 contractBalance = balanceOf(address(this));
    if (contractBalance >= tokenLiquidityThreshold) {
      if (tokenLiquidityThreshold > 1) {
        contractBalance = tokenLiquidityThreshold;
      }

      // Split the contract balance into halves
      uint256 denominator = feeswap * 2;
      uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
        denominator;
      uint256 toSwap = contractBalance - tokensToAddLiquidityWith;

      uint256 initialBalance = address(this).balance;

      swapTokensForETH(toSwap);

      uint256 deltaBalance = address(this).balance - initialBalance;
      uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
      uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;

      if (ethToAddLiquidityWith > 0) {
        // Add liquidity to PancakeSwap
        addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
      }

      uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
      if (marketingAmt > 0) {
        payable(_marketingWallet).sendValue(marketingAmt);
      }

      uint256 developmentAmt = unitBalance * 2 * swapTaxes.development;
      if (developmentAmt > 0) {
        payable(_developmentWallet).sendValue(developmentAmt);
      }
    }
  }

  function swapTokensForETH(uint256 tokenAmount) private {
    // Generate the pancake pair path of (token/weth)
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = router.WETH();

    _approve(address(this), address(router), tokenAmount);

    // Do the swap
    router.swapExactTokensForETHSupportingFeeOnTransferTokens(
      tokenAmount,
      0,
      path,
      address(this),
      block.timestamp
    );
  }

  function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
    // Approve token transfer to cover all possible scenarios
    _approve(address(this), address(router), tokenAmount);

    // Add the liquidity
    router.addLiquidityETH{ value: ethAmount }(
      address(this),
      tokenAmount,
      0, // Slippage is unavoidable
      0, // Slippage is unavoidable
      DEAD_WALLET,
      block.timestamp
    );
  }

  function updateLiquidityProvide(bool state) external onlyOwner {
    // Update liquidity providing state
    providingLiquidity = state;
  }

  function updateLiquidityTreshhold(uint256 newAmount) external onlyOwner {
    // Update the treshhold (with limitations)
    require(
      newAmount <= totalSupply() / 100,
      'Swap threshold amount should be lower or equal to 1% of tokens'
    );
    tokenLiquidityThreshold = newAmount * 10 ** decimals();
  }

  function setBuyTaxes(
    uint256 _marketing,
    uint256 _liquidity,
    uint256 _development
  ) external onlyOwner {
    taxes = Taxes(_marketing, _liquidity, _development);
    require(
      (_marketing + _liquidity + _development) <= 7,
      'Must keep fees at 7% or less'
    );
  }

  function setSellTaxes(
    uint256 _marketing,
    uint256 _liquidity,
    uint256 _development
  ) external onlyOwner {
    sellTaxes = Taxes(_marketing, _liquidity, _development);
    require(
      (_marketing + _liquidity + _development) <= 7,
      'Must keep fees at 7% or less'
    );
  }

  // Once trade enabled, can't disable
  function enableTrading() external onlyOwner {
    require(!tradingEnabled, 'Cannot re-enable trading');
    tradingEnabled = true;
    providingLiquidity = true;
    genesisBlock = block.number;
  }

  function updateDeadline(uint256 _deadline) external onlyOwner {
    require(!tradingEnabled, "Can't change when trading has started");
    require(_deadline < 5, 'Deadline should be less than 5 Blocks');
    deadline = _deadline;
  }

  function updateMarketingWallet(address newWallet) external onlyOwner {
    require(newWallet != address(0), 'Fee Address cannot be zero address');
    _marketingWallet = newWallet;
  }

  function updateDevelopmentWallet(address newWallet) external onlyOwner {
    require(newWallet != address(0), 'Fee Address cannot be zero address');
    _developmentWallet = newWallet;
  }

  function updateExemptFee(address _address, bool state) external onlyOwner {
    exemptFee[_address] = state;
  }

  function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
    for (uint256 i = 0; i < accounts.length; i++) {
      exemptFee[accounts[i]] = state;
    }
  }

  function rescueBNB(uint256 weiAmount) external onlyOwner {
    payable(owner()).transfer(weiAmount);
  }

  function rescueBEP20(address tokenAdd, uint256 amount) external onlyOwner {
    require(
      tokenAdd != address(this),
      "Owner can't claim contract's balance of its own tokens"
    );
    IBEP20(tokenAdd).transfer(owner(), amount);
  }

  // fallbacks
  receive() external payable {}
}