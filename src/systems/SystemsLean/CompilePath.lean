/-
  SYSTEMS_LEAN_HOST partial -- host-informed Slake compile-path readiness.
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): script/slake-compile-path.sh SLAKE_COMPILE_PATH_V0
    (structure-stage thin validation; shell greps remain V0 debt),
    HostCompose / IrProgram / Mult / Extract host surfaces.

  Spec (readable, separate from any future proof):
  - SLAKE_COMPILE_PATH_V1 / HOST-COMPILE-PATH: host-side readiness composition
    that Systems Lean units can be treated as compile-path inputs.
  - V0 structure stage (shell greps of UNIT_SURFACE / markers) remains; this
    module is the V1 host deepen -- not a second structure grep mill.
  - compileReady hc: fail-closed HostCompose.extractOkFs (implies multPreScan +
    hostIsWellTyped + RUNTIME-FS only). Does not re-emit product C.
  - programCompileReady p: IrProgram.isWellTyped (EMPTY-PROGRAM-FAIL-CLOSED on
    empty ordered program; distinct from empty HostCompose which is OK).
  - gradeSurfaceOk: closed Mult grades MULT-0/1/OMEGA + raw-tag reject of 3.
  - unitCompileReady hc: compileReady && gradeSurfaceOk (full host unit bar).
  - Verdict records hostChecked / extractFs / multsValid / ok for inventory.

  Intentional non-claims / partial parity:
  - PARTIAL: host Bool inventory vs freestanding product compile of .slake/.lean
    source files (no filesystem unit walk here; Lake elaborates this module).
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not a full Slake compiler body. Not residual free.
  - Classic Lean elaborator still has managed runtime residual (host != product wire).

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_COMPILE_PATH_V1, HOST-COMPILE-PATH,
  COMPILE-PATH, FAIL-CLOSED, RUNTIME-FS, EMIT-BOUNDARY, EMPTY-PROGRAM-FAIL-CLOSED,
  MULT-0, MULT-1, MULT-OMEGA, HOST-COMPOSE, ORDERED-IR-PROGRAM, compileReady,
  unitCompileReady, programCompileReady, gradeSurfaceOk, COMPILE-PATH-SMOKE
  UNIT_SURFACE host surface. Module: SystemsLean.CompilePath
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.IrProgram
import SystemsLean.HostCompose
import SystemsLean.Extract

namespace SystemsLean.CompilePath

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind typeTagInit)
open SystemsLean.IrProgram (Program)
open SystemsLean.HostCompose (Host)
open SystemsLean.Extract (RuntimeClaim)

/-- Greppable stage id for host-informed compile path (beyond V0 structure). -/
def stageId : String := "SLAKE_COMPILE_PATH_V1"

/-- Greppable alias for stage honesty (HOST-COMPILE-PATH). -/
def hostCompilePathId : String := "HOST-COMPILE-PATH"

/-- gradeSurfaceOk -- closed Mult surface canary (no multiplicity zoo).
    Host-independent constant: checks Mult constructors + raw tags 0/1/2 and
    rejects tag 3 (FAIL-CLOSED-UNKNOWN-GRADE). Not a walk of hc graph nodes;
    per-host node mult pre-scan remains HostCompose.multPreScan via extractOkFs. -/
def gradeSurfaceOk : Bool :=
  Mult.isValid Mult.mult0
    && Mult.isValid Mult.mult1
    && Mult.isValid Mult.multOmega
    && Mult.isValidTag 0
    && Mult.isValidTag 1
    && Mult.isValidTag 2
    && !Mult.isValidTag 3

/-- COMPILE-PATH readiness verdict (inventory; not product C).
    ok is the overall fail-closed bar used by unitCompileReady. -/
structure Verdict where
  hostChecked : Bool
  extractFs : Bool
  multsValid : Bool
  ok : Bool
  deriving DecidableEq, Repr

/-- Fail-closed zeroed verdict. -/
def Verdict.failClosed : Verdict := {
  hostChecked := false
  extractFs := false
  multsValid := false
  ok := false
}

/-- checkHost hc -- HostCompose fail-closed bar (graph well-typed + multPreScan).
    Greppable: FAIL-CLOSED, HOST-COMPOSE, multPreScan. -/
def checkHost (hc : Host) : Bool :=
  HostCompose.checkFailClosed hc

/-- extractFsOk hc -- product extract under RUNTIME-FS only (EMIT-BOUNDARY).
    EDGE-RUNTIME / RUNTIME-CLASSIC reject via HostCompose.extractOk. -/
def extractFsOk (hc : Host) : Bool :=
  HostCompose.extractOkFs hc

/-- compileReady hc -- host-informed compile-path readiness (SLAKE_COMPILE_PATH_V1).
    FAIL-CLOSED: HostCompose.extractOkFs (checkFailClosed + RUNTIME-FS).
    Empty compose is OK (vacuous mult pre-scan; matches HOST-SMOKE).
    Does not emit C. Does not claim freestanding residual free. -/
def compileReady (hc : Host) : Bool :=
  extractFsOk hc

/-- programCompileReady p -- ordered IR program well-typed for compile path.
    EMPTY-PROGRAM-FAIL-CLOSED: empty program is not compile-ready as a program
    (distinct from empty HostCompose, which is extract-OK). -/
def programCompileReady (p : Program) : Bool :=
  IrProgram.isWellTyped p

/-- unitCompileReady hc -- full host unit compile-path bar.
    compileReady + gradeSurfaceOk canary (not programCompileReady; sibling API).
    Greppable: unitCompileReady, HOST-COMPILE-PATH. -/
def unitCompileReady (hc : Host) : Bool :=
  compileReady hc && gradeSurfaceOk

/-- verdictOf hc -- inventory Verdict from host compose (not product C).
    ok == unitCompileReady hc. -/
def verdictOf (hc : Host) : Verdict :=
  let hostChecked := checkHost hc
  let extractFs := extractFsOk hc
  let multsValid := gradeSurfaceOk
  {
    hostChecked := hostChecked
    extractFs := extractFs
    multsValid := multsValid
    ok := extractFs && multsValid
  }

/-- extractClaimOk hc claim -- compile path respects RuntimeClaim (EMIT-BOUNDARY).
    Only RUNTIME-FS can be compile-path product ready. -/
def extractClaimOk (hc : Host) (claim : RuntimeClaim) : Bool :=
  HostCompose.extractOk hc claim

/-! ### Compile-path smoke (behavioral; lake build fails if an example does not hold)
    Greppable: COMPILE-PATH-SMOKE. Exercises empty OK, MULT-1 mint, empty program
    fail-closed, RUNTIME-FS only, grade surface, foldWellTyped. -/

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

/-- COMPILE-PATH-SMOKE: stage ids are greppable honesty strings. -/
example : stageId = "SLAKE_COMPILE_PATH_V1" := by decide
example : hostCompilePathId = "HOST-COMPILE-PATH" := by decide

/-- COMPILE-PATH-SMOKE: min Mult grade surface closed; raw tag 3 rejected. -/
example : gradeSurfaceOk = true := by decide

/-- COMPILE-PATH-SMOKE: empty HostCompose is compile-ready under RUNTIME-FS. -/
example : compileReady HostCompose.empty = true := by decide
example : unitCompileReady HostCompose.empty = true := by decide
example :
    (let v := verdictOf HostCompose.empty
     v.ok && v.hostChecked && v.extractFs && v.multsValid) = true := by decide

/-- COMPILE-PATH-SMOKE: empty ordered program is NOT program-compile-ready. -/
example : programCompileReady IrProgram.empty = false := by decide

/-- COMPILE-PATH-SMOKE: MULT-OMEGA-only host is compile-ready without mint. -/
example : unitCompileReady (smokePush HostCompose.empty smokeValueNode) = true := by
  decide

/-- COMPILE-PATH-SMOKE: MULT-1 without mint fails compile-ready (multPreScan). -/
example : compileReady (smokePush HostCompose.empty smokeLinearNode) = false := by
  decide
example :
    (let v := verdictOf (smokePush HostCompose.empty smokeLinearNode)
     !v.ok && !v.hostChecked && !v.extractFs && v.multsValid) = true := by decide

/-- COMPILE-PATH-SMOKE: MULT-1 with mint is unit compile-ready. -/
example :
    unitCompileReady (smokeMint (smokePush HostCompose.empty smokeLinearNode) 4) = true := by
  decide

/-- COMPILE-PATH-SMOKE: MULT-0 without mark fails; with markErased ok. -/
example : compileReady (smokePush HostCompose.empty smokeErasedNode) = false := by
  decide
example :
    compileReady (HostCompose.markErased (smokePush HostCompose.empty smokeErasedNode))
      = true := by decide

/-- COMPILE-PATH-SMOKE: RUNTIME-CLASSIC / EDGE-RUNTIME reject (EMIT-BOUNDARY). -/
example :
    extractClaimOk HostCompose.empty RuntimeClaim.runtimeClassic = false := by decide
example :
    extractClaimOk HostCompose.empty RuntimeClaim.edgeRuntime = false := by decide
example :
    extractClaimOk HostCompose.empty RuntimeClaim.runtimeFs = true := by decide

/-- COMPILE-PATH-SMOKE: well-typed non-empty program is program-compile-ready;
    foldWellTyped yields some count. -/
example :
    (let p := smokePushProg IrProgram.empty smokeValueNode
     programCompileReady p
       && (match IrProgram.foldWellTyped p (0 : Nat) (fun acc _ => acc + 1) with
           | some n => decide (n = 1)
           | none => false)) = true := by decide

/-- COMPILE-PATH-SMOKE: foldWellTyped on empty program is none (fail-closed). -/
example :
    (match IrProgram.foldWellTyped IrProgram.empty (0 : Nat) (fun acc _ => acc + 1) with
     | none => true
     | some _ => false) = true := by decide

end SystemsLean.CompilePath
