/**
 *Submitted for verification at BscScan.com on 2023-03-30
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract Airdrop {
    bool entered = false;

    modifier nonReentrant() {
        require(!entered, "Airdrop::nonReentrant: Reentrancy not allowed");
        entered = true;
        _;
        entered = false;
    }

    function airdrop(address token, address[] calldata addresses, uint256[] calldata amounts) external nonReentrant {
        require(addresses.length == amounts.length, "Airdrop::airdrop: lengths of addresses and amounts not equal");
        for (uint i = 0; i < addresses.length; i++) {
            uint256 balance = IERC20(token).balanceOf(msg.sender);
            if (balance < amounts[i]) {
                require(IERC20(token).transferFrom(msg.sender, addresses[i], balance), "Airdrop::airdrop: transfer failed");
            } else {
                require(IERC20(token).transferFrom(msg.sender, addresses[i], amounts[i]), "Airdrop::airdrop: transfer failed");
            }
        }
    }
}