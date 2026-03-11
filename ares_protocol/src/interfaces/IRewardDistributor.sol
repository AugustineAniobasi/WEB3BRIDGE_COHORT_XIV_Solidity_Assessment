// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IRewardDistributor {
    function merkleRoot() external view returns (bytes32);
    function hasClaimed(bytes32 root, address account) external view returns (bool);
    function token() external view returns (address);
    function admin() external view returns (address);
    function claim(uint256 amount, bytes32[] calldata proof) external;
    function updateRoot(bytes32 newRoot) external;
}
