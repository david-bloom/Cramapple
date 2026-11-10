-- Cardless trial v2: Codex merge-gate QA fixes (PR #609 head 802f0dc2, 2026-11-09).
-- Authority: APPROVAL-0208 (Development only).
--
-- Finding 1 (blocker): start_subject_trial stored caller-supplied touch JSON and
--   any non-blank notice version as-is. Now: touches are allow-listed
--   (utm_source, utm_medium, utm_campaign, utm_content, utm_term, promo, rdt_cid;
--   string values only, trimmed to 200 chars; anything else dropped) and the
--   notice version must match YYYY-MM-DD (trial:invalid_privacy_notice_version).
-- Finding 2 (blocker): the daily grading ceiling counted then inserted with no
--   per-user lock. Now: pg_advisory_xact_lock on the user before the count.
-- Finding 3: an account holding any active paid/beta entitlement whose email once
--   consumed a trial read as blocked/already_used ("pay"). Now: such an account
--   reads phase 'superseded', has_regular_entitlement true, can_start false.
-- Finding 4: executable down scripts live in supabase/migrations/down/.
-- Prior bodies are snapshotted into app.config.cardless_trial_prior_definitions
-- so the down script restores them exactly (sample-release convention).

begin;

insert into app.config (config_key, config_value, is_public, description)
values ('cardless_trial_prior_definitions', jsonb_build_object(
  'trial_v2_state', pg_get_functiondef('app.trial_v2_state(uuid)'::regprocedure),
  'start_subject_trial', pg_get_functiondef('app.start_subject_trial(uuid,text,text,jsonb,jsonb)'::regprocedure),
  'trial_grading_gate', pg_get_functiondef('app.trial_grading_gate(uuid,uuid,text,text)'::regprocedure)
), false, 'Snapshot of the 20261109215704 bodies replaced by cardless_trial_v2_qa_fixes; read by its down script.')
on conflict (config_key) do nothing;

-- ------------------------------------------------ finding 1: touch allow-list
create or replace function app.sanitize_trial_touch(p_touch jsonb)
returns jsonb language sql immutable set search_path = pg_catalog as $$
  select coalesce((
    select jsonb_object_agg(k, to_jsonb(left(btrim(v), 200)))
    from jsonb_each_text(case when jsonb_typeof(p_touch) = 'object' then p_touch else '{}'::jsonb end) kv(k, v)
    where k in ('utm_source', 'utm_medium', 'utm_campaign', 'utm_content', 'utm_term', 'promo', 'rdt_cid')
      and jsonb_typeof(p_touch -> k) = 'string'
      and nullif(btrim(v), '') is not null
  ), '{}'::jsonb);
$$;
revoke all on function app.sanitize_trial_touch(jsonb) from public, anon, authenticated;
grant execute on function app.sanitize_trial_touch(jsonb) to service_role;

-- --------------------------------------- finding 3: account-wide regular access
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

  -- No trial row. An account that already holds regular access anywhere is a
  -- customer, not a prospect: never show it "used" or "pay" (QA finding 3).
  v_regular := exists (
    select 1 from app.subject_entitlements e
    where e.user_id = p_user_id and e.access_tier in ('paid', 'beta') and e.status = 'active'
      and e.starts_at <= v_now and (e.ends_at is null or e.ends_at > v_now));
  if v_regular then
    return jsonb_build_object(
      'phase', 'superseded', 'can_start', false, 'blocked_reason', null,
      'subject_key', null, 'subject_name', null, 'starts_at', null, 'ends_at', null,
      'days_remaining', null, 'seconds_remaining', null, 'ends_eastern', null,
      'has_regular_entitlement', true, 'checkout_subject_key', null,
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

-- ------------------------------ finding 1: validated inputs in the start call
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
  v_notice text := btrim(coalesce(p_privacy_notice_version, ''));
  v_first jsonb := app.sanitize_trial_touch(p_first_touch);
  v_last jsonb := app.sanitize_trial_touch(p_last_touch);
begin
  if p_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if v_notice !~ '^\d{4}-\d{2}-\d{2}$' then
    raise exception 'trial:invalid_privacy_notice_version' using errcode = '22023';
  end if;
  select p.role::text into v_role from app.profiles p where p.user_id = p_user_id;
  if v_role is distinct from 'student' and v_role is distinct from 'admin' then
    raise exception 'trial:forbidden' using errcode = '42501';
  end if;
  if not coalesce((select (config_value)::text = 'true' from app.config where config_key = 'cardless_trial_enabled'), false) then
    raise exception 'trial:disabled' using errcode = '42501';
  end if;

  perform pg_advisory_xact_lock(hashtextextended('trial_v2:' || p_user_id::text, 0));

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
  on conflict (email_hash) do nothing;
  if not found then
    raise exception 'trial:already_used' using errcode = '42501';
  end if;

  insert into app.acquisition_profiles
    (user_id, marketing_email_opt_in, privacy_notice_version, consented_at, first_touch, last_touch)
  values (p_user_id, false, v_notice, null, v_first, v_last)
  on conflict (user_id) do update set
    privacy_notice_version = excluded.privacy_notice_version,
    last_touch = excluded.last_touch,
    updated_at = now();

  insert into app.growth_event_outbox (event_name, user_id, source, dedupe_key, properties, occurred_at)
  values ('trial_started', p_user_id, 'web', 'trial_v2:' || p_user_id::text,
          jsonb_build_object('trial_source', 'trial_v2',
                             'subject_key', (select subject_key from app.subjects where id = v_subject_id),
                             'ends_at', v_now + interval '7 days') || v_first,
          v_now)
  on conflict (dedupe_key) do nothing;

  return app.trial_v2_state(p_user_id);
end;
$$;

-- --------------------------------------- finding 2: atomic daily ceiling
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
    return 'entitled';
  end if;
  -- Serialise this user's ceiling checks: concurrent requests at cap-1 would
  -- otherwise all read the same count (QA finding 2).
  perform pg_advisory_xact_lock(hashtextextended('trial_grading:' || p_user_id::text, 0));
  if p_request_id is not null and exists (select 1 from app.trial_grading_log l where l.request_id = p_request_id) then
    return 'entitled';
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

commit;
