/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
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
        require(_owner == msg.sender, "!o");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "n0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface ISwapPair {
    function sync() external;
}

abstract contract AbsPool is Ownable {
    struct PoolInfo {
        uint256 queueReward;
        uint256 poolReward;
        address[] accounts;
        uint256[] accountTimes;
        uint256 rewardTime;
        uint256 queueLen;
        uint256 queueRewardIndex;
        uint256 accPoolReward;
    }

    struct UserInfo {
        uint256 queueUsdtReward;
        uint256 poolUsdtReward;
        uint256 inviteUsdtReward;
        uint256 tokenReward;
        bool active;
        uint256 claimedToken;
        uint256 teamAmount;
    }

    struct UserPoolInfo {
        uint256 joinNum;
        uint256 queueRewardNum;
        bool cal;
    }

    uint256 public _poolLen = 1;
    mapping(uint256 => address) private _poolCreator;
    mapping(uint256 => uint256) private _poolCreatorFeeAmount;
    mapping(uint256 => uint256) private _poolId;
    mapping(uint256 => mapping(uint256 => PoolInfo)) private _poolInfo;

    mapping(address => UserInfo) private _userInfo;
    mapping(uint256 => mapping(address => uint256)) public _userLastPid;
    mapping(uint256 => mapping(uint256 => mapping(address => UserPoolInfo))) private _userPoolInfo;

    address private immutable _usdtAddress;
    address private _tokenAddress;
    uint256 private _perUsdtAmount;
    uint256 private _perTokenAmount;
    uint256 public _refreshDuration = 24 hours;
    uint256 public _refreshNum = 1000;

    uint256 public _queueRewardLen = 2;
    uint256 public _queueRewardRate = 6500;
    uint256 public _poolRewardRate = 1000;

    mapping(uint256 => uint256) public _teamRewardRate;
    mapping(uint256 => uint256) public _teamRewardCondition;

    uint256 public _inviteRate = 500;
    uint256 public _buybackRate = 500;
    uint256 public _foundationRate = 300;
    address public _foundationAddress;

    uint256 public _lastRewardRate = 6000;
    uint256 public _inviteRewardRate = 100;

    address public _tokenLPPair;

    mapping(address => address) public _invitor;
    mapping(address => address[]) public _binder;
    mapping(address => uint256) private _teamNum;
    uint256 private constant _invitorLen = 9;

    uint256 public _showAccountLen = 3;
    address public _defaultInvitor;

    uint256 private _poolCreatePrice;
    uint256 public _maxPoolLen = 100;

    constructor(
        address USDTAddress, address TokenAddress, address TokenLPPair,
        address DefaultInvitor, address FoundationAddress
    ){
        _usdtAddress = USDTAddress;
        _tokenAddress = TokenAddress;
        _tokenLPPair = TokenLPPair;
        _defaultInvitor = DefaultInvitor;
        _foundationAddress = FoundationAddress;

        uint256 usdtUnit = 10 ** IERC20(USDTAddress).decimals();
        _perUsdtAmount = 100 * usdtUnit;
        _poolCreatePrice = 5000 * usdtUnit;

        uint256 tokenUnit = 10 ** IERC20(TokenAddress).decimals();
        _perTokenAmount = 2 * tokenUnit;

        _teamRewardRate[1] = 100;
        _teamRewardRate[2] = 200;
        _teamRewardRate[3] = 300;
        _teamRewardRate[4] = 400;
        _teamRewardRate[5] = 500;
        _teamRewardRate[6] = 600;
        _teamRewardRate[7] = 800;
        _teamRewardRate[8] = 1000;
        _teamRewardRate[9] = 1200;

        _teamRewardCondition[1] = 100 * usdtUnit;
        _teamRewardCondition[2] = 500 * usdtUnit;
        _teamRewardCondition[3] = 2500 * usdtUnit;
        _teamRewardCondition[4] = 12500 * usdtUnit;
        _teamRewardCondition[5] = 62500 * usdtUnit;
        _teamRewardCondition[6] = 312500 * usdtUnit;
        _teamRewardCondition[7] = 1562500 * usdtUnit;
        _teamRewardCondition[8] = 5000000 * usdtUnit;
        _teamRewardCondition[9] = 10000000 * usdtUnit;

        _userInfo[DefaultInvitor].active = true;
    }

    function join(uint256 index, address invitor) external {
        require(index < _poolLen, "invalid pool");
        address account = msg.sender;

        uint256 poolId = _poolId[index];
        PoolInfo storage poolInfo = _poolInfo[index][poolId];
        uint256 blockTime = block.timestamp;
        if (poolInfo.rewardTime > 0 && poolInfo.rewardTime <= blockTime) {
            _calReward(index, poolId);
            calUserPoolInfo(account, index, poolId);
            poolId += 1;
            _poolId[index] = poolId;
            poolInfo = _poolInfo[index][poolId];
        }
        poolInfo.rewardTime = blockTime + _refreshDuration;

        UserInfo storage userInfo = _userInfo[account];
        if (!userInfo.active) {
            if (!_userInfo[invitor].active) {
                invitor = _defaultInvitor;
            }
            _invitor[account] = invitor;
            _binder[invitor].push(account);
            for (uint256 i; i < _invitorLen;) {
                _teamNum[invitor] += 1;
                invitor = _invitor[invitor];
                if (address(0) == invitor) {
                    break;
                }
            unchecked{
                ++i;
            }
            }
            userInfo.active = true;
        }

        poolInfo.accounts.push(account);
        poolInfo.accountTimes.push(blockTime);

        uint256 perUsdtAmount = _perUsdtAmount;
        _takeToken(_usdtAddress, account, address(this), perUsdtAmount);

        _userLastPid[index][account] = poolId;
        _userPoolInfo[index][poolId][account].joinNum += 1;

        poolInfo.queueReward += perUsdtAmount * _queueRewardRate / 10000;
        poolInfo.queueLen += 1;
        if (poolInfo.queueLen >= _queueRewardLen) {
            poolInfo.queueLen = 0;
            address queueRewardAccount = poolInfo.accounts[poolInfo.queueRewardIndex];
            _userInfo[queueRewardAccount].queueUsdtReward += poolInfo.queueReward;
            poolInfo.queueReward = 0;
            poolInfo.queueRewardIndex += 1;
            _userPoolInfo[index][poolId][queueRewardAccount].queueRewardNum += 1;
        }

        poolInfo.poolReward += perUsdtAmount * _poolRewardRate / 10000;

        uint256 buybackUsdt = perUsdtAmount * _buybackRate / 10000;
        if (buybackUsdt > 0) {
            address tokenLPPair = _tokenLPPair;
            IERC20(_usdtAddress).transfer(tokenLPPair, buybackUsdt);
            ISwapPair(tokenLPPair).sync();
        }

        uint256 foundationAmount = perUsdtAmount * _foundationRate / 10000;
        address poolCreator = _poolCreator[index];
        if (address(0) != poolCreator) {
            uint256 creatorFeeAmount = foundationAmount / 2;
            _giveToken(_usdtAddress, poolCreator, creatorFeeAmount);
            foundationAmount -= creatorFeeAmount;
            _poolCreatorFeeAmount[index] += creatorFeeAmount;
        }
        _giveToken(_usdtAddress, _foundationAddress, foundationAmount);

        uint256 inviteAmount = perUsdtAmount * _inviteRate / 10000;
        invitor = _invitor[account];
        if (invitor == address(0)) {
            invitor = _defaultInvitor;
        }
        _userInfo[invitor].inviteUsdtReward += inviteAmount;

        address current = account;
        for (uint256 i; i < _invitorLen;) {
            invitor = _invitor[current];
            if (address(0) == invitor) {
                break;
            }
            _userInfo[invitor].teamAmount += perUsdtAmount;
            current = invitor;
        unchecked{
            ++i;
        }
        }

        _calTeamReward(account, perUsdtAmount);

        if (poolInfo.accounts.length >= _refreshNum) {
            _calReward(index, poolId);
            calUserPoolInfo(account, index, poolId);
            poolId += 1;
            _poolId[index] = poolId;
        }
    }

    function calUserPoolInfo(address account, uint256 index, uint256 poolId) public {
        PoolInfo storage poolInfo = _poolInfo[index][poolId];
        if (poolInfo.accPoolReward == 0) {
            return;
        }
        UserPoolInfo storage userPoolInfo = _userPoolInfo[index][poolId][account];
        if (userPoolInfo.cal) {
            return;
        }
        userPoolInfo.cal = true;
        uint256 loseNum = userPoolInfo.joinNum - userPoolInfo.queueRewardNum;
        address[] storage accounts = poolInfo.accounts;
        uint256 accountsLen = accounts.length;
        if (account == accounts[accountsLen - 1]) {
            loseNum--;
        }
        _userInfo[account].tokenReward += loseNum * _perTokenAmount;
    }

    function _calTeamReward(
        address current, uint256 usdtAmount
    ) private {
        uint256 teamTotalReward = _teamRewardRate[_invitorLen] * usdtAmount / 10000;
        uint256 lastRewardLevel;
        uint256 teamReward;
        for (uint256 i; i < _invitorLen; ++i) {
            address invitor = _invitor[current];
            if (address(0) == invitor) {
                break;
            }
            current = invitor;
            uint256 invitorLevel = _getInvitorLevel(invitor, lastRewardLevel);
            if (invitorLevel <= lastRewardLevel || invitorLevel <= i) {
                continue;
            }
            uint256 rewardRate = _teamRewardRate[invitorLevel] - _teamRewardRate[lastRewardLevel];
            teamReward = rewardRate * usdtAmount / 10000;
            _userInfo[invitor].inviteUsdtReward += teamReward;
            teamTotalReward -= teamReward;
            lastRewardLevel = invitorLevel;
        }
        _userInfo[_defaultInvitor].inviteUsdtReward += teamTotalReward;
    }

    function _getInvitorLevel(
        address invitor, uint256 lowLevel
    ) private view returns (uint256){
        uint256 teamAmount = _userInfo[invitor].teamAmount;
        if (lowLevel == _invitorLen) {
            lowLevel = _invitorLen - 1;
        }
        for (uint256 i = _invitorLen; i > lowLevel;) {
            if (teamAmount >= _teamRewardCondition[i]) {
                return i;
            }
        unchecked{
            --i;
        }
        }
        return 0;
    }

    function calReward(uint256 index) public {
        uint256 poolId = _poolId[index];
        PoolInfo storage poolInfo = _poolInfo[index][poolId];
        uint256 blockTime = block.timestamp;
        if (poolInfo.rewardTime > 0 && poolInfo.rewardTime <= blockTime) {
            _calReward(index, poolId);
            poolId += 1;
            _poolId[index] = poolId;
        }
    }

    function _calReward(uint256 index, uint256 pid) private {
        PoolInfo storage poolInfo = _poolInfo[index][pid];
        if (poolInfo.accPoolReward > 0) {
            return;
        }
        uint256 poolReward = poolInfo.poolReward;
        poolInfo.accPoolReward = poolReward;

        address[] storage accounts = poolInfo.accounts;
        uint256 accountLen = accounts.length;
        address lastAccount = accounts[accountLen - 1];
        uint256 buybackUsdt = poolInfo.queueReward;
        if (accounts.length >= _refreshNum) {
            uint256 lastReward = poolReward * _lastRewardRate / 10000;
            _userInfo[lastAccount].poolUsdtReward += lastReward;
            buybackUsdt += poolReward - lastReward;

            uint256 perInviteUsdt = poolReward * _inviteRewardRate / 10000;
            if (perInviteUsdt > 0) {
                address current = lastAccount;
                address invitor;
                for (uint256 i; i < _invitorLen;) {
                    invitor = _invitor[current];
                    if (address(0) == invitor) {
                        break;
                    }
                    _userInfo[invitor].inviteUsdtReward += perInviteUsdt;
                    buybackUsdt -= perInviteUsdt;
                    current = invitor;
                unchecked{
                    ++i;
                }
                }
            }
        } else {
            _userInfo[lastAccount].poolUsdtReward += poolReward;
        }

        if (buybackUsdt > 0) {
            address tokenLPPair = _tokenLPPair;
            _giveToken(_usdtAddress, tokenLPPair, buybackUsdt);
            ISwapPair(tokenLPPair).sync();
        }
    }

    function _takeToken(address tokenAddress, address account, address to, uint256 amount) private {
        if (0 == amount) {
            return;
        }
        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(account) >= amount, "TNE");
        token.transferFrom(account, to, amount);
    }

    function _giveToken(address tokenAddress, address account, uint256 amount) private {
        if (0 == amount) {
            return;
        }
        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= amount, "PTNE");
        token.transfer(account, amount);
    }

    function claimReward() external {
        address account = msg.sender;
        calUserAllPool(account);

        UserInfo storage userInfo = _userInfo[account];
        uint256 pendingUsdt = userInfo.queueUsdtReward + userInfo.poolUsdtReward + userInfo.inviteUsdtReward;
        if (pendingUsdt > 0) {
            userInfo.queueUsdtReward = 0;
            userInfo.poolUsdtReward = 0;
            userInfo.inviteUsdtReward = 0;
            _giveToken(_usdtAddress, account, pendingUsdt);
        }

        uint256 pendingToken = userInfo.tokenReward;
        if (pendingToken > 0) {
            userInfo.tokenReward = 0;
            _giveToken(_tokenAddress, account, pendingToken);
            userInfo.claimedToken += pendingToken;
        }
    }

    function calUserAllPool(address account) public {
        uint256 len = _poolLen;
        uint256 lastPoolId;
        for (uint256 i; i < len;) {
            lastPoolId = _userLastPid[i][account];
            if (lastPoolId != _poolId[i]) {
                calUserPoolInfo(account, i, lastPoolId);
            }
        unchecked{
            ++i;
        }
        }
    }

    function userPoolPendingCalToken(address account, uint256 index, uint256 poolId) public view returns (uint256){
        PoolInfo storage poolInfo = _poolInfo[index][poolId];
        if (poolInfo.accPoolReward == 0) {
            return 0;
        }
        UserPoolInfo storage userPoolInfo = _userPoolInfo[index][poolId][account];
        if (userPoolInfo.cal) {
            return 0;
        }
        uint256 loseNum = userPoolInfo.joinNum - userPoolInfo.queueRewardNum;
        address[] storage accounts = poolInfo.accounts;
        uint256 accountsLen = accounts.length;
        if (account == accounts[accountsLen - 1]) {
            loseNum--;
        }
        return loseNum * _perTokenAmount;
    }

    function userAllPendingCalToken(address account) public view returns (uint256 pendingCalToken){
        uint256 len = _poolLen;
        uint256 lastPoolId;
        for (uint256 i; i < len;) {
            lastPoolId = _userLastPid[i][account];
            if (lastPoolId != _poolId[i]) {
                pendingCalToken += userPoolPendingCalToken(account, i, lastPoolId);
            }
        unchecked{
            ++i;
        }
        }
    }

    function claimBalance(address to, uint256 amount) external onlyOwner {
        address payable addr = payable(to);
        addr.transfer(amount);
    }

    function claimToken(address erc20Address, address to, uint256 amount) external onlyOwner {
        IERC20 erc20 = IERC20(erc20Address);
        erc20.transfer(to, amount);
    }

    function getBinderLength(address account) external view returns (uint256){
        return _binder[account].length;
    }

    function getUserInfo(address account) external view returns (
        uint256 queueUsdtReward,
        uint256 poolUsdtReward,
        uint256 inviteUsdtReward,
        uint256 tokenReward,
        bool isActive,
        uint256 teamNum,
        uint256 inviteRewardLevel,
        uint256 usdtBalance,
        uint256 usdtAllowance,
        uint256 tokenBalance,
        uint256 claimedToken,
        uint256 teamAmount
    ){
        UserInfo storage userInfo = _userInfo[account];
        queueUsdtReward = userInfo.queueUsdtReward;
        poolUsdtReward = userInfo.poolUsdtReward;
        inviteUsdtReward = userInfo.inviteUsdtReward;
        tokenReward = userInfo.tokenReward + userAllPendingCalToken(account);
        isActive = userInfo.active;
        teamNum = _teamNum[account];
        inviteRewardLevel = _getInvitorLevel(account, 0);
        usdtBalance = IERC20(_usdtAddress).balanceOf(account);
        usdtAllowance = IERC20(_usdtAddress).allowance(account, address(this));
        tokenBalance = IERC20(_tokenAddress).balanceOf(account);
        claimedToken = userInfo.claimedToken;
        teamAmount = userInfo.teamAmount;
    }

    function getUserPoolInfo(address account, uint256 index, uint256 pid) public view returns (
        uint256 joinNum, uint256 queueRewardNum, bool cal
    ){
        UserPoolInfo storage userPoolInfo = _userPoolInfo[index][pid][account];
        joinNum = userPoolInfo.joinNum;
        queueRewardNum = userPoolInfo.queueRewardNum;
        cal = userPoolInfo.cal;
    }

    function getUserAllPoolInfo(address account) public view returns (
        uint256[] memory joinNum, uint256[] memory queueRewardNum, bool[] memory cal
    ){
        uint256 len = _poolLen;
        joinNum = new uint256[](len);
        queueRewardNum = new uint256[](len);
        cal = new bool[](len);
        uint256 pid;
        for (uint256 i; i < len; ++i) {
            pid = getCurrentPoolId(i);
            (joinNum[i], queueRewardNum[i], cal[i]) = getUserPoolInfo(account, i, pid);
        }
    }

    function getBaseInfo() external view returns (
        address usdtAddress, uint256 usdtDecimals, string memory usdtSymbol,
        address tokenAddress, uint256 tokenDecimals, string memory tokenSymbol,
        uint256 perUsdtAmount, uint256 perTokenAmount, uint256 poolCreatePrice
    ){
        usdtAddress = _usdtAddress;
        usdtDecimals = IERC20(usdtAddress).decimals();
        usdtSymbol = IERC20(usdtAddress).symbol();
        tokenAddress = _tokenAddress;
        tokenDecimals = IERC20(tokenAddress).decimals();
        tokenSymbol = IERC20(tokenAddress).symbol();
        perUsdtAmount = _perUsdtAmount;
        perTokenAmount = _perTokenAmount;
        poolCreatePrice = _poolCreatePrice;
    }

    function getPoolBaseInfo(uint256 index) public view returns (
        uint256 pid, address creator, uint256 creatorFeeAmount
    ){
        pid = getCurrentPoolId(index);
        creator = _poolCreator[index];
        creatorFeeAmount = _poolCreatorFeeAmount[index];
    }

    function getAllPoolBaseInfo() public view returns (
        uint256[] memory pid, address[] memory creator, uint256[] memory creatorFeeAmount
    ){
        uint256 len = _poolLen;
        pid = new uint256[](len);
        creator = new address[](len);
        creatorFeeAmount = new uint256[](len);
        for (uint256 i; i < len; ++i) {
            (pid[i], creator[i], creatorFeeAmount[i]) = getPoolBaseInfo(i);
        }
    }

    function getPoolInfo(uint256 index, uint256 pid) public view returns (
        uint256 poolReward, uint256 accPoolReward, uint256 rewardTime, uint256 accountLen
    ){
        PoolInfo storage poolInfo = _poolInfo[index][pid];
        poolReward = poolInfo.poolReward;
        accPoolReward = poolInfo.accPoolReward;
        rewardTime = poolInfo.rewardTime;
        accountLen = poolInfo.accounts.length;
    }

    function getAllPoolInfo() public view returns (
        uint256[] memory poolReward, uint256[] memory rewardTime, uint256[] memory accountLen,
        address[][] memory showAccounts, uint256[][] memory showAccountTimes,
        address[] memory lastRewardAccount, uint256 blockTime
    ){
        uint256 len = _poolLen;
        poolReward = new uint256[](len);
        rewardTime = new uint256[](len);
        accountLen = new uint256[](len);
        showAccounts = new address[][](len);
        showAccountTimes = new uint256[][](len);
        lastRewardAccount = new address[](len);
        uint256 pid;
        for (uint256 i; i < len; ++i) {
            pid = getCurrentPoolId(i);
            (poolReward[i],,rewardTime[i], accountLen[i]) = getCurrentPoolInfo(i);
            (showAccounts[i], showAccountTimes[i]) = getPoolShowAccounts(i, pid);
            if (pid > 0) {
                address[] storage accounts = _poolInfo[i][pid - 1].accounts;
                uint256 lastAccountLen = accounts.length;
                if (lastAccountLen > 0) {
                    lastRewardAccount[i] = accounts[lastAccountLen - 1];
                }
            }
        }
        blockTime = block.timestamp;
    }

    function getCurrentPoolInfo(uint256 index) public view returns (
        uint256 poolReward, uint256 accPoolReward, uint256 rewardTime, uint256 accountLen
    ){
        (poolReward, accPoolReward, rewardTime, accountLen) = getPoolInfo(index, getCurrentPoolId(index));
        uint256 blockTime = block.timestamp;
        if (rewardTime == 0) {
            rewardTime = blockTime + _refreshDuration;
        }
    }

    function getCurrentPoolId(uint256 index) public view returns (uint256 poolId){
        poolId = _poolId[index];
        PoolInfo storage poolInfo = _poolInfo[index][poolId];
        uint256 blockTime = block.timestamp;
        if (poolInfo.rewardTime > 0 && poolInfo.rewardTime <= blockTime) {
            poolId += 1;
        }
    }

    function getPoolShowAccounts(uint256 pIndex, uint256 pid) public view returns (
        address[] memory returnAccounts, uint256[] memory returnAccountTimes
    ){
        PoolInfo storage poolInfo = _poolInfo[pIndex][pid];
        address[] storage accounts = poolInfo.accounts;
        uint256[] storage accountTimes = poolInfo.accountTimes;
        uint256 accountLength = accounts.length;
        uint256 start;
        uint256 len = _showAccountLen;
        if (accountLength > len) {
            start = accountLength - len;
        } else {
            len = accountLength;
        }
        returnAccounts = new address[](len);
        returnAccountTimes = new uint256[](len);

        uint256 index = 0;
        for (uint256 i = start; i < accountLength; ++i) {
            returnAccounts[index] = accounts[i];
            returnAccountTimes[index] = accountTimes[i];
            ++index;
        }
    }

    function getPoolAccounts(uint256 pIndex, uint256 pid, uint256 start, uint256 length) external view returns (
        uint256 returnLen, address[] memory returnAccounts, uint256[] memory returnAccountTimes
    ){
        PoolInfo storage poolInfo = _poolInfo[pIndex][pid];
        address[] storage accounts = poolInfo.accounts;
        uint256[] storage accountTimes = poolInfo.accountTimes;
        uint256 accountLength = accounts.length;
        if (0 == length) {
            length = accountLength;
        }
        returnLen = length;
        returnAccounts = new address[](length);
        returnAccountTimes = new uint256[](length);

        uint256 index = 0;
        for (uint256 i = start; i < start + length; ++i) {
            if (i >= accountLength)
                return (index, returnAccounts, returnAccountTimes);
            returnAccounts[index] = accounts[i];
            returnAccountTimes[index] = accountTimes[i];
            ++index;
        }
    }

    function getPoolQueueInfo(uint256 index, uint256 pid) public view returns (
        uint256 queueReward, uint256 queueLen, uint256 queueRewardIndex
    ){
        PoolInfo storage poolInfo = _poolInfo[index][pid];
        queueReward = poolInfo.queueReward;
        queueLen = poolInfo.queueLen;
        queueRewardIndex = poolInfo.queueRewardIndex;
    }

    function setFoundationAddress(address adr) external onlyOwner {
        _foundationAddress = adr;
    }

    function setTokenLPPair(address adr) external onlyOwner {
        _tokenLPPair = adr;
        require(IERC20(_tokenLPPair).totalSupply() > 0, "N LP");
    }

    function setTokenAddress(address adr) external onlyOwner {
        _tokenAddress = adr;
    }

    function setDefaultInvitor(address adr) external onlyOwner {
        _defaultInvitor = adr;
        _userInfo[adr].active = true;
    }

    function setPerUsdtAmount(uint256 perUsdtAmount) external onlyOwner {
        _perUsdtAmount = perUsdtAmount;
    }

    function setPerTokenAmount(uint256 perAmount) external onlyOwner {
        _perTokenAmount = perAmount;
    }

    function setRefreshDuration(uint256 refreshDuration) external onlyOwner {
        _refreshDuration = refreshDuration;
    }

    function setRefreshNum(uint256 num) external onlyOwner {
        _refreshNum = num;
    }

    function setQueueRewardLen(uint256 queueRewardLen) external onlyOwner {
        _queueRewardLen = queueRewardLen;
    }

    function setQueueRewardRate(uint256 rate) external onlyOwner maxRate {
        _queueRewardRate = rate;
    }

    function setPoolRewardRate(uint256 rate) external onlyOwner maxRate {
        require(rate > 0, ">0");
        _poolRewardRate = rate;
    }

    function setInviteRate(uint256 rate) external onlyOwner maxRate {
        _inviteRate = rate;
    }

    function setBuybackRate(uint256 rate) external onlyOwner maxRate {
        _buybackRate = rate;
    }

    function setFoundationRate(uint256 rate) external onlyOwner maxRate {
        _foundationRate = rate;
    }

    function setTeamRate(uint256 i, uint256 rate) external onlyOwner maxRate {
        _teamRewardRate[i] = rate;
    }

    function setTeamRewardCondition(uint256 i, uint256 c) external onlyOwner {
        _teamRewardCondition[i] = c;
    }

    function setTeamRewardConditionUnit(uint256 i, uint256 c) external onlyOwner {
        _teamRewardCondition[i] = c * 10 ** IERC20(_usdtAddress).decimals();
    }

    function setPoolCreatePrice(uint256 price) external onlyOwner maxRate {
        _poolCreatePrice = price;
    }

    function setMaxPoolLen(uint256 len) external onlyOwner maxRate {
        _maxPoolLen = len;
    }

    modifier maxRate(){
        _;
        require(_foundationRate + _teamRewardRate[_invitorLen] + _inviteRate + _buybackRate + _poolRewardRate + _queueRewardRate <= 10000, "M W");
    }

    function setLastRewardRate(uint256 rate) external onlyOwner {
        _lastRewardRate = rate;
        require(_lastRewardRate + _inviteRewardRate * _invitorLen <= 10000, "M W");
    }

    function setInviteRewardRate(uint256 rate) external onlyOwner {
        _inviteRewardRate = rate;
        require(_lastRewardRate + _inviteRewardRate * _invitorLen <= 10000, "M W");
    }

    function setShowAccountLen(uint256 len) external onlyOwner {
        _showAccountLen = len;
    }

    function createPool() external {
        require(_poolLen < _maxPoolLen, "maxPoolLen");
        address account = msg.sender;
        _takeToken(_usdtAddress, account, _foundationAddress, _poolCreatePrice);
        _poolCreator[_poolLen] = account;
        _poolLen++;
    }
}

contract FOMOPool is AbsPool {
    constructor() AbsPool(
    //usdt
        address(0x55d398326f99059fF775485246999027B3197955),
    //Token
        address(0x01FaD48ec3C6e45CC8E39034aeAce6484960A1DF),
    //TokenLP
        address(0x4ed6CC68412B01fEFc1ED168B5c7cf1f10f49949),
    //DefaultInvitor
        address(0xcDce83C1a7b3daAcf30e8ea82347Ec23C43707Fb),
    //Foundation
        address(0x42E26792298ddE777e773399C35Aba53B368d5e3)
    ){

    }
}