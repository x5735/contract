// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.4;

import "../interfaces/IBiswapCallback.sol";
import "../interfaces/IBiswapFactoryV3.sol";
import "../interfaces/IBiswapPoolV3.sol";

import "../libraries/Path.sol";

import "./base/base.sol";

contract QuoterXY is Base, IBiswapCallback {

    using Path for bytes;

    struct SwapCallbackData {
        bytes path;
        address payer;
    }

    uint256 private amountDesireCached;
    bool private chainMode;

    /// @notice Construct this contract.
    /// @param _factory address BiswapFactoryV3
    /// @param _weth address of weth token
    constructor(address _factory, address _weth) Base(_factory, _weth) {}


    /// @notice Make multiple function calls in this contract in a single transaction
    ///     and return the data for each function call, donot revert if any function call fails
    /// @param data The encoded function data for each function call
    /// @return successes whether catch a revert in the function call of data[i]
    /// @return results result of each function call
    function multicallNoRevert(bytes[] calldata data) external payable returns (bool[]memory successes, bytes[] memory results) {
        results = new bytes[](data.length);
        successes = new bool[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);

            successes[i] = success;
            results[i] = result;
        }
    }

    function parseRevert(bytes memory reason)
        private
        pure
        returns (
            uint256 amount,
            int24 currPt
        )
    {
        if (reason.length != 64) {
            if (reason.length < 68) revert('Unexpected error');
            assembly {
                reason := add(reason, 0x04)
            }
            revert(abi.decode(reason, (string)));
        }
        return abi.decode(reason, (uint256, int24));
    }

    function parseRevertXY(bytes memory reason)
        private
        pure
        returns (
            uint256 amountX,
            uint256 amountY
        )
    {
        if (reason.length != 64) {
            if (reason.length < 68) revert('Unexpected error');
            assembly {
                reason := add(reason, 0x04)
            }
            revert(abi.decode(reason, (string)));
        }
        return abi.decode(reason, (uint256, uint256));
    }

    /// @notice Callback for swapY2X and swapY2XDesireX, in order to mark computed-amount of token and point after exchange.
    /// @param x amount of tokenX trader acquired
    /// @param y amount of tokenY need to pay from trader
    /// @param path encoded SwapCallbackData
    function swapY2XCallback(
        uint256 x,
        uint256 y,
        bytes calldata path
    ) external view override {
        (address token0, address token1, uint16 fee) = path.decodeFirstPool();
        verify(token0, token1, fee);

        address poolAddr = pool(token0, token1, fee);
        (
            ,
            int24 currPt,
            ,
            ,
            ,
            ,
            ,
            ,
            ,
        ) = IBiswapPoolV3(poolAddr).state();

        if (!chainMode) {
            assembly {
                let ptr := mload(0x40)
                mstore(ptr, x)
                mstore(add(ptr, 0x20), y)
                revert(ptr, 64)
            }
        } else {
            if (token0 < token1) {
                // token1 is y, amount of token1 is calculated
                // called from pool.swapY2XDesireX(...)
                require(x >= amountDesireCached, 'x Pool Not Enough');
                assembly {
                    let ptr := mload(0x40)
                    mstore(ptr, y)
                    mstore(add(ptr, 0x20), currPt)
                    revert(ptr, 64)
                }
            } else {
                // token0 is y, amount of token0 is input param
                // called from pool.swapY2X(...)
                assembly {
                    let ptr := mload(0x40)
                    mstore(ptr, x)
                    mstore(add(ptr, 0x20), currPt)
                    revert(ptr, 64)
                }
            }
        }
    }

    /// @notice Callback for swapX2Y and swapX2YDesireY in order to mark computed-amount of token and point after exchange.
    /// @param x amount of tokenX need to pay from trader
    /// @param y amount of tokenY trader acquired
    /// @param path encoded SwapCallbackData
    function swapX2YCallback(
        uint256 x,
        uint256 y,
        bytes calldata path
    ) external view override {
        (address token0, address token1, uint16 fee) = path.decodeFirstPool();
        verify(token0, token1, fee);

        address poolAddr = pool(token0, token1, fee);
        (
            ,
            int24 currPt,
            ,
            ,
            ,
            ,
            ,
            ,
            ,
        ) = IBiswapPoolV3(poolAddr).state();

        if (!chainMode) {
            assembly {
                let ptr := mload(0x40)
                mstore(ptr, x)
                mstore(add(ptr, 0x20), y)
                revert(ptr, 64)
            }
        } else {

            if (token0 < token1) {
                // token0 is x, amount of token0 is input param
                // called from pool.swapX2Y(...)
                assembly {
                    let ptr := mload(0x40)
                    mstore(ptr, y)
                    mstore(add(ptr, 0x20), currPt)
                    revert(ptr, 64)
                }
            } else {
                // token1 is x, amount of token1 is calculated param
                // called from pool.swapX2YDesireY(...)
                require(y >= amountDesireCached, 'y Pool Not Enough');
                assembly {
                    let ptr := mload(0x40)
                    mstore(ptr, x)
                    mstore(add(ptr, 0x20), currPt)
                    revert(ptr, 64)
                }
            }
        }
    }

    function swapAmountSingleInternal(
        address tokenIn,
        address tokenOut,
        uint16 fee,
        uint128 amount
    ) private returns (uint256 acquire, int24 currPt) {
        address poolAddr = pool(tokenOut, tokenIn, fee);
        if (tokenIn < tokenOut) {
            int24 boundaryPoint = -799999;
            try
                IBiswapPoolV3(poolAddr).swapX2Y(
                    address(this), amount, boundaryPoint,
                    abi.encodePacked(tokenIn, fee, tokenOut)
                )
            {} catch (bytes memory reason) {
                return parseRevert(reason);
            }
        } else {
            int24 boundaryPoint = 799999;
            try
                IBiswapPoolV3(poolAddr).swapY2X(
                    address(this), amount, boundaryPoint,
                    abi.encodePacked(tokenIn, fee, tokenOut)
                )
            {} catch (bytes memory reason) {
                return parseRevert(reason);
            }
        }
    }

    function swapAmount(
        uint128 amount,
        bytes memory path
    ) public returns (uint256 acquire, int24[] memory pointAfterList) {
        // allow swapping to the router address with address 0

        uint256 i = 0;
        pointAfterList = new int24[](path.numPools());

        chainMode = true;
        while (true) {
            bool hasMultiplePools = path.hasMultiplePools();
            (address tokenIn, address tokenOut, uint16 fee) = path.decodeFirstPool();
            int24 finalPt;
            (acquire, finalPt) = swapAmountSingleInternal(tokenIn, tokenOut, fee, amount);
            pointAfterList[i] = finalPt;
            i ++;

            // decide whether to continue or terminate
            if (hasMultiplePools) {
                path = path.skipToken();
                amount = uint128(acquire);
            } else {
                break;
            }
        }
        delete chainMode;
    }

    function swapDesireSingleInternal(
        address tokenIn,
        address tokenOut,
        uint16 fee,
        uint128 desire
    ) private returns (uint256 cost, int24 currPt) {
        address poolAddr = pool(tokenOut, tokenIn, fee);
        amountDesireCached = desire;
        if (tokenIn < tokenOut) {
            int24 boundaryPoint = -799999;
            try
                IBiswapPoolV3(poolAddr).swapX2YDesireY(
                    address(this), desire + 1, boundaryPoint,
                    abi.encodePacked(tokenOut, fee, tokenIn)
                )
            {} catch (bytes memory reason) {
                return parseRevert(reason);
            }
        } else {
            int24 boundaryPoint = 799999;
            try
                IBiswapPoolV3(poolAddr).swapY2XDesireX(
                    address(this), desire + 1, boundaryPoint,
                    abi.encodePacked(tokenOut, fee, tokenIn)
                )
            {} catch (bytes memory reason) {
                return parseRevert(reason);
            }
        }
    }

    function swapDesire(
        uint128 desire,
        bytes memory path
    ) public returns (uint256 cost, int24[] memory pointAfterList) {
        // allow swapping to the router address with address 0

        uint256 i = 0;
        pointAfterList = new int24[](path.numPools());

        chainMode = true;
        while (true) {
            bool hasMultiplePools = path.hasMultiplePools();
            (address tokenOut, address tokenIn, uint16 fee) = path.decodeFirstPool();
            int24 finalPt;
            (cost, finalPt) = swapDesireSingleInternal(tokenIn, tokenOut, fee, desire);
            pointAfterList[i] = finalPt;
            i ++;

            // decide whether to continue or terminate
            if (hasMultiplePools) {
                path = path.skipToken();
                desire = uint128(cost);
            } else {
                break;
            }
        }
        delete chainMode;
        delete amountDesireCached;
    }

    /// @notice Estimate amount of tokenX acquired when user wants to buy tokenX given max amount of tokenY user willing to pay.
    /// calling this function will not generate any real exchanges in the pool
    /// @param tokenX tokenX of swap pool
    /// @param tokenY tokenY of swap pool
    /// @param fee fee amount of swap pool
    /// @param amount max-amount of tokenY user willing to pay
    /// @param highPt highest point during exchange
    /// @return amountX estimated amount of tokenX user would acquire
    /// @return amountY estimated amount of tokenX user would cost
    function swapY2X(
        address tokenX,
        address tokenY,
        uint16 fee,
        uint128 amount,
        int24 highPt
    ) public returns (uint256 amountX, uint256 amountY) {
        require(tokenX < tokenY, "x<y");
        address poolAddr = pool(tokenX, tokenY, fee);
        try
            IBiswapPoolV3(poolAddr).swapY2X(
                address(this), amount, highPt,
                abi.encodePacked(tokenY, fee, tokenX)
            )
        {} catch (bytes memory reason) {
            (amountX, amountY) = parseRevertXY(reason);
        }
    }

    /// @notice Estimate amount of tokenY required when an user wants to buy token given amount of tokenX user wants to buy
    ///    calling this function will not generate any real exchanges in the pool.
    /// @param tokenX tokenX of swap pool
    /// @param tokenY tokenY of swap pool
    /// @param fee fee amount of swap pool
    /// @param desireX amount of tokenX user wants to buy
    /// @param highPt highest point during exchange
    /// @return amountX estimated amount of tokenX user would acquire
    /// @return amountY estimated amount of tokenY user need to pay
    function swapY2XDesireX(
        address tokenX,
        address tokenY,
        uint16 fee,
        uint128 desireX,
        int24 highPt
    ) public returns (uint256 amountX, uint256 amountY) {
        require(tokenX < tokenY, "x<y");
        address poolAddr = pool(tokenX, tokenY, fee);
        try
            IBiswapPoolV3(poolAddr).swapY2XDesireX(
                address(this), desireX, highPt,
                abi.encodePacked(tokenX, fee, tokenY)
            )
        {} catch (bytes memory reason) {
            (amountX, amountY) = parseRevertXY(reason);
        }
    }

    /// @notice Estimate amount of tokenY acquired when an user wants to buy tokenY given max amount of tokenX user willing to pay
    ///    calling this function will not generate any real exchanges in the pool.
    /// @param tokenX tokenX of swap pool
    /// @param tokenY tokenY of swap pool
    /// @param fee fee amount of swap pool
    /// @param amount max-amount of tokenX user willing to pay
    /// @param lowPt lowest point during exchange
    /// @return amountX amount of tokenX need to pay
    /// @return amountY estimated amount of tokenY user would acquire
    function swapX2Y(
        address tokenX,
        address tokenY,
        uint16 fee,
        uint128 amount,
        int24 lowPt
    ) public returns (uint256 amountX, uint256 amountY) {
        require(tokenX < tokenY, "x<y");
        address poolAddr = pool(tokenX, tokenY, fee);
        try
            IBiswapPoolV3(poolAddr).swapX2Y(
                address(this), amount, lowPt,
                abi.encodePacked(tokenX, fee, tokenY)
            )
        {} catch (bytes memory reason) {
            (amountX, amountY) = parseRevertXY(reason);
        }
    }

    /// @notice Estimate amount of tokenX required when an user wants to buy tokenY given amount of tokenX user wants to buy
    ///    calling this function will not generate any real exchanges in the pool.
    /// @param tokenX tokenX of swap pool
    /// @param tokenY tokenY of swap pool
    /// @param fee fee amount of swap pool
    /// @param desireY amount of tokenY user wants to buy
    /// @param lowPt highest point during exchange
    /// @return amountX estimated amount of tokenX user need to pay
    /// @return amountY estimated amount of tokenY user would acquire
    function swapX2YDesireY(
        address tokenX,
        address tokenY,
        uint16 fee,
        uint128 desireY,
        int24 lowPt
    ) public returns (uint256 amountX, uint256 amountY) {
        require(tokenX < tokenY, "x<y");
        address poolAddr = pool(tokenX, tokenY, fee);
        try
            IBiswapPoolV3(poolAddr).swapX2YDesireY(
                address(this), desireY, lowPt,
                abi.encodePacked(tokenY, fee, tokenX)
            )
        {} catch (bytes memory reason) {
            (amountX, amountY) = parseRevertXY(reason);
        }
    }

}