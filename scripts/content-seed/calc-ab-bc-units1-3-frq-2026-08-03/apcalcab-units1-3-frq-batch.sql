begin;
do $calc_ab_bc_units1_3$
declare
  v_epv_id uuid;
  v_epv_count integer;
begin
  select count(*) into v_epv_count
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_calculus_ab'
    and epv.status = 'published';

  if v_epv_count <> 1 then
    raise exception 'expected_exactly_one_published_exam_pack_version:%:%', 'ap_calculus_ab', v_epv_count;
  end if;

  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_calculus_ab'
    and epv.status = 'published';

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-001'
      and id <> '45e20c35-6008-4db3-a6df-ecd3d4c1a780'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-001';
  end if;

  if not exists (
    select 1 from app.content_items where id = '45e20c35-6008-4db3-a6df-ecd3d4c1a780'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '45e20c35-6008-4db3-a6df-ecd3d4c1a780'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-001',
      'frq',
      'Continuity of a Piecewise Function at a Boundary Point',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '829f41f5-2804-4231-a111-9edb31cda154'::uuid,
      '45e20c35-6008-4db3-a6df-ecd3d4c1a780'::uuid,
      1,
      'Continuity of a Piecewise Function at a Boundary Point: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f be the piecewise function defined by
f(x) = x^2 - 1, for x <= 2
f(x) = 2x - 1, for x > 2',
      '{"content_key":"apcalcab-frq-u13-001","subject":"ap_calculus_ab","unit":1,"topic":"1.11 Defining Continuity at a Point","archetype":"Justification","difficulty":"Easy","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate lim x->2- f(x), lim x->2+ f(x), and f(2), showing the substitution used for each.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"State whether lim x->2 f(x) exists. If it exists, give its value and justify your conclusion.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Use the definition of continuity to justify whether f is continuous at x = 2.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Continuity of a Piecewise Function at a Boundary Point: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('34c405a7-61cc-4fe8-acca-aa8aa74ce72f'::uuid, '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'part-a-criterion-01', 'Correct left-hand limit lim x->2- f(x) = 3.', 1, 'Response substitutes x=2 into x^2-1 and gets 3.', 'Show substitution of x=2 into the x<=2 piece and state the value 3.', '[]'::jsonb),
      ('f4fcd36c-7d9a-4461-acb9-5aa781ea1fce'::uuid, '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'part-a-criterion-02', 'Correct right-hand limit lim x->2+ f(x) = 3.', 1, 'Response substitutes x=2 into 2x-1 and gets 3.', 'Show substitution of x=2 into the x>2 piece and state the value 3.', '[]'::jsonb),
      ('4f926190-c23a-4704-ae0e-ca66501dfb00'::uuid, '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'part-a-criterion-03', 'Correct value f(2) = 3 identified from the piecewise definition.', 1, 'Response states f(2)=3, using the x<=2 piece since it includes x=2.', 'State that f(2) uses the x<=2 piece, giving f(2)=3.', '[]'::jsonb),
      ('64336c53-2c64-461b-a792-b98edb06b0f3'::uuid, '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'part-b-criterion-01', 'Correct claim that the limit exists.', 1, 'Response explicitly states the two-sided limit exists.', 'State explicitly whether the limit exists.', '[]'::jsonb),
      ('5e4a5af1-5f18-46d3-a8aa-79b0d16a9c3c'::uuid, '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'part-b-criterion-02', 'Correct justification that the one-sided limits are equal.', 1, 'Response references that the left- and right-hand limits from part A are both 3.', 'Justify using the equality of the one-sided limits found in part A.', '[]'::jsonb),
      ('1ad8bf0d-b0ad-4a45-aaa9-c45368b1a5f5'::uuid, '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'part-b-criterion-03', 'Correct value lim x->2 f(x) = 3 stated.', 1, 'Response gives the numeric value 3 for the two-sided limit.', 'State the numeric value of the limit.', '[]'::jsonb),
      ('7b44d27a-2c0a-45bd-ac0f-690ec2a6dbfb'::uuid, '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'part-c-criterion-01', 'States the three-part definition of continuity.', 1, 'Response lists: f(2) is defined, lim x->2 f(x) exists, and lim x->2 f(x) = f(2).', 'State all three conditions required for continuity at a point.', '[]'::jsonb),
      ('55011d79-70a3-43f4-a6d8-af0b8d011925'::uuid, '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'part-c-criterion-02', 'Correctly verifies all three conditions hold using values from parts A/B.', 1, 'Response confirms f(2)=3 is defined, the limit exists and equals 3.', 'Verify each of the three conditions numerically using prior results.', '[]'::jsonb),
      ('0e8c7e41-7ba4-44a8-ad25-e4ab7a946098'::uuid, '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'part-c-criterion-03', 'Correct conclusion that f is continuous at x=2.', 1, 'Response concludes continuity holds because lim x->2 f(x) = f(2) = 3.', 'State the conclusion that f is continuous at x=2 with the matching values cited.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-002'
      and id <> '776d2398-e222-4068-ae3a-de315e7d4309'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-002';
  end if;

  if not exists (
    select 1 from app.content_items where id = '776d2398-e222-4068-ae3a-de315e7d4309'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '776d2398-e222-4068-ae3a-de315e7d4309'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-002',
      'frq',
      'Reading Limits and Discontinuities from a Described Graph',
      'draft',
      'short',
      'targeted_drill',
      'Connecting Representations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '670914c2-160a-4155-af54-0445ad2ab258'::uuid,
      '776d2398-e222-4068-ae3a-de315e7d4309'::uuid,
      1,
      'Reading Limits and Discontinuities from a Described Graph: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'The graph of g, defined for -4 <= x <= 4, consists of the following pieces:
- For -4 <= x < -1: a line segment from (-4,-2) to (-1,4), with an open circle at (-1,4).
- At x = -1: a closed dot at (-1,1).
- For -1 < x < 2: a horizontal segment at height y = 1, with an open circle at (2,1).
- For 2 <= x <= 4: a line segment from (2,3) to (4,-1), closed at both endpoints.',
      '{"content_key":"apcalcab-frq-u13-002","subject":"ap_calculus_ab","unit":1,"topic":"1.3 Estimating Limit Values from Graphs","archetype":"Connecting Representations","difficulty":"Easy","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"State the values of g(-1) and g(2).","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Find lim x->-1- g(x) and lim x->-1+ g(x). Does lim x->-1 g(x) exist? Justify your answer.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Find lim x->2- g(x) and lim x->2+ g(x). Does lim x->2 g(x) exist? If not, classify the type of discontinuity at x=2.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]}]}'::jsonb,
      md5('Reading Limits and Discontinuities from a Described Graph: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('c0e17502-6131-4d4e-a1a3-175d460ece44'::uuid, '670914c2-160a-4155-af54-0445ad2ab258'::uuid, 'part-a-criterion-01', 'Correct value g(-1) = 1.', 1, 'Response reads the closed dot at (-1,1).', 'Read the closed dot at x=-1 from the graph description.', '[]'::jsonb),
      ('2c5693ca-3f13-4c74-a8cd-3e20586e1aa6'::uuid, '670914c2-160a-4155-af54-0445ad2ab258'::uuid, 'part-a-criterion-02', 'Correct value g(2) = 3.', 1, 'Response reads the closed endpoint (2,3) of the third segment.', 'Read the closed endpoint at x=2 of the segment starting there.', '[]'::jsonb),
      ('273c902a-3f39-413a-a35e-00248e7fc40b'::uuid, '670914c2-160a-4155-af54-0445ad2ab258'::uuid, 'part-b-criterion-01', 'Correct left-hand limit lim x->-1- g(x) = 4.', 1, 'Response uses the open circle at (-1,4) approached along the first segment.', 'State the value approached along the segment from (-4,-2) to (-1,4).', '[]'::jsonb),
      ('29a1a671-e3b2-4731-a648-c44b7ed9d433'::uuid, '670914c2-160a-4155-af54-0445ad2ab258'::uuid, 'part-b-criterion-02', 'Correct right-hand limit lim x->-1+ g(x) = 1.', 1, 'Response uses the horizontal segment at height 1 approached from the right of x=-1.', 'State the value approached along the horizontal segment for x slightly greater than -1.', '[]'::jsonb),
      ('149bd0a4-3b19-4050-a90b-5d04668d8d27'::uuid, '670914c2-160a-4155-af54-0445ad2ab258'::uuid, 'part-b-criterion-03', 'Correct conclusion that the two-sided limit does not exist, justified by unequal one-sided limits.', 1, 'Response states DNE because 4 != 1.', 'State DNE and justify by comparing the two one-sided limits.', '[]'::jsonb),
      ('8428f7a6-1822-409e-a66f-77fec2f63d3a'::uuid, '670914c2-160a-4155-af54-0445ad2ab258'::uuid, 'part-c-criterion-01', 'Correct left-hand limit lim x->2- g(x) = 1.', 1, 'Response uses the horizontal segment approached from the left of x=2.', 'State the value approached along the horizontal segment as x approaches 2 from the left.', '[]'::jsonb),
      ('7de4de6c-c420-417b-ab13-815651f3ec5f'::uuid, '670914c2-160a-4155-af54-0445ad2ab258'::uuid, 'part-c-criterion-02', 'Correct right-hand limit lim x->2+ g(x) = 3.', 1, 'Response uses the segment starting at the closed point (2,3).', 'State the value approached along the third segment as x approaches 2 from the right.', '[]'::jsonb),
      ('44d1befa-4d18-41bb-a9b7-3586bebfba64'::uuid, '670914c2-160a-4155-af54-0445ad2ab258'::uuid, 'part-c-criterion-03', 'Correct conclusion that the two-sided limit does not exist, justified by unequal one-sided limits (1 vs 3).', 1, 'Response states DNE because the one-sided limits differ.', 'State DNE and justify using the unequal one-sided limits.', '[]'::jsonb),
      ('9076c12b-2eb1-4a0d-a0a7-72ec0d3c8c46'::uuid, '670914c2-160a-4155-af54-0445ad2ab258'::uuid, 'part-c-criterion-04', 'Correct classification as a jump discontinuity.', 1, 'Response labels the discontinuity at x=2 as a jump discontinuity.', 'Classify the discontinuity type using the fact that both one-sided limits exist but are unequal.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-003'
      and id <> '7720d16d-1102-47a1-a8f1-7b71d6153031'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-003';
  end if;

  if not exists (
    select 1 from app.content_items where id = '7720d16d-1102-47a1-a8f1-7b71d6153031'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '7720d16d-1102-47a1-a8f1-7b71d6153031'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-003',
      'frq',
      'Plant Growth Rate from Tabular Data',
      'draft',
      'short',
      'targeted_drill',
      'Connecting Representations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid,
      '7720d16d-1102-47a1-a8f1-7b71d6153031'::uuid,
      1,
      'Plant Growth Rate from Tabular Data: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'The height h(t), in centimeters, of a plant is measured at several times t, in days. Selected values are given in the table.
Table 1: Plant height over time
t (days) | 0 | 3 | 6 | 9 | 12
h(t) (cm) | 2.0 | 5.5 | 9.0 | 15.0 | 22.0',
      '{"content_key":"apcalcab-frq-u13-003","subject":"ap_calculus_ab","unit":2,"topic":"2.1 Defining Average and Instantaneous Rates of Change at a Point","archetype":"Connecting Representations","difficulty":"Easy","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Find the average rate of change of h over the interval [0,6]. Interpret the result in the context of the problem, including units.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Use the data in the table to approximate h''(9), showing which values you used.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Using correct derivative notation, write an expression representing the instantaneous rate of change of height at t=9, explain what it represents including units, and explain why a difference quotient only approximates this quantity.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Plant Growth Rate from Tabular Data: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('f6eae36d-eb27-4a24-a1e7-3084884c2a9f'::uuid, '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'part-a-criterion-01', 'Correct setup of the average rate of change as (h(6)-h(0))/(6-0).', 1, 'Response writes the difference quotient using t=0 and t=6.', 'Set up the difference quotient using the correct pair of table values.', '[]'::jsonb),
      ('17baac91-2249-438b-ab9f-a4c45627a647'::uuid, '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'part-a-criterion-02', 'Correct value of 7/6 (approximately 1.167) cm/day.', 1, 'Response computes (9-2)/6 = 7/6.', 'Compute (9-2)/6 and report the value with units.', '[]'::jsonb),
      ('95628889-7317-4b7e-a714-55905ae4cc28'::uuid, '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'part-a-criterion-03', 'Correct contextual interpretation with units.', 1, 'Response states the plant grew at an average rate of about 1.167 cm per day over the first 6 days.', 'State the interpretation in terms of average growth rate per day, with units.', '[]'::jsonb),
      ('2f011395-befe-470b-ae22-f2094d24266b'::uuid, '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'part-b-criterion-01', 'Correct choice of the central difference quotient using t=6 and t=12.', 1, 'Response uses (h(12)-h(6))/(12-6).', 'Use the symmetric interval around t=9, i.e., t=6 and t=12.', '[]'::jsonb),
      ('d63cbd3f-f722-4383-ac44-2e395d637655'::uuid, '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'part-b-criterion-02', 'Correct computation of approximately 2.167 cm/day.', 1, 'Response computes (22-9)/6 = 13/6 ≈ 2.167.', 'Compute (22-9)/6 and report the decimal or fraction value.', '[]'::jsonb),
      ('04004a25-a288-4c05-a82a-c29c75a866cd'::uuid, '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'part-b-criterion-03', 'Correct units included with the approximation.', 1, 'Response reports cm/day as the units of h''(9).', 'Attach units of cm/day to the final approximation.', '[]'::jsonb),
      ('dd4a2f9f-ecff-402c-a1ad-8bf17ccf38e3'::uuid, '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'part-c-criterion-01', 'Correct notation h''(9) written to represent the instantaneous rate.', 1, 'Response writes h''(9) explicitly.', 'Introduce the notation h''(9) for the instantaneous rate of change at t=9.', '[]'::jsonb),
      ('cadafbfe-989c-4b2f-a868-d6e21aec5c50'::uuid, '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'part-c-criterion-02', 'Correct explanation of what h''(9) represents, with units of cm/day.', 1, 'Response explains h''(9) is the instantaneous growth rate of the plant at day 9, in cm/day.', 'Explain that h''(9) is the instantaneous rate of height change at t=9 days, in cm/day.', '[]'::jsonb),
      ('76d0729a-cae1-45e4-ac46-271513c5c0bf'::uuid, '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'part-c-criterion-03', 'Correct explanation that a difference quotient gives an average rate over an interval, while the derivative is the limit of such quotients as the interval shrinks to 0.', 1, 'Response connects the difference quotient in part B to a secant slope and the derivative to a limiting tangent slope.', 'Explain that a difference quotient only estimates h''(9) because it is a secant slope over an interval, not the limiting value as the interval width goes to 0.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-004'
      and id <> 'e2cfa854-271d-4039-a6b7-85906918970f'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-004';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'e2cfa854-271d-4039-a6b7-85906918970f'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'e2cfa854-271d-4039-a6b7-85906918970f'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-004',
      'frq',
      'Resolving Indeterminate Forms by Factoring and Rationalizing',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid,
      'e2cfa854-271d-4039-a6b7-85906918970f'::uuid,
      1,
      'Resolving Indeterminate Forms by Factoring and Rationalizing: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Consider the two limits:
Limit 1: lim x->3 (x^2 - 9)/(x^2 - x - 6)
Limit 2: lim x->0 (sqrt(x+4) - 2)/x',
      '{"content_key":"apcalcab-frq-u13-004","subject":"ap_calculus_ab","unit":1,"topic":"1.6 Determining Limits Using Algebraic Manipulation","archetype":"Implementing Mathematical Processes","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Evaluate Limit 1, showing your algebraic steps.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Evaluate Limit 2, showing your algebraic steps.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Explain why direct substitution fails for both limits, and identify which algebraic technique (factoring or rationalizing) is appropriate for each, referencing the indeterminate form obtained.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Resolving Indeterminate Forms by Factoring and Rationalizing: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('3c0d311e-f4c1-4ba0-a03d-9a72d152dc25'::uuid, 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'part-a-criterion-01', 'Correct factoring of numerator and denominator: (x-3)(x+3) and (x-3)(x+2).', 1, 'Response factors x^2-9 as (x-3)(x+3) and x^2-x-6 as (x-3)(x+2).', 'Factor both the numerator and denominator completely.', '[]'::jsonb),
      ('d937871a-3827-4f72-a79b-470da4cd4bb4'::uuid, 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'part-a-criterion-02', 'Correct cancellation of the common factor (x-3).', 1, 'Response cancels (x-3) from numerator and denominator to get (x+3)/(x+2).', 'Cancel the common factor before substituting x=3.', '[]'::jsonb),
      ('39f556c6-74a2-4cdb-ace5-57820287fd7f'::uuid, 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'part-a-criterion-03', 'Correct final value of 6/5.', 1, 'Response substitutes x=3 into (x+3)/(x+2) to get 6/5.', 'Substitute x=3 into the simplified expression and report 6/5.', '[]'::jsonb),
      ('1b5af14c-d536-4e5c-a850-5ca33e7517d9'::uuid, 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'part-b-criterion-01', 'Correct multiplication by the conjugate sqrt(x+4)+2.', 1, 'Response multiplies numerator and denominator by sqrt(x+4)+2.', 'Multiply numerator and denominator by the conjugate of sqrt(x+4)-2.', '[]'::jsonb),
      ('603cc96e-a920-436b-ab65-902f95014bc6'::uuid, 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'part-b-criterion-02', 'Correct simplification to 1/(sqrt(x+4)+2).', 1, 'Response simplifies (x+4-4)/(x(sqrt(x+4)+2)) to 1/(sqrt(x+4)+2).', 'Cancel the common factor of x after rationalizing.', '[]'::jsonb),
      ('d3d020ca-bf52-4dca-a5d6-d2ea6a48c7dd'::uuid, 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'part-b-criterion-03', 'Correct final value of 1/4.', 1, 'Response substitutes x=0 to get 1/(sqrt(4)+2) = 1/4.', 'Substitute x=0 into the simplified expression and report 1/4.', '[]'::jsonb),
      ('f0dc2179-487d-435d-ab65-76cd019c55f9'::uuid, 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'part-c-criterion-01', 'Correct identification that direct substitution gives the indeterminate form 0/0 in both cases.', 1, 'Response notes both limits yield 0/0 upon direct substitution.', 'State that substituting the limit point directly into both expressions gives 0/0.', '[]'::jsonb),
      ('576328e3-fef9-4cc1-a8b6-5c6dc503cbfd'::uuid, 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'part-c-criterion-02', 'Correctly matches technique to each limit.', 1, 'Response states factoring/cancellation resolves Limit 1 and rationalizing the numerator resolves Limit 2.', 'Match factoring to the rational function and rationalizing to the radical expression.', '[]'::jsonb),
      ('4fd2022f-4938-445c-a83e-57403c088632'::uuid, 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'part-c-criterion-03', 'Correct explanation of why the technique resolves the indeterminate form.', 1, 'Response explains that removing the common factor eliminates the shared zero causing the 0/0 form.', 'Explain that the technique removes the factor causing both numerator and denominator to vanish simultaneously.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-005'
      and id <> 'd7d5d82e-4eee-4223-ad1c-ef55e3461567'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-005';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'd7d5d82e-4eee-4223-ad1c-ef55e3461567'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'd7d5d82e-4eee-4223-ad1c-ef55e3461567'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-005',
      'frq',
      'Identifying Removable and Infinite Discontinuities',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid,
      'd7d5d82e-4eee-4223-ad1c-ef55e3461567'::uuid,
      1,
      'Identifying Removable and Infinite Discontinuities: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f be the piecewise function defined by
f(x) = x + 5, for x < 1
f(x) = 3, for x = 1
f(x) = -x^2 + 4x + 3, for 1 < x < 3
f(x) = 1/(x-3), for x > 3',
      '{"content_key":"apcalcab-frq-u13-005","subject":"ap_calculus_ab","unit":1,"topic":"1.10 Exploring Types of Discontinuities","archetype":"Justification","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Compute lim x->1 f(x) and state f(1).","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Classify and justify the discontinuity at x=1, referencing the definition of continuity, and state how f(1) should be redefined to remove it.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Evaluate lim x->3- f(x) and lim x->3+ f(x). Determine whether lim x->3 f(x) exists, and classify and justify the type of discontinuity at x=3.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]}]}'::jsonb,
      md5('Identifying Removable and Infinite Discontinuities: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('81a6cd06-5c4f-4f4a-ae6c-db46ef7432c0'::uuid, '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'part-a-criterion-01', 'Correct limit lim x->1 f(x) = 6, with valid one-sided computations.', 1, 'Response shows lim x->1- (x+5)=6 and lim x->1+ (-x^2+4x+3)=6.', 'Compute both one-sided limits at x=1 and confirm they equal 6.', '[]'::jsonb),
      ('30944a3d-1af4-4ad1-ab89-e6f810941944'::uuid, '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'part-a-criterion-02', 'Correct value f(1) = 3 read from the piecewise definition.', 1, 'Response states f(1)=3 using the middle piece defined exactly at x=1.', 'Read f(1) directly from the piece defined at x=1.', '[]'::jsonb),
      ('2d360cc2-2ef4-4713-a4a9-015057197583'::uuid, '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'part-b-criterion-01', 'Correct classification as a removable discontinuity with justification.', 1, 'Response states the discontinuity is removable because the limit exists but does not equal f(1).', 'State the discontinuity is removable, justified by comparing lim x->1 f(x)=6 to f(1)=3.', '[]'::jsonb),
      ('87eb447a-0035-4791-ad03-70a9784f9dc4'::uuid, '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'part-b-criterion-02', 'Correct reasoning tied to the continuity definition, identifying which condition fails.', 1, 'Response notes conditions 1 and 2 of continuity hold (f(1) defined, limit exists) but condition 3 fails (limit != f(1)).', 'Identify that the third continuity condition (limit equals function value) is the one that fails.', '[]'::jsonb),
      ('8e0ce1cf-6416-4bf9-a5c4-a20bf30c29fb'::uuid, '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'part-b-criterion-03', 'Correct redefinition: f(1) should be set equal to 6.', 1, 'Response states redefining f(1)=6 removes the discontinuity.', 'State that setting f(1)=6 would make f continuous at x=1.', '[]'::jsonb),
      ('c4378f7c-e65e-4acf-a04e-1fe4b1472913'::uuid, '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'part-c-criterion-01', 'Correct left-hand limit lim x->3- f(x) = 6.', 1, 'Response substitutes x=3 into -x^2+4x+3 to get 6.', 'Substitute x=3 into the middle piece and report 6.', '[]'::jsonb),
      ('e5f5a70b-fa96-4ecb-af7c-2125f974b873'::uuid, '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'part-c-criterion-02', 'Correct right-hand limit lim x->3+ f(x) = positive infinity.', 1, 'Response reasons that as x->3+, x-3 -> 0+, so 1/(x-3) -> +infinity.', 'Analyze the sign of x-3 as x approaches 3 from the right to determine the limit is unbounded.', '[]'::jsonb),
      ('9e3dfa68-ed2c-4fce-ab6c-ad2452b8ec40'::uuid, '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'part-c-criterion-03', 'Correct conclusion that lim x->3 f(x) does not exist, since one side is infinite/unbounded.', 1, 'Response states the two-sided limit DNE because the right-hand limit is infinite.', 'State that the limit does not exist because the right-hand limit is unbounded.', '[]'::jsonb),
      ('1bb7b8ad-6970-495b-a1ad-9f39828fcd01'::uuid, '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'part-c-criterion-04', 'Correct classification as an infinite discontinuity with justification (vertical asymptote at x=3).', 1, 'Response labels the discontinuity as infinite/vertical asymptote type, citing the unbounded one-sided limit.', 'Classify the discontinuity as infinite, referencing the vertical asymptote behavior from the right.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-006'
      and id <> 'e2f4abc1-67d9-4e5f-a7bc-12f34926f0bb'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-006';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'e2f4abc1-67d9-4e5f-a7bc-12f34926f0bb'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'e2f4abc1-67d9-4e5f-a7bc-12f34926f0bb'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-006',
      'frq',
      'Estimating Cooling Rates from a Temperature Table',
      'draft',
      'short',
      'targeted_drill',
      'Connecting Representations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid,
      'e2f4abc1-67d9-4e5f-a7bc-12f34926f0bb'::uuid,
      1,
      'Estimating Cooling Rates from a Temperature Table: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'The temperature T(t), in degrees Celsius, of a cooling object is measured at several times t, in minutes. Selected values are given in the table.
Table 1: Temperature over time
t (min) | 0 | 2 | 4 | 6 | 8
T(t) (C) | 90 | 78 | 68 | 60 | 54',
      '{"content_key":"apcalcab-frq-u13-006","subject":"ap_calculus_ab","unit":2,"topic":"2.3 Estimating Derivatives of a Function at a Point","archetype":"Connecting Representations","difficulty":"Medium","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Approximate T''(4) using a central difference quotient, showing your computation.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Approximate T''(0) using the most appropriate difference quotient available from the table, and explain your choice.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Using correct derivative notation, write an expression for the instantaneous rate of change of temperature at t=6, estimate its value using an appropriate difference quotient, and explain why a central difference quotient generally gives a better approximation of the derivative than a one-sided difference quotient.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]}]}'::jsonb,
      md5('Estimating Cooling Rates from a Temperature Table: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('cc3191ef-e648-4238-a919-3594c94283e0'::uuid, '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid, 'part-a-criterion-01', 'Correct setup using t=2 and t=6: (T(6)-T(2))/(6-2).', 1, 'Response writes the symmetric difference quotient around t=4.', 'Use the values at t=2 and t=6 to form the central difference quotient.', '[]'::jsonb),
      ('4a228382-5236-4c33-a00b-853ec625aa86'::uuid, '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid, 'part-a-criterion-02', 'Correct value of -4.5 C/min.', 1, 'Response computes (60-78)/4 = -4.5.', 'Compute (60-78)/4 and report -4.5 with units.', '[]'::jsonb),
      ('447713be-521d-4706-a8ae-f2edad4b3492'::uuid, '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid, 'part-b-criterion-01', 'Correct identification that only a forward difference is available since t=0 is an endpoint.', 1, 'Response notes there is no data for t<0, so a central or backward difference cannot be formed.', 'Explain that t=0 is the left endpoint of the table, so only a forward difference quotient is possible.', '[]'::jsonb),
      ('4e709019-5d0d-483c-a7ee-6c7faa3b9ea2'::uuid, '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid, 'part-b-criterion-02', 'Correct computation of -6 C/min.', 1, 'Response computes (78-90)/2 = -6.', 'Compute (T(2)-T(0))/2 and report -6 with units.', '[]'::jsonb),
      ('7c0098c2-d6a8-41e8-aa51-3605176e0a29'::uuid, '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid, 'part-b-criterion-03', 'Correct explanation that the result is an approximation, not an exact value.', 1, 'Response notes the forward difference uses an average rate over [0,2], not the instantaneous rate at t=0.', 'Explain that a difference quotient reflects an average rate over an interval and only approximates the instantaneous rate.', '[]'::jsonb),
      ('6f5f4f1d-29a7-4b1b-a559-5230ce703182'::uuid, '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid, 'part-c-criterion-01', 'Correct notation T''(6) introduced.', 1, 'Response explicitly writes T''(6) to denote the instantaneous rate of change at t=6.', 'Introduce the notation T''(6) for the instantaneous rate of change.', '[]'::jsonb),
      ('95a0bdc3-e17d-4df4-aa0a-feb5b70b4fa9'::uuid, '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid, 'part-c-criterion-02', 'Correct estimate of -3.5 C/min with units.', 1, 'Response computes (T(8)-T(4))/(8-4) = (54-68)/4 = -3.5.', 'Compute the central difference quotient using t=4 and t=8, and report -3.5 with units.', '[]'::jsonb),
      ('084a0c93-1b4b-4a2b-a73f-8facb59da001'::uuid, '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid, 'part-c-criterion-03', 'Correct general explanation that a central difference incorporates behavior from both sides of the point.', 1, 'Response explains the central difference averages information from before and after t=6.', 'Explain that the central difference uses data symmetric about t=6 rather than only one side.', '[]'::jsonb),
      ('757621b0-822f-40c5-a6ce-308608094bf4'::uuid, '7a388fa6-b8ac-4a92-a78f-be9cecf03b98'::uuid, 'part-c-criterion-04', 'Correct comparison to one-sided quotients, referencing the two-sided nature of the derivative''s limit definition.', 1, 'Response notes the derivative is defined as a two-sided limit, so a symmetric estimate tends to better match it than a one-sided estimate.', 'Explain that since the derivative is a two-sided limit, one-sided quotients capture rate of change from only one direction and tend to be less accurate.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-007'
      and id <> '8f556122-1c8c-4d70-ae52-ad650646169a'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-007';
  end if;

  if not exists (
    select 1 from app.content_items where id = '8f556122-1c8c-4d70-ae52-ad650646169a'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '8f556122-1c8c-4d70-ae52-ad650646169a'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-007',
      'frq',
      'Polynomial Derivatives Using Basic Differentiation Rules',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid,
      '8f556122-1c8c-4d70-ae52-ad650646169a'::uuid,
      1,
      'Polynomial Derivatives Using Basic Differentiation Rules: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f(x) = 3x^4 - 8x^3 + 5x - 6.',
      '{"content_key":"apcalcab-frq-u13-007","subject":"ap_calculus_ab","unit":2,"topic":"2.5 Applying the Power Rule","archetype":"Implementing Mathematical Processes","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Find f''(x) using the power rule together with the sum, difference, and constant multiple rules. Show the derivative of each term.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Evaluate f''(1) and f''(-1). Then, using correct notation, state the equation that would need to be solved to find the x-values where the tangent line to f is horizontal (do not solve the equation).","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Let g(x) = 5f(x) - 2x^3. Find g''(x), showing your use of the constant multiple rule and the sum/difference rule.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Polynomial Derivatives Using Basic Differentiation Rules: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('e12822f5-1203-4d55-ab96-a30e34e11d0f'::uuid, '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'part-a-criterion-01', 'Correct application of the power rule to the first two terms: derivative of 3x^4 is 12x^3 and derivative of -8x^3 is -24x^2.', 1, 'Response shows 3x^4 -> 12x^3 and -8x^3 -> -24x^2.', 'Apply the power rule to 3x^4 and -8x^3 separately, showing the exponent brought down and reduced by 1.', '[]'::jsonb),
      ('f4e7333b-d147-452d-a901-10439ded6413'::uuid, '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'part-a-criterion-02', 'Correct derivative of the linear and constant terms: derivative of 5x is 5, and derivative of -6 is 0.', 1, 'Response shows 5x -> 5 and -6 -> 0.', 'Apply the constant multiple rule to 5x and the constant rule to -6.', '[]'::jsonb),
      ('15e530f2-cc0e-42e5-af05-cecab2ff412e'::uuid, '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'part-a-criterion-03', 'Correct fully assembled derivative f''(x) = 12x^3 - 24x^2 + 5.', 1, 'Response states the final combined derivative.', 'Combine all term derivatives into the single expression f''(x)=12x^3-24x^2+5.', '[]'::jsonb),
      ('ed29a8d2-f8b9-4153-aa6c-f953c24cd499'::uuid, '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'part-b-criterion-01', 'Correct value f''(1) = -7.', 1, 'Response computes 12-24+5=-7.', 'Substitute x=1 into f''(x) and report -7.', '[]'::jsonb),
      ('03b254f7-db33-4f05-a326-185e058c8e6a'::uuid, '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'part-b-criterion-02', 'Correct value f''(-1) = -31.', 1, 'Response computes -12-24+5=-31.', 'Substitute x=-1 into f''(x) and report -31.', '[]'::jsonb),
      ('2faae6c7-5550-405b-a6ae-1dbd1909e35d'::uuid, '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'part-b-criterion-03', 'Correct equation 12x^3-24x^2+5 = 0 stated, with correct reasoning that horizontal tangents occur where f''(x)=0.', 1, 'Response sets f''(x) equal to 0 and explains this identifies horizontal tangent locations.', 'State the equation f''(x)=0 explicitly and explain why this locates horizontal tangents.', '[]'::jsonb),
      ('67a6bf83-6560-49ee-ab2d-cef39ce4bc51'::uuid, '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'part-c-criterion-01', 'Correct application of the constant multiple rule: g''(x) = 5f''(x) - 6x^2.', 1, 'Response differentiates 5f(x) as 5f''(x) and -2x^3 as -6x^2.', 'Apply the constant multiple rule to 5f(x) and the power rule to -2x^3.', '[]'::jsonb),
      ('b2af9bfd-955c-4238-ada3-559f06c54351'::uuid, '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'part-c-criterion-02', 'Correct substitution of f''(x) from part A.', 1, 'Response substitutes 12x^3-24x^2+5 in place of f''(x).', 'Substitute the expression for f''(x) found in part A.', '[]'::jsonb),
      ('3e9f5bd0-48c2-44e4-a618-1d1bcc94abd3'::uuid, '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'part-c-criterion-03', 'Correct simplified final answer g''(x) = 60x^3 - 126x^2 + 25.', 1, 'Response simplifies 5(12x^3-24x^2+5) - 6x^2 to 60x^3-126x^2+25.', 'Distribute and combine like terms to reach the fully simplified derivative.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-008'
      and id <> '0ff4a511-424a-43c5-ad4a-c2267fbebe01'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-008';
  end if;

  if not exists (
    select 1 from app.content_items where id = '0ff4a511-424a-43c5-ad4a-c2267fbebe01'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '0ff4a511-424a-43c5-ad4a-c2267fbebe01'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-008',
      'frq',
      'Differentiating a Product of a Polynomial and an Exponential',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid,
      '0ff4a511-424a-43c5-ad4a-c2267fbebe01'::uuid,
      1,
      'Differentiating a Product of a Polynomial and an Exponential: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let h(x) = x^2 * e^x.',
      '{"content_key":"apcalcab-frq-u13-008","subject":"ap_calculus_ab","unit":2,"topic":"2.8 The Product Rule","archetype":"Implementing Mathematical Processes","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"State the product rule and identify u(x), u''(x), v(x), and v''(x) for h(x).","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Compute h''(x), fully simplified.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Evaluate h''(0) and h''(1), and interpret h''(0) as the slope of the tangent line to y = h(x) at x = 0.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Differentiating a Product of a Polynomial and an Exponential: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('e7fd32c4-4ef1-4967-afd1-ce4779858c2e'::uuid, 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'part-a-criterion-01', 'Correct statement of the product rule (uv)'' = u''v + uv''.', 1, 'Response writes the general product rule formula.', 'State the product rule formula explicitly before applying it.', '[]'::jsonb),
      ('a4b64039-f37a-4449-aa3c-b381077cbbe6'::uuid, 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'part-a-criterion-02', 'Correct identification u = x^2, u'' = 2x.', 1, 'Response identifies u(x)=x^2 and its derivative 2x.', 'Identify u(x)=x^2 and compute u''(x)=2x.', '[]'::jsonb),
      ('ba976b62-9246-4907-ab51-18631e9a549d'::uuid, 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'part-a-criterion-03', 'Correct identification v = e^x, v'' = e^x.', 1, 'Response identifies v(x)=e^x and its derivative e^x.', 'Identify v(x)=e^x and state v''(x)=e^x.', '[]'::jsonb),
      ('9caf84c9-6c42-4418-a12a-42936cbc4bb7'::uuid, 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'part-b-criterion-01', 'Correct substitution into the product rule: h''(x) = 2x*e^x + x^2*e^x.', 1, 'Response writes the unsimplified sum from the product rule.', 'Substitute u, u'', v, v'' into the product rule formula.', '[]'::jsonb),
      ('74a2b46f-7e4f-48df-ad39-8ef4e3c17eec'::uuid, 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'part-b-criterion-02', 'Correct factoring/simplification to e^x(x^2+2x).', 1, 'Response factors out e^x from both terms.', 'Factor the common factor e^x out of both terms.', '[]'::jsonb),
      ('37d0178b-0264-4730-a5c8-91cf66235eb1'::uuid, 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'part-b-criterion-03', 'Correct final answer stated clearly, e.g., h''(x) = e^x*x*(x+2).', 1, 'Response presents a fully simplified equivalent form.', 'State the fully simplified final derivative.', '[]'::jsonb),
      ('df71494b-2e48-4d51-ae07-a7e6dbc5fcc6'::uuid, 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'part-c-criterion-01', 'Correct value h''(0) = 0.', 1, 'Response computes e^0(0+0)=0.', 'Substitute x=0 into h''(x) and report 0.', '[]'::jsonb),
      ('d17d2f0d-ad6d-41a0-a0c8-36c5586ee9a0'::uuid, 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'part-c-criterion-02', 'Correct value h''(1) = 3e (approximately 8.15).', 1, 'Response computes e^1(1+2)=3e.', 'Substitute x=1 into h''(x) and report 3e.', '[]'::jsonb),
      ('714ca738-7936-4182-a62d-b1538a0778c8'::uuid, 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'part-c-criterion-03', 'Correct interpretation that the tangent line to h at x=0 is horizontal since its slope is 0.', 1, 'Response explicitly connects h''(0)=0 to a horizontal tangent line at x=0.', 'State that a slope of 0 at x=0 means the tangent line to y=h(x) there is horizontal.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-009'
      and id <> '4e34ecb4-4ced-4dc3-a4c4-1a2749ac2e75'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-009';
  end if;

  if not exists (
    select 1 from app.content_items where id = '4e34ecb4-4ced-4dc3-a4c4-1a2749ac2e75'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '4e34ecb4-4ced-4dc3-a4c4-1a2749ac2e75'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-009',
      'frq',
      'Differentiating a Composite Trigonometric Function',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid,
      '4e34ecb4-4ced-4dc3-a4c4-1a2749ac2e75'::uuid,
      1,
      'Differentiating a Composite Trigonometric Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f(x) = sin(3x^2 - 5x).',
      '{"content_key":"apcalcab-frq-u13-009","subject":"ap_calculus_ab","unit":3,"topic":"3.1 The Chain Rule","archetype":"Implementing Mathematical Processes","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Identify the outer and inner functions used in the chain rule for f(x), state the chain rule, and find the derivative of the inner function.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Compute f''(x).","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Evaluate f''(0) using correct notation, and determine whether the graph of f has a horizontal tangent at x = 5/6, justifying your answer.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Differentiating a Composite Trigonometric Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('0c9c1c0f-09b2-40e2-a7fc-786d9b031759'::uuid, '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'part-a-criterion-01', 'Correct identification of the outer function sin(u) and inner function u = 3x^2-5x.', 1, 'Response separates f(x) into sin(u) with u=3x^2-5x.', 'Identify the outer function as sine and the inner function as 3x^2-5x.', '[]'::jsonb),
      ('c00da6ca-d05a-418c-aa92-fc65f56c869a'::uuid, '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'part-a-criterion-02', 'Correct statement of the chain rule d/dx[f(g(x))] = f''(g(x))*g''(x).', 1, 'Response states the general chain rule formula.', 'State the chain rule formula explicitly.', '[]'::jsonb),
      ('03d06b25-863f-4b1d-ab21-f9bb44f7bf34'::uuid, '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'part-a-criterion-03', 'Correct inner derivative g''(x) = 6x - 5.', 1, 'Response differentiates 3x^2-5x to get 6x-5.', 'Differentiate the inner function 3x^2-5x.', '[]'::jsonb),
      ('3705df0c-e148-499b-a9be-cbf8dff40685'::uuid, '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'part-b-criterion-01', 'Correct outer derivative cos(3x^2-5x).', 1, 'Response writes the derivative of sin(u) as cos(u) with u unchanged.', 'Differentiate the outer sine function, keeping the inner function unchanged.', '[]'::jsonb),
      ('ee7a0178-91db-421d-a89c-dec984d8ce7f'::uuid, '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'part-b-criterion-02', 'Correct multiplication by the inner derivative (6x-5).', 1, 'Response multiplies cos(3x^2-5x) by (6x-5).', 'Multiply the outer derivative by the inner derivative found in part A.', '[]'::jsonb),
      ('810c421d-ab40-41ea-a7fd-91f1fd713d2c'::uuid, '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'part-b-criterion-03', 'Correct final answer f''(x) = (6x-5)cos(3x^2-5x).', 1, 'Response states the fully assembled derivative.', 'State the final combined derivative expression.', '[]'::jsonb),
      ('ceed9adf-bd4f-4efd-a3c3-ad4718eccb1e'::uuid, '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'part-c-criterion-01', 'Correct value f''(0) = -5, with correct notation.', 1, 'Response computes (0-5)cos(0) = -5.', 'Substitute x=0 into f''(x) using correct notation and report -5.', '[]'::jsonb),
      ('cfeccdfa-497b-4a24-af67-c07f77c62d94'::uuid, '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'part-c-criterion-02', 'Correct evaluation that f''(5/6) = 0, since 6(5/6)-5 = 0.', 1, 'Response shows the factor (6x-5) vanishes at x=5/6, making the whole derivative 0 regardless of the cosine factor.', 'Substitute x=5/6 and show the factor (6x-5) equals 0.', '[]'::jsonb),
      ('90aa203b-a96f-4b15-a13f-503eca106975'::uuid, '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'part-c-criterion-03', 'Correct conclusion with justification that the graph has a horizontal tangent at x=5/6 because f''(5/6)=0.', 1, 'Response explicitly concludes a horizontal tangent exists, referencing f''(5/6)=0.', 'State the conclusion that a horizontal tangent exists at x=5/6, justified by f''(5/6)=0.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-010'
      and id <> '6dc8e836-25e9-44e3-a58a-f48b72880133'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-010';
  end if;

  if not exists (
    select 1 from app.content_items where id = '6dc8e836-25e9-44e3-a58a-f48b72880133'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '6dc8e836-25e9-44e3-a58a-f48b72880133'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-010',
      'frq',
      'Applying and Interpreting the Intermediate Value Theorem',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'daf9d061-631a-4f52-a59d-92d39431e448'::uuid,
      '6dc8e836-25e9-44e3-a58a-f48b72880133'::uuid,
      1,
      'Applying and Interpreting the Intermediate Value Theorem: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'The function k is continuous on the closed interval [0,4]. Selected values of k are given in the table.
Table 1: Values of k
x | 0 | 1 | 2 | 3 | 4
k(x) | -3 | 2 | 1 | -4 | 5',
      '{"content_key":"apcalcab-frq-u13-010","subject":"ap_calculus_ab","unit":1,"topic":"1.16 Working with the Intermediate Value Theorem","archetype":"Justification","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use the Intermediate Value Theorem to justify that there is a value c in (0,1) such that k(c) = 0.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Justify whether the Intermediate Value Theorem guarantees a value c in (1,3) such that k(c) = -1.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"A student claims: \"Since k(2)=1 and k(3)=-4, and 0 is between these values, the IVT guarantees exactly one c in (2,3) with k(c)=0.\" Explain what part of the student''s claim is incorrect, and state the correct conclusion.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Applying and Interpreting the Intermediate Value Theorem: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('eb8569db-527a-4326-ac3b-3a8f55dfdc5a'::uuid, 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'part-a-criterion-01', 'States that k is continuous on [0,1], satisfying the hypothesis of the IVT.', 1, 'Response notes k is continuous on [0,1] since it is continuous on all of [0,4].', 'State that k is continuous on the interval [0,1].', '[]'::jsonb),
      ('76782140-32e0-42b8-a884-1d872e04049a'::uuid, 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'part-a-criterion-02', 'Correctly notes k(0) = -3 < 0 < 2 = k(1), so 0 lies between k(0) and k(1).', 1, 'Response compares 0 to the endpoint values -3 and 2.', 'Show that 0 is between k(0) and k(1) using the table values.', '[]'::jsonb),
      ('66b4aec9-e4dc-47f8-a647-163917083c74'::uuid, 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'part-a-criterion-03', 'Correct conclusion by the IVT that there exists c in (0,1) with k(c) = 0.', 1, 'Response concludes existence of such a c, citing the IVT.', 'State the IVT conclusion that at least one such c exists in (0,1).', '[]'::jsonb),
      ('974052df-8e95-49de-ab11-44ee8e318c22'::uuid, 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'part-b-criterion-01', 'Correctly identifies that -1 lies between k(1)=2 and k(3)=-4.', 1, 'Response compares -1 to the endpoint values 2 and -4.', 'Show that -1 lies between k(1) and k(3).', '[]'::jsonb),
      ('52bbdcf4-9a1f-4a9d-a6e9-0a0e3f251fae'::uuid, 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'part-b-criterion-02', 'Correctly notes k is continuous on [1,3], satisfying the hypothesis.', 1, 'Response states continuity on [1,3] holds.', 'State that k is continuous on the interval [1,3].', '[]'::jsonb),
      ('113fa9df-3a49-45e2-a24c-44d7d4a61a83'::uuid, 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'part-b-criterion-03', 'Correct conclusion that yes, the IVT guarantees at least one c in (1,3) with k(c) = -1.', 1, 'Response concludes existence is guaranteed.', 'State the correct yes/no conclusion with the IVT justification.', '[]'::jsonb),
      ('a81adfe3-db5a-48a5-aaf5-de38b365f56c'::uuid, 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'part-c-criterion-01', 'Correctly identifies the error: the IVT guarantees existence of at least one c, not uniqueness ("exactly one" is unjustified).', 1, 'Response points out the flaw is the claim of exactly one solution.', 'Identify that the phrase "exactly one" is not supported by the IVT.', '[]'::jsonb),
      ('839e30fc-aea0-4095-a8cb-6c8733a5bdf9'::uuid, 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'part-c-criterion-02', 'Correct explanation referencing that k could cross the value 0 multiple times in (2,3) without contradicting the IVT or continuity.', 1, 'Response explains multiple crossings are possible since the IVT says nothing about uniqueness.', 'Explain that a continuous function can attain a value more than once between two points.', '[]'::jsonb),
      ('250bd652-78b7-4e68-a17b-b7d8df0d1023'::uuid, 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'part-c-criterion-03', 'Correct restated conclusion: the IVT guarantees at least one (not necessarily exactly one) c in (2,3) with k(c)=0.', 1, 'Response gives the corrected, accurate conclusion.', 'State the corrected conclusion using "at least one" instead of "exactly one."', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-011'
      and id <> 'fadbfde2-fef7-4159-adc5-9a5b51490a24'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-011';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'fadbfde2-fef7-4159-adc5-9a5b51490a24'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'fadbfde2-fef7-4159-adc5-9a5b51490a24'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-011',
      'frq',
      'Sign Analysis Near Vertical Asymptotes of a Rational Function',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid,
      'fadbfde2-fef7-4159-adc5-9a5b51490a24'::uuid,
      1,
      'Sign Analysis Near Vertical Asymptotes of a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let r(x) = (2x^2 - 3x - 5)/(x^2 - 4).',
      '{"content_key":"apcalcab-frq-u13-011","subject":"ap_calculus_ab","unit":1,"topic":"1.14 Connecting Infinite Limits and Vertical Asymptotes","archetype":"Justification","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Determine the locations of the vertical asymptotes of r, showing your factoring.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Evaluate lim x->2+ r(x) and lim x->2- r(x), justifying the sign of each using sign analysis.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Evaluate lim x->-2+ r(x) and lim x->-2- r(x), justifying using sign analysis, and state the equation of the vertical asymptote at x=-2 using correct notation.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Sign Analysis Near Vertical Asymptotes of a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('8de24688-014c-478b-a11d-f33934fb396b'::uuid, 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'part-a-criterion-01', 'Correct factoring of the numerator (2x-5)(x+1) and denominator (x-2)(x+2).', 1, 'Response factors 2x^2-3x-5 and x^2-4 completely.', 'Factor both the numerator and denominator of r(x).', '[]'::jsonb),
      ('75d878ac-d201-4b48-a714-5ad2457bbc6a'::uuid, 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'part-a-criterion-02', 'Correctly determines there are no common factors, so both x=2 and x=-2 are candidates for vertical asymptotes.', 1, 'Response notes (2x-5)(x+1) shares no factor with (x-2)(x+2).', 'Check for common factors between numerator and denominator before concluding.', '[]'::jsonb),
      ('422fae45-74be-4c98-aa2a-8401de6d63ef'::uuid, 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'part-a-criterion-03', 'Correct final statement that vertical asymptotes occur at x=2 and x=-2.', 1, 'Response states both vertical asymptote locations.', 'State both vertical asymptote locations explicitly.', '[]'::jsonb),
      ('d9691100-de4b-414b-a360-ee89c66dbacb'::uuid, 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'part-b-criterion-01', 'Correct sign analysis of the numerator near x=2 (negative, approximately -3).', 1, 'Response evaluates the numerator at x=2 as 2(4)-6-5=-3.', 'Evaluate the numerator near x=2 to determine its sign.', '[]'::jsonb),
      ('8f80654c-cf4d-48fa-a264-437910311cb7'::uuid, 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'part-b-criterion-02', 'Correct sign analysis of the denominator approaching from each side (0+ from the right, 0- from the left).', 1, 'Response determines (x-2)(x+2) is positive as x->2+ and negative as x->2-.', 'Analyze the sign of (x-2)(x+2) as x approaches 2 from each side.', '[]'::jsonb),
      ('a89647ba-5db6-459f-adf9-db2592633e06'::uuid, 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'part-b-criterion-03', 'Correct conclusion: lim x->2+ r(x) = negative infinity and lim x->2- r(x) = positive infinity.', 1, 'Response combines the signs to reach the correct infinite limits.', 'Combine the numerator and denominator signs to state both one-sided infinite limits.', '[]'::jsonb),
      ('bcd30ed9-0fe0-45bc-aa82-37970f41501d'::uuid, 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'part-c-criterion-01', 'Correct sign analysis near x=-2 (numerator positive, approximately 9).', 1, 'Response evaluates the numerator at x=-2 as 2(4)+6-5=9.', 'Evaluate the numerator near x=-2 to determine its sign.', '[]'::jsonb),
      ('eafd6b73-7eb2-43dc-a4a2-19b67de6e570'::uuid, 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'part-c-criterion-02', 'Correct determination that lim x->-2+ r(x) = negative infinity and lim x->-2- r(x) = positive infinity, with sign justification.', 1, 'Response analyzes the sign of the denominator on each side of -2 and combines with the positive numerator.', 'Analyze the denominator''s sign on each side of x=-2 and combine with the numerator sign.', '[]'::jsonb),
      ('c9f9fe20-063f-495b-af4e-48eee380133d'::uuid, 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'part-c-criterion-03', 'Correct notation stating the vertical asymptote equation x = -2.', 1, 'Response writes the equation x=-2 explicitly.', 'State the vertical asymptote using the equation x=-2.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-012'
      and id <> '309b92e3-e8ed-4edf-a949-838f22b00ae3'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-012';
  end if;

  if not exists (
    select 1 from app.content_items where id = '309b92e3-e8ed-4edf-a949-838f22b00ae3'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '309b92e3-e8ed-4edf-a949-838f22b00ae3'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-012',
      'frq',
      'Reconciling a Table of Values with a Stated Function Value',
      'draft',
      'short',
      'targeted_drill',
      'Connecting Representations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '87949000-95db-4cf3-a1eb-c14767be7728'::uuid,
      '309b92e3-e8ed-4edf-a949-838f22b00ae3'::uuid,
      1,
      'Reconciling a Table of Values with a Stated Function Value: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Selected values of a function m near x=2 are given in the table. It is also known that m(2) = 5.
Table 1: Values of m near x = 2
x | 1 | 1.9 | 1.99 | 2.01 | 2.1 | 3
m(x) | 4.00 | 5.72 | 5.97 | 6.03 | 6.28 | 8.00',
      '{"content_key":"apcalcab-frq-u13-012","subject":"ap_calculus_ab","unit":1,"topic":"1.9 Connecting Multiple Representations of Limits","archetype":"Connecting Representations","difficulty":"Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Using the table, estimate lim x->2- m(x) and lim x->2+ m(x). State lim x->2 m(x) if it exists, and justify your answer using the table values.","points":4,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1}]},{"part_key":"part-b","prompt":"Given that m(2) = 5, use the definition of continuity to justify whether m is continuous at x=2, and classify the discontinuity, if any.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Define a new function n(x) that agrees with m(x) everywhere except redefined at x=2 to remove the discontinuity found in part B, and state n(2).","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Reconciling a Table of Values with a Stated Function Value: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('aaae3bed-96ea-4428-aea6-c0abb9730bbe'::uuid, '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'part-a-criterion-01', 'Correct estimate lim x->2- m(x) is approximately 6, supported by the trend 5.72, 5.97 approaching 6.', 1, 'Response cites the values at x=1.9 and x=1.99 trending toward 6.', 'Use the values at x=1.9 and x=1.99 to justify the left-hand estimate of 6.', '[]'::jsonb),
      ('444f81bf-9dd3-4d7c-aa6c-2d9deef79ef7'::uuid, '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'part-a-criterion-02', 'Correct estimate lim x->2+ m(x) is approximately 6, supported by the trend 6.03, 6.28 approaching 6.', 1, 'Response cites the values at x=2.01 and x=2.1 trending toward 6.', 'Use the values at x=2.01 and x=2.1 to justify the right-hand estimate of 6.', '[]'::jsonb),
      ('ffedaa48-d290-4af9-a6ad-2988a3676222'::uuid, '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'part-a-criterion-03', 'Correct conclusion that the two-sided limit exists and equals 6.', 1, 'Response states lim x->2 m(x) = 6.', 'State that the two-sided limit exists and equals 6.', '[]'::jsonb),
      ('f92e1509-6fca-42e3-aad1-e4036f651ce0'::uuid, '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'part-a-criterion-04', 'Correct justification referencing that both one-sided estimates approach the same value.', 1, 'Response explains the left and right trends both converge to 6, so the two-sided limit exists.', 'Justify existence by noting both one-sided trends approach the same value.', '[]'::jsonb),
      ('af805d09-5f6d-4c59-a4e3-390de4e8b975'::uuid, '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'part-b-criterion-01', 'Correct application of the continuity definition, comparing lim x->2 m(x)=6 to m(2)=5.', 1, 'Response explicitly compares the limit value to the function value.', 'Compare the limit from part A to the given value m(2)=5.', '[]'::jsonb),
      ('21397664-7705-4df6-a0ab-ec158d154acf'::uuid, '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'part-b-criterion-02', 'Correct conclusion that m is not continuous at x=2 since the limit does not equal m(2).', 1, 'Response states continuity fails because 6 != 5.', 'State that m is not continuous at x=2, citing the mismatch between the limit and function value.', '[]'::jsonb),
      ('f5b509e2-14de-49da-a41f-7d2cd0b8d125'::uuid, '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'part-b-criterion-03', 'Correct classification as a removable discontinuity, with justification.', 1, 'Response classifies the discontinuity as removable since the limit exists but does not match f(2).', 'Classify the discontinuity as removable, justified by the existing limit not matching the function value.', '[]'::jsonb),
      ('32ce17fe-3434-4681-a84c-a00e76e7acb0'::uuid, '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'part-c-criterion-01', 'Correct construction: n(x) = m(x) for x != 2.', 1, 'Response defines n to match m everywhere except at x=2.', 'Define n(x) equal to m(x) for all x not equal to 2.', '[]'::jsonb),
      ('c6b8c3d8-56b0-4721-a3dd-2d8aefe2bbb7'::uuid, '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'part-c-criterion-02', 'Correct value n(2) = 6 to make n continuous at x=2.', 1, 'Response sets n(2) equal to the limit value 6.', 'Set n(2) equal to the limit value found in part A, which is 6.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-013'
      and id <> 'd321b97f-deff-4056-ab62-ff29b0af5bbb'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-013';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'd321b97f-deff-4056-ab62-ff29b0af5bbb'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'd321b97f-deff-4056-ab62-ff29b0af5bbb'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-013',
      'frq',
      'Differentiating a Rational Function and Finding a Tangent Line',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid,
      'd321b97f-deff-4056-ab62-ff29b0af5bbb'::uuid,
      1,
      'Differentiating a Rational Function and Finding a Tangent Line: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let p(x) = (3x^2 + 1)/(x - 4).',
      '{"content_key":"apcalcab-frq-u13-013","subject":"ap_calculus_ab","unit":2,"topic":"2.9 The Quotient Rule","archetype":"Implementing Mathematical Processes","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"State the quotient rule and identify u, u'', v, and v'' for p(x).","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Compute p''(x), fully simplified.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Evaluate p''(0), and determine an equation of the tangent line to y=p(x) at x=0.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Differentiating a Rational Function and Finding a Tangent Line: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('9399f06e-f559-40d9-a942-a236f702d55a'::uuid, '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'part-a-criterion-01', 'Correct quotient rule formula (u/v)'' = (u''v - uv'')/v^2.', 1, 'Response writes the general quotient rule formula.', 'State the quotient rule formula explicitly.', '[]'::jsonb),
      ('1d7cf927-38a4-420a-a0d2-9deac873a21c'::uuid, '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'part-a-criterion-02', 'Correct identification u = 3x^2+1, u'' = 6x.', 1, 'Response identifies u(x) and its derivative correctly.', 'Identify u(x)=3x^2+1 and compute u''(x)=6x.', '[]'::jsonb),
      ('8442acaa-34e8-4826-ab35-f13369fa7593'::uuid, '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'part-a-criterion-03', 'Correct identification v = x-4, v'' = 1.', 1, 'Response identifies v(x) and its derivative correctly.', 'Identify v(x)=x-4 and compute v''(x)=1.', '[]'::jsonb),
      ('9e783921-cfd7-4ac0-a78a-e6b0f23f9d17'::uuid, '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'part-b-criterion-01', 'Correct substitution into the quotient rule.', 1, 'Response writes [6x(x-4) - (3x^2+1)(1)]/(x-4)^2.', 'Substitute u, u'', v, v'' into the quotient rule formula.', '[]'::jsonb),
      ('d7987de9-4c11-4def-ac78-30a2165bb04d'::uuid, '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'part-b-criterion-02', 'Correct expansion and simplification of the numerator to 3x^2-24x-1.', 1, 'Response expands 6x^2-24x-3x^2-1 to 3x^2-24x-1.', 'Expand and combine like terms in the numerator.', '[]'::jsonb),
      ('bb64abce-c607-47e5-a49a-39361135df67'::uuid, '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'part-b-criterion-03', 'Correct final answer p''(x) = (3x^2-24x-1)/(x-4)^2.', 1, 'Response states the fully simplified derivative.', 'State the final simplified derivative.', '[]'::jsonb),
      ('4dcd7ab2-b2f4-4de4-a21e-858377e63c94'::uuid, '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'part-c-criterion-01', 'Correct value p(0) = -1/4.', 1, 'Response computes (0+1)/(0-4) = -1/4.', 'Substitute x=0 into p(x) and report -1/4.', '[]'::jsonb),
      ('72291f9b-2f7e-431e-a2df-7632f7a6866b'::uuid, '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'part-c-criterion-02', 'Correct value p''(0) = -1/16.', 1, 'Response computes (0-0-1)/16 = -1/16.', 'Substitute x=0 into p''(x) and report -1/16.', '[]'::jsonb),
      ('9fcaab97-fbad-46fb-af0a-8b3c7cf33ebf'::uuid, '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'part-c-criterion-03', 'Correct tangent line equation y = -1/16 x - 1/4 (or equivalent point-slope form).', 1, 'Response writes the tangent line using point (0,-1/4) and slope -1/16.', 'Write the tangent line equation using the point and slope found.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-014'
      and id <> 'b2443f7f-3ce4-4271-ac2d-94f6b65a6e63'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-014';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'b2443f7f-3ce4-4271-ac2d-94f6b65a6e63'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'b2443f7f-3ce4-4271-ac2d-94f6b65a6e63'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-014',
      'frq',
      'Differentiating a Combination of Tangent and Secant',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '3b86e94b-3723-498c-a653-2952a034223c'::uuid,
      'b2443f7f-3ce4-4271-ac2d-94f6b65a6e63'::uuid,
      1,
      'Differentiating a Combination of Tangent and Secant: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let q(x) = tan(x) + 3 sec(x) - 2x.',
      '{"content_key":"apcalcab-frq-u13-014","subject":"ap_calculus_ab","unit":2,"topic":"2.10 Derivatives of tan x, cot x, sec x, and csc x","archetype":"Implementing Mathematical Processes","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"State the derivative formulas for tan x and sec x, then compute q''(x).","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Evaluate q''(pi/4) exactly, showing the exact trig values used.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Determine whether the graph of q has a horizontal tangent line at x=0, justifying using q''(0).","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Differentiating a Combination of Tangent and Secant: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ac0cf645-840d-4144-a57f-56f25b401c2a'::uuid, '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'part-a-criterion-01', 'Correct formula d/dx[tan x] = sec^2(x), used in the derivative.', 1, 'Response states and uses this formula for the tan term.', 'State and apply the derivative formula for tan x.', '[]'::jsonb),
      ('a09c0c61-6453-4f32-ab03-1e16a1a9a9e6'::uuid, '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'part-a-criterion-02', 'Correct formula d/dx[sec x] = sec(x)tan(x), used with the constant multiple 3.', 1, 'Response states and uses this formula, multiplied by 3, for the sec term.', 'State and apply the derivative formula for sec x, including the constant multiple of 3.', '[]'::jsonb),
      ('93a2a627-1273-42a9-ae25-05cef7eb7ffd'::uuid, '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'part-a-criterion-03', 'Correct assembled derivative q''(x) = sec^2(x) + 3sec(x)tan(x) - 2, including the derivative of -2x.', 1, 'Response combines all three term derivatives correctly, including -2 for the linear term.', 'Combine all term derivatives, including the derivative of -2x, into the final expression.', '[]'::jsonb),
      ('0af166ed-5c62-41fc-a821-188a9e1d1f44'::uuid, '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'part-b-criterion-01', 'Correct exact values sec(pi/4) = sqrt(2) and tan(pi/4) = 1 used.', 1, 'Response substitutes these known exact trig values.', 'Substitute the exact values sec(pi/4)=sqrt(2) and tan(pi/4)=1.', '[]'::jsonb),
      ('8a469faf-08c6-4cba-a2ea-80f9654658c3'::uuid, '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'part-b-criterion-02', 'Correct computation sec^2(pi/4) = 2.', 1, 'Response squares sqrt(2) to get 2.', 'Square sec(pi/4) to obtain 2.', '[]'::jsonb),
      ('fe5e0fa7-fced-415e-a6f3-5b0434095a72'::uuid, '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'part-b-criterion-03', 'Correct final exact value q''(pi/4) = 3*sqrt(2).', 1, 'Response computes 2 + 3*sqrt(2)*1 - 2 = 3*sqrt(2).', 'Combine terms to reach the final exact value 3*sqrt(2).', '[]'::jsonb),
      ('f04b7099-965b-48e6-a1c1-ad8dc77cbdbe'::uuid, '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'part-c-criterion-01', 'Correct exact values sec(0)=1 and tan(0)=0 used.', 1, 'Response substitutes these known exact trig values.', 'Substitute the exact values sec(0)=1 and tan(0)=0.', '[]'::jsonb),
      ('baf5d6f6-103f-443c-a468-06b0966c90f0'::uuid, '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'part-c-criterion-02', 'Correct computation q''(0) = 1 + 0 - 2 = -1.', 1, 'Response combines the substituted values to get -1.', 'Combine the substituted values to compute q''(0).', '[]'::jsonb),
      ('42e0e5f2-7f77-4e63-a9cf-709129f32395'::uuid, '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'part-c-criterion-03', 'Correct conclusion with justification that there is no horizontal tangent at x=0, since q''(0) = -1 is not 0.', 1, 'Response explicitly states no horizontal tangent exists, referencing the nonzero derivative value.', 'State that a horizontal tangent requires the derivative to equal 0, and since q''(0)=-1, no horizontal tangent exists there.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-015'
      and id <> '0ed66e29-f575-4879-afe5-24b90952311a'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-015';
  end if;

  if not exists (
    select 1 from app.content_items where id = '0ed66e29-f575-4879-afe5-24b90952311a'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '0ed66e29-f575-4879-afe5-24b90952311a'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-015',
      'frq',
      'Implicit Differentiation of a Curve and Its Tangent Line',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid,
      '0ed66e29-f575-4879-afe5-24b90952311a'::uuid,
      1,
      'Implicit Differentiation of a Curve and Its Tangent Line: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Consider the curve defined implicitly by x^2 + xy + y^2 = 7. The point (2,1) lies on this curve, since 2^2 + (2)(1) + 1^2 = 4+2+1 = 7.',
      '{"content_key":"apcalcab-frq-u13-015","subject":"ap_calculus_ab","unit":3,"topic":"3.2 Implicit Differentiation","archetype":"Implementing Mathematical Processes","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Differentiate both sides of x^2 + xy + y^2 = 7 implicitly with respect to x, showing correct use of the product rule on the xy term.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Solve for dy/dx in terms of x and y.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Evaluate dy/dx at the point (2,1), and write an equation for the tangent line to the curve at this point.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Implicit Differentiation of a Curve and Its Tangent Line: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('af55effd-4ae8-4f08-a72e-afe490c1502a'::uuid, 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'part-a-criterion-01', 'Correct derivative of the x^2 term: 2x.', 1, 'Response differentiates x^2 to get 2x.', 'Differentiate x^2 with respect to x.', '[]'::jsonb),
      ('00c232ae-6d03-47ec-a821-3a777d2896a2'::uuid, 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'part-a-criterion-02', 'Correct product rule applied to the xy term: y + x*y''.', 1, 'Response applies the product rule to xy, getting y + x*dy/dx.', 'Apply the product rule to the xy term, treating y as a function of x.', '[]'::jsonb),
      ('c45857c0-0840-4b94-ad23-f1193d7d82ea'::uuid, 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'part-a-criterion-03', 'Correct derivative of the y^2 term via the chain rule: 2y*y''.', 1, 'Response differentiates y^2 to get 2y*dy/dx.', 'Apply the chain rule to y^2, introducing the factor dy/dx.', '[]'::jsonb),
      ('388064c4-8b67-44ff-af3a-ef27d4324ba1'::uuid, 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'part-b-criterion-01', 'Correctly collects the y'' terms: x*y'' + 2y*y'' = -2x - y.', 1, 'Response moves all non-y'' terms to the other side.', 'Isolate all terms containing y'' on one side of the equation.', '[]'::jsonb),
      ('7a187652-e3fc-4e17-af4b-0307ec6bc888'::uuid, 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'part-b-criterion-02', 'Correctly factors: y''(x+2y) = -(2x+y).', 1, 'Response factors out y'' from the left side.', 'Factor y'' out of the collected terms.', '[]'::jsonb),
      ('1b063331-7da2-436c-adde-47e6f790df90'::uuid, 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'part-b-criterion-03', 'Correct final expression dy/dx = -(2x+y)/(x+2y).', 1, 'Response divides both sides by (x+2y) to isolate y''.', 'Divide to solve explicitly for dy/dx.', '[]'::jsonb),
      ('7958b3eb-657a-48fb-a9ff-3c8d25199588'::uuid, 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'part-c-criterion-01', 'Correct substitution of x=2, y=1 into the expression for dy/dx.', 1, 'Response substitutes the point into the formula from part B.', 'Substitute x=2 and y=1 into the dy/dx expression.', '[]'::jsonb),
      ('8acf082c-5e57-4c74-abaf-f8d630063b07'::uuid, 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'part-c-criterion-02', 'Correct value dy/dx = -5/4 at (2,1).', 1, 'Response computes -(4+1)/(2+2) = -5/4.', 'Simplify the substituted expression to get -5/4.', '[]'::jsonb),
      ('825a3f48-6706-4ae0-a860-6f77a710854c'::uuid, 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'part-c-criterion-03', 'Correct tangent line equation, e.g., y - 1 = -5/4(x-2), or an equivalent simplified form.', 1, 'Response uses point-slope form with point (2,1) and slope -5/4.', 'Write the tangent line using point-slope form with the point and slope found.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-016'
      and id <> '36334953-2336-4a1d-a97c-e948ea9c2b32'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-016';
  end if;

  if not exists (
    select 1 from app.content_items where id = '36334953-2336-4a1d-a97c-e948ea9c2b32'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '36334953-2336-4a1d-a97c-e948ea9c2b32'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-016',
      'frq',
      'Using a Table of Values to Differentiate an Inverse Function',
      'draft',
      'short',
      'targeted_drill',
      'Connecting Representations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '798d58ab-6661-4293-a380-7ca6a7245909'::uuid,
      '36334953-2336-4a1d-a97c-e948ea9c2b32'::uuid,
      1,
      'Using a Table of Values to Differentiate an Inverse Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'The function f is differentiable and strictly increasing on its domain. Selected values of f and f'' are given in the table. Let g = f^-1.
Table 1: Values of f and f''
x | 1 | 2 | 3 | 4 | 5
f(x) | 3 | 5 | 8 | 12 | 17
f''(x) | 2 | 3 | 4 | 5 | 6',
      '{"content_key":"apcalcab-frq-u13-016","subject":"ap_calculus_ab","unit":3,"topic":"3.3 Differentiating Inverse Functions","archetype":"Connecting Representations","difficulty":"Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"State the formula relating the derivative of f^-1 to the derivative of f, and identify the value a such that f(a) = 8.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Compute g''(8), showing your work using the table.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Compute g''(5), and using correct notation, write the equation of the tangent line to y = g(x) at x = 5.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Using a Table of Values to Differentiate an Inverse Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('16d7e6aa-586c-47b1-a5ba-e9cb08e67011'::uuid, '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'part-a-criterion-01', 'Correct formula (f^-1)''(x) = 1/(f''(f^-1(x))).', 1, 'Response states the general inverse function derivative formula.', 'State the inverse function derivative formula explicitly.', '[]'::jsonb),
      ('d7f9dd4a-2ccc-497e-adc9-57c3304c440b'::uuid, '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'part-a-criterion-02', 'Correctly identifies a=3, since f(3)=8 from the table.', 1, 'Response reads f(3)=8 from the table.', 'Read the table to find the input value a where f(a)=8.', '[]'::jsonb),
      ('2427493a-ca47-4e90-a006-336dd3510f0f'::uuid, '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'part-a-criterion-03', 'Correct reasoning that g(8) = 3, since g = f^-1.', 1, 'Response explains g(8)=3 follows from f(3)=8.', 'Explain that g(8)=3 because g is the inverse of f and f(3)=8.', '[]'::jsonb),
      ('371ecfaa-6dfc-4ea5-a2f8-fe2a9d0afa64'::uuid, '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'part-b-criterion-01', 'Correct application g''(8) = 1/f''(3).', 1, 'Response applies the inverse derivative formula with a=3.', 'Apply the formula from part A using a=3.', '[]'::jsonb),
      ('18b5369d-5dd0-4ffa-afbd-08d6c98f81b8'::uuid, '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'part-b-criterion-02', 'Correct table lookup f''(3) = 4.', 1, 'Response reads f''(3)=4 from the table.', 'Read f''(3) from the table.', '[]'::jsonb),
      ('48443630-9aa4-4ff3-ae4d-a6394c3abeb4'::uuid, '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'part-b-criterion-03', 'Correct final value g''(8) = 1/4.', 1, 'Response computes 1 divided by 4.', 'Compute the reciprocal of f''(3) to get g''(8).', '[]'::jsonb),
      ('dc98e254-261e-4ead-a3b6-807fa86d783d'::uuid, '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'part-c-criterion-01', 'Correct value g(5) = 2, since f(2)=5.', 1, 'Response reads f(2)=5 from the table to identify g(5)=2.', 'Identify g(5)=2 using the table value f(2)=5.', '[]'::jsonb),
      ('02a04fb2-2252-43b7-a65c-bdebcd4be773'::uuid, '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'part-c-criterion-02', 'Correct value g''(5) = 1/3, using g''(5)=1/f''(2).', 1, 'Response computes 1 divided by f''(2)=3.', 'Compute g''(5) as the reciprocal of f''(2).', '[]'::jsonb),
      ('42a506e9-7632-455a-acfd-f5017c97950c'::uuid, '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'part-c-criterion-03', 'Correct tangent line equation y - 2 = (1/3)(x-5), with correct notation.', 1, 'Response writes the tangent line in point-slope form using point (5,2) and slope 1/3.', 'Write the tangent line to y=g(x) at x=5 using point-slope form.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-017'
      and id <> 'a92a30ec-a89d-4f2e-a30d-f75da069e3e6'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-017';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'a92a30ec-a89d-4f2e-a30d-f75da069e3e6'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'a92a30ec-a89d-4f2e-a30d-f75da069e3e6'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-017',
      'frq',
      'Differentiating a Sum of Inverse Trigonometric Functions',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'bb06d698-561d-40bc-a57f-f4181365b134'::uuid,
      'a92a30ec-a89d-4f2e-a30d-f75da069e3e6'::uuid,
      1,
      'Differentiating a Sum of Inverse Trigonometric Functions: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let w(x) = arctan(2x) + arcsin(x/3).',
      '{"content_key":"apcalcab-frq-u13-017","subject":"ap_calculus_ab","unit":3,"topic":"3.4 Differentiating Inverse Trigonometric Functions","archetype":"Implementing Mathematical Processes","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"State the derivative formulas for arctan(u) and arcsin(u), and identify the inner function and its derivative for each term of w(x).","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Compute w''(x), simplifying the arcsin term to eliminate the fraction within the radical.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Evaluate w''(0), and state the domain restriction on x required for w''(x) to be defined, referencing the arcsin term.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Differentiating a Sum of Inverse Trigonometric Functions: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('8c051962-2565-4d2d-ad24-911a43d25391'::uuid, 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'part-a-criterion-01', 'Correct formula d/dx[arctan(u)] = u''/(1+u^2), with u=2x and u''=2 identified.', 1, 'Response states the formula and correctly identifies u and u'' for the arctan term.', 'State the arctan derivative formula and identify u=2x, u''=2.', '[]'::jsonb),
      ('eb196b89-8f9a-4fc3-ae37-af909abf50c6'::uuid, 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'part-a-criterion-02', 'Correct formula d/dx[arcsin(u)] = u''/sqrt(1-u^2), with u=x/3 and u''=1/3 identified.', 1, 'Response states the formula and correctly identifies u and u'' for the arcsin term.', 'State the arcsin derivative formula and identify u=x/3, u''=1/3.', '[]'::jsonb),
      ('6737f98a-3fc3-440d-adbc-0dd349894e2c'::uuid, 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'part-a-criterion-03', 'Correctly notes the domain restriction -3<x<3 needed for the arcsin term to be defined for differentiation.', 1, 'Response references that x/3 must lie strictly between -1 and 1.', 'Note the domain restriction required for the arcsin(x/3) term.', '[]'::jsonb),
      ('7baa37f1-a35a-4f43-a5d4-be13e2052472'::uuid, 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'part-b-criterion-01', 'Correct arctan term: 2/(1+4x^2).', 1, 'Response applies the formula with u=2x, u''=2.', 'Apply the arctan derivative formula to get 2/(1+4x^2).', '[]'::jsonb),
      ('038eff81-d373-48cf-afdb-f1450e1ab6cb'::uuid, 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'part-b-criterion-02', 'Correct initial (unsimplified) arcsin term: (1/3)/sqrt(1-x^2/9).', 1, 'Response applies the formula with u=x/3, u''=1/3.', 'Apply the arcsin derivative formula to get (1/3)/sqrt(1-x^2/9).', '[]'::jsonb),
      ('3c7724a6-78dc-4e28-a083-fc8d625b8cf4'::uuid, 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'part-b-criterion-03', 'Correct simplification of the arcsin term to 1/sqrt(9-x^2), giving final w''(x)=2/(1+4x^2)+1/sqrt(9-x^2).', 1, 'Response rewrites sqrt(1-x^2/9) as sqrt(9-x^2)/3 to simplify the fraction.', 'Multiply numerator and denominator appropriately to clear the fraction inside the radical.', '[]'::jsonb),
      ('31041452-b73f-41b0-a5b1-4a62513c4b6b'::uuid, 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'part-c-criterion-01', 'Correct value w''(0) = 7/3.', 1, 'Response computes 2/(1+0) + 1/sqrt(9) = 2+1/3 = 7/3.', 'Substitute x=0 into w''(x) and simplify to 7/3.', '[]'::jsonb),
      ('0db852cd-26a5-4f12-ae03-854b156f30c5'::uuid, 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'part-c-criterion-02', 'Correct domain restriction identified as -3<x<3.', 1, 'Response states the derivative is defined only for -3<x<3.', 'State the domain restriction -3<x<3 for w''(x).', '[]'::jsonb),
      ('a90e139b-26fa-4edc-a85c-497a66b8831e'::uuid, 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'part-c-criterion-03', 'Correct justification referencing that arcsin(x/3) requires -3<=x<=3, and the derivative requires the strict inequality since the denominator cannot be 0.', 1, 'Response explains 9-x^2 must be strictly positive to avoid division by zero.', 'Explain that the denominator sqrt(9-x^2) must be nonzero, requiring the strict inequality -3<x<3.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-018'
      and id <> '920f980b-875d-4388-a1e0-ce80e9567643'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-018';
  end if;

  if not exists (
    select 1 from app.content_items where id = '920f980b-875d-4388-a1e0-ce80e9567643'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '920f980b-875d-4388-a1e0-ce80e9567643'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-018',
      'frq',
      'Applying the Squeeze Theorem to an Oscillating Function',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid,
      '920f980b-875d-4388-a1e0-ce80e9567643'::uuid,
      1,
      'Applying the Squeeze Theorem to an Oscillating Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Consider lim x->0 x^4 sin(5/x).',
      '{"content_key":"apcalcab-frq-u13-018","subject":"ap_calculus_ab","unit":1,"topic":"1.8 Determining Limits Using the Squeeze Theorem","archetype":"Justification","difficulty":"Very Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Explain why direct application of limit laws (such as the product rule for limits) fails for this limit, referencing the behavior of sin(5/x) as x approaches 0.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Establish valid inequalities bounding x^4 sin(5/x), suitable for the squeeze theorem, for x not equal to 0.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Evaluate the limits of the bounding functions as x approaches 0, and use the squeeze theorem to state and justify lim x->0 x^4 sin(5/x).","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Applying the Squeeze Theorem to an Oscillating Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ac0a107e-22b7-412e-a25c-260a9f0742b0'::uuid, '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid, 'part-a-criterion-01', 'Correctly states that lim x->0 sin(5/x) does not exist because it oscillates between -1 and 1 infinitely often as x approaches 0.', 1, 'Response explains the oscillatory, non-converging behavior of sin(5/x) near x=0.', 'Explain that sin(5/x) oscillates between -1 and 1 without settling on a value as x approaches 0.', '[]'::jsonb),
      ('bfd68c59-1122-406e-add3-d6b541175d4a'::uuid, '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid, 'part-a-criterion-02', 'Correctly notes that the product rule for limits cannot be applied because it requires both individual limits (of x^4 and sin(5/x)) to exist.', 1, 'Response explicitly ties the failure to the requirement that both factor limits must exist.', 'State that the product limit law requires each individual limit to exist, which fails here for the sine factor.', '[]'::jsonb),
      ('ff8d8461-acb0-46f3-ad89-f75780e10e80'::uuid, '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid, 'part-a-criterion-03', 'Correct reasoning that an alternative method (the squeeze theorem) is needed.', 1, 'Response concludes that a different technique is required since standard limit laws do not apply.', 'State that an alternative technique, such as the squeeze theorem, is needed to evaluate this limit.', '[]'::jsonb),
      ('1ad85f92-01e3-41de-a79e-44c08c1525a8'::uuid, '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid, 'part-b-criterion-01', 'Correctly uses -1 <= sin(5/x) <= 1 for all x not equal to 0.', 1, 'Response states the standard bound on the sine function.', 'State the bound -1<=sin(5/x)<=1, valid for all x!=0.', '[]'::jsonb),
      ('029f45fa-b45d-413c-a4f0-4c8ad66d7f8a'::uuid, '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid, 'part-b-criterion-02', 'Correctly multiplies through by x^4 (which is nonnegative) to get -x^4 <= x^4 sin(5/x) <= x^4.', 1, 'Response multiplies the inequality by x^4 without flipping the inequality signs, since x^4 >= 0.', 'Multiply the sine inequality by x^4, noting the inequality direction is preserved since x^4 is nonnegative.', '[]'::jsonb),
      ('ee05ed98-8d75-4901-aecf-77a06cab5388'::uuid, '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid, 'part-b-criterion-03', 'Correctly notes the inequality holds for all x not equal to 0.', 1, 'Response specifies the domain restriction x!=0 (since the original expression is undefined at x=0).', 'State that the inequality holds on the domain x!=0.', '[]'::jsonb),
      ('1ba07cf3-2e19-4166-ad90-956e472e0f5b'::uuid, '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid, 'part-c-criterion-01', 'Correct evaluation lim x->0 (-x^4) = 0 and lim x->0 x^4 = 0.', 1, 'Response computes both bounding limits as 0.', 'Evaluate the limits of both the lower bound -x^4 and upper bound x^4 as x approaches 0.', '[]'::jsonb),
      ('5fb07133-1e1f-49c8-ac08-2ad46d3d4759'::uuid, '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid, 'part-c-criterion-02', 'Correct citation of the squeeze theorem: since both bounding functions converge to the same value, the middle function must converge to that value too.', 1, 'Response explicitly invokes the squeeze theorem by name with correct reasoning.', 'State the squeeze theorem and explain why equal bounding limits force the middle function''s limit.', '[]'::jsonb),
      ('65cc7df0-5803-4528-ae1c-dbc54816c134'::uuid, '8a70db87-8486-4651-a3b1-6cdf4731f5e7'::uuid, 'part-c-criterion-03', 'Correct conclusion lim x->0 x^4 sin(5/x) = 0.', 1, 'Response states the final limit value.', 'State the final numeric value of the original limit.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-019'
      and id <> '7f0f9e98-8561-4845-a557-014da9f3dcb5'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-019';
  end if;

  if not exists (
    select 1 from app.content_items where id = '7f0f9e98-8561-4845-a557-014da9f3dcb5'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '7f0f9e98-8561-4845-a557-014da9f3dcb5'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-019',
      'frq',
      'Second Derivative of an Implicitly Defined Circle',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid,
      '7f0f9e98-8561-4845-a557-014da9f3dcb5'::uuid,
      1,
      'Second Derivative of an Implicitly Defined Circle: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Consider the curve x^2 + y^2 = 25. The point (3,4) lies on this curve, since 3^2 + 4^2 = 9+16 = 25.',
      '{"content_key":"apcalcab-frq-u13-019","subject":"ap_calculus_ab","unit":3,"topic":"3.6 Calculating Higher-Order Derivatives","archetype":"Implementing Mathematical Processes","difficulty":"Very Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Find dy/dx by implicit differentiation, and evaluate it at the point (3,4).","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Differentiate y'' = -x/y with respect to x using the quotient rule, to find an expression for y'''' in terms of x, y, and y''.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Substitute y'' = -x/y and the point (3,4) to evaluate y'''' at (3,4), showing all substitutions.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Second Derivative of an Implicitly Defined Circle: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('965fd6ce-0080-4ced-a816-b039b026ee24'::uuid, '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'part-a-criterion-01', 'Correct implicit differentiation: 2x + 2y*y'' = 0.', 1, 'Response differentiates both sides of x^2+y^2=25 with respect to x.', 'Differentiate both sides of the equation with respect to x, applying the chain rule to y^2.', '[]'::jsonb),
      ('c76e6954-0d72-4e64-a360-623289aed544'::uuid, '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'part-a-criterion-02', 'Correct solution y'' = -x/y.', 1, 'Response solves the differentiated equation for y''.', 'Solve the equation from the previous step for y''.', '[]'::jsonb),
      ('0f33ca48-df72-43f7-ab10-670a669232c3'::uuid, '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'part-a-criterion-03', 'Correct evaluation y''(3,4) = -3/4, with the point verified to lie on the curve.', 1, 'Response substitutes x=3, y=4 into y''=-x/y and reports -3/4.', 'Substitute the point (3,4) into the expression for dy/dx and report -3/4.', '[]'::jsonb),
      ('8d9f00ac-9a6e-494e-a180-dd5c8c32f998'::uuid, '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'part-b-criterion-01', 'Correct quotient rule setup: y'''' = [(-1)(y) - (-x)(y'')]/y^2.', 1, 'Response applies the quotient rule to -x/y with numerator -x and denominator y.', 'Apply the quotient rule to differentiate -x/y, treating y as a function of x.', '[]'::jsonb),
      ('fb6fd8a3-a6d3-4da4-ae68-a3d400df39fc'::uuid, '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'part-b-criterion-02', 'Correct simplification of the numerator: -y + x*y''.', 1, 'Response simplifies the numerator of the quotient rule result.', 'Simplify the numerator obtained from the quotient rule.', '[]'::jsonb),
      ('e2d26622-d9f5-4195-a0f7-2dbe308397a5'::uuid, '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'part-b-criterion-03', 'Correct final expression y'''' = (x*y'' - y)/y^2.', 1, 'Response states the fully simplified expression for y'''' in terms of x, y, y''.', 'State the final expression for y'''' in terms of x, y, and y''.', '[]'::jsonb),
      ('9f4b8538-e820-454e-aaba-86173c286691'::uuid, '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'part-c-criterion-01', 'Correct substitution of y'' = -x/y into the expression for y'''' from part B.', 1, 'Response substitutes -x/y in place of y'' in (xy''-y)/y^2.', 'Substitute the expression for y'' found in part A into the y'''' formula from part B.', '[]'::jsonb),
      ('25961c5c-0055-45b8-aa83-330dc01946d5'::uuid, '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'part-c-criterion-02', 'Correct simplification using x^2+y^2=25 to obtain y'''' = -25/y^3 (or direct numeric substitution of x=3, y=4, y''=-3/4 into the part B formula).', 1, 'Response simplifies the substituted expression to -(x^2+y^2)/y^3 = -25/y^3, or computes numerically with the same result.', 'Simplify algebraically using x^2+y^2=25, or substitute the numeric values directly into the part B formula.', '[]'::jsonb),
      ('158172a9-4d48-407a-a20d-4fa6e92d35df'::uuid, '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'part-c-criterion-03', 'Correct final value y'''' = -25/64 at (3,4).', 1, 'Response reports the final numeric value.', 'Report the final simplified numeric value of y'''' at (3,4).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcab-frq-u13-020'
      and id <> '819fb4de-d0b5-4849-ad14-3215f537e6db'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcab-frq-u13-020';
  end if;

  if not exists (
    select 1 from app.content_items where id = '819fb4de-d0b5-4849-ad14-3215f537e6db'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '819fb4de-d0b5-4849-ad14-3215f537e6db'::uuid,
      v_epv_id,
      'apcalcab-frq-u13-020',
      'frq',
      'Continuity Without Differentiability at a Piecewise Boundary',
      'draft',
      'short',
      'targeted_drill',
      'Justification and Implementing'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid,
      '819fb4de-d0b5-4849-ad14-3215f537e6db'::uuid,
      1,
      'Continuity Without Differentiability at a Piecewise Boundary: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f be the piecewise function defined by
f(x) = e^(2x), for x <= 0
f(x) = 1 + 3x, for x > 0',
      '{"content_key":"apcalcab-frq-u13-020","subject":"ap_calculus_ab","unit":2,"topic":"2.4 Connecting Differentiability and Continuity","archetype":"Justification and Implementing","difficulty":"Very Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Show that f is continuous at x=0 using the definition of continuity.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Determine whether f is differentiable at x=0 by computing the left-hand and right-hand derivatives, and justify your conclusion.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"State whether differentiability at a point implies continuity at that point, and justify briefly, referencing this function or the general theorem.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Continuity Without Differentiability at a Piecewise Boundary: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('3a280001-6afa-4dde-a864-e95dbce7b118'::uuid, 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'part-a-criterion-01', 'Correct left-hand limit lim x->0- e^(2x) = 1.', 1, 'Response substitutes x=0 into e^(2x) and gets 1.', 'Substitute x=0 into the x<=0 piece and report 1.', '[]'::jsonb),
      ('10b80bc8-e9a5-41ea-a43b-1a39ae4bd589'::uuid, 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'part-a-criterion-02', 'Correct right-hand limit lim x->0+ (1+3x) = 1, consistent with f(0)=1.', 1, 'Response substitutes x=0 into 1+3x and gets 1, matching f(0) from the left piece.', 'Substitute x=0 into the x>0 piece and confirm it matches f(0).', '[]'::jsonb),
      ('39ebf6db-8181-4e3d-a745-9a6d46523f61'::uuid, 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'part-a-criterion-03', 'Correct conclusion that f is continuous at x=0 since the limit exists and equals f(0).', 1, 'Response states continuity holds because both one-sided limits and f(0) all equal 1.', 'State the conclusion that f is continuous at x=0, referencing all matching values of 1.', '[]'::jsonb),
      ('f1564882-8ced-43f9-a9ca-e1c85daeb9e3'::uuid, 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'part-b-criterion-01', 'Correct left-hand derivative computed via the chain rule: f''_-(0) = 2e^(0) = 2.', 1, 'Response differentiates e^(2x) to 2e^(2x) and evaluates at x=0 to get 2.', 'Apply the chain rule to differentiate e^(2x) and evaluate the result at x=0.', '[]'::jsonb),
      ('58cd301d-22dc-4d2b-a278-f492eb1af701'::uuid, 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'part-b-criterion-02', 'Correct right-hand derivative f''_+(0) = 3.', 1, 'Response differentiates 1+3x to get 3.', 'Differentiate 1+3x and evaluate at x=0 to get 3.', '[]'::jsonb),
      ('f8e5a36b-7e11-4d9a-a872-e544c04680d4'::uuid, 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'part-b-criterion-03', 'Correct comparison noting the two one-sided derivatives are unequal (2 does not equal 3).', 1, 'Response explicitly compares 2 and 3 and notes they differ.', 'Compare the left-hand and right-hand derivative values.', '[]'::jsonb),
      ('6f07af16-5ddf-4dc0-a8ca-ee9e043c5b39'::uuid, 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'part-b-criterion-04', 'Correct conclusion that f is not differentiable at x=0, justified by the definition requiring equal one-sided derivatives, and noting continuity does not imply differentiability.', 1, 'Response concludes non-differentiability and explicitly notes continuity alone does not guarantee differentiability.', 'State that f is not differentiable at x=0 because the one-sided derivatives disagree, despite f being continuous there.', '[]'::jsonb),
      ('5638ea45-4d58-45bc-ad3c-06c7f78dc81e'::uuid, 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'part-c-criterion-01', 'Correct statement that yes, differentiability at a point always implies continuity at that point.', 1, 'Response affirms the theorem in the correct direction.', 'State that differentiability implies continuity, but not the converse.', '[]'::jsonb),
      ('46896920-1a12-4fe4-a7a2-f9896da6a98a'::uuid, 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'part-c-criterion-02', 'Correct brief justification referencing the general theorem and/or this function as an illustration that the converse is false.', 1, 'Response notes this function is continuous but not differentiable at x=0, illustrating that continuity does not imply differentiability, consistent with the one-directional theorem.', 'Justify by citing the standard theorem and noting this function demonstrates the converse fails.', '[]'::jsonb);
  end if;
end
$calc_ab_bc_units1_3$;
commit;
