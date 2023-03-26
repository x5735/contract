/**
 *Submitted for verification at BscScan.com on 2023-03-25
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

 

interface IPancakeRouter {
    function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)  external payable returns (uint[] memory amounts);
    function WETH() external pure returns (address);
}
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
} 

contract SwapAndSend {
    address private _router;
    address private _tokenAAddress;
    address private _walletCAddress;
    address private _creator;

    constructor(address PANCAKE_ROUTER_ADDRESS, address walletCAddress) {
        _creator = msg.sender;
        _walletCAddress = walletCAddress;
        _router = PANCAKE_ROUTER_ADDRESS;
    }

    function setRouter(address router) public {
        require(msg.sender == _creator, "not the creator");
        _router = router;
    }

   function setTokenAAddress(address tokenAAddress) public {
        require(msg.sender == _creator, "not the creator");
        _tokenAAddress = tokenAAddress;
    }
 
    function setWalletCAddress(address walletCAddress) public {
        require(msg.sender == _creator, "not the creator");
        _walletCAddress = walletCAddress;
    }

    function swapExactETHForToken(uint amonttokenA) public payable{
        require(msg.sender == _creator, "not the creator");
        IPancakeRouter pancakeRouter = IPancakeRouter(_router);
        address[] memory path = new address[](2);
        path[0] = pancakeRouter.WETH();
        path[1] = _tokenAAddress;
        pancakeRouter.swapExactETHForTokens{value: msg.value}(
            amonttokenA,
            path,
            address(this),
            block.timestamp + 15

        );
        uint tokenABalance = IERC20(_tokenAAddress).balanceOf(address(this));
        IERC20(_tokenAAddress).transfer(_walletCAddress, tokenABalance);
    }
}