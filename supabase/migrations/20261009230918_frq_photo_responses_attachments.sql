-- Hand-drawn responses on every FRQ -- attachments, retention, same-device
-- capture (plan §4, §6; DECISION-0109 same-device, DECISION-0111 retention).
--
-- 1. Retention by REDACTION, not deletion. app.response_attachments is
--    immutable by trigger (TASK-0025) and must stay so for grading-dispute and
--    audit integrity; the privacy policy promises retention "as long as
--    needed" and deletion requests "subject to operational constraints".
--    DECISION-0111 resolves the two: image bytes are removed, the row (with
--    its digest, dimensions, and grading record) survives, and `redacted_at`
--    records when. The only write the immutability trigger now permits beyond
--    the three existing mutable columns is a single null -> timestamp
--    transition on `redacted_at`, through app.redact_response_attachment().
--    The bytes themselves are removed by the service role through the Storage
--    API (attempt-response `redact_attachment`), which is why this is a
--    function the operator calls, not a trigger.
-- 2. The age rule (24 months after the attempt, or on account deletion /
--    erasure request) is exposed as app.response_attachments_due_for_redaction()
--    for the sweep; scheduling the sweep through a function invoker (the BYOQ
--    purge pattern) is a follow-up noted in the plan, not part of this
--    migration. Nothing is due for 24 months.
-- 3. capture_pairing_tokens.access_path gains 'SAME_DEVICE' (DECISION-0109):
--    the student's phone is the primary device and runs the phone leg itself.

-- ---------------------------------------------------------------------------
-- 1. redacted_at + immutability trigger
-- ---------------------------------------------------------------------------
alter table app.response_attachments
  add column if not exists redacted_at timestamptz;

comment on column app.response_attachments.redacted_at is
  'Set once, when the image bytes (original and derived) were removed from storage under the retention rule or an erasure request (DECISION-0111). The row, digest, dimensions, and grading records are kept for audit. Written only by app.redact_response_attachment().';

create or replace function app.response_attachments_guard_immutable_fields()
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
    raise exception 'response_attachments: only capture_quality_state, is_current, reviewed_at, and a one-time redacted_at may change after insert (row %)', old.id;
  end if;
  -- redacted_at: null -> timestamp exactly once; never cleared or moved.
  if old.redacted_at is not null and new.redacted_at is distinct from old.redacted_at then
    raise exception 'response_attachments: redacted_at is set once and cannot change (row %)', old.id;
  end if;
  return new;
end;
$$;

create or replace function app.redact_response_attachment(p_attachment_id uuid)
returns app.response_attachments
language plpgsql
security definer
set search_path = 'app', 'pg_temp'
as $$
declare
  v_row app.response_attachments;
begin
  update app.response_attachments
     set redacted_at = now()
   where id = p_attachment_id
     and redacted_at is null
  returning * into v_row;
  if v_row.id is null then
    select * into v_row from app.response_attachments where id = p_attachment_id;
    if v_row.id is null then
      raise exception 'redact_response_attachment:not_found' using errcode = 'P0002';
    end if;
  end if;
  return v_row;
end;
$$;

revoke all on function app.redact_response_attachment(uuid) from public, anon, authenticated;
grant execute on function app.redact_response_attachment(uuid) to service_role;

comment on function app.redact_response_attachment(uuid) is
  'Stamps redacted_at on one attachment row (idempotent). The caller (service role, attempt-response redact_attachment) removes the storage objects first. DECISION-0111.';

create or replace function app.response_attachments_due_for_redaction(p_older_than interval default interval '24 months')
returns setof uuid
language sql
stable
security definer
set search_path = 'app', 'pg_temp'
as $$
  select ra.id
    from app.response_attachments ra
    join app.attempts a on a.id = ra.attempt_id
   where ra.redacted_at is null
     and coalesce(a.submitted_at, a.created_at) < now() - p_older_than
   order by coalesce(a.submitted_at, a.created_at);
$$;

revoke all on function app.response_attachments_due_for_redaction(interval) from public, anon, authenticated;
grant execute on function app.response_attachments_due_for_redaction(interval) to service_role;

comment on function app.response_attachments_due_for_redaction(interval) is
  'Attachment ids whose attempt is older than the retention window (default 24 months, DECISION-0111) and whose bytes have not been redacted. Consumed by the retention sweep.';

-- ---------------------------------------------------------------------------
-- 2. Same-device access path
-- ---------------------------------------------------------------------------
alter table app.capture_pairing_tokens
  drop constraint if exists capture_pairing_tokens_access_path_check;
alter table app.capture_pairing_tokens
  add constraint capture_pairing_tokens_access_path_check
  check (access_path is null or access_path in ('QR', 'FALLBACK_DIRECT', 'SAME_DEVICE'));

comment on column app.capture_pairing_tokens.access_path is
  'How the phone leg was reached: QR (scanned from a desktop), FALLBACK_DIRECT (typed URL), SAME_DEVICE (the student''s phone minted and used the pairing itself; DECISION-0109).';
