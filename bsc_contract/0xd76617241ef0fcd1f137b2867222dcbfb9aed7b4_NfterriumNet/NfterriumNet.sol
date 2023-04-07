/**
 *Submitted for verification at BscScan.com on 2023-03-29
*/

// File: @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol


pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

// File: @openzeppelin/contracts-upgradeable/utils/StorageSlotUpgradeable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)

pragma solidity ^0.8.0;

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC1967 implementation slot:
 * ```
 * contract ERC1967 {
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
 */
library StorageSlotUpgradeable {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }
}

// File: @openzeppelin/contracts-upgradeable/proxy/beacon/IBeaconUpgradeable.sol


// OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)

pragma solidity ^0.8.0;

/**
 * @dev This is the interface that {BeaconProxy} expects of its beacon.
 */
interface IBeaconUpgradeable {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {BeaconProxy} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}

// File: @openzeppelin/contracts-upgradeable/interfaces/draft-IERC1822Upgradeable.sol


// OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)

pragma solidity ^0.8.0;

/**
 * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
 * proxy whose upgrades are fully controlled by the current implementation.
 */
interface IERC1822ProxiableUpgradeable {
    /**
     * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
     * address.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy.
     */
    function proxiableUUID() external view returns (bytes32);
}

// File: @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165Upgradeable {
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

// File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library StringsUpgradeable {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}

// File: @openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol


// OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)

pragma solidity ^0.8.0;

/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControlUpgradeable {
    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) external;
}

// File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
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
        return functionCall(target, data, "Address: low-level call failed");
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
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
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
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
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
}

// File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (proxy/utils/Initializable.sol)

pragma solidity ^0.8.2;


/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
     */
    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require(
            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
            "Initializable: contract is already initialized"
        );
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
     * initialization step. This is essential to configure modules that are added through upgrades and that require
     * initialization.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     */
    modifier reinitializer(uint8 version) {
        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     */
    function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized < type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }
}

// File: @openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol


// OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)

pragma solidity ^0.8.2;






/**
 * @dev This abstract contract provides getters and event emitting update functions for
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
 *
 * _Available since v4.1._
 *
 * @custom:oz-upgrades-unsafe-allow delegatecall
 */
abstract contract ERC1967UpgradeUpgradeable is Initializable {
    function __ERC1967Upgrade_init() internal onlyInitializing {
    }

    function __ERC1967Upgrade_init_unchained() internal onlyInitializing {
    }
    // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
    bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev Emitted when the implementation is upgraded.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Returns the current implementation address.
     */
    function _getImplementation() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 implementation slot.
     */
    function _setImplementation(address newImplementation) private {
        require(AddressUpgradeable.isContract(newImplementation), "ERC1967: new implementation is not a contract");
        StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
    }

    /**
     * @dev Perform implementation upgrade
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    /**
     * @dev Perform implementation upgrade with additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCall(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        _upgradeTo(newImplementation);
        if (data.length > 0 || forceCall) {
            _functionDelegateCall(newImplementation, data);
        }
    }

    /**
     * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCallUUPS(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        // Upgrades from old implementations will perform a rollback test. This test requires the new
        // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
        // this special case will break upgrade paths from old UUPS implementation to new ones.
        if (StorageSlotUpgradeable.getBooleanSlot(_ROLLBACK_SLOT).value) {
            _setImplementation(newImplementation);
        } else {
            try IERC1822ProxiableUpgradeable(newImplementation).proxiableUUID() returns (bytes32 slot) {
                require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
            } catch {
                revert("ERC1967Upgrade: new implementation is not UUPS");
            }
            _upgradeToAndCall(newImplementation, data, forceCall);
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Emitted when the admin account has changed.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Returns the current admin.
     */
    function _getAdmin() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 admin slot.
     */
    function _setAdmin(address newAdmin) private {
        require(newAdmin != address(0), "ERC1967: new admin is the zero address");
        StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
    }

    /**
     * @dev Changes the admin of the proxy.
     *
     * Emits an {AdminChanged} event.
     */
    function _changeAdmin(address newAdmin) internal {
        emit AdminChanged(_getAdmin(), newAdmin);
        _setAdmin(newAdmin);
    }

    /**
     * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
     * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
     */
    bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

    /**
     * @dev Emitted when the beacon is upgraded.
     */
    event BeaconUpgraded(address indexed beacon);

    /**
     * @dev Returns the current beacon.
     */
    function _getBeacon() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value;
    }

    /**
     * @dev Stores a new beacon in the EIP1967 beacon slot.
     */
    function _setBeacon(address newBeacon) private {
        require(AddressUpgradeable.isContract(newBeacon), "ERC1967: new beacon is not a contract");
        require(
            AddressUpgradeable.isContract(IBeaconUpgradeable(newBeacon).implementation()),
            "ERC1967: beacon implementation is not a contract"
        );
        StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value = newBeacon;
    }

    /**
     * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
     * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
     *
     * Emits a {BeaconUpgraded} event.
     */
    function _upgradeBeaconToAndCall(
        address newBeacon,
        bytes memory data,
        bool forceCall
    ) internal {
        _setBeacon(newBeacon);
        emit BeaconUpgraded(newBeacon);
        if (data.length > 0 || forceCall) {
            _functionDelegateCall(IBeaconUpgradeable(newBeacon).implementation(), data);
        }
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function _functionDelegateCall(address target, bytes memory data) private returns (bytes memory) {
        require(AddressUpgradeable.isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return AddressUpgradeable.verifyCallResult(success, returndata, "Address: low-level delegate call failed");
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol


// OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/UUPSUpgradeable.sol)

pragma solidity ^0.8.0;




/**
 * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
 * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
 *
 * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
 * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
 * `UUPSUpgradeable` with a custom implementation of upgrades.
 *
 * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
 *
 * _Available since v4.1._
 */
abstract contract UUPSUpgradeable is Initializable, IERC1822ProxiableUpgradeable, ERC1967UpgradeUpgradeable {
    function __UUPSUpgradeable_init() internal onlyInitializing {
    }

    function __UUPSUpgradeable_init_unchained() internal onlyInitializing {
    }
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
    address private immutable __self = address(this);

    /**
     * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
     * a proxy contract with an implementation (as defined in ERC1967) pointing to self. This should only be the case
     * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
     * function through ERC1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
     * fail.
     */
    modifier onlyProxy() {
        require(address(this) != __self, "Function must be called through delegatecall");
        require(_getImplementation() == __self, "Function must be called through active proxy");
        _;
    }

    /**
     * @dev Check that the execution is not being performed through a delegate call. This allows a function to be
     * callable on the implementing contract but not through proxies.
     */
    modifier notDelegated() {
        require(address(this) == __self, "UUPSUpgradeable: must not be called through delegatecall");
        _;
    }

    /**
     * @dev Implementation of the ERC1822 {proxiableUUID} function. This returns the storage slot used by the
     * implementation. It is used to validate that the this implementation remains valid after an upgrade.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.
     */
    function proxiableUUID() external view virtual override notDelegated returns (bytes32) {
        return _IMPLEMENTATION_SLOT;
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     */
    function upgradeTo(address newImplementation) external virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
     * encoded in `data`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     */
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, data, true);
    }

    /**
     * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
     * {upgradeTo} and {upgradeToAndCall}.
     *
     * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
     *
     * ```solidity
     * function _authorizeUpgrade(address) internal override onlyOwner {}
     * ```
     */
    function _authorizeUpgrade(address newImplementation) internal virtual;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;



/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
    function __ERC165_init() internal onlyInitializing {
    }

    function __ERC165_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165Upgradeable).interfaceId;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)

pragma solidity ^0.8.0;






/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it.
 */
abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable, IAccessControlUpgradeable, ERC165Upgradeable {
    function __AccessControl_init() internal onlyInitializing {
    }

    function __AccessControl_init_unchained() internal onlyInitializing {
    }
    struct RoleData {
        mapping(address => bool) members;
        bytes32 adminRole;
    }

    mapping(bytes32 => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControlUpgradeable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
        return _roles[role].members[account];
    }

    /**
     * @dev Revert with a standard message if `_msgSender()` is missing `role`.
     * Overriding this function changes the behavior of the {onlyRole} modifier.
     *
     * Format of the revert message is described in {_checkRole}.
     *
     * _Available since v4.6._
     */
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }

    /**
     * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        StringsUpgradeable.toHexString(uint160(account), 20),
                        " is missing role ",
                        StringsUpgradeable.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleGranted} event.
     */
    function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleRevoked} event.
     */
    function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `account`.
     *
     * May emit a {RoleRevoked} event.
     */
    function renounceRole(bytes32 role, address account) public virtual override {
        require(account == _msgSender(), "AccessControl: can only renounce roles for self");

        _revokeRole(role, account);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event. Note that unlike {grantRole}, this function doesn't perform any
     * checks on the calling account.
     *
     * May emit a {RoleGranted} event.
     *
     * [WARNING]
     * ====
     * This function should only be called from the constructor when setting
     * up the initial roles for the system.
     *
     * Using this function in any other way is effectively circumventing the admin
     * system imposed by {AccessControl}.
     * ====
     *
     * NOTE: This function is deprecated in favor of {_grantRole}.
     */
    function _setupRole(bytes32 role, address account) internal virtual {
        _grantRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleGranted} event.
     */
    function _grantRole(bytes32 role, address account) internal virtual {
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleRevoked} event.
     */
    function _revokeRole(bytes32 role, address account) internal virtual {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, _msgSender());
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

// File: @openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;



/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    function __Pausable_init() internal onlyInitializing {
        __Pausable_init_unchained();
    }

    function __Pausable_init_unchained() internal onlyInitializing {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

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
        return a + b;
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
        return a - b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
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
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: contracts/net.sol


pragma solidity ^0.8.9;







interface INfterriumNomad {
    function mintNomad(address account, uint8 body) external;
}

interface INfterriumTerra {
    function mintTerra(address account) external;
}

contract NfterriumNet is Initializable, PausableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable {
    using SafeMath for uint256;
    using SafeMath for uint8;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant REFEREE_ROLE = keccak256("REFEREE_ROLE");

    AggregatorV3Interface internal priceFeed;

    struct User {
        address payable wallet;
        uint256 row;
        uint256 col;
        uint256 refId;
        uint256 terraCount;
        uint256 lastRow;
        uint8 status;
        uint256 expire;
    }

    struct UserForSale {
        address forWallet;
        uint256 price;
    }

    mapping(uint256 => uint256[9]) public refCounts;
    mapping(uint256 => uint256[9]) public refDirCounts;

    mapping(uint256 => UserForSale) public usersForSale;
    mapping(uint256 => User) public users;
    mapping(address => uint256) public userIds;
    mapping(uint256 => mapping(uint256 => uint256)) public globalPlaces;
    mapping(uint256 => uint256) public lastFreePlaceInRow;

    mapping(uint8 => uint8[12]) public percentages; // deprecated

    uint256 public terraPrice;
    uint8 public maxTerraBuy;
    uint8 public terraLimit;
    uint256 public nomadPrice;
    uint256 public vipPriceNomad;
    uint256 public vipPriceTerra;

    uint8 public term;

    uint8[11] public levels;
    uint8[11] public refs;

    uint256 public fightPool;

    uint256 public gasPrice;

    uint256 public lastUserId;

    address payable _owner;
    address payable _addressToCom;

    uint8 public constant MAX_ROW = 93;

    address nomadNft;
    address terraNft;

    uint256 public winPrice;
    mapping(uint256 => uint256) public balances;
    uint256 public allBalances;

    uint256 internal sChanged; // deprecated
    struct UChanged { // deprecated
        uint256 id;
        uint8 status;
    }
    mapping(uint256 => UChanged) internal uChanged; // deprecated
    uint256 public vipPriceNomadWoTerra;
    mapping(uint256 => bool) public blIds;

    uint256 public terraPriceNp;

    uint8[15] public lvlPercentages;

    mapping(uint256 => uint256) public sourcesOwners;
    mapping(uint256 => bool) public sourcesBuyers;

    event OwnershipTransferred(
        address indexed _previousOwner,
        address indexed _newOwner
    );
    event Register(
        address indexed _wallet,
        uint256 _userId,
        uint256 _row,
        uint256 _col,
        uint256 _refId,
        uint256 _date
    );
    event BuyTerra(
        address indexed _wallet,
        uint256 _count,
        uint256 _row,
        uint256 _col,
        uint256 _refId,
        uint256 _date
    );
    event RefBonusSent(
        uint256 _userId,
        address _refWallet,
        uint256 _amount,
        uint256 _date
    );
    event BuyVip(uint256 _userId, uint8 _status, uint256 _date);
    event PaymentToUpline(
        uint256 _userId,
        uint256 _refId,
        uint8 _level,
        uint256 _amount,
        uint256 _date
    );
    event StatusUpdate(uint256 _userId, uint8 _oldStatus, uint8 _newStatus);
    event PlaceSold(uint256 _userId, address _oldWallet, address _newWallet, uint256 _price, uint256 _date);
    event BattleAwardSent(uint256 _userId, uint256 _amount, uint256 _date);

    modifier notInBl() {
        require(blIds[userIds[msg.sender]] == false, "userIdBl");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {}

    function transferOwnership(address payable _newOwner) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_newOwner != address(0), "zeroAddress");
        _grantRole(DEFAULT_ADMIN_ROLE, _newOwner);
        _grantRole(MANAGER_ROLE, _newOwner);
        _grantRole(PAUSER_ROLE, _newOwner);
        _grantRole(UPGRADER_ROLE, _newOwner);
        _grantRole(REFEREE_ROLE, _newOwner);
        users[1].wallet = _newOwner;
        userIds[_newOwner] = 1;
        delete(userIds[_owner]);
        _owner = _newOwner;
        _revokeRole(DEFAULT_ADMIN_ROLE, _owner);
        _revokeRole(MANAGER_ROLE, _owner);
        _revokeRole(PAUSER_ROLE, _owner);
        _revokeRole(UPGRADER_ROLE, _owner);
        _revokeRole(REFEREE_ROLE, _owner);
        emit OwnershipTransferred(_owner, _newOwner);
    }

    // function getLatestPrice() public view returns (int256) {
    //     (,int256 price,,,) = priceFeed.latestRoundData();
    //     return price;
    // }

    function setPercentages(uint8 _status, uint8[12] memory _lines) public onlyRole(MANAGER_ROLE) {
        require(_status > 0 && _status < 11, "statusNotExist");
        percentages[_status] = _lines;
    }

    function setLvlPercentages(uint8[15] memory _lines) public onlyRole(MANAGER_ROLE) {
        lvlPercentages = _lines;
    }

    function setWinPrice(uint256 _price) public onlyRole(MANAGER_ROLE) {
        winPrice = _price;
    }

    function setNomadNft(address _newAddress) public onlyRole(MANAGER_ROLE) {
        require(_newAddress != address(0), "zeroAddress");
        nomadNft = _newAddress;
    }

    function setTerraNft(address _newAddress) public onlyRole(MANAGER_ROLE) {
        require(_newAddress != address(0), "zeroAddress");
        terraNft = _newAddress;
    }

    function setAddressToCom(address _newAddress) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_newAddress != address(0), "zeroAddress");
        _addressToCom = payable(_newAddress);
    }

    function setPriceTerra(uint256 _newPrice) public onlyRole(MANAGER_ROLE) {
        terraPrice = _newPrice;
    }

    function setPriceTerraNp(uint256 _newPrice) public onlyRole(MANAGER_ROLE) {
        terraPriceNp = _newPrice;
    }

    function setMaxTerraBuy(uint8 _newMax) public onlyRole(MANAGER_ROLE) {
        maxTerraBuy = _newMax;
    }

    function setTerraLimit(uint8 _newMax) public onlyRole(MANAGER_ROLE) {
        terraLimit = _newMax;
    }

    function setPriceNomad(uint256 _newPrice) public onlyRole(MANAGER_ROLE) {
        nomadPrice = _newPrice;
    }

    function setVipPriceNomad(uint256 _newPrice) public onlyRole(MANAGER_ROLE) {
        vipPriceNomad = _newPrice;
    }

    function setVipPriceNomadWoTerra(uint256 _newPrice) public onlyRole(MANAGER_ROLE) {
        vipPriceNomadWoTerra = _newPrice;
    }

    function setVipPriceTerra(uint256 _newPrice) public onlyRole(MANAGER_ROLE) {
        vipPriceTerra = _newPrice;
    }

    function setRefs(uint8[11] memory _newRefs) public onlyRole(MANAGER_ROLE) {
        refs = _newRefs;
    }

    function setLevels(uint8[11] memory _newLevels) public onlyRole(MANAGER_ROLE) {
        levels = _newLevels;
    }

    function setRefCounts(uint256 _id, uint256[9] memory _newCounts) public onlyRole(REFEREE_ROLE) {
        refCounts[_id] = _newCounts;
    }

    function setRefDirCounts(uint256 _id, uint256[9] memory _newCounts) public onlyRole(REFEREE_ROLE) {
        refDirCounts[_id] = _newCounts;
    }

    function setTerm(uint8 _newTerm) public onlyRole(MANAGER_ROLE) {
        require(_newTerm > 0, "zeroPrice");
        term = _newTerm;
    }

    function getRefCounts(uint256 _id) public view returns (uint256[9] memory) {
        uint256[9] memory result = refCounts[_id];
        return result;
    }

    function getRefDirCounts(uint256 _id) public view returns (uint256[9] memory) {
        uint256[9] memory result = refDirCounts[_id];
        return result;
    }

    function getOwner() public view returns (address) {
        address result = _owner;
        return result;
    }

    function addBlIds(uint256[] memory _ids) public onlyRole(REFEREE_ROLE) {
        for (uint256 i = 0; i < _ids.length; i++) {
            require(users[_ids[i]].wallet != address(0), "notRegistered");
            require(blIds[_ids[i]] == false, "alreadyBl");
            blIds[_ids[i]] = true;
        }
    }

    function remBlIds(uint256[] memory _ids) public onlyRole(REFEREE_ROLE) {
        for (uint256 i = 0; i < _ids.length; i++) {
            require(blIds[_ids[i]] == true, "notBl");
            delete(blIds[_ids[i]]);
        }
    }

    function withdraw(address payable to, uint256 amount) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0), "toZeroAddress");
        uint256 contractBalance = address(this).balance;
        require(contractBalance.sub(amount) >= fightPool.add(allBalances), "insufficientContractBalance");
        to.transfer(amount);
    }

    function setFightPool(uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_amount > 0, "zeroAmount");
        uint256 contractBalance = address(this).balance;
        require(contractBalance.sub(allBalances) >= _amount, "insufficientContractBalance");
        fightPool = _amount;
    }

    function addFightPool() external payable onlyRole(REFEREE_ROLE) {
        fightPool = fightPool.add(msg.value);
    }

    // function setGasPrice(uint256 _amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
    //     require(_amount > 0, "zeroAmount");
    //     gasPrice = _amount;
    // }

    function findFreePlace(uint256 _refId) internal view returns (uint256, uint256, uint256) {
        uint256 start;
        uint256 end;
        for (uint256 i = users[_refId].lastRow; i <= MAX_ROW; i++) {
            start = users[_refId].col.sub(1).mul(5**(i.sub(users[_refId].row)));
            end = start.add(5**(i.sub(users[_refId].row)));
            start = start.add(1);
            if (lastFreePlaceInRow[i] > end) {
                continue;
            }
            if (lastFreePlaceInRow[i] > start && lastFreePlaceInRow[i] < end) {
                start = lastFreePlaceInRow[i];
            }
            for (uint256 j = start; j <= end; j++) {
                if (globalPlaces[i][j] == 0) {
                    if (lastFreePlaceInRow[i] == 0 && start == 1) {
                        return (i, j, 2);
                    } else if (start > lastFreePlaceInRow[i]) {
                        return (i, j, lastFreePlaceInRow[i]);
                    } else {
                        return (i, j, j.add(1));
                    }
                }
            }
        }
        return (0, 0, 0);
    }

    function isExpired(uint256 _id) internal view returns (bool) {
        if (users[_id].row <= 2) {
            return false;
        }
        uint256 expireDate = users[_id].expire;
        bool result;
        result = block.timestamp > expireDate;
        return result;
    }

    function findUpline(uint256 col) internal pure returns (uint256) {
        return uint256(col.sub(1).div(5).add(1));
    }

    function checkLevel(uint8 _counter, uint8 _status) internal pure returns (bool) {
        if (_status == 1 && _counter <= 1) {
            return true;
        } else if (_status == 2 && _counter <= 2) {
            return true;
        } else if (_status == 3 && _counter <= 4) {
            return true;
        } else if (_status == 4 && _counter <= 5) {
            return true;
        } else if (_status == 5 && _counter <= 6) {
            return true;
        } else if (_status == 6 && _counter <= 8) {
            return true;
        } else if (_status == 7 && _counter <= 11) {
            return true;
        } else if (_status == 8 && _counter <= 14) {
            return true;
        } else if (_status == 9 && _counter <= 14) {
            return true;
        } else if (_status == 10 && _counter <= 14) {
            return true;
        } else {
            return false;
        }
    }

    function processNet(uint256 _userId) public payable onlyRole(REFEREE_ROLE) {
        require(msg.sender != address(0), "zeroAddress");
        require(users[_userId].wallet != address(0), "userNotRegistered");
        processRef(_userId, msg.value, false);
        processUplines(_userId, msg.value, false);
    }

    function processRef(uint256 _userId, uint256 _amount, bool _source) internal {
        User memory refUser = users[users[_userId].refId];
        uint256 refPercent = refs[refUser.status];
        if (refPercent > 0 && (!_source || _source && sourcesBuyers[_userId])) {
            uint256 amount = _amount.div(100).mul(refPercent);
            balances[users[_userId].refId] = balances[users[_userId].refId].add(amount);
            allBalances = allBalances.add(amount);
            emit RefBonusSent(
                _userId,
                refUser.wallet,
                amount,
                block.timestamp
            );
        }
    }

    function processUplines(uint256 _userId, uint256 _amount, bool _source) internal {
        uint8 counter = 0;
        uint256 uplineId;
        address payable uplineWallet;
        uint256 row = users[_userId].row;
        uint256 col = users[_userId].col;
        while (row > 1 && counter < 15) {
            col = findUpline(col);
            uplineId = globalPlaces[row.sub(1)][col];
            if (((users[uplineId].row <= 2) || (!isExpired(uplineId) && checkLevel(counter, users[uplineId].status))) && (!_source || _source && sourcesBuyers[_userId])) {
                uplineWallet = users[uplineId].wallet;
                uint8 percent = lvlPercentages[counter];
                uint256 amount = _amount.div(10000).mul(percent.mul(100));
                balances[uplineId] = balances[uplineId].add(amount);
                allBalances = allBalances.add(amount);
                emit PaymentToUpline(
                    _userId,
                    uplineId,
                    counter + 1,
                    amount,
                    block.timestamp
                );
                counter++;
            } else if (!isExpired(uplineId) && users[uplineId].status != 0 && !checkLevel(counter, users[uplineId].status) && !_source) {
                counter++;
            }
            row--;
        }
    }

    function countRefs(uint256 _id, uint8 _s, bool _dir) internal view returns (uint256) {
        uint256 count = 0;
        for (uint8 i = _s; i <= 8; i++) {
            if (_dir) {
                count = count.add(refDirCounts[_id][i]);
            } else {
                count = count.add(refCounts[_id][i]);
            }
        }
        return count;
    }

    function checkStatus(uint256 _userId) internal {
        (uint8 oldStatus, uint8 newStatus) = calculateStatus(_userId);
        if (oldStatus < newStatus || (oldStatus == 0 && newStatus == 0)) {
            countToUpline(_userId, _userId, oldStatus, newStatus);
        }
    }

    function calculateStatus(uint256 _userId) internal returns (uint8, uint8) {
        if (users[_userId].row == 1) {
            return (10, 10);
        }
        if (users[_userId].row == 2) {
            return (9, 9);
        }
        uint8 oldStatus = users[_userId].status;
        uint8 newStatus = users[_userId].status;
        uint256 owns = users[_userId].terraCount + sourcesOwners[_userId];
        if (owns >= 1) {
            newStatus = 1; // Lorddom
        }
        if (owns >= 2) {
            newStatus = 2; // Earldom
        }
        if (owns >= 3) {
            newStatus = 3; // Barondom
        }
        if (owns >= 4 && countRefs(_userId, 3, false) >= 5 && countRefs(_userId, 3, true) >= 2 ) {
            newStatus = 4; // Order
        }
        if (owns >= 6 && countRefs(_userId, 4, false) >= 5 && countRefs(_userId, 4, true) >= 2 ) {
            newStatus = 5; // Clan
        }
        if (owns >= 9 && countRefs(_userId, 5, false) >= 10 && countRefs(_userId, 5, true) >= 2 ) {
            newStatus = 6; // Alliance
        }
        if (owns >= 12 && countRefs(_userId, 6, false) >= 10 && countRefs(_userId, 6, true) >= 2 ) {
            newStatus = 7; // Kingdom
        }
        if (owns >= 18 && countRefs(_userId, 7, false) >= 15 && countRefs(_userId, 7, true) >= 2 ) {
            newStatus = 8; // Empire
        }
        if (oldStatus < newStatus) {
            users[_userId].status = newStatus;
            emit StatusUpdate(_userId, oldStatus, newStatus);
        }
        return (oldStatus, newStatus);
    }

    function countToUpline(uint256 _userId, uint256 _refId, uint8 _oldStatus, uint8 _newStatus) internal {
        uint256 uplineId;
        uint256 row = users[_userId].row;
        uint256 col = users[_userId].col;
        col = findUpline(col);
        uplineId = globalPlaces[row.sub(1)][col];
        if (_oldStatus == 0 && _newStatus == 0) {
            refCounts[uplineId][_newStatus] = refCounts[uplineId][_newStatus].add(1);
            if (users[_refId].refId == _userId) {
                refDirCounts[_userId][_newStatus] = refDirCounts[_userId][_newStatus].add(1);
            }
        } else {
            if (refCounts[uplineId][_oldStatus] > 0) {
                refCounts[uplineId][_oldStatus] = refCounts[uplineId][_oldStatus].sub(1);
                if (users[_refId].refId == _userId) {
                    refDirCounts[_userId][_oldStatus] = refDirCounts[_userId][_oldStatus].sub(1);
                }
            }
            refCounts[uplineId][_newStatus] = refCounts[uplineId][_newStatus].add(1);
            if (users[_refId].refId == _userId) {
                refDirCounts[_userId][_newStatus] = refDirCounts[_userId][_newStatus].add(1);
            }
        }
        if (users[uplineId].row > 1) {
            countToUpline(uplineId, _refId, _oldStatus, _newStatus);
        }
        (uint8 oldStatus, uint8 newStatus) = calculateStatus(uplineId);
        if (users[uplineId].row > 1 && oldStatus < newStatus) {
            countToUpline(uplineId, uplineId, oldStatus, newStatus);
        }
    }

    function calculateVipPrice(uint256 _userId) public view returns (uint256) {
        uint256 totalVipPrice = vipPriceNomad;
        if (users[_userId].terraCount == 0) {
            totalVipPrice = vipPriceNomadWoTerra;
        }
        totalVipPrice = totalVipPrice.add(vipPriceTerra.mul(users[_userId].terraCount));
        return totalVipPrice;
    }

    function buyVip(uint8 _count) external payable whenNotPaused notInBl {
        require(msg.sender != address(0), "senderZeroAddress");
        require(userIds[msg.sender] > 0, "userNotRegistered");
        require(_count > 0, "zeroCount");
        require(_count < 2, "onlyOneMonth");
        uint256 vipPrice = calculateVipPrice(userIds[msg.sender]);
        require(vipPrice > 0, "priceError");
        uint256 total = vipPrice.mul(_count);
        require(msg.value >= total, "insufficientAmount");
        uint256 userId = userIds[msg.sender];
        require(users[userId].expire.sub(1209600) < block.timestamp , "buyTooEarly");

        if (msg.value > total) {
            payable(msg.sender).transfer(msg.value.sub(total));
        }

        (bool sent,) = _addressToCom.call{value: total.div(5)}("");
        require(sent, "toComError");

        if (users[userId].row > 2) {
            if (block.timestamp > users[userId].expire) {
                users[userId].expire = block.timestamp.add(term.mul(86400).mul(_count));
            } else {
                users[userId].expire = users[userId].expire.add(term.mul(86400).mul(_count));
            }
        }

        emit BuyVip(userId, users[userId].status, block.timestamp);

        uint256 totalNomad = vipPriceNomad.mul(_count);
        if (users[userId].terraCount == 0) {
            totalNomad = vipPriceNomadWoTerra.mul(_count);
        }
        uint256 toFightPool = totalNomad.div(5);
        if (users[userId].terraCount > 0) {
            toFightPool = toFightPool.add(total.sub(totalNomad).div(5));
            processUplines(userId, total.sub(totalNomad), false);
        }
        fightPool = fightPool.add(toFightPool);
    }

    function sellPlace(uint256 _price, address _forWallet) external whenNotPaused notInBl {
        require(msg.sender != address(0), "zeroAddress");
        uint256 userId = userIds[msg.sender];
        require(users[userId].wallet == msg.sender, "userNotOwnPlace");
        UserForSale memory userForSale = UserForSale({
            price: _price,
            forWallet: _forWallet
        });
        usersForSale[userId] = userForSale;
    }

    // function cancelSellPlace() external whenNotPaused notInBl {
    //     require(msg.sender != address(0), "zeroAddress");
    //     uint256 userId = userIds[msg.sender];
    //     require(users[userId].wallet == msg.sender, "userNotOwnPlace");
    //     require(usersForSale[userId].price > 0, "placeNotOnSale");
    //     delete(usersForSale[userId]);
    // }

    function buyPlace(uint256 _id) external payable whenNotPaused notInBl {
        require(msg.sender != address(0), "zeroAddress");
        require(userIds[msg.sender] == 0, "userRegistered");
        require(usersForSale[_id].price > 0, "placeNotForSale");
        uint256 total = usersForSale[_id].price;
        require(msg.value >= total, "insufficientAmount");
        if (usersForSale[_id].forWallet != address(0)) {
            require(usersForSale[_id].forWallet == msg.sender, "placeNotForWallet");
        }

        if (msg.value > total) {
            payable(msg.sender).transfer(msg.value.sub(total));
        }

        uint256 cms = total.div(10000).mul(990);

        (bool sent,) = _addressToCom.call{value: cms}("");
        require(sent, "toComError");
        
        users[_id].wallet.transfer(total.sub(cms));
        emit PlaceSold(_id, users[_id].wallet, msg.sender, total, block.timestamp);

        delete(userIds[users[_id].wallet]);
        users[_id].wallet = payable(msg.sender);
        userIds[msg.sender] = _id;

        delete(usersForSale[_id]);
    }

    // function buyNomad(uint8 _body) external payable whenNotPaused notInBl {
    //     require(msg.sender != address(0), "senderZeroAddress");
    //     require(userIds[msg.sender] > 0, "userNotRegistered");
    //     uint256 total = nomadPrice;
    //     require(msg.value >= total, "insufficientAmount");
    //     if (msg.value > total) {
    //         payable(msg.sender).transfer(msg.value.sub(total));
    //     }
    //     (bool sent,) = _addressToCom.call{value: total.div(10000).mul(2000)}("");
    //     require(sent, "toComError");
    //     fightPool = fightPool.add(total.div(10000).mul(8000));
    //     INfterriumNomad(nomadNft).mintNomad(msg.sender, _body);
    // }

    function activate(address _refWallet, uint8 _body) external payable whenNotPaused notInBl {
        require(msg.sender != address(0), "senderZeroAddress");
        require(userIds[msg.sender] == 0, "userRegistered");
        require(userIds[_refWallet] != 0, "refUserNotRegistered");
        uint256 _refId = userIds[_refWallet];
        require((_refId > 0 && _refId < type(uint256).max), "invalidReferralId");
        require(users[_refId].wallet != address(0), "invalidReferralId");
        require(lastUserId < type(uint256).max, "registrationLimit");
        uint256 total = nomadPrice;
        require(msg.value >= total, "insufficientAmount");
        (uint256 userRow, uint256 userCol, uint256 newRowLastPlace) = findFreePlace(_refId);
        require((userRow != 0 && userCol != 0), "registrationLimit");

        if (msg.value > total) {
            payable(msg.sender).transfer(msg.value.sub(total));
        }

        (bool sent,) = _addressToCom.call{value: total}("");
        require(sent, "toComError");

        lastUserId = lastUserId.add(1);
        User memory user = User({
            wallet: payable(msg.sender),
            row: userRow,
            col: userCol,
            refId: _refId,
            terraCount: 0,
            lastRow: userRow.add(1),
            status: 0,
            expire: block.timestamp.add(term.mul(86400))
        });
        users[lastUserId] = user;
        userIds[msg.sender] = lastUserId;
        globalPlaces[userRow][userCol] = lastUserId;
        if (users[_refId].lastRow < userRow) {
            users[_refId].lastRow = userRow;
        }
        if (newRowLastPlace > lastFreePlaceInRow[userRow]) {
            lastFreePlaceInRow[userRow] = newRowLastPlace;
        }
        emit Register(
            msg.sender,
            lastUserId,
            userRow,
            userCol,
            _refId,
            block.timestamp
        );
        checkStatus(lastUserId);

        INfterriumNomad(nomadNft).mintNomad(msg.sender, _body);
    }

    function giftTerra(uint256 _id, uint8 _count) external onlyRole(REFEREE_ROLE) {
        require(_count > 0 && _count <= maxTerraBuy, "terraBuyLimit");
        require(_id > 0 && users[_id].wallet != address(0), "userNotRegistered");
        users[_id].terraCount = users[_id].terraCount.add(_count);
        for (uint8 i = 0; i < _count; i++) {
            INfterriumTerra(terraNft).mintTerra(users[_id].wallet);
        }
        checkStatus(_id);
    }

    function giftVip(uint256 _id, uint8 _count) external onlyRole(REFEREE_ROLE) {
        require(_id > 0 && users[_id].wallet != address(0), "userNotRegistered");
        if (users[_id].row > 2) {
            if (block.timestamp > users[_id].expire) {
                users[_id].expire = block.timestamp.add(term.mul(86400).mul(_count));
            } else {
                users[_id].expire = users[_id].expire.add(term.mul(86400).mul(_count));
            }
        }
    }

    function getTerraPrice(uint8 _count) public view returns (uint256, uint256) {
        uint256 total = terraPrice.mul(_count);
        uint256 totalNp = terraPriceNp.mul(_count);
        if (_count == 3) { // Promo 3 terra
            total = total.div(10000).mul(9000);
            totalNp = totalNp.div(10000).mul(8000);
        }
        if (_count == 5) { // Promo 5 terra
            total = total.div(10000).mul(8750);
            totalNp = totalNp.div(10000).mul(7500);
        }
        if (_count == 10) { // Promo 10 terra
            total = total.div(10000).mul(8500);
            totalNp = totalNp.div(10000).mul(7000);
        }
        return (total, totalNp);
    }

    function processSources(uint256 _userId, uint8 _terra) public payable onlyRole(REFEREE_ROLE) {
        require(users[_userId].wallet != address(0), "userNotRegistered");
        sourcesBuyers[_userId] = true;
        if (_terra > 0) {
            sourcesOwners[_userId] = sourcesOwners[_userId].add(_terra);
            checkStatus(_userId);
        }
        if (msg.value > 0) {
            processRef(_userId, msg.value, true);
            processUplines(_userId, msg.value, true);
        }
    }

    function buyTerra(uint8 _count) external payable whenNotPaused notInBl {
        require(msg.sender != address(0), "senderZeroAddress");
        require(userIds[msg.sender] > 0, "userNotRegistered");
        require(_count > 0 && _count <= maxTerraBuy, "terraBuyLimit");
        if (terraLimit > 0) {
            require(users[userIds[msg.sender]].terraCount.add(_count) > terraLimit, "terraUserLimit");
        }
        
        (uint256 total, uint256 totalNp) = getTerraPrice(_count);
        require(msg.value >= total, "insufficientAmount");
        if (msg.value > total) {
            payable(msg.sender).transfer(msg.value.sub(total));
        }

        (bool sent,) = _addressToCom.call{value: total.div(5)}("");
        require(sent, "toComError");

        uint256 userId = userIds[msg.sender];
        // if (users[userId].row > 2 && users[userId].terraCount == 0) {
        //     uint8 vipCount = _count;
        //     if (vipCount > 3) {
        //         vipCount = 3;
        //     }
        //     if (block.timestamp > users[userId].expire) {
        //         users[userId].expire = block.timestamp.add(term.mul(86400).mul(_count));
        //     } else {
        //         users[userId].expire = users[userId].expire.add(term.mul(86400).mul(_count));
        //     }
        // }
        users[userId].terraCount = users[userId].terraCount.add(_count);
        emit BuyTerra(
            msg.sender,
            _count,
            users[userId].row,
            users[userId].col,
            users[userId].refId,
            block.timestamp
        );

        checkStatus(userId);
        processRef(userId, totalNp, false);
        processUplines(userId, totalNp, false);
        fightPool = fightPool.add(total.div(100).mul(15));
        for (uint8 i = 0; i < _count; i++) {
            INfterriumTerra(terraNft).mintTerra(msg.sender);
        }
    }

    function addBattleAwards(uint256[] memory _netIds, uint256[] memory _balances) external onlyRole(REFEREE_ROLE) whenNotPaused {
        require(_netIds.length == _balances.length, "dataLengthNotMatch");
        for (uint256 i = 0; i < _netIds.length; i++) {
            require(users[_netIds[i]].wallet != address(0), "zeroAddress");
            require(fightPool > _balances[i], "fightPoolEmpty");
            balances[_netIds[i]] = balances[_netIds[i]].add(_balances[i]);
            allBalances = allBalances.add(_balances[i]);
            fightPool = fightPool.sub(_balances[i]);
        }
    }

    function withdrawAwards() external whenNotPaused notInBl {
        require(msg.sender != address(0), "senderZeroAddress");
        require(userIds[msg.sender] > 0, "userNotRegistered");
        require(balances[userIds[msg.sender]] > 0, "userBalanceEmpty");
        users[userIds[msg.sender]].wallet.transfer(balances[userIds[msg.sender]]);
        allBalances = allBalances.sub(balances[userIds[msg.sender]]);
        emit BattleAwardSent(userIds[msg.sender], balances[userIds[msg.sender]], block.timestamp);
        balances[userIds[msg.sender]] = 0;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _authorizeUpgrade(address newImplementation) internal onlyRole(UPGRADER_ROLE) override {}
}