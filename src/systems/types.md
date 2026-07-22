# Types -- shared core (unit surface notes)

**Module role:** dependent types as the common universe for Slake's shared core.
**Lean host:** `SystemsLean/Types.lean` (TypeTag, NodeKind, IrNode, kind/mult pairing) +
`SystemsLean/IrProgram.lean` (ordered IR program node list; push / well-typed fold;
EMPTY-PROGRAM-FAIL-CLOSED) + `SystemsLean/IrGraph.lean` (embeds ordered program +
edge list; edgeMax 16 SLAKE_IR_EDGE_MAX; pushNode / addEdge; EMPTY-GRAPH-OK;
endpoint bounds fail-closed; IR-GRAPH-EDGES honesty) + light emit host modules
`SystemsLean/EmitPlan.lean` / `EmitApply.lean` / `EmitBody.lean` (plan counts +
tag pack + body fragment readiness; primary tables in extract.md) +
`SystemsLean/KernelTypes.lean` (**SELF-HOST-KERNEL-TYPES** / **HOST-KERNEL-TYPES** /
`SLAKE_SELF_HOST_KERNEL_TYPES_V0` SH4 growth: lowerTypesKernel / typesProgramPathReady /
typesKernelReady + KERNEL-TYPES-SMOKE; typed IR + foldWellTyped program path) +
`SystemsLean/ParityTypes.lean` (**HOST-PARITY-TYPES** / **SELF-HOST-PARITY-TYPES** /
`SLAKE_SELF_HOST_PARITY_TYPES_V0` Mult+Linear+Types freestanding Types path parity;
typesParityReady / multLinearTypesParityReady; PARITY-TYPES-SMOKE) +
`SystemsLean/KernelProgram.lean` (**SELF-HOST-KERNEL-PROGRAM** / **HOST-KERNEL-PROGRAM** /
`SLAKE_SELF_HOST_KERNEL_PROGRAM_V0` SH4 remainder: lowerProgramKernel /
programPathReady / programGraphPathReady / programComposePathReady /
programKernelReady + KERNEL-PROGRAM-SMOKE; ordered IR + graph edges + HostCompose) +
`SystemsLean/ParityProgram.lean` (**HOST-PARITY-PROGRAM** / **SELF-HOST-PARITY-PROGRAM** /
`SLAKE_SELF_HOST_PARITY_PROGRAM_V0` Mult+Linear+Types+Program freestanding Program
path parity; programParityReady / multLinearTypesProgramParityReady;
PARITY-PROGRAM-SMOKE) +
`SystemsLean/KernelEmit.lean` (**SELF-HOST-KERNEL-EMIT** / **HOST-KERNEL-EMIT** /
`SLAKE_SELF_HOST_KERNEL_EMIT_V0` SH4 remainder: lowerEmitCompose / emitPlanPathReady /
emitApplyPathReady / emitBodyPathReady / emitKernelReady + KERNEL-EMIT-SMOKE;
plan/apply/body + Mult emit over program kernel; no new EMIT_* C stage) +
`SystemsLean/ParityEmit.lean` (**HOST-PARITY-EMIT** / **SELF-HOST-PARITY-EMIT** /
`SLAKE_SELF_HOST_PARITY_EMIT_V0` Mult+Linear+Types+Program+Emit freestanding Emit
path parity; emitParityReady / multLinearTypesProgramEmitParityReady;
PARITY-EMIT-SMOKE).
Greppable **SYSTEMS_LEAN_HOST** (partial). Still not residual free.
**Status:** UNIT_DEEPEN_V1 abstract body + **TYPED_IR_V0** richer typed IR surface +
**IR_PROGRAM_V0** multi-node ordered program (historical wire id; node list) + **IR_GRAPH_EDGES_V0** graph edges on emit (`slake_type_tag_init`, `slake_ir_node_*`, `slake_ir_program_*`,
`slake_ir_graph_*`) + light **HOST_COMPOSE_V0** graph side of host composition +
light **EMIT_PLAN_V0** (emit plan counts nodes/edges from compose; primary in extract) +
light **EMIT_APPLY_V0** (fixed tag buffer from compose; primary in extract) +
light **EMIT_BODY_V0** (C body fragment from compose; primary in extract) +
**SELF-HOST-KERNEL-TYPES** / **HOST-KERNEL-TYPES** (SH4 partial Types kernel) +
**HOST-PARITY-TYPES** / **SELF-HOST-PARITY-TYPES** (Mult+Linear+Types freestanding
Types path parity) +
**SELF-HOST-KERNEL-PROGRAM** / **HOST-KERNEL-PROGRAM** (SH4 partial Program kernel) +
**HOST-PARITY-PROGRAM** / **SELF-HOST-PARITY-PROGRAM** (Mult+Linear+Types+Program
freestanding Program path parity) +
**SELF-HOST-KERNEL-EMIT** / **HOST-KERNEL-EMIT** (SH4 partial Emit / codegen kernel) +
**HOST-PARITY-EMIT** / **SELF-HOST-PARITY-EMIT** (Mult+Linear+Types+Program+Emit
freestanding Emit path parity).
Still not residual free. Still not full compiler / elaborator.
Not a full CFG / dominance / SSA.
**Self-host kernel marker:** SELF-HOST-KERNEL-TYPES / HOST-KERNEL-TYPES /
SLAKE_SELF_HOST_KERNEL_TYPES_V0 / KERNEL-TYPES-SMOKE; HOST-PARITY-TYPES /
SELF-HOST-PARITY-TYPES / SLAKE_SELF_HOST_PARITY_TYPES_V0 / PARITY-TYPES-SMOKE;
SELF-HOST-KERNEL-PROGRAM / HOST-KERNEL-PROGRAM / SLAKE_SELF_HOST_KERNEL_PROGRAM_V0 /
KERNEL-PROGRAM-SMOKE; HOST-PARITY-PROGRAM / SELF-HOST-PARITY-PROGRAM /
SLAKE_SELF_HOST_PARITY_PROGRAM_V0 / PARITY-PROGRAM-SMOKE; SELF-HOST-KERNEL-EMIT /
HOST-KERNEL-EMIT / SLAKE_SELF_HOST_KERNEL_EMIT_V0 / KERNEL-EMIT-SMOKE;
HOST-PARITY-EMIT / SELF-HOST-PARITY-EMIT / SLAKE_SELF_HOST_PARITY_EMIT_V0 /
PARITY-EMIT-SMOKE
**IR sketch:** `doc/shared-ir-sketch.md` (Types row).
**Deepen marker:** UNIT_DEEPEN_V1
**Typed IR marker:** TYPED_IR_V0
**Ordered IR program marker:** IR_PROGRAM_V0
**Graph edges marker:** IR_GRAPH_EDGES_V0
**Host compose marker:** HOST_COMPOSE_V0
**Emit plan marker:** EMIT_PLAN_V0
**Emit apply marker:** EMIT_APPLY_V0
**Emit body marker:** EMIT_BODY_V0
**Types freestanding path parity:** HOST-PARITY-TYPES / SELF-HOST-PARITY-TYPES /
SLAKE_SELF_HOST_PARITY_TYPES_V0
**Program freestanding path parity:** HOST-PARITY-PROGRAM / SELF-HOST-PARITY-PROGRAM /
SLAKE_SELF_HOST_PARITY_PROGRAM_V0
**Emit freestanding path parity:** HOST-PARITY-EMIT / SELF-HOST-PARITY-EMIT /
SLAKE_SELF_HOST_PARITY_EMIT_V0

## Intent

Surface differences between Idris side and Lean side elaborators are host residual.
Product wire residual is separate. The shared core treats types as the common universe
Slake will later check and extract under freestanding constraints.

## UNIT_DEEPEN_V1 contract

Thin type_tag: `typeTagInit` maps to C `slake_type_tag_init`. Fail closed on null.

## TYPED_IR_V0 (richer typed IR surface)

Single-node typed IR behind the V0 checker/host. Not residual free. Not a full elaborator.

| C symbol | Role |
|----------|------|
| `slake_typed_ir_id` | returns `TYPED_IR_V0` |
| `slake_ir_node` | type_tag + mult + kind + valid |
| `slake_ir_node_init` | fail closed on null / bad mult / kind-mult mismatch; leaves `valid=0` |
| `slake_ir_node_is_well_typed` | non-null + valid + mult known + kind matches mult |
| `slake_ir_node_check_fail_closed` | composes FAIL_CLOSED_CHECKER_V1; product path RUNTIME-FS |

Kind/mult pairing (fail closed):

| kind | mult |
|------|------|
| VALUE | MULT-OMEGA |
| LINEAR | MULT-1 |
| ERASED | MULT-0 |

Greppable: TYPED_IR_V0, COMMON-UNIVERSE, FAIL_CLOSED_CHECKER_V1, slake_ir_node,
slake_ir_node_init, slake_ir_node_is_well_typed, slake_ir_node_check_fail_closed,
HOST-PARITY-TYPES, SELF-HOST-PARITY-TYPES, SLAKE_SELF_HOST_PARITY_TYPES_V0,
PARITY-TYPES-SMOKE, typesParityReady, multLinearTypesParityReady.

## HOST-PARITY-TYPES (Types freestanding path honesty)

Mult+Linear+Types freestanding Types path parity in `SystemsLean/ParityTypes.lean`:
`typesContractParityOk` composes `typesKernelReady` + `typesProgramPathReady`
(re-assert) + `kindMultMismatchRejected` + Mult+Linear `linearParityReady` +
product API canaries; `typesParityReady`; `multLinearTypesParityReady` greppable
joint name (equivalent to typesParityReady under current defs -- Mult+Linear
already folded). Product side: probe labels existing TYPED_IR / slake_ir_node
path. No new EMIT_* C stage. Not freestanding product self-host complete.

## HOST-PARITY-PROGRAM (Program freestanding path honesty)

Mult+Linear+Types+Program freestanding Program path parity in
`SystemsLean/ParityProgram.lean`: `programContractParityOk` composes
`programKernelReady` + `programPathReady` / `programGraphPathReady` /
`programComposePathReady` (intentional re-assert) + Mult+Linear+Types
`typesParityReady` + product API canaries (IR_PROGRAM_V0 / IR_GRAPH_EDGES_V0 /
HOST_COMPOSE_V0 + slake_ir_program_* / slake_ir_graph_* / slake_host_compose_*);
`programParityReady`; `multLinearTypesProgramParityReady` greppable joint name
(equivalent to programParityReady under current defs -- Mult+Linear+Types already
folded). Product side: probe labels existing IR_PROGRAM / IR_GRAPH / HOST_COMPOSE
path. No new EMIT_* C stage. Not freestanding product self-host complete.

Greppable: HOST-PARITY-PROGRAM, SELF-HOST-PARITY-PROGRAM,
SLAKE_SELF_HOST_PARITY_PROGRAM_V0, PARITY-PROGRAM-SMOKE, HOST-PARITY-PROGRAM-SMOKE,
programParityReady, multLinearTypesProgramParityReady, SYSTEMS_LEAN_HOST.

## HOST-PARITY-EMIT (Emit freestanding path honesty)

Mult+Linear+Types+Program+Emit freestanding Emit path parity in
`SystemsLean/ParityEmit.lean`: `emitContractParityOk` composes
`emitKernelReady` + `emitPlanPathReady` / `emitApplyPathReady` /
`emitBodyPathReady` (intentional re-assert) + `emitMultReady` (intentional
re-assert) + Mult+Linear+Types+Program `programParityReady` + product API
canaries (EMIT_PLAN_V0 / EMIT_APPLY_V0 / EMIT_BODY_V0 / HOST-EMIT-SSOT /
HOST-EMIT-MULT + slake_emit_plan_* / slake_emit_apply_* / slake_emit_body_*);
`emitParityReady`; `multLinearTypesProgramEmitParityReady` greppable joint name
(equivalent to emitParityReady under current defs -- Mult+Linear+Types+Program
already folded). Product side: probe labels existing EMIT_PLAN / EMIT_APPLY /
EMIT_BODY path. No new EMIT_* C stage. Not freestanding product self-host complete.

Greppable: HOST-PARITY-EMIT, SELF-HOST-PARITY-EMIT,
SLAKE_SELF_HOST_PARITY_EMIT_V0, PARITY-EMIT-SMOKE, HOST-PARITY-EMIT-SMOKE,
emitParityReady, multLinearTypesProgramEmitParityReady, SYSTEMS_LEAN_HOST.

**SH5 freestanding deepen compose:** `SelfApplyFs.lean` requires
`freestandingParityLadderReady` (ParityEmit Mult..Emit joint) in addition to
extract/body path + host selfApplyReady; not freestanding product self-host
complete (freestandingProductSelfHostComplete = false).

## IR_PROGRAM_V0 (multi-node ordered ordered IR program)

Fixed-capacity ordered list of well-typed `slake_ir_node` (cap 8). Collective
well-typed + fail-closed over all live slots. Not a control-flow graph (CFG).
Not residual free. Not a full elaborator.

| C symbol | Role |
|----------|------|
| `slake_ir_program_id` | returns `IR_PROGRAM_V0` |
| `slake_ir_program` | nodes[CAP] + count + valid |
| `SLAKE_IR_PROGRAM_CAP` | fixed capacity 8 |
| `slake_ir_program_init` | empty program; 0 ok; -1 null |
| `slake_ir_program_push` | append well-typed node; 0 ok; -1 null/bad; -2 full |
| `slake_ir_program_is_well_typed` | valid + count>=1 + every node well-typed; empty fails closed |
| `slake_ir_program_check_fail_closed` | per-node FAIL_CLOSED_CHECKER_V1 compose; RUNTIME-FS |

Empty program (count==0) is NOT well-typed as a program (fail closed).

Honesty (V0): MULT-1 nodes may share one live linear token for check (checker does
not consume). MULT-0 nodes need marked erased when checked.

Greppable: IR_PROGRAM_V0, slake_ir_program, SLAKE_IR_PROGRAM_CAP,
HOST-PARITY-PROGRAM, SELF-HOST-PARITY-PROGRAM, SLAKE_SELF_HOST_PARITY_PROGRAM_V0,
PARITY-PROGRAM-SMOKE, programParityReady, multLinearTypesProgramParityReady.

## IR_GRAPH_EDGES_V0 (edges over ordered IR program)

**Lean host:** `SystemsLean/IrGraph.lean` -- `Edge` (fromIdx, toIdx), `Graph` embeds
ordered program + edge list, `edgeMax = 16` (SLAKE_IR_EDGE_MAX), `pushNode` /
`addEdge` fail-closed (full / bad endpoints), EMPTY-GRAPH-OK. Not residual free.
Not PROVABLY. Not a full CFG.

Emit graph shell owns a ordered IR program plus a fixed edge table (`SLAKE_IR_EDGE_MAX` 16).
Edges are index pairs into `prog.nodes`. Not residual free. Not PROVABLY.
Not a full CFG.

| C symbol | Role |
|----------|------|
| `slake_ir_graph_id` | returns `IR_GRAPH_EDGES_V0` |
| `slake_ir_graph` | prog + edges[MAX] + edge_count + valid |
| `slake_ir_edge` | from + to + valid |
| `SLAKE_IR_EDGE_MAX` | fixed capacity 16 |
| `slake_ir_graph_init` | empty graph; 0 ok; -1 null |
| `slake_ir_graph_push_node` | push through prog; same codes as program push |
| `slake_ir_graph_add_edge` | 0 ok; -1 null/invalid/full/endpoints out of range |
| `slake_ir_graph_is_well_typed` | valid + edges sound + empty graph OK or program well-typed |
| `slake_ir_graph_check_fail_closed` | well-typed then program check call-through; empty valid graph OK |

Empty edges OK. Empty valid graph (no nodes, no edges) is well-typed and check OK
at the graph surface. Nested empty program alone remains fail-closed under
IR_PROGRAM_V0. Failed add leaves edge_count unchanged and does not leave a
half-valid edge. MULT-1 / MULT-0 fail-closed honesty follows the program checker.

Greppable: IR_GRAPH_EDGES_V0, IR-GRAPH-EDGES, slake_ir_graph, SLAKE_IR_EDGE_MAX,
HOST-PARITY-PROGRAM, SELF-HOST-PARITY-PROGRAM, SLAKE_SELF_HOST_PARITY_PROGRAM_V0,
PARITY-PROGRAM-SMOKE, programParityReady, multLinearTypesProgramParityReady.

## HOST_COMPOSE_V0 (graph side of host compose; light note)

Emit composes `slake_ir_graph` with host + erasure as `slake_host_compose` under
**HOST_COMPOSE_V0**. Push/add_edge call through graph APIs. Primary API table
lives in `extract.md` / `linear.md`. Not residual free; not CFG.

**Lean host:** `SystemsLean/HostCompose.lean` owns graph + linear host + erasure
(HOST-COMPOSE partial). Graph call-throughs live there. Still not residual free.

Greppable: HOST_COMPOSE_V0, slake_host_compose, IR_GRAPH_EDGES_V0,
HOST-PARITY-PROGRAM, SELF-HOST-PARITY-PROGRAM, SLAKE_SELF_HOST_PARITY_PROGRAM_V0,
PARITY-PROGRAM-SMOKE, programParityReady, multLinearTypesProgramParityReady.

## EMIT_PLAN_V0 (light note; primary in extract.md)

**EMIT_PLAN_V0** builds a readiness inventory from a checked host compose
(`slake_emit_plan_from_compose`). Counts graph nodes/edges and mult survivors.
**Lean host:** `SystemsLean/EmitPlan.lean` (planFromCompose / isReady; EMIT-PLAN-SMOKE).
Primary API table lives in `extract.md`. Not residual free; not CFG/SSA.

Greppable: EMIT_PLAN_V0, slake_emit_plan, HOST_COMPOSE_V0, SYSTEMS_LEAN_HOST.

## EMIT_APPLY_V0 (light note; primary in extract.md)

**EMIT_APPLY_V0** packs live node mult/kind tags into a fixed buffer
(`slake_emit_apply_from_compose`, `SLAKE_EMIT_APPLY_CAP` 32 defensive headroom
above `SLAKE_IR_PROGRAM_CAP` 8). **Lean host:** `SystemsLean/EmitApply.lean`
(packTag / applyFromCompose / applyIsValid; EMIT-APPLY-SMOKE). Primary API table
lives in `extract.md`. Not residual free; not full C body; fixed buffer tags only.

Greppable: EMIT_APPLY_V0, slake_emit_apply, HOST_COMPOSE_V0, SYSTEMS_LEAN_HOST.

## EMIT_BODY_V0 (light note; primary in extract.md)

**EMIT_BODY_V0** builds a fixed-buffer freestanding C body fragment from a
checked host compose via plan + apply (`slake_emit_body_from_compose`,
`SLAKE_EMIT_BODY_CAP` 256 defensive headroom under `SLAKE_IR_PROGRAM_CAP` 8).
**Lean host:** `SystemsLean/EmitBody.lean` (buildFragment / bodyFromCompose;
markers derived from buf; EMIT-BODY-SMOKE). Primary API table lives in
`extract.md`. Not residual free; not CFG/SSA; not full product module emit.

Greppable: EMIT_BODY_V0, EMIT-BODY, BODY_CAP, slake_emit_body, HOST_COMPOSE_V0,
SYSTEMS_LEAN_HOST.
