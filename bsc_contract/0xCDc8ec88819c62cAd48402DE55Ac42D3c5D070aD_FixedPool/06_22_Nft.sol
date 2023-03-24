// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Nft is ERC721, ERC721Enumerable, ERC721Burnable, AccessControl {
    using Counters for Counters.Counter;
    using Strings for uint256;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADE_ROLE = keccak256("UPGRADE_ROLE");

    Counters.Counter private _tokenIdCounter;

    string public baseURI;

    struct NftInfo {
        uint256 kind;
        uint256 lvl;
    }

    mapping(uint256 => uint256) public rarities; // kind => rarity

    mapping(uint256 => NftInfo) private nftInfo;

    mapping(bytes32 => uint256) public aprs; // hash => apr

    event KindRarityUpdatedEvent(uint256 indexed _kind, uint256 _prevRarity, uint256 _newRarity);

    event NftLvlUpgradedEvent(uint256 indexed _tokenId, uint256 _prevLvl, uint256 _newLvl);

    event BaseURIUpdatedEvent(string _oldBaseURI, string _baseURI);

    event AprUpdated(bytes32 indexed _hash, uint256 _apr);

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(UPGRADE_ROLE, msg.sender);

        updateKindRarity(1, 1);
        updateKindRarity(2, 2);
        updateKindRarity(3, 3);
    }

    function isAprable() external pure returns (bool) {
        return true;
    }

    function nftInfoOf(uint256 _tokenId) external view returns (bool exists, bool isBurned, address owner, uint256 kind, uint256 rarity, uint256 lvl, bytes32 hash, uint256 apr) {
        NftInfo memory nft = nftInfo[_tokenId];

        exists = _exists(_tokenId);
        isBurned = !_exists(_tokenId) && nft.kind > 0;
        owner = _ownerOf(_tokenId);

        kind = nft.kind;
        rarity = rarities[nft.kind];
        lvl = nft.lvl;

        hash = nftHashOf(_tokenId);

        apr = aprs[hash];
    }

    function nftHashOf(uint256 _tokenId) public view returns (bytes32 hash) {
        NftInfo memory nft = nftInfo[_tokenId];

        return keccak256(abi.encodePacked(rarities[nft.kind], nft.lvl));
    }

    function getAprByTokenId(uint256 _tokenId) external view returns (uint256) {
        bytes32 hash = nftHashOf(_tokenId);
        return aprs[hash];
    }

    function getApr(uint256 _rarity, uint256 _lvl) external view returns (uint256) {
        bytes32 hash = keccak256(abi.encodePacked(_rarity, _lvl));
        return aprs[hash];
    }

    function setApr(uint256 _rarity, uint256 _lvl, uint256 _apr) external onlyRole(DEFAULT_ADMIN_ROLE) {
        bytes32 hash = keccak256(abi.encodePacked(_rarity, _lvl));
        aprs[hash] = _apr;

        emit AprUpdated(hash, _apr);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        _requireMinted(_tokenId);

        if (bytes(baseURI).length > 0) {
            return string(
                abi.encodePacked(
                    baseURI,
                    _tokenId.toString(),
                    ".json"
                )
            );
        }
        return "";
    }

    function safeMint(address _to, uint256 _kind, uint256 _lvl) public onlyRole(MINTER_ROLE) {
        require(rarities[_kind] >= 1, "kind is not valid");
        require(_lvl >= 1, "lvl is not valid");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(_to, tokenId);

        nftInfo[tokenId].kind = _kind;
        nftInfo[tokenId].lvl = _lvl;
    }

    function updateKindRarity(uint256 _kind, uint256 _rarity) public onlyRole(UPGRADE_ROLE) {
        require(_rarity >= 1, "rarity is not valid");

        uint256 _oldRarity = rarities[_kind];

        rarities[_kind] = _rarity;

        emit KindRarityUpdatedEvent(_kind, _oldRarity, _rarity);
    }

    function upgradeLvl(uint256 _tokenId, uint256 _lvl) external onlyRole(UPGRADE_ROLE) {
        _requireMinted(_tokenId);
        require(_lvl >= 1, "lvl is not valid");

        uint256 _oldLvl = nftInfo[_tokenId].lvl;

        nftInfo[_tokenId].lvl = _lvl;

        emit NftLvlUpgradedEvent(_tokenId, _oldLvl, _lvl);
    }

    function setBaseURI(string memory _baseURI) external onlyRole(DEFAULT_ADMIN_ROLE) {
        string memory oldBaseURI = baseURI;

        baseURI = _baseURI;

        emit BaseURIUpdatedEvent(oldBaseURI, _baseURI);
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId, uint256 _batchSize) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(_from, _to, _tokenId, _batchSize);
    }

    function supportsInterface(bytes4 _interfaceId) public view override(ERC721, ERC721Enumerable, AccessControl) returns (bool) {
        return super.supportsInterface(_interfaceId);
    }
}