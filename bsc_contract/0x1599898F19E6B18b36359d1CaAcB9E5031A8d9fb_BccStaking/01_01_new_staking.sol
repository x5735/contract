// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

library TransferHelper {
    function safeTransfer(address token, address to, uint256 value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0xa9059cbb, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: TRANSFER_FAILED"
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x23b872dd, from, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "TransferHelper: TRANSFER_FROM_FAILED"
        );
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);
}

interface StakeInfo {
    // ÿ���û�����Ϣ��
    struct UserInfo {
        uint256 stakedOf; // �û��ṩ�˶��� LP ���ҡ�
        uint256 rewardOf; // �û��Ѿ���ȡ�Ľ���
        uint256 duration; //��Ѻ����
        uint256 lastDepositAt; //�����Ѻʱ��
        uint256 lastRewardAt; //����콱ʱ��
        uint256 userReward; //�û�����
    }

    // ÿ���ص���Ϣ��
    struct PoolInfo {
        uint256 totalStaked; // �ܹɷ�
        address lpToken; // LP ���Һ�Լ��ַ��
        uint256 duration; //��Ѻ����
        uint256 allocPoint; // ������˳صķ��������
        uint256 accPerShare; // ��Ѻһ��LPToken��ȫ������
    }
}

contract BccStaking is StakeInfo {
    address public immutable tokenAddress; // token��Լ��ַ
    address public owner; // ��Լ������

    uint256 public bonusDay = 30; //20 d
    uint256 public constant bonusDuration = 1 days; // �������� 86400
    uint256 public unstakeDuration = 1 days; // ���ڽ�ѹ���� 86400
    uint256 public autoDelay = 3 * bonusDuration; // ����3���ֺ�����(3d),�Զ�����

    bool public isStaking = true; // �Ƿ�����Ѻ
    bool public closeUnstake; // �رյĳ�������ֱ�ӽ�Ѻ
    bool public isBonus; // �Ƿ�������
    uint256 public totalAllocPoint; // �ܷ�������� ���������г������з������ܺ͡�

    uint256 public poolLength;
    mapping(address => mapping(uint256 => bool)) public isPool;
    mapping(address => mapping(uint256 => uint256)) public poolId; // token=>duration=>pid
    mapping(uint256 => PoolInfo) public poolInfo; //��Ѻ������ pid => info
    mapping(uint256 => mapping(address => UserInfo)) private _userInfo; // �û���Ϣ pid=>user=>user
    mapping(uint256 => uint256) public totalUnstakeAmount;
    mapping(uint256 => mapping(address => uint256)) public userUnstakeAmount;
    mapping(uint256 => mapping(address => uint256)) public userUnstakeAt;

    uint256 public totalReward; //�ܽ���
    uint256 public totalUsedReward; //�ֺܷ콱��
    uint256 public totalPendingReward; //�ֺܷ���콱��
    uint256 public lastBonusEpoch; //��һ�ηֺ�ʱ��
    uint256 public lastBonusToken; //���ֺ��USD

    // ��Ѻ�¼�
    event Staked(
        address indexed from,
        address indexed lpToken,
        uint256 _duration,
        uint256 amount
    );
    // ȡ����Ѻ�¼�
    event Unstaked(
        address indexed to,
        address indexed lpToken,
        uint256 _duration,
        uint256 amount
    );
    event WithdrawUnstaked(
        address indexed to,
        address indexed lpToken,
        uint256 _duration,
        uint256 amount
    );
    // ��ȡ�����¼�
    event Reward(address indexed to, uint256 amount);

    constructor(address token_) {
        tokenAddress = token_;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function userInfo(
        uint256 pid,
        address _account
    ) public view returns (UserInfo memory _user) {
        return _userInfo[pid][_account];
    }

    function setOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function setBonusDay(uint256 day) external onlyOwner {
        bonusDay = day;
    }

    function setUnstakeDuration(uint256 _duration) external onlyOwner {
        unstakeDuration = _duration;
    }

    function setStaking(bool _isStaking) external onlyOwner {
        isStaking = _isStaking;
    }

    function setCloseUnstake(bool value) external onlyOwner {
        closeUnstake = value;
    }

    function setIsBonus(bool value) external onlyOwner {
        isBonus = value;
    }

    function setAutoDelay(uint256 value) external onlyOwner {
        autoDelay = value;
    }

    function getPool(
        uint256 pid
    ) external view returns (PoolInfo memory _pool) {
        return poolInfo[pid];
    }

    function withdrawToken(
        address token_,
        address to_,
        uint256 amount_
    ) external onlyOwner {
        TransferHelper.safeTransfer(token_, to_, amount_);
    }

    // ����µ����ڳ�
    function addPool(
        address _lpToken,
        uint256 _duration,
        uint256 _allocPoint
    ) external onlyOwner {
        _addPool(_lpToken, _duration, _allocPoint);
    }

    function _addPool(
        address _lpToken,
        uint256 _duration,
        uint256 _allocPoint
    ) private {
        require(_lpToken != address(0), "invalid lp token");
        require(!isPool[_lpToken][_duration], "pool is exist"); //�����ظ���ӳ�

        totalAllocPoint += _allocPoint;
        uint256 pid = poolLength;
        poolLength += 1;

        isPool[_lpToken][_duration] = true;
        poolId[_lpToken][_duration] = pid;
        poolInfo[pid] = PoolInfo({
            totalStaked: 0,
            lpToken: _lpToken,
            duration: _duration,
            allocPoint: _allocPoint,
            accPerShare: 0
        });
    }

    // �������ڷֺ�Ȩ��
    function setPool(
        address _lpToken,
        uint256 _duration,
        uint256 _allocPoint
    ) external onlyOwner {
        require(isPool[_lpToken][_duration], "pool is not exist");

        uint256 pid = poolId[_lpToken][_duration];
        totalAllocPoint =
            totalAllocPoint -
            poolInfo[pid].allocPoint +
            _allocPoint;
        poolInfo[pid].allocPoint = _allocPoint;
    }

    function depositFee(uint256 amount_) external {
        require(msg.sender == tokenAddress, "caller is not allowed");
        totalReward += amount_;
    }

    //���뽱��
    function depositReward(uint256 amount_) external {
        uint balanceBefore = IERC20(tokenAddress).balanceOf(address(this)); //�����������ѵĴ���
        TransferHelper.safeTransferFrom(
            tokenAddress,
            msg.sender,
            address(this),
            amount_
        );

        uint balanceAdd = IERC20(tokenAddress).balanceOf(address(this)) -
            balanceBefore; //�����������ѵĴ���
        totalReward += balanceAdd;
    }

    // ��ȡ��һ�δ��ֺ�Ľ���
    function getPendingReward() public view returns (uint256) {
        return (totalReward - totalUsedReward) / bonusDay;
    }

    // ���·ֺ콱��
    function bonusReward() external {
        require(isBonus, "Bonus is not enabled");
        require(totalAllocPoint > 0, "No pool");
        uint256 _epoch_day = block.timestamp / bonusDuration;
        require(_epoch_day > lastBonusEpoch, "Error: lastBonusEpoch");

        _bonusReward();
    }

    function _bonusReward() private {
        if (isBonus && totalAllocPoint > 0) {
            uint256 _epoch_day = block.timestamp / bonusDuration;
            if (_epoch_day > lastBonusEpoch) {
                lastBonusEpoch = _epoch_day;
                lastBonusToken = getPendingReward(); //���οɷֺ�����
                if (lastBonusToken > 0) {
                    for (uint256 pid = 0; pid < poolLength; ++pid) {
                        _updatePool(pid);
                    }
                }
            }
        }
    }

    function _updatePool(uint256 pid) private {
        if (poolInfo[pid].allocPoint > 0 && poolInfo[pid].totalStaked > 0) {
            uint256 _reward = (lastBonusToken * poolInfo[pid].allocPoint) /
                totalAllocPoint;

            poolInfo[pid].accPerShare +=
                (_reward * 1e12) /
                poolInfo[pid].totalStaked;

            //��¼�ֺܷ�
            totalUsedReward += _reward;
            totalPendingReward += _reward;
        }
    }

    // ��Ѻ
    function stake(uint256 pid, uint256 amount) external returns (bool) {
        require(isStaking, "Staking is not enabled");
        require(amount > 0, "stake must be integer multiple of 1 token.");
        require(poolInfo[pid].allocPoint > 0, "stake pool is closed");

        _bonusReward(); //���·ֺ콱��
        UserInfo storage user = _userInfo[pid][msg.sender];
        if (user.stakedOf > 0) {
            // ��ȡ֮ǰ�Ľ���
            uint256 pending = ((user.stakedOf * poolInfo[pid].accPerShare) /
                1e12) - user.rewardOf;
            safeTransfer(pid, msg.sender, pending);
        }

        uint balanceBefore = IERC20(poolInfo[pid].lpToken).balanceOf(
            address(this)
        ); //�����������ѵĴ���
        //ת����Ѻ
        TransferHelper.safeTransferFrom(
            poolInfo[pid].lpToken,
            msg.sender,
            address(this),
            amount
        );
        uint balanceAdd = IERC20(poolInfo[pid].lpToken).balanceOf(
            address(this)
        ) - balanceBefore; //�����������ѵĴ���

        user.duration = poolInfo[pid].duration;
        user.lastDepositAt = block.timestamp;
        // �����û���Ѻ������
        user.stakedOf += balanceAdd;
        // �����Ѿ���ȡ�Ľ���
        user.rewardOf = (user.stakedOf * poolInfo[pid].accPerShare) / 1e12;
        // ���³�����Ʊ��
        poolInfo[pid].totalStaked += balanceAdd;

        // emit event
        emit Staked(
            msg.sender,
            poolInfo[pid].lpToken,
            poolInfo[pid].duration,
            balanceAdd
        );

        return true;
    }

    function withdrawUnstake(uint256 pid) external returns (bool) {
        uint256 _amount = userUnstakeAmount[pid][msg.sender];
        require(_amount > 0, "The withdraw amount must be greater than zero");
        require(
            block.timestamp > userUnstakeAt[pid][msg.sender] + unstakeDuration,
            "The time passed since the last unstake is less than unstakeDuration"
        );

        userUnstakeAmount[pid][msg.sender] -= _amount;
        userUnstakeAt[pid][msg.sender] = block.timestamp;
        totalUnstakeAmount[pid] -= _amount;
        TransferHelper.safeTransfer(poolInfo[pid].lpToken, msg.sender, _amount);

        emit WithdrawUnstaked(
            msg.sender,
            poolInfo[pid].lpToken,
            poolInfo[pid].duration,
            _amount
        );
        return true;
    }

    /**
     * ��Ѻ��Ѻ��
     */
    function unstake(
        uint256 pid,
        uint256 _amount
    ) external virtual returns (bool) {
        _bonusReward(); //���·ֺ콱��

        UserInfo storage user = _userInfo[pid][msg.sender];
        require(
            user.stakedOf >= _amount,
            "The inserted amount is greater than the current user's stake"
        );
        require(_amount > 0, "The inserted amount must be greater than zero");

        // ��ȡ֮ǰ�Ľ���
        uint256 pending = ((user.stakedOf * poolInfo[pid].accPerShare) / 1e12) -
            user.rewardOf; // �رյĳ�������ֱ�ӽ�Ѻ
        if (pending > 0) {
            _takeReward(pid, msg.sender, pending);
        }

        // �رյĳ�������ֱ�ӽ�Ѻ
        if (poolInfo[pid].allocPoint == 0 && closeUnstake) {} else {
            require(
                block.timestamp - user.lastDepositAt >= user.duration,
                "The time passed since the last deposit is less than user.duration"
            ); // ����
        }

        _unstake(pid, _amount);
        return true;
    }

    //������Ѻ�������Ľ���
    function emergencyUnstake(uint256 pid) external returns (bool) {
        UserInfo storage user = _userInfo[pid][msg.sender];
        require(
            user.stakedOf > 0,
            "The inserted amount is greater than the current user's stake"
        );

        // �رյĳ�������ֱ�ӽ�Ѻ
        if (poolInfo[pid].allocPoint == 0 && closeUnstake) {} else {
            require(
                block.timestamp - user.lastDepositAt >= user.duration,
                "The time passed since the last deposit is less than user.duration"
            ); // ����
        }

        _unstake(pid, user.stakedOf);
        return true;
    }

    function _unstake(uint256 pid, uint256 _amount) private {
        UserInfo storage user = _userInfo[pid][msg.sender];
        if (_amount > user.stakedOf) {
            _amount = user.stakedOf;
        }

        poolInfo[pid].totalStaked -= _amount;
        // �����û���Ѻ������
        user.stakedOf -= _amount;
        // �����Ѿ���ȡ�Ľ���
        user.rewardOf = (user.stakedOf * poolInfo[pid].accPerShare) / 1e12;
        // ���ڲ�ֱ�ӽ�ѹ,���ǽ������ֵȴ���(��ѹ�����ڴ���0�Ļ�)
        if (poolInfo[pid].duration == 0 && unstakeDuration > 0) {
            userUnstakeAmount[pid][msg.sender] += _amount;
            userUnstakeAt[pid][msg.sender] = block.timestamp;
            totalUnstakeAmount[pid] += _amount;
        } else {
            TransferHelper.safeTransfer(
                poolInfo[pid].lpToken,
                msg.sender,
                _amount
            );
        }

        emit Unstaked(
            msg.sender,
            poolInfo[pid].lpToken,
            poolInfo[pid].duration,
            _amount
        );
    }

    function rewardAmount(
        address _account,
        uint256 pid
    ) external view returns (uint256) {
        uint256 pending;
        UserInfo memory _user = userInfo(pid, _account);
        if (_user.stakedOf > 0) {
            uint256 _accPerShare = poolInfo[pid].accPerShare;
            uint256 _epoch_day = block.timestamp / bonusDuration;
            if (
                isBonus &&
                _epoch_day > lastBonusEpoch &&
                poolInfo[pid].allocPoint > 0
            ) {
                uint256 _reward = (getPendingReward() *
                    poolInfo[pid].allocPoint) / totalAllocPoint;
                _accPerShare += (_reward * 1e12) / poolInfo[pid].totalStaked;
            }
            pending = ((_user.stakedOf * _accPerShare) / 1e12) - _user.rewardOf;
        }

        return pending;
    }

    function _takeReward(
        uint256 pid,
        address _account,
        uint256 pending
    ) private {
        UserInfo storage user = _userInfo[pid][_account];

        uint256 userDepositDuration = user.lastDepositAt + user.duration;
        //�Զ�����
        if (
            user.duration > 0 &&
            (block.timestamp > autoDelay + userDepositDuration)
        ) {
            user.lastDepositAt = block.timestamp;
        }

        safeTransfer(pid, _account, pending);
    }

    // ֱ����ȡ����
    function takeReward(uint256 pid) external {
        _bonusReward(); //���·ֺ콱��

        UserInfo storage user = _userInfo[pid][msg.sender];
        require(user.stakedOf > 0, "Staking: out of staked");
        uint256 pending = ((user.stakedOf * poolInfo[pid].accPerShare) / 1e12) -
            user.rewardOf;
        require(pending > 0, "Staking: no pending reward");

        _takeReward(pid, msg.sender, pending);
        if (
            user.duration > 0 &&
            (block.timestamp - user.lastDepositAt >= user.duration)
        ) {
            _unstake(pid, user.stakedOf);
        } else {
            user.rewardOf = (user.stakedOf * poolInfo[pid].accPerShare) / 1e12;
        }
    }

    // ��ȫ��ת�˹��ܣ��Է���һ�����������³�û���㹻�Ľ�����
    function safeTransfer(
        uint256 pid,
        address _account,
        uint256 _amount
    ) private {
        if (_amount > 0) {
            if (_amount > totalPendingReward) {
                _amount = totalPendingReward;
            }

            UserInfo storage user = _userInfo[pid][_account];
            totalPendingReward -= _amount;
            user.userReward += _amount;
            TransferHelper.safeTransfer(tokenAddress, _account, _amount);
            emit Reward(_account, _amount);
        }
    }
}