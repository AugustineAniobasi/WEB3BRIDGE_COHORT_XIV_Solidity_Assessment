# Eviction Vault Hardening

## Refactor

The original monolithic contract w:
,,,
- DepositModule
- SafeWithdraw
- MerkleClaimModule
- WithdrawModule
- PausableModule
- VaultStorage

,,,
## Security Fixes
,,,
1. setMerkleRoot restricted to owners
2. emergencyWithdrawAll restricted to owners
3. tx.origin removed
4. transfer replaced with call
5. modular architecture implemented
6. pause/unpause restricted
,,,
## Testing
,,,
4 positive tests implemented using Foundry.

forge build ✔
forge test ✔
,,,