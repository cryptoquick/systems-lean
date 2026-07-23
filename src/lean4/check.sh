#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Process glue only: optional Lake elaborator when lean+lake and pin are ready.
# Static file/token presence is pure Nix -- run: just lean-side
# (nix/lean-side-presence/; also folded into just check before this script).
# Skip-if-missing honesty: missing toolchain does not RED this script.
set -euo pipefail
root=$(cd "$(dirname "$0")/../.." && pwd)
cd "$root"
fail=0
here=src/lean4

# Return 0 if elan reports the wanted toolchain as installed.
# Normalizes list lines so suffixes like " (default)" do not break the match.
elan_has_toolchain() {
  local want=$1
  local line base
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    # Strip trailing parenthetical status (default, override, resolved, ...).
    base=${line%% (*}
    # Trim trailing whitespace without external tools.
    base=${base%"${base##*[![:space:]]}"}
    if [[ "$base" == "$want" ]]; then
      return 0
    fi
  done < <(elan toolchain list 2>/dev/null || true)
  return 1
}

# Optional elaborator: only when lean+lake present AND pin is already installed
# (avoid network toolchain downloads breaking default just check).
run_lake=0
if command -v lean >/dev/null 2>&1 && command -v lake >/dev/null 2>&1; then
  want=$(tr -d '[:space:]' < "$here/lean-toolchain")
  if command -v elan >/dev/null 2>&1; then
    if elan_has_toolchain "$want"; then
      run_lake=1
    else
      echo "skip lean elaborator (toolchain $want not installed; avoid network download)"
    fi
  elif [[ "${SYSTEMS_LEAN_LAKE:-}" == "1" ]]; then
    # No elan: only on explicit opt-in so a mismatched PATH lean cannot RED just check.
    echo "lean elaborator: no elan; SYSTEMS_LEAN_LAKE=1 set -- running PATH lake build"
    run_lake=1
  else
    echo "skip lean elaborator (elan not on PATH; set SYSTEMS_LEAN_LAKE=1 to force PATH lake build)"
  fi
else
  echo "skip lean elaborator (lean and/or lake not on PATH; pure Nix lean-side presence still required via just lean-side)"
fi

if [[ "$run_lake" -eq 1 ]]; then
  echo "== lake build (classic Lean elaborator for examples) =="
  if ! (cd "$here" && lake build); then
    echo "RED: lake build failed for src/lean4" >&2
    fail=1
  else
    echo "ok lake build"
  fi
fi

if [[ "$fail" -ne 0 ]]; then
  echo "lean-side elaborator RED" >&2
  exit 1
fi
echo "lean-side elaborator GREEN (static presence: just lean-side)"
