# Residual -- Systems / Slake (`src/systems/`)

Owned by the Systems / Slake implement fork (`doc/fork-systems.md`).
Coordinator reads this file; does not drive the freestanding treadmill by default.

**Status vocabulary:** `open` | `in progress` | `done` | `blocked` | `deferred` | `wontfix`

**Honesty:** green gates are not residual free. Product freestanding residual
and host elaborator residual both remain. Do not claim residual free, product
self-host complete, proof complete, or llvm unlock without evidence bars in
`doc/goals.md`.

**Language:** Systems / Slake, Idris side, Lean side, coordinator. Do not say
"pole." Living residual uses **plain Names** (schema below), not phase / track /
wave / SH* / P* item titles.

**Focus:** bootstrap freestanding **Slake** -- Lean host under `src/systems/`
that owns freestanding synthesis toward `out/freestanding-c`.

**Autonomy:** when Open has a Name with checkable Done when, agents chain short
implement loops via `WATCHER.md` without waiting. When Done when is not
checkable, set BLOCKED with one need. Do not invent work.

**Evidence map (greppable gate tokens):** stay in product Lean and pure Nix
presence. Optional inventory companions under `src/systems/` (e.g.
`host-partial-inventory.md`, module headers). Do not re-paste token soup into
this living residual.

Plan: `.agents/plans/plan-unambiguous-residual-work.md`

---

## Work item schema (living residual)

Every **open** or **in progress** item:

| Field | Rule |
|-------|------|
| **Name** | 2-6 words; what you are building. Not a stage id. |
| **Goal** | One sentence. |
| **Done when** | Checkable outcomes (paths, gates, behaviors). Theorems only when they prove a **new** property. |
| **Out of scope** | Explicit non-claims for the slice. |
| **Primary paths** | 1-5 paths. |
| **Status** | open / in progress / done / blocked / deferred / wontfix |

**Banned as residual item names or living status voice:** wave, phase, track,
lane, stream, epoch; SH0..SH6 or P0..P7 as titles; stacking greppable tokens as
the work description; "human-directed product residual" without a Name.

---

## Open (living queue -- drives implement)

| Name | Goal (one line) | Status |
|------|-----------------|--------|
| *(empty)* | No open Systems residual Names. Deferred tracks stay deferred. | **done-for-now** |

Open queue empty after **Thin process glue**. Do not invent Open Names. Residual
free still false; freestanding product self-host complete still false; proof
complete false; PROVABLY false; llvm / CompCert still deferred.

---

## Deferred (held with reason)

| Name | Why held | Unlocks when |
|------|----------|--------------|
| LLVM IR emit | Not before freestanding self-host is real | True freestanding self-host acceptance met |
| CompCert product seal | Needs real resolved CompCert + matrix | Real `ccomp` available and product matrix defined |
| Host readiness canaries only | Exhausted as residual under current surface | New product surface needs a new property proof |
| Definitional alias theorem growth | Not product progress | Never as residual (wontfix as residual) |

---

## Done (archive -- capabilities, not token dumps)

Short capability list. Greppable stage ids live in Lean / Nix / companions.

| Capability | Paths (primary) |
|------------|-----------------|
| Systems layout + README product bar | `src/systems/README.md`, stubs |
| Pure Nix host presence + emit-wire gates | `nix/systems-host-presence/`, `nix/systems-emit-wire/` |
| Structure compile path (not product C) | `script/slake-compile-path.sh` |
| Lean freestanding emit writer + `out/freestanding-c` | `SystemsLean/FreestandingEmit.lean`, `emit/`, `out/freestanding-c/` |
| Unit surface + deepen + fail-closed product APIs | emit product + unit maps |
| Ordered IR program, graph edges, host compose (product + host) | emit C + `IrProgram` / `IrGraph` / `HostCompose` |
| Emit plan / apply / body product wire (frozen bulk) | emit product; host `EmitPlan` / `EmitApply` / `EmitBody` |
| Host Mult + body single sources of truth embedded in emit | `EmitMult`, `EmitBody`, `host_emit_*.ssot.txt` |
| Host Linear + ConsumeToken product text host-owned emit | `EmitLinear`, `host_emit_linear.ssot.txt`, `host-owned-emit.md` |
| Product wire matches host compose (PARTIAL inventory honesty) | `host-partial-inventory.md` scannable carry; closed gap **HOST-EMIT-LINEAR** Linear product C text ownership (not template-only); HostCompose mint/consume / plan/apply/body stay consistent without full C parity claim |
| Host Mult..SpecProof modules + honesty canaries | `SystemsLean/*.lean` Mult through SpecProof / LlvmHold |
| Algebraic / fail-closed / path / content theorems (partial) | same host modules; not proof complete |
| Dual maps + join algorithms (sides) | `src/idris2/`, `src/lean4/` (read for systems) |
| Shared IR sketch | `doc/shared-ir-sketch.md` |
| Self-host body (defined freestanding compile step) | plain-English acceptance in `self-host.md` (SELF-HOST-BODY); host pin `SystemsLean/SelfHostBody.lean` (selfHostBodyReady = emitMultReady && emitLinearReady + freestanding emit stage cite; freestandingProductSelfHostComplete false; residual free false); E2E under `just systems-host` / `systems-emit-wire` / `out-freestanding-c` / check.sh |
| Dual algorithms into Slake (stated map + host use) | `join-map.md` stated map; `SystemsLean/JoinMap.lean` joinAlgUseOk (ConsumeToken = HostCompose mint/consume via consumeTokenHostUseOk / hostMintConsumeOnceOk -- not Linear Token axioms; ErasedIndex = erasedIndexHostUseOk; UnrestrictedShare = unrestrictedShareHostUseOk Mult multOmega + shareNat) + joinDualCiteOk inventory; dual trees read-only; residual free false; product self-host complete false |
| Thin process glue | Shell ownership note in `src/systems/README.md` (role table + line counts); `script/slake-compile-path.sh` stamp only (~50 lines, no static greps); unit walk / honesty stay pure Nix (`systems-emit-wire` / `systems-host`); dual `check.sh` optional elaborators only; residual free false; product self-host complete false |

Still **not residual free**. Still **not** freestanding product self-host complete.
Still **not** proof complete. Still **not** PROVABLY. llvm still deferred.

---

## Next residual implement prompt (Systems / Slake)

```
DONE-FOR-NOW (Open queue empty)

Thin process glue is done: remaining novel shell is process glue only
(Lake / cc / drivers / compile-path stamp). Static presence is pure Nix.
Ownership note: src/systems/README.md (Shell ownership table).

Still false / deferred (do not forge):
- residual free
- freestanding product self-host complete
- proof complete
- PROVABLY
- llvm IR emit / CompCert product seal

Do not invent Open Names. Human names next residual when ready.
```
