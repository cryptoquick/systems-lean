# SURFACE-MATRIX -- superset surface inventory (P7)

**Greppable:** SURFACE-MATRIX, SLAKE_SURFACE_MATRIX_V0, HOST-SURFACE-MATRIX,
present-partial, open, SYSTEMS_LEAN_HOST, SURFACE-MATRIX-THEOREM,
HOST-SURFACE-MATRIX-THEOREM, matrixUnitReady_empty_true,
matrixProgramReady_empty_false
**Stage:** `SLAKE_SURFACE_MATRIX_V0` / `HOST-SURFACE-MATRIX` / `SURFACE-MATRIX`
**Lean host:** `SystemsLean/SurfaceMatrix.lean` (matrixUnitReady / matrixProgramReady
+ SURFACE-MATRIX-SMOKE + SURFACE-MATRIX-THEOREM / HOST-SURFACE-MATRIX-THEOREM;
SpecProof.proofCompleteClaimed stays false)
**Date evidence:** 2026-07-22 (P7 host-side surface matrix)

## Purpose

Honest **progressive** inventory of what Systems Lean / Slake host currently
covers versus open gaps relative to useful Idris 2 and Lean 4 cores.

Acceptance bar (from `doc/goals.md`): explicit surface matrix + progressive
gates -- **not** day-one full upstream parity, **not** marketing "superset
complete."

This file is inventory prose. Executable fail-closed composition lives in
`SystemsLean.SurfaceMatrix` (composes HOST-SELF-HOST readiness with matrix
surface canary).

Still **not residual free**. Not PROVABLY. Does **not** unlock `out/llvm-ir`.

---

## Status vocabulary

| Status | Meaning |
|--------|---------|
| **present-partial** | Host surface exists for this row; progressive gate green; intentional PARTIAL vs full wire / full language feature |
| **open** | Not claimed; gap stays open until named residual + evidence |

No row may be marked full Idris parity, full Lean parity, residual free, PROVABLY,
or llvm unlock.

---

## Dual cite inputs (read-only; do not reimplement)

Three JOIN-ALG algorithm examples on both bridge sides:

| Algorithm | Idris side | Lean side |
|-----------|------------|-----------|
| ConsumeToken | `src/idris2/examples/ConsumeToken.idr` | `src/lean4/examples/ConsumeToken.lean` |
| ErasedIndex | `src/idris2/examples/ErasedIndex.idr` | `src/lean4/examples/ErasedIndex.lean` |
| UnrestrictedShare | `src/idris2/examples/UnrestrictedShare.idr` | `src/lean4/examples/UnrestrictedShare.lean` |

Stated dual -> Slake use map: `src/systems/join-map.md` and
`SystemsLean/JoinMap.lean` (`joinAlgUseOk` host use pins; `joinDualCiteOk`
path inventory). ConsumeToken: HostCompose mint/consume live-flag
(`consumeTokenHostUseOk`) + HOST-EMIT-LINEAR product text (Linear Token axioms
remain dual-cite on Linear.lean, not joinAlgUseOk). ErasedIndex: Erasure mark /
isRuntimeAbsent + MULT-0. UnrestrictedShare: Mult multOmega / MULT-OMEGA +
Linear.shareNat (shareNat only on this dual). Duals are not reimplemented under
`src/systems/`; dual trees stay read-only.

---

## Matrix rows (host progressive vs open)

| Row | Status | Host evidence | Notes |
|-----|--------|---------------|-------|
| Multiplicity surface (MULT-0 / MULT-1 / MULT-OMEGA) | **present-partial** | `SystemsLean/Mult.lean` | Closed inductive; FAIL-CLOSED-UNKNOWN-GRADE on raw tags; MULT-THEOREM real theorems (ofNat?_fail_closed etc.); not SpecProof complete |
| Linear / JOIN-ALG duals (ConsumeToken + ErasedIndex / UnrestrictedShare use) | **present-partial** | HostCompose mint/consume + Erasure + Mult/shareNat via JoinMap joinAlgUseOk helpers; dualCiteOk inventory; join-map.md | Classic elaborator cannot enforce MULT-1; Linear Token axioms dual-cite only |
| Typed IR / ordered program / graph edges | **present-partial** | Types + IrProgram + IrGraph | CAP 8 / EDGE_MAX 16; List vs C arrays PARTIAL; Types TYPES-THEOREM (ofKindTag?_fail_closed etc.; FAIL-CLOSED-UNKNOWN-KIND); IrProgram IR-PROGRAM-THEOREM (isWellTyped_empty_false / EMPTY-PROGRAM-FAIL-CLOSED); not SpecProof complete |
| Erasure + extract | **present-partial** | Erasure + Extract + HostCompose.multPreScan | RUNTIME-FS extract; MULT-1 thinning intentional |
| Host compose | **present-partial** | HostCompose.lean | graph + linear + erasure; HOST-SMOKE |
| Emit plan / apply / body honesty | **present-partial** | EmitPlan + EmitApply + EmitBody + HOST-EMIT-SSOT | Frozen C wire; fragment dialect host SSoT |
| Compile path | **present-partial** | CompilePath.lean HOST-COMPILE-PATH / SLAKE_COMPILE_PATH_V1 | V0 process-glue stamp remains; unit walk pure Nix; not product C compile |
| Join map | **present-partial** | JoinMap.lean HOST-JOIN-MAP / SLAKE_JOIN_MAP_V0 + joinAlgUseOk | Duals read-only; stated map in join-map.md; not formal full bridge |
| Self-host direction | **present-partial** | SelfHost.lean HOST-SELF-HOST / SLAKE_SELF_HOST_V0 | Direction readiness only; not freestanding product self-host |
| Full syntax surface (Idris + Lean cores) | **open** | -- | Progressive gates only; no day-one full syntax claim |
| Full classic elaborator parity | **open** | -- | Host residual remains; not claimed |
| Freestanding product self-host complete | **open** | -- | HOST-SELF-HOST direction + SH5 SelfApply host-structural + SH5 SelfApplyFs freestanding extract/body + Mult..Emit parity ladder compose deepen (partial; freestandingSelfApplyReady true with freestandingParityLadderReady + freestandingProductSelfHostComplete = false) + HOST-PRODUCT-PATH productPathReady (unit/program + emit KernelEmit plan/apply/body + join unit joinUnitCompileReady + join program joinProgramCompileReady + self-host unit selfHostUnitReady + self-host program selfHostProgramReady + matrix unit matrixUnitReady + matrix program matrixProgramReady honesty; residual free false; complete false; open matrix rows stay open) + HOST-PRODUCT-PATH-CLOSE productPathCloseReady (structural ladder closed; residual free still open as claim); freestanding product self-host complete still open; LlvmHold freestandingProductSelfHostComplete = false; SH6 held |
| out/llvm-ir | **open** | -- | Deferred until true freestanding self-host (P6 hold; HOST-LLVM-HOLD gate documents hold -- not unlock) |
| CompCert PROVABLY | **open** | -- | Needs real ccomp + matrix; never forge (P6 hold; HOST-PROVABLY-HOLD documents hold) |
| Full Idris 2 core parity | **open** | -- | Not claimed; surface matrix is progressive |
| Full Lean 4 core parity | **open** | -- | Not claimed; surface matrix is progressive |

---

## Progressive gate composition (host)

```
matrixUnitReady hc
  = SelfHost.selfHostUnitReady hc && matrixSurfaceOk

matrixProgramReady p
  = SelfHost.selfHostProgramReady p && matrixSurfaceOk
```

Sibling bars: empty HostCompose may be matrix unit-ready; empty ordered program
is **not** matrix program-ready (EMPTY-PROGRAM-FAIL-CLOSED; P3 residual lesson).

`matrixSurfaceOk` is a constant canary: stage ids + three dual cites + host rows
present-partial + open rows open. Behavioral checks: SURFACE-MATRIX-SMOKE Lake
`example`s in `SurfaceMatrix.lean`.

---

## Non-claims

- Not day-one full Idris 2 + Lean 4 parity
- Not "superset complete"
- Not freestanding residual free
- Not PROVABLY
- Not freestanding product self-host complete
- Not permission to unlock `out/llvm-ir` from matrix inventory alone
- Does not invent duals under `src/idris2/` or `src/lean4/`
- Does not grow freestanding C or shell as residual progress

## Related

- PARTIAL host inventory: `host-partial-inventory.md` (Mult..SpecProof; 34 modules; HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH readiness + HOST-PRODUCT-PATH-CLOSE structural ladder close + HOST-DUAL-RESIDUAL dual residual honesty + HOST-PROBE-WIRE probe-vs-wire honesty + HOST-SPEC-PROOF formal spec-proof separation; intentional PARTIAL carry)
- Freestanding self-host acceptance: `self-host.md` (SH0; Mult kernel IR SH1;
  Mult host emit SH2; Mult closed-loop parity SH3; Linear freestanding path
  parity HOST-PARITY-LINEAR (`ParityLinear`); Types freestanding path parity
  HOST-PARITY-TYPES (`ParityTypes`); Program freestanding path parity
  HOST-PARITY-PROGRAM (`ParityProgram`); Emit freestanding path parity
  HOST-PARITY-EMIT (`ParityEmit`); SH4 partial -- KernelLinear
  (Linear start) + KernelTypes (Types growth) + KernelProgram (program/graph/
  compose) + KernelEmit (plan/apply/body codegen host honesty); SH5 self-apply
  partial -- SelfApply Mult+Linear+Types+Program+Emit; SH5 freestanding deepen
  partial -- SelfApplyFs freestandingExtractPathReady / freestandingBodyPathReady
  / freestandingParityLadderReady / freestandingSelfApplyReady (complete false);
  SH6 hold documented --
  LlvmHold; InventoryClose inventoryCloseReady (not residual free);
  ProductPath productPathReady with self-host-program+matrix deepen (not residual free; not
  product complete; open matrix rows stay open); not freestanding product self-host complete; not llvm
  unlocked; not PROVABLY)
- Goals superset bar: `doc/goals.md` (explicit surface matrix + progressive gates)
- Residual: `RESIDUAL-systems.md`
