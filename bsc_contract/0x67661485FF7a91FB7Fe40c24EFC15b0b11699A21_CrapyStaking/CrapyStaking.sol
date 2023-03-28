/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

// SPDX-License-Identifier: MIT

// t.me/crapybaracoin

pragma solidity 0.8.19;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function decimals() external view returns (uint8);
}


contract CrapyStaking {
    uint256 constant APR = 500; // 1000% APR
    uint256 constant PENALTY = 20; // 20% penalty if unstaked before end
    uint256 constant MAX_STAKE = 10**6 * 10**18; // Maximum total amount staked
    uint256 constant withdrawTime = 1681574174;

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;

    IERC20 public token;

    uint256 public totalStaked; // Total amount staked
    uint256 public totalPenalty; // Total penalty balance

    address public owner;

    constructor(IERC20 _token) {
        token = _token;
        owner = msg.sender;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake zero tokens");
        require(
            totalStaked + amount <= MAX_STAKE,
            "Maximum stake amount exceeded"
        );

        // Transfer tokens from user to contract
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );

        // Add stake record
        stakes[msg.sender].amount += amount;
        stakes[msg.sender].timestamp = block.timestamp;

        // Update total staked
        totalStaked += amount;
    }

    function withdraw() external {
        require(stakes[msg.sender].amount > 0, "No stake to withdraw");

        uint256 stakeAmount = stakes[msg.sender].amount;
        uint256 stakeTime = block.timestamp - stakes[msg.sender].timestamp;
        uint256 penalty = 0;
        uint256 reward = 0;
        // Calculate reward and penalty
        if (stakeTime >= 10 days) {
            reward = (stakeAmount * APR * 10 days) / (365 days * 100);
        } else {
            reward = (stakeAmount * APR * stakeTime) / (365 days * 100);
            penalty = stakeAmount * PENALTY /100;
            totalPenalty += penalty;
        }

        // Subtract penalty from stake
        stakeAmount = stakeAmount - penalty;

        // Transfer tokens to user
        require(
            token.transfer(msg.sender, stakeAmount + reward),
            "Token transfer failed"
        );

        // Clear stake record
        delete stakes[msg.sender];

        // Update total staked
        totalStaked -= (stakeAmount+penalty);
    }

    function withdrawPenalty() external {
        require(msg.sender == owner, "Only owner can withdraw penalty");
        uint256 balance = totalPenalty;
        totalPenalty = 0;
        require(token.transfer(owner, balance), "Token transfer failed");
    }

    function getStake(address user)
        external
        view
        returns (uint256 amount, uint256 timestamp)
    {
        amount = stakes[user].amount;
        timestamp = stakes[user].timestamp;
    }

    function getRewardAndLockTime(address user)
        external
        view
        returns (uint256 reward, uint256 lockTime)
    {
        uint256 stakeAmount = stakes[user].amount;
        uint256 stakeTime = block.timestamp - stakes[user].timestamp;

        // Calculate reward and remaining lock time
        if (stakeAmount > 0) {
            reward = (stakeTime < 10 days) ?(stakeAmount * APR * stakeTime) / (365 days * 100):(stakeAmount * APR * 10 days) / (365 days * 100);
            lockTime = (stakeTime < 10 days) ? (10 days - stakeTime) : 0;
        } else {
            reward = 0;
            lockTime = 0;
        }
    }

    function withdrawRemainingTokens() external {
        require(block.timestamp>withdrawTime);
        require(msg.sender == owner, "Only owner can withdraw");
        require(token.transfer(owner, token.balanceOf(address(this))), "Token transfer failed");
    }
}