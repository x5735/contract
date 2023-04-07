/**
 *Submitted for verification at BscScan.com on 2023-03-30
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElectroBits {
    // Token properties
    string public name = "ElectroBits";
    string public symbol = "EBTC";
    uint256 public totalSupply = 1000000000;
    uint8 public decimals = 18;
    
    // Address of the contract owner
    address public owner;
    
    // Events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed _burner, uint256 _value);
    
    // Balances and allowances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    // Constructor
    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
    }
    
    // Transfer tokens
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    // Approve a spender
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    // Transfer from
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    // Burn tokens
    function burn(uint256 _value) public returns (bool success) {
        require(msg.sender == owner);
        require(_value <= balanceOf[msg.sender]);
        totalSupply -= _value;
        balanceOf[msg.sender] -= _value;
        emit Transfer(msg.sender, address(0), _value);
        emit Burn(msg.sender, _value);
        return true;
    }
    
    // Add tokens
    function addTokens(uint256 _value) public returns (bool success) {
        require(msg.sender == owner);
        totalSupply += _value;
        balanceOf[msg.sender] += _value;
        emit Transfer(address(0), msg.sender, _value);
        return true;
    }
    
    // Remove tokens
    function removeTokens(uint256 _value) public returns (bool success) {
        require(msg.sender == owner);
        require(_value <= balanceOf[msg.sender]);
        totalSupply -= _value;
        balanceOf[msg.sender] -= _value;
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }
    
    // Burn 5000 tokens each week
    function weeklyBurn() public returns (bool success) {
        require(msg.sender == owner);
        require(totalSupply >= 5000);
        totalSupply -= 5000;
        balanceOf[address(0)] += 5000;
        emit Transfer(owner, address(0), 5000);
        emit Burn(owner, 5000);
        return true;
    }
}