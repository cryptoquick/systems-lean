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

  Theorems (PARITY-MULT-THEOREM / HOST-PARITY-MULT-THEOREM -- partial ParityMult):
  - multParityReady_true / multParityOk_true / multParityOk_eq_ready
  - gradeParityOk_true / ofNatRoundTripOk_true / isValidTagParityOk_true
  - nameParityOk_true / stageId_eq / hostParityMultId_eq / selfHostParityMultId_eq
  - Content equality (not pure readiness canaries): ofNatRoundTrip_tag0/tag1/
    tagOmega / ofNatRoundTrip_unknown3/unknown99; isValidTag_tag0/tag1/tagOmega /
    isValidTag_unknown3/unknown99; nameParity_mult0/mult1/multOmega;
    enumTag_multC0/C1/COmega; productIsValidApi_eq / productIsKnownApi_eq /
    productNameApi_eq; isValidParityOk_true / enumTagParityOk_true
  These ParityMult theorems do NOT set SpecProof.proofCompleteClaimed true.
  Mult grades closed-loop theorems != freestanding product self-host complete.

  Intentional non-claims / partial parity:
  - PARTIAL: Mult closed loop for grades only; not full product module emit;
    Linear kernel growth is KernelLinear (SH4 start); SH5 host compose is
    SelfApply (not freestanding product self-host complete).
  - PARTIAL: host String/Bool model vs C int/const char* return tables
    (compatible contracts, not bit-identical runtime).
  - Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not unlock llvm. Does not grow bash EMIT_* residual treadmill.
  - Not freestanding product self-host complete.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_PARITY_MULT_V0, HOST-PARITY-MULT,
  SELF-HOST-PARITY-MULT, PARITY-MULT-SMOKE, HOST-PARITY-MULT-SMOKE, MULT-0,
  MULT-1, MULT-OMEGA, FAIL-CLOSED-UNKNOWN-GRADE, multParityReady, gradeParityOk,
  slake_mult_is_valid, slake_mult_is_known, slake_mult_name, SELF-HOST-KERNEL-MULT,
  HOST-EMIT-MULT, PARITY-MULT-THEOREM, HOST-PARITY-MULT-THEOREM,
  multParityReady_true, multParityOk_true, multParityOk_eq_ready,
  gradeParityOk_true, ofNatRoundTripOk_true, isValidTagParityOk_true,
  nameParityOk_true, stageId_eq, hostParityMultId_eq, selfHostParityMultId_eq,
  ofNatRoundTrip_tag0, ofNatRoundTrip_tag1, ofNatRoundTrip_tagOmega,
  ofNatRoundTrip_unknown3, ofNatRoundTrip_unknown99, isValidTag_tag0,
  isValidTag_tag1, isValidTag_tagOmega, isValidTag_unknown3, isValidTag_unknown99,
  nameParity_mult0, nameParity_mult1, nameParity_multOmega, enumTag_multC0,
  enumTag_multC1, enumTag_multCOmega, productIsValidApi_eq, productIsKnownApi_eq,
  productNameApi_eq, isValidParityOk_true, enumTagParityOk_true
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

/-- Full SH3 inventory ok (alias of multParityReady for inventory greps).
    Definitional alias honesty: multParityOk == multParityReady (not a stronger
    gate). Theorems prove both names for greppable inventory. -/
def multParityOk : Bool := multParityReady

/-! ### PARITY-MULT-THEOREM / HOST-PARITY-MULT-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is Mult grades
  closed-loop readiness, grade parity tables, and stage-id surface canaries only.
  Does not complete SpecProof; does not claim residual free / freestanding
  product self-host complete / PROVABLY / llvm unlock.
  maxRecDepth raised for emitMultReady / multParityReady String.beq unfolds.
-/

set_option maxRecDepth 4096

/-- Primary stage id is greppable SLAKE_SELF_HOST_PARITY_MULT_V0.
    Greppable: stageId_eq, PARITY-MULT-THEOREM, HOST-PARITY-MULT-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_PARITY_MULT_V0" := rfl

/-- Host map id is greppable HOST-PARITY-MULT.
    Greppable: hostParityMultId_eq, PARITY-MULT-THEOREM. -/
theorem hostParityMultId_eq : hostParityMultId = "HOST-PARITY-MULT" := rfl

/-- Short map id is greppable SELF-HOST-PARITY-MULT.
    Greppable: selfHostParityMultId_eq, PARITY-MULT-THEOREM. -/
theorem selfHostParityMultId_eq :
    selfHostParityMultId = "SELF-HOST-PARITY-MULT" := rfl

/-- Mult closed-loop host readiness holds (kernel + emit + grade parity).
    Greppable: multParityReady_true, HOST-PARITY-MULT, SELF-HOST-PARITY-MULT,
    PARITY-MULT-THEOREM, HOST-PARITY-MULT-THEOREM. -/
theorem multParityReady_true : multParityReady = true := by decide

/-- multParityOk holds (same bar as multParityReady; joint inventory name).
    Greppable: multParityOk_true, PARITY-MULT-THEOREM. -/
theorem multParityOk_true : multParityOk = true := by decide

/-- Joint-name honesty: multParityOk is definitional alias of multParityReady
    (not a stronger gate). Greppable: multParityOk_eq_ready, PARITY-MULT-THEOREM,
    HOST-PARITY-MULT-THEOREM. -/
theorem multParityOk_eq_ready : multParityOk = multParityReady := rfl

/-- Grade parity tables hold (ofNat / isValidTag / isValid / name / enum).
    Greppable: gradeParityOk_true, PARITY-MULT-THEOREM, HOST-PARITY-MULT-THEOREM. -/
theorem gradeParityOk_true : gradeParityOk = true := by decide

/-- ofNat? round-trip for product grades 0/1/2 + unknown fail-closed.
    Greppable: ofNatRoundTripOk_true, FAIL-CLOSED-UNKNOWN-GRADE,
    PARITY-MULT-THEOREM. -/
theorem ofNatRoundTripOk_true : ofNatRoundTripOk = true := by decide

/-- isValidTag parity for known vs unknown tags.
    Greppable: isValidTagParityOk_true, PARITY-MULT-THEOREM. -/
theorem isValidTagParityOk_true : isValidTagParityOk = true := by decide

/-- Mult.name strings match greppable product wire names.
    Greppable: nameParityOk_true, PARITY-MULT-THEOREM. -/
theorem nameParityOk_true : nameParityOk = true := by decide

/-! ### PARITY-MULT content equality (parity table + product surface; not readiness canaries)

  Strength tiers (do not flatten):
  - Strong function content: ofNatRoundTrip_tag* / isValidTag_tag* /
    nameParity_mult* pin Mult.ofNat? / Mult.isValidTag / Mult.name (real
    cross-def equations on Mult).
  - Cross-module emit enum: enumTag_multC* pin EmitMult.multC* strings.
  - Frozen-ABI surface canaries only: productIsValidApi_eq /
    productIsKnownApi_eq / productNameApi_eq are local def-literal
    self-equality (def productX := "slake_..." then productX = "slake_...").
    They do NOT cross-check C/probe SSOT; weaker than ofNat/isValidTag/name.
  Mult already proves ofNat?_zero/one/two + name_mult*; Parity pins the parity
  module table (tag0/tag1/tagOmega defs + EmitMult enum + product API strings).
  Does NOT re-list multParityReady_true as new depth. Does NOT forge residual free.
  Do not treat product*Api_eq volume as remaining algebraic residual.
-/

/-- ofNat? round-trip content: parity tag0 decodes to MULT-0.
    Greppable: ofNatRoundTrip_tag0, PARITY-MULT-THEOREM, HOST-PARITY-MULT-THEOREM. -/
theorem ofNatRoundTrip_tag0 : Mult.ofNat? tag0 = some Mult.mult0 := rfl

/-- ofNat? round-trip content: parity tag1 decodes to MULT-1.
    Greppable: ofNatRoundTrip_tag1, PARITY-MULT-THEOREM. -/
theorem ofNatRoundTrip_tag1 : Mult.ofNat? tag1 = some Mult.mult1 := rfl

/-- ofNat? round-trip content: parity tagOmega decodes to MULT-OMEGA.
    Greppable: ofNatRoundTrip_tagOmega, PARITY-MULT-THEOREM. -/
theorem ofNatRoundTrip_tagOmega : Mult.ofNat? tagOmega = some Mult.multOmega := rfl

/-- ofNat? unknown raw tag 3 rejects (FAIL-CLOSED-UNKNOWN-GRADE content).
    Greppable: ofNatRoundTrip_unknown3, FAIL-CLOSED-UNKNOWN-GRADE, PARITY-MULT-THEOREM. -/
theorem ofNatRoundTrip_unknown3 : Mult.ofNat? 3 = none := rfl

/-- ofNat? unknown raw tag 99 rejects (FAIL-CLOSED-UNKNOWN-GRADE content).
    Greppable: ofNatRoundTrip_unknown99, FAIL-CLOSED-UNKNOWN-GRADE, PARITY-MULT-THEOREM. -/
theorem ofNatRoundTrip_unknown99 : Mult.ofNat? 99 = none := rfl

/-- isValidTag content: parity tag0 is valid.
    Greppable: isValidTag_tag0, PARITY-MULT-THEOREM. -/
theorem isValidTag_tag0 : Mult.isValidTag tag0 = true := rfl

/-- isValidTag content: parity tag1 is valid.
    Greppable: isValidTag_tag1, PARITY-MULT-THEOREM. -/
theorem isValidTag_tag1 : Mult.isValidTag tag1 = true := rfl

/-- isValidTag content: parity tagOmega is valid.
    Greppable: isValidTag_tagOmega, PARITY-MULT-THEOREM. -/
theorem isValidTag_tagOmega : Mult.isValidTag tagOmega = true := rfl

/-- isValidTag content: raw tag 3 is invalid (fail-closed).
    Greppable: isValidTag_unknown3, FAIL-CLOSED-UNKNOWN-GRADE, PARITY-MULT-THEOREM. -/
theorem isValidTag_unknown3 : Mult.isValidTag 3 = false := rfl

/-- isValidTag content: raw tag 99 is invalid (fail-closed).
    Greppable: isValidTag_unknown99, FAIL-CLOSED-UNKNOWN-GRADE, PARITY-MULT-THEOREM. -/
theorem isValidTag_unknown99 : Mult.isValidTag 99 = false := rfl

/-- name parity content: MULT-0 greppable product wire name.
    Greppable: nameParity_mult0, PARITY-MULT-THEOREM. -/
theorem nameParity_mult0 : Mult.name Mult.mult0 = "MULT-0" := rfl

/-- name parity content: MULT-1 greppable product wire name.
    Greppable: nameParity_mult1, PARITY-MULT-THEOREM. -/
theorem nameParity_mult1 : Mult.name Mult.mult1 = "MULT-1" := rfl

/-- name parity content: MULT-OMEGA greppable product wire name.
    Greppable: nameParity_multOmega, PARITY-MULT-THEOREM. -/
theorem nameParity_multOmega : Mult.name Mult.multOmega = "MULT-OMEGA" := rfl

/-- Emit Mult enum constant content: SLAKE_MULT_0.
    Greppable: enumTag_multC0, PARITY-MULT-THEOREM, HOST-PARITY-MULT-THEOREM. -/
theorem enumTag_multC0 : EmitMult.multC0 = "SLAKE_MULT_0" := rfl

/-- Emit Mult enum constant content: SLAKE_MULT_1.
    Greppable: enumTag_multC1, PARITY-MULT-THEOREM. -/
theorem enumTag_multC1 : EmitMult.multC1 = "SLAKE_MULT_1" := rfl

/-- Emit Mult enum constant content: SLAKE_MULT_OMEGA.
    Greppable: enumTag_multCOmega, PARITY-MULT-THEOREM. -/
theorem enumTag_multCOmega : EmitMult.multCOmega = "SLAKE_MULT_OMEGA" := rfl

/-- Product Mult is_valid API surface pin (frozen-ABI canary; local def-literal).
    Greppable: productIsValidApi_eq, PARITY-MULT-THEOREM. -/
theorem productIsValidApi_eq : productIsValidApi = "slake_mult_is_valid" := rfl

/-- Product Mult is_known API surface pin (frozen-ABI canary; local def-literal).
    Greppable: productIsKnownApi_eq, PARITY-MULT-THEOREM. -/
theorem productIsKnownApi_eq : productIsKnownApi = "slake_mult_is_known" := rfl

/-- Product Mult name API surface pin (frozen-ABI canary; local def-literal).
    Greppable: productNameApi_eq, PARITY-MULT-THEOREM. -/
theorem productNameApi_eq : productNameApi = "slake_mult_name" := rfl

/-- isValid component table holds (typed Mult total-true; intermediate of gradeParityOk).
    Greppable: isValidParityOk_true, PARITY-MULT-THEOREM. -/
theorem isValidParityOk_true : isValidParityOk = true := by decide

/-- enumTag component table holds (EmitMult SLAKE_MULT_* strings).
    Greppable: enumTagParityOk_true, PARITY-MULT-THEOREM. -/
theorem enumTagParityOk_true : enumTagParityOk = true := by decide

/-! ### Mult closed-loop parity smoke (behavioral; lake build fails if example fails)
    Greppable: PARITY-MULT-SMOKE, HOST-PARITY-MULT-SMOKE.
    maxRecDepth already raised above for emitMultReady / multParityReady unfolds. -/

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
