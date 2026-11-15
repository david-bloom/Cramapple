select subject_key, topic_code, core_idea, what_students_need_to_understand, how_this_becomes_points, point_attaining_answer, mini_example_question, weak_answer, quick_take
from app.topic_explainers where status='published' and subject_key in ('ap_calculus_ab','ap_calculus_bc') and unit_number between 4 and 6 order by 1,2;
