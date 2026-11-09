-- Paywall sample access: align the sample with unit-gated serving (2026-11-09).
-- Spec: docs/product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md §5.5, §6.2.
-- Source: app-session findings in docs/qa/PAYWALL_APP_DEV_SMOKE_2026_11_09.md
-- "Round 3" (verified read-only on Production by the backend session).
--
-- 1. The app's normal practice entry calls student-session-items with
--    mode 'unit_gated', which reads app.student_course_positions and defaults
--    to unit 1 when the student has none. The claim never set a position, so a
--    grant in unit 2+ would have been served nothing (selector keeps
--    max_required_unit <= 1, the sample scope keeps unit N only), and subjects
--    whose units start above 1 (Physics 2: 9-11, Physics C E&M: 8-10) raise
--    unit_serving:unit_not_in_subject. claim_sample_try now upserts the course
--    position to the grant unit (source 'confirmed').
-- 2. The imported first-MCQ session carried practice_format 'mcq'; the
--    unit-gated selector returns zero rows for that format (Production,
--    Statistics: 0 with 'mcq', 50 with null). The imported session is now
--    format-less like the app's own MCQ sessions.
-- 3. sample_unit_availability counted published items with a topic
--    resolution; serving additionally needs a validated serving label whose
--    hash matches and the unit in app.home_release_manifest.allowed_unit_numbers.
--    Calculus AB Unit 1 counted 10 MCQs but serving delivers 4. Availability
--    now counts what public.select_student_practice_items delivers (called
--    with a nil user so nothing is excluded as answered) whenever the pack has
--    validated serving labels, and says which basis it used
--    (basis = 'serving' | 'content'). Development has no serving labels and
--    keeps the content basis, which the output makes visible rather than
--    silent. The anonymous first MCQ (select_sample_mcq) draws from the same
--    deliverable set on the serving basis.
--
-- Down: supabase/migrations/down/paywall_sample_access_down.sql drops every
-- sample function, so no separate down step is needed for this file.

begin;

-- ---------------------------------------------------------------------------
-- Serving-deliverable item versions for one unit of a pack, as the unit-gated
-- selector would serve them to a student positioned at that unit. Null when
-- the pack has no validated serving labels (content basis applies).
-- ---------------------------------------------------------------------------
create or replace function app.sample_pack_has_serving_labels(p_exam_pack_version_id uuid)
returns boolean language sql stable security definer set search_path = pg_catalog as $$
  select exists (
    select 1 from app.content_taxonomy_labels ctl
    join app.content_items ci on ci.id = ctl.content_item_id
    where ci.exam_pack_version_id = p_exam_pack_version_id
      and ctl.label_scope = 'serving' and ctl.label_status = 'validated' and ctl.superseded_by is null
  );
$$;

create or replace function app.sample_serving_deliverable(p_exam_pack_version_id uuid, p_unit_number integer, p_item_type text)
returns table (content_item_version_id uuid, content_item_id uuid)
language plpgsql stable security definer set search_path = pg_catalog as $$
declare v_allowed integer[];
begin
  select m.allowed_unit_numbers into v_allowed from app.home_release_manifest m
  where m.exam_pack_version_id = p_exam_pack_version_id;
  if v_allowed is null or not (p_unit_number = any (v_allowed)) then
    return;  -- unit not servable for this pack
  end if;
  return query
  select s.content_item_version_id, s.content_item_id
  from public.select_student_practice_items(
    p_exam_pack_version_id, p_unit_number, '00000000-0000-0000-0000-000000000000'::uuid,
    case when p_item_type = 'frq' then 'targeted_drill' else null end,
    p_item_type, null, 51, 0) s
  where exists (
    select 1 from app.content_item_topic_resolution r
    where r.content_item_version_id = s.content_item_version_id and r.unit_number = p_unit_number
  )
  and (p_item_type <> 'frq' or coalesce(s.response_policy, '') <> 'photo_required');
end;
$$;
revoke all on function app.sample_pack_has_serving_labels(uuid), app.sample_serving_deliverable(uuid, integer, text) from public, anon, authenticated;
grant execute on function app.sample_pack_has_serving_labels(uuid), app.sample_serving_deliverable(uuid, integer, text) to service_role;

-- ---------------------------------------------------------------------------
-- Availability: serving basis when labels exist, content basis otherwise.
-- ---------------------------------------------------------------------------
create or replace function app.sample_unit_availability(p_subject_key text)
returns jsonb language plpgsql stable security definer set search_path = pg_catalog as $$
declare
  v_subject uuid := app.sample_subject_id(p_subject_key);
  v_pack uuid := app.sample_pack_for_subject(app.sample_subject_id(p_subject_key));
  v_serving boolean := false;
  v_allowed integer[];
begin
  if v_pack is null then return '[]'::jsonb; end if;
  v_serving := app.sample_pack_has_serving_labels(v_pack);
  select m.allowed_unit_numbers into v_allowed from app.home_release_manifest m where m.exam_pack_version_id = v_pack;

  return (
    with items as (
      select r.unit_number, ci.id as content_item_id, civ.id as version_id, ci.item_type,
        (ci.item_type = 'mcq' and civ.stimulus_image_path is null
          and not exists (select 1 from app.open_hand_teaching_items t where t.content_item_id = ci.id and t.released_at is null)
          and (select count(*) from app.mcq_choices mc where mc.content_item_version_id = civ.id and mc.is_correct) = 1) as mcq_ok,
        (ci.item_type = 'frq' and ci.practice_format = 'targeted_drill' and coalesce(ci.response_policy, '') <> 'photo_required') as frq_ok
      from app.content_items ci
      join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
      join app.content_item_topic_resolution r on r.content_item_version_id = civ.id
      where ci.exam_pack_version_id = v_pack and ci.status = 'published'
        and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true
    ),
    units as (select distinct unit_number from items),
    counts as (
      select u.unit_number,
        case when v_serving then
          (select count(*) from app.sample_serving_deliverable(v_pack, u.unit_number, 'mcq') d
             join items i on i.version_id = d.content_item_version_id and i.mcq_ok)
        else (select count(*) from items i where i.unit_number = u.unit_number and i.mcq_ok) end as mcq_available,
        case when v_serving then
          (select count(*) from app.sample_serving_deliverable(v_pack, u.unit_number, 'frq') d
             join items i on i.version_id = d.content_item_version_id and i.frq_ok)
        else (select count(*) from items i where i.unit_number = u.unit_number and i.frq_ok) end as frq_available,
        (v_allowed is not null and u.unit_number = any (v_allowed)) as unit_servable
      from units u
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
      'basis', case when v_serving then 'serving' else 'content' end,
      'eligible', c.unit_servable and c.mcq_available >= 8 and c.frq_available >= 1) order by c.unit_number), '[]'::jsonb)
    from counts c
  );
end;
$$;

-- The anonymous first MCQ draws from the deliverable set on the serving basis.
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
    and (not app.sample_pack_has_serving_labels(p_exam_pack_version_id)
         or exists (select 1 from app.sample_serving_deliverable(p_exam_pack_version_id, p_unit_number, 'mcq') d
                    where d.content_item_version_id = civ.id))
  order by md5(civ.id::text || coalesce(p_seed, '')) limit 1;
$$;

-- ---------------------------------------------------------------------------
-- Claim: course position = grant unit; imported session is format-less.
-- (Body otherwise identical to 20261108201632.)
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
  -- Unit-gated serving reads the course position; the grant unit is the position.
  insert into app.student_course_positions as positions (user_id, exam_pack_version_id, unit_id, source)
  values (p_user_id, v_try.exam_pack_version_id, v_try.unit_number, 'confirmed')
  on conflict on constraint student_course_positions_pkey do update
  set unit_id = excluded.unit_id, source = excluded.source;
  insert into app.learning_sessions (user_id, exam_pack_version_id, entry_path, session_mode, practice_format,
    available_minutes, status, start_idempotency_key, start_request_fingerprint)
  values (p_user_id, v_try.exam_pack_version_id, 'sample', 'quick', null, 10, 'active',
    'sample-try:' || v_try.id::text, '10:sample')
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

commit;
