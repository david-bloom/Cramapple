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
      '65a69d35-8d0d-414a-afd4-bba8918955a2'::uuid,
      'a7ae9b95-dde0-4a8b-a060-969d5c730677'::uuid,
      '082ce6f3e8059ae228895ba9748340daee619ddd7e0ea3654bb767d58ed49362',
      array[1]::integer[],
      1,
      '[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Requires substituting into and evaluating a quadratic polynomial model and a rational model."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Requires comparing polynomial and rational model outputs to data to identify the better fit."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Requires determining the horizontal asymptote/end behavior of a rational function and interpreting it in context."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Requires reasoning about long-term behavior of a quadratic polynomial model versus a saturating rational model."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Requires setting a rational function model equal to a target output value."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Requires solving the resulting rational equation for the input value."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":{"label_status":"legacy_unvalidated","required_units":[],"max_required_unit":null,"primary_unit":null,"source":"legacy_prompt_json"},"models":[{"model":"openai/gpt-5.5","ok":true,"ms":6378,"output":{"content_key":"apprecalc-frq-u12-020","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":"All scored criteria involve evaluating polynomial and rational models, rational end behavior/horizontal asymptote, model comparison, and solving a rational equation, which are within AP Precalculus Units 1–3 and do not require Unit 4 or calculus."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Requires substituting into and evaluating a quadratic polynomial model and a rational model."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Requires comparing polynomial and rational model outputs to data to identify the better fit."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Requires determining the horizontal asymptote/end behavior of a rational function and interpreting it in context."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Requires reasoning about long-term behavior of a quadratic polynomial model versus a saturating rational model."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Requires setting a rational function model equal to a target output value."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Requires solving the resulting rational equation for the input value."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5768,"completion_tokens":667,"total_tokens":6435,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":4864,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.026962,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":245,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.026962}},{"model":"google/gemini-2.5-flash","ok":true,"ms":13434,"output":{"content_key":"apprecalc-frq-u12-020","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"This criterion requires evaluating polynomial and rational functions at a specific value, which aligns with topics like 1.4 (Polynomial Functions) and 1.8 (Rational Functions and Zeros), and 1.13 (Function Model Selection)."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"This criterion requires comparing model outputs to actual data and determining which model fits better, directly addressing Unit 1.13 (Function Model Selection and Assumption Articulation) and 1.14 (Function Model Construction and Application)."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"This criterion explicitly asks for the horizontal asymptote of a rational function and its interpretation, which is covered in Unit 1.7 (Rational Functions and End Behavior)."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"This criterion requires explaining the long-term behavior of a quadratic model and why it''s inappropriate for the context, relating to Unit 1.6 (Polynomial Functions and End Behavior) and Unit 1.13/1.14 (Function Model Selection/Application)."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"This criterion involves setting up an equation based on a rational function model to find a specific output, which falls under Unit 1.14 (Function Model Construction and Application) and implicitly 1.8 (Rational Functions and Zeros)."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"This criterion requires solving the rational equation set up in the previous step, which is a core skill in Unit 1.8 (Rational Functions and Zeros) and application in Unit 1.14."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":6173,"completion_tokens":2796,"total_tokens":8969,"cost":0.0077403,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4080,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":2149,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.0077403,"gateway_cost":0.0077403}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '00f2e12d08cd38d1028c2b490931e8c5256226d59bee100b361d462c552b77d4'
    ),
(
      '16a7224d-4ba6-4bd6-b604-3329013ae06c'::uuid,
      '6a7db798-e2be-4fa3-a4ee-3b79c5faebf6'::uuid,
      'a1d0836308b31c5da7d514ac43b6e8612cd164b2e9af9d6e42acae49b3d60123',
      array[1]::integer[],
      1,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":{"label_status":"legacy_unvalidated","required_units":[],"max_required_unit":null,"primary_unit":null,"source":"legacy_prompt_json"},"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4355,"output":{"content_key":"apprecalc-mcq-026","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item assesses transformations of a function in the form g(x) = -2f(x-3)+5, which is AP Precalculus Unit 1 content and does not require Unit 4, calculus, or out-of-scope content."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"mcq_key_and_distractor_refutation","units":[1],"evidence":"Correctly identifying the graph transformation from f to g requires interpreting f(x-3) as a right shift by 3, multiplication by -2 as a vertical stretch by 2 and reflection across the x-axis, and +5 as an upward shift; refuting the distractors requires the same Unit 1 function transformation knowledge."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4609,"completion_tokens":373,"total_tokens":4982,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.016955,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":123,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.016955}},{"model":"google/gemini-2.5-flash","ok":true,"ms":4530,"output":{"content_key":"apprecalc-mcq-026","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"select_correct_answer","units":[1],"evidence":"The question asks to identify transformations of a function given its algebraic form g(x)=−2f(x−3)+5. This directly assesses knowledge of function transformations, which is covered in Unit 1, Topic 1.12: Transformations of Functions. Specifically, understanding the effect of ''a'', ''h'', and ''k'' in the form af(x-h)+k is required to correctly identify the vertical stretch/reflection, horizontal shift, and vertical shift."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4877,"completion_tokens":833,"total_tokens":5710,"cost":0.00244508,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4076,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":571,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00244508,"gateway_cost":0.00244508}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'db38a21f010cc6f43d7151b3724ff85b90fa7919ad6b8b046c1b4957c8a2f99c'
    ),
(
      '9168feb4-749b-493c-8a66-85b5bea0afe8'::uuid,
      '2462b46b-07f1-412e-9d04-b4170c64fb16'::uuid,
      'cb0f1e55e08209beb292bb74b578fd031cb206749b124c4b02cf668ff0610637',
      array[1]::integer[],
      1,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":3331,"output":{"content_key":"apprecalc-mcq-028","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires applying the Remainder Theorem/polynomial evaluation when dividing a polynomial by x−2, which is within AP Precalculus Unit 1 polynomial functions."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"mcq_key_and_distractor_refutation","units":[1],"evidence":"To select D and refute the distractors, a student must know that the remainder when p(x) is divided by x−2 is p(2), then evaluate the polynomial correctly: 2(2)^3−3(2)^2+4(2)−5=7. This is Unit 1 polynomial function/division-remainder content."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4734,"completion_tokens":332,"total_tokens":5066,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.01635,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":89,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.01635}},{"model":"google/gemini-2.5-flash","ok":true,"ms":5070,"output":{"content_key":"apprecalc-mcq-028","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[],"uncertainty_flags":[]},"usage":{"prompt_tokens":5021,"completion_tokens":824,"total_tokens":5845,"cost":0.00246551,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4077,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":701,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00246551,"gateway_cost":0.00246551}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'e15d67601466346b4cddc223060a8e4edb28ed440977636cd6fe59ab20a01ac5'
    ),
(
      '468496cc-98e5-41fb-99d8-3f37711100dc'::uuid,
      'f860ebef-7d0e-41f3-9a9d-07347a03dd7f'::uuid,
      'de743496e2e72754d8027cf9bf3570942cba34038b055dd04ddfbe7f478eee5a',
      array[1]::integer[],
      1,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":{"label_status":"legacy_unvalidated","required_units":[],"max_required_unit":null,"primary_unit":null,"source":"legacy_prompt_json"},"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4892,"output":{"content_key":"apprecalc-mcq-030","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires evaluating a cubic polynomial model at two inputs and computing the predicted change in output; this is within AP Precalculus Unit 1 polynomial function/model application scope."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"mcq_keyed_answer","units":[1],"evidence":"The keyed answer and distractor refutations depend on computing f(3.1)-f(2.4) for the cubic polynomial regression y=0.42x^3-1.8x^2+0.65x+7.1, a Unit 1 polynomial function evaluation/change task."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4542,"completion_tokens":442,"total_tokens":4984,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.01869,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":214,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.01869}},{"model":"google/gemini-2.5-flash","ok":true,"ms":22875,"output":{"content_key":"apprecalc-mcq-030","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"mcq_correct_answer","units":[1],"evidence":"The problem requires evaluating a polynomial function (cubic regression) at two specific points and calculating the difference between these values. This is a core skill within Unit 1 (Polynomial and Rational Functions), particularly related to understanding function behavior and change (e.g., Topics 1.1, 1.2, 1.4)."}],"uncertainty_flags":["Numerical discrepancy: The calculated change in y, without intermediate rounding, is approximately 0.24114, which rounds to 0.24. The provided canonical answer is 0.23. This suggests a potential error in the item''s key or an expectation of intermediate rounding not typically advised for AP exams."]},"usage":{"prompt_tokens":4826,"completion_tokens":4084,"total_tokens":8910,"cost":0.01055728,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4076,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":3778,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.01055728,"gateway_cost":0.01055728}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'c2420e5e41512a3ce53686c5ce5cf8fb3fdab63a12f9b40a218f2e717b55e865'
    ),
(
      '5e9d621c-c4b3-4fe0-892b-25c7aaa3e37e'::uuid,
      '344e3520-ce37-4303-aeab-ccf86d77c521'::uuid,
      'a17297b7e0cc574b7bdf611bd852fec0f5a375302ae57d8e9c9ba2e5fe68ac1a',
      array[1]::integer[],
      1,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":7032,"output":{"content_key":"apprecalc-mcq-031","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires computing an average rate of change for a polynomial function, which is within AP Precalculus Unit 1 and does not require Unit 4 or calculus."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"keyed_answer_C","units":[1],"evidence":"Selecting the correct answer requires using the average rate of change formula [f(2.7)-f(1.2)]/(2.7-1.2) for a polynomial function."},{"criterion_key":"distractor_A_refutation","units":[1],"evidence":"Refuting this distractor requires recognizing the correct order of subtraction in the secant-slope average rate of change formula."},{"criterion_key":"distractor_B_refutation","units":[1],"evidence":"Refuting this distractor requires dividing the endpoint output difference by the correct input interval length."},{"criterion_key":"distractor_D_refutation","units":[1],"evidence":"Refuting this distractor requires distinguishing output change from average rate of change."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4625,"completion_tokens":668,"total_tokens":5293,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.025885,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":319,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.025885}},{"model":"google/gemini-2.5-flash","ok":true,"ms":7190,"output":{"content_key":"apprecalc-mcq-031","rubric_preflight":{"status":"not_applicable","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"mcq_item","units":[1],"evidence":"The item requires calculating the average rate of change of a polynomial function over an interval. This concept is explicitly covered in Unit 1, specifically Topic 1.3: ''average rate of change over [a,b] = slope of the secant line = [f(b)−f(a)]/(b−a)''."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4932,"completion_tokens":1307,"total_tokens":6239,"cost":0.00364658,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4076,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1075,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00364658,"gateway_cost":0.00364658}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '778992eff9572eedc274d8e44bd18e581b900ca838500e3a5369e3f82fa424e9'
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
