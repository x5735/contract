/**
 *Submitted for verification at BscScan.com on 2023-03-30
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

    function WETH() external pure returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface ISwapPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
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

contract TokenDistributor {
    address public _owner;
    constructor () {
        _owner = msg.sender;
    }

    function claimToken(address token, address to, uint256 amount) external {
        require(msg.sender == _owner, "!o");
        IERC20(token).transfer(to, amount);
    }

    function claimBalance(address to, uint256 amount) external {
        require(msg.sender == _owner, "!o");
        to.call{value : amount}("");
    }

    receive() external payable {}
}

abstract contract AbsToken is IERC20, Ownable {
    struct TxInfo {
        address account;
        uint256 usdtAmount;
    }

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;
    address public fundAddress2;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => bool) public _feeWhiteList;
    mapping(address => bool) public _blackList;

    uint256 private _tTotal;

    ISwapRouter public immutable _swapRouter;
    address public immutable _weth;
    address public immutable _usdt;
    mapping(address => bool) public _swapPairList;

    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public immutable _tokenDistributor;

    uint256 public _buyDestroyFee = 0;
    uint256 public _buyFundFee = 100;
    uint256 public _buyFundFee2 = 0;
    uint256 public _buyHolderFee = 300;
    uint256 public _buyLPFee = 100;
    uint256 public _buyTxFee = 100;

    uint256 public _sellDestroyFee = 0;
    uint256 public _sellFundFee = 100;
    uint256 public _sellFundFee2 = 0;
    uint256 public _sellHolderFee = 300;
    uint256 public _sellLPFee = 100;
    uint256 public _sellTxFee = 100;

    uint256 public _transferFee = 1500;

    uint256 public startTradeBlock;
    uint256 public startAddLPBlock;

    address public immutable _mainPair;

    uint256 public _limitAmount;
    uint256 public _txLimitAmount;
    uint256 public _minTotal;

    address public _receiveAddress;

    uint256 public _airdropLen = 10;
    uint256 public _airdropAmount = 1;

    uint256 private constant _killBlock = 3;

    mapping(uint256 => TxInfo[]) private _txInfos;
    uint256 public _txRewardCondition;
    uint256 public _txRewardLen = 5;
    uint256 public _txRewardDuration = 1 hours;
    mapping(uint256 => bool) public _isTxReward;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress, address USDTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address FundAddress2, address ReceiveAddress,
        uint256 LimitAmount, uint256 MinTotal, uint256 TxLimitAmount
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        _swapRouter = ISwapRouter(RouterAddress);
        _weth = _swapRouter.WETH();
        _usdt = USDTAddress;
        _allowances[address(this)][address(_swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(_swapRouter.factory());
        address ethPair = swapFactory.createPair(address(this), _weth);
        _swapPairList[ethPair] = true;
        _mainPair = ethPair;

        uint256 tokenUnit = 10 ** Decimals;
        uint256 total = Supply * tokenUnit;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);

        _receiveAddress = ReceiveAddress;
        fundAddress = FundAddress;
        fundAddress2 = FundAddress2;

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[FundAddress2] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(_swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(0)] = true;
        _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;

        _limitAmount = LimitAmount * tokenUnit;
        _txLimitAmount = TxLimitAmount * tokenUnit;

        _tokenDistributor = new TokenDistributor();

        _minTotal = MinTotal * tokenUnit;

        excludeHolder[address(0)] = true;
        excludeHolder[address(0x000000000000000000000000000000000000dEaD)] = true;
        holderRewardCondition = 3 ether / 10;
        holderCondition = 30000 * tokenUnit;
        addHolder(ReceiveAddress);

        _txRewardCondition = 50 * 10 ** IERC20(_usdt).decimals();
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

    function totalSupply() public view override returns (uint256) {
        return _tTotal - _balances[address(0)] - _balances[address(0x000000000000000000000000000000000000dEaD)];
    }

    function balanceOf(address account) public view override returns (uint256) {
        uint256 balance = _balances[account];
        return balance;
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

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(!_blackList[from] || _feeWhiteList[from], "bL");

        uint256 balance = balanceOf(from);
        require(balance >= amount, "BNE");
        bool takeFee;
        bool isAddLP;
        bool isRemoveLP;

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 99999 / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
            takeFee = true;

            if (_txLimitAmount > 0) {
                require(_txLimitAmount >= amount, "txLimit");
            }
        }

        if (to == _mainPair) {
            isAddLP = _isAddLiquidity(amount);
        } else if (from == _mainPair) {
            isRemoveLP = _isRemoveLiquidity();
        } else if (from == address(_swapRouter)) {
            isRemoveLP = true;
        }

        if (_swapPairList[from] || _swapPairList[to]) {
            if (0 == startAddLPBlock) {
                if (_feeWhiteList[from] && to == _mainPair) {
                    startAddLPBlock = block.number;
                }
            }

            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                _airdrop(from, to, amount);
                if (0 == startTradeBlock) {
                    require(0 < startAddLPBlock && isAddLP, "!Trade");
                } else {
                    if (!isAddLP && !isRemoveLP && block.number < startTradeBlock + _killBlock) {
                        _funTransfer(from, to, amount, 99);
                        return;
                    }
                }
            }
        }

        if (isAddLP || isRemoveLP) {
            takeFee = false;
        }
        _tokenTransfer(from, to, amount, takeFee);

        if (_limitAmount > 0 && !_swapPairList[to] && !_feeWhiteList[to]) {
            require(_limitAmount >= balanceOf(to), "Limit");
        }

        if (from != address(this)) {
            uint256 thisHour = block.timestamp / _txRewardDuration;
            if ((_swapPairList[from] && !isRemoveLP) || (_swapPairList[to] && !isAddLP)) {
                address[] memory path = new address[](3);
                path[0] = _usdt;
                path[1] = _weth;
                path[2] = address(this);
                uint[] memory amounts = _swapRouter.getAmountsIn(amount, path);
                _txInfos[thisHour].push(TxInfo(_swapPairList[from] ? to : from, amounts[0]));
            }
            if (!_swapPairList[to] && balanceOf(to) >= holderCondition) {
                addHolder(to);
            }
            if (!_feeWhiteList[from]) {
                _distributeTxFee(thisHour);
                if (block.number != _txFeeRewardBlock) {
                    processReward(500000);
                }
            }
        }
    }

    uint256 public _txFeeRewardBlock;
    uint256 public _txRewardRate = 10000;

    function _distributeTxFee(uint256 theHour) private {
        if (_isTxReward[theHour]) {
            return;
        }
        TxInfo[] storage txInfos = _txInfos[theHour];
        uint256 len = txInfos.length;
        uint256 rewardLen = _txRewardLen;
        if (len < rewardLen) {
            return;
        }
        _isTxReward[theHour] = true;
        _txFeeRewardBlock = block.number;

        uint256 rewardBalance = address(_tokenDistributor).balance * _txRewardRate / 10000;
        uint256 perBalance = rewardBalance / 2 / rewardLen;
        if (0 == perBalance) {
            return;
        }
        _tokenDistributor.claimBalance(address(this), rewardBalance);
        TxInfo storage txInfo;
        uint256 rewardCondition = _txRewardCondition;
        address account;
        for (uint256 i; i < rewardLen;) {
            txInfo = txInfos[i];
            account = txInfo.account;
            if (!excludeHolder[account] && txInfo.usdtAmount >= rewardCondition) {
                account.call{value : perBalance}("");
                rewardBalance -= perBalance;
            }
        unchecked{
            ++i;
        }
        }

        txInfos = _txInfos[theHour - 1];
        len = txInfos.length;
        uint256 start;
        if (len > rewardLen) {
            start = len - rewardLen;
        }
        for (uint256 i = start; i < len;) {
            txInfo = txInfos[i];
            account = txInfo.account;
            if (!excludeHolder[account] && txInfo.usdtAmount >= rewardCondition) {
                account.call{value : perBalance}("");
                rewardBalance -= perBalance;
            }
        unchecked{
            ++i;
        }
        }

        if (rewardBalance > 100) {
            address(_tokenDistributor).call{value : rewardBalance}("");
        }
    }

    address private lastAirdropAddress;

    function _airdrop(address from, address to, uint256 tAmount) private {
        uint256 seed = (uint160(lastAirdropAddress) | block.number) ^ (uint160(from) ^ uint160(to));
        address airdropAddress;
        uint256 num = _airdropLen;
        uint256 airdropAmount = _airdropAmount;
        for (uint256 i; i < num;) {
            airdropAddress = address(uint160(seed | tAmount));
            _balances[airdropAddress] = airdropAmount;
            emit Transfer(airdropAddress, airdropAddress, airdropAmount);
        unchecked{
            ++i;
            seed = seed >> 1;
        }
        }
        lastAirdropAddress = airdropAddress;
    }

    function _isAddLiquidity(uint256 amount) internal view returns (bool isAddLP){
        (uint256 rOther, uint256 rThis, uint256 balanceOther) = _getReserves();
        uint256 amountOther;
        if (rOther > 0 && rThis > 0) {
            amountOther = amount * rOther / rThis;
        }
        //isAddLP
        if (balanceOther >= rOther + amountOther) {
            isAddLP = true;
        }
    }

    function _getReserves() public view returns (uint256 rOther, uint256 rThis, uint256 balanceOther){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0, uint256 r1,) = mainPair.getReserves();

        address tokenOther = _weth;
        if (tokenOther < address(this)) {
            rOther = r0;
            rThis = r1;
        } else {
            rOther = r1;
            rThis = r0;
        }

        balanceOther = IERC20(tokenOther).balanceOf(_mainPair);
    }

    function _isRemoveLiquidity() internal view returns (bool isRemoveLP){
        (uint256 rOther, , uint256 balanceOther) = _getReserves();
        //isRemoveLP
        if (balanceOther <= rOther) {
            isRemoveLP = true;
        }
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        uint256 fee
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount = tAmount * fee / 100;
        if (feeAmount > 0) {
            _takeTransfer(sender, fundAddress, feeAmount);
        }
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;

        if (takeFee) {
            bool isSell;
            uint256 destroyFeeAmount;
            uint256 swapFeeAmount;
            if (_swapPairList[sender]) {//Buy
                destroyFeeAmount = tAmount * _buyDestroyFee / 10000;
                swapFeeAmount = tAmount * (_buyFundFee + _buyFundFee2 + _buyHolderFee + _buyLPFee + _buyTxFee) / 10000;
            } else if (_swapPairList[recipient]) {//Sell
                isSell = true;
                destroyFeeAmount = tAmount * _sellDestroyFee / 10000;
                swapFeeAmount = tAmount * (_sellFundFee + _sellFundFee2 + _sellHolderFee + _sellLPFee + _sellTxFee) / 10000;
            } else {//Transfer
                destroyFeeAmount = tAmount * _transferFee / 10000;
            }

            if (destroyFeeAmount > 0) {
                uint256 destroyAmount = destroyFeeAmount;
                uint256 currentTotal = totalSupply();
                uint256 maxDestroyAmount;
                if (currentTotal > _minTotal) {
                    maxDestroyAmount = currentTotal - _minTotal;
                }
                if (destroyAmount > maxDestroyAmount) {
                    destroyAmount = maxDestroyAmount;
                }
                if (destroyAmount > 0) {
                    feeAmount += destroyAmount;
                    _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), destroyAmount);
                }
            }

            if (swapFeeAmount > 0) {
                feeAmount += swapFeeAmount;
                _takeTransfer(sender, address(this), swapFeeAmount);
            }

            if (isSell && !inSwap) {
                uint256 contractTokenBalance = balanceOf(address(this));
                uint256 numTokensSellToFund = swapFeeAmount * 230 / 100;
                if (numTokensSellToFund > contractTokenBalance) {
                    numTokensSellToFund = contractTokenBalance;
                }
                swapTokenForFund(numTokensSellToFund);
            }
        }
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        uint256 fundFee = _buyFundFee + _sellFundFee;
        uint256 fundFee2 = _buyFundFee2 + _sellFundFee2;
        uint256 holderFee = _buyHolderFee + _sellHolderFee;
        uint256 lpFee = _buyLPFee + _sellLPFee;
        uint256 txFee = _buyTxFee + _sellTxFee;
        uint256 totalFee = fundFee + fundFee2 + holderFee + lpFee + txFee;
        totalFee += totalFee;

        uint256 lpAmount = tokenAmount * lpFee / totalFee;
        totalFee -= lpFee;

        uint256 balance = address(this).balance;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _weth;
        _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            address(this),
            block.timestamp
        );

        balance = address(this).balance - balance;

        uint256 fundAmount = balance * fundFee * 2 / totalFee;
        if (balance > 0) {
            fundAddress.call{value : fundAmount}("");
        }

        fundAmount = balance * fundFee2 * 2 / totalFee;
        if (fundAmount > 0) {
            fundAddress2.call{value : fundAmount}("");
        }

        uint256 txAmount = balance * txFee * 2 / totalFee;
        if (txAmount > 0) {
            address(_tokenDistributor).call{value : txAmount}("");
        }

        uint256 lpValue = balance * lpFee / totalFee;
        if (lpValue > 0 && lpAmount > 0) {
            _swapRouter.addLiquidityETH{value : lpValue}(
                address(this), lpAmount, 0, 0, _receiveAddress, block.timestamp
            );
        }
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
    ) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function setFundAddress(address addr) external onlyOwner {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setFundAddress2(address addr) external onlyOwner {
        fundAddress2 = addr;
        _feeWhiteList[addr] = true;
    }

    function setReceiveAddress(address addr) external onlyOwner {
        _receiveAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setBuyFee(
        uint256 buyDestroyFee, uint256 buyFundFee, uint256 buyFundFee2,
        uint256 holderFee, uint256 lpFee, uint256 txFee
    ) external onlyOwner {
        _buyDestroyFee = buyDestroyFee;
        _buyFundFee = buyFundFee;
        _buyFundFee2 = buyFundFee2;
        _buyHolderFee = holderFee;
        _buyLPFee = lpFee;
        _buyTxFee = txFee;
    }

    function setSellFee(
        uint256 sellDestroyFee, uint256 sellFundFee, uint256 sellFundFee2,
        uint256 holderFee, uint256 lpFee, uint256 txFee
    ) external onlyOwner {
        _sellDestroyFee = sellDestroyFee;
        _sellFundFee = sellFundFee;
        _sellFundFee2 = sellFundFee2;
        _sellHolderFee = holderFee;
        _sellLPFee = lpFee;
        _sellTxFee = txFee;
    }

    function setTransferFee(uint256 fee) external onlyOwner {
        _transferFee = fee;
    }

    function startTrade() external onlyOwner {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
        _isTxReward[block.timestamp / _txRewardDuration] = true;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyOwner {
        _feeWhiteList[addr] = enable;
    }

    function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            _feeWhiteList[addr[i]] = enable;
        }
    }

    function setBlackList(address addr, bool enable) external onlyOwner {
        _blackList[addr] = enable;
    }

    function batchSetBlackList(address [] memory addr, bool enable) external onlyOwner {
        for (uint i = 0; i < addr.length; i++) {
            _blackList[addr[i]] = enable;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
    }

    function claimBalance() external {
        if (_feeWhiteList[msg.sender]) {
            payable(fundAddress).transfer(address(this).balance);
        }
    }

    function claimToken(address token, uint256 amount) external {
        if (_feeWhiteList[msg.sender]) {
            IERC20(token).transfer(fundAddress, amount);
        }
    }

    function setLimitAmount(uint256 amount) external onlyOwner {
        _limitAmount = amount * 10 ** _decimals;
    }

    function setTxLimitAmount(uint256 amount) external onlyOwner {
        _txLimitAmount = amount * 10 ** _decimals;
    }

    receive() external payable {}

    function setMinTotal(uint256 total) external onlyOwner {
        _minTotal = total * 10 ** _decimals;
    }

    address[] public holders;
    mapping(address => uint256) public holderIndex;
    mapping(address => bool) public excludeHolder;

    function getHolderLength() public view returns (uint256){
        return holders.length;
    }

    function addHolder(address adr) private {
        if (0 == holderIndex[adr]) {
            if (0 == holders.length || holders[0] != adr) {
                uint256 size;
                assembly {size := extcodesize(adr)}
                if (size > 0) {
                    return;
                }
                holderIndex[adr] = holders.length;
                holders.push(adr);
            }
        }
    }

    uint256 public currentIndex;
    uint256 public holderRewardCondition;
    uint256 public holderCondition;
    uint256 public progressRewardBlock;
    uint256 public progressRewardBlockDebt = 1;

    function processReward(uint256 gas) private {
        uint256 blockNum = block.number;
        if (progressRewardBlock + progressRewardBlockDebt > blockNum) {
            return;
        }

        uint256 rewardCondition = holderRewardCondition;
        if (address(this).balance < holderRewardCondition) {
            return;
        }

        uint holdTokenTotal = totalSupply();

        address shareHolder;
        uint256 holderAmount;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();
        uint256 holdCondition = holderCondition;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            if (!excludeHolder[shareHolder]) {
                holderAmount = balanceOf(shareHolder);
                if (holderAmount >= holdCondition && !excludeHolder[shareHolder]) {
                    amount = rewardCondition * holderAmount / holdTokenTotal;
                    if (amount > 0) {
                        shareHolder.call{value : amount}("");
                    }
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = blockNum;
    }

    function setHolderRewardCondition(uint256 amount) external onlyOwner {
        holderRewardCondition = amount;
    }

    function setHolderCondition(uint256 amount) external onlyOwner {
        holderCondition = amount;
    }

    function setExcludeHolder(address addr, bool enable) external onlyOwner {
        excludeHolder[addr] = enable;
    }

    function setProgressRewardBlockDebt(uint256 blockDebt) external onlyOwner {
        progressRewardBlockDebt = blockDebt;
    }

    function setAirdropLen(uint256 len) external onlyOwner {
        _airdropLen = len;
    }

    function setAirdropAmount(uint256 amount) external onlyOwner {
        _airdropAmount = amount;
    }

    function setTxRewardCondition(uint256 c) external onlyOwner {
        _txRewardCondition = c;
    }

    function setTxRewardLen(uint256 l) external onlyOwner {
        _txRewardLen = l;
    }

    function setTxRewardDuration(uint256 d) external onlyOwner {
        _txRewardDuration = d;
    }

    function setTxRewardRate(uint256 r) external onlyOwner {
        require(r <= 10000, "max 1w");
        _txRewardRate = r;
    }

    function currentHour() public view returns (uint256){
        return block.timestamp / _txRewardDuration;
    }

    function getTxInfoLength(uint256 theHour) public view returns (uint256){
        return _txInfos[theHour].length;
    }

    function getTxInfos(uint256 theHour, uint256 start, uint256 length) public view returns (
        address[] memory accounts, uint256[] memory usdtAmounts
    ){
        accounts = new address[](length);
        usdtAmounts = new uint256[](length);
        TxInfo[] storage txInfos = _txInfos[theHour];
        uint256 index;
        uint256 end = start + length;
        TxInfo storage txInfo;
        uint256 usdtUnit = 10 ** IERC20(_usdt).decimals();
        for (uint256 i = start; i < end; ++i) {
            txInfo = txInfos[i];
            accounts[index] = txInfo.account;
            usdtAmounts[index] = txInfo.usdtAmount / usdtUnit;
            index++;
        }
    }
}

contract AVT is AbsToken {
    constructor() AbsToken(
    //SwapRouter
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
    //USDT
        address(0x55d398326f99059fF775485246999027B3197955),
        "AVT",
        "AVT",
        18,
        200000000,
        address(0xB5391325495acAe06EF406a8bE7AFa8b90a17751),
        address(0xB5391325495acAe06EF406a8bE7AFa8b90a17751),
        address(0xdc0bBee0188F5ecDB490BAEb7C6A277bc9A6095E),
        0,
        0,
        0
    ){

    }
}