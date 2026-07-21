# Residual -- Idris side (`src/idris2/`)

Owned by the Idris-side implement fork (`doc/fork-idris.md`). Coordinator reads this file; it does not drive the Lean side or freestanding treadmill.

**Status vocabulary:** `open` | `in progress` | `done` | `blocked` | `wontfix`

Re-read `doc/fork-guidance-idris.md` at the start of every implement loop.

**Honesty:** green milestones on `doc/PROGRESS.md` are not residual closed. Keep this ledger current.

**Language:** say **Idris side** / **Lean side** / **coordinator**. Do not say "pole."

---

## Done (first cut)

| Item | Status | Paths |
|------|--------|--------|
| Scaffold README | **done** | `src/idris2/README.md` |
| Multiplicity correspondence (Idris side) | **done** (first cut) | `src/idris2/multiplicity-map.md` |
| Native ConsumeToken + trust notes | **done** (first cut) | `src/idris2/examples/ConsumeToken.idr`, `TRUST.md` |
| JOIN greppable join points | **done** | `src/idris2/JOIN.md` |
| Presence red/green gate | **done** | `src/idris2/check.sh` (required files + greps) |
| EDGE-* join aliases to Lean map ids | **done** | multiplicity-map Join aliases + JOIN MULT-MAP claim |
| No "pole" jargon on Idris-owned surfaces | **done** | `src/idris2/**`, this file, `doc/fork-idris.md` |
| Optional `idris2 --check` path honesty | **done** | skip if missing; RED if present and fails |

---

## Priority residual (Idris side only)

| Priority | Item | Status | Acceptance / notes |
|----------|------|--------|--------------------|
| 1 | Edge-id join aliases EDGE-* <-> Lean ERASE-*/RUNTIME-* | **done** | Both id sets greppable from Idris map/JOIN |
| 2 | Language pass: no "pole" under owned paths | **done** | `rg -i '\bpole\b'` clean on owned paths |
| 3 | Optional `idris2 --check` honesty | **done** | Documented in check.sh; residual notes PATH skip |
| 4 | Second native dual example (new algorithm id) | **open** (deferred) | Only after Lean dual need or coordinator request; do not invent freestanding |
| 5 | Wire `idris2` into project devShell for stronger CI | **open** (tooling) | Coordinator/flake if desired; do not break `just check` without binary |
| 6 | Merge imperfect edges into `doc/divergence.md` | **blocked** (this fork) | **Coordinator** owns join into divergence; Idris side only greppable edges |

---

## Not this fork

- `src/lean4/**` product edits (read-only for dual check)
- `src/systems/` freestanding Slake body
- `out/llvm-ir`, CompCert PROVABLY claims
- Git commits
- Repo-wide "pole" purge of Lean residual / progress generator (coordinator / Lean fork)

---

## Highest-value next (after this ledger)

1. **Lean side:** mirror join aliases (ERASE-PROP already present); confirm ConsumeToken dual still matches JOIN-ALG.
2. **Coordinator:** merge greppable imperfect edges into `doc/divergence.md` / coordinator residual; do not start freestanding body yet.
3. **Idris side (later):** second dual only when explicitly needed (e.g. MULT-0 erased index pattern with shared algorithm id).

---

## Next residual implement prompt (Idris side)

```
/implement --effort 1 remaining Idris-side work under src/idris2/ only:

1. Re-read RESIDUAL-idris.md and doc/fork-guidance-idris.md.
2. If coordinator or Lean dual requests a second algorithm id, add a small native Idris dual + JOIN row; else do not invent examples.
3. If idris2 is on PATH, keep ./src/idris2/check.sh green (including --check). If not, leave skip honest.
4. just check; update RESIDUAL-idris.md; end with residual implement prompt or blocked note.
5. Do not edit src/lean4 or src/systems. Do not say "pole". Do not forge freestanding/PROVABLY.

Subagents: strategic parallel; parent soft ~40% context / ~200k cost knee; join on disk.
```
