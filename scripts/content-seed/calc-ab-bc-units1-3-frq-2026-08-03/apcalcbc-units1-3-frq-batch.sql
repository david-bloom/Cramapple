begin;
do $calc_ab_bc_units1_3$
declare
  v_epv_id uuid;
  v_epv_count integer;
begin
  select count(*) into v_epv_count
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_calculus_bc'
    and epv.status = 'published';

  if v_epv_count <> 1 then
    raise exception 'expected_exactly_one_published_exam_pack_version:%:%', 'ap_calculus_bc', v_epv_count;
  end if;

  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_calculus_bc'
    and epv.status = 'published';

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-001'
      and id <> '5d3642b9-763f-4f34-a8eb-2c63b16b6da7'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-001';
  end if;

  if not exists (
    select 1 from app.content_items where id = '5d3642b9-763f-4f34-a8eb-2c63b16b6da7'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '5d3642b9-763f-4f34-a8eb-2c63b16b6da7'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-001',
      'frq',
      'Table Estimation, Continuity Check, and Removable Discontinuity',
      'draft',
      'short',
      'targeted_drill',
      'Connecting Representations and Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid,
      '5d3642b9-763f-4f34-a8eb-2c63b16b6da7'::uuid,
      1,
      'Table Estimation, Continuity Check, and Removable Discontinuity: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'A function r is defined for all real numbers except x = 5. Selected values of r(x) are shown in Table 1.

Table 1: Values of r(x) near x = 5
x | 4.8 | 4.9 | 4.99 | 5 | 5.01 | 5.1 | 5.2
r(x) | 7.84 | 7.92 | 7.992 | undefined | 8.008 | 8.08 | 8.16

It is also given that r(5) = 7.5.',
      '{"content_key":"apcalcbc-frq-u13-001","subject":"ap_calculus_bc","unit":1,"topic":"1.4 Estimating Limit Values from Tables","archetype":"Connecting Representations and Justification","difficulty":"Easy","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use Table 1 to estimate lim_{x→5} r(x). Write your answer using correct limit notation and justify your estimate by referencing the trend in the table values.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Given that r(5) = 7.5, determine whether r is continuous at x = 5. Justify your answer using the definition of continuity at a point.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Explain whether r has a removable discontinuity at x = 5. If it does, define a new function g that agrees with r for x ≠ 5 and removes the discontinuity at x = 5.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Table Estimation, Continuity Check, and Removable Discontinuity: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('d6f1947d-cd82-47c9-a43a-a58d37c31807'::uuid, 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'part-a-criterion-01', 'Uses correct limit notation for the statement.', 1, 'Response writes ''lim_{x→5} r(x) = 8'' (or equivalent notation) rather than just a bare number.', 'If missing, require the student to rewrite the answer using lim_{x→a} f(x) = L notation.', '[]'::jsonb),
      ('c905f330-c7cb-448d-ab5f-e9bea94f53d1'::uuid, 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'part-a-criterion-02', 'States the correct numerical value of the limit.', 1, 'Response identifies the value 8 as the estimated limit.', 'If wrong, recheck the table trend on both sides of x = 5.', '[]'::jsonb),
      ('11ebc1d3-311b-4cb9-aade-ff36b43a7ff6'::uuid, 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'part-a-criterion-03', 'Justifies the estimate using both sides of the table.', 1, 'Response notes values approach 8 from the left (7.84, 7.92, 7.992) and from the right (8.008, 8.08, 8.16).', 'If missing, require explicit reference to both the left-hand and right-hand trends in the table.', '[]'::jsonb),
      ('71a05d38-1586-4606-a791-b298d7765e60'::uuid, 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'part-b-criterion-01', 'Identifies that r(5) exists.', 1, 'Response states r(5) = 7.5 is defined.', 'If missing, require the student to state the value of r(5) explicitly.', '[]'::jsonb),
      ('a5745e12-5b4a-4958-afc2-4d48a975352b'::uuid, 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'part-b-criterion-02', 'Uses the limit value found in part A.', 1, 'Response states lim_{x→5} r(x) = 8 from part A.', 'If missing, require the student to restate the limit value before comparing.', '[]'::jsonb),
      ('07692bb0-8fcf-4940-a0a2-4bb9abe2aa65'::uuid, 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'part-b-criterion-03', 'Correctly concludes r is not continuous at x = 5 with justification.', 1, 'Response notes 8 ≠ 7.5 so lim_{x→5} r(x) ≠ r(5), violating the definition of continuity.', 'If missing, require an explicit comparison of the limit value to r(5) referencing the continuity definition.', '[]'::jsonb),
      ('c7994abc-1106-4dc7-a2ca-7e73dacf5ebe'::uuid, 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'part-c-criterion-01', 'Identifies the discontinuity as removable.', 1, 'Response states the discontinuity is removable because lim_{x→5} r(x) exists and is finite (equal to 8) even though it doesn''t match r(5).', 'If missing, require justification tied to the existence of a finite limit at the point.', '[]'::jsonb),
      ('2def55fe-2d23-4305-a921-cd6f78c805a7'::uuid, 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'part-c-criterion-02', 'States the correct new value needed to remove the discontinuity.', 1, 'Response gives g(5) = 8.', 'If wrong, recheck the value found in part A.', '[]'::jsonb),
      ('e481ede2-3843-4092-aa08-88ca38919319'::uuid, 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'part-c-criterion-03', 'Correctly defines g as a piecewise function.', 1, 'Response defines g(x) = r(x) for x ≠ 5 and g(5) = 8.', 'If missing, require an explicit piecewise definition of g covering both cases.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-002'
      and id <> '92c9542a-3422-4f04-a40b-6173583bebc2'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-002';
  end if;

  if not exists (
    select 1 from app.content_items where id = '92c9542a-3422-4f04-a40b-6173583bebc2'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '92c9542a-3422-4f04-a40b-6173583bebc2'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-002',
      'frq',
      'Hole in a Rational Function and Continuity Parameter',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid,
      '92c9542a-3422-4f04-a40b-6173583bebc2'::uuid,
      1,
      'Hole in a Rational Function and Continuity Parameter: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f(x) = (x^2 − 9)/(x − 3) for x ≠ 3, and let f(3) = k, where k is a constant.',
      '{"content_key":"apcalcbc-frq-u13-002","subject":"ap_calculus_bc","unit":1,"topic":"1.11 Defining Continuity at a Point","archetype":"Justification","difficulty":"Easy","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Find lim_{x→3} f(x) using algebraic manipulation. Show the factoring step used.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Determine the value of k that makes f continuous at x = 3. Justify your answer using the definition of continuity.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Suppose instead k = 4. Classify the type of discontinuity that would exist at x = 3, explaining your reasoning using the definition of continuity.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Hole in a Rational Function and Continuity Parameter: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('5db749ba-8040-4fd1-ac41-72ee2845a566'::uuid, 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'part-a-criterion-01', 'Correctly factors the numerator.', 1, 'Response writes x^2 − 9 = (x − 3)(x + 3).', 'If missing, require the student to factor the difference of squares before cancelling.', '[]'::jsonb),
      ('367d93af-3bd4-48c3-a400-581b805b1d69'::uuid, 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'part-a-criterion-02', 'Correctly cancels the common factor.', 1, 'Response simplifies (x−3)(x+3)/(x−3) to x + 3 for x ≠ 3.', 'If missing, require explicit cancellation shown as a step, not skipped.', '[]'::jsonb),
      ('62fc85b1-051b-4b64-abf6-c654e473d2e2'::uuid, 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'part-a-criterion-03', 'Correctly evaluates the limit.', 1, 'Response states lim_{x→3} f(x) = 6.', 'If wrong, recheck substitution of x = 3 into the simplified expression x + 3.', '[]'::jsonb),
      ('7907d8cc-33d0-43ce-a032-e623964d4b57'::uuid, 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'part-b-criterion-01', 'States the condition required for continuity.', 1, 'Response notes f(3) must equal lim_{x→3} f(x).', 'If missing, require the student to state this condition before solving for k.', '[]'::jsonb),
      ('3d92f8c3-2d52-4fd9-a428-5bee34425e68'::uuid, 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'part-b-criterion-02', 'Correctly solves for k.', 1, 'Response gives k = 6.', 'If wrong, recheck that k must equal the limit value found in part A.', '[]'::jsonb),
      ('d32a1fc6-4df2-43b8-a5ec-3b012c5def55'::uuid, 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'part-b-criterion-03', 'Justifies that all three continuity conditions hold when k = 6.', 1, 'Response confirms f(3) exists (=6), the limit exists (=6), and they are equal.', 'If missing, require explicit reference to all three parts of the continuity definition.', '[]'::jsonb),
      ('932a313b-8291-437d-a0f2-e9c23c34a504'::uuid, 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'part-c-criterion-01', 'Correctly identifies f(3) = 4 and lim_{x→3} f(x) = 6 as unequal.', 1, 'Response states f(3) = 4 ≠ 6 = lim_{x→3} f(x).', 'If missing, require explicit statement of both values before comparing.', '[]'::jsonb),
      ('3bb79ee8-0704-450a-acee-a69edb49b058'::uuid, 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'part-c-criterion-02', 'Correctly classifies the discontinuity as removable.', 1, 'Response identifies this as a removable discontinuity.', 'If wrong, require the student to re-examine why a finite existing limit unequal to the function value is removable, not a jump or infinite discontinuity.', '[]'::jsonb),
      ('1307e65c-ba98-4f79-a844-791bc980b928'::uuid, 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'part-c-criterion-03', 'Justifies the classification using the definition.', 1, 'Response explains that since the limit exists and is finite but does not equal the function value, the discontinuity can be ''removed'' by redefining f(3).', 'If missing, require the justification to explicitly reference the general definitions distinguishing removable, jump, and infinite discontinuities.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-003'
      and id <> 'ff3a5d9a-cab1-4f48-a961-dc61896d10ee'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-003';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'ff3a5d9a-cab1-4f48-a961-dc61896d10ee'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'ff3a5d9a-cab1-4f48-a961-dc61896d10ee'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-003',
      'frq',
      'Polynomial Derivative and Tangent Line Interpretation',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes and Communication'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid,
      'ff3a5d9a-cab1-4f48-a961-dc61896d10ee'::uuid,
      1,
      'Polynomial Derivative and Tangent Line Interpretation: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f(x) = 3x^4 − 8x^3 + 2x − 5.',
      '{"content_key":"apcalcbc-frq-u13-003","subject":"ap_calculus_bc","unit":2,"topic":"2.5 Applying the Power Rule","archetype":"Implementing Mathematical Processes and Communication","difficulty":"Easy","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Find f''(x), showing the derivative rule applied to each term.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Evaluate f(1) and f''(1), and write an equation for the line tangent to the graph of f at x = 1.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Using correct derivative notation, state the value of f''(1) and explain what this value represents about the graph of f at x = 1.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Polynomial Derivative and Tangent Line Interpretation: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('2bec84c9-090e-41e8-a012-be25d6f135c6'::uuid, '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'part-a-criterion-01', 'Correctly differentiates the 3x^4 term.', 1, 'Response gives d/dx[3x^4] = 12x^3.', 'If missing, require application of the power rule to this term explicitly.', '[]'::jsonb),
      ('19158cac-8646-4211-ad09-835958f29fc1'::uuid, '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'part-a-criterion-02', 'Correctly differentiates the −8x^3 + 2x terms.', 1, 'Response gives d/dx[−8x^3 + 2x] = −24x^2 + 2.', 'If wrong, recheck each term''s power rule application.', '[]'::jsonb),
      ('ee928d1f-b6a5-42cc-aca6-75c2d18a1616'::uuid, '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'part-a-criterion-03', 'Correctly handles the constant term and states the final derivative.', 1, 'Response notes d/dx[−5] = 0 and gives f''(x) = 12x^3 − 24x^2 + 2.', 'If missing, require the constant''s derivative to be addressed and the full expression stated.', '[]'::jsonb),
      ('a9d68e1d-1476-4e1c-a550-c61a63ca33af'::uuid, '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'part-b-criterion-01', 'Correctly computes f(1).', 1, 'Response gives f(1) = 3 − 8 + 2 − 5 = −8.', 'If wrong, recheck arithmetic substitution into f(x).', '[]'::jsonb),
      ('c5db1c74-f1aa-445d-a930-d1da911aadcc'::uuid, '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'part-b-criterion-02', 'Correctly computes f''(1).', 1, 'Response gives f''(1) = 12 − 24 + 2 = −10.', 'If wrong, recheck arithmetic substitution into f''(x).', '[]'::jsonb),
      ('3fe372fa-b192-453b-a00b-1c0d8d499346'::uuid, '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'part-b-criterion-03', 'Writes a correct tangent line equation.', 1, 'Response gives y + 8 = −10(x − 1) or equivalent y = −10x + 2.', 'If missing, require point-slope form using f(1) and f''(1).', '[]'::jsonb),
      ('418a81a3-e6b0-4b8e-acdd-6fce4b6a8f2f'::uuid, '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'part-c-criterion-01', 'Uses correct derivative notation.', 1, 'Response writes f''(1) = −10 (or dy/dx at x=1) rather than an unlabeled number.', 'If missing, require the student to use proper derivative notation.', '[]'::jsonb),
      ('12747baf-fbd4-4b56-a24e-6ce50247e1b3'::uuid, '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'part-c-criterion-02', 'Interprets the value as an instantaneous rate of change.', 1, 'Response explains f''(1) represents the instantaneous rate of change of f at x = 1.', 'If missing, require this interpretation to be stated explicitly.', '[]'::jsonb),
      ('69d92d00-e94e-48b7-aa91-46e80720c111'::uuid, '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'part-c-criterion-03', 'Interprets the value geometrically.', 1, 'Response explains f''(1) is the slope of the line tangent to the graph of f at x = 1.', 'If missing, require the geometric meaning to be stated in addition to the rate-of-change meaning.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-004'
      and id <> '4c982399-82e1-4414-a703-e9e13f6528c8'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-004';
  end if;

  if not exists (
    select 1 from app.content_items where id = '4c982399-82e1-4414-a703-e9e13f6528c8'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '4c982399-82e1-4414-a703-e9e13f6528c8'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-004',
      'frq',
      'Three Techniques for Algebraic Limit Evaluation',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes and Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid,
      '4c982399-82e1-4414-a703-e9e13f6528c8'::uuid,
      1,
      'Three Techniques for Algebraic Limit Evaluation: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Evaluate each of the following limits using an appropriate algebraic technique, showing all work.',
      '{"content_key":"apcalcbc-frq-u13-004","subject":"ap_calculus_bc","unit":1,"topic":"1.6 Determining Limits Using Algebraic Manipulation","archetype":"Implementing Mathematical Processes and Justification","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Evaluate lim_{x→4} (√x − 2)/(x − 4) using rationalization.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Evaluate lim_{x→−2} (x^3 + 8)/(x^2 − 4) using factoring.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Determine lim_{x→2} |x − 2|/(x − 2), and justify whether the limit exists using one-sided limits.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Three Techniques for Algebraic Limit Evaluation: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ef7fae86-49c9-4f68-a505-adccf4cb1044'::uuid, 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'part-a-criterion-01', 'Multiplies by the correct conjugate.', 1, 'Response multiplies numerator and denominator by (√x + 2).', 'If missing, require the conjugate multiplication step to be shown.', '[]'::jsonb),
      ('57038cff-5f77-4ee6-a2a2-ac5f7a7edc5b'::uuid, 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'part-a-criterion-02', 'Correctly simplifies the resulting expression.', 1, 'Response simplifies to 1/(√x + 2) after cancelling (x − 4).', 'If wrong, recheck the difference-of-squares simplification in the numerator.', '[]'::jsonb),
      ('f90e71a3-2598-4fe1-af99-fd918b56e4c9'::uuid, 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'part-a-criterion-03', 'Correctly evaluates the limit.', 1, 'Response gives lim = 1/4.', 'If wrong, recheck substitution of x = 4 into 1/(√x + 2).', '[]'::jsonb),
      ('7beff33b-ff99-47bb-aa37-7dd0c9a55973'::uuid, 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'part-b-criterion-01', 'Correctly factors the numerator as a sum of cubes.', 1, 'Response writes x^3 + 8 = (x + 2)(x^2 − 2x + 4).', 'If missing, require the sum-of-cubes factoring formula to be applied.', '[]'::jsonb),
      ('5aca8d98-a8dd-47ec-a91c-e25f1e9bca71'::uuid, 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'part-b-criterion-02', 'Correctly factors the denominator and cancels the common factor.', 1, 'Response writes x^2 − 4 = (x + 2)(x − 2) and cancels (x + 2).', 'If missing, require the cancellation step to be shown explicitly.', '[]'::jsonb),
      ('56a0ad87-ad17-4be6-a32d-939cd4b51e73'::uuid, 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'part-b-criterion-03', 'Correctly evaluates the limit.', 1, 'Response gives lim = −3, from (4 + 4 + 4)/(−4).', 'If wrong, recheck substitution of x = −2 into (x^2 − 2x + 4)/(x − 2).', '[]'::jsonb),
      ('35ab98e0-6299-470e-afe7-ae057fc69f8e'::uuid, 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'part-c-criterion-01', 'Correctly finds the left-hand limit.', 1, 'Response computes lim_{x→2^−} |x−2|/(x−2) = −1.', 'If wrong, recheck that |x−2| = −(x−2) for x < 2.', '[]'::jsonb),
      ('e85e54cb-e929-409e-a33d-380406b241b1'::uuid, 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'part-c-criterion-02', 'Correctly finds the right-hand limit.', 1, 'Response computes lim_{x→2^+} |x−2|/(x−2) = 1.', 'If wrong, recheck that |x−2| = (x−2) for x > 2.', '[]'::jsonb),
      ('7ed01dc5-323b-4703-a19f-debaa8ae304b'::uuid, 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'part-c-criterion-03', 'Correctly concludes the limit does not exist with justification.', 1, 'Response states the two-sided limit DNE because the one-sided limits (−1 and 1) are not equal.', 'If missing, require explicit comparison of the one-sided limits as justification.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-005'
      and id <> '093a4b97-ea70-4b54-aa21-f64c7d85538c'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-005';
  end if;

  if not exists (
    select 1 from app.content_items where id = '093a4b97-ea70-4b54-aa21-f64c7d85538c'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '093a4b97-ea70-4b54-aa21-f64c7d85538c'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-005',
      'frq',
      'Squeeze Theorem with an Oscillating Trigonometric Factor',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid,
      '093a4b97-ea70-4b54-aa21-f64c7d85538c'::uuid,
      1,
      'Squeeze Theorem with an Oscillating Trigonometric Factor: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f(x) = x^2 sin(5/x) for x ≠ 0, and f(0) = 0.',
      '{"content_key":"apcalcbc-frq-u13-005","subject":"ap_calculus_bc","unit":1,"topic":"1.8 Determining Limits Using the Squeeze Theorem","archetype":"Justification","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use the Squeeze Theorem to prove that lim_{x→0} x^2 sin(5/x) = 0.","points":4,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1}]},{"part_key":"part-b","prompt":"Given that f(0) = 0, determine whether f is continuous at x = 0. Justify your answer using the definition of continuity.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Explain why direct substitution cannot be used to evaluate lim_{x→0} x^2 sin(5/x).","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Squeeze Theorem with an Oscillating Trigonometric Factor: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('9058d140-bfa9-47a9-a72f-77a6186aaaab'::uuid, '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'part-a-criterion-01', 'States the correct bounding inequality.', 1, 'Response uses −1 ≤ sin(5/x) ≤ 1 to derive −x^2 ≤ x^2 sin(5/x) ≤ x^2.', 'If missing, require the bounding inequality to be derived from the range of sine before proceeding.', '[]'::jsonb),
      ('01615fc2-6027-466a-a828-cf06a7084026'::uuid, '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'part-a-criterion-02', 'Correctly evaluates the lower bound''s limit.', 1, 'Response computes lim_{x→0} (−x^2) = 0.', 'If missing, require this limit to be evaluated explicitly.', '[]'::jsonb),
      ('9c7a9c3c-5498-4e4e-a7d7-1ccc5eead61f'::uuid, '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'part-a-criterion-03', 'Correctly evaluates the upper bound''s limit.', 1, 'Response computes lim_{x→0} x^2 = 0.', 'If missing, require this limit to be evaluated explicitly.', '[]'::jsonb),
      ('044e6853-5a29-44a2-af90-48ad05abf8e7'::uuid, '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'part-a-criterion-04', 'Correctly cites the Squeeze Theorem to conclude.', 1, 'Response states that since both bounding limits equal 0, by the Squeeze Theorem lim_{x→0} x^2 sin(5/x) = 0.', 'If missing, require explicit reference to the Squeeze Theorem as the justification, not just the numeric answer.', '[]'::jsonb),
      ('c8e30fe9-55b4-4646-ae74-47e4e507d5fb'::uuid, '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'part-b-criterion-01', 'States that f(0) exists.', 1, 'Response notes f(0) = 0 is defined.', 'If missing, require this to be stated explicitly.', '[]'::jsonb),
      ('939a1d66-d9d4-4f97-a5ea-2ea8ba16b3e0'::uuid, '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'part-b-criterion-02', 'Uses the limit result from part A.', 1, 'Response states lim_{x→0} f(x) = 0, matching part A.', 'If missing, require restating the limit value before comparing to f(0).', '[]'::jsonb),
      ('84f77e58-bf87-4d5d-a4da-e559127f4689'::uuid, '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'part-b-criterion-03', 'Correctly concludes continuity with justification.', 1, 'Response concludes f is continuous at x = 0 since lim_{x→0} f(x) = f(0) = 0, satisfying the definition.', 'If missing, require explicit reference to the continuity definition in the conclusion.', '[]'::jsonb),
      ('db9bd450-2346-4c55-a7c6-f5786785f440'::uuid, '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'part-c-criterion-01', 'Identifies the issue with direct substitution.', 1, 'Response notes that sin(5/x) is undefined at x = 0 and oscillates infinitely often as x → 0, so it has no limit on its own.', 'If missing, require explanation of why sin(5/x) itself fails to have a limit at x = 0.', '[]'::jsonb),
      ('d69f0a6c-0386-4157-a750-8542ecda7e4b'::uuid, '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'part-c-criterion-02', 'Connects this to the need for the Squeeze Theorem.', 1, 'Response explains that since sin(5/x) is bounded (even though it has no limit), multiplying by x^2 → 0 allows the Squeeze Theorem to force the product''s limit to 0.', 'If missing, require the connection between boundedness of sin(5/x) and the applicability of the Squeeze Theorem to be stated.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-006'
      and id <> 'b5718e11-0cae-4f5b-a1dc-d2b47dfcf6a2'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-006';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'b5718e11-0cae-4f5b-a1dc-d2b47dfcf6a2'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'b5718e11-0cae-4f5b-a1dc-d2b47dfcf6a2'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-006',
      'frq',
      'Applying IVT from a Table of Values',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid,
      'b5718e11-0cae-4f5b-a1dc-d2b47dfcf6a2'::uuid,
      1,
      'Applying IVT from a Table of Values: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'The function h is continuous on the closed interval [0, 4]. Selected values of h are given in Table 1.

Table 1: Values of h(x)
x | 0 | 1 | 2 | 3 | 4
h(x) | −3 | 1 | 2 | −1 | 5',
      '{"content_key":"apcalcbc-frq-u13-006","subject":"ap_calculus_bc","unit":1,"topic":"1.16 Working with the Intermediate Value Theorem","archetype":"Justification","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use the Intermediate Value Theorem to justify that there exists a value c in the interval (0, 1) such that h(c) = 0.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Determine the minimum number of values of x in [0, 4] at which h(x) = 1.5. Justify your answer using the Intermediate Value Theorem applied to appropriate subintervals.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"A student claims, ''Since h(1) = 1 and h(3) = −1, the Intermediate Value Theorem guarantees exactly one solution to h(x) = 0 in (1, 3).'' Explain what is incorrect about this statement.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Applying IVT from a Table of Values: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('7e7bfb63-b248-4f2c-a39c-b7577c154d27'::uuid, '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'part-a-criterion-01', 'States the hypothesis that h is continuous on [0,1].', 1, 'Response notes h is continuous on [0,1] (given, since h is continuous on all of [0,4]).', 'If missing, require the continuity hypothesis to be stated as part of applying IVT.', '[]'::jsonb),
      ('70d19398-8bdb-4a24-a863-6c7649229121'::uuid, '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'part-a-criterion-02', 'Identifies that 0 lies between h(0) and h(1).', 1, 'Response notes h(0) = −3 < 0 < 1 = h(1).', 'If missing, require explicit comparison of h(0), 0, and h(1).', '[]'::jsonb),
      ('3950ab10-d6d7-4209-a625-a9f750613811'::uuid, '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'part-a-criterion-03', 'Correctly concludes using IVT.', 1, 'Response concludes by the Intermediate Value Theorem there exists c in (0,1) with h(c) = 0.', 'If missing, require the conclusion to explicitly cite the Intermediate Value Theorem.', '[]'::jsonb),
      ('eb28004d-d3a0-41c1-ad5f-80749bfa1f35'::uuid, '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'part-b-criterion-01', 'Identifies the subintervals where 1.5 lies between consecutive table values.', 1, 'Response identifies [1,2] (1 to 2), [2,3] (2 to −1), and [3,4] (−1 to 5) as intervals where 1.5 is between the endpoint values.', 'If missing, require the student to check each consecutive pair of table values against 1.5.', '[]'::jsonb),
      ('c28554d6-fa97-489a-a458-23637ba860ff'::uuid, '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'part-b-criterion-02', 'Applies IVT to each identified subinterval.', 1, 'Response applies IVT on [1,2], [2,3], and [3,4] to guarantee a solution in each.', 'If missing, require IVT to be invoked explicitly for each subinterval, not just asserted.', '[]'::jsonb),
      ('70e55d1e-3290-4958-ab7f-e67d001c939d'::uuid, '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'part-b-criterion-03', 'Correctly concludes the minimum number of solutions.', 1, 'Response concludes there are at least 3 values of x in [0,4] with h(x) = 1.5.', 'If wrong, recheck that all three subintervals were correctly identified.', '[]'::jsonb),
      ('6b3cd313-eef5-4552-ae54-138bc04cca19'::uuid, '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'part-c-criterion-01', 'Confirms IVT guarantees at least one solution exists.', 1, 'Response acknowledges that since h(1) = 1 > 0 > −1 = h(3) and h is continuous on [1,3], IVT does guarantee at least one c in (1,3) with h(c) = 0.', 'If missing, require acknowledgment of what IVT does correctly establish.', '[]'::jsonb),
      ('f1a21ea0-0cd3-4468-abc5-68aa9bb7f08c'::uuid, '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'part-c-criterion-02', 'Identifies that IVT does not guarantee uniqueness.', 1, 'Response explains IVT only guarantees existence of at least one solution, not that it is the only one.', 'If missing, require explicit statement that IVT says nothing about the number of solutions beyond ''at least one''.', '[]'::jsonb),
      ('5acc3a62-1da9-435a-aee6-fba71527b570'::uuid, '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'part-c-criterion-03', 'Correctly concludes the statement is incorrect for overstating IVT''s conclusion.', 1, 'Response concludes the student''s claim of ''exactly one'' is incorrect because h could cross zero more than once in (1,3) without contradicting the given data.', 'If missing, require the final conclusion to tie the error to the overstated claim of uniqueness.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-007'
      and id <> '338bd08c-061a-4164-addd-644253129f23'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-007';
  end if;

  if not exists (
    select 1 from app.content_items where id = '338bd08c-061a-4164-addd-644253129f23'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '338bd08c-061a-4164-addd-644253129f23'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-007',
      'frq',
      'Analyzing a Graph Described in Words',
      'draft',
      'short',
      'targeted_drill',
      'Connecting Representations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid,
      '338bd08c-061a-4164-addd-644253129f23'::uuid,
      1,
      'Analyzing a Graph Described in Words: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'The graph of a function p is described as follows. For −4 ≤ x < −1, p is a line segment from the point (−4, 1) to the point (−1, 3), with an open circle at (−1, 3) (not included). At x = −1, there is a filled point at (−1, 0), so p(−1) = 0. For −1 < x ≤ 2, p follows a smooth curve that rises continuously, approaching the point (−1, 0) as x → −1 from the right, and reaching a closed (filled) point at (2, 4). For x > 2, p(x) = 1 for all x, shown as a horizontal ray with an open circle at (2, 1) (not included, since p(2) = 4 from the curve).',
      '{"content_key":"apcalcbc-frq-u13-007","subject":"ap_calculus_bc","unit":1,"topic":"1.9 Connecting Multiple Representations of Limits","archetype":"Connecting Representations","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Find lim_{x→−1^−} p(x) and lim_{x→−1^+} p(x), and determine whether lim_{x→−1} p(x) exists.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Determine lim_{x→2} p(x), and state whether p is continuous at x = 2. Justify your answer.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Classify the type of discontinuity at x = −1 and at x = 2, justifying each classification.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Analyzing a Graph Described in Words: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('b585a333-4144-4707-af86-4ded5ffd8fa1'::uuid, '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'part-a-criterion-01', 'Correctly finds the left-hand limit.', 1, 'Response gives lim_{x→−1^−} p(x) = 3, from the line segment approaching the open circle at (−1,3).', 'If wrong, recheck the description of the line segment''s endpoint near x = −1.', '[]'::jsonb),
      ('4c757079-03a3-4c03-a97f-de8299cd278e'::uuid, '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'part-a-criterion-02', 'Correctly finds the right-hand limit.', 1, 'Response gives lim_{x→−1^+} p(x) = 0, from the curve approaching (−1, 0) from the right.', 'If wrong, recheck the description of the curve''s starting behavior near x = −1.', '[]'::jsonb),
      ('20addfee-a15a-458d-af36-cd72287c10c4'::uuid, '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'part-a-criterion-03', 'Correctly concludes the two-sided limit does not exist, with reasoning.', 1, 'Response states lim_{x→−1} p(x) DNE because the one-sided limits (3 and 0) are not equal.', 'If missing, require explicit comparison of the one-sided limit values as justification.', '[]'::jsonb),
      ('8d0b50e7-67bb-4e21-ac91-c8d817ce3b36'::uuid, '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'part-b-criterion-01', 'Correctly finds both one-sided limits at x = 2.', 1, 'Response gives lim_{x→2^−} p(x) = 4 (curve reaching the closed point) and lim_{x→2^+} p(x) = 1 (horizontal ray).', 'If wrong, recheck the description of the curve''s endpoint and the ray''s value near x = 2.', '[]'::jsonb),
      ('bc6a14f2-a744-4d8b-aaf5-63c65b1dcecb'::uuid, '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'part-b-criterion-02', 'Correctly concludes the two-sided limit does not exist.', 1, 'Response states lim_{x→2} p(x) DNE since the one-sided limits (4 and 1) differ.', 'If missing, require explicit comparison of the one-sided limits.', '[]'::jsonb),
      ('24d10baf-c1eb-4203-a7b1-d5c87047b3a9'::uuid, '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'part-b-criterion-03', 'Correctly concludes p is not continuous at x = 2 with justification.', 1, 'Response concludes p is not continuous at x = 2 because lim_{x→2} p(x) does not exist, which alone violates the continuity definition.', 'If missing, require the justification to explicitly tie the nonexistence of the limit to the continuity definition.', '[]'::jsonb),
      ('f77a614f-536a-48d8-aa00-28873b951f28'::uuid, '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'part-c-criterion-01', 'Correctly classifies x = −1 as a jump discontinuity with justification.', 1, 'Response states x = −1 is a jump discontinuity because both one-sided limits are finite but unequal (3 ≠ 0).', 'If missing, require reference to the finite-but-unequal one-sided limits as the justification.', '[]'::jsonb),
      ('5b6d0461-2b71-43e7-a98f-2878620508c3'::uuid, '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'part-c-criterion-02', 'Correctly classifies x = 2 as a jump discontinuity with justification.', 1, 'Response states x = 2 is a jump discontinuity because both one-sided limits are finite but unequal (4 ≠ 1).', 'If missing, require reference to the finite-but-unequal one-sided limits as the justification.', '[]'::jsonb),
      ('d4306361-e23b-444b-a28f-4b0f4255f8ac'::uuid, '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'part-c-criterion-03', 'Explains why neither point is removable or infinite.', 1, 'Response explains neither discontinuity is infinite (limits are finite) and neither is removable (the one-sided limits themselves disagree, rather than a single limit failing to match the function value).', 'If missing, require a contrast with the definitions of removable and infinite discontinuities.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-008'
      and id <> '8c52a8d7-362c-4aa9-a2b8-f197365f1367'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-008';
  end if;

  if not exists (
    select 1 from app.content_items where id = '8c52a8d7-362c-4aa9-a2b8-f197365f1367'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '8c52a8d7-362c-4aa9-a2b8-f197365f1367'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-008',
      'frq',
      'Product Rule with Estimated and Given Derivative Values',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes and Connecting Representations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid,
      '8c52a8d7-362c-4aa9-a2b8-f197365f1367'::uuid,
      1,
      'Product Rule with Estimated and Given Derivative Values: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Functions u and v are differentiable for all real numbers. Selected values of u are given in Table 1, and it is given that v(3) = 4.0 and v''(3) = 3.

Table 1: Values of u(x)
x | 2.9 | 3.0 | 3.1
u(x) | 5.24 | 5.00 | 4.72',
      '{"content_key":"apcalcbc-frq-u13-008","subject":"ap_calculus_bc","unit":2,"topic":"2.8 The Product Rule","archetype":"Implementing Mathematical Processes and Connecting Representations","difficulty":"Medium","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use Table 1 to approximate u''(3) with a centered (symmetric) difference quotient.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Let w(x) = u(x)v(x). Using u(3) = 5.00, v(3) = 4.0, v''(3) = 3, and your approximation for u''(3) from part A, approximate w''(3) using the product rule, and write the equation of the line tangent to the graph of w at x = 3.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Explain why using a symmetric difference quotient was an appropriate way to approximate u''(3), rather than using only a forward difference quotient.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Product Rule with Estimated and Given Derivative Values: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ee057995-99b5-4527-aae5-dfc1ad5d4992'::uuid, 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'part-a-criterion-01', 'Sets up the correct symmetric difference quotient.', 1, 'Response writes (u(3.1) − u(2.9))/(3.1 − 2.9).', 'If missing, require the symmetric difference formula centered at x = 3 to be shown.', '[]'::jsonb),
      ('f7af1ad5-637f-4d5e-aedb-5cd7bbb53b28'::uuid, 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'part-a-criterion-02', 'Correctly computes the numerical value.', 1, 'Response computes (4.72 − 5.24)/0.2 = −0.52/0.2 = −2.6.', 'If wrong, recheck the arithmetic of the numerator and denominator.', '[]'::jsonb),
      ('7aa32538-c912-485f-a830-383335ab0211'::uuid, 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'part-a-criterion-03', 'States the approximation with correct notation.', 1, 'Response writes u''(3) ≈ −2.6.', 'If missing, require the approximation symbol (≈) and correct derivative notation.', '[]'::jsonb),
      ('12f63882-7105-4b8e-ad60-c01f3e2e5373'::uuid, 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'part-b-criterion-01', 'States and applies the product rule formula.', 1, 'Response writes w''(3) = u''(3)v(3) + u(3)v''(3).', 'If missing, require the product rule formula to be stated before substitution.', '[]'::jsonb),
      ('3b33106e-699c-484f-a8ba-ae3ee040be62'::uuid, 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'part-b-criterion-02', 'Correctly substitutes and computes w''(3).', 1, 'Response computes (−2.6)(4.0) + (5.00)(3) = −10.4 + 15 = 4.6.', 'If wrong, recheck substitution of the four values into the product rule formula.', '[]'::jsonb),
      ('d08aa877-e4c9-4240-a323-4a21b8f17232'::uuid, 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'part-b-criterion-03', 'Correctly computes w(3).', 1, 'Response computes w(3) = u(3)v(3) = 5.00 × 4.0 = 20.', 'If wrong, recheck the multiplication.', '[]'::jsonb),
      ('e33fac8d-b281-4f16-afc6-514fd26b9d4f'::uuid, 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'part-b-criterion-04', 'Writes a correct tangent line equation.', 1, 'Response gives y − 20 = 4.6(x − 3) or equivalent.', 'If missing, require point-slope form using w(3) and w''(3).', '[]'::jsonb),
      ('5cff9cb6-670d-4e07-aec5-7b65c1098352'::uuid, 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'part-c-criterion-01', 'Explains that using both sides gives a better approximation.', 1, 'Response notes the symmetric difference quotient uses data on both sides of x = 3, generally producing a better approximation to the instantaneous rate of change than a one-sided estimate.', 'If missing, require an explanation referencing the use of points on both sides of x = 3.', '[]'::jsonb),
      ('c017d5e6-f9f7-4357-a9ca-caebe46b75ea'::uuid, 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'part-c-criterion-02', 'Connects the reasoning to the definition of the derivative.', 1, 'Response connects this to the derivative being defined as a two-sided limit of the difference quotient.', 'If missing, require the explanation to reference the derivative''s definition as a limit approached from both directions.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-009'
      and id <> '12b7348c-9448-4eae-ab43-6eefa9491f37'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-009';
  end if;

  if not exists (
    select 1 from app.content_items where id = '12b7348c-9448-4eae-ab43-6eefa9491f37'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '12b7348c-9448-4eae-ab43-6eefa9491f37'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-009',
      'frq',
      'Quotient Rule Derivative and Normal Line',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid,
      '12b7348c-9448-4eae-ab43-6eefa9491f37'::uuid,
      1,
      'Quotient Rule Derivative and Normal Line: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f(x) = (2x^2 + 1)/(x − 4).',
      '{"content_key":"apcalcbc-frq-u13-009","subject":"ap_calculus_bc","unit":2,"topic":"2.9 The Quotient Rule","archetype":"Implementing Mathematical Processes","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use the quotient rule to find f''(x), showing your setup and simplified result.","points":4,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1}]},{"part_key":"part-b","prompt":"Evaluate f(1) and f''(1).","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Write the equation of the line normal to the graph of f at x = 1.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Quotient Rule Derivative and Normal Line: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('f1b2ffbc-caff-4d32-addf-b4d51b4d7e37'::uuid, '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'part-a-criterion-01', 'Correctly sets up the quotient rule template.', 1, 'Response identifies top = 2x^2+1, bottom = x−4, and writes f''(x) = [(top)''(bottom) − (top)(bottom)'']/(bottom)^2.', 'If missing, require the quotient rule template to be written before substitution.', '[]'::jsonb),
      ('8d448992-f181-46d9-a72c-2676e24b49ef'::uuid, '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'part-a-criterion-02', 'Correctly expands the numerator.', 1, 'Response expands (4x)(x−4) − (2x^2+1)(1) = 4x^2 − 16x − 2x^2 − 1.', 'If wrong, recheck the distribution in both terms of the numerator.', '[]'::jsonb),
      ('c86736f2-8305-49e5-a840-42265ce85c81'::uuid, '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'part-a-criterion-03', 'Correctly simplifies the numerator.', 1, 'Response simplifies to 2x^2 − 16x − 1.', 'If wrong, recheck combining like terms from the expansion.', '[]'::jsonb),
      ('791c39d6-87c1-4773-a969-9c8bd029eeaf'::uuid, '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'part-a-criterion-04', 'States the correct final derivative.', 1, 'Response gives f''(x) = (2x^2 − 16x − 1)/(x − 4)^2.', 'If missing, require the final simplified expression to be stated explicitly.', '[]'::jsonb),
      ('a38c7470-79c1-494c-af69-c5c88f7bd88a'::uuid, '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'part-b-criterion-01', 'Correctly computes f(1).', 1, 'Response gives f(1) = (2+1)/(1−4) = 3/(−3) = −1.', 'If wrong, recheck substitution of x=1 into f(x).', '[]'::jsonb),
      ('af12e3c2-337d-4018-a561-13ebf0883570'::uuid, '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'part-b-criterion-02', 'Correctly computes f''(1).', 1, 'Response gives f''(1) = (2 − 16 − 1)/9 = −15/9 = −5/3.', 'If wrong, recheck substitution of x=1 into f''(x) from part A.', '[]'::jsonb),
      ('0ffe4842-de8d-48e2-acf9-86bc8f07bccc'::uuid, '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'part-c-criterion-01', 'Correctly identifies the normal slope as the negative reciprocal of f''(1).', 1, 'Response computes the normal slope as 3/5, the negative reciprocal of −5/3.', 'If wrong, recheck the negative reciprocal relationship between tangent and normal slopes.', '[]'::jsonb),
      ('a6be4926-8bba-428d-a84f-6e0b10930508'::uuid, '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'part-c-criterion-02', 'Uses the correct point.', 1, 'Response uses the point (1, −1) from part B.', 'If missing, require f(1) to be used as the y-coordinate of the point.', '[]'::jsonb),
      ('1a73ed5f-af35-4d30-a5e8-0aa02879edf6'::uuid, '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'part-c-criterion-03', 'Writes the correct final equation.', 1, 'Response gives y = (3/5)(x − 1) − 1 or equivalent.', 'If missing, require point-slope form using the point and normal slope.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-010'
      and id <> '71f1efd7-46c2-470a-a8b0-e38a26fe8c93'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-010';
  end if;

  if not exists (
    select 1 from app.content_items where id = '71f1efd7-46c2-470a-a8b0-e38a26fe8c93'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '71f1efd7-46c2-470a-a8b0-e38a26fe8c93'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-010',
      'frq',
      'Repeated Chain Rule with Logarithmic and Exponential Compositions',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid,
      '71f1efd7-46c2-470a-a8b0-e38a26fe8c93'::uuid,
      1,
      'Repeated Chain Rule with Logarithmic and Exponential Compositions: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let h(x) = [ln(x^2 + 4)]^3.',
      '{"content_key":"apcalcbc-frq-u13-010","subject":"ap_calculus_bc","unit":3,"topic":"3.1 The Chain Rule","archetype":"Implementing Mathematical Processes","difficulty":"Medium","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Find h''(x), showing each application of the chain rule.","points":4,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1}]},{"part_key":"part-b","prompt":"Evaluate h''(2) exactly. Leave your answer in terms of natural logarithms; do not approximate with a decimal.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Let k(x) = sin(e^{−2x}). Find k''(x) using the chain rule.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Repeated Chain Rule with Logarithmic and Exponential Compositions: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('562691b0-04ec-4426-a3b7-72a5b48e9fba'::uuid, 'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid, 'part-a-criterion-01', 'Correctly differentiates the outer power function.', 1, 'Response writes d/dx{[ln(x^2+4)]^3} = 3[ln(x^2+4)]^2 · d/dx[ln(x^2+4)].', 'If missing, require the outer power rule step to be shown before differentiating the inner logarithm.', '[]'::jsonb),
      ('c01938f5-2d29-444e-a31b-d01a29feadb4'::uuid, 'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid, 'part-a-criterion-02', 'Correctly differentiates the logarithm using the chain rule.', 1, 'Response gives d/dx[ln(x^2+4)] = 2x/(x^2+4).', 'If wrong, recheck the chain rule applied to ln(u) with u = x^2+4.', '[]'::jsonb),
      ('cf0137e0-877b-4d15-a2a6-7317e48db8b7'::uuid, 'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid, 'part-a-criterion-03', 'Correctly combines the two results.', 1, 'Response writes h''(x) = 3[ln(x^2+4)]^2 · (2x/(x^2+4)).', 'If missing, require the two derivative pieces to be multiplied together explicitly.', '[]'::jsonb),
      ('ec0f02f1-1c78-4759-a37c-6c847eb6dd69'::uuid, 'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid, 'part-a-criterion-04', 'Correctly simplifies to a single expression.', 1, 'Response simplifies to h''(x) = 6x[ln(x^2+4)]^2/(x^2+4).', 'If missing, require the final simplified single-fraction form to be stated.', '[]'::jsonb),
      ('e68f10b1-e211-4b7f-a4dc-09cddc06caac'::uuid, 'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid, 'part-b-criterion-01', 'Correctly substitutes x = 2.', 1, 'Response computes x^2 + 4 = 8 at x = 2.', 'If wrong, recheck the arithmetic 2^2+4.', '[]'::jsonb),
      ('05272307-5c3e-423f-ae13-449f1b923b3f'::uuid, 'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid, 'part-b-criterion-02', 'States the correct exact expression.', 1, 'Response gives h''(2) = (3/2)[ln 8]^2 (or an equivalent exact form).', 'If wrong, recheck substitution of x=2 into the formula from part A.', '[]'::jsonb),
      ('f677c3b9-9edf-441b-ad6a-ddf7af39a44a'::uuid, 'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid, 'part-b-criterion-03', 'Shows the simplification arithmetic explicitly.', 1, 'Response shows 6(2)/8 = 3/2 as an explicit step.', 'If missing, require the coefficient simplification to be shown, not just asserted.', '[]'::jsonb),
      ('87942418-ddbf-49ff-ad7e-f545dcb2de21'::uuid, 'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid, 'part-c-criterion-01', 'Correctly differentiates the outer sine function.', 1, 'Response writes k''(x) = cos(e^{−2x}) · d/dx[e^{−2x}].', 'If missing, require the outer derivative step to be shown before the inner one.', '[]'::jsonb),
      ('5bc1d89c-fefd-4ad3-a3a0-e8d45678aea8'::uuid, 'c9b06ef0-e676-4d2a-a4a6-313c2df01724'::uuid, 'part-c-criterion-02', 'Correctly differentiates the inner exponential and combines.', 1, 'Response gives d/dx[e^{−2x}] = −2e^{−2x}, and states k''(x) = −2e^{−2x}cos(e^{−2x}).', 'If wrong, recheck the chain rule constant multiple −2 applied to e^{−2x}.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-011'
      and id <> 'b2031f55-c88f-467b-ab45-69f0edf62473'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-011';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'b2031f55-c88f-467b-ab45-69f0edf62473'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'b2031f55-c88f-467b-ab45-69f0edf62473'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-011',
      'frq',
      'Solving for Constants to Guarantee Differentiability',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid,
      'b2031f55-c88f-467b-ab45-69f0edf62473'::uuid,
      1,
      'Solving for Constants to Guarantee Differentiability: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f(x) = { x^3 − 2x + k, for x ≤ 1 ; m x^2 − 3, for x > 1 }, where k and m are constants.',
      '{"content_key":"apcalcbc-frq-u13-011","subject":"ap_calculus_bc","unit":2,"topic":"2.4 Connecting Differentiability and Continuity","archetype":"Justification","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"State the two conditions that must both hold for f to be differentiable at x = 1.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Find the value of m required for the one-sided derivatives to be equal at x = 1.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Using your value of m, find the value of k required for f to be continuous at x = 1.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]},{"part_key":"part-d","prompt":"Explain why both continuity and equal one-sided derivatives are necessary for differentiability at x = 1 — that is, explain why continuity alone would not be sufficient.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Solving for Constants to Guarantee Differentiability: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('42ec88f5-15e0-4926-a1b3-c2dd2a3cd322'::uuid, 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'part-a-criterion-01', 'States the continuity condition.', 1, 'Response states f must be continuous at x = 1 (left limit = right limit = f(1)).', 'If missing, require the continuity condition to be stated explicitly as one of the two requirements.', '[]'::jsonb),
      ('99beebb6-ddf8-49cd-a0f7-448247eda9f6'::uuid, 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'part-a-criterion-02', 'States the matching-derivative condition.', 1, 'Response states the one-sided derivatives at x = 1 must be equal.', 'If missing, require the equal-derivative condition to be stated explicitly as the second requirement.', '[]'::jsonb),
      ('e54c5a5e-11fa-4345-a2a8-c325fd576ded'::uuid, 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'part-b-criterion-01', 'Correctly finds the left-hand derivative at x = 1.', 1, 'Response computes d/dx[x^3−2x+k] = 3x^2−2, giving 3(1)^2−2 = 1 at x=1.', 'If wrong, recheck the derivative of the left piece and its evaluation at x=1.', '[]'::jsonb),
      ('3a3346c0-f13c-49f8-ad95-45da0e2310bf'::uuid, 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'part-b-criterion-02', 'Correctly finds the right-hand derivative at x = 1 in terms of m.', 1, 'Response computes d/dx[mx^2−3] = 2mx, giving 2m(1) = 2m at x=1.', 'If wrong, recheck the derivative of the right piece and its evaluation at x=1.', '[]'::jsonb),
      ('61f794c2-360e-4a5a-a35d-176ae5905d0f'::uuid, 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'part-b-criterion-03', 'Correctly solves for m.', 1, 'Response sets 2m = 1 and solves m = 1/2.', 'If wrong, recheck the equation set from equating the two one-sided derivatives.', '[]'::jsonb),
      ('3da9a84d-bad6-45a5-a335-9b566adc8f72'::uuid, 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'part-c-criterion-01', 'Sets up the correct continuity equation.', 1, 'Response sets the left piece''s value equal to the right piece''s value at x=1: (1−2+k) = (m(1)−3).', 'If missing, require the continuity equation to be set up explicitly before solving.', '[]'::jsonb),
      ('f41bbe29-98e2-4f1c-a1c2-bebe0d0fdd23'::uuid, 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'part-c-criterion-02', 'Correctly solves for k using m = 1/2.', 1, 'Response solves k − 1 = 1/2 − 3, giving k = −3/2.', 'If wrong, recheck substitution of m = 1/2 and the resulting algebra.', '[]'::jsonb),
      ('96d64129-a482-4811-ae50-94667980ba70'::uuid, 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'part-d-criterion-01', 'Explains that continuity alone permits a corner.', 1, 'Response explains that continuity only ensures no jump or hole at x=1, but the function could still have a ''corner'' with unequal slopes on each side, which is not differentiable.', 'If missing, require an explanation of how a continuous piecewise function can still fail to be smooth at the junction point.', '[]'::jsonb),
      ('0834dd75-b20e-4b66-a6c0-9fd43cc04e58'::uuid, 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'part-d-criterion-02', 'Ties the explanation to the definition of the derivative.', 1, 'Response explains that the derivative is defined as a limit of the difference quotient from both sides, and if the two pieces'' slopes disagree, that two-sided limit fails to exist even though f is continuous there.', 'If missing, require the explanation to connect the corner/unequal-slope scenario to the definition of the derivative as a limit.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-012'
      and id <> '7244286f-af2c-4e5a-aca1-493a1a7165ae'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-012';
  end if;

  if not exists (
    select 1 from app.content_items where id = '7244286f-af2c-4e5a-aca1-493a1a7165ae'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '7244286f-af2c-4e5a-aca1-493a1a7165ae'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-012',
      'frq',
      'Vertical and Horizontal Asymptotes of a Rational Function',
      'draft',
      'short',
      'targeted_drill',
      'Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid,
      '7244286f-af2c-4e5a-aca1-493a1a7165ae'::uuid,
      1,
      'Vertical and Horizontal Asymptotes of a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let r(x) = (2x^2 − 3x − 5)/(x^2 − 4).',
      '{"content_key":"apcalcbc-frq-u13-012","subject":"ap_calculus_bc","unit":1,"topic":"1.14 Connecting Infinite Limits and Vertical Asymptotes","archetype":"Justification","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Determine the equations of all vertical asymptotes of the graph of r. Justify your answer using limits.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Determine lim_{x→2^−} r(x) and lim_{x→2^+} r(x), showing a sign analysis of the numerator and denominator.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Determine the horizontal asymptote of r, justifying your answer using limits as x → ±∞.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Vertical and Horizontal Asymptotes of a Rational Function: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('5cc71f3e-8f7a-4e64-aa1b-887e72f30d06'::uuid, '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'part-a-criterion-01', 'Correctly factors the numerator and denominator.', 1, 'Response factors as (2x−5)(x+1)/[(x−2)(x+2)] and notes no common factors cancel.', 'If missing, require both numerator and denominator to be factored to check for common factors.', '[]'::jsonb),
      ('ea8a03ac-e704-4e69-ab33-43180b60c4e7'::uuid, '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'part-a-criterion-02', 'Justifies vertical asymptotes using infinite-limit reasoning.', 1, 'Response explains that as x → 2 or x → −2 the denominator approaches 0 while the numerator approaches a nonzero value, so lim r(x) = ±∞ there.', 'If missing, require the justification to reference the behavior of numerator and denominator near each candidate point.', '[]'::jsonb),
      ('58b36a78-e0e2-498a-a06e-f9dd284debfc'::uuid, '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'part-a-criterion-03', 'States both correct vertical asymptote equations.', 1, 'Response gives x = 2 and x = −2 as the vertical asymptotes.', 'If missing, require both asymptote equations to be stated.', '[]'::jsonb),
      ('b481523b-2088-409a-a702-fd1dfc43d669'::uuid, '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'part-b-criterion-01', 'Correctly analyzes the sign of the numerator near x = 2.', 1, 'Response notes (2x−5)(x+1) at x near 2 is approximately (−1)(3) = −3, negative.', 'If wrong, recheck evaluation of the numerator''s factors near x=2.', '[]'::jsonb),
      ('4d65ee1f-6bf5-4f1f-a606-a35ff9e5b854'::uuid, '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'part-b-criterion-02', 'Correctly analyzes the sign of the denominator on each side of x = 2.', 1, 'Response notes (x−2)(x+2) is negative for x slightly less than 2 and positive for x slightly greater than 2.', 'If wrong, recheck the sign of each factor (x−2) and (x+2) on each side of x=2.', '[]'::jsonb),
      ('8825e1d4-d00f-442f-aeb6-72cf6eb94a4f'::uuid, '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'part-b-criterion-03', 'Correctly concludes the left-hand limit.', 1, 'Response gives lim_{x→2^−} r(x) = +∞ (negative/negative).', 'If wrong, recheck combining the numerator and denominator signs for the left side.', '[]'::jsonb),
      ('952a6029-7468-40c6-afdf-46c19a55053a'::uuid, '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'part-b-criterion-04', 'Correctly concludes the right-hand limit.', 1, 'Response gives lim_{x→2^+} r(x) = −∞ (negative/positive).', 'If wrong, recheck combining the numerator and denominator signs for the right side.', '[]'::jsonb),
      ('7634c136-02a8-4120-a25e-0325e2b9c2fe'::uuid, '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'part-c-criterion-01', 'Uses a correct method to find the horizontal asymptote.', 1, 'Response divides numerator and denominator by x^2 (or compares leading coefficients) to find the ratio 2/1 = 2.', 'If missing, require the leading-term comparison method to be shown.', '[]'::jsonb),
      ('c9349867-46ca-4206-a306-cbd9480fa4e6'::uuid, '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'part-c-criterion-02', 'States the correct limit statement and asymptote for both directions.', 1, 'Response states lim_{x→∞} r(x) = lim_{x→−∞} r(x) = 2, so y = 2 is the horizontal asymptote.', 'If missing, require both directions (x→∞ and x→−∞) to be addressed.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-013'
      and id <> '534512d1-0ee2-41fa-ac1c-11732a533881'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-013';
  end if;

  if not exists (
    select 1 from app.content_items where id = '534512d1-0ee2-41fa-ac1c-11732a533881'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '534512d1-0ee2-41fa-ac1c-11732a533881'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-013',
      'frq',
      'Removable Discontinuity and Continuity Over an Interval',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes and Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid,
      '534512d1-0ee2-41fa-ac1c-11732a533881'::uuid,
      1,
      'Removable Discontinuity and Continuity Over an Interval: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let g(x) = (x^3 − 3x^2 − x + 3)/(x − 3) for x ≠ 3, and g(3) = p, where p is a constant.',
      '{"content_key":"apcalcbc-frq-u13-013","subject":"ap_calculus_bc","unit":1,"topic":"1.13 Removing Discontinuities","archetype":"Implementing Mathematical Processes and Justification","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Factor the numerator and use algebraic simplification to find lim_{x→3} g(x).","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Determine the value of p that makes g continuous at x = 3, and classify the type of discontinuity that exists if p ≠ 8.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"With p = 8, determine whether g is continuous on the closed interval [0, 3]. Justify your answer, addressing both interior points and x = 3.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Removable Discontinuity and Continuity Over an Interval: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('584ccbb3-0327-44b8-a4d9-fe4419556e89'::uuid, 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'part-a-criterion-01', 'Correctly factors the cubic numerator by grouping.', 1, 'Response factors x^3−3x^2−x+3 as x^2(x−3) − (x−3) = (x−3)(x^2−1), then further to (x−3)(x−1)(x+1).', 'If missing, require the grouping/factoring steps to be shown explicitly.', '[]'::jsonb),
      ('c2bdc1f5-a46f-47ec-ab27-b3e08951a511'::uuid, 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'part-a-criterion-02', 'Correctly cancels the common factor.', 1, 'Response cancels (x−3), leaving g(x) = (x−1)(x+1) = x^2 − 1 for x ≠ 3.', 'If missing, require the cancellation step to be shown.', '[]'::jsonb),
      ('ff63b7d9-9575-467c-afeb-6bffd4c2f4ac'::uuid, 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'part-a-criterion-03', 'Correctly evaluates the limit.', 1, 'Response gives lim_{x→3} g(x) = 9 − 1 = 8.', 'If wrong, recheck substitution of x=3 into the simplified expression.', '[]'::jsonb),
      ('34627d41-d4fe-455a-a2fe-aa4efab3daca'::uuid, 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'part-b-criterion-01', 'Correctly finds p = 8 for continuity.', 1, 'Response states p must equal the limit value 8 from part A.', 'If wrong, recheck that continuity requires g(3) = lim_{x→3} g(x).', '[]'::jsonb),
      ('c6ca7966-da9e-4cc9-a84b-2d8fc5887ccf'::uuid, 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'part-b-criterion-02', 'Correctly classifies the discontinuity as removable when p ≠ 8.', 1, 'Response states that if p ≠ 8, the discontinuity at x=3 is removable.', 'If missing, require the classification to be stated explicitly.', '[]'::jsonb),
      ('23bc4c8c-4cca-4119-a0ee-16619ad752da'::uuid, 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'part-b-criterion-03', 'Justifies the classification using the definition.', 1, 'Response explains the limit exists and is finite (8) but does not equal g(3) when p ≠ 8, matching the definition of a removable discontinuity (as opposed to jump or infinite).', 'If missing, require the justification to reference the definition distinguishing discontinuity types.', '[]'::jsonb),
      ('d4960662-4f94-4de5-a039-c27fe18b3f7c'::uuid, 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'part-c-criterion-01', 'Addresses continuity at interior points of the interval.', 1, 'Response notes that for x ≠ 3, g(x) = x^2 − 1 is a polynomial and thus continuous for all x, including 0 ≤ x < 3.', 'If missing, require an explicit statement about the continuity of the simplified polynomial form on the interior of the interval.', '[]'::jsonb),
      ('bd90bf92-aae2-47e0-a602-49471d7fc7ca'::uuid, 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'part-c-criterion-02', 'Addresses continuity at x = 3 with p = 8.', 1, 'Response notes that with p = 8, g(3) = 8 = lim_{x→3} g(x), satisfying continuity at x=3.', 'If missing, require the specific check at x=3 using the chosen value of p.', '[]'::jsonb),
      ('6ae8f208-29d3-47fb-ab6c-73b16726a8ee'::uuid, 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'part-c-criterion-03', 'States the overall correct conclusion with justification.', 1, 'Response concludes g is continuous on [0,3] because it is continuous at every point in the interval, including the previously problematic point x=3.', 'If missing, require a summary conclusion referencing continuity at all points of the interval.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-014'
      and id <> '36e89fef-d6b8-4196-a9a6-72251f12255a'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-014';
  end if;

  if not exists (
    select 1 from app.content_items where id = '36e89fef-d6b8-4196-a9a6-72251f12255a'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '36e89fef-d6b8-4196-a9a6-72251f12255a'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-014',
      'frq',
      'Water Tank Rates of Change from Table Data',
      'draft',
      'short',
      'targeted_drill',
      'Connecting Representations and Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid,
      '36e89fef-d6b8-4196-a9a6-72251f12255a'::uuid,
      1,
      'Water Tank Rates of Change from Table Data: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'The amount of water in a tank, W(t), measured in gallons, is a differentiable function of time t, measured in minutes. Selected values of W(t) are given in Table 1.

Table 1: Values of W(t)
t (min) | 0 | 3 | 6 | 9 | 12
W(t) (gal) | 120 | 145 | 158 | 162 | 160',
      '{"content_key":"apcalcbc-frq-u13-014","subject":"ap_calculus_bc","unit":2,"topic":"2.1 Defining Average and Instantaneous Rates of Change at a Point","archetype":"Connecting Representations and Justification","difficulty":"Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Find the average rate of change of W over the interval [0, 12]. Include units and interpret the result in context.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Use the data in Table 1 to approximate W''(9) using the most accurate difference quotient available from the table. Interpret the meaning of your answer in context, including units.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Is there evidence that W has a local maximum somewhere in the interval (6, 12)? Use the Mean Value Theorem and justify your reasoning.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Water Tank Rates of Change from Table Data: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('bda1d8f6-b163-44fe-a551-c560ff554c2c'::uuid, '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid, 'part-a-criterion-01', 'Sets up the correct average-rate-of-change formula.', 1, 'Response writes (W(12) − W(0))/(12 − 0).', 'If missing, require the average rate of change formula to be shown explicitly.', '[]'::jsonb),
      ('ec6ca256-2f4e-4f89-a3f3-05d7740d45cb'::uuid, '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid, 'part-a-criterion-02', 'Correctly computes the value.', 1, 'Response computes (160 − 120)/12 = 40/12 = 10/3 gallons per minute.', 'If wrong, recheck the subtraction and division.', '[]'::jsonb),
      ('c430e9c1-e5d9-4f51-a836-b0907e2fb91e'::uuid, '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid, 'part-a-criterion-03', 'Correctly interprets the result in context with units.', 1, 'Response explains that, on average, the amount of water in the tank increased by about 10/3 (≈3.33) gallons per minute over the 12-minute interval.', 'If missing, require units (gallons per minute) and a context sentence tied to the tank scenario.', '[]'::jsonb),
      ('9b5903be-fba5-415c-a15b-840337036c7f'::uuid, '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid, 'part-b-criterion-01', 'Selects the correct centered difference quotient.', 1, 'Response uses the symmetric interval around t=9, computing (W(12) − W(6))/(12 − 6).', 'If missing, require justification that a centered difference (using t=6 and t=12) is more accurate than a one-sided one at t=9.', '[]'::jsonb),
      ('3c7ffbda-a5d1-4669-ae57-bc3c3077d7b3'::uuid, '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid, 'part-b-criterion-02', 'Correctly computes the numerical value.', 1, 'Response computes (160 − 158)/6 = 2/6 = 1/3 gallon per minute.', 'If wrong, recheck the arithmetic in the numerator and denominator.', '[]'::jsonb),
      ('ae47b91a-2551-489f-a983-de4636f77ead'::uuid, '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid, 'part-b-criterion-03', 'Correctly interprets the result in context with units.', 1, 'Response explains that at the instant t = 9 minutes, the amount of water in the tank is increasing at approximately 1/3 gallon per minute.', 'If missing, require units and reference to ''instantaneous rate'' or ''at the instant t=9'' in the interpretation.', '[]'::jsonb),
      ('c411deed-16df-4dcd-a9aa-66bdb4b450d1'::uuid, '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid, 'part-c-criterion-01', 'Applies MVT on [6,9] to get a positive derivative value.', 1, 'Response notes W is differentiable (hence continuous) on [6,9], so by MVT there exists c1 in (6,9) with W''(c1) = (162−158)/3 = 4/3 > 0.', 'If missing, require MVT to be explicitly applied to the subinterval [6,9].', '[]'::jsonb),
      ('6fbdf81e-7676-41cc-a606-2526475fb198'::uuid, '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid, 'part-c-criterion-02', 'Applies MVT on [9,12] to get a negative derivative value.', 1, 'Response notes similarly there exists c2 in (9,12) with W''(c2) = (160−162)/3 = −2/3 < 0.', 'If missing, require MVT to be explicitly applied to the subinterval [9,12].', '[]'::jsonb),
      ('0468c861-6fd4-434c-a075-979e52e06182'::uuid, '97b569a6-b5f6-40ff-abce-efb94dff8870'::uuid, 'part-c-criterion-03', 'Draws the correct conclusion about a local maximum.', 1, 'Response concludes that since W'' is positive at c1 and negative at c2 with c1 < c2 both in (6,12), there is evidence of a local maximum for W somewhere between c1 and c2 within (6,12).', 'If missing, require the conclusion to connect the sign change in W'' (via the two MVT applications) to evidence of a local maximum.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-015'
      and id <> '0174698e-6f7d-4802-a3c2-d7ff725861f2'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-015';
  end if;

  if not exists (
    select 1 from app.content_items where id = '0174698e-6f7d-4802-a3c2-d7ff725861f2'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '0174698e-6f7d-4802-a3c2-d7ff725861f2'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-015',
      'frq',
      'First and Second Derivatives of a Tangent-Secant Combination',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid,
      '0174698e-6f7d-4802-a3c2-d7ff725861f2'::uuid,
      1,
      'First and Second Derivatives of a Tangent-Secant Combination: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f(x) = tan x + sec x.',
      '{"content_key":"apcalcbc-frq-u13-015","subject":"ap_calculus_bc","unit":2,"topic":"2.10 Derivatives of tan x, cot x, sec x, and csc x","archetype":"Implementing Mathematical Processes","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Find f''(x), showing the derivative rules used for tan x and sec x. Then evaluate f''(π/4) exactly.","points":4,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1}]},{"part_key":"part-b","prompt":"Find f''''(x), showing the product rule steps needed for each term.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Evaluate f''''(π/4) exactly, and state what this value indicates about the graph of f at x = π/4.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('First and Second Derivatives of a Tangent-Secant Combination: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('e0373821-e31d-451c-a65f-8e5c838dbf4c'::uuid, '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'part-a-criterion-01', 'Correctly differentiates tan x.', 1, 'Response gives d/dx[tan x] = sec^2 x.', 'If missing, require the derivative rule for tan x to be stated.', '[]'::jsonb),
      ('b442f524-822a-4c15-a826-db64472cae1d'::uuid, '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'part-a-criterion-02', 'Correctly differentiates sec x.', 1, 'Response gives d/dx[sec x] = sec x tan x.', 'If missing, require the derivative rule for sec x to be stated.', '[]'::jsonb),
      ('5d119b1f-ef00-445f-a2fa-bc3c6d1c6c23'::uuid, '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'part-a-criterion-03', 'Correctly combines to state f''(x).', 1, 'Response gives f''(x) = sec^2 x + sec x tan x.', 'If missing, require the two derivative terms to be added together explicitly.', '[]'::jsonb),
      ('8a743fdf-503d-4e81-a144-053f98affc2c'::uuid, '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'part-a-criterion-04', 'Correctly evaluates f''(π/4) exactly.', 1, 'Response computes sec(π/4)=√2, tan(π/4)=1, giving f''(π/4) = 2 + √2.', 'If wrong, recheck the exact trigonometric values at π/4 before substituting.', '[]'::jsonb),
      ('86cd5683-c52e-454c-a051-d318dc6d4b83'::uuid, '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'part-b-criterion-01', 'Correctly differentiates the sec^2 x term.', 1, 'Response uses the chain rule to get d/dx[sec^2 x] = 2 sec^2 x tan x.', 'If missing, require the chain rule step for sec^2 x = (sec x)^2 to be shown.', '[]'::jsonb),
      ('5279c462-fac1-4679-a322-0f3d709fed39'::uuid, '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'part-b-criterion-02', 'Correctly differentiates the sec x tan x term using the product rule.', 1, 'Response gives d/dx[sec x tan x] = sec x tan^2 x + sec^3 x.', 'If missing, require both terms of the product rule expansion to be shown.', '[]'::jsonb),
      ('9349bd2d-17f1-4c70-a18a-bb52440070d6'::uuid, '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'part-b-criterion-03', 'States the correct combined second derivative.', 1, 'Response gives f''''(x) = 2 sec^2 x tan x + sec x tan^2 x + sec^3 x, using correct notation.', 'If missing, require the two differentiated terms to be combined into a single expression for f''''(x).', '[]'::jsonb),
      ('31386be7-78e7-41c8-a9ee-d32d14fd3eea'::uuid, '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'part-c-criterion-01', 'Correctly evaluates f''''(π/4).', 1, 'Response computes 2(2)(1) + √2(1) + (√2)^3 = 4 + √2 + 2√2 = 4 + 3√2.', 'If wrong, recheck substitution of sec(π/4)=√2 and tan(π/4)=1 into f''''(x).', '[]'::jsonb),
      ('30d884bf-11e0-42ce-ada9-53d45e8417c2'::uuid, '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'part-c-criterion-02', 'Correctly interprets the sign of f''''(π/4).', 1, 'Response states since f''''(π/4) = 4 + 3√2 > 0, the graph of f is concave up at x = π/4.', 'If missing, require the interpretation to connect the positive second derivative to concavity.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-016'
      and id <> '587eb240-ffa7-49c1-ae97-ad05f17485b3'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-016';
  end if;

  if not exists (
    select 1 from app.content_items where id = '587eb240-ffa7-49c1-ae97-ad05f17485b3'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '587eb240-ffa7-49c1-ae97-ad05f17485b3'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-016',
      'frq',
      'Implicit Differentiation and Tangent Line to a Curve',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid,
      '587eb240-ffa7-49c1-ae97-ad05f17485b3'::uuid,
      1,
      'Implicit Differentiation and Tangent Line to a Curve: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Consider the curve defined by x^2 y + y^3 = 10.',
      '{"content_key":"apcalcbc-frq-u13-016","subject":"ap_calculus_bc","unit":3,"topic":"3.2 Implicit Differentiation","archetype":"Implementing Mathematical Processes","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use implicit differentiation to find dy/dx in terms of x and y.","points":4,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1}]},{"part_key":"part-b","prompt":"Verify that (1, 2) lies on the curve, and find the slope of the tangent line to the curve at (1, 2).","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Write the equation of the line tangent to the curve at (1, 2).","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Implicit Differentiation and Tangent Line to a Curve: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('06d05b7a-05d4-4f37-ad3e-cdc9698d44bc'::uuid, '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid, 'part-a-criterion-01', 'Correctly differentiates x^2 y using the product rule.', 1, 'Response gives d/dx[x^2 y] = x^2 y'' + 2xy.', 'If missing, require both terms of the product rule to be shown for x^2 y.', '[]'::jsonb),
      ('0c286a26-e8d2-46ad-a3da-5f5400da6925'::uuid, '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid, 'part-a-criterion-02', 'Correctly differentiates y^3 using the chain rule.', 1, 'Response gives d/dx[y^3] = 3y^2 y''.', 'If missing, require the chain rule factor y'' to be included when differentiating y^3.', '[]'::jsonb),
      ('b84c75ca-8337-42fc-a1a6-733964acebfa'::uuid, '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid, 'part-a-criterion-03', 'Correctly sets the derivative of the equation to 0 and collects y'' terms.', 1, 'Response writes x^2 y'' + 2xy + 3y^2 y'' = 0, then y''(x^2 + 3y^2) = −2xy.', 'If missing, require the y'' terms to be collected on one side before solving.', '[]'::jsonb),
      ('55f0cf0b-5c83-4e27-abed-3db08198798a'::uuid, '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid, 'part-a-criterion-04', 'States the correct final expression for dy/dx.', 1, 'Response gives dy/dx = −2xy/(x^2 + 3y^2).', 'If missing, require the final solved expression to be stated explicitly.', '[]'::jsonb),
      ('79bba931-3956-483e-ae63-76d19ad6b437'::uuid, '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid, 'part-b-criterion-01', 'Correctly verifies the point satisfies the equation.', 1, 'Response checks 1^2(2) + 2^3 = 2 + 8 = 10, confirming (1,2) is on the curve.', 'If missing, require explicit substitution into x^2y + y^3 = 10 to verify.', '[]'::jsonb),
      ('f672b872-dde2-472a-a50f-c8cbe975d449'::uuid, '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid, 'part-b-criterion-02', 'Correctly substitutes x=1, y=2 into the derivative expression.', 1, 'Response substitutes into dy/dx = −2xy/(x^2+3y^2) from part A.', 'If missing, require the substitution step to be shown.', '[]'::jsonb),
      ('9fa1f3ba-1049-4756-a2f8-9cfae05a0011'::uuid, '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid, 'part-b-criterion-03', 'Correctly computes the slope.', 1, 'Response computes dy/dx = −4/13 at (1,2).', 'If wrong, recheck the arithmetic −2(1)(2)/(1+3(4)).', '[]'::jsonb),
      ('ea8f2a68-97db-428e-a409-3f8bf35c5223'::uuid, '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid, 'part-c-criterion-01', 'Sets up point-slope form correctly.', 1, 'Response uses the point (1,2) and slope −4/13 in point-slope form.', 'If missing, require both the point and the slope from part B to be used explicitly.', '[]'::jsonb),
      ('5e5e7c2e-60cb-4858-aea5-0b8f496511ba'::uuid, '15612405-cfe7-4eec-ae8e-d0309a2326f6'::uuid, 'part-c-criterion-02', 'States the correct final tangent line equation.', 1, 'Response gives y − 2 = (−4/13)(x − 1) or an equivalent correct form.', 'If wrong, recheck substitution of the point and slope into point-slope form.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-017'
      and id <> '27567128-6138-432c-a88c-21b62f3529f2'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-017';
  end if;

  if not exists (
    select 1 from app.content_items where id = '27567128-6138-432c-a88c-21b62f3529f2'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '27567128-6138-432c-a88c-21b62f3529f2'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-017',
      'frq',
      'Derivative of an Inverse Function from a Table',
      'draft',
      'short',
      'targeted_drill',
      'Justification and Implementing Mathematical Processes'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid,
      '27567128-6138-432c-a88c-21b62f3529f2'::uuid,
      1,
      'Derivative of an Inverse Function from a Table: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'The function f is differentiable for all real numbers. Selected values of f and f'' are given in Table 1.

Table 1: Values of f(x) and f''(x)
x | 1 | 2 | 3 | 4
f(x) | 2 | 5 | 9 | 14
f''(x) | 3 | 4 | 5 | 6',
      '{"content_key":"apcalcbc-frq-u13-017","subject":"ap_calculus_bc","unit":3,"topic":"3.3 Differentiating Inverse Functions","archetype":"Justification and Implementing Mathematical Processes","difficulty":"Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Explain why f has an inverse function on this domain, justifying your answer using the given information.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Let g = f^{−1}. Find g''(5) and g''(9), showing the formula used.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Write the equation of the line tangent to the graph of g at x = 5.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Derivative of an Inverse Function from a Table: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('2302b8ea-4696-4b50-a202-01e030f611b1'::uuid, '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid, 'part-a-criterion-01', 'Notes the derivative values are all positive.', 1, 'Response observes f''(x) > 0 at each given value of x (3, 4, 5, 6 are all positive).', 'If missing, require explicit reference to the sign of f'' at the given points.', '[]'::jsonb),
      ('9d76bd24-e5b7-46bd-ae25-106fbe6f4ad0'::uuid, '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid, 'part-a-criterion-02', 'Reasons that f is strictly increasing.', 1, 'Response explains that a positive derivative throughout the interval means f is strictly increasing on this domain.', 'If missing, require the connection between positive derivative and strictly increasing behavior to be stated.', '[]'::jsonb),
      ('60964437-5233-4a4d-a302-7f6effbc3d3a'::uuid, '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid, 'part-a-criterion-03', 'Concludes f has an inverse with justification.', 1, 'Response concludes f is one-to-one (strictly monotonic), so f has an inverse function.', 'If missing, require the final conclusion to explicitly cite strict monotonicity as guaranteeing invertibility.', '[]'::jsonb),
      ('84543f68-614f-4e67-a371-1b998e8871b5'::uuid, '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid, 'part-b-criterion-01', 'States the correct general formula for the derivative of an inverse function.', 1, 'Response writes g''(a) = 1/f''(g(a)).', 'If missing, require the inverse function derivative formula to be stated before use.', '[]'::jsonb),
      ('24e82019-9e27-47e6-a69f-4dcb67ec43df'::uuid, '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid, 'part-b-criterion-02', 'Correctly finds g(5) and computes g''(5).', 1, 'Response identifies g(5) = 2 (since f(2) = 5) and computes g''(5) = 1/f''(2) = 1/4.', 'If wrong, recheck which x-value satisfies f(x) = 5.', '[]'::jsonb),
      ('f074c174-dcb2-47cb-ad87-8b8a9032fefe'::uuid, '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid, 'part-b-criterion-03', 'Correctly finds g(9) and computes g''(9).', 1, 'Response identifies g(9) = 3 (since f(3) = 9) and computes g''(9) = 1/f''(3) = 1/5.', 'If wrong, recheck which x-value satisfies f(x) = 9.', '[]'::jsonb),
      ('72b571e6-0183-400e-ad9a-898f01a4665d'::uuid, '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid, 'part-b-criterion-04', 'States both final values with correct notation.', 1, 'Response clearly states g''(5) = 1/4 and g''(9) = 1/5.', 'If missing, require both final answers to be stated explicitly with correct notation.', '[]'::jsonb),
      ('840d827f-e89a-4ffc-a0d4-1f5a16f1dfd1'::uuid, '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid, 'part-c-criterion-01', 'Correctly identifies the point on the graph of g.', 1, 'Response identifies the point (5, 2), since g(5) = 2.', 'If missing, require the point to be stated explicitly using g(5) from part B.', '[]'::jsonb),
      ('809b3a4b-99f6-41fe-a49b-e3abb3aa32b8'::uuid, '047bca0a-b4f9-492b-aeda-c7862ec48559'::uuid, 'part-c-criterion-02', 'Writes the correct tangent line equation.', 1, 'Response gives y − 2 = (1/4)(x − 5) using the slope g''(5) = 1/4 from part B.', 'If wrong, recheck that the slope used is g''(5), not f''(5).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-018'
      and id <> '417e203e-a1f2-46aa-a993-b9ce22b6d7db'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-018';
  end if;

  if not exists (
    select 1 from app.content_items where id = '417e203e-a1f2-46aa-a993-b9ce22b6d7db'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '417e203e-a1f2-46aa-a993-b9ce22b6d7db'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-018',
      'frq',
      'Derivative of a Sum of Inverse Trigonometric Compositions',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes and Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid,
      '417e203e-a1f2-46aa-a993-b9ce22b6d7db'::uuid,
      1,
      'Derivative of a Sum of Inverse Trigonometric Compositions: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let h(x) = arccos(x^2) + x·arctan(2x).',
      '{"content_key":"apcalcbc-frq-u13-018","subject":"ap_calculus_bc","unit":3,"topic":"3.4 Differentiating Inverse Trigonometric Functions","archetype":"Implementing Mathematical Processes and Justification","difficulty":"Very Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"State the domain restriction required for arccos(x^2) to be defined, and verify that x = 1/2 lies in the domain of h.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Find h''(x), showing each rule used: the chain rule for arccos(x^2), and the product and chain rules for x·arctan(2x).","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Evaluate h''(1/2) exactly, in simplified exact form. Do not approximate with a decimal.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Derivative of a Sum of Inverse Trigonometric Compositions: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('28a9e015-8061-4f87-adf1-45edf779eca1'::uuid, '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid, 'part-a-criterion-01', 'States the correct domain restriction.', 1, 'Response states that arccos(u) requires −1 ≤ u ≤ 1, so −1 ≤ x^2 ≤ 1, which (since x^2 ≥ 0) reduces to −1 ≤ x ≤ 1.', 'If missing, require the domain condition on x^2 to be stated and simplified correctly.', '[]'::jsonb),
      ('da6214a0-da84-4b7d-a541-eb0fa741cb0b'::uuid, '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid, 'part-a-criterion-02', 'Correctly verifies x = 1/2 is in the domain.', 1, 'Response checks (1/2)^2 = 1/4 ≤ 1, confirming x = 1/2 is a valid input.', 'If missing, require explicit substitution of x=1/2 to verify the domain condition.', '[]'::jsonb),
      ('2d2bb840-1eb9-40f5-a32a-c6759e8243c1'::uuid, '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid, 'part-b-criterion-01', 'Correctly differentiates arccos(x^2) using the chain rule.', 1, 'Response gives d/dx[arccos(x^2)] = −(2x)/√(1 − x^4).', 'If missing, require the chain rule with u = x^2 in d/dx[arccos u] = −u''/√(1−u^2) to be shown.', '[]'::jsonb),
      ('e4fddbcc-7eef-4e15-a959-c21923a8886e'::uuid, '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid, 'part-b-criterion-02', 'Correctly applies the product rule to x·arctan(2x).', 1, 'Response writes d/dx[x·arctan(2x)] = arctan(2x) + x·d/dx[arctan(2x)].', 'If missing, require both terms of the product rule to be shown explicitly.', '[]'::jsonb),
      ('fd1e387d-603f-4793-a4db-bd6990a5680a'::uuid, '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid, 'part-b-criterion-03', 'Correctly differentiates arctan(2x) using the chain rule and combines.', 1, 'Response gives d/dx[arctan(2x)] = 2/(1+4x^2), and combines to arctan(2x) + 2x/(1+4x^2).', 'If wrong, recheck the chain rule factor of 2 applied to arctan(2x).', '[]'::jsonb),
      ('fe5365bc-12e8-46ca-acdc-3add2c33e654'::uuid, '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid, 'part-b-criterion-04', 'States the correct fully combined h''(x).', 1, 'Response gives h''(x) = −2x/√(1−x^4) + arctan(2x) + 2x/(1+4x^2).', 'If missing, require all three terms to be combined into a single final expression for h''(x).', '[]'::jsonb),
      ('9d6a5c9a-ae40-437d-a8a7-386329ea4d23'::uuid, '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid, 'part-c-criterion-01', 'Correctly substitutes x = 1/2 into each term of h''(x).', 1, 'Response substitutes x=1/2 into all three terms from part B before simplifying.', 'If missing, require substitution into each term to be shown separately.', '[]'::jsonb),
      ('1e73b93b-79ac-4d9c-a0f2-b0c32d993539'::uuid, '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid, 'part-c-criterion-02', 'Correctly simplifies the arccos-derivative term.', 1, 'Response simplifies −2(1/2)/√(1−(1/2)^4) = −1/√(15/16) to −4√15/15 (or equivalent exact form, e.g. −4/√15).', 'If wrong, recheck the computation of 1 − (1/2)^4 = 15/16 and the resulting simplification.', '[]'::jsonb),
      ('7c74a0b9-a1df-4734-ae3a-0ba1846be0b1'::uuid, '330af8a5-f1a2-4b23-aafd-e384bde6cd0f'::uuid, 'part-c-criterion-03', 'States the correct final combined exact expression.', 1, 'Response gives h''(1/2) = π/4 + 1/2 − 4√15/15 (using arctan(1) = π/4 and 2(1/2)/(1+4(1/2)^2) = 1/2), or an equivalent exact simplified form.', 'If missing, require all three exact terms to be combined into one final exact expression.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-019'
      and id <> 'ca031a4c-d0e6-4866-a7a7-aa01f121a035'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-019';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'ca031a4c-d0e6-4866-a7a7-aa01f121a035'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'ca031a4c-d0e6-4866-a7a7-aa01f121a035'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-019',
      'frq',
      'Selecting Procedures Across a Piecewise Function with a Parameter',
      'draft',
      'short',
      'targeted_drill',
      'Connecting Representations and Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'cabe6695-6cac-402f-a145-751c2c84575a'::uuid,
      'ca031a4c-d0e6-4866-a7a7-aa01f121a035'::uuid,
      1,
      'Selecting Procedures Across a Piecewise Function with a Parameter: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Let f be defined by f(x) = (x^2 − 5x + 6)/(x − 3) for x < 3, f(3) = b (a constant), and for x > 3, f is given by values in Table 1.

Table 1: Values of f(x) for x > 3
x | 3.1 | 3.01 | 3.001
f(x) | 2.05 | 2.0005 | 2.00005',
      '{"content_key":"apcalcbc-frq-u13-019","subject":"ap_calculus_bc","unit":1,"topic":"1.7 Selecting Procedures for Determining Limits","archetype":"Connecting Representations and Justification","difficulty":"Very Hard","calculator":"required","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Determine lim_{x→3^−} f(x) using algebraic manipulation, showing your work, and determine lim_{x→3^+} f(x) using the values in Table 1. Explain why a different procedure was appropriate for each piece.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Determine whether lim_{x→3} f(x) exists. Justify your answer.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Explain whether any value of b could make f continuous at x = 3. Justify using the definition of continuity.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]},{"part_key":"part-d","prompt":"Classify the type of discontinuity at x = 3, explaining your reasoning.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Selecting Procedures Across a Piecewise Function with a Parameter: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('dd706006-37a4-4dda-a07d-bb3fdef901de'::uuid, 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'part-a-criterion-01', 'Correctly finds the left-hand limit algebraically.', 1, 'Response factors (x^2−5x+6)/(x−3) = (x−2)(x−3)/(x−3) = x−2 for x≠3, giving lim_{x→3^−} f(x) = 1.', 'If wrong, recheck the factoring of the quadratic and the cancellation of (x−3).', '[]'::jsonb),
      ('58f03cc3-d24d-4b4c-a219-44edcfa00117'::uuid, 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'part-a-criterion-02', 'Correctly identifies the right-hand limit from the table.', 1, 'Response reads the table trend (2.05, 2.0005, 2.00005) to identify lim_{x→3^+} f(x) = 2.', 'If wrong, recheck that the table values are converging toward 2, not 3 or another value.', '[]'::jsonb),
      ('40bc3be4-3e91-4603-aa5b-16f20a5613ac'::uuid, 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'part-a-criterion-03', 'Justifies the choice of procedure for each piece.', 1, 'Response explains that algebraic factoring was appropriate for the left piece because a formula was given, while numerical table estimation was necessary for the right piece since no formula was given.', 'If missing, require explicit reasoning about why each technique matched the representation available for that piece.', '[]'::jsonb),
      ('394d4566-0652-4ccd-ad8d-1a0b129914e3'::uuid, 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'part-b-criterion-01', 'Compares the two one-sided limits.', 1, 'Response compares lim_{x→3^−} f(x) = 1 to lim_{x→3^+} f(x) = 2.', 'If missing, require both one-sided limit values from part A to be restated for comparison.', '[]'::jsonb),
      ('bbafd7bb-8cf1-4dd3-a7d8-cc9781a0f710'::uuid, 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'part-b-criterion-02', 'Correctly concludes the limit does not exist with justification.', 1, 'Response concludes lim_{x→3} f(x) does not exist because the one-sided limits (1 and 2) are unequal.', 'If missing, require the justification to explicitly cite the inequality of the one-sided limits.', '[]'::jsonb),
      ('c67ada6c-9e4d-4f17-ac2e-74a7edb1a3af'::uuid, 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'part-c-criterion-01', 'Reasons that continuity requires the two-sided limit to exist.', 1, 'Response notes that continuity at x=3 requires lim_{x→3} f(x) to exist and equal f(3) = b.', 'If missing, require the continuity condition to be restated before applying it here.', '[]'::jsonb),
      ('c5dd2e80-8741-4aa2-abb9-43218290ed55'::uuid, 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'part-c-criterion-02', 'Correctly concludes no value of b works, with justification.', 1, 'Response concludes that since lim_{x→3} f(x) does not exist regardless of b (from part B), no choice of b can make f continuous at x=3.', 'If missing, require the conclusion to explicitly connect the nonexistence of the two-sided limit to the impossibility of continuity for any b.', '[]'::jsonb),
      ('20f2191f-1cf4-45f4-a3aa-c69077aee25f'::uuid, 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'part-d-criterion-01', 'Correctly classifies the discontinuity as a jump discontinuity.', 1, 'Response states the discontinuity at x=3 is a jump discontinuity.', 'If wrong, recheck the classification against the definitions of removable, jump, and infinite discontinuities.', '[]'::jsonb),
      ('8bd4b432-7c82-4263-a8cc-96def06ece92'::uuid, 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'part-d-criterion-02', 'Justifies the classification using the definition.', 1, 'Response explains both one-sided limits exist and are finite (1 and 2) but are unequal, matching the definition of a jump discontinuity and ruling out removable or infinite types.', 'If missing, require the justification to explicitly rule out the other discontinuity types.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apcalcbc-frq-u13-020'
      and id <> '3e7fa3a2-7e6b-4918-a222-d449b2ab108c'::uuid
  ) then
    raise exception 'material_content_key_collision:apcalcbc-frq-u13-020';
  end if;

  if not exists (
    select 1 from app.content_items where id = '3e7fa3a2-7e6b-4918-a222-d449b2ab108c'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '3e7fa3a2-7e6b-4918-a222-d449b2ab108c'::uuid,
      v_epv_id,
      'apcalcbc-frq-u13-020',
      'frq',
      'Second Derivative of an Implicitly Defined Curve',
      'draft',
      'short',
      'targeted_drill',
      'Implementing Mathematical Processes and Justification'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid,
      '3e7fa3a2-7e6b-4918-a222-d449b2ab108c'::uuid,
      1,
      'Second Derivative of an Implicitly Defined Curve: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.',
      'Consider the curve defined by x^2 + xy + y^2 = 7. The point (1, 2) lies on this curve.',
      '{"content_key":"apcalcbc-frq-u13-020","subject":"ap_calculus_bc","unit":3,"topic":"3.6 Calculating Higher-Order Derivatives","archetype":"Implementing Mathematical Processes and Justification","difficulty":"Very Hard","calculator":"not_permitted","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["calc-ab-bc-units1-3-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Use implicit differentiation to find dy/dx for the curve, then evaluate dy/dx at (1, 2).","points":4,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1}]},{"part_key":"part-b","prompt":"Find d^2y/dx^2 at (1, 2) by differentiating implicitly a second time.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Based on the sign of y'''' at (1, 2), describe the concavity of the curve near this point, and explain what this indicates about the local shape of the curve.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      md5('Second Derivative of an Implicitly Defined Curve: Answer all parts. Show your reasoning and calculations clearly, using standard calculus notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('27156ac6-4b8c-46ae-a6c8-e054bb39c4db'::uuid, '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid, 'part-a-criterion-01', 'Correctly differentiates x^2.', 1, 'Response gives d/dx[x^2] = 2x.', 'If missing, require this term''s derivative to be shown.', '[]'::jsonb),
      ('d553f5ae-7df8-44d3-afb9-6bfb9e27d42d'::uuid, '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid, 'part-a-criterion-02', 'Correctly differentiates xy using the product rule.', 1, 'Response gives d/dx[xy] = y + xy''.', 'If missing, require both terms of the product rule to be shown for xy.', '[]'::jsonb),
      ('abf552c4-db71-49cf-adff-118f7bab97b5'::uuid, '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid, 'part-a-criterion-03', 'Correctly differentiates y^2 using the chain rule and solves for y''.', 1, 'Response gives d/dx[y^2] = 2yy'', sets 2x + y + xy'' + 2yy'' = 0, and solves y'' = −(2x+y)/(x+2y).', 'If missing, require the y'' terms to be collected and solved for explicitly.', '[]'::jsonb),
      ('00c9dfe8-59d3-4bfa-a7c7-aa6163ff1540'::uuid, '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid, 'part-a-criterion-04', 'Correctly evaluates dy/dx at (1,2).', 1, 'Response substitutes to get y'' = −(2+2)/(1+4) = −4/5.', 'If wrong, recheck substitution of x=1, y=2 into the derivative formula.', '[]'::jsonb),
      ('0753180d-bd46-42b5-a4b6-8d5a24521166'::uuid, '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid, 'part-b-criterion-01', 'Correctly differentiates the first-derivative equation again with respect to x.', 1, 'Response differentiates y''(x+2y) = −(2x+y) to obtain y''''(x+2y) + y''(1+2y'') = −(2+y'').', 'If missing, require the second implicit differentiation step to be shown explicitly, including product rule on y''(x+2y).', '[]'::jsonb),
      ('a562710c-cfb2-4bb5-a887-973ff6395df8'::uuid, '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid, 'part-b-criterion-02', 'Correctly substitutes x=1, y=2, y''=−4/5 into the resulting equation.', 1, 'Response substitutes these values into the equation from the previous step before solving for y''''.', 'If missing, require all three known values to be substituted before isolating y''''.', '[]'::jsonb),
      ('46b26d7c-db7f-4bd1-a5d4-a85685123e59'::uuid, '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid, 'part-b-criterion-03', 'Correctly solves for y'''' and states the final value.', 1, 'Response computes y'''' = −42/125 at (1,2).', 'If wrong, recheck the algebra solving for y'''' after substitution, e.g. by recomputing −2 −2y'' −2(y'')^2 over (x+2y).', '[]'::jsonb),
      ('4f080990-78f9-4817-aeb8-744ae04e36cc'::uuid, '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid, 'part-c-criterion-01', 'Correctly identifies the sign and resulting concavity.', 1, 'Response notes y'''' = −42/125 < 0 at (1,2), so the curve is concave down near this point.', 'If wrong, recheck the sign of the value found in part B.', '[]'::jsonb),
      ('c7bb5668-19db-43d6-abd1-ecb530c6997e'::uuid, '04a86fa0-32b0-4f3c-a1f8-d33fc222e879'::uuid, 'part-c-criterion-02', 'Justifies the interpretation using the definition of concavity.', 1, 'Response explains that a negative second derivative indicates the local branch of the curve near (1,2) bends downward (is concave down), noting this describes the local behavior of the curve near this point rather than a global property.', 'If missing, require the explanation to connect the sign of y'''' to the definition of concavity and note it applies locally near (1,2).', '[]'::jsonb);
  end if;
end
$calc_ab_bc_units1_3$;
commit;
