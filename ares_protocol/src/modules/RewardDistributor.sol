// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {IRewardDistributor} from "../interfaces/IRewardDistributor.sol"

contract RewardDistributor is IRewardDistributor {

    bytes32 public merkleRoot;

   
    mapping(bytes32 => mapping(address => bool)) public hasClaimed;

    address public token;
    address public admin;

    constructor(address _token, bytes32 _root) {
        token = _token;
        merkleRoot = _root;
        admin = msg.sender;
    }

    function claim(uint256 amount, bytes32[] calldata proof) external {
        
        require(!hasClaimed[merkleRoot][msg.sender], "ALREADY_CLAIMED_THIS_ROUND");

      
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, amount))));

        bool valid = MerkleProof.verify(proof, merkleRoot, leaf);
        require(valid, "INVALID_PROOF");

       
        hasClaimed[merkleRoot][msg.sender] = true;

       
        bool success = IERC20(token).transfer(msg.sender, amount);
        require(success, "TOKEN_TRANSFER_FAILED");
    }

    function updateRoot(bytes32 newRoot) external {
        require(msg.sender == admin, "NOT_ADMIN");
        merkleRoot = newRoot;
    }
}