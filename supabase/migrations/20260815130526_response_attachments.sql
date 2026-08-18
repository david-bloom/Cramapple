-- TASK-0011 / TASK-0020 Program B: response image attachments.
--
-- TASK-0020's 2026-08-03 launch-readiness findings
-- (docs/research/TASK0020_LAUNCH_READINESS_FINDINGS_2026_08_03.md, Program B)
-- found that app.response_versions can only store response_text /
-- response_parts, so a captured hand-drawn photo became a text placeholder
-- string ("[hand-drawn capture submitted -- capture:<id>]") with no image
-- ever preserved. This migration adds the missing binding: one row per
-- uploaded object in storage.learner-uploads, bound to the exact response
-- version, attempt, and content-item version it was captured for.
--
-- This is schema + storage only (the approved first slice of Program B
-- remediation). It does not implement: the current-device capture UI, the
-- QR-materiality device matrix, automated capture-quality checks, or
-- submit_response gating on an accepted attachment for construction items
-- (that needs a content-classification flag that doesn't exist yet -- see
-- docs/tasks/TASK-0020-IMAGE-AND-DRAWN-RESPONSE-LAUNCH-READINESS.md). Those
-- remain open follow-ups; do not treat this migration as closing Program B.
--
-- Field vocabulary is intentionally narrower than the offline research
-- schema (scripts/drawn_response/schemas/capture_image_record.schema.json):
-- that schema also carries consent/provenance status for *ingesting other
-- people's* historical photos into a corpus, which doesn't apply to a
-- student's own live submission under product ToS. capture_quality_state
-- values match the session-contract vocabulary in
-- docs/research/HAND_DRAWN_CAPTURE_SESSION_CONTRACT_2026_08_03.md.

begin;

create table app.response_attachments (
  id uuid primary key default gen_random_uuid(),
  response_version_id uuid not null references app.response_versions(id) on delete cascade,
  attempt_id uuid not null references app.attempts(id) on delete cascade,
  content_item_version_id uuid not null references app.content_item_versions(id),
  kind text not null default 'original' check (kind in ('original', 'derived')),
  -- Retake lineage: only set on an 'original' row, and only for a retake
  -- (the first original for a response_version has this null).
  replaces_attachment_id uuid references app.response_attachments(id),
  -- True only for the currently-bound ORIGINAL of a response_version.
  -- Retaking flips the prior current row to false and inserts a new one;
  -- rows are never deleted, matching the session contract's "preserve the
  -- original for audit" invariant.
  is_current boolean not null default true,
  storage_bucket text not null default 'learner-uploads' check (storage_bucket = 'learner-uploads'),
  storage_path text not null,
  media_type text not null check (media_type in ('image/png', 'image/jpeg', 'image/webp')),
  byte_size integer not null check (byte_size > 0),
  pixel_width integer check (pixel_width is null or pixel_width > 0),
  pixel_height integer check (pixel_height is null or pixel_height > 0),
  sha256_digest text not null check (char_length(sha256_digest) = 64),
  -- 'pending' until a quality check (automated or learner-attested) runs.
  -- Submission-time gating on 'acceptable' is a Program B follow-up, not
  -- enforced by this migration.
  capture_quality_state text not null default 'pending'
    check (capture_quality_state in ('pending', 'acceptable', 'retake_required', 'indeterminate')),
  captured_by uuid not null references app.profiles(user_id),
  created_at timestamptz not null default now(),
  reviewed_at timestamptz,
  constraint response_attachments_storage_path_unique unique (storage_bucket, storage_path),
  constraint response_attachments_replaces_only_original check (
    replaces_attachment_id is null or kind = 'original'
  )
);

comment on table app.response_attachments is
  'Binds one uploaded image (storage.learner-uploads) to the exact response version, attempt, and content-item version it was captured for. Rows are immutable except capture_quality_state/is_current/reviewed_at (enforced by response_attachments_guard_immutable trigger below). ORIGINAL rows form a retake lineage via replaces_attachment_id; at most one row per response_version may have is_current = true (response_attachments_one_current_original). See docs/research/HAND_DRAWN_CAPTURE_SESSION_CONTRACT_2026_08_03.md.';

-- Session-contract invariant 8: "a capture-image original cannot be bound
-- to two capture sessions" -- enforced here as "at most one current
-- original per response_version".
create unique index response_attachments_one_current_original
  on app.response_attachments (response_version_id)
  where kind = 'original' and is_current;

create index response_attachments_response_version_id_idx
  on app.response_attachments (response_version_id);
create index response_attachments_attempt_id_idx
  on app.response_attachments (attempt_id);
create index response_attachments_content_item_version_id_idx
  on app.response_attachments (content_item_version_id);

-- Everything except capture_quality_state/is_current/reviewed_at is set
-- once at insert and never changes -- including for service_role, which
-- bypasses RLS but not this trigger. A retake is a new row, not a mutated
-- one.
create function app.response_attachments_guard_immutable_fields()
returns trigger
language plpgsql
as $$
begin
  if new.response_version_id is distinct from old.response_version_id
    or new.attempt_id is distinct from old.attempt_id
    or new.content_item_version_id is distinct from old.content_item_version_id
    or new.kind is distinct from old.kind
    or new.replaces_attachment_id is distinct from old.replaces_attachment_id
    or new.storage_bucket is distinct from old.storage_bucket
    or new.storage_path is distinct from old.storage_path
    or new.media_type is distinct from old.media_type
    or new.byte_size is distinct from old.byte_size
    or new.pixel_width is distinct from old.pixel_width
    or new.pixel_height is distinct from old.pixel_height
    or new.sha256_digest is distinct from old.sha256_digest
    or new.captured_by is distinct from old.captured_by
    or new.created_at is distinct from old.created_at
  then
    raise exception 'response_attachments: only capture_quality_state, is_current, and reviewed_at may change after insert (row %)', old.id;
  end if;
  return new;
end;
$$;

create trigger response_attachments_guard_immutable
  before update on app.response_attachments
  for each row execute function app.response_attachments_guard_immutable_fields();

alter table app.response_attachments enable row level security;

-- Learners read their own attachments; mirrors response_versions_owner_select.
create policy response_attachments_owner_select
  on app.response_attachments for select to authenticated
  using (
    exists (
      select 1 from app.attempts a
      where a.id = response_attachments.attempt_id
        and a.user_id = auth.uid()
    )
  );

-- No insert/update/delete policy for authenticated: every write goes
-- through the attempt-response edge function (attach_capture operation),
-- which validates the uploaded object server-side before writing with the
-- service role. Direct client writes would bypass that validation.
grant select on table app.response_attachments to authenticated;
grant select, insert, update, delete on table app.response_attachments to service_role;

-- Storage-layer immutability: once an object is bound to a response
-- attachment, its owner can no longer update or delete it directly via the
-- storage API (only unbound, abandoned uploads remain owner-mutable). This
-- closes the same gap at the storage layer that the app-layer trigger above
-- closes at the table layer.
drop policy if exists "learner_uploads_owner_update" on storage.objects;
create policy "learner_uploads_owner_update"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'learner-uploads'
  and split_part(name, '/', 1) = auth.uid()::text
  and not exists (
    select 1 from app.response_attachments ra
    where ra.storage_bucket = 'learner-uploads' and ra.storage_path = storage.objects.name
  )
)
with check (
  bucket_id = 'learner-uploads'
  and split_part(name, '/', 1) = auth.uid()::text
);

drop policy if exists "learner_uploads_owner_delete" on storage.objects;
create policy "learner_uploads_owner_delete"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'learner-uploads'
  and split_part(name, '/', 1) = auth.uid()::text
  and not exists (
    select 1 from app.response_attachments ra
    where ra.storage_bucket = 'learner-uploads' and ra.storage_path = storage.objects.name
  )
);

commit;
