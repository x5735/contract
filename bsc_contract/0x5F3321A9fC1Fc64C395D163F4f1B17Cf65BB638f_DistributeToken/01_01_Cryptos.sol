//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    }
contract DistributeToken{
    address admin;
    uint public playerLength;
    IERC20 cguToken;
    IERC20 USDT;
    uint public totalSpendCguToken;
    uint public totalSpendUsdt;
    constructor (){
        admin=msg.sender;
        cguToken=IERC20(0x747D74dB20cc422F39ab54EDB2A3Ce21f3C98AF1);
        USDT=IERC20(0x55d398326f99059fF775485246999027B3197955);
    }
    modifier onlyAdmin(){
        require(msg.sender==admin,"only admin");
        _;
    }
    struct Player{
        uint rank;
        address playeraddress;
        uint cguToken;
        uint USDT;
    }
    mapping (uint=>Player) Splayer;
    //add player
    function addPlayer(address[] calldata  _address)public onlyAdmin{
        for( uint i=0;i<_address.length;i++){
            Splayer[i].playeraddress=_address[i];
            Splayer[i].rank=i;
        }
        playerLength=_address.length;
    }

    function addCguToken(uint[] calldata  _cguToken)public onlyAdmin{
        require(playerLength>0&&playerLength ==_cguToken.length);
         for(uint i=0;i<playerLength;i++){
            Splayer[i].cguToken=_cguToken[i];
    }}
    function addUsdtToken(uint[] calldata  _UsdtToken)public onlyAdmin{
            require(playerLength>0&&playerLength ==_UsdtToken.length);
         for(uint i=0;i<playerLength;i++){
            Splayer[i].USDT=_UsdtToken[i];
    }}
    function deletePlayer() public onlyAdmin{
        for(uint i=0;i<playerLength;i++){
            Splayer[i]=Player(0,address(0),0,0);
        }playerLength=0;
        }
    function transferCguReward() public payable onlyAdmin{
      require(playerLength>0);
        for (uint i=0;i<playerLength;i++){
            require(Splayer[i].playeraddress != address(0) ,"Add all the Address");
            if (Splayer[i].cguToken > 0) {
            uint amount=Splayer[i].cguToken*10**8;
            Splayer[i].cguToken=0;
            require(cguToken.transfer(Splayer[i].playeraddress, amount), "Transfer failed."); 
            totalSpendCguToken+=amount/10**8;
            }
        }   
    }
    function transferUSDTRewad() public payable onlyAdmin{
        require(playerLength>0);
        for (uint i=0;i<playerLength;i++){
            if (Splayer[i].USDT > 0) {
            require(Splayer[i].playeraddress != address(0) ,"Add all the Address");
            uint amount=Splayer[i].USDT*10**18;
            Splayer[i].USDT=0;
            require(USDT.transfer(Splayer[i].playeraddress,amount), "Transfer failed.");
            totalSpendUsdt+=amount/10**18;
            }
        }   
    }
    function transferOwnership(address newOwner) public onlyAdmin{
        admin=newOwner;
    }
    function transferCguToken(address recipient, uint256 _amount) public onlyAdmin{
        cguToken.transfer(recipient,_amount*10**8);
    }
    function balanceOfCguToken() external view returns (uint256){
        return cguToken.balanceOf(address(this))/10**8;
    }
    function transferUSDT(address recipient, uint256 _amount) public onlyAdmin{
        USDT.transfer(recipient,_amount*10**18);
    }
    function balanceOfUSDT() external view returns (uint256){
        return USDT.balanceOf(address(this))/10**18;
    }
    function getPlayer(uint index)public view returns(uint rank,address playeraddress,uint _cguAmount,uint USDTAmount ){
        (rank,playeraddress,_cguAmount,USDTAmount)=(Splayer[index].rank,Splayer[index].playeraddress,Splayer[index].cguToken,Splayer[index].USDT);
    }
    function totalSpendOfTokens() external view returns (uint _totalSpendCguToken ,uint _totalSpendUsdt){
        (_totalSpendCguToken,_totalSpendUsdt)=(totalSpendCguToken,totalSpendUsdt);
    }
}