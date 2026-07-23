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
| Thin process glue | Shell only for Lake / cc / drivers; static presence stays pure Nix | **open** (next) |

### Thin process glue

- **Goal:** Remaining shell is only what must invoke Lake / cc / drivers.
- **Done when:** ownership note updated (line counts or role list); no new
  static greps in shell; gates green.
- **Out of scope:** deleting behavioral tests without replacement.
- **Primary paths:** `src/systems/check.sh`, `script/slake-compile-path.sh`,
  pure Nix presence modules.
- **Status:** open (next implement)

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

Still **not residual free**. Still **not** freestanding product self-host complete.
Still **not** proof complete. Still **not** PROVABLY. llvm still deferred.

---

## Next residual implement prompt (Systems / Slake)

```
/implement --effort 1 Thin process glue:
Goal: Remaining shell is only what must invoke Lake / cc / drivers;
static presence stays pure Nix.
Done when:
- ownership note updated (line counts or role list for remaining shell)
- no new static greps in shell; gates green
- residual free still false; product self-host complete still false
Out of scope: deleting behavioral tests without replacement;
racing dual residual; full formal bridge; llvm unlock; PROVABLY;
residual free claim; grow probe C; git
Paths: src/systems/check.sh, script/slake-compile-path.sh,
pure Nix presence modules under nix/, RESIDUAL-systems.md,
RESIDUAL.md, WATCHER.md
Gates: just systems-host; just systems-emit-wire; just hygiene;
just idris-side; just lean-side; ./src/systems/check.sh
Autonomy: after this slice, write the next Open Name implement prompt into
WATCHER (or BLOCKED with one need). Chain freestanding Slake bootstrap only.
When Open queue is empty after this item, set WATCHER to a short blocked /
done-for-now note without inventing work.
```
