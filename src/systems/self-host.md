# Freestanding self-host acceptance (SELF-HOST)

**Greppable:** SELF-HOST, SELF-HOST-ACCEPTANCE, SLAKE_SELF_HOST_KERNEL_MULT_V0,
SELF-HOST-KERNEL-MULT, SLAKE_SELF_HOST_EMIT_MULT_V0, HOST-EMIT-MULT,
SELF-HOST-EMIT-MULT, SLAKE_SELF_HOST_EMIT_LINEAR_V0, HOST-EMIT-LINEAR,
SELF-HOST-EMIT-LINEAR, SLAKE_SELF_HOST_PARITY_MULT_V0, HOST-PARITY-MULT,
SELF-HOST-PARITY-MULT, SLAKE_SELF_HOST_KERNEL_LINEAR_V0, SELF-HOST-KERNEL-LINEAR,
HOST-KERNEL-LINEAR, SLAKE_SELF_HOST_PARITY_LINEAR_V0, HOST-PARITY-LINEAR,
SELF-HOST-PARITY-LINEAR, SLAKE_SELF_HOST_KERNEL_TYPES_V0, SELF-HOST-KERNEL-TYPES,
HOST-KERNEL-TYPES, SLAKE_SELF_HOST_PARITY_TYPES_V0, HOST-PARITY-TYPES,
SELF-HOST-PARITY-TYPES, SLAKE_SELF_HOST_KERNEL_PROGRAM_V0, SELF-HOST-KERNEL-PROGRAM,
HOST-KERNEL-PROGRAM, SLAKE_SELF_HOST_PARITY_PROGRAM_V0, HOST-PARITY-PROGRAM,
SELF-HOST-PARITY-PROGRAM, SLAKE_SELF_HOST_KERNEL_EMIT_V0, SELF-HOST-KERNEL-EMIT,
HOST-KERNEL-EMIT, SLAKE_SELF_HOST_PARITY_EMIT_V0, HOST-PARITY-EMIT,
SELF-HOST-PARITY-EMIT, SLAKE_SELF_HOST_SELF_APPLY_V0, HOST-SELF-APPLY,
SELF-HOST-SELF-APPLY, SLAKE_SELF_HOST_SELF_APPLY_FS_V0, HOST-SELF-APPLY-FS,
SELF-HOST-SELF-APPLY-FS, SLAKE_SELF_HOST_LLVM_HOLD_V0, HOST-LLVM-HOLD,
SELF-HOST-LLVM-HOLD, HOST-PROVABLY-HOLD, HOST-SELF-HOST,
SLAKE_SELF_HOST_PRODUCT_PATH_V0, HOST-PRODUCT-PATH, SELF-HOST-PRODUCT-PATH,
SLAKE_SELF_HOST_BODY_V0, HOST-SELF-HOST-BODY, SELF-HOST-BODY,
SLAKE_EMIT_FREESTANDING_C_V0, defined freestanding compile step, RUNTIME-FS
**ASCII only.** Living residual Open Names (plain English): see
`RESIDUAL-systems.md`. **Self-host body** is defined (SELF-HOST-BODY); dual
algorithms into Slake stated in `join-map.md` / `JoinMap.joinAlgUseOk`. Next Open
is Thin process glue. Ownership map `emit/host-owned-emit.md`.

**North star:** Systems Lean / Slake can compile a defined freestanding surface
to runtimeless freestanding C with no classic Lean managed runtime on the
product wire. That complete bar is **not** claimed yet.

**Capability status (short):** Mult kernel + host Mult emit + Mult parity;
HOST-EMIT-LINEAR Linear/ConsumeToken product text; Linear / Types / Program /
Emit kernels and freestanding path parity (partial); host self-apply structural
only (not freestanding product self-host complete); llvm / CompCert PROVABLY
held; inventory / product path / dual residual / probe-vs-wire / spec-proof
honesty modules present; **SELF-HOST-BODY** defined freestanding compile step
(host SSOT -> FreestandingEmit -> emit/ + out/freestanding-c under gates).
Not residual free. Not PROVABLY. Not full self-host complete. Not llvm unlocked.
Not proof complete.

Related: `SystemsLean/SelfHost.lean` (direction canary only),
`SystemsLean/KernelMult.lean` (first kernel IR fixture),
`SystemsLean/EmitMult.lean` (host-owned Mult product C text),
`SystemsLean/EmitLinear.lean` (host-owned Linear + ConsumeToken product C text),
`SystemsLean/ParityMult.lean` (Mult closed-loop parity),
`SystemsLean/KernelLinear.lean` (Linear kernel IR + HostCompose path),
`SystemsLean/ParityLinear.lean` (Linear freestanding path parity Mult+Linear),
`SystemsLean/KernelTypes.lean` (Types kernel IR + program path),
`SystemsLean/ParityTypes.lean` (Types freestanding path parity Mult+Linear+Types),
`SystemsLean/KernelProgram.lean` (program / graph / compose path),
`SystemsLean/ParityProgram.lean` (Program freestanding path parity Mult+Linear+Types+Program),
`SystemsLean/KernelEmit.lean` (emit plan/apply/body codegen host honesty),
`SystemsLean/ParityEmit.lean` (Emit freestanding path parity Mult+Linear+Types+Program+Emit),
`SystemsLean/SelfApply.lean` (host self-application readiness),
`SystemsLean/SelfApplyFs.lean` (freestanding extract/body path deepen on kernel
emit compose + freestanding Mult..Emit parity ladder compose;
freestandingParityLadderReady / freestandingSelfApplyReady; not product complete),
`SystemsLean/LlvmHold.lean` (SH6 hold gate: llvm/PROVABLY not unlocked),
`SystemsLean/InventoryClose.lean` (HOST-INVENTORY-CLOSE: inventory close readiness;
not residual free),
`SystemsLean/ProductPath.lean` (HOST-PRODUCT-PATH: freestanding unit/program/
emit/join unit/join program/self-host unit+program/matrix unit+program product
path readiness after inventory close; productPathReady folds
freestandingEmitProductPathReady + freestandingJoinProductPathReady +
freestandingJoinProgramProductPathReady + freestandingSelfHostProductPathReady +
freestandingSelfHostProgramProductPathReady + freestandingMatrixUnitProductPathReady +
freestandingMatrixProgramProductPathReady; HOST-PRODUCT-PATH-CLOSE structural
ladder close via productPathCloseReady / productPathLadderClosedOk; not residual
free; not freestanding product self-host complete; open matrix rows stay open;
further ProductPath alias theater held),
`SystemsLean/DualResidual.lean` (HOST-DUAL-RESIDUAL: dual residual honesty;
hostElaboratorResidualRemains + productResidualRemains; residualFreeClaimed
false; dualResidualReady after product path close; neither residual forged free),
`SystemsLean/ProbeWire.lean` (HOST-PROBE-WIRE: probe-vs-wire honesty;
behavioralProbeIsSmokeDebt + product freestanding wire path cites;
residualFreeClaimed false; probeWireReady after dual residual; probe green is
not residual free or product complete),
`SystemsLean/SpecProof.lean` (HOST-SPEC-PROOF: formal spec-proof separation;
specSurfaceStated true; proofCompleteClaimed false; proofDoesNotRetireTests
true; residualFreeClaimed false; specProofReady after probe-wire; not proof
complete),
`SystemsLean/SelfHostBody.lean` (HOST-SELF-HOST-BODY / SELF-HOST-BODY: defined
freestanding compile step; selfHostBodyReady folds emitMultReady +
emitLinearReady + freestanding emit stage cite; freestandingProductSelfHostComplete
stays false; residual free stays false),
`SystemsLean/FreestandingEmit.lean` (SLAKE_EMIT_FREESTANDING_C_V0 writer),
`RESIDUAL-systems.md`, `doc/vocabulary.md` (wire / host model terms).

---

## Self-host body (SELF-HOST-BODY) -- acceptance first

**Greppable:** SELF-HOST-BODY, HOST-SELF-HOST-BODY, SLAKE_SELF_HOST_BODY_V0,
defined freestanding compile step, SLAKE_EMIT_FREESTANDING_C_V0, HOST-EMIT-SSOT,
HOST-EMIT-MULT, HOST-EMIT-LINEAR, selfHostBodyReady

This residual defines the **first real freestanding compile step** with a tiny
input surface and written acceptance. It is **not** another readiness canary
re-list of Mult..Emit / ProductPath / SelfApply.

### Input surface

| Piece | Path / owner |
|-------|----------------|
| Body dialect SSOT | `emit/host_emit_body_fragment.ssot.txt` (HOST-EMIT-SSOT) |
| Mult product text SSOT | `emit/host_emit_mult.ssot.txt` + Lean `EmitMult` (HOST-EMIT-MULT) |
| Linear product text SSOT | `emit/host_emit_linear.ssot.txt` + Lean `EmitLinear` (HOST-EMIT-LINEAR) |
| Wire templates | `emit/template_slake_freestanding.{h,c}.in` |
| Host emit writer | Lake exe `slake-emit-freestanding-c` (`SystemsLean.FreestandingEmit`) |

### Process

1. Lean host loads host SSOT + templates and writes product wire under
   `src/systems/emit/slake_freestanding.{h,c}` (stage `SLAKE_EMIT_FREESTANDING_C_V0`).
2. `just out-freestanding-c` copies the release surface to `out/freestanding-c/`.
3. Host pin `SystemsLean/SelfHostBody.lean` states this path and proves
   freestanding product self-host complete and residual free stay **false**.

### Output artifacts

- `src/systems/emit/slake_freestanding.{h,c}` -- product wire (generator output)
- `out/freestanding-c/slake_freestanding.{h,c}` -- release surface copy
- Greppable ownership tokens on the wire: HOST-EMIT-MULT, HOST-EMIT-LINEAR,
  HOST-EMIT-SSOT, MULT-0/1/OMEGA, LINEAR-EXACT-ONCE, RUNTIME-FS, not residual free

### What green means

| Gate / path | Role |
|-------------|------|
| `just systems-host` | Host module + SELF-HOST-BODY presence tokens |
| `just systems-emit-wire` | Emit product + FreestandingEmit + unit walk |
| `just out-freestanding-c` / `./src/systems/check.sh` | End-to-end emit write + release copy + hosted probe |
| Lake smokes on `SelfHostBody` | `selfHostBodyReady_true`; complete/free false proved |

Host pin: `selfHostBodyReady` = `EmitMult.emitMultReady` &&
`EmitLinear.emitLinearReady` && surface cites && freestanding emit stage cite &&
!complete && !residual free && !llvm unlock. Does **not** re-fold ProductPath /
SelfApply readiness theater.

### Explicit non-claims (still false / held)

| Claim | Status |
|-------|--------|
| freestandingProductSelfHostComplete | **false** (proved; SelfApplyFs + SelfHostBody) |
| residual free (either side) | **false** (DualResidual product residual remains) |
| Full Slake self-application of product compiler sources | **not** claimed |
| llvm unlock / `out/llvm-ir` | **held** (LlvmHold) |
| PROVABLY / CompCert seal | **held** |
| proof complete | **false** (SpecProof) |

---

## North-star goal

Systems Lean can compile itself to freestanding C with **no classic Lean runtime**
on the **product wire** (the emitted release surface under `emit/` and
`out/freestanding-c` -- not "network wire").

Three claims that must not be conflated:

| Claim | Meaning |
|-------|---------|
| **Product freestanding** | Emitted C has no Lean managed runtime and no product garbage collection (GC) |
| **Slake as compiler** | Real check / lower / emit path for a stated Systems Lean subset -- not readiness canaries alone |
| **Self-application** | That path can process the self-host kernel (and later its own compiler sources) |

Classic Lake remains a valid **bootstrap host** for development. "No classic Lean
runtime" targets the product wire, not "delete Lake tomorrow."

---

## Jargon unpack (this track)

| Term | Meaning here |
|------|----------------|
| **Product wire** | Released freestanding C (and install under `out/freestanding-c`). What consumers link. |
| **Host model** | Lean structural representation of grades / IR / checks. **Not** an AI or machine-learning model. |
| **Direction readiness** | HOST-SELF-HOST V0 inventory canary -- present paths and stage ids only. **Not** self-host. |
| **Kernel** | Smallest freestanding self-host unit set we close first (default: Mult grades). |
| **Closed loop** | Host lowers kernel to IR (+ later host-owned emit) with parity smoke vs product C. |

Canonical terms also live in `doc/vocabulary.md` (**Wire / product wire**,
**Model (host / formal)**).

---

## What does **not** count as self-host

- `HOST-SELF-HOST` / `SLAKE_SELF_HOST_V0` alone (direction canary)
- Structure-only `SLAKE_COMPILE_PATH_V0` shell greps
- Host Bool readiness maps without IR for a named kernel unit
- Growing bash `EMIT_*` stages as residual theater
- Unlocking `out/llvm-ir` or CompCert PROVABLY from inventory alone

---

## Self-host kernel (default)

| Phase | Kernel | Done means |
|-------|--------|------------|
| **SH0** | Acceptance prose (this file) | Greppable bar + non-claims |
| **SH1** | Mult grades (MULT-0 / MULT-1 / MULT-OMEGA) | Host builds real ordered IR for the three grades; fail-closed unknown tags; Lake smoke -- **done (partial)** in `KernelMult.lean` |
| **SH2** | Host-owned product emit for Mult | Product C text derived from host for Mult contracts; bash NON-SSOT -- **done (partial)** in `EmitMult.lean` + `emit/host_emit_mult.ssot.txt`. Linear + ConsumeToken freestanding text also host-owned: **HOST-EMIT-LINEAR** / `EmitLinear.lean` + `emit/host_emit_linear.ssot.txt` (ownership map `emit/host-owned-emit.md`; no EMIT_LINEAR_V0 residual C stage) |
| **SH3** | First closed loop | Host + product C parity smoke for Mult -- **done (partial)** in `ParityMult.lean` + probe Mult name/is_known/tag checks |
| **SH3b** | Linear freestanding path parity | Mult+Linear freestanding path honesty -- **done (partial)** in `ParityLinear.lean` HOST-PARITY-LINEAR / `linearParityReady` / `multLinearParityReady` + probe linear_token + CONSUME_TOKEN labels; composes KernelLinear + ParityMult; no new EMIT_* C stage; not freestanding product self-host complete |
| **SH3c** | Types freestanding path parity | Mult+Linear+Types freestanding path honesty -- **done (partial)** in `ParityTypes.lean` HOST-PARITY-TYPES / `typesParityReady` / `multLinearTypesParityReady` + probe TYPED_IR / slake_ir_node labels; composes KernelTypes + ParityLinear; no new EMIT_* C stage; not freestanding product self-host complete |
| **SH3d** | Program freestanding path parity | Mult+Linear+Types+Program freestanding path honesty -- **done (partial)** in `ParityProgram.lean` HOST-PARITY-PROGRAM / `programParityReady` / `multLinearTypesProgramParityReady` + probe IR_PROGRAM / IR_GRAPH / HOST_COMPOSE labels; composes KernelProgram + ParityTypes; no new EMIT_* C stage; not freestanding product self-host complete |
| **SH3e** | Emit freestanding path parity | Mult+Linear+Types+Program+Emit freestanding path honesty -- **done (partial)** in `ParityEmit.lean` HOST-PARITY-EMIT / `emitParityReady` / `multLinearTypesProgramEmitParityReady` + probe EMIT_PLAN / EMIT_APPLY / EMIT_BODY labels; composes KernelEmit + ParityProgram; no new EMIT_* C stage; not freestanding product self-host complete |
| **SH4** | Grow ladder | Linear / types / program / compose / emit path as real codegen -- **done (partial growth)**: `KernelLinear.lean` Linear ordered IR + HostCompose mint/consume path; `KernelTypes.lean` Types / typed IR ordered IR + program-path fold honesty; `KernelProgram.lean` ordered IR program + graph edges + HostCompose path honesty; `KernelEmit.lean` host-owned emit plan/apply/body path over program kernel + Mult emit honesty (`emitKernelReady`); product wire bulk still frozen at EMIT_BODY_V0 except HOST-EMIT-SSOT + HOST-EMIT-MULT + HOST-EMIT-LINEAR (no new EMIT_* C residual stage) |
| **SH5** | Compiler self-application | **done (partial)** + **freestanding deepen (partial)**: `SelfApply.lean` host self-application readiness (`selfApplyReady` / `kernelRebuildsKernel` = Mult closed loop + Linear + Types + Program + Emit kernel); SELF-APPLY-THEOREM (`selfApplyReady_true`, `kernelRebuildsKernel_true`); structural host kernel-rebuilds-kernel only. **SH5 freestanding deepen:** `SelfApplyFs.lean` HOST-SELF-APPLY-FS / SELF-HOST-SELF-APPLY-FS / `SLAKE_SELF_HOST_SELF_APPLY_FS_V0` (`freestandingExtractPathReady` RUNTIME-FS extract on kernel emit compose; `freestandingBodyPathReady` HOST-EMIT-SSOT body + EmitMult; `freestandingParityLadderReady` = ParityEmit.multLinearTypesProgramEmitParityReady (Mult..Emit freestanding parity compose; dual alias freestandingEmitParityReady = emitParityReady -- equivalent under folds, not a stronger gate); `freestandingSelfApplyReady` = selfApplyReady && path && freestandingParityLadderReady && surface && !complete; `freestandingProductSelfHostComplete` = false; SELF-APPLY-FS-SMOKE; SELF-APPLY-FS-THEOREM (`freestandingSelfApplyReady_true`, `freestandingProductSelfHostComplete_false`)) -- **not** freestanding product self-host complete; SH6 still held |
| **SH6** | llvm / PROVABLY | **held (documented)**: `LlvmHold.lean` host hold gate (`llvmHoldReady` / `sh6HoldReady` = true; `llvmUnlocked` / `provablyUnlocked` / `freestandingProductSelfHostComplete` = false; `selfApplyDoesNotUnlockLlvm`); greppable HOST-LLVM-HOLD / HOST-PROVABLY-HOLD / LLVM-HOLD-SMOKE; LLVM-HOLD-THEOREM (`llvmHoldReady_true`, `llvmUnlocked_false`, `provablyUnlocked_false`) -- **not** unlocked; not residual-open llvm mill; real freestanding product self-host + real `ccomp` for PROVABLY still required |
| **Inventory close** | Host inventory close readiness | **done (partial)**: `InventoryClose.lean` HOST-INVENTORY-CLOSE / SELF-HOST-INVENTORY-CLOSE / `SLAKE_SELF_HOST_INVENTORY_CLOSE_V0` (`inventoryCloseReady` = freestandingSelfApplyReady && llvmHoldReady && surface && partialCarry && !complete && !llvmUnlocked && !provablyUnlocked; `residualFreeClaimed` = false; `inventoryCloseDoesNotMeanResidualFree`; INVENTORY-CLOSE-SMOKE; INVENTORY-CLOSE-THEOREM (`inventoryCloseReady_true`, `residualFreeClaimed_false`)) -- Mult..LlvmHold ladder + CLOSABLE-MISS-COUNT-0 compose; **not** residual free; **not** freestanding product self-host complete; intentional PARTIAL carry remains |
| **Product path** | Freestanding product path readiness | **done (partial, self-host-program+matrix deepen)**: `ProductPath.lean` HOST-PRODUCT-PATH / SELF-HOST-PRODUCT-PATH / `SLAKE_SELF_HOST_PRODUCT_PATH_V0` (`productPathReady` = inventoryCloseReady && freestandingUnitProductPathReady && freestandingProgramProductPathReady && freestandingEmitProductPathReady && freestandingJoinProductPathReady && freestandingJoinProgramProductPathReady && freestandingSelfHostProductPathReady && freestandingSelfHostProgramProductPathReady && freestandingMatrixUnitProductPathReady && freestandingMatrixProgramProductPathReady && surface && !residual free claimed && !product complete claimed && !SelfApplyFs complete && !llvm unlock && !provably unlock; `freestandingUnitProductPathReady` unitCompileReady / extractOkFs on empty/unminted/lowerEmitCompose; sibling `freestandingProgramProductPathReady` empty program fail-closed + lowered kernel well-typed; `freestandingEmitProductPathReady` = emitPlanPathReady && emitApplyPathReady && emitBodyPathReady && emitKernelReady && freestandingBodyPathReady (HOST-KERNEL-EMIT / HOST-EMIT-SSOT / HOST-EMIT-MULT reuse); `freestandingJoinProductPathReady` = joinUnitCompileReady empty/unminted/lowerEmitCompose (HOST-JOIN-MAP); dual alias freestandingJoinUnitProductPathReady; sibling `freestandingJoinProgramProductPathReady` empty program joinProgramCompileReady false + lowerProgramKernel joinProgramCompileReady + isWellTyped (EMPTY-PROGRAM-FAIL-CLOSED); `freestandingSelfHostProductPathReady` = selfHostUnitReady empty/unminted/lowerEmitCompose (HOST-SELF-HOST / SLAKE_SELF_HOST_V0; direction only); dual alias freestandingSelfHostUnitProductPathReady; sibling `freestandingSelfHostProgramProductPathReady` empty program selfHostProgramReady false + lowerProgramKernel selfHostProgramReady + isWellTyped (EMPTY-PROGRAM-FAIL-CLOSED; direction only -- not freestanding product self-host complete); `freestandingMatrixUnitProductPathReady` = matrixUnitReady empty/unminted/lowerEmitCompose (HOST-SURFACE-MATRIX / SLAKE_SURFACE_MATRIX_V0; open rows stay open); sibling `freestandingMatrixProgramProductPathReady` empty program matrixProgramReady false + lowerProgramKernel matrixProgramReady + isWellTyped (not day-one full Idris+Lean parity); `productPathDoesNotComplete` / `productPathDoesNotMeanResidualFree`; PRODUCT-PATH-SMOKE; PRODUCT-PATH-THEOREM (`productPathReady_true`, `residualFreeClaimed_false`)) -- **not** residual free; **not** freestanding product self-host complete; intentional PARTIAL carry remains |
| **Product path close** | Structural product path ladder close | **done (partial)**: same `ProductPath.lean` HOST-PRODUCT-PATH-CLOSE / SELF-HOST-PRODUCT-PATH-CLOSE / `SLAKE_SELF_HOST_PRODUCT_PATH_CLOSE_V0` (`productPathCloseReady` / `productPathLadderClosedOk` = productPathReady && productPathCloseSurfaceOk && productPathFurtherAliasTheaterHeld && !residual free claimed && !product complete claimed && !SelfApplyFs complete && !llvm unlock && !provably unlock; `productPathCloseDoesNotMeanResidualFree`; structural product path ladder closed token; intentional PARTIAL carry; `productPathFurtherAliasTheaterHeld` holds further inventoryCloseReady-implied ProductPath conjunct-only re-asserts as theater; PRODUCT-PATH-CLOSE-SMOKE; PRODUCT-PATH-THEOREM (`productPathCloseReady_true`, `productPathFurtherAliasTheaterHeld_true`)) -- **not** residual free; **not** freestanding product self-host complete; residual free still open as claim; further ProductPath alias theater held |
| **Dual residual** | Host elaborator residual vs product residual honesty | **done (partial)**: `DualResidual.lean` HOST-DUAL-RESIDUAL / SELF-HOST-DUAL-RESIDUAL / `SLAKE_SELF_HOST_DUAL_RESIDUAL_V0` (`dualResidualReady` = productPathCloseReady && surface && dualResidualSurfacesDistinct && hostElaboratorResidualRemains && productResidualRemains && free/complete/unlock claims false; `hostElaboratorResidualRemains` true; `productResidualRemains` true; `hostElaboratorResidualFreeClaimed` / `residualFreeClaimed` / `productSelfHostCompleteClaimed` false; `dualResidualDoesNotMeanResidualFree` / `dualResidualDoesNotForgeEitherFree`; DUAL-RESIDUAL-SMOKE; DUAL-RESIDUAL-THEOREM (`dualResidualReady_true`, both residuals remain)) -- dual residual honesty only; **not** residual free either side; **not** freestanding product self-host complete; **not** llvm unlock |
| **Probe-vs-wire** | Hosted behavioral probe vs product freestanding wire honesty | **done (partial)**: `ProbeWire.lean` HOST-PROBE-WIRE / SELF-HOST-PROBE-WIRE / `SLAKE_SELF_HOST_PROBE_WIRE_V0` (`probeWireReady` = dualResidualReady && surface && probeWireSurfacesDistinct && behavioralProbeIsSmokeDebt && behavioralProbeIsNotProductWire && productWireIsEmitPath && probeDoesNotReplaceProductWire && free/complete/unlock claims false; `behavioralProbeIsSmokeDebt` true; `behavioralProbeIsNotProductWire` true; `productWireIsEmitPath` true; `probeDoesNotReplaceProductWire` true; `residualFreeClaimed` / `productSelfHostCompleteClaimed` false; `probeWireDoesNotMeanResidualFree` / `probeWireDoesNotMeanProductComplete`; PROBE-WIRE-SMOKE; PROBE-WIRE-THEOREM (`probeWireReady_true`, `behavioralProbeIsSmokeDebt_true`)) -- probe-vs-wire honesty only; probe under `smoke/` is smoke debt; product wire is `emit/` + `out/freestanding-c/`; probe green is **not** residual free; **not** freestanding product self-host complete; **not** llvm unlock |
| **Spec-proof** | Formal specification vs proof separation honesty | **done (partial)**: `SpecProof.lean` HOST-SPEC-PROOF / SELF-HOST-SPEC-PROOF / `SLAKE_SELF_HOST_SPEC_PROOF_V0` (`specProofReady` = probeWireReady && surface && specSurfaceStated && proofDoesNotRetireTests && specDoesNotImplyProofComplete && free/complete/unlock / proof-complete claims false; `specSurfaceStated` true; `proofCompleteClaimed` false; `proofDoesNotRetireTests` true; `residualFreeClaimed` / `productSelfHostCompleteClaimed` false; `specProofDoesNotMeanResidualFree` / `specProofDoesNotMeanProofComplete`; SPEC-PROOF-SMOKE; SPEC-PROOF-THEOREM (`specProofReady_true`, `proofCompleteClaimed_false`)) -- formal feedback honesty only; readable specs stated; proof complete **not** forged; proofs do not retire tests/smokes; **not** residual free; **not** freestanding product self-host complete; **not** llvm unlock |
| **Self-host body** | Defined freestanding compile step (acceptance first) | **done (partial)**: plain-English acceptance above (SELF-HOST-BODY); `SelfHostBody.lean` HOST-SELF-HOST-BODY / SELF-HOST-BODY / `SLAKE_SELF_HOST_BODY_V0` (`selfHostBodyReady` = emitMultReady && emitLinearReady && surface && freestanding emit stage cite && free/complete/unlock false; `freestandingProductSelfHostComplete` false; `residualFreeClaimed` false; SELF-HOST-BODY-SMOKE; SELF-HOST-BODY-THEOREM (`selfHostBodyReady_true`, `freestandingProductSelfHostComplete_false`, `residualFreeClaimed_false`)); E2E path under gates via FreestandingEmit + `just out-freestanding-c` / check.sh -- **not** residual free; **not** freestanding product self-host complete; **not** full product compiler self-application; **not** llvm unlock |

Defaults (open questions answered by plan defaults until human overrides):

1. Mult first.
2. Host `.lean` is the Systems Lean surface for now; `.slake` stays unit-surface markers.
3. Lake bootstrap allowed for development indefinitely.
4. Host-owned freestanding ABI stays compatible with frozen wire contracts where honest.
5. This file is the acceptance home.
6. Full freestanding product kernel rebuilds kernel unlocks llvm **planning**;
   SH5 host-structural `kernelRebuildsKernel` (Mult closed loop + Linear + Types
   + Program + Emit kernel on the classic elaborator) does **not** unlock llvm
   planning as residual-open. Full ladder is progressive after true freestanding
   product self-host.
7. Pure Nix for gates; Lean owns emit truth; thin scripts install only.

---

## Green bar (gates)

```bash
just systems-host
just systems-emit-wire
just hygiene
./src/systems/check.sh
```

Plus Lake smokes in the active kernel / emit / parity / self-apply / freestanding
self-apply / hold modules (KERNEL-MULT-SMOKE, EMIT-MULT-SMOKE /
HOST-EMIT-MULT-SMOKE, PARITY-MULT-SMOKE / HOST-PARITY-MULT-SMOKE,
KERNEL-LINEAR-SMOKE, PARITY-LINEAR-SMOKE / HOST-PARITY-LINEAR-SMOKE,
KERNEL-TYPES-SMOKE, PARITY-TYPES-SMOKE / HOST-PARITY-TYPES-SMOKE,
KERNEL-PROGRAM-SMOKE, PARITY-PROGRAM-SMOKE / HOST-PARITY-PROGRAM-SMOKE,
KERNEL-EMIT-SMOKE, PARITY-EMIT-SMOKE / HOST-PARITY-EMIT-SMOKE,
SELF-APPLY-SMOKE / HOST-SELF-APPLY-SMOKE, SELF-APPLY-FS-SMOKE /
HOST-SELF-APPLY-FS-SMOKE, LLVM-HOLD-SMOKE / HOST-LLVM-HOLD-SMOKE,
INVENTORY-CLOSE-SMOKE / HOST-INVENTORY-CLOSE-SMOKE,
PRODUCT-PATH-SMOKE / HOST-PRODUCT-PATH-SMOKE,
PRODUCT-PATH-CLOSE-SMOKE / HOST-PRODUCT-PATH-CLOSE-SMOKE,
DUAL-RESIDUAL-SMOKE / HOST-DUAL-RESIDUAL-SMOKE,
PROBE-WIRE-SMOKE / HOST-PROBE-WIRE-SMOKE,
SPEC-PROOF-SMOKE / HOST-SPEC-PROOF-SMOKE) and product
Mult / Linear / Emit behavioral checks in `smoke/slake_behavioral_probe.c`
(hosted smoke debt -- not product freestanding wire residual progress).

---

## Honesty

- Still **not residual free**
- Still **not** freestanding product self-host complete (SH5 partial is host
  structural self-application; SH5 freestanding deepen is extract/body path
  honesty on kernel emit compose + host self-apply + freestanding Mult..Emit
  parity ladder compose -- Mult + Linear + Types + Program + Emit + RUNTIME-FS
  body/extract + freestandingParityLadderReady; not product freestanding C
  rebuilding full Slake; both `SelfApplyFs` and `LlvmHold` encode
  freestandingProductSelfHostComplete = false)
- Still **not PROVABLY** (`provablyUnlocked` = false; real `ccomp` still required)
- SH6 llvm / PROVABLY remains **held (documented)** via `LlvmHold.lean`
  (`llvmHoldReady` true, `llvmUnlocked` false; SH5 partial and freestanding
  deepen do not unlock llvm)
- `out/llvm-ir` product path still deferred
- SH4 ladder host growth (Linear / Types / Program / Emit codegen honesty) is
  substantially complete on the host surface; Mult+Linear freestanding Linear
  path parity partial landed (`ParityLinear` multLinearParityReady);
  Mult+Linear+Types freestanding Types path parity partial landed
  (`ParityTypes` multLinearTypesParityReady); Mult+Linear+Types+Program
  freestanding Program path parity partial landed (`ParityProgram`
  multLinearTypesProgramParityReady); Mult+Linear+Types+Program+Emit
  freestanding Emit path parity partial landed (`ParityEmit`
  multLinearTypesProgramEmitParityReady); SH5 freestanding deepen partial
  landed (`SelfApplyFs` including freestandingParityLadderReady Mult..Emit
  parity compose); host inventory close readiness landed (`InventoryClose`
  inventoryCloseReady; residualFreeClaimed false); freestanding product path
  readiness landed with self-host-program+matrix deepen (`ProductPath`
  productPathReady folds freestandingEmitProductPathReady +
  freestandingJoinProductPathReady + freestandingJoinProgramProductPathReady +
  freestandingSelfHostProductPathReady + freestandingSelfHostProgramProductPathReady +
  freestandingMatrixUnitProductPathReady + freestandingMatrixProgramProductPathReady;
  residualFreeClaimed false; not freestanding product self-host complete; open
  matrix rows stay open); structural product path ladder close landed
  (HOST-PRODUCT-PATH-CLOSE productPathCloseReady / productPathLadderClosedOk;
  productPathFurtherAliasTheaterHeld; residual free still open as claim);
  dual residual honesty landed (`DualResidual` dualResidualReady;
  hostElaboratorResidualRemains true; productResidualRemains true;
  residualFreeClaimed false; neither residual forged free);
  probe-vs-wire honesty landed (`ProbeWire` probeWireReady;
  behavioralProbeIsSmokeDebt true; product freestanding wire distinct from
  hosted probe; residualFreeClaimed false; probe green is not residual free);
  formal spec-proof separation landed (`SpecProof` specProofReady;
  specSurfaceStated true; proofCompleteClaimed false; proofDoesNotRetireTests
  true; residualFreeClaimed false; not proof complete);
  Mult MULT-THEOREM / HOST-MULT-THEOREM landed on Mult.lean
  (ofNat?_fail_closed / isValidTag_fail_closed / ofNat?_zero/one/two /
  isValid_true -- FAIL-CLOSED-UNKNOWN-GRADE proved for raw tags; partial Mult
  only; proofCompleteClaimed stays false);
  Types TYPES-THEOREM / HOST-TYPES-THEOREM landed on Types.lean
  (ofKindTag?_fail_closed / isValidKindTag_fail_closed / ofKindTag?_zero/one/two /
  kindMultOk known + mismatch + mkNode?_mismatch_none -- FAIL-CLOSED-UNKNOWN-KIND
  proved for raw tags; partial Types only; proofCompleteClaimed stays false);
  IrProgram IR-PROGRAM-THEOREM / HOST-IR-PROGRAM-THEOREM landed on IrProgram.lean
  (isWellTyped_empty_false / empty_not_well_typed / foldWellTyped_empty_none /
  push_bad_node / foldWellTyped_single_value_some -- EMPTY-PROGRAM-FAIL-CLOSED
  proved + single-node fold success; partial IrProgram only;
  proofCompleteClaimed stays false);
  CompilePath COMPILE-PATH-THEOREM / HOST-COMPILE-PATH-THEOREM landed
  (compileReady_empty_true / programCompileReady_empty_false /
  empty_host_ok_ne_empty_program_ok; partial only; proofCompleteClaimed stays false);
  IrGraph IR-GRAPH-THEOREM / HOST-IR-GRAPH-THEOREM landed
  (isWellTyped_empty_true / addEdge_empty_badEndpoints / pushNode_value_one_ok /
  addEdge_one_node_self_ok / addEdge_one_node_badEndpoints -- EMPTY-GRAPH-OK +
  one-node push/edge success + fail-closed; partial only; proofCompleteClaimed
  stays false);
  Linear LINEAR-THEOREM / HOST-LINEAR-THEOREM landed
  (shareNat_eq / polyId_id / roundTrip_eq; JOIN-ALG honest limited; axioms remain;
  no MULT-1 enforcement claim; proofCompleteClaimed stays false);
  HostCompose COMPOSE-THEOREM / HOST-COMPOSE-THEOREM landed
  (multPreScan empty / mint-consume / double_consume_notLive / nodeMultOk /
  pushHostNode_bad_node / pushHostNode_value_one_ok /
  addHostEdge_empty_badEndpoints / addHostEdge_two_values_ok /
  addHostEdge_one_node_badEndpoints;
  live-flag only; proofCompleteClaimed stays false);
  Extract EXTRACT-THEOREM / HOST-EXTRACT-THEOREM landed
  (RUNTIME-FS-only + ofRuntimeTag?_fail_closed; MULT-1 thinning intentional;
  proofCompleteClaimed stays false);
  Erasure ERASURE-THEOREM / HOST-ERASURE-THEOREM landed
  (mark fail-closed / ERASE-RULE-MULT-0; proofCompleteClaimed stays false);
  EmitBody EMIT-BODY-THEOREM / HOST-EMIT-BODY-THEOREM landed
  (HOST-EMIT-SSOT empty fragment + bodyCap; proofCompleteClaimed stays false);
  EmitPlan EMIT-PLAN-THEOREM / HOST-EMIT-PLAN-THEOREM landed
  (empty ready/counts + planOk_mult1_unminted_false + minted/marked inventory;
  proofCompleteClaimed stays false);
  EmitApply EMIT-APPLY-THEOREM / HOST-EMIT-APPLY-THEOREM landed
  (applyCap_eq_32 + applyOk_empty_true + packTag_linear +
  applyOk_linear_without_mint_false; proofCompleteClaimed stays false);
  JoinMap JOIN-MAP-THEOREM / HOST-JOIN-MAP-THEOREM landed
  (joinUnitCompileReady_empty_true + joinProgramCompileReady_empty_false +
  joinAlgContractOk_true + joinAlgUseOk_true; three dual host uses;
  stated map join-map.md; surface canaries not formal duals;
  proofCompleteClaimed stays false);
  SelfHost SELF-HOST-THEOREM / HOST-SELF-HOST-THEOREM landed
  (selfHostUnitReady_empty_true + selfHostProgramReady_empty_false +
  hostSurfaceOk_true + selfHostUnitReady_mult1_unminted_false /
  selfHostUnitReady_mult1_minted_true + selfHostProgramReady_single_value;
  direction + path fixtures; proofCompleteClaimed stays false);
  KernelMult KERNEL-MULT-THEOREM / HOST-KERNEL-MULT-THEOREM landed
  (multKernelReady_true + kernelOk_true + programCompileReady_empty_false +
  lowerMultKernel_length_three / lowerMultKernel_isWellTyped +
  multKernelProgram_length_three / multKernelProgram_isWellTyped;
  fixture content; proofCompleteClaimed stays false);
  KernelLinear KERNEL-LINEAR-THEOREM / HOST-KERNEL-LINEAR-THEOREM landed
  (linearKernelReady_true + linearKernelOk_true + programCompileReady_empty_false +
  lowerLinearKernel_length_one / lowerLinearKernel_isWellTyped +
  linearKernelProgram_length_one / linearKernelProgram_isWellTyped;
  Linear IR + host compose content; proofCompleteClaimed stays false);
  ParityMult PARITY-MULT-THEOREM / HOST-PARITY-MULT-THEOREM landed
  (multParityReady_true + gradeParityOk_true + ofNatRoundTripOk_true;
  Mult grades only; proofCompleteClaimed stays false);
  KernelTypes KERNEL-TYPES-THEOREM / HOST-KERNEL-TYPES-THEOREM landed
  (typesKernelReady_true + typesKernelOk_true + programCompileReady_empty_false +
  lowerTypesKernel_length_three / lowerTypesKernel_isWellTyped +
  typesKernelProgram_length_three / typesKernelProgram_isWellTyped;
  Types IR + program path content; proofCompleteClaimed stays false);
  KernelProgram KERNEL-PROGRAM-THEOREM / HOST-KERNEL-PROGRAM-THEOREM landed
  (programKernelReady_true + programKernelOk_true + programCompileReady_empty_false +
  lowerProgramKernel_length_three / lowerProgramKernel_isWellTyped +
  programKernelProgram_length_three / programKernelProgram_isWellTyped;
  program/graph/compose content; proofCompleteClaimed stays false);
  KernelEmit KERNEL-EMIT-THEOREM / HOST-KERNEL-EMIT-THEOREM landed
  (emitKernelReady_true + emitKernelOk_true + emitPlanPathReady_true +
  lowerEmitCompose_isSome / lowerEmitCompose_plan_counts /
  lowerEmitCompose_apply_tags / lowerEmitCompose_body_fragment;
  codegen content; proofCompleteClaimed stays false);
  ParityLinear PARITY-LINEAR-THEOREM / HOST-PARITY-LINEAR-THEOREM landed
  (linearParityReady_true + linearContractParityOk_true + multLinearParityReady_true;
  Linear freestanding path only; proofCompleteClaimed stays false);
  ParityTypes PARITY-TYPES-THEOREM / HOST-PARITY-TYPES-THEOREM landed
  (typesParityReady_true + typesContractParityOk_true + multLinearTypesParityReady_true;
  Types freestanding path only; proofCompleteClaimed stays false);
  ParityProgram PARITY-PROGRAM-THEOREM / HOST-PARITY-PROGRAM-THEOREM landed
  (programParityReady_true + programContractParityOk_true +
  multLinearTypesProgramParityReady_true; Program freestanding path only;
  proofCompleteClaimed stays false);
  ParityEmit PARITY-EMIT-THEOREM / HOST-PARITY-EMIT-THEOREM landed
  (emitParityReady_true + emitContractParityOk_true +
  multLinearTypesProgramEmitParityReady_true; Emit freestanding path only;
  proofCompleteClaimed stays false);
  SurfaceMatrix SURFACE-MATRIX-THEOREM / HOST-SURFACE-MATRIX-THEOREM landed
  (matrixUnitReady_empty_true + matrixProgramReady_empty_false +
  matrixSurfaceOk_true + matrixUnitReady_mult1_unminted_false /
  matrixUnitReady_mult1_minted_true + matrixProgramReady_single_value;
  inventory + path fixtures; proofCompleteClaimed stays false);
  SelfApply SELF-APPLY-THEOREM / HOST-SELF-APPLY-THEOREM landed
  (selfApplyReady_true + kernelRebuildsKernel_true; host structural only;
  proofCompleteClaimed stays false);
  SelfApplyFs SELF-APPLY-FS-THEOREM / HOST-SELF-APPLY-FS-THEOREM landed
  (freestandingSelfApplyReady_true + freestandingProductSelfHostComplete_false;
  complete stays false; proofCompleteClaimed stays false);
  InventoryClose INVENTORY-CLOSE-THEOREM / HOST-INVENTORY-CLOSE-THEOREM landed
  (inventoryCloseReady_true + residualFreeClaimed_false; residual free stays
  false; proofCompleteClaimed stays false);
  ProductPath PRODUCT-PATH-THEOREM / HOST-PRODUCT-PATH-THEOREM landed
  (productPathReady_true + productPathCloseReady_true + residualFreeClaimed_false
  + productPathFurtherAliasTheaterHeld_true; alias theater held;
  proofCompleteClaimed stays false);
  DualResidual DUAL-RESIDUAL-THEOREM / HOST-DUAL-RESIDUAL-THEOREM landed
  (dualResidualReady_true + hostElaboratorResidualRemains_true +
  productResidualRemains_true + residualFreeClaimed_false; neither free;
  proofCompleteClaimed stays false);
  ProbeWire PROBE-WIRE-THEOREM / HOST-PROBE-WIRE-THEOREM landed
  (probeWireReady_true + behavioralProbeIsSmokeDebt_true +
  residualFreeClaimed_false; proofCompleteClaimed stays false);
  SpecProof SPEC-PROOF-THEOREM / HOST-SPEC-PROOF-THEOREM landed
  (specProofReady_true + proofCompleteClaimed_false + residualFreeClaimed_false
  + proofDoesNotRetireTests_true + specSurfaceStated_true; proof complete stays
  false); LlvmHold LLVM-HOLD-THEOREM / HOST-LLVM-HOLD-THEOREM landed
  (llvmHoldReady_true + llvmUnlocked_false + provablyUnlocked_false; hold not
  unlock; proofCompleteClaimed stays false);
  remaining freestanding product residual pivots toward deeper Mult/Linear/Types
  host theorems beyond readiness canaries, or EmitMult EMIT-MULT-THEOREM if
  cheap, or true freestanding product rebuild without forging complete /
  residual free / proof complete -- not bash EMIT_* theater and not an llvm
  unlock mill and not ProductPath alias theater and not probe-body growth
- Host elaborator residual (classic Lean managed runtime on Lake) stays separate
  from product wire residual (HOST-DUAL-RESIDUAL canaries + DUAL-RESIDUAL-THEOREM)
- Hosted behavioral probe (`smoke/slake_behavioral_probe.c`) stays smoke debt
  separate from product freestanding wire (`emit/` + `out/freestanding-c/`)
  (HOST-PROBE-WIRE canaries + PROBE-WIRE-THEOREM); probe green does not mean
  residual free
- Readable specifications are stated separately from proof-complete claims
  (HOST-SPEC-PROOF canaries + SPEC-PROOF-THEOREM); Mult..SpecProof readiness
  theorems do not flip proof complete; proofs do not retire tests/smokes
- Do not forge either residual; do not treat probe as product wire; do not
  forge proof complete
