// SPDX-License-Identifier: MIT
pragma solidity =0.8.17;

import "./ERC20.sol";
import "./ERC20Burnable.sol";
import "./Ownable.sol";
import "./IRouterV2.sol";
import "./IFactoryV2.sol";

contract FLOKISHIBAPEPECEO is ERC20, ERC20Burnable, Ownable {
    //---------- Contracts ----------//
    IRouterV2 public dexRouter; // DEX router contract.

    //---------- Variables ----------//
    address public lpPair; // Pair that contains the liquidity for the taxSwap.
    address payable public treasury; // Address that manages the funds for betting.
    uint256 public constant sellTax = 5; // 5% tax on sell.
    bool public hasLiquidity; // Flag to check if you already have liquidity.
    bool private onSwap; // Flag to check if on swap tax tokens.

    //---------- Storage -----------//
    mapping(address => bool) private _lpPairs; // Contains the liquidity pairs of the token.
    mapping(address => bool) private _isExcluded; // Contains the addresses excluded from the sell tax.

    //---------- Events -----------//
    event ModifiedExclusion(address account, bool enabled);
    event ModifiedPair(address pair, bool enabled);
    event NewTreasury(address newTreasury);
    event NewRouter(address newRouter, address lpPair);

    //---------- Constructor ----------//
    constructor(IRouterV2 _dexRouter) ERC20("FLOKI SHIBA PEPE CEO", "3CEO") {
        _mint(msg.sender, 100_000_000_000_000_000 * 10**decimals());
        dexRouter = _dexRouter;
        lpPair = IFactoryV2(dexRouter.factory()).createPair(
            dexRouter.WETH(),
            address(this)
        );
        _lpPairs[lpPair] = true;
        _isExcluded[msg.sender] = true;
        _isExcluded[address(this)] = true;
        treasury = payable(msg.sender);
        hasLiquidity = false;
    }

    //---------- Modifiers ----------//
    /**
     * @dev Modify the status of the boolean onSwap for checks in the transfer.
     */
    modifier swapLocker() {
        onSwap = true;
        _;
        onSwap = false;
    }

    //----------- Internal Functions -----------//
    /**
     * @dev Swap the sell tax and send it to the treasury.
     * @param amount of tokens to swap.
     */
    function _taxSwap(uint256 amount) internal swapLocker {
        if (allowance(address(this), address(dexRouter)) != type(uint256).max) {
            _approve(address(this), address(dexRouter), type(uint256).max);
        }

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = dexRouter.WETH();

        try
            dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
                amount,
                0,
                path,
                treasury,
                block.timestamp
            )
        {} catch {
            return;
        }
    }

    /**
     * @dev Check if the pair has liquidity.
     */
    function _checkLiquidity() internal {
        require(!hasLiquidity, "Already have liquidity");
        if (balanceOf(lpPair) > 0) {
            hasLiquidity = true;
        }
    }

    /**
     * @dev Override the internal transfer function to apply the sell tax and distribute it.
     * @param sender address of origin.
     * @param recipient destination address.
     * @param amount tokens to transfer.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        require(
            sender != address(0x0),
            "ERC20: transfer from the zero address"
        );
        require(
            recipient != address(0x0),
            "ERC20: transfer to the zero address"
        );
        require(amount > 0, "Transfer amount must be greater than zero");

        if (!hasLiquidity) {
            _checkLiquidity();
        }

        if (!onSwap) {
            if (hasLiquidity) {
                uint256 balance = balanceOf(address(this));
                if (balance > 0) {
                    _taxSwap(balance);
                }
            }
        }

        // check whitelist
        bool excluded = _isExcluded[sender] || _isExcluded[recipient];

        if (excluded || !_lpPairs[recipient]) {
            super._transfer(sender, recipient, amount);
        } else {
            // sell tax amount
            uint256 taxAmount = (amount * sellTax) / 100;

            // tax transfer sent to this contract
            super._transfer(sender, address(this), taxAmount);
            // default transfer sent to recipient
            super._transfer(sender, recipient, amount - taxAmount);
        }
    }

    //----------- External Functions -----------//
    /**
     * @notice Check if a address is excluded from tax.
     * @param account address to check.
     * @return Boolean if excluded or not.
     */
    function isExcluded(address account) external view returns (bool) {
        return _isExcluded[account];
    }

    /**
     * @notice Check if a pair address is on list.
     * @param pair address to check.
     * @return Boolean if on list or not.
     */
    function isLpPair(address pair) external view returns (bool) {
        return _lpPairs[pair];
    }

    //----------- Owner Functions -----------//
    /**
     * @notice Set address in exclude list.
     * @param account address to set.
     * @param enabled boolean to enable or disable.
     */
    function setExcluded(address account, bool enabled) external onlyOwner {
        require(account != address(0x0), "Invalid address");
        _isExcluded[account] = enabled;
        emit ModifiedExclusion(account, enabled);
    }

    /**
     * @notice Set address in pairs list.
     * @param pair address to set.
     * @param enabled boolean to enable or disable.
     */
    function setLpPair(address pair, bool enabled) external onlyOwner {
        require(pair != address(0x0), "Invalid pair");
        _lpPairs[pair] = enabled;
        emit ModifiedPair(pair, enabled);
    }

    /**
     * @notice Change the trasury address.
     * @param newTreasury address to set.
     */
    function setTreasury(address newTreasury) external onlyOwner {
        require(newTreasury != address(0x0), "Invalid address");
        treasury = payable(newTreasury);
        emit NewTreasury(newTreasury);
    }

    /**
     * @notice Change the dex router address before having liquidity.
     * @param newRouter address to set.
     */
    function setRouter(address newRouter) external onlyOwner {
        require(newRouter != address(0x0), "Invalid router");
        require(!hasLiquidity, "Already have liquidity");
        IRouterV2 router = IRouterV2(newRouter);
        address newPair = IFactoryV2(router.factory()).getPair(
            address(this),
            router.WETH()
        );
        if (newPair == address(0x0)) {
            lpPair = IFactoryV2(router.factory()).createPair(
                address(this),
                router.WETH()
            );
        } else {
            lpPair = newPair;
        }
        dexRouter = router;
        _approve(address(this), address(dexRouter), type(uint256).max);
        emit NewRouter(newRouter, lpPair);
    }

    /**
     * @notice Swap tokens of sell tax.
     * @param amount to swap.
     */
    function swapTax(uint256 amount) external onlyOwner {
        uint256 balance = balanceOf(address(this));
        require(amount > 0 && balance > 0, "Zero amount");
        uint256 toSwap = amount > balance ? balance : amount;
        _taxSwap(toSwap);
    }
}