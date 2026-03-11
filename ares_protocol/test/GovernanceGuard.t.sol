// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {GovernanceGuard} from "../src/modules/GovernanceGuard.sol";

contract GovernanceGuardTest is Test {
    GovernanceGuard guard;
    address treasury = address(100);
    address user = address(1);
    bytes32 proposalId = keccak256("proposal");

    function setUp() public {
        vm.deal(treasury, 100 ether);
        guard = new GovernanceGuard(treasury, 1 ether, 10);
    }

    function testStakeDeposit() public {
        vm.deal(user, 5 ether);
        vm.prank(user);
        guard.depositStake{value: 1 ether}(proposalId);

        // FIX: Provide both proposalId AND user address for the nested mapping
        assertEq(guard.stakes(proposalId, user), 1 ether);
    }

    function testTreasuryDrainBlocked() public {
        vm.expectRevert("TREASURY_DRAIN_BLOCKED");
        guard.validateTreasuryOutflow(20 ether);
    }

    function testReleaseStake() public {
        vm.deal(user, 1 ether);
        vm.prank(user);
        guard.depositStake{value: 1 ether}(proposalId);

        vm.prank(user);
        guard.releaseStake(proposalId);

        assertEq(guard.stakes(proposalId, user), 0);
        assertEq(user.balance, 1 ether);
    }
}