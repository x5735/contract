/**
 *Submitted for verification at BscScan.com on 2023-03-30
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

interface IBEP20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IBEP20Metadata is IBEP20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
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

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract BEP20 is Context, IBEP20, IBEP20Metadata {
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

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
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
            require(
                currentAllowance >= amount,
                "BEP20: transfer amount exceeds allowance"
            );
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        _transfer(sender, recipient, amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "BEP20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function burn(uint256 amount) public virtual returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "BEP20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    //Called only once during token creation to create the token supply
    function _createSupply(address account, uint256 amount) internal virtual {
        require(account != address(0), "BEP20: token to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "BEP20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "BEP20: burn amount exceeds balance");
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
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

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

interface IUniswapV2Factory {

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
        
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
        
}

interface IUniswapV2Router02 is IUniswapV2Router01 {

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

}

contract AIoxus is BEP20, Ownable {

    uint256 private _totalFeesOnBuy = 3;
    uint256 private _totalFeesOnSell = 9;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    address private DEAD = 0x000000000000000000000000000000000000dEaD;

    address private USDTAddress = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;

    address public operator;

    bool private taxDisable = false;

    mapping (address => bool) private _isBlacklisted;
    bool private blacklistDisable = false;

    mapping(address => bool) private _isExcludedFromFees;

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event BuyFeesUpdate(uint256 totalFeesOnBuy);
    event SellFeesUpdate(uint256 totalFeesOnSell);
    
    event UpdateUniswapV2Router(
        address indexed newAddress,
        address indexed oldAddress
    );

    constructor() BEP20("AIoxus", "OXUS") {

        transferOwnership(msg.sender);
        operator = msg.sender;
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        );
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), USDTAddress);

        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;

        _isExcludedFromFees[owner()] = true;
        _isExcludedFromFees[DEAD] = true;
        _isExcludedFromFees[address(this)] = true;

        _createSupply(owner(), 12_000_000_000 * (10**18));
    }

    receive() external payable {}

    modifier onlyOperator() {
        require(operator == _msgSender(), "Caller is not the Operator");
        _;
    }

    modifier onlyAuth() {
        require(
            operator == _msgSender() || _msgSender() == owner(),
            "Caller is not the Operator or Owner"
        );
        _;
    }

    function claimStuckTokens(address token) external onlyOwner {
        if (token == address(0x0)) {
            payable(msg.sender).transfer(address(this).balance);
            return;
        }
        IBEP20 BEP20token = IBEP20(token);
        uint256 balance = BEP20token.balanceOf(address(this));
        BEP20token.transfer(msg.sender, balance);
    }

    function claimStuckBNB(address payable recipient, uint256 amount) external onlyOwner {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function updateUniswapV2Router(address newAddress) external onlyOperator {
        require(
            newAddress != address(uniswapV2Router),
            "The router already has that address"
        );
        emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
        address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
            .createPair(address(this), USDTAddress);
        uniswapV2Pair = _uniswapV2Pair;
    }

    //=======FeeManagement=======//
    function excludeFromFees(address account)
        external
        onlyOwner
    {
        require(!_isExcludedFromFees[account], "Account is already excluded");
        _isExcludedFromFees[account] = true;

        emit ExcludeFromFees(account,true);
    }

    function includeInFees(address account)
        external
        onlyOwner
    {
        require(_isExcludedFromFees[account], "Account is already included");
        _isExcludedFromFees[account] = false;

        emit ExcludeFromFees(account,false);
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function updateBuyFees(uint256 totalFeesOnBuy) external onlyOwner {
        require(totalFeesOnBuy <= 25, "Fees must be less than 25%");
        
        _totalFeesOnBuy = totalFeesOnBuy;
        emit BuyFeesUpdate(totalFeesOnBuy);
    }

    function updateSellFees(uint256 totalFeesOnSell) external onlyOwner {
        require(totalFeesOnSell <= 25, "Fees must be less than 25%");

        _totalFeesOnSell = totalFeesOnSell;
        emit SellFeesUpdate(totalFeesOnSell);
    }
    
    function blacklistAccount(address[] memory blacklist) external onlyOwner() {
        for (uint256 i = 0; i < blacklist.length; i++) {
            if (!_isBlacklisted[blacklist[i]]) {
                _isBlacklisted[blacklist[i]] = true;
            } else {
                continue;
            }
        }
    }
    
    function removeBlacklist(address[] memory blacklist) external onlyOwner() {
        for (uint256 i = 0; i < blacklist.length; i++) {
            if (_isBlacklisted[blacklist[i]]) {
                _isBlacklisted[blacklist[i]] = false;
            } else {
                continue;
            }
        }
    }

    function isBlacklisted(address account) external view returns (bool) {
        return _isBlacklisted[account];
    }

    function setBlacklistDisable(bool _blacklistDisableval) external onlyOwner {
        blacklistDisable = _blacklistDisableval;
    }

    function getBlacklistDisable() external view returns (bool) {
        return blacklistDisable;
    }

    function setTaxDisable(bool _taxDisableval) external onlyOwner {
       taxDisable = _taxDisableval;
    }

    function getTaxDisable() external view returns (bool) {
        return taxDisable;
    }

    function changeOperatorWallet(address _operatorWWallet)
        external
        onlyOperator
    {
        operator = _operatorWWallet;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");

        if (!blacklistDisable) {
            if (to != owner()) {
                require(
                    !_isBlacklisted[from],
                    "BEP20: sender address blacklisted"
                );
                require(
                    !_isBlacklisted[to],
                    "BEP20: transfer to blacklisted address"
                );
            }
        }

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        bool takeFee = true;
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        if (from != uniswapV2Pair && to != uniswapV2Pair) {
            takeFee = false;
        }

        if(taxDisable){
            takeFee = false;
        }

        if (takeFee) {
            uint256 _totalFees;
            if (from == uniswapV2Pair) {
                _totalFees = _totalFeesOnBuy;
            } else {
                _totalFees = _totalFeesOnSell;
            }
            if(_totalFees > 0){
                uint256 fees = (amount * _totalFees) / 100;

                amount = amount - fees;

                super._transfer(from, address(this), fees);
            }
        }

        super._transfer(from, to, amount);
    }
}