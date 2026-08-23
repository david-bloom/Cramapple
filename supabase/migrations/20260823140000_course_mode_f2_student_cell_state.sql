-- Course Mode F2 — cell mastery store (student_cell_state).
--
-- Per-(user x cell) proficiency state for the year-long "efficient learn" loop.
-- Additive to app.*; the legacy subject-grain app.student_memory_snapshots is
-- untouched (that is coaching/session memory, NOT a proficiency map -- see
-- COURSE_MODE_LEARNING_MODEL.md §8). Cell = (topic x skill), CM-D05.
--
-- Grain + invariants:
--  - one row per (user, taxonomy_source_version, topic_code, skill_code);
--  - composite FK to app.taxonomy_cells so state can only exist for a REGISTERED
--    cell of that taxonomy version (INV: no phantom cells; keyed by UUID version,
--    never raw subject_key -- the hyphen/underscore namespace trap);
--  - tier is a discrete ladder (CM-D06), never a percentage; `fragile` is the
--    INV-6 flag (a later miss reopens the estimate without zeroing the tier);
--  - deterministic transitions only (INV-4) -- the classifier + rule engine live
--    in supabase/functions/_shared/cell-state.ts, this table just stores results.
--
-- RLS: service_role only. Raw cell state is fine-grained and skill-coded; per
-- INV-1 ("store fine, present coarse; never surface letter codes to students")
-- the student-facing view is a coarse roll-up served later via functions, not
-- this table. No authenticated grant.

create table if not exists app.student_cell_state (
  student_cell_state_id uuid primary key default gen_random_uuid(),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  subject_id uuid not null references app.subjects(id) on delete restrict,
  taxonomy_source_version uuid not null
    references app.taxonomy_source_versions(taxonomy_source_version) on delete restrict,
  topic_code text not null,
  skill_code text not null,

  tier text not null default 'unseen'
    check (tier in ('unseen','exposed_unverified','supported','independent','confirmed')),
  fragile boolean not null default false,
  weighted_evidence numeric not null default 0,

  last_independent_success_at timestamptz,
  last_attempt_at timestamptz,
  next_due_at timestamptz,
  due_reason text
    check (due_reason is null or due_reason in
      ('decay','direct_miss','provisional_confirm','new_exposure')),

  -- provenance of the last transition, for auditability / debugging (INV-4 means
  -- every transition is explainable): the rule-engine event + weight that produced
  -- the current row, and the schema version of the rule engine.
  last_event text,
  last_weight numeric,
  rule_engine_version text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique (user_id, taxonomy_source_version, topic_code, skill_code),
  foreign key (taxonomy_source_version, topic_code, skill_code)
    references app.taxonomy_cells (taxonomy_source_version, topic_code, skill_code)
    on delete restrict
);

comment on table app.student_cell_state is
  'F2: per-(user x cell=(topic x skill)) proficiency state for Course Mode. Tier ladder '
  '(CM-D06), fragile flag (INV-6), weighted_evidence (CM-D07), decay/next_due_at (CM-D08). '
  'Deterministic transitions only (INV-4) -- written by _shared/cell-state.ts. Distinct from '
  'the subject-grain app.student_memory_snapshots (coaching memory). Service_role only; '
  'student-facing roll-ups are served coarse via functions (INV-1).';

alter table app.student_cell_state enable row level security;
grant select, insert, update, delete on app.student_cell_state to service_role;

-- The spaced-retrieval due-queue selection (CM-D11: "cells due now, ordered by
-- priority"): one row per cell, look up by user + due time.
create index if not exists student_cell_state_due_idx
  on app.student_cell_state using btree (user_id, next_due_at)
  where next_due_at is not null;
create index if not exists student_cell_state_cell_idx
  on app.student_cell_state using btree (taxonomy_source_version, topic_code, skill_code);
