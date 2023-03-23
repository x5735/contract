/**
 *Submitted for verification at BscScan.com on 2023-03-22
*/

/*
___  ___     _       ______ _ _       
|  \/  |    | |      |  ___| (_)      
| .  . | ___| |_ __ _| |_  | |_ _ __  
| |\/| |/ _ \ __/ _` |  _| | | | '_ \ 
| |  | |  __/ || (_| | |   | | | |_) |
\_|  |_/\___|\__\__,_\_|   |_|_| .__/ 
                               | |    
                               |_|  

*/


// SPDX-License-Identifier: MIT

// File: @chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol


pragma solidity ^0.8.4;

/** ****************************************************************************
 * @notice Interface for contracts using VRF randomness
 * *****************************************************************************
 * @dev PURPOSE
 *
 * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
 * @dev to Vera the verifier in such a way that Vera can be sure he's not
 * @dev making his output up to suit himself. Reggie provides Vera a public key
 * @dev to which he knows the secret key. Each time Vera provides a seed to
 * @dev Reggie, he gives back a value which is computed completely
 * @dev deterministically from the seed and the secret key.
 *
 * @dev Reggie provides a proof by which Vera can verify that the output was
 * @dev correctly computed once Reggie tells it to her, but without that proof,
 * @dev the output is indistinguishable to her from a uniform random sample
 * @dev from the output space.
 *
 * @dev The purpose of this contract is to make it easy for unrelated contracts
 * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
 * @dev simple access to a verifiable source of randomness. It ensures 2 things:
 * @dev 1. The fulfillment came from the VRFCoordinator
 * @dev 2. The consumer contract implements fulfillRandomWords.
 * *****************************************************************************
 * @dev USAGE
 *
 * @dev Calling contracts must inherit from VRFConsumerBase, and can
 * @dev initialize VRFConsumerBase's attributes in their constructor as
 * @dev shown:
 *
 * @dev   contract VRFConsumer {
 * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
 * @dev       VRFConsumerBase(_vrfCoordinator) public {
 * @dev         <initialization with other arguments goes here>
 * @dev       }
 * @dev   }
 *
 * @dev The oracle will have given you an ID for the VRF keypair they have
 * @dev committed to (let's call it keyHash). Create subscription, fund it
 * @dev and your consumer contract as a consumer of it (see VRFCoordinatorInterface
 * @dev subscription management functions).
 * @dev Call requestRandomWords(keyHash, subId, minimumRequestConfirmations,
 * @dev callbackGasLimit, numWords),
 * @dev see (VRFCoordinatorInterface for a description of the arguments).
 *
 * @dev Once the VRFCoordinator has received and validated the oracle's response
 * @dev to your request, it will call your contract's fulfillRandomWords method.
 *
 * @dev The randomness argument to fulfillRandomWords is a set of random words
 * @dev generated from your requestId and the blockHash of the request.
 *
 * @dev If your contract could have concurrent requests open, you can use the
 * @dev requestId returned from requestRandomWords to track which response is associated
 * @dev with which randomness request.
 * @dev See "SECURITY CONSIDERATIONS" for principles to keep in mind,
 * @dev if your contract could have multiple requests in flight simultaneously.
 *
 * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
 * @dev differ.
 *
 * *****************************************************************************
 * @dev SECURITY CONSIDERATIONS
 *
 * @dev A method with the ability to call your fulfillRandomness method directly
 * @dev could spoof a VRF response with any random value, so it's critical that
 * @dev it cannot be directly called by anything other than this base contract
 * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
 *
 * @dev For your users to trust that your contract's random behavior is free
 * @dev from malicious interference, it's best if you can write it so that all
 * @dev behaviors implied by a VRF response are executed *during* your
 * @dev fulfillRandomness method. If your contract must store the response (or
 * @dev anything derived from it) and use it later, you must ensure that any
 * @dev user-significant behavior which depends on that stored value cannot be
 * @dev manipulated by a subsequent VRF request.
 *
 * @dev Similarly, both miners and the VRF oracle itself have some influence
 * @dev over the order in which VRF responses appear on the blockchain, so if
 * @dev your contract could have multiple VRF requests in flight simultaneously,
 * @dev you must ensure that the order in which the VRF responses arrive cannot
 * @dev be used to manipulate your contract's user-significant behavior.
 *
 * @dev Since the block hash of the block which contains the requestRandomness
 * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
 * @dev miner could, in principle, fork the blockchain to evict the block
 * @dev containing the request, forcing the request to be included in a
 * @dev different block with a different hash, and therefore a different input
 * @dev to the VRF. However, such an attack would incur a substantial economic
 * @dev cost. This cost scales with the number of blocks the VRF oracle waits
 * @dev until it calls responds to a request. It is for this reason that
 * @dev that you can signal to an oracle you'd like them to wait longer before
 * @dev responding to the request (however this is not enforced in the contract
 * @dev and so remains effective only in the case of unmodified oracle software).
 */
abstract contract VRFConsumerBaseV2 {
  error OnlyCoordinatorCanFulfill(address have, address want);
  address private immutable vrfCoordinator;

  /**
   * @param _vrfCoordinator address of VRFCoordinator contract
   */
  constructor(address _vrfCoordinator) {
    vrfCoordinator = _vrfCoordinator;
  }

  /**
   * @notice fulfillRandomness handles the VRF response. Your contract must
   * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
   * @notice principles to keep in mind when implementing your fulfillRandomness
   * @notice method.
   *
   * @dev VRFConsumerBaseV2 expects its subcontracts to have a method with this
   * @dev signature, and will call it once it has verified the proof
   * @dev associated with the randomness. (It is triggered via a call to
   * @dev rawFulfillRandomness, below.)
   *
   * @param requestId The Id initially returned by requestRandomness
   * @param randomWords the VRF output expanded to the requested number of words
   */
  function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal virtual;

  // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
  // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
  // the origin of the call
  function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external {
    if (msg.sender != vrfCoordinator) {
      revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
    }
    fulfillRandomWords(requestId, randomWords);
  }
}

// File: @chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol

pragma solidity ^0.8.0;

contract ContractWithReflectToOwners {
    function reflectToOwners(uint256) public payable {
    }
}

interface IReflectingContract {
    function reflectToOwners() payable external;
}

pragma solidity ^0.8.0;

interface VRFCoordinatorV2Interface {
  /**
   * @notice Get configuration relevant for making requests
   * @return minimumRequestConfirmations global min for request confirmations
   * @return maxGasLimit global max for request gas limit
   * @return s_provingKeyHashes list of registered key hashes
   */
  function getRequestConfig()
    external
    view
    returns (
      uint16,
      uint32,
      bytes32[] memory
    );

  /**
   * @notice Request a set of random words.
   * @param keyHash - Corresponds to a particular oracle job which uses
   * that key for generating the VRF proof. Different keyHash's have different gas price
   * ceilings, so you can select a specific one to bound your maximum per request cost.
   * @param subId  - The ID of the VRF subscription. Must be funded
   * with the minimum subscription balance required for the selected keyHash.
   * @param minimumRequestConfirmations - How many blocks you'd like the
   * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
   * for why you may want to request more. The acceptable range is
   * [minimumRequestBlockConfirmations, 200].
   * @param callbackGasLimit - How much gas you'd like to receive in your
   * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
   * may be slightly less than this amount because of gas used calling the function
   * (argument decoding etc.), so you may need to request slightly more than you expect
   * to have inside fulfillRandomWords. The acceptable range is
   * [0, maxGasLimit]
   * @param numWords - The number of uint256 random values you'd like to receive
   * in your fulfillRandomWords callback. Note these numbers are expanded in a
   * secure way by the VRFCoordinator from a single random value supplied by the oracle.
   * @return requestId - A unique identifier of the request. Can be used to match
   * a request to a response in fulfillRandomWords.
   */
  function requestRandomWords(
    bytes32 keyHash,
    uint64 subId,
    uint16 minimumRequestConfirmations,
    uint32 callbackGasLimit,
    uint32 numWords
  ) external returns (uint256 requestId);

  /**
   * @notice Create a VRF subscription.
   * @return subId - A unique subscription id.
   * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
   * @dev Note to fund the subscription, use transferAndCall. For example
   * @dev  LINKTOKEN.transferAndCall(
   * @dev    address(COORDINATOR),
   * @dev    amount,
   * @dev    abi.encode(subId));
   */
  function createSubscription() external returns (uint64 subId);

  /**
   * @notice Get a VRF subscription.
   * @param subId - ID of the subscription
   * @return balance - LINK balance of the subscription in juels.
   * @return reqCount - number of requests for this subscription, determines fee tier.
   * @return owner - owner of the subscription.
   * @return consumers - list of consumer address which are able to use this subscription.
   */
  function getSubscription(uint64 subId)
    external
    view
    returns (
      uint96 balance,
      uint64 reqCount,
      address owner,
      address[] memory consumers
    );

  /**
   * @notice Request subscription owner transfer.
   * @param subId - ID of the subscription
   * @param newOwner - proposed new owner of the subscription
   */
  function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner) external;

  /**
   * @notice Request subscription owner transfer.
   * @param subId - ID of the subscription
   * @dev will revert if original owner of subId has
   * not requested that msg.sender become the new owner.
   */
  function acceptSubscriptionOwnerTransfer(uint64 subId) external;

  /**
   * @notice Add a consumer to a VRF subscription.
   * @param subId - ID of the subscription
   * @param consumer - New consumer which can use the subscription
   */
  function addConsumer(uint64 subId, address consumer) external;

  /**
   * @notice Remove a consumer from a VRF subscription.
   * @param subId - ID of the subscription
   * @param consumer - Consumer to remove from the subscription
   */
  function removeConsumer(uint64 subId, address consumer) external;

  /**
   * @notice Cancel a subscription
   * @param subId - ID of the subscription
   * @param to - Where to send the remaining LINK to
   */
  function cancelSubscription(uint64 subId, address to) external;

  /*
   * @notice Check to see if there exists a request commitment consumers
   * for all consumers and keyhashes for a given sub.
   * @param subId - ID of the subscription
   * @return true if there exists at least one unfulfilled request for the subscription, false
   * otherwise.
   */
  function pendingRequestExists(uint64 subId) external view returns (bool);
}

// File: @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol


pragma solidity ^0.8.0;

interface LinkTokenInterface {
  function allowance(address owner, address spender) external view returns (uint256 remaining);

  function approve(address spender, uint256 value) external returns (bool success);

  function balanceOf(address owner) external view returns (uint256 balance);

  function decimals() external view returns (uint8 decimalPlaces);

  function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);

  function increaseApproval(address spender, uint256 subtractedValue) external;

  function name() external view returns (string memory tokenName);

  function symbol() external view returns (string memory tokenSymbol);

  function totalSupply() external view returns (uint256 totalTokensIssued);

  function transfer(address to, uint256 value) external returns (bool success);

  function transferAndCall(
    address to,
    uint256 value,
    bytes calldata data
  ) external returns (bool success);

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool success);
}

// File: test/ReentrancyGuard.sol


// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity 0.8.7;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: test/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity 0.8.7;

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
}

// File: test/Ownable.sol


pragma solidity 0.8.7;


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



pragma solidity 0.8.7;


contract MetaFlip is Ownable, VRFConsumerBaseV2, ReentrancyGuard {
    VRFCoordinatorV2Interface COORDINATOR;
    LinkTokenInterface LINKTOKEN;
address payable externalAddress;
address payable marketAddress;
address payable devAddress;
address payable artistAddress;
address payable modAddress;


    /* Storage:
     ***********/

    address constant vrfCoordinator = 0xc587d9053cd1118f25F645F9E08BB98c9712A4EE;
    address constant link_token_contract = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;

    bytes32 constant keyHash = 0xba6e730de88d94a5510ae6613898bfb0c3de5d16e609c5b7da808747125506f7;
    uint16 constant requestConfirmations = 3;
    uint32 constant callbackGasLimit = 2e5;
    uint32 constant numWords = 1;
    uint64 subscriptionId;
    uint256 private contractBalance;
    uint256 private flips;
    uint256 private wins;
    uint256 private losses;
    uint256 private payout;

IReflectingContract reflectingContract = IReflectingContract(0xf262Dc22ca5B2f1F4Ba5FefA6453Ff1c030A99b2);

    struct Temp {
        uint256 id;
        uint256 result;
        address playerAddress;
    }

    struct PlayerByAddress {
        uint256 balance;
        uint256 betAmount;
        uint256 betChoice;
        address playerAddress;
        bool betOngoing;
        uint256 finalAmount;
        uint256 flips;
        uint256 gwin;
        uint256 lose;
    }

    mapping(address => PlayerByAddress) public playersByAddress; //to check who is the player
    mapping(uint256 => Temp) public temps; //to check who is the sender of a pending bet by Id

    /* Events:
     *********/

    event DepositToContract(address user, uint256 depositAmount, uint256 newBalance);
    event Withdrawal(address player, uint256 amount);
    event NewIdRequest(address indexed player, uint256 requestId);
    event GeneratedRandomNumber(uint256 requestId, uint256 randomNumber);
    event BetResult(address indexed player, bool victory, uint256 amount);

    /* Constructor:
     **************/

    constructor(uint64 _subscriptionId,address payable _externalAddress,address payable _marketAddress,address payable _devAddress,address payable _artistAddress,address payable _modAddress) payable initCosts(0.01 ether) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(link_token_contract);
        subscriptionId = _subscriptionId;
        contractBalance += msg.value;
        externalAddress = _externalAddress;
        marketAddress = _marketAddress;
        devAddress = _devAddress;
        artistAddress = _artistAddress;
        modAddress = _modAddress;
    }

    /* Modifiers:
     ************/

    modifier initCosts(uint256 initCost) {
        require(msg.value >= initCost, "Contract needs some ETH.");
        _;
    }

    modifier betConditions() {
        require(msg.value >= 0.01 ether, "Insuffisant amount, please increase your bet!");
        require(msg.value <= getContractBalance() / 5, "Can't bet more than 20% the contract's balance!");
        require(!playersByAddress[msg.sender].betOngoing, "Bet already ongoing with this address");
        _;
    }

    /* Functions:
     *************/

function bet(uint256 _betChoice) public payable betConditions nonReentrant {
    require(_betChoice == 0 || _betChoice == 1, "Must be either 0 or 1");

    playersByAddress[msg.sender].playerAddress = msg.sender;
    playersByAddress[msg.sender].betChoice = _betChoice;
    playersByAddress[msg.sender].betOngoing = true;
    playersByAddress[msg.sender].flips += 1;
    flips += 1;
    losses += 1;
    playersByAddress[msg.sender].lose += 1;

    // Calculate the after tax amount and the tax amount
    uint256 betAmount = msg.value - (msg.value * 3 / 100);
    uint256 nftAmount = msg.value - (msg.value * 97 / 100);
    uint256 taxAmount = msg.value - (msg.value * 90 / 100);
    uint256 totalAmount = taxAmount + (msg.value * 15 / 100);
    uint256 finalAmount = msg.value - totalAmount;
    playersByAddress[msg.sender].betAmount = betAmount;
    playersByAddress[msg.sender].finalAmount = finalAmount;
    contractBalance += playersByAddress[msg.sender].finalAmount;

    uint256 requestId = requestRandomWords();
    temps[requestId].playerAddress = msg.sender;
    temps[requestId].id = requestId;

    emit NewIdRequest(msg.sender, requestId);

    // Send the tax amount to the external addresses
    externalAddress.transfer(taxAmount);
    marketAddress.transfer(nftAmount);
    devAddress.transfer(nftAmount);
    artistAddress.transfer(nftAmount);
    modAddress.transfer(nftAmount);
    reflectingContract.reflectToOwners{value: nftAmount}();
}

    /// @notice Assumes the subscription is funded sufficiently.
    function requestRandomWords() internal returns (uint256) {
        return
            COORDINATOR.requestRandomWords(keyHash, subscriptionId, requestConfirmations, callbackGasLimit, numWords);
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal override {
        uint256 randomResult = _randomWords[0] % 2;
        temps[_requestId].result = randomResult;

        checkResult(randomResult, _requestId);
        emit GeneratedRandomNumber(_requestId, randomResult);
    }

function checkResult(uint256 _randomResult, uint256 _requestId) private returns (bool) {
address player = temps[_requestId].playerAddress;
bool win = false;
uint256 amountWon = 0;
    if (playersByAddress[player].betChoice == _randomResult) {
        win = true;
        amountWon = playersByAddress[player].betAmount * 2;
        playersByAddress[player].balance = playersByAddress[player].balance + amountWon;
        contractBalance -= amountWon;
        playersByAddress[msg.sender].gwin += 1;
        wins += 1;
        losses -= 1;
        playersByAddress[msg.sender].lose -= 1;
    }

    emit BetResult(player, win, amountWon);

    playersByAddress[player].betAmount = 0;
    playersByAddress[player].finalAmount = 0;
    playersByAddress[player].betOngoing = false;
    delete (temps[_requestId]);
    return win;
}

function clearPlayerCache(address playerAddress) public {
    require(msg.sender == playerAddress, "You can only clear your own cache");
    playersByAddress[playerAddress].betAmount = 0;
    playersByAddress[playerAddress].finalAmount = 0;
    playersByAddress[playerAddress].betOngoing = false;
}

function clearPlayerCacheAdmin(address playerAddress) public onlyOwner {
    playersByAddress[playerAddress].betAmount = 0;
    playersByAddress[playerAddress].finalAmount = 0;
    playersByAddress[playerAddress].betOngoing = false;
}

    function deposit() external payable {
        require(msg.value > 0);
        contractBalance += msg.value;
        emit DepositToContract(msg.sender, msg.value, contractBalance);
    }

        function depositExt() external payable {
        require(msg.value > 0);
    }

    receive() external payable {}

    function withdrawPlayerBalance() external nonReentrant {
        require(msg.sender != address(0), "This address doesn't exist.");
        require(playersByAddress[msg.sender].balance > 0, "You don't have any fund to withdraw.");
        require(!playersByAddress[msg.sender].betOngoing, "This address still has an open bet.");

        uint256 amount = playersByAddress[msg.sender].balance;
        payable(msg.sender).transfer(amount);
        payout += amount;
        delete (playersByAddress[msg.sender]);

        emit Withdrawal(msg.sender, amount);
    }

    /* View functions:
     *******************/

    function getPlayerBalance() external view returns (uint256) {
        return playersByAddress[msg.sender].balance;
    }

    function getPlayerWins() external view returns (uint256) {
        return playersByAddress[msg.sender].gwin;
    }

    function getPlayerLosses() external view returns (uint256) {
        return playersByAddress[msg.sender].lose;
    }

    function getPlayerFlips() external view returns (uint256) {
        return playersByAddress[msg.sender].flips;
    }

    function getContractBalance() public view returns (uint256) {
        return contractBalance;
    }

    function getPayout() public view returns (uint256) {
        return payout;
    }

    function getTotalGlobalFlips() public view returns (uint256) {
        return flips;
    }

    function getTotalGlobalWins() public view returns (uint256) {
        return wins;
    }

    function getTotalGlobalLoses() public view returns (uint256) {
        return losses;
    }

    function getMinimumBet() public view returns (uint256) {
    return contractBalance / 5;
}

    /* PRIVATE :
     ***********/

    function setExternalAddress(address payable _externalAddress) public onlyOwner {
    externalAddress = _externalAddress;
}    
    function setMarketAddress(address payable _marketAddress) public onlyOwner {
    marketAddress = _marketAddress;
}
    function setDevAddress(address payable _devAddress) public onlyOwner {
    devAddress = _devAddress;
}
    function setArtistAddress(address payable _artistAddress) public onlyOwner {
    artistAddress = _artistAddress;
}
    function setModAddress(address payable _modAddress) public onlyOwner {
    modAddress = _modAddress;
}
    function cancelGame() public payable onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: contractBalance}("");
    contractBalance = 0;
    require(success);
  }

      function emergencyCancel() public payable onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    contractBalance = 0;
    require(success);
  }
  
}