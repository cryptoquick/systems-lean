# out/freestanding-c -- runtimeless product C

**Release surface:** freestanding product C (and headers) that others can build with a normal C toolchain **without** a Lean managed runtime, GC (garbage collection), or host elaborator on the link line.

Name emphasizes **runtimeless / freestanding**, not classic AOT (ahead-of-time) that still ships a runtime.

## Policy

- Contents come from freestanding emit under `src/systems/` only (V0: `src/systems/emit/`).
- No host elaborator residual, no `libleanshared` expectation, no product GC.
- Refresh: `just out-freestanding-c` (see `script/out-freestanding-c.sh`).
- Stage: **SLAKE_EMIT_FREESTANDING_C_V0** -- V0 emit surface exists; still **not residual free**.

## Release process (minimum)

1. `just build` -- freestanding systems product green (compile-path structure stage; not product C).
2. `just out-freestanding-c` -- emit + populate this tree from `src/systems/emit/`.
3. `just check` -- full suite green.
4. Publish **this directory** via **git subtree** (or tarball) so consumers need not clone `ref/*` or the full host.
5. Notes: freestanding bar + Unlicense on novel emit; CompCert (if used) keeps its own license.

## V0 status

V0 emit surface exists (`slake_freestanding.c` / `slake_freestanding.h` via
`SLAKE_EMIT_FREESTANDING_C_V0`). First real unit translation
(**UNIT_TRANSLATION_V0** / **UNIT_DEEPEN_V1**) maps Mult / Linear / Erasure /
Extract / Types into freestanding C APIs (grade validity, exact-once consume,
runtime-absent erasure probe, RUNTIME-FS product class, type tags). Still
**not residual free**; not PROVABLY; not freestanding residual free.
