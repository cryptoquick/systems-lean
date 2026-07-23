# Residual -- coordinator (Systems Lean)

Project-level residual and join board. **Sides own their own files:**

| File | Owner |
|------|--------|
| `RESIDUAL-idris.md` | Idris-side fork |
| `RESIDUAL-lean.md` | Lean-side fork |
| `RESIDUAL-systems.md` | Systems / Slake fork |
| `RESIDUAL.md` (this file) | Coordinator (monitor / join board) |

**Status vocabulary:** `open` | `in progress` | `done` | `blocked` | `wontfix`

Green `just check` != residual closed.

Language: **Idris side** / **Lean side** / **coordinator** -- never "pole".

---

## Join done

| Item | Evidence |
|------|----------|
| Dual MULT maps (MULT-0 / MULT-1 / MULT-OMEGA) | `src/idris2/multiplicity-map.md`, `src/lean4/multiplicity-map.md` |
| Dual algorithm ids (JOIN-ALG) | ConsumeToken, ErasedIndex, UnrestrictedShare under `src/idris2/examples/` and `src/lean4/examples/` |
| Both JOIN files | `src/idris2/JOIN.md`, `src/lean4/JOIN.md` |
| Ordered IR program stage id | Greppable `IR_PROGRAM_V0`; product prose uses ordered IR program / node list; see `AGENTS.md` ban |
| Greppable imperfect edges merged into divergence | `doc/divergence.md` section **Greppable imperfect edges (dual pair)** (EDGE-* / ERASE-* / RUNTIME-* + JOIN-ALG) |
| Shared intermediate-representation (IR) sketch | `doc/shared-ir-sketch.md` (pointer from `doc/architecture.md`; thin note in `src/systems/README.md`) |
| Slake skeleton under `src/systems/` | Layout stubs: `types.md`/`Types.slake`, `mult.md`/`Mult.slake`, `linear.md`/`Linear.slake`, `erasure.md`/`Erasure.slake`, `extract.md`/`Extract.slake`; pure Nix presence + process glue `src/systems/check.sh`; `just build` -> compile-path stamp; unit markers (SKELETON + UNIT_SURFACE) pure Nix. **Not freestanding residual free.** |
| First freestanding unit surface | Five modules marked `UNIT_SURFACE` with thin abstract surface (grades / linear resource / erasure rule / extract boundary); check requires at least one + content bar; build unit-surface path prints count and refuses product C claim from build alone. |
| Real freestanding compile path (process-glue stamp) | `script/slake-compile-path.sh` stage id `SLAKE_COMPILE_PATH_V0` is process-glue stamp (no static greps); static unit walk pure Nix (`systems-emit-wire`); wired from `just build`; `.cache/slake-compile-path/` stamp is **not** product C. |
| Real freestanding emit path V0 + out/freestanding-c populate | Lean `SystemsLean.FreestandingEmit` stage `SLAKE_EMIT_FREESTANDING_C_V0`; writes `src/systems/emit/slake_freestanding.{c,h}` from templates + SSOT; `just out-freestanding-c` re-emits + clean-installs into `out/freestanding-c/` (preserves README); bash emit deleted (Wave C); still **not residual free**; **not PROVABLY**. |
| UNIT_DEEPEN_V1 abstract body + first unit translation | Mult/Linear/Erasure/Extract/Types `UNIT_DEEPEN_V1`; C APIs `slake_mult_is_valid`, `slake_linear_consume`, `slake_erasure_is_runtime_absent`; companion notes; still **not residual free**. |
| FAIL_CLOSED_CHECKER_V1 composed checker + extract path | `slake_check_bundle`, `slake_check_fail_closed`, `slake_extract_with_checks`; Extract unit map; behavioral smoke; still **not residual free**. |
| CONSUME_TOKEN_HOST_V0 freestanding JOIN-ALG host | `slake_consume_token` mint/consume/check under emit; Linear unit notes; dual cite only; still **not residual free**. |
| TYPED_IR_V0 richer typed IR surface | `slake_ir_node` kind/mult pairing + well-typed + fail-closed compose; Types unit map; still **not residual free**. |
| IR_PROGRAM_V0 multi-node ordered IR program | Ordered `slake_ir_program` (`SLAKE_IR_PROGRAM_CAP` 8) + collective well-typed + fail-closed (empty program NOT well-typed; full push -2); still **not residual free**. |
| IR_GRAPH_EDGES_V0 directed edge slots | `slake_ir_graph` shell + `SLAKE_IR_EDGE_MAX` 16 index pairs; empty graph OK; full edges -1; not full CFG/SSA; still **not residual free**. |
| HOST_COMPOSE_V0 host + IR graph composition | `slake_host_compose` owns graph + host + erased; mint / consume / mark_erased / check_fail_closed / extract; MULT-1 needs mint; MULT-0 needs mark; empty compose extract OK; still **not residual free**. |
| EMIT_PLAN_V0 emit plan from host compose | `slake_emit_plan` readiness inventory from checked host compose; Extract primary + Types light; still **not residual free**. |
| EMIT_APPLY_V0 apply plan tags | `slake_emit_apply` fixed mult/kind tag buffer from checked host compose; Extract primary + Types light; still **not residual free**. |
| EMIT_BODY_V0 body fragment | `slake_emit_body` fixed freestanding C body fragment from checked host compose via plan+apply; Extract primary + Types light; still **not residual free**. |

Dual depth, ordered IR program rename, divergence merge, IR sketch, systems skeleton, unit surface, compile path, and frozen freestanding emit product wire through emit body are **done**. **Do not** grow freestanding C as a substitute for duals or Systems Lean host. Active product residual: **Systems / Slake** Lean host deepen (`doc/fork-systems.md`, `RESIDUAL-systems.md`). Watcher session is separate (root `WATCHER.md`).

**Honesty pin:** freestanding C emit stages and shell gate mills are **product wire / debt**, not Systems Lean language progress and not meet-in-the-middle dual progress.

---

## Open (high-value next)

Prioritized backlog (plan): P0 shell/tooling -> P1 host close -> P2 host-driven emit ->
P3 compile depth -> P4 join map into Slake -> P5 self-host -> P6 llvm/PROVABLY (after
self-host / real ccomp) -> P7 superset matrix. Order is priority, not permission to skip
ordinary residual. Explicitly deferred only: llvm-ir until self-host; PROVABLY until real
ccomp + matrix.

| Priority | Work | Owner / notes |
|----------|------|----------------|
| P0 | Shell/C paydown | **done (2026-07-22, bulk + thin glue):** plan `.agents/plans/plan-paydown-shell-c-surfaces.md` waves 0-E + Thin process glue. Dual pure Nix presence; emit bash deleted (Lean `FreestandingEmit`); compile-path shell is stamp only (no static greps); ownership note in `src/systems/README.md`. Still **not residual free**. |
| P1 | Systems Lean host close PARTIAL | **done (2026-07-22):** `host-partial-inventory.md` CLOSABLE-MISS-COUNT-0; intentional PARTIAL carry |
| P2 | Host drives emit | **done (2026-07-22, partial):** host Mult/body SSOT fragments; full C ladder still frozen wire |
| P3 | Real Slake compile path | **done (2026-07-22, partial):** `SystemsLean/CompilePath.lean`; V0 stamp shell remains (no static greps; unit walk pure Nix) |
| P4 | Join map into Slake | **done (2026-07-22, partial):** `SystemsLean/JoinMap.lean`; duals read-only; not formal full bridge theorems |
| P5 | Self-host direction readiness | **done (2026-07-22, partial):** `SystemsLean/SelfHost.lean`; not freestanding product self-host complete; does **not** unlock llvm alone |
| P6 | llvm-ir / PROVABLY | **held** (SH6 documented): `LlvmHold.lean` (HOST-LLVM-HOLD / HOST-PROVABLY-HOLD); unlock flags false; true freestanding product self-host required; real ccomp + matrix for PROVABLY; **not** residual-open mill |
| P7 | Superset surface matrix | **done (2026-07-22, partial):** `SystemsLean/SurfaceMatrix.lean` + `surface-matrix.md`; not day-one full dual parity; does **not** unlock llvm |
| SH0..SH5 + deepen | Freestanding self-host track (partial) | **done (partial):** Mult..Emit kernels, parity, self-apply + freestanding deepen. Greppable map: `RESIDUAL-systems.md` **Highest value next**. Not freestanding product self-host complete; **not** residual free |
| SH6 | llvm / PROVABLY hold gate | **held (documented, 2026-07-22):** `LlvmHold.lean` (HOST-LLVM-HOLD / HOST-PROVABLY-HOLD); unlock flags false; still **not residual free**; still **not PROVABLY**; out/llvm-ir deferred |
| Inventory close | Host inventory close readiness | **done (partial):** `InventoryClose.lean`; residualFreeClaimed false; Mult..InventoryClose 30 modules; intentional PARTIAL |
| Product path | Freestanding product path readiness | **done (partial):** `ProductPath.lean` HOST-PRODUCT-PATH; productPathReady; residualFreeClaimed false; open matrix rows stay open; **not** freestanding product self-host complete |
| Product path close | Structural product path ladder close | **done (partial):** same `ProductPath.lean` HOST-PRODUCT-PATH-CLOSE; productPathCloseReady / productPathLadderClosedOk; productPathFurtherAliasTheaterHeld; residual free still open as claim -- **not** residual free |
| Dual residual | Host elaborator residual vs product residual honesty | **done (partial):** `DualResidual.lean` HOST-DUAL-RESIDUAL; dualResidualReady; hostElaboratorResidualRemains true; productResidualRemains true; residualFreeClaimed false; Mult..DualResidual was 32-module endpoint; neither residual forged free |
| Probe-vs-wire | Hosted behavioral probe vs product freestanding wire honesty | **done (partial):** `ProbeWire.lean` HOST-PROBE-WIRE; probeWireReady; behavioralProbeIsSmokeDebt true; product freestanding wire distinct; residualFreeClaimed false; Mult..ProbeWire was 33-module endpoint; probe green is not residual free |
| Spec-proof | Formal specification vs proof separation honesty | **done (partial):** `SpecProof.lean` HOST-SPEC-PROOF; specProofReady; specSurfaceStated true; proofCompleteClaimed false; proofDoesNotRetireTests true; residualFreeClaimed false; Mult..SpecProof 34 modules; not proof complete |
| Mult theorems | FAIL-CLOSED-UNKNOWN-GRADE / ofNat? + name honesty | **done (partial):** Mult.lean MULT-THEOREM; ofNat?_fail_closed + name_mult0/1/Omega + ofNat?_some_implies_isValidTag + ofNat?_name_zero/one/two + ofNat?_name_fail_closed; proofCompleteClaimed stays false |
| Types theorems | FAIL-CLOSED-UNKNOWN-KIND / mkNode success paths | **done (partial):** Types.lean TYPES-THEOREM; kindMultOk + mkNode?_ok + expectedMult_* + mkNodeFromTags? paths; proofCompleteClaimed stays false |
| IrProgram theorems | EMPTY-PROGRAM-FAIL-CLOSED + multi-node + cap full | **done (partial):** IrProgram.lean IR-PROGRAM-THEOREM; empty reject + single/two-value well-typed + fold success + push_second_value_ok + push_full_at_cap; proofCompleteClaimed stays false |
| CompilePath theorems | empty host vs empty program + path contracts | **done (partial):** CompilePath.lean COMPILE-PATH-THEOREM; empty host/program + extractFsOk_eq + extractClaimOk classic/edge/fs + single-value program + mult1 unminted/minted; proofCompleteClaimed stays false |
| IrGraph theorems | EMPTY-GRAPH-OK + multi-node one/two-edge + oversize | **done (partial):** IrGraph.lean IR-GRAPH-THEOREM; empty OK + one-node + edgesSound_one_edge + edgesSound_two_edges + addEdge_two_nodes_* + edgesSound_oversize_false; proofCompleteClaimed stays false |
| Linear theorems | JOIN-ALG honest limited surface theorems | **done (partial):** Linear.lean LINEAR-THEOREM; shareNat_eq + shareNat_zero/succ + polyId_id + roundTrip_eq; axioms remain; no MULT-1 claim; proofCompleteClaimed stays false |
| HostCompose theorems | multPreScan / mint-consume / push-edge / EMIT-BOUNDARY non-empty | **done (partial):** HostCompose.lean COMPOSE-THEOREM; mint-consume + markErased_idempotent + multPreScan_omega_only_true + mint_consume_roundtrip + pushHostNode_* + addHostEdge_* + extractOk_classic_mult1_minted_false / extractOk_edge_mult1_minted_false / extractOk_classic_mult0_marked_false / extractOk_edge_mult0_marked_false; live-flag only; proofCompleteClaimed stays false |
| Extract theorems | RUNTIME-FS-only + raw-tag success paths | **done (partial):** Extract.lean EXTRACT-THEOREM; ofRuntimeTag?_some_implies_isValidRuntimeTag + extractOkFromTags? known-tag paths + fail_closed; proofCompleteClaimed stays false |
| Erasure theorems | mark fail-closed + composition honesty | **done (partial):** Erasure.lean ERASURE-THEOREM; checkFailClosed_eq + markForGrade?_some_implies_isErasureGrade / markForGrade?_some_is_mark; proofCompleteClaimed stays false |
| EmitBody theorems | HOST-EMIT-SSOT + non-empty fixtures | **done (partial):** EmitBody.lean EMIT-BODY-THEOREM; bodyOk_empty_true + bodyOk_mult1_* + bodyFromCompose non-empty fixtures; proofCompleteClaimed stays false |
| EmitPlan theorems | EMIT-PLAN readiness inventory | **done (partial):** EmitPlan.lean EMIT-PLAN-THEOREM; empty ready/counts + fail-closed MULT-1/MULT-0 + planOk_mult1_minted_true / planFromCompose_mult1_minted_runtime + mult0 marked/omega + planFromCompose_two_values_edge + planFromCompose_linear_and_erased; proofCompleteClaimed stays false |
| EmitApply theorems | EMIT-APPLY tag buffer honesty | **done (partial):** EmitApply.lean EMIT-APPLY-THEOREM; applyCap_eq_32 + packTag_linear/erased/value + unpack + fail-closed MULT-1 + applyFromCompose_mult1_minted_tags / mult0_marked_tag / omega_tag + applyFromCompose_linear_and_erased_order + applyIsValid_count_tags_desync_false; proofCompleteClaimed stays false |
| JoinMap theorems | join path contracts + surface canaries | **done (partial):** JoinMap.lean JOIN-MAP-THEOREM; empty host/program + joinUnitCompileReady_eq + mult1 unminted/minted + joinProgramCompileReady_single_value; not formal duals; proofCompleteClaimed stays false |
| SelfHost theorems | self-host direction + path fixtures | **done (partial):** SelfHost.lean SELF-HOST-THEOREM; empty canaries + selfHostUnitReady_mult1_unminted_false / selfHostUnitReady_mult1_minted_true / selfHostProgramReady_single_value; direction only; proofCompleteClaimed stays false |
| KernelMult theorems | Mult kernel IR readiness + content | **done (partial):** KernelMult.lean KERNEL-MULT-THEOREM; multKernelReady_true + lowerMultKernel_length_three / isWellTyped + multKernelProgram content; proofCompleteClaimed stays false |
| KernelLinear theorems | Linear kernel IR + content | **done (partial):** KernelLinear.lean KERNEL-LINEAR-THEOREM; linearKernelReady_true + lowerLinearKernel_length_one / isWellTyped + linearKernelProgram content; proofCompleteClaimed stays false |
| ParityMult theorems | Mult grades closed-loop + content equality | **done (partial):** ParityMult.lean PARITY-MULT-THEOREM; multParityReady_true + gradeParityOk_true + ofNatRoundTrip_tag* / isValidTag_tag* / nameParity_mult* / enumTag_multC* / product*Api_eq; Mult grades only; proofCompleteClaimed stays false |
| KernelTypes theorems | Types kernel IR readiness + content | **done (partial):** KernelTypes.lean KERNEL-TYPES-THEOREM; typesKernelReady_true + lowerTypesKernel_length_three / isWellTyped + typesKernelProgram content; proofCompleteClaimed stays false |
| KernelProgram theorems | program / graph / compose kernel | **done (partial):** KernelProgram.lean KERNEL-PROGRAM-THEOREM; programKernelReady_true + lowerProgramKernel_length_three / isWellTyped + programKernelProgram content; program/graph/compose content; proofCompleteClaimed stays false |
| KernelEmit theorems | codegen host honesty + content | **done (partial):** KernelEmit.lean KERNEL-EMIT-THEOREM; emitKernelReady_true + lowerEmitCompose_isSome / plan_counts / apply_tags / body_fragment; codegen content; proofCompleteClaimed stays false |
| ParityLinear theorems | Linear freestanding path + product API content | **done (partial):** ParityLinear.lean PARITY-LINEAR-THEOREM; linearParityReady_true + productLinearConsumeApi_eq / productApiSurfaceOk_true; Linear freestanding path only; proofCompleteClaimed stays false |
| ParityTypes theorems | Types freestanding path + product API content | **done (partial):** ParityTypes.lean PARITY-TYPES-THEOREM; typesParityReady_true + productTypedIrId_eq / productApiSurfaceOk_true; Types freestanding path only; proofCompleteClaimed stays false |
| ParityProgram theorems | Program freestanding path + product API content | **done (partial):** ParityProgram.lean PARITY-PROGRAM-THEOREM; programParityReady_true + productIrProgramApi_eq / productApiSurfaceOk_true; Program freestanding path only; proofCompleteClaimed stays false |
| ParityEmit theorems | Emit freestanding path + product API content | **done (partial):** ParityEmit.lean PARITY-EMIT-THEOREM; emitParityReady_true + productEmitPlanApi_eq / productApiSurfaceOk_true; Emit freestanding path only; proofCompleteClaimed stays false |
| SurfaceMatrix theorems | surface inventory + path fixtures | **done (partial):** SurfaceMatrix.lean SURFACE-MATRIX-THEOREM; empty canaries + matrixUnitReady_mult1_unminted_false / matrixUnitReady_mult1_minted_true / matrixProgramReady_single_value; proofCompleteClaimed stays false |
| SelfApply theorems | host structural self-apply readiness | **done (partial):** SelfApply.lean SELF-APPLY-THEOREM; selfApplyReady_true + kernelRebuildsKernel_true; host structural only; proofCompleteClaimed stays false |
| SelfApplyFs theorems | freestanding self-apply path readiness | **done (partial):** SelfApplyFs.lean SELF-APPLY-FS-THEOREM; freestandingSelfApplyReady_true + freestandingProductSelfHostComplete_false; complete stays false; proofCompleteClaimed stays false |
| InventoryClose theorems | inventory close readiness canaries | **done (partial):** InventoryClose.lean INVENTORY-CLOSE-THEOREM; inventoryCloseReady_true + residualFreeClaimed_false; residual free stays false; proofCompleteClaimed stays false |
| ProductPath theorems | product path readiness canaries | **done (partial):** ProductPath.lean PRODUCT-PATH-THEOREM; productPathReady_true + productPathCloseReady_true + residualFreeClaimed_false; no alias theater growth; proofCompleteClaimed stays false |
| DualResidual theorems | dual residual honesty canaries | **done (partial):** DualResidual.lean DUAL-RESIDUAL-THEOREM; dualResidualReady_true + both residuals remain; proofCompleteClaimed stays false |
| ProbeWire theorems | probe-vs-wire honesty canaries | **done (partial):** ProbeWire.lean PROBE-WIRE-THEOREM; probeWireReady_true + behavioralProbeIsSmokeDebt_true; proofCompleteClaimed stays false |
| SpecProof theorems | formal feedback honesty canaries | **done (partial):** SpecProof.lean SPEC-PROOF-THEOREM; specProofReady_true + proofCompleteClaimed_false (proved false); not proof complete |
| LlvmHold theorems | SH6 hold honesty canaries | **done (partial):** LlvmHold.lean LLVM-HOLD-THEOREM; llvmHoldReady_true + llvmUnlocked_false; hold not unlock; proofCompleteClaimed stays false |

**Systems living residual:** `RESIDUAL-systems.md` **Open** queue (plain Names).
Do not re-paste greppable token maps here. Evidence tokens stay in Lean / Nix /
companions.

### Systems Open (join)

| Name | Status | Owner detail |
|------|--------|--------------|
| Self-host body | **done** (partial) | `RESIDUAL-systems.md` -- SELF-HOST-BODY acceptance + SelfHostBody.lean; complete/free stay false |
| Dual algorithms into Slake | **done** (partial) | `RESIDUAL-systems.md` -- join-map.md + JoinMap.joinAlgUseOk three dual host uses; dual trees read-only; free/complete stay false |
| Thin process glue | **done** | `RESIDUAL-systems.md` -- shell ownership note; compile-path stamp only; static pure Nix; free/complete stay false |

**Open queue empty (done-for-now).** No invent Open Names. Still not residual
free; freestanding product self-host complete still false; proof complete false;
llvm / CompCert PROVABLY deferred. Watcher: `WATCHER.md` (blocked / done-for-now).

---

## Hold / deferred / blocked

| Item | Status | Why |
|------|--------|-----|
| LLVM IR emit | deferred | Until freestanding self-host is real |
| CompCert product seal | deferred | Needs real `ccomp` + evidence matrix; never forge |
| Further duals beyond three algorithm ids | deferred | Invent only for named map gaps |
| Freestanding product residual free | not claimed | Host elaborator residual != product residual |
| Host readiness canaries only | deferred as residual | Exhausted under current surface |

Historical compile/emit product-wire capabilities through emit body are **done**
under Join done and `RESIDUAL-systems.md` Done archive. Still **not residual free**.

---

## Join status (auto-refreshed by `just progress` / `just watch`)

See live meter: `doc/PROGRESS.md` (generated). Do not hand-edit percentage tables there; edit evidence (side files + side residuals) instead.

---

## Foundation done

Tooling, charter, submodules, fork prompts, hygiene, Nix, just -- see `AGENTS.md`.

---

## Coordinator actions

- Read all fork residuals + `doc/PROGRESS.md` (join honesty; optional coordinator session).
- Write short directives in `doc/fork-guidance-idris.md`, `doc/fork-guidance-lean.md`, `doc/fork-guidance-systems.md`.
- Run `just watch` (300s loop) or `just progress` (once) while forks run.
- Do not race Idris / Lean / systems trees unless reassigned.
- Join-done history through frozen freestanding emit product wire is closed (see **Join done**). Lean host deepen continues under Mult..SpecProof (after HOST-SPEC-PROOF formal spec-proof separation); freeze C emit growth: **systems fork** owns residual (`RESIDUAL-systems.md`).

---

## Isolation

This repository **is** Systems Lean. Off-repo only if the human is desperate for a named fix.

## Watcher

Next implement prompt: root **`WATCHER.md`** (`WATCHER_BEGIN` ... `WATCHER_END`). This file is the status ledger only.
