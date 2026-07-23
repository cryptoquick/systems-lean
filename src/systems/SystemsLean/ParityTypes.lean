/-
  SYSTEMS_LEAN_HOST partial -- Types freestanding path parity (Mult+Linear+Types).
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): KernelTypes.lean Types kernel IR + program path;
    ParityLinear.lean Mult+Linear freestanding path (SH3 + SH3b); Types.lean
    kind/mult pairing; product wire TYPED_IR_V0 / slake_ir_node_* (frozen ABI);
    smoke/slake_behavioral_probe.c product TYPED_IR / slake_ir_node behavioral
    parity; self-host.md acceptance.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_PARITY_TYPES_V0 / HOST-PARITY-TYPES / SELF-HOST-PARITY-TYPES:
    freestanding Types product path honesty -- host Types kernel + program path
    contracts closed with Mult+Linear freestanding path + product API surface
    canaries (names match frozen wire).
  - Host model = structural representation of Types freestanding path contracts.
    Not an AI model.
  - typesContractParityOk: KernelTypes.typesKernelReady +
    KernelTypes.typesProgramPathReady (intentional re-assert: already inside
    typesKernelReady) + kindMultMismatchRejected + product API string canaries +
    ParityLinear.linearParityReady (Mult+Linear freestanding path prior rungs).
  - typesParityReady: typesContractParityOk && paritySurfaceOk (FAIL-CLOSED).
  - multLinearTypesParityReady: ParityLinear.multLinearParityReady &&
    typesParityReady -- greppable Mult+Linear+Types joint bar name.
    Mult+Linear is already folded into typesContractParityOk (via
    linearParityReady, which already folds Mult), so under current defs
    multLinearTypesParityReady is equivalent to typesParityReady (not a
    stronger gate; dual greppable honesty for HOST-PARITY-MULT +
    HOST-PARITY-LINEAR + HOST-PARITY-TYPES join). Not freestanding product
    self-host complete.
  - Product-wire TYPED_IR / slake_ir_node behavioral parity is exercised by
    hosted smoke (typed_ir id + ir_node init/well_typed/check_fail_closed) --
    same kind/mult fail-closed contracts the host proves in KernelTypes.
  - No new EMIT_* residual C stage ladder (host stage ids + frozen ABI only).

  Theorems (PARITY-TYPES-THEOREM / HOST-PARITY-TYPES-THEOREM -- partial
  ParityTypes):
  - typesParityReady_true / typesParityOk_true / typesContractParityOk_true
  - multLinearTypesParityReady_true / stageId_eq / hostParityTypesId_eq /
    selfHostParityTypesId_eq
  - Content equality (product API surface strings): productTypedIrId_eq /
    productIrNodeApi_eq / productIrNodeInitApi_eq /
    productIrNodeIsWellTypedApi_eq / productIrNodeCheckFailClosedApi_eq /
    productApiSurfaceOk_true
  These ParityTypes theorems do NOT set SpecProof.proofCompleteClaimed true.
  Types freestanding path readiness != freestanding product self-host complete.

  Intentional non-claims / partial parity:
  - PARTIAL: Types freestanding path honesty only; Mult grades already SH3;
    Mult+Linear Linear path already HOST-PARITY-LINEAR; no EmitTypes residual
    product C text SSoT; not program freestanding path parity close; SH5 host
    compose is SelfApply (not freestanding product self-host complete).
  - PARTIAL: host String/Bool model vs C int return tables
    (compatible contracts, not bit-identical runtime).
  - Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not unlock llvm. Does not grow bash EMIT_* residual treadmill.
  - Not freestanding product self-host complete.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_PARITY_TYPES_V0, HOST-PARITY-TYPES,
  SELF-HOST-PARITY-TYPES, PARITY-TYPES-SMOKE, HOST-PARITY-TYPES-SMOKE,
  typesParityReady, typesContractParityOk, multLinearTypesParityReady,
  TYPED_IR_V0, slake_ir_node, slake_ir_node_init, slake_ir_node_is_well_typed,
  slake_ir_node_check_fail_closed, HOST-KERNEL-TYPES, HOST-PARITY-LINEAR,
  HOST-PARITY-MULT, kindMultMismatchRejected, typesProgramPathReady,
  MULT-0, MULT-1, MULT-OMEGA, COMMON-UNIVERSE, ORDERED-IR-PROGRAM,
  PARITY-TYPES-THEOREM, HOST-PARITY-TYPES-THEOREM, typesParityReady_true,
  typesContractParityOk_true, productTypedIrId_eq, productIrNodeApi_eq,
  productIrNodeInitApi_eq, productIrNodeIsWellTypedApi_eq,
  productIrNodeCheckFailClosedApi_eq, productApiSurfaceOk_true
  UNIT_SURFACE host surface. Module: SystemsLean.ParityTypes
  Not freestanding emit. Not freestanding residual free. Not PROVABLY.
  Not freestanding emit residual free.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.KernelTypes
import SystemsLean.ParityLinear

namespace SystemsLean.ParityTypes

/-- Greppable primary stage id for Types freestanding path parity. -/
def stageId : String := "SLAKE_SELF_HOST_PARITY_TYPES_V0"

/-- Greppable short map id (HOST-PARITY-TYPES). -/
def hostParityTypesId : String := "HOST-PARITY-TYPES"

/-- Greppable short map id (SELF-HOST-PARITY-TYPES). -/
def selfHostParityTypesId : String := "SELF-HOST-PARITY-TYPES"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/ParityTypes.lean"

/-- Read-only product Types / TYPED_IR behavioral probe path cite. -/
def productProbePath : String := "src/systems/smoke/slake_behavioral_probe.c"

/-- Product wire Types / typed-IR API names (frozen ABI; compatible contracts). -/
def productTypedIrId : String := "TYPED_IR_V0"
def productIrNodeApi : String := "slake_ir_node"
def productIrNodeInitApi : String := "slake_ir_node_init"
def productIrNodeIsWellTypedApi : String := "slake_ir_node_is_well_typed"
def productIrNodeCheckFailClosedApi : String := "slake_ir_node_check_fail_closed"

/-- productApiSurfaceOk -- frozen product TYPED_IR / slake_ir_node API name canaries.
    Aligns host KernelTypes contracts with product probe symbols
    (representation PARTIAL: host String/Bool vs C int remains). -/
def productApiSurfaceOk : Bool :=
  (productTypedIrId == "TYPED_IR_V0")
    && (productIrNodeApi == "slake_ir_node")
    && (productIrNodeInitApi == "slake_ir_node_init")
    && (productIrNodeIsWellTypedApi == "slake_ir_node_is_well_typed")
    && (productIrNodeCheckFailClosedApi == "slake_ir_node_check_fail_closed")

/-- typesContractParityOk -- host Types freestanding path contracts closed.
    Composes real KernelTypes checks with Mult+Linear freestanding path and
    product API string canaries. typesProgramPathReady is an intentional
    re-assert of a conjunct already inside typesKernelReady (greppable
    EMPTY-PROGRAM-FAIL-CLOSED + foldWellTyped path). kindMultMismatchRejected
    is greppable kind/mult pairing fail-closed (also inside typesKernelReady).
    Mult+Linear is folded here via linearParityReady so typesParityReady
    already implies Mult SH3 + Linear freestanding path HOST-PARITY-LINEAR.
    Document: KernelTypes kind/mult contracts align with product TYPED_IR /
    slake_ir_node behavioral probe (PARTIAL String/Bool vs C).
    Not freestanding residual free. Not PROVABLY. -/
def typesContractParityOk : Bool :=
  KernelTypes.typesKernelReady
    && KernelTypes.typesProgramPathReady
    && KernelTypes.kindMultMismatchRejected
    && ParityLinear.linearParityReady
    && productApiSurfaceOk

/-- Surface canary: stage ids + path cites. -/
def paritySurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_PARITY_TYPES_V0")
    && (hostParityTypesId == "HOST-PARITY-TYPES")
    && (selfHostParityTypesId == "SELF-HOST-PARITY-TYPES")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/ParityTypes.lean")
    && (productProbePath == "src/systems/smoke/slake_behavioral_probe.c")

/-- typesParityReady -- Types freestanding path parity host readiness.
    FAIL-CLOSED: KernelTypes ready + Mult+Linear freestanding path + product
    API surface + stage/path surface canary.
    Greppable: typesParityReady, HOST-PARITY-TYPES, SELF-HOST-PARITY-TYPES. -/
def typesParityReady : Bool :=
  typesContractParityOk && paritySurfaceOk

/-- multLinearTypesParityReady -- greppable Mult+Linear+Types joint bar name.
    multLinearParityReady is already implied by linearParityReady (which is
    required by typesContractParityOk, hence by typesParityReady), so under
    current defs this is equivalent to typesParityReady -- not a stronger
    gate. Kept as dual greppable honesty for HOST-PARITY-MULT +
    HOST-PARITY-LINEAR + HOST-PARITY-TYPES join inventory.
    Do NOT set freestanding product self-host complete.
    Greppable: multLinearTypesParityReady, HOST-PARITY-MULT, HOST-PARITY-LINEAR,
    HOST-PARITY-TYPES. -/
def multLinearTypesParityReady : Bool :=
  ParityLinear.multLinearParityReady && typesParityReady

/-- Full Types freestanding path inventory ok (alias for inventory greps). -/
def typesParityOk : Bool := typesParityReady

/-! ### PARITY-TYPES-THEOREM / HOST-PARITY-TYPES-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is Types
  freestanding path readiness + Mult+Linear join only. Does not complete
  SpecProof; does not claim residual free / freestanding product self-host
  complete / PROVABLY / llvm unlock.
  maxRecDepth raised for multLinearParityReady / typesKernelReady unfolds.
-/

set_option maxRecDepth 8192

/-- Primary stage id is greppable SLAKE_SELF_HOST_PARITY_TYPES_V0.
    Greppable: stageId_eq, PARITY-TYPES-THEOREM, HOST-PARITY-TYPES-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_PARITY_TYPES_V0" := rfl

/-- Host map id is greppable HOST-PARITY-TYPES.
    Greppable: hostParityTypesId_eq, PARITY-TYPES-THEOREM. -/
theorem hostParityTypesId_eq : hostParityTypesId = "HOST-PARITY-TYPES" := rfl

/-- Short map id is greppable SELF-HOST-PARITY-TYPES.
    Greppable: selfHostParityTypesId_eq, PARITY-TYPES-THEOREM. -/
theorem selfHostParityTypesId_eq :
    selfHostParityTypesId = "SELF-HOST-PARITY-TYPES" := rfl

/-- Types freestanding path parity host readiness holds.
    Greppable: typesParityReady_true, HOST-PARITY-TYPES, SELF-HOST-PARITY-TYPES,
    PARITY-TYPES-THEOREM, HOST-PARITY-TYPES-THEOREM. -/
theorem typesParityReady_true : typesParityReady = true := by decide

/-- typesParityOk alias of typesParityReady holds.
    Greppable: typesParityOk_true, PARITY-TYPES-THEOREM. -/
theorem typesParityOk_true : typesParityOk = true := by decide

/-- Host Types freestanding path contracts closed.
    Greppable: typesContractParityOk_true, PARITY-TYPES-THEOREM,
    HOST-PARITY-TYPES-THEOREM. -/
theorem typesContractParityOk_true : typesContractParityOk = true := by decide

/-- Mult+Linear+Types joint bar name holds (equivalent to typesParityReady).
    Greppable: multLinearTypesParityReady_true, HOST-PARITY-MULT,
    HOST-PARITY-LINEAR, HOST-PARITY-TYPES, PARITY-TYPES-THEOREM. -/
theorem multLinearTypesParityReady_true :
    multLinearTypesParityReady = true := by decide

/-! ### PARITY-TYPES frozen-ABI product API surface pins (not Mult ofNat depth)

  product*Api_eq / productTypedIrId_eq are intentional greppable frozen-ABI
  surface canaries: local def-literal self-equality only (not Kernel/C/probe
  cross-SSOT). Weaker than ParityMult ofNatRoundTrip_tag* function content.
  Do not treat product*Api_eq volume as remaining algebraic residual.
  Path readiness canaries already held; no definitional alias spam.
-/

/-- Product TYPED_IR stage id surface pin (frozen-ABI canary; local def-literal).
    Greppable: productTypedIrId_eq, PARITY-TYPES-THEOREM. -/
theorem productTypedIrId_eq : productTypedIrId = "TYPED_IR_V0" := rfl

/-- Product ir_node API surface content.
    Greppable: productIrNodeApi_eq, PARITY-TYPES-THEOREM. -/
theorem productIrNodeApi_eq : productIrNodeApi = "slake_ir_node" := rfl

/-- Product ir_node_init API surface content.
    Greppable: productIrNodeInitApi_eq, PARITY-TYPES-THEOREM. -/
theorem productIrNodeInitApi_eq :
    productIrNodeInitApi = "slake_ir_node_init" := rfl

/-- Product ir_node_is_well_typed API surface content.
    Greppable: productIrNodeIsWellTypedApi_eq, PARITY-TYPES-THEOREM. -/
theorem productIrNodeIsWellTypedApi_eq :
    productIrNodeIsWellTypedApi = "slake_ir_node_is_well_typed" := rfl

/-- Product ir_node_check_fail_closed API surface content.
    Greppable: productIrNodeCheckFailClosedApi_eq, PARITY-TYPES-THEOREM. -/
theorem productIrNodeCheckFailClosedApi_eq :
    productIrNodeCheckFailClosedApi = "slake_ir_node_check_fail_closed" := rfl

/-- Product TYPED_IR / slake_ir_node API surface fold holds.
    Greppable: productApiSurfaceOk_true, PARITY-TYPES-THEOREM. -/
theorem productApiSurfaceOk_true : productApiSurfaceOk = true := by decide

/-! ### Types freestanding path parity smoke (behavioral; lake build fails if example fails)
    Greppable: PARITY-TYPES-SMOKE, HOST-PARITY-TYPES-SMOKE.
    maxRecDepth already raised above for multLinearParityReady / typesKernelReady. -/

/-- PARITY-TYPES-SMOKE / HOST-PARITY-TYPES-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_PARITY_TYPES_V0" := by decide
example : hostParityTypesId = "HOST-PARITY-TYPES" := by decide
example : selfHostParityTypesId = "SELF-HOST-PARITY-TYPES" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/ParityTypes.lean" := by decide
example : productProbePath = "src/systems/smoke/slake_behavioral_probe.c" := by decide
example : paritySurfaceOk = true := by decide

/-- PARITY-TYPES-SMOKE: product TYPED_IR / slake_ir_node API names frozen wire. -/
example : productApiSurfaceOk = true := by decide
example : productTypedIrId = "TYPED_IR_V0" := by decide
example : productIrNodeApi = "slake_ir_node" := by decide
example : productIrNodeInitApi = "slake_ir_node_init" := by decide
example : productIrNodeIsWellTypedApi = "slake_ir_node_is_well_typed" := by decide
example : productIrNodeCheckFailClosedApi = "slake_ir_node_check_fail_closed" := by decide

/-- PARITY-TYPES-SMOKE: KernelTypes + Mult+Linear freestanding path compose. -/
example : KernelTypes.typesKernelReady = true := by decide
example : KernelTypes.typesProgramPathReady = true := by decide
example : KernelTypes.kindMultMismatchRejected = true := by decide
example : ParityLinear.linearParityReady = true := by decide
example : ParityLinear.multLinearParityReady = true := by decide
example : typesContractParityOk = true := by decide
example : typesParityReady = true := by decide
example : typesParityOk = true := by decide
example : multLinearTypesParityReady = true := by decide

end SystemsLean.ParityTypes
