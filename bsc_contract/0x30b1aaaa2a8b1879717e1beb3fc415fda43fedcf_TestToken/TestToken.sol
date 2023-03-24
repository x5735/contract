/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TestToken {
    string public constant name = "Bot Tokens RO";
    string public constant symbol = "BTRO";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(uint256 initialSupply) {
        totalSupply = initialSupply;
        balanceOf[msg.sender] = initialSupply;
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}