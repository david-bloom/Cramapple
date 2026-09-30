-- TASK-0056 step 3, part 2 (DECISION-0089): replace the table-level SELECT with
-- an explicit safe-column grant.
--
-- Why this exists: 20260930120100 revoked the answer columns column-by-column,
-- but `authenticated` holds SELECT on the whole of app.content_item_versions and
-- app.frq_criteria (relacl `authenticated=r`). A column-level REVOKE cannot
-- remove part of a table-level grant, so those revokes were no-ops. The guard
-- (scripts/qa/answer_key_exposure_guard.sql) caught it on Dev, 2026-09-30.
-- Same pattern as 20260824060000 (app.mcq_choices).
--
-- Apply AFTER 20260930120100, on every environment.
--
-- Effect: `authenticated` keeps SELECT on every column except
--   content_item_versions: canonical_answer_1, canonical_answer_2, explanation,
--                          item_package_payload
--   frq_criteria:          evidence_requirements, accepted_variants, minimum_fix
-- RLS is unchanged. A column added later is NOT readable by `authenticated`
-- until it is granted here on purpose (safe by default).
--
-- Checked before writing (Prod, 2026-09-30): no SECURITY INVOKER function that
-- `authenticated` can execute reads a revoked column. Column sets are identical
-- on Dev and Prod. Prod's `content_reviewer` role keeps its table grant (out of
-- scope; it is not a PostgREST login role).
--
-- ROLLBACK:
--   grant select on app.content_item_versions to authenticated;
--   grant select on app.frq_criteria to authenticated;
--
-- Trap 1: record this as version 20260930120200 on every environment (file name = ledger version).

begin;

revoke select on app.content_item_versions from authenticated, anon;
grant select (
  id, content_item_id, version_num, stem, stimulus, stimulus_image_path, prompt_json,
  help_text, content_hash, status, approved_at, approved_by, published_at,
  created_by, created_at, updated_at, review_status, rubric_type,
  evaluator_strategy, item_package_schema_version, item_package_sha256
) on app.content_item_versions to authenticated;

revoke select on app.frq_criteria from authenticated, anon;
grant select (
  id, content_item_version_id, criterion_key, learner_facing_text,
  points_possible, created_at
) on app.frq_criteria to authenticated;

commit;
