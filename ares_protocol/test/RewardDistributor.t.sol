// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/modules/RewardDistributor.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("ARES", "ARS") { _mint(msg.sender, 1000 ether); }
}

contract RewardDistributorTest is Test {
    RewardDistributor distributor;
    MockToken token;
    address user = address(0xABC);
    uint256 amount = 100 ether;

    function setUp() public {
        token = new MockToken();
        // Generate a simple root where the user is the only leaf
        // FIX: MUST match the double-hash pattern in RewardDistributor.sol
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(user, amount))));
        distributor = new RewardDistributor(address(token), leaf);
        token.transfer(address(distributor), 500 ether);
    }

    function testClaimReward() public {
        bytes32[] memory proof = new bytes32[](0); // Empty proof because leaf == root

        vm.prank(user);
        distributor.claim(amount, proof);

        assertEq(token.balanceOf(user), amount);
        assertTrue(distributor.hasClaimed(distributor.merkleRoot(), user));
    }

    function testCannotClaimTwice() public {
        bytes32[] memory proof = new bytes32[](0);

        vm.startPrank(user);
        distributor.claim(amount, proof);

        vm.expectRevert("ALREADY_CLAIMED_THIS_ROUND");
        distributor.claim(amount, proof);
        vm.stopPrank();
    }

    function testRevert_InvalidProof() public {
        bytes32[] memory proof = new bytes32[](0);
        
        vm.prank(address(0xBAD)); // Wrong user
        vm.expectRevert("INVALID_PROOF");
        distributor.claim(amount, proof);
    }
}