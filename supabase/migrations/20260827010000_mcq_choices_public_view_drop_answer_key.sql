-- Recreate public.mcq_choices WITHOUT the answer-key columns (is_correct, rationale).
--
-- Why: PR #106 revoked column SELECT on app.mcq_choices.is_correct / .rationale
-- from `authenticated` to protect the answer key. But public.mcq_choices is a
-- SECURITY INVOKER view whose *definition* still selects mc.is_correct and
-- mc.rationale, so any `authenticated` read of the view requires privileges on
-- those columns -- which no longer exist. Result: EVERY authenticated read of
-- public.mcq_choices fails with "permission denied for table mcq_choices"
-- (SQLSTATE 42501), which breaks the Course Mode pilot's direct published-MCQ
-- serving read (use-published-mcq.ts / confirm-transfer-api.ts). This was latent
-- because prod never actually served a pilot MCQ until 2026-08-26.
--
-- Fix: remove is_correct / rationale from the student-facing view entirely. This
-- (a) makes the view readable by `authenticated` (it no longer touches the
-- revoked columns), and (b) completes PR #106's answer-key protection as
-- defense-in-depth -- the secret columns are no longer even present in the
-- authenticated-reachable surface.
--
-- Safety:
--   * No DB object depends on public.mcq_choices (pg_depend: none).
--   * No student-facing frontend path reads is_correct/rationale via this view
--     (both serving reads select only id, choice_key, choice_text).
--   * The reviewer path reads the answer key via the SECURITY DEFINER RPC
--     public.get_review_mcq_choices, NOT this view -- unaffected.
--   * Grading (evaluate-attempt) reads app.mcq_choices via service_role -- unaffected.
--   * RLS policy app.mcq_choices_select_published already permits authenticated
--     to see published rows, so serving returns rows once the view is readable.
--   * CREATE OR REPLACE VIEW cannot drop columns, so DROP + CREATE is required.
--
-- Revert: recreate the view with mc.is_correct and mc.rationale restored (the
-- prior definition), same grants.

drop view if exists public.mcq_choices;

create view public.mcq_choices with (security_invoker = true) as
  select
    mc.id,
    mc.content_item_version_id,
    civ.content_item_id,
    ci.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name as subject_name,
    ci.content_key,
    ci.item_type,
    ci.title,
    mc.choice_key,
    mc.choice_text,
    mc.created_at
  from app.mcq_choices mc
  join app.content_item_versions civ on civ.id = mc.content_item_version_id
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id;

-- Preserve the prior SELECT grants (anon was never granted and stays excluded).
grant select on public.mcq_choices to authenticated, service_role;
