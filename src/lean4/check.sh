#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Red/green presence check for Lean-side required artifacts.
# Optional: lean elaborator when Lake is wired (not required for green).
set -euo pipefail
root=$(cd "$(dirname "$0")/../.." && pwd)
cd "$root"
fail=0

need=(
  src/lean4/multiplicity-map.md
  src/lean4/examples/ConsumeToken.lean
  src/lean4/examples/TRUST.md
  src/lean4/JOIN.md
  src/lean4/check.sh
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

if ! grep -q 'ConsumeToken' src/lean4/examples/ConsumeToken.lean 2>/dev/null; then
  echo "RED: ConsumeToken id missing from example" >&2
  fail=1
fi
if ! grep -q 'MULT-1' src/lean4/multiplicity-map.md 2>/dev/null; then
  echo "RED: MULT-1 row missing from multiplicity-map" >&2
  fail=1
fi
if ! grep -q 'SystemsLean.LeanBridge.ConsumeToken' src/lean4/examples/ConsumeToken.lean 2>/dev/null; then
  echo "RED: expected LeanBridge namespace missing" >&2
  fail=1
fi
# Fail if forbidden jargon sneaks back into the example
if grep -qi 'pole' src/lean4/examples/ConsumeToken.lean 2>/dev/null; then
  echo "RED: forbidden jargon 'pole' in ConsumeToken.lean" >&2
  fail=1
fi

if command -v lean >/dev/null 2>&1; then
  echo "== lean present on PATH (optional elaborator not wired for this tree yet) =="
  echo "skip lean elaborator (no Lake package for src/lean4 yet)"
else
  echo "skip lean elaborator (lean not on PATH)"
fi

if [[ "$fail" -ne 0 ]]; then
  echo "lean-side check RED" >&2
  exit 1
fi
echo "lean-side check GREEN"
