-- TASK-0018 Development integration/security verification.
-- Run against Development only. The transaction rolls back every fixture.

begin;

create temporary table task0018_ids (
  key text primary key,
  id uuid not null
) on commit drop;

insert into task0018_ids (key, id)
select 'user_a', user_id
from app.profiles
order by created_at
limit 1;

insert into task0018_ids (key, id)
select 'user_b', user_id
from app.profiles
where user_id <> (select id from task0018_ids where key = 'user_a')
order by created_at
limit 1;

insert into task0018_ids (key, id)
select 'version_a', m.exam_pack_version_id
from app.home_release_manifest m
order by m.exam_pack_version_id
limit 1;

insert into task0018_ids (key, id)
select 'version_b', m.exam_pack_version_id
from app.home_release_manifest m
where m.exam_pack_version_id <> (
  select id from task0018_ids where key = 'version_a'
)
order by m.exam_pack_version_id
limit 1;

grant select on task0018_ids to authenticated;

do $$
begin
  if (select count(*) from task0018_ids) <> 4 then
    raise exception 'TASK-0018 fixtures require two profiles and two manifest versions';
  end if;
end;
$$;

update app.profiles
set
  active_exam_pack_version_id = (select id from task0018_ids where key = 'version_a'),
  first_run_dismissed_at = null
where user_id = (select id from task0018_ids where key = 'user_a');

update app.profiles
set first_run_dismissed_at = null
where user_id = (select id from task0018_ids where key = 'user_b');

insert into app.feature_flag_assignments (feature_key, user_id, enabled)
values
  ('home-v2', (select id from task0018_ids where key = 'user_a'), true),
  ('home-v2', (select id from task0018_ids where key = 'user_b'), true)
on conflict (feature_key, user_id) do update set enabled = excluded.enabled;

insert into app.learning_sessions (
  user_id,
  exam_pack_version_id,
  entry_path,
  session_mode,
  available_minutes,
  status
)
values (
  (select id from task0018_ids where key = 'user_a'),
  (select id from task0018_ids where key = 'version_a'),
  'recommend',
  'quick',
  15,
  'active'
);

select set_config(
  'request.jwt.claims',
  json_build_object(
    'sub', (select id from task0018_ids where key = 'user_a'),
    'role', 'authenticated'
  )::text,
  true
);
set local role authenticated;

do $$
declare
  v_timestamp timestamptz;
  v_source text;
  v_switched uuid;
begin
  if (select count(*) from public.feature_flag_assignments) <> 1 then
    raise exception 'feature flag RLS exposed another user';
  end if;

  select positions.source
  into v_source
  from public.set_course_position(null, 'confirmed') positions;
  if v_source <> 'unknown' then
    raise exception 'null course position did not remain unknown';
  end if;

  begin
    perform public.set_course_position(999, 'confirmed');
    raise exception 'unit outside the active subject was accepted';
  exception
    when sqlstate '22023' then null;
  end;

  v_timestamp := public.dismiss_first_run();
  if v_timestamp is null then
    raise exception 'first-run dismissal did not persist';
  end if;

  begin
    perform public.set_active_exam_pack_version(
      (select id from task0018_ids where key = 'version_b')
    );
    raise exception 'active subject changed while a session was open';
  exception
    when sqlstate '55000' then null;
  end;

  perform public.end_active_learning_session();
  v_switched := public.set_active_exam_pack_version(
    (select id from task0018_ids where key = 'version_b')
  );
  if v_switched <> (select id from task0018_ids where key = 'version_b') then
    raise exception 'subject switch returned the wrong version';
  end if;

  begin
    update public.feature_flag_assignments set enabled = false;
    raise exception 'authenticated user could write rollout assignments';
  exception
    when insufficient_privilege then null;
  end;
end;
$$;

reset role;

do $$
begin
  if (
    select first_run_dismissed_at
    from app.profiles
    where user_id = (select id from task0018_ids where key = 'user_b')
  ) is not null then
    raise exception 'dismissal modified another profile';
  end if;

  if not exists (
    select 1
    from information_schema.views
    where table_schema = 'public'
      and table_name = 'learning_sessions'
  ) then
    raise exception 'curated learning_sessions view is missing';
  end if;

  if not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'learning_sessions'
      and column_name = 'practice_format'
  ) then
    raise exception 'practice_format is missing from the curated view';
  end if;
end;
$$;

rollback;
