/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

/*

AISpaceID
https://t.me/AISpaceIDTOKEN
*/
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract AISpaceIDToken {
    string public name = "AISpaceID";
    string public symbol = "AISpaceID";
    uint256 public totalSupply = 10000000000000000000000;
    uint8 public decimals = 9;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(
        address indexed _ownerAISpaceID,
        address indexed spenderAISpaceID,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address private owner;
    event OwnershipRenounced();

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }


    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address spenderAISpaceID, uint256 _value)
        public
        returns (bool success)
    {
        require(address(0) != spenderAISpaceID);
        allowance[msg.sender][spenderAISpaceID] = _value;
        emit Approval(msg.sender, spenderAISpaceID, _value);
        return true;
    }

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function renounceOwnership() public {
        require(msg.sender == owner);
        emit OwnershipRenounced();
        owner = address(0);
    }
}