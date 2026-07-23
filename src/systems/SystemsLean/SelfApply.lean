/-
  SYSTEMS_LEAN_HOST partial -- compiler self-application readiness (SH5 partial).
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): ParityMult.lean Mult closed-loop (SH3); KernelLinear.lean
    Linear kernel IR + HostCompose path (SH4 start); KernelTypes.lean Types
    kernel IR + program path (SH4 growth); KernelProgram.lean program / graph /
    compose path (SH4 remainder); KernelEmit.lean emit plan/apply/body path
    (SH4 freestanding codegen host honesty); KernelMult / EmitMult prior Mult
    ladder; SelfHost.lean direction canary (P5); self-host.md acceptance.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_SELF_APPLY_V0 / HOST-SELF-APPLY / SELF-HOST-SELF-APPLY:
    first honest SH5 rung -- host self-application readiness composed from Mult
    closed loop + Linear kernel + Types kernel + Program kernel + Emit kernel
    evidence (not empty docs; not presence-only).
  - kernelRebuildsKernel (this stage): Mult side = Mult closed-loop readiness
    (ParityMult.multParityReady: Mult kernel IR + EmitMult product text +
    gradeParityOk); Linear side = Linear kernel readiness
    (KernelLinear.linearKernelReady: Linear ordered IR + HostCompose path);
    Types side = Types kernel readiness
    (KernelTypes.typesKernelReady: typed IR + program path fold);
    Program side = Program kernel readiness
    (KernelProgram.programKernelReady: ordered IR + graph edges + HostCompose);
    Emit side = Emit / codegen kernel readiness
    (KernelEmit.emitKernelReady: program kernel + plan/apply/body + Mult emit);
    all readiness paths decide true on the classic elaborator -- structural
    self-application of host kernel modules. NOT "product freestanding C
    recompiles full Slake compiler end-to-end".
  - selfApplyReady: ParityMult.multParityReady && KernelLinear.linearKernelReady
    && KernelTypes.typesKernelReady && KernelProgram.programKernelReady &&
    KernelEmit.emitKernelReady && selfApplySurfaceOk.
  - Host model = structural readiness compose. Not an AI/ML model. Not product C.

  Theorems (SELF-APPLY-THEOREM / HOST-SELF-APPLY-THEOREM -- partial SelfApply):
  - selfApplyReady_true / kernelRebuildsKernel_true / selfApplySurfaceOk_true
  - stageId_eq / hostSelfApplyId_eq / selfApplyOk_true / selfApplyOk_eq_ready
  These SelfApply theorems do NOT set SpecProof.proofCompleteClaimed true.
  Host structural self-apply readiness != freestanding product self-host complete.
  selfApplyOk is a definitional alias of selfApplyReady (joint-name honesty only;
  not a stronger gate; selfApplyOk_eq_ready proves equality).

  Intentional non-claims / partial parity:
  - PARTIAL: host structural kernel-rebuilds-kernel only; not freestanding product
    self-host complete; not residual free; not full Slake body compile.
  - SH4 freestanding codegen host honesty is KernelEmit (partial; product wire
    bulk still frozen at EMIT_BODY_V0 except HOST-EMIT-SSOT + HOST-EMIT-MULT).
  - Not PROVABLY. Does not unlock llvm / out/llvm-ir as done (SH6 held
    documented in LlvmHold.lean -- hold gate, not unlock).
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not grow bash EMIT_* residual treadmill. No new EMIT_* C stage.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_SELF_APPLY_V0, HOST-SELF-APPLY,
  SELF-HOST-SELF-APPLY, SELF-APPLY-SMOKE, HOST-SELF-APPLY-SMOKE, selfApplyReady,
  kernelRebuildsKernel, HOST-PARITY-MULT, SELF-HOST-KERNEL-LINEAR,
  SELF-HOST-KERNEL-TYPES, SELF-HOST-KERNEL-PROGRAM, SELF-HOST-KERNEL-EMIT,
  multParityReady, linearKernelReady, typesKernelReady, programKernelReady,
  emitKernelReady, SELF-APPLY-THEOREM, HOST-SELF-APPLY-THEOREM,
  selfApplyReady_true, kernelRebuildsKernel_true, selfApplySurfaceOk_true,
  selfApplyOk_true, selfApplyOk_eq_ready, stageId_eq, hostSelfApplyId_eq,
  SELF-HOST, MULT-0, MULT-1, MULT-OMEGA, JOIN-ALG, ConsumeToken,
  UNIT_SURFACE host surface. Module: SystemsLean.SelfApply
  Not freestanding emit. Not freestanding residual free. Not PROVABLY.
  Not freestanding emit residual free.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.ParityMult
import SystemsLean.KernelLinear
import SystemsLean.KernelTypes
import SystemsLean.KernelProgram
import SystemsLean.KernelEmit

namespace SystemsLean.SelfApply

/-- Greppable primary stage id for host self-application readiness (SH5 partial). -/
def stageId : String := "SLAKE_SELF_HOST_SELF_APPLY_V0"

/-- Greppable host map id (HOST-SELF-APPLY). -/
def hostSelfApplyId : String := "HOST-SELF-APPLY"

/-- Greppable short map id (SELF-HOST-SELF-APPLY). -/
def selfHostSelfApplyId : String := "SELF-HOST-SELF-APPLY"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/SelfApply.lean"

/-- Prior Mult closed-loop stage cite (SH3; composed into self-apply). -/
def multParityStageCite : String := "SLAKE_SELF_HOST_PARITY_MULT_V0"

/-- Prior Linear kernel stage cite (SH4; composed into self-apply). -/
def linearKernelStageCite : String := "SLAKE_SELF_HOST_KERNEL_LINEAR_V0"

/-- Prior Types kernel stage cite (SH4 growth; composed into self-apply). -/
def typesKernelStageCite : String := "SLAKE_SELF_HOST_KERNEL_TYPES_V0"

/-- Prior Program kernel stage cite (SH4 remainder; composed into self-apply). -/
def programKernelStageCite : String := "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0"

/-- Prior Emit / codegen kernel stage cite (SH4 remainder; composed into self-apply). -/
def emitKernelStageCite : String := "SLAKE_SELF_HOST_KERNEL_EMIT_V0"

/-- Surface canary: stage ids + path cites + prior ladder stage cites. -/
def selfApplySurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_SELF_APPLY_V0")
    && (hostSelfApplyId == "HOST-SELF-APPLY")
    && (selfHostSelfApplyId == "SELF-HOST-SELF-APPLY")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/SelfApply.lean")
    && (multParityStageCite == "SLAKE_SELF_HOST_PARITY_MULT_V0")
    && (linearKernelStageCite == "SLAKE_SELF_HOST_KERNEL_LINEAR_V0")
    && (typesKernelStageCite == "SLAKE_SELF_HOST_KERNEL_TYPES_V0")
    && (programKernelStageCite == "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0")
    && (emitKernelStageCite == "SLAKE_SELF_HOST_KERNEL_EMIT_V0")

/-- multKernelSideReady -- Mult closed-loop side of self-application (SH3 bar).
    Greppable: multKernelSideReady, HOST-PARITY-MULT, multParityReady. -/
def multKernelSideReady : Bool :=
  ParityMult.multParityReady

/-- linearKernelSideReady -- Linear kernel side of self-application (SH4 bar).
    Greppable: linearKernelSideReady, SELF-HOST-KERNEL-LINEAR, linearKernelReady. -/
def linearKernelSideReady : Bool :=
  KernelLinear.linearKernelReady

/-- typesKernelSideReady -- Types kernel side of self-application (SH4 growth).
    Greppable: typesKernelSideReady, SELF-HOST-KERNEL-TYPES, typesKernelReady. -/
def typesKernelSideReady : Bool :=
  KernelTypes.typesKernelReady

/-- programKernelSideReady -- Program kernel side of self-application (SH4 remainder).
    Greppable: programKernelSideReady, SELF-HOST-KERNEL-PROGRAM, programKernelReady. -/
def programKernelSideReady : Bool :=
  KernelProgram.programKernelReady

/-- emitKernelSideReady -- Emit / codegen kernel side of self-application (SH4).
    Greppable: emitKernelSideReady, SELF-HOST-KERNEL-EMIT, emitKernelReady. -/
def emitKernelSideReady : Bool :=
  KernelEmit.emitKernelReady

/-- kernelRebuildsKernel -- SH5 partial meaning of "kernel rebuilds kernel".
    FAIL-CLOSED: Mult closed-loop AND Linear kernel AND Types kernel AND
    Program kernel AND Emit / codegen kernel readiness.
    Honest scope: host elaborator lowers Mult / Linear / Types / Program / Emit
    kernel IR and readiness predicates decide true (structural self-application
    of host kernel modules over themselves). Not freestanding product C
    recompiling full Slake. Not residual free. Not PROVABLY.
    Greppable: kernelRebuildsKernel, SELF-HOST-SELF-APPLY. -/
def kernelRebuildsKernel : Bool :=
  multKernelSideReady && linearKernelSideReady && typesKernelSideReady
    && programKernelSideReady && emitKernelSideReady

/-- selfApplyReady -- SH5 partial compiler self-application host readiness.
    FAIL-CLOSED: Mult closed loop + Linear + Types + Program + Emit kernel + surface.
    Composes SH3 (ParityMult) + SH4 (KernelLinear + KernelTypes + KernelProgram
    + KernelEmit) into one bar.
    Greppable: selfApplyReady, HOST-SELF-APPLY, SELF-HOST-SELF-APPLY. -/
def selfApplyReady : Bool :=
  kernelRebuildsKernel && selfApplySurfaceOk

/-- Full SH5 partial inventory ok -- definitional alias of selfApplyReady
    (joint-name honesty only; not a stronger gate).
    Greppable: selfApplyOk, selfApplyReady. -/
def selfApplyOk : Bool := selfApplyReady

/-! ### SELF-APPLY-THEOREM / HOST-SELF-APPLY-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is host structural
  self-application readiness (Mult closed loop + Linear + Types + Program + Emit
  kernel) only. Does not complete SpecProof; does not claim residual free /
  freestanding product self-host complete / PROVABLY / llvm unlock.
-/

set_option maxRecDepth 16384

/-- Primary stage id is greppable SLAKE_SELF_HOST_SELF_APPLY_V0.
    Greppable: stageId_eq, SELF-APPLY-THEOREM, HOST-SELF-APPLY-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_SELF_APPLY_V0" := rfl

/-- Host map id is greppable HOST-SELF-APPLY.
    Greppable: hostSelfApplyId_eq, SELF-APPLY-THEOREM. -/
theorem hostSelfApplyId_eq : hostSelfApplyId = "HOST-SELF-APPLY" := rfl

/-- Surface canary holds (stage / path / prior ladder cites).
    Greppable: selfApplySurfaceOk_true, SELF-APPLY-THEOREM,
    HOST-SELF-APPLY-THEOREM. -/
theorem selfApplySurfaceOk_true : selfApplySurfaceOk = true := by decide

/-- Mult + Linear + Types + Program + Emit kernel sides ready (host sense).
    Greppable: kernelRebuildsKernel_true, SELF-APPLY-THEOREM,
    HOST-SELF-APPLY-THEOREM. -/
theorem kernelRebuildsKernel_true : kernelRebuildsKernel = true := by decide

/-- SH5 partial self-application readiness holds.
    Greppable: selfApplyReady_true, HOST-SELF-APPLY, SELF-APPLY-THEOREM,
    HOST-SELF-APPLY-THEOREM. -/
theorem selfApplyReady_true : selfApplyReady = true := by decide

/-- Full SH5 partial inventory ok holds (alias of selfApplyReady).
    Greppable: selfApplyOk_true, SELF-APPLY-THEOREM. -/
theorem selfApplyOk_true : selfApplyOk = true := by decide

/-- Joint-name honesty: selfApplyOk is definitional alias of selfApplyReady
    (not a stronger gate). Greppable: selfApplyOk_eq_ready, SELF-APPLY-THEOREM,
    HOST-SELF-APPLY-THEOREM. -/
theorem selfApplyOk_eq_ready : selfApplyOk = selfApplyReady := rfl

/-! ### Self-application smoke (behavioral; lake build fails if an example fails)
    Greppable: SELF-APPLY-SMOKE, HOST-SELF-APPLY-SMOKE.
    maxRecDepth raised for multParityReady / emitKernelReady / selfApplyReady
    String.beq unfolds. -/

/-- SELF-APPLY-SMOKE / HOST-SELF-APPLY-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_SELF_APPLY_V0" := by decide
example : hostSelfApplyId = "HOST-SELF-APPLY" := by decide
example : selfHostSelfApplyId = "SELF-HOST-SELF-APPLY" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/SelfApply.lean" := by decide
example : multParityStageCite = "SLAKE_SELF_HOST_PARITY_MULT_V0" := by decide
example : linearKernelStageCite = "SLAKE_SELF_HOST_KERNEL_LINEAR_V0" := by decide
example : typesKernelStageCite = "SLAKE_SELF_HOST_KERNEL_TYPES_V0" := by decide
example : programKernelStageCite = "SLAKE_SELF_HOST_KERNEL_PROGRAM_V0" := by decide
example : emitKernelStageCite = "SLAKE_SELF_HOST_KERNEL_EMIT_V0" := by decide
example : selfApplySurfaceOk = true := by decide

/-- SELF-APPLY-SMOKE: Mult closed-loop side ready (SH3 compose). -/
example : multKernelSideReady = true := by decide
example : ParityMult.multParityReady = true := by decide

/-- SELF-APPLY-SMOKE: Linear kernel side ready (SH4 compose). -/
example : linearKernelSideReady = true := by decide
example : KernelLinear.linearKernelReady = true := by decide

/-- SELF-APPLY-SMOKE: Types kernel side ready (SH4 growth compose). -/
example : typesKernelSideReady = true := by decide
example : KernelTypes.typesKernelReady = true := by decide

/-- SELF-APPLY-SMOKE: Program kernel side ready (SH4 remainder compose). -/
example : programKernelSideReady = true := by decide
example : KernelProgram.programKernelReady = true := by decide

/-- SELF-APPLY-SMOKE: Emit / codegen kernel side ready (SH4 remainder compose). -/
example : emitKernelSideReady = true := by decide
example : KernelEmit.emitKernelReady = true := by decide

/-- SELF-APPLY-SMOKE / HOST-SELF-APPLY-SMOKE: kernel rebuilds kernel (host sense). -/
example : kernelRebuildsKernel = true := by decide
example : selfApplyReady = true := by decide
example : selfApplyOk = true := by decide

end SystemsLean.SelfApply
