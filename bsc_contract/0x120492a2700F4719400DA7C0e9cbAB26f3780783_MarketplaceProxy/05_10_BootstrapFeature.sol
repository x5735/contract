// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.6.0 <0.9.0;

import "../lib_bytes4/LibRichErrorsV06.sol";
import "../migrations/LibBootstrap.sol";
import "../storage/LibProxyStorage.sol";
import "./interfaces/IBootstrapFeature.sol";

/// @dev Detachable `bootstrap()` feature.
contract BootstrapFeature is IBootstrapFeature {
    // solhint-disable state-visibility,indent
    /// @dev The ZeroEx contract.
    ///      This has to be immutable to persist across delegatecalls.
    address private immutable _deployer;
    /// @dev The implementation address of this contract.
    ///      This has to be immutable to persist across delegatecalls.
    address private immutable _implementation;
    /// @dev The deployer.
    ///      This has to be immutable to persist across delegatecalls.
    address private immutable _bootstrapCaller;
    // solhint-enable state-visibility,indent

    using LibRichErrorsV06 for bytes;

    /// @dev Construct this contract and set the bootstrap migration contract.
    ///      After constructing this contract, `bootstrap()` should be called
    ///      to seed the initial feature set.
    /// @param bootstrapCaller The allowed caller of `bootstrap()`.
    constructor(address bootstrapCaller) public {
        _deployer = msg.sender;
        _implementation = address(this);
        _bootstrapCaller = bootstrapCaller;
    }

    /// @dev Bootstrap the initial feature set of this contract by delegatecalling
    ///      into `target`. Before exiting the `bootstrap()` function will
    ///      deregister itself from the proxy to prevent being called again.
    /// @param target The bootstrapper contract address.
    /// @param callData The call data to execute on `target`.
    function bootstrap(address target, bytes calldata callData)
        external
        override
    {
        // Only the bootstrap caller can call this function.
        if (msg.sender != _bootstrapCaller) {
            LibProxyRichErrors
                .InvalidBootstrapCallerError(msg.sender, _bootstrapCaller)
                .rrevert();
        }
        // Deregister.
        LibProxyStorage.getStorage().impls[this.bootstrap.selector] = address(
            0
        );
        // Self-destruct.
        BootstrapFeature(_implementation).die();
        // Call the bootstrapper.
        LibBootstrap.delegatecallBootstrapFunction(target, callData);
    }

    /// @dev Self-destructs this contract.
    ///      Can only be called by the deployer.
    function die() external {
        assert(address(this) == _implementation);
        if (msg.sender != _deployer) {
            LibProxyRichErrors
                .InvalidDieCallerError(msg.sender, _deployer)
                .rrevert();
        }
        selfdestruct(payable(msg.sender));
    }
}