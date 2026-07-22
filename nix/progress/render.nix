# SPDX-License-Identifier: Unlicense
# Markdown report + console meters from scored milestones.
{ lib, bars }:
{
  milestones,
  pctOverall,
  doneW,
  totalW,
  phasePct,
  streamPct,
  phaseOrder,
  phaseLabels,
}:
let
  inherit (bars) bar bar10;

  openMs = builtins.filter (m: (!m.done) && m.weight > 0) milestones;

  phaseSection = lib.concatMapStrings (
    ph:
    let
      pct = phasePct ph;
      ms = builtins.filter (m: m.phase == ph && m.weight > 0) milestones;
      t = lib.foldl' (a: m: a + m.weight) 0 ms;
      d = lib.foldl' (a: m: a + (if m.done then m.weight else 0)) 0 ms;
    in
    ''
      ### ${phaseLabels.${ph}}

          ${bar pct}
          weight ${toString d} / ${toString t}

    ''
  ) phaseOrder;

  milestoneRows = lib.concatMapStrings (
    m:
    let
      meter = bar10 (if m.done then 100.0 else 0.0);
      w = if m.weight == 0 then "0*" else toString m.weight;
    in
    "| `${meter}` | ${w} | ${m.phase} | ${m.stream} | ${m.label} | ${m.note} |\n"
  ) milestones;

  openLines =
    if openMs == [ ] then
      "(none weighted open)\n"
    else
      lib.concatMapStrings (m: "  (${toString m.weight}) ${m.label}\n") openMs;

  report = ''
    # Progress meter (generated)

    Updated: (just progress -- regenerate)
    Generator: pure Nix (`nix/progress/`; also flake `progressReportText`).
    Evidence-based weights -- not calendar estimates.

    ## Goal -- total progress (Systems Lean / Slake freestanding journey)

        ${bar pctOverall}

    Weighted evidence: ${toString doneW} / ${toString totalW}

    North star (see `doc/goals.md`): Slake in Systems Lean, meet-in-the-middle
    Idris 2 and Lean 4 map, primary emit runtimeless freestanding C under
    `out/freestanding-c`. LLVM / CompCert PROVABLY are tracked as deferred
    (weight 0 until earned).

    ## Phases (plan milestones)

    ${phaseSection}
    ## Streams

    - Foundation:     ${bar (streamPct "foundation")}
    - Idris side:     ${bar (streamPct "idris")}
    - Lean side:      ${bar (streamPct "lean")}
    - Join (both):    ${bar (streamPct "both")}
    - Systems / freestanding: ${bar (streamPct "systems")}

    ## Milestone meters

    | Meter | Weight | Phase | Stream | Milestone | Evidence |
    |-------|--------|-------|--------|-----------|----------|
    ${milestoneRows}
    \* weight 0 = deferred track visible on the plan, not counted in totals.

    ## Open weighted milestones

    ${openLines}
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
  '';

  console = ''
    GOAL    ${bar pctOverall}

    Phases:
      foundation ${bar (phasePct "foundation")}
      bridge     ${bar (phasePct "bridge")}
      join       ${bar (phasePct "join")}
      systems    ${bar (phasePct "systems")}
      release    ${bar (phasePct "release")}

    Streams:
      foundation ${bar (streamPct "foundation")}
      idris      ${bar (streamPct "idris")}
      lean       ${bar (streamPct "lean")}
      join       ${bar (streamPct "both")}
      systems    ${bar (streamPct "systems")}

    Open weighted:
    ${openLines}
  '';
in
{
  inherit report console openLines;
}
