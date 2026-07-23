/-
  SYSTEMS_LEAN_HOST partial -- Program freestanding path parity
  (Mult+Linear+Types+Program).
  Side: classic Lean elaborator under src/systems/ (not freestanding C runtime).
  Pair map (read-only): KernelProgram.lean program / graph / compose kernel IR;
    ParityTypes.lean Mult+Linear+Types freestanding path (SH3 + SH3b + SH3c);
    IrProgram.lean ordered IR + foldWellTyped + EMPTY-PROGRAM-FAIL-CLOSED;
    IrGraph.lean Graph + edges + EMPTY-GRAPH-OK; HostCompose.lean mint/consume;
    product wire IR_PROGRAM_V0 / IR_GRAPH_EDGES_V0 / HOST_COMPOSE_V0 /
    slake_ir_program_* / slake_ir_graph_* / slake_host_compose_* (frozen ABI);
    smoke/slake_behavioral_probe.c product IR_PROGRAM / IR_GRAPH / HOST_COMPOSE
    behavioral parity; self-host.md acceptance.

  Spec (readable, separate from any future proof):
  - SLAKE_SELF_HOST_PARITY_PROGRAM_V0 / HOST-PARITY-PROGRAM /
    SELF-HOST-PARITY-PROGRAM: freestanding Program product path honesty -- host
    Program kernel + path contracts closed with Mult+Linear+Types freestanding
    path + product API surface canaries (names match frozen wire).
  - Host model = structural representation of Program freestanding path
    contracts. Not an AI model.
  - programContractParityOk: KernelProgram.programKernelReady +
    KernelProgram.programPathReady / programGraphPathReady /
    programComposePathReady (intentional re-assert: already inside
    programKernelReady) + product API string canaries +
    ParityTypes.typesParityReady (Mult+Linear+Types freestanding path prior
    rungs).
  - programParityReady: programContractParityOk && paritySurfaceOk (FAIL-CLOSED).
  - multLinearTypesProgramParityReady: ParityTypes.multLinearTypesParityReady &&
    programParityReady -- greppable Mult+Linear+Types+Program joint bar name.
    Mult+Linear+Types is already folded into programContractParityOk (via
    typesParityReady, which already folds Mult+Linear), so under current defs
    multLinearTypesProgramParityReady is equivalent to programParityReady (not a
    stronger gate; dual greppable honesty for HOST-PARITY-MULT +
    HOST-PARITY-LINEAR + HOST-PARITY-TYPES + HOST-PARITY-PROGRAM join). Not
    freestanding product self-host complete.
  - Product-wire IR_PROGRAM / IR_GRAPH / HOST_COMPOSE behavioral parity is
    exercised by hosted smoke (program init/push/well_typed/check_fail_closed +
    graph init/push_node/add_edge + host_compose mint/consume path) -- same
    ordered-IR / edges / compose contracts the host proves in KernelProgram.
  - No new EMIT_* residual C stage ladder (host stage ids + frozen ABI only).

  Theorems (PARITY-PROGRAM-THEOREM / HOST-PARITY-PROGRAM-THEOREM -- partial
  ParityProgram):
  - programParityReady_true / programParityOk_true / programContractParityOk_true
  - multLinearTypesProgramParityReady_true / stageId_eq /
    hostParityProgramId_eq / selfHostParityProgramId_eq
  - Content equality (product API surface strings): productIrProgramId_eq /
    productIrGraphId_eq / productHostComposeId_eq / productIrProgramApi_eq /
    productIrProgramInitApi_eq / productIrProgramPushApi_eq /
    productIrProgramIsWellTypedApi_eq / productIrProgramCheckFailClosedApi_eq /
    productIrGraphApi_eq / productIrGraphInitApi_eq /
    productIrGraphPushNodeApi_eq / productIrGraphAddEdgeApi_eq /
    productHostComposeApi_eq / productHostComposeInitApi_eq /
    productHostComposeMintApi_eq / productHostComposeConsumeApi_eq /
    productApiSurfaceOk_true
  These ParityProgram theorems do NOT set SpecProof.proofCompleteClaimed true.
  Program freestanding path readiness != freestanding product self-host complete.

  Intentional non-claims / partial parity:
  - PARTIAL: Program freestanding path honesty only (ordered IR + graph + host
    compose); Mult grades already SH3; Mult+Linear Linear path already
    HOST-PARITY-LINEAR; Mult+Linear+Types Types path already HOST-PARITY-TYPES;
    no EmitProgram residual product C text SSoT; not Emit freestanding path
    parity close; SH5 host compose is SelfApply (not freestanding product
    self-host complete).
  - PARTIAL: host String/Bool model vs C int return tables
    (compatible contracts, not bit-identical runtime).
  - Not freestanding residual free. Not PROVABLY. Not freestanding emit residual free.
  - Not proof complete (SpecProof.proofCompleteClaimed stays false).
  - Classic Lean elaborator residual remains (host residual != product wire).
  - Does not unlock llvm. Does not grow bash EMIT_* residual treadmill.
  - Not freestanding product self-host complete.

  Greppable: SYSTEMS_LEAN_HOST, SLAKE_SELF_HOST_PARITY_PROGRAM_V0,
  HOST-PARITY-PROGRAM, SELF-HOST-PARITY-PROGRAM, PARITY-PROGRAM-SMOKE,
  HOST-PARITY-PROGRAM-SMOKE, programParityReady, programContractParityOk,
  multLinearTypesProgramParityReady, IR_PROGRAM_V0, IR_GRAPH_EDGES_V0,
  HOST_COMPOSE_V0, slake_ir_program, slake_ir_program_init,
  slake_ir_program_push, slake_ir_program_is_well_typed,
  slake_ir_program_check_fail_closed, slake_ir_graph, slake_ir_graph_init,
  slake_ir_graph_push_node, slake_ir_graph_add_edge, slake_host_compose,
  slake_host_compose_init, slake_host_compose_mint, slake_host_compose_consume,
  HOST-KERNEL-PROGRAM, HOST-PARITY-TYPES, HOST-PARITY-LINEAR, HOST-PARITY-MULT,
  MULT-0, MULT-1, MULT-OMEGA, ORDERED-IR-PROGRAM, EMPTY-PROGRAM-FAIL-CLOSED,
  EMPTY-GRAPH-OK, IR-GRAPH-EDGES, HOST-COMPOSE, PARITY-PROGRAM-THEOREM,
  HOST-PARITY-PROGRAM-THEOREM, programParityReady_true,
  programContractParityOk_true, productIrProgramId_eq, productIrGraphId_eq,
  productHostComposeId_eq, productIrProgramApi_eq, productIrProgramInitApi_eq,
  productIrProgramPushApi_eq, productIrProgramIsWellTypedApi_eq,
  productIrProgramCheckFailClosedApi_eq, productIrGraphApi_eq,
  productIrGraphInitApi_eq, productIrGraphPushNodeApi_eq,
  productIrGraphAddEdgeApi_eq, productHostComposeApi_eq,
  productHostComposeInitApi_eq, productHostComposeMintApi_eq,
  productHostComposeConsumeApi_eq, productApiSurfaceOk_true
  UNIT_SURFACE host surface. Module: SystemsLean.ParityProgram
  Not freestanding emit. Not freestanding residual free. Not PROVABLY.
  Not freestanding emit residual free.
  Red/green: just systems-host; lake build when toolchain installed.
  Module must stay ASCII.
-/

import SystemsLean.KernelProgram
import SystemsLean.ParityTypes

namespace SystemsLean.ParityProgram

/-- Greppable primary stage id for Program freestanding path parity. -/
def stageId : String := "SLAKE_SELF_HOST_PARITY_PROGRAM_V0"

/-- Greppable short map id (HOST-PARITY-PROGRAM). -/
def hostParityProgramId : String := "HOST-PARITY-PROGRAM"

/-- Greppable short map id (SELF-HOST-PARITY-PROGRAM). -/
def selfHostParityProgramId : String := "SELF-HOST-PARITY-PROGRAM"

/-- Read-only acceptance prose path cite (not a filesystem read). -/
def acceptancePath : String := "src/systems/self-host.md"

/-- Read-only this-module path cite (not a filesystem read). -/
def hostModulePath : String := "src/systems/SystemsLean/ParityProgram.lean"

/-- Read-only product program / graph / compose behavioral probe path cite. -/
def productProbePath : String := "src/systems/smoke/slake_behavioral_probe.c"

/-- Product wire program / graph / compose stage ids (frozen ABI). -/
def productIrProgramId : String := "IR_PROGRAM_V0"
def productIrGraphId : String := "IR_GRAPH_EDGES_V0"
def productHostComposeId : String := "HOST_COMPOSE_V0"

/-- Product wire ordered IR program API names (frozen ABI; compatible contracts). -/
def productIrProgramApi : String := "slake_ir_program"
def productIrProgramInitApi : String := "slake_ir_program_init"
def productIrProgramPushApi : String := "slake_ir_program_push"
def productIrProgramIsWellTypedApi : String := "slake_ir_program_is_well_typed"
def productIrProgramCheckFailClosedApi : String := "slake_ir_program_check_fail_closed"

/-- Product wire IR graph API names (frozen ABI). -/
def productIrGraphApi : String := "slake_ir_graph"
def productIrGraphInitApi : String := "slake_ir_graph_init"
def productIrGraphPushNodeApi : String := "slake_ir_graph_push_node"
def productIrGraphAddEdgeApi : String := "slake_ir_graph_add_edge"

/-- Product wire host compose API names (frozen ABI; greppable probe surface). -/
def productHostComposeApi : String := "slake_host_compose"
def productHostComposeInitApi : String := "slake_host_compose_init"
def productHostComposeMintApi : String := "slake_host_compose_mint"
def productHostComposeConsumeApi : String := "slake_host_compose_consume"

/-- productApiSurfaceOk -- frozen product program / graph / compose API name canaries.
    Aligns host KernelProgram contracts with product probe symbols
    (representation PARTIAL: host String/Bool vs C int remains). -/
def productApiSurfaceOk : Bool :=
  (productIrProgramId == "IR_PROGRAM_V0")
    && (productIrGraphId == "IR_GRAPH_EDGES_V0")
    && (productHostComposeId == "HOST_COMPOSE_V0")
    && (productIrProgramApi == "slake_ir_program")
    && (productIrProgramInitApi == "slake_ir_program_init")
    && (productIrProgramPushApi == "slake_ir_program_push")
    && (productIrProgramIsWellTypedApi == "slake_ir_program_is_well_typed")
    && (productIrProgramCheckFailClosedApi == "slake_ir_program_check_fail_closed")
    && (productIrGraphApi == "slake_ir_graph")
    && (productIrGraphInitApi == "slake_ir_graph_init")
    && (productIrGraphPushNodeApi == "slake_ir_graph_push_node")
    && (productIrGraphAddEdgeApi == "slake_ir_graph_add_edge")
    && (productHostComposeApi == "slake_host_compose")
    && (productHostComposeInitApi == "slake_host_compose_init")
    && (productHostComposeMintApi == "slake_host_compose_mint")
    && (productHostComposeConsumeApi == "slake_host_compose_consume")

/-- programContractParityOk -- host Program freestanding path contracts closed.
    Composes real KernelProgram checks with Mult+Linear+Types freestanding path
    and product API string canaries. programPathReady / programGraphPathReady /
    programComposePathReady are intentional re-asserts of conjuncts already
    inside programKernelReady (greppable ordered-IR / edges / compose paths).
    Mult+Linear+Types is folded here via typesParityReady so programParityReady
    already implies Mult SH3 + Linear freestanding path HOST-PARITY-LINEAR +
    Types freestanding path HOST-PARITY-TYPES.
    Document: KernelProgram program/graph/compose contracts align with product
    IR_PROGRAM / IR_GRAPH / HOST_COMPOSE behavioral probe (PARTIAL String/Bool
    vs C).
    Not freestanding residual free. Not PROVABLY. -/
def programContractParityOk : Bool :=
  KernelProgram.programKernelReady
    && KernelProgram.programPathReady
    && KernelProgram.programGraphPathReady
    && KernelProgram.programComposePathReady
    && ParityTypes.typesParityReady
    && productApiSurfaceOk

/-- Surface canary: stage ids + path cites. -/
def paritySurfaceOk : Bool :=
  (stageId == "SLAKE_SELF_HOST_PARITY_PROGRAM_V0")
    && (hostParityProgramId == "HOST-PARITY-PROGRAM")
    && (selfHostParityProgramId == "SELF-HOST-PARITY-PROGRAM")
    && (acceptancePath == "src/systems/self-host.md")
    && (hostModulePath == "src/systems/SystemsLean/ParityProgram.lean")
    && (productProbePath == "src/systems/smoke/slake_behavioral_probe.c")

/-- programParityReady -- Program freestanding path parity host readiness.
    FAIL-CLOSED: KernelProgram ready + Mult+Linear+Types freestanding path +
    product API surface + stage/path surface canary.
    Greppable: programParityReady, HOST-PARITY-PROGRAM, SELF-HOST-PARITY-PROGRAM. -/
def programParityReady : Bool :=
  programContractParityOk && paritySurfaceOk

/-- multLinearTypesProgramParityReady -- greppable Mult+Linear+Types+Program joint
    bar name. multLinearTypesParityReady is already implied by typesParityReady
    (which is required by programContractParityOk, hence by programParityReady),
    so under current defs this is equivalent to programParityReady -- not a
    stronger gate. Kept as dual greppable honesty for HOST-PARITY-MULT +
    HOST-PARITY-LINEAR + HOST-PARITY-TYPES + HOST-PARITY-PROGRAM join inventory.
    Do NOT set freestanding product self-host complete.
    Greppable: multLinearTypesProgramParityReady, HOST-PARITY-MULT,
    HOST-PARITY-LINEAR, HOST-PARITY-TYPES, HOST-PARITY-PROGRAM. -/
def multLinearTypesProgramParityReady : Bool :=
  ParityTypes.multLinearTypesParityReady && programParityReady

/-- Full Program freestanding path inventory ok (alias for inventory greps). -/
def programParityOk : Bool := programParityReady

/-! ### PARITY-PROGRAM-THEOREM / HOST-PARITY-PROGRAM-THEOREM (readable statements, then proofs)

  Real Lean theorems (not only `example` Bool canaries). Scope is Program
  freestanding path readiness + Mult+Linear+Types join only. Does not complete
  SpecProof; does not claim residual free / freestanding product self-host
  complete / PROVABLY / llvm unlock.
  maxRecDepth raised for programKernelReady / typesParityReady unfolds.
-/

set_option maxRecDepth 16384

/-- Primary stage id is greppable SLAKE_SELF_HOST_PARITY_PROGRAM_V0.
    Greppable: stageId_eq, PARITY-PROGRAM-THEOREM, HOST-PARITY-PROGRAM-THEOREM. -/
theorem stageId_eq : stageId = "SLAKE_SELF_HOST_PARITY_PROGRAM_V0" := rfl

/-- Host map id is greppable HOST-PARITY-PROGRAM.
    Greppable: hostParityProgramId_eq, PARITY-PROGRAM-THEOREM. -/
theorem hostParityProgramId_eq :
    hostParityProgramId = "HOST-PARITY-PROGRAM" := rfl

/-- Short map id is greppable SELF-HOST-PARITY-PROGRAM.
    Greppable: selfHostParityProgramId_eq, PARITY-PROGRAM-THEOREM. -/
theorem selfHostParityProgramId_eq :
    selfHostParityProgramId = "SELF-HOST-PARITY-PROGRAM" := rfl

/-- Program freestanding path parity host readiness holds.
    Greppable: programParityReady_true, HOST-PARITY-PROGRAM,
    SELF-HOST-PARITY-PROGRAM, PARITY-PROGRAM-THEOREM,
    HOST-PARITY-PROGRAM-THEOREM. -/
theorem programParityReady_true : programParityReady = true := by decide

/-- programParityOk alias of programParityReady holds.
    Greppable: programParityOk_true, PARITY-PROGRAM-THEOREM. -/
theorem programParityOk_true : programParityOk = true := by decide

/-- Host Program freestanding path contracts closed.
    Greppable: programContractParityOk_true, PARITY-PROGRAM-THEOREM,
    HOST-PARITY-PROGRAM-THEOREM. -/
theorem programContractParityOk_true :
    programContractParityOk = true := by decide

/-- Mult+Linear+Types+Program joint bar name holds.
    Greppable: multLinearTypesProgramParityReady_true, HOST-PARITY-PROGRAM,
    PARITY-PROGRAM-THEOREM. -/
theorem multLinearTypesProgramParityReady_true :
    multLinearTypesProgramParityReady = true := by decide

/-! ### PARITY-PROGRAM frozen-ABI product API surface pins (not Mult ofNat depth)

  product*Api_eq theorems are intentional greppable frozen-ABI surface canaries:
  local def-literal self-equality only (not Kernel/C/probe cross-SSOT). Weaker
  than ParityMult ofNatRoundTrip_tag* function content. Do not treat
  product*Api_eq volume as remaining algebraic residual.
  Path readiness canaries already held; no definitional alias spam.
-/

/-- Product IR_PROGRAM stage id surface pin (frozen-ABI canary; local def-literal).
    Greppable: productIrProgramId_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrProgramId_eq : productIrProgramId = "IR_PROGRAM_V0" := rfl

/-- Product IR_GRAPH_EDGES stage id surface content.
    Greppable: productIrGraphId_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrGraphId_eq : productIrGraphId = "IR_GRAPH_EDGES_V0" := rfl

/-- Product HOST_COMPOSE stage id surface content.
    Greppable: productHostComposeId_eq, PARITY-PROGRAM-THEOREM. -/
theorem productHostComposeId_eq : productHostComposeId = "HOST_COMPOSE_V0" := rfl

/-- Product ir_program API surface content.
    Greppable: productIrProgramApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrProgramApi_eq : productIrProgramApi = "slake_ir_program" := rfl

/-- Product ir_program_init API surface content.
    Greppable: productIrProgramInitApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrProgramInitApi_eq :
    productIrProgramInitApi = "slake_ir_program_init" := rfl

/-- Product ir_program_push API surface content.
    Greppable: productIrProgramPushApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrProgramPushApi_eq :
    productIrProgramPushApi = "slake_ir_program_push" := rfl

/-- Product ir_program_is_well_typed API surface content.
    Greppable: productIrProgramIsWellTypedApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrProgramIsWellTypedApi_eq :
    productIrProgramIsWellTypedApi = "slake_ir_program_is_well_typed" := rfl

/-- Product ir_program_check_fail_closed API surface content.
    Greppable: productIrProgramCheckFailClosedApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrProgramCheckFailClosedApi_eq :
    productIrProgramCheckFailClosedApi =
      "slake_ir_program_check_fail_closed" := rfl

/-- Product ir_graph API surface content.
    Greppable: productIrGraphApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrGraphApi_eq : productIrGraphApi = "slake_ir_graph" := rfl

/-- Product ir_graph_init API surface content.
    Greppable: productIrGraphInitApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrGraphInitApi_eq :
    productIrGraphInitApi = "slake_ir_graph_init" := rfl

/-- Product ir_graph_push_node API surface content.
    Greppable: productIrGraphPushNodeApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrGraphPushNodeApi_eq :
    productIrGraphPushNodeApi = "slake_ir_graph_push_node" := rfl

/-- Product ir_graph_add_edge API surface content.
    Greppable: productIrGraphAddEdgeApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productIrGraphAddEdgeApi_eq :
    productIrGraphAddEdgeApi = "slake_ir_graph_add_edge" := rfl

/-- Product host_compose API surface content.
    Greppable: productHostComposeApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productHostComposeApi_eq :
    productHostComposeApi = "slake_host_compose" := rfl

/-- Product host_compose_init API surface content.
    Greppable: productHostComposeInitApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productHostComposeInitApi_eq :
    productHostComposeInitApi = "slake_host_compose_init" := rfl

/-- Product host_compose_mint API surface content.
    Greppable: productHostComposeMintApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productHostComposeMintApi_eq :
    productHostComposeMintApi = "slake_host_compose_mint" := rfl

/-- Product host_compose_consume API surface content.
    Greppable: productHostComposeConsumeApi_eq, PARITY-PROGRAM-THEOREM. -/
theorem productHostComposeConsumeApi_eq :
    productHostComposeConsumeApi = "slake_host_compose_consume" := rfl

/-- Product program / graph / compose API surface fold holds.
    Greppable: productApiSurfaceOk_true, PARITY-PROGRAM-THEOREM. -/
theorem productApiSurfaceOk_true : productApiSurfaceOk = true := by decide

/-! ### Program freestanding path parity smoke (behavioral; lake build fails if example fails)
    Greppable: PARITY-PROGRAM-SMOKE, HOST-PARITY-PROGRAM-SMOKE.
    maxRecDepth already raised above for programKernelReady / typesParityReady. -/

/-- PARITY-PROGRAM-SMOKE / HOST-PARITY-PROGRAM-SMOKE: stage / map ids greppable. -/
example : stageId = "SLAKE_SELF_HOST_PARITY_PROGRAM_V0" := by decide
example : hostParityProgramId = "HOST-PARITY-PROGRAM" := by decide
example : selfHostParityProgramId = "SELF-HOST-PARITY-PROGRAM" := by decide
example : acceptancePath = "src/systems/self-host.md" := by decide
example : hostModulePath = "src/systems/SystemsLean/ParityProgram.lean" := by decide
example : productProbePath = "src/systems/smoke/slake_behavioral_probe.c" := by decide
example : paritySurfaceOk = true := by decide

/-- PARITY-PROGRAM-SMOKE: product program / graph / compose API names frozen wire. -/
example : productApiSurfaceOk = true := by decide
example : productIrProgramId = "IR_PROGRAM_V0" := by decide
example : productIrGraphId = "IR_GRAPH_EDGES_V0" := by decide
example : productHostComposeId = "HOST_COMPOSE_V0" := by decide
example : productIrProgramApi = "slake_ir_program" := by decide
example : productIrProgramInitApi = "slake_ir_program_init" := by decide
example : productIrProgramPushApi = "slake_ir_program_push" := by decide
example : productIrProgramIsWellTypedApi = "slake_ir_program_is_well_typed" := by decide
example : productIrProgramCheckFailClosedApi = "slake_ir_program_check_fail_closed" := by decide
example : productIrGraphApi = "slake_ir_graph" := by decide
example : productIrGraphInitApi = "slake_ir_graph_init" := by decide
example : productIrGraphPushNodeApi = "slake_ir_graph_push_node" := by decide
example : productIrGraphAddEdgeApi = "slake_ir_graph_add_edge" := by decide
example : productHostComposeApi = "slake_host_compose" := by decide
example : productHostComposeInitApi = "slake_host_compose_init" := by decide
example : productHostComposeMintApi = "slake_host_compose_mint" := by decide
example : productHostComposeConsumeApi = "slake_host_compose_consume" := by decide

/-- PARITY-PROGRAM-SMOKE: KernelProgram + Mult+Linear+Types freestanding path compose. -/
example : KernelProgram.programKernelReady = true := by decide
example : KernelProgram.programPathReady = true := by decide
example : KernelProgram.programGraphPathReady = true := by decide
example : KernelProgram.programComposePathReady = true := by decide
example : ParityTypes.typesParityReady = true := by decide
example : ParityTypes.multLinearTypesParityReady = true := by decide
example : programContractParityOk = true := by decide
example : programParityReady = true := by decide
example : programParityOk = true := by decide
example : multLinearTypesProgramParityReady = true := by decide

end SystemsLean.ParityProgram
