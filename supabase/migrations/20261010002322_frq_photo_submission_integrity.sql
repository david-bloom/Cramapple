-- Hand-drawn responses on every FRQ -- submission integrity
-- (TASK-0069; remediation of docs/qa/QA_TASK0069_CODEX_2026_10_09.md).
--
-- Codex QA P1-a: the confirmation was bound to the photo but not to the
--   answer text. An owner may update an unsubmitted response version directly
--   (response_versions_owner_update_draft), so a student could confirm answer
--   A, PATCH response_text to B, and submit B.
-- Codex QA P1-b: the confirmation check ran in the Edge Function BEFORE the
--   submit RPC, outside its transaction; a retake could commit in between.
--   (A second public function, `submit-response`, also calls
--   app.submit_response directly and never ran the Edge check at all.)
-- Codex QA P2-a: a photo_required item could be submitted typed-only.
--
-- Fix: the rule moves INTO the database, on the one write every submit path
-- makes. A BEFORE UPDATE trigger on app.response_versions fires on the
-- is_submitted false -> true transition, i.e. inside app.submit_response's
-- transaction AFTER it has locked the attempt and the response version.
-- app.bind_response_attachment takes the same attempt lock first, so a
-- retake either commits before the trigger reads the attachment (and is
-- seen) or waits until the submit commits (and is then refused by the bind
-- writable guard). The trigger requires, when a current original photo is
-- bound:
--   * _confirmed_at present,
--   * _confirmed_digest = the current original's sha256_digest, and
--   * _confirmed_content_digest = a digest of the CURRENT response_text and
--     non-reserved response_parts, recomputed here.
-- When no photo is bound and the item is photo_required, it refuses.
-- Confirmation itself is one SQL function (app.confirm_response_transcript)
-- that locks attempt -> response version, checks the photo digest, writes
-- the confirmed text, and stores the content digest computed server-side.

-- ---------------------------------------------------------------------------
-- Canonical content digest: response_text + every non-reserved part key.
-- jsonb's text form is canonical (keys are stored sorted), so the same
-- content always yields the same digest.
-- ---------------------------------------------------------------------------
create or replace function app.response_content_digest(p_text text, p_parts jsonb)
returns text
language sql
immutable
set search_path = 'pg_catalog'
as $$
  select encode(
    sha256(convert_to(
      coalesce(p_text, '') || chr(31) ||
      coalesce(
        (select jsonb_object_agg(e.key, e.value)
           from jsonb_each(case when jsonb_typeof(p_parts) = 'object' then p_parts else '{}'::jsonb end) e
          where e.key not like '\_%' escape '\'
            and e.key <> 'capture'),
        '{}'::jsonb
      )::text,
      'UTF8')),
    'hex');
$$;

comment on function app.response_content_digest(text, jsonb) is
  'sha256 of response_text and the non-reserved response_parts keys. Stored as _confirmed_content_digest at confirmation and recomputed at submission (TASK-0069 QA P1-a).';

-- ---------------------------------------------------------------------------
-- Confirmation, atomically, under the attempt -> response lock order.
-- SECURITY INVOKER: called by the service role; the reserved-keys trigger
-- recognises the service role by current_user.
-- ---------------------------------------------------------------------------
create or replace function app.confirm_response_transcript(
  p_attempt_id uuid,
  p_response_version_id uuid,
  p_actor_id uuid,
  p_parts jsonb,
  p_response_text text,
  p_student_added jsonb,
  p_photo_digest text,
  p_confirmed_at timestamptz
)
returns app.response_versions
language plpgsql
security invoker
set search_path = 'app', 'pg_catalog'
as $$
declare
  v_attempt record;
  v_rv app.response_versions;
  v_current_digest text;
  v_content_digest text;
begin
  if p_parts is null or jsonb_typeof(p_parts) <> 'object' then
    raise exception 'confirm_transcript:invalid_parts' using errcode = '22023';
  end if;
  if exists (select 1 from jsonb_object_keys(p_parts) k where k like '\_%' escape '\' or k = 'capture') then
    raise exception 'confirm_transcript:invalid_parts' using errcode = '22023';
  end if;

  select id, user_id, status into v_attempt
    from app.attempts where id = p_attempt_id for update;
  if not found then
    raise exception 'confirm_transcript:attempt_not_found' using errcode = 'P0001';
  end if;
  if v_attempt.user_id <> p_actor_id then
    raise exception 'confirm_transcript:forbidden' using errcode = 'P0001';
  end if;
  if v_attempt.status not in ('draft', 'failed') then
    raise exception 'confirm_transcript:attempt_not_editable' using errcode = 'P0001';
  end if;

  select * into v_rv from app.response_versions where id = p_response_version_id for update;
  if not found then
    raise exception 'confirm_transcript:response_not_found' using errcode = 'P0001';
  end if;
  if v_rv.attempt_id <> p_attempt_id then
    raise exception 'confirm_transcript:response_attempt_mismatch' using errcode = 'P0001';
  end if;
  if v_rv.is_submitted then
    raise exception 'confirm_transcript:response_already_submitted' using errcode = 'P0001';
  end if;

  select ra.sha256_digest into v_current_digest
    from app.response_attachments ra
   where ra.response_version_id = p_response_version_id
     and ra.kind = 'original'
     and ra.is_current
   order by ra.created_at desc
   limit 1;
  if v_current_digest is null then
    raise exception 'confirm_transcript:no_attachment' using errcode = 'P0001';
  end if;
  if p_photo_digest is distinct from v_current_digest then
    raise exception 'confirm_transcript:photo_changed' using errcode = 'P0001';
  end if;

  update app.response_versions
     set response_text = p_response_text,
         response_parts = (
           coalesce(case when jsonb_typeof(response_parts) = 'object' then response_parts else '{}'::jsonb end, '{}'::jsonb)
           - 'capture'
         ) || p_parts || jsonb_build_object(
           '_source', 'photo_transcript',
           '_student_added', coalesce(p_student_added, '{}'::jsonb),
           '_confirmed_at', p_confirmed_at,
           '_confirmed_digest', v_current_digest
         )
   where id = p_response_version_id
  returning * into v_rv;

  v_content_digest := app.response_content_digest(v_rv.response_text, v_rv.response_parts);

  update app.response_versions
     set response_parts = response_parts || jsonb_build_object('_confirmed_content_digest', v_content_digest)
   where id = p_response_version_id
  returning * into v_rv;

  return v_rv;
end;
$$;

revoke all on function app.confirm_response_transcript(uuid, uuid, uuid, jsonb, text, jsonb, text, timestamptz) from public, anon, authenticated;
grant execute on function app.confirm_response_transcript(uuid, uuid, uuid, jsonb, text, jsonb, text, timestamptz) to service_role;

comment on function app.confirm_response_transcript(uuid, uuid, uuid, jsonb, text, jsonb, text, timestamptz) is
  'Confirms a photographed answer''s transcript: locks attempt then response version, requires the current original photo''s digest to equal p_photo_digest, writes the confirmed text, and stores the photo and content digests that the submission guard checks. Service role only (TASK-0069 QA P1-a/P1-b).';

-- ---------------------------------------------------------------------------
-- The submission guard: inside every submit transaction.
-- ---------------------------------------------------------------------------
create or replace function app.response_versions_guard_submission()
returns trigger
language plpgsql
security definer
set search_path = 'app', 'pg_catalog'
as $$
declare
  v_policy text;
  v_photo_digest text;
  v_parts jsonb := case when jsonb_typeof(new.response_parts) = 'object' then new.response_parts else '{}'::jsonb end;
begin
  select ra.sha256_digest into v_photo_digest
    from app.response_attachments ra
   where ra.response_version_id = new.id
     and ra.kind = 'original'
     and ra.is_current
   order by ra.created_at desc
   limit 1;

  if v_photo_digest is not null then
    if coalesce(v_parts ->> '_confirmed_at', '') = ''
       or coalesce(v_parts ->> '_confirmed_digest', '') <> v_photo_digest
       or coalesce(v_parts ->> '_confirmed_content_digest', '') <> app.response_content_digest(new.response_text, v_parts)
    then
      raise exception 'submit_response:transcript_confirmation_required' using errcode = 'P0001';
    end if;
    return new;
  end if;

  select ci.response_policy into v_policy
    from app.attempts a
    join app.content_item_versions civ on civ.id = a.content_item_version_id
    join app.content_items ci on ci.id = civ.content_item_id
   where a.id = new.attempt_id;
  if v_policy = 'photo_required' then
    raise exception 'submit_response:photo_required' using errcode = 'P0001';
  end if;
  return new;
end;
$$;

drop trigger if exists response_versions_guard_submission on app.response_versions;
create trigger response_versions_guard_submission
  before update of is_submitted on app.response_versions
  for each row
  when (new.is_submitted and not old.is_submitted)
  execute function app.response_versions_guard_submission();

comment on function app.response_versions_guard_submission() is
  'Fires on the is_submitted false->true transition, inside app.submit_response after it has locked attempt and response version. A response with a bound photo submits only with a confirmation whose photo digest matches the current original and whose content digest matches the current text and parts; a photo_required item without a photo never submits (TASK-0069 QA P1-a, P1-b, P2-a).';

-- The Edge-side helper app.merge_response_parts stays for propose_transcript
-- (it merges only _transcript and may drop stale confirmation keys).
