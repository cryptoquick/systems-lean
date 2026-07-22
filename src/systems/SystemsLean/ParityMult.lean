/-
  SYSTEMS_LEAN_HOST partial -- Mult closed-loop parity (SH3).
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): Mult.lean grades; KernelMult.lean Mult kernel IR;
    EmitMult.lean host Mult product text; product wire slake_mult_* (frozen ABI);
    smoke/slake_behavioral_probe.c product Mult behavioral parity;
    self-host.md acceptance.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_PARITY_MULT_V0 / HOST-PARITY-MULT / SELF-HOST-PARITY-MULT:
    first closed loop -- host Mult IR + Mult product text contracts agree with
    Mult grade contracts (names, isValid, ofNat?/isValidTag, enum tags 0/1/2).
  - Host model = structural representation of Mult contracts. Not an AI model.
  - multParityReady: KernelMult.multKernelReady && EmitMult.emitMultReady &&
    gradeParityOk (closed Mult surface + name/tag tables).
  - Product-wire Mult API behavioral parity is exercised by hosted smoke
    (slake_mult_is_valid / is_known / name for 0/1/omega + fail-closed unknown)
    -- same Mult.name / ofNat? contracts the host proves here.
  - No new EMIT_MULT_V0 residual C stage ladder (host stage ids only).

  Intentional non-claims / partial parity:
  - PARTIAL: Mult closed loop for grades only; not full product module emit;
    Linear kernel growth is KernelLinear (SH4 start); SH5 host compose is
    SelfApply (not freestanding product self-host complete).
  - PARTIAL: host String/Bool model vs C int/const char* return tables
    (compatible contracts, not bit-identical runtime).
  - Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not unlock llvm. Does not grow bash EMIT_* residual treadmill.
  - Not freestanding product self-host complete.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_PARITY_MULT_V0, HOST-PARITY-MULT,
  SELF-HOST-PARITY-MULT, PARITY-MULT-SMOKE, HOST-PARITY-MULT-SMOKE, MULT-0,
  MULT-1, MULT-OMEGA, FAIL-CLOSED-UNKNOWN-GRADE, multParityReady, gradeParityOk,
  slake_mult_is_valid, slake_mult_is_known, slake_mult_name, SELF-HOST-KERNEL-MULT,
  HOST-EMIT-MULT
  UNIT_SURFACE host surface. Module: SystemsLean.ParityMult
  Not freestanding emit. Not freestanding residual free. Not PROVABLY.
  Not freestanding emit residual free.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.Mult
import SystemsLean.KernelMult
import SystemsLean.EmitMult

namespace SystemsLean.ParityMult

open SystemsLean.Mult (Mult)

/-- Greppable primary stage id for Mult closed-loop parity (SH3). -/
def stageId : String := "SLAKE_SELF_HOST_PARITY_MULT_V0"

/-- Greppable short map id (HOST-PARITY-MULT). -/
def hostParityMultId : String := "HOST-PARITY-MULT"

/-- Greppable short map id (SELF-HOST-PARITY-MULT). -/
def selfHostParityMultId : String := "SELF-HOST-PARITY-MULT"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/ParityMult.lean"

/-- Read-only product Mult behavioral probe path cite (not a filesystem read). -/
def productProbePath : String := "src/systems/smoke/slake_behavioral_probe.c"

/-- Product wire Mult API names (frozen ABI; compatible contracts). -/
def productIsValidApi : String := "slake_mult_is_valid"
def productIsKnownApi : String := "slake_mult_is_known"
def productNameApi : String := "slake_mult_name"

/-- Grade tags aligned with freestanding enum slake_mult (0 / 1 / 2). -/
def tag0 : Nat := 0
def tag1 : Nat := 1
def tagOmega : Nat := 2

/-- ofNat? round-trip for the three product grades (host Mult contracts). -/
def ofNatRoundTripOk : Bool :=
  (Mult.ofNat? tag0 == some Mult.mult0)
    && (Mult.ofNat? tag1 == some Mult.mult1)
    && (Mult.ofNat? tagOmega == some Mult.multOmega)
    && (Mult.ofNat? 3 == none)
    && (Mult.ofNat? 99 == none)

/-- isValidTag matches product is_valid / is_known on known vs unknown tags. -/
def isValidTagParityOk : Bool :=
  Mult.isValidTag tag0
    && Mult.isValidTag tag1
    && Mult.isValidTag tagOmega
    && !Mult.isValidTag 3
    && !Mult.isValidTag 99

/-- Typed Mult isValid is total-true (closed inductive; pairs product valid grades). -/
def isValidParityOk : Bool :=
  Mult.isValid Mult.mult0
    && Mult.isValid Mult.mult1
    && Mult.isValid Mult.multOmega
    && Mult.multIsValid Mult.mult0
    && Mult.multIsValid Mult.mult1
    && Mult.multIsValid Mult.multOmega

/-- Mult.name strings match greppable product wire names (slake_mult_name).
    EmitMult.multName* is def Mult.name (SH2); emit readiness already composes
    gradeNamesOk into multParityReady -- do not re-check definitional aliases. -/
def nameParityOk : Bool :=
  (Mult.name Mult.mult0 == "MULT-0")
    && (Mult.name Mult.mult1 == "MULT-1")
    && (Mult.name Mult.multOmega == "MULT-OMEGA")

/-- Emit Mult product enum constant names (SLAKE_MULT_*); numeric tags are
    ofNatRoundTripOk + product probe, not local def self-equality. -/
def enumTagParityOk : Bool :=
  (EmitMult.multC0 == "SLAKE_MULT_0")
    && (EmitMult.multC1 == "SLAKE_MULT_1")
    && (EmitMult.multCOmega == "SLAKE_MULT_OMEGA")

/-- gradeParityOk -- host Mult contracts closed for the three grades.
    Structural host model of Mult product contracts (names, tags, isValid).
    Not freestanding residual free. Not PROVABLY. -/
def gradeParityOk : Bool :=
  ofNatRoundTripOk
    && isValidTagParityOk
    && isValidParityOk
    && nameParityOk
    && enumTagParityOk

/-- Surface canary: stage ids + path cites + product API names. -/
def paritySurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_PARITY_MULT_V0")
    && (hostParityMultId == "HOST-PARITY-MULT")
    && (selfHostParityMultId == "SELF-HOST-PARITY-MULT")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/ParityMult.lean")
    && (productProbePath == "src/systems/smoke/slake_behavioral_probe.c")
    && (productIsValidApi == "slake_mult_is_valid")
    && (productIsKnownApi == "slake_mult_is_known")
    && (productNameApi == "slake_mult_name")

/-- multParityReady -- SH3 Mult closed-loop host readiness.
    FAIL-CLOSED: Mult kernel IR ready + Mult host emit ready + grade parity
    + surface canary. Composes SH1 + SH2 + Mult contracts.
    Greppable: multParityReady, HOST-PARITY-MULT, SELF-HOST-PARITY-MULT. -/
def multParityReady : Bool :=
  KernelMult.multKernelReady
    && EmitMult.emitMultReady
    && gradeParityOk
    && paritySurfaceOk

/-- Full SH3 inventory ok (alias of multParityReady for inventory greps). -/
def multParityOk : Bool := multParityReady

/-! ### Mult closed-loop parity smoke (behavioral; lake build fails if example fails)
    Greppable: PARITY-MULT-SMOKE, HOST-PARITY-MULT-SMOKE.
    maxRecDepth raised for emitMultReady / multParityReady String.beq unfolds. -/

set_option maxRecDepth 4096

/-- PARITY-MULT-SMOKE / HOST-PARITY-MULT-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_PARITY_MULT_V0" := by decide
example : hostParityMultId = "HOST-PARITY-MULT" := by decide
example : selfHostParityMultId = "SELF-HOST-PARITY-MULT" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/ParityMult.lean" := by decide
example : productProbePath = "src/systems/smoke/slake_behavioral_probe.c" := by decide
example : paritySurfaceOk = true := by decide

/-- PARITY-MULT-SMOKE: Mult.ofNat? / isValidTag match product tags 0/1/2. -/
example : ofNatRoundTripOk = true := by decide
example : isValidTagParityOk = true := by decide
example : Mult.ofNat? 0 = some Mult.mult0 := by decide
example : Mult.ofNat? 1 = some Mult.mult1 := by decide
example : Mult.ofNat? 2 = some Mult.multOmega := by decide
example : Mult.ofNat? 3 = none := by decide
example : Mult.isValidTag 99 = false := by decide

/-- PARITY-MULT-SMOKE: isValid + Mult.name match product Mult contracts. -/
example : isValidParityOk = true := by decide
example : nameParityOk = true := by decide
example : Mult.name Mult.mult0 = "MULT-0" := by decide
example : Mult.name Mult.mult1 = "MULT-1" := by decide
example : Mult.name Mult.multOmega = "MULT-OMEGA" := by decide

/-- HOST-PARITY-MULT-SMOKE: emit Mult enum constant names (product wire ABI). -/
example : enumTagParityOk = true := by decide
example : EmitMult.multC0 = "SLAKE_MULT_0" := by decide
example : EmitMult.multC1 = "SLAKE_MULT_1" := by decide
example : EmitMult.multCOmega = "SLAKE_MULT_OMEGA" := by decide
example : gradeParityOk = true := by decide

/-- PARITY-MULT-SMOKE: SH1 kernel + SH2 emit compose into SH3 readiness. -/
example : KernelMult.multKernelReady = true := by decide
example : EmitMult.emitMultReady = true := by decide
example : multParityReady = true := by decide
example : multParityOk = true := by decide

/-- PARITY-MULT-SMOKE: product API name strings are frozen wire honesty. -/
example : productIsValidApi = "slake_mult_is_valid" := by decide
example : productIsKnownApi = "slake_mult_is_known" := by decide
example : productNameApi = "slake_mult_name" := by decide

end SystemsLean.ParityMult
