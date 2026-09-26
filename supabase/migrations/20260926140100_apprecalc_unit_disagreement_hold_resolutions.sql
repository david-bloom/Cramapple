-- Resolves 13 AP Precalculus serving-label holds with reason 'model_unit_disagreement', flagged in
-- Codex's cross-QA of PR #198 and independently re-verified by Claude against the full held-row set and
-- against each item's own stem/criteria text (docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md).
-- 11 of the 13 share one clean pattern (both models agree on primary_unit; the only disagreement is whether
-- Unit 1 belongs as a secondary required_unit for routine algebra used as a mechanical step) and are resolved
-- to the broader answer, matching the apcalcab-mcq-030/041 precedent from the parallel AP Calculus AB
-- remediation. One (apprecalc-frq-030) is the same pattern with the models swapped (GPT-5.5 broader,
-- Gemini narrower) and is resolved the same way after a stem spot-check. One (apprecalc-mcq-027) is a
-- genuinely different disagreement, resolved individually to Gemini's narrower, correct answer after
-- reading the item's stem. apprecalc-frq-np2-008's rubric_preflight_failure hold is a separate, real content
-- defect and is intentionally left untouched by this migration.

begin;


with prior_393debd6_f45d_43c1_b4d4_9a36b070a799 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = '393debd6-f45d-43c1-b4d4-9a36b070a799'
),
inserted_393debd6_f45d_43c1_b4d4_9a36b070a799 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2], 2, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2] only; Gemini returned [1,2], citing that the uniqueness argument in part C depends on recognizing the transformed equation is linear in x (Unit 1) before applying the nonzero-coefficient-implies-one-solution property. Resolved to the broader [1,2]: routine Unit 1 linear-equation mechanics used as a mechanical step inside an otherwise Unit 2 (exponential/logarithmic) item, matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_393debd6_f45d_43c1_b4d4_9a36b070a799 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_393debd6_f45d_43c1_b4d4_9a36b070a799)
where content_taxonomy_label_id = '393debd6-f45d-43c1-b4d4-9a36b070a799'; -- apprecalc-frq-014


with prior_bc116df0_5e25_4b2e_a406_4b315984be26 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = 'bc116df0-5e25-4b2e-a406-4b315984be26'
),
inserted_bc116df0_5e25_4b2e_a406_4b315984be26 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2], 2, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2] only; Gemini returned [1,2] because part (b) requires solving a 2x2 linear system for constants a and b, routine Unit 1 algebra used as a mechanical step inside an otherwise Unit 2 (exponential modeling) item. Resolved to the broader [1,2], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_bc116df0_5e25_4b2e_a406_4b315984be26 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_bc116df0_5e25_4b2e_a406_4b315984be26)
where content_taxonomy_label_id = 'bc116df0-5e25-4b2e-a406-4b315984be26'; -- apprecalc-frq-020


with prior_60941366_5aa8_41f2_9f8c_020c680d476f as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = '60941366-5aa8-41f2-9f8c-020c680d476f'
),
inserted_60941366_5aa8_41f2_9f8c_020c680d476f as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2,3], 3, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2,3] (log properties plus a trig equation in part c); Gemini returned [1,2,3], additionally tagging Unit 1 for routine algebraic manipulation used as a mechanical step alongside the Unit 2 log-rewrite and Unit 3 trig-equation work. Resolved to the broader [1,2,3], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2, 3]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_60941366_5aa8_41f2_9f8c_020c680d476f p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_60941366_5aa8_41f2_9f8c_020c680d476f)
where content_taxonomy_label_id = '60941366-5aa8-41f2-9f8c-020c680d476f'; -- apprecalc-frq-np2-007


with prior_324cba87_8b24_4917_a4d0_4b0205ab1005 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = '324cba87-8b24-4917-a4d0-4b0205ab1005'
),
inserted_324cba87_8b24_4917_a4d0_4b0205ab1005 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2], 2, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2] only; Gemini returned [1,2] because part (c) requires solving the quadratic equation x(x-4)=21 (routine Unit 1 mechanics) as a mechanical step inside an otherwise Unit 2 (logarithm properties) item -- confirmed by reading the item''s own frq_criteria (part-c-criterion-01: "forms the equation x(x-4) = 21, solving to get x = 7 or x = -3"). Resolved to the broader [1,2], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_324cba87_8b24_4917_a4d0_4b0205ab1005 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_324cba87_8b24_4917_a4d0_4b0205ab1005)
where content_taxonomy_label_id = '324cba87-8b24-4917-a4d0-4b0205ab1005'; -- apprecalc-frq-u12-002


with prior_6fd47acc_a5dd_4aed_b7df_302dd6ef6873 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = '6fd47acc-a5dd-4aed-b7df-302dd6ef6873'
),
inserted_6fd47acc_a5dd_4aed_b7df_302dd6ef6873 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2], 2, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2] only; Gemini returned [1,2], citing routine Unit 1 algebraic manipulation used as a mechanical step inside an otherwise Unit 2 (exponential/logarithmic equation solving) item. Resolved to the broader [1,2], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_6fd47acc_a5dd_4aed_b7df_302dd6ef6873 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_6fd47acc_a5dd_4aed_b7df_302dd6ef6873)
where content_taxonomy_label_id = '6fd47acc-a5dd-4aed-b7df-302dd6ef6873'; -- apprecalc-frq-u12-007


with prior_c42f3c07_c903_4437_b4c7_98431d89ce11 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = 'c42f3c07-c903-4437-b4c7-98431d89ce11'
),
inserted_c42f3c07_c903_4437_b4c7_98431d89ce11 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2], 2, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2] only; Gemini returned [1,2], citing routine Unit 1 domain-restriction/inverse-function algebra used as a mechanical step inside an otherwise Unit 2 item. Resolved to the broader [1,2], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_c42f3c07_c903_4437_b4c7_98431d89ce11 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_c42f3c07_c903_4437_b4c7_98431d89ce11)
where content_taxonomy_label_id = 'c42f3c07-c903-4437-b4c7-98431d89ce11'; -- apprecalc-frq-u12-009


with prior_5f3e7e49_bf1c_4644_a712_582be3477f51 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = '5f3e7e49-bf1c-4644-a712-582be3477f51'
),
inserted_5f3e7e49_bf1c_4644_a712_582be3477f51 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2], 2, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2] only; Gemini returned [1,2], citing routine Unit 1 algebraic manipulation used as a mechanical step inside an otherwise Unit 2 (logarithm manipulation) item. Resolved to the broader [1,2], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_5f3e7e49_bf1c_4644_a712_582be3477f51 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_5f3e7e49_bf1c_4644_a712_582be3477f51)
where content_taxonomy_label_id = '5f3e7e49-bf1c-4644-a712-582be3477f51'; -- apprecalc-frq-u12-014


with prior_f5706e14_c728_4f3c_af22_b08336b72cee as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = 'f5706e14-c728-4f3c-af22-b08336b72cee'
),
inserted_f5706e14_c728_4f3c_af22_b08336b72cee as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2], 2, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2] only; Gemini returned [1,2] because part (a) requires computing first differences and recognizing constant-first-differences as the signature of a linear model (Unit 1) before ruling it out in favor of the Unit 2 exponential model -- confirmed by reading the item''s own frq_criteria (part-a-criterion-02: "Correctly concludes a linear model is NOT appropriate because the first differences are not constant"). Resolved to the broader [1,2], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_f5706e14_c728_4f3c_af22_b08336b72cee p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_f5706e14_c728_4f3c_af22_b08336b72cee)
where content_taxonomy_label_id = 'f5706e14-c728-4f3c-af22-b08336b72cee'; -- apprecalc-frq-u12-016


with prior_2a8aaee5_bcf0_448a_9932_892d33699eb7 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = '2a8aaee5-bcf0-448a-9932-892d33699eb7'
),
inserted_2a8aaee5_bcf0_448a_9932_892d33699eb7 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2], 2, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2] only; Gemini returned [1,2], citing routine Unit 1 algebra (linearizing via a semi-log transform) used as a mechanical step inside an otherwise Unit 2 (exponential decay) item. Resolved to the broader [1,2], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_2a8aaee5_bcf0_448a_9932_892d33699eb7 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_2a8aaee5_bcf0_448a_9932_892d33699eb7)
where content_taxonomy_label_id = '2a8aaee5-bcf0-448a-9932-892d33699eb7'; -- apprecalc-frq-u12-017


with prior_d7044a4e_30d6_4468_b571_45bd082abac7 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = 'd7044a4e-30d6-4468-b571-45bd082abac7'
),
inserted_d7044a4e_30d6_4468_b571_45bd082abac7 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,2], 2, 2,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=2. GPT-5.5 returned required_units=[2] only; Gemini returned [1,2] because finding the domain of h(x)=ln(x^2-4) requires solving the quadratic inequality x^2-4>0 (routine Unit 1 mechanics) before applying the Unit 2 logarithm-domain rule. Resolved to the broader [1,2], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[2]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_d7044a4e_30d6_4468_b571_45bd082abac7 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_d7044a4e_30d6_4468_b571_45bd082abac7)
where content_taxonomy_label_id = 'd7044a4e-30d6-4468-b571-45bd082abac7'; -- apprecalc-mcq-014


with prior_8d8d8ca7_a7a3_4aff_8e29_2108662afce5 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = '8d8d8ca7-a7a3-4aff-8e29-2108662afce5'
),
inserted_8d8d8ca7_a7a3_4aff_8e29_2108662afce5 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,3], 3, 3,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=3. GPT-5.5 returned required_units=[3] only; Gemini returned [1,3], citing routine Unit 1 rate-of-change/graph-behavior reasoning used alongside the Unit 3 sinusoidal-model work in part (c). Resolved to the broader [1,3], matching the apcalcab-mcq-030/041 secondary-unit-tagging precedent.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[3]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_8d8d8ca7_a7a3_4aff_8e29_2108662afce5 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_8d8d8ca7_a7a3_4aff_8e29_2108662afce5)
where content_taxonomy_label_id = '8d8d8ca7-a7a3-4aff-8e29-2108662afce5'; -- apprecalc-frq-np2-003


with prior_c21185f6_831e_4459_9387_5331381f75fa as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = 'c21185f6-831e-4459-9387-5331381f75fa'
),
inserted_c21185f6_831e_4459_9387_5331381f75fa as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1,3], 3, 3,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'Both models agree primary_unit=3. This is the same disagreement pattern as the other 10 resolutions in this batch but with the models swapped: GPT-5.5 returned the broader required_units=[1,3] (citing Unit 1 rate-of-change/graph-behavior reasoning needed alongside Unit 3 sinusoidal analysis in part c), while Gemini returned the narrower [3] only. Spot-checked against the item''s own stem (part c: "state whether d is increasing or decreasing and whether its rate of change is increasing or decreasing") -- the rate-of-change-of-rate-of-change judgment is the same kind of general graph-behavior reasoning Gemini itself tagged as Unit 1 in the other 10 items in this batch. Resolved to the broader [1,3] for consistency with that same pattern.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[3]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_c21185f6_831e_4459_9387_5331381f75fa p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_c21185f6_831e_4459_9387_5331381f75fa)
where content_taxonomy_label_id = 'c21185f6-831e-4459-9387-5331381f75fa'; -- apprecalc-frq-030


with prior_f60716a7_8fb0_446e_9e40_e096cf161430 as (
  select content_taxonomy_label_id, content_item_id, label_version, taxonomy_source_version,
         taxonomy_confidence, input_packet_hash, model_run_id
  from app.content_taxonomy_labels
  where content_taxonomy_label_id = 'f60716a7-8fb0-446e-9e40-e096cf161430'
),
inserted_f60716a7_8fb0_446e_9e40_e096cf161430 as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit,
    taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id,
    input_packet_hash
  )
  select
    p.content_item_id, p.label_version + 1, 'serving', array[1], 1, 1,
    p.taxonomy_source_version, p.taxonomy_confidence, 'provisional_model',
    'claude_cross_qa_hold_resolution_2026_09_26',
    jsonb_build_object(
      'reason', 'GPT-5.5 returned required_units=[1,2,3]/primary_unit=1; Gemini returned required_units=[1]/primary_unit=1. Both agree on primary_unit. Read the item''s actual stem: "A table has constant second differences and nonconstant first differences for equally spaced inputs. Which model type is most appropriate?" (options: Linear/Exponential/Quadratic/Sinusoidal). This is pure Unit 1 content (quadratic recognition via finite differences) and does not require exponential (Unit 2) or trigonometric (Unit 3) knowledge to answer -- GPT-5.5''s broader tagging reads as a genuine model error here (asserting the correct-answer criterion requires refuting the exponential and sinusoidal distractors using Unit 2/3 concepts, when the actual discriminating skill is purely the Unit 1 finite-differences test), not a defensible secondary-unit read of this item. Resolved individually to Gemini''s narrower, correct answer: required_units=[1], primary_unit=1 -- NOT the ''resolve broader'' rule used for the other 12 items in this batch.',
      'remediation_report', 'docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md',
      'prior_label_id', p.content_taxonomy_label_id::text,
      'corrected_from_required_units', '[1, 2, 3]'::jsonb
    ),
    p.model_run_id, p.input_packet_hash
  from prior_f60716a7_8fb0_446e_9e40_e096cf161430 p
  returning content_taxonomy_label_id
)
update app.content_taxonomy_labels
set superseded_by = (select content_taxonomy_label_id from inserted_f60716a7_8fb0_446e_9e40_e096cf161430)
where content_taxonomy_label_id = 'f60716a7-8fb0-446e-9e40-e096cf161430'; -- apprecalc-mcq-027


commit;
