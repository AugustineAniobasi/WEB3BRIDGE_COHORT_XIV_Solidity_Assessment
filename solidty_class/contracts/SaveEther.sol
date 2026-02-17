SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract SaveEther {
	mapping(address => uint) public balances;

	event DepositSuccessful(address indexed sender, uint indexed amount);
	event WIthdrawalSuccessful(address indexed , msg)

	function deposit() external payable {
		require(msg.sender != address(0), "Address zero detected");  // sanity checks
		require(msg.value > 0, "Can't deposit zero value")
		balances[msg.sender] = balances[msg.sender] + msg.value;// balances[msg.sender] += msg.value

		emit DepositSuccessful(msg.sender, msg.value);
	}
	
	function getUserSavings() external view returns (uint256){
		require(msg.sender != address(0), "Address zero detected");  // sanity checks
		require(msg.value > 0, "Can't withdraw zero value");
		require(balances[msg.sender] > 0, "Insufficient funds");
		balances[msg.sender] = balances[msg.sender] - msg.value;
		//to transfer there are three methods
		//transfer, send and call
		(bool result,) = msg.sender.call{value: msg.value}("");
		require(result, "transfer failed");
		emit WithdrawalSuccessful(msg.sender, msg.value);
	}
	receive() external payable {}
	fallback() external {}



}
