-- Revised question experience: session position, comparison answers, one read-model RPC.
-- Development first; Production is a Hard Gate.
--
-- What this adds, and why each piece is new rather than reused:
--   1. app.learning_session_items — the ordered set of items a session delivered. learning_sessions has no
--      item list; session_target_items is tied to issued Home targets (TTL, consume and eligibility
--      triggers) and has 0 rows for practice sessions; student-session-items selects items dynamically and
--      keeps its queue cursor client-side, so the set cannot be re-derived after the fact (answered items
--      drop out of later selections). The set is stored once, server-side, by the delivery path.
--   2. app.content_item_comparison_answers — Full credit / Common mistake / Vague example answers hung off a
--      question version, each with its own published flag. Nothing stores these today.
--   3. public.get_question_experience — one round trip for the question page. It reads existing tables only
--      (attempts, grading_results.criterion_results, frq_criteria, mcq_choices) and reuses
--      public.get_topic_point_guides for reference content; app.attempt_criterion_results (IDG-8, dead) is
--      never read.
--
-- Not added: a resume table/column (derived from learning_sessions.status + learning_session_items +
-- attempts), stored "how the points went" (derived from criterion_results at read time), any diagram
-- rendering (TASK-0006).

begin;

-- ---------------------------------------------------------------------------
-- 1. app.learning_session_items
-- ---------------------------------------------------------------------------

create table app.learning_session_items (
  learning_session_item_id uuid primary key default gen_random_uuid(),
  learning_session_id uuid not null references app.learning_sessions(id) on delete cascade,
  ordinal integer not null,
  content_item_version_id uuid not null references app.content_item_versions(id) on delete restrict,
  added_at timestamptz not null default now(),
  constraint learning_session_items_ordinal_check check (ordinal >= 1),
  constraint learning_session_items_unique_ordinal unique (learning_session_id, ordinal),
  constraint learning_session_items_unique_item unique (learning_session_id, content_item_version_id)
);

comment on table app.learning_session_items is
  'Ordered set of question versions a learning session delivered (ordinal 1..n). Written only by the service role (app.append_learning_session_items, called from the item-delivery path). Gives the question page its N/M counter and resume position.';

create index learning_session_items_version_idx
  on app.learning_session_items (content_item_version_id);

alter table app.learning_session_items enable row level security;
alter table app.learning_session_items force row level security;
revoke all on app.learning_session_items from public, anon, authenticated;
grant select, insert, update, delete on app.learning_session_items to service_role;
grant select on app.learning_session_items to authenticated;

create policy learning_session_items_select_own
on app.learning_session_items
for select
to authenticated
using (
  exists (
    select 1 from app.learning_sessions ls
    where ls.id = learning_session_items.learning_session_id
      and ls.user_id = auth.uid()
  )
);

-- Append delivered items in the order given, skipping any already in the session. Idempotent: a re-sent
-- page does not renumber or duplicate. Returns the session's total after the append.
create or replace function app.append_learning_session_items(
  p_learning_session_id uuid,
  p_content_item_version_ids uuid[]
)
returns integer
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_next integer;
  v_id uuid;
  v_total integer;
begin
  if not exists (select 1 from app.learning_sessions where id = p_learning_session_id) then
    raise exception 'session_items:session_not_found' using errcode = '22023';
  end if;

  -- Serialize appends per session so concurrent pages cannot collide on an ordinal.
  perform 1 from app.learning_sessions where id = p_learning_session_id for update;

  select coalesce(max(ordinal), 0) + 1 into v_next
  from app.learning_session_items where learning_session_id = p_learning_session_id;

  foreach v_id in array coalesce(p_content_item_version_ids, '{}'::uuid[]) loop
    if v_id is not null and not exists (
      select 1 from app.learning_session_items
      where learning_session_id = p_learning_session_id and content_item_version_id = v_id
    ) then
      insert into app.learning_session_items (learning_session_id, ordinal, content_item_version_id)
      values (p_learning_session_id, v_next, v_id);
      v_next := v_next + 1;
    end if;
  end loop;

  select count(*) into v_total
  from app.learning_session_items where learning_session_id = p_learning_session_id;
  return v_total;
end;
$$;

revoke all on function app.append_learning_session_items(uuid, uuid[]) from public, anon, authenticated;
grant execute on function app.append_learning_session_items(uuid, uuid[]) to service_role;

-- ---------------------------------------------------------------------------
-- 2. app.content_item_comparison_answers
-- ---------------------------------------------------------------------------

create table app.content_item_comparison_answers (
  comparison_answer_id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null references app.content_item_versions(id) on delete restrict,
  variant text not null,
  response_text text not null,
  explanation text,
  is_published boolean not null default false,
  published_at timestamptz,
  source_note text not null default 'cramapple-authored',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint content_item_comparison_answers_variant_check
    check (variant in ('full_credit', 'common_mistake', 'vague')),
  constraint content_item_comparison_answers_response_check check (length(btrim(response_text)) >= 1),
  constraint content_item_comparison_answers_published_at_check
    check (not is_published or published_at is not null),
  constraint content_item_comparison_answers_unique_variant unique (content_item_version_id, variant)
);

comment on table app.content_item_comparison_answers is
  'Example answers shown beside the student''s own answer: full_credit, common_mistake, vague. One row per (question version, variant); each variant publishes independently. These are answer truth: students read them only through public.get_question_experience, and only after their attempt is submitted.';

create trigger content_item_comparison_answers_set_updated_at
  before update on app.content_item_comparison_answers
  for each row execute function app.set_updated_at();

-- Publish guard: a variant can be published only on a published question version; published_at is stamped
-- on the flip and cleared on unpublish.
create or replace function app.guard_comparison_answer_publish()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
begin
  if new.is_published then
    if not exists (
      select 1 from app.content_item_versions civ
      where civ.id = new.content_item_version_id and civ.status = 'published'
    ) then
      raise exception 'comparison_answer:version_not_published' using errcode = '23514';
    end if;
    if tg_op = 'INSERT' or not old.is_published then
      new.published_at := coalesce(new.published_at, now());
    end if;
  else
    new.published_at := null;
  end if;
  return new;
end;
$$;

create trigger content_item_comparison_answers_publish_guard
  before insert or update of is_published, content_item_version_id on app.content_item_comparison_answers
  for each row execute function app.guard_comparison_answer_publish();

alter table app.content_item_comparison_answers enable row level security;
alter table app.content_item_comparison_answers force row level security;
revoke all on app.content_item_comparison_answers from public, anon, authenticated;
grant select, insert, update, delete on app.content_item_comparison_answers to service_role;
-- No authenticated grant and no policy: read only through public.get_question_experience.

-- ---------------------------------------------------------------------------
-- 3. public.get_question_experience
-- ---------------------------------------------------------------------------

create or replace function public.get_question_experience(
  p_learning_session_id uuid,
  p_ordinal integer default null
)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
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
      'resume', jsonb_build_object('action', v_resume_action, 'ordinal', null,
        'contentItemVersionId', null, 'attemptId', null),
      'item', null, 'mcqChoices', '[]'::jsonb, 'criteria', '[]'::jsonb, 'attempt', null, 'grading', null,
      'mcqFeedback', null, 'priorAttempts', '[]'::jsonb, 'pointsChange', null,
      'comparisonAnswers', '[]'::jsonb, 'topic', null, 'reference', '{}'::jsonb, 'memoryHooks', '[]'::jsonb);
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

  return jsonb_build_object(
    'session', jsonb_build_object(
      'learningSessionId', v_session.id, 'status', v_session.status, 'entryPath', v_session.entry_path,
      'sessionMode', v_session.session_mode, 'startedAt', v_session.started_at, 'endedAt', v_session.ended_at),
    'counter', jsonb_build_object('index', v_ordinal, 'total', v_total),
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
        'hasStimulusImage', civ.stimulus_image_path is not null)
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
    'memoryHooks', coalesce(v_guides->'memoryHooks', '[]'::jsonb)
  );
end;
$$;

revoke all on function public.get_question_experience(uuid, integer) from public, anon;
grant execute on function public.get_question_experience(uuid, integer) to authenticated, service_role;

commit;
