-- Addresses two of the six Supabase security-advisor findings from the
-- 2026-08-22 review (docs: assessment given in chat, not a separate doc).
--
-- 1. dashboard_*_v1 views are SECURITY DEFINER and already self-gate with a
--    `WHERE EXISTS (... p.role = ANY(staff roles))` check baked into each
--    query, so students get zero rows today - not an active leak. But
--    SECURITY DEFINER means they bypass RLS on every underlying table and
--    rely entirely on that hand-copied WHERE clause; a future view added
--    without pasting the same check would silently leak cross-student /
--    ops data. security_invoker=true makes them respect the querying
--    user's own privileges instead, so the guard isn't the only thing
--    standing between a bug and a leak. The default view grant to
--    `authenticated` also included INSERT/UPDATE/DELETE/TRUNCATE, which are
--    inert (none of these views are updatable) but sloppy - trimmed to
--    SELECT only.
--
-- 2. The 15 flagged trigger functions are all SECURITY INVOKER (verified via
--    pg_proc.prosecdef), so the "mutable search_path" lint is low-severity
--    here - search-path hijacking is a privilege-escalation risk mainly for
--    SECURITY DEFINER functions. Still free to close: pin search_path so
--    Postgres can't be tricked into resolving an unqualified name against a
--    schema earlier in a caller-controlled search_path.

alter view public.dashboard_overview_v1 set (security_invoker = true);
alter view public.dashboard_subjects_v1 set (security_invoker = true);
alter view public.dashboard_pipeline_v1 set (security_invoker = true);
alter view public.dashboard_engagement_v1 set (security_invoker = true);
alter view public.dashboard_quality_v1 set (security_invoker = true);
alter view public.dashboard_attention_v1 set (security_invoker = true);

revoke insert, update, delete, truncate, references, trigger
  on public.dashboard_overview_v1 from authenticated;
revoke insert, update, delete, truncate, references, trigger
  on public.dashboard_subjects_v1 from authenticated;
revoke insert, update, delete, truncate, references, trigger
  on public.dashboard_pipeline_v1 from authenticated;
revoke insert, update, delete, truncate, references, trigger
  on public.dashboard_engagement_v1 from authenticated;
revoke insert, update, delete, truncate, references, trigger
  on public.dashboard_quality_v1 from authenticated;
revoke insert, update, delete, truncate, references, trigger
  on public.dashboard_attention_v1 from authenticated;

alter function app.set_updated_at()
  set search_path = 'app', 'pg_catalog';
alter function app.enforce_content_items_frq_form()
  set search_path = 'app', 'pg_catalog';
alter function app.prevent_client_grading_truth_update()
  set search_path = 'app', 'pg_catalog';
alter function app.project_artifact_state(p_artifact_version_id uuid)
  set search_path = 'app', 'pg_catalog';
alter function app.refresh_artifact_state()
  set search_path = 'app', 'pg_catalog';
alter function app.prevent_review_decision_mutation()
  set search_path = 'app', 'pg_catalog';
alter function app.prevent_empty_frq_criteria()
  set search_path = 'app', 'pg_catalog';
alter function app.validate_decision_answer_key()
  set search_path = 'app', 'pg_catalog';
alter function app.apply_student_memory_event()
  set search_path = 'app', 'pg_catalog';
alter function app.prevent_profile_role_change()
  set search_path = 'app', 'pg_catalog';
alter function app.mcq_stem_choice_resync(p_version_id uuid, p_stem text)
  set search_path = 'app', 'pg_catalog';
alter function app.mcq_stem_choice_desync(p_version_id uuid, p_stem text)
  set search_path = 'app', 'pg_catalog';
alter function app.enforce_mcq_stem_choice_sync()
  set search_path = 'app', 'pg_catalog';
alter function app.enforce_publish_gate()
  set search_path = 'app', 'pg_catalog';
alter function app.response_attachments_guard_immutable_fields()
  set search_path = 'app', 'pg_catalog';
alter function app.capture_pairing_tokens_guard_immutable_fields()
  set search_path = 'app', 'pg_catalog';
alter function app.capture_pairing_events_guard_append_only()
  set search_path = 'app', 'pg_catalog';
