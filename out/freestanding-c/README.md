# out/freestanding-c -- runtimeless product C

**Release surface:** freestanding product C (and headers) that others can build with a normal C toolchain **without** a Lean managed runtime, GC (garbage collection), or host elaborator on the link line.

Name emphasizes **runtimeless / freestanding**, not classic AOT (ahead-of-time) that still ships a runtime.

## Generated only (do not hand-author)

- Tracked `*.c` / `*.h` here are **generator outputs** copied from `src/systems/emit/` (Lean `SystemsLean.FreestandingEmit`, stage **SLAKE_EMIT_FREESTANDING_C_V0**).
- Hand-written product C is **forbidden** as Systems Lean implementation. Do not invent features by editing this tree; re-emit will overwrite.
- This directory is **not** a place to author residual progress. Systems Lean lives in Lean under `src/systems/`.
- Lake `.lake/build/ir/*.c` is classic Lean AOT IR with managed runtime -- **not** this freestanding surface; keep it untracked.
- Policy SSoT (source of truth): `AGENTS.md` (**Three languages only**, **Freestanding / ahead-of-time (AOT) C git policy**).

## Policy

- Contents come from freestanding emit under `src/systems/` only (V0: `src/systems/emit/`).
- No host elaborator residual, no `libleanshared` expectation, no product GC.
- Refresh: `just out-freestanding-c` (Lean freestanding emit + copy into this tree).
- Stage: **SLAKE_EMIT_FREESTANDING_C_V0** -- V0 emit surface exists; still **not residual free**.

## Release process (minimum)

1. `just build` -- freestanding systems product green (compile-path process-glue stamp; not product C).
2. `just out-freestanding-c` -- Lean freestanding emit + populate this tree from `src/systems/emit/`.
3. `just check` -- full suite green (human stages new `nix/` paths for flake match when needed).
4. Publish **this directory** so consumers need not clone `ref/*` or the full host monorepo.
5. Notes: freestanding bar + Unlicense on novel emit; CompCert (if used) keeps its own license.

### Consumer publish options

**Preferred: git subtree** (long-lived consumer repo, history of the release surface only):

```bash
# From monorepo root after green just out-freestanding-c + just check:
git subtree push --prefix=out/freestanding-c <consumer-remote> main
# Or split once to a branch for review:
git subtree split --prefix=out/freestanding-c -b freestanding-c-release
```

**Tarball** (one-shot drop; no git required on the consumer side):

```bash
just export-freestanding-c
# -> .cache/systems-lean-freestanding-c-<UTC>.tar.gz
# Unpack and build with a normal C toolchain (see header comments in slake_freestanding.h).
```

Consumers should treat `*.c` / `*.h` as **generated product wire**. Do not fork residual progress into a second hand-edited C tree.

**Optional later:** stop tracking monorepo dogfood `emit/*.c` after CI always regenerates; default remains tracked dogfood for local red/green.

## V0 status

V0 emit surface exists (`slake_freestanding.c` / `slake_freestanding.h` via
`SLAKE_EMIT_FREESTANDING_C_V0`). First real unit translation
(**UNIT_TRANSLATION_V0** / **UNIT_DEEPEN_V1**) maps Mult / Linear / Erasure /
Extract / Types into freestanding C APIs (grade validity, exact-once consume,
runtime-absent erasure probe, RUNTIME-FS product class, type tags). Still
**not residual free**; not PROVABLY; not freestanding residual free.
