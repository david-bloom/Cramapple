\set ON_ERROR_STOP on
do $$ begin if current_database()<>'task0063_fixture' then raise exception 'fixture database required'; end if; end $$;
create schema auth;
create schema app;
create function auth.uid() returns uuid language sql stable as $$ select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid $$;
create table app.profiles(user_id uuid primary key,active_exam_pack_version_id uuid);
create table app.learning_sessions(id uuid primary key default gen_random_uuid(),user_id uuid,exam_pack_version_id uuid,entry_path text,session_mode text,practice_format text,available_minutes int,status text,start_idempotency_key text,start_request_fingerprint text,started_at timestamptz default now());
create unique index learning_session_start_key on app.learning_sessions(user_id,start_idempotency_key) where start_idempotency_key is not null;
create function app.exam_pack_version_is_selectable(v uuid) returns boolean language sql as $$ select v in ('11111111-1111-4111-8111-111111111111'::uuid,'22222222-2222-4222-8222-222222222222'::uuid) $$;
create function app.home_exam_pack_is_eligible(v uuid) returns boolean language sql as $$ select app.exam_pack_version_is_selectable(v) $$;
CREATE OR REPLACE FUNCTION app.start_home_learning_session_for_user(_user_id uuid, _minutes integer, _idempotency_key text)
 RETURNS TABLE(learning_session_id uuid, exam_pack_version_id uuid, practice_format text, reused_active boolean, idempotent_replay boolean)
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
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
$function$;

CREATE OR REPLACE FUNCTION public.set_active_exam_pack_version(_version_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_current_version_id uuid;
  v_returned uuid;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if _version_id is not null
     and not app.exam_pack_version_is_selectable(_version_id) then
    raise exception 'invalid_exam_pack_version' using errcode = '22023';
  end if;

  select p.active_exam_pack_version_id
    into v_current_version_id
  from app.profiles p
  where p.user_id = v_user_id
  for update;

  if not found then
    raise exception 'profile_not_found' using errcode = 'P0002';
  end if;

  if v_current_version_id is distinct from _version_id
     and v_current_version_id is not null
     and exists (
       select 1
       from app.learning_sessions ls
       where ls.user_id = v_user_id
         and ls.exam_pack_version_id = v_current_version_id
         and ls.status = 'active'
     ) then
    raise exception 'active_session_blocks_subject_switch'
      using errcode = '55000';
  end if;

  update app.profiles
  set active_exam_pack_version_id = _version_id
  where user_id = v_user_id
  returning active_exam_pack_version_id into v_returned;

  return v_returned;
end;
$function$;

insert into app.profiles values('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','11111111-1111-4111-8111-111111111111');
insert into app.learning_sessions(user_id,exam_pack_version_id,status,practice_format) values('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','11111111-1111-4111-8111-111111111111','active','mcq');
do $$ begin
 perform set_config('request.jwt.claim.sub','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',true);
 begin
  perform public.set_active_exam_pack_version('22222222-2222-4222-8222-222222222222');
  raise exception 'expected old Production defect';
 exception when sqlstate '55000' then
  if sqlerrm<>'active_session_blocks_subject_switch' then raise; end if;
 end;
end $$;
\ir ../../supabase/migrations/20261021153710_task0063_reconcile_session_rpc_bodies.sql
do $$ declare r record; first_id uuid; begin
 perform set_config('request.jwt.claim.sub','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',true);
 perform public.set_active_exam_pack_version('22222222-2222-4222-8222-222222222222');
 select * into r from app.start_home_learning_session_for_user('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',10,'fixture-key');
 if r.exam_pack_version_id<>'22222222-2222-4222-8222-222222222222'::uuid or r.reused_active then raise exception 'cross-subject start reused old subject'; end if;
 first_id:=r.learning_session_id;
 select * into r from app.start_home_learning_session_for_user('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',10,'fixture-key');
 if not r.idempotent_replay or r.learning_session_id<>first_id then raise exception 'replay failed'; end if;
 select * into r from app.start_home_learning_session_for_user('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',10,'another-key');
 if not r.reused_active or r.learning_session_id<>first_id then raise exception 'same-subject reuse failed'; end if;
 begin
  perform app.start_home_learning_session_for_user('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',10,'other-user-key');
  raise exception 'wrong actor accepted';
 exception when insufficient_privilege then null; end;
 begin
  perform public.set_active_exam_pack_version('33333333-3333-4333-8333-333333333333');
  raise exception 'unselectable subject accepted';
 exception when invalid_parameter_value then null; end;
 if (select count(*) from app.learning_sessions)<>2 then raise exception 'duplicate sessions'; end if;
end $$;
select 'PASS: old defect reproduced; switching, scoped start/replay/reuse and identity/selectability guards' as result;

