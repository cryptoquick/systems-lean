# Linear use -- exact-once resources (unit surface notes)

**Module role:** linear (and later affine) use checks for product-relevant resources.
**Status:** SYSTEMS_LEAN_HOST partial -- `SystemsLean/Linear.lean` (JOIN-ALG
ConsumeToken axioms) + host compose mint/consume evidence in
`SystemsLean/HostCompose.lean` (LinearHost live flag; MULT-1 mult pre-scan) +
**HOST-JOIN-MAP** / `SLAKE_JOIN_MAP_V0` in `SystemsLean/JoinMap.lean` (join-
informed compile readiness; duals read-only cite) + **SELF-HOST-KERNEL-LINEAR** /
**HOST-KERNEL-LINEAR** / `SLAKE_SELF_HOST_KERNEL_LINEAR_V0` in
`SystemsLean/KernelLinear.lean` (SH4 start: Linear ordered IR + HostCompose
mint/consume readiness; KERNEL-LINEAR-SMOKE) + **HOST-PARITY-LINEAR** /
**SELF-HOST-PARITY-LINEAR** / `SLAKE_SELF_HOST_PARITY_LINEAR_V0` in
`SystemsLean/ParityLinear.lean` (Mult+Linear freestanding Linear path parity;
linearParityReady / multLinearParityReady; PARITY-LINEAR-SMOKE). UNIT_DEEPEN_V1 +
**CONSUME_TOKEN_HOST_V0** freestanding host shape on emit (+ **HOST_COMPOSE_V0**
host + IR graph composition; not pure layout only). V0 emit path exists
(`SLAKE_EMIT_FREESTANDING_C_V0` / **UNIT_TRANSLATION_V0** / **CONSUME_TOKEN_HOST_V0** /
**HOST_COMPOSE_V0**); still not residual free.
Not freestanding residual free. Not freestanding emit body in this unit file.
**IR sketch:** `doc/shared-ir-sketch.md` (Linear use / Affine rows).
**Anchors:** MULT-1; LINEAR-EXACT-ONCE; JOIN-ALG ConsumeToken; UNIT_DEEPEN_V1;
CONSUME_TOKEN_HOST_V0; HOST_COMPOSE_V0; HOST-JOIN-MAP; SLAKE_JOIN_MAP_V0;
SELF-HOST-KERNEL-LINEAR; HOST-KERNEL-LINEAR; SLAKE_SELF_HOST_KERNEL_LINEAR_V0;
HOST-PARITY-LINEAR; SELF-HOST-PARITY-LINEAR; SLAKE_SELF_HOST_PARITY_LINEAR_V0;
SYSTEMS_LEAN_HOST

## Intent

Exact-once resources fail closed under use checks (**LINEAR-EXACT-ONCE**). Affine
(at most once) is product talk (EDGE-AFFINE); Idris public grades are 0 /
exact-once 1 / unrestricted -- no first-class affine quantity on that side.

Dual algorithm (sides only; not reimplemented here): **JOIN-ALG** ConsumeToken
(`src/idris2/examples/ConsumeToken.idr`, `src/lean4/examples/ConsumeToken.lean`).
Systems cites that dual as the host target shape; does not invent a second dual.

TYPED_IR_V0 pairs LINEAR kind with MULT-1 on ir_node (composes host grades).

## Emit mapping (UNIT_TRANSLATION_V0 / UNIT_DEEPEN_V1)

V0 freestanding C (`SLAKE_EMIT_FREESTANDING_C_V0`) maps a linear token handle and
an exact-once consume API (`slake_linear_consume`; alias
`slake_linear_token_consume` is a thin call-through with the same codes).
Return codes: **0** success, **-1** null, **-2** already consumed. Init fails
closed on `id == 0` (spent sentinel). That is a first unit translation of this
surface, not a full use checker and not residual free.

## CONSUME_TOKEN_HOST_V0 (JOIN-ALG freestanding host shape)

Freestanding product host under `src/systems/emit/` models the dual algorithm
shape at C level (mint MULT-1 + exact-once consume). Not a dual reimplementation
of the Idris or Lean sources.

| C symbol | Dual-class role | Notes |
|----------|-----------------|-------|
| `slake_consume_token` | Program state holding MULT-1 token | state: empty / live / spent |
| `slake_consume_token_init` | Zero host | empty before mint |
| `slake_consume_token_mint` | mkToken shape | MULT-1; id!=0; live double-mint fails closed |
| `slake_consume_token_consume` | consume shape | composes `slake_linear_consume`; second use -2 |
| `slake_consume_token_is_live` | live predicate | 1 only when state live |
| `slake_consume_token_check_fail_closed` | FAIL_CLOSED_CHECKER_V1 path | MULT-1 + live + RUNTIME-FS check-only |
| `slake_consume_token_host_id` | Greppable id | returns `CONSUME_TOKEN_HOST_V0` |

Greppable: CONSUME_TOKEN_HOST_V0, JOIN-ALG, ConsumeToken, MULT-1, LINEAR-EXACT-ONCE.
Still **not residual free**; not PROVABLY; no product GC.

Contract: use only host APIs. Direct mutation of the embedded
`slake_linear_token` (for example `slake_linear_consume(&ct->token)`) is out of
contract. Host consume heals `state` to spent if the token is already spent while
the host believed live; mint keys off `is_live` so remint can recover desync.

## HOST_COMPOSE_V0 (host side of compose)

**Lean host:** `SystemsLean/HostCompose.lean` -- `mint` / `consume` record linear
host live flag; mult pre-scan requires live host for any MULT-1 graph node under
checkFailClosed (closes Extract intentional MULT-1 gap). JOIN-ALG ConsumeToken
shapes cited; Linear.Token axiom is not stored as data. PARTIAL vs full C
HOST_COMPOSE_V0. Still not residual free.

Emit composes this host with `slake_ir_graph` and erasure as `slake_host_compose`
under **HOST_COMPOSE_V0**. `slake_host_compose_mint` / `slake_host_compose_consume`
call-through host mint/consume APIs (mint: 0 ok; -1 null/invalid/id==0; -2 already
live). MULT-1 graph nodes need a live host token for
`slake_host_compose_check_fail_closed` / extract (check-only; does not consume).
Compose `check_fail_closed` pre-scans MULT-1 against live host at the compose
boundary (owns the handle), then call-throughs graph check. After consume, MULT-1
fails closed until remint. See `extract.md`.

Greppable: HOST_COMPOSE_V0, slake_host_compose, CONSUME_TOKEN_HOST_V0,
SYSTEMS_LEAN_HOST.

## HOST-JOIN-MAP / SLAKE_JOIN_MAP_V0 (join into compile path)

**Lean host:** `SystemsLean/JoinMap.lean` -- composes JOIN-ALG dual cite
(read-only: `src/idris2/examples/ConsumeToken.idr`,
`src/lean4/examples/ConsumeToken.lean`) with CompilePath unit/program readiness.
`joinUnitCompileReady` = unitCompileReady && joinAlgContractOk;
`joinProgramCompileReady` sibling preserves EMPTY-PROGRAM-FAIL-CLOSED (empty host
OK != empty program OK). JOIN-MAP-SMOKE behavioral examples under Lake. PARTIAL:
surface canary + host Bool map, not formal dual-bridge theorems and not
freestanding LinearCheck. Still not residual free.

Greppable: HOST-JOIN-MAP, SLAKE_JOIN_MAP_V0, JOIN-MAP, JOIN-ALG, ConsumeToken,
JOIN-MAP-SMOKE, SYSTEMS_LEAN_HOST.

## SELF-HOST-KERNEL-LINEAR / HOST-KERNEL-LINEAR (SH4 start)

**Lean host:** `SystemsLean/KernelLinear.lean` -- Linear self-host kernel IR
fixture + HostCompose mint/consume exact-once path.

| Host def | Role |
|----------|------|
| `lowerLinearKernel` | 1-node ordered IR (LINEAR / MULT-1); fail-closed push |
| `linearHostPathReady` | HostCompose: unminted MULT-1 fails; mint OK; consume clears live; id 0 / double mint reject |
| `linearKernelReady` | programCompileReady + linearHostPathReady + gradeSurfaceOk + surface |
| KERNEL-LINEAR-SMOKE | Lake `example` smokes for the above |

Stage ids: `SLAKE_SELF_HOST_KERNEL_LINEAR_V0`, `SELF-HOST-KERNEL-LINEAR`,
`HOST-KERNEL-LINEAR`. Product API cites only (`slake_linear_consume`,
`CONSUME_TOKEN_HOST_V0`); no new EMIT_* residual C stage. PARTIAL: Linear kernel
IR + host path only -- not full Linear product C text SSoT; not types/program
full ladder; SH5 host compose is SelfApply (not freestanding product self-host
complete). Still not residual free.

Greppable: SELF-HOST-KERNEL-LINEAR, HOST-KERNEL-LINEAR,
SLAKE_SELF_HOST_KERNEL_LINEAR_V0, KERNEL-LINEAR-SMOKE, LINEAR-EXACT-ONCE,
linearKernelReady, SYSTEMS_LEAN_HOST.

## HOST-PARITY-LINEAR / SELF-HOST-PARITY-LINEAR (Mult+Linear freestanding path)

**Lean host:** `SystemsLean/ParityLinear.lean` -- freestanding Linear product path
honesty closed-loop style after Mult SH3. Composes KernelLinear host contracts
with ParityMult Mult closed loop and frozen product API canaries.

| Host def | Role |
|----------|------|
| `linearContractParityOk` | linearKernelReady + linearHostPathReady (re-assert) + multParityReady + product API strings |
| `linearParityReady` | linearContractParityOk && paritySurfaceOk (FAIL-CLOSED) |
| `multLinearParityReady` | greppable Mult+Linear joint name; Mult already in linearContractParityOk so equivalent to linearParityReady under current defs (not a stronger gate) |
| PARITY-LINEAR-SMOKE | Lake `example` smokes for the above |

Stage ids: `SLAKE_SELF_HOST_PARITY_LINEAR_V0`, `HOST-PARITY-LINEAR`,
`SELF-HOST-PARITY-LINEAR`. Product API cites only (slake_linear_*,
slake_consume_token_*, CONSUME_TOKEN_HOST_V0); probe labels existing
init/live/consume + mint/consume path; no new EMIT_* residual C stage.
PARTIAL: Linear freestanding path honesty only -- Mult grades already SH3; not
EmitLinear product C text SSoT; not freestanding product self-host complete.
Still not residual free.

Greppable: HOST-PARITY-LINEAR, SELF-HOST-PARITY-LINEAR,
SLAKE_SELF_HOST_PARITY_LINEAR_V0, PARITY-LINEAR-SMOKE, linearParityReady,
multLinearParityReady, SYSTEMS_LEAN_HOST.

## Non-claims

- No full use-checker body here
- Not freestanding residual free
- No second ConsumeToken dual invented under systems
- Not PROVABLY
- SH4 KernelLinear is partial ladder growth -- not freestanding self-host complete
- HOST-PARITY-LINEAR is Linear freestanding path honesty only -- not residual free;
  not freestanding product self-host complete; Mult grades already SH3
- SH5 SelfApply composes Linear kernel into host self-application readiness
  (structural only; not freestanding product self-host complete; SH6 held)
- SH6 LlvmHold documents llvm / PROVABLY hold (llvmHoldReady true;
  llvmUnlocked false; not unlock mill)
