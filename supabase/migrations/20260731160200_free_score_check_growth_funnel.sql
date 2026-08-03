-- Activation-limited acquisition funnel: one FRQ score, one repair, one report.
-- The free offer is consumption-limited, not time-limited. Existing student
-- accounts are preserved as the initial beta cohort; new student accounts must
-- enter through this server-mediated flow or receive a paid/beta entitlement.

begin;

create table app.subject_entitlements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  subject_id uuid not null references app.subjects(id) on delete cascade,
  access_tier text not null,
  status text not null default 'active',
  source text not null,
  external_reference text,
  starts_at timestamptz not null default now(),
  ends_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint subject_entitlements_access_tier_check
    check (access_tier in ('beta', 'paid')),
  constraint subject_entitlements_status_check
    check (status in ('active', 'revoked', 'expired')),
  constraint subject_entitlements_dates_check
    check (ends_at is null or ends_at > starts_at),
  constraint subject_entitlements_unique
    unique (user_id, subject_id, access_tier, source)
);

create trigger subject_entitlements_set_updated_at
before update on app.subject_entitlements
for each row execute function app.set_updated_at();

alter table app.subject_entitlements enable row level security;

create policy "subject_entitlements_owner_select"
on app.subject_entitlements
for select to authenticated
using (user_id = auth.uid());

create policy "subject_entitlements_service_all"
on app.subject_entitlements
for all to service_role
using (true)
with check (true);

grant select on app.subject_entitlements to authenticated;
grant select, insert, update, delete on app.subject_entitlements to service_role;

-- Preserve current students as the explicitly named launch beta cohort. This
-- avoids breaking existing prototype users when direct attempt creation is
-- closed below. New users do not receive this grant automatically.
insert into app.subject_entitlements (
  user_id,
  subject_id,
  access_tier,
  source
)
select
  p.user_id,
  s.id,
  'beta',
  'migration_20260720_existing_student'
from app.profiles p
cross join app.subjects s
where p.role = 'student'
  and s.status = 'active'
on conflict do nothing;

create table app.acquisition_profiles (
  user_id uuid primary key references app.profiles(user_id) on delete cascade,
  marketing_email_opt_in boolean not null default false,
  privacy_notice_version text not null,
  consented_at timestamptz,
  first_touch jsonb not null default '{}'::jsonb,
  last_touch jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint acquisition_profiles_consent_check
    check (marketing_email_opt_in = false or consented_at is not null)
);

create trigger acquisition_profiles_set_updated_at
before update on app.acquisition_profiles
for each row execute function app.set_updated_at();

alter table app.acquisition_profiles enable row level security;

create policy "acquisition_profiles_owner_select"
on app.acquisition_profiles
for select to authenticated
using (user_id = auth.uid());

create policy "acquisition_profiles_service_all"
on app.acquisition_profiles
for all to service_role
using (true)
with check (true);

grant select on app.acquisition_profiles to authenticated;
grant select, insert, update, delete on app.acquisition_profiles to service_role;

create table app.free_score_checks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  subject_id uuid not null references app.subjects(id) on delete cascade,
  exam_pack_version_id uuid not null references app.exam_pack_versions(id),
  content_item_version_id uuid not null references app.content_item_versions(id),
  rubric_version_id uuid not null,
  learning_session_id uuid references app.learning_sessions(id) on delete set null,
  attempt_id uuid unique references app.attempts(id) on delete set null,
  repair_attempt_id uuid unique references app.attempts(id) on delete set null,
  initial_response_version_id uuid unique references app.response_versions(id) on delete set null,
  repair_response_version_id uuid unique references app.response_versions(id) on delete set null,
  initial_grading_request_id text,
  repair_grading_request_id text,
  initial_grading_result_id uuid unique references app.grading_results(id) on delete set null,
  repair_grading_result_id uuid unique references app.grading_results(id) on delete set null,
  state text not null default 'started',
  started_at timestamptz not null default now(),
  initial_graded_at timestamptz,
  repair_graded_at timestamptz,
  completed_at timestamptz,
  report_version text not null default 'v1',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint free_score_checks_user_subject_unique unique (user_id, subject_id),
  constraint free_score_checks_state_check check (
    state in ('started', 'initial_submitted', 'initial_graded', 'repair_submitted', 'completed')
  )
);

create trigger free_score_checks_set_updated_at
before update on app.free_score_checks
for each row execute function app.set_updated_at();

alter table app.free_score_checks enable row level security;

create policy "free_score_checks_owner_select"
on app.free_score_checks
for select to authenticated
using (user_id = auth.uid());

create policy "free_score_checks_service_all"
on app.free_score_checks
for all to service_role
using (true)
with check (true);

grant select on app.free_score_checks to authenticated;
grant select, insert, update, delete on app.free_score_checks to service_role;

create table app.growth_event_outbox (
  id uuid primary key default gen_random_uuid(),
  event_name text not null,
  user_id uuid references app.profiles(user_id) on delete set null,
  free_score_check_id uuid references app.free_score_checks(id) on delete set null,
  source text not null,
  dedupe_key text not null unique,
  properties jsonb not null default '{}'::jsonb,
  occurred_at timestamptz not null default now(),
  delivered_at timestamptz,
  delivery_attempts integer not null default 0,
  last_error text,
  created_at timestamptz not null default now(),
  constraint growth_event_outbox_event_name_check check (event_name in (
    'landing_view', 'demo_started', 'signup_started', 'trial_started',
    'first_response_graded', 'repair_completed', 'returned_day_2',
    'returned_day_7', 'checkout_started', 'purchase_completed',
    'referral_shared', 'referred_trial_started', 'referred_purchase'
  )),
  constraint growth_event_outbox_source_check
    check (source in ('web', 'free_score_check', 'stripe', 'referral', 'system')),
  constraint growth_event_outbox_delivery_attempts_check
    check (delivery_attempts >= 0)
);

alter table app.growth_event_outbox enable row level security;

create policy "growth_event_outbox_service_all"
on app.growth_event_outbox
for all to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.growth_event_outbox to service_role;

-- The selected launch FRQ is configured after an approved published item and
-- rubric version have been chosen. Keeping this disabled makes incomplete
-- production setup fail closed instead of exposing arbitrary content.
insert into app.config (config_key, config_value, is_public, description)
values (
  'growth.free_score_check.v1',
  jsonb_build_object(
    'enabled', false,
    'subject_key', 'biology',
    'content_item_version_id', null,
    'rubric_version_id', null,
    'available_minutes', 12
  ),
  false,
  'Server-only configuration for the activation-limited free score check.'
)
on conflict (config_key) do nothing;

-- Atomically creates or resumes the one free score check for a user/subject.
-- Callable only by service_role through the authenticated Edge Function.
create or replace function app.start_free_score_check(
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
  v_config jsonb;
  v_content_version_id uuid;
  v_rubric_version_id uuid;
  v_minutes integer;
  v_subject_id uuid;
  v_exam_pack_version_id uuid;
  v_check app.free_score_checks%rowtype;
  v_session_id uuid;
  v_attempt_id uuid;
  v_response_version_id uuid;
begin
  select config_value into v_config
  from app.config
  where config_key = 'growth.free_score_check.v1';

  if v_config is null or coalesce((v_config->>'enabled')::boolean, false) = false then
    raise exception 'free_score_check:not_available';
  end if;

  v_content_version_id := nullif(v_config->>'content_item_version_id', '')::uuid;
  v_rubric_version_id := nullif(v_config->>'rubric_version_id', '')::uuid;
  v_minutes := greatest(5, least(60, coalesce((v_config->>'available_minutes')::integer, 12)));

  if v_content_version_id is null or v_rubric_version_id is null then
    raise exception 'free_score_check:not_configured';
  end if;

  select s.id, ci.exam_pack_version_id
  into v_subject_id, v_exam_pack_version_id
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  where civ.id = v_content_version_id
    and civ.status = 'published'
    and ci.status = 'published'
    and ci.item_type = 'frq'
    and epv.status = 'published'
    and s.subject_key = v_config->>'subject_key';

  if v_subject_id is null then
    raise exception 'free_score_check:content_not_published';
  end if;

  perform pg_advisory_xact_lock(hashtextextended(p_user_id::text || ':' || v_subject_id::text, 0));

  insert into app.acquisition_profiles (
    user_id, marketing_email_opt_in, privacy_notice_version, consented_at,
    first_touch, last_touch
  ) values (
    p_user_id,
    p_marketing_email_opt_in,
    p_privacy_notice_version,
    case when p_marketing_email_opt_in then now() else null end,
    coalesce(p_first_touch, '{}'::jsonb),
    coalesce(p_last_touch, '{}'::jsonb)
  )
  on conflict (user_id) do update set
    marketing_email_opt_in = excluded.marketing_email_opt_in,
    privacy_notice_version = excluded.privacy_notice_version,
    consented_at = case
      when excluded.marketing_email_opt_in then coalesce(app.acquisition_profiles.consented_at, now())
      else null
    end,
    last_touch = excluded.last_touch;

  select * into v_check
  from app.free_score_checks
  where user_id = p_user_id and subject_id = v_subject_id
  for update;

  if found then
    return jsonb_build_object(
      'free_score_check_id', v_check.id,
      'state', v_check.state,
      'subject_id', v_check.subject_id,
      'exam_pack_version_id', v_check.exam_pack_version_id,
      'content_item_version_id', v_check.content_item_version_id,
      'rubric_version_id', v_check.rubric_version_id,
      'learning_session_id', v_check.learning_session_id,
      'attempt_id', v_check.attempt_id,
      'repair_attempt_id', v_check.repair_attempt_id,
      'initial_response_version_id', v_check.initial_response_version_id,
      'repair_response_version_id', v_check.repair_response_version_id
    );
  end if;

  insert into app.learning_sessions (
    user_id, exam_pack_version_id, entry_path, session_mode, available_minutes
  ) values (
    p_user_id, v_exam_pack_version_id, 'check_work', 'quick', v_minutes
  ) returning id into v_session_id;

  insert into app.attempts (
    user_id, learning_session_id, exam_pack_version_id,
    content_item_version_id, attempt_mode, assistance_state
  ) values (
    p_user_id, v_session_id, v_exam_pack_version_id,
    v_content_version_id, 'frq', 'independent'
  ) returning id into v_attempt_id;

  insert into app.response_versions (
    attempt_id, response_text, response_parts, version_number, created_by
  ) values (
    v_attempt_id, null, '{}'::jsonb, 1, p_user_id
  ) returning id into v_response_version_id;

  insert into app.free_score_checks (
    user_id, subject_id, exam_pack_version_id, content_item_version_id,
    rubric_version_id, learning_session_id, attempt_id,
    initial_response_version_id
  ) values (
    p_user_id, v_subject_id, v_exam_pack_version_id, v_content_version_id,
    v_rubric_version_id, v_session_id, v_attempt_id, v_response_version_id
  ) returning * into v_check;

  return jsonb_build_object(
    'free_score_check_id', v_check.id,
    'state', v_check.state,
    'subject_id', v_check.subject_id,
    'exam_pack_version_id', v_check.exam_pack_version_id,
    'content_item_version_id', v_check.content_item_version_id,
    'rubric_version_id', v_check.rubric_version_id,
    'learning_session_id', v_check.learning_session_id,
    'attempt_id', v_check.attempt_id,
    'repair_attempt_id', null,
    'initial_response_version_id', v_check.initial_response_version_id,
    'repair_response_version_id', null
  );
end;
$$;

revoke all on function app.start_free_score_check(uuid, jsonb, jsonb, boolean, text) from public, anon, authenticated;
grant execute on function app.start_free_score_check(uuid, jsonb, jsonb, boolean, text) to service_role;

-- Reserve grading slots idempotently. Paid/beta entitlements pass through;
-- free users get one initial grade and one revision on the mapped attempt.
create or replace function app.authorize_grading_access(
  p_user_id uuid,
  p_attempt_id uuid,
  p_operation text,
  p_request_id text
)
returns text
language plpgsql
security definer
set search_path = app, public
as $$
declare
  v_subject_id uuid;
  v_check app.free_score_checks%rowtype;
begin
  select ep.subject_id into v_subject_id
  from app.attempts a
  join app.exam_pack_versions epv on epv.id = a.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
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

  select * into v_check
  from app.free_score_checks
  where user_id = p_user_id
    and (attempt_id = p_attempt_id or repair_attempt_id = p_attempt_id)
  for update;

  if not found then
    raise exception 'grading_access:entitlement_required';
  end if;

  if p_operation = 'grade_initial_attempt' then
    if v_check.attempt_id <> p_attempt_id then
      raise exception 'grading_access:wrong_attempt_for_initial';
    end if;
    if v_check.initial_grading_request_id is null then
      update app.free_score_checks
      set initial_grading_request_id = p_request_id,
          state = 'initial_submitted'
      where id = v_check.id;
    elsif v_check.initial_grading_request_id <> p_request_id then
      raise exception 'grading_access:initial_limit_reached';
    end if;
    return 'free_initial';
  end if;

  if p_operation = 'select_repair' then
    if v_check.initial_grading_request_id is null then
      raise exception 'grading_access:initial_grade_required';
    end if;
    return 'free_repair_selection';
  end if;

  if p_operation = 'grade_revision' then
    if v_check.initial_grading_result_id is null then
      raise exception 'grading_access:initial_grade_required';
    end if;
    if v_check.repair_attempt_id is null or v_check.repair_attempt_id <> p_attempt_id then
      raise exception 'grading_access:wrong_attempt_for_repair';
    end if;
    if v_check.repair_grading_request_id is null then
      update app.free_score_checks
      set repair_grading_request_id = p_request_id,
          state = 'repair_submitted'
      where id = v_check.id;
    elsif v_check.repair_grading_request_id <> p_request_id then
      raise exception 'grading_access:repair_limit_reached';
    end if;
    return 'free_repair';
  end if;

  raise exception 'grading_access:operation_not_in_free_offer';
end;
$$;

revoke all on function app.authorize_grading_access(uuid, uuid, text, text) from public, anon, authenticated;
grant execute on function app.authorize_grading_access(uuid, uuid, text, text) to service_role;

-- Reconciles a completed grading row into the offer state and prepares the
-- separate coached repair attempt. A separate attempt is required because a
-- submitted/graded attempt is immutable in the canonical learner model.
create or replace function app.record_free_score_grade(
  p_user_id uuid,
  p_grading_result_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = app, public
as $$
declare
  v_result app.grading_results%rowtype;
  v_check app.free_score_checks%rowtype;
  v_repair_attempt_id uuid;
  v_repair_response_version_id uuid;
begin
  select * into v_result
  from app.grading_results
  where id = p_grading_result_id
    and status in ('graded', 'uncertain');

  if not found then
    raise exception 'free_score_check:grading_result_not_ready';
  end if;

  select * into v_check
  from app.free_score_checks
  where user_id = p_user_id
    and (attempt_id = v_result.attempt_id or repair_attempt_id = v_result.attempt_id)
  for update;

  if not found then
    raise exception 'free_score_check:not_found';
  end if;

  if v_result.operation = 'grade_initial_attempt'
     and v_result.attempt_id = v_check.attempt_id then
    if v_check.initial_grading_request_id is distinct from v_result.request_id then
      raise exception 'free_score_check:unreserved_initial_grade';
    end if;

    if v_check.repair_attempt_id is null then
      insert into app.attempts (
        user_id, learning_session_id, exam_pack_version_id,
        content_item_version_id, attempt_mode, assistance_state
      ) values (
        p_user_id, v_check.learning_session_id, v_check.exam_pack_version_id,
        v_check.content_item_version_id, 'frq', 'coached'
      ) returning id into v_repair_attempt_id;

      insert into app.response_versions (
        attempt_id, response_text, response_parts, version_number, created_by
      ) values (
        v_repair_attempt_id, null, '{}'::jsonb, 1, p_user_id
      ) returning id into v_repair_response_version_id;
    else
      v_repair_attempt_id := v_check.repair_attempt_id;
      v_repair_response_version_id := v_check.repair_response_version_id;
    end if;

    update app.free_score_checks set
      initial_grading_result_id = v_result.id,
      initial_graded_at = coalesce(initial_graded_at, now()),
      repair_attempt_id = v_repair_attempt_id,
      repair_response_version_id = v_repair_response_version_id,
      state = case when state = 'completed' then state else 'initial_graded' end
    where id = v_check.id;

    return jsonb_build_object(
      'free_score_check_id', v_check.id,
      'state', 'initial_graded',
      'repair_attempt_id', v_repair_attempt_id,
      'repair_response_version_id', v_repair_response_version_id
    );
  end if;

  if v_result.operation = 'grade_revision'
     and v_result.attempt_id = v_check.repair_attempt_id then
    if v_check.repair_grading_request_id is distinct from v_result.request_id then
      raise exception 'free_score_check:unreserved_repair_grade';
    end if;

    update app.free_score_checks set
      repair_grading_result_id = v_result.id,
      repair_graded_at = coalesce(repair_graded_at, now()),
      completed_at = coalesce(completed_at, now()),
      state = 'completed'
    where id = v_check.id;

    return jsonb_build_object(
      'free_score_check_id', v_check.id,
      'state', 'completed',
      'repair_attempt_id', v_check.repair_attempt_id,
      'repair_response_version_id', v_check.repair_response_version_id
    );
  end if;

  raise exception 'free_score_check:grading_result_mismatch';
end;
$$;

revoke all on function app.record_free_score_grade(uuid, uuid) from public, anon, authenticated;
grant execute on function app.record_free_score_grade(uuid, uuid) to service_role;

-- Close the browser-side attempt-creation path. Existing students keep access
-- via their beta grants; free-score attempts are created by service_role above.
drop policy if exists "attempts_owner_insert" on app.attempts;
create policy "attempts_entitled_owner_insert"
on app.attempts
for insert to authenticated
with check (
  user_id = auth.uid()
  and exists (
    select 1
    from app.exam_pack_versions epv
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.subject_entitlements se
      on se.subject_id = ep.subject_id
     and se.user_id = auth.uid()
    where epv.id = attempts.exam_pack_version_id
      and se.status = 'active'
      and se.starts_at <= now()
      and (se.ends_at is null or se.ends_at > now())
  )
);

create index subject_entitlements_active_lookup_idx
  on app.subject_entitlements (user_id, subject_id, status, ends_at);
create index free_score_checks_user_state_idx
  on app.free_score_checks (user_id, state);
create index growth_event_outbox_delivery_idx
  on app.growth_event_outbox (delivered_at, occurred_at)
  where delivered_at is null;

commit;
