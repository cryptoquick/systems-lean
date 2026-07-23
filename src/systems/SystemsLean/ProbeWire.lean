/-
  SYSTEMS_LEAN_HOST partial -- probe-vs-wire honesty (hosted behavioral probe
  vs product freestanding wire) after HOST-DUAL-RESIDUAL.
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): DualResidual.lean dual residual honesty;
    ProductPath.lean structural product path ladder close;
    InventoryClose.lean inventory close readiness; LlvmHold.lean SH6 hold;
    SelfApplyFs.lean freestanding self-apply (complete stays false);
    Parity* modules fold probe labels for Mult..Emit contracts;
    Extract.lean EMIT-BOUNDARY / RUNTIME-FS vs RUNTIME-CLASSIC;
    smoke/slake_behavioral_probe.c hosted behavioral smoke debt;
    emit/ + out/freestanding-c/ product freestanding wire paths;
    self-host.md acceptance; host-partial-inventory.md; surface-matrix.md.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_PROBE_WIRE_V0 / HOST-PROBE-WIRE / SELF-HOST-PROBE-WIRE:
    greppable probe-vs-wire honesty gate -- hosted behavioral probe under
    smoke/ is smoke debt (executable feedback), distinct from product
    freestanding wire under emit/ and out/freestanding-c/ (product path).
    Probe green does NOT mean product residual free or product complete.
  - behavioralProbeIsSmokeDebt: hosted probe is smoke debt, not product
    residual progress. MUST decide true.
  - behavioralProbeIsNotProductWire: probe path is not the product wire.
    MUST decide true.
  - productWireIsEmitPath: product freestanding wire is emit/out path.
    MUST decide true.
  - probeDoesNotReplaceProductWire: probe green does not replace wire residual.
    MUST decide true.
  - residualFreeClaimed / productSelfHostCompleteClaimed: MUST decide false.
  - probeWireSurfacesDistinct: probe and wire path cites differ; tokens
    distinguish smoke debt from product freestanding wire.
  - probeWireSurfaceOk: stage ids + probe/wire path cites + prior
    HOST-DUAL-RESIDUAL / HOST-PRODUCT-PATH-CLOSE / HOST-INVENTORY-CLOSE /
    HOST-LLVM-HOLD / EMIT-BOUNDARY / RUNTIME-FS cites.
  - probeWireReady: DualResidual.dualResidualReady && surface &&
    surfacesDistinct && smoke-debt + not-wire + emit-path + does-not-replace
    && free/complete/unlock claims stay false.
  - probeWireDoesNotMeanResidualFree /
    probeWireDoesNotMeanProductComplete: ready && free/complete claims false.
  - Host model = structural probe-vs-wire honesty. Not an AI/ML model.
    Not product C residual free. Not freestanding product self-host complete.

  Theorems (PROBE-WIRE-THEOREM / HOST-PROBE-WIRE-THEOREM -- partial ProbeWire):
  - probeWireReady_true / behavioralProbeIsSmokeDebt_true
  - behavioralProbeIsNotProductWire_true / productWireIsEmitPath_true
  - residualFreeClaimed_false / probeWireDoesNotMeanResidualFree_true
  - stageId_eq / hostProbeWireId_eq
  These ProbeWire theorems do NOT set SpecProof.proofCompleteClaimed true.
  Probe green is smoke debt, not product residual free.

  Intentional non-claims / partial:
  - Probe-vs-wire honesty only -- NOT freestanding residual free.
  - Hosted behavioral probe green is NOT product residual free.
  - Product freestanding wire residual remains (DualResidual product residual).
  - NOT freestanding product self-host complete.
  - NOT PROVABLY. Does not unlock llvm / out/llvm-ir (LlvmHold still holds).
  - Intentional PARTIAL carry remains.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Does not mint ProductPath alias theater. Does not grow bash EMIT_* treadmill.
  - No new EMIT_* C stage. Does not grow check.sh. Does not grow probe C body.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_PROBE_WIRE_V0,
  HOST-PROBE-WIRE, SELF-HOST-PROBE-WIRE, PROBE-WIRE-SMOKE,
  HOST-PROBE-WIRE-SMOKE, probeWireReady, probeWireSurfaceOk,
  probeWireSurfacesDistinct, probeWireDoesNotMeanResidualFree,
  probeWireDoesNotMeanProductComplete, behavioralProbeIsSmokeDebt,
  behavioralProbeIsNotProductWire, productWireIsEmitPath,
  probeDoesNotReplaceProductWire, residualFreeClaimed,
  productSelfHostCompleteClaimed, probeWireOk, HOST-DUAL-RESIDUAL,
  HOST-PRODUCT-PATH-CLOSE, HOST-INVENTORY-CLOSE, HOST-LLVM-HOLD,
  EMIT-BOUNDARY, RUNTIME-FS, dualResidualReady, productPathCloseReady,
  freestandingProductSelfHostComplete, llvmUnlocked, provablyUnlocked,
  intentional PARTIAL, SELF-HOST, MULT-0, MULT-1, MULT-OMEGA,
  PROBE-WIRE-THEOREM, HOST-PROBE-WIRE-THEOREM, probeWireReady_true,
  behavioralProbeIsSmokeDebt_true, residualFreeClaimed_false,
  UNIT_SURFACE host surface.
  Module: SystemsLean.ProbeWire
  Not freestanding residual free. Not PROVABLY.
  Not freestanding product self-host complete. Not freestanding emit residual free.
  Not llvm unlocked. Not host elaborator residual free. Not proof complete.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.DualResidual
import SystemsLean.ProductPath
import SystemsLean.InventoryClose
import SystemsLean.SelfApplyFs
import SystemsLean.LlvmHold

namespace SystemsLean.ProbeWire

/-- Greppable primary stage id for probe-vs-wire honesty. -/
def stageId : String := "SLAKE_SELF_HOST_PROBE_WIRE_V0"

/-- Greppable host map id (HOST-PROBE-WIRE). -/
def hostProbeWireId : String := "HOST-PROBE-WIRE"

/-- Greppable short map id (SELF-HOST-PROBE-WIRE). -/
def selfHostProbeWireId : String := "SELF-HOST-PROBE-WIRE"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/ProbeWire.lean"

/-- Read-only PARTIAL inventory path cite (not a filesystem read). -/
def inventoryPath : String := "src/systems/host-partial-inventory.md"

/-- Hosted behavioral probe path cite (smoke debt; not product wire). -/
def behavioralProbePath : String := "src/systems/smoke/slake_behavioral_probe.c"

/-- Product freestanding emit wire path cite (generator surface). -/
def productEmitWirePath : String := "src/systems/emit/"

/-- Product freestanding release wire path cite (out release surface). -/
def productReleaseWirePath : String := "out/freestanding-c/"

/-- Prior dual residual stage cite. -/
def dualResidualStageCite : String := "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0"

/-- Prior product path close stage cite. -/
def productPathCloseStageCite : String := "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0"

/-- Prior inventory close stage cite. -/
def inventoryCloseStageCite : String := "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0"

/-- Prior llvm hold stage cite. -/
def llvmHoldStageCite : String := "SLAKE_SELF_HOST_LLVM_HOLD_V0"

/-- Prior dual residual host map cite. -/
def hostDualResidualCite : String := "HOST-DUAL-RESIDUAL"

/-- Prior product path close host map cite. -/
def hostProductPathCloseCite : String := "HOST-PRODUCT-PATH-CLOSE"

/-- Prior inventory close host map cite. -/
def hostInventoryCloseCite : String := "HOST-INVENTORY-CLOSE"

/-- Prior llvm hold host map cite. -/
def hostLlvmHoldCite : String := "HOST-LLVM-HOLD"

/-- EMIT-BOUNDARY cite (host elaborator / proofs vs product extract). -/
def emitBoundaryCite : String := "EMIT-BOUNDARY"

/-- RUNTIME-FS product goal cite. -/
def runtimeFsCite : String := "RUNTIME-FS"

/-- Greppable hosted behavioral probe is smoke debt token. -/
def smokeDebtToken : String := "hosted behavioral probe is smoke debt"

/-- Greppable product freestanding wire token. -/
def productWireToken : String := "product freestanding wire"

/-- Greppable intentional PARTIAL carry token. -/
def intentionalPartialToken : String := "intentional PARTIAL"

/-- probeWireSurfaceOk -- stage ids + probe/wire path cites + prior dual residual
    / close / inventory / llvm hold / emit boundary cites. String canaries only.
    Greppable: probeWireSurfaceOk. -/
def probeWireSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_PROBE_WIRE_V0")
    && (hostProbeWireId == "HOST-PROBE-WIRE")
    && (selfHostProbeWireId == "SELF-HOST-PROBE-WIRE")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/ProbeWire.lean")
    && (inventoryPath == "src/systems/host-partial-inventory.md")
    && (behavioralProbePath == "src/systems/smoke/slake_behavioral_probe.c")
    && (productEmitWirePath == "src/systems/emit/")
    && (productReleaseWirePath == "out/freestanding-c/")
    && (dualResidualStageCite == "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0")
    && (productPathCloseStageCite == "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0")
    && (inventoryCloseStageCite == "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0")
    && (llvmHoldStageCite == "SLAKE_SELF_HOST_LLVM_HOLD_V0")
    && (hostDualResidualCite == "HOST-DUAL-RESIDUAL")
    && (hostProductPathCloseCite == "HOST-PRODUCT-PATH-CLOSE")
    && (hostInventoryCloseCite == "HOST-INVENTORY-CLOSE")
    && (hostLlvmHoldCite == "HOST-LLVM-HOLD")
    && (emitBoundaryCite == "EMIT-BOUNDARY")
    && (runtimeFsCite == "RUNTIME-FS")
    && (smokeDebtToken == "hosted behavioral probe is smoke debt")
    && (productWireToken == "product freestanding wire")
    && (intentionalPartialToken == "intentional PARTIAL")

/-- behavioralProbeIsSmokeDebt -- hosted probe under smoke/ is smoke debt, not
    product residual progress. MUST decide true.
    Greppable: behavioralProbeIsSmokeDebt. -/
def behavioralProbeIsSmokeDebt : Bool := true

/-- behavioralProbeIsNotProductWire -- probe path is not product freestanding
    wire. MUST decide true.
    Greppable: behavioralProbeIsNotProductWire. -/
def behavioralProbeIsNotProductWire : Bool := true

/-- productWireIsEmitPath -- product freestanding wire is emit/out path.
    MUST decide true.
    Greppable: productWireIsEmitPath. -/
def productWireIsEmitPath : Bool := true

/-- probeDoesNotReplaceProductWire -- probe green does not replace wire residual.
    MUST decide true.
    Greppable: probeDoesNotReplaceProductWire. -/
def probeDoesNotReplaceProductWire : Bool := true

/-- residualFreeClaimed -- product residual free claim; MUST decide false.
    Greppable: residualFreeClaimed. -/
def residualFreeClaimed : Bool := false

/-- productSelfHostCompleteClaimed -- MUST decide false (still open).
    Greppable: productSelfHostCompleteClaimed. -/
def productSelfHostCompleteClaimed : Bool := false

/-- probeWireSurfacesDistinct -- hosted behavioral probe and product freestanding
    wire are distinct honesty surfaces: smoke-debt true, not-wire true, emit-path
    true, probe does not replace wire, path cites differ, tokens distinguish.
    Greppable: probeWireSurfacesDistinct. -/
def probeWireSurfacesDistinct : Bool :=
  behavioralProbeIsSmokeDebt
    && behavioralProbeIsNotProductWire
    && productWireIsEmitPath
    && probeDoesNotReplaceProductWire
    && (behavioralProbePath == "src/systems/smoke/slake_behavioral_probe.c")
    && (productEmitWirePath == "src/systems/emit/")
    && (productReleaseWirePath == "out/freestanding-c/")
    && (smokeDebtToken == "hosted behavioral probe is smoke debt")
    && (productWireToken == "product freestanding wire")
    && (emitBoundaryCite == "EMIT-BOUNDARY")
    && (runtimeFsCite == "RUNTIME-FS")
    && !(behavioralProbePath == productEmitWirePath)
    && !(behavioralProbePath == productReleaseWirePath)

/-- probeWireReady -- probe-vs-wire honesty bar after dual residual honesty.
    FAIL-CLOSED: dualResidualReady && surface && surfacesDistinct &&
    smoke-debt + not-wire + emit-path + does-not-replace && free/complete/unlock
    claims stay false.
    Honest scope: probe-vs-wire honesty only -- NOT residual free, NOT
    freestanding product self-host complete, NOT llvm unlock, NOT PROVABLY.
    Greppable: probeWireReady, HOST-PROBE-WIRE. -/
def probeWireReady : Bool :=
  DualResidual.dualResidualReady
    && probeWireSurfaceOk
    && probeWireSurfacesDistinct
    && behavioralProbeIsSmokeDebt
    && behavioralProbeIsNotProductWire
    && productWireIsEmitPath
    && probeDoesNotReplaceProductWire
    && !residualFreeClaimed
    && !productSelfHostCompleteClaimed
    && !SelfApplyFs.freestandingProductSelfHostComplete
    && !LlvmHold.llvmUnlocked
    && !LlvmHold.provablyUnlocked

/-- probeWireDoesNotMeanResidualFree -- probe-vs-wire ready does NOT claim
    freestanding product residual free (probe green != residual free).
    Greppable: probeWireDoesNotMeanResidualFree. -/
def probeWireDoesNotMeanResidualFree : Bool :=
  probeWireReady && !residualFreeClaimed && DualResidual.productResidualRemains

/-- probeWireDoesNotMeanProductComplete -- probe-vs-wire ready does NOT claim
    freestanding product self-host complete.
    Greppable: probeWireDoesNotMeanProductComplete. -/
def probeWireDoesNotMeanProductComplete : Bool :=
  probeWireReady
    && !productSelfHostCompleteClaimed
    && !SelfApplyFs.freestandingProductSelfHostComplete

/-- Full probe-wire ok (alias of probeWireReady for inventory greps). -/
def probeWireOk : Bool := probeWireReady

/-! ### PROBE-WIRE-THEOREM / HOST-PROBE-WIRE-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is probe-vs-wire
  honesty and residual-free claim honesty only. Does not complete SpecProof;
  residualFreeClaimed stays false; probe is smoke debt not product wire.
  maxRecDepth raised for dualResidualReady / probeWireReady unfolds.
-/

set_option maxRecDepth 16384

/-- Primary stage id is greppable SLAKE_SELF_HOST_PROBE_WIRE_V0.
    Greppable: stageId_eq, PROBE-WIRE-THEOREM, HOST-PROBE-WIRE-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_PROBE_WIRE_V0" := rfl

/-- Host map id is greppable HOST-PROBE-WIRE.
    Greppable: hostProbeWireId_eq, PROBE-WIRE-THEOREM. -/
theorem hostProbeWireId_eq : hostProbeWireId = "HOST-PROBE-WIRE" := rfl

/-- Hosted behavioral probe is smoke debt (not product residual progress).
    Greppable: behavioralProbeIsSmokeDebt_true, PROBE-WIRE-THEOREM,
    HOST-PROBE-WIRE-THEOREM. -/
theorem behavioralProbeIsSmokeDebt_true :
    behavioralProbeIsSmokeDebt = true := rfl

/-- Probe path is not the product freestanding wire.
    Greppable: behavioralProbeIsNotProductWire_true, PROBE-WIRE-THEOREM. -/
theorem behavioralProbeIsNotProductWire_true :
    behavioralProbeIsNotProductWire = true := rfl

/-- Product freestanding wire is emit/out path.
    Greppable: productWireIsEmitPath_true, PROBE-WIRE-THEOREM. -/
theorem productWireIsEmitPath_true : productWireIsEmitPath = true := rfl

/-- residualFreeClaimed stays false (probe green != residual free).
    Greppable: residualFreeClaimed_false, PROBE-WIRE-THEOREM,
    HOST-PROBE-WIRE-THEOREM. -/
theorem residualFreeClaimed_false : residualFreeClaimed = false := rfl

/-- Probe-vs-wire honesty readiness holds.
    Greppable: probeWireReady_true, HOST-PROBE-WIRE, PROBE-WIRE-THEOREM,
    HOST-PROBE-WIRE-THEOREM. -/
theorem probeWireReady_true : probeWireReady = true := by decide

/-- Probe-vs-wire ready does NOT mean residual free.
    Greppable: probeWireDoesNotMeanResidualFree_true, PROBE-WIRE-THEOREM. -/
theorem probeWireDoesNotMeanResidualFree_true :
    probeWireDoesNotMeanResidualFree = true := by decide

/-! ### Probe-wire smoke (behavioral; lake build fails if example fails)
    Greppable: PROBE-WIRE-SMOKE, HOST-PROBE-WIRE-SMOKE.
    maxRecDepth already raised above for probeWireReady unfolds. -/

/-- PROBE-WIRE-SMOKE / HOST-PROBE-WIRE-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_PROBE_WIRE_V0" := by decide
example : hostProbeWireId = "HOST-PROBE-WIRE" := by decide
example : selfHostProbeWireId = "SELF-HOST-PROBE-WIRE" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/ProbeWire.lean" := by decide
example : inventoryPath = "src/systems/host-partial-inventory.md" := by decide
example : behavioralProbePath = "src/systems/smoke/slake_behavioral_probe.c" :=
  by decide
example : productEmitWirePath = "src/systems/emit/" := by decide
example : productReleaseWirePath = "out/freestanding-c/" := by decide
example : dualResidualStageCite = "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0" := by decide
example : productPathCloseStageCite = "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0" :=
  by decide
example : inventoryCloseStageCite = "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0" := by decide
example : llvmHoldStageCite = "SLAKE_SELF_HOST_LLVM_HOLD_V0" := by decide
example : hostDualResidualCite = "HOST-DUAL-RESIDUAL" := by decide
example : hostProductPathCloseCite = "HOST-PRODUCT-PATH-CLOSE" := by decide
example : hostInventoryCloseCite = "HOST-INVENTORY-CLOSE" := by decide
example : hostLlvmHoldCite = "HOST-LLVM-HOLD" := by decide
example : emitBoundaryCite = "EMIT-BOUNDARY" := by decide
example : runtimeFsCite = "RUNTIME-FS" := by decide
example : smokeDebtToken = "hosted behavioral probe is smoke debt" := by decide
example : productWireToken = "product freestanding wire" := by decide
example : intentionalPartialToken = "intentional PARTIAL" := by decide
example : probeWireSurfaceOk = true := by decide

/-- PROBE-WIRE-SMOKE: smoke debt / not-wire / emit-path / does-not-replace;
    free/complete/unlock stay false. -/
example : behavioralProbeIsSmokeDebt = true := by decide
example : behavioralProbeIsNotProductWire = true := by decide
example : productWireIsEmitPath = true := by decide
example : probeDoesNotReplaceProductWire = true := by decide
example : residualFreeClaimed = false := by decide
example : productSelfHostCompleteClaimed = false := by decide
example : SelfApplyFs.freestandingProductSelfHostComplete = false := by decide
example : LlvmHold.llvmUnlocked = false := by decide
example : LlvmHold.provablyUnlocked = false := by decide
example : probeWireSurfacesDistinct = true := by decide

/-- PROBE-WIRE-SMOKE: prior dual residual + ladder close + inventory + hold. -/
example : DualResidual.dualResidualReady = true := by decide
example : DualResidual.productResidualRemains = true := by decide
example : ProductPath.productPathCloseReady = true := by decide
example : InventoryClose.inventoryCloseReady = true := by decide
example : LlvmHold.llvmHoldReady = true := by decide

/-- PROBE-WIRE-SMOKE / HOST-PROBE-WIRE-SMOKE: probe-wire ready decides true
    (not residual free; not product complete; not llvm unlock).
    probeWireOk is definitional alias of probeWireReady (joint-name honesty). -/
example : probeWireReady = true := by decide
example : probeWireDoesNotMeanResidualFree = true := by decide
example : probeWireDoesNotMeanProductComplete = true := by decide
example : probeWireOk = true := by decide
example : probeWireOk = probeWireReady := by decide

end SystemsLean.ProbeWire
