#!/usr/bin/env python3
# SPDX-License-Identifier: Unlicense
"""Evolving progress meter for Systems Lean / Slake sides.

Evidence-based weights (not calendar estimates). Writes doc/PROGRESS.md.
Also used by script/watch-forks.sh.
"""

from __future__ import annotations

import argparse
import json
import time
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_MD = ROOT / "doc" / "PROGRESS.md"
STATE_PATH = ROOT / ".cache" / "fork-watch-state.json"


@dataclass(frozen=True)
class Milestone:
    id: str
    label: str
    weight: float
    side: str  # idris | lean | both | systems | foundation


def exists(*parts: str) -> bool:
    return ROOT.joinpath(*parts).is_file()


def any_suffix(dir_parts: tuple[str, ...], suffixes: tuple[str, ...], skip_readme: bool = True) -> bool:
    d = ROOT.joinpath(*dir_parts)
    if not d.is_dir():
        return False
    for p in d.rglob("*"):
        if not p.is_file():
            continue
        if skip_readme and p.name == "README.md":
            continue
        if p.suffix in suffixes:
            return True
    return False


def dir_nontrivial(dir_parts: tuple[str, ...]) -> bool:
    d = ROOT.joinpath(*dir_parts)
    if not d.is_dir():
        return False
    files = [p for p in d.rglob("*") if p.is_file()]
    if not files:
        return False
    if len(files) == 1 and files[0].name == "README.md":
        return False
    return True


def name_hint(dir_parts: tuple[str, ...], *hints: str) -> bool:
    d = ROOT.joinpath(*dir_parts)
    if not d.is_dir():
        return False
    for p in d.rglob("*"):
        if not p.is_file() or p.name == "README.md":
            continue
        low = p.name.lower()
        if any(h in low for h in hints):
            return True
    return False


def evaluate() -> list[tuple[Milestone, bool, str]]:
    items: list[tuple[Milestone, bool, str]] = []

    def add(m: Milestone, done: bool, note: str) -> None:
        items.append((m, done, note))

    add(
        Milestone("foundation", "Foundation (charter, tooling, refs)", 12, "foundation"),
        exists("AGENTS.md")
        and exists("justfile")
        and exists("flake.nix")
        and exists("ref", "Idris2", "README.md")
        and exists("ref", "lean4", "README.md"),
        "AGENTS + just + flake + submodules",
    )
    add(
        Milestone("idris_mult", "Idris multiplicity map", 10, "idris"),
        exists("src", "idris2", "multiplicity-map.md")
        or name_hint(("src", "idris2"), "mult", "multiplicit"),
        "src/idris2 multiplicity notes",
    )
    add(
        Milestone("lean_mult", "Lean multiplicity map", 10, "lean"),
        exists("src", "lean4", "multiplicity-map.md"),
        "src/lean4/multiplicity-map.md",
    )
    add(
        Milestone("idris_example", "Idris dual example (native)", 10, "idris"),
        any_suffix(("src", "idris2"), (".idr",))
        or any_suffix(("src", "idris2", "examples"), (".idr", ".md")),
        "src/idris2 .idr or examples/",
    )
    add(
        Milestone("lean_example", "Lean dual example", 10, "lean"),
        exists("src", "lean4", "examples", "ConsumeToken.lean")
        or any_suffix(("src", "lean4", "examples"), (".lean",)),
        "src/lean4/examples",
    )
    add(
        Milestone("idris_join", "Idris JOIN greppable points", 5, "idris"),
        exists("src", "idris2", "JOIN.md"),
        "src/idris2/JOIN.md",
    )
    add(
        Milestone("lean_join", "Lean JOIN greppable points", 5, "lean"),
        exists("src", "lean4", "JOIN.md"),
        "src/lean4/JOIN.md",
    )
    add(
        Milestone("dual_pair", "Dual pair join-ready", 8, "both"),
        exists("src", "idris2", "JOIN.md")
        and exists("src", "lean4", "JOIN.md")
        and dir_nontrivial(("src", "idris2"))
        and dir_nontrivial(("src", "lean4")),
        "both JOIN.md + nontrivial sides",
    )
    add(
        Milestone("shared_ir", "Shared intermediate-representation sketch", 6, "both"),
        exists("doc", "shared-ir-sketch.md"),
        "doc/shared-ir-sketch.md",
    )
    add(
        Milestone("systems_skeleton", "Slake / systems novel sources", 10, "systems"),
        dir_nontrivial(("src", "systems")),
        "src/systems beyond README",
    )
    add(
        Milestone("build_units", "Systems units for just build", 4, "systems"),
        any_suffix(("src", "systems"), (".lean", ".slake")),
        "src/systems *.lean or *.slake",
    )
    add(
        Milestone("freestanding_c", "out/freestanding-c product C", 10, "systems"),
        any(
            p.suffix in {".c", ".h"}
            for p in (ROOT / "out" / "freestanding-c").rglob("*")
            if p.is_file() and p.name != "README.md"
        ),
        "generated .c/.h under out/freestanding-c",
    )
    return items


def bar(pct: float, width: int = 20) -> str:
    n = int(round(pct / 100.0 * width))
    n = max(0, min(width, n))
    return "[" + ("#" * n) + ("-" * (width - n)) + f"] {pct:5.1f}%"


def compute() -> dict:
    items = evaluate()
    total_w = sum(m.weight for m, _, _ in items)
    done_w = sum(m.weight for m, d, _ in items if d)
    pct = 100.0 * done_w / total_w if total_w else 0.0

    side_done: dict[str, float] = {}
    side_total: dict[str, float] = {}
    for m, d, _ in items:
        side_total[m.side] = side_total.get(m.side, 0.0) + m.weight
        if d:
            side_done[m.side] = side_done.get(m.side, 0.0) + m.weight

    def side_pct(name: str) -> float:
        t = side_total.get(name, 0.0)
        return 100.0 * side_done.get(name, 0.0) / t if t else 0.0

    return {
        "pct_overall": pct,
        "pct_idris": side_pct("idris"),
        "pct_lean": side_pct("lean"),
        "pct_systems": side_pct("systems"),
        "pct_foundation": side_pct("foundation"),
        "items": [
            {
                "id": m.id,
                "label": m.label,
                "weight": m.weight,
                "side": m.side,
                "done": d,
                "note": note,
            }
            for m, d, note in items
        ],
        "ts": time.strftime("%Y-%m-%d %H:%M:%S %z"),
    }


def write_progress_md(data: dict) -> None:
    lines = [
        "# Progress meter (generated)",
        "",
        f"Updated: {data['ts']}",
        "",
        "Evidence-based weights -- not calendar estimates. Regenerate: `just progress` or `just watch`.",
        "",
        "## Overall (Slake / Systems Lean journey)",
        "",
        f"    {bar(data['pct_overall'])}",
        "",
        "## By stream",
        "",
        f"- Foundation:  {bar(data['pct_foundation'])}",
        f"- Idris side:  {bar(data['pct_idris'])}",
        f"- Lean side:   {bar(data['pct_lean'])}",
        f"- Systems / freestanding: {bar(data['pct_systems'])}",
        "",
        "## Milestones",
        "",
        "| Done | Weight | Side | Milestone | Evidence |",
        "|------|--------|------|-----------|----------|",
    ]
    for it in data["items"]:
        mark = "yes" if it["done"] else "no"
        lines.append(
            f"| {mark} | {it['weight']:.0f} | {it['side']} | {it['label']} | {it['note']} |"
        )
    lines.extend(
        [
            "",
            "## Residuals",
            "",
            "- Coordinator: `RESIDUAL.md`",
            "- Idris side: `RESIDUAL-idris.md`",
            "- Lean side: `RESIDUAL-lean.md`",
            "",
            "## Guidance (coordinator -> forks)",
            "",
            "- `doc/fork-guidance-idris.md`",
            "- `doc/fork-guidance-lean.md`",
            "",
            "SPDX-License-Identifier: Unlicense",
            "",
        ]
    )
    OUT_MD.write_text("\n".join(lines), encoding="utf-8")


def load_state() -> dict:
    if STATE_PATH.is_file():
        try:
            return json.loads(STATE_PATH.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            return {}
    return {}


def save_state(state: dict) -> None:
    STATE_PATH.parent.mkdir(parents=True, exist_ok=True)
    STATE_PATH.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")


def tree_mtime(parts: tuple[str, ...]) -> float:
    d = ROOT.joinpath(*parts)
    if not d.exists():
        return 0.0
    if d.is_file():
        return d.stat().st_mtime
    latest = 0.0
    for p in d.rglob("*"):
        if p.is_file():
            latest = max(latest, p.stat().st_mtime)
    return latest


def detect_changes(state: dict) -> dict[str, bool]:
    keys = {
        "idris": ("src", "idris2"),
        "lean": ("src", "lean4"),
        "systems": ("src", "systems"),
        "residual_idris": ("RESIDUAL-idris.md",),
        "residual_lean": ("RESIDUAL-lean.md",),
        "residual": ("RESIDUAL.md",),
    }
    changed: dict[str, bool] = {}
    prev = state.get("mtimes", {})
    mtimes: dict[str, float] = {}
    for k, parts in keys.items():
        mt = tree_mtime(parts)
        mtimes[k] = mt
        changed[k] = bool(mt) and prev.get(k, 0) != mt
    state["mtimes"] = mtimes
    return changed


def update_guidance_snapshots(data: dict, changed: dict[str, bool], stalled: dict[str, int]) -> None:
    def patch(path: Path, body: str) -> None:
        if not path.is_file():
            return
        text = path.read_text(encoding="utf-8")
        marker = "## Status snapshot"
        if marker not in text:
            return
        pre, rest = text.split(marker, 1)
        rest_body = rest[len("\n") :] if rest.startswith("\n") else rest
        if "\n## " in rest_body:
            _old, post = rest_body.split("\n## ", 1)
            post = "\n## " + post
        else:
            post = ""
        ch = ", ".join(k for k, v in changed.items() if v) or "none"
        snap = (
            f"{marker}\n\n"
            f"Watcher/progress at {data['ts']}:\n\n"
            f"- Overall {data['pct_overall']:.1f}% | Idris {data['pct_idris']:.1f}% | "
            f"Lean {data['pct_lean']:.1f}% | Systems {data['pct_systems']:.1f}%\n"
            f"- Tree changes this cycle: {ch}\n"
            f"- Stall cycles (no mtime change): idris={stalled.get('idris', 0)} "
            f"lean={stalled.get('lean', 0)}\n"
            f"- {body}\n"
        )
        path.write_text(pre + snap + post, encoding="utf-8")

    idris_note = (
        "Still need multiplicity map + native example + JOIN.md under src/idris2/."
        if data["pct_idris"] < 99
        else "Idris stream milestones green on meter -- keep residual honest."
    )
    lean_note = (
        "Lean first cut present; dual-update when Idris lands."
        if data["pct_lean"] > 0
        else "Lean milestones incomplete."
    )
    if stalled.get("idris", 0) >= 3:
        idris_note += (
            " STALL: no src/idris2 or RESIDUAL-idris mtime for 3+ watch cycles "
            "-- re-read guidance and push residual 1-3."
        )
    if stalled.get("lean", 0) >= 3:
        lean_note += (
            " STALL: no lean tree mtime for 3+ cycles -- if blocked on Idris, "
            "document blocked in RESIDUAL-lean.md."
        )

    patch(ROOT / "doc" / "fork-guidance-idris.md", idris_note)
    patch(ROOT / "doc" / "fork-guidance-lean.md", lean_note)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--json", action="store_true", help="print JSON to stdout")
    ap.add_argument(
        "--watch-update-state",
        action="store_true",
        help="update stall counters from mtimes (used by watch-forks.sh)",
    )
    args = ap.parse_args()

    data = compute()
    write_progress_md(data)

    state = load_state()
    changed = detect_changes(state)
    stalled = dict(state.get("stalled", {"idris": 0, "lean": 0}))
    if args.watch_update_state:
        if changed.get("idris") or changed.get("residual_idris"):
            stalled["idris"] = 0
        else:
            stalled["idris"] = int(stalled.get("idris", 0)) + 1
        if changed.get("lean") or changed.get("residual_lean"):
            stalled["lean"] = 0
        else:
            stalled["lean"] = int(stalled.get("lean", 0)) + 1
        state["stalled"] = stalled
        save_state(state)
        update_guidance_snapshots(data, changed, stalled)
    else:
        save_state(state)
        update_guidance_snapshots(data, changed, stalled)

    if args.json:
        print(json.dumps(data, indent=2))
    else:
        print(f"overall {bar(data['pct_overall'])}")
        print(f"idris   {bar(data['pct_idris'])}")
        print(f"lean    {bar(data['pct_lean'])}")
        print(f"systems {bar(data['pct_systems'])}")
        print(f"wrote {OUT_MD.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
