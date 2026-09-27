begin;

create temporary table tmp_math_serving_labels (
  content_item_id uuid,
  validated_against_version_id uuid,
  validated_against_taxo_hash text,
  required_units integer[],
  primary_unit integer,
  required_units_by_criterion jsonb,
  taxonomy_source_version uuid,
  label_status text,
  source_payload jsonb,
  model_run_id text,
  input_packet_hash text
) on commit drop;

insert into tmp_math_serving_labels (
  content_item_id,
  validated_against_version_id,
  validated_against_taxo_hash,
  required_units,
  primary_unit,
  required_units_by_criterion,
  taxonomy_source_version,
  label_status,
  source_payload,
  model_run_id,
  input_packet_hash
) values
(
      'b9089dc1-81d4-4d61-8f28-d34e83a65883'::uuid,
      'c91cdcd5-d637-4097-a243-2fba8b90e44f'::uuid,
      '939de9bc22a2375897213871d290fd4241d66c64190b9e60805f9b43f2e3c7f9',
      array[1]::integer[],
      1,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4527,"output":{"content_key":"apprecalc-mcq-np2-002","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires rational-function factor cancellation to distinguish a removable discontinuity (hole) from a vertical asymptote, which is assessed AP Precalculus Unit 1 content."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"keyed_answer_A","units":[1],"evidence":"Selecting A requires factoring x^2-16 as (x-4)(x+4), recognizing the common factor (x-4) creates a hole at x=4, and recognizing the uncanceled denominator factor (x+1) creates a vertical asymptote at x=-1."},{"criterion_key":"distractor_B","units":[1],"evidence":"Refuting B requires identifying which denominator zero corresponds to cancellation and which does not in a rational function."},{"criterion_key":"distractor_C","units":[1],"evidence":"Refuting C requires recognizing that a canceled factor in a rational expression produces a hole rather than a vertical asymptote."},{"criterion_key":"distractor_D","units":[1],"evidence":"Refuting D requires recognizing that an uncanceled denominator factor produces a vertical asymptote rather than a hole."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4447,"completion_tokens":478,"total_tokens":4925,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.019295,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":102,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.019295}},{"model":"google/gemini-2.5-flash","ok":true,"ms":8608,"output":{"content_key":"apprecalc-mcq-np2-002","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"A","units":[1],"evidence":"Correctly identifies a hole at x=4 due to the cancellable factor (x-4) and a vertical asymptote at x=-1 due to the non-cancellable factor (x+1) in the denominator. This requires understanding of Unit 1 Topics 1.9 (Rational Functions and Vertical Asymptotes), 1.10 (Rational Functions and Holes), and 1.11 (Equivalent Representations for factoring)."},{"criterion_key":"B","units":[1],"evidence":"Incorrectly swaps the behavior at x=4 and x=-1. Requires understanding of Unit 1 Topics 1.9, 1.10, and 1.11 to identify the error."},{"criterion_key":"C","units":[1],"evidence":"Incorrectly identifies vertical asymptotes at both x=4 and x=-1, failing to recognize the hole at x=4. Requires understanding of Unit 1 Topics 1.9, 1.10, and 1.11 to identify the error."},{"criterion_key":"D","units":[1],"evidence":"Incorrectly identifies holes at both x=4 and x=-1, failing to recognize the vertical asymptote at x=-1. Requires understanding of Unit 1 Topics 1.9, 1.10, and 1.11 to identify the error."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4634,"completion_tokens":1693,"total_tokens":6327,"cost":0.00452245,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4075,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1186,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00452245,"gateway_cost":0.00452245}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '8489b7dbf4261eb2dac21632fd3431bec6f36337a3ecca8be246d439af6c6338'
    ),
(
      '56671e87-a007-49ca-ab76-151034ed6323'::uuid,
      '5acac8c1-e7f5-49fa-bedf-24606865b482'::uuid,
      'a81792421acb5d62404ea869996eb3802591349fc43a697dfb839e5b8aa55c23',
      array[2]::integer[],
      2,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":6311,"output":{"content_key":"apprecalc-mcq-np2-003","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item assesses exponential model justification using constant ratios versus regression fit statistics, which is within AP Precalculus Units 1-3 exam scope and does not require Unit 4, calculus, or other out-of-scope content."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"mcq_keyed_answer_A","units":[2],"evidence":"Selecting the correct answer requires knowing that exponential data over equal input intervals is justified by a constant ratio of outputs, not by a high regression r-squared value alone."},{"criterion_key":"mcq_distractor_B","units":[2],"evidence":"Refuting this distractor requires understanding that a high r-squared value is not sufficient structural justification for choosing an exponential model."},{"criterion_key":"mcq_distractor_C","units":[2],"evidence":"Refuting this distractor requires understanding that the issue is not whether r-squared is exactly 1, but that ratio-based reasoning is the appropriate justification for an exponential model."},{"criterion_key":"mcq_distractor_D","units":[2],"evidence":"Refuting this distractor requires understanding that reporting precision for r-squared does not make it valid justification for exponential model type."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4437,"completion_tokens":611,"total_tokens":5048,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.023235,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":223,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.023235}},{"model":"google/gemini-2.5-flash","ok":true,"ms":5928,"output":{"content_key":"apprecalc-mcq-np2-003","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"mcq_answer","units":[2],"evidence":"The question assesses the understanding of what constitutes valid justification for an exponential model. It contrasts the defining characteristic of an exponential function (constant ratio between consecutive outputs) with statistical measures of fit (r-squared value). This directly aligns with the documented low-scoring pattern from the 2025 exam (Q1 Part C) where ''reasoning ... referencing ''exponential regression,'' ''r values,'' or ''r² values'' is NOT sufficient to earn [the reasoning] point'' for identifying exponential data. This content is central to Unit 2, particularly topics like 2.2, 2.5, and 2.6."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4636,"completion_tokens":1194,"total_tokens":5830,"cost":0.00327555,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4075,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":898,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00327555,"gateway_cost":0.00327555}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'efefafaabe72b7d859b904e0a8883e8f745f1dab481759f1b8f83f5d39e96c98'
    ),
(
      '0e1a8031-ea28-4fd8-961d-989d60032e14'::uuid,
      '57cb390f-fb41-4cac-a9b9-d107a2ab036c'::uuid,
      'a1e773b918ff9da530654222015f3522c9dceec445ac55eb6733b9f5f0933476',
      array[2]::integer[],
      2,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":6023,"output":{"content_key":"apprecalc-mcq-np2-004","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires logarithm product and power properties and evaluating log base 5 of 25, all within AP Precalculus Unit 2."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"mcq_keyed_answer_and_distractor_refutation","units":[2],"evidence":"Selecting the keyed expression and refuting distractors requires using logarithmic properties: log_b(xy)=log_b(x)+log_b(y), log_b(x^n)=n log_b(x), and evaluating log_5(25)=2."}],"uncertainty_flags":["Choice C appears algebraically equivalent to the original expression, though less simplified, so the MCQ may have more than one equivalent answer depending on interpretation of the stem."]},"usage":{"prompt_tokens":4391,"completion_tokens":623,"total_tokens":5014,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.023365,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":361,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.023365}},{"model":"google/gemini-2.5-flash","ok":true,"ms":6661,"output":{"content_key":"apprecalc-mcq-np2-004","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2],"primary_unit":2,"criterion_units":[],"uncertainty_flags":[]},"usage":{"prompt_tokens":4597,"completion_tokens":1269,"total_tokens":5866,"cost":0.00345135,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4075,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1143,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00345135,"gateway_cost":0.00345135}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'dfcce37554aa46bea208d65c3e9464ca9eea701eae906bd46de18e1ed8f6bcc8'
    ),
(
      '59d9423e-8f5d-4b37-a40b-6f808f146d44'::uuid,
      '7389bf58-62b8-4422-937e-d4e116deaad1'::uuid,
      '71540f06474f65d0ed44445b85a016af6ba1f632d5725692d9711451a6685025',
      array[2]::integer[],
      2,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":6815,"output":{"content_key":"apprecalc-mcq-np2-005","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires solving an exponential equation by substitution and using logarithms; this is AP Precalculus Unit 2 content and does not require Unit 4, calculus, or out-of-scope AP Calculus BC-only content."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"mcq_choice_A_keyed_answer","units":[2],"evidence":"Selecting the keyed answer requires treating the equation as quadratic in e^x, solving for e^x=1 or 3, and converting to x=ln(1)=0 and x=ln(3), which is exponential/logarithmic equation content."},{"criterion_key":"mcq_choice_B_refutation","units":[2],"evidence":"Refuting this distractor requires recognizing that the solved values 1 and 3 are values of e^x, not x, and must be converted using logarithms."},{"criterion_key":"mcq_choice_C_refutation","units":[2],"evidence":"Refuting this distractor requires recognizing that e^x=1 is also valid and gives x=ln(1)=0."},{"criterion_key":"mcq_choice_D_refutation","units":[2],"evidence":"Refuting this distractor requires recognizing that both positive values e^x=1 and e^x=3 correspond to real logarithmic solutions."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4380,"completion_tokens":663,"total_tokens":5043,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.02451,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":333,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.02451}},{"model":"google/gemini-2.5-flash","ok":true,"ms":7650,"output":{"content_key":"apprecalc-mcq-np2-005","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2],"primary_unit":2,"criterion_units":[],"uncertainty_flags":[]},"usage":{"prompt_tokens":4574,"completion_tokens":1308,"total_tokens":5882,"cost":0.00354195,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4075,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1182,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00354195,"gateway_cost":0.00354195}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '76998a7878ac7170747ef64f873afa1716da4387fa58a61bcc62a51b3346553d'
    ),
(
      'a6c89a69-ac6f-4bbd-add6-53f44497aca0'::uuid,
      'bf0f9fe9-dcda-4d50-b107-91bdbc8fd5d6'::uuid,
      'd94f6f15f52f13b99dd53ea440b520be927e22786035344d3a763c8d906b89dd',
      array[3]::integer[],
      3,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4571,"output":{"content_key":"apprecalc-mcq-np2-006","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires interpreting cycles, period, and the sinusoidal parameter b in y = a*sin(b(x+c)) + d, which is AP Precalculus Unit 3 content and does not require Unit 4 or calculus."},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"mcq_keyed_answer_A","units":[3],"evidence":"Finding b from a sinusoidal period uses Unit 3 sinusoidal function parameters: period = 2π/|b|."},{"criterion_key":"mcq_distractor_B","units":[3],"evidence":"Refuting this distractor requires recognizing that 24 seconds is the time for 4 cycles, not the period of one sinusoidal cycle."},{"criterion_key":"mcq_distractor_C","units":[3],"evidence":"Refuting this distractor requires distinguishing cycle count/frequency information from the sinusoidal parameter b."},{"criterion_key":"mcq_distractor_D","units":[3],"evidence":"Refuting this distractor requires understanding that elapsed time is not directly the sinusoidal parameter b."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4351,"completion_tokens":482,"total_tokens":4833,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.018935,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":120,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.018935}},{"model":"google/gemini-2.5-flash","ok":true,"ms":9475,"output":{"content_key":"apprecalc-mcq-np2-006","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"A","units":[3],"evidence":"The correct answer requires understanding how to calculate the period of a sinusoidal function from a given number of cycles over a time interval, and then relating this period to the parameter ''b'' in the general sinusoidal equation (P = 2π/|b|). This is a core concept within Unit 3, specifically Topic 3.6 ''Sinusoidal Function Transformations''."},{"criterion_key":"B","units":[3],"evidence":"This distractor reflects a common misconception where the total time is incorrectly used as the period, without accounting for the number of cycles. This error demonstrates a misunderstanding of the period concept within sinusoidal functions (Unit 3)."},{"criterion_key":"C","units":[3],"evidence":"This distractor shows a misunderstanding of how the number of cycles relates to the parameter ''b'', directly using the cycle count instead of deriving the period first. This is a conceptual error related to sinusoidal function parameters (Unit 3)."},{"criterion_key":"D","units":[3],"evidence":"This distractor indicates a fundamental misunderstanding of the ''b'' parameter, equating it directly to the total elapsed time without any conversion to period or consideration of cycles. This is a conceptual error related to sinusoidal function parameters (Unit 3)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4560,"completion_tokens":2009,"total_tokens":6569,"cost":0.00529025,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4075,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1530,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00529025,"gateway_cost":0.00529025}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '96b98780967d817fdd3b1b007860a75cc4c627837f231ad3358d9289410e1a39'
    );

with numbered as (
  select
    tmp.*,
    coalesce((
      select max(ctl.label_version)
      from app.content_taxonomy_labels ctl
      where ctl.content_item_id = tmp.content_item_id
        and ctl.label_scope = 'serving'
    ), 0) + 1 as next_label_version
  from tmp_math_serving_labels tmp
), inserted as (
  insert into app.content_taxonomy_labels (
    content_item_id,
    label_version,
    label_scope,
    validated_against_version_id,
    validated_against_taxo_hash,
    required_units,
    primary_unit,
    required_units_by_criterion,
    taxonomy_source_version,
    taxonomy_confidence,
    label_status,
    source,
    source_payload,
    model_run_id,
    input_packet_hash
  )
  select
    content_item_id,
    next_label_version,
    'serving',
    validated_against_version_id,
    validated_against_taxo_hash,
    required_units,
    primary_unit,
    required_units_by_criterion,
    taxonomy_source_version,
    'verified',
    label_status,
    'vercel_ai_gateway_two_model_serving_lane',
    source_payload,
    model_run_id,
    input_packet_hash
  from numbered
  returning content_taxonomy_label_id, content_item_id
)
update app.content_taxonomy_labels old
set superseded_by = inserted.content_taxonomy_label_id
from inserted
where old.content_item_id = inserted.content_item_id
  and old.label_scope = 'serving'
  and old.superseded_by is null
  and old.content_taxonomy_label_id <> inserted.content_taxonomy_label_id;

commit;
