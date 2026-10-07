-- 2026-10-07 — Assistance events: a write path for the plate loop, plus the topic hint as a kind.
--
-- Applied via the Supabase MCP `apply_migration`: Dev (wmgjsdkphcyhngaffbqf) as version
-- 20261007180947, Production (pcntajvbdfqhbeewmdry) as version 20261007181153. This file is named
-- after the Production version. Approved by the Product Owner in chat ("approved, run it Dev then
-- Production"), 2026-10-07; see APPROVALS_LOG and
-- docs/product/STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md (W9).
--
-- Why: `app.attempt_assistance_events` (migration 20260927170000, DECISION-0080) is the designed
-- source of truth for "hint use before submission", and `evaluate-attempt` derives
-- `attempts.assistance_state` / `pre_submit_hint_count` from it. Nothing had ever written to it:
-- there was no public view and no edge-function operation, so every Production attempt read
-- `independent` with a hint count of 0.
--
-- What this does:
--   1. Adds 'topic_hint' as an event kind. The Practice MCQ "Give me a hint" shows the topic's
--      authored answer move before the student commits. It is recorded as disqualifying for
--      mastery, like the four aids in DECISION-0080; the Product Owner can flip that with a
--      policy row insert, never a migration.
--   2. Exposes `public.attempt_assistance_events` as a security_invoker view with INSERT and
--      SELECT for `authenticated`. The base table's RLS (own attempts only) and the two
--      INSERT triggers (derived fields, hint-count rollup) apply unchanged. The client supplies
--      only attempt_id, event_kind, source and occurred_at.
--
-- Rehearsed on Dev before Production: an insert through the view on a real attempt derived
-- relative_to_submission / hint_ordinal / counts_toward_hint_rule and incremented
-- attempts.pre_submit_hint_count; rows then deleted and the count reset.
--
-- Safe to re-run.

-- 1. topic_hint ---------------------------------------------------------------
do $$
declare r record;
begin
  for r in
    select c.conname, c.conrelid::regclass as rel
    from pg_constraint c
    where c.contype = 'c'
      and c.conrelid in ('app.assistance_event_policy'::regclass, 'app.attempt_assistance_events'::regclass)
      and pg_get_constraintdef(c.oid) ilike '%event_kind%'
  loop
    execute format('alter table %s drop constraint %I', r.rel, r.conname);
  end loop;
end $$;

alter table app.assistance_event_policy
  add constraint assistance_event_policy_event_kind_check check (event_kind in (
    'rubric_preview', 'points_earned_lost', 'deep_dive', 'reference_materials', 'elimination', 'topic_hint'
  ));

alter table app.attempt_assistance_events
  add constraint attempt_assistance_events_event_kind_check check (event_kind in (
    'rubric_preview', 'points_earned_lost', 'deep_dive', 'reference_materials', 'elimination', 'topic_hint'
  ));

insert into app.assistance_event_policy (event_kind, disqualifies_mastery, effective_from)
values ('topic_hint', true, '2026-10-07T00:00:00Z')
on conflict (event_kind, effective_from) do nothing;

-- 2. public write/read surface ------------------------------------------------
grant usage on schema app to authenticated;
grant select, insert on app.attempt_assistance_events to authenticated;

create or replace view public.attempt_assistance_events
  with (security_invoker = true, security_barrier = true) as
  select id, attempt_id, event_kind, source, occurred_at,
         relative_to_submission, hint_ordinal, counts_toward_hint_rule, created_at
  from app.attempt_assistance_events;

grant select, insert on public.attempt_assistance_events to authenticated;

comment on view public.attempt_assistance_events is
  'Student-facing surface for app.attempt_assistance_events. INSERT only attempt_id, event_kind, '
  'source, occurred_at; relative_to_submission / hint_ordinal / counts_toward_hint_rule are set by '
  'the base table''s trigger and must not be supplied. RLS on the base table limits rows to the '
  'signed-in student''s own attempts.';
