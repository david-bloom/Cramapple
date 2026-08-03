-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260714191539
-- recorded name: review_decision_categorical_scoring
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Additive columns for the categorical scoring model (DECISION-0038).
-- No backfill UPDATE: content_review_decisions is append-only (immutability
-- trigger), and legacy rows (tutor_decision null) resolve via the edge
-- function's resolveDecision fallback to the numeric tutor_score.

alter table app.content_review_decisions add column if not exists tutor_decision text;

alter table app.content_review_decisions drop constraint if exists crd_tutor_decision_check;

alter table app.content_review_decisions add constraint crd_tutor_decision_check
  check (tutor_decision is null or tutor_decision in ('approve', 'approve_with_edits', 'disapprove'));

alter table app.content_review_decisions add column if not exists difficulty_action text;

alter table app.content_review_decisions drop constraint if exists crd_difficulty_action_check;

alter table app.content_review_decisions add constraint crd_difficulty_action_check
  check (difficulty_action is null or difficulty_action in ('agree', 'propose'));

alter table app.content_review_decisions drop constraint if exists crd_reader_decision_check;

alter table app.content_review_decisions add constraint crd_reader_decision_check
  check (reader_decision is null or reader_decision in ('agree', 'disagree', 'approve', 'approve_with_edits', 'disapprove'));
