pragma solidity ^0.6.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.6.0;

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
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
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
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
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
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
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
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/ownership/Ownable.sol

pragma solidity ^0.6.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);
    function mint(address account, uint amount) external;

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
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
}

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.6.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call{value:amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.6.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface IGWC {
    function mint(address _account,uint _amount) external;
}

interface IDataCenter {

    function add(
        uint256 phase,
        uint256 time,
        uint256 payAmount,
        address owner,
        address currency,
        string memory describe
        ) external; 
}

pragma experimental ABIEncoderV2;
contract GAME is Ownable {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    uint256 public feePct;
    uint256 public playerAmount;
    uint256 public worldBossPlayerAmount;
    uint256 public winningAmount;
    uint256 public payAmount;
    uint256 public worldBossPayAmount;
    address public currency;
    uint256 public cycle;
    uint256 public worldBossCycle;

    uint256 public playerIndex;
    uint256 public worldBossPlayerIndex;
    uint256 public platformReward;
    uint256 public worldBossPlatformReward;
    uint256 public lotteryFund;
    uint256 public rewardGWCAmount;
    uint256 public worldBossRewardGWCAmount;
    uint256 public cycleReward;
    uint256 public worldBossCycleReward;
    bool public startWorldBoss;
    address public operator;
    IGWC public GWC;
    address public worldBossRewardAddr;
    IDataCenter dataCenter;
 
    struct Player {
        address user;
        bool win;
        uint256 time;
    }

    struct Result {
        uint256 value;
        uint256 cycle;
        uint256 module; //0 - GWC  ,1 - CURRENCY
        uint256 time;
    }
    
    
//cycle => index => player
    mapping (uint256=>mapping (uint256=>Player)) public cycles;
    mapping (uint256=>mapping (uint256=>Player)) public worldBossCycles;
    mapping (address=>uint256) public reward;
    mapping (address=>uint256) public worldBossReward;
    mapping (address=>uint256) public rewardGWC;
    mapping (address=>uint256) public worldBossRewardGWC;

    mapping (address=>Result[]) public records ;
    mapping (address=>Result[]) public worldBossrecords;

    constructor(address _dataCenter) public {
        dataCenter = IDataCenter(_dataCenter);
    }

    function normal() external payable {
        if(currency == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
            require(msg.value == payAmount);
            dataCenter.add(cycle, block.timestamp, payAmount, msg.sender, address(0), "ordinary");
        }else{
            IERC20(currency).safeTransferFrom(msg.sender,address(this),payAmount);
            dataCenter.add(cycle, block.timestamp, payAmount, msg.sender, currency, "ordinary");
        }
        for(uint256 i=0;i<playerIndex;i++){
            require(cycles[cycle][i].user != msg.sender,"already join");
        }

        platformReward = platformReward.add(payAmount.mul(feePct).div(100));
        lotteryFund = lotteryFund.add(payAmount.mul(100 - feePct).div(100));
        cycles[cycle][playerIndex].user = msg.sender;
        cycles[cycle][playerIndex].time = block.timestamp;
        playerIndex++;
        if(playerIndex == playerAmount){

            uint256  _random =uint256( keccak256(abi.encodePacked( cycle, msg.sender,block.timestamp,uint256(blockhash(block.number -1))))) % playerAmount;
            for(uint256 i=0;i< winningAmount;i++){
                cycles[cycle][_random].win = true;
                records[cycles[cycle][_random].user].push(Result({
                    value: cycleReward,
                    cycle:cycle,
                    module:1,
                    time:block.timestamp
                    
                }));
                reward[cycles[cycle][_random].user] =reward[cycles[cycle][_random].user].add(cycleReward);
                _random++;
                if(_random == playerAmount){
                    _random = 0;
                }

            }

            for(uint256 l = 0;l < playerAmount - winningAmount;l++){
                 records[cycles[cycle][_random].user].push(Result({
                    value: rewardGWCAmount,
                    cycle:cycle,
                    module:0,
                    time:block.timestamp
                    
                }));
                rewardGWC[cycles[cycle][_random].user] =rewardGWC[cycles[cycle][_random].user].add(rewardGWCAmount);
                _random++;
                if(_random == playerAmount){
                    _random = 0;
                }
            }

            playerIndex = 0;
            cycle ++;
        }
        
    }

    

    function worldBoss() external payable {
        require(startWorldBoss,"not start");
        if(currency == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
            require(msg.value == worldBossPayAmount);
            dataCenter.add(cycle, block.timestamp, worldBossPayAmount, msg.sender, address(0), "boss");
        }else{
            IERC20(currency).safeTransferFrom(msg.sender,address(this),worldBossPayAmount);
            dataCenter.add(cycle, block.timestamp, worldBossPayAmount, msg.sender, address(0), "boss");
        }

        for(uint256 i=0;i<worldBossPlayerIndex;i++){
            require(worldBossCycles[worldBossCycle][i].user != msg.sender,"already join");
        }

        worldBossPlatformReward = worldBossPlatformReward.add(worldBossPayAmount);
        worldBossCycles[worldBossCycle][worldBossPlayerIndex].user = msg.sender;
        worldBossCycles[worldBossCycle][worldBossPlayerIndex].time = block.timestamp;
        worldBossPlayerIndex++;
        if(worldBossPlayerIndex == worldBossPlayerAmount){

            uint256  _random =uint256( keccak256(abi.encodePacked( worldBossCycle, msg.sender,block.timestamp,uint256(blockhash(block.number -1))))) % worldBossPlayerAmount;
                worldBossCycles[worldBossCycle][_random].win = true;
                worldBossrecords[worldBossCycles[worldBossCycle][_random].user].push(Result({
                    value: worldBossCycleReward,
                    cycle:worldBossCycle,
                    module:1,
                    time:block.timestamp
                    
                }));
                worldBossReward[worldBossCycles[worldBossCycle][_random].user] =worldBossReward[worldBossCycles[worldBossCycle][_random].user].add(worldBossCycleReward);
                _random++;
                if(_random == worldBossPlayerAmount){
                    _random = 0;
                }


            for(uint256 l = 0;l < worldBossPlayerAmount - 1;l++){
                 worldBossrecords[worldBossCycles[worldBossCycle][_random].user].push(Result({
                    value: worldBossRewardGWCAmount,
                    cycle:worldBossCycle,
                    module:0,
                    time:block.timestamp
                    
                }));
                worldBossRewardGWC[worldBossCycles[worldBossCycle][_random].user] =worldBossRewardGWC[worldBossCycles[worldBossCycle][_random].user].add(worldBossRewardGWCAmount);
                _random++;
                if(_random == worldBossPlayerAmount){
                    _random = 0;
                }
            }

            worldBossPlayerIndex = 0;
            worldBossCycle ++;
            startWorldBoss = false;
        }
        
    }


function isJoin(address _user)public view returns (bool) {
   
    for(uint256 i=0;i< playerIndex;i++){
        if( cycles[cycle][i].user == _user){
            return true;
        }
    }
    return false;
}

function isJoinBoss(address _user)public view returns (bool) {
   
    for(uint256 i=0;i< worldBossPlayerIndex;i++){
        if( worldBossCycles[worldBossCycle][i].user == _user){
            return true;
        }
    }
    return false;
}

    function setOperator(address _operator) external onlyOwner  {
        require(_operator != address(0),"zero address");
        operator = _operator;
    }

    function setStartWorldBoss() external  {
        require(msg.sender == operator,"not operator");
        startWorldBoss = true;
    }

    function getReward(uint256 _amount) external {
        uint256 amount = reward[msg.sender];
        require(amount >= _amount,"not enough");
        
        reward[msg.sender] = reward[msg.sender].sub(_amount);
        if(currency == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
            msg.sender.transfer(_amount);
        }else{
            IERC20(currency).safeTransfer(msg.sender,_amount);
        }
    }

    function getRewardGWC(uint256 _amount) external {
        uint256 amount = rewardGWC[msg.sender];
        require(amount >= _amount,"not enough");

        rewardGWC[msg.sender] = rewardGWC[msg.sender].sub(_amount);
        GWC.mint(msg.sender,_amount);
    }



    function getWorldBossReward() external {
        uint256 amount = worldBossReward[msg.sender];
        worldBossReward[msg.sender] = 0;
        if(worldBossRewardAddr == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
            msg.sender.transfer(amount);
        }else{
            IERC20(worldBossRewardAddr).safeTransfer(msg.sender,amount);
        }
    }

    function getWorldBossRewardGWC() external {
        uint256 amount = worldBossRewardGWC[msg.sender];
        worldBossRewardGWC[msg.sender] = 0;
        GWC.mint(msg.sender,amount);
    }




    function initSet(
        address _gwc,
        uint _feePct,
        uint256 _playerAmount,
        uint256 _worldBossPlayerAmount,
        uint256 _winningAmount,
        uint256 _payAmount,
        uint256 _worldBossPayAmount,
        address _currency,
        uint256 _rewardGWCAmount,
        uint256 _worldBossRewardGWCAmount,
        uint256 _worldBossCycleReward,
        address _worldBossRewardAddr
        ) external onlyOwner {
        GWC = IGWC(_gwc);
        feePct = _feePct;
        playerAmount = _playerAmount;
        worldBossPlayerAmount = _worldBossPlayerAmount;
        winningAmount= _winningAmount;
        payAmount = _payAmount;
        worldBossPayAmount = _worldBossPayAmount;
        currency = _currency;
        cycle = 1;
        worldBossCycle = 1;
        rewardGWCAmount = _rewardGWCAmount;
        worldBossRewardGWCAmount = _worldBossRewardGWCAmount;
        worldBossCycleReward = _worldBossCycleReward;
        worldBossRewardAddr =_worldBossRewardAddr;
        cycleReward = payAmount.mul(playerAmount).mul(100 - feePct).div(100);
    }

    function getInfo(address _user) public view returns (uint256,uint256,bool,uint256,uint256,  Result[] memory){
        bool isJoinedBoss = isJoinBoss(_user);
        return (playerAmount,playerIndex,isJoinedBoss,reward[_user],rewardGWC[_user],records[_user]);
    }

    function withdraw() external onlyOwner {
        require(lotteryFund >= 0,"not lottery fund");
        if(currency == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
            msg.sender.transfer(lotteryFund);
        }else{
            IERC20(currency).safeTransfer(msg.sender,lotteryFund);
        }
        lotteryFund = 0;
    }


}