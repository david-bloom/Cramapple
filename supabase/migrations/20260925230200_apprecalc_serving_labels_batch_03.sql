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
      'e53b3ead-e68f-4b68-9c1d-998b2be3e5c6'::uuid,
      'b7e1dcbe-4a15-45eb-9f7b-ebbaab8da6fd'::uuid,
      'da1fbdba1bc35f4fe2acaad0ad275f8a546e38a86f4cf12d89b77765998ac008',
      array[2]::integer[],
      2,
      '[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"Computing ratios of consecutive outputs to identify constant multiplicative change is required for validating an exponential model."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"Concluding that an exponential model is appropriate from a constant ratio over equal input intervals is exponential-model validation."},{"criterion_key":"part-b-criterion-01","units":[2],"evidence":"Identifying the initial value a in B(t)=a*b^t is part of constructing an exponential model."},{"criterion_key":"part-b-criterion-02","units":[2],"evidence":"Using the constant ratio as the base b and writing B(t)=5(1.6)^t is exponential function model construction."},{"criterion_key":"part-c-criterion-01","units":[2],"evidence":"Substituting t=5 into an exponential model requires use of the constructed exponential function."},{"criterion_key":"part-c-criterion-02","units":[2],"evidence":"Evaluating the exponential expression 5(1.6)^5 and reporting the model prediction is application of an exponential model."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":6426,"output":{"content_key":"apprecalc-frq-np2-009","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":"The scored criteria require exponential-model validation, construction, and evaluation, which are AP Precalculus Unit 2 skills. No Unit 4, calculus, or other out-of-scope content is required."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"Computing ratios of consecutive outputs to identify constant multiplicative change is required for validating an exponential model."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"Concluding that an exponential model is appropriate from a constant ratio over equal input intervals is exponential-model validation."},{"criterion_key":"part-b-criterion-01","units":[2],"evidence":"Identifying the initial value a in B(t)=a*b^t is part of constructing an exponential model."},{"criterion_key":"part-b-criterion-02","units":[2],"evidence":"Using the constant ratio as the base b and writing B(t)=5(1.6)^t is exponential function model construction."},{"criterion_key":"part-c-criterion-01","units":[2],"evidence":"Substituting t=5 into an exponential model requires use of the constructed exponential function."},{"criterion_key":"part-c-criterion-02","units":[2],"evidence":"Evaluating the exponential expression 5(1.6)^5 and reporting the model prediction is application of an exponential model."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4879,"completion_tokens":578,"total_tokens":5457,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.024455,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":123,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.024455}},{"model":"google/gemini-2.5-flash","ok":true,"ms":11046,"output":{"content_key":"apprecalc-frq-np2-009","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"This criterion assesses the understanding of the defining characteristic of exponential functions: a constant ratio of consecutive outputs over equal-length input intervals. This is a core concept in Unit 2, specifically related to topics like 2.1 (geometric sequences) and 2.3 (exponential functions)."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"This criterion requires justification for an exponential model based on the constant ratio, explicitly disallowing reasoning based on regression statistics. This directly aligns with the documented low-scoring-point pattern for Unit 2 exponential model justification, emphasizing conceptual understanding of exponential function properties (2.3, 2.5)."},{"criterion_key":"part-b-criterion-01","units":[2],"evidence":"This criterion assesses the ability to identify the initial value ''a'' in the general exponential form B(t)=a*b^t from the given data point B(0). This is fundamental to constructing exponential models (2.3)."},{"criterion_key":"part-b-criterion-02","units":[2],"evidence":"This criterion assesses the ability to identify the growth factor ''b'' (the constant ratio found in part (a)) and to correctly state the complete exponential model. This is central to constructing exponential functions (2.3)."},{"criterion_key":"part-c-criterion-01","units":[2],"evidence":"This criterion assesses the ability to use the constructed exponential model to make a prediction by substituting a given input value. This is an application of exponential functions (2.3, 2.5)."},{"criterion_key":"part-c-criterion-02","units":[2],"evidence":"This criterion assesses the ability to correctly evaluate the exponential expression and provide the answer with the required precision. This is a computational skill within the context of exponential functions (2.3, 2.5)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5138,"completion_tokens":2123,"total_tokens":7261,"cost":0.00574811,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4077,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1460,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00574811,"gateway_cost":0.00574811}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'b60873f5ff9a05f56ff0c588d701b900444e7850de4d12680a31ae192f913431'
    ),
(
      'e0791969-f2c6-4367-bca1-ab6c92f8b371'::uuid,
      '9d3fff98-0960-4c91-8813-fe619de46276'::uuid,
      'ec893261a39b11a32148b5a13e1cc87de1d1d9b5520586b7b35b3b23e256fd58',
      array[1,3]::integer[],
      1,
      '[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Factoring x^3 - 4x as a polynomial expression is required for the criterion."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Finding all real zeros of the factored polynomial equation is required for the criterion."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Applying the sine sum identity sin(alpha + beta) is required for the criterion."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Using exact sine and cosine values at pi/2 to simplify to cos(x) is trigonometric content."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Identifying the zero and undefined value of a rational expression and performing sign analysis for a rational inequality requires Unit 1 rational-function reasoning."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Stating the solution set for a rational inequality with correct endpoint inclusion and exclusion requires Unit 1 rational-function inequality reasoning."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":7465,"output":{"content_key":"apprecalc-frq-np2-010","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":"The scored work uses polynomial factoring/zeros, a sine sum identity with exact trig values, and a rational inequality. These are within AP Precalculus Units 1 and 3 and do not require Unit 4, calculus, or other out-of-scope content."},"required_units":[1,3],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Factoring x^3 - 4x as a polynomial expression is required for the criterion."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Finding all real zeros of the factored polynomial equation is required for the criterion."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Applying the sine sum identity sin(alpha + beta) is required for the criterion."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Using exact sine and cosine values at pi/2 to simplify to cos(x) is trigonometric content."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Identifying the zero and undefined value of a rational expression and performing sign analysis for a rational inequality requires Unit 1 rational-function reasoning."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Stating the solution set for a rational inequality with correct endpoint inclusion and exclusion requires Unit 1 rational-function inequality reasoning."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4918,"completion_tokens":786,"total_tokens":5704,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.03089,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":323,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.03089}},{"model":"google/gemini-2.5-flash","ok":true,"ms":10048,"output":{"content_key":"apprecalc-frq-np2-010","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1,3],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Factoring a polynomial (x^3 - 4x) is a core algebraic skill for polynomial functions, covered in Unit 1 (e.g., Topic 1.4, 1.5)."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Finding the real zeros of a polynomial equation is directly related to polynomial functions, covered in Unit 1 (e.g., Topic 1.5)."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Applying the sum identity for sine (sin(α+β)) is explicitly covered in Unit 3, Topic 3.12 (Equivalent Representations of Trigonometric Functions)."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Simplifying a trigonometric expression using known values (cos(pi/2), sin(pi/2)) and identities is covered in Unit 3, Topics 3.3 (Sine and Cosine Function Values) and 3.12 (Equivalent Representations of Trigonometric Functions)."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Identifying critical values (zeros and vertical asymptotes) and performing a sign analysis to solve a rational inequality is a key skill for rational functions, covered in Unit 1 (e.g., Topics 1.8, 1.9)."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Stating the solution to a rational inequality using correct interval notation or inequality form is the culmination of solving rational inequalities, covered in Unit 1 (e.g., Topics 1.8, 1.9)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5170,"completion_tokens":2154,"total_tokens":7324,"cost":0.00583521,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4077,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1518,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00583521,"gateway_cost":0.00583521}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '5696d22c5b1ece9ef3b0c7a77c98e811cce0514e2f4840e0209e12632bf4da62'
    ),
(
      '6c650d50-32ad-4df4-a6a6-8beb64a6a922'::uuid,
      '100c521c-b604-4837-a3f9-cc36bc61cb78'::uuid,
      '32130673e590646c701b3875184800c4d7f6761fbdfeef3f2026054f2bc36664',
      '{}'::integer[],
      null,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'held',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"model_unit_disagreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":{"label_status":"legacy_unvalidated","required_units":[],"max_required_unit":null,"primary_unit":null,"source":"legacy_prompt_json"},"models":[{"model":"openai/gpt-5.5","ok":true,"ms":9330,"output":{"content_key":"apprecalc-frq-u12-002","rubric_preflight":{"status":"pass","findings":["Each scoring criterion maps to an asked operation in the corresponding prompt part.","All prompt parts have scoring coverage, and no criterion scores an unasked operation."]},"scope_violation":{"status":"none","evidence":"The item requires logarithmic properties, exact logarithm evaluation, logarithmic expansion, solving a logarithmic equation, and checking logarithmic domain restrictions, all within AP Precalculus Unit 2 exam scope."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"Combining logarithms using the quotient relationship is logarithmic expression manipulation."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"Evaluating log_2(8) exactly uses logarithms as inverses of exponential expressions."},{"criterion_key":"part-b-criterion-01","units":[2],"evidence":"Separating a logarithm of products and quotients into sums and differences uses logarithmic expression properties."},{"criterion_key":"part-b-criterion-02","units":[2],"evidence":"Applying the logarithmic power property to produce 3ln(x) + (1/2)ln(y) - 2ln(z) is Unit 2 logarithmic manipulation."},{"criterion_key":"part-c-criterion-01","units":[2],"evidence":"Solving the equation requires combining logarithms and using equality of logarithmic expressions to form an equation in the arguments."},{"criterion_key":"part-c-criterion-02","units":[2],"evidence":"Rejecting the extraneous solution depends on logarithmic domain restrictions from the original logarithmic equation."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5503,"completion_tokens":955,"total_tokens":6458,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":4864,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.034277,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":438,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.034277}},{"model":"google/gemini-2.5-flash","ok":true,"ms":12032,"output":{"content_key":"apprecalc-frq-u12-002","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1,2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"This criterion assesses the application of the quotient property of logarithms, which is covered in Unit 2, Topic 2.12 (Logarithmic Function Manipulation)."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"This criterion assesses the evaluation of a logarithm, requiring an understanding of the definition of a logarithm, which is fundamental to Unit 2, Topics 2.9 (Logarithmic Expressions) and 2.11 (Logarithmic Functions)."},{"criterion_key":"part-b-criterion-01","units":[2],"evidence":"This criterion assesses the application of the product and quotient properties of logarithms for expansion, covered in Unit 2, Topic 2.12 (Logarithmic Function Manipulation)."},{"criterion_key":"part-b-criterion-02","units":[2],"evidence":"This criterion assesses the application of the power property of logarithms for expansion, explicitly covered in Unit 2, Topic 2.12 (Logarithmic Function Manipulation)."},{"criterion_key":"part-c-criterion-01","units":[1,2],"evidence":"This criterion requires combining logarithms using the product property (Unit 2, Topic 2.12) and then solving the resulting quadratic equation (x^2-4x-21=0). Solving polynomial equations, including quadratics, is a core skill reinforced in Unit 1 (e.g., Topic 1.5 Polynomial Functions and Complex Zeros, 1.11 Equivalent Representations)."},{"criterion_key":"part-c-criterion-02","units":[2],"evidence":"This criterion requires rejecting extraneous solutions based on the domain of logarithmic functions (arguments must be positive), which is a key concept in Unit 2, Topic 2.11 (Logarithmic Functions)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5853,"completion_tokens":2686,"total_tokens":8539,"cost":0.00709417,"is_byok":false,"prompt_tokens_details":{"cached_tokens":5099,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":2034,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00709417,"gateway_cost":0.00709417}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '73fdacc63ca6b6237026d3f015224d1ae3c8467e62f0b133724fe3bd53217090'
    ),
(
      'a41ce9c5-800e-455e-a50e-6419cedcb9b9'::uuid,
      'b4c69acb-e5df-43b8-ac72-d96b8058d78f'::uuid,
      'ebf0d4b6801b627da9b2fdd8c279702e545db5435bed30cf11f7a4b4b56f95ce',
      array[1]::integer[],
      1,
      '[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Requires multiplying binomial factors of a polynomial as part of converting factored form to standard form."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Requires completing expansion and collecting like terms to produce a standard polynomial form."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Requires identifying real zeros directly from the polynomial''s factored form."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Requires describing polynomial end behavior using odd degree and positive leading coefficient."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Requires setting up and performing polynomial division using long or synthetic division."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Requires interpreting the result of polynomial division as a quotient with remainder zero."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4455,"output":{"content_key":"apprecalc-frq-u12-003","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":"All scored criteria involve polynomial expansion, zeros from factored form, polynomial end behavior, and polynomial division, which are within AP Precalculus Unit 1."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Requires multiplying binomial factors of a polynomial as part of converting factored form to standard form."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Requires completing expansion and collecting like terms to produce a standard polynomial form."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Requires identifying real zeros directly from the polynomial''s factored form."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Requires describing polynomial end behavior using odd degree and positive leading coefficient."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Requires setting up and performing polynomial division using long or synthetic division."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Requires interpreting the result of polynomial division as a quotient with remainder zero."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5443,"completion_tokens":498,"total_tokens":5941,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":4864,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.020267,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":99,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.020267}},{"model":"google/gemini-2.5-flash","ok":true,"ms":8175,"output":{"content_key":"apprecalc-frq-u12-003","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"This criterion assesses the ability to multiply polynomial factors, which is a fundamental algebraic manipulation skill for polynomial functions, covered under Unit 1, particularly relevant to Topic 1.11 Equivalent Representations."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"This criterion assesses the completion of polynomial expansion to standard form, a direct continuation of algebraic manipulation of polynomial functions, covered under Unit 1, particularly relevant to Topic 1.11 Equivalent Representations."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"This criterion assesses the identification of real zeros from the factored form of a polynomial, a core concept for polynomial functions covered in Unit 1, specifically Topic 1.5 Polynomial Functions and Complex Zeros."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"This criterion assesses the description and justification of end behavior for a polynomial function, which is explicitly covered in Unit 1, Topic 1.6 Polynomial Functions and End Behavior."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"This criterion assesses the ability to perform polynomial division (long or synthetic), which is a key skill for manipulating polynomial expressions and is directly covered in Unit 1, Topic 1.11 Equivalent Representations (which mentions the polynomial division identity)."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"This criterion assesses the correct statement of the quotient from polynomial division, a direct outcome of the division process covered in Unit 1, Topic 1.11 Equivalent Representations."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5752,"completion_tokens":1568,"total_tokens":7320,"cost":0.00426887,"is_byok":false,"prompt_tokens_details":{"cached_tokens":5099,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":956,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00426887,"gateway_cost":0.00426887}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '8a4120efb883eb75156f05cd2a6a2650913c7e017ed9d846db26ae6569f28261'
    ),
(
      '9c085b4f-8eba-4024-a9d5-573f52ce38e4'::uuid,
      'd7d77cb5-9b34-49ed-97ea-2da4709b3379'::uuid,
      '7b884bb902f8d90ac5cf7fcfc6f36c219b91c7624e66ebc6e60be8a860fb5a1c',
      '{}'::integer[],
      null,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'held',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"rubric_preflight_failure","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":{"label_status":"legacy_unvalidated","required_units":[],"max_required_unit":null,"primary_unit":null,"source":"legacy_prompt_json"},"models":[{"model":"openai/gpt-5.5","ok":true,"ms":8289,"output":{"content_key":"apprecalc-frq-u12-004","rubric_preflight":{"status":"fail","findings":["Part C asks students to state a reasonable domain for x in context and explain real-world restrictions, but the corresponding criteria score the interval where profit is positive, 0 ≤ x < 18.2, rather than the domain of the model or contextual restrictions on x.","Part C criteria score an unasked operation: distinguishing the profit-positive interval from the stated domain 0 ≤ x ≤ 20 and justifying profitability beyond the break-even point.","The rubric does not directly award credit for the asked domain statement and real-world restrictions, such as x representing a price increase with the stated contextual bounds 0 ≤ x ≤ 20."]},"scope_violation":{"status":"none","evidence":"No Unit 4 content, calculus, or other out-of-scope content is required; the issue is rubric-prompt misalignment."},"required_units":[],"primary_unit":null,"criterion_units":[],"uncertainty_flags":["rubric_preflight_failed"]},"usage":{"prompt_tokens":5672,"completion_tokens":783,"total_tokens":6455,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":4864,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.029962,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":516,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.029962}},{"model":"google/gemini-2.5-flash","ok":true,"ms":9151,"output":{"content_key":"apprecalc-frq-u12-004","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Finding the maximum of a quadratic function (vertex) is a core concept of polynomial functions, covered in Unit 1 (e.g., Topic 1.4 or 1.14)."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Evaluating a polynomial function at a specific value to find the maximum profit is an application of function models, covered in Unit 1 (Topic 1.14)."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Finding the zeros/roots of a quadratic function is a fundamental skill for polynomial functions, covered in Unit 1 (e.g., Topic 1.5 or 1.8)."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Interpreting mathematical solutions in a real-world context and applying domain restrictions based on the problem''s scenario is part of function model application, covered in Unit 1 (Topic 1.14)."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Identifying the interval where a polynomial function''s output is positive (profit is positive) requires understanding function behavior and zeros, covered in Unit 1 (e.g., Topic 1.3 or 1.14)."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Justifying a reasonable domain for a model based on real-world restrictions and the function''s output (profitability) is a key aspect of function model application and interpretation, covered in Unit 1 (Topic 1.14)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":6070,"completion_tokens":1897,"total_tokens":7967,"cost":0.0054619,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4080,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1276,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.0054619,"gateway_cost":0.0054619}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '0ff5d431f6c3ba5ca3b11f81499633a2aaf54f4dc11cbf253ce1df84dbe40b06'
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
