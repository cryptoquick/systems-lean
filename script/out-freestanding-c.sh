#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Refresh out/freestanding-c: runtimeless freestanding C for external consumers / release.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

dest=out/freestanding-c
mkdir -p "$dest"

echo "== out freestanding-c -> $dest =="
echo "Release: runtimeless product C (no Lean managed runtime / product GC on the wire)."

if [[ ! -f "$dest/README.md" ]]; then
  echo "error: missing $dest/README.md" >&2
  exit 1
fi

generated=$(find src/systems -type f \( -name '*.c' -o -name '*.h' \) 2>/dev/null | head -n 1 || true)
if [[ -z "${generated}" ]]; then
  echo "out-freestanding-c: no generated C yet; $dest remains documentation + empty product surface."
  exit 0
fi

echo "error: C artifacts found under src/systems/ but copy pipeline not implemented."
exit 1
