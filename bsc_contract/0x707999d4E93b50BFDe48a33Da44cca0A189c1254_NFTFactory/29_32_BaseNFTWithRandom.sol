// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "../Base/BaseNFT.sol";
import "./utils/VRFConsumerBaseUpgradeable.sol";

contract BaseNFTWithRandom is BaseNFT, VRFConsumerBaseUpgradeable {
    bool internal isrequestfulfilled;
    uint256 private constant PRIMENUMBER = 111119;
    uint256 public fee;
    uint256 private randomNumber;
    bytes32 internal keyHash;
    bytes32 private vrfRequestId;

    struct randomConfig {
        address vrfCoordinator;
        address link;
        bytes32 keyHash;
        uint256 fee;
    }

    /**
    @notice Event when random number is requested  
    @param sender Address of the sender  
    @param vrfRequestId Chainlink request id of the request  
    */
    event RandomNumberRequested(address indexed sender, bytes32 indexed vrfRequestId);

    /**
    @notice Event when random number is generated  
    @param requestId Chainlink request id of the request   
    @param randomNumber Generated random number  
    */
    event RandomNumberCompleted(bytes32 indexed requestId, uint256 randomNumber);

    /**
    @notice This function is used to request random number from chainlink oracle  
    @dev Make sure there is link token available for fees  
    @return vrfRequestId chianlink request id  
    @return lockBlock block number when the random number is generated  
    */
    function requestRandomNumber() external onlyOwner returns (bytes32, uint32) {
        require(block.timestamp >= publicSaleEndTime, "Public sale is not yet ended");
        require(!isrequestfulfilled, "Already obtained random number");
        require(LINK.balanceOf(address(this)) >= fee, "LINK Balance>fee");

        uint32 lockBlock = uint32(block.number);
        vrfRequestId = requestRandomness(keyHash, fee);
        emit RandomNumberRequested(msg.sender, vrfRequestId);
        return (vrfRequestId, lockBlock);
    }

    /**
    @dev Callback function for chainlink oracle and store the random number  
    */
    function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
        randomNumber = _randomness;
        isrequestfulfilled = true;
        emit RandomNumberCompleted(_requestId, _randomness);
    }

    /**
    @notice This function is used to get random asset id  
    @return assetID Random assetID  
    */
    function _getAssetId(uint256 _tokenID) internal view returns (uint256) {
        require(_tokenID > 0 && _tokenID <= totalMint, "Invalid token Id");
        require(isrequestfulfilled, "Please wait for random number to be assigned");
        uint256 assetID;
        assetID = PRIMENUMBER * _tokenID + (randomNumber % PRIMENUMBER);
        assetID = assetID % totalMint;
        if (assetID == 0) assetID = totalMint;
        return assetID;
    }

    /**
    @notice This function is used to withdraw the LINK tokens 
    @param _amount Amount to withdraw
    */
    function withdrawLink(uint256 _amount) external onlyOwner nonReentrant {
        require(both(_amount > 0, LINK.balanceOf(address(this)) >= _amount), "Not enough LINK");

        require(LINK.transfer(msg.sender, _amount), "Transfer failed.");
    }

    // ============================ Getter Functions ============================

    /**
    @notice This function is used to get random number  
    @return randomNumber Random number generated by chainlink  
    */
    function getRandomNumber() external view returns (uint256) {
        require(isrequestfulfilled, "Please wait for random number to be assigned");

        return randomNumber;
    }

    /**
    @notice This function is used to get Link address  
    @return address Link address  
    */
    function getLinkAddress() external view returns (address) {
        return address(LINK);
    }
}