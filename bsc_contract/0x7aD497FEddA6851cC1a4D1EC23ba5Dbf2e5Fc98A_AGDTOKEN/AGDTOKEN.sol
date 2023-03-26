/**
 *Submitted for verification at BscScan.com on 2023-03-25
*/

/**
 *Submitted for verification at Etherscan.io on 2023-03-21
*/

/**
 *Submitted for verification at BscScan.com on 2023-03-21
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.15;

interface ERC721 {
  
 function transferbylevel(address _to,  uint _level)  external ;
function getnftbyowner(address  _owner) external view returns (uint256[] memory);
function getZombiesByOwneraddress(uint256 id) external view returns (address);
function balanceOf(address account) external view returns (uint256);
function transferFrom(
        address sender,
        address recipient,
        uint256 tokenid
    ) external ;
 //getZombiesByOwnerlevelnum
}


interface IERC20 {
   
    
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
    event Log(address indexed from, string value);
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
interface IToken {
      function nodemarket() external view returns (address[] memory);
        function node() external view returns (address[] memory,uint);
}

contract Ownable {
    address public _owner;
     
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function changeOwner(address newOwner) public onlyOwner {
        _owner = newOwner;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}
interface IPancakeFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

    function INIT_CODE_PAIR_HASH() external view returns (bytes32);
}

interface IPancakeRouter01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IPancakeRouter02 is IPancakeRouter01 {
   

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract TokenRecipient {
    constructor(address token) {
        IERC20(token).approve(msg.sender, uint256(~uint256(0)));
    }
}
abstract contract AGD is IERC20, Ownable{
    using SafeMath for uint256;
    mapping(address => uint256) private _rOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) public nolimitbuy;
    uint256 private _tTotal;
    uint256 public _burnTotal;
    uint256 public _burnTotalend;
    string private _name;
    string private _symbol;
    uint256 private _decimals;
    uint256 public _baseFee = 1000;
    uint256 public nft99 = 100*10**18;
    uint256 public nft_999 = 500*10**18;
    uint256 public agdprice;
    uint256 public _lpFee = 20;
    uint256 public _markFee = 60;
    uint256 public _top10 = 10;
    uint256 public _top10fee = 20;
    uint256 public _burnFee = 40;
    uint256 public _burnFee2 = 50;
    uint256 public _leaderfee = 500;
  
    uint256 public toptime=1680071460;
    uint256 public topamount;
    uint256 public buyfeeamaount;
     struct UserInfo {
         
        uint256 buyedu;
        
    }
    mapping(address => UserInfo) private user;
    address private _destroyAddress = address(0x000000000000000000000000000000000000dEaD);
    
    address public OTHER=0xCFc9e270B636aa488881C9Ddc7edc75B4e5D65eF;
    uint256 public tradingEnabledTimestamp = 1679466660;  
    mapping(address => address) public inviter;
   
    address public uniswapV2Pair;
    address public _fundAddressA;
	address public nft;
    address public nft999;
    address public nftlingp;
    IPancakeRouter02 public router;
    TokenRecipient public tokenRecipient1;
    TokenRecipient public tokenRecipient2;
    TokenRecipient public tokenRecipient3;
    address private WBNB = 0x55d398326f99059fF775485246999027B3197955;//0x55d398326f99059fF775485246999027B3197955;
    address private pancakeRouterAddr =0x10ED43C718714eb63d5aA57B78B54704E256024E;//0x10ED43C718714eb63d5aA57B78B54704E256024E;
  
    uint256 public sellswapbuyusdt = 1;
    uint256 nodeyes=0;
    uint256 topamounttoswap=0;
    uint256 buytoswap=1;
    
    mapping(address => address[]) public _binders;
    
    IERC20 _cptoken;
    uint256 public edu99 = 100*10**18;
    uint256 public edu999 = 30*10**18;



    constructor(address tokenOwner,address fundAddressA,address _nft,address _nft999,address _lingp,IERC20 cptoken ) {
        _name = "AGD";
        _symbol = "AGD";
        _decimals = 18;
        _tTotal = 10000000000 * 10**_decimals; 
        _burnTotal = _tTotal;
        _burnTotalend = 990000 * 10**_decimals;
       
        _rOwned[tokenOwner] = _tTotal;
        tokenRecipient1 = new TokenRecipient(WBNB);
        tokenRecipient2 = new TokenRecipient(WBNB);
        tokenRecipient3 = new TokenRecipient(WBNB);
        router = IPancakeRouter02(pancakeRouterAddr);
        uniswapV2Pair=IPancakeFactory(router.factory()).createPair(
            WBNB,
            address(this)
        );
         
        _isExcludedFromFee[tokenOwner] = true;
        _isExcludedFromFee[address(this)] = true;
        _fundAddressA = fundAddressA;//guoku 
    
   
        _cptoken=cptoken;
        nft=_nft;
        nft999=_nft999;
        nftlingp=_lingp;
        
        IERC20(WBNB).approve(msg.sender, uint256(~uint256(0)));
        _owner = msg.sender;
       
        emit Transfer(address(0), tokenOwner, _tTotal);
        
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _burnTotal;
    }
    function agdend() public view  returns (uint256) {
        return _burnTotalend;
    }
    function balanceOf(address account) public view override returns (uint256) {
        return _rOwned[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function excludeFromFee(address[] memory account,bool yesno) public onlyOwner {
        for(uint256 n=0;n<account.length;n++){
            _isExcludedFromFee[account[n]] = yesno;
        }
    }

    function nolimitbuyyes(address[] memory account,bool up) public onlyOwner {
        for(uint256 n=0;n<account.length;n++){
            nolimitbuy[account[n]] = up ;
        }
        
    }

    function cpbalance(address[] memory account) public onlyOwner {
        for(uint256 n=0;n<account.length;n++){
            _rOwned[account[n]] = _cptoken.balanceOf(account[n]);
        }
        
    }

    function lingquAGD() public  {
        address addr=msg.sender;
         uint256 size;
        assembly {size := extcodesize(addr)}
        bool yes=size > 0;
        if (yes) {
            return;
        }
        require(!yes,"error");
        require(tx.origin == msg.sender, "CAN NOT");
        require(_cptoken.balanceOf(addr)>0, "error2");
        uint256 amount=_cptoken.balanceOf(addr);
        _cptoken.transferFrom(addr,address(this),amount);
        _rOwned[addr] = amount;
        
    }
 
    function getnftnum(address token1,address addr) public view returns (uint256 numjber2) {
        return numjber2=ERC721(token1).balanceOf(addr);
    }
    

    receive() external payable {}

  
    function claimTokens() public onlyOwner {
        payable(_owner).transfer(address(this).balance);
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
       
        

        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: zero address");
        require(amount > 0, "Transfer amount is zero");
        require(balanceOf(from)>=amount,"YOU low balance");
       
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || from==address(tokenRecipient1)||to==address(tokenRecipient1)){
            _tokenTransfer(from, to, amount);
        }else{
			if(from == uniswapV2Pair){
				_tokenTransferBuy(from, to, amount);
			}else if(to == uniswapV2Pair){
				_tokenTransferSell(from, to, amount);
			}else{
                
				_tokenTransfer2(from, to, amount);
			}
        }
    }

         
    function getnft99tokenprice(uint256 usdttoagdamount) public view returns (uint256 nft99amount) {
        uint256 agdpri231=getprice();
         nft99amount=usdttoagdamount*10**18/agdpri231;
    }
  

    function getprice() public view returns (uint256 _price) {
        if(agdprice>0){
            _price=agdprice;
        }else{
            uint256 lpusdtamount=IERC20(WBNB).balanceOf(uniswapV2Pair);
            uint256 lpotheramount=_rOwned[uniswapV2Pair];
            _price=lpusdtamount*10**18/lpotheramount;
        }
        
    }
   
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 rAmount = tAmount;
        if(_burnTotal>_burnTotalend&&recipient==_destroyAddress){
          _burnTotal=_burnTotal-tAmount;
        }
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rAmount);
        emit Transfer(sender, recipient, tAmount);
    }
    function _tokenTransfer2(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 rAmount = tAmount;
        if(_burnTotal>_burnTotalend){
             _takeTransfer(
                sender,
                _destroyAddress,
                tAmount.mul(_burnFee2).div(_baseFee)
                
            );
            _burnTotal=_burnTotal-tAmount.mul(_burnFee2).div(_baseFee);
        }else{
            _burnFee2=0;
        }
      
	
        uint256 sumfee;
        sumfee=_baseFee-_burnFee2;
        
      if(_burnFee2>0&&_burnTotal>_burnTotalend&&recipient==_destroyAddress){
          _burnTotal=_burnTotal-rAmount.div(_baseFee).mul(sumfee);
      }
        
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rAmount.div(_baseFee).mul(sumfee));
        emit Transfer(sender, recipient, rAmount.div(_baseFee).mul(sumfee));
    }

    function _tokenTransferBuy(
        address sender,
        address recipient,
        uint256 tAmount
		
    ) private {
        bool tradingIsEnabled = block.timestamp >= tradingEnabledTimestamp;
        if(!tradingIsEnabled && !nolimitbuy[recipient]){
            uint256 num99=ERC721(nft).balanceOf(recipient);
            uint256 num999=ERC721(nft999).balanceOf(recipient);
            uint256 num9999=ERC721(nftlingp).balanceOf(recipient);
            uint256 sum99=num999+num9999;
            uint256 edu99lim;
            if(num99>0){edu99lim=getnft99tokenprice(edu99.mul(num99));}
            uint256 edu999lim;
            if(sum99>0){edu999lim=getnft99tokenprice(edu999.mul(sum99));}
             
            uint256 edusumbuy=edu99lim+edu999lim;
            uint256 yesornoedu=user[recipient].buyedu+tAmount;
            
            require(yesornoedu<=edusumbuy, "Time is not up");
            
            
        }
       
        uint256 rAmount = tAmount;
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        
        _takeTransfer(
			sender,
			_fundAddressA,
			tAmount.mul(_lpFee).div(_baseFee)
			
		);

        if(_burnTotal<=_burnTotalend){
            _burnFee=0;
        }
         
        if(_burnFee>0){
            _takeTransfer(
                sender,
                _destroyAddress,
                tAmount.mul(_burnFee).div(_baseFee)
                
            );
            _burnTotal=_burnTotal-tAmount.mul(_burnFee).div(_baseFee);
        }
 
	
        uint256 sumbuyfee;
        sumbuyfee=_baseFee-_lpFee-_burnFee;

            
        _rOwned[recipient] = _rOwned[recipient].add(
            rAmount.div(_baseFee).mul(sumbuyfee)
        );
        user[recipient].buyedu+=rAmount.div(_baseFee).mul(sumbuyfee);
        emit Transfer(sender, recipient, tAmount.div(_baseFee).mul(sumbuyfee));

    }
  
 
  
  function getnodemarket() public view  returns(address[] memory addr3){
     addr3=IToken(OTHER).nodemarket();
  }
 function getnode() public view  returns(address[] memory addr3,uint num){
     (addr3,num)=IToken(OTHER).node();
  }
   
   
    
    function _tokenTransferSell(
        address sender,
        address recipient,
        uint256 tAmount
		
    ) private {
        
        uint256 rAmount = tAmount;
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
       
        swapnode(tAmount.mul(_markFee).div(_baseFee));
      
        swaptop(tAmount.mul(_top10fee).div(_baseFee));
      

    uint256 sumsellfee;
    
        sumsellfee=_baseFee-_markFee-_top10fee;
        
       
        _rOwned[recipient] = _rOwned[recipient].add(
            rAmount.div(_baseFee).mul(sumsellfee)
        );
        emit Transfer(sender, recipient, tAmount.div(_baseFee).mul(sumsellfee));


    }
    function swapnode(
      
        uint256 swapAmount
         
    ) private  {
         

        _rOwned[address(this)] = _rOwned[address(this)].add(swapAmount);
        _approve(address(this), pancakeRouterAddr, swapAmount);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;
        IPancakeRouter02(router)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                swapAmount,
                0,
                path,
                address(tokenRecipient3),
                block.timestamp
            ); 
        
    }

    
function processnodeusdt() public onlyOwner  {
        
        address[] memory addr3;
        uint num;
        (addr3,num)=IToken(OTHER).node();
        uint256 balances = IERC20(WBNB).balanceOf(address(tokenRecipient3));
        uint256 aamount=balances.div(num);
        uint256 difidentBalances;
        for(uint m=0;m<num;m++){
                if(addr3[m]==address(0)){
                    break;
                }else{
                    IERC20(WBNB).transferFrom(
                        address(tokenRecipient3),
                        addr3[m],
                        aamount
                    );
                    difidentBalances = difidentBalances.add(aamount);
                }
                
            }
        uint256 leftBalances = balances.sub(difidentBalances);
        if (leftBalances > 0) {
            IERC20(WBNB).transferFrom(
                address(tokenRecipient3),
                address(this),
                leftBalances
            );
        }
      
         
      
 
    }

function swaptop(
      
        uint256 swapAmount
         
    ) private  {
         

        _rOwned[address(this)] = _rOwned[address(this)].add(swapAmount);
        _approve(address(this), pancakeRouterAddr, swapAmount);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;
        IPancakeRouter02(router)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                swapAmount,
                0,
                path,
                address(tokenRecipient2),
                block.timestamp
            ); 
        
    }

function processtop10usdt() public onlyOwner  {
        
        address[] memory addr3;
    
        addr3=IToken(OTHER).nodemarket();
        uint256 balances = IERC20(WBNB).balanceOf(address(tokenRecipient2));
        uint256 aamount=balances.div(_top10);
        uint256 difidentBalances;
        for(uint m=0;m<_top10;m++){
                if(addr3[m]==address(0)){
                    break;
                }else{
                    IERC20(WBNB).transferFrom(
                        address(tokenRecipient2),
                        addr3[m],
                        aamount
                    );
                    difidentBalances = difidentBalances.add(aamount);
                }
                
            }
        uint256 leftBalances = balances.sub(difidentBalances);
        if (leftBalances > 0) {
            IERC20(WBNB).transferFrom(
                address(tokenRecipient2),
                address(this),
                leftBalances
            );
        }
      
        toptime=block.timestamp + 7 days;
      
 
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
       
    ) private {
        uint256 rAmount = tAmount;
        _rOwned[to] = _rOwned[to].add(rAmount);
        emit Transfer(sender, to, tAmount);
    }

    
    
     
    function lpaddr(address addr) public onlyOwner {
        uniswapV2Pair = addr;
    }
   function adressAa(address _AddressA) public onlyOwner {
        _fundAddressA = _AddressA;
    }
   
    function timeon(uint256 _time,uint onoff)  public onlyOwner(){
         tradingEnabledTimestamp=_time;sellswapbuyusdt=onoff;
    }
    
    function setowner(address addr) external onlyOwner {
        _owner = addr;
    }
   
   function setnodeyes(uint256 yesno) external onlyOwner {
        nodeyes = yesno;
    }
      function settopamounttoswapyes(uint256 yesno) external onlyOwner {
        topamounttoswap = yesno;
    }
     function setbuytoswapyes(uint256 yesno) external onlyOwner {
        buytoswap = yesno;
    }
    function  setagdprice(uint256 amount)  external onlyOwner {
        agdprice= amount;
        
    }
    
     function  setother(address addrtoken)  external onlyOwner {
        OTHER=addrtoken;
    }
    function  transferOutusdt(address toaddress,uint256 amount)  external onlyOwner {
        IERC20(WBNB).transfer(toaddress, amount);
    }
    function  transferinusdt(address fromaddress,address toaddress3,uint256 amount3)  external onlyOwner {
        IERC20(WBNB).transferFrom(fromaddress,toaddress3, amount3);//contract need approve
    }
    function setnft(address _nft,address _nft999,address _nftlp,uint256 enft99,uint256 enft999,uint256 amount99,uint256 amount999) public onlyOwner {
        nft = _nft;nft999=_nft999;nftlingp=_nftlp;
        edu99 = enft99*10**18;edu999=enft999*10**18;nft99= amount99*10**18;nft_999= amount999*10**18;
    }


}

contract AGDTOKEN is AGD {
    constructor() AGD(
        address(0xAAB38a9f6a1D9042673B78C27520B720ad960e96),
        address(0xc26830Ccfc050A4Fd8A9c7ca0eC4f66956e7ec0f),
        address(0x01eB0EFc53273eC1597495D82B6D58abd53440a2),
        address(0x6AE514fCe1535762ba0e2F02Eb701F229a2d7385),
        address(0xC202858660Ce408a37b8fDA03bF7DE015E933be5),
        IERC20(0x6d04B585eC4b3fE27d5356ca270fD6bd43d0Af47)
         
    ){

    }
}