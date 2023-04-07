// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.17;

contract Charging {
  struct Coin {
    address addr;
    address genesisWallet;
    bool active;
  }

  address private owner;
  mapping(string => Coin) private stableCoins;

  event OwnerSet(address indexed oldOwner, address indexed newOwner);
  event Deposit(string tokenName, uint amount, address to, string data);

  modifier isOwner() {
    require(msg.sender == owner, "Caller is not owner");
    _;
  }

  constructor() {
    owner = msg.sender;
    stableCoins["BUSD"] = Coin(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56, msg.sender, true);
    stableCoins["USDT"] = Coin(0x55d398326f99059fF775485246999027B3197955, msg.sender, true);
    stableCoins["USDC"] = Coin(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d, msg.sender, true);
  }

  function changeOwner(address newOwner) public isOwner {
    emit OwnerSet(owner, newOwner);
    owner = newOwner;
  }

  function checkStableCoin(string memory tokenName) public view returns (address, address, bool) {
    return (stableCoins[tokenName].addr, stableCoins[tokenName].genesisWallet, stableCoins[tokenName].active);
  }

  function updateStableCoin(string memory tokenName, address addr, address genesisWallet, bool active) public isOwner {
    stableCoins[tokenName] = Coin(addr, genesisWallet, active);
  }

  function changeGenesisWallet(string memory tokenName, address genesisWallet) public isOwner {
    _validateTokenName(tokenName);
    Coin memory coin = stableCoins[tokenName];
    coin.genesisWallet = genesisWallet;
    stableCoins[tokenName] = coin;
  }

  function deposit(string memory tokenName, uint amount, string memory data) public {
    _validateTokenName(tokenName);
    require(amount > 0, "Amount is greater than 0");
    address _contract = stableCoins[tokenName].addr;
    address genesisWallet = stableCoins[tokenName].genesisWallet;
    (bool allowanceSuccess, bytes memory allowanceResult) = _contract.call(
      abi.encodeWithSignature("allowance(address,address)", msg.sender, genesisWallet)
    );

    require(allowanceSuccess, "Fail to check allowance coin");
    (uint256 allowance) = abi.decode(allowanceResult, (uint256));
    require(amount < allowance, "Amount BUSD is greater than allowance");

    (bool transferFromSuccess,) = _contract.call(
      abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, genesisWallet, amount)
    );
    require(transferFromSuccess, "Fail to transfer coin");

    emit Deposit(tokenName, amount, genesisWallet, data);
  }

  function _validateTokenName(string memory tokenName) private view {
    require(stableCoins[tokenName].active, "Not support token");
  }

}