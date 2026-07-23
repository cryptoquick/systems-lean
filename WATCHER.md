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
DONE-FOR-NOW (Open queue empty)

Thin process glue complete:
- Remaining novel shell is process glue only (Lake / cc / drivers /
  compile-path stamp). Static presence is pure Nix.
- Ownership note: src/systems/README.md (Shell ownership table + line counts).
- script/slake-compile-path.sh is stamp only (no UNIT_SURFACE greps).

Still false / deferred (do not forge):
- residual free
- freestanding product self-host complete
- proof complete
- PROVABLY
- llvm IR emit / CompCert product seal

Do not invent Open Names. Human names next residual when ready.
```
WATCHER_END
