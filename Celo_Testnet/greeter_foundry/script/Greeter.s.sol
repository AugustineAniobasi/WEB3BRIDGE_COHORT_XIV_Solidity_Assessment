// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "forge-std/Script.sol";
import "../src/Greeter.sol";

contract DeployGreeter is Script {
    function run() external returns (Greeter greeter) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        greeter = new Greeter();
        vm.stopBroadcast();
    }
}

