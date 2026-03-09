// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {VaultStorage} from "../core/VaultStorage.sol";

abstract contract SafeWithdraw is VaultStorage {

    event Withdrawal(address indexed user, uint256 amount);

    function withdraw(uint256 amount) external {

        require(!paused, "paused");
        require(balances[msg.sender] >= amount);

        balances[msg.sender] -= amount;
        totalVaultValue -= amount;

        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "transfer failed");

        emit Withdrawal(msg.sender, amount);
    }
}