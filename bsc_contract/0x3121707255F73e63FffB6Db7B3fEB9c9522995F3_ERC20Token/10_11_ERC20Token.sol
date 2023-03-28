//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract ERC20Token is ERC20, Ownable {
    string private _name;
    string private _symbol;

    address public uniswapV2Pair;
    address public tokenUSDT;
    address public feeBuyPayee = 0xfC8FF8E09da5E5C89dD2291cA84ef6ff023777dC;
    address public feeSellPayee;
    address public feeTransferPayee;
    address public feePtotectPayee;
    bool public isFeeGlobal = true;
    uint256 public feeBuyPercent = 5;
    uint256 public feeSellPercent = 5;
    uint256 public feeSellPrizePercent = 1;
    uint256 public feeTransferPercent = 5;
    uint256 public feeProtectPercent = 0;
    uint256 public forceHold = 1;
    uint256 public dateLatest;
    uint256 public priceYesterday;
    uint256 public priceLatest;
    uint256 public priceMax;
    mapping(uint256 => uint256) public feeProMap;
    mapping(address => bool) public noFeeMap;
    mapping(address => bool) public mintMap;
    uint256 public prizeBox = 0;
    mapping(address => bool) public blackMap;
    mapping(address => bool) public regMap;
    mapping(uint256 => address) public regMapId;
    uint256 public regCount = 0;

    function lpPrize(

    ) public onlyOwner () {
        uint256 all = 0;
        uint256[] memory arr = new uint256[](regCount);
        IERC20 lp = IERC20(uniswapV2Pair);

        for (uint256 i = 0;i < regCount;i ++) {
            uint256 balance = lp.balanceOf(regMapId[i]);
            all += balance;
            arr[i] = balance;
        }

        for (uint256 i = 0;i < regCount;i ++) {
            uint256 prize = arr[i] * prizeBox / all;

            if (prize > 0 && !noFeeMap[regMapId[i]]) 
                super._transfer(address(this), regMapId[i], prize);
        }
    }

    function _feeSell(
        address from,
        uint256 amount,
        uint256 amountBase
    ) private returns (uint256) {
        uint256 fee = feeProtectPercent + feeSellPercent;

        uint256 feeSell = (amountBase * fee * 80) / 10000;
        if (feeSellPayee == address(0x0)) super._burn(from, feeSell);
        else super._transfer(from, feeSellPayee, feeSell);

        uint256 prizeSell = (amountBase * fee * 20) / 10000;
        prizeBox += prizeSell;

        super._transfer(from, address(this), prizeSell);

        return amount - feeSell - prizeSell;
    }

    function _feeBuy(
        address from,
        uint256 amount,
        uint256 amountBase
    ) private returns (uint256) {
        uint256 feeBuy = (amountBase * feeBuyPercent) / 100;
        if (feeBuyPayee == address(0x0)) super._burn(from, feeBuy);
        else super._transfer(from, feeBuyPayee, feeBuy);
        return amount - feeBuy;
    }

    function _feeTransfer(
        address from,
        uint256 amount,
        uint256 amountBase
    ) private returns (uint256) {
        uint256 feeTransfer = (amountBase * feeTransferPercent) / 100;
        if (feeTransferPayee == address(0x0)) super._burn(from, feeTransfer);
        else super._transfer(from, feeTransferPayee, feeTransfer);

        return amount - feeTransfer;
    }

    function _feeProtect(
        address from,
        uint256 amount,
        uint256 amountBase
    ) private returns (uint256) {
        uint256 feeProtect = (amountBase * feeProtectPercent * 80) / 100;
        if (feePtotectPayee == address(0x0)) super._burn(from, feeProtect);
        else super._transfer(from, feePtotectPayee, feeProtect);
        
        uint256 prizeProtect = (amountBase * feeProtectPercent * 20) / 10000;
        prizeBox += prizeProtect;

        return amount - feeProtect - prizeProtect;
    }

    function _holdForce(uint256 amount, uint256 amountBase)
        private
        view
        returns (uint256)
    {
        uint256 amountHold = (amountBase * forceHold) / 10000;
        return amount - amountHold;
    }

    function _priceProtect() private {
        uint256 dateNow = block.timestamp / 86400;
        if (dateNow > dateLatest) {
            priceYesterday = priceMax;
            feeProtectPercent = 0;
            dateLatest = dateNow;
            priceMax = 0;
        }

        priceLatest = getPirce();

        if (priceLatest > priceMax) {
            priceMax = priceLatest;
        }

        if ((priceYesterday * 95) / 100 <= priceLatest) {
            feeProtectPercent = 0;
        } else if (
            (priceYesterday * 90) / 100 <= priceLatest &&
            priceLatest < (priceYesterday * 95) / 100
        ) {
            feeProtectPercent = feeProMap[0];
        } else if (
            (priceYesterday * 85) / 100 <= priceLatest &&
            priceLatest < (priceYesterday * 90) / 100
        ) {
            feeProtectPercent = feeProMap[1];
        } else if (priceLatest < (priceYesterday * 85) / 100) {
            feeProtectPercent = feeProMap[2];
        }
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(!blackMap[from], "black address can't transfer");
        require(!blackMap[to], "black address can't transfer");

        if (to == address(0x0)) return super._burn(from, amount);

        if (!regMap[from]) {
            regMap[from] = true;
            regMapId[regCount] = from;
            regCount += 1;
        }

        if (!regMap[to]) {
            regMap[to] = true;
            regMapId[regCount] = to;
            regCount += 1;
        }

        uint256 amountBase = amount;
        if (isFeeGlobal) {
            if (from != uniswapV2Pair && to != uniswapV2Pair) {
                if (!noFeeMap[from])
                    amount = _feeTransfer(from, amount, amountBase);
            } else {
                _priceProtect();
                if (to == uniswapV2Pair) {
                    if (!noFeeMap[from])
                        amount = _feeSell(from, amount, amountBase);
                    // if (!noFeeMap[from] && feeProtectPercent > 0)
                    //     amount = _feeProtect(from, amount, amountBase);
                    if (forceHold > 0) {
                        amount = _holdForce(amount, amountBase);
                    }
                } else if (from == uniswapV2Pair) {
                    if (!noFeeMap[to])
                        amount = _feeBuy(from, amount, amountBase);
                }
            }
        }
        return super._transfer(from, to, amount);
    }

    constructor() ERC20("SBTDAO", "SBTDAO") {
        noFeeMap[msg.sender] = true;
        mintMap[msg.sender] = true;
        feeBuyPayee = msg.sender;
        tokenUSDT = 0x55d398326f99059fF775485246999027B3197955;

        feeProMap[0] = 10;
        feeProMap[1] = 20;
        feeProMap[2] = 25;

        mint(msg.sender, uint256(100000000000000000000000000));
    }

    function setForceHold(uint256 _forceHold) public onlyOwner {
        forceHold = _forceHold;
    }

    function setDateLatest(uint256 _dateLatest) public onlyOwner {
        dateLatest = _dateLatest;
    }

    function setPriceYesterday(uint256 _priceYesterday) public onlyOwner {
        priceYesterday = _priceYesterday;
    }

    function setPriceMax(uint256 _priceMax) public onlyOwner {
        priceMax = _priceMax;
    }

    function setFeeProtectPercent(uint256 _feeProtectPercent) public onlyOwner {
        feeProtectPercent = _feeProtectPercent;
    }

    function setTokenUSDT(address _tokenUSDT) public onlyOwner {
        tokenUSDT = _tokenUSDT;
    }

    function setName(string calldata name) public onlyOwner {
        _name = name;
    }

    function setSymbol(string calldata symbol) public onlyOwner {
        _symbol = symbol;
    }

    function setFeeTransferPayee(address _feeTransferPayee) public onlyOwner {
        feeTransferPayee = _feeTransferPayee;
    }

    function setFeeSellPayee(address _feeSellPayee) public onlyOwner {
        feeSellPayee = _feeSellPayee;
    }

    function setFeeBuyPayee(address _feeBuyPayee) public onlyOwner {
        feeBuyPayee = _feeBuyPayee;
    }

    function setFeeProtectPayee(address _feeProtectPayee) public onlyOwner {
        feePtotectPayee = _feeProtectPayee;
    }

    function setNoFeeMap(address _noFeeMapPayee) public onlyOwner {
        noFeeMap[_noFeeMapPayee] = true;
    }

    function removeNoFeeMap(address _noFeeMapPayee) public onlyOwner {
        noFeeMap[_noFeeMapPayee] = false;
    }

    function setBlackMap(address _blackMapPayee) public onlyOwner {
        blackMap[_blackMapPayee] = true;
    }

    function removeBlackMap(address _blackMapPayee) public onlyOwner {
        blackMap[_blackMapPayee] = false;
    }


    function setTimesProtectMapItem(
        uint256 _timesProtectIndex,
        uint256 _feeProtectPercent
    ) public onlyOwner {
        feeProMap[_timesProtectIndex] = _feeProtectPercent;
    }

    function setFeeGlobal(bool _isFeeGlobal) public onlyOwner {
        isFeeGlobal = _isFeeGlobal;
    }

    function setFeeBuyPercent(uint256 _feeBuyPercent) public onlyOwner {
        feeBuyPercent = _feeBuyPercent;
    }

    function setFeeSellPercent(uint256 _feeSellPercent) public onlyOwner {
        feeSellPercent = _feeSellPercent;
    }

    function setFeeSellPrizePercent(uint256 _feeSellPrizePercent) public onlyOwner {
        feeSellPrizePercent = _feeSellPrizePercent;
    }

    function setFeeTransferPercent(uint256 _feeTransferPercent)
        public
        onlyOwner
    {
        feeTransferPercent = _feeTransferPercent;
    }

    function setUniswapV2Pair(address _uniswapV2Pair) public onlyOwner {
        uniswapV2Pair = _uniswapV2Pair;
    }

    function setMintMap(address _address, bool _isMint) public onlyOwner {
        mintMap[_address] = _isMint;
    }

    function mint(address _to, uint256 _amount) public {
        require(mintMap[msg.sender], "Only minter can mint");
        _mint(_to, _amount);
    }

    function getPirce() public view returns (uint256) {
        IERC20 usdt = IERC20(tokenUSDT);
        uint256 lpUSDT = usdt.balanceOf(uniswapV2Pair);
        uint256 lpTHIS = super.balanceOf(uniswapV2Pair);
        return ((lpUSDT + 1) * 10**super.decimals()) / (lpTHIS + 1);
    }

    function getBalanceOfUSDT() public view returns (uint256) {
        IERC20 usdt = IERC20(tokenUSDT);
        return usdt.balanceOf(uniswapV2Pair);
    }

    function getBalanceOfTHIS() public view returns (uint256) {
        return super.balanceOf(uniswapV2Pair);
    }

    function getDateNow() public view returns (uint256) {
        return block.timestamp / 86400;
    }

    function getPrizeBox() public view returns (uint256) {
        return prizeBox;
    }

    function getfeeProtectPercent() public view returns (uint256) {
        return feeProtectPercent;
    }

    function getFeeProtectPercent() public view returns (uint256) {
        return feeProtectPercent;
    }

    function getPriceYesterday() public view returns (uint256) {
        return priceYesterday;
    }
    
    function getPriceMax() public view returns (uint256) {
        return priceMax;
    }

    function getDateLatest() public view returns (uint256) {
        return dateLatest;
    }
}