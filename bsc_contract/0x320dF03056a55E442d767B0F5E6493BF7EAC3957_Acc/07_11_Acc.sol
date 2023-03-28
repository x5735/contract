// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "./library/PancakeLibrary.sol";
import "./interface/IPancakeRouter.sol";
import "./interface/IPancakePair.sol";
import "./interface/IPancakeFactory.sol";

contract Acc is IERC20, IERC20Metadata, Ownable {
    using Address for address;
    using BitMaps for BitMaps.BitMap;

    event addFeeWl(address indexed adr);

    event removeFeeWl(address indexed adr);

    event addBotWl(address indexed adr);

    event removeBotWl(address indexed adr);

    event distributeLpFee(
        address eco,
        uint256 rate,
        uint256 amount,
        uint256 restAmount
    );

    address private constant ROUTER_ADDRESS =
        0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address private constant USDT_ADDRESS =
        0x55d398326f99059fF775485246999027B3197955;

    uint256 public constant DIS_AMOUNT = 20000 * 1e18;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    address public genesisAddress;

    address public techAddress;

    address public communityAddress;

    address public pair;

    mapping(address => uint256) public buyPerAccount;

    mapping(address => uint256) public feePerAccount;

    BitMaps.BitMap private feeWhitelist;

    BitMaps.BitMap private botWhitelist;

    uint256 public lpFeeDisAmount;

    constructor(
        uint256 initAmount,
        address _receiver,
        address genesis,
        address _communityAddress,
        address _techAddress,
        address bot
    ) {
        _name = "aspiring cooperation Community";
        _symbol = "ACC";
        genesisAddress = genesis;
        communityAddress = _communityAddress;
        techAddress = _techAddress;
        pair = IPancakeFactory(IPancakeRouter(ROUTER_ADDRESS).factory())
            .createPair(address(this), USDT_ADDRESS);
        uint256 amount = initAmount * 10**decimals();
        _mint(_receiver, amount);
        addFeeWhitelist(_receiver);
        addFeeWhitelist(genesis);
        addBotWhitelist(bot);
    }

    function addFeeWhitelist(address adr) public onlyOwner {
        feeWhitelist.set(uint256(uint160(adr)));
        emit addFeeWl(adr);
    }

    function removeFeeWhitelist(address adr) public onlyOwner {
        feeWhitelist.unset(uint256(uint160(adr)));
        emit removeFeeWl(adr);
    }

    function getFeeWhitelist(address adr) public view returns (bool) {
        return feeWhitelist.get(uint256(uint160(adr)));
    }

    function addBotWhitelist(address adr) public onlyOwner {
        botWhitelist.set(uint256(uint160(adr)));
        emit addBotWl(adr);
    }

    function removeBotWhitelist(address adr) public onlyOwner {
        botWhitelist.unset(uint256(uint160(adr)));
        emit removeBotWl(adr);
    }

    function getBotWhitelist(address adr) public view returns (bool) {
        return botWhitelist.get(uint256(uint160(adr)));
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 tranType = 0;
        if (to == pair) {
            (uint112 r0, uint112 r1, ) = IPancakePair(pair).getReserves();
            uint256 amountA;
            if (r0 > 0 && r1 > 0) {
                amountA = IPancakeRouter(ROUTER_ADDRESS).quote(amount, r1, r0);
            }
            uint256 balanceA = IERC20(USDT_ADDRESS).balanceOf(pair);
            if (balanceA < r0 + amountA) {
                tranType = 1;
            } else {
                tranType = 2;
            }
        }
        if (from == pair) {
            (uint112 r0, uint112 r1, ) = IPancakePair(pair).getReserves();
            uint256 amountA;
            if (r0 > 0 && r1 > 0) {
                amountA = IPancakeRouter(ROUTER_ADDRESS).getAmountIn(
                    amount,
                    r0,
                    r1
                );
            }
            uint256 balanceA = IERC20(USDT_ADDRESS).balanceOf(pair);
            if (balanceA >= r0 + amountA) {
                tranType = 3;
            } else {
                tranType = 4;
            }
        }

        uint256 oldBalance = balanceOf(from);
        require(oldBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = oldBalance - amount;
        }

        uint256 subAmount;
        if (tranType == 1) {
            if (!feeWhitelist.get(uint256(uint160(from)))) {
                subAmount += shareFee(
                    from,
                    communityAddress,
                    (amount * 30) / 1000
                );
                subAmount += shareFee(
                    from,
                    genesisAddress,
                    (amount * 20) / 1000
                );
                subAmount += shareFee(
                    from,
                    address(this),
                    (amount * 30) / 1000
                );
            }
        } else if (tranType == 3) {
            if (!feeWhitelist.get(uint256(uint160(to)))) {
                subAmount += shareFee(to, techAddress, (amount * 20) / 1000);
                subAmount += shareFee(to, address(this), (amount * 30) / 1000);
                subAmount += shareFee(
                    to,
                    communityAddress,
                    (amount * 30) / 1000
                );
            }
            buyPerAccount[to] += amount - subAmount;
        }

        uint256 toAmount = amount - subAmount;
        _balances[to] += toAmount;
        emit Transfer(from, to, toAmount);

        if (balanceOf(address(this)) >= lpFeeDisAmount) {
            uint256 lpFeeRest = balanceOf(address(this)) - lpFeeDisAmount;
            if (lpFeeRest >= DIS_AMOUNT) {
                lpFeeDisAmount += DIS_AMOUNT;
                emit distributeLpFee(
                    genesisAddress,
                    15,
                    DIS_AMOUNT,
                    lpFeeRest - DIS_AMOUNT
                );
            }
        }
    }

    function shareFee(
        address from,
        address to,
        uint256 amount
    ) private returns (uint256) {
        _balances[to] += amount;
        feePerAccount[to] += amount;
        emit Transfer(from, to, amount);
        return amount;
    }

    function disLpFee(address[] calldata addr, uint256[] calldata amount)
        external
    {
        require(
            botWhitelist.get(uint256(uint160(msg.sender))),
            "not allowed call"
        );
        require(addr.length == amount.length, "addrLen!=amountLen");
        require(addr.length <= 300, "addrLen max 300");
        uint256 total;
        for (uint256 i = 0; i < addr.length; ++i) {
            address adr = addr[i];
            uint256 a = amount[i];
            _transfer(address(this), adr, a);
            total += a;
        }
        lpFeeDisAmount -= total;
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function getInfo(address[] calldata addr)
        external
        view
        returns (uint256[3][] memory r)
    {
        uint256 lp = IPancakePair(pair).totalSupply();
        uint256 tokenAmount = balanceOf(pair);
        r = new uint256[3][](addr.length);
        for (uint256 i = 0; i < addr.length; ++i) {
            uint256 lpBalance = IPancakePair(pair).balanceOf(addr[i]);
            r[i] = [
                lp > 0 ? (lpBalance * tokenAmount) / lp : 0,
                feePerAccount[addr[i]],
                buyPerAccount[addr[i]]
            ];
        }
    }
}