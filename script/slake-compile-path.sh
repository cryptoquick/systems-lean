#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# SLAKE_COMPILE_PATH_V0 -- real structure-validation stage for UNIT_SURFACE units.
#
# This is an honest compile-path step for just build. It is:
#   - NOT freestanding product C emit
#   - NOT residual free / freestanding residual free
#   - NOT a write into out/freestanding-c/ (never; release surface is separate)
#
# Stage id (greppable in build/check output and residual): SLAKE_COMPILE_PATH_V0
# Host deepen (Lean, not this shell): SLAKE_COMPILE_PATH_V1 / HOST-COMPILE-PATH
#   lives in src/systems/SystemsLean/CompilePath.lean (behavioral host readiness;
#   not more structure greps). V0 structure stage remains the driver contract.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

STAGE_ID="SLAKE_COMPILE_PATH_V0"
HOST_STAGE_ID="SLAKE_COMPILE_PATH_V1"
CACHE_DIR=".cache/slake-compile-path"
MANIFEST="${CACHE_DIR}/manifest.txt"

echo "== ${STAGE_ID}: freestanding compile-path structure validation =="
echo "  not freestanding emit; not product C; not residual free"
echo "  never writes out/freestanding-c/ (release surface is separate)"
echo "  host deepen: ${HOST_STAGE_ID} / HOST-COMPILE-PATH (SystemsLean/CompilePath.lean)"

# Freestanding unit discovery (parity with pure Nix unitWalkSkipDirs).
# just build invokes this driver; pure Nix systems-emit-wire walks the same tree.

mapfile -t units < <(find src/systems \( -name .lake -o -name .git \) -prune -o -type f \( -name '*.lean' -o -name '*.slake' \) -print 2>/dev/null | sort || true)

if [[ ${#units[@]} -eq 0 ]]; then
  echo "${STAGE_ID}: no freestanding units; nothing to validate (scaffold only)."
  exit 0
fi

fail=0
skeleton_only=()
unit_surface=()
missing=()

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
  echo "RED ${STAGE_ID}: unit(s) missing SKELETON or UNIT_SURFACE honesty marker:" >&2
  for u in "${missing[@]}"; do
    echo "  missing: $u" >&2
  done
  fail=1
fi

# No UNIT_SURFACE units: layout-only path; compile-path stage is a no-op success.
if [[ ${#unit_surface[@]} -eq 0 ]]; then
  if [[ "$fail" -ne 0 ]]; then
    echo "RED ${STAGE_ID}: structure validation failed" >&2
    exit 1
  fi
  echo "${STAGE_ID}: ${#skeleton_only[@]} skeleton-only unit(s); no UNIT_SURFACE to validate."
  echo "  not freestanding emit; not product C"
  exit 0
fi

echo "${STAGE_ID}: validating ${#unit_surface[@]} UNIT_SURFACE unit(s) (structure bar)..."

validated=()
for u in "${unit_surface[@]}"; do
  unit_fail=0

  # Thin content bar (structure stage only; static mills are pure Nix).
  # .lean host modules use namespace; .slake units use module.
  if ! grep -qE 'module |namespace ' "$u" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $u missing module/namespace name" >&2
    unit_fail=1
  fi
  if ! grep -q 'Not freestanding emit' "$u" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $u missing 'Not freestanding emit'" >&2
    unit_fail=1
  fi
  if ! grep -qE 'MULT-0|MULT-1|MULT-OMEGA|JOIN-ALG|ConsumeToken|EDGE-PROP|ERASE-PROP|RUNTIME-FS|EDGE-RUNTIME|linear resource|erasure rule|extract boundary' "$u" 2>/dev/null; then
    echo "RED ${STAGE_ID}: $u missing IR contract id" >&2
    unit_fail=1
  fi

  # Mult module: min freestanding grades only (no multiplicity zoo).
  base=$(basename "$u")
  if [[ "$base" == Mult.slake || "$base" == Mult.lean ]]; then
    for g in MULT-0 MULT-1 MULT-OMEGA; do
      if ! grep -q "$g" "$u" 2>/dev/null; then
        echo "RED ${STAGE_ID}: $u Mult surface missing $g" >&2
        unit_fail=1
      fi
    done
  fi

  # Units that claim COMPILE_PATH readiness must pass the same structure bar.
  if grep -q 'COMPILE_PATH' "$u" 2>/dev/null && [[ "$unit_fail" -ne 0 ]]; then
    echo "RED ${STAGE_ID}: $u claims COMPILE_PATH but failed structure validation" >&2
  fi

  if [[ "$unit_fail" -ne 0 ]]; then
    fail=1
  else
    validated+=("$u")
    echo "  ok compile-path-validated: $u"
  fi
done

if [[ "$fail" -ne 0 ]]; then
  echo "RED ${STAGE_ID}: structure validation failed (fail closed; not product C)" >&2
  exit 1
fi

# Greppable compile-path artifact (not product C; under .cache so hygiene skips it).
mkdir -p "$CACHE_DIR"
{
  echo "# ${STAGE_ID} manifest -- validated UNIT_SURFACE units"
  echo "# not freestanding emit; not product C; not residual free"
  echo "# never a substitute for out/freestanding-c product C"
  echo "stage=${STAGE_ID}"
  echo "unit_surface_count=${#unit_surface[@]}"
  echo "validated_count=${#validated[@]}"
  echo "skeleton_only_count=${#skeleton_only[@]}"
  for u in "${validated[@]}"; do
    echo "validated:$u"
  done
} >"$MANIFEST"

echo "${STAGE_ID}: GREEN structure validation for ${#validated[@]} unit(s)"
echo "  artifact: ${MANIFEST}"
echo "  host deepen stage: ${HOST_STAGE_ID} (HOST-COMPILE-PATH; Lean host, not this shell)"
echo "  not freestanding emit; not product C; not residual free"
echo "  product C is separate: SLAKE_EMIT_FREESTANDING_C_V0 / just out-freestanding-c"
exit 0
