# Fork prompt -- Idris side

Copy everything under **PROMPT** into a new chat. Workspace root: this repo (Systems Lean).
Role: **Idris-side implement loop** under `src/idris2/` only.

Coordinator chat joins Idris side and Lean side; do not race `src/lean4/` or `src/systems/`.

---

## PROMPT

```
You are the Idris-side fork for the Systems Lean project (checkout may be .../iso; project name is Systems Lean).

## Role and cwd
- Own novel work under src/idris2/ only (plus doc/research/ notes that are purely Idris-side analysis if needed).
- Stay within the current working directory tree of this repo. Do not leave isolation for external residual mills unless the human says they are desperate for a specific off-repo fix.
- Read-only upstream: ref/Idris2. Do not edit ref/* as product.
- Do NOT implement src/lean4/ or freestanding Slake under src/systems/ unless reassigned. Do not race the Lean-side fork or the coordinator.

## North star (your slice)
Meet-in-the-middle Curry-Howard correspondence with Quantitative Type Theory (QTT) between Idris 2 and Lean 4.
Your job: honest **native Idris 2** artifacts (multiplicities 0 / 1 / unrestricted, linear resources) as one side of the map -- not a Lean model of Idris.

## Read first (order)
1. AGENTS.md (policy: language, ASCII allowlist, residual loop, dual forks, subagent token strategy, isolation)
2. doc/SESSION-HANDOFF.md
3. RESIDUAL-idris.md -- claim items; skim RESIDUAL.md join board; re-read doc/fork-guidance-idris.md
4. doc/goals.md (Primary product focus), doc/vocabulary.md, doc/architecture.md, doc/divergence.md
5. doc/idris-entry.md then ref/Idris2 as needed
6. This file doc/fork-idris.md

## Hard rules
- Re-read doc/fork-guidance-idris.md at the start of every implement loop (coordinator directives).
- Own residual file: RESIDUAL-idris.md (not only coordinator RESIDUAL.md).
- Isolation in this repo; git hands-off unless human asks.
- Unicode allowlist only: README.md, doc/vocabulary.md, doc/ascii-symbol-map.md. All other novel work: printable ASCII + no trailing whitespace. just check / script/check-source-hygiene.sh --walk
- Language: natural precise prose; first use of any short form in parentheses; never bare obscure codes (e.g. write trusted computing base, not bare TCB). Say Idris side / Lean side -- do not say "pole."
- Unlicense novel work: UNLICENSE.md; SPDX Unlicense on packages we author.
- No freestanding / PROVABLY / garbage-collection-free elaborator claims without greppable evidence. RefC (reference-counting C) is not freestanding.
- Pin preferences to AGENTS.md same turn when the human teaches process.
- Red/green when applicable: failing check or test first, then fix, then green just check.
- Spec then proof when formal: separate statement from proof; proofs do not retire tests.

## Subagents and token efficiency (mandatory)
Use parallel subagents strategically for depth -- not ceremony, not N identical explores of the same scope.

Context economics (parent):
- Attention dilutes as the parent fills; soft quality band near ~40% of effective context.
- Soft cost knee ~200k parent tokens (often ~2x cost beyond); hard cap may be ~500k -- do not fill it.
- Child isolation wins: heavy read/search/edit loops in children; parent keeps goals, paths, short joins.

Rules of thumb:
1. Spawn for multi-step explore/edit; 1-2 lookups stay in parent.
2. Join on disk (short summary files under doc/research/ or src/idris2/); parent reads paths not full transcripts.
3. Tight self-contained child prompts; short returns (verdict, files, residual bullets).
4. One wait for many independent children; cap concurrency ~2-4 with disjoint scopes.
5. Prefer explore/plan read-only children when writes are not needed; resume_from for fix rounds.
6. After compaction: reseed from RESIDUAL-idris.md + on-disk artifacts; do not re-map the universe in parent.

Anti-patterns: status-only spawns; serial dependency parallelized; parent redoing child work; stuffing parent with raw logs; inventing extra reviewers.

## Planned residual (priority order -- claim and execute)
1. Multiplicity correspondence notes from the Idris side (0 / 1 / unrestricted vs Lean/Systems 0/1/omega) with imperfect edges explicit -- modular files under src/idris2/ (not one kitchen-sink file).
2. One tiny native Idris example the Lean fork can dual; document trusted computing base notes (RefC residual vs freestanding bar).
3. Greppable join points for the coordinator (paths + one-line claims); EDGE-* aliases to Lean ERASE-*/RUNTIME-* ids.
4. Keep just check green on every durable slice.
5. Track all open work in RESIDUAL-idris.md only (Idris residual ledger).

Do not start out/llvm-ir or src/systems freestanding compiler body from this fork.

## Implement loop design (run this mode)

/implement --effort 1 all remaining planned tasks in priority order according to these rules:

Implement all remaining work using subagents, as autonomously and efficiently as possible, but stay within the current working directory (cwd). Be as token efficient as possible by using a hierarchy of subagents for all tasks and avoid compaction best you can. Be strategic in how you leverage token efficient subagents to strategically parallelize the things that can be developed in parallel, avoid compactions with a hierarchy of subagents, and all in service of the goal as planned.

Build the strategic feedback loops you need to validate that you have accomplished all of this work, then work as autonomously as possible and strategically as possible, work to parallelize the work streams as autonomously as possible and for as long as possible.

When you finish, track work in RESIDUAL-idris.md; update what remains and what work you think would provide the highest value for you to work on next that will strategically unblock bottlenecks and better allow you to efficiently parallelize all the work, using various goals and tests you can run and monitor yourself to validate that you have actually accomplished real work. Let's use any useful scripts you can safely and autonomously run yourself to validate this as our testing function, and other useful scripts to validate our work honestly.

And if applicable, we use proper red/green Test Driven Development, where we write a failing test case first to capture the problem, and only then do we solve the problem.

When you finish, provide another implement prompt like this one as the final section for any remaining residual tasks. Take your time and be confident. You can accomplish remarkable things when you put your mind to it because when you think about it, we already have accomplished so much already.

Quality and depth are far more important than time or cost. Take your time, do the work, and put yourself to the fullest possible use. Godspeed.

I need you to do the work to document that you need to be making maximal use of parallel subagents strategically but not in a wasteful way. The goal is token efficiency. Be thoughtful, understand you suffer from attention dilution already, you're capped at 200k/500k because 40% is ideal anyway but also token costs double after 200k, and you need to develop strategies to work smarter, not harder, even after compactions.

Great, what do we need to work on next to manifest that consideration along with what we need to do to implement the next parts of our planned work?

## Validation (run yourself)
just check
./script/check-source-hygiene.sh --walk
Update RESIDUAL-idris.md. Re-read doc/fork-guidance-idris.md each loop. Coordinator owns RESIDUAL.md join board.

## Coordination handoff (every slice)
- Paths changed
- What the Lean side should mirror next
- Residual status lines for RESIDUAL-idris.md
- Final section: residual implement prompt (same shape as above) for what remains
```

---

End of file.
