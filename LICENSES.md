# Licenses

## This repository (Systems Lean) -- our work

**Author:** Hunter "cryptoquick" Beast

**License for work committed directly in this repository:** [The Unlicense](https://unlicense.org) -- see the root file `UNLICENSE.md`.

All **original** material committed in this tree (documentation, agent policy, project configuration, and any future product source we write here under this policy) is released into the **public domain** under The Unlicense.

> We treat that material as public domain because "intellectual property" is fake and gay witch doctor nonsense.

That sentence is the project's **attitude** toward exclusive IP theatre. The **legal instrument** for our original work is still **The Unlicense** (`UNLICENSE.md`), so downstream users have a greppable, standard public-domain dedication rather than a vibes-only footer.

### What "our work" means

| In scope (Unlicense / public domain dedication) | Out of scope |
|--------------------------------------------------|--------------|
| Files **authored in this repo** outside `ref/` (e.g. `AGENTS.md`, `doc/**`, `README.md`, `RESIDUAL.md`, root config we add, future `src/` we write) | Everything under `ref/` (upstream, **read-only** submodules) |
| Our own edits to files that live **outside** `ref/` | Copies or verbatim extracts of upstream that you may drop elsewhere -- those keep **their** licenses |

If you vendor or copy code **from** a `ref/` tree into product sources later, that copy keeps the **upstream** license obligations unless the upstream license and the law allow otherwise. Do not pretend submodule code is Unlicense just because it sits next to our docs.

### SPDX for our novel crates, modules, and packages

Any **novel work we author** in this repository -- Rust crates, Lean modules/packages, Idris packages, Nix packages, libraries, binaries, or similar -- must use the Unlicense **SPDX** designation where the format supports license metadata:

| Kind of artifact | Where to put it |
|------------------|-----------------|
| **SPDX short id** | `Unlicense` |
| Rust crate | `Cargo.toml`: `license = "Unlicense"` (and keep root `UNLICENSE.md` / this file accurate) |
| Lean package | `lakefile` / package metadata / module header comment as appropriate: SPDX `Unlicense` |
| Idris package | `.ipkg` or package docs: SPDX `Unlicense` |
| Nix package | `meta.license = lib.licenses.unlicense;` (or equivalent SPDX/`Unlicense` mapping in that nixpkgs revision) |
| Generic source file | Optional file header: `SPDX-License-Identifier: Unlicense` |

Do **not** put `Unlicense` on files that are copies or substantial extracts of upstream under `ref/` (or other third-party code). Those keep their upstream SPDX / license text.

---

## Referenced projects (`ref/`)

These are **git submodules**. Their licenses are whatever their upstreams say. We track them here for honesty; the authoritative text is always inside each submodule.

| Path | Project | Upstream | License summary (see submodule for full text) |
|------|---------|----------|------------------------------------------------|
| `ref/Idris2` | Idris 2 | [idris-lang/Idris2](https://github.com/idris-lang/Idris2) | **BSD-style** (3-clause class; copyright Edwin Brady / contributors). File: `ref/Idris2/LICENSE` |
| `ref/lean4` | Lean 4 | [leanprover/lean4](https://github.com/leanprover/lean4) | **Apache License 2.0**. Files: `ref/lean4/LICENSE`, `ref/lean4/LICENSES` (third-party inventory) |
| `ref/CompCert` | CompCert verified compiler | [AbsInt/CompCert](https://github.com/AbsInt/CompCert) | **Non-free for commercial use** by default: **INRIA Non-Commercial License Agreement** and/or AbsInt commercial agreement. Some `lib/` files dual-licensed INRIA-NC + **LGPL-2.1-or-later**. File: `ref/CompCert/LICENSE`. **Not** public domain; **not** Unlicense. Building/shipping product C through `ccomp` has **real license constraints** -- read upstream before commercial use. |
| `ref/rust` | Rust (rustc + std + tools) | [rust-lang/rust](https://github.com/rust-lang/rust) | **Dual-licensed Apache-2.0 OR MIT** for the main project (`LICENSE-APACHE`, `LICENSE-MIT`). The monorepo also vendors many third-party components under additional terms (`ref/rust/LICENSES/`, crate-level notices). |

### CompCert special note

CompCert is included as a **reference** for a CompCert-oriented backend and PROVABLY-style honesty. Submodule presence **does not** grant commercial rights to CompCert. Educational/research/evaluation use under INRIA-NC may apply; commercial use needs AbsInt's agreement (or whatever the current upstream license states). Always re-read `ref/CompCert/LICENSE` at the pinned commit.

### How to refresh this table

When adding a submodule or bumping a pin:

1. Open the submodule's primary `LICENSE` / `COPYING` / `LICENSE-*` files at the **pinned commit**.
2. Update the row above (and any special notes).
3. Do not restate third-party text in full here unless required -- link paths into `ref/`.

---

## SPDX-style shorthand (non-normative)

| Component | SPDX-ish label |
|-----------|----------------|
| Systems Lean original work | `Unlicense` |
| `ref/Idris2` | BSD-3-Clause class (confirm at pin) |
| `ref/lean4` | `Apache-2.0` (+ third parties per `LICENSES`) |
| `ref/CompCert` | Proprietary / INRIA-NC (+ LGPL-2.1-or-later for some `lib/` files) |
| `ref/rust` | `Apache-2.0 OR MIT` (+ many vendored licenses) |

SPDX labels above are **convenience only**. Upstream files win.

---

## Contact / attribution (optional)

Original **Systems Lean** work by **Hunter "cryptoquick" Beast**. Attribution is appreciated but **not required** under The Unlicense.
