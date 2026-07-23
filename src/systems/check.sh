#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Process glue: optional Lake + compile-path + just out-freestanding-c + cc tests.
# Static mills: just systems-host / just systems-emit-wire (pure Nix). Solo run is
# incomplete without those. Behavioral tests: smoke/slake_behavioral_probe.c.
# No new EMIT_* stages. Not residual free / not PROVABLY.
# Plan: .agents/plans/plan-paydown-shell-c-surfaces.md (Wave B).
set -euo pipefail
root=$(cd "$(dirname "$0")/../.." && pwd)
cd "$root"
fail=0
here=src/systems
emit_c=src/systems/emit/slake_freestanding.c
emit_h=src/systems/emit/slake_freestanding.h
probe=src/systems/smoke/slake_behavioral_probe.c

echo "== systems process glue (static: just systems-host / systems-emit-wire) =="

elan_has_toolchain() {
  local want=$1 line base
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    base=${line%% (*}; base=${base%"${base##*[![:space:]]}"}
    [[ "$base" == "$want" ]] && return 0
  done < <(elan toolchain list 2>/dev/null || true)
  return 1
}

run_lake=0
if command -v lean >/dev/null 2>&1 && command -v lake >/dev/null 2>&1; then
  want=$(tr -d '[:space:]' < "$here/lean-toolchain")
  if command -v elan >/dev/null 2>&1 && elan_has_toolchain "$want"; then
    run_lake=1
  elif command -v elan >/dev/null 2>&1; then
    echo "skip systems Lean elaborator (toolchain $want not installed)"
  elif [[ "${SYSTEMS_LEAN_LAKE:-}" == "1" ]]; then
    echo "systems Lean elaborator: SYSTEMS_LEAN_LAKE=1 -- PATH lake build"
    run_lake=1
  else
    echo "skip systems Lean elaborator (elan not on PATH; set SYSTEMS_LEAN_LAKE=1 to force)"
  fi
else
  echo "skip systems Lean elaborator (lean and/or lake not on PATH)"
fi
if [[ "$run_lake" -eq 1 ]]; then
  echo "== lake build =="
  if ! (cd "$here" && lake build); then echo "RED: lake build failed" >&2; fail=1
  else echo "ok lake build"; fi
fi

echo "== compile-path (SLAKE_COMPILE_PATH_V0) =="
if [[ ! -f script/slake-compile-path.sh ]]; then
  echo "RED: missing script/slake-compile-path.sh" >&2; fail=1
elif ! bash script/slake-compile-path.sh; then
  echo "RED: compile-path non-zero" >&2; fail=1
else echo "ok compile-path GREEN"; fi

echo "== emit + out (SLAKE_EMIT_FREESTANDING_C_V0 via just out-freestanding-c) =="
if ! just out-freestanding-c; then
  echo "RED: just out-freestanding-c non-zero" >&2; fail=1
else echo "ok out-freestanding-c GREEN"; fi
if [[ ! -f "$emit_c" || ! -f "$emit_h" ]]; then
  echo "RED: emit product missing" >&2; fail=1
else echo "ok emit product .c/.h"; fi
if [[ ! -f out/freestanding-c/slake_freestanding.c || ! -f out/freestanding-c/slake_freestanding.h ]]; then
  echo "RED: out/freestanding-c product missing" >&2; fail=1
else echo "ok release surface"; fi

echo "== freestanding compile + behavioral tests =="
if [[ ! -f "$emit_c" || ! -f "$emit_h" ]]; then
  echo "RED: emit files missing for tests" >&2; fail=1
elif ! command -v cc >/dev/null 2>&1; then
  echo "ok compile + behavioral tests skipped (no cc)"
else
  o="${TMPDIR:-/tmp}/slake_fs_smoke.o"
  inc=$(dirname "$emit_c")
  mode=""
  if cc -c -std=c11 -ffreestanding -nostdlib -I"$inc" -o "$o" "$emit_c" 2>/dev/null; then mode=ffreestanding-nostdlib
  elif cc -c -std=c11 -I"$inc" -o "$o" "$emit_c" 2>/dev/null; then mode=hosted-fallback; fi
  rm -f "$o"
  if [[ -n "$mode" ]]; then echo "ok freestanding-first compile ($mode)"
  else echo "RED: freestanding-first compile failed" >&2; fail=1; fi
  if [[ ! -f "$probe" ]]; then
    echo "RED: missing $probe" >&2; fail=1
  else
    d="${TMPDIR:-/tmp}/slake_beh_$$"; mkdir -p "$d"
    if ! cc -std=c11 -I"$inc" -o "$d/probe" "$probe" "$emit_c" 2>/dev/null; then
      echo "RED: behavioral tests failed to link" >&2; fail=1
    else
      rc=0; "$d/probe" || rc=$?
      if [[ "$rc" -eq 0 ]]; then echo "ok behavioral tests ($probe)"
      else echo "RED: behavioral tests assert code=$rc" >&2; fail=1; fi
    fi
    rm -rf "$d"
  fi
fi

if [[ "$fail" -ne 0 ]]; then echo "systems-side check RED" >&2; exit 1; fi
echo "systems-side check GREEN (process glue; static pure Nix; not residual free)"
