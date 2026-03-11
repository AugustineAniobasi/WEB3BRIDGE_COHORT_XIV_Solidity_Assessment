// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract RewardDistributor {

    bytes32 public merkleRoot;

    mapping(address => bool) public hasClaimed;

    address public token;
    address public owner;

    constructor(address _token, bytes32 _root) {
        token = _token;
        merkleRoot = _root;
        owner = msg.sender;
    }

    function claim(uint256 amount,bytes32[] calldata proof) external {

        require(!hasClaimed[msg.sender], "ALREADY_CLAIMED");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));

        bool valid = MerkleProof.verify(proof,merkleRoot,leaf);

        require(valid, "INVALID_PROOF");

        hasClaimed[msg.sender] = true;

        IERC20(token).transfer(msg.sender, amount);
    }

    function updateRoot(bytes32 newRoot) external {

        require(msg.sender == owner, "NOT_OWNER");

        merkleRoot = newRoot;
    }
}