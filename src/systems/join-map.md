# JOIN-MAP -- dual algorithms into Systems / Slake

**Greppable:** JOIN-MAP, HOST-JOIN-MAP, SLAKE_JOIN_MAP_V0, JOIN-ALG,
JOIN-ALG-USE, joinAlgContractOk, joinAlgUseOk, joinDualCiteOk, ConsumeToken,
ErasedIndex, UnrestrictedShare
**Lean host:** `SystemsLean/JoinMap.lean`
**Still not residual free. Not freestanding product self-host complete.
Not formal dual-bridge proof. Dual trees read-only for this map.**

## Purpose

Name how the three dual JOIN-ALG algorithm examples are **used by Systems /
Slake**, not only cited as dual-side file paths. Dual-cite inventory alone is
not "into Slake." Host use pins live in `joinAlgUseOk`; path inventory lives in
`joinDualCiteOk`. Both fold into `joinAlgContractOk` for compile-path readiness.

---

## Stated map (dual algorithm -> Systems / Slake use)

| Dual algorithm | Host use (Systems Lean; matches joinAlgUseOk) | Product wire (honesty) |
|----------------|-----------------------------------------------|------------------------|
| **ConsumeToken** | `HostCompose` mint/consume live-flag (`hostMintConsumeOnceOk` / `consumeTokenHostUseOk`); empty LinearHost not live. Linear.Token / mkToken / consume / roundTrip stay dual-cite axioms on `Linear.lean` (not joinAlgUseOk pins; noncomputable) | `slake_consume_token_*` / `slake_linear_token_*` via **HOST-EMIT-LINEAR** (`EmitLinear` + `host_emit_linear.ssot.txt`) |
| **ErasedIndex** | `Erasure` mark / `isRuntimeAbsent` / `isErasureGrade` MULT-0 (`erasedIndexHostUseOk`) | `slake_erasure_is_runtime_absent` / `slake_erased` (frozen wire) |
| **UnrestrictedShare** | `Mult` `multOmega` / `name` MULT-OMEGA + `Linear.shareNat` unrestricted sketch (`unrestrictedShareHostUseOk`; shareNat only here) | MULT-OMEGA grade surface (`slake_mult` / `EmitMult` name table) |

**Use vs dual-cite:**

| Evidence class | What it proves | What it does not |
|----------------|----------------|------------------|
| `joinDualCiteOk` | Dual example paths exist under `src/idris2/examples/` and `src/lean4/examples/` (string inventory) | That Systems / Slake implements or walks those duals |
| `joinAlgUseOk` | Host modules Mult / Linear / Erasure / HostCompose are linked into the join bar with behavior pins | Full formal bridge proof or MULT-1 elaborator enforcement |
| Dual trees | Read-only upstream-style examples for meet-in-the-middle honesty | Editable product sources for this residual |

---

## Dual path inventory (read-only)

| Algorithm | Idris side | Lean side |
|-----------|------------|-----------|
| ConsumeToken | `src/idris2/examples/ConsumeToken.idr` | `src/lean4/examples/ConsumeToken.lean` |
| ErasedIndex | `src/idris2/examples/ErasedIndex.idr` | `src/lean4/examples/ErasedIndex.lean` |
| UnrestrictedShare | `src/idris2/examples/UnrestrictedShare.idr` | `src/lean4/examples/UnrestrictedShare.lean` |

Do **not** reimplement duals under `src/systems/`. Do **not** edit dual trees
from Systems residual slices.

---

## Executable composition

- `joinAlgContractOk` = stage/map ids && `joinDualCiteOk` && `joinAlgUseOk`
- `joinUnitCompileReady hc` = `CompilePath.unitCompileReady hc` && `joinAlgContractOk`
- `joinProgramCompileReady p` = `CompilePath.programCompileReady p` && `joinAlgContractOk`
- Sibling bars: empty HostCompose may be unit-ready; empty program is not program-ready

Theorems / smoke: JOIN-MAP-THEOREM / JOIN-MAP-SMOKE in `JoinMap.lean`
(`joinAlgUseOk_true`, `joinAlgContractOk_true`, empty host/program fixtures).

---

## Intentional non-claims

- Not residual free. Not freestanding product self-host complete.
- Not full formal dual-bridge theorems. Not PROVABLY.
- Classic Lean still cannot enforce MULT-1 / LINEAR-EXACT-ONCE.
- Not llvm unlock. Dual residual on Idris side / Lean side remains separate.
