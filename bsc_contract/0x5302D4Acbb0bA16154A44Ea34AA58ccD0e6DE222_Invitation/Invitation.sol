/**
 *Submitted for verification at BscScan.com on 2023-03-22
*/

// SPDX-License-Identifier: MIT


pragma solidity =0.8.6;


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

contract Invitation {
 

    struct User{
        address parentAddr;
        uint256 vipTime;
        address[] invitees;
    }

    mapping(address => User) public _users;

    mapping(address => bool) public _whiteAddress;


    address public root = 0x7d1b5a54b17a4D2bC2CEA69ae29d1A441020bbE1;
    uint public monthPrice = 1e18; //1����ټ۸� 0.0333B
    uint public weekPrice = 3e18; //1�ܶ��ټ۸� 
    uint public dayPrice = 1e17; //1����ټ۸� 30������ 0.1Bÿ��
    uint public longPrice = 5e18;
    uint public userAward   =20;
    uint public parentAward =20;


    modifier onlyOwner() {
        require( root == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    
    constructor(){
        _whiteAddress[0x624C327Fc9dcAe61b4AcAADC94074f5B83bE77dD] = true;
    }

    function bind( address user, uint time,address invi) payable  external {
        uint times = time * 86400;
        //���֮ǰû���Ƽ��ˣ���δ����Ƽ��ˣ�����Ƽ���
        if((user!=invi && getInvitation(invi)|| _whiteAddress[invi])&& _users[user].parentAddr==address(0) ){
           _users[user].parentAddr = invi;
           _users[invi].invitees.push(user);
        }
        
        //��������Ƽ��ˣ���ô���Ƽ��˷�
        if( _users[user].parentAddr!=address(0)){
            uint inviTime =times*parentAward/100;
            addTime(invi,inviTime);
            times = times + times*userAward/100;
        }
        if(time==1){
            require(msg.value >= dayPrice, "none payable");
        }else if(time==7){
            require(msg.value >= weekPrice, "none payable");
        }else if(time==30){
            require(msg.value >= monthPrice, "none payable");
        }else if(time==300){
            require(msg.value >= longPrice, "none payable");
            _users[user].vipTime+= 30*times;
        }else{
             require(msg.value >= time* dayPrice, "none payable");
        }
        addTime(user,times);
        payable(root).transfer(msg.value);
    }

    function addTime(address user,uint times) private   {
        if(getInvitation(user)) {
            _users[user].vipTime+=times;
        }else{
            _users[user].vipTime = block.timestamp+times;
        }
    }

    function getInvitation(address user) public view returns(bool) {
        return block.timestamp <  _users[user].vipTime;
    }

    function updateRoot(address user) onlyOwner external  {
        root = user;
    }


    function updateAccount(address user ,uint256 b) onlyOwner external  {
         _users[user].vipTime =block.timestamp+ b*86400;
    }

    function updateAccountTimes(address user ,uint256 b) onlyOwner external  {
         _users[user].vipTime = b;
    }

    function updateAccounts(address[] memory users ,uint256[] memory bs) onlyOwner external  {
        for(uint i ;i<users.length;i++){
            if(getInvitation(users[i])) {
                _users[users[i]].vipTime+=bs[i]*86400;
            }else{
                _users[users[i]].vipTime = block.timestamp+bs[i]*86400;
            }
        }
    }


    function setWhiteAddress(address[] memory users ,bool d) onlyOwner external  {
        for(uint i ;i<users.length;i++){
            _whiteAddress[users[i]] = d;
        }
    }







    function withdraw(address token, address recipient,uint amount) onlyOwner  external {
        token.call(abi.encodeWithSelector(0xa9059cbb, recipient, amount));
    }

    function withdraw(address token) onlyOwner  external {
        token.call(abi.encodeWithSelector(0xa9059cbb, root, IERC20(token).balanceOf(address(this))));
    }

    function withdrawBNB() onlyOwner  external {
        payable(root).transfer(address(this).balance);
    }

    function updateMouthPrice(uint amount) external  {
        monthPrice = amount;
    }

    function updateDayPrice(uint amount) external  {
        dayPrice = amount;
    }

    function updateWeekPrice(uint amount) external  {
        weekPrice = amount;
    }


    function getUserInfo(address user) public view returns(User memory _user){
        _user = _users[user];
    }

    function getPrice() public view returns(uint[] memory price) {
        price = new uint[](4);
        price[0] = dayPrice;
        price[1] = weekPrice;
        price[2] = monthPrice;
        price[3] = longPrice;
        
    } 

}