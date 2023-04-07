/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

pragma solidity >=0.6.6;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        if (b == 0){
            return a;
        }
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

library TransferHelper {
    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function token0() external view returns (address);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IERC20 {
    function decimals() external view returns (uint8);
    function balanceOf(address owner) external view returns (uint);
    function transfer(address to, uint value) external returns (bool);
}

interface IChiToken {
    function freeUpTo(uint256 value) external returns (uint256 freed);
    function mint(uint256 value) external;
}

contract FengshuAllRouter {
    using SafeMath for uint;

    struct TradeOrdered {
        address[] _targetPath;
        address _targetRouter;
        uint _targetAmountIn;
        address tokenA;
        address tokenB;
        uint tradeType;
    }

    address public immutable DEV;
    
    address payable private administrator;
    
    mapping(address => bool) private whiteList;

    IChiToken constant chiToken = IChiToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
    
                                            
    receive() external payable {}

    modifier onlyAdmin() {
        require(msg.sender == DEV, "admin: wut do you try?");
        _;
    }

    modifier gasTokenRefund {
        uint256 gasStart = gasleft();
        _;
        chiToken.freeUpTo((21000 + gasStart - gasleft() + 16 * msg.data.length + 14154) / 41947);
    }
    
    constructor() public {
        DEV = administrator = msg.sender;
        whiteList[msg.sender] = true;
    }

    function mintChiToken(uint256 amount) external virtual onlyAdmin {
        chiToken.mint(amount);
    }

    function sendTokenBack(address token, uint256 amount) external virtual onlyAdmin {
        IERC20(token).transfer(DEV, amount);
    }
    
    function sendTokenBackAll(address token) external virtual onlyAdmin {
        IERC20(token).transfer(DEV, IERC20(token).balanceOf(address(this)));
    }
    
    function sendBnbBack() external virtual onlyAdmin {
        administrator.transfer(address(this).balance);
    }
    
    function setWhite(address account) external virtual onlyAdmin {
        whiteList[account] = true;
    }
    
    function balanceOf(address _token, address tokenOwner) public view returns (uint balance) {
      return IERC20(_token).balanceOf(tokenOwner);
    }
    
    function decimals(address _token) public view returns (uint8 decimal) {
      return IERC20(_token).decimals();
    }
    
    function getAmountsOut(address _router, uint amountIn, address[] memory path) public view returns (uint[] memory amounts) {
        return IUniswapV2Router02(_router).getAmountsOut(amountIn, path);
    }
    
    function getAmountOut(address _router, uint amountIn, uint reserveIn, uint reserveOut) public pure returns (uint amountOut) {
        return IUniswapV2Router02(_router).getAmountOut(amountIn, reserveIn, reserveOut);
    }

    function getAmountsIn(address _router, uint amountOut, address[] memory path) public view returns (uint[] memory amounts) {
        return IUniswapV2Router02(_router).getAmountsIn(amountOut, path);
    }
    
    function getAmountIn(address _router, uint amountOut, uint reserveIn, uint reserveOut) public pure returns (uint amountIn) {
        return IUniswapV2Router02(_router).getAmountIn(amountOut, reserveIn, reserveOut);
    }
    
    function getPair(address _router, address tokenA, address tokenB) public view returns (address pair){
        IUniswapV2Factory _uniswapV2Factory = IUniswapV2Factory(IUniswapV2Router02(_router).factory());
        return _uniswapV2Factory.getPair(tokenA, tokenB);
    }
    
    function getReserves(address _router, address tokenA, address tokenB) public view returns (uint _reserveInput, uint _reserveOutput) {
        address _uniswapV2Pair = getPair(_router, tokenA, tokenB);
        IUniswapV2Pair uniswapV2Pair = IUniswapV2Pair(_uniswapV2Pair);
        address token0 = uniswapV2Pair.token0();
        (uint reserve0, uint reserve1,) = uniswapV2Pair.getReserves();
        (uint reserveIn, uint reserveOut) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        return (reserveIn,reserveOut);
    }
 
    //��ȡ����������������Ƿ����ߵ������ٷֱȣ�(tokenA:bnb || usdt || busd    tokenB:token)
    function getTradePriceImpact(address[] memory _targetPath, address _targetRouter, uint _targetAmountIn, address tokenA, address tokenB, uint tradeType) public view returns (uint _priceImpact){
        uint beforePrice = getTokenPrice(_targetRouter, tokenA, tokenB);
        //ʹ�ýṹ�壬���stack too deep����
        TradeOrdered memory tradeOrdered;
        tradeOrdered._targetPath = _targetPath;
        tradeOrdered._targetRouter = _targetRouter;
        tradeOrdered._targetAmountIn = _targetAmountIn;
        tradeOrdered.tokenA = tokenA;
        tradeOrdered.tokenB = tokenB;
        tradeOrdered.tradeType = tradeType;

        (uint reserveIn, uint reserveOut) = getReserves(tradeOrdered._targetRouter, tradeOrdered.tokenA, tradeOrdered.tokenB);
        uint input = 1000000000000000;//bnb || busd || usdt
        uint tokenDecimals = uint(IERC20(tradeOrdered.tokenB).decimals());
        uint amountOut2;
        uint buyOrSell = 0;//������ 0���� 1����
        uint afterPrice = 0;
        if(tradeOrdered._targetPath[0] == tradeOrdered.tokenB){
            //����
            buyOrSell = 1;
            //tradeType 0:  �������������� ����ȡbnb  1�������ܻ�õ�bnb��  ����������
            if(tradeOrdered.tradeType == 0){
                uint amountOut = getAmountOut(tradeOrdered._targetRouter, tradeOrdered._targetAmountIn, reserveOut, reserveIn);
                amountOut2 = getAmountOut(tradeOrdered._targetRouter, input, reserveIn.sub(amountOut), reserveOut.add(tradeOrdered._targetAmountIn));
            }else{
                //���ﴫ�ε�_amountIn ʵ������amountOut ע:���amountOut��·�����ջ�ȡ�Ĵ��ҵ�����
                uint amountOut = tradeOrdered._targetAmountIn;
                uint[] memory amounts = getAmountsIn(tradeOrdered._targetRouter, amountOut, tradeOrdered._targetPath);//0: �Ǵ���token���� 1��token ��ȡ[1]���� ������
                amountOut2 = getAmountOut(tradeOrdered._targetRouter, input, reserveIn.sub(amounts[1]), reserveOut.add(amounts[0]));
            }
        }else if(tradeOrdered._targetPath[tradeOrdered._targetPath.length - 1] == tradeOrdered.tokenB){
            //��
            //tradeType 0:  ���빺��(bnb || usdt || busd) ���� ����ȡ����  1�������ܻ�õĴ�����  ���������
            if(tradeOrdered.tradeType == 0){
                uint[] memory amounts = getAmountsOut(tradeOrdered._targetRouter, tradeOrdered._targetAmountIn, tradeOrdered._targetPath);
                amountOut2 = getAmountOut(tradeOrdered._targetRouter, input, reserveIn.add(amounts[tradeOrdered._targetPath.length - 2]), reserveOut.sub(amounts[tradeOrdered._targetPath.length - 1]));
            }else{
                //���ﴫ�ε�_amountIn ʵ������amountOut ע:���amountOut��·�����ջ�ȡ�Ĵ��ҵ�����
                uint amountOut = tradeOrdered._targetAmountIn;
                uint[] memory amounts = getAmountsIn(tradeOrdered._targetRouter, amountOut, tradeOrdered._targetPath);
                amountOut2 = getAmountOut(tradeOrdered._targetRouter, input, reserveIn.add(amounts[tradeOrdered._targetPath.length - 2]), reserveOut.sub(amountOut));
            }
        } 
        if(tokenDecimals < 18){
            afterPrice = input.mul(10 ** 18).div(amountOut2.mul(10 ** (18 - tokenDecimals)));
        }else{
            afterPrice = input.mul(10 ** 18).div(amountOut2);
        }
        return buyOrSell == 0 ? afterPrice.sub(beforePrice).mul(10000).div(beforePrice) : (beforePrice.sub(afterPrice).mul(10000).div(beforePrice));
    }

    //��ȡ��ǰ���ҵļ۸� (tokenA:bnb || usdt || busd  tokenB:token)
    function getTokenPrice(address _router, address tokenA, address tokenB) public view returns (uint _price){
        uint reserveInput = 1000000000000000;
        address[] memory _path = new address[](2);
        _path[0] = tokenA;
        _path[1] = tokenB;
        uint[] memory amounts = getAmountsOut(_router, reserveInput, _path);
        uint tokenDecimals = uint(IERC20(tokenB).decimals());
        uint price = 0;
        if(tokenDecimals < 18){
             price = reserveInput.mul(10 ** 18).div(amounts[1].mul(10 ** (18 - tokenDecimals)));
        }else{
             price = reserveInput.mul(10 ** 18).div(amounts[1]);
        }
        return price;
    }

    //����������˰
    function checkHoneypots(address _router, address tokenA, address tokenB, uint amountIn) external virtual {
        address[] memory _path = new address[](2);
        _path[0] = tokenA;
        _path[1] = tokenB;
        uint[] memory amounts = getAmountsOut(_router, amountIn, _path);
        uint buyExpectedOut = amounts[1];
        testBuy(_router, tokenA, tokenB, amountIn);
        uint buyActualOut = IERC20(tokenB).balanceOf(address(this));
        //sell
        uint beforeBnb = IERC20(tokenA).balanceOf(address(this));
        address[] memory _path2 = new address[](2);
        _path2[0] = tokenB;
        _path2[1] = tokenA;
        uint[] memory amounts2 = getAmountsOut(_router, buyActualOut, _path2);
        uint sellExpectedOut = amounts2[1];
        testSellAll(_router, tokenB, tokenA);
        uint afterBnb = IERC20(tokenA).balanceOf(address(this));
        uint sellActualOut = afterBnb.sub(beforeBnb);
        require(1!=1,string(abi.encodePacked("printTax:", uint2str(buyExpectedOut), "-", uint2str(buyActualOut), "-", uint2str(sellExpectedOut), "-", uint2str(sellActualOut))));
    }

    function fastBuyCheckHoneypots(address _router, address tokenA, address tokenB, uint amountIn, uint taxFee) external virtual gasTokenRefund{
        require(whiteList[msg.sender], "not on the white list");
        address[] memory _path = new address[](2);
        _path[0] = tokenA;
        _path[1] = tokenB;
        uint[] memory amounts = getAmountsOut(_router, amountIn, _path);
        uint buyExpectedOut = amounts[1];
        //buy
        address pairAddress = getPair(_router, tokenA, tokenB);
        TransferHelper.safeTransfer(tokenA, pairAddress, amountIn);
        address token0 = tokenA < tokenB ? tokenA : tokenB;
        (uint amount0Out, uint amount1Out) = tokenA == token0 ? (uint(0), amounts[1]) : (amounts[1], uint(0));
        IUniswapV2Pair(pairAddress).swap(amount0Out, amount1Out, address(this), new bytes(0));
        //check buyTax
        uint buyActualOut = IERC20(tokenB).balanceOf(address(this));
        require(buyActualOut >= buyExpectedOut.sub(buyExpectedOut.mul(taxFee).div(10**2)), "buy tax too big");
        //sell
        uint sellToken = buyActualOut.div(100);//�����ٷ�֮1
        //�Լ�ת���Լ���֤�Ƿ������Լ���֤˰(��Щ��ת�˻��˰)
        TransferHelper.safeTransfer(tokenB, address(this), sellToken);
        require(sellToken.mul(taxFee).div(10**2) >= buyActualOut.sub(IERC20(tokenB).balanceOf(address(this))), "sell tax too big");
    }

    function fastBuy(address _router, address tokenA, address tokenB, uint amountIn) external virtual gasTokenRefund{
        require(whiteList[msg.sender], "not on the white list");
        address[] memory _path = new address[](2);
        _path[0] = tokenA;
        _path[1] = tokenB;
        uint[] memory amounts = getAmountsOut(_router, amountIn, _path);
        address pairAddress = getPair(_router, tokenA, tokenB);
        TransferHelper.safeTransfer(tokenA, pairAddress, amountIn);
        address token0 = tokenA < tokenB ? tokenA : tokenB;
        (uint amount0Out, uint amount1Out) = tokenA == token0 ? (uint(0), amounts[1]) : (amounts[1], uint(0));
        IUniswapV2Pair(pairAddress).swap(amount0Out, amount1Out, address(this), new bytes(0));
    }

    function fastSell(address _router, address tokenA, address tokenB, uint amountIn) external virtual gasTokenRefund{
        require(whiteList[msg.sender], "not on the white list");
        require(IERC20(tokenA).balanceOf(address(this)) > 0, "token not buy");
        address pairAddress = getPair(_router, tokenA, tokenB);
        TransferHelper.safeTransfer(tokenA, pairAddress, amountIn);
        (uint reserveInput, uint reserveOutput) = getReserves(_router, tokenA, tokenB);
        uint amountInput = IERC20(tokenA).balanceOf(address(pairAddress)).sub(reserveInput);
        uint amountOutput = getAmountOut(_router, amountInput, reserveInput, reserveOutput); 
        address token0 = tokenA < tokenB ? tokenA : tokenB;
        (uint amount0Out, uint amount1Out) = tokenA == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
        IUniswapV2Pair(pairAddress).swap(amount0Out, amount1Out, address(this), new bytes(0));
    }

    function fastSellAll(address _router, address tokenA, address tokenB) external virtual gasTokenRefund{
        require(whiteList[msg.sender], "not on the white list");
        uint256 balance = IERC20(tokenA).balanceOf(address(this));
        require(balance > 0, "token not buy");
        address pairAddress = getPair(_router, tokenA, tokenB);
        TransferHelper.safeTransfer(tokenA, pairAddress, balance);
        (uint reserveInput, uint reserveOutput) = getReserves(_router, tokenA, tokenB);
        uint amountInput = IERC20(tokenA).balanceOf(address(pairAddress)).sub(reserveInput);
        uint amountOutput = getAmountOut(_router, amountInput, reserveInput, reserveOutput); 
        address token0 = tokenA < tokenB ? tokenA : tokenB;
        (uint amount0Out, uint amount1Out) = tokenA == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
        IUniswapV2Pair(pairAddress).swap(amount0Out, amount1Out, address(this), new bytes(0));
    }

    function testBuy(address _router, address tokenA, address tokenB, uint amountIn) internal virtual {
        address token0 = tokenA < tokenB ? tokenA : tokenB;
        address[] memory _path = new address[](2);
        _path[0] = tokenA;
        _path[1] = tokenB;
        address pairAddress = getPair(_router, tokenA, tokenB);
        uint[] memory amounts = getAmountsOut(_router, amountIn, _path);
        TransferHelper.safeTransfer(tokenA, pairAddress, amountIn);
        (uint amount0Out, uint amount1Out) = tokenA == token0 ? (uint(0), amounts[1]) : (amounts[1], uint(0));
        IUniswapV2Pair(pairAddress).swap(amount0Out, amount1Out, address(this), new bytes(0));
    }

    function testSellAll(address _router, address tokenA, address tokenB) internal virtual {
        uint256 balance = IERC20(tokenA).balanceOf(address(this));
        require(balance > 0, "token not buy");
        address token0 = tokenA < tokenB ? tokenA : tokenB;
        address pairAddress = getPair(_router, tokenA, tokenB);
        TransferHelper.safeTransfer(tokenA, pairAddress, balance);
        (uint reserveInput, uint reserveOutput) = getReserves(_router, tokenA, tokenB);
        uint amountInput = IERC20(tokenA).balanceOf(address(pairAddress)).sub(reserveInput);
        uint amountOutput = getAmountOut(_router, amountInput, reserveInput, reserveOutput); 
        (uint amount0Out, uint amount1Out) = tokenA == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
        IUniswapV2Pair(pairAddress).swap(amount0Out, amount1Out, address(this), new bytes(0));
    }

  
    //------------------calcTool----------------------

    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

}