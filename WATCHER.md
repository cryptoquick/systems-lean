# Watcher (residual implement loop)

**What this is:** the greppable place Hunter's environment and agents use for the next autonomous implement pass.

**Not jargon:** a **watcher** here means "the fixed file + chat ending that always holds the next implement instructions," so a harness can pick them up without rereading the whole conversation.

## Contract

1. After every durable implement slice, agents **must** update the fenced block below (`WATCHER_BEGIN` / `WATCHER_END`) with the next implement prompt for remaining work (Name / Goal / Done when / Out of scope / Paths / Gates).
2. The **same** prompt text must appear as the **final section** of the agent's chat reply (so auto-continue can run it).
3. If blocked or ambiguous, set the block to a short **blocked** note (what is unclear) -- do not invent fake work. The fenced body must not contain the implement slash-command token (even as "do not auto-run ...") or the harness will re-queue it.
4. Scope stays in this repository. Git remains human-owned unless asked. No deferred tracks (`out/llvm-ir` before self-host).
5. Prefer freestanding Slake bootstrap Open Names from `RESIDUAL-systems.md`. Chain autonomously when Done when is checkable.

**Sessions:** this file is for the **watcher session** (auto-continue harness). Systems / Slake
implement work is a **different session** (`doc/fork-systems.md`, `RESIDUAL-systems.md`).
Do not treat the watcher session as the Slake implementor by default.

**Owner of next action:** after Systems residual slices, `WATCHER_BEGIN` holds the same
Systems next implement prompt as `RESIDUAL-systems.md` **Next residual implement prompt**
(reconcile if another session rewrote WATCHER for a different plan). Soft-concerns /
plan steps that are not Systems residual must not silently displace Systems next
without an explicit human pivot.

Validation the next pass should run when applicable:

```bash
just systems-host
just systems-emit-wire
just hygiene
./src/systems/check.sh
just check
```

Policy detail: `AGENTS.md` (residual implement loop, living residual work items,
subagent token efficiency).

---

WATCHER_BEGIN
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
WATCHER_END
