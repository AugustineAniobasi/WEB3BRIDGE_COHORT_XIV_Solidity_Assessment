// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ITimelockEngine} from "../interfaces/ITimelockEngine.sol";

contract TimelockEngine is ITimelockEngine {

    uint256 public constant MIN_DELAY = 2 days;
    uint256 public constant GRACE_PERIOD = 14 days;

    mapping(bytes32 => QueuedTransaction) public queue;
    address public admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "UNAUTHORIZED_QUEUER");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function setAdmin(address _newAdmin) external onlyAdmin {
        admin = _newAdmin;
    }

    function hashTransaction(address target, uint256 value, bytes calldata data, uint256 nonce) public view returns(bytes32) {
        return keccak256(abi.encode(target, value, data, nonce, block.chainid));
    }

    function queueTransaction(address target, uint256 value, bytes calldata data, uint256 nonce) external onlyAdmin returns(bytes32) {
        bytes32 txId = hashTransaction(target, value, data, nonce);
        require(queue[txId].executeAfter == 0, "ALREADY_QUEUED");

        queue[txId] = QueuedTransaction({
            executeAfter: block.timestamp + MIN_DELAY,
            executed: false
        });

        return txId;
    }

    function executeTransaction(address target, uint256 value, bytes calldata data, uint256 nonce) external {
        bytes32 txId = hashTransaction(target, value, data, nonce);
        QueuedTransaction storage txn = queue[txId];

        require(txn.executeAfter != 0, "NOT_QUEUED");
        require(block.timestamp >= txn.executeAfter, "TIMELOCK_ACTIVE");
        require(block.timestamp <= txn.executeAfter + GRACE_PERIOD, "TRANSACTION_EXPIRED");
        require(!txn.executed, "ALREADY_EXECUTED");

        txn.executed = true;

        (bool success, ) = target.call{value: value}(data);
        require(success, "EXECUTION_FAILED");
    }
}