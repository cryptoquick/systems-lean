# Trusted computing base notes -- dual examples (Lean side)

**Examples:**

| Algorithm id | Path |
|--------------|------|
| ConsumeToken | `src/lean4/examples/ConsumeToken.lean` |
| ErasedIndex | `src/lean4/examples/ErasedIndex.lean` |
| UnrestrictedShare | `src/lean4/examples/UnrestrictedShare.lean` |

**Pair:** same algorithm ids under `src/idris2/examples/`, plus `src/idris2/examples/TRUST.md`.

## What is in the trust base if you run classic Lean on these files

- Lean kernel and elaborator
- Lean managed runtime if you ahead-of-time compile a real program that links Lean runtime
- Axiom contracts and defs here do not emit freestanding C

## Pair honesty (Idris side)

Stock Idris 2 typecheck or execute (including the reference-counting C backend, RefC) still places a **managed runtime** in the trusted computing base. RefC is C plus reference-counting support. That is **not** Systems Lean freestanding product C (`out/freestanding-c`).

Both bridge halves are correspondence seeds. Neither is freestanding product evidence.

## What is not claimed

- Freestanding product residual (no Lean runtime on the wire)
- Linear enforcement of `consume` (MULT-1) in classic Lean
- CompCert PROVABLY or LLVM emit
- Identity of Lean `Prop` erasure with Idris multiplicity 0 (ERASE-PROP / EDGE-PROP)

## Map to freestanding bar

| Claim | When true |
|-------|-----------|
| MULT-1 enforced | Systems Lean freestanding checks under `src/systems/` / Slake |
| Runtimeless C | `out/freestanding-c` after freestanding emit |
| Memory safety without garbage collection | Linear/affine product path, not classic Lean ahead-of-time alone |
