// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Lock {
	// so we have data typed, under value types we have

//	bool keyword;
//	int time;
//	uint age;
//	address owner;
//	address owner;
//	bytes1 by;

//	enum status {
//		onsite,
//		online
//	}

//	//reference tyoes
//	int[] student; // we define an array using square brackets. so you just define the type and then the name of the array and then you put square bracket to indicate that it is an array
//	struct Users { // this is how we define<F8> a struct, we use the struct keyword followed by the name of the struct and then we define the properties of the struct inside
//		string name;
//		uint age;
//	}

	//mapping (uint => Users) Identifier; // this is how we define a mapping, we use the mapping followed by the key type and then the value type. in this case, the key is of type uintand the value is of type Users

	string name; 
	function setName(string memory _name) public {
		name = _name;
	}

	function getName() public view returns (string memory) {
		return name;
	}
}
