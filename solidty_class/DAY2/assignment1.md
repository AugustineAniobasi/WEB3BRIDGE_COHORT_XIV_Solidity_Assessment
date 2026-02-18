## Where are structs, mappings, and arrays stored?
```

Structs, mappings, and arrays are stored according to where and how they are declared in a Solidity contract. When declared at the contract level (outside any function), they are automatically stored in **storage**, which represents the permanent blockchain state and persists across transactions. These state variables consume gas when modified and remain part of the contract’s state indefinitely. When structs or arrays are declared inside functions, their data location must be explicitly specified as either `memory` (temporary and erased after execution) or `storage` (a reference to an existing state variable). Mappings are an exception: they can only exist in storage and cannot be declared in memory or calldata.
```
---

## How do structs, mappings, and arrays behave when executed or called?
```
The behavior of these data structures during execution depends on whether they are accessed as storage references or memory copies. When a struct or array is declared as `storage`, it acts as a reference to the contract’s persistent state, meaning that any modifications directly update the blockchain and persist after execution. When declared as `memory`, it becomes a temporary copy, and changes made to it do not affect the stored state. Mappings behave differently from arrays and structs: they always reference storage and function as deterministic key-to-value lookups. They do not store keys explicitly, cannot be iterated over, and return default values (e.g., `0` for `uint`) when a key has not been set.
```
---

## Why don’t you need to specify memory or storage with mappings?
```
Mappings do not require (and do not allow) explicit `memory` or `storage` specifiers because they are inherently tied to blockchain storage. Internally, mappings are implemented using a deterministic hash-based storage slot calculation, where each value is stored at a location derived from `keccak256(key, slot)`. This design directly links mappings to persistent storage layout, making it impossible to create temporary or in-memory versions of them. As a result, Solidity enforces that mappings exist only in storage, which is why developers never specify a data location for them.
```
