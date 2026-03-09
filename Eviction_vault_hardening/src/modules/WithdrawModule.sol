// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../core/VaultStorage.sol";

abstract contract WithdrawModule is VaultStorage {

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    function emergencyWithdrawAll(address to) external onlyOwner {

        uint256 balance = address(this).balance;

        (bool success,) = to.call{value: balance}("");
        require(success);

        totalVaultValue = 0;
    }
}// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../core/VaultStorage.sol";

abstract contract WithdrawModule is VaultStorage {

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    function emergencyWithdrawAll(address to) external onlyOwner {

        uint256 balance = address(this).balance;

        (bool success,) = to.call{value: balance}("");
        require(success);

        totalVaultValue = 0;
    }
}