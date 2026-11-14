select topic_code, core_idea, what_students_need_to_understand, how_this_becomes_points, point_attaining_answer, mini_example_question, weak_answer
from app.topic_explainers where status='published' and subject_key='ap_calculus_ab' order by split_part(topic_code,'.',1)::int, split_part(topic_code,'.',2)::int;
