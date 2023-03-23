// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.17;

//---------------------------------------------------------
// Imports
//---------------------------------------------------------
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

import "./interfaces/ITokenXBaseV3.sol";
import "./interfaces/ICakeBaker.sol";
import "./XNFTHolder.sol";

//---------------------------------------------------------
// Contract
//---------------------------------------------------------
contract Bullish is ReentrancyGuard, Pausable, XNFTHolder
{
	using SafeERC20 for IERC20;

	struct PoolInfo
	{
		address address_token_stake;
		uint256 xnft_grade; // when token is xnft

		address address_token_reward;

		uint256 alloc_point;
		uint256 harvest_interval_block_count; // block count

		uint256 total_staked_amount;
		uint256 accu_reward_amount_per_share;
		uint256 last_reward_block_id;
	}

	struct FeeInfo
	{
		uint256 deposit_e6;

		uint256 withdrawal_min_e6;
		uint256 withdrawal_max_e6;
		uint256 withdrawal_period_block_count; // decrease time from max to min
	}

	struct RewardInfo
	{
		uint256 emission_start_block_id;
		uint256 emission_end_block_id;
		uint256 emission_per_block;
		uint256 emission_weight_e6; // 0% ~ 10%
		uint256 emission_fee_rate_e6; // ~30%
		uint256 total_alloc_point;
	}

	struct UserInfo
	{
		uint256 staked_amount;
		
		uint256 paid_reward_amount;
		uint256 locked_reward_amount;

		uint256 last_deposit_block_id;
		uint256 last_harvest_block_id;
	}

	uint256 public constant MAX_HARVEST_INTERVAL_BLOCK = 15000; // about 15 days
	uint256 public constant MAX_DEPOSIT_FEE_E6 = 200000; // 20%
	uint256 public constant MIN_WITHDRAWAL_FEE_E6 = 0; // 0%
	uint256 public constant MAX_WITHDRAWAL_FEE_E6 = 0; // 20%
	uint256 public constant MAX_EMISSION_WEIGHT_E6 = 100000; // 10%
	uint256 public constant MAX_EMISSION_FEE_E6 = 300000; // 30%

	address public address_chick; // for tax
	address public address_cakebaker; // for delegate farming to pancakeswap

	PoolInfo[] public pool_info; // pool_id / pool_info
	FeeInfo[] public fee_info; // pool_id / fee_info

	mapping(address => bool) public is_pool_exist;
	mapping(uint256 => mapping(address => UserInfo)) public user_info; // pool_id / user_adddress / user_info
	mapping(address => RewardInfo) public reward_info; // reward_address / reward_info

	//---------------------------------------------------------------
	// Front-end connectors
	//---------------------------------------------------------------
	event SetChickCB(address indexed operator, address _controller);
	event SetCakeBakerCB(address indexed operator, address _controller);

	event MakePoolCB(address indexed operator, uint256 new_pool_id);
	event SetPoolInfoCB(address indexed operator, uint256 _pool_id);
	event UpdateEmissionRateCB(address indexed operator, uint256 _reward_per_block);

	event DepositCB(address indexed user, uint256 _pool_id, uint256 _amount);
	event WithdrawCB(address indexed user, uint256 _pool_id, uint256 _amount);
	event HarvestCB(address indexed user, uint256 _pool_id, uint256 _pending_reward_amount);
	event HarvestNotYetCB(address indexed user, uint256 _pool_id);

	event EmergencyWithdrawCB(address indexed user, uint256 _pool_id, uint256 _amount);
	event HandleStuckCB(address indexed user, uint256 _amount);

	//---------------------------------------------------------------
	// External Method
	//---------------------------------------------------------------
	constructor(address _address_chick, address _address_nft) XNFTHolder(_address_nft)
	{
		address_operator = msg.sender;
		address_chick = _address_chick;
		address_nft = _address_nft;
	}

	function make_reward(address _address_token_reward, uint256 _emission_per_block, uint256 _emission_start_block_id, 
		uint256 _emission_end_block_id, uint256 _emission_fee_rate_e6) external onlyOperator
	{
		require(_address_token_reward != address(0), "make_reward: Wrong address");
		require(_emission_start_block_id < _emission_end_block_id, "make_reward: Wrong block id");
		require(_emission_fee_rate_e6 <= MAX_EMISSION_FEE_E6, "make_reward: Fee limit exceed");

		RewardInfo storage reward = reward_info[_address_token_reward];
		reward.emission_per_block = _emission_per_block;
		reward.emission_start_block_id = (block.number > _emission_start_block_id)? block.number : _emission_start_block_id;
		reward.emission_end_block_id = _emission_end_block_id;
		reward.emission_fee_rate_e6 = _emission_fee_rate_e6;
	}

	function make_pool(address _address_token_stake, uint256 _xnft_grade, address _address_token_reward, uint256 _alloc_point,
		uint256 _harvest_interval_block_count, bool _refresh_reward) public onlyOperator
	{
		if(_refresh_reward)
			refresh_reward_per_share_all();

		require(_address_token_stake != address(0), "make_pool: Wrong address");
		require(_address_token_reward != address(0), "make_pool: Wrong address");
		require(_harvest_interval_block_count <= MAX_HARVEST_INTERVAL_BLOCK, "make_pool: Invalid harvest interval");
		require(is_pool_exist[_address_token_stake] == false || _xnft_grade != NFT_NOT_USED, "make_pool: Wrong address");

		RewardInfo storage reward = reward_info[_address_token_reward];
		require(reward.emission_per_block != 0, "make_pool: Invalid reward token");

		is_pool_exist[_address_token_stake] = true;

		reward.total_alloc_point += _alloc_point;

		pool_info.push(PoolInfo({
			address_token_stake: _address_token_stake,
			xnft_grade: _xnft_grade,

			address_token_reward: _address_token_reward,

			alloc_point: _alloc_point,
			harvest_interval_block_count: _harvest_interval_block_count,

			total_staked_amount: 0,
			accu_reward_amount_per_share: 0,
			last_reward_block_id: 0
		}));

		fee_info.push(FeeInfo({
			deposit_e6: 0,
			withdrawal_max_e6: 0,
			withdrawal_min_e6: 0,
			withdrawal_period_block_count: 0
		}));

		uint256 new_pool_id = pool_info.length-1;
		emit MakePoolCB(msg.sender, new_pool_id);
	}

	//function deposit(uint256 _pool_id, uint256 _amount) public whenNotPaused nonReentrant
	function deposit(uint256 _pool_id, uint256 _amount) public nonReentrant
	{
		require(_pool_id < pool_info.length, "deposit: Wrong pool id");

		refresh_reward_per_share_all();
		
		if(_amount == 0)
			return;

		address address_user = msg.sender;
		PoolInfo storage pool = pool_info[_pool_id];
		UserInfo storage user = user_info[_pool_id][address_user];
		
		require(pool.xnft_grade == NFT_NOT_USED, "deposit: Wrong pool id");

		_distribute_rewards(_pool_id, address_user);

		// User -> Bullish
		IERC20 stake_token = IERC20(pool.address_token_stake);
		stake_token.safeTransferFrom(address_user, address(this), _amount);

		// Checking Fee
		uint256 deposit_fee = 0;
		if(fee_info[_pool_id].deposit_e6 > 0)
		{
			// Bullish -> Chick for Fee
			deposit_fee = (_amount * fee_info[_pool_id].deposit_e6) / 1e6;
			stake_token.safeTransfer(address_chick, deposit_fee);
		}

		uint256 deposit_amount = _amount - deposit_fee;

		// Bullish -> CakeBaker for delegate farming
		if(address_cakebaker != address(0))
			ICakeBaker(address_cakebaker).delegate(address(this), pool.address_token_stake, deposit_amount);

		// Write down deposit amount on Bullish's ledger
		user.staked_amount += deposit_amount;
		user.last_deposit_block_id = block.number;
		pool.total_staked_amount += deposit_amount;
		
		emit DepositCB(address_user, _pool_id, _amount);
	}

	// !!!
	function fee_test(uint256 _pool_id, uint256 _amount) external view returns(uint256) 
	{
		require(_pool_id < pool_info.length, "withdraw: Wrong pool id");

		address address_user = msg.sender;
		PoolInfo storage pool = pool_info[_pool_id];
		UserInfo storage user = user_info[_pool_id][address_user];

		require(pool.xnft_grade == NFT_NOT_USED, "deposit: Wrong pool id");

		// Checking Fee
		uint256 withdraw_fee = 0;
		uint256 withdraw_fee_rate_e6 = _get_cur_withdraw_fee_e6(user, fee_info[_pool_id]);
		if(withdraw_fee_rate_e6 > 0)
			withdraw_fee = (_amount * withdraw_fee_rate_e6) / 1e6;

		return withdraw_fee;
	}

	function withdraw(uint256 _pool_id, uint256 _amount) public nonReentrant
	{
		require(_pool_id < pool_info.length, "withdraw: Wrong pool id");

		refresh_reward_per_share_all();

		if(_amount == 0)
			return;

		address address_user = msg.sender;
		PoolInfo storage pool = pool_info[_pool_id];
		UserInfo storage user = user_info[_pool_id][address_user];

		require(pool.xnft_grade == NFT_NOT_USED, "withdraw: Wrong pool id");
		require(user.staked_amount > _amount, "withdraw: Insufficient amount");

		_distribute_rewards(_pool_id, address_user);

		// CakeBaker -> Bullish from delegate farming
		if(address_cakebaker != address(0))
			ICakeBaker(address_cakebaker).retain(address(this), pool.address_token_stake, _amount);

		IERC20 stake_token = IERC20(pool.address_token_stake);

		// Checking Fee
		uint256 withdraw_fee = 0;
		uint256 withdraw_fee_rate_e6 = _get_cur_withdraw_fee_e6(user, fee_info[_pool_id]);
		if(withdraw_fee_rate_e6 > 0)
		{
			// Bullish -> Chick for Fee
			withdraw_fee = (_amount * withdraw_fee_rate_e6) / 1e6;
			stake_token.safeTransfer(address_chick, withdraw_fee);
		}

		uint256 withdraw_amount = _amount - withdraw_fee;
		stake_token.safeTransfer(address_user, withdraw_amount);

		// Write down deposit amount on Bullish's ledger
		user.staked_amount -= _amount;
		pool.total_staked_amount -= _amount;

		emit WithdrawCB(address_user, _pool_id, _amount);
	}

	//function deposit_nfts(uint256 _pool_id, uint256[] memory _xnft_ids) public whenNotPaused nonReentrant
	function deposit_nfts(uint256 _pool_id, uint256[] memory _xnft_ids) public nonReentrant
	{
		require(_pool_id < pool_info.length, "deposit: Wrong pool id");

		refresh_reward_per_share_all();

		if(_xnft_ids.length == 0)
			return;

		address address_user = msg.sender;
		PoolInfo storage pool = pool_info[_pool_id];
		UserInfo storage user = user_info[_pool_id][address_user];

		require(pool.xnft_grade != NFT_NOT_USED, "deposit: Wrong pool id");

		_distribute_rewards(_pool_id, address_user);
		
		// User -> Bullish
		uint256 amount_wei = _deposit_nfts(_pool_id, _xnft_ids) * 1e18;

		// Write down deposit amount on Bullish's ledger
		user.staked_amount += amount_wei;
		user.last_deposit_block_id = block.number;
		pool.total_staked_amount += amount_wei;

		emit DepositCB(address_user, _pool_id, amount_wei);
	}

	function withdraw_nfts(uint256 _pool_id, uint256[] memory _xnft_ids) public nonReentrant
	{
		require(_pool_id < pool_info.length, "withdraw_nfts: Wrong pool id");

		refresh_reward_per_share_all();

		if(_xnft_ids.length == 0)
			return;

		address address_user = msg.sender;
		PoolInfo storage pool = pool_info[_pool_id];
		UserInfo storage user = user_info[_pool_id][address_user];

		require(pool.xnft_grade != NFT_NOT_USED, "withdraw_nfts: Wrong pool id");

		_distribute_rewards(_pool_id, address_user);

		// Bullish -> User
		uint256 amount_wei = _withdraw_nfts(_pool_id, _xnft_ids) * 1e18;

		// Write down deposit amount on Bullish's ledger
		user.staked_amount -= amount_wei;
		pool.total_staked_amount -= amount_wei;

		emit WithdrawCB(address_user, _pool_id, amount_wei);
	}

	//function harvest(uint256 _pool_id) public whenNotPaused nonReentrant
	function harvest(uint256 _pool_id) public nonReentrant
	{
		require(_pool_id < pool_info.length, "harvest: Wrong pool id");

		refresh_reward_per_share_all();
		
		address address_user = msg.sender;

		_distribute_rewards(_pool_id, address_user);
		
		uint256 amount = _collect_reward(_pool_id, address_user);
		if(amount > 0)
			emit HarvestCB(address_user, _pool_id, amount);
		else
			emit HarvestNotYetCB(address_user, _pool_id);
	}

	function refresh_reward_per_share_all() public
	{
		if(paused() == true)
			return;

		for(uint256 i=0; i < pool_info.length; i++)
			_refresh_reward_per_share(i);
	}

	function emergency_withdraw(uint256 _pool_id) public nonReentrant
	{
		require(_pool_id < pool_info.length, "emergency_withdraw: Wrong pool id.");

		address address_user = msg.sender;
		PoolInfo storage pool = pool_info[_pool_id];
		UserInfo storage user = user_info[_pool_id][address_user];

		uint256 amount = user.staked_amount;
		if(amount == 0)
			return;

		if(pool.xnft_grade == NFT_NOT_USED)
		{
			IERC20 stake_token = IERC20(pool.address_token_stake);
			stake_token.safeTransfer(address_user, amount);
		}
		else
			emergency_withdraw_nft(_pool_id);

		user.staked_amount = 0;
		user.locked_reward_amount = 0;
		pool.total_staked_amount -= amount;

		emit EmergencyWithdrawCB(address_user, _pool_id, amount);
	}

	function handle_stuck(address _address_user, address _address_token, uint256 _amount) public onlyOperator
	{
		for(uint256 i=0; i<pool_info.length; i++)
		{
			require(_address_token != pool_info[i].address_token_stake, "handle_stuck: Wrong token address");
			require(_address_token != pool_info[i].address_token_reward, "handle_stuck: Wrong token address");
		}

		IERC20 stake_token = IERC20(_address_token);
		stake_token.safeTransfer(_address_user, _amount);

		emit HandleStuckCB(_address_user, _amount);
	}

	//---------------------------------------------------------------
	// Internal Method
	//---------------------------------------------------------------
	function _refresh_reward_per_share(uint256 _pool_id) internal
	{
		PoolInfo storage _pool = pool_info[_pool_id];
		if(_pool.alloc_point == 0 || _pool.total_staked_amount == 0 || block.number <= _pool.last_reward_block_id)
			return;

		RewardInfo storage _reward = reward_info[_pool.address_token_reward];

		if(	_reward.emission_per_block == 0 ||
			_reward.total_alloc_point == 0 ||

			_reward.emission_start_block_id == 0 ||
			_reward.emission_end_block_id == 0 ||

			block.number < _reward.emission_start_block_id || 
			block.number > _reward.emission_end_block_id)
			return;

		if(_pool.last_reward_block_id == 0)
			_pool.last_reward_block_id = block.number;
		
		uint256 elapsed_block_count = block.number - _pool.last_reward_block_id;
		uint256 mint_reward_amount = (elapsed_block_count * _reward.emission_per_block * _pool.alloc_point) / _reward.total_alloc_point;

		if(mint_reward_amount == 0)
			return;
		
		// add more rewards for the nft boosters
		uint256 pool_boost_rate_e6 = get_pool_tvl_boost_rate_e6(_pool_id);
		if(pool_boost_rate_e6 > 0)
			mint_reward_amount += (mint_reward_amount * (1000000 + pool_boost_rate_e6) / 1e6);

		ITokenXBaseV3 reward_token = ITokenXBaseV3(_pool.address_token_reward);

		// to reward pool
		reward_token.mint(address(this), mint_reward_amount);
		
		// to fund
		if(address_chick != address(0))
		{
			uint256 reward_for_fund = (mint_reward_amount * _reward.emission_fee_rate_e6) / 1e6;
			reward_token.mint(address_chick, reward_for_fund);
		}

		uint256 rps = (mint_reward_amount / _pool.total_staked_amount);
		_pool.accu_reward_amount_per_share += rps;
		_pool.last_reward_block_id = block.number;
	}
	
	function _distribute_rewards(uint256 _pool_id, address _address_user) internal
	{
		PoolInfo storage _pool = pool_info[_pool_id];
		UserInfo storage _user = user_info[_pool_id][_address_user];

		// reward: pool to user
		uint256 accu_rps = _pool.accu_reward_amount_per_share;
		if(accu_rps == 0)
			return;
		
		uint256 user_boosted_staked_amount = _get_boosted_user_amount(_pool_id, _address_user, _user.staked_amount);
		uint256 final_user_reward_amount = user_boosted_staked_amount * accu_rps;
		_user.locked_reward_amount += final_user_reward_amount;
	}
	
	function _collect_reward(uint256 _pool_id, address _address_user) private returns(uint256)
	{
		PoolInfo storage pool = pool_info[_pool_id];
		UserInfo storage user = user_info[_pool_id][_address_user];
		
		if(user.locked_reward_amount > 0 && 
			block.number >= (user.last_harvest_block_id + pool.harvest_interval_block_count))
		{
			uint256 amount = user.locked_reward_amount;
			_safe_reward_transfer(pool, _address_user, amount);

			user.paid_reward_amount += amount;
			user.locked_reward_amount = 0;
			user.last_harvest_block_id = block.number;

			return amount;
		} 
		else
			return 0;
	}

	function _safe_reward_transfer(PoolInfo storage _pool, address _to, uint256 _amount) internal
	{
		IERC20 reward_token = IERC20(_pool.address_token_reward);
		uint256 cur_reward_balance = reward_token.balanceOf(address(this));

		if(_amount > cur_reward_balance)
			reward_token.safeTransfer(_to, cur_reward_balance);
		else
			reward_token.safeTransfer(_to, _amount);
	}

	//function _get_boosted_user_amount(uint256 _pool_id, address _address_user, uint256 _user_staked_amount) internal view returns(uint256)
	function _get_boosted_user_amount(uint256 _pool_id, address _address_user, uint256 _user_staked_amount) public view returns(uint256)
	{
		uint256 tvl_boost_rate_e6 = get_user_tvl_boost_rate_e6(_pool_id, _address_user);
		uint256 boosted_amount_e6 = _user_staked_amount * (1000000 + tvl_boost_rate_e6);
		return boosted_amount_e6 / 1e6;
	}

	function _get_cur_withdraw_fee_e6(UserInfo storage _user, FeeInfo storage _fee) internal view returns(uint256)
	{
		if(_fee.withdrawal_period_block_count == 0)
			return 0;

		uint256 block_diff = (block.number <= _user.last_deposit_block_id)? 0 : block.number - _user.last_deposit_block_id;
		uint256 reduction_rate_e6 = _min(block_diff * 1e6 / _fee.withdrawal_period_block_count, 1000000);
		uint256 fee_diff = _fee.withdrawal_max_e6 - _fee.withdrawal_min_e6;

		return (_fee.withdrawal_max_e6 - (fee_diff * reduction_rate_e6)) / 1e6;
	}

	function _min(uint256 a, uint256 b) internal pure returns(uint256)
	{
		return a <= b ? a : b;
	}

	//---------------------------------------------------------------
	// Variable Interfaces
	//---------------------------------------------------------------
	function set_chick(address _new_address) external onlyOperator
	{
		require(_new_address != address(0), "set_chick: Wrong address");

		address_chick = _new_address;
		for(uint256 i=0; i<pool_info.length; i++)
		{
			ITokenXBaseV3 reward_token = ITokenXBaseV3(pool_info[i].address_token_reward);
			reward_token.set_chick(address_chick);
		}

		emit SetChickCB(msg.sender, _new_address);
	}

	function set_cakebaker(address _new_address) external onlyOperator
	{
		require(_new_address != address(0), "set_cakebaker: Wrong address");
		address_cakebaker = _new_address;

		emit SetCakeBakerCB(msg.sender, _new_address);
	}

	function get_pool_count() external view returns(uint256)
	{
		return pool_info.length;
	}
	
	function set_deposit_fee_e6(uint256 _pool_id, uint256 _fee_e6) external onlyOperator
	{
		require(_pool_id < pool_info.length, "set_deposit_fee_e6: Wrong pool id.");
		require(_fee_e6 <= MAX_DEPOSIT_FEE_E6, "set_deposit_fee_e6: Maximun deposit fee exceeded.");

		FeeInfo storage cur_fee = fee_info[_pool_id];
		cur_fee.deposit_e6 = _fee_e6;
	}

	function set_withdrawal_fee_e6(uint256 _pool_id, uint256 _fee_max_e6, uint256 _fee_min_e6, uint256 _period_block_count) external onlyOperator
	{
		require(_pool_id < pool_info.length, "set_withdrawal_fee: Wrong pool id.");
		require(_fee_min_e6 >= MIN_WITHDRAWAL_FEE_E6, "set_withdrawal_fee: Minimun fee exceeded.");
		require(_fee_max_e6 <= MAX_WITHDRAWAL_FEE_E6, "set_withdrawal_fee: Maximun fee exceeded.");
		require(_fee_min_e6 <= _fee_max_e6, "set_withdrawal_fee: Wrong withdrawal fee");

		FeeInfo storage cur_fee = fee_info[_pool_id];
		cur_fee.withdrawal_max_e6 = _fee_max_e6;
		cur_fee.withdrawal_min_e6 = _fee_min_e6;
		cur_fee.withdrawal_period_block_count = _period_block_count;
	}

	function set_alloc_point(uint256 _pool_id, uint256 _alloc_point, bool _refresh_reward) external onlyOperator
	{
		require(_pool_id < pool_info.length, "set_alloc_point: Wrong pool id.");

		if(_refresh_reward)
			refresh_reward_per_share_all();

		PoolInfo storage pool = pool_info[_pool_id];
		RewardInfo storage reward = reward_info[pool.address_token_reward];

		reward.total_alloc_point += _alloc_point;
		reward.total_alloc_point -= pool.alloc_point;

		pool.alloc_point = _alloc_point;
	}

	function set_emission_per_block(address _address_reward, uint256 _emission_per_block) external onlyOperator
	{
		require(_address_reward != address(0), "set_emission_per_block: Wrong address");

		refresh_reward_per_share_all();

		reward_info[_address_reward].emission_per_block = _emission_per_block;
		emit UpdateEmissionRateCB(msg.sender, _emission_per_block);
	}

	function set_emission_weight_e6(address _address_token_reward, uint256 _emission_weight_e6) external onlyOperator
	{
		require(_address_token_reward != address(0), "set_emission_weight_e6: Wrong address");
		require(_emission_weight_e6 <= MAX_EMISSION_WEIGHT_E6, "set_emission_weight_e6: limit exceed");

		RewardInfo storage reward = reward_info[_address_token_reward];
		require(reward.emission_per_block > 0, "set_emission_weight_e6: Wrong reward address");

		refresh_reward_per_share_all();
		
		reward.emission_weight_e6 = _emission_weight_e6;
	}

	function pause() external onlyOperator
	{
		_pause();
	}

	function resume() external onlyOperator
	{
		_unpause();
	}
}