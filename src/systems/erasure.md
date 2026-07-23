# Erasure -- compile-time-only values (unit surface notes)

**Module role:** honest erasure so mult-0 values leave no runtime presence when checks succeed.
**Status:** SYSTEMS_LEAN_HOST partial -- `SystemsLean/Erasure.lean` (Erased marker, mark /
isRuntimeAbsent fail-closed, markForGrade? MULT-0-only, ERASE-RULE-MULT-0 /
ERASE-NO-RUNTIME / EDGE-PROP / ERASE-PROP; ERASURE-THEOREM / HOST-ERASURE-THEOREM
real theorems on mark fail-closed / ERASE-RULE-MULT-0 grade gate +
checkFailClosed_eq / markForGrade?_some_implies_isErasureGrade /
markForGrade?_some_is_mark / markForGrade?_mult0_isRuntimeAbsent /
isRuntimeAbsent_eq_marked composition honesty;
SpecProof.proofCompleteClaimed stays false);
UNIT_DEEPEN_V1 contract surface on Erasure.slake remains for historical emit map.
Not freestanding residual free. Not freestanding emit body in this unit file.
**IR sketch:** `doc/shared-ir-sketch.md` (Erasure row).
**Anchors:** MULT-0; ERASE-RULE-MULT-0; ERASE-NO-RUNTIME; EDGE-PROP / ERASE-PROP;
markForGrade?; UNIT_DEEPEN_V1 (imperfect: Lean Prop vs Idris quantity 0); SYSTEMS_LEAN_HOST;
ERASURE-THEOREM; HOST-ERASURE-THEOREM.

## Intent

Compile-time-only values must not survive product emit when checks succeed
(**ERASE-RULE-MULT-0**, **ERASE-NO-RUNTIME**).
Lean Prop erasure is not the same mechanism as Idris quantity 0 -- working map with
exceptions, not isomorphism of erasure (see `doc/divergence.md` for
**EDGE-PROP** / **ERASE-PROP**).

TYPED_IR_V0 pairs ERASED kind with MULT-0 on ir_node (composes erasure grades).

## Lean host (SYSTEMS_LEAN_HOST)

| Host surface | Role |
|--------------|------|
| `SystemsLean.Erasure.Erased` | Zero-payload marker (`marked : Bool`) |
| `unmarked` / `mark` | Unmarked handle; mark for runtime-absent claim |
| `isRuntimeAbsent` / `erasureIsRuntimeAbsent` | True only when marked (fail closed unmarked) |
| `isErasureGrade` | True only for MULT-0 |
| `markForGrade?` | Mark only on MULT-0; else none (fail closed) |
| `checkFailClosed` | MULT-0 + marked (FAIL_CLOSED_CHECKER_V1 mult-0 path honesty) |
| ERASURE-THEOREM / HOST-ERASURE-THEOREM | Real theorems: isRuntimeAbsent_unmarked_false / mark true, isRuntimeAbsent_eq_marked, isErasureGrade mult0-only, markForGrade? mult0 some / mult1/omega none, markForGrade?_some_implies_isErasureGrade / markForGrade?_some_is_mark / markForGrade?_mult0_isRuntimeAbsent, checkFailClosed_eq + unmarked false / marked mult0 true / mult1/omega false, mark_idempotent -- partial Erasure only; not SpecProof complete |

Classic Lean Prop erasure is **not** freestanding product erasure (EDGE-PROP / ERASE-PROP).

## Emit mapping (UNIT_TRANSLATION_V0 / UNIT_DEEPEN_V1; frozen wire)

V0 freestanding C (`SLAKE_EMIT_FREESTANDING_C_V0`) exposes a zero-payload erased
marker type (`slake_erased`) and runtime-absent probe
(`slake_erasure_is_runtime_absent`): returns **1** only when non-null and
`marked`, else **0** (fail closed on unmarked handles). Host maps honesty only;
not a full erasure pass and not residual free.

## Non-claims

- No full erasure pass body here
- Not freestanding residual free
- Do not paper over EDGE-PROP / ERASE-PROP
