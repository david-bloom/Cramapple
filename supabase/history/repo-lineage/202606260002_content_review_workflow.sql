-- Content review workflow: assignments and immutable decisions.
--
-- Creates two tables for the UX-002 tutor and AP Reader review pipeline:
--
--   app.content_review_assignments  — one row per reviewer per item / stage
--   app.content_review_decisions    — one immutable row per submission attempt
--
-- Design notes:
--   - Separate from the student-practice pipeline (app.attempts et al.).
--   - Separate from the full artifact-governance model introduced in
--     migration 202606200006 (app.review_assignments, app.review_decisions).
--     Do not conflate these pipelines.
--   - Each review stage (tutor_question, tutor_answer, tutor_frq_canonical,
--     reader_question) gets its own assignment row and its own decision row.
--     MCQ answer review generates one assignment per answer option (A–D) per
--     tutor, not one assignment with a JSONB blob of four approvals.
--   - Decisions are append-only. To supersede a prior decision, insert a new
--     row with supersedes_id pointing to the original. Never update in place.
--   - Immutability is enforced by a BEFORE UPDATE/DELETE trigger in addition
--     to the absence of an UPDATE RLS policy, because RLS alone does not
--     protect against service_role writes.

begin;

-- Drop tables created by 202606230003 (content_intake_and_review_workflow) if
-- that migration already ran. This migration supersedes those definitions with
-- the correct FKs (→ content_item_versions) and immutability trigger.
drop table if exists app.content_review_decisions cascade;
drop table if exists app.content_review_assignments cascade;

-- ── app.content_review_assignments ───────────────────────────────────────────
-- Queue item: which reviewer is assigned to which content version and stage.

create table app.content_review_assignments (
  id                      uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,
  reviewer_id             uuid not null
    references app.profiles(user_id) on delete cascade,

  -- Stage discriminator. Keep one assignment per reviewer per version per stage.
  review_stage            text not null,

  -- blind_group_id is a bare UUID used as a correlation key.
  -- The two independent tutor assignments for the same content version and
  -- stage share the same value. No foreign key — intentionally lightweight.
  -- Neither tutor can see the other's assignment or decision while this group
  -- is open.
  blind_group_id          uuid,

  status                  text not null default 'pending',
  assigned_at             timestamptz not null default now(),
  due_at                  timestamptz,
  created_at              timestamptz not null default now(),
  created_by              uuid references app.profiles(user_id),

  constraint cra_stage_check check (review_stage in (
    'tutor_question',
    'tutor_answer',
    'tutor_frq_canonical',
    'reader_question'
  )),
  constraint cra_status_check check (status in (
    'pending',
    'in_progress',
    'submitted',
    'skipped'
  )),

  -- One active assignment per reviewer per version per stage.
  constraint cra_unique_active_assignment
    unique (content_item_version_id, reviewer_id, review_stage)
);

create index cra_reviewer_status_idx
  on app.content_review_assignments (reviewer_id, status);

create index cra_version_stage_idx
  on app.content_review_assignments (content_item_version_id, review_stage);

create index cra_blind_group_idx
  on app.content_review_assignments (blind_group_id)
  where blind_group_id is not null;

alter table app.content_review_assignments enable row level security;

create policy "cra_reviewer_select_own"
  on app.content_review_assignments
  for select to authenticated
  using (reviewer_id = auth.uid());

-- Service role manages assignment creation and status updates.
create policy "cra_service_all"
  on app.content_review_assignments
  for all to service_role
  using (true) with check (true);


-- ── app.content_review_decisions ─────────────────────────────────────────────
-- Immutable submission: one row per submission attempt per reviewer per stage.

create table app.content_review_decisions (
  id                      uuid primary key default gen_random_uuid(),

  -- References
  assignment_id           uuid not null
    references app.content_review_assignments(id) on delete cascade,
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,
  reviewer_id             uuid not null
    references app.profiles(user_id) on delete cascade,

  -- Points to the prior decision this row supersedes, if any.
  -- The original row is never modified; this is a linked-list of attempts.
  supersedes_id           uuid
    references app.content_review_decisions(id) on delete set null,

  -- Stage discriminator — must match the parent assignment's review_stage.
  review_stage            text not null,

  -- ── Tutor question fields (review_stage = 'tutor_question') ────────────────
  tutor_score             integer,          -- 1 Yes | 2 Maybe | 3 No
  difficulty_label        text,
  diagnostic_flag         boolean not null default false,
  concern_codes           text[] not null default '{}',
  note                    text,
  -- Modules and subtopics tagged by the tutor during review.
  -- Shape: { "u3": ["3.4", "3.5"], "u7": [] }
  topic_selections        jsonb,

  -- ── Tutor answer fields (review_stage = 'tutor_answer') ────────────────────
  -- One decision row per answer option per reviewer. Use assignment rows to
  -- distinguish which option (A–D) each reviewer is evaluating.
  answer_key              text,             -- 'A' | 'B' | 'C' | 'D'
  answer_approval         text,             -- 'approved' | 'rejected'

  -- ── Tutor FRQ canonical answer fields (review_stage = 'tutor_frq_canonical')
  canonical_decision      text,             -- 'approved' | 'rejected' | 'edited'

  -- ── AP Reader fields (review_stage = 'reader_question') ────────────────────
  reader_decision         text,             -- 'agree' | 'disagree'

  -- ── Full payload for audit ──────────────────────────────────────────────────
  -- The application must populate decision_payload with the complete structured
  -- payload it is submitting, and decision_hash with sha256(payload::text) or
  -- equivalent. These fields allow the audit log to prove exactly what was
  -- submitted and that it has not been altered.
  decision_payload        jsonb not null default '{}'::jsonb,
  decision_hash           text not null,

  -- ── Timestamps and authorship ───────────────────────────────────────────────
  submitted_at            timestamptz not null default now(),
  created_at              timestamptz not null default now(),
  created_by              uuid references app.profiles(user_id),

  -- ── Constraints ────────────────────────────────────────────────────────────
  constraint crd_stage_check check (review_stage in (
    'tutor_question',
    'tutor_answer',
    'tutor_frq_canonical',
    'reader_question'
  )),
  constraint crd_tutor_score_check
    check (tutor_score is null or tutor_score in (1, 2, 3)),
  constraint crd_difficulty_check
    check (difficulty_label is null or difficulty_label in (
      'Easy', 'Moderately easy', 'Medium', 'Hard', 'Very hard'
    )),
  constraint crd_answer_key_check
    check (answer_key is null or answer_key in ('A', 'B', 'C', 'D')),
  constraint crd_answer_approval_check
    check (answer_approval is null or answer_approval in ('approved', 'rejected')),
  constraint crd_canonical_decision_check
    check (canonical_decision is null or canonical_decision in (
      'approved', 'rejected', 'edited'
    )),
  constraint crd_reader_decision_check
    check (reader_decision is null or reader_decision in ('agree', 'disagree'))
);

create index crd_assignment_submitted_idx
  on app.content_review_decisions (assignment_id, submitted_at desc);

create index crd_reviewer_submitted_idx
  on app.content_review_decisions (reviewer_id, submitted_at desc);

create index crd_version_stage_idx
  on app.content_review_decisions (content_item_version_id, review_stage);

create index crd_supersedes_idx
  on app.content_review_decisions (supersedes_id)
  where supersedes_id is not null;

alter table app.content_review_decisions enable row level security;

create policy "crd_reviewer_select_own"
  on app.content_review_decisions
  for select to authenticated
  using (reviewer_id = auth.uid());

-- Reviewers may insert their own decisions only.
-- No UPDATE or DELETE policy for authenticated — decisions are append-only.
-- A new submission must use supersedes_id to link to a prior attempt.
create policy "crd_reviewer_insert_own"
  on app.content_review_decisions
  for insert to authenticated
  with check (reviewer_id = auth.uid());

create policy "crd_service_all"
  on app.content_review_decisions
  for all to service_role
  using (true) with check (true);


-- ── Immutability trigger ──────────────────────────────────────────────────────
-- RLS alone does not protect against service_role writes.
-- This trigger enforces immutability unconditionally for every role.

create or replace function app.prevent_review_decision_mutation()
returns trigger
language plpgsql
as $$
begin
  raise exception
    'content_review_decisions rows are immutable after insert (id: %). '
    'To supersede a decision, insert a new row with supersedes_id referencing '
    'this row.',
    old.id;
end;
$$;

create trigger content_review_decisions_immutable
before update or delete on app.content_review_decisions
for each row execute function app.prevent_review_decision_mutation();


-- ── Grants ────────────────────────────────────────────────────────────────────

grant usage on schema app to authenticated, service_role;

grant select on app.content_review_assignments to authenticated;

grant select, insert on app.content_review_decisions to authenticated;

grant select, insert, update, delete on
  app.content_review_assignments,
  app.content_review_decisions
to service_role;

commit;
