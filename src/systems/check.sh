#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Residual shell gate for systems / Slake: optional Lake elaborator + driver
# runs + freestanding C compile smoke + hosted behavioral probe.
#
# Behavioral probe source (smoke debt, not product emit residual):
#   src/systems/smoke/slake_behavioral_probe.c
# Pure Nix systems-emit-wire requires that path (fail closed if missing).
#
# Static presence mills are pure Nix (do not re-grow greps here):
#   nix/systems-host-presence/  -- Mult..ProductPath host + skeleton + unit-surface
#                                 tokens + tree-wide banned-jargon walk
#   nix/systems-emit-wire/      -- compile/emit drivers, UNIT_DEEPEN, emit stages,
#                                 unit-surface walk, optional release surface,
#                                 behavioral probe path presence
#   flake checks: systems-host-presence, systems-emit-wire
#   just systems-host && just systems-emit-wire
# Full suite (just check) runs pure Nix before this script. Solo runs of this
# script do NOT verify host tokens, emit-wire greps, or tree-wide jargon.
#
# C emit ladder is frozen product wire -- do not grow new EMIT_* residual here.
# Does not claim freestanding residual free or PROVABLY.
set -euo pipefail
root=$(cd "$(dirname "$0")/../.." && pwd)
cd "$root"
fail=0
here=src/systems

echo "== systems pure Nix gates (not shell) =="
echo "WARN: this script alone does NOT verify Mult..ProductPath host tokens,"
echo "      emit-wire stage greps, UNIT_DEEPEN_V1, unit-surface walk,"
echo "      or tree-wide banned-jargon ban."
echo "      incomplete without: just systems-host && just systems-emit-wire"
echo "      (or just check, which runs both pure gates first)"
echo "ok deferred: host presence + jargon + emit-wire owned by pure Nix"

# Optional elaborator: only when lean+lake present AND pin is already installed
# (avoid network toolchain downloads breaking default just check). Mirror src/lean4.
elan_has_toolchain() {
  local want=$1
  local line base
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    base=${line%% (*}
    base=${base%"${base##*[![:space:]]}"}
    if [[ "$base" == "$want" ]]; then
      return 0
    fi
  done < <(elan toolchain list 2>/dev/null || true)
  return 1
}

run_lake=0
if command -v lean >/dev/null 2>&1 && command -v lake >/dev/null 2>&1; then
  want=$(tr -d '[:space:]' < "$here/lean-toolchain")
  if command -v elan >/dev/null 2>&1; then
    if elan_has_toolchain "$want"; then
      run_lake=1
    else
      echo "skip systems Lean elaborator (toolchain $want not installed; avoid network download)"
    fi
  elif [[ "${SYSTEMS_LEAN_LAKE:-}" == "1" ]]; then
    echo "systems Lean elaborator: no elan; SYSTEMS_LEAN_LAKE=1 set -- running PATH lake build"
    run_lake=1
  else
    echo "skip systems Lean elaborator (elan not on PATH; set SYSTEMS_LEAN_LAKE=1 to force PATH lake build)"
  fi
else
  echo "skip systems Lean elaborator (lean and/or lake not on PATH; presence gate still green)"
fi

if [[ "$run_lake" -eq 1 ]]; then
  echo "== lake build (classic Lean elaborator for SystemsLean Mult..ProductPath) =="
  if ! (cd "$here" && lake build); then
    echo "RED: lake build failed for src/systems" >&2
    fail=1
  else
    echo "ok lake build"
  fi
fi

# Dynamic unit-surface walk lives in pure Nix (systems-emit-wire). Drivers always
# run: residual requires UNIT_SURFACE units and emit product (fail closed).
echo "== systems compile-path stage (SLAKE_COMPILE_PATH_V0 driver run) =="
driver="script/slake-compile-path.sh"
if [[ ! -f "$driver" ]]; then
  echo "RED: compile-path driver missing: $driver" >&2
  fail=1
else
  if [[ -x "$driver" ]]; then
    if ! ./"$driver"; then
      echo "RED: compile-path driver exited non-zero" >&2
      fail=1
    else
      echo "ok compile-path driver ran GREEN"
    fi
  else
    if ! bash "$driver"; then
      echo "RED: compile-path driver exited non-zero" >&2
      fail=1
    else
      echo "ok compile-path driver ran GREEN"
    fi
  fi
fi

echo "== systems emit path stage (SLAKE_EMIT_FREESTANDING_C_V0 driver run) =="
emit_driver="script/slake-emit-freestanding-c.sh"
out_sh="script/out-freestanding-c.sh"
emit_dir="src/systems/emit"
emit_c_path="src/systems/emit/slake_freestanding.c"
emit_h_path="src/systems/emit/slake_freestanding.h"

if [[ ! -f "$emit_driver" ]]; then
  echo "RED: emit driver missing: $emit_driver" >&2
  fail=1
else
  if [[ -x "$emit_driver" ]]; then
    if ! ./"$emit_driver"; then
      echo "RED: emit driver exited non-zero" >&2
      fail=1
    else
      echo "ok emit driver ran GREEN"
    fi
  else
    if ! bash "$emit_driver"; then
      echo "RED: emit driver exited non-zero" >&2
      fail=1
    else
      echo "ok emit driver ran GREEN"
    fi
  fi
fi

if [[ ! -f "$out_sh" ]]; then
  echo "RED: missing $out_sh" >&2
  fail=1
else
  if [[ -x "$out_sh" ]]; then
    if ! ./"$out_sh"; then
      echo "RED: out-freestanding-c exited non-zero" >&2
      fail=1
    else
      echo "ok out-freestanding-c ran GREEN"
    fi
  else
    if ! bash "$out_sh"; then
      echo "RED: out-freestanding-c exited non-zero" >&2
      fail=1
    else
      echo "ok out-freestanding-c ran GREEN"
    fi
  fi
fi

if [[ ! -f "$emit_c_path" || ! -f "$emit_h_path" ]]; then
  echo "RED: emit product missing under $emit_dir after emit" >&2
  fail=1
else
  echo "ok emit product .c/.h: $emit_c_path $emit_h_path"
fi

out_c="out/freestanding-c/slake_freestanding.c"
out_h="out/freestanding-c/slake_freestanding.h"
if [[ ! -f "$out_c" || ! -f "$out_h" ]]; then
  echo "RED: out/freestanding-c missing product .c/.h after emit+copy" >&2
  fail=1
else
  echo "ok release surface .c/.h under out/freestanding-c"
fi

# Compile + behavioral smoke only. Stage token greps are pure Nix systems-emit-wire.
echo "== systems emit compile + behavioral smoke (dynamic; tokens pure Nix) =="
if [[ ! -f "$emit_h_path" || ! -f "$emit_c_path" ]]; then
  echo "RED: emit product files missing for smoke" >&2
  fail=1
elif command -v cc >/dev/null 2>&1; then
  smoke_o="${TMPDIR:-/tmp}/slake_fs_smoke.o"
  emit_inc="$(dirname "$emit_c_path")"
  smoke_mode=""
  if cc -c -std=c11 -ffreestanding -nostdlib -I"$emit_inc" -o "$smoke_o" "$emit_c_path" 2>/dev/null; then
    smoke_mode="ffreestanding-nostdlib"
  elif cc -c -std=c11 -I"$emit_inc" -o "$smoke_o" "$emit_c_path" 2>/dev/null; then
    smoke_mode="hosted-fallback"
  fi
  rm -f "$smoke_o"
  if [[ -n "$smoke_mode" ]]; then
    echo "ok freestanding-first compile smoke ($smoke_mode): $emit_c_path"
  else
    echo "RED: freestanding-first compile smoke failed for $emit_c_path" >&2
    fail=1
  fi

  # Behavioral smoke (hosted link): contracts are freestanding-API semantics.
  # Probe source is durable smoke debt (not product emit residual).
  probe_src="src/systems/smoke/slake_behavioral_probe.c"
  if [[ ! -f "$probe_src" ]]; then
    echo "RED: behavioral probe source missing: $probe_src" >&2
    fail=1
  else
    smoke_dir="${TMPDIR:-/tmp}/slake_unit_tx_beh_$$"
    mkdir -p "$smoke_dir"
    if ! cc -std=c11 -I"$emit_inc" -o "$smoke_dir/probe" "$probe_src" "$emit_c_path" 2>/dev/null; then
      echo "RED: behavioral smoke failed to compile/link $probe_src against $emit_c_path" >&2
      fail=1
    else
      beh_rc=0
      "$smoke_dir/probe" || beh_rc=$?
      if [[ "$beh_rc" -eq 0 ]]; then
        echo "ok behavioral smoke (UNIT_TRANSLATION_V0..EMIT_BODY_V0 contracts; hosted link; $probe_src)"
      else
        echo "RED: behavioral smoke failed assert code=$beh_rc (see $probe_src)" >&2
        fail=1
      fi
    fi
    rm -rf "$smoke_dir"
  fi

else
  echo "ok freestanding-first + behavioral smoke skipped (no cc)"
fi

if [[ "$fail" -ne 0 ]]; then
  echo "systems-side check RED" >&2
  exit 1
fi

echo "systems-side check GREEN (driver runs + emit smoke; host/jargon/emit-wire pure Nix; not freestanding residual free)"
