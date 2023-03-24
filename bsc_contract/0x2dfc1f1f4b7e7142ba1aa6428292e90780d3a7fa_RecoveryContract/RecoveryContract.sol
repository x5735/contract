/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract RecoveryContract {
    address public owner;
    mapping(address => bool) public acceptedTokens;
    mapping(address => uint256) public tokenBalances;

    constructor() {
        owner = msg.sender;
    }

    function acceptToken(address token) public {
        require(
            msg.sender == owner,
            "Only the contract owner can add accepted tokens"
        );
        acceptedTokens[token] = true;
    }

    function depositToken(address token, uint256 amount) public {
        require(acceptedTokens[token], "Token not accepted by this contract");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        tokenBalances[token] += amount;
    }

    function depositNative() public payable {
        tokenBalances[address(0)] += msg.value;
    }

    function withdrawToken(address token, uint256 amount) public {
        require(
            msg.sender == owner,
            "Only the contract owner can withdraw tokens"
        );
        require(tokenBalances[token] >= amount, "Insufficient token balance");
        (bool success, ) = address(token).call(
            abi.encodeWithSelector(0xa9059cbb, msg.sender, amount)
        );
        require(success, "Token transfer failed");
        tokenBalances[token] -= amount;
    }

    function withdrawNative(uint256 amount) public {
        require(
            msg.sender == owner,
            "Only the contract owner can withdraw native tokens"
        );
        require(
            tokenBalances[address(0)] >= amount,
            "Insufficient native token balance"
        );
        payable(msg.sender).transfer(amount);
        tokenBalances[address(0)] -= amount;
    }
}