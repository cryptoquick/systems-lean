# SYSTEMS_LEAN_HOST -- Mult..ProductPath PARTIAL inventory (P1.1 + P2..P7 + SH0..SH6 hold + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH)

**Greppable:** HOST-PARTIAL-INVENTORY, SYSTEMS_LEAN_HOST, CLOSABLE-MISS-COUNT-0,
HOST-INVENTORY-CLOSE, SELF-HOST-INVENTORY-CLOSE,
HOST-PRODUCT-PATH, SELF-HOST-PRODUCT-PATH,
SELF-HOST-KERNEL-TYPES, HOST-KERNEL-TYPES, HOST-PARITY-TYPES,
SELF-HOST-PARITY-TYPES, SELF-HOST-KERNEL-PROGRAM, HOST-KERNEL-PROGRAM,
HOST-PARITY-PROGRAM, SELF-HOST-PARITY-PROGRAM,
SELF-HOST-KERNEL-EMIT, HOST-KERNEL-EMIT, HOST-PARITY-EMIT,
SELF-HOST-PARITY-EMIT, HOST-SELF-APPLY-FS,
SELF-HOST-SELF-APPLY-FS
**Date evidence:** 2026-07-22 freestanding self-host track: SH0 acceptance
(`self-host.md`) + SH1 Mult kernel IR (`KernelMult.lean`) + SH2 host Mult emit
(`EmitMult.lean` + `emit/host_emit_mult.ssot.txt`) + SH3 Mult closed-loop
parity (`ParityMult.lean` + product Mult probe checks) + SH4 Linear kernel
start (`KernelLinear.lean` ordered IR + HostCompose path) + Mult+Linear
freestanding Linear path parity (`ParityLinear.lean` linearParityReady /
multLinearParityReady + probe labels) + SH4 Types kernel
growth (`KernelTypes.lean` typed IR + program path) + Mult+Linear+Types
freestanding Types path parity (`ParityTypes.lean` typesParityReady /
multLinearTypesParityReady + probe labels) + SH4 Program kernel growth
(`KernelProgram.lean` ordered IR + graph edges + HostCompose path) +
Mult+Linear+Types+Program freestanding Program path parity
(`ParityProgram.lean` programParityReady / multLinearTypesProgramParityReady +
probe labels) + SH4 Emit codegen host honesty (`KernelEmit.lean` plan/apply/body
+ Mult emit over program kernel) + Mult+Linear+Types+Program+Emit freestanding
Emit path parity (`ParityEmit.lean` emitParityReady /
multLinearTypesProgramEmitParityReady + probe labels) + SH5 self-apply partial
(`SelfApply.lean` Mult closed loop + Linear + Types + Program + Emit kernel
compose) + SH5 freestanding deepen partial (`SelfApplyFs.lean` freestanding
extract/body path on kernel emit compose + freestanding Mult..Emit parity
ladder compose via freestandingParityLadderReady) + SH6 llvm/PROVABLY **held
(documented)** (`LlvmHold.lean` hold gate; not unlock) + **HOST-INVENTORY-CLOSE**
(`InventoryClose.lean` inventory close readiness after Mult..LlvmHold;
inventoryCloseReady; not residual free) + **HOST-PRODUCT-PATH**
(`ProductPath.lean` freestanding unit/program product path readiness after
inventory close; productPathReady; not residual free; not product complete).
Prior: P1 inventory; P2 HOST-EMIT-SSOT; P3 HOST-COMPILE-PATH; P4 HOST-JOIN-MAP;
P5 HOST-SELF-HOST; P7 HOST-SURFACE-MATRIX.
**Scope:** Lean host under `src/systems/SystemsLean/` (ladder through
ProductPath including InventoryClose + LlvmHold + SelfApplyFs + ParityTypes +
ParityProgram + ParityEmit) vs frozen freestanding product wire (`emit/`,
UNIT_DEEPEN notes) and pure Nix presence (`nix/systems-host-presence/`).
**Method:** module defs vs extract.md / README host tables vs presence
`hostSpecs` + `requiredFiles`; no phantom modules. Re-verify confirms
CLOSABLE-MISS-COUNT-0 (not a fresh invent pass).

**Verdict:** CLOSABLE-MISS-COUNT-0. Every Mult..ProductPath host module is present
(31 modules + root import; Mult..InventoryClose was the prior 30-module endpoint),
imported from `SystemsLean.lean`, presence-green, and API tables match defs. P1.2 / P1.3 had no named closable gap. **P2 (HOST-EMIT-SSOT)**
landed: Lean `buildFragment` + `emit/host_emit_body_fragment.ssot.txt` own EMIT_BODY
fragment dialect; bash generator is NON-SSOT for that fragment. **P3 (HOST-COMPILE-PATH)**
landed: `CompilePath.lean` unit/program readiness (sibling bars; see row). **P4
(HOST-JOIN-MAP)** landed: `JoinMap.lean` composes JOIN-ALG dual cite with
CompilePath unit/program readiness (sibling bars preserved). **P5 (HOST-SELF-HOST)**
landed: `SelfHost.lean` composes JoinMap unit/program readiness with host surface
canary for self-host *direction* (not self-host complete). **P7 (HOST-SURFACE-MATRIX)**
landed: `SurfaceMatrix.lean` + `surface-matrix.md` progressive superset surface
inventory; open parity / llvm / PROVABLY rows stay **open**. **SH0/SH1** landed:
`self-host.md` acceptance + `KernelMult.lean` Mult kernel ordered IR fixture
(structural host model -- not an AI model). **SH2** landed: `EmitMult.lean`
HOST-EMIT-MULT Mult freestanding C text + durable `emit/host_emit_mult.ssot.txt`;
bash NON-SSOT for Mult product text. **SH3** landed: `ParityMult.lean`
HOST-PARITY-MULT Mult closed-loop host readiness + product Mult name/is_known/tag
behavioral smoke. **SH4 start** landed: `KernelLinear.lean` SELF-HOST-KERNEL-LINEAR
Linear ordered IR + HostCompose mint/consume exact-once path (KERNEL-LINEAR-SMOKE).
**HOST-PARITY-LINEAR** landed: `ParityLinear.lean` freestanding Linear path parity
(linearParityReady / multLinearParityReady; Mult+Linear deepen; probe labels).
**SH4 Types growth** landed: `KernelTypes.lean` SELF-HOST-KERNEL-TYPES /
HOST-KERNEL-TYPES typed IR + foldWellTyped program-path honesty
(KERNEL-TYPES-SMOKE). **HOST-PARITY-TYPES** landed: `ParityTypes.lean`
freestanding Types path parity (typesParityReady / multLinearTypesParityReady;
Mult+Linear+Types deepen; probe labels). **SH4 Program growth** landed:
`KernelProgram.lean` SELF-HOST-KERNEL-PROGRAM / HOST-KERNEL-PROGRAM ordered IR +
graph edges + HostCompose path honesty (KERNEL-PROGRAM-SMOKE).
**HOST-PARITY-PROGRAM** landed: `ParityProgram.lean` freestanding Program path
parity (programParityReady / multLinearTypesProgramParityReady;
Mult+Linear+Types+Program deepen; probe labels). **SH4 Emit codegen**
landed: `KernelEmit.lean` SELF-HOST-KERNEL-EMIT / HOST-KERNEL-EMIT plan/apply/body
path over program kernel + Mult emit honesty (KERNEL-EMIT-SMOKE); no new EMIT_* C
stage. **HOST-PARITY-EMIT** landed: `ParityEmit.lean` freestanding Emit path
parity (emitParityReady / multLinearTypesProgramEmitParityReady;
Mult+Linear+Types+Program+Emit deepen; probe labels; no new EMIT_* C stage).
**SH5 partial** landed: `SelfApply.lean` HOST-SELF-APPLY /
SELF-HOST-SELF-APPLY selfApplyReady / kernelRebuildsKernel compose Mult closed
loop + Linear + Types + Program + Emit kernel (host structural
kernel-rebuilds-kernel only; not freestanding product self-host complete).
**SH5 freestanding deepen partial** landed: `SelfApplyFs.lean` HOST-SELF-APPLY-FS /
SELF-HOST-SELF-APPLY-FS / `SLAKE_SELF_HOST_SELF_APPLY_FS_V0`
freestandingExtractPathReady + freestandingBodyPathReady +
freestandingParityLadderReady (ParityEmit.multLinearTypesProgramEmitParityReady;
dual freestandingEmitParityReady = emitParityReady -- equivalent under folds,
not a stronger gate) + freestandingSelfApplyReady = selfApplyReady && path &&
parity ladder && surface && !complete with freestandingProductSelfHostComplete =
false (SELF-APPLY-FS-SMOKE). **SH6 held (documented)** landed: `LlvmHold.lean`
HOST-LLVM-HOLD / HOST-PROVABLY-HOLD / `llvmHoldReady` true with `llvmUnlocked` /
`provablyUnlocked` / `freestandingProductSelfHostComplete` false -- hold gate
active, **not** llvm unlock; P6 residual mill stays hold. **HOST-INVENTORY-CLOSE**
landed: `InventoryClose.lean` HOST-INVENTORY-CLOSE / SELF-HOST-INVENTORY-CLOSE /
`SLAKE_SELF_HOST_INVENTORY_CLOSE_V0` inventoryCloseReady =
freestandingSelfApplyReady && llvmHoldReady && surface && partialCarry &&
!complete && !llvmUnlocked && !provablyUnlocked; residualFreeClaimed = false;
inventoryCloseDoesNotMeanResidualFree; intentional PARTIAL carry honest
(INVENTORY-CLOSE-SMOKE). Inventory close is readiness only -- **not** residual
free; **not** freestanding product self-host complete; **not** llvm unlock.
**HOST-PRODUCT-PATH** landed: `ProductPath.lean` HOST-PRODUCT-PATH /
SELF-HOST-PRODUCT-PATH / `SLAKE_SELF_HOST_PRODUCT_PATH_V0` productPathReady =
inventoryCloseReady && freestandingUnitProductPathReady &&
freestandingProgramProductPathReady && surface && !residual free claimed &&
!product complete claimed && !SelfApplyFs complete && !llvm unlock &&
!provably unlock; freestandingUnitProductPathReady = unitCompileReady /
extractOkFs on empty + unminted fail + lowerEmitCompose some; sibling
freestandingProgramProductPathReady = empty program fail-closed + lowered
kernel well-typed; productPathDoesNotComplete /
productPathDoesNotMeanResidualFree; PRODUCT-PATH-SMOKE -- not residual free;
not freestanding product self-host complete; not llvm unlock.
Remaining PARTIAL rows (List/String vs C arrays, no null/return codes, host Bool
readiness vs FS unit compile, join/self-host/matrix surface canaries vs formal dual
theorems / freestanding product self-host complete / full Idris+Lean parity,
product wire bulk still frozen) stay intentional.

Still **not residual free**. Not PROVABLY. Not llvm unlocked.

---

## Class legend

| Class | Meaning |
|-------|---------|
| **OK** | Host surface matches wire honesty for PARTIAL host; presence + defs align |
| **intentional PARTIAL** | Documented host-vs-wire or surface-vs-formal gap; not a closable miss |
| **closable miss** | Missing def, broken import, residual/API table advertises helper Lean lacks, presence RED |

---

## Row inventory (Mult..ProductPath)

| Module | Product wire map | Class | Evidence / notes |
|--------|------------------|-------|------------------|
| `SystemsLean/Mult.lean` | `enum slake_mult`, `slake_mult_is_valid` | **OK** | Closed Mult; `isValid` total-true by match; FAIL-CLOSED-UNKNOWN-GRADE via `ofNat?` / `isValidTag`; `multIsValid` alias. Presence: MULT-0/1/OMEGA + FAIL-CLOSED-UNKNOWN-GRADE. |
| `SystemsLean/Linear.lean` | CONSUME_TOKEN_HOST_V0 / JOIN-ALG | **OK** + **intentional PARTIAL** | JOIN-ALG ConsumeToken axioms (`Token`, `mkToken`, `consume`, `roundTrip`). Classic elaborator cannot enforce MULT-1 / LINEAR-EXACT-ONCE -- axioms are the host contract (P1.3). Live-flag model lives on HostCompose. Dual cite paths read-only. SH4 kernel IR is KernelLinear. |
| `SystemsLean/Types.lean` | TYPED_IR_V0 `slake_ir_node_*` | **OK** | TypeTag, NodeKind, kind/mult pairing, IrNode, `mkNode?` / `mkNodeFromTags?`, FAIL-CLOSED-UNKNOWN-KIND. |
| `SystemsLean/IrProgram.lean` | IR_PROGRAM_V0, CAP 8 | **OK** + **intentional PARTIAL** | Ordered list under `programCap` 8; push / isWellTyped / foldWellTyped; EMPTY-PROGRAM-FAIL-CLOSED. PARTIAL: List vs fixed C array; program-level mult/token check is HostCompose, not this module. |
| `SystemsLean/Erasure.lean` | `slake_erased`, runtime-absent | **OK** | Erased, mark, isRuntimeAbsent, markForGrade?, checkFailClosed; ERASE-RULE-MULT-0 / ERASE-NO-RUNTIME / EDGE-PROP / ERASE-PROP. |
| `SystemsLean/Extract.lean` | FAIL_CLOSED_CHECKER_V1 thin path | **OK** + **intentional PARTIAL** | RuntimeClaim three-way; extractOk / checkFailClosed; extractOkFromTags?. PARTIAL: MULT-1 passes without live token (documented); fuller path HostCompose.multPreScan. C collapses CLASSIC/EDGE tags; host keeps three claims. |
| `SystemsLean/IrGraph.lean` | IR_GRAPH_EDGES_V0, EDGE_MAX 16 | **OK** + **intentional PARTIAL** | Graph embeds Program + edges; pushNode / addEdge; EMPTY-GRAPH-OK; edgesSound; IR-GRAPH-SMOKE. PARTIAL: List vs fixed C edge slots; no null return codes. |
| `SystemsLean/HostCompose.lean` | HOST_COMPOSE_V0 | **OK** + **intentional PARTIAL** | Host = graph + LinearHost + Erased; mint/consume/markErased; pushHostNode/addHostEdge; multPreScan closes Extract MULT-1 gap; extractOk / extractOkFs; HOST-SMOKE. PARTIAL: no null pointers / exact C -1/-2 tables (typed results + Bool). |
| `SystemsLean/EmitPlan.lean` | EMIT_PLAN_V0 | **OK** + **intentional PARTIAL** | Plan counts; planFromCompose fail-closed on checkFailClosed (not extractOk); isReady / planOk; EMIT-PLAN-SMOKE. PARTIAL: Nat/Bool vs C out-pointer + -1 codes. |
| `SystemsLean/EmitApply.lean` | EMIT_APPLY_V0, APPLY_CAP 32 | **OK** + **intentional PARTIAL** | packTag nibble layout; applyFromCompose / applyIsValid / applyOk; EMIT-APPLY-SMOKE. PARTIAL: List Nat vs fixed C `tags[32]`. |
| `SystemsLean/EmitBody.lean` | EMIT_BODY_V0, BODY_CAP 256 | **OK** + **intentional PARTIAL** | **HOST-EMIT-SSOT**: buildFragment + emptyComposeFragmentSsot; bodyFromCompose / bodyIsValid / bodyOk; markers from buf; EMIT-BODY-SMOKE. Durable artifact `emit/host_emit_body_fragment.ssot.txt`. PARTIAL: String vs fixed C char buf (not dialect ownership). |
| `SystemsLean/CompilePath.lean` | SLAKE_COMPILE_PATH_V1 / HOST-COMPILE-PATH | **OK** + **intentional PARTIAL** | P3: unit bar = `unitCompileReady` = extractOkFs + gradeSurfaceOk (closed Mult canary, not per-host node walk); program bar = `programCompileReady` = IrProgram.isWellTyped (sibling API; EMPTY-PROGRAM-FAIL-CLOSED). Empty host OK != empty program OK. COMPILE-PATH-SMOKE. PARTIAL: host Bool readiness vs freestanding FS unit compile; V0 structure shell remains. |
| `SystemsLean/JoinMap.lean` | SLAKE_JOIN_MAP_V0 / HOST-JOIN-MAP | **OK** + **intentional PARTIAL** | P4: `joinUnitCompileReady` = unitCompileReady && joinAlgContractOk; `joinProgramCompileReady` = programCompileReady && joinAlgContractOk (sibling; empty host OK != empty program OK). Dual cite read-only (Idris/Lean ConsumeToken paths). JOIN-MAP-SMOKE. PARTIAL: joinAlgContractOk is surface-level constant canary (not FS dual walk; not formal full bridge theorems; classic Lean still cannot enforce MULT-1). |
| `SystemsLean/SelfHost.lean` | SLAKE_SELF_HOST_V0 / HOST-SELF-HOST | **OK** + **intentional PARTIAL** | P5: `selfHostUnitReady` = joinUnitCompileReady && hostSurfaceOk; `selfHostProgramReady` = joinProgramCompileReady && hostSurfaceOk (sibling; empty host OK != empty program OK). Package/module path + stage-id surface canary. Verdict inventory layers joinReady / pure unitReady (CompilePath) / hostSurface (JoinMap pattern; not join-pre-folded unit field). SELF-HOST-SMOKE. PARTIAL: direction readiness only -- not freestanding product self-host; not residual free; classic elaborator residual remains; does not unlock llvm. |
| `SystemsLean/SurfaceMatrix.lean` | SLAKE_SURFACE_MATRIX_V0 / HOST-SURFACE-MATRIX | **OK** + **intentional PARTIAL** | P7: `matrixUnitReady` = selfHostUnitReady && matrixSurfaceOk; `matrixProgramReady` sibling; dualCiteOk three JOIN-ALG examples (ConsumeToken + ErasedIndex + UnrestrictedShare); host rows present-partial; open rows (syntax, full elaborator, freestanding self-host, llvm, PROVABLY, full Idris/Lean parity) stay open. Verdict layers selfHostUnit / pure unitReady / matrixSurface. SURFACE-MATRIX-SMOKE. Inventory prose `surface-matrix.md`. PARTIAL: inventory + progressive gate only -- not superset complete; not residual free. |
| `SystemsLean/KernelMult.lean` | SLAKE_SELF_HOST_KERNEL_MULT_V0 / SELF-HOST-KERNEL-MULT | **OK** + **intentional PARTIAL** | SH1: `lowerMultKernel` builds 3-node ordered IR (MULT-0/1/OMEGA with kind pairing); `multKernelReady` = programCompileReady + gradeSurfaceOk; KERNEL-MULT-SMOKE. Acceptance `self-host.md` (SH0). PARTIAL: Mult kernel IR fixture only -- not full product module emit; not self-host complete; does not unlock llvm. Host structural model, not AI model. Host-owned Mult C text is SH2 (`EmitMult`); closed-loop parity is SH3 (`ParityMult`). |
| `SystemsLean/EmitMult.lean` | HOST-EMIT-MULT / SLAKE_SELF_HOST_EMIT_MULT_V0 | **OK** + **intentional PARTIAL** | SH2: `multHeaderFragment` / `multBodyFragment` host-owned Mult freestanding C text from Mult.name; `emitMultReady` honesty; EMIT-MULT-SMOKE / HOST-EMIT-MULT-SMOKE. Durable artifact `emit/host_emit_mult.ssot.txt`. Bash `slake-emit-freestanding-c.sh` is NON-SSOT (reads/embeds MULT_C_HEADER / MULT_C_BODY). No EMIT_MULT_V0 residual C stage. PARTIAL: Mult text SSoT only -- not full product module emit; not self-host complete. Closed-loop Mult contracts are SH3 (`ParityMult`). |
| `SystemsLean/ParityMult.lean` | HOST-PARITY-MULT / SLAKE_SELF_HOST_PARITY_MULT_V0 | **OK** + **intentional PARTIAL** | SH3: `multParityReady` = multKernelReady && emitMultReady && gradeParityOk; gradeParityOk covers Mult.name / isValid / ofNat? / isValidTag / enum tags; PARITY-MULT-SMOKE / HOST-PARITY-MULT-SMOKE. Product Mult behavioral parity in `smoke/slake_behavioral_probe.c` (is_valid / is_known / name / enum tags). PARTIAL: Mult grades closed loop only -- SH4 Linear kernel is KernelLinear; not self-host complete; host String/Bool vs C int/const char* remains representation PARTIAL. |
| `SystemsLean/KernelLinear.lean` | SLAKE_SELF_HOST_KERNEL_LINEAR_V0 / SELF-HOST-KERNEL-LINEAR / HOST-KERNEL-LINEAR | **OK** + **intentional PARTIAL** | SH4 start: `lowerLinearKernel` builds 1-node ordered IR (LINEAR/MULT-1); `linearHostPathReady` HostCompose mint/consume exact-once path; `linearKernelReady` = programCompileReady + linearHostPathReady + gradeSurfaceOk + surface; KERNEL-LINEAR-SMOKE. Product API cites only (`slake_linear_consume`, CONSUME_TOKEN_HOST_V0); no new EMIT_* C stage. PARTIAL: Linear kernel IR + host compose path only -- not full Linear product C text SSoT; not program/compose/real-codegen full ladder close; freestanding path parity is ParityLinear; SH5 compose is SelfApply. |
| `SystemsLean/ParityLinear.lean` | HOST-PARITY-LINEAR / SELF-HOST-PARITY-LINEAR / SLAKE_SELF_HOST_PARITY_LINEAR_V0 | **OK** + **intentional PARTIAL** | Mult+Linear freestanding Linear path parity: `linearContractParityOk` = linearKernelReady && linearHostPathReady (re-assert) && multParityReady && productApiSurfaceOk (all eight frozen APIs incl. slake_consume_token_consume / is_live); `linearParityReady`; `multLinearParityReady` greppable Mult+Linear joint name -- Mult already folded into linearContractParityOk so equivalent to linearParityReady under current defs (not a stronger gate); PARITY-LINEAR-SMOKE / HOST-PARITY-LINEAR-SMOKE. Product Linear / CONSUME_TOKEN behavioral labels in `smoke/slake_behavioral_probe.c` (init/live/consume + mint/consume/is_live). PARTIAL: Linear freestanding path honesty only -- Mult grades already SH3; no EmitLinear residual C stage; host String/Bool vs C int remains representation PARTIAL; not freestanding product self-host complete. |
| `SystemsLean/KernelTypes.lean` | SLAKE_SELF_HOST_KERNEL_TYPES_V0 / SELF-HOST-KERNEL-TYPES / HOST-KERNEL-TYPES | **OK** + **intentional PARTIAL** | SH4 growth: `lowerTypesKernel` builds 3-node ordered IR (ERASED/LINEAR/VALUE kind/mult pairing); `typesProgramPathReady` EMPTY-PROGRAM-FAIL-CLOSED + foldWellTyped count-3; `typesKernelReady` = programCompileReady + program path + gradeSurfaceOk + surface + unknown-kind / kind-mult rejects; KERNEL-TYPES-SMOKE. Product API cites only (`TYPED_IR_V0`, `slake_ir_node`); no new EMIT_* C stage. PARTIAL: Types kernel IR + program-path honesty only -- freestanding path parity is ParityTypes; not full Types product C text SSoT; not program/compose/real-codegen full ladder close; SH5 compose is SelfApply. |
| `SystemsLean/ParityTypes.lean` | HOST-PARITY-TYPES / SELF-HOST-PARITY-TYPES / SLAKE_SELF_HOST_PARITY_TYPES_V0 | **OK** + **intentional PARTIAL** | Mult+Linear+Types freestanding Types path parity: `typesContractParityOk` = typesKernelReady && typesProgramPathReady (re-assert) && kindMultMismatchRejected && linearParityReady && productApiSurfaceOk (TYPED_IR_V0 + slake_ir_node + init + is_well_typed + check_fail_closed); `typesParityReady`; `multLinearTypesParityReady` greppable Mult+Linear+Types joint name -- Mult+Linear already folded into typesContractParityOk so equivalent to typesParityReady under current defs (not a stronger gate); PARITY-TYPES-SMOKE / HOST-PARITY-TYPES-SMOKE. Product TYPED_IR / slake_ir_node behavioral labels in `smoke/slake_behavioral_probe.c`. PARTIAL: Types freestanding path honesty only -- Mult grades already SH3; Mult+Linear Linear path already HOST-PARITY-LINEAR; no EmitTypes residual C stage; host String/Bool vs C int remains representation PARTIAL; not freestanding product self-host complete. |
| `SystemsLean/KernelProgram.lean` | SLAKE_SELF_HOST_KERNEL_PROGRAM_V0 / SELF-HOST-KERNEL-PROGRAM / HOST-KERNEL-PROGRAM | **OK** + **intentional PARTIAL** | SH4 remainder: `lowerProgramKernel` builds 3-node ordered IR; `programPathReady` EMPTY-PROGRAM-FAIL-CLOSED + foldWellTyped + push; `programGraphPathReady` IrGraph edges + EMPTY-GRAPH-OK; `programComposePathReady` HostCompose mult handles + edges; `programKernelReady` composes real checks; KERNEL-PROGRAM-SMOKE. Product API cites only (`IR_PROGRAM_V0`, `IR_GRAPH_EDGES_V0`, `HOST_COMPOSE_V0`, `slake_ir_program` / `slake_ir_graph` / `slake_host_compose`); no new EMIT_* C stage. PARTIAL: program/graph/compose host kernel only -- freestanding path parity is ParityProgram; not freestanding product self-host complete; SH4 codegen compose is KernelEmit; SH5 compose is SelfApply. |
| `SystemsLean/ParityProgram.lean` | HOST-PARITY-PROGRAM / SELF-HOST-PARITY-PROGRAM / SLAKE_SELF_HOST_PARITY_PROGRAM_V0 | **OK** + **intentional PARTIAL** | Mult+Linear+Types+Program freestanding Program path parity: `programContractParityOk` = programKernelReady && programPathReady / programGraphPathReady / programComposePathReady (re-assert) && typesParityReady && productApiSurfaceOk (IR_PROGRAM_V0 + IR_GRAPH_EDGES_V0 + HOST_COMPOSE_V0 + slake_ir_program_* / slake_ir_graph_* / slake_host_compose_* helpers); `programParityReady`; `multLinearTypesProgramParityReady` greppable Mult+Linear+Types+Program joint name -- Mult+Linear+Types already folded into programContractParityOk so equivalent to programParityReady under current defs (not a stronger gate); PARITY-PROGRAM-SMOKE / HOST-PARITY-PROGRAM-SMOKE. Product IR_PROGRAM / IR_GRAPH / HOST_COMPOSE behavioral labels in `smoke/slake_behavioral_probe.c`. PARTIAL: Program freestanding path honesty only -- Mult grades already SH3; Mult+Linear Linear path already HOST-PARITY-LINEAR; Mult+Linear+Types Types path already HOST-PARITY-TYPES; no EmitProgram residual C stage; host String/Bool vs C int remains representation PARTIAL; not freestanding product self-host complete. |
| `SystemsLean/KernelEmit.lean` | SLAKE_SELF_HOST_KERNEL_EMIT_V0 / SELF-HOST-KERNEL-EMIT / HOST-KERNEL-EMIT | **OK** + **intentional PARTIAL** | SH4 freestanding codegen host honesty: `lowerEmitCompose` program kernel HostCompose + mint/mark; `emitPlanPathReady` / `emitApplyPathReady` / `emitBodyPathReady` real plan/apply/body Bools over that surface; `emitKernelReady` = programKernelReady && plan/apply/body paths && emitMultReady && surface; KERNEL-EMIT-SMOKE. Uses HOST-EMIT-SSOT fragment + HOST-EMIT-MULT Mult text; product EMIT_PLAN/APPLY/BODY cites only; **no new EMIT_* C residual stage**. PARTIAL: host codegen readiness over program kernel only -- freestanding path parity is ParityEmit; not full product module emit mill; not residual free; not freestanding product self-host complete; SH5 compose is SelfApply. |
| `SystemsLean/ParityEmit.lean` | HOST-PARITY-EMIT / SELF-HOST-PARITY-EMIT / SLAKE_SELF_HOST_PARITY_EMIT_V0 | **OK** + **intentional PARTIAL** | Mult+Linear+Types+Program+Emit freestanding Emit path parity: `emitContractParityOk` = emitKernelReady && emitPlanPathReady / emitApplyPathReady / emitBodyPathReady (re-assert) && emitMultReady (re-assert) && programParityReady && productApiSurfaceOk (EMIT_PLAN_V0 + EMIT_APPLY_V0 + EMIT_BODY_V0 + HOST-EMIT-SSOT + HOST-EMIT-MULT + slake_emit_plan_* / slake_emit_apply_* / slake_emit_body_* helpers); `emitParityReady`; `multLinearTypesProgramEmitParityReady` greppable Mult+Linear+Types+Program+Emit joint name -- Mult+Linear+Types+Program already folded into emitContractParityOk so equivalent to emitParityReady under current defs (not a stronger gate); PARITY-EMIT-SMOKE / HOST-PARITY-EMIT-SMOKE. Product EMIT_PLAN / EMIT_APPLY / EMIT_BODY behavioral labels in `smoke/slake_behavioral_probe.c`. PARTIAL: Emit freestanding path honesty only -- Mult grades already SH3; Mult+Linear Linear path already HOST-PARITY-LINEAR; Mult+Linear+Types Types path already HOST-PARITY-TYPES; Mult+Linear+Types+Program Program path already HOST-PARITY-PROGRAM; no new EMIT_* residual C stage; host String/Bool vs C int remains representation PARTIAL; not freestanding product self-host complete; SH5 compose is SelfApply. |
| `SystemsLean/SelfApply.lean` | SLAKE_SELF_HOST_SELF_APPLY_V0 / HOST-SELF-APPLY / SELF-HOST-SELF-APPLY | **OK** + **intentional PARTIAL** | SH5 partial: `selfApplyReady` = kernelRebuildsKernel && surface; `kernelRebuildsKernel` = multParityReady && linearKernelReady && typesKernelReady && programKernelReady && emitKernelReady; SELF-APPLY-SMOKE / HOST-SELF-APPLY-SMOKE. Host structural kernel-rebuilds-kernel (Mult closed loop + Linear + Types + Program + Emit kernel readiness all true). PARTIAL: not freestanding product self-host complete; not residual free; not PROVABLY; freestanding deepen is SelfApplyFs; SH6 llvm held (documented via LlvmHold). |
| `SystemsLean/SelfApplyFs.lean` | SLAKE_SELF_HOST_SELF_APPLY_FS_V0 / HOST-SELF-APPLY-FS / SELF-HOST-SELF-APPLY-FS | **OK** + **intentional PARTIAL** | SH5 freestanding deepen partial: `freestandingExtractPathReady` empty/unminted/lowerEmitCompose extractOkFs (RUNTIME-FS / EMIT-BOUNDARY); `freestandingBodyPathReady` bodyOk + bodyIsValid + RUNTIME-FS marker + KernelEmit.expectedBodyFragment + emitMultReady (HOST-EMIT-SSOT / EMIT_BODY_V0; no new EMIT_* C stage); `freestandingParityLadderReady` = ParityEmit.multLinearTypesProgramEmitParityReady (Mult..Emit freestanding parity compose); dual greppable `freestandingEmitParityReady` = ParityEmit.emitParityReady (equivalent under ParityEmit folds -- not a stronger gate); surface cites HOST-PARITY-EMIT / SLAKE_SELF_HOST_PARITY_EMIT_V0; `freestandingSelfApplyReady` = selfApplyReady && freestandingSelfApplyPathReady && freestandingParityLadderReady && surface && !freestandingProductSelfHostComplete; `freestandingProductSelfHostComplete` = false; selfApplyFsDoesNotComplete; SELF-APPLY-FS-SMOKE / HOST-SELF-APPLY-FS-SMOKE. PARTIAL: freestanding extract/body path + Mult..Emit parity ladder compose + host self-apply only -- not freestanding product self-host complete; not residual free; not PROVABLY; SH6 still held. |
| `SystemsLean/LlvmHold.lean` | SLAKE_SELF_HOST_LLVM_HOLD_V0 / HOST-LLVM-HOLD / SELF-HOST-LLVM-HOLD / HOST-PROVABLY-HOLD | **OK** + **intentional PARTIAL** (hold) | SH6 held (documented): `llvmHoldReady` / `sh6HoldReady` = surface + holdHonestyOk + selfApplyReady + selfApplyDoesNotUnlockLlvm; `llvmUnlocked` / `provablyUnlocked` / `freestandingProductSelfHostComplete` = false; LLVM-HOLD-SMOKE / HOST-LLVM-HOLD-SMOKE. Hold gate active -- **not** unlock; not residual-open llvm mill; not PROVABLY; out/llvm-ir still deferred. PARTIAL: hold honesty only -- true freestanding product self-host + real ccomp still required before any unlock. |
| `SystemsLean/InventoryClose.lean` | SLAKE_SELF_HOST_INVENTORY_CLOSE_V0 / HOST-INVENTORY-CLOSE / SELF-HOST-INVENTORY-CLOSE | **OK** + **intentional PARTIAL** (close readiness) | Host inventory close after Mult..LlvmHold: `inventoryCloseReady` = freestandingSelfApplyReady && llvmHoldReady && inventoryCloseSurfaceOk && inventoryPartialCarryHonest && !SelfApplyFs.freestandingProductSelfHostComplete && !llvmUnlocked && !provablyUnlocked; `residualFreeClaimed` / `productSelfHostCompleteClaimed` = false; `inventoryCloseDoesNotMeanResidualFree`; surface cites host-partial-inventory.md + CLOSABLE-MISS-COUNT-0 + intentional PARTIAL + HOST-SELF-APPLY-FS / HOST-LLVM-HOLD; INVENTORY-CLOSE-SMOKE / HOST-INVENTORY-CLOSE-SMOKE. PARTIAL: inventory close readiness only -- **not** residual free; **not** freestanding product self-host complete; **not** llvm unlock; **not** PROVABLY; intentional PARTIAL carry remains. |
| `SystemsLean/ProductPath.lean` | SLAKE_SELF_HOST_PRODUCT_PATH_V0 / HOST-PRODUCT-PATH / SELF-HOST-PRODUCT-PATH | **OK** + **intentional PARTIAL** (path readiness) | Freestanding product path after inventory close: `freestandingUnitProductPathReady` empty/unminted/lowerEmitCompose unitCompileReady + extractOkFs (RUNTIME-FS / HOST-COMPILE-PATH); sibling `freestandingProgramProductPathReady` empty program fail-closed + lowerProgramKernel well-typed; `productPathReady` = inventoryCloseReady && unit path && program path && surface && !residual free claimed && !product complete claimed && !SelfApplyFs complete && !llvm unlock && !provably unlock; `productPathDoesNotComplete` / `productPathDoesNotMeanResidualFree`; PRODUCT-PATH-SMOKE / HOST-PRODUCT-PATH-SMOKE. PARTIAL: product path readiness only -- **not** residual free; **not** freestanding product self-host complete; **not** llvm unlock; **not** PROVABLY; intentional PARTIAL carry remains. |
| `SystemsLean.lean` root | import shell | **OK** | Imports Mult..ProductPath (all 31 modules including ParityLinear + ParityTypes + ParityProgram + ParityEmit + SelfApplyFs + LlvmHold + InventoryClose + ProductPath). Presence requires every import line. |

**Phantom modules:** none. No advertised host file without a real path.
**Presence RED:** none (live `just systems-host` green at inventory time).

---

## Closable misses (P1.2)

| Id | Miss | Status |
|----|------|--------|
| (none) | -- | **CLOSABLE-MISS-COUNT-0** |

No missing def, broken import, residual/API advertised helper without Lean def,
or presence RED found. Do not invent deepen-for-deepen.

Companion lag closed in the same slice (not a Lean miss): `mult.md` points at
`SystemsLean/Mult.lean`; `linear.md` records JOIN-MAP / HOST-JOIN-MAP +
SELF-HOST-KERNEL-LINEAR + HOST-PARITY-LINEAR + HOST-SELF-APPLY + HOST-LLVM-HOLD
status; `types.md` records HOST-KERNEL-TYPES + HOST-PARITY-TYPES +
HOST-KERNEL-PROGRAM + HOST-PARITY-PROGRAM + KernelEmit + HOST-PARITY-EMIT markers;
README / inventory / presence Mult..ProductPath after SH0..SH6 hold +
HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH + HOST-PARITY-TYPES + HOST-PARITY-PROGRAM +
HOST-PARITY-EMIT;
`surface-matrix.md` and `self-host.md` match SurfaceMatrix + KernelMult + EmitMult +
ParityMult + KernelLinear + ParityLinear + KernelTypes + ParityTypes + KernelProgram +
ParityProgram + KernelEmit + ParityEmit + SelfApply + SelfApplyFs + LlvmHold +
InventoryClose + ProductPath stage ids (llvm/PROVABLY rows stay open; residual free
unclaimed).

---

## Intentional PARTIAL list (carry after P2 HOST-EMIT-SSOT + SH2 HOST-EMIT-MULT + SH3 HOST-PARITY-MULT + SH4 KERNEL-LINEAR start + HOST-PARITY-LINEAR Mult+Linear path + SH4 KERNEL-TYPES growth + HOST-PARITY-TYPES Mult+Linear+Types path + SH4 KERNEL-PROGRAM growth + HOST-PARITY-PROGRAM Mult+Linear+Types+Program path + SH4 KERNEL-EMIT codegen + HOST-PARITY-EMIT Mult+Linear+Types+Program+Emit path + SH5 SELF-APPLY partial + SH5 SELF-APPLY-FS freestanding deepen + SH6 LLVM-HOLD documented + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH + P5 HOST-SELF-HOST + P7 HOST-SURFACE-MATRIX)

P2 closed **fragment dialect SSoT** (Lean + durable SSOT file; bash NON-SSOT).
SH2 closed **Mult product C text SSoT** (Lean EmitMult + durable Mult SSOT; bash NON-SSOT).
SH3 closed **Mult closed-loop host + product Mult contracts** (ParityMult + probe Mult checks).
SH4 start closed **Linear kernel IR + HostCompose mint/consume path** (KernelLinear).
HOST-PARITY-LINEAR closed **Linear freestanding path honesty Mult+Linear** (ParityLinear + probe labels).
SH4 Types growth closed **Types / typed IR kernel + program-path fold** (KernelTypes).
HOST-PARITY-TYPES closed **Types freestanding path honesty Mult+Linear+Types** (ParityTypes + probe labels).
SH4 Program growth closed **ordered IR program + graph edges + HostCompose path**
(KernelProgram).
HOST-PARITY-PROGRAM closed **Program freestanding path honesty Mult+Linear+Types+Program**
(ParityProgram + probe labels).
SH4 Emit codegen host honesty closed **plan/apply/body path over program kernel +
Mult emit** (KernelEmit; product wire bulk still frozen; no new EMIT_* C stage).
HOST-PARITY-EMIT closed **Emit freestanding path honesty Mult+Linear+Types+Program+Emit**
(ParityEmit + probe labels).
SH5 partial closed **host self-application readiness** (SelfApply compose Mult closed
loop + Linear + Types + Program + Emit kernel; structural kernel-rebuilds-kernel only
-- not freestanding product self-host complete).
SH6 held (documented) closed **host hold gate** (LlvmHold: llvmHoldReady true with
unlock/complete flags false; not llvm unlock; not PROVABLY; not residual mill open).
HOST-INVENTORY-CLOSE closed **host inventory close readiness** (InventoryClose:
inventoryCloseReady true with residualFreeClaimed / product complete / llvm unlock
false; intentional PARTIAL carry; not residual free; not product complete).
HOST-PRODUCT-PATH closed **freestanding product path readiness** (ProductPath:
productPathReady true with residualFreeClaimed / product complete / llvm unlock
false; unit/program CompilePath honesty; not residual free; not product complete).
P4 closed **host join map into compile path** (JoinMap composition; duals cite only).
P5 closed **host self-host direction readiness** (SelfHost composition; not self-host complete).
P7 closed **host surface matrix inventory + progressive gate** (SurfaceMatrix composition;
not full parity / superset complete).
Do **not** "fix" the rows below as host deepen; they are not missing defs.

1. **List / String vs C fixed arrays** -- IrProgram nodes, IrGraph edges, EmitApply
   tags, EmitBody buf: host uses List/String under the same capacity constants;
   C uses fixed arrays (`SLAKE_IR_PROGRAM_CAP` 8, `SLAKE_IR_EDGE_MAX` 16,
   `SLAKE_EMIT_APPLY_CAP` 32, `SLAKE_EMIT_BODY_CAP` 256). Fragment *text dialect*
   is HOST-EMIT-SSOT; Mult product *text* is HOST-EMIT-MULT; buffer representation
   remains PARTIAL.
2. **No null pointers on host** -- C APIs fail on null out/hc; host has no
   pointer layer (typed values always present).
3. **No exact C return-code tables** -- C uses 0 / -1 / -2; host uses result
   inductives (PushResult, MintResult, ...) and Bool checks.
4. **Extract MULT-1 thinning** -- `Extract.checkFailClosed` / `extractOk` do not
   require live token for MULT-1; fuller path is `HostCompose.multPreScan`
   (intentional two-tier host honesty, not a missing def).
5. **Linear MULT-1 elaborator gap** -- classic Lean cannot enforce exact-once;
   `Linear.Token` / mkToken / consume are axioms; HostCompose.LinearHost is a
   live-flag model for fail-closed checks only.
6. **Runtime claim tag collapse on wire** -- C `slake_runtime_class` collapses
   classic/edge; host keeps three RuntimeClaim constructors for honesty.
7. **Program / graph check thinning** -- IrProgram / IrGraph checkFailClosed =
   well-typed only; mult/token pre-scan is HostCompose (matches emit layering).
8. **Not freestanding residual free / not PROVABLY / not full CFG-SSA** -- all
   modules; never forge.
9. **Full C API ladder still frozen wire** -- Mult..HostCompose C APIs remain
   generator-owned history except Mult product text (HOST-EMIT-MULT) and EMIT_BODY
   fragment dialect (HOST-EMIT-SSOT); not a rewrite of the whole emit surface into Lean.
10. **Join map surface canary** -- `joinAlgContractOk` is constant dual-cite +
    algorithm id honesty, not a filesystem walk of dual trees and not formal
    dual-bridge theorems inventing duals under `src/idris2/` / `src/lean4/`.
11. **Self-host surface canary** -- `hostSurfaceOk` is constant stage-id + path
    cite honesty, not freestanding product self-host (Slake compiling Systems
    Lean units to freestanding C without classic elaborator). llvm remains
    deferred (SH6 held documented via LlvmHold; SH5 partial does not unlock
    llvm as done).
12. **Surface matrix inventory gate** -- `matrixSurfaceOk` is constant stage-id +
    dual-cite + row-status honesty; progressive host coverage only. Open rows
    (full syntax, full elaborator, freestanding self-host, llvm, PROVABLY, full
    Idris/Lean parity) stay **open**. Not day-one superset complete.
13. **Mult closed loop is Mult grades only** -- ParityMult + probe close Mult
    name/is_valid/is_known/tag contracts; SH4 start is KernelLinear (Linear IR
    + HostCompose path); SH4 Types growth is KernelTypes; SH4 Program growth is
    KernelProgram; SH4 Emit codegen is KernelEmit. Not bit-identical host String
    vs C const char* representation.
14. **Linear kernel is IR + host path only** -- KernelLinear does not own Linear
    product C text SSoT (no EmitLinear residual stage); product Linear ABI
    remains frozen wire + existing probe; no new EMIT_* C mill.
14b. **Linear freestanding path parity is path honesty only** -- ParityLinear
    composes KernelLinear + Mult closed loop + product API canaries; probe
    labels existing linear_token / CONSUME_TOKEN path; not EmitLinear residual;
    not freestanding product self-host complete; host String/Bool vs C int
    remains representation PARTIAL.
15. **Types kernel is IR + program path only** -- KernelTypes does not own Types
    product C text SSoT (no EmitTypes residual stage); product Types ABI
    remains frozen wire; no new EMIT_* C mill.
16. **Program kernel is IR + graph + compose path only** -- KernelProgram does
    not own program/graph/compose product C text SSoT (no new EmitProgram /
    EmitGraph residual stage); product program/graph/compose ABI remains frozen
    wire; freestanding path parity is ParityProgram; no new EMIT_* C mill.
16b. **Program freestanding path parity is path honesty only** -- ParityProgram
    composes KernelProgram + Mult+Linear+Types freestanding path + product API
    canaries; probe labels existing IR_PROGRAM / IR_GRAPH / HOST_COMPOSE path;
    not EmitProgram residual; not freestanding product self-host complete; host
    String/Bool vs C int remains representation PARTIAL.
17. **Emit kernel is host plan/apply/body readiness only** -- KernelEmit composes
    existing EmitPlan/EmitApply/EmitBody + Mult emit over program kernel; does
    not mint a new EMIT_* C residual stage; product wire bulk still frozen at
    EMIT_BODY_V0 except HOST-EMIT-SSOT + HOST-EMIT-MULT; freestanding path parity
    is ParityEmit; not residual free product emit mill; not freestanding product
    self-host complete.
17b. **Emit freestanding path parity is path honesty only** -- ParityEmit
    composes KernelEmit + Mult+Linear+Types+Program freestanding path + product
    API canaries; probe labels existing EMIT_PLAN / EMIT_APPLY / EMIT_BODY path;
    no new EMIT_* residual C stage; not freestanding product self-host complete;
    host String/Bool vs C int remains representation PARTIAL.
18. **Self-apply is host structural only** -- SelfApply composes Mult closed loop
    + Linear + Types + Program + Emit kernel readiness; kernelRebuildsKernel means
    host lowers those kernel fixtures with readiness true -- not product
    freestanding C rebuilding full Slake; not residual free; SH6 held (documented).
19. **SelfApplyFs is freestanding extract/body path + Mult..Emit parity compose
    honesty only** -- SelfApplyFs composes freestandingExtractPathReady
    (RUNTIME-FS extractOkFs on empty / unminted / lowerEmitCompose) +
    freestandingBodyPathReady (HOST-EMIT-SSOT body + emitMultReady) +
    freestandingParityLadderReady (ParityEmit Mult..Emit freestanding path;
    freestandingEmitParityReady dual alias equivalent under folds -- not a
    stronger gate) + SelfApply.selfApplyReady; freestandingSelfApplyReady true
    with freestandingProductSelfHostComplete false; not product freestanding
    self-host complete; not residual free; does not unlock llvm; SH6 held
    (documented).
20. **LlvmHold is hold honesty only** -- llvmHoldReady true with llvmUnlocked /
    provablyUnlocked / freestandingProductSelfHostComplete false; does not
    open out/llvm-ir product path or PROVABLY residual mill; P6 stays hold.
21. **InventoryClose is inventory close readiness only** -- inventoryCloseReady
    true with residualFreeClaimed / productSelfHostCompleteClaimed false and
    SelfApplyFs / LlvmHold complete+unlock flags false; composes freestanding
    self-apply + llvm hold + CLOSABLE-MISS-COUNT-0 surface; does not claim
    residual free, freestanding product self-host complete, llvm unlock, or
    PROVABLY; intentional PARTIAL carry remains.
22. **ProductPath is freestanding product path readiness only** --
    productPathReady true with residualFreeClaimed /
    productSelfHostCompleteClaimed false and SelfApplyFs complete + LlvmHold
    unlock flags false; composes inventoryCloseReady + unitCompileReady /
    extractOkFs path + programCompileReady path + surface; does not claim
    residual free, freestanding product self-host complete, llvm unlock, or
    PROVABLY; intentional PARTIAL carry remains.

---

## Host contracts P1.3 (grades / linear / erasure / extract / join / self-host / matrix / Mult emit / Mult parity / Linear kernel / Linear freestanding path parity / Types kernel / Types freestanding path parity / Program kernel / Program freestanding path parity / Emit kernel / Emit freestanding path parity / SelfApply / SelfApplyFs / LlvmHold / InventoryClose / ProductPath)

| Contract | Where | Executable? | Gap this slice? |
|----------|-------|-------------|-----------------|
| Grades MULT-0/1/OMEGA + FAIL-CLOSED-UNKNOWN-GRADE | Mult.lean | `isValid` / `ofNat?` / `isValidTag` (Bool/Option) | No -- closed inductive + raw-tag reject present |
| LINEAR-EXACT-ONCE / JOIN-ALG ConsumeToken | Linear.lean axioms + HostCompose mint/consume + JoinMap cite + KernelLinear path | HostCompose Bool + HOST-SMOKE + KERNEL-LINEAR-SMOKE; Linear axioms only; JoinMap joinAlgContractOk surface | No -- axioms required for classic elaborator; KernelLinear composes IR + host path |
| ERASE-RULE-MULT-0 / ERASE-NO-RUNTIME | Erasure.lean | mark / isRuntimeAbsent / markForGrade? / checkFailClosed | No |
| EMIT-BOUNDARY / RUNTIME-FS extract | Extract.lean + HostCompose | extractOk paths + extractOkFs + HOST-SMOKE | No; Extract MULT-1 thinning intentional PARTIAL |
| HOST-JOIN-MAP / SLAKE_JOIN_MAP_V0 | JoinMap.lean | joinUnitCompileReady / joinProgramCompileReady + JOIN-MAP-SMOKE | No -- surface canary + composition; not formal dual theorems |
| HOST-SELF-HOST / SLAKE_SELF_HOST_V0 | SelfHost.lean | selfHostUnitReady / selfHostProgramReady + SELF-HOST-SMOKE | No -- direction readiness only; not freestanding self-host complete |
| HOST-SURFACE-MATRIX / SLAKE_SURFACE_MATRIX_V0 | SurfaceMatrix.lean + surface-matrix.md | matrixUnitReady / matrixProgramReady + SURFACE-MATRIX-SMOKE | No -- progressive inventory gate; open parity rows stay open |
| SELF-HOST-KERNEL-MULT / SLAKE_SELF_HOST_KERNEL_MULT_V0 | KernelMult.lean + self-host.md | lowerMultKernel / multKernelReady + KERNEL-MULT-SMOKE | No -- Mult IR fixture; closed-loop is ParityMult |
| HOST-EMIT-MULT / SLAKE_SELF_HOST_EMIT_MULT_V0 | EmitMult.lean + host_emit_mult.ssot.txt | multHeaderFragment / multBodyFragment / emitMultReady + EMIT-MULT-SMOKE | No -- Mult text SSoT; closed-loop is ParityMult |
| HOST-PARITY-MULT / SLAKE_SELF_HOST_PARITY_MULT_V0 | ParityMult.lean + smoke probe | multParityReady / gradeParityOk + PARITY-MULT-SMOKE; product Mult name/is_known/tag | No -- Mult grades only; SH4 Linear kernel is KernelLinear |
| SELF-HOST-KERNEL-LINEAR / HOST-KERNEL-LINEAR / SLAKE_SELF_HOST_KERNEL_LINEAR_V0 | KernelLinear.lean + self-host.md | lowerLinearKernel / linearHostPathReady / linearKernelReady + KERNEL-LINEAR-SMOKE | No -- Linear IR + HostCompose path; freestanding path parity is ParityLinear; SH5 compose is SelfApply |
| HOST-PARITY-LINEAR / SELF-HOST-PARITY-LINEAR / SLAKE_SELF_HOST_PARITY_LINEAR_V0 | ParityLinear.lean + smoke probe | linearParityReady / linearContractParityOk / multLinearParityReady + PARITY-LINEAR-SMOKE; product linear_token + CONSUME_TOKEN labels | No -- Linear freestanding path honesty only; Mult grades already SH3; not freestanding product self-host complete |
| SELF-HOST-KERNEL-TYPES / HOST-KERNEL-TYPES / SLAKE_SELF_HOST_KERNEL_TYPES_V0 | KernelTypes.lean + self-host.md | lowerTypesKernel / typesProgramPathReady / typesKernelReady + KERNEL-TYPES-SMOKE | No -- Types IR + program path; freestanding path parity is ParityTypes; SH5 compose is SelfApply |
| HOST-PARITY-TYPES / SELF-HOST-PARITY-TYPES / SLAKE_SELF_HOST_PARITY_TYPES_V0 | ParityTypes.lean + smoke probe | typesParityReady / typesContractParityOk / multLinearTypesParityReady + PARITY-TYPES-SMOKE; product TYPED_IR / slake_ir_node labels | No -- Types freestanding path honesty only; Mult+Linear already HOST-PARITY-LINEAR; not freestanding product self-host complete |
| SELF-HOST-KERNEL-PROGRAM / HOST-KERNEL-PROGRAM / SLAKE_SELF_HOST_KERNEL_PROGRAM_V0 | KernelProgram.lean + self-host.md | lowerProgramKernel / programPathReady / programGraphPathReady / programComposePathReady / programKernelReady + KERNEL-PROGRAM-SMOKE | No -- program/graph/compose host kernel; freestanding path parity is ParityProgram; SH4 codegen is KernelEmit; SH5 compose is SelfApply |
| HOST-PARITY-PROGRAM / SELF-HOST-PARITY-PROGRAM / SLAKE_SELF_HOST_PARITY_PROGRAM_V0 | ParityProgram.lean + smoke probe | programParityReady / programContractParityOk / multLinearTypesProgramParityReady + PARITY-PROGRAM-SMOKE; product IR_PROGRAM / IR_GRAPH / HOST_COMPOSE labels | No -- Program freestanding path honesty only; Mult+Linear+Types already HOST-PARITY-TYPES; not freestanding product self-host complete |
| SELF-HOST-KERNEL-EMIT / HOST-KERNEL-EMIT / SLAKE_SELF_HOST_KERNEL_EMIT_V0 | KernelEmit.lean + self-host.md | lowerEmitCompose / emitPlanPathReady / emitApplyPathReady / emitBodyPathReady / emitKernelReady + KERNEL-EMIT-SMOKE | No -- host plan/apply/body + Mult emit over program kernel; freestanding path parity is ParityEmit; no new EMIT_* C stage; not residual free |
| HOST-PARITY-EMIT / SELF-HOST-PARITY-EMIT / SLAKE_SELF_HOST_PARITY_EMIT_V0 | ParityEmit.lean + smoke probe | emitParityReady / emitContractParityOk / multLinearTypesProgramEmitParityReady + PARITY-EMIT-SMOKE; product EMIT_PLAN / EMIT_APPLY / EMIT_BODY labels | No -- Emit freestanding path honesty only; Mult+Linear+Types+Program already HOST-PARITY-PROGRAM; no new EMIT_* C stage; not freestanding product self-host complete |
| HOST-SELF-APPLY / SELF-HOST-SELF-APPLY / SLAKE_SELF_HOST_SELF_APPLY_V0 | SelfApply.lean + self-host.md | selfApplyReady / kernelRebuildsKernel + SELF-APPLY-SMOKE | No -- host structural self-application only; freestanding deepen is SelfApplyFs; not freestanding product self-host complete; SH6 held |
| HOST-SELF-APPLY-FS / SELF-HOST-SELF-APPLY-FS / SLAKE_SELF_HOST_SELF_APPLY_FS_V0 | SelfApplyFs.lean + self-host.md | freestandingExtractPathReady / freestandingBodyPathReady / freestandingParityLadderReady / freestandingEmitParityReady / freestandingSelfApplyReady + SELF-APPLY-FS-SMOKE; freestandingProductSelfHostComplete false | No -- freestanding extract/body path + Mult..Emit parity ladder compose + host self-apply; freestandingParityLadderReady equiv emitParityReady under folds (not stronger gate); not freestanding product self-host complete; SH6 held |
| HOST-LLVM-HOLD / SELF-HOST-LLVM-HOLD / HOST-PROVABLY-HOLD / SLAKE_SELF_HOST_LLVM_HOLD_V0 | LlvmHold.lean + self-host.md | llvmHoldReady / sh6HoldReady + LLVM-HOLD-SMOKE; unlock flags false | No -- hold gate only; not unlock; not PROVABLY; out/llvm-ir still deferred |
| HOST-INVENTORY-CLOSE / SELF-HOST-INVENTORY-CLOSE / SLAKE_SELF_HOST_INVENTORY_CLOSE_V0 | InventoryClose.lean + host-partial-inventory.md + self-host.md | inventoryCloseReady / inventoryPartialCarryHonest / inventoryCloseDoesNotMeanResidualFree + INVENTORY-CLOSE-SMOKE; residualFreeClaimed false | No -- inventory close readiness only; not residual free; not freestanding product self-host complete; not llvm unlock; intentional PARTIAL carry |
| HOST-PRODUCT-PATH / SELF-HOST-PRODUCT-PATH / SLAKE_SELF_HOST_PRODUCT_PATH_V0 | ProductPath.lean + self-host.md + host-partial-inventory.md | productPathReady / freestandingUnitProductPathReady / freestandingProgramProductPathReady / productPathDoesNotComplete / productPathDoesNotMeanResidualFree + PRODUCT-PATH-SMOKE; residualFreeClaimed false | No -- freestanding product path readiness only; not residual free; not freestanding product self-host complete; not llvm unlock; intentional PARTIAL carry |

No new proof mill. No axiom removal theater.

---

## Presence / API table cross-check

| Source | Result |
|--------|--------|
| `nix/systems-host-presence/specs.nix` requiredFiles Mult..ProductPath | All paths exist (incl. ProductPath.lean + InventoryClose.lean + LlvmHold.lean + SelfApplyFs.lean + SelfApply.lean + ParityEmit.lean + KernelEmit.lean + ParityProgram.lean + KernelProgram.lean + ParityTypes.lean + KernelTypes.lean + ParityLinear.lean + KernelLinear.lean + ParityMult.lean + EmitMult.lean + host_emit_mult.ssot.txt + KernelMult + self-host.md) |
| hostSpecs tokens (SYSTEMS_LEAN_HOST, stage ids, smokes on IrGraph/HostCompose/Emit*/CompilePath/JoinMap/SelfHost/SurfaceMatrix/KernelMult/EmitMult/ParityMult/KernelLinear/ParityLinear/KernelTypes/ParityTypes/KernelProgram/ParityProgram/KernelEmit/ParityEmit/SelfApply/SelfApplyFs/LlvmHold/InventoryClose/ProductPath) | Matched in modules |
| extract.md Lean host table helpers | All named defs exist (incl. planOk / applyOk / bodyOk / multPreScan) |
| README lead host table | Same 31 modules; no phantom row |
| SystemsLean.lean imports | Full ladder Mult..ProductPath (incl. ParityLinear + ParityTypes + ParityProgram + ParityEmit + SelfApplyFs + LlvmHold + InventoryClose + ProductPath) |

---

## Non-claims

- Not freestanding residual free
- Not PROVABLY
- Not full product C generation from Lean (only EMIT_BODY fragment dialect SSoT + Mult product text SSoT + Mult IR fixture + Mult closed-loop parity + Linear kernel IR + Linear freestanding path parity Mult+Linear + Types kernel IR + Types freestanding path parity Mult+Linear+Types (ParityTypes / HOST-PARITY-TYPES) + Program kernel IR/graph/compose + Program freestanding path parity Mult+Linear+Types+Program (ParityProgram / HOST-PARITY-PROGRAM) + Emit kernel plan/apply/body host readiness + Emit freestanding path parity Mult+Linear+Types+Program+Emit (ParityEmit / HOST-PARITY-EMIT) + host self-apply compose + freestanding extract/body path deepen + freestanding Mult..Emit parity ladder compose on SelfApplyFs + llvm hold gate + inventory close readiness + freestanding product path readiness)
- Not residual free of shell debt (`check.sh` process-only remains)
- Not freestanding product self-host complete (HOST-SELF-HOST is direction; KernelMult is SH1 IR; EmitMult is SH2 Mult text; ParityMult is SH3 Mult grades only; KernelLinear is SH4 Linear start only; ParityLinear is Linear freestanding path honesty Mult+Linear only; KernelTypes is SH4 Types growth only; ParityTypes is Types freestanding path honesty Mult+Linear+Types only; KernelProgram is SH4 Program growth only; ParityProgram is Program freestanding path honesty Mult+Linear+Types+Program only; KernelEmit is SH4 freestanding codegen host honesty only; ParityEmit is Emit freestanding path honesty Mult+Linear+Types+Program+Emit only; SelfApply is SH5 host structural self-application only; SelfApplyFs is SH5 freestanding extract/body + Mult..Emit parity ladder compose deepen only with freestandingProductSelfHostComplete = false; LlvmHold encodes freestandingProductSelfHostComplete = false; InventoryClose residualFreeClaimed / productSelfHostCompleteClaimed = false; ProductPath residualFreeClaimed / productSelfHostCompleteClaimed = false)
- Not day-one full Idris + Lean parity / not "superset complete" (HOST-SURFACE-MATRIX is progressive inventory)
- Not permission to unlock `out/llvm-ir` (SH6 held documented; SH5 partial and freestanding deepen do not unlock llvm as done; llvmUnlocked = false; InventoryClose / ProductPath do not unlock)
- SH4 partial (KernelLinear + KernelTypes + KernelProgram + KernelEmit) does not close full freestanding product codegen / residual free product emit mill (host plan/apply/body readiness only; product wire bulk still frozen)
- SH5 partial (SelfApply) does not claim freestanding product self-host complete or residual free
- SH5 freestanding deepen (SelfApplyFs) does not claim freestanding product self-host complete or residual free (extract/body path + Mult..Emit parity ladder compose + host self-apply only; freestandingProductSelfHostComplete = false; freestandingParityLadderReady not stronger than emitParityReady under folds)
- SH6 held (LlvmHold) is not residual-open llvm emit mill and not PROVABLY
- HOST-INVENTORY-CLOSE (InventoryClose) is not residual free and not freestanding product self-host complete (inventory close readiness only; intentional PARTIAL carry)
- HOST-PRODUCT-PATH (ProductPath) is not residual free and not freestanding product self-host complete (product path readiness only; unit/program CompilePath honesty over kernel emit compose; intentional PARTIAL carry)
- CLOSABLE-MISS-COUNT-0 is not permission to mint phantom modules
- CompilePath unit bar does not fold programCompileReady (sibling APIs)
- JoinMap unit bar does not fold joinProgramCompileReady (sibling APIs)
- SelfHost unit bar does not fold selfHostProgramReady (sibling APIs)
- SurfaceMatrix unit bar does not fold matrixProgramReady (sibling APIs)
- ProductPath unit path does not fold freestandingProgramProductPathReady alone into residual free (sibling APIs compose into productPathReady without completing self-host)
