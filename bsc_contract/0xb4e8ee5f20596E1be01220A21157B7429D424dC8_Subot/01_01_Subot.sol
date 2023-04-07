/**
 *Submitted for verification at BscScan.com on 2023-01-19
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.12; 

interface IStakingContract {
    function stake(uint256 _amount) external;
}

interface ERC20 {
    function approve(address spender, uint256 amount) external returns (bool success);
    function balanceOf(address _tokenOwner) external view returns (uint balance);
    function transfer(address _to, uint _tokens) external returns (bool success);
    function allowance(address _contract, address _spender) external view returns (uint256 remaining);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }   

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Subot {

    using SafeMath for uint256;
    address public staking_pool_address;
    address public buy_back_contract;
    address public project_wallet;
    address public token_contract;
    address public usdt_contract;

    address public owner = msg.sender;
    uint256 public staking_fees = 40;
    uint256 public dev_fees = 40;

    constructor(
        address _staking_pool_address,
        address _buy_back_contract,
        address _project_wallet,
        address _token_contract,
        address _usdt_contract) {
       staking_pool_address = _staking_pool_address;
       buy_back_contract = _buy_back_contract;
       project_wallet = _project_wallet;
       token_contract = _token_contract;
       usdt_contract = _usdt_contract;
    }

    receive() external payable {}

    event acceptedPaymentBNB(address indexed group_owner, string indexed order_id, uint256 amount);
    event acceptedPaymentToken(address indexed group_owner, string indexed order_id, uint256 amount, address indexed token_contract);

    function acceptPaymentBNB(address group_owner, string memory order_id) public payable {
        uint256 total = msg.value;
        uint256 s_fees = total.mul(staking_fees).div(1000);
        uint256 d_fees = total.mul(dev_fees).div(1000);

        (bool sent, ) = buy_back_contract.call{value: s_fees}("");
        require(sent, "Failed to charge staking fees.");

        (bool sent1, ) = project_wallet.call{value: d_fees}("");
        require(sent1, "Failed to charge dev fees.");

        (bool sent2, ) = group_owner.call{value: msg.value.sub(s_fees + d_fees)}("");
        require(sent2, "Failed to charge.");

        emit acceptedPaymentBNB(group_owner, order_id, msg.value);
    }
    
    function acceptPaymentTTN(address recipient_, uint256 amount_) public {
        ERC20 transferToken = ERC20(token_contract);
        uint256 total = amount_;

        uint256 s_fees = total.mul(staking_fees).div(1000);
        uint256 d_fees = total.mul(dev_fees).div(1000);
 
        
        require(transferToken.allowance(msg.sender, address(this)) >= amount_, "Insufficient Allowance");
        require(transferToken.transferFrom(msg.sender, address(this), amount_), "Transfer failed");
        transferToken.approve(staking_pool_address, amount_);
        IStakingContract(staking_pool_address).stake(s_fees);
        require(transferToken.transfer(project_wallet, d_fees), "Transfer failed");
        require(transferToken.transfer(recipient_, total.sub(s_fees + d_fees)), "Transfer failed");
    }

    function acceptPaymentUSDT(address recipient_, uint256 amount_) public payable {
        ERC20 transferToken = ERC20(usdt_contract);
        uint256 total = amount_;

        uint256 s_fees = total.mul(staking_fees).div(1000);
        uint256 d_fees = total.mul(dev_fees).div(1000);

        require(transferToken.allowance(msg.sender, address(this)) >= amount_, "Insufficient Allowance");
        require(transferToken.transferFrom(msg.sender, address(this), amount_), "Transfer failed");

        require(transferToken.transfer(buy_back_contract, s_fees), "Transfer failed");
        require(transferToken.transfer(project_wallet, d_fees), "Transfer failed");
        require(transferToken.transfer(recipient_, total.sub(s_fees + d_fees)), "Transfer failed");
    }
}