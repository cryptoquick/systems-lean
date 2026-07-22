# src/idris2/ -- Idris side (novel work)

Idris 2 side of the meet-in-the-middle correspondence (Quantitative Type Theory, linear resources).

- Upstream reference only: `ref/Idris2` (read-only).
- Freestanding compiler host is `src/systems/` (not this tree).
- Validate: `./src/idris2/check.sh` then `just check`.
- Residual ledger: `RESIDUAL-idris.md` (root). Say **Idris side** / **Lean side** (see AGENTS.md language rules).

## Layout

| Path | Role |
|------|------|
| `multiplicity-map.md` | MULT-0 / MULT-1 / MULT-OMEGA + imperfect edges + Lean join aliases |
| `examples/ConsumeToken.idr` | Native dual -- MULT-1 linear Token (algorithm id ConsumeToken) |
| `examples/ErasedIndex.idr` | Native dual -- MULT-0 erased length/index (algorithm id ErasedIndex) |
| `examples/UnrestrictedShare.idr` | Native dual -- MULT-OMEGA unrestricted share (algorithm id UnrestrictedShare) |
| `examples/TRUST.md` | Trusted computing base honesty |
| `JOIN.md` | Greppable join table for coordinator |
| `check.sh` | Red/green required-file check (+ optional idris2 --check) |

## Language

Prefer **Idris side** / **Lean side**. Follow AGENTS.md banned-jargon list.
