#!/usr/bin/env bash
# SessionStart hook for The Operator's Brief.
# Runs when a scheduled session starts. Guarantees the working files exist
# even on a fresh container clone, so the daily prompt never fails on a
# missing ./editions/ or ./watchlist.md.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
mkdir -p "$REPO_ROOT/editions"

if [ ! -f "$REPO_ROOT/watchlist.md" ]; then
  cat > "$REPO_ROOT/watchlist.md" <<'EOF'
# Watchlist — unresolved items rolled forward between editions
# Format: - [ ] <item> — flagged <date>, why it matters, what would resolve it
EOF
fi

echo "Operator's Brief workspace ready at $REPO_ROOT"
