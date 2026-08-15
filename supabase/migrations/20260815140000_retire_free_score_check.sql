-- Retire the activation-limited Free Score Check (TASK-0024), superseded by
-- TASK-0026's 7-day full-access trial (app.start_trial, 20260815120000).
--
-- app.free_score_checks had 0 production rows at retirement time (the offer
-- was never enabled in production -- growth.free_score_check.v1.enabled was
-- false throughout its build). app.authorize_grading_access is rewritten to
-- drop the FSC-specific one-FRQ-cap fallback entirely; every supported access
-- path (beta/paid/trial) is now a subject_entitlements row, so the fallback
-- was dead code for any already-entitled caller and a landmine (referencing
-- a dropped table) for everyone else.

begin;

create or replace function app.authorize_grading_access(
  p_user_id uuid,
  p_attempt_id uuid,
  p_operation text,
  p_request_id text
)
returns text
language plpgsql
security definer
set search_path = app, public
as $$
declare
  v_subject_id uuid;
begin
  select ep.subject_id into v_subject_id
  from app.attempts a
  join app.exam_pack_versions epv on epv.id = a.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where a.id = p_attempt_id and a.user_id = p_user_id;

  if v_subject_id is null then
    raise exception 'grading_access:attempt_not_found';
  end if;

  if exists (
    select 1 from app.subject_entitlements se
    where se.user_id = p_user_id
      and se.subject_id = v_subject_id
      and se.status = 'active'
      and se.starts_at <= now()
      and (se.ends_at is null or se.ends_at > now())
  ) then
    return 'entitled';
  end if;

  raise exception 'grading_access:entitlement_required';
end;
$$;

revoke all on function app.authorize_grading_access(uuid, uuid, text, text) from public, anon, authenticated;
grant execute on function app.authorize_grading_access(uuid, uuid, text, text) to service_role;

drop function if exists app.record_free_score_grade(uuid, uuid);
drop function if exists app.start_free_score_check(uuid, jsonb, jsonb, boolean, text);
drop function if exists app.start_free_score_check(uuid, jsonb, jsonb, boolean, text, text);

drop table if exists app.free_score_checks cascade;

delete from app.config where config_key = 'growth.free_score_check.v1';

commit;
