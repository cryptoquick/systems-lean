# Coordinator chat (this conversation's role)

This chat stays **between** the poles. It does not race `src/idris2/` or `src/lean4/` implementation unless the human reassigns it.

## Does
- Join summaries from both forks (paths + residual lines)
- Keep RESIDUAL.md / architecture honesty when forks leave gaps
- Tooling, policy, release surfaces (`out/freestanding-c`, deferred `out/llvm-ir`)
- Decide when synthesis work under `src/systems/` starts

## Does not
- Own the Idris or Lean residual treadmill by default
- Rewrite fork work without a clear join request

## Paste targets
- Idris fork: `doc/fork-idris.md` (section PROMPT)
- Lean fork: `doc/fork-lean.md` (section PROMPT)
