/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

/// @title The interface for the Uniswap V3 Factory
/// @notice The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees
interface IUniswapV3Factory {
    /// @notice Emitted when the owner of the factory is changed
    /// @param oldOwner The owner before the owner was changed
    /// @param newOwner The owner after the owner was changed
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    /// @notice Emitted when a pool is created
    /// @param token0 The first token of the pool by address sort order
    /// @param token1 The second token of the pool by address sort order
    /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
    /// @param tickSpacing The minimum number of ticks between initialized ticks
    /// @param pool The address of the created pool
    event PoolCreated(
        address indexed token0,
        address indexed token1,
        uint24 indexed fee,
        int24 tickSpacing,
        address pool
    );

    /// @notice Emitted when a new fee amount is enabled for pool creation via the factory
    /// @param fee The enabled fee, denominated in hundredths of a bip
    /// @param tickSpacing The minimum number of ticks between initialized ticks for pools created with the given fee
    event FeeAmountEnabled(uint24 indexed fee, int24 indexed tickSpacing);

    /// @notice Returns the current owner of the factory
    /// @dev Can be changed by the current owner via setOwner
    /// @return The address of the factory owner
    function owner() external view returns (address);

    /// @notice Returns the tick spacing for a given fee amount, if enabled, or 0 if not enabled
    /// @dev A fee amount can never be removed, so this value should be hard coded or cached in the calling context
    /// @param fee The enabled fee, denominated in hundredths of a bip. Returns 0 in case of unenabled fee
    /// @return The tick spacing
    function feeAmountTickSpacing(uint24 fee) external view returns (int24);

    /// @notice Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist
    /// @dev tokenA and tokenB may be passed in either token0/token1 or token1/token0 order
    /// @param tokenA The contract address of either token0 or token1
    /// @param tokenB The contract address of the other token
    /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
    /// @return pool The pool address
    function getPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external view returns (address pool);

    /// @notice Creates a pool for the given two tokens and fee
    /// @param tokenA One of the two tokens in the desired pool
    /// @param tokenB The other of the two tokens in the desired pool
    /// @param fee The desired fee for the pool
    /// @dev tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
    /// from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
    /// are invalid.
    /// @return pool The address of the newly created pool
    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address pool);

    /// @notice Updates the owner of the factory
    /// @dev Must be called by the current owner
    /// @param _owner The new owner of the factory
    function setOwner(address _owner) external;

    /// @notice Enables a fee amount with the given tickSpacing
    /// @dev Fee amounts may never be removed once enabled
    /// @param fee The fee amount to enable, denominated in hundredths of a bip (i.e. 1e-6)
    /// @param tickSpacing The spacing between ticks to be enforced for all pools created with the given fee amount
    function enableFeeAmount(uint24 fee, int24 tickSpacing) external;
}

/// @title Pool state that never changes
/// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
interface IUniswapV3PoolImmutables {
    /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
    /// @return The contract address
    function factory() external view returns (address);

    /// @notice The first of the two tokens of the pool, sorted by address
    /// @return The token contract address
    function token0() external view returns (address);

    /// @notice The second of the two tokens of the pool, sorted by address
    /// @return The token contract address
    function token1() external view returns (address);

    /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
    /// @return The fee
    function fee() external view returns (uint24);

    /// @notice The pool tick spacing
    /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
    /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
    /// This value is an int24 to avoid casting even though it is always positive.
    /// @return The tick spacing
    function tickSpacing() external view returns (int24);

    /// @notice The maximum amount of position liquidity that can use any tick in the range
    /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
    /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
    /// @return The max amount of liquidity per tick
    function maxLiquidityPerTick() external view returns (uint128);
}

/// @title Pool state that can change
/// @notice These methods compose the pool's state, and can change with any frequency including multiple times
/// per transaction
interface IUniswapV3PoolState {
    /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
    /// when accessed externally.
    /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
    /// @return tick The current tick of the pool, i.e. according to the last tick transition that was run.
    /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
    /// boundary.
    /// @return observationIndex The index of the last oracle observation that was written,
    /// @return observationCardinality The current maximum number of observations stored in the pool,
    /// @return observationCardinalityNext The next maximum number of observations, to be updated when the observation.
    /// @return feeProtocol The protocol fee for both tokens of the pool.
    /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
    /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
    /// unlocked Whether the pool is currently locked to reentrancy
    function slot0()
        external
        view
        returns (
            uint160 sqrtPriceX96,
            int24 tick,
            uint16 observationIndex,
            uint16 observationCardinality,
            uint16 observationCardinalityNext,
            uint8 feeProtocol,
            bool unlocked
        );

    /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
    /// @dev This value can overflow the uint256
    function feeGrowthGlobal0X128() external view returns (uint256);

    /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
    /// @dev This value can overflow the uint256
    function feeGrowthGlobal1X128() external view returns (uint256);

    /// @notice The amounts of token0 and token1 that are owed to the protocol
    /// @dev Protocol fees will never exceed uint128 max in either token
    function protocolFees() external view returns (uint128 token0, uint128 token1);

    /// @notice The currently in range liquidity available to the pool
    /// @dev This value has no relationship to the total liquidity across all ticks
    /// @return The liquidity at the current price of the pool
    function liquidity() external view returns (uint128);

    /// @notice Look up information about a specific tick in the pool
    /// @param tick The tick to look up
    /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
    /// tick upper
    /// @return liquidityNet how much liquidity changes when the pool price crosses the tick,
    /// @return feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
    /// @return feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
    /// @return tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
    /// @return secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
    /// @return secondsOutside the seconds spent on the other side of the tick from the current tick,
    /// @return initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
    /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
    /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
    /// a specific position.
    function ticks(int24 tick)
        external
        view
        returns (
            uint128 liquidityGross,
            int128 liquidityNet,
            uint256 feeGrowthOutside0X128,
            uint256 feeGrowthOutside1X128,
            int56 tickCumulativeOutside,
            uint160 secondsPerLiquidityOutsideX128,
            uint32 secondsOutside,
            bool initialized
        );

    /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
    function tickBitmap(int16 wordPosition) external view returns (uint256);

    /// @notice Returns the information about a position by the position's key
    /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
    /// @return liquidity The amount of liquidity in the position,
    /// @return feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
    /// @return feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
    /// @return tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
    /// @return tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
    function positions(bytes32 key)
        external
        view
        returns (
            uint128 liquidity,
            uint256 feeGrowthInside0LastX128,
            uint256 feeGrowthInside1LastX128,
            uint128 tokensOwed0,
            uint128 tokensOwed1
        );

    /// @notice Returns data about a specific observation index
    /// @param index The element of the observations array to fetch
    /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
    /// ago, rather than at a specific index in the array.
    /// @return blockTimestamp The timestamp of the observation,
    /// @return tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
    /// @return secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
    /// @return initialized whether the observation has been initialized and the values are safe to use
    function observations(uint256 index)
        external
        view
        returns (
            uint32 blockTimestamp,
            int56 tickCumulative,
            uint160 secondsPerLiquidityCumulativeX128,
            bool initialized
        );
}

/// @title Pool state that is not stored
/// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
/// blockchain. The functions here may have variable gas costs.
interface IUniswapV3PoolDerivedState {
    /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
    /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
    /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
    /// you must call it with secondsAgos = [3600, 0].
    /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
    /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
    /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
    /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
    /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
    /// timestamp
    function observe(uint32[] calldata secondsAgos)
        external
        view
        returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);

    /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
    /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
    /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
    /// snapshot is taken and the second snapshot is taken.
    /// @param tickLower The lower tick of the range
    /// @param tickUpper The upper tick of the range
    /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
    /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
    /// @return secondsInside The snapshot of seconds per liquidity for the range
    function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
        external
        view
        returns (
            int56 tickCumulativeInside,
            uint160 secondsPerLiquidityInsideX128,
            uint32 secondsInside
        );
}

/// @title Permissionless pool actions
/// @notice Contains pool methods that can be called by anyone
interface IUniswapV3PoolActions {
    /// @notice Sets the initial price for the pool
    /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
    /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
    function initialize(uint160 sqrtPriceX96) external;

    /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
    /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
    /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
    /// on tickLower, tickUpper, the amount of liquidity, and the current price.
    /// @param recipient The address for which the liquidity will be created
    /// @param tickLower The lower tick of the position in which to add liquidity
    /// @param tickUpper The upper tick of the position in which to add liquidity
    /// @param amount The amount of liquidity to mint
    /// @param data Any data that should be passed through to the callback
    /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
    /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
    function mint(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        bytes calldata data
    ) external returns (uint256 amount0, uint256 amount1);

    /// @notice Collects tokens owed to a position
    /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
    /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
    /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
    /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
    /// @param recipient The address which should receive the fees collected
    /// @param tickLower The lower tick of the position for which to collect fees
    /// @param tickUpper The upper tick of the position for which to collect fees
    /// @param amount0Requested How much token0 should be withdrawn from the fees owed
    /// @param amount1Requested How much token1 should be withdrawn from the fees owed
    /// @return amount0 The amount of fees collected in token0
    /// @return amount1 The amount of fees collected in token1
    function collect(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount0Requested,
        uint128 amount1Requested
    ) external returns (uint128 amount0, uint128 amount1);

    /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
    /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
    /// @dev Fees must be collected separately via a call to #collect
    /// @param tickLower The lower tick of the position for which to burn liquidity
    /// @param tickUpper The upper tick of the position for which to burn liquidity
    /// @param amount How much liquidity to burn
    /// @return amount0 The amount of token0 sent to the recipient
    /// @return amount1 The amount of token1 sent to the recipient
    function burn(
        int24 tickLower,
        int24 tickUpper,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1);

    /// @notice Swap token0 for token1, or token1 for token0
    /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
    /// @param recipient The address to receive the output of the swap
    /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
    /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
    /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
    /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
    /// @param data Any data to be passed through to the callback
    /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
    /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
    ) external returns (int256 amount0, int256 amount1);

    /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
    /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
    /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
    /// with 0 amount{0,1} and sending the donation amount(s) from the callback
    /// @param recipient The address which will receive the token0 and token1 amounts
    /// @param amount0 The amount of token0 to send
    /// @param amount1 The amount of token1 to send
    /// @param data Any data to be passed through to the callback
    function flash(
        address recipient,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;

    /// @notice Increase the maximum number of price and liquidity observations that this pool will store
    /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
    /// the input observationCardinalityNext.
    /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
    function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
}

/// @title Permissioned pool actions
/// @notice Contains pool methods that may only be called by the factory owner
interface IUniswapV3PoolOwnerActions {
    /// @notice Set the denominator of the protocol's % share of the fees
    /// @param feeProtocol0 new protocol fee for token0 of the pool
    /// @param feeProtocol1 new protocol fee for token1 of the pool
    function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;

    /// @notice Collect the protocol fee accrued to the pool
    /// @param recipient The address to which collected protocol fees should be sent
    /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
    /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
    /// @return amount0 The protocol fee collected in token0
    /// @return amount1 The protocol fee collected in token1
    function collectProtocol(
        address recipient,
        uint128 amount0Requested,
        uint128 amount1Requested
    ) external returns (uint128 amount0, uint128 amount1);
}

/// @title Events emitted by a pool
/// @notice Contains all events emitted by the pool
interface IUniswapV3PoolEvents {
    /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
    /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
    /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
    /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
    event Initialize(uint160 sqrtPriceX96, int24 tick);

    /// @notice Emitted when liquidity is minted for a given position
    /// @param sender The address that minted the liquidity
    /// @param owner The owner of the position and recipient of any minted liquidity
    /// @param tickLower The lower tick of the position
    /// @param tickUpper The upper tick of the position
    /// @param amount The amount of liquidity minted to the position range
    /// @param amount0 How much token0 was required for the minted liquidity
    /// @param amount1 How much token1 was required for the minted liquidity
    event Mint(
        address sender,
        address indexed owner,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice Emitted when fees are collected by the owner of a position
    /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
    /// @param owner The owner of the position for which fees are collected
    /// @param tickLower The lower tick of the position
    /// @param tickUpper The upper tick of the position
    /// @param amount0 The amount of token0 fees collected
    /// @param amount1 The amount of token1 fees collected
    event Collect(
        address indexed owner,
        address recipient,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount0,
        uint128 amount1
    );

    /// @notice Emitted when a position's liquidity is removed
    /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
    /// @param owner The owner of the position for which liquidity is removed
    /// @param tickLower The lower tick of the position
    /// @param tickUpper The upper tick of the position
    /// @param amount The amount of liquidity to remove
    /// @param amount0 The amount of token0 withdrawn
    /// @param amount1 The amount of token1 withdrawn
    event Burn(
        address indexed owner,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice Emitted by the pool for any swaps between token0 and token1
    /// @param sender The address that initiated the swap call, and that received the callback
    /// @param recipient The address that received the output of the swap
    /// @param amount0 The delta of the token0 balance of the pool
    /// @param amount1 The delta of the token1 balance of the pool
    /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
    /// @param liquidity The liquidity of the pool after the swap
    /// @param tick The log base 1.0001 of price of the pool after the swap
    event Swap(
        address indexed sender,
        address indexed recipient,
        int256 amount0,
        int256 amount1,
        uint160 sqrtPriceX96,
        uint128 liquidity,
        int24 tick
    );

    /// @notice Emitted by the pool for any flashes of token0/token1
    /// @param sender The address that initiated the swap call, and that received the callback
    /// @param recipient The address that received the tokens from flash
    /// @param amount0 The amount of token0 that was flashed
    /// @param amount1 The amount of token1 that was flashed
    /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
    /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
    event Flash(
        address indexed sender,
        address indexed recipient,
        uint256 amount0,
        uint256 amount1,
        uint256 paid0,
        uint256 paid1
    );

    /// @notice Emitted by the pool for increases to the number of observations that can be stored
    /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
    /// just before a mint/swap/burn.
    /// @param observationCardinalityNextOld The previous value of the next observation cardinality
    /// @param observationCardinalityNextNew The updated value of the next observation cardinality
    event IncreaseObservationCardinalityNext(
        uint16 observationCardinalityNextOld,
        uint16 observationCardinalityNextNew
    );

    /// @notice Emitted when the protocol fee is changed by the pool
    /// @param feeProtocol0Old The previous value of the token0 protocol fee
    /// @param feeProtocol1Old The previous value of the token1 protocol fee
    /// @param feeProtocol0New The updated value of the token0 protocol fee
    /// @param feeProtocol1New The updated value of the token1 protocol fee
    event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);

    /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
    /// @param sender The address that collects the protocol fees
    /// @param recipient The address that receives the collected protocol fees
    /// @param amount0 The amount of token0 protocol fees that is withdrawn
    /// @param amount0 The amount of token1 protocol fees that is withdrawn
    event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
}

/// @title The interface for a Uniswap V3 Pool
/// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
/// to the ERC20 specification
/// @dev The pool interface is broken up into many smaller pieces
interface IUniswapV3Pool is
    IUniswapV3PoolImmutables,
    IUniswapV3PoolState,
    IUniswapV3PoolDerivedState,
    IUniswapV3PoolActions,
    IUniswapV3PoolOwnerActions,
    IUniswapV3PoolEvents
{

}

/// @title Callback for IUniswapV3PoolActions#swap
/// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
interface IUniswapV3SwapCallback {
    /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
    /// @dev In the implementation you must pay the pool tokens owed for the swap.
    /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
    /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
    /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
    /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
    /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}

/// @title Router token swapping functionality
/// @notice Functions for swapping tokens via Uniswap V3
interface ISwapRouter is IUniswapV3SwapCallback {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut);

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn);
}

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IWETH {
    function withdraw(uint256 amount) external;
}

interface IPairV2 {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}

interface IPairV3 {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function swap(address recipient, bool zeroForOne, int256 amountSpecified, uint160 sqrtPriceLimitX96, bytes calldata data) external;
}

/**
* @dev Struct containing variables needed for a swap
*
* @param input The input token address
* @param output The output token address
* @param token0 The token0 address for swaps
* @param amountInput The input token amount
* @param amountOutput The output token amount
*/
struct SwapVariables {
    address input;
    address output;
    address token0;
    uint amountInput;
    uint amountOutput;
}

/**
 * @dev Contract for the Decentralized Exchange Network
 */
contract DecentralizedExchangeNetwork is Ownable, ReentrancyGuard {
    uint8 public systemFeeNumerator = 15; // Numerator for the system fee percentage
    uint8 public ownerFeeNumerator = 20; // Numerator for the owner fee percentage
    uint8 public maxTotalFeeNumerator = 250; // Maximum total fee percentage numerator
    uint16 public feeDenominator = 10000; // Fee denominator for percentage calculation
    uint24 public feeTierV3 = 3000; // Fee tier for Uniswap V3 swaps
    uint64 public swapTokenForETHCount = 0; // Counter for token-to-ETH swaps
    uint64 public swapETHForTokenCount = 0; // Counter for ETH-to-token swaps
    uint64 public swapTokenForTokenCount = 0; // Counter for token-to-token swaps
    uint256 public systemFeesCollected = 0; // Total system fees collected
    uint256 public ownerFeesCollected = 0; // Total owner fees collected
    address public systemFeeReceiver; // Address to receive system fees, 0x0aaA18c723B3e57df3988c4612d4CC7fAdD42a34
    address public ownerFeeReceiver; // Address to receive owner fees, 0x091dD81C8B9347b30f1A4d5a88F92d6F2A42b059

    

    // Wrapped Native Coin
    // 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 (Wrapped ETH)
    // 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c (Wrapped BSC)
    // 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270 (Wrapped MATIC)
    // 0xB31f66AA3C1e785363F0875A1B74E27b85FD66c7 (Wrapped AVAX)
    // 0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83 (Wrapped FTM)
    // 0xcF664087a5bB0237a0BAd6742852ec6c8d69A27a (Wrapped ONE)
    // 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1 (Wrapped Arbitrum)
    address public WETH;

    /**
    * @dev Emitted when the owner fee numerator is changed
    *
    * @param oldFeeNumerator The old owner fee numerator
    * @param newFeeNumerator The new owner fee numerator
    */
    event OwnerFeeNumeratorChanged(
        uint oldFeeNumerator,
        uint newFeeNumerator
    );

    /**
    * @dev Emitted when the owner fee receiver address is changed
    *
    * @param oldOwnerFeeReceiver The old owner fee receiver address
    * @param newOwnerFeeReceiver The new owner fee receiver address
    */
    event OwnerFeeReceiverChanged(
        address indexed oldOwnerFeeReceiver,
        address indexed newOwnerFeeReceiver
    );

    /**
    * @dev Constructor for the contract
    *
    * @param WETH_ Address of the WETH contract
    * @param systemFeeReceiver_ Address of the system fee receiver
    * @param ownerFeeReceiver_ Address of the owner fee receiver
    */
    constructor( // test params: 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c, 0x0aaA18c723B3e57df3988c4612d4CC7fAdD42a34, 0x091dD81C8B9347b30f1A4d5a88F92d6F2A42b059
        address WETH_,
        address systemFeeReceiver_,
        address ownerFeeReceiver_
    ) {
        // Check for valid inputs
        require(WETH_ != address(0), "Zero Address for WETH");
        require(systemFeeReceiver_ != address(0), "Zero Address for systemFeeReceiver");
        require(ownerFeeReceiver_ != address(0), "Zero Address for ownerFeeReceiver");

        // Set the values for the WETH contract, system fee receiver, and owner fee receiver
        WETH = WETH_;
        systemFeeReceiver = systemFeeReceiver_;
        ownerFeeReceiver = ownerFeeReceiver_;
    }

    /**
    * @dev Sets the owner fee numerator
    *
    * @param newOwnerFeeNumerator The new owner fee numerator to set
    */
    function setOwnerFeeNumerator(uint8 newOwnerFeeNumerator) external onlyOwner {
        require(newOwnerFeeNumerator <= (maxTotalFeeNumerator - systemFeeNumerator), "Fee Too High");

        // Emit an event to notify of the change
        emit OwnerFeeNumeratorChanged(ownerFeeNumerator, newOwnerFeeNumerator);

        // Set the new owner fee numerator
        ownerFeeNumerator = newOwnerFeeNumerator;
    }

    /**
    * @dev Sets the owner fee receiver address
    *
    * @param newOwnerFeeReceiver The new owner fee receiver address to set
    */
    function setOwnerFeeReceiver(address newOwnerFeeReceiver) external onlyOwner {
        require(newOwnerFeeReceiver != address(0), "Zero Address");

        // Emit an event to notify of the change
        emit OwnerFeeReceiverChanged(ownerFeeReceiver, newOwnerFeeReceiver);

        // Set the new owner fee receiver address
        ownerFeeReceiver = newOwnerFeeReceiver;
    }

    /**
    * @dev Swaps a specified amount of ETH for ERC20 tokens
    *
    * @param DEX Address of the DEX contract
    * @param token Address of the ERC20 token to swap for
    * @param amountOutMin Minimum amount of `token` that must be received for the swap to be considered successful
    */
    function swapETHForToken(
        address DEX,
        address token,
        uint amountOutMin
    ) external payable nonReentrant {
        // Check for valid inputs
        require(DEX != address(0), "Zero Address for DEX");
        require(token != address(0), "Zero Address for token");
        require(amountOutMin > 0, "Zero Value for amountOutMin");
        require(msg.value > 0, "Zero Value for msg.value");

        // Handle the fees
        (uint systemFee, uint ownerFee) = getFees(msg.value);
        _sendETH(systemFeeReceiver, systemFee);
        _sendETH(ownerFeeReceiver, ownerFee);
        uint amountInLessFees = msg.value - (systemFee + ownerFee);

        // Swap with the right DEX version
        uint8 version = _getUniswapVersion(DEX);
        if (version == 3) {
            swapETHForTokenV3(DEX, token, amountInLessFees, amountOutMin);
        } else if (version == 2) {
            swapETHForTokenV2(DEX, token, amountInLessFees, amountOutMin);
        } else {
            revert("Unsupported DEX");
        }

        // Update state
        swapETHForTokenCount++;
        systemFeesCollected += systemFee;
        ownerFeesCollected += ownerFee;
    }

    /**
    * @dev Swaps a specified amount of ERC20 tokens for ETH
    *
    * @param DEX The address of the DEX to swap on
    * @param token The address of the ERC-20 token to swap
    * @param amountIn The amount of the token to swap
    * @param amountOutMin The minimum amount of ETH to receive from the swap
    */
    function swapTokenForETH(
        address DEX,
        address token,
        uint amountIn,
        uint amountOutMin
    ) external nonReentrant {
        // Check for valid inputs
        require(DEX != address(0), "Zero Address for DEX");
        require(token != address(0), "Zero Address for token");
        require(amountIn > 0, "Zero Value for amountIn");
        require(amountOutMin > 0, "Zero Value for amountOutMin");

        // Swap with the right DEX version
        uint8 version = _getUniswapVersion(DEX);
        if (version == 3) {
            swapTokenForETHV3(DEX, token, amountIn);
        } else if (version == 2) {
            swapTokenForETHV2(DEX, token, amountIn);
        } else {
            revert("Unsupported DEX");
        }

        // Check the amount of output tokens received from the swap
        uint amountOut = IERC20(WETH).balanceOf(address(this));
        require(amountOut >= amountOutMin, 'INSUFFICIENT_OUTPUT_AMOUNT');

        // Handle the fees and send the rest to the sender
        IWETH(WETH).withdraw(amountOut);
        (uint systemFee, uint ownerFee) = getFees(amountOut);
        _sendETH(systemFeeReceiver, systemFee);
        _sendETH(ownerFeeReceiver, ownerFee);
        _sendETH(msg.sender, amountOut - (systemFee + ownerFee));

        // Update state
        swapTokenForETHCount++;
        systemFeesCollected += systemFee;
        ownerFeesCollected += ownerFee;
    }

    /**
    * @dev Swaps a specified amount of ERC20 tokens for ERC20 tokens
    *
    * @param DEX The address of the Uniswap DEX contract
    * @param tokenIn The address of the input token
    * @param tokenOut The address of the output token
    * @param amountIn The amount of input tokens to swap
    * @param amountOutMin The minimum amount of output tokens to receive in the swap
    */
    function swapTokenForToken(address DEX, address tokenIn, address tokenOut, uint amountIn, uint amountOutMin) external nonReentrant {
        // Check for valid inputs
        require(DEX != address(0), "Zero Address for DEX");
        require(tokenIn != address(0), "Zero Address for tokenIn");
        require(tokenOut != address(0), "Zero Address for tokenOut");
        require(amountIn > 0, "Zero Value for amountIn");
        require(amountOutMin > 0, "Zero Value for amountOutMin");

        // Calculate fees
        (uint systemFee, uint ownerFee) = getFees(amountIn);
        _transferIn(msg.sender, systemFeeReceiver, tokenIn, systemFee);
        _transferIn(msg.sender, ownerFeeReceiver, tokenIn, ownerFee);
        uint amountInLessFees = amountIn - (systemFee + ownerFee);

        // Swap with the right DEX version
        uint amountOut = 0;
        uint8 version = _getUniswapVersion(DEX);
        if (version == 3) {
            amountOut = swapTokenForTokenV3(DEX, tokenIn, tokenOut, amountInLessFees);
        } else if (version == 2) {
            amountOut = swapTokenForTokenV2(DEX, tokenIn, tokenOut, amountInLessFees);
        } else {
            revert("Unsupported DEX");
        }

        // Check the amount of output tokens received from the swap
        require(amountOut >= amountOutMin, "INSUFFICIENT_OUTPUT_AMOUNT");

        // Update state
        swapTokenForTokenCount++;
        systemFeesCollected += systemFee;
        ownerFeesCollected += ownerFee;
    }

    /** Internal Functions **/

    /**
    * @dev Swaps a given amount of ETH for a specified token using a Uniswap v3 DEX
    *
    * @param token The address of the token to receive in the swap
    * @param DEX The address of the Uniswap v3 DEX to use for the swap
    * @param amountIn The amount of ETH to swap
    * @param amountOutMin The minimum amount of the output token to receive in the swap
    */
    function swapETHForTokenV3(address DEX, address token, uint amountIn, uint amountOutMin) private {
        ISwapRouter router = ISwapRouter(DEX);

        // Define swap parameters as an `ExactInputSingleParams` struct
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH, // Input token is WETH
            tokenOut: token, // Output token is the specified token
            fee: feeTierV3, // Fee tier used for the swap
            recipient: msg.sender, // Recipient of the output tokens
            deadline: block.timestamp + 300, // Deadline for the swap transaction
            amountIn: amountIn, // Amount of input token to swap
            amountOutMinimum: amountOutMin, // Minimum amount of output token to receive
            sqrtPriceLimitX96: 0 // No price limit
        });

        // Execute the swap using the `exactInputSingle` function of the Uniswap v3 router contract
        router.exactInputSingle{value: amountIn}(params);
    }

    /**
    * @dev Swaps a given amount of ETH for a specified token using a Uniswap v2 DEX
    *
    * @param DEX The address of the Uniswap v2 DEX to use for the swap
    * @param token The address of the token to receive in the swap
    * @param amountIn The amount of ETH to swap
    * @param amountOutMin The minimum amount of the output token to receive in the swap
    */
    function swapETHForTokenV2(
        address DEX, 
        address token, 
        uint amountIn, 
        uint amountOutMin
    ) private {
        // Instantiate the Uniswap v2 router
        IUniswapV2Router02 router = IUniswapV2Router02(DEX);

        // Define the swap path as WETH to the specified token
        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = token;

        // Execute the swap using the router's swapExactETHForTokensSupportingFeeOnTransferTokens function
        router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: amountIn
        }(
            amountOutMin, // minimum amount of output token to receive
            path, // swap path
            msg.sender, // recipient address
            block.timestamp + 300 // deadline for the swap transaction
        );

        // Clear the memory used for the swap path
        delete path;
    }

    /**
    * @dev Swaps a given amount of a token for ETH on a Uniswap v3 decentralized exchange
    *
    * @param DEX The address of the Uniswap v3 pool contract
    * @param token The address of the token to be swapped
    * @param amountIn The amount of tokens to be swapped
    */
    function swapTokenForETHV3(
        address DEX, 
        address token, 
        uint amountIn
    ) private {
        // Instantiate the Uniswap v3 pool contract
        IUniswapV3Pool pool = IUniswapV3Pool(DEX);

        // Get the addresses of the two tokens in the pool
        address token0 = pool.token0();
        address token1 = pool.token1();

        // Determine the direction of the swap: true for token0 to token1, false for token1 to token0
        bool zeroForOne;
        if (token == token0) {
            zeroForOne = true;
        } else if (token == token1) {
            zeroForOne = false;
        } else {
            revert("Invalid token input for pool");
        }

        // Get the current state of the pool
        (uint160 sqrtPriceX96,,,,,,) = pool.slot0();

        // Transfer the tokens to the pool contract
        _transferIn(msg.sender, address(pool), token, amountIn);

        // Execute the swap
        pool.swap(
            address(this),  // recipient of the ETH
            zeroForOne,  // directionality of the swap
            int256(amountIn),  // amount of tokens to swap
            sqrtPriceX96,  // limit the price of the swap
            new bytes(0)  // optional data to include with the swap
        );
    }

    /**
    * @dev Swaps an ERC20 token for ETH using Uniswap V2
    *
    * @param DEX The address of the Uniswap V2 router contract
    * @param token The address of the ERC20 token to swap
    * @param amountIn The amount of the ERC20 token to swap
    */
    function swapTokenForETHV2(address DEX, address token, uint amountIn) private {
        // Get the Uniswap V2 pool for the given token and WETH
        IPairV2 pool = IPairV2(IUniswapV2Factory(IUniswapV2Router02(DEX).factory()).getPair(token, WETH));

        // Transfer the tokens to the pool contract
        _transferIn(msg.sender, address(pool), token, amountIn);

        // Define a memory struct for swap-related variables
        SwapVariables memory swapVars;

        // The input token is the token being swapped, the output token is WETH
        (swapVars.input, swapVars.output) = (token, WETH);

        // Sort the input and output tokens for consistency
        (swapVars.token0,) = sortTokens(swapVars.input, swapVars.output);

        // Get the current reserves of the input and output tokens in the pool
        (uint reserve0, uint reserve1,) = pool.getReserves();

        // Determine which reserve value corresponds to the input token and which corresponds to the output token
        (uint reserveInput, uint reserveOutput) = swapVars.input == swapVars.token0 ? (reserve0, reserve1) : (reserve1, reserve0);

        // Calculate the amount of input tokens used in the swap
        swapVars.amountInput = IERC20(swapVars.input).balanceOf(address(pool)) - reserveInput;

        // Calculate the amount of output tokens to receive from the swap
        swapVars.amountOutput = getAmountOut(swapVars.amountInput, reserveInput, reserveOutput);

        // Set amount0Out and amount1Out for the swap function
        uint amount0Out;
        uint amount1Out;
        if (swapVars.input == swapVars.token0) {
            amount0Out = 0;
            amount1Out = swapVars.amountOutput;
        } else {
            amount0Out = swapVars.amountOutput;
            amount1Out = 0;
        }

        // Make the swap
        pool.swap(
            amount0Out, 
            amount1Out, 
            address(this), 
            new bytes(0)
        );

        // Delete the memory struct to free up memory
        delete swapVars;
    }

    /**
    * @dev Swaps a given amount of an input token for an output token using a Uniswap v3 DEX
    *
    * @param DEX The address of the Uniswap v3 DEX to use for the swap
    * @param tokenIn The address of the input token
    * @param tokenOut The address of the output token
    * @param amountIn The amount of the input token to swap
    * @return amountOut The amount of the output token received from the swap
    */
    function swapTokenForTokenV3(
        address DEX,
        address tokenIn,
        address tokenOut,
        uint amountIn
    ) private returns (uint amountOut) {
        // Get the Uniswap v3 pool for the input and output tokens
        IUniswapV3Pool pool = IUniswapV3Pool(DEX);
        address token0 = pool.token0();
        address token1 = pool.token1();

        // Determine the direction of the swap (token0 to token1 or token1 to token0)
        bool zeroForOne;
        if (tokenIn == token0) {
            zeroForOne = true;
        } else if (tokenIn == token1) {
            zeroForOne = false;
        } else {
            revert("Invalid token input for pool");
        }

        // Get the current state of the pool
        (uint160 sqrtPriceX96,,,,,,) = pool.slot0();
        // uint32 secondsIn = 10;
        // uint256 price = IUniswapV3PriceOracle(uniswapV3PriceOracle).estimateAmountOut(token, uint128(amountIn), secondsIn);

        // Transfer the input tokens into the liquidity pool
        _transferIn(msg.sender, address(pool), tokenIn, amountIn);

        // Make the swap
        uint before = IERC20(tokenOut).balanceOf(msg.sender);
        pool.swap(
            address(this), // recipient
            zeroForOne, // directionality
            (zeroForOne) ? int256(amountIn) : int256(amountIn) * -1, // amountSpecified
            sqrtPriceX96, // sqrtPriceLimitX96
            new bytes(0)
        );

        // Return the amount of the output token received from the swap
        return IERC20(tokenOut).balanceOf(msg.sender) - before;
    }


    /**
    * @dev Swaps a given amount of an input token for an output token using a Uniswap v2 DEX
    *
    * @param DEX The address of the Uniswap v2 DEX to use for the swap
    * @param tokenIn The address of the input token
    * @param tokenOut The address of the output token
    * @param amountIn The amount of the input token to swap
    * @return amountOut The amount of the output token received from the swap
    */
    function swapTokenForTokenV2(
        address DEX, 
        address tokenIn, 
        address tokenOut, 
        uint amountIn
    ) private returns (uint amountOut) {
        // Get the Uniswap v2 pair for the input and output tokens
        IPairV2 pair = IPairV2(IUniswapV2Factory(IUniswapV2Router02(DEX).factory()).getPair(tokenIn, tokenOut));
        
        // Transfer the input tokens into the liquidity pool
        _transferIn(msg.sender, address(pair), tokenIn, amountIn);

        // Define a memory struct for swap-related variables
        SwapVariables memory swapVars;

        // The input token is the token being swapped, the output token is the token to receive from the swap
        (swapVars.input, swapVars.output) = (tokenIn, tokenOut);

        // Sort the input and output tokens for consistency
        (swapVars.token0,) = sortTokens(swapVars.input, swapVars.output);

        // Get the current reserves of the input and output tokens in the pair
        (uint reserve0, uint reserve1,) = pair.getReserves();

        // Determine which reserve value corresponds to the input token and which corresponds to the output token
        (uint reserveInput, uint reserveOutput) = swapVars.input == swapVars.token0 ? (reserve0, reserve1) : (reserve1, reserve0);

        // Calculate the amount of input tokens used in the swap
        swapVars.amountInput = IERC20(swapVars.input).balanceOf(address(pair)) - reserveInput;

        // Calculate the amount of output tokens to receive from the swap
        swapVars.amountOutput = getAmountOut(swapVars.amountInput, reserveInput, reserveOutput);

        // Set amount0Out and amount1Out for the swap function
        uint amount0Out;
        uint amount1Out;
        if (swapVars.input == swapVars.token0) {
            // The input token is token0, so the amount of token1 (output token) to receive is `amount1Out`
            amount0Out = 0;
            amount1Out = swapVars.amountOutput;
        } else {
            // The input token is token1, so the amount of token0 (output token) to receive is `amount0Out`
            amount0Out = swapVars.amountOutput;
            amount1Out = 0;
        }

        // Get the amount of the output token held by the user before the swap
        uint before = IERC20(tokenOut).balanceOf(msg.sender);

        // Make the swap.
        pair.swap(
            amount0Out, 
            amount1Out, 
            msg.sender, // The recipient of the output tokens
            new bytes(0) // No
        );

        // Delete the memory struct to free up memory
        delete swapVars;

        // Return the amount of the output token received from the swap
        return IERC20(tokenOut).balanceOf(msg.sender) - before;
    }


    /**
    * @dev Given an address for a DEX, determines its Uniswap version (if any)
    *
    * @param DEX The address of the DEX
    * @return The Uniswap version of the DEX (2, 3) or 0 if it's not a Uniswap DEX
    */
    function _getUniswapVersion(address DEX) internal view returns (uint8) {
        // Define the interface IDs for the Uniswap v2 and v3 routers.
        bytes4 uniswapV2InterfaceId = 0x38ed1739; // Interface ID for IUniswapV2Router01 (swapExactTokensForTokens)
        bytes4 uniswapV3InterfaceId = 0x58a21736; // Interface ID for IUniswapV3Router (exactInput)

        // Create an IERC165 instance for the DEX
        IERC165 dexAsERC165 = IERC165(DEX);

        // Check if the DEX supports the Uniswap v2 interface
        if (dexAsERC165.supportsInterface(uniswapV2InterfaceId)) {
            return 2;
        }
        // Check if the DEX supports the Uniswap v3 interface
        else if (dexAsERC165.supportsInterface(uniswapV3InterfaceId)) {
            return 3;
        }
        // If the DEX doesn't support either interface, return 0
        else {
            return 0;
        }
    }

    /**
    * @dev Given an input amount, calculates the output amount based on the reserves of two ERC20 tokens in a liquidity pool
    *
    * @param amountIn The input amount
    * @param reserveIn The reserve amount of the input token
    * @param reserveOut The reserve amount of the output token
    * @return amountOut The output amount, calculated based on the input amount and the reserve amounts of the tokens
    */
    function getAmountOut(
        uint amountIn, 
        uint reserveIn, 
        uint reserveOut
    ) internal view returns (uint amountOut) {
        // Ensure that the input amount is greater than zero
        require(amountIn > 0, 'PancakeLibrary: INSUFFICIENT_INPUT_AMOUNT');
        
        // Ensure that both reserves are greater than zero
        require(reserveIn > 0 && reserveOut > 0, 'PancakeLibrary: INSUFFICIENT_LIQUIDITY');
        
        // Calculate the input amount with the fee deducted
        uint amountInWithFee = amountIn * (feeDenominator - (ownerFeeNumerator + systemFeeNumerator));
        
        // Calculate the numerator of the output amount equation
        uint numerator = amountInWithFee * (reserveOut);
        
        // Calculate the denominator of the output amount equation
        uint denominator = (reserveIn * feeDenominator) - amountInWithFee;
        
        // Calculate the output amount based on the input amount and the reserve amounts of the tokens
        return numerator / denominator;
    }

    /**
    * @dev Given two ERC20 tokens, returns them in the order that they should be sorted in for use in other functions
    *
    * @param tokenA The first token address
    * @param tokenB The second token address
    * @return token0 The address of the first token, sorted alphabetically
    * @return token1 The address of the second token, sorted alphabetically
    */
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        // Ensure that the two token addresses are not identical
        require(tokenA != tokenB, 'IDENTICAL_ADDRESSES');
        
        // Sort the two token addresses alphabetically and return them
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        
        // Ensure that the first token address is not the zero address
        require(token0 != address(0), 'PancakeLibrary: ZERO_ADDRESS');
    }

    /**
    * @dev Calculates the fees to be deducted from a given amount, based on the system fee and owner fee percentages
    *
    * @param amount The amount to calculate fees for
    * @return systemFee_ The system fee, calculated as a fraction of the amount
    * @return ownerFee_ The owner fee, calculated as a fraction of the amount
    */
    function getFees(uint amount) public view returns (uint systemFee_, uint ownerFee_) {
        // Calculate the system fee as a fraction of the amount, based on the systemFeeNumerator and feeDenominator
        uint systemFee = (amount * systemFeeNumerator) / feeDenominator;
        
        // Calculate the owner fee as a fraction of the amount, based on the ownerFeeNumerator and feeDenominator
        uint ownerFee = (amount * ownerFeeNumerator) / feeDenominator;
        
        // Return the system fee and owner fee as a tuple
        return (systemFee, ownerFee);
    }

    /**
    * @dev Sends a specified amount of Ether (ETH) from the contract to the specified receiver's address
    *
    * @param receiver_ The address of the receiver of the ETH
    * @param amount The amount of ETH to be sent
    */
    function _sendETH(address receiver_, uint amount) internal {
        // Check that the contract has enough ETH balance to send
        require(address(this).balance >= amount, 'Insufficient ETH balance');
        
        // Transfer the specified amount of ETH to the receiver's address
        payable(receiver_).transfer(amount);
    }

    /**
    * @dev Transfers a specified amount of a given ERC20 token from one user to another user, and returns the amount of tokens that were actually received
    *
    * @param fromUser The address of the user who is sending the tokens
    * @param toUser The address of the user who is receiving the tokens
    * @param token The address of the ERC20 token being transferred
    * @param amount The amount of tokens being transferred
    * @return The amount of tokens that the recipient actually received
    */
    function _transferIn(address fromUser, address toUser, address token, uint amount) internal returns (uint) {
        // Get the recipient's balance before the transfer
        uint before = IERC20(token).balanceOf(toUser);
        
        // Attempt to transfer the specified amount of tokens from the sender to the recipient
        bool s = IERC20(token).transferFrom(fromUser, toUser, amount);
        
        // Calculate the amount of tokens that the recipient actually received
        uint received = IERC20(token).balanceOf(toUser) - before;
        
        // Ensure that the transfer was successful and that the recipient received the expected amount of tokens
        require(s && (received > 0) && (received <= amount), "Error On Transfer From");
        
        // Return the amount of tokens that the recipient actually received
        return received;
    }
}