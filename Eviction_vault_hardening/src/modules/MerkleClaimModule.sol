// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "../security/AccessControlModule.sol";

abstract contract MerkleClaimModule is AccessControlModule {

    function setMerkleRoot(bytes32 root) external onlyOwner {
        merkleRoot = root;
    }

    function claim(bytes32[] calldata proof, uint256 amount) external {
        require(!paused, "paused");
        require(!claimed[msg.sender], "already claimed");
        

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));

        require(
            MerkleProof.verify(proof, merkleRoot, leaf),
            "invalid proof"
        );

        claimed[msg.sender] = true;

        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "transfer failed");

        totalVaultValue -= amount;
    }
}