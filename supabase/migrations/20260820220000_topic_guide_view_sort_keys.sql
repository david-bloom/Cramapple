begin;

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
  tpb.published_at,
  split_part(tpb.topic_code, '.', 1)::integer as topic_sort_major,
  split_part(tpb.topic_code, '.', 2)::integer as topic_sort_minor,
  (split_part(tpb.topic_code, '.', 1)::integer * 1000)
    + split_part(tpb.topic_code, '.', 2)::integer as topic_sort_key
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
  te.published_at,
  split_part(te.topic_code, '.', 1)::integer as topic_sort_major,
  split_part(te.topic_code, '.', 2)::integer as topic_sort_minor,
  (split_part(te.topic_code, '.', 1)::integer * 1000)
    + split_part(te.topic_code, '.', 2)::integer as topic_sort_key
from app.topic_explainers te
where te.status = 'published';

revoke all on public.topic_point_briefs
  from public, anon, authenticated, service_role;
revoke all on public.topic_explainers
  from public, anon, authenticated, service_role;
grant select on public.topic_point_briefs to authenticated, service_role;
grant select on public.topic_explainers to authenticated, service_role;

comment on column public.topic_point_briefs.topic_sort_major is
  'Numeric major component of topic_id for frontend ordering.';
comment on column public.topic_point_briefs.topic_sort_minor is
  'Numeric minor component of topic_id for frontend ordering.';
comment on column public.topic_point_briefs.topic_sort_key is
  'Combined numeric topic sort key. Sort by unit_number, topic_sort_major, topic_sort_minor.';
comment on column public.topic_explainers.topic_sort_major is
  'Numeric major component of topic_id for frontend ordering.';
comment on column public.topic_explainers.topic_sort_minor is
  'Numeric minor component of topic_id for frontend ordering.';
comment on column public.topic_explainers.topic_sort_key is
  'Combined numeric topic sort key. Sort by unit_number, topic_sort_major, topic_sort_minor.';

commit;
