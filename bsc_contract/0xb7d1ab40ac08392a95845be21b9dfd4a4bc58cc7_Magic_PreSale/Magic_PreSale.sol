/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

// SPDX-License-Identifier: MIT
// FishGunCrypto.io Team
pragma solidity ^0.8.14;

interface IERC20 {

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Magic_PreSale{

    IERC20 public tokenMAGIC = IERC20(0x03450c8c2a9265823a715caD9cd3aDE2C840BBC2);
    IERC20 public tokenBUSD = IERC20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);

    address public owner;

    uint256 public price_BNB_per_token = 10**15;      // 0.001 BNB = 1 MAGIC
    uint256 public price_Token_per_token = 10**15;    // 0.001 BUSD = 1 MAGIC
    
    bool public block_BNB = false;
    bool public block_Token = false;

    struct Player {
        address playerWallet;
        uint256 amountMagic;
    }
    uint public mapSize=0;
    mapping(uint256 => Player) public arrayPlayers;

    constructor(){
        owner = msg.sender;
    }

    // function getTotalPlayers() public view returns(uint){
    //     return arrayPlayers.length;
    // }

    modifier checkOwner(){
        require(msg.sender==owner, "You are not allowed.");
        _;
    }

    function buy_Magic_via_BNB() public payable{
        require(block_Token==false, "Not allowed");
        require(msg.value>=price_BNB_per_token, "Wrong value");
        uint256 tokenAmount = msg.value/price_BNB_per_token*10**18;
        require(tokenMAGIC.balanceOf(address(this))>=tokenAmount, "Not enough MAGIC to sell at this momment.");
        tokenMAGIC.transfer(msg.sender, tokenAmount);
        mapSize++;
        Player memory newPlayer = Player(msg.sender, tokenAmount);
        arrayPlayers[mapSize]= newPlayer;
    }

    function buy_Magic_via_Token(uint256 tokenBUSD_amount) public{
         require(block_BNB==false, "Not allowed");
        require(tokenBUSD.allowance(msg.sender, address(this))>tokenBUSD_amount, "Please approve BUSD.");
        require(tokenBUSD.balanceOf(msg.sender)>=tokenBUSD_amount, "You don't have BUSD enough");
        uint256 tokenAmount = tokenBUSD_amount/price_Token_per_token*10**18;
        require(tokenMAGIC.balanceOf(address(this))>=tokenAmount, "Not enough MAGIC to sell at this momment.");
        tokenBUSD.transferFrom(msg.sender, address(this), tokenBUSD_amount);
        tokenMAGIC.transfer(msg.sender, tokenAmount);
        mapSize++;
        Player memory newPlayer = Player(msg.sender, tokenAmount);
        arrayPlayers[mapSize]= newPlayer;
    }

    function update_price(uint256 bnb_price, uint256 token_price) public checkOwner{
        require(bnb_price>0, "Wrong value");
        require(token_price>0, "Wrong token");
        price_BNB_per_token = bnb_price;
        price_Token_per_token = token_price;
    }

    function update_curreny_status(bool bnb_status, bool token_status) public checkOwner{
        block_BNB = bnb_status;
        block_Token = token_status;
    }

    function withdraw_BNB() public checkOwner{
        require(address(this).balance>0, "Do not have bnb");
        payable(owner).transfer(address(this).balance);
    }

    function withdraw_BUSD() public checkOwner{
        require(tokenBUSD.balanceOf(address(this))>0, "Do not have BUSD");
        tokenBUSD.transfer(owner, tokenBUSD.balanceOf(address(this)));
    }

    function withdraw_Magic() public checkOwner{
        require(tokenMAGIC.balanceOf(address(this))>0, "Do not have MAGIC");
        tokenMAGIC.transfer(owner, tokenMAGIC.balanceOf(address(this)));
    }
}