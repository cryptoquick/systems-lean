/-
  SYSTEMS_LEAN_HOST partial -- ordered IR program / graph-compose self-host
  kernel (SH4 remainder growth).
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): IrProgram.lean ordered IR + foldWellTyped +
    EMPTY-PROGRAM-FAIL-CLOSED; IrGraph.lean Graph + edges + EMPTY-GRAPH-OK;
    HostCompose.lean Host mint/consume/markErased + multPreScan;
    CompilePath.programCompileReady; Mult closed grades; KernelMult /
    KernelLinear / KernelTypes prior SH4 rungs; self-host.md acceptance;
    product IR_PROGRAM_V0 / IR_GRAPH_EDGES_V0 / HOST_COMPOSE_V0 /
    slake_ir_program / slake_ir_graph / slake_host_compose (frozen ABI;
    no new EMIT_* residual C stage).

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_KERNEL_PROGRAM_V0 / SELF-HOST-KERNEL-PROGRAM /
    HOST-KERNEL-PROGRAM: SH4 ladder growth -- ordered IR program + graph
    edges + host compose path as real IR (not a Bool canary alone).
  - lowerProgramKernel: fail-closed build of a 3-node ordered IR program
    (ERASED/MULT-0, LINEAR/MULT-1, VALUE/MULT-OMEGA) via Types.mkNode? +
    IrProgram.push.
  - programPathReady: empty program fails programCompileReady /
    isWellTyped (EMPTY-PROGRAM-FAIL-CLOSED); foldWellTyped on lowered IR
    succeeds and counts three nodes; fold on empty is none; push of a
    fourth well-typed node succeeds (cap honesty).
  - programGraphPathReady: lower into IrGraph with edge 0->1 and 1->2;
    graph isWellTyped; empty graph OK (EMPTY-GRAPH-OK) while empty program
    is not; addEdge on empty program is badEndpoints; out-of-range edge
    rejected.
  - programComposePathReady: HostCompose push of three nodes + two edges;
    MULT-1 needs mint; MULT-0 needs markErased; checkFailClosed /
    extractOkFs OK when both hold; unminted MULT-1 fails closed.
  - programKernelReady: programCompileReady on lowered IR + programPathReady
    + programGraphPathReady + programComposePathReady + gradeSurfaceOk +
    surface canary.
  - Host model = structural representation of ordered program / graph /
    compose contracts as IR. Not an AI/ML model. Not product C. Not
    self-host complete.

  Theorems (KERNEL-PROGRAM-THEOREM / HOST-KERNEL-PROGRAM-THEOREM -- partial
  KernelProgram):
  - programKernelReady_true / programKernelOk_true
  - programPathReady_true / programGraphPathReady_true / programComposePathReady_true
  - lowerProgramKernel_isSome / programCompileReady_empty_false
  - stageId_eq / kernelProgramId_eq / hostKernelProgramId_eq
  - lowerProgramKernel_length_three / lowerProgramKernel_isWellTyped
  - programKernelProgram_length_three / programKernelProgram_isWellTyped
  These KernelProgram theorems do NOT set SpecProof.proofCompleteClaimed true.
  Program / graph / compose content != freestanding product self-host complete.

  Intentional non-claims / partial parity:
  - PARTIAL: program / graph / compose host kernel only; not full product C
    text SSoT for program/graph/compose; freestanding codegen host honesty is
    KernelEmit; not freestanding product self-host complete (SH5 is SelfApply).
  - Mult closed loop remains SH3 (ParityMult); Linear is KernelLinear;
    Types is KernelTypes; this module grows the program/compose rung of SH4.
  - Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not unlock llvm. Does not grow bash EMIT_* residual treadmill.
  - Product wire bulk still frozen at EMIT_BODY_V0; existing program/graph
    /compose ABI cites only.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_KERNEL_PROGRAM_V0,
  SELF-HOST-KERNEL-PROGRAM, HOST-KERNEL-PROGRAM, SELF-HOST,
  KERNEL-PROGRAM-SMOKE, ORDERED-IR-PROGRAM, EMPTY-PROGRAM-FAIL-CLOSED,
  EMPTY-GRAPH-OK, IR-GRAPH-EDGES, HOST-COMPOSE, HOST-COMPILE-PATH,
  foldWellTyped, IR_PROGRAM_V0, IR_GRAPH_EDGES_V0, HOST_COMPOSE_V0,
  SLAKE_IR_PROGRAM_CAP, SLAKE_IR_EDGE_MAX, MULT-0, MULT-1, MULT-OMEGA,
  slake_ir_program, slake_ir_graph, slake_host_compose,
  KERNEL-PROGRAM-THEOREM, HOST-KERNEL-PROGRAM-THEOREM,
  programKernelReady_true, programKernelOk_true,
  lowerProgramKernel_length_three, lowerProgramKernel_isWellTyped,
  programKernelProgram_length_three, programKernelProgram_isWellTyped
  UNIT_SURFACE host surface. Module: SystemsLean.KernelProgram
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.IrProgram
import SystemsLean.IrGraph
import SystemsLean.HostCompose
import SystemsLean.CompilePath

namespace SystemsLean.KernelProgram

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind typeTagInit)
open SystemsLean.IrProgram (Program)
open SystemsLean.IrGraph (Graph Edge)
open SystemsLean.HostCompose (Host LinearHost)
open SystemsLean.CompilePath (programCompileReady gradeSurfaceOk)

/-- Greppable primary stage id for program self-host kernel (SH4 remainder). -/
def stageId : String := "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0"

/-- Greppable short map id (SELF-HOST-KERNEL-PROGRAM). -/
def kernelProgramId : String := "SELF-HOST-KERNEL-PROGRAM"

/-- Greppable host map id (HOST-KERNEL-PROGRAM). -/
def hostKernelProgramId : String := "HOST-KERNEL-PROGRAM"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/KernelProgram.lean"

/-- Read-only product program / graph / compose host cites (frozen wire). -/
def productIrProgramId : String := "IR_PROGRAM_V0"
def productIrGraphId : String := "IR_GRAPH_EDGES_V0"
def productHostComposeId : String := "HOST_COMPOSE_V0"
def productIrProgramApi : String := "slake_ir_program"
def productIrGraphApi : String := "slake_ir_graph"
def productHostComposeApi : String := "slake_host_compose"

/-- Fixed type tags for the three program kernel nodes (deterministic fixture). -/
def tagErased : Nat := 0
def tagLinear : Nat := 1
def tagValue : Nat := 2

/-- Fixed mint id for host-compose path smokes (nonzero; emit id==0 fail). -/
def smokeMintId : Nat := 11

/-- mkProgramNode -- fail-closed typed node (kind/mult pairing via Types.mkNode?). -/
def mkProgramNode (tag : Nat) (m : Mult) (k : NodeKind) : Option IrNode :=
  Types.mkNode? tag m k

/-- pushNode p n? -- push when some well-typed node; none propagates fail-closed. -/
def pushNode (p : Program) (n? : Option IrNode) : Option Program :=
  match n? with
  | none => none
  | some n =>
    match IrProgram.push p n with
    | IrProgram.PushResult.ok p' => some p'
    | _ => none

/-- lowerProgramKernel -- build ordered IR for program path contracts
    (SELF-HOST-KERNEL-PROGRAM). Three nodes: MULT-0 erased, MULT-1 linear,
    MULT-OMEGA value (same kind/mult pairing as Types kernel; this module
    owns program / graph / compose path honesty over that fixture).
    FAIL-CLOSED: none if any node or push fails.
    Host structural model of program contracts as IR -- not product C,
    not an AI model, not freestanding residual free. -/
def lowerProgramKernel : Option Program :=
  let p0 : Program := IrProgram.empty
  let n0 := mkProgramNode tagErased Mult.mult0 NodeKind.erased
  let n1 := mkProgramNode tagLinear Mult.mult1 NodeKind.linear
  let n2 := mkProgramNode tagValue Mult.multOmega NodeKind.value
  match pushNode p0 n0 with
  | none => none
  | some p1 =>
    match pushNode p1 n1 with
    | none => none
    | some p2 => pushNode p2 n2

/-- programKernelProgram -- program kernel IR when lower succeeds; empty on fail.
    Prefer programKernelReady / lowerProgramKernel for fail-closed checks. -/
def programKernelProgram : Program :=
  match lowerProgramKernel with
  | some p => p
  | none => IrProgram.empty

/-- Extra well-typed VALUE node for push-cap honesty smoke. -/
def extraValueNode : IrNode :=
  { ty := typeTagInit 3, mult := Mult.multOmega, kind := NodeKind.value }

/-- programPathReady -- ordered IR program path honesty (SH4 program growth).
    FAIL-CLOSED checks:
      1) empty program is NOT well-typed / not programCompileReady
         (EMPTY-PROGRAM-FAIL-CLOSED)
      2) foldWellTyped on empty is none
      3) foldWellTyped on lowered program counts 3 nodes
      4) lowered program is well-typed / programCompileReady
      5) push of a fourth well-typed node succeeds (cap > 3 honesty)
    Greppable: programPathReady, foldWellTyped, EMPTY-PROGRAM-FAIL-CLOSED. -/
def programPathReady : Bool :=
  let emptyFails :=
    !IrProgram.isWellTyped IrProgram.empty
      && !programCompileReady IrProgram.empty
      && (IrProgram.foldWellTyped IrProgram.empty (0 : Nat) (fun acc _ => acc + 1)).isNone
  match lowerProgramKernel with
  | none => false
  | some p =>
      let foldOk :=
        match IrProgram.foldWellTyped p (0 : Nat) (fun acc _ => acc + 1) with
        | some n => n == 3
        | none => false
      let pushOk :=
        match IrProgram.push p extraValueNode with
        | IrProgram.PushResult.ok p' =>
            IrProgram.length p' == 4 && IrProgram.isWellTyped p'
        | _ => false
      emptyFails
        && IrProgram.isWellTyped p
        && programCompileReady p
        && foldOk
        && pushOk

/-- lowerProgramGraph -- lower program kernel into IrGraph with chain edges
    0->1 and 1->2 (IR-GRAPH-EDGES honesty). FAIL-CLOSED: none if lower or
    addEdge fails. -/
def lowerProgramGraph : Option Graph :=
  match lowerProgramKernel with
  | none => none
  | some p =>
      let g0 : Graph := { prog := p, edges := [] }
      match IrGraph.addEdge g0 0 1 with
      | IrGraph.AddEdgeResult.ok g1 =>
        match IrGraph.addEdge g1 1 2 with
        | IrGraph.AddEdgeResult.ok g2 => some g2
        | _ => none
      | _ => none

/-- programGraphPathReady -- IR graph edges path honesty (SH4 program growth).
    FAIL-CLOSED checks:
      1) empty graph is well-typed (EMPTY-GRAPH-OK)
      2) empty program alone is NOT well-typed (EMPTY-PROGRAM-FAIL-CLOSED)
      3) addEdge on empty program is badEndpoints
      4) lowered graph with two chain edges is well-typed; edge count 2
      5) out-of-range edge on lowered graph is badEndpoints
    Greppable: programGraphPathReady, EMPTY-GRAPH-OK, IR-GRAPH-EDGES. -/
def programGraphPathReady : Bool :=
  let emptyGraphOk := IrGraph.isWellTyped IrGraph.empty
  let emptyProgFails := !IrProgram.isWellTyped IrProgram.empty
  let emptyAddFails :=
    match IrGraph.addEdge IrGraph.empty 0 0 with
    | IrGraph.AddEdgeResult.badEndpoints => true
    | _ => false
  match lowerProgramGraph with
  | none => false
  | some g =>
      let graphOk :=
        IrGraph.isWellTyped g
          && IrGraph.edgeCount g == 2
          && IrGraph.nodeCount g == 3
          && IrProgram.isWellTyped g.prog
      let badEdgeOk :=
        match IrGraph.addEdge g 0 9 with
        | IrGraph.AddEdgeResult.badEndpoints => true
        | _ => false
      emptyGraphOk && emptyProgFails && emptyAddFails && graphOk && badEdgeOk

/-- smoke nodes for HostCompose path (match program kernel tags). -/
def smokeErasedNode : IrNode :=
  { ty := typeTagInit tagErased, mult := Mult.mult0, kind := NodeKind.erased }
def smokeLinearNode : IrNode :=
  { ty := typeTagInit tagLinear, mult := Mult.mult1, kind := NodeKind.linear }
def smokeValueNode : IrNode :=
  { ty := typeTagInit tagValue, mult := Mult.multOmega, kind := NodeKind.value }

/-- pushHost hc n -- push onto compose-owned graph; none on fail. -/
def pushHost (hc : Host) (n : IrNode) : Option Host :=
  match HostCompose.pushHostNode hc n with
  | HostCompose.HostPushNodeResult.ok hc' => some hc'
  | _ => none

/-- addHostEdge hc from to -- add edge; none on fail. -/
def addHostEdge (hc : Host) (fromIdx toIdx : Nat) : Option Host :=
  match HostCompose.addHostEdge hc fromIdx toIdx with
  | HostCompose.HostAddEdgeResult.ok hc' => some hc'
  | _ => none

/-- mintHost hc id -- mint MULT-1 live token; none on badId / alreadyLive. -/
def mintHost (hc : Host) (id : Nat) : Option Host :=
  match HostCompose.mint hc id with
  | HostCompose.MintResult.ok hc' => some hc'
  | _ => none

/-- lowerProgramCompose -- HostCompose with three nodes + chain edges 0->1, 1->2.
    Does not mint/mark (caller applies mult handles). FAIL-CLOSED: none on push
    or edge fail. -/
def lowerProgramCompose : Option Host :=
  match pushHost HostCompose.empty smokeErasedNode with
  | none => none
  | some hc0 =>
    match pushHost hc0 smokeLinearNode with
    | none => none
    | some hc1 =>
      match pushHost hc1 smokeValueNode with
      | none => none
      | some hc2 =>
        match addHostEdge hc2 0 1 with
        | none => none
        | some hc3 => addHostEdge hc3 1 2

/-- programComposePathReady -- HostCompose program/graph path (SH4 host honesty).
    FAIL-CLOSED checks:
      1) unminted/unmarked compose with MULT-0+MULT-1 fails checkFailClosed
      2) markErased + mint makes checkFailClosed / extractOkFs OK
      3) edge count 2 on compose-owned graph
      4) consume after mint clears live (LINEAR-EXACT-ONCE vs remaining MULT-1)
    Greppable: programComposePathReady, HOST-COMPOSE, multPreScan. -/
def programComposePathReady : Bool :=
  match lowerProgramCompose with
  | none => false
  | some hcRaw =>
      let unreadyFails := !HostCompose.checkFailClosed hcRaw
      let hcMarked := HostCompose.markErased hcRaw
      match mintHost hcMarked smokeMintId with
      | none => false
      | some hcReady =>
          let readyOk :=
            HostCompose.checkFailClosed hcReady
              && HostCompose.extractOkFs hcReady
              && hcReady.linear.live
              && hcReady.linear.id == smokeMintId
              && IrGraph.edgeCount hcReady.graph == 2
              && IrGraph.nodeCount hcReady.graph == 3
          let afterConsumeOk :=
            match HostCompose.consume hcReady with
            | HostCompose.ConsumeResult.ok hcSpent payload =>
                !HostCompose.checkFailClosed hcSpent
                  && !hcSpent.linear.live
                  && payload == smokeMintId
            | HostCompose.ConsumeResult.notLive => false
          unreadyFails && readyOk && afterConsumeOk

/-- Kernel surface canary: stage ids + path cites + product API names. -/
def programSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0")
    && (kernelProgramId == "SELF-HOST-KERNEL-PROGRAM")
    && (hostKernelProgramId == "HOST-KERNEL-PROGRAM")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/KernelProgram.lean")
    && (productIrProgramId == "IR_PROGRAM_V0")
    && (productIrGraphId == "IR_GRAPH_EDGES_V0")
    && (productHostComposeId == "HOST_COMPOSE_V0")
    && (productIrProgramApi == "slake_ir_program")
    && (productIrGraphApi == "slake_ir_graph")
    && (productHostComposeApi == "slake_host_compose")

/-- programKernelReady -- SH4 program / compose kernel bar.
    FAIL-CLOSED: lowerProgramKernel succeeds and programCompileReady holds
    (non-empty well-typed ordered IR) and programPathReady (empty fail closed
    + fold + push) and programGraphPathReady (edges + EMPTY-GRAPH-OK) and
    programComposePathReady (HostCompose mult handles + edges) and
    gradeSurfaceOk and surface canary.
    Greppable: programKernelReady, SELF-HOST-KERNEL-PROGRAM, HOST-KERNEL-PROGRAM. -/
def programKernelReady : Bool :=
  match lowerProgramKernel with
  | none => false
  | some p =>
      programCompileReady p
        && programPathReady
        && programGraphPathReady
        && programComposePathReady
        && gradeSurfaceOk
        && programSurfaceOk

/-- Full SH4 program kernel inventory ok. -/
def programKernelOk : Bool := programKernelReady

/-! ### KERNEL-PROGRAM-THEOREM / HOST-KERNEL-PROGRAM-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is program /
  graph / compose kernel readiness and empty-program sibling fail-closed only.
  Does not complete SpecProof; does not claim residual free / freestanding
  product self-host complete / PROVABLY / llvm unlock.
-/

/-- Primary stage id is greppable SLAKE_SELF_HOST_KERNEL_PROGRAM_V0.
    Greppable: stageId_eq, KERNEL-PROGRAM-THEOREM, HOST-KERNEL-PROGRAM-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0" := rfl

/-- Short map id is greppable SELF-HOST-KERNEL-PROGRAM.
    Greppable: kernelProgramId_eq, KERNEL-PROGRAM-THEOREM. -/
theorem kernelProgramId_eq : kernelProgramId = "SELF-HOST-KERNEL-PROGRAM" := rfl

/-- Host map id is greppable HOST-KERNEL-PROGRAM.
    Greppable: hostKernelProgramId_eq, KERNEL-PROGRAM-THEOREM,
    HOST-KERNEL-PROGRAM-THEOREM. -/
theorem hostKernelProgramId_eq : hostKernelProgramId = "HOST-KERNEL-PROGRAM" := rfl

/-- Program kernel lowers to well-typed ordered IR + graph + compose ready.
    Greppable: programKernelReady_true, SELF-HOST-KERNEL-PROGRAM,
    HOST-KERNEL-PROGRAM, KERNEL-PROGRAM-THEOREM, HOST-KERNEL-PROGRAM-THEOREM. -/
theorem programKernelReady_true : programKernelReady = true := by decide

/-- Full SH4 program kernel inventory ok holds.
    Greppable: programKernelOk_true, KERNEL-PROGRAM-THEOREM,
    HOST-KERNEL-PROGRAM-THEOREM. -/
theorem programKernelOk_true : programKernelOk = true := by decide

/-- Ordered IR program path honesty holds.
    Greppable: programPathReady_true, EMPTY-PROGRAM-FAIL-CLOSED,
    KERNEL-PROGRAM-THEOREM. -/
theorem programPathReady_true : programPathReady = true := by decide

/-- Graph path honesty (edges + EMPTY-GRAPH-OK) holds.
    Greppable: programGraphPathReady_true, EMPTY-GRAPH-OK,
    KERNEL-PROGRAM-THEOREM. -/
theorem programGraphPathReady_true : programGraphPathReady = true := by decide

/-- HostCompose mult handles + edges path honesty holds.
    Greppable: programComposePathReady_true, HOST-COMPOSE,
    KERNEL-PROGRAM-THEOREM. -/
theorem programComposePathReady_true : programComposePathReady = true := by decide

/-- lowerProgramKernel succeeds (isSome).
    Greppable: lowerProgramKernel_isSome, KERNEL-PROGRAM-THEOREM. -/
theorem lowerProgramKernel_isSome : lowerProgramKernel.isSome = true := by decide

/-- EMPTY-PROGRAM-FAIL-CLOSED sibling: empty program is not program-ready.
    Greppable: programCompileReady_empty_false, EMPTY-PROGRAM-FAIL-CLOSED,
    KERNEL-PROGRAM-THEOREM, HOST-KERNEL-PROGRAM-THEOREM. -/
theorem programCompileReady_empty_false :
    programCompileReady IrProgram.empty = false := rfl

/-- lowerProgramKernel yields a length-3 ordered IR program (content equality).
    Greppable: lowerProgramKernel_length_three, KERNEL-PROGRAM-THEOREM,
    HOST-KERNEL-PROGRAM-THEOREM. -/
theorem lowerProgramKernel_length_three :
    (match lowerProgramKernel with
     | some p => IrProgram.length p == 3
     | none => false) = true := by decide

/-- lowerProgramKernel yields a well-typed ordered IR program (content equality).
    Greppable: lowerProgramKernel_isWellTyped, KERNEL-PROGRAM-THEOREM,
    HOST-KERNEL-PROGRAM-THEOREM. -/
theorem lowerProgramKernel_isWellTyped :
    (match lowerProgramKernel with
     | some p => IrProgram.isWellTyped p
     | none => false) = true := by decide

/-- programKernelProgram (fallback wrapper) has length 3 when lower succeeds.
    Greppable: programKernelProgram_length_three, KERNEL-PROGRAM-THEOREM. -/
theorem programKernelProgram_length_three :
    IrProgram.length programKernelProgram = 3 := by decide

/-- programKernelProgram is well-typed (lower success path content).
    Greppable: programKernelProgram_isWellTyped, KERNEL-PROGRAM-THEOREM. -/
theorem programKernelProgram_isWellTyped :
    IrProgram.isWellTyped programKernelProgram = true := by decide

/-! ### Program kernel smoke (behavioral; lake build fails if an example does not hold)
    Greppable: KERNEL-PROGRAM-SMOKE. -/

/-- KERNEL-PROGRAM-SMOKE: stage / map ids are greppable honesty strings. -/
example : stageId = "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0" := by decide
example : kernelProgramId = "SELF-HOST-KERNEL-PROGRAM" := by decide
example : hostKernelProgramId = "HOST-KERNEL-PROGRAM" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/KernelProgram.lean" := by decide
example : productIrProgramId = "IR_PROGRAM_V0" := by decide
example : productIrGraphId = "IR_GRAPH_EDGES_V0" := by decide
example : productHostComposeId = "HOST_COMPOSE_V0" := by decide
example : productIrProgramApi = "slake_ir_program" := by decide
example : productIrGraphApi = "slake_ir_graph" := by decide
example : productHostComposeApi = "slake_host_compose" := by decide
example : programSurfaceOk = true := by decide

/-- KERNEL-PROGRAM-SMOKE: lowerProgramKernel builds a 3-node well-typed program. -/
example : (lowerProgramKernel.isSome) = true := by decide
example : programKernelProgram.nodes.length = 3 := by decide
example : IrProgram.isWellTyped programKernelProgram = true := by decide
example : programCompileReady programKernelProgram = true := by decide

/-- KERNEL-PROGRAM-SMOKE: nodes pair kind with mult. -/
example :
    (match programKernelProgram.nodes with
     | [n0, n1, n2] =>
         n0.mult == Mult.mult0 && n0.kind == NodeKind.erased && n0.isWellTyped
           && n1.mult == Mult.mult1 && n1.kind == NodeKind.linear && n1.isWellTyped
           && n2.mult == Mult.multOmega && n2.kind == NodeKind.value && n2.isWellTyped
     | _ => false) = true := by decide

/-- KERNEL-PROGRAM-SMOKE: program path honesty (empty fail-closed + fold + push). -/
example : programPathReady = true := by decide
example : programCompileReady IrProgram.empty = false := by decide
example : IrProgram.isWellTyped IrProgram.empty = false := by decide
example :
    (IrProgram.foldWellTyped IrProgram.empty (0 : Nat) (fun acc _ => acc + 1)).isNone
      = true := by decide
example :
    (match IrProgram.foldWellTyped programKernelProgram (0 : Nat)
        (fun acc _ => acc + 1) with
     | some n => n == 3
     | none => false) = true := by decide

/-- KERNEL-PROGRAM-SMOKE: graph path honesty (edges + EMPTY-GRAPH-OK). -/
example : programGraphPathReady = true := by decide
example : IrGraph.isWellTyped IrGraph.empty = true := by decide
example : (lowerProgramGraph.isSome) = true := by decide
example :
    (match lowerProgramGraph with
     | some g => IrGraph.edgeCount g == 2 && IrGraph.nodeCount g == 3
     | none => false) = true := by decide

/-- KERNEL-PROGRAM-SMOKE: HostCompose path honesty. -/
example : programComposePathReady = true := by decide
example : LinearHost.empty.live = false := by decide

/-- KERNEL-PROGRAM-SMOKE: program kernel ready and full inventory ok. -/
example : programKernelReady = true := by decide
example : programKernelOk = true := by decide
example : gradeSurfaceOk = true := by decide

/-- KERNEL-PROGRAM-SMOKE: capacity honesty cites. -/
example : IrProgram.programCap = 8 := by decide
example : IrGraph.edgeMax = 16 := by decide

end SystemsLean.KernelProgram
