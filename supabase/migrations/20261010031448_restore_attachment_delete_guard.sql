-- TASK-0069: restore the delete branch of
-- app.response_attachments_guard_immutable_fields().
--
-- 20261009230918_frq_photo_responses_attachments recreated this function from
-- the 2026-08-15 definition and dropped the `tg_op = 'DELETE'` branch added by
-- 20260818011720_response_attachments_fixes. Deletes stayed blocked (the
-- column comparisons against a NULL NEW row still raised, and a BEFORE DELETE
-- trigger returning NEW = NULL cancels the delete), but with the wrong error
-- and by accident. Found by the Production pre-apply capture on 2026-10-10;
-- the 20261009230918 file is corrected for any database that has not run it,
-- and this migration repairs Development, where it already ran. On a database
-- that ran the corrected file it is a no-op re-statement.
create or replace function app.response_attachments_guard_immutable_fields()
returns trigger
language plpgsql
set search_path = 'app', 'pg_catalog'
as $$
begin
  if tg_op = 'DELETE' then
    raise exception 'response_attachments: rows are never deleted (row %); retakes supersede via is_current instead', old.id;
  end if;

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
