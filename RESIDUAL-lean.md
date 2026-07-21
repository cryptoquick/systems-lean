# Residual -- Lean side (`src/lean4/`)

**Chat role:** Systems Lean -- Lean side
**Owner residual file for this conversation:** this file only (`RESIDUAL-lean.md`)
**Do not** treat coordinator `RESIDUAL.md` or `RESIDUAL-idris.md` as the Lean work board.

Fork prompt: `doc/fork-lean.md`. Re-read `doc/fork-guidance-lean.md` every implement loop.

**Status vocabulary:** `open` | `in progress` | `done` | `blocked` | `wontfix`

**Language:** say **Idris side** / **Lean side** / **bridge half** / **fork**. Do not use the word "pole" (except when documenting the ban or a red/green grep that rejects it).

---

## Done

| Id | Item | Status | Paths |
|----|------|--------|-------|
| L-DONE-MAP | First-cut multiplicity / erasure map | **done** | `src/lean4/multiplicity-map.md` |
| L-DONE-EX | Classic Lean ConsumeToken sketch | **done** | `src/lean4/examples/ConsumeToken.lean` |
| L-DONE-TRUST | Trusted computing base notes for example | **done** | `src/lean4/examples/TRUST.md` |
| L-DONE-JOIN | Greppable join table | **done** | `src/lean4/JOIN.md` |
| L-DUAL-MAP | Dual-update map + edge crosswalk from real Idris text | **done** | `src/lean4/multiplicity-map.md` |
| L-DUAL-EX | Align ConsumeToken; `SystemsLean.LeanBridge` namespace | **done** | `src/lean4/examples/ConsumeToken.lean` |
| L-DUAL-TRUST | TRUST paired with Idris trust notes | **done** | `src/lean4/examples/TRUST.md` |
| L-JOIN | JOIN paired status (Idris dual present) | **done** | `src/lean4/JOIN.md` |
| L-EDGE-XWALK | Durable Lean <-> Idris edge crosswalk | **done** | multiplicity-map edge table |
| L-README | README dual status + residual pointer | **done** | `src/lean4/README.md` |
| L-JARGON | Scrub pole/Pole under Lean product sources | **done** | `src/lean4/**` clean except check.sh ban |
| L-CHECK-SH | Presence/syntax red/green gate | **done** | `src/lean4/check.sh` |
| L-RESIDUAL | Living inventory in this file | **done** (kept current) | this file |
| L-RESEARCH | Optional analysis note | **wontfix** (this slice) | product map holds dual honesty |

---

## Open (optional / deferred)

| Id | Item | Status | Notes |
|----|------|--------|-------|
| L-LAKE | Optional Lake/lean elaborator check for examples | **open** | Must not break default `just check`; no freestanding claim |
| L-FORMAL-ISO | Formal map theorems in Lean | **open** (deferred) | After duals stabilize + human prioritizes proofs |

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

1. **L-LAKE** only if a cheap Lake package can typecheck `ConsumeToken.lean` without wiring freestanding claims into the suite -- otherwise leave open.
2. Otherwise **stop Lean autonomous loop**: dual honesty is current; remaining product freestanding work is coordinator / systems hold.
3. Do not invent residual to keep the watcher spinning.

---

## Next residual implement prompt (Lean side)

```
/implement --effort 1 remaining Lean-side work only under src/lean4/ (residual file: RESIDUAL-lean.md only):

1. If L-LAKE is still open and a minimal Lake package is low-risk: red/green elaborator check for examples/ConsumeToken.lean without freestanding claims; keep just check green.
2. Else: do not invent work -- document blocked or residual-closed-except-optional in RESIDUAL-lean.md; hand coordinator L-COORD-JOIN if still open.
3. Do not implement src/idris2 or src/systems. Do not use the word pole in new prose.
4. Run just check and ./src/lean4/check.sh; update RESIDUAL-lean.md; end with another implement prompt or a short stop/blocked note.

Subagents: strategic parallel for disjoint reads; parent soft ~40% context / ~200k cost knee; join on disk.
```
