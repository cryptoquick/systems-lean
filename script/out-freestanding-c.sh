#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Refresh out/freestanding-c: runtimeless freestanding C for external consumers / release.
#
# Invokes SLAKE_EMIT_FREESTANDING_C_V0 emit driver, then copies product .c/.h from
# src/systems/emit/ into out/freestanding-c/. Still not residual free; not PROVABLY.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

dest=out/freestanding-c
emit_driver="script/slake-emit-freestanding-c.sh"
emit_dir="src/systems/emit"

mkdir -p "$dest"

echo "== out freestanding-c -> $dest =="
echo "Release: runtimeless product C (no Lean managed runtime / product GC on the wire)."
echo "  not residual free; not PROVABLY"

if [[ ! -f "$dest/README.md" ]]; then
  echo "error: missing $dest/README.md" >&2
  exit 1
fi

if [[ ! -f "$emit_driver" ]]; then
  echo "error: emit driver missing: $emit_driver" >&2
  echo "  residual priority 4 requires SLAKE_EMIT_FREESTANDING_C_V0 (fail closed)." >&2
  exit 1
fi
if [[ -x "$emit_driver" ]]; then
  ./"$emit_driver"
else
  bash "$emit_driver"
fi

mapfile -t artifacts < <(find "$emit_dir" -type f \( -name '*.c' -o -name '*.h' \) 2>/dev/null | sort || true)
if [[ ${#artifacts[@]} -eq 0 ]]; then
  echo "error: after emit, no .c/.h under $emit_dir to copy into $dest" >&2
  exit 1
fi

# Clean install: drop stale product .c/.h so concurrent/old stage leftovers do not
# mix release surfaces. Always keep README.md (release policy doc).
for stale in "$dest"/*.c "$dest"/*.h; do
  if [[ -f "$stale" ]]; then
    rm -f "$stale"
    echo "  remove stale: $stale"
  fi
done

copied=0
for src in "${artifacts[@]}"; do
  base=$(basename "$src")
  cp -f "$src" "$dest/$base"
  echo "  copy: $src -> $dest/$base"
  copied=$((copied + 1))
done

echo "out-freestanding-c: copied ${copied} product file(s) into $dest"
echo "  not residual free; not PROVABLY; no product GC; not Lean managed runtime"
echo "  stage: SLAKE_EMIT_FREESTANDING_C_V0 + UNIT_DEEPEN_V1 (first unit translation; still not residual free)"
exit 0
