// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Ownable.sol";

contract TestToken is ERC20, Ownable {
    mapping(address => address) private _referrers;
    mapping(address => bool) private _whitelisted;

    constructor() ERC20("testA", "TESTA") {
        _mint(msg.sender, 30000000000 * 10**decimals());
        addToWhitelist(msg.sender);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        // ����������
        require(amount % 10**decimals() == 0, "Transfer amount must be a whole number.");
        // Ǯ�����ٱ���1��
        require(balanceOf(msg.sender) - amount >= 10**decimals(), "Sender must retain at least 1 token.");
        // ת�˳ɹ����Ϊ�����˵ı�������
        _establishReferral(msg.sender, recipient);

        bool success = super.transfer(recipient, amount);
        // ת�˳ɹ������٣�����������
        if (success && !_whitelisted[msg.sender]) {
            _burn(recipient, amount);
        }

        return success;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(amount % 10**decimals() == 0, "Transfer amount must be a whole number.");
        require(balanceOf(sender) - amount >= 10**decimals(), "Sender must retain at least 1 token.");

        _establishReferral(sender, recipient);

        bool success = super.transferFrom(sender, recipient, amount);

        if (success && !_whitelisted[sender]) {
            _burn(recipient, amount);
        }

        return success;
    }

    function addToWhitelist(address account) public onlyOwner {
        _whitelisted[account] = true;
    }

    function removeFromWhitelist(address account) public onlyOwner {
        _whitelisted[account] = false;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisted[account];
    }

    function _establishReferral(address sender, address recipient) private {
        if (_referrers[sender] == address(0) && sender != recipient) {
            _referrers[sender] = recipient;
        }
    }

    function getReferrer(address account) public view returns (address) {
        return _referrers[account];
    }
}
