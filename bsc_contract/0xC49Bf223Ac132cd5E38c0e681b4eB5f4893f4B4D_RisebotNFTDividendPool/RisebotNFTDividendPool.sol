/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

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

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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

interface INFT {
    function totalSupply(uint256 tokenId) external view returns (uint256);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function balanceOf(address owner, uint256 tokenId) external view returns (uint256 balance);
}

abstract contract AbsNFTPool is Ownable {
    using SafeMath for uint256;

    address private _lpToken;

    address private _rewardToken;

    address private _nft;

    PoolInfo private poolInfo;

    mapping(address => UserInfo) _userInfo;

    address[] lianchuangs;
    mapping(address => uint256) lianchuangIndexes;

    struct PoolInfo {
        uint256 releaseLPStartTime;
        uint256 accTokenRewardPerDay;
    }

    struct UserInfo {
        uint256 lockLPAmount;
        uint256 releaseTokenAmount;
        uint256 releaseLPAmount;
        uint256 releaseTime;
    }

    event RewardPaid(address indexed user, uint256 tokenReward, uint256 lpReward);


    constructor(
        address LPToken, address RewardToken,
        address NFT
    ){
        _lpToken = LPToken;
        _nft = NFT;
        _rewardToken = RewardToken;
    }

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function setNFT(address NFT) public onlyOwner {
        _nft = NFT;
    }

    function setLPToken(address lpToken) external onlyOwner {
        _lpToken = lpToken;
    }

    function setRewardToken(address rewardToken) external onlyOwner {
        _rewardToken = rewardToken;
    }

    function setReleaseLPStartTime(uint256 t) public onlyOwner {
        poolInfo.releaseLPStartTime = t;
    }

    function setAccTokenRewardPerDay(uint256 amount) public onlyOwner {
        poolInfo.accTokenRewardPerDay = amount;
    }

    function initLPLockAmounts(
        address[] memory accounts,
        uint256 lpAmount
    ) public onlyOwner {
        uint256 len = accounts.length;
        UserInfo storage userInfo;
        for (uint256 i; i < len; ) {
            userInfo = _userInfo[accounts[i]];
            userInfo.lockLPAmount = lpAmount;

            addlianchuang(accounts[i]);
            unchecked {
                ++i;
            }
        }
    }

    function cancelLPLockAmounts(address[] memory accounts) public onlyOwner {
        uint256 len = accounts.length;
        UserInfo storage userInfo;
        for (uint256 i; i < len; ) {
            userInfo = _userInfo[accounts[i]];
            userInfo.lockLPAmount = 0;

            quitlianchuang(accounts[i]);
            unchecked {
                ++i;
            }
        }
    }

    function addlianchuang(address lianchuang) internal {
        lianchuangIndexes[lianchuang] = lianchuangs.length;
        lianchuangs.push(lianchuang);
    }

    function quitlianchuang(address lianchuang) private {
        removelianchuang(lianchuang);
    }

    function removelianchuang(address lianchuang) internal {
        lianchuangs[lianchuangIndexes[lianchuang]] = lianchuangs[
            lianchuangs.length - 1
        ];
        lianchuangIndexes[
            lianchuangs[lianchuangs.length - 1]
        ] = lianchuangIndexes[lianchuang];
        lianchuangs.pop();
    }


    function getPoolInfo() public view returns (
        uint256 releaseLPStartTime,
        uint256 accTokenRewardPerDay
    ) {
        releaseLPStartTime = poolInfo.releaseLPStartTime;
        accTokenRewardPerDay = poolInfo.accTokenRewardPerDay;
    }

    function getUserInfo(uint256 id, address account) public view returns (
        uint256 releaseTokenAmount, uint256 releaseLPAmount,
        uint256 releaseTime, uint256 pendingTokenAmount,
        uint256 pendingLPAmount, uint256 lockLPAmount
    ) {
        UserInfo storage user = _userInfo[account];

        releaseTokenAmount = user.releaseTokenAmount;
        releaseLPAmount = user.releaseLPAmount;
        releaseTime = user.releaseTime;
        lockLPAmount = user.lockLPAmount;

        (pendingTokenAmount, pendingLPAmount) = pendingAllReward(id, account);
    }

    function pendingAllReward(uint256 id, address account) private view returns (uint256 pendingToken, uint256 pendingLP) {

        if (block.timestamp < poolInfo.releaseLPStartTime) {
            return (0, 0);
        }

        uint totalNFT = INFT(_nft).totalSupply(id);

        uint balances = INFT(_nft).balanceOf(account, id);

        UserInfo memory user = _userInfo[account];

        uint256 releaseTime = user.releaseTime > poolInfo.releaseLPStartTime ? user.releaseTime : poolInfo.releaseLPStartTime; 

        //pendingToken
        if (totalNFT == 0) {
            pendingToken = 0;
        } else {
            pendingToken =  block.timestamp.sub(releaseTime).mul(poolInfo.accTokenRewardPerDay).div(1 days).mul(balances).div(totalNFT);
        }
        

        //pendingLP
        uint256 lockAmount = user.lockLPAmount.sub(user.releaseLPAmount);

        pendingLP = block.timestamp.sub(releaseTime).mul(user.lockLPAmount).div(100).div(1 days);
        if (pendingLP > lockAmount) {
            pendingLP = lockAmount;
        }

    }

    function claim(uint256 id) public {
        address account = msg.sender;
        UserInfo storage user = _userInfo[account];
        (uint256 pendingToken, uint256 pendingLP) = pendingAllReward(id, account);
        if (pendingToken > 0) {
            if (_rewardToken == address(2)) {
                safeTransferBNB(account, pendingToken);
            } else {
                IERC20(_rewardToken).transfer(account, pendingToken);
            }
            user.releaseTokenAmount += pendingToken;
        }

        if (pendingLP > 0) {
            IERC20(_lpToken).transfer(account, pendingLP);
            user.releaseLPAmount += pendingLP;
        }

        user.releaseTime = block.timestamp;

        emit RewardPaid(account, pendingToken, pendingLP);
    }

    function safeTransferBNB(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
    }

    function claimBalance(address to, uint256 amount) external onlyOwner {
        payable(to).transfer(amount);
    }

    function claimToken(address token, address to, uint256 amount) external onlyOwner {
        IERC20(token).transfer(to, amount);
    } 
    
}

contract RisebotNFTDividendPool is AbsNFTPool {
    constructor() AbsNFTPool(
    //Risebot-BNB-LP
        address(0x5E23452204A05190b8ce443F37b9712C03fF672E),
    //BNB
        address(2),
    //NFT
        address(0xE0a34d2DeF2E2D140C70811b601BA4Cd13e4e6e0)
    ){

    }
}