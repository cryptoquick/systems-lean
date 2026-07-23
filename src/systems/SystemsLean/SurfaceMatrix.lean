/-
  SYSTEMS_LEAN_HOST partial -- host-side superset surface matrix (P7).
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): SystemsLean.SelfHost self-host direction readiness
    (sibling unit/program bars), JoinMap JOIN-ALG dual cite, CompilePath,
    Mult/Linear/Types/IrProgram/IrGraph/Erasure/Extract/HostCompose/Emit*
    host ladder. Dual cite paths (read-only; do not reimplement):
    ConsumeToken, ErasedIndex, UnrestrictedShare under src/idris2/examples/
    and src/lean4/examples/. Inventory prose: src/systems/surface-matrix.md.

  Spec (readable, separate from any future proof):
  - SLAKE_SURFACE_MATRIX_V0 / HOST-SURFACE-MATRIX / SURFACE-MATRIX: host
    inventory of progressive surface coverage vs open gaps (useful dual cores).
  - matrixSurfaceOk: surface-level canary (stage ids + dual cites + row status
    inventory strings). Not FS walk; not full language feature implement.
  - matrixUnitReady hc: SelfHost.selfHostUnitReady && matrixSurfaceOk
    (FAIL-CLOSED composition; reuses self-host / join / unit bar APIs).
  - matrixProgramReady p: SelfHost.selfHostProgramReady && matrixSurfaceOk
    (sibling API; EMPTY-PROGRAM-FAIL-CLOSED preserved; empty host OK != empty
    program OK).
  - matrixReady hc: alias of matrixUnitReady (HOST-SURFACE-MATRIX unit bar).
  - Verdict records selfHostUnit / pure unitReady / matrixSurface / ok.

  Theorems (SURFACE-MATRIX-THEOREM / HOST-SURFACE-MATRIX-THEOREM -- partial
  SurfaceMatrix):
  - matrixSurfaceOk_true / matrixUnitReady_empty_true /
    matrixProgramReady_empty_false / stageId_eq / hostSurfaceMatrixId_eq /
    surfaceMatrixId_eq / empty_host_ok_ne_empty_program_ok
  - matrixUnitReady_mult1_unminted_false / matrixUnitReady_mult1_minted_true
  - matrixProgramReady_single_value (path fixtures; SelfHost sibling pattern)
  These SurfaceMatrix theorems do NOT set SpecProof.proofCompleteClaimed true.
  Surface inventory readiness canaries != freestanding product self-host complete.

  Intentional non-claims / partial parity:
  - PARTIAL: inventory + progressive host gate, not day-one full Idris+Lean
    parity or "superset complete".
  - Open rows stay open: full syntax surface, full elaborator, freestanding
    product self-host, llvm, PROVABLY, full Idris parity, full Lean parity.
  - Duals cited only (three JOIN-ALG algorithm examples); no dual invent.
  - Not residual free. Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Does not fold program bar into unit bar (sibling APIs; P3 residual lesson).
  - Does not unlock out/llvm-ir (still deferred until true self-host).

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SURFACE_MATRIX_V0, HOST-SURFACE-MATRIX,
  SURFACE-MATRIX, matrixUnitReady, matrixProgramReady, matrixReady,
  matrixSurfaceOk, SURFACE-MATRIX-SMOKE, HOST-SELF-HOST, SLAKE_SELF_HOST_V0,
  HOST-JOIN-MAP, HOST-COMPILE-PATH, MULT-0, MULT-1, MULT-OMEGA, JOIN-ALG,
  ConsumeToken, ErasedIndex, UnrestrictedShare, present-partial, open,
  EMPTY-PROGRAM-FAIL-CLOSED, FAIL-CLOSED, SURFACE-MATRIX-THEOREM,
  HOST-SURFACE-MATRIX-THEOREM, matrixUnitReady_empty_true,
  matrixProgramReady_empty_false, matrixUnitReady_mult1_unminted_false,
  matrixUnitReady_mult1_minted_true, matrixProgramReady_single_value,
  UNIT_SURFACE host surface.
  Module: SystemsLean.SurfaceMatrix
  Red/green: just systems-host (nix/systems-host-presence/; flake checks.systems-host-presence); lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.Types
import SystemsLean.IrProgram
import SystemsLean.Erasure
import SystemsLean.HostCompose
import SystemsLean.CompilePath
import SystemsLean.JoinMap
import SystemsLean.SelfHost

namespace SystemsLean.SurfaceMatrix

open SystemsLean.Mult (Mult)
open SystemsLean.Types (IrNode NodeKind typeTagInit)
open SystemsLean.IrProgram (Program)
open SystemsLean.HostCompose (Host)

/-- Greppable primary stage id for host surface matrix (P7). -/
def stageId : String := "SLAKE_SURFACE_MATRIX_V0"

/-- Greppable host alias for surface-matrix honesty (HOST-SURFACE-MATRIX). -/
def hostSurfaceMatrixId : String := "HOST-SURFACE-MATRIX"

/-- Greppable short map id (SURFACE-MATRIX). -/
def surfaceMatrixId : String := "SURFACE-MATRIX"

/-- Read-only inventory doc path cite (not a filesystem read). -/
def inventoryDocPath : String := "src/systems/surface-matrix.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/SurfaceMatrix.lean"

/-- Read-only package root path cite (not a filesystem read). -/
def packageRootPath : String := "src/systems/SystemsLean.lean"

/-! ### Dual cite paths (three JOIN-ALG algorithm examples; read-only) -/

def dualConsumeTokenIdris : String := "src/idris2/examples/ConsumeToken.idr"
def dualConsumeTokenLean : String := "src/lean4/examples/ConsumeToken.lean"
def dualErasedIndexIdris : String := "src/idris2/examples/ErasedIndex.idr"
def dualErasedIndexLean : String := "src/lean4/examples/ErasedIndex.lean"
def dualUnrestrictedShareIdris : String := "src/idris2/examples/UnrestrictedShare.idr"
def dualUnrestrictedShareLean : String := "src/lean4/examples/UnrestrictedShare.lean"

/-- dualCiteOk -- three JOIN-ALG dual-pair path cites match layout.
    Surface-level constant canary only (not an FS walk of dual trees).
    Greppable: ConsumeToken, ErasedIndex, UnrestrictedShare, JOIN-ALG. -/
def dualCiteOk : Bool :=
  (dualConsumeTokenIdris == "src/idris2/examples/ConsumeToken.idr")
    && (dualConsumeTokenLean == "src/lean4/examples/ConsumeToken.lean")
    && (dualErasedIndexIdris == "src/idris2/examples/ErasedIndex.idr")
    && (dualErasedIndexLean == "src/lean4/examples/ErasedIndex.lean")
    && (dualUnrestrictedShareIdris == "src/idris2/examples/UnrestrictedShare.idr")
    && (dualUnrestrictedShareLean == "src/lean4/examples/UnrestrictedShare.lean")

/-! ### Matrix row status vocabulary (inventory strings; not product C) -/

/-- Row present on host as progressive partial (not full parity). -/
def statusPresentPartial : String := "present-partial"

/-- Row open / not claimed (full feature, parity, or deferred track). -/
def statusOpen : String := "open"

/-- Multiplicity surface MULT-0 / MULT-1 / MULT-OMEGA (host Mult). -/
def rowMult : String := statusPresentPartial

/-- Linear / JOIN-ALG duals (ConsumeToken host + ErasedIndex/UnrestrictedShare cite). -/
def rowLinearJoin : String := statusPresentPartial

/-- Typed IR / ordered program / graph edges (Types + IrProgram + IrGraph). -/
def rowTypedIrProgramGraph : String := statusPresentPartial

/-- Erasure + extract (MULT-0 erase; RUNTIME-FS extract honesty). -/
def rowEraseExtract : String := statusPresentPartial

/-- Host compose (graph + linear + erasure; multPreScan). -/
def rowHostCompose : String := statusPresentPartial

/-- Emit plan / apply / body honesty (HOST-EMIT-SSOT fragment; frozen wire). -/
def rowEmitPlanApplyBody : String := statusPresentPartial

/-- Compile path host readiness (HOST-COMPILE-PATH V1; V0 structure remains). -/
def rowCompilePath : String := statusPresentPartial

/-- Join map into Slake (HOST-JOIN-MAP; duals cite only). -/
def rowJoinMap : String := statusPresentPartial

/-- Self-host direction readiness (HOST-SELF-HOST; not self-host complete). -/
def rowSelfHostDirection : String := statusPresentPartial

/-- Full Idris 2 / Lean 4 syntax surface (not claimed day-one). -/
def rowSyntaxSurface : String := statusOpen

/-- Full classic elaborator parity (not claimed). -/
def rowFullElaborator : String := statusOpen

/-- Freestanding product self-host complete (not claimed): HOST-SELF-HOST
    direction + SH5 SelfApply host-structural only; freestanding product
    self-host complete still open; SH6 held. Do not flip to present-partial. -/
def rowFreestandingSelfHost : String := statusOpen

/-- out/llvm-ir pipeline (deferred; SH6 held until true freestanding product
    self-host; SH5 host-structural kernelRebuildsKernel does not unlock). -/
def rowLlvm : String := statusOpen

/-- CompCert PROVABLY (needs real ccomp + matrix; never forge). -/
def rowProvably : String := statusOpen

/-- Full Idris 2 core parity (not claimed; progressive gates only). -/
def rowFullIdrisParity : String := statusOpen

/-- Full Lean 4 core parity (not claimed; progressive gates only). -/
def rowFullLeanParity : String := statusOpen

/-- hostRowsPresentPartialOk -- host progressive rows are present-partial. -/
def hostRowsPresentPartialOk : Bool :=
  (rowMult == statusPresentPartial)
    && (rowLinearJoin == statusPresentPartial)
    && (rowTypedIrProgramGraph == statusPresentPartial)
    && (rowEraseExtract == statusPresentPartial)
    && (rowHostCompose == statusPresentPartial)
    && (rowEmitPlanApplyBody == statusPresentPartial)
    && (rowCompilePath == statusPresentPartial)
    && (rowJoinMap == statusPresentPartial)
    && (rowSelfHostDirection == statusPresentPartial)

/-- openRowsOpenOk -- open / not-claimed rows stay open (honesty). -/
def openRowsOpenOk : Bool :=
  (rowSyntaxSurface == statusOpen)
    && (rowFullElaborator == statusOpen)
    && (rowFreestandingSelfHost == statusOpen)
    && (rowLlvm == statusOpen)
    && (rowProvably == statusOpen)
    && (rowFullIdrisParity == statusOpen)
    && (rowFullLeanParity == statusOpen)

/-- matrixSurfaceOk -- stage / dual / row-status inventory canary.
    Surface-level only (not implementing missing language features).
    Greppable: matrixSurfaceOk, SURFACE-MATRIX, present-partial, open. -/
def matrixSurfaceOk : Bool :=
  (stageId == "SLAKE_SURFACE_MATRIX_V0")
    && (hostSurfaceMatrixId == "HOST-SURFACE-MATRIX")
    && (surfaceMatrixId == "SURFACE-MATRIX")
    && (inventoryDocPath == "src/systems/surface-matrix.md")
    && (hostModulePath == "src/systems/SystemsLean/SurfaceMatrix.lean")
    && (packageRootPath == "src/systems/SystemsLean.lean")
    && dualCiteOk
    && hostRowsPresentPartialOk
    && openRowsOpenOk

/-- SURFACE-MATRIX readiness verdict (inventory; not product C; not superset complete).
    Field layering (JoinMap / SelfHost pattern; not pre-folded):
    - selfHostUnit: SelfHost.selfHostUnitReady (join + host surface; pure call)
    - unitReady: pure CompilePath.unitCompileReady (no join / self-host fold)
    - matrixSurface: matrixSurfaceOk canary only
    - ok: selfHostUnit && matrixSurface (== matrixUnitReady while self-host holds) -/
structure Verdict where
  selfHostUnit : Bool
  unitReady : Bool
  matrixSurface : Bool
  ok : Bool
  deriving DecidableEq, Repr

/-- Fail-closed zeroed verdict. -/
def Verdict.failClosed : Verdict := {
  selfHostUnit := false
  unitReady := false
  matrixSurface := false
  ok := false
}

/-- matrixUnitReady hc -- surface-matrix unit bar (self-host-informed).
    FAIL-CLOSED: SelfHost.selfHostUnitReady && matrixSurfaceOk.
    Reuses self-host unit bar; no parallel type zoo.
    Does not fold programCompileReady (sibling API).
    Greppable: matrixUnitReady, HOST-SURFACE-MATRIX, HOST-SELF-HOST. -/
def matrixUnitReady (hc : Host) : Bool :=
  SelfHost.selfHostUnitReady hc && matrixSurfaceOk

/-- matrixReady hc -- HOST-SURFACE-MATRIX unit bar alias of matrixUnitReady.
    Empty HostCompose is OK when self-host unit bar holds (vacuous mult pre-scan).
    Does not emit C. Does not claim full superset parity or residual free. -/
def matrixReady (hc : Host) : Bool :=
  matrixUnitReady hc

/-- matrixProgramReady p -- surface-matrix program bar (sibling).
    FAIL-CLOSED: SelfHost.selfHostProgramReady && matrixSurfaceOk.
    EMPTY-PROGRAM-FAIL-CLOSED: empty ordered program is not program-ready
    (distinct from empty HostCompose, which is unit-ready under matrix map).
    Greppable: matrixProgramReady, EMPTY-PROGRAM-FAIL-CLOSED. -/
def matrixProgramReady (p : Program) : Bool :=
  SelfHost.selfHostProgramReady p && matrixSurfaceOk

/-- verdictOf hc -- inventory Verdict with layered fields (SelfHost pattern).
    unitReady is pure CompilePath.unitCompileReady (not self-host-pre-folded).
    ok == selfHostUnit && matrixSurface == matrixUnitReady hc.
    Does not fold program bar. -/
def verdictOf (hc : Host) : Verdict :=
  let selfHostUnit := SelfHost.selfHostUnitReady hc
  let unitReady := CompilePath.unitCompileReady hc
  let matrixSurface := matrixSurfaceOk
  {
    selfHostUnit := selfHostUnit
    unitReady := unitReady
    matrixSurface := matrixSurface
    ok := selfHostUnit && matrixSurface
  }

/-! ### SURFACE-MATRIX-THEOREM / HOST-SURFACE-MATRIX-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is surface-matrix
  inventory readiness, empty host unit OK vs empty program fail-closed only.
  Does not complete SpecProof; does not claim residual free / freestanding
  product self-host complete / PROVABLY / llvm unlock / full superset parity.
-/

/-- Primary stage id is greppable SLAKE_SURFACE_MATRIX_V0.
    Greppable: stageId_eq, SURFACE-MATRIX-THEOREM, HOST-SURFACE-MATRIX-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SURFACE_MATRIX_V0" := rfl

/-- Host map id is greppable HOST-SURFACE-MATRIX.
    Greppable: hostSurfaceMatrixId_eq, SURFACE-MATRIX-THEOREM. -/
theorem hostSurfaceMatrixId_eq :
    hostSurfaceMatrixId = "HOST-SURFACE-MATRIX" := rfl

/-- Short map id is greppable SURFACE-MATRIX.
    Greppable: surfaceMatrixId_eq, SURFACE-MATRIX-THEOREM. -/
theorem surfaceMatrixId_eq : surfaceMatrixId = "SURFACE-MATRIX" := rfl

/-- Matrix surface inventory canary holds (stage / dual / row status).
    Greppable: matrixSurfaceOk_true, SURFACE-MATRIX-THEOREM,
    HOST-SURFACE-MATRIX-THEOREM. -/
theorem matrixSurfaceOk_true : matrixSurfaceOk = true := by decide

/-- Empty HostCompose is matrix unit-ready (self-host + surface).
    Greppable: matrixUnitReady_empty_true, HOST-SURFACE-MATRIX,
    SURFACE-MATRIX-THEOREM, HOST-SURFACE-MATRIX-THEOREM. -/
theorem matrixUnitReady_empty_true :
    matrixUnitReady HostCompose.empty = true := by decide

/-- EMPTY-PROGRAM-FAIL-CLOSED on matrix program bar.
    Greppable: matrixProgramReady_empty_false, EMPTY-PROGRAM-FAIL-CLOSED,
    SURFACE-MATRIX-THEOREM, HOST-SURFACE-MATRIX-THEOREM. -/
theorem matrixProgramReady_empty_false :
    matrixProgramReady IrProgram.empty = false := by decide

/-- Honesty: empty host matrix unit OK is not empty program matrix OK.
    Greppable: empty_host_ok_ne_empty_program_ok, SURFACE-MATRIX-THEOREM. -/
theorem empty_host_ok_ne_empty_program_ok :
    matrixUnitReady HostCompose.empty = true
      /\ matrixProgramReady IrProgram.empty = false := by
  exact And.intro matrixUnitReady_empty_true matrixProgramReady_empty_false

/-! ### Non-empty path fixtures (beyond empty host vs empty program canaries)
    SelfHost / JoinMap sibling pattern: MULT-1 mint + single-value program. -/

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

/-- MULT-1 host without mint fails matrix unit-ready (self-host unit fail-closed).
    Greppable: matrixUnitReady_mult1_unminted_false, MULT-1,
    SURFACE-MATRIX-THEOREM, HOST-SURFACE-MATRIX-THEOREM. -/
theorem matrixUnitReady_mult1_unminted_false :
    matrixUnitReady thmHostMult1Unminted = false := by decide

/-- MULT-1 host with mint is matrix unit-ready (self-host unit + matrix surface).
    Greppable: matrixUnitReady_mult1_minted_true, MULT-1,
    SURFACE-MATRIX-THEOREM, HOST-SURFACE-MATRIX-THEOREM. -/
theorem matrixUnitReady_mult1_minted_true :
    matrixUnitReady thmHostMult1Minted = true := by decide

/-- One well-typed VALUE node is matrix program-ready (sibling of empty fail).
    Greppable: matrixProgramReady_single_value, SURFACE-MATRIX-THEOREM,
    HOST-SURFACE-MATRIX-THEOREM. -/
theorem matrixProgramReady_single_value :
    matrixProgramReady thmSingleValueProg = true := by decide

/-! ### Surface-matrix smoke (behavioral; lake build fails if an example does not hold)
    Greppable: SURFACE-MATRIX-SMOKE. Exercises matrix surface canary, dual cites,
    present-partial / open row honesty, empty host OK, empty program fail-closed,
    MULT-1 mint path, sibling bars not conflated. -/

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

/-- SURFACE-MATRIX-SMOKE: stage / map ids are greppable honesty strings. -/
example : stageId = "SLAKE_SURFACE_MATRIX_V0" := by decide
example : hostSurfaceMatrixId = "HOST-SURFACE-MATRIX" := by decide
example : surfaceMatrixId = "SURFACE-MATRIX" := by decide

/-- SURFACE-MATRIX-SMOKE: inventory / module / package path cites match layout. -/
example : inventoryDocPath = "src/systems/surface-matrix.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/SurfaceMatrix.lean" := by decide
example : packageRootPath = "src/systems/SystemsLean.lean" := by decide

/-- SURFACE-MATRIX-SMOKE: three dual cites (ConsumeToken + ErasedIndex + UnrestrictedShare). -/
example : dualCiteOk = true := by decide
example : dualConsumeTokenIdris = "src/idris2/examples/ConsumeToken.idr" := by decide
example : dualErasedIndexLean = "src/lean4/examples/ErasedIndex.lean" := by decide
example :
    dualUnrestrictedShareIdris = "src/idris2/examples/UnrestrictedShare.idr" := by
  decide

/-- SURFACE-MATRIX-SMOKE: host progressive rows present-partial; open rows stay open. -/
example : hostRowsPresentPartialOk = true := by decide
example : openRowsOpenOk = true := by decide
example : rowMult = "present-partial" := by decide
example : rowLinearJoin = "present-partial" := by decide
example : rowSelfHostDirection = "present-partial" := by decide
example : rowSyntaxSurface = "open" := by decide
example : rowFullIdrisParity = "open" := by decide
example : rowFullLeanParity = "open" := by decide
example : rowLlvm = "open" := by decide
example : rowProvably = "open" := by decide
example : matrixSurfaceOk = true := by decide

/-- SURFACE-MATRIX-SMOKE: empty HostCompose is matrix unit-ready (self-host + surface). -/
example : matrixReady HostCompose.empty = true := by decide
example : matrixUnitReady HostCompose.empty = true := by decide
example :
    (let v := verdictOf HostCompose.empty
     v.ok && v.selfHostUnit && v.unitReady && v.matrixSurface) = true := by decide

/-- SURFACE-MATRIX-SMOKE: empty ordered program is NOT matrix program-ready.
    Sibling bar: empty host OK != empty program OK (P3 residual lesson). -/
example : matrixProgramReady IrProgram.empty = false := by decide

/-- SURFACE-MATRIX-SMOKE: MULT-OMEGA-only host is matrix unit-ready without mint. -/
example :
    matrixUnitReady (smokePush HostCompose.empty smokeValueNode) = true := by
  decide

/-- SURFACE-MATRIX-SMOKE: MULT-1 without mint fails matrix unit-ready (multPreScan). -/
example :
    matrixReady (smokePush HostCompose.empty smokeLinearNode) = false := by
  decide
example :
    (let v := verdictOf (smokePush HostCompose.empty smokeLinearNode)
     !v.ok && !v.selfHostUnit && !v.unitReady && v.matrixSurface) = true := by
  decide

/-- SURFACE-MATRIX-SMOKE: MULT-1 with mint is matrix unit-ready. -/
example :
    matrixUnitReady
      (smokeMint (smokePush HostCompose.empty smokeLinearNode) 4) = true := by
  decide

/-- SURFACE-MATRIX-SMOKE: MULT-0 without mark fails; with markErased ok. -/
example :
    matrixReady (smokePush HostCompose.empty smokeErasedNode) = false := by
  decide
example :
    matrixReady
      (HostCompose.markErased (smokePush HostCompose.empty smokeErasedNode))
      = true := by decide

/-- SURFACE-MATRIX-SMOKE: well-typed non-empty program is matrix program-ready. -/
example :
    (let p := smokePushProg IrProgram.empty smokeValueNode
     matrixProgramReady p) = true := by decide

/-- SURFACE-MATRIX-SMOKE: failClosed verdict is not ok. -/
example : Verdict.failClosed.ok = false := by decide

/-- SURFACE-MATRIX-SMOKE: unit bar does not imply program bar on empty program
    (sibling APIs; do not conflate). -/
example :
    (matrixUnitReady HostCompose.empty
      && !matrixProgramReady IrProgram.empty) = true := by decide

/-- SURFACE-MATRIX-SMOKE: matrix unit bar matches self-host unit bar under surface. -/
example :
    (matrixUnitReady HostCompose.empty
      = SelfHost.selfHostUnitReady HostCompose.empty) = true := by decide

/-- SURFACE-MATRIX-SMOKE: JoinMap dual canary still holds under matrix composition. -/
example : JoinMap.joinAlgContractOk = true := by decide

end SystemsLean.SurfaceMatrix
