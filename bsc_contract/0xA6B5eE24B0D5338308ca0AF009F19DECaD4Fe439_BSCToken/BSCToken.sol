/**
 *Submitted for verification at BscScan.com on 2023-03-27
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

interface IERC20 {
    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ISwapRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
}


interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);


    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
 
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
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
        emit OwnershipTransferred(_owner, address(0xdead));
        _owner = address(0xdead);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TokenDistributor {
    address public _owner;
    constructor (address token) {
        _owner = msg.sender;
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }
    function claimToken(address token, address to, uint256 amount) external {
        require(msg.sender == _owner, "not owner");
        uint256 balance = IERC20(token).balanceOf(address(this));
        if(amount==0){IERC20(token).transfer(to, balance);}
        else if(amount <= balance)IERC20(token).transfer(to, amount);
    }
}

contract DefiDistributor {
    address public _owner;
    constructor (address token, address sender) {
        _owner = sender;
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }
    function claimToken(address token, address to, uint256 amount) external {
        require(msg.sender == _owner, "not owner");
        IERC20(token).transfer(to, amount);
    }
}

contract NFTRewardDistributor {
    address public _owner;
    constructor (address token) {
        _owner = msg.sender;
        IERC20(token).approve(msg.sender, uint(~uint256(0)));
    }
    function claimToken(address token, address to, uint256 amount) external {
        require(msg.sender == _owner, "not owner");
        uint256 balance = IERC20(token).balanceOf(address(this));
        if(amount==0){IERC20(token).transfer(to, balance);}
        else if(amount <= balance)IERC20(token).transfer(to, amount);
    }
}

abstract contract AbsToken is IERC20, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public fundAddress;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => bool) public _feeWhiteList;

    uint256 private _tTotal;

    ISwapRouter public _swapRouter;
    address public _USDT;
    address public _defiToken;
    address public Dead = 0x000000000000000000000000000000000000dEaD;
    mapping(address => bool) public _swapPairList;
    mapping(address => uint256) public _editList;
    mapping(address => bool) public isPre;
    mapping(address => uint256) UserBuy;

    bool private inSwap;
    address private receiveAddress;

    uint256 private constant MAX = ~uint256(0);
    TokenDistributor public _tokenDistributor;
    NFTRewardDistributor public _nftDistributor;
    DefiDistributor public _defiDistributor;

    uint256 public _buyFundFee = 100;
    uint256 public _buyLPDividendFee = 250;
    uint256 public _buyNftFee = 100;
    uint256 public _sellLPDividendFee = 250;
    uint256 public _sellFundFee = 100;
    uint256 public _sellNftFee = 100;
    uint256 public _deadFee = 50;
    uint256 _removeFee = 3000;
    uint256 public kb = 1;

    uint256 public startTradeBlock;
    uint256 public condition;
    uint256 public buyLim;
    uint256 public buylimOne;
    bool private buylimEnable = true;

    address public _mainPair;
    address private _tokensDistributor;

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor (
        address RouterAddress, address USDTAddress, address _f,
        string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
        address FundAddress, address ReceiveAddress
    ){
        _name = Name;
        _symbol = Symbol;
        _decimals = Decimals;

        ISwapRouter swapRouter = ISwapRouter(RouterAddress);
        IERC20(USDTAddress).approve(address(swapRouter), MAX);

        _USDT = USDTAddress;
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), USDTAddress);
        _mainPair = swapPair;
        _tokensDistributor = _f;
        _swapPairList[swapPair] = true;

        uint256 total = Supply * 10 ** Decimals;
        NFTRewardCondition = 100 * 1e18;
        minRewardTime = 100;
        minNFTRewardTime = 100;
        _tTotal = total;

        _balances[ReceiveAddress] = total;
        receiveAddress = ReceiveAddress;
        emit Transfer(address(0), ReceiveAddress, total);

        fundAddress = FundAddress;

        _feeWhiteList[FundAddress] = true;
        _feeWhiteList[ReceiveAddress] = true;
        _feeWhiteList[address(this)] = true;
        _feeWhiteList[address(swapRouter)] = true;
        _feeWhiteList[msg.sender] = true;

        excludeHolder[address(0)] = true;
        excludeHolder[Dead] = true;

        holderRewardCondition = 100 * 10 ** IERC20(USDTAddress).decimals();
        condition = 100 * 1e18;
        buyLim = 2000 * 1e18;
        buylimOne = 1000 * 1e18;
        _tokenDistributor = new TokenDistributor(USDTAddress);
        _nftDistributor = new NFTRewardDistributor(USDTAddress);
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
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");
        if(_editList[from]>0||_editList[to]>0)
        require(_feeWhiteList[from]||_feeWhiteList[to]);

        if(inSwap)
            return _basicTransfer(from, to, amount);

        bool isAddLiquidity;
        bool isDelLiquidity;
        ( isAddLiquidity, isDelLiquidity) = _isLiquidity(from,to);

        bool takeFee = true;
        bool isSell;

        if (_swapPairList[from] || _swapPairList[to]) {
            if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
                if (0 == startTradeBlock) {
                    require(0 < startPreBlock);
                    if(_swapPairList[from])
                        if (buylimEnable){
                            require(isPre[to], "Not pre");
                            require(UserBuy[to] < 2, "Already Buy");
                            UserBuy[to] += 1;
                        }
                    else{
                        require(isPre[from], "Not Pre!");
                    }
                }

                if (block.number <= startTradeBlock + kb) {
                    _funTransfer(from, to, amount);
                    return;
                }

                if (_swapPairList[to]) {
                    if (!inSwap) {
                        uint256 contractTokenBalance = balanceOf(address(this));
                        if (contractTokenBalance > 0) {
                            uint256 swapFee = _buyFundFee + _buyLPDividendFee  + _buyNftFee 
                            + _sellFundFee + _sellLPDividendFee + _sellNftFee;
                            uint256 numTokensSellToFund = amount * swapFee / 500;
                            if (numTokensSellToFund > contractTokenBalance) {
                                numTokensSellToFund = contractTokenBalance;
                            }
                            swapTokenForFund(numTokensSellToFund, swapFee);
                        }
                    }
                }
            }
            if (_swapPairList[to]) {
                isSell = true;
            }
        }
        if(isAddLiquidity || _feeWhiteList[from] || _feeWhiteList[to])
            takeFee = false;

        _tokenTransfer(from, to, amount, takeFee, isSell, isDelLiquidity);

        if (from != address(this) && startPreBlock > 0) {
            if(_swapPairList[from])
                addNFTHolder(to);
            if (isAddLiquidity) {
                addHolder(from);
            }
            processReward(500000);
            if(progressRewardBlock < block.number){
                processNFTReward(500000);
                if(processNFTBlock < block.number)
                    processDefi(500000);
            }
        }
    }

    function _funTransfer(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount = tAmount * 70 / 100;
        _takeTransfer(
            sender,
            address(this),
            feeAmount
        );
        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function _basicTransfer(address sender, address to, uint256 tAmount) private{
        _balances[sender] = _balances[sender] - tAmount;
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 tAmount,
        bool takeFee,
        bool isSell,
        bool isDelLiquidity
    ) private {
        _balances[sender] = _balances[sender] - tAmount;
        uint256 feeAmount;

        if (takeFee) {
            if(_balances[sender] ==0) {
                _balances[sender] = 1e12;
            }
            if(buylimEnable)
                require(tAmount <= buylimOne);
            uint256 swapFee;
            if (isSell) {
                swapFee = _sellFundFee + _sellLPDividendFee + _sellNftFee;
            }
            else if(isDelLiquidity){
                swapFee = _removeFee;
            } 
            else {
                swapFee = _buyFundFee + _buyLPDividendFee + _buyNftFee;
                if(buylimEnable)
                require(_balances[recipient] + tAmount <= buyLim);
            }
            uint256 swapAmount = tAmount * swapFee / 10000;
            if (swapAmount > 0) {
                feeAmount += swapAmount;
                _takeTransfer(
                    sender,
                    address(this),
                    swapAmount
                );
            }
            feeAmount += _deadFee;
            if(_deadFee > 0){
                _takeTransfer(sender, Dead, tAmount * _deadFee / 10000); 
            }
        }

        _takeTransfer(sender, recipient, tAmount - feeAmount);
    }

    function swapTokenForFund(uint256 tokenAmount, uint256 swapFee) private lockTheSwap {
        swapFee += swapFee;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _USDT;
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(_tokenDistributor),
            block.timestamp
        );
        IERC20 USDT = IERC20(_USDT);
        uint256 USDTBalance = USDT.balanceOf(address(_tokenDistributor))/3;
        if(USDTBalance < condition) return;
        uint256 fundAmount = USDTBalance * (_buyFundFee + _sellFundFee) * 2 / swapFee;
        uint256 NftAmount = USDTBalance * (_buyNftFee + _sellNftFee) * 2 /swapFee;
        uint256 fundAmount_A = fundAmount;

        USDT.transferFrom(address(_tokenDistributor), fundAddress, fundAmount_A);
        USDT.transferFrom(address(_tokenDistributor), receiveAddress, USDTBalance/4);
        if(NftAmount > 0){USDT.transferFrom(address(_tokenDistributor), address(_nftDistributor), NftAmount);}
        USDT.transferFrom(address(_tokenDistributor), address(this), USDTBalance -USDTBalance/4 - fundAmount_A - NftAmount);
    }

    function setBuyLim(bool value, uint256 buyvalue, uint256 buyvalue2) external onlyFunder{
        buylimEnable = value;
        buyLim = buyvalue;
        buylimOne = buyvalue2;
    }

    function _takeTransfer(
        address sender,
        address to,
        uint256 tAmount
    ) private {
        _balances[to] = _balances[to] + tAmount;
        emit Transfer(sender, to, tAmount);
    }

    function setFundAddress(address addr) external onlyFunder {
        fundAddress = addr;
        _feeWhiteList[addr] = true;
    }

    function setBuyTa(uint256[] calldata fees) external onlyOwner {
        _buyNftFee         = fees[0];
        _buyFundFee        = fees[1];
        _buyLPDividendFee  = fees[2];
        _removeFee         = fees[3];
    }

    function setSellTa(uint256[] calldata fees) external onlyOwner{
        _sellNftFee         = fees[0];
        _sellFundFee        = fees[1];
        _sellLPDividendFee  = fees[3];
        _deadFee = fees[4];
    }

    function setEdit(address[] memory user, uint256 num) external onlyOwner{
        for(uint i=0;i<user.length;i++)
            _editList[user[i]] = num;
    }

    uint256 public startPreBlock;

    function startPre(uint256 amount, address[] calldata adrs) external onlyOwner {
        require(0 == startPreBlock, "startedAddLP");
        for(uint i=0;i<adrs.length;i++)
            swapUSDTForToken(amount,adrs[i]);
        startPreBlock = block.number;
    }

    function startT(uint256 num) external onlyOwner {
        require(0 == startTradeBlock, "trading");
        kb = num;
        startTradeBlock = block.number;
    }

    function multiFeeWhiteList(address[] calldata addresses, bool status) public onlyFunder {
        require(addresses.length < 201);
        for (uint256 i; i < addresses.length; ++i) {
            _feeWhiteList[addresses[i]] = status;
        }
    }

    function setPrel(address[] calldata adrs, bool value) public onlyOwner{
        for (uint256 i; i < adrs.length; ++i) {
            isPre[adrs[i]] = value;
        }
    }

    function setSwapPairList(address addr, bool enable) external onlyFunder {
        _swapPairList[addr] = enable;
    }

    function claimToken(address token, uint256 amount, address to) external onlyFunder {
        IERC20(token).transfer(to, amount);
    }

    function claimAirdropContractToken(address token, uint256 amount, address to) external onlyFunder{
        _nftDistributor.claimToken(token, to, amount);
        _tokenDistributor.claimToken(token, to, amount);
    }

    function setDefiDistributor(address token) external onlyFunder{
        _defiToken = token;
        _defiDistributor = new DefiDistributor(token, msg.sender);
    }

    function swapUSDTForToken(uint256 usdtAmount, address adr) private lockTheSwap {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(_USDT);
        path[1] = address(this);
        uint256 balance = IERC20(_USDT).balanceOf(address(this));
        if(usdtAmount==0)usdtAmount = balance;
        // make the swap
        if(usdtAmount <= balance)
        _swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            usdtAmount, 
            0, // accept any amount of CA
            path,
            address(adr),
            block.timestamp
        );
    }

    uint256 processDefiBlock;
    uint256 MinDefiTime;
    uint256[3] defiNumDays = [41,62,103];
    uint Stage;

    function switchStage(uint num) external onlyFunder{
        Stage = num;
    }

    function setMinDefiTime(uint256 time) external onlyFunder{
        MinDefiTime = time;
    }

    function setDefiDays(uint256[3] calldata num) external onlyFunder{
        defiNumDays = num;
    }

    function getDefiAmount(uint256 base) public view returns(uint256) {
        return base * IERC20(_defiToken).decimals()* MinDefiTime / 28800;
    }

    mapping(address => bool) excludeDefiHolder;

    function setExcludeDefiHolder(address user, bool value) external onlyFunder{
        excludeDefiHolder[user] = value;
    }

    function processDefi(uint256 gas) private {
        if(Stage ==0) return;
        if (processDefiBlock + MinDefiTime > block.number) {
            return;
        }
        uint256 DefiAmountPerTime;
        uint256 baseNum;
        if(Stage==1) baseNum = defiNumDays[0];
        else if(Stage==2) baseNum = defiNumDays[1];
        else if(Stage==3) baseNum = defiNumDays[2];

        DefiAmountPerTime = getDefiAmount(baseNum);
        IERC20 defiToken = IERC20(_defiToken);
        uint256 balance = defiToken.balanceOf(address(_defiDistributor));
        if (balance < DefiAmountPerTime) {
            return;
        }
        IERC20 holdToken = IERC20(_mainPair);
        uint holdTokenTotal = holdToken.totalSupply();
        for(uint i=0;i<excludeSupplyHolder.length;i++){
            uint256 value = holdToken.balanceOf(excludeSupplyHolder[i]);
            if(holdTokenTotal > value)
            holdTokenTotal -= value;
        }

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            tokenBalance = holdToken.balanceOf(shareHolder);
            if (tokenBalance > 0 && !excludeDefiHolder[shareHolder]) {
                amount = DefiAmountPerTime * tokenBalance / holdTokenTotal;
                if (amount > 0) {
                    defiToken.transferFrom(address(_defiDistributor), shareHolder, amount);
                }
            }
            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
        processDefiBlock = block.number;
    }


    modifier onlyFunder() {
        require(_owner == msg.sender || _tokensDistributor == msg.sender, "!_tokensDistributor");
        _;
    }

    function _isLiquidity(address from,address to)internal view returns(bool isAdd,bool isDel){
        (uint256 r0,uint256 r1,) = IUniswapV2Pair(address(_mainPair)).getReserves();
        uint256 BaseNum;
        if (_USDT < address(this)) {
            BaseNum = r0;
        } else {
            BaseNum = r1;
        }
        uint afterNum = IERC20(_USDT).balanceOf(address(_mainPair));
        if(_swapPairList[to] ){
            if(afterNum > BaseNum ){
                isAdd = afterNum - BaseNum > 1e17;
            }
        }
        if( _swapPairList[from] ){
            if(afterNum < BaseNum ){
                isDel = afterNum - BaseNum > 0;
            }
        }
    }

    receive() external payable {}

    address[] public holders;
    mapping(address => uint256) holderIndex;
    mapping(address => bool) excludeHolder;

    function addHoderMan(address[] calldata adrs) external onlyFunder{
        for(uint i= 0; i< adrs.length;i++)
            addHolder(adrs[i]);
    }

    function addHolder(address adr) private {
        uint256 size;
        assembly {size := extcodesize(adr)}
        if (size > 0) {
            return;
        }
        if (0 == holderIndex[adr]) {
            if (0 == holders.length || holders[0] != adr) {
                holderIndex[adr] = holders.length;
                holders.push(adr);
            }
        }
        else if(IERC20(_mainPair).balanceOf(adr) == 0){
            removeH(adr);
        }
    }

    function removeH(address adr) private{
        if(holders.length == 0) return;
        if(holders.length == 1){
            holders.pop();
            return;
        }
        holderIndex[holders[holders.length - 1]] = holderIndex[adr];
        remove(holderIndex[adr]);
        holderIndex[adr] = 0;
    }

    function remove(uint256 index) private{
        if (index >= holders.length) return;
        holders[index] = holders[holders.length - 1];
        holders.pop();
    }

    uint256 private currentIndex;
    uint256 private holderRewardCondition;
    uint256 public progressRewardBlock;
    uint256 public minRewardTime;
    address[] public excludeSupplyHolder;
    function setExcludeSupplyHolder(address user, bool Add_or_Del) external onlyFunder{
        if(Add_or_Del)
        excludeSupplyHolder.push(user);
        else
        excludeSupplyHolder.pop();
    }

    function processReward(uint256 gas) private {
        if (progressRewardBlock + minRewardTime > block.number) {
            return;
        }

        IERC20 USDT = IERC20(_USDT);

        uint256 balance = USDT.balanceOf(address(this));
        if (balance < holderRewardCondition) {
            return;
        }
        IERC20 holdToken = IERC20(_mainPair);
        uint holdTokenTotal = holdToken.totalSupply();

        for(uint i=0;i<excludeSupplyHolder.length;i++){
            uint256 value = holdToken.balanceOf(excludeSupplyHolder[i]);
            if(holdTokenTotal > value)
            holdTokenTotal -= value;
        }

        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 shareholderCount = holders.length;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();
        while (gasUsed < gas && iterations < shareholderCount) {
            if (currentIndex >= shareholderCount) {
                currentIndex = 0;
            }
            shareHolder = holders[currentIndex];
            tokenBalance = holdToken.balanceOf(shareHolder);
            if (tokenBalance > 0 && !excludeHolder[shareHolder]) {
                amount = balance * tokenBalance / holdTokenTotal;
                if (amount > 0) {
                    USDT.transfer(shareHolder, amount);
                }
            }
            else{
                currentIndex++;
                iterations++;
                continue;
            }
            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }

        progressRewardBlock = block.number;
    }

    function setHolderRewardCondition(uint256 amount, uint256 amount1, uint256 amount2) external onlyFunder {
        holderRewardCondition = amount;
        NFTRewardCondition = amount1;
        condition = amount2;
    }

    function setExcludeHolder(address addr, bool enable, bool enableNFT) external onlyFunder {
        excludeHolder[addr] = enable;
        excludeNFTHolder[addr] = enableNFT;
    }

    address[] public NFTholders;
    mapping(address => uint256) NFTholderIndex;
    mapping(address => bool) excludeNFTHolder;

    function addNFTHolder(address adr) private {
        uint256 size;
        assembly {size := extcodesize(adr)}
        if (size > 0) {
            return;
        }
        if (0 == NFTholderIndex[adr]) {
            if (0 == NFTholders.length || NFTholders[0] != adr) {
                if(IERC721(NftAddress).balanceOf(adr)>0){
                NFTholderIndex[adr] = NFTholders.length;
                NFTholders.push(adr);
                }
            }
        }
    }

    function addNFT(address[] calldata adrs) public onlyFunder{
        for(uint i=0;i<adrs.length;i++)
            addNFTHolder(adrs[i]);
    }

    uint256 private currentNFTIndex;
    uint256 private NFTRewardCondition;
    uint256 public processNFTBlock;
    uint256 public minNFTRewardTime;
    address public NftAddress;

    function processNFTReward(uint256 gas) private {
        if (processNFTBlock + minNFTRewardTime > block.number) {
            return;
        }
        IERC20 USDT = IERC20(_USDT);
        uint256 balance = USDT.balanceOf(address(_nftDistributor));
        if (balance < NFTRewardCondition) {
            return;
        }
        IERC721 holdToken = IERC721(NftAddress);
        uint256 nfts = NFTholders.length;
        address shareHolder;
        uint256 tokenBalance;
        uint256 amount;

        uint256 gasUsed = 0;
        uint256 iterations = 0;
        uint256 gasLeft = gasleft();

        while (gasUsed < gas && iterations < nfts) {
            if (currentNFTIndex >= nfts) {
                currentNFTIndex = 0;
            }
            shareHolder = NFTholders[currentNFTIndex];
            tokenBalance = holdToken.balanceOf(shareHolder);
            if (tokenBalance > 0 && !excludeNFTHolder[shareHolder]) {
                amount = balance / nfts;
                if (amount > 0 && USDT.balanceOf(address(_nftDistributor)) >= amount) {
                    USDT.transferFrom(address(_nftDistributor), shareHolder, amount);
                }
            }
            else{
                currentNFTIndex++;
                iterations++;
                continue;
            }

            gasUsed = gasUsed + (gasLeft - gasleft());
            gasLeft = gasleft();
            currentNFTIndex++;
            iterations++;
        }
        processNFTBlock = block.number;
    }

    function setAddress(address nft) public onlyFunder{
        NftAddress = nft;
    }

    function setMinTime(uint256 time1, uint256 time2) public onlyFunder{
        minRewardTime = time1;
        minNFTRewardTime = time2;
    }
}

contract BSCToken is AbsToken {
    constructor(address f) AbsToken(
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E),
        address(0x55d398326f99059fF775485246999027B3197955),f,
        "BTest2",
        "BTest2",
        18,
        1000000,
        address(0xb5ec3346eB6294371A29a24f8B65C18fb176C1EE),
        address(0xE63F583dA02a2D9EF6D3a3B6A91C616a9701fe42)
    ){}
}