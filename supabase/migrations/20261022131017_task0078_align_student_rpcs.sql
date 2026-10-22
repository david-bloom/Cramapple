-- TASK-0078 ruling 6 (David, 2026-10-22): align Development to Production.
-- Bucket: the five student-facing public RPCs whose live text differed between the projects.
-- Source of truth: Production's live definitions (pg_get_functiondef, 2026-10-22). Four of the five
-- differ from Development only in whitespace; get_student_progress_dashboard differs in substance:
-- Production (and main's 20260821080000_progress_dashboard_v1.sql) null out pointsEarned and add
-- pointsWithheld for uncertain grades in recentActivity; Development never received that text.
-- CREATE OR REPLACE keeps ownership and grants. Re-running is a no-op.

CREATE OR REPLACE FUNCTION public.complete_learning_session(_session_id uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_status text;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select ls.status
    into v_status
  from app.learning_sessions ls
  where ls.id = _session_id
    and ls.user_id = v_user_id
  for update;

  if not found then
    raise exception 'learning_session_not_found' using errcode = 'P0002';
  end if;

  if v_status = 'active' then
    update app.learning_sessions
    set status = 'completed',
        ended_at = coalesce(ended_at, pg_catalog.now())
    where id = _session_id
      and user_id = v_user_id;
  elsif v_status <> 'completed' then
    raise exception 'learning_session_not_completable'
      using errcode = '55000';
  end if;

  return _session_id;
end;
$function$;

CREATE OR REPLACE FUNCTION public.get_open_hand_item(p_content_item_version_id uuid, p_learning_session_id uuid DEFAULT NULL::uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_role text;
  v_is_staff boolean;
  v_content_item_id uuid;
  v_item_type text;
  v_subject_id uuid;
  v_canonical_answer_1 text;
  v_canonical_answer_2 text;
  v_entitled boolean;
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if p_content_item_version_id is null then
    raise exception 'open_hand:missing_identity' using errcode = '22023';
  end if;

  select p.role into v_role from app.profiles p where p.user_id = v_user_id;
  v_is_staff := coalesce(v_role, '') = any (array['admin', 'content_author', 'tutor', 'reader', 'validator']);

  select civ.content_item_id, ci.item_type, s.id, civ.canonical_answer_1, civ.canonical_answer_2
  into v_content_item_id, v_item_type, v_subject_id, v_canonical_answer_1, v_canonical_answer_2
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  where civ.id = p_content_item_version_id
    and civ.status = 'published'
    and ci.status = 'published'
    and epv.status = 'published'
    and epv.retired_at is null
    and s.status = 'active';

  if v_item_type is null then
    raise exception 'open_hand:item_not_accessible' using errcode = '42501';
  end if;

  if not v_is_staff then
    select exists (
      select 1 from app.subject_entitlements se
      where se.user_id = v_user_id
        and se.status = 'active'
        and (se.all_subjects is true or se.subject_id = v_subject_id)
        and (se.starts_at is null or se.starts_at <= now())
        and (se.ends_at is null or se.ends_at > now())
    ) into v_entitled;
    if not v_entitled then
      raise exception 'open_hand:entitlement_required' using errcode = '42501';
    end if;
  end if;

  if p_learning_session_id is not null then
    if not exists (
      select 1 from app.learning_sessions ls
      where ls.id = p_learning_session_id and ls.user_id = v_user_id
    ) then
      raise exception 'open_hand:session_not_accessible' using errcode = '42501';
    end if;
  end if;

  if not v_is_staff then
    insert into app.open_hand_scoring_exclusions (user_id, content_item_version_id, content_item_id, learning_session_id)
    values (v_user_id, p_content_item_version_id, v_content_item_id, p_learning_session_id)
    on conflict (user_id, content_item_version_id) do nothing;
  end if;

  select jsonb_build_object(
    'content_item_version_id', p_content_item_version_id,
    'content_item_id', v_content_item_id,
    'item_type', v_item_type,
    'scoring_eligible', false,
    'exclusion_recorded', not v_is_staff,
    'canonical_answers', jsonb_strip_nulls(jsonb_build_object('answer_1', v_canonical_answer_1, 'answer_2', v_canonical_answer_2)),
    'mcq_choices', coalesce((
      select jsonb_agg(jsonb_build_object(
        'choice_key', mc.choice_key, 'choice_text', mc.choice_text, 'is_correct', mc.is_correct,
        'rationale', mc.rationale, 'minimum_fix', mc.rationale) order by mc.choice_key)
      from app.mcq_choices mc where mc.content_item_version_id = p_content_item_version_id
    ), '[]'::jsonb),
    'frq_criteria', coalesce((
      select jsonb_agg(jsonb_build_object(
        'criterion_key', fc.criterion_key, 'learner_facing_text', fc.learner_facing_text,
        'points_possible', fc.points_possible, 'evidence_requirements', fc.evidence_requirements,
        'accepted_variants', fc.accepted_variants, 'minimum_fix', fc.minimum_fix) order by fc.criterion_key)
      from app.frq_criteria fc where fc.content_item_version_id = p_content_item_version_id
    ), '[]'::jsonb),
    'credited_response_spans', coalesce((
      select jsonb_agg(jsonb_build_object(
        'answer_field', cas.answer_field, 'span_ordinal', cas.span_ordinal,
        'span_text', cas.span_text, 'criterion_keys', cas.criterion_keys) order by cas.answer_field, cas.span_ordinal)
      from app.canonical_answer_spans cas where cas.content_item_version_id = p_content_item_version_id
    ), '[]'::jsonb)
  ) into v_result;

  return v_result;
end;
$function$;

CREATE OR REPLACE FUNCTION public.get_student_progress_dashboard(_subject_key text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  c_version constant text := 'progress_dashboard_v1_2026_08_21';
  c_min_frq_items constant integer := 3;
  c_min_frq_points constant integer := 10;
  v_user_id uuid := auth.uid();
  v_requested text := nullif(app.normalize_student_subject_key(_subject_key), '');
  v_version_id uuid; v_subject_id uuid; v_subject_key text; v_display_name text;
  v_school_year text; v_exam_date date; v_taxonomy_version uuid;
  v_mcq_attempted integer := 0; v_mcq_correct integer := 0; v_mcq_uncertain integer := 0;
  v_frq_items integer := 0; v_frq_earned integer := 0; v_frq_possible integer := 0;
  v_frq_uncertain integer := 0;
  v_excluded_non_independent integer := 0; v_excluded_other_format integer := 0;
  v_sessions integer := 0; v_minutes integer := 0; v_sessions_no_duration integer := 0;
  v_est integer; v_confidence text;
  v_gaps jsonb := '[]'::jsonb; v_units jsonb := '[]'::jsonb; v_recent jsonb := '[]'::jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if v_requested is not null and v_requested !~ '^[a-z0-9][a-z0-9_]*$' then
    raise exception 'progress:invalid_subject_key' using errcode = '22023';
  end if;

  if v_requested is null then
    select p.active_exam_pack_version_id into v_version_id
      from app.profiles p where p.user_id = v_user_id;
  else
    select epv.id into v_version_id
      from app.exam_pack_versions epv
      join app.exam_packs ep on ep.id = epv.exam_pack_id
      join app.subjects s on s.id = ep.subject_id
     where app.normalize_student_subject_key(s.subject_key) = v_requested
       and epv.status = 'published'
     order by epv.school_year desc, epv.released_at desc nulls last, epv.created_at desc
     limit 1;
  end if;

  if v_version_id is null then
    return jsonb_build_object(
      'version', c_version, 'generatedAt', now(), 'state', 'no_subject',
      'subject', null, 'summary', null, 'units', '[]'::jsonb, 'recentActivity', '[]'::jsonb,
      'notes', jsonb_build_array('No active subject is selected for this student.'));
  end if;

  select s.id, app.normalize_student_subject_key(s.subject_key), s.display_name,
         epv.school_year, epv.official_exam_date
    into v_subject_id, v_subject_key, v_display_name, v_school_year, v_exam_date
    from app.exam_pack_versions epv
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.subjects s on s.id = ep.subject_id
   where epv.id = v_version_id;

  if v_subject_id is null then
    raise exception 'progress:unresolvable_subject' using errcode = '22023';
  end if;

  if not exists (
    select 1 from app.subject_entitlements e
     where e.user_id = v_user_id and e.status = 'active'
       and (e.all_subjects or e.subject_id = v_subject_id)
       and (e.starts_at is null or e.starts_at <= now())
       and (e.ends_at is null or e.ends_at > now())
  ) then
    raise exception 'progress:not_entitled' using errcode = '42501';
  end if;

  with latest_grade as (
    select distinct on (g.attempt_id)
           g.attempt_id, g.status, g.points_earned, g.points_available
      from app.grading_results g
      join app.attempts a2 on a2.id = g.attempt_id
     where a2.user_id = v_user_id and a2.exam_pack_version_id = v_version_id
     order by g.attempt_id, g.created_at desc
  ),
  scoped as (
    select a.id as attempt_id, civ.content_item_id, a.attempt_mode,
           coalesce(a.assistance_state,'independent') as assistance_state,
           lg.status, lg.points_earned, lg.points_available,
           coalesce(a.submitted_at, a.created_at) as attempted_at
      from app.attempts a
      join latest_grade lg on lg.attempt_id = a.id
      join app.content_item_versions civ on civ.id = a.content_item_version_id
  ),
  first_per_item as (
    select distinct on (s.content_item_id) s.*
      from scoped s
     where s.assistance_state = 'independent' and s.attempt_mode in ('mcq','frq')
     order by s.content_item_id, s.attempted_at asc
  ),
  excluded as (
    select count(distinct s.content_item_id) filter (where s.assistance_state <> 'independent') as non_independent_items,
           count(distinct s.content_item_id) filter (where s.attempt_mode not in ('mcq','frq')) as other_format_items
      from scoped s
  )
  select
    count(*) filter (where attempt_mode='mcq' and status='graded' and coalesce(points_available,0)>0),
    count(*) filter (where attempt_mode='mcq' and status='graded' and coalesce(points_available,0)>0
                       and coalesce(points_earned,0) >= points_available),
    count(*) filter (where attempt_mode='mcq' and status='uncertain'),
    count(*) filter (where attempt_mode='frq' and status='graded'),
    coalesce(sum(points_earned) filter (where attempt_mode='frq' and status='graded'),0),
    coalesce(sum(points_available) filter (where attempt_mode='frq' and status='graded'),0),
    count(*) filter (where attempt_mode='frq' and status='uncertain'),
    max(x.non_independent_items), max(x.other_format_items)
    into v_mcq_attempted, v_mcq_correct, v_mcq_uncertain,
         v_frq_items, v_frq_earned, v_frq_possible, v_frq_uncertain,
         v_excluded_non_independent, v_excluded_other_format
    from first_per_item right join excluded x on true;

  select count(*),
         coalesce(round(sum(extract(epoch from (ls.ended_at - ls.started_at))/60.0)
           filter (where ls.ended_at is not null and ls.started_at is not null))::integer, 0),
         count(*) filter (where ls.ended_at is null or ls.started_at is null)
    into v_sessions, v_minutes, v_sessions_no_duration
    from app.learning_sessions ls
   where ls.user_id = v_user_id and ls.exam_pack_version_id = v_version_id;

  if v_frq_items >= c_min_frq_items and v_frq_possible >= c_min_frq_points then
    v_est := app.progress_estimated_ap_score(v_frq_earned, v_frq_possible);
    v_confidence := 'low';
  else
    v_est := null; v_confidence := 'none';
  end if;

  if v_frq_items < c_min_frq_items then
    v_gaps := v_gaps || to_jsonb(format(
      'Based on %s independently graded free-response item(s); %s are needed before an estimate is shown.',
      v_frq_items, c_min_frq_items));
  end if;
  if v_frq_possible < c_min_frq_points then
    v_gaps := v_gaps || to_jsonb(format(
      'Only %s free-response point(s) attempted; %s are needed before an estimate is shown.',
      v_frq_possible, c_min_frq_points));
  end if;
  if v_frq_uncertain > 0 or v_mcq_uncertain > 0 then
    v_gaps := v_gaps || to_jsonb(format(
      '%s grade(s) were withheld as uncertain and are excluded from these figures.',
      v_frq_uncertain + v_mcq_uncertain));
  end if;
  if v_est is not null then
    v_gaps := v_gaps || to_jsonb('This estimate has not been calibrated against official College Board score data.'::text);
  end if;
  if coalesce(v_excluded_non_independent,0) > 0 then
    v_gaps := v_gaps || to_jsonb(format(
      '%s item(s) were worked with help or in exam-practice mode and are excluded from independent evidence.',
      v_excluded_non_independent));
  end if;
  if coalesce(v_excluded_other_format,0) > 0 then
    v_gaps := v_gaps || to_jsonb(format(
      '%s item(s) in a format v1 does not score are excluded from these figures.',
      v_excluded_other_format));
  end if;
  v_gaps := v_gaps || to_jsonb('Unit-level attribution is unavailable, so this figure is not weighted by exam unit.'::text);

  select tsv.taxonomy_source_version into v_taxonomy_version
    from app.taxonomy_source_versions tsv
   where tsv.subject_key = v_subject_key
     and tsv.taxonomy_confidence = 'verified'
     and exists (select 1 from app.taxonomy_units tu where tu.taxonomy_source_version = tsv.taxonomy_source_version)
   order by tsv.school_year desc, tsv.verified_at desc nulls last, tsv.created_at desc
   limit 1;

  if v_taxonomy_version is not null then
    select coalesce(jsonb_agg(jsonb_build_object(
             'unitNumber', tu.unit_number,
             'unitTitle', tu.unit_title,
             'isExamAssessed', tu.is_exam_assessed,
             'status', 'attribution_unavailable',
             'statusLabel', app.progress_status_label('attribution_unavailable')
           ) order by tu.unit_number), '[]'::jsonb)
      into v_units
      from app.taxonomy_units tu
     where tu.taxonomy_source_version = v_taxonomy_version;
  end if;

  with latest_grade as (
    select distinct on (g.attempt_id)
           g.attempt_id, g.status, g.points_earned, g.points_available, g.confidence
      from app.grading_results g
      join app.attempts a2 on a2.id = g.attempt_id
     where a2.user_id = v_user_id and a2.exam_pack_version_id = v_version_id
     order by g.attempt_id, g.created_at desc
  ),
  recent as (
    select ci.content_key, a.attempt_mode, lg.status, lg.points_earned,
           lg.points_available, lg.confidence,
           coalesce(a.submitted_at, a.created_at) as attempted_at
      from app.attempts a
      join latest_grade lg on lg.attempt_id = a.id
      join app.content_item_versions civ on civ.id = a.content_item_version_id
      join app.content_items ci on ci.id = civ.content_item_id
     order by coalesce(a.submitted_at, a.created_at) desc
     limit 10
  )
  select coalesce(jsonb_agg(jsonb_build_object(
           'contentKey', r.content_key, 'format', r.attempt_mode,
           'gradeState', r.status, 'gradeConfidence', r.confidence,
           'pointsEarned', case when r.status = 'uncertain' then null else r.points_earned end, 'pointsAvailable', r.points_available, 'pointsWithheld', (r.status = 'uncertain'),
           'attemptedAt', r.attempted_at) order by r.attempted_at desc), '[]'::jsonb)
    into v_recent from recent r;

  return jsonb_build_object(
    'version', c_version, 'generatedAt', now(), 'state', 'ready',
    'subject', jsonb_build_object(
      'subjectKey', v_subject_key,
      'displayName', coalesce(v_display_name, v_subject_key),
      'examPackVersionId', v_version_id,
      'schoolYear', v_school_year,
      'officialExamDate', v_exam_date),
    'summary', jsonb_build_object(
      'mcq', jsonb_build_object(
        'correct', v_mcq_correct, 'attempted', v_mcq_attempted,
        'percentCorrect', case when v_mcq_attempted > 0
          then round((v_mcq_correct::numeric / v_mcq_attempted)*100)::integer else null end,
        'uncertainExcluded', v_mcq_uncertain,
        'status', app.progress_status_token(v_mcq_attempted, v_mcq_correct, v_mcq_attempted),
        'statusLabel', app.progress_status_label(app.progress_status_token(v_mcq_attempted, v_mcq_correct, v_mcq_attempted))),
      'frq', jsonb_build_object(
        'gradedItems', v_frq_items, 'earnedPoints', v_frq_earned,
        'possiblePoints', v_frq_possible, 'uncertainExcluded', v_frq_uncertain,
        'estimatedScore1To5', v_est, 'confidence', v_confidence, 'isOfficial', false,
        'qualifier', 'Cramapple estimate, not an official College Board score.',
        'evidenceGaps', v_gaps,
        'nextAction', case when v_est is null
          then 'Complete a few more free-response items to unlock an estimate.'
          else 'Work the criteria you are losing points on to move this estimate.' end,
        'status', app.progress_status_token(v_frq_items, v_frq_earned, v_frq_possible),
        'statusLabel', app.progress_status_label(app.progress_status_token(v_frq_items, v_frq_earned, v_frq_possible))),
      'activity', jsonb_build_object(
        'sessions', v_sessions, 'actualMinutes', v_minutes,
        'sessionsWithoutDuration', v_sessions_no_duration,
        'unitsWithEvidence', null, 'unitAttributionAvailable', false,
        'excludedNonIndependentItems', coalesce(v_excluded_non_independent,0),
        'excludedOtherFormatItems', coalesce(v_excluded_other_format,0))),
    'units', v_units,
    'recentActivity', v_recent,
    'notes', jsonb_build_array(
      'Unit-level evidence attribution is not available in v1. Units are listed from the verified course taxonomy with no per-unit evidence.',
      'Topic-level progress is not available in v1.'));
end;
$function$;

CREATE OR REPLACE FUNCTION public.select_student_practice_items(_exam_pack_version_id uuid, _current_unit integer, _user_id uuid, _practice_format text DEFAULT NULL::text, _item_type text DEFAULT NULL::text, _topic_code text DEFAULT NULL::text, _limit integer DEFAULT 20, _offset integer DEFAULT 0)
 RETURNS TABLE(content_item_version_id uuid, content_item_id uuid, content_key text, title text, item_type text, stem text, stimulus text, stimulus_image_path text, prompt_json jsonb, frq_form text, practice_format text, response_policy text, required_units integer[], max_required_unit integer, label_version integer, published_at timestamp with time zone, topic_match boolean)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_allowed_units integer[];
begin
  if _exam_pack_version_id is null then
    raise exception 'unit_serving:exam_pack_required' using errcode = '22023';
  end if;
  if _current_unit is null then
    raise exception 'unit_serving:current_unit_required' using errcode = '22023';
  end if;
  if _user_id is null then
    raise exception 'unit_serving:user_required' using errcode = '22023';
  end if;

  select m.allowed_unit_numbers
    into v_allowed_units
  from app.home_release_manifest m
  where m.exam_pack_version_id = _exam_pack_version_id;

  if v_allowed_units is null then
    raise exception 'unit_serving:subject_taxonomy_unavailable' using errcode = '22023';
  end if;
  if not (_current_unit = any(v_allowed_units)) then
    raise exception 'unit_serving:unit_not_in_subject' using errcode = '22023';
  end if;

  return query
  with latest as (
    select distinct on (civ.content_item_id)
      civ.*
    from app.content_item_versions civ
    order by civ.content_item_id, civ.version_num desc
  ), active_labels as (
    select distinct on (ctl.content_item_id)
      ctl.*
    from app.content_taxonomy_labels ctl
    where ctl.label_scope = 'serving'
      and ctl.label_status = 'validated'
      and ctl.superseded_by is null
    order by ctl.content_item_id, ctl.label_version desc
  ), answered as (
    select distinct av.content_item_id
    from app.attempts a
    join app.content_item_versions av on av.id = a.content_item_version_id
    where a.user_id = _user_id
      and a.status in ('submitted', 'graded')
  ), revealed as (
    select distinct e.content_item_id
    from app.open_hand_scoring_exclusions e
    where e.user_id = _user_id
  )
  select
    civ.id,
    ci.id,
    ci.content_key,
    ci.title,
    ci.item_type,
    civ.stem,
    civ.stimulus,
    civ.stimulus_image_path,
    civ.prompt_json,
    ci.frq_form,
    ci.practice_format,
    ci.response_policy,
    label.required_units,
    label.max_required_unit,
    label.label_version,
    civ.published_at,
    (_topic_code is not null and exists (
      select 1 from app.content_item_topic_resolution r
      where r.content_item_version_id = civ.id
        and r.is_primary
        and r.topic_code = _topic_code
    )) as topic_match
  from app.content_items ci
  join latest civ
    on civ.content_item_id = ci.id
  join active_labels label
    on label.content_item_id = ci.id
  where ci.exam_pack_version_id = _exam_pack_version_id
    and ci.status = 'published'
    and civ.status = 'published'
    and label.max_required_unit <= _current_unit
    and label.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)
    and (_practice_format is null or ci.practice_format = _practice_format)
    and (_item_type is null or ci.item_type = _item_type)
    and (
      ci.item_type in ('mcq', 'quantitative')
      or (ci.item_type = 'frq' and ci.frq_form in ('short', 'long'))
    )
    -- Hand-drawn items are served here on purpose (2026-10-09): the Practice
    -- FRQ screen renders a capture control for response_policy =
    -- 'photo_required'. The TASK-0038 exclusion stays on the legacy /session
    -- selectors only.
    and not app.content_item_is_teaching(ci.id)
    and not exists (select 1 from answered an where an.content_item_id = ci.id)
    and not exists (select 1 from revealed rv where rv.content_item_id = ci.id)
  order by 17 desc, label.max_required_unit desc, civ.published_at nulls last, ci.content_key
  offset greatest(0, coalesce(_offset, 0))
  limit greatest(1, least(coalesce(_limit, 20), 51));
end;
$function$;

CREATE OR REPLACE FUNCTION public.start_home_learning_session_for_user(_user_id uuid, _minutes integer, _idempotency_key text)
 RETURNS TABLE(learning_session_id uuid, exam_pack_version_id uuid, practice_format text, reused_active boolean, idempotent_replay boolean)
 LANGUAGE sql
 SET search_path TO 'pg_catalog'
AS $function$
  select *
  from app.start_home_learning_session_for_user(
    _user_id,
    _minutes,
    _idempotency_key
  );
$function$;
