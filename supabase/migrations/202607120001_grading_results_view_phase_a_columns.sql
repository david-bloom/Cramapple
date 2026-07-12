-- Expose Phase A's grading-results columns through the curated public view.
--
-- 202607080007/008/009/010 added feedback_preview, action_hint, repair_hint,
-- deterministic_verifier_version, and boundary_contract_version to
-- app.grading_results. 202607090001 (curated_public_interface) recreated
-- public.grading_results with an explicit column list one day later, before
-- Phase A was reconciled onto this history, so those columns were never
-- added to the view. Without this, the Lovable frontend (which reads through
-- public.grading_results, not app.grading_results directly) cannot see
-- feedback text, repair hints, or verifier/boundary-contract provenance.
--
-- Postgres refuses `create or replace view` when the new column list isn't a
-- pure trailing append (here the new columns are inserted before
-- created_at/updated_at, not appended after them), so this must drop and
-- recreate rather than replace. Confirmed no other view depends on
-- public.grading_results before drop (checked via pg_depend on Production).

begin;

drop view public.grading_results;

create view public.grading_results
with (security_invoker = true)
as
select
  gr.id,
  gr.request_id,
  gr.request_hash,
  gr.attempt_id,
  a.user_id,
  a.learning_session_id,
  a.exam_pack_version_id,
  epv.exam_pack_id,
  ep.exam_code,
  ep.exam_name,
  ep.subject_id,
  s.subject_key,
  s.display_name as subject_name,
  a.content_item_version_id,
  ci.content_key,
  ci.item_type,
  ci.frq_form,
  ci.title,
  gr.response_version_id,
  gr.operation,
  gr.status,
  gr.points_earned,
  gr.points_available,
  gr.criterion_results,
  gr.highest_value_gap,
  gr.predicted_label,
  gr.predicted_point_gain,
  gr.actual_point_gain,
  gr.prediction_outcome,
  gr.confidence,
  gr.uncertainty_reason,
  gr.feedback_preview,
  gr.action_hint,
  gr.repair_hint,
  gr.deterministic_verifier_version,
  gr.boundary_contract_version,
  gr.created_at,
  gr.updated_at
from app.grading_results gr
join app.attempts a
  on a.id = gr.attempt_id
join app.content_item_versions civ
  on civ.id = a.content_item_version_id
join app.content_items ci
  on ci.id = civ.content_item_id
join app.exam_pack_versions epv
  on epv.id = a.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
join app.subjects s
  on s.id = ep.subject_id;

grant select on public.grading_results to authenticated;

commit;
