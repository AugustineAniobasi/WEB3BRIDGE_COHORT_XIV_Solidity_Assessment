// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AccessControlModule} from "../security/AccessControlModule.sol";

abstract contract WithdrawModule is AccessControlModule {

    function emergencyWithdrawAll(address to) external onlyOwner {

        uint256 balance = address(this).balance;

        (bool success,) = to.call{value: balance}("");
        require(success);

        totalVaultValue = 0;
    }
}