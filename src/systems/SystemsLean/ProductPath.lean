/-
  SYSTEMS_LEAN_HOST partial -- freestanding product path readiness
  (after HOST-INVENTORY-CLOSE).
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): InventoryClose.lean inventory close readiness;
    CompilePath.lean unit/program compile bars; KernelEmit.lean lowerEmitCompose;
    KernelProgram.lean lowerProgramKernel; SelfApplyFs / LlvmHold complete and
    unlock flags; self-host.md acceptance; host-partial-inventory.md.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_PRODUCT_PATH_V0 / HOST-PRODUCT-PATH /
    SELF-HOST-PRODUCT-PATH: greppable freestanding product path readiness gate
    beyond inventory close -- real Bool compose on CompilePath unit / program
    bars over empty HostCompose, unminted emit compose, and lowered kernel
    emit compose (not docs-only canaries).
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
  - freestandingProductPathReady: unit path && program path (joint freestanding
    product path bar; not freestanding product self-host complete).
  - productPathSurfaceOk: stage ids + product wire cites (RUNTIME-FS,
    EMIT-BOUNDARY, EMIT_BODY_V0, HOST-EMIT-SSOT, HOST-EMIT-MULT) + prior
    HOST-INVENTORY-CLOSE / HOST-SELF-APPLY-FS / HOST-COMPILE-PATH cites --
    String canaries only.
  - residualFreeClaimed / productSelfHostCompleteClaimed: MUST decide false.
  - productPathReady: InventoryClose.inventoryCloseReady &&
    freestandingUnitProductPathReady && freestandingProgramProductPathReady &&
    productPathSurfaceOk && !residual free claimed && !product complete claimed
    && !SelfApplyFs.freestandingProductSelfHostComplete &&
    !LlvmHold.llvmUnlocked && !LlvmHold.provablyUnlocked.
  - productPathDoesNotComplete / productPathDoesNotMeanResidualFree: ready &&
    complete/residual claims stay false.
  - Host model = structural freestanding product path honesty. Not an AI/ML
    model. Not product C residual free.

  Intentional non-claims / partial:
  - Product path readiness only -- NOT freestanding residual free.
  - NOT freestanding product self-host complete.
  - NOT PROVABLY. Does not unlock llvm / out/llvm-ir (LlvmHold still holds).
  - Intentional PARTIAL carry remains (host Bool path honesty vs full product
    freestanding C rebuild of Slake).
  - Does not mint phantom modules. Does not grow bash EMIT_* residual treadmill.
  - No new EMIT_* C stage. Does not grow check.sh.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_PRODUCT_PATH_V0,
  HOST-PRODUCT-PATH, SELF-HOST-PRODUCT-PATH, PRODUCT-PATH-SMOKE,
  HOST-PRODUCT-PATH-SMOKE, productPathReady, productPathSurfaceOk,
  freestandingUnitProductPathReady, freestandingProgramProductPathReady,
  freestandingProductPathReady, productPathDoesNotComplete,
  productPathDoesNotMeanResidualFree, residualFreeClaimed,
  productSelfHostCompleteClaimed, productPathOk, HOST-INVENTORY-CLOSE,
  HOST-SELF-APPLY-FS, HOST-COMPILE-PATH, inventoryCloseReady, unitCompileReady,
  programCompileReady, extractOkFs, lowerEmitCompose, lowerProgramKernel,
  RUNTIME-FS, EMIT-BOUNDARY, EMIT_BODY_V0, HOST-EMIT-SSOT, HOST-EMIT-MULT,
  EMPTY-PROGRAM-FAIL-CLOSED, freestandingProductSelfHostComplete, llvmUnlocked,
  provablyUnlocked, SELF-HOST, UNIT_SURFACE host surface.
  Module: SystemsLean.ProductPath
  Not freestanding residual free. Not PROVABLY.
  Not freestanding product self-host complete. Not freestanding emit residual free.
  Not llvm unlocked.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.InventoryClose
import SystemsLean.CompilePath
import SystemsLean.KernelEmit
import SystemsLean.KernelProgram
import SystemsLean.HostCompose
import SystemsLean.IrProgram
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

/-- Prior inventory close host map cite. -/
def hostInventoryCloseCite : String := "HOST-INVENTORY-CLOSE"

/-- Prior freestanding self-apply host map cite. -/
def hostSelfApplyFsCite : String := "HOST-SELF-APPLY-FS"

/-- Prior compile-path host map cite. -/
def hostCompilePathCite : String := "HOST-COMPILE-PATH"

/-- Product wire cites (frozen; no new EMIT_* C stage). -/
def productEmitBodyId : String := "EMIT_BODY_V0"
def productHostEmitSsotId : String := "HOST-EMIT-SSOT"
def productHostEmitMultId : String := "HOST-EMIT-MULT"
def runtimeFsMarker : String := "RUNTIME-FS"
def emitBoundaryMarker : String := "EMIT-BOUNDARY"
def emptyProgramFailClosedMarker : String := "EMPTY-PROGRAM-FAIL-CLOSED"

/-- Surface canary: stage ids + product wire cites + prior HOST-INVENTORY-CLOSE /
    HOST-SELF-APPLY-FS / HOST-COMPILE-PATH cites. String canaries only. -/
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
    && (hostInventoryCloseCite == "HOST-INVENTORY-CLOSE")
    && (hostSelfApplyFsCite == "HOST-SELF-APPLY-FS")
    && (hostCompilePathCite == "HOST-COMPILE-PATH")
    && (productEmitBodyId == "EMIT_BODY_V0")
    && (productHostEmitSsotId == "HOST-EMIT-SSOT")
    && (productHostEmitMultId == "HOST-EMIT-MULT")
    && (runtimeFsMarker == "RUNTIME-FS")
    && (emitBoundaryMarker == "EMIT-BOUNDARY")
    && (emptyProgramFailClosedMarker == "EMPTY-PROGRAM-FAIL-CLOSED")

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

/-- freestandingProductPathReady -- joint unit + program freestanding product path.
    Greppable: freestandingProductPathReady. -/
def freestandingProductPathReady : Bool :=
  freestandingUnitProductPathReady && freestandingProgramProductPathReady

/-- residualFreeClaimed -- MUST decide false (product path is not residual free).
    Greppable: residualFreeClaimed. -/
def residualFreeClaimed : Bool := false

/-- productSelfHostCompleteClaimed -- MUST decide false (still open).
    Greppable: productSelfHostCompleteClaimed. -/
def productSelfHostCompleteClaimed : Bool := false

/-- productPathReady -- freestanding product path bar after inventory close.
    FAIL-CLOSED: inventoryCloseReady && unit path && program path && surface &&
    residual free / product complete / llvm unlock claims stay false.
    Honest scope: freestanding product path readiness only -- NOT residual free,
    NOT freestanding product self-host complete, NOT llvm unlock, NOT PROVABLY.
    Greppable: productPathReady, HOST-PRODUCT-PATH. -/
def productPathReady : Bool :=
  InventoryClose.inventoryCloseReady
    && freestandingUnitProductPathReady
    && freestandingProgramProductPathReady
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

/-! ### Product path smoke (behavioral; lake build fails if example fails)
    Greppable: PRODUCT-PATH-SMOKE, HOST-PRODUCT-PATH-SMOKE.
    maxRecDepth raised for inventoryCloseReady / productPathReady unfolds. -/

set_option maxRecDepth 16384

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
example : hostInventoryCloseCite = "HOST-INVENTORY-CLOSE" := by decide
example : hostSelfApplyFsCite = "HOST-SELF-APPLY-FS" := by decide
example : hostCompilePathCite = "HOST-COMPILE-PATH" := by decide
example : productEmitBodyId = "EMIT_BODY_V0" := by decide
example : productHostEmitSsotId = "HOST-EMIT-SSOT" := by decide
example : productHostEmitMultId = "HOST-EMIT-MULT" := by decide
example : runtimeFsMarker = "RUNTIME-FS" := by decide
example : emitBoundaryMarker = "EMIT-BOUNDARY" := by decide
example : emptyProgramFailClosedMarker = "EMPTY-PROGRAM-FAIL-CLOSED" := by decide
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

/-- PRODUCT-PATH-SMOKE: joint path + inventory close prior ready. -/
example : freestandingProductPathReady = true := by decide
example : InventoryClose.inventoryCloseReady = true := by decide

/-- PRODUCT-PATH-SMOKE / HOST-PRODUCT-PATH-SMOKE: product path ready decides true
    (not residual free; not product complete; not llvm unlock). -/
example : productPathReady = true := by decide
example : productPathDoesNotComplete = true := by decide
example : productPathDoesNotMeanResidualFree = true := by decide
example : productPathOk = true := by decide

end SystemsLean.ProductPath
