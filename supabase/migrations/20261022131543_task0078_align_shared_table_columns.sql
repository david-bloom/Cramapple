-- TASK-0078 ruling 6 (David, 2026-10-22): align Development to Production.
-- Bucket: columns on the five shared tables whose column sets differed.
-- Production and main's 20260731160000_schema_baseline.sql carry three columns Development lacks
-- (profiles.notification_email; content_review_decisions.tutor_decision and difficulty_action, the
-- first of which review-decision/index.ts writes). Development's own baseline carried eleven columns
-- that exist neither on Production nor in any migration on main, on three tables that hold zero rows
-- on Development (review_decisions, validation_runs, validation_suites); dropping a column drops its
-- own check/FK constraints and indexes with it. No view exposes any of these columns on either project.
-- Idempotent.

alter table app.profiles add column if not exists notification_email text;
alter table app.profiles drop constraint if exists profiles_notification_email_format_check;
alter table app.profiles add constraint profiles_notification_email_format_check
  check (((notification_email is null) or (notification_email ~* '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'::text)));
comment on column app.profiles.notification_email is
  'Optional address for operational notifications only. It is not an authentication identifier and does not change the user login.';

alter table app.content_review_decisions
  add column if not exists tutor_decision text,
  add column if not exists difficulty_action text;
alter table app.content_review_decisions drop constraint if exists crd_tutor_decision_check;
alter table app.content_review_decisions add constraint crd_tutor_decision_check
  check (((tutor_decision is null) or (tutor_decision = any (array['approve'::text, 'approve_with_edits'::text, 'disapprove'::text]))));
alter table app.content_review_decisions drop constraint if exists crd_difficulty_action_check;
alter table app.content_review_decisions add constraint crd_difficulty_action_check
  check (((difficulty_action is null) or (difficulty_action = any (array['agree'::text, 'propose'::text]))));

alter table app.review_decisions drop column if exists difficulty_label;

alter table app.validation_runs
  drop column if exists target_kind,
  drop column if exists runner_build,
  drop column if exists evidence_uri,
  drop column if exists evidence_sha256,
  drop column if exists invalidated_at,
  drop column if exists invalidation_reason;

alter table app.validation_suites
  drop column if exists input_contract_version,
  drop column if exists runner_kind,
  drop column if exists deterministic_configuration,
  drop column if exists expected_target_kind,
  drop column if exists supersedes_suite_version_id;
