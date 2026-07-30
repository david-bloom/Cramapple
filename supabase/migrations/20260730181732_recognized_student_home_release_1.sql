-- TASK-0018 — Recognized Student Home, Release 1.
--
-- Development-first contract:
--   * optional first-run profile state
--   * active exam-pack selection with active-session switch protection
--   * per-exam-pack course position with manifest-backed unit validation
--   * private per-user Home V2 rollout assignments
--   * server-owned quick-start release manifest and fail-closed eligibility
--   * curated security-invoker views only; authoritative tables stay in app
--
-- Production application and staff assignment remain separate Hard Gates.

begin;

-- ---------------------------------------------------------------------------
-- Profile state and active-subject contract
-- ---------------------------------------------------------------------------

alter table app.profiles
  add column if not exists active_exam_pack_version_id uuid
    references app.exam_pack_versions(id) on delete set null,
  add column if not exists first_run_dismissed_at timestamptz;

create index if not exists profiles_active_exam_pack_version_idx
  on app.profiles (active_exam_pack_version_id);

create or replace view public.profiles
with (security_invoker = true, security_barrier = true)
as
select
  p.user_id,
  p.full_name,
  p.role,
  p.review_queue_scope,
  p.timezone,
  p.locale,
  p.onboarding_completed_at,
  p.created_at,
  p.updated_at,
  p.active_exam_pack_version_id,
  p.first_run_dismissed_at
from app.profiles p;

grant select on public.profiles to authenticated;

create or replace function app.exam_pack_version_is_selectable(_version_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog
as $$
  select exists (
    select 1
    from app.exam_pack_versions epv
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.subjects s on s.id = ep.subject_id
    where epv.id = _version_id
      and epv.status = 'published'
      and epv.retired_at is null
      and s.status = 'active'
  );
$$;

revoke all on function app.exam_pack_version_is_selectable(uuid)
  from public, anon, authenticated;
grant execute on function app.exam_pack_version_is_selectable(uuid)
  to service_role;

create or replace function public.set_active_exam_pack_version(_version_id uuid)
returns uuid
language plpgsql
security definer
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
$$;

revoke all on function public.set_active_exam_pack_version(uuid)
  from public, anon;
grant execute on function public.set_active_exam_pack_version(uuid)
  to authenticated;

create or replace function public.complete_onboarding(_version_id uuid)
returns table (
  active_exam_pack_version_id uuid,
  onboarding_completed_at timestamptz
)
language plpgsql
security definer
set search_path = pg_catalog
as $$
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
$$;

revoke all on function public.complete_onboarding(uuid)
  from public, anon;
grant execute on function public.complete_onboarding(uuid)
  to authenticated;

create or replace function public.dismiss_first_run()
returns timestamptz
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_dismissed_at timestamptz;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  update app.profiles
  set first_run_dismissed_at = coalesce(first_run_dismissed_at, pg_catalog.now())
  where user_id = v_user_id
  returning first_run_dismissed_at into v_dismissed_at;

  if not found then
    raise exception 'profile_not_found' using errcode = 'P0002';
  end if;

  return v_dismissed_at;
end;
$$;

revoke all on function public.dismiss_first_run()
  from public, anon;
grant execute on function public.dismiss_first_run()
  to authenticated;

create or replace function public.end_active_learning_session()
returns uuid
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_active_exam_pack_version_id uuid;
  v_session_id uuid;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select p.active_exam_pack_version_id
    into v_active_exam_pack_version_id
  from app.profiles p
  where p.user_id = v_user_id;

  if v_active_exam_pack_version_id is null then
    raise exception 'no_active_subject' using errcode = '22023';
  end if;

  select ls.id
    into v_session_id
  from app.learning_sessions ls
  where ls.user_id = v_user_id
    and ls.exam_pack_version_id = v_active_exam_pack_version_id
    and ls.status = 'active'
  order by ls.started_at desc
  limit 1
  for update;

  if v_session_id is null then
    raise exception 'active_session_not_found' using errcode = 'P0002';
  end if;

  update app.learning_sessions
  set
    status = 'completed',
    ended_at = coalesce(ended_at, pg_catalog.now())
  where id = v_session_id;

  return v_session_id;
end;
$$;

revoke all on function public.end_active_learning_session()
  from public, anon;
grant execute on function public.end_active_learning_session()
  to authenticated;

-- ---------------------------------------------------------------------------
-- Server-owned Home release manifest
-- ---------------------------------------------------------------------------

create table app.home_release_manifest (
  exam_pack_version_id uuid primary key
    references app.exam_pack_versions(id) on delete cascade,
  quick_start_enabled boolean not null default false,
  minimum_published_items integer not null default 10
    check (minimum_published_items >= 1),
  allowed_unit_numbers integer[] not null default '{}'::integer[],
  criterion_starter_enabled boolean not null default false,
  updated_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint home_release_manifest_positive_units
    check (
      array_position(allowed_unit_numbers, null) is null
      and 0 < all(allowed_unit_numbers)
    )
);

create trigger home_release_manifest_set_updated_at
before update on app.home_release_manifest
for each row execute function app.set_updated_at();

alter table app.home_release_manifest enable row level security;
alter table app.home_release_manifest force row level security;

create policy "home_release_manifest_authenticated_read"
on app.home_release_manifest
for select
to authenticated
using (true);

grant select on app.home_release_manifest to authenticated;
grant select, insert, update, delete on app.home_release_manifest to service_role;

-- Seed only the taxonomy validation range. Quick start remains disabled until
-- the explicit staff enablement gate and live inventory/resolver checks pass.
insert into app.home_release_manifest (
  exam_pack_version_id,
  quick_start_enabled,
  minimum_published_items,
  allowed_unit_numbers,
  criterion_starter_enabled
)
select
  epv.id,
  false,
  10,
  case s.subject_key
    when 'ap_biology' then array[1,2,3,4,5,6,7,8]
    when 'ap_statistics' then array[1,2,3,4,5,6,7,8,9]
    else '{}'::integer[]
  end,
  false
from app.exam_pack_versions epv
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
where epv.status = 'published'
  and epv.retired_at is null
  and s.subject_key in ('ap_biology', 'ap_statistics')
on conflict (exam_pack_version_id) do nothing;

create or replace view public.home_quick_start_subjects
with (security_invoker = true, security_barrier = true)
as
select
  epv.id as exam_pack_version_id,
  s.subject_key,
  s.display_name,
  epv.official_exam_date,
  m.minimum_published_items,
  count(distinct civ.id) filter (
    where ci.status = 'published'
      and civ.status = 'published'
      and ci.item_type = 'mcq'
  )::integer as compatible_published_items,
  m.allowed_unit_numbers,
  m.criterion_starter_enabled,
  (
    m.quick_start_enabled
    and epv.status = 'published'
    and epv.retired_at is null
    and s.status = 'active'
    and count(distinct civ.id) filter (
      where ci.status = 'published'
        and civ.status = 'published'
        and ci.item_type = 'mcq'
    ) >= m.minimum_published_items
  ) as eligible
from app.home_release_manifest m
join app.exam_pack_versions epv on epv.id = m.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
left join app.content_items ci on ci.exam_pack_version_id = epv.id
left join app.content_item_versions civ on civ.content_item_id = ci.id
group by
  epv.id,
  s.subject_key,
  s.display_name,
  epv.official_exam_date,
  epv.status,
  epv.retired_at,
  s.status,
  m.minimum_published_items,
  m.allowed_unit_numbers,
  m.criterion_starter_enabled,
  m.quick_start_enabled;

grant select on public.home_quick_start_subjects to authenticated;

-- ---------------------------------------------------------------------------
-- Per-user rollout assignment (own-row read, service-only writes)
-- ---------------------------------------------------------------------------

create table app.feature_flag_assignments (
  feature_key text not null,
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  enabled boolean not null default false,
  expires_at timestamptz,
  assigned_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (feature_key, user_id),
  constraint feature_flag_assignments_key_check
    check (feature_key ~ '^[a-z0-9][a-z0-9._-]{1,63}$')
);

create trigger feature_flag_assignments_set_updated_at
before update on app.feature_flag_assignments
for each row execute function app.set_updated_at();

alter table app.feature_flag_assignments enable row level security;
alter table app.feature_flag_assignments force row level security;

create policy "feature_flag_assignments_select_own"
on app.feature_flag_assignments
for select
to authenticated
using ((select auth.uid()) = user_id);

grant select on app.feature_flag_assignments to authenticated;
grant select, insert, update, delete on app.feature_flag_assignments to service_role;

create or replace view public.feature_flag_assignments
with (security_invoker = true, security_barrier = true)
as
select
  f.feature_key,
  f.user_id,
  f.enabled,
  f.expires_at,
  f.created_at,
  f.updated_at
from app.feature_flag_assignments f;

grant select on public.feature_flag_assignments to authenticated;

-- ---------------------------------------------------------------------------
-- Per-subject course position
-- ---------------------------------------------------------------------------

create table app.student_course_positions (
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  exam_pack_version_id uuid not null
    references app.exam_pack_versions(id) on delete cascade,
  unit_id integer,
  source text not null default 'unknown'
    check (source in ('confirmed', 'estimated', 'unknown')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, exam_pack_version_id),
  constraint student_course_positions_unit_check
    check (unit_id is null or unit_id > 0),
  constraint student_course_positions_unknown_check
    check (
      (unit_id is null and source = 'unknown')
      or
      (unit_id is not null and source in ('confirmed', 'estimated'))
    )
);

create trigger student_course_positions_set_updated_at
before update on app.student_course_positions
for each row execute function app.set_updated_at();

alter table app.student_course_positions enable row level security;
alter table app.student_course_positions force row level security;

create policy "student_course_positions_select_own"
on app.student_course_positions
for select
to authenticated
using ((select auth.uid()) = user_id);

grant select on app.student_course_positions to authenticated;
grant select, insert, update, delete on app.student_course_positions to service_role;

create or replace view public.student_course_positions
with (security_invoker = true, security_barrier = true)
as
select
  p.user_id,
  p.exam_pack_version_id,
  p.unit_id,
  p.source,
  p.created_at,
  p.updated_at
from app.student_course_positions p;

grant select on public.student_course_positions to authenticated;

create or replace function public.set_course_position(
  _unit_id integer,
  _source text
)
returns table (
  exam_pack_version_id uuid,
  unit_id integer,
  source text,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_exam_pack_version_id uuid;
  v_allowed_units integer[];
  v_source text;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select p.active_exam_pack_version_id
    into v_exam_pack_version_id
  from app.profiles p
  where p.user_id = v_user_id;

  if v_exam_pack_version_id is null then
    raise exception 'no_active_subject' using errcode = '22023';
  end if;

  if not app.exam_pack_version_is_selectable(v_exam_pack_version_id) then
    raise exception 'invalid_active_subject' using errcode = '22023';
  end if;

  select m.allowed_unit_numbers
    into v_allowed_units
  from app.home_release_manifest m
  where m.exam_pack_version_id = v_exam_pack_version_id;

  if v_allowed_units is null then
    raise exception 'subject_taxonomy_unavailable' using errcode = '22023';
  end if;

  if _unit_id is not null
     and not (_unit_id = any(v_allowed_units)) then
    raise exception 'unit_not_in_active_subject' using errcode = '22023';
  end if;

  if _unit_id is null then
    v_source := 'unknown';
  elsif _source in ('confirmed', 'estimated') then
    v_source := _source;
  else
    raise exception 'invalid_course_position_source' using errcode = '22023';
  end if;

  return query
  insert into app.student_course_positions as positions (
    user_id,
    exam_pack_version_id,
    unit_id,
    source
  )
  values (
    v_user_id,
    v_exam_pack_version_id,
    _unit_id,
    v_source
  )
  on conflict (user_id, exam_pack_version_id) do update
  set
    unit_id = excluded.unit_id,
    source = excluded.source
  returning
    positions.exam_pack_version_id,
    positions.unit_id,
    positions.source,
    positions.updated_at;
end;
$$;

revoke all on function public.set_course_position(integer, text)
  from public, anon;
grant execute on function public.set_course_position(integer, text)
  to authenticated;

-- ---------------------------------------------------------------------------
-- Curated learning-session interface: append the actual practice format.
-- ---------------------------------------------------------------------------

alter table app.learning_sessions
  add column if not exists practice_format text;

create or replace view public.learning_sessions
with (security_invoker = true, security_barrier = true)
as
select
  ls.id,
  ls.user_id,
  ls.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  ls.entry_path,
  ls.session_mode,
  ls.available_minutes,
  ls.status,
  ls.started_at,
  ls.ended_at,
  ls.created_at,
  ls.updated_at,
  ls.practice_format
from app.learning_sessions ls
join app.exam_pack_versions epv on epv.id = ls.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id;

grant select on public.learning_sessions to authenticated;

commit;
