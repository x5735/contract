// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DracooSignIn {
    event SignIn(address indexed user, uint256 timestamp);

    function signIn() external {
        emit SignIn(msg.sender, block.timestamp);
    }
}