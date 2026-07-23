# Paydown Wave A join summary

Kind: paydown join summary.

Date: 2026-07-22

Plan: `.agents/plans/plan-paydown-shell-c-surfaces.md` Wave A (step 1).

## What landed

Static file/token presence mills moved out of dual `check.sh` into pure Nix
modules mirroring `nix/systems-host-presence/`. Dual shells keep optional
elaborator process glue only.

### New pure Nix modules

| Module | Paths | Live gate | Flake check |
|--------|-------|-----------|-------------|
| Idris-side dual presence | `nix/idris-side-presence/{default,specs}.nix` | `just idris-side` | `idris-side-presence` |
| Lean-side dual presence | `nix/lean-side-presence/{default,specs}.nix` | `just lean-side` | `lean-side-presence` |

### Files changed

- `nix/idris-side-presence/default.nix` (new)
- `nix/idris-side-presence/specs.nix` (new)
- `nix/lean-side-presence/default.nix` (new)
- `nix/lean-side-presence/specs.nix` (new)
- `justfile` -- `_idris_side` / `idris-side`, `_lean_side` / `lean-side`; folded into `check` before residual bash
- `flake.nix` -- lib exports + checks for both modules
- `src/idris2/check.sh` -- thinned to optional `idris2 --check` only
- `src/lean4/check.sh` -- thinned to optional Lake elaborator only
- `AGENTS.md` -- scheduled-deletion dual rows marked Wave A met; Nix map + command list updated
- `doc/dev/research/paydown-wave-a-summary.md` (this file)

### Not touched

- `script/slake-emit-freestanding-c.sh` (Wave C)
- Systems host / emit-wire modules (already pure)
- No git add / stage / commit (HITL)

## How to run gates

```bash
just idris-side      # pure Nix dual Idris static presence
just lean-side       # pure Nix dual Lean static presence
just hygiene         # ASCII + trailing WS + professional-tone
just systems-host    # still green (unchanged contract)
bash src/idris2/check.sh   # optional elaborator; skip-if-missing ok
bash src/lean4/check.sh    # optional Lake; skip-if-missing / pin-guard ok
just check           # pure gates first (incl. idris-side + lean-side), then flake, then residual shells
```

Live `just idris-side` / `just lean-side` use impure worktree eval and do **not**
require new `nix/` paths to be git-tracked.

## Shell line delta (estimate)

| Path | Before (approx) | After | Delta |
|------|-----------------|-------|-------|
| `src/idris2/check.sh` | ~90 | 30 | about -60 shell lines |
| `src/lean4/check.sh` | ~125 | 67 | about -58 shell lines |
| Dual static mills total | ~215 | ~97 glue | about -118 shell lines of presence mill |

Residual shell left in dual `check.sh`:

- Idris: optional `idris2 --check` loop + skip message (~30 lines)
- Lean: elan toolchain guard + optional `lake build` (~67 lines)

Static presence algorithms live only under pure Nix.

## HITL note (human staging)

Agents did **not** `git add` / stage / commit.

For `nix flake check` and continuous integration (CI) to see the new modules,
the human must stage at least:

- `nix/idris-side-presence/`
- `nix/lean-side-presence/`
- plus related edits (`flake.nix`, `justfile`, dual `check.sh`, `AGENTS.md`, this summary)

Until then, live pure gates remain green via impure `just`; flake may WARN on
untracked paths. Policy: `AGENTS.md` (Nix tooling / HITL stage + Git hands-off).

## Acceptance (ran green this slice)

- `just idris-side` OK (7 required paths; content tokens; jargon files=3)
- `just lean-side` OK (10 required paths; content tokens; jargon files=3)
- `just hygiene` OK
- `just systems-host` OK
- Thin dual `check.sh` GREEN (idris2 skip; lake build green when pin present)

Wave B not started.
