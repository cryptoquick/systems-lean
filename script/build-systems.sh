#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Freestanding Systems Lean build: src/systems/ product only (not ref/, not host elab).
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

echo "== systems freestanding build =="
echo "workspace: src/systems/  (Slake host synthesis; min QTT (Quantitative Type Theory) mults)"
echo "policy: no runtime GC (garbage collection) on product wire; RC (reference counting) only if proven necessary"
echo "  see src/systems/README.md"

# Units: freestanding sources we will compile when Slake/systems emit exists.
mapfile -t units < <(find src/systems -type f \( -name '*.lean' -o -name '*.slake' \) 2>/dev/null | sort || true)

if [[ ${#units[@]} -eq 0 ]]; then
  echo "systems: no freestanding units yet (scaffold only). build is a no-op success until sources land."
  exit 0
fi

echo "error: freestanding compiler/driver not wired yet; ${#units[@]} unit(s) present but unbuildable."
echo "  first unit: ${units[0]}"
exit 1
