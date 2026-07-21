# Rust entry map (layout + LLVM IR interop)

Read-only upstream: `ref/rust/` (`rust-lang/rust`).
Do not edit upstream as product source.

**Why Rust (not only llvm-project):** Rust **type layout and ABI** are defined by rustc (`rustc_abi`, codegen conventions). LLVM IR alone does not define "Rust-compatible layout." For Slake's design bar -- LLVM IR and efficient Rust-ecosystem interop **without classic FFI** as the happy path -- rustc is the reference.

Nested LLVM under rust's own submodules is **not** required for reading layout/ABI sources. Do not recursive-init the world unless a human asks.

---

## Start here

| Purpose | Path |
|---------|------|
| Overview | `ref/rust/README.md` |
| Compiler crates | `ref/rust/compiler/` |
| **Type layout / ABI** | `ref/rust/compiler/rustc_abi/` (and related) |
| Codegen SSA / LLVM bridge | `ref/rust/compiler/rustc_codegen_ssa/`, `ref/rust/compiler/rustc_codegen_llvm/` |
| Target specs | under `ref/rust/compiler/rustc_target/` |

Exact crate layout can shift across rustc versions; search under `ref/rust/compiler/` for `abi`, `layout`, `codegen_llvm` if paths move.

---

## Design bar (not a claim yet)

| Phrase | Status |
|--------|--------|
| "LLVM IR backend" | Design goal for Slake |
| "Rust layout-compatible" | Must be defined against rustc_abi rules + tests |
| "Without classic FFI" | Happy path = layout/IR-level interop, not hand `extern "C"` glue as default -- **not claimed** until design note + tests |

See `doc/architecture.md`, residual item for LLVM + Rust interop design note.

---

## What Systems Lean uses this for

- Layout and ABI reference for freestanding/LLVM product wire
- Research into link/embed without classic FFI
- Later: dual tests (Rust consumer + Slake product)

Not for forking rustc development inside this repo.
