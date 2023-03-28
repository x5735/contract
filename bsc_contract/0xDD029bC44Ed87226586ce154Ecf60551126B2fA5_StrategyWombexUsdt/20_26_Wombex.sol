// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


interface IAsset is IERC20 {
    function underlyingToken() external view returns (address);

    function pool() external view returns (address);

    function cash() external view returns (uint120);

    function liability() external view returns (uint120);

    function decimals() external view returns (uint8);

    function underlyingTokenDecimals() external view returns (uint8);

    function setPool(address pool_) external;

    function underlyingTokenBalance() external view returns (uint256);

    function transferUnderlyingToken(address to, uint256 amount) external;

    function mint(address to, uint256 amount) external;

    function burn(address to, uint256 amount) external;

    function addCash(uint256 amount) external;

    function removeCash(uint256 amount) external;

    function addLiability(uint256 amount) external;

    function removeLiability(uint256 amount) external;
}


interface IBaseRewardPool is IERC20 {

    /**
     * @notice Total amount of the underlying asset that is "managed" by Vault.
     */
    function totalAssets() external view returns(uint256);

    /**
     * @notice Mints `shares` Vault shares to `receiver`.
     * @dev Because `asset` is not actually what is collected here, first wrap to required token in the booster.
     */
    function deposit(uint256 assets, address receiver) external returns (uint256);

    /**
     * @notice Mints exactly `shares` Vault shares to `receiver`
     * by depositing `assets` of underlying tokens.
     */
    function mint(uint256 shares, address receiver) external returns (uint256);

    /**
     * @notice Redeems `shares` from `owner` and sends `assets`
     * of underlying tokens to `receiver`.
     */
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external returns (uint256);

    /**
     * @notice Redeems `shares` from `owner` and sends `assets`
     * of underlying tokens to `receiver`.
     */
    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external returns (uint256);

    /**
     * @notice The amount of shares that the vault would
     * exchange for the amount of assets provided, in an
     * ideal scenario where all the conditions are met.
     */
    function convertToShares(uint256 assets) external view returns (uint256);

    /**
     * @notice The amount of assets that the vault would
     * exchange for the amount of shares provided, in an
     * ideal scenario where all the conditions are met.
     */
    function convertToAssets(uint256 shares) external view returns (uint256);

    /**
     * @notice Total number of underlying assets that can
     * be deposited by `owner` into the Vault, where `owner`
     * corresponds to the input parameter `receiver` of a
     * `deposit` call.
     */
    function maxDeposit(address /* owner */) external view returns (uint256);

    /**
     * @notice Allows an on-chain or off-chain user to simulate
     * the effects of their deposit at the current block, given
     * current on-chain conditions.
     */
    function previewDeposit(uint256 assets) external view returns(uint256);

    /**
     * @notice Total number of underlying shares that can be minted
     * for `owner`, where `owner` corresponds to the input
     * parameter `receiver` of a `mint` call.
     */
    function maxMint(address owner) external view returns (uint256);

    /**
     * @notice Allows an on-chain or off-chain user to simulate
     * the effects of their mint at the current block, given
     * current on-chain conditions.
     */
    function previewMint(uint256 shares) external view returns(uint256);

    /**
     * @notice Total number of underlying assets that can be
     * withdrawn from the Vault by `owner`, where `owner`
     * corresponds to the input parameter of a `withdraw` call.
     */
    function maxWithdraw(address owner) external view returns (uint256);

    /**
     * @notice Allows an on-chain or off-chain user to simulate
     * the effects of their withdrawal at the current block,
     * given current on-chain conditions.
     */
    function previewWithdraw(uint256 assets) external view returns(uint256 shares);

    /**
     * @notice Total number of underlying shares that can be
     * redeemed from the Vault by `owner`, where `owner` corresponds
     * to the input parameter of a `redeem` call.
     */
    function maxRedeem(address owner) external view returns (uint256);

    /**
     * @notice Allows an on-chain or off-chain user to simulate
     * the effects of their redeemption at the current block,
     * given current on-chain conditions.
     */
    function previewRedeem(uint256 shares) external view returns(uint256);

    function lastTimeRewardApplicable(address _token) external view returns (uint256);

    function rewardPerToken(address _token) external view returns (uint256);

    function earned(address _token, address _account) external view returns (uint256);

    function claimableRewards(address _account) external view returns (address[] memory tokens, uint256[] memory amounts);

    function stake(uint256 _amount)
    external
    returns(bool);

    function stakeAll() external returns(bool);

    function stakeFor(address _for, uint256 _amount)
    external
    returns(bool);

    function withdraw(uint256 amount, bool claim)
    external
    returns(bool);

    function withdrawAll(bool claim) external;

    function withdrawAndUnwrap(uint256 amount, bool claim) external returns(bool);

    function withdrawAllAndUnwrap(bool claim) external;

    /**
     * @dev Gives a staker their rewards, with the option of claiming extra rewards
     * @param _account     Account for which to claim
     * @param _lockCvx     Get the child rewards too?
     */
    function getReward(address _account, bool _lockCvx) external returns(bool);

    /**
     * @dev Called by a staker to get their allocated rewards
     */
    function getReward() external returns(bool);

    /**
     * @dev Donate some extra rewards to this contract
     */
    function donate(address _token, uint256 _amount) external returns(bool);

    /**
     * @dev Processes queued rewards in isolation, providing the period has finished.
     *      This allows a cheaper way to trigger rewards on low value pools.
     */
    function processIdleRewards() external;

    function rewardTokensLen() external view returns (uint256);

    function rewardTokensList() external view returns (address[] memory);
}


interface IPoolDepositor {

    function deposit(address _lptoken, uint256 _amount, uint256 _minLiquidity, bool _stake) external;

    function withdraw(address _lptoken, uint256 _amount, uint256 _minOut, address _recipient) external;

    function getDepositAmountOut(address _lptoken, uint256 _amount) external view returns (uint256 liquidity, uint256 reward);

    function getWithdrawAmountOut(address _lptoken, uint256 _amount) external view returns (uint256 amount, uint256 fee);
}


interface IPool {
    function getTokens() external view returns (address[] memory);

    function addressOfAsset(address token) external view returns (address);

    function deposit(
        address token,
        uint256 amount,
        uint256 minimumLiquidity,
        address to,
        uint256 deadline,
        bool shouldStake
    ) external returns (uint256 liquidity);

    function withdraw(
        address token,
        uint256 liquidity,
        uint256 minimumAmount,
        address to,
        uint256 deadline
    ) external returns (uint256 amount);

    function withdrawFromOtherAsset(
        address fromToken,
        address toToken,
        uint256 liquidity,
        uint256 minimumAmount,
        address to,
        uint256 deadline
    ) external returns (uint256 amount);

    function swap(
        address fromToken,
        address toToken,
        uint256 fromAmount,
        uint256 minimumToAmount,
        address to,
        uint256 deadline
    ) external returns (uint256 actualToAmount, uint256 haircut);

    function quotePotentialDeposit(address token, uint256 amount)
    external
    view
    returns (uint256 liquidity, uint256 reward);

    function quotePotentialSwap(
        address fromToken,
        address toToken,
        int256 fromAmount
    ) external view returns (uint256 potentialOutcome, uint256 haircut);

    function quotePotentialWithdraw(address token, uint256 liquidity)
    external
    view
    returns (uint256 amount, uint256 fee);

    function quoteAmountIn(
        address fromToken,
        address toToken,
        int256 toAmount
    ) external view returns (uint256 amountIn, uint256 haircut);
}