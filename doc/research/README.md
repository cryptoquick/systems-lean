# Research notes

**Kind of directory:** fork / analysis only.

Notes here survive compaction. They do **not** automatically become residual implementation work.

## Rules

1. Every research note starts with a header:

   ```markdown
   # Title

   **Kind:** fork research (analysis only). Not residual implementation work.
   **Date:** YYYY-MM-DD
   **Audience:** ...
   ```

2. Do **not** invent residual tracker items from a research note unless the human asks.
3. Prefer plain English. Define technical terms once; no ephemeral wave vocabulary as the main language.
4. Primary implementor may ignore research notes unless stuck on correspondence / TCB honesty.

## What belongs here

- Correspondence deep-dives (Idris vs Lean erasure edges)
- Backend TCB essays
- "What someone claimed on the internet vs what upstream actually is"
- Design alternatives rejected with reasons

## What does not

- Living residual ("do this next") -- that is `RESIDUAL.md`
- Process corrections for all agents -- that is `AGENTS.md`
- Canonical goals -- that is `doc/goals.md`
