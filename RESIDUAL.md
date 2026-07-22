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
| Slake skeleton under `src/systems/` | Layout stubs: `types.md`/`Types.slake`, `mult.md`/`Mult.slake`, `linear.md`/`Linear.slake`, `erasure.md`/`Erasure.slake`, `extract.md`/`Extract.slake`; presence gate `src/systems/check.sh`; honest multi-tier path in `script/build-systems.sh` (SKELETON + UNIT_SURFACE). **Not freestanding residual free.** |
| First freestanding unit surface | Five modules marked `UNIT_SURFACE` with thin abstract surface (grades / linear resource / erasure rule / extract boundary); check requires at least one + content bar; build unit-surface path prints count and refuses product C claim from build alone. |
| Real freestanding compile path (structure stage) | `script/slake-compile-path.sh` stage id `SLAKE_COMPILE_PATH_V0`; wired from `just build` / `script/build-systems.sh`; `src/systems/check.sh` fails closed if driver missing/unwired; `.cache/slake-compile-path/` manifest is **not** product C. |
| Real freestanding emit path V0 + out/freestanding-c populate | `script/slake-emit-freestanding-c.sh` stage id `SLAKE_EMIT_FREESTANDING_C_V0`; writes `src/systems/emit/slake_freestanding.{c,h}`; `just out-freestanding-c` clean-installs into `out/freestanding-c/` (preserves README); still **not residual free**; **not PROVABLY**. |
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

Dual depth (three algorithm ids), metaphor stage-id rename (`IR_PROGRAM_V0`), divergence merge, IR sketch, systems skeleton, unit surface, compile path, and emit V0 wire through EMIT_BODY_V0 are **done**. **Do not** grow freestanding C as a substitute for Idris/Lean duals or Systems Lean host. Active product residual: **Systems / Slake** Lean host deepen (`doc/fork-systems.md`, `RESIDUAL-systems.md`). Watcher session is separate (root `WATCHER.md`).

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
| P0 | Shell/tooling debt | **done (2026-07-22):** static mills pure Nix; `check.sh` process-only (~228); devShell has `elan` + `idris2` (Lean pin via elan, not lagged `pkgs.lean4`) |
| P1 | Systems Lean host close PARTIAL | **done (2026-07-22):** `src/systems/host-partial-inventory.md` CLOSABLE-MISS-COUNT-0; intentional PARTIAL carry |
| P2 | Host drives emit | **done (2026-07-22, partial):** HOST-EMIT-SSOT -- `EmitBody.buildFragment` + `emit/host_emit_body_fragment.ssot.txt`; bash NON-SSOT for EMIT_BODY fragment; full C ladder still frozen wire |
| P3 | Real Slake compile path | **done (2026-07-22, partial):** HOST-COMPILE-PATH / `SLAKE_COMPILE_PATH_V1` in `SystemsLean/CompilePath.lean`; V0 structure shell remains |
| P4 | Join map into Slake | **done (2026-07-22, partial):** HOST-JOIN-MAP / `SLAKE_JOIN_MAP_V0` in `SystemsLean/JoinMap.lean`; duals read-only cite; not formal full bridge theorems |
| P5 | Self-host direction readiness | **done (2026-07-22, partial):** HOST-SELF-HOST / `SLAKE_SELF_HOST_V0` in `SystemsLean/SelfHost.lean`; join + host surface; not freestanding product self-host complete; does **not** unlock llvm alone |
| P6 | llvm-ir / PROVABLY | Explicitly deferred (SH6 **held (documented)**): `LlvmHold.lean` HOST-LLVM-HOLD / HOST-PROVABLY-HOLD; llvmHoldReady true; llvmUnlocked / provablyUnlocked false; true freestanding product self-host required; SH5 partial does **not** unlock; real ccomp + matrix for PROVABLY; **not** residual-open mill |
| P7 | Superset surface matrix | **done (2026-07-22, partial):** HOST-SURFACE-MATRIX / `SLAKE_SURFACE_MATRIX_V0` in `SystemsLean/SurfaceMatrix.lean` + `surface-matrix.md`; progressive present-partial vs open; not day-one full Idris+Lean parity; does **not** unlock llvm |
| SH0 | Freestanding self-host acceptance | **done (2026-07-22, partial):** `src/systems/self-host.md` SELF-HOST-ACCEPTANCE; product wire / host model jargon in vocabulary + AGENTS |
| SH1 | Mult kernel IR | **done (2026-07-22, partial):** `SystemsLean/KernelMult.lean` SLAKE_SELF_HOST_KERNEL_MULT_V0; lowerMultKernel / multKernelReady + KERNEL-MULT-SMOKE |
| SH2 | Host-owned Mult product emit | **done (2026-07-22, partial):** `SystemsLean/EmitMult.lean` HOST-EMIT-MULT / SLAKE_SELF_HOST_EMIT_MULT_V0; multHeaderFragment / multBodyFragment + `emit/host_emit_mult.ssot.txt`; bash NON-SSOT Mult embed |
| SH3 | Mult closed loop parity | **done (2026-07-22, partial):** `SystemsLean/ParityMult.lean` HOST-PARITY-MULT / SLAKE_SELF_HOST_PARITY_MULT_V0; multParityReady + product Mult probe name/is_known/tag; Mult grades only |
| SH3b | Mult+Linear freestanding Linear path parity | **done (2026-07-22, partial):** `SystemsLean/ParityLinear.lean` HOST-PARITY-LINEAR / SELF-HOST-PARITY-LINEAR / SLAKE_SELF_HOST_PARITY_LINEAR_V0; linearParityReady / multLinearParityReady + probe linear_token + CONSUME_TOKEN labels; not freestanding product self-host complete |
| SH3c | Mult+Linear+Types freestanding Types path parity | **done (2026-07-22, partial):** `SystemsLean/ParityTypes.lean` HOST-PARITY-TYPES / SELF-HOST-PARITY-TYPES / SLAKE_SELF_HOST_PARITY_TYPES_V0; typesParityReady / multLinearTypesParityReady + probe TYPED_IR / slake_ir_node labels; not freestanding product self-host complete |
| SH3d | Mult+Linear+Types+Program freestanding Program path parity | **done (2026-07-22, partial):** `SystemsLean/ParityProgram.lean` HOST-PARITY-PROGRAM / SELF-HOST-PARITY-PROGRAM / SLAKE_SELF_HOST_PARITY_PROGRAM_V0; programParityReady / multLinearTypesProgramParityReady + probe IR_PROGRAM / IR_GRAPH / HOST_COMPOSE labels; not freestanding product self-host complete |
| SH3e | Mult+Linear+Types+Program+Emit freestanding Emit path parity | **done (2026-07-22, partial):** `SystemsLean/ParityEmit.lean` HOST-PARITY-EMIT / SELF-HOST-PARITY-EMIT / SLAKE_SELF_HOST_PARITY_EMIT_V0; emitParityReady / multLinearTypesProgramEmitParityReady + probe EMIT_PLAN / EMIT_APPLY / EMIT_BODY labels; no new EMIT_* C stage; not freestanding product self-host complete |
| SH4 | Grow ladder (Linear + Types + Program + Emit) | **done (2026-07-22, partial growth):** `KernelLinear` + `KernelTypes` + `KernelProgram` + `KernelEmit` SELF-HOST-KERNEL-EMIT / HOST-KERNEL-EMIT / SLAKE_SELF_HOST_KERNEL_EMIT_V0; lowerEmitCompose / emitPlanPathReady / emitApplyPathReady / emitBodyPathReady / emitKernelReady + KERNEL-EMIT-SMOKE; host plan/apply/body + Mult emit over program kernel; no new EMIT_* C stage; product wire bulk still frozen |
| SH5 | Compiler self-application | **done (2026-07-22, partial):** `SystemsLean/SelfApply.lean` HOST-SELF-APPLY / SELF-HOST-SELF-APPLY / SLAKE_SELF_HOST_SELF_APPLY_V0; selfApplyReady / kernelRebuildsKernel = Mult closed loop + Linear + Types + Program + Emit kernel; SELF-APPLY-SMOKE; host structural only -- **not** freestanding product self-host complete; **not** residual free |
| SH5 deepen | Freestanding self-apply path | **done (2026-07-22, partial):** `SystemsLean/SelfApplyFs.lean` HOST-SELF-APPLY-FS / SELF-HOST-SELF-APPLY-FS / SLAKE_SELF_HOST_SELF_APPLY_FS_V0; freestandingExtractPathReady + freestandingBodyPathReady + freestandingParityLadderReady (ParityEmit Mult..Emit compose; dual freestandingEmitParityReady) + freestandingSelfApplyReady; freestandingProductSelfHostComplete = false; SELF-APPLY-FS-SMOKE -- **not** freestanding product self-host complete; **not** residual free |
| SH6 | llvm / PROVABLY hold gate | **held (documented, 2026-07-22):** `SystemsLean/LlvmHold.lean` HOST-LLVM-HOLD / SELF-HOST-LLVM-HOLD / HOST-PROVABLY-HOLD / SLAKE_SELF_HOST_LLVM_HOLD_V0; llvmHoldReady / sh6HoldReady true; llvmUnlocked / provablyUnlocked / freestandingProductSelfHostComplete false; LLVM-HOLD-SMOKE -- **not** unlock; still **not residual free**; still **not PROVABLY**; out/llvm-ir still deferred |
| Inventory close | Host inventory close readiness | **done (2026-07-22, partial):** `SystemsLean/InventoryClose.lean` HOST-INVENTORY-CLOSE / SELF-HOST-INVENTORY-CLOSE / SLAKE_SELF_HOST_INVENTORY_CLOSE_V0; inventoryCloseReady; residualFreeClaimed false; inventoryCloseDoesNotMeanResidualFree; INVENTORY-CLOSE-SMOKE; Mult..InventoryClose 30 modules before ProductPath -- **not** residual free; **not** freestanding product self-host complete; intentional PARTIAL carry |
| Product path | Freestanding product path readiness | **done (2026-07-22, partial):** `SystemsLean/ProductPath.lean` HOST-PRODUCT-PATH / SELF-HOST-PRODUCT-PATH / SLAKE_SELF_HOST_PRODUCT_PATH_V0; productPathReady; freestandingUnitProductPathReady + freestandingProgramProductPathReady; residualFreeClaimed false; productPathDoesNotComplete; PRODUCT-PATH-SMOKE; Mult..ProductPath 31 modules -- **not** residual free; **not** freestanding product self-host complete; intentional PARTIAL carry |

**Highest-value next:** further honest freestanding product path deepen -- without forging residual free / product complete / llvm unlock. SH0..SH5 partial + SH5 freestanding deepen (parity ladder compose) + Mult..Emit freestanding parity + SH6 hold + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH landed. P6 llvm/PROVABLY still held (gate module landed; not residual-open mill). Product wire bulk C still frozen at EMIT_BODY_V0 except HOST-EMIT-SSOT fragment + HOST-EMIT-MULT Mult text; not bash EMIT_* theater and not llvm unlock.

---

## Hold / deferred / blocked

| Item | Status | Why |
|------|--------|-----|
| `out/llvm-ir` pipeline | Hold | Deferred until self-hosted Systems Lean / Slake; HOST-LLVM-HOLD documents hold (llvmUnlocked = false) |
| CompCert PROVABLY path | Hold | Needs real `ccomp` + evidence matrix; never forge; HOST-PROVABLY-HOLD documents hold |
| Further duals beyond three algorithm ids | Hold | ConsumeToken + ErasedIndex + UnrestrictedShare current; invent only for named map gaps |
| Freestanding product residual free | Not claimed | Host elaborator residual != product residual; honesty required |
| Wire `just build` freestanding compile (structure path) | **Done** | `SLAKE_COMPILE_PATH_V0` structure validation; still not product C |
| Populate `out/freestanding-c` | **Done** (emit V0 + UNIT_DEEPEN_V1 + FAIL_CLOSED_CHECKER_V1 + CONSUME_TOKEN_HOST_V0 + TYPED_IR_V0 + IR_PROGRAM_V0 + IR_GRAPH_EDGES_V0 + HOST_COMPOSE_V0 + EMIT_PLAN_V0 + EMIT_APPLY_V0 + EMIT_BODY_V0) | `SLAKE_EMIT_FREESTANDING_C_V0`; first unit translation + checker + host + typed IR + ordered IR program + graph edges + host compose + emit plan + emit apply + emit body; not residual free |
| UNIT_DEEPEN_V1 abstract + first unit translation | **Done** | Greppable deepen + C APIs; residual free still unclaimed |
| FAIL_CLOSED_CHECKER_V1 extract path | **Done** | Composed checker + extract; residual free still unclaimed |
| CONSUME_TOKEN_HOST_V0 freestanding host | **Done** | JOIN-ALG ConsumeToken-class host shape; residual free still unclaimed |
| TYPED_IR_V0 richer typed IR surface | **Done** | Single-node kind/mult IR + checker compose; residual free still unclaimed |
| IR_PROGRAM_V0 multi-node ordered IR program | **Done** | Ordered multi-node list + collective check; residual free still unclaimed |
| IR_GRAPH_EDGES_V0 graph edges | **Done** | Index pairs + graph shell; residual free still unclaimed |
| HOST_COMPOSE_V0 host compose | **Done** | Host + graph + erasure fail-closed extract; residual free still unclaimed |
| EMIT_PLAN_V0 emit plan | **Done** | Readiness inventory from host compose; residual free still unclaimed |
| EMIT_APPLY_V0 emit apply | **Done** | Fixed mult/kind tag buffer from host compose; residual free still unclaimed |
| EMIT_BODY_V0 emit body | **Done** | Fixed freestanding C body fragment from host compose; residual free still unclaimed |

---

## Project hold ladder (after dual pair + IR sketch + skeleton + unit surface + compile path + emit V0)

| Priority | Work | When |
|----------|------|------|
| 1 | Shared intermediate-representation sketch | **Done** -- `doc/shared-ir-sketch.md` |
| 2 | Slake skeleton under `src/systems/` | **Done** -- layout stubs + presence gate + honest build path |
| 3 | First freestanding unit surface | **Done** -- `UNIT_SURFACE` five modules + check content bar |
| 4 | Wire `just build` freestanding compile (structure path) | **Done** -- `SLAKE_COMPILE_PATH_V0` (still not product C) |
| 5 | Populate `out/freestanding-c` | **Done** (emit V0 `SLAKE_EMIT_FREESTANDING_C_V0`; not residual free) |
| 6 | CompCert PROVABLY path | Real `ccomp` + matrix |
| 7 | `out/llvm-ir` | Deferred until self-hosted Systems Lean / Slake |

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
- Greppable edge merge into `doc/divergence.md` (done). IR sketch (done). Systems skeleton (done). Unit surface (done). Compile-path structure stage (done). Emit V0 (done). UNIT_DEEPEN_V1 first translation (done). FAIL_CLOSED_CHECKER_V1 (done). CONSUME_TOKEN_HOST_V0 (done). TYPED_IR_V0 (done). IR_PROGRAM_V0 (done). IR_GRAPH_EDGES_V0 (done). HOST_COMPOSE_V0 (done). EMIT_PLAN_V0 (done). EMIT_APPLY_V0 (done). EMIT_BODY_V0 (done).
- Lean host deepen (Mult/Linear/Types/IrProgram/Erasure/Extract/IrGraph/HostCompose/EmitPlan/EmitApply/EmitBody partial; further deepen or Nix presence port next); freeze C emit: **systems fork** owns residual (`RESIDUAL-systems.md`).

---

## Isolation

This repository **is** Systems Lean. Off-repo only if the human is desperate for a named fix.

## Watcher

Next implement prompt: root **`WATCHER.md`** (`WATCHER_BEGIN` ... `WATCHER_END`). This file is the status ledger only.
