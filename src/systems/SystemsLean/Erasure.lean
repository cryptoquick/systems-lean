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

  Intentional non-claims:
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Classic Lean Prop erasure is not freestanding product erasure.
  - Not a full erasure pass. Not residual free.

  Greppable: SYSTEMS_LEAN_HOST, ERASE-RULE-MULT-0, ERASE-NO-RUNTIME, EDGE-PROP, ERASE-PROP
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

end SystemsLean.Erasure
