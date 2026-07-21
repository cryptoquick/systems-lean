# Divergence

Honest differences between poles of the meet-in-the-middle bridge.
The point of this document is to prevent false "they're the same" claims.

Related: [vocabulary.md](vocabulary.md), [architecture.md](architecture.md), [idris-entry.md](idris-entry.md), [lean-entry.md](lean-entry.md).

---

## Erasure and multiplicity

| Concern | Idris 2 | Lean 4 (classic) | Systems Lean / Slake goal |
|---------|---------|------------------|---------------------------|
| Erasure model | Multiplicity **0** on binders; quantities visible in types/holes | **Prop** vs **Type**; proof erasure; not full Idris-style 0/1/omega on every binder | QTT **0 / 1 / omega** first-class on freestanding path |
| Linearity | Multiplicity **1** + linear libraries + LinearCheck | No full Idris-style linear core | Linear/affine checks on product-relevant resources |
| Unrestricted | Unrestricted quantity (omega-class) | Ordinary runtime values under RC | Multiplicity **omega** for ordinary data |

**Imperfect edges (expected):**

- Lean `Prop` erasure is not identical to Idris multiplicity `0` in all cases.
- "Same algorithm in both languages" does not imply the same runtime residual.
- A correspondence table is progressive work -- document known mismatches; do not paper over them.

---

## Runtime and product wire

| Path | Runtime on the wire | Honest residual |
|------|---------------------|-----------------|
| Idris **RefC** | C + reference-counting support | Managed RC remains in TCB |
| Idris Scheme backends | Scheme runtime | Not freestanding bare metal |
| Classic Lean **AOT** | Lean object runtime / shared libs | Managed runtime remains in TCB |
| **Freestanding** product goal | No Lean managed runtime on product wire | Host elaborator may still use managed runtime until residual is **earned** |

**Never claim** that RefC or classic Lean AOT is freestanding.

---

## Compiler architecture shapes

### Idris 2 (high level)

Source -> desugar -> TTImp elaboration -> core **TT** (multiplicities) -> linear check -> compile (case trees / ANF / VMCode) -> backend (Chez, Racket, Gambit, JS, RefC).

Entry: `ref/Idris2/docs/source/implementation/overview.rst`.

### Lean 4 (high level)

Source -> elaborator -> kernel-checked environment -> AOT / interpreter; Lake for packages; optional classic LLVM work is not freestanding Systems product codegen by default.

Entry: `ref/lean4/README.md`, `ref/lean4/doc/`.

### Slake (intended)

Systems Lean host implements shared core checks + freestanding extract + CompCert and LLVM backends. Surface grows toward superset of both poles under progressive gates.

---

## Proof vs runtime split

| Tradition | Typical split |
|-----------|----------------|
| Idris | Programs and proofs share QTT; quantities decide runtime presence |
| Lean | Heavy proof ecosystem; extract/AOT still often carries runtime residual |
| Slake goal | Host proofs erased from product TCB; product wire freestanding; dual residual honesty |

---

## What "isomorphism" does *not* mean here

- Not "byte-identical compilers."
- Not "every Lean theorem is an Idris program and vice versa on day one."
- Not "marketing isomorphism" without a written map and tests.

It means a **deliberate correspondence** of core notions (types, proofs, multiplicities, extract) that both poles can meet, implemented and checked in Slake over time.

---

## Isolation note

This document compares **upstream refs** and **Systems Lean** goals. It does not require browsing residual mills in other trees. Keep divergence notes here.
