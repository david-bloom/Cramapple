#!/usr/bin/env bash
# Apply the TASK-0077 migration to a throwaway database on a local Postgres and
# run the scenario tests. Never point this at Development or Production.
# Usage: PGHOST=127.0.0.1 PGPORT=55432 PGUSER=postgres scripts/task0077/run_sql_tests.sh
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/../.." && pwd)"
db="task0077_test_$$"
case "${PGHOST:-}" in
  127.0.0.1|localhost|"") ;;
  *) echo "refusing to run against non-local PGHOST=$PGHOST" >&2; exit 2 ;;
esac
psql -q -d postgres -c "create database $db"
trap 'psql -q -d postgres -c "drop database if exists $db"' EXIT
psql -q -d "$db" -v ON_ERROR_STOP=1 -f "$here/stub_schema.sql"
psql -q -d "$db" -v ON_ERROR_STOP=1 \
  -f "$repo/supabase/migrations/20261018191924_task0077_card_trial_orders.sql" \
  -f "$repo/supabase/migrations/20261018191935_task0077_trial_worker_invokers.sql" \
  -f "$repo/supabase/migrations/20261019142835_task0077_trial_qa_fixes.sql" \
  -f "$repo/supabase/migrations/20261020224101_task0077_trial_qa_round3.sql"
psql -q -d "$db" -v ON_ERROR_STOP=1 -f "$here/trial_orders_sql_test.sql" 2>&1 \
  | sed 's/^psql:[^ ]* //'

# Legacy backfill: a cardless trial_v1 user that exists before the migration
# must count as having used their trial (plan §6.11).
db2="${db}_legacy"
psql -q -d postgres -c "create database $db2"
trap 'psql -q -d postgres -c "drop database if exists $db"; psql -q -d postgres -c "drop database if exists $db2"' EXIT
psql -q -d "$db2" -v ON_ERROR_STOP=1 -f "$here/stub_schema.sql"
psql -q -d "$db2" -v ON_ERROR_STOP=1 -c "
  insert into auth.users values ('00000000-0000-0000-0000-0000000000aa', ' Legacy@Example.com');
  insert into app.profiles values ('00000000-0000-0000-0000-0000000000aa');
  insert into app.subjects (id, subject_key) values ('10000000-0000-0000-0000-0000000000aa', 'biology');
  insert into app.subject_entitlements (user_id, subject_id, access_tier, status, source, starts_at, ends_at)
  values ('00000000-0000-0000-0000-0000000000aa', '10000000-0000-0000-0000-0000000000aa',
          'trial', 'expired', 'trial_v1', now() - interval '30 days', now() - interval '23 days');"
psql -q -d "$db2" -v ON_ERROR_STOP=1 \
  -f "$repo/supabase/migrations/20261018191924_task0077_card_trial_orders.sql"
consumed="$(psql -At -d "$db2" -c "select app.trial_email_consumed('legacy@example.com')")"
[ "$consumed" = "t" ] || { echo "FAILED: legacy trial_v1 email not backfilled" >&2; exit 1; }
echo "ok: legacy trial_v1 email backfilled as consumed"
