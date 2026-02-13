# 🟢 StudentAttendance Smart Contract
## 🌐 Live Deployment

Contract deployed on **Core Blockchain Testnet2**  
Contract Address:0xf99145D7c82c8d5b147981cC6D787869623eF2d0


A StudentAttendance  smart contract written in **Solidity (0.8.28)** that allows students to mark attendance.

This project demonstrates:

* Smart contract deployment using **foundry**
* Interaction with contracts on **Core Blockchain Testnet2**
* Proper environment configuration using `.env`
* Basic state management in Solidity

---

## 📜 Contract Overview

The `StudentAttendance` contract allows student to:

* Allows students mark attendance
* Update students attendance
* Gets the total number of student that signs attendance

### Solidity Implementation

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

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
```

---

## 🧠 How It Works

* The contract marks the attendance of a student by:
* `Student`: A struct that takes the name of student, age and the present attendance status of student
* `addStudent()` Add a student name to the attendance registry and by default set its present status to false
* 'UpdateAttendance` Changes the student present status to true to mark the students attendance.
* `getStudentCount` Return the total number of students.

---

## 🛠 Tech Stack

![Solidity](https://img.shields.io/badge/Solidity-0.8.30-363636?style=for-the-badge&logo=solidity&logoColor=white)  ![Foundry](https://img.shields.io/badge/Foundry-Forge-000000?style=for-the-badge)![Core Testnet2](https://img.shields.io/badge/Core-Testnet2-111111?style=for-the-badge&logo=blockchain&logoColor=white)
![EVM](https://img.shields.io/badge/EVM-Compatible-627EEA?style=for-the-badge&logo=ethereum&logoColor=white)

---

## 📂 Project Structure

```
StudentAttendance/
│
├── .github/                     # GitHub workflows (CI/CD automation)
│   └── workflows/
│       └── test.yml
│
├── broadcast/                   # Deployment broadcast logs
│   └── DeployStudentAttendance.s.sol/
│
├── cache/                       # Foundry cache files
│
├── lib/                         # External dependencies (e.g., forge-std)
│   └── forge-std/
│
├── out/                         # Compiled contract artifacts
│
├── script/                      # Deployment scripts
│   └── DeployStudentAttendance.s.sol
│
├── src/                         # Smart contracts source files
│   └── StudentAttendance.sol
│
├── test/                        # Unit tests
|
│
├── .env                         # Environment variables (PRIVATE_KEY, CORE_TESTNET2_RPC_URL)
├── .gitignore                   # Git ignored files
├── .gitmodules                  # Submodule references
├── foundry.lock                 # Dependency lock file
├── foundry.toml                 # Foundry configuration file
└── README.md                    # Project documentation

```

---

## ⚙️ Installation & Setup

### 1️⃣ Install foundry (if not installed)
```
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2️⃣ Clone the Repository

```bash
git clone https://github.com/AugustineAniobasi/WEB3BRIDGE_COHORT_XIV_Solidity_Assessment.git

cd ./StudentAttendance/
```
---

### 3️⃣ Install Dependencies

```bash
forge install
```
---

## 🔑 Environment Variables

* Create a `.env` file in the root directory
```bash
touch .env
```
* Add your private key and RPC URL in the .env 
```
PRIVATE_KEY=0xYOUR_PRIVATE_KEY
CELO_SEPOLIA_RPC_URL=https://forno.celo-sepolia.celo-testnet.org
```

⚠️ Never commit your private key.

---

## 🧪 Running test
```
forge test -vv
---

## 🚀 Deploying to Celo Sepolia
```
forge script script/Greeter.s.sol:DeployStudentAttendance \
--rpc-url https://rpc.test2.btcs.network
--broadcast \
-vv

```
If using environment variables
```
source .env
forge script script/Greeter.s.sol:DeployGreeter \
--rpc-url $CORE_TESTNET2_RPC_URL \
--broadcast \
-vv

```
## 📍 Deployed Contract Address
```
0xf99145D7c82c8d5b147981cC6D787869623eF2d0
```
## 🔎 View on Block Explorer
```
👉 https://scan.test2.btcs.network/address/0xf99145d7c82c8d5b147981cc6d787869623ef2d0 
```
## 🔎 Interacting With the Contract (foundry Console)
Read the stored message
```

```

## 🌍 Network Details

* Network: **Core Blockchain Testnet2**
* Chain ID: `1114`
* Public RPC:

    https://rpc.test2.btcs.network

---

## 📜 License

MIT License
