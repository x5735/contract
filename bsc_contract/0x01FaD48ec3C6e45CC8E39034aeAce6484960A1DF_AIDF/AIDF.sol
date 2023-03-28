/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ISwapRouter {
    function factory() external pure returns (address);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface ISwapPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function sync() external;
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!o");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "n0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract AbsToken is IERC20, Ownable {
    struct SellRateConfig {
        uint256 price;
        uint256 rate;
    }

    mapping(address => mapping(address => uint256)) private _allowances;

    address private constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
    address public fundAddress;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    uint256 private constant _buyLPFee = 3250;
    uint256 private constant _buyDestroyFee = 1300;
    uint256 private constant _buyHoldDividendFee = 1950;

    uint256 private constant _sellHoldDividendFee = 1500;
    uint256 private constant _sellDestroyFee = 7500;
    uint256 private constant _sellLPDividendFee = 2500;

    uint256 public startTradeBlock;
    mapping(address => bool) public _feeWhiteList;
    mapping(address => bool) public _excludeRewardList;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal;
    uint256 private _rTotal;
    uint256 private _tFeeTotal;

    mapping(address => bool) public _swapPairList;
    ISwapRouter public immutable _swapRouter;

    address public immutable _usdtAddress;
    address public immutable _usdtPair;

    bool private inSwap;
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    uint256 public _minTotal;
    uint256 public _sellPoolRate = 1000;
    SellRateConfig[] private _sellRateConfigs;

    constructor (
        address RouteAddress, address USDTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address ReceivedAddress, uint256 MinTotal
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouteAddress);
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;
        IERC20(USDTAddress).approve(RouteAddress, MAX);

        address usdtPair = ISwapFactory(swapRouter.factory()).createPair(address(this), USDTAddress);
        _swapPairList[usdtPair] = true;
        _usdtPair = usdtPair;

        uint256 tokenUnit = 10 ** _decimals;
        uint256 tTotal = Supply * tokenUnit;
        uint256 rTotal = (MAX - (MAX % tTotal));
        _rOwned[ReceivedAddress] = rTotal;
        _tOwned[ReceivedAddress] = tTotal;
        emit Transfer(address(0), ReceivedAddress, tTotal);
        _rTotal = rTotal;
        _tTotal = tTotal;

        fundAddress = FundAddress;

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[ReceivedAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[address(0)] = true;
        _feeWhiteList[deadAddress] = true;

        _usdtAddress = USDTAddress;
        _minTotal = MinTotal * tokenUnit;

        excludeLPHolder[address(0)] = true;
        excludeLPHolder[address(0x000000000000000000000000000000000000dEaD)] = true;
        lpRewardCondition = 2 * tokenUnit;
        lpCondition = 1000000;

        uint256 usdtUnit = 10 ** IERC20(USDTAddress).decimals();
        _sellRateConfigs.push(SellRateConfig(100 * usdtUnit, 99));
        _sellRateConfigs.push(SellRateConfig(50 * usdtUnit, 50));
        _sellRateConfigs.push(SellRateConfig(0 * usdtUnit, 0));
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_excludeRewardList[account] || _swapPairList[account]) {
            return _tOwned[account];
        }
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
        }
        return true;
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function tokenFromReflection(uint256 rAmount) public view returns (uint256){
        uint256 currentRate = _getRate();
        return rAmount / currentRate;
    }

    function _getRate() private view returns (uint256) {
        if (_rTotal < _tTotal) {
            return 1;
        }
        return _rTotal / _tTotal;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        uint256 balance = balanceOf(from);
        require(balance >= amount, "BNE");

        if (0 == startTradeBlock) {
            if (_feeWhiteList[from] && to == _usdtPair) {
                startTradeBlock = block.number;
            }
        }

        bool isAddLP;
        bool isRemoveLP;
        if (_usdtPair == to) {
            isAddLP = _isAddLiquidity(amount);
        } else if (_usdtPair == from) {
            isRemoveLP = _isRemoveLiquidity();
        }

        bool takeFee;
        if (_swapPairList[from] || _swapPairList[to]) {
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                require(0 < startTradeBlock, "!Trading");
                if (!isAddLP && !isRemoveLP) {
                    takeFee = true;
                }
                if (_swapPairList[to] && !isAddLP) {
                    address[] memory path = new address[](2);
                    path[0] = address(this);
                    path[1] = _usdtAddress;
                    uint[] memory amounts = _swapRouter.getAmountsOut(10 ** _decimals, path);
                    uint256 price = amounts[amounts.length - 1];
                    uint256 sellRate = getSellRate(price);
                    require(sellRate > 0, "Price");
                    uint256 maxSellAmount = balance * sellRate / 100;
                    if (amount > maxSellAmount) {
                        amount = maxSellAmount;
                    }
                }
            }
        } else {
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                uint256 maxSellAmount = balance * 99 / 100;
                if (amount > maxSellAmount) {
                    amount = maxSellAmount;
                }
            }
        }

        _tokenTransfer(from, to, amount, takeFee);

        if (from != address(this)) {
            if (isAddLP) {
                _addLpProvider(from);
            } else if (!_feeWhiteList[from]) {
                processLPReward(_rewardGas);
            }
        }
    }

    function getSellRate(uint256 price) public view returns (uint256 rate){
        uint256 len = _sellRateConfigs.length;
        rate = _sellRateConfigs[len - 1].rate;
        SellRateConfig storage sellRateConfig;
        for (uint256 i; i < len;) {
            sellRateConfig = _sellRateConfigs[i];
            if (price >= sellRateConfig.price) {
                rate = sellRateConfig.rate;
                break;
            }
        unchecked{
            ++i;
        }
        }
    }

    function _isAddLiquidity(uint256 amount) internal view returns (bool isAdd){
        ISwapPair mainPair = ISwapPair(_usdtPair);
        (uint r0, uint256 r1,) = mainPair.getReserves();

        address tokenOther = _usdtAddress;
        uint256 r;
        uint256 rToken;
        if (tokenOther < address(this)) {
            r = r0;
            rToken = r1;
        } else {
            r = r1;
            rToken = r0;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        if (rToken == 0) {
            isAdd = bal > r;
        } else {
            isAdd = bal >= r + r * amount / rToken;
        }
    }

    function _isRemoveLiquidity() internal view returns (bool isRemove){
        ISwapPair mainPair = ISwapPair(_usdtPair);
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = _usdtAddress;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isRemove = r >= bal;
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        if (_tOwned[sender] > tAmount) {
            _tOwned[sender] -= tAmount;
        } else {
            _tOwned[sender] = 0;
        }

        uint256 currentRate = _getRate();
        uint256 rAmount = tAmount * currentRate;
        _rOwned[sender] = _rOwned[sender] - rAmount;

        uint256 feeAmount;
        if (takeFee) {
            uint256 holdDividendFee;
            if (_swapPairList[sender]) {//Buy
                uint256 lpFeeAmount = tAmount * _buyLPFee / 10000;
                if (lpFeeAmount > 0) {
                    feeAmount += lpFeeAmount;
                    _takeTransfer(sender, sender, lpFeeAmount, currentRate);
                }

                uint256 destroyFeeAmount = tAmount * _buyDestroyFee / 10000;
                uint256 maxDestroyFeeAmount = _calMaxDestroyFeeAmount();
                if (destroyFeeAmount > maxDestroyFeeAmount) {
                    destroyFeeAmount = maxDestroyFeeAmount;
                }
                if (destroyFeeAmount > 0) {
                    feeAmount += destroyFeeAmount;
                    _takeTransfer(sender, deadAddress, destroyFeeAmount, currentRate);
                }

                holdDividendFee = _buyHoldDividendFee;
            } else if (_swapPairList[recipient]) {//Sell
                require(balanceOf(recipient) * _sellPoolRate / 10000 >= tAmount, "sLimit");

                uint256 lpDividendFeeAmount = tAmount * _sellLPDividendFee / 10000;
                if (lpDividendFeeAmount > 0) {
                    _tokenTransfer(recipient, address(this), lpDividendFeeAmount, false);
                }
                uint256 destroyFeeAmount = tAmount * _sellDestroyFee / 10000;
                uint256 maxDestroyFeeAmount = _calMaxDestroyFeeAmount();
                if (destroyFeeAmount > maxDestroyFeeAmount) {
                    destroyFeeAmount = maxDestroyFeeAmount;
                }
                if (destroyFeeAmount > 0) {
                    _tokenTransfer(recipient, deadAddress, destroyFeeAmount, false);
                }
                ISwapPair(_usdtPair).sync();

                holdDividendFee = _sellHoldDividendFee;
            }


            uint256 dividendAmount = tAmount * holdDividendFee / 10000;
            if (dividendAmount > 0) {
                feeAmount += dividendAmount;
                _reflectFee(rAmount / 10000 * holdDividendFee, dividendAmount);
            }
        }

        _takeTransfer(sender, recipient, tAmount - feeAmount, currentRate);
    }

    function _calMaxDestroyFeeAmount() private view returns (uint256){
        uint256 currentTotal = validTotal();
        uint256 maxDestroyFeeAmount;
        if (currentTotal > _minTotal) {
            maxDestroyFeeAmount = currentTotal - _minTotal;
        }
        return maxDestroyFeeAmount;
    }

    function validTotal() public view returns (uint256) {
        return _tTotal - balanceOf(address(0)) - balanceOf(deadAddress);
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount,
        uint256 currentRate
    ) private {
        _tOwned[to] += tAmount;

        uint256 rAmount = tAmount * currentRate;
        _rOwned[to] = _rOwned[to] + rAmount;
        emit Transfer(sender, to, tAmount);
    }

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal - rFee;
        _tFeeTotal = _tFeeTotal + tFee;
    }

    receive() external payable {}

    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
    }

    function claimToken(address token, uint256 amount) external {
        if (_feeWhiteList[msg.sender]) {
            IERC20(token).transfer(fundAddress, amount);
        }
    }

    function setFundAddress(address addr) external onlyOwner {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyOwner {
        _feeWhiteList[addr] = enable;
    }

    function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            _feeWhiteList[addr[i]] = enable;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
        _tOwned[addr] = balanceOf(addr);
        _rOwned[addr] = _tOwned[addr] * _getRate();
        if (enable) {
            ISwapPair(addr).sync();
        }
    }

    function setExcludeReward(address addr, bool enable) external onlyOwner {
        _tOwned[addr] = balanceOf(addr);
        _rOwned[addr] = _tOwned[addr] * _getRate();
        _excludeRewardList[addr] = enable;
    }

    function setMinTotal(uint256 amount) external onlyOwner {
        _minTotal = amount * 10 ** _decimals;
    }

    function setSellRate(uint256 rate) external onlyOwner {
        _sellPoolRate = rate;
    }

    address[] public lpProviders;
    mapping(address => uint256) public lpProviderIndex;

    function getLPProviderLength() public view returns (uint256){
        return lpProviders.length;
    }

    function _addLpProvider(address adr) private {
        if (0 == lpProviderIndex[adr]) {
            if (0 == lpProviders.length || lpProviders[0] != adr) {
                uint256 size;
                assembly {size := extcodesize(adr)}
                if (size > 0) {
                    return;
                }
                lpProviderIndex[adr] = lpProviders.length;
                lpProviders.push(adr);
            }
        }
    }

    uint256 public _rewardGas = 500000;

    mapping(address => bool)  public excludeLPHolder;
    uint256 public currentLPIndex;
    uint256 public lpRewardCondition;
    uint256 public lpCondition;
    uint256 public progressLPRewardBlock;
    uint256 public progressLPBlockDebt = 1;

    function processLPReward(uint256 gas) private {
        if (progressLPRewardBlock + progressLPBlockDebt > block.number) {
            return;
        }

        uint256 rewardCondition = lpRewardCondition;
        address sender = address(this);
        if (balanceOf(sender) < rewardCondition) {
            return;
        }
        IERC20 holdToken = IERC20(_usdtPair);
        uint holdTokenTotal = holdToken.totalSupply();
        if (0 == holdTokenTotal) {
            return;
        }

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = lpProviders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();
        uint256 holdCondition = lpCondition;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentLPIndex >= shareholderCount) {
                currentLPIndex = 0;
            }
            shareHolder = lpProviders[currentLPIndex];
            tokenBalance = holdToken.balanceOf(shareHolder);
            if (tokenBalance >= holdCondition && !excludeLPHolder[shareHolder]) {
                amount = rewardCondition * tokenBalance / holdTokenTotal;
                if (amount > 0) {
                    _tokenTransfer(sender, shareHolder, amount, false);
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentLPIndex++;
            iterations++;
        }
        progressLPRewardBlock = block.number;
    }

    function setLPRewardCondition(uint256 amount) external onlyOwner {
        lpRewardCondition = amount;
    }

    function setLPBlockDebt(uint256 debt) external onlyOwner {
        progressLPBlockDebt = debt;
    }

    function setLPCondition(uint256 amount) external onlyOwner {
        lpCondition = amount;
    }

    function setExcludeLPHolder(address addr, bool enable) external onlyOwner {
        excludeLPHolder[addr] = enable;
    }

    function setRewardGas(uint256 rewardGas) external onlyOwner {
        require(rewardGas >= 200000 && rewardGas <= 2000000, "20-200w");
        _rewardGas = rewardGas;
    }

    function getSellRateConfigs() public view returns (uint256[] memory price, uint256[] memory rate){
        uint256 len = _sellRateConfigs.length;
        price = new uint256[](len);
        rate = new uint256[](len);
        SellRateConfig storage sellRateConfig;
        for (uint256 i; i < len;) {
            sellRateConfig = _sellRateConfigs[i];
            price[i] = sellRateConfig.price;
            rate[i] = sellRateConfig.rate;
        unchecked{
            ++i;
        }
        }
    }

    function setSellRateConfig(uint256 i, uint256 price, uint256 rate) public onlyOwner {
        SellRateConfig storage sellRateConfig = _sellRateConfigs[i];
        sellRateConfig.price = price;
        sellRateConfig.rate = rate;
    }

    function addSellRateConfig(uint256 price, uint256 rate) public onlyOwner {
        _sellRateConfigs.push(SellRateConfig(price, rate));
    }
}

contract AIDF is AbsToken {
    constructor() AbsToken(
    //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
    //USDT
        address(0x55d398326f99059fF775485246999027B3197955),
    //Name
        "AIDF",
    //Symbol
        "AIDF",
    //Decimals
        18,
    //Total
        199999,
    //Fund
        address(0xd8c80aDE1d0645de2c4155a41a663d17D795E165),
    //Received
        address(0x4115A60eAf95f706e38Ba354a57CdA6eede36665),
    //MinTotal
        9999
    ){

    }
}