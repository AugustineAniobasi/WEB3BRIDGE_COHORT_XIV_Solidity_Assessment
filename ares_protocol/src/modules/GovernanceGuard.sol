// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {IGovernanceGuard} from "../interfaces/IGovernanceGuard.sol"

contract GovernanceGuard is IGovernanceGuard {

    uint256 public proposalStake;
    uint256 public maxTreasuryPercent;

    address public treasury;

    mapping(bytes32 => mapping(address => uint256)) public stakes;

    constructor(
        address _treasury,
        uint256 _stake,
        uint256 _maxPercent
    ){
        treasury = _treasury;
        proposalStake = _stake;
        maxTreasuryPercent = _maxPercent;
    }

    function depositStake(bytes32 proposalId) external payable {
        require(msg.value >= proposalStake, "INSUFFICIENT_STAKE");

        stakes[proposalId][msg.sender] += msg.value;
    }

    function validateTreasuryOutflow(uint256 amount) external view {
        uint256 treasuryBalance = treasury.balance;
        uint256 maxAllowed = (treasuryBalance * maxTreasuryPercent) / 100;

        require(amount <= maxAllowed, "TREASURY_DRAIN_BLOCKED");
    }

    function releaseStake(bytes32 proposalId) external {
        
        uint256 amount = stakes[proposalId][msg.sender];
        require(amount > 0, "NO_STAKE_TO_RELEASE");

        stakes[proposalId][msg.sender] = 0;

    
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "ETH transfer failed");
    }
}