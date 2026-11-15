select json_agg(t order by subject_key, unit_number, split_part(topic_code,'.',2)::int) as j from (
select te.subject_key, te.unit_number, te.topic_code, te.answer_move, te.common_point_loss,
 (select coalesce(json_agg(h.hook_text order by h.created_at),'[]'::json) from app.topic_memory_hooks h join app.unit_reference_entries r using(reference_entry_id)
   where r.subject_key=te.subject_key and r.status='published' and h.status='published' and te.topic_code=any(r.topic_codes)) as hooks,
 md5(te.answer_move||'|'||te.common_point_loss) as h
from app.topic_explainers te
where te.status='published' and te.quick_take is null and (
 (te.subject_key='ap_biology' and te.unit_number between 6 and 8) or (te.subject_key='ap_chemistry' and te.unit_number between 6 and 9)
 or te.subject_key in ('ap_calculus_ab','ap_calculus_bc','ap_physics_1','ap_precalculus'))) t;
