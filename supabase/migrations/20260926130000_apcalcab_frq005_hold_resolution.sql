-- Resolves the apcalcab-frq-005 serving-label hold flagged in Claude's cross-QA of Codex's AP Calculus AB
-- Tier 3 run (docs/content/CLAUDE_CROSS_QA_AP_CALCULUS_AB_2026_09_25.md, PR #199). GPT-5.5's structured
-- output correctly returned required_units=[2,3], primary_unit=3 with per-criterion evidence; Gemini's
-- structured required_units/criterion_units arrays were empty despite its own prose evidence agreeing with
-- GPT-5.5's answer on every criterion -- a model-output-extraction bug, not a genuine disagreement. Both
-- models independently flagged the same real content issue (stimulus states the curve constant as 14 while
-- prompt_json/canonical answers use 16, consistent with point (2,2) actually lying on the curve) -- that is
-- a separate content data-inconsistency ticket, not touched by this migration.

begin;

with prior as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = 'd135bfe3-75ff-487f-ba6e-b5f4a567d139'
),
inserted as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[2,3], 3, 3,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'GPT-5.5''s required_units=[2,3]/primary_unit=3 matches its own per-criterion evidence exactly (implicit differentiation, product rule, chain rule across parts a/b/c). Gemini''s structured required_units/criterion_units arrays were empty ([]) on every criterion despite its own prose evidence text explicitly citing units 2.5/2.8/3.1/3.2 and agreeing with GPT-5.5''s conclusion -- read as a model-output-extraction bug, not a genuine two-model disagreement.',
      'cross_qa_report', 'docs/content/CLAUDE_CROSS_QA_AP_CALCULUS_AB_2026_09_25.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[]'::jsonb,
      'note', 'Separately flagged (content ticket, not fixed here): packet-level stimulus/prompt_json inconsistency -- stimulus states the level curve constant as 14 while prompt_json/canonical answers use 16, the value consistent with point (2,2) lying on the curve.'
    ),
    p.model_run_id, p.input_packet_hash
  from prior p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted)
where content_taxonomy_label_id = 'd135bfe3-75ff-487f-ba6e-b5f4a567d139';

commit;
