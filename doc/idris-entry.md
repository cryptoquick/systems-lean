# Idris 2 entry map

Read-only upstream: `ref/Idris2/`.
Do not edit upstream as product source.

---

## Start here

| Purpose | Path |
|---------|------|
| Clone overview / install | `ref/Idris2/README.md` |
| **Compiler architecture** (TT, QTT, layers) | `ref/Idris2/docs/source/implementation/overview.rst` |
| Implementation index | `ref/Idris2/docs/source/implementation/index.rst` |
| QTT / multiplicities / erasure (user story) | `ref/Idris2/docs/source/updates/updates.rst` |
| Multiplicities tutorial | `ref/Idris2/docs/source/tutorial/multiplicities.rst` |
| Backends overview | `ref/Idris2/docs/source/backends/index.rst` |
| **RefC / C codegen** (RC residual) | `ref/Idris2/docs/source/backends/refc.rst` |
| Custom backend cookbook | `ref/Idris2/docs/source/backends/backend-cookbook.rst` |
| Docs root | `ref/Idris2/docs/source/index.rst` |

Published HTML mirrors the Sphinx tree: https://idris2.readthedocs.io/en/latest/

---

## Source landmarks

| Area | Path |
|------|------|
| Core TT | `ref/Idris2/src/Core/` (especially TT + LinearCheck) |
| TTImp | `ref/Idris2/src/TTImp/` |
| Compiler / backends | `ref/Idris2/src/Compiler/` |
| RefC compiler | `ref/Idris2/src/Compiler/RefC/` |
| RefC C support | `ref/Idris2/support/refc/` |
| Multiplicity algebra | `ref/Idris2/src/Algebra/` |
| Linear libs | `ref/Idris2/libs/linear/` |

---

## Pipeline (plain English)

**source -> desugar -> TTImp elab -> core TT (with multiplicities) -> linear check -> compile expr -> backend**

Default production backend is Chez Scheme. **RefC** is the C path; it is **not** freestanding bare metal -- reference counting remains in the trust base. See [divergence.md](divergence.md).

---

## What Systems Lean uses this for

- Correspondence for QTT and linear resources
- Honest TCB comparison vs freestanding product goals
- Later: dual examples and surface matrix items

Not for forking Idris 2 development inside this repo.
