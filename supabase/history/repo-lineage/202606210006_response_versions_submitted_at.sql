-- Add submitted_at to app.response_versions so the new submit-response
-- Edge Function (introduced on the same branch as this migration) can
-- record when each response_version transitioned to is_submitted = true.
--
-- The column is nullable: existing rows pre-dating this migration carry
-- NULL. New rows still default is_submitted = false / submitted_at = NULL.
-- submit-response sets both atomically.

begin;

alter table app.response_versions
  add column if not exists submitted_at timestamptz;

-- Backfill best-effort: if any historical rows already have
-- is_submitted = true, set submitted_at to updated_at as the closest
-- available timestamp. New code paths will use now() at the moment of
-- submission, so backfilled rows are explicitly flagged by the comment.
update app.response_versions
set submitted_at = updated_at
where is_submitted = true and submitted_at is null;

comment on column app.response_versions.submitted_at is
  'Timestamp when is_submitted transitioned to true. Backfilled rows may use updated_at as an approximation; new rows always use the actual submission moment.';

commit;
