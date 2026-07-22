# src/lean4/ -- Lean side (novel work)

**Role label:** Systems Lean -- Lean side
**Residual board:** root `RESIDUAL-lean.md` (not coordinator residual alone)

Lean 4 half of the meet-in-the-middle correspondence (kernel, elaborator, proof culture as reference side).

- Upstream reference only: `ref/lean4` (read-only).
- Novel dual examples and Lean-facing bridge work live **here**.
- Classic ahead-of-time with managed runtime is **not** freestanding. Product freestanding path is `src/systems/`.
- Pair: read-only duals under `src/idris2/` (do not rewrite from this fork).

## Layout

| Path | Role |
|------|------|
| `multiplicity-map.md` | Lean-side multiplicity / erasure correspondence + edge crosswalk |
| `examples/ConsumeToken.lean` | Dual algorithm id ConsumeToken (MULT-1 focus) |
| `examples/ErasedIndex.lean` | Dual algorithm id ErasedIndex (MULT-0 focus) |
| `examples/UnrestrictedShare.lean` | Dual algorithm id UnrestrictedShare (MULT-OMEGA focus) |
| `examples/TRUST.md` | Trusted computing base notes for the examples |
| `JOIN.md` | Greppable join points for the coordinator |
| `check.sh` | Presence gate + optional Lake elaborator red/green |
| `lakefile.toml` | Minimal Lake package (no remote deps) for classic elaborator |
| `lean-toolchain` | Pin matching installed elan (currently v4.32.0) |
| `lake-manifest.json` | Offline empty-deps snapshot (no remote packages) |

## Language

Prefer **Idris side** / **Lean side**. Follow AGENTS.md language rules.

## Validation

```bash
just check
./src/lean4/check.sh
```

Presence files are always required (including the empty offline `lake-manifest.json`).

Optional classic Lean elaborator (`lake build`; not freestanding):

1. **elan present:** run only if the pin in `lean-toolchain` appears in `elan toolchain list` (status suffixes like ` (default)` are ignored). Missing pin -> skip (no network download).
2. **elan absent:** skip by default so a mismatched PATH lean cannot RED `just check`. Set `SYSTEMS_LEAN_LAKE=1` to force PATH `lake build` (elaborator RED is accepted if that install cannot build the pin).
3. **lean and/or lake missing:** skip honestly; presence gate still green.
