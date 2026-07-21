# Residual tracker (Systems Lean only)

Living open work for the **Systems Lean** project (this repository). Short and product-first.
Do **not** import wave histories from other trees.

**Status vocabulary:** `open` * `in progress` * `done` * `blocked` * `wontfix`

Green docs or green submodules != residual closed.

---

## Hold (do not start until forked chats take ownership)

The **hard meet-in-the-middle / Slake design+implementation work** is intentionally **not started** in the foundation chat so either a research fork or a primary implementor chat can own it cleanly.

When a chat claims a role, move items from Hold -> Open (or In progress) in this file.

| Held work | Suggested owner |
|-----------|-----------------|
| Multiplicity correspondence table (imperfect edges written down) | Research or primary |
| Tiny dual examples (Idris 2 + Lean) + TCB notes | Research or primary |
| Shared IR sketch (design on disk) | Research -> primary |
| LLVM + Rust interop design note (concrete "without classic FFI") | Research -> primary |
| CompCert product-path honesty (build `ccomp` only when claiming PROVABLY) | Primary |
| Slake compiler skeleton under `src/systems/` (not `ref/`) | Primary |
| Wire `just build` freestanding compile once units exist | Primary |
| Populate `out/freestanding-c` from freestanding emit + subtree release | Primary |
| `out/llvm-ir` pipeline (after self-hosted Systems Lean / Slake) | Deferred |

---

## Done

| Item | Notes |
|------|--------|
| Git init + Nix-oriented `.gitignore` | Root |
| Submodule `ref/Idris2` | Upstream Idris 2 |
| Submodule `ref/lean4` | Upstream Lean 4 |
| Submodule `ref/CompCert` | AbsInt CompCert (`ccomp` source; not built/PROVABLY claimed) |
| Submodule `ref/rust` | rust-lang/rust (layout/ABI + codegen_llvm reference; shallow; no nested LLVM required) |
| Project charter docs | `doc/goals.md`, `vocabulary.md`, `architecture.md`, `divergence.md` |
| Agent hygiene pins | `AGENTS.md`, `doc/SESSION-HANDOFF.md`, `doc/research/README.md` |
| Entry maps | `doc/idris-entry.md`, `doc/lean-entry.md`, `doc/compcert-entry.md`, `doc/rust-entry.md` |
| License | `UNLICENSE.md` (our work) + `LICENSES.md` (public-domain note + `ref/` license inventory) |
| ASCII hygiene | `doc/ascii-symbol-map.md` + `script/check-source-hygiene.py`; Nix `checks.source-hygiene`; pre-commit chain |
| Nix foundation | `flake.nix`, `.envrc` |
| just + check-all + CI | `justfile`, `script/check-all.sh`, `.github/workflows/ci.yml` |
| Workspaces | `src/idris2/`, `src/lean4/`, `src/systems/`, `out/freestanding-c/`, `out/llvm-ir/` (deferred) |
| RC / no-GC freestanding policy | `src/systems/README.md`, `AGENTS.md` |

---

## Open (foundation only)

1. **Initial signed commit** -- stage docs + all `ref/*` submodules; human runs GPG-signed commit on a real TTY.

---

## Explicitly out of residual (default)

- Racing residual mills in other trees
- Day-one full Idris 2 or Lean 4 surface parity
- Forging freestanding / PROVABLY / host residual_free tokens
- Renaming upstream under `ref/`
- Recursive init of rust's nested LLVM world unless the human asks
- Starting held hard work from a chat that has not claimed implementor/research role

---

## Isolation

This repository **is** Systems Lean. Unless the human is **absolutely desperate** for a specific off-repo solution and says so: implement here, reference `ref/*` only.
