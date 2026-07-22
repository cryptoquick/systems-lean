# Trusted computing base notes -- dual examples (Idris side)

**Examples:**

| Algorithm id | Path |
|--------------|------|
| ConsumeToken | `src/idris2/examples/ConsumeToken.idr` |
| ErasedIndex | `src/idris2/examples/ErasedIndex.idr` |
| UnrestrictedShare | `src/idris2/examples/UnrestrictedShare.idr` |

**Pair:** same algorithm ids under `src/lean4/examples/`, plus `src/lean4/examples/TRUST.md`.

Stock Idris 2 typecheck or execute (including the reference-counting C backend, RefC) still places a **managed runtime** in the trusted computing base. RefC is C plus reference-counting support. That is **not** Systems Lean freestanding product C (`out/freestanding-c`): no garbage collection on the product wire, memory safety from linear/affine discipline under Slake.

Green `idris2 --check` is useful correspondence feedback. It is not freestanding evidence and not PROVABLY CompCert evidence.
