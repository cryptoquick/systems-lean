# SPDX-License-Identifier: Unlicense
# Weighted evidence milestones (not calendar). Consumed by progress/default.nix.
{
  exists,
  dirNontrivial,
  hasSuffixIn,
  fileContains,
  freestandingC,
}:
[
  {
    id = "foundation";
    label = "Foundation (charter, tooling, refs)";
    weight = 12;
    stream = "foundation";
    phase = "foundation";
    done =
      exists "AGENTS.md"
      && exists "justfile"
      && exists "flake.nix"
      && exists "WATCHER.md"
      && exists "RESIDUAL.md"
      && exists "nix/progress/default.nix"
      && exists "nix/source-hygiene.nix";
    note = "AGENTS + just + flake + watcher + residual + nix tooling modules";
  }
  {
    id = "docs_charter";
    label = "Goals / vocabulary / architecture";
    weight = 4;
    stream = "foundation";
    phase = "foundation";
    done =
      exists "doc/goals.md"
      && exists "doc/vocabulary.md"
      && exists "doc/architecture.md"
      && exists "doc/divergence.md";
    note = "doc/goals + vocabulary + architecture + divergence";
  }
  {
    id = "fork_prompts";
    label = "Fork prompts + dual residuals";
    weight = 4;
    stream = "foundation";
    phase = "foundation";
    done =
      exists "doc/fork-idris.md"
      && exists "doc/fork-lean.md"
      && exists "doc/fork-coordinator.md"
      && exists "RESIDUAL-idris.md"
      && exists "RESIDUAL-lean.md";
    note = "fork-*.md + RESIDUAL-idris/lean";
  }
  {
    id = "idris_mult";
    label = "Idris multiplicity map";
    weight = 10;
    stream = "idris";
    phase = "bridge";
    done = exists "src/idris2/multiplicity-map.md";
    note = "src/idris2 multiplicity notes";
  }
  {
    id = "lean_mult";
    label = "Lean multiplicity map";
    weight = 10;
    stream = "lean";
    phase = "bridge";
    done = exists "src/lean4/multiplicity-map.md";
    note = "src/lean4/multiplicity-map.md";
  }
  {
    id = "idris_example";
    label = "Idris dual example (native)";
    weight = 10;
    stream = "idris";
    phase = "bridge";
    done = hasSuffixIn "src/idris2" [ ".idr" ];
    note = "src/idris2 .idr";
  }
  {
    id = "lean_example";
    label = "Lean dual example";
    weight = 10;
    stream = "lean";
    phase = "bridge";
    done =
      exists "src/lean4/examples/ConsumeToken.lean"
      || hasSuffixIn "src/lean4/examples" [ ".lean" ];
    note = "src/lean4/examples";
  }
  {
    id = "idris_join";
    label = "Idris JOIN greppable points";
    weight = 5;
    stream = "idris";
    phase = "bridge";
    done = exists "src/idris2/JOIN.md";
    note = "src/idris2/JOIN.md";
  }
  {
    id = "lean_join";
    label = "Lean JOIN greppable points";
    weight = 5;
    stream = "lean";
    phase = "bridge";
    done = exists "src/lean4/JOIN.md";
    note = "src/lean4/JOIN.md";
  }
  {
    id = "idris_check";
    label = "Idris presence red/green gate";
    weight = 3;
    stream = "idris";
    phase = "bridge";
    done = exists "src/idris2/check.sh";
    note = "src/idris2/check.sh";
  }
  {
    id = "lean_check";
    label = "Lean presence red/green gate";
    weight = 3;
    stream = "lean";
    phase = "bridge";
    done = exists "src/lean4/check.sh";
    note = "src/lean4/check.sh";
  }
  {
    id = "dual_pair";
    label = "Dual pair join-ready";
    weight = 8;
    stream = "both";
    phase = "join";
    done =
      exists "src/idris2/JOIN.md"
      && exists "src/lean4/JOIN.md"
      && dirNontrivial "src/idris2"
      && dirNontrivial "src/lean4";
    note = "both JOIN.md + nontrivial sides";
  }
  {
    id = "divergence_edges";
    label = "Divergence imperfect edges joined";
    weight = 6;
    stream = "both";
    phase = "join";
    done = fileContains "doc/divergence.md" "imperfect";
    note = "doc/divergence.md cites dual imperfect edges";
  }
  {
    id = "shared_ir";
    label = "Shared intermediate-representation sketch";
    weight = 8;
    stream = "both";
    phase = "join";
    done = exists "doc/shared-ir-sketch.md";
    note = "doc/shared-ir-sketch.md";
  }
  {
    id = "systems_skeleton";
    label = "Slake / systems novel sources";
    weight = 12;
    stream = "systems";
    phase = "systems";
    done = dirNontrivial "src/systems";
    note = "src/systems beyond README";
  }
  {
    id = "build_units";
    label = "Systems units for just build";
    weight = 6;
    stream = "systems";
    phase = "systems";
    done = hasSuffixIn "src/systems" [
      ".lean"
      ".slake"
    ];
    note = "src/systems *.lean or *.slake";
  }
  {
    id = "min_mult_host";
    label = "Min mult 0/1/omega host notes in systems";
    weight = 4;
    stream = "systems";
    phase = "systems";
    done =
      fileContains "src/systems/README.md" "multiplicit"
      || fileContains "src/systems/mult.md" "MULT-0"
      || fileContains "src/systems/Mult.slake" "MULT";
    note = "src/systems mult / QTT surface";
  }
  {
    id = "freestanding_c";
    label = "out/freestanding-c product C";
    weight = 12;
    stream = "systems";
    phase = "release";
    done = freestandingC;
    note = "generated .c/.h under out/freestanding-c";
  }
  {
    id = "freestanding_gate";
    label = "just out-freestanding-c / build path";
    weight = 4;
    stream = "systems";
    phase = "release";
    done =
      exists "justfile"
      && exists "script/slake-compile-path.sh"
      && exists "src/systems/SystemsLean/FreestandingEmit.lean"
      && exists "src/systems/emit/template_slake_freestanding.h.in"
      && exists "src/systems/emit/template_slake_freestanding.c.in";
    note = "just build + just out-freestanding-c (Wave B); emit driver until Wave C";
  }
  {
    id = "compcert_path";
    label = "CompCert PROVABLY path (deferred weight 0)";
    weight = 0;
    stream = "systems";
    phase = "release";
    done = false;
    note = "needs real ccomp + matrix -- not claimed";
  }
  {
    id = "llvm_path";
    label = "out/llvm-ir (deferred until self-host, weight 0)";
    weight = 0;
    stream = "systems";
    phase = "release";
    done = false;
    note = "deferred -- recipe reserved";
  }
]
