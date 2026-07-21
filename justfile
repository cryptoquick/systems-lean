# Systems Lean -- task runner (https://github.com/casey/just)
# Default: list recipes (no silent no-op).

set shell := ["bash", "-euo", "pipefail", "-c"]

# List recipes (default when you run bare `just`).
default:
    @just --list

# Same suite as CI: every check we ship. Local and remote must match.
check:
    ./script/check-all.sh

# Freestanding Systems Lean product under src/systems/ (Slake host synthesis).
build:
    ./script/build-systems.sh

# Emit / refresh runtimeless freestanding C under out/freestanding-c.
out-freestanding-c:
    ./script/out-freestanding-c.sh

# LLVM IR release surface (deferred until self-hosted Systems Lean / Slake).
# Recipe reserved; fails closed with a clear message until post-self-host.
out-llvm-ir:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "out-llvm-ir: deferred until self-hosted Systems Lean in Slake (see out/llvm-ir/README.md)"
    exit 0


# Pre-commit path (also installed via script/git-hooks/pre-commit).
pre-commit:
    ./script/check-all.sh --staged

# One-shot progress meter -> doc/PROGRESS.md (+ guidance snapshots).
progress:
    python3 script/progress.py

# Poll sides every 300s (override: WATCH_INTERVAL=60 just watch).
watch:
    ./script/watch-forks.sh
