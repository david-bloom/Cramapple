#!/usr/bin/env bash
# File-faithful applier for the TASK-0017 / publication migration batch on the
# DEVELOPMENT Supabase project. Applies the exact repo migration files via psql
# (no hand-transcription), then records each version in
# supabase_migrations.schema_migrations so a future `db push` treats them as
# applied.
#
# Connection: read from CRAMAPPLE_DEV_DB_URL (a full postgres connection string).
# Provide it OUT OF BAND — never paste it into chat. Either:
#   export CRAMAPPLE_DEV_DB_URL='postgresql://...'      # in this shell, or
#   put it in scripts/dev-migration-apply/dev.secrets.env  (gitignored)
# The script never prints the connection string.
#
# Safety: refuses to run unless the Dev-only Phase-A migration markers are
# present (Production does not have them), so it cannot target Production by
# accident.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
MIG="$REPO/supabase/migrations"

# 1. Load the connection (env var wins; else the gitignored secrets file).
if [ -z "${CRAMAPPLE_DEV_DB_URL:-}" ] && [ -f "$HERE/dev.secrets.env" ]; then
  # shellcheck disable=SC1091
  set +x; . "$HERE/dev.secrets.env"; set +x
fi
if [ -z "${CRAMAPPLE_DEV_DB_URL:-}" ]; then
  echo "ERROR: CRAMAPPLE_DEV_DB_URL is not set (env var or dev.secrets.env)." >&2
  echo "See scripts/dev-migration-apply/README.md." >&2
  exit 2
fi

PSQL=(psql "$CRAMAPPLE_DEV_DB_URL" -v ON_ERROR_STOP=1 -X -q)

# 2. Dev-only interlock: the task0016_phase_a_* markers exist ONLY on Dev.
markers="$("${PSQL[@]}" -tAc \
  "select count(*) from supabase_migrations.schema_migrations where name like 'task0016_phase_a_%'")"
dbname="$("${PSQL[@]}" -tAc "select current_database()")"
if [ "${markers:-0}" -lt 1 ]; then
  echo "REFUSING: target does not look like Development (0 task0016_phase_a_* markers)." >&2
  echo "This interlock prevents accidentally targeting Production." >&2
  exit 3
fi
echo "Connected to database '$dbname' with $markers Phase-A marker(s) -> Development confirmed."
echo

# 3. The ordered TASK-0017 / publication batch (deferred items intentionally omitted).
MIGRATIONS=(
  "202607090001_curated_public_interface"
  "202607090002_curated_public_interface_revoke_anon"
  "202607130001_atomic_content_publication"
  "20260713172806_task0017_h1_h2_subject_harness_persistence"
  "20260713172817_task0017_h3_h5_validation_and_exceptions"
)

for stem in "${MIGRATIONS[@]}"; do
  file="$MIG/$stem.sql"
  version="${stem%%_*}"
  name="${stem#*_}"
  [ -f "$file" ] || { echo "ERROR: missing $file" >&2; exit 4; }

  already="$("${PSQL[@]}" -tAc \
    "select count(*) from supabase_migrations.schema_migrations where version='$version'")"
  if [ "${already:-0}" -ge 1 ]; then
    echo "SKIP  $version ($name) — already recorded."
    continue
  fi

  echo "APPLY $version ($name) ..."
  "${PSQL[@]}" -f "$file"                     # file carries its own begin/commit
  "${PSQL[@]}" -c \
    "insert into supabase_migrations.schema_migrations(version,name) values ('$version','$name') on conflict (version) do nothing"
  echo "  recorded $version"
done

echo
echo "Batch applied. Next: run scripts/dev-migration-apply/verify.sql for evidence."
