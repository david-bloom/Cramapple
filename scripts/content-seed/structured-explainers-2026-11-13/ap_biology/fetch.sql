select json_agg(t order by t.unit_number, split_part(t.topic_code,'.',2)::int) as j from (
select subject_key, unit_number, topic_code, core_idea, what_students_need_to_understand, how_this_becomes_points, point_attaining_answer, mini_example_question, weak_answer,
 md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer) as h
from app.topic_explainers where subject_key='ap_biology' and status='published' and unit_number between 1 and 5) t;
