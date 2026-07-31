-- Keep the narrowly scoped RLS-bypass helper and session constructor on the
-- server side only. Authenticated browser requests enter through a
-- requireSupabaseAuth server function, which supplies its verified user id to
-- the service-role-only RPC.

revoke execute on function app.home_exam_pack_is_eligible(uuid)
  from authenticated;
revoke execute on function app.start_home_learning_session_for_user(
  uuid, integer, text
) from authenticated;

drop function if exists public.start_home_learning_session(integer, text);

revoke all on function app.home_exam_pack_is_eligible(uuid)
  from public, anon, authenticated;
grant execute on function app.home_exam_pack_is_eligible(uuid)
  to service_role;

revoke all on function app.start_home_learning_session_for_user(
  uuid, integer, text
) from public, anon, authenticated;
grant execute on function app.start_home_learning_session_for_user(
  uuid, integer, text
) to service_role;
