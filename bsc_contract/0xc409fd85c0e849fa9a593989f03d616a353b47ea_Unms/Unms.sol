/**
 *Submitted for verification at BscScan.com on 2023-03-26
*/

// SPDX-License-Identifier: MIT


pragma solidity 0.8.17;

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
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IUniswapV2Pair {
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function sync() external;
}

interface IDapp {
    function getBurnAmount() external view returns(uint256);
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


abstract contract BaseToken is IERC20, Ownable {
    bool public _disableBuyLimit;
    uint8 private _decimals;  
    uint32 public _startTradeBlock;

    uint256 private _totalSupply;
    uint256 private constant MAX = ~uint256(0);
    uint256 public _totalBuyAmount;
    uint256 public _releasedAmount;
    uint256 public _addPriceTokenAmount;   
    uint256 public _dayLimitAmountForPerson;
    uint256 public _daySoldAmount;

    ISwapRouter private _swapRouter;
    IDapp public _dapp;
    address public _releaseAddress;
    address private _marketAddress;
    address private _usdtAddress;
    address private _mainPairAddress;

    string private _name;
    string private _symbol;
    address[] private _dayBuyAddressList;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _feeWhiteList;
    mapping(address => bool) private _swapPairMap;
    
    mapping(uint32 => uint256) private _dayLimitAmount; 
    mapping(address => uint256) private _dayBuyAmountMap;

    constructor (string memory Name, string memory Symbol, uint256 Supply, address RouterAddress, address UsdtAddress, address marketAddress, address issueAddress, address releaseAddress, address dappAddress){
        _name = Name;
        _symbol = Symbol;
        _decimals = 18;
        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        _usdtAddress = UsdtAddress;
        _swapRouter = swapRouter;
        _allowances[address(this)][RouterAddress] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        _mainPairAddress = swapFactory.createPair(address(this), UsdtAddress);
        _swapPairMap[_mainPairAddress] = true;

        uint256 total = Supply * 1e18;
        _totalSupply = total;
        
        _marketAddress = marketAddress;
        _releaseAddress = releaseAddress;

        _balances[address(0x000000000000000000000000000000000000dEaD)] = total/2; 
        emit Transfer(address(0), address(0x000000000000000000000000000000000000dEaD), _balances[address(0x000000000000000000000000000000000000dEaD)]);
        
        _balances[issueAddress] = total/4; 
        emit Transfer(address(0), issueAddress, _balances[issueAddress]);
        
        _balances[dappAddress] = total/5; 
        emit Transfer(address(0), dappAddress,  _balances[dappAddress]);
        
        _balances[address(this)] = total/20;  
        emit Transfer(address(0), address(this), _balances[address(this)]);


        _dapp = IDapp(dappAddress);

        _marketAddress = marketAddress;

        _feeWhiteList[marketAddress] = true;
        _feeWhiteList[issueAddress] = true;
        _feeWhiteList[dappAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;

        _addPriceTokenAmount = 1e14;
        _startTradeBlock = 0;
    }

    function pairAddress() external view returns (address) {
        return _mainPairAddress;
    }
    
    function routerAddress() external view returns (address) {
        return address(_swapRouter);
    }
    
    function usdtAddress() external view returns (address) {
        return _usdtAddress;
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
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
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

    
    function _isLiquidity(address from,address to) internal view returns(bool isAdd,bool isDel){
        address token0 = IUniswapV2Pair(_mainPairAddress).token0();
        (uint r0,,) = IUniswapV2Pair(_mainPairAddress).getReserves();
        uint bal0 = IERC20(token0).balanceOf(_mainPairAddress);
        if( _swapPairMap[to] ){
            if( token0 != address(this) && bal0 > r0 ){
                isAdd = bal0 - r0 > _addPriceTokenAmount;
            }
        }
        if( _swapPairMap[from] ){
            if( token0 != address(this) && bal0 < r0 ){
                isDel = r0 - bal0 > 0; 
            }
        }
    }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {       
        require(amount > 0, "UNMS: transfer amount must be >0");
        if(address(this)==from) {
            _tokenTransfer(from, to, amount); 
            return;
        }
        bool isAddLiquidity;
        bool isDelLiquidity;
        ( isAddLiquidity, isDelLiquidity) = _isLiquidity(from,to);
        
        if (_feeWhiteList[from] || _feeWhiteList[to] || isAddLiquidity || isDelLiquidity){
            
            _tokenTransfer(from, to, amount);

        }else if(_swapPairMap[from] || _swapPairMap[to]){
            
            require(_startTradeBlock > 0, "UNMS: trade don't start");  
            if (_swapPairMap[to]) {
                require(amount <= (_balances[from])*99/100, "UNMS: sell amount exceeds balance 99%");
            }else{
                
                _totalBuyAmount += amount; 
                if(!_disableBuyLimit){ 
                    uint32 today = uint32(block.timestamp/86400);   
                    if(_dayLimitAmount[today] == 0) resetDayBuyLimit(); 

                    require(_daySoldAmount + amount <= _dayLimitAmount[today], "UNMS: exceed day limit amount");
                    require(_dayBuyAmountMap[to] + amount <= _dayLimitAmountForPerson, "UNMS: exceed day limit amount for person");
                    if(_dayBuyAmountMap[to] == 0) _dayBuyAddressList.push(to); 
                    _daySoldAmount += amount;
                    _dayBuyAmountMap[to] += amount;
                }
            }
            _tokenTransfer(from, to, amount*93/100);     
            _tokenTransfer(from, _marketAddress, amount*7/100);              
        }
    }
    
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        _balances[recipient] = _balances[recipient] + tAmount;
        emit Transfer(sender, recipient, tAmount);
        if(!_disableBuyLimit && _dayLimitAmount[uint32(block.timestamp/86400)] == 0) resetDayBuyLimit(); 
    }

    
    function getLockedAmount() external view returns(uint256) {
        return _balances[address(this)];
    }

    function getUnlockedAmount() public view returns(uint256) {
        
        return (_dapp.getBurnAmount() + _totalBuyAmount)/20;
    }

    
    function getReleaseableAmount() public view returns(uint256) {
        uint256 unlockdedAmount = getUnlockedAmount();
        if(unlockdedAmount > _releasedAmount) return unlockdedAmount-_releasedAmount; 
        return 0;
    }

    
    function releaseToken(uint256 amount) external{
        uint256 releaseableAmount = getReleaseableAmount();
        require(releaseableAmount > 0, "UNMS: releaseable amount is zero");
        require(releaseableAmount >= amount, "UNMS: releaseable amount is less than amount");
        _tokenTransfer(address(this), _releaseAddress, amount);
        _releasedAmount += amount;
    }

    
    function getTodayLimitAmount(address addr) external view returns(uint256 todayLimitAmount, uint256 myLimitAmount) {
        todayLimitAmount =  _dayLimitAmount[uint32(block.timestamp/86400)];
        if(_dayLimitAmountForPerson > _dayBuyAmountMap[addr])  myLimitAmount = _dayLimitAmountForPerson - _dayBuyAmountMap[addr];
    }

    
    function resetDayBuyLimit() internal {    
        uint32 today = uint32(block.timestamp/86400);   
        
        
        if(_dayLimitAmount[today-4] > 0) delete _dayLimitAmount[today-4];
        if(_dayLimitAmount[today-3] > 0) delete _dayLimitAmount[today-3];

        address[] memory addressList = _dayBuyAddressList;
        for(uint i=0;i<addressList.length;i++){
            delete _dayBuyAmountMap[addressList[i]];
        }
        delete _dayBuyAddressList;
        delete _daySoldAmount;
        _dayLimitAmount[today] = _dapp.getBurnAmount()/50; 
        _dayLimitAmountForPerson = _dayLimitAmount[today]/50; 
    }

    function setReleaseAddress(address addr) external onlyOwner {
        _releaseAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function getReleaseAddress() external view returns(address) {
        return _releaseAddress;
    }

    function setMarketAddress(address addr) external onlyOwner {
        _marketAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function getMarketAddress() external view returns(address) {
        return _marketAddress;
    }

    function isFeeWhiteAddress(address addr) external view returns(bool) {
        return _feeWhiteList[addr];
    }

    function setDappAddress(address addr) external onlyOwner {
        _dapp = IDapp(addr);
        _feeWhiteList[addr] = true;
    }

    function setDisableBuyLimit(bool disable) external onlyOwner {
       _disableBuyLimit = disable;
    }

    function startTrade() external onlyOwner {
        require(0 == _startTradeBlock, "trading");
        _startTradeBlock = uint32(block.number);
    }

    function closeTrade() external onlyOwner {
        _startTradeBlock = 0;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyOwner {
        _feeWhiteList[addr] = enable;
    }    

    function getFeeWhiteList(address addr) external view returns(bool) {
        return _feeWhiteList[addr];
    }  

    function setSwapPairMap(address addr, bool enable) external onlyOwner {
        _swapPairMap[addr] = enable;
    }

    function setAddPriceTokenAmount(uint addPriceTokenAmount) external onlyOwner{
        _addPriceTokenAmount = addPriceTokenAmount;
    }

    function getTodayBuyAddressList() external view returns(address[] memory){
        return _dayBuyAddressList;
    }

    function getTodayBuyAmount(address userAddress) external view returns(uint256){
        return _dayBuyAmountMap[userAddress];
    }

    receive() external payable {}
}

contract Unms is BaseToken {
    constructor(address dappAddress) BaseToken(
        "UNMS",
        "UNMS",
        1000000000,
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E), 
        address(0x55d398326f99059fF775485246999027B3197955), 
        address(0x993Ef42C3d2b0dFF7e2AdA1B83F211BD2025AaFF), 
        address(0x6FEb077fAE31C4ed7788D874ad75Bba22b0ACc60), 
        address(0xD63eD86047853035F3880E8095F0c42e562c06A6), 
        dappAddress
    ){

    }
}