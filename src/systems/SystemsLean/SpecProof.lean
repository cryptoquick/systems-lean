/-
  SYSTEMS_LEAN_HOST partial -- formal spec-proof separation honesty after
  HOST-PROBE-WIRE.
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): ProbeWire.lean probe-vs-wire honesty;
    DualResidual.lean dual residual honesty;
    ProductPath.lean structural product path ladder close;
    InventoryClose.lean inventory close readiness; LlvmHold.lean SH6 hold;
    SelfApplyFs.lean freestanding self-apply (complete stays false);
    Extract.lean EMIT-BOUNDARY / RUNTIME-FS vs RUNTIME-CLASSIC;
    AGENTS.md formal feedback (spec then proof; proofs do not retire tests);
    self-host.md acceptance; host-partial-inventory.md; surface-matrix.md.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_SPEC_PROOF_V0 / HOST-SPEC-PROOF / SELF-HOST-SPEC-PROOF:
    greppable formal spec-proof separation gate -- readable specifications
    are stated as distinct surfaces from proof-complete claims; proof complete
    is NOT forged; a theorem about a host model is not a freestanding emit run;
    a green smoke is not a full proof; proofs do not retire tests/smokes.
  - specSurfaceStated: readable specs exist as statements (module header +
    greppable stage ids + Bool canaries). MUST decide true.
  - proofCompleteClaimed: MUST decide false (do not forge proof complete).
  - specDoesNotImplyProofComplete: stated surface does not imply proof complete.
    MUST decide true when surface stated and proof complete claimed stays false.
  - proofDoesNotRetireTests: proofs do not retire tests / smokes (AGENTS formal
    feedback honesty). MUST decide true.
  - residualFreeClaimed / productSelfHostCompleteClaimed: MUST decide false.
  - specProofSurfaceOk: stage ids + formal-feedback cites + prior
    HOST-PROBE-WIRE / HOST-DUAL-RESIDUAL / HOST-PRODUCT-PATH-CLOSE /
    HOST-INVENTORY-CLOSE / HOST-LLVM-HOLD / EMIT-BOUNDARY / RUNTIME-FS cites.
  - specProofReady: ProbeWire.probeWireReady && surface &&
    specSurfaceStated && proofDoesNotRetireTests &&
    specDoesNotImplyProofComplete && free/complete/unlock claims stay false.
  - specProofDoesNotMeanResidualFree /
    specProofDoesNotMeanProofComplete: ready && free/complete claims false.
  - Host model = structural formal feedback honesty. Not an AI/ML model.
    Not product C residual free. Not freestanding product self-host complete.
    Not proof complete.

  Intentional non-claims / partial:
  - Spec-proof separation honesty only -- NOT freestanding residual free.
  - Spec surface stated is NOT proof complete (proofCompleteClaimed false).
  - Lake example smokes are NOT full proofs; host theorems do not replace
    freestanding emit runs or smoke drivers.
  - Mult MULT-THEOREM / HOST-MULT-THEOREM (ofNat?_fail_closed etc. on Mult.lean)
    are partial Mult proofs only -- they do NOT flip proofCompleteClaimed true.
  - Types TYPES-THEOREM / HOST-TYPES-THEOREM (ofKindTag?_fail_closed etc. on
    Types.lean) are partial Types proofs only -- they do NOT flip
    proofCompleteClaimed true.
  - IrProgram IR-PROGRAM-THEOREM / HOST-IR-PROGRAM-THEOREM
    (isWellTyped_empty_false / EMPTY-PROGRAM-FAIL-CLOSED /
    foldWellTyped_single_value_some etc. on IrProgram.lean)
    are partial IrProgram proofs only -- they do NOT flip proofCompleteClaimed
    true.
  - Types kindMultOk mismatch family + mkNode?_mismatch_none (TYPES-THEOREM
    extend) are partial Types proofs only -- they do NOT flip
    proofCompleteClaimed true.
  - CompilePath COMPILE-PATH-THEOREM / HOST-COMPILE-PATH-THEOREM
    (empty host OK vs empty program fail-closed) are partial only -- they do
    NOT flip proofCompleteClaimed true.
  - IrGraph IR-GRAPH-THEOREM / HOST-IR-GRAPH-THEOREM (EMPTY-GRAPH-OK /
    pushNode_value_one_ok / addEdge_one_node_self_ok /
    addEdge_one_node_badEndpoints) are
    partial only -- they do NOT flip proofCompleteClaimed true.
  - Linear LINEAR-THEOREM / HOST-LINEAR-THEOREM (shareNat_eq / polyId_id /
    roundTrip_eq; JOIN-ALG dual-cite honesty; axioms remain) are honest
    limited only -- they do NOT claim MULT-1 enforcement and do NOT flip
    proofCompleteClaimed true.
  - HostCompose COMPOSE-THEOREM / HOST-COMPOSE-THEOREM (multPreScan_empty_true /
    mint_zero_badId / consume_empty_notLive / nodeMultOk_mult1_eq_live /
    double_consume_notLive / checkFailClosed_eq / pushHostNode_bad_node /
    pushHostNode_value_one_ok / addHostEdge_empty_badEndpoints /
    addHostEdge_two_values_ok / addHostEdge_one_node_badEndpoints etc.) are
    partial HostCompose proofs only -- live-flag model; they do NOT claim
    MULT-1 elaborator enforcement and do NOT flip proofCompleteClaimed true.
  - Extract EXTRACT-THEOREM / HOST-EXTRACT-THEOREM (isFreestandingGoal_runtimeFs /
    extractOk_classic_reject / ofRuntimeTag?_fail_closed etc.) are partial
    Extract proofs only -- intentional MULT-1 thinning remains; they do NOT flip
    proofCompleteClaimed true.
  - Erasure ERASURE-THEOREM / HOST-ERASURE-THEOREM (isRuntimeAbsent_unmarked_false /
    markForGrade?_mult1_none / checkFailClosed_unmarked_false etc.) are partial
    Erasure proofs only -- they do NOT flip proofCompleteClaimed true.
  - EmitBody EMIT-BODY-THEOREM / HOST-EMIT-BODY-THEOREM (bodyCap_eq_256 /
    emptyComposeFragmentSsot_eq / bodyOk_empty_true etc.) are partial EmitBody
    proofs only -- HOST-EMIT-SSOT honesty; they do NOT flip proofCompleteClaimed
    true.
  - EmitPlan EMIT-PLAN-THEOREM / HOST-EMIT-PLAN-THEOREM (planOk_empty_true /
    planFromCompose_empty_counts_zero / planOk_mult1_unminted_false /
    planOk_mult1_minted_true / planFromCompose_two_values_edge /
    planFromCompose_linear_and_erased etc.) are partial EmitPlan proofs only --
    they do NOT flip proofCompleteClaimed true.
  - EmitApply EMIT-APPLY-THEOREM / HOST-EMIT-APPLY-THEOREM (applyCap_eq_32 /
    applyOk_empty_true / applyOk_linear_without_mint_false / packTag_linear /
    applyFromCompose_mult1_minted_tags /
    applyFromCompose_linear_and_erased_order /
    applyIsValid_count_tags_desync_false etc.) are partial EmitApply proofs
    only -- they do NOT flip proofCompleteClaimed true.
  - JoinMap JOIN-MAP-THEOREM / HOST-JOIN-MAP-THEOREM
    (joinUnitCompileReady_empty_true / joinProgramCompileReady_empty_false /
    joinAlgContractOk_true) are partial surface canaries only -- not formal dual
    bridge theorems; they do NOT flip proofCompleteClaimed true.
  - SelfHost SELF-HOST-THEOREM / HOST-SELF-HOST-THEOREM
    (selfHostUnitReady_empty_true / selfHostProgramReady_empty_false /
    hostSurfaceOk_true) are partial direction readiness only -- they do NOT flip
    proofCompleteClaimed true.
  - KernelMult KERNEL-MULT-THEOREM / HOST-KERNEL-MULT-THEOREM
    (multKernelReady_true / kernelOk_true / programCompileReady_empty_false)
    are partial Mult IR fixture proofs only -- they do NOT flip
    proofCompleteClaimed true.
  - KernelLinear KERNEL-LINEAR-THEOREM / HOST-KERNEL-LINEAR-THEOREM
    (linearKernelReady_true / linearKernelOk_true / linearHostPathReady_true /
    programCompileReady_empty_false) are partial Linear IR + host compose
    proofs only -- they do NOT flip proofCompleteClaimed true.
  - ParityMult PARITY-MULT-THEOREM / HOST-PARITY-MULT-THEOREM
    (multParityReady_true / gradeParityOk_true / ofNatRoundTripOk_true /
    multParityOk_eq_ready joint-name alias honesty)
    are partial Mult grades closed-loop proofs only -- they do NOT flip
    proofCompleteClaimed true.
  - KernelTypes KERNEL-TYPES-THEOREM / HOST-KERNEL-TYPES-THEOREM
    (typesKernelReady_true / typesKernelOk_true / programCompileReady_empty_false)
    are partial Types IR + program path proofs only -- they do NOT flip
    proofCompleteClaimed true.
  - KernelProgram KERNEL-PROGRAM-THEOREM / HOST-KERNEL-PROGRAM-THEOREM
    (programKernelReady_true / programKernelOk_true / programCompileReady_empty_false)
    are partial program / graph / compose proofs only -- they do NOT flip
    proofCompleteClaimed true.
  - KernelEmit KERNEL-EMIT-THEOREM / HOST-KERNEL-EMIT-THEOREM
    (emitKernelReady_true / emitKernelOk_true / emitPlanPathReady_true)
    are partial codegen host honesty proofs only -- they do NOT flip
    proofCompleteClaimed true.
  - ParityLinear PARITY-LINEAR-THEOREM / HOST-PARITY-LINEAR-THEOREM
    (linearParityReady_true / linearContractParityOk_true /
    multLinearParityReady_true) are partial Linear freestanding path proofs
    only -- they do NOT flip proofCompleteClaimed true.
  - ParityTypes PARITY-TYPES-THEOREM / HOST-PARITY-TYPES-THEOREM
    (typesParityReady_true / typesContractParityOk_true /
    multLinearTypesParityReady_true) are partial Types freestanding path
    proofs only -- they do NOT flip proofCompleteClaimed true.
  - ParityProgram PARITY-PROGRAM-THEOREM / HOST-PARITY-PROGRAM-THEOREM
    (programParityReady_true / programContractParityOk_true /
    multLinearTypesProgramParityReady_true) are partial Program freestanding
    path proofs only -- they do NOT flip proofCompleteClaimed true.
  - ParityEmit PARITY-EMIT-THEOREM / HOST-PARITY-EMIT-THEOREM
    (emitParityReady_true / emitContractParityOk_true /
    multLinearTypesProgramEmitParityReady_true) are partial Emit freestanding
    path proofs only -- they do NOT flip proofCompleteClaimed true.
  - SurfaceMatrix SURFACE-MATRIX-THEOREM / HOST-SURFACE-MATRIX-THEOREM
    (matrixUnitReady_empty_true / matrixProgramReady_empty_false /
    matrixSurfaceOk_true) are partial surface inventory readiness canaries
    only -- they do NOT flip proofCompleteClaimed true.
  - SelfApply SELF-APPLY-THEOREM / HOST-SELF-APPLY-THEOREM
    (selfApplyReady_true / kernelRebuildsKernel_true / selfApplySurfaceOk_true /
    selfApplyOk_eq_ready; selfApplyOk definitional alias of selfApplyReady)
    are partial host structural self-apply readiness canaries only -- they do
    NOT flip proofCompleteClaimed true.
  - SelfApplyFs SELF-APPLY-FS-THEOREM / HOST-SELF-APPLY-FS-THEOREM
    (freestandingSelfApplyReady_true / freestandingProductSelfHostComplete_false)
    are partial freestanding path readiness canaries only -- complete stays
    false; they do NOT flip proofCompleteClaimed true.
  - InventoryClose INVENTORY-CLOSE-THEOREM / HOST-INVENTORY-CLOSE-THEOREM
    (inventoryCloseReady_true / residualFreeClaimed_false) are partial
    inventory close readiness canaries only -- residual free stays false; they
    do NOT flip proofCompleteClaimed true.
  - ProductPath PRODUCT-PATH-THEOREM / HOST-PRODUCT-PATH-THEOREM
    (productPathReady_true / productPathCloseReady_true /
    residualFreeClaimed_false) are partial product path readiness canaries
    only -- residual free / product complete stay false; they do NOT flip
    proofCompleteClaimed true. No ProductPath alias theater growth.
  - DualResidual DUAL-RESIDUAL-THEOREM / HOST-DUAL-RESIDUAL-THEOREM
    (dualResidualReady_true / hostElaboratorResidualRemains_true /
    productResidualRemains_true / residualFreeClaimed_false /
    dualResidualOk_eq_ready; dualResidualOk definitional alias of
    dualResidualReady) are partial dual residual honesty canaries only --
    neither residual forged free; they do NOT flip proofCompleteClaimed true.
  - ProbeWire PROBE-WIRE-THEOREM / HOST-PROBE-WIRE-THEOREM
    (probeWireReady_true / behavioralProbeIsSmokeDebt_true /
    residualFreeClaimed_false) are partial probe-vs-wire honesty canaries
    only -- probe green != residual free; they do NOT flip
    proofCompleteClaimed true.
  - SpecProof SPEC-PROOF-THEOREM / HOST-SPEC-PROOF-THEOREM
    (specProofReady_true / proofCompleteClaimed_false / residualFreeClaimed_false)
    are formal feedback honesty canaries only -- proof complete stays false
    (proved false); they do NOT flip proofCompleteClaimed true.
  - LlvmHold LLVM-HOLD-THEOREM / HOST-LLVM-HOLD-THEOREM
    (llvmHoldReady_true / llvmUnlocked_false / provablyUnlocked_false /
    sh6HoldReady_eq_llvmHoldReady; sh6HoldReady definitional alias of
    llvmHoldReady) are SH6 hold honesty canaries only -- unlock stays false;
    they do NOT flip proofCompleteClaimed true.
  - NOT freestanding product self-host complete.
  - NOT PROVABLY. Does not unlock llvm / out/llvm-ir (LlvmHold still holds).
  - Intentional PARTIAL carry remains.
  - Does not mint ProductPath / DualResidual / ProbeWire alias theater.
  - No new EMIT_* C stage. Does not grow check.sh. Does not grow probe C body.

  Theorems (SPEC-PROOF-THEOREM / HOST-SPEC-PROOF-THEOREM -- partial SpecProof):
  - specProofReady_true / proofCompleteClaimed_false / residualFreeClaimed_false
  - specSurfaceStated_true / proofDoesNotRetireTests_true
  - specProofDoesNotMeanProofComplete_true / specProofDoesNotMeanResidualFree_true
  - stageId_eq / hostSpecProofId_eq
  These SpecProof theorems keep proofCompleteClaimed false (proved false).
  Spec surface stated is NOT proof complete.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_SPEC_PROOF_V0,
  HOST-SPEC-PROOF, SELF-HOST-SPEC-PROOF, SPEC-PROOF-SMOKE,
  HOST-SPEC-PROOF-SMOKE, specProofReady, specProofSurfaceOk,
  specSurfaceStated, proofCompleteClaimed, specDoesNotImplyProofComplete,
  proofDoesNotRetireTests, residualFreeClaimed,
  productSelfHostCompleteClaimed, specProofOk,
  specProofDoesNotMeanResidualFree, specProofDoesNotMeanProofComplete,
  HOST-PROBE-WIRE, HOST-DUAL-RESIDUAL, HOST-PRODUCT-PATH-CLOSE,
  HOST-INVENTORY-CLOSE, HOST-LLVM-HOLD, EMIT-BOUNDARY, RUNTIME-FS,
  probeWireReady, productPathCloseReady, freestandingProductSelfHostComplete,
  llvmUnlocked, provablyUnlocked, intentional PARTIAL, SELF-HOST,
  MULT-0, MULT-1, MULT-OMEGA, SPEC-PROOF-THEOREM, HOST-SPEC-PROOF-THEOREM,
  proofCompleteClaimed_false, specProofReady_true, residualFreeClaimed_false,
  UNIT_SURFACE host surface.
  Module: SystemsLean.SpecProof
  Not freestanding residual free. Not PROVABLY.
  Not freestanding product self-host complete. Not freestanding emit residual free.
  Not llvm unlocked. Not host elaborator residual free. Not proof complete.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.ProbeWire
import SystemsLean.DualResidual
import SystemsLean.ProductPath
import SystemsLean.InventoryClose
import SystemsLean.SelfApplyFs
import SystemsLean.LlvmHold

namespace SystemsLean.SpecProof

/-- Greppable primary stage id for formal spec-proof separation. -/
def stageId : String := "SLAKE_SELF_HOST_SPEC_PROOF_V0"

/-- Greppable host map id (HOST-SPEC-PROOF). -/
def hostSpecProofId : String := "HOST-SPEC-PROOF"

/-- Greppable short map id (SELF-HOST-SPEC-PROOF). -/
def selfHostSpecProofId : String := "SELF-HOST-SPEC-PROOF"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/SpecProof.lean"

/-- Read-only PARTIAL inventory path cite (not a filesystem read). -/
def inventoryPath : String := "src/systems/host-partial-inventory.md"

/-- Prior probe-vs-wire stage cite. -/
def probeWireStageCite : String := "SLAKE_SELF_HOST_PROBE_WIRE_V0"

/-- Prior dual residual stage cite. -/
def dualResidualStageCite : String := "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0"

/-- Prior product path close stage cite. -/
def productPathCloseStageCite : String := "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0"

/-- Prior inventory close stage cite. -/
def inventoryCloseStageCite : String := "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0"

/-- Prior llvm hold stage cite. -/
def llvmHoldStageCite : String := "SLAKE_SELF_HOST_LLVM_HOLD_V0"

/-- Prior probe-vs-wire host map cite. -/
def hostProbeWireCite : String := "HOST-PROBE-WIRE"

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

/-- Greppable readable specification surface stated token. -/
def specSurfaceToken : String := "readable specification surface stated"

/-- Greppable proof complete not forged token. -/
def proofNotCompleteToken : String := "proof complete not forged"

/-- Greppable proofs do not retire tests token (AGENTS formal feedback). -/
def proofDoesNotRetireTestsToken : String := "proofs do not retire tests"

/-- Greppable intentional PARTIAL carry token. -/
def intentionalPartialToken : String := "intentional PARTIAL"

/-- specProofSurfaceOk -- stage ids + formal-feedback cites + prior probe-wire /
    dual residual / close / inventory / llvm hold / emit boundary cites.
    String canaries only. Greppable: specProofSurfaceOk. -/
def specProofSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_SPEC_PROOF_V0")
    && (hostSpecProofId == "HOST-SPEC-PROOF")
    && (selfHostSpecProofId == "SELF-HOST-SPEC-PROOF")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/SpecProof.lean")
    && (inventoryPath == "src/systems/host-partial-inventory.md")
    && (probeWireStageCite == "SLAKE_SELF_HOST_PROBE_WIRE_V0")
    && (dualResidualStageCite == "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0")
    && (productPathCloseStageCite == "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0")
    && (inventoryCloseStageCite == "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0")
    && (llvmHoldStageCite == "SLAKE_SELF_HOST_LLVM_HOLD_V0")
    && (hostProbeWireCite == "HOST-PROBE-WIRE")
    && (hostDualResidualCite == "HOST-DUAL-RESIDUAL")
    && (hostProductPathCloseCite == "HOST-PRODUCT-PATH-CLOSE")
    && (hostInventoryCloseCite == "HOST-INVENTORY-CLOSE")
    && (hostLlvmHoldCite == "HOST-LLVM-HOLD")
    && (emitBoundaryCite == "EMIT-BOUNDARY")
    && (runtimeFsCite == "RUNTIME-FS")
    && (specSurfaceToken == "readable specification surface stated")
    && (proofNotCompleteToken == "proof complete not forged")
    && (proofDoesNotRetireTestsToken == "proofs do not retire tests")
    && (intentionalPartialToken == "intentional PARTIAL")

/-- specSurfaceStated -- readable specifications exist as statements (module
    header Spec block + greppable stage ids + Bool canaries). MUST decide true.
    Greppable: specSurfaceStated. -/
def specSurfaceStated : Bool := true

/-- proofCompleteClaimed -- MUST decide false (do not forge proof complete).
    Greppable: proofCompleteClaimed. -/
def proofCompleteClaimed : Bool := false

/-- proofDoesNotRetireTests -- proofs do not retire tests / smokes (AGENTS formal
    feedback: a theorem about a host model is not a freestanding emit run; a
    green smoke is not a full proof). MUST decide true.
    Greppable: proofDoesNotRetireTests. -/
def proofDoesNotRetireTests : Bool := true

/-- residualFreeClaimed -- product residual free claim; MUST decide false.
    Greppable: residualFreeClaimed. -/
def residualFreeClaimed : Bool := false

/-- productSelfHostCompleteClaimed -- MUST decide false (still open).
    Greppable: productSelfHostCompleteClaimed. -/
def productSelfHostCompleteClaimed : Bool := false

/-- specDoesNotImplyProofComplete -- readable spec surface does NOT imply
    proof complete. True when surface stated and proof complete claimed false.
    Greppable: specDoesNotImplyProofComplete. -/
def specDoesNotImplyProofComplete : Bool :=
  specSurfaceStated
    && !proofCompleteClaimed
    && (specSurfaceToken == "readable specification surface stated")
    && (proofNotCompleteToken == "proof complete not forged")

/-- specProofReady -- formal spec-proof separation bar after probe-vs-wire honesty.
    FAIL-CLOSED: probeWireReady && surface && specSurfaceStated &&
    proofDoesNotRetireTests && specDoesNotImplyProofComplete &&
    free/complete/unlock claims stay false.
    Honest scope: formal feedback honesty only -- NOT residual free, NOT
    proof complete, NOT freestanding product self-host complete, NOT llvm unlock,
    NOT PROVABLY.
    Greppable: specProofReady, HOST-SPEC-PROOF. -/
def specProofReady : Bool :=
  ProbeWire.probeWireReady
    && specProofSurfaceOk
    && specSurfaceStated
    && proofDoesNotRetireTests
    && specDoesNotImplyProofComplete
    && !proofCompleteClaimed
    && !residualFreeClaimed
    && !productSelfHostCompleteClaimed
    && !SelfApplyFs.freestandingProductSelfHostComplete
    && !LlvmHold.llvmUnlocked
    && !LlvmHold.provablyUnlocked

/-- specProofDoesNotMeanResidualFree -- spec-proof ready does NOT claim
    freestanding product residual free.
    Greppable: specProofDoesNotMeanResidualFree. -/
def specProofDoesNotMeanResidualFree : Bool :=
  specProofReady && !residualFreeClaimed && DualResidual.productResidualRemains

/-- specProofDoesNotMeanProofComplete -- spec-proof ready does NOT claim
    proof complete (spec stated != proof complete).
    Greppable: specProofDoesNotMeanProofComplete. -/
def specProofDoesNotMeanProofComplete : Bool :=
  specProofReady && !proofCompleteClaimed && specDoesNotImplyProofComplete

/-- Full spec-proof ok (alias of specProofReady for inventory greps). -/
def specProofOk : Bool := specProofReady

/-! ### SPEC-PROOF-THEOREM / HOST-SPEC-PROOF-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is formal
  feedback honesty only. proofCompleteClaimed stays false (proved false --
  never set true). Does not claim residual free / freestanding product
  self-host complete / PROVABLY / llvm unlock.
  maxRecDepth raised for probeWireReady / specProofReady unfolds.
-/

set_option maxRecDepth 16384

/-- Primary stage id is greppable SLAKE_SELF_HOST_SPEC_PROOF_V0.
    Greppable: stageId_eq, SPEC-PROOF-THEOREM, HOST-SPEC-PROOF-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_SPEC_PROOF_V0" := rfl

/-- Host map id is greppable HOST-SPEC-PROOF.
    Greppable: hostSpecProofId_eq, SPEC-PROOF-THEOREM. -/
theorem hostSpecProofId_eq : hostSpecProofId = "HOST-SPEC-PROOF" := rfl

/-- Readable specification surface is stated (module header + Bool canaries).
    Greppable: specSurfaceStated_true, SPEC-PROOF-THEOREM,
    HOST-SPEC-PROOF-THEOREM. -/
theorem specSurfaceStated_true : specSurfaceStated = true := rfl

/-- proofCompleteClaimed stays false (do not forge proof complete).
    Greppable: proofCompleteClaimed_false, SPEC-PROOF-THEOREM,
    HOST-SPEC-PROOF-THEOREM. -/
theorem proofCompleteClaimed_false : proofCompleteClaimed = false := rfl

/-- Proofs do not retire tests / smokes (formal feedback honesty).
    Greppable: proofDoesNotRetireTests_true, SPEC-PROOF-THEOREM. -/
theorem proofDoesNotRetireTests_true : proofDoesNotRetireTests = true := rfl

/-- residualFreeClaimed stays false (spec-proof ready != residual free).
    Greppable: residualFreeClaimed_false, SPEC-PROOF-THEOREM. -/
theorem residualFreeClaimed_false : residualFreeClaimed = false := rfl

/-- Formal spec-proof separation readiness holds (not proof complete).
    Greppable: specProofReady_true, HOST-SPEC-PROOF, SPEC-PROOF-THEOREM,
    HOST-SPEC-PROOF-THEOREM. -/
theorem specProofReady_true : specProofReady = true := by decide

/-- Spec-proof ready does NOT mean proof complete.
    Greppable: specProofDoesNotMeanProofComplete_true, SPEC-PROOF-THEOREM,
    HOST-SPEC-PROOF-THEOREM. -/
theorem specProofDoesNotMeanProofComplete_true :
    specProofDoesNotMeanProofComplete = true := by decide

/-- Spec-proof ready does NOT mean residual free.
    Greppable: specProofDoesNotMeanResidualFree_true, SPEC-PROOF-THEOREM. -/
theorem specProofDoesNotMeanResidualFree_true :
    specProofDoesNotMeanResidualFree = true := by decide

/-! ### Spec-proof smoke (behavioral; lake build fails if example fails)
    Greppable: SPEC-PROOF-SMOKE, HOST-SPEC-PROOF-SMOKE.
    maxRecDepth already raised above for specProofReady unfolds. -/

/-- SPEC-PROOF-SMOKE / HOST-SPEC-PROOF-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_SPEC_PROOF_V0" := by decide
example : hostSpecProofId = "HOST-SPEC-PROOF" := by decide
example : selfHostSpecProofId = "SELF-HOST-SPEC-PROOF" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/SpecProof.lean" := by decide
example : inventoryPath = "src/systems/host-partial-inventory.md" := by decide
example : probeWireStageCite = "SLAKE_SELF_HOST_PROBE_WIRE_V0" := by decide
example : dualResidualStageCite = "SLAKE_SELF_HOST_DUAL_RESIDUAL_V0" := by decide
example : productPathCloseStageCite = "SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0" :=
  by decide
example : inventoryCloseStageCite = "SLAKE_SELF_HOST_INVENTORY_CLOSE_V0" := by decide
example : llvmHoldStageCite = "SLAKE_SELF_HOST_LLVM_HOLD_V0" := by decide
example : hostProbeWireCite = "HOST-PROBE-WIRE" := by decide
example : hostDualResidualCite = "HOST-DUAL-RESIDUAL" := by decide
example : hostProductPathCloseCite = "HOST-PRODUCT-PATH-CLOSE" := by decide
example : hostInventoryCloseCite = "HOST-INVENTORY-CLOSE" := by decide
example : hostLlvmHoldCite = "HOST-LLVM-HOLD" := by decide
example : emitBoundaryCite = "EMIT-BOUNDARY" := by decide
example : runtimeFsCite = "RUNTIME-FS" := by decide
example : specSurfaceToken = "readable specification surface stated" := by decide
example : proofNotCompleteToken = "proof complete not forged" := by decide
example : proofDoesNotRetireTestsToken = "proofs do not retire tests" := by decide
example : intentionalPartialToken = "intentional PARTIAL" := by decide
example : specProofSurfaceOk = true := by decide

/-- SPEC-PROOF-SMOKE: surface stated; proof complete / free / unlock stay false. -/
example : specSurfaceStated = true := by decide
example : proofCompleteClaimed = false := by decide
example : proofDoesNotRetireTests = true := by decide
example : residualFreeClaimed = false := by decide
example : productSelfHostCompleteClaimed = false := by decide
example : SelfApplyFs.freestandingProductSelfHostComplete = false := by decide
example : LlvmHold.llvmUnlocked = false := by decide
example : LlvmHold.provablyUnlocked = false := by decide
example : specDoesNotImplyProofComplete = true := by decide

/-- SPEC-PROOF-SMOKE: prior probe-wire + dual residual + ladder + inventory + hold. -/
example : ProbeWire.probeWireReady = true := by decide
example : DualResidual.dualResidualReady = true := by decide
example : DualResidual.productResidualRemains = true := by decide
example : ProductPath.productPathCloseReady = true := by decide
example : InventoryClose.inventoryCloseReady = true := by decide
example : LlvmHold.llvmHoldReady = true := by decide

/-- SPEC-PROOF-SMOKE / HOST-SPEC-PROOF-SMOKE: spec-proof ready decides true
    (not residual free; not proof complete; not product complete; not llvm unlock).
    specProofOk is definitional alias of specProofReady (joint-name honesty). -/
example : specProofReady = true := by decide
example : specProofDoesNotMeanResidualFree = true := by decide
example : specProofDoesNotMeanProofComplete = true := by decide
example : specProofOk = true := by decide
example : specProofOk = specProofReady := by decide

end SystemsLean.SpecProof
