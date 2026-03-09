// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../core/VaultStorage.sol";

abstract contract PausableModule is VaultStorage {

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }
}