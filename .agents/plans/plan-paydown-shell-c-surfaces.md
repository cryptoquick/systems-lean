# Plan: Pay down shell / C surfaces (stop labeling, start removing)

ASCII only. Plan skill artifact. **Approved.** Implement waves 0-E in order. Durable docs + subagent slices.
Do not forge residual free / PROVABLY / llvm unlock. Hands-off agent git.

Workspace copy:
`.agents/plans/plan-paydown-shell-c-surfaces.md`

---

## Context

### Why

Soft-concerns plan **documented** non-product surfaces (Shell, C, smoke, SSOT
text) as "debt" and froze growth. That was correct inventory -- and wrong end
state for this machine-intelligence era. Accumulating labeled debt is not a
strategy when ports to Lean 4 / pure Nix are achievable.

User direction:

- Stop treating large shell/C as permanent "debt we live with."
- Prefer **elimination or honest permanent roles** over freeze banners.
- Generated freestanding C belongs in a **consumer release tree** (subtree /
  tarball), not as if it were Systems Lean source in the monorepo story.
- Constraints still hold: three languages only (Idris 2 / Lean 4 / pure Nix);
  no bash-in-Nix; no product GC; dual residual honesty; hands-off agent git;
  no residual-free / PROVABLY forge.

### Current inventory (approximate novel lines, post soft plan)

| Surface | ~Code lines | Honest role today | Paydown target |
|---------|-------------|-------------------|----------------|
| `script/slake-emit-freestanding-c.sh` | ~2070 | Frozen NON-SSOT C generator | **Delete** after Lean-owned full emit writer |
| `src/systems/smoke/slake_behavioral_probe.c` | ~1615 | Hosted behavioral tests of product C | Keep as **tests** (rename language), thin if possible; never product body |
| `src/systems/emit/*.{c,h}` + `out/freestanding-c/*` | ~1650+ | **Generated product wire** | Keep generated; **stop treating as monorepo implementation**; publish via subtree; consider untracking dogfood from main history later |
| `src/systems/check.sh` | ~228 | Process: optional Lake, driver runs, `cc` smoke | **Thin to just recipes** or pure orchestration; no static mills (already Nix) |
| `script/slake-compile-path.sh` | ~149 | Structure compile-path driver | Port or absorb into thin just + Lean/Nix |
| `src/lean4/check.sh` | ~125 | Dual presence + optional Lake | **Pure Nix** presence (mirror systems-host pattern) |
| `script/build-systems.sh` | ~101 | Multi-tier build orchestrator | Collapse into just + smaller drivers |
| `src/idris2/check.sh` | ~90 | Dual presence + optional idris2 | **Pure Nix** presence |
| `script/out-freestanding-c.sh` | ~63 | Emit + copy to out/ | Thin just + one generator call |
| git-hooks BASH | ~4 | Call just | Keep thin (not a problem) |
| Lake `.lake/build/ir/*.c` | large if unscanned | Classic AOT IR | **Never track**; exclude from scc |

Already paid earlier (do not re-do):

- Static host presence, jargon walk, emit-wire greps, unit walk -> pure Nix
- Probe extracted from fat check.sh
- Progress / hygiene / professional-tone pure Nix
- Soft-plan docs (HITL, inventory, freeze headers) -- **policy**, not paydown

### Constraints

- Novel work only: Idris 2, Lean 4, pure Nix. Port **to** those; do not invent Python or bash-in-Nix.
- Emit product wire remains freestanding C **output** -- C is not a fourth source language.
- No new `EMIT_*` residual treadmill stages as fake progress.
- No forge residual free / freestanding product self-host complete / PROVABLY / llvm unlock.
- Isolation: work only in this repo unless human is desperate.
- Hands-off agent git (HITL stage for new nix/).
- Residual process shell that **must** invoke `lake` / `cc` can stay **tiny** as process glue -- that is orchestration, not "debt theater." Goal is **lines and ownership**, not zero process.

### Non-goals

- Full freestanding self-host complete in this plan alone (still the north star; emit paydown **feeds** it).
- CompCert PROVABLY / `out/llvm-ir` unlock.
- Bulk HOST-* rename mill.
- Pushing WIP or agent git add.
- Deleting product wire C without a working Lean generator replacement.
- Claiming shell debt gone while emit shell still exists.

### Assumptions (defaults -- freeform revise if wrong)

1. **Priority order:** eliminate largest removable shell first (emit generator), then dual check.sh -> Nix, then collapse small drivers, then release-layout for generated C.
2. **Smoke C stays as C tests** linked against product wire until/unless Lean can drive equivalent live `cc` contracts another way. Rename in docs: **tests**, not "smoke debt forever."
3. **Generated C:** short term keep dogfood under `emit/` + `out/freestanding-c/` for gates; medium term subtree publish is the consumer tree; optional later: stop tracking `*.c`/`*.h` in monorepo (CI artifact only).
4. **Lean emit writer:** use Lake executable or `lake env lean` IO to write `slake_freestanding.{c,h}` from host SSOT + structured fragments already in EmitMult / EmitBody -- not a second bash dialect.
5. **scc targets (novel, exclude ref/.lake/.cache):** Shell code under ~400 after wave 1-3; under ~100 after wave 4; C code = product wire + tests only, with clear labels.

---

## Approach

**Reclassify -> replace -> delete -> measure.**

1. **Language shift in policy:** drop casual "debt" for permanent roles (product wire, tests, thin orchestration). Reserve "debt" only for **scheduled deletion** items with an owner and exit criterion.
2. **Wave A -- dual presence pure Nix (fast):** replace `src/idris2/check.sh` and `src/lean4/check.sh` static file/token presence with pure Nix modules; optional elaborator stays a thin just recipe.
3. **Wave B -- process collapse (medium):** fold `build-systems.sh`, `out-freestanding-c.sh`, parts of `systems/check.sh` into short just recipes + one remaining driver call each; delete empty shells.
4. **Wave C -- Lean owns full freestanding emit (hard, high value):** implement Lean-side writer that produces byte-stable (or contract-stable) `slake_freestanding.{c,h}` from existing SSOT + host modules; bash emit becomes thin wrapper then **deleted**. This is the ~2k line kill.
5. **Wave D -- release layout:** document and wire subtree/tarball publish; optionally untrack monorepo dogfood C after CI green path exists; scc exclude recipe pinned.
6. **Wave E -- smoke honesty:** keep probe as tests; do not grow; split or generate only if it reduces maintenance without losing red/green product contracts.

Material alternatives rejected:

- **Not** "rewrite emit shell in bash-in-Nix" -- forbidden.
- **Not** "delete emit C now and hope" -- breaks dogfood and smoke.
- **Not** more freeze banners without delete dates -- that is how debt accumulated.
- **Not** ProductPath / readiness theater as substitute for deleting shell.
- **Not** growing probe C as residual progress.

---

## Critical files

| Path | Why |
|------|-----|
| `script/slake-emit-freestanding-c.sh` | ~2k line kill target |
| `src/systems/SystemsLean/EmitBody.lean` / `EmitMult.lean` / KernelEmit | Lean emit ownership |
| `src/systems/emit/host_emit_*.ssot.txt` | SSOT fragments |
| `src/systems/emit/slake_freestanding.{c,h}` | Generated wire dogfood |
| `src/systems/smoke/slake_behavioral_probe.c` | Product contract tests |
| `src/systems/check.sh` | Process residual |
| `src/idris2/check.sh` / `src/lean4/check.sh` | Dual presence -> Nix |
| `script/build-systems.sh` / `slake-compile-path.sh` / `out-freestanding-c.sh` | Small drivers |
| `nix/systems-host-presence/` / `nix/systems-emit-wire/` | Patterns to mirror for duals |
| `justfile` / `flake.nix` | Wire recipes and checks |
| `AGENTS.md` / `doc/vocabulary.md` / `RESIDUAL-systems.md` | Policy: scheduled deletion vs permanent roles; stop debt-speak abuse |
| `out/freestanding-c/README.md` | Subtree consumer release |
| `.gitignore` | Optional untrack generated C later |

---

## Reuse

| Existing | How |
|----------|-----|
| pure Nix presence walks | Template for idris/lean dual presence |
| HOST-EMIT-SSOT / HOST-EMIT-MULT | Already Lean-owned fragments; extend to full file emit |
| `just systems-host` / `systems-emit-wire` | Gate pattern for new pure checks |
| `just out-freestanding-c` | Becomes "run Lean emit + install" |
| professional-tone / source-hygiene | Module size / purity norms |
| ProbeWire honesty | Keep probe vs wire distinct while renaming "debt" |

---

## Steps

Ordered; implement only after chat **Approve**. Prefer sequential `/implement` per wave (effort 1 default; raise for Wave C).

### 0. Policy reframe (same turn as first code wave or alone)

1. In `AGENTS.md` residual inventory: replace undifferentiated "debt" with:
   - **Scheduled deletion** (emit shell, dual check.sh static mills, fat drivers)
   - **Permanent roles** (generated product wire, behavioral tests, thin just orchestration)
2. Vocabulary: **product wire**, **behavioral tests**, **process glue** -- not all "debt."
3. Pin scc exclude dirs for honesty meters.
4. Acceptance: greppable scheduled-deletion list with exit criteria; no claim shell gone early.

### 1. Wave A -- dual check.sh -> pure Nix

1. Add `nix/idris-side-presence/` and `nix/lean-side-presence/` (or one `nix/dual-presence/` with two roots) mirroring systems-host style: required paths + greppable tokens; skip ref/.lake/.cache.
2. Wire `just idris-side` / `just lean-side` (names thoughtful) + flake checks + fold into `just check` before or instead of bash presence.
3. Thin `src/idris2/check.sh` / `src/lean4/check.sh` to optional elaborator only, or delete if just recipes call lake/idris2 directly.
4. Acceptance: `just check` green without depending on bash file lists; shell lines drop ~200.

### 2. Wave B -- collapse small scripts

1. Inline or replace `build-systems.sh` / `out-freestanding-c.sh` with short just recipes calling remaining drivers.
2. Reduce `systems/check.sh` to: invoke pure gates already run by just check; optional lake; compile/emit drivers; cc probe -- target **under ~80 lines** or pure just steps.
3. `slake-compile-path.sh`: keep only if still required for stage manifest; otherwise Lean/Nix owns readiness and shell only writes a tiny stamp.
4. Acceptance: fewer than N shell files under script/ (target: emit + at most one compile helper until Wave C deletes emit).

### 3. Wave C -- Lean-owned freestanding emit (main kill)

1. Spec: Lean program writes complete `slake_freestanding.h` + `.c` such that:
   - existing smoke probe still green against new emit
   - systems-emit-wire tokens still present
   - HOST-EMIT-SSOT / HOST-EMIT-MULT still authoritative (no second dialect)
2. Implementation sketch (adjust after spike):
   - Lake exe or `lean --run` module under `src/systems/` that concatenates structured sections (Mult already fragments; expand section emitters for Linear/Types/Program/Emit already on the frozen wire)
   - Golden or contract tests: probe + pure presence, not byte-diff fetish unless stable
3. `just out-freestanding-c` / emit path calls Lean writer; bash emit becomes wrapper then **deleted**.
4. Update residual / AGENTS: emit shell **gone**, not frozen.
5. Acceptance: `wc -l script/slake-emit-freestanding-c.sh` fails (file absent); `just out-freestanding-c` + probe green; no new EMIT_* stage theater.

**Risk:** largest wave; may need 2-4 implement slices (header-only writer, body sections, cutover, delete bash).

### 4. Wave D -- generated C release layout

1. Harden subtree/tarball docs and a just recipe for "export release dir."
2. Optional: monorepo stops tracking `emit/*.c` and `out/freestanding-c/*.{c,h}` -- CI generates and uploads / subtree pushes. **Human decision** at implement time if gates need tracked dogfood.
3. scc progress recipe excludes .lake; documents product wire as generated.
4. Acceptance: consumer story is subtree-first; monorepo scc C either tests-only or clearly generated paths.

### 5. Wave E -- behavioral tests (probe)

1. Keep product-linked C tests until redundant.
2. Prefer not growing; if Lean host theorems cover a slice, drop only **duplicate** probe asserts with evidence.
3. Rename docs: behavioral tests, not endless smoke debt.
4. Acceptance: probe not larger than today without explicit need; scc labels honest.

### 6. Verification

```bash
# Novel scc (exclude ref, .lake, .cache)
scc . --exclude-dir .git --exclude-dir ref --exclude-dir .lake --exclude-dir .cache

just hygiene
just systems-host
just systems-emit-wire
just idris-side   # when Wave A lands
just lean-side
./src/systems/check.sh   # or successor
just out-freestanding-c
just check   # after human stages new nix/
```

Targets after full plan (approximate):

| Metric | Before (rough) | After Wave C+ |
|--------|----------------|---------------|
| Shell code lines (novel) | ~2500 | under ~100 process glue |
| Emit bash | ~2070 | **0** |
| Dual check.sh static | ~200 | **0** (Nix) |
| C code | wire + tests + (no .lake) | wire (generated) + tests only |

---

## Risks

| Risk | Mitigation |
|------|------------|
| Lean emit byte-drift breaks probe | Contract tests first; cutover behind just recipe; keep bash until green |
| Wave C scope explosion | Slice by section; no new product APIs while porting |
| Untracking C breaks local dogfood | Optional Wave D; default keep tracked until CI path solid |
| Agents stage git for flake | HITL; just impure gates live |
| Calling everything done while shell remains | scc + file-absent gates; residual honesty |

---

## Verification (definition of done for this plan)

1. Emit bash **absent**; Lean path is sole freestanding C generator for dogfood.
2. Dual presence is pure Nix; dual check.sh deleted or elaborator-only thin.
3. AGENTS scheduled-deletion list empty for shells that were targeted.
4. scc novel Shell under agreed cap; C explained as generated + tests.
5. Green: hygiene, systems-host, systems-emit-wire, out-freestanding-c, probe, just check (HITL flake stage as needed).
6. No residual-free / PROVABLY / llvm unlock claims.

---

## Open questions (defaults above if silent)

1. Wave D untrack monorepo C now, or after Lean emit only? **Default: after Lean emit solid; untrack optional.**
2. Dual presence: two nix modules vs one dual-presence package? **Default: two small modules (idris-side, lean-side) for LLM attention.**
3. Wave C: full byte-stable port of current C vs contract-stable regenerate? **Default: contract-stable (probe + tokens); chase byte-stable only if cheap.**

---

## Implementation todos (after Approve)

| Id | Content |
|----|---------|
| `impl:policy-reframe` | AGENTS/vocabulary scheduled deletion vs permanent roles; scc exclude |
| `impl:wave-a-dual-nix` | idris/lean pure Nix presence; thin/delete dual check.sh |
| `impl:wave-b-collapse` | Collapse build/out/check process shells |
| `impl:wave-c-lean-emit` | Lean freestanding emit writer; delete bash emit |
| `impl:wave-d-release` | Subtree/export; optional untrack dogfood C |
| `impl:wave-e-tests` | Probe as tests honesty; no growth |
| `impl:verify` | scc + full gates; residual honesty |

---

## Present summary

**Path:** Pay down real shell/C bulk -- especially **delete the 2k-line emit shell** via Lean-owned emit -- and stop calling permanent product wire / tests "debt."

**Not:** more freeze documentation without deletion, bash-in-Nix, or self-host theater instead of removing files.

### Critical Files for Implementation
- `script/slake-emit-freestanding-c.sh` -- main kill
- `src/systems/SystemsLean/Emit*.lean` -- Lean emit ownership
- `nix/systems-host-presence/` -- dual presence pattern
- `src/*/check.sh` -- thin or delete
- `AGENTS.md` -- scheduled deletion vs permanent roles
- `justfile` / `flake.nix` -- wire
