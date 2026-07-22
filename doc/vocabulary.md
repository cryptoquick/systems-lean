# Vocabulary

Stable terms for **Systems Lean**. Prefer plain English. Do not invent fashion names, wave codes, or ephemeral labels as permanent product language.

**Agents:** natural precise prose; avoid jargon soup; expand short forms on use (see `AGENTS.md` -- Language).

**Systems Lean** is the **project name** and the **language** (see below).
**Slake**, in this repository, means the **compiler** unless explicitly qualified.

---

## Product terms

| Term | Meaning |
|------|---------|
| **Systems Lean** | **This project.** Also the language: Lean 4 with linear/affine ownership and QTT multiplicities **0 / 1 / omega**, aimed at freestanding systems products. Implemented **in this repository**, in isolation |
| **Slake** | The **compiler** product of Systems Lean: usable superset surface of Idris 2 and Lean 4 cores; freestanding backends |
| **Meet-in-the-middle** | Build correspondence from Idris 2 and Lean 4 toward a shared core, then consummate it in the Slake compiler -- not a third mystery language full of brands |
| **Idris side / Lean side** | The two ends of the bridge: novel work under `src/idris2/` and `src/lean4/`. Prefer this wording; do not say "pole" |
| **Curry-Howard** | Programs and proofs inhabit a typed universe; extract makes that correspondence pay rent as systems software. Extract correctness remains a separate claim |
| **QTT** | Quantitative Type Theory: binder multiplicities **0** (erased), **1** (use once), **omega** (unrestricted) |
| **Linear / affine** | Exact-once or at-most-once resource discipline on product-relevant values |
| **Freestanding** | Closed subset + fail-closed codegen + **no** managed Lean object runtime on the product wire (see **wire** below) |
| **Host** | Full Lean-style toolchain (tactics, proofs, managed runtime) used for proofs and tooling only |
| **Wire / product wire** | The **release surface** Slake emits for consumers -- mainly freestanding C under `emit/` and `out/freestanding-c/`. Not electrical jargon; not "network wire." When we say contracts on the wire, we mean the emitted product, not the host elaborator. Distinct from **flake wire-up** (connecting Nix modules in `flake.nix`) |
| **Model (host / formal)** | A **structural or formal representation** of grades, IR, checks, or contracts in Lean (or in docs). **Not** a machine-learning or AI model. Prefer "host representation," "contract surface," or "structural model" when ambiguity is possible |
| **Dual residual honesty** | Product residual and host elaborator residual are independent; never forge either; never conflate them |
| **CompCert path** | Emit C suitable for CompCert (`ccomp`) when PROVABLY is earned with a real resolved compiler |
| **LLVM path** | Emit LLVM IR for efficient embed and Rust-ecosystem interop |
| **Rust without classic FFI** | Design bar: happy path is layout-compatible / IR-level interop, not hand-written `extern "C"` glue as the default story |
| **ref/** | Read-only upstream submodules (`ref/Idris2`, `ref/lean4`, `ref/CompCert`, `ref/rust`) -- not product source |
| **CompCert / ccomp** | Verified C compiler reference; product C path may target it; PROVABLY only with real resolved evidence |
| **Rust layout reference** | `ref/rust` (rustc_abi / codegen) defines layout-compatible interop; LLVM IR alone is not enough |
| **iso** | Optional **directory / checkout nickname** only (e.g. path `.../iso`). Not the product name. Prefer **Systems Lean** in prose |
| **src/idris2/** | Novel Idris-side workspace (isomorphism); not `ref/Idris2` |
| **src/lean4/** | Novel Lean-side workspace; not `ref/lean4` |
| **src/systems/** | Freestanding Systems Lean + Slake host; min 0/1/omega; no product GC (garbage collection) |
| **out/freestanding-c/** | Runtimeless freestanding product C for external consumers |
| **out/llvm-ir/** | LLVM IR for Rust-native link; **deferred** until self-hosted Systems Lean / Slake |
| **RC necessity** | Freestanding RC (reference counting) only if proven unavoidable vs linear/affine/arena design |

---

## Three languages only (novel work)

Full policy: `AGENTS.md` section **Three languages only**.

| Language | Where | For |
|----------|-------|-----|
| **Idris 2** | `src/idris2/` | Idris-side bridge work |
| **Lean 4** | `src/lean4/`, `src/systems/` | Lean-side bridge + Systems Lean / Slake product |
| **Nix (flakes)** | `nix/`, thin `flake.nix` | Pure project tooling (gates, meters, checks) |

**Not novel implementation languages:** Python; shell/bash (except shrinking migration debt); bash/shell/Python embedded inside Nix; freestanding C (that is **emit output**, not source language for the project); Markdown (prose only).

**justfile:** thin task runner only -- orchestration, not a fourth product language.

---

## Tooling terms (repo infrastructure -- not product language)

Policy and mistake history: `AGENTS.md` (Three languages only + Nix tooling).

| Term | Meaning |
|------|---------|
| **Nix** | Language for reproducible builds and pure project tooling in this repo |
| **Flake** | Nix project entrypoint (`flake.nix` + lock); exports named checks, packages, shells |
| **Pure Nix tooling** | Tool logic as Nix that evaluates to a result (text, pass/fail). Not a shell or Python program living inside the flake |
| **Bash-in-Nix** (also shell-in-Nix, Python-in-Nix) | Anti-pattern: long scripts embedded via `writeShellApplication` / `runCommand` (or similar), sold as flake tooling. Forbidden |
| **Project Python** | Anti-pattern: novel `*.py` in this repo. Forbidden |
| **Shell migration debt** | Existing `.sh` under `script/` or workspace `check.sh` that still runs product build/emit/gates. Shrink and port; do not grow; not a template |
| **just / justfile** | Thin task runner (`just check`, `just progress`). Orchestration only |
| **Orchestration** | Gluing steps: write `doc/PROGRESS.md`, sleep between watch cycles, invoke residual debt scripts |
| **elan** | Lean toolchain manager in the flake **devShell**. Install the pin from `src/systems/lean-toolchain` / `src/lean4/lean-toolchain` (`leanprover/lean4:v4.32.0`). Do not default to lagged `pkgs.lean4` as the elaborator. Workspace checks skip Lake when the pin is not installed (no surprise network download). |
| **idris2 (devShell)** | Idris 2 elaborator package in the flake **devShell** for bridge-side checks. Residual `src/idris2/check.sh` still skips when the binary is absent. |
| **ripgrep (`rg`)** | Default code search in the flake **devShell**. Agents and humans search with `rg`. Pure Nix checks must not shell out to ripgrep for policy algorithms. |
| **Source hygiene** | Gate: novel text ASCII-clean (allowlist exceptions), no trailing whitespace. Pure Nix: `nix/source-hygiene.nix` |
| **Progress meters** | Evidence-weighted report `doc/PROGRESS.md` from pure Nix `nix/progress/` |
| **Novel source** | Our editable tree -- excludes upstream `ref/`, git metadata, caches |
| **scc** | External line-count tool for optional appendix only (`just progress-scc`) |
| **LLM-friendly modules** | Small, single-concern files with stable names so large language model agents stay within attention limits after compaction |

---

## Three runtime stories (never conflate)

| Path | What is still in the trust base |
|------|----------------------------------|
| Idris **RefC** | Generated C **plus** a reference-counting runtime |
| Classic Lean **AOT** | Native code that still expects the managed Lean runtime |
| **Freestanding** (Systems Lean product goal) | **No** Lean managed runtime on the product wire; host tools may still use one until earned residual_free |

---

## Naming hygiene

### Ephemeral (plans, research, chat only)

- Wave numbers, session labels, plan phase ids (`plan:draft`, `impl:...`)
- `REQ-*` matrix tokens, temporary branch nicknames
- Fashion code names for "the next residual pack"

### Stable (source, permanent docs, CLI)

- Module paths, gate names, greppable honesty tokens
- **Systems Lean**, **Slake**, **freestanding**, **QTT**, submodule paths
- Upstream symbols when citing refs (`Core.TT`, Lean kernel names)

### Slake disambiguation

Elsewhere, "Slake" has also been used for a **Lake twin build driver**. That usage is **out of scope** for this repository.

| Phrase | Meaning here |
|--------|----------------|
| **Slake** | The Systems Lean **compiler** (default) |
| **Lake twin / build driver** | Not this project's product; do not divert residual work to that story |

---

## Isolation

Work on **Systems Lean** and **Slake** **in this repository**, against `ref/*` as read-only references.

Do **not** treat other trees as the default workplace for Systems Lean residual unless the human is **absolutely desperate** for a specific solution and says so. Isolation is the default. This repo **is** the project.

## Encoding

This file may use Unicode. Most other novel paths must be ASCII (map: `doc/ascii-symbol-map.md`). See `AGENTS.md`.

| Prefer full phrase | Avoid bare short form |
|--------------------|------------------------|
| trusted computing base | TCB |
| Quantitative Type Theory | QTT without expansion on first use |
| garbage collection | GC without expansion on first use |
