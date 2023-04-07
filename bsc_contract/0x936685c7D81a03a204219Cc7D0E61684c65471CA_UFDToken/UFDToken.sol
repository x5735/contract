/**
 *Submitted for verification at BscScan.com on 2023-03-31
*/

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

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

pragma solidity ^0.8.0;

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

pragma solidity ^0.8.0;

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

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

pragma solidity ^0.8.0;

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

pragma solidity ^0.8.0;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

pragma solidity ^0.8.0;

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

pragma solidity ^0.8.0;

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

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

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

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

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
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
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

pragma solidity ~0.8.6;

struct AccountRatio {
    address account;
    uint256 ratio;
}

abstract contract TradeFeeableToken is Ownable, ERC20 {
    uint256 public constant PRECISION = 1000;

    mapping(address => bool) internal dexPairs;
    mapping(address => bool) internal feeWhites;

    AccountRatio[] private _buyFeeTargets;
    AccountRatio[] private _sellFeeTargets;
    AccountRatio[] private _transferFeeTargets;

    event TradePairSet(address indexed caller, address indexed account, bool isPair);
    event FeeWhiteSet(address indexed caller, address indexed account, bool isWhite);
    event FeeTargetsSet(address indexed caller);

    function _transfer(address from, address to, uint256 amount) internal virtual override {
        require(from != address(0), "Transfer: from is zero");
        require(to != address(0), "Transfer: to is zero");
        super._transfer(from, to, (amount - _feeFilter(from, to, amount)));
    }

    function _feeFilter(address from, address to, uint256 amount) internal returns (uint256) {
        if (isInFeeWhites(from) || isInFeeWhites(to)) {
            return 0;
        }

        if (dexPairs[from]) {
            return _feeTo(amount, from, _buyFeeTargets);
        }

        if (dexPairs[to]) {
            return _feeTo(amount, from, _sellFeeTargets);
        }

        return _feeTo(amount, from, _transferFeeTargets);
    }

    function _feeTo(uint256 transferAmount, address feeFrom, AccountRatio[] memory targets) internal returns (uint256 used) {
        if (transferAmount == 0 || feeFrom == address(0) || targets.length == 0) {
            return 0;
        }

        for (uint256 i = 0; i < targets.length; i++) {
            address account = targets[i].account;
            uint256 ratio = targets[i].ratio;
            uint256 amount = (transferAmount * ratio) / PRECISION;

            if (account == address(0) || amount == 0) {
                continue;
            }

            used += amount;
            super._transfer(feeFrom, account, amount);
        }
    }

    function setTradePair(address tokenA, address tokenB, address router, bool isPair) external onlyOwner {
        address factory = IUniswapV2Router02(router).factory();
        address pair = IUniswapV2Factory(factory).getPair(tokenA, tokenB);
        setTradePair(pair, isPair);
    }

    function setTradePair(address pair, bool isPair) public onlyOwner {
        require(pair != address(0), "TOKEN: pair zero");
        dexPairs[pair] = isPair;

        emit TradePairSet(_msgSender(), pair, isPair);
    }

    function isInFeeWhites(address account) public view returns (bool) {
        return feeWhites[account];
    }

    function setFeeWhites(address account, bool state) public onlyOwner {
        feeWhites[account] = state;

        emit FeeWhiteSet(_msgSender(), account, state);
    }

    function batchSetFeeWhites(address[] calldata accounts, bool state) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            feeWhites[accounts[i]] = state;

            emit FeeWhiteSet(_msgSender(), accounts[i], state);
        }
    }

    function batchSetFeeWhites(address[] calldata accounts, bool[] memory states) external onlyOwner {
        require(accounts.length == states.length, "TOKEN: length not same");

        for (uint256 i = 0; i < accounts.length; i++) {
            feeWhites[accounts[i]] = states[i];

            emit FeeWhiteSet(_msgSender(), accounts[i], states[i]);
        }
    }

    function isDexPair(address pair) external view returns (bool) {
        return dexPairs[pair];
    }

    function getBuyFeeTargets(uint256 start, uint256 end) external view returns (AccountRatio[] memory) {
        return _getFeeRatios(_buyFeeTargets, start, end);
    }

    function getBuyFeeTargetsLength() external view returns (uint256) {
        return _buyFeeTargets.length;
    }

    function setBuyFeeTargets(AccountRatio[] memory targets) public onlyOwner {
        _setFeeRatios(targets, _buyFeeTargets);
    }

    function getSellFeeTargets(uint256 start, uint256 end) external view returns (AccountRatio[] memory) {
        return _getFeeRatios(_sellFeeTargets, start, end);
    }

    function getSellFeeTargetsLength() external view returns (uint256) {
        return _sellFeeTargets.length;
    }

    function setSellFeeTargets(AccountRatio[] memory targets) public onlyOwner {
        _setFeeRatios(targets, _sellFeeTargets);
    }

    function getTransferFeeTargets(uint256 start, uint256 end) external view returns (AccountRatio[] memory) {
        return _getFeeRatios(_transferFeeTargets, start, end);
    }

    function getTransferFeeTargetsLength() external view returns (uint256) {
        return _transferFeeTargets.length;
    }

    function setTransferFeeTargets(AccountRatio[] memory targets) public onlyOwner {
        _setFeeRatios(targets, _transferFeeTargets);
    }

    function _getFeeRatios(
        AccountRatio[] storage source,
        uint256 start,
        uint256 end
    ) internal view returns (AccountRatio[] memory) {
        require(end > start, "TOKEN: end smaller than start");
        require(end <= source.length, "TOKEN: array out of bounds");

        AccountRatio[] memory targets = new AccountRatio[](end - start + 1);
        for (uint256 i = 0; i < (end - start + 1); i++) {
            targets[i] = source[start + i];
        }
        return targets;
    }

    function _setFeeRatios(AccountRatio[] memory source, AccountRatio[] storage target) internal onlyOwner {
        require(target.length <= 5, "TOKEN: fee target too more");

        if (target.length > 0) {
            uint256 targetLength = target.length;
            for (uint256 i = 0; i < targetLength; i++) {
                target.pop();
            }
        }

        if (source.length > 0) {
            for (uint256 i = 0; i < source.length; i++) {
                require(source[i].ratio <= 100, "TOKEN: fee too high");
                target.push(source[i]);
            }
        }

        emit FeeTargetsSet(_msgSender());
    }
}

pragma solidity ~0.8.6;

contract UFDToken is Ownable, TradeFeeableToken {
    constructor(
        address mintOnwer,
        address mintLp,
        address mintAgg,
        address mintTech,
        address mintCommunity,
        address mintWeb3
    ) ERC20("UFD", "UFD") {
        _mint(mintOnwer, 13 * 10000 * 1e18);
        _mint(mintLp, 15 * 10000 * 1e18);
        _mint(mintAgg, 40 * 10000 * 1e18);
        _mint(mintTech, 5 * 10000 * 1e18);
        _mint(mintCommunity, 2 * 10000 * 1e18);
        _mint(mintWeb3, 25 * 10000 * 1e18);

        setFeeWhites(mintOnwer, true);
        setFeeWhites(mintLp, true);
        setFeeWhites(mintAgg, true);
        setFeeWhites(mintTech, true);
        setFeeWhites(mintCommunity, true);
        setFeeWhites(mintWeb3, true);
    }
}