# SPDX-License-Identifier: Unlicense
# Pure Nix progress meters for Systems Lean / Slake.
#
#   let progress = import ./nix/progress { inherit lib; };
#   in (progress.mk root).report
{ lib }:
let
  bars = import ./bars.nix { inherit lib; };
  render = import ./render.nix { inherit lib bars; };

  phaseOrder = [
    "foundation"
    "bridge"
    "join"
    "systems"
    "release"
  ];

  phaseLabels = {
    foundation = "Foundation (charter, tooling, refs)";
    bridge = "Bridge duals (Idris side + Lean side)";
    join = "Join / map honesty (coordinator)";
    systems = "Systems Lean / Slake synthesis";
    release = "Freestanding product release surfaces";
  };

  mk =
    root:
    let
      helpers = import ./helpers.nix { inherit lib root; };
      milestones = import ./milestones.nix helpers;

      weighted = builtins.filter (m: m.weight > 0) milestones;
      totalW = lib.foldl' (a: m: a + m.weight) 0 weighted;
      doneW = lib.foldl' (a: m: a + (if m.done then m.weight else 0)) 0 weighted;
      pctOverall = if totalW == 0 then 0.0 else (doneW * 100.0) / totalW;

      streamPct =
        name:
        let
          ms = builtins.filter (m: m.stream == name && m.weight > 0) milestones;
          t = lib.foldl' (a: m: a + m.weight) 0 ms;
          d = lib.foldl' (a: m: a + (if m.done then m.weight else 0)) 0 ms;
        in
        if t == 0 then 0.0 else (d * 100.0) / t;

      phasePct =
        name:
        let
          ms = builtins.filter (m: m.phase == name && m.weight > 0) milestones;
          t = lib.foldl' (a: m: a + m.weight) 0 ms;
          d = lib.foldl' (a: m: a + (if m.done then m.weight else 0)) 0 ms;
        in
        if t == 0 then 0.0 else (d * 100.0) / t;

      rendered = render {
        inherit
          milestones
          pctOverall
          doneW
          totalW
          phasePct
          streamPct
          phaseOrder
          phaseLabels
          ;
      };
    in
    {
      inherit
        milestones
        pctOverall
        doneW
        totalW
        phasePct
        streamPct
        ;
      inherit (rendered) report console;
    };
in
{
  inherit mk bars;
}
