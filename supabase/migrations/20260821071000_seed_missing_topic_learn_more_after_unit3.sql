begin;

-- Backfill Learn More explainers for every published Topic Point Brief that
-- does not already have one. This intentionally preserves existing
-- hand-authored or previously seeded explainers and only fills gaps.
--
-- Companion context:
--   docs/product/AP_ALL_SUBJECTS_UNIT3_TOPIC_POINT_BRIEFS.md

with missing_briefs as (
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
      when tpb.subject_key = 'ap_calculus_ab' then 'AP Calculus AB'
      when tpb.subject_key = 'ap_calculus_bc' then 'AP Calculus BC'
      when tpb.subject_key = 'ap_chemistry' then 'AP Chemistry'
      when tpb.subject_key = 'ap_physics_1' then 'AP Physics 1'
      when tpb.subject_key = 'ap_physics_2' then 'AP Physics 2'
      when tpb.subject_key = 'ap_physics_c_em' then 'AP Physics C: Electricity and Magnetism'
      when tpb.subject_key = 'ap_physics_c_mechanics' then 'AP Physics C: Mechanics'
      when tpb.subject_key = 'ap_precalculus' then 'AP Precalculus'
      when tpb.subject_key = 'ap_statistics' then 'AP Statistics'
      else initcap(replace(tpb.subject_key, '_', ' '))
    end as subject_name,
    case
      when tpb.subject_key = 'ap_biology' then
        'A free-response prompt asks you to explain an observed biological pattern using ' || tpb.title || '. What should your answer make explicit?'
      when tpb.subject_key = 'ap_chemistry' then
        'A problem gives chemical data or a particle-level claim involving ' || tpb.title || '. What should your response show to earn the explanation point?'
      when tpb.subject_key = 'ap_statistics' then
        'A scenario gives data from a real study and asks about ' || tpb.title || '. What should your response connect back to the context?'
      when tpb.subject_key in ('ap_calculus_ab', 'ap_calculus_bc') then
        'A calculus prompt asks you to justify a conclusion involving ' || tpb.title || '. What should your work and sentence make clear?'
      when tpb.subject_key = 'ap_precalculus' then
        'A precalculus prompt asks you to interpret a function or model involving ' || tpb.title || '. What should your answer connect?'
      when tpb.subject_key like 'ap_physics%' then
        'A physics prompt gives a scenario involving ' || tpb.title || '. What should your response show to earn credit?'
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
      when tpb.subject_key in ('ap_calculus_ab', 'ap_calculus_bc') then
        'I would write the final value or conclusion without showing why it follows.'
      when tpb.subject_key = 'ap_precalculus' then
        'I would describe the graph or formula without connecting it to the model.'
      when tpb.subject_key like 'ap_physics%' then
        'I would plug into a formula without defining the quantities or direction.'
      else
        'I would give the final answer without explaining the evidence.'
    end as weak_response
  from app.topic_point_briefs tpb
  left join app.topic_explainers te
    on te.subject_key = tpb.subject_key
   and te.topic_code = tpb.topic_code
   and te.status = 'published'
  where tpb.status = 'published'
    and te.topic_explainer_id is null
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
from missing_briefs
on conflict (subject_key, topic_code) do nothing;

do $verify$
declare
  v_missing_count integer;
  v_orphan_count integer;
begin
  select count(*) into v_missing_count
  from app.topic_point_briefs tpb
  left join app.topic_explainers te
    on te.subject_key = tpb.subject_key
   and te.topic_code = tpb.topic_code
   and te.status = 'published'
  where tpb.status = 'published'
    and te.topic_explainer_id is null;

  if v_missing_count <> 0 then
    raise exception 'expected every published topic point brief to have a published explainer, found % missing', v_missing_count;
  end if;

  select count(*) into v_orphan_count
  from app.topic_explainers te
  left join app.topic_point_briefs tpb
    on tpb.subject_key = te.subject_key
   and tpb.topic_code = te.topic_code
   and tpb.status = 'published'
  where te.status = 'published'
    and tpb.topic_point_brief_id is null;

  if v_orphan_count <> 0 then
    raise exception 'expected no published orphan topic explainers, found %', v_orphan_count;
  end if;
end $verify$;

commit;
