// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IProposalManager {

    function commitProposal(address target,uint256 value,bytes calldata data,uint256 nonce) external returns (bytes32);
}