# Idris-side join points (for coordinator)

Greppable one-liners. Update when this side lands slices.

| Id | Path | Claim (honest) |
|----|------|----------------|
| MULT-MAP | `src/idris2/multiplicity-map.md` | Idris MULT-0/1/OMEGA map + edges EDGE-NAME, EDGE-PROP, EDGE-AFFINE, EDGE-RUNTIME, EDGE-CLASSIC-LEAN; aliases ERASE-PROP, RUNTIME-CLASSIC, RUNTIME-FS |
| EX-CONSUME | `src/idris2/examples/ConsumeToken.idr` | Native Idris ConsumeToken with (1 t) LinearCheck surface; not freestanding |
| EX-ERASED | `src/idris2/examples/ErasedIndex.idr` | Native Idris ErasedIndex MULT-0 length/index patterns; not freestanding |
| EX-SHARE | `src/idris2/examples/UnrestrictedShare.idr` | Native Idris UnrestrictedShare MULT-OMEGA copy/drop/multi-use; not freestanding |
| EX-TRUST | `src/idris2/examples/TRUST.md` | Trusted computing base notes for dual examples |
| JOIN-ALG | algorithm ids `ConsumeToken`, `ErasedIndex`, `UnrestrictedShare` | Mirror Lean side under `src/lean4/examples/` |
| CHECK | `src/idris2/check.sh` | Red/green presence check for this side's required files |

## What Lean side should do next

1. Keep duals of EX-CONSUME / EX-ERASED / EX-SHARE matched on JOIN-ALG ids.
2. Keep ERASE-PROP / RUNTIME-* greppable; optional note of EDGE-* aliases from Idris map.
3. Stay out of `src/systems/` freestanding body unless reassigned.

## Coordinator

Join imperfect edges into residual / `doc/divergence.md` when both sides greppable. Prefer listing both EDGE-* and ERASE-*/RUNTIME-* ids. Dual depth (multiple algorithm ids) is now the join bar -- not a single example forever.
