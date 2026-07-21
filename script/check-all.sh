#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Single entry for local `just check`, pre-commit, and CI. Add new gates here.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

staged=0
if [[ "${1:-}" == "--staged" ]]; then
  staged=1
fi

echo "== source-hygiene =="
if [[ "$staged" -eq 1 ]]; then
  ./script/check-source-hygiene.sh --staged
else
  # --walk: include not-yet-tracked novel files (human owns git staging)
  ./script/check-source-hygiene.sh --walk
fi

echo "== nix flake check =="
if command -v nix >/dev/null 2>&1; then
  nix flake check
else
  echo "error: nix not on PATH (required for full check suite)" >&2
  exit 1
fi

echo "== idris-side (if present) =="
if [[ -x ./src/idris2/check.sh ]]; then
  ./src/idris2/check.sh
elif [[ -f ./src/idris2/check.sh ]]; then
  bash ./src/idris2/check.sh
fi

echo "== lean-side (if present) =="
if [[ -x ./src/lean4/check.sh ]]; then
  ./src/lean4/check.sh
elif [[ -f ./src/lean4/check.sh ]]; then
  bash ./src/lean4/check.sh
fi

echo "check-all OK"
