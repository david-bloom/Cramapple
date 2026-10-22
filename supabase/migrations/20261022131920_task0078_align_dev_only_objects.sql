-- TASK-0078 ruling 6 (David, 2026-10-22): align Development to Production.
-- Bucket: Development-only objects.
-- public.scc_rehearsal_chunks_20261006 is rehearsal scratch from 2026-10-06 (6 rows, no dependent
-- views, absent from Production and from every migration on main).
-- app.review_decisions: Production has one policy (deny_authenticated_all) and table grants to
-- service_role only; Development's own baseline left two owner policies plus authenticated
-- INSERT/SELECT grants. Frozen review area (ruling 1); the table is empty on Development.
-- Idempotent.
drop table if exists public.scc_rehearsal_chunks_20261006;

drop policy if exists review_decisions_insert_own on app.review_decisions;
drop policy if exists review_decisions_select_own on app.review_decisions;
drop policy if exists deny_authenticated_all on app.review_decisions;
create policy deny_authenticated_all on app.review_decisions
  as permissive for all to authenticated using (false) with check (false);
revoke insert, select on app.review_decisions from authenticated;
