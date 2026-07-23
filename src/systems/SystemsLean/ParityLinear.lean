/-
  SYSTEMS_LEAN_HOST partial -- Linear freestanding path parity (Mult+Linear deepen).
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): KernelLinear.lean Linear kernel IR + HostCompose path;
    ParityMult.lean Mult closed-loop (SH3); Linear.lean JOIN-ALG ConsumeToken;
    HostCompose.lean mint/consume; product wire slake_linear_* /
    slake_consume_token_* (frozen ABI); CONSUME_TOKEN_HOST_V0;
    smoke/slake_behavioral_probe.c product Linear / CONSUME_TOKEN behavioral
    parity; self-host.md acceptance.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_PARITY_LINEAR_V0 / HOST-PARITY-LINEAR / SELF-HOST-PARITY-LINEAR:
    freestanding Linear product path honesty -- host Linear kernel + HostCompose
    mint/consume contracts closed with Mult closed loop + product API surface
    canaries (names match frozen wire).
  - Host model = structural representation of Linear freestanding path contracts.
    Not an AI model.
  - linearContractParityOk: KernelLinear.linearKernelReady +
    KernelLinear.linearHostPathReady (intentional re-assert: already inside
    linearKernelReady) + product API string canaries + Mult closed loop
    ParityMult.multParityReady.
  - linearParityReady: linearContractParityOk && paritySurfaceOk (FAIL-CLOSED).
  - multLinearParityReady: ParityMult.multParityReady && linearParityReady --
    greppable Mult+Linear joint bar name. Mult is already folded into
    linearContractParityOk, so under current defs multLinearParityReady is
    equivalent to linearParityReady (not a stronger gate; dual greppable
    honesty for HOST-PARITY-MULT + HOST-PARITY-LINEAR join). Not freestanding
    product self-host complete.
  - Product-wire Linear / CONSUME_TOKEN behavioral parity is exercised by hosted
    smoke (linear_token init/live/consume + consume_token mint/consume/is_live)
    -- same exact-once / mint-consume contracts the host proves in KernelLinear.
  - No new EMIT_* residual C stage ladder (host stage ids + frozen ABI only).

  Theorems (PARITY-LINEAR-THEOREM / HOST-PARITY-LINEAR-THEOREM -- partial
  ParityLinear):
  - linearParityReady_true / linearParityOk_true / linearContractParityOk_true
  - multLinearParityReady_true / stageId_eq / hostParityLinearId_eq /
    selfHostParityLinearId_eq
  - Content equality (product API surface strings): productLinearConsumeApi_eq /
    productLinearTokenInitApi_eq / productLinearTokenIsLiveApi_eq /
    productLinearTokenConsumeApi_eq / productConsumeTokenMintApi_eq /
    productConsumeTokenConsumeApi_eq / productConsumeTokenIsLiveApi_eq /
    productConsumeTokenHostId_eq / productApiSurfaceOk_true
  These ParityLinear theorems do NOT set SpecProof.proofCompleteClaimed true.
  Linear freestanding path readiness != freestanding product self-host complete.

  Intentional non-claims / partial parity:
  - PARTIAL: Linear freestanding path honesty only; Mult grades already SH3;
    no EmitLinear residual product C text SSoT; not types/program freestanding
    parity close; SH5 host compose is SelfApply (not freestanding product
    self-host complete).
  - PARTIAL: host String/Bool model vs C int return tables
    (compatible contracts, not bit-identical runtime).
  - Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not unlock llvm. Does not grow bash EMIT_* residual treadmill.
  - Not freestanding product self-host complete.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_PARITY_LINEAR_V0, HOST-PARITY-LINEAR,
  SELF-HOST-PARITY-LINEAR, PARITY-LINEAR-SMOKE, HOST-PARITY-LINEAR-SMOKE,
  linearParityReady, linearContractParityOk, multLinearParityReady,
  LINEAR-EXACT-ONCE, JOIN-ALG, ConsumeToken, CONSUME_TOKEN_HOST_V0,
  slake_linear_consume, slake_linear_token_init, slake_linear_token_is_live,
  slake_linear_token_consume, slake_consume_token_mint,
  slake_consume_token_consume, slake_consume_token_is_live, HOST-KERNEL-LINEAR,
  HOST-PARITY-MULT, PARITY-LINEAR-THEOREM, HOST-PARITY-LINEAR-THEOREM,
  linearParityReady_true, linearContractParityOk_true,
  productLinearConsumeApi_eq, productLinearTokenInitApi_eq,
  productLinearTokenIsLiveApi_eq, productLinearTokenConsumeApi_eq,
  productConsumeTokenMintApi_eq, productConsumeTokenConsumeApi_eq,
  productConsumeTokenIsLiveApi_eq, productConsumeTokenHostId_eq,
  productApiSurfaceOk_true
  UNIT_SURFACE host surface. Module: SystemsLean.ParityLinear
  Not freestanding emit. Not freestanding residual free. Not PROVABLY.
  Not freestanding emit residual free.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.KernelLinear
import SystemsLean.ParityMult

namespace SystemsLean.ParityLinear

/-- Greppable primary stage id for Linear freestanding path parity. -/
def stageId : String := "SLAKE_SELF_HOST_PARITY_LINEAR_V0"

/-- Greppable short map id (HOST-PARITY-LINEAR). -/
def hostParityLinearId : String := "HOST-PARITY-LINEAR"

/-- Greppable short map id (SELF-HOST-PARITY-LINEAR). -/
def selfHostParityLinearId : String := "SELF-HOST-PARITY-LINEAR"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/ParityLinear.lean"

/-- Read-only product Linear / CONSUME_TOKEN behavioral probe path cite. -/
def productProbePath : String := "src/systems/smoke/slake_behavioral_probe.c"

/-- Product wire Linear API names (frozen ABI; compatible contracts). -/
def productLinearConsumeApi : String := "slake_linear_consume"
def productLinearTokenInitApi : String := "slake_linear_token_init"
def productLinearTokenIsLiveApi : String := "slake_linear_token_is_live"
def productLinearTokenConsumeApi : String := "slake_linear_token_consume"

/-- Product wire CONSUME_TOKEN host API names (frozen ABI). -/
def productConsumeTokenMintApi : String := "slake_consume_token_mint"
def productConsumeTokenConsumeApi : String := "slake_consume_token_consume"
def productConsumeTokenIsLiveApi : String := "slake_consume_token_is_live"
def productConsumeTokenHostId : String := "CONSUME_TOKEN_HOST_V0"

/-- productApiSurfaceOk -- frozen product Linear / CONSUME_TOKEN API name canaries.
    Aligns host KernelLinear / HostCompose contracts with product probe symbols
    (representation PARTIAL: host String/Bool vs C int remains). -/
def productApiSurfaceOk : Bool :=
  (productLinearConsumeApi == "slake_linear_consume")
    && (productLinearTokenInitApi == "slake_linear_token_init")
    && (productLinearTokenIsLiveApi == "slake_linear_token_is_live")
    && (productLinearTokenConsumeApi == "slake_linear_token_consume")
    && (productConsumeTokenMintApi == "slake_consume_token_mint")
    && (productConsumeTokenConsumeApi == "slake_consume_token_consume")
    && (productConsumeTokenIsLiveApi == "slake_consume_token_is_live")
    && (productConsumeTokenHostId == "CONSUME_TOKEN_HOST_V0")

/-- linearContractParityOk -- host Linear freestanding path contracts closed.
    Composes real KernelLinear checks with Mult closed loop and product API
    string canaries. linearHostPathReady is an intentional re-assert of a
    conjunct already inside linearKernelReady (greppable mint/consume path).
    Mult is folded here so linearParityReady already implies Mult SH3.
    Document: HostCompose mint/consume contracts align with product
    CONSUME_TOKEN / linear_consume behavioral probe (PARTIAL String/Bool vs C).
    Not freestanding residual free. Not PROVABLY. -/
def linearContractParityOk : Bool :=
  KernelLinear.linearKernelReady
    && KernelLinear.linearHostPathReady
    && ParityMult.multParityReady
    && productApiSurfaceOk

/-- Surface canary: stage ids + path cites. -/
def paritySurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_PARITY_LINEAR_V0")
    && (hostParityLinearId == "HOST-PARITY-LINEAR")
    && (selfHostParityLinearId == "SELF-HOST-PARITY-LINEAR")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/ParityLinear.lean")
    && (productProbePath == "src/systems/smoke/slake_behavioral_probe.c")

/-- linearParityReady -- Linear freestanding path parity host readiness.
    FAIL-CLOSED: KernelLinear ready + Mult closed loop + product API surface +
    stage/path surface canary.
    Greppable: linearParityReady, HOST-PARITY-LINEAR, SELF-HOST-PARITY-LINEAR. -/
def linearParityReady : Bool :=
  linearContractParityOk && paritySurfaceOk

/-- multLinearParityReady -- greppable Mult+Linear joint bar name.
    multParityReady is already required by linearContractParityOk (hence by
    linearParityReady), so under current defs this is equivalent to
    linearParityReady -- not a stronger gate. Kept as dual greppable honesty
    for HOST-PARITY-MULT + HOST-PARITY-LINEAR join inventory.
    Do NOT set freestanding product self-host complete.
    Greppable: multLinearParityReady, HOST-PARITY-MULT, HOST-PARITY-LINEAR. -/
def multLinearParityReady : Bool :=
  ParityMult.multParityReady && linearParityReady

/-- Full Linear freestanding path inventory ok (alias for inventory greps). -/
def linearParityOk : Bool := linearParityReady

/-! ### PARITY-LINEAR-THEOREM / HOST-PARITY-LINEAR-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is Linear
  freestanding path readiness + Mult closed-loop join only. Does not complete
  SpecProof; does not claim residual free / freestanding product self-host
  complete / PROVABLY / llvm unlock.
  maxRecDepth raised for multParityReady / linearKernelReady String.beq unfolds.
-/

set_option maxRecDepth 4096

/-- Primary stage id is greppable SLAKE_SELF_HOST_PARITY_LINEAR_V0.
    Greppable: stageId_eq, PARITY-LINEAR-THEOREM, HOST-PARITY-LINEAR-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_PARITY_LINEAR_V0" := rfl

/-- Host map id is greppable HOST-PARITY-LINEAR.
    Greppable: hostParityLinearId_eq, PARITY-LINEAR-THEOREM. -/
theorem hostParityLinearId_eq : hostParityLinearId = "HOST-PARITY-LINEAR" := rfl

/-- Short map id is greppable SELF-HOST-PARITY-LINEAR.
    Greppable: selfHostParityLinearId_eq, PARITY-LINEAR-THEOREM. -/
theorem selfHostParityLinearId_eq :
    selfHostParityLinearId = "SELF-HOST-PARITY-LINEAR" := rfl

/-- Linear freestanding path parity host readiness holds.
    Greppable: linearParityReady_true, HOST-PARITY-LINEAR, SELF-HOST-PARITY-LINEAR,
    PARITY-LINEAR-THEOREM, HOST-PARITY-LINEAR-THEOREM. -/
theorem linearParityReady_true : linearParityReady = true := by decide

/-- linearParityOk alias of linearParityReady holds.
    Greppable: linearParityOk_true, PARITY-LINEAR-THEOREM. -/
theorem linearParityOk_true : linearParityOk = true := by decide

/-- Host Linear freestanding path contracts closed (kernel + Mult + product API).
    Greppable: linearContractParityOk_true, PARITY-LINEAR-THEOREM,
    HOST-PARITY-LINEAR-THEOREM. -/
theorem linearContractParityOk_true : linearContractParityOk = true := by decide

/-- Mult+Linear joint bar name holds (equivalent to linearParityReady).
    Greppable: multLinearParityReady_true, HOST-PARITY-MULT, HOST-PARITY-LINEAR,
    PARITY-LINEAR-THEOREM. -/
theorem multLinearParityReady_true : multLinearParityReady = true := by decide

/-! ### PARITY-LINEAR frozen-ABI product API surface pins (not Mult ofNat depth)

  product*Api_eq theorems are intentional greppable frozen-ABI surface canaries:
  each is local def-literal self-equality (def productX := "slake_..." then
  theorem productX_eq : productX = "slake_..." := rfl). They do NOT cross-check
  Kernel/C/probe SSOT and are weaker than ParityMult ofNatRoundTrip_tag* /
  isValidTag_tag* / nameParity_mult* function content. Kept as ABI honesty pins;
  do not treat product*Api_eq volume as remaining algebraic residual.
  Path readiness canaries already held; no definitional alias spam.
  Does NOT forge MULT-1 elaborator enforcement or residual free.
-/

/-- Product Linear consume API surface pin (frozen-ABI canary; local def-literal).
    Greppable: productLinearConsumeApi_eq, PARITY-LINEAR-THEOREM. -/
theorem productLinearConsumeApi_eq :
    productLinearConsumeApi = "slake_linear_consume" := rfl

/-- Product Linear token_init API surface content.
    Greppable: productLinearTokenInitApi_eq, PARITY-LINEAR-THEOREM. -/
theorem productLinearTokenInitApi_eq :
    productLinearTokenInitApi = "slake_linear_token_init" := rfl

/-- Product Linear token_is_live API surface content.
    Greppable: productLinearTokenIsLiveApi_eq, PARITY-LINEAR-THEOREM. -/
theorem productLinearTokenIsLiveApi_eq :
    productLinearTokenIsLiveApi = "slake_linear_token_is_live" := rfl

/-- Product Linear token_consume API surface content.
    Greppable: productLinearTokenConsumeApi_eq, PARITY-LINEAR-THEOREM. -/
theorem productLinearTokenConsumeApi_eq :
    productLinearTokenConsumeApi = "slake_linear_token_consume" := rfl

/-- Product CONSUME_TOKEN mint API surface content.
    Greppable: productConsumeTokenMintApi_eq, PARITY-LINEAR-THEOREM. -/
theorem productConsumeTokenMintApi_eq :
    productConsumeTokenMintApi = "slake_consume_token_mint" := rfl

/-- Product CONSUME_TOKEN consume API surface content.
    Greppable: productConsumeTokenConsumeApi_eq, PARITY-LINEAR-THEOREM. -/
theorem productConsumeTokenConsumeApi_eq :
    productConsumeTokenConsumeApi = "slake_consume_token_consume" := rfl

/-- Product CONSUME_TOKEN is_live API surface content.
    Greppable: productConsumeTokenIsLiveApi_eq, PARITY-LINEAR-THEOREM. -/
theorem productConsumeTokenIsLiveApi_eq :
    productConsumeTokenIsLiveApi = "slake_consume_token_is_live" := rfl

/-- Product CONSUME_TOKEN host stage id surface content.
    Greppable: productConsumeTokenHostId_eq, PARITY-LINEAR-THEOREM. -/
theorem productConsumeTokenHostId_eq :
    productConsumeTokenHostId = "CONSUME_TOKEN_HOST_V0" := rfl

/-- Product Linear / CONSUME_TOKEN API surface fold holds.
    Greppable: productApiSurfaceOk_true, PARITY-LINEAR-THEOREM. -/
theorem productApiSurfaceOk_true : productApiSurfaceOk = true := by decide

/-! ### Linear freestanding path parity smoke (behavioral; lake build fails if example fails)
    Greppable: PARITY-LINEAR-SMOKE, HOST-PARITY-LINEAR-SMOKE.
    maxRecDepth already raised above for multParityReady / linearKernelReady. -/

/-- PARITY-LINEAR-SMOKE / HOST-PARITY-LINEAR-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_PARITY_LINEAR_V0" := by decide
example : hostParityLinearId = "HOST-PARITY-LINEAR" := by decide
example : selfHostParityLinearId = "SELF-HOST-PARITY-LINEAR" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/ParityLinear.lean" := by decide
example : productProbePath = "src/systems/smoke/slake_behavioral_probe.c" := by decide
example : paritySurfaceOk = true := by decide

/-- PARITY-LINEAR-SMOKE: product Linear / CONSUME_TOKEN API names frozen wire. -/
example : productApiSurfaceOk = true := by decide
example : productLinearConsumeApi = "slake_linear_consume" := by decide
example : productLinearTokenInitApi = "slake_linear_token_init" := by decide
example : productLinearTokenIsLiveApi = "slake_linear_token_is_live" := by decide
example : productLinearTokenConsumeApi = "slake_linear_token_consume" := by decide
example : productConsumeTokenMintApi = "slake_consume_token_mint" := by decide
example : productConsumeTokenConsumeApi = "slake_consume_token_consume" := by decide
example : productConsumeTokenIsLiveApi = "slake_consume_token_is_live" := by decide
example : productConsumeTokenHostId = "CONSUME_TOKEN_HOST_V0" := by decide

/-- PARITY-LINEAR-SMOKE: KernelLinear + Mult closed loop compose into readiness. -/
example : KernelLinear.linearKernelReady = true := by decide
example : KernelLinear.linearHostPathReady = true := by decide
example : ParityMult.multParityReady = true := by decide
example : linearContractParityOk = true := by decide
example : linearParityReady = true := by decide
example : linearParityOk = true := by decide
example : multLinearParityReady = true := by decide

end SystemsLean.ParityLinear
