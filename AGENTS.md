# AGENTS.md -- Systems Lean

Policy for humans and coding agents working on the **Systems Lean** project (checkout may live under a path like `.../iso`; the project name is Systems Lean).

Global rules in `~/.grok/AGENTS.md` still apply (subagents, multi-chat, GPG). This file is project-specific and wins on conflict for work **in this tree**.

---

## Discovery after compaction (read order)

1. **This file** (`AGENTS.md`) -- policy, **Three languages only**, **Repository structure**, **Nix tooling**
2. `doc/SESSION-HANDOFF.md` (includes three-languages reseed)
3. `RESIDUAL.md` (status) and `WATCHER.md` (next implement prompt)
4. `doc/goals.md` and `doc/vocabulary.md` if goals or terms (including tooling terms) are unclear
5. `doc/architecture.md` / `doc/divergence.md` for technical framing
6. Entry maps when touching refs: `doc/idris-entry.md`, `doc/lean-entry.md`, `doc/compcert-entry.md`, `doc/rust-entry.md`
7. Workspace READMEs: `src/idris2/`, `src/lean4/`, `src/systems/`

Do **not** re-map the whole universe in parent context if handoff + residual already answer.

**Held hard work:** do not start items listed under Hold in `RESIDUAL.md` unless this chat has claimed research or primary implementor ownership for that work (supports clean chat forks).

---

## Isolation (hard rule)

**Default: work only in this repository.** This repo **is** Systems Lean.

- Implement the Systems Lean language and the **Slake compiler** **here**.
- Use `ref/*` as **read-only** upstream references.
- Do **not** open other trees for routine residual, "sync," or implementation.
- Leave isolation **only** when the human says we are **absolutely desperate** for a specific off-repo solution.

This is intentional. Other trees have been unproductive places to send agents. Stay here.

---

## What this project is

| Name | Meaning |
|------|---------|
| **Systems Lean** | **This project** and its language (Lean 4 + linear/affine ownership + minimum Quantitative Type Theory grades 0/1/omega for freestanding work) |
| **Slake** | The **compiler** written in Systems Lean: meet-in-the-middle Idris 2 and Lean 4, freestanding backends |
| **Primary emit** | Runtimeless freestanding C (`out/freestanding-c`): memory safety from linear types, **no garbage collection** on the product wire |

Canonical goals: `doc/goals.md` (read **Primary product focus**). Stable words: `doc/vocabulary.md`.

**Focus:** Systems Lean + Slake + freestanding runtimeless C. Do not dilute into unrelated tooling essays or deferred LLVM work before self-host.

---

## Three languages only (hard rule)

Novel work in this repository uses **exactly three languages**. Nothing else is a home for product logic or tooling logic.

| # | Language | Where it belongs | What it is for |
|---|----------|------------------|----------------|
| 1 | **Idris 2** | `src/idris2/` | Idris-side bridge work (maps, duals, join notes that live with Idris sources) |
| 2 | **Lean 4** | `src/lean4/` and `src/systems/` | Lean-side bridge work **and** Systems Lean / **Slake** (the freestanding product and compiler host synthesis) |
| 3 | **Nix** (modern **flakes**) | `nix/` + thin root `flake.nix` | Project tooling: gates, meters, filters, continuous-integration checks -- **pure** modules, not scripts hidden inside Nix |

### What is not a fourth language

These may appear on disk but are **not** places to implement new product or tooling algorithms:

| Surface | Role | Rule |
|---------|------|------|
| **Python** | Forbidden | No `*.py`. No "temporary" Python gates or meters. Ever. |
| **Shell / bash** (`.sh`, long recipes) | **Scheduled deletion** or **thin process glue** only | Do not grow it. Port logic into Lean 4 (product/gates that belong with Slake) or pure Nix (tooling). Delete when the exit criterion is met. |
| **Bash-in-Nix / shell-in-Nix / Python-in-Nix** | Forbidden | Embedding a shell or Python program inside `writeShellApplication`, `runCommand`, or similar and calling it a flake is still shell/Python. Not allowed. |
| **Freestanding C** (`out/freestanding-c/`, emit outputs) | **Product wire** (what Slake emits) | Generated release surface -- not a language for writing the project or its tools. Not "debt"; it is the product. |
| **Markdown** | Human/agent prose | Docs and residual ledgers only -- not executable product. |
| **`just` / justfile** | Thin task runner | May call Nix eval, print, sleep, or invoke **existing residual** scripts. Must not become a shell program farm. Keep recipes short. |
| **`ref/`** | Read-only upstream | Do not treat upstream languages or scripts as our product stack. |

### Pay down, do not accumulate (hard rule)

In the era of machine intelligence, large labeled piles of shell/C are a **choice**, not a law of nature. Ports to Lean 4 and pure Nix are cheap enough that **accumulation is failure**.

| Do | Do not |
|----|--------|
| **Pay down** scheduled-deletion items until the file is gone or reduced to thin process glue | Call permanent product wire / behavioral tests / thin just orchestration "debt" forever |
| Give every removable surface an **owner language** (Lean or pure Nix) and an **exit criterion** | Freeze banners without a delete path |
| Measure novel `scc` with honest excludes (`ref/`, `.lake/`, `.cache/`) | Inflate C counts with classic Lean ahead-of-time intermediate representation under `.lake` |
| Keep **product wire**, **behavioral tests**, and **process glue** as honest permanent roles when they belong | Grow shell or hand-written product C and call it residual progress |

**Word "debt":** reserve it for **scheduled deletion** (must leave the tree or shrink to process glue). Prefer role names for everything else: **product wire**, **behavioral tests**, **process glue**, **tool config**.

**Line-count honesty:** if novel `scc` (excluding `ref/`, `.lake/`, `.cache/`) shows Shell dominating Nix and Lean product sources, that is **regression**, not success. Do **not** claim shell is gone while scheduled-deletion `.sh` remains.

Plan (waves): `.agents/plans/plan-paydown-shell-c-surfaces.md`.

### Scheduled deletion (must leave; exit criteria)

**Delete on sight (forbidden mills; do not restore):**

- `script/progress.py`, `script/check-source-hygiene.py`, `script/check-source-hygiene.sh`
- `script/check-all.sh`, `script/watch-forks.sh`
- Any new `*.py` under this repo (outside `ref/`)

| Path | ~Lines | Exit criterion | Owner language |
|------|--------|----------------|----------------|
| `script/slake-emit-freestanding-c.sh` | gone | **Met (Wave C):** deleted; Lean `SystemsLean.FreestandingEmit` + templates write `slake_freestanding.{c,h}` from SSOT | Lean (`SystemsLean` emit) |
| `src/idris2/check.sh` static presence | ~30 glue | **Met (Wave A):** static mill in `nix/idris-side-presence/` (`just idris-side`); shell is optional `idris2 --check` only | pure Nix + thin glue |
| `src/lean4/check.sh` static presence | ~70 glue | **Met (Wave A):** static mill in `nix/lean-side-presence/` (`just lean-side`); shell is optional Lake only | pure Nix + thin glue |
| `script/build-systems.sh` | gone | **Met (Wave B):** deleted; `just build` calls `script/slake-compile-path.sh` | just + compile-path driver |
| `script/out-freestanding-c.sh` | gone | **Met (Wave B):** deleted; body is `just out-freestanding-c` (Wave C: Lean emit + copy) | just + Lean emit |
| `script/slake-compile-path.sh` | ~51 stamp | **Met (thin stamp):** static UNIT_SURFACE greps removed (pure Nix `systems-emit-wire` unit walk + host presence); shell is process-glue stamp for `just build` / emit preflight only; may delete later if stamp unneeded | process glue + pure Nix |
| Fat body of `src/systems/check.sh` | ~100 glue | **Met (Wave B):** process glue only (Lake + drivers + cc tests); static mills pure Nix | just + pure Nix gates |

**Emit shell deleted (Wave C).** Do not restore `script/slake-emit-freestanding-c.sh`. Product wire comes from Lean `SystemsLean.FreestandingEmit` + emit templates + SSOT.

### Permanent roles (not "debt")

| Role | Paths | Rule |
|------|-------|------|
| **Product wire** | `src/systems/emit/*.{c,h}`, `out/freestanding-c/*` | Generated freestanding C. Publish via git subtree / tarball. Do not hand-author features in C. |
| **Behavioral tests** | `src/systems/smoke/slake_behavioral_probe.c` | Hosted product-contract tests linked against the wire. Do not grow as Systems Lean body. Prefer shrinking only when Lean theorems **duplicate** a live `cc` contract with evidence. |
| **Process glue** | Thin just recipes; optional elaborator/`cc` one-liners; tiny `script/git-hooks/*` | Orchestration that must invoke external binaries. Keep tiny. Not a place for algorithms. |
| **Host emit SSOT text** | `src/systems/emit/host_emit_*.ssot.txt` | Lean-owned fragments; not shell dialect. |
| **Tool config** | `lakefile.toml`, `lake-manifest.json`, CI YAML | Config only. |
| **Prose** | `doc/`, residuals, plans, README | Humans and agents; min useful. |

**Target end state:** product and gates live in **Lean 4** / **Idris 2**; tooling lives in **small pure Nix modules**; `just` is a short menu; scheduled-deletion shells are **gone**; remaining shell is process glue only.

### Non-product surfaces (scc honesty)

When `scc` counts Shell, C, headers, config, or plain text beyond Lean / Idris / Nix, those are **non-product surfaces**: scheduled deletion, permanent roles above, tool config, or prose -- **not** a fourth novel implementation language. Full policy SSoT is this section; terms in `doc/vocabulary.md`.

**Honest novel `scc` excludes:** `ref/`, `.git/`, `.lake/`, `.cache/` (and similar build junk). Classic Lean ahead-of-time intermediate representation under `.lake` is **not** freestanding product C.

| Surface | Paths (examples) | Classification |
|---------|------------------|----------------|
| **Shell (scheduled deletion)** | none open for static mills (dual/static paid Wave A; compile-path greps paid thin-stamp) | Must leave if any mill returns |
| **Shell (process glue)** | `src/systems/check.sh`, `script/slake-compile-path.sh` (stamp), dual optional elaborators, `script/git-hooks/*` | Keep tiny; no static greps |
| **C (product wire)** | `src/systems/emit/slake_freestanding.c`, `out/freestanding-c/` | Generated; permanent role |
| **C Header** | `*.h` beside emit | Same wire |
| **C (behavioral tests)** | `src/systems/smoke/slake_behavioral_probe.c` | Tests; not product body |
| **Plain Text** | `src/systems/emit/host_emit_*.ssot.txt` | Host SSOT fragments |
| **Plain Text** | `doc/PROGRESS-scc.txt` | Generated meter snapshot |
| **JSON / TOML / YAML** | Lake + CI | Tool config |
| **Markdown** | `doc/`, residuals, plans | Prose |

Do **not** claim shell is gone while scheduled-deletion `.sh` remains.

### Freestanding / ahead-of-time (AOT) C git policy

Hand-written product **C is forbidden** as an implementation language for Systems Lean / residual progress (see **No new C or shell product work**). Ahead-of-time (AOT) here means classic Lean managed-runtime IR -- not freestanding product wire.

| Kind | Paths | Git / authoring rule |
|------|-------|----------------------|
| **Generator outputs (product wire)** | `src/systems/emit/*.{c,h}` (from emit driver), `out/freestanding-c/*.{c,h}` | Tracked as **dogfood / release surface** only. Refresh via `just out-freestanding-c` (and the emit driver). Do **not** author features by hand under `out/` or treat emit C as Systems Lean source. |
| **README under out** | `out/freestanding-c/README.md` | Human prose for consumers; may be edited. |
| **Host emit SSOT text** | `src/systems/emit/host_emit_*.ssot.txt` | Lean-owned fragments; not free-form product C. |
| **Behavioral tests** | `src/systems/smoke/slake_behavioral_probe.c` | Hosted product-contract tests only; shrink only when Lean covers the live contract; never grow as product body. |
| **Classic Lean AOT IR** | `.lake/build/ir/*.c` (and similar under Lake build trees) | **Not** freestanding product. Managed-runtime AOT IR only. Stay **gitignored / untracked**. Never ship as `out/freestanding-c`. |

**Release:** publish `out/freestanding-c/` via **git subtree** (or tarball) after green `just build` + `just out-freestanding-c` + `just check`. Consumers should not need `ref/*` or the full host. Detail: `out/freestanding-c/README.md`.

### Nix architecture for LLM (large language model) attention and compaction

Agents lose quality when context fills (soft band ~40% of effective context; cost knee often ~200k tokens). Nix layout must **help** that, not fight it.

1. **Small modules, one job each.** Prefer files under ~100-150 lines of one concern. Split helpers / data / render rather than one 500+ line dump.
2. **Thoughtful stable names.** Name for the job (`source-hygiene`, `progress/milestones`), never for a chat wave or session code.
3. **Thin `flake.nix`.** Only wire systems, import modules, expose `checks` / `packages` / `lib` / `devShells`. No embedded script farms.
4. **Pure evaluation first.** Hygiene and meters are Nix that *computes* pass/fail or report text. No hidden shell body doing the real work.
5. **Join on paths, not transcripts.** Parent agents keep module paths and short results; children edit small files -- do not paste whole kitchen-sink modules into context "to be sure."
6. **Same module locally and in continuous integration.** One pure check definition; `just` only orchestrates how humans run it.

Detail, mistake history, and current file map: section **Nix tooling** below. Terms: `doc/vocabulary.md` (Three languages + Tooling terms).

---

## Multi-chat roles (separate sessions)

Hunter often runs **several chats** on this repo. Do not assume which chat this is after compaction -- **ask once** if unclear.

| Session role | Owns | Does not |
|--------------|------|----------|
| **Watcher** | Separate session: residual auto-continue from root `WATCHER.md` (`WATCHER_BEGIN` / `WATCHER_END`); may run `just watch` / meters | Guess role as Slake or dual implementor; invent residual |
| **Systems / Slake** | Freestanding product under `src/systems/`, `RESIDUAL-systems.md`, paste `doc/fork-systems.md` | Race Idris/Lean dual trees; own the watcher session |
| **Idris side** | `src/idris2/`, `RESIDUAL-idris.md` | Freestanding Slake body unless reassigned |
| **Lean side** | `src/lean4/`, `RESIDUAL-lean.md` | Freestanding Slake body unless reassigned |
| **Coordinator** | Join board `RESIDUAL.md`, fork guidance, advisory join honesty | Race active implement forks by default |
| **Research / analysis** | Inventory, correspondence notes under `doc/research/` | Drive product residual unless reassigned |

**Important:** `WATCHER.md` is a **file** the watcher session reads. The watcher is **not** the same chat as Systems / Slake. `just watch` (progress meters every 300s) is tooling any session may run; it is not the watcher role by itself.

Talk in plain English. Prefer file paths and durable terms over wave numbers and ephemeral labels.

### Plans and approvals -- in chat, not only a modal

Hunter **hates approval modals**. They steal focus, hide the actual text, and accidental keypress can look like "approved."

- When a plan exists, **paste or paraphrase the full plan (or a faithful complete dump) into the chat reply**. Do not rely on a host modal as the only place the human can read it.
- Do **not** treat modal dismiss / accidental close / host "plan approved, start coding" as human approval unless the human has clearly said yes in chat (e.g. "execute", "approved", "go").
- If the host auto-approves after a modal accident: **stop, show the plan in chat, wait**.
- **No structured questionnaires** for plan approval or residual clarification. Do not use multi-choice quiz tools (`ask_user_question` or similar). Put the full plan (or the open question) in chat and wait for freeform **Approve** / revise / abandon (or a clear prose answer). Unresolved plan options use documented defaults in the plan, not a quiz.

### Language (agent UX) -- natural, precise, not lazy

Write **thoughtful, concise, natural language**. This is not a jargon dump or acronym soup.

- Prefer full words. Do not invent or drop in obscure short forms (e.g. never bare **TCB** -- write **trusted computing base**).
- **First use of any acronym or short form in a reply or durable doc:** unpack in parentheses. Example: Quantitative Type Theory (QTT), garbage collection (GC). After compaction, treat the next use as a new first use.
- If a word is jargon or has multiple meanings, unpack what you mean **here** in a short parenthetical.
- Avoid project-internal slang that needs a glossary to parse. Example: do **not** say **pole** for a language side of the bridge -- say **Idris side** / **Lean side** (or "fork for Idris work" / "fork for Lean work").
- **Wire:** when you mean the freestanding product release surface, say **product wire** (or unpack once: "product wire -- the emitted freestanding C under emit/ and out/freestanding-c"). Do not use bare "wire" as if the reader already knows. Do not confuse with flake **wire-up** (connecting Nix attributes). Canonical: `doc/vocabulary.md` (**Wire / product wire**).
- **Model:** when you mean a Lean or formal representation of contracts or IR, say **host model**, **structural model**, or **representation** -- **never** bare "model" if it could read as an AI/ML model. Canonical: `doc/vocabulary.md` (**Model (host / formal)**).
- **Banned naming jargon:** do **not** use **spine** (or "program spine", stage ids like `IR_PROGRAM_*`) for intermediate-representation structure. Say what it is in plain English: **ordered IR program**, **node list**, **program nodes**, **graph edges**. Existing greppable stage ids that already ship the word may be renamed in a deliberate honesty slice; never mint new `*SPINE*` names.
- **Do not say "pin" / "pinning"** for saving a rule into a file. That is agent-internal jargon.
- When you put a preference or process rule into a durable file, say **documented** (and name the file). Do not use vague fillers like bare **"written"** / "wrote it down" with no object -- say **documented in `AGENTS.md`** (or residual / watcher / the named doc). Prefer "documented" or "recorded in policy" over "pinned."
- The human may be terser; **agents must not** mirror unexplained shorthand.
- **Professional tone:** agent chat and novel project prose stay professional. No profanity in agent output or novel docs. Demeaning subagent language is already banned in global `~/.grok/AGENTS.md` -- follow that; do not restate it here.
- **Professional tone gate (pure Nix, v1):** novel `*.md` only (docs, residual, plans, AGENTS, READMEs). Module `nix/professional-tone.nix` -- short ASCII banned-token list; case-insensitive whole-token match (non-alphanumeric separators). Live: `just professional-tone` or folded into `just hygiene`. Flake check `professional-tone` after human stages new `nix/` paths. Does **not** scan Lean comments, emit C, or shell in v1. Algorithm is pure evaluation (`builtins.readFile` / `lib` walks) -- no shell `rg` policy mill.
- Prose encoding: see ASCII and Unicode rule (allowlist vs strict).

---

## Identifier hygiene and modular layout

**Ephemeral** (plans, residual ledgers, chat, implement prompts only -- **never** product source or permanent APIs):

- Plan **phase** labels (`Phase 1b`, `1a`, ...), **wave** numbers, **track** names, session codes
- `REQ-*` tokens, fashion brand names for temporary ideas
- Creative synonyms for the same ephemeral idea (do not invent "streams", "lanes", "epochs", etc. as product vocabulary)

**Do not pepper the codebase** (`.lean`, `.idr`, emit C, README product maps, module names, greppable host markers that describe the product) with those plan labels. Residual files and chat may mention implement order for humans/agents; product code names **what the thing is** (Mult, Linear, Types, ordered IR program).

**Stable:**

- `Slake`, `Systems Lean`, `freestanding`, module paths, gate names
- Upstream cites under `ref/`
- Greppable honesty tokens when gates exist (e.g. `SYSTEMS_LEAN_HOST`, `MULT-0`) -- durable product/host surface, not plan choreography

**Naming:** name things for what they are (algorithms, roles, release surfaces). Thoughtful names; no thesaurus farms or wave packing. No metaphor names (`spine`, fashion brands) when a structural name exists.

### Stage-id density (human prose vs greppable honesty)

Greppable honesty tokens (`HOST-*`, `SLAKE_*`, `EMIT_*`, stage ids required by pure Nix gates) stay where product Lean, presence specs, and emit wire need them. Do **not** mass-rename those in residual docs as "cleanup." Density policy is about **human-facing prose**, not erasing gate tokens.

| Surface | Rule |
|---------|------|
| **Residual ledgers (living)** | Drive work from an **Open** queue of plain **Names** with Goal / Done when / Out of scope / Paths (`RESIDUAL-systems.md`). Do **not** use phase / track / wave / SH* / P* as residual item titles. Do not re-paste greppable token maps into living residual; leave tokens in Lean / Nix / optional companions. Coordinator `RESIDUAL.md` joins Open Names only. |
| **SESSION-HANDOFF** | **Summarize + link** residual (`RESIDUAL.md` join board, `RESIDUAL-systems.md` for Systems). Do not re-paste token soup after compaction. |
| **Product Lean / Nix gates** | Honesty tokens required by presence checks stay. No bulk rename of `.lean` `HOST-*` markers as a docs slice. |
| **Doc-only milestones** | Do **not** mint new `*_V0` / plan-only stage ids only to mark a prose status change. |
| **Human prose** | Prefer structural names (Mult, Linear, freestanding product path, ordered IR program, host compose) over stacking greppable tokens in one sentence. |

Ephemeral vs stable above still applies. This subsection only tightens **readability and density** so residual stays honest without becoming greppable token soup.

### Living residual work items (hard rule)

Every open Systems residual item is a named accomplishment:

| Field | Rule |
|-------|------|
| **Name** | 2-6 words; what you build. Not a stage id. |
| **Goal** | One sentence. |
| **Done when** | Checkable outcomes. Theorems only for **new** properties, not readiness re-lists. |
| **Out of scope** | Explicit non-claims for the slice. |
| **Primary paths** | Few paths the implementer may touch. |

**Focus:** bootstrap freestanding **Slake** under `src/systems/` (Lean host + freestanding emit toward `out/freestanding-c`). Prefer product surface growth over host canary theorems.

**Autonomy (walk-away loops):** when Open has Name + checkable Done when, chain short implement loops via `WATCHER.md` without inventing work and without waiting for re-confirmation of non-claims already documented. When Done when is not checkable, **BLOCKED** with one concrete need. Cap concurrent subagents (~1 implementer + ~1 reviewer at effort 1; raise only with clean disjoint scopes). Parent stays thin; subagents own depth (fresh context, no compaction of child work).

**Do not put everything in one file.** Split modules, docs, and checks by responsibility. Prefer a small clear file over a kitchen-sink blob. New work uses the **three languages only** rule: Idris 2, Lean 4 (including Slake / Systems Lean), or pure Nix under `nix/` -- never a new Python or shell mill.

### Systems / Slake residual must grow Lean (hard rule)

**Systems Lean is Lean.** Slake is a compiler written in Systems Lean. Under `src/systems/`:

| Do | Do not |
|----|--------|
| Add real **`.lean`** sources (types, mult, linear, erasure, extract, IR, host, emit planning as Lean) | Grow another bash-generated freestanding **C API stage** (`EMIT_*_V0` ladder) as the main residual treadmill |
| Treat freestanding C under `emit/` / `out/freestanding-c/` as **emit product wire** (what Slake eventually produces) | Treat hand-written or generator-expanded C as the place Systems Lean is "implemented" |
| Pay down scheduled-deletion shell (`script/slake-*.sh`, fat `check.sh`) toward Lean/Nix | Mint new shell feature markers and call that progress |

If a Systems residual prompt only extends the C emit generator, **stop and re-scope** toward Lean sources unless the human explicitly asked for emit-wire-only work. Marker-stage theater is not residual closed.

### No new C or shell product work (hard rule -- delete-on-sight)

Hunter's bar: **writing more freestanding C sources or more shell scripts for product / residual progress is forbidden.** Unmaintainable. Already banned under **Three languages only**.

| Forbidden as "progress" | Allowed only if |
|-------------------------|-----------------|
| New or expanded `*.c` / `*.h` under `src/systems/`, `emit/`, `out/freestanding-c/` as the work of a residual slice | Human **explicitly** orders a named wire fix (rare); still not "Systems Lean implementation" |
| New or expanded `*.sh`, longer `check.sh`, more `script/slake-*.sh` stages | Human **explicitly** orders a named paydown or process-glue fix; prefer delete/port over grow |
| Generator edits that only mint another C API stage | Never as default residual |

**Existing** emit/out C is **product wire** (generated). Existing large shells are **scheduled deletion** until replaced by Lean/Nix -- not a license to grow them. Tracked emit/out C is **generator output** (see **Freestanding / ahead-of-time (AOT) C git policy** above); do not patch product contracts only in C without updating the authoritative generator / Lean SSOT path.

If residual is about to be "solved" by editing C or shell: **stop.** Do Lean (or pure Nix for tooling) instead. Hunter may **delete** C/shell additions that violate this without further discussion.

If a process correction matters, **document it in this file** or a named durable doc **in the same turn**.

---

## Documentation hygiene

- Product is not docs. **Minimum useful text** only; document once in the single source of truth (SSoT), link elsewhere.
- SSoT map: goals `doc/goals.md` | terms `doc/vocabulary.md` | residual `RESIDUAL.md` | reseed `doc/SESSION-HANDOFF.md` | this file for agent policy and Nix tooling.
- Research: `doc/research/` header **Kind: analysis only. Not residual.**
- Process corrections: document in this file or a named durable doc in the same turn.
- Do not invent residual from research unless asked.

### Learn preferences on every instruction (hard rule)

Hunter invests real time in tooling and process for this project. Treat each human instruction as a preference signal -- including freeform chat corrections, not only formal implement prompts.

**On every prompt that asks you to do something**, before or while acting, ask: *what durable preference or anti-mistake belongs in `AGENTS.md` (or a tighter living doc)?* Then **document it in that file in the same turn** when it is not already there. Do not call this "pinning." Do not say only that you "wrote" something -- say **documented in** the path. Do **not** collect preferences via multi-choice quiz UIs; freeform chat is enough (see **Plans and approvals**).

Examples of rules worth documenting:

- Format/extension conventions (e.g. `UNLICENSE.md`, not extensionless license files)
- Hands-off git unless asked; no push of local unpushed work-in-progress (WIP)
- ASCII-only novel work; acronym expansion for agents
- Isolation; workspace paths; freestanding vs runtime claims
- Human-in-the-loop (HITL) flake staging; professional tone / no profanity

Do **not** wait to be told "document that." Do **not** only fix the immediate file and forget the preference. The goal is fewer repeat mistakes and better agent UX after compaction.

### Residual implement loop / watcher (environment auto-continue)

Hunter's environment can **auto-run** residual implement instructions when they appear in a fixed, greppable place.

**Canonical on-disk watcher:** root file `WATCHER.md`
- Update the fenced block between `WATCHER_BEGIN` and `WATCHER_END` after every durable slice.
- Put the **same** text as the **final section** of the chat reply.

When you finish a planned slice:

1. If residual work is **clear and needs no human input**, write the next implement prompt into `WATCHER.md` using the residual **Name / Goal / Done when / Out of scope / Paths / Gates** shape **and** end the reply with that prompt so the harness can continue. Prefer freestanding Slake bootstrap Open Names over inventing theorem canaries.
2. If **blocked or ambiguous**, put a short blocked note in `WATCHER.md` (what is unclear); do not invent fake work. The blocked fence and the reply final section must **not** contain the implement slash-command token (even as "do not auto-run ..." prose) -- the harness will re-queue it as a new implement pass.
3. Never use the loop to race git, forge freestanding/PROVABLY claims, or start deferred tracks (e.g. `out/llvm-ir` before self-host).
4. Keep `RESIDUAL.md` as the join board (Open Names); `RESIDUAL-systems.md` as Systems detail; `WATCHER.md` as only the **next action**.

### Forks (Idris side / Lean side / Systems / Coordinator)

Research and implement forks are expected (each can be its **own session**). Product
freestanding work is the **Systems / Slake** session once duals are join-ready.
The **watcher** session is separate (see Multi-chat roles).

| Fork | Workspace | Paste prompt |
|------|-----------|--------------|
| Idris side | `src/idris2/` | `doc/fork-idris.md` |
| Lean side | `src/lean4/` | `doc/fork-lean.md` |
| Systems / Slake | `src/systems/` | `doc/fork-systems.md` |
| Coordinator | join board, residual honesty, fork guidance | `doc/fork-coordinator.md` |
| Watcher | `WATCHER.md` residual loop (separate session) | root `WATCHER.md` contract |

**Residuals (separate files):**

| File | Owner |
|------|--------|
| `RESIDUAL-idris.md` | Idris-side fork |
| `RESIDUAL-lean.md` | Lean-side fork |
| `RESIDUAL-systems.md` | Systems / Slake fork |
| `RESIDUAL.md` | Coordinator join board |

**Progress / watch:** `just progress` writes `doc/PROGRESS.md` from pure Nix (`nix/progress/`, flake output `progressReportText`). `just progress-scc` adds an `scc .` appendix. `just watch` is a just loop (300s sleep; process uptime is not cycle cost). Hygiene is pure Nix (`nix/source-hygiene.nix` ASCII + trailing whitespace, plus `nix/professional-tone.nix` novel markdown tone) -> live `just hygiene`; flake checks `source-hygiene` and `professional-tone`.

**Do not** implement both language sides only as Lean models of Idris unless the human redefines the goal. Honest meet-in-the-middle needs **real Idris sources** plus **real Lean sources**, then a stated map (later formalized, often in Lean). Freestanding synthesis: `src/systems/` (Slake) via the systems fork.

**Single freestanding emit stage id:** product C emit is **`SLAKE_EMIT_FREESTANDING_C_V0`**
(Lean `SystemsLean.FreestandingEmit` / lake exe `slake-emit-freestanding-c`,
`src/systems/emit/`, `just out-freestanding-c`). Bash emit driver is **gone** (Wave C).
Do not land a second competing emit stage id in the same tree without retiring the other.
Concurrent sessions must not delete shared tooling under `script/` while another
session is mid-slice.

---

## Technical honesty

1. **Three runtime stories** -- Idris reference-counting C backend; classic Lean ahead-of-time with managed runtime; freestanding product with **no** Lean managed runtime on the wire. Never conflate.
2. **Dual residual** -- product residual != host elaborator residual; never forge either.
3. **Ahead-of-time != freestanding.** Runtimeless freestanding C is the primary product claim.
4. **PROVABLY** requires real resolved CompCert evidence; never sell weaker dogfood as PROVABLY.
5. **Rust-native link** (layout-compatible intermediate representation) is deferred until self-host; not a claim yet.
6. **`ref/` is read-only.** Novel work: `src/idris2/`, `src/lean4/`, `src/systems/`.
7. **No product garbage collection.** Memory safety from linear/affine types and checks.
8. **Reference counting** on freestanding paths only if proven unavoidable; see `src/systems/README.md`.
9. **Multiplicities:** only minimum 0 / 1 / omega for freestanding Slake in `src/systems/`.

## Feedback loops: tests and proofs

Both are required. Neither replaces the other (scientific method: theory + experiment).

### Executable feedback (red / green)

- Prefer **red/green** test-driven development for product behavior: failing test or check first, then implementation, then green `just check` (and focused tests when they exist).
- Do not claim done on vibes. Gates and tests must actually run.

### Formal feedback (spec then proof)

- Separate **specification** from **proof** as cleanly as the host allows: state what must hold, then prove it.
- Take time on the specification. Do not bury the claim inside an unstructured proof script with no readable statement.
- Proofs do **not** retire tests: a theorem about a model is not a run of freestanding emit, and a green smoke is not a full proof.

---

## Subagents and token efficiency (strategic max, not wasteful)

**Goal: token efficiency under attention limits.** Maximal **strategic** use of parallel subagents -- not maximal spawn count, not parent solo on deep work, not thrash.

### Context economics (plan against these)

- **Attention dilution:** parent quality drops as context fills -- often well before the hard cap. Parent is a **coordinator budget**, not a tool-output warehouse.
- **Soft quality band:** keep the parent near **~40%** of its effective context when you can.
- **Cost knee:** treat **~200k** parent tokens as a soft ceiling where further tokens get expensive (often ~**2x**). Hard ceiling may be higher (e.g. **500k**); do **not** treat "room left" as "fill it."
- **Child isolation is the win:** each subagent has a fresh context. Heavy read/search/edit loops belong in children; parent holds goals, artifact paths, and short join results.

### Maximal strategic use

| Pattern | When | Parent keeps |
|---------|------|----------------|
| Parallel **explore** (read-only) | Disjoint dirs/files | Bullet map + paths only |
| Independent research | Live contract vs local inventory | One-line results each |
| Implementer + true-independent background | Scopes do not race | Exit codes + log paths |

Rules of thumb:

1. **Spawn for depth, not ceremony.** Many greps/reads/edits -> child. 1-2 lookups -> parent.
2. **Join on disk.** Children write short summary files; parent reads those, not full transcripts or whole hot modules "to be sure."
3. **Tight prompts.** Self-contained: goal, paths, acceptance, hard non-claims, output path. No parent history dump.
4. **Short returns.** Verdict, files, residual bullets -- not novels.
5. **One wait for many.** Launch independent children together; multi-id wait. Do not serialize independent explores.
6. **`resume_from` for rounds.** Fix/re-review resumes the same agent when possible.
7. **Right type.** Prefer explore/plan (read-only) for mapping; general-purpose only when writes are required.
8. **Cap concurrency** (~2-4 typical). Raise only with clean disjoint scopes.
9. **Right-size effort.** effort=1 is the token-efficient default; escalate only when risk justifies multi-reviewer cost.

### Anti-patterns (waste)

- Spawning for pure status ("is the file there?")
- Fan-out of N identical explores over the same scope
- Parallelizing a serial dependency
- Parent re-implementing or re-grepping after a child finished
- Stuffing the parent with raw logs when path + exit + short tail would do
- Nested spawn fantasies (children cannot spawn children in this host)
- Gate-only mills with no new named delta

### After compaction

Reseed from `RESIDUAL.md`, handoff, and on-disk summaries. Prefer `resume_from` when the host still has the child id. Soft ~40% / ~200k knee still apply to the **new** parent window.

Fork prompts embed the same implement-loop design: `doc/fork-idris.md`, `doc/fork-lean.md`, `doc/fork-systems.md`.

---

## ASCII and Unicode (hard rule)

**How the check scrubs:** pure Nix `nix/source-hygiene.nix` (`just hygiene`, flake check `source-hygiene`) evaluates novel files with `builtins.readFile`: fails non-ASCII outside the allowlist and trailing whitespace. No ripgrep, no bash, no Python in the algorithm. Upstream `ref/**` is not scanned. Related pure checks: `just professional-tone` / flake `professional-tone` (`nix/professional-tone.nix`) for novel markdown banned tokens (also folded into `just hygiene`); `just systems-host` / flake `systems-host-presence` (`nix/systems-host-presence/`) for static Systems host presence tokens; `just systems-emit-wire` / flake `systems-emit-wire` (`nix/systems-emit-wire/`) for emit-wire stage tokens, UNIT_DEEPEN, unit-surface walk, optional release surface, hosted behavioral probe path; `just idris-side` / flake `idris-side-presence` (`nix/idris-side-presence/`) and `just lean-side` / flake `lean-side-presence` (`nix/lean-side-presence/`) for dual-side static presence (Wave A; thin check.sh is elaborator glue only).

| Path | Unicode? |
|------|----------|
| `doc/ascii-symbol-map.md` | **Yes** -- glossary of Unicode -> ASCII spellings (source of map for `--fix`) |
| `README.md` | **Yes** -- human-facing overview may use Unicode |
| `doc/vocabulary.md` | **Yes** -- term table may use Unicode |
| All other novel work | **No** -- ASCII only; use map spellings (`--`, `"..."`, `omega`, `->`, ...) |
| `ref/**` | Upstream; not rewritten |

```bash
just check                         # full suite (hygiene + systems-host + systems-emit-wire + idris-side + lean-side + flake + residual shells)
just hygiene                       # pure Nix ASCII + trailing WS + professional-tone (novel *.md)
just professional-tone             # pure Nix novel markdown banned-token gate only
just systems-host                  # pure Nix static host/unit-surface presence
just systems-emit-wire             # pure Nix emit-wire / UNIT_DEEPEN / unit walk
just idris-side                    # pure Nix Idris-side dual presence (files + tokens + jargon)
just lean-side                     # pure Nix Lean-side dual presence (files + tokens + jargon)
nix flake check                    # pure checks (source-hygiene, professional-tone, systems-host-presence, systems-emit-wire, idris-side-presence, lean-side-presence, ...)
just progress                      # meters (pure Nix generator)
just progress --scc                # meters + scc .
just watch                         # 300s loop (short just recipe; not a flake app)
```

No success claim on novel edits without green hygiene (allowlist files still must have no trailing whitespace).


## Repository structure (evolving detail)

Keep this map current when dirs move. README has a short tree; **this section is the agent SSoT (source of truth)**.

```
.
+-- src/                      # ALL novel product sources
|   +-- idris2/               # Idris 2 side -- isomorphism, dual examples, QTT (Quantitative Type Theory) maps
|   +-- lean4/                # Lean 4 side -- novel Lean-facing bridge work (not freestanding product)
|   +-- systems/              # Freestanding Systems Lean + Slake compiler host synthesis
+-- out/
|   +-- freestanding-c/       # Runtimeless freestanding product C (release)
|   +-- llvm-ir/              # LLVM IR / Rust-native link (deferred until self-host)
+-- ref/                      # Upstream ONLY (read-only submodules)
|   +-- Idris2/
|   +-- lean4/
|   +-- CompCert/
|   +-- rust/
+-- doc/                      # Goals, vocabulary, architecture, divergence, entry maps, research/
+-- nix/                      # Pure Nix tooling modules (progress, source-hygiene, professional-tone)
+-- script/                   # Scheduled deletion / process glue only (pay down; port to Lean/Nix)
+-- .github/workflows/        # CI == just check
+-- justfile
+-- flake.nix / flake.lock
+-- AGENTS.md / README.md / RESIDUAL.md / LICENSES.md / UNLICENSE.md
+-- .agents/plans/            # Plans (ephemeral relative to product)
```

| Path | Write? | Role |
|------|--------|------|
| `src/idris2/` | yes | Idris side novel work; never edit `ref/Idris2` as product |
| `src/lean4/` | yes | Lean side novel work; never edit `ref/lean4` as product |
| `src/systems/` | yes | Freestanding product + Slake; min mults; no product GC (garbage collection) |
| `out/freestanding-c/` | emit | Runtimeless freestanding C (`just out-freestanding-c`) |
| `out/llvm-ir/` | deferred | LLVM IR for Rust-native link; after self-hosted Systems Lean / Slake |
| `ref/*` | no | Upstream references only |
| `doc/` | yes | Durable design / policy prose (min tokens) |
| `nix/` | yes | Small pure flake modules (hygiene, progress, novel-source) |
| `script/` | pay down | Scheduled deletion / process glue only -- never a template for new tools |

**Commands vs trees:** `just build` -> `src/systems/`. `just out-freestanding-c` -> `out/freestanding-c/`. `just out-llvm-ir` reserved (deferred). `just check` -> full suite.

## Nix tooling (under three languages only)

This section details language **3** (pure Nix flakes). Read **Three languages only** first.

**Product and bridge code** is Idris 2 or Lean 4 under `src/`.
**Repo tooling** (meters, source hygiene, flake checks) is **pure Nix** under `nix/`, with a **thin** `justfile` only for orchestration. Not Python. Not shell. Not shell wrapped to look like Nix.

Terms (plain English); full glossary in `doc/vocabulary.md`:

| Phrase | Meaning |
|--------|---------|
| **Nix** | Build and configuration language for project tools and continuous integration. |
| **Flake** | Nix project entry (`flake.nix` + lock file) that exports named outputs (checks, packages, shell). |
| **Pure Nix / pure evaluation** | The tool is ordinary Nix that *computes* a result (report text, pass/fail). No hidden shell doing the real work. |
| **Bash-in-Nix** | Long shell inside `writeShellApplication` / `runCommand` sold as a flake tool. Forbidden. |
| **`just` / justfile** | Thin task runner. Loops and redirects only -- not the policy algorithm. |
| **Orchestration** | Gluing steps (write `doc/PROGRESS.md`, sleep, run `scc`). Not product logic. |
| **ripgrep (`rg`)** | Default code search in the flake **devShell** (`pkgs.ripgrep`). Agents and humans search with `rg`, not ad-hoc `grep` mills. Pure Nix checks still must not shell out to ripgrep for policy algorithms. |
| **elan** | Lean toolchain manager in the flake **devShell**. Install the pin from `src/systems/lean-toolchain` / `src/lean4/lean-toolchain` (`leanprover/lean4:v4.32.0`). Do not default to lagged `pkgs.lean4` as the elaborator. Workspace checks skip Lake when the pin is not installed (no surprise network download). |
| **idris2 (devShell)** | Idris 2 elaborator package in the flake **devShell** for bridge-side checks. Residual `src/idris2/check.sh` still skips when the binary is absent. |
| **Novel source** | Our tree -- not `ref/`, not `.git/`, not caches. |
| **Source hygiene** | Novel text is printable ASCII (plus tab/newline) except a small allowlist; no trailing spaces/tabs. |
| **Professional tone** | Novel `*.md` only (v1): short banned-token list in pure Nix; no profanity / demeaning slurs in project markdown. |
| **Progress meters** | Evidence-weighted bars in `doc/PROGRESS.md` (not a calendar guess). |
| **Kitchen-sink file** | One huge file mixing unrelated jobs. Split instead. Designed against large language model attention limits. |

### What went wrong (do not repeat)

1. Progress meters and source hygiene as **project Python** under `script/`.
2. "Fix" by stuffing the same work into **shell strings inside Nix** (bash-in-Nix) and flake apps.
3. Product/build gates grown as **multi-thousand-line shell** under `script/` and `src/**/check.sh` instead of Lean or pure Nix.
4. Human rejection: **three languages only**; pure small Nix modules; architecture that respects large language model attention and compaction -- not Python, not bash-in-Nix, not kitchen-sink files.

**Core lesson:** ask **where the algorithm lives**. If it lives in `.py` or a long shell string (including inside Nix), you have not done the work.

### Who owns what

| Layer | Owns | Does not own |
|-------|------|----------------|
| **`nix/` (pure Nix)** | Tooling policy, meters, filters, report text; flake checks; pure text packages | Product language semantics; multi-kLOC shell; sleep loops as "Nix packages" |
| **`justfile`** | Short orchestration: eval redirect, watch interval, call residual debt scripts, optional scc | New algorithms; growing into a program |
| **`flake.nix`** | Thin wire-up only | Embedded script farms |
| **`script/` and `*.sh`** | Scheduled deletion / thin process glue only (see three-languages inventory) | New tools; expanding check/emit bash |

### Before you add anything

1. **Is it Idris-side product/bridge?** -> Idris 2 under `src/idris2/`.
2. **Is it Lean-side or Slake / Systems Lean?** -> Lean 4 under `src/lean4/` or `src/systems/`.
3. **Is it repo tooling (gate, meter, filter)?** -> Pure Nix module under `nix/`, small and named; wire a check or pure package; thin `just` line.
4. **Is it only orchestration?** -> Short `just` recipe. Not a flake app whose body is bash.
5. **Would you reach for Python or a new `.sh`?** -> Stop. Wrong language. Port or design in Lean/Nix.
6. **Would the file exceed ~100-150 lines of mixed concerns?** -> Split for humans and for large language model context. Names describe the job.

### Hard bans

- No project Python.
- No new shell mills; do not grow residual `.sh` files.
- No bash-in-Nix / shell-in-Nix / Python-in-Nix.
- No flake apps that are only shell farms.
- No kitchen-sink `flake.nix` or mega `nix/` modules.
- No "I removed Python" victory that leaves the algorithm in shell.

### Current pure Nix map (keep small; update when tools move)

| Tool | How you run it | Where the logic lives |
|------|----------------|------------------------|
| Source hygiene | `just hygiene` (includes professional-tone) or flake `source-hygiene` | `nix/source-hygiene.nix` -> check `source-hygiene` |
| Professional tone | `just professional-tone` or folded into `just hygiene`; flake after human stages | `nix/professional-tone.nix` -> check `professional-tone` (novel `*.md` banned tokens) |
| Systems host presence | `just systems-host` (live); flake after human stages | `nix/systems-host-presence/` -> check `systems-host-presence` |
| Systems emit-wire presence | `just systems-emit-wire` (live); flake after human stages | `nix/systems-emit-wire/` -> check `systems-emit-wire` (drivers, emit product, unit walk, optional release, hosted probe path) |
| Idris-side dual presence | `just idris-side` (live); flake after human stages | `nix/idris-side-presence/` -> check `idris-side-presence` (files + tokens + examples jargon) |
| Lean-side dual presence | `just lean-side` (live); flake after human stages | `nix/lean-side-presence/` -> check `lean-side-presence` (files + tokens + examples jargon) |
| Progress meters | `just progress` | `nix/progress/` -> text outputs / package `progress-report` |
| Line-count appendix | `just progress-scc` | `just` + `scc` on PATH |
| Watch loop | `just watch` | short `just` loop only |
| Full suite | `just check` | hygiene (+ professional-tone) + systems-host + systems-emit-wire + idris-side + lean-side + flake check + residual workspace scripts |

**New pure Nix modules and flakes (HITL stage):** `just systems-host` / `just
systems-emit-wire` / `just idris-side` / `just lean-side` / `just hygiene` /
`just professional-tone` evaluate the live worktree (impure) and do not require
the new path to be git-tracked. `nix flake check` and
`nix build .#checks.*.systems-host-presence` (or `systems-emit-wire`,
`idris-side-presence`, `lean-side-presence`, `professional-tone`) only see files
git tracks. After adding under `nix/` (and any related paths the flake copy
needs), the **human** must `git add` those paths before flake/continuous
integration (CI) match. Agents must **not** stage files to "help," silence flake
WARN, or force flake/CI green. Prefer impure `just` pure-eval gates until the
human stages. The `justfile` `check` recipe WARN states the same policy without
a hardcoded path list -- stage what the flake error names (or `git status` under
`nix/` and related flake copy paths). Same idea in `doc/SESSION-HANDOFF.md`
(**Flake vs live**).

```
nix/
  novel-source.nix            # which paths count as novel work
  source-hygiene.nix          # pure ASCII + no trailing whitespace
  professional-tone.nix       # novel *.md professional tone / banned tokens (v1)
  systems-host-presence/      # skeleton + unit-surface + SYSTEMS_LEAN_HOST + tree-wide jargon
    default.nix               # pure eval: { ok, violations, summary }
    specs.nix                 # required paths + token tables
  systems-emit-wire/          # compile/emit drivers, UNIT_DEEPEN, emit stages, unit walk, probe path
    default.nix               # pure eval: { ok, violations, summary }
    specs.nix                 # thin join of data slices below
    emit-product.nix          # drivers + emit product APIs/stages + optional release + smoke probe path
    unit-deepen.nix           # UNIT_DEEPEN_V1 units + companions
    unit-walk.nix             # dynamic SKELETON|UNIT_SURFACE walk + skip dirs
  idris-side-presence/        # dual Idris static presence (Wave A; was check.sh mill)
    default.nix               # pure eval: { ok, violations, summary }
    specs.nix                 # required paths + tokens + examples jargon
  lean-side-presence/         # dual Lean static presence (Wave A; was check.sh mill)
    default.nix               # pure eval: { ok, violations, summary }
    specs.nix                 # required paths + tokens + examples jargon
  progress/
    default.nix               # entry: report and scores from a tree root
    helpers.nix               # path probes
    milestones.nix            # weighted evidence list
    bars.nix                  # ASCII meter bars
    render.nix                # markdown + console text
```

## License (our novel work)

- Root dedication: `UNLICENSE.md` + narrative/inventory in `LICENSES.md`.
- Author: Hunter "cryptoquick" Beast.
- For **any novel crates, modules, or packages we write** (Rust, Lean, Idris, Nix, etc.): set license metadata to the SPDX id **`Unlicense`** (e.g. Cargo `license = "Unlicense"`, Nix `meta.license = lib.licenses.unlicense`, optional `SPDX-License-Identifier: Unlicense` headers).
- Never label upstream/`ref/` code as Unlicense.

## Git (default: hands off)

**Do not think about git at all unless the human explicitly asks.**

- No `git add`, `git commit`, `git push`, `git status` for staging hygiene, no staging "to help," no commit message drafts unless requested.
- The human stages and commits as a proper software engineer. Your job is the work product on disk.
- **Local unpushed WIP:** agents do **not** push. Do not rewrite history (`git commit --amend`, rebase, force-push) of published or human WIP commits unless the human explicitly asks. Leave local commits alone.
- When (and only when) they ask for git help: follow their ask; still never unsigned-commit workarounds (`--no-gpg-sign`, `commit.gpgsign=false`, fake `gpg.program`). Surmount-style verified signatures remain mandatory if a commit is requested.
- Do not commit secrets.

---

## Success criteria

Do not claim success unless verification for the task actually ran.

**Foundation verification:**

```bash
cd /home/hunter/Projects/ai/iso
test -f AGENTS.md && test -f README.md && test -f RESIDUAL.md
test -f doc/goals.md && test -f doc/vocabulary.md
test -f doc/architecture.md && test -f doc/divergence.md
test -f doc/SESSION-HANDOFF.md
test -f doc/idris-entry.md && test -f doc/lean-entry.md
test -f doc/compcert-entry.md && test -f doc/rust-entry.md
test -f doc/research/README.md
test -f doc/ascii-symbol-map.md
test -f flake.nix
test -f ref/Idris2/README.md && test -f ref/lean4/README.md
test -f ref/CompCert/README.md && test -f ref/rust/README.md
just hygiene
git submodule status
```

Later: real builds and tests as defined in residual -- not vibes.

---

## What agents must not do

- Divert Systems Lean work to other residual mills by default
- Treat Idris RefC or classic Lean AOT as freestanding
- Edit `ref/*` as product
- Use ephemeral wave-speak as permanent product vocabulary
- Forge residual / PROVABLY / host residual_free claims
- Bypass GPG signing
- Implement novel work in any language other than **Idris 2**, **Lean 4**, or **pure Nix flakes** (see Three languages only)
- Grow freestanding **C** or **shell** as Systems / Slake residual "progress" (see No new C or shell product work)
- Add or restore project Python (`*.py`)
- Add or grow shell/bash mills; restore deleted mills (`progress.py`, `check-source-hygiene.*`, `check-all.sh`, `watch-forks.sh`)
- Smuggle tool logic through bash-in-Nix / shell-in-Nix / Python-in-Nix or flake apps that are only shell farms
- Grow kitchen-sink `flake.nix`, mega `nix/` modules, or multi-thousand-line `check.sh` / emit shell instead of Lean or pure Nix
