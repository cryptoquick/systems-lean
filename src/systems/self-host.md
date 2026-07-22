# Freestanding self-host acceptance (SELF-HOST)

**Greppable:** SELF-HOST, SELF-HOST-ACCEPTANCE, SLAKE_SELF_HOST_KERNEL_MULT_V0,
SELF-HOST-KERNEL-MULT, SLAKE_SELF_HOST_EMIT_MULT_V0, HOST-EMIT-MULT,
SELF-HOST-EMIT-MULT, SLAKE_SELF_HOST_PARITY_MULT_V0, HOST-PARITY-MULT,
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
RUNTIME-FS
**ASCII only.** Status: SH0 acceptance + SH1 Mult kernel IR + SH2 host Mult
emit + SH3 Mult closed-loop parity + SH4 Linear kernel start + Mult+Linear
freestanding Linear path parity (`ParityLinear.lean`) + Types kernel growth +
Types freestanding path parity Mult+Linear+Types (`ParityTypes.lean`) +
Program kernel growth + Program freestanding path parity
Mult+Linear+Types+Program (`ParityProgram.lean`) + Emit / codegen host honesty
+ Emit freestanding path parity Mult+Linear+Types+Program+Emit
(`ParityEmit.lean`) + SH5 self-apply (partial) + SH5 freestanding deepen
(partial) via `SelfApplyFs.lean` + SH6 llvm/PROVABLY **held (documented)** via
`LlvmHold.lean` + host inventory close via `InventoryClose.lean` + freestanding
product path via `ProductPath.lean`. Not freestanding residual free. Not PROVABLY.
Not full self-host complete. Not llvm unlocked.

Related: `SystemsLean/SelfHost.lean` (direction canary only),
`SystemsLean/KernelMult.lean` (first kernel IR fixture),
`SystemsLean/EmitMult.lean` (host-owned Mult product C text),
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
`SystemsLean/ProductPath.lean` (HOST-PRODUCT-PATH: freestanding unit/program
product path readiness after inventory close; productPathReady; not residual
free; not freestanding product self-host complete),
`RESIDUAL-systems.md`, `doc/vocabulary.md` (wire / host model terms).

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
| **SH2** | Host-owned product emit for Mult | Product C text derived from host for Mult contracts; bash NON-SSOT -- **done (partial)** in `EmitMult.lean` + `emit/host_emit_mult.ssot.txt` |
| **SH3** | First closed loop | Host + product C parity smoke for Mult -- **done (partial)** in `ParityMult.lean` + probe Mult name/is_known/tag checks |
| **SH3b** | Linear freestanding path parity | Mult+Linear freestanding path honesty -- **done (partial)** in `ParityLinear.lean` HOST-PARITY-LINEAR / `linearParityReady` / `multLinearParityReady` + probe linear_token + CONSUME_TOKEN labels; composes KernelLinear + ParityMult; no new EMIT_* C stage; not freestanding product self-host complete |
| **SH3c** | Types freestanding path parity | Mult+Linear+Types freestanding path honesty -- **done (partial)** in `ParityTypes.lean` HOST-PARITY-TYPES / `typesParityReady` / `multLinearTypesParityReady` + probe TYPED_IR / slake_ir_node labels; composes KernelTypes + ParityLinear; no new EMIT_* C stage; not freestanding product self-host complete |
| **SH3d** | Program freestanding path parity | Mult+Linear+Types+Program freestanding path honesty -- **done (partial)** in `ParityProgram.lean` HOST-PARITY-PROGRAM / `programParityReady` / `multLinearTypesProgramParityReady` + probe IR_PROGRAM / IR_GRAPH / HOST_COMPOSE labels; composes KernelProgram + ParityTypes; no new EMIT_* C stage; not freestanding product self-host complete |
| **SH3e** | Emit freestanding path parity | Mult+Linear+Types+Program+Emit freestanding path honesty -- **done (partial)** in `ParityEmit.lean` HOST-PARITY-EMIT / `emitParityReady` / `multLinearTypesProgramEmitParityReady` + probe EMIT_PLAN / EMIT_APPLY / EMIT_BODY labels; composes KernelEmit + ParityProgram; no new EMIT_* C stage; not freestanding product self-host complete |
| **SH4** | Grow ladder | Linear / types / program / compose / emit path as real codegen -- **done (partial growth)**: `KernelLinear.lean` Linear ordered IR + HostCompose mint/consume path; `KernelTypes.lean` Types / typed IR ordered IR + program-path fold honesty; `KernelProgram.lean` ordered IR program + graph edges + HostCompose path honesty; `KernelEmit.lean` host-owned emit plan/apply/body path over program kernel + Mult emit honesty (`emitKernelReady`); product wire bulk still frozen at EMIT_BODY_V0 except HOST-EMIT-SSOT + HOST-EMIT-MULT (no new EMIT_* C stage) |
| **SH5** | Compiler self-application | **done (partial)** + **freestanding deepen (partial)**: `SelfApply.lean` host self-application readiness (`selfApplyReady` / `kernelRebuildsKernel` = Mult closed loop + Linear + Types + Program + Emit kernel); structural host kernel-rebuilds-kernel only. **SH5 freestanding deepen:** `SelfApplyFs.lean` HOST-SELF-APPLY-FS / SELF-HOST-SELF-APPLY-FS / `SLAKE_SELF_HOST_SELF_APPLY_FS_V0` (`freestandingExtractPathReady` RUNTIME-FS extract on kernel emit compose; `freestandingBodyPathReady` HOST-EMIT-SSOT body + EmitMult; `freestandingParityLadderReady` = ParityEmit.multLinearTypesProgramEmitParityReady (Mult..Emit freestanding parity compose; dual alias freestandingEmitParityReady = emitParityReady -- equivalent under folds, not a stronger gate); `freestandingSelfApplyReady` = selfApplyReady && path && freestandingParityLadderReady && surface && !complete; `freestandingProductSelfHostComplete` = false; SELF-APPLY-FS-SMOKE) -- **not** freestanding product self-host complete; SH6 still held |
| **SH6** | llvm / PROVABLY | **held (documented)**: `LlvmHold.lean` host hold gate (`llvmHoldReady` / `sh6HoldReady` = true; `llvmUnlocked` / `provablyUnlocked` / `freestandingProductSelfHostComplete` = false; `selfApplyDoesNotUnlockLlvm`); greppable HOST-LLVM-HOLD / HOST-PROVABLY-HOLD / LLVM-HOLD-SMOKE -- **not** unlocked; not residual-open llvm mill; real freestanding product self-host + real `ccomp` for PROVABLY still required |
| **Inventory close** | Host inventory close readiness | **done (partial)**: `InventoryClose.lean` HOST-INVENTORY-CLOSE / SELF-HOST-INVENTORY-CLOSE / `SLAKE_SELF_HOST_INVENTORY_CLOSE_V0` (`inventoryCloseReady` = freestandingSelfApplyReady && llvmHoldReady && surface && partialCarry && !complete && !llvmUnlocked && !provablyUnlocked; `residualFreeClaimed` = false; `inventoryCloseDoesNotMeanResidualFree`; INVENTORY-CLOSE-SMOKE) -- Mult..LlvmHold ladder + CLOSABLE-MISS-COUNT-0 compose; **not** residual free; **not** freestanding product self-host complete; intentional PARTIAL carry remains |
| **Product path** | Freestanding product path readiness | **done (partial)**: `ProductPath.lean` HOST-PRODUCT-PATH / SELF-HOST-PRODUCT-PATH / `SLAKE_SELF_HOST_PRODUCT_PATH_V0` (`productPathReady` = inventoryCloseReady && freestandingUnitProductPathReady && freestandingProgramProductPathReady && surface && !residual free claimed && !product complete claimed && !SelfApplyFs complete && !llvm unlock && !provably unlock; `freestandingUnitProductPathReady` unitCompileReady / extractOkFs on empty/unminted/lowerEmitCompose; sibling `freestandingProgramProductPathReady` empty program fail-closed + lowered kernel well-typed; `productPathDoesNotComplete` / `productPathDoesNotMeanResidualFree`; PRODUCT-PATH-SMOKE) -- **not** residual free; **not** freestanding product self-host complete; intentional PARTIAL carry remains |

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
PRODUCT-PATH-SMOKE / HOST-PRODUCT-PATH-SMOKE) and product
Mult / Linear / Emit behavioral checks in `smoke/slake_behavioral_probe.c`.

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
  readiness landed (`ProductPath` productPathReady; residualFreeClaimed false;
  not freestanding product self-host complete); remaining freestanding product
  residual is further honest freestanding product path deepen without forging
  complete / residual free -- not bash EMIT_* theater and not an llvm unlock mill
- Host elaborator residual (classic Lean managed runtime on Lake) stays separate
  from product wire residual
- Do not forge either residual
