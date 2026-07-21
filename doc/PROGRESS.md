# Progress meter (generated)

Updated: 2026-07-21 12:15:27 -0600

Evidence-based weights -- not calendar estimates. Regenerate: `just progress` or `just watch`.

## Overall (Slake / Systems Lean journey)

    [##############------]  70.0%

## By stream

- Foundation:  [####################] 100.0%
- Idris side:  [####################] 100.0%
- Lean side:   [####################] 100.0%
- Systems / freestanding: [--------------------]   0.0%

## Milestones

| Done | Weight | Side | Milestone | Evidence |
|------|--------|------|-----------|----------|
| yes | 12 | foundation | Foundation (charter, tooling, refs) | AGENTS + just + flake + submodules |
| yes | 10 | idris | Idris multiplicity map | src/idris2 multiplicity notes |
| yes | 10 | lean | Lean multiplicity map | src/lean4/multiplicity-map.md |
| yes | 10 | idris | Idris dual example (native) | src/idris2 .idr or examples/ |
| yes | 10 | lean | Lean dual example | src/lean4/examples |
| yes | 5 | idris | Idris JOIN greppable points | src/idris2/JOIN.md |
| yes | 5 | lean | Lean JOIN greppable points | src/lean4/JOIN.md |
| yes | 8 | both | Dual pair join-ready | both JOIN.md + nontrivial sides |
| no | 6 | both | Shared intermediate-representation sketch | doc/shared-ir-sketch.md |
| no | 10 | systems | Slake / systems novel sources | src/systems beyond README |
| no | 4 | systems | Systems units for just build | src/systems *.lean or *.slake |
| no | 10 | systems | out/freestanding-c product C | generated .c/.h under out/freestanding-c |

## Residuals

- Coordinator: `RESIDUAL.md`
- Idris side: `RESIDUAL-idris.md`
- Lean side: `RESIDUAL-lean.md`

## Guidance (coordinator -> forks)

- `doc/fork-guidance-idris.md`
- `doc/fork-guidance-lean.md`

SPDX-License-Identifier: Unlicense
