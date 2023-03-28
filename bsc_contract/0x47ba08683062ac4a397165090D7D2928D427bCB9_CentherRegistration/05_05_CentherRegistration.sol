// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CentherRegistration is OwnableUpgradeable {
    mapping(address => bool) public isUserRegisteredWithAddress;
    mapping(address => address) public userAddressToReferrerAddress;

    uint256 public registrationFeeWithoutReferrer;
    uint256 public registrationFeeWithReferrer;

    uint8 public constant referralDeep = 6;

    event RegisterWithoutReferrer(address indexed user, uint256 paidAmount);
    event RegisterWithReferrer(
        address indexed user,
        uint256 paidAmount,
        address indexed referrer
    );
    event SetReferrer(
        address indexed referrer,
        address indexed user,
        uint8 level
    );

    bool public _pause;

    address public operator;

    function initialize() public initializer {
        __Ownable_init();
        registrationFeeWithoutReferrer = 0.025 ether;
        registrationFeeWithReferrer = 0 ether;
    }

    function setOperator(address _operator) public onlyOwner {
        operator = _operator;
    }

    function registerWithoutReferrer() external payable {
        require(!_pause, "registration_paused");
        require(
            msg.value >= registrationFeeWithoutReferrer,
            "insufficient_funds"
        );

        require(
            !isUserRegisteredWithAddress[msg.sender],
            "user_already_registered"
        );

        isUserRegisteredWithAddress[msg.sender] = true;

        emit RegisterWithoutReferrer(msg.sender, msg.value);
    }

    function registerWithReferrer(address referrerAddress) external payable {
        require(!_pause, "registration_paused");
        require(msg.value >= registrationFeeWithReferrer, "insufficient_funds");

        require(
            !isUserRegisteredWithAddress[msg.sender],
            "user_already_registered"
        );
        require(
            isUserRegisteredWithAddress[referrerAddress],
            "referrer_not_registered"
        );

        isUserRegisteredWithAddress[msg.sender] = true;
        userAddressToReferrerAddress[msg.sender] = referrerAddress;

        address referrer = msg.sender;
        for (uint8 i = 0; i < referralDeep; i++) {
            address aboveReferrer = userAddressToReferrerAddress[referrer];
            if (aboveReferrer == address(0)) {
                break;
            }
            emit SetReferrer(aboveReferrer, msg.sender, i + 1);
            referrer = aboveReferrer;
        }
        emit RegisterWithReferrer(msg.sender, msg.value, referrerAddress);
    }

    function registerForOwner(address user, address referrerAddress) external {
        require(!_pause, "registration_paused");
        require(msg.sender == operator, "caller_is_not_operator.");

        require(!isUserRegisteredWithAddress[user], "user_already_registered");
        isUserRegisteredWithAddress[user] = true;

        if (referrerAddress == address(0)) {
            emit RegisterWithoutReferrer(user, 0);
        } else {
            require(
                isUserRegisteredWithAddress[referrerAddress],
                "referrer_not_registered"
            );
            userAddressToReferrerAddress[user] = referrerAddress;
            address referrer = user;
            for (uint8 i = 0; i < referralDeep; i++) {
                address aboveReferrer = userAddressToReferrerAddress[referrer];
                if (aboveReferrer == address(0)) {
                    break;
                }
                emit SetReferrer(aboveReferrer, user, i + 1);
                referrer = aboveReferrer;
            }
            emit RegisterWithReferrer(user, 0, referrerAddress);
        }
    }

    // Register multiple users with multiple referrers
    function registerForOwnerBatch(
        address[] calldata users,
        address[] calldata referrerAddresses
    ) external {
        require(!_pause, "registration_paused");
        require(msg.sender == operator, "caller_is_not_operator.");
        require(
            users.length == referrerAddresses.length,
            "users_and_referrers_length_not_match"
        );

        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            address referrerAddress = referrerAddresses[i];
            require(
                !isUserRegisteredWithAddress[user],
                "user_already_registered"
            );
            isUserRegisteredWithAddress[user] = true;

            if (referrerAddress == address(0)) {
                emit RegisterWithoutReferrer(user, 0);
            } else {
                // We can skip this check because we are not sure if the referrer is registered or not,
                // because we are registering multiple users at once.
                // require(
                //     isUserRegisteredWithAddress[referrerAddress],
                //     "referrer_not_registered"
                // );
                userAddressToReferrerAddress[user] = referrerAddress;
                address referrer = user;
                for (uint8 j = 0; j < referralDeep; j++) {
                    address aboveReferrer = userAddressToReferrerAddress[
                        referrer
                    ];
                    if (aboveReferrer == address(0)) {
                        break;
                    }
                    emit SetReferrer(aboveReferrer, user, j + 1);
                    referrer = aboveReferrer;
                }
                emit RegisterWithReferrer(user, 0, referrerAddress);
            }
        }
    }

    function pause() public onlyOwner {
        _pause = true;
    }

    function unPause() public onlyOwner {
        _pause = false;
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "No funds.");
        payable(msg.sender).transfer(address(this).balance);
    }

    function changeFees(
        uint256 feeWithoutReferrer,
        uint256 feeWithReferrer
    ) public onlyOwner {
        registrationFeeWithoutReferrer = feeWithoutReferrer;
        registrationFeeWithReferrer = feeWithReferrer;
    }

    function isRegistered(address _user) external view returns (bool) {
        return isUserRegisteredWithAddress[_user];
    }

    function getReferrerAddresses(
        address _userAddress
    ) external view returns (address[] memory referrerAddresses) {
        address userAddress = _userAddress;

        referrerAddresses = new address[](referralDeep);
        for (uint8 i = 0; i < referralDeep; i++) {
            address referrerAddress = userAddressToReferrerAddress[userAddress];
            referrerAddresses[i] = referrerAddress;
            userAddress = referrerAddress;
        }
    }
}