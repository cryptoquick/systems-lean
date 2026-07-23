# Paydown Wave C summary -- Lean-owned freestanding emit

Kind: analysis / implement join. Not residual-free claim. Not PROVABLY.

ASCII only.

## Goal

Delete `script/slake-emit-freestanding-c.sh` (~2071 lines). Product wire
`slake_freestanding.{h,c}` produced by Lean under `src/systems/`.

## Approach (contract-stable)

1. Extract pre-embed header/source templates from frozen bash heredocs into
   Lean-owned durable templates:
   - `src/systems/emit/template_slake_freestanding.h.in`
   - `src/systems/emit/template_slake_freestanding.c.in`
2. Placeholders:
   - `__HOST_EMIT_MULT_HEADER__` / `__HOST_EMIT_MULT_BODY__` (whole-line Mult embed)
   - `__SSOT_*__` for EMIT_BODY put_str dialect strings from body SSOT
3. Lean IO writer `SystemsLean/FreestandingEmit.lean` + lake exe
   `slake-emit-freestanding-c`:
   - Fail-closed load of `host_emit_body_fragment.ssot.txt` and
     `host_emit_mult.ssot.txt`
   - EMPTY_FRAGMENT recompose + Mult name/block honesty
   - Substitute templates; write only under `src/systems/emit/`
   - Never write `out/freestanding-c/`
4. `just out-freestanding-c`: compile-path structure bar, then
   `lake build` + `lake exe slake-emit-freestanding-c`, then copy
   product `.c`/`.h` to release.
5. pure Nix emit-wire requires Lean module + templates; stops requiring bash.
6. Bash file deleted after green probe path.

## Files

| Path | Role | ~Lines |
|------|------|--------|
| `src/systems/SystemsLean/FreestandingEmit.lean` | Lean emit writer (IO) | ~322 |
| `src/systems/emit/template_slake_freestanding.h.in` | Header template | ~573 |
| `src/systems/emit/template_slake_freestanding.c.in` | Source template | ~1031 |
| `src/systems/lakefile.toml` | lake exe `slake-emit-freestanding-c` | + |
| `justfile` | out-freestanding-c -> Lean | edit |
| `nix/systems-emit-wire/emit-product.nix` | require Lean + templates | edit |
| `nix/progress/milestones.nix` | emit milestone paths | edit |
| `nix/systems-host-presence/specs.nix` | FreestandingEmit path | edit |
| `script/slake-emit-freestanding-c.sh` | **deleted** | was ~2071 |

## Honesty

- Still **not residual free**. Still **not PROVABLY**.
- No new EMIT_* residual C stage.
- Bulk product wire remains frozen templates; Mult + body put_str stay SSOT.
- Product emit requires host Lean pin (elan/lake); fail closed if missing.

## Residual after Wave C

- Wave D: release layout / subtree publish polish; optional untrack dogfood C.
- Wave E: behavioral probe honesty (do not grow; shrink only with Lean evidence).
- Remaining shell: `script/slake-compile-path.sh` (~150) + thin process glue.

## Gates (ran at implement)

```text
just out-freestanding-c
just systems-emit-wire
just systems-host
just hygiene
bash src/systems/check.sh
test ! -f script/slake-emit-freestanding-c.sh
```
