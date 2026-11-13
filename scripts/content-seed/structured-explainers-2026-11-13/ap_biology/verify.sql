select json_agg(t order by t.unit_number, split_part(t.topic_code,'.',2)::int) as j from (
select unit_number, topic_code, md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer) as h,
 (source_note like '%Structured 2026-11-13 (recommendation #3%') as noted
from app.topic_explainers where subject_key='ap_biology' and status='published' and unit_number between 1 and 5) t;
