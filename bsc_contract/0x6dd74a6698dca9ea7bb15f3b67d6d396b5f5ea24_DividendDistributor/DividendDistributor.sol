/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

library SafeMath {
    /* FUNCTION */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
}

library Address {
    /* FUNCTION */
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
}

abstract contract Context {
    /* FUNCTION */
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgValue() internal view virtual returns (uint256) {
        return msg.value;
    }
}

abstract contract Ownable is Context {
    /* DATA */
    address private _owner;

    /* MAPPING */ 
    mapping(address => bool) internal authorizations;

    /* MODIFIER */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    modifier authorized() {
        _checkAuthorization();
        _;
    }
    
    /* CONSTRUCTOR */
    constructor() {
        _transferOwnership(_msgSender());
        authorizations[_msgSender()] = true;
    }

    /* EVENT */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /* FUNCTION */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function _checkAuthorization() internal view virtual {
        require(isAuthorized(_msgSender()), "Ownable: caller is not an authorized account");
    }

    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    function authorize(address adr) public onlyOwner {
        authorizations[adr] = true;
    }

    function unauthorize(address adr) public onlyOwner {
        authorizations[adr] = false;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IPair {
    function sync() external;
}

interface IRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidityETHSupportingFeeOnTransferTokens(
      address token,
      uint liquidity,
      uint amountTokenMin,
      uint amountETHMin,
      address to,
      uint deadline
    ) external returns (uint amountETH);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IERC20Extended is IERC20 {
    /* FUNCTION */
    function name() external view returns (string memory);
    
    function symbol() external view returns (string memory);
    
    function decimals() external view returns (uint8);
}

interface IDividendDistributor {
    /* FUNCTION */ 
    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;

    function setShare(address shareholder, uint256 amount) external;

    function deposit() external payable;

    function process(uint256 gas) external;
}

contract DividendDistributor is IDividendDistributor, Ownable {
    
    /* LIBRARY */
    using SafeMath for uint256;

    /* DATA */
    IERC20Extended public rewardToken;
    IRouter public router;
    
    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }
    
    bool public initialized = false;

    uint256 public currentIndex = 0;
    uint256 public minPeriod = 0;
    uint256 public minDistribution = 0;
    uint256 public totalShares = 0;
    uint256 public totalDividends = 0;
    uint256 public totalDistributed = 0;
    uint256 public dividendsPerShare = 0;
    
    uint256 public immutable dividendsPerShareAccuracyFactor = 10**36;

    address public token;
    address[] public shareholders;
    
    /* MAPPING */
    mapping(address => uint256) public shareholderIndexes;
    mapping(address => uint256) public shareholderClaims;
    mapping(address => Share) public shares;

    /* MODIFIER */
    modifier initializer() {
        require(!initialized);
        _;
        initialized = true;
    }

    modifier onlyToken() {
        require(_msgSender() == token || _msgSender() == owner());
        _;
    }

    /* CONSTRUCTOR */
    constructor(address rewardTokenAddress, address routerAddress) {
        token = _msgSender();
        rewardToken = IERC20Extended(rewardTokenAddress);
        router = IRouter(routerAddress);

        minPeriod = 1 hours;
        minDistribution = 1 * (10**rewardToken.decimals());
    }

    /* EVENT */
    event ChangeRouter(address caller, address prevRouter, address newRouter);

    /* FUNCTION */
    function changeRouter(IRouter routerAddress) external authorized {
        address prevRouter = address(router);
        router = routerAddress;
        emit ChangeRouter(_msgSender(), prevRouter, address(router));
    }

    function unInitialized(bool initialization) external authorized {
        initialized = initialization;
    }

    function setTokenAddress(address token_) external initializer authorized {
        require(token_ != address(0), "Set Token Address: Cannot set token address as null address.");
        token = token_;
    }

    function setDistributionCriteria(uint256 minPeriodLength, uint256 minDistributionAmount) external override authorized {
        minPeriod = minPeriodLength;
        minDistribution = minDistributionAmount;
    }

    function changeRewardToken(IERC20Extended rewardTokenAddress) external authorized {
        rewardToken = rewardTokenAddress;
    }

    function setShare(address shareholder, uint256 amount) external override onlyToken {
        if (shares[shareholder].amount > 0) {
            distributeDividend(shareholder);
        }

        if (amount > 0 && shares[shareholder].amount == 0) {
            addShareholder(shareholder);
        } else if (amount == 0 && shares[shareholder].amount > 0) {
            removeShareholder(shareholder);
        }

        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
        shares[shareholder].amount = amount;
        shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
    }

    function deposit() external payable override authorized {
        uint256 balanceBefore = rewardToken.balanceOf(address(this));

        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = address(rewardToken);

        router.swapExactETHForTokensSupportingFeeOnTransferTokens {
            value: _msgValue()
        } (0, path, address(this), block.timestamp);

        uint256 amount = rewardToken.balanceOf(address(this)).sub(balanceBefore);

        totalDividends = totalDividends.add(amount);
        dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
    }

    function process(uint256 gas) external override authorized {
        uint256 shareholderCount = shareholders.length;

        if (shareholderCount == 0) {
            return;
        }

        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();
        uint256 iterations = 0;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }

            if (shouldDistribute(shareholders[currentIndex])) {
                distributeDividend(shareholders[currentIndex]);
            }

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }

    function shouldDistribute(address shareholder) internal view returns (bool) {
        return shareholderClaims[shareholder] + minPeriod < block.timestamp && getUnpaidEarnings(shareholder) > minDistribution;
    }

    function distributeDividend(address shareholder) internal {
        if (shares[shareholder].amount == 0) {
            return;
        }

        uint256 amount = getUnpaidEarnings(shareholder);
        if (amount > 0) {
            totalDistributed = totalDistributed.add(amount);
            shareholderClaims[shareholder] = block.timestamp;
            shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
            shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
            rewardToken.transfer(shareholder, amount);
        }
    }

    function getCumulativeDividends(uint256 share) internal view returns (uint256) {
        return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
    }
    
    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        if (shares[shareholder].amount == 0) {
            return 0;
        }

        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;

        if (shareholderTotalDividends <= shareholderTotalExcluded) {
            return 0;
        }

        return shareholderTotalDividends.sub(shareholderTotalExcluded);
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1];
        shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }

    function claimDividend() external {
        distributeDividend(_msgSender());
    }

}

contract FrenToken is Ownable, IERC20 {
    /* LIBRARY */
    using SafeMath for uint256;
    using Address for address;

    /* DATA */
    IRouter public router;
    DividendDistributor public dividendDistributor;
    
    string private constant NAME = "Fren Token";
    string private constant SYMBOL = "FREN";

    address public constant ZERO = address(0);
    address public constant DEAD = address(0xdead);
    
    address public pair;
    address public marketingWallet;
    address public liquidityReceiver;

    address[] public excludedAccounts;

    uint8 private constant DECIMALS = 9;
    
    uint256 private constant TOTALSUPPLY = 10_000_000_000 gwei;
    uint256 private constant TOKENTOTAL = TOTALSUPPLY;
    
    uint256 public constant MAX = ~uint256(0);
    uint256 public constant MAX_BUY_TAXES = 1000;
    uint256 public constant MAX_SELL_TAXES = 1000;
    uint256 public constant MAX_TRANSFER_TAXES = 1000;

    uint256 public distributorGas = 500_000;
    uint256 public buyMarketingFee = 0;
    uint256 public buyLiquidityFee = 0;
    uint256 public buyDividendFee = 0;
    uint256 public sellMarketingFee = 0;
    uint256 public sellLiquidityFee = 0;
    uint256 public sellDividendFee = 0;
    uint256 public transferMarketingFee = 0;
    uint256 public transferLiquidityFee = 0;
    uint256 public transferDividendFee = 0;
    uint256 public tokenFeeTotal = 0;
    uint256 public marketingFeeTotal = 0;
    uint256 public liquidityFeeTotal = 0;
    uint256 public dividendFeeTotal = 0;
    uint256 public minTokensBeforeSwap = 0;
    uint256 public reflectionTotal = (MAX.sub(MAX % TOKENTOTAL));

    bool private inSwapAndLiquify = false;

    bool public taxesAreLocked = false;
    bool public isFeeActive = false;
    bool public swapAndLiquifyEnabled = false;
    bool public presaleEnded = false;

    /* MAPPING */
    mapping (address => bool) public lpPairs;
    mapping (address => bool) public isDividendExempt;
    mapping (address => bool) public isExcludedFromFees;
    mapping (address => bool) public isExcludedFromReflections;
    mapping (address => uint256) public excludedIndexes;
    mapping (address => uint256) public reflectionBalance;
    mapping (address => uint256) public tokenBalance;
    mapping (address => mapping(address => uint256)) private _allowances;

    /* MODIFIER */
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    /* CONSTRUCTOR */
    constructor (
        address routerAddress,
        address marketingWalletAddress,
        DividendDistributor dividendDistributorAddress
    ) {
        require(marketingWalletAddress != address(0), "Fren Token: Cannot set marketing wallet as null address.");
        router = IRouter(routerAddress);
        pair = IFactory(router.factory()).createPair(address(this), router.WETH());
        lpPairs[pair] = true;
        
        marketingWallet = marketingWalletAddress;
        liquidityReceiver = _msgSender();
        dividendDistributor = dividendDistributorAddress;

        isExcludedFromFees[owner()] = true;
        isExcludedFromFees[DEAD] = true;
        isExcludedFromFees[ZERO] = true;
        isExcludedFromFees[address(dividendDistributor)] = true;
        isExcludedFromFees[address(this)] = true;

        isDividendExempt[owner()] = true;
        isDividendExempt[DEAD] = true;
        isDividendExempt[ZERO] = true;
        isDividendExempt[address(dividendDistributor)] = true;
        isDividendExempt[address(pair)] = true;
        isDividendExempt[address(router)] = true;
        isDividendExempt[address(this)] = true;

        _excludeFromReflections(owner());
        _excludeFromReflections(DEAD);
        _excludeFromReflections(ZERO);
        _excludeFromReflections(address(dividendDistributor));
        _excludeFromReflections(address(pair));
        _excludeFromReflections(address(router));
        _excludeFromReflections(address(this));
        
        reflectionBalance[owner()] = reflectionTotal;
        
        emit Transfer(address(0),owner(), TOKENTOTAL);
    }

    /* EVENT */
    event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived, uint256 tokensIntoLiqudity);
    event SetMinTokensBeforeSwap(uint256 prevMinTokensBeforeSwap, uint256 currentMinTokensBeforeSwap, uint256 timestamp);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event UpdateRouter(address prevRouter, address currentRouter, uint256 timestamp);
    event NewBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 dividendFee);
    event NewSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 dividendFee);
    event NewTransferFee(uint256 marketingFee, uint256 liquidityFee, uint256 dividendFee);
    event NewDistributorGas(uint256 newGas);

    /* FUNCTION */
    receive() external payable {}

    function setPresaleEnded() external onlyOwner {
        require(!presaleEnded, "Set Presale Ended: Presale has already been finalize.");
        presaleEnded = true;
        isFeeActive = true;
        swapAndLiquifyEnabled = true;
        buyMarketingFee = 200;
        buyLiquidityFee = 200;
        buyDividendFee = 100;
        sellMarketingFee = 200;
        sellLiquidityFee = 200;
        sellDividendFee = 100;
        minTokensBeforeSwap = TOKENTOTAL.mul(10).div(10000);
    }

    // CHECKS

    function checkAddress(address theAddress) pure internal {
        require(theAddress != ZERO, "Check Address: Address cannot be zero address.");
        require(theAddress != DEAD, "Check Address: Address cannot be dead address.");
    }

    function tokenFromReflection(uint256 reflectionAmount) public view returns (uint256) {
        require(reflectionAmount <= reflectionTotal, "Token From Reflection: Amount must be less than total reflections.");
        uint256 currentRate = getReflectionRate();
        return reflectionAmount.div(currentRate);
    }

    function getReflectionRate() public view returns (uint256) {
        uint256 reflectionSupply = reflectionTotal;
        uint256 tokenSupply = TOKENTOTAL;
        for (uint256 i = 0; i < excludedAccounts.length; i++) {
            if (
                reflectionBalance[excludedAccounts[i]] > reflectionSupply ||
                tokenBalance[excludedAccounts[i]] > tokenSupply
            ) return reflectionTotal.div(TOKENTOTAL);
            reflectionSupply = reflectionSupply.sub(
                reflectionBalance[excludedAccounts[i]]
            );
            tokenSupply = tokenSupply.sub(
                tokenBalance[excludedAccounts[i]]
            );
        }
        if (reflectionSupply < reflectionTotal.div(TOKENTOTAL))
            return reflectionTotal.div(TOKENTOTAL);
        return reflectionSupply.div(tokenSupply);
    }

    // UPDATES

    function lockTaxes() external onlyOwner {
        require(!taxesAreLocked, "Lock Taxes: Taxes were already locked forever.");
        taxesAreLocked = true;
    }

    function setBuyFees(uint256 marketingFee, uint256 liquidityFee, uint256 dividendFee) external onlyOwner {
        require(!taxesAreLocked, "Set Buy Fees: Taxes were locked forever.");
        require(marketingFee.add(liquidityFee).add(dividendFee) <= MAX_BUY_TAXES, "Set Buy Fees: Buy fee cannot exceed maximum buy taxes of 10%.");
        buyMarketingFee = marketingFee;
        buyLiquidityFee = liquidityFee;
        buyDividendFee = dividendFee;
        emit NewBuyFee(buyMarketingFee, buyLiquidityFee, buyDividendFee);
    }

    function setSellFees(uint256 marketingFee, uint256 liquidityFee, uint256 dividendFee) external onlyOwner {
        require(!taxesAreLocked, "Set Sell Fees: Taxes were locked forever.");
        require(marketingFee.add(liquidityFee).add(dividendFee) <= MAX_SELL_TAXES, "Set Sell Fees: Sell fee cannot exceed maximum sell taxes of 10%.");
        sellMarketingFee = marketingFee;
        sellLiquidityFee = liquidityFee;
        sellDividendFee = dividendFee;
        emit NewSellFee(sellMarketingFee, sellLiquidityFee, sellDividendFee);
    }

    function setTransferFees(uint256 marketingFee, uint256 liquidityFee, uint256 dividendFee) external onlyOwner {
        require(!taxesAreLocked, "Set Transfer Fees: Taxes were locked forever.");
        require(marketingFee.add(liquidityFee).add(dividendFee) <= MAX_TRANSFER_TAXES, "Set Transfer Fees: Transfer fee cannot exceed maximum transfer taxes of 10%.");
        transferMarketingFee = marketingFee;
        transferLiquidityFee = liquidityFee;
        transferDividendFee = dividendFee;
        emit NewTransferFee(transferMarketingFee, transferLiquidityFee, transferDividendFee);
    }

    function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
        require(amount > 0, "Set Min Tokens Before Swap: Minimum token required should be more than 0.");
        uint256 prevMinTokensBeforeSwap = minTokensBeforeSwap;
        minTokensBeforeSwap = amount;
        emit SetMinTokensBeforeSwap(prevMinTokensBeforeSwap, amount, block.timestamp);
    }

    function setMarketingWallet(address marketingWalletAddress) external onlyOwner {
        checkAddress(marketingWalletAddress);
        require(marketingWallet != marketingWalletAddress, "Set Marketing Wallet: Cannot set the same address.");
        marketingWallet = marketingWalletAddress;
    }

    function setLiquidityReceiver(address liquidityReceiverAddress) external onlyOwner {
        checkAddress(liquidityReceiverAddress);
        require(liquidityReceiver != liquidityReceiverAddress, "Set Liquidity Receiver: Cannot set the same address.");
        liquidityReceiver = liquidityReceiverAddress;
    }

    function setNewRouter(address routerAddress) external onlyOwner {
        require(routerAddress != address(router), "Set New Router: This is current address for the router.");
        address prevRouter = address(router);
        
        isDividendExempt[address(router)] = false;
        _excludeFromReflections(address(router));
        router = IRouter(routerAddress);
        isDividendExempt[address(router)] = true;
        _excludeFromReflections(address(router));

        lpPairs[pair] = false;
        isDividendExempt[address(pair)] = false;
        _excludeFromReflections(address(pair));
        pair = IFactory(router.factory()).createPair(address(this), router.WETH());
        lpPairs[pair] = true;
        isDividendExempt[address(pair)] = true;
        _excludeFromReflections(address(pair));

        emit UpdateRouter(prevRouter, routerAddress, block.timestamp);
    }

    function setOtherPair(address otherPair, bool value) external onlyOwner {
        require(otherPair.isContract(), "Set Other Pair: This is not a contract address.");
        require(lpPairs[otherPair] != value, "Set Other Pair: This is the current state for this pair.");
        isDividendExempt[address(otherPair)] = true;
        _excludeFromReflections(address(otherPair));
        lpPairs[otherPair] = value;
    }
    
    function setSwapAndLiquifyEnabled(bool enabled) external onlyOwner {
        swapAndLiquifyEnabled = enabled;
        emit SwapAndLiquifyEnabledUpdated(enabled);
    }
    
    function setFeeActive(bool value) external onlyOwner {
        isFeeActive = value;
    }

    // ERC STANDARD

    function name() public pure returns (string memory) {
        return NAME;
    }

    function symbol() public pure returns (string memory) {
        return SYMBOL;
    }

    function decimals() public pure returns (uint8) {
        return DECIMALS;
    }

    function totalSupply() public override pure returns (uint256) {
        return TOTALSUPPLY;
    }

    function balanceOf(address account) public override view returns (uint256) {
        if (isExcludedFromReflections[account]) return tokenBalance[account];
        return tokenFromReflection(reflectionBalance[account]);
    }

    function transfer(address recipient, uint256 amount) external override virtual returns (bool) {
       _transfer(_msgSender(),recipient,amount);
        return true;
    }

    function allowance(address provider, address spender) external override view returns (uint256) {
        return _allowances[provider][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address provider, address spender, uint256 amount) internal {
        require(provider != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[provider][spender] = amount;
        emit Approval(provider, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override virtual returns (bool) {
        _transfer(sender,recipient,amount);
               
        _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "ERC20: Transfer amount must be greater than zero");
        
        uint256 contractTokenBalance = balanceOf(address(this));
        bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
        if (!inSwapAndLiquify && overMinTokenBalance && sender != pair && swapAndLiquifyEnabled) {
            swapAndLiquify(minTokensBeforeSwap);
        }

        bool takeFee = isFeeActive;

        if (isExcludedFromFees[sender] || isExcludedFromFees[recipient]) {
            takeFee = false;
        }

        tokenTransfer(sender, recipient, amount, takeFee);
        
        if(!isDividendExempt[sender]) {
            try IDividendDistributor(dividendDistributor).setShare(sender, balanceOf(sender)) {} catch {}
        }
        if(!isDividendExempt[recipient]) {
            try IDividendDistributor(dividendDistributor).setShare(recipient, balanceOf(recipient)) {} catch {}
        }

        try IDividendDistributor(dividendDistributor).process(distributorGas) {} catch {}

    }

    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(
            subtractedValue,
            "ERC20: decreased allowance below zero"
        ));
        return true;
    }

    // REFLECTIONS

    function excludeFromReflections(address account) public onlyOwner {
        require(!isExcludedFromReflections[account], "Exclude From Reflections: Account is already excluded.");

        if (reflectionBalance[account] > 0) {
            tokenBalance[account] = tokenFromReflection(
                reflectionBalance[account]
            );
        }
        
        _excludeFromReflections(account);
    }

    function _excludeFromReflections(address account) internal {
        isExcludedFromReflections[account] = true;
        excludedIndexes[account] = excludedAccounts.length;
        excludedAccounts.push(account);
    }

    function includeInReflections(address account) external onlyOwner {
        require(isExcludedFromReflections[account], "Include From Reflections: Account is already included");
        excludedAccounts[excludedIndexes[account]] = excludedAccounts[excludedAccounts.length - 1];
        tokenBalance[account] = 0;
        _includeFromReflections(account);
    }

    function _includeFromReflections(address account) internal {
        isExcludedFromReflections[account] = false;
        excludedIndexes[excludedAccounts[excludedAccounts.length - 1]] = excludedIndexes[account];
        excludedAccounts.pop();
    }

    // DIVIDEND

    function distributorInitialization(bool initialized) public onlyOwner {
        DividendDistributor(dividendDistributor).unInitialized(initialized);
    }

    function setIsDividendExempt(address holder, bool exempt) external authorized {
        require(holder != address(this) && holder != pair);
        isDividendExempt[holder] = exempt;

        if (exempt) {
            IDividendDistributor(dividendDistributor).setShare(holder, 0);
        } else {
            IDividendDistributor(dividendDistributor).setShare(holder, balanceOf(holder));
        }
    }
    
    function setNewDividendDistributor(DividendDistributor dividendDistributorAddress) external onlyOwner {
        checkAddress(address(dividendDistributorAddress));
        require(dividendDistributor != dividendDistributorAddress, "Set Dividend Distributor: Cannot set the same address.");

        distributorInitialization(false);
        DividendDistributor(dividendDistributor).setTokenAddress(_msgSender());
        
        isExcludedFromFees[address(dividendDistributor)] = false;
        _includeFromReflections(address(dividendDistributor));
        
        isExcludedFromFees[address(dividendDistributorAddress)] = true;
        _excludeFromReflections(address(dividendDistributorAddress));

        dividendDistributor = dividendDistributorAddress;
    }

    function setDistributorSettings(uint256 gas) external onlyOwner {
        require(gas < 750000, "Set Distributor Settings: Gas must be lower than 750000.");
        require(gas != distributorGas, "Set Distributor Settings: This is the current gas value.");
        distributorGas = gas;
        emit NewDistributorGas(distributorGas);
    }

    // TRANSFER

    function tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) internal {
        if (isExcludedFromReflections[sender] && !isExcludedFromReflections[recipient]) {
            transferFromExcluded(sender, recipient, amount, takeFee);
        } else if (!isExcludedFromReflections[sender] && isExcludedFromReflections[recipient]) {
            transferToExcluded(sender, recipient, amount, takeFee);
        } else if (!isExcludedFromReflections[sender] && !isExcludedFromReflections[recipient]) {
            transferStandard(sender, recipient, amount, takeFee);
        } else if (isExcludedFromReflections[sender] && isExcludedFromReflections[recipient]) {
            transferBothExcluded(sender, recipient, amount, takeFee);
        } else {
            transferStandard(sender, recipient, amount, takeFee);
        }
    }

    function transferStandard(address sender, address recipient, uint256 tAmount, bool takeFee) internal {
        uint256 rate = getReflectionRate();
        uint256 transferAmount = tAmount;

        if(takeFee && sender == pair && lpPairs[sender]) {
            transferAmount = collectBuyFee(sender,tAmount,rate);
        } else if(takeFee && recipient == pair && lpPairs[recipient]) {
            transferAmount = collectSellFee(sender,tAmount,rate);
        } else if(takeFee && sender != pair && !lpPairs[sender] && recipient != pair && !lpPairs[recipient]) {
            transferAmount = collectTransferFee(sender,tAmount,rate);
        }

        reflectionBalance[sender] = reflectionBalance[sender].sub(tAmount.mul(rate));
        reflectionBalance[recipient] = reflectionBalance[recipient].add(transferAmount.mul(rate));
        
        emit Transfer(sender, recipient, transferAmount);
    }

    function transferToExcluded(address sender, address recipient, uint256 tAmount, bool takeFee) internal {
        uint256 rate = getReflectionRate();
        uint256 transferAmount = tAmount;

        if(takeFee && sender == pair && lpPairs[sender]) {
            transferAmount = collectBuyFee(sender,tAmount,rate);
        } else if(takeFee && recipient == pair && lpPairs[recipient]) {
            transferAmount = collectSellFee(sender,tAmount,rate);
        } else if(takeFee && sender != pair && !lpPairs[sender] && recipient != pair && !lpPairs[recipient]) {
            transferAmount = collectTransferFee(sender,tAmount,rate);
        }

        reflectionBalance[sender] = reflectionBalance[sender].sub(tAmount.mul(rate));
        tokenBalance[recipient] = tokenBalance[recipient].add(transferAmount);
        reflectionBalance[recipient] = reflectionBalance[recipient].add(transferAmount.mul(rate));
        
        emit Transfer(sender, recipient, transferAmount);
    }

    function transferFromExcluded(address sender, address recipient, uint256 tAmount, bool takeFee) internal {
        uint256 rate = getReflectionRate();
        uint256 transferAmount = tAmount;

        if(takeFee && sender == pair && lpPairs[sender]) {
            transferAmount = collectBuyFee(sender,tAmount,rate);
        } else if(takeFee && recipient == pair && lpPairs[recipient]) {
            transferAmount = collectSellFee(sender,tAmount,rate);
        } else if(takeFee && sender != pair && !lpPairs[sender] && recipient != pair && !lpPairs[recipient]) {
            transferAmount = collectTransferFee(sender,tAmount,rate);
        }

        tokenBalance[sender] = tokenBalance[sender].sub(tAmount);
        reflectionBalance[sender] = reflectionBalance[sender].sub(tAmount.mul(rate));
        reflectionBalance[recipient] = reflectionBalance[recipient].add(transferAmount.mul(rate));
        
        emit Transfer(sender, recipient, transferAmount);
    }

    function transferBothExcluded(address sender, address recipient, uint256 tAmount, bool takeFee) internal {
        uint256 rate = getReflectionRate();
        uint256 transferAmount = tAmount;

        if(takeFee && sender == pair && lpPairs[sender]) {
            transferAmount = collectBuyFee(sender,tAmount,rate);
        } else if(takeFee && recipient == pair && lpPairs[recipient]) {
            transferAmount = collectSellFee(sender,tAmount,rate);
        } else if(takeFee && sender != pair && !lpPairs[sender] && recipient != pair && !lpPairs[recipient]) {
            transferAmount = collectTransferFee(sender,tAmount,rate);
        }

        tokenBalance[sender] = tokenBalance[sender].sub(tAmount);
        reflectionBalance[sender] = reflectionBalance[sender].sub(tAmount.mul(rate));
        tokenBalance[recipient] = tokenBalance[recipient].add(transferAmount);
        reflectionBalance[recipient] = reflectionBalance[recipient].add(transferAmount.mul(rate));
        
        emit Transfer(sender, recipient, transferAmount);
    }

    // TAXES
    
    function setExcludeFromFees(address account, bool value) external onlyOwner {
        isExcludedFromFees[account] = value;
    }

    function collectBuyFee(address account, uint256 amount, uint256 rate) internal returns (uint256) {
        uint256 transferAmount = amount;
        
        if(buyMarketingFee != 0){
            uint256 feeMarketing = amount.mul(buyMarketingFee);
            uint256 feeMarketingDivided = feeMarketing.div(10000);
            transferAmount=transferAmount.sub(feeMarketingDivided);
            reflectionBalance[marketingWallet] = reflectionBalance[marketingWallet].add(feeMarketing.mul(rate).div(10000));
            if(isExcludedFromReflections[marketingWallet]){
                tokenBalance[marketingWallet] = tokenBalance[marketingWallet].add(feeMarketingDivided);
            }
            reflectionTotal = reflectionTotal.sub(feeMarketing.mul(rate));
            tokenFeeTotal = tokenFeeTotal.add(feeMarketingDivided);
            marketingFeeTotal = marketingFeeTotal.add(feeMarketingDivided);
            emit Transfer(account, marketingWallet, feeMarketingDivided);
        }

        if(buyLiquidityFee != 0){
            uint256 feeLiquidity = amount.mul(buyLiquidityFee);
            uint256 feeLiquidityDivided = feeLiquidity.div(10000);
            transferAmount = transferAmount.sub(feeLiquidityDivided);
            reflectionBalance[address(this)] = reflectionBalance[address(this)].add(feeLiquidity.mul(rate).div(10000));
            if(isExcludedFromReflections[address(this)]){
                tokenBalance[address(this)] = tokenBalance[address(this)].add(feeLiquidityDivided);
            }
            reflectionTotal = reflectionTotal.sub(feeLiquidity.mul(rate));
            tokenFeeTotal = tokenFeeTotal.add(feeLiquidityDivided);
            liquidityFeeTotal = liquidityFeeTotal.add(feeLiquidityDivided);
            emit Transfer(account, address(this), feeLiquidityDivided);
        }

        if(buyDividendFee != 0){
            uint256 feeDividend = amount.mul(buyDividendFee);
            uint256 feeDividendDivided = feeDividend.div(10000);
            transferAmount = transferAmount.sub(feeDividendDivided);
            reflectionBalance[address(dividendDistributor)] = reflectionBalance[address(dividendDistributor)].add(feeDividend.mul(rate).div(10000));
            if(isExcludedFromReflections[address(dividendDistributor)]){
                tokenBalance[address(dividendDistributor)] = tokenBalance[address(dividendDistributor)].add(feeDividendDivided);
            }
            reflectionTotal = reflectionTotal.sub(feeDividend.mul(rate));
            tokenFeeTotal = tokenFeeTotal.add(feeDividendDivided);
            dividendFeeTotal = dividendFeeTotal.add(feeDividendDivided);
            emit Transfer(account, address(dividendDistributor), feeDividendDivided);
        }
        
        return transferAmount;
    }
    
    function collectSellFee(address account, uint256 amount, uint256 rate) internal returns (uint256) {
        uint256 transferAmount = amount;
        
        if(sellMarketingFee != 0){
            uint256 feeMarketing = amount.mul(sellMarketingFee);
            uint256 feeMarketingDivided = feeMarketing.div(10000);
            transferAmount=transferAmount.sub(feeMarketingDivided);
            reflectionBalance[marketingWallet] = reflectionBalance[marketingWallet].add(feeMarketing.mul(rate).div(10000));
            if(isExcludedFromReflections[marketingWallet]){
                tokenBalance[marketingWallet] = tokenBalance[marketingWallet].add(feeMarketingDivided);
            }
            reflectionTotal = reflectionTotal.sub(feeMarketing.mul(rate));
            tokenFeeTotal = tokenFeeTotal.add(feeMarketingDivided);
            marketingFeeTotal = marketingFeeTotal.add(feeMarketingDivided);
            emit Transfer(account, marketingWallet, feeMarketingDivided);
        }

        if(sellLiquidityFee != 0){
            uint256 feeLiquidity = amount.mul(sellLiquidityFee);
            uint256 feeLiquidityDivided = feeLiquidity.div(10000);
            transferAmount = transferAmount.sub(feeLiquidityDivided);
            reflectionBalance[address(this)] = reflectionBalance[address(this)].add(feeLiquidity.mul(rate).div(10000));
            if(isExcludedFromReflections[address(this)]){
                tokenBalance[address(this)] = tokenBalance[address(this)].add(feeLiquidityDivided);
            }
            reflectionTotal = reflectionTotal.sub(feeLiquidity.mul(rate));
            tokenFeeTotal = tokenFeeTotal.add(feeLiquidityDivided);
            liquidityFeeTotal = liquidityFeeTotal.add(feeLiquidityDivided);
            emit Transfer(account, address(this), feeLiquidityDivided);
        }

        if(sellDividendFee != 0){
            uint256 feeDividend = amount.mul(sellDividendFee);
            uint256 feeDividendDivided = feeDividend.div(10000);
            transferAmount = transferAmount.sub(feeDividendDivided);
            reflectionBalance[address(dividendDistributor)] = reflectionBalance[address(dividendDistributor)].add(feeDividend.mul(rate).div(10000));
            if(isExcludedFromReflections[address(dividendDistributor)]){
                tokenBalance[address(dividendDistributor)] = tokenBalance[address(dividendDistributor)].add(feeDividendDivided);
            }
            reflectionTotal = reflectionTotal.sub(feeDividend.mul(rate));
            tokenFeeTotal = tokenFeeTotal.add(feeDividendDivided);
            dividendFeeTotal = dividendFeeTotal.add(feeDividendDivided);
            emit Transfer(account, address(dividendDistributor), feeDividendDivided);
        }
        
        return transferAmount;
    }
    
    function collectTransferFee(address account, uint256 amount, uint256 rate) internal returns (uint256) {
        uint256 transferAmount = amount;
        
        if(transferMarketingFee != 0){
            uint256 feeMarketing = amount.mul(transferMarketingFee);
            uint256 feeMarketingDivided = feeMarketing.div(10000);
            transferAmount=transferAmount.sub(feeMarketingDivided);
            reflectionBalance[marketingWallet] = reflectionBalance[marketingWallet].add(feeMarketing.mul(rate).div(10000));
            if(isExcludedFromReflections[marketingWallet]){
                tokenBalance[marketingWallet] = tokenBalance[marketingWallet].add(feeMarketingDivided);
            }
            reflectionTotal = reflectionTotal.sub(feeMarketing.mul(rate));
            tokenFeeTotal = tokenFeeTotal.add(feeMarketingDivided);
            marketingFeeTotal = marketingFeeTotal.add(feeMarketingDivided);
            emit Transfer(account, marketingWallet, feeMarketingDivided);
        }

        if(transferLiquidityFee != 0){
            uint256 feeLiquidity = amount.mul(transferLiquidityFee);
            uint256 feeLiquidityDivided = feeLiquidity.div(10000);
            transferAmount = transferAmount.sub(feeLiquidityDivided);
            reflectionBalance[address(this)] = reflectionBalance[address(this)].add(feeLiquidity.mul(rate).div(10000));
            if(isExcludedFromReflections[address(this)]){
                tokenBalance[address(this)] = tokenBalance[address(this)].add(feeLiquidityDivided);
            }
            reflectionTotal = reflectionTotal.sub(feeLiquidity.mul(rate));
            tokenFeeTotal = tokenFeeTotal.add(feeLiquidityDivided);
            liquidityFeeTotal = liquidityFeeTotal.add(feeLiquidityDivided);
            emit Transfer(account, address(this), feeLiquidityDivided);
        }

        if(transferDividendFee != 0){
            uint256 feeDividend = amount.mul(transferDividendFee);
            uint256 feeDividendDivided = feeDividend.div(10000);
            transferAmount = transferAmount.sub(feeDividendDivided);
            reflectionBalance[address(dividendDistributor)] = reflectionBalance[address(dividendDistributor)].add(feeDividend.mul(rate).div(10000));
            if(isExcludedFromReflections[address(dividendDistributor)]){
                tokenBalance[address(dividendDistributor)] = tokenBalance[address(dividendDistributor)].add(feeDividendDivided);
            }
            reflectionTotal = reflectionTotal.sub(feeDividend.mul(rate));
            tokenFeeTotal = tokenFeeTotal.add(feeDividendDivided);
            dividendFeeTotal = dividendFeeTotal.add(feeDividendDivided);
            emit Transfer(account, address(dividendDistributor), feeDividendDivided);
        }
        
        return transferAmount;
    }

    // LIQUIFY

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(router), tokenAmount);

        router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            liquidityReceiver,
            block.timestamp
        );
    }

    // SWAP

    function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);
        uint256 initialBalance = address(this).balance;
        
        swapTokensForEth(half);
        
        uint256 newBalance = address(this).balance.sub(initialBalance);
        
        addLiquidity(otherHalf, newBalance);
        
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        _approve(address(this), address(router), tokenAmount);

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    // OVERRIDES

    function transferOwnership(address newOwner) public override virtual onlyOwner {
        checkAddress(newOwner);
        
        isExcludedFromFees[owner()] = false;
        isExcludedFromReflections[owner()] = false;

        isExcludedFromFees[newOwner] = true;
        isExcludedFromReflections[newOwner] = true;

        _transferOwnership(newOwner);
    }
}