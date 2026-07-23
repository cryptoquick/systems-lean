/-
  SYSTEMS_LEAN_HOST partial -- dual residual honesty (host elaborator residual
  vs product residual) after HOST-PRODUCT-PATH-CLOSE.
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): ProductPath.lean structural product path ladder close;
    InventoryClose.lean inventory close readiness; LlvmHold.lean SH6 hold;
    SelfApplyFs.lean freestanding self-apply (complete stays false);
    Extract.lean EMIT-BOUNDARY / RUNTIME-FS vs RUNTIME-CLASSIC;
    Types.lean HOST-RESIDUAL vs PRODUCT-WIRE-RESIDUAL;
    self-host.md acceptance; host-partial-inventory.md; surface-matrix.md.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_DUAL_RESIDUAL_V0 / HOST-DUAL-RESIDUAL /
    SELF-HOST-DUAL-RESIDUAL: greppable dual residual honesty gate -- host
    elaborator residual (classic Lean managed runtime on Lake) and product
    residual (freestanding product wire residual) are distinct surfaces;
    neither is forged free.
  - hostElaboratorResidualRemains: classic Lean elaborator residual still
    present (RUNTIME-CLASSIC / Lake managed residual story). MUST decide true.
  - productResidualRemains: freestanding product wire residual still present
    (not residual free). MUST decide true.
  - hostElaboratorResidualFreeClaimed / residualFreeClaimed /
    productSelfHostCompleteClaimed: MUST decide false.
  - dualResidualSurfacesDistinct: both residuals remain, neither free claimed,
    surface tokens distinguish host elaborator residual from product residual.
  - dualResidualSurfaceOk: stage ids + dual residual path cites + prior
    HOST-PRODUCT-PATH-CLOSE / HOST-INVENTORY-CLOSE / HOST-LLVM-HOLD /
    HOST-RESIDUAL / PRODUCT-WIRE-RESIDUAL / EMIT-BOUNDARY cites.
  - dualResidualReady: ProductPath.productPathCloseReady && surface &&
    surfacesDistinct && both residuals remain && free/complete/unlock claims
    stay false.
  - dualResidualDoesNotMeanResidualFree /
    dualResidualDoesNotForgeEitherFree: ready && free claims stay false &&
    both residuals still remain.
  - Host model = structural dual residual honesty. Not an AI/ML model.
    Not product C residual free.

  Theorems (DUAL-RESIDUAL-THEOREM / HOST-DUAL-RESIDUAL-THEOREM -- partial
  DualResidual):
  - dualResidualReady_true / hostElaboratorResidualRemains_true
  - productResidualRemains_true / residualFreeClaimed_false
  - dualResidualDoesNotMeanResidualFree_true
  - dualResidualDoesNotForgeEitherFree_true / stageId_eq
  - dualResidualOk_eq_ready (dualResidualOk definitional alias of dualResidualReady)
  These DualResidual theorems do NOT set SpecProof.proofCompleteClaimed true.
  Both residuals remain true; free claims stay false (proved, not forged free).
  dualResidualOk is a definitional alias of dualResidualReady (joint-name honesty
  only; not a stronger gate; dualResidualOk_eq_ready proves equality).

  Intentional non-claims / partial:
  - Dual residual honesty only -- NOT freestanding residual free.
  - Host elaborator residual is NOT forged free (Lake managed runtime remains).
  - Product residual is NOT forged free (freestanding wire residual remains).
  - NOT freestanding product self-host complete.
  - NOT PROVABLY. Does not unlock llvm / out/llvm-ir (LlvmHold still holds).
  - Intentional PARTIAL carry remains.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Does not mint ProductPath alias theater. Does not grow bash EMIT_* treadmill.
  - No new EMIT_* C stage. Does not grow check.sh.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_DUAL_RESIDUAL_V0,
  HOST-DUAL-RESIDUAL, SELF-HOST-DUAL-RESIDUAL, DUAL-RESIDUAL-SMOKE,
  HOST-DUAL-RESIDUAL-SMOKE, dualResidualReady, dualResidualSurfaceOk,
  dualResidualSurfacesDistinct, dualResidualDoesNotMeanResidualFree,
  dualResidualDoesNotForgeEitherFree, hostElaboratorResidualRemains,
  productResidualRemains, hostElaboratorResidualFreeClaimed,
  residualFreeClaimed, productSelfHostCompleteClaimed, dualResidualOk,
  HOST-PRODUCT-PATH-CLOSE, HOST-INVENTORY-CLOSE, HOST-LLVM-HOLD,
  HOST-RESIDUAL, PRODUCT-WIRE-RESIDUAL, EMIT-BOUNDARY, RUNTIME-FS,
  RUNTIME-CLASSIC, productPathCloseReady, inventoryCloseReady, llvmHoldReady,
  freestandingProductSelfHostComplete, llvmUnlocked, provablyUnlocked,
  intentional PARTIAL, SELF-HOST, MULT-0, MULT-1, MULT-OMEGA,
  DUAL-RESIDUAL-THEOREM, HOST-DUAL-RESIDUAL-THEOREM, dualResidualReady_true,
  hostElaboratorResidualRemains_true, productResidualRemains_true,
  residualFreeClaimed_false, dualResidualOk_eq_ready,
  UNIT_SURFACE host surface.
  Module: SystemsLean.DualResidual
  Not freestanding residual free. Not PROVABLY.
  Not freestanding product self-host complete. Not freestanding emit residual free.
  Not llvm unlocked. Not host elaborator residual free. Not proof complete.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.ProductPath
import SystemsLean.InventoryClose
import SystemsLean.SelfApplyFs
import SystemsLean.LlvmHold

namespace SystemsLean.DualResidual

/-- Greppable primary stage id for dual residual honesty. -/
def stageId : String := "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0"

/-- Greppable host map id (HOST-DUAL-RESIDUAL). -/
def hostDualResidualId : String := "HOST-DUAL-RESIDUAL"

/-- Greppable short map id (SELF-HOST-DUAL-RESIDUAL). -/
def selfHostDualResidualId : String := "SELF-HOST-DUAL-RESIDUAL"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/DualResidual.lean"

/-- Read-only PARTIAL inventory path cite (not a filesystem read). -/
def inventoryPath : String := "src/systems/host-partial-inventory.md"

/-- Prior structural product path ladder close stage cite. -/
def productPathCloseStageCite : String := "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0"

/-- Prior inventory close stage cite. -/
def inventoryCloseStageCite : String := "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0"

/-- Prior llvm hold stage cite. -/
def llvmHoldStageCite : String := "SLAKE_SELF_HOST_LLVM_HOLD_V0"

/-- Prior product path close host map cite. -/
def hostProductPathCloseCite : String := "HOST-PRODUCT-PATH-CLOSE"

/-- Prior inventory close host map cite. -/
def hostInventoryCloseCite : String := "HOST-INVENTORY-CLOSE"

/-- Prior llvm hold host map cite. -/
def hostLlvmHoldCite : String := "HOST-LLVM-HOLD"

/-- HOST-RESIDUAL cite (Types elaborator residual surface; not product wire). -/
def hostResidualCite : String := "HOST-RESIDUAL"

/-- PRODUCT-WIRE-RESIDUAL cite (freestanding emit residual surface). -/
def productWireResidualCite : String := "PRODUCT-WIRE-RESIDUAL"

/-- EMIT-BOUNDARY cite (host elaborator / proofs vs product extract). -/
def emitBoundaryCite : String := "EMIT-BOUNDARY"

/-- RUNTIME-FS product goal cite. -/
def runtimeFsCite : String := "RUNTIME-FS"

/-- RUNTIME-CLASSIC host elaborator managed residual cite. -/
def runtimeClassicCite : String := "RUNTIME-CLASSIC"

/-- Greppable host elaborator residual remains token. -/
def hostElaboratorResidualToken : String := "host elaborator residual remains"

/-- Greppable product residual remains token. -/
def productResidualToken : String := "product residual remains"

/-- Greppable intentional PARTIAL carry token. -/
def intentionalPartialToken : String := "intentional PARTIAL"

/-- dualResidualSurfaceOk -- stage ids + dual residual cites + prior close /
    inventory / llvm hold / residual surface cites. String canaries only.
    Greppable: dualResidualSurfaceOk. -/
def dualResidualSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0")
    && (hostDualResidualId == "HOST-DUAL-RESIDUAL")
    && (selfHostDualResidualId == "SELF-HOST-DUAL-RESIDUAL")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/DualResidual.lean")
    && (inventoryPath == "src/systems/host-partial-inventory.md")
    && (productPathCloseStageCite == "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0")
    && (inventoryCloseStageCite == "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0")
    && (llvmHoldStageCite == "SLAKE_SELF_HOST_LLVM_HOLD_V0")
    && (hostProductPathCloseCite == "HOST-PRODUCT-PATH-CLOSE")
    && (hostInventoryCloseCite == "HOST-INVENTORY-CLOSE")
    && (hostLlvmHoldCite == "HOST-LLVM-HOLD")
    && (hostResidualCite == "HOST-RESIDUAL")
    && (productWireResidualCite == "PRODUCT-WIRE-RESIDUAL")
    && (emitBoundaryCite == "EMIT-BOUNDARY")
    && (runtimeFsCite == "RUNTIME-FS")
    && (runtimeClassicCite == "RUNTIME-CLASSIC")
    && (hostElaboratorResidualToken == "host elaborator residual remains")
    && (productResidualToken == "product residual remains")
    && (intentionalPartialToken == "intentional PARTIAL")

/-- hostElaboratorResidualRemains -- classic Lean elaborator residual still
    present (Lake managed runtime / RUNTIME-CLASSIC story). MUST decide true.
    Greppable: hostElaboratorResidualRemains. -/
def hostElaboratorResidualRemains : Bool := true

/-- productResidualRemains -- freestanding product wire residual still present
    (not residual free). MUST decide true.
    Greppable: productResidualRemains. -/
def productResidualRemains : Bool := true

/-- hostElaboratorResidualFreeClaimed -- MUST decide false (do not forge host
    residual free). Greppable: hostElaboratorResidualFreeClaimed. -/
def hostElaboratorResidualFreeClaimed : Bool := false

/-- residualFreeClaimed -- product residual free claim; MUST decide false.
    Greppable: residualFreeClaimed. -/
def residualFreeClaimed : Bool := false

/-- productSelfHostCompleteClaimed -- MUST decide false (still open).
    Greppable: productSelfHostCompleteClaimed. -/
def productSelfHostCompleteClaimed : Bool := false

/-- dualResidualSurfacesDistinct -- host elaborator residual and product residual
    are distinct honesty surfaces: both remain, neither free claimed, tokens
    distinguish the two residuals. Greppable: dualResidualSurfacesDistinct. -/
def dualResidualSurfacesDistinct : Bool :=
  hostElaboratorResidualRemains
    && productResidualRemains
    && !hostElaboratorResidualFreeClaimed
    && !residualFreeClaimed
    && (hostElaboratorResidualToken == "host elaborator residual remains")
    && (productResidualToken == "product residual remains")
    && (hostResidualCite == "HOST-RESIDUAL")
    && (productWireResidualCite == "PRODUCT-WIRE-RESIDUAL")
    && (emitBoundaryCite == "EMIT-BOUNDARY")
    && (runtimeClassicCite == "RUNTIME-CLASSIC")
    && (runtimeFsCite == "RUNTIME-FS")

/-- dualResidualReady -- dual residual honesty bar after product path ladder close.
    FAIL-CLOSED: productPathCloseReady && surface && surfacesDistinct &&
    both residuals remain && free/complete/unlock claims stay false.
    Honest scope: dual residual honesty only -- NOT residual free (either side),
    NOT freestanding product self-host complete, NOT llvm unlock, NOT PROVABLY.
    Greppable: dualResidualReady, HOST-DUAL-RESIDUAL. -/
def dualResidualReady : Bool :=
  ProductPath.productPathCloseReady
    && dualResidualSurfaceOk
    && dualResidualSurfacesDistinct
    && hostElaboratorResidualRemains
    && productResidualRemains
    && !hostElaboratorResidualFreeClaimed
    && !residualFreeClaimed
    && !productSelfHostCompleteClaimed
    && !SelfApplyFs.freestandingProductSelfHostComplete
    && !LlvmHold.llvmUnlocked
    && !LlvmHold.provablyUnlocked

/-- dualResidualDoesNotMeanResidualFree -- dual residual ready does NOT claim
    freestanding product residual free (product residual still remains).
    Greppable: dualResidualDoesNotMeanResidualFree. -/
def dualResidualDoesNotMeanResidualFree : Bool :=
  dualResidualReady && !residualFreeClaimed && productResidualRemains

/-- dualResidualDoesNotForgeEitherFree -- dual residual ready does NOT forge
    either residual free (host elaborator residual and product residual both
    remain; free claims false). Greppable: dualResidualDoesNotForgeEitherFree. -/
def dualResidualDoesNotForgeEitherFree : Bool :=
  dualResidualReady
    && !hostElaboratorResidualFreeClaimed
    && !residualFreeClaimed
    && hostElaboratorResidualRemains
    && productResidualRemains

/-- Full dual residual ok -- definitional alias of dualResidualReady
    (joint-name honesty only; not a stronger gate).
    Greppable: dualResidualOk, dualResidualReady. -/
def dualResidualOk : Bool := dualResidualReady

/-! ### DUAL-RESIDUAL-THEOREM / HOST-DUAL-RESIDUAL-THEOREM (readable statements,
    then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is dual residual
  honesty and free-claim non-forging only. Does not complete SpecProof; both
  residuals remain true; free claims stay false.
  maxRecDepth raised for productPathCloseReady / dualResidualReady unfolds.
-/

set_option maxRecDepth 16384

/-- Primary stage id is greppable SLAKE_SELF_HOST_DUAL_RESIDUAL_V0.
    Greppable: stageId_eq, DUAL-RESIDUAL-THEOREM, HOST-DUAL-RESIDUAL-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0" := rfl

/-- Host elaborator residual still remains (Lake managed / RUNTIME-CLASSIC).
    Greppable: hostElaboratorResidualRemains_true, DUAL-RESIDUAL-THEOREM,
    HOST-DUAL-RESIDUAL-THEOREM. -/
theorem hostElaboratorResidualRemains_true :
    hostElaboratorResidualRemains = true := rfl

/-- Product freestanding wire residual still remains (not residual free).
    Greppable: productResidualRemains_true, DUAL-RESIDUAL-THEOREM,
    HOST-DUAL-RESIDUAL-THEOREM. -/
theorem productResidualRemains_true : productResidualRemains = true := rfl

/-- residualFreeClaimed stays false (do not forge product residual free).
    Greppable: residualFreeClaimed_false, DUAL-RESIDUAL-THEOREM. -/
theorem residualFreeClaimed_false : residualFreeClaimed = false := rfl

/-- Dual residual honesty readiness holds (neither side forged free).
    Greppable: dualResidualReady_true, HOST-DUAL-RESIDUAL,
    DUAL-RESIDUAL-THEOREM, HOST-DUAL-RESIDUAL-THEOREM. -/
theorem dualResidualReady_true : dualResidualReady = true := by decide

/-- Dual residual ready does NOT mean residual free.
    Greppable: dualResidualDoesNotMeanResidualFree_true, DUAL-RESIDUAL-THEOREM. -/
theorem dualResidualDoesNotMeanResidualFree_true :
    dualResidualDoesNotMeanResidualFree = true := by decide

/-- Dual residual ready does NOT forge either residual free.
    Greppable: dualResidualDoesNotForgeEitherFree_true, DUAL-RESIDUAL-THEOREM,
    HOST-DUAL-RESIDUAL-THEOREM. -/
theorem dualResidualDoesNotForgeEitherFree_true :
    dualResidualDoesNotForgeEitherFree = true := by decide

/-- Joint-name honesty: dualResidualOk is definitional alias of dualResidualReady
    (not a stronger gate). Greppable: dualResidualOk_eq_ready,
    DUAL-RESIDUAL-THEOREM, HOST-DUAL-RESIDUAL-THEOREM. -/
theorem dualResidualOk_eq_ready : dualResidualOk = dualResidualReady := rfl

/-! ### Dual residual smoke (behavioral; lake build fails if example fails)
    Greppable: DUAL-RESIDUAL-SMOKE, HOST-DUAL-RESIDUAL-SMOKE.
    maxRecDepth already raised above for dualResidualReady unfolds. -/

/-- DUAL-RESIDUAL-SMOKE / HOST-DUAL-RESIDUAL-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0" := by decide
example : hostDualResidualId = "HOST-DUAL-RESIDUAL" := by decide
example : selfHostDualResidualId = "SELF-HOST-DUAL-RESIDUAL" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/DualResidual.lean" := by decide
example : inventoryPath = "src/systems/host-partial-inventory.md" := by decide
example : productPathCloseStageCite = "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0" :=
  by decide
example : inventoryCloseStageCite = "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0" := by decide
example : llvmHoldStageCite = "SLAKE_SELF_HOST_LLVM_HOLD_V0" := by decide
example : hostProductPathCloseCite = "HOST-PRODUCT-PATH-CLOSE" := by decide
example : hostInventoryCloseCite = "HOST-INVENTORY-CLOSE" := by decide
example : hostLlvmHoldCite = "HOST-LLVM-HOLD" := by decide
example : hostResidualCite = "HOST-RESIDUAL" := by decide
example : productWireResidualCite = "PRODUCT-WIRE-RESIDUAL" := by decide
example : emitBoundaryCite = "EMIT-BOUNDARY" := by decide
example : runtimeFsCite = "RUNTIME-FS" := by decide
example : runtimeClassicCite = "RUNTIME-CLASSIC" := by decide
example : hostElaboratorResidualToken = "host elaborator residual remains" := by decide
example : productResidualToken = "product residual remains" := by decide
example : intentionalPartialToken = "intentional PARTIAL" := by decide
example : dualResidualSurfaceOk = true := by decide

/-- DUAL-RESIDUAL-SMOKE: both residuals remain; free/complete/unlock stay false. -/
example : hostElaboratorResidualRemains = true := by decide
example : productResidualRemains = true := by decide
example : hostElaboratorResidualFreeClaimed = false := by decide
example : residualFreeClaimed = false := by decide
example : productSelfHostCompleteClaimed = false := by decide
example : SelfApplyFs.freestandingProductSelfHostComplete = false := by decide
example : LlvmHold.llvmUnlocked = false := by decide
example : LlvmHold.provablyUnlocked = false := by decide
example : dualResidualSurfacesDistinct = true := by decide

/-- DUAL-RESIDUAL-SMOKE: prior ladder close + inventory close + hold ready. -/
example : ProductPath.productPathCloseReady = true := by decide
example : InventoryClose.inventoryCloseReady = true := by decide
example : LlvmHold.llvmHoldReady = true := by decide

/-- DUAL-RESIDUAL-SMOKE / HOST-DUAL-RESIDUAL-SMOKE: dual residual ready decides
    true (not residual free either side; not product complete; not llvm unlock).
    dualResidualOk is definitional alias of dualResidualReady (joint-name honesty). -/
example : dualResidualReady = true := by decide
example : dualResidualDoesNotMeanResidualFree = true := by decide
example : dualResidualDoesNotForgeEitherFree = true := by decide
example : dualResidualOk = true := by decide
example : dualResidualOk = dualResidualReady := by decide

end SystemsLean.DualResidual
