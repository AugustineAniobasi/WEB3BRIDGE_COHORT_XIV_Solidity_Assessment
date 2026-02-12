# 🟢 Greeter Smart Contract (Hardhat + Celo Sepolia)

A minimal smart contract written in **Solidity (0.8.30)** that allows users to store and retrieve a message on-chain.

This project demonstrates:

* Smart contract deployment using **Foundry**
* Interaction with contracts on **Celo Sepolia Testnet**
* Proper environment configuration using `.env`
* Basic state management in Solidity

---

## 📜 Contract Overview

The `Greeter` contract allows anyone to:

* Set a message on-chain
* Retrieve the stored message

### Solidity Implementation

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Greeter {
    string public text;

    function setMessage(string memory _text) public {
        text = _text;
    }

    function getMessage() public view returns (string memory) {
        return text;
    }
}
```

---

## 🧠 How It Works

* The contract stores a `string` variable called `text`.
* `setMessage()` updates the stored value.
* `getMessage()` returns the current stored value.
* The `text` variable is declared `public`, meaning Solidity automatically creates a getter function.

---

## 🛠 Tech Stack

![Solidity](https://img.shields.io/badge/Solidity-0.8.30-363636?style=for-the-badge&logo=solidity&logoColor=white)  ![Hardhat](https://img.shields.io/badge/Hardhat-2.28.5-FFF100?style=for-the-badge&logo=hardhat&logoColor=black) ![Celo Sepolia](https://img.shields.io/badge/Celo%20Sepolia-Testnet-35D07F?style=for-the-badge&logo=celo&logoColor=white) ![EVM](https://img.shields.io/badge/EVM-Compatible-627EEA?style=for-the-badge&logo=ethereum&logoColor=white)

---

## 📂 Project Structure

```
greeter_hardhat/
│
├── artifacts/              # Compiled contract artifacts (auto-generated)
├── cache/                  # Hardhat build cache (auto-generated)
│
├── contracts/              # Smart contracts
│   └── greeter.sol
│
├── ignition/               # Hardhat Ignition deployment modules
│   └── modules/
│       └── greeter.ts
│
├── test/                   # Test files (TypeScript)
│   └── greeter.ts
│
├── typechain-types/        #Auto-generated TypeScript contract types
│
├── .env                    # Environment variables (PRIVATE_KEYS, CELO_SEPOLIA_RPC_URL)
├── .gitignore              # Git ignored files
│
├── hardhat.config.ts       # Hardhat configuration file
├── tsconfig.json           # TypeScript configuration
│
├── package.json            # Project dependencies and scripts
├── package-lock.json       # Dependency lock file
│
└── README.md               # Project documentation

```

---

## ⚙️ Installation & Setup

### 1️⃣ Install Hardhat (if not installed)
* Create an empty folder

### 2️⃣ Clone the Repository

```bash
git clone https://github.com/AugustineAniobasi/WEB3BRIDGE_COHORT_XIV_Solidity_Assessment.git

cd ./Celo_Testnet/greeter-hardhat
```

---

### 3️⃣ Install Dependencies

```bash
npm install
```
---

## 🔑 Environment Variables

* Create a `.env` file in the root directory
```
touch .env
```
Add your private key and RPC URL in the .env 
```
PRIVATE_KEY=0xYOUR_PRIVATE_KEY
CELO_SEPOLIA_RPC_URL=https://forno.celo-sepolia.celo-testnet.org
```

⚠️ Never commit your private key.

---

## 🧪 Compile
```
npx hardhat compile
---

## 🚀 Deploying to Celo Sepolia
```
npx hardhat ignition deploy ./ignition/modules/greeter.ts --network celoSepolia
```
## 📍 Deployed Contract Address
```
0xf99145D7c82c8d5b147981cC6D787869623eF2d0
```
## 🔎 View on Block Explorer
```
👉 https://celo-sepolia.blockscout.com/address/0xf99145D7c82c8d5b147981cC6D787869623eF2d0 
```
## 🔎 Interacting With the Contract (Hardhat Console)
```
npx hardhat console --network celoSepolia
```
Then inside the console:
```
const greeter = await ethers.getContractAt(
  "Greeter",
  "0xf99145D7c82c8d5b147981cC6D787869623eF2d0"
);

await greeter.getMessage();
await greeter.setMessage("Hello Celo!");

```

## 🌍 Network Details

* Network: **Celo Sepolia**
* Chain ID: `11142220`
* Public RPC:

  ```
  https://forno.celo-sepolia.celo-testnet.org
  ```

---


## 🤝 Contributing

Contributions are welcome.
Please open an issue first to discuss major changes.

---

## 📜 License

MIT License

---

---
