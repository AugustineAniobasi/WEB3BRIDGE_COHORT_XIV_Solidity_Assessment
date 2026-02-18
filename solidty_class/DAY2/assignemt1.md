
---

## 1. Where Are Structs, Mappings, and Arrays Stored?

In Solidity, data can live in three main locations:

- **Storage** → Permanent blockchain state  
- **Memory** → Temporary during function execution  
- **Calldata** → Read-only input data for external functions  

The storage location of structs, mappings, and arrays depends on **how and where they are declared**.

---

### A. State Variables (Declared at Contract Level)

When structs, mappings, or arrays are declared **outside functions**, they are stored in:

> ✅ **Storage (permanent blockchain state)**

Example:

```solidity
struct User {
    uint id;
    string name;
}

mapping(address => User) public users;
User[] public userList;
````

These are permanently stored on-chain inside the contract’s storage.

* They persist between transactions.
* They cost gas when modified.
* They are part of the contract’s state.

---

### B. Inside Functions

When declared inside a function, the location must be specified (except for mappings).

Example:

```solidity
function example() public {
    User memory tempUser;
}
```

Here:

* `memory` → temporary, erased after execution.
* `storage` → reference to existing state variable.
* `calldata` → external function inputs (read-only).

---

### C. Summary Table

| Declaration Location | Default Storage                      |
| -------------------- | ------------------------------------ |
| Contract-level       | Storage                              |
| Local struct/array   | Must specify (`memory` or `storage`) |
| Mapping              | Always storage                       |

---

## 2. Why Don’t You Need to Specify Memory or Storage With Mappings?

Mappings are special in Solidity.

They:

* Can **only exist in storage**
* Cannot exist in memory
* Cannot exist in calldata
* Cannot be passed around like arrays or structs

This is because mappings are implemented as **hash tables** using a deterministic storage slot calculation.

Internally, a mapping key-value pair is stored as:

```
keccak256(key . slot)
```

This calculation directly references blockchain storage.

Since mappings are tied to storage layout:

> Solidity does not allow mappings in memory.

So you never write:

```solidity
mapping(uint => uint) memory myMap; ❌
```

That is invalid.

Mappings are always:

```solidity
mapping(uint => uint) public myMap; // Storage only
```

---

## 3. How Do Structs, Mappings, and Arrays Behave When Executed or Called?

Their behavior depends on whether they are accessed as:

* Storage references
* Memory copies
* Or calldata inputs

---

### A. Struct Behavior

#### Storage Struct

```solidity
User storage u = users[msg.sender];
```

* `u` is a reference.
* Modifying `u` modifies contract storage directly.
* Changes persist after execution.

#### Memory Struct

```solidity
User memory u = users[msg.sender];
```

* `u` is a copy.
* Changes do NOT affect storage.
* Disappears after function execution.

---

### B. Array Behavior

Arrays behave similarly to structs.

#### Storage Array

```solidity
User[] storage list = userList;
```

* Reference to storage.
* Modifications persist.

#### Memory Array

```solidity
User;
```

* Temporary.
* Does not persist.

---

### C. Mapping Behavior

Mappings:

* Do not store keys explicitly.
* Return default values for non-existing keys.
* Cannot be iterated over.
* Cannot be returned directly from functions.

Example:

```solidity
mapping(address => uint) public balances;
```

If a key was never set:

```solidity
balances[address(0)] → returns 0
```

It does not mean the key exists — just that the default value is returned.

Mappings behave like:

> Deterministic storage lookups, not like arrays.

---
---

```
```

