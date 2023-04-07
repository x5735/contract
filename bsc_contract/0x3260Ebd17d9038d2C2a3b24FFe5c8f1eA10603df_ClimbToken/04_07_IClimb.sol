//SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IClimb is IERC20 {
    function burn(uint256 amount) external;

    function burn() external payable;

    function sell(uint256 amount) external;

    function sell(address recipient, uint256 amount) external;

    function getUnderlyingAsset() external returns (address);

    function buy(uint256 numTokens) external returns (bool);

    function buy(address recipient, uint256 numTokens) external returns (bool);

    function eraseHoldings(uint256 nHoldings) external;

    function transferOwnership(address newOwner) external;

    function volumeFor(address wallet) external view returns (uint256);

    function owner() external view returns (address);
}