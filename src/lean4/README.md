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
| `examples/ConsumeToken.lean` | Dual algorithm id ConsumeToken (classic Lean sketch) |
| `examples/TRUST.md` | Trusted computing base notes for the example |
| `JOIN.md` | Greppable join points for the coordinator |
| `check.sh` | Optional presence/syntax red/green for this tree |

## Language

Prefer **Idris side** / **Lean side**. Do not use the word "pole" in novel prose.

## Validation

```bash
just check
./src/lean4/check.sh
```

Lean package elaborator build for this tree is not required for suite green yet; hygiene, flake, and presence check are the current automated gates.
