# out/llvm-ir -- LLVM IR (intermediate representation) for Rust-native link

**Intent:** freestanding emit of LLVM IR that can link with the Rust ecosystem in a seamless, native way (layout/ABI (application binary interface) compatible) -- without classic FFI (foreign function interface) glue as the happy path.

## Status: deferred

Do **not** implement populate/pipeline work here until **true freestanding
product self-host** is working in the **Slake** compiler design
(`src/systems/`).

**SH6 hold (documented, not unlock):** host gate `SystemsLean/LlvmHold.lean`
(`HOST-LLVM-HOLD` / `SELF-HOST-LLVM-HOLD` / `HOST-PROVABLY-HOLD`;
`llvmUnlocked` / `provablyUnlocked` / `freestandingProductSelfHostComplete`
decide false; `llvmHoldReady` true). SH5 host-structural `selfApplyReady` does
**not** open this path. Not residual-open llvm mill. Not PROVABLY. Still not
residual free.

Until then:

- This directory is a reserved release surface + design placeholder.
- Correspondence and freestanding C (`out/freestanding-c/`) take priority.
- Residual: keep deferred (P6 hold); do not invent llvm-ir residual treadmill.

## Later (after self-host)

1. Freestanding LLVM IR emit from Slake / `src/systems/`.
2. `just out-llvm-ir` (not required until then).
3. Layout/ABI notes vs `ref/rust` (`rustc_abi`, codegen).
4. Release same as freestanding-c (subtree/tarball) when green.
