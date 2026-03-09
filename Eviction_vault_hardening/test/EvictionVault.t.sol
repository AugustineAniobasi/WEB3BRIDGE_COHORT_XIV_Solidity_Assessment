// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/EvictionVault.sol";

contract EvictionVaultTest is Test {

    EvictionVault vault;

    address owner1 = address(1);
    address owner2 = address(2);

    function setUp() public {

        address[] memory owners = new address[](2);

        owners[0] = owner1;
        owners[1] = owner2;

        vault = new EvictionVault(owners, 2);
    }

    function testDeposit() public {

        vm.deal(address(this), 10 ether);

        vault.deposit{value: 1 ether}();

        assertEq(vault.balances(address(this)), 1 ether);
    }

    function testWithdraw() public {

        vm.deal(address(this), 10 ether);

        vault.deposit{value: 1 ether}();

        vault.withdraw(0.5 ether);

        assertEq(vault.balances(address(this)), 0.5 ether);
    }

    receive() external payable {}

    function testPause() public {

        vm.prank(owner1);

        vault.pause();

        assertTrue(vault.paused());
    }

    function testSetMerkleRoot() public {

        vm.prank(owner1);

        vault.setMerkleRoot(bytes32(uint256(1)));

        assertEq(vault.merkleRoot(), bytes32(uint256(1)));
    }
}