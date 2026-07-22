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

  Intentional non-claims:
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Not a full elaborator. Not a control-flow graph.

  Greppable: SYSTEMS_LEAN_HOST, COMMON-UNIVERSE, HOST-RESIDUAL, PRODUCT-WIRE-RESIDUAL,
  TYPED_IR_V0, FAIL-CLOSED-UNKNOWN-KIND, MULT-0, MULT-1, MULT-OMEGA
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

end SystemsLean.Types
