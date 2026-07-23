#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# SLAKE_COMPILE_PATH_V0 -- process glue stamp for just build / out-freestanding-c.
#
# Static UNIT_SURFACE / SKELETON / module / honesty greps live in pure Nix
# (just systems-emit-wire unit walk + just systems-host). This shell only:
#   - names the stage (greppable in build/check output)
#   - writes a thin cache stamp (not product C)
#
# This is:
#   - NOT freestanding product C emit
#   - NOT residual free / freestanding residual free
#   - NOT a write into out/freestanding-c/ (never; release surface is separate)
#   - NOT a static content mill (no UNIT_SURFACE greps here)
#
# Stage id (greppable): SLAKE_COMPILE_PATH_V0
# Host deepen (Lean, not this shell): SLAKE_COMPILE_PATH_V1 / HOST-COMPILE-PATH
#   lives in src/systems/SystemsLean/CompilePath.lean.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

STAGE_ID="SLAKE_COMPILE_PATH_V0"
HOST_STAGE_ID="SLAKE_COMPILE_PATH_V1"
CACHE_DIR=".cache/slake-compile-path"
MANIFEST="${CACHE_DIR}/manifest.txt"

echo "== ${STAGE_ID}: freestanding compile-path process glue (stamp only) =="
echo "  static presence: just systems-emit-wire (unit walk) + just systems-host"
echo "  not freestanding emit; not product C; not residual free"
echo "  never writes out/freestanding-c/ (release surface is separate)"
echo "  host deepen: ${HOST_STAGE_ID} / HOST-COMPILE-PATH (SystemsLean/CompilePath.lean)"

# Greppable compile-path artifact (not product C; under .cache so hygiene skips it).
mkdir -p "$CACHE_DIR"
{
  echo "# ${STAGE_ID} stamp -- process glue only; static mills pure Nix"
  echo "# not freestanding emit; not product C; not residual free"
  echo "# never a substitute for out/freestanding-c product C"
  echo "# unit walk / UNIT_SURFACE: just systems-emit-wire"
  echo "stage=${STAGE_ID}"
  echo "host_stage=${HOST_STAGE_ID}"
  echo "role=process-glue-stamp"
} >"$MANIFEST"

echo "${STAGE_ID}: GREEN process-glue stamp"
echo "  artifact: ${MANIFEST}"
echo "  host deepen stage: ${HOST_STAGE_ID} (HOST-COMPILE-PATH; Lean host, not this shell)"
echo "  not freestanding emit; not product C; not residual free"
echo "  product C is separate: SLAKE_EMIT_FREESTANDING_C_V0 / just out-freestanding-c"
exit 0
