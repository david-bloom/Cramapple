-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260709123606
-- recorded name: curated_public_interface_revoke_anon
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- DECISION-0035: curated interface is authenticated-only. Supabase default
-- privileges auto-grant anon on new public objects; revoke that here so the
-- contract matches the decision (sign-in required; no anon).
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
