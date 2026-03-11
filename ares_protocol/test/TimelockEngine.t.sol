// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {TimelockEngine} from "../src/modules/TimelockEngine.sol";

contract MockTarget {
    uint256 public value;
    function setValue(uint256 _value) external { value = _value; }
}

contract TimelockEngineTest is Test {
    TimelockEngine timelock;
    MockTarget target;
    uint256 nonce = 1;
    bytes data;
    bytes32 txId;

    function setUp() public {
        timelock = new TimelockEngine();
        target = new MockTarget();
        data = abi.encodeWithSignature("setValue(uint256)", 100);
    }

    function testQueueTransaction() public {
        txId = timelock.queueTransaction(address(target), 0, data, nonce);

       
        (uint256 executeAfter, bool executed) = timelock.queue(txId);

        assertFalse(executed);
        assertTrue(executeAfter > block.timestamp);
    }

    function testExecuteAfterDelay() public {
        txId = timelock.queueTransaction(address(target), 0, data, nonce);
        vm.warp(block.timestamp + 2 days);

        timelock.executeTransaction(address(target), 0, data, nonce);

        assertEq(target.value(), 100);
    }

    function testCannotExecuteBeforeDelay() public {
        txId = timelock.queueTransaction(address(target), 0, data, nonce);
        vm.expectRevert("TIMELOCK_ACTIVE");
        timelock.executeTransaction(address(target), 0, data, nonce);
    }

    function testCannotExecuteTwice() public {
        txId = timelock.queueTransaction(address(target), 0, data, nonce);
        vm.warp(block.timestamp + 2 days);
        timelock.executeTransaction(address(target), 0, data, nonce);

        vm.expectRevert("ALREADY_EXECUTED");
        timelock.executeTransaction(address(target), 0, data, nonce);
    }

    function testCannotExecuteUnqueuedTransaction() public {
        vm.expectRevert("NOT_QUEUED");
        timelock.executeTransaction(address(0x123), 0, "0x", 999);
    }
}