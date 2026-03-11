// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {AuthorizationModule} from "../src/modules/AuthorizationModule.sol";

contract AuthorizationModuleTest is Test {

    AuthorizationModule module;

    uint256 signerPrivateKey;
    address signer;

    uint256 attackerPrivateKey;
    address attacker;

    bytes32 proposalId;
    uint256 nonce;
    uint256 deadline;

    function setUp() public {

        signerPrivateKey = 1;
        signer = vm.addr(signerPrivateKey);

        attackerPrivateKey = 2;
        attacker = vm.addr(attackerPrivateKey);

        address[] memory signers = new address[](1);

        signers[0] = signer;

        module = new AuthorizationModule(signers);

        proposalId = keccak256("proposal1");
        nonce = 0;
        deadline = block.timestamp + 1 hours;
    }

    function signApproval(uint256 privateKey,bytes32 _proposalId,uint256 _nonce,uint256 _deadline) internal view returns (bytes memory) {

        bytes32 structHash = keccak256(
            abi.encode(module.APPROVAL_TYPEHASH(),_proposalId,_nonce,_deadline));

        bytes32 digest = keccak256(
            abi.encodePacked("\x19\x01",module.DOMAIN_SEPARATOR(),structHash));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);

        return abi.encodePacked(r, s, v);
    }

    function testValidSignatureApproval() public {

        bytes memory signature = signApproval(signerPrivateKey,proposalId,nonce,deadline);

        bool result = module.verifyApproval(signer,proposalId,nonce,deadline,signature);

        assertTrue(result);
    }

    function testNonceIncrementAfterApproval() public {

        bytes memory signature = signApproval(signerPrivateKey,proposalId,nonce,deadline);

        module.verifyApproval(signer,proposalId,nonce,deadline,signature);

        uint256 newNonce = module.nonces(signer);

        assertEq(newNonce, 1);
    }

    function testInvalidSignature() public {

        bytes memory signature = signApproval(attackerPrivateKey,proposalId,nonce,deadline);

        vm.expectRevert();

        module.verifyApproval(signer,proposalId,nonce,deadline,signature);
    }

    function testUnauthorizedSigner() public {

        bytes memory signature = signApproval(attackerPrivateKey,proposalId,nonce,deadline);

        vm.expectRevert();

        module.verifyApproval(attacker,proposalId,nonce,deadline,signature);
    }

    function testSignatureReplayAttack() public {

        bytes memory signature = signApproval(signerPrivateKey,proposalId,nonce,deadline);

        module.verifyApproval(signer,proposalId,nonce,deadline,signature);

        vm.expectRevert();

        module.verifyApproval(signer,proposalId,nonce,deadline,signature);
    }

    function testExpiredSignature() public {

        uint256 expiredDeadline = block.timestamp - 1;

        bytes memory signature = signApproval(signerPrivateKey,proposalId,nonce,expiredDeadline);

        vm.expectRevert("SIGNATURE_EXPIRED");

        module.verifyApproval(signer,proposalId,nonce,expiredDeadline,signature);
    }

    function testWrongNonce() public {

        bytes memory signature = signApproval(signerPrivateKey,proposalId,5,deadline);

        vm.expectRevert();

        module.verifyApproval(signer,proposalId,5,deadline,signature);
    }

    function testProposalReplayDifferentProposal() public {

        bytes memory signature = signApproval(signerPrivateKey,proposalId,nonce,deadline);

        bytes32 newProposal = keccak256("proposal2");

        vm.expectRevert();

        module.verifyApproval(signer,newProposal,nonce,deadline,signature);
    }
}