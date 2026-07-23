# Paydown Wave D + E join summary

Kind: paydown join summary.

Date: 2026-07-22

Plan: `.agents/plans/plan-paydown-shell-c-surfaces.md` Waves D and E.

## Wave D -- release layout

- Hardened `out/freestanding-c/README.md` with concrete **git subtree** and
  **tarball** consumer publish steps.
- Added `just export-freestanding-c` (depends on `out-freestanding-c`): writes
  `.cache/systems-lean-freestanding-c-<UTC>.tar.gz` from `out/freestanding-c`.
- Default remains: monorepo tracks dogfood product wire for local red/green;
  optional later untrack is documented, not forced.

## Wave E -- behavioral tests + scc honesty

- Product-linked probe stays under `src/systems/smoke/slake_behavioral_probe.c`
  as **behavioral tests** (permanent role), not endless "smoke debt" in policy
  docs (`AGENTS.md` / vocabulary already reframed in Wave 0).
- Do not grow probe without need; shrink only when Lean theorems duplicate a
  live `cc` contract with evidence.
- Honest novel `scc` excludes already in `just progress-scc`: `.git`, `ref`,
  `.lake`, `.cache` (Wave 0).

## Novel scc snapshot (post Wave C+; excludes above)

Approximate code lines (see `doc/PROGRESS-scc.txt`):

| Language | Code lines | Role |
|----------|------------|------|
| Lean | ~4159 | Product + host |
| Nix | ~4236 | Pure tooling |
| Markdown | ~5514 | Prose |
| Shell | ~268 | Process glue only |
| C + Header | ~3327 | Product wire + behavioral tests + templates classified partly as Autoconf by scc |

Shell code dropped from ~2500+ (with emit bash) to **~268**.

## Remaining process glue (not product algorithms)

- `script/slake-compile-path.sh` (~150)
- `src/systems/check.sh` (~99) Lake + drivers + cc tests
- Dual elaborator thin shells (~30 + ~67)

## HITL

Stage new `nix/` paths (Wave A dual presence and any later) before flake/CI
match. Agents do not git add.

## Honesty

Still **not residual free**, **not PROVABLY**. No llvm unlock.
