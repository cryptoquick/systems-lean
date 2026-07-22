# Coordinator guidance -- Systems / Slake

**Systems fork: re-read this file at the start of every implement loop.**
**Residual board:** `RESIDUAL-systems.md` only.

## Latest directive (coordinator updates this section)

- C emit ladder bulk frozen at **EMIT_BODY_V0** (product wire -- emitted freestanding C under emit/ and out/freestanding-c). Do not grow bash `EMIT_*` stage theater. Host-owned Mult text (SH2 HOST-EMIT-MULT) + Mult closed-loop parity (SH3 HOST-PARITY-MULT) + Linear kernel start (SH4 HOST-KERNEL-LINEAR) + Mult+Linear freestanding Linear path (HOST-PARITY-LINEAR) + Types kernel growth (SH4 HOST-KERNEL-TYPES) + Mult+Linear+Types freestanding Types path (HOST-PARITY-TYPES) + Program kernel growth (SH4 HOST-KERNEL-PROGRAM) + Mult+Linear+Types+Program freestanding Program path (HOST-PARITY-PROGRAM) + Emit kernel (SH4 HOST-KERNEL-EMIT) + Mult+Linear+Types+Program+Emit freestanding Emit path (HOST-PARITY-EMIT) + self-apply Mult+Linear+Types+Program+Emit (SH5 HOST-SELF-APPLY partial) + freestanding self-apply deepen with Mult..Emit parity compose (SH5 HOST-SELF-APPLY-FS freestandingParityLadderReady) + llvm hold (SH6 HOST-LLVM-HOLD documented) + host inventory close (HOST-INVENTORY-CLOSE) + freestanding product path (HOST-PRODUCT-PATH) landed. **Next residual: further honest freestanding product path deepen** without forging complete / residual free (not llvm unlock; not bash EMIT_* theater).
- **SYSTEMS_LEAN_HOST partial:** Lake + Mult..ProductPath (**31 modules**; PARTIAL vs full product C; not residual free; SH6 hold not unlock; inventory close not residual free; product path not residual free).
- **P1 inventory:** `host-partial-inventory.md` (**CLOSABLE-MISS-COUNT-0**). Intentional PARTIAL only. HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH readiness gated.
- **P2..P5 / P7 done** (HOST-EMIT-SSOT, HOST-COMPILE-PATH, HOST-JOIN-MAP, HOST-SELF-HOST, HOST-SURFACE-MATRIX).
- **SH0 + SH1 + SH2 + SH3 + SH3b HOST-PARITY-LINEAR + SH3c HOST-PARITY-TYPES + SH3d HOST-PARITY-PROGRAM + SH3e HOST-PARITY-EMIT + SH4 Linear/Types/Program/Emit + SH5 partial + SH5 freestanding deepen (parity ladder compose) + SH6 hold documented + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH:** `self-host.md`; `KernelMult.lean` Mult IR; `EmitMult.lean` HOST-EMIT-MULT + `host_emit_mult.ssot.txt`; `ParityMult.lean` HOST-PARITY-MULT + probe Mult contracts; `KernelLinear.lean` HOST-KERNEL-LINEAR + KERNEL-LINEAR-SMOKE; `ParityLinear.lean` HOST-PARITY-LINEAR + PARITY-LINEAR-SMOKE; `KernelTypes.lean` HOST-KERNEL-TYPES + KERNEL-TYPES-SMOKE; `ParityTypes.lean` HOST-PARITY-TYPES + PARITY-TYPES-SMOKE; `KernelProgram.lean` HOST-KERNEL-PROGRAM + KERNEL-PROGRAM-SMOKE; `ParityProgram.lean` HOST-PARITY-PROGRAM + PARITY-PROGRAM-SMOKE; `KernelEmit.lean` HOST-KERNEL-EMIT + KERNEL-EMIT-SMOKE; `ParityEmit.lean` HOST-PARITY-EMIT + PARITY-EMIT-SMOKE; `SelfApply.lean` HOST-SELF-APPLY + SELF-APPLY-SMOKE; `SelfApplyFs.lean` HOST-SELF-APPLY-FS + freestandingParityLadderReady + SELF-APPLY-FS-SMOKE; `LlvmHold.lean` HOST-LLVM-HOLD + LLVM-HOLD-SMOKE (unlock flags false); `InventoryClose.lean` HOST-INVENTORY-CLOSE + INVENTORY-CLOSE-SMOKE (residualFreeClaimed false); `ProductPath.lean` HOST-PRODUCT-PATH + PRODUCT-PATH-SMOKE (productPathReady; residualFreeClaimed false). **Highest value now: further honest freestanding product path deepen** without forging complete. P6 llvm / PROVABLY still held (gate module documents hold; not residual-open mill).
- Jargon: unpack **product wire** and **host model** (not AI model) -- `doc/vocabulary.md`, `AGENTS.md`.
- Stay in `src/systems/` (+ `RESIDUAL-systems.md`). Duals read-only.
- Language: Systems / Slake, Idris side, Lean side -- do not say "pole."
- Validate: `just systems-host`, `just systems-emit-wire`, `just hygiene`, `./src/systems/check.sh`, `just check`.
- Hard non-claims: no freestanding residual free without evidence; no freestanding product self-host complete from SH5 partial alone; no PROVABLY; no `out/llvm-ir` before true freestanding product self-host; no product GC.

## Status snapshot

- Coordinator monitors meters (`just progress` / `just watch`) and this guidance.
- Open: further honest freestanding product path deepen without forging complete (next); Mult..Emit freestanding parity ladder + SelfApplyFs parity compose + SH4 host ladder + SH5 host/FS partial closed; SH6 hold documented; HOST-INVENTORY-CLOSE landed; HOST-PRODUCT-PATH landed; P6 holds (llvm / PROVABLY); residual free unclaimed.
- Parked dual forks: do not invent second dual unless human asks.

## Do not

- Invent freestanding or PROVABLY claims
- Start `out/llvm-ir`
- Touch git unless the human asks
- Race Idris-side or Lean-side residual treadmill
