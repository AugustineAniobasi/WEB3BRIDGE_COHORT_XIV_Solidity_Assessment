// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title ProposalHash
 * @notice ensures a collision-resistant hashing mechanism for treasury actions.
 * @dev This library implements a deterministic hashing function to represent unique treasury proposals
 */

library ProposalHash {
    function compute(address target,uint256 value,bytes memory data,uint256 nonce,uint256 chainId) internal pure returns (bytes32) {

        return keccak256(abi.encode(target,value,data,nonce,chainId));
    }
}