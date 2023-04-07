// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

contract OPV_REF {
    mapping (address => address) listRef;

    event CreateRef (
        address user,
        address refBy
    );

    function createRef(address _refBy) public {
        require(listRef[msg.sender] == address(0),'Registered');
        listRef[msg.sender] = _refBy;
    } 

    function getRef(address _user) external view returns (address) {
        return listRef[_user];
    }
}