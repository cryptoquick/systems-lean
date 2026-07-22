# Watcher (residual implement loop)

**What this is:** the greppable place Hunter's environment and agents use for the next autonomous implement pass.

**Not jargon:** a **watcher** here means "the fixed file + chat ending that always holds the next implement instructions," so a harness can pick them up without rereading the whole conversation.

## Contract

1. After every durable implement slice, agents **must** update the fenced block below (`WATCHER_BEGIN` / `WATCHER_END`) with the next `/implement` prompt for remaining work.
2. The **same** prompt text must appear as the **final section** of the agent's chat reply (so auto-continue can run it).
3. If blocked or ambiguous, set the block to a short **blocked** note (what is unclear) -- do not invent fake work.
4. Scope stays in this repository. Git remains human-owned unless asked. No deferred tracks (`out/llvm-ir` before self-host).

**Sessions:** this file is for the **watcher session** (auto-continue harness). Systems / Slake
implement work is a **different session** (`doc/fork-systems.md`, `RESIDUAL-systems.md`).
Do not treat the watcher session as the Slake implementor by default.

Validation the next pass should run when applicable:

```bash
just systems-host
just systems-emit-wire
just hygiene
./src/systems/check.sh
just check
```

Policy detail: `AGENTS.md` (residual implement loop, subagent token efficiency).

---

WATCHER_BEGIN
```
/implement --effort 1 Systems Lean under src/systems/ ONLY Lean (+ pure Nix if tooling):
SH0..SH5 partial + SH5 freestanding deepen + Mult..Emit freestanding parity +
SH6 hold + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH
(ProductPath.productPathReady; residualFreeClaimed false; Mult..ProductPath 31
modules) landed. Next: further honest freestanding product path deepen without
forging residual free / product complete / llvm unlock; no new EMIT_* C stage;
no grow check.sh; no PROVABLY; no git; no dual race. Gates: just systems-host;
just systems-emit-wire; just hygiene; ./src/systems/check.sh.
```
WATCHER_END
