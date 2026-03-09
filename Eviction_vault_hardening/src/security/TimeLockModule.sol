// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../core/VaultStorage.sol";

abstract contract TimelockModule is VaultStorage {

    modifier timelockPassed(uint256 txId) {
        Transaction storage txn = transactions[txId];

        require(
            block.timestamp >= txn.executionTime,
            "timelock active"
        );

        _;
    }
}