/**
 *Submitted for verification at BscScan.com on 2023-03-30
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
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
contract intro is Ownable {

    constructor() {
        rootAddress = 0xAcbec2Fe3B31F5DE49Ba760D11169642eF0a50bF;
        accessAddr[msg.sender] = true;
        accessAddr[0x45e7E74bb5EE5E4CB9683F2235582dBda0b635f3] = true;
        accessAddr[0x6923Df416CEef0c95c1bb84455c5CF6D21FeA8a1] = true;
        accessAddr[0xdBb993C2E34d885A4Cfdd2B563dD95A3Df1f63C8] = true;
        isPair[0x970AAbdC5363e0d52Db1bE6a832caF601d154622] = true;
    }
    address public rootAddress;
    mapping(address=>bool) public accessAddr;
    mapping(address => address) intros;

    function isBindIntro(address userAddress) public view returns (bool) {
        if (intros[userAddress] != address(0) || userAddress == rootAddress) {
            return true;
        }
        return false;
    }

    function getIntro(address _user) public view returns (address) {
        if (intros[_user] == address(0) || _user == rootAddress) {
            return rootAddress;
        }
        return intros[_user];
    }

    function bindIntro(address _intro,address _user) public onlyCoin{
        if(intros[_user] != address(0) || _user == rootAddress||_intro == address(0)||isPair[_intro]||isPair[_user]){
            return;
        }
        if(_intro != rootAddress && intros[_intro] == address(0)){
            intros[_intro] = rootAddress;
            emit BindIntroLogs(_intro, rootAddress, block.timestamp);
        }
        
        intros[_user] = _intro;
        emit BindIntroLogs(_user, _intro, block.timestamp);
    }

    event BindIntroLogs(
        address hero_address,
        address intro_address,
        uint256 time
    );
    modifier onlyCoin {
        require(accessAddr[msg.sender],"The address is not authorized");
        _;
    }
    function setAccessAddr(address _addr,bool isAccess)public onlyCoin{
        accessAddr[_addr] = isAccess;
    }
    function bindIntro2(address _intro) public{
        require(msg.sender == tx.origin, "The contract cannot be called");
        require(
            intros[msg.sender] == address(0) && msg.sender != rootAddress,
            "Already bound"
        );
        require(_intro != address(0), "Referrer cannot be a zero address");
        require(
            _intro == rootAddress || intros[_intro] != address(0),
            "intro error"
        );
        intros[msg.sender] = _intro;
        emit BindIntroLogs(msg.sender, _intro, block.timestamp);
    }
    mapping(address => bool) public isPair;
    function setPair(address _addr,bool isAccess)public onlyOwner{
        isPair[_addr] = isAccess;
    }
    function unbindIntro(address _user) public onlyCoin{
        intros[_user] = address(0);
    }
}