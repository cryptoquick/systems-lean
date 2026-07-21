# Idris-side join points (for coordinator)

Greppable one-liners. Update when this side lands slices.

| Id | Path | Claim (honest) |
|----|------|----------------|
| MULT-MAP | `src/idris2/multiplicity-map.md` | Idris MULT-0/1/OMEGA map + edges EDGE-NAME, EDGE-PROP, EDGE-AFFINE, EDGE-RUNTIME, EDGE-CLASSIC-LEAN; aliases ERASE-PROP, RUNTIME-CLASSIC, RUNTIME-FS |
| EX-CONSUME | `src/idris2/examples/ConsumeToken.idr` | Native Idris ConsumeToken with (1 t) LinearCheck surface; not freestanding |
| EX-TRUST | `src/idris2/examples/TRUST.md` | Trusted computing base notes for EX-CONSUME |
| JOIN-ALG | algorithm id `ConsumeToken` | Mirrors Lean side `src/lean4/examples/ConsumeToken.lean` |
| CHECK | `src/idris2/check.sh` | Red/green presence check for this side's required files |

## What Lean side should do next

1. Confirm dual of EX-CONSUME still matches JOIN-ALG.
2. Keep ERASE-PROP / RUNTIME-* greppable; optional note of EDGE-* aliases from Idris map.
3. Stay out of `src/systems/` freestanding body unless reassigned.

## Coordinator

Join imperfect edges into residual / `doc/divergence.md` when both sides greppable (now true for MULT-MAP + EX-CONSUME). Prefer listing both EDGE-* and ERASE-*/RUNTIME-* ids.
