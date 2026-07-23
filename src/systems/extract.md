# Extract / emit boundary (unit surface notes)

**Module role:** host elaborator / proofs vs product extract; dual residual honesty.
**Status:** SYSTEMS_LEAN_HOST partial -- `SystemsLean/Extract.lean` (RuntimeClaim
RUNTIME-FS / RUNTIME-CLASSIC / EDGE-RUNTIME; EMIT-BOUNDARY; extractOk /
checkFailClosed as PARTIAL FAIL_CLOSED_CHECKER_V1: MULT-0 + RUNTIME-FS; MULT-1
pass-through without live token; EXTRACT-THEOREM / HOST-EXTRACT-THEOREM real
theorems on RUNTIME-FS-only / FAIL-CLOSED-UNKNOWN-RUNTIME +
ofRuntimeTag?_some_implies_isValidRuntimeTag + extractOkFromTags? known-tag paths;
SpecProof.proofCompleteClaimed stays false) + fuller **HostCompose** path in
`SystemsLean/HostCompose.lean` (owns graph + linear host + erasure; MULT-1 live
host required via mult pre-scan; COMPOSE-THEOREM / HOST-COMPOSE-THEOREM real
theorems on multPreScan empty / mint-consume FAIL-CLOSED / RUNTIME-FS extract /
nodeMultOk contracts + markErased_idempotent / multPreScan_omega_only_true /
mint_consume_roundtrip; SpecProof.proofCompleteClaimed stays false) + **EmitPlan** /
**EmitApply** / **EmitBody** host honesty modules (`SystemsLean/EmitPlan.lean`,
`EmitApply.lean`, `EmitBody.lean`: readiness inventory, fixed tag list, body
fragment inventory; EMIT-BODY-THEOREM / HOST-EMIT-BODY-THEOREM fragment honesty;
PARTIAL vs full C EMIT_*_V0). UNIT_DEEPEN_V1 +
**FAIL_CLOSED_CHECKER_V1** + **HOST_COMPOSE_V0** + **EMIT_PLAN_V0** +
**EMIT_APPLY_V0** + **EMIT_BODY_V0** contract surface on Extract.slake remains for
historical emit map. V0 emit path exists (`SLAKE_EMIT_FREESTANDING_C_V0` / frozen
wire stages); still not residual free.
**PARTIAL inventory:** `host-partial-inventory.md` (HOST-PARTIAL-INVENTORY;
CLOSABLE-MISS-COUNT-0 -- Mult..SpecProof intentional PARTIAL only; no closable miss;
HOST-INVENTORY-CLOSE readiness does not claim residual free;
HOST-PRODUCT-PATH freestandingEmitProductPathReady reuses KernelEmit plan/apply/body
+ freestandingBodyPathReady and does not claim residual free).
**SH4 emit kernel:** `SystemsLean/KernelEmit.lean` (**SELF-HOST-KERNEL-EMIT** /
**HOST-KERNEL-EMIT** / `SLAKE_SELF_HOST_KERNEL_EMIT_V0`) composes EmitPlan /
EmitApply / EmitBody + Mult emit over program kernel (KERNEL-EMIT-SMOKE); no new
EMIT_* C residual stage; product wire bulk still frozen at EMIT_BODY_V0 except
HOST-EMIT-SSOT + HOST-EMIT-MULT.
**Emit freestanding path parity:** `SystemsLean/ParityEmit.lean`
(**HOST-PARITY-EMIT** / **SELF-HOST-PARITY-EMIT** /
`SLAKE_SELF_HOST_PARITY_EMIT_V0`) Mult+Linear+Types+Program+Emit freestanding
path honesty (emitParityReady / multLinearTypesProgramEmitParityReady;
PARITY-EMIT-SMOKE); product EMIT_PLAN / EMIT_APPLY / EMIT_BODY probe labels;
no new EMIT_* C stage.
**SH5 freestanding deepen compose:** `SystemsLean/SelfApplyFs.lean` folds
`freestandingParityLadderReady` (= multLinearTypesProgramEmitParityReady) into
`freestandingSelfApplyReady` with freestanding extract/body path (RUNTIME-FS /
HOST-EMIT-SSOT); freestandingProductSelfHostComplete stays false.
**IR sketch:** `doc/shared-ir-sketch.md` (Extract / emit boundary).
**Anchors:** EMIT-BOUNDARY; EDGE-RUNTIME / RUNTIME-CLASSIC; product goal RUNTIME-FS;
UNIT_DEEPEN_V1; FAIL_CLOSED_CHECKER_V1; HOST_COMPOSE_V0; EMIT_PLAN_V0; EMIT_APPLY_V0;
EMIT_BODY_V0; SYSTEMS_LEAN_HOST; HOST-PARTIAL-INVENTORY; SELF-HOST-KERNEL-EMIT;
HOST-KERNEL-EMIT; HOST-PARITY-EMIT; SELF-HOST-PARITY-EMIT; HOST-SELF-APPLY-FS;
COMPOSE-THEOREM; HOST-COMPOSE-THEOREM; markErased_idempotent;
multPreScan_omega_only_true; mint_consume_roundtrip; pushHostNode_bad_node;
pushHostNode_value_one_ok; addHostEdge_empty_badEndpoints;
addHostEdge_two_values_ok; addHostEdge_one_node_badEndpoints; EXTRACT-THEOREM;
HOST-EXTRACT-THEOREM; EMIT-BODY-THEOREM; HOST-EMIT-BODY-THEOREM

## Lean host (SYSTEMS_LEAN_HOST)

| Host surface | Role |
|--------------|------|
| `RuntimeClaim` | `runtimeFs` (RUNTIME-FS) / `runtimeClassic` (RUNTIME-CLASSIC) / `edgeRuntime` (EDGE-RUNTIME) |
| `isFreestandingGoal` | True only for RUNTIME-FS product goal |
| `ofRuntimeTag?` / `isValidRuntimeTag` | FAIL-CLOSED-UNKNOWN-RUNTIME on raw tags (0/1/2) |
| `checkFailClosed` / `extractOk` | PARTIAL FAIL_CLOSED_CHECKER_V1: claim must be RUNTIME-FS; MULT-0 needs marked erased; MULT-1 / MULT-OMEGA under FS always pass (no live-token check) |
| `extractOkFromTags?` | Raw mult + marked + runtime tag path (none on unknown tags; same MULT-1 gap) |
| EXTRACT-THEOREM / HOST-EXTRACT-THEOREM | Real theorems: isFreestandingGoal_runtimeFs / classic/edge false, extractOk_classic_reject / extractOk_edge_reject, extractOk_mult1_fs_true / omega / mult0 unmarked/marked, ofRuntimeTag? known + fail_closed + ofRuntimeTag?_some_implies_isValidRuntimeTag + isValidRuntimeTag_zero/one/two, name honesty, extractOkFromTags? known-tag success/fail + unknown none -- partial Extract only; intentional MULT-1 thinning; not SpecProof complete |
| `HostCompose.Host` | Graph + LinearHost (live/id) + Erased (HOST-COMPOSE host honesty) |
| `HostCompose.checkFailClosed` / `extractOk` / `extractOkFs` | Graph well-typed + mult pre-scan (MULT-0 marked; MULT-1 live host; MULT-OMEGA free); extractOk needs RUNTIME-FS; extractOkFs = extract under runtimeFs |
| COMPOSE-THEOREM / HOST-COMPOSE-THEOREM | Real theorems: multPreScan_empty_true, checkFailClosed_empty_true, extractOkFs_empty_true, extractOk_classic_empty_false / extractOk_edge_empty_false, extractOk_classic_mult1_minted_false / extractOk_edge_mult1_minted_false / extractOk_classic_mult0_marked_false / extractOk_edge_mult0_marked_false (EMIT-BOUNDARY: conjoins extractOkFs true + classic/edge false on checkFailClosed-true non-empty), mint_zero_badId, consume_empty_notLive, mint_empty_one_ok, consume_minted_one, mint_already_live_one, double_consume_notLive (conjoins first-ok + second-notLive; no match escape), nodeMultOk_omega / nodeMultOk_mult1_eq_live / nodeMultOk_mult0_eq_absent, multPreScan_mult1_unminted_false / extractOkFs_mult1_unminted_false / multPreScan_mult1_minted_true / extractOkFs_mult1_minted_true, multPreScan_mult0_unmarked_false / multPreScan_mult0_marked_true / extractOkFs_mult0_unmarked_false / extractOkFs_mult0_marked_true, extractOk_eq / extractOkFs_eq / checkFailClosed_eq, markErased_idempotent, multPreScan_omega_only_true / extractOkFs_omega_only_true, consume_live_payload / mint_nonzero_ok / mint_consume_roundtrip, pushHostNode_bad_node / pushHostNode_value_one_ok, addHostEdge_empty_badEndpoints / addHostEdge_two_values_ok / addHostEdge_one_node_badEndpoints -- partial HostCompose only; live-flag model; not SpecProof complete; not MULT-1 elaborator enforcement |
| `mint` / `consume` / `markErased` | MULT-1 live evidence + MULT-0 mark (JOIN-ALG ConsumeToken shapes cited; Token axiom not stored) |
| `pushHostNode` / `addHostEdge` | Call-through IrGraph (names distinct from IrGraph.pushNode / addEdge) |
| `multPreScan` / `nodeMultOk` | MULT-1 needs `linear.live`; MULT-0 needs marked erased |
| `EmitPlan.Plan` / `planFromCompose` / `fromCompose` / `isReady` / `planOk` | Readiness inventory (nodeCount/edgeCount/runtimeNodes/erasedNodes); fail-closed on HostCompose.checkFailClosed (not extractOk); empty compose ready OK; planOk convenience |
| `EmitApply.Apply` / `packTag` / `applyFromCompose` / `fromCompose` / `applyIsValid` / `applyOk` | Fixed mult/kind tag list (applyCap 32); packing matches emit nibble layout; applyIsValid checks valid + count<=cap + count==tags.length; applyOk convenience |
| `EmitBody.Body` / `bodyFromCompose` / `fromCompose` / `bodyIsValid` / `bodyOk` / `buildFragment` | Fragment readiness; markers derived from buf (EMIT_BODY_V0 / RUNTIME-FS); PARTIAL String vs C char buf; via plan+apply; bodyOk convenience |
| EMIT-BODY-THEOREM / HOST-EMIT-BODY-THEOREM | Real theorems: bodyCap_eq_256, emptyComposeFragmentSsot_eq, bodyOk_empty_true, bodyFromCompose_empty_buf_ssot / empty markers, bodyIsValid_failClosed_false, bufHas* ssot markers, bodyOk_mult1_unminted_false / bodyOk_mult1_minted_true / bodyFromCompose_mult1_minted_buf / bodyFromCompose_mult0_marked_buf / bodyOk_omega_true / bodyFromCompose_linear_and_erased -- partial EmitBody only; HOST-EMIT-SSOT honesty; not SpecProof complete |

**Extract intentional thinning vs HostCompose:** `Extract.checkFailClosed` /
`extractOk` do **not** require live token for MULT-1 (PARTIAL path). Fuller host
path is `SystemsLean/HostCompose.lean` (mult pre-scan requires live host for any
MULT-1 graph node; marked erased for MULT-0). PARTIAL vs full C HOST_COMPOSE_V0
(no null pointers / exact C return-code tables). Not residual free.

## Three runtime stories (must stay distinct)

| Story | Trust base residual |
|-------|---------------------|
| Idris RefC (and stock Idris backends) | Generated C plus managed / reference-counting runtime |
| Classic Lean ahead-of-time (AOT) | Native code that still expects the managed Lean runtime |
| Freestanding product (goal) | No Lean managed runtime on the product wire |

Shared IR must track which values survive emit (mult omega and mult 1 resources that
are not erased) versus what is host-only (proofs, mult 0, elaborator services).

**EMIT-BOUNDARY:** product extract must not reintroduce EDGE-RUNTIME /
RUNTIME-CLASSIC managed residual onto the RUNTIME-FS wire.

## FAIL_CLOSED_CHECKER_V1 (composed checker + extract path)

V0 freestanding C maps a thin composed checker (not a full compiler body):

| C API | Role |
|-------|------|
| `slake_check_bundle` | Input: mult grade, optional linear token, optional erased marker, claimed runtime |
| `slake_check_fail_closed` | Fail-closed composition: unknown mult, MULT-1 without live token, MULT-0 without marked erased, non-RUNTIME-FS claim -> `SLAKE_EXTRACT_FAIL_CLOSED` |
| `slake_extract_with_checks` | Run checks; on OK set `*out_rt = SLAKE_RUNTIME_FS`; on fail leave `out_rt` untouched |

Still **not residual free**. Behavioral smoke in
`src/systems/smoke/slake_behavioral_probe.c` exercises these return contracts under a
hosted link (API semantics are freestanding). Residual `src/systems/check.sh` only
compiles/links/runs that probe when `cc` is present (not residual free).

## HOST_COMPOSE_V0 (host + IR graph composition for extract)

Thin orchestration: own `slake_ir_graph` (IR_GRAPH_EDGES_V0) + `slake_consume_token`
(CONSUME_TOKEN_HOST_V0) + `slake_erased` mark for one fail-closed extract entry.
Not a second elaborator. Not full CFG/SSA. Still not residual free.

| C symbol | Role |
|----------|------|
| `slake_host_compose_id` | returns exact `HOST_COMPOSE_V0` |
| `slake_host_compose` | graph + host + erased + valid |
| `slake_host_compose_init` | init graph + host; erased unmarked; 0 ok; -1 null |
| `slake_host_compose_push_node` / `add_edge` | call-through graph APIs after valid guard; compose -1 on null/invalid |
| `slake_host_compose_mint` / `consume` | call-through host; mint: 0 ok; -1 null/invalid/id==0; -2 already live |
| `slake_host_compose_mark_erased` | call-through `slake_erased_mark`; 0 ok; -1 null/invalid compose |
| `slake_host_compose_is_well_typed` | valid + graph well-typed; empty compose OK at graph surface |
| `slake_host_compose_check_fail_closed` | mult pre-scan (compose owns host/erasure) then graph check |
| `slake_host_compose_extract` | run check; on OK set `*out_rt = RUNTIME-FS`; null `out_rt` on success path FAIL_CLOSED |

Honesty: empty well-typed compose (no nodes) check/extract OK. MULT-1 uses host
linear when live (`&hc->host.token`). MULT-0 needs `mark_erased`.
`check_fail_closed` intentionally pre-scans MULT-1/0 against live host / marked
erasure at the compose boundary (owns those handles), then selects linear/erased
pointers and call-throughs `slake_ir_graph_check_fail_closed` (which also fails
closed when handles are null). Redundant-safe; behavioral smoke locks both.
Greppable:
HOST_COMPOSE_V0, CONSUME_TOKEN_HOST_V0, IR_GRAPH_EDGES_V0,
FAIL_CLOSED_CHECKER_V1, EMIT-BOUNDARY, RUNTIME-FS, slake_host_compose.

**Lean host:** `SystemsLean/HostCompose.lean` (SYSTEMS_LEAN_HOST partial) owns graph
+ linear host live flag + erasure; mint / consume / markErased; mult pre-scan closes
Extract MULT-1 live-token gap for graph nodes; extractOk under RUNTIME-FS only.
PARTIAL vs full C HOST_COMPOSE_V0 (no null pointers / exact return-code tables).
Still not residual free. Greppable host: HOST-COMPOSE, FAIL-CLOSED, EMIT-BOUNDARY.

## EMIT_PLAN_V0 (emit plan from host compose)

Readiness inventory derived from a checked `slake_host_compose`. Counts nodes,
edges, MULT-1+MULT-OMEGA runtime survivors, and MULT-0 erased nodes. Requires
`check_fail_closed` OK (fail closed otherwise). Not residual free. Not CFG/SSA.
Not full product emit of IR bodies -- plan only.

| C symbol | Role |
|----------|------|
| `slake_emit_plan_id` | returns exact `EMIT_PLAN_V0` |
| `slake_emit_plan` | node_count, edge_count, runtime_nodes, erased_nodes, ready, valid |
| `slake_emit_plan_from_compose` | 0 ok; -1 null out or null/invalid/ill-typed compose or check fails; on fail zero fields + valid=0 |
| `slake_emit_plan_is_ready` | 1 if non-null and valid and ready; else 0 |

Empty compose after init: plan ok with all counts 0, ready=1, valid=1. Greppable:
EMIT_PLAN_V0, HOST_COMPOSE_V0, RUNTIME-FS, EMIT-BOUNDARY, slake_emit_plan.

**Lean host:** `SystemsLean/EmitPlan.lean` (SYSTEMS_LEAN_HOST partial) -- `Plan`
inventory from `HostCompose.checkFailClosed` only (not extractOk); `planFromCompose`
fail-closed (alias `fromCompose`); `isReady` / `planOk`; empty compose ready with
zero counts; edge + multi-node EMIT-PLAN-SMOKE; EMIT-PLAN-THEOREM /
HOST-EMIT-PLAN-THEOREM real theorems (empty ready/counts, fail-closed MULT-1
unminted, minted/marked ready counts, edgeCount, multi-node runtime+erased).
PARTIAL vs full C EMIT_PLAN_V0 (no null pointers / exact -1 codes). Still not
residual free. Not proof complete (SpecProof.proofCompleteClaimed stays false).
Greppable host: EMIT-PLAN, FAIL-CLOSED, HOST-COMPOSE, EMIT-BOUNDARY,
planFromCompose, EMIT-PLAN-THEOREM.

## EMIT_APPLY_V0 (apply plan tags from host compose)

Fixed-buffer serialisation of live program node mult/kind tags from a checked
`slake_host_compose`. Requires `check_fail_closed` OK (fail closed otherwise).
Not residual free. Not CFG/SSA. Not full product C body codegen of arbitrary IR
-- tag buffer only.

| C symbol | Role |
|----------|------|
| `slake_emit_apply_id` | returns exact `EMIT_APPLY_V0` |
| `slake_emit_apply` | `tags[SLAKE_EMIT_APPLY_CAP]`, count, valid (`CAP` = 32) |
| `slake_emit_apply_from_compose` | 0 ok; -1 null out or null/invalid/ill-typed compose or check fails or count would exceed CAP; on fail valid=0 count=0 |
| `slake_emit_apply_is_valid` | 1 if non-null and valid; else 0 |

Tag packing (one byte per live node, program order):
`tag = (uint8_t)(((unsigned)mult & 0xFu) << 4 | ((unsigned)kind & 0xFu))`.
Mult codes (high nibble): MULT_0=0, MULT_1=1, MULT_OMEGA=2.
Kind codes (low nibble): VALUE=0, LINEAR=1, ERASED=2.
Empty well-typed ready compose: count=0, valid=1.

**Capacity honesty:** `SLAKE_EMIT_APPLY_CAP` (32) is defensive headroom above
`SLAKE_IR_PROGRAM_CAP` (8). Honest compose mutators cannot grow live nodes past
program CAP, so the apply overflow branch is unreachable via public APIs today;
retained for poisoned `prog.count` and future program growth. APPLY_CAP is not a
claim that apply supports 32 live nodes while the program still caps at 8.

Greppable:
EMIT_APPLY_V0, EMIT_PLAN_V0, HOST_COMPOSE_V0, RUNTIME-FS, slake_emit_apply.

**Lean host:** `SystemsLean/EmitApply.lean` -- `Apply` tag list under `applyCap` 32
(SLAKE_EMIT_APPLY_CAP honesty); `packTag` mult high nibble / kind low; fail-closed
`applyFromCompose` (alias `fromCompose`); `applyIsValid`; multi-tag EMIT-APPLY-SMOKE;
EMIT-APPLY-THEOREM / HOST-EMIT-APPLY-THEOREM real theorems (applyCap, empty valid,
fail-closed MULT-1 unminted, packTag table, minted/marked/omega tags, multi-node
program order, applyIsValid count/tags desync reject). PARTIAL vs full C
EMIT_APPLY_V0. Still not residual free. Not proof complete
(SpecProof.proofCompleteClaimed stays false). Greppable host: EMIT-APPLY,
APPLY_CAP, FAIL-CLOSED, applyFromCompose, EMIT-APPLY-THEOREM.

## EMIT_BODY_V0 (freestanding C body fragment from host compose)

Fixed-buffer deterministic ASCII fragment built from a checked
`slake_host_compose` via plan + apply APIs (does not reimplement those checks).
Not residual free. Not CFG/SSA. Not full product module emit of arbitrary IR --
V0 fragment only.

| C symbol | Role |
|----------|------|
| `slake_emit_body_id` | returns exact `EMIT_BODY_V0` |
| `slake_emit_body` | `buf[SLAKE_EMIT_BODY_CAP]`, len, valid (`CAP` = 256) |
| `slake_emit_body_from_compose` | 0 ok; -1 null out/hc, plan/apply/check fail, or buffer overflow; on fail valid=0 len=0 buf[0]=0 |
| `slake_emit_body_is_valid` | 1 if non-null, valid, len < CAP, buf[len]==0; else 0 |

Fragment includes greppable `EMIT_BODY_V0` and `RUNTIME-FS`, decimal
`runtime_nodes` / `erased_nodes` from plan, and one short line per apply tag
encoding mult/kind (same packing as EMIT_APPLY_V0: mult high nibble, kind low).
MULT-0 tags may still be listed (erased inventory honesty). Empty compose:
header with r=0 e=0.

**Capacity honesty:** `SLAKE_EMIT_BODY_CAP` (256) is defensive headroom for the
V0 fragment under `SLAKE_IR_PROGRAM_CAP` (8) live nodes (~222 bytes max honest
fragment with the current line format). Overflow fail-closed is retained for
format growth / poisoned counts; not smoked via honest compose mutators today
(same class as APPLY_CAP honesty). BODY_CAP is not a claim that arbitrary IR
modules fit in 256 bytes.

Greppable: EMIT_BODY_V0, EMIT_APPLY_V0, EMIT_PLAN_V0,
RUNTIME-FS, EMIT-BOUNDARY, slake_emit_body.

**Lean host (HOST-EMIT-SSOT):** `SystemsLean/EmitBody.lean` -- `Body` fragment
readiness via EmitPlan + EmitApply (does not reimplement HostCompose checks);
`bodyCap` 256; `buildFragment` / `emptyComposeFragmentSsot` / `bodyFromCompose`
(alias `fromCompose`); markers derived from buf substrings; `bodyIsValid`;
multi-node EMIT-BODY-SMOKE. Durable dialect:
`emit/host_emit_body_fragment.ssot.txt`. Bash generator is NON-SSOT for fragment
text. PARTIAL String vs C char buf. Still not residual free. Greppable host:
EMIT-BODY, HOST-EMIT-SSOT, BODY_CAP, EMIT-BOUNDARY, RUNTIME-FS, bodyFromCompose.

## Intended path

```
 surface (phased)
      |
      v
 shared typed core / IR
   (types, mult 0/1/omega, linear/affine use, erasure)
      |
      v
 checks (use / linearity / freestanding constraints, fail closed)
      |
      v
 product extract  -->  freestanding C (out/freestanding-c)
```

V0: `script/slake-emit-freestanding-c.sh` writes `src/systems/emit/` with first
real unit translation (**UNIT_TRANSLATION_V0** / **UNIT_DEEPEN_V1**),
**FAIL_CLOSED_CHECKER_V1**, **CONSUME_TOKEN_HOST_V0** (Linear host; composes
this checker via `slake_consume_token_check_fail_closed`),
**HOST_COMPOSE_V0** (`slake_host_compose_extract` joins host + graph + erasure),
**EMIT_PLAN_V0** (`slake_emit_plan_from_compose` readiness inventory),
**EMIT_APPLY_V0** (`slake_emit_apply_from_compose` fixed tag buffer), and
**EMIT_BODY_V0** (`slake_emit_body_from_compose` fixed C body fragment);
`just out-freestanding-c` copies into release.
Structure compile path stays separate (`SLAKE_COMPILE_PATH_V0`).

## Non-claims

- Not freestanding residual free
- No full compiler body; checker is V0 composed surface only
- No out/llvm-ir (deferred until self-host)
- No PROVABLY CompCert
