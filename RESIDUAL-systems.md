# Residual -- Systems / Slake (`src/systems/`)

Owned by the Systems / Slake implement fork (`doc/fork-systems.md`).
Coordinator reads this file; does not drive the freestanding treadmill by default.

**Status vocabulary:** `open` | `in progress` | `done` | `blocked` | `wontfix`

Re-read `doc/fork-guidance-systems.md` at the start of every implement loop.

**Honesty:** green milestones on `doc/PROGRESS.md` are not residual closed. Keep this ledger current.

**Language:** **Systems / Slake**, **Idris side**, **Lean side**, **coordinator**. Do not say "pole."

---

## Done (skeleton / unit surface / compile path V0+V1 / join map / self-host direction / surface matrix / Mult kernel IR SH1 / host Mult emit SH2 / Mult closed-loop parity SH3 / Linear kernel SH4 start / self-apply SH5 partial / freestanding self-apply SH5 deepen / llvm hold SH6 documented / self-host acceptance SH0 / emit wire history / unit deepen / fail-closed / host / typed IR / ordered program / graph edges / host compose / emit plan/apply/body / HOST-COMPILE-PATH / HOST-JOIN-MAP / HOST-SELF-HOST / HOST-SURFACE-MATRIX / SYSTEMS_LEAN_HOST partial)

| Item | Status | Paths |
|------|--------|--------|
| Systems README + product bar | **done** | `src/systems/README.md` |
| Shared IR sketch (design) | **done** (coordinator) | `doc/shared-ir-sketch.md` |
| Layout stubs types/mult/linear/erasure/extract | **done** | `*.md` + `*.slake` under `src/systems/` |
| Presence gate (static skeleton / unit-surface / host tokens + tree-wide jargon) | **done** (pure Nix) | `nix/systems-host-presence/` (`just systems-host`, flake `systems-host-presence`); bans pole+spine tree-wide under `src/systems` (md/slake/lean/c/h) |
| Emit-wire + unit walk + UNIT_DEEPEN presence | **done** (pure Nix) | `nix/systems-emit-wire/` (`just systems-emit-wire`, flake `systems-emit-wire`); requires drivers, emit product, + hosted probe path `src/systems/smoke/slake_behavioral_probe.c`; residual shell `check.sh` = optional Lake + driver runs + compile/link/run smoke |
| Honest multi-tier build path | **done** | `script/build-systems.sh` (SKELETON + UNIT_SURFACE + compile path) |
| First freestanding unit surface (beyond pure SKELETON) | **done** | Five modules `UNIT_SURFACE`; check requires at least one + content bar |
| Real freestanding compile path (structure stage) | **done** | `script/slake-compile-path.sh` stage id `SLAKE_COMPILE_PATH_V0`; **not** product C |
| Host-informed compile path V1 | **done** (partial) | `SystemsLean/CompilePath.lean` stage `SLAKE_COMPILE_PATH_V1` / `HOST-COMPILE-PATH`; behavioral COMPILE-PATH-SMOKE; V0 structure remains; **not** product C; still **not residual free** |
| Real freestanding emit path V0 + populate `out/freestanding-c` | **done** (frozen wire) | `script/slake-emit-freestanding-c.sh` stage id `SLAKE_EMIT_FREESTANDING_C_V0`; writes `src/systems/emit/slake_freestanding.{c,h}`; `just out-freestanding-c` clean-installs to release; still **not residual free** |
| Unit deepen + first real unit translation | **done** | `UNIT_DEEPEN_V1` + `UNIT_TRANSLATION_V0` emit APIs; still **not residual free** |
| Fail-closed checker + extract path V1 | **done** | `FAIL_CLOSED_CHECKER_V1` in emit; still **not residual free** |
| ConsumeToken-class freestanding host V0 | **done** | `CONSUME_TOKEN_HOST_V0` in emit; dual cite only; still **not residual free** |
| Richer typed IR surface V0 | **done** | `TYPED_IR_V0` in emit; still **not residual free** |
| Multi-node ordered IR program V0 | **done** | Stage id `IR_PROGRAM_V0` (ordered node list; renamed from banned metaphor id); still **not residual free** |
| Naming cleanup: ban metaphor stage id | **done** | Greppable `IR_PROGRAM_V0` (ordered IR program); product prose scrubbed; AGENTS ban remains |
| IR graph edges V0 | **done** | `IR_GRAPH_EDGES_V0` in emit; still **not residual free** |
| Host compose V0 | **done** | `HOST_COMPOSE_V0` in emit; still **not residual free** |
| Emit plan / apply / body V0 | **done** (frozen wire) | `EMIT_PLAN_V0` / `EMIT_APPLY_V0` / `EMIT_BODY_V0`; still **not residual free** |
| EMIT_MODULE_V0 (accidental wire sketch) | **discarded / frozen out** | Unstaged generator growth reverted; product wire ends at EMIT_BODY_V0; do not re-add as residual progress |
| Dual pair join-ready (inputs) | **done** (sides) | Idris/Lean maps + JOIN + divergence edges |
| Lake package + Mult/Linear Lean host | **done** (partial) | `SYSTEMS_LEAN_HOST` partial: `lean-toolchain`, `lakefile.toml`, `lake-manifest.json`, `SystemsLean.lean`, `SystemsLean/Mult.lean`, `SystemsLean/Linear.lean`; still **not residual free**; not PROVABLY |
| SYSTEMS_LEAN_HOST: Types + ordered IR program | **done** (partial) | `SystemsLean/Types.lean` (COMMON-UNIVERSE TypeTag, NodeKind, IrNode, kind/mult pairing, FAIL-CLOSED-UNKNOWN-KIND); `SystemsLean/IrProgram.lean` (ORDERED-IR-PROGRAM node list cap 8, push, foldWellTyped, EMPTY-PROGRAM-FAIL-CLOSED); wired in `SystemsLean.lean` + presence gate; still **not residual free**; not PROVABLY |
| SYSTEMS_LEAN_HOST: Erasure + Extract | **done** (partial) | `SystemsLean/Erasure.lean` (Erased, mark / isRuntimeAbsent / markForGrade?, ERASE-RULE-MULT-0 / ERASE-NO-RUNTIME, EDGE-PROP / ERASE-PROP); `SystemsLean/Extract.lean` (RuntimeClaim runtimeFs/runtimeClassic/edgeRuntime, EMIT-BOUNDARY, extractOk / checkFailClosed); wired + presence gate; still **not residual free**; not PROVABLY |
| SYSTEMS_LEAN_HOST: IrGraph + HostCompose | **done** (partial) | `SystemsLean/IrGraph.lean` (Graph embeds Program + edges, edgeMax 16 / SLAKE_IR_EDGE_MAX, pushNode / addEdge fail-closed, EMPTY-GRAPH-OK, IR-GRAPH-EDGES honesty); `SystemsLean/HostCompose.lean` (Host = Graph + LinearHost + Erased; mint/consume/markErased/pushNode/addEdge; multPreScan + checkFailClosed/extractOk closes MULT-1 live gap; HOST-COMPOSE partial vs full C); wired + presence gate; still **not residual free**; not PROVABLY |
| SYSTEMS_LEAN_HOST: EmitPlan + EmitApply + EmitBody | **done** (partial) | `SystemsLean/EmitPlan.lean` / `EmitApply.lean` / `EmitBody.lean` (plan/apply/body; EMIT-*-SMOKE); **HOST-EMIT-SSOT** on EmitBody (`buildFragment` + `emptyComposeFragmentSsot` + `emit/host_emit_body_fragment.ssot.txt`); bash NON-SSOT for fragment; PARTIAL String vs C char buf; wired + presence; still **not residual free**; not PROVABLY |
| SYSTEMS_LEAN_HOST + unit-surface presence -> pure Nix | **done** | `nix/systems-host-presence/` + flake check `systems-host-presence` + `just systems-host`; **static** required paths + fixed tokens (skeleton docs/slake, Lake pins, Mult..ProductPath) + tree-wide pole+spine jargon walk; still presence-only; Lake `example` smokes remain in `.lean`. |
| Emit-wire greps + unit walk -> pure Nix | **done** | `nix/systems-emit-wire/` + flake `systems-emit-wire` + `just systems-emit-wire`; drivers/UNIT_DEEPEN/emit stages UNIT_TRANSLATION..EMIT_BODY + unit-surface walk + optional release; later `check.sh` thinned again via external probe (see below). |
| Behavioral probe out of check.sh | **done** | Probe source `src/systems/smoke/slake_behavioral_probe.c` (hosted smoke debt, not product emit residual); pure Nix presence fail-closed; `check.sh` ~1736 -> ~228 lines; still not residual free. |
| Tree-wide banned-jargon greps -> pure Nix | **done** | Host-presence walk under `src/systems` (`.md`/`.slake`/`.lean`/`.c`/`.h`); pole+spine case-folded; shell mill removed from `check.sh`. |
| P0.1 shell static mills | **done** | Remaining `check.sh` (~228) is process-only: optional Lake, driver runs, freestanding compile + link/run smoke. No more static greps to port. |
| P0.2 elaborators in devShell | **done** | Flake `devShells.default`: `elan` (install pin from lean-toolchain) + `idris2`. Not `pkgs.lean4` (lags v4.32.0 pin). Checks still skip Lake when pin absent. |
| P1 host PARTIAL inventory + close | **done** | `src/systems/host-partial-inventory.md` (HOST-PARTIAL-INVENTORY; **CLOSABLE-MISS-COUNT-0**); Mult..ProductPath all OK or intentional PARTIAL (ladder grew through P2/P3/P4/P5/P7 + SH0..SH6 hold + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH); companion mult.md / linear.md Lean host tables; presence tokens for inventory path; still **not residual free** |
| P3 host-informed compile path V1 | **done** (partial) | `SystemsLean/CompilePath.lean` stage **SLAKE_COMPILE_PATH_V1** / **HOST-COMPILE-PATH**; compileReady / unitCompileReady / programCompileReady + COMPILE-PATH-SMOKE; V0 structure driver remains; still **not residual free**; not product C |
| P4 join map into Slake | **done** (partial) | `SystemsLean/JoinMap.lean` stage **SLAKE_JOIN_MAP_V0** / **HOST-JOIN-MAP**; joinUnitCompileReady / joinProgramCompileReady + JOIN-MAP-SMOKE; duals read-only cite; still **not residual free**; not product C; not formal full bridge theorems |
| P5 self-host direction readiness | **done** (partial) | `SystemsLean/SelfHost.lean` stage **SLAKE_SELF_HOST_V0** / **HOST-SELF-HOST**; selfHostUnitReady / selfHostProgramReady + SELF-HOST-SMOKE; join + host surface composition; still **not residual free**; **not** self-host complete; classic elaborator residual remains; llvm still deferred |
| P7 superset surface matrix | **done** (partial) | `SystemsLean/SurfaceMatrix.lean` + `surface-matrix.md` stage **SLAKE_SURFACE_MATRIX_V0** / **HOST-SURFACE-MATRIX**; matrixUnitReady / matrixProgramReady + SURFACE-MATRIX-SMOKE; progressive present-partial vs open; still **not residual free**; **not** full Idris+Lean parity; does not unlock llvm |
| SH0 freestanding self-host acceptance | **done** (partial) | `src/systems/self-host.md` SELF-HOST-ACCEPTANCE; product wire / host model (not AI) jargon; phases SH0..SH6 hold |
| SH1 Mult kernel IR | **done** (partial) | `SystemsLean/KernelMult.lean` **SLAKE_SELF_HOST_KERNEL_MULT_V0** / **SELF-HOST-KERNEL-MULT**; lowerMultKernel / multKernelReady + KERNEL-MULT-SMOKE; structural host model of Mult as ordered IR; still **not residual free**; not product parity |
| SH2 host-owned Mult product emit | **done** (partial) | `SystemsLean/EmitMult.lean` **SLAKE_SELF_HOST_EMIT_MULT_V0** / **HOST-EMIT-MULT**; multHeaderFragment / multBodyFragment / emitMultReady + EMIT-MULT-SMOKE; durable `emit/host_emit_mult.ssot.txt`; bash NON-SSOT Mult embed; still **not residual free**; no EMIT_MULT_V0 residual C stage |
| SH3 Mult closed-loop parity | **done** (partial) | `SystemsLean/ParityMult.lean` **SLAKE_SELF_HOST_PARITY_MULT_V0** / **HOST-PARITY-MULT** / **SELF-HOST-PARITY-MULT**; multParityReady / gradeParityOk + PARITY-MULT-SMOKE; product Mult is_valid/is_known/name/tag checks in `smoke/slake_behavioral_probe.c`; still **not residual free**; Mult grades only; not self-host complete |
| Mult+Linear freestanding Linear path parity | **done** (partial) | `SystemsLean/ParityLinear.lean` **SLAKE_SELF_HOST_PARITY_LINEAR_V0** / **HOST-PARITY-LINEAR** / **SELF-HOST-PARITY-LINEAR**; linearParityReady / linearContractParityOk / multLinearParityReady + PARITY-LINEAR-SMOKE; product linear_token + CONSUME_TOKEN probe labels; composes KernelLinear + ParityMult; still **not residual free**; not freestanding product self-host complete |
| Mult+Linear+Types freestanding Types path parity | **done** (partial) | `SystemsLean/ParityTypes.lean` **SLAKE_SELF_HOST_PARITY_TYPES_V0** / **HOST-PARITY-TYPES** / **SELF-HOST-PARITY-TYPES**; typesParityReady / typesContractParityOk / multLinearTypesParityReady + PARITY-TYPES-SMOKE; product TYPED_IR / slake_ir_node probe labels; composes KernelTypes + ParityLinear; still **not residual free**; not freestanding product self-host complete |
| Mult+Linear+Types+Program freestanding Program path parity | **done** (partial) | `SystemsLean/ParityProgram.lean` **SLAKE_SELF_HOST_PARITY_PROGRAM_V0** / **HOST-PARITY-PROGRAM** / **SELF-HOST-PARITY-PROGRAM**; programParityReady / programContractParityOk / multLinearTypesProgramParityReady + PARITY-PROGRAM-SMOKE; product IR_PROGRAM / IR_GRAPH / HOST_COMPOSE probe labels; composes KernelProgram + ParityTypes; still **not residual free**; not freestanding product self-host complete |
| Mult+Linear+Types+Program+Emit freestanding Emit path parity | **done** (partial) | `SystemsLean/ParityEmit.lean` **SLAKE_SELF_HOST_PARITY_EMIT_V0** / **HOST-PARITY-EMIT** / **SELF-HOST-PARITY-EMIT**; emitParityReady / emitContractParityOk / multLinearTypesProgramEmitParityReady + PARITY-EMIT-SMOKE; product EMIT_PLAN / EMIT_APPLY / EMIT_BODY probe labels; composes KernelEmit + ParityProgram; no new EMIT_* C stage; still **not residual free**; not freestanding product self-host complete |
| SH4 Linear kernel start | **done** (partial) | `SystemsLean/KernelLinear.lean` **SLAKE_SELF_HOST_KERNEL_LINEAR_V0** / **SELF-HOST-KERNEL-LINEAR** / **HOST-KERNEL-LINEAR**; lowerLinearKernel / linearHostPathReady / linearKernelReady + KERNEL-LINEAR-SMOKE; Linear ordered IR + HostCompose mint/consume path; still **not residual free**; SH5 compose is SelfApply |
| SH4 Types kernel growth | **done** (partial) | `SystemsLean/KernelTypes.lean` **SLAKE_SELF_HOST_KERNEL_TYPES_V0** / **SELF-HOST-KERNEL-TYPES** / **HOST-KERNEL-TYPES**; lowerTypesKernel / typesProgramPathReady / typesKernelReady + KERNEL-TYPES-SMOKE; Types / typed IR + foldWellTyped program path; still **not residual free** |
| SH4 Program kernel growth | **done** (partial) | `SystemsLean/KernelProgram.lean` **SLAKE_SELF_HOST_KERNEL_PROGRAM_V0** / **SELF-HOST-KERNEL-PROGRAM** / **HOST-KERNEL-PROGRAM**; lowerProgramKernel / programPathReady / programGraphPathReady / programComposePathReady / programKernelReady + KERNEL-PROGRAM-SMOKE; ordered IR + graph edges + HostCompose path; still **not residual free** |
| SH4 Emit / codegen host honesty | **done** (partial) | `SystemsLean/KernelEmit.lean` **SLAKE_SELF_HOST_KERNEL_EMIT_V0** / **SELF-HOST-KERNEL-EMIT** / **HOST-KERNEL-EMIT**; lowerEmitCompose / emitPlanPathReady / emitApplyPathReady / emitBodyPathReady / emitKernelReady + KERNEL-EMIT-SMOKE; program kernel + plan/apply/body + Mult emit; no new EMIT_* C stage; still **not residual free**; product wire bulk still frozen at EMIT_BODY_V0 except HOST-EMIT-SSOT + HOST-EMIT-MULT |
| SH5 compiler self-application | **done** (partial) | `SystemsLean/SelfApply.lean` **SLAKE_SELF_HOST_SELF_APPLY_V0** / **HOST-SELF-APPLY** / **SELF-HOST-SELF-APPLY**; selfApplyReady / kernelRebuildsKernel = multParityReady && linearKernelReady && typesKernelReady && programKernelReady && emitKernelReady + surface; SELF-APPLY-SMOKE; host structural kernel-rebuilds-kernel only; still **not residual free**; **not** freestanding product self-host complete; SH6 llvm / PROVABLY still **held** |
| SH5 freestanding self-apply deepen | **done** (partial) | `SystemsLean/SelfApplyFs.lean` **SLAKE_SELF_HOST_SELF_APPLY_FS_V0** / **HOST-SELF-APPLY-FS** / **SELF-HOST-SELF-APPLY-FS**; freestandingExtractPathReady (RUNTIME-FS extractOkFs on empty/unminted/lowerEmitCompose); freestandingBodyPathReady (HOST-EMIT-SSOT body + emitMultReady); freestandingParityLadderReady = ParityEmit.multLinearTypesProgramEmitParityReady (Mult..Emit freestanding parity compose; dual freestandingEmitParityReady = emitParityReady -- equivalent under folds, not a stronger gate); freestandingSelfApplyReady = selfApplyReady && path && freestandingParityLadderReady && surface && !complete; freestandingProductSelfHostComplete = false; SELF-APPLY-FS-SMOKE; still **not residual free**; **not** freestanding product self-host complete; SH6 still **held** |
| SH6 llvm / PROVABLY hold gate | **held (documented)** | `SystemsLean/LlvmHold.lean` **SLAKE_SELF_HOST_LLVM_HOLD_V0** / **HOST-LLVM-HOLD** / **SELF-HOST-LLVM-HOLD** / **HOST-PROVABLY-HOLD**; llvmHoldReady / sh6HoldReady true; llvmUnlocked / provablyUnlocked / freestandingProductSelfHostComplete false; LLVM-HOLD-SMOKE; **not** unlock; **not** residual-open llvm mill; still **not residual free**; still **not PROVABLY**; out/llvm-ir still deferred |
| HOST-INVENTORY-CLOSE host inventory close | **done** (partial) | `SystemsLean/InventoryClose.lean` **SLAKE_SELF_HOST_INVENTORY_CLOSE_V0** / **HOST-INVENTORY-CLOSE** / **SELF-HOST-INVENTORY-CLOSE**; inventoryCloseReady = freestandingSelfApplyReady && llvmHoldReady && surface && partialCarry && !complete && !llvmUnlocked && !provablyUnlocked; residualFreeClaimed false; inventoryCloseDoesNotMeanResidualFree; INVENTORY-CLOSE-SMOKE; Mult..InventoryClose (30 modules before ProductPath); still **not residual free**; **not** freestanding product self-host complete; intentional PARTIAL carry |
| HOST-PRODUCT-PATH freestanding product path | **done** (partial) | `SystemsLean/ProductPath.lean` **SLAKE_SELF_HOST_PRODUCT_PATH_V0** / **HOST-PRODUCT-PATH** / **SELF-HOST-PRODUCT-PATH**; productPathReady = inventoryCloseReady && freestandingUnitProductPathReady && freestandingProgramProductPathReady && surface && !residual free claimed && !product complete claimed && !SelfApplyFs complete && !llvm unlock && !provably unlock; freestandingUnitProductPathReady unitCompileReady / extractOkFs empty/unminted/lowerEmitCompose; sibling freestandingProgramProductPathReady empty fail-closed + lowered kernel; productPathDoesNotComplete / productPathDoesNotMeanResidualFree; PRODUCT-PATH-SMOKE; Mult..ProductPath (31 modules); still **not residual free**; **not** freestanding product self-host complete; intentional PARTIAL carry |

---

## Priority residual (Systems / Slake only)

| Priority | Item | Status | Acceptance / notes |
|----------|------|--------|--------------------|
| 0 | Freeze C emit ladder as product wire only | **done** | No further `EMIT_*` residual treadmill; keep gates green; never residual free |
| 1 | SYSTEMS_LEAN_HOST: Mult + Linear Lean modules | **done** (partial) | Inductive Mult closed; typed `isValid` total-true by match; raw-tag FAIL-CLOSED-UNKNOWN-GRADE via `ofNat?` / `isValidTag`; Linear ConsumeToken axioms + JOIN-ALG; Lake offline pin v4.32.0 |
| 2 | SYSTEMS_LEAN_HOST: Types + ordered IR program in Lean | **done** (partial) | Types.lean + IrProgram.lean landed; kind/mult + empty-program fail-closed; emit map honesty only; still not residual free |
| 3 | SYSTEMS_LEAN_HOST: Erasure + Extract in Lean | **done** (partial) | Erasure.lean + Extract.lean landed; three-way RuntimeClaim; fail-closed mark/absent + RUNTIME-FS-only extract; still not residual free |
| 3b | SYSTEMS_LEAN_HOST: host compose + graph edges in Lean | **done** (partial) | IrGraph.lean + HostCompose.lean landed; mult pre-scan closes MULT-1 live gap; PARTIAL vs full C HOST_COMPOSE_V0 (typed results, no null wire codes); still not residual free |
| 4 | Naming cleanup: retire banned metaphor jargon | **done** | Stage id `IR_PROGRAM_V0`; product/docs scrubbed; ban greps keep the forbidden word only to reject it |
| 4b | SYSTEMS_LEAN_HOST: emit plan/apply/body host honesty | **done** (partial) | EmitPlan + EmitApply + EmitBody landed; host ladder through body inventory; still not residual free; not PROVABLY; not freestanding C generation |
| P1 | Close host PARTIAL vs wire (inventory + misses) | **done** | P1.1 inventory + P1.2/P1.3 empty closable list + HOST-INVENTORY-CLOSE readiness gate + HOST-PRODUCT-PATH path readiness; see `host-partial-inventory.md` Mult..ProductPath; intentional PARTIAL carry |
| P2 | Host-driven emit (EMIT_BODY fragment SSoT) | **done** (partial) | **HOST-EMIT-SSOT**: `EmitBody.buildFragment` + `emit/host_emit_body_fragment.ssot.txt`; bash `slake-emit-freestanding-c.sh` is **NON-SSOT** (reads artifact, embeds dialect); presence gates require SSOT path + tokens; still not residual free; full C ladder remains frozen wire |
| P3 | Real Slake compile path (host-informed V1) | **done** (partial) | **HOST-COMPILE-PATH** / `SLAKE_COMPILE_PATH_V1` in `CompilePath.lean`; unit bar = extractOkFs + gradeSurfaceOk; program bar = IrProgram.isWellTyped (sibling; EMPTY-PROGRAM-FAIL-CLOSED); empty host OK != empty program OK; V0 structure shell remains; not freestanding product compile; still not residual free |
| P4 | Join map into Slake | **done** (partial) | **HOST-JOIN-MAP** / `SLAKE_JOIN_MAP_V0` in `JoinMap.lean`; joinUnitCompileReady = unitCompileReady && joinAlgContractOk; joinProgramCompileReady sibling; duals read-only; JOIN-MAP-SMOKE; not formal full bridge theorems; still not residual free |
| P5 | Self-host direction readiness | **done** (partial) | **HOST-SELF-HOST** / `SLAKE_SELF_HOST_V0` in `SelfHost.lean`; selfHostUnitReady = joinUnitCompileReady && hostSurfaceOk; selfHostProgramReady sibling; SELF-HOST-SMOKE; not freestanding product self-host complete; classic elaborator residual remains; still not residual free; does not unlock llvm |
| P7 | Superset surface matrix | **done** (partial) | **HOST-SURFACE-MATRIX** / `SLAKE_SURFACE_MATRIX_V0` in `SurfaceMatrix.lean` + `surface-matrix.md`; matrixUnitReady = selfHostUnitReady && matrixSurfaceOk; matrixProgramReady sibling; SURFACE-MATRIX-SMOKE; present-partial host rows; open parity/llvm/PROVABLY rows stay open; not day-one full parity; still not residual free; does not unlock llvm |
| 5 | CompCert PROVABLY path | **hold** | Real `ccomp` + matrix only; HOST-PROVABLY-HOLD documents hold (provablyUnlocked = false) |
| 6 | `out/llvm-ir` | **hold** | Deferred until true freestanding product self-host (SH5 partial does **not** unlock; SH6 held documented via HOST-LLVM-HOLD; llvmUnlocked = false) |

Historical C stages (UNIT_SURFACE through EMIT_BODY) remain **emit wire history** under `src/systems/emit/` -- not the place Systems Lean is implemented.

**Shell debt (check.sh):** Static host presence + tree-wide jargon + emit-wire greps + unit-surface walk + probe path presence are pure Nix (`nix/systems-host-presence/`, `nix/systems-emit-wire/`). Remaining shell (~228 lines) owns: optional Lake elaborator, compile/emit **driver runs**, freestanding-first compile smoke + `cc` link/run of external probe. Probe C is **smoke debt** under `src/systems/smoke/` (not freestanding product residual progress). Do not re-grow static greps; do not fatten frozen C-stage gates. Solo `check.sh` is incomplete without `just systems-host` + `just systems-emit-wire`.

**Flake staging (human):** `nix flake check` needs git-tracked paths. Until staged, use impure `just systems-host` + `just systems-emit-wire` as local green presence gates. Stage set (full untracked set flake may need): `nix/systems-host-presence/` (incl. jargon walk), `nix/systems-emit-wire/` (incl. probe path + HOST-EMIT-SSOT + HOST-EMIT-MULT + HOST-PARITY-MULT + HOST-PARITY-LINEAR + HOST-PARITY-TYPES + HOST-PARITY-PROGRAM + HOST-PARITY-EMIT probe tokens), `src/systems/smoke/`, `src/systems/emit/host_emit_body_fragment.ssot.txt`, `src/systems/emit/host_emit_mult.ssot.txt`, `src/systems/lakefile.toml`, `src/systems/lean-toolchain`, `src/systems/lake-manifest.json`, `src/systems/SystemsLean.lean`, `src/systems/SystemsLean/*.lean` host modules (incl. EmitMult.lean + ParityMult.lean + KernelLinear.lean + ParityLinear.lean + KernelTypes.lean + ParityTypes.lean + KernelProgram.lean + ParityProgram.lean + KernelEmit.lean + ParityEmit.lean + SelfApply.lean + SelfApplyFs.lean + LlvmHold.lean + InventoryClose.lean + ProductPath.lean), flake/just edits. Prefer: all paths under host-presence + emit-wire `requiredFiles` plus smoke probe. Agent hands-off git.

---

## Not this fork

- `src/idris2/**` / `src/lean4/**` product rewrites (read duals only)
- Bridge dual examples under `src/idris2/` / `src/lean4/` (read only; those forks own duals)
- Git commits unless human asks
- Inventing freestanding residual_free or PROVABLY claims
- **Any new freestanding C or shell as residual progress** (human delete-on-sight; see `AGENTS.md`)
- Growing `script/slake-emit-freestanding-c.sh`, fattening `check.sh`, or new `EMIT_*` stages

---

## Highest value next

**Freestanding self-host track open (SH0..SH5 partial + SH5 freestanding deepen
with Mult..Emit parity compose; SH6 held documented; HOST-INVENTORY-CLOSE
readiness landed; HOST-PRODUCT-PATH freestanding product path readiness landed;
SH4 host ladder substantially complete).**

North-star: Systems Lean can compile itself to freestanding C with no classic
Lean runtime on the **product wire** (emitted release surface). See
`src/systems/self-host.md` (SELF-HOST-ACCEPTANCE). **Host model** means
structural Lean representation -- not an AI model (`doc/vocabulary.md`).

| Kind | Item | Residual action |
|------|------|-----------------|
| SH0 | SELF-HOST acceptance | **done** (partial): `self-host.md` bar + jargon unpack |
| SH1 | Mult kernel IR | **done** (partial): `KernelMult.lean` lowerMultKernel / multKernelReady + KERNEL-MULT-SMOKE |
| SH2 | Host-owned Mult product emit | **done** (partial): `EmitMult.lean` + `host_emit_mult.ssot.txt`; bash NON-SSOT Mult embed; no EMIT_MULT_V0 stage |
| SH3 | Mult closed loop parity | **done** (partial): `ParityMult.lean` multParityReady + probe Mult name/is_known/tag |
| SH3b | Mult+Linear freestanding Linear path | **done** (partial): `ParityLinear.lean` linearParityReady / multLinearParityReady + probe linear_token + CONSUME_TOKEN labels |
| SH3c | Mult+Linear+Types freestanding Types path | **done** (partial): `ParityTypes.lean` typesParityReady / multLinearTypesParityReady + probe TYPED_IR / slake_ir_node labels |
| SH3d | Mult+Linear+Types+Program freestanding Program path | **done** (partial): `ParityProgram.lean` programParityReady / multLinearTypesProgramParityReady + probe IR_PROGRAM / IR_GRAPH / HOST_COMPOSE labels |
| SH3e | Mult+Linear+Types+Program+Emit freestanding Emit path | **done** (partial): `ParityEmit.lean` emitParityReady / multLinearTypesProgramEmitParityReady + probe EMIT_PLAN / EMIT_APPLY / EMIT_BODY labels; no new EMIT_* C stage |
| SH4 | Grow kernel toward the Slake body | **done** (partial growth): `KernelLinear` + `KernelTypes` + `KernelProgram` + `KernelEmit` (plan/apply/body codegen host honesty over program kernel); product wire bulk still frozen; no new EMIT_* C stage |
| SH5 | Compiler self-application | **done** (partial): `SelfApply.lean` selfApplyReady / kernelRebuildsKernel; host structural Mult+Linear+Types+Program+Emit only -- not freestanding product self-host complete |
| SH5 deepen | Freestanding self-apply path | **done** (partial): `SelfApplyFs.lean` freestandingExtractPathReady + freestandingBodyPathReady + freestandingParityLadderReady (Mult..Emit parity compose) + freestandingSelfApplyReady; freestandingProductSelfHostComplete = false -- not product freestanding self-host complete |
| SH6 | llvm / PROVABLY | **held (documented)**: `LlvmHold.lean` llvmHoldReady true; unlock flags false -- not unlocked; not residual mill open |
| Inventory close | Host inventory close readiness | **done** (partial): `InventoryClose.lean` inventoryCloseReady; residualFreeClaimed false -- not residual free; intentional PARTIAL carry |
| Product path | Freestanding product path readiness | **done** (partial): `ProductPath.lean` productPathReady; freestandingUnitProductPathReady + freestandingProgramProductPathReady; residualFreeClaimed false -- not residual free; not freestanding product self-host complete |
| P2..P7 | Prior host maps | **done** (partial): readiness / inventory / direction only |
| Intentional PARTIAL (carry) | List/String host vs C arrays; Mult grades closed loop only; host codegen readiness vs full product emit mill; freestanding path deepen vs freestanding product self-host complete; product path readiness vs freestanding product self-host complete; join/self-host/matrix canaries vs formal duals | document in inventory |
| Process shell residual | check.sh ~228: Lake optional + drivers + smoke | do not grow |
| Explicitly deferred (P6) | CompCert PROVABLY; llvm-ir until true freestanding product self-host | leave until preconditions (hold gate documents; do not open mill) |

**Honesty:** Product wire bulk C still frozen at **EMIT_BODY_V0** except
HOST-EMIT-SSOT fragment dialect and HOST-EMIT-MULT Mult product text. SH3 is
Mult grades closed-loop parity only. HOST-PARITY-LINEAR is Mult+Linear
freestanding Linear path honesty (ParityLinear multLinearParityReady) only.
HOST-PARITY-TYPES is Mult+Linear+Types freestanding Types path honesty
(ParityTypes multLinearTypesParityReady) only. HOST-PARITY-PROGRAM is
Mult+Linear+Types+Program freestanding Program path honesty
(ParityProgram multLinearTypesProgramParityReady) only. HOST-PARITY-EMIT is
Mult+Linear+Types+Program+Emit freestanding Emit path honesty
(ParityEmit multLinearTypesProgramEmitParityReady) only. SH4 host ladder is
KernelLinear + KernelTypes + KernelProgram + KernelEmit (codegen host honesty).
SH5 is host structural self-application + freestanding extract/body path deepen
+ freestanding Mult..Emit parity ladder compose (SelfApplyFs
freestandingParityLadderReady) -- not residual free, not freestanding product
self-host complete. SH6 is held (documented) via LlvmHold -- not llvm unlock,
not PROVABLY. HOST-INVENTORY-CLOSE is inventory close readiness only (not residual
free). HOST-PRODUCT-PATH is freestanding product path readiness only
(productPathReady; unit/program CompilePath honesty; not residual free; not
freestanding product self-host complete). Highest-value next is further honest
freestanding product path deepen without forging complete -- not bash EMIT_*
theater and not llvm unlock mill.

---

## Next residual implement prompt (Systems / Slake)

```
/implement --effort 1 Systems Lean under src/systems/ ONLY Lean (+ pure Nix if tooling):
SH0..SH5 partial + SH5 freestanding deepen + Mult..Emit freestanding parity +
SH6 hold + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH
(ProductPath.productPathReady; residualFreeClaimed false; Mult..ProductPath 31
modules) landed. Next: further honest freestanding product path deepen without
forging residual free / product complete / llvm unlock; no new EMIT_* C stage;
no grow check.sh; no PROVABLY; no git; no dual race.
Gates: just systems-host; just systems-emit-wire; just hygiene; ./src/systems/check.sh.
```
