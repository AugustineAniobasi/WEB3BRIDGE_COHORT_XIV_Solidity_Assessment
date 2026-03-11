// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IProposalManager} from "../interfaces/IProposalManager.sol";

contract ProposalManager is IProposalManager {

    mapping(bytes32 => Proposal) public proposals;
    mapping(address => uint256) public proposerNonce;
    
    address public controller;

    function setController(address _controller) external {
        require(controller == address(0), "CONTROLLER_ALREADY_SET");
        controller = _controller;
    }

    function computeProposalId(address target, uint256 value, bytes memory data, uint256 nonce) public view returns (bytes32) {
        return keccak256(abi.encode(target, value, data, nonce, block.chainid));
    }

    function commitProposal(address target, uint256 value, bytes calldata data, uint256 nonce) external returns (bytes32 proposalId) {
        require(nonce == proposerNonce[msg.sender], "INVALID_NONCE");

        proposalId = computeProposalId(target, value, data, nonce);
        require(proposals[proposalId].state == ProposalState.NONE, "PROPOSAL_ALREADY_EXISTS");

        proposals[proposalId] = Proposal({
            proposer: msg.sender,
            proposalId: proposalId,
            target: target,
            value: value,
            data: data,
            nonce: nonce,
            timestamp: block.timestamp,
            state: ProposalState.COMMITTED
        });

        proposerNonce[msg.sender]++;
        emit ProposalCommitted(proposalId, msg.sender, target, value, data);
    }

    function updateProposalState(bytes32 proposalId, uint8 newState) external {
        require(msg.sender == controller, "ONLY_CONTROLLER");
        require(proposals[proposalId].state != ProposalState.NONE, "DOES_NOT_EXIST");
        proposals[proposalId].state = ProposalState(newState);
    }

    function getProposal(bytes32 proposalId) external view returns (Proposal memory) {
        return proposals[proposalId];
    }

    function proposalExists(bytes32 proposalId) external view returns (bool) {
        return proposals[proposalId].state != ProposalState.NONE;
    }
}