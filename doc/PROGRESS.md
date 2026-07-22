# Progress meter (generated)

Updated: (just progress -- regenerate)
Generator: pure Nix (`nix/progress/`; also flake `progressReportText`).
Evidence-based weights -- not calendar estimates.

## Goal -- total progress (Systems Lean / Slake freestanding journey)

    [####################] 100.0%

Weighted evidence: 136 / 136

North star (see `doc/goals.md`): Slake in Systems Lean, meet-in-the-middle
Idris 2 and Lean 4 map, primary emit runtimeless freestanding C under
`out/freestanding-c`. LLVM / CompCert PROVABLY are tracked as deferred
(weight 0 until earned).

## Phases (plan milestones)

### Foundation (charter, tooling, refs)

    [####################] 100.0%
    weight 20 / 20

### Bridge duals (Idris side + Lean side)

    [####################] 100.0%
    weight 56 / 56

### Join / map honesty (coordinator)

    [####################] 100.0%
    weight 22 / 22

### Systems Lean / Slake synthesis

    [####################] 100.0%
    weight 22 / 22

### Freestanding product release surfaces

    [####################] 100.0%
    weight 16 / 16


## Streams

- Foundation:     [####################] 100.0%
- Idris side:     [####################] 100.0%
- Lean side:      [####################] 100.0%
- Join (both):    [####################] 100.0%
- Systems / freestanding: [####################] 100.0%

## Milestone meters

| Meter | Weight | Phase | Stream | Milestone | Evidence |
|-------|--------|-------|--------|-----------|----------|
| `[##########] 100.0%` | 12 | foundation | foundation | Foundation (charter, tooling, refs) | AGENTS + just + flake + watcher + residual + nix tooling modules |
| `[##########] 100.0%` | 4 | foundation | foundation | Goals / vocabulary / architecture | doc/goals + vocabulary + architecture + divergence |
| `[##########] 100.0%` | 4 | foundation | foundation | Fork prompts + dual residuals | fork-*.md + RESIDUAL-idris/lean |
| `[##########] 100.0%` | 10 | bridge | idris | Idris multiplicity map | src/idris2 multiplicity notes |
| `[##########] 100.0%` | 10 | bridge | lean | Lean multiplicity map | src/lean4/multiplicity-map.md |
| `[##########] 100.0%` | 10 | bridge | idris | Idris dual example (native) | src/idris2 .idr |
| `[##########] 100.0%` | 10 | bridge | lean | Lean dual example | src/lean4/examples |
| `[##########] 100.0%` | 5 | bridge | idris | Idris JOIN greppable points | src/idris2/JOIN.md |
| `[##########] 100.0%` | 5 | bridge | lean | Lean JOIN greppable points | src/lean4/JOIN.md |
| `[##########] 100.0%` | 3 | bridge | idris | Idris presence red/green gate | src/idris2/check.sh |
| `[##########] 100.0%` | 3 | bridge | lean | Lean presence red/green gate | src/lean4/check.sh |
| `[##########] 100.0%` | 8 | join | both | Dual pair join-ready | both JOIN.md + nontrivial sides |
| `[##########] 100.0%` | 6 | join | both | Divergence imperfect edges joined | doc/divergence.md cites dual imperfect edges |
| `[##########] 100.0%` | 8 | join | both | Shared intermediate-representation sketch | doc/shared-ir-sketch.md |
| `[##########] 100.0%` | 12 | systems | systems | Slake / systems novel sources | src/systems beyond README |
| `[##########] 100.0%` | 6 | systems | systems | Systems units for just build | src/systems *.lean or *.slake |
| `[##########] 100.0%` | 4 | systems | systems | Min mult 0/1/omega host notes in systems | src/systems mult / QTT surface |
| `[##########] 100.0%` | 12 | release | systems | out/freestanding-c product C | generated .c/.h under out/freestanding-c |
| `[##########] 100.0%` | 4 | release | systems | just out-freestanding-c / build path | emit + build scripts present |
| `[----------] 0.0%` | 0* | release | systems | CompCert PROVABLY path (deferred weight 0) | needs real ccomp + matrix -- not claimed |
| `[----------] 0.0%` | 0* | release | systems | out/llvm-ir (deferred until self-host, weight 0) | deferred -- recipe reserved |

\* weight 0 = deferred track visible on the plan, not counted in totals.

## Open weighted milestones

(none weighted open)

## Residuals

- Coordinator: `RESIDUAL.md`
- Idris side: `RESIDUAL-idris.md`
- Lean side: `RESIDUAL-lean.md`
- Systems / Slake: `RESIDUAL-systems.md`
- Next implement prompt: `WATCHER.md` (watcher session; do not race Slake)

## Guidance

- `doc/fork-guidance-idris.md`
- `doc/fork-guidance-lean.md`
- `doc/fork-guidance-systems.md`

SPDX-License-Identifier: Unlicense
