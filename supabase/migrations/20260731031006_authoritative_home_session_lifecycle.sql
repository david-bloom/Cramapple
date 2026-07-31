-- TASK-0018 authoritative broad Home session lifecycle.
--
-- The browser supplies only duration and an idempotency key. The active exam
-- pack, eligibility, practice format, and user identity are resolved inside
-- the transaction.

begin;

alter table app.learning_sessions
  add column if not exists start_idempotency_key text,
  add column if not exists start_request_fingerprint text;

create unique index if not exists learning_sessions_user_start_key_uidx
  on app.learning_sessions (user_id, start_idempotency_key)
  where start_idempotency_key is not null;

create or replace function app.home_exam_pack_is_eligible(
  _exam_pack_version_id uuid
)
returns boolean
language sql
stable
security invoker
set search_path = pg_catalog
as $$
  select exists (
    select 1
    from app.home_release_manifest m
    join app.exam_pack_versions epv
      on epv.id = m.exam_pack_version_id
    join app.exam_packs ep
      on ep.id = epv.exam_pack_id
    join app.subjects s
      on s.id = ep.subject_id
    where m.exam_pack_version_id = _exam_pack_version_id
      and m.quick_start_enabled
      and epv.status = 'published'
      and epv.retired_at is null
      and s.status = 'active'
      and (
        select count(distinct ci.id)
        from app.content_items ci
        join app.content_item_versions civ
          on civ.content_item_id = ci.id
        where ci.exam_pack_version_id = epv.id
          and ci.status = 'published'
          and ci.item_type = 'mcq'
          and civ.status = 'published'
          and exists (
            select 1
            from app.mcq_choices choice
            where choice.content_item_version_id = civ.id
          )
      ) >= m.minimum_published_items
  );
$$;

revoke all on function app.home_exam_pack_is_eligible(uuid)
  from public, anon;
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
    and ls.status = 'active'
  order by ls.started_at desc
  limit 1
  for update;

  if found then
    if v_existing.exam_pack_version_id <> v_exam_pack_version_id then
      raise exception 'home_session:active_session_wrong_subject'
        using errcode = '55000';
    end if;
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

create or replace function public.start_home_learning_session(
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
language sql
security invoker
set search_path = pg_catalog
as $$
  select *
  from app.start_home_learning_session_for_user(
    auth.uid(),
    _minutes,
    _idempotency_key
  );
$$;

revoke all on function public.start_home_learning_session(integer, text)
  from public, anon;
grant execute on function public.start_home_learning_session(integer, text)
  to authenticated;

create or replace function public.start_home_learning_session_for_user(
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
language sql
security invoker
set search_path = pg_catalog
as $$
  select *
  from app.start_home_learning_session_for_user(
    _user_id,
    _minutes,
    _idempotency_key
  );
$$;

revoke all on function public.start_home_learning_session_for_user(
  uuid, integer, text
) from public, anon, authenticated;
grant execute on function public.start_home_learning_session_for_user(
  uuid, integer, text
) to service_role;

create or replace function public.complete_learning_session(
  _session_id uuid
)
returns uuid
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_status text;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select ls.status
    into v_status
  from app.learning_sessions ls
  where ls.id = _session_id
    and ls.user_id = v_user_id
  for update;

  if not found then
    raise exception 'learning_session_not_found' using errcode = 'P0002';
  end if;

  if v_status = 'active' then
    update app.learning_sessions
    set status = 'completed',
        ended_at = coalesce(ended_at, pg_catalog.now())
    where id = _session_id
      and user_id = v_user_id;
  elsif v_status <> 'completed' then
    raise exception 'learning_session_not_completable'
      using errcode = '55000';
  end if;

  return _session_id;
end;
$$;

revoke all on function public.complete_learning_session(uuid)
  from public, anon;
grant execute on function public.complete_learning_session(uuid)
  to authenticated;

commit;
