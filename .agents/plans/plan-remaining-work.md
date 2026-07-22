# Plan: Remaining work (Systems Lean)

ASCII only. Status snapshot after Mult..ProductPath host ladder (31 modules).

## North star (one line)

Slake compiles Systems Lean to freestanding C with no classic Lean runtime on
the product wire. That claim is not true yet.

## Where we stand (done enough)

| Area | State |
|------|--------|
| Idris duals (3 algorithms) | Done for this fork; hold unless named map gap |
| Lean duals (3 algorithms) | Done for this fork; formal theorems deferred |
| Freestanding C product wire | Frozen at EMIT_BODY_V0 (except host-owned Mult + body fragment text) |
| Systems Lean host ladder | Partial through ProductPath (Mult..ProductPath, 31 modules) |
| Self-host track SH0..SH5 | Partial readiness / parity / self-apply canaries only |
| SH6 llvm / PROVABLY | Held documented (unlock flags false) |
| Pure Nix presence gates | Host + emit-wire + jargon |
| Residual shell check.sh | ~228 lines process-only (Lake optional + drivers + smoke) |
| Residual free / product self-host complete | Not claimed |

## What is still left

### A. Human / process (not agent residual)

| # | Work | Why |
|---|------|-----|
| A1 | Stage and commit novel paths | Flake only sees tracked files; live `just systems-host` / `systems-emit-wire` can be green while flake is not |
| A2 | After stage: `nix flake check` | Same gates as live just recipes |

### B. Bridge sides (Idris / Lean forks)

| # | Work | When |
|---|------|------|
| B1 | New dual examples | Only for a named map gap that needs a new algorithm id on both sides |
| B2 | Formal map theorems in Lean (L-FORMAL-ISO) | Only if you prioritize proofs over product self-host |
| B3 | Coordinator join | Divergence imperfect edges already merged history; do not invent dual work |

Default: **blocked / hold** on both bridge forks.

### C. Systems / Slake -- the real remaining product work

Everything below is still open in substance even when host "ready" flags are true.
Readiness canaries are not self-host and not residual free.

| # | Work | Honesty bar |
|---|------|-------------|
| C1 | **Real freestanding self-host** | Compiler body that lowers a stated kernel and emits freestanding product C without classic Lean runtime on the wire. Flip `freestandingProductSelfHostComplete` only with evidence. |
| C2 | **Close intentional PARTIAL gaps that block C1** | Host List/String vs product C arrays; host codegen readiness vs full product emit; join/matrix canaries vs formal duals -- only as needed for C1, not module theater |
| C3 | **Freestanding residual free** | Product residual closed with evidence; host elaborator residual stays separate |
| C4 | **CompCert PROVABLY** | Real `ccomp` + evidence matrix; never forge |
| C5 | **`out/llvm-ir` + Rust-native link** | Only after true freestanding product self-host |

Order: **C1 before C2-as-blocker, then C3, then C4, then C5.**

### D. Optional polish (none required)

| # | Work | When |
|---|------|------|
| D1 | Thin proofs over existing host contracts | Formal feedback without new surface |
| D2 | Further shell shrink | Port remaining process carefully; do not grow bash |
| D3 | Named host deepen | Only if you name a greppable gap (missing API, RED gate) |

### E. Explicitly not residual

- New EMIT_* freestanding C stages
- Re-growing check.sh presence mills
- Dual LOC padding without map gaps
- Claiming residual free, product complete, PROVABLY, or llvm unlock without evidence
- Auto-deepen for its own sake (readiness mill without product delta)

## Recommended path

1. **Human:** stage/commit so flake matches live gates (A1--A2) when convenient.
2. **Hold** invent loops on duals and frozen C wire.
3. **Next major product slice:** design and implement **real freestanding self-host (C1)** -- separate from canary modules that already land as partial.
4. After C1 with evidence: residual free (C3), then PROVABLY (C4), then llvm-ir (C5).

Default if you name nothing new: **hold product invent**; keep gates green; do not grow the host ladder for theater.

## Risks

| Risk | Mitigation |
|------|------------|
| More Bool readiness modules instead of real compiler body | C1 acceptance in self-host.md; complete flag stays false until evidence |
| Treating smoke LOC or C wire growth as language progress | Product wire frozen; smoke under smoke/ |
| Early PROVABLY / llvm | SH6 hold gate + residual Hold tables |
| Flake green while worktree untracked | Human stage; impure just gates for local |

## Verification (current bar)

```bash
just systems-host
just systems-emit-wire
just hygiene
./src/systems/check.sh
# after human stage:
# nix flake check
```

## Open questions

1. Prefer **git stage first**, or a **self-host design** slice next?
2. Any **named gap** that should force near-term host deepen (else hold invent)?
3. Care about **formal dual theorems** before self-host, or after?

## Summary

Bridge duals and the Systems Lean host readiness ladder (through product path)
are partial-done. C emit is frozen. Presence is pure Nix. Shell is thin.
**Left in substance:** human git for flake; optional polish only if chosen;
then real freestanding self-host, residual free, CompCert PROVABLY, and
llvm-ir -- in that order. **Not left as useful residual:** more canary modules
or C stages without a product delta.
