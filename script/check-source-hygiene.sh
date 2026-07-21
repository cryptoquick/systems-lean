#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Wrapper so hooks and docs can call a stable path.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
exec python3 "$root/script/check-source-hygiene.py" "$@"
