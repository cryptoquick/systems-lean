# Session handoff

Reseed after compaction or a new chat. Read in order with `AGENTS.md`.

---

## Role (fork-ready)

**Forks:** paste `doc/fork-idris.md` or `doc/fork-lean.md` (PROMPT section).
**Watcher:** root `WATCHER.md` (`WATCHER_BEGIN` / `WATCHER_END`) -- next implement prompt for auto-continue.
**Coordinator:** this chat / `doc/fork-coordinator.md` -- join only; do not race Idris/Lean sides by default.

This project is set up so you can **fork the chat** into research vs implementor without fighting over the same residual.

| Role | Does | Does not |
|------|------|----------|
| **Research / analysis** | Correspondence, trusted computing base essays, dual-example analysis, IR/interop design notes under `doc/research/` or analysis docs | Drive product residual treadmill unless reassigned; does not need to own git |
| **Primary implementor** | Residual that changes product surface, later `src/`, gates | Invent research backlog from silence |

If role is unclear after compaction: **ask once**. Do not assume.

**Foundation chat status:** refs + charter + hygiene are landed. **Hard Slake / correspondence work is on Hold** in `RESIDUAL.md` until a forked chat claims it.

---

## North star (one line)

**Systems Lean** is this project (language + freestanding systems goals). **Slake** is its compiler: meet-in-the-middle Idris 2 <-> Lean 4 (QTT + Curry-Howard), freestanding products to CompCert-oriented C and LLVM IR, Rust interop without classic FFI as the design bar -- work **here, in isolation**.

---

## Residual and progress

- Coordinator: `RESIDUAL.md`
- Sides: `RESIDUAL-idris.md`, `RESIDUAL-lean.md`
- Meter: `doc/PROGRESS.md` (`just progress` / `just watch` every 300s)
- Steering: `doc/fork-guidance-idris.md`, `doc/fork-guidance-lean.md`

---

## Key paths

| Path | Why |
|------|-----|
| `AGENTS.md` | Agent policy + isolation + discovery |
| `doc/goals.md` | Canonical goals |
| `doc/vocabulary.md` | Stable terms; Slake = compiler |
| `doc/architecture.md` | Meet-in-middle sketch |
| `doc/divergence.md` | Honest differences / trusted computing base |
| `RESIDUAL.md` | Living open work (Systems Lean only); Hold vs Open |
| `ref/Idris2/` | Upstream Idris 2 (read-only) |
| `ref/lean4/` | Upstream Lean 4 (read-only) |
| `ref/CompCert/` | AbsInt CompCert (read-only; `ccomp` source) |
| `ref/rust/` | rustc layout/ABI + codegen_llvm (read-only) |
| `src/idris2/` `src/lean4/` `src/systems/` | Novel workspaces |
| `out/freestanding-c/` | Release freestanding AOT C |
| `justfile` | `just check` / `build` / `out-freestanding-c` |
| `doc/idris-entry.md` | Idris map |
| `doc/lean-entry.md` | Lean map |
| `doc/compcert-entry.md` | CompCert map |
| `doc/rust-entry.md` | Rust layout / LLVM interop map |
| `.agents/plans/plan-iso-goals-and-agent-hygiene.md` | Approved plan + isolation amendment |

---

## Isolation (do not forget)

Do **not** go work residual in other trees by default. This repo is Systems Lean. Escalate off-repo only when the human says we are desperate for a specific solution.

---

## Why `ref/rust` and not `ref/llvm` alone

Rust **type layout and ABI** live in rustc. LLVM IR is the wire shape; layout-compatible interop needs rustc's rules. Nested LLVM under rust is optional and large -- do not recursive-init unless asked. See `doc/rust-entry.md`.

---

## Verify (foundation)

```bash
cd /home/hunter/Projects/ai/iso
test -f AGENTS.md && test -f README.md && test -f RESIDUAL.md
test -f doc/goals.md && test -f doc/vocabulary.md
test -f doc/architecture.md && test -f doc/divergence.md
test -f doc/SESSION-HANDOFF.md
test -f doc/idris-entry.md && test -f doc/lean-entry.md
test -f doc/compcert-entry.md && test -f doc/rust-entry.md
test -f doc/research/README.md
test -f doc/ascii-symbol-map.md
test -f flake.nix
test -f ref/Idris2/README.md && test -f ref/lean4/README.md
test -f ref/CompCert/README.md && test -f ref/rust/README.md
just check
```

Foundation only; held residual needs a claimed role. Policy SSoT: `AGENTS.md`.
