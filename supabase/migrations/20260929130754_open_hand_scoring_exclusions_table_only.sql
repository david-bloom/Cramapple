-- TASK-0051 hotfix — create app.open_hand_scoring_exclusions ONLY (option A, approved
-- by David 2026-09-29 for Development and Production).
--
-- Why this exists: evaluate-attempt v67 (the TASK-0053 MCQ-feedback deploy) was
-- deployed from a main that already carried TASK-0051's scoring-exclusion check.
-- That check selects from app.open_hand_scoring_exclusions before grading and
-- returns HTTP 500 open_hand_eligibility_check_failed on any error. Production had
-- no such table (only 20260929034129, applied to Development, creates it), so every
-- graded submission in Production would have failed.
--
-- This file is the table section of
-- 20260929034129_open_hand_entitlement_scoped_contract.sql, copied verbatim, and
-- nothing else. It deliberately does NOT create public.get_open_hand_item: that
-- RPC discloses answer keys to students and stays behind TASK-0051's QA and
-- Production gate. An empty table means evaluate-attempt finds no exclusion and
-- grades normally.
--
-- Every statement is guarded or idempotent, so:
--   * on Development (table already present from 20260929034129) it is a no-op;
--   * when 20260929034129 is later applied to Production, its table section is a
--     no-op on top of this file.
--
-- Rollback: drop table app.open_hand_scoring_exclusions; (only while it is empty
-- and before 20260929034129 is applied to Production; evaluate-attempt v67 will
-- then fail again, so roll back evaluate-attempt first).
--
-- No explicit begin/commit: apply_migration and `db push` each run a migration in
-- one transaction, and leaving them out keeps this file byte-identical to what
-- supabase_migrations.schema_migrations records.

create table if not exists app.open_hand_scoring_exclusions (
  user_id uuid not null references auth.users(id) on delete cascade,
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,
  learning_session_id uuid
    references app.learning_sessions(id) on delete restrict,
  disclosed_at timestamptz not null default now(),
  primary key (user_id, content_item_version_id)
);

alter table app.open_hand_scoring_exclusions
  alter column learning_session_id drop not null;

alter table app.open_hand_scoring_exclusions
  add column if not exists content_item_id uuid
    references app.content_items(id) on delete cascade;

-- Backfill any pre-existing rows (Development had 0 as of 2026-09-29, so this is
-- a no-op there; it is written to be correct rather than to rely on that).
update app.open_hand_scoring_exclusions ohse
set content_item_id = civ.content_item_id
from app.content_item_versions civ
where civ.id = ohse.content_item_version_id
  and ohse.content_item_id is null;

alter table app.open_hand_scoring_exclusions
  alter column content_item_id set not null;

-- The scoring check is by (user, item), so index it that way.
create index if not exists open_hand_scoring_exclusions_user_item_idx
  on app.open_hand_scoring_exclusions (user_id, content_item_id);

comment on table app.open_hand_scoring_exclusions is
  'Permanent per-user scoring exclusions, created atomically when '
  'get_open_hand_item discloses an answer key. Keyed on content_item_id as well '
  'as content_item_version_id: evaluate-attempt rejects on ITEM id, so '
  'republishing an item cannot restore scorability for a student who has seen '
  'its key. learning_session_id is nullable because access is entitlement-scoped '
  '(DECISION-0086) and a caller need not be in a session. Staff/QA callers are '
  'exempt and write no row. evaluate-attempt rejects matches with HTTP 409 and '
  'error=open_hand_item_not_scorable before reading any answer-key table.';

alter table app.open_hand_scoring_exclusions enable row level security;
alter table app.open_hand_scoring_exclusions force row level security;

revoke all on app.open_hand_scoring_exclusions
  from public, anon, authenticated;
grant select on app.open_hand_scoring_exclusions to service_role;

notify pgrst, 'reload schema';
