/**
 *Submitted for verification at BscScan.com on 2023-03-25
*/

/**
 *Submitted for verification at BscScan.com on 2023-03-19
*/

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
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;


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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;




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





pragma solidity ^0.8.0;



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

interface ISwapRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

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
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface Warp {
    function withdraw() external returns (bool);
}

abstract contract AbcToken is ERC20, Ownable {
    address public fundAddress;
    address public repoAddress;

    mapping(address => bool) private _feeList;
    mapping(address => bool) private _inhibitList;
    mapping(address => bool) private _swapPairList;

    ISwapRouter private _swapRouter;
    Warp private warp;

    bool private inSwap;

    uint256 private constant MAX = ~uint256(0);

    uint256 private _buyBurnFee = 0;
    uint256 private _buyFundFee = 200;
    uint256 private _buyRepoFee = 100;
    uint256 private _buyLPDividendFee = 200;
    uint256 private _sellBurnFee = 0;
    uint256 private _sellFundFee = 200;
    uint256 private _sellRepoFee = 100;
    uint256 private _sellLPDividendFee = 200;
    uint256 private _transferFee;

    uint256 private fundFee;
    uint256 private repoFee;
    uint256 private dividendFee;
    uint256 private initialPrice;

    uint256 private tokensSwapForFund = 140 * 10**18;
    uint256 private tokensSwapForRepo = 100 * 10**18;
    uint256 private tokensSwapForDividend = 80 * 10**18;

    address public mainPair;
    address private baseToken;
    address private deadWallet = 0x000000000000000000000000000000000000dEaD;

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(
        address RouterAddress,
        address BaseToken,
        string memory Name,
        string memory Symbol,
        uint256 Supply,
        address FundAddress,
        address RepoAddress,
        address LPAddress
    ) ERC20(Name, Symbol) {
        baseToken = BaseToken;
        fundAddress = FundAddress;
        repoAddress = RepoAddress;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        _swapRouter = swapRouter;
        _approve(address(this), address(swapRouter), MAX);
        ERC20(BaseToken).approve(address(swapRouter), MAX);

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), BaseToken);
        mainPair = swapPair;
        _swapPairList[swapPair] = true;

        _mint(LPAddress, Supply);

        _feeList[FundAddress] = true;
        _feeList[RepoAddress] = true;
        _feeList[LPAddress] = true;
        _feeList[address(this)] = true;
        _feeList[address(swapRouter)] = true;

        excludeLPHolder[address(0)] = true;
        excludeLPHolder[address(deadWallet)] = true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");
        require(!_inhibitList[from], "inhibitList");
        require(amount > 0, "amountIsZero");

        if (!_feeList[from] && !_feeList[to]) {
            uint256 maxSellAmount = (balance * 9999) / 10000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
        }

        if (initialPrice == 0 && tokenPrice() > 0) {
            initialPrice = tokenPrice();
        }

        bool isAddLdx;
        bool isDelLdx;
        if (_swapPairList[to]) {
            isAddLdx = _checkADDldx();
        }
        if (_swapPairList[from]) {
            isDelLdx = _isDelLiquidityV1();
        }

        bool isSell;
        bool takeSwapFee;
        bool takeTransferFee;

        if (!_feeList[from] && !_feeList[to]) {
            if (_swapPairList[from] || _swapPairList[to]) {
                if (0 == startTradeBlock) {
                    require(
                        0 < startAddLPBlock && _swapPairList[to],
                        "!startAddLP"
                    );
                }

                if (block.number < startTradeBlock + 2) {
                    _funTransfer(from, to, amount);
                    return;
                }

                if (_swapPairList[to]) {
                    if (!inSwap && !isAddLdx) {
                        uint256 tokensSwapFund = calTokensSwap(
                            tokensSwapForFund
                        );
                        uint256 tokensSwapRepo = calTokensSwap(
                            tokensSwapForRepo
                        );
                        uint256 tokensSwapDividend = calTokensSwap(
                            tokensSwapForDividend
                        );

                        if (
                            fundFee >= tokensSwapFund &&
                            balanceOf(address(this)) > tokensSwapFund
                        ) {
                            fundFee = fundFee - tokensSwapFund;
                            swapToken(tokensSwapFund, fundAddress);
                        }
                        if (
                            repoFee >= tokensSwapRepo &&
                            balanceOf(address(this)) > tokensSwapRepo
                        ) {
                            repoFee = repoFee - tokensSwapRepo;
                            swapToken(tokensSwapRepo, repoAddress);
                        }
                        if (
                            dividendFee >= tokensSwapDividend &&
                            balanceOf(address(this)) > tokensSwapDividend
                        ) {
                            dividendFee = dividendFee - tokensSwapDividend;
                            swapToken(tokensSwapDividend, address(warp));
                            warp.withdraw();
                        }
                    }

                    isSell = true;
                }

                takeSwapFee = true;
            } else {
                takeTransferFee = true;
            }
        }

        if (isAddLdx || isDelLdx) {
            takeSwapFee = false;
        }

        _tokenTransfer(from, to, amount, takeSwapFee, isSell, takeTransferFee);

        if (isAddLdx) {
            addLPHolder(from);
        }

        if (from != address(this) && !_feeList[from]) {
            processReward(500000);
        }
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 feeAmount = (tAmount * 75) / 100;
        _takeTransfer(sender, address(this), feeAmount);
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeSwapFee,
        bool isSell,
        bool takeTransferFee
    ) private {
        uint256 feeAmount;

        if (takeSwapFee) {
            if (isSell) {
                uint256 sellFundFee = (tAmount * _sellFundFee) / 10000;
                uint256 sellRepoFee = (tAmount * _sellRepoFee) / 10000;
                uint256 sellDividendFee = (tAmount * _sellLPDividendFee) /
                    10000;
                uint256 sellBurnFee = (tAmount * _sellBurnFee) / 10000;

                if (sellFundFee > 0) {
                    feeAmount += sellFundFee;
                    fundFee += sellFundFee;
                }
                if (sellRepoFee > 0) {
                    feeAmount += sellRepoFee;
                    repoFee += sellRepoFee;
                }
                if (sellDividendFee > 0) {
                    feeAmount += sellDividendFee;
                    dividendFee += sellDividendFee;
                }
                if (feeAmount > 0) {
                    _takeTransfer(sender, address(this), feeAmount);
                }
                if (sellBurnFee > 0) {
                    feeAmount += sellBurnFee;
                    _takeTransfer(sender, deadWallet, sellBurnFee);
                }
            } else {
                uint256 buyFundFee = (tAmount * _buyFundFee) / 10000;
                uint256 buyRepoFee = (tAmount * _buyRepoFee) / 10000;
                uint256 buyDividendFee = (tAmount * _buyLPDividendFee) / 10000;
                uint256 buyBurnFee = (tAmount * _buyBurnFee) / 10000;

                if (buyFundFee > 0) {
                    feeAmount += buyFundFee;
                    fundFee += buyFundFee;
                }
                if (buyRepoFee > 0) {
                    feeAmount += buyRepoFee;
                    repoFee += buyRepoFee;
                }
                if (buyDividendFee > 0) {
                    feeAmount += buyDividendFee;
                    dividendFee += buyDividendFee;
                }
                if (feeAmount > 0) {
                    _takeTransfer(sender, address(this), feeAmount);
                }
                if (buyBurnFee > 0) {
                    feeAmount += buyBurnFee;
                    _takeTransfer(sender, deadWallet, buyBurnFee);
                }
            }
        } else if (takeTransferFee) {
            uint256 transferFee = (tAmount * _transferFee) / 10000;
            if (transferFee > 0) {
                feeAmount += transferFee;
                _takeTransfer(sender, fundAddress, transferFee);
            }
        }

        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function swapToken(uint256 tokenAmount, address to) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = baseToken;

        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            to,
            block.timestamp
        );
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
    ) private {
        super._transfer(sender, to, tAmount);
    }

    uint256 private startTradeBlock;
    uint256 private startAddLPBlock;

    function startAddLP() external onlyOwner {
        require(0 == startAddLPBlock, "startedAddLP");
        startAddLPBlock = block.number;
    }

    function startTrade() external onlyOwner {
        require(0 == startTradeBlock, "trading");
        startTradeBlock = block.number;
    }

    function setBuyBurnFee(uint256 _burnFee) external onlyOwner {
        _buyBurnFee = _burnFee;
    }

    function setBuyRepoFee(uint256 _repoFee) external onlyOwner {
        _buyRepoFee = _repoFee;
    }

    function setBuyFundFee(uint256 _fundFee) external onlyOwner {
        _buyFundFee = _fundFee;
    }

    function setBuyLPDividendFee(uint256 _dividendFee) external onlyOwner {
        _buyLPDividendFee = _dividendFee;
    }

    function setSellBurnFee(uint256 _burnFee) external onlyOwner {
        _sellBurnFee = _burnFee;
    }

    function setSellRepoFee(uint256 _repoFee) external onlyOwner {
        _sellRepoFee = _repoFee;
    }

    function setSellFundFee(uint256 _fundFee) external onlyOwner {
        _sellFundFee = _fundFee;
    }

    function setSellLPDividendFee(uint256 _dividendFee) external onlyOwner {
        _sellLPDividendFee = _dividendFee;
    }

    function setTransferFee(uint256 _transferFeee) external onlyOwner {
        _transferFee = _transferFeee;
    }

    function setSwapWarp(address _warp) external onlyOwner {
        warp = Warp(_warp);
        _feeList[_warp] = true;
    }

    function warpWithdraw() external onlyOwner {
        warp.withdraw();
    }

    function setInhibitList(address account, bool inhibit) external onlyOwner {
        _inhibitList[account] = inhibit;
    }

    function setMultipleInhibitList(address[] calldata accounts, bool inhibit)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < accounts.length; i++) {
            _inhibitList[accounts[i]] = inhibit;
        }
    }

    function setTokensSwapForFund(uint256 tokens) external onlyOwner {
        tokensSwapForFund = tokens;
    }

    function setTokensSwapForRepo(uint256 tokens) external onlyOwner {
        tokensSwapForRepo = tokens;
    }

    function setTokensSwapForDividend(uint256 tokens) external onlyOwner {
        tokensSwapForDividend = tokens;
    }

    function claimBalance() external {
        payable(fundAddress).transfer(address(this).balance);
    }

    receive() external payable {}

    address[] private holders;
    mapping(address => uint256) private holderIndex;
    mapping(address => bool) private excludeLPHolder;

    function addLPHolder(address adr) private {
        uint256 size;
        assembly {
            size := extcodesize(adr)
        }
        if (size > 0) {
            return;
        }
        if (0 == holderIndex[adr]) {
            if (0 == holders.length || holders[0] != adr) {
                holderIndex[adr] = holders.length;
                holders.push(adr);
            }
        }
    }

    uint256 private currentIndex;
    uint256 private holderRewardCondition;
    uint256 private progressRewardBlock;
    uint256 private mimLPForReward;

    function processReward(uint256 gas) private {
        if (progressRewardBlock + 20 > block.number) {
            return;
        }

        ERC20 USDT = ERC20(baseToken);

        uint256 balance = USDT.balanceOf(address(this));
        if (balance < holderRewardCondition) {
            return;
        }

        IERC20 holdToken = IERC20(mainPair);
        uint256 holdTokenTotal = holdToken.totalSupply();

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            tokenBalance = holdToken.balanceOf(shareHolder);
            if (
                tokenBalance > mimLPForReward && !excludeLPHolder[shareHolder]
            ) {
                amount = (balance * tokenBalance) / holdTokenTotal;
                if (amount > 0) {
                    USDT.transfer(shareHolder, amount);
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = block.number;
    }

    function setHolderRewardCondition(uint256 amount) external {
        require(msg.sender == fundAddress || msg.sender == owner());
        holderRewardCondition = amount;
    }

    function setMimLPForReward(uint256 _mimLPForReward) external {
        require(msg.sender == fundAddress || msg.sender == owner());
        mimLPForReward = _mimLPForReward;
    }

    function setExcludeLPHolder(address addr, bool enable) external {
        require(msg.sender == fundAddress || msg.sender == owner());
        excludeLPHolder[addr] = enable;
    }

    function rescueToken(uint256 tokens) external {
        require(msg.sender == fundAddress || msg.sender == owner());
        ERC20(baseToken).transfer(msg.sender, tokens);
    }

    function allHolders() public view returns (address[] memory) {
        return holders;
    }

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    function _checkADDldx() internal view returns (bool ldxAdd) {
        address token0 = IUniswapV2Pair(mainPair).token0();
        address token1 = IUniswapV2Pair(mainPair).token1();
        (uint256 r0, uint256 r1, ) = IUniswapV2Pair(mainPair).getReserves();
        uint256 bal1 = IERC20(token1).balanceOf(mainPair);
        uint256 bal0 = IERC20(token0).balanceOf(mainPair);
        if (token0 == address(this)) {
            if (bal1 > r1) {
                uint256 change1 = bal1 - r1;
                ldxAdd = change1 > 1000;
            }
        } else {
            if (bal0 > r0) {
                uint256 change0 = bal0 - r0;
                ldxAdd = change0 > 1000;
            }
        }
    }

    function _isDelLiquidityV1() internal view returns (bool ldxDel) {
        address token0 = IUniswapV2Pair(mainPair).token0();
        address token1 = IUniswapV2Pair(mainPair).token1();
        (uint256 r0, uint256 r1, ) = IUniswapV2Pair(mainPair).getReserves();
        uint256 bal1 = IERC20(token1).balanceOf(mainPair);
        uint256 bal0 = IERC20(token0).balanceOf(mainPair);
        if (token0 == address(this)) {
            if (bal1 < r1) {
                uint256 change1 = r1 - bal1;
                ldxDel = change1 > 1000;
            }
        } else {
            if (bal0 < r0) {
                uint256 change0 = r0 - bal0;
                ldxDel = change0 > 1000;
            }
        }
    }

    function tokenPrice() public view returns (uint256 price) {
        uint256 tokenOfPair = balanceOf(mainPair);
        uint256 usdtOfPair = ERC20(baseToken).balanceOf(mainPair);

        if (tokenOfPair > 0 && usdtOfPair > 0) {
            price = (10**18 * usdtOfPair) / tokenOfPair;
        }
        return price;
    }

    function calTokensSwap(uint256 tokensSwap) internal view returns (uint256) {
        if (initialPrice == 0) return tokensSwap;

        uint256 multiple = tokenPrice() / initialPrice;
        if (multiple > 1000) {
            return tokensSwap / 8;
        } else if (multiple > 100) {
            return tokensSwap / 4;
        } else if (multiple > 10) {
            return tokensSwap / 2;
        }
        return tokensSwap;
    }
}

contract kyalami is AbcToken {
    constructor()
        AbcToken(
            address(0x10ED43C718714eb63d5aA57B78B54704E256024E), //RouterAddress
            address(0x55d398326f99059fF775485246999027B3197955), //BaseToken
            "kyalami", //Name
            "kyalami", //Symbol
            100000 * 10**18, //Supply
            address(0x9Bc73A2fAf568E143C0Cd1834F246844d009D9b1), //FundAddress
            address(0xEA893BC43428Ac1eD0a918ee79c43450e5262869), //RepoAddress
            address(0x5B5D08c70649d3172b2dBB083bdcE5bB81461634) //LPAddress
        )
    {}
}