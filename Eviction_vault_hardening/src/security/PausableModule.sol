// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AccessControlModule} from "../security/AccessControlModule.sol";

abstract contract PausableModule is AccessControlModule {

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }
}