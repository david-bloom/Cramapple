-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260628193927
-- recorded name: assignments_staging_bridge
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Staging bridge: keep review assignments alive during content ingestion.
begin;

-- 1. Rename PKs and FK columns
alter table app.content_review_assignments
  rename column id to content_review_assignment_id;

alter table app.content_review_decisions
  rename column id to content_review_decision_id;

alter table app.content_review_decisions
  rename column assignment_id to content_review_assignment_id;

-- 2. Make content_item_version_id nullable
alter table app.content_review_assignments
  alter column content_item_version_id drop not null;

alter table app.content_review_decisions
  alter column content_item_version_id drop not null;

-- 3. Add ingest_row_id to assignments
alter table app.content_review_assignments
  add column if not exists ingest_row_id uuid
    references app.content_ingest_rows(ingest_row_id) on delete set null;

create index if not exists cra_ingest_row_idx
  on app.content_review_assignments (ingest_row_id)
  where ingest_row_id is not null;

-- 4. Add review_kind to assignments
alter table app.content_review_assignments
  add column if not exists review_kind text
    check (review_kind is null or review_kind in ('frq', 'mcq'));

-- 5. Fix unique constraint
alter table app.content_review_assignments
  drop constraint if exists cra_unique_active_assignment;

create unique index if not exists cra_unique_by_ingest_row
  on app.content_review_assignments (ingest_row_id, reviewer_id, review_stage)
  where ingest_row_id is not null;

create unique index if not exists cra_unique_by_content_version
  on app.content_review_assignments (content_item_version_id, reviewer_id, review_stage)
  where content_item_version_id is not null;

-- 6. Add frq_form to content_ingest_rows
alter table app.content_ingest_rows
  add column if not exists frq_form text
    check (frq_form is null or frq_form in ('short', 'long'));

commit;
