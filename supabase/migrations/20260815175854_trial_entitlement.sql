-- Add a time-boxed 'trial' access tier and the self-serve grant path for it.
--
-- app.authorize_grading_access already treats any subject_entitlements row
-- with status='active' and a still-open [starts_at, ends_at) window as fully
-- entitled (grading-access outage retro, 2026-08-14: the only reason
-- GRADING_ENTITLEMENTS_ENABLED stayed off was that no grant path existed for
-- a new, unprovisioned student). app.start_trial is that grant path: it
-- inserts one 'trial' row per active subject with ends_at = now() + 7 days,
-- and requires no changes to the grading gate itself.

alter table app.subject_entitlements
  drop constraint subject_entitlements_access_tier_check;

alter table app.subject_entitlements
  add constraint subject_entitlements_access_tier_check
  check (access_tier = any (array['beta', 'paid', 'trial']));

create or replace function app.start_trial(
  p_user_id uuid,
  p_first_touch jsonb,
  p_last_touch jsonb,
  p_marketing_email_opt_in boolean,
  p_privacy_notice_version text
)
returns jsonb
language plpgsql
security definer
set search_path = app, public
as $$
declare
  v_now timestamptz := now();
  v_ends_at timestamptz := now() + interval '7 days';
  v_already_started boolean;
  v_starts_at timestamptz;
  v_existing_ends_at timestamptz;
  v_subjects jsonb;
begin
  perform pg_advisory_xact_lock(hashtextextended('start_trial:' || p_user_id::text, 0));

  select exists (
    select 1 from app.subject_entitlements
    where user_id = p_user_id and access_tier = 'trial' and source = 'trial_v1'
  ) into v_already_started;

  insert into app.acquisition_profiles (
    user_id, marketing_email_opt_in, privacy_notice_version, consented_at,
    first_touch, last_touch
  ) values (
    p_user_id,
    p_marketing_email_opt_in,
    p_privacy_notice_version,
    case when p_marketing_email_opt_in then v_now else null end,
    coalesce(p_first_touch, '{}'::jsonb),
    coalesce(p_last_touch, '{}'::jsonb)
  )
  on conflict (user_id) do update set
    marketing_email_opt_in = excluded.marketing_email_opt_in,
    privacy_notice_version = excluded.privacy_notice_version,
    consented_at = case
      when excluded.marketing_email_opt_in then coalesce(app.acquisition_profiles.consented_at, v_now)
      else null
    end,
    last_touch = excluded.last_touch;

  if not v_already_started then
    insert into app.subject_entitlements (
      user_id, subject_id, access_tier, status, source, starts_at, ends_at
    )
    select p_user_id, s.id, 'trial', 'active', 'trial_v1', v_now, v_ends_at
    from app.subjects s
    where s.status = 'active'
    on conflict (user_id, subject_id, access_tier, source) do nothing;
  end if;

  select min(starts_at), max(ends_at) into v_starts_at, v_existing_ends_at
  from app.subject_entitlements
  where user_id = p_user_id and access_tier = 'trial' and source = 'trial_v1';

  select jsonb_agg(jsonb_build_object(
    'subject_id', se.subject_id,
    'subject_key', s.subject_key,
    'subject_name', s.display_name
  ) order by s.subject_key)
  into v_subjects
  from app.subject_entitlements se
  join app.subjects s on s.id = se.subject_id
  where se.user_id = p_user_id and se.access_tier = 'trial' and se.source = 'trial_v1';

  return jsonb_build_object(
    'already_started', v_already_started,
    'starts_at', v_starts_at,
    'ends_at', v_existing_ends_at,
    'subjects', coalesce(v_subjects, '[]'::jsonb)
  );
end;
$$;

revoke all on function app.start_trial(uuid, jsonb, jsonb, boolean, text) from public, anon, authenticated;
grant execute on function app.start_trial(uuid, jsonb, jsonb, boolean, text) to service_role;
