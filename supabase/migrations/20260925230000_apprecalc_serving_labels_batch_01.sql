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
      'ebcc3300-7c1c-4a92-9410-db134babd4a2'::uuid,
      'd06a4fe4-42e1-4937-bfd5-25e119b9c5c7'::uuid,
      'eae454842c2d161f4e4a1c05c15d5a3275bc6f00e31b6fb2f1ebd7d51b62cf2f',
      array[2]::integer[],
      2,
      '[{"criterion_key":"part-a-criterion-1","units":[2],"evidence":"Evaluating D(5)=48(0.82)^5 uses an exponential function model."},{"criterion_key":"part-a-criterion-2","units":[2],"evidence":"Interpreting the value of an exponential context model as excess temperature after 5 minutes is Unit 2 exponential-function context interpretation."},{"criterion_key":"part-b-criterion-1","units":[2],"evidence":"Solving 48(0.82)^t=10 by using logarithms is an exponential/logarithmic equation."},{"criterion_key":"part-b-criterion-2","units":[2],"evidence":"Determining the time interval for which a decreasing exponential model is below a threshold relies on exponential-function behavior."},{"criterion_key":"part-c-criterion-1","units":[2],"evidence":"Explaining that exponential decay removes a constant percent of the current amount each minute is Unit 2 exponential-change reasoning."},{"criterion_key":"part-c-criterion-2","units":[2],"evidence":"Contrasting exponential decay with a linear model that subtracts a constant absolute amount is part of Unit 2 linear-versus-exponential change reasoning."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":10202,"output":{"content_key":"apprecalc-frq-007","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":"The item requires evaluating and interpreting an exponential decay model, solving an exponential equation using logarithms, and distinguishing exponential decay from a linear decrease. This is within AP Precalculus Units 1-3 and does not require Unit 4 or calculus."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-1","units":[2],"evidence":"Evaluating D(5)=48(0.82)^5 uses an exponential function model."},{"criterion_key":"part-a-criterion-2","units":[2],"evidence":"Interpreting the value of an exponential context model as excess temperature after 5 minutes is Unit 2 exponential-function context interpretation."},{"criterion_key":"part-b-criterion-1","units":[2],"evidence":"Solving 48(0.82)^t=10 by using logarithms is an exponential/logarithmic equation."},{"criterion_key":"part-b-criterion-2","units":[2],"evidence":"Determining the time interval for which a decreasing exponential model is below a threshold relies on exponential-function behavior."},{"criterion_key":"part-c-criterion-1","units":[2],"evidence":"Explaining that exponential decay removes a constant percent of the current amount each minute is Unit 2 exponential-change reasoning."},{"criterion_key":"part-c-criterion-2","units":[2],"evidence":"Contrasting exponential decay with a linear model that subtracts a constant absolute amount is part of Unit 2 linear-versus-exponential change reasoning."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4815,"completion_tokens":1022,"total_tokens":5837,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.037455,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":551,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.037455}},{"model":"google/gemini-2.5-flash","ok":true,"ms":16765,"output":{"content_key":"apprecalc-frq-007","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-1","units":[2],"evidence":"Evaluating an exponential function D(t)=48(0.82)^t at t=5. This is covered in Unit 2, specifically Topic 2.3 (Exponential Functions) and 2.5 (Exponential Function Context and Data Modeling)."},{"criterion_key":"part-a-criterion-2","units":[2],"evidence":"Interpreting the output of an exponential function in context. This is covered in Unit 2, Topic 2.5 (Exponential Function Context and Data Modeling)."},{"criterion_key":"part-b-criterion-1","units":[2],"evidence":"Solving an exponential equation 48(0.82)^t = 10 using logarithms. This is covered in Unit 2, Topic 2.13 (Exponential and Logarithmic Equations and Inequalities)."},{"criterion_key":"part-b-criterion-2","units":[2],"evidence":"Solving an exponential inequality 48(0.82)^t < 10 and stating the interval. This is covered in Unit 2, Topic 2.13 (Exponential and Logarithmic Equations and Inequalities)."},{"criterion_key":"part-c-criterion-1","units":[2],"evidence":"Explaining the nature of exponential decay (percentage of current amount). This is covered in Unit 2, Topic 2.3 (Exponential Functions) and 2.5 (Exponential Function Context and Data Modeling)."},{"criterion_key":"part-c-criterion-2","units":[2],"evidence":"Explaining the nature of linear change (same absolute amount) and comparing it to exponential change. This is covered in Unit 2, Topic 2.2 (Change in Linear and Exponential Functions) and 2.6 (Competing Function Model Validation)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5106,"completion_tokens":3487,"total_tokens":8593,"cost":0.00914851,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4077,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":2851,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00914851,"gateway_cost":0.00914851}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '230177aaf63bb2202efda1e660d306e8f9ec10a2bb72a91ebdb1e88e01b4df49'
    ),
(
      '3bea9948-b8c8-4c53-bee1-a4ca6a9c4bb7'::uuid,
      'ba17ab7a-808a-4c24-8244-996ba74d7497'::uuid,
      'c3f0e62f0cb591f505ced8e29bb2f706d01fdf87e734dce1adf3db320f8846ee',
      array[2]::integer[],
      2,
      '[{"criterion_key":"part-a","units":[2],"evidence":"Solving log₂(x−3)=4 requires understanding logarithmic equations and logarithms as inverses of exponential functions."},{"criterion_key":"part-b","units":[2],"evidence":"Solving 2^(x+1)=32 requires exponential equation solving."},{"criterion_key":"part-c","units":[2],"evidence":"Rewriting 2^(log₂(x−3)+1) without logarithms and preserving the original domain requires logarithmic/exponential inverse relationships and logarithmic domain reasoning."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":{"label_status":"legacy_unvalidated","required_units":[],"max_required_unit":null,"primary_unit":null,"source":"legacy_prompt_json"},"models":[{"model":"openai/gpt-5.5","ok":true,"ms":4834,"output":{"content_key":"apprecalc-frq-032","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":"All scored work involves exponential and logarithmic equations, inverse-function/logarithm rules, and domain preservation, which are AP Precalculus Unit 2 topics."},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a","units":[2],"evidence":"Solving log₂(x−3)=4 requires understanding logarithmic equations and logarithms as inverses of exponential functions."},{"criterion_key":"part-b","units":[2],"evidence":"Solving 2^(x+1)=32 requires exponential equation solving."},{"criterion_key":"part-c","units":[2],"evidence":"Rewriting 2^(log₂(x−3)+1) without logarithms and preserving the original domain requires logarithmic/exponential inverse relationships and logarithmic domain reasoning."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":4838,"completion_tokens":431,"total_tokens":5269,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":3840,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.01984,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":149,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.01984}},{"model":"google/gemini-2.5-flash","ok":true,"ms":7976,"output":{"content_key":"apprecalc-frq-032","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a","units":[2],"evidence":"Solving logarithmic equations (2.13) and understanding the domain of logarithmic functions (2.11)."},{"criterion_key":"part-b","units":[2],"evidence":"Solving exponential equations (2.13) by recognizing equivalent bases (2.3)."},{"criterion_key":"part-c","units":[2],"evidence":"Manipulating exponential expressions (2.4), using properties of logarithms (2.9), applying inverse function properties between exponentials and logarithms (2.10), and stating the domain of a logarithmic expression (2.11)."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5142,"completion_tokens":1860,"total_tokens":7002,"cost":0.00509181,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4077,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1541,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00509181,"gateway_cost":0.00509181}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'f37430caae12cff4241556adad950bd425da60fec81072e5cfc44753a90ffcfd'
    ),
(
      '2096cfbf-7be5-4e9a-88bb-6f670cd6a7fd'::uuid,
      '2bbab2ae-7ca1-42b4-915d-b67de9417969'::uuid,
      'e233ed78dbf976a8986f6a5f8638a7bdd1e3dbb4a8b31d2e17f42e1fd728368c',
      '{}'::integer[],
      null,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'held',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"other","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":10171,"output":{"content_key":"apprecalc-frq-np2-001","rubric_preflight":{"status":"pass","findings":["Each scoring criterion maps to an explicitly asked operation in parts (a), (b), or (c).","All prompt parts have scoring coverage.","No criterion scores an unasked operation."]},"scope_violation":{"status":"other","evidence":"Part (b) explicitly asks students to evaluate a limit as x approaches infinity using limit notation. AP Precalculus may assess rational end behavior, but scored AP Precalculus practice should not introduce calculus or limit-based reasoning."},"required_units":[1,2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"Finding f(g(2)) from function values requires composition of functions."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"Finding g^-1(4) from a table requires interpreting an inverse function."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"The intended mathematical content is rational-function end behavior, though the use of limit notation creates a scope concern."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Computing the horizontal end behavior of a rational function using leading coefficients is Unit 1 rational-function end behavior."},{"criterion_key":"part-c-criterion-01","units":[2],"evidence":"Classifying data as exponential requires recognizing exponential-function behavior."},{"criterion_key":"part-c-criterion-02","units":[2],"evidence":"Justifying exponential behavior using a constant ratio over equal input intervals is Unit 2 exponential-function model validation."}],"uncertainty_flags":["Part (b) is teachable as Unit 1 rational end behavior, but the prompt''s required limit notation is outside AP Precalculus exam-style scope."]},"usage":{"prompt_tokens":4987,"completion_tokens":1061,"total_tokens":6048,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":4864,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.034877,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":516,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.034877}},{"model":"google/gemini-2.5-flash","ok":true,"ms":10367,"output":{"content_key":"apprecalc-frq-np2-001","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1,2],"primary_unit":2,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[2],"evidence":"Finding f(g(2)) requires understanding function composition, which is covered in Unit 2, Topic 2.7."},{"criterion_key":"part-a-criterion-02","units":[2],"evidence":"Finding g^-1(4) requires understanding inverse functions, which is covered in Unit 2, Topic 2.8."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Evaluating the limit as x approaches infinity for a rational function and using limit notation is covered in Unit 1, Topic 1.7 Rational Functions and End Behavior."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Computing the end behavior of a rational function using the ratio of leading coefficients is covered in Unit 1, Topic 1.7 Rational Functions and End Behavior."},{"criterion_key":"part-c-criterion-01","units":[2],"evidence":"Identifying a function as exponential from data is covered in Unit 2, Topic 2.5 Exponential Function Context and Data Modeling and Topic 2.6 Competing Function Model Validation."},{"criterion_key":"part-c-criterion-02","units":[2],"evidence":"Justifying an exponential model by showing a constant ratio of consecutive outputs for equal input intervals is a core concept in Unit 2, Topic 2.5 Exponential Function Context and Data Modeling. The fact-pack explicitly notes this reasoning pattern as critical for this type of question."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5244,"completion_tokens":1944,"total_tokens":7188,"cost":0.0064332,"is_byok":false,"prompt_tokens_details":{"cached_tokens":0,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1358,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.0064332,"gateway_cost":0.0064332}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      'e27abbf13a6e7c06a4b4178d1bc2b487e70b22018791d33b01f76784d41bfcda'
    ),
(
      'fffd72fc-9aeb-44d4-acc1-ec245a4e1f15'::uuid,
      'b7a5d9ba-b504-42a6-b66e-07903533e2d8'::uuid,
      'e83528e298cd96bd6642ab9fe8fa54a6de5431230efd2ab1c31172af3787b16c',
      array[1]::integer[],
      1,
      '[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Setting up equations from data for a quadratic polynomial model is polynomial model construction."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Solving for coefficients of a quadratic polynomial model supports polynomial model construction and representation."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Computing average rate of change using (P(4)-P(2))/(4-2) is Unit 1 rates-of-change work."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Interpreting average rate of change in context is required for Unit 1 function behavior and modeling."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Using a secant line to estimate a value from a polynomial model relies on Unit 1 rates of change and graph behavior."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Justifying underestimation using concavity of a quadratic polynomial from the sign of the leading coefficient is Unit 1 polynomial graph behavior, without requiring calculus."}]'::jsonb,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'provisional_model',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"two_model_unit_agreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":9551,"output":{"content_key":"apprecalc-frq-np2-002","rubric_preflight":{"status":"pass","findings":["Each rubric criterion maps to an asked operation in parts (a), (b), or (c).","All prompt parts have scoring coverage.","No criterion scores an unasked operation."]},"scope_violation":{"status":"none","evidence":"The scored work uses polynomial/quadratic modeling, average rate of change, secant-line estimation, and non-calculus concavity reasoning, all within AP Precalculus Units 1-3."},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Setting up equations from data for a quadratic polynomial model is polynomial model construction."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Solving for coefficients of a quadratic polynomial model supports polynomial model construction and representation."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Computing average rate of change using (P(4)-P(2))/(4-2) is Unit 1 rates-of-change work."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Interpreting average rate of change in context is required for Unit 1 function behavior and modeling."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Using a secant line to estimate a value from a polynomial model relies on Unit 1 rates of change and graph behavior."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Justifying underestimation using concavity of a quadratic polynomial from the sign of the leading coefficient is Unit 1 polynomial graph behavior, without requiring calculus."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5000,"completion_tokens":924,"total_tokens":5924,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":4864,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.030832,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":394,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.030832}},{"model":"google/gemini-2.5-flash","ok":true,"ms":13215,"output":{"content_key":"apprecalc-frq-np2-002","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1],"primary_unit":1,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[1],"evidence":"Setting up a system of equations to find parameters for a polynomial model (P(t) = at^2 + bt + c) aligns with Unit 1 topics on Polynomial Functions (1.4) and Function Model Construction (1.14)."},{"criterion_key":"part-a-criterion-02","units":[1],"evidence":"Solving the system of equations to determine the coefficients of a polynomial model aligns with Unit 1 topics on Polynomial Functions (1.4) and Function Model Construction (1.14)."},{"criterion_key":"part-b-criterion-01","units":[1],"evidence":"Computing the average rate of change using the formula [f(b)-f(a)]/(b-a) is a core skill in Unit 1, specifically Topics 1.2 (Rates of Change) and 1.3 (Rates of Change and Behavior of Graphs)."},{"criterion_key":"part-b-criterion-02","units":[1],"evidence":"Interpreting the average rate of change in context with appropriate units is part of Unit 1, Topics 1.2 (Rates of Change) and 1.3 (Rates of Change and Behavior of Graphs)."},{"criterion_key":"part-c-criterion-01","units":[1],"evidence":"Using a secant line to estimate a function value (linear interpolation) is an application of average rate of change and function behavior, covered in Unit 1 (1.2, 1.3)."},{"criterion_key":"part-c-criterion-02","units":[1],"evidence":"Justifying an overestimate/underestimate using concavity for a polynomial function (quadratic in this case, where concavity is determined by the leading coefficient ''a'') is a key aspect of understanding the Behavior of Graphs (1.3) and Polynomial Functions (1.4). The fact pack explicitly notes this type of concavity reasoning for secant line estimates as a Unit 1 skill."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5258,"completion_tokens":2650,"total_tokens":7908,"cost":0.00710134,"is_byok":false,"prompt_tokens_details":{"cached_tokens":4078,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":1969,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.00710134,"gateway_cost":0.00710134}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '3dedf8602009a5041aa4e597d0801dcc80ed34c2cf852e29ed3ee7195a6f481f'
    ),
(
      '3ee1a438-5b80-4fc5-8bf4-abd10ef87e0f'::uuid,
      '470074a2-c95e-4d76-a866-c2fcde2fb16b'::uuid,
      '70f4b6ab4fa49ab46fac0dfcbae822983dd4bee8be90c57477768678035b054b',
      '{}'::integer[],
      null,
      null,
      '16383753-6775-430d-960a-544cd6ee0972'::uuid,
      'held',
      '{"run_id":"serving-units-mcp-2026-09-25-20260926030633","reason":"model_unit_disagreement","scope":"serving_only","coverage_deferred":true,"mode":"cold_label","legacy_serving_label":null,"models":[{"model":"openai/gpt-5.5","ok":true,"ms":11161,"output":{"content_key":"apprecalc-frq-np2-003","rubric_preflight":{"status":"pass","findings":["Each scoring criterion maps to an asked prompt part: part (a) key points and midline, part (b) cosine model construction, and part (c) increasing/decreasing behavior and rate-of-change behavior on the specified interval.","No criterion scores an operation outside the prompt; the parameter justification criterion is treated as supporting the requested construction of a cosine model."]},"scope_violation":{"status":"none","evidence":"The item requires sinusoidal modeling, periodic key points, midline, period-to-parameter conversion, and qualitative behavior of a sinusoidal function, all within AP Precalculus Unit 3. It does not require Unit 4 content or calculus-based derivative reasoning."},"required_units":[3],"primary_unit":3,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[3],"evidence":"Finding five consecutive key points one quarter-period apart for a periodic tide model requires sinusoidal function structure and periodic phenomena."},{"criterion_key":"part-a-criterion-02","units":[3],"evidence":"Determining the midline from maximum and minimum values is part of constructing and interpreting a sinusoidal function."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Constructing a cosine model with amplitude, midline, period, and phase shift is sinusoidal function modeling."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Justifying amplitude, midline, period-to-b conversion, and horizontal shift is parameter interpretation for a sinusoidal function."},{"criterion_key":"part-c-criterion-01","units":[3],"evidence":"Identifying increasing or decreasing behavior on an interval of a sinusoidal model is Unit 3 function behavior."},{"criterion_key":"part-c-criterion-02","units":[3],"evidence":"Describing the rate of change as increasing via concavity/leveling-off behavior for a sinusoidal context is qualitative Unit 3 sinusoidal behavior, not calculus derivative reasoning."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5029,"completion_tokens":1075,"total_tokens":6104,"cost":0,"is_byok":true,"prompt_tokens_details":{"cached_tokens":4864,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":0.035507,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":516,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.035507}},{"model":"google/gemini-2.5-flash","ok":true,"ms":18365,"output":{"content_key":"apprecalc-frq-np2-003","rubric_preflight":{"status":"pass","findings":[]},"scope_violation":{"status":"none","evidence":""},"required_units":[1,3],"primary_unit":3,"criterion_units":[{"criterion_key":"part-a-criterion-01","units":[3],"evidence":"Identifying key points (max, min, midline crossings) of a sinusoidal function based on its characteristics (amplitude, period, phase shift, midline) is covered in Unit 3 (e.g., 3.4, 3.5)."},{"criterion_key":"part-a-criterion-02","units":[3],"evidence":"Calculating the midline of a sinusoidal function from its maximum and minimum values is a fundamental aspect of sinusoidal functions, covered in Unit 3 (e.g., 3.5, 3.6)."},{"criterion_key":"part-b-criterion-01","units":[3],"evidence":"Constructing a sinusoidal function model from given characteristics (amplitude, midline, period, phase shift) is a core skill in Unit 3 (e.g., 3.5, 3.6, 3.7)."},{"criterion_key":"part-b-criterion-02","units":[3],"evidence":"Deriving and justifying the parameters (amplitude, midline, period, ''b'' value, phase shift) for a sinusoidal model from contextual information is covered in Unit 3 (e.g., 3.5, 3.6, 3.7)."},{"criterion_key":"part-c-criterion-01","units":[3],"evidence":"Determining intervals where a sinusoidal function is increasing or decreasing based on its graph or characteristics is covered in Unit 3 (e.g., 3.4, 3.5)."},{"criterion_key":"part-c-criterion-02","units":[1,3],"evidence":"Analyzing the behavior of the rate of change (concavity, i.e., whether the rate of change is increasing or decreasing) of a sinusoidal function requires the general understanding of ''Rates of Change and Behavior of Graphs'' from Unit 1 (1.3) applied to the specific context of a Unit 3 sinusoidal function."}],"uncertainty_flags":[]},"usage":{"prompt_tokens":5280,"completion_tokens":3549,"total_tokens":8829,"cost":0.0104565,"is_byok":false,"prompt_tokens_details":{"cached_tokens":0,"audio_tokens":0,"video_tokens":0},"cost_details":{"upstream_inference_cost":null,"upstream_inference_prompt_cost":0,"upstream_inference_completions_cost":0},"completion_tokens_details":{"reasoning_tokens":2872,"image_tokens":0},"cache_creation_input_tokens":0,"market_cost":0.0104565,"gateway_cost":0.0104565}}]}'::jsonb,
      'serving-units-mcp-2026-09-25-20260926030633',
      '40474a80f94324e39acfc1d6a210839400aee88e54c871fedc86cdd98c953f59'
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
