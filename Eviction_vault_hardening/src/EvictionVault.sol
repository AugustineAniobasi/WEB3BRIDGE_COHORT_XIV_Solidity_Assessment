// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./modules/DepositModule.sol";
import "./modules/SafeWIthdraw.sol";
import "./modules/MerkleClaimModule.sol";
import "./modules/WithdrawModule.sol";
import "./security/PausableModule.sol";

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