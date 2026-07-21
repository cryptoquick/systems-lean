# Watcher (residual implement loop)

**What this is:** the greppable place Hunter's environment and agents use for the next autonomous implement pass.

**Not jargon:** a **watcher** here means "the fixed file + chat ending that always holds the next implement instructions," so a harness can pick them up without rereading the whole conversation.

## Contract

1. After every durable implement slice, agents **must** update the fenced block below (`WATCHER_BEGIN` ... `WATCHER_END`) with the next `/implement` prompt for remaining work.
2. The **same** prompt text must appear as the **final section** of the agent's chat reply (so auto-continue can run it).
3. If blocked or ambiguous, set the block to a short **blocked** note (what is unclear) -- do not invent fake work.
4. Scope stays in this repository. Git remains human-owned unless asked. No deferred tracks (`out/llvm-ir` before self-host).

Validation the next pass should run when applicable:

```bash
just check
./script/check-source-hygiene.sh --walk
```

Policy detail: `AGENTS.md` (residual implement loop, subagent token efficiency).

---

WATCHER_BEGIN
```
/implement --effort 1 highest-value residual: shared intermediate-representation (IR) correspondence sketch (token-efficient subagents; parent soft ~40% context / ~200k cost knee).

Scope: coordinator. Dual pair (MULT maps, ConsumeToken, JOIN files, greppable edges in doc/divergence.md) is done -- do not invent a second dual.

1. Write a durable IR correspondence sketch that both Idris side and Lean side can meet later in Slake. Prefer a short product note under doc/ (extend architecture or a focused doc/*-ir*.md) OR research under doc/research/ with header Kind: analysis only. Not residual. if still exploratory.
2. Content bar: name the shared notions to map (types, multiplicities 0/1/omega, linear use, erasure, extract/emit boundary); cite dual-pair greppable ids from doc/divergence.md; list imperfect edges honestly; state what feeds src/systems/ Slake later.
3. Hard non-claims: no freestanding C emit yet; no out/llvm-ir; no PROVABLY CompCert; no formal isomorphism theorem; no freestanding residual free.
4. Do not start freestanding Slake body under src/systems/ beyond optional README-only pointer if needed. Prefer doc/ first.
5. Validate: just check; ./script/check-source-hygiene.sh --walk. Update RESIDUAL.md (IR sketch done vs next open). Rewrite this WATCHER block and end the chat reply with the same next implement prompt.

Do not: git commit, invent second ConsumeToken dual, forge freestanding/PROVABLY claims.
Quality over speed. Godspeed.
```
WATCHER_END
