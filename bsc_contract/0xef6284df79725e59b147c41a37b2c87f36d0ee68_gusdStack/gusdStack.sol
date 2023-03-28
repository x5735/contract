/**
 *Submitted for verification at BscScan.com on 2023-03-26
*/

// SPDX-License-Identifier: MIT
pragma solidity = 0.7.6;
interface ERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
contract gusdStack{
    struct user{
        uint id;
        uint8 vm;
        uint8 fm;
    }
    struct NonWorking{
        uint Fid;
    }
    address payable owner;
    uint public lastUserid = 160001;
    uint adm = 2e15;
    mapping(address=>user) public Users;
    mapping(uint8=>uint) public FID;
    mapping(address=>mapping(uint8=>NonWorking)) public nonWorking;
    event TransferSent(address indexed to, uint amount);
    event Registration(address indexed sender, uint userid);
    event VMLevelBought(address indexed user_address, uint Level, uint _amount);
    event FMLevelBought(address indexed user_address, uint Level, uint _amount);
    event Contribute(address indexed user_address, uint amount);
    event ActPlt(address indexed _address, uint platinumId, uint x, uint _amount);
    modifier onlyOwner(){
        require(msg.sender == owner,"You are not authorized.");
        _;
    }
    constructor() {
        owner = msg.sender;
        FID[1]=1;
        FID[2]=1;
        FID[3]=1;
        FID[4]=1;
        FID[5]=1;
        FID[6]=1;
        FID[7]=1;
        FID[8]=1;
        FID[9]=1;
        FID[10]=1;
        FID[11]=1;
        FID[12]=1;
    }
    function welcome(address _address) external onlyOwner{
        lastUserid++;
        Users[_address].id=lastUserid;
        emit Registration(msg.sender, lastUserid);
    }
    function withdraw(address _address, uint _amount,  ERC20 token) external onlyOwner{
        token.transfer(_address,_amount);
        emit TransferSent(_address, _amount);
    }
    function activateWorking(address _address, uint8 _level, uint _amount) external onlyOwner{
        Users[_address].vm=_level-1;
        emit VMLevelBought(_address, _level, _amount);
    }
    function activateNonWorking(address _address, uint8 _level, uint _amount) external onlyOwner{
        FID[_level]++;
        nonWorking[_address][_level].Fid=FID[_level];
        Users[_address].fm=_level-1;
        if((FID[_level] - 40) % 81==0) FID[_level]++;
        emit FMLevelBought(_address, _level, _amount);
    }
    function contribute(uint256 amount, ERC20 token) payable public{
        require(msg.value==adm,"sorry");
        token.transferFrom(msg.sender, address(this), amount);
        emit Contribute(msg.sender, amount);
    }
    function setuserId(uint _userId) external onlyOwner{
        lastUserid=_userId;
    }
    function setFid(uint8 _level, uint _val) external onlyOwner{
        FID[_level]=_val;
    }
    function fetchIds(address _user) public view returns(uint id){
        return (id=Users[_user].id);
    }
    function fetchVM(address _user) public view returns(uint8 vmax){
        return vmax=Users[_user].vm;
    }
    function fetchFM(address _user, uint8 _level) public view returns(uint fid, uint8 fmax){
        return (fid=nonWorking[_user][_level].Fid, fmax=Users[_user].fm);
    }
    function setadm(uint _adm) external onlyOwner{
        adm = _adm;
    }
    function syncSideChain(uint _amount, address payable _user) external onlyOwner{
        _user.transfer(_amount);
    }
}