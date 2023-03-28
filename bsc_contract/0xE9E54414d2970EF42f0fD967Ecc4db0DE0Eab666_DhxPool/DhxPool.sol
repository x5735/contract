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
        uint256 perAmount;
        uint256 rewardRate;
        uint256 totalAmount;
        uint256 accReward;
        uint256 accPerShare;
    }

    struct UserInfo {
        bool active;
        uint256 totalAmount;
        uint256 maxAmount;
        uint256 teamAmount;
        uint256 teamMaxLevelNum;
        bool isCalTeamMaxLevel;
        uint256 calTeamMaxLevelIndex;
        uint256 inviteReward;
        uint256 teamReward;
        uint256 worldReward;
        uint256 poolReward;
        uint256 claimedReward;
    }

    struct UserPoolInfo {
        uint256 amount;
        uint256 rewardDebt;
        uint256 maxReward;
        uint256 calReward;
    }

    uint256 public _poolLen = 7;
    mapping(uint256 => PoolInfo) private _poolInfo;

    mapping(address => UserInfo) private _userInfo;
    mapping(uint256 => mapping(address => UserPoolInfo)) private _userPoolInfo;

    address private _tokenAddress;

    uint256 private constant _maxLevel = 9;
    mapping(uint256 => uint256) public _teamRewardRate;
    mapping(uint256 => uint256) public _teamRewardCondition;
    mapping(uint256 => uint256) public _inviteRewardCondition;

    uint256 public _backRate = 5000;
    uint256 public _foundationRate = 900;
    uint256 public _poolRate = 1000;
    uint256 public _inviteRate = 50;
    uint256 public _worldRate = 100;
    uint256 private _worldRewardTeamMaxLevelCondition = 2;

    address public _foundationAddress;
    address public _specialAddress;

    mapping(address => address) public _invitor;
    mapping(address => address[]) public _binder;
    mapping(address => uint256) private _teamNum;
    uint256 private constant _invitorLen = 20;

    address private _defaultInvitor;
    uint256 private _totalAmount;
    uint256 private _currentTotalAmount;
    uint256 public _claimFeeAmount;

    mapping(address => mapping(uint256 => address)) public _levelInvitor;

    constructor(
        address TokenAddress, address DefaultInvitor, address FoundationAddress, address SpecialAddress
    ){
        _tokenAddress = TokenAddress;
        _defaultInvitor = DefaultInvitor;
        _foundationAddress = FoundationAddress;
        _specialAddress = SpecialAddress;
        uint256 tokenUnit = 10 ** IERC20(TokenAddress).decimals();

        _poolInfo[0].perAmount = 50 * tokenUnit;
        _poolInfo[0].rewardRate = 15000;
        _poolInfo[1].perAmount = 100 * tokenUnit;
        _poolInfo[1].rewardRate = 15000;
        _poolInfo[2].perAmount = 300 * tokenUnit;
        _poolInfo[2].rewardRate = 15000;
        _poolInfo[3].perAmount = 500 * tokenUnit;
        _poolInfo[3].rewardRate = 20000;
        _poolInfo[4].perAmount = 1000 * tokenUnit;
        _poolInfo[4].rewardRate = 20000;
        _poolInfo[5].perAmount = 2000 * tokenUnit;
        _poolInfo[5].rewardRate = 20000;
        _poolInfo[6].perAmount = 3000 * tokenUnit;
        _poolInfo[6].rewardRate = 30000;

        _teamRewardRate[1] = 100;
        _teamRewardRate[2] = 200;
        _teamRewardRate[3] = 400;
        _teamRewardRate[4] = 600;
        _teamRewardRate[5] = 800;
        _teamRewardRate[6] = 1100;
        _teamRewardRate[7] = 1400;
        _teamRewardRate[8] = 1700;
        _teamRewardRate[9] = 2000;

        _teamRewardCondition[1] = 5000 * tokenUnit;
        _teamRewardCondition[2] = 10000 * tokenUnit;
        _teamRewardCondition[3] = 20000 * tokenUnit;
        _teamRewardCondition[4] = 40000 * tokenUnit;
        _teamRewardCondition[5] = 80000 * tokenUnit;
        _teamRewardCondition[6] = 160000 * tokenUnit;
        _teamRewardCondition[7] = 320000 * tokenUnit;
        _teamRewardCondition[8] = 640000 * tokenUnit;
        _teamRewardCondition[9] = 1280000 * tokenUnit;

        uint256 c = 100 * tokenUnit;
        for (uint256 i; i < _invitorLen; ++i) {
            if (i == 5) {
                c = 500 * tokenUnit;
            } else if (i == 10) {
                c = 3000 * tokenUnit;
            }
            _inviteRewardCondition[i] = c;
        }

        _userInfo[DefaultInvitor].active = true;
        _claimFeeAmount = 2 * tokenUnit;
    }

    function join(uint256 index, address invitor) external {
        uint256 poolLen = _poolLen;
        require(index < poolLen, "invalid pool");
        address account = msg.sender;
        require(tx.origin == account, "origin");
        uint256 debtAmount = _calUserPoolReward(account, poolLen);
        uint256 specialAmount = _calPoolReward(debtAmount, poolLen);
        address specialAddress = _specialAddress;
        address tokenAddress = _tokenAddress;
        _giveToken(tokenAddress, specialAddress, specialAmount);

        UserInfo storage userInfo = _userInfo[account];
        if (!userInfo.active) {
            require(_userInfo[invitor].active, "invalid invitor");
            _invitor[account] = invitor;
            _binder[invitor].push(account);
            for (uint256 i; i < _invitorLen;) {
                _levelInvitor[account][i] = invitor;
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

        PoolInfo storage poolInfo = _poolInfo[index];
        uint256 perAmount = poolInfo.perAmount;
        require(IERC20(tokenAddress).balanceOf(account) >= perAmount, "BNE");

        uint256 backAmount = perAmount * _backRate / 10000;
        _takeToken(tokenAddress, account, address(this), perAmount - backAmount);

        _giveToken(tokenAddress, _foundationAddress, perAmount * _foundationRate / 10000);

        specialAmount = _calPoolReward(perAmount * _poolRate / 10000, poolLen);
        _giveToken(tokenAddress, specialAddress, specialAmount);

        poolInfo.totalAmount += perAmount;
        _totalAmount += perAmount;
        _currentTotalAmount += perAmount;
        userInfo.totalAmount += perAmount;
        if (userInfo.maxAmount < perAmount) {
            userInfo.maxAmount = perAmount;
        }

        specialAmount = _calTeamReward(account, perAmount);
        _giveToken(tokenAddress, specialAddress, specialAmount);

        specialAmount = _calWorldReward(account, perAmount);
        _giveToken(tokenAddress, specialAddress, specialAmount);

        specialAmount = _calInviteReward(account, perAmount);
        _giveToken(tokenAddress, specialAddress, specialAmount);

        resetUserPoolInfo(index, account, perAmount, backAmount);
    }

    function _calUserPoolReward(address account, uint256 poolLen) private returns (uint256 debtAmount){
        UserInfo storage userInfo = _userInfo[account];
        UserPoolInfo storage userPoolInfo;
        uint256 amount;
        PoolInfo storage poolInfo;
        uint256 totalReward;
        uint256 pendingReward;
        uint256 maxReward;
        uint256 maxAmount;
        for (uint256 i; i < poolLen;) {
            userPoolInfo = _userPoolInfo[i][account];
            amount = userPoolInfo.amount;
            if (amount > 0) {
                poolInfo = _poolInfo[i];
                totalReward = userPoolInfo.amount * poolInfo.accPerShare / 1e18;
                pendingReward = totalReward - userPoolInfo.rewardDebt;
                if (pendingReward > 0) {
                    maxReward = userPoolInfo.maxReward - userPoolInfo.calReward;
                    if (pendingReward >= maxReward) {
                        debtAmount += pendingReward - maxReward;
                        pendingReward = maxReward;
                        userPoolInfo.amount = 0;
                        _currentTotalAmount -= amount;
                        poolInfo.totalAmount -= amount;
                    } else {
                        if (amount > maxAmount) {
                            maxAmount = amount;
                        }
                        userPoolInfo.rewardDebt = totalReward;
                    }
                    userPoolInfo.calReward += pendingReward;
                    userInfo.poolReward += pendingReward;
                } else {
                    if (amount > maxAmount) {
                        maxAmount = amount;
                    }
                }
            }

        unchecked{
            ++i;
        }
        }
        userInfo.maxAmount = maxAmount;
    }

    function _calInviteReward(address account, uint256 perAmount) private returns (uint256 specialAmount){
        uint256 inviteAmount = perAmount * _inviteRate / 10000;
        specialAmount = inviteAmount * _invitorLen;

        uint256 maxLevelCondition = _teamRewardCondition[_maxLevel];
        address current = account;
        uint256 teamAmount;
        uint256 start;
        address invitor;
        UserInfo storage invitorInfo;
        for (uint256 i; i < _invitorLen;) {
            invitor = _invitor[current];
            if (address(0) == invitor) {
                break;
            }
            invitorInfo = _userInfo[invitor];
            teamAmount = invitorInfo.teamAmount;
            teamAmount += perAmount;
            invitorInfo.teamAmount = teamAmount;
            if (teamAmount >= maxLevelCondition) {
                _calMaxLevelNum(invitor, start);
                start = _invitorLen - 1;
            } else if (start > 0) {
                start--;
            }
            if (invitorInfo.maxAmount >= _inviteRewardCondition[i]) {
                invitorInfo.inviteReward += inviteAmount;
                specialAmount -= inviteAmount;
            }
            current = invitor;
        unchecked{
            ++i;
        }
        }
    }

    function resetUserPoolInfo(uint256 index, address account, uint256 perAmount, uint256 backAmount) private {
        PoolInfo storage poolInfo = _poolInfo[index];
        UserPoolInfo storage userPoolInfo = _userPoolInfo[index][account];
        require(userPoolInfo.amount == 0, "joined");
        uint256 maxReward = perAmount * poolInfo.rewardRate / 10000;
        userPoolInfo.maxReward = maxReward;
        userPoolInfo.calReward = backAmount;
        userPoolInfo.amount = perAmount;
        userPoolInfo.rewardDebt = poolInfo.accPerShare * perAmount / 1e18;
    }

    function _calPoolReward(uint256 totalReward, uint256 poolLen) private returns (uint256 remainReward){
        remainReward = totalReward;
        if (totalReward > 0) {
            uint256 currentTotalAmount = _currentTotalAmount;
            if (currentTotalAmount > 0) {
                remainReward = 0;
                PoolInfo storage poolInfo;
                uint256 poolAmount;
                uint256 poolReward;
                for (uint256 i; i < poolLen;) {
                    poolInfo = _poolInfo[i];
                    poolAmount = poolInfo.totalAmount;
                    if (poolAmount > 0) {
                        poolReward = totalReward * poolAmount / currentTotalAmount;
                        poolInfo.accReward += poolReward;
                        poolInfo.accPerShare += poolReward * 1e18 / poolAmount;
                    }
                unchecked{
                    ++i;
                }
                }
            }
        }
    }

    function _calWorldReward(
        address current, uint256 perAmount
    ) private returns (uint256 worldReward){
        worldReward = perAmount * _worldRate / 10000;
        uint256 teamMaxLevelCondition = _worldRewardTeamMaxLevelCondition;
        address invitor;
        for (uint256 i; i < _invitorLen;) {
            invitor = _invitor[current];
            if (address(0) == invitor) {
                break;
            }
            if (_userInfo[invitor].teamMaxLevelNum >= teamMaxLevelCondition) {
                _userInfo[invitor].worldReward += worldReward;
                worldReward = 0;
                break;
            }
            current = invitor;
        unchecked{
            ++i;
        }
        }
    }

    function _calTeamReward(
        address current, uint256 perAmount
    ) private returns (uint256 teamTotalReward){
        teamTotalReward = _teamRewardRate[_maxLevel] * perAmount / 10000;
        uint256 lastRewardLevel;
        uint256 teamLevel;
        uint256 teamReward;
        address invitor;
        uint256 rewardRate;
        for (uint256 i; i < _invitorLen; ++i) {
            invitor = _invitor[current];
            if (address(0) == invitor) {
                break;
            }
            current = invitor;
            teamLevel = _getInvitorTeamLevel(invitor, lastRewardLevel);
            if (teamLevel <= lastRewardLevel) {
                continue;
            }
            rewardRate = _teamRewardRate[teamLevel] - _teamRewardRate[lastRewardLevel];
            teamReward = rewardRate * perAmount / 10000;
            _userInfo[invitor].teamReward += teamReward;
            teamTotalReward -= teamReward;
            lastRewardLevel = teamLevel;
        }
    }

    function _calMaxLevelNum(
        address current, uint256 start
    ) private {
        uint256 len = _invitorLen;
        UserInfo storage currentInfo = _userInfo[current];
        if (currentInfo.calTeamMaxLevelIndex >= len) {
            return;
        }
        currentInfo.calTeamMaxLevelIndex = len;
        if (start > 0) {
            current = _levelInvitor[current][start - 1];
        }
        address invitor;
        for (uint256 i = start; i < len;) {
            invitor = _invitor[current];
            if (address(0) == invitor) {
                break;
            }
            currentInfo = _userInfo[current];
            if (!currentInfo.isCalTeamMaxLevel) {
                currentInfo.isCalTeamMaxLevel = true;
                _userInfo[invitor].teamMaxLevelNum += 1;
            }
            current = invitor;
        unchecked{
            ++i;
        }
        }
    }

    function _getInvitorTeamLevel(
        address invitor, uint256 lowLevel
    ) private view returns (uint256){
        uint256 teamAmount = _userInfo[invitor].teamAmount;
        for (uint256 i = _maxLevel; i > lowLevel;) {
            if (teamAmount >= _teamRewardCondition[i]) {
                return i;
            }
        unchecked{
            --i;
        }
        }
        return 0;
    }

    function _takeToken(address tokenAddress, address account, address to, uint256 amount) private {
        if (0 < amount) {
            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(account, to, amount);
        }
    }

    function _giveToken(address tokenAddress, address account, uint256 amount) private {
        if (0 < amount) {
            IERC20 token = IERC20(tokenAddress);
            token.transfer(account, amount);
        }
    }

    function claimReward() external {
        address account = msg.sender;
        uint256 poolLen = _poolLen;
        uint256 debtAmount = _calUserPoolReward(account, poolLen);
        uint256 specialAmount = _calPoolReward(debtAmount, poolLen);
        address tokenAddress = _tokenAddress;
        _giveToken(tokenAddress, _specialAddress, specialAmount);

        UserInfo storage userInfo = _userInfo[account];
        uint256 pendingReward = userInfo.teamReward + userInfo.poolReward + userInfo.inviteReward + userInfo.worldReward;
        if (pendingReward > 0) {
            userInfo.claimedReward += pendingReward;
            userInfo.teamReward = 0;
            userInfo.poolReward = 0;
            userInfo.inviteReward = 0;
            userInfo.worldReward = 0;
            _giveToken(tokenAddress, account, pendingReward - _claimFeeAmount);
            _giveToken(tokenAddress, _foundationAddress, _claimFeeAmount);
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

    function getBaseInfo() external view returns (
        address tokenAddress, uint256 tokenDecimals, string memory tokenSymbol,
        address defaultInvitor, uint256 totalAmount, uint256 currentTotalAmount,
        uint256 worldRewardTeamMaxLevelCondition
    ){
        tokenAddress = _tokenAddress;
        tokenDecimals = IERC20(tokenAddress).decimals();
        tokenSymbol = IERC20(tokenAddress).symbol();
        defaultInvitor = _defaultInvitor;
        totalAmount = _totalAmount;
        currentTotalAmount = _currentTotalAmount;
        worldRewardTeamMaxLevelCondition = _worldRewardTeamMaxLevelCondition;
    }

    function getPoolInfo(uint256 i) public view returns (
        uint256 perAmount,
        uint256 rewardRate,
        uint256 totalAmount,
        uint256 accReward,
        uint256 accPerShare
    ){
        PoolInfo storage poolInfo = _poolInfo[i];
        perAmount = poolInfo.perAmount;
        rewardRate = poolInfo.rewardRate;
        totalAmount = poolInfo.totalAmount;
        accReward = poolInfo.accReward;
        accPerShare = poolInfo.accPerShare;
    }

    function getAllPoolInfo() public view returns (
        uint256[] memory perAmount,
        uint256[] memory rewardRate,
        uint256[] memory totalAmount,
        uint256[] memory accReward,
        uint256[] memory accPerShare
    ){
        uint256 len = _poolLen;
        perAmount = new uint256[](len);
        rewardRate = new uint256[](len);
        totalAmount = new uint256[](len);
        accReward = new uint256[](len);
        accPerShare = new uint256[](len);
        for (uint256 i; i < len; ++i) {
            (perAmount[i], rewardRate[i], totalAmount[i], accReward[i], accPerShare[i]) = getPoolInfo(i);
        }
    }

    function getUserPoolInfo(uint256 i, address account) public view returns (
        uint256 amount,
        uint256 rewardDebt,
        uint256 maxReward,
        uint256 calReward,
        uint256 pendingReward
    ){
        UserPoolInfo storage userPoolInfo = _userPoolInfo[i][account];
        amount = userPoolInfo.amount;
        rewardDebt = userPoolInfo.rewardDebt;
        maxReward = userPoolInfo.maxReward;
        calReward = userPoolInfo.calReward;
        pendingReward = getUserPoolPendingReward(i, account);
    }

    function getUserAllPoolInfo(address account) public view returns (
        uint256[] memory amount,
        uint256[] memory rewardDebt,
        uint256[] memory maxReward,
        uint256[] memory calReward,
        uint256[] memory pendingReward
    ){
        uint256 len = _poolLen;
        amount = new uint256[](len);
        rewardDebt = new uint256[](len);
        maxReward = new uint256[](len);
        calReward = new uint256[](len);
        pendingReward = new uint256[](len);
        for (uint256 i; i < len; ++i) {
            (amount[i], rewardDebt[i], maxReward[i], calReward[i], pendingReward[i]) = getUserPoolInfo(i, account);
        }
    }

    function getUserPoolPendingReward(uint256 i, address account) public view returns (uint256 pendingReward){
        UserPoolInfo storage userPoolInfo = _userPoolInfo[i][account];
        uint256 amount = userPoolInfo.amount;
        if (amount > 0) {
            pendingReward = userPoolInfo.amount * _poolInfo[i].accPerShare / 1e18 - userPoolInfo.rewardDebt;
            if (pendingReward > 0) {
                uint256 maxReward = userPoolInfo.maxReward - userPoolInfo.calReward;
                if (pendingReward >= maxReward) {
                    pendingReward = maxReward;
                }
            }
        }
    }

    function getUserInfo(address account) public view returns (
        uint256 totalAmount,
        uint256 teamAmount,
        uint256 inviteReward,
        uint256 teamReward,
        uint256 worldReward,
        uint256 poolReward,
        uint256 pendingPoolReward,
        uint256 claimedReward,
        uint256 tokenBalance,
        uint256 tokenAllowance,
        uint256 teamNum
    ){
        UserInfo storage userInfo = _userInfo[account];
        totalAmount = userInfo.totalAmount;
        teamAmount = userInfo.teamAmount;
        inviteReward = userInfo.inviteReward;
        teamReward = userInfo.teamReward;
        worldReward = userInfo.worldReward;
        poolReward = userInfo.poolReward;
        claimedReward = userInfo.claimedReward;
        tokenBalance = IERC20(_tokenAddress).balanceOf(account);
        tokenAllowance = IERC20(_tokenAddress).allowance(account, address(this));
        for (uint256 i; i < _poolLen; ++i) {
            pendingPoolReward += getUserPoolPendingReward(i, account);
        }
        teamNum = _teamNum[account];
    }

    function getUserExtInfo(address account) public view returns (
        bool active,
        uint256 maxAmount,
        uint256 teamMaxLevelNum,
        bool isCalTeamMaxLevel,
        uint256 calTeamMaxLevelIndex,
        uint256 inviteLevel,
        uint256 teamLevel
    ){
        UserInfo storage userInfo = _userInfo[account];
        active = userInfo.active;
        maxAmount = userInfo.maxAmount;
        teamMaxLevelNum = userInfo.teamMaxLevelNum;
        isCalTeamMaxLevel = userInfo.isCalTeamMaxLevel;
        calTeamMaxLevelIndex = userInfo.calTeamMaxLevelIndex;
        inviteLevel = _getInvitorLevel(account);
        teamLevel = _getInvitorTeamLevel(account, 0);
    }

    function _getInvitorLevel(
        address invitor
    ) private view returns (uint256){
        uint256 maxAmount = _userInfo[invitor].maxAmount;
        for (uint256 i = _invitorLen - 1; i > 0;) {
            if (maxAmount >= _inviteRewardCondition[i]) {
                return i + 1;
            }
        unchecked{
            --i;
        }
        }
        return 0;
    }

    function setFoundationAddress(address adr) external onlyOwner {
        _foundationAddress = adr;
    }

    function setSpecialAddress(address adr) external onlyOwner {
        _specialAddress = adr;
    }

    function setTokenAddress(address adr) external onlyOwner {
        _tokenAddress = adr;
    }

    function setDefaultInvitor(address adr) external onlyOwner {
        _defaultInvitor = adr;
        _userInfo[adr].active = true;
    }

    function setPerAmount(uint256 i, uint256 perAmount) external onlyOwner {
        _poolInfo[i].perAmount = perAmount;
    }

    function setRewardRate(uint256 i, uint256 r) external onlyOwner {
        _poolInfo[i].rewardRate = r;
    }

    function setWorldRate(uint256 rate) external onlyOwner maxRate {
        _worldRate = rate;
    }

    function setWorldRewardTeamMaxLevelCondition(uint256 c) external onlyOwner maxRate {
        _worldRewardTeamMaxLevelCondition = c;
    }

    function setPoolRate(uint256 rate) external onlyOwner maxRate {
        _poolRate = rate;
    }

    function setInviteRate(uint256 rate) external onlyOwner maxRate {
        _inviteRate = rate;
    }

    function setBackRate(uint256 rate) external onlyOwner maxRate {
        _backRate = rate;
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
        _teamRewardCondition[i] = c * 10 ** IERC20(_tokenAddress).decimals();
    }

    function setInviteRewardCondition(uint256 i, uint256 c) external onlyOwner {
        _inviteRewardCondition[i] = c;
    }

    function setInviteRewardConditionUnit(uint256 i, uint256 c) external onlyOwner {
        _inviteRewardCondition[i] = c * 10 ** IERC20(_tokenAddress).decimals();
    }

    function setClaimFeeAmount(uint256 amount) external onlyOwner {
        _claimFeeAmount = amount;
    }

    function setClaimFeeAmountUnit(uint256 amount) external onlyOwner {
        _claimFeeAmount = amount * 10 ** IERC20(_tokenAddress).decimals();
    }

    modifier maxRate(){
        _;
        require(_foundationRate + _teamRewardRate[_maxLevel] + _inviteRate * _invitorLen + _backRate + _poolRate + _worldRate <= 10000, "M W");
    }

    uint256 _maxPoolLen = 10;

    function setMaxPoolLen(uint256 len) external onlyOwner maxRate {
        _maxPoolLen = len;
    }

    function addPool(uint256 amount, uint256 rate) external onlyOwner {
        require(_poolLen < _maxPoolLen, "maxPoolLen");
        PoolInfo storage poolInfo = _poolInfo[_poolLen];
        poolInfo.perAmount = amount;
        poolInfo.rewardRate = rate;
        _poolLen++;
    }
}

contract DhxPool is AbsPool {
    constructor() AbsPool(
    //Token
        address(0x11d9f5d36BA3996962142c1c32467AcEBb697009),
    //DefaultInvitor
        address(0x1D85c3E9b365be6d0257F3eFf07eE4b4d4906e19),
    //Foundation
        address(0xa6Ce22df73778D7d5BBa178EB40682Bda7c0be85),
    //Special
        address(0xa6Ce22df73778D7d5BBa178EB40682Bda7c0be85)
    ){

    }
}