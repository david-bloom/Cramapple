-- Paywall sample access (docs/product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md).
--
-- The sample is a SCOPED GRANT, not an entitlement tier: app.subject_entitlements
-- is untouched and every existing "any active entitlement row = full access"
-- check keeps denying a sample student. Exactly three gates learn about the
-- sample: subject study access (admission while the 72h clock runs), attempt
-- creation (allowance + unit), and grading authorization (clock + fixed grace).
-- Readback of saved feedback is widened separately and never withdrawn.
--
-- Both switches default OFF (app.config sample_access_enabled=false). Nothing
-- in this file changes behaviour for a student without a sample grant.
--
-- Development only. Down script: supabase/migrations/down/paywall_sample_access_down.sql

begin;

-- ---------------------------------------------------------------------------
-- 0. Snapshot the function bodies this migration replaces (for the down script)
-- ---------------------------------------------------------------------------
insert into app.config (config_key, config_value, is_public, description)
values (
  'sample_access_prior_definitions',
  jsonb_build_object(
    'has_study_subject_access', pg_get_functiondef('app.has_study_subject_access(uuid,text)'::regprocedure),
    'authorize_grading_access', pg_get_functiondef('app.authorize_grading_access(uuid,uuid,text,text)'::regprocedure),
    'get_study_topic_point_guides', pg_get_functiondef('public.get_study_topic_point_guides(text,integer,text)'::regprocedure),
    'get_question_experience', pg_get_functiondef('public.get_question_experience(uuid,integer)'::regprocedure),
    'learning_sessions_entry_path_check', (select pg_get_constraintdef(oid) from pg_constraint where conname = 'learning_sessions_entry_path_check')
  ),
  false,
  'Pre-change definitions captured by the paywall sample access migration (2026-11-08); read by the down script.'
)
on conflict (config_key) do nothing;

-- ---------------------------------------------------------------------------
-- 1. Switches (both layers default off / honor-existing on)
-- ---------------------------------------------------------------------------
insert into app.config (config_key, config_value, is_public, description) values
  ('sample_access_enabled', 'false'::jsonb, false,
   'Paywall sample: admits anonymous tries and claims when true. Default false. Edge SAMPLE_ACCESS_ENABLED must also be true.'),
  ('sample_access_honor_existing', 'true'::jsonb, false,
   'Paywall sample: when false every existing grant reads as phase disabled (no new attempts, no grading); readback stays.')
on conflict (config_key) do nothing;

create or replace function app.sample_access_enabled()
returns boolean language sql stable security definer set search_path = pg_catalog as $$
  select coalesce((select (c.config_value)::text = 'true' from app.config c where c.config_key = 'sample_access_enabled'), false);
$$;
create or replace function app.sample_honor_existing()
returns boolean language sql stable security definer set search_path = pg_catalog as $$
  select coalesce((select (c.config_value)::text = 'true' from app.config c where c.config_key = 'sample_access_honor_existing'), true);
$$;
revoke all on function app.sample_access_enabled() from public, anon, authenticated;
revoke all on function app.sample_honor_existing() from public, anon, authenticated;
grant execute on function app.sample_access_enabled() to service_role;
grant execute on function app.sample_honor_existing() to service_role;

-- ---------------------------------------------------------------------------
-- 2. Tables
-- ---------------------------------------------------------------------------
create table app.sample_tries (
  id uuid primary key default gen_random_uuid(),
  token_hash text not null unique check (token_hash ~ '^[0-9a-f]{64}$'),
  subject_id uuid not null references app.subjects(id),
  exam_pack_version_id uuid not null references app.exam_pack_versions(id),
  unit_number integer not null check (unit_number >= 1),
  content_item_version_id uuid not null references app.content_item_versions(id),
  ip_hmac text,
  attribution jsonb not null default '{}'::jsonb,
  served_at timestamptz not null default now(),
  answer_expires_at timestamptz not null default now() + interval '24 hours',
  answered_at timestamptz,
  picked_choice_key text,
  is_correct boolean,
  points_earned integer,
  claim_expires_at timestamptz,
  supersedes_try_id uuid references app.sample_tries(id),
  switch_count integer not null default 0,
  claimed_by_user_id uuid references app.profiles(user_id),
  claimed_at timestamptz,
  grant_id uuid,
  status text not null default 'served'
    check (status in ('served', 'answered', 'superseded', 'expired', 'claimed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
comment on table app.sample_tries is
  'Paywall sample: the anonymous first MCQ. Keyed by the sha256 of a random browser token. No PII (IP as HMAC, attribution allow-list only). Never an attempt or a grading row.';
create index sample_tries_claimed_by_idx on app.sample_tries (claimed_by_user_id) where claimed_by_user_id is not null;
create trigger sample_tries_set_updated_at before update on app.sample_tries
for each row execute function app.set_updated_at();

create table app.sample_grants (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references app.profiles(user_id) on delete cascade,
  email_hash text not null check (email_hash ~ '^[0-9a-f]{64}$'),
  subject_id uuid not null references app.subjects(id),
  exam_pack_version_id uuid not null references app.exam_pack_versions(id),
  unit_number integer not null check (unit_number >= 1),
  try_id uuid not null references app.sample_tries(id),
  activated_at timestamptz not null default now(),
  expires_at timestamptz not null,
  grace_ends_at timestamptz not null,
  mcq_allowance integer not null default 8 check (mcq_allowance >= 1),
  frq_allowance integer not null default 1 check (frq_allowance >= 0),
  status text not null default 'active' check (status in ('active', 'superseded', 'revoked')),
  superseded_at timestamptz,
  superseded_by text check (superseded_by is null or superseded_by in ('trial', 'paid', 'beta')),
  revoked_at timestamptz,
  revoked_reason text,
  attribution jsonb not null default '{}'::jsonb,
  learning_session_id uuid references app.learning_sessions(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint sample_grants_clock_check check (expires_at > activated_at and grace_ends_at > expires_at)
);
comment on table app.sample_grants is
  'Paywall sample: one 72-hour scoped grant per student (and per email hash). Not an entitlement: regular access checks ignore it; only the three sample gates read it.';
create trigger sample_grants_set_updated_at before update on app.sample_grants
for each row execute function app.set_updated_at();
alter table app.sample_tries add constraint sample_tries_grant_fk foreign key (grant_id) references app.sample_grants(id);

create table app.sample_consumptions (
  id uuid primary key default gen_random_uuid(),
  grant_id uuid not null references app.sample_grants(id) on delete cascade,
  kind text not null check (kind in ('mcq', 'frq')),
  source text not null default 'cramapple' check (source in ('cramapple', 'byoq')),
  content_item_id uuid references app.content_items(id),
  content_item_version_id uuid references app.content_item_versions(id),
  byoq_item_id uuid,
  first_attempt_id uuid,
  started_at timestamptz not null default now(),
  grace_deadline timestamptz not null,
  grading_request_ids text[] not null default '{}'::text[],
  transcript_runs integer not null default 0,
  created_at timestamptz not null default now(),
  constraint sample_consumptions_identity check (
    (source = 'cramapple' and content_item_id is not null and content_item_version_id is not null and byoq_item_id is null)
    or (source = 'byoq' and byoq_item_id is not null)
  )
);
create unique index sample_consumptions_item_once on app.sample_consumptions (grant_id, kind, content_item_id) where content_item_id is not null;
create unique index sample_consumptions_byoq_once on app.sample_consumptions (grant_id, byoq_item_id) where byoq_item_id is not null;
comment on table app.sample_consumptions is
  'Paywall sample: allowance ledger. One row per content item per grant, written at server attempt start; grace_deadline is fixed at consumption.';

create table app.sample_consumed_emails (
  email_hash text primary key check (email_hash ~ '^[0-9a-f]{64}$'),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  consumed_at timestamptz not null default now()
);

alter table app.sample_tries enable row level security;
alter table app.sample_tries force row level security;
alter table app.sample_grants enable row level security;
alter table app.sample_grants force row level security;
alter table app.sample_consumptions enable row level security;
alter table app.sample_consumptions force row level security;
alter table app.sample_consumed_emails enable row level security;
alter table app.sample_consumed_emails force row level security;
revoke all on app.sample_tries, app.sample_grants, app.sample_consumptions, app.sample_consumed_emails from public, anon, authenticated;
grant select, insert, update, delete on app.sample_tries, app.sample_grants, app.sample_consumptions, app.sample_consumed_emails to service_role;

-- The imported first-MCQ session is distinguishable in reporting and sweeps.
alter table app.learning_sessions drop constraint learning_sessions_entry_path_check;
alter table app.learning_sessions add constraint learning_sessions_entry_path_check
  check (entry_path = any (array['recommend','topic','check_work','bring_question','recommendation','self_guided_topic','self_guided_format','sample']));

-- ---------------------------------------------------------------------------
-- 3. Core helpers
-- ---------------------------------------------------------------------------
create or replace function app.sample_grant_phase(g app.sample_grants)
returns text language sql stable security definer set search_path = pg_catalog as $$
  select case
    when g.id is null then null
    when g.status = 'superseded' then 'superseded'
    when g.status = 'revoked' then 'revoked'
    when not app.sample_access_enabled() and not app.sample_honor_existing() then 'disabled'
    when now() < g.expires_at then 'active'
    when now() < g.grace_ends_at then 'grace'
    else 'expired'
  end;
$$;

create or replace function app.sample_grant_for(p_user_id uuid)
returns app.sample_grants language sql stable security definer set search_path = pg_catalog as $$
  select g.* from app.sample_grants g where g.user_id = p_user_id;
$$;

-- Staff role or an active regular entitlement for the subject (all_subjects included).
create or replace function app.sample_has_regular_access(p_user_id uuid, p_subject_id uuid)
returns boolean language sql stable security definer set search_path = pg_catalog as $$
  select p_user_id is not null and (
    exists (select 1 from app.profiles p where p.user_id = p_user_id
      and p.role::text in ('admin', 'content_author', 'tutor', 'reader', 'validator'))
    or exists (select 1 from app.subject_entitlements e
      where e.user_id = p_user_id and (e.all_subjects is true or e.subject_id = p_subject_id)
        and e.status = 'active' and e.starts_at <= now()
        and (e.ends_at is null or e.ends_at > now()))
  );
$$;

create or replace function app.sample_subject_id(p_subject_key text)
returns uuid language sql stable security definer set search_path = pg_catalog as $$
  select s.id from app.subjects s
  where s.status = 'active'
    and app.normalize_student_subject_key(s.subject_key) = app.normalize_student_subject_key(p_subject_key)
  limit 1;
$$;

-- Admission: the grant's subject while the clock runs. Nothing else.
create or replace function app.sample_study_access(p_user_id uuid, p_subject_key text)
returns boolean language sql stable security definer set search_path = pg_catalog as $$
  select exists (
    select 1 from app.sample_grants g
    join app.subjects s on s.id = g.subject_id
    where g.user_id = p_user_id
      and app.normalize_student_subject_key(s.subject_key) = app.normalize_student_subject_key(p_subject_key)
      and app.sample_grant_phase(g) = 'active'
  );
$$;

-- Primary unit of an item version (null when unresolved).
create or replace function app.sample_item_unit(p_version_id uuid)
returns integer language sql stable security definer set search_path = pg_catalog as $$
  select r.unit_number from app.content_item_topic_resolution r
  where r.content_item_version_id = p_version_id
  order by r.unit_number limit 1;
$$;

-- The subject's one selectable pack (newest published, not retired).
create or replace function app.sample_pack_for_subject(p_subject_id uuid)
returns uuid language sql stable security definer set search_path = pg_catalog as $$
  select v.id from app.exam_pack_versions v
  join app.exam_packs p on p.id = v.exam_pack_id
  where p.subject_id = p_subject_id and v.status = 'published' and v.retired_at is null
  order by v.created_at desc limit 1;
$$;

revoke all on function app.sample_grant_phase(app.sample_grants), app.sample_grant_for(uuid),
  app.sample_has_regular_access(uuid, uuid), app.sample_subject_id(text), app.sample_study_access(uuid, text),
  app.sample_item_unit(uuid), app.sample_pack_for_subject(uuid) from public, anon, authenticated;
grant execute on function app.sample_grant_phase(app.sample_grants), app.sample_grant_for(uuid),
  app.sample_has_regular_access(uuid, uuid), app.sample_subject_id(text), app.sample_study_access(uuid, text),
  app.sample_item_unit(uuid), app.sample_pack_for_subject(uuid) to service_role;

-- ---------------------------------------------------------------------------
-- 4. Gate 1: subject study access gains the sample branch (admission only)
-- ---------------------------------------------------------------------------
create or replace function app.has_study_subject_access(_user_id uuid, _subject_key text)
returns boolean language sql stable security definer set search_path = pg_catalog
as $$
  select _user_id is not null and (
    exists (select 1 from app.profiles p where p.user_id = _user_id
      and p.role::text in ('admin', 'content_author', 'tutor', 'reader', 'validator'))
    or exists (
      select 1 from app.subject_entitlements e
      join app.subjects entitled_subject on entitled_subject.id = e.subject_id
      where e.user_id = _user_id
        and app.normalize_student_subject_key(entitled_subject.subject_key) = app.normalize_student_subject_key(_subject_key)
        and e.status = 'active' and e.starts_at <= now()
        and (e.ends_at is null or e.ends_at > now())
    )
    or app.sample_study_access(_user_id, _subject_key)
  );
$$;

-- Readback: saved feedback stays readable in every sample phase (plan D8).
create or replace function app.has_study_readback_access(_user_id uuid, _version_id uuid)
returns boolean language sql stable security definer set search_path = pg_catalog as $$
  select app.has_study_pack_access(_user_id, _version_id)
    or exists (
      select 1 from app.sample_grants g
      join app.exam_pack_versions v on v.id = _version_id
      join app.exam_packs p on p.id = v.exam_pack_id
      where g.user_id = _user_id and g.subject_id = p.subject_id
    );
$$;
revoke all on function app.has_study_readback_access(uuid, uuid) from public, anon, authenticated;
grant execute on function app.has_study_readback_access(uuid, uuid) to service_role;

do $patch$
declare
  definition text := pg_get_functiondef('public.get_question_experience(uuid,integer)'::regprocedure);
  anchor text := 'if not app.has_study_pack_access(v_user_id, v_session.exam_pack_version_id) then';
begin
  if strpos(definition, anchor) = 0 or strpos(definition, 'has_study_readback_access') > 0 then
    raise exception 'sample access migration: question experience definition drift';
  end if;
  execute replace(definition, anchor, 'if not app.has_study_readback_access(v_user_id, v_session.exam_pack_version_id) then');
end;
$patch$;

-- Guides: a sample-only caller reads the grant's unit only.
create or replace function public.get_study_topic_point_guides(
  _subject_key text, _unit_number integer default null, _topic_code text default null
)
returns jsonb language plpgsql stable security definer set search_path = pg_catalog
as $$
declare
  v_user uuid := auth.uid();
  v_subject uuid;
  v_grant app.sample_grants;
begin
  if v_user is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  v_subject := app.sample_subject_id(_subject_key);
  if v_subject is not null and app.sample_has_regular_access(v_user, v_subject) then
    return public.get_topic_point_guides(_subject_key, _unit_number, _topic_code);
  end if;
  v_grant := app.sample_grant_for(v_user);
  if v_grant.id is not null and v_grant.subject_id = v_subject and app.sample_grant_phase(v_grant) = 'active' then
    if _unit_number is not null and _unit_number <> v_grant.unit_number then
      raise exception 'sample:unit_locked' using errcode = '42501';
    end if;
    return public.get_topic_point_guides(_subject_key, v_grant.unit_number, _topic_code);
  end if;
  raise exception 'subject_access:entitlement_required' using errcode = '42501';
end;
$$;
revoke all on function public.get_study_topic_point_guides(text, integer, text) from public, anon;
grant execute on function public.get_study_topic_point_guides(text, integer, text) to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 5. Gate 2: attempt creation consumes the allowance (server-recorded start)
-- ---------------------------------------------------------------------------
create or replace function app.sample_gate_attempt_insert()
returns trigger language plpgsql security definer set search_path = pg_catalog as $$
declare
  v_subject uuid;
  v_grant app.sample_grants;
  v_phase text;
  v_unit integer;
  v_policy text;
  v_item uuid;
  v_kind text;
  v_inserted uuid;
  v_count integer;
  v_allowance integer;
begin
  select ep.subject_id into v_subject
  from app.exam_pack_versions epv join app.exam_packs ep on ep.id = epv.exam_pack_id
  where epv.id = new.exam_pack_version_id;

  if app.sample_has_regular_access(new.user_id, v_subject) then
    return new;
  end if;

  select g.* into v_grant from app.sample_grants g where g.user_id = new.user_id for update;
  if v_grant.id is null then
    return new;  -- no sample, no change: create_attempt was never gated here
  end if;

  if v_grant.subject_id is distinct from v_subject then
    raise exception 'sample:subject_locked' using errcode = '42501';
  end if;

  v_phase := app.sample_grant_phase(v_grant);
  if v_phase = 'grace' then
    raise exception 'sample:grace_no_new_questions' using errcode = '42501';
  elsif v_phase <> 'active' then
    raise exception 'sample:%', v_phase using errcode = '42501';
  end if;

  select ci.id, ci.response_policy into v_item, v_policy
  from app.content_item_versions civ join app.content_items ci on ci.id = civ.content_item_id
  where civ.id = new.content_item_version_id;
  if v_policy = 'photo_required' then
    raise exception 'sample:item_not_included' using errcode = '42501';
  end if;

  v_unit := app.sample_item_unit(new.content_item_version_id);
  if v_unit is null or v_unit <> v_grant.unit_number then
    raise exception 'sample:item_outside_unit' using errcode = '42501';
  end if;

  v_kind := case when new.attempt_mode = 'mcq' then 'mcq' else 'frq' end;
  v_allowance := case when v_kind = 'mcq' then v_grant.mcq_allowance else v_grant.frq_allowance end;

  insert into app.sample_consumptions (grant_id, kind, source, content_item_id, content_item_version_id, first_attempt_id, grace_deadline)
  values (v_grant.id, v_kind, 'cramapple', v_item, new.content_item_version_id, new.id, v_grant.grace_ends_at)
  on conflict (grant_id, kind, content_item_id) where content_item_id is not null do nothing
  returning id into v_inserted;

  if v_inserted is not null then
    select count(*) into v_count from app.sample_consumptions c where c.grant_id = v_grant.id and c.kind = v_kind;
    if v_count > v_allowance then
      raise exception 'sample:%_allowance_exhausted', v_kind using errcode = '42501';
    end if;
  end if;
  return new;
end;
$$;
revoke all on function app.sample_gate_attempt_insert() from public, anon, authenticated;
create trigger sample_gate_attempt_insert
before insert on app.attempts
for each row execute function app.sample_gate_attempt_insert();

-- ---------------------------------------------------------------------------
-- 6. Gate 3: grading authorization (clock + fixed grace, bounded requests)
-- ---------------------------------------------------------------------------
create or replace function app.authorize_grading_access(
  p_user_id uuid, p_attempt_id uuid, p_operation text, p_request_id text
) returns text
language plpgsql security definer set search_path = app, public as $$
declare
  v_subject_id uuid;
  v_item_id uuid;
  v_grant app.sample_grants;
  v_consumption app.sample_consumptions;
  v_phase text;
begin
  select ep.subject_id, civ.content_item_id into v_subject_id, v_item_id
  from app.attempts a
  join app.exam_pack_versions epv on epv.id = a.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.content_item_versions civ on civ.id = a.content_item_version_id
  where a.id = p_attempt_id and a.user_id = p_user_id;

  if v_subject_id is null then
    raise exception 'grading_access:attempt_not_found';
  end if;

  if exists (
    select 1 from app.subject_entitlements se
    where se.user_id = p_user_id
      and se.subject_id = v_subject_id
      and se.status = 'active'
      and se.starts_at <= now()
      and (se.ends_at is null or se.ends_at > now())
  ) then
    return 'entitled';
  end if;

  -- Sample branch: only reached when no regular entitlement applies.
  select g.* into v_grant from app.sample_grants g where g.user_id = p_user_id for update;
  if v_grant.id is not null then
    select c.* into v_consumption from app.sample_consumptions c
    where c.grant_id = v_grant.id and c.content_item_id = v_item_id for update;
    if v_consumption.id is not null then
      v_phase := app.sample_grant_phase(v_grant);
      if v_phase in ('superseded', 'revoked', 'disabled', 'expired') then
        raise exception 'grading_access:sample_%', v_phase;
      end if;
      if v_phase = 'grace' and now() >= v_consumption.grace_deadline then
        raise exception 'grading_access:sample_expired';
      end if;
      if p_operation not in ('submit_response', 'grade_initial_attempt') then
        raise exception 'grading_access:sample_operation_not_included';
      end if;
      if p_operation = 'grade_initial_attempt'
         and not (p_request_id = any (v_consumption.grading_request_ids)) then
        if coalesce(array_length(v_consumption.grading_request_ids, 1), 0) >= 3 then
          raise exception 'grading_access:sample_grading_limit_reached';
        end if;
        update app.sample_consumptions
        set grading_request_ids = array_append(grading_request_ids, p_request_id)
        where id = v_consumption.id;
      end if;
      return case when v_phase = 'grace' then 'sample_grace' else 'sample' end;
    end if;
  end if;

  raise exception 'grading_access:entitlement_required';
end;
$$;
revoke all on function app.authorize_grading_access(uuid, uuid, text, text) from public, anon, authenticated;
grant execute on function app.authorize_grading_access(uuid, uuid, text, text) to service_role;

-- Photo extraction runs per sample FRQ (spec §7).
create or replace function app.sample_take_photo_run(p_user_id uuid, p_attempt_id uuid)
returns text language plpgsql security definer set search_path = pg_catalog as $$
declare
  v_subject uuid; v_item uuid; v_grant app.sample_grants; v_runs integer;
begin
  select ep.subject_id, civ.content_item_id into v_subject, v_item
  from app.attempts a
  join app.exam_pack_versions epv on epv.id = a.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.content_item_versions civ on civ.id = a.content_item_version_id
  where a.id = p_attempt_id and a.user_id = p_user_id;
  if v_subject is null then raise exception 'sample:attempt_not_found' using errcode = '42501'; end if;
  if app.sample_has_regular_access(p_user_id, v_subject) then return 'not_sample'; end if;
  select g.* into v_grant from app.sample_grants g where g.user_id = p_user_id;
  if v_grant.id is null then return 'not_sample'; end if;
  update app.sample_consumptions c set transcript_runs = c.transcript_runs + 1
  where c.grant_id = v_grant.id and c.content_item_id = v_item
  returning c.transcript_runs into v_runs;
  if v_runs is null then raise exception 'sample:attempt_not_found' using errcode = '42501'; end if;
  if v_runs > 3 then raise exception 'sample:extraction_limit_reached' using errcode = '42501'; end if;
  return 'ok';
end;
$$;
revoke all on function app.sample_take_photo_run(uuid, uuid) from public, anon, authenticated;
grant execute on function app.sample_take_photo_run(uuid, uuid) to service_role;

-- Serving scope for student-session-items (null = not a sample-only caller).
create or replace function app.sample_serving_scope(p_user_id uuid, p_exam_pack_version_id uuid)
returns jsonb language plpgsql stable security definer set search_path = pg_catalog as $$
declare v_subject uuid; v_grant app.sample_grants; v_mcq integer; v_frq integer;
begin
  select ep.subject_id into v_subject from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id where epv.id = p_exam_pack_version_id;
  if app.sample_has_regular_access(p_user_id, v_subject) then return null; end if;
  select g.* into v_grant from app.sample_grants g where g.user_id = p_user_id;
  if v_grant.id is null then return null; end if;
  select count(*) filter (where kind = 'mcq'), count(*) filter (where kind = 'frq') into v_mcq, v_frq
  from app.sample_consumptions where grant_id = v_grant.id;
  return jsonb_build_object(
    'unit_number', v_grant.unit_number,
    'phase', app.sample_grant_phase(v_grant),
    'subject_matches', v_grant.subject_id = v_subject,
    'mcq_remaining', greatest(v_grant.mcq_allowance - v_mcq, 0),
    'frq_remaining', greatest(v_grant.frq_allowance - v_frq, 0),
    'consumed_item_ids', coalesce((select jsonb_agg(c.content_item_id) from app.sample_consumptions c
       where c.grant_id = v_grant.id and c.content_item_id is not null), '[]'::jsonb));
end;
$$;
revoke all on function app.sample_serving_scope(uuid, uuid) from public, anon, authenticated;
grant execute on function app.sample_serving_scope(uuid, uuid) to service_role;

-- ---------------------------------------------------------------------------
-- 7. Trial precedence: any active regular entitlement supersedes the sample for good
-- ---------------------------------------------------------------------------
create or replace function app.sample_supersede_on_entitlement()
returns trigger language plpgsql security definer set search_path = pg_catalog as $$
begin
  if new.status = 'active' and new.starts_at <= now() and (new.ends_at is null or new.ends_at > now())
     and new.access_tier in ('trial', 'paid', 'beta') then
    update app.sample_grants g
    set status = 'superseded', superseded_at = now(), superseded_by = new.access_tier
    where g.user_id = new.user_id and g.status = 'active';
  end if;
  return new;
end;
$$;
revoke all on function app.sample_supersede_on_entitlement() from public, anon, authenticated;
create trigger sample_supersede_on_entitlement
after insert or update of status, ends_at, starts_at on app.subject_entitlements
for each row execute function app.sample_supersede_on_entitlement();

-- ---------------------------------------------------------------------------
-- 8. Unit availability and sample MCQ selection
-- ---------------------------------------------------------------------------
create or replace function app.sample_unit_availability(p_subject_key text)
returns jsonb language sql stable security definer set search_path = pg_catalog as $$
  with subj as (select app.sample_subject_id(p_subject_key) as id),
  pack as (select app.sample_pack_for_subject((select id from subj)) as id),
  items as (
    select r.unit_number, ci.item_type,
      (ci.item_type = 'mcq' and civ.stimulus_image_path is null
        and not exists (select 1 from app.open_hand_teaching_items t where t.content_item_id = ci.id and t.released_at is null)
        and (select count(*) from app.mcq_choices mc where mc.content_item_version_id = civ.id and mc.is_correct) = 1) as mcq_ok,
      (ci.item_type = 'frq' and ci.practice_format = 'targeted_drill' and coalesce(ci.response_policy, '') <> 'photo_required') as frq_ok
    from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
    join app.content_item_topic_resolution r on r.content_item_version_id = civ.id
    where ci.exam_pack_version_id = (select id from pack) and ci.status = 'published'
      and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true
  ),
  counts as (
    select unit_number, count(*) filter (where mcq_ok) as mcq_available, count(*) filter (where frq_ok) as frq_available
    from items group by unit_number
  ),
  titles as (
    select distinct tt.unit_number, tt.unit_title
    from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv on tsv.taxonomy_source_version = tt.taxonomy_source_version
    where app.normalize_student_subject_key(tsv.subject_key) = app.normalize_student_subject_key(p_subject_key)
  )
  select coalesce(jsonb_agg(jsonb_build_object(
    'unit_number', c.unit_number,
    'unit_title', (select t.unit_title from titles t where t.unit_number = c.unit_number limit 1),
    'mcq_available', c.mcq_available,
    'frq_available', c.frq_available,
    'eligible', c.mcq_available >= 8 and c.frq_available >= 1) order by c.unit_number), '[]'::jsonb)
  from counts c;
$$;

create or replace function app.select_sample_mcq(p_exam_pack_version_id uuid, p_unit_number integer, p_exclude_items uuid[], p_seed text)
returns uuid language sql stable security definer set search_path = pg_catalog as $$
  select civ.id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
  join app.content_item_topic_resolution r on r.content_item_version_id = civ.id
  where ci.exam_pack_version_id = p_exam_pack_version_id
    and ci.status = 'published' and ci.item_type = 'mcq'
    and r.unit_number = p_unit_number
    and civ.stimulus_image_path is null
    and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true
    and not exists (select 1 from app.open_hand_teaching_items t where t.content_item_id = ci.id and t.released_at is null)
    and (select count(*) from app.mcq_choices mc where mc.content_item_version_id = civ.id and mc.is_correct) = 1
    and not (ci.id = any (coalesce(p_exclude_items, '{}'::uuid[])))
  order by md5(civ.id::text || coalesce(p_seed, '')) limit 1;
$$;
revoke all on function app.sample_unit_availability(text), app.select_sample_mcq(uuid, integer, uuid[], text) from public, anon, authenticated;
grant execute on function app.sample_unit_availability(text), app.select_sample_mcq(uuid, integer, uuid[], text) to service_role;

-- ---------------------------------------------------------------------------
-- 9. Anonymous try: start / answer / status (service role only; the edge
--    function validates, rate-limits and hashes the token)
-- ---------------------------------------------------------------------------
create or replace function app.sample_try_question(t app.sample_tries)
returns jsonb language sql stable security definer set search_path = pg_catalog as $$
  select jsonb_build_object(
    'content_item_version_id', civ.id,
    'content_item_id', ci.id,
    'title', ci.title,
    'stem', civ.stem,
    'stimulus', civ.stimulus,
    'topic', (select jsonb_build_object('topic_code', r.topic_code, 'topic_title', r.topic_title, 'unit_number', r.unit_number)
              from app.content_item_topic_resolution r where r.content_item_version_id = civ.id limit 1),
    'choices', coalesce((select jsonb_agg(jsonb_build_object('choice_key', mc.choice_key, 'choice_text', mc.choice_text) order by mc.choice_key)
               from app.mcq_choices mc where mc.content_item_version_id = civ.id), '[]'::jsonb))
  from app.content_item_versions civ join app.content_items ci on ci.id = civ.content_item_id
  where civ.id = t.content_item_version_id;
$$;

create or replace function app.sample_try_feedback(t app.sample_tries)
returns jsonb language sql stable security definer set search_path = pg_catalog as $$
  select case when t.answered_at is null then null else jsonb_build_object(
    'content_item_version_id', t.content_item_version_id,
    'picked_choice_key', t.picked_choice_key,
    'earned', t.points_earned,
    'possible', 1,
    'choices', coalesce((select jsonb_agg(jsonb_build_object('choice_key', mc.choice_key, 'choice_text', mc.choice_text,
                 'is_correct', mc.is_correct, 'rationale', mc.rationale) order by mc.choice_key)
               from app.mcq_choices mc where mc.content_item_version_id = t.content_item_version_id), '[]'::jsonb),
    'explanation', (select civ.explanation from app.content_item_versions civ where civ.id = t.content_item_version_id)) end;
$$;

create or replace function app.sample_try_view(t app.sample_tries, p_include_question boolean)
returns jsonb language sql stable security definer set search_path = pg_catalog as $$
  select jsonb_build_object(
    'try_id', t.id,
    'status', t.status,
    'subject_key', (select s.subject_key from app.subjects s where s.id = t.subject_id),
    'exam_pack_version_id', t.exam_pack_version_id,
    'unit_number', t.unit_number,
    'served_at', t.served_at,
    'answer_expires_at', t.answer_expires_at,
    'answered_at', t.answered_at,
    'claim_expires_at', t.claim_expires_at,
    'switch_count', t.switch_count,
    'question', case when p_include_question then app.sample_try_question(t) end,
    'feedback', app.sample_try_feedback(t));
$$;

create or replace function app.sample_try_start(
  p_subject_key text, p_unit_number integer, p_existing_token_hash text, p_new_token_hash text,
  p_ip_hmac text, p_attribution jsonb
) returns jsonb language plpgsql security definer set search_path = pg_catalog as $$
declare
  v_subject uuid; v_pack uuid; v_existing app.sample_tries; v_new app.sample_tries;
  v_switch integer := 0; v_supersedes uuid := null; v_avail jsonb; v_version uuid;
begin
  if not app.sample_access_enabled() then raise exception 'sample_try:disabled' using errcode = '42501'; end if;
  if p_new_token_hash is null or p_new_token_hash !~ '^[0-9a-f]{64}$' then
    raise exception 'sample_try:invalid_token' using errcode = '22023';
  end if;
  v_subject := app.sample_subject_id(p_subject_key);
  if v_subject is null then raise exception 'sample_try:unknown_subject' using errcode = '22023'; end if;
  v_pack := app.sample_pack_for_subject(v_subject);
  v_avail := app.sample_unit_availability(p_subject_key);
  if v_pack is null or not exists (
    select 1 from jsonb_array_elements(v_avail) u
    where (u->>'unit_number')::integer = p_unit_number and (u->>'eligible')::boolean) then
    raise exception 'sample_try:unit_unavailable' using errcode = '22023', detail = v_avail::text;
  end if;

  if p_existing_token_hash is not null then
    select t.* into v_existing from app.sample_tries t where t.token_hash = p_existing_token_hash for update;
  end if;
  if v_existing.id is not null then
    if v_existing.status = 'served' and now() >= v_existing.answer_expires_at then
      update app.sample_tries set status = 'expired' where id = v_existing.id;
      v_existing := null;
    end if;
  end if;
  if v_existing.id is not null then
    if v_existing.status = 'answered' then
      return jsonb_build_object('outcome', 'register_required', 'issued_new_token', false, 'try', app.sample_try_view(v_existing, false));
    elsif v_existing.status = 'claimed' then
      return jsonb_build_object('outcome', 'claimed', 'issued_new_token', false, 'try', app.sample_try_view(v_existing, false));
    elsif v_existing.status = 'served' then
      if v_existing.subject_id = v_subject and v_existing.unit_number = p_unit_number then
        return jsonb_build_object('outcome', 'resumed', 'issued_new_token', false, 'try', app.sample_try_view(v_existing, true));
      end if;
      if v_existing.switch_count >= 3 then
        raise exception 'sample_try:switch_limit_reached' using errcode = '42501';
      end if;
      update app.sample_tries set status = 'superseded' where id = v_existing.id;
      v_switch := v_existing.switch_count + 1;
      v_supersedes := v_existing.id;
    end if;
    -- 'superseded' / 'expired': fall through and start fresh
  end if;

  v_version := app.select_sample_mcq(v_pack, p_unit_number, '{}'::uuid[], p_new_token_hash);
  if v_version is null then
    raise exception 'sample_try:unit_unavailable' using errcode = '22023', detail = v_avail::text;
  end if;

  insert into app.sample_tries (token_hash, subject_id, exam_pack_version_id, unit_number, content_item_version_id,
    ip_hmac, attribution, supersedes_try_id, switch_count)
  values (p_new_token_hash, v_subject, v_pack, p_unit_number, v_version,
    p_ip_hmac, coalesce(p_attribution, '{}'::jsonb), v_supersedes, v_switch)
  returning * into v_new;
  return jsonb_build_object('outcome', 'created', 'issued_new_token', true, 'try', app.sample_try_view(v_new, true));
end;
$$;

create or replace function app.sample_try_answer(p_token_hash text, p_choice_key text)
returns jsonb language plpgsql security definer set search_path = pg_catalog as $$
declare v_try app.sample_tries; v_correct text; v_valid boolean;
begin
  if not app.sample_access_enabled() then raise exception 'sample_try:disabled' using errcode = '42501'; end if;
  select t.* into v_try from app.sample_tries t where t.token_hash = p_token_hash for update;
  if v_try.id is null then raise exception 'sample_try:not_found' using errcode = '22023'; end if;
  if v_try.status = 'answered' or v_try.status = 'claimed' then
    if v_try.picked_choice_key = p_choice_key then
      return jsonb_build_object('outcome', 'replayed', 'try', app.sample_try_view(v_try, false));
    end if;
    raise exception 'sample_try:already_answered' using errcode = '42501', detail = app.sample_try_view(v_try, false)::text;
  end if;
  if v_try.status <> 'served' or now() >= v_try.answer_expires_at then
    update app.sample_tries set status = 'expired' where id = v_try.id and status = 'served';
    raise exception 'sample_try:expired' using errcode = '42501';
  end if;
  select bool_or(mc.choice_key = p_choice_key), max(mc.choice_key) filter (where mc.is_correct)
    into v_valid, v_correct
  from app.mcq_choices mc where mc.content_item_version_id = v_try.content_item_version_id;
  if not coalesce(v_valid, false) then raise exception 'sample_try:invalid_choice' using errcode = '22023'; end if;
  update app.sample_tries
  set status = 'answered', answered_at = now(), picked_choice_key = p_choice_key,
      is_correct = (p_choice_key = v_correct), points_earned = case when p_choice_key = v_correct then 1 else 0 end,
      claim_expires_at = now() + interval '7 days'
  where id = v_try.id returning * into v_try;
  return jsonb_build_object('outcome', 'answered', 'try', app.sample_try_view(v_try, false));
end;
$$;

create or replace function app.sample_try_status(p_token_hash text)
returns jsonb language sql stable security definer set search_path = pg_catalog as $$
  select coalesce((select app.sample_try_view(t, t.status = 'served') from app.sample_tries t where t.token_hash = p_token_hash),
                  jsonb_build_object('status', 'not_found'));
$$;

revoke all on function app.sample_try_question(app.sample_tries), app.sample_try_feedback(app.sample_tries),
  app.sample_try_view(app.sample_tries, boolean), app.sample_try_start(text, integer, text, text, text, jsonb),
  app.sample_try_answer(text, text), app.sample_try_status(text) from public, anon, authenticated;
grant execute on function app.sample_try_question(app.sample_tries), app.sample_try_feedback(app.sample_tries),
  app.sample_try_view(app.sample_tries, boolean), app.sample_try_start(text, integer, text, text, text, jsonb),
  app.sample_try_answer(text, text), app.sample_try_status(text) to service_role;

-- ---------------------------------------------------------------------------
-- 10. State readback for the app
-- ---------------------------------------------------------------------------
create or replace function app.sample_access_state(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path = pg_catalog as $$
declare v_grant app.sample_grants; v_email text; v_mcq integer; v_frq integer; v_state jsonb;
begin
  select u.email into v_email from auth.users u where u.id = p_user_id;
  select g.* into v_grant from app.sample_grants g where g.user_id = p_user_id;
  if v_grant.id is not null then
    select count(*) filter (where kind = 'mcq'), count(*) filter (where kind = 'frq') into v_mcq, v_frq
    from app.sample_consumptions where grant_id = v_grant.id;
  end if;
  v_state := jsonb_build_object(
    'enabled', app.sample_access_enabled(),
    'honor_existing', app.sample_honor_existing(),
    'has_grant', v_grant.id is not null,
    'grant', case when v_grant.id is null then null else jsonb_build_object(
      'id', v_grant.id,
      'subject_key', (select s.subject_key from app.subjects s where s.id = v_grant.subject_id),
      'exam_pack_version_id', v_grant.exam_pack_version_id,
      'unit_number', v_grant.unit_number,
      'status', v_grant.status,
      'phase', app.sample_grant_phase(v_grant),
      'activated_at', v_grant.activated_at,
      'expires_at', v_grant.expires_at,
      'grace_ends_at', v_grant.grace_ends_at,
      'now', now(),
      'mcq', jsonb_build_object('total', v_grant.mcq_allowance, 'used', v_mcq, 'remaining', greatest(v_grant.mcq_allowance - v_mcq, 0)),
      'frq', jsonb_build_object('total', v_grant.frq_allowance, 'used', v_frq, 'remaining', greatest(v_grant.frq_allowance - v_frq, 0)),
      'learning_session_id', v_grant.learning_session_id,
      'in_progress', coalesce((
        select jsonb_agg(jsonb_build_object('kind', c.kind, 'content_item_version_id', c.content_item_version_id,
          'attempt_id', c.first_attempt_id, 'started_at', c.started_at, 'grace_deadline', c.grace_deadline,
          'transcript_runs', c.transcript_runs) order by c.started_at)
        from app.sample_consumptions c
        where c.grant_id = v_grant.id and not exists (
          select 1 from app.attempts a where a.user_id = p_user_id
            and a.content_item_version_id = c.content_item_version_id and a.status = 'graded')), '[]'::jsonb),
      'superseded_by', v_grant.superseded_by) end,
    'offer_context', jsonb_build_object(
      'has_regular_entitlement', exists (select 1 from app.subject_entitlements e where e.user_id = p_user_id
        and e.status = 'active' and e.starts_at <= now() and (e.ends_at is null or e.ends_at > now())),
      'trial_email_consumed', case when v_email is null then null else app.trial_email_consumed(v_email) end,
      'attribution', coalesce(v_grant.attribution, '{}'::jsonb)));
  return v_state;
end;
$$;
revoke all on function app.sample_access_state(uuid) from public, anon, authenticated;
grant execute on function app.sample_access_state(uuid) to service_role;

create or replace function public.get_sample_access_state()
returns jsonb language plpgsql stable security definer set search_path = pg_catalog as $$
begin
  if auth.uid() is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  return app.sample_access_state(auth.uid());
end;
$$;
revoke all on function public.get_sample_access_state() from public, anon;
grant execute on function public.get_sample_access_state() to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 11. Claim: registration succeeded (caller is authenticated) AND the first
--     answer is saved, in one transaction. The clock starts at this commit.
-- ---------------------------------------------------------------------------
create or replace function app.claim_sample_try(p_user_id uuid, p_token_hash text)
returns jsonb language plpgsql security definer set search_path = pg_catalog as $$
declare
  v_try app.sample_tries; v_role text; v_email text; v_email_hash text; v_grant app.sample_grants;
  v_session app.learning_sessions; v_attempt app.attempts; v_rv app.response_versions; v_rationale text;
  v_now timestamptz := now(); v_audit_id text;
begin
  if p_user_id is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  if not app.sample_access_enabled() then raise exception 'sample:disabled' using errcode = '42501'; end if;
  perform pg_advisory_xact_lock(hashtextextended('sample_claim:' || p_user_id::text, 0));

  select t.* into v_try from app.sample_tries t where t.token_hash = p_token_hash for update;
  if v_try.id is null then raise exception 'sample:try_not_found' using errcode = '42501'; end if;
  if v_try.claimed_by_user_id = p_user_id then
    return app.sample_access_state(p_user_id);  -- idempotent replay
  end if;
  if v_try.claimed_by_user_id is not null then raise exception 'sample:try_claimed_elsewhere' using errcode = '42501'; end if;
  if v_try.status <> 'answered' then raise exception 'sample:try_not_answered' using errcode = '42501'; end if;
  if v_now >= v_try.claim_expires_at then raise exception 'sample:try_claim_expired' using errcode = '42501'; end if;

  select p.role::text into v_role from app.profiles p where p.user_id = p_user_id;
  if v_role is distinct from 'student' then raise exception 'sample:not_student' using errcode = '42501'; end if;
  select u.email into v_email from auth.users u where u.id = p_user_id;
  if v_email is null or btrim(v_email) = '' then raise exception 'sample:email_required' using errcode = '42501'; end if;
  v_email_hash := app.trial_email_hash(v_email);
  if exists (select 1 from app.sample_grants g where g.user_id = p_user_id) then
    raise exception 'sample:already_sampled' using errcode = '42501';
  end if;
  if exists (select 1 from app.sample_consumed_emails e where e.email_hash = v_email_hash) then
    raise exception 'sample:email_already_sampled' using errcode = '42501';
  end if;
  if exists (select 1 from app.subject_entitlements e where e.user_id = p_user_id) then
    raise exception 'sample:not_eligible_prior_access' using errcode = '42501';
  end if;
  if app.trial_email_consumed(v_email) then
    raise exception 'sample:not_eligible_prior_trial' using errcode = '42501';
  end if;

  insert into app.sample_grants (user_id, email_hash, subject_id, exam_pack_version_id, unit_number, try_id,
    activated_at, expires_at, grace_ends_at, attribution)
  values (p_user_id, v_email_hash, v_try.subject_id, v_try.exam_pack_version_id, v_try.unit_number, v_try.id,
    v_now, v_now + interval '72 hours', v_now + interval '144 hours', coalesce(v_try.attribution, '{}'::jsonb))
  returning * into v_grant;
  insert into app.sample_consumed_emails (email_hash, user_id) values (v_email_hash, p_user_id);

  -- Import the first MCQ as real study data (service-definer writes).
  update app.profiles set active_exam_pack_version_id = v_try.exam_pack_version_id where user_id = p_user_id;
  insert into app.learning_sessions (user_id, exam_pack_version_id, entry_path, session_mode, practice_format,
    available_minutes, status, start_idempotency_key, start_request_fingerprint)
  values (p_user_id, v_try.exam_pack_version_id, 'sample', 'quick', 'mcq', 10, 'active',
    'sample-try:' || v_try.id::text, '10:mcq:sample')
  returning * into v_session;
  perform app.append_learning_session_items(v_session.id, array[v_try.content_item_version_id]);
  insert into app.attempts (user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode,
    status, assistance_state, started_at, submitted_at, graded_at, score_points, score_possible, result_state)
  values (p_user_id, v_session.id, v_try.exam_pack_version_id, v_try.content_item_version_id, 'mcq',
    'graded', 'independent', v_try.served_at, v_try.answered_at, v_now, v_try.points_earned, 1,
    case when v_try.is_correct then 'correct' else 'incorrect' end)
  returning * into v_attempt;
  insert into app.response_versions (attempt_id, response_text, version_number, is_submitted, created_by, submitted_at)
  values (v_attempt.id, v_try.picked_choice_key, 1, true, p_user_id, v_try.answered_at)
  returning * into v_rv;
  select mc.rationale into v_rationale from app.mcq_choices mc
  where mc.content_item_version_id = v_try.content_item_version_id and mc.choice_key = v_try.picked_choice_key;
  insert into app.grading_results (request_id, request_hash, attempt_id, response_version_id, operation, status,
    points_earned, points_available, criterion_results, confidence, model_id, prompt_version, feedback_preview, created_at)
  values ('sample-try:' || v_try.id::text,
    encode(sha256(convert_to('sample-try:' || v_try.id::text || ':' || v_try.picked_choice_key, 'UTF8')), 'hex'),
    v_attempt.id, v_rv.id, 'grade_initial_attempt', 'graded', v_try.points_earned, 1,
    jsonb_build_array(jsonb_build_object('criterion_key', 'mcq_correct_choice',
      'status', case when v_try.is_correct then 'earned' else 'not_yet_earned' end,
      'points_awarded', v_try.points_earned, 'evidence_quote', v_try.picked_choice_key,
      'decision_explanation', 'Deterministic MCQ check recorded from the anonymous sample try.')),
    'high', 'sample_try_deterministic', 'sample-try-v1', v_rationale, v_now);

  update app.sample_grants set learning_session_id = v_session.id where id = v_grant.id;
  update app.sample_tries set status = 'claimed', claimed_by_user_id = p_user_id, claimed_at = v_now, grant_id = v_grant.id
  where id = v_try.id;

  v_audit_id := gen_random_uuid()::text;
  insert into app.audit_events (audit_event_id, occurred_at, actor_type, actor_id, action, object_type, object_id,
    request_id, reason_code, metadata, event_sha256, actor_user_id, subject_user_id)
  values (v_audit_id, v_now, 'human', p_user_id::text, 'sample.claim', 'sample_grant', v_grant.id,
    'sample-claim:' || v_try.id::text, 'sample_claim',
    jsonb_build_object('try_id', v_try.id, 'grant_id', v_grant.id, 'learning_session_id', v_session.id, 'attempt_id', v_attempt.id),
    encode(sha256(convert_to(v_audit_id || ':' || v_grant.id::text, 'UTF8')), 'hex'), p_user_id, p_user_id);

  return app.sample_access_state(p_user_id);
end;
$$;
revoke all on function app.claim_sample_try(uuid, text) from public, anon, authenticated;
grant execute on function app.claim_sample_try(uuid, text) to service_role;

create or replace function public.claim_sample_try(p_try_token text)
returns jsonb language plpgsql security definer set search_path = pg_catalog as $$
begin
  if auth.uid() is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  if p_try_token is null or char_length(p_try_token) not between 32 and 200 then
    raise exception 'sample:try_not_found' using errcode = '42501';
  end if;
  return app.claim_sample_try(auth.uid(), encode(sha256(convert_to(p_try_token, 'UTF8')), 'hex'));
end;
$$;
revoke all on function public.claim_sample_try(text) from public, anon;
grant execute on function public.claim_sample_try(text) to authenticated, service_role;

-- Reserved: student-uploaded FRQ as the sample FRQ (spec §11, blocker).
create or replace function public.claim_sample_frq_source(p_byoq_item_id uuid)
returns jsonb language plpgsql security definer set search_path = pg_catalog as $$
begin
  if auth.uid() is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  raise exception 'sample:byoq_grading_not_available' using errcode = '42501';
end;
$$;
revoke all on function public.claim_sample_frq_source(uuid) from public, anon;
grant execute on function public.claim_sample_frq_source(uuid) to authenticated, service_role;

commit;
