-- TASK-0019 is an optional targeting extension to TASK-0018 Home. Enforce
-- the TASK-0018 Home contract in the database at both lifecycle boundaries.

begin;

create or replace function app.enforce_session_target_home_eligibility()
returns trigger
language plpgsql
security invoker
set search_path = pg_catalog
as $$
begin
  if not exists (
    select 1
    from app.profiles p
    where p.user_id = new.user_id
      and p.active_exam_pack_version_id = new.exam_pack_version_id
  ) then
    raise exception 'session_target:active_subject_mismatch'
      using errcode = '22023';
  end if;

  if not app.home_exam_pack_is_eligible(new.exam_pack_version_id) then
    raise exception 'session_target:home_subject_not_eligible'
      using errcode = '22023';
  end if;
  return new;
end;
$$;

revoke all on function app.enforce_session_target_home_eligibility()
  from public, anon, authenticated, service_role;

drop trigger if exists session_targets_home_eligibility_insert
  on app.session_targets;
create trigger session_targets_home_eligibility_insert
before insert on app.session_targets
for each row execute function app.enforce_session_target_home_eligibility();

create or replace function app.revalidate_session_target_before_consumption()
returns trigger
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  v_item_count integer;
  v_valid_count integer;
begin
  if new.status <> 'consumed' or old.status = 'consumed' then
    return new;
  end if;

  if not exists (
    select 1
    from app.profiles p
    where p.user_id = new.user_id
      and p.active_exam_pack_version_id = new.exam_pack_version_id
  ) then
    raise exception 'session_target:active_subject_mismatch'
      using errcode = '22023';
  end if;

  if not app.home_exam_pack_is_eligible(new.exam_pack_version_id) then
    raise exception 'session_target:home_subject_not_eligible'
      using errcode = '22023';
  end if;

  select count(*)::integer
    into v_item_count
  from app.session_target_items sti
  where sti.target_id = new.id;

  select count(*)::integer
    into v_valid_count
  from app.session_target_items sti
  join app.content_item_versions civ
    on civ.id = sti.content_item_version_id
  join app.content_items ci
    on ci.id = civ.content_item_id
  where sti.target_id = new.id
    and ci.exam_pack_version_id = new.exam_pack_version_id
    and ci.status = 'published'
    and civ.status = 'published'
    and (
      (
        ci.item_type = 'mcq'
        and exists (
          select 1
          from app.mcq_choices choice
          where choice.content_item_version_id = civ.id
        )
      )
      or ci.item_type = 'quantitative'
      or (ci.item_type = 'frq' and ci.frq_form in ('short', 'long'))
    );

  if v_item_count = 0 or v_valid_count <> v_item_count then
    raise exception 'session_target:content_not_published_or_compatible'
      using errcode = '22023';
  end if;

  return new;
end;
$$;

revoke all on function app.revalidate_session_target_before_consumption()
  from public, anon, authenticated, service_role;

drop trigger if exists session_targets_revalidate_consumption
  on app.session_targets;
create trigger session_targets_revalidate_consumption
before update of status on app.session_targets
for each row execute function app.revalidate_session_target_before_consumption();

commit;
