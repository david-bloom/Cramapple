-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260719201155
-- recorded name: add_stimulus_image_path
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

alter table app.content_item_versions
  add column if not exists stimulus_image_path text;
