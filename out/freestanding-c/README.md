# out/freestanding-c -- runtimeless product C

**Release surface:** freestanding product C (and headers) that others can build with a normal C toolchain **without** a Lean managed runtime, GC (garbage collection), or host elaborator on the link line.

Name emphasizes **runtimeless / freestanding**, not classic AOT (ahead-of-time) that still ships a runtime.

## Policy

- Contents come from freestanding emit under `src/systems/` only.
- No host elaborator residual, no `libleanshared` expectation, no product GC.
- Refresh: `just out-freestanding-c` (see `script/out-freestanding-c.sh`).

## Release process (minimum)

1. `just build` -- freestanding systems product green.
2. `just out-freestanding-c` -- populate this tree from emit.
3. `just check` -- full suite green.
4. Publish **this directory** via **git subtree** (or tarball) so consumers need not clone `ref/*` or the full host.
5. Notes: freestanding bar + Unlicense on novel emit; CompCert (if used) keeps its own license.

Until emit exists, this tree is a documented empty product surface.
