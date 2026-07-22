#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Red/green presence check for Idris-side required artifacts.
# Optional: idris2 --check when available (not required for green if missing).
set -euo pipefail
root=$(cd "$(dirname "$0")/../.." && pwd)
cd "$root"
fail=0

need=(
  src/idris2/multiplicity-map.md
  src/idris2/examples/ConsumeToken.idr
  src/idris2/examples/ErasedIndex.idr
  src/idris2/examples/UnrestrictedShare.idr
  src/idris2/examples/TRUST.md
  src/idris2/JOIN.md
  src/idris2/check.sh
)

echo "== idris-side required files =="
for f in "${need[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "RED missing: $f" >&2
    fail=1
  else
    echo "ok $f"
  fi
done

# Grep join algorithm ids in the examples
for alg in ConsumeToken ErasedIndex UnrestrictedShare; do
  if ! grep -q "$alg" "src/idris2/examples/${alg}.idr" 2>/dev/null; then
    echo "RED: $alg id missing from example" >&2
    fail=1
  fi
done

if ! grep -q 'MULT-1' src/idris2/multiplicity-map.md 2>/dev/null; then
  echo "RED: MULT-1 row missing from multiplicity-map" >&2
  fail=1
fi
if ! grep -q 'MULT-0' src/idris2/multiplicity-map.md 2>/dev/null; then
  echo "RED: MULT-0 row missing from multiplicity-map" >&2
  fail=1
fi
if ! grep -q 'MULT-OMEGA' src/idris2/multiplicity-map.md 2>/dev/null; then
  echo "RED: MULT-OMEGA row missing from multiplicity-map" >&2
  fail=1
fi
if ! grep -q 'ERASE-PROP' src/idris2/multiplicity-map.md 2>/dev/null; then
  echo "RED: ERASE-PROP join alias missing from multiplicity-map" >&2
  fail=1
fi
if ! grep -q 'EDGE-PROP' src/idris2/multiplicity-map.md 2>/dev/null; then
  echo "RED: EDGE-PROP missing from multiplicity-map" >&2
  fail=1
fi
if ! grep -q 'ErasedIndex' src/idris2/JOIN.md 2>/dev/null; then
  echo "RED: ErasedIndex missing from JOIN.md" >&2
  fail=1
fi
if ! grep -q 'UnrestrictedShare' src/idris2/JOIN.md 2>/dev/null; then
  echo "RED: UnrestrictedShare missing from JOIN.md" >&2
  fail=1
fi
# Banned jargon in novel Idris source modules (not check.sh self-text)
if grep -qiE '\b(spine|pole)\b' src/idris2/examples/*.idr 2>/dev/null; then
  echo "RED: forbidden jargon under src/idris2/examples/*.idr (see AGENTS.md)" >&2
  fail=1
fi

if command -v idris2 >/dev/null 2>&1; then
  echo "== idris2 --check (optional when binary present) =="
  for f in ConsumeToken.idr ErasedIndex.idr UnrestrictedShare.idr; do
    if ! (cd src/idris2/examples && idris2 --check "$f"); then
      echo "RED: idris2 --check failed on $f" >&2
      fail=1
    else
      echo "ok idris2 --check $f"
    fi
  done
else
  echo "skip idris2 --check (not on PATH; presence gate still green)"
fi

if [[ "$fail" -ne 0 ]]; then
  echo "idris-side check RED" >&2
  exit 1
fi
echo "idris-side check GREEN"
