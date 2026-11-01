-- WORK-SUBJECT-ACCESS: enforce current access before study, never grant access.
begin;

create or replace function app.has_study_subject_access(_user_id uuid, _subject_key text)
returns boolean language sql stable security definer set search_path = pg_catalog
as $$
  select _user_id is not null and (
    exists (select 1 from app.profiles p where p.user_id = _user_id
      and p.role::text in ('admin', 'content_author', 'tutor', 'reader', 'validator'))
    or exists (
      select 1 from app.subject_entitlements e
      join app.subjects entitled_subject on entitled_subject.id = e.subject_id
      where e.user_id = _user_id and entitled_subject.subject_key = _subject_key
        and e.status = 'active' and e.starts_at <= now()
        and (e.ends_at is null or e.ends_at > now())
    )
  );
$$;
revoke all on function app.has_study_subject_access(uuid, text) from public, anon, authenticated;
grant execute on function app.has_study_subject_access(uuid, text) to service_role;

create or replace function app.has_study_pack_access(_user_id uuid, _version_id uuid)
returns boolean language sql stable security definer set search_path = pg_catalog
as $$
  select exists (
    select 1 from app.exam_pack_versions v
    join app.exam_packs p on p.id = v.exam_pack_id
    join app.subjects s on s.id = p.subject_id
    where v.id = _version_id and app.has_study_subject_access(_user_id, s.subject_key)
  );
$$;
revoke all on function app.has_study_pack_access(uuid, uuid) from public, anon, authenticated;
grant execute on function app.has_study_pack_access(uuid, uuid) to service_role;

-- Browser entry points always derive identity from the JWT.
create or replace function public.has_study_pack_access(_version_id uuid)
returns boolean language sql stable security definer set search_path = pg_catalog
as $$ select app.has_study_pack_access(auth.uid(), _version_id); $$;
revoke all on function public.has_study_pack_access(uuid) from public, anon;
grant execute on function public.has_study_pack_access(uuid) to authenticated, service_role;

create or replace function public.get_study_subject_keys()
returns jsonb language sql stable security definer set search_path = pg_catalog
as $$
  select coalesce(jsonb_agg(s.subject_key order by s.subject_key), '[]'::jsonb)
  from app.subjects s
  where s.status = 'active' and app.has_study_subject_access(auth.uid(), s.subject_key);
$$;
revoke all on function public.get_study_subject_keys() from public, anon;
grant execute on function public.get_study_subject_keys() to authenticated, service_role;

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

  if _version_id is not null and not public.has_study_pack_access(_version_id) then
    raise exception 'subject_access:entitlement_required' using errcode = '42501';
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
$function$
;

CREATE OR REPLACE FUNCTION public.complete_onboarding(_version_id uuid)
 RETURNS TABLE(active_exam_pack_version_id uuid, onboarding_completed_at timestamp with time zone)
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if _version_id is null
     or not app.exam_pack_version_is_selectable(_version_id) then
    raise exception 'invalid_exam_pack_version' using errcode = '22023';
  end if;

  if _version_id is not null and not public.has_study_pack_access(_version_id) then
    raise exception 'subject_access:entitlement_required' using errcode = '42501';
  end if;

  return query
  update app.profiles p
  set
    active_exam_pack_version_id = _version_id,
    onboarding_completed_at = coalesce(p.onboarding_completed_at, pg_catalog.now())
  where p.user_id = v_user_id
  returning p.active_exam_pack_version_id, p.onboarding_completed_at;

  if not found then
    raise exception 'profile_not_found' using errcode = 'P0002';
  end if;
end;
$function$
;

-- A direct insert or authoritative Home start cannot substitute an unentitled pack.
create or replace function app.require_learning_session_subject_access()
returns trigger language plpgsql security definer set search_path = pg_catalog
as $$
begin
  if TG_OP = 'INSERT' or new.user_id is distinct from old.user_id
     or new.exam_pack_version_id is distinct from old.exam_pack_version_id
     or (new.status = 'active' and old.status is distinct from new.status) then
    if not app.has_study_pack_access(new.user_id, new.exam_pack_version_id) then
      raise exception 'subject_access:entitlement_required' using errcode = '42501';
    end if;
  end if;
  return new;
end;
$$;
revoke all on function app.require_learning_session_subject_access() from public, anon, authenticated;
create trigger require_learning_session_subject_access
before insert or update of user_id, exam_pack_version_id, status on app.learning_sessions
for each row execute function app.require_learning_session_subject_access();

-- Preserve the large current readback body; fail the migration on anchor drift.
do $patch$
declare
  definition text := pg_get_functiondef('public.get_question_experience(uuid,integer)'::regprocedure);
  anchor text := E'  select count(*) into v_total\n  from app.learning_session_items where learning_session_id = v_session.id;';
begin
  if strpos(definition, anchor) = 0 or strpos(definition, 'subject_access:entitlement_required') > 0 then
    raise exception 'subject access migration: question experience definition drift';
  end if;
  execute replace(definition, anchor, E'  if not app.has_study_pack_access(v_user_id, v_session.exam_pack_version_id) then\n    raise exception ''subject_access:entitlement_required'' using errcode = ''42501'';\n  end if;\n\n' || anchor);
end;
$patch$;

-- Separate study endpoint: existing identity-agnostic BYOQ reference access stays intact.
-- Entitlement is to the requested subject, including BC's inherited AB references.
create or replace function public.get_study_topic_point_guides(
  _subject_key text, _unit_number integer default null, _topic_code text default null
)
returns jsonb language plpgsql stable security definer set search_path = pg_catalog
as $$
begin
  if auth.uid() is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if not app.has_study_subject_access(auth.uid(), app.normalize_student_subject_key(_subject_key)) then
    raise exception 'subject_access:entitlement_required' using errcode = '42501';
  end if;
  return public.get_topic_point_guides(_subject_key, _unit_number, _topic_code);
end;
$$;
revoke all on function public.get_study_topic_point_guides(text, integer, text) from public, anon;
grant execute on function public.get_study_topic_point_guides(text, integer, text) to authenticated, service_role;

commit;
