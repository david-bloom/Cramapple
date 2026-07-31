-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260712190427
-- recorded name: grading_results_view_phase_a_columns_v2
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

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
