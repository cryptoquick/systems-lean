# src/systems/ -- freestanding Systems Lean (Slake host)

Synthesis workspace: **minimum** QTT (Quantitative Type Theory) multiplicities **0 / 1 / omega** needed to implement **Slake**, the freestanding Systems Lean compiler.

## Product bar

- **No runtime GC (garbage collection)** on the freestanding product wire.
- **No Lean managed runtime** on that wire (AOT (ahead-of-time) != freestanding).
- Multiplicities: only what Slake needs -- do not grow a multiplicity zoo.

## RC (reference counting) -- fail closed

Default: **no RC** on freestanding product paths.

If RC appears, you must **prove it is absolutely necessary**: no linear/affine ownership, borrow, arena, or other strategic design removes it without breaking the freestanding bar. Write the proof (or machine-checked obligation) next to the use; residual must name the hole until proven. "We already had RC" is not a proof.

## Layout

| Path | Role |
|------|------|
| (sources TBD) | Freestanding modules / Slake implementation |
| `../../out/freestanding-c/` | Runtimeless freestanding product C (release) |

## Commands

```bash
just build          # freestanding src/systems build
just out-freestanding-c      # refresh out/freestanding-c for release
just check          # full suite (CI-identical)
```
