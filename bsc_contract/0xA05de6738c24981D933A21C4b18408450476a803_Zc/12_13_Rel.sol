// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

contract Rel {
    event Bind(address indexed user, address indexed parent);
    event Upgrade(address indexed user, uint256 indexed level);

    address public pool;

    mapping(address => address) public parents;

    mapping(bytes32 => address[]) public children;

    mapping(address => uint256) public levelPerUser;

    mapping(address => mapping(uint256 => uint256)) public countPerLevelPerUser;

    constructor(address genesis) {
        parents[genesis] = address(1);
        emit Bind(genesis, address(1));
    }

    function bind(address parent) external {
        require(parents[msg.sender] == address(0), "already bind");
        require(parents[parent] != address(0), "parent invalid");
        parents[msg.sender] = parent;
        countPerLevelPerUser[parent][0]++;
        emit Bind(msg.sender, parent);
    }

    function setPool(address adr) external {
        require(pool == address(0) && adr != address(0));
        pool = adr;
    }

    function setLevel(address adr, uint256 level) external {
        require(msg.sender == pool, "not allowed");
        levelPerUser[adr] = level;
        emit Upgrade(adr, level);
    }

    function updateCountPerLevel(
        address user,
        uint256 minusLevel,
        uint256 addLevel
    ) external {
        require(msg.sender == pool, "not allowed");
        countPerLevelPerUser[user][minusLevel]--;
        countPerLevelPerUser[user][addLevel]++;
    }
}