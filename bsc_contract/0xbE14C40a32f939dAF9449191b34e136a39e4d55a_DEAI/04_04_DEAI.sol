// SPDX-License-Identifier: MIT
 

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";
 

 
 contract DEAI is Context,IERC20,IERC20Metadata{
     address public owner;
     string private _name;
     string private _symbol;
     uint256 private _totalSupply;
     mapping(address=>uint256) private _balances;
     mapping(address=>mapping(address=>uint256)) private _allowance;

     constructor(  string memory name, string memory symbol,uint256 totalSupply){
        _name=name;
        _symbol=symbol;
        _totalSupply=totalSupply*10**18;
        owner=msg.sender;
        _balances[owner]=_totalSupply;

        emit Transfer(address(0),owner,_totalSupply);
        

     }

     function name() public view virtual override returns(string memory){
         return _name;
     }

     function symbol()public view virtual override returns(string memory){
         return _symbol;
     }
     function decimals()public view virtual override returns(uint8){
         return 18;
     }

     function totalSupply() public view virtual override returns(uint256){
         return _totalSupply;
     }

     function balanceOf(address account) public view virtual override returns(uint256){
         return _balances[account];
     }

     function transfer(address to, uint256 amount) public virtual override returns(bool) {
         address from= _msgSender();
         _transfer(from,to,amount);
         return true;

     }

     function _transfer(address from,address to, uint256 amount) internal {
         require(_balances[from] >=amount, "Not Enough Balance");
         _balances[from] -=amount;
         _balances[to]+=amount;
         emit Transfer(from,to,amount);
     }

     function allowance(address owner,address spender) public view virtual override returns(uint256){
         return _allowance[owner][spender];
     }

     function approve(address spender, uint256 amount) public virtual override returns (bool){
         address from= _msgSender();
       _approve(from,spender,amount);
        return true;
     }

     function _approve(address from,address spender ,uint256 amount) internal virtual{
     
        _allowance[from][spender]=amount;
        emit Approval(from,spender,amount);

     }

     function transferFrom(address from,address to, uint256 amount)public virtual override returns(bool){
         address spender =_msgSender();
        _spendAllowance(from,spender,amount);

         _transfer(from,to,amount);

        return true;

     }

    function _spendAllowance(address from,address to , uint256 amount) internal virtual{

        uint256 currentAllowance= allowance(from,to);
        if(currentAllowance >=amount){
           _approve(from,to,amount-currentAllowance); 
        }
        
        
    }

 }