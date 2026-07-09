-- DECISION-0035: the curated public interface is authenticated-only (sign-in
-- required; no anonymous access). Supabase's default privileges auto-grant `anon`
-- SELECT on newly created objects in the `public` schema, so the views created by
-- 202607090001 picked up `anon` grants the prior migration never issued. Revoke
-- them here so the live contract matches the decision.
--
-- Applied to Production (pcntajvbdfqhbeewmdry) 2026-07-09 as migration
-- `curated_public_interface_revoke_anon`. No data was exposed before this ran:
-- the entity views are `security_invoker` and `anon` lacks USAGE on schema `app`
-- (permission denied at query time), and the dashboard views are gated to
-- signed-in staff via an `auth.uid()` role check. This revoke is defense-in-depth
-- plus literal compliance with DECISION-0035.

revoke all on public.profiles from anon;
revoke all on public.subjects from anon;
revoke all on public.exam_packs from anon;
revoke all on public.exam_pack_versions from anon;
revoke all on public.content_labels from anon;
revoke all on public.content_items from anon;
revoke all on public.content_item_versions from anon;
revoke all on public.mcq_choices from anon;
revoke all on public.frq_criteria from anon;
revoke all on public.content_item_labels from anon;
revoke all on public.learning_sessions from anon;
revoke all on public.attempts from anon;
revoke all on public.response_versions from anon;
revoke all on public.attempt_criterion_results from anon;
revoke all on public.progress_snapshots from anon;
revoke all on public.grading_results from anon;
revoke all on public.content_review_assignments from anon;
revoke all on public.content_review_decisions from anon;
revoke all on public.config from anon;
revoke all on public.dashboard_overview_v1 from anon;
revoke all on public.dashboard_subjects_v1 from anon;
revoke all on public.dashboard_pipeline_v1 from anon;
revoke all on public.dashboard_engagement_v1 from anon;
revoke all on public.dashboard_quality_v1 from anon;
revoke all on public.dashboard_attention_v1 from anon;
