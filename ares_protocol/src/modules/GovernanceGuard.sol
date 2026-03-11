// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract GovernanceGuard {

    uint256 public proposalStake;
    uint256 public maxTreasuryPercent;

    address public treasury;

    mapping(bytes32 => uint256) public stakes;

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
        require( msg.value >= proposalStake, "INSUFFICIENT_STAKE" );

        stakes[proposalId] += msg.value;
    }

    function validateTreasuryOutflow(uint256 amount) external view {

        uint256 treasuryBalance =
            treasury.balance;

        uint256 maxAllowed = (treasuryBalance * maxTreasuryPercent) / 100;

        require( amount <= maxAllowed, "TREASURY_DRAIN_BLOCKED" );
    }

    function releaseStake( bytes32 proposalId, address proposer) external {

        uint256 amount = stakes[proposalId];

        stakes[proposalId] = 0;

        (bool success, ) = payable(proposer).call{value: amount}("");
        require(success, "ETH transfer failed");
        }
}