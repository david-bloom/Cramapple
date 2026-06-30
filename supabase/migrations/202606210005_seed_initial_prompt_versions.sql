-- Seed an initial published prompt_versions row per grading operation so
-- evaluate-attempt's new prompt_versions enforcement (added on the same
-- branch as this migration) has a baseline to match.
--
-- DEPLOYMENT REQUIREMENT: the EVALUATE_ATTEMPT_PROMPT_VERSION env var on
-- the deployed Edge Function must match the `version` value in this seed
-- (or be updated whenever a new prompt_versions row is published). Without
-- alignment, evaluate-attempt will reject every grading request with
-- HTTP 400 invalid_prompt_version.
--
-- Subsequent prompt rollouts should:
--   1. INSERT a new row with status='draft' under a new version string
--   2. Validate the prompt
--   3. UPDATE status to 'published' (the prior row may be left published
--      until the new one supersedes it; the env var controls which one
--      evaluate-attempt requests)
--   4. Eventually UPDATE the prior row to status='retired'
--
-- The prompt_hash here is a placeholder. Real rollouts should set
-- prompt_hash to sha256 of the canonical prompt text bundled with the
-- function build, so a runtime grader can verify the deployed prompt
-- matches the governed text.

begin;

insert into app.prompt_versions (operation, version, status, prompt_hash, released_at)
values
  ('grade_initial_attempt', 'v1.0.0', 'published', 'seed-placeholder-grade-initial-attempt', now()),
  ('select_repair',         'v1.0.0', 'published', 'seed-placeholder-select-repair',         now()),
  ('grade_revision',        'v1.0.0', 'published', 'seed-placeholder-grade-revision',        now()),
  ('grade_transfer_attempt','v1.0.0', 'published', 'seed-placeholder-grade-transfer-attempt',now())
on conflict (operation, version) do nothing;

commit;
