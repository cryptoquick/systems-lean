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

  Intentional non-claims / partial parity:
  - PARTIAL vs full C HOST_COMPOSE_V0: host does not model null pointers,
    uint8 wire widths, or exact C return-code tables (codes -1 and -2); uses typed
    result inductives and Bool checks instead.
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Classic Lean elaborator still has managed runtime residual (host != product wire).
  - Not a full elaborator. Not full emit reimplementation. Not residual free.

  Greppable: SYSTEMS_LEAN_HOST, HOST_COMPOSE_V0, HOST-COMPOSE, FAIL-CLOSED,
  EMIT-BOUNDARY, RUNTIME-FS, JOIN-ALG, ConsumeToken, MULT-0, MULT-1, MULT-OMEGA,
  IR-GRAPH-EDGES, slake_host_compose
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

/-! ### Host smoke (behavioral; lake build fails if an example does not hold)
    Greppable: HOST-SMOKE. Exercises MULT-1 live, MULT-0 mark, empty OK, FS reject. -/

private def smokeLinearNode : IrNode :=
  { ty := typeTagInit 1, mult := Mult.mult1, kind := NodeKind.linear }

private def smokeErasedNode : IrNode :=
  { ty := typeTagInit 0, mult := Mult.mult0, kind := NodeKind.erased }

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
