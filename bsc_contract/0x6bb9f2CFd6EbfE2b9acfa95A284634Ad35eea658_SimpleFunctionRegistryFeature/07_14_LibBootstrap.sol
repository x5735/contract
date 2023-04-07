// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.6.0 <0.9.0;

import "../lib_bytes4/LibRichErrorsV06.sol";
import "../errors/LibProxyRichErrors.sol";

library LibBootstrap {
    /// @dev Magic bytes returned by the bootstrapper to indicate success.
    ///      This is `keccack('BOOTSTRAP_SUCCESS')`.
    bytes4 internal constant BOOTSTRAP_SUCCESS = 0xd150751b;

    using LibRichErrorsV06 for bytes;

    /// @dev Perform a delegatecall and ensure it returns the magic bytes.
    /// @param target The call target.
    /// @param data The call data.
    function delegatecallBootstrapFunction(address target, bytes memory data)
        internal
    {
        (bool success, bytes memory resultData) = target.delegatecall(data);
        if (
            !success ||
            resultData.length != 32 ||
            abi.decode(resultData, (bytes4)) != BOOTSTRAP_SUCCESS
        ) {
            LibProxyRichErrors
                .BootstrapCallFailedError(target, resultData)
                .rrevert();
        }
    }
}