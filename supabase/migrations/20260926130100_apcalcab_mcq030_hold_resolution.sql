-- Resolves the apcalcab-mcq-030 serving-label hold flagged in Claude's cross-QA of Codex's AP Calculus AB
-- Tier 3 run (docs/content/CLAUDE_CROSS_QA_AP_CALCULUS_AB_2026_09_25.md, PR #199). Both models agree
-- primary_unit=3 (implicit differentiation of x^2+y^2=25 at (3,4)); the only disagreement is required_units
-- [3] (GPT-5.5) vs [2,3] (Gemini) -- whether the underlying power-rule mechanics count as a required
-- secondary unit. Resolved to [2,3], matching the pattern already used for apcalcab-mcq-041 in this same
-- run (an implicit-differentiation item that also tagged its underlying power-rule unit as a secondary
-- requirement).

begin;

with prior as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = '7b72df83-b697-4952-b46e-b6b98a26e8a1'
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
      'reason', 'Both models agree primary_unit=3. GPT-5.5 returned required_units=[3] only; Gemini returned [2,3], citing the power rule (Topic 2.5) as load-bearing alongside implicit differentiation (3.2) and the chain rule (3.1). Resolved to the broader [2,3] to match the secondary-unit-tagging convention already used elsewhere in this same run (apcalcab-mcq-041 tagged its underlying power-rule mechanics unit as a secondary requirement alongside its primary unit).',
      'cross_qa_report', 'docs/content/CLAUDE_CROSS_QA_AP_CALCULUS_AB_2026_09_25.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[3]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted)
where content_taxonomy_label_id = '7b72df83-b697-4952-b46e-b6b98a26e8a1';

commit;
