# Lean 4 entry map

Read-only upstream: `ref/lean4/`.
Do not edit upstream as product source.

**Systems Lean** (this project) and **Slake** (its compiler) are developed here. Use `ref/lean4` as the Lean 4 reference; implement product code in this repository when the time comes. Do **not** default to other trees (see [goals.md](goals.md) isolation policy).

---

## Start here

| Purpose | Path |
|---------|------|
| Project overview / build | `ref/lean4/README.md` |
| Contributing / build notes | `ref/lean4/CONTRIBUTING.md` |
| Dev docs index | `ref/lean4/doc/` |
| Toolchain pin | `ref/lean4/lean-toolchain` |
| Flake (if using Nix) | `ref/lean4/flake.nix` |

---

## Source landmarks

| Area | Path |
|------|------|
| Init prelude | `ref/lean4/src/Init/` |
| Lean elaborator / compiler | `ref/lean4/src/Lean/` |
| Std library | `ref/lean4/src/Std/` |
| Lake (classic package/build) | `ref/lean4/src/lake/` |
| Runtime (C++) | `ref/lean4/src/runtime/` |
| Kernel (C++) | `ref/lean4/src/kernel/` |
| Tests | `ref/lean4/tests/` |

---

## Honest product notes

- Classic Lean **AOT** produces native code that still expects the **managed Lean runtime**. That is not freestanding.
- **AOT != freestanding.** Freestanding means no Lean managed runtime on the product wire.
- Lake is the classic package/build driver. Slake (this project) is the **compiler**, not a Lake rename.

See [divergence.md](divergence.md) and [vocabulary.md](vocabulary.md).

---

## What Systems Lean uses this for

- Kernel / elaborator / proof-ecosystem side of the meet-in-the-middle
- Understanding classic AOT residual vs freestanding goals
- Later: surface matrix and dual examples

Product Systems Lean extensions and the Slake compiler will live **outside** `ref/lean4` in this repository.
