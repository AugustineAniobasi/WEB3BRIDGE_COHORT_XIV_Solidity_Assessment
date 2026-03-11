
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