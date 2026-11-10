-- Cardless trial v2: same-email race in app.start_subject_trial (Vercel review on
-- PR #609, 2026-11-10). Authority: APPROVAL-0208 (Development only).
--
-- Defect: the eligibility check (app.trial_email_consumed) and the hash insert
-- were separated by the grant insert, and the hash insert used ON CONFLICT DO
-- NOTHING. A concurrent writer of the same hash (card trial, or a second account
-- with the same email) therefore let the cardless trial commit a second grant.
-- Reproduced on Development with two connections: 2 trial_v2 rows, 1 hash.
-- Fix: insert the hash before the grant and raise trial:already_used when the
-- insert is lost. Prior body snapshotted for the down script.
begin;

insert into app.config (config_key, config_value, is_public, description)
values ('cardless_trial_email_race_prior_definitions', jsonb_build_object(
  'start_subject_trial', pg_get_functiondef('app.start_subject_trial(uuid,text,text,jsonb,jsonb)'::regprocedure)
), false, 'Snapshot of the 20261110011605 start_subject_trial body replaced by cardless_trial_v2_email_race; read by its down script.')
on conflict (config_key) do nothing;

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

  -- Consume the email FIRST and treat a lost conflict as already used: a card
  -- trial (app.trial_activate) or another account with the same email may have
  -- inserted the hash between the check above and here (Vercel review on PR #609,
  -- reproduced on Development 2026-11-10: two grants on one email). The primary
  -- key on email_hash makes the loser wait for the winner's commit and then fail.
  insert into app.trial_consumed_emails (email_hash, source, consumed_at)
  values (app.trial_email_hash(v_email), 'trial_v2', v_now)
  on conflict (email_hash) do nothing;
  if not found then
    raise exception 'trial:already_used' using errcode = '42501';
  end if;

  insert into app.subject_entitlements
    (user_id, subject_id, access_tier, status, source, starts_at, ends_at, all_subjects)
  values (p_user_id, v_subject_id, 'trial', 'active', 'trial_v2', v_now, v_now + interval '7 days', false);

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

commit;
