-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260628193933
-- recorded name: canonical_answer_snapshot
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

alter table app.content_review_decisions
  add column if not exists canonical_answer_snapshot text;
