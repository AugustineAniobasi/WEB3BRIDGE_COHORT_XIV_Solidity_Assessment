// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title ProposalManager
 * @notice Handles creation and tracking of treasury proposals for the ARES Protocol.
 *         Proposals enter a commit phase and cannot be executed immediately.
 */
contract ProposalManager {

///@notice defines the lifecycle of a proposal

    enum ProposalState {
        NONE,
        COMMITTED,
        APPROVED,
        QUEUED,
        EXECUTED,
        CANCELLED
    }

///@notice defines a unique treasury proposal

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


    mapping(bytes32 => Proposal) public proposals;

/// @notice Nonce tracking for each proposer (replay protection)
    mapping(address => uint256) public proposerNonce;



    event ProposalCommitted(bytes32 indexed proposalId,address indexed proposer,address indexed target,uint256 value,bytes data);

    function computeProposalId(address target,uint256 value,bytes memory data,uint256 nonce) public view returns (bytes32) {
        
        return keccak256(abi.encode(target,value,data,nonce,block.chainid));
    }


/**
 * @notice Commit a new proposal to the system
 * @dev Proposals cannot be executed immediately
 */
    function commitProposal(address target,uint256 value,bytes calldata data,uint256 nonce) external returns (bytes32 proposalId) {

        require(nonce == proposerNonce[msg.sender], "INVALID_NONCE");

        proposalId = computeProposalId(target,value,data,nonce);

        require(proposals[proposalId].state == ProposalState.NONE,"PROPOSAL_ALREADY_EXISTS");

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

        emit ProposalCommitted(proposalId,msg.sender,target,value,data);
    }

    function getProposal(bytes32 proposalId) external view returns (Proposal memory)
    {
        return proposals[proposalId];
    }

    function proposalExists(bytes32 proposalId) external view returns (bool)
    {
        return proposals[proposalId].state != ProposalState.NONE;
    }
}