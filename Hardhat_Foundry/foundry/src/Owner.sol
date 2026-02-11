// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Owner {
    address public owner;

    constructor() {
        owner =msg.sender;
    }

    function changeOwner(address newOwner) public {
        require(msg.sender == owner, "Only the owner can change the owner");
        owner = newOwner;
    }

    function getOwner() public view returns (address){
        return owner;
    }

}
