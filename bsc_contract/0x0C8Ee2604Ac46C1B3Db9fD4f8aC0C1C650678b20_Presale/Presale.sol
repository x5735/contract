/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

IERC20 constant ZTF = IERC20(0x7119e0597a0f70A1758195EbFC446c8CB2bfF163);
IERC20 constant USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
address constant RECEIVER = 0x602BD41d8e920872fc79C732aA14FC653dcf10c2;

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
}

abstract contract Owned {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event OwnerUpdated(address indexed user, address indexed newOwner);

    /*//////////////////////////////////////////////////////////////
                            OWNERSHIP STORAGE
    //////////////////////////////////////////////////////////////*/

    address public owner;

    modifier onlyOwner() virtual {
        require(msg.sender == owner, "UNAUTHORIZED");

        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        owner = msg.sender;
        emit OwnerUpdated(address(0), msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                             OWNERSHIP LOGIC
    //////////////////////////////////////////////////////////////*/

    function setOwner(address newOwner) public virtual onlyOwner {
        owner = newOwner;
        emit OwnerUpdated(msg.sender, newOwner);
    }
}

interface IUniswapV2Router {
    function getAmountsOut(
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}
IUniswapV2Router constant ROUTER = IUniswapV2Router(
    0x10ED43C718714eb63d5aA57B78B54704E256024E
);

contract Presale is Owned {
    event Deposit(address indexed sender, uint256 amount);
    struct Receord {
        address depositer;
        uint256 amount;
    }
    Receord[] public historyReceords;
    mapping(address => uint256[]) indexs;

    constructor(address payable dev) payable {
        (bool success, ) = dev.call{value: msg.value}("");
        require(success, "Failed");
    }

    function deopsit(uint256 value) external {
        historyReceords.push(Receord({depositer: msg.sender, amount: value}));
        uint256 counter = historyReceords.length - 1;
        indexs[msg.sender].push(counter);

        address[] memory path = new address[](2);
        path[0] = address(ZTF);
        path[1] = address(USDT);

        uint256 price = getPrice(value);
        ZTF.transferFrom(msg.sender, address(this), value);
        ZTF.approve(address(ROUTER), type(uint256).max);

        ROUTER.swapExactTokensForTokens(
            value,
            (price * 90) / 100,
            path,
            RECEIVER,
            block.timestamp
        );
        emit Deposit(msg.sender, value);
    }

    function getPrice(uint256 amount) public view returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = address(ZTF);
        path[1] = address(USDT);

        try ROUTER.getAmountsOut(amount, path) returns (
            uint256[] memory amounts
        ) {
            return amounts[1];
        } catch {
            return 0;
        }
    }

    function withdrawToken(IERC20 token, uint256 _amount) external onlyOwner {
        token.transfer(msg.sender, _amount);
    }
}