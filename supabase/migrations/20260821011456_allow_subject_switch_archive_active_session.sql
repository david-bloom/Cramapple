begin;

-- New-user Home now treats subject switching as changing the student's active
-- browsing/study context. A stale active learning session should not trap the
-- student on the old subject. Archive active sessions for the old active pack
-- inside the same transaction, then update the profile.

create or replace function public.set_active_exam_pack_version(_version_id uuid)
returns uuid
language plpgsql
security invoker
set search_path = pg_catalog
as $$
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
     and v_current_version_id is not null then
    update app.learning_sessions
    set status = 'archived',
        ended_at = coalesce(ended_at, pg_catalog.now()),
        updated_at = pg_catalog.now()
    where user_id = v_user_id
      and exam_pack_version_id = v_current_version_id
      and status = 'active';
  end if;

  update app.profiles
  set active_exam_pack_version_id = _version_id
  where user_id = v_user_id
  returning active_exam_pack_version_id into v_returned;

  return v_returned;
end;
$$;

revoke all on function public.set_active_exam_pack_version(uuid)
  from public, anon;
grant execute on function public.set_active_exam_pack_version(uuid)
  to authenticated, service_role;

comment on function public.set_active_exam_pack_version(uuid) is
  'Sets the authenticated user active exam pack version. Switching away from the previous active pack archives active learning sessions for that previous pack instead of blocking subject switch.';

commit;
