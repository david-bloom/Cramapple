# APPROVAL-0184 — Remove the ungated ten-subject More help migration; repair Production ledger (2026-10-16)

**Approver:** David Bloom (chat, 2026-10-16: "I authorize the cleanup").
**Numbering note:** 0181–0183 live on other branches (#476 and the Statistics launch branch), not `main`; 0184 chosen to avoid reuse. Renumber on merge if needed.

## What was done
1. **Repo:** deleted `supabase/migrations/20261015232212_more_help_all_subjects.sql` (the superseded ungated ten-subject function, merged to `main` by PR #475 in error of the session-close instruction). Production's ledger never contained it; it was never applied to Production.
2. **Production ledger (read-verified first):** the policy table, four policy rows (AB, BC, Chemistry all units; Statistics 1–3) and `reserve_question_help_delivery` md5 `582930f351d7fbd7b9ad01a2bc8adccb` (= tested Development function) were confirmed live. Two migrations applied earlier via `supabase db query` had no ledger rows; inserted `20261015175446 more_help_question_grounding` and `20261016000100 more_help_unit_gated_policy` into `supabase_migrations.schema_migrations` (`ON CONFLICT DO NOTHING`; rows only, no schema or data change, no statements stored).
3. **Left alone:** `20261015175807_restore_taxonomy_hash_for_development_qa.sql` is still unrecorded in Production. It is guarded (`if to_regprocedure(...) is null`) and the helper already exists in Production, so a future `db push` would be a no-op for it.

## Rollback
`delete from supabase_migrations.schema_migrations where version in ('20261015175446','20261016000100');` (ledger only). The deleted file is recoverable from git history.
