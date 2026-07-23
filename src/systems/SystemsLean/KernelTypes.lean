/-
  SYSTEMS_LEAN_HOST partial -- Types self-host kernel IR + program path (SH4 growth).
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): Types.lean NodeKind / IrNode / mkNode? / ofKindTag?;
    IrProgram ordered IR + foldWellTyped + EMPTY-PROGRAM-FAIL-CLOSED;
    CompilePath.programCompileReady; Mult closed grades; KernelMult prior
    Mult fixture; KernelLinear prior Linear rung; self-host.md acceptance;
    product TYPED_IR_V0 / slake_ir_node_* (frozen ABI; no new EMIT_* residual).

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_KERNEL_TYPES_V0 / SELF-HOST-KERNEL-TYPES / HOST-KERNEL-TYPES:
    SH4 ladder growth -- Types / typed IR contracts as real ordered IR plus
    program-path honesty (not a Bool canary alone).
  - lowerTypesKernel: fail-closed build of a 3-node ordered IR program
    (ERASED/MULT-0, LINEAR/MULT-1, VALUE/MULT-OMEGA) via Types.mkNode? +
    IrProgram.push (reuses Types kind/mult pairing; fail-closed unknown kind).
  - typesProgramPathReady: empty program fails programCompileReady /
    isWellTyped (EMPTY-PROGRAM-FAIL-CLOSED); foldWellTyped on lowered IR
    succeeds and counts three nodes; fold on empty is none.
  - typesKernelReady: programCompileReady on lowered IR + typesProgramPathReady
    + gradeSurfaceOk + surface canary + unknown-kind reject.
  - Host model = structural representation of Types / typed IR contracts as
    IR + program fold. Not an AI/ML model. Not product C. Not self-host complete.

  Theorems (KERNEL-TYPES-THEOREM / HOST-KERNEL-TYPES-THEOREM -- partial KernelTypes):
  - typesKernelReady_true / typesKernelOk_true / typesProgramPathReady_true
  - lowerTypesKernel_isSome / unknownKindRejected_true / kindMultMismatchRejected_true
  - programCompileReady_empty_false (sibling EMPTY-PROGRAM)
  - lowerTypesKernel_length_three / lowerTypesKernel_isWellTyped /
    typesKernelProgram_length_three / typesKernelProgram_isWellTyped (content)
  - stageId_eq / kernelTypesId_eq / hostKernelTypesId_eq
  These KernelTypes theorems do NOT set SpecProof.proofCompleteClaimed true.
  Types IR + program path theorems != freestanding product self-host complete.

  Intentional non-claims / partial parity:
  - PARTIAL: Types kernel IR fixture + program-path honesty only; not full
    product C text SSoT for Types; not program/compose/codegen full ladder
    close; not freestanding product self-host complete (SH5 is SelfApply).
  - Mult closed loop remains SH3 (ParityMult); Linear kernel is KernelLinear;
    this module grows the Types rung of SH4 remainder.
  - Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not unlock llvm. Does not grow bash EMIT_* residual treadmill.
  - Product wire bulk still frozen at EMIT_BODY_V0; existing Types ABI only.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_KERNEL_TYPES_V0,
  SELF-HOST-KERNEL-TYPES, HOST-KERNEL-TYPES, SELF-HOST, KERNEL-TYPES-SMOKE,
  TYPED_IR_V0, FAIL-CLOSED-UNKNOWN-KIND, EMPTY-PROGRAM-FAIL-CLOSED,
  ORDERED-IR-PROGRAM, HOST-COMPILE-PATH, foldWellTyped, COMMON-UNIVERSE,
  MULT-0, MULT-1, MULT-OMEGA, VALUE, LINEAR, ERASED, KERNEL-TYPES-THEOREM,
  HOST-KERNEL-TYPES-THEOREM, typesKernelReady_true, typesKernelOk_true,
  lowerTypesKernel_length_three, lowerTypesKernel_isWellTyped,
  typesKernelProgram_length_three, typesKernelProgram_isWellTyped
  UNIT_SURFACE host surface. Module: SystemsLean.KernelTypes
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.IrProgram
import SystemsLean.CompilePath

namespace SystemsLean.KernelTypes

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind)
open SystemsLean.IrProgram (Program)
open SystemsLean.CompilePath (programCompileReady gradeSurfaceOk)

/-- Greppable primary stage id for Types self-host kernel IR (SH4 growth). -/
def stageId : String := "SLAKE_SELF_HOST_KERNEL_TYPES_V0"

/-- Greppable short map id (SELF-HOST-KERNEL-TYPES). -/
def kernelTypesId : String := "SELF-HOST-KERNEL-TYPES"

/-- Greppable host map id (HOST-KERNEL-TYPES). -/
def hostKernelTypesId : String := "HOST-KERNEL-TYPES"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/KernelTypes.lean"

/-- Read-only product Types / typed-IR host cite (frozen wire; no new stage). -/
def productTypedIrId : String := "TYPED_IR_V0"
def productIrNodeApi : String := "slake_ir_node"

/-- Fixed type tags for the three Types kernel nodes (deterministic fixture). -/
def tagErased : Nat := 0
def tagLinear : Nat := 1
def tagValue : Nat := 2

/-- mkTypedNode -- fail-closed typed node (kind/mult pairing via Types.mkNode?). -/
def mkTypedNode (tag : Nat) (m : Mult) (k : NodeKind) : Option IrNode :=
  Types.mkNode? tag m k

/-- pushNode p n? -- push when some well-typed node; none propagates fail-closed. -/
def pushNode (p : Program) (n? : Option IrNode) : Option Program :=
  match n? with
  | none => none
  | some n =>
    match IrProgram.push p n with
    | IrProgram.PushResult.ok p' => some p'
    | _ => none

/-- lowerTypesKernel -- build ordered IR for Types / typed IR contracts
    (SELF-HOST-KERNEL-TYPES). Three nodes: MULT-0 erased, MULT-1 linear,
    MULT-OMEGA value (TYPED_IR_V0 kind/mult pairing).
    FAIL-CLOSED: none if any node or push fails.
    Host structural model of Types contracts as IR -- not product C,
    not an AI model, not freestanding residual free. -/
def lowerTypesKernel : Option Program :=
  let p0 : Program := IrProgram.empty
  let n0 := mkTypedNode tagErased Mult.mult0 NodeKind.erased
  let n1 := mkTypedNode tagLinear Mult.mult1 NodeKind.linear
  let n2 := mkTypedNode tagValue Mult.multOmega NodeKind.value
  match pushNode p0 n0 with
  | none => none
  | some p1 =>
    match pushNode p1 n1 with
    | none => none
    | some p2 => pushNode p2 n2

/-- typesKernelProgram -- Types kernel IR when lower succeeds; empty on fail.
    Prefer typesKernelReady / lowerTypesKernel for fail-closed checks. -/
def typesKernelProgram : Program :=
  match lowerTypesKernel with
  | some p => p
  | none => IrProgram.empty

/-- typesProgramPathReady -- ordered IR program path honesty (SH4 Types growth).
    FAIL-CLOSED checks:
      1) empty program is NOT well-typed / not programCompileReady
         (EMPTY-PROGRAM-FAIL-CLOSED)
      2) foldWellTyped on empty is none
      3) foldWellTyped on lowered Types kernel counts 3 nodes
      4) lowered program is well-typed
    Greppable: typesProgramPathReady, foldWellTyped, EMPTY-PROGRAM-FAIL-CLOSED. -/
def typesProgramPathReady : Bool :=
  let emptyFails :=
    !IrProgram.isWellTyped IrProgram.empty
      && !programCompileReady IrProgram.empty
      && (IrProgram.foldWellTyped IrProgram.empty (0 : Nat) (fun acc _ => acc + 1)).isNone
  match lowerTypesKernel with
  | none => false
  | some p =>
      let foldOk :=
        match IrProgram.foldWellTyped p (0 : Nat) (fun acc _ => acc + 1) with
        | some n => n == 3
        | none => false
      emptyFails
        && IrProgram.isWellTyped p
        && programCompileReady p
        && foldOk

/-- unknownKindRejected -- FAIL-CLOSED-UNKNOWN-KIND on raw kind tag 3. -/
def unknownKindRejected : Bool := !Types.isValidKindTag 3

/-- kindMultMismatchRejected -- kind/mult pairing fails closed. -/
def kindMultMismatchRejected : Bool :=
  (Types.mkNode? 0 Mult.mult1 NodeKind.erased).isNone
    && (Types.mkNode? 0 Mult.mult0 NodeKind.linear).isNone
    && (Types.mkNode? 0 Mult.multOmega NodeKind.linear).isNone
    && (Types.mkNodeFromTags? 0 0 3).isNone
    && (Types.mkNodeFromTags? 0 3 0).isNone

/-- Kernel surface canary: stage ids + path cites + product API names. -/
def typesSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_KERNEL_TYPES_V0")
    && (kernelTypesId == "SELF-HOST-KERNEL-TYPES")
    && (hostKernelTypesId == "HOST-KERNEL-TYPES")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/KernelTypes.lean")
    && (productTypedIrId == "TYPED_IR_V0")
    && (productIrNodeApi == "slake_ir_node")

/-- typesKernelReady -- SH4 Types kernel bar.
    FAIL-CLOSED: lowerTypesKernel succeeds and programCompileReady holds
    (non-empty well-typed ordered IR) and typesProgramPathReady (empty fail
    closed + foldWellTyped) and gradeSurfaceOk and surface canary and
    unknown-kind / kind-mult mismatch rejects.
    Greppable: typesKernelReady, SELF-HOST-KERNEL-TYPES, HOST-KERNEL-TYPES. -/
def typesKernelReady : Bool :=
  match lowerTypesKernel with
  | none => false
  | some p =>
      programCompileReady p
        && typesProgramPathReady
        && gradeSurfaceOk
        && typesSurfaceOk
        && unknownKindRejected
        && kindMultMismatchRejected

/-- Full SH4 Types kernel inventory ok. -/
def typesKernelOk : Bool := typesKernelReady

/-! ### KERNEL-TYPES-THEOREM / HOST-KERNEL-TYPES-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is Types kernel
  readiness, program-path honesty, unknown-kind / kind-mult mismatch reject, and
  empty-program sibling fail-closed only. Does not complete SpecProof; does not
  claim residual free / freestanding product self-host complete / PROVABLY /
  llvm unlock.
-/

/-- Primary stage id is greppable SLAKE_SELF_HOST_KERNEL_TYPES_V0.
    Greppable: stageId_eq, KERNEL-TYPES-THEOREM, HOST-KERNEL-TYPES-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_KERNEL_TYPES_V0" := rfl

/-- Short map id is greppable SELF-HOST-KERNEL-TYPES.
    Greppable: kernelTypesId_eq, KERNEL-TYPES-THEOREM. -/
theorem kernelTypesId_eq : kernelTypesId = "SELF-HOST-KERNEL-TYPES" := rfl

/-- Host map id is greppable HOST-KERNEL-TYPES.
    Greppable: hostKernelTypesId_eq, KERNEL-TYPES-THEOREM,
    HOST-KERNEL-TYPES-THEOREM. -/
theorem hostKernelTypesId_eq : hostKernelTypesId = "HOST-KERNEL-TYPES" := rfl

/-- Types kernel lowers to well-typed ordered IR + program path ready.
    Greppable: typesKernelReady_true, SELF-HOST-KERNEL-TYPES,
    HOST-KERNEL-TYPES, KERNEL-TYPES-THEOREM, HOST-KERNEL-TYPES-THEOREM. -/
theorem typesKernelReady_true : typesKernelReady = true := by decide

/-- Full SH4 Types kernel inventory ok holds.
    Greppable: typesKernelOk_true, KERNEL-TYPES-THEOREM,
    HOST-KERNEL-TYPES-THEOREM. -/
theorem typesKernelOk_true : typesKernelOk = true := by decide

/-- Program path honesty (empty fail-closed + foldWellTyped) holds.
    Greppable: typesProgramPathReady_true, EMPTY-PROGRAM-FAIL-CLOSED,
    KERNEL-TYPES-THEOREM. -/
theorem typesProgramPathReady_true : typesProgramPathReady = true := by decide

/-- lowerTypesKernel succeeds (isSome).
    Greppable: lowerTypesKernel_isSome, KERNEL-TYPES-THEOREM. -/
theorem lowerTypesKernel_isSome : lowerTypesKernel.isSome = true := by decide

/-- FAIL-CLOSED-UNKNOWN-KIND on raw kind tag 3.
    Greppable: unknownKindRejected_true, FAIL-CLOSED-UNKNOWN-KIND,
    KERNEL-TYPES-THEOREM. -/
theorem unknownKindRejected_true : unknownKindRejected = true := by decide

/-- Kind/mult pairing mismatches fail closed.
    Greppable: kindMultMismatchRejected_true, KERNEL-TYPES-THEOREM. -/
theorem kindMultMismatchRejected_true :
    kindMultMismatchRejected = true := by decide

/-- EMPTY-PROGRAM-FAIL-CLOSED sibling: empty program is not program-ready.
    Greppable: programCompileReady_empty_false, EMPTY-PROGRAM-FAIL-CLOSED,
    KERNEL-TYPES-THEOREM, HOST-KERNEL-TYPES-THEOREM. -/
theorem programCompileReady_empty_false :
    programCompileReady IrProgram.empty = false := rfl

/-- lowerTypesKernel yields a length-3 ordered IR program (content equality).
    Greppable: lowerTypesKernel_length_three, KERNEL-TYPES-THEOREM,
    HOST-KERNEL-TYPES-THEOREM. -/
theorem lowerTypesKernel_length_three :
    (match lowerTypesKernel with
     | some p => IrProgram.length p == 3
     | none => false) = true := by decide

/-- lowerTypesKernel yields a well-typed ordered IR program (content equality).
    Greppable: lowerTypesKernel_isWellTyped, KERNEL-TYPES-THEOREM,
    HOST-KERNEL-TYPES-THEOREM. -/
theorem lowerTypesKernel_isWellTyped :
    (match lowerTypesKernel with
     | some p => IrProgram.isWellTyped p
     | none => false) = true := by decide

/-- typesKernelProgram (fallback wrapper) has length 3 when lower succeeds.
    Greppable: typesKernelProgram_length_three, KERNEL-TYPES-THEOREM. -/
theorem typesKernelProgram_length_three :
    IrProgram.length typesKernelProgram = 3 := by decide

/-- typesKernelProgram is well-typed (lower success path content).
    Greppable: typesKernelProgram_isWellTyped, KERNEL-TYPES-THEOREM. -/
theorem typesKernelProgram_isWellTyped :
    IrProgram.isWellTyped typesKernelProgram = true := by decide

/-! ### Types kernel smoke (behavioral; lake build fails if an example does not hold)
    Greppable: KERNEL-TYPES-SMOKE. -/

/-- KERNEL-TYPES-SMOKE: stage / map ids are greppable honesty strings. -/
example : stageId = "SLAKE_SELF_HOST_KERNEL_TYPES_V0" := by decide
example : kernelTypesId = "SELF-HOST-KERNEL-TYPES" := by decide
example : hostKernelTypesId = "HOST-KERNEL-TYPES" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/KernelTypes.lean" := by decide
example : productTypedIrId = "TYPED_IR_V0" := by decide
example : productIrNodeApi = "slake_ir_node" := by decide
example : typesSurfaceOk = true := by decide

/-- KERNEL-TYPES-SMOKE: lowerTypesKernel builds a 3-node well-typed program. -/
example : (lowerTypesKernel.isSome) = true := by decide
example : typesKernelProgram.nodes.length = 3 := by decide
example : IrProgram.isWellTyped typesKernelProgram = true := by decide
example : programCompileReady typesKernelProgram = true := by decide

/-- KERNEL-TYPES-SMOKE: nodes pair kind with mult (TYPED_IR_V0 structural host). -/
example :
    (match typesKernelProgram.nodes with
     | [n0, n1, n2] =>
         n0.mult == Mult.mult0 && n0.kind == NodeKind.erased && n0.isWellTyped
           && n1.mult == Mult.mult1 && n1.kind == NodeKind.linear && n1.isWellTyped
           && n2.mult == Mult.multOmega && n2.kind == NodeKind.value && n2.isWellTyped
     | _ => false) = true := by decide

/-- KERNEL-TYPES-SMOKE: program path honesty (empty fail-closed + fold). -/
example : typesProgramPathReady = true := by decide
example : programCompileReady IrProgram.empty = false := by decide
example : IrProgram.isWellTyped IrProgram.empty = false := by decide
example :
    (IrProgram.foldWellTyped IrProgram.empty (0 : Nat) (fun acc _ => acc + 1)).isNone
      = true := by decide
example :
    (match IrProgram.foldWellTyped typesKernelProgram (0 : Nat)
        (fun acc _ => acc + 1) with
     | some n => n == 3
     | none => false) = true := by decide

/-- KERNEL-TYPES-SMOKE: Types kernel ready and full inventory ok. -/
example : typesKernelReady = true := by decide
example : unknownKindRejected = true := by decide
example : kindMultMismatchRejected = true := by decide
example : typesKernelOk = true := by decide
example : gradeSurfaceOk = true := by decide

/-- KERNEL-TYPES-SMOKE: FAIL-CLOSED-UNKNOWN-KIND / kind-mult mismatch. -/
example : Types.isValidKindTag 0 = true := by decide
example : Types.isValidKindTag 1 = true := by decide
example : Types.isValidKindTag 2 = true := by decide
example : Types.isValidKindTag 3 = false := by decide
example :
    (Types.mkNode? 0 Mult.mult1 NodeKind.erased).isNone = true := by decide
example :
    (Types.mkNodeFromTags? 0 0 3).isNone = true := by decide

end SystemsLean.KernelTypes
