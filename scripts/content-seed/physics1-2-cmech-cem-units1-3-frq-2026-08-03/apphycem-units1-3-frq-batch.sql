begin;
do $physics_units1_3$
declare
  v_epv_id uuid;
  v_epv_count integer;
  v_max integer;
begin
  select count(*) into v_epv_count
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_physics_c_em'
    and epv.status = 'published';

  if v_epv_count <> 1 then
    raise exception 'expected_exactly_one_published_exam_pack_version:%:%', 'ap_physics_c_em', v_epv_count;
  end if;

  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_physics_c_em'
    and epv.status = 'published';

  select coalesce(max((regexp_match(content_key, '-frq-([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^apphycem-frq-[0-9]+$';
  if v_max <> 38 then
    raise exception 'unexpected_live_max:apphycem:expected=38:actual=%', v_max;
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-039'
      and id <> '1e944853-f210-4db3-a3d3-a0eb1d60bbc7'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-039';
  end if;

  if not exists (
    select 1 from app.content_items where id = '1e944853-f210-4db3-a3d3-a0eb1d60bbc7'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '1e944853-f210-4db3-a3d3-a0eb1d60bbc7'::uuid,
      v_epv_id,
      'apphycem-frq-039',
      'frq',
      'apphycem-frq-039',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'ee66c5e6-16bd-4a6c-a699-81a88d7fea4f'::uuid,
      '1e944853-f210-4db3-a3d3-a0eb1d60bbc7'::uuid,
      1,
      'Answer all parts of the following question.

(a) Describe a procedure for this investigation, identifying the independent variable, the dependent variable, and one quantity that must be held constant (a control) across trials.

(b) Explain why plotting the measured force F versus 1/r^2 should produce a straight line through the origin if Coulomb''s law holds, and state what physical quantity determines the slope of that line.',
      'A student holds two small charged spheres, each carrying a fixed charge of magnitude 5.00 nC, at various separations r ranging from 0.10 m to 0.50 m and measures the electrostatic force between them with a force sensor.',
      '{"modules":["unit-8-electric-charges-fields-and-gauss-s-law","practice-1"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-experimental","difficulty":"Easy","content_key":"apphycem-frq-039","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Describe a procedure for this investigation, identifying the independent variable, the dependent variable, and one quantity that must be held constant (a control) across trials.

(b) Explain why plotting the measured force F versus 1/r^2 should produce a straight line through the origin if Coulomb''s law holds, and state what physical quantity determines the slope of that line.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('c75c2984-3a54-4b1d-a3c7-839665ace46f'::uuid, 'ee66c5e6-16bd-4a6c-a699-81a88d7fea4f'::uuid, 'part-a', 'Identifies the separation r as the independent variable, the measured force F as the dependent variable, and the charge magnitude on each sphere as a control held constant.', 1, 'Names r as varied, F as measured, and charge magnitude (or sphere size) as fixed across trials', 'State that r is deliberately varied, F is measured, and the charges q1, q2 are held fixed.', '[]'::jsonb),
      ('094d878f-aa45-4290-a87c-a3f8951fe03f'::uuid, 'ee66c5e6-16bd-4a6c-a699-81a88d7fea4f'::uuid, 'part-b', 'Explains that Coulomb''s law F = kq1q2/r^2 predicts F is linear in 1/r^2, with slope equal to kq1q2.', 1, 'References F=kq1q2/r^2 and identifies the slope as kq1q2', 'Rewrite Coulomb''s law as F = (kq1q2)(1/r^2) and identify kq1q2 as the slope of F vs 1/r^2.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-040'
      and id <> '2ed10d3e-0305-481a-a8c3-51366993d690'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-040';
  end if;

  if not exists (
    select 1 from app.content_items where id = '2ed10d3e-0305-481a-a8c3-51366993d690'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '2ed10d3e-0305-481a-a8c3-51366993d690'::uuid,
      v_epv_id,
      'apphycem-frq-040',
      'frq',
      'apphycem-frq-040',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'af57088b-e96a-4965-af61-dfefe99d1f29'::uuid,
      '2ed10d3e-0305-481a-a8c3-51366993d690'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the net electric field at the midpoint between the two charges.

(b) Explain, using superposition and the direction of each charge''s individual field at that point, why the net field there is zero regardless of the common charge magnitude.',
      'Two identical point charges of +5.00 nC each are fixed at x = 0 and x = 0.600 m on the x-axis.',
      '{"modules":["unit-8-electric-charges-fields-and-gauss-s-law","practice-2"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-representation","difficulty":"Easy","content_key":"apphycem-frq-040","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the net electric field at the midpoint between the two charges.

(b) Explain, using superposition and the direction of each charge''s individual field at that point, why the net field there is zero regardless of the common charge magnitude.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('5d436052-6602-4bcc-ac12-c5352a76eebb'::uuid, 'af57088b-e96a-4965-af61-dfefe99d1f29'::uuid, 'part-a', 'Calculates the net electric field at the midpoint as zero, showing the two individual field contributions.', 1, 'Computes E from each +5.00 nC charge at r=0.300 m (each about 499 N/C) and shows they point in opposite directions, summing to zero', 'Compute E=kq/r^2 for each charge at the midpoint and note the two vectors point in opposite directions with equal magnitude.', '[]'::jsonb),
      ('a8b9994c-26fe-4acd-aa6c-9e8806dbc021'::uuid, 'af57088b-e96a-4965-af61-dfefe99d1f29'::uuid, 'part-b', 'Explains that by superposition, the two equal-magnitude fields point directly away from their respective charges (in opposite directions at the midpoint) and cancel exactly.', 1, 'References equal magnitude and opposite direction of the two contributions due to symmetry', 'State that since the charges are equal and equidistant from the midpoint, their field vectors are equal in magnitude and opposite in direction, so they cancel.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-041'
      and id <> '60c838d0-828e-4c85-a208-d21b95da6796'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-041';
  end if;

  if not exists (
    select 1 from app.content_items where id = '60c838d0-828e-4c85-a208-d21b95da6796'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '60c838d0-828e-4c85-a208-d21b95da6796'::uuid,
      v_epv_id,
      'apphycem-frq-041',
      'frq',
      'apphycem-frq-041',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '103ba951-f78a-46dd-a771-a8f33e8cc2e1'::uuid,
      '60c838d0-828e-4c85-a208-d21b95da6796'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the electric potential energy of the system at the original separation. Then predict and calculate the potential energy when the separation is tripled to 1.20 m.

(b) Explain why tripling the separation reduces the potential energy to one-third of its original value.',
      'Two point charges of +1.50 microC and +2.50 microC are separated by 0.400 m in vacuum.',
      '{"modules":["unit-9-electric-potential","practice-3"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-translation","difficulty":"Easy","content_key":"apphycem-frq-041","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the electric potential energy of the system at the original separation. Then predict and calculate the potential energy when the separation is tripled to 1.20 m.

(b) Explain why tripling the separation reduces the potential energy to one-third of its original value.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('0d78d62b-177c-4cfc-ae1f-cab46b13b7c1'::uuid, '103ba951-f78a-46dd-a771-a8f33e8cc2e1'::uuid, 'a-original', 'Calculates the correct original potential energy.', 1, 'U = kq1q2/r gives approximately 0.0843 J at r=0.400 m', 'Apply U=kq1q2/r with the original separation of 0.400 m.', '[]'::jsonb),
      ('a9fa96e8-ce4b-4598-a1bc-0d41f8e7ea8a'::uuid, '103ba951-f78a-46dd-a771-a8f33e8cc2e1'::uuid, 'a-tripled', 'Calculates the correct potential energy after tripling the separation.', 1, 'Using r=1.20 m gives approximately 0.0281 J, one-third of the original value', 'Apply U=kq1q2/r with the tripled separation of 1.20 m.', '[]'::jsonb),
      ('1a1e7b9c-a9c5-40b9-a258-60b339fa25e3'::uuid, '103ba951-f78a-46dd-a771-a8f33e8cc2e1'::uuid, 'part-b', 'Explains the inverse proportionality between U and r for point charges.', 1, 'References U proportional to 1/r, so tripling r reduces U to one-third', 'Explain that U=kq1q2/r means U scales inversely with r, so tripling r divides U by 3.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-042'
      and id <> '2da69394-c727-411e-a9d6-2acd61a41051'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-042';
  end if;

  if not exists (
    select 1 from app.content_items where id = '2da69394-c727-411e-a9d6-2acd61a41051'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '2da69394-c727-411e-a9d6-2acd61a41051'::uuid,
      v_epv_id,
      'apphycem-frq-042',
      'frq',
      'apphycem-frq-042',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '4a7130db-bc4a-4227-abab-e385fe24e9cf'::uuid,
      '2da69394-c727-411e-a9d6-2acd61a41051'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using integration, derive an expression for the electric field magnitude at point P in terms of lambda, L, and d.

(b) Evaluate the electric field magnitude at P for the given numeric values.',
      'A thin rod of length L = 0.600 m carries a uniform linear charge density lambda = 4.00 x 10^-9 C/m along the x-axis from x=0 to x=L. Point P lies on the axis of the rod, a distance d = 0.200 m beyond the end at x=L.',
      '{"modules":["unit-8-electric-charges-fields-and-gauss-s-law","practice-4"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-math","difficulty":"Medium","content_key":"apphycem-frq-042","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using integration, derive an expression for the electric field magnitude at point P in terms of lambda, L, and d.

(b) Evaluate the electric field magnitude at P for the given numeric values.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('c43d5cb1-0239-45d1-a4f1-d088bf3d3a5f'::uuid, '4a7130db-bc4a-4227-abab-e385fe24e9cf'::uuid, 'a-setup', 'Sets up the integral for E with a charge element dq = lambda dx at distance (L+d-x) from P.', 1, 'Writes dE = k(lambda dx)/(L+d-x)^2 and integrates x from 0 to L', 'Express dq=lambda dx and dE=k dq/(L+d-x)^2, then set up the integral over x from 0 to L.', '[]'::jsonb),
      ('e06b72d4-3fc7-477e-a909-ce789a2c33d9'::uuid, '4a7130db-bc4a-4227-abab-e385fe24e9cf'::uuid, 'a-integration', 'Correctly evaluates the integral to obtain E = k*lambda*L / [d(L+d)].', 1, 'Antiderivative 1/(L+d-x) evaluated at the limits gives 1/d - 1/(L+d) = L/[d(L+d)]', 'Integrate to get 1/(L+d-x) evaluated from 0 to L, simplify to L/[d(L+d)], and multiply by k*lambda.', '[]'::jsonb),
      ('1aba82e3-0de9-4321-ace1-c729ad004b9b'::uuid, '4a7130db-bc4a-4227-abab-e385fe24e9cf'::uuid, 'b-numeric', 'Evaluates E numerically as approximately 135 N/C.', 1, 'E = (8.99e9)(4.00e-9)(0.600)/[(0.200)(0.800)] is approximately 135 N/C', 'Substitute lambda=4.00e-9 C/m, L=0.600 m, d=0.200 m into the derived expression.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-043'
      and id <> '5d5c759d-9f63-4095-af0d-d0add6b189b4'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-043';
  end if;

  if not exists (
    select 1 from app.content_items where id = '5d5c759d-9f63-4095-af0d-d0add6b189b4'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '5d5c759d-9f63-4095-af0d-d0add6b189b4'::uuid,
      v_epv_id,
      'apphycem-frq-043',
      'frq',
      'apphycem-frq-043',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '1c2dcc35-9627-43a1-ace7-5d312764b87b'::uuid,
      '5d5c759d-9f63-4095-af0d-d0add6b189b4'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a procedure to determine the field magnitude, identifying the independent variable, the dependent variable, and one control quantity held fixed across trials.

(b) Explain how the relation tan(theta) = qE/(mg) is used to determine E from the measured angle.',
      'A small charged pith ball of known charge q and mass m hangs from an insulating thread inside a region of unknown uniform horizontal electric field created by a pair of parallel plates connected to an adjustable voltage source; the ball hangs at an equilibrium angle theta from vertical.',
      '{"modules":["unit-8-electric-charges-fields-and-gauss-s-law","practice-1"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-experimental","difficulty":"Medium","content_key":"apphycem-frq-043","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a procedure to determine the field magnitude, identifying the independent variable, the dependent variable, and one control quantity held fixed across trials.

(b) Explain how the relation tan(theta) = qE/(mg) is used to determine E from the measured angle.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('36a1ef7f-615b-4cf1-a192-7fdd424e1144'::uuid, '1c2dcc35-9627-43a1-ace7-5d312764b87b'::uuid, 'a-independent', 'Identifies the plate voltage (which sets the field magnitude) as the independent variable.', 1, 'States that the applied plate voltage is deliberately varied between trials', 'State that the voltage across the plates is varied to change the field.', '[]'::jsonb),
      ('27213c5b-a514-4008-a183-041975fb37a4'::uuid, '1c2dcc35-9627-43a1-ace7-5d312764b87b'::uuid, 'a-dependent', 'Identifies the equilibrium deflection angle theta as the dependent variable.', 1, 'States that theta is measured for each applied voltage', 'State that the equilibrium angle theta is measured at each field setting.', '[]'::jsonb),
      ('80d3db30-e553-47d6-a3de-519602c2dc4a'::uuid, '1c2dcc35-9627-43a1-ace7-5d312764b87b'::uuid, 'a-control', 'Identifies the ball''s charge q (or mass m, thread length) as a control held constant across trials.', 1, 'Names q or m as fixed', 'State that the charge on the ball (and its mass) is kept the same across trials.', '[]'::jsonb),
      ('944c93c2-f1b3-4e5f-a6e5-2980ea8a9899'::uuid, '1c2dcc35-9627-43a1-ace7-5d312764b87b'::uuid, 'b-analysis', 'Explains that equilibrium requires tan(theta)=qE/(mg), so E = mg*tan(theta)/q can be computed from the measured angle.', 1, 'Sets up horizontal and vertical force balance and solves for E', 'Balance horizontal electric force qE against the horizontal component of tension, and vertical weight mg against the vertical component, then divide to eliminate tension and solve for E.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-044'
      and id <> '06c1dfec-3755-4f50-a641-2cb533dc5629'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-044';
  end if;

  if not exists (
    select 1 from app.content_items where id = '06c1dfec-3755-4f50-a641-2cb533dc5629'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '06c1dfec-3755-4f50-a641-2cb533dc5629'::uuid,
      v_epv_id,
      'apphycem-frq-044',
      'frq',
      'apphycem-frq-044',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '895047bf-99d1-4f8e-a80f-38352a5b436a'::uuid,
      '06c1dfec-3755-4f50-a641-2cb533dc5629'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using integration, calculate the potential difference V(0) - V(L) for this field.

(b) Predict and calculate the new potential difference if L is doubled to 1.00 m with E0 unchanged, and justify the result using the integral relationship between V and E.',
      'A charge moves along the x-axis through a region of non-uniform electric field E(x) = E0(1 - x/L), directed in the +x direction, with E0 = 200 N/C and L = 0.500 m, from x=0 to x=L.',
      '{"modules":["unit-9-electric-potential","practice-2"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-translation","difficulty":"Medium","content_key":"apphycem-frq-044","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using integration, calculate the potential difference V(0) - V(L) for this field.

(b) Predict and calculate the new potential difference if L is doubled to 1.00 m with E0 unchanged, and justify the result using the integral relationship between V and E.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('41ef0ec4-49cd-4296-adac-44624b5e75d6'::uuid, '895047bf-99d1-4f8e-a80f-38352a5b436a'::uuid, 'a-integral', 'Sets up and evaluates the integral V(0)-V(L) = integral of E dx from 0 to L, obtaining E0*L/2 = 50.0 V.', 1, 'Integral of E0(1-x/L) dx from 0 to L equals E0[x - x^2/(2L)] evaluated at L, giving E0*L/2', 'Integrate E(x) from 0 to L using V(0)-V(L) = integral of E dx, and simplify to E0*L/2.', '[]'::jsonb),
      ('36c62057-e15f-4e59-a462-e8f51dde7108'::uuid, '895047bf-99d1-4f8e-a80f-38352a5b436a'::uuid, 'b-prediction', 'Predicts and calculates that doubling L doubles the potential difference to 100 V.', 1, 'New L=1.00 m gives E0*L/2 = 100 V', 'Substitute the doubled L into the derived expression E0*L/2.', '[]'::jsonb),
      ('29fd2621-1adb-4e86-aad1-9967385d1846'::uuid, '895047bf-99d1-4f8e-a80f-38352a5b436a'::uuid, 'b-justification', 'Justifies the doubling using the linear dependence of the integral result on L.', 1, 'States that the result E0*L/2 is directly proportional to L', 'Explain that since V(0)-V(L)=E0*L/2 is linear in L, doubling L doubles the potential difference.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-045'
      and id <> '196d1375-bd44-43b1-a523-59cb6ad562db'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-045';
  end if;

  if not exists (
    select 1 from app.content_items where id = '196d1375-bd44-43b1-a523-59cb6ad562db'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '196d1375-bd44-43b1-a523-59cb6ad562db'::uuid,
      v_epv_id,
      'apphycem-frq-045',
      'frq',
      'apphycem-frq-045',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'e6aa952a-45bb-4e68-a2f0-7762d5f981f2'::uuid,
      '196d1375-bd44-43b1-a523-59cb6ad562db'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the electric potential at the midpoint of the segment joining the charges, and at a point on the axis 0.100 m beyond the +6.00 nC charge (away from the -6.00 nC charge).

(b) Explain why the perpendicular bisector plane of the dipole is an equipotential surface, and describe how the electric field lines are oriented relative to that surface.',
      'An electric dipole consists of point charges +6.00 nC and -6.00 nC separated by 0.200 m along the x-axis.',
      '{"modules":["unit-9-electric-potential","practice-3"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-representation","difficulty":"Medium","content_key":"apphycem-frq-045","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the electric potential at the midpoint of the segment joining the charges, and at a point on the axis 0.100 m beyond the +6.00 nC charge (away from the -6.00 nC charge).

(b) Explain why the perpendicular bisector plane of the dipole is an equipotential surface, and describe how the electric field lines are oriented relative to that surface.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('9f015c84-f2eb-4b7b-a16d-7488ab691b31'::uuid, 'e6aa952a-45bb-4e68-a2f0-7762d5f981f2'::uuid, 'a-midpoint', 'Calculates the potential at the midpoint as zero, showing the two equal-and-opposite contributions.', 1, 'Both charges are 0.100 m from the midpoint, giving V=kq/r + k(-q)/r = 0', 'Compute V from each charge at r=0.100 m and show the contributions cancel exactly.', '[]'::jsonb),
      ('9f67bc1e-b2ac-41b0-a664-e0e318446010'::uuid, 'e6aa952a-45bb-4e68-a2f0-7762d5f981f2'::uuid, 'a-axial', 'Calculates the potential at the external axial point as approximately 360 V.', 1, 'V = kq(1/0.100 - 1/0.300) is approximately 360 V', 'Use distances of 0.100 m from +q and 0.300 m from -q in V=kq/r1 + k(-q)/r2.', '[]'::jsonb),
      ('9baa4248-7d33-4663-a414-e091d4b06fd2'::uuid, 'e6aa952a-45bb-4e68-a2f0-7762d5f981f2'::uuid, 'b-equipotential', 'Explains that the bisector plane is an equipotential (V=0 everywhere on it) and that field lines, always perpendicular to equipotential surfaces, cross it pointing from the + charge toward the - charge.', 1, 'References equal distance from both charges giving V=0 on the whole plane, and perpendicularity of field lines to equipotentials', 'State that every point on the bisector plane is equidistant from +q and -q, so V=0 there, and that field lines must cross this equipotential surface perpendicularly, directed from + to -.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-046'
      and id <> '898bf366-db28-4f59-ae2e-964624545fac'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-046';
  end if;

  if not exists (
    select 1 from app.content_items where id = '898bf366-db28-4f59-ae2e-964624545fac'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '898bf366-db28-4f59-ae2e-964624545fac'::uuid,
      v_epv_id,
      'apphycem-frq-046',
      'frq',
      'apphycem-frq-046',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'b21b6c97-446c-4ff2-ab56-8b8aa70e578f'::uuid,
      '898bf366-db28-4f59-ae2e-964624545fac'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the capacitance, and the charge and energy stored on the capacitor.

(b) Explain, in terms of the induced (bound) surface charge on the dielectric, why inserting the dielectric increases the capacitance compared to the same capacitor with vacuum between the plates.',
      'A parallel-plate capacitor has plate area A = 0.0200 m^2 and plate separation d = 1.00 mm, completely filled with a dielectric of dielectric constant kappa = 4.50, connected to a 12.0 V battery.',
      '{"modules":["unit-10-conductors-and-capacitors","practice-4"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-representation","difficulty":"Medium","content_key":"apphycem-frq-046","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the capacitance, and the charge and energy stored on the capacitor.

(b) Explain, in terms of the induced (bound) surface charge on the dielectric, why inserting the dielectric increases the capacitance compared to the same capacitor with vacuum between the plates.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('9e7caf5f-f9a1-4b2d-a90d-a5ef73ef1219'::uuid, 'b21b6c97-446c-4ff2-ab56-8b8aa70e578f'::uuid, 'a-capacitance', 'Calculates the capacitance as approximately 0.797 nF.', 1, 'C = kappa*epsilon0*A/d = 4.50*(8.85e-12)(0.0200)/(0.00100) is approximately 0.797 nF', 'Apply C=kappa*epsilon0*A/d with the given values.', '[]'::jsonb),
      ('2dce0b53-814c-4234-a4f1-88dab11a47d2'::uuid, 'b21b6c97-446c-4ff2-ab56-8b8aa70e578f'::uuid, 'a-charge-energy', 'Calculates the stored charge as approximately 9.56 nC and stored energy as approximately 57.4 nJ.', 1, 'Q=CV is approximately 9.56 nC and U=0.5CV^2 is approximately 57.4 nJ', 'Use Q=CV and U=0.5CV^2 with the capacitance found in part (a).', '[]'::jsonb),
      ('7177ce20-a8f3-450e-a8be-5fe549341fae'::uuid, 'b21b6c97-446c-4ff2-ab56-8b8aa70e578f'::uuid, 'b-explanation', 'Explains that the dielectric''s induced bound surface charges create an opposing field that reduces the net field between the plates, allowing more charge to be stored for the same voltage, hence a larger capacitance.', 1, 'References polarization/bound charge reducing the net internal field', 'Explain that the external field polarizes the dielectric, producing bound surface charges whose field partially cancels the plates'' field, reducing E and allowing more free charge Q=CV for the same V.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-047'
      and id <> 'f6184cf0-4ff5-4ad7-a6a4-64bc4de6c555'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-047';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'f6184cf0-4ff5-4ad7-a6a4-64bc4de6c555'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'f6184cf0-4ff5-4ad7-a6a4-64bc4de6c555'::uuid,
      v_epv_id,
      'apphycem-frq-047',
      'frq',
      'apphycem-frq-047',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '16f0636e-b063-489e-afaf-dec0601b6e4a'::uuid,
      'f6184cf0-4ff5-4ad7-a6a4-64bc4de6c555'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a procedure to determine the unknown capacitance, identifying the independent variable, the dependent variable, and one control held constant.

(b) Explain why a graph of V versus t should be a straight line through the origin, and how the capacitance is obtained from its slope.',
      'An unknown capacitor is charged by a constant current source supplying I = 5.00 microA, while a voltmeter records the capacitor voltage V at various times t.',
      '{"modules":["unit-10-conductors-and-capacitors","practice-1"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-experimental","difficulty":"Medium","content_key":"apphycem-frq-047","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a procedure to determine the unknown capacitance, identifying the independent variable, the dependent variable, and one control held constant.

(b) Explain why a graph of V versus t should be a straight line through the origin, and how the capacitance is obtained from its slope.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('45310000-6b63-441a-a3e9-2fa3be25aebf'::uuid, '16f0636e-b063-489e-afaf-dec0601b6e4a'::uuid, 'a-independent', 'Identifies elapsed time t as the independent variable.', 1, 'States that time is the deliberately varied/recorded quantity', 'State that time is recorded at intervals during charging.', '[]'::jsonb),
      ('106aebc9-a454-44dc-a6f5-dbb8b0493e82'::uuid, '16f0636e-b063-489e-afaf-dec0601b6e4a'::uuid, 'a-dependent', 'Identifies the capacitor voltage V as the dependent variable.', 1, 'Names voltage across the capacitor as measured at each time', 'State that voltage is measured as a function of time.', '[]'::jsonb),
      ('f5b7864d-e990-425f-a27b-8dfa3449427a'::uuid, '16f0636e-b063-489e-afaf-dec0601b6e4a'::uuid, 'a-control', 'Identifies the constant charging current I as a control held fixed.', 1, 'Names the current source setting as held constant across the trial', 'State that the charging current I is held constant throughout.', '[]'::jsonb),
      ('55ecd473-9b92-40b3-a042-69773ffc369e'::uuid, '16f0636e-b063-489e-afaf-dec0601b6e4a'::uuid, 'b-analysis', 'Explains that since Q=It and V=Q/C, V=(I/C)t is linear in t with slope I/C, so C = I/slope.', 1, 'Derives V=(I/C)t and identifies slope as I/C', 'Combine Q=It with V=Q/C to get V=(I/C)t, then solve C=I/slope from the measured graph.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-048'
      and id <> 'dd784904-8549-4369-afc2-0cffa011e6a7'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-048';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'dd784904-8549-4369-afc2-0cffa011e6a7'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'dd784904-8549-4369-afc2-0cffa011e6a7'::uuid,
      v_epv_id,
      'apphycem-frq-048',
      'frq',
      'apphycem-frq-048',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '6e70379e-3033-4164-a855-b6d286c10630'::uuid,
      'dd784904-8549-4369-afc2-0cffa011e6a7'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the total electric flux through the Gaussian sphere before the second charge is added, and state what happens to that total flux after the second charge is placed outside the sphere.

(b) Explain, using Gauss''s law, why the external charge does not change the total flux through the sphere even though it changes the electric field at points on the sphere''s surface.',
      'A point charge of +3.00 nC sits at the center of an imaginary Gaussian sphere of radius R. A second point charge of +7.00 nC is then placed outside the sphere, at a distance 2R from the center.',
      '{"modules":["unit-8-electric-charges-fields-and-gauss-s-law","practice-2"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-translation","difficulty":"Medium","content_key":"apphycem-frq-048","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the total electric flux through the Gaussian sphere before the second charge is added, and state what happens to that total flux after the second charge is placed outside the sphere.

(b) Explain, using Gauss''s law, why the external charge does not change the total flux through the sphere even though it changes the electric field at points on the sphere''s surface.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('0028130c-74ee-49fa-aa1a-c46393309760'::uuid, '6e70379e-3033-4164-a855-b6d286c10630'::uuid, 'a-flux', 'Calculates the flux from the enclosed charge alone as approximately 339 N*m^2/C.', 1, 'Phi = q_enc/epsilon0 = (3.00e-9)/(8.85e-12) is approximately 339 N*m^2/C', 'Apply Phi=q_enc/epsilon0 using only the enclosed +3.00 nC charge.', '[]'::jsonb),
      ('03531efb-039d-49fb-afd9-3e6db958fd0f'::uuid, '6e70379e-3033-4164-a855-b6d286c10630'::uuid, 'a-prediction', 'States that the total flux through the sphere is unchanged after the external charge is added.', 1, 'Explicitly states flux remains approximately 339 N*m^2/C', 'State that the total flux depends only on enclosed charge, so it stays the same.', '[]'::jsonb),
      ('af7cdc21-1619-4661-a897-19ba439af5d1'::uuid, '6e70379e-3033-4164-a855-b6d286c10630'::uuid, 'b-explanation', 'Explains that Gauss''s law depends only on enclosed charge; the external charge''s field lines enter and exit the closed surface an equal number of times, contributing zero net flux even though it locally alters the field.', 1, 'References field lines from external charge entering and exiting the surface, netting to zero flux', 'Explain that any field line from an external charge that enters the Gaussian surface must also exit it, so its net contribution to flux is zero, even though it changes the field magnitude/direction at each point.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-049'
      and id <> 'b271425b-81e7-4470-a193-6cfc766546cb'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-049';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'b271425b-81e7-4470-a193-6cfc766546cb'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'b271425b-81e7-4470-a193-6cfc766546cb'::uuid,
      v_epv_id,
      'apphycem-frq-049',
      'frq',
      'apphycem-frq-049',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '36bd0295-f15c-408f-a821-f503a43ff382'::uuid,
      'b271425b-81e7-4470-a193-6cfc766546cb'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using Gauss''s law, derive an expression for the electric field magnitude E(r) for r < R, showing the integral used to find the enclosed charge.

(b) Evaluate E(r) at r = R/2 for the given numeric values.',
      'A solid sphere of radius R = 0.300 m has non-uniform volume charge density rho(r) = rho0(r/R) for r <= R and zero outside, with rho0 = 6.00 x 10^-6 C/m^3.',
      '{"modules":["unit-8-electric-charges-fields-and-gauss-s-law","practice-3"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-math","difficulty":"Hard","content_key":"apphycem-frq-049","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using Gauss''s law, derive an expression for the electric field magnitude E(r) for r < R, showing the integral used to find the enclosed charge.

(b) Evaluate E(r) at r = R/2 for the given numeric values.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('411beeb0-d45d-4581-adc6-0464af7f4dfc'::uuid, '36bd0295-f15c-408f-a821-f503a43ff382'::uuid, 'a-gaussian-surface', 'Selects a concentric spherical Gaussian surface of radius r < R and states Gauss''s law Phi_E = Q_enc/epsilon0.', 1, 'Writes E(4*pi*r^2) = Q_enc/epsilon0', 'State Gauss''s law with a spherical Gaussian surface of radius r and flux E*4*pi*r^2.', '[]'::jsonb),
      ('80330618-ca06-4cef-a2a9-a25cf9f8be99'::uuid, '36bd0295-f15c-408f-a821-f503a43ff382'::uuid, 'a-enclosed-integral', 'Sets up the enclosed charge integral Q_enc = integral of rho0(r''/R)*4*pi*r''^2 dr'' from 0 to r.', 1, 'Correctly writes dQ = rho(r'')*4*pi*r''^2 dr'' with rho(r'')=rho0*r''/R', 'Write dQ_enc = rho(r'')*(4*pi*r''^2) dr'' and integrate from 0 to r.', '[]'::jsonb),
      ('aefe93b6-f120-419b-a74f-44c6d153f0ca'::uuid, '36bd0295-f15c-408f-a821-f503a43ff382'::uuid, 'a-integral-evaluation', 'Evaluates the integral to obtain Q_enc(r) = pi*rho0*r^4/R.', 1, 'Integral of r''^3 dr'' from 0 to r is r^4/4, giving Q_enc = 4*pi*rho0/R * (r^4/4) = pi*rho0*r^4/R', 'Integrate r''^3 dr'' to get r^4/4 and simplify the constants.', '[]'::jsonb),
      ('d586d4bf-3ab1-455f-a641-cfcc909c474a'::uuid, '36bd0295-f15c-408f-a821-f503a43ff382'::uuid, 'a-field-expression', 'Solves for E(r) = rho0*r^2/(4*epsilon0*R).', 1, 'Divides Q_enc by (4*pi*r^2*epsilon0) and simplifies', 'Divide Q_enc(r) by 4*pi*epsilon0*r^2 and simplify to E(r) = rho0*r^2/(4*epsilon0*R).', '[]'::jsonb),
      ('f27a6958-4c2e-44aa-a441-ab6d6f97dee2'::uuid, '36bd0295-f15c-408f-a821-f503a43ff382'::uuid, 'b-numeric', 'Evaluates E at r=R/2 as approximately 1.27 x 10^4 N/C.', 1, 'E(0.150 m) = rho0*R/(16*epsilon0) is approximately 1.27e4 N/C', 'Substitute r=R/2=0.150 m, rho0=6.00e-6 C/m^3, R=0.300 m into the derived expression.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-050'
      and id <> 'b05eeeb8-81af-415e-a023-c655c515f5c9'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-050';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'b05eeeb8-81af-415e-a023-c655c515f5c9'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'b05eeeb8-81af-415e-a023-c655c515f5c9'::uuid,
      v_epv_id,
      'apphycem-frq-050',
      'frq',
      'apphycem-frq-050',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'ff87ac9b-bbcd-4b8f-a10c-2e9a75000b33'::uuid,
      'b05eeeb8-81af-415e-a023-c655c515f5c9'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using the integral definition of the field from the ring, derive the on-axis field expression E(z) = kQz/(z^2+a^2)^(3/2), and evaluate E at z = 0.150 m.

(b) Predict, and justify using the derived expression, whether E(z) at this fixed z increases or decreases if the ring''s radius is doubled to 0.200 m while Q is held fixed.',
      'A uniformly charged ring of radius a = 0.100 m carries total charge Q = 5.00 nC. Its on-axis field at distance z from the center is produced by integrating the contributions of each charge element around the ring.',
      '{"modules":["unit-8-electric-charges-fields-and-gauss-s-law","practice-4"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-translation","difficulty":"Hard","content_key":"apphycem-frq-050","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using the integral definition of the field from the ring, derive the on-axis field expression E(z) = kQz/(z^2+a^2)^(3/2), and evaluate E at z = 0.150 m.

(b) Predict, and justify using the derived expression, whether E(z) at this fixed z increases or decreases if the ring''s radius is doubled to 0.200 m while Q is held fixed.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('31d72658-e3d9-43ad-a657-906c584cb27f'::uuid, 'ff87ac9b-bbcd-4b8f-a10c-2e9a75000b33'::uuid, 'a-integral-setup', 'Sets up dE_z = k*dq*z/(z^2+a^2)^(3/2) for a charge element dq on the ring, noting only the axial components survive by symmetry.', 1, 'Writes the z-component of the field from dq and notes perpendicular components cancel by symmetry', 'Write dE_z = k dq z/(z^2+a^2)^(3/2) and argue that the radial components cancel by symmetry around the ring.', '[]'::jsonb),
      ('d8f7d2b8-10f0-4729-a878-eb7125194b84'::uuid, 'ff87ac9b-bbcd-4b8f-a10c-2e9a75000b33'::uuid, 'a-derivation', 'Integrates dq around the ring (total dq = Q) to obtain E(z) = kQz/(z^2+a^2)^(3/2).', 1, 'Since z and a are constant around the ring, the integral of dq is simply Q', 'Pull the constant factor z/(z^2+a^2)^(3/2) out of the integral and integrate dq around the ring to get Q.', '[]'::jsonb),
      ('d437bbeb-f2f8-4df9-a7a2-f50b934dce4e'::uuid, 'ff87ac9b-bbcd-4b8f-a10c-2e9a75000b33'::uuid, 'a-numeric', 'Evaluates E at z=0.150 m (a=0.100 m) as approximately 1.15 x 10^3 N/C.', 1, 'E = (8.99e9)(5.00e-9)(0.150)/(0.0325)^1.5 is approximately 1.15e3 N/C', 'Substitute z=0.150 m, a=0.100 m, Q=5.00 nC into the derived expression.', '[]'::jsonb),
      ('a362a5fa-a9ce-4ed0-a78a-ae3cc3c06ff9'::uuid, 'ff87ac9b-bbcd-4b8f-a10c-2e9a75000b33'::uuid, 'b-prediction', 'Predicts that E(z) decreases when the ring radius is doubled to 0.200 m at fixed z.', 1, 'New field is approximately 4.32 x 10^2 N/C, less than the original 1.15e3 N/C', 'Recompute E with a=0.200 m and compare to the original value.', '[]'::jsonb),
      ('d8dfd87e-ffd2-4f60-a836-036d54d338ca'::uuid, 'ff87ac9b-bbcd-4b8f-a10c-2e9a75000b33'::uuid, 'b-justification', 'Justifies the decrease by noting the denominator (z^2+a^2)^(3/2) grows faster than the numerator as a increases, reducing E.', 1, 'References the denominator increasing disproportionately with a', 'Explain that increasing a increases (z^2+a^2)^(3/2) more than it affects the numerator, so E decreases.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-051'
      and id <> '67e76fc9-4f4d-464c-a15f-0b53e785d820'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-051';
  end if;

  if not exists (
    select 1 from app.content_items where id = '67e76fc9-4f4d-464c-a15f-0b53e785d820'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '67e76fc9-4f4d-464c-a15f-0b53e785d820'::uuid,
      v_epv_id,
      'apphycem-frq-051',
      'frq',
      'apphycem-frq-051',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '47ee5fb8-949f-4ae8-aba1-ab5999ab7945'::uuid,
      '67e76fc9-4f4d-464c-a15f-0b53e785d820'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using integration, derive an expression for the electric potential at point P, and evaluate it numerically.

(b) State the linear charge density used in the derivation.',
      'A thin rod of length L = 0.800 m and total charge Q = 8.00 nC, uniformly charged, lies along the x-axis centered at the origin. Point P is on the perpendicular bisector of the rod at distance y = 0.300 m.',
      '{"modules":["unit-9-electric-potential","practice-1"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-math","difficulty":"Hard","content_key":"apphycem-frq-051","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using integration, derive an expression for the electric potential at point P, and evaluate it numerically.

(b) State the linear charge density used in the derivation.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('228aeada-7803-4973-afb6-9d85708981b4'::uuid, '47ee5fb8-949f-4ae8-aba1-ab5999ab7945'::uuid, 'a-lambda', 'Computes the linear charge density lambda = Q/L = 1.00 x 10^-8 C/m.', 1, 'lambda = 8.00e-9/0.800 = 1.00e-8 C/m', 'Divide total charge Q by rod length L to get lambda.', '[]'::jsonb),
      ('2e19a4ac-e500-4d51-a875-14ee45f3f008'::uuid, '47ee5fb8-949f-4ae8-aba1-ab5999ab7945'::uuid, 'a-setup', 'Sets up the potential integral dV = k*lambda*dx/sqrt(x^2+y^2) with limits from -L/2 to L/2.', 1, 'Correct geometry with distance sqrt(x^2+y^2) from element to P', 'Write dV=k*lambda*dx/sqrt(x^2+y^2) with x ranging from -L/2 to L/2.', '[]'::jsonb),
      ('ec2d0604-d7df-493a-a134-c3ce2c9aa5ca'::uuid, '47ee5fb8-949f-4ae8-aba1-ab5999ab7945'::uuid, 'a-integration', 'Evaluates the integral using the antiderivative involving an inverse hyperbolic sine (or equivalent logarithmic form).', 1, 'Integral of dx/sqrt(x^2+y^2) is sinh^-1(x/y) or ln(x+sqrt(x^2+y^2)), evaluated at the limits', 'Use the antiderivative sinh^-1(x/y) (or the equivalent log form) and evaluate at x=+L/2 and x=-L/2.', '[]'::jsonb),
      ('840af20b-364b-4df4-a0ef-6945b1b14598'::uuid, '47ee5fb8-949f-4ae8-aba1-ab5999ab7945'::uuid, 'a-final-expression', 'Uses symmetry to combine the limits into V = 2*k*lambda*sinh^-1(L/(2y)).', 1, 'Combines the symmetric contributions from -L/2 to L/2 into twice the 0-to-L/2 integral', 'Use symmetry of the odd/even integrand to write V = 2*k*lambda*sinh^-1(L/(2y)).', '[]'::jsonb),
      ('525f6211-f799-4d7b-a8fe-78e9ccf618a4'::uuid, '47ee5fb8-949f-4ae8-aba1-ab5999ab7945'::uuid, 'b-numeric', 'Evaluates V numerically as approximately 198 V.', 1, 'V = 2(8.99e9)(1.00e-8)*sinh^-1(1.333) is approximately 198 V', 'Substitute lambda=1.00e-8 C/m, L=0.800 m, y=0.300 m into the derived expression.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-052'
      and id <> 'f9cfd839-09d7-40e8-ab9b-c06c6e780d66'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-052';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'f9cfd839-09d7-40e8-ab9b-c06c6e780d66'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'f9cfd839-09d7-40e8-ab9b-c06c6e780d66'::uuid,
      v_epv_id,
      'apphycem-frq-052',
      'frq',
      'apphycem-frq-052',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'be5b29af-a334-42c3-ae00-f8472225ec59'::uuid,
      'f9cfd839-09d7-40e8-ab9b-c06c6e780d66'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a procedure to map the equipotential lines, identifying the independent variable, the dependent variable, and one control quantity held fixed.

(b) Explain how the resulting equipotential map can be used to determine the direction and relative magnitude of the electric field near the conductor.',
      'A student uses a movable voltmeter probe and a fixed reference electrode to map equipotential lines in a conductive gel tray surrounding an irregularly shaped charged conductor held at a fixed applied voltage.',
      '{"modules":["unit-9-electric-potential","practice-2"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-experimental","difficulty":"Hard","content_key":"apphycem-frq-052","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a procedure to map the equipotential lines, identifying the independent variable, the dependent variable, and one control quantity held fixed.

(b) Explain how the resulting equipotential map can be used to determine the direction and relative magnitude of the electric field near the conductor.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('1f8cf806-4662-492d-a7ff-046c53cd4b45'::uuid, 'be5b29af-a334-42c3-ae00-f8472225ec59'::uuid, 'a-independent', 'Identifies the probe''s position (coordinates) in the tray as the independent variable.', 1, 'States that probe location is systematically varied to trace out points of equal potential', 'State that the probe is moved to different positions, and its coordinates are recorded.', '[]'::jsonb),
      ('6717f9a2-99ea-4641-a530-5598c2e09330'::uuid, 'be5b29af-a334-42c3-ae00-f8472225ec59'::uuid, 'a-dependent', 'Identifies the measured voltage (potential difference relative to the fixed reference) as the dependent variable.', 1, 'States that voltmeter reading is recorded at each probe position', 'State that the voltmeter reading at each position is the measured quantity.', '[]'::jsonb),
      ('96ae57dc-6442-434c-a1c2-fe0ab4264b39'::uuid, 'be5b29af-a334-42c3-ae00-f8472225ec59'::uuid, 'a-control', 'Identifies the applied voltage on the conductor (or the fixed reference electrode position) as a control held constant.', 1, 'Names the source voltage or reference point as fixed throughout mapping', 'State that the voltage applied to the conductor is held constant throughout the mapping.', '[]'::jsonb),
      ('a9518028-8a4b-4c40-ac12-f94c739be2f7'::uuid, 'be5b29af-a334-42c3-ae00-f8472225ec59'::uuid, 'b-analysis', 'Explains that field lines are perpendicular to equipotential lines and point from higher to lower potential, with closer-spaced equipotentials indicating a larger field magnitude.', 1, 'References perpendicularity, direction of decreasing potential, and spacing-magnitude relationship', 'State that E is perpendicular to equipotential lines, points toward lower potential, and its magnitude is larger where equipotential lines are more closely spaced.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-053'
      and id <> '7a79eb3e-68d4-41ba-abed-9f00423d0aa7'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-053';
  end if;

  if not exists (
    select 1 from app.content_items where id = '7a79eb3e-68d4-41ba-abed-9f00423d0aa7'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '7a79eb3e-68d4-41ba-abed-9f00423d0aa7'::uuid,
      v_epv_id,
      'apphycem-frq-053',
      'frq',
      'apphycem-frq-053',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a7c8366f-efe2-4043-acd9-78b00913beb7'::uuid,
      '7a79eb3e-68d4-41ba-abed-9f00423d0aa7'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using U = integral of (q/C) dq, derive the energy stored on the capacitor once fully charged, and evaluate it numerically.

(b) Calculate the total energy delivered by the battery during the charging process, and explain why it is not equal to the energy stored on the capacitor.',
      'A capacitor with capacitance C = 2.00 microF is charged from zero charge to its final charge by a 9.00 V battery through a resistor.',
      '{"modules":["unit-10-conductors-and-capacitors","practice-3"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-math","difficulty":"Hard","content_key":"apphycem-frq-053","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using U = integral of (q/C) dq, derive the energy stored on the capacitor once fully charged, and evaluate it numerically.

(b) Calculate the total energy delivered by the battery during the charging process, and explain why it is not equal to the energy stored on the capacitor.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('69719a94-8c6d-472f-a5ca-7875265e7a69'::uuid, 'a7c8366f-efe2-4043-acd9-78b00913beb7'::uuid, 'a-charge', 'Calculates the final charge Qf = C*(EMF) = 18.0 microC.', 1, 'Qf = (2.00e-6)(9.00) = 1.80e-5 C', 'Apply Qf=C*EMF using the given capacitance and battery EMF.', '[]'::jsonb),
      ('656b9554-985d-4a31-a462-6c3ced5a24a2'::uuid, 'a7c8366f-efe2-4043-acd9-78b00913beb7'::uuid, 'a-integral-setup', 'Sets up U = integral of (q/C) dq from 0 to Qf.', 1, 'Correctly writes the incremental work dU=(q/C)dq to move charge dq onto the capacitor against its current voltage q/C', 'Write dU = V(q) dq = (q/C) dq and integrate from 0 to Qf.', '[]'::jsonb),
      ('892b89d6-1d1b-4ad1-ad66-312067268219'::uuid, 'a7c8366f-efe2-4043-acd9-78b00913beb7'::uuid, 'a-integral-evaluation', 'Evaluates the integral to U = Qf^2/(2C), approximately 81.0 microJ.', 1, 'Qf^2/(2C) = (1.80e-5)^2/(2*2.00e-6) is approximately 8.10e-5 J', 'Integrate (q/C)dq to Qf^2/(2C) and substitute numeric values.', '[]'::jsonb),
      ('ec7ce810-2dd0-49bd-ae3d-7b9271e4475b'::uuid, 'a7c8366f-efe2-4043-acd9-78b00913beb7'::uuid, 'b-battery-energy', 'Calculates the total energy delivered by the battery as W = EMF*Qf, approximately 162 microJ.', 1, 'W = (9.00)(1.80e-5) is approximately 1.62e-4 J', 'Apply W=EMF*Qf using the battery voltage and final charge.', '[]'::jsonb),
      ('2a51106d-a37e-4ca9-abac-03fa7f6579c0'::uuid, 'a7c8366f-efe2-4043-acd9-78b00913beb7'::uuid, 'b-explanation', 'Explains that the difference between the battery''s energy output and the stored energy (approximately 81.0 microJ) is dissipated as heat in the resistor during charging.', 1, 'States that exactly half the delivered energy is lost to resistive heating regardless of the resistance value', 'Explain that the missing energy (W minus U_stored) is dissipated as I^2R heating in the resistor during the charging transient.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-054'
      and id <> 'd13ac7dc-874a-4581-af5b-1b90cd94b042'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-054';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'd13ac7dc-874a-4581-af5b-1b90cd94b042'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'd13ac7dc-874a-4581-af5b-1b90cd94b042'::uuid,
      v_epv_id,
      'apphycem-frq-054',
      'frq',
      'apphycem-frq-054',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '7efa1f75-8db0-4cb3-a040-9d27c7c3e18a'::uuid,
      'd13ac7dc-874a-4581-af5b-1b90cd94b042'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the final charge on each sphere after they are disconnected, and the common final potential of the spheres.

(b) Explain, in terms of the electric field inside a conductor in electrostatic equilibrium, why charge redistributes until both spheres reach the same potential.',
      'An isolated conducting sphere of radius r1 = 0.100 m carries charge Q1 = 6.00 nC, and a second isolated conducting sphere of radius r2 = 0.200 m carries charge Q2 = 2.00 nC. The spheres are connected briefly by a thin conducting wire, far apart from each other, then disconnected.',
      '{"modules":["unit-10-conductors-and-capacitors","practice-4"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-representation","difficulty":"Hard","content_key":"apphycem-frq-054","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the final charge on each sphere after they are disconnected, and the common final potential of the spheres.

(b) Explain, in terms of the electric field inside a conductor in electrostatic equilibrium, why charge redistributes until both spheres reach the same potential.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('0064cca5-fd54-4857-afbe-e865ca9d1e3a'::uuid, '7efa1f75-8db0-4cb3-a040-9d27c7c3e18a'::uuid, 'a-charge1', 'Calculates the final charge on the r1 sphere as approximately 2.67 nC, using Q1'' proportional to r1/(r1+r2) times total charge.', 1, 'Q1'' = 8.00 nC * (0.100/0.300) is approximately 2.67 nC', 'Set V1=V2 (kQ1''/r1 = kQ2''/r2) with Q1''+Q2''=8.00 nC and solve for Q1''.', '[]'::jsonb),
      ('0e7a371c-6682-42c7-ad82-7afb934a4251'::uuid, '7efa1f75-8db0-4cb3-a040-9d27c7c3e18a'::uuid, 'a-charge2', 'Calculates the final charge on the r2 sphere as approximately 5.33 nC.', 1, 'Q2'' = 8.00 nC * (0.200/0.300) is approximately 5.33 nC', 'Use Q2'' = total charge minus Q1'', or the analogous proportional formula with r2.', '[]'::jsonb),
      ('eab8d2a2-5765-46c6-aef6-4112e67c7722'::uuid, '7efa1f75-8db0-4cb3-a040-9d27c7c3e18a'::uuid, 'a-potential', 'Calculates the common final potential as approximately 240 V.', 1, 'V = kQ1''/r1 = kQ2''/r2 is approximately 240 V for both spheres', 'Substitute either final charge and its sphere''s radius into V=kQ/r.', '[]'::jsonb),
      ('197ef53a-3242-4e11-af0d-1064be0fe7f4'::uuid, '7efa1f75-8db0-4cb3-a040-9d27c7c3e18a'::uuid, 'b-explanation', 'Explains that E=0 inside a conductor in equilibrium, so charge flows through the connecting wire until the electric potential is equal everywhere on the connected conductors (no field remains to drive further charge flow).', 1, 'References zero field inside conductors in equilibrium and the resulting equal potential condition', 'Explain that charge continues to flow through the wire as long as a potential difference (and hence field) exists between the spheres, stopping only once both reach the same potential, consistent with E=0 inside conductors at equilibrium.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-055'
      and id <> '0b329939-d3b4-4235-a96a-2e310c7f4e37'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-055';
  end if;

  if not exists (
    select 1 from app.content_items where id = '0b329939-d3b4-4235-a96a-2e310c7f4e37'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '0b329939-d3b4-4235-a96a-2e310c7f4e37'::uuid,
      v_epv_id,
      'apphycem-frq-055',
      'frq',
      'apphycem-frq-055',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'd10afd52-f2c9-4d69-aa5b-59f7f73a63c4'::uuid,
      '0b329939-d3b4-4235-a96a-2e310c7f4e37'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a procedure to determine the dielectric constant, identifying the independent variable, the dependent variable, and one control held constant.

(b) Explain how the dielectric constant is computed from the measured charges with and without the dielectric present.',
      'A student wants to determine the dielectric constant of an unknown slab by inserting it fully between the plates of a parallel-plate capacitor connected to a battery that holds the voltage constant, using an electrometer to measure the charge on the plates before and after insertion.',
      '{"modules":["unit-10-conductors-and-capacitors","practice-1"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-experimental","difficulty":"Hard","content_key":"apphycem-frq-055","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a procedure to determine the dielectric constant, identifying the independent variable, the dependent variable, and one control held constant.

(b) Explain how the dielectric constant is computed from the measured charges with and without the dielectric present.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('298fa2b2-1d8c-4675-aaa4-89f193e53d1a'::uuid, 'd10afd52-f2c9-4d69-aa5b-59f7f73a63c4'::uuid, 'a-independent', 'Identifies whether the dielectric slab is present or absent as the independent variable.', 1, 'States that the presence/absence (or identity) of the inserted material is what is changed between trials', 'State that the material inserted between the plates (dielectric present or vacuum/air) is the varied condition.', '[]'::jsonb),
      ('01264724-b071-44c9-a7ad-ac2e55b8c7c2'::uuid, 'd10afd52-f2c9-4d69-aa5b-59f7f73a63c4'::uuid, 'a-dependent', 'Identifies the measured plate charge Q (at fixed voltage) as the dependent variable.', 1, 'States that charge is measured with the electrometer in each condition', 'State that the charge on the plates, read from the electrometer, is measured in each condition.', '[]'::jsonb),
      ('6673f96b-8d24-48f4-a97f-1a0fd2cd665f'::uuid, 'd10afd52-f2c9-4d69-aa5b-59f7f73a63c4'::uuid, 'a-control', 'Identifies the battery voltage and plate geometry (area, separation) as controls held constant.', 1, 'Names voltage and/or geometry as fixed across both measurements', 'State that the applied voltage and the plate area/separation are kept the same in both trials.', '[]'::jsonb),
      ('f94e46c6-e0cd-4bc2-a015-57581c79e6dc'::uuid, 'd10afd52-f2c9-4d69-aa5b-59f7f73a63c4'::uuid, 'b-analysis', 'Explains that since C=kappa*C0 and Q=CV at fixed V, kappa = Q_with_dielectric / Q_without_dielectric.', 1, 'Derives kappa from the ratio of measured charges at constant voltage', 'Use Q=CV with V fixed to show that the ratio of charges equals the ratio of capacitances, which equals kappa.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-056'
      and id <> 'ce183d2c-e8a8-4b15-af55-ab3b4fd25299'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-056';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'ce183d2c-e8a8-4b15-af55-ab3b4fd25299'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'ce183d2c-e8a8-4b15-af55-ab3b4fd25299'::uuid,
      v_epv_id,
      'apphycem-frq-056',
      'frq',
      'apphycem-frq-056',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid,
      'ce183d2c-e8a8-4b15-af55-ab3b4fd25299'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using Gauss''s law, derive an expression for the electric field magnitude E(r) for r < R, showing the enclosed-charge integral.

(b) Derive an expression for E(r) for r > R.

(c) Evaluate E(r) at r = R/2 and at r = 2R.',
      'A solid sphere of radius R = 0.250 m has non-uniform volume charge density rho(r) = rho0(1 - r/R) for r <= R and zero outside, with rho0 = 6.00 x 10^-6 C/m^3.',
      '{"modules":["unit-8-electric-charges-fields-and-gauss-s-law","practice-2"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-math","difficulty":"Very Hard","content_key":"apphycem-frq-056","total_points":7}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using Gauss''s law, derive an expression for the electric field magnitude E(r) for r < R, showing the enclosed-charge integral.

(b) Derive an expression for E(r) for r > R.

(c) Evaluate E(r) at r = R/2 and at r = 2R.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('07ad4e2c-2def-438e-a197-c82aef199b80'::uuid, '4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid, 'a-gaussian-setup', 'Selects a spherical Gaussian surface of radius r < R and states Phi_E = Q_enc/epsilon0.', 1, 'Writes E(4*pi*r^2) = Q_enc/epsilon0', 'State Gauss''s law with a spherical Gaussian surface of radius r < R.', '[]'::jsonb),
      ('108f26f9-2e04-4842-a8fe-7d830931d063'::uuid, '4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid, 'a-enclosed-integral', 'Sets up and evaluates Q_enc(r) = integral of rho0(1-r''/R)*4*pi*r''^2 dr'' from 0 to r, obtaining 4*pi*rho0[r^3/3 - r^4/(4R)].', 1, 'Integrates r''^2 and r''^3/R terms separately over 0 to r', 'Expand rho(r'')*4*pi*r''^2 = 4*pi*rho0(r''^2 - r''^3/R) and integrate term by term from 0 to r.', '[]'::jsonb),
      ('e54e8ad5-ccb8-4d1f-a0c3-ca651e6c4352'::uuid, '4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid, 'a-field-expression', 'Solves for E(r) = (rho0/epsilon0)*(r/3 - r^2/(4R)) for r < R.', 1, 'Divides Q_enc(r) by 4*pi*epsilon0*r^2 and simplifies', 'Divide the enclosed charge expression by 4*pi*epsilon0*r^2 and simplify.', '[]'::jsonb),
      ('e4aea2d6-55e1-4768-a568-49812282974f'::uuid, '4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid, 'b-total-charge', 'Computes the total charge on the sphere Q_total = Q_enc(R) = pi*rho0*R^3/3.', 1, 'Substitutes r=R into the enclosed charge expression and simplifies (R^3/3 - R^3/4 = R^3/12)', 'Evaluate the enclosed-charge expression at r=R to find the total charge.', '[]'::jsonb),
      ('d67ef502-8dee-4bc4-a1ac-e515ba49417b'::uuid, '4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid, 'b-field-expression', 'Derives E(r) = rho0*R^3/(12*epsilon0*r^2) for r > R.', 1, 'Applies E=Q_total/(4*pi*epsilon0*r^2) with the total charge from part (b)', 'Apply Gauss''s law outside the sphere using the total enclosed charge found in part (b).', '[]'::jsonb),
      ('de2558aa-a1f6-4669-a34d-c3f99f251725'::uuid, '4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid, 'c-numeric-inside', 'Evaluates E at r=R/2 as approximately 1.77 x 10^4 N/C.', 1, 'E(0.125 m) = (rho0/epsilon0)(0.125/3 - 0.015625/1.00) is approximately 1.77e4 N/C', 'Substitute r=R/2=0.125 m into the inside-field expression from part (a).', '[]'::jsonb),
      ('1d2042c4-da19-4e36-ad6e-74d246e45a68'::uuid, '4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid, 'c-numeric-outside', 'Evaluates E at r=2R as approximately 3.53 x 10^3 N/C.', 1, 'E(0.500 m) = rho0*R^3/(12*epsilon0*(0.500)^2) is approximately 3.53e3 N/C', 'Substitute r=2R=0.500 m into the outside-field expression from part (b).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-057'
      and id <> '36040213-840a-4e08-ae1e-6617c66410b9'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-057';
  end if;

  if not exists (
    select 1 from app.content_items where id = '36040213-840a-4e08-ae1e-6617c66410b9'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '36040213-840a-4e08-ae1e-6617c66410b9'::uuid,
      v_epv_id,
      'apphycem-frq-057',
      'frq',
      'apphycem-frq-057',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '5563378f-365a-45c1-a20e-3247a582a45d'::uuid,
      '36040213-840a-4e08-ae1e-6617c66410b9'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using E(r)=kQ/r^2 between the shells and V = integral of E dr, derive an expression for the capacitance of this configuration.

(b) Evaluate the capacitance and the energy stored numerically.

(c) Using U = integral of (q/C) dq, confirm that this integral yields the same stored energy found in part (b).',
      'A spherical capacitor consists of an inner conducting sphere of radius a = 0.0400 m carrying charge Q = 4.00 nC and a concentric outer conducting shell of radius b = 0.0800 m carrying charge -Q.',
      '{"modules":["unit-10-conductors-and-capacitors","practice-3"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-math","difficulty":"Very Hard","content_key":"apphycem-frq-057","total_points":7}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using E(r)=kQ/r^2 between the shells and V = integral of E dr, derive an expression for the capacitance of this configuration.

(b) Evaluate the capacitance and the energy stored numerically.

(c) Using U = integral of (q/C) dq, confirm that this integral yields the same stored energy found in part (b).'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('3d847209-0247-4cf5-a606-21a150c93bfd'::uuid, '5563378f-365a-45c1-a20e-3247a582a45d'::uuid, 'a-field', 'States the field between the shells as E(r) = kQ/r^2, from Gauss''s law applied to the region a < r < b.', 1, 'Applies Gauss''s law with a concentric Gaussian sphere of radius r between a and b', 'Apply Gauss''s law with a spherical surface of radius r (a<r<b) enclosing only the inner charge Q.', '[]'::jsonb),
      ('531507b8-aeac-4c88-abb4-c646b512446b'::uuid, '5563378f-365a-45c1-a20e-3247a582a45d'::uuid, 'a-integral', 'Integrates to find V = integral of E dr from a to b = kQ(1/a - 1/b).', 1, 'Integral of kQ/r^2 dr from a to b gives kQ(1/a-1/b)', 'Integrate E(r)=kQ/r^2 from r=a to r=b.', '[]'::jsonb),
      ('b3d66664-d7ec-4f07-aa7d-5254ab220f43'::uuid, '5563378f-365a-45c1-a20e-3247a582a45d'::uuid, 'a-capacitance-expression', 'Derives C = Q/V = 4*pi*epsilon0*a*b/(b-a) (equivalently ab/[k(b-a)]).', 1, 'Divides Q by the derived V and simplifies using k=1/(4*pi*epsilon0)', 'Divide Q by the expression for V from part (a) and simplify.', '[]'::jsonb),
      ('efa3453d-7538-4b2c-a21d-8a40eddf9e35'::uuid, '5563378f-365a-45c1-a20e-3247a582a45d'::uuid, 'b-numeric-C', 'Evaluates the capacitance numerically as approximately 8.90 pF.', 1, 'C = 4*pi*epsilon0*(0.0400)(0.0800)/(0.0400) is approximately 8.90e-12 F', 'Substitute a=0.0400 m, b=0.0800 m into the derived capacitance expression.', '[]'::jsonb),
      ('60848006-da96-4737-a376-906d558ed683'::uuid, '5563378f-365a-45c1-a20e-3247a582a45d'::uuid, 'b-numeric-U', 'Evaluates the stored energy as U=Q^2/(2C), approximately 0.899 microJ.', 1, 'U = (4.00e-9)^2/(2*8.90e-12) is approximately 8.99e-7 J', 'Apply U=Q^2/(2C) using the numeric capacitance found above.', '[]'::jsonb),
      ('185b596d-10cf-4cf6-a786-710694d427d3'::uuid, '5563378f-365a-45c1-a20e-3247a582a45d'::uuid, 'c-integral-setup', 'Sets up U = integral of (q/C) dq from 0 to Q.', 1, 'Writes the incremental work dU=(q/C)dq to add charge dq to the capacitor', 'Write dU=(q/C)dq and integrate q from 0 to Q, treating C as constant.', '[]'::jsonb),
      ('ae1fa668-43fb-4d7d-a930-b8793bf3d6ef'::uuid, '5563378f-365a-45c1-a20e-3247a582a45d'::uuid, 'c-integral-evaluation', 'Evaluates the integral to Q^2/(2C) and confirms it matches the numeric value found in part (b).', 1, 'Integral of (q/C)dq from 0 to Q equals Q^2/(2C), the same as part (b)''s result', 'Integrate to Q^2/(2C) and compare directly to the value computed in part (b).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycem-frq-058'
      and id <> '7269480c-4476-4ae9-a180-a5f815ad4027'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-058';
  end if;

  if not exists (
    select 1 from app.content_items where id = '7269480c-4476-4ae9-a180-a5f815ad4027'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '7269480c-4476-4ae9-a180-a5f815ad4027'::uuid,
      v_epv_id,
      'apphycem-frq-058',
      'frq',
      'apphycem-frq-058',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-em-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '08c74de6-a2f7-4285-a516-00ecb9cd6129'::uuid,
      '7269480c-4476-4ae9-a180-a5f815ad4027'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using integration over concentric ring elements, derive an expression for the electric potential V(z) on the axis, and evaluate it numerically.

(b) Differentiate V(z) to obtain the on-axis field E(z) = -dV/dz, evaluate it numerically, and state the direction of the field at P.',
      'A uniformly charged disk of radius R = 0.100 m has surface charge density sigma = 5.00 x 10^-6 C/m^2. Point P lies on the disk''s central axis at distance z = 0.150 m from its center.',
      '{"modules":["unit-9-electric-potential","practice-4"],"subject":"ap_physics_c_em","frq_type":"short","archetype":"ap-physics-c-em-frq-math","difficulty":"Very Hard","content_key":"apphycem-frq-058","total_points":6}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using integration over concentric ring elements, derive an expression for the electric potential V(z) on the axis, and evaluate it numerically.

(b) Differentiate V(z) to obtain the on-axis field E(z) = -dV/dz, evaluate it numerically, and state the direction of the field at P.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('f00eb151-d889-4210-af97-4dfa72366231'::uuid, '08c74de6-a2f7-4285-a516-00ecb9cd6129'::uuid, 'a-setup', 'Sets up dV = k*dq/sqrt(s^2+z^2) with a ring element dq = sigma*2*pi*s*ds at radius s.', 1, 'Correctly expresses the ring''s charge and its distance to point P', 'Write dq=sigma*2*pi*s*ds and dV=k*dq/sqrt(s^2+z^2), integrating s from 0 to R.', '[]'::jsonb),
      ('c49b7417-9f47-49aa-a55e-f2fb22d6d8be'::uuid, '08c74de6-a2f7-4285-a516-00ecb9cd6129'::uuid, 'a-integration', 'Evaluates the integral to V(z) = (sigma/(2*epsilon0))*(sqrt(R^2+z^2) - z).', 1, 'Integral of s ds/sqrt(s^2+z^2) from 0 to R gives sqrt(R^2+z^2)-z, combined with k*sigma*2*pi = sigma/(2*epsilon0)', 'Integrate s/sqrt(s^2+z^2) ds from 0 to R using the substitution u=s^2+z^2, then multiply by sigma/(2*epsilon0).', '[]'::jsonb),
      ('f5b76136-387c-4026-a486-f636afea5371'::uuid, '08c74de6-a2f7-4285-a516-00ecb9cd6129'::uuid, 'a-numeric', 'Evaluates V(z) at z=0.150 m as approximately 8.55 x 10^3 V.', 1, 'V = (5.00e-6/(2*8.85e-12))*(sqrt(0.0325)-0.150) is approximately 8.55e3 V', 'Substitute sigma=5.00e-6 C/m^2, R=0.100 m, z=0.150 m into the derived expression.', '[]'::jsonb),
      ('f1549489-d3e9-44d5-a1a8-aa1c1e8e04d1'::uuid, '08c74de6-a2f7-4285-a516-00ecb9cd6129'::uuid, 'b-differentiation', 'Differentiates V(z) to obtain E(z) = (sigma/(2*epsilon0))*(1 - z/sqrt(R^2+z^2)).', 1, 'd/dz[sqrt(R^2+z^2)-z] = z/sqrt(R^2+z^2) - 1, and E=-dV/dz', 'Differentiate sqrt(R^2+z^2)-z with respect to z and negate to get E(z)=-dV/dz.', '[]'::jsonb),
      ('17cbfc22-7772-4af6-ae52-5167bb8ac947'::uuid, '08c74de6-a2f7-4285-a516-00ecb9cd6129'::uuid, 'b-numeric', 'Evaluates E(z) at z=0.150 m as approximately 4.74 x 10^3 N/C.', 1, 'E = (5.00e-6/(2*8.85e-12))*(1 - 0.150/0.180278) is approximately 4.74e3 N/C', 'Substitute the same numeric values into the derived field expression.', '[]'::jsonb),
      ('7afff57b-5f58-4b55-a4a5-2a8068eeb881'::uuid, '08c74de6-a2f7-4285-a516-00ecb9cd6129'::uuid, 'b-direction', 'States that the field at P points along the axis away from the disk (in the +z direction), consistent with the disk''s positive charge.', 1, 'Notes the field direction is away from a positively charged disk, along the axis', 'State that since the disk is positively charged, the on-axis field points away from the disk, in the +z direction at P.', '[]'::jsonb);
  end if;
end
$physics_units1_3$;
commit;
