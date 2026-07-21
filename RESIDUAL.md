# Residual -- coordinator (Systems Lean)

Project-level residual and join board. **Sides own their own files:**

| File | Owner |
|------|--------|
| `RESIDUAL-idris.md` | Idris-side fork |
| `RESIDUAL-lean.md` | Lean-side fork |
| `RESIDUAL.md` (this file) | Coordinator |

**Status vocabulary:** `open` | `in progress` | `done` | `blocked` | `wontfix`

Green `just check` != residual closed.

Language: **Idris side** / **Lean side** / **coordinator** -- never "pole".

---

## Join done

| Item | Evidence |
|------|----------|
| Dual MULT maps (MULT-0 / MULT-1 / MULT-OMEGA) | `src/idris2/multiplicity-map.md`, `src/lean4/multiplicity-map.md` |
| ConsumeToken dual (JOIN-ALG) | `src/idris2/examples/ConsumeToken.idr`, `src/lean4/examples/ConsumeToken.lean` |
| Both JOIN files | `src/idris2/JOIN.md`, `src/lean4/JOIN.md` |
| Greppable imperfect edges merged into divergence | `doc/divergence.md` section **Greppable imperfect edges (dual pair)** (EDGE-* / ERASE-* / RUNTIME-* + JOIN-ALG) |

Side forks should **not** invent a second dual example or new map residual unless the human asks. Coordinator owns divergence merge (done this slice).

---

## Open (high-value next)

| Priority | Work | Owner / notes |
|----------|------|----------------|
| 1 | **Shared intermediate-representation (IR) sketch** | Coordinator / systems path. Unblocked by dual pair + JOIN. Prefer durable note under `doc/` (or research with Kind honesty) so both language forks can stop inventing map work. Feeds Slake later. |
| 2 | **Slake skeleton under `src/systems/`** | Only after IR honesty lands. Do not start freestanding emit body before that. |
| 3 | Optional toolchains in shell (Lake / `idris2`) | L-LAKE, idris2 check when available -- do **not** break `just check` without tools |

**Highest-value unblocker for parallelization:** IR sketch (coordinator). Systems freestanding hold stays closed until IR lands.

---

## Hold / deferred / blocked

| Item | Status | Why |
|------|--------|-----|
| `out/llvm-ir` pipeline | Hold | Deferred until self-hosted Systems Lean / Slake |
| CompCert PROVABLY path | Hold | Needs real `ccomp` + evidence matrix; never forge |
| Second ConsumeToken-class dual | Hold | Dual pair already exists; invent only on human request |
| Freestanding product residual free | Not claimed | Host elaborator residual != product residual; honesty required |
| Wire `just build` freestanding compile | Hold | After units exist under systems |
| Populate `out/freestanding-c` | Hold | After emit exists |

---

## Project hold ladder (after dual pair)

| Priority | Work | When |
|----------|------|------|
| 1 | Shared intermediate-representation sketch | **Now unblocked** (dual pair + both JOIN + divergence edges done) |
| 2 | Slake skeleton under `src/systems/` | After IR honesty |
| 3 | Wire `just build` freestanding compile | Units exist |
| 4 | Populate `out/freestanding-c` | Emit exists |
| 5 | CompCert PROVABLY path | Real `ccomp` + matrix |
| 6 | `out/llvm-ir` | Deferred until self-hosted Systems Lean / Slake |

---

## Join status (auto-refreshed by `just progress` / `just watch`)

See live meter: `doc/PROGRESS.md` (generated). Do not hand-edit percentage tables there; edit evidence (side files + side residuals) instead.

---

## Foundation done

Tooling, charter, submodules, fork prompts, hygiene, Nix, just -- see `AGENTS.md`.

---

## Coordinator actions

- Read both side residuals + `doc/PROGRESS.md`.
- Write short directives in `doc/fork-guidance-idris.md` and `doc/fork-guidance-lean.md` (forks re-read each loop).
- Run `just watch` (300s loop) or `just progress` (once) while forks run.
- Do not race side trees unless reassigned.
- Own greppable edge merge into `doc/divergence.md` (done for dual pair).

---

## Isolation

This repository **is** Systems Lean. Off-repo only if the human is desperate for a named fix.

## Watcher

Next implement prompt: root **`WATCHER.md`** (`WATCHER_BEGIN` ... `WATCHER_END`). This file is the status ledger only.
