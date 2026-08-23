-- Course-mode convergence (Dev-behind, additive; also idempotent-safe on Prod where these already exist).
-- Brings Dev up to Prod on grading_results + content_item_versions. Applied to Dev 2026-08-23.
alter table app.grading_results add column if not exists normalized_response_sha256 text;
alter table app.grading_results add column if not exists cached_tokens integer;
alter table app.grading_results add column if not exists stage_timings jsonb;
alter table app.grading_results add column if not exists shadow_result jsonb;
alter table app.content_item_versions add column if not exists stimulus_image_path text;
