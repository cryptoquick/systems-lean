/-
  SYSTEMS_LEAN_HOST partial -- ordered IR program (node list) on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): Types.slake / types.md ir_program notes,
    emit slake_ir_program_* (historical stage id IR_PROGRAM_V0 on frozen wire).
  Shared core map: doc/shared-ir-sketch.md.

  Spec (readable, separate from any future proof):
  - An ordered IR program is a fixed-capacity ordered list of typed IR nodes.
  - Capacity honesty: programCap = 8 (emit SLAKE_IR_PROGRAM_CAP).
  - Host uses List under the cap; emit uses a fixed array of the same capacity.
  - push appends a well-typed node; fail closed on bad node or full capacity.
  - isWellTyped: non-empty, length <= programCap, and every live node well-typed.
  - EMPTY-PROGRAM-FAIL-CLOSED: empty program (count 0) is NOT well-typed as a
    program (matches emit slake_ir_program_is_well_typed).
  - Oversize lists (length > programCap) fail well-typed (emit count > CAP reject).
  - foldWellTyped folds left-to-right only when the program is well-typed;
    otherwise none (fail closed).
  - Not a control-flow graph. Not graph edges (see SystemsLean.IrGraph for edge host surface).

  Theorems (IR-PROGRAM-THEOREM / HOST-IR-PROGRAM-THEOREM -- partial IrProgram only):
  - empty_isEmpty / empty_length_zero: empty program facts.
  - isWellTyped_empty_false / empty_not_well_typed: EMPTY-PROGRAM-FAIL-CLOSED core.
  - checkFailClosed_eq_isWellTyped: checkFailClosed is isWellTyped.
  - foldWellTyped_ill_typed_none / foldWellTyped_empty_none: no fold when ill-typed.
  - push_bad_node: bad node yields PushResult.badNode.
  - programCap_eq_eight: capacity honesty (emit SLAKE_IR_PROGRAM_CAP).
  - push_value_one_ok / length_single_value / isWellTyped_single_value:
    one well-typed VALUE node is a well-typed length-1 program.
  - foldWellTyped_single_value_some: fold success path on one well-typed node.
  - isWellTyped_two_values / length_two_values / foldWellTyped_two_values_some:
    multi-node well-typed + fold success.
  - push_second_value_ok: second well-typed push length honesty.
  - push_full_at_cap: push at programCap fails closed (full).
  These IrProgram theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial theorems on IrProgram != host proof complete != residual free.

  Intentional non-claims:
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Not a full elaborator. Not CFG / dominance / SSA.
  - Historical wire id IR_PROGRAM_V0 is emit map only; new host names prefer
    ordered IR program / node list (no banned metaphor jargon in this module).

  Greppable: SYSTEMS_LEAN_HOST, ORDERED-IR-PROGRAM, EMPTY-PROGRAM-FAIL-CLOSED,
  IR-PROGRAM-THEOREM, HOST-IR-PROGRAM-THEOREM, isWellTyped_empty_false,
  empty_not_well_typed, empty_isEmpty, empty_length_zero,
  checkFailClosed_eq_isWellTyped, foldWellTyped_empty_none,
  foldWellTyped_ill_typed_none, push_bad_node, programCap_eq_eight,
  push_value_one_ok, length_single_value, isWellTyped_single_value,
  foldWellTyped_single_value_some, isWellTyped_two_values, length_two_values,
  foldWellTyped_two_values_some, push_second_value_ok, push_full_at_cap,
  SLAKE_IR_PROGRAM_CAP, MULT-0, MULT-1, MULT-OMEGA, TYPED_IR_V0
  UNIT_SURFACE host surface. Module: SystemsLean.IrProgram
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types

namespace SystemsLean.IrProgram

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind typeTagInit)

/-- Fixed capacity matching emit SLAKE_IR_PROGRAM_CAP (honesty map). -/
def programCap : Nat := 8

/-- Ordered IR program: ordered list of typed IR nodes under programCap.
    ORDERED-IR-PROGRAM host surface. -/
structure Program where
  nodes : List IrNode
  deriving DecidableEq, Repr

/-- Empty ordered IR program (not well-typed as a program; see isWellTyped). -/
def empty : Program := { nodes := [] }

/-- Live node count. -/
def length (p : Program) : Nat := p.nodes.length

/-- True when no live nodes. -/
def isEmpty (p : Program) : Bool := p.nodes.isEmpty

/-- Result of push: ok with new program, bad node, or full capacity.
    Emit map: 0 ok; -1 null/bad; -2 full. -/
inductive PushResult where
  | ok (p : Program)
  | badNode
  | full
  deriving DecidableEq, Repr

/-- push p n -- append a well-typed node.
    Fail closed: badNode when n is not well-typed; full when at programCap.
    Bad push leaves the original program unchanged (caller keeps p). -/
def push (p : Program) (n : IrNode) : PushResult :=
  if !n.isWellTyped then
    PushResult.badNode
  else if p.nodes.length >= programCap then
    PushResult.full
  else
    PushResult.ok { nodes := p.nodes ++ [n] }

/-- isWellTyped p -- non-empty, within programCap, and every live node well-typed.
    EMPTY-PROGRAM-FAIL-CLOSED: empty program is not well-typed as a program.
    Oversize (length > programCap) fails closed (emit count > CAP parity). -/
def isWellTyped (p : Program) : Bool :=
  !p.nodes.isEmpty
    && decide (p.nodes.length <= programCap)
    && p.nodes.all IrNode.isWellTyped

/-- foldWellTyped p init f -- left-to-right fold over ordered nodes when the
    program is well-typed; none when empty or any node fails well-typed.
    Fail closed: does not fold an ill-typed program. -/
def foldWellTyped {alpha : Type} (p : Program) (init : alpha)
    (f : alpha -> IrNode -> alpha) : Option alpha :=
  if isWellTyped p then
    some (List.foldl f init p.nodes)
  else
    none

/-- Fail-closed program check (host V0): same bar as isWellTyped.
    Emit compose path adds FAIL_CLOSED_CHECKER_V1 per node; that is product wire. -/
def checkFailClosed (p : Program) : Bool := isWellTyped p

/-! ### IR-PROGRAM-THEOREM / HOST-IR-PROGRAM-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is ordered IR
  program EMPTY-PROGRAM-FAIL-CLOSED and cheap push/fold contracts only.
  Does not complete SpecProof; does not claim residual free / freestanding
  product self-host complete / PROVABLY.
-/

/-- Empty program has no live nodes. Greppable: empty_isEmpty, IR-PROGRAM-THEOREM. -/
theorem empty_isEmpty : isEmpty empty = true := rfl

/-- Empty program live count is zero. Greppable: empty_length_zero, IR-PROGRAM-THEOREM. -/
theorem empty_length_zero : length empty = 0 := rfl

/-- Capacity honesty: programCap matches emit SLAKE_IR_PROGRAM_CAP.
    Greppable: programCap_eq_eight, SLAKE_IR_PROGRAM_CAP, IR-PROGRAM-THEOREM. -/
theorem programCap_eq_eight : programCap = 8 := rfl

/-- EMPTY-PROGRAM-FAIL-CLOSED core: empty program is not well-typed as a program.
    Greppable: isWellTyped_empty_false, EMPTY-PROGRAM-FAIL-CLOSED, IR-PROGRAM-THEOREM,
    HOST-IR-PROGRAM-THEOREM. -/
theorem isWellTyped_empty_false : isWellTyped empty = false := rfl

/-- Alias of isWellTyped_empty_false (readable empty reject name).
    Greppable: empty_not_well_typed, EMPTY-PROGRAM-FAIL-CLOSED, IR-PROGRAM-THEOREM. -/
theorem empty_not_well_typed : isWellTyped empty = false := isWellTyped_empty_false

/-- checkFailClosed is definitionally isWellTyped.
    Greppable: checkFailClosed_eq_isWellTyped, IR-PROGRAM-THEOREM. -/
theorem checkFailClosed_eq_isWellTyped (p : Program) :
    checkFailClosed p = isWellTyped p := rfl

/-- Fail closed fold: ill-typed programs yield none (no partial fold).
    Greppable: foldWellTyped_ill_typed_none, IR-PROGRAM-THEOREM, HOST-IR-PROGRAM-THEOREM. -/
theorem foldWellTyped_ill_typed_none {alpha : Type} (p : Program) (init : alpha)
    (f : alpha -> IrNode -> alpha) (h : isWellTyped p = false) :
    foldWellTyped p init f = none := by
  unfold foldWellTyped
  rw [h]
  rfl

/-- EMPTY-PROGRAM-FAIL-CLOSED on fold: empty program does not fold.
    Greppable: foldWellTyped_empty_none, EMPTY-PROGRAM-FAIL-CLOSED, IR-PROGRAM-THEOREM. -/
theorem foldWellTyped_empty_none {alpha : Type} (init : alpha)
    (f : alpha -> IrNode -> alpha) :
    foldWellTyped empty init f = none :=
  foldWellTyped_ill_typed_none empty init f isWellTyped_empty_false

/-- push fails closed on a node that is not well-typed (badNode; original p kept).
    Greppable: push_bad_node, IR-PROGRAM-THEOREM, HOST-IR-PROGRAM-THEOREM. -/
theorem push_bad_node (p : Program) (n : IrNode) (h : n.isWellTyped = false) :
    push p n = PushResult.badNode := by
  unfold push
  rw [h]
  rfl

/-! ### Single well-typed node program (beyond EMPTY-PROGRAM-FAIL-CLOSED) -/

private def thmValueNode : IrNode :=
  { ty := typeTagInit 1, mult := Mult.multOmega, kind := NodeKind.value }

/-- push empty with a well-typed VALUE node yields a one-node program.
    Greppable: push_value_one_ok, IR-PROGRAM-THEOREM, HOST-IR-PROGRAM-THEOREM. -/
theorem push_value_one_ok :
    push empty thmValueNode =
      PushResult.ok { nodes := [thmValueNode] } := rfl

/-- One well-typed VALUE node has length 1.
    Greppable: length_single_value, IR-PROGRAM-THEOREM, HOST-IR-PROGRAM-THEOREM. -/
theorem length_single_value :
    length { nodes := [thmValueNode] } = 1 := rfl

/-- One well-typed VALUE node is a well-typed program (EMPTY-PROGRAM contrast).
    Greppable: isWellTyped_single_value, IR-PROGRAM-THEOREM,
    HOST-IR-PROGRAM-THEOREM. -/
theorem isWellTyped_single_value :
    isWellTyped { nodes := [thmValueNode] } = true := rfl

/-- foldWellTyped success path: single well-typed VALUE node folds to some count.
    Contrasts foldWellTyped_empty_none / foldWellTyped_ill_typed_none.
    Greppable: foldWellTyped_single_value_some, IR-PROGRAM-THEOREM,
    HOST-IR-PROGRAM-THEOREM. -/
theorem foldWellTyped_single_value_some :
    foldWellTyped { nodes := [thmValueNode] } (0 : Nat) (fun acc _ => acc + 1) =
      some 1 := rfl

/-! ### Multi-node well-typed + capacity fail-closed (beyond single-node) -/

private def thmValueNodeB : IrNode :=
  { ty := typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }

private def thmTwoValues : Program :=
  { nodes := [thmValueNode, thmValueNodeB] }

/-- Two well-typed VALUE nodes form a well-typed program.
    Greppable: isWellTyped_two_values, IR-PROGRAM-THEOREM, HOST-IR-PROGRAM-THEOREM. -/
theorem isWellTyped_two_values :
    isWellTyped thmTwoValues = true := rfl

/-- Two-node program has length 2.
    Greppable: length_two_values, IR-PROGRAM-THEOREM. -/
theorem length_two_values : length thmTwoValues = 2 := rfl

/-- foldWellTyped success path on two well-typed VALUE nodes.
    Greppable: foldWellTyped_two_values_some, IR-PROGRAM-THEOREM,
    HOST-IR-PROGRAM-THEOREM. -/
theorem foldWellTyped_two_values_some :
    foldWellTyped thmTwoValues (0 : Nat) (fun acc _ => acc + 1) = some 2 := rfl

/-- push of a second well-typed VALUE onto a one-node program succeeds.
    Greppable: push_second_value_ok, IR-PROGRAM-THEOREM, HOST-IR-PROGRAM-THEOREM. -/
theorem push_second_value_ok :
    push { nodes := [thmValueNode] } thmValueNodeB =
      PushResult.ok thmTwoValues := rfl

/-- Full program at programCap rejects further push (FAIL-CLOSED full).
    Greppable: push_full_at_cap, SLAKE_IR_PROGRAM_CAP, IR-PROGRAM-THEOREM,
    HOST-IR-PROGRAM-THEOREM. -/
theorem push_full_at_cap :
    push {
      nodes := [
        thmValueNode, thmValueNodeB, thmValueNode, thmValueNodeB,
        thmValueNode, thmValueNodeB, thmValueNode, thmValueNodeB
      ]
    } thmValueNode = PushResult.full := rfl

end SystemsLean.IrProgram
