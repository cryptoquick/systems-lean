/-
  SYSTEMS_LEAN_HOST partial -- Types and typed IR nodes on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): Types.slake, types.md, emit slake_type_tag / slake_ir_node_*.
  Shared core map: doc/shared-ir-sketch.md (Types row).

  Spec (readable, separate from any future proof):
  - Types are the COMMON-UNIVERSE for Slake shared core.
  - HOST-RESIDUAL (Idris side / Lean side elaborator differences) is not
    PRODUCT-WIRE-RESIDUAL (freestanding emit residual).
  - TypeTag is a thin tag (emit: slake_type_tag).
  - NodeKind is closed: VALUE, LINEAR, ERASED (emit: enum slake_ir_kind).
  - Kind/mult pairing (fail closed):
      VALUE  <-> MULT-OMEGA
      LINEAR <-> MULT-1
      ERASED <-> MULT-0
  - Typed IrNode is well-typed when kind matches mult (closed inductives).
  - FAIL-CLOSED-UNKNOWN-KIND attaches to ofKindTag? / isValidKindTag only:
    unknown raw kind tags decode to none / false.
  - mkNode? / mkNodeFromTags? fail closed on kind/mult mismatch or unknown tags.

  Theorems (TYPES-THEOREM / HOST-TYPES-THEOREM -- partial Types proofs only):
  - ofKindTag? known tags 0/1/2 succeed (ofKindTag?_zero / ofKindTag?_one / ofKindTag?_two).
  - ofKindTag?_fail_closed / isValidKindTag_fail_closed: n > 2 rejects (FAIL-CLOSED).
  - isValidKindTag_eq_ofKindTag?_isSome: isValidKindTag is ofKindTag? isSome.
  - kindMultOk known pairings (VALUE/omega, LINEAR/1, ERASED/0).
  - kindMultOk mismatch family: wrong kind/mult pairings are false
    (kindMultOk_value_not_one / value_not_zero / linear_not_omega /
    linear_not_zero / erased_not_omega / erased_not_one).
  - mkNode?_mismatch_none: mkNode? fails closed on kind/mult mismatch.
  - expectedMult_value / expectedMult_linear / expectedMult_erased table honesty.
  - IrNode.isWellTyped_eq_kindMultOk: well-typed is kindMultOk.
  - mkNode?_ok: success path when kindMultOk (fields match).
  - mkNodeFromTags?_unknown_mult / unknown_kind fail closed.
  - mkNodeFromTags?_value_omega_some / linear_one_some / erased_zero_some.
  These Types theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial theorems on Types != host proof complete != residual free.

  Intentional non-claims:
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Not a full elaborator. Not a control-flow graph.

  Greppable: SYSTEMS_LEAN_HOST, COMMON-UNIVERSE, HOST-RESIDUAL, PRODUCT-WIRE-RESIDUAL,
  TYPED_IR_V0, FAIL-CLOSED-UNKNOWN-KIND, MULT-0, MULT-1, MULT-OMEGA,
  TYPES-THEOREM, HOST-TYPES-THEOREM, ofKindTag?_fail_closed, isValidKindTag_fail_closed,
  ofKindTag?_zero, ofKindTag?_one, ofKindTag?_two, isValidKindTag_eq_ofKindTag?_isSome,
  isValidKindTag_zero, isValidKindTag_one, isValidKindTag_two,
  kindMultOk_value_omega, kindMultOk_linear_one, kindMultOk_erased_zero,
  kindMultOk_value_not_one, kindMultOk_value_not_zero, kindMultOk_linear_not_omega,
  kindMultOk_linear_not_zero, kindMultOk_erased_not_omega, kindMultOk_erased_not_one,
  mkNode?_mismatch_none, expectedMult_value, expectedMult_linear, expectedMult_erased,
  isWellTyped_eq_kindMultOk, mkNode?_ok, mkNodeFromTags?_unknown_mult,
  mkNodeFromTags?_unknown_kind, mkNodeFromTags?_value_omega_some,
  mkNodeFromTags?_linear_one_some, mkNodeFromTags?_erased_zero_some
  UNIT_SURFACE host surface. Module: SystemsLean.Types
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult

namespace SystemsLean.Types

open SystemsLean.Mult (Mult)

/-- Thin COMMON-UNIVERSE type tag (emit map: slake_type_tag / slake_type_tag_init).
    Host residual and product wire residual stay separate. -/
structure TypeTag where
  tag : Nat
  deriving DecidableEq, Repr

/-- typeTagInit tag -- construct a thin type tag (always succeeds on Nat).
    Emit null fail-closed is a product-wire concern, not a host Nat concern. -/
def typeTagInit (tag : Nat) : TypeTag := { tag := tag }

/-- IR node kind (emit: enum slake_ir_kind). Closed inductive. -/
inductive NodeKind where
  | value
  | linear
  | erased
  deriving DecidableEq, Repr

/-- Human-facing kind ids (greppable contract surface). -/
def NodeKind.name : NodeKind -> String
  | NodeKind.value => "VALUE"
  | NodeKind.linear => "LINEAR"
  | NodeKind.erased => "ERASED"

/-- Expected Mult for each kind (kind/mult pairing table).
    Explicit match so a future kind must update this table. -/
def NodeKind.expectedMult : NodeKind -> Mult
  | NodeKind.value => Mult.multOmega
  | NodeKind.linear => Mult.mult1
  | NodeKind.erased => Mult.mult0

/-- kindMultOk k m -- true when kind pairs with mult (fail-closed pairing). -/
def kindMultOk (k : NodeKind) (m : Mult) : Bool :=
  decide (k.expectedMult = m)

/-- Raw kind tag decode aligned with freestanding C enum slake_ir_kind
    (0 = VALUE, 1 = LINEAR, 2 = ERASED).
    FAIL-CLOSED-UNKNOWN-KIND: unknown tags return none. -/
def ofKindTag? : Nat -> Option NodeKind
  | 0 => some NodeKind.value
  | 1 => some NodeKind.linear
  | 2 => some NodeKind.erased
  | _ => none

/-- FAIL-CLOSED-UNKNOWN-KIND on raw tags: true only for known 0/1/2. -/
def isValidKindTag (n : Nat) : Bool := (ofKindTag? n).isSome

/-- Typed IR node (emit map: slake_ir_node; TYPED_IR_V0 honesty).
    type tag + mult + kind. Well-typed when kind matches mult. -/
structure IrNode where
  ty : TypeTag
  mult : Mult
  kind : NodeKind
  deriving DecidableEq, Repr

/-- isWellTyped n -- true when kind/mult pairing holds (closed inductives).
    Unknown grades/kinds cannot inhabit Mult / NodeKind; raw-tag reject is
    Mult.ofNat? / ofKindTag? only. -/
def IrNode.isWellTyped (n : IrNode) : Bool := kindMultOk n.kind n.mult

/-- Fail-closed node construction from typed Mult + NodeKind.
    none when kind/mult mismatch. -/
def mkNode? (tag : Nat) (m : Mult) (k : NodeKind) : Option IrNode :=
  if kindMultOk k m then
    some { ty := typeTagInit tag, mult := m, kind := k }
  else
    none

/-- Raw tag path: fail closed on unknown mult or kind tags, or kind/mult mismatch.
    Map name honesty: slake_ir_node_init leave-invalid path. -/
def mkNodeFromTags? (typeTag multTag kindTag : Nat) : Option IrNode :=
  match Mult.ofNat? multTag, ofKindTag? kindTag with
  | some m, some k => mkNode? typeTag m k
  | _, _ => none

/-! ### TYPES-THEOREM / HOST-TYPES-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is NodeKind tags
  and FAIL-CLOSED-UNKNOWN-KIND only. Does not complete SpecProof; does not
  claim residual free / freestanding product self-host complete / PROVABLY.
-/

/-- Known raw tag 0 decodes to VALUE. Greppable: ofKindTag?_zero, TYPES-THEOREM. -/
theorem ofKindTag?_zero : ofKindTag? 0 = some NodeKind.value := rfl

/-- Known raw tag 1 decodes to LINEAR. Greppable: ofKindTag?_one, TYPES-THEOREM. -/
theorem ofKindTag?_one : ofKindTag? 1 = some NodeKind.linear := rfl

/-- Known raw tag 2 decodes to ERASED. Greppable: ofKindTag?_two, TYPES-THEOREM. -/
theorem ofKindTag?_two : ofKindTag? 2 = some NodeKind.erased := rfl

/-- FAIL-CLOSED-UNKNOWN-KIND: raw tags with n > 2 reject to none (no coerce).
    Greppable: ofKindTag?_fail_closed, FAIL-CLOSED-UNKNOWN-KIND, TYPES-THEOREM,
    HOST-TYPES-THEOREM. -/
theorem ofKindTag?_fail_closed (n : Nat) (h : 2 < n) : ofKindTag? n = none := by
  cases n with
  | zero =>
    -- h : 2 < 0 is false; ASCII Not (no Unicode not-sign).
    exact absurd h (by decide : Not (2 < 0))
  | succ n1 =>
    cases n1 with
    | zero =>
      exact absurd h (by decide : Not (2 < 1))
    | succ n2 =>
      cases n2 with
      | zero =>
        exact absurd h (by decide : Not (2 < 2))
      | succ _ =>
        rfl

/-- isValidKindTag is definitionally ofKindTag? isSome.
    Greppable: isValidKindTag_eq_ofKindTag?_isSome, TYPES-THEOREM. -/
theorem isValidKindTag_eq_ofKindTag?_isSome (n : Nat) :
    isValidKindTag n = (ofKindTag? n).isSome := rfl

/-- Known tags 0/1/2 are valid raw kind tags.
    Greppable: isValidKindTag_zero, isValidKindTag_one, isValidKindTag_two, TYPES-THEOREM. -/
theorem isValidKindTag_zero : isValidKindTag 0 = true := rfl
theorem isValidKindTag_one : isValidKindTag 1 = true := rfl
theorem isValidKindTag_two : isValidKindTag 2 = true := rfl

/-- FAIL-CLOSED-UNKNOWN-KIND on isValidKindTag: n > 2 is false.
    Greppable: isValidKindTag_fail_closed, FAIL-CLOSED-UNKNOWN-KIND, TYPES-THEOREM,
    HOST-TYPES-THEOREM. -/
theorem isValidKindTag_fail_closed (n : Nat) (h : 2 < n) : isValidKindTag n = false := by
  unfold isValidKindTag
  rw [ofKindTag?_fail_closed n h]
  rfl

/-- Known kind/mult pairings hold (VALUE/omega, LINEAR/1, ERASED/0).
    Greppable: kindMultOk_value_omega, kindMultOk_linear_one, kindMultOk_erased_zero,
    TYPES-THEOREM. -/
theorem kindMultOk_value_omega : kindMultOk NodeKind.value Mult.multOmega = true := rfl
theorem kindMultOk_linear_one : kindMultOk NodeKind.linear Mult.mult1 = true := rfl
theorem kindMultOk_erased_zero : kindMultOk NodeKind.erased Mult.mult0 = true := rfl

/-- Wrong kind/mult pairings reject (fail-closed pairing table).
    Greppable: kindMultOk_value_not_one, kindMultOk_value_not_zero,
    kindMultOk_linear_not_omega, kindMultOk_linear_not_zero,
    kindMultOk_erased_not_omega, kindMultOk_erased_not_one, TYPES-THEOREM,
    HOST-TYPES-THEOREM. -/
theorem kindMultOk_value_not_one : kindMultOk NodeKind.value Mult.mult1 = false := rfl
theorem kindMultOk_value_not_zero : kindMultOk NodeKind.value Mult.mult0 = false := rfl
theorem kindMultOk_linear_not_omega : kindMultOk NodeKind.linear Mult.multOmega = false := rfl
theorem kindMultOk_linear_not_zero : kindMultOk NodeKind.linear Mult.mult0 = false := rfl
theorem kindMultOk_erased_not_omega : kindMultOk NodeKind.erased Mult.multOmega = false := rfl
theorem kindMultOk_erased_not_one : kindMultOk NodeKind.erased Mult.mult1 = false := rfl

/-- mkNode? fails closed when kind/mult pairing is false (any type tag).
    Greppable: mkNode?_mismatch_none, TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem mkNode?_mismatch_none (tag : Nat) (m : Mult) (k : NodeKind)
    (h : kindMultOk k m = false) : mkNode? tag m k = none := by
  unfold mkNode?
  rw [h]
  rfl

/-- expectedMult table: VALUE expects MULT-OMEGA.
    Greppable: expectedMult_value, TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem expectedMult_value :
    NodeKind.expectedMult NodeKind.value = Mult.multOmega := rfl

/-- expectedMult table: LINEAR expects MULT-1.
    Greppable: expectedMult_linear, TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem expectedMult_linear :
    NodeKind.expectedMult NodeKind.linear = Mult.mult1 := rfl

/-- expectedMult table: ERASED expects MULT-0.
    Greppable: expectedMult_erased, TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem expectedMult_erased :
    NodeKind.expectedMult NodeKind.erased = Mult.mult0 := rfl

/-- IrNode.isWellTyped is definitionally kindMultOk on kind and mult.
    Greppable: isWellTyped_eq_kindMultOk, TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem isWellTyped_eq_kindMultOk (n : IrNode) :
    n.isWellTyped = kindMultOk n.kind n.mult := rfl

/-- mkNode? success path: kindMultOk true yields some with matching fields.
    Greppable: mkNode?_ok, TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem mkNode?_ok (tag : Nat) (m : Mult) (k : NodeKind)
    (h : kindMultOk k m = true) :
    mkNode? tag m k =
      some { ty := typeTagInit tag, mult := m, kind := k } := by
  unfold mkNode?
  rw [h]
  rfl

/-- mkNodeFromTags? fails closed on unknown mult tag (n > 2).
    Greppable: mkNodeFromTags?_unknown_mult, FAIL-CLOSED-UNKNOWN-GRADE,
    TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem mkNodeFromTags?_unknown_mult (typeTag kindTag multTag : Nat)
    (h : 2 < multTag) : mkNodeFromTags? typeTag multTag kindTag = none := by
  unfold mkNodeFromTags?
  have hm : Mult.ofNat? multTag = none := Mult.ofNat?_fail_closed multTag h
  simp [hm]

/-- mkNodeFromTags? fails closed on unknown kind tag (n > 2).
    Greppable: mkNodeFromTags?_unknown_kind, FAIL-CLOSED-UNKNOWN-KIND,
    TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem mkNodeFromTags?_unknown_kind (typeTag multTag kindTag : Nat)
    (h : 2 < kindTag) : mkNodeFromTags? typeTag multTag kindTag = none := by
  unfold mkNodeFromTags?
  have hk : ofKindTag? kindTag = none := ofKindTag?_fail_closed kindTag h
  simp [hk]

/-- Known good tags (mult 2, kind 0) build VALUE/MULT-OMEGA node.
    Greppable: mkNodeFromTags?_value_omega_some, TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem mkNodeFromTags?_value_omega_some (typeTag : Nat) :
    mkNodeFromTags? typeTag 2 0 =
      some {
        ty := typeTagInit typeTag
        mult := Mult.multOmega
        kind := NodeKind.value
      } := rfl

/-- Known good tags (mult 1, kind 1) build LINEAR/MULT-1 node.
    Greppable: mkNodeFromTags?_linear_one_some, TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem mkNodeFromTags?_linear_one_some (typeTag : Nat) :
    mkNodeFromTags? typeTag 1 1 =
      some {
        ty := typeTagInit typeTag
        mult := Mult.mult1
        kind := NodeKind.linear
      } := rfl

/-- Known good tags (mult 0, kind 2) build ERASED/MULT-0 node.
    Greppable: mkNodeFromTags?_erased_zero_some, TYPES-THEOREM, HOST-TYPES-THEOREM. -/
theorem mkNodeFromTags?_erased_zero_some (typeTag : Nat) :
    mkNodeFromTags? typeTag 0 2 =
      some {
        ty := typeTagInit typeTag
        mult := Mult.mult0
        kind := NodeKind.erased
      } := rfl

end SystemsLean.Types
