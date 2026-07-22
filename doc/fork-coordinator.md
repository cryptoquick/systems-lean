# Coordinator role (optional separate session)

Paste or assign when a chat is the **join / advisory** session -- not the Systems / Slake
implement session, and not the watcher session.

## Does
- Join summaries from forks (paths + residual lines + their next implement prompts)
- Keep coordinator `RESIDUAL.md` honest; forks own their residual files
- Steer forks via `doc/fork-guidance-idris.md`, `doc/fork-guidance-lean.md`,
  `doc/fork-guidance-systems.md` (Latest directive)
- May run `just progress` / `just watch` for meters; read `doc/PROGRESS.md`
- Policy, tooling, honesty of release surfaces (`out/freestanding-c`, deferred `out/llvm-ir`)
- Advise what is unblocked vs held; do not invent residual for parked duals

## Does not
- Own the Idris, Lean, or Systems residual treadmill by default
- Replace the **watcher** session (that session owns auto-continue from `WATCHER.md`)
- Race freestanding units under `src/systems/` while a Systems / Slake session is active

## Related paste targets
- Idris fork: `doc/fork-idris.md` (PROMPT)
- Lean fork: `doc/fork-lean.md` (PROMPT)
- Systems / Slake fork: `doc/fork-systems.md` (PROMPT)
- Watcher contract: root `WATCHER.md`

## Residuals

| File | Owner |
|------|--------|
| `RESIDUAL-idris.md` | Idris-side fork |
| `RESIDUAL-lean.md` | Lean-side fork |
| `RESIDUAL-systems.md` | Systems / Slake fork |
| `RESIDUAL.md` | Coordinator join board |

## Watch / progress (tooling, any session)

```bash
just progress          # pure Nix meters -> doc/PROGRESS.md
just progress-scc      # meters + scc line-count appendix
just hygiene           # pure Nix ASCII / trailing-whitespace walk
just watch             # every 300s: progress-scc + hygiene
```

`just watch` is a **progress tool**, not the watcher residual-implement session.

**Three languages only:** Idris 2, Lean 4 (including Systems Lean / Slake), pure Nix
flakes. No project Python. Do not grow shell; residual `.sh` is debt. No bash-in-Nix.
Policy: `AGENTS.md` (Three languages only + Nix tooling).
