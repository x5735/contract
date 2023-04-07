/**
 *Submitted for verification at BscScan.com on 2023-03-31
*/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

//Contract to create [Biteables] token
contract Token {
//Token Details
string public name = "Biteables";
string public symbol = "BITES";
uint256 public decimals = 18;
uint256 public totalSupply = 1000000 * 10 ** decimals;

//Token Balances
mapping(address => uint256) public balanceOf;

//Token Vesting
mapping(address => uint256) public vestingBalance;
mapping(address => uint256) public vestingTime;

//Token Wallets
address public teamWallet = 0xDb16DB911a5CDdc773cf55c300C95B48d1514851;
address public marketingWallet = 0x3f4841247f770FE62C7226557A061E296cb3b396;
address public airdropWallet = 0x04C584264bBB12edE77d7da011E5C54525FC4402;
address public burnWallet = 0x3B525543B51eBdb3AF51A2754d4939240d21D1C2;
address public circulationWallet = 0xd31f6be8aF0ea57CD00F44e08CCAbc0535EE1ee3;
address public feeWallet = 0x0Cd167C5DB15Bea70D4E54dB4D9CBCcdC5C5eD12;

//Transaction Fees
uint256 public marketingFee = 4;
uint256 public teamFee = 6;

//Events
event Transfer(address indexed from, address indexed to, uint256 value);

//Constructor
constructor() {
    balanceOf[circulationWallet] = totalSupply * 4 / 10; //40% Circulation - 10% at TGE
    vestingBalance[teamWallet] = totalSupply * 25 / 100; //25% Team
    vestingTime[teamWallet] = block.timestamp + 12 * 30 days; //Vesting: 12 Months
    balanceOf[burnWallet] = totalSupply * 10 / 100; //10% Burn
    balanceOf[airdropWallet] = totalSupply * 10 / 100; //10% Airdrop
    vestingBalance[marketingWallet] = totalSupply * 15 / 100; //15% Marketing
    vestingTime[marketingWallet] = block.timestamp + 18 * 30 days; //Vesting: 18 Months
}

//Function to calculate transaction fees
function _calculateFees(uint256 _amount) private view returns (uint256, uint256) {
    uint256 marketingAmount = _amount * marketingFee / 100;
    uint256 teamAmount = _amount * teamFee / 100;
    uint256 feeTotal = marketingAmount + teamAmount;
    return (marketingAmount, teamAmount);
}

//Function to transfer tokens
function transfer(address _to, uint256 _amount) public returns (bool) {
    require(_to != address(0), "Invalid address");
    require(_amount > 0, "Invalid amount");

    uint256 marketingAmount;
    uint256 teamAmount;
    (marketingAmount, teamAmount) = _calculateFees(_amount);

    uint256 transferAmount = _amount - marketingAmount - teamAmount;
    balanceOf[msg.sender] -= _amount;
    balanceOf[_to] += transferAmount;
    balanceOf[marketingWallet] += marketingAmount;
    balanceOf[teamWallet] += teamAmount;
emit Transfer(msg.sender, _to, transferAmount);
emit Transfer(msg.sender, marketingWallet, marketingAmount);
emit Transfer(msg.sender, teamWallet, teamAmount);
return true;
}

//Function to check vesting balance of a wallet
function checkVestingBalance(address _wallet) public view returns (uint256) {
if (block.timestamp < vestingTime[_wallet]) {
return 0;
} else {
return vestingBalance[_wallet] * (block.timestamp - vestingTime[_wallet]) / (30 days);
}
}
//Function to claim vested tokens for a wallet
function claimVestedTokens() public returns (bool) {
uint256 vestedAmount = checkVestingBalance(msg.sender);
require(vestedAmount > 0, "No vested tokens available");
}

//Function to burn tokens
function burn(uint256 _amount) public returns (bool) {
require(_amount > 0, "Invalid amount");
require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
balanceOf[msg.sender] -= _amount;
balanceOf[burnWallet] += _amount;
totalSupply -= _amount;
emit Transfer(msg.sender, address(0), _amount);
return true;
}
//Fallback function
fallback() external payable {
revert("Invalid transaction");
}

//Receive function
receive() external payable {
revert("Invalid transaction");
}

//Function to update marketing fee
function setMarketingFee(uint256 _marketingFee) public {
require(msg.sender == marketingWallet, "Only marketing wallet can update marketing fee");
require(_marketingFee <= 10, "Invalid fee"); //Fee cannot be more than 10%
marketingFee = _marketingFee;
}

//Function to update team fee
function setTeamFee(uint256 _teamFee) public {
require(msg.sender == teamWallet, "Only team wallet can update team fee");
require(_teamFee <= 10, "Invalid fee"); //Fee cannot be more than 10%
teamFee = _teamFee;
}

//Function to transfer ownership of marketing wallet
function transferMarketingWalletOwnership(address _newOwner) public {
require(msg.sender == marketingWallet, "Only current owner can transfer ownership");
marketingWallet = _newOwner;
}

//Function to transfer ownership of team wallet
function transferTeamWalletOwnership(address _newOwner) public {
require(msg.sender == teamWallet, "Only current owner can transfer ownership");
teamWallet = _newOwner;
}
}