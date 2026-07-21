#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense
# Poll side progress every INTERVAL seconds; update meter + fork guidance snapshots.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

INTERVAL="${WATCH_INTERVAL:-300}"
LOG="${WATCH_LOG:-doc/progress-log.md}"

mkdir -p .cache
touch "$LOG"

if [[ ! -s "$LOG" ]]; then
  cat >"$LOG" <<'EOF'
# Fork progress log

Append-only cycle notes from `just watch` / `script/watch-forks.sh`.
ASCII only.

EOF
fi

echo "watch-forks: interval=${INTERVAL}s  log=$LOG  (Ctrl-C to stop)"
echo "progress once, then loop..."

cycle=0
while true; do
  cycle=$((cycle + 1))
  ts=$(date -Is 2>/dev/null || date)
  echo ""
  echo "======== watch cycle $cycle @ $ts ========"

  set +e
  python3 script/progress.py --watch-update-state
  prog_rc=$?
  set -e

  overall=$(python3 script/progress.py --json 2>/dev/null | python3 -c 'import sys,json; print(json.load(sys.stdin)["pct_overall"])' 2>/dev/null || echo "?")

  # hygiene as honest gate (non-fatal for watch)
  set +e
  python3 script/check-source-hygiene.py --walk >/tmp/systems-lean-hyg.txt 2>&1
  hyg_rc=$?
  set -e
  hyg_line=$(tail -n 1 /tmp/systems-lean-hyg.txt 2>/dev/null || echo hygiene-unknown)

  {
    echo "## cycle $cycle -- $ts"
    echo ""
    echo "- progress.py rc=$prog_rc overall_pct=$overall"
    echo "- hygiene rc=$hyg_rc -- $hyg_line"
    echo "- see doc/PROGRESS.md and side RESIDUAL-*.md"
    echo ""
  } >>"$LOG"

  echo "log append -> $LOG"
  echo "guidance snapshots refreshed under doc/fork-guidance-*.md"
  echo "sleeping ${INTERVAL}s..."
  sleep "$INTERVAL"
done
