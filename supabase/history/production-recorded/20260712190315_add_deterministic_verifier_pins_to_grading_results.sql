-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260712190315
-- recorded name: add_deterministic_verifier_pins_to_grading_results
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

alter table app.grading_results
  add column if not exists deterministic_verifier_version text;

alter table app.grading_results
  add column if not exists boundary_contract_version text;
