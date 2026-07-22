/-
  SYSTEMS_LEAN_HOST partial -- host-side dual / JOIN map into compile-path readiness.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Dual cite (read-only; do not reimplement duals here):
    src/idris2/examples/ConsumeToken.idr
    src/lean4/examples/ConsumeToken.lean
  Pair map (read-only): SystemsLean.Linear JOIN-ALG ConsumeToken axioms,
    SystemsLean.CompilePath unit/program readiness (sibling bars),
    HostCompose mint/consume live-flag model (LINEAR-EXACT-ONCE contract state).

  Spec (readable, separate from any future proof):
  - SLAKE_JOIN_MAP_V0 / HOST-JOIN-MAP / JOIN-MAP: host map from dual-pair
    JOIN-ALG honesty into Slake compile-path readiness composition.
  - joinAlgContractOk: surface-level canary (constant dual-cite + algorithm ids).
    Not a filesystem walk of dual trees; not freestanding LinearCheck.
  - joinUnitCompileReady hc: CompilePath.unitCompileReady && joinAlgContractOk
    (FAIL-CLOSED composition; reuses unit bar APIs; no parallel type zoo).
  - joinProgramCompileReady p: CompilePath.programCompileReady && joinAlgContractOk
    (sibling API; EMPTY-PROGRAM-FAIL-CLOSED preserved; empty host OK != empty program OK).
  - joinCompileReady hc: alias of joinUnitCompileReady (HOST-JOIN-MAP unit bar).
  - Verdict records joinOk / unitReady / ok for inventory (ok == both).

  Intentional non-claims / partial parity:
  - PARTIAL: host Bool map inventory vs formal dual-bridge theorems inventing
    duals; this module cites duals read-only and composes existing host APIs.
  - PARTIAL: joinAlgContractOk is surface-level (constant canaries), not a
    structure walk of dual sources or HostCompose graph nodes.
  - Classic Lean cannot enforce MULT-1 / LINEAR-EXACT-ONCE; Linear axioms +
    HostCompose live flag remain the contract (see Linear.lean / HostCompose).
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not a full Slake compiler body. Not residual free.
  - Does not fold program bar into unit bar (sibling APIs; P3 residual lesson).

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_JOIN_MAP_V0, HOST-JOIN-MAP, JOIN-MAP,
  JOIN-ALG, ConsumeToken, LINEAR-EXACT-ONCE, MULT-1, HOST-COMPILE-PATH,
  SLAKE_COMPILE_PATH_V1, joinUnitCompileReady, joinProgramCompileReady,
  joinCompileReady, joinAlgContractOk, JOIN-MAP-SMOKE, EMPTY-PROGRAM-FAIL-CLOSED,
  FAIL-CLOSED, UNIT_SURFACE host surface. Module: SystemsLean.JoinMap
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.IrProgram
import SystemsLean.HostCompose
import SystemsLean.CompilePath

namespace SystemsLean.JoinMap

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind typeTagInit)
open SystemsLean.IrProgram (Program)
open SystemsLean.HostCompose (Host)

/-- Greppable primary stage id for host join map (P4). -/
def stageId : String := "SLAKE_JOIN_MAP_V0"

/-- Greppable host alias for join-map honesty (HOST-JOIN-MAP). -/
def hostJoinMapId : String := "HOST-JOIN-MAP"

/-- Greppable short map id (JOIN-MAP). -/
def joinMapId : String := "JOIN-MAP"

/-- JOIN-ALG algorithm id (dual-pair ConsumeToken). -/
def joinAlgId : String := "JOIN-ALG"

/-- ConsumeToken dual algorithm name (read-only dual cite). -/
def consumeTokenAlgId : String := "ConsumeToken"

/-- Read-only dual path cite (Idris side). Not a filesystem read. -/
def dualIdrisPath : String := "src/idris2/examples/ConsumeToken.idr"

/-- Read-only dual path cite (Lean side). Not a filesystem read. -/
def dualLeanPath : String := "src/lean4/examples/ConsumeToken.lean"

/-- joinLinearCiteOk -- dual path inventory strings match dual-pair layout.
    Surface-level constant canary only (not an FS walk of dual trees).
    Greppable: JOIN-ALG, ConsumeToken, dual cite. -/
def joinLinearCiteOk : Bool :=
  (dualIdrisPath == "src/idris2/examples/ConsumeToken.idr")
    && (dualLeanPath == "src/lean4/examples/ConsumeToken.lean")

/-- joinAlgContractOk -- JOIN-ALG / ConsumeToken dual-cite honesty canary.
    Surface-level: algorithm ids + dual path cites match the dual-pair map.
    Does not elaborate dual .idr/.lean sources. Does not enforce MULT-1
    (Linear axioms + HostCompose live flag; classic elaborator gap).
    Greppable: joinAlgContractOk, JOIN-ALG, ConsumeToken. -/
def joinAlgContractOk : Bool :=
  (joinAlgId == "JOIN-ALG")
    && (consumeTokenAlgId == "ConsumeToken")
    && (stageId == "SLAKE_JOIN_MAP_V0")
    && (hostJoinMapId == "HOST-JOIN-MAP")
    && (joinMapId == "JOIN-MAP")
    && joinLinearCiteOk

/-- JOIN-MAP readiness verdict (inventory; not product C).
    ok is the overall fail-closed bar used by joinUnitCompileReady. -/
structure Verdict where
  joinOk : Bool
  unitReady : Bool
  ok : Bool
  deriving DecidableEq, Repr

/-- Fail-closed zeroed verdict. -/
def Verdict.failClosed : Verdict := {
  joinOk := false
  unitReady := false
  ok := false
}

/-- joinUnitCompileReady hc -- join-informed unit compile-path bar.
    FAIL-CLOSED: CompilePath.unitCompileReady && joinAlgContractOk.
    Reuses unit bar (extractOkFs + gradeSurfaceOk); no parallel type zoo.
    Does not fold programCompileReady (sibling API).
    Greppable: joinUnitCompileReady, HOST-JOIN-MAP, HOST-COMPILE-PATH. -/
def joinUnitCompileReady (hc : Host) : Bool :=
  CompilePath.unitCompileReady hc && joinAlgContractOk

/-- joinCompileReady hc -- HOST-JOIN-MAP unit bar alias of joinUnitCompileReady.
    Empty HostCompose is OK when unit bar holds (vacuous mult pre-scan).
    Does not emit C. Does not claim freestanding residual free. -/
def joinCompileReady (hc : Host) : Bool :=
  joinUnitCompileReady hc

/-- joinProgramCompileReady p -- join-informed program compile-path bar (sibling).
    FAIL-CLOSED: CompilePath.programCompileReady && joinAlgContractOk.
    EMPTY-PROGRAM-FAIL-CLOSED: empty ordered program is not program-ready
    (distinct from empty HostCompose, which is unit-ready under join map).
    Greppable: joinProgramCompileReady, EMPTY-PROGRAM-FAIL-CLOSED. -/
def joinProgramCompileReady (p : Program) : Bool :=
  CompilePath.programCompileReady p && joinAlgContractOk

/-- verdictOf hc -- inventory Verdict from join map + unit compile readiness.
    ok == joinUnitCompileReady hc. Does not fold program bar. -/
def verdictOf (hc : Host) : Verdict :=
  let joinOk := joinAlgContractOk
  let unitReady := CompilePath.unitCompileReady hc
  {
    joinOk := joinOk
    unitReady := unitReady
    ok := joinOk && unitReady
  }

/-! ### Join-map smoke (behavioral; lake build fails if an example does not hold)
    Greppable: JOIN-MAP-SMOKE. Exercises dual-cite surface, empty host OK,
    empty program fail-closed, MULT-1 mint path, sibling bars not conflated. -/

private def smokeLinearNode : IrNode :=
  { ty := typeTagInit 1, mult := Mult.mult1, kind := NodeKind.linear }

private def smokeErasedNode : IrNode :=
  { ty := typeTagInit 0, mult := Mult.mult0, kind := NodeKind.erased }

private def smokeValueNode : IrNode :=
  { ty := typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }

private def smokePush (hc : Host) (n : IrNode) : Host :=
  match HostCompose.pushHostNode hc n with
  | HostCompose.HostPushNodeResult.ok hc' => hc'
  | _ => hc

private def smokeMint (hc : Host) (id : Nat) : Host :=
  match HostCompose.mint hc id with
  | HostCompose.MintResult.ok hc' => hc'
  | _ => hc

private def smokePushProg (p : Program) (n : IrNode) : Program :=
  match IrProgram.push p n with
  | IrProgram.PushResult.ok p' => p'
  | _ => p

/-- JOIN-MAP-SMOKE: stage / map ids are greppable honesty strings. -/
example : stageId = "SLAKE_JOIN_MAP_V0" := by decide
example : hostJoinMapId = "HOST-JOIN-MAP" := by decide
example : joinMapId = "JOIN-MAP" := by decide
example : joinAlgId = "JOIN-ALG" := by decide
example : consumeTokenAlgId = "ConsumeToken" := by decide

/-- JOIN-MAP-SMOKE: dual path cites match dual-pair layout (surface canary). -/
example : dualIdrisPath = "src/idris2/examples/ConsumeToken.idr" := by decide
example : dualLeanPath = "src/lean4/examples/ConsumeToken.lean" := by decide
example : joinLinearCiteOk = true := by decide
example : joinAlgContractOk = true := by decide

/-- JOIN-MAP-SMOKE: empty HostCompose is join-unit-ready (unit bar + join). -/
example : joinCompileReady HostCompose.empty = true := by decide
example : joinUnitCompileReady HostCompose.empty = true := by decide
example :
    (let v := verdictOf HostCompose.empty
     v.ok && v.joinOk && v.unitReady) = true := by decide

/-- JOIN-MAP-SMOKE: empty ordered program is NOT join-program-ready.
    Sibling bar: empty host OK != empty program OK (P3 residual lesson). -/
example : joinProgramCompileReady IrProgram.empty = false := by decide

/-- JOIN-MAP-SMOKE: MULT-OMEGA-only host is join-unit-ready without mint. -/
example :
    joinUnitCompileReady (smokePush HostCompose.empty smokeValueNode) = true := by
  decide

/-- JOIN-MAP-SMOKE: MULT-1 without mint fails join-unit-ready (multPreScan). -/
example :
    joinCompileReady (smokePush HostCompose.empty smokeLinearNode) = false := by
  decide
example :
    (let v := verdictOf (smokePush HostCompose.empty smokeLinearNode)
     !v.ok && v.joinOk && !v.unitReady) = true := by decide

/-- JOIN-MAP-SMOKE: MULT-1 with mint is join-unit-ready. -/
example :
    joinUnitCompileReady
      (smokeMint (smokePush HostCompose.empty smokeLinearNode) 4) = true := by
  decide

/-- JOIN-MAP-SMOKE: MULT-0 without mark fails; with markErased ok. -/
example :
    joinCompileReady (smokePush HostCompose.empty smokeErasedNode) = false := by
  decide
example :
    joinCompileReady
      (HostCompose.markErased (smokePush HostCompose.empty smokeErasedNode))
      = true := by decide

/-- JOIN-MAP-SMOKE: well-typed non-empty program is join-program-ready. -/
example :
    (let p := smokePushProg IrProgram.empty smokeValueNode
     joinProgramCompileReady p) = true := by decide

/-- JOIN-MAP-SMOKE: failClosed verdict is not ok. -/
example : Verdict.failClosed.ok = false := by decide

/-- JOIN-MAP-SMOKE: unit bar does not imply program bar on empty program
    (sibling APIs; do not conflate). -/
example :
    (joinUnitCompileReady HostCompose.empty
      && !joinProgramCompileReady IrProgram.empty) = true := by decide

end SystemsLean.JoinMap
