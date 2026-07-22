# Session handoff

Reseed after compaction or a new chat. Read in order with `AGENTS.md`.

---

## Role (separate sessions -- ask once if unclear)

| Session | How to reseed | Owns |
|---------|---------------|------|
| **Watcher** | Separate session; contract in root `WATCHER.md` | Auto-continue residual from `WATCHER_BEGIN` / `WATCHER_END` |
| **Systems / Slake** | Paste `doc/fork-systems.md` PROMPT | `src/systems/`, `RESIDUAL-systems.md` |
| **Idris side** | Paste `doc/fork-idris.md` PROMPT | `src/idris2/`, `RESIDUAL-idris.md` |
| **Lean side** | Paste `doc/fork-lean.md` PROMPT | `src/lean4/`, `RESIDUAL-lean.md` |
| **Coordinator** | `doc/fork-coordinator.md` | `RESIDUAL.md` join board, fork guidance |
| **Research** | Analysis under `doc/research/` | Inventory / correspondence notes only |

**Do not confuse:** the **watcher session** (reads `WATCHER.md`) is not the **Systems / Slake session**.
`just watch` is only a progress-meter loop (any session may run it).

If role is unclear after compaction: **ask once**. Do not assume coordinator or watcher.

**Status:** foundation + dual depth (algorithm ids ConsumeToken, ErasedIndex,
UnrestrictedShare on both bridge sides) + IR sketch + systems skeleton + unit
surface + compile-path + **frozen** emit V0 wire (`SLAKE_EMIT_FREESTANDING_C_V0`
through EMIT_BODY_V0 end; stage id `IR_PROGRAM_V0` for ordered IR program) +
**SYSTEMS_LEAN_HOST partial** (Lake + Mult..ProductPath under `src/systems/`;
31 modules including KernelMult + EmitMult + ParityMult + KernelLinear +
ParityLinear + KernelTypes + ParityTypes + KernelProgram + ParityProgram +
KernelEmit + ParityEmit + SelfApply + SelfApplyFs + LlvmHold + InventoryClose +
ProductPath).
Still **not residual free**.
Progress meter 100% is evidence-weighted milestones, not freestanding residual free.
**Active product residual:** freestanding self-host track. SH0..SH5 partial +
SH5 freestanding deepen (extract/body + Mult..Emit parity compose) + Mult+Linear
freestanding Linear path parity + Mult+Linear+Types freestanding Types path
parity + Mult+Linear+Types+Program freestanding Program path parity +
Mult+Linear+Types+Program+Emit freestanding Emit path parity + SH6 hold
documented + HOST-INVENTORY-CLOSE + HOST-PRODUCT-PATH:
`self-host.md`; KernelMult; EmitMult + host_emit_mult.ssot.txt;
ParityMult + probe Mult; KernelLinear HOST-KERNEL-LINEAR; ParityLinear
HOST-PARITY-LINEAR / linearParityReady / multLinearParityReady + probe labels;
KernelTypes HOST-KERNEL-TYPES; ParityTypes HOST-PARITY-TYPES / typesParityReady /
multLinearTypesParityReady + probe TYPED_IR / slake_ir_node labels;
KernelProgram HOST-KERNEL-PROGRAM; ParityProgram HOST-PARITY-PROGRAM /
programParityReady / multLinearTypesProgramParityReady + probe IR_PROGRAM /
IR_GRAPH / HOST_COMPOSE labels; KernelEmit HOST-KERNEL-EMIT (plan/apply/body +
Mult emit); ParityEmit HOST-PARITY-EMIT / emitParityReady /
multLinearTypesProgramEmitParityReady + probe EMIT_PLAN / EMIT_APPLY / EMIT_BODY
labels; SelfApply HOST-SELF-APPLY / selfApplyReady (host structural
Mult+Linear+Types+Program+Emit only); SelfApplyFs HOST-SELF-APPLY-FS /
freestandingParityLadderReady / freestandingSelfApplyReady (extract/body path +
Mult..Emit parity compose; freestandingProductSelfHostComplete = false -- not
freestanding product self-host complete); LlvmHold HOST-LLVM-HOLD /
llvmHoldReady (unlock flags false -- not llvm unlocked); InventoryClose
HOST-INVENTORY-CLOSE / inventoryCloseReady (residualFreeClaimed false -- not
residual free; intentional PARTIAL carry); ProductPath HOST-PRODUCT-PATH /
productPathReady (unit/program CompilePath honesty after inventory close;
residualFreeClaimed false -- not residual free; not freestanding product
self-host complete).
**Next: further honest freestanding product path deepen** -- without forging
complete / residual free / llvm unlock. SH4 host ladder substantially complete;
Mult..Emit freestanding parity ladder partial landed; SH5 freestanding path deepen
+ parity ladder compose partial landed; host inventory close readiness landed;
freestanding product path readiness landed.
P7 / P5 direction maps remain partial history. P6 llvm / PROVABLY held
(documented via LlvmHold; not residual-open mill). Product wire / host model
jargon: `doc/vocabulary.md`. See `RESIDUAL-systems.md`.

---

## North star (one line)

**Systems Lean** is this project (language + freestanding systems goals). **Slake** is its compiler: meet-in-the-middle Idris 2 <-> Lean 4 (QTT + Curry-Howard), freestanding products to CompCert-oriented C and LLVM IR, Rust interop without classic FFI as the design bar -- work **here, in isolation**.

---

## Residual and progress

- Coordinator: `RESIDUAL.md`
- Forks: `RESIDUAL-idris.md`, `RESIDUAL-lean.md`, `RESIDUAL-systems.md`
- Meter: `doc/PROGRESS.md` via `just progress` (pure Nix under `nix/progress/`); `just watch` loops every 300s
- Hygiene: `just hygiene` (pure Nix under `nix/source-hygiene.nix`) -- not Python, not bash-in-Nix
- Host presence: `just systems-host` (pure Nix under `nix/systems-host-presence/`; live impure eval)
- Emit-wire presence: `just systems-emit-wire` (pure Nix under `nix/systems-emit-wire/`; live impure eval)
- Flake vs live: new `nix/` modules must be human-staged before `nix flake check` sees them
- Steering: `doc/fork-guidance-idris.md`, `doc/fork-guidance-lean.md`, `doc/fork-guidance-systems.md`

## Three languages only (reseed after compaction)

Novel work uses **only**:

1. **Idris 2** -- `src/idris2/`
2. **Lean 4** -- `src/lean4/` and `src/systems/` (Systems Lean / **Slake**)
3. **Pure Nix flakes** -- small modules under `nix/` (not bash-in-Nix, not kitchen-sink files; layout for large language model attention and compaction)

No project Python. Do not grow shell. Residual `.sh` under `script/` and large workspace `check.sh` files are **debt to shrink**, not a template. Freestanding C under `out/` is **emit output**, not a source language for the project.

Read `AGENTS.md` (**Three languages only** + **Nix tooling**) and `doc/vocabulary.md` before adding any tool or gate.

---

## Key paths

| Path | Why |
|------|-----|
| `AGENTS.md` | Agent policy + isolation + Nix tooling hard rule |
| `doc/goals.md` | Canonical goals |
| `doc/vocabulary.md` | Stable product terms + tooling terms |
| `doc/architecture.md` | Meet-in-middle sketch |
| `doc/divergence.md` | Honest differences / trusted computing base |
| `RESIDUAL.md` | Living open work (Systems Lean only); Hold vs Open |
| `nix/` | Pure flake tooling modules (hygiene, progress, systems-host-presence, systems-emit-wire, novel-source filter) |
| `flake.nix` | Thin flake wire-up only (not a shell-script dump) |
| `justfile` | Task runner: check / progress / hygiene / watch / build / emit |
| `ref/Idris2/` | Upstream Idris 2 (read-only) |
| `ref/lean4/` | Upstream Lean 4 (read-only) |
| `ref/CompCert/` | AbsInt CompCert (read-only; `ccomp` source) |
| `ref/rust/` | rustc layout/ABI + codegen_llvm (read-only) |
| `src/idris2/` `src/lean4/` `src/systems/` | Novel workspaces |
| `out/freestanding-c/` | Release freestanding ahead-of-time C (no managed runtime on the wire) |
| `script/` | Residual product build/emit shells only (migration debt) |
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
