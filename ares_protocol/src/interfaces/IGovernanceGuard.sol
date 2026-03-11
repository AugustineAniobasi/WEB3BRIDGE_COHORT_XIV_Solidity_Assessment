// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IGovernanceGuard {
    function proposalStake() external view returns (uint256);
    function maxTreasuryPercent() external view returns (uint256);
    function treasury() external view returns (address);
    function stakes(bytes32 proposalId, address staker) external view returns (uint256);
    function depositStake(bytes32 proposalId) external payable;
    function validateTreasuryOutflow(uint256 amount) external view;
    function releaseStake(bytes32 proposalId) external;
}