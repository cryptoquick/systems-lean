/-
  SYSTEMS_LEAN_HOST partial -- Erasure (MULT-0 compile-time-only) on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): Erasure.slake, erasure.md,
    emit slake_erased / slake_erasure_is_runtime_absent (frozen wire honesty only).

  Spec (readable, separate from any future proof):
  - ERASE-RULE-MULT-0: MULT-0 values are compile-time-only when checks succeed.
  - ERASE-NO-RUNTIME: marked erasure claims no product runtime presence.
  - Erased is a zero-payload marker handle (emit: slake_erased with marked flag).
  - unmarked: handle present but not yet marked erased (fail closed for runtime-absent).
  - mark flips marked to true (host model of slake_erased_mark).
  - isRuntimeAbsent / erasureIsRuntimeAbsent: true only when marked
    (emit: slake_erasure_is_runtime_absent returns 1 only for non-null marked;
    host has no null pointer -- unmarked fails closed).
  - EDGE-PROP / ERASE-PROP: Lean Prop erasure is not Idris quantity 0 -- working map
    with exceptions, not isomorphism of erasure mechanisms.
  - isErasureGrade: true only for Mult.mult0 (pairs with Types ERASED <-> MULT-0).
  - markForGrade?: mark only when grade is MULT-0; else none (fail closed).

  Theorems (ERASURE-THEOREM / HOST-ERASURE-THEOREM -- partial Erasure only):
  - isRuntimeAbsent_unmarked_false / isRuntimeAbsent_mark_true (fail-closed mark)
  - isRuntimeAbsent_eq_marked (definitional mark flag)
  - isErasureGrade_mult0 / isErasureGrade_mult1_false / isErasureGrade_omega_false
  - markForGrade?_mult0_some / markForGrade?_mult1_none / markForGrade?_omega_none
  - markForGrade?_some_implies_isErasureGrade / markForGrade?_some_is_mark
  - checkFailClosed_eq / checkFailClosed_unmarked_false /
    checkFailClosed_marked_mult0_true / checkFailClosed_mult1_false
  - erasureIsRuntimeAbsent_eq / mark_idempotent
  These Erasure theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial theorems on Erasure != host proof complete != residual free.

  Intentional non-claims:
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Classic Lean Prop erasure is not freestanding product erasure.
  - Not a full erasure pass. Not residual free.

  Greppable: SYSTEMS_LEAN_HOST, ERASE-RULE-MULT-0, ERASE-NO-RUNTIME, EDGE-PROP, ERASE-PROP,
  ERASURE-THEOREM, HOST-ERASURE-THEOREM, isRuntimeAbsent_unmarked_false,
  markForGrade?_mult1_none, checkFailClosed_unmarked_false, checkFailClosed_eq,
  markForGrade?_some_implies_isErasureGrade, isRuntimeAbsent_eq_marked
  UNIT_SURFACE host surface. Module: SystemsLean.Erasure
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult

namespace SystemsLean.Erasure

open SystemsLean.Mult (Mult)

/-- Zero-payload erased marker (emit map: slake_erased).
    marked true means ERASE-NO-RUNTIME claim is live for this handle. -/
structure Erased where
  marked : Bool
  deriving DecidableEq, Repr

/-- Unmarked handle (not runtime-absent yet; fail closed until mark). -/
def unmarked : Erased := { marked := false }

/-- mark e -- mark erased for product runtime-absent claim.
    Emit map honesty: slake_erased_mark. Idempotent on already-marked handles. -/
def mark (_e : Erased) : Erased := { marked := true }

/-- isRuntimeAbsent e -- true only when marked (ERASE-NO-RUNTIME).
    Fail closed: unmarked is not runtime-absent.
    Emit map: slake_erasure_is_runtime_absent (1 only when non-null and marked). -/
def isRuntimeAbsent (e : Erased) : Bool := e.marked

/-- Map name honesty: erasureIsRuntimeAbsent / slake_erasure_is_runtime_absent. -/
def erasureIsRuntimeAbsent (e : Erased) : Bool := isRuntimeAbsent e

/-- isErasureGrade m -- true only for MULT-0 (ERASE-RULE-MULT-0).
    Types pairs ERASED kind with MULT-0; host Mult is closed.
    Explicit match so a future grade must update this table. -/
def isErasureGrade (m : Mult) : Bool :=
  match m with
  | Mult.mult0 => true
  | Mult.mult1 => false
  | Mult.multOmega => false

/-- markForGrade? m e -- mark only when m is MULT-0 (ERASE-RULE-MULT-0).
    Fail closed: MULT-1 / MULT-OMEGA cannot claim erasure mark; returns none.
    Success path returns marked Erased (payload-free ERASE-NO-RUNTIME handle). -/
def markForGrade? (m : Mult) (e : Erased) : Option Erased :=
  if isErasureGrade m then
    some (mark e)
  else
    none

/-- Fail-closed erasure check: MULT-0 grade and marked erased handle.
    Unmarked MULT-0 fails closed (matches FAIL_CLOSED_CHECKER_V1 mult-0 path honesty).
    Non-MULT-0 fails closed (cannot claim ERASE-NO-RUNTIME without erasure grade). -/
def checkFailClosed (m : Mult) (e : Erased) : Bool :=
  isErasureGrade m && isRuntimeAbsent e

/-! ### ERASURE-THEOREM / HOST-ERASURE-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is ERASE-NO-RUNTIME
  mark fail-closed and ERASE-RULE-MULT-0 grade gate only. Does not complete
  SpecProof; does not claim residual free / freestanding product self-host
  complete / PROVABLY.
-/

/-- Unmarked handle is not runtime-absent (fail closed).
    Greppable: isRuntimeAbsent_unmarked_false, ERASE-NO-RUNTIME, ERASURE-THEOREM,
    HOST-ERASURE-THEOREM. -/
theorem isRuntimeAbsent_unmarked_false :
    isRuntimeAbsent unmarked = false := rfl

/-- mark flips handle to runtime-absent (ERASE-NO-RUNTIME).
    Greppable: isRuntimeAbsent_mark_true, ERASE-NO-RUNTIME, ERASURE-THEOREM. -/
theorem isRuntimeAbsent_mark_true (e : Erased) :
    isRuntimeAbsent (mark e) = true := rfl

/-- erasureIsRuntimeAbsent tracks isRuntimeAbsent.
    Greppable: erasureIsRuntimeAbsent_eq, ERASURE-THEOREM. -/
theorem erasureIsRuntimeAbsent_eq (e : Erased) :
    erasureIsRuntimeAbsent e = isRuntimeAbsent e := rfl

/-- mark is idempotent on already-marked handles.
    Greppable: mark_idempotent, ERASURE-THEOREM. -/
theorem mark_idempotent (e : Erased) : mark (mark e) = mark e := rfl

/-- MULT-0 is the only erasure grade (ERASE-RULE-MULT-0).
    Greppable: isErasureGrade_mult0, ERASE-RULE-MULT-0, ERASURE-THEOREM. -/
theorem isErasureGrade_mult0 : isErasureGrade Mult.mult0 = true := rfl

/-- MULT-1 is not an erasure grade.
    Greppable: isErasureGrade_mult1_false, ERASE-RULE-MULT-0, ERASURE-THEOREM. -/
theorem isErasureGrade_mult1_false : isErasureGrade Mult.mult1 = false := rfl

/-- MULT-OMEGA is not an erasure grade.
    Greppable: isErasureGrade_omega_false, ERASE-RULE-MULT-0, ERASURE-THEOREM. -/
theorem isErasureGrade_omega_false : isErasureGrade Mult.multOmega = false := rfl

/-- markForGrade? succeeds only on MULT-0 (returns marked handle).
    Greppable: markForGrade?_mult0_some, ERASE-RULE-MULT-0, ERASURE-THEOREM,
    HOST-ERASURE-THEOREM. -/
theorem markForGrade?_mult0_some (e : Erased) :
    markForGrade? Mult.mult0 e = some (mark e) := rfl

/-- markForGrade? fails closed on MULT-1.
    Greppable: markForGrade?_mult1_none, ERASE-RULE-MULT-0, ERASURE-THEOREM,
    HOST-ERASURE-THEOREM. -/
theorem markForGrade?_mult1_none (e : Erased) :
    markForGrade? Mult.mult1 e = none := rfl

/-- markForGrade? fails closed on MULT-OMEGA.
    Greppable: markForGrade?_omega_none, ERASE-RULE-MULT-0, ERASURE-THEOREM. -/
theorem markForGrade?_omega_none (e : Erased) :
    markForGrade? Mult.multOmega e = none := rfl

/-- MULT-0 unmarked fails closed (need mark for ERASE-NO-RUNTIME).
    Greppable: checkFailClosed_unmarked_false, ERASE-NO-RUNTIME, ERASURE-THEOREM,
    HOST-ERASURE-THEOREM. -/
theorem checkFailClosed_unmarked_false :
    checkFailClosed Mult.mult0 unmarked = false := rfl

/-- MULT-0 marked passes fail-closed erasure check.
    Greppable: checkFailClosed_marked_mult0_true, ERASE-NO-RUNTIME, ERASURE-THEOREM. -/
theorem checkFailClosed_marked_mult0_true (e : Erased) :
    checkFailClosed Mult.mult0 (mark e) = true := rfl

/-- MULT-1 cannot claim ERASE-NO-RUNTIME even if handle marked.
    Greppable: checkFailClosed_mult1_false, ERASE-RULE-MULT-0, ERASURE-THEOREM. -/
theorem checkFailClosed_mult1_false (e : Erased) :
    checkFailClosed Mult.mult1 e = false := rfl

/-- MULT-OMEGA cannot claim ERASE-NO-RUNTIME even if handle marked.
    Greppable: checkFailClosed_omega_false, ERASE-RULE-MULT-0, ERASURE-THEOREM. -/
theorem checkFailClosed_omega_false (e : Erased) :
    checkFailClosed Mult.multOmega e = false := rfl

/-- isRuntimeAbsent is definitionally the marked flag.
    Greppable: isRuntimeAbsent_eq_marked, ERASE-NO-RUNTIME, ERASURE-THEOREM,
    HOST-ERASURE-THEOREM. -/
theorem isRuntimeAbsent_eq_marked (e : Erased) :
    isRuntimeAbsent e = e.marked := rfl

/-- checkFailClosed is definitionally grade gate && runtime-absent.
    Greppable: checkFailClosed_eq, ERASE-RULE-MULT-0, ERASE-NO-RUNTIME,
    ERASURE-THEOREM, HOST-ERASURE-THEOREM. -/
theorem checkFailClosed_eq (m : Mult) (e : Erased) :
    checkFailClosed m e = (isErasureGrade m && isRuntimeAbsent e) := rfl

/-- Successful markForGrade? implies erasure grade (MULT-0 only path).
    Greppable: markForGrade?_some_implies_isErasureGrade, ERASE-RULE-MULT-0,
    ERASURE-THEOREM, HOST-ERASURE-THEOREM. -/
theorem markForGrade?_some_implies_isErasureGrade (m : Mult) (e e' : Erased)
    (h : markForGrade? m e = some e') : isErasureGrade m = true := by
  cases m with
  | mult0 => rfl
  | mult1 =>
    simp [markForGrade?, isErasureGrade] at h
  | multOmega =>
    simp [markForGrade?, isErasureGrade] at h

/-- Successful markForGrade? returns mark e (payload-free ERASE-NO-RUNTIME handle).
    Greppable: markForGrade?_some_is_mark, ERASE-NO-RUNTIME, ERASURE-THEOREM,
    HOST-ERASURE-THEOREM. -/
theorem markForGrade?_some_is_mark (m : Mult) (e e' : Erased)
    (h : markForGrade? m e = some e') : e' = mark e := by
  cases m with
  | mult0 =>
    simp [markForGrade?, isErasureGrade] at h
    exact h.symm
  | mult1 =>
    simp [markForGrade?, isErasureGrade] at h
  | multOmega =>
    simp [markForGrade?, isErasureGrade] at h

/-- markForGrade? MULT-0 yields mark e that is runtime-absent (composition honesty).
    Prefer And.intro over soft match fallthrough.
    Greppable: markForGrade?_mult0_isRuntimeAbsent, ERASE-NO-RUNTIME,
    ERASURE-THEOREM, HOST-ERASURE-THEOREM. -/
theorem markForGrade?_mult0_isRuntimeAbsent (e : Erased) :
    markForGrade? Mult.mult0 e = some (mark e) /\
      isRuntimeAbsent (mark e) = true :=
  And.intro rfl rfl

end SystemsLean.Erasure
