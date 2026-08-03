begin;
do $stats_precalc_units1_2$
declare
  v_epv_id uuid;
  v_epv_count integer;
begin
  select count(*) into v_epv_count
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_precalculus'
    and epv.status = 'published';

  if v_epv_count <> 1 then
    raise exception 'expected_exactly_one_published_exam_pack_version:%:%', 'ap_precalculus', v_epv_count;
  end if;

  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_precalculus'
    and epv.status = 'published';

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-001'
      and id <> '099220f9-795d-4659-a5ef-1477bcc2afe1'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-001';
  end if;

  if not exists (
    select 1 from app.content_items where id = '099220f9-795d-4659-a5ef-1477bcc2afe1'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '099220f9-795d-4659-a5ef-1477bcc2afe1'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-001',
      'frq',
      'Average Rate of Change from a Table',
      'draft',
      'short',
      'targeted_drill',
      'Function Concepts'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '5df7d10b-8939-42f7-ad20-1df768981245'::uuid,
      '099220f9-795d-4659-a5ef-1477bcc2afe1'::uuid,
      1,
      'Average Rate of Change from a Table: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'The function f is defined for all real numbers. Selected values of f are given in the table below. A graphing calculator is permitted for this item.

Table 1: Values of f(x)
x | 0 | 2 | 4 | 6 | 8
f(x) | 3 | 7 | 15 | 27 | 43',
      '{"content_key":"apprecalc-frq-u12-001","subject":"ap_precalculus","unit":1,"topic":"1.2 Rates of Change","archetype":"Function Concepts","difficulty":"Easy","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the average rate of change of f on the interval [0,4] and on the interval [4,8]. Show the difference quotient used for each.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"State which interval from part A has the larger average rate of change, and use this comparison to describe whether the graph of f is increasing at an increasing rate or a decreasing rate over [0,8].","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Using the average rate of change on [6,8], write a linear approximation to estimate f(10). Then explain whether this estimate is likely too high or too low, based on the behavior described in part B.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Average Rate of Change from a Table: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('797307b1-6458-471b-a148-26f69c057c90'::uuid, '5df7d10b-8939-42f7-ad20-1df768981245'::uuid, 'part-a-criterion-01', 'Correctly computes the average rate of change on [0,4].', 1, 'Response shows (15-3)/(4-0) = 3.', 'Show the quotient (f(4)-f(0))/(4-0) using the table values and simplify to 3.', '[]'::jsonb),
      ('b79fab16-7d9a-4295-a019-e77c90d59b37'::uuid, '5df7d10b-8939-42f7-ad20-1df768981245'::uuid, 'part-a-criterion-02', 'Correctly computes the average rate of change on [4,8].', 1, 'Response shows (43-15)/(8-4) = 7.', 'Show the quotient (f(8)-f(4))/(8-4) using the table values and simplify to 7.', '[]'::jsonb),
      ('bf6977a8-b498-4cc9-a1e0-21a5844ee928'::uuid, '5df7d10b-8939-42f7-ad20-1df768981245'::uuid, 'part-b-criterion-01', 'Correctly identifies [4,8] as having the larger average rate of change (7 > 3).', 1, 'Response explicitly compares the two values from part A and names the correct interval.', 'State that 7 (on [4,8]) is greater than 3 (on [0,4]).', '[]'::jsonb),
      ('0930daa3-2597-4d6b-a432-0d00156c6c8c'::uuid, '5df7d10b-8939-42f7-ad20-1df768981245'::uuid, 'part-b-criterion-02', 'Correctly concludes the graph is increasing at an increasing rate (consistent with concave up behavior) on [0,8].', 1, 'Response links the increasing average rate of change to the graph increasing faster and faster.', 'Explain that since the average rate of change increases as x increases, f is increasing at an increasing rate.', '[]'::jsonb),
      ('6df27c88-112c-4c77-af82-36ef4e9a5571'::uuid, '5df7d10b-8939-42f7-ad20-1df768981245'::uuid, 'part-c-criterion-01', 'Produces a correct linear estimate for f(10) using the rate of change on [6,8].', 1, 'Response computes (27 to 43 gives rate 8 on [6,8]) and estimates f(10) ≈ 43 + 8(2) = 59.', 'Compute the average rate of change on [6,8] from the table, then extend f(8)=43 by that rate over 2 more units.', '[]'::jsonb),
      ('94652918-c53e-4770-ad6e-dc25cecc41a3'::uuid, '5df7d10b-8939-42f7-ad20-1df768981245'::uuid, 'part-c-criterion-02', 'Correctly reasons the estimate is an underestimate because the function''s rate of change keeps increasing (concave up) beyond x=8.', 1, 'Response states that since the rate of change is growing, using a constant rate underestimates the true value of f(10).', 'Explain that because the average rate of change has been increasing across the table, a linear extension using the [6,8] rate will underestimate f(10).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-002'
      and id <> '6c650d50-32ad-4df4-a6a6-8beb64a6a922'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-002';
  end if;

  if not exists (
    select 1 from app.content_items where id = '6c650d50-32ad-4df4-a6a6-8beb64a6a922'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '6c650d50-32ad-4df4-a6a6-8beb64a6a922'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-002',
      'frq',
      'Simplifying and Solving Logarithmic Expressions',
      'draft',
      'short',
      'targeted_drill',
      'Symbolic Manipulations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '100c521c-b604-4837-a3f9-cc36bc61cb78'::uuid,
      '6c650d50-32ad-4df4-a6a6-8beb64a6a922'::uuid,
      1,
      'Simplifying and Solving Logarithmic Expressions: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'No calculator is permitted for this item. All work must use exact values and properties of logarithms.',
      '{"content_key":"apprecalc-frq-u12-002","subject":"ap_precalculus","unit":2,"topic":"2.9 Logarithmic Expressions","archetype":"Symbolic Manipulations","difficulty":"Easy","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Write log_2(32) - log_2(4) as a single logarithm, and then evaluate it to an exact integer.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Fully expand ln(x^3 * sqrt(y) / z^2) using properties of logarithms.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Solve log_5(x) + log_5(x-4) = log_5(21) exactly for x, and justify why any extraneous solution must be rejected.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Simplifying and Solving Logarithmic Expressions: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('c8843282-e1a9-4da7-a129-95b29d426036'::uuid, '100c521c-b604-4837-a3f9-cc36bc61cb78'::uuid, 'part-a-criterion-01', 'Correctly combines the difference of logs into a single logarithm using the quotient property.', 1, 'Response shows log_2(32) - log_2(4) = log_2(32/4) = log_2(8).', 'Apply the property log_b(m) - log_b(n) = log_b(m/n) to combine the expression.', '[]'::jsonb),
      ('4e8bb21a-f05c-4e28-abdc-8b5b2d9e74f5'::uuid, '100c521c-b604-4837-a3f9-cc36bc61cb78'::uuid, 'part-a-criterion-02', 'Correctly evaluates the resulting logarithm to the exact value 3.', 1, 'Response states log_2(8) = 3, since 2^3 = 8.', 'Rewrite log_2(8) as 2^x = 8 and solve for x to get 3.', '[]'::jsonb),
      ('0fc31efb-c02d-4ef5-a7c4-f27f2cfcac17'::uuid, '100c521c-b604-4837-a3f9-cc36bc61cb78'::uuid, 'part-b-criterion-01', 'Correctly applies the product and quotient properties to separate the expression into three log terms.', 1, 'Response shows ln(x^3) + ln(y^(1/2)) - ln(z^2).', 'Rewrite the single logarithm as a sum/difference of logs of each factor before applying the power rule.', '[]'::jsonb),
      ('721a85a5-3689-4959-a575-b0bdec8e810b'::uuid, '100c521c-b604-4837-a3f9-cc36bc61cb78'::uuid, 'part-b-criterion-02', 'Correctly applies the power property to each term, yielding 3ln(x) + (1/2)ln(y) - 2ln(z).', 1, 'Response arrives at the fully expanded exact form 3ln(x) + (1/2)ln(y) - 2ln(z).', 'Bring each exponent down as a coefficient using ln(a^k) = k ln(a).', '[]'::jsonb),
      ('1466cc4f-f1fc-4428-a753-035bfdc303d8'::uuid, '100c521c-b604-4837-a3f9-cc36bc61cb78'::uuid, 'part-c-criterion-01', 'Correctly combines the logs and forms the equation x(x-4) = 21, solving to get x = 7 or x = -3.', 1, 'Response shows log_5(x(x-4)) = log_5(21) implies x^2-4x-21=0, factoring to (x-7)(x+3)=0.', 'Combine the left side into a single log, set the arguments equal, and solve the resulting quadratic by factoring.', '[]'::jsonb),
      ('eb710154-3f83-4ad4-ae71-d8b8f7f30c31'::uuid, '100c521c-b604-4837-a3f9-cc36bc61cb78'::uuid, 'part-c-criterion-02', 'Correctly rejects x = -3 as extraneous because it is outside the domain (x > 4 required) and states the final answer x = 7.', 1, 'Response explicitly checks that log_5(x) and log_5(x-4) require x > 0 and x > 4, ruling out x = -3.', 'State the domain requirement x > 4 (so both logarithms are defined) and reject the negative solution.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-003'
      and id <> 'a41ce9c5-800e-455e-a50e-6419cedcb9b9'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-003';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'a41ce9c5-800e-455e-a50e-6419cedcb9b9'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'a41ce9c5-800e-455e-a50e-6419cedcb9b9'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-003',
      'frq',
      'Converting Between Factored and Standard Polynomial Forms',
      'draft',
      'short',
      'targeted_drill',
      'Symbolic Manipulations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'b4c69acb-e5df-43b8-ac72-d96b8058d78f'::uuid,
      'a41ce9c5-800e-455e-a50e-6419cedcb9b9'::uuid,
      1,
      'Converting Between Factored and Standard Polynomial Forms: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'Let f(x) = (x-2)(x+1)(x-3). No calculator is permitted for this item; all work must be shown symbolically.',
      '{"content_key":"apprecalc-frq-u12-003","subject":"ap_precalculus","unit":1,"topic":"1.11 Equivalent Representations","archetype":"Symbolic Manipulations","difficulty":"Easy","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Expand f(x) to standard polynomial form, showing intermediate steps.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Using the factored form of f, state all real zeros of f and describe the end behavior of the graph of f, justifying your answer.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Divide the standard form of f(x) from part A by (x+1) using long or synthetic division, and state the resulting quotient.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Converting Between Factored and Standard Polynomial Forms: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ca287b66-e91b-4424-a002-e9f4b28be07f'::uuid, 'b4c69acb-e5df-43b8-ac72-d96b8058d78f'::uuid, 'part-a-criterion-01', 'Correctly multiplies two of the three binomial factors as an intermediate step.', 1, 'Response shows (x-2)(x+1) = x^2 - x - 2 (or equivalent correct intermediate product).', 'Multiply any two of the three linear factors first and simplify before multiplying by the third.', '[]'::jsonb),
      ('05cb8cff-ba78-45fc-a6a8-94efffaaf856'::uuid, 'b4c69acb-e5df-43b8-ac72-d96b8058d78f'::uuid, 'part-a-criterion-02', 'Correctly completes the expansion to the standard form x^3 - 4x^2 + x + 6.', 1, 'Response shows the final simplified polynomial x^3 - 4x^2 + x + 6.', 'Multiply the intermediate quadratic by the remaining linear factor and collect like terms.', '[]'::jsonb),
      ('6051346e-1a89-469d-a36b-cd002d63b9cd'::uuid, 'b4c69acb-e5df-43b8-ac72-d96b8058d78f'::uuid, 'part-b-criterion-01', 'Correctly identifies all three zeros x = 2, x = -1, x = 3 directly from the factors.', 1, 'Response lists x=2, x=-1, x=3 as the zeros, referencing the factored form.', 'Set each factor (x-2), (x+1), (x-3) equal to zero and solve.', '[]'::jsonb),
      ('90b4974f-a34d-4933-a75a-41d82a1ff292'::uuid, 'b4c69acb-e5df-43b8-ac72-d96b8058d78f'::uuid, 'part-b-criterion-02', 'Correctly describes end behavior (f(x) → -∞ as x → -∞ and f(x) → +∞ as x → +∞) with justification based on odd degree and positive leading coefficient.', 1, 'Response explains that the degree is 3 (odd) with a positive leading coefficient, so the ends go in opposite directions.', 'State the degree (3) and leading coefficient (positive 1) of the expanded polynomial and use these to describe end behavior.', '[]'::jsonb),
      ('91cbcd88-695b-413c-a165-de50ed292cba'::uuid, 'b4c69acb-e5df-43b8-ac72-d96b8058d78f'::uuid, 'part-c-criterion-01', 'Correctly sets up and carries out the division process (synthetic or long division) with correct intermediate values.', 1, 'Response shows synthetic division with root -1 on coefficients 1, -4, 1, 6 producing 1, -5, 6, and remainder 0.', 'Use synthetic division with root -1 on the coefficients 1, -4, 1, 6, tracking each step.', '[]'::jsonb),
      ('f77853f2-4b43-49a7-a0f3-aa5fb4fd5ee1'::uuid, 'b4c69acb-e5df-43b8-ac72-d96b8058d78f'::uuid, 'part-c-criterion-02', 'Correctly states the quotient x^2 - 5x + 6 with remainder 0.', 1, 'Response gives the final quotient x^2 - 5x + 6 (equivalent to (x-2)(x-3)).', 'Read the final row of the synthetic division as the coefficients of the quadratic quotient.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-004'
      and id <> '9c085b4f-8eba-4024-a9d5-573f52ce38e4'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-004';
  end if;

  if not exists (
    select 1 from app.content_items where id = '9c085b4f-8eba-4024-a9d5-573f52ce38e4'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '9c085b4f-8eba-4024-a9d5-573f52ce38e4'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-004',
      'frq',
      'Maximizing Weekly Profit with a Quadratic Model',
      'draft',
      'short',
      'targeted_drill',
      'Modeling a Non-Periodic Context'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'cb0ffa9d-84dd-4251-ae5f-70d3a3e690a0'::uuid,
      '9c085b4f-8eba-4024-a9d5-573f52ce38e4'::uuid,
      1,
      'Maximizing Weekly Profit with a Quadratic Model: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A company sells a product at a base price of $20. For a price increase of x dollars (0 ≤ x ≤ 20), the weekly profit is modeled by P(x) = -50x^2 + 800x + 2000 dollars. A graphing calculator is permitted for this item.',
      '{"content_key":"apprecalc-frq-u12-004","subject":"ap_precalculus","unit":1,"topic":"1.14 Function Model Construction and Application","archetype":"Modeling a Non-Periodic Context","difficulty":"Medium","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use your calculator to find the price increase x that maximizes profit, and state the maximum weekly profit.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Use your calculator to find the price increase(s) at which the weekly profit equals zero (break-even), and determine which value(s) are reasonable in context.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"State a reasonable domain for x in this context and explain the real-world restrictions that justify it.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Maximizing Weekly Profit with a Quadratic Model: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('d1cd9431-155f-4054-a97b-f2ba274aaa3e'::uuid, 'cb0ffa9d-84dd-4251-ae5f-70d3a3e690a0'::uuid, 'part-a-criterion-01', 'Correctly identifies x = 8 as the price increase that maximizes profit.', 1, 'Response finds the vertex/maximum of P(x) at x = 8 using calculator graphing or maximum-finding features.', 'Use the calculator''s maximum feature on the graph of P(x), or compute x = -b/(2a) = -800/(2(-50)) = 8.', '[]'::jsonb),
      ('5fda45ed-d105-4d7c-af5e-853694693eb6'::uuid, 'cb0ffa9d-84dd-4251-ae5f-70d3a3e690a0'::uuid, 'part-a-criterion-02', 'Correctly states the maximum profit as $5200.', 1, 'Response evaluates P(8) = -50(64) + 800(8) + 2000 = 5200 and reports $5200.', 'Substitute x = 8 into P(x) to compute the maximum profit value.', '[]'::jsonb),
      ('773c2b18-cc9f-4c90-a6b3-62e508b393f8'::uuid, 'cb0ffa9d-84dd-4251-ae5f-70d3a3e690a0'::uuid, 'part-b-criterion-01', 'Correctly finds both solutions of -50x^2+800x+2000=0 numerically (x ≈ 18.2 and x ≈ -2.2).', 1, 'Response uses the calculator to solve or graph P(x)=0 and reports approximately x ≈ 18.2 and x ≈ -2.2.', 'Graph P(x) and use the zero/root-finding feature, or solve the quadratic equation using the quadratic formula.', '[]'::jsonb),
      ('81f62205-c324-41b3-a708-c90441dfaef2'::uuid, 'cb0ffa9d-84dd-4251-ae5f-70d3a3e690a0'::uuid, 'part-b-criterion-02', 'Correctly rejects the negative solution as not reasonable given the domain 0 ≤ x ≤ 20, keeping only x ≈ 18.2.', 1, 'Response explains that a negative price increase is not meaningful in context, so only x ≈ 18.2 is valid.', 'State that x represents a price increase, which cannot be negative, so only the positive break-even value applies.', '[]'::jsonb),
      ('92aa16d5-1c51-4424-a5b6-0b0461956583'::uuid, 'cb0ffa9d-84dd-4251-ae5f-70d3a3e690a0'::uuid, 'part-c-criterion-01', 'States a reasonable domain such as 0 ≤ x ≤ 20 (or 0 ≤ x < 18.2).', 1, 'Response gives explicit domain bounds consistent with the context.', 'Identify the values of x for which the price increase and profit both make practical sense.', '[]'::jsonb),
      ('f8318b4c-aa71-4ee4-a0eb-b60a2207a66d'::uuid, 'cb0ffa9d-84dd-4251-ae5f-70d3a3e690a0'::uuid, 'part-c-criterion-02', 'Justifies the domain restriction using context (x cannot be negative since it''s a price increase; profit becomes zero or negative beyond the break-even point, which is not a sustainable pricing choice).', 1, 'Response connects the lower bound to nonnegative price increases and the upper bound to the break-even/profitability point.', 'Explain why x < 0 is meaningless and why prices beyond the break-even value are not reasonable to model.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-005'
      and id <> 'e45ea840-1283-49c6-afe1-7cedad0b8596'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-005';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'e45ea840-1283-49c6-afe1-7cedad0b8596'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'e45ea840-1283-49c6-afe1-7cedad0b8596'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-005',
      'frq',
      'Vertical Asymptotes and Sign Behavior of a Rational Function',
      'draft',
      'short',
      'targeted_drill',
      'Function Concepts'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '8b83b1d9-2642-4353-a5a6-6942dc15e440'::uuid,
      'e45ea840-1283-49c6-afe1-7cedad0b8596'::uuid,
      1,
      'Vertical Asymptotes and Sign Behavior of a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'Let f(x) = (x^2 + 3x - 4)/(x^2 - 4). A graphing calculator is permitted for this item.',
      '{"content_key":"apprecalc-frq-u12-005","subject":"ap_precalculus","unit":1,"topic":"1.9 Rational Functions and Vertical Asymptotes","archetype":"Function Concepts","difficulty":"Medium","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Factor the numerator and denominator of f completely, and use the factored form to identify all vertical asymptotes of f.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Use your calculator to determine the horizontal asymptote of f and describe the end behavior of f as x → ∞ and x → -∞.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Using your calculator, determine the sign of f(x) immediately to the left and immediately to the right of x = 2, and describe the resulting behavior of the graph near this asymptote.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Vertical Asymptotes and Sign Behavior of a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('3187e5c7-49cd-4976-a239-13c236b4023d'::uuid, '8b83b1d9-2642-4353-a5a6-6942dc15e440'::uuid, 'part-a-criterion-01', 'Correctly factors numerator as (x+4)(x-1) and denominator as (x-2)(x+2).', 1, 'Response shows f(x) = (x+4)(x-1) / [(x-2)(x+2)].', 'Factor the quadratic numerator and denominator separately, checking for common factors.', '[]'::jsonb),
      ('ce88efb6-1524-4199-a957-c03b84f20270'::uuid, '8b83b1d9-2642-4353-a5a6-6942dc15e440'::uuid, 'part-a-criterion-02', 'Correctly identifies vertical asymptotes at x = 2 and x = -2, noting there are no common factors to cancel.', 1, 'Response states both x=2 and x=-2 are vertical asymptotes since neither factor cancels with the numerator.', 'Confirm the numerator does not share a factor with (x-2) or (x+2), so both denominator zeros are true vertical asymptotes.', '[]'::jsonb),
      ('4d1d9396-6e1d-4e5d-a7c8-0c9dfa679746'::uuid, '8b83b1d9-2642-4353-a5a6-6942dc15e440'::uuid, 'part-b-criterion-01', 'Correctly identifies the horizontal asymptote as y = 1.', 1, 'Response states y=1, referencing the ratio of leading coefficients (1/1) since numerator and denominator have equal degree.', 'Compare the degrees and leading coefficients of numerator and denominator, or use the calculator''s table for large |x|.', '[]'::jsonb),
      ('7aa0251d-56db-4a59-a943-e56e6bda5439'::uuid, '8b83b1d9-2642-4353-a5a6-6942dc15e440'::uuid, 'part-b-criterion-02', 'Correctly describes that f(x) → 1 as x → ∞ and as x → -∞.', 1, 'Response explicitly states both end behaviors approach the value 1.', 'Use the calculator table at large positive and large negative x-values to confirm f(x) approaches 1 on both ends.', '[]'::jsonb),
      ('d4de1568-74b3-44d0-a369-c084f16e6f46'::uuid, '8b83b1d9-2642-4353-a5a6-6942dc15e440'::uuid, 'part-c-criterion-01', 'Correctly determines f(x) is negative just to the left of x=2 and positive just to the right of x=2 (or shows correct calculator-based sign evidence).', 1, 'Response reports test values such as f(1.9) < 0 and f(2.1) > 0.', 'Evaluate f at values just less than and just greater than 2 using the calculator table feature.', '[]'::jsonb),
      ('b3fa607b-3b64-4719-abeb-ef72ae379ccd'::uuid, '8b83b1d9-2642-4353-a5a6-6942dc15e440'::uuid, 'part-c-criterion-02', 'Correctly describes the graph going to -∞ as x → 2⁻ and to +∞ as x → 2⁺.', 1, 'Response links the sign changes to the graph plunging downward on the left side and rising upward on the right side of x=2.', 'State that the sign change across the vertical asymptote corresponds to the graph diverging to -∞ on one side and +∞ on the other.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-006'
      and id <> '03feed1a-d1ca-41a2-af8a-5b890dc947cf'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-006';
  end if;

  if not exists (
    select 1 from app.content_items where id = '03feed1a-d1ca-41a2-af8a-5b890dc947cf'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '03feed1a-d1ca-41a2-af8a-5b890dc947cf'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-006',
      'frq',
      'Modeling Bacterial Population Growth',
      'draft',
      'short',
      'targeted_drill',
      'Modeling a Non-Periodic Context'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '3f6a5741-e344-4891-afcf-3c877869b1c4'::uuid,
      '03feed1a-d1ca-41a2-af8a-5b890dc947cf'::uuid,
      1,
      'Modeling Bacterial Population Growth: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A biologist measures the population of a bacterial culture every hour. A graphing calculator is permitted for this item.

Table 1: Bacterial population N over time t (hours)
t | 0 | 1 | 2 | 3 | 4
N(t) | 500 | 650 | 845 | 1098.5 | 1428.05',
      '{"content_key":"apprecalc-frq-u12-006","subject":"ap_precalculus","unit":2,"topic":"2.5 Exponential Function Context and Data Modeling","archetype":"Modeling a Non-Periodic Context","difficulty":"Medium","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Show that the data represent exponential growth by computing the ratio of consecutive population values, and write an exponential model N(t) for the population.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Use your calculator to determine how many hours it takes for the population to reach 5000.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Interpret the meaning of the growth factor 1.3 in context, and use the model to predict the population at t = 6 hours.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Modeling Bacterial Population Growth: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('9a9da982-29f5-4e10-a27a-cae14f2022e4'::uuid, '3f6a5741-e344-4891-afcf-3c877869b1c4'::uuid, 'part-a-criterion-01', 'Correctly computes at least two consecutive ratios and shows they are constant (equal to 1.3).', 1, 'Response shows 650/500 = 1.3, 845/650 = 1.3, etc., confirming a constant ratio.', 'Divide each population value by the previous one and compare the results.', '[]'::jsonb),
      ('164e48ca-f122-4927-a0a5-cb4526062729'::uuid, '3f6a5741-e344-4891-afcf-3c877869b1c4'::uuid, 'part-a-criterion-02', 'Correctly writes the model N(t) = 500(1.3)^t.', 1, 'Response states N(t) = 500(1.3)^t, using 500 as initial value and 1.3 as the constant ratio.', 'Use the initial value (t=0) as the coefficient and the constant ratio as the base of the exponential model.', '[]'::jsonb),
      ('81c01a6e-bf4e-477c-ac64-9ed436013e23'::uuid, '3f6a5741-e344-4891-afcf-3c877869b1c4'::uuid, 'part-b-criterion-01', 'Sets up the correct equation 500(1.3)^t = 5000 (or equivalent 1.3^t = 10).', 1, 'Response shows the equation used to find t, either in exponential or logarithmic form.', 'Divide both sides of the population equation by 500 to isolate the exponential expression before solving.', '[]'::jsonb),
      ('a0fb05ae-c183-4e39-a355-ee29e1b24988'::uuid, '3f6a5741-e344-4891-afcf-3c877869b1c4'::uuid, 'part-b-criterion-02', 'Correctly solves for t ≈ 8.8 hours using the calculator (graphing intersection, solver, or logarithms).', 1, 'Response reports t ≈ 8.8 hours (or equivalent, e.g. 8.79 hours).', 'Use the calculator''s intersection/solver feature, or compute t = ln(10)/ln(1.3).', '[]'::jsonb),
      ('3bbb406a-11be-44ae-a52f-60babcd1765e'::uuid, '3f6a5741-e344-4891-afcf-3c877869b1c4'::uuid, 'part-c-criterion-01', 'Correctly interprets 1.3 as the population increasing by 30% each hour.', 1, 'Response explains that the population multiplies by 1.3 (a 30% increase) every hour.', 'Relate the base of the exponential model to a percent increase by subtracting 1 and converting to a percentage.', '[]'::jsonb),
      ('29e0ba09-0b7c-4264-a9b8-461baa9b60ed'::uuid, '3f6a5741-e344-4891-afcf-3c877869b1c4'::uuid, 'part-c-criterion-02', 'Correctly computes N(6) ≈ 2413 (bacteria) using the model.', 1, 'Response shows N(6) = 500(1.3)^6 ≈ 2413.4, rounding appropriately.', 'Substitute t = 6 into the model N(t) = 500(1.3)^t and evaluate with the calculator.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-007'
      and id <> '1981876b-7dbf-470e-a3da-092ece9dfc8d'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-007';
  end if;

  if not exists (
    select 1 from app.content_items where id = '1981876b-7dbf-470e-a3da-092ece9dfc8d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '1981876b-7dbf-470e-a3da-092ece9dfc8d'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-007',
      'frq',
      'Solving Exponential and Logarithmic Equations Exactly',
      'draft',
      'short',
      'targeted_drill',
      'Symbolic Manipulations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '55185c80-7990-482f-a9f8-f917efa7e0b1'::uuid,
      '1981876b-7dbf-470e-a3da-092ece9dfc8d'::uuid,
      1,
      'Solving Exponential and Logarithmic Equations Exactly: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'No calculator is permitted for this item. All solutions must be found and expressed exactly (as integers, fractions, or exact logarithmic expressions).',
      '{"content_key":"apprecalc-frq-u12-007","subject":"ap_precalculus","unit":2,"topic":"2.13 Exponential and Logarithmic Equations and Inequalities","archetype":"Symbolic Manipulations","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Solve 3^(2x-1) = 27 exactly for x.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Solve 4^x = 3^(x+1) exactly for x, expressing your answer as an exact logarithmic expression.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Solve log_2(x+3) - log_2(x-1) = 2 exactly for x, checking the domain.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Solving Exponential and Logarithmic Equations Exactly: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('d24ea0c8-ef67-4efa-a250-21785bbfb205'::uuid, '55185c80-7990-482f-a9f8-f917efa7e0b1'::uuid, 'part-a-criterion-01', 'Correctly rewrites 27 as 3^3 so both sides have the same base.', 1, 'Response shows 3^(2x-1) = 3^3.', 'Express 27 as a power of 3 to match the base on the left side.', '[]'::jsonb),
      ('5a08a5f0-3bc3-49eb-a3a6-6ddaf7e0ccd6'::uuid, '55185c80-7990-482f-a9f8-f917efa7e0b1'::uuid, 'part-a-criterion-02', 'Correctly solves 2x-1=3 to get x = 2.', 1, 'Response sets the exponents equal, 2x-1=3, and solves to x=2.', 'Set the exponents equal to each other once the bases match, then solve the resulting linear equation.', '[]'::jsonb),
      ('3ce79d09-b62c-4b61-a948-ecf76f2cac40'::uuid, '55185c80-7990-482f-a9f8-f917efa7e0b1'::uuid, 'part-b-criterion-01', 'Correctly takes the natural log (or log) of both sides and applies the power property.', 1, 'Response shows x ln4 = (x+1) ln3.', 'Apply ln (or log) to both sides and bring down each exponent using the power property of logarithms.', '[]'::jsonb),
      ('db50882e-5a08-4ac0-a9cc-50c24adb455a'::uuid, '55185c80-7990-482f-a9f8-f917efa7e0b1'::uuid, 'part-b-criterion-02', 'Correctly isolates x to get x = ln3 / (ln4 - ln3) (equivalently ln3/ln(4/3)).', 1, 'Response algebraically isolates x and presents the exact expression ln3/(ln4-ln3) or ln3/ln(4/3).', 'Collect all x-terms on one side, factor out x, and divide to solve exactly for x.', '[]'::jsonb),
      ('ec467046-4c8d-4cb6-a224-b1024eab0c19'::uuid, '55185c80-7990-482f-a9f8-f917efa7e0b1'::uuid, 'part-c-criterion-01', 'Correctly combines the logs and forms (x+3)/(x-1) = 4.', 1, 'Response shows log_2((x+3)/(x-1)) = 2 which implies (x+3)/(x-1) = 2^2 = 4.', 'Combine the left side using the quotient property, then rewrite the logarithmic equation in exponential form.', '[]'::jsonb),
      ('e3bfa9c6-d877-46c1-a3b7-84bad8b9fc05'::uuid, '55185c80-7990-482f-a9f8-f917efa7e0b1'::uuid, 'part-c-criterion-02', 'Correctly solves to x = 7/3 and confirms it satisfies the domain requirement x > 1.', 1, 'Response solves x+3=4x-4 to get x=7/3 and checks that 7/3 > 1.', 'Solve the resulting linear equation for x, then verify the result satisfies the domain restriction x > 1.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-008'
      and id <> '8d8d1d28-9e2a-4517-ad0e-0e18b35e1887'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-008';
  end if;

  if not exists (
    select 1 from app.content_items where id = '8d8d1d28-9e2a-4517-ad0e-0e18b35e1887'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '8d8d1d28-9e2a-4517-ad0e-0e18b35e1887'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-008',
      'frq',
      'Zeros, Multiplicity, and End Behavior of a Quartic',
      'draft',
      'short',
      'targeted_drill',
      'Function Concepts'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '89cb2ceb-9985-48bd-a878-ff6489c4c541'::uuid,
      '8d8d1d28-9e2a-4517-ad0e-0e18b35e1887'::uuid,
      1,
      'Zeros, Multiplicity, and End Behavior of a Quartic: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'Let f(x) = -x^4 + 4x^2. A graphing calculator is permitted for this item.',
      '{"content_key":"apprecalc-frq-u12-008","subject":"ap_precalculus","unit":1,"topic":"1.6 Polynomial Functions and End Behavior","archetype":"Function Concepts","difficulty":"Medium","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Determine the end behavior of f as x → ∞ and as x → -∞, justifying your answer using the leading term of f.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Use your calculator to find all zeros of f and their multiplicities, and describe the graph''s behavior at each zero.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Use your calculator to find the local maximum value of f for x > 0, and report the coordinates of that maximum point (rounded to three decimal places if needed).","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Zeros, Multiplicity, and End Behavior of a Quartic: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('b76e84ea-6dec-4ad4-a9cc-a1c82912c13a'::uuid, '89cb2ceb-9985-48bd-a878-ff6489c4c541'::uuid, 'part-a-criterion-01', 'Correctly identifies the leading term as -x^4 (degree 4, negative leading coefficient).', 1, 'Response states the leading term is -x^4 and notes the degree is even with a negative coefficient.', 'Identify the term with the highest power of x in f(x) and its coefficient.', '[]'::jsonb),
      ('c54cb832-e295-4637-a606-7e6ef1334c58'::uuid, '89cb2ceb-9985-48bd-a878-ff6489c4c541'::uuid, 'part-a-criterion-02', 'Correctly concludes f(x) → -∞ as x → ∞ and f(x) → -∞ as x → -∞.', 1, 'Response states both ends of the graph decrease to -∞, matching an even-degree negative leading coefficient function.', 'Use the rule for even-degree polynomials with negative leading coefficients: both ends fall.', '[]'::jsonb),
      ('5dfddc38-8a83-44e5-a887-03af5ee7b86a'::uuid, '89cb2ceb-9985-48bd-a878-ff6489c4c541'::uuid, 'part-b-criterion-01', 'Correctly finds the zeros x = -2, 0, 2, with x=0 having multiplicity 2 and x=±2 having multiplicity 1 (from factoring f(x) = -x^2(x-2)(x+2)).', 1, 'Response lists all three zero locations and correctly assigns multiplicities.', 'Factor f(x) = -x^2(x^2-4) = -x^2(x-2)(x+2), or use the calculator''s zero-finder and examine the graph shape near each zero.', '[]'::jsonb),
      ('0e0ba2e6-7d7d-4d9a-a505-d1448c51c699'::uuid, '89cb2ceb-9985-48bd-a878-ff6489c4c541'::uuid, 'part-b-criterion-02', 'Correctly describes that the graph touches and turns around at x=0 (even multiplicity) and crosses through at x=-2 and x=2 (odd multiplicity).', 1, 'Response explains the tangent/touching behavior at x=0 versus the crossing behavior at x=±2.', 'Relate even multiplicity to the graph touching the x-axis without crossing, and odd multiplicity to the graph crossing through.', '[]'::jsonb),
      ('f8266957-9bce-429a-a7c4-498ce6f8764a'::uuid, '89cb2ceb-9985-48bd-a878-ff6489c4c541'::uuid, 'part-c-criterion-01', 'Correctly uses the calculator''s maximum-finding feature to locate the local maximum near x ≈ 1.414.', 1, 'Response identifies the x-coordinate of the local maximum as x ≈ 1.414 (√2).', 'Graph f(x) for x > 0 and use the calculator''s maximum feature to find the peak.', '[]'::jsonb),
      ('f4eee115-7acb-42e8-a493-5cec238f84d0'::uuid, '89cb2ceb-9985-48bd-a878-ff6489c4c541'::uuid, 'part-c-criterion-02', 'Correctly reports the maximum value f(x) = 4 at that point.', 1, 'Response states the local maximum point is approximately (1.414, 4).', 'Evaluate f at the x-value found by the maximum feature and report the resulting y-value as 4.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-009'
      and id <> '45e5d849-30fb-4d3d-aec7-fd44d4ed0056'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-009';
  end if;

  if not exists (
    select 1 from app.content_items where id = '45e5d849-30fb-4d3d-aec7-fd44d4ed0056'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '45e5d849-30fb-4d3d-aec7-fd44d4ed0056'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-009',
      'frq',
      'Restricting a Domain to Construct an Inverse Function',
      'draft',
      'short',
      'targeted_drill',
      'Function Concepts'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '74adedf0-516c-4422-a701-018b675e2c99'::uuid,
      '45e5d849-30fb-4d3d-aec7-fd44d4ed0056'::uuid,
      1,
      'Restricting a Domain to Construct an Inverse Function: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'Let f(x) = (x-1)^2 + 3, restricted to the domain x ≥ 1. A graphing calculator is available to check your work. Selected values are shown below.

Table 1: Values of f(x) for x ≥ 1
x | 1 | 2 | 3 | 4 | 5
f(x) | 3 | 4 | 7 | 12 | 19',
      '{"content_key":"apprecalc-frq-u12-009","subject":"ap_precalculus","unit":2,"topic":"2.8 Inverse Functions","archetype":"Function Concepts","difficulty":"Medium","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Explain why the domain of f must be restricted to x ≥ 1 in order for f to have an inverse function.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Using the table, find f⁻¹(7), and explain how the table supports your answer.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Find the inverse function f⁻¹(x) algebraically, stating its domain.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Restricting a Domain to Construct an Inverse Function: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('2a5b7962-730e-4038-a4dd-28502bc44184'::uuid, '74adedf0-516c-4422-a701-018b675e2c99'::uuid, 'part-a-criterion-01', 'Correctly explains that without the restriction, f is not one-to-one (fails the horizontal line test), so it has no inverse over all real numbers.', 1, 'Response notes that f(x) = (x-1)^2+3 is a parabola, symmetric about x=1, so two different x-values can give the same output.', 'Use the calculator to graph f over all real numbers and observe that a horizontal line crosses the graph twice, showing it fails the horizontal line test.', '[]'::jsonb),
      ('c874221f-7500-4b36-af31-24dac1737307'::uuid, '74adedf0-516c-4422-a701-018b675e2c99'::uuid, 'part-a-criterion-02', 'Correctly explains that restricting to x ≥ 1 makes f one-to-one (passes the horizontal line test) so the inverse exists.', 1, 'Response states that on x ≥ 1, the graph is increasing and each output corresponds to exactly one input.', 'Check that on x ≥ 1, the function is strictly increasing, so it passes the horizontal line test and is invertible.', '[]'::jsonb),
      ('4d5e1e99-3cf6-4b77-aae8-cbf1c8cb21b4'::uuid, '74adedf0-516c-4422-a701-018b675e2c99'::uuid, 'part-b-criterion-01', 'Correctly identifies f⁻¹(7) = 3.', 1, 'Response states f⁻¹(7)=3.', 'Locate the x-value in the table whose corresponding f(x) equals 7.', '[]'::jsonb),
      ('44d19e54-7e1b-4061-a990-55a61e805d4a'::uuid, '74adedf0-516c-4422-a701-018b675e2c99'::uuid, 'part-b-criterion-02', 'Correctly explains the reasoning that f⁻¹(7)=3 because f(3)=7 from the table, using the inverse relationship between input/output.', 1, 'Response explains that since f(3)=7, the inverse function reverses this correspondence so f⁻¹(7)=3.', 'State the definition of inverse function: if f(a)=b, then f⁻¹(b)=a, and apply it using the table row where f(x)=7.', '[]'::jsonb),
      ('54df83dc-8614-4fdb-a3f0-71d12d9df821'::uuid, '74adedf0-516c-4422-a701-018b675e2c99'::uuid, 'part-c-criterion-01', 'Correctly solves y=(x-1)^2+3 for x, obtaining x = 1 + sqrt(y-3) (choosing the positive root consistent with x ≥ 1).', 1, 'Response shows the algebraic steps: y-3=(x-1)^2, x-1=sqrt(y-3), x=1+sqrt(y-3).', 'Isolate (x-1)^2, take the square root of both sides (choosing the positive root since x≥1), and solve for x.', '[]'::jsonb),
      ('d29ba851-faa4-4594-afee-83f8bb0b53c0'::uuid, '74adedf0-516c-4422-a701-018b675e2c99'::uuid, 'part-c-criterion-02', 'Correctly writes f⁻¹(x) = 1 + sqrt(x-3) with domain x ≥ 3.', 1, 'Response states the final inverse function and its domain restriction matching the range of the original restricted f.', 'Swap the roles of x and y in the solved equation, and state the domain of f⁻¹ as the range of the original f (x ≥ 3).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-010'
      and id <> '737f091d-088b-4c61-a1c0-684cfaaa26f6'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-010';
  end if;

  if not exists (
    select 1 from app.content_items where id = '737f091d-088b-4c61-a1c0-684cfaaa26f6'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '737f091d-088b-4c61-a1c0-684cfaaa26f6'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-010',
      'frq',
      'Maximizing Volume of an Open-Top Box',
      'draft',
      'short',
      'targeted_drill',
      'Modeling a Non-Periodic Context'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '595bd40d-7726-4d7d-af6a-a8adab5d0472'::uuid,
      '737f091d-088b-4c61-a1c0-684cfaaa26f6'::uuid,
      1,
      'Maximizing Volume of an Open-Top Box: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A rectangular piece of cardboard measuring 12 inches by 20 inches is used to make an open-top box by cutting squares of side length x inches from each corner and folding up the sides. The volume of the resulting box is modeled by V(x) = x(12-2x)(20-2x) cubic inches. A graphing calculator is permitted for this item.',
      '{"content_key":"apprecalc-frq-u12-010","subject":"ap_precalculus","unit":1,"topic":"1.4 Polynomial Functions and Rates of Change","archetype":"Modeling a Non-Periodic Context","difficulty":"Medium","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use your calculator to find the value of x that maximizes the volume, and state the maximum volume (rounded to the nearest hundredth).","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Compute the average rate of change of V(x) on the interval [1,3], and interpret its meaning in the context of the box.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"State a reasonable domain for x in this context and explain the restrictions that justify it.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Maximizing Volume of an Open-Top Box: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('c7a565c8-a1f6-4bf8-a66a-f5d5e46427da'::uuid, '595bd40d-7726-4d7d-af6a-a8adab5d0472'::uuid, 'part-a-criterion-01', 'Correctly uses the calculator''s graph/maximum feature to find x ≈ 2.43 inches.', 1, 'Response reports the maximizing value of x as approximately 2.43.', 'Graph V(x) on the calculator over a reasonable domain and use the maximum-finding feature.', '[]'::jsonb),
      ('26ec1dc6-843b-4890-aa4b-a8f5cf351e5d'::uuid, '595bd40d-7726-4d7d-af6a-a8adab5d0472'::uuid, 'part-a-criterion-02', 'Correctly reports the maximum volume as approximately 262.68 cubic inches (or a value consistent with the x found).', 1, 'Response evaluates V at the x-value found and reports a maximum volume near 262.7 cubic inches.', 'Substitute the maximizing x-value back into V(x) to compute the maximum volume.', '[]'::jsonb),
      ('dc637717-1007-4ddc-a1fa-9b4f83de69ee'::uuid, '595bd40d-7726-4d7d-af6a-a8adab5d0472'::uuid, 'part-b-criterion-01', 'Correctly computes the average rate of change as 36 cubic inches per inch.', 1, 'Response shows V(1)=180, V(3)=252, and (252-180)/(3-1)=36.', 'Evaluate V(1) and V(3), then divide the difference in volume by the difference in x.', '[]'::jsonb),
      ('adc0ee3f-32c2-4b61-aa90-029ce7fb39e4'::uuid, '595bd40d-7726-4d7d-af6a-a8adab5d0472'::uuid, 'part-b-criterion-02', 'Correctly interprets this value in context, e.g., as x increases from 1 to 3 inches, volume increases on average by 36 cubic inches for each additional inch cut.', 1, 'Response gives a contextual sentence connecting the numeric rate to inches cut and cubic inches of volume gained.', 'Describe the units (cubic inches of volume per inch of x) and state what the rate represents physically.', '[]'::jsonb),
      ('228226e4-69c3-45b5-affe-9715ea433d29'::uuid, '595bd40d-7726-4d7d-af6a-a8adab5d0472'::uuid, 'part-c-criterion-01', 'Correctly states the domain 0 < x < 6.', 1, 'Response gives explicit bounds 0 < x < 6 (or equivalent).', 'Determine the values of x for which both box dimensions (12-2x) and (20-2x) remain positive.', '[]'::jsonb),
      ('ef8f3b75-75d6-4f79-ab14-a0a260383e7a'::uuid, '595bd40d-7726-4d7d-af6a-a8adab5d0472'::uuid, 'part-c-criterion-02', 'Correctly justifies both bounds: x must be positive (a real cut must be made) and x < 6 (otherwise 12-2x becomes zero or negative, which is not physically possible).', 1, 'Response explains that x=0 gives no box and x≥6 makes the shorter side length zero or negative.', 'Explain why x=0 produces a flat piece of cardboard (no box) and why x≥6 makes a side length non-positive.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-011'
      and id <> '809abd44-4e6a-4967-adad-3974c0702792'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-011';
  end if;

  if not exists (
    select 1 from app.content_items where id = '809abd44-4e6a-4967-adad-3974c0702792'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '809abd44-4e6a-4967-adad-3974c0702792'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-011',
      'frq',
      'Finding All Complex Zeros of a Quartic Polynomial',
      'draft',
      'short',
      'targeted_drill',
      'Symbolic Manipulations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '76ab691d-b5ec-4d77-adf1-be0fdbd5468e'::uuid,
      '809abd44-4e6a-4967-adad-3974c0702792'::uuid,
      1,
      'Finding All Complex Zeros of a Quartic Polynomial: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'Let p(x) = x^4 - 3x^3 + 6x^2 - 12x + 8. No calculator is permitted for this item; all work must be shown symbolically.',
      '{"content_key":"apprecalc-frq-u12-011","subject":"ap_precalculus","unit":1,"topic":"1.5 Polynomial Functions and Complex Zeros","archetype":"Symbolic Manipulations","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Verify that x = 1 is a zero of p, and use polynomial division to find the resulting cubic quotient.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Factor the cubic quotient from part A completely over the real numbers, identifying the remaining real zero.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Solve x^2 + 4 = 0 for its complex solutions, and write p(x) as a product of linear factors over the complex numbers.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Finding All Complex Zeros of a Quartic Polynomial: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('122d0bc8-4fbf-4647-a611-62cf913d7c96'::uuid, '76ab691d-b5ec-4d77-adf1-be0fdbd5468e'::uuid, 'part-a-criterion-01', 'Correctly verifies p(1) = 0 by direct substitution.', 1, 'Response shows 1 - 3 + 6 - 12 + 8 = 0.', 'Substitute x=1 into p(x) and simplify to show the result is zero.', '[]'::jsonb),
      ('3e6ff77f-84ab-4508-a06b-602792133dbd'::uuid, '76ab691d-b5ec-4d77-adf1-be0fdbd5468e'::uuid, 'part-a-criterion-02', 'Correctly performs synthetic or long division by (x-1) to obtain the quotient x^3 - 2x^2 + 4x - 8.', 1, 'Response shows the division process with coefficients 1, -3, 6, -12, 8 producing 1, -2, 4, -8 and remainder 0.', 'Divide p(x) by (x-1) using synthetic division with root 1, tracking each step of the process.', '[]'::jsonb),
      ('96ae31c6-e732-4c71-afd2-7e61927af456'::uuid, '76ab691d-b5ec-4d77-adf1-be0fdbd5468e'::uuid, 'part-b-criterion-01', 'Correctly factors x^3 - 2x^2 + 4x - 8 by grouping into x^2(x-2) + 4(x-2).', 1, 'Response shows the grouping step leading to (x-2)(x^2+4).', 'Group the first two terms and the last two terms, factoring out a common binomial factor.', '[]'::jsonb),
      ('2eee21f5-3684-4f52-a142-7386f989d31e'::uuid, '76ab691d-b5ec-4d77-adf1-be0fdbd5468e'::uuid, 'part-b-criterion-02', 'Correctly identifies the remaining real zero as x = 2, with x^2+4 as the remaining irreducible quadratic factor.', 1, 'Response states x=2 as the second real zero of p, and identifies x^2+4 as the factor with no real zeros.', 'Set the linear factor (x-2) equal to zero to find the remaining real zero.', '[]'::jsonb),
      ('f9f55c99-217c-4eea-a659-87370b9e7e6b'::uuid, '76ab691d-b5ec-4d77-adf1-be0fdbd5468e'::uuid, 'part-c-criterion-01', 'Correctly solves x^2+4=0 to get x = 2i and x = -2i.', 1, 'Response shows x^2=-4, x=±sqrt(-4)=±2i.', 'Isolate x^2, take the square root of a negative number, and express the result using i.', '[]'::jsonb),
      ('e7448408-48b3-43fd-abff-fb0918a162a5'::uuid, '76ab691d-b5ec-4d77-adf1-be0fdbd5468e'::uuid, 'part-c-criterion-02', 'Correctly writes the complete factorization p(x) = (x-1)(x-2)(x-2i)(x+2i).', 1, 'Response assembles all four linear factors found across parts A-C into the complete factorization.', 'Combine the two real linear factors from parts A and B with the two complex linear factors from this part.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-012'
      and id <> '21a17db8-78e4-4eb6-a35d-12e53c97ab4d'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-012';
  end if;

  if not exists (
    select 1 from app.content_items where id = '21a17db8-78e4-4eb6-a35d-12e53c97ab4d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '21a17db8-78e4-4eb6-a35d-12e53c97ab4d'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-012',
      'frq',
      'Comparing Earthquake Intensities Using a Logarithmic Scale',
      'draft',
      'short',
      'targeted_drill',
      'Modeling a Non-Periodic Context'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '0d390467-9d69-4a5a-acff-123bbfa73620'::uuid,
      '21a17db8-78e4-4eb6-a35d-12e53c97ab4d'::uuid,
      1,
      'Comparing Earthquake Intensities Using a Logarithmic Scale: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'Seismologists measure earthquake magnitude using the model M = log10(I), where I is the intensity of the earthquake relative to a reference intensity of 1. A graphing calculator is permitted for this item.',
      '{"content_key":"apprecalc-frq-u12-012","subject":"ap_precalculus","unit":2,"topic":"2.14 Logarithmic Function Context and Data Modeling","archetype":"Modeling a Non-Periodic Context","difficulty":"Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Earthquake A has an intensity ratio of I = 6,300,000 relative to the reference intensity. Use your calculator to find its magnitude M_A, rounded to the nearest hundredth.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Earthquake B has a magnitude of 5.4. Use your calculator to find its intensity ratio I_B.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Determine how many times more intense earthquake A is than earthquake B, and explain how this relates to the difference in their magnitudes.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Comparing Earthquake Intensities Using a Logarithmic Scale: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('1d625f4e-8ce5-412f-a3fd-6872d64e91f8'::uuid, '0d390467-9d69-4a5a-acff-123bbfa73620'::uuid, 'part-a-criterion-01', 'Correctly sets up M_A = log10(6,300,000).', 1, 'Response writes the expression M_A = log10(6,300,000) before evaluating.', 'Substitute I = 6,300,000 into the model M = log10(I).', '[]'::jsonb),
      ('0d85c913-2c08-4e02-a440-6f31491c719f'::uuid, '0d390467-9d69-4a5a-acff-123bbfa73620'::uuid, 'part-a-criterion-02', 'Correctly evaluates M_A ≈ 6.80 using the calculator.', 1, 'Response reports M_A ≈ 6.80 (accept 6.79-6.80 due to rounding).', 'Use the calculator''s log base-10 function to evaluate log10(6,300,000).', '[]'::jsonb),
      ('68f91850-b4cd-45b4-af58-9f823562b07c'::uuid, '0d390467-9d69-4a5a-acff-123bbfa73620'::uuid, 'part-b-criterion-01', 'Correctly sets up the equation 5.4 = log10(I_B) and rewrites it in exponential form I_B = 10^5.4.', 1, 'Response shows the correct exponential rewrite of the logarithmic equation.', 'Rewrite the equation M=log10(I) in exponential form to solve for I_B.', '[]'::jsonb),
      ('51604c2b-1cd2-43cf-a10c-4c8ad8432264'::uuid, '0d390467-9d69-4a5a-acff-123bbfa73620'::uuid, 'part-b-criterion-02', 'Correctly evaluates I_B ≈ 251,189 using the calculator.', 1, 'Response reports I_B ≈ 251,189 (accept reasonable rounding, e.g., 251,000-251,200).', 'Use the calculator to evaluate 10^5.4.', '[]'::jsonb),
      ('bfdec456-59f3-4abe-af94-e476ef1001cd'::uuid, '0d390467-9d69-4a5a-acff-123bbfa73620'::uuid, 'part-c-criterion-01', 'Correctly computes the ratio I_A/I_B ≈ 25 (using values from parts A and B).', 1, 'Response computes 6,300,000/251,189 ≈ 25.1 and reports approximately 25 times more intense.', 'Divide the intensity of earthquake A by the intensity of earthquake B using the values found in parts A and B.', '[]'::jsonb),
      ('0b775514-01f4-41db-a322-979f78813b94'::uuid, '0d390467-9d69-4a5a-acff-123bbfa73620'::uuid, 'part-c-criterion-02', 'Correctly explains that the magnitude difference of 1.4 (6.8 - 5.4) corresponds to an intensity ratio of 10^1.4 ≈ 25, consistent with the answer above.', 1, 'Response connects the difference in magnitudes to the exponent in the intensity ratio calculation.', 'Compute 10 raised to the difference in magnitudes (1.4) and compare it to the ratio found from the raw intensities.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-013'
      and id <> '558106e7-f505-40b7-a5df-91382180a3ae'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-013';
  end if;

  if not exists (
    select 1 from app.content_items where id = '558106e7-f505-40b7-a5df-91382180a3ae'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '558106e7-f505-40b7-a5df-91382180a3ae'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-013',
      'frq',
      'Identifying a Hole and Asymptotic Behavior in a Rational Function',
      'draft',
      'short',
      'targeted_drill',
      'Function Concepts'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '02023405-5a21-4e1a-a6b5-6d8d1ee52055'::uuid,
      '558106e7-f505-40b7-a5df-91382180a3ae'::uuid,
      1,
      'Identifying a Hole and Asymptotic Behavior in a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'Let f(x) = (x^2 - x - 6)/(x^2 - 4). A graphing calculator is permitted for this item.',
      '{"content_key":"apprecalc-frq-u12-013","subject":"ap_precalculus","unit":1,"topic":"1.10 Rational Functions and Holes","archetype":"Function Concepts","difficulty":"Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Factor the numerator and denominator of f, and identify the coordinates of the removable discontinuity (hole) in the graph of f.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Identify the vertical asymptote of f, and explain why x=-2 is a hole rather than a vertical asymptote despite also making the original denominator zero.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Use your calculator to determine the horizontal asymptote of f, and describe the end behavior of f.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Identifying a Hole and Asymptotic Behavior in a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('955d7e47-a9a1-48c3-a238-8c9df70f2e6f'::uuid, '02023405-5a21-4e1a-a6b5-6d8d1ee52055'::uuid, 'part-a-criterion-01', 'Correctly factors f(x) = (x-3)(x+2) / [(x-2)(x+2)] and identifies x=-2 as the location of the hole.', 1, 'Response shows the common factor (x+2) in both numerator and denominator, giving a hole at x=-2.', 'Factor both numerator and denominator completely and identify any common linear factor.', '[]'::jsonb),
      ('03e65c2f-77fd-411f-a4f0-9ec8b09ba4e2'::uuid, '02023405-5a21-4e1a-a6b5-6d8d1ee52055'::uuid, 'part-a-criterion-02', 'Correctly finds the y-coordinate of the hole by substituting x=-2 into the simplified expression (x-3)/(x-2), obtaining y = 1.25, so the hole is at (-2, 1.25).', 1, 'Response substitutes x=-2 into (x-3)/(x-2) to get (-5)/(-4)=1.25 and states the hole location as (-2, 1.25).', 'Cancel the common factor to get the simplified rational expression, then evaluate it at x=-2 to find the y-coordinate of the hole.', '[]'::jsonb),
      ('96a37a0b-04e1-4c66-a301-9942ffc9ff5d'::uuid, '02023405-5a21-4e1a-a6b5-6d8d1ee52055'::uuid, 'part-b-criterion-01', 'Correctly identifies x=2 as the vertical asymptote.', 1, 'Response states x=2 is the sole vertical asymptote of f.', 'Determine which zero of the original denominator remains after the common factor is cancelled.', '[]'::jsonb),
      ('a52b30cd-aab2-4f95-a587-58a13d7485cb'::uuid, '02023405-5a21-4e1a-a6b5-6d8d1ee52055'::uuid, 'part-b-criterion-02', 'Correctly explains that x=-2 cancels with a matching factor in the numerator (making it a removable discontinuity), whereas x=2 does not cancel and the numerator is nonzero there.', 1, 'Response explains the distinction between a hole (factor cancels) and a true vertical asymptote (factor does not cancel, numerator nonzero).', 'Check whether the numerator equals zero at x=2 to confirm it doesn''t cancel, unlike at x=-2.', '[]'::jsonb),
      ('5194366e-b809-414d-a081-6c8543f2a921'::uuid, '02023405-5a21-4e1a-a6b5-6d8d1ee52055'::uuid, 'part-c-criterion-01', 'Correctly identifies the horizontal asymptote as y=1.', 1, 'Response states y=1, based on equal degrees and leading coefficient ratio 1/1 (or by examining a calculator table for large |x|).', 'Compare the degrees and leading coefficients of the numerator and denominator, or use a calculator table for large |x| values.', '[]'::jsonb),
      ('069ddad0-b0f5-4929-a014-172dc75504b0'::uuid, '02023405-5a21-4e1a-a6b5-6d8d1ee52055'::uuid, 'part-c-criterion-02', 'Correctly describes that f(x) approaches 1 as x → ∞ and as x → -∞.', 1, 'Response explicitly states f(x)→1 in both directions.', 'Confirm using the simplified expression (x-3)/(x-2), which also approaches 1 as x becomes very large in either direction.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-014'
      and id <> '9cc8ecb2-d941-41c6-a383-6dd90782db19'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-014';
  end if;

  if not exists (
    select 1 from app.content_items where id = '9cc8ecb2-d941-41c6-a383-6dd90782db19'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '9cc8ecb2-d941-41c6-a383-6dd90782db19'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-014',
      'frq',
      'Manipulating and Solving Logarithmic Expressions Exactly',
      'draft',
      'short',
      'targeted_drill',
      'Symbolic Manipulations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '68e75aee-1621-4fb8-a98b-287be2da2277'::uuid,
      '9cc8ecb2-d941-41c6-a383-6dd90782db19'::uuid,
      1,
      'Manipulating and Solving Logarithmic Expressions Exactly: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'No calculator is permitted for this item. All work must use exact values and properties of logarithms.',
      '{"content_key":"apprecalc-frq-u12-014","subject":"ap_precalculus","unit":2,"topic":"2.12 Logarithmic Function Manipulation","archetype":"Symbolic Manipulations","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Combine log_3(81) + log_3(1/9) - log_3(3) into a single logarithm and evaluate it exactly.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Solve ln(x) + ln(x+2) = ln(15) exactly for x, checking the domain of any solutions.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Explain why the identity log_b(x^2) = 2 log_b(x) is only valid for x > 0, and state the correct general identity that holds for all x ≠ 0.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Manipulating and Solving Logarithmic Expressions Exactly: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('1be1d36f-4349-4347-a41d-ef6543e053eb'::uuid, '68e75aee-1621-4fb8-a98b-287be2da2277'::uuid, 'part-a-criterion-01', 'Correctly combines the expression into a single logarithm: log_3(81 · (1/9) / 3) = log_3(3).', 1, 'Response shows the combined argument simplifies to 81/(9·3) = 3.', 'Use the product and quotient properties to combine all three terms into one logarithm before simplifying the argument.', '[]'::jsonb),
      ('ad4f97a1-610e-4c69-a180-9c2e17c5853e'::uuid, '68e75aee-1621-4fb8-a98b-287be2da2277'::uuid, 'part-a-criterion-02', 'Correctly evaluates log_3(3) = 1 as the final exact answer.', 1, 'Response states the final value is 1.', 'Recognize log_3(3) = 1 since 3^1 = 3.', '[]'::jsonb),
      ('9090405e-9a19-479d-a90b-77e3aa86b4ba'::uuid, '68e75aee-1621-4fb8-a98b-287be2da2277'::uuid, 'part-b-criterion-01', 'Correctly combines the logs and forms the equation x(x+2) = 15, solving to x = 3 or x = -5.', 1, 'Response shows ln(x(x+2)) = ln(15) implies x^2+2x-15=0, factoring to (x+5)(x-3)=0.', 'Combine the left side into a single logarithm, set the arguments equal, and solve the resulting quadratic by factoring.', '[]'::jsonb),
      ('60d26e2a-4969-48b4-ad92-90a743c89f19'::uuid, '68e75aee-1621-4fb8-a98b-287be2da2277'::uuid, 'part-b-criterion-02', 'Correctly rejects x=-5 as extraneous (domain requires x > 0) and reports the final answer x=3.', 1, 'Response explicitly checks the domain requirement x>0 (and x+2>0) and rules out the negative solution.', 'State the domain requirement for ln(x) to be defined, and use it to eliminate the negative root.', '[]'::jsonb),
      ('5a7be887-da2c-4d91-ac48-edd7012e4703'::uuid, '68e75aee-1621-4fb8-a98b-287be2da2277'::uuid, 'part-c-criterion-01', 'Correctly explains that log_b(x^2) = 2log_b(x) fails for x<0 because log_b(x) is undefined when x is negative, even though x^2 is positive.', 1, 'Response identifies the domain mismatch: the left side is defined for all x≠0, but the right side requires x>0.', 'Test the identity with a negative value of x to show the right-hand side is undefined while the left-hand side is defined.', '[]'::jsonb),
      ('703d56d7-b233-4217-a31b-fe62ddb8987a'::uuid, '68e75aee-1621-4fb8-a98b-287be2da2277'::uuid, 'part-c-criterion-02', 'Correctly states the general identity log_b(x^2) = 2 log_b|x|, valid for all x ≠ 0.', 1, 'Response gives the corrected identity using the absolute value of x.', 'Replace log_b(x) with log_b|x| on the right-hand side so both sides share the same domain (all nonzero real x).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-015'
      and id <> 'c99b578c-4c8e-4638-a893-882eb6d1b8d5'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-015';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'c99b578c-4c8e-4638-a893-882eb6d1b8d5'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'c99b578c-4c8e-4638-a893-882eb6d1b8d5'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-015',
      'frq',
      'Average Cost Per Unit as a Rational Function',
      'draft',
      'short',
      'targeted_drill',
      'Modeling a Non-Periodic Context'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a32ccd85-a993-4fbb-a0cb-47477b394ee9'::uuid,
      'c99b578c-4c8e-4638-a893-882eb6d1b8d5'::uuid,
      1,
      'Average Cost Per Unit as a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A factory has fixed costs of $2500 per week and a variable cost of $15 per item produced. The average cost per item when producing x items is modeled by C(x) = (2500 + 15x)/x dollars. A graphing calculator is permitted for this item.',
      '{"content_key":"apprecalc-frq-u12-015","subject":"ap_precalculus","unit":1,"topic":"1.14 Function Model Construction and Application","archetype":"Modeling a Non-Periodic Context","difficulty":"Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use your calculator to find the average cost per item when x=100 and when x=500, and describe the trend.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Determine the horizontal asymptote of C(x) as x → ∞, and interpret its meaning in the context of the factory''s costs.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Use your calculator to find the production level x at which the average cost per item is exactly $17, and verify your answer.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Average Cost Per Unit as a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('03c042b5-2129-4126-ac7f-e54d5afa9d8c'::uuid, 'a32ccd85-a993-4fbb-a0cb-47477b394ee9'::uuid, 'part-a-criterion-01', 'Correctly computes C(100) = 40 and C(500) = 20.', 1, 'Response shows C(100)=(2500+1500)/100=40 and C(500)=(2500+7500)/500=20.', 'Substitute x=100 and x=500 into C(x) and simplify each.', '[]'::jsonb),
      ('e478e0bd-c820-4b63-ad70-4108b2b608d5'::uuid, 'a32ccd85-a993-4fbb-a0cb-47477b394ee9'::uuid, 'part-a-criterion-02', 'Correctly describes that average cost per item decreases as production increases.', 1, 'Response states the trend that C(x) decreases from 40 to 20 as x increases from 100 to 500.', 'Compare the two computed values and describe how average cost changes as x grows.', '[]'::jsonb),
      ('8fcd7368-2af2-490a-a261-75e4d051e6b1'::uuid, 'a32ccd85-a993-4fbb-a0cb-47477b394ee9'::uuid, 'part-b-criterion-01', 'Correctly identifies the horizontal asymptote as y=15.', 1, 'Response states y=15, since C(x) = 15 + 2500/x and 2500/x → 0 as x→∞.', 'Rewrite C(x) as 15 + 2500/x and analyze the behavior of the second term as x becomes very large.', '[]'::jsonb),
      ('16798375-7e0c-4510-a58c-72cdce977f07'::uuid, 'a32ccd85-a993-4fbb-a0cb-47477b394ee9'::uuid, 'part-b-criterion-02', 'Correctly interprets y=15 as the variable cost per item, representing the minimum average cost the factory approaches as production scales up (fixed costs become negligible per item).', 1, 'Response explains that as more items are produced, the fixed cost is spread thinner, so average cost approaches the per-item variable cost of $15.', 'Explain in context why average cost can never go below $15 per item and why it approaches this value as production increases.', '[]'::jsonb),
      ('8d224eab-a28b-467d-a7a8-ea40c4d9afa8'::uuid, 'a32ccd85-a993-4fbb-a0cb-47477b394ee9'::uuid, 'part-c-criterion-01', 'Correctly sets up and solves 15 + 2500/x = 17 (or (2500+15x)/x=17) to get x=1250.', 1, 'Response shows 2500/x=2 leading to x=1250, using the calculator to solve or graph the equation.', 'Set C(x) equal to 17 and solve for x, using the calculator''s solver or intersection feature if needed.', '[]'::jsonb),
      ('5973aa28-59be-4bb5-a8f5-7ac7e0e58137'::uuid, 'a32ccd85-a993-4fbb-a0cb-47477b394ee9'::uuid, 'part-c-criterion-02', 'Correctly verifies the answer by substituting x=1250 back into C(x) to confirm C(1250)=17.', 1, 'Response shows C(1250) = (2500+18750)/1250 = 21250/1250 = 17.', 'Plug x=1250 back into the original formula for C(x) to check that the result equals 17.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-016'
      and id <> '5f83c6c8-e9e4-429d-a79a-ed9e4940fa98'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-016';
  end if;

  if not exists (
    select 1 from app.content_items where id = '5f83c6c8-e9e4-429d-a79a-ed9e4940fa98'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '5f83c6c8-e9e4-429d-a79a-ed9e4940fa98'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-016',
      'frq',
      'Choosing Between a Linear and Exponential Model',
      'draft',
      'short',
      'targeted_drill',
      'Function Concepts'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'd8c9d860-8dba-4c91-a96a-f0be701f5199'::uuid,
      '5f83c6c8-e9e4-429d-a79a-ed9e4940fa98'::uuid,
      1,
      'Choosing Between a Linear and Exponential Model: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A graphing calculator is permitted for this item. The table below shows values of a function y for several inputs x.

Table 1: Values of y
x | 0 | 1 | 2 | 3 | 4
y | 5 | 7.5 | 11.25 | 16.875 | 25.3125',
      '{"content_key":"apprecalc-frq-u12-016","subject":"ap_precalculus","unit":2,"topic":"2.6 Competing Function Model Validation","archetype":"Function Concepts","difficulty":"Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Compute the first differences of the y-values. Based on these differences, determine whether a linear model is appropriate, and explain why or why not.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Compute the ratios of consecutive y-values. Based on these ratios, determine whether an exponential model is appropriate, and write the exponential model that fits the data.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Use the exponential model to predict the value of y at x=6, and explain why the exponential model (rather than a linear extrapolation) should be used for this prediction.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Choosing Between a Linear and Exponential Model: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('3afcd47b-e662-478e-ad7a-735f5271c281'::uuid, 'd8c9d860-8dba-4c91-a96a-f0be701f5199'::uuid, 'part-a-criterion-01', 'Correctly computes the first differences: 2.5, 3.75, 5.625, 8.4375.', 1, 'Response lists all four consecutive differences correctly.', 'Subtract each y-value from the next consecutive y-value to find the first differences.', '[]'::jsonb),
      ('64ac935f-f3ac-4c7c-a99e-fbd4a0867d49'::uuid, 'd8c9d860-8dba-4c91-a96a-f0be701f5199'::uuid, 'part-a-criterion-02', 'Correctly concludes a linear model is NOT appropriate because the first differences are not constant.', 1, 'Response explicitly states that since the differences change (increase), a linear model does not fit.', 'Recall that a linear model requires constant first differences, and compare this to the computed values.', '[]'::jsonb),
      ('7a082342-4703-465e-af8e-aca7aacd73ad'::uuid, 'd8c9d860-8dba-4c91-a96a-f0be701f5199'::uuid, 'part-b-criterion-01', 'Correctly computes the ratios and shows they are constant at 1.5.', 1, 'Response shows 7.5/5=1.5, 11.25/7.5=1.5, 16.875/11.25=1.5, 25.3125/16.875=1.5.', 'Divide each y-value by the previous y-value to find the ratios.', '[]'::jsonb),
      ('3314b939-e183-46da-a391-1a70362789d2'::uuid, 'd8c9d860-8dba-4c91-a96a-f0be701f5199'::uuid, 'part-b-criterion-02', 'Correctly writes the exponential model y = 5(1.5)^x.', 1, 'Response states the model using 5 as the initial value and 1.5 as the constant ratio.', 'Use the initial value (x=0) as the coefficient and the constant ratio as the base of the exponential model.', '[]'::jsonb),
      ('a7ad9d74-a590-4624-ad2e-6c2ea9b88e3d'::uuid, 'd8c9d860-8dba-4c91-a96a-f0be701f5199'::uuid, 'part-c-criterion-01', 'Correctly computes y(6) = 5(1.5)^6 ≈ 56.95.', 1, 'Response evaluates the model at x=6 and reports approximately 56.95 (accept 56.9-57.0).', 'Substitute x=6 into the exponential model y=5(1.5)^x and evaluate using the calculator.', '[]'::jsonb),
      ('b1b45de7-5da6-4b1e-aa65-523a6b94c544'::uuid, 'd8c9d860-8dba-4c91-a96a-f0be701f5199'::uuid, 'part-c-criterion-02', 'Correctly explains that the exponential model should be used because the data show a constant ratio (not constant difference), meaning growth compounds rather than accumulates by a fixed amount, so linear extrapolation would significantly underestimate y at x=6.', 1, 'Response connects the constant-ratio pattern established in part B to the appropriateness of exponential (not linear) extrapolation.', 'Explain that since the data pass the ratio test rather than the difference test, using a linear model would misrepresent the compounding growth pattern.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-017'
      and id <> '0ae1e29a-b2b6-4e12-aabc-1e4d63897f8d'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-017';
  end if;

  if not exists (
    select 1 from app.content_items where id = '0ae1e29a-b2b6-4e12-aabc-1e4d63897f8d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '0ae1e29a-b2b6-4e12-aabc-1e4d63897f8d'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-017',
      'frq',
      'Radioactive Decay and a Semi-log Plot',
      'draft',
      'short',
      'targeted_drill',
      'Modeling a Non-Periodic Context'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '94b287ca-a1c5-4add-ad89-56a1fd51b239'::uuid,
      '0ae1e29a-b2b6-4e12-aabc-1e4d63897f8d'::uuid,
      1,
      'Radioactive Decay and a Semi-log Plot: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A radioactive sample''s mass is measured every 10 years. A graphing calculator is permitted for this item.

Table 1: Mass m (grams) remaining after t years
t | 0 | 10 | 20 | 30 | 40
m(t) | 80 | 56.57 | 40 | 28.28 | 20',
      '{"content_key":"apprecalc-frq-u12-017","subject":"ap_precalculus","unit":2,"topic":"2.15 Semi-log Plots","archetype":"Modeling a Non-Periodic Context","difficulty":"Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Show that the data represent exponential decay by computing the ratio of consecutive mass values, and state the approximate decay factor per 10-year interval.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"If log10(mass) is plotted against t, explain why the resulting graph is linear, and find the slope of this semi-log plot using the data at t=0 and t=40.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Use the data or model to determine the half-life of the substance, and confirm your answer using two points in the table.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Radioactive Decay and a Semi-log Plot: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('a10c0e84-6257-4ce7-a9d3-98c4cefa9951'::uuid, '94b287ca-a1c5-4add-ad89-56a1fd51b239'::uuid, 'part-a-criterion-01', 'Correctly computes at least two consecutive ratios and shows they are approximately constant (≈0.7071).', 1, 'Response shows 56.57/80≈0.7071, 40/56.57≈0.7071, etc.', 'Divide each mass value by the previous mass value to check for a constant ratio.', '[]'::jsonb),
      ('eafa132b-e1d4-4c4c-ad8d-f1dc09850913'::uuid, '94b287ca-a1c5-4add-ad89-56a1fd51b239'::uuid, 'part-a-criterion-02', 'Correctly states the decay factor per 10 years is approximately 0.7071 (about 70.71%).', 1, 'Response reports the constant ratio as approximately 0.7071 and connects it to the model.', 'Average or confirm the constant ratio found across the table to state the decay factor precisely.', '[]'::jsonb),
      ('73201d85-87db-4993-aff6-bf040e0f32ce'::uuid, '94b287ca-a1c5-4add-ad89-56a1fd51b239'::uuid, 'part-b-criterion-01', 'Correctly explains that plotting log10(mass) versus t linearizes exponential decay because taking the log of an exponential function produces a linear function of t.', 1, 'Response explains that m(t)=80(0.7071)^(t/10) implies log10(m) = log10(80) + (t/10)log10(0.7071), which is linear in t.', 'Take log10 of both sides of the exponential model and show the result is a linear expression in t.', '[]'::jsonb),
      ('da854018-eab6-433c-a7f6-f7cce6dd0b54'::uuid, '94b287ca-a1c5-4add-ad89-56a1fd51b239'::uuid, 'part-b-criterion-02', 'Correctly computes the slope using log10(80)≈1.90309 and log10(20)≈1.30103, giving slope ≈ (1.30103-1.90309)/40 ≈ -0.01505 per year.', 1, 'Response shows the slope calculation using the two log-transformed data points and arrives at approximately -0.015.', 'Use the two points (0, log10(80)) and (40, log10(20)) and apply the slope formula (change in log(mass))/(change in t).', '[]'::jsonb),
      ('5476be5a-49d7-4a32-aa69-6601b6644588'::uuid, '94b287ca-a1c5-4add-ad89-56a1fd51b239'::uuid, 'part-c-criterion-01', 'Correctly identifies the half-life as 20 years.', 1, 'Response states the half-life is 20 years.', 'Use the model or calculator to find the time t at which mass equals half of the initial value (40 grams).', '[]'::jsonb),
      ('3e20c446-1e61-4468-a289-c9f92be553c8'::uuid, '94b287ca-a1c5-4add-ad89-56a1fd51b239'::uuid, 'part-c-criterion-02', 'Correctly confirms using table values, e.g., mass goes from 80 to 40 over t=0 to t=20, and from 40 to 20 over t=20 to t=40.', 1, 'Response explicitly cites both halving intervals shown in the table as confirmation.', 'Check that the mass value halves consistently every 20 years using at least two pairs of table values.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-018'
      and id <> 'f4991b16-5c47-42ed-a222-f96a5faf92f2'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-018';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'f4991b16-5c47-42ed-a222-f96a5faf92f2'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'f4991b16-5c47-42ed-a222-f96a5faf92f2'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-018',
      'frq',
      'Holes, Vertical Asymptotes, and Slant Asymptotes',
      'draft',
      'short',
      'targeted_drill',
      'Symbolic Manipulations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '184814fb-41f2-4820-ace4-368a4fe7e877'::uuid,
      'f4991b16-5c47-42ed-a222-f96a5faf92f2'::uuid,
      1,
      'Holes, Vertical Asymptotes, and Slant Asymptotes: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'Let f(x) = (2x^3 - 9x^2 + 10x - 3)/(x^2 - x - 6). No calculator is permitted for this item; all work must be shown symbolically.',
      '{"content_key":"apprecalc-frq-u12-018","subject":"ap_precalculus","unit":1,"topic":"1.7 Rational Functions and End Behavior","archetype":"Symbolic Manipulations","difficulty":"Very Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Factor the numerator and denominator of f completely, simplify any removable discontinuity, and state the coordinates of the resulting hole.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Identify the vertical asymptote of f, justifying why x=-2 is a true vertical asymptote (unlike x=3, which is a hole).","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Using the simplified expression from part A, perform polynomial division to find the slant (oblique) asymptote of f, and state its equation.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Holes, Vertical Asymptotes, and Slant Asymptotes: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ce93fdce-d690-4a35-a4ae-74914caa23c7'::uuid, '184814fb-41f2-4820-ace4-368a4fe7e877'::uuid, 'part-a-criterion-01', 'Correctly factors the denominator as (x-3)(x+2) and the numerator as (x-3)(2x-1)(x-1), identifying (x-3) as the common factor.', 1, 'Response shows both factorizations and identifies (x-3) as canceling, giving simplified form (2x-1)(x-1)/(x+2).', 'Factor the denominator by inspection, then use synthetic division (testing x=3) on the numerator to confirm (x-3) is a common factor.', '[]'::jsonb),
      ('57998e75-d7d6-4c90-a0f4-43f77d3738d8'::uuid, '184814fb-41f2-4820-ace4-368a4fe7e877'::uuid, 'part-a-criterion-02', 'Correctly finds the hole at (3, 2) by substituting x=3 into the simplified expression (2x-1)(x-1)/(x+2).', 1, 'Response substitutes x=3 into (2(3)-1)(3-1)/(3+2) = (5)(2)/5 = 2, giving the hole at (3,2).', 'Evaluate the simplified rational expression at x=3 to find the y-coordinate of the hole.', '[]'::jsonb),
      ('d3e1af29-87d6-47f4-ab6f-f555d97d24d4'::uuid, '184814fb-41f2-4820-ace4-368a4fe7e877'::uuid, 'part-b-criterion-01', 'Correctly identifies x=-2 as the vertical asymptote.', 1, 'Response states x=-2 is the vertical asymptote of f.', 'Determine which zero of the denominator remains uncancelled after simplification.', '[]'::jsonb),
      ('1ab8ee63-342c-4678-ad33-b26d0a75510b'::uuid, '184814fb-41f2-4820-ace4-368a4fe7e877'::uuid, 'part-b-criterion-02', 'Correctly justifies that (x+2) does not cancel with any numerator factor, since the numerator evaluated at x=-2 is nonzero (confirmed by direct substitution or by noting the numerator''s factors are (x-3), (2x-1), (x-1), none of which equal (x+2)).', 1, 'Response explicitly checks that x=-2 is not a zero of the numerator, distinguishing it from the canceled factor at x=3.', 'Evaluate or reason about the numerator at x=-2 to confirm it is nonzero, confirming x=-2 is a genuine vertical asymptote.', '[]'::jsonb),
      ('ced77677-c464-4742-a871-5da1b1b192ef'::uuid, '184814fb-41f2-4820-ace4-368a4fe7e877'::uuid, 'part-c-criterion-01', 'Correctly performs polynomial long division of (2x^2-3x+1) by (x+2), showing the quotient term 2x and remainder steps.', 1, 'Response shows the division process: 2x^2-3x+1 divided by x+2 yields partial quotient 2x with remainder -7x+1, then continues to full quotient.', 'Multiply out the simplified numerator (2x-1)(x-1) to get 2x^2-3x+1, then divide by (x+2) using polynomial long division.', '[]'::jsonb),
      ('3d480d92-e5bb-4647-a1d7-fbd510ae6942'::uuid, '184814fb-41f2-4820-ace4-368a4fe7e877'::uuid, 'part-c-criterion-02', 'Correctly completes the division to find quotient 2x-7 (remainder 15), stating the slant asymptote as y = 2x-7.', 1, 'Response finalizes the division to show 2x^2-3x+1 = (x+2)(2x-7) + 15, and states the asymptote equation y=2x-7.', 'Complete the long division to find the full linear quotient, ignoring the remainder term, to state the slant asymptote equation.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-019'
      and id <> '00260a57-cf2d-4a1f-ab26-0a5abd0d841d'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-019';
  end if;

  if not exists (
    select 1 from app.content_items where id = '00260a57-cf2d-4a1f-ab26-0a5abd0d841d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '00260a57-cf2d-4a1f-ab26-0a5abd0d841d'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-019',
      'frq',
      'Solving Quadratic-Type Exponential and Logarithmic Equations',
      'draft',
      'short',
      'targeted_drill',
      'Symbolic Manipulations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '958635e1-f9e1-4047-a303-d8a622f75173'::uuid,
      '00260a57-cf2d-4a1f-ab26-0a5abd0d841d'::uuid,
      1,
      'Solving Quadratic-Type Exponential and Logarithmic Equations: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'No calculator is permitted for this item. All solutions must be found and expressed exactly.',
      '{"content_key":"apprecalc-frq-u12-019","subject":"ap_precalculus","unit":2,"topic":"2.13 Exponential and Logarithmic Equations and Inequalities","archetype":"Symbolic Manipulations","difficulty":"Very Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Solve 3^(2x) - 4(3^x) - 45 = 0 exactly for x, using the substitution u = 3^x.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Solve e^(2x) - 5e^x + 6 = 0 exactly for x, using the substitution v = e^x.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Solve log_2(x) + log_2(x-3) = log_2(10) exactly for x, identifying and rejecting any extraneous solution with a domain justification.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Solving Quadratic-Type Exponential and Logarithmic Equations: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('3a62bf63-59f8-4d9f-acb9-7a3489a48e58'::uuid, '958635e1-f9e1-4047-a303-d8a622f75173'::uuid, 'part-a-criterion-01', 'Correctly substitutes u=3^x to form the quadratic u^2-4u-45=0 and factors it as (u-9)(u+5)=0.', 1, 'Response shows the substitution and correct factorization, obtaining u=9 or u=-5.', 'Let u=3^x, rewrite 3^(2x) as u^2, and factor the resulting quadratic equation in u.', '[]'::jsonb),
      ('a9ea0290-2d07-4552-af01-78775680de31'::uuid, '958635e1-f9e1-4047-a303-d8a622f75173'::uuid, 'part-a-criterion-02', 'Correctly rejects u=-5 (since 3^x>0 for all real x) and solves 3^x=9 to get x=2.', 1, 'Response explicitly states u=-5 is rejected because an exponential expression cannot be negative, then solves 3^x=9 for x=2.', 'Recall that 3^x is always positive, reject the negative value of u, then solve the remaining exponential equation for x.', '[]'::jsonb),
      ('13a6e4ec-9cea-4ea1-a408-0e3188c56297'::uuid, '958635e1-f9e1-4047-a303-d8a622f75173'::uuid, 'part-b-criterion-01', 'Correctly substitutes v=e^x to form the quadratic v^2-5v+6=0 and factors it as (v-2)(v-3)=0.', 1, 'Response shows the substitution and correct factorization, obtaining v=2 or v=3.', 'Let v=e^x, rewrite e^(2x) as v^2, and factor the resulting quadratic equation in v.', '[]'::jsonb),
      ('1afbd763-1573-49fe-a402-bc3ee9881c57'::uuid, '958635e1-f9e1-4047-a303-d8a622f75173'::uuid, 'part-b-criterion-02', 'Correctly solves both e^x=2 and e^x=3 to get x=ln2 and x=ln3.', 1, 'Response states both exact solutions x=ln2 and x=ln3.', 'Take the natural log of both sides for each value of v to solve for x exactly.', '[]'::jsonb),
      ('4642d329-d172-428e-a208-0f33bf4c6724'::uuid, '958635e1-f9e1-4047-a303-d8a622f75173'::uuid, 'part-c-criterion-01', 'Correctly combines the logs and forms x(x-3)=10, solving to x=5 or x=-2.', 1, 'Response shows log_2(x(x-3))=log_2(10) implies x^2-3x-10=0, factoring to (x-5)(x+2)=0.', 'Combine the left side into a single logarithm, set the arguments equal, and solve the resulting quadratic by factoring.', '[]'::jsonb),
      ('534e8272-8625-4c0e-a55f-e6ffb0a91a20'::uuid, '958635e1-f9e1-4047-a303-d8a622f75173'::uuid, 'part-c-criterion-02', 'Correctly rejects x=-2 as extraneous, citing the domain requirement x>3 (needed for both log_2(x) and log_2(x-3) to be defined), and reports the final answer x=5.', 1, 'Response explicitly states the domain condition x>3 and uses it to eliminate x=-2.', 'Determine the domain restrictions for both logarithmic terms (x>0 and x>3) and use the stricter condition to reject the invalid solution.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apprecalc-frq-u12-020'
      and id <> '65a69d35-8d0d-414a-afd4-bba8918955a2'::uuid
  ) then
    raise exception 'material_content_key_collision:apprecalc-frq-u12-020';
  end if;

  if not exists (
    select 1 from app.content_items where id = '65a69d35-8d0d-414a-afd4-bba8918955a2'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '65a69d35-8d0d-414a-afd4-bba8918955a2'::uuid,
      v_epv_id,
      'apprecalc-frq-u12-020',
      'frq',
      'Choosing Between a Quadratic and a Rational Model for Subscriber Growth',
      'draft',
      'short',
      'targeted_drill',
      'Modeling a Non-Periodic Context'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a7ae9b95-dde0-4a8b-a060-969d5c730677'::uuid,
      '65a69d35-8d0d-414a-afd4-bba8918955a2'::uuid,
      1,
      'Choosing Between a Quadratic and a Rational Model for Subscriber Growth: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A streaming service tracks the number of subscribers S(t), in thousands, over t months. Two candidate models are proposed:
Quadratic model: Q(t) = -0.04t^2 + 1.8t + 2
Rational model: R(t) = 2 + 18t/(t+8)
A graphing calculator is permitted for this item.

Table 1: Actual subscriber data (in thousands)
t | 0 | 4 | 8 | 12 | 16
S(t) | 2 | 8 | 11 | 12.8 | 14',
      '{"content_key":"apprecalc-frq-u12-020","subject":"ap_precalculus","unit":1,"topic":"1.13 Function Model Selection and Assumption Articulation","archetype":"Modeling a Non-Periodic Context","difficulty":"Very Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use your calculator to evaluate both candidate models at t=16 and compare each result to the actual data value S(16)=14. Which model fits the data better at this point?","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Determine the horizontal asymptote of the rational model R(t), interpret it as the maximum sustainable number of subscribers, and explain why the quadratic model is not appropriate for long-term prediction.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Use your calculator to determine how many months it will take, according to the rational model, for the number of subscribers to reach 19 thousand.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Choosing Between a Quadratic and a Rational Model for Subscriber Growth: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('5f4213c3-5aa9-4388-abf6-f4deb1edc753'::uuid, 'a7ae9b95-dde0-4a8b-a060-969d5c730677'::uuid, 'part-a-criterion-01', 'Correctly evaluates Q(16) ≈ 20.56 and R(16) = 14, showing the calculations for each.', 1, 'Response computes Q(16)=-0.04(256)+1.8(16)+2=20.56 and R(16)=2+18(16)/24=14.', 'Substitute t=16 into each candidate model and simplify.', '[]'::jsonb),
      ('344faf32-ff5d-4af4-a7b3-743e195959d5'::uuid, 'a7ae9b95-dde0-4a8b-a060-969d5c730677'::uuid, 'part-a-criterion-02', 'Correctly concludes the rational model R(t) fits the actual data value at t=16 exactly, while the quadratic model Q(t) significantly overestimates it.', 1, 'Response compares both computed values to the actual value 14 and identifies R(t) as the better fit.', 'Compare each model''s output at t=16 to the actual data value of 14 and state which is closer.', '[]'::jsonb),
      ('e4722684-892a-495d-abb3-4cce7dd84f26'::uuid, 'a7ae9b95-dde0-4a8b-a060-969d5c730677'::uuid, 'part-b-criterion-01', 'Correctly determines the horizontal asymptote of R(t) is y=20 (since 18t/(t+8) → 18 as t→∞, plus the constant 2).', 1, 'Response shows that as t→∞, R(t) → 2+18 = 20, and interprets this as approximately 20,000 subscribers.', 'Analyze the behavior of 18t/(t+8) as t becomes very large, noting it approaches 18, then add the constant term 2.', '[]'::jsonb),
      ('bb3a8f71-0f90-4eb9-a8fa-b98881b0eb02'::uuid, 'a7ae9b95-dde0-4a8b-a060-969d5c730677'::uuid, 'part-b-criterion-02', 'Correctly explains that the quadratic model is inappropriate long-term because it predicts subscribers will eventually decrease (since it has a negative leading coefficient and is not monotonically increasing, or diverges to increasingly unrealistic values) rather than leveling off at a realistic cap as real subscriber growth would.', 1, 'Response explains that Q(t) does not level off and instead its shape does not reflect a realistic saturating growth pattern, unlike the rational model.', 'Compare the long-term shape of Q(t) (parabolic, eventually decreasing) to the leveling-off behavior of R(t) and explain why the quadratic shape is unrealistic for subscriber growth over time.', '[]'::jsonb),
      ('a77884ec-b77f-4983-aaf6-b12a1e89b73e'::uuid, 'a7ae9b95-dde0-4a8b-a060-969d5c730677'::uuid, 'part-c-criterion-01', 'Correctly sets up the equation 2 + 18t/(t+8) = 19 (or equivalent 18t/(t+8)=17).', 1, 'Response shows the correct equation being solved for t.', 'Set R(t) equal to 19 and isolate the rational term before solving.', '[]'::jsonb),
      ('7ac2f053-9435-4646-ad47-191afc036858'::uuid, 'a7ae9b95-dde0-4a8b-a060-969d5c730677'::uuid, 'part-c-criterion-02', 'Correctly solves for t = 136 months, using algebra or the calculator''s solver/intersection feature.', 1, 'Response shows 18t=17(t+8) leading to t=136, or uses the calculator to confirm this solution.', 'Cross-multiply to clear the fraction, solve the resulting linear equation for t, and verify using the calculator.', '[]'::jsonb);
  end if;
end
$stats_precalc_units1_2$;
commit;
