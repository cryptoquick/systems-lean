# Paydown Wave B join summary

Kind: paydown join summary.

Date: 2026-07-22

Plan: `.agents/plans/plan-paydown-shell-c-surfaces.md` Wave B (step 2).

## What landed

Collapse small process shells into short just recipes + remaining driver calls.
No bash-in-Nix. Emit generator (~2k lines) left for Wave C.

### Deleted

| Path | Former role | Replacement |
|------|-------------|-------------|
| `script/out-freestanding-c.sh` | Emit + clean-install into `out/freestanding-c` | `just out-freestanding-c` recipe body |
| `script/build-systems.sh` | Marker walk + compile-path invoke | `just build` -> `script/slake-compile-path.sh` (markers also pure Nix unit walk) |

### Thinned

| Path | Before | After | Notes |
|------|--------|-------|-------|
| `src/systems/check.sh` | ~228 | ~99 | Process glue: optional Lake, compile-path, `just out-freestanding-c`, cc + behavioral tests |
| `script/slake-compile-path.sh` | ~149 | ~149 | Kept; comments only (stage manifest still required) |

### Pure Nix retarget (live gates; HITL stage for flake)

| Path | Change |
|------|--------|
| `nix/systems-emit-wire/emit-product.nix` | Drop required/content specs for deleted scripts; require `justfile` tokens instead |
| `nix/progress/milestones.nix` | `freestanding_gate` done when justfile + compile-path + emit drivers exist |

No **new** `nix/` module paths -- only edits to existing emit-wire data and progress milestones. Human stages when flake/CI should match live pure gates.

### justfile

- `just build` -- short recipe; fail closed if compile-path driver missing; honest not product C
- `just out-freestanding-c` -- require README, run emit driver, clean-install `.c`/`.h`, honest not residual free / not PROVABLY

### Docs

- `AGENTS.md` scheduled-deletion rows Wave B met
- `RESIDUAL.md` / `RESIDUAL-systems.md` join honesty for build/out paths
- `src/systems/README.md`, `out/freestanding-c/README.md` script path updates
- This file

### Not touched

- `script/slake-emit-freestanding-c.sh` (Wave C)
- Probe C / emit product body (no growth)
- No git add / stage / commit

## Gates (acceptance)

```bash
just hygiene
just systems-host
just systems-emit-wire
just idris-side
just lean-side
just build
just out-freestanding-c
bash src/systems/check.sh
just check   # flake may WARN if related nix/ edits untracked -- live pure gates must green
```

## Shell residual after Wave B

| Path | Role | Next wave |
|------|------|-----------|
| `script/slake-emit-freestanding-c.sh` | ~2070 scheduled deletion | Wave C Lean-owned emit writer, then delete |
| `script/slake-compile-path.sh` | ~150 process/structure driver | Thin/port later; not Wave C kill target |
| `src/systems/check.sh` | ~99 process glue | Keep thin; Lake/cc/drivers |
| `src/idris2/check.sh` / `src/lean4/check.sh` | Thin elaborator glue (Wave A) | Stay thin |
| justfile bash bodies | Process glue for build/out/check orchestration | Permanent role when tiny |

## Hard non-claims

- Not residual free
- Not PROVABLY
- Not freestanding self-host complete
- Not llvm unlock
- Shell not gone (emit generator remains)

SPDX-License-Identifier: Unlicense
