-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124601
-- recorded name: response_versions_submitted_at
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

begin;

alter table app.response_versions
  add column if not exists submitted_at timestamptz;

update app.response_versions
set submitted_at = updated_at
where is_submitted = true and submitted_at is null;

comment on column app.response_versions.submitted_at is
  'Timestamp when is_submitted transitioned to true. Backfilled rows may use updated_at as an approximation; new rows always use the actual submission moment.';

commit;
