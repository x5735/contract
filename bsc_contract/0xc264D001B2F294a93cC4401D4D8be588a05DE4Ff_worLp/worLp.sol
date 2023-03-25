/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

pragma solidity >=0.6.0 <0.9.0;
//ע��˴�
pragma experimental ABIEncoderV2;  

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function burn(uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
    
}



interface IPancakeRouter {
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
}

interface IPancakePair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function balanceOf(address owner) external view returns (uint);
    function totalSupply() external view returns (uint);
}



contract worLp {
       bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
       address private admin;//����Ա 
       using SafeMath for uint;
       uint  zLp = 0;
       mapping(address => userLp[]) userLpList; // ��Ѻ��¼
       uint private dayLp = 1;
       struct userLp {
            uint   date;
            uint   value;
            uint   state;
       }
       address public USDT = address(0x55d398326f99059fF775485246999027B3197955);
       address public WOR = address(0xd6edbB510af7901b2C049ce778b65a740c4aeB7f);
       address public USDT_WOR_PAIR_ADDRESS = address(0xF366696df61171B9832d4746309D38e20c9A09be);
       address public PANCAKE_ROUTER_ADDRESS = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);

       constructor() public {
            admin = msg.sender;
       }

       function getZlp() public view returns(uint){
           return zLp;
       }

       function _safeTransfer(address token, address to, uint value) private {
            (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
            require(success && (data.length == 0 || abi.decode(data, (bool))), 'Pancake: TRANSFER_FAILED');
        }

       modifier isAdmin(){
        require(msg.sender == admin, 'FORBIDDEN');
        _;
       }

       function updateDayLp(uint _dayLp) external isAdmin {
            dayLp =_dayLp;
       }

       function extractLp(uint _value) external isAdmin{
            uint b = IPancakePair(USDT_WOR_PAIR_ADDRESS).balanceOf(address(this));
            require(b >= _value,"Extraction failure");
            _safeTransfer(USDT_WOR_PAIR_ADDRESS,msg.sender,_value);
       }

        function extractWor(uint _value) external isAdmin{
            uint b = IPancakePair(WOR).balanceOf(address(this));
            require(b >= _value,"Extraction failure");
             _safeTransfer(WOR,msg.sender,_value);
       }


       // ��ȡ
       function getExtractLp() public {
            userLp[] storage listLp = userLpList[msg.sender];
            uint  z = 0 ;
               for (uint i = 0 ; i < listLp.length ; i++){
                    uint day = block.timestamp.sub(listLp[i].date).div(86400);
                    if(day >= dayLp && listLp[i].state == 0) {
                        z = z +listLp[i].value; 
                        listLp[i].value = 1;
                        zLp = zLp.sub(listLp[i].value);
                    } 
                }
            require(IPancakePair(USDT_WOR_PAIR_ADDRESS).balanceOf(address(this)) >= z,"Extraction failure");
            _safeTransfer(USDT_WOR_PAIR_ADDRESS,msg.sender,z);
       }

        // lp ���
        function getLpBalance() public view returns (uint) {
            return IPancakePair(USDT_WOR_PAIR_ADDRESS).balanceOf(msg.sender);
        }

       //��Ѻ
       function addWorUsdtLp(uint _value) public  {
            require(IPancakePair(USDT_WOR_PAIR_ADDRESS).balanceOf(msg.sender) >= _value,"Lp deficiency");
            (, uint reserve1,) =  IPancakePair(USDT_WOR_PAIR_ADDRESS).getReserves();
            (uint totalSupply) =  IPancakePair(USDT_WOR_PAIR_ADDRESS).totalSupply();
            IBEP20(USDT_WOR_PAIR_ADDRESS).transferFrom(msg.sender, address(this), _value);
            (uint j) =  _value.mul(reserve1).div(totalSupply).mul(12).div(100);
            require(IBEP20(WOR).balanceOf(address(this)) >= j,"underreward");
            userLp[] storage add = userLpList[msg.sender];
            userLp memory  u = userLp(block.timestamp,_value,0);
            add.push(u);
            _safeTransfer(WOR,msg.sender,j);
            zLp = zLp.add(_value);
       }

        // ��ý������
       function getWorBalanceOf() public view returns(uint){
            return IBEP20(WOR).balanceOf(address(this));
       }

        // �����ӽ���
       function getAddLpRewardWor(uint _value) public view returns(uint){
            (, uint reserve1,) =  IPancakePair(USDT_WOR_PAIR_ADDRESS).getReserves();
            (uint totalSupply) =  IPancakePair(USDT_WOR_PAIR_ADDRESS).totalSupply();
            (uint j) =  _value.mul(reserve1).div(totalSupply).mul(12).div(100);
            return j;
       }



       //�������Ѻ
       function getWorLpAlready() public view returns(uint){
            userLp[] memory listLp = userLpList[msg.sender];
            uint  z ;
            for (uint i = 0 ; i < listLp.length ; i++){
                  if(listLp[i].state == 0)  z = z +listLp[i].value;
            }
            return z;
       }

       // �ѽ���lp
       function getWorLpUnlock() public view returns(uint) {
            userLp[] memory listLp = userLpList[msg.sender];
            uint  z ;
               for (uint i = 0 ; i < listLp.length ; i++){
                uint day = block.timestamp.sub(listLp[i].date).div(86400);
                if(day >= dayLp && listLp[i].state == 0)  z = z +listLp[i].value;
            }
            return z;
       }
}