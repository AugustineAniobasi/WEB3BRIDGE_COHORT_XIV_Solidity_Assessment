// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {RewardDistributor} from "../src/modules/RewardDistributor.sol";

contract MockToken is ERC20 {

    constructor() ERC20("Mock","MOCK") {}

    function mint(address to,uint256 amount) external {
        _mint(to,amount);
    }
}

contract RewardDistributorTest is Test {

    RewardDistributor distributor;
    MockToken token;

    address user = address(1);

    bytes32 root;
    bytes32[] proof;

    function setUp() public {

        token = new MockToken();

        uint256 amount = 100;

        bytes32 leaf = keccak256(abi.encodePacked(user,amount));

        root = leaf;

        distributor = new RewardDistributor(address(token),root);

        token.mint(address(distributor),1000);
    }

    function testClaimReward() public {

        vm.prank(user);

        distributor.claim(100, proof);

        assertEq(token.balanceOf(user),100);
    }

    function testCannotClaimTwice() public {

        vm.startPrank(user);

        distributor.claim(100,proof);

        vm.expectRevert("ALREADY_CLAIMED");

        distributor.claim(100,proof);
    }

    function testInvalidProof() public {

        vm.expectRevert("INVALID_PROOF");

        distributor.claim(200,proof);
    }

    function testUpdateRoot() public {

        bytes32 newRoot = keccak256("new");

        distributor.updateRoot(newRoot);

        assertEq(distributor.merkleRoot(), newRoot);
    }
}