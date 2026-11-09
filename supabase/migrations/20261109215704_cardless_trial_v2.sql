-- Cardless 7-day single-subject trial (trial_v2).
-- Spec: docs/product/FREE_TRIAL_NO_CARD_BACKEND_DESIGN_SPEC_2026_11_09.md
-- Authority: DECISION-0135, APPROVAL-0208 (Development only; every Production
-- step is its own approval).
--
-- One app.subject_entitlements row per trial: access_tier 'trial', source
-- 'trial_v2', one subject, ends_at = starts_at + 7 days. Existing gates admit it
-- and deny it after ends_at; nothing here changes how access is decided during
-- the trial. New: a start RPC behind app.config.cardless_trial_enabled (false),
-- one trial per email via app.trial_consumed_emails, a state read for /home,
-- readback of own work after day 7, and a trial-only daily grading ceiling.
--
-- Not in this file (spec §10): dropping the legacy app.start_trial. That waits
-- for CARDLESS_TRIAL_RETIRED=true on the live start-trial function (its own
-- approval), otherwise that function would answer 500 instead of 410.

begin;

-- ---------------------------------------------------------------- switches
insert into app.config (config_key, config_value, is_public, description) values
  ('cardless_trial_enabled', 'false'::jsonb, false,
   'DECISION-0135: when true, public.start_subject_trial grants 7-day single-subject trials (trial_v2). Default off.'),
  ('trial_daily_grading_cap', '40'::jsonb, false,
   'DECISION-0135 D5: graded attempts (grade_initial_attempt + grade_revision) per rolling 24 h allowed to a trial_v2-only student before grading_access:trial_daily_cap.')
on conflict (config_key) do nothing;

-- ------------------------------------------- consumed-email source check
-- The TASK-0077 table only allowed trial_v1 / stripe_trial_v1 sources (found by
-- the integration test on the first Development run).
alter table app.trial_consumed_emails drop constraint trial_consumed_emails_source_check;
alter table app.trial_consumed_emails add constraint trial_consumed_emails_source_check
  check (source in ('trial_v1', 'stripe_trial_v1', 'trial_v2'));

-- ------------------------------------------------- grading ceiling log table
create table if not exists app.trial_grading_log (
  request_id text primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  subject_id uuid not null references app.subjects (id),
  operation text not null,
  created_at timestamptz not null default now()
);
create index if not exists trial_grading_log_user_created_idx
  on app.trial_grading_log (user_id, created_at desc);
alter table app.trial_grading_log enable row level security;
alter table app.trial_grading_log force row level security;
revoke all on app.trial_grading_log from public, anon, authenticated;

-- ------------------------------------------------------------- state read
create or replace function app.trial_v2_state(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path = pg_catalog as $$
declare
  v_enabled boolean := coalesce((select (config_value)::text = 'true' from app.config where config_key = 'cardless_trial_enabled'), false);
  v_email text;
  v_row record;
  v_regular boolean := false;
  v_consumed boolean := false;
  v_phase text;
  v_now timestamptz := now();
begin
  if p_user_id is null then
    return jsonb_build_object('phase', 'none', 'can_start', false, 'blocked_reason', 'not_authenticated');
  end if;

  select e.starts_at, e.ends_at, s.subject_key, s.display_name, s.id as subject_id
    into v_row
  from app.subject_entitlements e
  join app.subjects s on s.id = e.subject_id
  where e.user_id = p_user_id and e.access_tier = 'trial' and e.source = 'trial_v2'
  order by e.created_at desc limit 1;

  if v_row.subject_id is not null then
    v_regular := exists (
      select 1 from app.subject_entitlements e
      where e.user_id = p_user_id and e.subject_id = v_row.subject_id
        and e.access_tier in ('paid', 'beta') and e.status = 'active'
        and e.starts_at <= v_now and (e.ends_at is null or e.ends_at > v_now));
    v_phase := case when v_regular then 'superseded'
                    when v_now < v_row.ends_at then 'active'
                    else 'ended' end;
    return jsonb_build_object(
      'phase', v_phase,
      'can_start', false,
      'blocked_reason', null,
      'subject_key', v_row.subject_key,
      'subject_name', v_row.display_name,
      'starts_at', v_row.starts_at,
      'ends_at', v_row.ends_at,
      'days_remaining', greatest(0, ceil(extract(epoch from (v_row.ends_at - v_now)) / 86400.0))::int,
      'seconds_remaining', greatest(0, floor(extract(epoch from (v_row.ends_at - v_now))))::int,
      'ends_eastern', to_char(v_row.ends_at at time zone 'America/New_York', 'FMDay, FMMonth FMDD, YYYY'),
      'has_regular_entitlement', v_regular,
      'checkout_subject_key', v_row.subject_key,
      'server_now', v_now);
  end if;

  select u.email into v_email from auth.users u where u.id = p_user_id;
  v_consumed := v_email is not null and app.trial_email_consumed(v_email);

  return jsonb_build_object(
    'phase', case when v_enabled and not v_consumed then 'none' else 'blocked' end,
    'can_start', v_enabled and not v_consumed,
    'blocked_reason', case when not v_enabled then 'disabled' when v_consumed then 'already_used' else null end,
    'subject_key', null, 'subject_name', null, 'starts_at', null, 'ends_at', null,
    'days_remaining', null, 'seconds_remaining', null, 'ends_eastern', null,
    'has_regular_entitlement', false, 'checkout_subject_key', null,
    'server_now', v_now);
end;
$$;
revoke all on function app.trial_v2_state(uuid) from public, anon, authenticated;
grant execute on function app.trial_v2_state(uuid) to service_role;

create or replace function public.get_trial_state()
returns jsonb language plpgsql stable security definer set search_path = pg_catalog as $$
begin
  if auth.uid() is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  return app.trial_v2_state(auth.uid());
end;
$$;
revoke all on function public.get_trial_state() from public, anon;
grant execute on function public.get_trial_state() to authenticated;

-- ------------------------------------------------------------------- start
create or replace function app.start_subject_trial(
  p_user_id uuid, p_subject_key text, p_privacy_notice_version text,
  p_first_touch jsonb default null, p_last_touch jsonb default null
) returns jsonb language plpgsql security definer set search_path = pg_catalog as $$
declare
  v_now timestamptz := now();
  v_role text;
  v_email text;
  v_subject_id uuid;
  v_existing record;
  v_state jsonb;
begin
  if p_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  select p.role::text into v_role from app.profiles p where p.user_id = p_user_id;
  if v_role is distinct from 'student' and v_role is distinct from 'admin' then
    raise exception 'trial:forbidden' using errcode = '42501';
  end if;
  if not coalesce((select (config_value)::text = 'true' from app.config where config_key = 'cardless_trial_enabled'), false) then
    raise exception 'trial:disabled' using errcode = '42501';
  end if;

  perform pg_advisory_xact_lock(hashtextextended('trial_v2:' || p_user_id::text, 0));

  -- Subject: active, with a published pack version in the home release manifest.
  select s.id into v_subject_id
  from app.subjects s
  where app.normalize_student_subject_key(s.subject_key) = app.normalize_student_subject_key(p_subject_key)
    and s.status = 'active'
    and exists (
      select 1 from app.exam_packs p
      join app.exam_pack_versions v on v.exam_pack_id = p.id and v.status = 'published'
      join app.home_release_manifest m on m.exam_pack_version_id = v.id
      where p.subject_id = s.id)
  limit 1;
  if v_subject_id is null then
    raise exception 'trial:subject_unavailable' using errcode = '22023';
  end if;

  -- Replay: one trial per account, subject fixed at confirmation (D9).
  select e.subject_id into v_existing
  from app.subject_entitlements e
  where e.user_id = p_user_id and e.access_tier = 'trial' and e.source = 'trial_v2'
  order by e.created_at desc limit 1;
  if v_existing.subject_id is not null then
    v_state := app.trial_v2_state(p_user_id);
    if v_existing.subject_id <> v_subject_id then
      v_state := v_state || jsonb_build_object('replayed_other_subject', true);
    end if;
    return v_state;
  end if;

  -- Already a regular student of this subject: no trial needed, nothing consumed.
  if exists (
    select 1 from app.subject_entitlements e
    where e.user_id = p_user_id and e.subject_id = v_subject_id
      and e.access_tier in ('paid', 'beta') and e.status = 'active'
      and e.starts_at <= v_now and (e.ends_at is null or e.ends_at > v_now)) then
    return app.trial_v2_state(p_user_id)
      || jsonb_build_object('phase', 'superseded', 'can_start', false,
           'subject_key', (select subject_key from app.subjects where id = v_subject_id),
           'checkout_subject_key', null, 'has_regular_entitlement', true);
  end if;

  -- One trial per student email: trial_v1 (backfilled), card trials, trial_v2.
  select u.email into v_email from auth.users u where u.id = p_user_id;
  if v_email is null then
    raise exception 'trial:forbidden' using errcode = '42501';
  end if;
  if app.trial_email_consumed(v_email) then
    raise exception 'trial:already_used' using errcode = '42501';
  end if;

  insert into app.subject_entitlements
    (user_id, subject_id, access_tier, status, source, starts_at, ends_at, all_subjects)
  values (p_user_id, v_subject_id, 'trial', 'active', 'trial_v2', v_now, v_now + interval '7 days', false);

  insert into app.trial_consumed_emails (email_hash, source, consumed_at)
  values (app.trial_email_hash(v_email), 'trial_v2', v_now)
  on conflict do nothing;

  insert into app.acquisition_profiles
    (user_id, marketing_email_opt_in, privacy_notice_version, consented_at, first_touch, last_touch)
  values (p_user_id, false, p_privacy_notice_version, null,
          coalesce(p_first_touch, '{}'::jsonb), coalesce(p_last_touch, '{}'::jsonb))
  on conflict (user_id) do update set
    privacy_notice_version = excluded.privacy_notice_version,
    last_touch = excluded.last_touch,
    updated_at = now();

  insert into app.growth_event_outbox (event_name, user_id, source, dedupe_key, properties, occurred_at)
  values ('trial_started', p_user_id, 'web', 'trial_v2:' || p_user_id::text,
          jsonb_build_object('trial_source', 'trial_v2',
                             'subject_key', (select subject_key from app.subjects where id = v_subject_id),
                             'ends_at', v_now + interval '7 days'),
          v_now)
  on conflict (dedupe_key) do nothing;

  return app.trial_v2_state(p_user_id);
end;
$$;
revoke all on function app.start_subject_trial(uuid, text, text, jsonb, jsonb) from public, anon, authenticated;
grant execute on function app.start_subject_trial(uuid, text, text, jsonb, jsonb) to service_role;

create or replace function public.start_subject_trial(
  p_subject_key text, p_privacy_notice_version text,
  p_first_touch jsonb default null, p_last_touch jsonb default null
) returns jsonb language plpgsql security definer set search_path = pg_catalog as $$
begin
  if auth.uid() is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if nullif(btrim(coalesce(p_privacy_notice_version, '')), '') is null then
    raise exception 'trial:missing_privacy_notice_version' using errcode = '22023';
  end if;
  return app.start_subject_trial(auth.uid(), p_subject_key, p_privacy_notice_version, p_first_touch, p_last_touch);
end;
$$;
revoke all on function public.start_subject_trial(text, text, jsonb, jsonb) from public, anon;
grant execute on function public.start_subject_trial(text, text, jsonb, jsonb) to authenticated;

-- ------------------------------------------------- readback after day 7 (D2)
-- Own saved work stays readable once the trial has ended: get_question_experience
-- already consults this function (sample release). Pack access is unchanged.
create or replace function app.has_study_readback_access(_user_id uuid, _version_id uuid)
returns boolean language sql stable security definer set search_path = pg_catalog as $$
  select app.has_study_pack_access(_user_id, _version_id)
    or exists (
      select 1 from app.sample_grants g
      join app.exam_pack_versions v on v.id = _version_id
      join app.exam_packs p on p.id = v.exam_pack_id
      where g.user_id = _user_id and g.subject_id = p.subject_id)
    or exists (
      select 1 from app.subject_entitlements e
      join app.exam_pack_versions v on v.id = _version_id
      join app.exam_packs p on p.id = v.exam_pack_id
      where e.user_id = _user_id and e.subject_id = p.subject_id
        and e.access_tier = 'trial' and e.source = 'trial_v2');
$$;
revoke all on function app.has_study_readback_access(uuid, uuid) from public, anon, authenticated;
grant execute on function app.has_study_readback_access(uuid, uuid) to service_role;

-- -------------------------------------------- daily grading ceiling (D5)
-- Called from authorize_grading_access in place of its bare `return 'entitled'`.
-- A paid/beta row for the subject bypasses the ceiling; only a student whose
-- admitting row is trial_v2 is counted. Idempotent per request id.
create or replace function app.trial_grading_gate(
  p_user_id uuid, p_subject_id uuid, p_operation text, p_request_id text
) returns text language plpgsql security definer set search_path = pg_catalog as $$
declare
  v_cap integer := coalesce((select (config_value)::text::integer from app.config where config_key = 'trial_daily_grading_cap'), 40);
  v_count integer;
begin
  if p_operation not in ('grade_initial_attempt', 'grade_revision') then
    return 'entitled';
  end if;
  if exists (
    select 1 from app.subject_entitlements e
    where e.user_id = p_user_id and e.subject_id = p_subject_id
      and e.access_tier in ('paid', 'beta') and e.status = 'active'
      and e.starts_at <= now() and (e.ends_at is null or e.ends_at > now())) then
    return 'entitled';
  end if;
  if not exists (
    select 1 from app.subject_entitlements e
    where e.user_id = p_user_id and e.subject_id = p_subject_id
      and e.access_tier = 'trial' and e.source = 'trial_v2' and e.status = 'active'
      and e.starts_at <= now() and (e.ends_at is null or e.ends_at > now())) then
    return 'entitled';  -- trial_v1 / card trial rows: unchanged behaviour
  end if;
  if p_request_id is not null and exists (select 1 from app.trial_grading_log l where l.request_id = p_request_id) then
    return 'entitled';  -- replay of an authorized request
  end if;
  select count(*) into v_count from app.trial_grading_log l
  where l.user_id = p_user_id and l.created_at > now() - interval '24 hours';
  if v_count >= v_cap then
    raise exception 'grading_access:trial_daily_cap';
  end if;
  insert into app.trial_grading_log (request_id, user_id, subject_id, operation)
  values (coalesce(p_request_id, gen_random_uuid()::text), p_user_id, p_subject_id, p_operation)
  on conflict (request_id) do nothing;
  return 'entitled';
end;
$$;
revoke all on function app.trial_grading_gate(uuid, uuid, text, text) from public, anon, authenticated;
grant execute on function app.trial_grading_gate(uuid, uuid, text, text) to service_role;

-- Patch authorize_grading_access by anchor (its comments differ between
-- Development and Production since the sample release, so no md5 guard).
do $$
declare
  definition text := pg_get_functiondef('app.authorize_grading_access(uuid,uuid,text,text)'::regprocedure);
  anchor text := E'    return ''entitled'';';
  replacement text := E'    return app.trial_grading_gate(p_user_id, v_subject_id, p_operation, p_request_id);';
begin
  if strpos(definition, 'trial_grading_gate') > 0 then
    return;  -- already patched
  end if;
  if (length(definition) - length(replace(definition, anchor, ''))) / length(anchor) <> 1 then
    raise exception 'authorize_grading_access: expected exactly one bare return ''entitled'' anchor';
  end if;
  if strpos(definition, 'app.sample_grant_phase(v_grant)') = 0 then
    raise exception 'authorize_grading_access: sample branch missing; refusing to patch an unknown body';
  end if;
  execute replace(definition, anchor, replacement);
end $$;

commit;

-- ---------------------------------------------------------------- down
-- begin;
-- restore app.authorize_grading_access from the sample migration body (20261108201632);
-- drop function app.trial_grading_gate(uuid,uuid,text,text);
-- restore app.has_study_readback_access from 20261108201632 (two-clause body);
-- drop function public.start_subject_trial(text,text,jsonb,jsonb);
-- drop function app.start_subject_trial(uuid,text,text,jsonb,jsonb);
-- drop function public.get_trial_state();
-- drop function app.trial_v2_state(uuid);
-- drop table app.trial_grading_log;
-- delete from app.config where config_key in ('cardless_trial_enabled','trial_daily_grading_cap');
-- alter table app.trial_consumed_emails drop constraint trial_consumed_emails_source_check;
-- alter table app.trial_consumed_emails add constraint trial_consumed_emails_source_check check (source in ('trial_v1','stripe_trial_v1'));  -- only once no trial_v2 hashes remain
-- -- trial_v2 entitlement rows and consumed-email hashes are history; leave them.
-- commit;
