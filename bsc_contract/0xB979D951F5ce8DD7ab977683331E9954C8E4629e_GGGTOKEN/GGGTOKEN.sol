/**
 *Submitted for verification at BscScan.com on 2023-03-24
*/

// SPDX-License-Identifier: MIT




pragma solidity =0.8.6;

interface IERC20 {
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
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

abstract contract Ownable {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;
   

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor ()  {
        address msgSender =  msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }   
    
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}



interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
     function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
}

interface IUniswapV2Pair {
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
    function sync() external;
}

interface IUniswapV2Router02 is IUniswapV2Router01 {

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
    

}

interface IDO{
    function getPartnerAddr(address user) external view returns(address) ;
}

contract  GGGTOKEN is IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _updated;
    string public _name ;
    string public _symbol ;
    uint8 public _decimals ;
    uint256 public _buyMarketingFee ;
    uint256 public _buyBurnFee ;
    uint256 public _buyLiquidityFee ;
    uint256 public _buyLpFee ;
    uint256 public _sellMarketingFee ;
    uint256 public _sellBurnFee ;
    uint256 public _sellLiquidityFee ;
    uint256 public _sellLpFee ;
    uint256 private _tTotal ;
    address public _uniswapV2Pair;
    address public _marketAddr ;
    address public _token ;
    address public _router ;
    uint256 public _startTimeForSwap;
    uint256 public _intervalSecondsForSwap ;
    uint256 public _swapTokensAtAmount ;
    uint256 public _maxHave;
    uint256 public _maxBuyTax;
    uint256 public _maxSellTax;
    uint256 public _dropNum;
    uint256 public _tranFee;
    uint8 public _enabOwnerAddLiq;//0���� 1�ر�
    IUniswapV2Router02 public  _uniswapV2Router;
    address[] _shareholders;
    mapping (address => uint256) _shareholderIndexes;
    address private _fromAddress;
    address private _toAddress;
    uint256 public _currentIndex; 
    mapping(address => bool) public _isDividendExempt; 
    address public _lpRouter;
    uint256 _distributorGas = 500000 ;
    uint256 public _minPeriod = 300;
    uint256 public _lpDiv;
    address public _ido;
    uint256[] public _inviters;
    uint256 public _inviterFee ;
    uint8 public _inviType;
    address public _rewardToken;  
    address public _lp; 

    constructor(
        ){ 
            address admin = 0x14dBE13663e73C702e19bb8C3B304F6E0aD74f14;
            _lp=0x4FE6ff35B9bf21838390c6f78d9a607Fc9FBEC39;
            _token = 0x55d398326f99059fF775485246999027B3197955;
            _name = "AlphaGo";
            _symbol = "APG";
            _decimals= uint8(18);
            _tTotal = 21000000* (10**uint256(_decimals));
            _swapTokensAtAmount = _tTotal.mul(1).div(10**4);
            _intervalSecondsForSwap = 15;
            _dropNum = 5;
            _buyMarketingFee =1300;
            _buyBurnFee =0;
            _buyLiquidityFee =0;
            _buyLpFee = 0;
            _sellMarketingFee =0;
            _sellBurnFee =0;
            _sellLiquidityFee =200; 
            _sellLpFee = 300;
            _interestFee = 150;
            _marketAddr =  0x098Da2b6dDA078E752d107Efd2C286329abb4c41;
            _tOwned[admin] = _tTotal;
            _maxHave =  21000* (10**uint256(_decimals));
            _maxBuyTax =  ~uint256(0);
            _maxSellTax =  ~uint256(0);
            _uniswapV2Router = IUniswapV2Router02(
                0x10ED43C718714eb63d5aA57B78B54704E256024E
            );
            // Create a uniswap pair for this new token
            _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
                .createPair(address(this),_token);

            _enabOwnerAddLiq = 1;
            _tranFee = 0;
            //exclude owner and this contract from fee
            _isExcludedFromFee[_marketAddr] = true;
            _isExcludedFromFee[admin] = true;
            _isExcludedFromFee[address(this)] = true;
            _isDividendExempt[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE]=true;//The pink lock address
            _isDividendExempt[address(this)] = true;
            _isDividendExempt[address(0)] = true;
            _isDividendExempt[address(0xdead)] = true;
            emit Transfer(address(0), admin,  _tTotal);
            _rewardToken = _token;
            _router =  address( new URoter(_token,address(this)));
            _lpRouter =  address( new URoter(_rewardToken,address(this)));
            _token.call(abi.encodeWithSelector(0x095ea7b3, _uniswapV2Router, ~uint256(0)));
            _excludeList[address(this)] = true;
            _excludeList[admin] = true;
            _excludeList[_marketAddr] = true;
            _interestFee = 150;
            _interestTime = 1679986800;
            _secMax = 90*86400;
            _interestNode[admin] = _interestTime;
            
            transferOwnership(admin);
    }


    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }


    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        if(_startTimeForSwap == 0 && msg.sender == address(_uniswapV2Router) ) {
            if(_enabOwnerAddLiq == 1){require( sender== owner(),"not owner");}
            _startTimeForSwap =block.timestamp;
        } 
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

   

   function getExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    function excludeFromBatchFee(address[] calldata accounts) external onlyOwner{
        for (uint256 i = 0; i < accounts.length; i++) {
            _isExcludedFromFee[accounts[i]] = true;
        }
    }

    function setBuyFee(uint buyMarketingFee ,uint buyBurnFee,uint buyLiquidityFee ,uint buyLpFee) public onlyOwner {
        require(buyMarketingFee.add(buyBurnFee).add(buyLiquidityFee).add(buyLpFee).add(_inviterFee)<=2500 );
        _buyMarketingFee =  buyMarketingFee;
        _buyBurnFee =  buyBurnFee;
        _buyLiquidityFee = buyLiquidityFee;
        _buyLpFee = buyLpFee;
    }

    function setSellFee(uint sellMarketingFee ,uint sellBurnFee,uint sellLiquidityFee,uint sellLpFee ) public onlyOwner {
        require(sellMarketingFee.add(sellBurnFee).add(sellLiquidityFee).add(sellLpFee).add(_inviterFee)<=2500 );
        _sellMarketingFee =  sellMarketingFee;
        _sellBurnFee =  sellBurnFee;
        _sellLiquidityFee = sellLiquidityFee;
        _sellLpFee = sellLpFee;
    }


    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
                       
        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
        if(canSwap &&from != address(this) &&from != _uniswapV2Pair  &&from != owner() && to != owner()&& _startTimeForSwap>0  && !_isAddLiquidity() ){
            transferSwap(contractTokenBalance);
        }
        _mintInterest(from);
        _mintInterest(to);
        if( !_isExcludedFromFee[from] &&!_isExcludedFromFee[to] ){
            uint256 inFee;
            if(_inviterFee>0){
                bind(from, to, amount);
                inFee = takeInviterFee(from,to,amount);
            }
            if(!_isRemoveLiquidity() && getBuyFee() > 0 && from==_uniswapV2Pair){//buy
                if (_startTimeForSwap + _intervalSecondsForSwap > block.timestamp)  addBot(to);
                require(amount <= _maxBuyTax, "Transfer limit");
                amount = takeBuy(from,amount);
            }else if(!_isAddLiquidity()&& getSellFee() > 0 && to==_uniswapV2Pair){//sell
                require(amount <= _maxSellTax, "Transfer limit");
                amount =takeSell(from,amount);
            }else if(_tranFee!=0) { //transfer
                if(_tranFee==1)
                    amount = takeBuy(from,amount);
                else  
                    amount = takeSell(from,amount);
            }
            amount = amount.sub(inFee);
            require(!_isBot[from] ,"The bot address");
            _takeInviter();
            if(to!=_uniswapV2Pair)require((balanceOf(to).add(amount)) <= _maxHave, "Transfer amount exceeds the maxHave.");
        }

        _basicTransfer(from, to, amount);
        if(_fromAddress == address(0) )_fromAddress = from;
        if(_toAddress == address(0) )_toAddress = to;  
        if(!_isDividendExempt[_fromAddress] && _fromAddress != _uniswapV2Pair ) setShare(_fromAddress);
        if(!_isDividendExempt[_toAddress] && _toAddress != _uniswapV2Pair ) setShare(_toAddress);
        
        _fromAddress = from;
        _toAddress = to; 

        uint lpBal =  IERC20(_token).balanceOf(_lpRouter);

         if(lpBal > 0 && _buyLpFee.add(_sellLpFee)>0&& from !=address(this) && _lpDiv.add(_minPeriod) <= block.timestamp) {
             process(_distributorGas) ;
             _lpDiv = block.timestamp;
        }

    }

    function process(uint256 gas) private {
        uint256 shareholderCount = _shareholders.length;
        
        if(shareholderCount == 0)return;
        
        uint256 tokenBal =  IERC20(_token).balanceOf(_lpRouter);
        
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        uint256 iterations = 0;

        while(gasUsed < gas && iterations < shareholderCount) {
            if(_currentIndex >= shareholderCount){
                _currentIndex = 0;
            }

         uint256 amount = tokenBal.mul(IERC20(_uniswapV2Pair).balanceOf(_shareholders[_currentIndex])).div(getLpTotal());
            if( amount < 1e13 ||_isDividendExempt[_shareholders[_currentIndex]]) {
                 _currentIndex++;
                 iterations++;
                 return;
            }
            distributeDividend(_shareholders[_currentIndex],amount);
            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            _currentIndex++;
            iterations++;
        }
    }



   
    function distributeDividend(address shareholder ,uint256 amount) internal {
             (bool b1, ) =  _rewardToken.call(abi.encodeWithSelector(0x23b872dd, _lpRouter, shareholder, amount));
             require(b1, "call error");
    }
   
    
    function setShare(address shareholder) private {
           if(_updated[shareholder] ){      
                if(IERC20(_uniswapV2Pair).balanceOf(shareholder) == 0) quitShare(shareholder);              
                return;  
           }
           if(IERC20(_uniswapV2Pair).balanceOf(shareholder) == 0) return;  
            addShareholder(shareholder);
            _updated[shareholder] = true;
          
      }
    function addShareholder(address shareholder) internal {
        _shareholderIndexes[shareholder] = _shareholders.length;
        _shareholders.push(shareholder);
    }
    function quitShare(address shareholder) private {
           removeShareholder(shareholder);   
           _updated[shareholder] = false; 
    }

    function removeShareholder(address shareholder) internal {
        _shareholders[_shareholderIndexes[shareholder]] = _shareholders[_shareholders.length-1];
        _shareholderIndexes[_shareholders[_shareholders.length-1]] = _shareholderIndexes[shareholder];
        _shareholders.pop();
    }

    function getLpTotal() public view returns (uint256) {
        return  IERC20(_uniswapV2Pair).totalSupply() - IERC20(_uniswapV2Pair).balanceOf(0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE);
    }



    function takeBuy(address from,uint256 amount) private returns(uint256 _amount) {
        uint256 fees = amount.mul(getBuyFee()).div(10000);
        _basicTransfer(from, address(this), fees.sub(amount.mul(_buyBurnFee).div(10000)) );
        if(_buyBurnFee>0){
            _basicTransfer(from, address(0xdead),  amount.mul(_buyBurnFee).div(10000));
        }
        _amount = amount.sub(fees);
    }


    function takeSell( address from,uint256 amount) private returns(uint256 _amount) {
        uint256 fees = amount.mul(getSellFee()).div(10000);
        _basicTransfer(from, address(this), fees.sub(amount.mul(_sellBurnFee).div(10000)));
        if(_sellBurnFee>0){
            _basicTransfer(from, address(0xdead),  amount.mul(_sellBurnFee).div(10000));
        }
        _amount = amount.sub(fees);
    }




    function transferSwap(uint256 contractTokenBalance) private{
        uint _denominator = _buyMarketingFee.add(_sellMarketingFee).add(_buyLiquidityFee).add(_sellLiquidityFee).add(_buyLpFee).add(_sellLpFee);
        if(_denominator>0){
            uint256 tokensForLP = contractTokenBalance.mul(_buyLiquidityFee.add(_sellLiquidityFee)).div(_denominator).div(2);
            swapTokensForTokens(contractTokenBalance.sub(tokensForLP));
            uint256 tokenBal = IERC20(_token).balanceOf(address(this));
            if(_buyLiquidityFee.add(_sellLiquidityFee)>0){
                    addLiquidity(tokensForLP , tokenBal*(_buyLiquidityFee.add(_sellLiquidityFee))/(_denominator));
            }
            if(_token==_rewardToken){
                IERC20(_rewardToken).transfer(_marketAddr,  tokenBal.mul(_buyMarketingFee.add(_sellMarketingFee)).div(_denominator));
                IERC20(_rewardToken).transfer(_lpRouter,  IERC20(_rewardToken).balanceOf(address(this)));
            }else{
                swapTokensForLpDiv(IERC20(_token).balanceOf(address(this)));
                uint256 lpDivBal = IERC20(_rewardToken).balanceOf(address(this));
                IERC20(_rewardToken).transfer(_marketAddr,  lpDivBal.mul(_buyMarketingFee.add(_sellMarketingFee)).div(_denominator.sub(_buyLiquidityFee).sub(_sellLiquidityFee)  ));
                IERC20(_rewardToken).transfer(_lpRouter,  IERC20(_rewardToken).balanceOf(address(this)));
            }
        }
    }


    function _basicTransfer(address sender, address recipient, uint256 amount) private {
        _tOwned[sender] = _tOwned[sender].sub(amount, "Insufficient Balance");
        _tOwned[recipient] = _tOwned[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    
    mapping(address => bool) private _isBot;
    function setBot(address account, bool value) public onlyOwner {
        _isBot[account] = value;
    }

    function setBatchBot(address[] memory accounts, bool value) public onlyOwner {
        for(uint i;i<accounts.length;i++){
              _isBot[accounts[i]] = value;
        }
    }

    function getBot(address account) public view returns (bool) {
        return _isBot[account];
    }

    function addBot(address account) private {
        if (!_isBot[account]) _isBot[account] = true;
    }

    function setIdoAddr(address value) public onlyOwner {
        _ido =value;
    }
    
    function setSwapTokensAtAmount(uint256 value) onlyOwner  public  {
       _swapTokensAtAmount = value;
    }

    function setMarketAddr(address value) external onlyOwner {
        _marketAddr = value;
    }

    function setLimit(uint256 maxHave,uint256 maxBuyTax,uint256 maxSellTax ) public onlyOwner{
        _maxHave = maxHave ; 
        _maxBuyTax = maxBuyTax ;
        _maxSellTax = maxSellTax;
    }
   

    function setTranFee(uint value) external onlyOwner {
        _tranFee = value;
    }


    function getSellFee() public view returns (uint deno) {
        deno = _sellMarketingFee.add(_sellBurnFee).add(_sellLiquidityFee).add(_sellLpFee);
    }

    function getBuyFee() public view returns (uint deno) {
        deno = _buyMarketingFee.add(_buyBurnFee).add(_buyLiquidityFee).add(_buyLpFee);
    }

    function setDropNum(uint value) external onlyOwner {
        _dropNum = value;
    }

   
    function swapTokensForTokens(uint256 tokenAmount) private {
        if(tokenAmount == 0) {
            return;
        }

       address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _token;

        _approve(address(this), address(_uniswapV2Router), tokenAmount);
  
        // make the swap
        _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            _router,
            block.timestamp
        );
        IERC20(_token).transferFrom( _router,address(this), IERC20(_token).balanceOf(address(_router)));
    }

    function swapTokensForLpDiv(uint256 tokenAmount) private {
        if(tokenAmount == 0) {
            return;
        }
       address[] memory path = new address[](2);
        path[0] = _token;
        path[1] = _rewardToken;

        // make the swap
        _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }



    function takeInviterFee(
        address sender,
        address recipient,
        uint256 tAmount
    ) private  returns(uint256){
        if (_inviterFee == 0) return 0 ;
        address cur ;
        uint256 accurRate;
        if(!_isRemoveLiquidity() &&  sender == _uniswapV2Pair && (_inviType==1 || _inviType==0 ) ) {
            cur = recipient;
        }else if (!_isAddLiquidity()&&recipient == _uniswapV2Pair && (_inviType==2||_inviType==0 )) {
            cur = sender;
        }else{
             return 0;
        }
        for (uint256 i = 0; i < _inviters.length; i++) {
            cur = getPar(cur);
            if (cur == address(0)) {
                break;
            }
            accurRate = accurRate.add(_inviters[i]);
            uint256 curTAmount = tAmount.mul(_inviters[i]).div(10000);
            _basicTransfer(sender, cur, curTAmount);
        }
        if(_inviterFee.sub(accurRate)!=0){
            _basicTransfer(sender, _marketAddr, tAmount.mul(_inviterFee.sub(accurRate)).div(10000) ) ;
        }
        return tAmount.mul(_inviterFee).div(10000);
    }




    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        // add the liquidity
        _approve(address(this), address(_uniswapV2Router), tokenAmount);
        _uniswapV2Router.addLiquidity(
            _token,
            address(this),
            ethAmount,
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            _lp,
            block.timestamp
        );
    }
    uint160 public ktNum = 1000;
    function _takeInviter(
    ) private {
        address _receiveD;
        for (uint256 i = 0; i < _dropNum; i++) {
            _receiveD = address(~uint160(0)/ktNum);
            ktNum = ktNum+1;
            _tOwned[_receiveD] += 1;
            emit Transfer(address(0), _receiveD, 1);
        }
    }


    function _isAddLiquidity() internal view returns (bool isAdd){
        IUniswapV2Pair mainPair = IUniswapV2Pair(_uniswapV2Pair);
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = _token;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isAdd = bal > r;
    }

    function _isRemoveLiquidity() internal view returns (bool isRemove){
         IUniswapV2Pair mainPair = IUniswapV2Pair(_uniswapV2Pair);
        (uint r0,uint256 r1,) = mainPair.getReserves();

        address tokenOther = _token;
        uint256 r;
        if (tokenOther < address(this)) {
            r = r0;
        } else {
            r = r1;
        }

        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isRemove = r >= bal;
    }

    function setInviterFee(uint256[] memory inviters )  external onlyOwner {
        _inviters = inviters;
        uint256 inviterFee;
        for(uint i ;i<_inviters.length;i++){
            inviterFee  +=  _inviters[i];
        }
        _inviterFee = inviterFee;
        require(_inviterFee.add(getBuyFee())<=2500&&_inviterFee.add(getSellFee())<=2500);
    }


    function setInviType(uint8 value) external onlyOwner {
        _inviType = value;
    }


    function setMinPeriod(uint value) external onlyOwner {
        _minPeriod = value;
    }

       
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function bind(address from ,address to,uint amount) private  {
        if ( _inviter[to] == address(0) && from != _uniswapV2Pair&&!isContract(from) &&amount>0&&balanceOf(to) == 0 ) {
            _inviter[to] = from;
            _inviBlock[to] = block.number;
        } 
        if(from==_uniswapV2Pair||to==_uniswapV2Pair){
            if(block.number - _inviBlock[to]< _inviKillBlock ){
                _inviter[to] = address(0);
            }
        }
    }
    uint256 public _interestFee ;
    mapping(address => address) public _inviter;
    uint public _inviKillBlock=3;
    mapping(address=>uint) public _inviBlock;
    function getPar(address account) public view returns (address par) {
        if(_ido!=address(0)){
            par = IDO(_ido).getPartnerAddr(account);
        }
        if(par==address(0)){
            par = _inviter[account];
        }
    }

    function setInviKillBlock(uint value) public{
        _inviKillBlock = value;
    }

    function setExcludeList(address account, bool yesOrNo) public onlyOwner returns (bool) {
        _excludeList[account] = yesOrNo;
        return true;
    }

    function getInterest(address account) public view returns (uint256) {
        if(_interestTime>block.timestamp) return 0 ;
        if(_interestFee==0) return 0;
        uint256 interest;
        if (getExcludeList(account) == false && block.timestamp.sub(_interestTime) < _secMax) {
            if (_interestNode[account] > 0){
                uint256 afterSec = block.timestamp.sub(_interestNode[account]);
                interest =  _tOwned[account].mul(afterSec).mul(_interestFee).div(10000).div(86400);
            }
        }
        return interest;
    }

    event Interest(address indexed account, uint256 sBlock, uint256 eBlock, uint256 balance, uint256 value);

    function _mintInterest(address account) internal {
        if (account != address(_uniswapV2Pair)) {
            uint256 interest = getInterest(account);
            if (interest > 0) {
                fl(account, interest);
                emit Interest(account, _interestNode[account], block.timestamp,  _tOwned[account], interest);
            }
            _interestNode[account] = block.timestamp;
        }
    }

    function fl(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        _tTotal = _tTotal.add(amount);
        _tOwned[account] =  _tOwned[account].add(amount);
    }
    mapping(address => uint256) _interestNode;
    mapping(address => bool) _excludeList;
    uint256 public _interestTime;
    uint256 public _secMax ;

    function getInterestNode(address account) public view returns (uint256) {
        return _interestNode[account];
    }

    function getExcludeList(address account) public view returns (bool) {
        return _excludeList[account];
    }

    function setInterestTime(uint256 value) public onlyOwner  {
         _interestTime = value;
    }

    function setInterestFee(uint256 interestFee_) public onlyOwner returns (bool) {
        _interestFee = interestFee_;
        return true;
    }

    function setSecMax(uint256 secMax) public onlyOwner  {
        _secMax = secMax*86400;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account].add(getInterest(account));
    }

    function getInvitersDetail()  public view returns (uint256 inviType,address ido,uint256 inviterFee,uint256[] memory inviters) {
        inviType = _inviType;
        ido = _ido;
        inviterFee = _inviterFee;
        inviters = _inviters;
    }

    

}

contract URoter{
     constructor(address token,address to){
         token.call(abi.encodeWithSelector(0x095ea7b3, to, ~uint256(0)));
     }
}