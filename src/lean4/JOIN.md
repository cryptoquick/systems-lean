# Lean-side join points (for coordinator)

Greppable one-liners. Update when this workspace lands slices. Residual board: `RESIDUAL-lean.md`.

| Id | Path | Claim (honest) |
|----|------|----------------|
| MULT-MAP | `src/lean4/multiplicity-map.md` | Lean-side MULT-0/1/OMEGA map + edges ERASE-PROP, RUNTIME-CLASSIC + crosswalk to Idris EDGE-* |
| EX-CONSUME | `src/lean4/examples/ConsumeToken.lean` | Classic Lean dual of algorithm ConsumeToken (shareNat, Token, mkToken, consume, roundTrip, polyId); not freestanding |
| EX-TRUST | `src/lean4/examples/TRUST.md` | Trusted computing base notes for EX-CONSUME; pairs Idris TRUST |
| JOIN-ALG | algorithm id `ConsumeToken` | Paired with Idris `src/idris2/examples/ConsumeToken.idr` |
| CHECK | `src/lean4/check.sh` | Presence/syntax gate for required Lean-side files (optional elaborator later) |

## Paired status (Idris dual present)

| Join need | Status |
|-----------|--------|
| Idris MULT-MAP | Present at `src/idris2/multiplicity-map.md` |
| Idris EX-CONSUME | Present at `src/idris2/examples/ConsumeToken.idr` |
| Edge naming | Crosswalk in Lean multiplicity-map; coordinator may merge into `doc/divergence.md` |

## What the Idris side should do next

1. Align MULT-* / EDGE-* with Lean crosswalk if drift appears (Idris residual owns Idris files).
2. Optional real `idris2 --check` gate when toolchain available (`src/idris2/check.sh`).
3. Stay out of `src/systems/` freestanding body unless reassigned.

## What the coordinator should do next

1. Merge imperfect edges from both JOIN files into `doc/divergence.md` / coordinator residual when ready.
2. Do not start freestanding `src/systems/` body until dual honesty is accepted.
3. Steer forks via `doc/fork-guidance-lean.md` / `doc/fork-guidance-idris.md`.

## Non-claims

- Freestanding product residual free
- CompCert PROVABLY
- Formal isomorphism theorem
