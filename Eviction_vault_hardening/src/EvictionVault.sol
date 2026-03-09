// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DepositModule} from "./modules/DepositModule.sol";
import {SafeWithdraw} from "./modules/SafeWithdraw.sol";
import {MerkleClaimModule} from"./modules/MerkleClaimModule.sol";
import {WithdrawModule} from "./modules/WithdrawModule.sol";
import {PausableModule} from "./security/PausableModule.sol";

contract EvictionVault is DepositModule, SafeWithdraw, MerkleClaimModule, WithdrawModule, PausableModule {

    constructor(address[] memory _owners, uint256 _threshold) payable {

        require(_owners.length > 0, "no owners");

        threshold = _threshold;

        for (uint i = 0; i < _owners.length; i++) {

            address o = _owners[i];

            require(o != address(0));

            isOwner[o] = true;

            owners.push(o);
        }

        totalVaultValue = msg.value;
    }
}