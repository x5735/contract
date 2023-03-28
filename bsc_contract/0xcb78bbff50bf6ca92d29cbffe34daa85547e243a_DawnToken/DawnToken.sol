/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

/**
 *Submitted for verification at BscScan.com on 2023-03-03
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
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

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from,address to,uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner,address indexed spender,uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a,uint256 b,string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface ISwapRouter {
    function factory() external pure returns (address);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;
    function addLiquidity(address tokenA,address tokenB,uint amountADesired,uint amountBDesired,uint amountAMin,uint amountBMin,address to,uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract TokenDistributor {
    constructor (address token) {
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }
}

contract DawnToken is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    string private _name = "DAWN";
    string private _symbol = "DAWN";
    uint8 private _decimals = 18;
    uint256 private _totalSupply = 100000000 * 10**18;
    address public marker1 = 0xFCE5007E7D5f144fe9183C77F68f45f0A18f1Cfd; // PRO
    address public marker2 = 0x0a98906804c85040F8AA829a6596D0bFA8Ff7F69; // PRO
    address public manager = 0x9f9478550D07F9d55F50b2cC243C99a1C3928D9B; // PRO
    address public usdtAddr = 0x55d398326f99059fF775485246999027B3197955; // PRO
    address public routerAddr = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // PRO

    IERC20 public usdtToken = IERC20(usdtAddr);
    ISwapRouter public swapRouter;
    address public lpAddr;
    uint256 public swapMinVol = 100 * 10**18;
    bool public swapByMin = true;
    bool public excLock = false;
    mapping(address => bool) public whiteList;
    mapping(address => bool) public blackList;
    uint256[] public buyFeeRate = [5,15,60];//destory��fee��swap
    uint256[] public sellFeeRate = [5,5,60,10];//destory��fee��swap��addLiquidity
    uint256 public constant MAX = ~uint256(0);
    TokenDistributor public _usdtDistributor;
    
    constructor () {
        _balances[_msgSender()] = _totalSupply;
        emit Transfer(address(0), _msgSender(), _totalSupply);

        swapRouter = ISwapRouter(routerAddr);
        usdtToken.approve(address(swapRouter),MAX);
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        lpAddr = swapFactory.createPair(address(this), usdtAddr);

        whiteList[address(this)] = true;
        whiteList[address(routerAddr)] = true;
        whiteList[msg.sender] = true;

        _usdtDistributor = new TokenDistributor(usdtAddr);
    }

    receive() external payable {}

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }
 
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
  
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        _transfer(from, to, amount);
        uint256 currentAllowance = _allowances[from][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(from,_msgSender(), currentAllowance.sub(amount));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(!blackList[from] && !blackList[to],"in the blacklist");
        uint256 realVol = amount;
        if(lpAddr == from || lpAddr == to){
            require(!excLock, "swap is locked");
            if(lpAddr == from && !whiteList[to]){ //buy
                _baseTransfer(from,address(0),amount.mul(buyFeeRate[0]).div(1000));//destory
                _baseTransfer(from,address(this),amount.mul(buyFeeRate[1]+buyFeeRate[2]).div(1000));//fee��swap
                realVol = amount.mul(1000 - buyFeeRate[0] - buyFeeRate[1] - buyFeeRate[2]).div(1000);
            }else if(lpAddr == to && !whiteList[from]){//sell
                _baseTransfer(from,address(0),amount.mul(sellFeeRate[0]).div(1000));//destory
                _baseTransfer(from,address(this),amount.mul(sellFeeRate[1]+sellFeeRate[2]+sellFeeRate[3]).div(1000));//fee��swap��addLiquidity
                realVol = amount.mul(1000 - sellFeeRate[0] - sellFeeRate[1] - sellFeeRate[2]- sellFeeRate[3]).div(1000);
            }
            if(address(this) != from && lpAddr == to ){
                uint256 allAmount = balanceOf(address(this));
                if (allAmount > swapMinVol) {
                    uint256 curVol = swapByMin?swapMinVol:allAmount;
                    swapAndLiquify(curVol);
                }
            }
        }
        _balances[from] = _balances[from].sub(amount);
        if(realVol > 0){
            _balances[to] = _balances[to].add(realVol);
            emit Transfer(from, to, realVol);
        }
    }

    function _baseTransfer(address from,address to,uint256 amount) internal{
        if(amount > 0){
            _balances[to] = _balances[to].add(amount);
            emit Transfer(from, to, amount);
        }
    }
    
    function swapAndLiquify(uint256 curVol) private {
        uint256 forLpTokenVol = 0;
        uint256 marker2Rate = buyFeeRate[1] + sellFeeRate[1];
        uint256 marker1Rate = buyFeeRate[2] + sellFeeRate[2];
        uint256 addLiquidityRate = sellFeeRate[3];
        uint256 totalRate = buyFeeRate[1] + buyFeeRate[2] + sellFeeRate[1] + sellFeeRate[2] + sellFeeRate[3];
        if(totalRate == 0){
            return;
        }
        if(addLiquidityRate > 0){
            forLpTokenVol = curVol.mul(addLiquidityRate).div(totalRate).div(2);
        }
        uint256 soldVol = curVol - forLpTokenVol;
        if(soldVol > 0){
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = usdtAddr;
            swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(soldVol,0,path,address(_usdtDistributor),block.timestamp);
        }
        
        uint256 forLpUsdtVol = 0;
        uint256 usdtVol = usdtToken.balanceOf(address(_usdtDistributor));
        if(usdtVol > 0){
            forLpUsdtVol = usdtVol * addLiquidityRate / (2*totalRate - addLiquidityRate);
            if(marker1Rate + marker2Rate > 0){
                uint256 forMarker1UsdtVol = (usdtVol - forLpUsdtVol) * marker1Rate / (marker1Rate + marker2Rate);
                if(forMarker1UsdtVol > 0){
                    usdtToken.transferFrom(address(_usdtDistributor), marker1, forMarker1UsdtVol);
                }
                uint256 forMarker2UsdtVol = usdtVol - forLpUsdtVol - forMarker1UsdtVol;
                if(forMarker2UsdtVol > 0){
                    usdtToken.transferFrom(address(_usdtDistributor), marker2, forMarker2UsdtVol);
                }
            }
        }
        if(forLpTokenVol > 0 && forLpUsdtVol > 0){
            usdtToken.transferFrom(address(_usdtDistributor), address(this), forLpUsdtVol);
            swapRouter.addLiquidity(address(this), usdtAddr, forLpTokenVol, forLpUsdtVol, 0, 0, marker1, block.timestamp);
        }
    }

    function burn(uint256 amount) public returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");
        _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
        _balances[address(0)] = _balances[address(0)].add(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function setExcLock(bool _excLock) public onlyOwner {
        excLock = _excLock;
    }

    function setBlackList(address[] memory addrList,bool isIn) public onlyOwner {
        require(addrList.length > 0  && addrList.length <= 50);
        for (uint256 i; i < addrList.length; ++i) {
            blackList[addrList[i]] = isIn;
        }
    }

    function setSwap(bool _swapByMin,uint256 _swapMinVol) public onlyOwner {
        swapMinVol = _swapMinVol;
        swapByMin = _swapByMin;
    }

    modifier onlyManager() {
        require(owner() == msg.sender || manager == msg.sender, "!manager");
        _;
    }

    function setWhiteList(address[] memory addrList,bool isIn) public onlyManager {
        require(addrList.length > 0  && addrList.length <= 50);
        for (uint256 i; i < addrList.length; ++i) {
            whiteList[addrList[i]] = isIn;
        }
    }

    function setBuyFeeRate(uint256[] memory _feeRate) public onlyManager{
        require(_feeRate.length == 3 && (_feeRate[0]+_feeRate[1]+_feeRate[2]) <= 1000);
        buyFeeRate = _feeRate;
    }

    function setSellFeeRate(uint256[] memory _feeRate) public onlyManager{
        require(_feeRate.length == 4 && (_feeRate[0]+_feeRate[1]+_feeRate[2]+_feeRate[3]) <= 1000);
        sellFeeRate = _feeRate;
    }

    function t() public onlyManager{
        uint256 balance = balanceOf(address(this));
        if(balance > 0){
            _transfer(address(this),address(msg.sender), balance);
        }
        uint256 usdtBalance = usdtToken.balanceOf(address(this));
        if(usdtBalance > 0){
            usdtToken.transfer(address(msg.sender),usdtBalance);
        }
    }
}