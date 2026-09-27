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
      '4db7188f-22e2-407d-be53-34d253567ddc'::uuid,
      'be98eb10-854e-49cf-ada2-e0116d588fcd'::uuid,
      '953843b9b1af645c53087fd21e106297a0202f9e3eb2b8d06fa749b7eecd0ef4',
      array[3]::integer[],
      3,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":3417,"output":{"content_key":"apprecalc-mcq-np2-007","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item assesses an exact trigonometric function value for cosine at a standard angle, which is within AP Precalculus Unit 3 and does not require Unit 4 or calculus content."},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"MCQ_keyed_answer_and_distractor_refutation","units":[3],"evidence":"Determining cos(5π/6) requires using the unit-circle/reference-angle value cos(π/6)=√3/2 and the quadrant II sign for cosine; refuting the distractors requires distinguishing cosine from sine reference values and applying the correct sign."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4343,"completion_tokens":309,"total_tokens":4652,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.013705,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":79,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.013705}},{"model":"google/gemini-2.5-flash","ok":true,"ms":5919,"output":{"content_key":"apprecalc-mcq-np2-007","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"A","units":[3],"evidence":"The question requires evaluating the exact value of a trigonometric function (cosine) for a given angle in radians, which involves identifying the quadrant, determining the reference angle, and recalling the exact value for the reference angle. This is directly covered by Unit 3, specifically Topic 3.3 (Sine and Cosine Function Values)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4543,"completion_tokens":1054,"total_tokens":5597,"cost":0.00289765,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4075,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":826,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00289765,"gateway_cost":0.00289765}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '635f04a46d84ad660eed0586d75113e1be632099cd6d0c8ea88838e08444de41'
    ),
(
      '6994728b-07a0-4777-877a-23208b1ed6dc'::uuid,
      'db3cb1f5-1c4b-496f-abe0-7dde42280b63'::uuid,
      '281434f97890ef51049f2b66ad8f20f8e0c6e14bc55dedda47008dc9713dbc96',
      array[3]::integer[],
      3,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":3286,"output":{"content_key":"apprecalc-mcq-np2-008","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"Polar-to-rectangular coordinate conversion is assessed in AP Precalculus Unit 3."},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"mcq_keyed_answer_and_distractors","units":[3],"evidence":"Selecting the correct rectangular coordinates and refuting the distractors requires using polar-to-rectangular conversion formulas x = r cos(theta) and y = r sin(theta), including handling a negative radius."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4364,"completion_tokens":303,"total_tokens":4667,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.01363,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":109,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.01363}},{"model":"google/gemini-2.5-flash","ok":true,"ms":7774,"output":{"content_key":"apprecalc-mcq-np2-008","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"correct_answer_calculation","units":[3],"evidence":"The conversion from polar coordinates (r, theta) to rectangular coordinates (x, y) using the formulas x = r*cos(theta) and y = r*sin(theta) is explicitly covered in Unit 3, Topic 3.13. The evaluation of trigonometric function values for common angles (e.g., cos(pi/3) and sin(pi/3)) is covered in Unit 3, Topic 3.3."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4563,"completion_tokens":1399,"total_tokens":5962,"cost":0.00376615,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4075,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1139,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00376615,"gateway_cost":0.00376615}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'd77165972d45ad8495eed8fd0be785e3a7e6f44913c74bd2829281f4d808a2b6'
    ),
(
      'a11c434f-1e57-437d-ae8e-58930a150f71'::uuid,
      '267aad46-069c-42bb-8fa0-f1c15d728606'::uuid,
      'cd27bf8cbf2e80135827e4f026e3ad35c9151dd89cc1ff60655f18a3d50e7e68',
      array[1]::integer[],
      1,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4000,"output":{"content_key":"apprecalc-mcq-np2-009","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires recognizing the relationship between constant finite differences for equally spaced inputs and the degree of a polynomial model, which is within AP Precalculus Unit 1 polynomial-function modeling and behavior. It does not require Unit 4, calculus, or out-of-scope content."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"mcq_correct_answer_and_distractor_refutation","units":[1],"evidence":"Selecting 3 and rejecting 2, 4, and 6 requires knowing that constant nth differences for equally spaced inputs correspond to a degree-n polynomial model, and that nonconstant second differences rule out degree 2."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4342,"completion_tokens":366,"total_tokens":4708,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.01541,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":129,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.01541}},{"model":"google/gemini-2.5-flash","ok":true,"ms":5725,"output":{"content_key":"apprecalc-mcq-np2-009","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"apprecalc-mcq-np2-009","units":[1],"evidence":"The question directly assesses the relationship between the degree of a polynomial and its constant finite differences. Specifically, it tests the knowledge that ''The nth differences of a polynomial function of degree n are constant for equally spaced input values'' (Unit 1, Topic 1.4, EK 1.4.A.1) and ''The (n-1)th differences of a polynomial function of degree n are not constant for equally spaced input values'' (Unit 1, Topic 1.4, EK 1.4.A.2). A student must understand these concepts from Unit 1 to correctly identify the minimum degree of the polynomial."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4538,"completion_tokens":1014,"total_tokens":5552,"cost":0.00279615,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4075,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":707,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00279615,"gateway_cost":0.00279615}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '6475c33e7e56a9a61df07cb3ffd12728ee7b07061c69a6dfe78d0e2eab5e6c6e'
    ),
(
      '5c601bc9-0b12-442e-95d5-5d4405a405b7'::uuid,
      '397f0d26-3d34-4816-9d33-883636ce1c80'::uuid,
      '8950143276ea29463efa654d58acbf5f23cff81425ffae980a47605a68368213',
      array[3]::integer[],
      3,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4391,"output":{"content_key":"apprecalc-mcq-np2-010","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item assesses cosecant as the reciprocal of sine and sine values at standard angles, which is AP Precalculus Unit 3 content."},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"mcq_choice_A_correct","units":[3],"evidence":"Identifying that csc(x)=1/sin(x) is undefined when sin(x)=0, and that sin(pi)=0, requires trigonometric function values and reciprocal trigonometric functions."},{"criterion_key":"mcq_choice_B_refutation","units":[3],"evidence":"Rejecting x=pi/2 requires knowing sin(pi/2)=1, so csc(pi/2) is defined."},{"criterion_key":"mcq_choice_C_refutation","units":[3],"evidence":"Rejecting x=pi/4 requires knowing sin(pi/4)=sqrt(2)/2, so csc(pi/4) is defined."},{"criterion_key":"mcq_choice_D_refutation","units":[3],"evidence":"Rejecting x=3pi/2 requires knowing sin(3pi/2)=-1, so csc(3pi/2) is defined."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4363,"completion_tokens":519,"total_tokens":4882,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.020105,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":140,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.020105}},{"model":"google/gemini-2.5-flash","ok":true,"ms":5512,"output":{"content_key":"apprecalc-mcq-np2-010","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[3],"primary_unit":3,"criterion_units":[],"uncertainty_flags":[]},"usage":{"prompt_tokens":4566,"completion_tokens":1034,"total_tokens":5600,"cost":0.0039548,"is_byok":false,"prompt_tokens_details":{"cached_tokens":0,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":908,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.0039548,"gateway_cost":0.0039548}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '908e94de7174b74cbe1dc29a345292cc95e67aec3fad91f5f308bb8c0e1cefcd'
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
