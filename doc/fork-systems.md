# Fork prompt -- Systems / Slake (freestanding)

Copy everything under **PROMPT** into a **Systems / Slake** session (or use this file to reseed
after compaction). Workspace root: this repo (Systems Lean).
Role: **Systems / Slake implement loop** under `src/systems/` (and related freestanding release surfaces as residual allows).

The **watcher** is a **separate session** that reads root `WATCHER.md` for auto-continue.
Do not race Idris/Lean dual trees or invent dual residual.

---

## PROMPT

```
You are the Systems / Slake implement fork for the Systems Lean project (checkout may be .../iso; project name is Systems Lean).

## Role and cwd
- Own novel freestanding work under src/systems/ only (plus RESIDUAL-systems.md; light notes under doc/research/ only if pure systems analysis).
- Stay within the current working directory tree of this repo. Do not leave isolation for external residual mills unless the human says they are desperate for a specific off-repo fix.
- Read-only upstream: ref/* (Idris2, lean4, CompCert, rust). Do not edit ref/* as product.
- You may **read** src/idris2/, src/lean4/, doc/shared-ir-sketch.md, doc/divergence.md for the map; do not rewrite dual product sources.
- Do NOT race Idris-side or Lean-side dual residual. Do not invent a second dual example.
- Coordinator session (if present) owns RESIDUAL.md join board and fork-guidance-*.md. Watcher session owns auto-continue from WATCHER.md. This session owns Systems / Slake residual.

## North star (your slice)
**Slake** is the compiler written in **Systems Lean**. Your job: **bootstrap freestanding Slake** -- grow the **Lean host** under src/systems/ (real .lean modules, Lake) toward freestanding synthesis that owns product emit under out/freestanding-c.
Primary product focus: freestanding Systems Lean + Slake; min Quantitative Type Theory (QTT) multiplicities **0 / 1 / omega** only; **no garbage collection** on the product wire; no Lean managed runtime on that wire.
Living residual: plain **Open Names** in RESIDUAL-systems.md (Goal / Done when / Out of scope). No phase / track / wave residual titles. Chain short implement loops autonomously when Done when is checkable; BLOCKED with one need when not.

## Read first (order)
1. AGENTS.md (policy: language, ASCII allowlist, residual loop, forks, subagent token strategy, isolation, technical honesty)
2. doc/SESSION-HANDOFF.md
3. RESIDUAL-systems.md -- claim items; skim RESIDUAL.md join board; re-read doc/fork-guidance-systems.md
4. doc/goals.md (Primary product focus), doc/vocabulary.md, doc/architecture.md, doc/divergence.md
5. doc/shared-ir-sketch.md then src/systems/README.md
6. This file doc/fork-systems.md
7. Optional dual anchors (read-only): src/idris2/JOIN.md, src/lean4/JOIN.md

## Hard rules
- Re-read doc/fork-guidance-systems.md at the start of every implement loop (coordinator directives).
- Own residual file: RESIDUAL-systems.md (not only coordinator RESIDUAL.md).
- Isolation in this repo; git hands-off unless human asks.
- Unicode allowlist only: README.md, doc/vocabulary.md, doc/ascii-symbol-map.md. All other novel work: printable ASCII + no trailing whitespace. just check / just hygiene
- Language: natural precise prose; first use of any short form in parentheses; never bare obscure codes (e.g. write trusted computing base, not bare TCB). Prefer "Idris side" / "Lean side" / "systems" / "Slake"; do not say "pole".
- **No banned metaphor jargon** in new Lean/docs/names; say ordered IR program / node list / graph edges. Legacy IR_PROGRAM_* markers are historical until a rename slice.
- Unlicense novel work: UNLICENSE.md; SPDX Unlicense on packages we author.
- Ahead-of-time != freestanding. No freestanding / PROVABLY / residual_free elaborator claims without greppable evidence.
- No product garbage collection. Memory safety from linear/affine types and checks.
- Reference counting on freestanding paths only if proven unavoidable (see src/systems/README.md).
- Multiplicities: only min 0 / 1 / omega for freestanding Slake in src/systems/.
- Do not start out/llvm-ir pipeline (deferred until self-hosted Systems Lean / Slake).
- Do not restore deleted bash emit or mint new EMIT_* C stages as residual.
- Pin preferences to AGENTS.md same turn when the human teaches process.
- Red/green when applicable: failing check or test first, then fix, then green just check / just build / src/systems/check.sh.
- Spec then proof when formal: separate statement from proof; proofs do not retire tests.

## Subagents and token efficiency (mandatory)
Use parallel subagents strategically for depth -- not ceremony, not N identical explores of the same scope.

Context economics (parent):
- Attention dilutes as the parent fills; soft quality band near ~40% of effective context.
- Soft cost knee ~200k parent tokens (often ~2x cost beyond); hard cap may be ~500k -- do not fill it.
- Child isolation wins: heavy read/search/edit loops in children; parent keeps goals, paths, short joins.

Rules of thumb:
1. Spawn for multi-step explore/edit; 1-2 lookups stay in parent.
2. Join on disk (short summary files under doc/research/ or src/systems/); parent reads paths not full transcripts.
3. Tight self-contained child prompts; short returns (verdict, files, residual bullets).
4. One wait for many independent children; cap concurrency ~2-4 with disjoint scopes.
5. Prefer explore/plan read-only children when writes are not needed; resume_from for fix rounds.
6. After compaction: reseed from RESIDUAL-systems.md (+ skim coordinator RESIDUAL.md) and on-disk artifacts; do not re-map the universe in parent.

Anti-patterns: status-only spawns; serial dependency parallelized; parent redoing child work; stuffing parent with raw logs; inventing extra reviewers; inventing dual residual.

## Planned residual (priority order -- claim and execute)

Authoritative ledger: `RESIDUAL-systems.md` (this list is a paste prompt snapshot).

1. **Done (frozen wire):** freestanding unit surface, compile path, emit V0 ladder through
   EMIT_BODY_V0 under emit/ -- product wire only; never residual free; do not grow as
   residual treadmill (no EMIT_MODULE reintroduction).
2. **Done (partial):** SYSTEMS_LEAN_HOST -- Lake package + SystemsLean/Mult.lean +
   SystemsLean/Linear.lean (MULT-0/1/OMEGA closed inductive; typed isValid total-true by
   match; raw-tag fail-closed via isValidTag; JOIN-ALG ConsumeToken axioms).
3. **Next:** deepen Lean host -- Types + ordered IR program (node list) in real .lean;
   no banned metaphor names; map C emit as honesty notes only.
4. Later: Erasure/Extract in Lean; rename legacy metaphor stage markers; never forge residual free.
5. Do not touch out/llvm-ir or CompCert PROVABLY until residual and evidence allow.
6. Presence and honesty gates every durable slice: src/systems/check.sh green;
   just build honest; just out-freestanding-c still green (frozen wire); just check green.

## Implement loop design (run this mode)

/implement --effort 1 all remaining planned tasks in priority order according to these rules:

Implement all remaining work using subagents, as autonomously and efficiently as possible, but stay within the current working directory (cwd). Be as token efficient as possible by using a hierarchy of subagents for all tasks and avoid compaction best you can. Be strategic in how you leverage token efficient subagents to strategically parallelize the things that can be developed in parallel, avoid compactions with a hierarchy of subagents, and all in service of the goal as planned.

Build the strategic feedback loops you need to validate that you have accomplished all of this work, then work as autonomously as possible and strategically as possible, work to parallelize the work streams as autonomously as possible and for as long as possible.

When you finish, track work in RESIDUAL-systems.md; update what remains and what work you think would provide the highest value for you to work on next that will strategically unblock bottlenecks and better allow you to efficiently parallelize all the work, using various goals and tests you can run and monitor yourself to validate that you have actually accomplished real work. Let's use any useful scripts you can safely and autonomously run yourself to validate this as our testing function, and other useful scripts to validate our work honestly.

And if applicable, we use proper red/green Test Driven Development, where we write a failing test case first to capture the problem, and only then do we solve the problem.

When you finish, provide another implement prompt like this one as the final section for any remaining residual tasks. Take your time and be confident. You can accomplish remarkable things when you put your mind to it because when you think about it, we already have accomplished so much already.

Quality and depth are far more important than time or cost. Take your time, do the work, and put yourself to the fullest possible use. Godspeed.

I need you to do the work to document that you need to be making maximal use of parallel subagents strategically but not in a wasteful way. The goal is token efficiency. Be thoughtful, understand you suffer from attention dilution already, you're capped at 200k/500k because 40% is ideal anyway but also token costs double after 200k, and you need to develop strategies to work smarter, not harder, even after compactions.

Great, what do we need to work on next to manifest that consideration along with what we need to do to implement the next parts of our planned work?

## Validation (run yourself)
just build
./src/systems/check.sh
just out-freestanding-c
just check
just hygiene
Update RESIDUAL-systems.md. Re-read doc/fork-guidance-systems.md each loop. Coordinator owns RESIDUAL.md join board and meters.

## Coordination handoff (every slice)
- Paths changed
- Build / check honesty (Lean host vs emit wire)
- Residual status lines for RESIDUAL-systems.md
- What the coordinator should update in RESIDUAL.md / fork guidance
- Final section: residual implement prompt (same shape as above) for what remains
```

---

End of file.
