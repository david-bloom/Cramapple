-- Isolated local database only. Minimal tables model the live access columns.
-- Apply with psql -v ON_ERROR_STOP=1; no real accounts or production writes.
create role anon;
create role authenticated;
create role service_role;
create schema auth;
create schema app;
create function auth.uid() returns uuid language sql stable as $$
  select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid;
$$;
create table app.subjects (id uuid primary key, subject_key text, status text);
create table app.profiles (user_id uuid primary key, role text, active_exam_pack_version_id uuid, onboarding_completed_at timestamptz);
create table app.exam_packs (id uuid primary key, subject_id uuid);
create table app.exam_pack_versions (id uuid primary key, exam_pack_id uuid);
create table app.subject_entitlements (user_id uuid, subject_id uuid, status text, starts_at timestamptz, ends_at timestamptz);
create table app.learning_sessions (id uuid primary key, user_id uuid, exam_pack_version_id uuid, status text);
create table app.learning_session_items (learning_session_id uuid);
create table app.attempts (id uuid);
create table app.grading_results (id uuid);
create function app.exam_pack_version_is_selectable(uuid) returns boolean language sql as $$ select true; $$;
create function app.normalize_student_subject_key(text) returns text language sql as $$ select replace($1, '-', '_'); $$;
create function public.get_topic_point_guides(text, integer, text) returns jsonb language sql as $$ select jsonb_build_object('subject', $1); $$;
CREATE OR REPLACE FUNCTION public.get_question_experience(p_learning_session_id uuid, p_ordinal integer DEFAULT NULL::integer)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_session app.learning_sessions%rowtype;
  v_total integer;
  v_resume_ordinal integer;
  v_ordinal integer;
  v_civ_id uuid;
  v_item_id uuid;
  v_item_type text;
  v_attempt app.attempts%rowtype;
  v_submitted boolean := false;
  v_grading app.grading_results%rowtype;
  v_has_grading boolean := false;
  v_prev_grading app.grading_results%rowtype;
  v_has_prev boolean := false;
  v_subject_key text;
  v_topic_code text;
  v_unit_number integer;
  v_guides jsonb;
  v_mcq_feedback jsonb;
  v_resume_action text;
  v_resume_attempt app.attempts%rowtype;
  v_raw_parts jsonb;
  v_question_parts jsonb := '[]'::jsonb;
  v_question_parts_complete boolean := true;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select * into v_session from app.learning_sessions
  where id = p_learning_session_id and user_id = v_user_id;
  if v_session.id is null then
    raise exception 'question_experience:session_not_found' using errcode = '42501';
  end if;

  select count(*) into v_total
  from app.learning_session_items where learning_session_id = v_session.id;

  -- Resume position: the first item without a submitted attempt in this session; when every item is
  -- submitted, the last item.
  select min(lsi.ordinal) into v_resume_ordinal
  from app.learning_session_items lsi
  where lsi.learning_session_id = v_session.id
    and not exists (
      select 1 from app.attempts a
      where a.learning_session_id = v_session.id
        and a.user_id = v_user_id
        and a.content_item_version_id = lsi.content_item_version_id
        and a.submitted_at is not null
    );
  if v_resume_ordinal is null and v_total > 0 then
    v_resume_ordinal := v_total;
  end if;

  if p_ordinal is not null and (p_ordinal < 1 or p_ordinal > v_total) then
    raise exception 'question_experience:invalid_ordinal' using errcode = '22023';
  end if;
  v_ordinal := coalesce(p_ordinal, v_resume_ordinal);

  -- Resume action, always computed for the resume position (independent of p_ordinal).
  if v_session.status <> 'active' then
    v_resume_action := 'session_ended';
  elsif v_total = 0 then
    v_resume_action := 'no_items';
  else
    select a.* into v_resume_attempt
    from app.learning_session_items lsi
    join app.attempts a
      on a.learning_session_id = v_session.id
     and a.user_id = v_user_id
     and a.content_item_version_id = lsi.content_item_version_id
    where lsi.learning_session_id = v_session.id and lsi.ordinal = v_resume_ordinal
    order by a.started_at desc, a.created_at desc, a.id desc
    limit 1;
    if v_resume_attempt.id is null then
      v_resume_action := case when v_resume_ordinal = 1 then 'start_item' else 'next_item' end;
    elsif v_resume_attempt.submitted_at is null then
      v_resume_action := 'continue_draft';
    else
      v_resume_action := 'review_feedback';  -- every item submitted; the last one is shown
    end if;
  end if;

  if v_ordinal is null then
    return jsonb_build_object(
      'session', jsonb_build_object(
        'learningSessionId', v_session.id, 'status', v_session.status, 'entryPath', v_session.entry_path,
        'sessionMode', v_session.session_mode, 'startedAt', v_session.started_at, 'endedAt', v_session.ended_at),
      'counter', null,
      'servedItems', coalesce((
      select jsonb_agg(jsonb_build_object(
        'ordinal', lsi.ordinal,
        'contentItemVersionId', lsi.content_item_version_id,
        'itemType', ci.item_type,
        'submitted', exists (
          select 1 from app.attempts a
          where a.learning_session_id = v_session.id and a.user_id = v_user_id
            and a.content_item_version_id = lsi.content_item_version_id and a.submitted_at is not null))
        order by lsi.ordinal)
      from app.learning_session_items lsi
      join app.content_item_versions civ on civ.id = lsi.content_item_version_id
      join app.content_items ci on ci.id = civ.content_item_id
      where lsi.learning_session_id = v_session.id), '[]'::jsonb),
      'resume', jsonb_build_object('action', v_resume_action, 'ordinal', null,
        'contentItemVersionId', null, 'attemptId', null),
      'item', null, 'mcqChoices', '[]'::jsonb, 'criteria', '[]'::jsonb, 'attempt', null, 'grading', null,
      'mcqFeedback', null, 'priorAttempts', '[]'::jsonb, 'pointsChange', null,
      'comparisonAnswers', '[]'::jsonb, 'topic', null, 'reference', '{}'::jsonb, 'memoryHooks', '[]'::jsonb, 'figures', '[]'::jsonb);
  end if;

  select lsi.content_item_version_id, civ.content_item_id, ci.item_type
    into v_civ_id, v_item_id, v_item_type
  from app.learning_session_items lsi
  join app.content_item_versions civ on civ.id = lsi.content_item_version_id
  join app.content_items ci on ci.id = civ.content_item_id
  where lsi.learning_session_id = v_session.id and lsi.ordinal = v_ordinal;

  -- This session's latest attempt on this item.
  select a.* into v_attempt from app.attempts a
  where a.learning_session_id = v_session.id and a.user_id = v_user_id and a.content_item_version_id = v_civ_id
  order by a.started_at desc, a.created_at desc, a.id desc limit 1;
  v_submitted := v_attempt.id is not null and v_attempt.submitted_at is not null;

  if v_submitted then
    select gr.* into v_grading from app.grading_results gr
    where gr.attempt_id = v_attempt.id and gr.status in ('graded', 'uncertain')
    order by gr.created_at desc limit 1;
    v_has_grading := v_grading.id is not null;
  end if;

  -- Previous graded attempt on the same question (any version, any session) for how-the-points-went.
  if v_has_grading then
    select gr.* into v_prev_grading
    from app.attempts a
    join app.content_item_versions civ on civ.id = a.content_item_version_id
    join lateral (
      select g.* from app.grading_results g
      where g.attempt_id = a.id and g.status in ('graded', 'uncertain')
      order by g.created_at desc limit 1
    ) gr on true
    where a.user_id = v_user_id and civ.content_item_id = v_item_id
      and a.id <> v_attempt.id and a.submitted_at is not null
      and a.submitted_at < v_attempt.submitted_at
    order by a.submitted_at desc limit 1;
    v_has_prev := v_prev_grading.id is not null;
  end if;

  if v_item_type = 'mcq' and v_has_grading then
    begin
      v_mcq_feedback := public.get_graded_mcq_feedback(v_attempt.id);
    exception when others then
      v_mcq_feedback := null;
    end;
  end if;

  -- Topic for reference: the version's primary, unsuperseded cell; unit from that taxonomy version.
  -- Joins are on UUIDs; subject_key comes from app.subjects through the session's exam pack.
  select s.subject_key into v_subject_key
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  where epv.id = v_session.exam_pack_version_id;

  select cc.topic_code, tt.unit_number into v_topic_code, v_unit_number
  from app.content_item_cells cc
  left join app.taxonomy_topics tt
    on tt.taxonomy_source_version = cc.taxonomy_source_version and tt.topic_code = cc.topic_code
  where cc.content_item_version_id = v_civ_id and cc.superseded_by is null
  order by cc.is_primary desc nulls last, cc.created_at
  limit 1;

  if v_subject_key is not null and v_topic_code is not null then
    v_guides := public.get_topic_point_guides(v_subject_key, v_unit_number, v_topic_code);
  end if;

  -- Authored instructions only. Never derive a question from answer-bearing criteria.
  select case
    when civ.prompt_json ? 'parts' and civ.prompt_json->'parts' <> 'null'::jsonb
      then civ.prompt_json->'parts'
    when civ.item_package_payload ? 'parts' then civ.item_package_payload->'parts'
    else '[]'::jsonb end into v_raw_parts
  from app.content_item_versions civ where civ.id = v_civ_id;
  if jsonb_typeof(v_raw_parts) <> 'array' then
    v_question_parts_complete := false;
  else
    select coalesce(jsonb_agg(jsonb_build_object(
      'key', coalesce(nullif(p->>'part_key',''),nullif(p->>'part_id',''), 'part-' || ord::text),
      'prompt', (case when jsonb_typeof(p->'prompt')='string' and nullif(btrim(p->>'prompt'),'') is not null then p->>'prompt' when jsonb_typeof(p->'prompt_text')='string' then p->>'prompt_text' end)) order by ord),'[]'::jsonb),
      count(*) = jsonb_array_length(v_raw_parts)
      and count(*) = count(distinct coalesce(nullif(p->>'part_key',''),nullif(p->>'part_id',''), 'part-' || ord::text))
    into v_question_parts, v_question_parts_complete
    from jsonb_array_elements(v_raw_parts) with ordinality as x(p,ord)
    where jsonb_typeof(p) = 'object'
      and (jsonb_typeof(p->'prompt')='string' or jsonb_typeof(p->'prompt_text')='string')
      and nullif(btrim((case when jsonb_typeof(p->'prompt')='string' and nullif(btrim(p->>'prompt'),'') is not null then p->>'prompt' when jsonb_typeof(p->'prompt_text')='string' then p->>'prompt_text' end)),'') is not null;
    if not v_question_parts_complete then v_question_parts := '[]'::jsonb; end if;
  end if;

  return jsonb_build_object(
    'session', jsonb_build_object(
      'learningSessionId', v_session.id, 'status', v_session.status, 'entryPath', v_session.entry_path,
      'sessionMode', v_session.session_mode, 'startedAt', v_session.started_at, 'endedAt', v_session.ended_at),
    'counter', jsonb_build_object('index', v_ordinal, 'total', v_total),
    -- Every served item in order with whether this session submitted it, so the client can rebuild
    -- its skip count from this one call instead of one read per earlier ordinal.
    'servedItems', coalesce((
      select jsonb_agg(jsonb_build_object(
        'ordinal', lsi.ordinal,
        'contentItemVersionId', lsi.content_item_version_id,
        'itemType', ci.item_type,
        'submitted', exists (
          select 1 from app.attempts a
          where a.learning_session_id = v_session.id and a.user_id = v_user_id
            and a.content_item_version_id = lsi.content_item_version_id and a.submitted_at is not null))
        order by lsi.ordinal)
      from app.learning_session_items lsi
      join app.content_item_versions civ on civ.id = lsi.content_item_version_id
      join app.content_items ci on ci.id = civ.content_item_id
      where lsi.learning_session_id = v_session.id), '[]'::jsonb),
    'resume', jsonb_build_object(
      'action', v_resume_action,
      'ordinal', v_resume_ordinal,
      'contentItemVersionId', (select content_item_version_id from app.learning_session_items
                               where learning_session_id = v_session.id and ordinal = v_resume_ordinal),
      'attemptId', v_resume_attempt.id),
    'item', (
      select jsonb_build_object(
        'contentItemVersionId', civ.id, 'contentItemId', ci.id, 'itemType', ci.item_type,
        'title', ci.title, 'stem', civ.stem, 'stimulus', civ.stimulus,
        'hasStimulusImage', civ.stimulus_image_path is not null,
        'questionParts', v_question_parts,
        'questionPartsComplete', v_question_parts_complete,
        -- Only these six exact reviewed descriptions are certified complete for text grounding.
        -- Approval/alt text alone never certifies arbitrary future visual questions.
        'questionVisual', (select jsonb_build_object('alt',m.alt_text,
          'description',m.long_description,'completeReviewedDescription',true)
          from app.content_asset_metadata m
          join (values
              ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb'::uuid,'questions/apcalcab-frq-u13-002/v2/bca6ca68b5511794b7d0ade184214609a8e95a34b97498a9cb5e160d7a5b3508.png','4610eef236837435767a569dc94ab778'),
              ('a59eb1ed-b96e-4d89-94ee-a4a32b309744'::uuid,'questions/apcalcab-frq-u13g-1-3/v2/75702de6d4bdfbfe04aaf0e102df9f824e0d6cbd9950b2296b40e93e034ab377.png','0d52fb66029e22279aa99ee024a15d87'),
              ('f1548706-2043-4f7b-9941-c1c6e2724174'::uuid,'questions/apcalcab-oht-1.3/v2/ac7fd89a433124ad8e567adcac94e49a17c95e739f151e724c9a5248d34a7478.png','3bd46ee2e5eea7834e8fcee8ee8357ff'),
              ('b7b068cb-0610-4da7-8565-4290621d402f'::uuid,'questions/apchem-oht-3.8/v2/66fbf35180965b903ef15df42a6c6dd13b01b18da4ecf6961a6bbd513f9b2967.png','cc04fcd3bd7d659987c38cc540fa60d5'),
              ('f492bfbf-5434-434f-a4d8-50b058477139'::uuid,'questions/apcalcab-mcq-060/v2/9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png','94f2dce11fbf112cf3cfd830ac924f1f'),
              ('959822a0-5cd4-4e1f-813e-58241c6c66cf'::uuid,'questions/apchem-frq-u13g-3-8/v2/86914cd4eb4e2a171de085a3a7ddb0d1b60f0e35fb7d56edad82059e9fc2ebad.png','68be64447d95a07ee426fd40797e1752')
          ) reviewed(version_id,path,description_md5)
            on reviewed.version_id = civ.id and reviewed.path = civ.stimulus_image_path
          where m.content_item_version_id=civ.id and m.storage_bucket='content-assets'
            and m.storage_path=civ.stimulus_image_path and m.approved_at is not null
            and md5(m.long_description)=reviewed.description_md5
            and nullif(btrim(m.alt_text),'') is not null
            and not exists (select 1 from app.content_visual_requirements vr
              where vr.content_item_version_id=civ.id and vr.image_needed='yes'
                and coalesce(vr.image_approval,'') not in ('approved','approved_with_edits'))
          limit 1))
      from app.content_item_versions civ join app.content_items ci on ci.id = civ.content_item_id
      where civ.id = v_civ_id),
    -- Choices without answer truth; truth arrives in mcqFeedback after grading.
    'mcqChoices', coalesce((
      select jsonb_agg(jsonb_build_object('choiceKey', mc.choice_key, 'choiceText', mc.choice_text)
                       order by mc.choice_key)
      from app.mcq_choices mc where mc.content_item_version_id = v_civ_id), '[]'::jsonb),
    -- Rubric rows; minimumFix only after submission.
    'criteria', coalesce((
      select jsonb_agg(jsonb_build_object(
        'criterionKey', f.criterion_key, 'learnerFacingText', f.learner_facing_text,
        'pointsPossible', f.points_possible, 'judgementKind', f.judgement_kind,
        'minimumFix', case when v_submitted then f.minimum_fix end)
        order by f.created_at, f.criterion_key)
      from app.frq_criteria f where f.content_item_version_id = v_civ_id), '[]'::jsonb),
    'attempt', case when v_attempt.id is null then null else jsonb_build_object(
      'attemptId', v_attempt.id, 'status', v_attempt.status, 'startedAt', v_attempt.started_at,
      'submittedAt', v_attempt.submitted_at, 'gradedAt', v_attempt.graded_at,
      'scorePoints', coalesce(v_attempt.score_points, v_grading.points_earned),
      'scorePossible', coalesce(v_attempt.score_possible, v_grading.points_available),
      'resultState', v_attempt.result_state, 'resultSummary', v_attempt.result_summary) end,
    'grading', case when not v_has_grading then null else jsonb_build_object(
      'gradingResultId', v_grading.id, 'status', v_grading.status,
      'pointsEarned', v_grading.points_earned, 'pointsAvailable', v_grading.points_available,
      'confidence', v_grading.confidence, 'feedbackPreview', v_grading.feedback_preview,
      'actionHint', v_grading.action_hint, 'repairHint', v_grading.repair_hint,
      'criterionResults', coalesce((
        select jsonb_agg(jsonb_build_object(
          'criterionKey', e->>'criterion_key', 'status', e->>'status',
          'pointsAwarded', (e->>'points_awarded')::integer, 'evidenceQuote', e->>'evidence_quote',
          'decisionExplanation', e->>'decision_explanation', 'minimumFix', e->>'minimum_fix')
          order by ord)
        from jsonb_array_elements(case when jsonb_typeof(v_grading.criterion_results) = 'array'
                                       then v_grading.criterion_results else '[]'::jsonb end)
             with ordinality as x(e, ord)), '[]'::jsonb)) end,
    'mcqFeedback', v_mcq_feedback,
    -- Every submitted attempt on this question (any version, any session), oldest first.
    'priorAttempts', coalesce((
      select jsonb_agg(jsonb_build_object(
        'attemptId', a.id, 'contentItemVersionId', a.content_item_version_id,
        'learningSessionId', a.learning_session_id, 'submittedAt', a.submitted_at,
        'scorePoints', coalesce(a.score_points, g.points_earned),
        'scorePossible', coalesce(a.score_possible, g.points_available),
        'resultState', coalesce(a.result_state, g.status),
        'isCurrent', a.id = v_attempt.id)
        order by a.submitted_at, a.id)
      from app.attempts a
      join app.content_item_versions civ on civ.id = a.content_item_version_id
      left join lateral (
        select gr.points_earned, gr.points_available, gr.status from app.grading_results gr
        where gr.attempt_id = a.id and gr.status in ('graded', 'uncertain')
        order by gr.created_at desc limit 1
      ) g on true
      where a.user_id = v_user_id and civ.content_item_id = v_item_id and a.submitted_at is not null), '[]'::jsonb),
    -- How the points went: mechanical per-criterion comparison of the previous graded attempt and this one.
    'pointsChange', case when not (v_has_grading and v_has_prev) then null else jsonb_build_object(
      'previousAttemptId', v_prev_grading.attempt_id,
      'currentAttemptId', v_grading.attempt_id,
      'previousPoints', v_prev_grading.points_earned,
      'currentPoints', v_grading.points_earned,
      'pointsAvailable', v_grading.points_available,
      'criteria', coalesce((
        with prev as (
          select e->>'criterion_key' k, e->>'status' s
          from jsonb_array_elements(case when jsonb_typeof(v_prev_grading.criterion_results) = 'array'
                                         then v_prev_grading.criterion_results else '[]'::jsonb end) e
        ), cur as (
          select e->>'criterion_key' k, e->>'status' s, ord
          from jsonb_array_elements(case when jsonb_typeof(v_grading.criterion_results) = 'array'
                                         then v_grading.criterion_results else '[]'::jsonb end)
               with ordinality as x(e, ord)
        ), keys as (
          select coalesce(cur.k, prev.k) k, prev.s ps, cur.s cs, coalesce(cur.ord, 1000000) ord
          from cur full join prev on prev.k = cur.k
        )
        select jsonb_agg(jsonb_build_object(
          'criterionKey', k, 'previousStatus', ps, 'currentStatus', cs,
          'change', case
            when ps is null then 'not_previously_assessed'
            when cs is null then 'not_currently_assessed'
            when ps = 'unable_to_determine' or cs = 'unable_to_determine' then 'undetermined'
            when ps <> 'earned' and cs = 'earned' then 'gained'
            when ps = 'earned' and cs <> 'earned' then 'lost'
            else 'unchanged' end)
          order by ord, k)
        from keys), '[]'::jsonb)) end,
    -- Always the three variants in a fixed order. available = a published row exists (tab enabled);
    -- content only after this attempt is submitted.
    'comparisonAnswers', (
      select jsonb_agg(jsonb_build_object(
        'variant', v.variant,
        'available', ca.comparison_answer_id is not null,
        'locked', not v_submitted,
        'responseText', case when v_submitted then ca.response_text end,
        'explanation', case when v_submitted then ca.explanation end)
        order by v.ord)
      from (values ('full_credit', 1), ('common_mistake', 2), ('vague', 3)) v(variant, ord)
      left join app.content_item_comparison_answers ca
        on ca.content_item_version_id = v_civ_id and ca.variant = v.variant and ca.is_published),
    'topic', case when v_topic_code is null then null else jsonb_build_object(
      'subjectKey', v_subject_key, 'unitNumber', v_unit_number, 'topicCode', v_topic_code) end,
    -- get_topic_point_guides' reference[] for this topic, grouped by kind (same entry objects).
    'reference', coalesce((
      select jsonb_object_agg(kind, entries)
      from (
        select r->>'kind' kind, jsonb_agg(r order by ord) entries
        from jsonb_array_elements(coalesce(v_guides->'reference', '[]'::jsonb)) with ordinality as x(r, ord)
        group by r->>'kind'
      ) g), '{}'::jsonb),
    'memoryHooks', coalesce(v_guides->'memoryHooks', '[]'::jsonb),
    'figures', coalesce(v_guides->'figures', '[]'::jsonb)
  );
end;
$function$
;

-- A session can predate entitlement enforcement; it must be blocked on readback.
insert into app.subjects values ('10000000-0000-4000-8000-000000000001', 'ap_calculus_ab', 'active'), ('10000000-0000-4000-8000-000000000002', 'ap_calculus_bc', 'active');
insert into app.profiles values ('20000000-0000-4000-8000-000000000001','student',null,null), ('20000000-0000-4000-8000-000000000002','student',null,null), ('20000000-0000-4000-8000-000000000003','validator',null,null);
insert into app.exam_packs values ('30000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001'), ('30000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000002');
insert into app.exam_pack_versions values ('40000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000001'), ('40000000-0000-4000-8000-000000000002','30000000-0000-4000-8000-000000000002');
insert into app.learning_sessions values ('50000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000001','40000000-0000-4000-8000-000000000001','active');
\ir ../migrations/20261031143302_subject_access_before_study.sql
begin;
select set_config('request.jwt.claim.sub', '20000000-0000-4000-8000-000000000001', true);
do $test$
declare
  student uuid := '20000000-0000-4000-8000-000000000001';
  ab uuid := '10000000-0000-4000-8000-000000000001';
  pack uuid := '40000000-0000-4000-8000-000000000001';
begin
  assert not public.has_study_pack_access(pack), 'missing grant denied';
  assert public.get_study_subject_keys() = '[]'::jsonb, 'empty subject picker';
  begin
    perform public.set_active_exam_pack_version(pack);
    raise exception 'selection should deny';
  exception when insufficient_privilege then assert sqlerrm = 'subject_access:entitlement_required';
  end;
  begin
    perform public.complete_onboarding(pack);
    raise exception 'onboarding should deny';
  exception when insufficient_privilege then assert sqlerrm = 'subject_access:entitlement_required';
  end;
  begin
    perform public.get_question_experience('50000000-0000-4000-8000-000000000001', null);
    raise exception 'old session should deny';
  exception when insufficient_privilege then assert sqlerrm = 'subject_access:entitlement_required';
  end;
  begin
    insert into app.learning_sessions values (gen_random_uuid(),student,pack,'active');
    raise exception 'session insert should deny';
  exception when insufficient_privilege then assert sqlerrm = 'subject_access:entitlement_required';
  end;
  insert into app.subject_entitlements values (student,ab,'active',now() - interval '1 day',null);
  assert public.has_study_pack_access(pack), 'active perpetual grant allowed';
  assert public.get_study_subject_keys() = '["ap_calculus_ab"]'::jsonb;
  assert public.set_active_exam_pack_version(pack) = pack;
  perform public.complete_onboarding(pack);
  insert into app.learning_sessions values (gen_random_uuid(),student,pack,'active');
  assert public.get_study_topic_point_guides('ap-calculus-ab',1,'1.1')->>'subject' = 'ap-calculus-ab';
  begin
    perform public.get_study_topic_point_guides('ap_calculus_bc',1,'1.1');
    raise exception 'AB entitlement must not unlock BC';
  exception when insufficient_privilege then null;
  end;
  update app.subject_entitlements set ends_at = now();
  assert not public.has_study_pack_access(pack), 'end is exclusive';
  update app.subject_entitlements set ends_at = now() + interval '1 day';
  assert public.has_study_pack_access(pack), 'current dated grant allowed';
  update app.subject_entitlements set starts_at = now() + interval '1 hour';
  assert not public.has_study_pack_access(pack), 'future denied';
  update app.subject_entitlements set starts_at = now(), status = 'revoked';
  assert not public.has_study_pack_access(pack), 'revoked denied';
  -- Saving and leaving are still permitted after revocation.
  update app.learning_sessions set status = status;
  update app.learning_sessions set status = 'archived';
  begin
    update app.learning_sessions set status = 'active';
    raise exception 'reactivation should deny';
  exception when insufficient_privilege then null;
  end;
  perform public.set_active_exam_pack_version(null);
  perform set_config('request.jwt.claim.sub', '20000000-0000-4000-8000-000000000002', true);
  assert public.get_study_subject_keys() = '[]'::jsonb, 'other account isolated';
  perform set_config('request.jwt.claim.sub', '20000000-0000-4000-8000-000000000003', true);
  assert public.has_study_pack_access(pack), 'staff QA preserved';
  perform set_config('request.jwt.claim.sub', '', true);
  assert not public.has_study_pack_access(pack), 'no user denied';
  assert not has_function_privilege('authenticated', 'app.has_study_pack_access(uuid,uuid)', 'execute'), 'no arbitrary user check';
  assert not has_function_privilege('anon', 'public.get_study_subject_keys()', 'execute'), 'anon has no subject access RPC';
end;
$test$;
rollback;
