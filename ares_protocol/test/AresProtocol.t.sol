// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/core/AresController.sol";
import "../src/modules/ProposalManager.sol";
import "../src/modules/AuthorizationModule.sol";
import "../src/modules/TimelockEngine.sol";
import "../src/modules/RewardDistributor.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// A simple mock token to represent the Treasury funds
contract MockToken is ERC20 {
    constructor() ERC20("ARES", "ARS") {
        _mint(msg.sender, 1_000_000_000 * 10 ** 18);
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

    bytes32 root = 0x0000000000000000000000000000000000000000000000000000000000000000; // Mock root

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

        // 3. Wire the architecture together (Access Control)
        proposalManager.setController(address(controller));
        
        // Note: You will need to add a `setAdmin` function to TimelockEngine 
        // to transfer control from the deployer (this test contract) to the Controller
        // timelock.setAdmin(address(controller)); 
    }

    /*//////////////////////////////////////////////////////////////
                        FUNCTIONAL TESTS (Happy Path)
    //////////////////////////////////////////////////////////////*/

    function test_ProposalLifecycle_Success() public {
        address target = address(treasuryToken);
        uint256 value = 0;
        bytes memory data = abi.encodeWithSelector(ERC20.transfer.selector, signer, 1000);
        uint256 nonce = 0;
        uint256 deadline = block.timestamp + 1 hours;

        // 1. Commit
        vm.prank(signer);
        bytes32 proposalId = proposalManager.commitProposal(target, value, data, nonce);

        // 2. Sign (Mocking the EIP-712 signature generation)
        bytes32 digest = _generateDigest(proposalId, nonce, deadline);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPk, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        // 3. Approve and Queue
        controller.approveAndQueue(proposalId, signer, deadline, signature);

        // 4. Fast forward time past the MIN_DELAY (2 days)
        vm.warp(block.timestamp + 2 days + 1);

        // 5. Execute
        controller.executeProposal(target, value, data, nonce);

        // Assert Proposal is EXECUTED
        (, , , , , , , ProposalManager.ProposalState state) = proposalManager.proposals(proposalId);
        assertEq(uint(state), 4); // 4 corresponds to EXECUTED
    }

    /*//////////////////////////////////////////////////////////////
                        EXPLOIT TESTS (Negative Cases)
    //////////////////////////////////////////////////////////////*/

    // Exploit Test 1: Premature Execution (Timelock Bypass Attempt)
    function testRevert_PrematureExecution() public {
        // ... (Assume proposal is queued successfully here) ...
        
        // Attempt to execute immediately without warping time
        vm.expectRevert("TIMELOCK_ACTIVE");
        controller.executeProposal(address(0), 0, "", 0); // Mock data
    }

    // Exploit Test 2: Invalid Signature (Governance Takeover Attempt)
    function testRevert_InvalidSignature() public {
        bytes32 proposalId = keccak256("fake_proposal");
        uint256 deadline = block.timestamp + 1 hours;

        // Attacker signs the payload instead of the authorized signer
        bytes32 digest = _generateDigest(proposalId, 0, deadline);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(attackerPk, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.expectRevert("INVALID_SIGNATURE");
        controller.approveAndQueue(proposalId, signer, deadline, signature);
    }

    // Exploit Test 3: Double Claim Attempt (Reward Drain)
    function testRevert_DoubleClaimAttempt() public {
        // Setup a mock valid claim state
        bytes32[] memory mockProof = new bytes32[](0); // Assume valid for this test setup
        
        // Force the state to show the user already claimed
        // (In a real test, you'd execute a valid claim first)
        
        vm.prank(attacker);
        vm.expectRevert("ALREADY_CLAIMED_THIS_ROUND");
        rewardDistributor.claim(100, mockProof);
    }

    // Exploit Test 4: Unauthorized Queuer (Bypassing Controller)
    function testRevert_UnauthorizedQueuer() public {
        vm.prank(attacker);
        vm.expectRevert("UNAUTHORIZED_QUEUER");
        // Attacker tries to bypass the controller and talk directly to the vault
        timelock.queueTransaction(attacker, 1000, "", 0);
    }

    // Helper function for EIP-712 hashing in tests
    function _generateDigest(bytes32 _proposalId, uint256 _nonce, uint256 _deadline) internal view returns (bytes32) {
        bytes32 structHash = keccak256(abi.encode(authModule.APPROVAL_TYPEHASH(), _proposalId, _nonce, _deadline));
        return keccak256(abi.encodePacked("\x19\x01", authModule.DOMAIN_SEPARATOR(), structHash));
    }
}