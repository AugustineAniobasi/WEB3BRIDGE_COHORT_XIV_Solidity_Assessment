// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract TimelockEngine {

    uint256 public constant MIN_DELAY = 2 days;

    struct QueuedTransaction {
        address target;
        uint256 value;
        bytes data;
        uint256 executeAfter;
        bool executed;
    }

    mapping(bytes32 => QueuedTransaction) public queue;

    function hashTransaction(address target,uint256 value,bytes calldata data,uint256 nonce) public view returns(bytes32) {

        return keccak256(abi.encode(target,value,data,nonce,block.chainid));
    }

    function queueTransaction(address target,uint256 value,bytes calldata data,uint256 nonce) external returns(bytes32){

        bytes32 txId = hashTransaction(target,value,data,nonce);

        require(queue[txId].executeAfter == 0,"ALREADY_QUEUED");

        uint256 executeTime = block.timestamp + MIN_DELAY;

        queue[txId] = QueuedTransaction({
            target: target,
            value: value,
            data: data,
            executeAfter: executeTime,
            executed: false
        });

        return txId;
    }

    function executeTransaction(bytes32 txId) external {

        QueuedTransaction storage txn = queue[txId];

        require(txn.executeAfter != 0,"NOT_QUEUED");

        require(block.timestamp >= txn.executeAfter,"TIMELOCK_ACTIVE");

        require(!txn.executed,"ALREADY_EXECUTED");

        txn.executed = true;

        (bool success,) = txn.target.call{value: txn.value}(txn.data);

        require(success,"EXECUTION_FAILED");
    }
}