# Coordinator chat (this conversation's role)

This chat stays **between** the Idris side and the Lean side. It does not race `src/idris2/` or `src/lean4/` implementation unless the human reassigns it.

## Does
- Join summaries from both forks (paths + residual lines + their residual implement prompts)
- Keep coordinator `RESIDUAL.md` honest; each side owns `RESIDUAL-idris.md` / `RESIDUAL-lean.md`
- Steer forks via `doc/fork-guidance-idris.md` and `doc/fork-guidance-lean.md` (Latest directive)
- Run `just progress` / `just watch` (300s) while forks run; read `doc/PROGRESS.md`
- Tooling, policy, release surfaces (`out/freestanding-c`, deferred `out/llvm-ir`)
- Decide when synthesis work under `src/systems/` starts
- Enforce token-efficient subagent posture in joins (no parent re-mapping either side)

## Does not
- Own the Idris or Lean residual treadmill by default
- Rewrite fork work without a clear join request

## Paste targets
- Idris fork: `doc/fork-idris.md` (section PROMPT -- includes implement loop)
- Lean fork: `doc/fork-lean.md` (section PROMPT -- includes implement loop)

## Watch / progress

```bash
just progress          # one-shot meter -> doc/PROGRESS.md
just watch             # every 300s (WATCH_INTERVAL=60 to speed up)
```

## Next high-value join

1. Both sides have multiplicity notes + ConsumeToken dual + JOIN files (see meter).
2. Coordinator merges imperfect edges into `doc/divergence.md` without freestanding claims.
3. Only then consider `src/systems/` skeleton for Slake (still not LLVM pipeline).
