/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

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
    address private _owner;

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

abstract contract AbsLPPool is Ownable {
    struct UserInfo {
        bool isActive;
        uint256 amount;
        uint256 rewardMintDebt;
        uint256 calMintReward;
    }

    struct PoolInfo {
        uint256 totalAmount;

        uint256 accMintPerShare;
        uint256 accMintReward;
        uint256 mintPerBlock;
        uint256 lastMintBlock;
        uint256 totalMintReward;
    }

    PoolInfo private poolInfo;
    mapping(address => UserInfo) private userInfo;

    address private _lpToken;
    string private _lpTokenSymbol;
    address private _rewardToken;

    mapping(address => address) public _invitor;
    mapping(address => address[]) public _binder;
    uint256 public _inviteFee = 1000;

    event BindParent(address indexed user, address indexed parent);
    event Deposit(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event Claim(address indexed user, uint256 amount);

    constructor(
        address LPToken, string memory LPTokenSymbol,
        address RewardToken
    ){
        _lpToken = LPToken;
        _lpTokenSymbol = LPTokenSymbol;
        _rewardToken = RewardToken;
    }

    receive() external payable {}

    function safeTransferBNB(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
    }

    function deposit(uint256 amount, address invitor) external {
        require(amount > 0, "=0");
        address account = msg.sender;
        UserInfo storage user = userInfo[account];
        if (!user.isActive) {
            user.isActive = true;
            if (userInfo[invitor].isActive) {
                _invitor[account] = invitor;
                _binder[invitor].push(account);
                emit BindParent(account, invitor);
            }
        }
        _calReward(user);

        IERC20(_lpToken).transferFrom(msg.sender, address(this), amount);

        user.amount += amount;
        poolInfo.totalAmount += amount;

        user.rewardMintDebt = user.amount * poolInfo.accMintPerShare / 1e18;

        emit Deposit(account, amount);
    }

    function withdraw() public {
        address account = msg.sender;
        UserInfo storage user = userInfo[account];
        _calReward(user);

        uint256 amount = user.amount;

        IERC20(_lpToken).transfer(msg.sender, amount);

        user.amount -= amount;
        poolInfo.totalAmount -= amount;

        user.rewardMintDebt = user.amount * poolInfo.accMintPerShare / 1e18;

        emit Withdrawn(account, amount);
    }

    function claim() public {
        address account = msg.sender;
        UserInfo storage user = userInfo[account];
        _calReward(user);
        uint256 pendingMint = user.calMintReward;
        if (pendingMint > 0) {
            address invitor = _invitor[account];
            if (address(0) != invitor) {
                uint256 inviteAmount = pendingMint * _inviteFee / 10000;
                if (inviteAmount > 0) {
                    if (_rewardToken == address(2)) {
                        safeTransferBNB(account, inviteAmount);
                    } else {
                        IERC20(_rewardToken).transfer(account, inviteAmount);
                    } 
                }
            }
            if (_rewardToken == address(2)) {
                safeTransferBNB(account, pendingMint);
            } else {
                IERC20(_rewardToken).transfer(account, pendingMint);
            }
            user.calMintReward = 0;

            emit Claim(account, pendingMint);
        }
        
    }

    function _updatePool() private {
        PoolInfo storage pool = poolInfo;
        uint256 blockNum = block.number;
        uint256 lastRewardBlock = pool.lastMintBlock;
        if (blockNum <= lastRewardBlock) {
            return;
        }
        pool.lastMintBlock = blockNum;

        uint256 accReward = pool.accMintReward;
        uint256 totalReward = pool.totalMintReward;
        if (accReward >= totalReward) {
            return;
        }

        uint256 totalAmount = pool.totalAmount;
        uint256 rewardPerBlock = pool.mintPerBlock;
        if (0 < totalAmount && 0 < rewardPerBlock) {
            uint256 reward = rewardPerBlock * (blockNum - lastRewardBlock);
            uint256 remainReward = totalReward - accReward;
            if (reward > remainReward) {
                reward = remainReward;
            }
            pool.accMintPerShare += reward * 1e18 / totalAmount;
            pool.accMintReward += reward;
        }
    }

    function _calReward(UserInfo storage user) private {
        _updatePool();
        if (user.amount > 0) {
            uint256 accMintReward = user.amount * poolInfo.accMintPerShare / 1e18;
            uint256 pendingMintAmount = accMintReward - user.rewardMintDebt;
            if (pendingMintAmount > 0) {
                user.rewardMintDebt = accMintReward;
                user.calMintReward += pendingMintAmount;
            }
        }
    }

    function _calPendingMintReward(address account) private view returns (uint256 reward) {
        reward = 0;
        PoolInfo storage pool = poolInfo;
        UserInfo storage user = userInfo[account];
        if (user.amount > 0) {
            uint256 poolPendingReward;
            uint256 blockNum = block.number;
            uint256 lastRewardBlock = pool.lastMintBlock;
            if (blockNum > lastRewardBlock) {
                poolPendingReward = pool.mintPerBlock * (blockNum - lastRewardBlock);
                uint256 totalReward = pool.totalMintReward;
                uint256 accReward = pool.accMintReward;
                uint256 remainReward;
                if (totalReward > accReward) {
                    remainReward = totalReward - accReward;
                }
                if (poolPendingReward > remainReward) {
                    poolPendingReward = remainReward;
                }
            }
            reward = user.amount * (pool.accMintPerShare + poolPendingReward * 1e18 / pool.totalAmount) / 1e18 - user.rewardMintDebt;
        }
    }
    function getPoolInfo() public view returns (
        uint256 totalAmount,
        uint256 accMintPerShare, uint256 accMintReward,
        uint256 mintPerBlock, uint256 lastMintBlock, uint256 totalMintReward
    ) {
        totalAmount = poolInfo.totalAmount;
        accMintPerShare = poolInfo.accMintPerShare;
        accMintReward = poolInfo.accMintReward;
        mintPerBlock = poolInfo.mintPerBlock;
        lastMintBlock = poolInfo.lastMintBlock;
        totalMintReward = poolInfo.totalMintReward;
    }

    function getUserInfo(address account) public view returns (
        uint256 amount, uint256 lpAllowance,
        uint256 pendingMintReward
    ) {
        UserInfo storage user = userInfo[account];
        amount = user.amount;
        lpAllowance = IERC20(_lpToken).allowance(account, address(this));
        pendingMintReward = _calPendingMintReward(account) + user.calMintReward;
    }

    function getUserExtInfo(address account) public view returns (
        uint256 calMintReward, uint256 rewardMintDebt
    ) {
        UserInfo storage user = userInfo[account];
        calMintReward = user.calMintReward;
        rewardMintDebt = user.rewardMintDebt;
    }

    function getBinderLength(address account) public view returns (uint256){
        return _binder[account].length;
    }

    function setLPToken(address lpToken, string memory lpSymbol) external onlyOwner {
        require(poolInfo.totalAmount == 0, "started");
        _lpToken = lpToken;
        _lpTokenSymbol = lpSymbol;
    }

    function setRewardToken(address rewardToken) external onlyOwner {
        _rewardToken = rewardToken;
    }

    function setMintPerBlock(uint256 totalMint) external onlyOwner {
        _updatePool();
        poolInfo.mintPerBlock = totalMint / 28800;
    }

    function setTotalMintReward(uint256 totalReward) external onlyOwner {
        _updatePool();
        poolInfo.totalMintReward = totalReward;
    }

    function setInviteFee(uint256 fee) external onlyOwner {
        _inviteFee = fee;
    }

    function claimBalance(address to, uint256 amount) external onlyOwner {
        payable(to).transfer(amount);
    }

    function claimToken(address token, address to, uint256 amount) external onlyOwner {
        IERC20(token).transfer(to, amount);
    }
}

contract RisebotLPDividendPool is AbsLPPool {
    constructor() AbsLPPool(
    //Risebot-BNB-LP
        address(0x5E23452204A05190b8ce443F37b9712C03fF672E),
        "Risebot-BNB-LP",
    //BNB
        address(2)
    ){

    }
}