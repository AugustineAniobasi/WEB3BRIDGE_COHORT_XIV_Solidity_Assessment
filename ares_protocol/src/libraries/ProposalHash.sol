// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title ProposalHash
 * @notice This library hash the proposal details into a single 32 bytes string.
 * @dev compute() ensures a collision-resistant hashing mechanism for treasury actions.
 */

library ProposalHash {
    function compute(address target,uint256 value,bytes memory data,uint256 nonce,uint256 chainId) internal pure returns (bytes32) {

        return keccak256(abi.encode(target,value,data,nonce,chainId));
    }
}