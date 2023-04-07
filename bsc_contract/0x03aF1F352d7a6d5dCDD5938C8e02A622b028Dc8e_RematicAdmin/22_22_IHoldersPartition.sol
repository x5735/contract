// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IHoldersPartition {

    function process() external;
    function setHoldersStandard(address _address) external;
    function recordTransactionHistory(address payable account, uint256 amount, bool isSell) external;

    function setClaimWait(uint256 _newvalue) external;
    function setEligiblePeriod(uint256 _newvalue) external;
    function setEligibleMinimunBalance(uint256 _newvalue) external;
    function setTierPercentage(uint256 _tierIndex, uint256 _newvalue) external;

    function lastProcessedIndex() external returns(uint256);
    function checkIfUnfinishedWork() external returns(bool);
    function updateTotalBUSD() external;

}