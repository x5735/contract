/**
 *Submitted for verification at BscScan.com on 2023-03-25
*/

//FilterSwap (V1): filterswap.exchange

pragma solidity ^0.8;

interface IERC20 {
    function transfer(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    function approve(address, uint) external returns (bool);
}

interface IFilterRouter {
    function addLiquidityETH(address, uint, uint, uint, address, uint, uint) external payable returns (uint, uint, uint);
}

contract SieveLauncher {
    uint public presaleStatus;
    address public owner;

    mapping(address => uint) public userTokensBought;
    mapping(address => bool) public hasClaimedAirdrop;

    uint public totalTokensBought;
    uint public totalAirdropClaims;
    uint public lastAirdropClaimTime;

    // **** PRESALE CONFIG ****

    address public routerAddress = 0x149970278c5506D7443A42fdcf5eaB1Cf3b46C8D;
    address public sieveToken = 0xbA7bd6307a2d6D485cf0B5E639640130232Af2f7;

    uint public softCap = 100 ether;
    uint public hardCap = 400 ether;

    uint public totalTokens = 1000000 ether;

    uint public tokensForLiquidity = 300000 ether;
    uint public tokensForBuyers = 600000 ether;
    uint public tokensForOwners = 50000 ether;
    uint public tokensForAirdrop = 50000 ether;

    uint public tokenBuyLimit = 30000 ether;
    uint public maxAirdropClaims = 5000;
    uint public airdropClaimTimeDelay = 60;

    uint public tokensPerBNB = tokensForBuyers / hardCap;
    bool public hardcapReached = false;

    // **** END OF CONFIG ****

    constructor() {
        owner = msg.sender;
    }

    // **** OWNER ONLY FUNCTIONS ****

    function startPresale() external {     
        require(msg.sender == owner, "SieveLauncher: OWNER_ONLY");
        require(presaleStatus == 0, "SieveLauncher: ALREADY_STARTED");

        IERC20(sieveToken).transferFrom(msg.sender, address(this), totalTokens);
        presaleStatus = 1;
    }

    function finalizePresale() public {
        require(msg.sender == owner || address(this).balance == hardCap, "SieveLauncher: ONLY_OWNER_OR_CONTRACT");
        require(address(this).balance >= softCap, "SieveLauncher: CANNOT_FINALIZE");
        
        presaleStatus = 2;
        IERC20(sieveToken).approve(routerAddress, type(uint).max);

        IERC20(sieveToken).transfer(owner, tokensForOwners);

        if (hardcapReached) {
            IFilterRouter(routerAddress).addLiquidityETH{value: address(this).balance}(
                sieveToken,
                tokensForLiquidity,
                0,
                0,
                address(0),
                block.timestamp,
                type(uint128).max
            );
        } 
        
        else {
            IFilterRouter(routerAddress).addLiquidityETH{value: address(this).balance}(
                sieveToken,
                tokensForLiquidity + tokensForBuyers - totalTokensBought,
                0,
                0,
                address(0),
                block.timestamp,
                type(uint128).max
            );
        }
    }

    // **** USER FUNCTIONS ****

    function buyTokens() public payable {
        require(presaleStatus == 1, "SieveLauncher: CANNOT_BUY");

        uint tokensBought = (tokensPerBNB * msg.value) / 1 ether;  

        uint amountToSpend = 0;
        uint refundAmount = 0;

        if (address(this).balance >= hardCap) {
            hardcapReached = true;

            amountToSpend = hardCap - (address(this).balance - msg.value);
            refundAmount = address(this).balance - hardCap;
            tokensBought = (tokensPerBNB * amountToSpend) / 1 ether;
        }
        
        else {
            amountToSpend = msg.value;
        }

        userTokensBought[msg.sender] += tokensBought;
        totalTokensBought += tokensBought;

        require(userTokensBought[msg.sender] <= tokenBuyLimit, "SieveLauncher: BUY_AMOUNT_TOO_LARGE");

        if (refundAmount > 0) {
            payable(msg.sender).transfer(refundAmount);
            finalizePresale();
        }
    }

    function claimTokens() external {
        require(presaleStatus == 2, "SieveLauncher: PRESALE_NOT_ENDED");

        IERC20(sieveToken).transfer(msg.sender, userTokensBought[msg.sender] * 1 ether);
        userTokensBought[msg.sender] = 0;
    }

    function claimAirdrop() external {
        require(block.timestamp >= lastAirdropClaimTime + airdropClaimTimeDelay, "SieveLauncher: CLAIM_TOO_SOON");
        require(presaleStatus == 2, "SieveLauncher: CANNOT_CLAIM_YET");
        require(totalAirdropClaims < maxAirdropClaims, "SieveLauncher: NO_MORE_AIRDROPS");
        require(!hasClaimedAirdrop[msg.sender], "SieveLauncher: ALREADY_CLAIMED");

        lastAirdropClaimTime = block.timestamp;

        IERC20(sieveToken).transfer(msg.sender, tokensForAirdrop / maxAirdropClaims);

        hasClaimedAirdrop[msg.sender] = true;
        totalAirdropClaims++;

        if (totalAirdropClaims == maxAirdropClaims) presaleStatus = 3;
    }

    // **** MISC ****

    function getCurrentTimestamp() external view returns (uint) {
        return block.timestamp;
    }

    receive() external payable {
        buyTokens();
    }
}