-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260712152005
-- recorded name: add_answer_approvals_to_content_review_decisions
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

alter table app.content_review_decisions
  add column if not exists answer_approvals jsonb;

comment on column app.content_review_decisions.answer_approvals is
  'Per-MCQ-choice approve/reject picks captured alongside the tutor_question decision, e.g. [{"choice_key":"A","approved":true}, ...]. Null for FRQ items and non-tutor_question stages.';
