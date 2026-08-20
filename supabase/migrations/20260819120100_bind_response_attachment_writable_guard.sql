-- TASK-0016 Phase D Stage D2, rework pass 2: enforce "no writes to a submitted
-- response" INSIDE app.bind_response_attachment (Round-3 QA finding N7).
--
-- NOT APPLIED. Written, not run against Development or Production — same
-- boundary as 20260819120000_capture_pairing.sql.
--
-- WHY
-- ---
-- The capture-pairing bridge's safety claim — "an open (retake-eligible)
-- capability cannot corrupt a response that has since been submitted/graded" —
-- was, before this, enforced only by the edge function's
-- assertAttemptStillWritable check, which runs seconds before the bind (a
-- download + byte validation + storage fingerprinting + a vision call all sit
-- between the check and the write). Round 3 confirmed against live Production
-- that app.bind_response_attachment itself had NO is_submitted check — the
-- guarantee was a check-then-act race, not a database invariant. This adds the
-- check under the function's existing row lock so the guarantee holds for BOTH
-- callers of bind_response_attachment (the token-paired capture bridge AND the
-- authenticated attach_capture path in attempt-response), closing the window.
--
-- This is a `create or replace` of the function last defined in
-- 20260818011720_response_attachments_fixes.sql. The body is reproduced
-- verbatim from that migration with exactly one addition: the writability guard
-- at the top of the block. `create or replace` preserves the existing grants;
-- they are restated below for explicitness.

begin;

create or replace function app.bind_response_attachment(
  p_response_version_id uuid,
  p_attempt_id uuid,
  p_content_item_version_id uuid,
  p_kind text,
  p_replaces_attachment_id uuid,
  p_storage_path text,
  p_media_type text,
  p_byte_size integer,
  p_pixel_width integer,
  p_pixel_height integer,
  p_sha256_digest text,
  p_captured_by uuid
)
returns app.response_attachments
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_prior_current_id uuid;
  v_new_row app.response_attachments;
  v_writable boolean;
begin
  -- N7: DB-level enforcement of "the response must still be writable", under a
  -- row lock, BEFORE any attachment is written. This makes the guarantee an
  -- invariant of the write itself rather than an edge-function check-then-act
  -- window. A submitted response version, or an attempt no longer in an
  -- editable status, cannot receive a new (or superseding) attachment.
  select (rv.is_submitted = false and a.status in ('draft', 'failed'))
    into v_writable
  from app.response_versions rv
  join app.attempts a on a.id = rv.attempt_id
  where rv.id = p_response_version_id
  for update;

  if v_writable is null then
    raise exception using errcode = 'P0001',
      message = 'attach_capture:response_not_found';
  end if;
  if not v_writable then
    raise exception using errcode = 'P0001',
      message = 'attach_capture:response_not_writable';
  end if;

  if p_kind = 'original' then
    -- Lock any existing current original for this response_version so a
    -- second concurrent call for the same response_version blocks here
    -- instead of both racing past the is_current=true check below.
    select id into v_prior_current_id
    from app.response_attachments
    where response_version_id = p_response_version_id
      and kind = 'original'
      and is_current
    for update;

    if p_replaces_attachment_id is not null then
      if v_prior_current_id is null then
        raise exception using errcode = 'P0001',
          message = 'attach_capture:no_current_original_to_replace';
      end if;
      if v_prior_current_id is distinct from p_replaces_attachment_id then
        raise exception using errcode = 'P0001',
          message = 'attach_capture:stale_retake_target';
      end if;
    else
      if v_prior_current_id is not null then
        raise exception using errcode = 'P0001',
          message = 'attach_capture:original_already_current';
      end if;
    end if;

    if v_prior_current_id is not null then
      -- Supersede BEFORE inserting the new current row -- the ordering bug
      -- this migration fixes -- and in the same transaction as the insert
      -- below, so a failure either way rolls back both.
      update app.response_attachments
        set is_current = false
        where id = v_prior_current_id;
    end if;
  elsif p_replaces_attachment_id is not null then
    raise exception using errcode = 'P0001',
      message = 'attach_capture:derived_cannot_replace';
  end if;

  insert into app.response_attachments (
    response_version_id, attempt_id, content_item_version_id, kind,
    replaces_attachment_id, is_current, storage_path, media_type,
    byte_size, pixel_width, pixel_height, sha256_digest, captured_by
  ) values (
    p_response_version_id, p_attempt_id, p_content_item_version_id, p_kind,
    p_replaces_attachment_id, p_kind = 'original', p_storage_path,
    p_media_type, p_byte_size, p_pixel_width, p_pixel_height,
    p_sha256_digest, p_captured_by
  )
  returning * into v_new_row;

  return v_new_row;
end;
$$;

-- create or replace preserves privileges; restated for explicitness.
revoke all on function app.bind_response_attachment(
  uuid, uuid, uuid, text, uuid, text, text, integer, integer, integer, text, uuid
) from public;
grant execute on function app.bind_response_attachment(
  uuid, uuid, uuid, text, uuid, text, text, integer, integer, integer, text, uuid
) to service_role;

commit;
