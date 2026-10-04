-- APPROVAL-0120: expose the topic-level columns through public.student_course_positions.
--
-- 20260927211703_student_course_positions_topic_level.sql added topic_code and
-- topic_source to app.student_course_positions but did not recreate the public
-- view, which still listed the original six columns. The student home asks the
-- API for the two new columns, so every subject load returned HTTP 400
-- ("We couldn't load your home right now").
--
-- The view keeps its existing options and grants. security_invoker means the
-- underlying table's row-level security still decides which rows a student
-- sees. New columns go at the end so create or replace view is legal.

create or replace view public.student_course_positions
with (security_invoker = true, security_barrier = true)
as
select
  p.user_id,
  p.exam_pack_version_id,
  p.unit_id,
  p.source,
  p.created_at,
  p.updated_at,
  p.topic_code,
  p.topic_source
from app.student_course_positions p;
