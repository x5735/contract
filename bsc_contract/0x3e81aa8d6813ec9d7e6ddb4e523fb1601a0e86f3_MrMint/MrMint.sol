/**
 *Submitted for verification at BscScan.com on 2023-03-30
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

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
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address _owner,
        address spender
    ) external view returns (uint256);

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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

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
    constructor() {}

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
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
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

contract MrMint is IBEP20, Context, ReentrancyGuard {
    using SafeMath for uint256;

    event SetLiquidityFeeWallet(address indexed liquidityFeeWallet);
    event ExcludeFromFee(address indexed account);
    event IncludeInFee(address indexed account);
    event WithdrawAmount(
        address indexed sender,
        address indexed recipient,
        uint256 amount
    );
    event TransferAnyBSC20Token(
        address indexed sender,
        address indexed recipient,
        uint256 tokens
    );

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;

    uint256 private _totalSupply;
    uint8 private _decimals;
    string private _symbol;
    string private _name;

    address public liquidityFeeWallet = 0x5ff1500A7bc0cd1D71786B2b2d918457490590c8;

    uint256 public constant liquidityFeePercent = 0.5 * 10 ** 2; // 0.5% Percent of liquidity fee;
    uint256 public constant burnFeePercent = 0.5 * 10 ** 2; // 0.5% Percent of burn fee;

    //multi-signature-wallet
    address multiSigWallet;
    modifier onlyMultiSigWallet() {
        require(msg.sender == multiSigWallet, "Unauthorized Access");
        _;
    }

    constructor(address _multisigWallet) {
        _name = "Mr Mint";
        _symbol = "MNT";
        _decimals = 18;
        _totalSupply = 1000000000 * (10 ** 18);
        //excluded from fee
        _isExcludedFromFee[msg.sender] = true;
        _isExcludedFromFee[address(this)] = true;
        //assign multi sig wallet
        multiSigWallet = _multisigWallet;

        //Tokenomics
        _balances[0x705E7327aa1aea2e3C764A4eb729E3FfC178fC10] = _totalSupply.mul(5).div(100); // Private Sale	5%
        _balances[0xFDd0DC763506aFa61C142d8dA38Ee5bd83291f83] = _totalSupply.mul(15).div(100); // Pre Sale	15%
        _balances[0x91C473a8043E6768Bf9EeF16567AC69f51FA8690] = _totalSupply.mul(20).div(100); // Public Sale	20%
        _balances[0x194A607b0B02f5Edd9003107B56D31153243d70B] = _totalSupply.mul(10).div(100); // Marketing	10%
        _balances[0xd33784b93645fcf49185EDB152996AcFbc73C3d9] = _totalSupply.mul(2).div(100); // Referral       2%
        _balances[0x2f1e572E81B53C68E58f11dA30A93Ec088d6A403] = _totalSupply.mul(1).div(100); // R & D	        1%
        _balances[0x1E03A67fcdEd78f978668efe7468e2EA4587aE75] = _totalSupply.mul(1).div(100); // Airdrop	1%
        _balances[0x87dDDECB5682531d851CF1e9d1160b81dF7414f4] = _totalSupply.mul(12).div(100); // Liquidity&Staking 12%
        _balances[0x2DEB1Df7c5419E931A25CF2A88AEd20a72a0Ba6C] = _totalSupply.mul(7).div(100); // Ecosystem	7%
        _balances[0x0d254bf545F5733E8F37a0C392be7B328c725Db6] = _totalSupply.mul(4).div(100); // Reserve	4%
        _balances[0x09AD1287D3BcF930bAff65Edf4E0460EdD512b9d] = _totalSupply.mul(18).div(100); // Team	        18%
        _balances[0x3181c8ce50B01A90a49056E09DA1bb027dc8BCed] = _totalSupply.mul(1).div(100); // Charity	1%
        _balances[0xe5910d8B764fa1d9e903cBE78552b556aF6B19Be] = _totalSupply.mul(4).div(100); // Advisors	4%
        
        emit Transfer(address(0),0x705E7327aa1aea2e3C764A4eb729E3FfC178fC10,_totalSupply.mul(5).div(100));
        emit Transfer(address(0),0xFDd0DC763506aFa61C142d8dA38Ee5bd83291f83,_totalSupply.mul(15).div(100));
        emit Transfer(address(0),0x91C473a8043E6768Bf9EeF16567AC69f51FA8690,_totalSupply.mul(20).div(100));
        emit Transfer(address(0),0x194A607b0B02f5Edd9003107B56D31153243d70B,_totalSupply.mul(10).div(100));
        emit Transfer(address(0),0xd33784b93645fcf49185EDB152996AcFbc73C3d9,_totalSupply.mul(2).div(100));
        emit Transfer(address(0),0x2f1e572E81B53C68E58f11dA30A93Ec088d6A403,_totalSupply.mul(1).div(100));
        emit Transfer(address(0),0x1E03A67fcdEd78f978668efe7468e2EA4587aE75,_totalSupply.mul(1).div(100));
        emit Transfer(address(0),0x87dDDECB5682531d851CF1e9d1160b81dF7414f4,_totalSupply.mul(12).div(100));
        emit Transfer(address(0),0x2DEB1Df7c5419E931A25CF2A88AEd20a72a0Ba6C,_totalSupply.mul(7).div(100));
        emit Transfer(address(0),0x0d254bf545F5733E8F37a0C392be7B328c725Db6,_totalSupply.mul(4).div(100));
        emit Transfer(address(0),0x09AD1287D3BcF930bAff65Edf4E0460EdD512b9d,_totalSupply.mul(18).div(100));
        emit Transfer(address(0),0x3181c8ce50B01A90a49056E09DA1bb027dc8BCed,_totalSupply.mul(1).div(100));
        emit Transfer(address(0),0xe5910d8B764fa1d9e903cBE78552b556aF6B19Be,_totalSupply.mul(4).div(100));
    }

    receive() external payable {}

    /**
     * @notice get exclude From Fee
     * @param account address
     **/
    function getExcludeFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    /**
     * @notice Set Liquidity Fee Wallet
     * @param _liquidityFeeWallet address
     **/
    function setLiquidityFeeWallet(
        address _liquidityFeeWallet
    ) public onlyMultiSigWallet {
        require(_liquidityFeeWallet != address(0), "Zero address not allowed");
        liquidityFeeWallet = _liquidityFeeWallet;
        emit SetLiquidityFeeWallet(_liquidityFeeWallet);
    }

    /**
     * @notice exclude From Fee
     * @param account address
     **/
    function excludeFromFee(address account) public onlyMultiSigWallet {
        _isExcludedFromFee[account] = true;
        emit ExcludeFromFee(account);
    }

    /**
     * @notice include In Fee
     * @param account address
     **/
    function includeInFee(address account) public onlyMultiSigWallet {
        _isExcludedFromFee[account] = false;
        emit IncludeInFee(account);
    }

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the token name.
     */
    function name() external view override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {BEP20-totalSupply}.
     */
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {BEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {BEP20-allowance}.
     */
    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {BEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {BEP20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {BEP20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "BEP20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "BEP20: decreased allowance below zero"
            )
        );
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(
            amount,
            "BEP20: transfer amount exceeds balance"
        );

        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[sender]) {
            takeFee = false;
        }

        if (!takeFee) {
            //excluded from fee
            _balances[recipient] = _balances[recipient].add(amount);
            emit Transfer(sender, recipient, amount);
        } else {
            //take liquidity fee
            uint256 liquidityFee = amount.mul(liquidityFeePercent).div(10000);
            _balances[liquidityFeeWallet] = _balances[liquidityFeeWallet].add(
                liquidityFee
            );

            //take burn fee
            uint256 burnFee = amount.mul(burnFeePercent).div(10000);
            _totalSupply = _totalSupply.sub(burnFee);

            //_balances[admin] = _balances[admin].add(fee);
            uint256 totalFee = liquidityFee + burnFee;
            _balances[recipient] = _balances[recipient].add(amount - totalFee);

            //emit Transfer(sender, admin, fee);
            emit Transfer(sender, recipient, amount - totalFee);
            emit Transfer(sender, liquidityFeeWallet, liquidityFee);
            emit Transfer(sender, address(0), burnFee);
        }
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");

        _balances[account] = _balances[account].sub(
            amount,
            "BEP20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /*
     @dev function to burn token
     @param _amount uint256
    */
    function burn(uint256 _amount) public {
        _burn(msg.sender, _amount);
    }

    /*
     @dev function to withdraw BNB
     @param recipient address
     @param amount uint256
    */
    function withdraw(
        address recipient,
        uint256 amount
    ) external onlyMultiSigWallet {
        sendValue(recipient, amount);
        emit WithdrawAmount(address(this), recipient, amount);
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
     */
    function sendValue(address recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = payable(recipient).call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /* 
     @dev function to transfer any BEP20 token
     @param tokenAddress token contract address
     @param tokens amount of tokens
     @return success boolean status
    */
    function transferAnyBSC20Token(
        address tokenAddress,
        address wallet,
        uint256 tokens
    ) public onlyMultiSigWallet returns (bool success) {
        success = IBEP20(tokenAddress).transfer(wallet, tokens);
        require(success, "BEP20 transfer failed");
        emit TransferAnyBSC20Token(address(this), wallet, tokens);
    }

    // Below functions to get signature for multisig operations

    function getSignatureForSetLiquidityFeeWallet(
        address account
    ) public pure returns (bytes memory) {
        return
            abi.encodeWithSignature("setLiquidityFeeWallet(address)", account);
    }

    function getSignatureForExcludeFromFee(
        address account
    ) public pure returns (bytes memory) {
        return abi.encodeWithSignature("excludeFromFee(address)", account);
    }

    function getSignatureForIncludeInFee(
        address account
    ) public pure returns (bytes memory) {
        return abi.encodeWithSignature("includeInFee(address)", account);
    }

    function getSignatureForWithdraw(
        address recipient,
        uint256 amount
    ) public pure returns (bytes memory) {
        return
            abi.encodeWithSignature(
                "withdraw(address,uint256)",
                recipient,
                amount
            );
    }

    function getSignatureForTransferAnyBSC20Token(
        address tokenAddress,
        address wallet,
        uint256 tokens
    ) public pure returns (bytes memory) {
        return
            abi.encodeWithSignature(
                "transferAnyBSC20Token(address,address,uint256)",
                tokenAddress,
                wallet,
                tokens
            );
    }
}