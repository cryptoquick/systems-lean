# Systems Lean

**Systems Lean** is the project: Lean 4 with linear/affine ownership and QTT multiplicities **0 / 1 / omega**, aimed at freestanding systems products, reached by a meet-in-the-middle bridge between **Idris 2** and **Lean 4**.

The freestanding compiler product of this project is **Slake**.

(Checkout directory may still be named `iso` on disk; the **project name** is Systems Lean.)

## North star

**Slake** is a compiler written in **Systems Lean**. Focus: freestanding **runtimeless** C (`out/freestanding-c`) with memory safety from **linear types**, **no garbage collection** on the product wire, and only the **minimum** Quantitative Type Theory multiplicities (0 / 1 / omega) needed for that path.

Meet-in-the-middle Idris 2 and Lean 4 correspondence feeds Slake -- sides live under `src/idris2/` and `src/lean4/`. LLVM intermediate representation for Rust-native link is **deferred** until self-host (`out/llvm-ir`).

**Three languages only** for novel work: **Idris 2**, **Lean 4** (including Systems Lean / Slake), and **pure Nix flakes** (small modules under `nix/`, not bash-in-Nix). No project Python; shell under `script/` is migration debt to shrink. Freestanding C is product emit, not a fourth source language. Thin **`just`** orchestrates only. Policy: [AGENTS.md](AGENTS.md), terms: [doc/vocabulary.md](doc/vocabulary.md), goals: [doc/goals.md](doc/goals.md). Spec and proof stay separated; red/green tests stay required.

## Read first

| Doc | Purpose |
|-----|---------|
| [doc/goals.md](doc/goals.md) | Full goals, non-goals, honesty ladder |
| [doc/vocabulary.md](doc/vocabulary.md) | Stable terms (project = Systems Lean; Slake = **compiler**; tooling terms) |
| [doc/architecture.md](doc/architecture.md) | Meet-in-the-middle sketch |
| [doc/divergence.md](doc/divergence.md) | Honest differences and trusted computing bases |
| [AGENTS.md](AGENTS.md) | Agent hygiene, isolation, and pure Nix tooling rule |
| [RESIDUAL.md](RESIDUAL.md) | Living open work for **this** project |

## References (read-only)

| Path | Upstream | Role |
|------|----------|------|
| `ref/Idris2` | [Idris2](https://github.com/idris-lang/Idris2) | QTT / linear side |
| `ref/lean4` | [Lean 4](https://github.com/leanprover/lean4) | Kernel / elaborator / proof side |
| `ref/CompCert` | [AbsInt CompCert](https://github.com/AbsInt/CompCert) | `ccomp` source for CompCert-oriented C path |
| `ref/rust` | [rust-lang/rust](https://github.com/rust-lang/rust) | Type layout / ABI + LLVM codegen reference (not llvm-project alone) |

Do not treat `ref/` as product source. Systems Lean language work and the Slake compiler live in this repository when implementation begins.

Entry maps: `doc/idris-entry.md`, `doc/lean-entry.md`, `doc/compcert-entry.md`, `doc/rust-entry.md`.

## Isolation

Work **here**. This repository **is** Systems Lean. Do not default to other trees for residual or implementation. Escalate off-repo only when a human is explicitly desperate for a specific solution.

## Repository structure

```
.
+-- src/                 # Novel product work (not upstream)
|   +-- idris2/          # Idris side -- isomorphism / QTT (Quantitative Type Theory) side
|   +-- lean4/           # Lean 4 side -- kernel/elaborator-facing novel work
|   +-- systems/         # Freestanding Systems Lean + Slake host (min 0/1/omega; no product GC)
+-- out/
|   +-- freestanding-c/  # Runtimeless freestanding product C (release)
|   +-- llvm-ir/         # LLVM IR for Rust-native link (deferred post self-host)
+-- ref/                 # Upstream read-only submodules (Idris2, lean4, CompCert, rust)
+-- doc/                 # Goals, vocabulary, architecture, entry maps
+-- script/              # residual build/emit shells + git-hooks; tooling is flake apps
+-- justfile             # just check | build | out-freestanding-c (default: list)
+-- flake.nix            # Nix checks / devShell / apps
+-- AGENTS.md            # Agent policy + detailed tree map
+-- RESIDUAL.md          # Living open work
```

Full evolving map: [AGENTS.md](AGENTS.md). Product code never under `ref/`.
Forks: [doc/fork-idris.md](doc/fork-idris.md), [doc/fork-lean.md](doc/fork-lean.md). Coordinator: [doc/fork-coordinator.md](doc/fork-coordinator.md).
Next autonomous implement instructions: [WATCHER.md](WATCHER.md) (`WATCHER_BEGIN` ... `WATCHER_END`).

## Tooling

```bash
nix develop       # elan (Lean/Lake pin manager) + idris2 + just + rg + scc
just              # list
just check        # CI-identical full suite
just progress     # % meter -> doc/PROGRESS.md
just watch        # every 300s: progress + fork guidance snapshots
just build        # freestanding src/systems/
just out-freestanding-c  # release freestanding C
just out-llvm-ir         # deferred (see out/llvm-ir/README.md)
```

Lean elaborator pin is `leanprover/lean4:v4.32.0` (`src/systems/lean-toolchain`, `src/lean4/lean-toolchain`).
In the dev shell: `elan toolchain install "$(tr -d '[:space:]' < src/systems/lean-toolchain)"` once.
Workspace checks skip Lake when the pin is not installed (no surprise network download).

Side residuals: `RESIDUAL-idris.md`, `RESIDUAL-lean.md`. Coordinator: `RESIDUAL.md`.
ASCII map: [doc/ascii-symbol-map.md](doc/ascii-symbol-map.md). Policy: [AGENTS.md](AGENTS.md).

## License

- **Our work** (everything we commit outside `ref/`): [The Unlicense](UNLICENSE.md) -- public domain dedication. See [LICENSES.md](LICENSES.md).
- **Author:** Hunter "cryptoquick" Beast.
- **SPDX for our crates / modules / packages:** `Unlicense` (Cargo, Lake, Idris, Nix metadata, optional file headers). Details in [LICENSES.md](LICENSES.md).
- **Submodules under `ref/`:** keep their own licenses (Idris 2 BSD-style, Lean 4 Apache-2.0, CompCert non-commercial/AbsInt, Rust Apache-2.0 OR MIT, ...). Tracked in [LICENSES.md](LICENSES.md).

## Status

Foundation: goals, vocabulary, architecture, agent hygiene, and upstream submodules (Idris2, Lean4, CompCert, rust).
Hard correspondence / Slake design work is **on hold** so a forked research or implementor chat can own it -- see [RESIDUAL.md](RESIDUAL.md) and [doc/SESSION-HANDOFF.md](doc/SESSION-HANDOFF.md).
