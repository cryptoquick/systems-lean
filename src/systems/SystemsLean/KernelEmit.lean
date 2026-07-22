/-
  SYSTEMS_LEAN_HOST partial -- freestanding codegen host honesty (SH4 remainder).
  Side: classic Lean elaborator under src/systems/ (not freestanding C).
  Pair map (read-only): KernelProgram.lean program / graph / compose kernel;
    EmitPlan.lean plan readiness; EmitApply.lean tag apply; EmitBody.lean
    HOST-EMIT-SSOT body fragment; EmitMult.lean Mult product text honesty;
    HostCompose.lean mint/mark path; self-host.md acceptance;
    product EMIT_PLAN_V0 / EMIT_APPLY_V0 / EMIT_BODY_V0 / HOST-EMIT-SSOT
    (frozen wire + host fragment dialect; no new EMIT_* residual C stage).

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_KERNEL_EMIT_V0 / SELF-HOST-KERNEL-EMIT / HOST-KERNEL-EMIT:
    SH4 ladder growth -- host-owned emit plan / apply / body path over the
    program kernel surface (not a Bool canary alone; not a new bash EMIT stage).
  - lowerEmitCompose: fail-closed HostCompose from KernelProgram program
    fixture (3 nodes + chain edges) with MULT-0 markErased + MULT-1 mint.
  - emitPlanPathReady: planOk / isReady on lowered compose; runtime=2 erased=1
    nodeCount=3 edgeCount=2; empty compose plan ready with zero counts;
    unminted MULT-1 fails plan (fail-closed).
  - emitApplyPathReady: applyOk / applyIsValid; tags [2, 17, 32] program order
    (erased / linear / value packTag); unminted fails apply.
  - emitBodyPathReady: bodyOk / bodyIsValid; HOST-EMIT-SSOT markers from buf;
    inventory r=2 e=1 tagCount=3; exact fragment text; empty compose uses
    emptyComposeFragmentSsot; unminted fails body.
  - emitKernelReady: programKernelReady && emitPlanPathReady &&
    emitApplyPathReady && emitBodyPathReady && emitMultReady && surface canary.
  - Host model = structural codegen readiness compose over program kernel +
    existing emit modules. Not an AI/ML model. Not product C residual free.
    Not freestanding product self-host complete.

  Intentional non-claims / partial parity:
  - PARTIAL: host plan/apply/body readiness + Mult text honesty over program
    kernel only; not full freestanding product module emit mill; not CFG/SSA;
    not freestanding product self-host complete (SH5 is SelfApply).
  - Product wire bulk still frozen at EMIT_BODY_V0 except HOST-EMIT-SSOT +
    HOST-EMIT-MULT (no new EMIT_* C residual stage).
  - Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not unlock llvm. Does not grow bash EMIT_* residual treadmill.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_KERNEL_EMIT_V0,
  SELF-HOST-KERNEL-EMIT, HOST-KERNEL-EMIT, SELF-HOST, KERNEL-EMIT-SMOKE,
  EMIT-PLAN, EMIT-APPLY, EMIT-BODY, HOST-EMIT-SSOT, HOST-EMIT-MULT,
  HOST-KERNEL-PROGRAM, programKernelReady, emitKernelReady, planOk, applyOk,
  bodyOk, emitMultReady, EMIT_PLAN_V0, EMIT_APPLY_V0, EMIT_BODY_V0,
  RUNTIME-FS, FAIL-CLOSED, MULT-0, MULT-1, MULT-OMEGA
  UNIT_SURFACE host surface. Module: SystemsLean.KernelEmit
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.HostCompose
import SystemsLean.EmitPlan
import SystemsLean.EmitApply
import SystemsLean.EmitBody
import SystemsLean.EmitMult
import SystemsLean.KernelProgram

namespace SystemsLean.KernelEmit

open SystemsLean.HostCompose (Host)

/-- Greppable primary stage id for emit / codegen self-host kernel (SH4 remainder). -/
def stageId : String := "SLAKE_SELF_HOST_KERNEL_EMIT_V0"

/-- Greppable short map id (SELF-HOST-KERNEL-EMIT). -/
def kernelEmitId : String := "SELF-HOST-KERNEL-EMIT"

/-- Greppable host map id (HOST-KERNEL-EMIT). -/
def hostKernelEmitId : String := "HOST-KERNEL-EMIT"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/KernelEmit.lean"

/-- Prior program kernel stage cite (composed into emit kernel). -/
def programKernelStageCite : String := "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0"

/-- Read-only product emit stage / API cites (frozen wire; no new stage). -/
def productEmitPlanId : String := "EMIT_PLAN_V0"
def productEmitApplyId : String := "EMIT_APPLY_V0"
def productEmitBodyId : String := "EMIT_BODY_V0"
def productHostEmitSsotId : String := "HOST-EMIT-SSOT"
def productHostEmitMultId : String := "HOST-EMIT-MULT"
def productEmitPlanApi : String := "slake_emit_plan"
def productEmitApplyApi : String := "slake_emit_apply"
def productEmitBodyApi : String := "slake_emit_body"

/-- Expected apply tags for program kernel order: erased, linear, value.
    packTag: mult high nibble, kind low -- 0x02, 0x11, 0x20. -/
def expectedTagErased : Nat := 2
def expectedTagLinear : Nat := 17
def expectedTagValue : Nat := 32

/-- Exact HOST-EMIT-SSOT fragment for program-kernel emit host (r=2 e=1). -/
def expectedBodyFragment : String :=
  "/* EMIT_BODY_V0 RUNTIME-FS r=2 e=1 */\n"
    ++ "/* t0 mult=0 kind=2 */\n"
    ++ "/* t1 mult=1 kind=1 */\n"
    ++ "/* t2 mult=2 kind=0 */\n"

/-- lowerEmitCompose -- HostCompose ready for plan/apply/body from program kernel.
    FAIL-CLOSED: none if program compose lower, mark, or mint fails.
    MULT-0 markErased + MULT-1 mint (smokeMintId from KernelProgram).
    Host structural model of codegen input -- not product C residual free. -/
def lowerEmitCompose : Option Host :=
  match KernelProgram.lowerProgramCompose with
  | none => none
  | some hcRaw =>
    let hcMarked := HostCompose.markErased hcRaw
    match KernelProgram.mintHost hcMarked KernelProgram.smokeMintId with
    | none => none
    | some hc => some hc

/-- emitHost -- emit-ready compose when lower succeeds; empty on fail.
    Prefer emitKernelReady / lowerEmitCompose for fail-closed checks. -/
def emitHost : Host :=
  match lowerEmitCompose with
  | some hc => hc
  | none => HostCompose.empty

/-- Unminted program compose (MULT-1 live without mint) -- fail-closed fixture. -/
def unmintedEmitCompose : Host :=
  match KernelProgram.lowerProgramCompose with
  | some hc => hc
  | none => HostCompose.empty

/-- emitPlanPathReady -- EMIT-PLAN path honesty over program kernel surface.
    FAIL-CLOSED checks:
      1) empty compose plan ready with zero counts
      2) unminted MULT-1 program compose fails plan
      3) emit host plan ready: nodeCount=3 edgeCount=2 runtime=2 erased=1
    Greppable: emitPlanPathReady, EMIT-PLAN, planOk, planFromCompose. -/
def emitPlanPathReady : Bool :=
  let emptyOk :=
    EmitPlan.planOk HostCompose.empty
      && (let p := EmitPlan.planFromCompose HostCompose.empty
          p.nodeCount == 0 && p.edgeCount == 0 && p.runtimeNodes == 0
            && p.erasedNodes == 0 && EmitPlan.isReady p)
  let unmintedFails := !EmitPlan.planOk unmintedEmitCompose
  match lowerEmitCompose with
  | none => false
  | some hc =>
      let p := EmitPlan.planFromCompose hc
      emptyOk
        && unmintedFails
        && EmitPlan.planOk hc
        && EmitPlan.isReady p
        && p.nodeCount == 3
        && p.edgeCount == 2
        && p.runtimeNodes == 2
        && p.erasedNodes == 1

/-- emitApplyPathReady -- EMIT-APPLY path honesty over program kernel surface.
    FAIL-CLOSED checks:
      1) empty compose apply valid count 0
      2) unminted fails apply
      3) emit host tags [2, 17, 32] count 3 applyIsValid
    Greppable: emitApplyPathReady, EMIT-APPLY, applyOk, applyFromCompose. -/
def emitApplyPathReady : Bool :=
  let emptyOk :=
    EmitApply.applyOk HostCompose.empty
      && (let a := EmitApply.applyFromCompose HostCompose.empty
          a.valid && a.count == 0 && a.tags.isEmpty)
  let unmintedFails := !EmitApply.applyOk unmintedEmitCompose
  match lowerEmitCompose with
  | none => false
  | some hc =>
      let a := EmitApply.applyFromCompose hc
      emptyOk
        && unmintedFails
        && EmitApply.applyOk hc
        && EmitApply.applyIsValid a
        && a.count == 3
        && a.tags == [expectedTagErased, expectedTagLinear, expectedTagValue]
        && EmitApply.tagMult expectedTagErased == 0
        && EmitApply.tagKind expectedTagErased == 2
        && EmitApply.tagMult expectedTagLinear == 1
        && EmitApply.tagKind expectedTagLinear == 1
        && EmitApply.tagMult expectedTagValue == 2
        && EmitApply.tagKind expectedTagValue == 0

/-- emitBodyPathReady -- EMIT-BODY / HOST-EMIT-SSOT path honesty.
    FAIL-CLOSED checks:
      1) empty compose body == emptyComposeFragmentSsot with markers
      2) unminted fails body
      3) emit host bodyIsValid; r=2 e=1 tagCount=3; exact fragment text
    Greppable: emitBodyPathReady, EMIT-BODY, HOST-EMIT-SSOT, bodyOk. -/
def emitBodyPathReady : Bool :=
  let emptyOk :=
    EmitBody.bodyOk HostCompose.empty
      && (let b := EmitBody.bodyFromCompose HostCompose.empty
          b.buf == EmitBody.emptyComposeFragmentSsot
            && EmitBody.bufHasEmitBodyMarker b.buf
            && EmitBody.bufHasRuntimeFsMarker b.buf)
  let unmintedFails := !EmitBody.bodyOk unmintedEmitCompose
  match lowerEmitCompose with
  | none => false
  | some hc =>
      let b := EmitBody.bodyFromCompose hc
      emptyOk
        && unmintedFails
        && EmitBody.bodyOk hc
        && EmitBody.bodyIsValid b
        && b.runtimeNodes == 2
        && b.erasedNodes == 1
        && b.tagCount == 3
        && b.buf == expectedBodyFragment
        && EmitBody.bufHasEmitBodyMarker b.buf
        && EmitBody.bufHasRuntimeFsMarker b.buf

/-- Kernel surface canary: stage ids + path cites + product API names. -/
def emitSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_KERNEL_EMIT_V0")
    && (kernelEmitId == "SELF-HOST-KERNEL-EMIT")
    && (hostKernelEmitId == "HOST-KERNEL-EMIT")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/KernelEmit.lean")
    && (programKernelStageCite == "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0")
    && (productEmitPlanId == "EMIT_PLAN_V0")
    && (productEmitApplyId == "EMIT_APPLY_V0")
    && (productEmitBodyId == "EMIT_BODY_V0")
    && (productHostEmitSsotId == "HOST-EMIT-SSOT")
    && (productHostEmitMultId == "HOST-EMIT-MULT")
    && (productEmitPlanApi == "slake_emit_plan")
    && (productEmitApplyApi == "slake_emit_apply")
    && (productEmitBodyApi == "slake_emit_body")

/-- emitKernelReady -- SH4 freestanding codegen host honesty bar.
    FAIL-CLOSED real Bool composition (not presence-only):
      programKernelReady (ordered IR + graph + compose)
      && emitPlanPathReady && emitApplyPathReady && emitBodyPathReady
      && EmitMult.emitMultReady (HOST-EMIT-MULT Mult product text honesty)
      && emitSurfaceOk
    Greppable: emitKernelReady, SELF-HOST-KERNEL-EMIT, HOST-KERNEL-EMIT. -/
def emitKernelReady : Bool :=
  KernelProgram.programKernelReady
    && emitPlanPathReady
    && emitApplyPathReady
    && emitBodyPathReady
    && EmitMult.emitMultReady
    && emitSurfaceOk

/-- Full SH4 emit / codegen kernel inventory ok. -/
def emitKernelOk : Bool := emitKernelReady

/-! ### Emit kernel smoke (behavioral; lake build fails if an example does not hold)
    Greppable: KERNEL-EMIT-SMOKE.
    maxRecDepth raised for programKernelReady / emitKernelReady unfolds. -/

set_option maxRecDepth 8192

/-- KERNEL-EMIT-SMOKE: stage / map ids are greppable honesty strings. -/
example : stageId = "SLAKE_SELF_HOST_KERNEL_EMIT_V0" := by decide
example : kernelEmitId = "SELF-HOST-KERNEL-EMIT" := by decide
example : hostKernelEmitId = "HOST-KERNEL-EMIT" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/KernelEmit.lean" := by decide
example : programKernelStageCite = "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0" := by decide
example : productEmitPlanId = "EMIT_PLAN_V0" := by decide
example : productEmitApplyId = "EMIT_APPLY_V0" := by decide
example : productEmitBodyId = "EMIT_BODY_V0" := by decide
example : productHostEmitSsotId = "HOST-EMIT-SSOT" := by decide
example : productHostEmitMultId = "HOST-EMIT-MULT" := by decide
example : productEmitPlanApi = "slake_emit_plan" := by decide
example : productEmitApplyApi = "slake_emit_apply" := by decide
example : productEmitBodyApi = "slake_emit_body" := by decide
example : emitSurfaceOk = true := by decide

/-- KERNEL-EMIT-SMOKE: lowerEmitCompose succeeds; program kernel ready. -/
example : (lowerEmitCompose.isSome) = true := by decide
example : KernelProgram.programKernelReady = true := by decide

/-- KERNEL-EMIT-SMOKE: plan path honesty (empty / unminted / emit host). -/
example : emitPlanPathReady = true := by decide
example : EmitPlan.planOk HostCompose.empty = true := by decide
example : EmitPlan.planOk unmintedEmitCompose = false := by decide
example :
    (match lowerEmitCompose with
     | some hc =>
         let p := EmitPlan.planFromCompose hc
         EmitPlan.isReady p && p.nodeCount == 3 && p.edgeCount == 2
           && p.runtimeNodes == 2 && p.erasedNodes == 1
     | none => false) = true := by decide

/-- KERNEL-EMIT-SMOKE: apply path honesty (tags + packing). -/
example : emitApplyPathReady = true := by decide
example : EmitApply.applyOk HostCompose.empty = true := by decide
example : EmitApply.applyOk unmintedEmitCompose = false := by decide
example :
    (match lowerEmitCompose with
     | some hc =>
         let a := EmitApply.applyFromCompose hc
         EmitApply.applyIsValid a && a.count == 3
           && a.tags == [expectedTagErased, expectedTagLinear, expectedTagValue]
     | none => false) = true := by decide

/-- KERNEL-EMIT-SMOKE: body path honesty (HOST-EMIT-SSOT fragment). -/
example : emitBodyPathReady = true := by decide
example : EmitBody.bodyOk HostCompose.empty = true := by decide
example : EmitBody.bodyOk unmintedEmitCompose = false := by decide
example :
    (match lowerEmitCompose with
     | some hc =>
         let b := EmitBody.bodyFromCompose hc
         EmitBody.bodyIsValid b && b.runtimeNodes == 2 && b.erasedNodes == 1
           && b.tagCount == 3 && b.buf == expectedBodyFragment
     | none => false) = true := by decide
example :
    EmitBody.emptyComposeFragmentSsot
      == "/* EMIT_BODY_V0 RUNTIME-FS r=0 e=0 */\n" := by decide

/-- KERNEL-EMIT-SMOKE: Mult product text honesty composes (HOST-EMIT-MULT). -/
example : EmitMult.emitMultReady = true := by decide

/-- KERNEL-EMIT-SMOKE: emit kernel ready and full inventory ok. -/
example : emitKernelReady = true := by decide
example : emitKernelOk = true := by decide

/-- KERNEL-EMIT-SMOKE: capacity honesty cites (frozen wire). -/
example : EmitApply.applyCap = 32 := by decide
example : EmitBody.bodyCap = 256 := by decide

end SystemsLean.KernelEmit
