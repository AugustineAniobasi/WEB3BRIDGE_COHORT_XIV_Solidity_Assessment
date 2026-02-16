// SPDX-LIcense-Identifier: MIT
pragma solidity ^0.8.3;

contract Todo {
	
	struct Task {
	uint8 id;
	string title;
	bool isComplete;
	uint256 time_completed;
	}

	Task[] public tasks;
	uint todo_id;


	function createTask(string memory _title) external {
	uint8 id = todo_id + 1; //todo_id = todo_id + 1
	Task memory task = Task({id: id, title: _title. isComplete:false, time_completed: 0})//id: todo_id
	tasks.push(task);	
	
	}

	function getAllTasks() external view returns(Task[] memory){
		return tasks;
	}

	function markComplete(uint8 _id)external {
		for (uint8 i; i < tasks.length; i++){
			if (tasks[i].id == _id){
				tasks[i].isComplete = true;
				tasks[i].time_completed = block.timestamp;
			}	
		}
	}

	function deleteTask()external{
		for (uint8 i; i < tasks.length; i++){
			if(tasks[i].id == _id){
				tasks[i] = tasks[tasks.length - 1];
				tasks.pop();
			}
		}
	
	}








}
