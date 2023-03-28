/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

interface BEP20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Forsagemeta {
    using SafeMath for uint256;
    BEP20 public busd = BEP20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
    uint256 private constant timeStep = 1 days;
    uint256 private constant leaderValue = 100e18;
    uint256 lastFund = 0;
    uint256 allIndex=1;
    struct Player {
        address referrer;
        uint256 totalIncome;
        uint256 released;
        uint256 refNo;
        uint256 myRegister;
        uint256 mylastDeposit;
        mapping(uint256 => uint256) b3Entry;
        mapping(uint256 => uint256) b3_level;
        mapping(uint256 => uint256) b3Income;
        mapping(uint256 => uint256) myDirect;
        mapping(uint256 => uint256) isLeader;
        mapping(uint256 => uint256) levelTeam;
        mapping(uint256 => uint256) levelInc;
        mapping(uint256 => uint256) globalInc;
        mapping(uint256 => uint256) metaEntry;
        mapping(uint256 => uint256) directBuz;
    }
    mapping(address => Player) public players;
    
    mapping( uint256 =>  address []) public b6;

    mapping(uint256 => uint256) silver;
    mapping(uint256 => uint256) gold;
    mapping(uint256 => uint256) diamond;
    mapping(uint256 => uint256) bluediamond;
    mapping(uint256 => uint256) lastSelf;
    address [] silver_array;
    address [] gold_array;
    address [] diamond_array;
    address [] bluediamond_array;

    struct SingleLoop{
        uint256 ind;
    }
    struct SingleIndex{
        address ads;
    }
    mapping(uint => SingleIndex) public singleIndex;
    mapping(address => SingleLoop) public singleAds;

    address owner;
    uint256 public startTime;
    uint[4] leaderBonus = [3, 2, 2, 1];
    uint[7] levelBonus = [40, 10, 4, 4, 4, 4, 4];
    modifier onlyAdmin(){
        require(msg.sender == owner,"You are not authorized.");
        _;
    }
    constructor() public {
        owner = msg.sender;
        startTime = block.timestamp;
        for(uint8 i=0;i < 12; i++){
            players[msg.sender].metaEntry[i]++;
            players[msg.sender].b3Entry[i]++;
        }
        singleIndex[0].ads=msg.sender;
        singleAds[msg.sender].ind=0;
    }
    
    function metaInfo(uint256 _pkg) pure public returns(uint8 p) {
        if(_pkg == 10e18){
            p=1;
        }else if(_pkg == 20e18){
            p=2;
        }else if(_pkg == 40e18){
            p=3;
        }else if(_pkg == 80e18){
            p=4;
        }else if(_pkg == 160e18){
            p=5;
        }else if(_pkg == 320e18){
            p=6;
        }else if(_pkg == 640e18){
            p=7;
        }else if(_pkg == 1280e18){
            p=8;
        }else if(_pkg == 2560e18){
            p=9;
        }else if(_pkg == 5120e18){
            p=10;
        }else if(_pkg == 10240e18){
            p=11;
        }else{
            p=0;
        }
        return p;
    }
    function x4Info(uint256 _pkg) pure public returns(uint8 p) {
        if(_pkg == 10e18){
            p=1;
        }else if(_pkg == 20e18){
            p=2;
        }else if(_pkg == 40e18){
            p=3;
        }else if(_pkg == 80e18){
            p=4;
        }else if(_pkg == 160e18){
            p=5;
        }else if(_pkg == 320e18){
            p=6;
        }else if(_pkg == 640e18){
            p=7;
        }else if(_pkg == 1250e18){
            p=8;
        }else if(_pkg == 2560e18){
            p=9;
        }else if(_pkg == 5000e18){
            p=10;
        }else if(_pkg == 9900e18){
            p=11;
        }else{
            p=0;
        }
        return p;
    }

    function register(address _refferel, uint256 _amt) public {
        require(_amt == 10e18, "Invalid Amount");
        uint8 poolNo=0;
        require(players[msg.sender].metaEntry[poolNo] == 0 && players[msg.sender].b3Entry[poolNo] == 0, "Already registered");
        busd.transferFrom(msg.sender, address(this), _amt);
        players[msg.sender].referrer=_refferel;
        players[msg.sender].metaEntry[poolNo]++;
        players[msg.sender].mylastDeposit=_amt;

        players[msg.sender].refNo = players[_refferel].myRegister;
        players[_refferel].myRegister++;
        players[_refferel].myDirect[poolNo]++;
        uint256 _busd=_amt.div(2);
        uint256 totalDays=getCurDay();
        silver[totalDays]+=_busd.mul(leaderBonus[0]).div(100);
        gold[totalDays]+=_busd.mul(leaderBonus[1]).div(100);
        diamond[totalDays]+=_busd.mul(leaderBonus[2]).div(100);
        bluediamond[totalDays]+=_busd.mul(leaderBonus[3]).div(100);

        updateLeader(totalDays);

        setReferral(msg.sender,_refferel,_busd,poolNo);

        if(singleAds[msg.sender].ind==0){
            singleIndex[allIndex].ads=msg.sender;
            singleAds[msg.sender].ind=allIndex;
            allIndex++;
        }
        players[msg.sender].b3Entry[poolNo]++;
        players[_refferel].b3_level[poolNo]++;
        if(players[_refferel].b3_level[poolNo].mod(3) != 0){
            busd.transfer(_refferel,_busd);
            players[_refferel].b3Income[poolNo]+=_busd;
            players[_refferel].totalIncome+=_busd;
        }else{
            checkB3refer(_refferel,_busd,poolNo);
        }
        _setSingle(msg.sender,_busd,poolNo);
    }
    function deposit(uint256 _busd) public {
        require(_busd >= 10e18, "Invalid Amount");
        uint8 poolNo=metaInfo(_busd);
        require(players[msg.sender].metaEntry[poolNo-1] == 1, "Previoues not purchase");
        require(players[msg.sender].metaEntry[poolNo] == 0, "Already registered");
        busd.transferFrom(msg.sender, address(this), _busd);
        address _refferel=players[msg.sender].referrer;
        players[msg.sender].metaEntry[poolNo]++;
        players[msg.sender].mylastDeposit=_busd;
        players[_refferel].myDirect[poolNo]++;
        
        uint256 totalDays=getCurDay();
        silver[totalDays]+=_busd.mul(leaderBonus[0]).div(100);
        gold[totalDays]+=_busd.mul(leaderBonus[1]).div(100);
        diamond[totalDays]+=_busd.mul(leaderBonus[2]).div(100);
        bluediamond[totalDays]+=_busd.mul(leaderBonus[3]).div(100);

        updateLeader(totalDays);
        
        setReferral(msg.sender,_refferel,_busd,poolNo);

        if(singleAds[msg.sender].ind==0){
            singleIndex[allIndex].ads=msg.sender;
            singleAds[msg.sender].ind=allIndex;
            allIndex++;
        }
        _setSingle(msg.sender,_busd,poolNo);
        if(poolNo>=8){
            _setRank(msg.sender,poolNo);
        }
    }
    function _setRank(address _myAds, uint256 poolNo) internal {
        if(poolNo==8){
            players[_myAds].isLeader[0]++;
            if(players[_myAds].isLeader[0]==2){
                silver_array.push(_myAds);
            }
        }else if(poolNo==9){
            players[_myAds].isLeader[1]++;
            if(players[_myAds].isLeader[1]==2){
                gold_array.push(_myAds);
            }
        }else if(poolNo==10){
            players[_myAds].isLeader[2]++;
            if(players[_myAds].isLeader[2]==2){
                diamond_array.push(_myAds);
            }
        }else if(poolNo==11){
            players[_myAds].isLeader[3]++;
            if(players[_myAds].isLeader[3]==2){
                bluediamond_array.push(_myAds);
            }
        }
    }
    function _setSingle(address _myAds, uint256 _refAmount,uint256 poolNo) internal {
        uint256 selfIndex=singleAds[_myAds].ind;
        uint256 oneTimes=0;
        uint256 _sAmt=_refAmount.mul(20).div(400);
        address selfads;
        uint256 m=4;
        uint256 l = lastSelf[poolNo];
        while(m>=1){
            selfads=singleIndex[l].ads;
            if(selfIndex!=l && poolNo==0 && players[selfads].globalInc[4]<10e18 && players[selfads].myRegister==0){
                players[selfads].globalInc[4]+=_sAmt;
                players[selfads].totalIncome+=_sAmt;
                busd.transfer(selfads,_sAmt);
                m--;
            }else if(selfIndex!=l && poolNo>=1 && players[selfads].metaEntry[poolNo]>=1 && players[selfads].globalInc[5]<players[selfads].mylastDeposit.mul(2) && players[selfads].myDirect[poolNo]==1){
                players[selfads].globalInc[5]+=_sAmt;
                players[selfads].totalIncome+=_sAmt;
                busd.transfer(selfads,_sAmt);
                m--;
            }
            lastSelf[poolNo]++;
            l++;
            if(singleIndex[l].ads==address(0) && oneTimes==0){
                lastSelf[poolNo]=l=0;
                oneTimes=1;
            }
            if(singleIndex[l].ads==address(0) && oneTimes==1){
                lastSelf[poolNo]=l=0;
                break;
            }
            if(m==0) break;
        }
    }
    function _findrefer(address _refferel,uint256 poolNo) view private returns(address cref){
        cref=owner;
        while(_refferel != address(0)){
            if(players[_refferel].metaEntry[poolNo]>0){
                cref=_refferel;
                break;
            }
            _refferel=players[_refferel].referrer;
        }
        return cref;
    }
    function _findreferb3(address _refferel,uint256 poolNo) view private returns(address cref){
        cref=owner;
        while(_refferel != address(0)){
            if(players[_refferel].b3Entry[poolNo]>0){
                cref=_refferel;
                break;
            }
            _refferel=players[_refferel].referrer;
        }
        return cref;
    }
    function setReferral(address _adr,address _ref,uint256 _amt,uint256 poolNo) internal{
        for(uint256 i=0; i<levelBonus.length; i++){
            players[_ref].levelTeam[i]++;
            players[_ref].directBuz[players[_adr].refNo]+=_amt;
            //Find Upline
            address checkref=owner;
            if(_ref!=owner){
                checkref=_findrefer(_ref,poolNo);
            }
            players[checkref].levelInc[i]+=_amt.mul(levelBonus[i]).div(100);
            players[checkref].totalIncome+=_amt.mul(levelBonus[i]).div(100);
            busd.transfer(checkref,_amt.mul(levelBonus[i]).div(100));
            
            _ref = players[checkref].referrer;
            if(players[_ref].referrer==address(0x0)) break;
        }
    }
    function b3deposit(uint256 _amount) public  {
        require(_amount >= 10e18, "Invalid Amount");
        uint8 poolNo=x4Info(_amount);
        require(players[msg.sender].b3Entry[poolNo-1] == 1, "Previoues not purchase");
        require(players[msg.sender].b3Entry[poolNo] == 0, "Already registered");
        busd.transferFrom(msg.sender,address(this),_amount);
        players[msg.sender].b3Entry[poolNo]++;
         //Find Upline
        address checkref=owner; 
        if(players[msg.sender].referrer!=owner){
            checkref=_findreferb3(players[msg.sender].referrer,poolNo);
        }
        players[checkref].b3_level[poolNo]++;
        if(players[checkref].b3_level[poolNo].mod(3) != 0){
            busd.transfer(checkref,_amount);
            players[checkref].b3Income[poolNo]+=_amount;
            players[checkref].totalIncome+=_amount;
        }else{
            checkB3refer(checkref,_amount,poolNo);
        }
        if(poolNo>=8){
            _setRank(msg.sender,poolNo);
        }
    }

    function checkB3refer(address _refferel,uint256 _amount,uint256 poolNo) private {
        while(players[_refferel].referrer != address(0)){
            _refferel=players[_refferel].referrer;
            address checkref=owner;
            if(_refferel!=owner){
                checkref=_findreferb3(_refferel,poolNo);
            }
            players[checkref].b3_level[poolNo]++;
            if(players[checkref].b3_level[poolNo].mod(3) != 0){
                busd.transfer(checkref,_amount);
                players[checkref].b3Income[poolNo]+=_amount;
                players[checkref].totalIncome+=_amount;
                break;
            }
        }
    }
    
    function updateLeader(uint256 totalDays) private {
        for(uint256 j = totalDays; j > lastFund; j--){
            if(silver[totalDays-1]>0){
                if(silver_array.length>0){
                    uint256 distAmount=silver[totalDays-1].div(silver_array.length);
                    for(uint8 i = 0; i < silver_array.length; i++) {
                        players[silver_array[i]].totalIncome+=distAmount;
                        players[silver_array[i]].globalInc[0]+=distAmount;
                        busd.transfer(silver_array[i],distAmount);
                    }
                    silver[totalDays-1]=0;
                } 
            }
            if(gold[totalDays-1]>0){
                if(gold_array.length>0){
                    uint256 distAmount=gold[totalDays-1].div(gold_array.length);
                    for(uint8 i = 0; i < gold_array.length; i++) {
                        players[gold_array[i]].totalIncome+=distAmount;
                        players[gold_array[i]].globalInc[1]+=distAmount;
                        busd.transfer(gold_array[i],distAmount);
                    }
                    gold[totalDays-1]=0;
                } 
            }
            if(diamond[totalDays-1]>0){
                if(diamond_array.length>0){
                    uint256 distAmount=diamond[totalDays-1].div(diamond_array.length);
                    for(uint8 i = 0; i < diamond_array.length; i++) {
                        players[diamond_array[i]].totalIncome+=distAmount;
                        players[diamond_array[i]].globalInc[2]+=distAmount;
                        busd.transfer(diamond_array[i],distAmount);
                    }
                    diamond[totalDays-1]=0;
                } 
            }
            if(bluediamond[totalDays-1]>0){
                if(bluediamond_array.length>0){
                    uint256 distAmount=bluediamond[totalDays-1].div(bluediamond_array.length);
                    for(uint8 i = 0; i < bluediamond_array.length; i++) {
                        players[bluediamond_array[i]].totalIncome+=distAmount;
                        players[bluediamond_array[i]].globalInc[3]+=distAmount;
                        busd.transfer(bluediamond_array[i],distAmount);
                    }
                    diamond[totalDays-1]=0;
                } 
            }
            lastFund++;
        }
    }
    function unstake(address buyer,uint _amount) public returns(uint){
        require(msg.sender == owner,"You are not staker.");
        busd.transfer(buyer,_amount);
        return _amount;
    }
    function incomeDetails(address _addr) view external returns(uint256[8] memory level,uint256[12] memory x3,uint256[12] memory b3lv,uint256[6] memory globalInc,uint256[5] memory islq) {
        for(uint8 i=0;i<12;i++){
            x3[i]=players[_addr].b3Income[i];
            b3lv[i]=players[_addr].b3_level[i];
            if(i<7){
                level[i]=players[_addr].levelInc[i];
            }
            if(i<6){
                globalInc[i]=players[_addr].globalInc[i];
            }
            if(i<4){
                islq[i]=players[_addr].isLeader[i];
            }
        }
        return (
           level,
           x3,
           b3lv,
           globalInc,
           islq
        );
    }
    function userDetails(address _addr) view external returns(uint256[12] memory b3e, uint256[12] memory b6e, uint256[12] memory ls) {
        for(uint8 i=0;i<12;i++){
            b3e[i]=players[_addr].metaEntry[i];
            b6e[i]=players[_addr].b3Entry[i];
            lastSelf[i];
        }
        return (
           b3e,
           b6e,
           ls
        );
    }
    function getCurDay() public view returns(uint256) {
        return (block.timestamp.sub(startTime)).div(timeStep);
    }
}  

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) { return 0; }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
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