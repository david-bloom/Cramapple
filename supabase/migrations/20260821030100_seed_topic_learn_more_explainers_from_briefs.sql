begin;

-- Publish Learn More explainer payloads for the requested home-topic guide
-- subjects by deriving a subject-specific teaching page from each published
-- topic point brief. The point brief remains the compact home card; this row
-- is the richer page opened by "Learn more".
--
-- Hand-authored AP Calculus AB Unit 1 explainers already exist and are left
-- unchanged.

with source_briefs as (
  select
    tpb.subject_key,
    tpb.unit_number,
    tpb.topic_code,
    tpb.title,
    tpb.what_it_is,
    tpb.why_it_matters,
    tpb.how_points_are_earned,
    tpb.answer_move,
    tpb.common_point_loss,
    case
      when tpb.subject_key = 'ap_biology' then 'AP Biology'
      when tpb.subject_key = 'ap_chemistry' then 'AP Chemistry'
      when tpb.subject_key = 'ap_statistics' then 'AP Statistics'
      when tpb.subject_key = 'ap_calculus_ab' then 'AP Calculus AB'
      else initcap(replace(tpb.subject_key, '_', ' '))
    end as subject_name,
    case
      when tpb.subject_key = 'ap_biology' then
        'A free-response prompt asks you to explain an observed biological pattern using ' || tpb.title || '. What should your answer make explicit?'
      when tpb.subject_key = 'ap_chemistry' then
        'A problem gives chemical data or a particle-level claim involving ' || tpb.title || '. What should your response show to earn the explanation point?'
      when tpb.subject_key = 'ap_statistics' then
        'A scenario gives data from a real study and asks about ' || tpb.title || '. What should your response connect back to the context?'
      when tpb.subject_key = 'ap_calculus_ab' then
        'A calculus prompt asks you to justify a conclusion involving ' || tpb.title || '. What should your work and sentence make clear?'
      else
        'A prompt asks about ' || tpb.title || '. What should your answer make clear?'
    end as mini_question,
    case
      when tpb.subject_key = 'ap_biology' then
        'I would name the biology term and give a general statement.'
      when tpb.subject_key = 'ap_chemistry' then
        'I would do the calculation or name the trend and move on.'
      when tpb.subject_key = 'ap_statistics' then
        'I would report the number or vocabulary term without tying it to the study.'
      when tpb.subject_key = 'ap_calculus_ab' then
        'I would write the final value or conclusion without showing why it follows.'
      else
        'I would give the final answer without explaining the evidence.'
    end as weak_response
  from app.topic_point_briefs tpb
  where tpb.status = 'published'
    and tpb.subject_key in (
      'ap_biology',
      'ap_chemistry',
      'ap_statistics',
      'ap_calculus_ab'
    )
    and not (
      tpb.subject_key = 'ap_calculus_ab'
      and tpb.unit_number = 1
    )
)
insert into app.topic_explainers (
  subject_key,
  unit_number,
  topic_code,
  title,
  core_idea,
  what_students_need_to_understand,
  how_this_becomes_points,
  answer_move,
  mini_example_question,
  weak_answer,
  point_attaining_answer,
  common_point_loss,
  practice_bridge,
  status,
  published_at
)
select
  subject_key,
  unit_number,
  topic_code,
  title,
  what_it_is,
  why_it_matters,
  how_points_are_earned,
  answer_move,
  mini_question,
  weak_response,
  answer_move || ' Then make the scoring connection explicit: ' || how_points_are_earned,
  common_point_loss,
  'Practice this topic by doing one focused item and checking whether your response includes the content, the evidence, and the point-earning connection for ' || subject_name || ' Unit ' || unit_number::text || ', Topic ' || topic_code || '.',
  'published',
  now()
from source_briefs
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
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
  published_at = excluded.published_at,
  updated_at = now();

commit;
