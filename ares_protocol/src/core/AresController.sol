// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IProposalManager} from "../interfaces/IProposalManager.sol";
import {IAuthorizationModule} from "../interfaces/IAuthorizationModule.sol";
import {ITimelockEngine} from "../interfaces/ITimelockEngine.sol";

contract AresController {
    
    IProposalManager public proposalManager;
    IAuthorizationModule public authModule;
    ITimelockEngine public timelockEngine;

    event ProposalApprovedAndQueued(bytes32 indexed proposalId);
    event ProposalExecuted(bytes32 indexed proposalId);

    constructor(
        address _proposalManager,
        address _authModule,
        address _timelockEngine
    ) {
        proposalManager = IProposalManager(_proposalManager);
        authModule = IAuthorizationModule(_authModule);
        timelockEngine = ITimelockEngine(_timelockEngine);
    }

    function approveAndQueue(
        bytes32 proposalId,
        address signer,
        uint256 deadline,
        bytes calldata signature
    ) external {
        IProposalManager.Proposal memory p = proposalManager.getProposal(proposalId);
        
        require(uint(p.state) == 1, "PROPOSAL_NOT_COMMITTED");

        bool isApproved = authModule.verifyApproval(
            signer,
            proposalId,
            p.nonce,
            deadline,
            signature
        );
        require(isApproved, "AUTHORIZATION_FAILED");

        timelockEngine.queueTransaction(p.target, p.value, p.data, p.nonce);

        proposalManager.updateProposalState(proposalId, 3);

        emit ProposalApprovedAndQueued(proposalId);
    }

    function executeProposal(
        address target,
        uint256 value,
        bytes calldata data,
        uint256 nonce
    ) external {
        bytes32 proposalId = proposalManager.computeProposalId(target, value, data, nonce);
        
        require(proposalManager.proposalExists(proposalId), "PROPOSAL_DOES_NOT_EXIST");

        timelockEngine.executeTransaction(target, value, data, nonce);

        proposalManager.updateProposalState(proposalId, 4);

        emit ProposalExecuted(proposalId);
    }
}