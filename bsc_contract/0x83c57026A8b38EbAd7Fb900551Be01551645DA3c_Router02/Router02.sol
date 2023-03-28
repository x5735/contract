/**
 *Submitted for verification at BscScan.com on 2023-03-26
*/

pragma solidity =0.6.6;
pragma experimental ABIEncoderV2;


interface IRouter02 {
    function factory() external pure returns (address);

    function bDeployer() external pure returns (address);

    function cDeployer() external pure returns (address);

    function WETH() external pure returns (address);

    function mint(
        address poolToken,
        uint256 amount,
        address to,
        uint256 deadline
    ) external returns (uint256 tokens);

    function mintETH(
        address poolToken,
        address to,
        uint256 deadline
    ) external payable returns (uint256 tokens);

    function mintCollateral(
        address poolToken,
        uint256 amount,
        address to,
        uint256 deadline,
        bytes calldata permitData
    ) external returns (uint256 tokens);

    function redeem(
        address poolToken,
        uint256 tokens,
        address to,
        uint256 deadline,
        bytes calldata permitData
    ) external returns (uint256 amount);

    function redeemETH(
        address poolToken,
        uint256 tokens,
        address to,
        uint256 deadline,
        bytes calldata permitData
    ) external returns (uint256 amountETH);

    function borrow(
        address borrowable,
        uint256 amount,
        address to,
        uint256 deadline,
        bytes calldata permitData
    ) external;

    function borrowETH(
        address borrowable,
        uint256 amountETH,
        address to,
        uint256 deadline,
        bytes calldata permitData
    ) external;

    function repay(
        address borrowable,
        uint256 amountMax,
        address borrower,
        uint256 deadline
    ) external returns (uint256 amount);

    function repayETH(
        address borrowable,
        address borrower,
        uint256 deadline
    ) external payable returns (uint256 amountETH);

    function liquidate(
        address borrowable,
        uint256 amountMax,
        address borrower,
        address to,
        uint256 deadline
    ) external returns (uint256 amount, uint256 seizeTokens);

    function liquidateETH(
        address borrowable,
        address borrower,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountETH, uint256 seizeTokens);

    function leverage(
        address uniswapV2Pair,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bytes calldata permitDataA,
        bytes calldata permitDataB
    ) external;

    function deleverage(
        address uniswapV2Pair,
        uint256 redeemTokens,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256 deadline,
        bytes calldata permitData
    ) external;

    function isVaultToken(address underlying) external view returns (bool);

    function getUniswapV2Pair(address underlying)
        external
        view
        returns (address);

    function getBorrowable(address uniswapV2Pair, uint8 index)
        external
        view
        returns (address borrowable);

    function getCollateral(address uniswapV2Pair)
        external
        view
        returns (address collateral);

    function getLendingPool(address uniswapV2Pair)
        external
        view
        returns (
            address collateral,
            address borrowableA,
            address borrowableB
        );
}

interface IPoolToken {
    /*** Lif3 ERC20 ***/

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /*** Pool Token ***/

    event Mint(
        address indexed sender,
        address indexed minter,
        uint256 mintAmount,
        uint256 mintTokens
    );
    event Redeem(
        address indexed sender,
        address indexed redeemer,
        uint256 redeemAmount,
        uint256 redeemTokens
    );
    event Sync(uint256 totalBalance);

    function underlying() external view returns (address);

    function factory() external view returns (address);

    function totalBalance() external view returns (uint256);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function exchangeRate() external returns (uint256);

    function mint(address minter) external returns (uint256 mintTokens);

    function redeem(address redeemer) external returns (uint256 redeemAmount);

    function skim(address to) external;

    function sync() external;

    function _setFactory() external;
}

interface IBorrowable {
    /*** Lif3 ERC20 ***/

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /*** Pool Token ***/

    event Mint(
        address indexed sender,
        address indexed minter,
        uint256 mintAmount,
        uint256 mintTokens
    );
    event Redeem(
        address indexed sender,
        address indexed redeemer,
        uint256 redeemAmount,
        uint256 redeemTokens
    );
    event Sync(uint256 totalBalance);

    function underlying() external view returns (address);

    function factory() external view returns (address);

    function totalBalance() external view returns (uint256);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function exchangeRate() external returns (uint256);

    function mint(address minter) external returns (uint256 mintTokens);

    function redeem(address redeemer) external returns (uint256 redeemAmount);

    function skim(address to) external;

    function sync() external;

    function _setFactory() external;

    /*** Borrowable ***/

    event BorrowApproval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Borrow(
        address indexed sender,
        address indexed borrower,
        address indexed receiver,
        uint256 borrowAmount,
        uint256 repayAmount,
        uint256 accountBorrowsPrior,
        uint256 accountBorrows,
        uint256 totalBorrows
    );
    event Liquidate(
        address indexed sender,
        address indexed borrower,
        address indexed liquidator,
        uint256 seizeTokens,
        uint256 repayAmount,
        uint256 accountBorrowsPrior,
        uint256 accountBorrows,
        uint256 totalBorrows
    );

    function BORROW_FEE() external pure returns (uint256);

    function collateral() external view returns (address);

    function reserveFactor() external view returns (uint256);

    function exchangeRateLast() external view returns (uint256);

    function borrowIndex() external view returns (uint256);

    function totalBorrows() external view returns (uint256);

    function borrowAllowance(address owner, address spender)
        external
        view
        returns (uint256);

    function borrowBalance(address borrower) external view returns (uint256);

    function borrowTracker() external view returns (address);

    function BORROW_PERMIT_TYPEHASH() external pure returns (bytes32);

    function borrowApprove(address spender, uint256 value)
        external
        returns (bool);

    function borrowPermit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function borrow(
        address borrower,
        address receiver,
        uint256 borrowAmount,
        bytes calldata data
    ) external;

    function liquidate(address borrower, address liquidator)
        external
        returns (uint256 seizeTokens);

    function trackBorrow(address borrower) external;

    /*** Borrowable Interest Rate Model ***/

    event AccrueInterest(
        uint256 interestAccumulated,
        uint256 borrowIndex,
        uint256 totalBorrows
    );
    event CalculateKink(uint256 kinkRate);
    event CalculateBorrowRate(uint256 borrowRate);

    function KINK_BORROW_RATE_MAX() external pure returns (uint256);

    function KINK_BORROW_RATE_MIN() external pure returns (uint256);

    function KINK_MULTIPLIER() external pure returns (uint256);

    function borrowRate() external view returns (uint256);

    function kinkBorrowRate() external view returns (uint256);

    function kinkUtilizationRate() external view returns (uint256);

    function adjustSpeed() external view returns (uint256);

    function rateUpdateTimestamp() external view returns (uint32);

    function accrualTimestamp() external view returns (uint32);

    function accrueInterest() external;

    /*** Borrowable Setter ***/

    event NewReserveFactor(uint256 newReserveFactor);
    event NewKinkUtilizationRate(uint256 newKinkUtilizationRate);
    event NewAdjustSpeed(uint256 newAdjustSpeed);
    event NewBorrowTracker(address newBorrowTracker);

    function RESERVE_FACTOR_MAX() external pure returns (uint256);

    function KINK_UR_MIN() external pure returns (uint256);

    function KINK_UR_MAX() external pure returns (uint256);

    function ADJUST_SPEED_MIN() external pure returns (uint256);

    function ADJUST_SPEED_MAX() external pure returns (uint256);

    function _initialize(
        string calldata _name,
        string calldata _symbol,
        address _underlying,
        address _collateral
    ) external;

    function _setReserveFactor(uint256 newReserveFactor) external;

    function _setKinkUtilizationRate(uint256 newKinkUtilizationRate) external;

    function _setAdjustSpeed(uint256 newAdjustSpeed) external;

    function _setBorrowTracker(address newBorrowTracker) external;
}

interface ICollateral {
    /*** Lif3 ERC20 ***/

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /*** Pool Token ***/

    event Mint(
        address indexed sender,
        address indexed minter,
        uint256 mintAmount,
        uint256 mintTokens
    );
    event Redeem(
        address indexed sender,
        address indexed redeemer,
        uint256 redeemAmount,
        uint256 redeemTokens
    );
    event Sync(uint256 totalBalance);

    function underlying() external view returns (address);

    function factory() external view returns (address);

    function totalBalance() external view returns (uint256);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function exchangeRate() external returns (uint256);

    function mint(address minter) external returns (uint256 mintTokens);

    function redeem(address redeemer) external returns (uint256 redeemAmount);

    function skim(address to) external;

    function sync() external;

    function _setFactory() external;

    /*** Collateral ***/

    function borrowable0() external view returns (address);

    function borrowable1() external view returns (address);

    function lif3PriceOracle() external view returns (address);

    function safetyMarginSqrt() external view returns (uint256);

    function liquidationIncentive() external view returns (uint256);

    function getPrices() external returns (uint256 price0, uint256 price1);

    function tokensUnlocked(address from, uint256 value)
        external
        returns (bool);

    function accountLiquidityAmounts(
        address account,
        uint256 amount0,
        uint256 amount1
    ) external returns (uint256 liquidity, uint256 shortfall);

    function accountLiquidity(address account)
        external
        returns (uint256 liquidity, uint256 shortfall);

    function canBorrow(
        address account,
        address borrowable,
        uint256 accountBorrows
    ) external returns (bool);

    function seize(
        address liquidator,
        address borrower,
        uint256 repayAmount
    ) external returns (uint256 seizeTokens);

    function flashRedeem(
        address redeemer,
        uint256 redeemAmount,
        bytes calldata data
    ) external;

    /*** Collateral Setter ***/

    event NewSafetyMargin(uint256 newSafetyMarginSqrt);
    event NewLiquidationIncentive(uint256 newLiquidationIncentive);

    function SAFETY_MARGIN_SQRT_MIN() external pure returns (uint256);

    function SAFETY_MARGIN_SQRT_MAX() external pure returns (uint256);

    function LIQUIDATION_INCENTIVE_MIN() external pure returns (uint256);

    function LIQUIDATION_INCENTIVE_MAX() external pure returns (uint256);

    function _initialize(
        string calldata _name,
        string calldata _symbol,
        address _underlying,
        address _borrowable0,
        address _borrowable1
    ) external;

    function _setSafetyMarginSqrt(uint256 newSafetyMarginSqrt) external;

    function _setLiquidationIncentive(uint256 newLiquidationIncentive) external;
}

interface ILif3Callee {
    function lif3Borrow(
        address sender,
        address borrower,
        uint256 borrowAmount,
        bytes calldata data
    ) external;

    function lif3Redeem(
        address sender,
        uint256 redeemAmount,
        bytes calldata data
    ) external;
}

interface IERC20 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

interface IVaultToken {
    /*** Lif3 ERC20 ***/

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /*** Pool Token ***/

    event Mint(
        address indexed sender,
        address indexed minter,
        uint256 mintAmount,
        uint256 mintTokens
    );
    event Redeem(
        address indexed sender,
        address indexed redeemer,
        uint256 redeemAmount,
        uint256 redeemTokens
    );
    event Sync(uint256 totalBalance);

    function underlying() external view returns (address);

    function factory() external view returns (address);

    function totalBalance() external view returns (uint256);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function exchangeRate() external view returns (uint256);

    function mint(address minter) external returns (uint256 mintTokens);

    function redeem(address redeemer) external returns (uint256 redeemAmount);

    function skim(address to) external;

    function sync() external;

    function _setFactory() external;

    /*** VaultToken ***/

    event Reinvest(address indexed caller, uint256 reward, uint256 bounty);

    function isVaultToken() external pure returns (bool);

    function router() external view returns (IUniswapV2Router01);

    function masterChef() external view returns (IMasterChef);

    function rewardsToken() external view returns (address);

    function WETH() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function swapFeeFactor() external view returns (uint256);

    function pid() external view returns (uint256);

    function REINVEST_BOUNTY() external pure returns (uint256);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function _initialize(
        IUniswapV2Router01 _router,
        IMasterChef _masterChef,
        address _rewardsToken,
        uint256 _swapFeeFactor,
        uint256 _pid
    ) external;

    function reinvest() external;
}

interface IFactory {
    function canLiquidate(address) external view returns (bool);
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

// From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
// Subject to the MIT license.

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, errorMessage);

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot underflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction underflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot underflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, errorMessage);

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers.
     * Reverts on division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers.
     * Reverts with custom message on division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

pragma solidity =0.6.6;

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x095ea7b3, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper::safeApprove: approve failed"
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0xa9059cbb, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper::safeTransfer: transfer failed"
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x23b872dd, from, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper::transferFrom: transferFrom failed"
        );
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(
            success,
            "TransferHelper::safeTransferETH: ETH transfer failed"
        );
    }
}

contract IMasterChef {
    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken; // Address of LP token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. Reward tokens to distribute per block.
        uint256 lastRewardBlock; // Last block number that reward token distribution occurs.
        uint256 accRewardTokenPerShare; // Accumulated reward tokens per share, times 1e12. See below.
    }

    // Info of each user that stakes LP tokens.
    mapping(uint256 => PoolInfo) public poolInfo;
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;

    // Deposit LP tokens to MasterChef.
    function deposit(uint256 _pid, uint256 _amount) external {}

    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _pid, uint256 _amount) external {}
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

contract Router02 is IRouter02, ILif3Callee {
    using SafeMath for uint256;

    address public immutable override factory;
    address public immutable override bDeployer;
    address public immutable override cDeployer;
    address public immutable override WETH;

    modifier ensure(uint256 deadline) {
        require(deadline >= block.timestamp, "Lif3Router: EXPIRED");
        _;
    }

    modifier checkETH(address poolToken) {
        require(
            WETH == IPoolToken(poolToken).underlying(),
            "Lif3Router: NOT_WETH"
        );
        _;
    }

    constructor(
        address _factory,
        address _bDeployer,
        address _cDeployer,
        address _WETH
    ) public {
        factory = _factory;
        bDeployer = _bDeployer;
        cDeployer = _cDeployer;
        WETH = _WETH;
    }

    receive() external payable {
        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
    }

    /*** Mint ***/

    function _mint(
        address poolToken,
        address token,
        uint256 amount,
        address from,
        address to
    ) internal virtual returns (uint256 tokens) {
        if (from == address(this))
            TransferHelper.safeTransfer(token, poolToken, amount);
        else TransferHelper.safeTransferFrom(token, from, poolToken, amount);
        tokens = IPoolToken(poolToken).mint(to);
    }

    function mint(
        address poolToken,
        uint256 amount,
        address to,
        uint256 deadline
    ) external virtual override ensure(deadline) returns (uint256 tokens) {
        return
            _mint(
                poolToken,
                IPoolToken(poolToken).underlying(),
                amount,
                msg.sender,
                to
            );
    }

    function mintETH(
        address poolToken,
        address to,
        uint256 deadline
    )
        external
        payable
        virtual
        override
        ensure(deadline)
        checkETH(poolToken)
        returns (uint256 tokens)
    {
        IWETH(WETH).deposit{value: msg.value}();
        return _mint(poolToken, WETH, msg.value, address(this), to);
    }

    function mintCollateral(
        address poolToken,
        uint256 amount,
        address to,
        uint256 deadline,
        bytes calldata permitData
    ) external virtual override ensure(deadline) returns (uint256 tokens) {
        address underlying = IPoolToken(poolToken).underlying();
        if (isVaultToken(underlying)) {
            address uniswapV2Pair = IVaultToken(underlying).underlying();
            _permit(uniswapV2Pair, amount, deadline, permitData);
            TransferHelper.safeTransferFrom(
                uniswapV2Pair,
                msg.sender,
                underlying,
                amount
            );
            IVaultToken(underlying).mint(poolToken);
            return IPoolToken(poolToken).mint(to);
        } else {
            _permit(underlying, amount, deadline, permitData);
            return _mint(poolToken, underlying, amount, msg.sender, to);
        }
    }

    /*** Redeem ***/

    function redeem(
        address poolToken,
        uint256 tokens,
        address to,
        uint256 deadline,
        bytes memory permitData
    ) public virtual override ensure(deadline) returns (uint256 amount) {
        _permit(poolToken, tokens, deadline, permitData);
        IPoolToken(poolToken).transferFrom(msg.sender, poolToken, tokens);
        address underlying = IPoolToken(poolToken).underlying();
        if (isVaultToken(underlying)) {
            IPoolToken(poolToken).redeem(underlying);
            return IVaultToken(underlying).redeem(to);
        } else {
            return IPoolToken(poolToken).redeem(to);
        }
    }

    function redeemETH(
        address poolToken,
        uint256 tokens,
        address to,
        uint256 deadline,
        bytes memory permitData
    )
        public
        virtual
        override
        ensure(deadline)
        checkETH(poolToken)
        returns (uint256 amountETH)
    {
        amountETH = redeem(
            poolToken,
            tokens,
            address(this),
            deadline,
            permitData
        );
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    /*** Borrow ***/

    function borrow(
        address borrowable,
        uint256 amount,
        address to,
        uint256 deadline,
        bytes memory permitData
    ) public virtual override ensure(deadline) {
        _borrowPermit(borrowable, amount, deadline, permitData);
        IBorrowable(borrowable).borrow(msg.sender, to, amount, new bytes(0));
    }

    function borrowETH(
        address borrowable,
        uint256 amountETH,
        address to,
        uint256 deadline,
        bytes memory permitData
    ) public virtual override ensure(deadline) checkETH(borrowable) {
        borrow(borrowable, amountETH, address(this), deadline, permitData);
        IWETH(WETH).withdraw(amountETH);
        TransferHelper.safeTransferETH(to, amountETH);
    }

    /*** Repay ***/

    function _repayAmount(
        address borrowable,
        uint256 amountMax,
        address borrower
    ) internal virtual returns (uint256 amount) {
        IBorrowable(borrowable).accrueInterest();
        uint256 borrowedAmount = IBorrowable(borrowable).borrowBalance(
            borrower
        );
        amount = amountMax < borrowedAmount ? amountMax : borrowedAmount;
    }

    function repay(
        address borrowable,
        uint256 amountMax,
        address borrower,
        uint256 deadline
    ) external virtual override ensure(deadline) returns (uint256 amount) {
        amount = _repayAmount(borrowable, amountMax, borrower);
        TransferHelper.safeTransferFrom(
            IBorrowable(borrowable).underlying(),
            msg.sender,
            borrowable,
            amount
        );
        IBorrowable(borrowable).borrow(borrower, address(0), 0, new bytes(0));
    }

    function repayETH(
        address borrowable,
        address borrower,
        uint256 deadline
    )
        external
        payable
        virtual
        override
        ensure(deadline)
        checkETH(borrowable)
        returns (uint256 amountETH)
    {
        amountETH = _repayAmount(borrowable, msg.value, borrower);
        IWETH(WETH).deposit{value: amountETH}();
        assert(IWETH(WETH).transfer(borrowable, amountETH));
        IBorrowable(borrowable).borrow(borrower, address(0), 0, new bytes(0));
        // refund surpluss eth, if any
        if (msg.value > amountETH)
            TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
    }

    /*** Liquidate ***/

    function liquidate(
        address borrowable,
        uint256 amountMax,
        address borrower,
        address to,
        uint256 deadline
    )
        external
        virtual
        override
        ensure(deadline)
        returns (uint256 amount, uint256 seizeTokens)
    {
        require(IFactory(factory).canLiquidate(msg.sender), "Not permitted to liquidate");
        amount = _repayAmount(borrowable, amountMax, borrower);
        TransferHelper.safeTransferFrom(
            IBorrowable(borrowable).underlying(),
            msg.sender,
            borrowable,
            amount
        );
        seizeTokens = IBorrowable(borrowable).liquidate(borrower, to);
    }

    function liquidateETH(
        address borrowable,
        address borrower,
        address to,
        uint256 deadline
    )
        external
        payable
        virtual
        override
        ensure(deadline)
        checkETH(borrowable)
        returns (uint256 amountETH, uint256 seizeTokens)
    {
        require(IFactory(factory).canLiquidate(msg.sender), "Not permitted to liquidate");
        amountETH = _repayAmount(borrowable, msg.value, borrower);
        IWETH(WETH).deposit{value: amountETH}();
        assert(IWETH(WETH).transfer(borrowable, amountETH));
        seizeTokens = IBorrowable(borrowable).liquidate(borrower, to);
        // refund surpluss eth, if any
        if (msg.value > amountETH)
            TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
    }

    /*** Leverage LP Token ***/

    function _leverage(
        address underlying,
        uint256 amountA,
        uint256 amountB,
        address to
    ) internal virtual {
        address borrowableA = getBorrowable(underlying, 0);
        // mint collateral
        bytes memory borrowBData = abi.encode(
            CalleeData({
                callType: CallType.ADD_LIQUIDITY_AND_MINT,
                underlying: underlying,
                borrowableIndex: 1,
                data: abi.encode(
                    AddLiquidityAndMintCalldata({
                        amountA: amountA,
                        amountB: amountB,
                        to: to
                    })
                )
            })
        );
        // borrow borrowableB
        bytes memory borrowAData = abi.encode(
            CalleeData({
                callType: CallType.BORROWB,
                underlying: underlying,
                borrowableIndex: 0,
                data: abi.encode(
                    BorrowBCalldata({
                        borrower: msg.sender,
                        receiver: address(this),
                        borrowAmount: amountB,
                        data: borrowBData
                    })
                )
            })
        );
        // borrow borrowableA
        IBorrowable(borrowableA).borrow(
            msg.sender,
            address(this),
            amountA,
            borrowAData
        );
    }

    function leverage(
        address underlying,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bytes calldata permitDataA,
        bytes calldata permitDataB
    ) external virtual override ensure(deadline) {
        _borrowPermit(
            getBorrowable(underlying, 0),
            amountADesired,
            deadline,
            permitDataA
        );
        _borrowPermit(
            getBorrowable(underlying, 1),
            amountBDesired,
            deadline,
            permitDataB
        );
        address uniswapV2Pair = getUniswapV2Pair(underlying);
        (uint256 amountA, uint256 amountB) = _optimalLiquidity(
            uniswapV2Pair,
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin
        );
        _leverage(underlying, amountA, amountB, to);
    }

    function _addLiquidityAndMint(
        address underlying,
        uint256 amountA,
        uint256 amountB,
        address to
    ) internal virtual {
        (
            address collateral,
            address borrowableA,
            address borrowableB
        ) = getLendingPool(underlying);
        address uniswapV2Pair = getUniswapV2Pair(underlying);
        // add liquidity to uniswap pair
        TransferHelper.safeTransfer(
            IBorrowable(borrowableA).underlying(),
            uniswapV2Pair,
            amountA
        );
        TransferHelper.safeTransfer(
            IBorrowable(borrowableB).underlying(),
            uniswapV2Pair,
            amountB
        );
        // mint LP token
        if (isVaultToken(underlying))
            IUniswapV2Pair(uniswapV2Pair).mint(underlying);
        IUniswapV2Pair(underlying).mint(collateral);
        // mint collateral
        ICollateral(collateral).mint(to);
    }

    /*** Deleverage LP Token ***/

    function deleverage(
        address underlying,
        uint256 redeemTokens,
        uint256 amountAMin,
        uint256 amountBMin,
        uint256 deadline,
        bytes calldata permitData
    ) external virtual override ensure(deadline) {
        address collateral = getCollateral(underlying);
        uint256 exchangeRate = ICollateral(collateral).exchangeRate();
        require(redeemTokens > 0, "Lif3Router: REDEEM_ZERO");
        uint256 redeemAmount = (redeemTokens - 1).mul(exchangeRate).div(1e18);
        _permit(collateral, redeemTokens, deadline, permitData);
        bytes memory redeemData = abi.encode(
            CalleeData({
                callType: CallType.REMOVE_LIQ_AND_REPAY,
                underlying: underlying,
                borrowableIndex: 0,
                data: abi.encode(
                    RemoveLiqAndRepayCalldata({
                        borrower: msg.sender,
                        redeemTokens: redeemTokens,
                        redeemAmount: redeemAmount,
                        amountAMin: amountAMin,
                        amountBMin: amountBMin
                    })
                )
            })
        );
        // flashRedeem
        ICollateral(collateral).flashRedeem(
            address(this),
            redeemAmount,
            redeemData
        );
    }

    function _removeLiqAndRepay(
        address underlying,
        address borrower,
        uint256 redeemTokens,
        uint256 redeemAmount,
        uint256 amountAMin,
        uint256 amountBMin
    ) internal virtual {
        (
            address collateral,
            address borrowableA,
            address borrowableB
        ) = getLendingPool(underlying);
        address tokenA = IBorrowable(borrowableA).underlying();
        address tokenB = IBorrowable(borrowableB).underlying();
        address uniswapV2Pair = getUniswapV2Pair(underlying);
        // removeLiquidity
        IUniswapV2Pair(underlying).transfer(underlying, redeemAmount);
        //TransferHelper.safeTransfer(underlying, underlying, redeemAmount);
        if (isVaultToken(underlying))
            IVaultToken(underlying).redeem(uniswapV2Pair);
        (uint256 amountAMax, uint256 amountBMax) = IUniswapV2Pair(uniswapV2Pair)
        .burn(address(this));
        require(amountAMax >= amountAMin, "Lif3Router: INSUFFICIENT_A_AMOUNT");
        require(amountBMax >= amountBMin, "Lif3Router: INSUFFICIENT_B_AMOUNT");
        // repay and refund
        _repayAndRefund(borrowableA, tokenA, borrower, amountAMax);
        _repayAndRefund(borrowableB, tokenB, borrower, amountBMax);
        // repay flash redeem
        ICollateral(collateral).transferFrom(
            borrower,
            collateral,
            redeemTokens
        );
    }

    function _repayAndRefund(
        address borrowable,
        address token,
        address borrower,
        uint256 amountMax
    ) internal virtual {
        //repay
        uint256 amount = _repayAmount(borrowable, amountMax, borrower);
        TransferHelper.safeTransfer(token, borrowable, amount);
        IBorrowable(borrowable).borrow(borrower, address(0), 0, new bytes(0));
        // refund excess
        if (amountMax > amount) {
            uint256 refundAmount = amountMax - amount;
            if (token == WETH) {
                TransferHelper.safeTransferETH(borrower, refundAmount);
            } else TransferHelper.safeTransfer(token, borrower, refundAmount);
        }
    }

    /*** Lif3 Callee ***/

    enum CallType {
        ADD_LIQUIDITY_AND_MINT,
        BORROWB,
        REMOVE_LIQ_AND_REPAY
    }
    struct CalleeData {
        CallType callType;
        address underlying;
        uint8 borrowableIndex;
        bytes data;
    }
    struct AddLiquidityAndMintCalldata {
        uint256 amountA;
        uint256 amountB;
        address to;
    }
    struct BorrowBCalldata {
        address borrower;
        address receiver;
        uint256 borrowAmount;
        bytes data;
    }
    struct RemoveLiqAndRepayCalldata {
        address borrower;
        uint256 redeemTokens;
        uint256 redeemAmount;
        uint256 amountAMin;
        uint256 amountBMin;
    }

    function lif3Borrow(
        address sender,
        address borrower,
        uint256 borrowAmount,
        bytes calldata data
    ) external virtual override {
        borrower;
        borrowAmount;
        CalleeData memory calleeData = abi.decode(data, (CalleeData));
        address declaredCaller = getBorrowable(
            calleeData.underlying,
            calleeData.borrowableIndex
        );
        // only succeeds if called by a borrowable and if that borrowable has been called by the router
        require(sender == address(this), "Lif3Router: SENDER_NOT_ROUTER");
        require(
            msg.sender == declaredCaller,
            "Lif3Router: UNAUTHORIZED_CALLER"
        );
        if (calleeData.callType == CallType.ADD_LIQUIDITY_AND_MINT) {
            AddLiquidityAndMintCalldata memory d = abi.decode(
                calleeData.data,
                (AddLiquidityAndMintCalldata)
            );
            _addLiquidityAndMint(
                calleeData.underlying,
                d.amountA,
                d.amountB,
                d.to
            );
        } else if (calleeData.callType == CallType.BORROWB) {
            BorrowBCalldata memory d = abi.decode(
                calleeData.data,
                (BorrowBCalldata)
            );
            address borrowableB = getBorrowable(calleeData.underlying, 1);
            IBorrowable(borrowableB).borrow(
                d.borrower,
                d.receiver,
                d.borrowAmount,
                d.data
            );
        } else revert();
    }

    function lif3Redeem(
        address sender,
        uint256 redeemAmount,
        bytes calldata data
    ) external virtual override {
        redeemAmount;
        CalleeData memory calleeData = abi.decode(data, (CalleeData));
        address declaredCaller = getCollateral(calleeData.underlying);
        // only succeeds if called by a collateral and if that collateral has been called by the router
        require(sender == address(this), "Lif3Router: SENDER_NOT_ROUTER");
        require(
            msg.sender == declaredCaller,
            "Lif3Router: UNAUTHORIZED_CALLER"
        );
        if (calleeData.callType == CallType.REMOVE_LIQ_AND_REPAY) {
            RemoveLiqAndRepayCalldata memory d = abi.decode(
                calleeData.data,
                (RemoveLiqAndRepayCalldata)
            );
            _removeLiqAndRepay(
                calleeData.underlying,
                d.borrower,
                d.redeemTokens,
                d.redeemAmount,
                d.amountAMin,
                d.amountBMin
            );
        } else revert();
    }

    /*** Utilities ***/

    function _permit(
        address poolToken,
        uint256 amount,
        uint256 deadline,
        bytes memory permitData
    ) internal virtual {
        if (permitData.length == 0) return;
        (bool approveMax, uint8 v, bytes32 r, bytes32 s) = abi.decode(
            permitData,
            (bool, uint8, bytes32, bytes32)
        );
        uint256 value = approveMax ? uint256(-1) : amount;
        IPoolToken(poolToken).permit(
            msg.sender,
            address(this),
            value,
            deadline,
            v,
            r,
            s
        );
    }

    function _borrowPermit(
        address borrowable,
        uint256 amount,
        uint256 deadline,
        bytes memory permitData
    ) internal virtual {
        if (permitData.length == 0) return;
        (bool approveMax, uint8 v, bytes32 r, bytes32 s) = abi.decode(
            permitData,
            (bool, uint8, bytes32, bytes32)
        );
        uint256 value = approveMax ? uint256(-1) : amount;
        IBorrowable(borrowable).borrowPermit(
            msg.sender,
            address(this),
            value,
            deadline,
            v,
            r,
            s
        );
    }

    function _optimalLiquidity(
        address uniswapV2Pair,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin
    ) public view virtual returns (uint256 amountA, uint256 amountB) {
        (uint256 reserveA, uint256 reserveB, ) = IUniswapV2Pair(uniswapV2Pair)
        .getReserves();
        uint256 amountBOptimal = _quote(amountADesired, reserveA, reserveB);
        if (amountBOptimal <= amountBDesired) {
            require(
                amountBOptimal >= amountBMin,
                "Lif3Router: INSUFFICIENT_B_AMOUNT"
            );
            (amountA, amountB) = (amountADesired, amountBOptimal);
        } else {
            uint256 amountAOptimal = _quote(amountBDesired, reserveB, reserveA);
            assert(amountAOptimal <= amountADesired);
            require(
                amountAOptimal >= amountAMin,
                "Lif3Router: INSUFFICIENT_A_AMOUNT"
            );
            (amountA, amountB) = (amountAOptimal, amountBDesired);
        }
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function _quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) internal pure returns (uint256 amountB) {
        require(amountA > 0, "Lif3Router: INSUFFICIENT_AMOUNT");
        require(
            reserveA > 0 && reserveB > 0,
            "Lif3Router: INSUFFICIENT_LIQUIDITY"
        );
        amountB = amountA.mul(reserveB) / reserveA;
    }

    function isVaultToken(address underlying)
        public
        view
        virtual
        override
        returns (bool)
    {
        if (underlying == WETH) {
            return false;
        }
        try IVaultToken(underlying).isVaultToken() returns (bool result) {
            return result;
        } catch {
            return false;
        }
    }

    function getUniswapV2Pair(address underlying)
        public
        view
        virtual
        override
        returns (address)
    {
        try IVaultToken(underlying).underlying() returns (address u) {
            if (u != address(0)) return u;
            return underlying;
        } catch {
            return underlying;
        }
    }

    function getBorrowable(address underlying, uint8 index)
        public
        view
        virtual
        override
        returns (address borrowable)
    {
        require(index < 2, "Lif3Router: INDEX_TOO_HIGH");
        borrowable = address(
            uint256(
                keccak256(
                    abi.encodePacked(
                        hex"ff",
                        bDeployer,
                        keccak256(abi.encodePacked(factory, underlying, index)),
                        hex"b3881bdcb5636c700a9c8e3c068ea4fcfffaf4d877b2945b050165e31e51a84b" // Borrowable bytecode keccak256
                    )
                )
            )
        );
    }

    function getCollateral(address underlying)
        public
        view
        virtual
        override
        returns (address collateral)
    {
        collateral = address(
            uint256(
                keccak256(
                    abi.encodePacked(
                        hex"ff",
                        cDeployer,
                        keccak256(abi.encodePacked(factory, underlying)),
                        hex"0299c3dd197fa1db543a6c06c359e187e6c67fc937d51b5d5767651ec59fed0d" // Collateral bytecode keccak256
                    )
                )
            )
        );
    }

    function getLendingPool(address underlying)
        public
        view
        virtual
        override
        returns (
            address collateral,
            address borrowableA,
            address borrowableB
        )
    {
        collateral = getCollateral(underlying);
        borrowableA = getBorrowable(underlying, 0);
        borrowableB = getBorrowable(underlying, 1);
    }
}