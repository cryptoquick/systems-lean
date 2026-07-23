/-
  SYSTEMS_LEAN_HOST partial -- emit plan readiness inventory on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): extract.md EMIT_PLAN_V0 notes,
    emit slake_emit_plan / slake_emit_plan_from_compose / slake_emit_plan_is_ready
    (frozen wire honesty only).

  Spec (readable, separate from any future proof):
  - Thin EMIT-PLAN host: readiness inventory from a checked HostCompose.
  - Plan fields: nodeCount, edgeCount, runtimeNodes (MULT-1 + MULT-OMEGA),
    erasedNodes (MULT-0), ready, valid.
  - planFromCompose is FAIL-CLOSED: requires HostCompose.checkFailClosed
    (graph well-typed + mult pre-scan only -- not HostCompose.extractOk).
  - On fail: return zeroed plan with ready=false and valid=false (no null wire).
  - On ok: ready=true and valid=true; empty checked compose yields all counts 0.
  - isReady: valid && ready (emit map: slake_emit_plan_is_ready).
  - RUNTIME-FS honesty is compositional: plan does not re-check runtime claim;
    product extract path still uses HostCompose.extractOk / extractOkFs under
    RUNTIME-FS (EMIT-BOUNDARY). Plan readiness implies checkFailClosed only.

  Open hygiene (name clash):
  - Prefer planFromCompose (primary). Greppable alias fromCompose is emit-map
    honesty only. Never open more than one SystemsLean.Emit* namespace at once;
    qualify EmitPlan.planFromCompose / EmitApply.applyFromCompose /
    EmitBody.bodyFromCompose when clients use several modules together.

  Theorems (EMIT-PLAN-THEOREM / HOST-EMIT-PLAN-THEOREM -- partial EmitPlan only):
  - planOk_empty_true / planFromCompose_empty_counts_zero / isReady_empty_plan
  - planOk_eq_isReady_planFromCompose / fromCompose_eq_planFromCompose
  - isReady_failClosed_false / planOk_mult1_unminted_false
  - planFromCompose_mult1_unminted_failClosed (zeroed inventory)
  - planOk_mult1_minted_true / planFromCompose_mult1_minted_runtime
  - planOk_mult0_unmarked_false / planFromCompose_mult0_marked_erased
  - planFromCompose_omega_runtime / planFromCompose_two_values_edge
  - planFromCompose_linear_and_erased (runtime+erased inventory)
  These EmitPlan theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial theorems on EmitPlan != host proof complete != residual free.
  Does not invent a second emit dialect; does not grow product C.

  Intentional non-claims / partial parity:
  - PARTIAL vs full C EMIT_PLAN_V0: host does not model null pointers,
    uint8 wire widths, or exact C return-code tables (codes -1); uses Plan
    with valid/ready Bools instead of out-pointer mutation.
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not product C body emit. Not full CFG/SSA. Not residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator still has managed runtime residual (host != product wire).

  Greppable: SYSTEMS_LEAN_HOST, EMIT-PLAN, EMIT_PLAN_V0, RUNTIME-FS, EMIT-BOUNDARY,
  FAIL-CLOSED, HOST-COMPOSE, MULT-0, MULT-1, MULT-OMEGA, slake_emit_plan,
  planFromCompose, fromCompose, isReady, checkFailClosed,
  EMIT-PLAN-THEOREM, HOST-EMIT-PLAN-THEOREM, planOk_empty_true,
  planFromCompose_empty_counts_zero, isReady_empty_plan,
  planOk_mult1_unminted_false, planOk_mult1_minted_true,
  planFromCompose_two_values_edge, planFromCompose_linear_and_erased
  UNIT_SURFACE host surface. Module: SystemsLean.EmitPlan
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.HostCompose

namespace SystemsLean.EmitPlan

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode)
open SystemsLean.HostCompose (Host)

/-- EMIT-PLAN readiness inventory (emit map: slake_emit_plan).
    PARTIAL vs full C EMIT_PLAN_V0: Nat counts + Bool ready/valid (no null wire). -/
structure Plan where
  nodeCount : Nat
  edgeCount : Nat
  runtimeNodes : Nat
  erasedNodes : Nat
  ready : Bool
  valid : Bool
  deriving DecidableEq, Repr

/-- Fail-closed zeroed plan (emit: on fail set valid=0 and leave fields zeroed). -/
def Plan.failClosed : Plan := {
  nodeCount := 0
  edgeCount := 0
  runtimeNodes := 0
  erasedNodes := 0
  ready := false
  valid := false
}

/-- True when mult survives product wire as a runtime node (MULT-1 or MULT-OMEGA).
    MULT-0 is erased inventory, not runtime. -/
def isRuntimeMult (m : Mult) : Bool :=
  match m with
  | Mult.mult0 => false
  | Mult.mult1 => true
  | Mult.multOmega => true

/-- Count MULT-1 + MULT-OMEGA nodes (runtime survivors on product wire). -/
def countRuntimeNodes (nodes : List IrNode) : Nat :=
  (nodes.filter (fun n => isRuntimeMult n.mult)).length

/-- Count MULT-0 nodes (erased inventory honesty). -/
def countErasedNodes (nodes : List IrNode) : Nat :=
  (nodes.filter (fun n => n.mult == Mult.mult0)).length

/-- planFromCompose hc -- build EMIT-PLAN readiness inventory from HostCompose.
    FAIL-CLOSED: requires HostCompose.checkFailClosed (HOST-COMPOSE path:
    well-typed graph + mult pre-scan). On fail returns Plan.failClosed.
    Empty checked compose: all counts 0, ready=true, valid=true.
    Does not require HostCompose.extractOk / RUNTIME-FS (see planOk).
    Greppable: EMIT-PLAN, FAIL-CLOSED, HOST-COMPOSE, planFromCompose. -/
def planFromCompose (hc : Host) : Plan :=
  if !HostCompose.checkFailClosed hc then
    Plan.failClosed
  else
    let nodes := hc.graph.prog.nodes
    {
      nodeCount := nodes.length
      edgeCount := hc.graph.edges.length
      runtimeNodes := countRuntimeNodes nodes
      erasedNodes := countErasedNodes nodes
      ready := true
      valid := true
    }

/-- Greppable emit-map alias for planFromCompose (slake_emit_plan_from_compose honesty).
    Prefer planFromCompose when opening multiple Emit* modules (open-clash hygiene). -/
def fromCompose (hc : Host) : Plan := planFromCompose hc

/-- isReady p -- true when plan is valid and ready (emit: slake_emit_plan_is_ready).
    FAIL-CLOSED: invalid or not-ready plans reject. -/
def isReady (p : Plan) : Bool :=
  p.valid && p.ready

/-- planOk hc -- planFromCompose + isReady convenience.
    Plan-ready / checkFailClosed inventory path only (not extract-ready).
    Product extract under RUNTIME-FS remains HostCompose.extractOkFs. -/
def planOk (hc : Host) : Bool :=
  isReady (planFromCompose hc)

/-! ### EMIT-PLAN-THEOREM / HOST-EMIT-PLAN-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is empty-compose
  plan readiness, count inventory, fail-closed MULT-1 unminted, minted/marked
  ready counts, edgeCount, and multi-node runtime+erased inventory. Does not
  complete SpecProof; does not claim residual free / freestanding product
  self-host complete / PROVABLY. Does not invent a second emit dialect.
-/

/-- planOk is definitionally isReady (planFromCompose hc).
    Greppable: planOk_eq_isReady_planFromCompose, EMIT-PLAN-THEOREM. -/
theorem planOk_eq_isReady_planFromCompose (hc : Host) :
    planOk hc = isReady (planFromCompose hc) := rfl

/-- fromCompose is definitionally planFromCompose (emit-map alias honesty).
    Greppable: fromCompose_eq_planFromCompose, EMIT-PLAN-THEOREM. -/
theorem fromCompose_eq_planFromCompose (hc : Host) :
    fromCompose hc = planFromCompose hc := rfl

/-- Fail-closed zeroed plan is not ready.
    Greppable: isReady_failClosed_false, FAIL-CLOSED, EMIT-PLAN-THEOREM,
    HOST-EMIT-PLAN-THEOREM. -/
theorem isReady_failClosed_false :
    isReady Plan.failClosed = false := by decide

/-- Empty compose plan is ready (checkFailClosed vacuous path).
    Greppable: planOk_empty_true, EMIT-PLAN-THEOREM, HOST-EMIT-PLAN-THEOREM. -/
theorem planOk_empty_true : planOk HostCompose.empty = true := by decide

/-- Empty compose plan has zero counts and isReady.
    Greppable: planFromCompose_empty_counts_zero, isReady_empty_plan,
    EMIT-PLAN-THEOREM, HOST-EMIT-PLAN-THEOREM. -/
theorem planFromCompose_empty_counts_zero :
    (let p := planFromCompose HostCompose.empty
     p.nodeCount == 0 && p.edgeCount == 0 && p.runtimeNodes == 0
       && p.erasedNodes == 0 && isReady p) = true := by decide

/-- Empty compose plan isReady (alias surface for isReady_empty_plan).
    Greppable: isReady_empty_plan, EMIT-PLAN-THEOREM, HOST-EMIT-PLAN-THEOREM. -/
theorem isReady_empty_plan :
    isReady (planFromCompose HostCompose.empty) = true := by decide

/-! ### Non-empty plan fixtures (theorem surface, not only smoke)
    Concrete hosts so inventory claims reduce without push/mint match escapes. -/

private def thmLinearNode : IrNode :=
  { ty := Types.typeTagInit 1, mult := Mult.mult1, kind := Types.NodeKind.linear }

private def thmErasedNode : IrNode :=
  { ty := Types.typeTagInit 0, mult := Mult.mult0, kind := Types.NodeKind.erased }

private def thmValueNode : IrNode :=
  { ty := Types.typeTagInit 2, mult := Mult.multOmega, kind := Types.NodeKind.value }

/-- One MULT-1 node, unminted linear host (multPreScan fails). -/
private def thmHostMult1Unminted : Host :=
  { HostCompose.empty with
    graph := { prog := { nodes := [thmLinearNode] }, edges := [] } }

/-- One MULT-1 node with live token (mint evidence). -/
private def thmHostMult1Minted : Host :=
  { HostCompose.empty with
    graph := { prog := { nodes := [thmLinearNode] }, edges := [] }
    linear := { live := true, id := 1 } }

/-- One MULT-0 node without erasure mark (multPreScan fails). -/
private def thmHostMult0Unmarked : Host :=
  { HostCompose.empty with
    graph := { prog := { nodes := [thmErasedNode] }, edges := [] } }

/-- One MULT-0 node with markErased (erased inventory path). -/
private def thmHostMult0Marked : Host :=
  HostCompose.markErased
    { HostCompose.empty with
      graph := { prog := { nodes := [thmErasedNode] }, edges := [] } }

/-- One MULT-OMEGA value node (no mint/mark required). -/
private def thmHostOmega : Host :=
  { HostCompose.empty with
    graph := { prog := { nodes := [thmValueNode] }, edges := [] } }

/-- Two MULT-OMEGA nodes with edge 0->1 (edgeCount inventory). -/
private def thmHostTwoValuesEdge : Host :=
  { HostCompose.empty with
    graph := {
      prog := { nodes := [thmValueNode, thmValueNode] }
      edges := [{ fromIdx := 0, toIdx := 1 }]
    } }

/-- MULT-1 (minted) then MULT-0 (marked): runtime=1 erased=1 nodeCount=2. -/
private def thmHostLinearAndErased : Host :=
  HostCompose.markErased
    { HostCompose.empty with
      graph := { prog := { nodes := [thmLinearNode, thmErasedNode] }, edges := [] }
      linear := { live := true, id := 9 } }

/-- MULT-1 without mint fails plan (fail-closed zeroed plan).
    Greppable: planOk_mult1_unminted_false, MULT-1, FAIL-CLOSED, EMIT-PLAN-THEOREM,
    HOST-EMIT-PLAN-THEOREM. -/
theorem planOk_mult1_unminted_false :
    planOk thmHostMult1Unminted = false := by decide

/-- MULT-1 without mint yields zeroed fail-closed plan inventory.
    Greppable: planFromCompose_mult1_unminted_failClosed, FAIL-CLOSED,
    EMIT-PLAN-THEOREM, HOST-EMIT-PLAN-THEOREM. -/
theorem planFromCompose_mult1_unminted_failClosed :
    (let p := planFromCompose thmHostMult1Unminted
     !p.valid && !p.ready && p.nodeCount == 0 && p.edgeCount == 0
       && p.runtimeNodes == 0 && p.erasedNodes == 0) = true := by decide

/-- MULT-1 with mint is plan-ready.
    Greppable: planOk_mult1_minted_true, MULT-1, EMIT-PLAN-THEOREM,
    HOST-EMIT-PLAN-THEOREM. -/
theorem planOk_mult1_minted_true :
    planOk thmHostMult1Minted = true := by decide

/-- MULT-1 with mint: runtimeNodes = 1, erasedNodes = 0, nodeCount = 1.
    Greppable: planFromCompose_mult1_minted_runtime, MULT-1, EMIT-PLAN-THEOREM,
    HOST-EMIT-PLAN-THEOREM. -/
theorem planFromCompose_mult1_minted_runtime :
    (let p := planFromCompose thmHostMult1Minted
     isReady p && p.nodeCount == 1 && p.runtimeNodes == 1
       && p.erasedNodes == 0) = true := by decide

/-- MULT-0 without mark fails plan (fail-closed).
    Greppable: planOk_mult0_unmarked_false, MULT-0, FAIL-CLOSED, EMIT-PLAN-THEOREM,
    HOST-EMIT-PLAN-THEOREM. -/
theorem planOk_mult0_unmarked_false :
    planOk thmHostMult0Unmarked = false := by decide

/-- MULT-0 with mark: erasedNodes = 1, ready.
    Greppable: planFromCompose_mult0_marked_erased, MULT-0, EMIT-PLAN-THEOREM,
    HOST-EMIT-PLAN-THEOREM. -/
theorem planFromCompose_mult0_marked_erased :
    (let p := planFromCompose thmHostMult0Marked
     isReady p && p.nodeCount == 1 && p.runtimeNodes == 0
       && p.erasedNodes == 1) = true := by decide

/-- MULT-OMEGA-only without mint/mark is ready (runtimeNodes = 1).
    Greppable: planFromCompose_omega_runtime, MULT-OMEGA, EMIT-PLAN-THEOREM,
    HOST-EMIT-PLAN-THEOREM. -/
theorem planFromCompose_omega_runtime :
    (let p := planFromCompose thmHostOmega
     isReady p && p.runtimeNodes == 1 && p.erasedNodes == 0) = true := by decide

/-- Two MULT-OMEGA nodes + one edge: edgeCount inventory.
    Greppable: planFromCompose_two_values_edge, EMIT-PLAN-THEOREM,
    HOST-EMIT-PLAN-THEOREM. -/
theorem planFromCompose_two_values_edge :
    (let p := planFromCompose thmHostTwoValuesEdge
     isReady p && p.nodeCount == 2 && p.edgeCount == 1
       && p.runtimeNodes == 2 && p.erasedNodes == 0) = true := by decide

/-- Multi-node runtime+erased inventory (both nonzero; sum == nodeCount).
    Greppable: planFromCompose_linear_and_erased, EMIT-PLAN-THEOREM,
    HOST-EMIT-PLAN-THEOREM. -/
theorem planFromCompose_linear_and_erased :
    (let p := planFromCompose thmHostLinearAndErased
     isReady p && p.nodeCount == 2 && p.runtimeNodes == 1 && p.erasedNodes == 1
       && p.runtimeNodes + p.erasedNodes == p.nodeCount) = true := by decide

/-! ### Emit plan smoke (behavioral; lake build fails if an example does not hold)
    Greppable: EMIT-PLAN-SMOKE. Exercises empty ok, edge count, multi-node, fail-closed. -/

private def smokeLinearNode : IrNode :=
  { ty := Types.typeTagInit 1, mult := Mult.mult1, kind := Types.NodeKind.linear }

private def smokeErasedNode : IrNode :=
  { ty := Types.typeTagInit 0, mult := Mult.mult0, kind := Types.NodeKind.erased }

private def smokeValueNode : IrNode :=
  { ty := Types.typeTagInit 2, mult := Mult.multOmega, kind := Types.NodeKind.value }

private def smokePush (hc : Host) (n : IrNode) : Host :=
  match HostCompose.pushHostNode hc n with
  | HostCompose.HostPushNodeResult.ok hc' => hc'
  | _ => hc

private def smokeMint (hc : Host) (id : Nat) : Host :=
  match HostCompose.mint hc id with
  | HostCompose.MintResult.ok hc' => hc'
  | _ => hc

private def smokeAddEdge (hc : Host) (fromIdx toIdx : Nat) : Host :=
  match HostCompose.addHostEdge hc fromIdx toIdx with
  | HostCompose.HostAddEdgeResult.ok hc' => hc'
  | _ => hc

/-- Two MULT-OMEGA nodes with edge 0->1 (no mint/mark required). -/
private def smokeTwoValuesEdge : Host :=
  smokeAddEdge
    (smokePush (smokePush HostCompose.empty smokeValueNode) smokeValueNode) 0 1

/-- MULT-1 (minted) then MULT-0 (marked): runtime=1 erased=1 nodeCount=2. -/
private def smokeLinearAndErased : Host :=
  HostCompose.markErased
    (smokeMint
      (smokePush (smokePush HostCompose.empty smokeLinearNode) smokeErasedNode) 9)

/-- EMIT-PLAN-SMOKE: empty compose plan is ready with zero counts. -/
example : planOk HostCompose.empty = true := by decide
example :
    (let p := planFromCompose HostCompose.empty
     p.nodeCount == 0 && p.edgeCount == 0 && p.runtimeNodes == 0
       && p.erasedNodes == 0 && isReady p) = true := by decide

/-- EMIT-PLAN-SMOKE: MULT-1 without mint fails check; plan fail-closed. -/
example : planOk (smokePush HostCompose.empty smokeLinearNode) = false := by decide
example :
    (let p := planFromCompose (smokePush HostCompose.empty smokeLinearNode)
     !p.valid && !p.ready && p.nodeCount == 0) = true := by decide

/-- EMIT-PLAN-SMOKE: MULT-1 with mint: runtimeNodes = 1, ready. -/
example :
    (let p := planFromCompose (smokeMint (smokePush HostCompose.empty smokeLinearNode) 7)
     isReady p && p.nodeCount == 1 && p.runtimeNodes == 1 && p.erasedNodes == 0) = true := by
  decide

/-- EMIT-PLAN-SMOKE: MULT-0 with mark: erasedNodes = 1, ready. -/
example :
    (let p := planFromCompose (HostCompose.markErased (smokePush HostCompose.empty smokeErasedNode))
     isReady p && p.nodeCount == 1 && p.runtimeNodes == 0 && p.erasedNodes == 1) = true := by
  decide

/-- EMIT-PLAN-SMOKE: MULT-OMEGA-only without mint/mark is ready (runtimeNodes = 1). -/
example :
    (let p := planFromCompose (smokePush HostCompose.empty smokeValueNode)
     isReady p && p.runtimeNodes == 1 && p.erasedNodes == 0) = true := by decide

/-- EMIT-PLAN-SMOKE: MULT-0 without mark fails plan (fail-closed). -/
example : planOk (smokePush HostCompose.empty smokeErasedNode) = false := by decide

/-- EMIT-PLAN-SMOKE: edgeCount from addHostEdge (two nodes, one edge). -/
example :
    (let p := planFromCompose smokeTwoValuesEdge
     isReady p && p.nodeCount == 2 && p.edgeCount == 1
       && p.runtimeNodes == 2 && p.erasedNodes == 0) = true := by decide

/-- EMIT-PLAN-SMOKE: multi-node runtime+erased inventory (both nonzero). -/
example :
    (let p := planFromCompose smokeLinearAndErased
     isReady p && p.nodeCount == 2 && p.runtimeNodes == 1 && p.erasedNodes == 1
       && p.runtimeNodes + p.erasedNodes == p.nodeCount) = true := by decide

end SystemsLean.EmitPlan
