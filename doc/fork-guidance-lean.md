# Coordinator guidance -- Lean side

**Lean fork: re-read this file at the start of every implement loop.**
**Residual board for Lean chat:** `RESIDUAL-lean.md` only.

## Latest directive (coordinator updates this section)

- **Dual join done:** MULT map, ConsumeToken, JOIN, and ERASE-*/RUNTIME-* crosswalk under `src/lean4/`; coordinator merged greppable edges into `doc/divergence.md`.
- **Do not invent residual** on this side unless a real drift appears vs Idris dual. Second dual example only on human request.
- Stay in `src/lean4/` (+ `RESIDUAL-lean.md`). Do not implement `src/idris2/` or freestanding body under `src/systems/`.
- Language: Idris side / Lean side -- do not say "pole".
- Validate with `just check` and `./src/lean4/check.sh`. Track work only in `RESIDUAL-lean.md`.
- Optional later: Lake elaborator gate (L-LAKE); do not claim freestanding; do not break `just check` without tools.
- Coordinator owns shared intermediate-representation (IR) sketch next -- not required of Lean fork.

## Status snapshot

Watcher/progress at 2026-07-21 12:15:27 -0600:

- Overall 70.0% | Idris 100.0% | Lean 100.0% | Systems 0.0%
- Tree changes this cycle: none
- Stall cycles (no mtime change): idris=4 lean=4
- Lean first cut present; dual-update when Idris lands. STALL: no lean tree mtime for 3+ cycles -- if blocked on Idris, document blocked in RESIDUAL-lean.md.

## Do not

- Invent freestanding or PROVABLY claims
- Start `out/llvm-ir`
- Touch git unless the human asks
