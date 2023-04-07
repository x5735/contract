//SPDX-License-Identifier: MIT
pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import "./Partnership.sol";
import "./WhitelistFeeOnTransfer.sol";
import "./interfaces/IUserStakingPrice.sol";

contract KalmarTokenPriviledge is Partnership {

    IUserStakingPrice userStakingPrice;

    event UpdateUserStakingPriceAddr(address userStakingPriceAddr);

    function updateUserStakingPrice(address _userStakingPriceAddr) public onlyOwner
    {
        userStakingPrice = IUserStakingPrice(_userStakingPriceAddr);
        emit UpdateUserStakingPriceAddr(_userStakingPriceAddr);
    }

    function userStakingValue(address user) public view returns (uint256 fee, uint256 total)
    {
        (fee, total) = IUserStakingPrice(userStakingPrice).userStakingValue(user);
        return (fee, total);
    }
}

contract KalmyswapV2 is KalmarTokenPriviledge, WhitelistFeeOnTransfer, ReentrancyGuard {
    using SafeERC20 for IERC20;
    using SafeMath for uint256; 

    /**
    * @dev when new trade occure (and success), this event will be boardcast.
    * @param srcAsset Source token
    * @param srcAmount amount of source token
    * @param destAsset Destination token
    * @param destAmount amount of destination token
    * @param trader user address
    */
    event Trade(
        address indexed srcAsset, // Source
        uint256         srcAmount,
        address indexed destAsset, // Destination
        uint256         destAmount,
        address indexed trader // User
    );

    event DestAmount(uint256 _destAmount, uint256 _order);

    /**
    * @notice use token address 0xeee...eee for ether
    * @dev makes a trade between Ether to token by tradingRouteIndex
    * @param tradingRouteIndex index of trading route
    * @param srcAmount amount of source tokens
    * @param dest Destination token
    * @return amount of actual destination tokens
    */
    function _tradeEtherToToken(
        uint256 tradingRouteIndex,
        uint256 srcAmount,
        IERC20 dest
    )
        private
        returns(uint256)
    {
        // Load trading route
        IKalmarTradingRoute tradingRoute = tradingRoutes[tradingRouteIndex].route;
        // Trade to route
        uint256 destAmount = tradingRoute.trade.value(srcAmount)(
            etherERC20,
            dest,
            srcAmount
        );
        return destAmount;
    }

    // Receive ETH in case of trade Token -> ETH, will get ETH back from trading route
    function () external payable {}

    /**
    * @notice use token address 0xeee...eee for ether
    * @dev makes a trade between token to Ether by tradingRouteIndex
    * @param tradingRouteIndex index of trading route
    * @param src Source token
    * @param srcAmount amount of source tokens
    * @return amount of actual destination tokens
    */
    function _tradeTokenToEther(
        uint256 tradingRouteIndex,
        IERC20 src,
        uint256 srcAmount
    )
        private
        returns(uint256)
    {
        // Load trading route
        IKalmarTradingRoute tradingRoute = tradingRoutes[tradingRouteIndex].route;
        // Approve to TradingRoute
        src.safeApprove(address(tradingRoute), srcAmount);
        // Trande to route
        uint256 destAmount = tradingRoute.trade(
            src,
            etherERC20,
            srcAmount
        );
        return destAmount;
    }

    /**
    * @dev makes a trade between token to token by tradingRouteIndex
    * @param tradingRouteIndex index of trading route
    * @param src Source token
    * @param srcAmount amount of source tokens
    * @param dest Destination token
    * @return amount of actual destination tokens
    */
    function _tradeTokenToToken(
        uint256 tradingRouteIndex,
        IERC20 src,
        uint256 srcAmount,
        IERC20 dest
    )
        private
        returns(uint256)
    {
        // Load trading route
        IKalmarTradingRoute tradingRoute = tradingRoutes[tradingRouteIndex].route;
        // Approve to TradingRoute
        src.safeApprove(address(tradingRoute), srcAmount);
        // Trande to route
        uint256 destAmount = tradingRoute.trade(
            src,
            dest,
            srcAmount
        );
        return destAmount;
    }

    /**
    * @notice use token address 0xeee...eee for ether
    * @dev makes a trade between src and dest token by tradingRouteIndex
    * Ex1: trade 0.5 ETH -> DAI
    * 0, "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "500000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "21003850000000000000"
    * Ex2: trade 30 DAI -> ETH
    * 0, "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "30000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "740825000000000000"
    * @param _tradingRouteIndex index of trading route
    * @param _src Source token
    * @param _srcAmount amount of source tokens
    * @param _dest Destination token
    * @return amount of actual destination tokens
    */
    function _trade(
        uint256             _tradingRouteIndex,
        IERC20              _src,
        uint256             _srcAmount,
        IERC20              _dest
    )
        private
        onlyTradingRouteEnabled(_tradingRouteIndex)
        returns(uint256)
    {
        // Destination amount
        uint256 destAmount;
        // Record src/dest asset for later consistency check.
        uint256 srcAmountBefore;
        uint256 destAmountBefore;

        if (etherERC20 == _src) { // Source
            srcAmountBefore = address(this).balance;
        } else {
            srcAmountBefore = _src.balanceOf(address(this));
        }
        if (etherERC20 == _dest) { // Dest
            destAmountBefore = address(this).balance;
        } else {
            destAmountBefore = _dest.balanceOf(address(this));
        }
        if (etherERC20 == _src) { // Trade ETH -> Token
            destAmount = _tradeEtherToToken(_tradingRouteIndex, _srcAmount, _dest);
        } else if (etherERC20 == _dest) { // Trade Token -> ETH
            destAmount = _tradeTokenToEther(_tradingRouteIndex, _src, _srcAmount);
        } else { // Trade Token -> Token
            destAmount = _tradeTokenToToken(_tradingRouteIndex, _src, _srcAmount, _dest);
        }

        // Recheck if src/dest amount correct
        if (etherERC20 == _src) { // Source
            require(address(this).balance == srcAmountBefore.sub(_srcAmount), "source(ETH) amount mismatch after trade");
        } else {
            require(_src.balanceOf(address(this)) == srcAmountBefore.sub(_srcAmount), "source amount mismatch after trade");
        }
        if (etherERC20 == _dest) { // Dest
            require(address(this).balance == destAmountBefore.add(destAmount), "destination(ETH) amount mismatch after trade");
        } else {
            require(_dest.balanceOf(address(this)) <= destAmountBefore.add(destAmount), "destination amount mismatch after trade");
        }
        return destAmount;
    }

    /**
    * @notice use token address 0xeee...eee for ether
    * @dev makes a trade between src and dest token by tradingRouteIndex
    * Ex1: trade 0.5 ETH -> DAI
    * 0, "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "500000000000000000", "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "21003850000000000000"
    * Ex2: trade 30 DAI -> ETH
    * 0, "0xd3c64BbA75859Eb808ACE6F2A6048ecdb2d70817", "30000000000000000000", "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee", "740825000000000000"
    * @param tradingRouteIndex index of trading route
    * @param src Source token
    * @param srcAmount amount of source tokens
    * @param dest Destination token
    * @param minDestAmount minimun destination amount
    * @return amount of actual destination tokens
    */
    function trade(
        uint256   tradingRouteIndex,
        IERC20    src,
        uint256   srcAmount,
        IERC20    dest,
        uint256   minDestAmount
    )
        external
        payable
        nonReentrant
        returns(uint256)
    {
        uint256 destAmount;
        // Prepare source's asset
        uint256 _before;
        uint256 _beforeSrc;
        uint256 _afterSrc;
        if (etherERC20 != src) {
            _beforeSrc = src.balanceOf(address(this));
            src.safeTransferFrom(msg.sender, address(this), srcAmount); // Transfer token to this address
            _afterSrc = src.balanceOf(address(this));
            srcAmount = _afterSrc.sub(_beforeSrc);
        }

        if(etherERC20 != dest){
          _before = dest.balanceOf(address(this));
        }

        // Trade to route
        destAmount = _trade(tradingRouteIndex, src, srcAmount, dest);
        // checking fee
        (uint256 fee ,) = userStakingValue(msg.sender);
        destAmount = _collectFee(destAmount, dest, fee);


        // Throw exception if destination amount doesn't meet user requirement.
        require(destAmount >= minDestAmount, "destination amount is too low.");
        if (etherERC20 == dest) {
            (bool success, ) = msg.sender.call.value(destAmount)(""); // Send back ether to sender
            require(success, "Transfer ether back to caller failed.");
        } else { // Send back token to sender

            uint256 _after = dest.balanceOf(address(this));
            uint256 _current = _after.sub(_before);

            if(isFeeOnTransferToken(dest) || isFeeOnTransferToken(src)){
              destAmount = _current;
              dest.safeTransfer(msg.sender, destAmount);
            }else{
              dest.safeTransfer(msg.sender, destAmount);
            }
        }

        emit Trade(address(src), srcAmount, address(dest), destAmount, msg.sender);
        return destAmount;
    }

    /**
    * @notice use token address 0xeee...eee for ether
    * @dev makes a trade with split volumes to multiple-routes ex. UNI -> ETH (5%, 15% and 80%)
    * @param routes Trading paths
    * @param src Source token
    * @param srcAmounts amount of source tokens
    * @param dest Destination token
    * @param minDestAmount minimun destination amount
    * @return amount of actual destination tokens
    */

    function splitTrades(
        uint256[] calldata routes,
        IERC20    src,
        uint256   totalSrcAmount,
        uint256[] calldata srcAmounts,
        IERC20    dest,
        uint256   minDestAmount
    )
        external
        payable
        nonReentrant
        returns(uint256)
    {
        require(routes.length > 0, "routes can not be empty");
        require(routes.length == srcAmounts.length, "routes and srcAmounts lengths mismatch");
        uint256 destAmount = 0;

        // Prepare source's asset
        uint256 _before;
        uint256 _currentTotal;


        if (etherERC20 != src) {
            uint256 _beforeSrc = src.balanceOf(address(this));
            src.safeTransferFrom(msg.sender, address(this), totalSrcAmount); // Transfer token to this address
            uint256 _afterSrc = src.balanceOf(address(this));
            _currentTotal = _afterSrc.sub(_beforeSrc);
        }else{
          _currentTotal = totalSrcAmount;
        }

        uint256[] memory splitAmounts = new uint256[](srcAmounts.length);

        for (uint k = 0; k < srcAmounts.length; k++) {
          uint256 x = srcAmounts[k];
          splitAmounts[k] = x.mul(_currentTotal).div(totalSrcAmount);
        }

        if(etherERC20 != dest){
          _before = dest.balanceOf(address(this));
        }

        // Trade with routes
        for (uint i = 0; i < routes.length; i++) {
            uint256 tradingRouteIndex = routes[i];
            uint256 amount = splitAmounts[i];
            IERC20 _src = src;
            IERC20 _dest = dest;
            destAmount = destAmount.add(_trade(tradingRouteIndex, _src, amount, _dest));
        }

        // Collect fee
        (uint256 fee ,) = userStakingValue(msg.sender);
        destAmount = _collectFee(destAmount, dest, fee);

        // Throw exception if destination amount doesn't meet user requirement.
        require(destAmount >= minDestAmount, "destination amount is too low.");
        if (etherERC20 == dest) {
            (bool success, ) = msg.sender.call.value(destAmount)(""); // Send back ether to sender
            require(success, "Transfer ether back to caller failed.");
        } else { // Send back token to sender
            uint256 _after = dest.balanceOf(address(this));
            uint256 _current = _after.sub(_before);

            if(isFeeOnTransferToken(dest) || isFeeOnTransferToken(src)){
              destAmount = _current;
              dest.safeTransfer(msg.sender, destAmount);
            }else{
              dest.safeTransfer(msg.sender, destAmount);
            }

        }

        emit Trade(address(src), totalSrcAmount, address(dest), destAmount, msg.sender);
        return destAmount;
    }

    /**
    * @notice use token address 0xeee...eee for ether
    * @dev get amount of destination token for given source token amount
    * @param tradingRouteIndex index of trading route
    * @param src Source token
    * @param dest Destination token
    * @param srcAmount amount of source tokens
    * @return amount of actual destination tokens
    */
    function getDestinationReturnAmount(
        uint256 tradingRouteIndex,
        IERC20  src,
        IERC20  dest,
        uint256 srcAmount,
        uint256 fee
    )
        external
        returns(uint256)
    {
        // Load trading route
        IKalmarTradingRoute tradingRoute = tradingRoutes[tradingRouteIndex].route;
        uint256 destAmount;
        bytes memory payload = abi.encodeWithSelector(tradingRoute.getDestinationReturnAmount.selector, src, dest, srcAmount);
        (bool success, bytes memory data) = address(tradingRoute).call(payload);
        if (success) {
            destAmount = abi.decode(data, (uint256));
        } else {
            destAmount = 0;
        }
        return _amountWithFee(destAmount, fee);
    }

    function getDestinationReturnAmountForSplitTrades(
        uint256[] calldata routes,
        IERC20    src,
        uint256[] calldata srcAmounts,
        IERC20    dest,
        uint256   fee
    )
        external
        returns(uint256)
    {
        require(routes.length > 0, "routes can not be empty");
        require(routes.length == srcAmounts.length, "routes and srcAmounts lengths mismatch");
        uint256 destAmount = 0;

        for (uint i = 0; i < routes.length; i++) {
            uint256 tradingRouteIndex = routes[i];
            uint256 amount = srcAmounts[i];
            // Load trading route
            IKalmarTradingRoute tradingRoute = tradingRoutes[tradingRouteIndex].route;
            destAmount = destAmount.add(tradingRoute.getDestinationReturnAmount(src, dest, amount));
        }
        return _amountWithFee(destAmount, fee);
    }

    // In case of expected and unexpected event that have some token amounts remain in this contract, owner can call to collect them.
    function collectRemainingToken(
        IERC20  token,
        uint256 amount
    )
      public
      onlyOwner
    {
        token.safeTransfer(msg.sender, amount);
    }

    // In case of expected and unexpected event that have some ether amounts remain in this contract, owner can call to collect them.
    function collectRemainingEther(
        uint256 amount
    )
      public
      onlyOwner
    {
        (bool success, ) = msg.sender.call.value(amount)(""); // Send back ether to sender
        require(success, "Transfer ether back to caller failed.");
    }
}