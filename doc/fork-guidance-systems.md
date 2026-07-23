# Coordinator guidance -- Systems / Slake

**Systems fork: re-read this file at the start of every implement loop.**
**Residual board:** `RESIDUAL-systems.md` only.

## Latest directive (coordinator updates this section)

- C emit ladder bulk frozen at **EMIT_BODY_V0** (product wire -- emitted freestanding C under emit/ and out/freestanding-c). Do not grow bash `EMIT_*` stage theater. Host-owned Mult text (SH2 HOST-EMIT-MULT) + Mult closed-loop parity (SH3 HOST-PARITY-MULT) + Linear kernel start (SH4 HOST-KERNEL-LINEAR) + Mult+Linear freestanding Linear path (HOST-PARITY-LINEAR) + Types kernel growth (SH4 HOST-KERNEL-TYPES) + Mult+Linear+Types freestanding Types path (HOST-PARITY-TYPES) + Program kernel growth (SH4 HOST-KERNEL-PROGRAM) + Mult+Linear+Types+Program freestanding Program path (HOST-PARITY-PROGRAM) + Emit kernel (SH4 HOST-KERNEL-EMIT) + Mult+Linear+Types+Program+Emit freestanding Emit path (HOST-PARITY-EMIT) + self-apply Mult+Linear+Types+Program+Emit (SH5 HOST-SELF-APPLY partial) + freestanding self-apply deepen with Mult..Emit parity compose (SH5 HOST-SELF-APPLY-FS freestandingParityLadderReady) + llvm hold (SH6 HOST-LLVM-HOLD documented) + host inventory close (HOST-INVENTORY-CLOSE) + freestanding product path self-host-program+matrix deepen (HOST-PRODUCT-PATH) + structural product path ladder close (HOST-PRODUCT-PATH-CLOSE productPathCloseReady / productPathLadderClosedOk; productPathFurtherAliasTheaterHeld) + dual residual honesty (HOST-DUAL-RESIDUAL dualResidualReady; hostElaboratorResidualRemains; productResidualRemains) + probe-vs-wire honesty (HOST-PROBE-WIRE probeWireReady; behavioralProbeIsSmokeDebt; product freestanding wire distinct) + formal spec-proof separation (HOST-SPEC-PROOF specProofReady; specSurfaceStated; proofCompleteClaimed false; proofDoesNotRetireTests) + Mult MULT-THEOREM / HOST-MULT-THEOREM + Types TYPES-THEOREM / HOST-TYPES-THEOREM + IrProgram IR-PROGRAM-THEOREM / HOST-IR-PROGRAM-THEOREM landed. **Next residual: real host theorems on Linear JOIN-ALG / kindMultOk mismatch / CompilePath empty-host-vs-empty-program / IrGraph EMPTY-GRAPH-OK** (as cheap; proofCompleteClaimed stays false) without forging complete / residual free / proof complete (not ProductPath alias theater; not llvm unlock; not bash EMIT_* theater; not probe-body growth).
- **SYSTEMS_LEAN_HOST partial:** Lake + Mult..SpecProof (**34 modules**; PARTIAL vs full product C; not residual free; SH6 hold not unlock; inventory close not residual free; product path not residual free; structural ladder closed not residual free; dual residual honesty not residual free either side; probe-vs-wire honesty not residual free; formal spec-proof separation not residual free and not proof complete). Mult + Types + IrProgram FAIL-CLOSED theorems partial only -- proofCompleteClaimed stays false.
- **P1 inventory:** `host-partial-inventory.md` (**CLOSABLE-MISS-COUNT-0**). Intentional PARTIAL only. HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH + HOST-PRODUCT-PATH-CLOSE + HOST-DUAL-RESIDUAL + HOST-PROBE-WIRE + HOST-SPEC-PROOF readiness gated.
- **P2..P5 / P7 done** (HOST-EMIT-SSOT, HOST-COMPILE-PATH, HOST-JOIN-MAP, HOST-SELF-HOST, HOST-SURFACE-MATRIX).
- **SH0 + SH1 + SH2 + SH3 + SH3b HOST-PARITY-LINEAR + SH3c HOST-PARITY-TYPES + SH3d HOST-PARITY-PROGRAM + SH3e HOST-PARITY-EMIT + SH4 Linear/Types/Program/Emit + SH5 partial + SH5 freestanding deepen (parity ladder compose) + SH6 hold documented + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH self-host-program+matrix deepen + HOST-PRODUCT-PATH-CLOSE structural ladder close + HOST-DUAL-RESIDUAL dual residual honesty + HOST-PROBE-WIRE probe-vs-wire honesty + HOST-SPEC-PROOF formal spec-proof separation + Mult MULT-THEOREM + Types TYPES-THEOREM + IrProgram IR-PROGRAM-THEOREM:** `self-host.md`; modules through `SpecProof.lean` HOST-SPEC-PROOF + SPEC-PROOF-SMOKE (specProofReady; readable specs stated; proofCompleteClaimed false; residualFreeClaimed false). **Highest value now: real Linear / kindMultOk mismatch / CompilePath empty-host-vs-empty-program / IrGraph host theorems** without forging proof complete. Further ProductPath inventoryCloseReady-implied alias theater held. P6 llvm / PROVABLY still held (gate module documents hold; not residual-open mill).
- Jargon: unpack **product wire** and **host model** (not AI model) -- `doc/vocabulary.md`, `AGENTS.md`.
- Stay in `src/systems/` (+ `RESIDUAL-systems.md`). Duals read-only.
- Language: Systems / Slake, Idris side, Lean side -- do not say "pole."
- Validate: `just systems-host`, `just systems-emit-wire`, `just hygiene`, `./src/systems/check.sh`, `just check`.
- Hard non-claims: no freestanding residual free without evidence; no freestanding product self-host complete from SH5 partial alone; no proof complete from HOST-SPEC-PROOF alone; no PROVABLY; no `out/llvm-ir` before true freestanding product self-host; no product GC.

## Status snapshot

- Coordinator monitors meters (`just progress` / `just watch`) and this guidance.
- Open: real Linear JOIN-ALG / kindMultOk mismatch / CompilePath empty-host-vs-empty-program / IrGraph EMPTY-GRAPH-OK host theorems without forging proof complete (next); Mult MULT-THEOREM + Types TYPES-THEOREM + IrProgram IR-PROGRAM-THEOREM held; Mult..Emit freestanding parity ladder + SelfApplyFs parity compose + SH4 host ladder + SH5 host/FS partial closed; SH6 hold documented; HOST-INVENTORY-CLOSE landed; HOST-PRODUCT-PATH self-host-program+matrix deepen landed; HOST-PRODUCT-PATH-CLOSE structural ladder close landed; HOST-DUAL-RESIDUAL dual residual honesty landed; HOST-PROBE-WIRE probe-vs-wire honesty landed; HOST-SPEC-PROOF formal spec-proof separation landed; P6 holds (llvm / PROVABLY); residual free unclaimed; proof complete unclaimed.
- Parked dual forks: do not invent second dual unless human asks.

## Do not

- Invent freestanding or PROVABLY claims
- Start `out/llvm-ir`
- Touch git unless the human asks
- Race Idris-side or Lean-side residual treadmill
