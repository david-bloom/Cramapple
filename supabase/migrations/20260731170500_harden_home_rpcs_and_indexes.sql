-- Run student-owned mutations as the authenticated caller so RLS remains the
-- final authorization boundary. Add only the grants/policies those narrow RPCs
-- require, plus advisor-recommended foreign-key indexes.

begin;

alter function app.exam_pack_version_is_selectable(uuid) security invoker;
grant execute on function app.exam_pack_version_is_selectable(uuid)
  to authenticated, service_role;

alter function public.set_active_exam_pack_version(uuid) security invoker;
alter function public.complete_onboarding(uuid) security invoker;
alter function public.dismiss_first_run() security invoker;
alter function public.end_active_learning_session() security invoker;
alter function public.set_course_position(integer, text) security invoker;

create policy "student_course_positions_insert_own"
on app.student_course_positions
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "student_course_positions_update_own"
on app.student_course_positions
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

grant insert, update on app.student_course_positions to authenticated;

create index feature_flag_assignments_user_id_idx
  on app.feature_flag_assignments (user_id);

create index feature_flag_assignments_assigned_by_idx
  on app.feature_flag_assignments (assigned_by)
  where assigned_by is not null;

create index home_release_manifest_updated_by_idx
  on app.home_release_manifest (updated_by)
  where updated_by is not null;

create index student_course_positions_exam_pack_version_idx
  on app.student_course_positions (exam_pack_version_id);

commit;
