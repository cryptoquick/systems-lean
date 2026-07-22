# Lean-side multiplicity and erasure map

**Owner:** Lean side (`src/lean4/`).
**Pair:** Idris-side map at `src/idris2/multiplicity-map.md` (same MULT-* row ids).
**Status:** dual-updated against real Idris text. Imperfect edges explicit. Not freestanding. Not PROVABLY.

Related: `doc/divergence.md`, `doc/vocabulary.md`, example `examples/ConsumeToken.lean`, join `JOIN.md`.

## Row ids (greppable)

Use these ids on both bridge halves and in coordinator joins.

| Id | Topic |
|----|--------|
| MULT-0 | Erased / compile-time-only |
| MULT-1 | Use-once / linear |
| MULT-OMEGA | Unrestricted / ordinary data |
| ERASE-PROP | Lean Prop erasure vs Idris mult 0 |
| RUNTIME-CLASSIC | Classic Lean ahead-of-time managed runtime residual |
| RUNTIME-FS | Systems Lean freestanding product goal (out of scope for this workspace to implement) |

## Paired status

| Artifact | Lean side | Idris side |
|----------|-----------|------------|
| Multiplicity map | this file | `src/idris2/multiplicity-map.md` |
| ConsumeToken (MULT-1 focus) | `examples/ConsumeToken.lean` | `examples/ConsumeToken.idr` |
| ErasedIndex (MULT-0 focus) | `examples/ErasedIndex.lean` | `examples/ErasedIndex.idr` |
| UnrestrictedShare (MULT-OMEGA focus) | `examples/UnrestrictedShare.lean` | `examples/UnrestrictedShare.idr` |
| Trust notes | `examples/TRUST.md` | `examples/TRUST.md` |
| Join table | `JOIN.md` | `JOIN.md` |

Idris duals for all three algorithm ids **have landed**. This file tracks correspondence honesty.

## Correspondence (Lean view)

### MULT-0 -- erased

| Side | Story |
|------|--------|
| Idris 2 | Binder multiplicity 0: no runtime presence; surface like `(0 n : Nat)`, `{0 a : Type}` (see Idris map + `ref/Idris2`) |
| Lean 4 (classic) | `Prop` arguments and proof terms are erased at runtime by the compiler; not a full 0/1/omega binder algebra on every binder |
| Systems Lean / Slake goal | Explicit mult 0 on freestanding path |

**Imperfect edge (ERASE-PROP):** A Lean `Prop` proof is not identical to an Idris mult-0 binder in all cases (implicits, proof irrelevance, large-elim restrictions). Do not claim isomorphism of erasure mechanisms -- claim a **working map** with listed exceptions.

### MULT-1 -- use once

| Side | Story |
|------|--------|
| Idris 2 | Multiplicity 1 + LinearCheck; double-use / drop of linear resources fail; surface `(1 t : Token)` |
| Lean 4 (classic) | No full Idris-style linear core on every binder; ownership is library/convention or future Systems Lean checks |
| Systems Lean / Slake goal | Linear/affine checks on freestanding product-relevant resources |

**Imperfect edge:** Classic Lean duals of linear Idris programs are **behavioral sketches** plus comments until Systems Lean mult-1 is the host. This workspace ships Lean 4 sources that state the intended once-use contract; freestanding enforcement is `src/systems/`.

### MULT-OMEGA -- unrestricted

| Side | Story |
|------|--------|
| Idris 2 | Unrestricted quantity (copy/drop freely); users say "unrestricted"; compiler often `RigW` |
| Lean 4 (classic) | Ordinary `Type` values under reference counting in the managed runtime |
| Systems Lean / Slake goal | Multiplicity omega for ordinary data on freestanding path |

**Imperfect edge (RUNTIME-CLASSIC):** Classic Lean ahead-of-time still leaves managed runtime in the trusted computing base. That is not freestanding (RUNTIME-FS).

## Edge crosswalk (Lean ids <-> Idris EDGE-*)

Idris map names imperfect edges `EDGE-*`. Lean keeps historical greppable ids and maps them:

| Lean id | Idris edge id | One-line meaning |
|---------|---------------|------------------|
| ERASE-PROP | EDGE-PROP | Lean `Prop` erasure != Idris quantity 0 mechanism |
| (name note) | EDGE-NAME | Join docs say **omega**; Idris users say **unrestricted** / `RigW` |
| (affine note) | EDGE-AFFINE | Systems product talk includes affine; Idris public grades are 0 / exact-once 1 / unrestricted |
| RUNTIME-CLASSIC | EDGE-RUNTIME (+ EDGE-CLASSIC-LEAN) | Managed runtime in trusted computing base on stock hosts; not freestanding product C |

Keep both naming families greppable until a coordinator join normalizes `doc/divergence.md`.

## What this file does not claim

- Freestanding product residual free of Lean runtime
- CompCert PROVABLY
- Complete formal isomorphism theorem (later, after dual examples stabilize)
- Permission to implement `src/systems/` from the Lean fork

## Next (Lean residual)

See `RESIDUAL-lean.md`. Optional: Lake/check gate; formal map theorems deferred.
