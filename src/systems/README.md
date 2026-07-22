# src/systems/ -- freestanding Systems Lean (Slake host)

Synthesis workspace: **minimum** QTT (Quantitative Type Theory) multiplicities **0 / 1 / omega** needed to implement **Slake**, the freestanding Systems Lean compiler.

**Fork:** implement residual lives in `RESIDUAL-systems.md`; paste prompt `doc/fork-systems.md`.
Coordinator steers via `doc/fork-guidance-systems.md` and does not race this tree by default.

## Lead: Lean host (Lake)

**Systems Lean is Lean.** Primary residual is real `.lean` sources under this tree, elaborated with Lake (same offline pin policy as `src/lean4/`: `leanprover/lean4:v4.32.0`, empty remote packages).

| Path | Role |
|------|------|
| `lean-toolchain` | Pin match with `src/lean4` |
| `lakefile.toml` | Package `SystemsLean` (SPDX Unlicense; no remote deps) |
| `lake-manifest.json` | Offline empty packages |
| `SystemsLean.lean` | Package root imports |
| `SystemsLean/Mult.lean` | `SystemsLean.Mult` -- MULT-0 / MULT-1 / MULT-OMEGA closed inductive; typed `isValid` total-true by match; raw-tag FAIL-CLOSED-UNKNOWN-GRADE via `ofNat?` / `isValidTag` |
| `SystemsLean/Linear.lean` | `SystemsLean.Linear` -- JOIN-ALG ConsumeToken-class axioms (classic Lean cannot enforce mult-1) |
| `SystemsLean/Types.lean` | `SystemsLean.Types` -- COMMON-UNIVERSE TypeTag; NodeKind VALUE/LINEAR/ERASED; kind/mult pairing; IrNode well-typed; FAIL-CLOSED-UNKNOWN-KIND on raw kind tags |
| `SystemsLean/IrProgram.lean` | `SystemsLean.IrProgram` -- ordered IR program (node list, cap 8); push / isWellTyped / foldWellTyped; EMPTY-PROGRAM-FAIL-CLOSED |
| `SystemsLean/Erasure.lean` | `SystemsLean.Erasure` -- Erased marker; mark / isRuntimeAbsent; markForGrade? (MULT-0 only else none); ERASE-RULE-MULT-0 / ERASE-NO-RUNTIME; EDGE-PROP / ERASE-PROP honesty |
| `SystemsLean/Extract.lean` | `SystemsLean.Extract` -- RuntimeClaim runtimeFs / runtimeClassic / edgeRuntime; EMIT-BOUNDARY; extractOk / checkFailClosed (PARTIAL FAIL_CLOSED_CHECKER_V1: MULT-0 + RUNTIME-FS; MULT-1 no live-token) |
| `SystemsLean/IrGraph.lean` | `SystemsLean.IrGraph` -- IR-GRAPH-EDGES over ordered program; edgeMax 16 (SLAKE_IR_EDGE_MAX); pushNode / addEdge; EMPTY-GRAPH-OK; endpoint bounds fail-closed (not CFG/SSA) |
| `SystemsLean/HostCompose.lean` | `SystemsLean.HostCompose` -- HOST-COMPOSE owns graph + linear host + erasure; mint / consume / markErased; pushHostNode / addHostEdge (distinct from IrGraph); multPreScan closes MULT-1 live gap; extractOk RUNTIME-FS; HOST-SMOKE example (PARTIAL vs full C) |
| `SystemsLean/EmitPlan.lean` | `SystemsLean.EmitPlan` -- EMIT-PLAN readiness inventory; planFromCompose fail-closed on checkFailClosed; isReady; edge + multi-node EMIT-PLAN-SMOKE (PARTIAL vs full C EMIT_PLAN_V0) |
| `SystemsLean/EmitApply.lean` | `SystemsLean.EmitApply` -- EMIT-APPLY fixed mult/kind tag list; packTag; applyCap 32; applyFromCompose / applyIsValid; multi-tag EMIT-APPLY-SMOKE (PARTIAL vs full C EMIT_APPLY_V0) |
| `SystemsLean/EmitBody.lean` | `SystemsLean.EmitBody` -- EMIT-BODY **HOST-EMIT-SSOT** buildFragment + emptyComposeFragmentSsot + bodyFromCompose; markers from buf; EMIT-BODY-SMOKE (PARTIAL String vs C char buf) |
| `SystemsLean/CompilePath.lean` | `SystemsLean.CompilePath` -- **HOST-COMPILE-PATH** / `SLAKE_COMPILE_PATH_V1` host-informed readiness (compileReady / unitCompileReady / programCompileReady); COMPILE-PATH-SMOKE; not product C |
| `SystemsLean/JoinMap.lean` | `SystemsLean.JoinMap` -- **HOST-JOIN-MAP** / `SLAKE_JOIN_MAP_V0` dual / JOIN-ALG map into compile-path readiness (joinUnitCompileReady / joinProgramCompileReady); JOIN-MAP-SMOKE; duals read-only cite |
| `SystemsLean/SelfHost.lean` | `SystemsLean.SelfHost` -- **HOST-SELF-HOST** / `SLAKE_SELF_HOST_V0` self-host direction readiness (selfHostUnitReady / selfHostProgramReady from join map + host surface canary); SELF-HOST-SMOKE; not self-host complete |
| `SystemsLean/SurfaceMatrix.lean` | `SystemsLean.SurfaceMatrix` -- **HOST-SURFACE-MATRIX** / `SLAKE_SURFACE_MATRIX_V0` progressive superset surface inventory (matrixUnitReady / matrixProgramReady from self-host + matrix surface canary); SURFACE-MATRIX-SMOKE; not full parity |
| `SystemsLean/KernelMult.lean` | `SystemsLean.KernelMult` -- **SELF-HOST-KERNEL-MULT** / `SLAKE_SELF_HOST_KERNEL_MULT_V0` Mult self-host kernel ordered IR (lowerMultKernel / multKernelReady); KERNEL-MULT-SMOKE; not product parity; not self-host complete |
| `SystemsLean/EmitMult.lean` | `SystemsLean.EmitMult` -- **HOST-EMIT-MULT** / `SLAKE_SELF_HOST_EMIT_MULT_V0` host-owned Mult freestanding C text (multHeaderFragment / multBodyFragment / emitMultReady); EMIT-MULT-SMOKE; bash NON-SSOT; not full product module emit; not self-host complete |
| `SystemsLean/ParityMult.lean` | `SystemsLean.ParityMult` -- **HOST-PARITY-MULT** / `SLAKE_SELF_HOST_PARITY_MULT_V0` Mult closed-loop parity (multParityReady / gradeParityOk); PARITY-MULT-SMOKE; product Mult behavioral parity in `smoke/slake_behavioral_probe.c`; Mult grades only; not self-host complete |
| `SystemsLean/KernelLinear.lean` | `SystemsLean.KernelLinear` -- **SELF-HOST-KERNEL-LINEAR** / **HOST-KERNEL-LINEAR** / `SLAKE_SELF_HOST_KERNEL_LINEAR_V0` Linear self-host kernel ordered IR + HostCompose mint/consume path (lowerLinearKernel / linearHostPathReady / linearKernelReady); KERNEL-LINEAR-SMOKE; SH4 start; not full ladder; not self-host complete |
| `SystemsLean/ParityLinear.lean` | `SystemsLean.ParityLinear` -- **HOST-PARITY-LINEAR** / **SELF-HOST-PARITY-LINEAR** / `SLAKE_SELF_HOST_PARITY_LINEAR_V0` Linear freestanding path parity Mult+Linear (linearParityReady / multLinearParityReady); PARITY-LINEAR-SMOKE; product linear_token + CONSUME_TOKEN probe labels; not freestanding product self-host complete |
| `SystemsLean/KernelTypes.lean` | `SystemsLean.KernelTypes` -- **SELF-HOST-KERNEL-TYPES** / **HOST-KERNEL-TYPES** / `SLAKE_SELF_HOST_KERNEL_TYPES_V0` Types self-host kernel ordered IR + program-path fold honesty (lowerTypesKernel / typesProgramPathReady / typesKernelReady); KERNEL-TYPES-SMOKE; SH4 growth; not full ladder; not self-host complete |
| `SystemsLean/ParityTypes.lean` | `SystemsLean.ParityTypes` -- **HOST-PARITY-TYPES** / **SELF-HOST-PARITY-TYPES** / `SLAKE_SELF_HOST_PARITY_TYPES_V0` Types freestanding path parity Mult+Linear+Types (typesParityReady / multLinearTypesParityReady); PARITY-TYPES-SMOKE; product TYPED_IR / slake_ir_node probe labels; not freestanding product self-host complete |
| `SystemsLean/KernelProgram.lean` | `SystemsLean.KernelProgram` -- **SELF-HOST-KERNEL-PROGRAM** / **HOST-KERNEL-PROGRAM** / `SLAKE_SELF_HOST_KERNEL_PROGRAM_V0` program / graph / compose self-host kernel (lowerProgramKernel / programPathReady / programGraphPathReady / programComposePathReady / programKernelReady); KERNEL-PROGRAM-SMOKE; SH4 remainder; not freestanding product self-host complete |
| `SystemsLean/ParityProgram.lean` | `SystemsLean.ParityProgram` -- **HOST-PARITY-PROGRAM** / **SELF-HOST-PARITY-PROGRAM** / `SLAKE_SELF_HOST_PARITY_PROGRAM_V0` Program freestanding path parity Mult+Linear+Types+Program (programParityReady / multLinearTypesProgramParityReady); PARITY-PROGRAM-SMOKE; product IR_PROGRAM / IR_GRAPH / HOST_COMPOSE probe labels; not freestanding product self-host complete |
| `SystemsLean/KernelEmit.lean` | `SystemsLean.KernelEmit` -- **SELF-HOST-KERNEL-EMIT** / **HOST-KERNEL-EMIT** / `SLAKE_SELF_HOST_KERNEL_EMIT_V0` freestanding codegen host honesty (lowerEmitCompose / emitPlanPathReady / emitApplyPathReady / emitBodyPathReady / emitKernelReady = programKernel + plan/apply/body + Mult emit); KERNEL-EMIT-SMOKE; SH4 remainder; no new EMIT_* C stage; not residual free |
| `SystemsLean/ParityEmit.lean` | `SystemsLean.ParityEmit` -- **HOST-PARITY-EMIT** / **SELF-HOST-PARITY-EMIT** / `SLAKE_SELF_HOST_PARITY_EMIT_V0` Emit freestanding path parity Mult+Linear+Types+Program+Emit (emitParityReady / multLinearTypesProgramEmitParityReady); PARITY-EMIT-SMOKE; product EMIT_PLAN / EMIT_APPLY / EMIT_BODY probe labels; no new EMIT_* C stage; not freestanding product self-host complete |
| `SystemsLean/SelfApply.lean` | `SystemsLean.SelfApply` -- **HOST-SELF-APPLY** / **SELF-HOST-SELF-APPLY** / `SLAKE_SELF_HOST_SELF_APPLY_V0` host self-application readiness (selfApplyReady / kernelRebuildsKernel = Mult closed loop + Linear + Types + Program + Emit kernel); SELF-APPLY-SMOKE; SH5 partial; not freestanding product self-host complete; SH6 held |
| `SystemsLean/SelfApplyFs.lean` | `SystemsLean.SelfApplyFs` -- **HOST-SELF-APPLY-FS** / **SELF-HOST-SELF-APPLY-FS** / `SLAKE_SELF_HOST_SELF_APPLY_FS_V0` freestanding self-apply deepen (freestandingExtractPathReady / freestandingBodyPathReady / freestandingParityLadderReady / freestandingEmitParityReady / freestandingSelfApplyReady; freestandingProductSelfHostComplete = false); Mult..Emit parity compose into readiness; SELF-APPLY-FS-SMOKE; SH5 freestanding deepen partial; not freestanding product self-host complete; SH6 held |
| `SystemsLean/LlvmHold.lean` | `SystemsLean.LlvmHold` -- **HOST-LLVM-HOLD** / **SELF-HOST-LLVM-HOLD** / **HOST-PROVABLY-HOLD** / `SLAKE_SELF_HOST_LLVM_HOLD_V0` SH6 hold gate (llvmHoldReady / sh6HoldReady; llvmUnlocked / provablyUnlocked / freestandingProductSelfHostComplete = false); LLVM-HOLD-SMOKE; held documented -- not unlock; not PROVABLY |
| `SystemsLean/InventoryClose.lean` | `SystemsLean.InventoryClose` -- **HOST-INVENTORY-CLOSE** / **SELF-HOST-INVENTORY-CLOSE** / `SLAKE_SELF_HOST_INVENTORY_CLOSE_V0` host inventory close readiness (inventoryCloseReady / inventoryPartialCarryHonest / inventoryCloseDoesNotMeanResidualFree; residualFreeClaimed = false); composes freestandingSelfApplyReady + llvmHoldReady + CLOSABLE-MISS-COUNT-0 surface; INVENTORY-CLOSE-SMOKE; not residual free; not freestanding product self-host complete; not llvm unlock |
| `SystemsLean/ProductPath.lean` | `SystemsLean.ProductPath` -- **HOST-PRODUCT-PATH** / **SELF-HOST-PRODUCT-PATH** / `SLAKE_SELF_HOST_PRODUCT_PATH_V0` freestanding product path readiness (productPathReady / freestandingUnitProductPathReady / freestandingProgramProductPathReady / productPathDoesNotComplete / productPathDoesNotMeanResidualFree; residualFreeClaimed = false); unitCompileReady + extractOkFs path + sibling program path over kernel emit compose; PRODUCT-PATH-SMOKE; not residual free; not freestanding product self-host complete; not llvm unlock |
| `surface-matrix.md` | **SURFACE-MATRIX** durable inventory prose (present-partial vs open rows) |
| `self-host.md` | **SELF-HOST-ACCEPTANCE** freestanding self-host bar (SH0..SH5 partial + SH5 freestanding deepen + SH6 hold documented + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH); product wire / host model jargon unpack |
| `emit/host_emit_body_fragment.ssot.txt` | Durable **HOST-EMIT-SSOT** empty-compose fragment + HEADER_*/TAG_* dialect keys; Lean owns format; bash generator is **NON-SSOT** and must embed this |
| `emit/host_emit_mult.ssot.txt` | Durable **HOST-EMIT-MULT** Mult product C text (MULT_C_HEADER / MULT_C_BODY + MULT_NAME_*); Lean owns; bash generator is **NON-SSOT** |
| `host-partial-inventory.md` | **HOST-PARTIAL-INVENTORY**: Mult..ProductPath (31 modules); **CLOSABLE-MISS-COUNT-0**; intentional PARTIAL after P2..P7 + SH0..SH6 hold + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH + HOST-PARITY-LINEAR + HOST-PARITY-TYPES + HOST-PARITY-PROGRAM + HOST-PARITY-EMIT |

Greppable host stage: **SYSTEMS_LEAN_HOST** (partial: Mult + Linear + Types + ordered IR program + Erasure + Extract + IrGraph + HostCompose + EmitPlan + EmitApply + EmitBody + CompilePath + JoinMap + SelfHost + SurfaceMatrix + KernelMult + EmitMult + ParityMult + KernelLinear + ParityLinear + KernelTypes + ParityTypes + KernelProgram + ParityProgram + KernelEmit + ParityEmit + SelfApply + SelfApplyFs + LlvmHold + InventoryClose + ProductPath). **HOST-EMIT-SSOT** (P2): fragment dialect SSoT is Lean `buildFragment` + `emit/host_emit_body_fragment.ssot.txt`; bash `script/slake-emit-freestanding-c.sh` is **NON-SSOT** for EMIT_BODY fragment text. **HOST-EMIT-MULT** (SH2): Mult product C text SSoT is Lean `EmitMult` + `emit/host_emit_mult.ssot.txt`; bash is **NON-SSOT** for Mult enum/is_valid/name. **HOST-PARITY-MULT** (SH3): Mult closed-loop host + product Mult contracts in `ParityMult.lean` + probe. **SELF-HOST-KERNEL-LINEAR** / **HOST-KERNEL-LINEAR** (SH4 start): Linear ordered IR + HostCompose path in `KernelLinear.lean`. **HOST-PARITY-LINEAR** / **SELF-HOST-PARITY-LINEAR**: Linear freestanding path parity Mult+Linear in `ParityLinear.lean` (linearParityReady / multLinearParityReady + probe). **SELF-HOST-KERNEL-TYPES** / **HOST-KERNEL-TYPES** (SH4 growth): Types / typed IR + program-path fold in `KernelTypes.lean`. **HOST-PARITY-TYPES** / **SELF-HOST-PARITY-TYPES**: Types freestanding path parity Mult+Linear+Types in `ParityTypes.lean` (typesParityReady / multLinearTypesParityReady + probe). **SELF-HOST-KERNEL-PROGRAM** / **HOST-KERNEL-PROGRAM** (SH4 remainder): ordered IR program + graph edges + HostCompose path in `KernelProgram.lean`. **HOST-PARITY-PROGRAM** / **SELF-HOST-PARITY-PROGRAM**: Program freestanding path parity Mult+Linear+Types+Program in `ParityProgram.lean` (programParityReady / multLinearTypesProgramParityReady + probe). **SELF-HOST-KERNEL-EMIT** / **HOST-KERNEL-EMIT** (SH4 remainder): host-owned emit plan/apply/body + Mult emit over program kernel in `KernelEmit.lean` (no new EMIT_* C stage). **HOST-PARITY-EMIT** / **SELF-HOST-PARITY-EMIT**: Emit freestanding path parity Mult+Linear+Types+Program+Emit in `ParityEmit.lean` (emitParityReady / multLinearTypesProgramEmitParityReady + probe). **HOST-SELF-APPLY** / **SELF-HOST-SELF-APPLY** (SH5 partial): host self-application readiness in `SelfApply.lean` (structural Mult+Linear+Types+Program+Emit kernel compose; not freestanding product self-host complete; SH6 held). **HOST-SELF-APPLY-FS** / **SELF-HOST-SELF-APPLY-FS** (SH5 freestanding deepen partial): freestanding extract/body path + freestandingParityLadderReady (ParityEmit Mult..Emit) folded into freestandingSelfApplyReady in `SelfApplyFs.lean` (freestandingProductSelfHostComplete = false; not product complete; SH6 held). **HOST-LLVM-HOLD** / **SELF-HOST-LLVM-HOLD** / **HOST-PROVABLY-HOLD** (SH6 held documented): hold gate in `LlvmHold.lean` (llvmHoldReady true; unlock flags false; not residual-open llvm mill). **HOST-INVENTORY-CLOSE** / **SELF-HOST-INVENTORY-CLOSE**: inventory close readiness in `InventoryClose.lean` (inventoryCloseReady; residualFreeClaimed false; not residual free). **HOST-PRODUCT-PATH** / **SELF-HOST-PRODUCT-PATH**: freestanding product path readiness in `ProductPath.lean` (productPathReady; unit/program CompilePath honesty; residualFreeClaimed false; not residual free; not freestanding product self-host complete). **HOST-COMPILE-PATH** (P3): `SLAKE_COMPILE_PATH_V1` host readiness in `CompilePath.lean`; structure driver remains `SLAKE_COMPILE_PATH_V0`. **HOST-JOIN-MAP** (P4): `SLAKE_JOIN_MAP_V0` composes JOIN-ALG dual cite with unit/program compile readiness in `JoinMap.lean`. **HOST-SELF-HOST** (P5): `SLAKE_SELF_HOST_V0` join-informed self-host direction readiness in `SelfHost.lean` (not self-host complete; classic elaborator residual remains). **HOST-SURFACE-MATRIX** (P7): `SLAKE_SURFACE_MATRIX_V0` progressive superset surface inventory in `SurfaceMatrix.lean` + `surface-matrix.md` (not day-one full Idris+Lean parity). **SELF-HOST-KERNEL-MULT** (SH1): Mult kernel ordered IR in `KernelMult.lean` + acceptance `self-host.md` (SH0). PARTIAL inventory: `host-partial-inventory.md` (CLOSABLE-MISS-COUNT-0). Still **not freestanding residual free**. Not PROVABLY. Not llvm unlocked. Classic elaborator still has managed runtime residual (host residual != product wire residual -- product wire means emitted freestanding C under emit/ and out/freestanding-c).

Optional Lake: `./src/systems/check.sh` runs `lake build` when lean+lake and the pinned toolchain are already installed (or `SYSTEMS_LEAN_LAKE=1` without elan). Presence stays green if Lake is missing.

Mult honesty: typed `isValid` is total-true by explicit constructor match (closed inductive). **FAIL-CLOSED-UNKNOWN-GRADE** is `ofNat?` / `isValidTag` on raw tags only.

## Product bar

- **No runtime GC (garbage collection)** on the freestanding product wire.
- **No Lean managed runtime** on that wire (AOT (ahead-of-time) != freestanding).
- Multiplicities: only what Slake needs -- **MULT-0 / MULT-1 / MULT-OMEGA** -- do not grow a multiplicity zoo.

## RC (reference counting) -- fail closed

Default: **no RC** on freestanding product paths.

If RC appears, you must **prove it is absolutely necessary**: no linear/affine ownership, borrow, arena, or other strategic design removes it without breaking the freestanding bar. Write the proof (or machine-checked obligation) next to the use; residual must name the hole until proven. "We already had RC" is not a proof.

## C emit product wire (secondary, frozen)

Freestanding product C under `emit/` / `out/freestanding-c/` is the **product wire**
(release surface Slake emits for consumers -- not network jargon), not the language
to implement Slake in.

- Stage id: **SLAKE_EMIT_FREESTANDING_C_V0** (`script/slake-emit-freestanding-c.sh`, `just out-freestanding-c`).
- Historical C API stages (unit translation, fail-closed checker, ConsumeToken host, typed IR, ordered program, graph edges, host compose, emit plan/apply/body) stay as **frozen wire history**.
- Product wire ends at **EMIT_BODY_V0**. Do not reintroduce `EMIT_MODULE_V0` or further C stages as residual.
- **HOST-EMIT-SSOT (P2):** EMIT_BODY fragment dialect is owned by Lean `SystemsLean.EmitBody` + `emit/host_emit_body_fragment.ssot.txt`. The bash generator is **NON-SSOT** for that fragment: it fail-closed-reads the artifact and embeds HEADER_*/TAG_* into product C. Re-emit must not invent a second header dialect.
- **HOST-EMIT-MULT (SH2):** Mult freestanding product C text is owned by Lean `SystemsLean.EmitMult` + `emit/host_emit_mult.ssot.txt`. Bash is **NON-SSOT** for Mult: fail-closed-reads MULT_C_HEADER / MULT_C_BODY and embeds them. No `EMIT_MULT_V0` residual C stage ladder.
- **HOST-PARITY-MULT (SH3):** Mult closed-loop parity -- host `ParityMult.lean` proves Mult contracts + kernel + emit readiness; product Mult name/is_known/tag checks in `smoke/slake_behavioral_probe.c`. No new C stage.
- **SELF-HOST-KERNEL-LINEAR / HOST-KERNEL-LINEAR (SH4 start):** Linear kernel ordered IR + HostCompose mint/consume path in `KernelLinear.lean` (KERNEL-LINEAR-SMOKE). Product Linear API cites only; no new EMIT_* C stage.
- **HOST-PARITY-LINEAR / SELF-HOST-PARITY-LINEAR:** Linear freestanding path parity Mult+Linear -- host `ParityLinear.lean` composes KernelLinear + Mult closed loop + product API canaries (`linearParityReady` / `multLinearParityReady`); probe labels existing linear_token + CONSUME_TOKEN path. No new EMIT_* C stage.
- **SELF-HOST-KERNEL-TYPES / HOST-KERNEL-TYPES (SH4 growth):** Types kernel ordered IR + foldWellTyped program-path honesty in `KernelTypes.lean` (KERNEL-TYPES-SMOKE). Product Types API cites only; no new EMIT_* C stage.
- **HOST-PARITY-TYPES / SELF-HOST-PARITY-TYPES:** Types freestanding path parity Mult+Linear+Types -- host `ParityTypes.lean` composes KernelTypes + Mult+Linear freestanding path + product API canaries (`typesParityReady` / `multLinearTypesParityReady`); probe labels existing TYPED_IR / slake_ir_node path. No new EMIT_* C stage.
- **SELF-HOST-KERNEL-PROGRAM / HOST-KERNEL-PROGRAM (SH4 remainder):** program / graph / compose kernel in `KernelProgram.lean` (programPathReady + programGraphPathReady + programComposePathReady + programKernelReady; KERNEL-PROGRAM-SMOKE). Product program/graph/compose API cites only; no new EMIT_* C stage.
- **HOST-PARITY-PROGRAM / SELF-HOST-PARITY-PROGRAM:** Program freestanding path parity Mult+Linear+Types+Program -- host `ParityProgram.lean` composes KernelProgram + Mult+Linear+Types freestanding path + product API canaries (`programParityReady` / `multLinearTypesProgramParityReady`); probe labels existing IR_PROGRAM / IR_GRAPH / HOST_COMPOSE path. No new EMIT_* C stage.
- **SELF-HOST-KERNEL-EMIT / HOST-KERNEL-EMIT (SH4 remainder):** freestanding codegen host honesty in `KernelEmit.lean` (emitPlanPathReady + emitApplyPathReady + emitBodyPathReady + emitKernelReady over program kernel + Mult emit; KERNEL-EMIT-SMOKE). Uses HOST-EMIT-SSOT + HOST-EMIT-MULT; product EMIT_PLAN/APPLY/BODY cites only; no new EMIT_* C stage.
- **HOST-PARITY-EMIT / SELF-HOST-PARITY-EMIT:** Emit freestanding path parity Mult+Linear+Types+Program+Emit -- host `ParityEmit.lean` composes KernelEmit + Mult+Linear+Types+Program freestanding path + product API canaries (`emitParityReady` / `multLinearTypesProgramEmitParityReady`); probe labels existing EMIT_PLAN / EMIT_APPLY / EMIT_BODY path. No new EMIT_* C stage.
- **HOST-SELF-APPLY / SELF-HOST-SELF-APPLY (SH5 partial):** host self-application readiness in `SelfApply.lean` (selfApplyReady / kernelRebuildsKernel from Mult closed loop + Linear + Types + Program + Emit kernel; SELF-APPLY-SMOKE). Structural host only -- not freestanding product self-host complete; SH6 llvm held.
- **HOST-SELF-APPLY-FS / SELF-HOST-SELF-APPLY-FS (SH5 freestanding deepen partial):** freestanding extract/body path honesty on kernel emit compose + freestanding Mult..Emit parity ladder compose in `SelfApplyFs.lean` (freestandingExtractPathReady + freestandingBodyPathReady + freestandingParityLadderReady = ParityEmit.multLinearTypesProgramEmitParityReady; dual freestandingEmitParityReady = emitParityReady -- equivalent under folds, not a stronger gate; freestandingSelfApplyReady folds parity ladder; freestandingProductSelfHostComplete = false; SELF-APPLY-FS-SMOKE). Not freestanding product self-host complete; SH6 llvm held.
- **HOST-LLVM-HOLD / SELF-HOST-LLVM-HOLD / HOST-PROVABLY-HOLD (SH6 held documented):** hold gate in `LlvmHold.lean` (llvmHoldReady / sh6HoldReady; llvmUnlocked / provablyUnlocked / freestandingProductSelfHostComplete = false; LLVM-HOLD-SMOKE). Not unlock; not residual-open llvm mill; out/llvm-ir still deferred.
- **HOST-INVENTORY-CLOSE / SELF-HOST-INVENTORY-CLOSE (inventory close readiness):** host inventory close after Mult..LlvmHold in `InventoryClose.lean` (inventoryCloseReady = freestandingSelfApplyReady && llvmHoldReady && surface && partialCarry && !complete && !llvmUnlocked && !provablyUnlocked; residualFreeClaimed = false; inventoryCloseDoesNotMeanResidualFree; INVENTORY-CLOSE-SMOKE). Not residual free; not freestanding product self-host complete; not llvm unlock; intentional PARTIAL carry remains.
- **HOST-PRODUCT-PATH / SELF-HOST-PRODUCT-PATH (freestanding product path readiness):** freestanding unit/program product path after inventory close in `ProductPath.lean` (productPathReady = inventoryCloseReady && freestandingUnitProductPathReady && freestandingProgramProductPathReady && surface && !residual free claimed && !product complete claimed && !SelfApplyFs complete && !llvm unlock && !provably unlock; freestandingUnitProductPathReady unitCompileReady / extractOkFs on empty/unminted/lowerEmitCompose; sibling freestandingProgramProductPathReady empty program fail-closed + lowered kernel well-typed; productPathDoesNotComplete / productPathDoesNotMeanResidualFree; PRODUCT-PATH-SMOKE). Not residual free; not freestanding product self-host complete; not llvm unlock; intentional PARTIAL carry remains.
- Do **not** mint new `EMIT_*` C stages as the residual treadmill. Do not grow shell debt.

**Static presence (pure Nix):** two modules; do not re-grow those greps in `check.sh`.

| Gate | Module | Live recipe / flake check |
|------|--------|---------------------------|
| Host skeleton + unit-surface tokens + SYSTEMS_LEAN_HOST Mult..ProductPath + tree-wide banned-jargon walk | `nix/systems-host-presence/` | `just systems-host` / `systems-host-presence` |
| Compile/emit drivers, UNIT_DEEPEN, emit product stages, unit-surface walk, optional release, hosted probe path (`smoke/slake_behavioral_probe.c`) | `nix/systems-emit-wire/` | `just systems-emit-wire` / `systems-emit-wire` |

**Residual shell** (`check.sh`, ~228 lines): optional Lake elaborator, compile-path/emit/out-freestanding-c **driver runs**, freestanding-first compile smoke + `cc` link/run of hosted behavioral probe (`smoke/slake_behavioral_probe.c` -- smoke debt, not product emit residual). Tree-wide banned-jargon ban is pure Nix (host-presence). Pure Nix requires the probe path. Solo `check.sh` is incomplete without both pure Nix recipes.

Legacy greppable id `IR_PROGRAM_V0` means multi-node **ordered IR program** (node list). Do not mint new `metaphor stage ids` names; rename when a deliberate honesty slice lands. Prefer: ordered IR program, node list, graph edges.

## IR sketch (design only)

Shared intermediate-representation correspondence lives at
`doc/shared-ir-sketch.md`. Module layout below mirrors that sketch.

## Unit markers (honest multi-tier)

Every freestanding unit (`*.slake` / `*.lean` under this tree) must carry one of:

| Marker | Meaning | `just build` path |
|--------|---------|-------------------|
| `SKELETON` | Pure layout / import shell | Layout-only when only skeletons exist |
| `UNIT_SURFACE` | Unit surface beyond layout (Lean host or .slake surface) | Counts as unit-surface; still **not** product C from build alone |
| `UNIT_DEEPEN_V1` | Abstract body + first unit translation contracts (historical .slake + emit map) | Still **not residual free** |
| `SYSTEMS_LEAN_HOST` | Real Lean host modules under Lake | Mult/Linear/Types/IrProgram/Erasure/Extract/IrGraph/HostCompose/EmitPlan/EmitApply/EmitBody/CompilePath/JoinMap/SelfHost/SurfaceMatrix/KernelMult/EmitMult/ParityMult/KernelLinear/ParityLinear/KernelTypes/ParityTypes/KernelProgram/ParityProgram/KernelEmit/ParityEmit/SelfApply/SelfApplyFs/LlvmHold/InventoryClose/ProductPath partial; still **not residual free**; SH6 hold not unlock; inventory close not residual free; product path not residual free |
| `FAIL_CLOSED_CHECKER_V1` | Composed fail-closed checker + extract path (frozen wire) | Still **not residual free** |
| `CONSUME_TOKEN_HOST_V0` | JOIN-ALG ConsumeToken-class freestanding host (frozen wire) | Still **not residual free** |
| `TYPED_IR_V0` | Richer typed IR surface (frozen wire) | Still **not residual free** |
| `IR_PROGRAM_V0` | Historical ordered IR program id (node list; rename later) | Still **not residual free** |
| `IR_GRAPH_EDGES_V0` | Directed edge slots (frozen wire) | Still **not residual free** |
| `HOST_COMPOSE_V0` | Host + IR graph composition (frozen wire) | Still **not residual free** |
| `EMIT_PLAN_V0` | Emit plan readiness inventory (frozen wire) | Still **not residual free** |
| `EMIT_APPLY_V0` | Apply plan tags into fixed buffer (frozen wire) | Still **not residual free** |
| `EMIT_BODY_V0` | Freestanding C body fragment (frozen wire) | Still **not residual free** |
| (stage) `SLAKE_COMPILE_PATH_V0` | Structure-validation compile path for `UNIT_SURFACE` | Driver: `script/slake-compile-path.sh`; still **not** product C |
| (stage) `SLAKE_COMPILE_PATH_V1` / `HOST-COMPILE-PATH` | Host-informed compile-path readiness (Lean) | `SystemsLean/CompilePath.lean`; V0 structure remains; still **not** product C |
| (stage) `SLAKE_JOIN_MAP_V0` / `HOST-JOIN-MAP` | Dual / JOIN-ALG map into compile-path readiness (Lean) | `SystemsLean/JoinMap.lean`; duals read-only cite; still **not residual free** |
| (stage) `SLAKE_SELF_HOST_V0` / `HOST-SELF-HOST` | Self-host direction readiness (Lean) | `SystemsLean/SelfHost.lean`; not self-host complete; still **not residual free** |
| (stage) `SLAKE_SURFACE_MATRIX_V0` / `HOST-SURFACE-MATRIX` | Progressive superset surface inventory (Lean) | `SystemsLean/SurfaceMatrix.lean` + `surface-matrix.md`; not full parity; still **not residual free** |
| (stage) `SLAKE_EMIT_FREESTANDING_C_V0` | Real freestanding emit path V0 (frozen ladder) | Driver: `script/slake-emit-freestanding-c.sh`; release via `just out-freestanding-c`; still **not residual free** |

Rules:

- Unit with **neither** `SKELETON` nor `UNIT_SURFACE` -> build and check **fail** (`missing: path`).
- Unit with `UNIT_SURFACE` counts as unit-surface (even if `SKELETON` text also appears).
- When any `UNIT_SURFACE` unit exists, `just build` runs **SLAKE_COMPILE_PATH_V0** (structure bar).
- Product C: **SLAKE_EMIT_FREESTANDING_C_V0** writes under `src/systems/emit/`; `just out-freestanding-c` copies into `out/freestanding-c/`. Still not residual free.
- Presence gate requires Lean host files (lakefile, toolchain, Mult..ProductPath ladder + surface-matrix.md + self-host.md) plus frozen emit wire honesty. Never residual free.

### First unit translation map (historical emit / UNIT_TRANSLATION_V0)

| Unit | Contract ids | Lean host | Emit C map (frozen wire) |
|------|--------------|-----------|--------------------------|
| Mult | MULT-0 / MULT-1 / MULT-OMEGA; FAIL-CLOSED-UNKNOWN-GRADE; HOST-PARITY-MULT | `SystemsLean/Mult.lean` + **HOST-EMIT-MULT** `EmitMult.lean` + **HOST-PARITY-MULT** `ParityMult.lean` | `enum slake_mult`, `slake_mult_is_valid` / `is_known` / `name` (bash NON-SSOT Mult text; probe parity) |
| Linear | LINEAR-EXACT-ONCE; JOIN-ALG ConsumeToken; SELF-HOST-KERNEL-LINEAR; HOST-PARITY-LINEAR | `SystemsLean/Linear.lean` + **HOST-KERNEL-LINEAR** `KernelLinear.lean` + **HOST-PARITY-LINEAR** `ParityLinear.lean` | `slake_linear_*`, `slake_consume_token_*` (frozen ABI; KernelLinear path + ParityLinear freestanding path honesty) |
| Erasure | ERASE-RULE-MULT-0; ERASE-NO-RUNTIME; EDGE-PROP / ERASE-PROP | `SystemsLean/Erasure.lean` | `slake_erased`, `slake_erasure_is_runtime_absent` |
| Extract | EMIT-BOUNDARY; RUNTIME-FS; EDGE-RUNTIME / RUNTIME-CLASSIC | `SystemsLean/Extract.lean` | `slake_extract_*`, FAIL_CLOSED_CHECKER_V1, emit plan/apply/body |
| Types | COMMON-UNIVERSE; HOST-RESIDUAL vs PRODUCT-WIRE-RESIDUAL; kind/mult IR node; HOST-PARITY-TYPES | `SystemsLean/Types.lean` + **HOST-KERNEL-TYPES** `KernelTypes.lean` + **HOST-PARITY-TYPES** `ParityTypes.lean` | `slake_type_tag`, `slake_ir_node_*` (frozen ABI; KernelTypes path + ParityTypes freestanding path honesty) |
| Ordered IR program | ORDERED-IR-PROGRAM; EMPTY-PROGRAM-FAIL-CLOSED; cap 8; HOST-PARITY-PROGRAM | `SystemsLean/IrProgram.lean` + **HOST-KERNEL-PROGRAM** `KernelProgram.lean` + **HOST-PARITY-PROGRAM** `ParityProgram.lean` | `slake_ir_program_*` (historical wire id `IR_PROGRAM_V0`; KernelProgram path + ParityProgram freestanding path honesty) |
| IR graph edges | IR-GRAPH-EDGES; EMPTY-GRAPH-OK; SLAKE_IR_EDGE_MAX 16; HOST-PARITY-PROGRAM | `SystemsLean/IrGraph.lean` + **HOST-KERNEL-PROGRAM** + **HOST-PARITY-PROGRAM** | `slake_ir_graph_*` (historical wire id `IR_GRAPH_EDGES_V0`) |
| Host compose | HOST-COMPOSE; mint/consume/markErased; pushHostNode; multPreScan MULT-1; HOST-PARITY-PROGRAM | `SystemsLean/HostCompose.lean` + **HOST-KERNEL-PROGRAM** + **HOST-PARITY-PROGRAM** | `slake_host_compose_*` (historical wire id `HOST_COMPOSE_V0`) |
| Emit plan | EMIT-PLAN; readiness counts; planFromCompose fail-closed | `SystemsLean/EmitPlan.lean` | `slake_emit_plan_*` (historical wire id `EMIT_PLAN_V0`) |
| Emit apply | EMIT-APPLY; packTag mult/kind buffer; applyFromCompose | `SystemsLean/EmitApply.lean` | `slake_emit_apply_*` (historical wire id `EMIT_APPLY_V0`) |
| Emit body | EMIT-BODY; **HOST-EMIT-SSOT** buildFragment + emptyComposeFragmentSsot; markers from buf | `SystemsLean/EmitBody.lean` + `emit/host_emit_body_fragment.ssot.txt` | `slake_emit_body_*` (historical wire id `EMIT_BODY_V0`; bash NON-SSOT) |
| Compile path (host) | HOST-COMPILE-PATH; `SLAKE_COMPILE_PATH_V1`; compileReady / unitCompileReady | `SystemsLean/CompilePath.lean` | Structure driver remains `SLAKE_COMPILE_PATH_V0` (shell); not product C |
| Join map (host) | HOST-JOIN-MAP; `SLAKE_JOIN_MAP_V0`; JOIN-ALG ConsumeToken cite; joinUnitCompileReady | `SystemsLean/JoinMap.lean` | Duals read-only; not formal full bridge theorems; not product C |
| Self-host (host) | HOST-SELF-HOST; `SLAKE_SELF_HOST_V0`; selfHostUnitReady / selfHostProgramReady | `SystemsLean/SelfHost.lean` | Direction readiness only; not self-host complete; not product C; llvm still deferred |
| Surface matrix (host) | HOST-SURFACE-MATRIX; `SLAKE_SURFACE_MATRIX_V0`; matrixUnitReady / matrixProgramReady | `SystemsLean/SurfaceMatrix.lean` + `surface-matrix.md` | Progressive inventory only; not full Idris/Lean parity; not product C; llvm still deferred |
| Mult kernel / emit / parity (self-host) | SELF-HOST-KERNEL-MULT; HOST-EMIT-MULT; HOST-PARITY-MULT | `KernelMult.lean` + `EmitMult.lean` + `ParityMult.lean` | Mult product text SSoT + closed-loop Mult contracts; not self-host complete |
| Linear kernel (self-host SH4 start) | SELF-HOST-KERNEL-LINEAR; HOST-KERNEL-LINEAR | `KernelLinear.lean` | Linear ordered IR + HostCompose mint/consume path; not full ladder; not self-host complete |
| Linear freestanding path parity | HOST-PARITY-LINEAR; SELF-HOST-PARITY-LINEAR | `ParityLinear.lean` | Mult+Linear freestanding path honesty (linearParityReady / multLinearParityReady); not product complete |
| Types kernel (self-host SH4 growth) | SELF-HOST-KERNEL-TYPES; HOST-KERNEL-TYPES | `KernelTypes.lean` | Types / typed IR + foldWellTyped program path; not full ladder; not self-host complete |
| Types freestanding path parity | HOST-PARITY-TYPES; SELF-HOST-PARITY-TYPES | `ParityTypes.lean` | Mult+Linear+Types freestanding path honesty (typesParityReady / multLinearTypesParityReady); not product complete |
| Program kernel (self-host SH4 remainder) | SELF-HOST-KERNEL-PROGRAM; HOST-KERNEL-PROGRAM | `KernelProgram.lean` | ordered IR + graph edges + HostCompose path; not freestanding product self-host complete |
| Program freestanding path parity | HOST-PARITY-PROGRAM; SELF-HOST-PARITY-PROGRAM | `ParityProgram.lean` | Mult+Linear+Types+Program freestanding path honesty (programParityReady / multLinearTypesProgramParityReady); not product complete |
| Emit kernel (self-host SH4 remainder) | SELF-HOST-KERNEL-EMIT; HOST-KERNEL-EMIT | `KernelEmit.lean` | plan/apply/body + Mult emit over program kernel; no new EMIT_* C stage; not residual free |
| Emit freestanding path parity | HOST-PARITY-EMIT; SELF-HOST-PARITY-EMIT | `ParityEmit.lean` | Mult+Linear+Types+Program+Emit freestanding path honesty (emitParityReady / multLinearTypesProgramEmitParityReady); not product complete |
| Self-apply (self-host SH5 partial) | HOST-SELF-APPLY; SELF-HOST-SELF-APPLY | `SelfApply.lean` | Mult closed loop + Linear + Types + Program + Emit kernel compose; host structural only; not freestanding product self-host complete |
| Self-apply FS (self-host SH5 freestanding deepen) | HOST-SELF-APPLY-FS; SELF-HOST-SELF-APPLY-FS | `SelfApplyFs.lean` | freestanding extract/body path on kernel emit compose + freestandingParityLadderReady (Mult..Emit parity) + selfApplyReady; freestandingProductSelfHostComplete false; not product complete |
| Llvm hold (self-host SH6 held) | HOST-LLVM-HOLD; SELF-HOST-LLVM-HOLD; HOST-PROVABLY-HOLD | `LlvmHold.lean` | Hold gate only; llvmUnlocked false; not unlock; not PROVABLY; out/llvm-ir deferred |
| Inventory close (host inventory close) | HOST-INVENTORY-CLOSE; SELF-HOST-INVENTORY-CLOSE | `InventoryClose.lean` | inventoryCloseReady after Mult..LlvmHold; residualFreeClaimed false; intentional PARTIAL carry; not residual free; not product complete |
| Product path (freestanding product path) | HOST-PRODUCT-PATH; SELF-HOST-PRODUCT-PATH | `ProductPath.lean` | productPathReady after inventory close; unit/program CompilePath honesty; residualFreeClaimed false; not residual free; not product complete |

Smoke: `cc -c -ffreestanding -nostdlib` preferred when freestanding stdint works;
hosted `cc -c` fallback documented in emit header comments.

## Layout

| Path | Role |
|------|------|
| `SystemsLean/*.lean` | **Primary** Systems Lean host modules (Lake) |
| `host-partial-inventory.md` | Mult..ProductPath PARTIAL inventory (CLOSABLE-MISS-COUNT-0; KernelMult + EmitMult + ParityMult + KernelLinear + ParityLinear + KernelTypes + ParityTypes + KernelProgram + ParityProgram + KernelEmit + ParityEmit + SelfApply + SelfApplyFs + LlvmHold + InventoryClose + ProductPath + self-host rows) |
| `self-host.md` | Freestanding self-host acceptance (SH0..SH5 partial + SH5 freestanding deepen + SH6 hold documented + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH); product wire / host model terms |
| `surface-matrix.md` | SURFACE-MATRIX progressive superset inventory prose (P7) |
| `emit/host_emit_body_fragment.ssot.txt` | HOST-EMIT-SSOT durable fragment dialect (P2) |
| `emit/host_emit_mult.ssot.txt` | HOST-EMIT-MULT durable Mult product text (SH2) |
| `types.md` / `Types.slake` | Types notes + historical unit surface |
| `mult.md` / `Mult.slake` | Mult notes + historical unit surface (Lean: Mult.lean) |
| `linear.md` / `Linear.slake` | Linear notes + historical unit surface (Lean: Linear.lean) |
| `erasure.md` / `Erasure.slake` | Erasure of mult-0 (Lean: Erasure.lean) |
| `extract.md` / `Extract.slake` | Extract / emit boundary (Lean: Extract.lean) |
| `emit/` | Frozen freestanding product C (`slake_freestanding.c` / `.h`) |
| `smoke/` | Hosted behavioral probe (`slake_behavioral_probe.c`) -- test/smoke debt linked against emit product; not freestanding residual progress |
| `check.sh` | Residual shell (~228 lines): driver runs + freestanding compile + link/run external probe + optional Lake (static host + jargon + emit-wire + probe path pure Nix; not residual free) |
| `../../script/slake-compile-path.sh` | `SLAKE_COMPILE_PATH_V0` structure validation (not product C) |
| `../../script/slake-emit-freestanding-c.sh` | `SLAKE_EMIT_FREESTANDING_C_V0` emit into `emit/` (frozen wire; **NON-SSOT** for EMIT_BODY fragment + Mult product text; HOST-EMIT-SSOT + HOST-EMIT-MULT) |
| `../../out/freestanding-c/` | Runtimeless freestanding product C (release; populated by out-freestanding-c) |

## Commands

```bash
just build               # freestanding src/systems build (compile-path; not product C)
just out-freestanding-c  # emit + refresh out/freestanding-c for release (frozen wire)
just systems-host        # pure Nix static skeleton/unit-surface/host + tree-wide jargon ban
just systems-emit-wire   # pure Nix emit-wire / UNIT_DEEPEN / unit walk / optional release / probe path
just check               # hygiene + systems-host + systems-emit-wire + flake + residual shells
./src/systems/check.sh   # residual shell: Lake optional + driver runs + link/run smoke/probe (incomplete alone)
./script/slake-compile-path.sh           # compile-path stage alone (SLAKE_COMPILE_PATH_V0)
./script/slake-emit-freestanding-c.sh    # emit stage alone (SLAKE_EMIT_FREESTANDING_C_V0)
```
