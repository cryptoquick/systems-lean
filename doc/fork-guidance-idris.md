# Coordinator guidance -- Idris side

**Idris fork: re-read this file at the start of every implement loop.**

## Latest directive (coordinator updates this section)

- **Dual join done:** MULT map, ConsumeToken, JOIN, EDGE-* aliases under `src/idris2/`; coordinator merged greppable edges into `doc/divergence.md`.
- **Do not invent residual** on this side unless a real drift appears vs Lean dual. Second dual example only on human request.
- Stay in `src/idris2/` (+ `RESIDUAL-idris.md`). Do not edit `src/lean4/` or freestanding body under `src/systems/`.
- Validate with `just check`. Track work only in `RESIDUAL-idris.md`.
- Language: **Idris side** / **Lean side** -- do not say "pole."
- Coordinator owns IR sketch next (shared intermediate representation); side forks wait unless reassigned.

## Status snapshot

Watcher/progress at 2026-07-21 12:15:27 -0600:

- Overall 70.0% | Idris 100.0% | Lean 100.0% | Systems 0.0%
- Tree changes this cycle: none
- Stall cycles (no mtime change): idris=4 lean=4
- Idris stream milestones green on meter -- keep residual honest. STALL: no src/idris2 or RESIDUAL-idris mtime for 3+ watch cycles -- re-read guidance and push residual 1-3.

## Do not

- Invent freestanding or PROVABLY claims
- Start `out/llvm-ir`
- Touch git unless the human asks
