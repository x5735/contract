//SPDX-License-Identifier: UXUY
pragma solidity ^0.8.11;

interface IBridgeAdapter {
    struct BridgeParams {
        address tokenIn;
        uint chainIDOut;
        address tokenOut;
        uint amountIn;
        uint minAmountOut;
        address recipient;
        bytes data;
    }

    function supportSwap() external pure returns (bool);

    // @dev calls bridge router to fulfill the exchange
    // @return amountOut the amount of tokens transferred out, may be 0 if can not be fetched
    // @return txnID the transaction id of the bridge, may be 0 if not exist
    function bridge(BridgeParams calldata params) external payable returns (uint amountOut, uint txnID);
}