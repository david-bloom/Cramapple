select coalesce(json_agg(x),'[]') as rows from (with params as (select 'ap_calculus_ab'::text bkey, 'ap-calculus-ab'::text rkey),
taught as (
  select t.topic_code
  from app.open_hand_teaching_items t
  join app.content_items ci on ci.id = t.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id, params
  where t.released_at is null and s.subject_key = params.rkey),
seeds as (
  select distinct on (c.topic_code) c.topic_code, civ.stem,
    (select json_agg(json_build_object('k', m.choice_key, 't', m.choice_text, 'ok', m.is_correct) order by m.choice_key)
       from app.mcq_choices m where m.content_item_version_id = civ.id) choices
  from app.content_item_cells c
  join app.content_items ci on ci.id = c.content_item_id
  join app.content_item_versions civ on civ.id = c.content_item_version_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id, params
  where s.subject_key = params.rkey and ci.item_type = 'mcq' and ci.status = 'published'
    and c.is_primary and c.superseded_by is null
  order by c.topic_code, civ.published_at desc nulls last)
select b.unit_number, b.topic_code, b.title, b.what_it_is, b.how_points_are_earned, b.answer_move,
       b.common_point_loss, e.core_idea, e.what_students_need_to_understand, e.mini_example_question,
       e.common_point_loss as explainer_point_loss,
       case when sd.topic_code is null then null else json_build_object('stem', sd.stem, 'choices', sd.choices) end as seed
from app.topic_point_briefs b cross join params
left join app.topic_explainers e on e.subject_key = b.subject_key and e.topic_code = b.topic_code and e.status = 'published'
left join seeds sd on sd.topic_code = b.topic_code
where b.subject_key = params.bkey and b.status = 'published'
  and b.topic_code not in (select topic_code from taught)
  and b.topic_code in ('1.3','1.9','1.12','1.14','1.15','2.3')
order by b.unit_number, string_to_array(b.topic_code, '.')::int[]) x;