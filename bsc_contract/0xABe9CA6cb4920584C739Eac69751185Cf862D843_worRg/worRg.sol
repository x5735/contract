/**
 *Submitted for verification at BscScan.com on 2023-03-31
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

struct userLp {
     uint   date;
     uint   valueStay;
     uint   valueHas;
     uint   price;
     string name;
}

struct communityLp {
     string   name;
     string   code;
     uint   value;
     uint  state;
     uint  date;
}


contract  worRg { 
       
       event BindingAddressCommunity(address indexed addr, string indexed code, string indexed name);
       event ReceiveAward(address indexed addr,  string indexed name ,uint num);
       event RgWor(address indexed addr,  string indexed name ,uint num);
       bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
       uint public price =  1*10**18;
       uint constant internal SECONDS_PER_DAY = 24 * 60 * 60;
       uint constant internal OFFSET19700101 = 2440588;
       address private admin;//����Ա 
       using SafeMath for uint;
       uint rg = 80000*10**18 ; // Ĭ���Ϲ�����
       address public USDT = address(0x55d398326f99059fF775485246999027B3197955);
       address public WOR = address(0xd6edbB510af7901b2C049ce778b65a740c4aeB7f);
       address public JS_USDT = address(0x70a6266f8bD6FE48f18F0127F396Edf1bdC9df15);
       address public USDT_WOR_PAIR_ADDRESS = address(0xF366696df61171B9832d4746309D38e20c9A09be);
       mapping(uint => string) monthString; 
       mapping(uint => string) yearString; 
       uint public day30 = 30;
       uint public daycount = 0;
        constructor() public {
                admin = msg.sender;
                monthString[1] = "01";
                monthString[2] = "02";
                monthString[3] = "03";
                monthString[4] = "04";
                monthString[5] = "05";
                monthString[6] = "06";
                monthString[7] = "07";
                monthString[8] = "08";
                monthString[9] = "09";
                monthString[10] = "10";
                monthString[11] = "11";
                monthString[12] = "12";
                yearString[2023] = "2023";
                yearString[2024] = "2024";
                yearString[2025] = "2025";
                yearString[2026] = "2026";
                yearString[2027] = "2027";
                yearString[2028] = "2028";
                yearString[2029] = "2029";
                yearString[2030] = "2030";
                yearString[2031] = "2031";
                yearString[2032] = "2032";
                yearString[2033] = "2033";
                yearString[2034] = "2034";
                yearString[2035] = "2035";
        }

       // �󶨵�������ϵ
       mapping(address => communityLp) userCommunity;
       //����
       mapping(string => communityLp) communityList;
       //�û��Ϲ���¼
       mapping(address => userLp[]) userRecord;
        //�Ϲ���¼
       mapping(string => mapping(string => uint)) communityLpRecordList;

        function _safeTransfer(address token, address to, uint value) private {
            (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
            require(success && (data.length == 0 || abi.decode(data, (bool))), 'Pancake: TRANSFER_FAILED');
        }

       modifier isAdmin() {
        require(msg.sender == admin, 'FORBIDDEN');
        _;
       }


       function getCommunityAdmin (string memory _code) public view returns(communityLp memory){
           return communityList[_code];
       }

        function extractWor(uint _value) external isAdmin{
            uint b = IPancakePair(WOR).balanceOf(address(this));
            require(b >= _value,"Extraction failure");
             _safeTransfer(WOR,msg.sender,_value);
       }

        function extractUsdt(uint _value) external isAdmin{
                uint b = IPancakePair(USDT).balanceOf(address(this));
                require(b >= _value,"Extraction failure");
                _safeTransfer(USDT,msg.sender,_value);
        }

        function updateDay(uint _day) public isAdmin {
            day30 = _day;
        }

        function updatePrice(uint _price) public isAdmin {
            price = _price;
        }

        function updateDaycount(uint _daycount) public isAdmin {
            daycount = _daycount;
        }

        //��ü�¼
        function addressCommList() public view returns(userLp[] memory){
            return  userRecord[msg.sender];
        }

        // �������
        function addCommunityAdmin(string memory _name,string memory _code,uint _value)  public isAdmin {
                require(_utilCompareInternal(communityList[_code].name,""),"Community already exist");
                communityLp  memory com = communityLp(_name,_code,_value,0,block.timestamp);
                communityList[_code] = com;
        }

        // ��ȡ
        function receiveAward() public {
                userLp[] storage  u =   userRecord[msg.sender];
                uint k;
                for (uint i = 0; i < u.length; i ++) {
                    uint day = block.timestamp.sub(u[i].date).div(86400);
                    uint c =  day.div(day30) + daycount;
                    uint z = u[i].valueStay.div(10).mul(c) - u[i].valueHas;
                    u[i].valueHas = u[i].valueHas + z ;
                    k += z;
                } 
                require(k > 0,"invalid");
                _safeTransfer(WOR,msg.sender,k);
                emit ReceiveAward(msg.sender, userCommunity[msg.sender].name,k);
        }

        // �Ϲ�
        function rgWor(uint _value) public  {
          communityLp memory com =  userCommunity[msg.sender];
          require(!_utilCompareInternal(com.name,""),"address invalid");
          require(com.state == 0,"community close");
          uint usdtNum =  _value.mul(price).div(10**18);
          require(IPancakePair(USDT).balanceOf(msg.sender) >= usdtNum,"USDT balance deficiency");
          (uint year, uint month, ) = _daysToDate(block.timestamp);
          string memory codeBs =  strConcat(yearString[year],monthString[month]);
          uint valueCom =  communityLpRecordList[com.code][codeBs];
          require(com.value >= valueCom + _value ,"lazy weight");
          communityLpRecordList[com.code][codeBs]  = valueCom + _value;
          userLp memory _userLp =  userLp(block.timestamp,_value,0,price,com.name);
          userRecord[msg.sender].push(_userLp);
          IBEP20(USDT).transferFrom(msg.sender, JS_USDT, usdtNum);
          emit RgWor(msg.sender,com.name,_value);
        }


       
        function strConcat(string memory _a, string memory _b) internal pure returns (string memory){
                bytes memory _ba = bytes(_a);
                bytes memory _bb = bytes(_b);
                string memory ret = new string(_ba.length + _bb.length);
                bytes memory bret = bytes(ret);
                uint k = 0;
                for (uint i = 0; i < _ba.length; i++)
                bret[k++] = _ba[i];
                for (uint i = 0; i < _bb.length; i++) 
                bret[k++] = _bb[i];
                return string(ret);
        }  



        function _dateCompare(uint _dateStart, uint _dateEnd) internal pure returns(uint){
             (uint year, uint month, ) = _daysToDate(_dateStart);
             (uint dyear, uint dmonth, ) = _daysToDate(_dateEnd);
             uint c ;
             if(month > dmonth){
                c = month.sub(dmonth);
             }else{
                c = dmonth.sub(month);
             }
             c +=  dyear.sub(year).mul(12);
            return c;
        }

        //������
        function bindingAddressCommunity(string memory _code) public  {
              communityLp memory _addr = userCommunity[msg.sender];
              require(_utilCompareInternal(_addr.name,""),"address bound");
              communityLp storage _communityLp = communityList[_code];
              require(!_utilCompareInternal(_communityLp.name,""),"code invalid");
              userCommunity[msg.sender] = _communityLp;
              emit BindingAddressCommunity(msg.sender, _code,_communityLp.name);
        }

        //����Ƿ�� false �� true
        function examineAddressCommunity() public view returns(bool) {
              return !_utilCompareInternal(userCommunity[msg.sender].name,"");
        }

        // �����������
        function getCommunity() public view returns(uint,uint,string memory) {
             communityLp memory  com =  userCommunity[msg.sender];
             (uint year, uint month, ) = _daysToDate(block.timestamp);
             string memory codeBs =  strConcat(yearString[year],monthString[month]);
             uint valueCom =  communityLpRecordList[com.code][codeBs];
             return (price,com.value.sub(valueCom),com.name) ;
        }



        //���address �Ϲ�����
        function getAddressCommunity() public view returns(uint,uint){
                userLp[]  memory u =   userRecord[msg.sender];
                uint k; // ���ͷ�
                uint s; //  ʣ���ͷ�
                for (uint i = 0; i < u.length; i ++) {
                    uint day = block.timestamp.sub(u[i].date).div(86400);
                    uint c =  day.div(day30) + daycount;
                    k += u[i].valueStay.div(10).mul(c) - u[i].valueHas;
                    s += u[i].valueStay - u[i].valueStay.div(10).mul(c);
                } 
                return (k,s);
        }


        function _utilCompareInternal(string memory a, string memory b)  private pure returns (bool) {
            if (bytes(a).length != bytes(b).length) {
                return false;
            }
            for (uint i = 0; i < bytes(a).length; i ++) {
                if(bytes(a)[i] != bytes(b)[i]) {
                    return false;
                }
            }
            return true;
        }
    
            //ʱ���ת���ڣ�UTCʱ��
        function _daysToDate(uint timestamp) private pure returns (uint year, uint month, uint day) {
            uint _days = uint(timestamp) / SECONDS_PER_DAY;
    
            uint L = _days + 68569 + OFFSET19700101;
            uint N = 4 * L / 146097;
            L = L - (146097 * N + 3) / 4;
            year = 4000 * (L + 1) / 1461001;
            L = L - 1461 * year / 4 + 31;
            month = 80 * L / 2447;
            day = L - 2447 * month / 80;
            L = month / 11;
            month = month + 2 - 12 * L;
            year = 100 * (N - 49) + year + L;
        }

}