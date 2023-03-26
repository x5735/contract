/**
 *Submitted for verification at BscScan.com on 2023-03-25
*/

pragma solidity 0.5.16;

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }
    
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
    
}

interface IOneCoinPair{
    function admin() external view returns (address);
    function token() external view returns (address);
    function payToken() external view returns (address);
    
    function price() external view returns (uint);
    function priceRate() external view returns (uint);
    function getInfo() external view returns(uint initPrice, uint currPrice, uint priceSpace, uint decimals);
    function initialize(address tokenCon, address payTokenCon, uint initPrice, uint priceSpace) external;
    function setPrices(uint initPrice, uint currPrice, uint priceSpace) external;
    // function buyExactToken(uint amountOut, address to) external;
    function buyToken(address to, uint amountOut) external;
    // function sellExactPayToken(uint amountOutPay, address to) external;
    function sellToken(address to, uint endPrice) external;
    function getAmountInPayToken(uint amountOut) external view returns(uint amountInPay, uint endPrice);
    function getAmountOutPayToken(uint amountIn) external view returns(uint amountOutPay, uint endPrice);
    // function getAmountInToken(uint amountOutPay) external view returns(uint amountIn, uint endPrice);
    // function getAmountOutToken(uint amountInPay) external view returns(uint amountOut, uint endPrice);
    function reserves() external view returns (uint reserve, uint reservePay);
    // function skim(address to) external;
    function sync() external;
    function removeTokens(uint payTokenAmount, uint tokenAmount, address to) external;
}


contract OneCoinPair is IOneCoinPair{
    
    using SafeMath for uint;
    
    address private _admin;
    
    address private _token;
    address private _payToken;
    
    uint private _reserve;
    uint private _reservePay;
    
    uint private _price;
    
    uint private _priceRate;//10000 /10**18
    
    uint private _d;
    
    uint private _initPrice;
    
    constructor() public {
        _admin = msg.sender;
    }
    
    uint private unlocked = 1;
    
    modifier lock() {
        require(unlocked == 1, 'OneCoin: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }
    
    function initialize(address tokenCon, address payTokenCon, uint initPrice, uint priceSpace) external{
        require(msg.sender == _admin, 'OneCoin: FORBIDDEN'); // sufficient check
        _token = tokenCon;
        _payToken = payTokenCon;
        _price = initPrice;
        _priceRate = priceSpace;
        _d = IBEP20(tokenCon).decimals();
        _initPrice = initPrice;
        // _dp = IBEP20(payTokenCon).decimals();
    }
    
    function setPrices(uint initPrice, uint currPrice, uint priceSpace) external{
        require(msg.sender == _admin, 'OneCoin: FORBIDDEN'); // sufficient check
        _price = currPrice;
        _priceRate = priceSpace;
        _initPrice = initPrice;
    }
    
    function getAmountInPayToken(uint amountOut) public view returns(uint amountInPay, uint endPrice){
        endPrice = _price;
        if (amountOut >= 10 ** _d){
            uint n = amountOut / 10 ** _d;
            uint q = 10**_d * (_priceRate + 1) / _priceRate;
            uint qp = pow(q, _d, n);
        
            uint shang = endPrice * (qp - 10**_d);
            uint xia = q - 10**_d;
            endPrice = endPrice * qp / 10**_d;
            amountInPay = shang/ xia;
        }
        
        uint m = amountOut % 10 ** _d;
        
        if (m > 0){
            amountInPay += endPrice * m / 10 ** _d;
            endPrice += endPrice * m / _priceRate / 10 ** _d;
        }
    }
    
    function getAmountOutPayToken(uint amountIn) public view returns(uint amountOutPay, uint endPrice){
        endPrice = _price;
        if (amountIn >= 10 ** _d){
            uint n = amountIn / 10 ** _d;
            uint q = 10**_d * (_priceRate - 1) / _priceRate;
            uint qp = pow(q, _d, n);
        
            uint shang = endPrice * (10**_d - qp);
            uint xia = 10**_d - q;
            
            endPrice = endPrice * qp / 10**_d;
            amountOutPay = shang/ xia;
        }
        uint m = amountIn % 10 ** _d;
        if (m > 0){
            amountOutPay += endPrice * m / 10 ** _d;
            endPrice -= endPrice * m / _priceRate / 10 ** _d;
        }
    }
    
    function pow(uint n, uint d, uint p) internal pure returns(uint){
        uint q = 10**d;
        
        if (p % 2 > 0) q = q * n / 10 ** d;
        while(p > 1){
            n = n ** 2 / 10 ** d;
            p = p / 2;
            if (p % 2 > 0) q = q * n / 10 ** d;
        }
        return q;
    }
    
    // function getAmountInPayToken(uint amountOut) public view returns(uint amountInPay, uint endPrice){
    //     endPrice = _price.add(_priceRate.mul(amountOut).div(10**_d));
    //     amountInPay = _price.add(endPrice).mul(amountOut).div(2*10**_d);
    // }
    
    // function getAmountOutPayToken(uint amountIn) public view returns(uint amountOutPay, uint endPrice){
    //     endPrice = _price.sub(_priceRate.mul(amountIn).div(10**_d));
    //     amountOutPay = _price.add(endPrice).mul(amountIn).div(2*10**_d);
    // }
    
    // function getAmountInToken(uint amountOutPay) public view returns(uint amountIn, uint endPrice){
    //     uint y = (_price * 10**_d/_priceRate) **2 - amountOutPay * 2*10**_d * 10**_d/_priceRate;
    //     amountIn = _price * 10**_d/_priceRate - y.sqrt();
    //     endPrice = _price.sub(_priceRate.mul(amountIn).div(10**_d));
    // }
    
    // function getAmountOutToken(uint amountInPay) public view returns(uint amountOut, uint endPrice){
    //     uint y = amountInPay * 2 * 10**_d * 10**_d / _priceRate + (_price*10**_d/_priceRate)**2;
    //     amountOut = y.sqrt() - _price * 10**_d / _priceRate;
    //     endPrice = _price.add(_priceRate.mul(amountOut).div(10**_d));
    // }
    
    function buyToken(address to, uint amountOut) external lock {
        require(msg.sender == _admin,'OneCoin: FORBIDDEN');
        uint amountInPay = IBEP20(_payToken).balanceOf(address(this)) - _reservePay;
        require(amountInPay > 0, 'OneCoin: INPUTPAY_AMOUNT_ZERO');
        
        (uint aip, uint endPrice) = getAmountInPayToken(amountOut);
        
        require(amountInPay >= aip, 'OneCoin: INSUFFICIENT_INPUTPAY_AMOUNT');
        
        
        // (uint amountOut, uint endPrice) = getAmountOutToken(amountInPay);
        
        require(amountOut < _reserve, 'OneCoin: INSUFFICIENT_RESERVE');
        
        IBEP20(_token).transfer(to, amountOut);
        // _priceRate = endPrice.mul(_priceRate).div(_price);
        _price = endPrice;
        
        _update(IBEP20(_token).balanceOf(address(this)), IBEP20(_payToken).balanceOf(address(this)));
        
        
    }
    
    function sellToken(address to, uint endPrice) external lock{
        require(msg.sender == _admin,'OneCoin: FORBIDDEN');
        uint amountIn = IBEP20(_token).balanceOf(address(this)).sub(_reserve);
        require(amountIn > 0, 'OneCoin: INPUT_AMOUNT_ZERO');
        (uint amountOutPay,) = getAmountOutPayToken(amountIn);
        require(amountOutPay > 0, 'OneCoin: OUTPUT_AMOUNT_ZERO');
        require(amountOutPay < _reservePay, 'OneCoin: INSUFFICIENT_RESERVEPAY');
        require(endPrice > 0 && endPrice < _price, 'OneCoin: sell amount failed');
        IBEP20(_payToken).transfer(to, amountOutPay);
        // _priceRate = endPrice.mul(_priceRate).div(_price);
        _price = endPrice;
        _update(IBEP20(_token).balanceOf(address(this)), IBEP20(_payToken).balanceOf(address(this)));
    }
    
    function getInfo() external view returns(uint initPrice, uint currPrice, uint priceSpace, uint decimals){
        initPrice = _initPrice;
        currPrice = _price;
        priceSpace = _priceRate;
        decimals = _d;
    }
    
    function sync() external lock {
        _update(IBEP20(_token).balanceOf(address(this)), IBEP20(_payToken).balanceOf(address(this)));
    }
    
    function _update(uint newReserve, uint newReservePay) private{
        _reserve = newReserve;
        _reservePay = newReservePay;
    }
    function admin() external view returns (address){
        return _admin;
    }
    function token() external view returns (address){
        return _token;
    }
    function payToken() external view returns (address){
        return _payToken;
    }
    function price() external view returns (uint){
        return _price;
    }
    function priceRate() external view returns (uint){
        return _priceRate;
    }
    function reserves() external view returns (uint reserve, uint reservePay){
        reserve = _reserve;
        reservePay = _reservePay;
    }
    function removeTokens(uint payTokenAmount, uint tokenAmount, address to) external{
        require(msg.sender == _admin,'OneCoin: FORBIDDEN');
        if (tokenAmount > 0) IBEP20(_token).transfer(to, tokenAmount);
        if (payTokenAmount > 0) IBEP20(_payToken).transfer(to, payTokenAmount);
        _update(IBEP20(_token).balanceOf(address(this)), IBEP20(_payToken).balanceOf(address(this)));
    }
    
}

contract OneCoinAdmin{
    
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    
    event BuyToken(address indexed pair, address indexed account, uint256 inPayTokenAmount, uint256 outTokenAmount);
    event SellToken(address indexed pair, address indexed account, uint256 inTokenAmount, uint256 outPayTokenAmount);
    
    using SafeMath for uint;
    // address public feeTo;
    address public admin;
    // uint public feeAdmin;
    
    
    address private _blcToken = address(0x04841221FCa96b1d9fb4183941d63de2b9202CBF);

    // address private _toYX = address(0x5b30dF8B82A0dC21a6c9F2A9a83558c79B2Ba248);
    // address private _toJJ = address(0x509998A331a528E2F42B17638Ae4d6a636f06f0e);
    // address private _toJD = address(0xCA195a3e343e3Fdac93AdDDbd8Ec376807A2A0fE);
    // address private _toLP = address(0x092F5027806d8B0a597d5688D1A04Fa3252AC4B3);
    // address private _deadAddress = 0x000000000000000000000000000000000000dEaD;
    mapping(address => address) private _toYX;
    mapping(address => address) private _toJJ;
    mapping(address => address) private _toJD;
    mapping(address => address) private _toLP;
    address private _deadAddress = address(0x000000000000000000000000000000000000dEaD);
    
    // uint private _feeYX = 50;
    // uint private _feeJJ = 50;
    // uint private _feeJD = 100;
    // uint private _feeLP = 200;
    // uint private _feeDead = 200;
    mapping(address => uint) private _feeYX;
    mapping(address => uint) private _feeJJ;
    mapping(address => uint) private _feeJD;
    mapping(address => uint) private _feeLP;
    mapping(address => uint) private _feeDead;
    
    address private _toGas = address(0xAed7b55078F7E350f138876c0370C804Fc82eC54);
    // uint private _gas = 50;
    mapping(address => uint) private _gas;
    
    // uint private _minBlc = 210000*10**18;
    mapping(address => uint) private _minToken;
    
    mapping(address => mapping(address => address)) public getPair;
    // mapping(address => uint) private feeAll;
    mapping(address => address) private pairFeeAddress;
    
    mapping(address => mapping(address => uint)) private _lpPayToken;
    mapping(address => mapping(address => uint)) private _lpToken;
    mapping(address => uint) private _lpTotal;
    mapping(address => uint) private _totalLPReward;
    mapping(address => uint) private _unallocatedRewards;
    mapping(address => uint) private _rewardHeight;
    
    mapping(address => mapping(address => uint)) private _userHeight;
    
    address[] public allPairs;
    
    constructor() public {
        admin = msg.sender;
    }
    
    modifier isAdmin(){
        require(msg.sender == admin, 'OneCoin: FORBIDDEN');
        _;
    }
    
    function createPair(address payToken, address token, uint initPrice, uint priceSpace) external isAdmin returns (address pair) {
        require(token != payToken, 'OneCoin: IDENTICAL_ADDRESSES');
        require(token != address(0) && payToken != address(0), 'OneCoin: ZERO_ADDRESS');
        require(getPair[payToken][token] == address(0), 'OneCoin: PAIR_EXISTS');
        bytes memory bytecode = type(OneCoinPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token, payToken));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IOneCoinPair(pair).initialize(token, payToken, initPrice, priceSpace);
        
        getPair[payToken][token] = pair;
        allPairs.push(pair);
        
        _toYX[pair] = address(0x5b30dF8B82A0dC21a6c9F2A9a83558c79B2Ba248);
        _toJJ[pair] = address(0x509998A331a528E2F42B17638Ae4d6a636f06f0e);
        _toJD[pair] = address(0xCA195a3e343e3Fdac93AdDDbd8Ec376807A2A0fE);
        _toLP[pair] = address(0x092F5027806d8B0a597d5688D1A04Fa3252AC4B3);

        _feeYX[pair] = 50;
        _feeJJ[pair] = 50;
        _feeJD[pair] = 100;
        _feeLP[pair] = 200;
        _feeDead[pair] = 200;

        _minToken[pair] = 210000*10**18;
        _gas[pair] = 50;

        emit PairCreated(payToken, token, pair, allPairs.length);
    }
    
    function buyExactToken(address payToken, address token, uint amountInPayMax, uint amountOut, address to) external {
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        IOneCoinPair pair = IOneCoinPair(pairAddress);
        
        (uint amountInPay, uint endPrice) = pair.getAmountInPayToken(amountOut);
        
        require(endPrice > 0, 'OneCoin: INVALID_AMOUNT');
        
        if(payToken != _blcToken && token != _blcToken && _toGas != address(0) && _gas[pairAddress] > 0){
            (, uint currPrice, , uint decimals) = IOneCoinPair(getPair[payToken][_blcToken]).getInfo();
            uint feeGas = amountInPay.mul(10**decimals).mul(_gas[pairAddress]).div(currPrice).div(10000);
            IBEP20(_blcToken).transferFrom(msg.sender, _toGas, feeGas);
        }
        
        uint feeAmount = 0;

        uint feeAll = _feeYX[pairAddress].add(_feeJJ[pairAddress]).add(_feeJD[pairAddress]).add(_feeLP[pairAddress]);

        // if (token != _blcToken || IBEP20(token).totalSupply() > _minBlc + IBEP20(token).balanceOf(_deadAddress)){
        //     feeAll = feeAll.add(_feeDead[pairAddress]);
        // }
        if (IBEP20(token).totalSupply() > _minToken[pairAddress] + IBEP20(token).balanceOf(_deadAddress)){
            feeAll = feeAll.add(_feeDead[pairAddress]);
        }
        if (feeAll > 0) feeAmount = amountOut.mul(feeAll).div(10000);
        
        require(
            amountInPay <= amountInPayMax,
            'EXCESSIVE_INPUT_AMOUNT'
        );
        
        IBEP20(payToken).transferFrom(msg.sender, pairAddress, amountInPay);
        pair.buyToken(address(this), amountOut);
        IBEP20(token).transfer(to, amountOut.sub(feeAmount));
        
        // if (feeAdminAmount > 0) IBEP20(token).transfer(feeTo, feeAdminAmount);
        
        if (_feeYX[pairAddress] > 0) IBEP20(token).transfer(_toYX[pairAddress], feeAmount.mul(_feeYX[pairAddress]).div(feeAll));
        if (_feeJJ[pairAddress] > 0) IBEP20(token).transfer(_toJJ[pairAddress], feeAmount.mul(_feeJJ[pairAddress]).div(feeAll));
        if (_feeLP[pairAddress] > 0) {
            uint before = IBEP20(token).balanceOf(_toLP[pairAddress]);
            IBEP20(token).transfer(_toLP[pairAddress], feeAmount.mul(_feeLP[pairAddress]).div(feeAll));
            uint newLPReward = IBEP20(token).balanceOf(_toLP[pairAddress]).sub(before)*10**18;
            require(newLPReward > 0, 'OneCoin: LP_REWARD_FAIL');
            _totalLPReward[pairAddress] = _totalLPReward[pairAddress].add(newLPReward);
            _unallocatedRewards[pairAddress] = _unallocatedRewards[pairAddress].add(newLPReward);
            if (_lpTotal[pairAddress] > 0 && _unallocatedRewards[pairAddress] >= _lpTotal[pairAddress]){
                _rewardHeight[pairAddress] = _rewardHeight[pairAddress].add(_unallocatedRewards[pairAddress].div(_lpTotal[pairAddress]));
                _unallocatedRewards[pairAddress] = _unallocatedRewards[pairAddress] % _lpTotal[pairAddress];
            }
            
        }
        if (_feeJD[pairAddress] > 0) IBEP20(token).transfer(_toJD[pairAddress], feeAmount.mul(_feeJD[pairAddress]).div(feeAll));
        if (_feeDead[pairAddress] > 0) IBEP20(token).transfer(_deadAddress, feeAmount.mul(_feeDead[pairAddress]).div(feeAll));
        
        emit BuyToken(pairAddress, msg.sender, amountInPay, amountOut);
        // if (feeAmount > 0) IBEP20(token).transferFrom(msg.sender, pairFeeAddress[pairAddress], feeAmount);
        
    }
    
    //δ���� �ܽ��� 
    function unallocatedRewards(address payToken, address token) external view returns(uint){
        return _unallocatedRewards[getPair[payToken][token]].div(10**18);
    }
    // �ܽ��� 
    function totalLPReward(address payToken, address token) external view returns(uint){
        return _totalLPReward[getPair[payToken][token]].div(10**18);
    }
    //��lp
    function lpTotal(address payToken, address token) external view returns(uint){
        return _lpTotal[getPair[payToken][token]];
    }
    //�û� ����ȡ 
    function userUnclaimedReward(address payToken, address token) external view returns(uint){
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        if (_rewardHeight[pairAddress] > 0){
            return _rewardHeight[pairAddress].sub(_userHeight[pairAddress][msg.sender]).mul(_lpPayToken[pairAddress][msg.sender]).div(10**18);
        }
        return 0;
    }
    //��ȡ 
    function receiveLPReward(address payToken, address token, address to) external {
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _receiveLPReward(pairAddress, token, to);
    }
    
    function _receiveLPReward(address pairAddress, address token, address to) internal {
        if (_rewardHeight[pairAddress] > 0){
            uint reward = _rewardHeight[pairAddress].sub(_userHeight[pairAddress][msg.sender]).mul(_lpPayToken[pairAddress][msg.sender]).div(10**18);
            if(reward > 0){
                IBEP20(token).transferFrom(_toLP[pairAddress], to,reward);
                _rewardLog[pairAddress][msg.sender] = _rewardLog[pairAddress][msg.sender].add(reward);
            } 
        }
        _userHeight[pairAddress][msg.sender] = _rewardHeight[pairAddress];
    }
    
    mapping(address => mapping(address => uint)) private _rewardLog;
    
    function rewardLog(address payToken, address token, address account) external view returns(uint){
        address pairAddress = getPair[payToken][token];
        if (pairAddress == address(0)) return 0;
        return _rewardLog[pairAddress][account];
    }
    
    function sellExactToken(address payToken, address token, uint amountIn, uint amountOutPayMin, address to) external {
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        IOneCoinPair pair = IOneCoinPair(pairAddress);
        
        (uint amountOutPay,uint endPrice) = pair.getAmountOutPayToken(amountIn);
        
        if(payToken != _blcToken && token != _blcToken && _toGas != address(0) && _gas[pairAddress] > 0){
            (, uint cp, , uint d1) = pair.getInfo();
            (, uint currPrice, , uint decimals) = IOneCoinPair(getPair[payToken][_blcToken]).getInfo();
            uint feeGas = amountIn * cp * _gas[pairAddress] * 10**decimals/(10**d1 * currPrice * 10000);
            IBEP20(_blcToken).transferFrom(msg.sender, _toGas, feeGas);
        }
        
        uint feeAmount = 0;
        uint feeAll = _feeYX[pairAddress].add(_feeJJ[pairAddress]).add(_feeJD[pairAddress]).add(_feeLP[pairAddress]);
        if (IBEP20(token).totalSupply() > _minToken[pairAddress] + IBEP20(token).balanceOf(_deadAddress)){
            feeAll = feeAll.add(_feeDead[pairAddress]);
        }
        if (feeAll > 0) feeAmount = amountIn.mul(feeAll).div(10000);
        if (_feeYX[pairAddress] > 0) IBEP20(token).transferFrom(msg.sender, _toYX[pairAddress], feeAmount.mul(_feeYX[pairAddress]).div(feeAll));
        if (_feeJJ[pairAddress] > 0) IBEP20(token).transferFrom(msg.sender, _toJJ[pairAddress], feeAmount.mul(_feeJJ[pairAddress]).div(feeAll));
        if (_feeJD[pairAddress] > 0) IBEP20(token).transferFrom(msg.sender, _toJD[pairAddress], feeAmount.mul(_feeJD[pairAddress]).div(feeAll));
        // if (_feeLP > 0) IBEP20(token).transferFrom(msg.sender, _toLP, feeAmount.mul(_feeLP).div(feeAll));
        if (_feeLP[pairAddress] > 0) {
            uint before = IBEP20(token).balanceOf(_toLP[pairAddress]);
            IBEP20(token).transferFrom(msg.sender, _toLP[pairAddress], feeAmount.mul(_feeLP[pairAddress]).div(feeAll));
            uint newLPReward = IBEP20(token).balanceOf(_toLP[pairAddress]).sub(before)*10**18;
            require(newLPReward > 0, 'OneCoin: LP_REWARD_FAIL');
            _totalLPReward[pairAddress] = _totalLPReward[pairAddress].add(newLPReward);
            _unallocatedRewards[pairAddress] = _unallocatedRewards[pairAddress].add(newLPReward);
            if (_lpTotal[pairAddress] > 0 && _unallocatedRewards[pairAddress] >= _lpTotal[pairAddress]){
                _rewardHeight[pairAddress] = _rewardHeight[pairAddress].add(_unallocatedRewards[pairAddress].div(_lpTotal[pairAddress]));
                _unallocatedRewards[pairAddress] = _unallocatedRewards[pairAddress] % _lpTotal[pairAddress];
            }
        }
        if (_feeDead[pairAddress] > 0) IBEP20(token).transferFrom(msg.sender, _deadAddress, feeAmount.mul(_feeDead[pairAddress]).div(feeAll));
        
        IBEP20(token).transferFrom(msg.sender, pairAddress, amountIn.sub(feeAmount));
        
        uint balanceBefore = IBEP20(payToken).balanceOf(to);
        pair.sellToken(to, endPrice);
        // uint outPay = IBEP20(payToken).balanceOf(to).sub(balanceBefore);
        
        require(
            IBEP20(payToken).balanceOf(to).sub(balanceBefore) >= amountOutPayMin,
            'INSUFFICIENT_OUTPUT_AMOUNT'
        );
        emit SellToken(pairAddress, msg.sender, amountIn, amountOutPay);
    }
    
    function getPairFeeAddress(address payToken, address token) external view returns(address){
        return pairFeeAddress[getPair[payToken][token]];
    }
    
    function getPairFeeAddress(address pair) external view returns(address){
        return pairFeeAddress[pair];
    }
    
    function setPairFeeAddress(address pair, address feeAddress) external isAdmin returns(bool){
        require(pair != address(0), 'OneCoin: PAIR_ZERO_ADDRESS');
        pairFeeAddress[pair] = feeAddress;
        return true;
    }

    function setAdmin(address _admin) external isAdmin{
        admin = _admin;
    }
    
    function getPairInfo(address payToken, address token) 
    external view returns(uint initPrice, uint currPrice, uint priceSpace, uint decimals, uint fee, uint feePair,uint reserve, uint reservePay){
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        (initPrice, currPrice, priceSpace, decimals) = IOneCoinPair(pairAddress).getInfo();
        fee = _gas[pairAddress];
        feePair = 0;
        (reserve, reservePay) = IOneCoinPair(pairAddress).reserves();
    }
    
    function addTokens(address payToken, address token, uint amountPayToken, address to) external{
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _receiveLPReward(pairAddress, token, msg.sender);
        // uint price = IOneCoinPair(pairAddress).price();
        (, uint currPrice, , uint decimals) = IOneCoinPair(pairAddress).getInfo();
        uint amountToken = amountPayToken.mul(10**decimals).div(currPrice);
        
        uint payTokenBefore = IBEP20(payToken).balanceOf(pairAddress);
        uint tokenBefore = IBEP20(token).balanceOf(pairAddress);
        IBEP20(payToken).transferFrom(msg.sender, pairAddress, amountPayToken);
        IBEP20(token).transferFrom(msg.sender, pairAddress, amountToken);
        _lpPayToken[pairAddress][to] = _lpPayToken[pairAddress][to].add(IBEP20(payToken).balanceOf(pairAddress).sub(payTokenBefore));
        _lpToken[pairAddress][to] = _lpToken[pairAddress][to].add(IBEP20(token).balanceOf(pairAddress).sub(tokenBefore));
        _lpTotal[pairAddress] = _lpTotal[pairAddress].add(IBEP20(payToken).balanceOf(pairAddress).sub(payTokenBefore));
        _syncPair(pairAddress);
    }
    
    function setPairPrice(address payToken, address token, uint initPrice, uint currPrice, uint priceSpace) external isAdmin {
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        require(initPrice > 0, 'OneCoin: PRICE_INIT_ZERO');
        require(priceSpace > 0, 'OneCoin: PRICE_SPACE_ZERO');
        IOneCoinPair(pairAddress).setPrices(initPrice, currPrice, priceSpace);
        _syncPair(pairAddress);
    }
    
    function syncPair(address payToken, address token) external {
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _syncPair(pairAddress);
    }
    
    function _syncPair(address pair) internal {
        IOneCoinPair(pair).sync();
    }
    
    function removeTokensAdmin(address payToken, address token, uint payTokenAmount, uint tokenAmount, address to) external isAdmin{
        require(to != address(0), 'OneCoin: TO_ZERO_ADDRESS');
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        IOneCoinPair(pairAddress).removeTokens(payTokenAmount, tokenAmount, to);
    }
    
    function removeTokens(address payToken, address token, uint payTokenAmount, address to) external{
        require(to != address(0), 'OneCoin: TO_ZERO_ADDRESS');
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _receiveLPReward(pairAddress, token, msg.sender);
        
        uint payTokenTotal = _lpPayToken[pairAddress][msg.sender];
        uint tokenTotal = _lpToken[pairAddress][msg.sender];
        
        require(payTokenAmount <= payTokenTotal,'OneCoin:INSUFFICIENT_PAYTOKEN');
        
        uint amountToken = payTokenAmount.mul(tokenTotal).div(payTokenTotal);
        
        require(amountToken <= tokenTotal,'OneCoin:INSUFFICIENT_TOKEN');
        
        IOneCoinPair(pairAddress).removeTokens(payTokenAmount, amountToken, to);
        _lpPayToken[pairAddress][msg.sender] = _lpPayToken[pairAddress][msg.sender].sub(payTokenAmount);
        _lpToken[pairAddress][msg.sender] = _lpToken[pairAddress][msg.sender].sub(amountToken);
        _lpTotal[pairAddress] = _lpTotal[pairAddress].sub(payTokenAmount);
        
    }
    function getGas(address payToken, address token) external view returns(address, uint){
        return (_toGas, _gas[getPair[payToken][token]]);
    }
    
    function setGas(address payToken, address token, address addr, uint fee) external isAdmin{
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _toGas = addr;
        _gas[pairAddress] = fee;
    }
    function toYX(address payToken, address token) external view returns (address, uint){
        return (_toYX[getPair[payToken][token]], _feeYX[getPair[payToken][token]]);
    }
    function toJJ(address payToken, address token) external view returns (address, uint){
        return (_toJJ[getPair[payToken][token]], _feeJJ[getPair[payToken][token]]);
    }
    function toJD(address payToken, address token) external view returns (address, uint){
        return (_toJD[getPair[payToken][token]], _feeJD[getPair[payToken][token]]);
    }
    function toLP(address payToken, address token) external view returns (address, uint){
        return (_toLP[getPair[payToken][token]], _feeLP[getPair[payToken][token]]);
    }
    function toDead(address payToken, address token) external view returns (address, uint){
        return (_deadAddress, _feeDead[getPair[payToken][token]]);
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }
    function setYX(address payToken, address token, address addr, uint fee) external isAdmin{
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _toYX[pairAddress] = addr;
        _feeYX[pairAddress] = fee;
    }
    function setJJ(address payToken, address token, address addr, uint fee) external isAdmin{
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _toJJ[pairAddress] = addr;
        _feeJJ[pairAddress] = fee;
    }
    function setJD(address payToken, address token, address addr, uint fee) external isAdmin{
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _toJD[pairAddress] = addr;
        _feeJD[pairAddress] = fee;
    }
    function setLP(address payToken, address token, address addr, uint fee) external isAdmin{
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _toLP[pairAddress] = addr;
        _feeLP[pairAddress] = fee;
    }
    function setDead(address payToken, address token, address addr, uint fee) external isAdmin{
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _deadAddress = addr;
        _feeDead[pairAddress] = fee;
    }
    function minToken(address payToken, address token) external view returns(uint){
        return _minToken[getPair[payToken][token]];
    }
    function setMinToken(address payToken, address token, uint min) external {
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        _minToken[pairAddress] = min;
    }
    function blcToken() external view returns(address){
        return _blcToken;
    }
    function setBlcToken(address token) external{
        _blcToken = token;
    }
    
    function getLps(address payToken, address token, address owner) external view returns(uint, uint){
        address pairAddress = getPair[payToken][token];
        require(pairAddress != address(0), 'OneCoin: INVALID_PATH');
        uint payTokenAmount = _lpPayToken[pairAddress][owner];
        uint tokenAmount = _lpToken[pairAddress][owner];
        return (payTokenAmount, tokenAmount);
    }
}