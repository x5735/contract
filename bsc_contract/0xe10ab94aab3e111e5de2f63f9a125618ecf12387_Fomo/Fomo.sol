/**
 *Submitted for verification at BscScan.com on 2023-03-28
*/

/**
 *Submitted for verification at BscScan.com on 2022-11-13
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
   
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
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

contract Fomo is Ownable {
    using Address for address payable;

    uint256 public fomoIntervalTime;
    uint256 public maximumIntervalTime;
    uint256 public minBuyRecord;
    uint256 public minBuyFomo;
    address public token;

    address public newRecordBuyer;
    address public maximumBuyer;
    uint256 public maximum;

    uint256 public beforeTimeWhithFomo;
    uint256 public beforeTimeWhithMax;

    event SetFomoIntervalTime(uint256 fomoIntervalTime);
    event SetMaximumIntervalTime(uint256 maximumIntervalTime);
    event SetMinBuyRecord(uint256 minBuyRecord);
    event SetMinBuyFomo(uint256 minBuyFomo);
    event SetTokenAddress(address token);

    event NewRecordBuyer(address buyer);
    event NewMaxBuyer(address buyer, uint256 maximum);

    event UpdateBeforeTimeWhithFomo(uint256 time);
    event UpdateBeforeTimeWhithMax(uint256 time);

    event SendEthWhithFomoBuy(address recv, uint256 amountETH);
    event SendEthWhithMaximum(address recv, uint256 amountETH);
    event SendEth(address recv, uint256 amountETH);

    constructor (address token_) {
        token = token_;
        fomoIntervalTime = 1 days;
        maximumIntervalTime = 1 days;
        minBuyRecord = 1e17;
        minBuyFomo = 1e17;

        emit SetTokenAddress(token);
        emit SetFomoIntervalTime(fomoIntervalTime);
        emit SetMaximumIntervalTime(maximumIntervalTime);
        emit SetMinBuyRecord(minBuyRecord);
        emit SetMinBuyFomo(minBuyFomo);
    }

    function getFomoBNB() external view returns(uint256) {
        return address(this).balance;
    }

    function getFomoEndTimeLeft() external view returns(uint256) {
        uint256 time = block.timestamp - beforeTimeWhithFomo;
        if (time > fomoIntervalTime) {
            return 0;
        } else {
            return fomoIntervalTime - time;
        }
    }

    function getMaximumEndTimeLeft() external view returns(uint256) {
        uint256 time = block.timestamp - beforeTimeWhithMax;
        if (time > maximumIntervalTime) {
            return 0;
        } else {
            return maximumIntervalTime - time;
        }
    }

    function setTokenAddress(address token_) external onlyOwner {
        token = token_;
        emit SetTokenAddress(token);
    }

    function setFomoIntervalTime(uint256 fomoIntervalTime_) external onlyOwner {
        fomoIntervalTime = fomoIntervalTime_;
        emit SetFomoIntervalTime(fomoIntervalTime);
    }

    function setMaximumIntervalTime(uint256 maximumIntervalTime_) external onlyOwner {
        maximumIntervalTime = maximumIntervalTime_;
        emit SetMaximumIntervalTime(maximumIntervalTime);
    }


    function setMinBuyRecord(uint256 minBuyRecord_) external onlyOwner {
        minBuyRecord = minBuyRecord_;
        emit SetMinBuyRecord(minBuyRecord);
    }

    function setMinBuyFomo(uint256 minBuyFomo_) external onlyOwner {
        minBuyFomo = minBuyFomo_;
        emit SetMinBuyFomo(minBuyFomo);
    }

    modifier onlyToken() {
        require(token == _msgSender(), "Fomo: caller is not the token");
        _;
    }

    function recordInfo(address buyer_, uint256 num_) external onlyToken {
        isSendEthWhithFomoBuy(buyer_, num_);
        isSendEthWhithMaximum();

        if (num_ > maximum) {
            maximum = num_;
            maximumBuyer = buyer_;
            emit NewMaxBuyer(maximumBuyer, maximum);
        }
    }

    function isSendEthWhithFomoBuy(address buyer_, uint256 num_) private {
        if (num_ >= minBuyRecord) {
            if (block.timestamp - beforeTimeWhithFomo > fomoIntervalTime) {
                uint256 amountETH = address(this).balance;
                if (amountETH > 0 && newRecordBuyer != address(0x0)) {
                    sendEth(newRecordBuyer, amountETH);
                    emit SendEthWhithFomoBuy(newRecordBuyer, amountETH);
                }

            }
            newRecordBuyer = buyer_;
            beforeTimeWhithFomo = block.timestamp;
            emit UpdateBeforeTimeWhithFomo(beforeTimeWhithFomo);
            emit NewRecordBuyer(newRecordBuyer);
        }
    }

    function isSendEthWhithMaximum() private {
        if (block.timestamp - beforeTimeWhithMax > maximumIntervalTime) {
            uint256 amountETH = address(this).balance / 2;
            if (amountETH > 0 && maximumBuyer != address(0x0)) {
                sendEth(maximumBuyer, amountETH);
                emit SendEthWhithMaximum(maximumBuyer, amountETH);
            }

            beforeTimeWhithMax = block.timestamp;
            emit UpdateBeforeTimeWhithMax(beforeTimeWhithMax);

            maximumBuyer = address(0x0);
            maximum = 0;
        }
    }

    function sendEth(address recv_, uint256 amountETH_) private {
        payable(recv_).sendValue(amountETH_);
        emit SendEth(recv_, amountETH_);
    }


    receive() external payable {

  	}

    function claimStuckTokens(address token_) external onlyOwner {
        if (token_ == address(0x0)) {
            payable(msg.sender).sendValue(address(this).balance);
            return;
        }
        IERC20 ERC20token = IERC20(token_);
        uint256 balance = ERC20token.balanceOf(address(this));
        ERC20token.transfer(msg.sender, balance);
    }
}