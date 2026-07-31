-- The content tables have mutually referential publication policies. The
-- authenticated invoker cannot safely aggregate them without policy
-- recursion. This narrowly scoped, non-exposed helper returns one boolean and
-- permits authenticated callers to evaluate only their own active pack.
create or replace function app.home_exam_pack_is_eligible(
  _exam_pack_version_id uuid
)
returns boolean
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is not null
     and not exists (
       select 1
       from app.profiles p
       where p.user_id = v_user_id
         and p.active_exam_pack_version_id = _exam_pack_version_id
     ) then
    return false;
  end if;

  return exists (
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
end;
$$;

revoke all on function app.home_exam_pack_is_eligible(uuid)
  from public, anon;
grant execute on function app.home_exam_pack_is_eligible(uuid)
  to authenticated, service_role;

comment on function app.home_exam_pack_is_eligible(uuid) is
  'Returns Home quick-start eligibility for the caller active pack; SECURITY DEFINER is limited to avoiding recursive content-publication RLS.';
