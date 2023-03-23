/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

pragma solidity 0.5.17;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);


}

library SafeERC20 {
    using SafeMath for uint;

    function safeTransfer(IERC20 token, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(isContract(address(token)), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }

    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}

contract BEP20 {
 /*==============================
    =            EVENTS            =
    ==============================*/
    
    event onTokenPurchase(
        address indexed customerAddress,
        uint256 incomingBnb,
        uint256 tokensMinted,
        address indexed referredBy
    );
    
    event onTokenSell(
        address indexed customerAddress,
        uint256 tokensBurned,
        uint256 BnbEarned
    );
    
    event onReinvestment(
        address indexed customerAddress,
        uint256 BnbReinvested,
        uint256 tokensMinted
    );
    
    event onWithdraw(
        address indexed customerAddress,
        uint256 BnbWithdrawn
    );
    
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 tokens
    );
	event Approval(
        address indexed owner, 
        address indexed spender,
        uint value
	);

    event Newbie(
        address user
    );
   
   
	function totalSupply() public view returns (uint256);
	function allowance(address owner, address spender)public view returns (uint);
    function transferFrom(address from, address to, uint value)public returns (bool ok);
    function approve(address spender, uint value)public returns (bool ok);
    function transfer(address to, uint value)public returns (bool ok);
    
}


contract TripFoundation is BEP20 {
	using SafeMath for uint256;
	using SafeERC20 for IERC20;
    
    IERC20 public token;

	string public name                          = "TripFoundation";
    string public symbol                        = "TRIP";
    uint8 constant public decimals              = 18;
	uint256 constant public INVEST_MIN_AMOUNT 	= 100e18; // 100BUSD 
	uint256[] public REFERRAL_PERCENTS 			= [500,400,300,200,100];
	uint256[] public UNILEVEL_PERCENTS 			= [1000, 800, 600, 400, 300, 300, 300, 300, 300, 300, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200,400,500,600,700,800];
	uint256[] public ranking 				    = [25, 60, 100, 225, 500, 1000, 2000, 7500, 12500, 30000, 75000, 150000];
	uint256[] public target 					= [3350, 8350, 16650, 41650, 83350, 166670, 333350, 833350, 1666670, 4166670, 8333330, 16666670];
    uint256 constant public Project_FEE 		= 1000;
    uint256 constant public Development_FEE 	= 1000;
    uint256 constant public Trip_FEE 			= 1000;
    uint256 constant public Marketing_FEE 		= 1000;
    uint256 constant public Pancakeswap_FEE 	= 2000;
    uint256 constant public Remaining           = 4000;
	uint256 constant public PERCENT_STEP 		= 10;
	uint256 constant public PERCENTS_DIVIDER 	= 10000;
	uint256 constant public PLANPER_DIVIDER 	= 10000;
	uint256 constant public TIME_STEP 			= 1 days;

    uint256 constant public Admin_FEE 	        = 2000;
    uint256 constant public burn_FEE 	        = 1000;
	
	
    uint256 constant internal tokenPriceInitial_            = 100 finney; 
    uint256 constant internal tokenPriceIncremental_        = 0.0001 finney;
    uint256 constant internal tokenPriceDecremental_        = 0.000099 finney;

    uint256 internal tokenSupply_                           = 0;

	uint256 public totalInvested;
	uint256 public totalRefBonus;
	
	uint256 public _initialsupply       = 450000000 * 10 ** 18;        // Initial supply 450 Million 90%
	 
    uint256 public developmentsupply  	= 50000000 * 10 ** 18; // 50 M --10%
	
	address chkLv2;
    address chkLv3;
    address chkLv4;
    address chkLv5;
    address chkLv6;
    address chkLv7;
    address chkLv8;
    address chkLv9;
    address chkLv10;
	
	address chkLv11;
	address chkLv12;
    address chkLv13;
    address chkLv14;
    address chkLv15;
	address chkLv16;
	address chkLv17;
    address chkLv18;
    address chkLv19;
    address chkLv20;
   
	address chkLv21;
	address chkLv22;
    address chkLv23;
    address chkLv24;
    address chkLv25;
	address chkLv26;
	address chkLv27;
    address chkLv28;
    address chkLv29;
    address chkLv30;
	
    
    struct RefUserDetail {
        address refUserAddress;
        uint256 refLevel;
    }

    mapping(address => mapping (uint => RefUserDetail)) public RefUser;
    mapping(address => uint256) public referralCount_;
	
	mapping(address => uint256) internal tokenBalanceLedger_;
    mapping(address => uint256) internal stakeBalanceLedger_;
	mapping(address => uint256) internal stakingTime_;
    mapping(address => uint256) internal capitaBalanceLedger_;
    mapping(address => uint256) internal payouts_;
    mapping(address => uint256) internal payoutsTo_;
    
	mapping(address => mapping(address => uint)) allowed;
    
	mapping(address => address) internal referralLevel1Address;
    mapping(address => address) internal referralLevel2Address;
    mapping(address => address) internal referralLevel3Address;
    mapping(address => address) internal referralLevel4Address;
    mapping(address => address) internal referralLevel5Address;
    mapping(address => address) internal referralLevel6Address;
    mapping(address => address) internal referralLevel7Address;
    mapping(address => address) internal referralLevel8Address;
    mapping(address => address) internal referralLevel9Address;
    mapping(address => address) internal referralLevel10Address;
	
	mapping(address => address) internal referralLevel11Address;
    mapping(address => address) internal referralLevel12Address;
    mapping(address => address) internal referralLevel13Address;
    mapping(address => address) internal referralLevel14Address;
    mapping(address => address) internal referralLevel15Address;
	mapping(address => address) internal referralLevel16Address;
    mapping(address => address) internal referralLevel17Address;
    mapping(address => address) internal referralLevel18Address;
    mapping(address => address) internal referralLevel19Address;
    mapping(address => address) internal referralLevel20Address;
	
	mapping(address => address) internal referralLevel21Address;
    mapping(address => address) internal referralLevel22Address;
    mapping(address => address) internal referralLevel23Address;
    mapping(address => address) internal referralLevel24Address;
    mapping(address => address) internal referralLevel25Address;
	mapping(address => address) internal referralLevel26Address;
    mapping(address => address) internal referralLevel27Address;
    mapping(address => address) internal referralLevel28Address;
    mapping(address => address) internal referralLevel29Address;
    mapping(address => address) internal referralLevel30Address;
  
    
	struct Deposit {
        uint256 time;
        uint256 percent;
		uint256 amount;
        uint256 tokenamount;
		uint256 start;
	}

	struct User {
		Deposit[] deposits;
		uint256 checkpoint;
		address referrer;
		uint256[5] levels;
		uint256 bonus;
		uint256 totalBonus;
		uint256 UNILEVELincome;
		uint256 withdrawn;
		uint256 withdrawnUNILEVEL;
		uint256 withdrawnReferral;
		uint256 withdrawnReward;
        uint256 withdrawnCapita;
		uint256 teambusiness;
		uint256[12] levelbusiness;
		uint256 RankingReward;
		bool[12] Reward_achivement; 	
		bool cashoutuser;
       

	}
	
	mapping (address => User) internal users;

	bool public started;
	address payable public pancakeWallet;
    address payable public marketingWallet;
    address payable public tripWallet;
    address payable public developmentWallet;
    address payable public projectWallet;

	event Newbie(address user);
	event NewDeposit(address indexed user, uint256 amount, uint256 tokenamount);
	event Withdrawn(address indexed user, uint256 amount);
	event RefBonus(address indexed referrer, address indexed referral, uint256 indexed level, uint256 amount);
	event UNILEVELIncome(address indexed referrer, address indexed referral, uint256 indexed level, uint256 amount);
	event FeePayed(address indexed user, uint256 totalAmount);

	constructor(address payable pancake, address payable marketing, address payable trip, address payable development, address payable project, address tokenAddr) public {
		require(!isContract(development) && isContract(tokenAddr));
        token = IERC20(tokenAddr);
		
		 pancakeWallet		=	pancake;
		 marketingWallet	=	marketing;
		 tripWallet			=	trip;
		 developmentWallet	=	development;
		 projectWallet		=	project;


		tokenBalanceLedger_[developmentWallet] = SafeMath.add(tokenBalanceLedger_[developmentWallet], developmentsupply);
		emit Transfer(address(this), developmentWallet, developmentsupply);
	
		
		
	}
	
	function () external payable {
        revert();
    }
	
	
	 // Only people with tokens
    modifier onlybelievers () {
        require(myTokens() > 0);
        _;
    }


    /**
     * WITHDRAW
     */
    function withdrawprofit() public {
        
        address _customerAddress            = msg.sender;
		uint256 withdrawamt;

        User storage user = users[msg.sender];
        require(user.cashoutuser == false);

		withdrawamt = payouts_[_customerAddress];

        uint256 contractBal = token.balanceOf(address(this));
		require(contractBal > withdrawamt);

		payoutsTo_[_customerAddress] = payoutsTo_[_customerAddress].add(withdrawamt);

        token.transfer(msg.sender, withdrawamt);
         payouts_[_customerAddress] = 0;

        // fire event
        emit onWithdraw(_customerAddress, withdrawamt);
    }

     /**
     * SELL
     */
    function selltokens(uint256 _amountOfTokens) onlybelievers () public {
        address _customerAddress              = msg.sender;
         User storage user = users[msg.sender];
        require(user.cashoutuser == false);

        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
        uint256 _tokens                     = _amountOfTokens;
        uint256 _Bnb                        = tokensToBnb_(_tokens);
        uint256 _taxedBnb                   = _Bnb;
        
        tokenSupply_                        = SafeMath.sub(tokenSupply_, _tokens);
        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
        
        payouts_[_customerAddress]        += _taxedBnb;       
        
        emit onTokenSell(_customerAddress, _tokens, _taxedBnb);
    }
    
    /**
     * TRANSFER
     */
    function transfer(address _toAddress, uint256 _amountOfTokens) public returns(bool) {
        address _customerAddress            = msg.sender;
        
        require( _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
        
        uint256 _taxedTokens                = _amountOfTokens;
       
        tokenSupply_                        = tokenSupply_;
        
        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
        tokenBalanceLedger_[_toAddress]     = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
       
       
        emit Transfer(_customerAddress, _toAddress, _taxedTokens);
        return true;
    }
  
	
	function getDownlineRef(address senderAddress, uint dataId) public view returns (address,uint) { 
        return (RefUser[senderAddress][dataId].refUserAddress,RefUser[senderAddress][dataId].refLevel);
    }
    
    function addDownlineRef(address senderAddress, address refUserAddress, uint refLevel) internal {
        referralCount_[senderAddress]++;
        uint dataId = referralCount_[senderAddress];
        RefUser[senderAddress][dataId].refUserAddress = refUserAddress;
        RefUser[senderAddress][dataId].refLevel = refLevel;
    }

    
	 function distributeRef(address _referredBy,address _sender, bool _newReferral) internal {
       
          address _customerAddress        = _sender;
        // Level 1
        referralLevel1Address[_customerAddress]                     = _referredBy;
        if(_newReferral == true) {
            addDownlineRef(_referredBy, _customerAddress, 1);
        }
        
        chkLv2                          = referralLevel1Address[_referredBy];
        chkLv3                          = referralLevel2Address[_referredBy];
        chkLv4                          = referralLevel3Address[_referredBy];
        chkLv5                          = referralLevel4Address[_referredBy];
        chkLv6                          = referralLevel5Address[_referredBy];
        chkLv7                          = referralLevel6Address[_referredBy];
        chkLv8                          = referralLevel7Address[_referredBy];
        chkLv9                          = referralLevel8Address[_referredBy];
        chkLv10                         = referralLevel9Address[_referredBy];
		
		chkLv11                          = referralLevel10Address[_referredBy];
	    chkLv12                          = referralLevel11Address[_referredBy];
        chkLv13                          = referralLevel12Address[_referredBy];
        chkLv14                          = referralLevel13Address[_referredBy];
        chkLv15                          = referralLevel14Address[_referredBy];
		chkLv16                          = referralLevel15Address[_referredBy];
	    chkLv17                          = referralLevel16Address[_referredBy];
        chkLv18                          = referralLevel17Address[_referredBy];
        chkLv19                          = referralLevel18Address[_referredBy];
        chkLv20                          = referralLevel19Address[_referredBy];
				
		chkLv21                          = referralLevel20Address[_referredBy];
	    chkLv22                          = referralLevel21Address[_referredBy];
        chkLv23                          = referralLevel22Address[_referredBy];
        chkLv24                          = referralLevel23Address[_referredBy];
        chkLv25                          = referralLevel24Address[_referredBy];
		chkLv26                          = referralLevel25Address[_referredBy];
	    chkLv27                          = referralLevel26Address[_referredBy];
        chkLv28                          = referralLevel27Address[_referredBy];
        chkLv29                          = referralLevel28Address[_referredBy];
        chkLv30                          = referralLevel29Address[_referredBy];
		
       
		
		
        // Level 2
        if(chkLv2 != 0x0000000000000000000000000000000000000000) {
            referralLevel2Address[_customerAddress]                     = referralLevel1Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel1Address[_referredBy], _customerAddress, 2);
            }
        }
        
        // Level 3
        if(chkLv3 != 0x0000000000000000000000000000000000000000) {
            referralLevel3Address[_customerAddress]                     = referralLevel2Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel2Address[_referredBy], _customerAddress, 3);
            }
        }
        
        // Level 4
        if(chkLv4 != 0x0000000000000000000000000000000000000000) {
            referralLevel4Address[_customerAddress]                     = referralLevel3Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel3Address[_referredBy], _customerAddress, 4);
            }
        }
        
        // Level 5
        if(chkLv5 != 0x0000000000000000000000000000000000000000) {
            referralLevel5Address[_customerAddress]                     = referralLevel4Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel4Address[_referredBy], _customerAddress, 5);
            }
        }
        
        // Level 6
        if(chkLv6 != 0x0000000000000000000000000000000000000000) {
            referralLevel6Address[_customerAddress]                     = referralLevel5Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel5Address[_referredBy], _customerAddress, 6);
            }
        }
        
        // Level 7
        if(chkLv7 != 0x0000000000000000000000000000000000000000) {
            referralLevel7Address[_customerAddress]                     = referralLevel6Address[_referredBy];
           if(_newReferral == true) {
                addDownlineRef(referralLevel6Address[_referredBy], _customerAddress, 7);
            }
        }
        
        // Level 8
        if(chkLv8 != 0x0000000000000000000000000000000000000000) {
            referralLevel8Address[_customerAddress]                     = referralLevel7Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel7Address[_referredBy], _customerAddress, 8);
            }
        }
        
        // Level 9
        if(chkLv9 != 0x0000000000000000000000000000000000000000) {
            referralLevel9Address[_customerAddress]                     = referralLevel8Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel8Address[_referredBy], _customerAddress, 9);
            }
        }
        
        // Level 10
        if(chkLv10 != 0x0000000000000000000000000000000000000000) {
            referralLevel10Address[_customerAddress]                    = referralLevel9Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel9Address[_referredBy], _customerAddress, 10);
            }
        }
		
		// Level 11
        if(chkLv11 != 0x0000000000000000000000000000000000000000) {
            referralLevel11Address[_customerAddress]                    = referralLevel10Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel10Address[_referredBy], _customerAddress, 11);
            }
        }
		
		 // Level 12
        if(chkLv12 != 0x0000000000000000000000000000000000000000) {
            referralLevel12Address[_customerAddress]                    = referralLevel11Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel11Address[_referredBy], _customerAddress, 12);
            }
        }
		
		 // Level 13
        if(chkLv13 != 0x0000000000000000000000000000000000000000) {
            referralLevel13Address[_customerAddress]                    = referralLevel12Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel12Address[_referredBy], _customerAddress, 13);
            }
        }
		
		 // Level 14
        if(chkLv14 != 0x0000000000000000000000000000000000000000) {
            referralLevel14Address[_customerAddress]                    = referralLevel13Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel13Address[_referredBy], _customerAddress, 14);
            }
        }
		
		 // Level 15
        if(chkLv15 != 0x0000000000000000000000000000000000000000) {
            referralLevel15Address[_customerAddress]                    = referralLevel14Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel14Address[_referredBy], _customerAddress, 15);
            }
        }
		
				 // Level 16
        if(chkLv16 != 0x0000000000000000000000000000000000000000) {
            referralLevel16Address[_customerAddress]                    = referralLevel15Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel15Address[_referredBy], _customerAddress, 16);
            }
        }
	   
       		 // Level 17
        if(chkLv17 != 0x0000000000000000000000000000000000000000) {
            referralLevel17Address[_customerAddress]                    = referralLevel16Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel16Address[_referredBy], _customerAddress, 17);
            }
        }
		
				 // Level 18
        if(chkLv18 != 0x0000000000000000000000000000000000000000) {
            referralLevel18Address[_customerAddress]                    = referralLevel17Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel17Address[_referredBy], _customerAddress, 18);
            }
        }
		
				 // Level 19
        if(chkLv19 != 0x0000000000000000000000000000000000000000) {
            referralLevel19Address[_customerAddress]                    = referralLevel18Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel18Address[_referredBy], _customerAddress, 19);
            }
        }
		
				 // Level 20
        if(chkLv20 != 0x0000000000000000000000000000000000000000) {
            referralLevel20Address[_customerAddress]                    = referralLevel19Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel19Address[_referredBy], _customerAddress, 20);
            }
        }
		
				 // Level 21
        if(chkLv21 != 0x0000000000000000000000000000000000000000) {
            referralLevel21Address[_customerAddress]                    = referralLevel20Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel20Address[_referredBy], _customerAddress, 21);
            }
        }
		
				 // Level 22
        if(chkLv22 != 0x0000000000000000000000000000000000000000) {
            referralLevel22Address[_customerAddress]                    = referralLevel21Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel21Address[_referredBy], _customerAddress, 22);
            }
        }
		
				 // Level 23
        if(chkLv23 != 0x0000000000000000000000000000000000000000) {
            referralLevel23Address[_customerAddress]                    = referralLevel22Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel22Address[_referredBy], _customerAddress, 23);
            }
        }
		
				 // Level 24
        if(chkLv24 != 0x0000000000000000000000000000000000000000) {
            referralLevel24Address[_customerAddress]                    = referralLevel23Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel23Address[_referredBy], _customerAddress, 24);
            }
        }
		
				 // Level 25
        if(chkLv25 != 0x0000000000000000000000000000000000000000) {
            referralLevel25Address[_customerAddress]                    = referralLevel24Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel24Address[_referredBy], _customerAddress, 25);
            }
        }
		
				 // Level 26
        if(chkLv26 != 0x0000000000000000000000000000000000000000) {
            referralLevel26Address[_customerAddress]                    = referralLevel25Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel25Address[_referredBy], _customerAddress, 26);
            }
        }
		
				 // Level 27
        if(chkLv27 != 0x0000000000000000000000000000000000000000) {
            referralLevel27Address[_customerAddress]                    = referralLevel26Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel26Address[_referredBy], _customerAddress, 27);
            }
        }
		
				 // Level 28
        if(chkLv28 != 0x0000000000000000000000000000000000000000) {
            referralLevel28Address[_customerAddress]                    = referralLevel27Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel27Address[_referredBy], _customerAddress, 28);
            }
        }
		
				 // Level 29
        if(chkLv29 != 0x0000000000000000000000000000000000000000) {
            referralLevel29Address[_customerAddress]                    = referralLevel28Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel28Address[_referredBy], _customerAddress, 29);
            }
        }
		
				 // Level 30
        if(chkLv30 != 0x0000000000000000000000000000000000000000) {
            referralLevel30Address[_customerAddress]                    = referralLevel29Address[_referredBy];
            if(_newReferral == true) {
                addDownlineRef(referralLevel29Address[_referredBy], _customerAddress, 30);
            }
        }
}
	
	
	function invest(uint256 planno, address referrer) public{
		
        
		uint256 value;
        uint256 time;
        uint256 percent;

        if(planno == 1) {
            value = 100*10**18;
            time = 2000;
            percent = 10;
        }
        else if(planno == 2) {
            value = 500*10**18;
            time = 2000;
            percent = 10;
        }
        else if(planno == 3) {
            value = 1000*10**18;
            time = 1334;
            percent = 15;
        }
		else if(planno == 4) {
            value = 5000*10**18;
            time = 1000;
            percent = 20;
        }
		else if(planno == 5) {
            value = 10000*10**18;
            time = 800;
            percent = 25;
        }
        else if(planno == 6) {
            value = 20000*10**18;
            time = 667;
            percent = 30;
        }
        else{

        }


	    require(value <= token.allowance(msg.sender, address(this)));
        
        User storage user = users[msg.sender];
        
         require(user.cashoutuser == false);

		if (!started) {
			if (msg.sender == developmentWallet) {
				started = true;
			} else revert("Not started yet");
		}
		
	
		require(value >= INVEST_MIN_AMOUNT);
		
      
		uint256 projectfee = value.mul(Project_FEE).div(PERCENTS_DIVIDER);
        token.safeTransferFrom(msg.sender, projectWallet, projectfee);
		emit FeePayed(msg.sender, projectfee);
		
		uint256 developmentfee = value.mul(Development_FEE).div(PERCENTS_DIVIDER);
        token.safeTransferFrom(msg.sender, developmentWallet, developmentfee);
		emit FeePayed(msg.sender, developmentfee);
		
		uint256 tripfee = value.mul(Trip_FEE).div(PERCENTS_DIVIDER);
        token.safeTransferFrom(msg.sender, tripWallet, tripfee);
		emit FeePayed(msg.sender, tripfee);
		
		uint256 marketingfee = value.mul(Marketing_FEE).div(PERCENTS_DIVIDER);
        token.safeTransferFrom(msg.sender, marketingWallet, marketingfee);
		emit FeePayed(msg.sender, marketingfee);
		
		uint256 pancakefee = value.mul(Pancakeswap_FEE).div(PERCENTS_DIVIDER);
        token.safeTransferFrom(msg.sender, pancakeWallet, pancakefee);
		emit FeePayed(msg.sender, pancakefee);
		
        uint256 finalvalue = value.mul(Remaining).div(PERCENTS_DIVIDER);

	    uint256 _amountOfTokens             = BnbToTokens_(value);
		require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));

		
       
		
		if (user.referrer == address(0)) {
			if (users[referrer].deposits.length > 0 && referrer != msg.sender) {
				user.referrer = referrer;
			}

			address upline = user.referrer;
			for (uint256 i = 0; i < 5; i++) {
				if (upline != address(0)) {
					users[upline].levels[i] = users[upline].levels[i].add(1);
					upline = users[upline].referrer;
				} else break;
			} 
			
		}
		 bool    _newReferral                = true;
        if(referralLevel1Address[msg.sender] != 0x0000000000000000000000000000000000000000) {
            referrer                     = referralLevel1Address[msg.sender];
            _newReferral                    = false;
        }
		
		distributeRef(referrer, msg.sender, _newReferral);
      
		
		if (user.referrer != address(0)) {
			address upline = user.referrer;
			for (uint256 i = 0; i < 5; i++) {
				if (upline != address(0)) {
					uint256 amount = _amountOfTokens.mul(REFERRAL_PERCENTS[i]).div(PERCENTS_DIVIDER);
					if(stakeBalanceLedger_[upline] > 0){
						users[upline].bonus = users[upline].bonus.add(amount);
						users[upline].totalBonus = users[upline].totalBonus.add(amount);
						emit RefBonus(upline, msg.sender, i, amount);
					}
					upline = users[upline].referrer;
				} else break;
			}
            for (uint256 i = 0; i < 30; i++) {
				if (upline != address(0)) {
                    users[upline].teambusiness = users[upline].teambusiness.add(value);
					upline = users[upline].referrer;

				} else break;
			}
			for (uint256 i = 0; i < 12; i++) {
				if (upline != address(0)) {
                    users[upline].levelbusiness[i] = users[upline].levelbusiness[i].add(value);
					upline = users[upline].referrer;
                    if(stakeBalanceLedger_[upline] > 0){
                        if(users[upline].levelbusiness[i] >= target[i]){
                            if(!users[upline].Reward_achivement[i]){
                                uint256 _rankingtokens 		    = BnbToTokens_(ranking[i]);
                                users[upline].RankingReward 	= _rankingtokens;
                                users[upline].Reward_achivement[i] 	= true;
                            }
                        }
                    }

				} else break;
			}
		}
		
        if(tokenSupply_ > 0){
         tokenSupply_                    = SafeMath.add(tokenSupply_, _amountOfTokens);
        } else {
             tokenSupply_                    = _amountOfTokens;
        }
		
		
		if (user.deposits.length == 0) {
			user.checkpoint = block.timestamp;
			emit Newbie(msg.sender);
		}

       
        
        token.safeTransferFrom(msg.sender, address(this), finalvalue);
		
		user.deposits.push(Deposit(time, percent, value,_amountOfTokens, block.timestamp));
        stakeBalanceLedger_[msg.sender] = SafeMath.add(stakeBalanceLedger_[msg.sender], _amountOfTokens);
        capitaBalanceLedger_[msg.sender] = SafeMath.add(capitaBalanceLedger_[msg.sender], _amountOfTokens);

		totalInvested = totalInvested.add(value);

		emit NewDeposit(msg.sender, value, _amountOfTokens);
		
	}


	function withdrawcapita() public {
        User storage user = users[msg.sender];
        require(user.cashoutuser == false);
		uint256 ttamount = getUserTotaltoken(msg.sender);
		uint256 start = user.deposits[0].start;
		uint256 currenttime = block.timestamp;
        require(capitaBalanceLedger_[msg.sender] != 0);

		if(SafeMath.sub(currenttime,start) >= 157766400 )
		{
			tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], ttamount);
            emit Transfer(address(this), msg.sender, ttamount);
       		capitaBalanceLedger_[msg.sender] = 0;
            user.withdrawnCapita.add(ttamount);
            user.cashoutuser = true;
            stakeBalanceLedger_[msg.sender] = 0;

            for (uint256 i = 0; i < user.deposits.length; i++) {
                user.deposits[i].tokenamount = 0;
                
            }
		}
		else 
		{
			uint256 adminshare = ttamount.mul(Admin_FEE).div(PERCENTS_DIVIDER);
			uint256 burntoken = ttamount.mul(burn_FEE).div(PERCENTS_DIVIDER);
            user.withdrawnCapita.add(ttamount);
			ttamount = ttamount.sub(adminshare.add(burntoken));
			
			tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], ttamount);
            emit Transfer(address(this), msg.sender, ttamount);
			tokenBalanceLedger_[developmentWallet] = SafeMath.add(tokenBalanceLedger_[developmentWallet], adminshare);
            emit Transfer(address(this), developmentWallet, adminshare);
			tokenSupply_ = tokenSupply_.sub(burntoken);
            capitaBalanceLedger_[msg.sender] = 0;
            user.cashoutuser = true;
            stakeBalanceLedger_[msg.sender] = 0;

             for (uint256 i = 0; i < user.deposits.length; i++) {
                user.deposits[i].tokenamount = 0;
                user.cashoutuser = true;
            }
		
        }
			
	}
   
	function withdraw() public {
		User storage user = users[msg.sender];
        require(user.cashoutuser == false);
			uint256 totalAmount 	= getUserDividends(msg.sender);
			uint256 UNILEVELAmount = getcurrentUNILEVELincome(msg.sender);
			uint256 RewardAmount = getUserTotalReward(msg.sender);

			uint256 referralBonus = getUserReferralBonus(msg.sender);

			if (referralBonus > 0) {
				user.bonus = 0;
				totalAmount = totalAmount.add(referralBonus);
			}
			totalAmount = totalAmount.add(UNILEVELAmount);
			totalAmount = totalAmount.add(RewardAmount);

            require(_initialsupply >= totalAmount);			

            tokenSupply_    = SafeMath.add(tokenSupply_, totalAmount);

            _initialsupply  = SafeMath.sub(_initialsupply, totalAmount);

			tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], totalAmount);
       		emit Transfer(address(this), msg.sender, totalAmount);
						
			user.withdrawnUNILEVEL 	= user.withdrawnUNILEVEL.add(UNILEVELAmount);
			user.withdrawnReferral 	= user.withdrawnReferral.add(referralBonus);
			user.withdrawnReward 	= user.withdrawnReward.add(RewardAmount);
			user.RankingReward 	    = 0;
			user.checkpoint 		= block.timestamp;
			user.withdrawn 			= user.withdrawn.add(totalAmount);
			
			emit Withdrawn(msg.sender, totalAmount);
		
	}


	function getContractBalance() public view returns (uint256) {
		return address(this).balance;
	}
		
	
	function getUserDividends(address userAddress) public view returns (uint256) {
		User storage user = users[userAddress];

		uint256 totalAmount;
	
		for (uint256 i = 0; i < user.deposits.length; i++) {
		
			
			uint256 finish = user.deposits[i].start.add(user.deposits[i].time.mul(1 days));
			if (user.checkpoint < finish) {
               	uint256 share = user.deposits[i].tokenamount.mul(user.deposits[i].percent).div(PLANPER_DIVIDER);
				uint256 from = user.deposits[i].start > user.checkpoint ? user.deposits[i].start : user.checkpoint;
				uint256 to = finish < block.timestamp ? finish : block.timestamp;
				if (from < to) {
					totalAmount = totalAmount.add(share.mul(to.sub(from)).div(TIME_STEP));
					
				}
				
			}
		}
		

		return totalAmount;
	}
	
	function getUserUNILEVELIncome(address userAddress) public view returns(uint256) {

	uint256 totalUNILEVELAmount;

	uint256 count = getUserTotalReferrals(userAddress);
    require(stakeBalanceLedger_[userAddress] > 0);

	for (uint256 y = 1; y <= count; y++) {
		uint256 level;
		address addressdownline;

		(addressdownline, level) = getDownlineRef(userAddress, y);

		User storage downline = users[addressdownline];

		if (level == 1) {
			for (uint256 i = 0; i < downline.deposits.length; i++) {
                uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
				if (downline.deposits[i].start < finish) {
					uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
					uint256 from = downline.deposits[i].start;
					uint256 to = finish < block.timestamp ? finish : block.timestamp;
					//UNILEVEL income
					uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

					if (from < to) {

						totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

					}
				}
			}
		}

		if (users[userAddress].levels[0] == 2) {
			if (level == 2) {

				for (uint256 i = 0; i < downline.deposits.length; i++) {
                uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
				if (downline.deposits[i].start < finish) {
					uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
					uint256 from = downline.deposits[i].start;
					uint256 to = finish < block.timestamp ? finish : block.timestamp;
					//UNILEVEL income
					uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

					if (from < to) {

						totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

					}
				}
			}
			}
		}
		if (users[userAddress].levels[0] == 3) {
			if (level >= 2 || level <= 3) {

				for (uint256 i = 0; i < downline.deposits.length; i++) {
                uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
				if (downline.deposits[i].start < finish) {
					uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
					uint256 from = downline.deposits[i].start;
					uint256 to = finish < block.timestamp ? finish : block.timestamp;
					//UNILEVEL income
					uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

					if (from < to) {

						totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

					}
				}
			}
			}
		}
		if (users[userAddress].levels[0] == 4) {
			if (level >= 2 || level <= 4) {
				for (uint256 i = 0; i < downline.deposits.length; i++) {
                uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
				if (downline.deposits[i].start < finish) {
					uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
					uint256 from = downline.deposits[i].start;
					uint256 to = finish < block.timestamp ? finish : block.timestamp;
					//UNILEVEL income
					uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

					if (from < to) {

						totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

					}
				}
			}

			}
		}
		if (users[userAddress].levels[0] == 5) {

			if (users[userAddress].teambusiness >= 25000 * 10 ** 18) {
				if (level >= 2 || level <= 25) {
					for (uint256 i = 0; i < downline.deposits.length; i++) {
                        uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
                        if (downline.deposits[i].start < finish) {
                            uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
                            uint256 from = downline.deposits[i].start;
                            uint256 to = finish < block.timestamp ? finish : block.timestamp;
                            //UNILEVEL income
                            uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

                            if (from < to) {

                                totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

                            }
                        }
                    }

				}
			}

			else if (users[userAddress].teambusiness >= 30000 * 10 ** 18) {
				if (level >= 2 || level <= 26) {
					for (uint256 i = 0; i < downline.deposits.length; i++) {
                    uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
                    if (downline.deposits[i].start < finish) {
                        uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
                        uint256 from = downline.deposits[i].start;
                        uint256 to = finish < block.timestamp ? finish : block.timestamp;
                        //UNILEVEL income
                        uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

                        if (from < to) {

                            totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

                        }
                    }
                }
				}
			}
			else if (users[userAddress].teambusiness >= 50000 * 10 ** 18) {
				if (level >= 2 || level <= 27) {
					for (uint256 i = 0; i < downline.deposits.length; i++) {
                        uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
                        if (downline.deposits[i].start < finish) {
                            uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
                            uint256 from = downline.deposits[i].start;
                            uint256 to = finish < block.timestamp ? finish : block.timestamp;
                            //UNILEVEL income
                            uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

                            if (from < to) {

                                totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

                            }
                        }
                    }
				}
			}
			else if (users[userAddress].teambusiness >= 100000 * 10 ** 18) {
				if (level >= 2 || level <= 28) {
					for (uint256 i = 0; i < downline.deposits.length; i++) {
                        uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
                        if (downline.deposits[i].start < finish) {
                            uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
                            uint256 from = downline.deposits[i].start;
                            uint256 to = finish < block.timestamp ? finish : block.timestamp;
                            //UNILEVEL income
                            uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

                            if (from < to) {

                                totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

                            }
                        }
                    }
				}
			}
			else if (users[userAddress].teambusiness >= 250000 * 10 ** 18) {
				if (level >= 2 || level <= 29) {
                    for (uint256 i = 0; i < downline.deposits.length; i++) {
                        uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
                        if (downline.deposits[i].start < finish) {
                            uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
                            uint256 from = downline.deposits[i].start;
                            uint256 to = finish < block.timestamp ? finish : block.timestamp;
                            //UNILEVEL income
                            uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

                            if (from < to) {

                                totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

                            }
                        }
                    }
				}
			}
			else if (users[userAddress].teambusiness >= 500000 * 10 ** 18) {
				if (level >= 2 || level <= 30) {
                        for (uint256 i = 0; i < downline.deposits.length; i++) {
                        uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
                        if (downline.deposits[i].start < finish) {
                            uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
                            uint256 from = downline.deposits[i].start;
                            uint256 to = finish < block.timestamp ? finish : block.timestamp;
                            //UNILEVEL income
                            uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

                            if (from < to) {

                                totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

                            }
                        }
                    }
				}
			}
		    else {
			if (level >= 2 || level <= 10) {
                    for (uint256 i = 0; i < downline.deposits.length; i++) {
                    uint256 finish = downline.deposits[i].start.add(downline.deposits[i].time.mul(1 days));
                    if (downline.deposits[i].start < finish) {
                        uint256 share = downline.deposits[i].tokenamount.mul(downline.deposits[i].percent).div(PLANPER_DIVIDER);
                        uint256 from = downline.deposits[i].start;
                        uint256 to = finish < block.timestamp ? finish : block.timestamp;
                        //UNILEVEL income
                        uint256 UNILEVELshare = share.mul(UNILEVEL_PERCENTS[level - 1]).div(PERCENTS_DIVIDER);

                        if (from < to) {

                            totalUNILEVELAmount = totalUNILEVELAmount.add(UNILEVELshare.mul(to.sub(from)).div(TIME_STEP));

                        }
                    }
                }
			    }
		    }
        }


	}

return totalUNILEVELAmount;

}
	 /*---------- CALCULATORS  ----------*/

    function totalPayouts(address _customerAddress) view public returns(uint256) {
        return payoutsTo_[_customerAddress];
    }
    
     function totalavailPayouts(address _customerAddress) view public returns(uint256) {
        return payouts_[_customerAddress];
    }
    
    function totalBnbBalance() public view returns(uint) {
        return address(this).balance;
    }
   
       
    function totalSupply() public view returns(uint256) {
        return tokenSupply_+_initialsupply+developmentsupply;
    }
    
    
    function myTokens() public view returns(uint256) {
        address _customerAddress            = msg.sender;
        return stakebalance(_customerAddress);
    }

    function balanceOf(address _customerAddress) view public returns(uint256) {
        return tokenBalanceLedger_[_customerAddress];
    }
    
    function stakebalance(address _customerAddress) public view returns(uint256){
        return stakeBalanceLedger_[_customerAddress];
    }

    function capitabalance(address _customerAddress) public view returns(uint256){
        return capitaBalanceLedger_[_customerAddress];
    }
    
    function getUserCapitaWithdrawn(address userAddress) public view returns (uint256) {
		return users[userAddress].withdrawnCapita;
	}
	
	function getcurrentUNILEVELincome(address userAddress) public view returns (uint256){
	    User storage user = users[userAddress];
	    return (getUserUNILEVELIncome(userAddress).sub(user.withdrawnUNILEVEL));
	    
	}
	
	function getUserAllWithdrawn(address userAddress) public view returns (uint256 unilevel_withdrawn,uint256 referral_withdrawn,uint256 reward_withdrawn ) {
		 unilevel_withdrawn = users[userAddress].withdrawnUNILEVEL;
		 referral_withdrawn = users[userAddress].withdrawnReferral;
		 reward_withdrawn = users[userAddress].withdrawnReward;
	}

	function getUserTotalWithdrawn(address userAddress) public view returns (uint256) {
		return users[userAddress].withdrawn;
	}
	
	function getUserTotalReward(address userAddress) public view returns (uint256) {
		return users[userAddress].RankingReward;
	}

    function getUserRanking(address userAddress) public view returns (bool[12] memory achivement) {
		return users[userAddress].Reward_achivement;
	}
		

	function getUserCheckpoint(address userAddress) public view returns(uint256) {
		return users[userAddress].checkpoint;
	}

	function getUserReferrer(address userAddress) public view returns(address) {
		return users[userAddress].referrer;
	}

	function getUserDownlineCount(address userAddress) public view returns(uint256[5] memory referrals) {
			return (users[userAddress].levels);
	}

	function getUserTotalReferrals(address userAddress) public view returns(uint256) {
				return users[userAddress].levels[0]+users[userAddress].levels[1]+users[userAddress].levels[2]+users[userAddress].levels[3]+users[userAddress].levels[4];
	}

	function getUserReferralBonus(address userAddress) public view returns(uint256) {
		return users[userAddress].bonus;
	}

	function getUserReferralTotalBonus(address userAddress) public view returns(uint256) {
		return users[userAddress].totalBonus;
	}

   
    function getUserteambusiness(address userAddress) public view returns(uint256) {
		return users[userAddress].teambusiness;
	}
	
	
	function getUserReferralWithdrawn(address userAddress) public view returns(uint256) {
		return users[userAddress].totalBonus.sub(users[userAddress].bonus);
	}

	function getUserAvailable(address userAddress) public view returns(uint256) {
		return getUserReferralBonus(userAddress).add(getUserDividends(userAddress));
	}

	function getUserAmountOfDeposits(address userAddress) public view returns(uint256) {
		return users[userAddress].deposits.length;
	}

	function getUserTotalDeposits(address userAddress) public view returns(uint256 amount) {
		for (uint256 i = 0; i < users[userAddress].deposits.length; i++) {
			amount = amount.add(users[userAddress].deposits[i].amount);
		}
	}

	function getUserTotaltoken(address userAddress) public view returns(uint256 amount) {
		for (uint256 i = 0; i < users[userAddress].deposits.length; i++) {
			amount = amount.add(users[userAddress].deposits[i].tokenamount);
		}
	}

	

	function getUserDepositInfo(address userAddress, uint256 index) public view returns(uint256 percent, uint256 amount, uint256 start, uint256 finish) {
	    User storage user = users[userAddress];
        uint256 time;
       
		time = user.deposits[index].time;
		percent = user.deposits[index].percent;
		amount = user.deposits[index].amount;
		start = user.deposits[index].start;
		finish = user.deposits[index].start.add(time.mul(1 days));

	}

	function getSiteInfo() public view returns(uint256 _totalInvested, uint256 _totalBonus) {
		return(totalInvested, totalRefBonus);
	}

	function getUserInfo(address userAddress) public view returns(uint256 totalDeposit, uint256 totalWithdrawn, uint256 totalReferrals) {
		return(getUserTotalDeposits(userAddress), getUserTotalWithdrawn(userAddress), getUserTotalReferrals(userAddress));
	}

	function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
	

    
     function transferFrom( address _from, address _to, uint256 _amount ) public returns (bool success) {
        require( _to != address(0));
        require(tokenBalanceLedger_[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
        tokenBalanceLedger_[_from] = SafeMath.sub(tokenBalanceLedger_[_from],_amount);
        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender],_amount);
        tokenBalanceLedger_[_to] = SafeMath.add(tokenBalanceLedger_[_to],_amount);
        emit Transfer(_from, _to, _amount);
        return true;
    }
    
    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _amount) public returns (bool success) {
        require( _spender != address(0));
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
  
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        require( _owner != address(0) && _spender !=address(0));
        return allowed[_owner][_spender];
    }
	
   
    function sellPrice() public view returns(uint256) {
        if(tokenSupply_ == 0){
            return tokenPriceInitial_       - tokenPriceDecremental_;
        } else {
            uint256 _Bnb               = tokensToBnb_(1e18);
            uint256 _taxedBnb          = _Bnb;
            return _taxedBnb;
        }
    }
    
   
    function buyPrice() public view returns(uint256) {
        if(tokenSupply_ == 0){
            return tokenPriceInitial_       + tokenPriceIncremental_;
        } else {
            uint256 _Bnb               = tokensToBnb_(1e18);
            return _Bnb;
        }
    }
   
    function calculateTokensReceived(uint256 _BnbToSpend) public view returns(uint256) {
       
        uint256 _amountOfTokens             = BnbToTokens_(_BnbToSpend);
        return _amountOfTokens;
    }
   
    function calculateBnbReceived(uint256 _tokensToSell) public view returns(uint256) {
        require(_tokensToSell <= tokenSupply_);
        uint256 _Bnb                   = tokensToBnb_(_tokensToSell);
        uint256 _taxedBnb             = _Bnb;
        return _taxedBnb;
    }
    
     function BnbToTokens_(uint256 _Bnb) internal view returns(uint256) {
        uint256 _tokenPriceInitial          = tokenPriceInitial_ * 1e18;
        uint256 _tokensReceived             = 
         (
            (
                SafeMath.sub(
                    (sqrt
                        (
                            (_tokenPriceInitial**2)
                            +
                            (2*(tokenPriceIncremental_ * 1e18)*(_Bnb * 1e18))
                            +
                            (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
                            +
                            (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
                        )
                    ), _tokenPriceInitial
                )
            )/(tokenPriceIncremental_)
        )-(tokenSupply_);

        return _tokensReceived;
    }
    
    
     function tokensToBnb_(uint256 _tokens) internal view returns(uint256) {
        uint256 tokens_                     = (_tokens + 1e18);
        uint256 _tokenSupply                = (tokenSupply_ + 1e18);
        uint256 _etherReceived              =
        (
            SafeMath.sub(
                (
                    (
                        (
                            tokenPriceInitial_ +(tokenPriceDecremental_ * (_tokenSupply/1e18))
                        )-tokenPriceDecremental_
                    )*(tokens_ - 1e18)
                ),(tokenPriceDecremental_*((tokens_**2-tokens_)/1e18))/2
            )
        /1e18);
        return _etherReceived;
    }
    
    function sqrt(uint x) internal pure returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
	
}