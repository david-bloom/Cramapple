# TASK-0077 SQL tests

Scenario tests for `supabase/migrations/20261018191924_task0077_card_trial_orders.sql`
and its QA follow-up `20261019141829_task0077_trial_qa_fixes.sql` (7-day card trial order engine, plan v3 §6). They run on a **throwaway local
Postgres** against minimal stand-ins for the tables the migration touches
(`stub_schema.sql`), never against Development or Production.

```bash
initdb -D /some/dir -U postgres --auth=trust
LC_ALL=en_US.UTF-8 pg_ctl -D /some/dir -o "-p 55432 -k '' -c listen_addresses=127.0.0.1" start
PGHOST=127.0.0.1 PGPORT=55432 PGUSER=postgres scripts/task0077/run_sql_tests.sh
```

The runner refuses a non-local `PGHOST`. It covers activation and replay, one trial per
email, the pending-order limit, decline → grace → retry → 30-day recovery → conversion,
partial and full refunds, the our-fault delay rule, cancel (including a late success that
must be refunded), parent-pay acceptance and two-recipient notices, a parent with two
children, amount mismatch, learner-deletion protection, disputes, a full refund that arrives
before the success event, a delayed charge gated on its notice being sent, the parent cancel
link surviving an unfinished settlement, and the legacy `trial_v1` backfill.
