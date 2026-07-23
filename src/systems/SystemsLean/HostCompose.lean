/-
  SYSTEMS_LEAN_HOST partial -- host compose (graph + linear host + erasure) on Systems Lean host.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): Extract.slake / extract.md HOST_COMPOSE_V0 notes,
    Linear.slake / linear.md host side, Types.slake graph side,
    emit slake_host_compose_* (frozen wire honesty only).

  Spec (readable, separate from any future proof):
  - Thin host compose: owns IR graph + linear host handle (ConsumeToken-class
    live flag honesty) + erasure mark + extract path honesty.
  - HOST-COMPOSE surface: mint / consume / markErased / pushHostNode / addHostEdge
    fail-closed helpers; checkFailClosed mult pre-scan then graph bar.
    Compose names are distinct from IrGraph.pushNode / addEdge (no open clash).
  - MULT-1 live-token gap closed here (relative to Extract partial path):
      any MULT-1 node in the owned graph requires hc.linear.live;
      any MULT-0 node requires marked erased (ERASE-NO-RUNTIME);
      MULT-OMEGA nodes need neither handle.
  - Empty well-typed compose (no nodes) check/extract OK (matches emit).
  - extractOk requires RUNTIME-FS claim (EMIT-BOUNDARY); classic / edge reject.
  - Linear host here is a concrete live-flag model for fail-closed checks.
    SystemsLean.Linear axioms remain the JOIN-ALG ConsumeToken dual cite;
    classic Lean still does not enforce exact-once at the elaborator.

  Theorems (COMPOSE-THEOREM / HOST-COMPOSE-THEOREM -- partial HostCompose only):
  - multPreScan_empty_true / checkFailClosed_empty_true / extractOkFs_empty_true
  - extractOk_classic_empty_false / extractOk_edge_empty_false (EMIT-BOUNDARY)
  - extractOk_classic_mult1_minted_false / extractOk_edge_mult1_minted_false
  - extractOk_classic_mult0_marked_false / extractOk_edge_mult0_marked_false
    (EMIT-BOUNDARY: conjoins extractOkFs true + classic/edge false on
    non-empty fixtures; hard intermediate like double_consume_notLive)
  - mint_zero_badId / consume_empty_notLive / mint_empty_one_ok /
    consume_minted_one / mint_already_live_one (mint-consume FAIL-CLOSED)
  - double_consume_notLive (first consume must be ok with payload 1; second notLive)
  - nodeMultOk_omega / nodeMultOk_mult1_eq_live / nodeMultOk_mult0_eq_absent
  - multPreScan / extractOkFs MULT-1 unminted fail + minted pass (gap-close)
  - multPreScan MULT-0 unmarked fail + marked pass
  - extractOk_eq / extractOkFs_eq / checkFailClosed_eq (definitional honesty)
  - markErased_idempotent (erasure mark is idempotent on host)
  - multPreScan_omega_only_true / extractOkFs_omega_only_true (value node, no mint)
  - consume_live_payload / mint_nonzero_ok / mint_consume_roundtrip (payload honesty)
  - pushHostNode_bad_node / pushHostNode_value_one_ok (push fail-closed + ok)
  - addHostEdge_empty_badEndpoints / addHostEdge_two_values_ok /
    addHostEdge_one_node_badEndpoints (edge fail-closed + ok)
  These HostCompose theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial theorems on HostCompose != host proof complete != residual free.
  Live-flag model only -- does NOT claim MULT-1 LINEAR-EXACT-ONCE elaborator
  enforcement (SystemsLean.Linear axioms remain; classic Lean cannot enforce).

  Intentional non-claims / partial parity:
  - PARTIAL vs full C HOST_COMPOSE_V0: host does not model null pointers,
    uint8 wire widths, or exact C return-code tables (codes -1 and -2); uses typed
    result inductives and Bool checks instead.
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Not a full elaborator. Not full emit reimplementation. Not residual free.

  Greppable: SYSTEMS_LEAN_HOST, HOST_COMPOSE_V0, HOST-COMPOSE, FAIL-CLOSED,
  EMIT-BOUNDARY, RUNTIME-FS, JOIN-ALG, ConsumeToken, MULT-0, MULT-1, MULT-OMEGA,
  IR-GRAPH-EDGES, slake_host_compose, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM,
  multPreScan_empty_true, mint_zero_badId, consume_empty_notLive,
  double_consume_notLive, multPreScan_mult1_unminted_false,
  extractOkFs_mult1_unminted_false, multPreScan_mult1_minted_true,
  markErased_idempotent, multPreScan_omega_only_true, extractOkFs_omega_only_true,
  consume_live_payload, mint_nonzero_ok, mint_consume_roundtrip,
  pushHostNode_bad_node, pushHostNode_value_one_ok, addHostEdge_empty_badEndpoints,
  addHostEdge_two_values_ok, addHostEdge_one_node_badEndpoints,
  extractOk_classic_mult1_minted_false, extractOk_edge_mult1_minted_false,
  extractOk_classic_mult0_marked_false, extractOk_edge_mult0_marked_false
  UNIT_SURFACE host surface. Module: SystemsLean.HostCompose
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.IrGraph
import SystemsLean.Erasure
import SystemsLean.Extract

namespace SystemsLean.HostCompose

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind typeTagInit)
open SystemsLean.IrGraph (Graph)
open SystemsLean.Erasure (Erased)
open SystemsLean.Extract (RuntimeClaim)

/-- Linear host handle (CONSUME_TOKEN_HOST_V0 / JOIN-ALG ConsumeToken honesty).
    live true means a MULT-1 resource is available for checkFailClosed.
    id is unrestricted payload (mint rejects id 0, matching emit id==0 fail).
    Classic Lean does not enforce LINEAR-EXACT-ONCE; live flag is contract state. -/
structure LinearHost where
  live : Bool
  id : Nat
  deriving DecidableEq, Repr

/-- Empty / unminted linear host (not live). -/
def LinearHost.empty : LinearHost := { live := false, id := 0 }

/-- HOST-COMPOSE: graph + linear host + erasure under one extract entry.
    Emit map: slake_host_compose. -/
structure Host where
  graph : Graph
  linear : LinearHost
  erased : Erased
  deriving DecidableEq, Repr

/-- Empty compose: empty graph, unminted host, unmarked erased.
    EMPTY-GRAPH-OK at graph surface; checkFailClosed OK when no nodes. -/
def empty : Host := {
  graph := IrGraph.empty
  linear := LinearHost.empty
  erased := Erasure.unmarked
}

/-- Result of mint: ok, bad id (0), or already live.
    Emit map: 0 ok; -1 id==0 / invalid; -2 already live. -/
inductive MintResult where
  | ok (hc : Host)
  | badId
  | alreadyLive
  deriving DecidableEq, Repr

/-- mint hc id -- mint a MULT-1 live token on the host (ConsumeToken-class).
    FAIL-CLOSED: id 0 rejected; already-live rejected (no double mint). -/
def mint (hc : Host) (id : Nat) : MintResult :=
  if id = 0 then
    MintResult.badId
  else if hc.linear.live then
    MintResult.alreadyLive
  else
    MintResult.ok { hc with linear := { live := true, id := id } }

/-- Result of consume: ok with payload, or not live (empty / already spent).
    Emit map: 0 success; -1 empty; -2 already spent / LINEAR-EXACT-ONCE. -/
inductive ConsumeResult where
  | ok (hc : Host) (payload : Nat)
  | notLive
  deriving DecidableEq, Repr

/-- consume hc -- use the live token once (contract); clear live.
    FAIL-CLOSED: notLive when host is not live (includes double consume).
    After spend: live false and id scrubbed to 0 (emit-map honesty: spent scrub).
    Payload is returned in ConsumeResult.ok; checkFailClosed only reads live. -/
def consume (hc : Host) : ConsumeResult :=
  if !hc.linear.live then
    ConsumeResult.notLive
  else
    let payload := hc.linear.id
    ConsumeResult.ok { hc with linear := { live := false, id := 0 } } payload

/-- markErased hc -- mark owned erasure handle (ERASE-NO-RUNTIME path).
    Emit map honesty: slake_host_compose_mark_erased / slake_erased_mark.
    Always succeeds on host (no null compose); returns marked handle. -/
def markErased (hc : Host) : Host :=
  { hc with erased := Erasure.mark hc.erased }

/-- Result of pushHostNode: ok with new host, bad node, or full.
    Named Host* to stay distinct from IrGraph.PushNodeResult. -/
inductive HostPushNodeResult where
  | ok (hc : Host)
  | badNode
  | full
  deriving DecidableEq, Repr

/-- Result of addHostEdge: ok, full, or bad endpoints.
    Named Host* to stay distinct from IrGraph.AddEdgeResult. -/
inductive HostAddEdgeResult where
  | ok (hc : Host)
  | full
  | badEndpoints
  deriving DecidableEq, Repr

/-- pushHostNode hc n -- call-through IrGraph.pushNode (compose-owned graph).
    FAIL-CLOSED: same badNode / full as graph / program.
    Distinct name from IrGraph.pushNode so clients need not FQN when both open. -/
def pushHostNode (hc : Host) (n : IrNode) : HostPushNodeResult :=
  match IrGraph.pushNode hc.graph n with
  | IrGraph.PushNodeResult.ok g => HostPushNodeResult.ok { hc with graph := g }
  | IrGraph.PushNodeResult.badNode => HostPushNodeResult.badNode
  | IrGraph.PushNodeResult.full => HostPushNodeResult.full

/-- addHostEdge hc fromIdx toIdx -- call-through IrGraph.addEdge.
    FAIL-CLOSED: full / badEndpoints.
    Distinct name from IrGraph.addEdge. -/
def addHostEdge (hc : Host) (fromIdx toIdx : Nat) : HostAddEdgeResult :=
  match IrGraph.addEdge hc.graph fromIdx toIdx with
  | IrGraph.AddEdgeResult.ok g => HostAddEdgeResult.ok { hc with graph := g }
  | IrGraph.AddEdgeResult.full => HostAddEdgeResult.full
  | IrGraph.AddEdgeResult.badEndpoints => HostAddEdgeResult.badEndpoints

/-- nodeMultOk n hc -- mult pre-scan for one owned node (HOST-COMPOSE boundary).
    MULT-0 needs marked erased; MULT-1 needs hc.linear.live; MULT-OMEGA always ok.
    Closes the Extract.lean MULT-1 live-token gap for nodes present in the graph. -/
def nodeMultOk (n : IrNode) (hc : Host) : Bool :=
  match n.mult with
  | Mult.mult0 => Erasure.isRuntimeAbsent hc.erased
  | Mult.mult1 => hc.linear.live
  | Mult.multOmega => true

/-- multPreScan hc -- FAIL-CLOSED mult pre-scan over all live graph nodes.
    Empty node list is vacuously true (empty compose OK). -/
def multPreScan (hc : Host) : Bool :=
  hc.graph.prog.nodes.all (fun n => nodeMultOk n hc)

/-- hostIsWellTyped hc -- graph well-typed (EMPTY-GRAPH-OK included).
    Distinct from IrGraph.isWellTyped. Host may be unminted; well-typed does not
    require live token until mult pre-scan. -/
def hostIsWellTyped (hc : Host) : Bool := IrGraph.isWellTyped hc.graph

/-- checkFailClosed hc -- HOST-COMPOSE fail-closed bar (partial vs full C).
    1) graph must be well-typed (empty graph OK)
    2) mult pre-scan: MULT-1 needs linear.live; MULT-0 marked erased; MULT-OMEGA free
    Not full C return-code table; Bool host honesty only.
    Greppable: FAIL-CLOSED, HOST-COMPOSE, MULT-0, MULT-1, nodeMultOk, multPreScan. -/
def checkFailClosed (hc : Host) : Bool :=
  hostIsWellTyped hc && multPreScan hc

/-- extractOk hc claim -- extract path honesty (EMIT-BOUNDARY).
    Requires RuntimeClaim.runtimeFs and checkFailClosed.
    Any MULT-1 node needs linear.live; any MULT-0 needs marked erased;
    empty compose and MULT-OMEGA-only graphs may extract under FS without mint.
    EDGE-RUNTIME / RUNTIME-CLASSIC reject.
    On OK product wire would set out_rt to RUNTIME-FS (not modeled as mutation).
    PARTIAL vs full C HOST_COMPOSE_V0 extract (no null out_rt path on host). -/
def extractOk (hc : Host) (claim : RuntimeClaim) : Bool :=
  Extract.isFreestandingGoal claim && checkFailClosed hc

/-- extractOkFs hc -- product extract under RUNTIME-FS only (common path). -/
def extractOkFs (hc : Host) : Bool :=
  extractOk hc RuntimeClaim.runtimeFs

/-! ### COMPOSE-THEOREM / HOST-COMPOSE-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is empty compose
  multPreScan / mint-consume / RUNTIME-FS extract honesty and nodeMultOk
  contracts only. Does not complete SpecProof; does not claim residual free /
  freestanding product self-host complete / PROVABLY. Live-flag model only --
  does NOT claim MULT-1 LINEAR-EXACT-ONCE elaborator enforcement.
-/

/-- Empty compose mult pre-scan is vacuously true (no live nodes).
    Greppable: multPreScan_empty_true, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem multPreScan_empty_true : multPreScan empty = true := rfl

/-- Empty compose fail-closed bar holds (EMPTY-GRAPH-OK + vacuous multPreScan).
    Greppable: checkFailClosed_empty_true, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem checkFailClosed_empty_true : checkFailClosed empty = true := rfl

/-- Empty compose extracts under RUNTIME-FS (EMIT-BOUNDARY product path).
    Greppable: extractOkFs_empty_true, RUNTIME-FS, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem extractOkFs_empty_true : extractOkFs empty = true := rfl

/-- RUNTIME-CLASSIC rejects even empty compose (EMIT-BOUNDARY).
    Greppable: extractOk_classic_empty_false, RUNTIME-CLASSIC, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem extractOk_classic_empty_false :
    extractOk empty RuntimeClaim.runtimeClassic = false := rfl

/-- EDGE-RUNTIME rejects even empty compose (EMIT-BOUNDARY).
    Greppable: extractOk_edge_empty_false, EDGE-RUNTIME, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem extractOk_edge_empty_false :
    extractOk empty RuntimeClaim.edgeRuntime = false := rfl

/-- extractOk is definitionally freestanding goal and checkFailClosed.
    Greppable: extractOk_eq, COMPOSE-THEOREM. -/
theorem extractOk_eq (hc : Host) (c : RuntimeClaim) :
    extractOk hc c = (Extract.isFreestandingGoal c && checkFailClosed hc) := rfl

/-- extractOkFs is definitionally extractOk under RUNTIME-FS.
    Greppable: extractOkFs_eq, RUNTIME-FS, COMPOSE-THEOREM. -/
theorem extractOkFs_eq (hc : Host) :
    extractOkFs hc = extractOk hc RuntimeClaim.runtimeFs := rfl

/-- mint id 0 is always badId (FAIL-CLOSED; emit-map id==0 reject).
    Greppable: mint_zero_badId, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem mint_zero_badId (hc : Host) : mint hc 0 = MintResult.badId := rfl

/-- consume on empty/unminted host is notLive (FAIL-CLOSED).
    Greppable: consume_empty_notLive, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem consume_empty_notLive : consume empty = ConsumeResult.notLive := rfl

/-- mint id 1 on empty compose succeeds and sets live with that id.
    Greppable: mint_empty_one_ok, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem mint_empty_one_ok :
    mint empty 1 =
      MintResult.ok { empty with linear := { live := true, id := 1 } } := rfl

/-- consume of a minted id-1 host returns payload 1 and clears live (spent scrub).
    Greppable: consume_minted_one, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem consume_minted_one :
    consume { empty with linear := { live := true, id := 1 } } =
      ConsumeResult.ok empty 1 := rfl

/-- mint on already-live host is alreadyLive (no double mint; FAIL-CLOSED).
    Greppable: mint_already_live_one, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem mint_already_live_one :
    mint { empty with linear := { live := true, id := 1 } } 2 =
      MintResult.alreadyLive := rfl

/-- MULT-OMEGA nodes always pass nodeMultOk (no live/mark handle required).
    Greppable: nodeMultOk_omega, MULT-OMEGA, COMPOSE-THEOREM. -/
theorem nodeMultOk_omega (n : IrNode) (hc : Host)
    (h : n.mult = Mult.multOmega) : nodeMultOk n hc = true := by
  unfold nodeMultOk
  rw [h]

/-- MULT-1 nodeMultOk tracks linear.live (closes Extract MULT-1 live gap).
    Greppable: nodeMultOk_mult1_eq_live, MULT-1, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem nodeMultOk_mult1_eq_live (n : IrNode) (hc : Host)
    (h : n.mult = Mult.mult1) : nodeMultOk n hc = hc.linear.live := by
  unfold nodeMultOk
  rw [h]

/-- MULT-0 nodeMultOk tracks isRuntimeAbsent erased (ERASE-NO-RUNTIME).
    Greppable: nodeMultOk_mult0_eq_absent, MULT-0, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem nodeMultOk_mult0_eq_absent (n : IrNode) (hc : Host)
    (h : n.mult = Mult.mult0) :
    nodeMultOk n hc = Erasure.isRuntimeAbsent hc.erased := by
  unfold nodeMultOk
  rw [h]

/-- checkFailClosed is definitionally hostIsWellTyped and multPreScan.
    Greppable: checkFailClosed_eq, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem checkFailClosed_eq (hc : Host) :
    checkFailClosed hc = (hostIsWellTyped hc && multPreScan hc) := rfl

/-- Double consume: first spend of minted id-1 must succeed (ok empty payload 1),
    then second consume on spent host is notLive. Conjoins consume_minted_one and
    consume_empty_notLive so a broken first-consume path fails the theorem
    (no match escape masking first-arm failure). Live-flag honesty only -- does
    NOT claim elaborator LINEAR-EXACT-ONCE.
    Greppable: double_consume_notLive, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem double_consume_notLive :
    (consume { empty with linear := { live := true, id := 1 } } =
      ConsumeResult.ok empty 1)
      /\ (consume empty = ConsumeResult.notLive) :=
  And.intro consume_minted_one consume_empty_notLive

/-! ### Non-empty multPreScan / extract fixtures (theorem surface, not only smoke)
    Concrete one-node hosts so MULT-1 gap-close / MULT-0 mark claims reduce
    without push match escapes. -/

private def thmLinearNode : IrNode :=
  { ty := typeTagInit 1, mult := Mult.mult1, kind := NodeKind.linear }

private def thmErasedNode : IrNode :=
  { ty := typeTagInit 0, mult := Mult.mult0, kind := NodeKind.erased }

/-- One MULT-1 node, unminted linear host. -/
private def thmHostMult1Unminted : Host := {
  graph := { prog := { nodes := [thmLinearNode] }, edges := [] }
  linear := LinearHost.empty
  erased := Erasure.unmarked
}

/-- One MULT-1 node with live token (mint evidence). -/
private def thmHostMult1Minted : Host := {
  graph := { prog := { nodes := [thmLinearNode] }, edges := [] }
  linear := { live := true, id := 1 }
  erased := Erasure.unmarked
}

/-- One MULT-0 node without erasure mark. -/
private def thmHostMult0Unmarked : Host := {
  graph := { prog := { nodes := [thmErasedNode] }, edges := [] }
  linear := LinearHost.empty
  erased := Erasure.unmarked
}

/-- One MULT-0 node with marked erasure (ERASE-NO-RUNTIME). -/
private def thmHostMult0Marked : Host := {
  graph := { prog := { nodes := [thmErasedNode] }, edges := [] }
  linear := LinearHost.empty
  erased := Erasure.mark Erasure.unmarked
}

/-- MULT-1 graph node without mint fails multPreScan (closes Extract MULT-1 gap).
    Greppable: multPreScan_mult1_unminted_false, MULT-1, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem multPreScan_mult1_unminted_false :
    multPreScan thmHostMult1Unminted = false := rfl

/-- MULT-1 graph node without mint fails extract under RUNTIME-FS.
    Greppable: extractOkFs_mult1_unminted_false, MULT-1, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem extractOkFs_mult1_unminted_false :
    extractOkFs thmHostMult1Unminted = false := rfl

/-- MULT-1 graph node with live token passes multPreScan.
    Greppable: multPreScan_mult1_minted_true, MULT-1, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem multPreScan_mult1_minted_true :
    multPreScan thmHostMult1Minted = true := rfl

/-- MULT-1 graph node with live token extracts under RUNTIME-FS.
    Greppable: extractOkFs_mult1_minted_true, MULT-1, RUNTIME-FS, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem extractOkFs_mult1_minted_true :
    extractOkFs thmHostMult1Minted = true := rfl

/-- MULT-0 graph node without mark fails multPreScan (ERASE-NO-RUNTIME).
    Greppable: multPreScan_mult0_unmarked_false, MULT-0, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem multPreScan_mult0_unmarked_false :
    multPreScan thmHostMult0Unmarked = false := rfl

/-- MULT-0 graph node with markErased passes multPreScan.
    Greppable: multPreScan_mult0_marked_true, MULT-0, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem multPreScan_mult0_marked_true :
    multPreScan thmHostMult0Marked = true := rfl

/-- MULT-0 graph node without mark fails extract under RUNTIME-FS.
    Greppable: extractOkFs_mult0_unmarked_false, MULT-0, COMPOSE-THEOREM. -/
theorem extractOkFs_mult0_unmarked_false :
    extractOkFs thmHostMult0Unmarked = false := rfl

/-- MULT-0 graph node with mark extracts under RUNTIME-FS.
    Greppable: extractOkFs_mult0_marked_true, MULT-0, RUNTIME-FS, COMPOSE-THEOREM. -/
theorem extractOkFs_mult0_marked_true :
    extractOkFs thmHostMult0Marked = true := rfl

/-- MULT-1 minted still rejects RUNTIME-CLASSIC (EMIT-BOUNDARY).
    Conjoins extractOkFs true so a broken multPreScan / checkFailClosed path
    fails this theorem (not claim-side false alone; same And.intro honesty as
    double_consume_notLive / mint_consume_roundtrip).
    Greppable: extractOk_classic_mult1_minted_false, RUNTIME-CLASSIC, MULT-1,
    COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem extractOk_classic_mult1_minted_false :
    (extractOkFs thmHostMult1Minted = true)
      /\ (extractOk thmHostMult1Minted RuntimeClaim.runtimeClassic = false) :=
  And.intro extractOkFs_mult1_minted_true rfl

/-- MULT-1 minted still rejects EDGE-RUNTIME (EMIT-BOUNDARY non-empty).
    Conjoins extractOkFs true (hard intermediate; not claim-side alone).
    Greppable: extractOk_edge_mult1_minted_false, EDGE-RUNTIME, MULT-1,
    COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem extractOk_edge_mult1_minted_false :
    (extractOkFs thmHostMult1Minted = true)
      /\ (extractOk thmHostMult1Minted RuntimeClaim.edgeRuntime = false) :=
  And.intro extractOkFs_mult1_minted_true rfl

/-- MULT-0 marked still rejects RUNTIME-CLASSIC (EMIT-BOUNDARY).
    Conjoins extractOkFs true so mult0 mark / checkFailClosed cannot silently
    regress while classic reject stays green.
    Greppable: extractOk_classic_mult0_marked_false, RUNTIME-CLASSIC, MULT-0,
    COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem extractOk_classic_mult0_marked_false :
    (extractOkFs thmHostMult0Marked = true)
      /\ (extractOk thmHostMult0Marked RuntimeClaim.runtimeClassic = false) :=
  And.intro extractOkFs_mult0_marked_true rfl

/-- MULT-0 marked still rejects EDGE-RUNTIME (EMIT-BOUNDARY non-empty).
    Conjoins extractOkFs true (hard intermediate; not claim-side alone).
    Greppable: extractOk_edge_mult0_marked_false, EDGE-RUNTIME, MULT-0,
    COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem extractOk_edge_mult0_marked_false :
    (extractOkFs thmHostMult0Marked = true)
      /\ (extractOk thmHostMult0Marked RuntimeClaim.edgeRuntime = false) :=
  And.intro extractOkFs_mult0_marked_true rfl

/-! ### Algebraic / fail-closed deepen (beyond empty canaries)
    mark idempotence, MULT-OMEGA-only pre-scan, mint-consume payload honesty. -/

private def thmValueNode : IrNode :=
  { ty := typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }

/-- One MULT-OMEGA value node, unminted/unmarked (no live handle required). -/
private def thmHostOmegaOnly : Host := {
  graph := { prog := { nodes := [thmValueNode] }, edges := [] }
  linear := LinearHost.empty
  erased := Erasure.unmarked
}

/-- markErased is idempotent (ERASE-NO-RUNTIME mark twice equals mark once).
    Greppable: markErased_idempotent, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem markErased_idempotent (hc : Host) :
    markErased (markErased hc) = markErased hc := by
  unfold markErased
  rw [Erasure.mark_idempotent]

/-- MULT-OMEGA-only graph passes multPreScan without mint or mark.
    Greppable: multPreScan_omega_only_true, MULT-OMEGA, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem multPreScan_omega_only_true :
    multPreScan thmHostOmegaOnly = true := rfl

/-- MULT-OMEGA-only graph extracts under RUNTIME-FS without mint or mark.
    Greppable: extractOkFs_omega_only_true, MULT-OMEGA, RUNTIME-FS,
    COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem extractOkFs_omega_only_true :
    extractOkFs thmHostOmegaOnly = true := rfl

/-- Live host with any id yields consume payload equal to that id (spent scrub).
    Greppable: consume_live_payload, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem consume_live_payload (id : Nat) :
    consume { empty with linear := { live := true, id := id } } =
      ConsumeResult.ok empty id := rfl

/-- mint nonempty id on empty compose succeeds with that live id.
    Greppable: mint_nonzero_ok, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem mint_nonzero_ok (id : Nat) (h : Not (id = 0)) :
    mint empty id =
      MintResult.ok { empty with linear := { live := true, id := id } } := by
  unfold mint
  rw [if_neg h]
  rfl

/-- mint then consume payload honesty for nonzero id (live-flag only).
    Conjoins mint_nonzero_ok and consume_live_payload so a broken mint path
    fails the theorem (no match escape masking first-arm failure; same pattern
    as double_consume_notLive).
    Greppable: mint_consume_roundtrip, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem mint_consume_roundtrip (id : Nat) (h : Not (id = 0)) :
    (mint empty id =
      MintResult.ok { empty with linear := { live := true, id := id } })
      /\ (consume { empty with linear := { live := true, id := id } } =
           ConsumeResult.ok empty id) :=
  And.intro (mint_nonzero_ok id h) (consume_live_payload id)

/-! ### pushHostNode / addHostEdge fail-closed + ok (beyond mint-consume)
    Hand-built fixtures so push/edge match escapes are not required. -/

/-- Kind/mult mismatch (VALUE with MULT-1) is not well-typed. -/
private def thmBadNode : IrNode :=
  { ty := typeTagInit 9, mult := Mult.mult1, kind := NodeKind.value }

/-- One MULT-OMEGA value node host (graph only; unminted linear). -/
private def thmHostOneValue : Host := {
  graph := { prog := { nodes := [thmValueNode] }, edges := [] }
  linear := LinearHost.empty
  erased := Erasure.unmarked
}

/-- Two MULT-OMEGA value nodes, no edges. -/
private def thmHostTwoValues : Host := {
  graph := {
    prog := { nodes := [thmValueNode, thmValueNode] }
    edges := []
  }
  linear := LinearHost.empty
  erased := Erasure.unmarked
}

/-- pushHostNode fails closed on a bad (kind/mult mismatch) node.
    Greppable: pushHostNode_bad_node, FAIL-CLOSED, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem pushHostNode_bad_node :
    pushHostNode empty thmBadNode = HostPushNodeResult.badNode := rfl

/-- pushHostNode empty with well-typed VALUE yields one-node host.
    Greppable: pushHostNode_value_one_ok, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem pushHostNode_value_one_ok :
    pushHostNode empty thmValueNode = HostPushNodeResult.ok thmHostOneValue := rfl

/-- addHostEdge on empty compose fails closed (no valid endpoints).
    Greppable: addHostEdge_empty_badEndpoints, FAIL-CLOSED, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem addHostEdge_empty_badEndpoints (fromIdx toIdx : Nat) :
    addHostEdge empty fromIdx toIdx = HostAddEdgeResult.badEndpoints := by
  unfold addHostEdge
  have h :
      IrGraph.addEdge empty.graph fromIdx toIdx =
        IrGraph.AddEdgeResult.badEndpoints :=
    IrGraph.addEdge_empty_badEndpoints fromIdx toIdx
  rw [h]

/-- addHostEdge 0->1 on two-value host succeeds.
    Greppable: addHostEdge_two_values_ok, COMPOSE-THEOREM, HOST-COMPOSE-THEOREM. -/
theorem addHostEdge_two_values_ok :
    addHostEdge thmHostTwoValues 0 1 =
      HostAddEdgeResult.ok {
        graph := {
          prog := thmHostTwoValues.graph.prog
          edges := [{ fromIdx := 0, toIdx := 1 }]
        }
        linear := LinearHost.empty
        erased := Erasure.unmarked
      } := rfl

/-- addHostEdge out-of-range on one-node host fails closed.
    Greppable: addHostEdge_one_node_badEndpoints, FAIL-CLOSED, COMPOSE-THEOREM,
    HOST-COMPOSE-THEOREM. -/
theorem addHostEdge_one_node_badEndpoints :
    addHostEdge thmHostOneValue 0 1 = HostAddEdgeResult.badEndpoints := by
  unfold addHostEdge
  have h :
      IrGraph.addEdge thmHostOneValue.graph 0 1 =
        IrGraph.AddEdgeResult.badEndpoints := by
    -- Hand-built one-node length-1 fixture; prove graph addEdge badEndpoints
    -- then rewrite match (IrGraph.addEdge_one_node_badEndpoints is private-fixture
    -- and not reused here -- empty path reuses IrGraph theorem instead).
    unfold IrGraph.addEdge
    rw [if_neg (by decide :
        Not (thmHostOneValue.graph.edges.length >= IrGraph.edgeMax))]
    have hends :
        IrGraph.edgeEndpointsOk { fromIdx := 0, toIdx := 1 }
          (IrProgram.length thmHostOneValue.graph.prog) = false := by
      simp [IrGraph.edgeEndpointsOk, thmHostOneValue, IrProgram.length]
    simp [hends]
  rw [h]

/-! ### Host smoke (behavioral; lake build fails if an example does not hold)
    Greppable: HOST-SMOKE. Exercises MULT-1 live, MULT-0 mark, empty OK, FS reject. -/

private def smokeLinearNode : IrNode := thmLinearNode

private def smokeErasedNode : IrNode := thmErasedNode

private def smokeValueNode : IrNode :=
  { ty := typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }

private def smokePush (hc : Host) (n : IrNode) : Host :=
  match pushHostNode hc n with
  | HostPushNodeResult.ok hc' => hc'
  | _ => hc

private def smokeMint (hc : Host) (id : Nat) : Host :=
  match mint hc id with
  | MintResult.ok hc' => hc'
  | _ => hc

/-- HOST-SMOKE: empty compose extract under RUNTIME-FS is OK. -/
example : extractOkFs empty = true := by decide

/-- HOST-SMOKE: MULT-1 node without mint fails extract. -/
example : extractOkFs (smokePush empty smokeLinearNode) = false := by decide

/-- HOST-SMOKE: MULT-1 node with mint extracts OK. -/
example : extractOkFs (smokeMint (smokePush empty smokeLinearNode) 7) = true := by decide

/-- HOST-SMOKE: MULT-0 node without mark fails extract. -/
example : extractOkFs (smokePush empty smokeErasedNode) = false := by decide

/-- HOST-SMOKE: MULT-0 node with markErased extracts OK. -/
example : extractOkFs (markErased (smokePush empty smokeErasedNode)) = true := by decide

/-- HOST-SMOKE: MULT-OMEGA-only extract under FS without mint/mark. -/
example : extractOkFs (smokePush empty smokeValueNode) = true := by decide

/-- HOST-SMOKE: RUNTIME-CLASSIC reject even on empty compose. -/
example : extractOk empty RuntimeClaim.runtimeClassic = false := by decide

/-- HOST-SMOKE: mint then consume then MULT-1 extract fails (live cleared);
    spent scrub sets id to 0 while returning payload (emit-map honesty). -/
example :
    (match consume (smokeMint (smokePush empty smokeLinearNode) 3) with
     | ConsumeResult.ok hc' payload =>
         !extractOkFs hc' && !hc'.linear.live && hc'.linear.id == 0 && payload == 3
     | ConsumeResult.notLive => false) = true := by decide

/-- HOST-SMOKE: mint id 0 is badId. -/
example :
    (match mint empty 0 with
     | MintResult.badId => true
     | _ => false) = true := by decide

/-- HOST-SMOKE: multPreScan / nodeMultOk on MULT-1 path. -/
example : multPreScan (smokePush empty smokeLinearNode) = false := by decide
example : multPreScan (smokeMint (smokePush empty smokeLinearNode) 1) = true := by decide

end SystemsLean.HostCompose
