/**
 *Submitted for verification at BscScan.com on 2023-03-30
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.19;

contract EXMToken {
    string public name = "ExmToken";
    string public symbol = "EXM";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
        emit Transfer(address(0), msg.sender, _initialSupply);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid recipient address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Invalid spender address");

        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid recipient address");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");

        balanceOf[_from] -= _value; // <-- vulnerable line
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function withdraw(uint amount) public {
        if (balanceOf[msg.sender] >= amount) {
            balanceOf[msg.sender] -= amount;
            (bool success, ) = msg.sender.call{value: amount}("");
            if (!success) {
                balanceOf[msg.sender] += amount;
            }
        }
    }

    function delegate(address _delegate, bytes memory _data) public {
        (bool success, ) = _delegate.delegatecall(_data);
        if (!success) {
            revert();
        }
    }
}