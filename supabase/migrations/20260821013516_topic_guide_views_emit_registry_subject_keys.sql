begin;

create or replace view public.topic_point_briefs
with (security_invoker = true, security_barrier = true)
as
select
  tpb.topic_point_brief_id as id,
  coalesce(registry_subject.subject_key, tpb.subject_key) as subject_key,
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
    + split_part(tpb.topic_code, '.', 2)::integer as topic_sort_key,
  tpb.subject_key as canonical_subject_key
from app.topic_point_briefs tpb
left join lateral (
  select s.subject_key
  from app.subjects s
  where app.normalize_student_subject_key(s.subject_key) = tpb.subject_key
    and s.status = 'active'
  order by s.created_at nulls last, s.subject_key
  limit 1
) registry_subject on true
where tpb.status = 'published';

create or replace view public.topic_explainers
with (security_invoker = true, security_barrier = true)
as
select
  te.topic_explainer_id as id,
  coalesce(registry_subject.subject_key, te.subject_key) as subject_key,
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
    + split_part(te.topic_code, '.', 2)::integer as topic_sort_key,
  te.subject_key as canonical_subject_key
from app.topic_explainers te
left join lateral (
  select s.subject_key
  from app.subjects s
  where app.normalize_student_subject_key(s.subject_key) = te.subject_key
    and s.status = 'active'
  order by s.created_at nulls last, s.subject_key
  limit 1
) registry_subject on true
where te.status = 'published';

revoke all on public.topic_point_briefs
  from public, anon, authenticated, service_role;
revoke all on public.topic_explainers
  from public, anon, authenticated, service_role;
grant select on public.topic_point_briefs to authenticated, service_role;
grant select on public.topic_explainers to authenticated, service_role;

comment on view public.topic_point_briefs is
  'Authenticated Lovable-facing read view for published topic point briefs. subject_key is the student-facing registry key; canonical_subject_key is the app content key.';
comment on view public.topic_explainers is
  'Authenticated Lovable-facing read view for published topic explainers. subject_key is the student-facing registry key; canonical_subject_key is the app content key.';
comment on column public.topic_point_briefs.canonical_subject_key is
  'Canonical app content key stored on app.topic_point_briefs, for example ap_biology.';
comment on column public.topic_explainers.canonical_subject_key is
  'Canonical app content key stored on app.topic_explainers, for example ap_biology.';

commit;
