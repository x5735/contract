// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import './Ownable.sol';
import "./IRedCat.sol";
import "./IERC721TokenReceiver.sol";
import "./ReentrancyGuard.sol";

struct RedCatOrder {
    address borrowAddress;
    uint borrowMoney;
    uint borrowTime;
    uint salePrice;
}

contract RedCatJail is Ownable, IERC721TokenReceiver, ReentrancyGuard {

    // constant
    IRedCat immutable RedCat;

    // attributes
    bool public saleOpen = false;
    bool public borrowOpen = false;
    uint public borrowPrice = 0.2 ether;
    uint public mintPrice = 0.3 ether;
    uint public holdTime = 60 days;
    uint public redemptionTime = 90 days;
    uint public abandonTime = 180 days;

    mapping(address => mapping(uint tokenId => RedCatOrder)) jail;
    mapping(address => mapping(uint tokenId => RedCatOrder)) abandon;

    // event
    event BorrowMoney(address borrower, uint borrowMoney, uint tokenId);
    event DepositMoney(address depositor, uint money);
    event BuyRedCat(address buyer, uint tokenId, uint money);
    event RedemptionRedCat(address redeemer, uint tokenId, uint money);

    constructor(address RedCatAddress) payable {
        RedCat = IRedCat(RedCatAddress);
        emit DepositMoney(msg.sender, msg.value);
    }

    receive() external payable {
        emit DepositMoney(msg.sender, msg.value);
    }

    function borrowMoney(uint[] calldata tokenIds) external nonReentrant {
        require(borrowOpen, "market not open");
        require(RedCat.balanceOf(msg.sender) - tokenIds.length >= 1, "hold at least one");

        for(uint i = 0; i < tokenIds.length; i++) {
            (uint tokenId, uint buyTime) = RedCat.getBuyTime(tokenIds[i]);
            (, bool ban) = RedCat.getBan(tokenId);

            require(block.timestamp - buyTime >= holdTime, "holding time too short");
            require(RedCat.ownerOf(tokenId) == msg.sender, "RedCat is not yours");
            require(!ban, "RedCat has been banned");

            RedCat.safeTransferFrom(msg.sender, address(this), tokenId);
            jail[address(this)][tokenId] = RedCatOrder(msg.sender, borrowPrice, block.timestamp, 0);

            (bool success, ) = msg.sender.call{value: borrowPrice}("");
            require(success, "failed");

            emit BorrowMoney(msg.sender, borrowPrice, tokenId);
        }
    }

    function redemptionRedCat(uint[] calldata tokenIds) external payable {
        for(uint i = 0; i < tokenIds.length; i++) {
            uint tokenId = tokenIds[i];
            RedCatOrder memory redCatOrder = jail[address(this)][tokenId];
            require(redCatOrder.borrowAddress == msg.sender, "not yours");
            require(!getAbandomTime(tokenId), "has been abandoned");
            require(!getRedemptionTime(tokenId), "has been overRedemption");

            require(msg.value / tokenIds.length >= redCatOrder.borrowMoney, "wrong amount");

            RedCat.safeTransferFrom(address(this), msg.sender, tokenId);
            delete jail[address(this)][tokenId];

            emit RedemptionRedCat(msg.sender, tokenId, redCatOrder.borrowMoney);
        }
    }

    function overRedemptionRedCat(uint tokenId) external payable {
        RedCatOrder memory redCatOrder = jail[address(this)][tokenId];
        require(redCatOrder.borrowAddress == msg.sender, "not yours");
        require(!getAbandomTime(tokenId), "has been abandoned");
        require(getRedemptionTime(tokenId), "not overRedemption");

        uint totalAmount = getTotalAmount(tokenId);
        require(msg.value >= totalAmount, "wrong amount");

        RedCat.safeTransferFrom(address(this), msg.sender, tokenId);
        delete jail[address(this)][tokenId];

        (bool success, ) = msg.sender.call{value: msg.value - totalAmount}("");
        require(success, "failed");

        emit RedemptionRedCat(msg.sender, tokenId, totalAmount);
    }

    function confirmAbandon() external {
        uint256[] memory jailRedCat = RedCat.walletOfOwner(address(this));

        for(uint i = 0; i < jailRedCat.length; i++) {
            uint tokenId = jailRedCat[i];

            if(getAbandomTime(tokenId)) {
                abandon[address(this)][tokenId] = jail[address(this)][tokenId];
                delete jail[address(this)][tokenId];
            }
        }
    }

    function buyRedCat(uint tokenId) external payable nonReentrant {
        require(saleOpen, "market not open");
        uint salePrice = abandon[address(this)][tokenId].salePrice;
        require(salePrice > 0 && msg.value >= salePrice, "Insufficient expenses");

        RedCat.safeTransferFrom(address(this), msg.sender, tokenId);
        delete abandon[address(this)][tokenId];

        emit BuyRedCat(msg.sender, tokenId, msg.value);
    }

    // onlyOwner
    function setBorrowOpen() external onlyOwner {
        borrowOpen = !borrowOpen;
    }

    function setSaleOpen() external onlyOwner {
        saleOpen = !saleOpen;
    }

    function setSalePrice(uint tokenId, uint price) external onlyOwner {
        require(getAbandonTokenOrder(tokenId).borrowAddress != address(0), "not abandon");
        abandon[address(this)][tokenId].salePrice = price;
    }

    function setBorrowPrice(uint _borrowPrice) external onlyOwner {
        borrowPrice = _borrowPrice;
    }

    function setMintPrice(uint _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }

    function setHoldTime(uint _holdTime) external onlyOwner {
        holdTime = _holdTime;
    }

    function setRedemptionTime(uint _redemptionTime) external onlyOwner {
        redemptionTime = _redemptionTime;
    }

    function setAbandonTime(uint _abandonTime) external onlyOwner {
        abandonTime = _abandonTime;
    }

    function withdrawERC20(address _address, uint _amount) external onlyOwner {
        (bool success, ) = _address.call(abi.encodeWithSignature("transfer(address,uint256)", msg.sender, _amount));
        require(success, "failed");
    }

    function withdraw() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "failed");
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getRedemptionTime(uint tokenId) public view returns (bool) {
        return block.timestamp - jail[address(this)][tokenId].borrowTime >= redemptionTime;
    }

    function getAbandomTime(uint tokenId) public view returns (bool) {
        return block.timestamp - jail[address(this)][tokenId].borrowTime >= abandonTime;
    }

    function getJailTokenOrder(uint tokenId) public view returns (RedCatOrder memory) {
        return jail[address(this)][tokenId];
    }

    function getAbandonTokenOrder(uint tokenId) public view returns (RedCatOrder memory) {
        return abandon[address(this)][tokenId];
    }

    function getTotalAmount(uint tokenId) public view returns (uint totalAmount) {
        require(RedCat.ownerOf(tokenId) == address(this), "not yours");
        RedCatOrder memory redCatOrder = getJailTokenOrder(tokenId);
        totalAmount = (mintPrice - redCatOrder.borrowMoney) / (abandonTime - redemptionTime) * (block.timestamp - (redCatOrder.borrowTime + redemptionTime)) + redCatOrder.borrowMoney;
    }

    function onERC721Received(address, address, uint, bytes calldata) external pure returns (bytes4) {
        return IERC721TokenReceiver.onERC721Received.selector;
    }

}
