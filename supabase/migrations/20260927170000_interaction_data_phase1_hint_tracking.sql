-- STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md Phase 1, items 1-2 only.
-- Hard-gated on DECISION-0074's hint-definition-boundary addendum (DECISION-0080):
-- the four gated aids in the architecture (Rubric preview, Points earned/lost,
-- Deep Dive, Reference Materials) count as disqualifying pre-submission hint use.
-- "Elimination" (the MCQ-only bonus gate) is intentionally NOT one of "the four" --
-- logged as a candidate event but non-disqualifying by policy until decided
-- explicitly, per the plan's "log the superset, gate on a policy boolean" design.
--
-- Phase 1 items 3-6 (active time, student confidence, retry reason, recommendation
-- provenance) are NOT part of this migration -- unblocked separately, not gated on
-- DECISION-0080, and deliberately left for their own pass.
--
-- Does NOT wire any application code: evaluate-attempt/index.ts still needs to derive
-- attempts.assistance_state from this table instead of trusting the client, and
-- _shared/cell-state.ts still needs to populate the new student_cell_state mastery
-- counters. SessionFrame emits zero events into this table until the separately
-- approved Workstream B1 rebuild ships. This migration only makes the schema exist.

-- ---------------------------------------------------------------------------
-- 1. Policy config table -- decouples "which events exist" (CHECK'd, stable)
--    from "which events currently disqualify mastery" (a data row, cheap to
--    change later without a migration).
-- ---------------------------------------------------------------------------
create table app.assistance_event_policy (
  event_kind text not null check (event_kind in (
    'rubric_preview',
    'points_earned_lost',
    'deep_dive',
    'reference_materials',
    'elimination'
  )),
  disqualifies_mastery boolean not null,
  effective_from timestamptz not null default now(),
  created_at timestamptz not null default now(),
  primary key (event_kind, effective_from)
);

alter table app.assistance_event_policy enable row level security;
-- No policies: this is a service-managed config table, not client-writable or
-- client-readable directly. The write-derivation trigger below reads it as
-- SECURITY DEFINER, bypassing RLS regardless of the inserting role.
grant select on app.assistance_event_policy to service_role;

comment on table app.assistance_event_policy is
  'DECISION-0080: which attempt_assistance_events.event_kind values currently '
  'disqualify mastery under DECISION-0074''s "no hint use before submission" rule. '
  'A future policy change is a row insert here (new effective_from), not a schema migration.';

insert into app.assistance_event_policy (event_kind, disqualifies_mastery, effective_from) values
  ('rubric_preview',       true,  '2026-09-27T00:00:00Z'),
  ('points_earned_lost',   true,  '2026-09-27T00:00:00Z'),
  ('deep_dive',            true,  '2026-09-27T00:00:00Z'),
  ('reference_materials',  true,  '2026-09-27T00:00:00Z'),
  ('elimination',          false, '2026-09-27T00:00:00Z'); -- DECISION-0080: not one of "the four", undecided -- logged, non-disqualifying by default

-- ---------------------------------------------------------------------------
-- 2. Per-event log
-- ---------------------------------------------------------------------------
create table app.attempt_assistance_events (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references app.attempts(id) on delete cascade,
  event_kind text not null check (event_kind in (
    'rubric_preview',
    'points_earned_lost',
    'deep_dive',
    'reference_materials',
    'elimination'
  )),
  source text not null check (source in ('session_frame', 'practice_mcq', 'practice_frq')),
  occurred_at timestamptz not null default now(),
  -- Derived at write time by trg_set_assistance_event_derived_fields, not
  -- client-supplied -- see that function for why (client-trust was exactly
  -- the bug assistance_state has today).
  relative_to_submission text check (relative_to_submission in ('before', 'after')),
  hint_ordinal int,
  counts_toward_hint_rule boolean,
  created_at timestamptz not null default now()
);

alter table app.attempt_assistance_events enable row level security;

create policy attempt_assistance_events_owner_select
  on app.attempt_assistance_events
  for select
  to authenticated
  using (exists (
    select 1 from app.attempts a
    where a.id = attempt_assistance_events.attempt_id
      and a.user_id = auth.uid()
  ));

create policy attempt_assistance_events_owner_insert
  on app.attempt_assistance_events
  for insert
  to authenticated
  with check (exists (
    select 1 from app.attempts a
    where a.id = attempt_assistance_events.attempt_id
      and a.user_id = auth.uid()
  ));

-- Append-only by design (matches attempt_criterion_results' pattern): no
-- update/delete policy for `authenticated`. service_role bypasses RLS as usual.

comment on table app.attempt_assistance_events is
  'One row per open of a gated aid (STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md '
  'Phase 1 item 1). relative_to_submission/hint_ordinal/counts_toward_hint_rule are '
  'derived server-side at insert, never client-supplied.';

-- ---------------------------------------------------------------------------
-- 3. Write-time derivation (SECURITY DEFINER: needs to read the policy table
--    and the parent attempt regardless of the inserting role's own RLS grants)
-- ---------------------------------------------------------------------------
create or replace function app.set_assistance_event_derived_fields()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, app
as $$
declare
  v_submitted_at timestamptz;
  v_disqualifies boolean;
begin
  select submitted_at into v_submitted_at
  from app.attempts
  where id = new.attempt_id;

  new.relative_to_submission := case
    when v_submitted_at is null or new.occurred_at < v_submitted_at then 'before'
    else 'after'
  end;

  new.hint_ordinal := (
    select count(*) + 1
    from app.attempt_assistance_events
    where attempt_id = new.attempt_id
  );

  select disqualifies_mastery into v_disqualifies
  from app.assistance_event_policy
  where event_kind = new.event_kind
    and effective_from <= new.occurred_at
  order by effective_from desc
  limit 1;

  new.counts_toward_hint_rule := (new.relative_to_submission = 'before')
    and coalesce(v_disqualifies, true); -- fail safe: an unrecognized/future event_kind counts against mastery until policy says otherwise

  return new;
end;
$$;

create trigger trg_set_assistance_event_derived_fields
  before insert on app.attempt_assistance_events
  for each row
  execute function app.set_assistance_event_derived_fields();

-- ---------------------------------------------------------------------------
-- 4. Roll up onto attempts (denormalized read-model, per the plan)
-- ---------------------------------------------------------------------------
alter table app.attempts
  add column pre_submit_hint_count int not null default 0;

comment on column app.attempts.pre_submit_hint_count is
  'Denormalized count of attempt_assistance_events rows for this attempt where '
  'counts_toward_hint_rule is true. Maintained by trg_rollup_pre_submit_hint_count. '
  'Does NOT yet drive attempts.assistance_state -- evaluate-attempt/index.ts still '
  'trusts the client for that column (STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md '
  'Phase 1 item 1 calls this out as separate follow-up work).';

create or replace function app.rollup_pre_submit_hint_count()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, app
as $$
begin
  if new.counts_toward_hint_rule then
    update app.attempts
    set pre_submit_hint_count = pre_submit_hint_count + 1
    where id = new.attempt_id;
  end if;
  return new;
end;
$$;

create trigger trg_rollup_pre_submit_hint_count
  after insert on app.attempt_assistance_events
  for each row
  execute function app.rollup_pre_submit_hint_count();

-- ---------------------------------------------------------------------------
-- 5. Item-type-mix mastery counters on student_cell_state (Phase 1 item 2)
--    Additive only -- nothing populates these yet. Counting logic ("only when
--    pre_submit_hint_count = 0") belongs in _shared/cell-state.ts, not here.
-- ---------------------------------------------------------------------------
alter table app.student_cell_state
  add column mastery_mcq_correct_count int not null default 0,
  add column mastery_frq_full_count int not null default 0,
  add column mastery_reached_at timestamptz;

comment on column app.student_cell_state.mastery_mcq_correct_count is
  'DECISION-0074: count of correct MCQ answers on this cell with pre_submit_hint_count = 0. '
  'Column only -- not yet populated by any write path.';
comment on column app.student_cell_state.mastery_frq_full_count is
  'DECISION-0074: count of full-point FRQ answers on this cell with pre_submit_hint_count = 0. '
  'Column only -- not yet populated by any write path.';
comment on column app.student_cell_state.mastery_reached_at is
  'Set once mastery_mcq_correct_count >= 2 and mastery_frq_full_count >= 1. Column only.';

-- ---------------------------------------------------------------------------
-- 6. Indexes (Amendment 1: ship with the DDL, not a follow-up)
-- ---------------------------------------------------------------------------
create index attempt_assistance_events_attempt_occurred_idx
  on app.attempt_assistance_events (attempt_id, occurred_at);

create index attempt_assistance_events_before_submission_idx
  on app.attempt_assistance_events (attempt_id)
  where relative_to_submission = 'before';
