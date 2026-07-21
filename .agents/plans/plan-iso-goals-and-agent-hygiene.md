# Plan: iso -- meet-in-the-middle bridge, Slake compiler, agent hygiene

**Workspace:** `/home/hunter/Projects/ai/iso`
**Date:** 2026-07-21
**Status:** approved and implemented (foundation docs)
**Amendment (user review):** avoid external Systems Lean trees -- work **in isolation** unless the human is absolutely desperate for a specific off-repo solution.
**After approval:** durable documentation + agent pins only (no compiler body yet)

This is the real project charter plan -- not a sketch for later. Everything below is intended to land on disk in iso so humans and agents can reseed after compaction without inventing jargon or racing the wrong tree.

---

## 1. What we are building

### One-sentence goal

**Slake** is a compiler, written in **Systems Lean**, that is a usable **superset** of the programming and proof capabilities of **Idris 2** and **Lean 4**, reached by a **meet-in-the-middle** correspondence (Curry-Howard + QTT), and that emits **freestanding** binaries targeting **CompCert-oriented C** and **LLVM IR**, with efficient **Rust ecosystem interop without classic FFI** as the happy-path design bar.

### Meet-in-the-middle (operational meaning)

| Pole | What we take seriously |
|------|-------------------------|
| **Idris 2** | Native **QTT** (multiplicities 0 / 1 / unrestricted), linear resources, core TT + LinearCheck, RefC as *closest* C path (still RC -- honest residual) |
| **Lean 4** | Production kernel/elaborator, proof culture, Mathlib-scale ecosystem; classic AOT still **managed-runtime** residual |
| **Systems Lean** (sister tree) | Lean 4 **plus** linear/affine ownership + QTT 0/1/omega + **freestanding** extract (no Lean object runtime on product wire) + CompCert dogfood/PROVABLY machinery |
| **Middle** | Shared core story: erasure, multiplicity, linearity, extract TCB honesty -- maps both poles can target; **not** a third fashion language |
| **Consummation** | Compiler binary **Slake** that typechecks under that core and pays rent with freestanding products |

Curry-Howard is not a slogan here: programs and proofs inhabit a typed universe under QTT; extract is how that correspondence becomes systems software. **Extract correctness, backend TCB, and interop ABI remain separate claims** with separate evidence.

### Why this repo (`iso`) exists

| This repo owns | Sister tree owns (`/home/hunter/Projects/cryptoquick/lean4`) |
|----------------|--------------------------------------------------------------|
| Cross-language vision, goals, non-claims | Freestanding codegen, UseCheck, AffineCheck, EmitC residual |
| Idris2 <-> Lean / Systems correspondence | PRODUCT_STDLIB, SCORE / systems-validate, systems.nix |
| Agent hygiene + compaction survival for *this* product | Lake twin driver currently named Slake (`src/slake/`) |
| Later: bridge IR, prototypes, **Slake compiler** sources | CompCert pin / PROVABLY vs DOGFOOD honesty |

**Hard rule:** do **not** fork or race the Systems Lean residual treadmill into this repo. Cite it. Build on it. Do not re-implement SCORE gates here.

---

## 2. Stable vocabulary (no ephemeral rename games)

| Term | Plain meaning | Do not confuse with |
|------|---------------|---------------------|
| **Systems Lean** | Lean 4 configured for systems: freestanding extract, linear/affine, QTT 0/1/omega | "Just another Lean dialect name of the week" |
| **Freestanding** | Closed subset + fail-closed codegen + **no** Lean managed runtime on the **product** wire | Classic Lean AOT; Idris RefC (still RC) |
| **Host** | Full Lean (tactics, Prop, RC) for proofs and tooling | Product embed TCB |
| **Dual residual honesty** | Product residual-free and host elaborator residual are **independent**; never forge either | Single greppable "we're residual-free" marketing |
| **QTT** | Multiplicities **0** (erased), **1** (once), **omega** (unrestricted) | Prop-only erasure story without linearity |
| **Slake (compiler)** | **This project's north-star product** -- the compiler written in Systems Lean | -- |
| **Slake (Lake twin)** | In cryptoquick lean4: freestanding-oriented **build driver** twin of Lake | The compiler |
| **CompCert path** | Product C + optional real `ccomp`; PROVABLY only with resolved in-tree ccomp | COMPCERT_DOGFOOD (weaker) |
| **LLVM path** | LLVM IR for embed + Rust ecosystem interop | Claiming LLVM is already Systems product codegen today (it is not in the sister tree) |
| **ref/** | Read-only upstream submodules | Product source |

### Naming resolution (normative for iso)

1. In **iso**, **Slake** means the **compiler** unless explicitly qualified.
2. When referring to cryptoquick's driver, write **Slake (Lake twin)** every time both appear.
3. Prefer plain English over new brands. No thesaurus product names, no wave/`REQ-*` as public API language.
4. Optional later: umbrella family ("Slake compiler" + "Slake build") -- still two surfaces in prose.

---

## 3. Goals and non-goals

### North-star goals

1. **Superset surface (phased):** programming + proof capabilities covering the *useful cores* of Idris 2 and Lean 4 -- progressive matrix, not day-one full upstream parity.
2. **QTT + linear/affine first-class** in the compiler's type system and checks.
3. **Implementation language:** Systems Lean (stronger typed host for this effort).
4. **Freestanding products:** no Lean object runtime on the embed wire; dual residual reporting always honest.
5. **Backends:** CompCert-oriented C (PROVABLY when earned) and LLVM IR (Rust embed/interop design bar).
6. **Rust without classic FFI:** design bar for the happy path -- concrete ABI/embed story required before claiming; not a slogan.
7. **Honesty ladder:** every major claim has an evidence bar (see section5).

### Near-term goals (this implementation pass)

1. Durable project docs on disk (goals, vocabulary, architecture, divergence).
2. Agent hygiene (`AGENTS.md`, session handoff, residual, research quarantine).
3. Reference layout complete (`ref/Idris2` + `ref/lean4` -- **both present now**).
4. Clear sister-tree relationship so agents do not invent work in the wrong place.

### Explicit non-goals

- Implementing full Slake compiler body in the first docs pass
- Day-one full Idris2 or full Lean4 compatibility
- Forging residual / PROVABLY / GC-free elaborator tokens
- Forking Systems Lean residual waves into `RESIDUAL.md` here
- Calendar ship dates
- Replacing Idris2 or Lean4 upstream development
- Marketing "safer than Rust" without greppable gates
- Ephemeral wave language as permanent module/CLI names

---

## 4. Technical architecture (design now; implement later)

```
     Idris 2                              Lean 4
  (QTT core, linear)                 (kernel, elab, proofs)
         \                                /
          \     correspondence maps      /
           \    (erasure, mult, TCB)    /
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

### Three runtime/TCB stories (must stay distinct in docs)

| Path | Residual honesty |
|------|------------------|
| Idris **RefC** | C + **reference-counting** runtime still in TCB |
| Classic Lean **AOT** | Managed Lean runtime (`libleanshared` / RC objects) still in TCB |
| Systems **freestanding** | **No** Lean managed runtime on product wire; host elaborator still classic until earned |

### First spikes after docs (residual items, not this pass's code)

1. Multiplicity correspondence table (Idris 0/1/omega <-> Systems Lean 0/1/omega <-> Lean Prop/runtime erasure) with **known imperfect edges** written down.
2. Tiny dual examples (same algorithm in Idris2 + Lean/Systems) with TCB notes.
3. Shared IR sketch (on disk under `doc/` or `doc/research/` until product code lands).
4. LLVM + Rust interop design note (what "without FFI" means in one concrete ABI proposal).

---

## 5. Honesty ladder (claims need evidence)

| Claim | Evidence bar |
|-------|----------------|
| QTT multiplicities supported | Binder mult + use-check + tests |
| Linear resources on product wire | Affine/use checks + residual gates |
| Freestanding product | No Lean RC/shared residual on product nm/IR |
| GC-free elaborator | Measured host residual =1; **never forge** |
| CompCert PROVABLY | Resolved in-tree `ccomp` + full product matrix |
| Rust interop without FFI | Concrete ABI/embed design + tests |
| Superset of Idris2 and Lean4 | Explicit surface matrix + progressive gates |

---

## 6. Agent hygiene (must be discoverable after compaction)

### Discovery order (reseed)

1. `AGENTS.md`
2. `doc/SESSION-HANDOFF.md`
3. `RESIDUAL.md`
4. `doc/goals.md` + `doc/vocabulary.md` if goal unclear
5. Sister Systems Lean docs **only** when freestanding/host residual is in scope

### Rules to pin in `AGENTS.md`

| Rule | Source pattern |
|------|----------------|
| Multi-chat: research fork vs primary implementor; ask once if unclear | `~/.grok/AGENTS.md` |
| Pin process corrections same turn to durable docs | global + project |
| Identifier hygiene: ephemeral (waves, `REQ-*`, plan phase ids) vs stable (modules, gates, vocabulary) | VeriK1 AGENTS |
| Research under `doc/research/` with header "analysis only / not residual" | Systems research notes |
| `ref/` is read-only upstream | iso-specific |
| Dual residual honesty; three runtime stories never conflated | Systems Lean |
| Do not race cryptoquick lean4 residual without explicit scope | iso-specific |
| Subagents: artifact-first join; parent soft ~40% / ~200k budget | global subagent strategy |
| GPG-signed commits only; never unsigned workarounds | global |
| Success = verification defined for this repo (docs links + submodule status; later real tests) | project |

### What agents must not do

- Invent ephemeral product brands or wave-speak as permanent vocabulary
- Treat Idris RefC or classic Lean AOT as freestanding
- Dump research into residual as free implementation backlog
- Claim Slake (compiler) work when only Lake-twin residual was in scope
- Bypass GPG signing

---

## 7. Durable tree to create (implementation)

```
/home/hunter/Projects/ai/iso/
  AGENTS.md
  README.md
  RESIDUAL.md
  .gitignore              # exists
  .gitmodules             # exists (Idris2 + lean4)
  .agents/plans/          # may keep a copy of this plan
  doc/
    goals.md
    vocabulary.md
    architecture.md
    divergence.md
    SESSION-HANDOFF.md
    idris-entry.md
    lean-entry.md
    research/
      README.md
  ref/
    Idris2/               # submodule -- complete
    lean4/                # submodule -- complete (0e8a9eba...)
```

### File responsibilities

| File | Contents |
|------|----------|
| `README.md` | Human north star; links goals + sister tree; no residual dump |
| `AGENTS.md` | Discovery order, hygiene, honesty, multi-chat, git, wrong-tree ban |
| `doc/goals.md` | Full goals, non-goals, honesty ladder, relationship to Systems Lean |
| `doc/vocabulary.md` | Stable terms; **Slake disambiguation table** |
| `doc/architecture.md` | Meet-in-middle diagram; backends; design vs implemented |
| `doc/divergence.md` | Erasure models; three TCB stories; imperfect map edges |
| `doc/idris-entry.md` | Short map into `ref/Idris2` (overview, QTT, RefC paths) |
| `doc/lean-entry.md` | Map into `ref/lean4` + pointer to Systems Lean sister absolute paths |
| `doc/SESSION-HANDOFF.md` | Role, one-liner goal, residual top 3, key paths, verify commands |
| `RESIDUAL.md` | **Short** living residual for **this repo only** |
| `doc/research/README.md` | Fork-only policy |

Optional later (not this pass): cross-link "See also iso" from cryptoquick `doc/dev/` -- **only if user approves sister-tree edit**.

---

## 8. Current workspace facts

| Item | State |
|------|--------|
| Git | Initialized on `main`; **no commits yet** |
| Staged | `.gitignore`, `.gitmodules`, `ref/Idris2`, `ref/lean4` |
| Untracked | `.agents/` (includes earlier plan copy) |
| `ref/Idris2` | Complete @ `870fcdb81` |
| `ref/lean4` | Complete @ `0e8a9ebad9` |
| Product docs | Missing -- this plan creates them |

---

## 9. Implementation steps (after approval)

1. Write `doc/vocabulary.md` (Slake disambiguation + three runtime stories).
2. Write `doc/goals.md` (canonical goals / non-goals / honesty ladder).
3. Write `doc/architecture.md` (meet-in-middle + backends).
4. Write `doc/divergence.md` (correspondence honesty).
5. Write `doc/idris-entry.md` and `doc/lean-entry.md`.
6. Write `doc/research/README.md`.
7. Write short `RESIDUAL.md` (docs landed, next spikes listed, not Systems wave history).
8. Write `doc/SESSION-HANDOFF.md`.
9. Write root `README.md`.
10. Write root `AGENTS.md`.
11. Mirror or link this plan under `.agents/plans/` if useful for in-repo discoverability.
12. Stage new docs; **leave commit to user** with signed command (GPG mandatory).

**Out of scope this pass:** Slake compiler source, LLVM backend, Rust ABI implementation, Systems SCORE changes.

---

## 10. Risks and mitigations

| Risk | Mitigation |
|------|------------|
| Slake name collision | Vocabulary + AGENTS disambiguation every time |
| Jargon / ephemeral IDs | Identifier hygiene; plain English default; systems-naming principles |
| iso becomes second Systems residual mill | Explicit ban; residual here is iso-only |
| "Isomorphism" overclaimed | Goals: progressive correspondence + evidence bars |
| "Rust without FFI" vapor | Architecture + residual item for concrete ABI note before claim |
| Attention dilution / compaction amnesia | Short AGENTS + SESSION-HANDOFF; detail in goals/architecture |
| Cross-repo drift | Absolute paths to sister tree; "read don't fork" |

---

## 11. Verification (docs pass)

```bash
cd /home/hunter/Projects/ai/iso
test -f AGENTS.md && test -f README.md && test -f RESIDUAL.md
test -f doc/goals.md && test -f doc/vocabulary.md
test -f doc/architecture.md && test -f doc/divergence.md
test -f doc/SESSION-HANDOFF.md
test -f doc/idris-entry.md && test -f doc/lean-entry.md
test -f doc/research/README.md
test -f ref/Idris2/README.md && test -f ref/lean4/README.md
git submodule status
# Manual: AGENTS discovery order matches files; Slake disambiguated
```

---

## 12. Open questions (non-blocking defaults)

| # | Question | Plan default if silent |
|---|----------|------------------------|
| 1 | Slake naming | iso = compiler; cryptoquick = Lake twin until intentional rename |
| 2 | Sister-tree "See also" link | **iso-only** unless user asks to edit cryptoquick |
| 3 | Future compiler source home | Prefer **iso `src/`** (or `compiler/`) so vision and product co-locate; Systems Lean remains language/runtime |
| 4 | Rust without FFI first meaning | Document as open design with preferred sketch: **LLVM IR + layout-compatible embed / link**, not hand-written `extern "C"` glue as the happy path |
| 5 | lean4 pin policy | Track submodule commit as recorded; pin bumps intentional |

---

## 13. Critical files for implementation

**Create in iso:**

- `AGENTS.md`, `README.md`, `RESIDUAL.md`
- `doc/goals.md`, `doc/vocabulary.md`, `doc/architecture.md`, `doc/divergence.md`
- `doc/SESSION-HANDOFF.md`, `doc/idris-entry.md`, `doc/lean-entry.md`
- `doc/research/README.md`

**Read, do not fork content:**

- `/home/hunter/Projects/cryptoquick/lean4/doc/dev/systems-lean.md`
- `/home/hunter/Projects/cryptoquick/lean4/doc/dev/slake.md`
- `/home/hunter/Projects/cryptoquick/lean4/doc/dev/systems-naming.md`
- `/home/hunter/Projects/cryptoquick/lean4/RESIDUAL.md` (pattern only)
- `/home/hunter/.grok/AGENTS.md`
- `/home/hunter/Projects/surmount/lean/verik1/AGENTS.md` (identifier hygiene)
- `/home/hunter/Projects/ai/iso/ref/Idris2/docs/source/implementation/overview.rst`
- `/home/hunter/Projects/ai/iso/ref/Idris2/docs/source/backends/refc.rst`

---

## 14. Approval ask

Approve this plan to land the durable documentation and agent hygiene pins in `/home/hunter/Projects/ai/iso` as specified above.

**Revise** if you want different Slake naming, compiler source home, or sister-tree cross-links.

**Abandon** if iso should not be the home for this vision.
