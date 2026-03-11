

# **ARES Protocol: Modular Treasury Infrastructure**

**ARES** is a high-security, gas-optimized treasury execution engine built for the **Eviction day 2 test at web3bridge** . Unlike monolithic treasury contracts, ARES utilizes a modular architecture to separate proposal management, cryptographic authorization, and time-delayed execution.

## **Core Architecture**

The protocol is divided into specialized modules to ensure a "Defense in Depth" security model:

* **AresController (Core):** The orchestrator that manages the interaction between all modules and enforces the protocol state machine.
* **ProposalManager:** Handles the lifecycle of treasury actions using deterministic hashing to ensure proposal immutability.
* **AuthorizationModule:** Implements EIP-712 structured signature verification for secure, off-chain governance approvals.
* **TimelockEngine:** A security buffer that enforces a mandatory 48-hour delay before any authorized transaction can be executed.
* **RewardDistributor:** A scalable contributor payment system utilizing Merkle Trees to minimize on-chain storage costs.
* **GovernanceGuard:** A protective layer that requires proposal bonds (stakes) to prevent governance spam and griefing.

---

## **Key Security Features**

* **Anti-Replay Protection:** Unique nonces and ChainID binding in the Authorization layer prevent signatures from being reused or bridged.
* **Hash-Based Execution:** To optimize gas, the Timelock only stores a 32-byte hash. Full data is provided at execution time and verified on-the-fly.
* **Checks-Effects-Interactions:** All state transitions occur before external calls to prevent reentrancy-based treasury drains.
* **Double-Hash Merkle Leaves:** The Reward Distributor uses double-hashing to prevent second-preimage attacks on the Merkle root.

---

## **Getting Started**

### **Prerequisites**

* Foundry installed

### **Installation**

```bash
git clone https://github.com/AugustineAniobasi/WEB3BRIDGE_COHORT_XIV_Solidity_Assessment/tree/main/ares_protocol
cd ares_protocol
forge install

```

### **Build & Test**

Compile the contracts:

```bash
forge build

```

Run the full test suite (including functional and exploit tests):

```bash
forge test -vv

```

---

## **Technical Specifications**

| Component | Standard/Pattern | Purpose |
| --- | --- | --- |
| **Signatures** | EIP-712 | Structured data hashing & signing |
| **Vault** | Timelock | Mandatory execution delay |
| **Scalability** | Merkle Tree | Gas-efficient reward distribution |
| **State Machine** | Enum-based | Proposal lifecycle tracking |

---

## **Project Structure**

```text
src/
├── core/
│   └── AresController.sol      # Protocol Orchestrator
├── interfaces/
│   └── I...                   # Module Interfaces
├── libraries/
│   └── ProposalHash.sol       # Hashing Logic
└── modules/
    ├── AuthorizationModule.sol # EIP-712 Auth
    ├── GovernanceGuard.sol     # Spam Protection
    ├── ProposalManager.sol     # Lifecycle Logic
    ├── RewardDistributor.sol   # Merkle Claims
    └── TimelockEngine.sol      # Delayed Vault

```

---

## **Author**

**Aniobasi Augustine Chimezie** Electrical Engineer & Blockchain Developer

*Web3Bridge Cohort XIV*

---

---
---

# Protocol Lifecycle SPecification

The protocol enforces a strictly linear state machine to ensure no treasury action can bypass security gates. Each state transition is triggered by a specific cryptographic or temporal event.

### Proposal Creation (COMMITTED)
A proposer initiates a transaction by submitting the target, value, and calldata.

* Action: Proposer calls commitProposal() in the ProposalManager.

* Security: The protocol generates a deterministic proposalId using a hash of the parameters and a nonce.

* Result: The state transitions from NONE to COMMITTED. The proposal is now immutable; if the proposer wants to change a single digit, they must start over with a new nonce.

### Approval (APPROVED)
In this phase, authorized governors review the committed proposal off-chain.

* Action: Governors sign the proposalId using their private keys, following the EIP-712 standard.

* Security: The AresController receives this signature and passes it to the AuthorizationModule. The module recovers the signer’s address and verifies it against the authorized signer list.

* Result: If the signature is valid and the nonce matches, the proposal is internally marked as APPROVED within the logic flow.

### Queueing (QUEUED)
Once authorized, the proposal must be moved into the execution pipeline.

* Action: The AresController calls queueTransaction() on the TimelockEngine.

* Security: The Timelock assigns a release timestamp (block.timestamp + MIN_DELAY). Only the Controller can trigger this transition.

* Result: The ProposalManager updates the state to QUEUED. The 48-hour "Security Buffer" begins.

### Execution (EXECUTED)
After the mandatory delay, the proposal is ready for finality.

* Action: Anyone can call executeProposal() on the AresController by providing the original transaction data.

* Security: The protocol re-hashes the provided data and checks it against the txId in the Timelock. It verifies that block.timestamp is greater than executeAfter and less than the GRACE_PERIOD expiration.

* Result: The TimelockEngine performs the low-level .call to the target. The ProposalManager marks the state as EXECUTED.

### Cancellation (CANCELLED)
If a proposal is found to be malicious or incorrect during the COMMITTED or QUEUED phases, it can be stopped.

* Action: An authorized admin or the original proposer (depending on governance rules) calls a cancel function.

* Security: The state is moved to CANCELLED, which permanently prevents the AresController from ever queueing or executing that specific proposalId.

* Result: Any associated "Governance Stake" is handled according to the slashing or refund rules in the GovernanceGuard.