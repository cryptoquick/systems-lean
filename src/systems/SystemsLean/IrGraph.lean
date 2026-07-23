/-
  SYSTEMS_LEAN_HOST partial -- IR graph edges over ordered IR program on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): Types.slake / types.md IR_GRAPH_EDGES_V0 notes,
    emit slake_ir_graph_* (frozen wire honesty only; SLAKE_IR_EDGE_MAX = 16).
  Shared core map: doc/shared-ir-sketch.md.

  Spec (readable, separate from any future proof):
  - Directed edge slots honesty over an ordered IR program (index pairs into nodes).
  - Capacity honesty: edgeMax = 16 matching emit SLAKE_IR_EDGE_MAX.
  - Graph embeds ordered program + edge list under edgeMax.
  - EMPTY-GRAPH-OK: empty graph (no nodes, no edges) is well-typed at graph surface
    (matches emit slake_ir_graph_is_well_typed; nested empty program alone stays
    EMPTY-PROGRAM-FAIL-CLOSED under IrProgram).
  - addEdge fail closed: full edges, endpoints out of range (not < node count).
  - pushNode call-through to IrProgram.push (same badNode / full codes).
  - isWellTyped: empty OK; else program well-typed, edge count <= edgeMax, and every
    live edge endpoint in range (capacity upper bound checked, not only at push).
  - Not a full control-flow graph. Not dominance / SSA.

  Theorems (IR-GRAPH-THEOREM / HOST-IR-GRAPH-THEOREM -- partial IrGraph only):
  - isWellTyped_empty_true / empty_well_typed: EMPTY-GRAPH-OK core.
  - checkFailClosed_eq_isWellTyped: checkFailClosed is isWellTyped.
  - empty_isEmpty / edgeMax_eq_sixteen: empty facts + capacity honesty.
  - addEdge_empty_badEndpoints: no valid endpoints on empty program.
  - edgesSound_empty: empty edge list is sound for any node count.
  - isWellTyped_one_node_empty_edges: one well-typed node, no edges is OK.
  - pushNode_value_one_ok: push well-typed VALUE on empty yields one-node graph.
  - addEdge_one_node_self_ok: self-edge 0->0 on one-node graph succeeds.
  - addEdge_one_node_badEndpoints: endpoint out of range fails closed.
  - edgesSound_one_edge / isWellTyped_two_nodes_one_edge / addEdge_two_nodes_ok:
    multi-node single-edge (0->1) soundness + success.
  - edgesSound_two_edges / isWellTyped_two_nodes_two_edges / addEdge_two_nodes_second_ok:
    multi-node two-edge (0->1, 1->0) soundness + second addEdge success.
  - addEdge_two_nodes_badEndpoints: out-of-range after multi-node fails closed.
  - edgesSound_oversize_false: edge list past edgeMax fails closed.
  Nested IrProgram.empty stays EMPTY-PROGRAM-FAIL-CLOSED (do not claim empty
  program is well-typed as a program).
  These IrGraph theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial theorems on IrGraph != host proof complete != residual free.

  Intentional non-claims:
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Not full IR_GRAPH_EDGES_V0 C reimplementation. Not residual free.
  - Nested empty ordered program alone is still EMPTY-PROGRAM-FAIL-CLOSED.

  Greppable: SYSTEMS_LEAN_HOST, IR_GRAPH_EDGES_V0, IR-GRAPH-EDGES, SLAKE_IR_EDGE_MAX,
  EMPTY-GRAPH-OK, FAIL-CLOSED, ORDERED-IR-PROGRAM, MULT-0, MULT-1, MULT-OMEGA,
  slake_ir_graph, IR-GRAPH-THEOREM, HOST-IR-GRAPH-THEOREM, isWellTyped_empty_true,
  empty_well_typed, checkFailClosed_eq_isWellTyped, empty_isEmpty,
  edgeMax_eq_sixteen, addEdge_empty_badEndpoints, edgesSound_empty,
  isWellTyped_one_node_empty_edges, pushNode_value_one_ok,
  addEdge_one_node_self_ok, addEdge_one_node_badEndpoints,
  edgesSound_one_edge, isWellTyped_two_nodes_one_edge, addEdge_two_nodes_ok,
  edgesSound_two_edges, isWellTyped_two_nodes_two_edges, addEdge_two_nodes_second_ok,
  addEdge_two_nodes_badEndpoints, edgesSound_oversize_false
  UNIT_SURFACE host surface. Module: SystemsLean.IrGraph
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.IrProgram

namespace SystemsLean.IrGraph

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind)
open SystemsLean.IrProgram (Program)

/-- Fixed edge capacity matching emit SLAKE_IR_EDGE_MAX (honesty map). -/
def edgeMax : Nat := 16

/-- Directed edge: index pair into ordered IR program nodes.
    Emit map: slake_ir_edge (from, to). -/
structure Edge where
  fromIdx : Nat
  toIdx : Nat
  deriving DecidableEq, Repr

/-- IR graph: ordered program plus edge list under edgeMax.
    IR-GRAPH-EDGES host surface. Emit map: slake_ir_graph. -/
structure Graph where
  prog : Program
  edges : List Edge
  deriving DecidableEq, Repr

/-- Empty graph (EMPTY-GRAPH-OK: well-typed at graph surface). -/
def empty : Graph := { prog := IrProgram.empty, edges := [] }

/-- Live edge count. -/
def edgeCount (g : Graph) : Nat := g.edges.length

/-- Live node count (call-through program length). -/
def nodeCount (g : Graph) : Nat := IrProgram.length g.prog

/-- True when no nodes and no edges. -/
def isEmpty (g : Graph) : Bool :=
  IrProgram.isEmpty g.prog && g.edges.isEmpty

/-- Result of pushNode: ok with new graph, bad node, or full program capacity.
    Emit map: 0 ok; -1 null/bad; -2 full (via program push). -/
inductive PushNodeResult where
  | ok (g : Graph)
  | badNode
  | full
  deriving DecidableEq, Repr

/-- Result of addEdge: ok, full capacity, or bad endpoints (out of range).
    Emit map: 0 ok; -1 full / out of range / invalid. -/
inductive AddEdgeResult where
  | ok (g : Graph)
  | full
  | badEndpoints
  deriving DecidableEq, Repr

/-- edgeEndpointsOk e nCount -- true when both endpoints are in range.
    Fail closed: fromIdx / toIdx must be < nCount (emit add_edge contract). -/
def edgeEndpointsOk (e : Edge) (nCount : Nat) : Bool :=
  decide (e.fromIdx < nCount) && decide (e.toIdx < nCount)

/-- edgesSound edges nCount -- every edge in range and list under edgeMax.
    Capacity upper bound is part of soundness (not only enforced at addEdge). -/
def edgesSound (edges : List Edge) (nCount : Nat) : Bool :=
  decide (edges.length <= edgeMax)
    && edges.all (fun e => edgeEndpointsOk e nCount)

/-- addEdge g fromIdx toIdx -- append a directed edge under edgeMax.
    FAIL-CLOSED: full when at SLAKE_IR_EDGE_MAX; badEndpoints when index out of
    range (including empty program -- no valid endpoint). Failed add leaves g
    unchanged (caller keeps g). -/
def addEdge (g : Graph) (fromIdx toIdx : Nat) : AddEdgeResult :=
  if g.edges.length >= edgeMax then
    AddEdgeResult.full
  else if !(edgeEndpointsOk { fromIdx := fromIdx, toIdx := toIdx }
      (IrProgram.length g.prog)) then
    AddEdgeResult.badEndpoints
  else
    AddEdgeResult.ok {
      prog := g.prog
      edges := g.edges ++ [{ fromIdx := fromIdx, toIdx := toIdx }]
    }

/-- pushNode g n -- append a well-typed node via IrProgram.push.
    FAIL-CLOSED: same badNode / full as ordered IR program push.
    Edges are left unchanged (new node index is old length on success). -/
def pushNode (g : Graph) (n : IrNode) : PushNodeResult :=
  match IrProgram.push g.prog n with
  | IrProgram.PushResult.ok p => PushNodeResult.ok { g with prog := p }
  | IrProgram.PushResult.badNode => PushNodeResult.badNode
  | IrProgram.PushResult.full => PushNodeResult.full

/-- isWellTyped g -- EMPTY-GRAPH-OK when empty; else program well-typed and edges
    sound (count <= SLAKE_IR_EDGE_MAX and endpoints in range).
    Non-empty edges with empty program fail closed.
    Oversize edge lists fail closed even if addEdge already caps. -/
def isWellTyped (g : Graph) : Bool :=
  if isEmpty g then
    true
  else if IrProgram.isEmpty g.prog then
    false
  else
    IrProgram.isWellTyped g.prog
      && edgesSound g.edges (IrProgram.length g.prog)

/-- Fail-closed graph check (host V0): same bar as isWellTyped.
    Empty valid graph OK (EMPTY-GRAPH-OK). Emit path adds mult/token pre-scan at
    program or host-compose layers; this module is graph surface only. -/
def checkFailClosed (g : Graph) : Bool := isWellTyped g

/-! ### IR-GRAPH-THEOREM / HOST-IR-GRAPH-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is EMPTY-GRAPH-OK
  and cheap edge/capacity contracts only. Does not complete SpecProof; does not
  claim residual free / freestanding product self-host complete / PROVABLY.
  Nested IrProgram.empty remains EMPTY-PROGRAM-FAIL-CLOSED (not re-proved here).
-/

/-- EMPTY-GRAPH-OK core: empty graph is well-typed at graph surface.
    Greppable: isWellTyped_empty_true, EMPTY-GRAPH-OK, IR-GRAPH-THEOREM,
    HOST-IR-GRAPH-THEOREM. -/
theorem isWellTyped_empty_true : isWellTyped empty = true := rfl

/-- Alias of isWellTyped_empty_true (readable EMPTY-GRAPH-OK name).
    Greppable: empty_well_typed, EMPTY-GRAPH-OK, IR-GRAPH-THEOREM. -/
theorem empty_well_typed : isWellTyped empty = true := isWellTyped_empty_true

/-- checkFailClosed is definitionally isWellTyped.
    Greppable: checkFailClosed_eq_isWellTyped, IR-GRAPH-THEOREM. -/
theorem checkFailClosed_eq_isWellTyped (g : Graph) :
    checkFailClosed g = isWellTyped g := rfl

/-- Empty graph has no nodes and no edges.
    Greppable: empty_isEmpty, IR-GRAPH-THEOREM. -/
theorem empty_isEmpty : isEmpty empty = true := rfl

/-- Capacity honesty: edgeMax matches emit SLAKE_IR_EDGE_MAX.
    Greppable: edgeMax_eq_sixteen, SLAKE_IR_EDGE_MAX, IR-GRAPH-THEOREM. -/
theorem edgeMax_eq_sixteen : edgeMax = 16 := rfl

/-- addEdge on empty program fails closed (no valid endpoints).
    Greppable: addEdge_empty_badEndpoints, FAIL-CLOSED, IR-GRAPH-THEOREM,
    HOST-IR-GRAPH-THEOREM. -/
theorem addEdge_empty_badEndpoints (fromIdx toIdx : Nat) :
    addEdge empty fromIdx toIdx = AddEdgeResult.badEndpoints := by
  -- empty: not at edgeMax (Prop if); program length 0 so endpoints fail (Bool if).
  unfold addEdge
  rw [if_neg (by decide : Not (empty.edges.length >= edgeMax))]
  have hends :
      edgeEndpointsOk { fromIdx := fromIdx, toIdx := toIdx }
        (IrProgram.length empty.prog) = false := by
    simp [edgeEndpointsOk, empty, IrProgram.empty, IrProgram.length]
  simp [hends]

/-! ### edgesSound / single-node program-only graph (beyond EMPTY-GRAPH-OK) -/

private def thmValueNode : IrNode :=
  { ty := { tag := 1 }, mult := Mult.multOmega, kind := Types.NodeKind.value }

/-- Empty edge list is sound for any node count (vacuous endpoints + under cap).
    Greppable: edgesSound_empty, IR-GRAPH-THEOREM, HOST-IR-GRAPH-THEOREM. -/
theorem edgesSound_empty (nCount : Nat) : edgesSound [] nCount = true := rfl

/-- One well-typed VALUE node with empty edges is a well-typed graph
    (program-only; EMPTY-GRAPH-OK is the zero-node case).
    Greppable: isWellTyped_one_node_empty_edges, IR-GRAPH-THEOREM,
    HOST-IR-GRAPH-THEOREM. -/
theorem isWellTyped_one_node_empty_edges :
    isWellTyped {
      prog := { nodes := [thmValueNode] }
      edges := []
    } = true := rfl

/-! ### pushNode / addEdge success + fail-closed (beyond EMPTY-GRAPH-OK) -/

/-- One-node graph fixture (hand-built; no push match escape). -/
private def thmOneNode : Graph := {
  prog := { nodes := [thmValueNode] }
  edges := []
}

/-- pushNode empty with a well-typed VALUE node yields a one-node empty-edge graph.
    Greppable: pushNode_value_one_ok, IR-GRAPH-THEOREM, HOST-IR-GRAPH-THEOREM. -/
theorem pushNode_value_one_ok :
    pushNode empty thmValueNode = PushNodeResult.ok thmOneNode := rfl

/-- addEdge self-loop 0->0 on one-node graph succeeds.
    Greppable: addEdge_one_node_self_ok, IR-GRAPH-THEOREM, HOST-IR-GRAPH-THEOREM. -/
theorem addEdge_one_node_self_ok :
    addEdge thmOneNode 0 0 =
      AddEdgeResult.ok {
        prog := thmOneNode.prog
        edges := [{ fromIdx := 0, toIdx := 0 }]
      } := rfl

/-- addEdge out-of-range endpoint on one-node graph fails closed.
    Greppable: addEdge_one_node_badEndpoints, FAIL-CLOSED, IR-GRAPH-THEOREM,
    HOST-IR-GRAPH-THEOREM. -/
theorem addEdge_one_node_badEndpoints :
    addEdge thmOneNode 0 1 = AddEdgeResult.badEndpoints := by
  unfold addEdge
  rw [if_neg (by decide : Not (thmOneNode.edges.length >= edgeMax))]
  have hends :
      edgeEndpointsOk { fromIdx := 0, toIdx := 1 }
        (IrProgram.length thmOneNode.prog) = false := by
    simp [edgeEndpointsOk, thmOneNode, IrProgram.length]
  simp [hends]

/-! ### Multi-node edge contracts (one-edge then two-edge; beyond one-node self-edge) -/

private def thmValueNodeB : IrNode :=
  { ty := { tag := 2 }, mult := Mult.multOmega, kind := Types.NodeKind.value }

private def thmTwoNodes : Graph := {
  prog := { nodes := [thmValueNode, thmValueNodeB] }
  edges := []
}

private def thmTwoNodesOneEdge : Graph := {
  prog := { nodes := [thmValueNode, thmValueNodeB] }
  edges := [{ fromIdx := 0, toIdx := 1 }]
}

private def thmTwoNodesTwoEdges : Graph := {
  prog := { nodes := [thmValueNode, thmValueNodeB] }
  edges := [{ fromIdx := 0, toIdx := 1 }, { fromIdx := 1, toIdx := 0 }]
}

/-- One directed edge 0->1 is sound for a two-node program.
    Greppable: edgesSound_one_edge, IR-GRAPH-THEOREM, HOST-IR-GRAPH-THEOREM. -/
theorem edgesSound_one_edge :
    edgesSound [{ fromIdx := 0, toIdx := 1 }] 2 = true := rfl

/-- Two well-typed nodes with one in-range edge is a well-typed graph.
    Greppable: isWellTyped_two_nodes_one_edge, IR-GRAPH-THEOREM,
    HOST-IR-GRAPH-THEOREM. -/
theorem isWellTyped_two_nodes_one_edge :
    isWellTyped thmTwoNodesOneEdge = true := rfl

/-- addEdge 0->1 on a two-node empty-edge graph succeeds.
    Greppable: addEdge_two_nodes_ok, IR-GRAPH-THEOREM, HOST-IR-GRAPH-THEOREM. -/
theorem addEdge_two_nodes_ok :
    addEdge thmTwoNodes 0 1 = AddEdgeResult.ok thmTwoNodesOneEdge := rfl

/-- Two directed edges 0->1 and 1->0 are sound for a two-node program.
    Greppable: edgesSound_two_edges, IR-GRAPH-THEOREM, HOST-IR-GRAPH-THEOREM. -/
theorem edgesSound_two_edges :
    edgesSound
      [{ fromIdx := 0, toIdx := 1 }, { fromIdx := 1, toIdx := 0 }] 2 = true := rfl

/-- Two well-typed nodes with two in-range edges is a well-typed graph.
    Greppable: isWellTyped_two_nodes_two_edges, IR-GRAPH-THEOREM,
    HOST-IR-GRAPH-THEOREM. -/
theorem isWellTyped_two_nodes_two_edges :
    isWellTyped thmTwoNodesTwoEdges = true := rfl

/-- addEdge second edge 1->0 on a one-edge two-node graph succeeds.
    Greppable: addEdge_two_nodes_second_ok, IR-GRAPH-THEOREM, HOST-IR-GRAPH-THEOREM. -/
theorem addEdge_two_nodes_second_ok :
    addEdge thmTwoNodesOneEdge 1 0 = AddEdgeResult.ok thmTwoNodesTwoEdges := rfl

/-- addEdge out-of-range on two-node graph fails closed.
    Greppable: addEdge_two_nodes_badEndpoints, FAIL-CLOSED, IR-GRAPH-THEOREM,
    HOST-IR-GRAPH-THEOREM. -/
theorem addEdge_two_nodes_badEndpoints :
    addEdge thmTwoNodes 0 2 = AddEdgeResult.badEndpoints := by
  unfold addEdge
  rw [if_neg (by decide : Not (thmTwoNodes.edges.length >= edgeMax))]
  have hends :
      edgeEndpointsOk { fromIdx := 0, toIdx := 2 }
        (IrProgram.length thmTwoNodes.prog) = false := by
    simp [edgeEndpointsOk, thmTwoNodes, IrProgram.length]
  simp [hends]

/-- Edge list longer than edgeMax fails edgesSound (capacity upper bound).
    Greppable: edgesSound_oversize_false, SLAKE_IR_EDGE_MAX, IR-GRAPH-THEOREM,
    HOST-IR-GRAPH-THEOREM. -/
theorem edgesSound_oversize_false :
    edgesSound
      (List.replicate (edgeMax + 1) { fromIdx := 0, toIdx := 0 }) 2 = false := by
  decide

/-! ### Graph smoke (behavioral; lake build fails if an example does not hold)
    Greppable: IR-GRAPH-SMOKE. EMPTY-GRAPH-OK, edgeMax, full, badEndpoints, edgesSound. -/

private def smokeValueNode : IrNode :=
  { ty := { tag := 9 }, mult := Mult.multOmega, kind := Types.NodeKind.value }

private def smokePush (g : Graph) (n : IrNode) : Graph :=
  match pushNode g n with
  | PushNodeResult.ok g' => g'
  | _ => g

private def smokeTwoNodes : Graph :=
  smokePush (smokePush empty smokeValueNode) smokeValueNode

/-- Fill g with n edges 0->1 (requires at least two nodes). -/
private def smokeFillEdges (g : Graph) : Nat -> Graph
  | 0 => g
  | n + 1 =>
    match addEdge (smokeFillEdges g n) 0 1 with
    | AddEdgeResult.ok g' => g'
    | _ => g

/-- IR-GRAPH-SMOKE: empty graph well-typed (EMPTY-GRAPH-OK). -/
example : isWellTyped empty = true := by decide
example : checkFailClosed empty = true := by decide

/-- IR-GRAPH-SMOKE: edgeMax is 16 (SLAKE_IR_EDGE_MAX honesty). -/
example : edgeMax = 16 := by decide

/-- IR-GRAPH-SMOKE: addEdge on empty program is badEndpoints. -/
example :
    (match addEdge empty 0 0 with
     | AddEdgeResult.badEndpoints => true
     | _ => false) = true := by decide

/-- IR-GRAPH-SMOKE: two nodes, edge 0->1 ok; edge out of range badEndpoints. -/
example :
    (match addEdge smokeTwoNodes 0 1 with
     | AddEdgeResult.ok _ => true
     | _ => false) = true := by decide
example :
    (match addEdge smokeTwoNodes 0 2 with
     | AddEdgeResult.badEndpoints => true
     | _ => false) = true := by decide

/-- IR-GRAPH-SMOKE: 16 edges ok; 17th is full. -/
example : edgeCount (smokeFillEdges smokeTwoNodes 16) = 16 := by decide
example :
    (match addEdge (smokeFillEdges smokeTwoNodes 16) 0 1 with
     | AddEdgeResult.full => true
     | _ => false) = true := by decide

/-- IR-GRAPH-SMOKE: oversize edge list (edgeMax+1) fails isWellTyped via edgesSound
    even when a structure literal bypasses addEdge (capacity upper bound not only
    at push). Greppable: edgesSound. -/
example :
    (let over : Graph := {
        prog := smokeTwoNodes.prog
        edges := List.replicate (edgeMax + 1) { fromIdx := 0, toIdx := 0 }
      }
     !isWellTyped over && !edgesSound over.edges (IrProgram.length over.prog)) = true := by
  decide

end SystemsLean.IrGraph
