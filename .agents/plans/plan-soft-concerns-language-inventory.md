# Plan: Soft concerns, language inventory, professional tone

ASCII only. Plan skill artifact (understand -> explore -> draft -> present).
**No product implementation until the human clearly approves in chat**
(e.g. "approve", "execute", "go"). Host modal / accidental dismiss is not
approval. Do **not** use structured questionnaires (`ask_user_question` or
similar) for plan clarification -- freeform chat only; unresolved items use
documented defaults below.

Workspace copy (when implement starts, keep in sync if useful):
`.agents/plans/plan-soft-concerns-language-inventory.md`

## Context

### Why

After pure-Nix tooling landed and a local unpushed WIP commit, residual soft
concerns remain (process honesty, not Slake self-host substance). Separately,
`scc` still shows Shell / C / headers / config surfaces that need **named
justifications** and tighter policy so agents do not treat them as normal novel
work. Human also asked to always document HITL (human-in-the-loop) preferences
and to keep tone professional, including **profanity checks**. Plan workflow
must stay chat-native: full plan text in the reply, no quiz UIs.

### Soft concerns in scope (from prior soft review)

| Soft concern | Evidence | Desired direction |
|--------------|----------|-------------------|
| **Stage-id density** | ~2.8k greps for `SLAKE_` / `_V0` / `HOST-` / `EMIT_*` etc.; dense in residual, Lean host markers, Nix presence specs, emit shell | Reduce *human-facing* noise; keep greppable honesty tokens where gates need them; stop minting new plan-theater ids in product docs |
| **Large shell emit** | `script/slake-emit-freestanding-c.sh` ~2064 lines | Document as frozen debt; no growth; eventual Lean-owned emit replaces it |
| **Human git stage for flake** | `nix flake check` only sees tracked files; live `just systems-*` can be green while flake is not | Document as HITL only; agents never stage/commit; improve warn text consistency |
| **Stale progress-log** | `doc/progress-log.md` still carries old `progress.py` cycles and failed hygiene recipes | Rotate / rewrite header; keep append-only from current `just watch` only |

### Language inventory in scope (`scc` without `ref/` / `.lake` / `.cache`)

| scc label | Novel role (honest) | Grow? |
|-----------|---------------------|-------|
| **Markdown** | Docs, residual, plans | Yes (min useful) |
| **Lean** | Systems Lean / Slake + Lean duals | **Yes** (primary product) |
| **Nix** | Pure tooling under `nix/` | **Yes** (small modules) |
| **Idris** | Idris duals | Yes when map gaps |
| **Shell** (~2.5k code lines) | Migration debt: build/emit/check | **No** -- shrink only |
| **C** + **C Header** | Emit product wire + smoke probe | **No** as product source; generated wire only |
| **Plain Text** | Host emit SSOT fragments + scc snapshot | SSOT yes (Lean-owned text); snapshot is generated |
| **JSON** | Lake manifests (empty packages) | Host tool config only |
| **TOML** | Lake project files | Host tool config only |
| **BASH** | Thin git hook(s) calling `just` | Thin only |
| **YAML** | GitHub Actions CI == `just check` | Thin only |

### Constraints

- **Do not push** the local WIP commit.
- **No bulk find-and-replace** across the tree. Targeted `rg` to *find* sites;
  careful per-file edits.
- **Three languages only** stays hard (Idris 2 / Lean 4 / pure Nix).
- **No new C or shell** as residual progress (existing AGENTS ban).
- Freestanding / AOT C in git is **generated release surface** only; prefer
  **git subtree** (or tarball) publish of `out/freestanding-c/` -- never hand-
  written product C as the implementation home.
- Document all new HITL prefs in the same turn (`AGENTS.md` and/or vocabulary /
  handoff as appropriate).
- Professional tone; add **profanity** gate (pure Nix, not shell).
- Do not race Slake self-host residual with this hygiene/docs slice unless a
  step is purely documentary.
- Hands-off git unless human asks.
- **No questionnaires** for plan/residual clarification; freeform chat only.

### Non-goals

- Full port of emit shell to Lean in this plan (that is major product work).
- Claiming residual free / PROVABLY / freestanding product self-host complete.
- Deleting frozen emit C or smoke without a Lean replacement path.
- Auto-staging files for the human.
- Rewriting all stage ids in Lean modules in one bulk pass.
- Expanding CI beyond thin `just check` equivalence.

### Assumptions (resolved defaults -- no questionnaire)

1. **Profanity scope:** novel `*.md` under the repo (docs, residual, plans,
   AGENTS, READMEs) first. Not Lean comments or generated emit C in v1.
2. **Progress-log:** full clean restart -- header + "log restarted YYYY-MM-DD;
   prior cycles in git history." Append-only from that date via `just watch`.
3. **Tracked dogfood C:** keep current policy -- `out/freestanding-c/*`
   tracked as generated dogfood + README; **subtree (or tarball) is the
   publish mechanism** for consumers. Still never hand-written product C.
4. **Unpushed WIP:** human revises later; agents do not push or amend unless
   asked.
5. **Stage-id cleanup:** documentation and residual first; product Lean
   honesty tokens stay until a deliberate later honesty slice.
6. **Plan UX HITL (document in AGENTS on implement):** no structured
   questionnaires for plan or residual clarification; freeform chat only;
   plan text always in chat, not only a host modal.

---

## Approach

**Document-first inventory + surgical policy + small pure-Nix profanity gate +
progress-log hygiene.** One coherent docs/tooling slice, not a residual mill.

Recommended path:

1. **Single inventory SSoT** -- extend `AGENTS.md` (Three languages / residual
   shell inventory) and `doc/vocabulary.md` with a clear **language surface
   table**: every scc language, path examples, justification, grow/shrink rule,
   and freestanding C **subtree release** rule.
2. **Soft concerns** -- document stage-id density policy, frozen emit shell,
   HITL flake stage, progress-log lifecycle -- then apply careful fixes:
   - rewrite `doc/progress-log.md` header + drop stale mill references
   - tighten residual / handoff prose where stage-id soup hurts humans (keep
     one greppable map table; cut redundant SH* paragraphs where a link
     suffices)
   - ensure `justfile` flake WARN and SESSION-HANDOFF agree on HITL stage
3. **Profanity + professional tone** -- pure Nix check (prefer extend
   `source-hygiene` or a sibling under `nix/` with a word list module), walk
   novel markdown; wire into `just hygiene` / `just check` and flake checks.
4. **Emit / out C honesty** -- reinforce in `out/freestanding-c/README.md` and
   AGENTS: tracked C under emit/out is **generator output**; hand-written C
   under `smoke/` is **smoke debt** only; release via **git subtree** of
   `out/freestanding-c/`.
5. **Optional scc honesty** -- document recommended `scc` exclude dirs
   (`.lake`, `.cache`, `ref`); refresh stale `doc/PROGRESS-scc.txt`.

Material alternatives rejected:

- **Not bulk rename of all HOST- / SLAKE_ tokens** -- breaks greppable gates.
- **Not rewriting emit shell into bash-in-Nix** -- forbidden.
- **Not deleting emit C this slice** -- product wire still depends on it.
- **Not agent-owned git add for flake** -- hands-off git; HITL only.
- **Not a new Python profanity mill** -- pure Nix only.
- **Not questionnaires for open options** -- defaults locked above.

---

## Critical files

| Path | Why |
|------|-----|
| `AGENTS.md` | Three languages, shell inventory, HITL prefs (incl. no quiz UI), professional/profanity, C/subtree |
| `doc/vocabulary.md` | Stable terms: product wire, shell debt, smoke debt, SSOT fragment, subtree release |
| `doc/SESSION-HANDOFF.md` | Compaction reseed: flake stage HITL, language surfaces, progress-log note |
| `doc/goals.md` | Link-only if three-languages bullet needs subtree wording |
| `RESIDUAL.md` / `RESIDUAL-systems.md` | Soft concern: reduce stage-id noise; keep one honest ladder table |
| `doc/progress-log.md` | Stale mill history; rotate header |
| `doc/PROGRESS-scc.txt` | Stale generated scc snapshot |
| `justfile` | Flake stage WARN; watch log bootstrap; hygiene recipe |
| `nix/source-hygiene.nix` (and/or new `nix/professional-tone.nix`) | Profanity / professional check |
| `flake.nix` | Wire new pure check if split from hygiene |
| `out/freestanding-c/README.md` | Subtree release + generated-only |
| `src/systems/README.md` | Emit vs smoke vs hand-written ban |
| `README.md` | Tree blurb may still say "flake apps" -- fix if inaccurate |
| `script/slake-emit-freestanding-c.sh` | Header comment: frozen debt; no growth (no body rewrite) |
| `src/systems/smoke/slake_behavioral_probe.c` | Header: smoke debt only |
| `.github/workflows/ci.yml` | Thin CI justification |
| `src/systems/lakefile.toml` / `lake-manifest.json` (and lean4 twins) | Lake host config |

---

## Reuse

| Symbol / module | Path | How |
|-----------------|------|-----|
| Novel source walk | `nix/novel-source.nix` | Same file set filter for profanity walk |
| Hygiene pure check | `nix/source-hygiene.nix` | Extend with word bans **or** sibling check |
| Jargon walk pattern | `nix/systems-host-presence/` | Mirror pure `hasInfix` walk for docs-wide profanity |
| Residual shell inventory table | `AGENTS.md` | Expand rows for C/JSON/TOML/YAML/BASH/Plain Text |
| Subtree release steps | `out/freestanding-c/README.md` | Promote to agent policy cross-link |
| Flake stage WARN | `justfile` `check` recipe | Keep; align docs |

---

## Steps

Ordered; implementation only after chat **Approve**.

### 1. HITL preference documentation (same turn as first edits)

Document in `AGENTS.md` (and reseed one line in `doc/SESSION-HANDOFF.md`):

- Always document human preferences and corrections in durable policy the same
  turn (already present -- strengthen if any gap).
- **Local unpushed WIP commits:** agents do not push; do not rewrite history
  unless human asks; hands-off git remains.
- **Flake visibility:** new `nix/` require **human** `git add` before
  `nix flake check` matches live impure just recipes; agents must not stage.
- **Professional tone:** no profanity; demeaning subagent language already
  banned globally.
- **Plan / clarification UX:** no structured questionnaires or multi-choice
  quiz tools for plan approval or residual clarification. Full plan in chat;
  wait for freeform Approve / revise / abandon. (Extends existing "Plans and
  approvals -- in chat, not only a modal".)
- **Language inventory** and **subtree-only generated C release** (step 2).

### 2. Language surface inventory (docs only)

Careful edits (rg to locate outdated claims, e.g. README "flake apps"):

1. Expand **Three languages only** / residual inventory in `AGENTS.md` with a
   **Non-product surfaces (justified)** table covering every scc language.
2. Per-surface justification:

   | Surface | Paths (examples) | Why it exists | Rule |
   |---------|------------------|---------------|------|
   | Shell | `script/*.sh`, `src/*/check.sh` | Temporary glue for Lake, emit driver, smoke compile | Shrink/port; delete mills; no new |
   | BASH (thin) | `script/git-hooks/*` | Pre-commit calls `just` / checks | Keep tiny; no logic farm |
   | C (emit) | `src/systems/emit/slake_freestanding.c`, copy in `out/freestanding-c/` | **Generated** freestanding product wire | Not hand-written product; freeze growth; replace via Lean emit |
   | C Header | `*.h` beside emit | Same wire | Same |
   | C (smoke) | `src/systems/smoke/slake_behavioral_probe.c` | Hosted behavioral smoke debt | Not product residual progress; do not grow as Systems Lean body |
   | Plain Text | `emit/host_emit_*.ssot.txt` | Lean-owned emit SSOT fragments | Host text, not shell-owned product |
   | Plain Text | `doc/PROGRESS-scc.txt` | Generated scc snapshot for meters | Regenerated; not hand-curated essay |
   | JSON | `**/lake-manifest.json` | Lake offline empty package set | Tool config only |
   | TOML | `**/lakefile.toml` | Lake project roots | Tool config only |
   | YAML | `.github/workflows/ci.yml` | CI == `just check` | Thin; no second suite |
   | Markdown | `doc/`, residuals, plans | Humans and agents | Min useful; ASCII policy |

3. **Freestanding / AOT C git policy:**

   - Hand-written product C is forbidden as implementation language.
   - Tracked files under `src/systems/emit/` and `out/freestanding-c/` are
     **generator outputs** (plus README prose under out/).
   - **Release:** publish `out/freestanding-c/` via **git subtree** (or tarball)
     after green `just build` + `just out-freestanding-c` + `just check`.
   - Do not treat `out/` as a place to author features by hand.
   - Lake `.lake/build/ir/*.c` is **classic Lean AOT IR**, not freestanding
     product; stay gitignored / untracked.

4. Mirror short terms in `doc/vocabulary.md`.

### 3. Soft concern: stage-id density (careful prose, not bulk rename)

1. Policy in AGENTS **Identifier hygiene**: one ladder table in residual;
   handoff summarizes + links; no new `*_V0` theater for doc-only milestones;
   prefer structural names in human prose.
2. Careful residual/handoff compress; no mass token rename in `.lean` this slice.

### 4. Soft concern: large shell emit (document + freeze header)

1. Header on `script/slake-emit-freestanding-c.sh`: frozen debt; do not add
   stages; Lean host-owned emit is the replacement path.
2. AGENTS: line-count honesty (Shell >> Nix is debt).
3. No body rewrite of the 2k-line script.

### 5. Soft concern: human flake stage (HITL)

1. Align `justfile` WARN with AGENTS/handoff.
2. Agents **never** `git add` to silence flake WARN.

### 6. Soft concern: stale progress-log

1. Replace `doc/progress-log.md` with clean header matching `just watch`
   (pure Nix; no `progress.py`).
2. Clean restart dated; prior cycles in git history.
3. Regenerate `doc/PROGRESS-scc.txt` via `just progress-scc` during implement.

### 7. Profanity / professional tone check (pure Nix)

1. Small word list under `nix/` (extend hygiene or `nix/professional-tone.nix`).
2. Walk novel `*.md`; exclude `ref/`, `.cache`, `.lake`.
3. Fail with path + matched token; short ASCII list.
4. Wire to `just hygiene` / `just check` + flake `checks`.
5. Document in AGENTS; no shell `rg` algorithm.

### 8. README / tree honesty

1. Fix root `README.md` if it still claims flake apps.
2. `src/systems/README.md`: emit generated, smoke debt.
3. Cross-link language inventory once (AGENTS is SSoT).

### 9. Verification (after implement) -- **done** 2026-07-22 (live gates green; flake HITL only)

```bash
rg -n 'progress\\.py|check-source-hygiene\\.py|flake apps' README.md AGENTS.md doc/ justfile
just hygiene
just systems-host
just systems-emit-wire
just progress-scc
# just check when human has staged any new nix modules
```


### 10. Out of scope follow-ons (do not auto-start)

- Real Lean emit replacing `slake-emit-freestanding-c.sh`
- Freestanding product self-host (C1 in plan-remaining-work)
- Bulk honesty rename of HOST-* Lean tokens
- Pushing or amending the WIP commit

---

## Risks

| Risk | Mitigation |
|------|------------|
| Profanity list hits legitimate technical text | Start narrow; md-first; exclude ref/ |
| Compressing residual loses greppable history | Keep one ladder table |
| Touching emit shell body by accident | Header-only edit |
| Flake check still red until human stages | Expected HITL; do not agent-stage |
| Progress-log rewrite loses audit trail | Note rewrite date; old content in WIP commit |
| Scope creep into Slake residual | Stop at docs + pure Nix tone + log hygiene |

## Verification

Success means:

1. AGENTS (+ vocabulary/handoff) document language inventory, subtree C policy,
   soft concerns, HITL flake stage, no-quiz plan UX, professional/profanity.
2. `doc/progress-log.md` no longer references deleted Python mills.
3. Pure Nix profanity/professional check exists and is wired; green on tree.
4. No new shell/C product lines added for "progress."
5. `just hygiene` (and full `just check` when flake paths are staged) green.
6. No push performed.

## Open questions

None blocking. Defaults locked under **Assumptions**. Human may revise
freeform in chat before or after approve.

---

## Plan workflow (this slice)

| Phase | Status |
|-------|--------|
| `plan:understand` | done |
| `plan:explore` | done |
| `plan:draft` | done (this file) |
| `plan:present` | exit_plan_mode + full plan in chat; wait freeform approval |
| `plan:handoff` | only after chat Approve -- seed `impl:*` todos, then implement |

---

## Implementation todo seeds (post-approval only)

| Id | Step |
|----|------|
| `impl:hitl-docs` | Document HITL + professional + no-push WIP + no-quiz UX in AGENTS/handoff |
| `impl:lang-inventory` | Language surface table + vocabulary + README honesty |
| `impl:subtree-c` | Subtree / generated-only C policy in AGENTS + out README + systems README |
| `impl:stage-id-prose` | Compress residual/handoff stage-id soup; AGENTS density policy |
| `impl:emit-shell-freeze` | Header freeze note on emit shell; inventory line-count honesty |
| `impl:progress-log` | Rewrite progress-log; refresh scc snapshot if appropriate |
| `impl:profanity-nix` | Pure Nix professional/profanity check + just/flake wire |
| `impl:verify` | hygiene + host + emit-wire (+ check if staged); rg stale mill strings |
