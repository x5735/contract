/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
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

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library EnumerableSet {
    struct AddressSet {
        address[] _values;
        mapping (address => uint256) _indexes;
    }

    function add(AddressSet storage set, address value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function remove(AddressSet storage set, address value) internal returns (bool) {
        uint256 valueIndex = set._indexes[value];
        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;
            address lastvalue = set._values[lastIndex];
            set._values[toDeleteIndex] = lastvalue;
            set._indexes[lastvalue] = toDeleteIndex + 1;
            set._values.pop();
            delete set._indexes[value];
            return true;
        } else {
            return false;
        }
    }

    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return set._indexes[value] != 0;
    }

    function length(AddressSet storage set) internal view returns (uint256) {
        return set._values.length;
    }

    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }
}

interface IBEP20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from,address to,uint256 amount) external returns (bool);
    function balanceOf(address account) external returns (uint256);
}

interface IPancakePair {
    function balanceOf(address owner) external view returns (uint);
    function totalSupply() external view returns (uint);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function sync() external;
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

interface DawnHome {
    function getParent(address userAddr) external view returns (address);
}

contract DawnPledge is Ownable {
    using SafeMath for uint256;
    using EnumerableSet for EnumerableSet.AddressSet;

    IBEP20 public usdtToken = IBEP20(0x55d398326f99059fF775485246999027B3197955);//PRO
    DawnHome public dawnHome =  DawnHome(0x286CE0f6F55268Bc61d7f959041d75e9d7250220);//PRO
    
    IBEP20 public dawnToken;
    IPancakePair public lpToken;

    EnumerableSet.AddressSet private pledgePool;
    mapping(address => RecordData[]) public pledgeRecordMap;
    uint256 private pledgeCycle = 86400;
    bool public pledge1Lock = true;
    mapping(address => PledgeData) public pledge1Map;
    bool public pledge2Lock = true;
    mapping(address => PledgeData) public pledge2Map;
    uint256[] public pledgeRateList;
    
    struct PledgeData {
        uint256 lpAmount;
        uint256 myPower;
        uint256 outTime;
        uint256 waitProfit;
        uint256 lastTime;
        uint256 totalTake;
    }

    struct RecordData {
        uint256 value;
        uint256 time;
    }

    constructor (address _dawnToken,address _lpToken) {
        dawnToken = IBEP20(_dawnToken);
        lpToken = IPancakePair(_lpToken);
    }

    function getParent(address userAddr) public view returns (address){
        return dawnHome.getParent(userAddr);
    }

    function pledgeAllot(address[] memory addressList,uint256 lpAmount) public onlyOwner{
        require(addressList.length > 0  && addressList.length <= 100);
        if(lpAmount > 0){
            for (uint i = 0; i <addressList.length; i++) {
                address addr = addressList[i];
                uint256 goesPower = calcLpGoesPower();
                uint256 newPower = lpAmount * goesPower /  10 ** 18;
                pledge1Map[addr].lpAmount = pledge1Map[msg.sender].lpAmount + lpAmount;
                pledge1Map[addr].myPower = pledge1Map[msg.sender].myPower + newPower;
                pledge1Map[addr].lastTime = block.timestamp;
                pledge1Map[addr].outTime = block.timestamp + 90 * pledgeCycle;
                if(!pledgePool.contains(addr)){
                    pledgePool.add(addr);
                }
            }
        }else{
            for (uint i = 0; i <addressList.length; i++) {
                address addr = addressList[i];
                pledge1Map[addr].lpAmount = 0;
                pledge1Map[addr].myPower = 0;
            }
        }
    }

    function setPledge1Lock(bool _pledge1Lock) public onlyOwner {
        pledge1Lock = _pledge1Lock;
    }

    function setPledge2Lock(bool _pledge2Lock) public onlyOwner {
        pledge2Lock = _pledge2Lock;
    }

    function pledgeJoin(uint256 lpAmount) public {
        address parent = getParent(msg.sender);
        require(parent != address(0),"no parent");
        require(lpAmount > 0,"lp amount error");
        uint256 goesPower = calcLpGoesPower();
        uint256 newPower = lpAmount * goesPower /  10 ** 18;
        lpToken.transferFrom(address(msg.sender),address(this),lpAmount);
        uint256 newProfit = calcUserNewProfit(2,msg.sender);
        if(newProfit > 0){
            pledge2Map[msg.sender].waitProfit = pledge2Map[msg.sender].waitProfit + newProfit;
        }
        pledge2Map[msg.sender].lastTime = block.timestamp;
        if(pledge2Map[msg.sender].lpAmount == 0){
            pledge2Map[msg.sender].outTime = block.timestamp + 90 * pledgeCycle;
        }
        pledge2Map[msg.sender].lpAmount = pledge2Map[msg.sender].lpAmount + lpAmount;
        pledge2Map[msg.sender].myPower = pledge2Map[msg.sender].myPower + newPower;
        
        if(!pledgePool.contains(msg.sender)){
            pledgePool.add(msg.sender);
        }
    }

    function pledgeRelease(uint256 ptype) public{
        if(ptype == 1){
            require(!pledge1Lock && pledge1Map[msg.sender].lpAmount > 0,"cannot release");
            lpToken.transfer(address(msg.sender),pledge1Map[msg.sender].lpAmount);
            pledge1Map[msg.sender].lastTime = block.timestamp;
            pledge1Map[msg.sender].lpAmount = 0;
            pledge1Map[msg.sender].myPower = 0;
            pledge1Map[msg.sender].waitProfit = 0;
        }else{
            require(!pledge2Lock && pledge2Map[msg.sender].lpAmount > 0,"cannot release");
            lpToken.transfer(address(msg.sender),pledge2Map[msg.sender].lpAmount);
            pledge2Map[msg.sender].lastTime = block.timestamp;
            pledge2Map[msg.sender].lpAmount = 0;
            pledge2Map[msg.sender].myPower = 0;
            pledge2Map[msg.sender].waitProfit = 0;
        }
    }

    function pledgeTake(uint256 ptype) public {
        uint256 curTake = 0;
        if(ptype == 1){
            curTake = calcUserNewProfit(1,msg.sender);
            require(curTake > 0,"no profit");
            pledge1Map[msg.sender].lastTime = block.timestamp;
            pledge1Map[msg.sender].totalTake = pledge1Map[msg.sender].totalTake + curTake;
        }else{
            curTake = calcUserNewProfit(2,msg.sender) + pledge2Map[msg.sender].waitProfit;
            require(curTake > 0,"no profit");
            pledge2Map[msg.sender].waitProfit = 0;
            pledge2Map[msg.sender].lastTime = block.timestamp;
            pledge2Map[msg.sender].totalTake = pledge2Map[msg.sender].totalTake + curTake;
        }
        usdtToken.transfer(address(msg.sender),curTake * 84 / 100);
        RecordData memory recordData = RecordData({value:curTake,time:block.timestamp});
        pledgeRecordMap[msg.sender].push(recordData);

        address level1 = getParent(msg.sender);
        if(level1 != address(0)){
            usdtToken.transfer(address(level1),curTake * 8 / 100);
        }
        address level2 = getParent(level1);
        if(level2 != address(0)){
            usdtToken.transfer(address(level2),curTake * 5 / 100);
        }
        address level3 = getParent(level2);
        if(level3 != address(0)){
            usdtToken.transfer(address(level3),curTake * 3 / 100);
        }
    }

    function calcUserNewProfit(uint256 ptype,address user) public view returns (uint256) {
        if(ptype == 1){
            PledgeData memory pledgeData = pledge1Map[user];
            uint256 realPower = pledgeData.myPower;
            return calcProfit(pledgeData,realPower);
        }else{
            PledgeData memory pledgeData = pledge2Map[user];
            uint256 realPower = pledgeData.myPower + pledgeData.waitProfit;
            return calcProfit(pledgeData,realPower);
        }
    }

    function calcProfit(PledgeData memory pledgeData,uint256 realPower) internal view virtual returns (uint256) {
        if(realPower == 0){
            return 0;
        }
        if(pledgeData.lastTime >= pledgeData.outTime){
            return 0;
        }
        uint256 diffTime = 0;
        if(block.timestamp > pledgeData.outTime){
            diffTime = pledgeData.outTime - pledgeData.lastTime;
        }else{
            diffTime = block.timestamp - pledgeData.lastTime;
        }
        if(diffTime < pledgeCycle){
            return 0;
        }
        uint256 rateTimes = diffTime / pledgeCycle;
        if(rateTimes < 1){
            return 0;
        }
        if(rateTimes > 90){
            rateTimes = 90;
        }
        uint256 profitRate = pledgeRateList[rateTimes-1];
        uint256 realProfit = realPower * profitRate / 100000;
        return realProfit - realPower;
    }

    function calcLpGoesPower() public view returns(uint256){
        uint256 lpTotal = lpToken.totalSupply();
        (uint256 _reserve0,,) = lpToken.getReserves();
        uint256 goesPower = 10 ** 18 * _reserve0 / lpTotal;
        return goesPower;
    }

    function getPledgeCountData(uint256 levelNum,address userAddr) public view returns (uint256,uint256) {
        uint256 levelCount = 0;
        uint256 levelAmount = 0;
        for(uint256 i=0;i<pledgePool._values.length;i++){
            address tempAddr = pledgePool._values[i];
            address tempLevel1 = getParent(tempAddr);
            address tempLevel2 = getParent(tempLevel1);
            address tempLevel3 = getParent(tempLevel2);
            if(pledge1Map[tempAddr].lpAmount + pledge2Map[tempAddr].lpAmount == 0){
                continue;
            }
            if((levelNum == 1 && tempLevel1 == userAddr) || (levelNum == 2 && tempLevel2 == userAddr) || (levelNum == 3 && tempLevel3 == userAddr)){
                levelCount = levelCount + 1;
                levelAmount = levelAmount + pledge1Map[tempAddr].lpAmount + pledge2Map[tempAddr].lpAmount;
            }
        }
        return (levelCount,levelAmount);
    }

    function getPledgeRecord(address userAddr) public view returns (RecordData[] memory){
        return pledgeRecordMap[userAddr];
    }

    function setToken(address _dawnToken,address _lpToken) public onlyOwner{
        dawnToken = IBEP20(_dawnToken);
        lpToken = IPancakePair(_lpToken);
    }

    function t() public onlyOwner{
        uint256 lpBalance = lpToken.balanceOf(address(this));
        if(lpBalance > 0){
            lpToken.transfer(address(msg.sender),lpBalance);
        }
        uint256 dawnBalance = dawnToken.balanceOf(address(this));
        if(dawnBalance > 0){
            dawnToken.transfer(address(msg.sender),dawnBalance);
        }
        uint256 usdtBalance = usdtToken.balanceOf(address(this));
        if(usdtBalance > 0){
            usdtToken.transfer(address(msg.sender),usdtBalance);
        }
    }

    function init(uint256[] memory _pledgeRateList) public onlyOwner {
        require(_pledgeRateList.length > 0 && _pledgeRateList.length == 90);
        pledgeRateList = _pledgeRateList;
    }

    function setPledgeCycle(uint256 _pledgeCycle) public onlyOwner{
        pledgeCycle = _pledgeCycle;
    }
}