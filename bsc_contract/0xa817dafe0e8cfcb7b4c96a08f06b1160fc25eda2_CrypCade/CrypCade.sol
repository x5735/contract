/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

/*
CrypCade | $lCADE

INTRODUCING ��CrypCade | $lCADE�� - THE FUTURE IS HERE 
Thank you for your continued patience during these turbulent times.
We have been busy working and would like to provide you all with an update on the inner development during the month of September.

https://www.crypcade.city/
https://t.me/CrypCade
https://t.me/CrypCadeNews
https://twitter.com/CrypCade
https://linktr.ee/crypcade

In this update we will go over:

TGE & Listing
Development
Marketing
Partnerships
NFTs
Events
Q4 Roadmap
TGE & Listing:
This is a topic that has been thoroughly discussed on a regular basis within the team and with advisors as well as market makers and exchanges. We had IDOS in August with Launchpads some having great success and selling out. Usually TGE would follow shortly after a Launchpad has completed their IDOs however we are in an ever changing industry and the environment changes as the landscape evolves. Being able to adapt to the harshness of these changes are imperative for the longevity and success of a project.

The community of these Launchpads have been very patient with us, as have the Launchpads themselves and we are very appreciative of this. As you are all aware the Launchpads have recently announced refund policies to protect the communities investments. This is an excellent idea and we support it 100%. However because of this we have had to revise the TGE and Listing strategy for the release of the CrypCade Metaverse, the Beta is available to download at crypcade.city but the full launch and listing is officially delayed with the date TDB.

We are keeping communications open with several exchanges, we have confirmed listing but not yet confirmed and finalised the date. We will be listing on known exchanges, there are several we have commitments with but in which order is TBA. Listing during such a volatile market with varying sentiment is not an option as we have been watching projects launch and some triggering their refund policies. We feel allowing for communities and Launchpads to refund due to non TGE is a better option than refunding due to failing the conditions of the refund policies after listing. This way we can perform another IDO with the launchpads closer to the known listing date.

Further to this there will be no more updates on listing until later in the month of October, we will continue to watch and monitor the market and if things change we will update sooner.

Development:
The CrypCade Metaverse is an open development meaning there is no end point, the development is ongoing and the team strive to add additional elements, fine tune graphics and optimisation, build new sectors, add and integrate new projects and partners, the list goes on. We will be releasing monthly updates and weekly reports as much as possible to keep the community up to date on how things are progressing.
Recently the team has been working on:

Optimising Performance and Gameplay
Creating the mechanics behind the Gaming Economics
Creation of new buildings for new partners
Expansion of Sector one in both vertical and horizontal planes
Creation of new assets and testing of functionality in the metaverse
Connecting with new partners for added utility and functionality in the development TBA later
Adding additional support for more blockchains for interoperable compatibility
Implementation and additional user retention based models introduced to increase the screen time and potential user acquisition
Sector 2 Build is progressing
We will endeavour to do weekly updates and a more detailed monthly update from here on in.

Marketing:
As mentioned earlier TGE and Listing have been postponed, we have also suspended marketing during the market uncertainty as we feel that marketing will yield little benefit to the project during this time. Instead we have been speaking to growth matter experts and advisors to seek advice and direction to focus on growing the community and users.

This will be rolled out over the next few weeks in split A/B Testing spread over numerous platforms so we can analyse the data and make preparations for when marketing is resumed. We feel this is the better course of action in the current climate and will help us identify what fits the project best in terms of marketability. We are also active in finding new parters to utilise their resources and connections for when we can push to market.

Partnerships:
Due to the nature of the project we will always be looking for new partners and additions to add to our network, this will come in many forms. Business integration or collaborations will be used to grow our community and bring in new users to the platform. We hope to see an abundance of projects and businesses partnering and collaborating with Crypcade to help grow the platform to be the fully immersive experience we aim to deliver.
We have onboard both Crypto and Retail businesses in this past month and their integration process has already begun. From being able to purchase digital and physical goods, to rental and lending of assets, community based projects and more to come.

NFTS:
The NFTs have also been effected by the TGE and Listings delay, we are currently reassessing the mechanics behind how the NFTs will interact within the metaverse. Not just for Crypcade NFTs but also for onboard partner projects and businesses who look to onboard their NFTs also.

The Crypcade keys remain the main NFT of the CrypCade Metaverse and can still be purchased HERE though for now they don��t have enabled utility other than the access pass for future utility. We originally planned to have 777 keys per sector but have now decided that we will limit it to 777 in total cutting the Total supply down to 777 for the entirety of the project. No more keys will be created after this collection.

An update later this month will be given for the NFTs (Characters, Vehicles, In Game Assets, etc) As the mechanics are in review and currently being discussed.

Events:
We have been seeing more and more success from the events and though we have not been able to make many appearances and have public presence at them we have started to scope them out. Having a member at the Australian Convention in September, and a member at Token2049 in Singapore. We have a team member still in Singapore in meetings with potential partners as well as Melbourne in Australia.

We are looking at making more of a public appearance in 2023 but are looking to be present for events through out the remainder of 2022. Europe, Dubai and Asia being the primary focus. If you have an event you think we should look at please let us know on one of our social channels.

Q4 Roadmap:
Unfortunately like many projects we to have had to make changes to our Roadmap, we are technically ahead in terms of development but due to market conditions, contractual deals with partners, overall market sentiment and delays that are out of our control. The entire Roadmap not just Q4 will be revised and released.

The entire team are discussing with partnering projects and advisors about the best course of action to take with the Roadmap, please understand a roadmap is not a a fixed schedule but more of a goal and circumstances can create conflicts with timelines. We feel that the Roadmap no longer aligns with the proposed marketing strategy that is being put together and will be reviewed, reaccessed and reinstated.

We understand and apologise for the inconvenience and realise some will be upset but the longevity and growth of the project takes precedence and we must ensure that the long term goal is achieved.

Summary:
This may not have been the update that you were all hoping for but we do appreciate your patience with us.

Key take away from this update:

TGE and Listing delayed TBD
NFTs being reaccessed to create better utility
Marketing strategy being revised
Roadmap to be redone to suit new Marketing strategy
Ongoing partnerships are being created and signed
Development is ongoing
Team presence and focus on community growth to be implemented
*/
// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.17;

abstract contract Contextbep20 {
    function _msgSender() internal view virtual returns (address ) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface bep20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
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
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract Ownablebep20 is Contextbep20 {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownablebep20: caller is not the owner");
        _;
    }

 
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownablebep20: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract CrypCade is Contextbep20, bep20, Ownablebep20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcluded;
    address[] private _excluded;

    uint256 private constant MAX = ~uint256(0);
    uint256 private constant _allTotalSupply = 10000000000 * 10**6 * 10**9;
    uint256 private _rTotalSupply = (MAX - (MAX % _allTotalSupply));
    uint256 private _tFeeTotal;

    string private _name = 'CrypCade';
    string private _symbol = 'lCADE';
    uint8 private _decimals = 9;

    constructor () {
        _rOwned[_msgSender()] = _rTotalSupply;
        emit Transfer(address(0), _msgSender(), _allTotalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _allTotalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function isExcluded(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function reflect(uint256 tAmount) public {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        (uint256 rAmount,,,,) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rTotalSupply = _rTotalSupply.sub(rAmount);
        _tFeeTotal = _tFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _allTotalSupply, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotalSupply, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function excludeAccount(address account) external onlyOwner() {
        require(!_isExcluded[account], "Account is not excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeAccount(address account) external onlyOwner() {
        require(_isExcluded[account], "Account is not excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferStandard(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotalSupply = _rTotalSupply.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
    }

    function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
        uint256 tFee = tAmount.div(100).mul(3);
        uint256 tTransferAmount = tAmount.sub(tFee);
        return (tTransferAmount, tFee);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotalSupply;
        uint256 tSupply = _allTotalSupply;      
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotalSupply, _allTotalSupply);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotalSupply.div(_allTotalSupply)) return (_rTotalSupply, _allTotalSupply);
        return (rSupply, tSupply);
    }
}