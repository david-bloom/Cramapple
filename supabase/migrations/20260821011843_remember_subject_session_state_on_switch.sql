begin;

-- Subject switching is a context change, not session completion. Keep active
-- sessions available so a student can switch away, inspect another subject, and
-- return to the previous mid-session state.

create or replace function public.set_active_exam_pack_version(_version_id uuid)
returns uuid
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_returned uuid;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if _version_id is not null
     and not app.exam_pack_version_is_selectable(_version_id) then
    raise exception 'invalid_exam_pack_version' using errcode = '22023';
  end if;

  update app.profiles
  set active_exam_pack_version_id = _version_id
  where user_id = v_user_id
  returning active_exam_pack_version_id into v_returned;

  if not found then
    raise exception 'profile_not_found' using errcode = 'P0002';
  end if;

  return v_returned;
end;
$$;

revoke all on function public.set_active_exam_pack_version(uuid)
  from public, anon;
grant execute on function public.set_active_exam_pack_version(uuid)
  to authenticated, service_role;

comment on function public.set_active_exam_pack_version(uuid) is
  'Sets the authenticated user active exam pack version without completing or archiving active learning sessions; Home resumes by selected subject.';

grant execute on function app.home_exam_pack_is_eligible(uuid)
  to authenticated, service_role;

create or replace function app.start_home_learning_session_for_user(
  _user_id uuid,
  _minutes integer,
  _idempotency_key text
)
returns table (
  learning_session_id uuid,
  exam_pack_version_id uuid,
  practice_format text,
  reused_active boolean,
  idempotent_replay boolean
)
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  v_authenticated_user_id uuid := auth.uid();
  v_exam_pack_version_id uuid;
  v_fingerprint text;
  v_existing app.learning_sessions%rowtype;
  v_mode text;
begin
  if _user_id is null then
    raise exception 'home_session:not_authenticated' using errcode = '28000';
  end if;
  if v_authenticated_user_id is not null
     and v_authenticated_user_id <> _user_id then
    raise exception 'home_session:forbidden' using errcode = '42501';
  end if;
  if _minutes not between 5 and 90 then
    raise exception 'home_session:invalid_minutes' using errcode = '22023';
  end if;
  if char_length(coalesce(_idempotency_key, '')) not between 8 and 200 then
    raise exception 'home_session:invalid_idempotency_key'
      using errcode = '22023';
  end if;

  v_fingerprint := _minutes::text || ':mcq:broad';

  perform pg_advisory_xact_lock(
    hashtextextended('learning-session-user:' || _user_id::text, 0)
  );

  select p.active_exam_pack_version_id
    into v_exam_pack_version_id
  from app.profiles p
  where p.user_id = _user_id
  for update;

  if v_exam_pack_version_id is null then
    raise exception 'home_session:active_subject_required'
      using errcode = '22023';
  end if;
  if not app.home_exam_pack_is_eligible(v_exam_pack_version_id) then
    raise exception 'home_session:subject_not_eligible'
      using errcode = '22023';
  end if;

  select ls.*
    into v_existing
  from app.learning_sessions ls
  where ls.user_id = _user_id
    and ls.start_idempotency_key = _idempotency_key
  for update;

  if found then
    if v_existing.start_request_fingerprint <> v_fingerprint then
      raise exception 'home_session:idempotency_conflict'
        using errcode = '23505';
    end if;
    return query select
      v_existing.id,
      v_existing.exam_pack_version_id,
      coalesce(v_existing.practice_format, 'mcq'),
      false,
      true;
    return;
  end if;

  select ls.*
    into v_existing
  from app.learning_sessions ls
  where ls.user_id = _user_id
    and ls.exam_pack_version_id = v_exam_pack_version_id
    and ls.status = 'active'
  order by ls.started_at desc
  limit 1
  for update;

  if found then
    return query select
      v_existing.id,
      v_existing.exam_pack_version_id,
      coalesce(v_existing.practice_format, 'mcq'),
      true,
      false;
    return;
  end if;

  v_mode := case
    when _minutes <= 20 then 'quick'
    when _minutes <= 35 then 'focused'
    else 'buckle_down'
  end;

  insert into app.learning_sessions (
    user_id,
    exam_pack_version_id,
    entry_path,
    session_mode,
    practice_format,
    available_minutes,
    status,
    start_idempotency_key,
    start_request_fingerprint
  ) values (
    _user_id,
    v_exam_pack_version_id,
    'recommend',
    v_mode,
    'mcq',
    _minutes,
    'active',
    _idempotency_key,
    v_fingerprint
  )
  returning * into v_existing;

  return query select
    v_existing.id,
    v_existing.exam_pack_version_id,
    'mcq'::text,
    false,
    false;
end;
$$;

revoke all on function app.start_home_learning_session_for_user(
  uuid, integer, text
) from public, anon;
grant execute on function app.start_home_learning_session_for_user(
  uuid, integer, text
) to authenticated, service_role;

comment on function app.start_home_learning_session_for_user(uuid, integer, text) is
  'Starts or resumes the caller selected-subject Home session. Active sessions for other subjects are preserved for later return.';

commit;
