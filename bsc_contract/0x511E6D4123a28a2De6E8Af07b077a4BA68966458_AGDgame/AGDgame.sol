/**
 *Submitted for verification at BscScan.com on 2023-03-25
*/

/**
 *Submitted for verification at BscScan.com on 2023-03-21
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.15;

interface ERC721 {
  
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

struct UserInfo {
        uint256 receiveall;
        uint256 dtyesno;
        uint256 edusum;
        uint256 baseedu;
        uint256 performance;
        uint256 teamperformance;
        uint256 performance7;
        uint256 bonus;
        uint256 teambonus;
        uint256 dongtai;
        uint256 buyedu;
        uint256 sharenumber;
        uint256 teamnumber;
        uint256 level;
        uint256 l1;
        uint256 l2;
        uint256 l3;
        uint256 l4;
        uint256 l5;
        uint256 l6;
        uint256 l7;
        uint256 receivetime;
    }
interface IERC20 {
    
    function getuser(address account) external view returns (UserInfo calldata);
     //function _binders(address account) external view returns (address[] memory);
     function _binders(address account,uint index) external view returns (address);
     function _bindersnum(address account) external view returns (uint256);
    function vipcount() external view returns (uint256);
    function viplist(uint256 index) external view returns (address);
    function inviter(address account) external view returns (address);
     
   
   
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
    
}
interface IToken {
    function getuser(address account) external view returns (UserInfo calldata);
     
    function vipcount() external view returns (uint256);
    function viplist(uint256 index) external view returns (address);
    function inviter(address account) external view returns (address);
    function totalSupply() external view returns (uint256);
      function  agdend() external view returns (uint256);
    
    function burndo(uint256 amount)
        external
        returns (bool);
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

contract Ownable {
    address public _owner;
    address public _owner2;
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
        require(_owner == msg.sender||_owner2== msg.sender, "Ownable: caller is not the owner");
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

 
abstract contract AGD2 is   Ownable {
    using SafeMath for uint256;
   
    string private _name;
    string private _symbol;
    
    uint256 public _baseFee = 1000;
    uint256 public nft99 = 100*10**18;
    uint256 public nft_999 = 500*10**18;
    uint256 public agdprice;
     
     
    uint256 public _leaderfee = 500;
    uint256 public bili = 10;
    
    address private _destroyAddress = address(0x000000000000000000000000000000000000dEaD);
   
    IERC20 _cptoken;
     
    mapping(address => address) public inviter;
    
    address public uniswapV2Pair;
    address public _fundAddressA;
    address public KLP;
	address public nft;
    address public nft999;
    address public nftlingp;
    
  
    address  AGD;
    IPancakeRouter02 public router;
    address private WBNB = 0x55d398326f99059fF775485246999027B3197955;//0x55d398326f99059fF775485246999027B3197955;
    address private pancakeRouterAddr =0x10ED43C718714eb63d5aA57B78B54704E256024E;//0x10ED43C718714eb63d5aA57B78B54704E256024E;
    uint256 public vipcount = 0;
   
    uint256 public logon = 0;
    uint256 public bdbd = 1;
    uint256 public nftsl = 99;
    
    mapping(uint256 => address) public viplist;
    address[] public nodelist;
    uint public nodecount = 0;
    mapping(address => address[]) public _binders;
   
     
    
    mapping(address => UserInfo) private user;
    uint256 public maxzt=10;
    uint256 public dec=18;
    uint256 public maxteam = 20;
    uint256[8] public _team =[0,100,200,300,350,400,450,500];//[1]-[7] level1-level7
    uint256 public pingji=100;
    constructor(address tokenOwner,address fundAddressA,address agdaddr,address _nft,address _nft999,address _lingp,address lpaddr,IERC20 cptoken) {
        _name = "AGDGAME";
        _symbol = "AGDGAME";
        AGD=agdaddr;
        uniswapV2Pair=lpaddr;
       
        _fundAddressA=fundAddressA;
        nft=_nft;
        nft999=_nft999;
        nftlingp=_lingp;
        
     _cptoken=cptoken;
        _owner = msg.sender;
       _owner2 = msg.sender;
        KLP=tokenOwner;
          router = IPancakeRouter02(pancakeRouterAddr);
      
    }
    function cp(uint start,uint end) public onlyOwner{
         for (uint n = start; n < end; n++) {
            if (_cptoken.viplist(n) == address(0)) {
                break;
            }
            
            inviter[_cptoken.viplist(n)] = _cptoken.inviter(_cptoken.viplist(n));
            user[_cptoken.viplist(n)]=_cptoken.getuser(_cptoken.viplist(n));
            viplist[n]=_cptoken.viplist(n);
            if(n==0){
                address fi=_cptoken.inviter(_cptoken.viplist(n));
                user[fi]=_cptoken.getuser(fi);
            }
            

        }
        vipcount=end;
    }
    
    function _bindersnum(address account) public view  returns(uint256 count){
        count=_binders[account].length;
    }
    function getotherbind(address account,uint256 index) public view  returns(address addr,uint256 count){
        count = _cptoken._bindersnum(account);
        if(count>0){
            addr=_cptoken._binders(account,index);
        }
    }
    function getswapamount( 
        uint256 amount  
    ) public view  returns(uint256[] memory amount2) {
        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = AGD;
        amount2=router.getAmountsOut(amount,path);
    }
   
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }
 
   
  
    function getuser(address account) public view returns (UserInfo memory) {
        return user[account];
    }
    function getnftnum(address token1,address addr) public view returns (uint256 numjber2) {
        return numjber2=ERC721(token1).balanceOf(addr);
    }
    

    receive() external payable {}

  
    function claimTokens() public onlyOwner {
        payable(_owner).transfer(address(this).balance);
    }

    
    function teamupdate(address addr,uint256 usdtamount) private{
        address cur;
        cur = addr;
         user[cur].performance7+=usdtamount;
        for (uint256 i = 0; i < maxteam;i++) {

            cur = inviter[cur];
            if (cur == address(0)) {
               
                break;
            }

         user[cur].teamperformance+=usdtamount;
         user[cur].performance7+=usdtamount;
         if(user[cur].level>=7){continue;}

         if(user[cur].level<1 && user[cur].sharenumber>=3&& user[cur].teamperformance>=30000*10**18){user[cur].level=1;user[inviter[cur]].l1+=1;}
         if(user[cur].level<2 && user[cur].l1>=2){user[cur].level=2;user[inviter[cur]].l2+=1;}
         if(user[cur].level<3 && user[cur].l2>=2){user[cur].level=3;user[inviter[cur]].l3+=1;}
         if(user[cur].level<4 && user[cur].l3>=2){user[cur].level=4;user[inviter[cur]].l4+=1;}
         if(user[cur].level<5 && user[cur].l4>=2){user[cur].level=5;user[inviter[cur]].l5+=1;}
         if(user[cur].level<6 && user[cur].l5>=2){user[cur].level=6;user[inviter[cur]].l6+=1;}
         if(user[cur].level<7 && user[cur].l6>=2){user[cur].level=7;user[inviter[cur]].l7+=1;}
           
            
        }

    }
    function teamupdate2(address addr2,uint256 yjamount,uint256 teamyjornum) private{
        address cur;
        cur = addr2;
         
        for (uint256 i = 0; i < maxteam;) {

            cur = inviter[cur];
            if (cur == address(0)) {
                 
                break;
            }
            
            if(teamyjornum==1){
                user[cur].teamnumber+=yjamount;
            }
           
            
            unchecked{
                ++i;
            }
            
        }

    }


    function ztjiang(uint256 agd) private{
        address cur;
        cur = msg.sender;
        uint256 agdpri2=getprice();
        uint256 curTAmount;
        uint256 agdtousdtamount;
        for (uint256 i = 0; i < maxzt;i++) {

            cur = inviter[cur];
            if (cur == address(0)) {
               
                break;
            }

            agd=agd.mul(_leaderfee).div(_baseFee);
            if (agd < 1*10**16) {
                
                break;
            }
            // if(user[cur].dtyesno==0){
            //    continue; 
            // }
            
            if(user[cur].sharenumber<3||_binders[cur].length<3){
                 
                continue;
            }
            if(user[cur].edusum==0){
                 
                continue;
            }
            if(agd>0){
                 curTAmount = agd;
                
                
                 agdtousdtamount=curTAmount*agdpri2/10**18;
                if(user[cur].edusum>agdtousdtamount){
                    user[cur].edusum=user[cur].edusum-agdtousdtamount;
                    user[cur].dongtai+=curTAmount;
                }else{
                    agdtousdtamount=user[cur].edusum;
                    curTAmount=getnft99tokenprice(agdtousdtamount);
                    user[cur].dongtai+=curTAmount;
                    user[cur].edusum=0;
                    user[cur].baseedu=0;
                }
                
                user[cur].receiveall+=agdtousdtamount;
                user[cur].bonus+=agdtousdtamount;
                
               
                
            }
            
           
        }

    }

    function teamjiang(uint256 ltj) private{
        address cur;
        cur = msg.sender;
        uint256 rate;
        uint256[10] memory yjl;
         uint256 agdpri23=getprice();
         uint256 curTAmount;
        uint256 agdtousdtamount;
        for (uint256 i = 0; i < maxteam;i++) {

            cur = inviter[cur];
            if (cur == address(0)) {
                
                break;
            }

            // if(user[cur].dtyesno==0){
            //    continue; 
            // }
            if(yjl[user[cur].level]>1 || user[cur].level<1){
                continue;
            }
            for (uint8 n = 1; n < 8; n++) {
                if(user[cur].level==n){
                    rate=_team[n];
                    if(yjl[n-1]>0){rate=_team[n]-_team[n-1];}
                     
                    if(yjl[n]>0){rate=_team[n].mul(pingji).div(_baseFee);}//ping ji jiang,na 1 ci
                    
                }
            }
           
            if(user[cur].edusum==0){
                
                continue;
            }
            if(rate>0){
                 curTAmount = ltj.mul(rate).div(_baseFee);
                 agdtousdtamount=curTAmount*agdpri23/10**18;
                if(user[cur].edusum>agdtousdtamount){
                    user[cur].edusum=user[cur].edusum-agdtousdtamount;
                    user[cur].dongtai+=curTAmount;
                }else{
                   
                    agdtousdtamount=user[cur].edusum;
                    curTAmount=getnft99tokenprice(agdtousdtamount);
                    user[cur].dongtai+=curTAmount;
                    user[cur].edusum=0;
                    user[cur].baseedu=0;
                }
                
                user[cur].receiveall=user[cur].receiveall+agdtousdtamount;
                user[cur].bonus=user[cur].bonus+agdtousdtamount;
                 
              
                
            }
          
                yjl[user[cur].level]=yjl[user[cur].level]+1;
            
            
        }

    }
  
    function pushzt(uint256 start,uint256 end) public  onlyOwner {
           address fatheraddr;
           address toaddr;
        for (uint n = start; n < end; n++) {
             if (_cptoken.viplist(n) == address(0)) {
                break;
            }
            
           fatheraddr= _cptoken.inviter(_cptoken.viplist(n));
           toaddr=_cptoken.viplist(n);
             uint256 cd =_binders[fatheraddr].length;
              if(cd==0){
                  _binders[fatheraddr].push(toaddr);
              }else{
                  uint256 res=0;
                  for (uint256 y=0;y<cd;y++){
                      if(_binders[fatheraddr][y]==toaddr){
                          res++;
                      }
                  }
                  if(res==0){
                      _binders[fatheraddr].push(toaddr);
                  }
              }   
           

        }
    }
    function pushzt2(address toaddr) public  onlyOwner {
            address fatheraddr=_cptoken.inviter(toaddr);
                uint256 cd =_binders[fatheraddr].length;
              if(cd==0){
                  _binders[fatheraddr].push(toaddr);
              }else{
                  uint256 res=0;
                  for (uint256 y=0;y<cd;y++){
                      if(_binders[fatheraddr][y]==toaddr){
                          res++;
                      }
                  }
                  if(res==0){
                      _binders[fatheraddr].push(toaddr);
                  }
              }         
        
    }
    function pushzt3(address toaddr,address fatheraddr) public  onlyOwner {
                uint256 cd =_binders[fatheraddr].length;
              if(cd==0){
                  _binders[fatheraddr].push(toaddr);
              }else{
                  uint256 res=0;
                  for (uint256 y=0;y<cd;y++){
                      if(_binders[fatheraddr][y]==toaddr){
                          res++;
                      }
                  }
                  if(res==0){
                      _binders[fatheraddr].push(toaddr);
                  }
              }         
        
    }
    function bindfather(address addr,address fatheraddr) public  {
        require(fatheraddr != address(0), "zero address");
        require(fatheraddr!=addr,"cannot onself");
        require(inviter[fatheraddr]!=address(0) || fatheraddr==_owner ,"no fater");
         if (inviter[addr] == address(0)) {
            inviter[addr] = fatheraddr;
            if(bdbd==0){_binders[fatheraddr].push(addr);}
            user[fatheraddr].sharenumber+=1;
            teamupdate2(addr,1,1);
            viplist[vipcount]=addr;
            vipcount+=1;
        }
    }
    function buynft99(address toaddr,address fatheraddr,uint256 num2,uint256 buytype) public  {
        address addr=msg.sender;
        require(fatheraddr!=toaddr,"cannot onself");
          require(toaddr != address(0)&&fatheraddr != address(0), "zero address");
        require(user[toaddr].edusum == 0, "must zero");
        require(buytype <= 3&&buytype!=0, "type error");
        require(fatheraddr==inviter[toaddr],"father error");
        uint256 size;
    assembly {size := extcodesize(addr)}
    bool yes=size > 0;
    if (yes) {
        return;
    }
    require(!yes,"error");
   require(tx.origin == msg.sender, "CAN NOT"); 
        uint256 nft99amount2;
        uint256 nftusdtprice;
        
        if(buytype==1){
            nftusdtprice=nft99.mul(num2);
            nft99amount2=getnft99tokenprice(nft99.mul(num2));
            require(IToken(AGD).balanceOf(msg.sender)>=nft99amount2,"low balance");
           
            if(IToken(AGD).totalSupply()>IToken(AGD).agdend()){
                uint256 tt10=nft99amount2.mul(100).div(_baseFee);
                uint256 tt90=nft99amount2.mul(900).div(_baseFee);
               IToken(AGD).transferFrom(msg.sender,_fundAddressA,tt10);
               IToken(AGD).transferFrom(msg.sender,_destroyAddress,tt90);
            }else{
                IToken(AGD).transferFrom(msg.sender,_fundAddressA,nft99amount2);
                 
            }
        }else{
            address typenft;
            if(buytype==2){
                typenft=nftlingp;
            }else{
                typenft=nft999;
            }
             uint256 numjber=ERC721(typenft).balanceOf(msg.sender);
            require(numjber>=num2,"NFT low balance");
            uint[] memory myNFTS=ERC721(typenft).getnftbyowner(msg.sender);
            for (uint8 n = 0; n < num2; n++) {
                ERC721(typenft).transferFrom(msg.sender,_destroyAddress,myNFTS[n]);
            }
            nftusdtprice=nft_999.mul(num2);
            nft99amount2=getnft99tokenprice(nft_999.mul(num2));
        }
        

         
        // if (inviter[toaddr] == address(0)) {
        //     bindfather(toaddr,fatheraddr);
             
        // }
        
        
        user[toaddr].edusum+=nftusdtprice.mul(2);
        user[toaddr].baseedu+=nftusdtprice;
        if(buytype<=2){
            user[toaddr].dtyesno=1;
             teamupdate(toaddr,nftusdtprice);
              user[toaddr].performance+=nftusdtprice;
              if(bdbd==1){
                uint256 cd =_binders[fatheraddr].length;

                if(cd==0){
                    _binders[fatheraddr].push(toaddr);
                }else{
                    uint256 res=0;
                    for (uint256 y=0;y<cd;y++){
                        if(_binders[fatheraddr][y]==toaddr){
                            res++;
                        }
                    }
                    if(res==0){
                        _binders[fatheraddr].push(toaddr);
                    }
                }
            }
        }else{
            user[toaddr].dtyesno=0;
        }
       
       
        user[toaddr].receivetime=block.timestamp;
      
        
    }
    function getnft99tokenprice(uint256 usdttoagdamount) public view returns (uint256 nft99amount) {
        uint256 agdpri231=getprice();
         nft99amount=usdttoagdamount*10**18/agdpri231;
    }
    function getwillrec() public view returns (uint256 amount) {
        address addr=msg.sender;
        uint256 cha=(block.timestamp-user[addr].receivetime)/86400;
        if(cha>0){
            uint256 usdttoagdamontbili= user[addr].baseedu.mul(bili).div(_baseFee).mul(cha);
            if(user[addr].edusum<=usdttoagdamontbili){
                 
         
                usdttoagdamontbili=user[addr].edusum;
                
            }
            amount=getnft99tokenprice(usdttoagdamontbili);
        }
    }

    function  AGD_receive()  external   {
        address addr=msg.sender;
        uint256 cha=(block.timestamp-user[addr].receivetime)/86400;
        bool Limited = cha>0 ;
        require(Limited,"Exchange interval is too short.");
        
    uint256 size;
    assembly {size := extcodesize(addr)}
    bool yes=size > 0;
    if (yes) {
        return;
    }
    require(!yes,"error");
   require(tx.origin == msg.sender, "CAN NOT");    
    if(user[addr].edusum > 0){
        uint256 usdttoagdamontbili= user[addr].baseedu.mul(bili).div(_baseFee).mul(cha);
        if(user[addr].edusum>usdttoagdamontbili){
            user[addr].edusum=user[addr].edusum-usdttoagdamontbili;
        }else{
            usdttoagdamontbili=user[addr].edusum;
            user[addr].edusum=0;
            user[addr].baseedu=0;
        }

        uint256 usdttoagdamont3=getnft99tokenprice(usdttoagdamontbili);//need agd
        uint256 temp22=usdttoagdamont3+user[addr].dongtai;

        IToken(AGD).transferFrom(KLP,addr,temp22);
        user[addr].dongtai=0;

        
        user[addr].receiveall+=usdttoagdamontbili;
        
       if(user[addr].dtyesno==1){
           teamjiang(usdttoagdamont3);
            ztjiang(usdttoagdamont3);
       }
        
    }else{
        if(user[addr].dongtai > 0){
             
             IToken(AGD).transferFrom(KLP,addr,user[addr].dongtai);
             user[addr].dongtai=0;
        }
    }
        user[addr].receivetime=block.timestamp;
        
      
    }


    // function getLPbalance() public view returns (uint256 lpusdtamount,uint256 lpotheramount) {
    //     lpusdtamount=usdt.balanceOf(uniswapV2Pair);
    //     lpotheramount=_rOwned[uniswapV2Pair];
          
    // }

    function getprice() public view returns (uint256 _price) {
        if(agdprice>0){
            _price=agdprice;
        }else{
            // uint256 lpusdtamount=IToken(WBNB).balanceOf(uniswapV2Pair);
            // uint256 lpotheramount= IToken(AGD).balanceOf(uniswapV2Pair);
            // _price=lpusdtamount*10**18/lpotheramount;
            address[] memory path = new address[](2);
            uint256[] memory amount2 = new uint256[](2);
            path[0] = WBNB;
            path[1] = AGD;
            amount2=router.getAmountsOut(1*10**16,path);
            _price=amount2[0]*10**dec/amount2[1];
        }
        
    }
   
   
 

   function teammax(address addr2) public view  returns(uint256 maxa){
    
         uint256 sump;
         uint256 max;
       for (uint n = 0; n < _binders[addr2].length; n++) {
           
                
                sump+=user[_binders[addr2][n]].performance7;

                if(n==0){
                    max=user[_binders[addr2][n]].performance7;}
                else{
                    if(user[_binders[addr2][n]].performance7>max){max=user[_binders[addr2][n]].performance7;}
                }

               
            
            
        }
        if(sump>=max){maxa=sump-max;}
        
   }
function nodemarket() public view  returns(address[] memory){
        address[] memory viplist2= new address[](nftsl);
       uint256[] memory performance2= new uint256[](nftsl);
        address[] memory viplist4= new address[](nftsl);
       uint num;
        
       (viplist4,num)=node();
       
        for (uint n = 0; n < num; n++) {
            if (viplist4[n] == address(0)) {
                 
                break;
            }
                viplist2[n]=viplist4[n];
                if(user[viplist4[n]].sharenumber>0){
                    performance2[n] = teammax(viplist4[n]);
                }else{
                    performance2[n] = 0;
                }
                
                 
            
        }
    
    for(uint256 i=1;i<num;i++){
      address  tempaddr=viplist2[i];
      uint256  tempamount=performance2[i];
      uint256 j=i;
      while((j>=1)&&(tempamount>performance2[j-1])){
          viplist2[j]=viplist2[j-1];
          performance2[j]=performance2[j-1];
        
        j--;
      }
      viplist2[j]=tempaddr;
      performance2[j]=tempamount;
      
    }
    address[] memory viplist5= new address[](10);
       
    for(uint256 y=0;y<10;y++){
       
        viplist5[y]=viplist2[y];
    }
   
    
    return viplist5;
  }
    function nodemarket2() public view  returns(address[] memory,uint256[] memory){
        address[] memory viplist2= new address[](nftsl);
       uint256[] memory performance2= new uint256[](nftsl);
        address[] memory viplist4= new address[](nftsl);
       uint num;
        
       (viplist4,num)=node();
       
        for (uint n = 0; n < num; n++) {
            if (viplist4[n] == address(0)) {
                 
                break;
            }
                viplist2[n]=viplist4[n];
                if(user[viplist4[n]].sharenumber>0){
                    performance2[n] = teammax(viplist4[n]);
                }else{
                    performance2[n] = 0;
                }
                
                 
            
        }
    
    for(uint256 i=1;i<num;i++){
      address  tempaddr=viplist2[i];
      uint256  tempamount=performance2[i];
      uint256 j=i;
      while((j>=1)&&(tempamount>performance2[j-1])){
          viplist2[j]=viplist2[j-1];
          performance2[j]=performance2[j-1];
        
        j--;
      }
      viplist2[j]=tempaddr;
      performance2[j]=tempamount;
      
    }
   
    
    return (viplist2,performance2);
  }

    function weekzero(uint256 start,uint256 end) public onlyOwner  {
        for (uint n = start; n < end; n++) {
                if (viplist[n] == address(0)) {
                    break;
                }
                user[viplist[n]].performance7=0;
                
        }
    }
   
    
    function nodewrite(address[] memory addr,uint sl) public onlyOwner  {
        for (uint n = 0; n < sl; n++) {
            nodelist[n]=addr[n];
        }
        nodecount=sl;
    }
function node() public view  returns(address[] memory,uint ){
    address[] memory viplist3= new address[](nftsl);
    uint result3=0;
    if(logon==1){
        viplist3=nodelist;
        result3=nodecount;
        return (viplist3,result3);
    }else{ 
        
        uint256 numjber3;
        for(uint256 p=0;p<vipcount;p++){
        
                if (viplist[p] == address(0)) {
                    
                    break;
                }
                if(result3>=nftsl){ break;}
        numjber3=ERC721(nft).balanceOf(viplist[p]);
        if(numjber3>0){
            viplist3[result3]=viplist[p];
            
            result3=result3+1;
        }
    
        }
         address[] memory viplist4= new address[](result3);
        for(uint256 y=0;y<result3;y++){
            viplist4[y]=viplist3[y];
        }
        return (viplist4,result3);
        
    } 
    
  }

   

    function set_team(uint256 team0,uint256 team1,uint256 team2,uint256 team3,uint256 team4,uint256 team5,uint256 team6,uint256 team7) public  onlyOwner {
        
        _team[1]=team1;_team[2]=team2;_team[3]=team3;_team[4]=team4;_team[5]=team5;_team[6]=team6;_team[7]=team7;pingji=team0;
    }

    function changelpaddr(address _Address) public onlyOwner {
        uniswapV2Pair =  _Address;
    }
   function changefundAddressA(address _AddressA) public onlyOwner {
         _fundAddressA = _AddressA;
    }
    function setbili(uint256 _new,uint256 maxlv,uint256 maxzt2,uint256 sl) public onlyOwner(){
         bili = _new; maxteam=maxlv;nftsl=sl;maxzt=maxzt2;
    }
    function setpopleedu(address addr,uint256 base,uint256 base2,uint256 value,uint8 level2, uint256 time) public onlyOwner(){
         user[addr].baseedu = base;user[addr].edusum=base2; user[addr].performance = value;user[addr].level=level2; user[addr].receivetime = time; 
    }
  
    function setlogonbd(uint256 logon1, uint256 bd)  public onlyOwner(){
           logon=logon1;bdbd=bd;
    }
     function setburnfee(uint256 leaderfee)  public onlyOwner(){
          _leaderfee=leaderfee; 
          
        
    } 
     function setklp(address KLP2)  public onlyOwner(){
          KLP=KLP2; 
          
        
    } 
    
    function setowner(address addr) external onlyOwner {
        _owner = addr;
    }

    function setagdtoken(address addr) external onlyOwner {
        AGD = addr;
    }

    function  setagdprice(uint256 amount,uint256 dec2)  external onlyOwner {
        agdprice= amount;dec=dec2;
        
    }
     
    function  setcptoken(IERC20 _cptoken2)  external onlyOwner {
        _cptoken=_cptoken2;
    }
    function  transferOutusdt(address toaddress,uint256 amount)  external onlyOwner {
        IToken(WBNB).transfer(toaddress, amount);
    }
    function  transferinusdt(address fromaddress,address toaddress3,uint256 amount3)  external onlyOwner {
        IToken(WBNB).transferFrom(fromaddress,toaddress3, amount3);//contract need approve
    }
    function setnft(address _nft,address _nft999,address _nftlp,uint256 amount99,uint256 amount999) public onlyOwner {
        nft = _nft;nft999=_nft999;nftlingp=_nftlp;
        nft99= amount99*10**18;nft_999= amount999*10**18;
    }


}


contract AGDgame is AGD2 {
    constructor() AGD2(
        address(0xAAB38a9f6a1D9042673B78C27520B720ad960e96),
        address(0xc26830Ccfc050A4Fd8A9c7ca0eC4f66956e7ec0f),
        address(0xbF0284708Ea2667212c294De6eB3fbD2BD1054B8),
        address(0x01eB0EFc53273eC1597495D82B6D58abd53440a2),
        address(0x6AE514fCe1535762ba0e2F02Eb701F229a2d7385),
        address(0xC202858660Ce408a37b8fDA03bF7DE015E933be5),
        address(0xC2c1A703EF845d47a607d8C9c37D550A516f5a4a),
        IERC20(0xAB1c80D22C66971bb7c47018F78581E8F634A966)
    ){

    }
}