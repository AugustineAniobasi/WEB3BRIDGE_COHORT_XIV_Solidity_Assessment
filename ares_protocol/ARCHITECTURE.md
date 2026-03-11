
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
