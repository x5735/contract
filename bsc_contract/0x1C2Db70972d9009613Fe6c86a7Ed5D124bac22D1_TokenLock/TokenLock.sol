/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

// SPDX-License-Identifier: MIT

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

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


pragma solidity ^0.8.0;


contract TokenLock {
    address public tokenAddress;
    address public owner;
    uint256 public releaseTime;
    
    constructor(address _tokenAddress, uint256 _releaseTime) {
        tokenAddress = _tokenAddress;
        owner = msg.sender;
        releaseTime = _releaseTime;
    }
    
    function releaseTokens() public {
        require(msg.sender == owner, "Only the owner can release tokens");
        require(block.timestamp >= releaseTime, "Lockup period has not ended yet");
        
        IERC20 token = IERC20(tokenAddress);
        
        uint256 lockedAmount = token.balanceOf(address(this));
        require(lockedAmount > 0, "No tokens are locked");
        
        require(token.transfer(owner, lockedAmount), "Failed to transfer locked tokens");
    }
    function setOwner(address _to) public {
        require(msg.sender == owner,"Only the owner can change owner");
        owner = _to;
    }

    function getContractBalance() public view returns(uint256) {
        IERC20 token = IERC20(tokenAddress);
        return token.balanceOf(address(this));
    }

    function getTimeStampLeft() public view returns(uint256) {
        uint256 timeLeft = releaseTime - block.timestamp;
        return timeLeft;
    }
}