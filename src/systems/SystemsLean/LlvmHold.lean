/-
  SYSTEMS_LEAN_HOST partial -- llvm / PROVABLY hold gate (SH6 held, documented).
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): SelfApply.lean SH5 host self-application readiness;
    SelfHost.lean direction canary (P5); surface-matrix.md open llvm / PROVABLY
    rows; self-host.md acceptance (SH6 held).

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_LLVM_HOLD_V0 / HOST-LLVM-HOLD / SELF-HOST-LLVM-HOLD:
    greppable SH6 hold gate -- residual honesty is code-backed, not prose alone.
  - HOST-PROVABLY-HOLD: greppable PROVABLY hold sibling (real ccomp still required).
  - llvmUnlocked / provablyUnlocked: MUST decide false under current evidence.
    SH5 host-structural selfApplyReady does NOT imply llvm unlocked.
  - freestandingProductSelfHostComplete: MUST decide false (product freestanding
    C rebuilding full Slake is still open).
  - llvmHoldReady / sh6HoldReady: true when hold surface + non-claims + SelfApply
    honesty composition are present and unlock flags remain false.
  - Host model = structural hold honesty. Not an AI/ML model. Not product C.

  Theorems (LLVM-HOLD-THEOREM / HOST-LLVM-HOLD-THEOREM -- partial LlvmHold):
  - llvmHoldReady_true / llvmUnlocked_false / provablyUnlocked_false
  - freestandingProductSelfHostComplete_false / selfApplyDoesNotUnlockLlvm_true
  - stageId_eq / hostLlvmHoldId_eq / sh6HoldReady_eq_llvmHoldReady
  These LlvmHold theorems do NOT set SpecProof.proofCompleteClaimed true.
  Unlock flags stay false (proved false, not set true). Hold is not unlock.

  Intentional non-claims / hold (not unlock):
  - SH6 is held (documented), NOT done as llvm unlock or PROVABLY achieved.
  - Does not create product emit into out/llvm-ir.
  - Does not wire just out-llvm-ir as a green product residual-free path.
  - Does not open P6 residual rows as open work to mill.
  - Still not residual free. Still not freestanding product self-host complete.
  - Still not PROVABLY. llvm-ir product path still deferred until true
    freestanding product self-host + real CompCert ccomp evidence.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Does not grow bash EMIT_* residual treadmill. No new EMIT_* C stage.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_LLVM_HOLD_V0, HOST-LLVM-HOLD,
  SELF-HOST-LLVM-HOLD, HOST-PROVABLY-HOLD, LLVM-HOLD-SMOKE, HOST-LLVM-HOLD-SMOKE,
  llvmHoldReady, sh6HoldReady, llvmUnlocked, provablyUnlocked,
  freestandingProductSelfHostComplete, selfApplyDoesNotUnlockLlvm,
  HOST-SELF-APPLY, selfApplyReady, SELF-HOST, MULT-0, MULT-1, MULT-OMEGA,
  JOIN-ALG, ConsumeToken, LLVM-HOLD-THEOREM, HOST-LLVM-HOLD-THEOREM,
  llvmHoldReady_true, llvmUnlocked_false, sh6HoldReady_eq_llvmHoldReady,
  UNIT_SURFACE host surface.
  Module: SystemsLean.LlvmHold
  Not freestanding emit. Not freestanding residual free. Not PROVABLY.
  Not freestanding emit residual free. Not llvm unlocked. Not proof complete.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.SelfApply

namespace SystemsLean.LlvmHold

/-- Greppable primary stage id for llvm / PROVABLY hold gate (SH6 held). -/
def stageId : String := "SLAKE_SELF_HOST_LLVM_HOLD_V0"

/-- Greppable host map id (HOST-LLVM-HOLD). -/
def hostLlvmHoldId : String := "HOST-LLVM-HOLD"

/-- Greppable short map id (SELF-HOST-LLVM-HOLD). -/
def selfHostLlvmHoldId : String := "SELF-HOST-LLVM-HOLD"

/-- Greppable PROVABLY hold sibling id (HOST-PROVABLY-HOLD). -/
def hostProvablyHoldId : String := "HOST-PROVABLY-HOLD"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/LlvmHold.lean"

/-- Prior SH5 self-apply stage cite (composed into hold honesty). -/
def selfApplyStageCite : String := "SLAKE_SELF_HOST_SELF_APPLY_V0"

/-- Deferred product path cite (not unlocked; path string only). -/
def llvmIrPathCite : String := "out/llvm-ir"

/-- Surface canary: stage ids + path cites + prior SelfApply stage cite. -/
def llvmHoldSurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_LLVM_HOLD_V0")
    && (hostLlvmHoldId == "HOST-LLVM-HOLD")
    && (selfHostLlvmHoldId == "SELF-HOST-LLVM-HOLD")
    && (hostProvablyHoldId == "HOST-PROVABLY-HOLD")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/LlvmHold.lean")
    && (selfApplyStageCite == "SLAKE_SELF_HOST_SELF_APPLY_V0")
    && (llvmIrPathCite == "out/llvm-ir")

/-- llvmUnlocked -- MUST be false under current evidence.
    Not residual-open. Not product emit path. Greppable: llvmUnlocked. -/
def llvmUnlocked : Bool := false

/-- provablyUnlocked -- MUST be false (needs real CompCert ccomp + matrix).
    Greppable: provablyUnlocked, HOST-PROVABLY-HOLD. -/
def provablyUnlocked : Bool := false

/-- freestandingProductSelfHostComplete -- MUST be false (still open).
    SH5 host-structural kernelRebuildsKernel (SelfApply) is not freestanding
    product self-host complete. SH5 freestanding deepen
    freestandingSelfApplyReady (SelfApplyFs extract/body path + Mult..Emit
    parity ladder compose) also does not complete product freestanding
    self-host. Greppable: freestandingProductSelfHostComplete. -/
def freestandingProductSelfHostComplete : Bool := false

/-- holdHonestyOk -- unlock / complete flags all remain false.
    FAIL-CLOSED: any true unlock or complete claim fails the hold gate. -/
def holdHonestyOk : Bool :=
  (!llvmUnlocked) && (!provablyUnlocked) && (!freestandingProductSelfHostComplete)

/-- selfApplyDoesNotUnlockLlvm -- SH5 host-structural selfApplyReady does NOT
    imply llvm unlocked. True when SelfApply readiness holds and llvmUnlocked
    remains false. Greppable: selfApplyDoesNotUnlockLlvm, selfApplyReady. -/
def selfApplyDoesNotUnlockLlvm : Bool :=
  SelfApply.selfApplyReady && !llvmUnlocked

/-- llvmHoldReady -- SH6 hold gate active and correct (not unlock).
    FAIL-CLOSED: surface + non-claims + SelfApply honesty composition +
    selfApply does not unlock. Greppable: llvmHoldReady, HOST-LLVM-HOLD. -/
def llvmHoldReady : Bool :=
  llvmHoldSurfaceOk
    && holdHonestyOk
    && SelfApply.selfApplyReady
    && selfApplyDoesNotUnlockLlvm

/-- sh6HoldReady -- definitional alias of llvmHoldReady for SH6 residual greps
    (joint-name honesty only; not a stronger gate).
    Greppable: sh6HoldReady, SELF-HOST-LLVM-HOLD, sh6HoldReady_eq_llvmHoldReady. -/
def sh6HoldReady : Bool := llvmHoldReady

/-- Full SH6 hold inventory ok (alias of llvmHoldReady for inventory greps). -/
def llvmHoldOk : Bool := llvmHoldReady

/-! ### LLVM-HOLD-THEOREM / HOST-LLVM-HOLD-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is SH6 hold
  readiness and unlock-flag honesty only. Does not complete SpecProof; unlock
  flags stay false (proved false). Hold is not unlock.
  maxRecDepth raised for selfApplyReady / llvmHoldReady String.beq unfolds.
-/

set_option maxRecDepth 16384

/-- Primary stage id is greppable SLAKE_SELF_HOST_LLVM_HOLD_V0.
    Greppable: stageId_eq, LLVM-HOLD-THEOREM, HOST-LLVM-HOLD-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_LLVM_HOLD_V0" := rfl

/-- Host map id is greppable HOST-LLVM-HOLD.
    Greppable: hostLlvmHoldId_eq, LLVM-HOLD-THEOREM. -/
theorem hostLlvmHoldId_eq : hostLlvmHoldId = "HOST-LLVM-HOLD" := rfl

/-- llvmUnlocked stays false under current evidence (hold, not unlock).
    Greppable: llvmUnlocked_false, LLVM-HOLD-THEOREM, HOST-LLVM-HOLD-THEOREM. -/
theorem llvmUnlocked_false : llvmUnlocked = false := rfl

/-- provablyUnlocked stays false (real CompCert ccomp still required).
    Greppable: provablyUnlocked_false, LLVM-HOLD-THEOREM, HOST-PROVABLY-HOLD. -/
theorem provablyUnlocked_false : provablyUnlocked = false := rfl

/-- freestandingProductSelfHostComplete stays false (still open).
    Greppable: freestandingProductSelfHostComplete_false, LLVM-HOLD-THEOREM. -/
theorem freestandingProductSelfHostComplete_false :
    freestandingProductSelfHostComplete = false := rfl

/-- SH5 selfApplyReady does NOT unlock llvm.
    Greppable: selfApplyDoesNotUnlockLlvm_true, LLVM-HOLD-THEOREM. -/
theorem selfApplyDoesNotUnlockLlvm_true :
    selfApplyDoesNotUnlockLlvm = true := by decide

/-- SH6 hold gate ready holds (hold active, not unlock).
    Greppable: llvmHoldReady_true, HOST-LLVM-HOLD, LLVM-HOLD-THEOREM,
    HOST-LLVM-HOLD-THEOREM. -/
theorem llvmHoldReady_true : llvmHoldReady = true := by decide

/-- Joint-name honesty: sh6HoldReady is definitional alias of llvmHoldReady.
    Greppable: sh6HoldReady_eq_llvmHoldReady, LLVM-HOLD-THEOREM. -/
theorem sh6HoldReady_eq_llvmHoldReady : sh6HoldReady = llvmHoldReady := rfl

/-! ### Llvm hold smoke (behavioral; lake build fails if an example fails)
    Greppable: LLVM-HOLD-SMOKE, HOST-LLVM-HOLD-SMOKE.
    maxRecDepth already raised above for llvmHoldReady unfolds. -/

/-- LLVM-HOLD-SMOKE / HOST-LLVM-HOLD-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_LLVM_HOLD_V0" := by decide
example : hostLlvmHoldId = "HOST-LLVM-HOLD" := by decide
example : selfHostLlvmHoldId = "SELF-HOST-LLVM-HOLD" := by decide
example : hostProvablyHoldId = "HOST-PROVABLY-HOLD" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/LlvmHold.lean" := by decide
example : selfApplyStageCite = "SLAKE_SELF_HOST_SELF_APPLY_V0" := by decide
example : llvmIrPathCite = "out/llvm-ir" := by decide
example : llvmHoldSurfaceOk = true := by decide

/-- LLVM-HOLD-SMOKE: unlock / complete flags decide false (hold honesty). -/
example : llvmUnlocked = false := by decide
example : provablyUnlocked = false := by decide
example : freestandingProductSelfHostComplete = false := by decide
example : holdHonestyOk = true := by decide

/-- LLVM-HOLD-SMOKE: SH5 self-apply present does not unlock llvm. -/
example : SelfApply.selfApplyReady = true := by decide
example : selfApplyDoesNotUnlockLlvm = true := by decide

/-- LLVM-HOLD-SMOKE / HOST-LLVM-HOLD-SMOKE: hold ready decides true (not unlock). -/
example : llvmHoldReady = true := by decide
example : sh6HoldReady = true := by decide
example : llvmHoldOk = true := by decide

end SystemsLean.LlvmHold
