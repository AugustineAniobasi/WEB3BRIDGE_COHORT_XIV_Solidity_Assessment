// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract StudentAttendance {

    struct Student {
        string name;
        uint256 age;
        bool present;
    }

    Student[] public students;

    event StudentAdded(uint256 indexed studentId, string name, uint256 age);
    event AttendanceUpdated(uint256 indexed studentId, bool isPresent);

    function addStudent(string memory _name, uint256 _age) public {
        Student memory newStudent = Student({
            name: _name,
            age: _age,
            present: false
        });

        students.push(newStudent);
        emit StudentAdded(students.length - 1, _name, _age);
    }

    function updateAttendance(uint256 _studentId, bool _isPresent) public {
        require(_studentId < students.length, "Student does not exist");
        students[_studentId].present = _isPresent;
        emit AttendanceUpdated(_studentId, _isPresent);
    }

    function getStudentCount() public view returns (uint256) {
        return students.length;
    }
}
