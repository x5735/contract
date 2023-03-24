/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBEP20 {
    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract DonationContract {
    address payable private owner;
    mapping(address => bool) public whitelistedTokens;
    mapping(address => uint256) public totalDonations;

    event DonationReceived(
        address indexed token,
        address indexed sender,
        uint256 amount
    );

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function whitelistToken(address tokenAddress) internal {
        whitelistedTokens[tokenAddress] = true;
    }

    function removeTokenFromWhitelist(address tokenAddress) external onlyOwner {
        whitelistedTokens[tokenAddress] = false;
    }

    function donateToken(address tokenAddress, uint256 amount) external {
        require(amount > 0, "Invalid amount");

        if (!whitelistedTokens[tokenAddress]) {
            whitelistToken(tokenAddress);
        }

        IBEP20 token = IBEP20(tokenAddress);
        uint256 balanceBefore = token.balanceOf(address(this));
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        uint256 balanceAfter = token.balanceOf(address(this));
        uint256 receivedAmount = balanceAfter - balanceBefore;

        totalDonations[tokenAddress] += receivedAmount;

        emit DonationReceived(tokenAddress, msg.sender, receivedAmount);
    }

    function donateNative() external payable {
        require(msg.value > 0, "Invalid amount");

        totalDonations[address(0)] += msg.value;

        emit DonationReceived(address(0), msg.sender, msg.value);
    }

    function withdrawToken(address tokenAddress) external onlyOwner {
        IBEP20 token = IBEP20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(owner, balance), "Transfer failed");

        totalDonations[tokenAddress] = 0;
    }

    function withdrawNative() external onlyOwner {
        require(address(this).balance > 0, "Insufficient balance");

        payable(owner).transfer(address(this).balance);

        totalDonations[address(0)] = 0;
    }
}