-- TASK-0063 / TASK-0078. UNAPPLIED; no historical migration or ledger replay.
-- Replace only the two reviewed bodies. Later security functions/grants remain intact.
do $$ begin
  if not exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
    where n.nspname='app' and p.proname='start_home_learning_session_for_user' and not p.prosecdef
      and p.proconfig=array['search_path=pg_catalog']::text[]
      and md5(p.prosrc) in ('de584bfdfbadd390d9b2fd4e370150e1','dbc35186dc642ac15e19295f3601186b')) then
    raise exception 'TASK-0063: start_home_learning_session_for_user changed; re-review';
  end if;
end $$;

do $$ begin
  if not exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
    where n.nspname='public' and p.proname='set_active_exam_pack_version' and not p.prosecdef
      and p.proconfig=array['search_path=pg_catalog']::text[]
      and md5(p.prosrc) in ('1363d6eaf5a1196b448f67cc4dfbbccd','5a71a24d2fc753b91f0150aa0ac2161e')) then
    raise exception 'TASK-0063: set_active_exam_pack_version changed; re-review';
  end if;
end $$;

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

  select p.active_exam_pack_version_id
    into v_exam_pack_version_id
  from app.profiles p
  where p.user_id = _user_id
  for update;

  if v_exam_pack_version_id is null then
    raise exception 'home_session:active_subject_required'
      using errcode = '22023';
  end if;
  if not app.exam_pack_version_is_selectable(v_exam_pack_version_id) then
    raise exception 'home_session:subject_not_selectable'
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
$function$;

CREATE OR REPLACE FUNCTION public.set_active_exam_pack_version(_version_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
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
$function$;

