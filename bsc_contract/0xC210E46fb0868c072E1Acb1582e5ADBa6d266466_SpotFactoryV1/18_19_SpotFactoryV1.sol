pragma solidity 0.8.17;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/proxy/Clones.sol";
import {IRDNRegistry} from "../../RDN/interfaces/IRDNRegistry.sol";
import "./IMasterChef2.sol";
import "./ISpotV1.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract SpotFactoryV1 is AccessControlEnumerable{
    
     bytes32 public constant UPDATEIMPLEMENTATION_ROLE = keccak256("UPDATEIMPLEMENTATION_ROLE");

    event SpotCreated(address indexed spotAddress, uint indexed ownerId, uint indexed poolIndex);

    using SafeERC20 for IERC20;

    address public implementation;
    address public immutable registry;
    address public immutable pool;
    address public immutable router;
    address public immutable rewardToken;
    address public immutable wrapper;

    mapping(uint => mapping(uint => address)) public spots;

    constructor(address _implementation, address _registry, address _pool, address _router, address _rewardToken, address _wrapper, address _admin) {
        implementation = _implementation;
        registry = _registry;
        pool = _pool;
        router = _router;
        rewardToken = _rewardToken;
        wrapper = _wrapper;
        _setupRole(DEFAULT_ADMIN_ROLE, _admin);
        _setupRole(UPDATEIMPLEMENTATION_ROLE, _admin);
    }

    function create(uint poolIndex) public returns(address) {
        uint ownerId = IRDNRegistry(registry).getUserIdByAddress(msg.sender);
        require(IRDNRegistry(registry).isActive(ownerId), "not active RDN");
        address spot = _create(ownerId, poolIndex);
        return spot;
    }

    function createAndDeposit(
        uint poolIndex,
        uint amount, 
        ISpotV1.Swap memory swap0, 
        ISpotV1.Swap memory swap1,
        ISpotV1.Swap memory swapReward0,
        ISpotV1.Swap memory swapReward1,
        uint deadline
    ) public payable returns(address) {
        uint ownerId = IRDNRegistry(registry).getUserIdByAddress(msg.sender);
        require(IRDNRegistry(registry).isActive(ownerId), "not active RDN");
        address spot = _create(ownerId, poolIndex);
        if (msg.value > 0) {
            ISpotV1(spot).deposit{value: msg.value}(amount, swap0, swap1, swapReward0, swapReward1, deadline);
        } else {
            IERC20(swap0.path[0]).safeTransferFrom(msg.sender, address(this), amount);
            amount = IERC20(swap0.path[0]).balanceOf(address(this));
            IERC20(swap0.path[0]).approve(spot, amount);
            ISpotV1(spot).deposit(amount, swap0, swap1, swapReward0, swapReward1, deadline);
        }
        return spot;
    }

    function updateImplementation(address _implementation) public onlyRole(UPDATEIMPLEMENTATION_ROLE) {
        implementation = _implementation;
    }

    function _create(uint ownerId, uint poolIndex) internal returns(address) {
        require(spots[ownerId][poolIndex] == address(0), "spot already created");

        address stakingToken = IMasterChef2(pool).lpToken(poolIndex);
        require(stakingToken != address(0), "wrong pool index");

        address spot = Clones.clone(implementation);

        ISpotV1(spot).init(wrapper, pool, router, stakingToken, rewardToken, poolIndex, ownerId, registry, address(this));

        // pools[ownerId].push(poolIndex);
        spots[ownerId][poolIndex] = spot;
        
        emit SpotCreated(spot, ownerId, poolIndex);
        
        return spot;
    }

    function getAllUserSpots(uint ownerId) public view returns(address[] memory) {
        uint poolsCount = IMasterChef2(pool).poolLength();
        address[] memory spotsArray = new address[](poolsCount);
        for (uint i=0; i < poolsCount; i++) {
            spotsArray[i] = spots[ownerId][i];
        }
        return spotsArray;
    }

    function getSpotAddress(uint ownerId, uint poolIndex) public view returns(address) {
        return spots[ownerId][poolIndex];
    }

}