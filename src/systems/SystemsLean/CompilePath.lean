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

  Theorems (COMPILE-PATH-THEOREM / HOST-COMPILE-PATH-THEOREM -- partial only):
  - gradeSurfaceOk_true: closed Mult grade canary holds.
  - compileReady_empty_true / unitCompileReady_empty_true: empty HostCompose OK.
  - programCompileReady_empty_false: EMPTY-PROGRAM-FAIL-CLOSED on program bar.
  - programCompileReady_eq_isWellTyped: program bar is IrProgram.isWellTyped.
  - empty_host_ok_ne_empty_program_ok: empty host OK != empty program OK.
  - stageId_eq / hostCompilePathId_eq / extractFsOk_eq / compileReady_eq_extractFsOk
  - unitCompileReady_eq / extractClaimOk classic-edge reject + fs accept on empty
  - verdictOf_empty_ok / programCompileReady_single_value
  - compileReady_mult1_unminted_false / unitCompileReady_mult1_minted_true
  These CompilePath theorems do NOT set SpecProof.proofCompleteClaimed true.
  Partial theorems on CompilePath != host proof complete != residual free.

  Intentional non-claims / partial parity:
  - PARTIAL: host Bool inventory vs freestanding product compile of .slake/.lean
    source files (no filesystem unit walk here; Lake elaborates this module).
  - Not freestanding residual free. Not product C residual free.
  - Not PROVABLY. Not freestanding emit residual free.
  - Not a full Slake compiler body. Not residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator still has managed runtime residual (host != product wire).

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_COMPILE_PATH_V1, HOST-COMPILE-PATH,
  COMPILE-PATH, FAIL-CLOSED, RUNTIME-FS, EMIT-BOUNDARY, EMPTY-PROGRAM-FAIL-CLOSED,
  MULT-0, MULT-1, MULT-OMEGA, HOST-COMPOSE, ORDERED-IR-PROGRAM, compileReady,
  unitCompileReady, programCompileReady, gradeSurfaceOk, COMPILE-PATH-SMOKE,
  COMPILE-PATH-THEOREM, HOST-COMPILE-PATH-THEOREM, compileReady_empty_true,
  unitCompileReady_empty_true, programCompileReady_empty_false,
  programCompileReady_eq_isWellTyped, gradeSurfaceOk_true,
  empty_host_ok_ne_empty_program_ok, stageId_eq, hostCompilePathId_eq,
  extractFsOk_eq, compileReady_eq_extractFsOk, unitCompileReady_eq,
  extractClaimOk_classic_empty_false, extractClaimOk_edge_empty_false,
  extractClaimOk_fs_empty_true, verdictOf_empty_ok,
  programCompileReady_single_value, compileReady_mult1_unminted_false,
  unitCompileReady_mult1_minted_true
  UNIT_SURFACE host surface. Module: SystemsLean.CompilePath
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.IrProgram
import SystemsLean.Erasure
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

/-! ### COMPILE-PATH-THEOREM / HOST-COMPILE-PATH-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is empty-host
  vs empty-program readiness honesty only. Does not complete SpecProof; does
  not claim residual free / freestanding product self-host complete / PROVABLY.
-/

/-- Closed Mult grade surface canary holds.
    Greppable: gradeSurfaceOk_true, COMPILE-PATH-THEOREM. -/
theorem gradeSurfaceOk_true : gradeSurfaceOk = true := by decide

/-- Empty HostCompose is compile-ready under RUNTIME-FS.
    Greppable: compileReady_empty_true, COMPILE-PATH-THEOREM, HOST-COMPILE-PATH-THEOREM. -/
theorem compileReady_empty_true : compileReady HostCompose.empty = true := by decide

/-- Empty HostCompose is unit compile-ready (compileReady + gradeSurfaceOk).
    Greppable: unitCompileReady_empty_true, COMPILE-PATH-THEOREM, HOST-COMPILE-PATH-THEOREM. -/
theorem unitCompileReady_empty_true : unitCompileReady HostCompose.empty = true := by decide

/-- programCompileReady is definitionally IrProgram.isWellTyped.
    Greppable: programCompileReady_eq_isWellTyped, COMPILE-PATH-THEOREM. -/
theorem programCompileReady_eq_isWellTyped (p : Program) :
    programCompileReady p = IrProgram.isWellTyped p := rfl

/-- EMPTY-PROGRAM-FAIL-CLOSED on program compile bar.
    Greppable: programCompileReady_empty_false, EMPTY-PROGRAM-FAIL-CLOSED,
    COMPILE-PATH-THEOREM, HOST-COMPILE-PATH-THEOREM. -/
theorem programCompileReady_empty_false :
    programCompileReady IrProgram.empty = false := rfl

/-- Honesty: empty host OK is not the same as empty program OK.
    Greppable: empty_host_ok_ne_empty_program_ok, COMPILE-PATH-THEOREM,
    HOST-COMPILE-PATH-THEOREM. -/
theorem empty_host_ok_ne_empty_program_ok :
    (compileReady HostCompose.empty = true)
      /\ (programCompileReady IrProgram.empty = false) :=
  And.intro compileReady_empty_true programCompileReady_empty_false

/-- Greppable stage-id honesty only (not path-depth content). Primary path
    contracts are extractClaimOk / mult1 / single-value program theorems below.
    Greppable: stageId_eq, COMPILE-PATH-THEOREM, HOST-COMPILE-PATH-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_COMPILE_PATH_V1" := rfl

/-- Greppable host-alias honesty only (not path-depth content).
    Greppable: hostCompilePathId_eq, COMPILE-PATH-THEOREM. -/
theorem hostCompilePathId_eq : hostCompilePathId = "HOST-COMPILE-PATH" := rfl

/-- extractFsOk is definitionally HostCompose.extractOkFs.
    Greppable: extractFsOk_eq, RUNTIME-FS, COMPILE-PATH-THEOREM. -/
theorem extractFsOk_eq (hc : Host) :
    extractFsOk hc = HostCompose.extractOkFs hc := rfl

/-- compileReady is definitionally extractFsOk (RUNTIME-FS extract bar).
    Greppable: compileReady_eq_extractFsOk, COMPILE-PATH-THEOREM. -/
theorem compileReady_eq_extractFsOk (hc : Host) :
    compileReady hc = extractFsOk hc := rfl

/-- unitCompileReady is definitionally compileReady && gradeSurfaceOk.
    Greppable: unitCompileReady_eq, COMPILE-PATH-THEOREM. -/
theorem unitCompileReady_eq (hc : Host) :
    unitCompileReady hc = (compileReady hc && gradeSurfaceOk) := rfl

/-- RUNTIME-CLASSIC rejects empty compose on compile-path extractClaimOk.
    Greppable: extractClaimOk_classic_empty_false, EMIT-BOUNDARY,
    COMPILE-PATH-THEOREM, HOST-COMPILE-PATH-THEOREM. -/
theorem extractClaimOk_classic_empty_false :
    extractClaimOk HostCompose.empty RuntimeClaim.runtimeClassic = false := by
  decide

/-- EDGE-RUNTIME rejects empty compose on compile-path extractClaimOk.
    Greppable: extractClaimOk_edge_empty_false, EMIT-BOUNDARY,
    COMPILE-PATH-THEOREM, HOST-COMPILE-PATH-THEOREM. -/
theorem extractClaimOk_edge_empty_false :
    extractClaimOk HostCompose.empty RuntimeClaim.edgeRuntime = false := by
  decide

/-- RUNTIME-FS accepts empty compose on compile-path extractClaimOk.
    Greppable: extractClaimOk_fs_empty_true, RUNTIME-FS, COMPILE-PATH-THEOREM. -/
theorem extractClaimOk_fs_empty_true :
    extractClaimOk HostCompose.empty RuntimeClaim.runtimeFs = true := by decide

/-- Empty-host inventory verdict is ok (unit bar).
    Greppable: verdictOf_empty_ok, COMPILE-PATH-THEOREM. -/
theorem verdictOf_empty_ok : (verdictOf HostCompose.empty).ok = true := by decide

/-! ### Non-empty path contracts (beyond empty host vs empty program) -/

private def thmValueNode : IrNode :=
  { ty := typeTagInit 2, mult := Mult.multOmega, kind := NodeKind.value }

private def thmLinearNode : IrNode :=
  { ty := typeTagInit 1, mult := Mult.mult1, kind := NodeKind.linear }

private def thmSingleValueProg : Program := { nodes := [thmValueNode] }

private def thmHostMult1Unminted : Host := {
  graph := { prog := { nodes := [thmLinearNode] }, edges := [] }
  linear := HostCompose.LinearHost.empty
  erased := Erasure.unmarked
}

private def thmHostMult1Minted : Host := {
  graph := { prog := { nodes := [thmLinearNode] }, edges := [] }
  linear := { live := true, id := 4 }
  erased := Erasure.unmarked
}

/-- One well-typed VALUE node is program-compile-ready (sibling of empty fail).
    Greppable: programCompileReady_single_value, COMPILE-PATH-THEOREM,
    HOST-COMPILE-PATH-THEOREM. -/
theorem programCompileReady_single_value :
    programCompileReady thmSingleValueProg = true := by decide

/-- MULT-1 host without mint fails compileReady (multPreScan via extractOkFs).
    Greppable: compileReady_mult1_unminted_false, MULT-1, COMPILE-PATH-THEOREM,
    HOST-COMPILE-PATH-THEOREM. -/
theorem compileReady_mult1_unminted_false :
    compileReady thmHostMult1Unminted = false := by decide

/-- MULT-1 host with mint is unit-compile-ready (unit bar + grade surface).
    Greppable: unitCompileReady_mult1_minted_true, MULT-1, COMPILE-PATH-THEOREM,
    HOST-COMPILE-PATH-THEOREM. -/
theorem unitCompileReady_mult1_minted_true :
    unitCompileReady thmHostMult1Minted = true := by decide

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
