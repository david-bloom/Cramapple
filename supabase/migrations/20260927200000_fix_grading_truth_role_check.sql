-- app.attempts_prevent_client_grading_truth_update (the trigger guarding
-- score_points/score_possible/graded_at/confidence_level/result_state/
-- result_summary and the draft/submitted -> graded/uncertain status
-- transition) checked current_setting('request.jwt.claim.role', true) --
-- a deprecated, per-claim PostgREST compatibility GUC this project's current
-- PostgREST version no longer populates for ANY caller, service-role JWT or
-- not. Confirmed empirically 2026-09-27 (a throwaway Dev/Prod diagnostic
-- function, deployed and deleted the same session): a genuinely valid,
-- correctly-scoped, unexpired service_role JWT still resolved
-- request.jwt.claim.role to null, while current_setting('role', true) --
-- the actual Postgres role PostgREST SET ROLE's to for the request --
-- correctly read 'service_role'. This is why evaluate-attempt's
-- attempts.update() has apparently never once succeeded in Production
-- (STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md's IDG-5): the trigger
-- was checking a GUC that was never going to be true for anyone, not a
-- key-format problem.
--
-- Fix: check the actual session role instead of the deprecated per-claim
-- GUC. coalesce(...,'') preserves the original's fail-closed posture --
-- an unset/null role setting must still be treated as "not service_role",
-- never silently pass through.
create or replace function app.prevent_client_grading_truth_update()
returns trigger
language plpgsql
set search_path to 'app', 'pg_catalog'
as $function$
begin
  if coalesce(current_setting('role', true), '') <> 'service_role' then
    if new.score_points is distinct from old.score_points
      or new.score_possible is distinct from old.score_possible
      or new.graded_at is distinct from old.graded_at
      or new.confidence_level is distinct from old.confidence_level
      or new.result_state is distinct from old.result_state
      or new.result_summary is distinct from old.result_summary
      or (
        old.status not in ('graded', 'uncertain')
        and new.status in ('graded', 'uncertain')
      )
    then
      raise exception 'grading truth is service-side only';
    end if;
  end if;

  return new;
end;
$function$;
