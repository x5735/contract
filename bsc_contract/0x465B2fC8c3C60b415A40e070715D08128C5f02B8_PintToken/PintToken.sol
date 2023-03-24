/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

// File: contracts\IBEP20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function mint(address account, uint256 amount) external returns (bool);
    function burn(uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts\PintToken.sol

pragma solidity ^0.8.0;
contract PintToken is IBEP20 {
    string public name ;
    string public symbol;
    uint8 public decimals;
    uint256 public claim_start_time;
    uint256 public WEEKLY_CLAIM_SUPPLY;
    address payable public owner;
    uint256 public override totalSupply;
    uint256 public  MAX_SUPPLY;
    uint256 public  INITIAL_SUPPLY;
    uint256 public constant LIQUIDITY_TAX = 1;
    uint256 public constant ASSET_BACKING_TAX = 5 * 10**17; //0.5%
    uint256 public constant BUY_TAX = 25 * 10**16; //0.25%
    uint256 public constant SELL_TAX_REFLECTION = 5;
    uint256 public constant SELL_TAX_BURN = 5;
    address public constant DIRECTOR1_WALLET_ADDRESS = 0x15c72f29B3cE6f0cBf8778E0Dd6f43736259b1bC;
    address public constant DIRECTOR2_WALLET_ADDRESS = 0x1F0B9a481e4835E0E6e3545D5804D3997C626bD0;
    address public constant LIQUIDITY_WALLET_ADDRESS = 0xEC97A75A0696f50C6c80B6CA2c87f0D0F7EcdDe6;
    address public constant ASSET_BACKING_WALLET_ADDRESS = 0x5cf3F8d3E57c74b0161ff4F3C55B29E56b84e4e4;
    mapping (address => uint256) public override balanceOf;
    mapping (address => bool) public claimed;
    mapping (address => mapping (address => uint256)) public override allowance;

    constructor() {
            name = "Pint";
            symbol ="PNT";
            decimals = 18;
            MAX_SUPPLY = 100000000000 * 10**18;
            INITIAL_SUPPLY  = 200000000 * 10**18;
            owner = payable(msg.sender);
            totalSupply = INITIAL_SUPPLY;
            balanceOf[owner] = totalSupply;
            emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
    }
    function startWeeklyClaim() public {
        require(block.timestamp > claim_start_time + 7 days, "This week claim is still running");
        require(WEEKLY_CLAIM_SUPPLY <= 0, "Tokens still up for claim");
        claim_start_time = block.timestamp;
        WEEKLY_CLAIM_SUPPLY = 10000000 * 10**18;
    }

     function addTokensForClaim() public {
        require(claim_start_time > 0, "This week's claim is not started yet");
        WEEKLY_CLAIM_SUPPLY = 10000000 * 10**18;
    }

    function _calculateBuyTax(uint256 amount) private pure returns (uint256) {
        return amount * BUY_TAX / 100;
    }

    function _calculateSellTaxReflection(uint256 amount) private pure returns (uint256) {
        return amount * SELL_TAX_REFLECTION / 100;
    }

    function _calculateSellTaxBurn(uint256 amount) private pure returns (uint256) {
        return amount * SELL_TAX_BURN / 100;
    }

    function _calculateLiquidityTax(uint256 amount) private pure returns (uint256) {
        return amount * LIQUIDITY_TAX / 100;
    }

    function _calculateAssetBackingTax(uint256 amount) private pure returns (uint256) {
        return amount * ASSET_BACKING_TAX / 100;
    }

    function checkClaimStatus(address user) public view returns (bool) {
        return claimed[user];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        uint256 reflectionFee = _calculateSellTaxReflection(amount);
        uint256 burnFee = _calculateSellTaxBurn(amount);
        amount -= reflectionFee + burnFee;
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        balanceOf[address(0)] += burnFee;
        totalSupply -= reflectionFee;
        emit Transfer(msg.sender, recipient, amount);
        emit Transfer(msg.sender, address(0), burnFee);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        require(amount <= balanceOf[sender], "Insufficient balance");
        require(amount <= allowance[sender][msg.sender], "Insufficient allowance");
        uint256 reflectionFee = _calculateSellTaxReflection(amount);
        uint256 burnFee = _calculateSellTaxBurn(amount);
        uint256 liquidityTax = _calculateLiquidityTax(amount);
        uint256 assetBackingTax = _calculateAssetBackingTax(amount);
        amount -= reflectionFee + burnFee + liquidityTax + assetBackingTax;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        balanceOf[address(0)] += burnFee;
        balanceOf[LIQUIDITY_WALLET_ADDRESS] += liquidityTax;
        balanceOf[ASSET_BACKING_WALLET_ADDRESS] += assetBackingTax;
        totalSupply -= reflectionFee;
        allowance[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        emit Transfer(sender, address(0), burnFee);
        emit Transfer(sender, LIQUIDITY_WALLET_ADDRESS, liquidityTax);
        emit Transfer(sender, ASSET_BACKING_WALLET_ADDRESS, assetBackingTax);
        return true;
    }

    function mint(address account, uint256 amount) public override returns (bool) {
        require(msg.sender == DIRECTOR1_WALLET_ADDRESS || msg.sender == DIRECTOR2_WALLET_ADDRESS, "Unauthorized");
        require(totalSupply + amount <= MAX_SUPPLY, "Exceeds max supply");
        totalSupply += amount;
        balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
        return true;
    }

    function mintDrop( uint256 amount) public  returns (bool) {
        require(totalSupply + amount <= MAX_SUPPLY, "Exceeds max supply");
        require(amount <= WEEKLY_CLAIM_SUPPLY, "Exceeds balance in this week's treasury");
        totalSupply += amount;
        balanceOf[msg.sender] += amount;
        claimed[msg.sender] = true;
        WEEKLY_CLAIM_SUPPLY -= amount;
        emit Transfer(address(0), msg.sender, amount);
        return true;
    }

    function burn(uint256 amount) external override returns (bool) {
        require(amount <= balanceOf[msg.sender], "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }
}