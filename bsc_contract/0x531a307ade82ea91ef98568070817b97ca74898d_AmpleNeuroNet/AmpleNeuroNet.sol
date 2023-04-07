/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );


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

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract ReentrancyGuard {

    uint private constant _NOT_ENTERED = 1;
    uint private constant _ENTERED = 2;

    uint private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }


    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;

        _;


        _status = _NOT_ENTERED;
    }
}

library SafeMath {
   

    function add(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }


    function sub(uint a, uint b) internal pure returns (uint) {
        return a - b;
    }


    function div(uint a, uint b) internal pure returns (uint) {
        return a / b;
    }
}


contract AmpleNeuroNet is Ownable, ReentrancyGuard{
    using SafeMath for uint;

    uint private constant DEVELOPER_FEE = 500; 
    uint private constant REFFER_REVARD_1_LVL = 500; 
    uint private constant REFFER_REVARD_2_LVL = 300;
    uint private constant REWARD_PERIOD = 1 days;
    uint public constant APR =  718; 
    uint private constant PERCENT_RATE = 10000;
    address private devWallet; 
    uint private _currentDepositID = 0;

    uint private totalInvestors = 0;
    uint private totalReward = 0;
    uint private totalInvested = 0;


    struct InvestorStruct{
        address investor;
        address referrer;
        uint totalLocked;
        uint startTime;
        uint lastCalculationDate;
        uint claimableAmount;
        uint claimedAmount;
        uint referAmount;
        uint referralsNumber;
    }

    mapping(address => uint[]) internal ownedDeposits;

    mapping(address => InvestorStruct) public investors;
    
    constructor() {
        devWallet = 0x1fEc568Fb35556994357Ec784664c573Abc4db31;
    }


    function _getNextDepositID() private view returns (uint) {
        return _currentDepositID + 1;
    }

    function _incrementDepositID() private {
        _currentDepositID++;
    }

    function invest(address _referrer) public payable {
        uint _amount = msg.value;
        require(_amount > 0, "error invest");

        if(_referrer == msg.sender){
            _referrer = address(0);
        }

        uint _id = _getNextDepositID();
        _incrementDepositID();

        uint depositFee = (_amount * DEVELOPER_FEE).div(PERCENT_RATE);
        
        _sendDepositFee(depositFee);

        uint _depositAmount = _amount - depositFee;


        if(investors[msg.sender].investor == address(0)){
            totalInvestors = totalInvestors.add(1);
            investors[msg.sender].investor = msg.sender;
            investors[msg.sender].startTime = block.timestamp;
            investors[msg.sender].lastCalculationDate = block.timestamp;
        }

        if(address(0) != _referrer && investors[msg.sender].referrer == address(0)) {
            investors[msg.sender].referrer = _referrer;
            investors[_referrer].referralsNumber += 1;            
        }

        if(investors[msg.sender].referrer != address(0)){
            uint referrerAmountlvl1 = (_amount * REFFER_REVARD_1_LVL).div(PERCENT_RATE);
            uint referrerAmountlvl2 = (_amount * REFFER_REVARD_2_LVL).div(PERCENT_RATE);

            investors[investors[msg.sender].referrer].referAmount = investors[investors[msg.sender].referrer].referAmount.add(referrerAmountlvl1);

            payable(investors[msg.sender].referrer).transfer(referrerAmountlvl1);


            if(investors[_referrer].referrer != address(0)) {
                investors[investors[_referrer].referrer].referAmount = investors[investors[_referrer].referrer].referAmount.add(referrerAmountlvl2);

                payable(investors[_referrer].referrer).transfer(referrerAmountlvl2);
            }
        }

        uint lastRoiTime = block.timestamp - investors[msg.sender].lastCalculationDate;
        uint allClaimableAmount = (lastRoiTime *
            investors[msg.sender].totalLocked *
            APR).div(PERCENT_RATE * REWARD_PERIOD);

        investors[msg.sender].claimableAmount = investors[msg.sender].claimableAmount.add(allClaimableAmount);
        investors[msg.sender].totalLocked = investors[msg.sender].totalLocked.add(_depositAmount);
        investors[msg.sender].lastCalculationDate = block.timestamp;

        totalInvested = totalInvested.add(_amount);

        ownedDeposits[msg.sender].push(_id);
    }


    function claim() public nonReentrant {
        require(ownedDeposits[msg.sender].length > 0, "you can deposit once at least");

        uint lastRoiTime = block.timestamp - investors[msg.sender].lastCalculationDate;

        uint allClaimableAmount = (lastRoiTime *
            investors[msg.sender].totalLocked *
            APR).div(PERCENT_RATE * REWARD_PERIOD);

        investors[msg.sender].claimableAmount = investors[msg.sender].claimableAmount.add(allClaimableAmount);

        uint amountToSend = investors[msg.sender].claimableAmount;
        
        if(balanceThisContract() < amountToSend){
            amountToSend = balanceThisContract();
        }
        
        investors[msg.sender].claimableAmount = investors[msg.sender].claimableAmount.sub(amountToSend);
        investors[msg.sender].claimedAmount = investors[msg.sender].claimedAmount.add(amountToSend);
        investors[msg.sender].lastCalculationDate = block.timestamp;
        totalReward = totalReward.add(amountToSend);

        uint depositFee = (amountToSend * DEVELOPER_FEE).div(PERCENT_RATE);
        
        _sendDepositFee(depositFee);

        uint withdrawalAmount = amountToSend - depositFee;

        payable(msg.sender).transfer(withdrawalAmount);
    }


    function withdraw(uint _amount) public payable onlyOwner {
        uint balance = address(this).balance;
        require(balance >= _amount);
        payable(owner()).transfer(_amount);
    }
    
    
    function getOwnedDeposits(address investor) internal view returns (uint[] memory) {
        return ownedDeposits[investor];
    }

    function getAllClaimableReward(address _investor) public view returns (uint) {
        uint lastRoiTime = block.timestamp - investors[_investor].lastCalculationDate;
        uint allClaimableAmount = (lastRoiTime *
            investors[_investor].totalLocked *
            APR).div(PERCENT_RATE * REWARD_PERIOD);

         return investors[_investor].claimableAmount.add(allClaimableAmount);
    }

    function balanceThisContract() internal view returns(uint) {
        return address(this).balance;
    }


    function getTotalAmountEarned(address _investor) external view returns(uint){
        uint claimed = getAllClaimableReward(_investor);
        return investors[_investor].claimedAmount + claimed;
    }

    
    function _sendDepositFee(uint depositFee) internal {
        payable(devWallet).transfer(depositFee);
    }
    
    receive() external payable{
        invest(msg.sender);
    }
}