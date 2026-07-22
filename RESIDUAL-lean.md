# Residual -- Lean side (`src/lean4/`)

**Chat role:** Systems Lean -- Lean side
**Owner residual file for this conversation:** this file only (`RESIDUAL-lean.md`)
**Do not** treat coordinator `RESIDUAL.md` or `RESIDUAL-idris.md` as the Lean work board.

Fork prompt: `doc/fork-lean.md`. Re-read `doc/fork-guidance-lean.md` every implement loop.

**Status vocabulary:** `open` | `in progress` | `done` | `blocked` | `wontfix`

**Language:** say **Idris side** / **Lean side** / **bridge half** / **fork**. Follow `AGENTS.md` banned-jargon list.

---

## Done

| Id | Item | Status | Paths |
|----|------|--------|-------|
| L-DONE-MAP | First-cut multiplicity / erasure map | **done** | `src/lean4/multiplicity-map.md` |
| L-DONE-EX | Classic Lean ConsumeToken sketch | **done** | `examples/ConsumeToken.lean` |
| L-DONE-ERASED | Classic Lean ErasedIndex dual (MULT-0) | **done** | `examples/ErasedIndex.lean` |
| L-DONE-SHARE | Classic Lean UnrestrictedShare dual (MULT-OMEGA) | **done** | `examples/UnrestrictedShare.lean` |
| L-DONE-TRUST | Trusted computing base notes for duals | **done** | `examples/TRUST.md` |
| L-DONE-JOIN | Greppable join table (three algorithm ids) | **done** | `JOIN.md` |
| L-DUAL-MAP | Dual-update map + edge crosswalk from real Idris text | **done** | multiplicity-map |
| L-EDGE-XWALK | Durable Lean <-> Idris edge crosswalk | **done** | multiplicity-map edge table |
| L-README | README dual status + residual pointer | **done** | `README.md` |
| L-JARGON | Language hygiene under Lean product sources | **done** | examples clean of banned jargon |
| L-CHECK-SH | Presence/syntax red/green gate | **done** | `check.sh` |
| L-LAKE | Minimal Lake package + optional elaborator | **done** | `lakefile.toml` roots for three examples |
| L-RESIDUAL | Living inventory in this file | **done** (kept current) | this file |

---

## Open (optional / deferred)

| Id | Item | Status | Notes |
|----|------|--------|-------|
| L-FORMAL-ISO | Formal map theorems in Lean | **open** (deferred) | After duals stabilize + human prioritizes proofs |
| L-MORE-DUAL | Further duals | **open** (deferred) | Only when a named map gap requires a new algorithm id |

---

## Explicit non-work

| Id | Rule |
|----|------|
| L-NO-SYSTEMS | Do not implement `src/systems/` freestanding body |
| L-NO-IDRIS-WRITE | Do not rewrite `src/idris2/` sources |
| L-NO-LLVM | Do not start `out/llvm-ir` |
| L-NO-PROVABLY | Do not claim CompCert PROVABLY |
| L-NO-GIT | Do not stage/commit/push unless the human asks |

---

## External (not Lean-fork duty)

| Id | Item | Status | Unblock |
|----|------|--------|---------|
| L-COORD-JOIN | Coordinator merge imperfect edges into `doc/divergence.md` / `RESIDUAL.md` | **blocked** (coordinator) | Both JOIN files greppable; wait for coordinator chat |

---

## Highest value next (if continuing Lean chat)

1. **Stop Lean autonomous loop** unless the human prioritizes **L-FORMAL-ISO** or a named new dual.
2. Do not invent residual to keep the watcher spinning.
3. Hand **L-COORD-JOIN** to the coordinator chat (not Lean-fork duty).
4. Systems Lean host deepen is **Systems fork** (`src/systems/`), not this tree.

---

## Next residual implement prompt (Lean side)

```
blocked (Lean side): dual depth residual for this fork is current
(ConsumeToken + ErasedIndex + UnrestrictedShare). Optional formal map theorems
only if human prioritizes. Do not edit src/idris2 or src/systems.
Follow AGENTS.md language rules. No freestanding/PROVABLY forge. No git.
```
