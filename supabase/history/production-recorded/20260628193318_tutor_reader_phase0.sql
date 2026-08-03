-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260628193318
-- recorded name: tutor_reader_phase0
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Phase 0: Tutor / Reader pilot prerequisites.
--
-- 1. Add tutor and reader to the profiles role constraint.
-- 2. Fix content_ingest_rows.review_stage to match content-intake output.
-- 3. Add concern_code controlled vocabulary on content_review_decisions.
-- 4. Add review_status to content_item_versions for the review state machine.
-- 5. Add reviewer-safe SELECT policies on content_item_versions, mcq_choices,
--    and frq_criteria so assigned reviewers can read content through the
--    Supabase client as well as through edge functions.

begin;

-- ── 1. Profiles role constraint ───────────────────────────────────────────────

alter table app.profiles
  drop constraint profiles_role_check;

alter table app.profiles
  add constraint profiles_role_check
    check (role in (
      'student',
      'content_author',
      'tutor',
      'reader',
      'validator',
      'support',
      'admin'
    ));

-- ── 2. content_ingest_rows.review_stage constraint ───────────────────────────
--
-- The old constraint used hyphenated legacy values that content-intake never
-- emits. Replace with the values normalizeReviewStage actually returns.

alter table app.content_ingest_rows
  drop constraint if exists content_ingest_rows_stage_check;

alter table app.content_ingest_rows
  add constraint content_ingest_rows_stage_check
    check (review_stage in (
      'question',
      'answer',
      'canonical_answer',
      'difficulty_discussion'
    ));

-- ── 3. Concern code vocabulary ────────────────────────────────────────────────
--
-- Controlled vocabulary: Accuracy, Ambiguity, Rubric gap, Other.
-- The <@ operator enforces that every element of the array is in the allowed
-- set. An empty array satisfies this constraint.

alter table app.content_review_decisions
  add constraint crd_concern_codes_check
    check (concern_codes <@ array['Accuracy', 'Ambiguity', 'Rubric gap', 'Other']::text[]);

-- ── 4. Review status on content_item_versions ─────────────────────────────────
--
-- Tracks where a content version sits in the tutor/reader review workflow.
-- Null means the version has not yet been assigned for review.
-- Content lifecycle status (draft/published/retired) remains unchanged.

alter table app.content_item_versions
  add column if not exists review_status text
    check (review_status is null or review_status in (
      -- Question review states
      'tutor_review_pending',
      'tutor_review_partial',
      'ap_reader_pending',
      'modification_reserved',
      'excluded',
      'question_review_approved',
      'difficulty_discussion',
      'difficulty_confirmed',
      -- MCQ answer review states (set after question_review_approved for MCQs)
      'answer_tutor_review_pending',
      'answer_ap_reader_pending',
      'answer_modification_reserved',
      'answer_approved',
      'mcq_package_excluded',
      'mcq_answer_review_complete'
    ));

-- ── 5. RLS: assigned reviewers can read content ───────────────────────────────
--
-- Reviewers access content through edge functions (service_role). These
-- policies add defense-in-depth and allow direct Supabase client reads for
-- the Lovable frontend.

-- content_item_versions: readable by any reviewer with an active assignment
-- against that version.
create policy "civ_select_assigned_reviewer"
  on app.content_item_versions
  for select to authenticated
  using (
    exists (
      select 1
      from app.content_review_assignments cra
      where cra.content_item_version_id = content_item_versions.id
        and cra.reviewer_id = auth.uid()
        and cra.status in ('pending', 'in_progress', 'submitted')
    )
  );

-- content_items: readable when the reviewer can see the version.
create policy "ci_select_assigned_reviewer"
  on app.content_items
  for select to authenticated
  using (
    exists (
      select 1
      from app.content_item_versions civ
      join app.content_review_assignments cra
        on cra.content_item_version_id = civ.id
      where civ.content_item_id = content_items.id
        and cra.reviewer_id = auth.uid()
        and cra.status in ('pending', 'in_progress', 'submitted')
    )
  );

-- mcq_choices: readable when the reviewer is assigned to the parent version.
create policy "mcq_choices_select_assigned_reviewer"
  on app.mcq_choices
  for select to authenticated
  using (
    exists (
      select 1
      from app.content_review_assignments cra
      where cra.content_item_version_id = mcq_choices.content_item_version_id
        and cra.reviewer_id = auth.uid()
        and cra.status in ('pending', 'in_progress', 'submitted')
    )
  );

-- frq_criteria: readable when the reviewer is assigned to the parent version.
create policy "frq_criteria_select_assigned_reviewer"
  on app.frq_criteria
  for select to authenticated
  using (
    exists (
      select 1
      from app.content_review_assignments cra
      where cra.content_item_version_id = frq_criteria.content_item_version_id
        and cra.reviewer_id = auth.uid()
        and cra.status in ('pending', 'in_progress', 'submitted')
    )
  );

commit;
