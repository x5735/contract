/**
 *Submitted for verification at BscScan.com on 2023-03-26
*/

pragma solidity ^0.6.0;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
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
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }
}

contract Ownable {

  // Owner of the contract
  address payable public owner;
  address payable internal _newOwner;

    constructor() public {
        owner = msg.sender;
    }

  /**
  * @dev Event to show ownership has been transferred
  * @param previousOwner representing the address of the previous owner
  * @param newOwner representing the address of the new owner
  */
  event OwnershipTransferred(address previousOwner, address newOwner);


  /**
   * @dev Sets a new owner address
   */
  function setOwner(address payable newOwner) internal {
    _newOwner = newOwner;
  }

  /**
  * @dev Throws if called by any account other than the owner.
  */
  modifier onlyOwner() {
    require(msg.sender == owner, "Not Owner");
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address payable newOwner) public onlyOwner {
    require(newOwner != address(0), "Invalid Address");
    setOwner(newOwner);
  }

  //this flow is to prevent transferring ownership to wrong wallet by mistake
  function acceptOwnership() public returns (address){
      require(msg.sender == _newOwner,"Invalid new owner");
      emit OwnershipTransferred(owner, _newOwner);
      owner = _newOwner;
      _newOwner = address(0);
      return owner;
  }
}

contract BullishCeoAI is Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) public _BCTokenBalances;
    mapping(address => mapping(address => uint256)) public _allowed;
    string constant tokenName = "BullishCeoAI";
    string constant tokenSymbol = "BC";
    uint8 constant tokenDecimals = 18;
    uint256 _totalSupply = 10000 * 10**uint256(tokenDecimals);
    address payable devAddress;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(address payable _devAddress)
        public
        payable
    {
        devAddress = _devAddress;
        _mint(devAddress, _totalSupply);
    }

    function name() public pure returns (string memory) {
        return tokenName;
    }

    function symbol() public pure returns (string memory) {
        return tokenSymbol;
    }

    function decimals() public pure returns (uint8) {
        return tokenDecimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _BCTokenBalances[owner];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= _BCTokenBalances[msg.sender]);
        require(to != address(0));

        uint256 BCTokenToDev = value.div(50);
        uint256 BCTokenToBurn = value.div(100);
        uint256 tokensToTransfer = value.sub(BCTokenToDev).sub(BCTokenToBurn);

        _BCTokenBalances[msg.sender] = _BCTokenBalances[msg.sender]
            .sub(value);
        _BCTokenBalances[to] = _BCTokenBalances[to].add(
            tokensToTransfer
        );
        _BCTokenBalances[devAddress] = _BCTokenBalances[devAddress].add(
            BCTokenToDev
        );
        _totalSupply = _totalSupply.sub(BCTokenToBurn);

        emit Transfer(msg.sender, to, tokensToTransfer);
        emit Transfer(msg.sender, devAddress, BCTokenToDev);
        emit Transfer(msg.sender, address(0), BCTokenToBurn);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowed[owner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(value <= _BCTokenBalances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        _BCTokenBalances[from] = _BCTokenBalances[from].sub(value);

        uint256 BCTokenToDev = value.div(50);
        uint256 BCTokenToBurn = value.div(100);
        uint256 tokensToTransfer = value.sub(BCTokenToDev).sub(BCTokenToBurn);

        _BCTokenBalances[to] = _BCTokenBalances[to].add(
            tokensToTransfer
        );
        _BCTokenBalances[devAddress] = _BCTokenBalances[devAddress].add(
            BCTokenToDev
        );
        _totalSupply = _totalSupply.sub(BCTokenToBurn);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

        emit Transfer(from, to, tokensToTransfer);
        emit Transfer(from, devAddress, BCTokenToDev);
        emit Transfer(from, address(0), BCTokenToBurn);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        require(spender != address(0));
        _allowed[msg.sender][spender] = (
            _allowed[msg.sender][spender].add(addedValue)
        );
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        require(spender != address(0));
        _allowed[msg.sender][spender] = (
            _allowed[msg.sender][spender].sub(subtractedValue)
        );
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function _mint(address account, uint256 amount) internal {
      require(amount != 0);
      _BCTokenBalances[account] = _BCTokenBalances[account].add(amount);
      emit Transfer(address(0), account, amount);
    }

    function setDevAddress(address payable _devAddress) external onlyOwner {
        devAddress = _devAddress;
    }
}