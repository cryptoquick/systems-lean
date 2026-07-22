# Shared intermediate representation (IR) sketch

**Status:** product design note. Not an implementation claim.
**Owner:** coordinator. Feeds **Slake** under `src/systems/` later.
**ASCII only.** Related: [architecture.md](architecture.md), [divergence.md](divergence.md),
[vocabulary.md](vocabulary.md). Side maps: `src/idris2/multiplicity-map.md`,
`src/lean4/multiplicity-map.md`. Dual algorithm: **ConsumeToken** (JOIN-ALG).

This note names the shared core notions both language sides already document so
Slake can meet them in one compile path. It is a **working map**, not a formal
isomorphism theorem.

---

## Purpose

Idris side and Lean side duals are join-ready (MULT maps, JOIN files, greppable
edges in `doc/divergence.md`). The shared IR is the next honesty layer: a
common typed core story that Slake will implement, check, and later emit toward
runtimeless freestanding C.

Sides stop inventing new map residual unless real drift appears. Coordinator /
systems owns the consummation path.

---

## Shared notions to map

| Notion | IR intent | Greppable anchors |
|--------|-----------|-------------------|
| **Types** | Dependent types as the common universe; surface differences are elaborator residual, not product wire residual | Side JOIN tables; architecture "Core / IR" layer |
| **Multiplicities 0 / 1 / omega** | Only these three Quantitative Type Theory (QTT) grades on freestanding Slake | **MULT-0**, **MULT-1**, **MULT-OMEGA** |
| **Linear use** | Exact-once resources fail closed under use checks (product-relevant) | MULT-1; dual **JOIN-ALG** ConsumeToken |
| **Affine (at most once)** | Product talk includes affine; not first-class on Idris public grades | **EDGE-AFFINE** |
| **Erasure** | Compile-time-only values leave no runtime presence when honest | MULT-0; imperfect: **EDGE-PROP** / **ERASE-PROP** |
| **Extract / emit boundary** | Host elaborator / proofs vs product extract; dual residual honesty | **EDGE-RUNTIME** / **RUNTIME-CLASSIC**; product goal **RUNTIME-FS** |
| **Names for omega** | Same three-way shape; labels differ | **EDGE-NAME** (omega vs unrestricted / `RigW`) |

### Multiplicity row ids (must stay greppable)

| Id | Meaning on the shared core |
|----|----------------------------|
| MULT-0 | Erased / compile-time-only -- no product runtime presence when checks succeed |
| MULT-1 | Use-once / linear -- exact-once on product-relevant resources |
| MULT-OMEGA | Unrestricted / ordinary data -- copy, drop, reuse freely under ordinary rules |

Classic Lean duals of MULT-1 remain **sketches** until Systems Lean mult-1 checks
are the host. Idris already has LinearCheck for mult 1 on its side.

### Linear use and the dual algorithm

| Id | Role |
|----|------|
| JOIN-ALG | Algorithm id **ConsumeToken** -- same shape both sides |
| EX-CONSUME (Idris) | `src/idris2/examples/ConsumeToken.idr` -- native; LinearCheck surface; not freestanding |
| EX-CONSUME (Lean) | `src/lean4/examples/ConsumeToken.lean` -- classic Lean dual sketch; not freestanding |

IR later should be able to host a ConsumeToken-class program under mult-1
discipline without inventing a second dual example on the sides.

---

## Extract / emit boundary

Three runtime stories must stay distinct (see `doc/vocabulary.md`):

| Story | Trust base residual |
|-------|---------------------|
| Idris RefC (and stock Idris backends) | Generated C plus managed / reference-counting runtime |
| Classic Lean ahead-of-time (AOT) | Native code that still expects the managed Lean runtime |
| Freestanding product (goal) | No Lean managed runtime on the product wire |

**EDGE-RUNTIME** / **RUNTIME-CLASSIC** mark stock-host managed residual.
**RUNTIME-FS** is the freestanding product goal under `src/systems/` -- not
implemented by side forks.

Shared IR must track **which values survive emit** (mult omega and mult 1
resources that are not erased) versus **what is host-only** (proofs, mult 0,
elaborator services). Product residual and host elaborator residual are
independent claims.

---

## Honest imperfect edges (do not paper over)

Full tables live in `doc/divergence.md` section **Greppable imperfect edges
(dual pair)**. IR sketch inherits them:

| Id(s) | Honesty |
|-------|---------|
| EDGE-PROP / ERASE-PROP | Lean `Prop` erasure is **not** the same mechanism as Idris quantity 0. Working map with exceptions, not isomorphism of erasure. |
| EDGE-RUNTIME / RUNTIME-CLASSIC | Stock hosts leave managed runtime in the trusted computing base. Dual examples are not freestanding product C. |
| EDGE-CLASSIC-LEAN (overloaded) | **Not one clean 1:1 alias.** Senses: (1) classic Lean binder-algebra gap vs Idris 0/1/omega; (2) partial alias toward **RUNTIME-FS** product goal (Idris map); (3) Lean co-name with RUNTIME-CLASSIC. Cite both families; do not compress to one pairing. |
| EDGE-NAME | Join docs say **omega**; Idris users say **unrestricted** / compiler `RigW`. Same three-way shape, different labels. |
| EDGE-AFFINE | Systems Lean product includes affine (at most once). Idris public grades are 0 / exact-once 1 / unrestricted -- no first-class affine quantity. |

These edges are **inputs** to IR design (fail-closed checks, explicit mults,
separate product vs host residual gates). They are not fixed by this note alone.

---

## What this feeds in `src/systems/` / Slake

Intended compile path (design only -- not claimed implemented):

```
 surface (phased)
      |
      v
 shared typed core / IR   <-- this sketch names the core
   (types, mult 0/1/omega, linear/affine use, erasure)
      |
      v
 checks (use / linearity / freestanding constraints, fail closed)
      |
      v
 product extract  -->  later freestanding C (out/freestanding-c)
      |                      CompCert seal only when PROVABLY earned
      +-->  deferred: LLVM IR (out/llvm-ir) after self-host
```

| Later systems work | Relation to this sketch |
|--------------------|-------------------------|
| Slake skeleton under `src/systems/` | **Done (layout):** types / mult / linear / erasure / extract stubs |
| Min mult host notes / checks | MULT-0 / MULT-1 / MULT-OMEGA greppable in `src/systems/mult.md` |
| Freestanding unit surface | **Done (abstract):** five modules `UNIT_SURFACE`; still not residual free |
| Unit deepen + first translation | **Done (UNIT_DEEPEN_V1):** abstract contracts + C APIs (`slake_mult_is_valid`, `slake_linear_consume`, `slake_erasure_is_runtime_absent`); still not residual free |
| Real compile path (structure) | **Done:** `SLAKE_COMPILE_PATH_V0` via `script/slake-compile-path.sh`; still not product C |
| Real emit + `out/freestanding-c` | **Done (V0 + UNIT_DEEPEN_V1 body):** `SLAKE_EMIT_FREESTANDING_C_V0` via `script/slake-emit-freestanding-c.sh`; first unit translation; not residual free |
| Typed IR product surface | **Done (TYPED_IR_V0):** single-node `slake_ir_node` kind/mult pairing + fail-closed compose; still not residual free |
| ordered IR program | **Done (IR_PROGRAM_V0):** ordered multi-node `slake_ir_program` (`SLAKE_IR_PROGRAM_CAP` 8) + collective well-typed/fail-closed (empty NOT well-typed; full push -2); still not residual free |
| IR graph edges | **Done (IR_GRAPH_EDGES_V0):** `slake_ir_graph` shell + directed index pairs (`SLAKE_IR_EDGE_MAX` 16); empty graph OK; not full CFG/SSA; still not residual free |
| Host compose | **Done (HOST_COMPOSE_V0):** `slake_host_compose` joins CONSUME_TOKEN_HOST_V0 + IR_GRAPH_EDGES_V0 for fail-closed extract; thin call-throughs; not full CFG/SSA; still not residual free |
| Emit plan | **Done (EMIT_PLAN_V0):** `slake_emit_plan` readiness inventory from checked host compose (node/edge/runtime/erased counts); not CFG/SSA; still not residual free |
| Emit apply | **Done (EMIT_APPLY_V0):** `slake_emit_apply` fixed mult/kind tag buffer from checked host compose (`SLAKE_EMIT_APPLY_CAP` 32); not full C body emit; not CFG/SSA; still not residual free |
| Emit body | **Done (EMIT_BODY_V0):** `slake_emit_body` fixed freestanding C body fragment from checked host compose via plan+apply (`SLAKE_EMIT_BODY_CAP` 256); not full module emit; not CFG/SSA; still not residual free |
| `just build` / `out/freestanding-c` | Build = compile-path structure; release = `just out-freestanding-c` (emit install) |

No second dual example is required on the Idris or Lean sides for the skeleton.

---

## Explicit non-claims

This note does **not** claim:

- Freestanding product residual free (UNIT_DEEPEN_V1 first translation is not residual free)
- Full checker / ConsumeToken-class freestanding host body
- `out/llvm-ir` pipeline (deferred until self-hosted Systems Lean / Slake)
- CompCert **PROVABLY** (needs real resolved `ccomp` + product matrix)
- Formal isomorphism theorem of Idris and Lean cores
- Permission for side forks to invent freestanding body under `src/systems/`
- A second ConsumeToken-class dual (Hold unless human asks)

---

## Evidence and next residual

| Done | Evidence |
|------|----------|
| Dual MULT maps | `src/idris2/multiplicity-map.md`, `src/lean4/multiplicity-map.md` |
| ConsumeToken dual (JOIN-ALG) | side `examples/ConsumeToken.*` + both JOIN.md |
| Greppable edges | `doc/divergence.md` (EDGE-* / ERASE-* / RUNTIME-* / MULT-* / JOIN-ALG) |
| This IR sketch | `doc/shared-ir-sketch.md` |
| Emit V0 surface | `script/slake-emit-freestanding-c.sh` (`SLAKE_EMIT_FREESTANDING_C_V0`); `out/freestanding-c/*.c` |
| UNIT_DEEPEN_V1 + first translation | `src/systems/*.{slake,md}` markers; C APIs in emit/ |
| TYPED_IR_V0 + IR_PROGRAM_V0 + IR_GRAPH_EDGES_V0 | single-node + multi-node ordered program node list + edge slots in emit; Types unit map |
| HOST_COMPOSE_V0 | host+graph fail-closed extract compose in emit; Extract/Linear/Types unit map |
| EMIT_PLAN_V0 | emit plan readiness inventory from host compose; Extract primary + Types light map |
| EMIT_APPLY_V0 | fixed mult/kind tag serialisation from host compose; Extract primary + Types light map |
| EMIT_BODY_V0 | freestanding C body fragment from host compose via plan+apply; Extract primary + Types light map |

**Next high-value residual (systems fork):** further **emit quality** / deeper IR
only as needed (full freestanding C module codegen of arbitrary IR still residual);
no residual free forge; no llvm-ir; quality over speed.

Compile-path evidence: `script/slake-compile-path.sh` stage id `SLAKE_COMPILE_PATH_V0`;
wired from `just build`; check fails closed if driver missing. Emit evidence:
`script/slake-emit-freestanding-c.sh` stage id `SLAKE_EMIT_FREESTANDING_C_V0`; `just out-freestanding-c`
install; UNIT_DEEPEN_V1 first unit translation + IR_PROGRAM_V0 + IR_GRAPH_EDGES_V0
+ HOST_COMPOSE_V0 + EMIT_PLAN_V0 + EMIT_APPLY_V0 + EMIT_BODY_V0 landed.
