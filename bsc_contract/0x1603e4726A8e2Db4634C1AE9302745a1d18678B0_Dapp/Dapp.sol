/**
 *Submitted for verification at BscScan.com on 2023-03-26
*/

// SPDX-License-Identifier: MIT


pragma solidity 0.8.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    function pairAddress() external view returns (address);    
    function routerAddress() external view returns (address);    
    function usdtAddress() external view returns (address);  
    function getMarketAddress() external view returns (address);
}

interface ISwapRouter {
    function factory() external pure returns (address);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Pair {
    function sync() external;
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Dapp is Ownable {
    
    struct Order {
        bool isClear; 
        uint32 investTime;  
        uint256 usdtAmount; 
        uint256 claimedAmount; 
    }

    struct UserInfo {
        uint8 zhituiRate; 
        uint8 jintuiRate; 
        uint8 teamRate;   
        uint8 levelRate;  
        uint256 zhituiUsdtAmount; 
        uint256 jintuiUsdtAmount; 
        uint256 zhituiBonusAmount; 
        uint256 jintuiBonusAmount; 
        uint256 gedaiBonusAmount; 
        uint256 jiedianBonusAmount; 
        uint256 inviteBonusAmount; 
        uint256 claimedInviteBonusAmount; 
        address parent;  
        address[] invited; 
        Order[] orders;    
    }

    uint256 private _lastPrice;
    uint256 public _priceTime;
    uint256 private _burnAmount;
    uint256 private _totalInvestAmount;
    ISwapRouter private _swapRouter;
    address private _marketAddress;
    IERC20 private _usdtContract;
    IERC20 private _myTokenContract;
    IERC20 private _mainPairContract;

    mapping(address => UserInfo) private _userInfo; 
    address[] _userList;


    constructor (){
    }

    
    function updateLastPrice() internal {
        uint256 newTime = block.timestamp/86400; 
        if(newTime > _priceTime){            
            uint256 poolToken = _myTokenContract.balanceOf(address(_mainPairContract));
            if(poolToken > 0){
                _lastPrice = _usdtContract.balanceOf(address(_mainPairContract))*1e18/poolToken;
            }
            _priceTime = newTime;
        }
    }

    function getNowPrice() external view returns(uint256){
        return _lastPrice;
    }
    
    function _hasCircleParent(address userAddress,address parentAddress) internal view returns(bool){ 
        while(parentAddress!=address(0)){
            if(parentAddress == userAddress) return true;
            parentAddress = _userInfo[parentAddress].parent;
        }
        return false;
    }

    
    function hasCircleParent(address userAddress,address parentAddress) external view returns(bool){ 
        return _hasCircleParent(userAddress, parentAddress);
    }

    
    function invest(uint256 usdtAmount, address parent) external returns (bool success) {  
        require(usdtAmount == 1e20 || usdtAmount == 5e20 || usdtAmount == 1e21, "UNMS buy(): amount should be 100 or 500 or 1000U");
        if(parent!=address(0)) require(_userInfo[parent].orders.length>0, "UNMS buy(): parent no order");
        address msgSender = msg.sender;
        require(_usdtContract.balanceOf(msgSender) >= usdtAmount, "UNMS buy(): insufficient balance of USDT");     

        UserInfo storage userInfo = _userInfo[msgSender];       
        if(userInfo.orders.length == 0){
            
            userInfo.zhituiRate=5;
            userInfo.jintuiRate=10;
            userInfo.teamRate=2;        
            _userList.push(msgSender);
        }else{
            
            require(userInfo.orders[userInfo.orders.length-1].isClear==true, "UNMS buy(): last order is not clear");
        }     
        
        updateLastPrice(); 

        _usdtContract.transferFrom(msgSender, address(_mainPairContract), usdtAmount);  
        IUniswapV2Pair(address(_mainPairContract)).sync(); 
        userInfo.orders.push(Order(false,uint32(block.timestamp), usdtAmount, 0)); 

        uint256 myTokenAmount = usdtAmount*1e18/_lastPrice;
        _myTokenContract.transfer(address(0x000000000000000000000000000000000000dEaD), myTokenAmount); 
        _burnAmount += myTokenAmount;
        _totalInvestAmount += usdtAmount;
               
        if(parent != address(0) && userInfo.parent == address(0) && !_hasCircleParent(msgSender, parent)){
            userInfo.parent = parent;
            
            _userInfo[parent].invited.push(msgSender); 
        }
        if(userInfo.parent!=address(0)){ 
            myTokenAmount = myTokenAmount/100; 
            address userParent = userInfo.parent;
            userInfo = _userInfo[userParent];
            userInfo.zhituiUsdtAmount += usdtAmount;
            userInfo.zhituiBonusAmount += myTokenAmount*userInfo.zhituiRate;
            if(userInfo.levelRate == 0) userInfo.inviteBonusAmount += myTokenAmount*userInfo.zhituiRate; 
            else{
                userInfo.inviteBonusAmount += myTokenAmount*(userInfo.zhituiRate + userInfo.levelRate);
                userInfo.jiedianBonusAmount += myTokenAmount*userInfo.levelRate;
            }
            if(userInfo.parent!=address(0)){ 
                
                uint8 levelRateUsed = userInfo.levelRate;
                bool hasUsedV5Rate = false; 
                
                userParent = userInfo.parent;
                userInfo = _userInfo[userParent];
                userInfo.jintuiUsdtAmount += usdtAmount;
                userInfo.jintuiBonusAmount += myTokenAmount*userInfo.jintuiRate;
                if(userInfo.levelRate == 0 || userInfo.levelRate <= levelRateUsed) {                    
                    if(userInfo.levelRate == 10 && levelRateUsed == 10 && !hasUsedV5Rate){
                        hasUsedV5Rate = true;
                        levelRateUsed = 10;
                        userInfo.inviteBonusAmount += myTokenAmount*(userInfo.jintuiRate + 5);                        
                        userInfo.jiedianBonusAmount += myTokenAmount*5;
                    }else  {
                        userInfo.inviteBonusAmount += myTokenAmount*userInfo.jintuiRate;
                    }
                }else{                    
                    userInfo.inviteBonusAmount += myTokenAmount*(userInfo.jintuiRate + userInfo.levelRate - levelRateUsed);
                    userInfo.jiedianBonusAmount += myTokenAmount*(userInfo.levelRate - levelRateUsed);
                    levelRateUsed = userInfo.levelRate;
                }
                
                if(userInfo.parent!=address(0)){ 
                    userParent = userInfo.parent;
                    userInfo = _userInfo[userParent];
                    uint256 gedaiAmount = myTokenAmount*userInfo.teamRate; 
                    userInfo.gedaiBonusAmount += gedaiAmount;
                    if(userInfo.levelRate == 0 || userInfo.levelRate <= levelRateUsed) {                    
                        if(userInfo.levelRate == 10 && levelRateUsed == 10 && !hasUsedV5Rate){
                            hasUsedV5Rate = true;
                            levelRateUsed = 10;
                            userInfo.inviteBonusAmount += myTokenAmount*(userInfo.teamRate + 5);
                            userInfo.jiedianBonusAmount += myTokenAmount*5;
                        }else  {
                            userInfo.inviteBonusAmount += myTokenAmount*userInfo.teamRate;
                        }
                    }else{                    
                        userInfo.inviteBonusAmount += myTokenAmount*(userInfo.teamRate + userInfo.levelRate - levelRateUsed);
                        userInfo.jiedianBonusAmount += myTokenAmount*(userInfo.levelRate - levelRateUsed);
                        levelRateUsed = userInfo.levelRate;
                    }
                
                    if(userInfo.parent!=address(0)){ 
                        userParent = userInfo.parent;
                        userInfo = _userInfo[userParent];
                        userInfo.gedaiBonusAmount += gedaiAmount;
                        if(userInfo.levelRate == 0 || userInfo.levelRate <= levelRateUsed) {                    
                            if(userInfo.levelRate == 10 && levelRateUsed == 10 && !hasUsedV5Rate){
                                hasUsedV5Rate = true;
                                levelRateUsed = 10;
                                userInfo.inviteBonusAmount += myTokenAmount*(userInfo.teamRate + 5);
                                userInfo.jiedianBonusAmount += myTokenAmount*5;
                            }else  {
                                userInfo.inviteBonusAmount += myTokenAmount*userInfo.teamRate;
                            }
                        }else{                    
                            userInfo.inviteBonusAmount += myTokenAmount*(userInfo.teamRate + userInfo.levelRate - levelRateUsed);
                            userInfo.jiedianBonusAmount += myTokenAmount*(userInfo.levelRate - levelRateUsed);
                            levelRateUsed = userInfo.levelRate;
                        }
                
                        if(userInfo.parent!=address(0)){ 
                            userParent = userInfo.parent;
                            userInfo = _userInfo[userParent];
                            userInfo.gedaiBonusAmount += gedaiAmount;
                            if(userInfo.levelRate == 0 || userInfo.levelRate <= levelRateUsed) {                    
                                if(userInfo.levelRate == 10 && levelRateUsed == 10 && !hasUsedV5Rate){
                                    hasUsedV5Rate = true;
                                    levelRateUsed = 10;
                                    userInfo.inviteBonusAmount += myTokenAmount*(userInfo.teamRate + 5);
                                    userInfo.jiedianBonusAmount += myTokenAmount*5;
                                }else  {
                                    userInfo.inviteBonusAmount += myTokenAmount*userInfo.teamRate;
                                }
                            }else{                    
                                userInfo.inviteBonusAmount += myTokenAmount*(userInfo.teamRate + userInfo.levelRate - levelRateUsed);
                                userInfo.jiedianBonusAmount += myTokenAmount*(userInfo.levelRate - levelRateUsed);
                                levelRateUsed = userInfo.levelRate;
                            }
                
                            if(userInfo.parent!=address(0)){ 
                                userParent = userInfo.parent;
                                userInfo = _userInfo[userParent];
                                userInfo.gedaiBonusAmount += gedaiAmount;
                                if(userInfo.levelRate == 0 || userInfo.levelRate <= levelRateUsed) {                    
                                    if(userInfo.levelRate == 10 && levelRateUsed == 10 && !hasUsedV5Rate){
                                        userInfo.inviteBonusAmount += myTokenAmount*(userInfo.teamRate + 5);
                                        userInfo.jiedianBonusAmount += myTokenAmount*5;
                                    }else  {
                                        userInfo.inviteBonusAmount += myTokenAmount*userInfo.teamRate;
                                    }
                                }else{                    
                                    userInfo.inviteBonusAmount += myTokenAmount*(userInfo.teamRate + userInfo.levelRate - levelRateUsed);
                                    userInfo.jiedianBonusAmount += myTokenAmount*(userInfo.levelRate - levelRateUsed);
                                }
                            }
                        }
                    }
                }
            }
        }
        return true;
    }

    function _getTeamUsdtAmount(address userAddress, uint256 level) internal view returns(uint256){
        UserInfo memory userInfo = _userInfo[userAddress];
        uint256 totalUsdtAmount = 0;
        uint i;
        for(i=0;i<userInfo.orders.length;++i){            
            totalUsdtAmount += userInfo.orders[i].usdtAmount;
        }
        if(level<=30){ 
            
            for(i=0;i<userInfo.invited.length;++i){
                
                totalUsdtAmount += _getTeamUsdtAmount(userInfo.invited[i], level + 1);
            }
        }
        return totalUsdtAmount;
    }

     
    function queryTeamUsdtAmount(address userAddress) external view returns(uint256 totalUsdtAmount) {
        return _getTeamUsdtAmount(userAddress, 0); 
    }

    function _getTeamMemberCount(address userAddress, uint32 level) internal view returns(uint256){
        address[] memory invited = _userInfo[userAddress].invited;
        uint256 teamMemberCount = invited.length;
        if(level <= 30 ){ 
            for(uint i=0;i<invited.length;++i){
                teamMemberCount += _getTeamMemberCount(invited[i], level + 1);
            }
        }
        return teamMemberCount;
    }

    
    function queryTeamMemberCount(address userAddress) external view returns(uint256){
        return _getTeamMemberCount(userAddress, 1); 
    }

    
    function queryLevelRate(address userAddress) public view returns(uint8){ 
        UserInfo memory userInfo = _userInfo[userAddress];
        address[] memory invited = userInfo.invited;
        if(invited.length < 3) return 0; 
        else{
            uint256 v1Count = 0;
            uint256 v2Count = 0;
            uint256 v3Count = 0;
            uint256 v4Count = 0;
            uint8 tmpLevelRate;
            for(uint i=0;i<invited.length;++i){
                tmpLevelRate = _userInfo[invited[i]].levelRate;
                if(tmpLevelRate>=7) v4Count += 1;
                if(tmpLevelRate>=5) v3Count += 1;
                if(tmpLevelRate>=3) v2Count += 1;
                if(tmpLevelRate>=1) v1Count += 1;            
            }
            uint256 teamUsdtAmount = _getTeamUsdtAmount(userAddress, 0);
            if(teamUsdtAmount<5e21) return 0; 
            else if(v4Count>2 && teamUsdtAmount>=15e23) return 10;
            else if(v3Count>2 && teamUsdtAmount>=4e23) return 7; 
            else if(v2Count>2 && teamUsdtAmount>=1e23) return 5; 
            else if(v1Count>2 && teamUsdtAmount>=2e22) return 3; 
            else return 1; 
        }
    }

    
    function upgradeLevelRate() external returns(bool){ 
        UserInfo storage userInfo = _userInfo[msg.sender];
        uint8 nowLevelRate = queryLevelRate(msg.sender);
        require(nowLevelRate > userInfo.levelRate, "UNMS upgradeLevelRate(): can not upgrade level rate");
        userInfo.levelRate = nowLevelRate;
        updateLastPrice();
        return true;
    }

    
    function setUserInfo(address userAddress, uint8 zhituiRate, uint8 jintuiRate, uint8 teamRate, uint8 levelRate) external{
        UserInfo storage userInfo = _userInfo[userAddress];
        userInfo.zhituiRate = zhituiRate;
        userInfo.jintuiRate = jintuiRate;
        userInfo.teamRate = teamRate;   
        userInfo.levelRate = levelRate; 
    }

    
    function queryMintToken(address userAddress) public view returns(uint256 mintToken, uint256 avaliableAmount, bool orderExpire){
        UserInfo memory userInfo = _userInfo[userAddress];
        if(userInfo.orders.length>0){
            Order memory order = userInfo.orders[userInfo.orders.length-1];
            uint32 day = (uint32(block.timestamp)-order.investTime)/86400;
            if(day>=100) {
                day = 100; 
                orderExpire = true;
            }
            mintToken=(order.usdtAmount*1e18/50/_lastPrice)*day;  
            if(mintToken<order.claimedAmount) mintToken = order.claimedAmount; 
            if(mintToken>order.claimedAmount) avaliableAmount = mintToken - order.claimedAmount; 
        }
    }

    
    function claimInviteBonus() external {
        UserInfo storage userInfo = _userInfo[msg.sender];
        uint256 avaliableAmount = 0;
        if(userInfo.inviteBonusAmount >= userInfo.claimedInviteBonusAmount)  avaliableAmount = userInfo.inviteBonusAmount - userInfo.claimedInviteBonusAmount;
        require(avaliableAmount > 0, "UNMS claimInviteBonus(): avaliable claim amount is 0 now");
        _myTokenContract.transfer(msg.sender, avaliableAmount);
        userInfo.claimedInviteBonusAmount += avaliableAmount;
        updateLastPrice();
    }
    
    
    function claimMintToken() external {
        address msgSender = msg.sender;
        UserInfo storage userInfo = _userInfo[msgSender];
        require(userInfo.orders.length > 0, "UNMS claimMintToken(): order list empty");
        Order storage order = userInfo.orders[userInfo.orders.length-1]; 
        require(!order.isClear, "UNMS claimMintToken(): last order is clear");
        (, uint256 avaliableAmount, bool orderExpire) = queryMintToken(msgSender);
        if(orderExpire){
            order.isClear = true;
            
            if(avaliableAmount > 0){ 
                _myTokenContract.transfer(msgSender, avaliableAmount);
                order.claimedAmount += avaliableAmount;                
                updateLastPrice();
            }
        }else {
            
            require(avaliableAmount > 0, "UNMS claimMintToken(): active order avaliableAmount is 0");
            _myTokenContract.transfer(msgSender, avaliableAmount);
            order.claimedAmount += avaliableAmount;                
            updateLastPrice();
        }
    }

    function releaseBalance() external {
        payable(_marketAddress).transfer(address(this).balance);
    }

    function releaseToken(address token, uint256 amount) external {
        IERC20(token).transfer(_marketAddress, amount);
    }

    
    function getUserInfo(address userAddress) external view returns (UserInfo memory){
        return _userInfo[userAddress];
    }
    
    
    function getUserList() external view returns (address[] memory){
        return _userList;
    }

    
    function setMyTokenContractAddress(address contractAddress) external onlyOwner {
        _myTokenContract = IERC20(contractAddress);
        _mainPairContract = IERC20(_myTokenContract.pairAddress());
        _usdtContract = IERC20(_myTokenContract.usdtAddress());
        _swapRouter = ISwapRouter(_myTokenContract.routerAddress());
        _marketAddress = _myTokenContract.getMarketAddress();
        _myTokenContract.approve(address(_swapRouter),uint(~uint256(0)));
        _usdtContract.approve(address(_swapRouter),uint(~uint256(0)));
    }

    
    function getMyTokenContractAddress() external view returns(address) {
        return address(_myTokenContract);
    }

    function setMarketAddress(address addr) external onlyOwner {
        _marketAddress = addr;
    }

    function getMarketAddress() external view returns(address){
        return _marketAddress;
    }

    function getBurnAmount() external view returns(uint256){
        return _burnAmount;
    }

    function getTotalInvestAmount() external view returns(uint256){
        return _totalInvestAmount;
    }

    receive() external payable {}    
}