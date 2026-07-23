/-
  SYSTEMS_LEAN_HOST partial -- freestanding product path readiness
  (after HOST-INVENTORY-CLOSE).
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): InventoryClose.lean inventory close readiness;
    CompilePath.lean unit/program compile bars; KernelEmit.lean lowerEmitCompose
    + emitPlanPathReady / emitApplyPathReady / emitBodyPathReady / emitKernelReady;
    SelfApplyFs.lean freestandingBodyPathReady (HOST-EMIT-SSOT body);
    KernelProgram.lean lowerProgramKernel; JoinMap.lean joinUnitCompileReady /
    joinProgramCompileReady; SelfHost.lean selfHostUnitReady /
    selfHostProgramReady (HOST-SELF-HOST); SurfaceMatrix.lean matrixUnitReady /
    matrixProgramReady (HOST-SURFACE-MATRIX); SelfApplyFs / LlvmHold complete
    and unlock flags; self-host.md acceptance; surface-matrix.md;
    host-partial-inventory.md.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_PRODUCT_PATH_V0 / HOST-PRODUCT-PATH /
    SELF-HOST-PRODUCT-PATH: greppable freestanding product path readiness gate
    beyond inventory close -- real Bool compose on CompilePath unit / program
    bars, KernelEmit plan/apply/body path, JoinMap unit + program join paths,
    SelfHost unit + program direction paths, SurfaceMatrix unit + program paths
    over empty HostCompose / unminted emit compose / lowered kernel emit compose
    (not docs-only canaries).
  - freestandingUnitProductPathReady: fail-closed unit product path honesty
    (RUNTIME-FS / HOST-COMPILE-PATH / extractOkFs):
      empty HostCompose unitCompileReady true + extractOkFs true;
      unminted emit compose unitCompileReady false + extractOkFs false;
      KernelEmit.lowerEmitCompose some + unitCompileReady true + extractOkFs
      true on that host.
  - freestandingProgramProductPathReady: sibling program path honesty
    (EMPTY-PROGRAM-FAIL-CLOSED):
      empty program programCompileReady false;
      KernelProgram.lowerProgramKernel some + programCompileReady true +
      isWellTyped true on that program.
  - freestandingEmitProductPathReady: freestanding emit product path honesty
    (HOST-KERNEL-EMIT / HOST-EMIT-SSOT / HOST-EMIT-MULT) -- reuses existing
    real path bars rather than duplicating theater:
      KernelEmit.emitPlanPathReady (empty/unminted/lowerEmitCompose plan);
      KernelEmit.emitApplyPathReady (empty/unminted/lowerEmitCompose apply);
      KernelEmit.emitBodyPathReady (empty/unminted/lowerEmitCompose body);
      KernelEmit.emitKernelReady (intentional re-assert: plan/apply/body +
      EmitMult.emitMultReady + program kernel + surface);
      SelfApplyFs.freestandingBodyPathReady (HOST-EMIT-SSOT body deepen +
      emitMultReady on same compose).
  - freestandingJoinProductPathReady: freestanding join *unit* product path
    honesty (HOST-JOIN-MAP / joinUnitCompileReady). Dual greppable alias
    freestandingJoinUnitProductPathReady == this def (joint name honesty with
    freestandingJoinProgramProductPathReady sibling):
      empty HostCompose joinUnitCompileReady true;
      unminted emit compose joinUnitCompileReady false;
      KernelEmit.lowerEmitCompose some + joinUnitCompileReady true.
  - freestandingJoinProgramProductPathReady: freestanding join *program*
    product path honesty (HOST-JOIN-MAP / joinProgramCompileReady; sibling of
    freestandingJoinProductPathReady; pattern after freestandingProgramProductPathReady):
      empty program joinProgramCompileReady false (EMPTY-PROGRAM-FAIL-CLOSED);
      KernelProgram.lowerProgramKernel some + joinProgramCompileReady true +
      isWellTyped true on that program.
  - freestandingSelfHostProductPathReady: freestanding self-host *direction*
    *unit* product path honesty (HOST-SELF-HOST / SLAKE_SELF_HOST_V0 /
    selfHostUnitReady). Dual greppable alias freestandingSelfHostUnitProductPathReady
    == this def (joint name honesty with freestandingSelfHostProgramProductPathReady
    sibling). Does NOT claim freestanding product self-host complete:
      empty HostCompose selfHostUnitReady true;
      unminted emit compose selfHostUnitReady false;
      KernelEmit.lowerEmitCompose some + selfHostUnitReady true.
  - freestandingSelfHostProgramProductPathReady: freestanding self-host
    *direction* *program* product path honesty (HOST-SELF-HOST /
    selfHostProgramReady; sibling of freestandingSelfHostProductPathReady):
      empty program selfHostProgramReady false (EMPTY-PROGRAM-FAIL-CLOSED);
      KernelProgram.lowerProgramKernel some + selfHostProgramReady true +
      isWellTyped true on that program.
    Does NOT claim freestanding product self-host complete.
  - freestandingMatrixUnitProductPathReady: freestanding surface-matrix *unit*
    product path honesty (HOST-SURFACE-MATRIX / SLAKE_SURFACE_MATRIX_V0 /
    matrixUnitReady). Open rows stay open; not day-one full Idris+Lean parity:
      empty HostCompose matrixUnitReady true;
      unminted emit compose matrixUnitReady false;
      KernelEmit.lowerEmitCompose some + matrixUnitReady true.
  - freestandingMatrixProgramProductPathReady: freestanding surface-matrix
    *program* product path honesty (HOST-SURFACE-MATRIX / matrixProgramReady;
    sibling of freestandingMatrixUnitProductPathReady):
      empty program matrixProgramReady false (EMPTY-PROGRAM-FAIL-CLOSED);
      KernelProgram.lowerProgramKernel some + matrixProgramReady true +
      isWellTyped true on that program.
  - freestandingProductPathReady: unit path && program path && emit path &&
    join unit path && join program path && self-host unit path && self-host
    program path && matrix unit path && matrix program path (joint freestanding
    product path bar; not freestanding product self-host complete).
  - productPathSurfaceOk: stage ids + product wire cites (RUNTIME-FS,
    EMIT-BOUNDARY, EMIT_BODY_V0, HOST-EMIT-SSOT, HOST-EMIT-MULT) + prior
    HOST-INVENTORY-CLOSE / HOST-SELF-APPLY-FS / HOST-COMPILE-PATH /
    HOST-KERNEL-EMIT / HOST-JOIN-MAP / HOST-SELF-HOST / HOST-SURFACE-MATRIX
    cites -- String canaries.
  - residualFreeClaimed / productSelfHostCompleteClaimed: MUST decide false.
  - productPathReady: InventoryClose.inventoryCloseReady &&
    freestandingUnitProductPathReady && freestandingProgramProductPathReady &&
    freestandingEmitProductPathReady && freestandingJoinProductPathReady &&
    freestandingJoinProgramProductPathReady && freestandingSelfHostProductPathReady &&
    freestandingSelfHostProgramProductPathReady &&
    freestandingMatrixUnitProductPathReady && freestandingMatrixProgramProductPathReady &&
    productPathSurfaceOk && !residual free claimed && !product complete claimed
    && !SelfApplyFs.freestandingProductSelfHostComplete &&
    !LlvmHold.llvmUnlocked && !LlvmHold.provablyUnlocked.
  - productPathDoesNotComplete / productPathDoesNotMeanResidualFree: ready &&
    complete/residual claims stay false.
  - SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0 / HOST-PRODUCT-PATH-CLOSE /
    SELF-HOST-PRODUCT-PATH-CLOSE: structural freestanding product path ladder
    close -- documents unit/program/emit/join/self-host/matrix folds closed at
    productPathReady without forging residual free / product complete / llvm
    unlock. Same module (no 32nd module); greppable close helpers only.
  - productPathCloseSurfaceOk: close stage ids + structural ladder closed token
    + intentional PARTIAL carry cite (String canaries).
  - productPathFurtherAliasTheaterHeld: honesty canary -- further ProductPath
    conjunct-only re-asserts of inventoryCloseReady-implied kernel/parity bars
    alone are not residual progress (held as theater; not residual free claim).
  - productPathLadderClosedOk / productPathCloseReady: productPathReady &&
    productPathCloseSurfaceOk && productPathFurtherAliasTheaterHeld &&
    residual free / complete / unlock claims stay false.
  - productPathCloseDoesNotMeanResidualFree: close ready && !residual free.
  - Host model = structural freestanding product path honesty. Not an AI/ML
    model. Not product C residual free.

  Theorems (PRODUCT-PATH-THEOREM / HOST-PRODUCT-PATH-THEOREM -- partial
  ProductPath only):
  - productPathReady_true / productPathCloseReady_true / residualFreeClaimed_false
  - productPathFurtherAliasTheaterHeld_true / productPathDoesNotMeanResidualFree_true
  - stageId_eq / hostProductPathId_eq
  These ProductPath theorems do NOT set SpecProof.proofCompleteClaimed true.
  residualFreeClaimed stays false; further alias theater held (not residual progress).

  Intentional non-claims / partial:
  - Product path readiness only -- NOT freestanding residual free.
  - Structural ladder close is NOT residual free and NOT product self-host
    complete (close documents path folds only).
  - NOT freestanding product self-host complete (self-host unit + program paths
    are direction honesty only; HOST-SELF-HOST cite does not complete self-host).
  - NOT day-one full Idris+Lean surface parity (HOST-SURFACE-MATRIX open rows
    stay open; matrix path is progressive inventory honesty only).
  - NOT PROVABLY. Does not unlock llvm / out/llvm-ir (LlvmHold still holds).
  - Intentional PARTIAL carry remains (host Bool path honesty vs full product
    freestanding C rebuild of Slake).
  - Further ProductPath alias theater of inventoryCloseReady-implied bars held
    (productPathFurtherAliasTheaterHeld); not residual progress.
  - Does not mint phantom modules. Does not grow bash EMIT_* residual treadmill.
  - No new EMIT_* C stage. Does not grow check.sh.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_PRODUCT_PATH_V0,
  HOST-PRODUCT-PATH, SELF-HOST-PRODUCT-PATH, PRODUCT-PATH-SMOKE,
  HOST-PRODUCT-PATH-SMOKE, SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0,
  HOST-PRODUCT-PATH-CLOSE, SELF-HOST-PRODUCT-PATH-CLOSE,
  PRODUCT-PATH-CLOSE-SMOKE, HOST-PRODUCT-PATH-CLOSE-SMOKE,
  productPathReady, productPathSurfaceOk,
  freestandingUnitProductPathReady, freestandingProgramProductPathReady,
  freestandingEmitProductPathReady, freestandingJoinProductPathReady,
  freestandingJoinUnitProductPathReady, freestandingJoinProgramProductPathReady,
  freestandingSelfHostProductPathReady, freestandingSelfHostUnitProductPathReady,
  freestandingSelfHostProgramProductPathReady, freestandingMatrixUnitProductPathReady,
  freestandingMatrixProgramProductPathReady, freestandingProductPathReady,
  productPathDoesNotComplete, productPathDoesNotMeanResidualFree,
  productPathCloseReady, productPathLadderClosedOk, productPathCloseSurfaceOk,
  productPathCloseDoesNotMeanResidualFree, productPathFurtherAliasTheaterHeld,
  structural product path ladder closed, residualFreeClaimed,
  productSelfHostCompleteClaimed, productPathOk, productPathCloseOk,
  HOST-INVENTORY-CLOSE, HOST-SELF-APPLY-FS, HOST-COMPILE-PATH, HOST-KERNEL-EMIT,
  HOST-JOIN-MAP, HOST-SELF-HOST, HOST-SURFACE-MATRIX, HOST-EMIT-SSOT,
  HOST-EMIT-MULT, inventoryCloseReady, unitCompileReady, programCompileReady,
  extractOkFs, lowerEmitCompose, lowerProgramKernel, emitPlanPathReady,
  emitApplyPathReady, emitBodyPathReady, emitKernelReady, freestandingBodyPathReady,
  joinUnitCompileReady, joinProgramCompileReady, selfHostUnitReady,
  selfHostProgramReady, matrixUnitReady, matrixProgramReady,
  RUNTIME-FS, EMIT-BOUNDARY, EMIT_BODY_V0, EMPTY-PROGRAM-FAIL-CLOSED,
  freestandingProductSelfHostComplete, llvmUnlocked, provablyUnlocked,
  PRODUCT-PATH-THEOREM, HOST-PRODUCT-PATH-THEOREM, productPathReady_true,
  productPathCloseReady_true, residualFreeClaimed_false,
  SELF-HOST, SLAKE_SELF_HOST_V0, SURFACE-MATRIX, SLAKE_SURFACE_MATRIX_V0,
  UNIT_SURFACE host surface.
  Module: SystemsLean.ProductPath
  Not freestanding residual free. Not PROVABLY.
  Not freestanding product self-host complete. Not freestanding emit residual free.
  Not llvm unlocked. Not day-one full Idris+Lean surface parity.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.InventoryClose
import SystemsLean.CompilePath
import SystemsLean.KernelEmit
import SystemsLean.KernelProgram
import SystemsLean.HostCompose
import SystemsLean.IrProgram
import SystemsLean.JoinMap
import SystemsLean.SelfHost
import SystemsLean.SurfaceMatrix
import SystemsLean.SelfApplyFs
import SystemsLean.LlvmHold

namespace SystemsLean.ProductPath

/-- Greppable primary stage id for freestanding product path readiness. -/
def stageId : String := "SLAKE_SELF_HOST_PRODUCT_PATH_V0"

/-- Greppable host map id (HOST-PRODUCT-PATH). -/
def hostProductPathId : String := "HOST-PRODUCT-PATH"

/-- Greppable short map id (SELF-HOST-PRODUCT-PATH). -/
def selfHostProductPathId : String := "SELF-HOST-PRODUCT-PATH"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/ProductPath.lean"

/-- Read-only PARTIAL inventory path cite (not a filesystem read). -/
def inventoryPath : String := "src/systems/host-partial-inventory.md"

/-- Prior inventory close stage cite. -/
def inventoryCloseStageCite : String := "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0"

/-- Prior freestanding self-apply stage cite. -/
def selfApplyFsStageCite : String := "SLAKE_SELF_HOST_SELF_APPLY_FS_V0"

/-- Prior compile-path stage cite. -/
def compilePathStageCite : String := "SLAKE_COMPILE_PATH_V1"

/-- Prior emit kernel stage cite. -/
def kernelEmitStageCite : String := "SLAKE_SELF_HOST_KERNEL_EMIT_V0"

/-- Prior join map stage cite. -/
def joinMapStageCite : String := "SLAKE_JOIN_MAP_V0"

/-- Prior self-host direction stage cite. -/
def selfHostStageCite : String := "SLAKE_SELF_HOST_V0"

/-- Prior surface-matrix stage cite. -/
def surfaceMatrixStageCite : String := "SLAKE_SURFACE_MATRIX_V0"

/-- Prior inventory close host map cite. -/
def hostInventoryCloseCite : String := "HOST-INVENTORY-CLOSE"

/-- Prior freestanding self-apply host map cite. -/
def hostSelfApplyFsCite : String := "HOST-SELF-APPLY-FS"

/-- Prior compile-path host map cite. -/
def hostCompilePathCite : String := "HOST-COMPILE-PATH"

/-- Prior emit kernel host map cite. -/
def hostKernelEmitCite : String := "HOST-KERNEL-EMIT"

/-- Prior join map host map cite. -/
def hostJoinMapCite : String := "HOST-JOIN-MAP"

/-- Prior self-host direction host map cite. -/
def hostSelfHostCite : String := "HOST-SELF-HOST"

/-- Prior surface-matrix host map cite. -/
def hostSurfaceMatrixCite : String := "HOST-SURFACE-MATRIX"

/-- Product wire cites (frozen; no new EMIT_* C stage). -/
def productEmitBodyId : String := "EMIT_BODY_V0"
def productHostEmitSsotId : String := "HOST-EMIT-SSOT"
def productHostEmitMultId : String := "HOST-EMIT-MULT"
def runtimeFsMarker : String := "RUNTIME-FS"
def emitBoundaryMarker : String := "EMIT-BOUNDARY"
def emptyProgramFailClosedMarker : String := "EMPTY-PROGRAM-FAIL-CLOSED"
def surfaceMatrixIdMarker : String := "SURFACE-MATRIX"

/-- Surface canary: stage ids + product wire cites + prior HOST-INVENTORY-CLOSE /
    HOST-SELF-APPLY-FS / HOST-COMPILE-PATH / HOST-KERNEL-EMIT / HOST-JOIN-MAP /
    HOST-SELF-HOST / HOST-SURFACE-MATRIX cites. String canaries only. -/
def productPathSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_PRODUCT_PATH_V0")
    && (hostProductPathId == "HOST-PRODUCT-PATH")
    && (selfHostProductPathId == "SELF-HOST-PRODUCT-PATH")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/ProductPath.lean")
    && (inventoryPath == "src/systems/host-partial-inventory.md")
    && (inventoryCloseStageCite == "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0")
    && (selfApplyFsStageCite == "SLAKE_SELF_HOST_SELF_APPLY_FS_V0")
    && (compilePathStageCite == "SLAKE_COMPILE_PATH_V1")
    && (kernelEmitStageCite == "SLAKE_SELF_HOST_KERNEL_EMIT_V0")
    && (joinMapStageCite == "SLAKE_JOIN_MAP_V0")
    && (selfHostStageCite == "SLAKE_SELF_HOST_V0")
    && (surfaceMatrixStageCite == "SLAKE_SURFACE_MATRIX_V0")
    && (hostInventoryCloseCite == "HOST-INVENTORY-CLOSE")
    && (hostSelfApplyFsCite == "HOST-SELF-APPLY-FS")
    && (hostCompilePathCite == "HOST-COMPILE-PATH")
    && (hostKernelEmitCite == "HOST-KERNEL-EMIT")
    && (hostJoinMapCite == "HOST-JOIN-MAP")
    && (hostSelfHostCite == "HOST-SELF-HOST")
    && (hostSurfaceMatrixCite == "HOST-SURFACE-MATRIX")
    && (productEmitBodyId == "EMIT_BODY_V0")
    && (productHostEmitSsotId == "HOST-EMIT-SSOT")
    && (productHostEmitMultId == "HOST-EMIT-MULT")
    && (runtimeFsMarker == "RUNTIME-FS")
    && (emitBoundaryMarker == "EMIT-BOUNDARY")
    && (emptyProgramFailClosedMarker == "EMPTY-PROGRAM-FAIL-CLOSED")
    && (surfaceMatrixIdMarker == "SURFACE-MATRIX")

/-- freestandingUnitProductPathReady -- freestanding unit product path honesty
    (CompilePath.unitCompileReady / extractOkFs on empty, unminted, lowered emit).
    FAIL-CLOSED real Bools:
      1) empty HostCompose unitCompileReady + extractOkFs true
      2) unminted emit compose unitCompileReady false + extractOkFs false
      3) lowerEmitCompose some + unitCompileReady true + extractOkFs true
    Greppable: freestandingUnitProductPathReady, unitCompileReady, extractOkFs. -/
def freestandingUnitProductPathReady : Bool :=
  let emptyOk :=
    CompilePath.unitCompileReady HostCompose.empty
      && HostCompose.extractOkFs HostCompose.empty
  let unmintedFails :=
    !CompilePath.unitCompileReady KernelEmit.unmintedEmitCompose
      && !HostCompose.extractOkFs KernelEmit.unmintedEmitCompose
  match KernelEmit.lowerEmitCompose with
  | none => false
  | some hc =>
      emptyOk
        && unmintedFails
        && CompilePath.unitCompileReady hc
        && HostCompose.extractOkFs hc

/-- freestandingProgramProductPathReady -- sibling program path honesty
    (EMPTY-PROGRAM-FAIL-CLOSED + well-typed lowered kernel).
    FAIL-CLOSED real Bools:
      1) empty program programCompileReady false
      2) lowerProgramKernel some + programCompileReady + isWellTyped
    Greppable: freestandingProgramProductPathReady, programCompileReady. -/
def freestandingProgramProductPathReady : Bool :=
  let emptyFails := !CompilePath.programCompileReady IrProgram.empty
  match KernelProgram.lowerProgramKernel with
  | none => false
  | some p =>
      emptyFails
        && CompilePath.programCompileReady p
        && IrProgram.isWellTyped p

/-- freestandingEmitProductPathReady -- freestanding emit product path honesty
    (HOST-KERNEL-EMIT plan/apply/body + HOST-EMIT-SSOT body deepen).
    FAIL-CLOSED real Bools (reuse, do not duplicate theater):
      1) KernelEmit.emitPlanPathReady (empty plan OK / unminted fails /
         lowerEmitCompose plan ready with r=2 e=1)
      2) KernelEmit.emitApplyPathReady (empty apply OK / unminted fails /
         tags [2, 17, 32])
      3) KernelEmit.emitBodyPathReady (empty SSOT fragment / unminted fails /
         exact HOST-EMIT-SSOT body)
      4) KernelEmit.emitKernelReady (intentional re-assert of plan/apply/body +
         EmitMult.emitMultReady + programKernelReady + surface)
      5) SelfApplyFs.freestandingBodyPathReady (HOST-EMIT-SSOT body path +
         emitMultReady on same compose; greppable freestanding body bar)
    Greppable: freestandingEmitProductPathReady, emitPlanPathReady,
    emitApplyPathReady, emitBodyPathReady, emitKernelReady,
    freestandingBodyPathReady, HOST-KERNEL-EMIT, HOST-EMIT-SSOT, HOST-EMIT-MULT. -/
def freestandingEmitProductPathReady : Bool :=
  KernelEmit.emitPlanPathReady
    && KernelEmit.emitApplyPathReady
    && KernelEmit.emitBodyPathReady
    && KernelEmit.emitKernelReady
    && SelfApplyFs.freestandingBodyPathReady

/-- freestandingJoinProductPathReady -- freestanding join *unit* product path honesty
    (HOST-JOIN-MAP joinUnitCompileReady on empty / unminted / lowerEmitCompose).
    FAIL-CLOSED real Bools:
      1) empty HostCompose joinUnitCompileReady true
      2) unminted emit compose joinUnitCompileReady false
      3) lowerEmitCompose some + joinUnitCompileReady true
    Sibling: freestandingJoinProgramProductPathReady (program bar; empty program
    fail-closed). Dual greppable alias freestandingJoinUnitProductPathReady.
    Greppable: freestandingJoinProductPathReady, joinUnitCompileReady,
    HOST-JOIN-MAP. -/
def freestandingJoinProductPathReady : Bool :=
  let emptyOk := JoinMap.joinUnitCompileReady HostCompose.empty
  let unmintedFails :=
    !JoinMap.joinUnitCompileReady KernelEmit.unmintedEmitCompose
  match KernelEmit.lowerEmitCompose with
  | none => false
  | some hc =>
      emptyOk && unmintedFails && JoinMap.joinUnitCompileReady hc

/-- freestandingJoinUnitProductPathReady -- dual greppable alias of
    freestandingJoinProductPathReady (joint name honesty with join program sibling).
    Greppable: freestandingJoinUnitProductPathReady. -/
def freestandingJoinUnitProductPathReady : Bool :=
  freestandingJoinProductPathReady

/-- freestandingJoinProgramProductPathReady -- freestanding join *program* product
    path honesty (HOST-JOIN-MAP joinProgramCompileReady; sibling of
    freestandingJoinProductPathReady / freestandingJoinUnitProductPathReady).
    Pattern after freestandingProgramProductPathReady + JoinMap.joinProgramCompileReady.
    FAIL-CLOSED real Bools:
      1) empty program joinProgramCompileReady false (EMPTY-PROGRAM-FAIL-CLOSED)
      2) lowerProgramKernel some + joinProgramCompileReady + isWellTyped
    Does not fold join unit bar (sibling APIs; unit empty host OK != empty program).
    Greppable: freestandingJoinProgramProductPathReady, joinProgramCompileReady,
    EMPTY-PROGRAM-FAIL-CLOSED, HOST-JOIN-MAP. -/
def freestandingJoinProgramProductPathReady : Bool :=
  let emptyFails := !JoinMap.joinProgramCompileReady IrProgram.empty
  match KernelProgram.lowerProgramKernel with
  | none => false
  | some p =>
      emptyFails
        && JoinMap.joinProgramCompileReady p
        && IrProgram.isWellTyped p

/-- freestandingSelfHostProductPathReady -- freestanding self-host *direction*
    *unit* product path honesty (HOST-SELF-HOST / SLAKE_SELF_HOST_V0 /
    selfHostUnitReady). Dual greppable alias freestandingSelfHostUnitProductPathReady.
    FAIL-CLOSED real Bools:
      1) empty HostCompose selfHostUnitReady true
      2) unminted emit compose selfHostUnitReady false
      3) lowerEmitCompose some + selfHostUnitReady true
    Does NOT claim freestanding product self-host complete (direction only).
    Greppable: freestandingSelfHostProductPathReady, selfHostUnitReady,
    HOST-SELF-HOST, SLAKE_SELF_HOST_V0. -/
def freestandingSelfHostProductPathReady : Bool :=
  let emptyOk := SelfHost.selfHostUnitReady HostCompose.empty
  let unmintedFails :=
    !SelfHost.selfHostUnitReady KernelEmit.unmintedEmitCompose
  match KernelEmit.lowerEmitCompose with
  | none => false
  | some hc =>
      emptyOk && unmintedFails && SelfHost.selfHostUnitReady hc

/-- freestandingSelfHostUnitProductPathReady -- dual greppable alias of
    freestandingSelfHostProductPathReady (joint name honesty with self-host
    program sibling). Greppable: freestandingSelfHostUnitProductPathReady. -/
def freestandingSelfHostUnitProductPathReady : Bool :=
  freestandingSelfHostProductPathReady

/-- freestandingSelfHostProgramProductPathReady -- freestanding self-host
    *direction* *program* product path honesty (HOST-SELF-HOST /
    selfHostProgramReady; sibling of freestandingSelfHostProductPathReady /
    freestandingSelfHostUnitProductPathReady).
    Pattern after freestandingProgramProductPathReady + SelfHost.selfHostProgramReady.
    FAIL-CLOSED real Bools:
      1) empty program selfHostProgramReady false (EMPTY-PROGRAM-FAIL-CLOSED)
      2) lowerProgramKernel some + selfHostProgramReady + isWellTyped
    Does NOT claim freestanding product self-host complete (direction only).
    Does not fold self-host unit bar (sibling APIs; unit empty host OK != empty program).
    Greppable: freestandingSelfHostProgramProductPathReady, selfHostProgramReady,
    EMPTY-PROGRAM-FAIL-CLOSED, HOST-SELF-HOST. -/
def freestandingSelfHostProgramProductPathReady : Bool :=
  let emptyFails := !SelfHost.selfHostProgramReady IrProgram.empty
  match KernelProgram.lowerProgramKernel with
  | none => false
  | some p =>
      emptyFails
        && SelfHost.selfHostProgramReady p
        && IrProgram.isWellTyped p

/-- freestandingMatrixUnitProductPathReady -- freestanding surface-matrix *unit*
    product path honesty (HOST-SURFACE-MATRIX / SLAKE_SURFACE_MATRIX_V0 /
    matrixUnitReady). Open matrix rows stay open; not day-one full Idris+Lean
    parity; not residual free.
    FAIL-CLOSED real Bools:
      1) empty HostCompose matrixUnitReady true
      2) unminted emit compose matrixUnitReady false
      3) lowerEmitCompose some + matrixUnitReady true
    Greppable: freestandingMatrixUnitProductPathReady, matrixUnitReady,
    HOST-SURFACE-MATRIX, SLAKE_SURFACE_MATRIX_V0. -/
def freestandingMatrixUnitProductPathReady : Bool :=
  let emptyOk := SurfaceMatrix.matrixUnitReady HostCompose.empty
  let unmintedFails :=
    !SurfaceMatrix.matrixUnitReady KernelEmit.unmintedEmitCompose
  match KernelEmit.lowerEmitCompose with
  | none => false
  | some hc =>
      emptyOk && unmintedFails && SurfaceMatrix.matrixUnitReady hc

/-- freestandingMatrixProgramProductPathReady -- freestanding surface-matrix
    *program* product path honesty (HOST-SURFACE-MATRIX / matrixProgramReady;
    sibling of freestandingMatrixUnitProductPathReady).
    Pattern after freestandingProgramProductPathReady + SurfaceMatrix.matrixProgramReady.
    FAIL-CLOSED real Bools:
      1) empty program matrixProgramReady false (EMPTY-PROGRAM-FAIL-CLOSED)
      2) lowerProgramKernel some + matrixProgramReady + isWellTyped
    Open matrix rows stay open; not day-one full Idris+Lean parity.
    Greppable: freestandingMatrixProgramProductPathReady, matrixProgramReady,
    EMPTY-PROGRAM-FAIL-CLOSED, HOST-SURFACE-MATRIX. -/
def freestandingMatrixProgramProductPathReady : Bool :=
  let emptyFails := !SurfaceMatrix.matrixProgramReady IrProgram.empty
  match KernelProgram.lowerProgramKernel with
  | none => false
  | some p =>
      emptyFails
        && SurfaceMatrix.matrixProgramReady p
        && IrProgram.isWellTyped p

/-- freestandingProductPathReady -- joint unit + program + emit + join unit +
    join program + self-host unit + self-host program + matrix unit + matrix
    program freestanding product path.
    Greppable: freestandingProductPathReady. -/
def freestandingProductPathReady : Bool :=
  freestandingUnitProductPathReady
    && freestandingProgramProductPathReady
    && freestandingEmitProductPathReady
    && freestandingJoinProductPathReady
    && freestandingJoinProgramProductPathReady
    && freestandingSelfHostProductPathReady
    && freestandingSelfHostProgramProductPathReady
    && freestandingMatrixUnitProductPathReady
    && freestandingMatrixProgramProductPathReady

/-- residualFreeClaimed -- MUST decide false (product path is not residual free).
    Greppable: residualFreeClaimed. -/
def residualFreeClaimed : Bool := false

/-- productSelfHostCompleteClaimed -- MUST decide false (still open).
    Greppable: productSelfHostCompleteClaimed. -/
def productSelfHostCompleteClaimed : Bool := false

/-- productPathReady -- freestanding product path bar after inventory close.
    FAIL-CLOSED: inventoryCloseReady && unit path && program path && emit path &&
    join unit path && join program path && self-host unit path && self-host
    program path && matrix unit path && matrix program path && surface &&
    residual free / product complete / llvm unlock claims stay false.
    Honest scope: freestanding product path readiness only -- NOT residual free,
    NOT freestanding product self-host complete, NOT llvm unlock, NOT PROVABLY,
    NOT day-one full Idris+Lean surface parity.
    Greppable: productPathReady, HOST-PRODUCT-PATH. -/
def productPathReady : Bool :=
  InventoryClose.inventoryCloseReady
    && freestandingUnitProductPathReady
    && freestandingProgramProductPathReady
    && freestandingEmitProductPathReady
    && freestandingJoinProductPathReady
    && freestandingJoinProgramProductPathReady
    && freestandingSelfHostProductPathReady
    && freestandingSelfHostProgramProductPathReady
    && freestandingMatrixUnitProductPathReady
    && freestandingMatrixProgramProductPathReady
    && productPathSurfaceOk
    && !residualFreeClaimed
    && !productSelfHostCompleteClaimed
    && !SelfApplyFs.freestandingProductSelfHostComplete
    && !LlvmHold.llvmUnlocked
    && !LlvmHold.provablyUnlocked

/-- productPathDoesNotComplete -- product path ready does NOT complete freestanding
    product self-host. Greppable: productPathDoesNotComplete. -/
def productPathDoesNotComplete : Bool :=
  productPathReady && !productSelfHostCompleteClaimed
    && !SelfApplyFs.freestandingProductSelfHostComplete

/-- productPathDoesNotMeanResidualFree -- product path ready does NOT claim
    freestanding residual free. Greppable: productPathDoesNotMeanResidualFree. -/
def productPathDoesNotMeanResidualFree : Bool :=
  productPathReady && !residualFreeClaimed

/-- Full product path ok (alias of productPathReady for inventory greps). -/
def productPathOk : Bool := productPathReady

/-! ### HOST-PRODUCT-PATH-CLOSE -- structural product path ladder close
    Greppable: SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0, HOST-PRODUCT-PATH-CLOSE,
    SELF-HOST-PRODUCT-PATH-CLOSE, productPathCloseReady, productPathLadderClosedOk.
    Same module (keep 31); not residual free; not product complete. -/

/-- Greppable primary stage id for structural product path ladder close. -/
def closeStageId : String := "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0"

/-- Greppable host map id (HOST-PRODUCT-PATH-CLOSE). -/
def hostProductPathCloseId : String := "HOST-PRODUCT-PATH-CLOSE"

/-- Greppable short map id (SELF-HOST-PRODUCT-PATH-CLOSE). -/
def selfHostProductPathCloseId : String := "SELF-HOST-PRODUCT-PATH-CLOSE"

/-- Greppable structural ladder closed token (surface cite). -/
def structuralLadderClosedToken : String := "structural product path ladder closed"

/-- Greppable intentional PARTIAL carry token for close surface. -/
def closeIntentionalPartialToken : String := "intentional PARTIAL"

/-- Greppable further-alias-theater honesty token (not residual progress). -/
def furtherAliasTheaterToken : String :=
  "further ProductPath inventoryCloseReady-implied alias theater held"

/-- productPathCloseSurfaceOk -- close stage ids + ladder closed + PARTIAL.
    String canaries only. Greppable: productPathCloseSurfaceOk. -/
def productPathCloseSurfaceOk : Bool :=
  (closeStageId == "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0")
    && (hostProductPathCloseId == "HOST-PRODUCT-PATH-CLOSE")
    && (selfHostProductPathCloseId == "SELF-HOST-PRODUCT-PATH-CLOSE")
    && (structuralLadderClosedToken == "structural product path ladder closed")
    && (closeIntentionalPartialToken == "intentional PARTIAL")
    && (furtherAliasTheaterToken
        == "further ProductPath inventoryCloseReady-implied alias theater held")
    && (hostProductPathId == "HOST-PRODUCT-PATH")
    && (stageId == "SLAKE_SELF_HOST_PRODUCT_PATH_V0")

/-- productPathFurtherAliasTheaterHeld -- honesty canary: further ProductPath
    conjunct-only re-asserts of inventoryCloseReady-implied kernel/parity bars
    alone are NOT residual progress (definitional alias theater held).
    Does NOT claim residual free. Greppable: productPathFurtherAliasTheaterHeld. -/
def productPathFurtherAliasTheaterHeld : Bool :=
  productPathCloseSurfaceOk
    && (furtherAliasTheaterToken
        == "further ProductPath inventoryCloseReady-implied alias theater held")
    && !residualFreeClaimed

/-- productPathLadderClosedOk -- structural freestanding product path ladder
    closed at unit/program/emit/join/self-host/matrix (via productPathReady).
    FAIL-CLOSED: productPathReady && residual free / complete / unlock claims
    stay false && close surface && further alias theater honesty.
    Honest scope: structural ladder close only -- NOT residual free, NOT
    freestanding product self-host complete, NOT llvm unlock, NOT PROVABLY.
    Greppable: productPathLadderClosedOk, HOST-PRODUCT-PATH-CLOSE. -/
def productPathLadderClosedOk : Bool :=
  productPathReady
    && productPathCloseSurfaceOk
    && productPathFurtherAliasTheaterHeld
    && !residualFreeClaimed
    && !productSelfHostCompleteClaimed
    && !SelfApplyFs.freestandingProductSelfHostComplete
    && !LlvmHold.llvmUnlocked
    && !LlvmHold.provablyUnlocked

/-- productPathCloseReady -- dual greppable alias of productPathLadderClosedOk.
    Greppable: productPathCloseReady. -/
def productPathCloseReady : Bool := productPathLadderClosedOk

/-- productPathCloseDoesNotMeanResidualFree -- ladder close does NOT claim
    freestanding residual free. Greppable: productPathCloseDoesNotMeanResidualFree. -/
def productPathCloseDoesNotMeanResidualFree : Bool :=
  productPathCloseReady && !residualFreeClaimed

/-- Full product path close ok (alias for inventory greps). -/
def productPathCloseOk : Bool := productPathCloseReady

/-! ### PRODUCT-PATH-THEOREM / HOST-PRODUCT-PATH-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is freestanding
  product path readiness, structural ladder close, and honesty non-claims only.
  residualFreeClaimed stays false; further alias theater held. Does not complete
  SpecProof; does not claim residual free / product complete / PROVABLY / llvm unlock.
  Does not invent new ProductPath alias conjuncts.
-/

set_option maxRecDepth 16384

/-- Primary stage id is greppable SLAKE_SELF_HOST_PRODUCT_PATH_V0.
    Greppable: stageId_eq, PRODUCT-PATH-THEOREM, HOST-PRODUCT-PATH-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_PRODUCT_PATH_V0" := rfl

/-- Host map id is greppable HOST-PRODUCT-PATH.
    Greppable: hostProductPathId_eq, PRODUCT-PATH-THEOREM. -/
theorem hostProductPathId_eq : hostProductPathId = "HOST-PRODUCT-PATH" := rfl

/-- residualFreeClaimed stays false (product path is not residual free).
    Greppable: residualFreeClaimed_false, PRODUCT-PATH-THEOREM,
    HOST-PRODUCT-PATH-THEOREM. -/
theorem residualFreeClaimed_false : residualFreeClaimed = false := rfl

/-- Freestanding product path readiness holds (not residual free).
    Greppable: productPathReady_true, HOST-PRODUCT-PATH, PRODUCT-PATH-THEOREM,
    HOST-PRODUCT-PATH-THEOREM. -/
theorem productPathReady_true : productPathReady = true := by decide

/-- Product path ready does NOT claim freestanding residual free.
    Greppable: productPathDoesNotMeanResidualFree_true, PRODUCT-PATH-THEOREM. -/
theorem productPathDoesNotMeanResidualFree_true :
    productPathDoesNotMeanResidualFree = true := by decide

/-- Further ProductPath alias theater honesty canary holds (not residual progress).
    Greppable: productPathFurtherAliasTheaterHeld_true, PRODUCT-PATH-THEOREM,
    HOST-PRODUCT-PATH-THEOREM. -/
theorem productPathFurtherAliasTheaterHeld_true :
    productPathFurtherAliasTheaterHeld = true := by decide

/-- Structural product path ladder close readiness holds (not residual free).
    Greppable: productPathCloseReady_true, HOST-PRODUCT-PATH-CLOSE,
    PRODUCT-PATH-THEOREM, HOST-PRODUCT-PATH-THEOREM. -/
theorem productPathCloseReady_true : productPathCloseReady = true := by decide

/-! ### Product path smoke (behavioral; lake build fails if example fails)
    Greppable: PRODUCT-PATH-SMOKE, HOST-PRODUCT-PATH-SMOKE.
    maxRecDepth raised for inventoryCloseReady / productPathReady unfolds. -/

/-- PRODUCT-PATH-SMOKE / HOST-PRODUCT-PATH-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_PRODUCT_PATH_V0" := by decide
example : hostProductPathId = "HOST-PRODUCT-PATH" := by decide
example : selfHostProductPathId = "SELF-HOST-PRODUCT-PATH" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/ProductPath.lean" := by decide
example : inventoryPath = "src/systems/host-partial-inventory.md" := by decide
example : inventoryCloseStageCite = "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0" := by decide
example : selfApplyFsStageCite = "SLAKE_SELF_HOST_SELF_APPLY_FS_V0" := by decide
example : compilePathStageCite = "SLAKE_COMPILE_PATH_V1" := by decide
example : kernelEmitStageCite = "SLAKE_SELF_HOST_KERNEL_EMIT_V0" := by decide
example : joinMapStageCite = "SLAKE_JOIN_MAP_V0" := by decide
example : selfHostStageCite = "SLAKE_SELF_HOST_V0" := by decide
example : surfaceMatrixStageCite = "SLAKE_SURFACE_MATRIX_V0" := by decide
example : hostInventoryCloseCite = "HOST-INVENTORY-CLOSE" := by decide
example : hostSelfApplyFsCite = "HOST-SELF-APPLY-FS" := by decide
example : hostCompilePathCite = "HOST-COMPILE-PATH" := by decide
example : hostKernelEmitCite = "HOST-KERNEL-EMIT" := by decide
example : hostJoinMapCite = "HOST-JOIN-MAP" := by decide
example : hostSelfHostCite = "HOST-SELF-HOST" := by decide
example : hostSurfaceMatrixCite = "HOST-SURFACE-MATRIX" := by decide
example : productEmitBodyId = "EMIT_BODY_V0" := by decide
example : productHostEmitSsotId = "HOST-EMIT-SSOT" := by decide
example : productHostEmitMultId = "HOST-EMIT-MULT" := by decide
example : runtimeFsMarker = "RUNTIME-FS" := by decide
example : emitBoundaryMarker = "EMIT-BOUNDARY" := by decide
example : emptyProgramFailClosedMarker = "EMPTY-PROGRAM-FAIL-CLOSED" := by decide
example : surfaceMatrixIdMarker = "SURFACE-MATRIX" := by decide
example : productPathSurfaceOk = true := by decide

/-- PRODUCT-PATH-SMOKE: residual-free / complete / unlock claims stay false. -/
example : residualFreeClaimed = false := by decide
example : productSelfHostCompleteClaimed = false := by decide
example : SelfApplyFs.freestandingProductSelfHostComplete = false := by decide
example : LlvmHold.llvmUnlocked = false := by decide
example : LlvmHold.provablyUnlocked = false := by decide

/-- PRODUCT-PATH-SMOKE: freestanding unit product path (empty / unminted / emit). -/
example : freestandingUnitProductPathReady = true := by decide
example : CompilePath.unitCompileReady HostCompose.empty = true := by decide
example : HostCompose.extractOkFs HostCompose.empty = true := by decide
example :
    CompilePath.unitCompileReady KernelEmit.unmintedEmitCompose = false := by decide
example :
    HostCompose.extractOkFs KernelEmit.unmintedEmitCompose = false := by decide
example :
    (match KernelEmit.lowerEmitCompose with
     | some hc =>
         CompilePath.unitCompileReady hc && HostCompose.extractOkFs hc
     | none => false) = true := by decide

/-- PRODUCT-PATH-SMOKE: freestanding program product path (empty fail / lowered). -/
example : freestandingProgramProductPathReady = true := by decide
example : CompilePath.programCompileReady IrProgram.empty = false := by decide
example :
    (match KernelProgram.lowerProgramKernel with
     | some p =>
         CompilePath.programCompileReady p && IrProgram.isWellTyped p
     | none => false) = true := by decide

/-- PRODUCT-PATH-SMOKE: freestanding emit product path (reuse KernelEmit + FS body). -/
example : freestandingEmitProductPathReady = true := by decide
example : KernelEmit.emitPlanPathReady = true := by decide
example : KernelEmit.emitApplyPathReady = true := by decide
example : KernelEmit.emitBodyPathReady = true := by decide
example : KernelEmit.emitKernelReady = true := by decide
example : SelfApplyFs.freestandingBodyPathReady = true := by decide

/-- PRODUCT-PATH-SMOKE: freestanding join *unit* product path (empty / unminted / emit). -/
example : freestandingJoinProductPathReady = true := by decide
example : freestandingJoinUnitProductPathReady = true := by decide
example : freestandingJoinUnitProductPathReady = freestandingJoinProductPathReady :=
  by decide
example : JoinMap.joinUnitCompileReady HostCompose.empty = true := by decide
example :
    JoinMap.joinUnitCompileReady KernelEmit.unmintedEmitCompose = false := by decide
example :
    (match KernelEmit.lowerEmitCompose with
     | some hc => JoinMap.joinUnitCompileReady hc
     | none => false) = true := by decide

/-- PRODUCT-PATH-SMOKE: freestanding join *program* product path
    (EMPTY-PROGRAM-FAIL-CLOSED + lowered kernel joinProgramCompileReady). -/
example : freestandingJoinProgramProductPathReady = true := by decide
example : JoinMap.joinProgramCompileReady IrProgram.empty = false := by decide
example :
    (match KernelProgram.lowerProgramKernel with
     | some p =>
         JoinMap.joinProgramCompileReady p && IrProgram.isWellTyped p
     | none => false) = true := by decide

/-- PRODUCT-PATH-SMOKE: freestanding self-host *direction* *unit* product path
    (HOST-SELF-HOST selfHostUnitReady empty / unminted / lowerEmitCompose).
    Dual alias freestandingSelfHostUnitProductPathReady.
    Does NOT claim freestanding product self-host complete. -/
example : freestandingSelfHostProductPathReady = true := by decide
example : freestandingSelfHostUnitProductPathReady = true := by decide
example :
    freestandingSelfHostUnitProductPathReady
      = freestandingSelfHostProductPathReady := by decide
example : SelfHost.selfHostUnitReady HostCompose.empty = true := by decide
example :
    SelfHost.selfHostUnitReady KernelEmit.unmintedEmitCompose = false := by decide
example :
    (match KernelEmit.lowerEmitCompose with
     | some hc => SelfHost.selfHostUnitReady hc
     | none => false) = true := by decide

/-- PRODUCT-PATH-SMOKE: freestanding self-host *direction* *program* product path
    (EMPTY-PROGRAM-FAIL-CLOSED + lowered kernel selfHostProgramReady).
    Does NOT claim freestanding product self-host complete. -/
example : freestandingSelfHostProgramProductPathReady = true := by decide
example : SelfHost.selfHostProgramReady IrProgram.empty = false := by decide
example :
    (match KernelProgram.lowerProgramKernel with
     | some p =>
         SelfHost.selfHostProgramReady p && IrProgram.isWellTyped p
     | none => false) = true := by decide

/-- PRODUCT-PATH-SMOKE: freestanding surface-matrix *unit* product path
    (HOST-SURFACE-MATRIX matrixUnitReady empty / unminted / lowerEmitCompose).
    Open rows stay open; not day-one full Idris+Lean parity. -/
example : freestandingMatrixUnitProductPathReady = true := by decide
example : SurfaceMatrix.matrixUnitReady HostCompose.empty = true := by decide
example :
    SurfaceMatrix.matrixUnitReady KernelEmit.unmintedEmitCompose = false := by
  decide
example :
    (match KernelEmit.lowerEmitCompose with
     | some hc => SurfaceMatrix.matrixUnitReady hc
     | none => false) = true := by decide

/-- PRODUCT-PATH-SMOKE: freestanding surface-matrix *program* product path
    (EMPTY-PROGRAM-FAIL-CLOSED + lowered kernel matrixProgramReady).
    Open rows stay open; not day-one full Idris+Lean parity. -/
example : freestandingMatrixProgramProductPathReady = true := by decide
example : SurfaceMatrix.matrixProgramReady IrProgram.empty = false := by decide
example :
    (match KernelProgram.lowerProgramKernel with
     | some p =>
         SurfaceMatrix.matrixProgramReady p && IrProgram.isWellTyped p
     | none => false) = true := by decide

/-- PRODUCT-PATH-SMOKE: joint path + inventory close prior ready. -/
example : freestandingProductPathReady = true := by decide
example : InventoryClose.inventoryCloseReady = true := by decide

/-- PRODUCT-PATH-SMOKE / HOST-PRODUCT-PATH-SMOKE: product path ready decides true
    (not residual free; not product complete; not llvm unlock). -/
example : productPathReady = true := by decide
example : productPathDoesNotComplete = true := by decide
example : productPathDoesNotMeanResidualFree = true := by decide
example : productPathOk = true := by decide

/-! ### Product path close smoke (structural ladder close)
    Greppable: PRODUCT-PATH-CLOSE-SMOKE, HOST-PRODUCT-PATH-CLOSE-SMOKE. -/

/-- PRODUCT-PATH-CLOSE-SMOKE / HOST-PRODUCT-PATH-CLOSE-SMOKE: close stage ids. -/
example : closeStageId = "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0" := by decide
example : hostProductPathCloseId = "HOST-PRODUCT-PATH-CLOSE" := by decide
example : selfHostProductPathCloseId = "SELF-HOST-PRODUCT-PATH-CLOSE" := by decide
example :
    structuralLadderClosedToken = "structural product path ladder closed" := by decide
example : closeIntentionalPartialToken = "intentional PARTIAL" := by decide
example :
    furtherAliasTheaterToken
      = "further ProductPath inventoryCloseReady-implied alias theater held" :=
  by decide
example : productPathCloseSurfaceOk = true := by decide
example : productPathFurtherAliasTheaterHeld = true := by decide

/-- PRODUCT-PATH-CLOSE-SMOKE: residual free / complete / unlock stay false. -/
example : residualFreeClaimed = false := by decide
example : productSelfHostCompleteClaimed = false := by decide
example : SelfApplyFs.freestandingProductSelfHostComplete = false := by decide
example : LlvmHold.llvmUnlocked = false := by decide
example : LlvmHold.provablyUnlocked = false := by decide

/-- PRODUCT-PATH-CLOSE-SMOKE / HOST-PRODUCT-PATH-CLOSE-SMOKE: ladder closed.
    Structural product path ladder closed -- not residual free; not complete. -/
example : productPathLadderClosedOk = true := by decide
example : productPathCloseReady = true := by decide
example : productPathCloseReady = productPathLadderClosedOk := by decide
example : productPathCloseDoesNotMeanResidualFree = true := by decide
example : productPathCloseOk = true := by decide

end SystemsLean.ProductPath
