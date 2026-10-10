-- TASK-0069 Production rollback reference: pg_get_functiondef() of every function the
-- seven TASK-0069 migrations replace, captured from Production pcntajvbdfqhbeewmdry on
-- 2026-10-10 BEFORE the apply. md5 values are Production's own md5(pg_get_functiondef()).
-- public.select_student_practice_items (md5 be88bb92a688e6d750ac45389d2d1f02) is NOT
-- restated here: its pre-apply body is identical to
-- supabase/migrations/20261008113000_student_practice_queue_selector.sql (re-apply that
-- file's function, after DROP FUNCTION, to roll the selector back).

-- app.claim_capture_pairing_upload md5 9f25501b9ba2b408da71946d52f9dc41 (match on transcription)
CREATE OR REPLACE FUNCTION app.claim_capture_pairing_upload(p_handle_sha256 text, p_max_attempts integer, p_access_path text DEFAULT NULL::text)
 RETURNS app.capture_pairing_tokens
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app', 'public'
AS $function$
declare
  v_row app.capture_pairing_tokens;
begin
  select * into v_row
  from app.capture_pairing_tokens
  where handle_sha256 = p_handle_sha256
  for update;

  if v_row.id is null then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:not_found';
  end if;

  -- Already-terminal capabilities: nothing to record, so raise directly.
  if v_row.state = 'consumed' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:already_used';
  end if;
  if v_row.state = 'cancelled' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:cancelled';
  end if;
  if v_row.state = 'rejected' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:rejected';
  end if;
  if v_row.state = 'expired' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:expired';
  end if;

  -- Just-now-terminal transitions COMMIT their bookkeeping by RETURNING the
  -- updated row rather than raising. A `RAISE` here would abort the function's
  -- own transaction and roll the UPDATE back -- the original defect, which
  -- made `state = 'rejected'` unreachable dead code and the "record the
  -- expiry" comment false. The caller distinguishes these from a live claim by
  -- inspecting the returned `state` (a live claim returns 'paired'/'uploaded').
  if v_row.expires_at <= now() then
    update app.capture_pairing_tokens
      set state = 'expired', closed_at = coalesce(closed_at, now())
      where id = v_row.id
      returning * into v_row;
    return v_row;
  end if;
  if v_row.redemption_attempts >= p_max_attempts then
    update app.capture_pairing_tokens
      set state = 'rejected', closed_at = coalesce(closed_at, now())
      where id = v_row.id
      returning * into v_row;
    return v_row;
  end if;

  update app.capture_pairing_tokens
    set redemption_attempts = redemption_attempts + 1,
        state = case when state = 'issued' then 'paired' else state end,
        paired_at = coalesce(paired_at, now()),
        access_path = coalesce(access_path, p_access_path)
    where id = v_row.id
    returning * into v_row;

  return v_row;
end;
$function$;

-- app.response_attachments_guard_immutable_fields md5 06b3e32c6b5143033add0ba7e3b2c954 (match on transcription)
CREATE OR REPLACE FUNCTION app.response_attachments_guard_immutable_fields()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'app', 'pg_catalog'
AS $function$
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
    raise exception 'response_attachments: only capture_quality_state, is_current, and reviewed_at may change after insert (row %)', old.id;
  end if;
  return new;
end;
$function$;

-- app.tg_require_practice_format_at_publish md5 d86202afd6859dc4ec0a0b94898790b5 (match on transcription)
CREATE OR REPLACE FUNCTION app.tg_require_practice_format_at_publish()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app', 'pg_temp'
AS $function$
declare
  v_hand_drawn boolean;
begin
  if new.status = 'published'
     and old.status is distinct from 'published'
     and new.item_type = 'frq'
     and new.practice_format is null
  then
    select coalesce((civ.prompt_json ->> 'hand_drawn')::boolean, false)
      into v_hand_drawn
    from app.content_item_versions civ
    where civ.content_item_id = new.id
      and civ.status = 'published'
    order by civ.version_num desc
    limit 1;

    if not coalesce(v_hand_drawn, false) then
      raise exception
        'practice_format_required_at_publish: FRQ % (content_key %) cannot publish with practice_format IS NULL — set targeted_drill or full_exam_frq before publishing, or confirm it is a hand-drawn item (prompt_json.hand_drawn = true) if it should stay unreachable via select_practice_frqs',
        new.id, new.content_key;
    end if;
  end if;
  return new;
end;
$function$;
