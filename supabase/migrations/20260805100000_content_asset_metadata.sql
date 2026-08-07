-- TASK-0021 — Biology Prompt-Visual Student Delivery.
-- Task: docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md
--
-- Approved home for accessible alt / long-description text on prompt visuals.
-- Decision: David Bloom, 2026-08-05, choosing a dedicated table over a
-- prompt_json key and over new content_item_versions columns. Rationale
-- recorded in the task's Technical Scope: the Acceptance Criteria require
-- *approved* accessibility text, and neither alternative can record who
-- approved it; content_item_versions is additionally marked a deprecated
-- compatibility projection in the schema baseline.
--
-- This table also carries the student-visibility gate. approved_at IS NULL
-- means "QA-visible, not student-visible": staff/QA identities may render the
-- asset to exercise the delivery path, but the student serving path must
-- fail closed and omit the item. That deliberately unifies three separate
-- Acceptance Criteria into one server-side check -- missing accessibility
-- text, un-reviewed content, and fail-closed omission are all the same
-- condition, so none of them can be satisfied by accident while another is
-- skipped.
--
-- Learning Quality construct-equivalence review for the 8 construct-sensitive
-- Biology items is NOT granted by this migration. It creates the place that
-- review gets recorded; the review itself is a separate Acceptance Criterion
-- and no row here is seeded as approved.

begin;

create table if not exists app.content_asset_metadata (
  content_asset_metadata_id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,
  storage_bucket text not null default 'content-assets',
  storage_path text not null,
  -- Short accessible name. Required: an asset with no alt text is not
  -- deliverable to a student under this task's Acceptance Criteria.
  alt_text text not null,
  -- Extended description for visuals carrying data a student must read to
  -- answer (charts, tables, micrographs). Optional -- not every visual needs
  -- one -- but when the visual is construct-bearing it is expected.
  long_description text,
  -- Non-null approved_at is what makes the asset student-visible. Never
  -- backfill this without the corresponding Learning Quality record.
  approved_by uuid,
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint content_asset_metadata_unique_asset
    unique (content_item_version_id, storage_bucket, storage_path),
  constraint content_asset_metadata_alt_text_check
    check (char_length(btrim(alt_text)) > 0),
  constraint content_asset_metadata_path_check
    check (
      char_length(btrim(storage_path)) > 0
      and storage_path !~ '^/'
      and storage_path !~ '\.\.'
      and storage_path !~ '//'
    ),
  -- Approval is a single fact: who and when, together or neither. This stops
  -- a half-written approval from reading as student-visible.
  constraint content_asset_metadata_approval_pairing_check
    check (num_nonnulls(approved_by, approved_at) <> 1)
);

comment on table app.content_asset_metadata is
  'Approved accessibility metadata and student-visibility gate for prompt visuals. approved_at IS NULL means QA-visible but not student-visible.';

comment on column app.content_asset_metadata.approved_at is
  'Non-null only when Learning Quality has recorded construct-equivalence/accessibility approval for this asset. The student serving path requires this; QA/staff paths do not.';

create index if not exists content_asset_metadata_version_idx
  on app.content_asset_metadata (content_item_version_id);

-- Partial index for the student serving path, which only ever reads approved
-- rows.
create index if not exists content_asset_metadata_approved_idx
  on app.content_asset_metadata (content_item_version_id)
  where approved_at is not null;

alter table app.content_asset_metadata enable row level security;
alter table app.content_asset_metadata force row level security;
revoke all on app.content_asset_metadata from public, anon, authenticated;
grant select, insert, update, delete on app.content_asset_metadata to service_role;

-- Students never read this table directly; the student-session-items Edge
-- Function reads it with the service role and returns only the alt/long
-- description strings for items that student is actually being served. No
-- authenticated-role grant is added, deliberately -- a direct grant would let
-- a student enumerate accessibility text for unpublished or unapproved
-- content.

create or replace function app.touch_content_asset_metadata()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists content_asset_metadata_touch on app.content_asset_metadata;
create trigger content_asset_metadata_touch
  before update on app.content_asset_metadata
  for each row execute function app.touch_content_asset_metadata();

commit;
