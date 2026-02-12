# 🟢 Greeter Smart Contract
## 🌐 Live Deployment

Contract deployed on **Celo Sepolia**  
Address: `0x19677500406657E4F835F6A101685a1186515d2F`


A minimal smart contract written in **Solidity (0.8.30)** that allows users to store and retrieve a message on-chain.

This project demonstrates:

* Smart contract deployment using **foundry**
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

![Solidity](https://img.shields.io/badge/Solidity-0.8.30-363636?style=for-the-badge&logo=solidity&logoColor=white)  ![Foundry](https://img.shields.io/badge/Foundry-Forge-000000?style=for-the-badge)
![Celo Sepolia](https://img.shields.io/badge/Celo%20Sepolia-Testnet-35D07F?style=for-the-badge&logo=celo&logoColor=white) ![EVM](https://img.shields.io/badge/EVM-Compatible-627EEA?style=for-the-badge&logo=ethereum&logoColor=white)

---

## 📂 Project Structure

```
greeter_foundry/
│
├── .github/               # GitHub workflows (CI/CD, automation)
│
├── broadcast/             # Deployment transaction data (auto-generated)
├── cache/                 # Foundry build cache (auto-generated)
├── out/                   # Compiled contract artifacts (auto-generated)
│
├── lib/                   # External dependencies (forge-std, etc.)
│
├── script/                # Deployment scripts
│   └── Greeter.s.sol
│
├── src/                   # Smart contracts
│   └── Greeter.sol
│
├── test/                  # Test files
│   └── Greeter.t.sol
│
├── .env                   # Environment variables (PRIVATE_KEY, RPC_URL)
├── .gitignore             # Ignored files for Git
├── .gitmodules            # Git submodules (dependencies)
│
├── foundry.toml           # Foundry configuration file
├── foundry.lock           # Dependency lock file
│
└── README.md              # Project documentation

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

cd ./Celo_Testnet/greeter-foundry
```

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
forge script script/Greeter.s.sol:DeployGreeter \
--rpc-url https://forno.celo-sepolia.celo-testnet.org \
--broadcast \
-vv

```
If using environment variables
```
source .env
forge script script/Greeter.s.sol:DeployGreeter \
--rpc-url $CELO_SEPOLIA_RPC_URL \
--broadcast \
-vv

```
## 📍 Deployed Contract Address
```
0x19677500406657E4F835F6A101685a1186515d2F
```
## 🔎 View on Block Explorer
```
👉 https://celo-sepolia.blockscout.com/address/0x19677500406657E4F835F6A101685a1186515d2F 
```
## 🔎 Interacting With the Contract (foundry Console)
Read the stored message
```
cast call <DEPLOYED_CONTRACT_ADDRESS> \
"getMessage()(string)" \
--rpc-url https://forno.celo-sepolia.celo-testnet.org

```
Update the message
```
cast send <DEPLOYED_CONTRACT_ADDRESS> \
"setMessage(string)" "Hello Celo!" \
--private-key $PRIVATE_KEY \
--rpc-url https://forno.celo-sepolia.celo-testnet.org

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
