// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {ProposalManager} from "../src/modules/ProposalManager.sol";

contract ProposalManagerTest is Test {

    ProposalManager manager;

    address proposer = address(0xABCD);
    address target = address(0x1234);

    function setUp() public {
        manager = new ProposalManager();
    }



    function testCommitProposal() public {

        vm.startPrank(proposer);

        bytes memory data = abi.encodeWithSignature("transfer(address,uint256)",address(0x1),100);

        bytes32 proposalId = manager.commitProposal(
            target,
            0,
            data,
            0
        );

        ProposalManager.Proposal memory proposal = manager.getProposal(proposalId);

        assertEq(proposal.proposer, proposer);
        assertEq(proposal.target, target);
        assertEq(uint(proposal.state), 1); 

        vm.stopPrank();
    }

    function testNonceIncrements() public {

        vm.startPrank(proposer);

        bytes memory data = "call-data";

        manager.commitProposal(
            target,
            0,
            data,
            0
        );

        uint nonce = manager.proposerNonce(proposer);

        assertEq(nonce, 1);

        vm.stopPrank();
    }


    function testCannotReuseNonce() public {

        vm.startPrank(proposer);

        bytes memory data = "call-data";

        manager.commitProposal(
            target,
            0,
            data,
            0
        );

        vm.expectRevert("INVALID_NONCE");

        manager.commitProposal(
            target,
            0,
            data,
            0
        );

        vm.stopPrank();
    }


    function testDuplicateProposalFails() public {

        vm.startPrank(proposer);

        bytes memory data = "call-data";

        manager.commitProposal(
            target,
            0,
            data,
            0
        );

        vm.expectRevert("INVALID_NONCE");

        manager.commitProposal(
            target,
            0,
            data,
            0
        );

        vm.stopPrank();
    }


    function testProposalHashConsistency() public view {

        bytes memory data = "hello";

        bytes32 hash1 =
            manager.computeProposalId(
                target,
                0,
                data,
                0
            );

        bytes32 hash2 =
            manager.computeProposalId(
                target,
                0,
                data,
                0
            );

        assertEq(hash1, hash2);
    }

}