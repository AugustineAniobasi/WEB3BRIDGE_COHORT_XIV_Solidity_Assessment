// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {TimelockEngine} from "../src/modules/TimelockEngine.sol";

contract MockTarget {
    uint256 public value;

    function setValue(uint256 _value) external {
        value = _value;
    }
}

contract TimelockEngineTest is Test {

    TimelockEngine timelock;
    MockTarget target;

    uint256 nonce;
    bytes data;
    bytes32 txId;

    function setUp() public {

        timelock = new TimelockEngine();
        target = new MockTarget();

        nonce = 1;

        data = abi.encodeWithSignature("setValue(uint256)",100);
    }

  
    function testQueueTransaction() public {

        txId = timelock.queueTransaction(address(target),0,
            data,nonce);

        (address storedTarget,uint256 value,bytes memory storedData,uint256 executeAfter,bool executed) = timelock.queue(txId);

        

        assertEq(storedTarget, address(target));
        assertEq(value, 0);
        assertFalse(executed);
        assertTrue(executeAfter > block.timestamp);
    }

    function testExecuteAfterDelay() public {

        txId = timelock.queueTransaction(address(target),0,data,nonce);

        vm.warp(block.timestamp + 2 days);

        timelock.executeTransaction(txId);

        assertEq(target.value(), 100);
    }

 

    function testCannotExecuteBeforeDelay() public {

        txId = timelock.queueTransaction(address(target),0,data,nonce);

        vm.expectRevert("TIMELOCK_ACTIVE");

        timelock.executeTransaction(txId);
    }

    function testCannotExecuteTwice() public {

        txId = timelock.queueTransaction(address(target),0,data,nonce);

        vm.warp(block.timestamp + 2 days);

        timelock.executeTransaction(txId);

        vm.expectRevert("ALREADY_EXECUTED");

        timelock.executeTransaction(txId);
    }

    function testCannotExecuteUnqueuedTransaction() public {

        bytes32 fakeTx = keccak256("fake");

        vm.expectRevert("NOT_QUEUED");

        timelock.executeTransaction(fakeTx);
    }

    function testCannotQueueDuplicateTransaction() public {

        timelock.queueTransaction(address(target),0,data,nonce);

        vm.expectRevert("ALREADY_QUEUED");

        timelock.queueTransaction(address(target),0,data,nonce);
    }

    function testTransactionHashConsistency() public view {

        bytes32 hash1 = timelock.hashTransaction(address(target),0,data,nonce);

        bytes32 hash2 = timelock.hashTransaction(address(target),0,data,nonce);

        assertEq(hash1, hash2);
    }
}