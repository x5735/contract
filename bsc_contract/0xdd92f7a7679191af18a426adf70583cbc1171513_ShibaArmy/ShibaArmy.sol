/**
 *Submitted for verification at BscScan.com on 2023-03-25
*/

// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract ShibaArmy { 
    mapping(address => uint) public balances; 
    uint public totalSupply = 100000000000 * 10 ** 18; 
    string public name = "Shiba Army"; 
    string public symbol = "SHARMY"; 
    uint public decimals = 18; 

    uint public transactionLimit = 1000000 * 10 ** 18; 
    address public marketingWallet; 
    address public ownerWallet; 
    uint public taxPercentage; 

    event Transfer(address indexed from, address indexed to, uint value); 

    constructor(address _marketingWallet, address _ownerWallet, uint _taxPercentage) { 
        require(_taxPercentage <= 100, "Tax percentage must be between 0 and 100"); 

        marketingWallet = _marketingWallet; 
        ownerWallet = _ownerWallet; 
        taxPercentage = _taxPercentage; 

        balances[msg.sender] = totalSupply; 
    } 

    function balanceOf(address owner) public view returns(uint) { 
        return balances[owner]; 
    } 

    function setTransactionLimit(uint256 newLimit) public onlyOwner { 
        transactionLimit = newLimit; 
    } 

    function setTaxPercentage(uint256 newPercentage) public onlyOwner { 
        require(newPercentage <= 100, "Tax percentage must be between 0 and 100"); 
        taxPercentage = newPercentage; 
    } 

    function transfer(address to, uint value) public returns(bool) { 
        require(balanceOf(msg.sender) >= value, 'Insufficient balance'); 
        require(value <= transactionLimit, "Transfer amount exceeds the transaction limit"); 

        uint tax = (value * taxPercentage) / 100; 
        uint netAmount = value - tax; 

        balances[to] += netAmount; 
        balances[msg.sender] -= value; 
        balances[marketingWallet] += tax; 

        emit Transfer(msg.sender, to, netAmount); 
        emit Transfer(msg.sender, marketingWallet, tax); 

        return true; 
    } 

    modifier onlyOwner() { 
        require(msg.sender == ownerWallet, "Caller is not the owner"); 
        _; 
    } 
}