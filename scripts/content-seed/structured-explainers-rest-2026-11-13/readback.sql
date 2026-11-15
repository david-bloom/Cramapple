select subject_key||'|'||topic_code k, md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer) h
from app.topic_explainers where status='published' and subject_key in ('ap_biology','ap_chemistry','ap_calculus_ab','ap_calculus_bc','ap_physics_1','ap_precalculus');
