
# ARES Protocol: System Architecture

The ARES Protocol treasury system is built as a modular execution pipeline instead of just one big vault contract. Most treasury setups put all the power in one contract that holds the money and makes the decisions. That's a huge single point of failure where one bug drains everything. To fix this, ARES breaks responsibilities into separate modules that each handle one security check before any money moves. The architecure has five main parts: the Proposal Manager, Authorization Module, Timelock Engine, Reward Distributor, and the Ares Controller (Core). Every treasury action has to go through these stages in order. If one check fails, the whole thing stops, which keeps the funds safe from logic errors.

## Proposal Management
The Proposal Manager handles the start of the lifecycle. When someone wants to move funds, they don't store the huge data on-chain because that's too expensive. Instead, we use a deterministic hash of the target, value, data, and nonce. This keeps the proposal immutable—once it's committed, you can't change the destination or the amount. The manager tracks if a proposal is committed, queued, or executed so we don't have double-spending issues.

## Cryptographic Authorization
The Authorization Module is where the signers actually approve the hashes. We use EIP-712 structured signatures here to stop replay attacks. Each signer has their own nonce, so a signature used on Mainnet can't be reused on a Layer 2 or reused by an attacker. By keeping the signing logic away from the storage logic, we can change how governance works later without breaking the existing proposals.

## Timelock and Execution
Once a proposal is approved, it goes into the Timelock Engine. This is a mandatory 2-day wait period. It’s basically a security buffer so the community can see what’s coming. If a bad proposal somehow gets signed, the 48-hour delay gives everyone time to react before the money is gone. The timelock only stores the "execution time" and a "true/false" flag for execution to save on gas costs.

## The Protocol Core
The Ares Controller (Core) is the orchestrator. It doesn't hold funds; it just talks to the other modules. It checks the Proposal Manager to see if a proposal exists, asks the Auth module if the signature is real, and then tells the Timelock to queue it. This separation means the "brain" of the protocol is tiny and easy to audit, reducing the chance of a major implementation error.

## Scalable Reward Distribution
For paying out contributors, we use the Reward Distributor. Storing thousands of addresses on-chain would cost a fortune in gas. Instead, we use a Merkle Root. The protocol just stores one 32-byte hash, and users provide a "proof" to claim their own tokens. We implemented a double-hash leaf system here to prevent collision attacks, and it tracks claims per-root so we can run multiple reward rounds without state mismatch.

The main goal here is "defense in depth." The Proposal Manager handles identity, the Auth module handles the keys, and the Timelock handles the timing. Because the treasury vault (the Timelock) only listens to the Controller, an attacker can't just bypass governance. Even if signers act weird, the timelock delay provides a window for defensive action. This layered setup is what allows the protocol to manage high-value assets securely.

---
---
# Security Analysis
The ARES treasury setup is built for an adversarial environment where attackers try to find bugs in the code or game the governance process. Since we are managing high-value assets, the design has to stop technical exploits like reentrancy and signature replay while also protecting against economic threats like flash-loan attacks. This section breaks down how we handled those risks.

## Reentrancy and State Integrity
Reentrancy is a huge risk in treasury systems where an external call might let an attacker re-enter a function before the state is updated. We stop this by using the Checks-Effects-Interactions pattern. All proposal state changes (moving a proposal from "Queued" to "Executed") happen before the external .call is made. Because we update the state first, any attempt to re-enter and trigger the same execution twice will fail because the contract already sees it as "Executed."

## Signature Replay & Maleability
Attackers often try to reuse old signatures to authorize the same transaction twice. ARES stops this using three layers:

* Nonces: Every signer has a counter that increases after every use. Once a signature is used, that nonce is spent.

* Chain IDs: We include the block.chainid in the EIP-712 domain. This means a signature for the Ethereum mainnet won't work if someone tries to "replay" it on an L2 like Base or Arbitrum.

* Canonical Recovery: We use OpenZeppelin’s ECDSA library which rejects non-standard signatures, preventing attackers from "tweaking" signature data to bypass checks.

* Timelock Bypass Protections
The Timelock is the final defense. We made sure it can't be bypassed by storing the "execution timestamp" permanently in the contract state. A proposal has to be explicitly queued first. The engine checks the current block.timestamp against the stored executeAfter time. Since this logic depends on the contract's own state and not just the user's input, there's no way to skip the 48-hour wait period.

## Flash-Loan Resistance
Flash loans let people borrow millions of dollars for one transaction to manipulate votes. ARES is immune to this because we don't use "snapshot" voting at the moment of execution. Instead, we rely on cryptographic authorization from pre-set signers. Since a flash loan doesn't give you the private key of an authorized governor, borrowing a bunch of tokens won't help an attacker push a bad proposal thorugh.

Griefing & Spam Control
To prevent "proposal griefing" (where a bot spams the system with thousands of fake proposals), we have the GovernanceGuard. Proposers have to put up a "stake" in ETH to commit a proposal. If they spam the system, their funds stay locked in the mapping. We used a nested mapping stakes[id][proposer] so that people can only withdraw their own money, stopping attackers from stealing stakes.

## Reward Claim Security
For the Reward Distributor, we use Merkle Proofs. A major risk here is "double claiming." We solved this by mapping the hasClaimed status to the specific merkleRoot. This means when the admin updates the root for a new month of rewards, the claim state resets correctly for the new round, but stays locked for the old one. We also used a "double-hash" for the leaf nodes to prevent specialized cryptographic attacks called second-preimage attacks.

No system is 100% perfect. If a majority of the private keys for the governors are stolen, the protocol is in trouble. This is why "Operational Security" (using hardware wallets like Ledger/Trezor) is just as important as the code itself. We also assume the Merkle tree is generated correctly off-chain. If the script that builds the tree has a bug, the wrong people might get paid, though the contract itself would still function exactly as programmed.
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