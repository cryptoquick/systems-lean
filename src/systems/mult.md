# Multiplicities -- min 0 / 1 / omega (unit surface notes)

**Module role:** Quantitative Type Theory (QTT) grades on freestanding Slake.
**Status:** SYSTEMS_LEAN_HOST partial -- `SystemsLean/Mult.lean` (closed Mult
inductive MULT-0 / MULT-1 / MULT-OMEGA; typed `isValid` total-true by match;
FAIL-CLOSED-UNKNOWN-GRADE via `ofNat?` / `isValidTag`; `multIsValid` alias) +
UNIT_DEEPEN_V1 contract surface on Mult.slake (historical emit map) +
HOST-EMIT-MULT (`EmitMult.lean` / `emit/host_emit_mult.ssot.txt`) +
HOST-PARITY-MULT (`ParityMult.lean` + product Mult probe).
Not freestanding residual free. Not freestanding emit body in this unit file.
**IR sketch:** `doc/shared-ir-sketch.md` (Multiplicities row).
**Greppable row ids:** MULT-0, MULT-1, MULT-OMEGA, FAIL-CLOSED-UNKNOWN-GRADE,
UNIT_DEEPEN_V1, SYSTEMS_LEAN_HOST, HOST-EMIT-MULT, HOST-PARITY-MULT,
HOST-SELF-APPLY, SELF-HOST-SELF-APPLY, HOST-LLVM-HOLD, SELF-HOST-LLVM-HOLD
**PARTIAL inventory:** `host-partial-inventory.md` (CLOSABLE-MISS-COUNT-0)

## Lean host (SYSTEMS_LEAN_HOST)

| Host surface | Role |
|--------------|------|
| `SystemsLean.Mult.Mult` | Closed inductive mult0 / mult1 / multOmega |
| `name` | Greppable MULT-0 / MULT-1 / MULT-OMEGA strings |
| `isValid` / `multIsValid` | Typed Mult always true (constructor match) |
| `ofNat?` / `isValidTag` | FAIL-CLOSED-UNKNOWN-GRADE on raw tags (0/1/2 only) |

## Grades (product surface)

| Id | Meaning on the shared core |
|----|----------------------------|
| MULT-0 | Erased / compile-time-only -- no product runtime presence when checks succeed |
| MULT-1 | Use-once / linear -- exact-once on product-relevant resources |
| MULT-OMEGA | Unrestricted / ordinary data -- copy, drop, reuse freely under ordinary rules |

Only these three grades on freestanding Slake. Do not grow a multiplicity zoo.

## Fail closed

**FAIL-CLOSED-UNKNOWN-GRADE:** any grade outside MULT-0 / MULT-1 / MULT-OMEGA is
rejected. Emit and later checkers must not silently coerce unknown grades into
omega or zero. Product C maps known grades via `enum slake_mult` only
(`SLAKE_MULT_0`, `SLAKE_MULT_1`, `SLAKE_MULT_OMEGA`) and
`slake_mult_is_valid` / `slake_mult_is_known`.

Side maps (read-only for systems): `src/idris2/multiplicity-map.md`,
`src/lean4/multiplicity-map.md`.

TYPED_IR_V0 ir_node pairs kinds with these grades (VALUE/OMEGA, LINEAR/1, ERASED/0).

## Emit mapping (UNIT_TRANSLATION_V0 / UNIT_DEEPEN_V1 + HOST-EMIT-MULT)

V0 freestanding C (`SLAKE_EMIT_FREESTANDING_C_V0`) exposes grade tags and Mult
API (`slake_mult_is_valid` / `slake_mult_is_known` / `slake_mult_name`). That is
a first unit translation of this surface, not a full mult checker and not
residual free.

**HOST-EMIT-MULT (SH2):** Mult product C text SSoT is Lean `SystemsLean.EmitMult`
(`multHeaderFragment` / `multBodyFragment`) + durable
`emit/host_emit_mult.ssot.txt`. Bash `script/slake-emit-freestanding-c.sh` is
NON-SSOT for Mult: reads/embeds MULT_C_HEADER / MULT_C_BODY. No `EMIT_MULT_V0`
residual C stage ladder.

**HOST-SELF-APPLY (SH5 partial):** Mult closed loop composes into `SelfApply.lean`
`selfApplyReady` / `kernelRebuildsKernel` with Linear kernel (host structural
only -- not freestanding product self-host complete; SH6 held documented).

**HOST-LLVM-HOLD (SH6 held documented):** Mult closed loop remains under hold gate
in `LlvmHold.lean` (`llvmHoldReady` true; `llvmUnlocked` false) -- not residual-
open llvm mill; not PROVABLY.

**HOST-PARITY-MULT (SH3):** Mult closed-loop parity -- host `ParityMult.lean`
(`multParityReady` / `gradeParityOk`) + product Mult behavioral checks in
`smoke/slake_behavioral_probe.c` (is_valid / is_known / name / enum tags 0/1/2
+ fail-closed unknown). Mult grades only -- Linear kernel is KernelLinear (SH4).

## Non-claims

- No full mult checker body here
- Not freestanding residual free
- Not freestanding self-host complete / not PROVABLY
- Labels may differ on sides (EDGE-NAME: omega vs unrestricted / RigW)
