/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVault {
    function addWhitelist(address addr) external;

    function removeWhitelist(address addr) external;

    function withdraw(address tokenAddress, address to, uint256 amount) external;

    function isWhitelist(address addr) external view returns (bool);
}

// File: src/IRegister.sol

pragma solidity ^0.8.0;

interface IRegister {
    event Regist(address player, address inviter);

    function addDefaultInviter(address addr) external returns (bool);

    function regist(address _inviter) external returns (bool);

    function registed(address _player) external view returns (bool);

    function myInviter(address _player) external view returns (address);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

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
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

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

// File: @openzeppelin/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

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

// File: src/Fleet.sol

pragma solidity ^0.8.0;

contract Fleet is Ownable {
    IERC20 public token;
    IRegister public register;
    IVault public compensationAmountVault;
    IVault public inviterVault;
    uint256 public breakEvenPoolBalance;
    uint256 public staticPoolBalance;
    uint256 public burnPoolBalance;
    uint256 public reawrdPoolBalance;
    uint256 public marketPoolBalance;
    uint256 public minDepositAmount;
    uint256 public maxDepositAmount;
    uint256 public depositRewardRate = 1;
    uint256 public breakEvenRate = 65;
    uint256 public staticRate = 26;
    uint256 public burnRate = 1;
    uint256 public rewardRate = 3;
    uint256 public marketRate = 2;
    uint256 public inviteRate = 3;
    uint256 public compensationAmount;
    uint256 public fusingUserLeftPrincipal;
    uint256 public startTime = block.timestamp;
    uint256 public withdrawDuration = 24 hours;
    uint256 compensationAmountReleaseDuration = 180 days;
    uint256 public fusingTime;
    bool public fusing;
    address public burnAddress = address(0x000000000000000000000000000000000000dEaD);
    address public marketPoolReceiveAddress;
    address public rewardPoolOperator;
    mapping(address => UserDeposit) userDepositMap;
    mapping(address => UserFusingInfo) UserFusingInfoMap;

    event Withdraw(address user, uint256 principal, uint256 reward);

    event Deposit(address user, uint256 principal);

    event Fusing();

    event WithdrawPrincipalAfterFusing(address user, uint256 amount);

    event WithdrawCompensationAmountAfterFusing(address user, uint256 amount);

    modifier onFusing() {
        require(fusing, "Fleet: not fusing");
        _;
    }

    modifier notFusing() {
        require(!fusing, "Fleet: fusing");
        _;
    }

    modifier deposited() {
        UserDeposit memory userDeposit = userDepositMap[msg.sender];
        require(userDeposit.deposited, "FLEET: Not deposit");
        _;
    }

    struct UserDeposit {
        uint256 principal;
        uint256 depositTime;
        bool deposited;
    }

    struct GameInfo {
        uint256 breakEvenPoolBalance;
        uint256 burnPoolBalance;
        uint256 reawrdPoolBalance;
        uint256 marketPoolBalance;
        uint256 time;
        uint256 minDepositAmount;
        uint256 maxDepositAmount;
    }

    struct UserFusingInfo {
        uint256 principal;
        uint256 withdrawablePrincipal;
        uint256 totalCompensationAmount;
        uint256 lockedCompensationAmount;
        uint256 withdrewCompensationAmount;
        uint256 lastWithdrawCompensationAmountTime;
        uint256 withdrawableCompensationAmount;
        bool exist;
    }

    constructor(
        IERC20 token_,
        IRegister register_,
        address rewardPoolOperator_,
        address marketPoolReceiveAddress_,
        uint256 minDepositAmount_,
        uint256 maxDepositAmount_,
        IVault compensationAmountVault_,
        IVault inviterVault_
    ) {
        token = token_;
        register = register_;
        rewardPoolOperator = rewardPoolOperator_;
        marketPoolReceiveAddress = marketPoolReceiveAddress_;
        minDepositAmount = minDepositAmount_;
        maxDepositAmount = maxDepositAmount_;
        compensationAmountVault = compensationAmountVault_;
        inviterVault = inviterVault_;
    }

    function deposit(uint256 amount) public notFusing {
        require(amount >= minDepositAmount && amount <= maxDepositAmount, "Fleet: Invalid deposit amount");
        address user = msg.sender;
        UserDeposit storage userDeposit = userDepositMap[user];
        require(register.registed(user), "FLEET: Not registed");
        require(!userDeposit.deposited, "FLEET: deposited");
        userDeposit.depositTime = block.timestamp;
        userDeposit.principal = amount;
        userDeposit.deposited = true;
        userDepositMap[user] = userDeposit;
        fusingUserLeftPrincipal += (userDeposit.principal * (100 - breakEvenRate)) / 100;
        require(token.transferFrom(user, address(this), amount), "FLEET: Transfer token from user to contract faild");
        takeInvite(amount);
        takeBurn(amount);
        takeReward(amount);
        takeMarket(amount);

        breakEvenPoolBalance += (amount * breakEvenRate) / 100;
        staticPoolBalance += (amount * staticRate) / 100;
        emit Deposit(user, amount);
    }

    function takeBurn(uint256 amount) private {
        uint256 burnAmount = (amount * burnRate) / 100;
        require(token.transfer(burnAddress, burnAmount), "FLEET: Burn token fail");
        burnPoolBalance += burnAmount;
    }

    function takeReward(uint256 amount) private {
        reawrdPoolBalance += (amount * rewardRate) / 100;
    }

    function takeMarket(uint256 amount) private {
        amount = (amount * marketRate) / 100;
        require(token.transfer(marketPoolReceiveAddress, amount), "FLEET: Transfer market pool token failed");
        marketPoolBalance += amount;
    }

    function takeInvite(uint256 amount) private {
        require(
            token.transfer(address(inviterVault), (amount * inviteRate) / 100),
            "FLEET: Transfer token to inviter vault failed"
        );
    }

    function withdraw() public deposited notFusing {
        address user = msg.sender;
        UserDeposit storage userDeposit = userDepositMap[user];
        require(block.timestamp >= userDeposit.depositTime + withdrawDuration, "Fleet: Not time");
        uint256 userPrincipal = userDeposit.principal;
        uint256 reward = (userPrincipal * depositRewardRate) / 100;
        uint256 userBreakEvenPoolAmount = (userPrincipal * breakEvenRate) / 100;
        uint256 leftPrincipal = userPrincipal - userBreakEvenPoolAmount;
        if (staticPoolBalance >= leftPrincipal + reward) {
            fusingUserLeftPrincipal -= (userDeposit.principal * (100 - breakEvenRate)) / 100;
            breakEvenPoolBalance -= userBreakEvenPoolAmount;
            staticPoolBalance -= leftPrincipal + reward;
            require(token.transfer(user, userPrincipal + reward), "FLEET: withdraw transfer token failed");
            UserDeposit memory newUserDeposit = UserDeposit({principal: 0, depositTime: 0, deposited: false});
            userDepositMap[user] = newUserDeposit;
            emit Withdraw(user, userPrincipal, reward);
        } else {
            fusing = true;
            fusingTime = block.timestamp;
            require(
                token.transfer(rewardPoolOperator, reawrdPoolBalance),
                "FLEET: Transfer reward pool balance to operator failed"
            );
            compensationAmount = fusingUserLeftPrincipal * 2;
            require(
                token.transfer(address(compensationAmountVault), staticPoolBalance),
                "FLEET: Transfer static pool balance to compensation amount vault failed"
            );
            staticPoolBalance = 0;
            emit Fusing();
        }
    }

    function withdrawPrincipalAfterFusing() public deposited onFusing {
        address user = msg.sender;
        UserFusingInfo memory info = getFusingUserInfo(user);

        uint256 amount = info.withdrawablePrincipal;
        require(amount > 0, "FLEET: zero balance");
        info.withdrawablePrincipal = 0;
        UserFusingInfoMap[user] = info;
        breakEvenPoolBalance -= amount;
        require(token.transfer(user, amount), "FLEET: withdraw transfer token failed");
        emit WithdrawPrincipalAfterFusing(user, amount);
    }

    function withdrawCompensationAmountAfterFusing() public deposited onFusing {
        address user = msg.sender;
        UserFusingInfo memory info = getFusingUserInfo(user);

        uint256 amount = info.withdrawableCompensationAmount;
        require(amount > 0, "FLEET: zero balance");
        info.withdrewCompensationAmount += amount;
        info.lastWithdrawCompensationAmountTime = block.timestamp;
        UserFusingInfoMap[user] = info;
        compensationAmountVault.withdraw(address(token), user, amount);
        emit WithdrawCompensationAmountAfterFusing(user, amount);
    }

    function getFusingUserInfo(address user) public view returns (UserFusingInfo memory) {
        UserFusingInfo memory info = UserFusingInfoMap[user];
        if (!info.exist) {
            UserDeposit memory userDeposit = userDepositMap[user];
            uint256 principal = userDeposit.principal;
            uint256 lastWithdrawCompensationAmountTime = fusingTime;
            uint256 totalCompensationAmount = ((principal * (100 - breakEvenRate)) / 100) * 2;
            info = UserFusingInfo({
                principal: principal,
                withdrawablePrincipal: (principal * breakEvenRate) / 100,
                totalCompensationAmount: totalCompensationAmount,
                lockedCompensationAmount: totalCompensationAmount,
                withdrewCompensationAmount: 0,
                lastWithdrawCompensationAmountTime: lastWithdrawCompensationAmountTime,
                withdrawableCompensationAmount: 0,
                exist: true
            });
        }
        uint256 compensationAmountReleasePerSecond = info.totalCompensationAmount / compensationAmountReleaseDuration;
        uint256 withdrawableCompensationAmount =
            (block.timestamp - info.lastWithdrawCompensationAmountTime) * compensationAmountReleasePerSecond;
        if (withdrawableCompensationAmount + info.withdrewCompensationAmount > info.totalCompensationAmount) {
            withdrawableCompensationAmount = info.totalCompensationAmount - info.withdrewCompensationAmount;
        }
        info.withdrawableCompensationAmount = withdrawableCompensationAmount;
        info.lockedCompensationAmount =
            info.totalCompensationAmount - info.withdrewCompensationAmount - info.withdrawableCompensationAmount;

        return info;
    }

    function getGameInfo() public view returns (GameInfo memory) {
        return GameInfo({
            breakEvenPoolBalance: breakEvenPoolBalance + staticPoolBalance,
            burnPoolBalance: burnPoolBalance,
            reawrdPoolBalance: reawrdPoolBalance,
            marketPoolBalance: marketPoolBalance,
            time: startTime,
            minDepositAmount: minDepositAmount,
            maxDepositAmount: maxDepositAmount
        });
    }

    function getUserDepositInfo(address user) public view returns (UserDeposit memory) {
        return userDepositMap[user];
    }

    function setRewardPoolOperator(address addr) public onlyOwner {
        rewardPoolOperator = addr;
    }

    function setWithdrawDuration(uint256 duration) public onlyOwner {
        withdrawDuration = duration;
    }

    function setCompensationAmountReleaseDuration(uint256 duration) public onlyOwner {
        compensationAmountReleaseDuration = duration;
    }
}