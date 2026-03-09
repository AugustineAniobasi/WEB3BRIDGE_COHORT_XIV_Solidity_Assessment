# Eviction Vault Hardening

## Refactor

The original monolithic contract w:
```
<img width="135" height="308" alt="image" src="https://github.com/user-attachments/assets/590ae376-147d-4cbe-9024-6557a496e7b8" />

- DepositModule
- SafeWithdraw
- MerkleClaimModule
- WithdrawModule
- PausableModule
- VaultStorage

```
## Security Fixes
```
1. setMerkleRoot restricted to owners
2. emergencyWithdrawAll restricted to owners
3. tx.origin removed
4. transfer replaced with call
5. modular architecture implemented
6. pause/unpause restricted
```
## Testing
```
4 positive tests implemented using Foundry.

forge build ✔
forge test ✔
```
