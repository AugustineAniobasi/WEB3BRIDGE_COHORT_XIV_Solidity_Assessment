// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/core/AresController.sol";
import "../src/modules/ProposalManager.sol";
import "../src/modules/AuthorizationModule.sol";
import "../src/modules/TimelockEngine.sol";
import "../src/modules/RewardDistributor.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("ARES", "ARS") {
        _mint(msg.sender, 1_000_000 * 10**18);
    }
}

contract AresProtocolTest is Test {
    AresController controller;
    ProposalManager proposalManager;
    AuthorizationModule authModule;
    TimelockEngine timelock;
    RewardDistributor rewardDistributor;
    MockToken treasuryToken;

    uint256 signerPk = 0xA11CE;
    address signer;
    uint256 attackerPk = 0xB0B;
    address attacker;

    bytes32 root = bytes32(0);

    function setUp() public {
        signer = vm.addr(signerPk);
        attacker = vm.addr(attackerPk);
        treasuryToken = new MockToken();

        // 1. Deploy Modules
        address[] memory signers = new address[](1);
        signers[0] = signer;
        
        authModule = new AuthorizationModule(signers);
        proposalManager = new ProposalManager();
        timelock = new TimelockEngine();
        rewardDistributor = new RewardDistributor(address(treasuryToken), root);

        // 2. Deploy Controller
        controller = new AresController(
            address(proposalManager),
            address(authModule),
            address(timelock)
        );

        // 3. SET PERMISSIONS
        proposalManager.setController(address(controller));
        timelock.setAdmin(address(controller)); // CRITICAL FIX: Transfer admin to Controller

        // Fund Treasury
        treasuryToken.transfer(address(timelock), 100_000 * 10**18);
    }

    function test_ProposalLifecycle_Success() public {
        address target = address(treasuryToken);
        bytes memory data = abi.encodeWithSelector(ERC20.transfer.selector, signer, 100 ether);
        uint256 nonce = 0;
        uint256 deadline = block.timestamp + 1 hours;

        vm.prank(signer);
        bytes32 proposalId = proposalManager.commitProposal(target, 0, data, nonce);

        bytes32 digest = _getEIP712Digest(proposalId, nonce, deadline);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPk, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        controller.approveAndQueue(proposalId, signer, deadline, signature);

        vm.warp(block.timestamp + 2 days + 1);
        controller.executeProposal(target, 0, data, nonce);

        assertEq(treasuryToken.balanceOf(signer), 100 ether);
    }

    function testRevert_PrematureExecution() public {
        vm.expectRevert("PROPOSAL_DOES_NOT_EXIST");
        controller.executeProposal(address(0x1), 0, "", 99);
    }

    function testRevert_InvalidSignature() public {
        bytes32 fakeId = keccak256("fake");
        vm.expectRevert("PROPOSAL_NOT_COMMITTED");
        controller.approveAndQueue(fakeId, signer, block.timestamp + 1 hours, "");
    }

    function _getEIP712Digest(bytes32 pid, uint256 n, uint256 d) internal view returns (bytes32) {
        bytes32 structHash = keccak256(abi.encode(authModule.APPROVAL_TYPEHASH(), pid, n, d));
        return keccak256(abi.encodePacked("\x19\x01", authModule.DOMAIN_SEPARATOR(), structHash));
    }
}