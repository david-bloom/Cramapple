begin;

-- Fix the learning-session leak.
--
-- SYMPTOM: 20 of the 26 learning sessions ever created on Production were
-- still status='active', the oldest from 2026-07-09. Because
-- public.set_active_exam_pack_version refuses to switch subjects while any
-- active session exists on the profile's current exam pack version, the
-- pilot account became permanently unable to change subjects
-- (active_session_blocks_subject_switch).
--
-- ROOT CAUSE: nothing server-side ever ends a session.
--   1. app.start_home_learning_session_for_user reuses an existing active
--      session (entry_path='recommend'), so it does not duplicate -- but the
--      frontend also creates sessions directly with its own entry_path
--      values ('recommendation', 'self_guided_format', 'check_work'), and
--      that path has no reuse or dedup logic.
--   2. Termination is entirely client-driven. public.end_active_learning_session
--      must be called by the client and closes only the single most recent
--      active session on the current pack, so a user who closes the tab
--      leaks a session permanently, and a backlog can never be cleared
--      through the UI at all.
--   3. available_minutes (5-90) is recorded on every row but never enforced;
--      no process marks a session finished when its budget elapses.
--
-- FIX (three parts):
--   A. app.sweep_learning_sessions() -- server-side reaper that archives
--      sessions whose declared time budget plus a grace period has elapsed.
--      Modeled on the existing app.sweep_session_targets() pattern.
--   B. public.end_active_learning_session() now ends EVERY active session on
--      the caller's current pack, not just the most recent one, so a backlog
--      is self-clearing from the UI.
--   C. Reclassify already-swept sessions from 'completed' to 'archived' so
--      reaped sessions are not counted as genuine student completions.
--
-- NOTE ON SCHEDULING: pg_cron is not installed on this project, so
-- app.sweep_learning_sessions() has no in-database schedule. It must be
-- invoked by an external caller (edge function / scheduled job), exactly as
-- app.sweep_session_targets() is. Until that caller exists, part B is what
-- keeps the UI unblocked. This is a deliberate, documented gap.

-- ---------------------------------------------------------------------------
-- A. Server-side session reaper
-- ---------------------------------------------------------------------------

create or replace function app.sweep_learning_sessions(
  _grace_minutes integer default 120
)
returns jsonb
language plpgsql
set search_path = pg_catalog
as $$
declare
  v_archived integer;
begin
  if _grace_minutes < 0 then
    raise exception 'sweep_learning_sessions:invalid_grace' using errcode = '22023';
  end if;

  -- A session is reapable once its own declared budget has elapsed plus a
  -- grace window. available_minutes is constrained to 5-90 at creation;
  -- coalesce guards rows that predate that column being populated.
  update app.learning_sessions
  set status = 'archived',
      ended_at = coalesce(ended_at, now()),
      updated_at = now()
  where status = 'active'
    and started_at
        + make_interval(mins => coalesce(available_minutes, 90))
        + make_interval(mins => _grace_minutes)
        < now();
  get diagnostics v_archived = row_count;

  return jsonb_build_object(
    'archived', v_archived,
    'grace_minutes', _grace_minutes,
    'swept_at', now()
  );
end;
$$;

revoke all on function app.sweep_learning_sessions(integer) from public, anon, authenticated;
grant execute on function app.sweep_learning_sessions(integer) to service_role;

comment on function app.sweep_learning_sessions(integer) is
  'Archives learning sessions whose available_minutes budget plus a grace window has elapsed. Counterpart to app.sweep_session_targets(). Requires an external scheduler; pg_cron is not installed.';

-- ---------------------------------------------------------------------------
-- B. End ALL active sessions on the current pack, not just the newest
-- ---------------------------------------------------------------------------

create or replace function public.end_active_learning_session()
returns uuid
language plpgsql
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_active_exam_pack_version_id uuid;
  v_session_id uuid;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select p.active_exam_pack_version_id
    into v_active_exam_pack_version_id
  from app.profiles p
  where p.user_id = v_user_id;

  if v_active_exam_pack_version_id is null then
    raise exception 'no_active_subject' using errcode = '22023';
  end if;

  -- Identify the newest active session first; it is the one whose id we
  -- return, preserving the previous contract for existing callers.
  select ls.id
    into v_session_id
  from app.learning_sessions ls
  where ls.user_id = v_user_id
    and ls.exam_pack_version_id = v_active_exam_pack_version_id
    and ls.status = 'active'
  order by ls.started_at desc
  limit 1;

  if v_session_id is null then
    raise exception 'active_session_not_found' using errcode = 'P0002';
  end if;

  -- Close every active session on this pack, not only the newest. Prior
  -- behaviour closed one per call, which made an accumulated backlog
  -- impossible to clear through the UI.
  update app.learning_sessions
  set status = 'completed',
      ended_at = coalesce(ended_at, now()),
      updated_at = now()
  where user_id = v_user_id
    and exam_pack_version_id = v_active_exam_pack_version_id
    and status = 'active';

  return v_session_id;
end;
$$;

revoke all on function public.end_active_learning_session() from public, anon;
grant execute on function public.end_active_learning_session() to authenticated, service_role;

comment on function public.end_active_learning_session() is
  'Ends every active learning session on the caller''s current exam pack version and returns the id of the most recent one. Closing all of them prevents an unclearable backlog from blocking set_active_exam_pack_version.';

-- ---------------------------------------------------------------------------
-- C. Reclassify reaped sessions as archived, not completed
-- ---------------------------------------------------------------------------

-- The 2026-08-21 unblock pass closed a stale backlog as 'completed' to
-- restore subject switching. Those were reaped, not finished by the student;
-- leaving them as 'completed' would overstate genuine completions. Only rows
-- that were already stale by this migration's own sweep rule are touched.
update app.learning_sessions
set status = 'archived',
    updated_at = now()
where status = 'completed'
  and ended_at::date = date '2026-08-21'
  and started_at
      + make_interval(mins => coalesce(available_minutes, 90))
      + make_interval(mins => 120)
      < ended_at;

commit;
