#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Red/green presence check for Lean-side required artifacts.
# Optional: Lake elaborator when lean+lake and pinned toolchain are installed.
set -euo pipefail
root=$(cd "$(dirname "$0")/../.." && pwd)
cd "$root"
fail=0
here=src/lean4

need=(
  src/lean4/multiplicity-map.md
  src/lean4/examples/ConsumeToken.lean
  src/lean4/examples/ErasedIndex.lean
  src/lean4/examples/UnrestrictedShare.lean
  src/lean4/examples/TRUST.md
  src/lean4/JOIN.md
  src/lean4/check.sh
  src/lean4/lakefile.toml
  src/lean4/lean-toolchain
  src/lean4/lake-manifest.json
)

echo "== lean-side required files =="
for f in "${need[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "RED missing: $f" >&2
    fail=1
  else
    echo "ok $f"
  fi
done

for alg in ConsumeToken ErasedIndex UnrestrictedShare; do
  if ! grep -q "$alg" "src/lean4/examples/${alg}.lean" 2>/dev/null; then
    echo "RED: $alg id missing from example" >&2
    fail=1
  fi
done

if ! grep -q 'MULT-1' src/lean4/multiplicity-map.md 2>/dev/null; then
  echo "RED: MULT-1 row missing from multiplicity-map" >&2
  fail=1
fi
if ! grep -q 'SystemsLean.LeanBridge.ConsumeToken' src/lean4/examples/ConsumeToken.lean 2>/dev/null; then
  echo "RED: expected LeanBridge namespace missing (ConsumeToken)" >&2
  fail=1
fi
if ! grep -q 'SystemsLean.LeanBridge.ErasedIndex' src/lean4/examples/ErasedIndex.lean 2>/dev/null; then
  echo "RED: expected LeanBridge namespace missing (ErasedIndex)" >&2
  fail=1
fi
if ! grep -q 'SystemsLean.LeanBridge.UnrestrictedShare' src/lean4/examples/UnrestrictedShare.lean 2>/dev/null; then
  echo "RED: expected LeanBridge namespace missing (UnrestrictedShare)" >&2
  fail=1
fi
if ! grep -q 'ErasedIndex' src/lean4/JOIN.md 2>/dev/null; then
  echo "RED: ErasedIndex missing from JOIN.md" >&2
  fail=1
fi
if ! grep -q 'UnrestrictedShare' src/lean4/JOIN.md 2>/dev/null; then
  echo "RED: UnrestrictedShare missing from JOIN.md" >&2
  fail=1
fi
# Fail if forbidden jargon sneaks back into examples (see AGENTS.md ban list)
if grep -qiE '\b(pole|spine)\b' src/lean4/examples/*.lean 2>/dev/null; then
  echo "RED: forbidden jargon in Lean examples (see AGENTS.md)" >&2
  fail=1
fi

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
  echo "skip lean elaborator (lean and/or lake not on PATH; presence gate still green)"
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
  echo "lean-side check RED" >&2
  exit 1
fi
echo "lean-side check GREEN"
