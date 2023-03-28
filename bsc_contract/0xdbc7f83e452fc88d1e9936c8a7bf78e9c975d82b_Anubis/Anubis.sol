/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

/**
 *Submitted for verification at BscScan.com on 2022-11-13
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

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

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
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

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
   
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
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
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        _transfer(sender, recipient, amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

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

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

contract Anubis is ERC20, Ownable {
    using Address for address payable;

    IUniswapV2Router02 public uniswapV2Router;
    IUniswapV2Pair public  uniswapV2Pair;

    uint256 public makeOfferTime = type(uint256).max;

    mapping (address => bool) private _isExcludedFromFees;

    address public  marketingWallet;
    address public  fomoWallet;
    address public  buyBackAnWallet;
    address public  dividendWallet;

    uint256 public  marketingFeeOnBuySell;
    uint256 public  fomoFeeOnBuySell;
    uint256 public  buyBackAnFeeOnBuySell;
    uint256 public  dividendFeeOnBuySell;
    uint256 public  walletToWalletTransferFee; // Usually all handling charges

    uint256 public  totalFeesOnBuySell;

    uint256 private maxFee;

    uint256 public  swapTokensAtAmount;
    bool    private swapping;

    event ExcludeFromFees(address indexed account, bool isExcluded);

    event MarketingWalletChanged(address marketingWallet);
    event fomoWalletChanged(address fomoWallet);
    event BuyBackAnWalletChanged(address buyBackAnWallet);
    event DividendWalletChanged(address dividendWallet);

    event MakeOfferTime(uint256 makeOfferTime);
    
    event UpdateBuySellFees(uint256 marketingFeeOnBuySell, 
        uint256 fomoFeeOnBuySell, 
        uint256 buyBackAnFeeOnBuySell,
        uint256 dividendFeeOnBuySell);
    event UpdateWalletToWalletTransferFee(uint256 walletToWalletTransferFee);

    event SwapAll(uint256 amountETH);
    event SendEth(address recv, uint256 amountETH);

    event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
    event DividendTrigger(address dividendWallet, uint256 ethNumber);
    event MarketingTrigger(address marketingWallet, uint256 sendNum);
    event RecordCall(bool state);
    event DividendCall(bool state);
    event MarketingCall(bool state);

    constructor (string memory name_, 
        string memory symbol_, 
        uint256 totalSupply_, 
        uint256 marketingFeeOnBuySell_,
        uint256 fomoFeeOnBuySell_,
        uint256 buyBackAnFeeOnBuySell_,
        uint256 dividendFeeOnBuySell_,
        uint256 walletToWalletTransferFee_
    ) ERC20(name_, symbol_) {
        address router;
        if (block.chainid == 56) {
            router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
        } else if (block.chainid == 97) {
            router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
        } else if (block.chainid == 1) {
            router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet
        } else if (block.chainid == 5) {
            router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Testnet
        } else {
            revert();
        }
        
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Pair(_uniswapV2Pair);

        maxFee = 25;

        marketingFeeOnBuySell = marketingFeeOnBuySell_;
        fomoFeeOnBuySell = fomoFeeOnBuySell_;
        buyBackAnFeeOnBuySell = buyBackAnFeeOnBuySell_;
        dividendFeeOnBuySell = dividendFeeOnBuySell_;

        totalFeesOnBuySell = marketingFeeOnBuySell + 
            fomoFeeOnBuySell + 
            buyBackAnFeeOnBuySell +
            dividendFeeOnBuySell;

        walletToWalletTransferFee = walletToWalletTransferFee_;

        marketingWallet = address(this);
        fomoWallet = address(this);

        require(totalFeesOnBuySell <= maxFee, "Total Fees cannot exceed the maximum");
        require(walletToWalletTransferFee <= maxFee, "Wallet to Wallet Transfer Fee cannot exceed the maximum");

        _isExcludedFromFees[owner()] = true;
        _isExcludedFromFees[address(0xdead)] = true;
        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[marketingWallet] = true;
        _isExcludedFromFees[fomoWallet] = true;

        _mint(owner(), totalSupply_ * (10 ** decimals()));
        swapTokensAtAmount = totalSupply() / 5_000;
    }

    receive() external payable {

  	}

    function claimStuckTokens(address token) external onlyOwner {
        if (token == address(0x0)) {
            payable(msg.sender).sendValue(address(this).balance);
            return;
        }
        IERC20 ERC20token = IERC20(token);
        uint256 balance = ERC20token.balanceOf(address(this));
        ERC20token.transfer(msg.sender, balance);
    }

    // FEE SYSTEM
    function excludeFromFees(address account, bool excluded) external onlyOwner{
        require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);
    }

    function isExcludedFromFees(address account) public view returns(bool) {
        return _isExcludedFromFees[account];
    }

    function closeFees(bool marketing, 
        bool fomo, bool buyBackAn, bool dividend,
        bool walletToWallet) external onlyOwner {
        require(marketing || 
            fomo || buyBackAn || 
            dividend || walletToWallet, "At least one true input is required");

        if (marketing) {
            require(marketingFeeOnBuySell != 0, "marketingFeeOnBuySell is zero");
            marketingFeeOnBuySell = 0;
        }

        if (fomo) {
            require(fomoFeeOnBuySell != 0, "fomoFeeOnBuySell is zero");
            fomoFeeOnBuySell = 0;
        }

        if (buyBackAn) {
            require(buyBackAnFeeOnBuySell != 0, "buyBackAnFeeOnBuySell is zero");
            buyBackAnFeeOnBuySell = 0;
        }

        if (dividend) {
            require(dividendFeeOnBuySell != 0, "dividendFeeOnBuySell is zero");
            dividendFeeOnBuySell = 0;
        }

        totalFeesOnBuySell = marketingFeeOnBuySell + 
            fomoFeeOnBuySell + 
            buyBackAnFeeOnBuySell +
            dividendFeeOnBuySell;

        if (walletToWallet) {
            require(walletToWalletTransferFee != 0, "walletToWalletTransferFee is zero");
            walletToWalletTransferFee = 0;
        }

        if (walletToWalletTransferFee > totalFeesOnBuySell) {
            walletToWalletTransferFee = totalFeesOnBuySell;
        }

        emit UpdateBuySellFees(marketingFeeOnBuySell, 
            fomoFeeOnBuySell, 
            buyBackAnFeeOnBuySell,
            dividendFeeOnBuySell);
        emit UpdateWalletToWalletTransferFee(walletToWalletTransferFee);
    }

    function setMakeOfferTime(uint256 time_) external onlyOwner{
        require(makeOfferTime >= block.timestamp, "Have started trading");
        makeOfferTime = time_;

        emit MakeOfferTime(makeOfferTime);
    }

    function changeMarketingWallet(address marketingWallet_) external onlyOwner{
        require(marketingWallet_ != marketingWallet,"Marketing wallet is already that address");
        require(marketingWallet_ != address(0),"Marketing wallet cannot be the zero address");
        marketingWallet = marketingWallet_;

        emit MarketingWalletChanged(marketingWallet);
    }

    function changefomoWallet(address fomoWallet_) external onlyOwner{
        require(fomoWallet_ != fomoWallet,"Fomo wallet is already that address");
        require(fomoWallet_ != address(0),"Fomo wallet cannot be the zero address");
        fomoWallet = fomoWallet_;

        emit fomoWalletChanged(fomoWallet);
    }

    function changeBuyBackAnWallet(address buyBackAnWallet_) external onlyOwner{
        require(buyBackAnWallet_ != buyBackAnWallet,"BuyBackAn wallet is already that address");
        require(buyBackAnWallet_ != address(0),"BuyBackAn wallet cannot be the zero address");
        buyBackAnWallet = buyBackAnWallet_;

        emit BuyBackAnWalletChanged(buyBackAnWallet);
    }

    function changeDividendWallet(address dividendWallet_) external onlyOwner{
        require(dividendWallet_ != dividendWallet,"Dividend wallet is already that address");
        require(dividendWallet_ != address(0),"Dividend wallet cannot be the zero address");
        dividendWallet = dividendWallet_;

        emit DividendWalletChanged(dividendWallet);
    }
    
    // TRANSFER SYSTEM

    function _transfer(address from,address to,uint256 amount) internal  override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
       
        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;
        bool isOpenTrade = (block.timestamp > makeOfferTime);
        bool success;

        if (canSwap &&
            !swapping &&
            to == address(uniswapV2Pair) &&
            totalFeesOnBuySell > 0 &&
            totalFeesOnBuySell == (marketingFeeOnBuySell + 
                fomoFeeOnBuySell + 
                buyBackAnFeeOnBuySell + 
                dividendFeeOnBuySell)
        ) {
            swapping = true;

            _approve(address(this), address(uniswapV2Router), type(uint256).max);
            uint256 otherETH = swapAll();
            uint256 allocETH = otherETH * 9 / 10;
            uint256 sendNum;

            if (marketingFeeOnBuySell > 0) {
                sendNum = (otherETH - allocETH) + (allocETH * marketingFeeOnBuySell / totalFeesOnBuySell);
                // marketing recvEth() function Hash
                (success, ) = marketingWallet.call{value: sendNum}(abi.encodeWithSelector(0x20910d48));
                if (success) {
                    emit MarketingTrigger(marketingWallet, sendNum);
                } else {
                    emit MarketingTrigger(address(0x0), 0);
                }
            }
            
            if (fomoFeeOnBuySell > 0) {
                sendNum = allocETH * fomoFeeOnBuySell / totalFeesOnBuySell;
                sendEth(fomoWallet, sendNum);
            }

            if (buyBackAnFeeOnBuySell > 0) {
                sendNum = allocETH * buyBackAnFeeOnBuySell / totalFeesOnBuySell;
                sendEth(buyBackAnWallet, sendNum);
            }

            if (dividendFeeOnBuySell > 0) {
                sendNum = allocETH * dividendFeeOnBuySell / totalFeesOnBuySell;
                // dividend recvEth() function Hash
                (success, ) = dividendWallet.call{value: sendNum}(abi.encodeWithSelector(0x20910d48));
                if (success) {
                    emit DividendTrigger(dividendWallet, sendNum);
                } else {
                    emit DividendTrigger(address(0x0), 0);
                }
            }

            swapping = false;
        }

        if (from == address(uniswapV2Pair)) {
            // fomo wallet recordInfo(address buyer_, uint256 num_) function Hash
            (success, ) = fomoWallet.call(abi.encodeWithSelector(0x2e916d55, to, getBuyEthNum())); // (0x2e916d55, to, amount)
            emit RecordCall(success);
        }
        // dividend allocEth() function Hash
        (success, ) = dividendWallet.call(abi.encodeWithSelector(0xc2c2b565));
        emit DividendCall(success);
        // marketing allocEth() function Hash
        (success, ) = marketingWallet.call(abi.encodeWithSelector(0xc2c2b565));
        emit MarketingCall(success);

        uint256 _totalFees;
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
            _totalFees = 0;
        } else if (from == address(uniswapV2Pair) || to == address(uniswapV2Pair)) {
            require(isOpenTrade, "isOpenTrade is false");
            _totalFees = totalFeesOnBuySell;
        } else {
            _totalFees = walletToWalletTransferFee;
        }

        if (_totalFees > 0) {
            uint256 fees = (amount * _totalFees) / 100;
            amount = amount - fees;
            super._transfer(from, address(this), fees);
        }

        super._transfer(from, to, amount);
    }

    // SWAP SYSTEM
    function getBuyEthNum() private view returns (uint256 buyEthNum) {
        if(uniswapV2Pair.token0() == uniswapV2Router.WETH()) {
            (buyEthNum, , ) = uniswapV2Pair.getReserves(); // 0: token, 1: bnb
        } else {
            (, buyEthNum, ) = uniswapV2Pair.getReserves();
        }

        uint256 nowEthNum = (IERC20(uniswapV2Router.WETH())).balanceOf(address(uniswapV2Pair));
        if (nowEthNum >= buyEthNum) {
            buyEthNum = nowEthNum - buyEthNum;
        } else {
            buyEthNum = 0;
        }
    }

    function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
        require(newAmount > totalSupply() / 1_000_000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
        swapTokensAtAmount = newAmount;

        emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
    }

    function swapAll() private returns (uint256 amountETH) {
        uint256 initialBalance = address(this).balance;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            IERC20(this).balanceOf(address(this)),
            0,
            path,
            address(this),
            block.timestamp);

        amountETH = address(this).balance - initialBalance;

        emit SwapAll(amountETH);
    }

    function sendEth(address recv, uint256 amountETH) private {
        payable(recv).sendValue(amountETH);
        emit SendEth(recv, amountETH);
    }
}