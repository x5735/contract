// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "./SafeMath.sol";

interface BEP20Token
{
    function mintTokens(address receipient, uint256 tokenAmount) external returns(bool);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function balanceOf(address user) external view returns(uint256);
    function totalSupply() external view returns (uint256);
    function maxsupply() external view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _value) external returns(bool);
    function burn_internal(uint256 _value, address _to) external returns (bool);
}

contract Xakpot {
    BEP20Token public rewardToken;

    AggregatorV3Interface internal priceFeed;
    using SafeMath for uint;
    using SafeMath for uint256;
    struct User{
        address stockiest;
        string userType;
        uint[] gameIDs;
        uint comission;
        uint withdrawan;
        bool isRegisterd;
    }

    struct Game{
        uint gameID;
        uint gameTotalInvest;
        uint winingNo;
        bool numberPicked;
    }

    struct Distributor{
        DistributorDeposit[] depositInfo;
        uint[10] dnumbers;
    }

    struct DistributorDeposit{
        uint time;
        uint totalAmountBNB;
        uint totalAmountToken;
    }
   
    string[3] public userTypes;
    address payable public admin;
    address public creator;
    address payable private defaultStockiest;
    bool private IsInitinalized;
    uint public time_stamp;
    uint public subRefundTime;
    uint public lastDistribution;
    uint public tokenPriceUSD;
    uint private contractFee;
    uint private baseDivider;
    uint public gameNo;
    bool private drawingPhase;
    uint public totalSupply;
    uint[10] number;
    uint public min_amount;
    uint public min_amountdistributor;


    mapping(address => User) public users;
    mapping(uint => mapping(address => uint[10])) public userHistory;
    mapping(uint => mapping(address => uint[10])) public distributorHistory;
    mapping(uint => mapping(address => uint[10])) public distributorOldHistory;
    mapping(uint => mapping(address => uint[])) public winings;
    mapping (uint =>address[] )public distributorAddress;
    mapping(uint => mapping(address =>bool)) public claimInfo;
    mapping(uint => mapping(address => uint)) public commision;
    mapping(uint => Game) public games;


    modifier adminOnly() {
        require(msg.sender == admin, "admin: wut?");
        _;
    }
    modifier creatorOnly() {
        require(msg.sender == creator, "admin: wut?");
        _;
    }

    modifier onlyDistributor() {
        string memory a = users[msg.sender].userType;
        string memory b = userTypes[1];
        require(keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
        _;
    }
    modifier onlyStockiest() {
            string memory a = users[msg.sender].userType;
            string memory b = userTypes[2];
            require(keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
            _;
        }
    
function initialize(address payable _admin,address payable _defaultStockiest,BEP20Token _token,address _creator) public {
         require (IsInitinalized == false,"Already Started");
         userTypes = ['player','distributor','stockiest'];
         time_stamp =  11 hours + 58 minutes;
         subRefundTime =  20 minutes;
         lastDistribution = block.timestamp;
         priceFeed = AggregatorV3Interface(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);
         admin = _admin;
         creator = _creator;
         defaultStockiest = _defaultStockiest;
         users[_defaultStockiest].userType =userTypes[2];
         users[_defaultStockiest].isRegisterd = true;
         tokenPriceUSD = 1000000;
         baseDivider = 1000;
         gameNo = 1;
         rewardToken = _token;
         min_amount = 10e8;
         min_amountdistributor = 100e8;
         IsInitinalized = true;

}

function register(uint _index) public returns(bool){
    User storage user = users[msg.sender];
    require(_index< userTypes.length,"You select a wrong package");
    if(_index == 1){
        user.userType = userTypes[_index];
        user.stockiest = defaultStockiest;
    }
    else {
         user.userType = userTypes[_index];
    }
    user.isRegisterd = true;
    return true;

}

function makeDistributor(address _user) public onlyStockiest returns(bool) {
    string memory c = userTypes[0];
    string memory d = users[_user].userType;
    require(keccak256(abi.encodePacked((d))) == keccak256(abi.encodePacked((c))),"User  need to register first as player");
    users[_user].userType = userTypes[1];
    users[_user].stockiest = msg.sender;
    return true;
}

function buy(uint _value) payable public onlyDistributor returns(bool){
    require(block.timestamp<= lastDistribution.add(time_stamp),"time is over");
    require(uint256(TotalusdPrice(int(msg.value))) >=_value, "USD do not  match");
    require(_value >=min_amountdistributor, "Min amount is 100 USD");
    uint token = _value;
    uint amount = token.div(10);
    uint count = distributorHistory[gameNo][msg.sender].length;
    for(uint i=0; i<count;i++){
        uint bal = distributorHistory[gameNo][msg.sender][i];
        bal = bal.add(amount);
        distributorHistory[gameNo][msg.sender][i] = bal;
    }
    games[gameNo].gameID = gameNo;
    games[gameNo].gameTotalInvest = games[gameNo].gameTotalInvest.add(token);
    bool check = findInArray(msg.sender);
    if(check == false){
    users[msg.sender].gameIDs.push(gameNo);
    distributorAddress[gameNo].push(msg.sender);
    claimInfo[gameNo][msg.sender] = false;
    }
    totalSupply = totalSupply.add(token);
    uint comission1 = token.mul(10).div(100);
    commision[gameNo][msg.sender] = commision[gameNo][msg.sender].add(comission1);
    address upline = users[msg.sender].stockiest;
    uint comission2 = token.mul(1).div(100);
    commision[gameNo][upline] = commision[gameNo][upline].add(comission2);
    
    
    return true;
}

function refund() public onlyDistributor returns(bool){
    require(block.timestamp <= lastDistribution.add(time_stamp).sub(subRefundTime),"refund portal is closed");
    uint[10] memory _dnumbers = distributorHistory[gameNo][msg.sender];
    uint minAmount = min(_dnumbers);
    require(minAmount > 0,"No amount to refund");
    for(uint i=0; i<distributorHistory[gameNo][msg.sender].length;i++){
        uint bal = distributorHistory[gameNo][msg.sender][i];
        bal = bal.sub(minAmount);
        distributorHistory[gameNo][msg.sender][i] = bal;
    }
    uint refundtoken = minAmount.mul(10);
    games[gameNo].gameTotalInvest = games[gameNo].gameTotalInvest.sub(refundtoken);
    totalSupply = totalSupply.sub(refundtoken);
    uint comission1 = refundtoken.mul(10).div(100);
    commision[gameNo][msg.sender] = commision[gameNo][msg.sender].sub(comission1);
    address upline = users[msg.sender].stockiest;
    uint comission2 = refundtoken.mul(1).div(100);
    commision[gameNo][upline] = commision[gameNo][upline].sub(comission2);
    uint refundAmountBNB = calculateBnbReceived(refundtoken);
    payable(msg.sender).transfer(refundAmountBNB);
    return true;


}

function min(uint256[10] memory numbers) private pure returns (uint256) {
     require(numbers.length > 0); // throw an exception if the condition is not met
        uint256 minNumber; // default 0, the lowest value of `uint256`

        for (uint256 i = 0; i < numbers.length; i++) {
           if(i==0){
                if (minNumber <= numbers[i]) {
                    minNumber = numbers[i];
                }
           }else if (minNumber > numbers[i]){
                    minNumber = numbers[i]; 
                } 
        }

        return minNumber;
    }
function playerBuy(address _distributer, uint _index,uint count) payable public returns(bool){
    string memory a = users[msg.sender].userType;
    string memory b = userTypes[1];
    require(keccak256(abi.encodePacked((a))) != keccak256(abi.encodePacked((b))),"Distributor can't buy");
    require(users[msg.sender].isRegisterd == true,"Register First");
    require(block.timestamp<= lastDistribution.add(time_stamp),"time is over");
    uint amount = distributorHistory[gameNo][_distributer][_index];
    uint token =min_amount.mul(count);
    require(uint256(TotalusdPrice(int(msg.value))) >= token, 'required min 10 USD!');
    require(token<=amount,"Distributor don't have funds" );
    userHistory[gameNo][msg.sender][_index] = userHistory[gameNo][msg.sender][_index].add(token); 
    distributorHistory[gameNo][_distributer][_index] = distributorHistory[gameNo][_distributer][_index].sub(token);
    bool check = findInArray(msg.sender);
    if(check == false ){
        users[msg.sender].gameIDs.push(gameNo);
        claimInfo[gameNo][msg.sender] = false;
    }
    return true;
}

function claimReward(uint _gameID) public returns(bool) {
require(_gameID != gameNo,"game is currently in progress");
require(claimInfo[_gameID][msg.sender] == false, "You already Claim Your Reward");
    uint amount = rewardInfo(msg.sender,_gameID);
    uint withdrawn = calculateBnbReceived(amount);
    require(amount != 0 , "You don't Win any amount");
    
    payable(msg.sender).transfer(withdrawn);
    claimInfo[_gameID][msg.sender] = true;
    
    return true;
 
}

function rewardInfo(address _user,uint _gameID) public view returns(uint _winingAmount){
    string memory a = users[_user].userType;
    string memory b = userTypes[1];
    if(_gameID != gameNo){
        if((keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))))){
            for(uint i=0; i<10;i++){
                 if(i==games[_gameID].winingNo){
                    uint bal = distributorHistory[_gameID][_user][i];
                    return _winingAmount = (bal.mul(8));
                }
            }
        } else{ 
            for(uint j=0; j<10;j++){
                if(j==games[_gameID].winingNo){
                    uint bal = userHistory[_gameID][_user][j];
                    return _winingAmount = (bal.mul(8));
                }
            }
        }


    }
}


function withdraw() public returns(bool){
    uint amount = getCommison(msg.sender);
    require(amount > 0,"No Funds to withdraw");
    users[msg.sender].withdrawan =  users[msg.sender].withdrawan.add(amount);
    uint withdrawAmount = calculateBnbReceived(amount);
    payable(msg.sender).transfer(withdrawAmount);
    return true;

}

function getCommison(address _user) public view returns(uint){
    uint count = users[_user].gameIDs.length;
    uint _amount;
    for(uint i=0;i<count;i++){
      uint id = users[_user].gameIDs[i];
      if(id==gameNo){
        break;
      }
    uint bal = commision[id][_user];
    _amount = _amount.add(bal);

    }
    uint withdrawAmount = _amount.sub(users[_user].withdrawan);
    return withdrawAmount;
     
}

function reset() external creatorOnly {
     require(block.timestamp >= lastDistribution.add(time_stamp),"game is not end yet");
        pickWiningNo();
        uint amount = games[gameNo].gameTotalInvest;
        if(amount > 0){
        uint adminFee = amount.mul(7).div(100);
        uint adminFeeBNB = calculateBnbReceived(adminFee);
        uint newAmount = amount.mul(2).div(100);
        newAmount = newAmount*1e2;
        uint _totalSupply = rewardToken.totalSupply();
        if(_totalSupply>0){
        uint per = (newAmount/_totalSupply).mul(100);
        per = per/1e8;
        uint tokenIncrement = tokenPriceUSD.mul(per).div(10000);
        tokenPriceUSD = tokenPriceUSD.add(tokenIncrement);
        }
        admin.transfer(adminFeeBNB);
        }
    
        gameNo = gameNo.add(1);
        lastDistribution = block.timestamp;
        drawingPhase = false;
        // lastDrawTimestamp = block.timestamp;
       
    }

function calculateBnbReceived(uint _token) public view returns(uint ){
        uint tokenInUsd = _token;
        uint bnbprice = getCalculatedBnbRecieved(tokenInUsd);
        return bnbprice;
    }

function pickWiningNo() internal{
    require(block.timestamp >= lastDistribution.add(time_stamp),"game is not end yet");
    require( games[gameNo].numberPicked == false, "number is picked already");
    uint index = random() % 10;
    games[gameNo].winingNo = index;
    games[gameNo].numberPicked = true;
        
}
function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp,number.length)));
    }

function findInArray(address _user) private view returns (bool){
        string memory a = users[_user].userType;
        string memory b = userTypes[1];
        string memory c = userTypes[0];
        if((keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))))){
            if(users[_user].gameIDs.length > 0){
            for(uint i = 0 ; i<users[_user].gameIDs.length;i++){
                uint count = users[_user].gameIDs[i];
                if(count==gameNo){
                    return true;
                }
            }
            }
        }if((keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((c))))){
             if(users[_user].gameIDs.length > 0){
            for(uint j = 0 ; j<users[_user].gameIDs.length;j++){
                uint count = users[_user].gameIDs[j];
                if(count==gameNo){
                    return true;
                }
            }
             }
        }

        return false;
}

function getDistributorData(address _user,uint _gameid) public view returns(uint[10] memory _numbers){
      _numbers =   distributorHistory[_gameid][_user];
      return _numbers;
}



function getLatestPrice() public view returns (int) {
    (
        /* uint80 roundID */,
        int price,
        /*uint startedAt */,
        /*uint timeStamp*/,
        /* uint80 answeredInRound*/
    ) = priceFeed.latestRoundData();
    return price;
}

function TotalusdPrice(int _amount) public view returns (int) {
    int usdt = getLatestPrice();
    return (usdt * _amount)/1e18;
}

function getCalculatedBnbRecieved(uint _amount) public view returns(uint) {
    uint usdt = uint(getLatestPrice());
    uint recieved_bnb = (_amount*1e18/usdt*1e18)/1e18;
    return recieved_bnb;
    }

function getshowInfo(address _user,uint _gameid) public view returns(uint[10] memory _numbers){
    string memory a = users[_user].userType;
    string memory b = userTypes[1];
    if((keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))))){
      _numbers  = distributorHistory[_gameid][_user];
    }else{
      _numbers  = userHistory[_gameid][_user];
    }
    return _numbers;
}



function getUserData(address _user,uint _gameid) public view returns(uint[10] memory _numbers){
      _numbers =   userHistory[_gameid][_user];
      return _numbers;
}


function getUserGameID(address _user,uint _index) public view returns(uint _game_id){
    uint length = getUsergameIdLength(_user);
    if(length > 0){
        _game_id = users[_user].gameIDs[_index];
    }
    
    return _game_id;
}

function getUsergameIdLength(address _user) public view returns(uint _count){
        _count = users[_user].gameIDs.length;
        return _count;
}

function getDistributorAddressLength(uint _gameID) public view returns(uint _count){
    _count = distributorAddress[_gameID].length;
}






}
interface AggregatorV3Interface {

  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version()external view returns (uint);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)external view returns (
      uint80 roundId,
      int256 answer,
      uint startedAt,
      uint updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()external view returns (
      uint80 roundId,
      int256 answer,
      uint startedAt,
      uint updatedAt,
      uint80 answeredInRound
    );

}