#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Freestanding Systems Lean build: src/systems/ product only (not ref/, not host elab).
#
# Multi-tier honesty (see src/systems/README.md):
#   SKELETON          -- pure layout stub
#   UNIT_SURFACE      -- freestanding unit surface beyond layout
#   SLAKE_COMPILE_PATH_V0 -- structure-validation compile-path stage (not product C)
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

echo "== systems freestanding build =="
echo "workspace: src/systems/  (Slake host synthesis; min QTT (Quantitative Type Theory) mults)"
echo "policy: no runtime GC (garbage collection) on product wire; RC (reference counting) only if proven necessary"
echo "  see src/systems/README.md"

# Units: freestanding sources we will compile when Slake/systems emit exists.
# Prune package-local .lake / .git (parity with pure Nix unitWalkSkipDirs).
mapfile -t units < <(find src/systems \( -name .lake -o -name .git \) -prune -o -type f \( -name '*.lean' -o -name '*.slake' \) -print 2>/dev/null | sort || true)

if [[ ${#units[@]} -eq 0 ]]; then
  echo "systems: no freestanding units yet (scaffold only). build is a no-op success until sources land."
  exit 0
fi

# Multi-tier honesty markers:
#   SKELETON     -- pure layout stub (layout-only success if every unit is this only)
#   UNIT_SURFACE -- freestanding unit surface beyond layout (still not product C emit)
# A unit with UNIT_SURFACE counts as unit-surface even if SKELETON also appears.
missing=()
skeleton_only=()
unit_surface=()

for u in "${units[@]}"; do
  has_us=0
  has_sk=0
  if grep -q 'UNIT_SURFACE' "$u" 2>/dev/null; then
    has_us=1
  fi
  if grep -q 'SKELETON' "$u" 2>/dev/null; then
    has_sk=1
  fi
  if [[ "$has_us" -eq 0 && "$has_sk" -eq 0 ]]; then
    missing+=("$u")
  elif [[ "$has_us" -eq 1 ]]; then
    unit_surface+=("$u")
  else
    skeleton_only+=("$u")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "error: freestanding unit(s) missing honesty marker."
  echo "  every unit must carry greppable SKELETON (layout-only) or UNIT_SURFACE (unit surface):"
  for u in "${missing[@]}"; do
    echo "  missing: $u"
  done
  exit 1
fi

if [[ ${#unit_surface[@]} -gt 0 ]]; then
  echo "systems: ${#unit_surface[@]} unit-surface unit(s) (marker UNIT_SURFACE); ${#skeleton_only[@]} layout-only skeleton unit(s)."
  echo "  not freestanding emit; not product C."
  for u in "${unit_surface[@]}"; do
    echo "  unit-surface: $u"
  done
  for u in "${skeleton_only[@]}"; do
    echo "  skeleton: $u"
  done

  # Real compile-path stage (SLAKE_COMPILE_PATH_V0): structure validation, not product C.
  # Fail closed if the driver is missing or validation fails.
  driver="script/slake-compile-path.sh"
  if [[ ! -f "$driver" ]]; then
    echo "error: UNIT_SURFACE units present but compile-path driver missing: $driver" >&2
    echo "  residual priority 3 requires SLAKE_COMPILE_PATH_V0 (not silent success)." >&2
    exit 1
  fi
  if [[ -x "$driver" ]]; then
    ./"$driver"
  else
    bash "$driver"
  fi
  compile_rc=$?
  if [[ "$compile_rc" -ne 0 ]]; then
    exit "$compile_rc"
  fi
  # Product C is a separate stage: SLAKE_EMIT_FREESTANDING_C_V0 via just out-freestanding-c.
  # Build stays compile-path + unit surface only (not residual free; not product C claim).
  echo "systems: compile-path GREEN; product C is via just out-freestanding-c (SLAKE_EMIT_FREESTANDING_C_V0)."
  echo "  not freestanding residual free; not product C from this build stage"
  exit 0
fi

echo "systems: ${#skeleton_only[@]} layout-only skeleton unit(s) under src/systems/ (marker SKELETON)."
echo "  not freestanding emit; not product C; compile-path stage idle without UNIT_SURFACE."
for u in "${skeleton_only[@]}"; do
  echo "  skeleton: $u"
done
exit 0
