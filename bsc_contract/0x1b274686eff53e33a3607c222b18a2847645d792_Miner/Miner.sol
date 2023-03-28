/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

/**
 *Submitted for verification at BscScan.com on 2023-03-20
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface IBEP20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Ownable {
    address private _owner;

    event OwnershipRenounced(address indexed previousOwner);
    event TransferOwnerShip(address indexed previousOwner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(_owner);
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        emit TransferOwnerShip(newOwner);
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Owner can not be 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface PreviousMiner {
    function amountStaked(address user) external view returns (uint256);

    function stakingTime(address user) external view returns (uint256);

    function lastClaimed(address user) external view returns (uint256);

    function totalClaimed(address user) external view returns (uint256);

    function tokenClaimable(address user) external view returns (uint256);

    function lockStakeTime(address user) external view returns (uint256);

    function lockedTime(address user) external view returns (uint256);

    function refferalConnection(address user) external view returns (address);
}

contract Miner is Ownable {
    address public tokenAddress;
    address public marketingWallet;
    address public previousMinerAddress;
    mapping(address => uint256) public amountStaked;
    mapping(address => uint256) public stakingTime;
    mapping(address => uint256) public lastClaimed;
    mapping(address => uint256) public totalClaimed;
    mapping(address => uint256) public tokenClaimable;
    mapping(address => uint256) public lockStakeTime;
    mapping(address => uint256) public lockedTime;
    mapping(address => address) public refferalConnection; // it tell 1st address was reffered by 2nd address

    uint256 public tokenPrice; // this is the token price per BNB
    uint256 public totalUsers; // this is the total users
    uint256 public startingTime; // this is the starting time of contract

    bool public isPaused = false; // whether contract is paused or not
    bool lock_= false;

    constructor() {
        marketingWallet = 0xA0Ac4232467d3c65548c936f9f09EE81568c630a;
    }

    modifier notPaused() {
        require(isPaused == false, "Contract is paused");
        _;
    }

    modifier lock {
        require(!lock_, "Process is locked");
        lock_ = true;
        _;
        lock_ = false;
    }

    // only owner functions here

    function setTokenAddress(address _tokenAddress) external onlyOwner {
        tokenAddress = _tokenAddress;
    }

    function setPreviousMinerAddress(address _previousMinerAddress) external onlyOwner {
        previousMinerAddress = _previousMinerAddress;
    }

    function setTokenPrice(uint256 _tokenPrice) external onlyOwner {
        tokenPrice = _tokenPrice;
    }

    function pauseContract() external onlyOwner {
        isPaused = true;
    }

    function unpauseContract() external onlyOwner {
        isPaused = false;
        startingTime = block.timestamp;
    }

    function updateMarketingWallet(address _marketingWallet) external onlyOwner {
        marketingWallet = _marketingWallet;
    }

    function importUserDetails (address _user) external onlyOwner {
        require (amountStaked [_user] == 0, "user already exists");

        PreviousMiner _miner = PreviousMiner(previousMinerAddress);
        amountStaked[_user] = _miner.amountStaked(_user);
        stakingTime[_user] = _miner.stakingTime(_user);
        lastClaimed[_user] = _miner.lastClaimed(_user);
        totalClaimed[_user] = _miner.totalClaimed(_user);
        tokenClaimable[_user] = _miner.tokenClaimable(_user);
        lockStakeTime[_user] = _miner.lockStakeTime(_user);
        lockedTime[_user] = _miner.lockedTime(_user);
        refferalConnection[_user] = _miner.refferalConnection(_user);
        totalUsers++;
    }

    // public functions here

    function stake(
        address refferal
    ) public payable lock notPaused {
        require(refferal != msg.sender, "You can not reffer yourself");
        require(msg.value > 0, "Amount must be greater than 0");

        // count the number of users
        if (amountStaked[msg.sender] == 0) totalUsers++;

        amountStaked[msg.sender] += (msg.value * 98) / 100;
        stakingTime[msg.sender] = block.timestamp;
        lastClaimed[msg.sender] = block.timestamp;

        // if user has no refferal
        if (refferalConnection[msg.sender] == address(0)) {
            refferalConnection[msg.sender] = refferal;
        }

        // 1st level refferal
        uint256 refferalLevel1 = (msg.value * 6) / 100;
        uint256 refferalLevel2 = (msg.value * 2) / 100;

        address refferalAddress1 = refferalConnection[msg.sender];
        address refferalAddress2 = refferalConnection[refferalAddress1];

        bool success;

        // 1st level refferal
        if (refferalAddress1 != address(0)) {
            (success, ) = address(refferalAddress1).call{value: refferalLevel1}(
                ""
            );
        }
        // 2nd level refferal
        if (refferalAddress2 != address(0)) {
            (success, ) = address(refferalAddress2).call{value: refferalLevel2}(
                ""
            );
        }

        // send fees to marketing wallet
        (success, ) = address(marketingWallet).call{
            value: (msg.value * 2) / 100
        }("");

        if (msg.value >= 10 ether){
            uint256 cashback = (msg.value * 15) / 100;
            (success, ) = address(msg.sender).call{value: cashback}("");

            // give 20% token cashback
            uint256 tokenCashback = ((msg.value * 20) / 100) * tokenPrice;
            tokenClaimable[msg.sender] += tokenCashback;
        } else if (msg.value >= 4 ether) {
            uint256 cashback = (msg.value * 5) / 100;
            (success, ) = address(msg.sender).call{value: cashback}("");

            // give 10% token cashback
            uint256 tokenCashback = ((msg.value * 10) / 100) * tokenPrice;
            tokenClaimable[msg.sender] += tokenCashback;
        } else if (msg.value >= 2 ether) {
            uint256 cashback = (msg.value * 3) / 100;
            (success, ) = address(msg.sender).call{value: cashback}("");
        }
    }

    function lockStake(uint256 noOfDays) public notPaused {
        require (lockStakeTime[msg.sender] == 0, "You have already locked your stake");
        
        uint256 lockTime = block.timestamp + (noOfDays * 1 days);
        lockStakeTime[msg.sender] = lockTime;
        lockedTime[msg.sender] = noOfDays;
    }

    function claimableAmount(address user) public view returns (uint256) {
        uint256 timePassed = (block.timestamp - lastClaimed[user]) / 1 days;
        uint256 amount = 0;
        if (lockedTime[user] > 0) {
            if (lockedTime[user] == 7) {
                amount = (amountStaked[user] * 7 * 23) / 1000;
            } else if (lockedTime[user] == 30) {
                amount = (amountStaked[user] * 30 * 35) / 1000;
            }
            timePassed -= lockedTime[user];
        }
        amount += (amountStaked[user] * timePassed * 20) / 1000;
        return amount;
    }

    function claim() public lock notPaused {
        require(amountStaked[msg.sender] > 0, "You have no stake");
        require(
            block.timestamp > lockStakeTime[msg.sender],
            "You can not claim before lock time"
        );
        uint256 amount = claimableAmount(msg.sender);
        bool success;
        (success, ) = address(msg.sender).call{value: amount * 98 / 100}("");
        require(success, "Transfer failed.");
        if (lockStakeTime[msg.sender] != 0) {
            delete lockStakeTime[msg.sender];
            delete lockedTime[msg.sender];
        }
        lastClaimed[msg.sender] = block.timestamp;
        totalClaimed[msg.sender] += amount;

        // send fees to marketing wallet
        (success, ) = address(marketingWallet).call{
            value: (amount * 2) / 100
        }("");
    }

    function claimToken() public lock notPaused {
        require(tokenClaimable[msg.sender] > 0, "You have no token to claim");
        uint256 amount = tokenClaimable[msg.sender];
        IBEP20(tokenAddress).transfer(msg.sender, amount * 98 / 100);
        tokenClaimable[msg.sender] = 0;

        // send fees to marketing wallet
        IBEP20(tokenAddress).transfer(marketingWallet, (amount * 2) / 100);
    }

    function withdraw() public lock notPaused {
        require(amountStaked[msg.sender] > 0, "You have no stake");

        // count the number of users
        totalUsers--;

        // can withdraw in first 4 days of staking
        require(
            (block.timestamp - startingTime) / 1 days < 4,
            "You can not withdraw after 4 days"
        );

        uint256 amount = (amountStaked[msg.sender] * 85) / 100;
        amountStaked[msg.sender] = 0;
        bool success;
        (success, ) = address(msg.sender).call{value: amount}("");

        // send fees to marketing wallet
        (success, ) = address(marketingWallet).call{value: (amount * 15) / 100}(
            ""
        );
    }

    function withdrawPartial(uint256 unstakeAmount) public lock notPaused {
        require(
            amountStaked[msg.sender] >= unstakeAmount,
            "You dont have this much staking amount"
        );

        // count the number of users
        totalUsers--;

        // can withdraw in first 4 days of staking
        require(
            (block.timestamp - startingTime) / 1 days < 4,
            "You can not withdraw after 4 days"
        );

        uint256 amount = (unstakeAmount * 85) / 100;
        amountStaked[msg.sender] -= amount;
        bool success;
        (success, ) = address(msg.sender).call{value: amount}("");

        // send fees to marketing wallet
        (success, ) = address(marketingWallet).call{
            value: (unstakeAmount * 15) / 100
        }("");
    }

    function reinvest() public notPaused {
        require(amountStaked[msg.sender] > 0, "You have no stake");
        uint256 amount = claimableAmount(msg.sender);
        tokenClaimable[msg.sender] += (amount * tokenPrice) / 1e18;
        lastClaimed[msg.sender] = block.timestamp;
    }

    // this function is to withdraw BNB sent to this address by mistake
    function withdrawEth(uint256 amount) external onlyOwner returns (bool) {
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        return success;
    }

    // this function is to withdraw BEP20 tokens sent to this address by mistake
    function withdrawBEP20(
        address _tokenAddress,
        uint256 amount
    ) external onlyOwner returns (bool) {
        IBEP20 token = IBEP20(_tokenAddress);
        bool success = token.transfer(msg.sender, amount);
        return success;
    }

    receive() external payable {}
}