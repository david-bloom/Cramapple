-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627123500
-- recorded name: add_canonical_answers_to_content_item_versions
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Add two nullable canonical answer columns to content_item_versions.
-- Both default to NULL so existing rows are unaffected.
-- MCQ rows will remain NULL; FRQ rows can be populated with 0, 1, or 2 answers.

alter table app.content_item_versions
  add column if not exists canonical_answer_1 text,
  add column if not exists canonical_answer_2 text;

comment on column app.content_item_versions.canonical_answer_1
  is 'Model canonical answer #1 for FRQ grading calibration. NULL when not provided.';

comment on column app.content_item_versions.canonical_answer_2
  is 'Model canonical answer #2 for FRQ grading calibration. NULL when not provided.';
