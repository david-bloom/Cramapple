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
      'c2201ccf-d8e7-40d2-9f22-f1d510a78e00'::uuid,
      'f6dc813c-50d0-45fc-99cd-25a47b811559'::uuid,
      'fde5a98e0a4eb4d352b3ef9af61ae9c98fe4a4c931984a67f24652233b102c47',
      array[2,3]::integer[],
      2,
      '[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"Solving e^(2x)-e^x-6=0 by substituting u=e^x and rejecting the negative root requires exponential-equation reasoning from Unit 2."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"Solving e^x=3 as x=ln(3) requires logarithms as inverses of exponential functions from Unit 2."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Restricting solutions of 4sin^2(x)-3=0 on [0, pi) uses sine-function values and trigonometric equation reasoning from Unit 3."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Finding x=pi/3 and x=2pi/3 on [0, pi) requires trigonometric function values and solving trigonometric equations from Unit 3."},{"criterion_key":"part-c-criterion-01","units":[3],"evidence":"Applying sec^2(x)-1=tan^2(x) requires Pythagorean trigonometric identities from Unit 3."},{"criterion_key":"part-c-criterion-02","units":[3],"evidence":"Simplifying tan^2(x)/tan(x) to tan(x) in a trigonometric expression is Unit 3 trigonometric manipulation."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":9787,"output":{"content_key":"apprecalc-frq-np2-004","rubric_preflight":{"status":"pass","findings":["Each prompt part has scoring coverage: part (a) is covered by two exponential-equation criteria, part (b) by two trigonometric-equation criteria, and part (c) by two trigonometric-simplification criteria.","Each criterion maps to an asked operation in the prompt.","No criterion scores an operation outside the prompt."]},"scope_violation":{"status":"none","evidence":"The item requires exponential equations, trigonometric equations, and trigonometric identities/simplification, all within AP Precalculus Units 2 and 3. It does not require Unit 4, calculus, or other out-of-scope content."},"required_units":[2,3],"primary_unit":null,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"Solving e^(2x)-e^x-6=0 by substituting u=e^x and rejecting the negative root requires exponential-equation reasoning from Unit 2."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"Solving e^x=3 as x=ln(3) requires logarithms as inverses of exponential functions from Unit 2."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Restricting solutions of 4sin^2(x)-3=0 on [0, pi) uses sine-function values and trigonometric equation reasoning from Unit 3."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Finding x=pi/3 and x=2pi/3 on [0, pi) requires trigonometric function values and solving trigonometric equations from Unit 3."},{"criterion_key":"part-c-criterion-01","units":[3],"evidence":"Applying sec^2(x)-1=tan^2(x) requires Pythagorean trigonometric identities from Unit 3."},{"criterion_key":"part-c-criterion-02","units":[3],"evidence":"Simplifying tan^2(x)/tan(x) to tan(x) in a trigonometric expression is Unit 3 trigonometric manipulation."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4853,"completion_tokens":1087,"total_tokens":5940,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.039595,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":484,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.039595}},{"model":"google/gemini-2.5-flash","ok":true,"ms":10855,"output":{"content_key":"apprecalc-frq-np2-004","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2,3],"primary_unit":3,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"This criterion assesses the ability to recognize and solve a hidden quadratic equation involving exponential functions (e^x) and to correctly handle the domain restriction of e^x > 0. This is explicitly covered in Unit 2, particularly in topics related to exponential equations and their properties (2.13)."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"This criterion assesses the ability to solve an exponential equation by applying the inverse logarithmic function. This is covered in Unit 2, specifically in topics 2.10 (Inverses of Exponential Functions) and 2.13 (Exponential and Logarithmic Equations and Inequalities)."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"This criterion assesses the ability to solve a trigonometric equation for sin(x) and to apply domain restrictions ([0, pi)) to determine the correct sign of the trigonometric function. This falls under Unit 3, specifically topics 3.3 (Sine and Cosine Function Values) and 3.10 (Trigonometric Equations and Inequalities)."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"This criterion assesses the ability to find specific solutions to a trigonometric equation within a given interval, requiring knowledge of common trigonometric values. This is covered in Unit 3, topics 3.3 (Sine and Cosine Function Values) and 3.10 (Trigonometric Equations and Inequalities)."},{"criterion_key":"part-c-criterion-01","units":[3],"evidence":"This criterion assesses the application of a Pythagorean trigonometric identity (sec^2(x)-1=tan^2(x)). This is explicitly mentioned in the fact pack as part of Unit 3, topic 3.12 (Equivalent Representations of Trigonometric Functions)."},{"criterion_key":"part-c-criterion-02","units":[3],"evidence":"This criterion assesses the algebraic simplification of a trigonometric expression after applying an identity. This is covered under Unit 3, topic 3.12 (Equivalent Representations of Trigonometric Functions), which involves manipulating trigonometric expressions."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5099,"completion_tokens":2374,"total_tokens":7473,"cost":0.00608851,"is_byok":false,"prompt_tokens_details":{"cached_tokens":5097,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1651,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00608851,"gateway_cost":0.00608851}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'b277b5444f88ab7e41c9790224d9c3ab9f4b777ee608e38a72509f5069b1e114'
    ),
(
      '226d6d13-ef7b-485c-be5a-8814f4ec31ec'::uuid,
      'e385e927-883f-483d-9299-daeac95b266f'::uuid,
      'c998806d3c77c2fea4201131e6d19f00b4c32b903ef85bfe65cc8be4db3f31f5',
      array[1]::integer[],
      1,
      '[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Identifying zeros of a rational function after factoring and canceling a shared factor is Unit 1 rational function behavior/equivalent representation work."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Identifying a hole and evaluating the simplified rational expression at the removed input is Unit 1 rational functions and holes."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Identifying the uncanceled denominator zero as a vertical asymptote is Unit 1 rational functions and vertical asymptotes."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Determining a horizontal asymptote from degrees and leading coefficients is Unit 1 rational functions and end behavior."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Setting up an equation using an equivalent simplified rational expression is Unit 1 rational function/equivalent representation work."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Solving the resulting rational equation and reporting the coordinate point is Unit 1 rational function application."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":8918,"output":{"content_key":"apprecalc-frq-np2-005","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":"The scored work requires rational function zeros, holes, vertical asymptotes, horizontal asymptotes, and solving a rational equation, all within AP Precalculus Unit 1."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Identifying zeros of a rational function after factoring and canceling a shared factor is Unit 1 rational function behavior/equivalent representation work."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Identifying a hole and evaluating the simplified rational expression at the removed input is Unit 1 rational functions and holes."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Identifying the uncanceled denominator zero as a vertical asymptote is Unit 1 rational functions and vertical asymptotes."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Determining a horizontal asymptote from degrees and leading coefficients is Unit 1 rational functions and end behavior."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Setting up an equation using an equivalent simplified rational expression is Unit 1 rational function/equivalent representation work."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Solving the resulting rational equation and reporting the coordinate point is Unit 1 rational function application."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4876,"completion_tokens":936,"total_tokens":5812,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.03518,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":479,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.03518}},{"model":"google/gemini-2.5-flash","ok":true,"ms":9190,"output":{"content_key":"apprecalc-frq-np2-005","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"This criterion assesses the identification of zeros of a rational function, which is covered in Unit 1, Topic 1.8 (Rational Functions and Zeros)."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"This criterion assesses the identification and location of holes in a rational function, which is covered in Unit 1, Topic 1.10 (Rational Functions and Holes)."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"This criterion assesses the identification of vertical asymptotes of a rational function, which is covered in Unit 1, Topic 1.9 (Rational Functions and Vertical Asymptotes)."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"This criterion assesses the identification of horizontal asymptotes of a rational function based on end behavior, which is covered in Unit 1, Topic 1.7 (Rational Functions and End Behavior)."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"This criterion requires setting up an equation involving a rational function, which is a direct application of rational function understanding from Unit 1. Solving equations is a general skill, but the function type places it in Unit 1 context."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"This criterion requires solving the rational equation set up in the previous step, which is an application of rational function properties and algebraic manipulation from Unit 1."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5106,"completion_tokens":1966,"total_tokens":7072,"cost":0.00534601,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4077,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1378,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00534601,"gateway_cost":0.00534601}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'd03e90ebd814534b9ea113b0835265efcaae432a9662e2db1f4188adad9a99b5'
    ),
(
      'baa26e29-08dd-47f7-adb2-7465c39ad70b'::uuid,
      'fa9e0ce7-fead-4d9c-85fd-620dedd7615f'::uuid,
      '374e177656ff7e5233278035e9f84d95eaeb19c17852b4f1bdc8ae80218c1aab',
      array[3]::integer[],
      3,
      '[{"criterion_key":"part-a-criterion-01","units":[3],"evidence":"Finding five consecutive key points for one cycle of a periodic Ferris wheel height model requires sinusoidal/periodic function behavior."},{"criterion_key":"part-a-criterion-02","units":[3],"evidence":"Computing the midline from the maximum and minimum heights is part of constructing and interpreting a sinusoidal model."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Constructing H(t)=12-10cos((pi/20)t) requires sinusoidal function parameters: amplitude, midline, period, and reflection/phase alignment."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Justifying amplitude, midline, and converting a 40-second period to b=2pi/40 uses sinusoidal model parameter interpretation."},{"criterion_key":"part-c-criterion-01","units":[3],"evidence":"Determining that H is increasing on the first quarter-cycle uses qualitative behavior of a sinusoidal function."},{"criterion_key":"part-c-criterion-02","units":[3],"evidence":"Determining that the rate of change is increasing/graph is concave up on the first quarter-cycle uses qualitative behavior of a sinusoidal function in a periodic context."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":15904,"output":{"content_key":"apprecalc-frq-np2-006","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":"The scored work requires sinusoidal key points, midline, amplitude, period-to-parameter conversion, and qualitative behavior of a sinusoidal model. No Unit 4 content, derivatives, integrals, or limit-based reasoning is required."},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[3],"evidence":"Finding five consecutive key points for one cycle of a periodic Ferris wheel height model requires sinusoidal/periodic function behavior."},{"criterion_key":"part-a-criterion-02","units":[3],"evidence":"Computing the midline from the maximum and minimum heights is part of constructing and interpreting a sinusoidal model."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Constructing H(t)=12-10cos((pi/20)t) requires sinusoidal function parameters: amplitude, midline, period, and reflection/phase alignment."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Justifying amplitude, midline, and converting a 40-second period to b=2pi/40 uses sinusoidal model parameter interpretation."},{"criterion_key":"part-c-criterion-01","units":[3],"evidence":"Determining that H is increasing on the first quarter-cycle uses qualitative behavior of a sinusoidal function."},{"criterion_key":"part-c-criterion-02","units":[3],"evidence":"Determining that the rate of change is increasing/graph is concave up on the first quarter-cycle uses qualitative behavior of a sinusoidal function in a periodic context."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5005,"completion_tokens":1687,"total_tokens":6692,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.058355,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1196,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.058355}},{"model":"google/gemini-2.5-flash","ok":true,"ms":12584,"output":{"content_key":"apprecalc-frq-np2-006","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[3],"evidence":"Identifying key points (min, midline, max) of a sinusoidal function based on its properties (period, amplitude, midline) is covered in Unit 3 (e.g., Topics 3.4, 3.5, 3.6)."},{"criterion_key":"part-a-criterion-02","units":[3],"evidence":"Calculating the midline from maximum and minimum values is a fundamental property of sinusoidal functions, covered in Unit 3 (e.g., Topics 3.5, 3.6)."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Constructing a sinusoidal model from given contextual information (max, min, period, initial condition) is a core skill in Unit 3 (Topics 3.5, 3.6, 3.7)."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Justifying parameters like amplitude, midline, and the ''b'' parameter (from period) for a sinusoidal function is central to Unit 3 (Topics 3.5, 3.6)."},{"criterion_key":"part-c-criterion-01","units":[3],"evidence":"Determining intervals where a sinusoidal function is increasing or decreasing based on its graph and key points is covered in Unit 3 (e.g., Topics 3.4, 3.5)."},{"criterion_key":"part-c-criterion-02","units":[3],"evidence":"Analyzing whether the rate of change of a sinusoidal function is increasing or decreasing (corresponding to concavity) using Precalculus-appropriate language (e.g., ''concave up'' or describing the behavior of the rate of rise) is a Unit 3 skill, as confirmed by the fact-pack''s guidance on concavity in periodic contexts and avoiding calculus-register language."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5296,"completion_tokens":2485,"total_tokens":7781,"cost":0.00670024,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4078,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1822,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00670024,"gateway_cost":0.00670024}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '0b6cf4a440251f9006bb22cdff0e0dc71e488912fa0f3857fd98aaf6d8bb63d9'
    ),
(
      'f17d01b9-3996-433f-89ae-6e5e716de5fd'::uuid,
      'a4100b8c-f820-4dfa-9e76-e7c4b271152c'::uuid,
      '4a8aab8224b6b2bdd5887b3f2e1a0dd8e6d051ada04745e2eb684e4cdb30a034',
      '{}'::integer[],
      null,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'held',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"model_unit_disagreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":9271,"output":{"content_key":"apprecalc-frq-np2-007","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":"The scored criteria require logarithmic manipulation/equations and trigonometric equation solving, all within AP Precalculus Units 2 and 3. No Unit 4, calculus, or other out-of-scope content is required."},"required_units":[2,3],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"Applies the logarithm power property to rewrite 2 log_3(y) as log_3(y^2), which is logarithmic expression manipulation."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"Combines logarithmic terms into a single logarithm using product and quotient-style manipulation."},{"criterion_key":"part-b-criterion-01","units":[2],"evidence":"Converts a logarithmic equation to exponential form."},{"criterion_key":"part-b-criterion-02","units":[2],"evidence":"Solves a logarithmic equation and checks the logarithm domain condition."},{"criterion_key":"part-c-criterion-01","units":[3],"evidence":"Uses substitution u = cos(x) to solve a trigonometric equation."},{"criterion_key":"part-c-criterion-02","units":[3],"evidence":"Finds all solutions to cosine equations on [0, 2π), requiring trigonometric equation solving and unit-circle cosine values."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4890,"completion_tokens":962,"total_tokens":5852,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.03603,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":516,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.03603}},{"model":"google/gemini-2.5-flash","ok":true,"ms":17329,"output":{"content_key":"apprecalc-frq-np2-007","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1,2,3],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"Applies the power property of logarithms (Unit 2, Topic 2.12)."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"Combines logarithms using product and quotient properties (Unit 2, Topic 2.12)."},{"criterion_key":"part-b-criterion-01","units":[2],"evidence":"Converts a logarithmic equation to exponential form (Unit 2, Topics 2.10, 2.13)."},{"criterion_key":"part-b-criterion-02","units":[2],"evidence":"Solves an exponential equation and verifies the domain of a logarithmic function (Unit 2, Topics 2.11, 2.13)."},{"criterion_key":"part-c-criterion-01","units":[1,3],"evidence":"Recognizes and factors a quadratic equation in terms of a trigonometric function (Unit 1 for quadratic factoring, Unit 3 for trigonometric context). The fact-pack notes ''hidden quadratics'' as a skill in other units, but the core factoring skill is Unit 1."},{"criterion_key":"part-c-criterion-02","units":[3],"evidence":"Solves trigonometric equations for specific values within a given interval (Unit 3, Topic 3.10)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5150,"completion_tokens":3288,"total_tokens":8438,"cost":0.00866421,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4077,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":2729,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00866421,"gateway_cost":0.00866421}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'c224ac9e1cbacddd2da4dd47a506cc951acf8a915139373ebe8a771fe32aba34'
    ),
(
      '865d0749-0361-4bd0-b48d-024e61410c04'::uuid,
      '0c6f5ac1-a8a6-4ab4-bd2c-fd380150114f'::uuid,
      'eb23e39e052e3931ad5f73e2376dc78c423f44a811a4c0c7bde3146af0bca476',
      '{}'::integer[],
      null,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'held',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"rubric_preflight_failure","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":10266,"output":{"content_key":"apprecalc-frq-np2-008","rubric_preflight":{"status":"fail","findings":["part-c-criterion-01 scores an unasked operation: the prompt asks for the y-coordinate of the local maximum, but this criterion awards a point for reporting the x-location."]},"scope_violation":{"status":"none","evidence":"No Precalculus Unit 4, calculus, or other out-of-scope content is required by the prompt."},"required_units":[],"primary_unit":null,"criterion_units":[],"uncertainty_flags":["Rubric preflight failed; unit labels withheld rather than forced."]},"usage":{"prompt_tokens":4932,"completion_tokens":1095,"total_tokens":6027,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.04023,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":918,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.04023}},{"model":"google/gemini-2.5-flash","ok":true,"ms":8582,"output":{"content_key":"apprecalc-frq-np2-008","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Identifying zeros and their multiplicities for polynomial functions is covered in Unit 1 (e.g., Topic 1.4, 1.5)."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Describing the end behavior of polynomial functions using limit notation is explicitly covered in Unit 1, Topic 1.6."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Relating the multiplicity of a zero to the local behavior of a polynomial graph (tangency, turning points, local extrema) is a core concept in Unit 1 (e.g., Topic 1.4, 1.6)."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Contrasting polynomial behavior at zeros based on odd vs. even multiplicity is a core concept in Unit 1 (e.g., Topic 1.4, 1.6)."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Identifying local extrema of polynomial functions, often with the aid of technology, is part of understanding function behavior in Unit 1 (e.g., Topic 1.3)."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Approximating the value of local extrema of polynomial functions using technology is part of understanding function behavior in Unit 1 (e.g., Topic 1.3)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5180,"completion_tokens":1804,"total_tokens":6984,"cost":0.00496321,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4077,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1220,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00496321,"gateway_cost":0.00496321}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '680664c263cff2633d0371138bec50dff7bab17081cd653ebaf7f8350ff73e7a'
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
