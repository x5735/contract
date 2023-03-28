/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

abstract contract Auth {
    address internal owner;
    mapping (address => bool) internal authorizations;

    constructor(address _owner) {
        owner = _owner;
        authorizations[_owner] = true;
    }

    /**
     * Function modifier to require caller to be contract owner
     */
    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER"); _;
    }

    /**
     * Function modifier to require caller to be authorized
     */
    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    /**
     * Authorize address. Owner only
     */
    function authorize(address adr) public onlyOwner {
        authorizations[adr] = true;
    }

    /**
     * Remove address' authorization. Owner only
     */
    function unauthorize(address adr) public onlyOwner {
        authorizations[adr] = false;
    }

    /**
     * Check if address is owner
     */
    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    /**
     * Return address' authorization status
     */
    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    /**
     * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
     */
    function transferOwnership(address payable adr) public onlyOwner {
        owner = adr;
        authorizations[adr] = true;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);
}

contract VIPManager is Auth {
    mapping(address => bool) private vipMembers;

    constructor () Auth(msg.sender) {}

    function addVipMembers(address[] calldata _members) external authorized {
        for (uint256 i = 0; i < _members.length; i++) {
            vipMembers[_members[i]] = true;
        }
    }

    function removeVipMembers(address[] calldata _members) external authorized {
        for (uint256 i = 0; i < _members.length; i++) {
            vipMembers[_members[i]] = false;
        }
    }

    function isVipMember(address _member) external view returns (bool) {
        return vipMembers[_member];
    }
}