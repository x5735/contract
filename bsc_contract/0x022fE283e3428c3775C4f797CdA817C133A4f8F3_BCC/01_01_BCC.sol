// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

interface IStake {
    function depositFee(uint256 amount_) external;
}

contract BCC {
    string public name = "Bichon Coin";
    string public symbol = "BCC";
    uint8 public decimals = 18;
    uint256 public totalSupply = 0;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;
    mapping(address => bool) public whitelist;

    uint256 public taxFee = 30; // 30/1000 3%
    uint256 public burnFee = 20; // 20/1000 2%
    address public burnAddress = 0x000000000000000000000000000000000000dEaD;
    address public stakeAddress;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed holder,
        address indexed spender,
        uint256 value
    );

    constructor(address dao_) {
        owner = msg.sender;
        _mint(dao_, 125920234191380458898048032);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function setOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function setStakeAddress(address newStakeAddress) external onlyOwner {
        stakeAddress = newStakeAddress;
        if (newStakeAddress != address(0)) {
            uint256 reward = balanceOf[address(this)];
            IStake(stakeAddress).depositFee(reward);
            changeBalance(address(this), stakeAddress, reward);
        }
    }

    function setBurnAddress(address newBurnAddress) external onlyOwner {
        burnAddress = newBurnAddress;
    }

    function setBurnFee(uint256 newBurnFee) external onlyOwner {
        require(newBurnFee <= taxFee, "invalid burn fee");
        burnFee = newBurnFee;
    }

    function setTaxFee(uint256 newTaxFee) external onlyOwner {
        taxFee = newTaxFee;
    }

    function setWhitelist(
        address[] memory new_addr,
        bool _value
    ) external onlyOwner {
        for (uint256 i = 0; i < new_addr.length; i++) {
            whitelist[new_addr[i]] = _value;
        }
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external virtual returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(
        address spender,
        uint256 amount
    ) external virtual returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external virtual returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = allowance[sender][msg.sender];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        unchecked {
            _approve(sender, msg.sender, currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) external virtual returns (bool) {
        _approve(
            msg.sender,
            spender,
            allowance[msg.sender][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) external virtual returns (bool) {
        uint256 currentAllowance = allowance[msg.sender][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractedValue);
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

        uint256 senderBalance = balanceOf[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        unchecked {
            balanceOf[sender] = senderBalance - amount;
        }
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        totalSupply += amount;
        balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _approve(
        address holder,
        address spender,
        uint256 amount
    ) internal virtual {
        require(holder != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        allowance[holder][spender] = amount;
        emit Approval(holder, spender, amount);
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
    ) internal virtual {
        if (whitelist[to] || whitelist[from]) {
            return;
        }

        if (from == stakeAddress || to == stakeAddress) {
            return;
        }

        uint256 burnAmount = (amount * burnFee) / 1000;
        changeBalance(to, burnAddress, burnAmount);

        uint256 reward = (amount * taxFee) / 1000 - burnAmount;
        if (stakeAddress != address(0)) {
            IStake(stakeAddress).depositFee(reward);
            changeBalance(to, stakeAddress, reward);
        } else {
            changeBalance(to, address(this), reward);
        }
    }

    function changeBalance(address from, address to, uint256 amount) private {
        if (amount > 0) {
            balanceOf[from] -= amount;
            balanceOf[to] += amount;
            emit Transfer(from, to, amount);
        }
    }
}