# Systems Lean -- thin task runner only (https://github.com/casey/just)
# Three languages only for novel work: Idris 2, Lean 4 (Slake/Systems Lean), pure Nix.
# just orchestrates (redirects, loops). Does not host product or tooling algorithms.
# Residual script/*.sh and workspace check.sh are migration debt -- shrink, do not grow.

set shell := ["bash", "-euo", "pipefail", "-c"]

# Pure Nix expression: progress report text from live tree (impure root only).
_progress_report := '''
let
  lib = (import (builtins.getFlake "nixpkgs") {}).lib;
  p = import ./nix/progress { inherit lib; };
in (p.mk ./. ).report
'''

_progress_console := '''
let
  lib = (import (builtins.getFlake "nixpkgs") {}).lib;
  p = import ./nix/progress { inherit lib; };
in (p.mk ./. ).console
'''

_hygiene := '''
let
  lib = (import (builtins.getFlake "nixpkgs") {}).lib;
  novel = import ./nix/novel-source.nix { inherit lib; src = ./.; };
  h = import ./nix/source-hygiene.nix { inherit lib; root = novel; };
in if h.ok then h.summary + "\n" else throw h.summary
'''

_systems_host := '''
let
  lib = (import (builtins.getFlake "nixpkgs") {}).lib;
  novel = import ./nix/novel-source.nix { inherit lib; src = ./.; };
  h = import ./nix/systems-host-presence { inherit lib; root = novel; };
in if h.ok then h.summary + "\n" else throw h.summary
'''

_systems_emit_wire := '''
let
  lib = (import (builtins.getFlake "nixpkgs") {}).lib;
  novel = import ./nix/novel-source.nix { inherit lib; src = ./.; };
  h = import ./nix/systems-emit-wire { inherit lib; root = novel; };
in if h.ok then h.summary + "\n" else throw h.summary
'''

# List recipes (default when you run bare `just`).
default:
    @just --list

# Full suite: pure hygiene + host presence + emit-wire + flake check + residual gates.
# Live pure gates (systems-host, systems-emit-wire, hygiene) use impure eval of the
# worktree and do not require new nix/ files to be git-tracked. nix flake check
# only sees tracked files -- after adding a pure Nix module, human must git add
# before flake/CI match. On flake track errors, residual scripts still run; suite
# exits non-zero with a clear pointer to just systems-host / just systems-emit-wire.
check: hygiene systems-host systems-emit-wire
    #!/usr/bin/env bash
    set -euo pipefail
    set +e
    nix flake check
    flake_rc=$?
    set -e
    if [[ "$flake_rc" -ne 0 ]]; then
      echo "WARN: nix flake check failed (rc=$flake_rc)." >&2
      echo "If error is 'not tracked by Git' for a new nix/ module: pure live gates" >&2
      echo "already ran (just systems-host, just systems-emit-wire, just hygiene)." >&2
      echo "Agent hands-off git." >&2
      echo "Human: git add nix/systems-host-presence/ nix/systems-emit-wire/ src/systems/smoke/ src/systems/lakefile.toml src/systems/lean-toolchain src/systems/lake-manifest.json src/systems/SystemsLean.lean src/systems/SystemsLean/ (and flake/just edits) then re-run." >&2
    fi
    if [[ -f ./src/idris2/check.sh ]]; then bash ./src/idris2/check.sh; fi
    if [[ -f ./src/lean4/check.sh ]]; then bash ./src/lean4/check.sh; fi
    if [[ -f ./src/systems/check.sh ]]; then bash ./src/systems/check.sh; fi
    if [[ "$flake_rc" -ne 0 ]]; then
      echo "check incomplete: flake rc=$flake_rc (live pure gates + workspace scripts ran)" >&2
      exit "$flake_rc"
    fi
    echo "check OK"

# Freestanding Systems Lean product under src/systems/ (Slake host synthesis).
# Residual: migrate body to flake package; thin script remains until then.
build:
    ./script/build-systems.sh

# Emit / refresh runtimeless freestanding C under out/freestanding-c.
out-freestanding-c:
    ./script/out-freestanding-c.sh

# LLVM IR release surface (deferred until self-hosted Systems Lean / Slake).
out-llvm-ir:
    @echo "out-llvm-ir: deferred until self-hosted Systems Lean in Slake (see out/llvm-ir/README.md)"

# Pre-commit path.
pre-commit: check

# Pure Nix progress meters -> doc/PROGRESS.md + console summary.
progress:
    mkdir -p doc
    nix eval --impure --raw --expr {{quote(_progress_report)}} > doc/PROGRESS.md
    nix eval --impure --raw --expr {{quote(_progress_console)}}
    @echo "wrote doc/PROGRESS.md"

# Progress meters plus scc . snapshot (size appendix; scc is an external binary).
progress-scc: progress
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p doc .cache
    set +e
    scc . > .cache/last-scc.txt 2>&1
    scc_rc=$?
    set -e
    tr -cd '\11\12\15\40-\176\n' < .cache/last-scc.txt > .cache/last-scc.ascii
    {
      echo "# scc . snapshot (generated)"
      echo ""
      echo "Exit: $scc_rc"
      echo "Generator: just progress-scc (scc from PATH / nixpkgs)"
      echo ""
      echo '```'
      head -n 80 .cache/last-scc.ascii
      echo '```'
      echo ""
      echo "SPDX-License-Identifier: Unlicense"
    } > doc/PROGRESS-scc.txt
    {
      echo ""
      echo "## Code size (\`scc .\`)"
      echo ""
      echo "Exit: $scc_rc -- full snapshot: \`doc/PROGRESS-scc.txt\`"
      echo ""
      echo '```'
      head -n 22 .cache/last-scc.ascii
      echo '```'
    } >> doc/PROGRESS.md
    echo "scc snapshot -> doc/PROGRESS-scc.txt (rc=$scc_rc)"

# Pure Nix source hygiene (ASCII + no trailing WS) on novel source.
hygiene:
    @nix eval --impure --raw --expr {{quote(_hygiene)}}

# Pure Nix systems host presence (skeleton + unit-surface + SYSTEMS_LEAN_HOST +
# tree-wide banned-jargon walk under src/systems). Live impure worktree eval.
systems-host:
    @nix eval --impure --raw --expr {{quote(_systems_host)}}

# Pure Nix systems emit-wire presence (drivers, UNIT_DEEPEN, emit product stages,
# unit-surface walk, optional release surface). Live impure worktree eval.
systems-emit-wire:
    @nix eval --impure --raw --expr {{quote(_systems_emit_wire)}}

# Poll: meters + scc + hygiene. Interval is loop sleep, not cycle cost.
# Override: WATCH_INTERVAL=60 just watch
watch:
    #!/usr/bin/env bash
    set -euo pipefail
    INTERVAL="${WATCH_INTERVAL:-300}"
    LOG="${WATCH_LOG:-doc/progress-log.md}"
    mkdir -p doc .cache
    if [[ ! -s "$LOG" ]]; then
      printf '%s\n' \
        '# Fork progress log' \
        '' \
        'Append-only cycle notes from just watch.' \
        'Each cycle: pure Nix progress meters + scc . + source-hygiene.' \
        'ASCII only. Tooling is pure Nix modules under nix/; just orchestrates.' \
        '' >"$LOG"
    fi
    echo "systems-lean watch: interval=${INTERVAL}s log=$LOG"
    echo "note: process elapsed time is loop uptime, not cycle cost"
    cycle=0
    while true; do
      cycle=$((cycle + 1))
      ts=$(date -Is 2>/dev/null || date)
      echo ""
      echo "======== watch cycle $cycle @ $ts ========"
      just progress-scc || true
      set +e
      just hygiene
      hyg_rc=$?
      set -e
      {
        echo "## cycle $cycle -- $ts"
        echo ""
        echo "- progress: just progress-scc"
        echo "- hygiene rc=$hyg_rc"
        echo "- see doc/PROGRESS.md and doc/PROGRESS-scc.txt"
        echo ""
      } >>"$LOG"
      echo "sleeping ${INTERVAL}s..."
      sleep "$INTERVAL"
    done
