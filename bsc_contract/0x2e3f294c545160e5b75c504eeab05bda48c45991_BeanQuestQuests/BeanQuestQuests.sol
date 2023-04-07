/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BeanQuestQuests {
    mapping(address => bool) public authorized;

    modifier auth() {
        require(authorized[msg.sender]);
        _;
    }
    
    address payable dev;
    address payable dev2;

    constructor(address _dev2) {
        authorized[msg.sender] = true;
        dev = payable(msg.sender);
        dev2 = payable(_dev2);
    }

    function changeDevAddresses(address _dev, address _dev2) public auth() {
        dev = payable(_dev);
        dev2 = payable(_dev2);
    }


    address nftAddress = 0x0c934422FbAB47668C2b3284B95cF444297A23B0;
    address gachaAddress = 0x6759dda0e5f4e4205DDF8909FDEF33EBdcB251Ca;
    NFTs nft = NFTs(nftAddress);
    BeanQuestGacha gacha = BeanQuestGacha(gachaAddress);
    BeanQuest miner = BeanQuest(0x9f5FcfeaaF8aA60cB4239d53507429b8cC86b015);

    event QuestCompleted (address user, string nick, uint quest);
    event QuestStepFulfilled (address user, string nick, uint quest, uint step);

    function setContracts(address _nft, address _gacha, address _miner) public auth() {
        nftAddress = _nft;
        gachaAddress = _gacha;
        nft = NFTs(_nft);
        gacha = BeanQuestGacha(_gacha);
        miner = BeanQuest(_miner);
    }    

    struct Quest {
        uint[] items;
        uint[] amounts;
        uint reward;
        uint rwdAmount;
        uint magicBeans;
        uint itemRequired;
        uint[] statsRequired;
    }

    struct Recipe {
        uint blueprint;
        uint[] ingredients;
        uint[] amounts;
        uint result;
        uint resultAmount;
        uint magicBeans;    
    }

    Recipe[] public recipes;
    Quest[] public quests;
    mapping(address => mapping(uint => uint)) currentQuestStep;
    mapping(address => mapping(uint => bool)) questCompleted;



    mapping(address => bool) public canMint;

    function authorize(address _addr, bool _bool) public auth() {
        authorized[_addr] = _bool;
    } 

    function setCanMint(bool _can, address _addr) public auth() {
        canMint[_addr] = _can;
    }

    function mint(uint id, address receiver, uint amount) public {
        require(canMint[msg.sender], "Address is not authorized to mint");
        nft.mint(id, receiver, amount);
    }

    function burn(uint id, address addr, uint amount) public {
        require(canMint[msg.sender], "Address is not authorized to mint");
        nft._burnQuestItem(addr, id, amount);
    }

    function createQuests(Quest[] memory _quests) public auth() {
        uint length = _quests.length;
        for(uint i; i < length; i++) {
            quests.push(_quests[i]);
        }
    }

    function createQuest(Quest memory _quest) public auth() {
        quests.push(_quest);
    }

    function changeQuest(uint questId, Quest memory _quest) public auth() {
        quests[questId] = _quest;
    }

    function createRecipes(Recipe[] memory _recipes) public auth() {
        uint length = _recipes.length;
        for(uint i; i < length; i++) {
            recipes.push(_recipes[i]);
        }
    }

    function createRecipe(Recipe memory _recipe) public auth() {
        recipes.push(_recipe);
    }

    function changeRecipe(uint recipeId, Recipe memory _recipe) public auth() {
        recipes[recipeId] = _recipe;
    }

    function completeQuestStep(uint questId) public {
        Quest memory quest = quests[questId];
        uint _currentStep = currentQuestStep[msg.sender][questId];
        if(_currentStep == 0) {
            uint[4] memory stats = nft.userStats(msg.sender);
            require(stats[0] >= quest.statsRequired[0], "You do not have enough Strength to begin this quest");
            require(stats[1] >= quest.statsRequired[1], "You do not have enough Dexterity to begin this quest");
            require(stats[2] >= quest.statsRequired[2], "You do not have enough Intelligence to begin this quest");
            require(stats[3] >= quest.statsRequired[3], "You are not at a high enough Level to begin this quest");
        }
        require(currentQuestStep[msg.sender][questId] != quest.items.length, "You have already completed this quest.");
        if(quest.itemRequired != 0) {
            require(nft.balanceOf(msg.sender, quest.itemRequired) > 0, "You do not own the required item to do this quest.");
        }
        require(nft.balanceOf(msg.sender, quest.items[_currentStep]) >= quest.amounts[_currentStep], "You do not have the items required to fulfill this step");
        nft._burnQuestItem(msg.sender, quest.items[_currentStep], quest.amounts[_currentStep]);
        if(_currentStep+1 == quest.items.length) {
            if(quest.reward != 0) {
                nft.mint(quest.reward, msg.sender, quest.rwdAmount);
            }
            gacha.sendGachaTokens(quest.magicBeans, msg.sender);
            questCompleted[msg.sender][questId];
            emit QuestCompleted(msg.sender, miner.getNicknameToAddress(msg.sender), questId);
        }
        emit QuestStepFulfilled(msg.sender, miner.getNicknameToAddress(msg.sender), questId, _currentStep);
        currentQuestStep[msg.sender][questId]++;
    }

    function craftItem(uint recipeId) public{
        Recipe memory recipe = recipes[recipeId];
        require(nft.balanceOf(msg.sender, recipe.blueprint) > 0, "You do not own the blueprint required to craft this item!");
        for(uint i; i < recipe.ingredients.length; i++) {
            require(nft.balanceOf(msg.sender, recipe.ingredients[i]) >= recipe.amounts[i]);
        }
        for(uint i; i < recipe.ingredients.length; i++) {
            nft._burnQuestItem(msg.sender, recipe.ingredients[i], recipe.amounts[i]);
        }
        if(recipe.result != 0) {
            nft.mint(recipe.result, msg.sender, recipe.resultAmount);
        }
        gacha.sendGachaTokens(recipe.magicBeans, msg.sender);
    }

    function getCurrentStep(uint questId, address _addr) external view returns(uint) {
        return currentQuestStep[_addr][questId];
    }

    function getCurrentStepForEachQuest(address _addr) external view returns(uint[] memory) {
        uint[] memory _steps = new uint[](quests.length);
        for(uint i; i < quests.length; i++){
            _steps[i] = currentQuestStep[_addr][i];
        }
        return _steps;
    }

    function getQuests() external view returns(Quest[] memory) {
        return quests;
    }

    function getQuest(uint questId) external view returns(Quest memory) {
        return quests[questId];
    }

    function getRecipes() external view returns(Recipe[] memory) {
        return recipes;
    }

    function getRecipe(uint recipeId) external view returns(Recipe memory) {
        return recipes[recipeId];
    }

}

contract NFTs {
    function balanceOf(address account, uint256 id) external view returns (uint256) {}
    function userStats(address _addr) view external returns(uint[4] memory) {}
    function getEffectStatus(uint8 _bonus, address _add) public view returns(bool) {}
    function getRelicActiveForBonus(address _add, uint8 _bonus) public view returns(uint) {}
    function getBonusMultiplier(uint _id) public view returns (uint) {}
    function mint(uint _id, address _add, uint amount) public {}
    function _burnQuestItem(address _addr, uint id, uint amount) external {}
    function updateStats(uint payout, address _addr, uint8 _attribute) external returns(uint) {}
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external {}
}

contract BeanQuest {
    function getNicknameToAddress(address _addr) public view returns (string memory nick){}
}

contract BeanQuestGacha {
    function sendGachaTokens(uint _amount, address receiver) public {}
}