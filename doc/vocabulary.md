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
| **Curry-Howard** | Programs and proofs inhabit a typed universe; extract makes that correspondence pay rent as systems software. Extract correctness remains a separate claim |
| **QTT** | Quantitative Type Theory: binder multiplicities **0** (erased), **1** (use once), **omega** (unrestricted) |
| **Linear / affine** | Exact-once or at-most-once resource discipline on product-relevant values |
| **Freestanding** | Closed subset + fail-closed codegen + **no** managed Lean object runtime on the product wire |
| **Host** | Full Lean-style toolchain (tactics, proofs, managed runtime) used for proofs and tooling only |
| **Dual residual honesty** | Product residual and host elaborator residual are independent; never forge either; never conflate them |
| **CompCert path** | Emit C suitable for CompCert (`ccomp`) when PROVABLY is earned with a real resolved compiler |
| **LLVM path** | Emit LLVM IR for efficient embed and Rust-ecosystem interop |
| **Rust without classic FFI** | Design bar: happy path is layout-compatible / IR-level interop, not hand-written `extern "C"` glue as the default story |
| **ref/** | Read-only upstream submodules (`ref/Idris2`, `ref/lean4`, `ref/CompCert`, `ref/rust`) -- not product source |
| **CompCert / ccomp** | Verified C compiler reference; product C path may target it; PROVABLY only with real resolved evidence |
| **Rust layout reference** | `ref/rust` (rustc_abi / codegen) defines layout-compatible interop; LLVM IR alone is not enough |
| **iso** | Optional **directory / checkout nickname** only (e.g. path `.../iso`). Not the product name. Prefer **Systems Lean** in prose |
| **src/idris2/** | Novel Idris pole workspace (isomorphism); not `ref/Idris2` |
| **src/lean4/** | Novel Lean 4 pole workspace; not `ref/lean4` |
| **src/systems/** | Freestanding Systems Lean + Slake host; min 0/1/omega; no product GC (garbage collection) |
| **out/freestanding-c/** | Runtimeless freestanding product C for external consumers |
| **out/llvm-ir/** | LLVM IR for Rust-native link; **deferred** until self-hosted Systems Lean / Slake |
| **RC necessity** | Freestanding RC (reference counting) only if proven unavoidable vs linear/affine/arena design |

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

## ASCII

Novel work: ASCII only. Map: `doc/ascii-symbol-map.md`. Enforce: `AGENTS.md` (ASCII + Nix).
