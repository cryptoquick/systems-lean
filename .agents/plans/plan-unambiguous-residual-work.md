# Plan: Unambiguous residual work (plain names, short loops)

ASCII only. Plan skill artifact. **No product implementation until the human
clearly approves in chat** (e.g. Approve / execute / go). Host modal dismiss is
not approval.

After approval, copy to workspace:
`.agents/plans/plan-unambiguous-residual-work.md`

---

## Context

### Why

Autonomous residual loops stalled for the right reason: the next action was
**ambiguous** ("human-directed product residual only when a real delta
exists") with no concrete accomplishment, no acceptance bar, and a Held list
that was mostly greppable token soup (HOST-*, SH*, EMIT_*, theorem name dumps).

That was honest about not inventing canary theorems. It was **not** a usable
work system. Separately, residual ledgers and self-host notes grew dense with
phase / track / stage identifiers that AGENTS.md already bans as product
vocabulary, then re-used them as the residual language of record.

You asked for:

1. Ambiguous work made **unambiguous**.
2. Structured planned accomplishment -- not "phase / track / wave" theater.
3. Concise, thoughtful **names** for what to achieve (jargon only when needed).
4. Loops OK when they do **useful** work on **short** timeframes.
5. Agreement that stopping on ambiguity was correct.

### Constraints (carry forward)

- Isolation: this repo only unless you escalate.
- Three novel languages: Idris 2, Lean 4 / Systems Lean, pure Nix. Freestanding C is **emit**, not a fourth source language.
- Dual residual honesty: product wire residual != host elaborator residual; never forge either free.
- No product garbage collection; min multiplicities 0 / 1 / omega only.
- No llvm unlock / CompCert PROVABLY forge; no agent git unless asked.
- Greppable honesty tokens **in Lean and pure Nix gates** stay where gates need them. This plan stops them from being the **residual prose language**.
- Hands-off inventing "next theorem canary" when no named product delta exists.

### Non-goals of this plan

- Claiming residual free, self-host complete, proof complete, or llvm unlocked.
- Bulk renaming every HOST-* marker inside `.lean` files as a docs mill.
- Replacing formal gate evidence with soft prose only.
- Designing the full self-host compiler in one plan document.

---

## Diagnosis (what broke unambiguity)

| Failure mode | Effect |
|--------------|--------|
| Residual = greppable archive | Open work buried under Done paragraphs and token lists |
| Next prompt = Held: TOKEN* inventory | Agents re-prove or re-list; no new product surface |
| "Human-directed product residual" | Anti-spec: sounds like a task, is not a task |
| Phase / track / SH / P-priority labels in living residual | Ephemeral map becomes vocabulary of record |
| Watcher body containing implement slash-command in prose | Auto-harness thrash (fixed once; keep the rule) |
| No "Done when" on open items | Effort-1 loops cannot self-close honestly |

**Correct stop:** no inventable theorem theater.
**Missing piece:** a living queue of **named accomplishments** with acceptance.

---

## Design: residual work item schema

Every **open** or **in progress** residual item uses this shape only:

| Field | Rule |
|-------|------|
| **Name** | 2-6 words. What you are building or closing. Not a stage id. Not "Phase 3". Prefer structural words already in the product (Mult, freestanding emit, ordered IR program, host compose). |
| **Goal** | One sentence: what changes in the world of the repo when this lands. |
| **Done when** | Bullet list of checkable outcomes (files, gates, behaviors). Prefer `just ...` / path existence / theorem family only when the theorem **proves a new property**, not a readiness re-list. |
| **Out of scope** | Explicit non-claims for this slice (e.g. no llvm, no grow probe C, no residual free claim). |
| **Primary paths** | 1-5 paths the implementer may touch. |
| **Status** | `open` / `in progress` / `done` / `blocked` / `deferred` / `wontfix` only. |

**Banned in Name / Goal / Done when (living residual):**

- wave, phase, track, lane, stream, epoch, mill, theater (as status words)
- SH0..SH6, P0..P7 as residual item names
- stacking greppable tokens as the work description (HOST-FOO + SLAKE_BAR + EMIT_BAZ)
- "human-directed product residual" without a named item

**Allowed:**

- Module and API names that already exist (`HostCompose`, `out/freestanding-c`)
- Gate recipe names (`just systems-host`)
- One greppable evidence token **in Done when** if a gate requires it, not as the item title

### Short-loop implement prompt (watcher + chat end)

When residual is clear:

```
/implement --effort 1 <Name>:
Goal: <one sentence>
Done when:
- <checkable>
- <checkable>
Out of scope: <non-claims>
Paths: <paths>
Gates: just systems-host; just systems-emit-wire; just hygiene; ./src/systems/check.sh
```

When residual is **not** clear:

```
BLOCKED -- no residual implement prompt active.
Need: <one concrete missing decision or name>.
Do not invent work.
```

(Blocked fence must not contain the implement slash-command token.)

Loops: one Name per implement pass when possible; if a Name is large, split into
**sequenced Names** (still plain English), not "Phase 1a of Track B".

---

## Living residual layout (Systems / Slake)

Rewrite `RESIDUAL-systems.md` into three human layers. Keep greppable history
compressed, not deleted from git history.

### 1. Open (living queue) -- only this drives implement

Short table, top of file after honesty pin:

| Name | Goal (one line) | Done when (summary) | Status |
|------|-----------------|---------------------|--------|
| ... | ... | ... | open |

Detail for each open item: Goal / Done when / Out of scope / Paths (schema above).

### 2. Deferred (held with reason)

Plain names + **why held** + **what unlocks** (not greppable soup).

Examples of deferred **names** (not residual-open mills):

| Name | Why held | Unlocks when |
|------|----------|--------------|
| LLVM IR emit | Deferred until freestanding self-host is real | True freestanding self-host acceptance met |
| CompCert product seal | Needs real resolved CompCert tool + matrix | Real `ccomp` available and product matrix defined |

### 3. Done (archive)

- Collapse today's multi-hundred-line Done table over time into **short** bullets:
  what capability landed + primary path.
- Greppable tokens may remain in **product Lean / Nix presence** and in a
  **single optional appendix** (`doc/systems-host-evidence-map.md` or similar)
  if humans still need grep maps -- not in every residual paragraph.
- Do not re-paste full theorem inventories into the join board.

### Coordinator join board (`RESIDUAL.md`)

- One line per systems open Name + status.
- No full token maps.
- Highest-value next = first open Name, or BLOCKED with one need.

### Watcher (`WATCHER.md`)

- Fenced body = exactly one implement prompt for the first open Name, **or** BLOCKED.
- Same text ends the agent reply when a slice closes.

### Policy pins (`AGENTS.md`)

- Living residual = schema above.
- Ephemeral ban already exists; extend: residual **open queue** may not use phase/track/wave/SH/P as item names.
- Blocked note harness-safe (already partially pinned).
- Agent must refuse invent work when Open is empty or only Deferred.

---

## Proposed open Names (product backlog, plain English)

These are the **real** freestanding / self-host gaps after host theorem depth
ran out. Order is priority for short autonomous loops. Refine Done when on
approval before first implement.

### 1. Host-owned freestanding emit

- **Goal:** More of the freestanding C release under `out/freestanding-c` is
  produced from Systems Lean host sources (fragments / SSOT already started for
  Mult and body), not from frozen hand templates alone.
- **Done when (first slice -- propose refine):** documented list of which
  product headers/bodies Lean owns vs still template; at least one additional
  non-Mult product surface owned the same way as Mult/body SSOT; `just
  out-freestanding-c` still green; no new residual-only C stage name mill;
  residual free still false.
- **Out of scope:** llvm; PROVABLY; claiming full self-host; growing probe C
  as product.
- **Paths:** `src/systems/SystemsLean/FreestandingEmit.lean`, `Emit*.lean`,
  `emit/`, `out/freestanding-c/` (generated), related docs.

### 2. Product wire matches host compose (honest partial)

- **Goal:** Where the host model already has compose / plan / apply / body
  behavior, the freestanding product APIs and tests stay consistent without
  forging full C parity claims.
- **Done when:** intentional PARTIAL list is short and current; any gap closed
  is named in Done when of a slice; behavioral tests still prove product APIs;
  no residual-free claim.
- **Out of scope:** full C rewrite; shell mill growth.

### 3. Self-host body (first real compiler step)

- **Goal:** A named freestanding compilation step that is more than readiness
  flags: Systems Lean host drives a **defined** input surface toward freestanding
  output (even if tiny), with acceptance written first.
- **Done when:** written acceptance in `src/systems/` (plain English); one
  end-to-end host path exercised under gates; complete-self-host flag still
  false until true criteria met.
- **Out of scope:** llvm unlock from partial progress; "kernel rebuilds kernel"
  canary re-lists.

### 4. Dual algorithms into Slake (read map, write systems)

- **Goal:** ConsumeToken / Erased / Share (or next dual join item) is **used**
  by Systems / Slake in a stated way, not only dual-cited.
- **Done when:** systems module + residual line states the map; dual trees
  remain read-only for this work.
- **Out of scope:** racing Idris/Lean residual; formal full bridge proof.

### 5. Thin process glue

- **Goal:** Remaining shell under systems is only what must invoke Lake / cc /
  drivers; static presence stays pure Nix.
- **Done when:** line-count / ownership note updated; no new static greps in
  shell; gates green.
- **Out of scope:** deleting behavioral C tests without replacement.

**Not open residual (deferred):** LLVM IR emit, CompCert product seal.

**Not open residual (exhausted as residual under current surface):** pure host
readiness canaries, definitional alias theorems, conjunct-only ProductPath
growth.

---

## Ambiguity protocol (agent + human)

```
Is the next Open item present with Name + Goal + Done when?
  no  -> BLOCKED: "Need: write or approve next Open Name (schema)."
         Do not invent theorems / C stages / git.
  yes -> Is Done when checkable this effort?
           no  -> split Name into smaller Names, or BLOCKED with one question
           yes -> write watcher implement prompt from schema; run short loop
```

After each successful slice:

1. Mark Name done (or partial with new smaller open Names).
2. Write next open Name's implement prompt into WATCHER (or BLOCKED).
3. Keep residual free / proof complete / llvm claims honest (false / held).

---

## Implementation steps (after approval)

| Step | Work | Owner after approval |
|------|------|----------------------|
| A | Write `.agents/plans/plan-unambiguous-residual-work.md` from this plan | implement session |
| B | Pin residual schema + banned residual vocabulary + blocked harness rule in `AGENTS.md` | implement |
| C | Restructure `RESIDUAL-systems.md`: Open / Deferred / Done (compress Done) | implement |
| D | Align `RESIDUAL.md` join board to Open Names only | implement |
| E | Align `WATCHER.md` to first Open Name implement prompt **or** keep BLOCKED until Open filled | implement |
| F | Light update `doc/fork-systems.md` + `src/systems/self-host.md` human prose: plain Names, stop SH* as living status voice (keep greppable appendix or leave markers in Lean only) | implement |
| G | Fill Open queue: refine Done when for Names 1-3 with paths and first-slice acceptance (no product code yet unless same pass is approved) | implement + human glance |
| H | First autonomous product loop only after Open #1 has tight Done when | later implement |

Effort: process-only pass is effort 1. Product Name #1 is a separate implement after Open is filled.

---

## Success criteria (this plan)

- Living residual answers "what do we do next?" with a **Name**, not a token dump.
- An implement pass can close without human mid-loop **when** Done when is checkable.
- When Done when is not checkable, residual is **BLOCKED** with one clear need -- not a fake queue.
- No new phase / track / wave / SH / P labels introduced as residual item names.
- Auto-continue does not thrash on blocked notes.
- Product honesty flags remain unforged.

## Risks

| Risk | Mitigation |
|------|------------|
| Compressing Done loses evidence | Keep gate tokens in Lean/Nix; optional evidence appendix; git history |
| Open Names too big for effort 1 | Split before implement; Done when must fit one short loop |
| Agents still invent theorem theater | Out of scope on every prompt; exhausted host canaries listed under Deferred/wontfix as residual |
| Self-host Name stays vague | Force written acceptance before first self-host body implement |

## Defaults (revise in freeform chat if wrong)

1. Process restructure lands **before** next freestanding product code loop.
2. First Open Name after restructure is **Host-owned freestanding emit** (tightened Done when on fill).
3. Historical greppable markers stay in product Lean / presence; residual prose uses plain Names.
4. Dual poles keep separate residual files; this plan's Open queue is Systems / Slake unless you reassign.

---

## What you approve

Approving this plan means: rewrite residual / watcher / agent policy to the
schema above, fill the Open queue with plain Names and Done when, and only
then resume autonomous implement loops. It does **not** unlock llvm, PROVABLY,
or residual free.

---

## Human review addendum (approved)

Once the human issues the first implement command and walks away:

1. **Maximum autonomy** within residual schema, non-claims, and isolation. Keep
   chaining short loops via WATCHER as long as Open has a Name with Done when.
2. **Focus:** bootstrap freestanding **Slake** (Lean host + freestanding emit
   path under `src/systems/`). Do not dilate into llvm, PROVABLY, dual races,
   or greppable theorem theater.
3. **Token efficiency:** parent orchestrates; subagents do depth. Use strategic
   subagents (they stay fresh context) but **not too many at once** (cap ~2-4,
   prefer 1 implementer + 1 reviewer at effort 1).
