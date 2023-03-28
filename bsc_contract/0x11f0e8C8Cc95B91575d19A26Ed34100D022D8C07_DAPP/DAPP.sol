/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

interface IERC20 {
  function transfer(address recipient, uint256 amount) external returns (bool);
  function balanceOf(address account) external view returns (uint256);
  function decimals() external view returns (uint8);
  function symbol() external view returns (string memory);
  function allowance(address _owner, address spender) external view returns (uint256);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal pure virtual returns (bytes calldata) {
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
 * `onlyOwner`, which can be applied to your functionas to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() public {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
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
   */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

contract DAPP is Ownable {
    using SafeMath for uint256;
    mapping(address => mapping(address => uint256)) private p_principal;
    mapping(address => mapping(address => uint256)) private p_dynamic;
    mapping(address => mapping(address => uint256)) private p_static;
    mapping(address => uint256) private p_all;
    mapping(address => uint256) private principal_total;
    mapping(address => uint256) private dynamic_total;
    mapping(address => uint256) private static_total;
    mapping(address => uint256) private principal_picked;
    mapping(address => uint256) private dynamic_picked;
    mapping(address => uint256) private static_picked;

    event E(address indexed _token, uint256 _type, uint256 _amount);

    function info(address token) public view returns(
        string memory symbol,
        uint8 decimals,
        bool is_owner,
        uint256[] memory data,
        uint256[] memory total,
        uint256[] memory picked
    ){
        symbol = IERC20(token).symbol();
        decimals = IERC20(token).decimals();
        is_owner = owner() == tx.origin;
        data = new uint256[](7);
        data[0] = IERC20(token).allowance(tx.origin, address(this));
        data[1] = IERC20(token).balanceOf(tx.origin);
        data[2] = IERC20(token).balanceOf(address(this));
        data[3] = p_principal[tx.origin][token];
        data[4] = p_dynamic[tx.origin][token];
        data[5] = p_static[tx.origin][token];
        total = new uint256[](3);
        picked = new uint256[](3);
        if(is_owner){
            data[6] = p_all[token];
            total[0] = principal_total[token];
            total[1] = dynamic_total[token];
            total[2] = static_total[token];
            picked[0] = principal_picked[token];
            picked[1] = dynamic_picked[token];
            picked[2] = static_picked[token];
        }
    }

    function set_p(
        address token,
        address[] memory addresses,
        uint256[] memory _principal,
        uint256[] memory _dynamic,
        uint256[] memory _static
    ) public onlyOwner {
        uint256 amount = 0;
        uint256 total1 = 0;
        uint256 total2 = 0;
        uint256 total3 = 0;
        for(uint256 i = 0; i < addresses.length; i++){
            p_principal[addresses[i]][token] = p_principal[addresses[i]][token].add(_principal[i]);
            p_dynamic[addresses[i]][token] = p_dynamic[addresses[i]][token].add(_dynamic[i]);
            p_static[addresses[i]][token] = p_static[addresses[i]][token].add(_static[i]);
            amount += _principal[i] + _dynamic[i] + _static[i];
            total1 += _principal[i];
            total2 += _dynamic[i];
            total3 += _static[i];
        }
        p_all[token] = p_all[token].add(amount);
        principal_total[token] = principal_total[token].add(total1);
        dynamic_total[token] = dynamic_total[token].add(total2);
        static_total[token] = static_total[token].add(total3);
    }

    function claim_owner(address token) public onlyOwner{
        IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
    }

    function invest(address token, uint256 amount) public {
        if(p_principal[tx.origin][token] >= amount){
            p_principal[tx.origin][token] = p_principal[tx.origin][token].sub(amount);
            p_all[token] = p_all[token].sub(amount);
            principal_picked[token] = principal_picked[token].add(amount);
            emit E(tx.origin, 1, amount);
        }else{
            IERC20(token).transferFrom(tx.origin, address(this), amount);
            emit E(tx.origin, 2, amount);
        }
    }
    
    function claim_user_principal(address token) public {
        uint256 amount = p_principal[tx.origin][token];
        require(amount > 0, "There are no bonuses to be claimed");
        IERC20(token).transfer(tx.origin, amount);
        p_principal[tx.origin][token] = 0;
        p_all[token] = p_all[token].sub(amount);
        principal_picked[token] = principal_picked[token].add(amount);
        emit E(tx.origin, 3, amount);
    }

    function claim_user_dynamic_static(address token) public {
        uint256 amount = p_dynamic[tx.origin][token] + p_static[tx.origin][token];
        require(amount > 0, "There are no bonuses to be claimed");
        IERC20(token).transfer(tx.origin, amount);
        dynamic_picked[token] = dynamic_picked[token].add(p_dynamic[tx.origin][token]);
        static_picked[token] = static_picked[token].add(p_static[tx.origin][token]);
        p_dynamic[tx.origin][token] = 0;
        p_static[tx.origin][token] = 0;
        p_all[token] = p_all[token].sub(amount);
        emit E(tx.origin, 4, amount);
    }
}