# Idris side -- multiplicity correspondence (native Quantitative Type Theory)

**Owner:** Idris side under `src/idris2/`.
**Pair:** Lean-side map at `src/lean4/multiplicity-map.md` (read-only for this fork).
**Greppable row ids:** `MULT-0`, `MULT-1`, `MULT-OMEGA` (same ids as Lean side for join).

Upstream cites (read-only):

- `ref/Idris2/docs/source/tutorial/multiplicities.rst`
- `ref/Idris2/docs/source/implementation/overview.rst`
- `ref/Idris2/src/Algebra/ZeroOneOmega.idr` (`Rig0` / `Rig1` / `RigW`)

## Grades (Idris surface)

| Row id | Idris surface | Runtime meaning (honest) |
|--------|---------------|---------------------------|
| MULT-0 | `(0 n : Nat)`, unbound implicits default erased, `{0 a : Type}` | Compile-time only; guaranteed erased at run time; not for free pattern-match unless uniquely determined |
| MULT-1 | `(1 x : a)` | Used **exactly once** at run time (match or apply); post-elaboration LinearCheck |
| MULT-OMEGA | No digit on binder (default); internal `RigW` | Unrestricted copy/drop/reuse (Idris docs: "unrestricted", not the word omega) |

## Syntax seeds

```idris
ignoreN : (0 n : Nat) -> Vect n a -> Nat
useOnce : (1 x : a) -> b
freeUse : Nat -> Nat   -- Nat binder unrestricted by default
```

## Imperfect edges (do not paper over)

| Edge id | Claim |
|---------|--------|
| EDGE-NAME | Systems Lean / join docs say **omega**; Idris users say **unrestricted** / compiler `RigW`. Same three-way shape, different labels. |
| EDGE-PROP | Lean `Prop` erasure is **not** the same mechanism as Idris quantity `0`. |
| EDGE-AFFINE | Systems Lean product talk includes **affine** (at most once). Idris public grades are **0 / exact-once 1 / unrestricted** -- no first-class affine quantity. |
| EDGE-RUNTIME | QTT erasure decides argument presence; stock Idris backends (Chez, RefC, ...) still put a **managed runtime** in the trusted computing base. Not freestanding product C. |
| EDGE-CLASSIC-LEAN | Classic Lean has no full 0/1/unrestricted binder algebra like Idris; Lean side sketches contracts. Systems freestanding path is future product work, not this file. |

## Join aliases (Lean map ids)

Idris keeps EDGE-* names. Lean map uses ERASE-* / RUNTIME-*. Both must stay greppable for coordinator join. Do not rename Lean files from this fork.

| Idris edge | Lean greppable id | Notes |
|------------|-------------------|--------|
| EDGE-PROP | ERASE-PROP | Same imperfect edge: Prop erasure vs mult 0 |
| EDGE-RUNTIME | RUNTIME-CLASSIC (partial) | Stock Idris backends leave managed runtime in the trusted computing base |
| EDGE-CLASSIC-LEAN | RUNTIME-FS (out of scope here); classic Lean binder gap | Freestanding product is `src/systems/`; this file only maps the gap |
| EDGE-NAME | (none on Lean map yet) | Label: omega vs unrestricted / RigW |
| EDGE-AFFINE | (none on Lean map yet) | Affine (at most once) vs Idris exact-once 1 |

## Native dual examples (algorithm ids)

| Algorithm id | Path | Grade focus |
|--------------|------|-------------|
| ConsumeToken | `examples/ConsumeToken.idr` | MULT-1 linear Token + LinearCheck surface |
| ErasedIndex | `examples/ErasedIndex.idr` | MULT-0 erased length/index on Vect |
| UnrestrictedShare | `examples/UnrestrictedShare.idr` | MULT-OMEGA unrestricted copy/drop/multi-use |

Lean duals: same algorithm ids under `src/lean4/examples/`. See `JOIN.md`.

## What this file is not

- Not a completed mathematical isomorphism.
- Not freestanding emit, not PROVABLY CompCert evidence.
- Not permission to invent Lean or `src/systems/` code from the Idris fork.
