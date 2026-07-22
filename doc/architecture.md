# Architecture

Design sketch for the meet-in-the-middle bridge and the **Slake** compiler.
**Status:** design documentation. Not an implementation claim.

Related: [goals.md](goals.md), [divergence.md](divergence.md), [vocabulary.md](vocabulary.md).
See also: [shared-ir-sketch.md](shared-ir-sketch.md) (shared intermediate-representation correspondence; design only).

---

## Meet-in-the-middle

```
     Idris 2                              Lean 4
  (QTT core, linear)                 (kernel, elab, proofs)
         \                                /
          \     correspondence maps      /
           \    (erasure, mult, trusted computing base)    /
            v                          v
         Shared core story  ->  later shared IR
                    |
                    v
         Slake compiler (Systems Lean host)
                    |
         +----------+-----------+
         v                      v
  CompCert-oriented C      LLVM IR
  (PROVABLY when earned)   (Rust ecosystem embed /
                            interop design bar)
```

### Sides

| Side | Role |
|------|------|
| **Idris 2** (`ref/Idris2`) | Native QTT, linear resources, TT/TTImp/compiler pipeline, RefC as C-ish path with RC residual |
| **Lean 4** (`ref/lean4`) | Kernel, elaborator, proof ecosystem; classic AOT is not freestanding |
| **Middle** | Shared core: multiplicities, erasure, linearity, extract honesty -- plain names |
| **Slake** | Compiler that implements the shared core and backends; written in Systems Lean |

### Consummation

The correspondence is consummated when Slake:

1. Accepts a surface that covers the useful cores of both sides (phased).
2. Type-checks under QTT + linear/affine discipline.
3. Emits freestanding products under dual residual honesty.
4. Targets CompCert-oriented C and LLVM IR with stated trusted computing bases.

Curry-Howard is operational: well-typed terms are programs and/or proofs; extract is how systems software is produced. **Backend trusted computing base and interop ABI are separate claims.**

---

## Layers (intended product shape)

| Layer | Responsibility | Now |
|-------|----------------|-----|
| Surface | Language(s) accepted by Slake (phased toward superset) | Design only |
| Core / IR | Shared typed core with multiplicities | Design sketch: [shared-ir-sketch.md](shared-ir-sketch.md); not implemented |
| Checks | Use/linearity/affine; fail-closed freestanding constraints | Design only |
| Host tooling | Proofs, elaborator services on full host | Design only |
| Product extract | Freestanding C / objects without managed Lean runtime | Design only |
| CompCert backend | Seal product C with real `ccomp` when earned | Design only |
| LLVM backend | IR for embed + Rust-ecosystem path | Design only |

Product sources for Slake will live in this repository (e.g. `src/` or `compiler/`) when implementation begins -- **not** under `ref/`.

---

## Backends

### CompCert-oriented C

- Emit ISO C suitable for CompCert acceptance where possible.
- **PROVABLY** means real resolved CompCert compiler + product matrix green -- never a weaker dogfood token sold as PROVABLY.
- Lean/Slake owns residual and certs on the product wire; CompCert owns C->asm for accepted translation units.

### LLVM IR

- Target efficient embed and interoperation with the Rust ecosystem.
- **Rust without classic FFI** (design bar): prefer LLVM-level / layout-compatible linking over hand-written `extern "C"` glue as the default story.
- Not claimed until a concrete ABI note and tests exist (see residual).

---

## Dual sides (forks)

| Side | Novel tree | Upstream ref |
|------|------------|--------------|
| Idris | `src/idris2/` | `ref/Idris2` |
| Lean | `src/lean4/` | `ref/lean4` |
| Synthesis | `src/systems/` (Slake / freestanding) | -- |

Keep **native Idris** and **native Lean** duals; map them. Do not collapse both sides into Lean-only models of Idris without an explicit goal change. Formal map theorems may later live on the Lean side once the informal map is honest.

## Isolation and references

| Path | Role |
|------|------|
| `ref/Idris2` | Upstream Idris 2 -- read-only reference |
| `ref/lean4` | Upstream Lean 4 -- read-only reference |
| `src/idris2/`, `src/lean4/`, `src/systems/` | Novel sides + freestanding synthesis |

Other residual mills are **not** part of the architecture diagram. This repository is Systems Lean; work here in isolation unless a human explicitly escalates.

---

## What is deliberately not designed yet

- Full surface syntax for the superset language
- Exact shared IR schema (correspondence sketch only: [shared-ir-sketch.md](shared-ir-sketch.md))
- Package manager / build driver story for Slake (orthogonal to the Lake-twin naming collision elsewhere)
- Verified concurrent runtime on the product residual
- Formal proof that extract preserves all observational behavior

These are residual / research topics, not silent assumptions.
