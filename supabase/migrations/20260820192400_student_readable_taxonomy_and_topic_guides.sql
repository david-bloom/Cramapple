-- Student-readable taxonomy seam and topic point guide backend.
--
-- Supabase is the canonical runtime source for subject/unit/topic taxonomy.
-- Raw taxonomy tables remain private; students read through authenticated RPCs.
-- Topic point guide content is also private by default and exposed only when
-- published through an authenticated RPC.

begin;

-- ---------------------------------------------------------------------------
-- Topic point guide content tables
-- ---------------------------------------------------------------------------

create table app.topic_point_briefs (
  topic_point_brief_id uuid primary key default gen_random_uuid(),
  subject_key text not null,
  unit_number integer not null,
  topic_code text not null,
  title text not null,
  class_importance text not null,
  exam_importance text not null,
  what_it_is text not null,
  why_it_matters text not null,
  how_points_are_earned text not null,
  answer_move text not null,
  common_point_loss text not null,
  learn_more_path text not null,
  practice_subject_key text not null,
  practice_unit_number integer not null,
  practice_topic_code text not null,
  status text not null default 'draft',
  source_note text not null default 'cramapple-authored',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint topic_point_briefs_subject_key_check
    check (subject_key ~ '^[a-z0-9][a-z0-9_]*$'),
  constraint topic_point_briefs_unit_check
    check (unit_number > 0 and practice_unit_number > 0),
  constraint topic_point_briefs_topic_code_check
    check (
      topic_code ~ '^[0-9]+\.[0-9]+$'
      and practice_topic_code ~ '^[0-9]+\.[0-9]+$'
    ),
  constraint topic_point_briefs_importance_check
    check (
      class_importance in ('not-important', 'somewhat-important', 'very-important')
      and exam_importance in ('not-important', 'somewhat-important', 'very-important')
    ),
  constraint topic_point_briefs_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint topic_point_briefs_nonempty_check
    check (
      char_length(btrim(title)) > 0
      and char_length(btrim(what_it_is)) > 0
      and char_length(btrim(why_it_matters)) > 0
      and char_length(btrim(how_points_are_earned)) > 0
      and char_length(btrim(answer_move)) > 0
      and char_length(btrim(common_point_loss)) > 0
      and learn_more_path ~ '^/learn/'
    ),
  constraint topic_point_briefs_published_at_check
    check ((status = 'published') = (published_at is not null)),
  constraint topic_point_briefs_unique_topic
    unique (subject_key, topic_code)
);

create index topic_point_briefs_subject_unit_status_idx
  on app.topic_point_briefs (subject_key, unit_number, status, topic_code);

create trigger topic_point_briefs_set_updated_at
before update on app.topic_point_briefs
for each row execute function app.set_updated_at();

alter table app.topic_point_briefs enable row level security;
alter table app.topic_point_briefs force row level security;
revoke all on app.topic_point_briefs from public, anon, authenticated;
grant select, insert, update, delete on app.topic_point_briefs to service_role;
grant select on app.topic_point_briefs to authenticated;

create policy topic_point_briefs_select_published
on app.topic_point_briefs
for select
to authenticated
using (
  status = 'published'
  and exists (
    select 1
    from app.subjects s
    where s.subject_key = topic_point_briefs.subject_key
      and s.status = 'active'
  )
);

create table app.topic_explainers (
  topic_explainer_id uuid primary key default gen_random_uuid(),
  subject_key text not null,
  unit_number integer not null,
  topic_code text not null,
  title text not null,
  core_idea text not null,
  what_students_need_to_understand text not null,
  how_this_becomes_points text not null,
  answer_move text not null,
  mini_example_question text not null,
  weak_answer text not null,
  point_attaining_answer text not null,
  common_point_loss text not null,
  practice_bridge text not null,
  status text not null default 'draft',
  source_note text not null default 'cramapple-authored',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint topic_explainers_subject_key_check
    check (subject_key ~ '^[a-z0-9][a-z0-9_]*$'),
  constraint topic_explainers_unit_check check (unit_number > 0),
  constraint topic_explainers_topic_code_check
    check (topic_code ~ '^[0-9]+\.[0-9]+$'),
  constraint topic_explainers_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint topic_explainers_nonempty_check
    check (
      char_length(btrim(title)) > 0
      and char_length(btrim(core_idea)) > 0
      and char_length(btrim(what_students_need_to_understand)) > 0
      and char_length(btrim(how_this_becomes_points)) > 0
      and char_length(btrim(answer_move)) > 0
      and char_length(btrim(mini_example_question)) > 0
      and char_length(btrim(weak_answer)) > 0
      and char_length(btrim(point_attaining_answer)) > 0
      and char_length(btrim(common_point_loss)) > 0
      and char_length(btrim(practice_bridge)) > 0
    ),
  constraint topic_explainers_published_at_check
    check ((status = 'published') = (published_at is not null)),
  constraint topic_explainers_unique_topic
    unique (subject_key, topic_code)
);

create index topic_explainers_subject_unit_status_idx
  on app.topic_explainers (subject_key, unit_number, status, topic_code);

create trigger topic_explainers_set_updated_at
before update on app.topic_explainers
for each row execute function app.set_updated_at();

alter table app.topic_explainers enable row level security;
alter table app.topic_explainers force row level security;
revoke all on app.topic_explainers from public, anon, authenticated;
grant select, insert, update, delete on app.topic_explainers to service_role;
grant select on app.topic_explainers to authenticated;

create policy topic_explainers_select_published
on app.topic_explainers
for select
to authenticated
using (
  status = 'published'
  and exists (
    select 1
    from app.subjects s
    where s.subject_key = topic_explainers.subject_key
      and s.status = 'active'
  )
);

-- ---------------------------------------------------------------------------
-- Student-readable RPCs
-- ---------------------------------------------------------------------------

create or replace function public.get_student_taxonomy(
  _subject_key text default null
)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_subject_key text := nullif(btrim(lower(_subject_key)), '');
  v_payload jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if v_subject_key is not null
     and v_subject_key !~ '^[a-z0-9][a-z0-9_]*$' then
    raise exception 'taxonomy:invalid_subject_key' using errcode = '22023';
  end if;

  with latest_sources as (
    select distinct on (tsv.subject_key)
      tsv.taxonomy_source_version,
      tsv.subject_key,
      tsv.school_year,
      tsv.source_title,
      tsv.taxonomy_confidence,
      tsv.source_citation,
      tsv.verified_at
    from app.taxonomy_source_versions tsv
    where tsv.taxonomy_confidence = 'verified'
      and (v_subject_key is null or tsv.subject_key = v_subject_key)
      and exists (
        select 1
        from app.taxonomy_units tu
        where tu.taxonomy_source_version = tsv.taxonomy_source_version
      )
    order by
      tsv.subject_key,
      tsv.school_year desc,
      tsv.verified_at desc nulls last,
      tsv.created_at desc
  ), subject_rows as (
    select
      latest_sources.*,
      coalesce(
        (
          select s.display_name
          from app.subjects s
          where s.subject_key = latest_sources.subject_key
            and s.status = 'active'
          limit 1
        ),
        initcap(replace(latest_sources.subject_key, '_', ' '))
      ) as display_name
    from latest_sources
  )
  select jsonb_build_object(
    'subjects',
    coalesce(
      jsonb_agg(
        jsonb_build_object(
          'subjectKey', sr.subject_key,
          'displayName', sr.display_name,
          'schoolYear', sr.school_year,
          'sourceTitle', sr.source_title,
          'taxonomyConfidence', sr.taxonomy_confidence,
          'verifiedAt', sr.verified_at,
          'units', coalesce((
            select jsonb_agg(
              jsonb_build_object(
                'unitNumber', tu.unit_number,
                'unitTitle', tu.unit_title,
                'isExamAssessed', tu.is_exam_assessed,
                'topics', coalesce((
                  select jsonb_agg(
                    jsonb_build_object(
                      'topicCode', tt.topic_code,
                      'topicTitle', tt.topic_title,
                      'hasPointBrief', exists (
                        select 1
                        from app.topic_point_briefs tpb
                        where tpb.subject_key = sr.subject_key
                          and tpb.topic_code = tt.topic_code
                          and tpb.status = 'published'
                      ),
                      'hasExplainer', exists (
                        select 1
                        from app.topic_explainers te
                        where te.subject_key = sr.subject_key
                          and te.topic_code = tt.topic_code
                          and te.status = 'published'
                      )
                    )
                    order by
                      split_part(tt.topic_code, '.', 1)::integer,
                      split_part(tt.topic_code, '.', 2)::integer
                  )
                  from app.taxonomy_topics tt
                  where tt.taxonomy_source_version = sr.taxonomy_source_version
                    and tt.unit_number = tu.unit_number
                ), '[]'::jsonb)
              )
              order by tu.unit_number
            )
            from app.taxonomy_units tu
            where tu.taxonomy_source_version = sr.taxonomy_source_version
          ), '[]'::jsonb)
        )
        order by sr.display_name
      ),
      '[]'::jsonb
    )
  )
  into v_payload
  from subject_rows sr;

  return coalesce(v_payload, jsonb_build_object('subjects', '[]'::jsonb));
end;
$$;

revoke all on function public.get_student_taxonomy(text) from public, anon;
grant execute on function public.get_student_taxonomy(text)
  to authenticated, service_role;

create or replace function public.get_topic_point_guides(
  _subject_key text,
  _unit_number integer default null,
  _topic_code text default null
)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_subject_key text := nullif(btrim(lower(_subject_key)), '');
  v_topic_code text := nullif(btrim(_topic_code), '');
  v_payload jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if v_subject_key is null then
    raise exception 'topic_guides:subject_required' using errcode = '22023';
  end if;
  if v_subject_key !~ '^[a-z0-9][a-z0-9_]*$' then
    raise exception 'topic_guides:invalid_subject_key' using errcode = '22023';
  end if;
  if _unit_number is not null and _unit_number <= 0 then
    raise exception 'topic_guides:invalid_unit' using errcode = '22023';
  end if;
  if v_topic_code is not null and v_topic_code !~ '^[0-9]+\.[0-9]+$' then
    raise exception 'topic_guides:invalid_topic_code' using errcode = '22023';
  end if;

  with published_briefs as (
    select *
    from app.topic_point_briefs tpb
    where tpb.subject_key = v_subject_key
      and tpb.status = 'published'
      and (_unit_number is null or tpb.unit_number = _unit_number)
      and (v_topic_code is null or tpb.topic_code = v_topic_code)
  ), published_explainers as (
    select *
    from app.topic_explainers te
    where te.subject_key = v_subject_key
      and te.status = 'published'
      and (_unit_number is null or te.unit_number = _unit_number)
      and (v_topic_code is null or te.topic_code = v_topic_code)
  )
  select jsonb_build_object(
    'subjectKey', v_subject_key,
    'unitNumber', _unit_number,
    'topicCode', v_topic_code,
    'briefs', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'subjectKey', tpb.subject_key,
          'unitId', 'unit-' || tpb.unit_number::text,
          'unitNumber', tpb.unit_number,
          'topicId', tpb.topic_code,
          'topicCode', tpb.topic_code,
          'title', tpb.title,
          'classImportance', tpb.class_importance,
          'examImportance', tpb.exam_importance,
          'whatItIs', tpb.what_it_is,
          'whyItMatters', tpb.why_it_matters,
          'howPointsAreEarned', tpb.how_points_are_earned,
          'answerMove', tpb.answer_move,
          'commonPointLoss', tpb.common_point_loss,
          'learnMorePath', tpb.learn_more_path,
          'practiceParams', jsonb_build_object(
            'subject', tpb.practice_subject_key,
            'unit', tpb.practice_unit_number::text,
            'topic', tpb.practice_topic_code
          )
        )
        order by
          tpb.unit_number,
          split_part(tpb.topic_code, '.', 1)::integer,
          split_part(tpb.topic_code, '.', 2)::integer
      )
      from published_briefs tpb
    ), '[]'::jsonb),
    'explainers', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'subject', te.subject_key,
          'subjectKey', te.subject_key,
          'unitId', 'unit-' || te.unit_number::text,
          'unitNumber', te.unit_number,
          'topicId', te.topic_code,
          'topicCode', te.topic_code,
          'title', te.title,
          'coreIdea', te.core_idea,
          'whatStudentsNeedToUnderstand', te.what_students_need_to_understand,
          'howThisBecomesPoints', te.how_this_becomes_points,
          'answerMove', te.answer_move,
          'miniExample', jsonb_build_object(
            'question', te.mini_example_question,
            'weakAnswer', te.weak_answer,
            'pointAttainingAnswer', te.point_attaining_answer
          ),
          'commonPointLoss', te.common_point_loss,
          'practiceBridge', te.practice_bridge
        )
        order by
          te.unit_number,
          split_part(te.topic_code, '.', 1)::integer,
          split_part(te.topic_code, '.', 2)::integer
      )
      from published_explainers te
    ), '[]'::jsonb)
  )
  into v_payload;

  return v_payload;
end;
$$;

revoke all on function public.get_topic_point_guides(text, integer, text)
  from public, anon;
grant execute on function public.get_topic_point_guides(text, integer, text)
  to authenticated, service_role;

create or replace view public.topic_point_briefs
with (security_invoker = true, security_barrier = true)
as
select
  tpb.topic_point_brief_id as id,
  tpb.subject_key,
  tpb.unit_number,
  'unit-' || tpb.unit_number::text as unit_id,
  tpb.topic_code as topic_id,
  tpb.title,
  tpb.class_importance,
  tpb.exam_importance,
  tpb.what_it_is,
  tpb.why_it_matters,
  tpb.how_points_are_earned,
  tpb.answer_move,
  tpb.common_point_loss,
  tpb.learn_more_path,
  tpb.practice_subject_key,
  tpb.practice_unit_number,
  tpb.practice_topic_code,
  jsonb_build_object(
    'subject', tpb.practice_subject_key,
    'unit', tpb.practice_unit_number::text,
    'topic', tpb.practice_topic_code
  ) as practice_params,
  tpb.created_at,
  tpb.updated_at,
  tpb.published_at
from app.topic_point_briefs tpb
where tpb.status = 'published';

create or replace view public.topic_explainers
with (security_invoker = true, security_barrier = true)
as
select
  te.topic_explainer_id as id,
  te.subject_key,
  te.unit_number,
  'unit-' || te.unit_number::text as unit_id,
  te.topic_code as topic_id,
  te.title,
  te.core_idea,
  te.what_students_need_to_understand,
  te.how_this_becomes_points,
  te.answer_move,
  te.mini_example_question,
  te.weak_answer,
  te.point_attaining_answer,
  te.common_point_loss,
  te.practice_bridge,
  jsonb_build_object(
    'question', te.mini_example_question,
    'weakAnswer', te.weak_answer,
    'pointAttainingAnswer', te.point_attaining_answer
  ) as mini_example,
  te.created_at,
  te.updated_at,
  te.published_at
from app.topic_explainers te
where te.status = 'published';

revoke all on public.topic_point_briefs
  from public, anon, authenticated, service_role;
revoke all on public.topic_explainers
  from public, anon, authenticated, service_role;
grant select on public.topic_point_briefs to authenticated, service_role;
grant select on public.topic_explainers to authenticated, service_role;

comment on function public.get_student_taxonomy(text) is
  'Authenticated student-readable taxonomy seam. Raw app taxonomy registry tables remain private.';

comment on function public.get_topic_point_guides(text, integer, text) is
  'Authenticated published topic point brief and Learn More explainer API. Missing guide content returns empty arrays.';

comment on view public.topic_point_briefs is
  'Authenticated Lovable-facing read view for published topic point briefs. app.topic_point_briefs remains the source of truth.';

comment on view public.topic_explainers is
  'Authenticated Lovable-facing read view for published topic Learn More explainers. app.topic_explainers remains the source of truth.';

-- ---------------------------------------------------------------------------
-- AP Calculus AB Unit 1 seed content
-- ---------------------------------------------------------------------------

with brief_seed (
  topic_code, title, class_importance, exam_importance, what_it_is,
  why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path
) as (
  values
  ('1.1','Introducing Calculus: Can Change Occur at an Instant?','very-important','somewhat-important',
   'This topic introduces the move from average change over an interval to change at a single instant. A limit describes what average rates approach as the interval around the instant shrinks.',
   'This is the conceptual bridge into derivatives. Students who understand why an instant needs a limit are better prepared to interpret slope, velocity, and change throughout the course.',
   'You earn points by recognizing whether a question asks about an interval or an instant and by connecting the instant case to limiting behavior.',
   'Ask: over an interval or at one point? If it is at one point, describe the instantaneous rate as the value approached by average rates over smaller intervals.',
   'Trying to compute an instantaneous rate as a direct quotient with zero change in x.',
   '/learn/ap-calculus-ab/unit-1/instantaneous-change'),
  ('1.2','Defining Limits and Using Limit Notation','very-important','very-important',
   'A limit describes the value a function approaches as x gets close to a chosen input. Limit notation names that approaching behavior precisely.',
   'Limit notation is the language used for continuity, derivatives, infinite behavior, and many justifications.',
   'You earn points by reading and writing the approaching input, function, direction when specified, and value approached.',
   'Read the notation as: as x approaches c, f(x) approaches L. Keep approaches separate from equals.',
   'Replacing the limit with f(a) automatically, or dropping the direction marker on a one-sided limit.',
   '/learn/ap-calculus-ab/unit-1/limit-notation'),
  ('1.3','Estimating Limit Values from Graphs','very-important','very-important',
   'A graph can show what y-value a function approaches as x moves toward a chosen input from the left, right, or both sides.',
   'Graph-based limits train students to focus on nearby behavior instead of point values, a skill that returns in continuity, asymptotes, and derivative graphs.',
   'You earn points by identifying left-hand and right-hand behavior and concluding whether the two-sided limit exists.',
   'Trace the graph toward the x-value from both sides before looking at the point on the graph.',
   'Using a filled or open point as the limit value without checking nearby graph behavior.',
   '/learn/ap-calculus-ab/unit-1/estimating-limits-from-graphs'),
  ('1.4','Estimating Limit Values from Tables','very-important','very-important',
   'A table can suggest a limit by showing how function values behave for x-values close to a chosen input.',
   'Tables appear when exact formulas are not given. Students need to use numerical evidence carefully and distinguish estimates from exact values.',
   'You earn points by using nearby table values from both sides and writing an estimate that matches the evidence.',
   'Look inward from both sides of the table, then state the trend and estimated limit.',
   'Choosing one table entry instead of describing the trend across nearby entries.',
   '/learn/ap-calculus-ab/unit-1/estimating-limits-from-tables'),
  ('1.5','Determining Limits Using Algebraic Properties of Limits','very-important','very-important',
   'Limit properties let students combine simpler limits to determine limits of sums, differences, products, quotients, and composite functions.',
   'This is where limits become a reliable calculation tool instead of only a graphical or numerical idea.',
   'You earn points by applying a valid property, preserving expression structure, and showing setup that makes the final value follow.',
   'Break the expression into parts, determine component limits, then apply the matching property.',
   'Applying quotient or composition rules mechanically when the needed conditions are not met.',
   '/learn/ap-calculus-ab/unit-1/algebraic-properties-of-limits'),
  ('1.6','Determining Limits Using Algebraic Manipulation','very-important','very-important',
   'Some limit expressions hide their behavior until they are rewritten into an equivalent useful form.',
   'Factoring, rationalizing, simplifying, or using identities can turn a blocked expression into a solvable limit.',
   'You earn points by choosing a valid rewrite, showing the transformed expression, and evaluating from the simplified form.',
   'When substitution is blocked, ask what equivalent form removes the obstacle.',
   'Stopping at 0/0, or canceling terms that are not common factors.',
   '/learn/ap-calculus-ab/unit-1/algebraic-manipulation-for-limits'),
  ('1.7','Selecting Procedures for Determining Limits','very-important','very-important',
   'This topic is about choosing the method that fits the limit problem before carrying out the calculation.',
   'AP questions often reward recognizing the right path: direct property use, graph or table reasoning, factoring, rationalizing, or one-sided analysis.',
   'You earn points by classifying the problem form and selecting a procedure that matches it.',
   'Before solving, name the cue: direct substitution works, sides must be checked, factoring helps, or another strategy fits.',
   'Defaulting to a familiar technique without checking whether the problem calls for it.',
   '/learn/ap-calculus-ab/unit-1/selecting-limit-procedures'),
  ('1.8','Determining Limits Using the Squeeze Theorem','somewhat-important','somewhat-important',
   'The squeeze theorem finds a limit by trapping one function between two functions that approach the same value.',
   'This is an early example of theorem-based limit reasoning where conditions force a conclusion.',
   'You earn points by showing bounds, showing both bounding limits match, and then stating the squeezed conclusion.',
   'Write the inequality first, find the outside limits, then conclude the middle limit.',
   'Naming the theorem without showing the bounding relationship and matching limits.',
   '/learn/ap-calculus-ab/unit-1/squeeze-theorem'),
  ('1.9','Connecting Multiple Representations of Limits','very-important','very-important',
   'The same limit can be represented by notation, words, a graph, a table, or an equation.',
   'AP Calculus regularly changes representation without changing the underlying mathematical claim.',
   'You earn points by identifying the same limiting behavior across representations and keeping the claim consistent.',
   'Convert each representation into: as x approaches c, f(x) approaches L.',
   'Matching a table or graph to a function value instead of to approach behavior.',
   '/learn/ap-calculus-ab/unit-1/multiple-representations-of-limits'),
  ('1.10','Exploring Types of Discontinuities','very-important','very-important',
   'A discontinuity is a place where continuity fails. The type depends on whether the value, one-sided limits, or bounded behavior fails.',
   'Naming the type helps students explain what failed rather than merely saying the graph is broken.',
   'You earn points by classifying the discontinuity and connecting that classification to limit evidence.',
   'Check left-hand limit, right-hand limit, and f(c), then classify based on which part fails.',
   'Calling every gap removable or every discontinuity an asymptote without checking behavior.',
   '/learn/ap-calculus-ab/unit-1/types-of-discontinuities'),
  ('1.11','Defining Continuity at a Point','very-important','very-important',
   'A function is continuous at a point when f(c) exists, the limit exists, and the limit equals f(c).',
   'Continuity is a condition checklist. AP explanations often reward verifying each part before drawing the conclusion.',
   'You earn points by checking all three conditions and using them to justify whether the function is continuous.',
   'Use the checklist: value exists, limit exists, value equals limit, then state the conclusion.',
   'Saying a function is continuous because the graph looks connected without verifying conditions.',
   '/learn/ap-calculus-ab/unit-1/continuity-at-a-point'),
  ('1.12','Confirming Continuity over an Interval','very-important','very-important',
   'Continuity over an interval means the function is continuous at every point in that interval.',
   'Many AP conclusions depend on interval-level continuity, including theorem use and domain reasoning.',
   'You earn points by identifying the interval, checking special points, and naming domain restrictions or endpoints that matter.',
   'Start with the function family and domain, then check special points inside the interval.',
   'Claiming continuity over an interval while ignoring holes, asymptotes, piecewise boundaries, or excluded domain values.',
   '/learn/ap-calculus-ab/unit-1/continuity-over-an-interval'),
  ('1.13','Removing Discontinuities','very-important','very-important',
   'A removable discontinuity can be fixed by defining or redefining the function value so it equals the limit at that point.',
   'This topic turns the definition of continuity into an action: find the value or parameter that makes the function continuous.',
   'You earn points by finding the relevant limit and setting the function value or parameter equal to it.',
   'Find the limit at the discontinuity first, then set f(c) or the parameter expression equal to that limit.',
   'Solving for a value without showing that it matches the limiting behavior.',
   '/learn/ap-calculus-ab/unit-1/removing-discontinuities'),
  ('1.14','Connecting Infinite Limits and Vertical Asymptotes','very-important','very-important',
   'An infinite limit describes function values growing without bound as x approaches a finite input.',
   'Students need to distinguish unbounded behavior from finite limits, jumps, and ordinary function values.',
   'You earn points by using limit notation to describe unbounded behavior and connecting it to a vertical asymptote when appropriate.',
   'Check each side of the input. If f(x) grows without bound, write the infinite limit and name x = c as the vertical asymptote.',
   'Writing only does not exist when the problem asks for behavior or an asymptote connection.',
   '/learn/ap-calculus-ab/unit-1/infinite-limits-and-vertical-asymptotes'),
  ('1.15','Connecting Limits at Infinity and Horizontal Asymptotes','very-important','very-important',
   'A limit at infinity describes end behavior as x grows very large positive or negative.',
   'End behavior helps students describe long-run function behavior analytically, graphically, and verbally.',
   'You earn points by identifying end behavior, writing the correct limit at infinity, and connecting a finite result to y = L.',
   'Ask what f(x) approaches as x goes far left or far right. If it approaches L, name y = L.',
   'Confusing vertical asymptotes with horizontal asymptotes or finite-input limits with limits at infinity.',
   '/learn/ap-calculus-ab/unit-1/limits-at-infinity-and-horizontal-asymptotes'),
  ('1.16','Working with the Intermediate Value Theorem','very-important','very-important',
   'The Intermediate Value Theorem says a continuous function on a closed interval takes every value between its endpoint values somewhere inside the interval.',
   'This is an early existence theorem: it proves a value occurs without finding its exact location.',
   'You earn points by verifying continuity, showing the target value lies between endpoint values, and stating the existence conclusion.',
   'Write the conditions first: continuous on [a,b], target between f(a) and f(b), therefore some c exists in (a,b).',
   'Jumping to the conclusion without verifying continuity and the endpoint-value condition.',
   '/learn/ap-calculus-ab/unit-1/intermediate-value-theorem')
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, practice_subject_key, practice_unit_number,
  practice_topic_code, status, published_at
)
select
  'ap_calculus_ab', 1, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, 'ap_calculus_ab', 1, topic_code,
  'published', now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  status = excluded.status,
  published_at = excluded.published_at;

with biology_brief_seed (
  topic_code, title, class_importance, exam_importance, what_it_is,
  why_it_matters, how_points_are_earned, answer_move, common_point_loss,
  learn_more_path
) as (
  values
  ('1.1','Structure of Water and Hydrogen Bonding','very-important','very-important',
   'Water is a polar molecule. Its uneven charge distribution allows water molecules to form hydrogen bonds with each other and with other polar or charged substances.',
   'Water properties explain biological patterns such as cohesion, adhesion, surface tension, temperature stability, solvent behavior, and cellular chemistry in aqueous environments.',
   'You earn points by connecting a property of water to the molecular reason behind it and then to the biological consequence.',
   'Use a three-step chain: water is polar -> hydrogen bonds form -> this causes the biological property or effect.',
   'Naming a water property without explaining how polarity or hydrogen bonding produces it.',
   '/learn/ap-biology/unit-1/water-and-hydrogen-bonding'),
  ('1.2','Elements of Life','very-important','somewhat-important',
   'Living systems are built mostly from a small set of elements, especially carbon, hydrogen, oxygen, nitrogen, phosphorus, and sulfur.',
   'Element composition helps students explain why particular molecules can store energy, carry information, form membranes, or build cellular structures.',
   'You earn points by linking an element to the molecule or structure it supports, such as phosphorus in nucleic acids and phospholipids or nitrogen in amino acids and nucleotides.',
   'Do not just list elements. Connect the element to a biological molecule and the molecule to its function.',
   'Reciting CHNOPS without explaining what those elements let cells build or do.',
   '/learn/ap-biology/unit-1/elements-of-life'),
  ('1.3','Introduction to Macromolecules','very-important','very-important',
   'Biological macromolecules are large molecules built from smaller subunits. Dehydration synthesis builds polymers by removing water, and hydrolysis breaks polymers by adding water.',
   'This topic gives students a reusable way to think about carbohydrates, proteins, nucleic acids, and many digestion or biosynthesis contexts.',
   'You earn points by identifying whether a system is building or breaking a polymer and by connecting the reaction to water use or release and bond formation or cleavage.',
   'Ask: is the cell building a larger molecule or breaking one apart? Then name dehydration synthesis or hydrolysis and state what happens to water.',
   'Mixing up dehydration synthesis and hydrolysis, especially the direction of water movement.',
   '/learn/ap-biology/unit-1/macromolecules'),
  ('1.4','Carbohydrates','very-important','very-important',
   'Carbohydrates include monosaccharides and polysaccharides. They can provide readily usable energy, store energy, or contribute to structural support depending on their bonds and organization.',
   'AP Biology often rewards structure-function reasoning. The same basic sugar subunits can lead to different biological roles depending on how they are linked and arranged.',
   'You earn points by connecting carbohydrate structure to function, such as glucose availability for energy, starch or glycogen for storage, or cellulose for plant cell wall support.',
   'Name the carbohydrate type, identify the structural feature, and connect it to energy storage, energy use, or support.',
   'Saying carbohydrates are only for energy and missing structural roles such as cellulose.',
   '/learn/ap-biology/unit-1/carbohydrates'),
  ('1.5','Lipids','very-important','very-important',
   'Lipids are generally nonpolar or hydrophobic molecules. Important examples include fats, phospholipids, and steroids, each with structures that support different cell functions.',
   'Lipids connect Unit 1 chemistry to membranes, energy storage, insulation, signaling, and cell compartment boundaries later in the course.',
   'You earn points by connecting nonpolar or amphipathic structure to function. For example, phospholipid structure explains membrane formation, while fats support long-term energy storage.',
   'Start with polarity: hydrophobic or amphipathic? Then connect that property to membrane behavior, storage, insulation, or signaling.',
   'Treating all lipids as the same instead of distinguishing fats, phospholipids, and steroids by structure and function.',
   '/learn/ap-biology/unit-1/lipids'),
  ('1.6','Nucleic Acids','very-important','very-important',
   'Nucleic acids such as DNA and RNA are polymers of nucleotides. Their nucleotide sequences store and transmit biological information.',
   'This topic starts the information theme that returns in DNA replication, gene expression, biotechnology, inheritance, and evolution.',
   'You earn points by connecting nucleotide structure and sequence to information storage, directionality, complementary base pairing, or differences between DNA and RNA.',
   'When asked about DNA or RNA, connect structure to information: sequence stores instructions, base pairing supports copying, and strand direction affects synthesis.',
   'Describing nucleic acids only as genetic material without explaining how sequence, base pairing, or strand structure supports the function.',
   '/learn/ap-biology/unit-1/nucleic-acids'),
  ('1.7','Proteins','very-important','very-important',
   'Proteins are polymers of amino acids joined by peptide bonds. A protein''s amino acid sequence influences its folding, shape, and function.',
   'Proteins are central to enzymes, transport, signaling, structure, movement, and regulation. AP Biology questions often ask students to connect a change in structure to a change in function.',
   'You earn points by tracing the structure-function chain: amino acid sequence affects interactions, interactions affect folding and shape, and shape affects protein function.',
   'Use the chain: sequence -> folding/shape -> function. If a mutation or environmental change appears, explain how it could alter that chain.',
   'Saying a protein is denatured or changed without connecting the structural change to a functional consequence.',
   '/learn/ap-biology/unit-1/proteins')
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, practice_subject_key, practice_unit_number,
  practice_topic_code, status, published_at
)
select
  'ap_biology', 1, topic_code, title, class_importance, exam_importance,
  what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss, learn_more_path, 'ap_biology', 1, topic_code,
  'published', now()
from biology_brief_seed
on conflict (subject_key, topic_code) do update
set
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  status = excluded.status,
  published_at = excluded.published_at;

with explainer_seed (
  topic_code, title, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('1.1','Introducing Calculus: Can Change Occur at an Instant?',
   'Calculus begins with the problem that average rate is easy over an interval, but an instant has no interval width.',
   'Average rate compares two inputs. Instantaneous rate is the value those average rates approach near one input.',
   'Points come from connecting an instant to a limiting process, not from dividing by zero.',
   'Ask whether the change is over an interval or at one point.',
   'A car position is measured near t = 4. What does speed at exactly t = 4 mean?',
   'Use position divided by time at t = 4.',
   'The speed at t = 4 is the limit of average velocities over intervals containing t = 4 as the interval width approaches 0.',
   'Trying to compute an instantaneous rate with zero change in x.',
   'Practice should distinguish interval questions from instant questions.'),
  ('1.2','Defining Limits and Using Limit Notation',
   'A limit names what a function approaches as x gets close to a chosen input.',
   'Approaches does not mean equals. The limit is about nearby behavior, and one-sided notation adds direction.',
   'Points come from translating notation accurately into a mathematical claim.',
   'Read notation as: as x approaches c, f(x) approaches L.',
   'Explain what it means for f(x) to approach 5 as x approaches 2.',
   'f(2) = 5.',
   'As x gets close to 2, f(x) gets close to 5; this does not by itself tell us f(2).',
   'Replacing a limit statement with a function-value statement.',
   'Practice should mix notation, words, graphs, and tables.'),
  ('1.3','Estimating Limit Values from Graphs',
   'A graph shows the y-value approached as x moves toward an input.',
   'The filled point shows f(c); nearby curve behavior shows the limit.',
   'Points come from naming left- and right-hand behavior before concluding.',
   'Trace toward the x-value from both sides before using the plotted point.',
   'A graph approaches y = 4 from both sides at x = 3 but has a filled point at (3,1).',
   'The limit is 1 because the filled point is at y = 1.',
   'The limit is 4 because the graph approaches y = 4 from both sides; the filled point gives f(3).',
   'Using the function value instead of approaching graph behavior.',
   'Practice should include holes, jumps, and matching one-sided limits.'),
  ('1.4','Estimating Limit Values from Tables',
   'A table suggests a limit by showing values near the target input.',
   'A table gives evidence of a trend, not automatic proof of an exact value.',
   'Points come from using nearby values on both sides and stating the supported estimate.',
   'Look inward from both sides of the table and state the trend.',
   'Values near x = 2 are 4.9, 4.99, 5.01, and 5.1. Estimate the limit.',
   'The limit is 5.1 because that is in the table.',
   'The limit appears to be 5 because nearby values approach 5 from both sides.',
   'Choosing one table entry instead of describing the trend.',
   'Practice should ask students to explain the numerical evidence.'),
  ('1.5','Determining Limits Using Algebraic Properties of Limits',
   'Limit properties combine simpler limits into limits of larger expressions.',
   'The properties are valid procedures when the component limits meet the needed conditions.',
   'Points come from showing the property setup, not just the final number.',
   'Break the expression into parts, then apply the property that matches the structure.',
   'If lim f(x)=3 and lim g(x)=2, determine lim(f(x)+4g(x)).',
   'It is 7.',
   'Using limit properties, the limit is lim f(x)+4 lim g(x)=3+4(2)=11.',
   'Applying a property without checking that its conditions fit.',
   'Practice should ask students to identify the property being used.'),
  ('1.6','Determining Limits Using Algebraic Manipulation',
   'Some expressions must be rewritten before their limit behavior is visible.',
   'A blocked form such as 0/0 may need factoring, rationalizing, simplifying, or an identity.',
   'Points come from the valid rewrite that justifies the final limit.',
   'When substitution is blocked, ask what equivalent form removes the obstacle.',
   'Determine lim (x^2 - 9)/(x - 3) as x approaches 3.',
   'It is undefined because plugging in 3 gives 0/0.',
   'For x near 3, the expression simplifies to x+3, so the limit is 6.',
   'Stopping at 0/0 or canceling terms that are not common factors.',
   'Practice should require naming the manipulation.'),
  ('1.7','Selecting Procedures for Determining Limits',
   'This topic is about deciding which limit method fits the problem.',
   'Different representations and algebraic forms give different cues.',
   'Points come from choosing a procedure that matches the form before solving.',
   'Classify the problem before calculating.',
   'Direct substitution into a rational expression gives 0/0. What should you consider first?',
   'Use L''Hospital''s Rule.',
   'In Unit 1, first look for algebraic simplification such as factoring, a common factor, or a conjugate.',
   'Using a familiar method because it feels comfortable.',
   'Practice should include mixed items where students choose the method first.'),
  ('1.8','Determining Limits Using the Squeeze Theorem',
   'The squeeze theorem traps one function between two functions approaching the same value.',
   'The theorem is a justification: bounds plus matching outside limits force the middle limit.',
   'Points come from showing the bounds, the matching limits, and the conclusion.',
   'Write the bounds first, then the outside limits, then the squeezed conclusion.',
   'Near x=0, suppose -x^2 <= h(x) <= x^2. Determine the limit of h(x).',
   'The limit is 0 by the squeeze theorem.',
   'Since both bounds approach 0 and h(x) is between them, the squeeze theorem gives lim h(x)=0.',
   'Naming the theorem without verifying the bounds and matching limits.',
   'Practice should emphasize the condition checklist.'),
  ('1.9','Connecting Multiple Representations of Limits',
   'A formula, table, graph, words, and notation can express the same limit.',
   'The underlying sentence stays the same even when the representation changes.',
   'Points come from preserving the same mathematical information across forms.',
   'Convert each form into: as x approaches c, f(x) approaches L.',
   'A table suggests f(x) approaches 4 as x approaches 2. What graph feature matches?',
   'The graph should have f(2)=4.',
   'The graph should approach y=4 as x approaches 2; f(2) may be different.',
   'Matching a limit trend to a function value.',
   'Practice should ask students to choose equivalent representations.'),
  ('1.10','Exploring Types of Discontinuities',
   'A discontinuity occurs where continuity fails, and the type depends on what fails.',
   'Removable, jump, and infinite discontinuities come from different limit and value behavior.',
   'Points come from naming the type and tying it to evidence.',
   'Check left-hand limit, right-hand limit, and f(c), then classify.',
   'At x=1, the left-hand limit is 3 and the right-hand limit is 5.',
   'It is discontinuous.',
   'It is a jump discontinuity because the one-sided limits are finite but not equal.',
   'Naming the discontinuity without explaining the limit behavior.',
   'Practice should require classification plus evidence.'),
  ('1.11','Defining Continuity at a Point',
   'Continuity at a point requires f(c), the limit, and equality between them.',
   'Continuity is a definition with conditions, not just a visual impression.',
   'Points come from checking all three conditions before drawing the conclusion.',
   'Use the checklist: f(c) exists, limit exists, and the limit equals f(c).',
   'If lim f(x)=7 as x approaches 2 and f(2)=7, is f continuous at x=2?',
   'Yes, because the graph is connected.',
   'Yes. f(2) exists, the limit exists, and the limit equals f(2).',
   'Checking only the limit or only the function value.',
   'Practice should decide continuity from multiple representations.'),
  ('1.12','Confirming Continuity over an Interval',
   'A function is continuous over an interval if it is continuous at every point in that interval.',
   'Students must scan the interval for domain restrictions, holes, jumps, asymptotes, and endpoints.',
   'Points come from naming the interval and supporting continuity across the whole interval.',
   'Start with the function family and domain, then check special points.',
   'Is f(x)=1/(x-2) continuous on [0,4]?',
   'Yes, rational functions are continuous.',
   'No. Rational functions are continuous on their domains, but x=2 is not in the domain and lies in [0,4].',
   'Using a general fact while ignoring the domain.',
   'Practice should include specified intervals and special points.'),
  ('1.13','Removing Discontinuities',
   'A removable discontinuity can be fixed by making the function value equal the limit.',
   'A discontinuity is removable only when the limiting behavior has one finite target.',
   'Points come from finding the limit and matching the value or parameter to it.',
   'Find the limit first, then set f(c) or the parameter expression equal to it.',
   'lim f(x)=6 as x approaches 3, but f(3)=1. How can the discontinuity be removed?',
   'Change the graph so it is connected.',
   'Redefine f(3)=6 because continuity requires f(3) to equal the limit.',
   'Solving for a visible point without finding the required limit.',
   'Practice should include removable holes and piecewise parameters.'),
  ('1.14','Connecting Infinite Limits and Vertical Asymptotes',
   'An infinite limit describes unbounded behavior near a finite input.',
   'Infinity describes behavior, not a regular real-number limit.',
   'Points come from writing one-sided or two-sided infinite limit statements and connecting them to vertical asymptotes.',
   'Check each side; if values grow without bound, state the infinite limit and vertical asymptote.',
   'As x approaches 2 from the right, f(x) increases without bound.',
   'The limit is DNE.',
   'The right-hand limit is positive infinity; this supports a vertical asymptote at x=2.',
   'Writing only DNE when the behavior or asymptote connection is requested.',
   'Practice should move between notation, graphs, and asymptote statements.'),
  ('1.15','Connecting Limits at Infinity and Horizontal Asymptotes',
   'A limit at infinity describes end behavior as x goes far left or right.',
   'Horizontal asymptotes describe long-run y-values, not undefined x-values.',
   'Points come from writing the correct limit at infinity and connecting a finite result to y=L.',
   'Ask what f(x) approaches as x goes to positive or negative infinity.',
   'If lim f(x)=3 as x approaches infinity, what graph feature is suggested?',
   'There is a vertical asymptote at x=3.',
   'The graph approaches y=3 as x goes to infinity, so y=3 is a horizontal asymptote to the right.',
   'Confusing x=c vertical asymptotes with y=L horizontal asymptotes.',
   'Practice should interpret end behavior from formulas, graphs, and notation.'),
  ('1.16','Working with the Intermediate Value Theorem',
   'IVT says a continuous function on a closed interval takes every y-value between its endpoint values.',
   'IVT proves existence without locating the exact input.',
   'Points come from verifying continuity, comparing endpoint values, and stating the existence conclusion.',
   'Write the conditions first, then conclude that some c exists.',
   'f is continuous on [1,5], f(1)=2, and f(5)=10. Explain why f(c)=7 for some c.',
   'Because 7 is between 1 and 5.',
   'Because f is continuous and 7 is between f(1)=2 and f(5)=10, IVT guarantees some c in (1,5).',
   'Comparing the target value to x-values instead of endpoint function values.',
   'Practice should require verifying IVT conditions before the conclusion.')
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, status, published_at
)
select
  'ap_calculus_ab', 1, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, 'published', now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  title = excluded.title,
  core_idea = excluded.core_idea,
  what_students_need_to_understand = excluded.what_students_need_to_understand,
  how_this_becomes_points = excluded.how_this_becomes_points,
  answer_move = excluded.answer_move,
  mini_example_question = excluded.mini_example_question,
  weak_answer = excluded.weak_answer,
  point_attaining_answer = excluded.point_attaining_answer,
  common_point_loss = excluded.common_point_loss,
  practice_bridge = excluded.practice_bridge,
  status = excluded.status,
  published_at = excluded.published_at;

commit;
