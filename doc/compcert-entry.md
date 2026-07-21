# CompCert entry map

Read-only upstream: `ref/CompCert/`.
Do not edit upstream as product source.

**Role for Systems Lean:** CompCert-oriented C backend path -- real `ccomp` when built; PROVABLY only with resolved compiler + product matrix evidence. Weaker "we ran something named ccomp once" is not PROVABLY.

---

## Start here

| Purpose | Path |
|---------|------|
| Overview / install | `ref/CompCert/README.md` |
| Manual / usage | `ref/CompCert/doc/` (when present) |
| Configure / build | `ref/CompCert/configure`, `ref/CompCert/Makefile` |
| Driver sources | `ref/CompCert/driver/` |
| C frontend / compiler passes | under `ref/CompCert/` (cfrontend, backend, ...) |

---

## Honest residual

| Claim | Meaning |
|-------|---------|
| CompCert path designed | Docs/architecture mention C for CompCert |
| `ccomp` built and resolved in-tree | Real binary available under a known path |
| **PROVABLY** | Resolved `ccomp` + full product matrix + residual honesty -- **not claimed yet** |

Building CompCert is optional for foundation docs; required before PROVABLY claims.

---

## What Systems Lean uses this for

- Backend trusted computing base honesty for the CompCert-oriented C path
- Later: seal freestanding product C with real `ccomp`

Not for shipping CompCert as a product of this repo.
