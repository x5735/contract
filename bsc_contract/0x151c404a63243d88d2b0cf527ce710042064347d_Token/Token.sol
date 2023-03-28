/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract Token is IBEP20 {
    string public constant name = "Whale UNI";
    string public constant symbol = "WHLI";
    uint8 public constant decimals = 9;
    
    address private _owner;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    uint256 private _buyFee = 0; // default buy fee
    uint256 private _sellFee = 6; // default sell fee
    address private _feeAddress = 0x1c108BE1A17C29414D311b51eB012182c9dE09dE;
    
    constructor(uint256 initialSupply) {
        _owner = msg.sender;
        _totalSupply = initialSupply * 10 ** decimals;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the contract owner can call this function");
        _;
    }
    
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }
    
    function setBuyFee(uint256 buyFee) public onlyOwner {
        require(buyFee <= 100, "Buy fee percentage must be less than or equal to 100");
        _buyFee = buyFee;
    }
    
    function getBuyFee() public view returns (uint256) {
        return _buyFee;
    }
    
    function setSellFee(uint256 sellFee) public onlyOwner {
        require(sellFee <= 100, "Sell fee percentage must be less than or equal to 100");
        _sellFee = sellFee;
    }
    
    function getSellFee() public view returns (uint256) {
        return _sellFee;
    }
    
    function setFeeAddress(address feeAddress) public onlyOwner {
        _feeAddress = feeAddress;
    }
    
    function getFeeAddress() public view returns (address) {
        return _feeAddress;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        
        uint256 buyFeeAmount = 0;
        uint256 sellFeeAmount = 0;
        
        if (sender == _feeAddress || recipient == _feeAddress) {
            buyFeeAmount = 0;
            sellFeeAmount = 0;
        } else if (recipient == address(this)) {
            // Selling tokens
            sellFeeAmount = amount * _sellFee / 100;
            _balances[_feeAddress] += sellFeeAmount;
            _totalSupply -= sellFeeAmount;
        } else {
            // Buying tokens
            buyFeeAmount = amount * _buyFee / 100;
            _balances[_feeAddress] += buyFeeAmount;
            _totalSupply += buyFeeAmount;
        }
        
        _balances[sender] -= amount;
        _balances[recipient] += amount - sellFeeAmount - buyFeeAmount;
        
        emit Transfer(sender, recipient, amount);
    }
    
    function _approve(address owner , address spender, uint256 amount) private {
        require(owner != address(0), "Approve from the zero address");
        require(spender != address(0), "Approve to the zero address");
        _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
}

event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);
}