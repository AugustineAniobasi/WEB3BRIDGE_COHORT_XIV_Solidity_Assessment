// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface ITimelockEngine {
    struct QueuedTransaction { 
        uint256 executeAfter;
        bool executed; 
        }
    function MIN_DELAY() external view returns (uint256);
    function GRACE_PERIOD() external view returns (uint256);
    function admin() external view returns (address);
    function queue(bytes32 txId) external view returns (uint256 executeAfter, bool executed);
    function hashTransaction(address target, uint256 value, bytes calldata data, uint256 nonce) external view returns (bytes32);
    function queueTransaction(address target, uint256 value, bytes calldata data, uint256 nonce) external returns (bytes32);
    function executeTransaction(address target, uint256 value, bytes calldata data, uint256 nonce) external;
}