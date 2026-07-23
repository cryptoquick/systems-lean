#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Process glue only: optional idris2 --check when binary is on PATH.
# Static file/token presence is pure Nix -- run: just idris-side
# (nix/idris-side-presence/; also folded into just check before this script).
# Skip-if-missing honesty: absence of idris2 does not RED this script.
set -euo pipefail
root=$(cd "$(dirname "$0")/../.." && pwd)
cd "$root"
fail=0

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
  echo "skip idris2 --check (not on PATH; pure Nix idris-side presence still required via just idris-side)"
fi

if [[ "$fail" -ne 0 ]]; then
  echo "idris-side elaborator RED" >&2
  exit 1
fi
echo "idris-side elaborator GREEN (static presence: just idris-side)"
