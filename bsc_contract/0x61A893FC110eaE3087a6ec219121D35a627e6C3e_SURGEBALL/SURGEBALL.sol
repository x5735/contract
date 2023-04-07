/**
 *Submitted for verification at BscScan.com on 2023-03-31
*/

pragma solidity ^ 0.8.0;

// SPDX-License-Identifier: MIT

library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract SURGEBALL is Ownable {
    using SafeMath for uint256;

    IERC20 public token;
    uint256 public ticketPrice;
    uint256 public devTaxPercentage;
    address public devTaxWallet;
    uint256 public endTime;
    uint256 public prize;
    uint256 public numberOfWinners;
    bool public paused;

    struct Entry {
        address user;
        uint256 ticketCount;
    }

    Entry[] public entries;
    mapping(address => uint256) public userEntryIndex;

    event LotteryStarted(uint256 endTime, uint256 prize, uint256 numberOfWinners);
    event WinnersPicked(address[] winners, uint256 prizePerWinner);

    constructor(
    IERC20 _token,
    uint256 _ticketPriceInTokens,
    uint8 _tokenDecimals,
    uint256 _devTaxPercentage,
    address _devTaxWallet
    ) {
        token = _token;
        ticketPrice = _ticketPriceInTokens * (10 ** uint256(_tokenDecimals));
        devTaxPercentage = _devTaxPercentage;
        devTaxWallet = _devTaxWallet;
    }

    modifier whenNotPaused() {
        require(!paused, "Lottery is paused");
        _;
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function resume() external onlyOwner {
        paused = false;
    }

    function updateDevTaxPercentage(uint256 _devTaxPercentage) external onlyOwner {
    require(_devTaxPercentage <= 100, "Invalid dev tax percentage");
    devTaxPercentage = _devTaxPercentage;
    }

    function updateDevTaxWallet(address _devTaxWallet) external onlyOwner {
    require(_devTaxWallet != address(0), "Invalid dev tax wallet");
    devTaxWallet = _devTaxWallet;
    }



    function buyTicket(uint256 ticketCount) external whenNotPaused {
        require(block.timestamp < endTime, "Lottery has ended");
        uint256 amount = ticketPrice.mul(ticketCount);
        uint256 devTax = amount.mul(devTaxPercentage).div(100);
        token.transferFrom(msg.sender, devTaxWallet, devTax);
        token.transferFrom(msg.sender, address(this), amount.sub(devTax));

        uint256 entryIndex = userEntryIndex[msg.sender];
        if (entryIndex == 0) {
            entries.push(Entry({user: msg.sender, ticketCount: ticketCount}));
            userEntryIndex[msg.sender] = entries.length;
        } else {
            entries[entryIndex - 1].ticketCount = entries[entryIndex - 1].ticketCount.add(ticketCount);
        }
    }

    function resetUserTickets() private {
        for (uint256 i = 0; i < entries.length; i++) {
            userEntryIndex[entries[i].user] = 0;
        }
        delete entries;
    }

    function startLottery(uint256 _endTime, uint256 _prize, uint256 _numberOfWinners) external onlyOwner {
        endTime = _endTime;
        prize = _prize;
        numberOfWinners = _numberOfWinners;

        resetUserTickets();
        emit LotteryStarted(endTime, prize, numberOfWinners);
    }

function pickWinners() external onlyOwner {
    require(block.timestamp >= endTime, "Lottery is still ongoing");
    require(entries.length > 0, "No entries to pick winners from");

    uint256 totalTickets = 0;
    for (uint256 i = 0; i < entries.length; i++) {
        totalTickets = totalTickets.add(entries[i].ticketCount);
    }

    uint256 prizePerWinner = prize.div(numberOfWinners);
    address[] memory winners = new address[](numberOfWinners);

    for (uint256 winnerIndex = 0; winnerIndex < numberOfWinners; winnerIndex++) {
        uint256 winningTicket = uint256(keccak256(abi.encodePacked(block.timestamp, winnerIndex))) % totalTickets;
        uint256 winnerEntryIndex = findWinnerEntryIndex(winningTicket);
        address winner = entries[winnerEntryIndex].user;
        token.transfer(winner, prizePerWinner);
        winners[winnerIndex] = winner;
    }

    emit WinnersPicked(winners, prizePerWinner);

    // Optionally reset the lottery after picking winners
    // startLottery(newEndTime, newPrize, newNumberOfWinners);
    }

function findWinnerEntryIndex(uint256 winningTicket) private view returns (uint256) {
    uint256 ticketSum = 0;
    for (uint256 i = 0; i < entries.length; i++) {
        ticketSum = ticketSum.add(entries[i].ticketCount);
        if (ticketSum > winningTicket) {
            return i;
        }
    }

    revert("Winner not found");
    }


    function getTicketCount(address user) public view returns (uint256) {
        uint256 entryIndex = userEntryIndex[user];
        return entryIndex > 0 ? entries[entryIndex - 1].ticketCount : 0;
    }

    function rescueTokens(IERC20 _token, uint256 _amount) external onlyOwner {
    require(_token != token, "Cannot withdraw lottery token");
    _token.transfer(msg.sender, _amount);
    }

    function getTotalEntries() public view returns (uint256) {
    return entries.length;
    }

}