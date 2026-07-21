#!/usr/bin/env python3
# SPDX-License-Identifier: Unlicense
"""Source hygiene for Systems Lean novel work.

Hard rules:
  - No trailing whitespace on novel files.
  - Printable ASCII only (tab/LF/CR + 0x20-0x7E), except allowlisted paths
    that may contain Unicode prose/symbols:
      * doc/ascii-symbol-map.md  (Unicode -> ASCII glossary; required)
      * README.md                (human-facing overview; Unicode OK)
      * doc/vocabulary.md        (term table; Unicode OK)
  - ref/** is upstream and not scanned for ASCII policy.

How scrubbing works: each novel text file is UTF-8 decoded, then every
character is checked. If ord(ch) is outside tab/LF/CR and 0x20-0x7E, the
file fails unless it is on the allowlist. --fix rewrites known Unicode
via the symbol map (not applied to allowlisted prose files).

Usage:
  script/check-source-hygiene.py           # git ls-files novel set
  script/check-source-hygiene.py --walk    # filesystem walk (local + Nix)
  script/check-source-hygiene.py --staged  # git index only
  script/check-source-hygiene.py --fix    # map rewrite + strip trailing WS
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAP_REL = Path("doc/ascii-symbol-map.md")
MAP_PATH = ROOT / MAP_REL

# Novel paths allowed to contain non-ASCII (still no trailing whitespace).
UNICODE_OK = frozenset(
    {
        "doc/ascii-symbol-map.md",
        "README.md",
        "doc/vocabulary.md",
    }
)

# Allowed control chars in text files
ALLOWED_CTRL = {0x09, 0x0A, 0x0D}  # tab, LF, CR


def load_map() -> dict[str, str]:
    """Parse CODEPOINT/UNICODE/ASCII rows between MAP_BEGIN and MAP_END."""
    text = MAP_PATH.read_text(encoding="utf-8")
    mapping: dict[str, str] = {}
    in_map = False
    for line in text.splitlines():
        if line.strip() == "MAP_BEGIN":
            in_map = True
            continue
        if line.strip() == "MAP_END":
            in_map = False
            continue
        if not in_map:
            continue
        if not line or line.strip() == "```" or line.lstrip().startswith("#"):
            continue
        parts = line.split("\t")
        if len(parts) < 3:
            continue
        code = parts[0].strip()
        uni = parts[1]
        ascii_rep = parts[2]
        if code.upper() == "CODEPOINT" or code == "0020":
            # space reference row; skip identity
            if code == "0020":
                continue
            continue
        try:
            ch = chr(int(code, 16))
        except ValueError:
            continue
        # Prefer codepoint-derived char (uni column can confuse TSV if empty)
        mapping[ch] = ascii_rep
        if uni and uni != ch:
            mapping[uni] = ascii_rep
    mapping.setdefault("\u00a0", " ")
    return mapping


def is_under_ref(rel: Path) -> bool:
    parts = rel.parts
    return bool(parts) and parts[0] == "ref"


def is_map_file(rel: Path) -> bool:
    return rel.as_posix() == MAP_REL.as_posix()


def unicode_allowed(rel: Path) -> bool:
    return rel.as_posix() in UNICODE_OK


def list_files(staged: bool, walk: bool) -> list[Path]:
    if staged:
        out = subprocess.check_output(
            ["git", "diff", "--cached", "--name-only", "--diff-filter=ACMR", "-z"],
            cwd=ROOT,
        )
        names = [n for n in out.split(b"\0") if n]
        return [Path(n.decode("utf-8", "surrogateescape")) for n in names]
    if walk:
        skip = {".git", "ref", "result", "result-dev", ".direnv"}
        found: list[Path] = []
        for dirpath, dirnames, filenames in os.walk(ROOT):
            rel_dir = Path(dirpath).relative_to(ROOT)
            dirnames[:] = [
                d
                for d in dirnames
                if d not in skip and not d.startswith("result")
            ]
            if rel_dir.parts and rel_dir.parts[0] in skip:
                continue
            for fn in filenames:
                found.append(rel_dir / fn if rel_dir != Path(".") else Path(fn))
        return found
    out = subprocess.check_output(["git", "ls-files", "-z"], cwd=ROOT)
    names = [n for n in out.split(b"\0") if n]
    return [Path(n.decode("utf-8", "surrogateescape")) for n in names]


def is_probably_binary(data: bytes) -> bool:
    if b"\0" in data[:8192]:
        return True
    return False


def scan_text(text: str) -> list[tuple[int, int, str, int]]:
    """Return list of (line, col, char, ord) for illegal chars."""
    bad: list[tuple[int, int, str, int]] = []
    line = 1
    col = 1
    for ch in text:
        if ch == "\n":
            line += 1
            col = 1
            continue
        if ch == "\r":
            col = 1
            continue
        o = ord(ch)
        if ch == "\t" or 0x20 <= o <= 0x7E:
            col += 1
            continue
        if o in ALLOWED_CTRL:
            col += 1
            continue
        bad.append((line, col, ch, o))
        col += 1
    return bad


def trailing_ws_lines(text: str) -> list[int]:
    bad: list[int] = []
    for i, line in enumerate(text.splitlines(), 1):
        if line != line.rstrip(" \t"):
            bad.append(i)
    return bad


def apply_map(text: str, mapping: dict[str, str]) -> str:
    # longest keys first so multi-char sequences win if any
    keys = sorted(mapping.keys(), key=len, reverse=True)
    out = text
    for k in keys:
        if k and k in out:
            out = out.replace(k, mapping[k])
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--staged", action="store_true", help="only staged files")
    ap.add_argument(
        "--walk",
        action="store_true",
        help="walk tree instead of git ls-files (for Nix pure checks)",
    )
    ap.add_argument("--fix", action="store_true", help="apply symbol map then re-check")
    args = ap.parse_args()

    if not MAP_PATH.is_file():
        print(f"error: missing symbol map {MAP_REL}", file=sys.stderr)
        return 2

    mapping = load_map()
    # Prefer filesystem walk unless --staged: untracked novel files must still fail/fix.
    # Nix pure checks also pass --walk explicitly.
    use_walk = args.walk or not args.staged
    files = list_files(args.staged, use_walk)
    rc = 0
    checked = 0

    for rel in files:
        if is_under_ref(rel):
            continue
        path = ROOT / rel
        if not path.is_file():
            continue
        data = path.read_bytes()
        if is_probably_binary(data):
            continue
        try:
            text = data.decode("utf-8")
        except UnicodeDecodeError:
            print(f"{rel}: not valid UTF-8", file=sys.stderr)
            rc = 1
            continue

        # --fix: strip trailing WS always; apply Unicode->ASCII map only off allowlist
        if args.fix:
            fixed = text if unicode_allowed(rel) else apply_map(text, mapping)
            lines = fixed.splitlines()
            stripped = [ln.rstrip(" \t") for ln in lines]
            fixed2 = "\n".join(stripped)
            if text.endswith("\n") or fixed.endswith("\n"):
                fixed2 += "\n"
            if fixed2 != text:
                path.write_text(fixed2, encoding="utf-8", newline="\n")
                text = fixed2
                print(f"fixed: {rel}")

        for ln in trailing_ws_lines(text):
            print(f"{rel}:{ln}: trailing whitespace", file=sys.stderr)
            rc = 1

        if not unicode_allowed(rel):
            bad = scan_text(text)
            if bad:
                shown = 0
                for line, col, ch, o in bad:
                    hint = mapping.get(ch)
                    extra = (
                        f" -> ASCII {hint!r}"
                        if hint
                        else " (no map entry; delete, rewrite, or extend doc/ascii-symbol-map.md)"
                    )
                    print(
                        f"{rel}:{line}:{col}: non-ASCII U+{o:04X} {ch!r}{extra}",
                        file=sys.stderr,
                    )
                    shown += 1
                    if shown >= 40:
                        print(f"{rel}: ... more non-ASCII omitted", file=sys.stderr)
                        break
                rc = 1
        checked += 1

    if rc == 0:
        print(
            f"source-hygiene OK ({checked} novel files; "
            f"ASCII except allowlist README.md/doc/vocabulary.md/doc/ascii-symbol-map.md; "
            f"no trailing whitespace)"
        )
    else:
        print(
            "source-hygiene FAILED: trailing whitespace and/or non-ASCII outside allowlist; "
            "try: script/check-source-hygiene.py --fix",
            file=sys.stderr,
        )
    return rc


if __name__ == "__main__":
    sys.exit(main())
