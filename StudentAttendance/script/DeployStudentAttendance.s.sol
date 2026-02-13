// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/StudentAttendance.sol";

contract DeployStudentAttendance is Script {
    function run() external returns (StudentAttendance deployed) {
        // Start broadcasting transactions using your private key
        vm.startBroadcast();

        deployed = new StudentAttendance();

        vm.stopBroadcast();
    }
}
