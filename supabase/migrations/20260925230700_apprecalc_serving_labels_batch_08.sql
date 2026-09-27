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
      '574d732f-00c9-4a57-b674-c2c276aa76ca'::uuid,
      'c42a4161-d558-4dd5-a427-891404f88dae'::uuid,
      '841ea628a69ec2a65f0a1207019e6f65e09261ed47f7de58bf86e9888e37b556',
      array[2]::integer[],
      2,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":{"label_status":"legacy_unvalidated","required_units":[],"max_required_unit":null,"primary_unit":null,"source":"legacy_prompt_json"},"models":[{"model":"openai/gpt-5.5","ok":true,"ms":5840,"output":{"content_key":"apprecalc-mcq-036","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires evaluating a composition of functions, which is within AP Precalculus Units 1-3 and does not require Unit 4, calculus, or other out-of-scope content."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"keyed_answer_D","units":[2],"evidence":"Finding (g∘f)(x) requires substituting f(x)=2x−5 into g(x)=x²+1 to obtain (2x−5)²+1."},{"criterion_key":"distractor_A_refutation","units":[2],"evidence":"Rejecting this choice requires recognizing that it applies the functions in the reverse order rather than computing g after f."},{"criterion_key":"distractor_B_refutation","units":[2],"evidence":"Rejecting this choice requires correctly substituting the entire expression f(x)=2x−5 as the input to g."},{"criterion_key":"distractor_C_refutation","units":[2],"evidence":"Rejecting this choice requires using the correct outer function g(u)=u²+1, not u²−1."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4557,"completion_tokens":638,"total_tokens":5195,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.024645,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":271,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.024645}},{"model":"google/gemini-2.5-flash","ok":true,"ms":3702,"output":{"content_key":"apprecalc-mcq-036","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2],"primary_unit":2,"criterion_units":[],"uncertainty_flags":[]},"usage":{"prompt_tokens":4815,"completion_tokens":631,"total_tokens":5446,"cost":0.00192148,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4076,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":508,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00192148,"gateway_cost":0.00192148}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '7862fac5b72ab41b796d575b87dde4317a0404fa29e2b1deb9a42ecbba76fcec'
    ),
(
      '5ddbd788-5ba9-45a7-8719-9c779ad9914b'::uuid,
      'd6d5756c-ced2-42c5-bb73-7ab9eec4e4f1'::uuid,
      'f49b1289462f590aeef873311ae6f9421aa5466c89168c508ac32eea28064144',
      array[2]::integer[],
      2,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":{"label_status":"legacy_unvalidated","required_units":[],"max_required_unit":null,"primary_unit":null,"source":"legacy_prompt_json"},"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4417,"output":{"content_key":"apprecalc-mcq-038","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires interpreting a semi-log plot for an exponential function, which is assessed in AP Precalculus Unit 2."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"mcq_keyed_answer_and_distractors","units":[2],"evidence":"To select B and reject the distractors, the student must know that for y = ab^x, plotting log10(y) against x gives a line with slope log10(b), so log10(b) = 0.3010 and b = 10^0.3010 ≈ 2. This is Unit 2 exponential/logarithmic and semi-log plot reasoning."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4525,"completion_tokens":423,"total_tokens":4948,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.018035,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":186,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.018035}},{"model":"google/gemini-2.5-flash","ok":true,"ms":9311,"output":{"content_key":"apprecalc-mcq-038","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"mcq_item","units":[2],"evidence":"The item requires understanding of exponential functions (y=ab^x), logarithmic properties (product and power rules), and the concept of semi-log linearization to transform an exponential relationship into a linear one. Specifically, it tests the ability to identify the slope of the linearized function log₁₀(y) = log₁₀(a) + x * log₁₀(b) as log₁₀(b) and then solve for b. This directly aligns with Unit 2 topics, particularly 2.12 (Logarithmic Function Manipulation) and 2.15 (Semi-log Plots)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4815,"completion_tokens":1683,"total_tokens":6498,"cost":0.00455148,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4076,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1398,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00455148,"gateway_cost":0.00455148}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '9d71d59f6550c21d2253eb01f7cca6a1722edd4d76523554cc921ffa65112f79'
    ),
(
      '69d75830-63b2-41c8-94e8-bba886ba1781'::uuid,
      '7b86a30b-2c16-4541-bafa-9eaed4d8e334'::uuid,
      'fdd0faff48b115ebb29d461e306a1d4a9241747ffa2a3e529c95faea3b1bb783',
      array[2]::integer[],
      2,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":{"label_status":"legacy_unvalidated","required_units":[],"max_required_unit":null,"primary_unit":null,"source":"legacy_prompt_json"},"models":[{"model":"openai/gpt-5.5","ok":true,"ms":6132,"output":{"content_key":"apprecalc-mcq-040","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires solving a logarithmic equation using the inverse relationship between natural logarithms and base-e exponentials, which is AP Precalculus Unit 2 content."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"mcq_keyed_answer","units":[2],"evidence":"To select the correct answer, students must solve 12 = 4.8 + 2.3ln(x), isolate ln(x), and exponentiate with base e."},{"criterion_key":"mcq_distractor_refutation","units":[2],"evidence":"Refuting the distractors requires recognizing that ln(x) is not x, using base e rather than base 10, and correctly isolating the logarithmic expression before exponentiating."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4511,"completion_tokens":553,"total_tokens":5064,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.021865,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":288,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.021865}},{"model":"google/gemini-2.5-flash","ok":true,"ms":11565,"output":{"content_key":"apprecalc-mcq-040","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"mcq_item","units":[2],"evidence":"The item requires solving a logarithmic equation of the form y = a + b ln(x) for x, given a value for y. This involves algebraic manipulation of logarithmic expressions and applying the inverse relationship between the natural logarithm and the exponential function (e^x). This directly aligns with Unit 2, specifically Topic 2.13 (Exponential and Logarithmic Equations and Inequalities) and Topic 2.10 (Inverses of Exponential Functions)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4796,"completion_tokens":2093,"total_tokens":6889,"cost":0.00557078,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4076,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1838,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00557078,"gateway_cost":0.00557078}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '0b99a4cb59f1595bf4d0462ab03bee86a3f30783028884215019083cf881bca6'
    ),
(
      '6beecd39-c626-407d-84be-253225e4250a'::uuid,
      '87e4a25c-dfad-41da-9f67-a02bac5ca693'::uuid,
      '7a645f16066fdb184a21c18ab33718fca89db1f380d37dee4403c34de696f885',
      array[3]::integer[],
      3,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4108,"output":{"content_key":"apprecalc-mcq-045","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires evaluating a sinusoidal function model at a given input using radian measure, which is assessed in AP Precalculus Unit 3."},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"mcq_key_and_distractor_refutation","units":[3],"evidence":"To select the keyed answer and reject distractors, the student must evaluate T(t)=18+7sin((π/6)(t−2)) at t=5.5 using radians and understand the sinusoidal model’s midline/amplitude structure rather than using the maximum, sign error, or degree-mode evaluation."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4548,"completion_tokens":363,"total_tokens":4911,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.01635,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":127,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.01635}},{"model":"google/gemini-2.5-flash","ok":true,"ms":9793,"output":{"content_key":"apprecalc-mcq-045","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"mcq_answer","units":[3],"evidence":"The item requires evaluating a sinusoidal function at a specific input value. This involves understanding the structure of sinusoidal functions (Unit 3.5, 3.6), evaluating trigonometric functions (Unit 3.3), and performing calculations in radian mode, which is a key aspect of trigonometric functions in AP Precalculus (Unit 3). The distractors also highlight common errors related to trigonometric evaluation, such as using degree mode instead of radian mode or sign errors in trigonometric values."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4832,"completion_tokens":1677,"total_tokens":6509,"cost":0.00454158,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4076,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1418,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00454158,"gateway_cost":0.00454158}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'b921a7a4e9be410625eb2dab747480f0f155f48a881e291c535a208f42138ad7'
    ),
(
      '67085d22-4721-421f-8ef9-a9a821cdd5a4'::uuid,
      '0e63cb2f-469a-42b8-9453-f32757469032'::uuid,
      '397104e8137edb03ab0092579024c6fd52a76bf964e31067c6c0baa9ec4a9dc1',
      array[1]::integer[],
      1,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4948,"output":{"content_key":"apprecalc-mcq-np2-001","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires polynomial end behavior from the leading term, which is AP Precalculus Unit 1 content and does not require Unit 4 or calculus."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"mcq_correct_A","units":[1],"evidence":"Determining that -3x^5 dominates and tends to positive infinity as x approaches negative infinity requires polynomial end behavior."},{"criterion_key":"mcq_refute_B","units":[1],"evidence":"Refuting the negative-infinity choice requires distinguishing odd-degree polynomial end behavior for x approaching negative infinity versus positive infinity."},{"criterion_key":"mcq_refute_C","units":[1],"evidence":"Refuting a finite horizontal behavior requires knowing nonconstant polynomial end behavior is governed by the leading term and is unbounded."},{"criterion_key":"mcq_refute_D","units":[1],"evidence":"Refuting oscillation requires recognizing polynomial end behavior is determined by the leading term."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4350,"completion_tokens":486,"total_tokens":4836,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.01905,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":149,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.01905}},{"model":"google/gemini-2.5-flash","ok":true,"ms":7013,"output":{"content_key":"apprecalc-mcq-np2-001","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"A","units":[1],"evidence":"The correct answer requires knowledge of polynomial end behavior, specifically how the leading term''s degree and coefficient determine the function''s behavior as x approaches negative infinity. This is covered in Unit 1, Topic 1.6 (Polynomial Functions and End Behavior)."},{"criterion_key":"B","units":[1],"evidence":"This distractor represents the end behavior as x approaches positive infinity for this polynomial. Understanding why this is incorrect for x approaching negative infinity relies on Unit 1, Topic 1.6."},{"criterion_key":"C","units":[1],"evidence":"This distractor suggests the function approaches a finite value. Understanding that non-constant polynomial end behavior is unbounded is part of Unit 1, Topic 1.6."},{"criterion_key":"D","units":[1],"evidence":"This distractor suggests oscillatory behavior. Understanding that polynomial functions do not oscillate in their end behavior, but rather are determined by the leading term, is part of Unit 1, Topic 1.6."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4549,"completion_tokens":1276,"total_tokens":5825,"cost":0.00345445,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4075,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":846,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00345445,"gateway_cost":0.00345445}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '428c42ff7da46ba022e7e8835bae42b9c48f7d5d9f530cb6c26c788558925c34'
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
