-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124556
-- recorded name: seed_initial_prompt_versions
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

begin;

insert into app.prompt_versions (operation, version, status, prompt_hash, released_at)
values
  ('grade_initial_attempt', 'v1.0.0', 'published', 'seed-placeholder-grade-initial-attempt', now()),
  ('select_repair',         'v1.0.0', 'published', 'seed-placeholder-select-repair',         now()),
  ('grade_revision',        'v1.0.0', 'published', 'seed-placeholder-grade-revision',        now()),
  ('grade_transfer_attempt','v1.0.0', 'published', 'seed-placeholder-grade-transfer-attempt',now())
on conflict (operation, version) do nothing;

commit;
