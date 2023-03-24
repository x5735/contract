/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity 0.8.17;
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
     * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
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

contract RigelRewardPool is Ownable {

    // token that is used as the reward token by trading contract
    IERC20 private immutable pRGP;
    // reward token
    IERC20 private immutable RGP;
    // TimeFrame that will be added for rext available rewards
    uint256 private TimeFrame;
    // amount to be distributed for current rewards and next rewards
    uint256 private CurrentAllocation;
    // current time frame
    uint256 private updatedTimeFrame;

    // Get the time that user must unstake after timeframe has ellapse
    uint256 private timeToUnstake;

    // list of all the periods of events in loop
    uint256[] private allTimeEvents;

    // User Information
    struct UserInfo {
        address user;
        uint256 timeDeposit;
        uint256 amountDeposit;
        uint256 acruedReward;
    }

    // mapping of when time ellapse and the users that are withing the range of this time fram
    mapping (uint256 => UserInfo[]) private rangeOfAllUsers;
    // allocation to be stored when new event start
    mapping(uint256 => uint256) private eventAllocatio;

    /// @notice initialize the contract
    /// @param _pRGP pRGP token that is used as the reward token by trading contract
    /// @param _rgp reward token
    constructor(address _pRGP, address _rgp) {
        pRGP = IERC20(_pRGP);
        RGP = IERC20(_rgp);
    }

    /* ##################################################################
                            EVENTS
    ################################################################## */

    event params(uint256 interval, uint256 allocation);

    event unstakeTimeDif(uint256 time);

    event staked(address indexed user, uint256 amount, uint256 time, uint256 _timeFrame);

    event unstake(address indexed user, uint256 shareReward, uint256 time);

    /* ##################################################################
                                ADMIN FUNCTIONS
    ################################################################## */

    /// @notice set interval of time frame before the next loop and also the possible specifield amount to be claim paramters
    /// @param newInterval next available time frame in seconds
    /// @param newAllocation set the amount that will be claimable.
    function setParams(uint256 newInterval, uint256 newAllocation) external onlyOwner {
        require(newInterval > 0, "RIGEL: Invalid specified time");
        TimeFrame = newInterval;
        CurrentAllocation = newAllocation;
        emit params(newInterval, newAllocation);
    }

    /// @notice Owner need to initialize the time to unstake, should be in seconds
    /// @param initTime new different in time.
    function initializeTimeToUnstake(uint256 initTime) external onlyOwner {
        timeToUnstake = initTime;
        emit unstakeTimeDif(initTime);
    }

    function withdrawToken(IERC20 token, address recipient, uint256 amount) external onlyOwner {
        token.transfer(recipient, amount);
    }

    /* ################################################################## 
                                USER FUNCTIONS
    ################################################################## */

    /// @notice user can easily stake thier pRGP rewards.
    /// user must have approved this contract to withdraw pRGP from him
    /// amount must be greater than 0
    /// @param amount amount of pRGP user have.
    function stake(uint256 amount) external {
        require(amount != 0, "Invalid Deposit amount");
        // transfer pRGP from user first.
        pRGP.transferFrom(msg.sender, address(this), amount);

        // store user infor
        uint256 lastKnownTime = computeTime();
        // caluclate user last staked amount
        (uint256 _lastStakedAmount, uint256 userID) =  _userStakedAmount(lastKnownTime, msg.sender);

        UserInfo memory _userInfo = 
            UserInfo(
                {
                    user: msg.sender, 
                    timeDeposit: block.timestamp, 
                    amountDeposit : _lastStakedAmount + amount, 
                    acruedReward : 0
                }
            );

        // check user last deposit to know if user want to deposit under the same event
        if(_lastStakedAmount == 0) {
            rangeOfAllUsers[lastKnownTime].push(_userInfo);
        } else { // else user has deposit during the last event and want to deposit again.
            rangeOfAllUsers[lastKnownTime][userID] = _userInfo;
        }
        emit staked(msg.sender, amount, block.timestamp, lastKnownTime);
    }

    /// @notice user can easily claim thier RGP rewards.
    /// user must have staked on this event.
    /// timeframe to unstake must be within the specified time by the owner
    /// @param timedEvent .
    function claimReward(uint256 timedEvent) external {
        // ensure user withdraw within specified allowable timeframe
        if (timeToUnstake != 0) {
            require(
                block.timestamp - (timedEvent + timeToUnstake) 
                < timedEvent + TimeFrame + timeToUnstake, "Time to claim Ellapse" );
        }
        // verify if user has staked on the event
        (bool userStaked, uint256 amountStaked) = _userStakedOnEvent(msg.sender, timedEvent);
        require(userStaked, "User not found");
        // get the total sum amount that has been staked on the event ID
        uint256 sumAmount = _computeRewards(timedEvent);
        // calculate user rewards
        uint256 share = computeSharedReward(sumAmount,amountStaked, timedEvent );
        // transfer RGP to user
        RGP.transfer(msg.sender, share);
        emit unstake(msg.sender, share, block.timestamp);
    }

    /* ##################################################################
                            INTERNAL FUNCTIONS
    ################################################################## */

    /// @notice get the time user deposit feet in, if previous time already allaps, start new time from here.
    /// @return lastKnownTime the last know time that staked happened
    function computeTime() private returns(uint256 lastKnownTime) {
        // get the last deposited time on the arr.
        uint256 allTime = allTimeEvents.length;
        // compute when the time will expire for this event
        uint256 expirationTime;
        // time should be initialized on first deposit
        if(allTime == 0) {
            allTimeEvents.push(block.timestamp);
            // get the last known time from arr
            lastKnownTime = allTimeEvents[0];
            // update allocation for the known time
            eventAllocatio[lastKnownTime] = CurrentAllocation;
        } else {
            lastKnownTime = allTimeEvents[allTimeEvents.length - 1];
            // update allocation for the known time
            eventAllocatio[lastKnownTime] = CurrentAllocation;
            // compute when the time will expire for this event
            expirationTime = lastKnownTime + TimeFrame;            
            // start new time when time for past event has ellapsed
            if(expirationTime < block.timestamp) {
                // update new timeframe
                allTimeEvents.push(block.timestamp);
                // get the last known time from arr
                lastKnownTime = block.timestamp;
            }
        }
    }

    /// @notice caluclate user last staked amount
    /// @param lastKnownTime amount of pRGP user have.
    /// @return _lastStakedAmount sum of amount user has staked if 0 then user is staking for the first time.
    /// @return userID the user id, if 0 then user is staking for the first time
    function _userStakedAmount(uint256 lastKnownTime, address user) private view returns(uint256 _lastStakedAmount, uint256 userID) {
        // get all staked for this time
        UserInfo[] memory _allRange = rangeOfAllUsers[lastKnownTime];
        // for gas opt store lenght
        uint256 allLength = _allRange.length;
        for (uint256 i; i < allLength; ) {
            if (_allRange[i].user == user) {
                // all current staked amount
                _lastStakedAmount = _allRange[i].amountDeposit;
                userID = i;
                break;
            }
            unchecked {
                i++;
            }
        }
    }

    /// @notice Compute user equivalent rewards in RGP from pRGP.
    /// @param timedEvent amount of pRGP user have.
    /// @return sumAmount total sum of amount deposited on this timedEvent
    function _computeRewards(uint256 timedEvent) private view returns(uint256 sumAmount) {
        // get all staked for this time
        UserInfo[] memory _allRange = rangeOfAllUsers[timedEvent];
        // for gas opt store lenght
        uint256 allLength = _allRange.length;
        for (uint256 i; i < allLength; ) {
            sumAmount += _allRange[i].amountDeposit;
            unchecked {
                i++;
            }
        }
    }

    /// @notice Compute user equivalent rewards in RGP from pRGP.
    /// @param user amount of pRGP user have.
    /// @param timedEvent event ID
    /// @return userStaked returns true if user staked on event
    /// @return amountStaked total sum of amount deposited on this timedEvent
    function _userStakedOnEvent(address user, uint256 timedEvent) private view returns(bool userStaked, uint256 amountStaked) {
        // get all staked for this time
        UserInfo[] memory _allRange = rangeOfAllUsers[timedEvent];
        // for gas opt store lenght
        uint256 allLength = _allRange.length;
        for (uint256 i; i < allLength; ) {
            if (_allRange[i].user == user) {
                // all current staked amount
                userStaked = true;
                amountStaked = _allRange[i].amountDeposit;
                break;
            } else {
                userStaked = false;
            }
            unchecked {
                i++;
            }
        }
    }

    /// @notice Compute user equivalent rewards in RGP from pRGP.
    /// @param sumAmountStaken sum of amount staked on a particular event.
    /// @param stakeAmount amount staked
    /// @param timedEvent event ID
    /// @return share returns the share that user get.
    function computeSharedReward(uint256 sumAmountStaken, uint256 stakeAmount, uint256 timedEvent) private view returns(uint256 share) {
        return stakeAmount * eventAllocatio[timedEvent] / sumAmountStaken;
    }

    /* ##################################################################
                                VIEW FUNCTIONS
    ################################################################## */

    ///@notice returns the TimeFrame
    ///@return TimeFrame that will be added for rext available rewards
    function timeFrame() external view returns (uint256) {
        return TimeFrame;
    }

    ///@notice returns the current amount specified for the next round of distribution
    ///@return amount to be distributed for current rewards and next rewards
    function availableRewards() external view returns (uint256) {
        return CurrentAllocation;
    }

    ///@notice get the total numbers of events.
    ///@return return the length of event available at the current time
    function AllEventLenght() external view returns(uint256) {
        return allTimeEvents.length;
    }
    ///@notice return the time that the associated event ID ellapse.
    ///@return return the time in seconds of when the event time ellapse.
    function getAllEventsTime(uint256 eventID) external view returns(uint256) {
        return allTimeEvents[eventID];
    }

    function getRangeOfAllUsers(uint256 timedEvent) external view returns(UserInfo[] memory allRange) {
        // get the lenght of users in a struct with timeEllapse
        UserInfo[] memory _allRange = rangeOfAllUsers[timedEvent];
        uint256 allRangeLength = _allRange.length;
        allRange = new UserInfo[](allRangeLength);
        for (uint i; i < allRangeLength; ) {
            allRange[i] = _allRange[i];
            unchecked {
                i++;
            }
        }
    }

    /// @notice Compute user equivalent rewards in RGP from pRGP.
    /// @param timedEvent amount of pRGP user have.
    /// @return sumAmount total sum of amount deposited on this timedEvent
    function cummulativeAmount(uint256 timedEvent) external view returns(uint256 sumAmount) {
        sumAmount = _computeRewards(timedEvent);
    }

    /// @notice Compute user equivalent rewards in RGP from pRGP.
    /// @param user amount of pRGP user have.
    /// @param timedEvent event ID
    /// @return userStaked returns true if user staked on event
    /// @return amountStaked total sum of amount deposited on this timedEvent
    function userStakedOnEvent(address user, uint256 timedEvent) external view returns(bool userStaked, uint256 amountStaked) {
        (userStaked, amountStaked) = _userStakedOnEvent(user, timedEvent);
    }

    /// @notice caluclate user last staked amount
    /// @param timedEvent amount of pRGP user have.
    /// @return _lastStakedAmount sum of amount user has staked if 0 then user is staking for the first time.
    /// @return userID the user id, if 0 then user is staking for the first time
    function userStakedAmount(uint256 timedEvent, address user) external view returns(uint256 _lastStakedAmount, uint256 userID) {
        (_lastStakedAmount, userID) = _userStakedAmount(timedEvent, user);
    }

    /// @notice get the allocation that is set when event started
    /// @param timedEvent amount of pRGP user have.
    /// @return _lastStakedAmount sum of amount user has staked if 0 then user is staking for the first time.
    function getAllocationForEvent(uint256 timedEvent) external view returns(uint256) {
        return eventAllocatio[timedEvent];
    }


    function getPRGPToken() external view returns(address) {
        return address(pRGP);
    }

    function getRGPToken() external view returns(address) {
        return address(RGP);
    }

}