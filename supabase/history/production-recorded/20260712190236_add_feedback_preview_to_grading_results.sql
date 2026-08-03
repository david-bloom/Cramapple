-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260712190236
-- recorded name: add_feedback_preview_to_grading_results
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

alter table app.grading_results
  add column if not exists feedback_preview text;
