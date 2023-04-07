//SPDX-License-Identifier: MIT Licensed
pragma solidity 0.8.17;
pragma experimental ABIEncoderV2;

interface ITOKEN {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 value) external;

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract TCT_PLUS {
    address public admin = 0xf2D5fcB7861120726c6Dc130Ca4BdB13F0Cf4785;
    address public liquidityPool;
    address public Coffe_wallet = 0xC1E3F429Ee0b07232D4c2c0DeBF5388EEB5e9d60;
    address public SubFee_wallet = 0xb466f13d1b1bDFa60AE508A2771A15fb0d9305cf;
    ITOKEN public BUSD;
    ITOKEN public CREST;
    uint256 public joiningFee = 100 ether;
    uint256 public subcriptionFee = 50 ether;
    uint256 public crestTokenFeeBUSD = 10 ether;
    uint256 public tctTokenFeeBUSD = 10 ether;
    uint256 public crestToken = 100 * 1e12;

    uint256[8] directBonus = [
        20 ether,
        30 ether,
        40 ether,
        50 ether,
        55 ether,
        60 ether,
        65 ether,
        70 ether
    ];
    uint256[8] teamBonus = [
        5 ether,
        10 ether,
        20 ether,
        30 ether,
        35 ether,
        40 ether,
        45 ether,
        50 ether
    ];

    uint256[8] directsRequirement = [3, 6, 9, 12, 15, 18, 21, 24];
    uint256[8] teamRequirement = [3, 9, 27, 81, 243, 729, 2178, 6561];
    uint256[8] rankRequirment = [3, 3, 3, 4, 4, 5, 5, 6];
    uint256[8] rankUsers;

    uint256 public totalInvestment;
    uint256 public totalNumberOfInvestors;
    uint256 public totalDirectBonusDistributed;
    uint256 public totalTeamBonusDistributed;

    address[] members;

    struct User {
        bool isRegistered;
        address referrer;
        uint256 numPartners;
        uint256 directs;
        address[] referred;
        uint256 rank;
        uint256 totalDirectBonusDistributed;
        uint256 totalTeamBonusDistributed;
    }
    struct subscription {
        bool iswhitelisted;
        uint256 time;
    }

    mapping(address => User) public users;
    mapping(address => mapping(uint256 => uint256)) public userCount;
    mapping(address => mapping(uint256 => mapping(address => bool)))
        public userExists;
    mapping(address => subscription) public subscriptions;

    modifier onlyAdmin() {
        // Check if the sender is the admin
        require(
            msg.sender == admin,
            "Only admin is allowed to call this function"
        );
        // Execute the function body
        _;
    }

    modifier isNotContract() {
        // Check if the sender is the same as the origin of the transaction
        require(msg.sender == tx.origin, "You are blocked");
        // Check if the sender is not a contract by checking if they have no code
        require(msg.sender.code.length == 0, "You are blocked");
        // Execute the function body
        _;
    }

    constructor(address _liquiditypool) {
        //CREST
        CREST = ITOKEN(0xb4aE1DfeEf9224F89D48AFBcf9fA49f08DF90f26);
        // Set the token contract
        BUSD = ITOKEN(0x55d398326f99059fF775485246999027B3197955);
        // Set the contract's rankUsers
        rankUsers[users[admin].rank]++;
        // Set the contract's CrestToken address
        liquidityPool = _liquiditypool;
        // Register the admin
        users[admin].isRegistered = true;
        // subscribtion of owner
        subscriptions[admin].iswhitelisted = true;
        // Add the admin to the members list
        members.push(admin);
        // Increment the number of investors
        totalNumberOfInvestors++;
    }

    function register(address ref) external isNotContract {
        // Check if the sender is already registered
        require(!users[msg.sender].isRegistered, "Already isRegistered");
        // Check if the referrer is registered
        require(users[ref].isRegistered, "Invalid referrer");
        // Transfer the joining fee from the sender to the contract
        BUSD.transferFrom(msg.sender, address(this), joiningFee);
        // Transfer the crestFeeBUSD to the liquidityPool contract
        BUSD.transfer(liquidityPool, crestTokenFeeBUSD);
        // Transfer the tctFeeBUSD to the tctTokenAddress contract
        BUSD.transfer(Coffe_wallet, tctTokenFeeBUSD);

        // Transfer the crestToken to the sender
        CREST.transferFrom(admin, msg.sender, crestToken);

        // Calculate the amount that will be distributed as rewards
        uint256 amount = joiningFee - (crestTokenFeeBUSD + tctTokenFeeBUSD);

        // Update the contract's total invested and number of members
        totalInvestment += joiningFee;
        members.push(msg.sender);
        totalNumberOfInvestors++;
        rankUsers[users[msg.sender].rank]++;

        // Register the sender
        users[msg.sender].isRegistered = true;
        subscriptions[msg.sender].time = block.timestamp + 30 days;
        users[msg.sender].referrer = ref;

        // Update the referrer's data
        users[ref].referred.push(msg.sender);
        users[ref].directs++;

        // Calculate and distribute the direct bonus to the referrer
        address upline = ref;

        // Calculate and distribute the team bonus to the upline
        while (upline != address(0)) {
            // Update the rank and partners count of the upline
            users[upline].numPartners++;
            for (uint256 i = 0; i < users[upline].referred.length; i++) {
                if (
                    !userExists[upline][uint256(users[upline].rank)][
                        users[upline].referred[i]
                    ] &&
                    users[users[upline].referred[i]].rank >= users[upline].rank
                ) {
                    userCount[upline][uint256(users[upline].rank)]++;
                    userExists[upline][uint256(users[upline].rank)][
                        users[upline].referred[i]
                    ] = true;
                }
            }
            updateRank(upline);
            upline = users[upline].referrer;
        }
        upline = ref;
        if (
            amount >= directBonus[uint256(users[upline].rank)] &&
            (subscriptions[upline].iswhitelisted ||
                subscriptions[upline].time > block.timestamp)
        ) {
            amount -= directBonus[uint256(users[upline].rank)];
            users[upline].totalDirectBonusDistributed += directBonus[
                uint256(users[upline].rank)
            ];
            totalDirectBonusDistributed += directBonus[
                uint256(users[upline].rank)
            ];
            BUSD.transfer(upline, directBonus[uint256(users[upline].rank)]);
        }

        // Calculate and distribute the team bonus to the upline

        // Go to the next upline
        upline = users[ref].referrer;
        uint256 tempamount;
        uint256 index = 0;
        while (
            upline != address(0) &&
            amount >= teamBonus[uint256(users[upline].rank)] &&
            amount > 0
        ) {
            if (
                users[upline].rank > 0 &&
                (subscriptions[upline].iswhitelisted ||
                    subscriptions[upline].time > block.timestamp)
            ) {
                tempamount = teamBonus[uint256(users[upline].rank)];
                users[upline].totalTeamBonusDistributed += tempamount;
                totalTeamBonusDistributed += tempamount;
                {
                    BUSD.transfer(upline, tempamount);
                    amount -= tempamount;
                }
            } else if (
                index < 4 &&
                (subscriptions[upline].iswhitelisted ||
                    subscriptions[upline].time > block.timestamp)
            ) {
                tempamount = teamBonus[uint256(users[upline].rank)];
                users[upline].totalTeamBonusDistributed += tempamount;
                totalTeamBonusDistributed += tempamount;
                {
                    BUSD.transfer(upline, tempamount);
                    amount -= tempamount;
                }
            }

            upline = users[upline].referrer;
            index++;
        }
        if (amount > 0) {
            BUSD.transfer(admin, amount);
        }
    }

    function updateRank(address user) internal {
        // Check if the user has more referrals than the requirement for their current rank
        // and if they have more partners than the requirement for their current rank
        // and if their rank is not AMBASSADOR
        if (
            users[user].referred.length >
            directsRequirement[users[user].rank] &&
            users[user].rank < 7 &&
            userCount[user][users[user].rank] >=
            rankRequirment[users[user].rank]
        ) {
            // Decrement the count of users with the current rank
            rankUsers[users[user].rank]--;
            // Increment the user's rank by 1
            users[user].rank++;
            // Increment the count of users with the new rank
            rankUsers[users[user].rank]++;
        }
    }

    function subscribe(uint256 months) external {
        require(months > 0);
        require(
            block.timestamp > subscriptions[msg.sender].time &&
                users[msg.sender].isRegistered
        );
        BUSD.transferFrom(msg.sender, SubFee_wallet, months * subcriptionFee);
        subscriptions[msg.sender].time = block.timestamp + (months * 30 days);
    }



    function SetRank(address user, uint256 rank) external onlyAdmin {
        require(
            user != address(0) && user != address(0xdead),
            " invalid address"
        );
        require(rank < rankRequirment.length, "invalid rank");
        require(users[user].rank != rank, "already at rank");
        if (users[user].isRegistered) {
            rankUsers[users[user].rank]--;
            users[user].rank = rank;
            rankUsers[users[user].rank]++;
        } else {
            users[user].isRegistered = true;
            users[user].rank = rank;
            users[user].referrer = admin;
            users[admin].referred.push(user);
            users[admin].directs++;
            users[admin].numPartners++;
            members.push(user);
            subscriptions[user].time = block.timestamp + 30 days;
            totalNumberOfInvestors++;
            rankUsers[users[user].rank]++;
        }
    }

    // to Change Admin
    function changeAdmin(address newAdmin) external onlyAdmin {
        // Check if the new admin is not a null address
        require(
            newAdmin != address(0),
            "The new admin address cannot be a null address (0x0)"
        );
        // Check if the new admin is not a dead contract address
        require(
            newAdmin != address(0xdead),
            "The new admin address cannot be a dead contract address (0xdead)"
        );
        // Change the admin
        admin = newAdmin;
    }

    // to withdraw token
    function withdrawToken(address _token, uint256 _amount) external onlyAdmin {
        // Check if the token address is not a null address
        require(
            _token != address(0),
            "The token address cannot be a null address (0x0)"
        );
        // Check if the amount to withdraw is positive
        require(
            _amount > 0,
            "The amount to withdraw must be greater than zero"
        );
        // Check if the contract has sufficient balance of the token
        require(
            ITOKEN(_token).balanceOf(address(this)) >= _amount,
            "The contract has insufficient balance of the token"
        );
        // Transfer the tokens to the admin
        ITOKEN(_token).transfer(admin, _amount);
    }

    // to change joining fee
    function changeJoiningFee(uint256 _joiningFee) external onlyAdmin {
        // Ensure that the new joining fee is greater than 0
        require(_joiningFee > 0, "Joining fee must be greater than 0");
        joiningFee = _joiningFee;
    }

    // to change crestToken reward
    function changecrestTokenreward(uint256 _crestToken) external onlyAdmin {
        crestToken = _crestToken;
    }


    function changesubcriptionFee(uint256 _subcriptionFee) external onlyAdmin {
        // Ensure that the new joining fee is greater than 0
        require(_subcriptionFee > 0, "Joining fee must be greater than 0");
        subcriptionFee = _subcriptionFee;
    }

    // to change crest token fee
    function changecrestTokenFeeBUSD(
        uint256 _crestTokenFeeBUSD
    ) external onlyAdmin {
        // Ensure that the new crestTokenFeeBUSD is greater than 0
        require(
            _crestTokenFeeBUSD > 0,
            "Crest token fee must be greater than 0"
        );
        crestTokenFeeBUSD = _crestTokenFeeBUSD;
    }

    // to change tct token fee
    function changetctTokenFeeBUSD(
        uint256 _tctTokenFeeBUSD
    ) external onlyAdmin {
        // Ensure that the new tctTokenFeeBUSD is greater than 0
        require(_tctTokenFeeBUSD > 0, "Tct token fee must be greater than 0");
        tctTokenFeeBUSD = _tctTokenFeeBUSD;
    }

    // to change direct bonus
    function changeDirectBonus(
        uint256 _directBonus,
        uint256 _rank
    ) external onlyAdmin {
        // Ensure that the new direct bonus is greater than 0
        require(_directBonus > 0, "Direct bonus must be greater than 0");
        // Ensure that the rank is within the valid range
        require(_rank <= directBonus.length, "Invalid rank");
        directBonus[_rank] = _directBonus;
    }

    // to change team bonus
    function changeTeamBonus(
        uint256 _teamBonus,
        uint256 _rank
    ) external onlyAdmin {
        // Ensure that the new team bonus is greater than 0
        require(_teamBonus > 0, "Team bonus must be greater than 0");
        // Ensure that the rank is within the valid range
        require(_rank <= teamBonus.length, "Invalid rank");
        teamBonus[_rank] = _teamBonus;
    }

    // to change team requirement
    function changeteamRequirement(
        uint256 _teamRequirement,
        uint256 _rank
    ) external onlyAdmin {
        // Ensure that the new team requirement is greater than 0
        require(
            _teamRequirement > 0,
            "Team requirement must be greater than 0"
        );
        // Ensure that the rank is within the valid range
        require(_rank <= teamRequirement.length, "Invalid rank");
        teamRequirement[_rank] = _teamRequirement;
    }

    // to change rank requirement
    function changerankRequirement(
        uint256 _rankRequirement,
        uint256 _rank
    ) external onlyAdmin {
        // Ensure that the new rank requirement is greater than 0
        require(
            _rankRequirement > 0,
            "rank requirement must be greater than 0"
        );
        // Ensure that the rank is within the valid range
        require(_rank <= rankRequirment.length, "Invalid rank");
        rankRequirment[_rank] = _rankRequirement;
    }

    // to change directs requirement
    function changedirectsRequirement(
        uint256 _directsRequirement,
        uint256 _rank
    ) external onlyAdmin {
        require(
            _directsRequirement > 0,
            "Directs requirement must be greater than zero"
        );
        // Ensure that the rank is within the valid range
        require(_rank < uint256(7), "Invalid rank");
        directsRequirement[_rank] = _directsRequirement;
    }

    // to change lp address
    function changeliquidityPool(address _liquidityPool) external onlyAdmin {
        require(_liquidityPool != address(0), "Invalid crest token address");
        liquidityPool = _liquidityPool;
    }

    // to change wallet address
    function changeCoffeWallet(address _Coffe_wallet) external onlyAdmin {
        require(_Coffe_wallet != address(0), "Invalid crest token address");
        Coffe_wallet = _Coffe_wallet;
    }

    // to change SubFee_wallet
    function changeSubFee_wallet(address _SubFee_wallet) external onlyAdmin {
        require(_SubFee_wallet != address(0), "Invalid crest token address");
        SubFee_wallet = _SubFee_wallet;
    }

    function whitelistSubcription(
        address _user,
        bool value
    ) external onlyAdmin {
        subscriptions[_user].iswhitelisted = value;
    }

    // to change token BUSD address
    function changeTokenBUSD(address _token) external onlyAdmin {
        require(_token != address(0), "Invalid token address");
        BUSD = ITOKEN(_token);
    }

    // to change token CREST
    function changeTokenCREST(address _token) external onlyAdmin {
        require(_token != address(0), "Invalid token address");
        CREST = ITOKEN(_token);
    }

    function rewardDistribution(
        ITOKEN token,
        uint256 rank,
        uint256 amount
    ) external onlyAdmin {
        // Check if the rank is valid
        require(rank < 7, "Invalid Rank");
        // Check if the amount is valid
        require(amount > 0, "Invalid Amount");
        // Transfer the amount from the sender to the contract
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        // Calculate the amount per user
        uint256 perUser = amount / rankUsers[rank];
        // Distribute the rewards to all the members with the specified rank
        for (uint256 i = 0; i < members.length; i++) {
            if (users[members[i]].rank == rank) {
                // Transfer the reward to the member
                require(token.transfer(members[i], perUser), "Transfer failed");
            }
        }
    }

    // to get directs
    function getDirects(
        address _user
    ) external view returns (address[] memory) {
        return users[_user].referred;
    }

    // to get requirements
    function getRequirements()
        external
        view
        returns (
            uint256[8] memory directsRequired,
            uint256[8] memory teamRequired,
            uint256[8] memory _directBonus,
            uint256[8] memory _teamBonus,
            uint256[8] memory _rankUsers
        )
    {
        return (
            directsRequirement,
            teamRequirement,
            directBonus,
            teamBonus,
            rankUsers
        );
    }

}