# Systems Lean -- thin task runner only (https://github.com/casey/just)
# Three languages only for novel work: Idris 2, Lean 4 (Slake/Systems Lean), pure Nix.
# just orchestrates (redirects, loops). Does not host product or tooling algorithms.
# Residual script/*.sh and fat check.sh are scheduled deletion / process glue -- pay down, do not grow.
# Plan: .agents/plans/plan-paydown-shell-c-surfaces.md

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
  t = import ./nix/professional-tone.nix { inherit lib; root = novel; };
  ok = h.ok && t.ok;
  summary =
    if ok then
      h.summary + "; " + t.summary
    else
      lib.concatStringsSep "\n" (
        (if h.ok then [ ] else [ h.summary ])
        ++ (if t.ok then [ ] else [ t.summary ])
      );
in if ok then summary + "\n" else throw summary
'''

_professional_tone := '''
let
  lib = (import (builtins.getFlake "nixpkgs") {}).lib;
  novel = import ./nix/novel-source.nix { inherit lib; src = ./.; };
  t = import ./nix/professional-tone.nix { inherit lib; root = novel; };
in if t.ok then t.summary + "\n" else throw t.summary
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

_idris_side := '''
let
  lib = (import (builtins.getFlake "nixpkgs") {}).lib;
  novel = import ./nix/novel-source.nix { inherit lib; src = ./.; };
  h = import ./nix/idris-side-presence { inherit lib; root = novel; };
in if h.ok then h.summary + "\n" else throw h.summary
'''

_lean_side := '''
let
  lib = (import (builtins.getFlake "nixpkgs") {}).lib;
  novel = import ./nix/novel-source.nix { inherit lib; src = ./.; };
  h = import ./nix/lean-side-presence { inherit lib; root = novel; };
in if h.ok then h.summary + "\n" else throw h.summary
'''

# List recipes (default when you run bare `just`).
default:
    @just --list

# Full suite: pure hygiene + host/emit-wire + dual presence + flake + residual glue.
# Live pure gates (systems-host, systems-emit-wire, idris-side, lean-side, hygiene)
# use impure eval of the worktree and do not require new nix/ files to be
# git-tracked. nix flake check only sees tracked files -- after adding under
# nix/ (or related flake copy paths), the human must stage those paths before
# flake/continuous integration (CI) match. Agents never git add / stage / commit
# to silence flake WARN (human-in-the-loop (HITL) stage; see AGENTS.md Nix tooling).
# On flake failure, residual workspace scripts still run; suite exits non-zero.
check: hygiene systems-host systems-emit-wire idris-side lean-side
    #!/usr/bin/env bash
    set -euo pipefail
    set +e
    nix flake check
    flake_rc=$?
    set -e
    if [[ "$flake_rc" -ne 0 ]]; then
      echo "WARN: nix flake check failed (rc=$flake_rc)." >&2
      echo "Live pure gates already ran (just systems-host, just systems-emit-wire," >&2
      echo "just idris-side, just lean-side, just hygiene)." >&2
      echo "If the flake error is missing/untracked paths: that is human-in-the-loop (HITL)" >&2
      echo "stage -- not agent work. Agents never git add, stage, or commit to silence this WARN." >&2
      echo "Human: stage the untracked paths named in the flake error (or git status under" >&2
      echo "nix/ and related flake copy paths), then re-run. No fixed path list here (rots)." >&2
      echo "Policy: AGENTS.md (Nix tooling / HITL stage + Git hands-off)." >&2
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
# UNIT_SURFACE marker walk is pure Nix (systems-emit-wire). Compile-path driver is stamp only.
# Not product C; product wire is just out-freestanding-c (SLAKE_EMIT_FREESTANDING_C_V0).
build:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "== systems freestanding build =="
    echo "workspace: src/systems/  (Slake host synthesis; min QTT mults)"
    echo "policy: no runtime GC on product wire; RC only if proven necessary"
    driver="script/slake-compile-path.sh"
    if [[ ! -f "$driver" ]]; then
      echo "error: compile-path driver missing: $driver" >&2
      echo "  residual requires SLAKE_COMPILE_PATH_V0 (fail closed)." >&2
      exit 1
    fi
    if [[ -x "$driver" ]]; then
      ./"$driver"
    else
      bash "$driver"
    fi
    echo "systems: compile-path GREEN; product C via just out-freestanding-c (SLAKE_EMIT_FREESTANDING_C_V0)."
    echo "  not freestanding residual free; not product C from this build stage"

# Emit / refresh runtimeless freestanding C under out/freestanding-c.
# Wave C: Lean-owned emit (SystemsLean.FreestandingEmit / lake exe
# slake-emit-freestanding-c). Optional compile-path process-glue stamp first
# (static unit walk is pure Nix systems-emit-wire / systems-host).
# Product emit requires host Lean pin (elan + lake); fail closed if missing.
out-freestanding-c:
    #!/usr/bin/env bash
    set -euo pipefail
    root=$(pwd)
    dest=out/freestanding-c
    emit_dir="src/systems/emit"
    systems_dir="src/systems"
    compile_driver="script/slake-compile-path.sh"
    mkdir -p "$dest"
    echo "== out freestanding-c -> $dest =="
    echo "Release: runtimeless product C (no Lean managed runtime / product GC on the wire)."
    echo "  not residual free; not PROVABLY"
    echo "  emit: Lean SLAKE_EMIT_FREESTANDING_C_V0 (SystemsLean.FreestandingEmit)"
    if [[ ! -f "$dest/README.md" ]]; then
      echo "error: missing $dest/README.md" >&2
      exit 1
    fi
    if [[ ! -f "$systems_dir/lakefile.toml" || ! -f "$systems_dir/SystemsLean/FreestandingEmit.lean" ]]; then
      echo "error: Lean freestanding emit missing under $systems_dir" >&2
      echo "  residual requires SLAKE_EMIT_FREESTANDING_C_V0 Lean writer (fail closed)." >&2
      exit 1
    fi
    if ! command -v lake >/dev/null 2>&1; then
      echo "error: lake not on PATH; freestanding emit requires host Lean pin" >&2
      echo "  install elan pin from $systems_dir/lean-toolchain then retry." >&2
      exit 1
    fi
    # Process-glue stamp before product emit (static unit walk is pure Nix).
    if [[ -f "$compile_driver" ]]; then
      if [[ -x "$compile_driver" ]]; then
        ./"$compile_driver"
      else
        bash "$compile_driver"
      fi
    fi
    (
      cd "$systems_dir"
      lake build slake-emit-freestanding-c
      lake exe slake-emit-freestanding-c -- "$root"
    )
    mapfile -t artifacts < <(find "$emit_dir" -type f \( -name 'slake_freestanding.c' -o -name 'slake_freestanding.h' \) 2>/dev/null | sort || true)
    if [[ ${#artifacts[@]} -eq 0 ]]; then
      echo "error: after emit, no slake_freestanding.c/.h under $emit_dir to copy into $dest" >&2
      exit 1
    fi
    for stale in "$dest"/*.c "$dest"/*.h; do
      if [[ -f "$stale" ]]; then
        rm -f "$stale"
        echo "  remove stale: $stale"
      fi
    done
    copied=0
    for src in "${artifacts[@]}"; do
      base=$(basename "$src")
      cp -f "$src" "$dest/$base"
      echo "  copy: $src -> $dest/$base"
      copied=$((copied + 1))
    done
    echo "out-freestanding-c: copied ${copied} product file(s) into $dest"
    echo "  not residual free; not PROVABLY; no product GC; not Lean managed runtime"
    echo "  stage: SLAKE_EMIT_FREESTANDING_C_V0 + UNIT_DEEPEN_V1 (still not residual free)"

# Package out/freestanding-c for consumers (tarball). Does not publish git.
# Prefer git subtree for long-lived consumer trees (see out/freestanding-c/README.md).
# Regenerates product wire first. Not residual free; not PROVABLY.
export-freestanding-c: out-freestanding-c
    #!/usr/bin/env bash
    set -euo pipefail
    dest=out/freestanding-c
    mkdir -p .cache
    stamp=$(date -u +%Y%m%dT%H%M%SZ)
    archive=".cache/systems-lean-freestanding-c-${stamp}.tar.gz"
    if [[ ! -f "$dest/README.md" || ! -f "$dest/slake_freestanding.c" || ! -f "$dest/slake_freestanding.h" ]]; then
      echo "error: incomplete release surface under $dest" >&2
      exit 1
    fi
    tar -czf "$archive" -C out freestanding-c
    echo "export-freestanding-c: wrote $archive"
    echo "  consumer tree is product wire only (no ref/*, no host elaborator required)"
    echo "  not residual free; not PROVABLY"
    echo "  subtree publish: see out/freestanding-c/README.md"

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

# Progress meters plus scc novel snapshot (size appendix; scc is an external binary).
# Honest novel excludes: ref (upstream), .lake (classic Lean AOT IR), .cache, .git.
# Product wire C and behavioral tests remain in the count; they are permanent roles.
progress-scc: progress
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p doc .cache
    set +e
    scc . --exclude-dir .git --exclude-dir ref --exclude-dir .lake --exclude-dir .cache \
      > .cache/last-scc.txt 2>&1
    scc_rc=$?
    set -e
    tr -cd '\11\12\15\40-\176\n' < .cache/last-scc.txt > .cache/last-scc.ascii
    {
      echo "# scc novel snapshot (generated)"
      echo ""
      echo "Exit: $scc_rc"
      echo "Generator: just progress-scc (scc from PATH / nixpkgs)"
      echo "Excludes: .git ref .lake .cache (honest novel; not freestanding vs classic AOT confusion)"
      echo ""
      echo '```'
      head -n 80 .cache/last-scc.ascii
      echo '```'
      echo ""
      echo "SPDX-License-Identifier: Unlicense"
    } > doc/PROGRESS-scc.txt
    {
      echo ""
      echo "## Code size (\`scc\` novel)"
      echo ""
      echo "Exit: $scc_rc -- full snapshot: \`doc/PROGRESS-scc.txt\`"
      echo "Excludes: .git ref .lake .cache"
      echo ""
      echo '```'
      head -n 22 .cache/last-scc.ascii
      echo '```'
    } >> doc/PROGRESS.md
    echo "scc novel snapshot -> doc/PROGRESS-scc.txt (rc=$scc_rc)"

# Pure Nix source hygiene (ASCII + no trailing WS) plus professional-tone
# (novel *.md banned tokens). Live impure worktree eval; no git stage needed.
hygiene:
    @nix eval --impure --raw --expr {{quote(_hygiene)}}

# Pure Nix professional tone / profanity gate on novel markdown only (v1).
# Also folded into just hygiene. Live impure worktree eval.
professional-tone:
    @nix eval --impure --raw --expr {{quote(_professional_tone)}}

# Pure Nix systems host presence (skeleton + unit-surface + SYSTEMS_LEAN_HOST +
# tree-wide banned-jargon walk under src/systems). Live impure worktree eval.
systems-host:
    @nix eval --impure --raw --expr {{quote(_systems_host)}}

# Pure Nix systems emit-wire presence (drivers, UNIT_DEEPEN, emit product stages,
# unit-surface walk, optional release surface). Live impure worktree eval.
systems-emit-wire:
    @nix eval --impure --raw --expr {{quote(_systems_emit_wire)}}

# Pure Nix Idris-side dual presence (required files + tokens + examples jargon).
# Live impure worktree eval. Thin src/idris2/check.sh is optional elaborator only.
idris-side:
    @nix eval --impure --raw --expr {{quote(_idris_side)}}

# Pure Nix Lean-side dual presence (required files + tokens + examples jargon).
# Live impure worktree eval. Thin src/lean4/check.sh is optional Lake only.
lean-side:
    @nix eval --impure --raw --expr {{quote(_lean_side)}}

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
        'Each cycle: pure Nix progress meters + scc . + just hygiene (source-hygiene + professional-tone).' \
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
