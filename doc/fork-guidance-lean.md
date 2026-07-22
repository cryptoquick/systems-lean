# Coordinator guidance -- Lean side

**Lean fork: re-read this file at the start of every implement loop.**
**Residual board for Lean chat:** `RESIDUAL-lean.md` only.

## Latest directive (coordinator updates this section)

- **Dual join done:** MULT map, ConsumeToken, JOIN, and ERASE-*/RUNTIME-* crosswalk under `src/lean4/`; coordinator merged greppable edges into `doc/divergence.md`.
- **IR sketch landed:** `doc/shared-ir-sketch.md`.
- **Systems skeleton landed:** layout stubs under `src/systems/` (types / mult / linear / erasure / extract). Coordinator owns freestanding units next; do not invent dual residual.
- **Do not invent residual** on this side unless a real drift appears vs Idris dual. Second dual example only on human request.
- Stay in `src/lean4/` (+ `RESIDUAL-lean.md`). Do not implement `src/idris2/` or freestanding body under `src/systems/`.
- Language: Idris side / Lean side -- do not say "pole".
- Validate with `just check` and `./src/lean4/check.sh`. Track work only in `RESIDUAL-lean.md`.
- Lake elaborator gate (L-LAKE) **done**: optional `lake build` when lean/lake and pinned toolchain installed; skip honestly otherwise; no freestanding claim.
- Optional deferred only: formal map theorems (L-FORMAL-ISO) if residual still names them -- not freestanding emit.


## Status snapshot

Watcher/progress at 2026-07-21 12:47:40 -0600:

- Goal total [##################--]  91.2%
- Phases: foundation 100% | bridge 100% | join 100% | systems 100% | release 25%
- Streams: Idris 100.0% | Lean 100.0% | Systems 68.4%
- Tree changes this cycle: none
- Stall cycles (no mtime change): idris=12 lean=7
- Dual join done; IR sketch + systems skeleton + unit surface landed. Wait real compile path / emit under src/systems/ (systems fork owns); do not invent dual residual. Second dual only on human request. STALL: no side-tree mtime for 3+ watch cycles -- hold / re-read guidance; do not invent residual unless human asks.

## Do not

- Invent freestanding or PROVABLY claims
- Start `out/llvm-ir`
- Touch git unless the human asks
