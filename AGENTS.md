# AGENTS.md -- Systems Lean

Policy for humans and coding agents working on the **Systems Lean** project (checkout may live under a path like `.../iso`; the project name is Systems Lean).

Global rules in `~/.grok/AGENTS.md` still apply (subagents, multi-chat, GPG). This file is project-specific and wins on conflict for work **in this tree**.

---

## Discovery after compaction (read order)

1. **This file** (`AGENTS.md`) -- policy + **Repository structure**
2. `doc/SESSION-HANDOFF.md`
3. `RESIDUAL.md`
4. `doc/goals.md` and `doc/vocabulary.md` if the goal is unclear
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

## Multi-chat roles

| Role | Does | Does not |
|------|------|----------|
| **Research / analysis** | Inventory, correspondence analysis, notes under `doc/research/` | Drive residual implementation unless reassigned |
| **Primary implementor** | Residual work, product docs, later source | Need research chat to own git |

If role is unclear after compaction: **ask once**.

Talk in plain English. Prefer file paths and durable terms over wave numbers and ephemeral labels.

### Language (agent UX) -- natural, precise, not lazy

Write **thoughtful, concise, natural language**. This is not a jargon dump or acronym soup.

- Prefer full words. Avoid lazy abbreviations and undefined slang.
- When a short form is still useful, expand it in parentheses on use (and after compaction, re-expand): Quantitative Type Theory (often written QTT), trusted computing base, application binary interface, intermediate representation, foreign function interface, ahead-of-time, garbage collection.
- If a word is ambiguous, unpack what you mean **here** in a short parenthetical.
- ASCII only in novel prose (see ASCII-only rule).
- The human may be terser; **agents must not** mirror unexplained shorthand.

---

## Identifier hygiene and modular layout

**Ephemeral** (plans, research, chat only -- not source or permanent APIs):

- Wave numbers, session codes, plan phase ids
- `REQ-*` tokens, fashion brand names for temporary ideas

**Stable:**

- `Slake`, `Systems Lean`, `freestanding`, module paths, gate names
- Upstream cites under `ref/`
- Greppable honesty tokens when gates exist

**Naming:** name things for what they are (algorithms, roles, release surfaces). Thoughtful names; no thesaurus farms or wave packing.

**Do not put everything in one file.** Split modules, docs, and checks by responsibility. Prefer a small clear file over a kitchen-sink blob. New tools get their own script/flake check with a clear name, wired through `just check`.

If a process correction matters, pin it in **this file** or a named durable doc **in the same turn**.

---

## Documentation hygiene

- Product is not docs. **Minimum useful text** only; pin once in the SSoT, link elsewhere.
- SSoT map: goals `doc/goals.md` | terms `doc/vocabulary.md` | residual `RESIDUAL.md` | reseed `doc/SESSION-HANDOFF.md` | this file for agent policy.
- Research: `doc/research/` header **Kind: analysis only. Not residual.**
- Process corrections: pin same turn here or named durable doc.
- Do not invent residual from research unless asked.

### Learn preferences on every instruction (hard rule)

Hunter invests real time in tooling and process for this project. Treat each human instruction as a preference signal.

**On every prompt that asks you to do something**, before or while acting, ask: *what durable preference or anti-mistake belongs in `AGENTS.md` (or a tighter living doc)?* Then **pin it the same turn** when it is not already written.

Examples of pins worth making:

- Format/extension conventions (e.g. `UNLICENSE.md`, not extensionless license files)
- Hands-off git unless asked
- ASCII-only novel work; acronym expansion for agents
- Isolation; workspace paths; freestanding vs runtime claims

Do **not** wait to be told "document that." Do **not** only fix the immediate file and forget the preference. The goal is fewer repeat mistakes and better agent UX after compaction.

### Residual implement loop (environment auto-continue)

Hunter's environment can **auto-run residual implement-loop statements** from the end of an agent turn.

When you finish a planned slice:

1. If residual work is **clear, low-ambiguity, and needs no human input**, end with an explicit **next residual implement loop** (concrete steps / acceptance) so the harness can continue -- then do that work yourself in the same session when you are allowed to act.
2. If something is **blocked or ambiguous**, state what is unclear (options + recommendation) and **do not** invent a fake green residual loop.
3. Never use the loop to race git, forge freestanding/PROVABLY claims, or start deferred tracks (e.g. `out/llvm-ir` before self-host).

### Dual forks (Idris pole / Lean pole)

Two research/implement forks are expected:

| Fork | Workspace | Paste prompt |
|------|-----------|--------------|
| Idris side | `src/idris2/` | `doc/fork-idris.md` |
| Lean side | `src/lean4/` | `doc/fork-lean.md` |
| Coordinator | tooling, join, residual honesty | `doc/fork-coordinator.md` (this chat by default) |

**Do not** implement both poles only as Lean models of Idris unless the human redefines the goal. Honest meet-in-the-middle needs **real Idris sources** plus **real Lean sources**, then a stated map (later formalized, often in Lean). Freestanding synthesis: `src/systems/` (Slake).

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

## Subagents and context

Follow global strategic parallelism (`~/.grok/AGENTS.md`):

- Parent coordinates; children do heavy explore/edit loops
- Join via short on-disk artifacts; keep parent near soft context budget
- Cap concurrency; `resume_from` for fix rounds
- After compaction: reseed from handoff + residual, not from zero exploration if artifacts exist

---

## ASCII-only (hard rule)

This is an **ASCII repository** for novel work: printable ASCII + no trailing whitespace.

**Only exception:** `doc/ascii-symbol-map.md` -- the glossary that maps Unicode symbols to our ASCII spellings. Everywhere else we author: no smart quotes, dashes, Greek, box-drawing, etc. `ref/**` (upstream) is exempt from rewrite.

```bash
just                    # list tasks
just check              # full suite = CI = script/check-all.sh
just pre-commit         # staged suite (git hook)
just build              # freestanding src/systems/ (Slake host)
just out-freestanding-c     # refresh out/freestanding-c
just out-llvm-ir            # deferred (see out/llvm-ir/README.md)
./script/check-source-hygiene.sh --fix
```

No success claim on novel edits without green `just check` (or staged pre-commit) unless only editing the symbol map.

## Repository structure (evolving detail)

Keep this map current when dirs move. README has a short tree; **this section is the agent SSoT (source of truth)**.

```
.
+-- src/                      # ALL novel product sources
|   +-- idris2/               # Idris 2 pole -- isomorphism, dual examples, QTT (Quantitative Type Theory) maps
|   +-- lean4/                # Lean 4 pole -- novel Lean-facing bridge work (not freestanding product)
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
+-- script/                   # check-all, build-systems, out-freestanding-c, hygiene, git-hooks/
+-- .github/workflows/        # CI == just check
+-- justfile
+-- flake.nix / flake.lock
+-- AGENTS.md / README.md / RESIDUAL.md / LICENSES.md / UNLICENSE.md
+-- .agents/plans/            # Plans (ephemeral relative to product)
```

| Path | Write? | Role |
|------|--------|------|
| `src/idris2/` | yes | Idris pole novel work; never edit `ref/Idris2` as product |
| `src/lean4/` | yes | Lean pole novel work; never edit `ref/lean4` as product |
| `src/systems/` | yes | Freestanding product + Slake; min mults; no product GC (garbage collection) |
| `out/freestanding-c/` | emit | Runtimeless freestanding C (`just out-freestanding-c`) |
| `out/llvm-ir/` | deferred | LLVM IR for Rust-native link; after self-hosted Systems Lean / Slake |
| `ref/*` | no | Upstream references only |
| `doc/` | yes | Durable design / policy prose (min tokens) |
| `script/` | yes | Tooling shared by just / CI / pre-commit |

**Commands vs trees:** `just build` -> `src/systems/`. `just out-freestanding-c` -> `out/freestanding-c/`. `just out-llvm-ir` reserved (deferred). `just check` -> full suite.

## Nix tooling

- **Modern idiomatic flakes only** for project tooling (`flake.nix` / `flake.lock`). Thoughtful attribute names (`source-hygiene`, `systems-lean` shell, `novelSource`).
- New tools: flake `packages` / `apps` / `checks` / `devShells` **and** a `just` recipe; wire into `script/check-all.sh` so local == continuous integration.
- No undocumented one-off scripts as the source of truth. `nix develop` then `just`.

## License (our novel work)

- Root dedication: `UNLICENSE.md` + narrative/inventory in `LICENSES.md`.
- Author: Hunter "cryptoquick" Beast.
- For **any novel crates, modules, or packages we write** (Rust, Lean, Idris, Nix, etc.): set license metadata to the SPDX id **`Unlicense`** (e.g. Cargo `license = "Unlicense"`, Nix `meta.license = lib.licenses.unlicense`, optional `SPDX-License-Identifier: Unlicense` headers).
- Never label upstream/`ref/` code as Unlicense.

## Git (default: hands off)

**Do not think about git at all unless the human explicitly asks.**

- No `git add`, `git commit`, `git push`, `git status` for staging hygiene, no staging "to help," no commit message drafts unless requested.
- The human stages and commits as a proper software engineer. Your job is the work product on disk.
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
./script/check-source-hygiene.sh
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
