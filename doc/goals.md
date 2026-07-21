# Goals

Canonical goals for **Systems Lean** and its **Slake** compiler.

Related: [vocabulary.md](vocabulary.md), [architecture.md](architecture.md), [divergence.md](divergence.md).

---

## One-sentence goal

**Slake** is a compiler, written in **Systems Lean**, that is a usable **superset** of the programming and proof capabilities of **Idris 2** and **Lean 4**, reached by a **meet-in-the-middle** correspondence (Curry-Howard + QTT), emitting **freestanding** products toward **CompCert-oriented C** and **LLVM IR**, with efficient **Rust ecosystem interop without classic FFI** as the happy-path design bar.

## Primary product focus (do not dilute)

Day-to-day work serves **Systems Lean** and the **Slake** compiler. The freestanding product bar is non-negotiable:

| Focus | Meaning |
|-------|---------|
| **Systems Lean** | Language + project: Lean 4 with linear/affine ownership and only the **minimum** Quantitative Type Theory multiplicities (**0** erased, **1** once, **omega** unrestricted) needed for freestanding work |
| **Slake** | Compiler written in Systems Lean that consummates the Idris/Lean meet-in-the-middle map |
| **Runtimeless freestanding C** | Primary emit: `out/freestanding-c` -- no managed Lean runtime, **no garbage collection** on the product wire |
| **Memory safety** | From types: linear/affine discipline and related checks -- not from a garbage collector |
| **LLVM / Rust path** | Real design bar, but **deferred** until self-hosted Systems Lean / Slake (`out/llvm-ir`) |

Bridge sides (`src/idris2/`, `src/lean4/`) exist to feed an honest map into Slake -- not as a substitute for freestanding product work.

---

## Why this exists

Idris 2 and Lean 4 both inhabit dependent type theory, but they do not share one product surface:

- Idris 2 puts **QTT multiplicities** and linear resources in the core language story.
- Lean 4 puts a production **kernel, elaborator, and proof ecosystem** first; classic AOT still carries a managed runtime.
- **Systems Lean** is our invention: Lean 4 plus linear/affine ownership and full QTT multiplicities, aimed at freestanding systems binaries.

**This repository is Systems Lean:** we document the bridge, keep agent hygiene honest, and implement the language and Slake **in isolation** -- using upstream trees only as **read-only references** under `ref/`.

---

## North-star goals

1. **Meet in the middle.** Map Idris 2 and Lean 4 toward a shared core (erasure, multiplicity, linearity, extract trusted computing base honesty). Consummate that core in Slake -- not a third fashion language.
2. **Superset surface (phased).** Cover the *useful cores* of both languages with progressive gates. Day-one full upstream parity is not required and not claimed.
3. **Minimum multiplicities only.** Quantitative Type Theory grades **0 / 1 / omega** -- only what freestanding Slake needs; no multiplicity zoo.
4. **Linear/affine memory safety.** Safety on the product wire comes from ownership discipline and checks, **not** garbage collection.
5. **Runtimeless freestanding C first.** Primary release surface `out/freestanding-c`. Dual residual honesty (product vs host elaborator).
6. **CompCert path.** C sealable with CompCert when PROVABLY is earned with a real resolved `ccomp`.
7. **LLVM / Rust path (later).** After self-host; layout-compatible link without classic foreign-function glue as the design bar -- not claimed early.
8. **Tooling in idiomatic Nix flakes.** New tools are named flake `checks` / `apps` / `devShells` + `just` recipes; not ad-hoc one-off scripts as the source of truth.
9. **Honesty ladder.** Every major claim has an evidence bar (below). Prefer greppable gates over prose.
10. **Theory and experiment.** Spec/proof separation for formal work **and** red/green tests -- both, like scientific method (hypothesis + experiment).

---

## Near-term goals (repo foundation)

1. Durable goals, vocabulary, architecture, and divergence docs (this tree).
2. Agent hygiene that survives compaction (`AGENTS.md`, session handoff, residual, research quarantine).
3. Complete read-only references: `ref/Idris2`, `ref/lean4`.
4. Isolation: all product work happens here unless a human explicitly escalates out of isolation.

---

## Honesty ladder

| Claim | Evidence bar |
|-------|----------------|
| QTT multiplicities supported | Binder mult + use-check + tests |
| Linear resources safe on product wire | Affine/use checks + residual gates |
| Freestanding product | No Lean managed-runtime residual on product nm/IR |
| GC-free / residual_free host elaborator | Measured residual; **never forge** |
| CompCert PROVABLY | Resolved real `ccomp` + full product matrix |
| Rust interop without classic FFI | Concrete ABI/embed design + tests |
| Superset of Idris 2 and Lean 4 | Explicit surface matrix + progressive gates |

Do not claim mathematical "isomorphism finished" until the correspondence is stated, imperfect edges documented, and progressive gates exist.

---

## Non-goals

- Day-one full Idris 2 or full Lean 4 compatibility
- Forging residual, PROVABLY, or host residual_free tokens
- Calendar ship dates as success criteria
- Replacing upstream Idris 2 or Lean 4 development
- Marketing "safer than Rust" without greppable gates
- Ephemeral wave language as permanent APIs or module names
- Racing or residual-chasing **external** Systems Lean trees by default
- Inventing a thesaurus of product brands for the same idea

---

## Isolation policy (normative)

| Do | Do not |
|----|--------|
| Implement Systems Lean / Slake work **in this repo** | Treat another tree as the default Systems Lean workplace |
| Read `ref/Idris2` and `ref/lean4` as upstream truth | Edit upstream under `ref/` as product |
| Pin process corrections into `AGENTS.md` / living docs | Rely on chat memory after compaction |
| Escalate off-repo **only** when the human says we are desperate for a specific solution | "Sync with sister tree" as routine process |

---

## Success for early phases

Early success is **honest documentation + agent discoverability + reference layout**, then small correspondence spikes. Compiler body and backends come after the foundation is greppable and residual is honest.
