/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVault {
    function addWhitelist(address addr) external;

    function removeWhitelist(address addr) external;

    function withdraw(address tokenAddress, address to, uint256 amount) external;

    function isWhitelist(address addr) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: src/NFTFI.sol

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface CustomIERC721 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function safeMint(address to) external;

    function batchMint(address to, uint256 count) external returns (bool);

    function currentTokenId() external view returns (uint256);
}

contract NFTFI is Ownable {
    CustomIERC721 public NFT;
    IERC20 public BELE;
    IVault public vault;
    uint256 public nftMaxReleaseStage = 100;
    uint256 private _nftCurrentReleaseStage;
    uint256 public nftReleaseCountEachStage = 100;
    uint256 public nftCurrentReleaseCount;
    uint256 public nftCurrentSoldCount;
    uint256 public nftCurrentBuyableCount;
    uint256 public nftRewardCycle = 120 days;
    uint256 public buyAmount = 1000000 * 10 ** 18;
    uint256 public rewardAmount = buyAmount * 2;
    uint256 public defaultSellingTime;
    address private _destroyAddress = address(0x000000000000000000000000000000000000dEaD);
    mapping(uint256 => NftInfo) public nftInfoMap;

    event WithdrawReward(address indexed buyer, uint256[] tokenIds, uint256[] amounts);

    event Buy(address indexed buyer, uint256[] tokenId);

    struct NftInfo {
        uint256 tokenId;
        uint256 sellTime;
        uint256 lastWithdrawTime;
        uint256 rewardBalance;
        uint256 withdrawableBalance;
        bool exist;
    }

    constructor(address bele_, address nft_, address vault_) {
        BELE = IERC20(bele_);
        NFT = CustomIERC721(nft_);
        vault = IVault(vault_);
        defaultSellingTime = block.timestamp;
        uint256 externalNFTCount = NFT.currentTokenId();
        nftCurrentSoldCount = externalNFTCount;
        nftCurrentReleaseCount = externalNFTCount;
    }

    function release() public onlyOwner returns (bool) {
        require(nftCurrentReleaseStage() < nftMaxReleaseStage, "NFTFI: max release stage");
        nftCurrentReleaseCount += nftReleaseCountEachStage;
        nftCurrentBuyableCount += nftReleaseCountEachStage;
        return true;
    }

    function buy(uint256 count) public returns (bool) {
        address buyer = msg.sender;
        require(nftCurrentBuyableCount >= count, "NFTFI: not have enough nft");
        nftCurrentBuyableCount -= count;
        nftCurrentSoldCount += count;
        require(BELE.transferFrom(buyer, _destroyAddress, buyAmount * count), "NFTFI: transfer token from buyer failed");
        sell(buyer, count);
        return true;
    }

    function sell(address buyer, uint256 count) private {
        uint256[] memory tokenIds = new uint256[](count);
        uint256 nowTime = block.timestamp;
        uint256 currentTokenId = NFT.currentTokenId();
        for (uint256 i = 0; i < count; i++) {
            NftInfo memory info = NftInfo({
                tokenId: currentTokenId,
                sellTime: nowTime,
                lastWithdrawTime: nowTime,
                rewardBalance: rewardAmount,
                withdrawableBalance: 0,
                exist: true
            });
            nftInfoMap[currentTokenId] = info;
            tokenIds[i] = currentTokenId;
            currentTokenId++;
        }
        NFT.batchMint(buyer, count);
        emit Buy(buyer, tokenIds);
    }

    function withdrawReward(uint256[] calldata tokenIds) public returns (bool) {
        address buyer = msg.sender;
        NftInfo[] memory infoList = nftsInfo(tokenIds);
        NftInfo memory info;
        uint256 totalRewardAmount;
        uint256 withdrawableAmount;
        uint256 nowTime = block.timestamp;
        uint256[] memory amounts = new uint256[](infoList.length);
        for (uint256 i = 0; i < infoList.length; i++) {
            info = infoList[i];
            require(NFT.ownerOf(info.tokenId) == buyer, "NFTFI: invalid buyer");
            withdrawableAmount = info.withdrawableBalance;
            info.lastWithdrawTime = nowTime;
            info.withdrawableBalance = 0;
            nftInfoMap[info.tokenId] = info;
            totalRewardAmount += withdrawableAmount;
            amounts[i] = withdrawableAmount;
        }
        vault.withdraw(address(BELE), buyer, totalRewardAmount);
        emit WithdrawReward(buyer, tokenIds, amounts);
        return true;
    }

    function nftsInfo(uint256[] calldata tokenIds) public view returns (NftInfo[] memory) {
        NftInfo[] memory infoList = new NftInfo[](tokenIds.length);
        NftInfo memory info;
        uint256 releaseAmountSecond = rewardAmount / nftRewardCycle;
        uint256 withdrawableAmount;
        uint256 tokenId;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            tokenId = tokenIds[i];
            info = nftInfoMap[tokenId];
            if (!info.exist) {
                info.tokenId = tokenId;
                info.sellTime = defaultSellingTime;
                info.lastWithdrawTime = defaultSellingTime;
                info.rewardBalance = rewardAmount;
                info.exist = true;
            }
            withdrawableAmount = (block.timestamp - info.lastWithdrawTime) * releaseAmountSecond;
            if (withdrawableAmount > info.rewardBalance) {
                withdrawableAmount = info.rewardBalance;
            }
            info.withdrawableBalance = withdrawableAmount;
            info.rewardBalance -= withdrawableAmount;
            infoList[i] = info;
        }
        return infoList;
    }

    function nftCurrentReleaseStage() public view returns (uint256) {
        uint256 stage = nftCurrentReleaseCount / 100;
        if (stage * 100 < nftCurrentReleaseCount) {
            stage++;
        }
        return stage;
    }
}