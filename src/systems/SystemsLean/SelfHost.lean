/-
  SYSTEMS_LEAN_HOST partial -- host-side self-host readiness composition.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): SystemsLean.JoinMap join-informed unit/program readiness
    (sibling bars), SystemsLean.CompilePath HOST-COMPILE-PATH, HostCompose
    extractOkFs, package root import shell SystemsLean.lean.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_V0 / HOST-SELF-HOST / SELF-HOST: host map that join-informed
    compile path + host ladder surface are present for self-host *direction*.
  - hostSurfaceOk: surface-level canary (stage ids + package/module path cites).
    Not a filesystem walk of the host ladder; not freestanding product compile.
  - selfHostUnitReady hc: JoinMap.joinUnitCompileReady && hostSurfaceOk
    (FAIL-CLOSED composition; reuses join/unit bar APIs; no parallel type zoo).
  - selfHostProgramReady p: JoinMap.joinProgramCompileReady && hostSurfaceOk
    (sibling API; EMPTY-PROGRAM-FAIL-CLOSED preserved; empty host OK != empty
    program OK).
  - selfHostReady hc: alias of selfHostUnitReady (HOST-SELF-HOST unit bar).
  - Verdict records joinReady / unitReady / hostSurface / ok for inventory.

  Intentional non-claims / partial parity:
  - PARTIAL: host Bool readiness inventory vs freestanding product self-host
    (Slake compiling Systems Lean units to freestanding C without classic
    elaborator). This module is V0 direction readiness, not self-host complete.
  - PARTIAL: hostSurfaceOk is surface-level constant canary, not a structure
    walk of Mult..InventoryClose sources or FS unit compile.
  - Classic Lean elaborator residual remains (managed runtime on host; host
    residual != product wire residual).
  - Freestanding product self-host is later (true self-host unlocks llvm track).
  - Not residual free. Not PROVABLY. Not freestanding emit residual free.
  - Not a full Slake compiler body. Does not emit product C.
  - Does not fold program bar into unit bar (sibling APIs; P3 residual lesson).
  - Does not unlock out/llvm-ir (still deferred until true self-host).

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_V0, HOST-SELF-HOST, SELF-HOST,
  HOST-JOIN-MAP, SLAKE_JOIN_MAP_V0, HOST-COMPILE-PATH, SLAKE_COMPILE_PATH_V1,
  selfHostUnitReady, selfHostProgramReady, selfHostReady, hostSurfaceOk,
  SELF-HOST-SMOKE, EMPTY-PROGRAM-FAIL-CLOSED, FAIL-CLOSED, joinUnitCompileReady,
  UNIT_SURFACE host surface. Module: SystemsLean.SelfHost
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.IrProgram
import SystemsLean.HostCompose
import SystemsLean.CompilePath
import SystemsLean.JoinMap

namespace SystemsLean.SelfHost

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind typeTagInit)
open SystemsLean.IrProgram (Program)
open SystemsLean.HostCompose (Host)

/-- Greppable primary stage id for host self-host readiness (P5). -/
def stageId : String := "SLAKE_SELF_HOST_V0"

/-- Greppable host alias for self-host honesty (HOST-SELF-HOST). -/
def hostSelfHostId : String := "HOST-SELF-HOST"

/-- Greppable short map id (SELF-HOST). -/
def selfHostId : String := "SELF-HOST"

/-- Read-only package root path cite (not a filesystem read). -/
def packageRootPath : String := "src/systems/SystemsLean.lean"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/SelfHost.lean"

/-- hostSurfaceOk -- package / stage-id inventory canary for self-host direction.
    Surface-level constant canary only (not an FS walk of Mult..InventoryClose;
    this module is SelfHost; full SYSTEMS_LEAN_HOST ladder includes KernelMult +
    EmitMult + ParityMult + KernelLinear + KernelTypes + KernelProgram +
    SelfApply + LlvmHold).
    Greppable: hostSurfaceOk, SYSTEMS_LEAN_HOST, SELF-HOST. -/
def hostSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_V0")
    && (hostSelfHostId == "HOST-SELF-HOST")
    && (selfHostId == "SELF-HOST")
    && (packageRootPath == "src/systems/SystemsLean.lean")
    && (hostModulePath == "src/systems/SystemsLean/SelfHost.lean")

/-- SELF-HOST readiness verdict (inventory; not product C; not self-host complete).
    Field layering matches JoinMap.verdictOf (sibling inventory, not pre-folded):
    - joinReady: JOIN-ALG dual-cite surface canary only
    - unitReady: pure CompilePath unit bar (extractOkFs + gradeSurfaceOk; no join fold)
    - hostSurface: package/stage-id surface canary only
    - ok: joinReady && unitReady && hostSurface (== selfHostUnitReady while join is unit && joinAlg)
    Inventory can separate "join canary down" from "unit bar down" via fields. -/
structure Verdict where
  joinReady : Bool
  unitReady : Bool
  hostSurface : Bool
  ok : Bool
  deriving DecidableEq, Repr

/-- Fail-closed zeroed verdict. -/
def Verdict.failClosed : Verdict := {
  joinReady := false
  unitReady := false
  hostSurface := false
  ok := false
}

/-- selfHostUnitReady hc -- self-host direction unit bar (join-informed).
    FAIL-CLOSED: JoinMap.joinUnitCompileReady && hostSurfaceOk.
    Reuses join unit bar (unitCompileReady + joinAlgContractOk); no parallel zoo.
    Does not fold programCompileReady (sibling API).
    Greppable: selfHostUnitReady, HOST-SELF-HOST, HOST-JOIN-MAP. -/
def selfHostUnitReady (hc : Host) : Bool :=
  JoinMap.joinUnitCompileReady hc && hostSurfaceOk

/-- selfHostReady hc -- HOST-SELF-HOST unit bar alias of selfHostUnitReady.
    Empty HostCompose is OK when join unit bar holds (vacuous mult pre-scan).
    Does not emit C. Does not claim freestanding residual free or self-host complete. -/
def selfHostReady (hc : Host) : Bool :=
  selfHostUnitReady hc

/-- selfHostProgramReady p -- self-host direction program bar (sibling).
    FAIL-CLOSED: JoinMap.joinProgramCompileReady && hostSurfaceOk.
    EMPTY-PROGRAM-FAIL-CLOSED: empty ordered program is not program-ready
    (distinct from empty HostCompose, which is unit-ready under self-host map).
    Greppable: selfHostProgramReady, EMPTY-PROGRAM-FAIL-CLOSED. -/
def selfHostProgramReady (p : Program) : Bool :=
  JoinMap.joinProgramCompileReady p && hostSurfaceOk

/-- verdictOf hc -- inventory Verdict with layered fields (JoinMap pattern).
    unitReady is pure CompilePath.unitCompileReady (not join-pre-folded).
    ok == joinReady && unitReady && hostSurface == selfHostUnitReady hc.
    Does not fold program bar. -/
def verdictOf (hc : Host) : Verdict :=
  let joinReady := JoinMap.joinAlgContractOk
  let unitReady := CompilePath.unitCompileReady hc
  let hostSurface := hostSurfaceOk
  {
    joinReady := joinReady
    unitReady := unitReady
    hostSurface := hostSurface
    ok := joinReady && unitReady && hostSurface
  }

/-! ### Self-host smoke (behavioral; lake build fails if an example does not hold)
    Greppable: SELF-HOST-SMOKE. Exercises surface canary, empty host OK,
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

/-- SELF-HOST-SMOKE: stage / map ids are greppable honesty strings. -/
example : stageId = "SLAKE_SELF_HOST_V0" := by decide
example : hostSelfHostId = "HOST-SELF-HOST" := by decide
example : selfHostId = "SELF-HOST" := by decide

/-- SELF-HOST-SMOKE: package / module path cites match host layout (surface). -/
example : packageRootPath = "src/systems/SystemsLean.lean" := by decide
example : hostModulePath = "src/systems/SystemsLean/SelfHost.lean" := by decide
example : hostSurfaceOk = true := by decide

/-- SELF-HOST-SMOKE: empty HostCompose is self-host unit-ready (join + surface). -/
example : selfHostReady HostCompose.empty = true := by decide
example : selfHostUnitReady HostCompose.empty = true := by decide
example :
    (let v := verdictOf HostCompose.empty
     v.ok && v.joinReady && v.unitReady && v.hostSurface) = true := by decide

/-- SELF-HOST-SMOKE: empty ordered program is NOT self-host program-ready.
    Sibling bar: empty host OK != empty program OK (P3 residual lesson). -/
example : selfHostProgramReady IrProgram.empty = false := by decide

/-- SELF-HOST-SMOKE: MULT-OMEGA-only host is self-host unit-ready without mint. -/
example :
    selfHostUnitReady (smokePush HostCompose.empty smokeValueNode) = true := by
  decide

/-- SELF-HOST-SMOKE: MULT-1 without mint fails self-host unit-ready (multPreScan). -/
example :
    selfHostReady (smokePush HostCompose.empty smokeLinearNode) = false := by
  decide
example :
    (let v := verdictOf (smokePush HostCompose.empty smokeLinearNode)
     !v.ok && v.joinReady && !v.unitReady && v.hostSurface) = true := by decide

/-- SELF-HOST-SMOKE: MULT-1 with mint is self-host unit-ready. -/
example :
    selfHostUnitReady
      (smokeMint (smokePush HostCompose.empty smokeLinearNode) 4) = true := by
  decide

/-- SELF-HOST-SMOKE: MULT-0 without mark fails; with markErased ok. -/
example :
    selfHostReady (smokePush HostCompose.empty smokeErasedNode) = false := by
  decide
example :
    selfHostReady
      (HostCompose.markErased (smokePush HostCompose.empty smokeErasedNode))
      = true := by decide

/-- SELF-HOST-SMOKE: well-typed non-empty program is self-host program-ready. -/
example :
    (let p := smokePushProg IrProgram.empty smokeValueNode
     selfHostProgramReady p) = true := by decide

/-- SELF-HOST-SMOKE: failClosed verdict is not ok. -/
example : Verdict.failClosed.ok = false := by decide

/-- SELF-HOST-SMOKE: unit bar does not imply program bar on empty program
    (sibling APIs; do not conflate). -/
example :
    (selfHostUnitReady HostCompose.empty
      && !selfHostProgramReady IrProgram.empty) = true := by decide

/-- SELF-HOST-SMOKE: self-host unit bar matches join unit bar under host surface. -/
example :
    (selfHostUnitReady HostCompose.empty
      = JoinMap.joinUnitCompileReady HostCompose.empty) = true := by decide

end SystemsLean.SelfHost
