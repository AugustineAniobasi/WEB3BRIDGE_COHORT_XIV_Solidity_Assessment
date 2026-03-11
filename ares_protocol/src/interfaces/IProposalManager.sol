// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IProposalManager {

    enum ProposalState {
        NONE,
        COMMITTED,
        APPROVED,
        QUEUED,
        EXECUTED,
        CANCELLED
    }

    struct Proposal {
        address proposer;
        bytes32 proposalId;
        address target;
        uint256 value;
        bytes data;
        uint256 nonce;
        uint256 timestamp;
        ProposalState state;
    }

    event ProposalCommitted(bytes32 indexed proposalId,address indexed proposer,address indexed target,uint256 value,bytes data);

    function proposals(bytes32 proposalId) external view returns ( address proposer, bytes32 id, address target, uint256 value, bytes memory data, uint256 nonce, uint256 timestamp,ProposalState state);

    function proposerNonce(address proposer) external view returns (uint256);

    function setController(address _controller) external;
    
    function updateProposalState(bytes32 proposalId, uint8 newState) external;

    function computeProposalId(address target, uint256 value, bytes memory data, uint256 nonce ) external view returns (bytes32);

    function commitProposal( address target, uint256 value, bytes calldata data, uint256 nonce ) external returns (bytes32 proposalId);

    function getProposal(bytes32 proposalId) external view returns (Proposal memory);

    function proposalExists(bytes32 proposalId) external view returns (bool);
}