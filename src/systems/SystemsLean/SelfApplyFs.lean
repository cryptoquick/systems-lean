/-
  SYSTEMS_LEAN_HOST partial -- freestanding self-application deepen (SH5 deepen).
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): SelfApply.lean SH5 host structural self-application;
    ParityEmit.lean Mult+Linear+Types+Program+Emit freestanding path parity;
    KernelEmit.lean emit plan/apply/body path over program kernel; HostCompose
    extractOkFs RUNTIME-FS path; EmitBody HOST-EMIT-SSOT body fragment;
    EmitMult Mult product text honesty; self-host.md acceptance.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_SELF_APPLY_FS_V0 / HOST-SELF-APPLY-FS / SELF-HOST-SELF-APPLY-FS:
    SH5 freestanding deepen rung -- host self-apply plus freestanding extract
    and body path honesty on the kernel emit compose plus freestanding Mult..Emit
    parity ladder compose (not empty docs; not presence-only canaries alone).
  - freestandingExtractPathReady: fail-closed freestanding extract honesty on
    the self-host kernel emit compose (RUNTIME-FS / EMIT-BOUNDARY):
      empty HostCompose extractOkFs true;
      unminted program compose (KernelEmit.unmintedEmitCompose) extractOkFs false;
      KernelEmit.lowerEmitCompose some + extractOkFs true on that host.
  - freestandingBodyPathReady: freestanding body honesty on same compose
    (mirrors KernelEmit.emitBodyPathReady empty/unminted + emit host):
      empty bodyOk + emptyComposeFragmentSsot + markers;
      unminted bodyOk false;
      bodyOk + bodyIsValid + RUNTIME-FS marker on lowered emit compose body;
      EmitMult.emitMultReady (product Mult text honesty);
      reuses KernelEmit expected body fragment / HOST-EMIT-SSOT / EMIT_BODY_V0
      product wire cites (no new EMIT_* C stage).
  - freestandingSelfApplyPathReady: freestandingExtractPathReady &&
    freestandingBodyPathReady.
  - freestandingParityLadderReady: ParityEmit.multLinearTypesProgramEmitParityReady
    (freestanding Mult+Linear+Types+Program+Emit parity compose bar).
    Under current ParityEmit defs multLinearTypesProgramEmitParityReady is
    equivalent to emitParityReady (not a stronger gate; dual greppable honesty
    for Mult..Emit joint inventory). freestandingEmitParityReady aliases
    ParityEmit.emitParityReady for the same dual-greppable honesty.
  - freestandingProductSelfHostComplete: MUST decide false (still open).
  - freestandingSelfApplyReady: SelfApply.selfApplyReady &&
    freestandingSelfApplyPathReady && freestandingParityLadderReady &&
    surfaceOk && !freestandingProductSelfHostComplete.
    Honest scope: host self-apply + freestanding extract/body path on kernel
    emit compose + freestanding Mult..Emit parity ladder -- NOT "product
    freestanding C rebuilds full Slake end-to-end".
  - selfApplyFsDoesNotComplete: freestandingSelfApplyReady &&
    !freestandingProductSelfHostComplete.
  - Host model = structural freestanding path honesty. Not an AI/ML model.
    Not product C residual free.

  Intentional non-claims / partial parity:
  - PARTIAL: freestanding extract/body path on kernel compose + host self-apply
    + freestanding Mult..Emit parity ladder compose; not freestanding product
    self-host complete; not residual free.
  - Not PROVABLY. Does not unlock llvm / out/llvm-ir (SH6 still held via
    LlvmHold.lean -- hold gate, not unlock).
  - freestandingProductSelfHostComplete remains false forever in this module
    until a later honest product residual (never set true here).
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not grow bash EMIT_* residual treadmill. No new EMIT_* C stage.
  - Does not grow check.sh.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_SELF_APPLY_FS_V0,
  HOST-SELF-APPLY-FS, SELF-HOST-SELF-APPLY-FS, SELF-APPLY-FS-SMOKE,
  HOST-SELF-APPLY-FS-SMOKE, freestandingExtractPathReady,
  freestandingBodyPathReady, freestandingSelfApplyPathReady,
  freestandingParityLadderReady, freestandingEmitParityReady,
  freestandingSelfApplyReady, freestandingProductSelfHostComplete,
  selfApplyFsDoesNotComplete, HOST-SELF-APPLY, selfApplyReady,
  HOST-PARITY-EMIT, SELF-HOST-PARITY-EMIT, SLAKE_SELF_HOST_PARITY_EMIT_V0,
  emitParityReady, multLinearTypesProgramEmitParityReady,
  RUNTIME-FS, EMIT-BOUNDARY, HOST-EMIT-SSOT, EMIT_BODY_V0, HOST-EMIT-MULT,
  SELF-HOST-KERNEL-EMIT, lowerEmitCompose, extractOkFs, bodyOk, emitMultReady,
  UNIT_SURFACE host surface. Module: SystemsLean.SelfApplyFs
  Not freestanding residual free. Not PROVABLY. Not freestanding product
  self-host complete. Not freestanding emit residual free. Not llvm unlocked.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.SelfApply
import SystemsLean.ParityEmit
import SystemsLean.KernelEmit
import SystemsLean.HostCompose
import SystemsLean.EmitBody
import SystemsLean.EmitMult

namespace SystemsLean.SelfApplyFs

/-- Greppable primary stage id for freestanding self-apply deepen (SH5). -/
def stageId : String := "SLAKE_SELF_HOST_SELF_APPLY_FS_V0"

/-- Greppable host map id (HOST-SELF-APPLY-FS). -/
def hostSelfApplyFsId : String := "HOST-SELF-APPLY-FS"

/-- Greppable short map id (SELF-HOST-SELF-APPLY-FS). -/
def selfHostSelfApplyFsId : String := "SELF-HOST-SELF-APPLY-FS"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/SelfApplyFs.lean"

/-- Prior SH5 host structural self-apply stage cite. -/
def selfApplyStageCite : String := "SLAKE_SELF_HOST_SELF_APPLY_V0"

/-- Prior SH4 emit / codegen kernel stage cite (compose surface). -/
def emitKernelStageCite : String := "SLAKE_SELF_HOST_KERNEL_EMIT_V0"

/-- Prior freestanding Emit path parity stage cite (Mult..Emit ladder). -/
def parityEmitStageCite : String := "SLAKE_SELF_HOST_PARITY_EMIT_V0"

/-- Greppable freestanding Emit path parity host map cite. -/
def hostParityEmitCite : String := "HOST-PARITY-EMIT"

/-- Greppable freestanding Emit path parity short map cite. -/
def selfHostParityEmitCite : String := "SELF-HOST-PARITY-EMIT"

/-- Product wire cites (frozen; no new EMIT_* C stage). -/
def productEmitBodyId : String := "EMIT_BODY_V0"
def productHostEmitSsotId : String := "HOST-EMIT-SSOT"
def productHostEmitMultId : String := "HOST-EMIT-MULT"
def runtimeFsMarker : String := "RUNTIME-FS"
def emitBoundaryMarker : String := "EMIT-BOUNDARY"

/-- Surface canary: stage ids + path cites + product wire / prior stage cites
    + freestanding Mult..Emit parity (HOST-PARITY-EMIT) stage cites. -/
def selfApplyFsSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_SELF_APPLY_FS_V0")
    && (hostSelfApplyFsId == "HOST-SELF-APPLY-FS")
    && (selfHostSelfApplyFsId == "SELF-HOST-SELF-APPLY-FS")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/SelfApplyFs.lean")
    && (selfApplyStageCite == "SLAKE_SELF_HOST_SELF_APPLY_V0")
    && (emitKernelStageCite == "SLAKE_SELF_HOST_KERNEL_EMIT_V0")
    && (parityEmitStageCite == "SLAKE_SELF_HOST_PARITY_EMIT_V0")
    && (hostParityEmitCite == "HOST-PARITY-EMIT")
    && (selfHostParityEmitCite == "SELF-HOST-PARITY-EMIT")
    && (productEmitBodyId == "EMIT_BODY_V0")
    && (productHostEmitSsotId == "HOST-EMIT-SSOT")
    && (productHostEmitMultId == "HOST-EMIT-MULT")
    && (runtimeFsMarker == "RUNTIME-FS")
    && (emitBoundaryMarker == "EMIT-BOUNDARY")

/-- freestandingExtractPathReady -- freestanding extract honesty on kernel emit
    compose (RUNTIME-FS / EMIT-BOUNDARY).
    FAIL-CLOSED real Bools:
      1) empty HostCompose extractOkFs true
      2) unminted program compose extractOkFs false
      3) lowerEmitCompose some + extractOkFs true on that host
    Greppable: freestandingExtractPathReady, extractOkFs, RUNTIME-FS. -/
def freestandingExtractPathReady : Bool :=
  let emptyOk := HostCompose.extractOkFs HostCompose.empty
  let unmintedFails := !HostCompose.extractOkFs KernelEmit.unmintedEmitCompose
  match KernelEmit.lowerEmitCompose with
  | none => false
  | some hc =>
      emptyOk && unmintedFails && HostCompose.extractOkFs hc

/-- freestandingBodyPathReady -- freestanding body honesty on kernel emit compose.
    FAIL-CLOSED real Bools (mirrors KernelEmit.emitBodyPathReady empty/unminted):
      1) empty compose bodyOk with emptyComposeFragmentSsot + markers
      2) unminted program compose bodyOk false
      3) lowered emit compose: bodyOk + bodyIsValid + RUNTIME-FS / EMIT_BODY
         markers; exact KernelEmit.expectedBodyFragment (HOST-EMIT-SSOT /
         EMIT_BODY_V0); counts r=2 e=1 tagCount=3
      4) EmitMult.emitMultReady (product Mult text honesty).
    Greppable: freestandingBodyPathReady, bodyOk, HOST-EMIT-SSOT, EMIT_BODY_V0. -/
def freestandingBodyPathReady : Bool :=
  let emptyOk :=
    EmitBody.bodyOk HostCompose.empty
      && (let b := EmitBody.bodyFromCompose HostCompose.empty
          b.buf == EmitBody.emptyComposeFragmentSsot
            && EmitBody.bufHasEmitBodyMarker b.buf
            && EmitBody.bufHasRuntimeFsMarker b.buf)
  let unmintedFails := !EmitBody.bodyOk KernelEmit.unmintedEmitCompose
  match KernelEmit.lowerEmitCompose with
  | none => false
  | some hc =>
      let b := EmitBody.bodyFromCompose hc
      emptyOk
        && unmintedFails
        && EmitBody.bodyOk hc
        && EmitBody.bodyIsValid b
        && EmitBody.bufHasRuntimeFsMarker b.buf
        && EmitBody.bufHasEmitBodyMarker b.buf
        && b.buf == KernelEmit.expectedBodyFragment
        && b.runtimeNodes == 2
        && b.erasedNodes == 1
        && b.tagCount == 3
        && EmitMult.emitMultReady

/-- freestandingSelfApplyPathReady -- extract + body freestanding path on kernel
    emit compose. Greppable: freestandingSelfApplyPathReady. -/
def freestandingSelfApplyPathReady : Bool :=
  freestandingExtractPathReady && freestandingBodyPathReady

/-- freestandingParityLadderReady -- freestanding Mult..Emit parity ladder bar.
    Folds ParityEmit.multLinearTypesProgramEmitParityReady (HOST-PARITY-MULT +
    HOST-PARITY-LINEAR + HOST-PARITY-TYPES + HOST-PARITY-PROGRAM +
    HOST-PARITY-EMIT joint). Under current ParityEmit defs that joint is
    equivalent to emitParityReady (not a stronger gate; dual greppable honesty).
    Greppable: freestandingParityLadderReady, multLinearTypesProgramEmitParityReady,
    HOST-PARITY-EMIT. -/
def freestandingParityLadderReady : Bool :=
  ParityEmit.multLinearTypesProgramEmitParityReady

/-- freestandingEmitParityReady -- dual greppable alias for Emit freestanding
    path parity single bar (ParityEmit.emitParityReady).
    Under current ParityEmit folds, multLinearTypesProgramEmitParityReady is
    equivalent to emitParityReady, so freestandingParityLadderReady and this
    alias are equivalent -- not a stronger gate than freestandingParityLadderReady.
    Greppable: freestandingEmitParityReady, emitParityReady, HOST-PARITY-EMIT. -/
def freestandingEmitParityReady : Bool :=
  ParityEmit.emitParityReady

/-- freestandingProductSelfHostComplete -- MUST decide false (still open).
    SH5 freestanding deepen is not product freestanding C rebuilding full Slake.
    Greppable: freestandingProductSelfHostComplete. -/
def freestandingProductSelfHostComplete : Bool := false

/-- freestandingSelfApplyReady -- SH5 freestanding deepen bar.
    FAIL-CLOSED: host self-apply + freestanding extract/body path + freestanding
    Mult..Emit parity ladder + surface + complete flag remains false.
    Honest scope: SelfApply.selfApplyReady (Mult+Linear+Types+Program+Emit
    host structural) AND freestanding extract/body on kernel emit compose AND
    freestandingParityLadderReady (ParityEmit Mult..Emit freestanding path).
    NOT freestanding product self-host complete.
    Greppable: freestandingSelfApplyReady, HOST-SELF-APPLY-FS. -/
def freestandingSelfApplyReady : Bool :=
  SelfApply.selfApplyReady
    && freestandingSelfApplyPathReady
    && freestandingParityLadderReady
    && selfApplyFsSurfaceOk
    && !freestandingProductSelfHostComplete

/-- selfApplyFsDoesNotComplete -- freestanding deepen ready does NOT complete
    product freestanding self-host. Greppable: selfApplyFsDoesNotComplete. -/
def selfApplyFsDoesNotComplete : Bool :=
  freestandingSelfApplyReady && !freestandingProductSelfHostComplete

/-- Full SH5 freestanding deepen inventory ok. -/
def selfApplyFsOk : Bool := freestandingSelfApplyReady

/-! ### Freestanding self-apply smoke (behavioral; lake build fails if example fails)
    Greppable: SELF-APPLY-FS-SMOKE, HOST-SELF-APPLY-FS-SMOKE.
    maxRecDepth raised for selfApplyReady / freestandingSelfApplyReady /
    freestandingParityLadderReady / emitParityReady unfolds. -/

set_option maxRecDepth 16384

/-- SELF-APPLY-FS-SMOKE / HOST-SELF-APPLY-FS-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_SELF_APPLY_FS_V0" := by decide
example : hostSelfApplyFsId = "HOST-SELF-APPLY-FS" := by decide
example : selfHostSelfApplyFsId = "SELF-HOST-SELF-APPLY-FS" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/SelfApplyFs.lean" := by decide
example : selfApplyStageCite = "SLAKE_SELF_HOST_SELF_APPLY_V0" := by decide
example : emitKernelStageCite = "SLAKE_SELF_HOST_KERNEL_EMIT_V0" := by decide
example : parityEmitStageCite = "SLAKE_SELF_HOST_PARITY_EMIT_V0" := by decide
example : hostParityEmitCite = "HOST-PARITY-EMIT" := by decide
example : selfHostParityEmitCite = "SELF-HOST-PARITY-EMIT" := by decide
example : productEmitBodyId = "EMIT_BODY_V0" := by decide
example : productHostEmitSsotId = "HOST-EMIT-SSOT" := by decide
example : productHostEmitMultId = "HOST-EMIT-MULT" := by decide
example : runtimeFsMarker = "RUNTIME-FS" := by decide
example : emitBoundaryMarker = "EMIT-BOUNDARY" := by decide
example : selfApplyFsSurfaceOk = true := by decide

/-- SELF-APPLY-FS-SMOKE: freestanding extract path (empty / unminted / emit host). -/
example : freestandingExtractPathReady = true := by decide
example : HostCompose.extractOkFs HostCompose.empty = true := by decide
example : HostCompose.extractOkFs KernelEmit.unmintedEmitCompose = false := by decide
example :
    (match KernelEmit.lowerEmitCompose with
     | some hc => HostCompose.extractOkFs hc
     | none => false) = true := by decide

/-- SELF-APPLY-FS-SMOKE: freestanding body path (empty / unminted / emit host). -/
example : freestandingBodyPathReady = true := by decide
example : EmitBody.bodyOk HostCompose.empty = true := by decide
example : EmitBody.bodyOk KernelEmit.unmintedEmitCompose = false := by decide
example : EmitMult.emitMultReady = true := by decide
example :
    (match KernelEmit.lowerEmitCompose with
     | some hc =>
         let b := EmitBody.bodyFromCompose hc
         EmitBody.bodyOk hc && EmitBody.bodyIsValid b
           && EmitBody.bufHasRuntimeFsMarker b.buf
           && b.buf == KernelEmit.expectedBodyFragment
     | none => false) = true := by decide

/-- SELF-APPLY-FS-SMOKE: path ready compose. -/
example : freestandingSelfApplyPathReady = true := by decide

/-- SELF-APPLY-FS-SMOKE: freestanding Mult..Emit parity ladder compose. -/
example : freestandingParityLadderReady = true := by decide
example : freestandingEmitParityReady = true := by decide
example : ParityEmit.multLinearTypesProgramEmitParityReady = true := by decide
example : ParityEmit.emitParityReady = true := by decide

/-- SELF-APPLY-FS-SMOKE: complete flag false; deepen ready true; does not complete. -/
example : freestandingProductSelfHostComplete = false := by decide
example : SelfApply.selfApplyReady = true := by decide
example : freestandingSelfApplyReady = true := by decide
example : selfApplyFsDoesNotComplete = true := by decide
example : selfApplyFsOk = true := by decide

end SystemsLean.SelfApplyFs
