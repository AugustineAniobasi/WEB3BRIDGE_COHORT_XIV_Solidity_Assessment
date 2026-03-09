// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../core/VaultStorage.sol";

abstract contract AccessControlModule is VaultStorage {

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }
}