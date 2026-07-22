# Residual -- Idris side (`src/idris2/`)

Owned by the Idris-side implement fork (`doc/fork-idris.md`). Coordinator reads this file; it does not drive the Lean side or freestanding treadmill.

**Status vocabulary:** `open` | `in progress` | `done` | `blocked` | `wontfix`

Re-read `doc/fork-guidance-idris.md` at the start of every implement loop.

**Honesty:** green milestones on `doc/PROGRESS.md` are not residual closed. Keep this ledger current.

**Language:** say **Idris side** / **Lean side** / **coordinator**. Do not use banned metaphor names (see `AGENTS.md`).

---

## Done

| Item | Status | Paths |
|------|--------|--------|
| Scaffold README | **done** | `src/idris2/README.md` |
| Multiplicity correspondence (Idris side) | **done** (first cut) | `src/idris2/multiplicity-map.md` |
| Native ConsumeToken + trust notes | **done** | `examples/ConsumeToken.idr`, `TRUST.md` |
| Native ErasedIndex (MULT-0) | **done** | `examples/ErasedIndex.idr` |
| Native UnrestrictedShare (MULT-OMEGA) | **done** | `examples/UnrestrictedShare.idr` |
| JOIN greppable join points (three algorithm ids) | **done** | `src/idris2/JOIN.md` |
| Presence red/green gate | **done** | `src/idris2/check.sh` (required files + greps + optional idris2) |
| EDGE-* join aliases to Lean map ids | **done** | multiplicity-map Join aliases + JOIN MULT-MAP claim |
| Language pass on Idris-owned surfaces | **done** | no banned jargon in `.idr` modules |

**LOC honesty:** multiple `.idr` modules (ConsumeToken + ErasedIndex + UnrestrictedShare); not a single thin example.

---

## Priority residual (Idris side only)

| Priority | Item | Status | Acceptance / notes |
|----------|------|--------|--------------------|
| 1 | Three native duals (MULT-0 / 1 / OMEGA focus) | **done** | ConsumeToken, ErasedIndex, UnrestrictedShare + Lean duals |
| 2 | Optional `idris2 --check` path honesty | **done** | skip if missing; RED if present and fails |
| 3 | Wire `idris2` into project devShell for stronger CI | **done** | Flake `devShells.default` includes `pkgs.idris2`; check.sh still skips if binary absent outside the shell |
| 4 | Further native duals only when product map needs them | **open** (deferred) | Do not pad LOC; new algorithm id must dual with Lean |
| 5 | Merge imperfect edges into `doc/divergence.md` | **blocked** (this fork) | **Coordinator** owns join into divergence |

---

## Not this fork

- `src/lean4/**` product edits (read-only for dual check)
- `src/systems/` freestanding Slake body
- `out/llvm-ir`, CompCert PROVABLY claims
- Git commits
- Freestanding C emit as substitute for Idris depth

---

## Highest-value next (after this ledger)

1. **Systems:** P1 host close under `src/systems/` (not more dual invent unless map needs it).
2. **Idris side:** only new duals when a named correspondence gap requires them.
3. **Bridge formal work** lives on Lean residual (L-FORMAL-ISO), not more Idris sketches.

---

## Next residual implement prompt (Idris side)

```
blocked (Idris side): dual depth residual for this fork is current
(ConsumeToken + ErasedIndex + UnrestrictedShare). idris2 is in flake devShell.
Do not invent more examples without a named map gap.
Do not edit src/lean4 or src/systems. Follow AGENTS.md language rules.
```
