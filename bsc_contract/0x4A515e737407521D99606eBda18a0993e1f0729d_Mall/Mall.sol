/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

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

library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

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

contract Mall is Ownable{
    event MultiTransfer(uint256 total,address _token);
    event Withdraw(address indexed account,uint256 gasValue,uint256 amount,uint8 t);
    event Pay(address indexed account,uint256 orderId,uint256 amount);

    using SafeMath for uint256;
    uint private up = 8;
    IERC20 public BNBao;
    IERC20 public Usdt;
    address public Pair;
    address payable withdrawAddr;
    address public master;
    

    uint256 private constant BASE_RATIO = 10**18; 

    constructor(){
        BNBao = IERC20(0x72d205bF2662D11c65e468A59101B3A4e988E527);
        Usdt = IERC20(0x55d398326f99059fF775485246999027B3197955);
        Pair = 0x45825E8c0fe3De463b743D5669980fE83695d47f;
        withdrawAddr = payable(0x8596fBFec1489c53e6ac36055Ce2D13a28Be3e2A);
        master = 0xc6E4A547c2287ef382EF02A11a6e37Ce78E72e48;
    }


    function setBNBao(address _token) public onlyOwner(){
        BNBao = IERC20(_token);
    }

    function setUsdt(address _usdt) public onlyOwner(){
        Usdt = IERC20(_usdt);
    }

    function setPair(address _pair) public onlyOwner(){
        Pair = _pair;
    }

    function getWithdraw() public view returns(address){
        return withdrawAddr;
    }

    function setWithdraw(address _addr) public onlyOwner(){
        withdrawAddr = payable(_addr);
    }

    function setMaster(address _addr) public onlyOwner(){
        master = _addr;
    }

    function pay(uint256 orderId,uint256 amount) public {
        require(amount > 0,"error");
        Usdt.transferFrom(msg.sender,master,amount);
        emit Pay(msg.sender,orderId,amount);
    }

    function getPrice() public view returns(uint){
        uint balanceA;
        uint balanceB;
        balanceA = BNBao.balanceOf(Pair).mul(10 ** up);
        balanceB = Usdt.balanceOf(Pair);
        return balanceA.div(balanceB);
    }
    
    function withdraw(uint256 amount,uint8 t) payable public  {
        withdrawAddr.transfer(msg.value);
        emit Withdraw(msg.sender,msg.value,amount,t);
    }

    function multiTransfer(address _token, address[] memory addresses, uint256[] memory counts) public returns (bool){
        uint256 total;
        IERC20 token = IERC20(_token);
        for(uint i = 0; i < addresses.length; i++) {
            require(token.transferFrom(msg.sender, addresses[i], counts[i]));
            total += counts[i];
        }
        emit MultiTransfer(total,_token);
        return true;
    }
}