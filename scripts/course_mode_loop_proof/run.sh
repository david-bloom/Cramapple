#!/usr/bin/env bash
# Course Mode — one-command Phase-2 loop proof runner (Dev).
#
# Wraps run_e2e_harness.ts so you don't have to juggle env vars. It:
#   - sets the public config (SB_URL + the legacy anon key),
#   - prompts ONCE for your Dev *legacy* service_role JWT (hidden input),
#   - installs @supabase/supabase-js (+ tsx for Node) and makes the throwaway
#     package.json ESM (the harness uses top-level await),
#   - runs the 10-cell serve → grade → confirm-transfer → promotion proof.
#
# Usage (from the Cramapple repo):
#   bash scripts/course_mode_loop_proof/run.sh
#
# To skip the prompt, export SB_SERVICE_ROLE_KEY beforehand.
# Prod is never touched; the harness provisions and deletes its own test student.
set -euo pipefail

# repo root = two levels up from this script (so it works from anywhere)
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

HARNESS="scripts/course_mode_loop_proof/run_e2e_harness.ts"
if [ ! -f "$HARNESS" ]; then
  echo "error: $HARNESS not found — run this from your Cramapple clone." >&2
  exit 1
fi

# ── public config (safe to embed) ──────────────────────────────────────────
export SB_URL="https://wmgjsdkphcyhngaffbqf.supabase.co"
export SB_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtZ2pzZGtwaGN5aG5nYWZmYnFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE5OTQ2NjMsImV4cCI6MjA5NzU3MDY2M30.jjIvM3h7JEFZi-pUDw3JnZEfapQ6e8Rzci7Ce1V8nTk"

# ── secret: legacy service_role JWT (prompt unless already set) ─────────────
if [ -z "${SB_SERVICE_ROLE_KEY:-}" ]; then
  echo "Paste your Dev LEGACY service_role key."
  echo "  Supabase dashboard → Project Settings → API keys → Legacy API keys → service_role"
  printf "service_role JWT: "
  read -rs SB_SERVICE_ROLE_KEY
  echo
  export SB_SERVICE_ROLE_KEY
fi

case "${SB_SERVICE_ROLE_KEY:-}" in
  eyJ*) : ;;  # looks like a JWT — good
  sb_*) echo "error: that is a new-format key (sb_...). This project's GoTrue needs the LEGACY service_role JWT (starts with eyJ...)." >&2; exit 1 ;;
  "")   echo "error: no key entered." >&2; exit 1 ;;
  *)    echo "warning: key doesn't look like a JWT (expected to start with eyJ...); continuing." >&2 ;;
esac

# ── toolchain: prefer bun, else node + tsx ─────────────────────────────────
if command -v bun >/dev/null 2>&1; then
  echo "→ installing @supabase/supabase-js (bun)…"
  bun add @supabase/supabase-js >/dev/null 2>&1 || bun add @supabase/supabase-js
  echo "→ running the loop proof (bun)…"
  exec bun run "$HARNESS"
fi

if command -v node >/dev/null 2>&1; then
  NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)"
  if [ "${NODE_MAJOR:-0}" -lt 18 ]; then
    echo "error: Node $(node -v 2>/dev/null) is too old — need Node ≥18 (global fetch). Try: brew install node" >&2
    exit 1
  fi
  echo "→ installing @supabase/supabase-js + tsx (npm)…"
  npm i @supabase/supabase-js tsx >/dev/null 2>&1 || npm i @supabase/supabase-js tsx
  npm pkg set type=module >/dev/null 2>&1 || true   # harness uses top-level await → ESM
  echo "→ running the loop proof (node + tsx)…"
  exec npx tsx "$HARNESS"
fi

echo "error: neither bun nor node found. Install Node ≥18 (e.g. brew install node) and re-run." >&2
exit 1
