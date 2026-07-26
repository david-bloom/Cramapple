begin;
do $physics_full_scale$
declare
  v_max integer;
begin

  select coalesce(max((regexp_match(content_key, '([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^apphycm-frq-[0-9]+$';
  if v_max not between 34 and 38 then
    raise exception 'unexpected_live_max:apphycm:%', v_max;
  end if;

  select coalesce(max((regexp_match(content_key, '([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^apphycem-frq-[0-9]+$';
  if v_max not between 34 and 38 then
    raise exception 'unexpected_live_max:apphycem:%', v_max;
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid
      and content_key = 'apphycm-frq-035'
      and id <> '276dc33a-7c86-4a41-a5f7-a8987ff7351f'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-035';
  end if;

  if not exists (
    select 1 from app.content_items where id = '276dc33a-7c86-4a41-a5f7-a8987ff7351f'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '276dc33a-7c86-4a41-a5f7-a8987ff7351f'::uuid,
      'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,
      'apphycm-frq-035',
      'frq',
      'Motion in a quartic potential',
      'assigned',
      'long',
      'full_exam_frq',
      'Mathematical Routines'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, content_hash, status, review_status, rubric_type,
      evaluator_strategy
    ) values (
      '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid,
      '276dc33a-7c86-4a41-a5f7-a8987ff7351f'::uuid,
      1,
      'Motion in a quartic potential: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A particle of mass m moves along the x-axis in the potential U(x)=αx⁴/4-βx²/2, where α and β are positive constants. At t=0 the particle is released from rest at x=A, where A>sqrt(2β/α).',
      '{"content_key":"apphycm-frq-035","subject":"ap_physics_c_mechanics","unit":3,"topic":"Work, Energy, and Power","archetype":"Mathematical Routines","difficulty":"Hard","source_fact_pack_id":"1rc_z7A4CmhDx1Ya6zJswnKYm2wtOrLsJRK-7qBzDxG0","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Using calculus and conservation laws, determine the equilibrium positions and their stability, derive the particle''s speed as a function of position, and determine its maximum speed during the subsequent motion.","points":7,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1},{"criterion_key":"part-a-criterion-05","points":1},{"criterion_key":"part-a-criterion-06","points":1},{"criterion_key":"part-a-criterion-07","points":1}]},{"part_key":"part-b","prompt":"Determine whether the particle crosses x=0. If it does, derive its speed there; if it does not, identify the turning point that prevents crossing. Justify from the energy.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]}]}'::jsonb,
      'Equilibria occur where βx-αx³=0. The origin is an unstable maximum and x=±sqrt(β/α) are stable minima. Conservation gives v(x)=sqrt{2[U(A)-U(x)]/m}; maximum speed occurs at either minimum. The given A makes U(A)>0, so the particle crosses the central barrier.',
      md5('Motion in a quartic potential: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('8f02fe80-adf0-404c-ac50-e845429ab7dc'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-a-criterion-01', 'Calculates F(x)=-dU/dx=βx-αx³.', 1, 'The derivative and force sign are correct.', 'Differentiate U and apply F=-dU/dx.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('ceee319f-495a-4ba8-abdd-d4f1ee96c6bd'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-a-criterion-02', 'Solves F=0 to obtain x=0 and x=±sqrt(β/α).', 1, 'All equilibrium positions are included.', 'Factor x(β-αx²)=0.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('d5502031-a82f-4399-a7fb-6a9cee091604'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-a-criterion-03', 'Uses d²U/dx²=3αx²-β to classify x=0 as unstable.', 1, 'The second-derivative test is applied correctly at the origin.', 'A negative second derivative of U indicates a local maximum.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('6c875a5d-d7d2-4292-a25b-ec5d55e4c7f9'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-a-criterion-04', 'Classifies x=±sqrt(β/α) as stable minima.', 1, 'The second derivative is positive at both nonzero equilibria.', 'Evaluate 3αx²-β at x²=β/α.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('10d86b1c-a7d9-40f4-afda-4de42f9d0219'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-a-criterion-05', 'Writes (1/2)mv²+U(x)=U(A) from the release condition.', 1, 'Conservation of mechanical energy and the initial rest condition are used.', 'Set total energy equal to the initial potential energy.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('0b384b5e-9fd7-413c-a47e-ae0df1e7d665'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-a-criterion-06', 'Derives v(x)=sqrt{(2/m)[U(A)-U(x)]}.', 1, 'The speed expression is correctly isolated and applicable in allowed regions.', 'Solve the energy equation for the nonnegative speed.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('c6201e3e-05bb-4cfc-a3b5-bc0e1b1b4930'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-a-criterion-07', 'Identifies maximum speed at a potential minimum and gives v_max=sqrt{(2/m)[U(A)+β²/(4α)]}.', 1, 'The minimum potential U=-β²/(4α) is correctly used.', 'Evaluate U at x²=β/α and maximize K=E-U.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('860248b6-33bb-4cb3-abd7-5eb9ff327729'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-b-criterion-01', 'Evaluates U(0)=0 and U(A)=αA⁴/4-βA²/2.', 1, 'The barrier and total energy are compared explicitly.', 'Use the release energy and the potential at the origin.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('c3811c98-10d6-4c25-aee2-1af16a34bc77'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-b-criterion-02', 'Uses A>sqrt(2β/α) to show U(A)>0, so the particle crosses x=0.', 1, 'The given inequality is translated into the correct energy condition.', 'Factor U(A)=A²(αA²-2β)/4.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('7ca82422-0f43-48b3-a13d-ba19f330079b'::uuid, '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid, 'part-b-criterion-03', 'Obtains v(0)=sqrt{(2/m)U(A)}=sqrt{(αA⁴/2-βA²)/m}.', 1, 'The crossing speed follows correctly from conservation of energy.', 'Set U=0 in the speed expression and simplify.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      'b3c91b12-a4f5-408b-ab1c-b9e519502bd2'::uuid,
      '79b1dadd-22c3-42a4-a6c3-db8848d4f712'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid
      and content_key = 'apphycm-frq-036'
      and id <> 'b6bf19f2-f186-47e1-afc3-12de0555457e'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-036';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'b6bf19f2-f186-47e1-afc3-12de0555457e'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'b6bf19f2-f186-47e1-afc3-12de0555457e'::uuid,
      'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,
      'apphycm-frq-036',
      'frq',
      'Velocity-dependent drag representations',
      'assigned',
      'long',
      'full_exam_frq',
      'Translation Between Representations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, content_hash, status, review_status, rubric_type,
      evaluator_strategy
    ) values (
      'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid,
      'b6bf19f2-f186-47e1-afc3-12de0555457e'::uuid,
      1,
      'Velocity-dependent drag representations: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A small object of mass m is released from rest at t=0 and falls vertically through a fluid. Take downward as positive. The drag force has magnitude bv, where b is a positive constant and v is the downward velocity.',
      '{"content_key":"apphycm-frq-036","subject":"ap_physics_c_mechanics","unit":2,"topic":"Force and Translational Dynamics","archetype":"Translation Between Representations","difficulty":"Hard","source_fact_pack_id":"1rc_z7A4CmhDx1Ya6zJswnKYm2wtOrLsJRK-7qBzDxG0","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Draw a force diagram for the object after release and write the differential equation governing v(t). Identify the terminal speed.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Solve the differential equation for v(t) using v(0)=0. Then derive the acceleration a(t).","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Sketch v versus t and a versus t on separate labeled axes. Mark initial values, asymptotes, and concavity.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"A second object has the same mass but a larger drag coefficient. Compare its terminal speed and the initial slope of its velocity graph with those of the first object.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      'Newton''s law gives m dv/dt=mg-bv. With v(0)=0, v=(mg/b)(1-e^{-bt/m}) and a=g e^{-bt/m}. A larger b lowers terminal speed but does not change the initial acceleration.',
      md5('Velocity-dependent drag representations: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('8460f021-432c-4d46-ac9f-a5637f16d24d'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-a-criterion-01', 'Shows weight mg downward and drag bv upward.', 1, 'The free-body diagram has correct forces and directions.', 'Drag opposes the downward velocity.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('698d4f02-2e95-4e26-adbb-c85c8b759236'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-a-criterion-02', 'Writes m dv/dt=mg-bv with the stated sign convention.', 1, 'Newton''s second law is correct.', 'Sum downward-positive forces before dividing by m.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('4d969823-dd34-4878-a8fa-d0e505a71ef4'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-a-criterion-03', 'Obtains terminal speed v_T=mg/b.', 1, 'Terminal motion is found by setting acceleration to zero.', 'Set mg-bv_T=0.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('06bd70a0-35ac-4242-ac1e-19583cc976b2'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-b-criterion-01', 'Separates variables or uses a valid linear-equation method on dv/dt+(b/m)v=g.', 1, 'A calculus-based solution method is shown.', 'Put the equation in separable or first-order linear form.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('6739bad6-7a06-47df-a8b9-53f8673ec2aa'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-b-criterion-02', 'Integrates to obtain a logarithmic or equivalent exponential relation with an integration constant.', 1, 'The integration step is mathematically valid.', 'Integrate dv/(g-bv/m)=dt.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('03e5f45e-68ae-4a7f-ab0c-6ce45a2ec222'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-b-criterion-03', 'Applies v(0)=0 to obtain v(t)=v_T(1-e^{-bt/m}).', 1, 'The initial condition and time constant are correct.', 'Choose the constant so velocity begins at zero.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('5babe14b-dd74-4776-ad94-b80a730689bc'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-b-criterion-04', 'Differentiates to obtain a(t)=g e^{-bt/m}.', 1, 'The acceleration has correct initial and long-time limits.', 'Differentiate the velocity expression with respect to time.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('87e5161c-4ee5-4c00-a65e-0e1f94f86295'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-c-criterion-01', 'Shows v starting at zero, increasing concave down, and approaching v_T asymptotically.', 1, 'The velocity graph matches the solution.', 'Use both v and dv/dt limits.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('3ab5e430-e0c5-4506-af21-f3d5956c8f03'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-c-criterion-02', 'Shows a starting at g, decreasing concave up, and approaching zero.', 1, 'The acceleration graph matches the exponential solution.', 'Use a=g e^{-bt/m}.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('273c7138-4ed9-4021-abb3-38efd29058df'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-c-criterion-03', 'Labels the characteristic time scale m/b or a representative value at t=m/b.', 1, 'The graph includes a quantitative time feature.', 'Mark τ=m/b, where the exponential factor is e^{-1}.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('4071a88f-817c-4a57-a5bc-f8371aea7dd7'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-d-criterion-01', 'States that the second object''s terminal speed is smaller because v_T=mg/b.', 1, 'The parameter dependence is correct.', 'Increase b in the terminal-speed expression.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('93af330c-7781-442e-a834-45004effe978'::uuid, 'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid, 'part-d-criterion-02', 'States that the initial slope remains g because drag is zero at release.', 1, 'The initial acceleration comparison is correct.', 'At v=0, the bv term vanishes for either object.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      '037ba04d-df07-4b9a-a7cb-722c12ed664e'::uuid,
      'f36a8ea5-d796-4ce9-aeab-aa39c0782c05'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid
      and content_key = 'apphycm-frq-037'
      and id <> '1f9e0011-5221-4879-aac7-f62da6438e4b'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-037';
  end if;

  if not exists (
    select 1 from app.content_items where id = '1f9e0011-5221-4879-aac7-f62da6438e4b'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '1f9e0011-5221-4879-aac7-f62da6438e4b'::uuid,
      'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,
      'apphycm-frq-037',
      'frq',
      'Measuring an irregular rotor''s inertia',
      'assigned',
      'long',
      'full_exam_frq',
      'Experimental Design and Analysis'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, content_hash, status, review_status, rubric_type,
      evaluator_strategy
    ) values (
      'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid,
      '1f9e0011-5221-4879-aac7-f62da6438e4b'::uuid,
      1,
      'Measuring an irregular rotor''s inertia: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'An irregular rigid rotor turns with negligible axle friction about a fixed horizontal axis. A light string wrapped around a hub of measured radius r supports a hanging mass m. Available equipment includes several masses, a meterstick, a stopwatch, a motion sensor for the hanging mass, and a balance. The rotor''s rotational inertia I is unknown.',
      '{"content_key":"apphycm-frq-037","subject":"ap_physics_c_mechanics","unit":5,"topic":"Torque and Rotational Dynamics","archetype":"Experimental Design and Analysis","difficulty":"Hard","source_fact_pack_id":"1rc_z7A4CmhDx1Ya6zJswnKYm2wtOrLsJRK-7qBzDxG0","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Derive a model relating the hanging mass''s downward acceleration a to m, r, g, and I, assuming the string does not slip.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Describe how to collect acceleration data for several trials while controlling sources of random and systematic error.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Linearize the model, specify graph axes, and explain how I and its uncertainty are determined. Include one diagnostic for non-negligible axle friction.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]},{"part_key":"part-d","prompt":"The actual hub radius is larger than the measured value used in the analysis. Determine the direction of the resulting error in I and justify.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      'Eliminating tension gives a=mg/(m+I/r²). The linear form 1/a=1/g+[I/(gr²)](1/m) makes the slope proportional to I. An underestimated hub radius produces an underestimated inertia.',
      md5('Measuring an irregular rotor''s inertia: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('06ace998-ca92-4a49-afbf-d31b9dd473a9'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-a-criterion-01', 'Combines mg-T=ma, Tr=Iα, and α=a/r.', 1, 'The translational and rotational equations and no-slip condition are all present.', 'Write one force equation, one torque equation, and the kinematic link.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('828aee4e-dd54-4fb6-a748-7e607db1d362'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-a-criterion-02', 'Obtains a=mg/(m+I/r²), or an algebraically equivalent form.', 1, 'The model is solved correctly for acceleration.', 'Eliminate T and α before isolating a.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('326454ac-5e27-45e0-af0b-8ae8771b6cc6'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-b-criterion-01', 'Uses several known hanging masses, releases from rest without a push, and obtains a from the slope of velocity-time data or a quadratic fit to position-time data.', 1, 'The procedure generates repeated quantitative acceleration measurements.', 'Use the motion sensor rather than a single fall-time estimate where possible.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('8c607f3a-c4bd-476a-aa71-834721b61a43'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-b-criterion-02', 'Keeps r and drop distance fixed, prevents slip, and repeats trials to average random variation.', 1, 'Relevant controls and replication are specified.', 'Control geometry and verify the string remains taut and nonslipping.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('0afa4f2d-d8db-4cc5-adda-e407e51d0690'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-c-criterion-01', 'Rearranges to 1/a=1/g+(I/(g r²))(1/m), or an equivalent linear form.', 1, 'The model is correctly linearized.', 'Invert the acceleration equation and separate constant and 1/m terms.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('871e901d-b925-46fe-ad88-1c74620d34d7'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-c-criterion-02', 'Plots 1/a vertically versus 1/m horizontally and identifies slope S=I/(g r²).', 1, 'Axes and slope meaning match the linearized model.', 'Map the equation to y=b+Sx.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('4043073b-d566-4d58-aee2-68ddeca35f73'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-c-criterion-03', 'Calculates I=S g r² and propagates slope and radius uncertainty, or uses defensible extreme-fit bounds.', 1, 'The parameter and uncertainty method are correct.', 'Include the r² sensitivity when reporting I uncertainty.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('2b65a01d-64ac-4226-a735-b83a2d54b540'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-c-criterion-04', 'Uses a fitted intercept inconsistent with 1/g or systematic residuals as evidence of unmodeled friction.', 1, 'A valid model diagnostic is identified.', 'Compare the measured intercept with the frictionless prediction.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('bd180e98-4e17-4f96-aad1-38e77b78e0c6'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-d-criterion-01', 'States that the reported I is too small.', 1, 'The direction follows from I=Sgr².', 'A radius underestimate enters the calculated inertia quadratically.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('7ebc967a-a676-49dd-a2c9-5a5397a8b789'::uuid, 'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid, 'part-d-criterion-02', 'Justifies that the fitted slope is data determined while multiplying by an underestimated r² reduces the inferred I.', 1, 'The role of the graph and radius is clearly distinguished.', 'Hold the fitted slope fixed and compare the true and used radius factors.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      'd3345e6a-d160-4567-af23-8279d656e3d2'::uuid,
      'dc22c9db-8d63-4612-ab56-cd877dee7673'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid
      and content_key = 'apphycm-frq-038'
      and id <> '251b6c29-4068-409f-affb-f4b3d640ed70'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-038';
  end if;

  if not exists (
    select 1 from app.content_items where id = '251b6c29-4068-409f-affb-f4b3d640ed70'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '251b6c29-4068-409f-affb-f4b3d640ed70'::uuid,
      'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,
      'apphycm-frq-038',
      'frq',
      'Tangential impulse in circular orbit',
      'assigned',
      'long',
      'full_exam_frq',
      'Qualitative/Quantitative Translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, content_hash, status, review_status, rubric_type,
      evaluator_strategy
    ) values (
      'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid,
      '251b6c29-4068-409f-affb-f4b3d640ed70'::uuid,
      1,
      'Tangential impulse in circular orbit: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A satellite of mass m moves in a circular orbit of radius r around a planet of mass M. At one instant a brief tangential impulse increases the satellite''s speed from the circular value v_c to (1+ε)v_c, where 0<ε<sqrt(2)-1. The satellite remains at radius r during the impulse.',
      '{"content_key":"apphycm-frq-038","subject":"ap_physics_c_mechanics","unit":6,"topic":"Gravitation and Orbits","archetype":"Qualitative/Quantitative Translation","difficulty":"Hard","source_fact_pack_id":"1rc_z7A4CmhDx1Ya6zJswnKYm2wtOrLsJRK-7qBzDxG0","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Predict whether the point of the impulse becomes the pericenter or apocenter of the new orbit. Justify using the radial acceleration immediately after the impulse and the orbit''s qualitative shape.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Derive the new orbit''s specific mechanical energy and semimajor axis a in terms of r and ε.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Sketch radial distance from the planet versus time for one new orbital period beginning at the impulse. Label the initial value and qualitative extrema.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      'Because the new tangential speed exceeds circular speed, gravity cannot supply the instantaneous v²/r curvature and the satellite moves outward; the impulse point is pericenter. Energy gives a=r/[2-(1+ε)²], and the radial coordinate oscillates smoothly between r and 2a-r.',
      md5('Tangential impulse in circular orbit: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('f17b7211-429f-47dc-a5fe-b35f8420fbe9'::uuid, 'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid, 'part-a-criterion-01', 'States that the impulse point becomes the pericenter.', 1, 'The faster-than-circular tangential speed leads to outward motion after the impulse.', 'At a turning point of radius, excess tangential speed corresponds to closest approach.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('b379081e-0bd1-49a1-aab5-6cdd7fd6c514'::uuid, 'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid, 'part-a-criterion-02', 'Compares v²/r with GM/r² and shows the required centripetal acceleration exceeds gravity immediately after the impulse.', 1, 'The force-kinematics mismatch is correctly identified.', 'Use v_c²=GM/r and v>v_c.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('11028d04-3c1f-44a8-a861-40ad501bc3a1'::uuid, 'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid, 'part-a-criterion-03', 'Explains that the satellite initially curves less sharply than a circle and moves to larger radius, forming a bound ellipse.', 1, 'The qualitative trajectory follows from the acceleration comparison and the given speed bound.', 'Connect insufficient inward acceleration to outward radial departure.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('79ca126d-3654-45e8-ad62-7c0be835a1ec'::uuid, 'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid, 'part-b-criterion-01', 'Uses v_c²=GM/r in E/m=(1/2)(1+ε)²v_c²-GM/r.', 1, 'The post-impulse kinetic and potential energies are correct.', 'Substitute the circular-speed relation only after writing total energy.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('fd8cbcc6-f036-4fd8-a8c7-0374fd01b2e5'::uuid, 'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid, 'part-b-criterion-02', 'Obtains E/m=(GM/(2r))[(1+ε)²-2], which is negative for the stated ε.', 1, 'The specific energy is simplified and boundness is checked.', 'Compare (1+ε)² with 2.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('d167f8a8-dd67-465a-a1b0-43321c65d0af'::uuid, 'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid, 'part-b-criterion-03', 'Uses E/m=-GM/(2a) to obtain a=r/[2-(1+ε)²].', 1, 'The semimajor axis is correctly derived.', 'Equate the two specific-energy expressions and solve for a.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('728ece91-c2ae-41c6-aef1-0dd4f0eea10a'::uuid, 'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid, 'part-c-criterion-01', 'Shows radius beginning at a minimum r with zero initial radial slope, increasing to one maximum, and returning to r after one period.', 1, 'The time representation matches a bound ellipse beginning at pericenter.', 'Mark the impulse point as the radial minimum.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('90256726-683d-48a4-ae16-9d38ff255f56'::uuid, 'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid, 'part-c-criterion-02', 'Shows a smooth curve with zero slope at both pericenter and apocenter and labels r_max=2a-r or an equivalent relation.', 1, 'Turning-point behavior and the second extreme are correctly represented.', 'Use r_peri+r_apo=2a for an ellipse.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      '8c1d4f55-09e8-425d-abb6-ad0bef7c1a47'::uuid,
      'b3695266-5c32-4c2f-ab4a-552b77743f1c'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = '841a88cc-773c-44e5-97fa-6504f8667689'::uuid
      and content_key = 'apphycem-frq-035'
      and id <> '6968abce-53ea-4e41-a7e9-5254292d75f1'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-035';
  end if;

  if not exists (
    select 1 from app.content_items where id = '6968abce-53ea-4e41-a7e9-5254292d75f1'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '6968abce-53ea-4e41-a7e9-5254292d75f1'::uuid,
      '841a88cc-773c-44e5-97fa-6504f8667689'::uuid,
      'apphycem-frq-035',
      'frq',
      'Nonuniform charged insulating sphere',
      'assigned',
      'long',
      'full_exam_frq',
      'Mathematical Routines'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, content_hash, status, review_status, rubric_type,
      evaluator_strategy
    ) values (
      '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid,
      '6968abce-53ea-4e41-a7e9-5254292d75f1'::uuid,
      1,
      'Nonuniform charged insulating sphere: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A solid insulating sphere of radius R has spherically symmetric volume charge density ρ(r)=ρ0(r/R) for 0≤r≤R and zero outside, where ρ0>0. Take electric potential to be zero at infinity.',
      '{"content_key":"apphycem-frq-035","subject":"ap_physics_c_em","unit":8,"topic":"Electrostatics and Gauss''s Law","archetype":"Mathematical Routines","difficulty":"Hard","source_fact_pack_id":"1AwMAtwpUj798kRROyz4O8q9w36YubauEeB7122mrJM0","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Using calculus and Gauss''s law, derive the electric field magnitude for r<R and r≥R. Demonstrate continuity at r=R.","points":7,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1},{"criterion_key":"part-a-criterion-05","points":1},{"criterion_key":"part-a-criterion-06","points":1},{"criterion_key":"part-a-criterion-07","points":1}]},{"part_key":"part-b","prompt":"Derive the electric potential at the center of the sphere.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]}]}'::jsonb,
      'Integrating the density gives q_enc=πρ0r⁴/R and Q=πρ0R³. Gauss''s law yields E=ρ0r²/(4ε0R) inside and ρ0R³/(4ε0r²) outside. Integrating the field from the center to infinity gives V(0)=ρ0R²/(3ε0).',
      md5('Nonuniform charged insulating sphere: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('db86937c-2144-48d1-a57f-6de3080ac9c7'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-a-criterion-01', 'Writes dq=ρ(r'')4πr''²dr'' for a spherical shell.', 1, 'The volume element and radial variable are correct.', 'Use dV=4πr''²dr''.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('d3f7a6b0-c7e2-4597-a2c5-f7f2f3182530'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-a-criterion-02', 'Integrates q_enc(r)=∫0^r ρ0(r''/R)4πr''²dr''=πρ0r⁴/R.', 1, 'The enclosed-charge integral and result are correct.', 'Integrate r''^3 from 0 to r.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('457bbb5c-3257-43ea-ad2a-b8049de0c9c4'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-a-criterion-03', 'Applies E(4πr²)=q_enc/ε0 inside.', 1, 'Gauss''s law uses the spherical surface and symmetry correctly.', 'Use a concentric Gaussian sphere.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('caf01dbf-1e27-4931-a82d-f6983c5f1423'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-a-criterion-04', 'Obtains E_inside=ρ0r²/(4ε0R), radially outward.', 1, 'The inside field has correct dependence, units, and direction.', 'Substitute q_enc and divide by 4πr²ε0.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('492cfa47-ec5a-4a23-a465-9dd0ae4626f2'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-a-criterion-05', 'Calculates total charge Q=πρ0R³.', 1, 'The inside charge result is evaluated correctly at R.', 'Set r=R in q_enc.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('c0bb1f95-f5de-4219-ade4-edc24daf9941'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-a-criterion-06', 'Obtains E_outside=ρ0R³/(4ε0r²), radially outward.', 1, 'The outside field is the total-charge inverse-square field.', 'Apply Gauss''s law with q_enc=Q.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('5ca0472f-ffec-4014-afad-82cc9e7808b2'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-a-criterion-07', 'Shows both expressions give E(R)=ρ0R/(4ε0).', 1, 'Continuity at the boundary is explicitly demonstrated.', 'Evaluate the inside and outside formulas at R.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('b4f50c28-3592-47b9-ae08-9d17760ee0c2'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-b-criterion-01', 'Uses V(0)=∫0^∞ E(r)dr, split at R with the correct sign convention.', 1, 'The potential difference from infinity is expressed correctly.', 'For an outward positive field, V(0)=∫_0^∞ E dr.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('1a12ec4b-e691-43da-a71d-391ebcba6009'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-b-criterion-02', 'Evaluates the inside contribution ∫0^R ρ0r²/(4ε0R)dr=ρ0R²/(12ε0).', 1, 'The interior integral is correct.', 'Integrate r² and retain the 1/R factor.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('b027e94d-f16e-41a5-a46a-93e4733510c9'::uuid, '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid, 'part-b-criterion-03', 'Evaluates the outside contribution ρ0R²/(4ε0) and obtains V(0)=ρ0R²/(3ε0).', 1, 'Both regions are combined correctly.', 'Integrate r^{-2} from R to infinity and add the interior result.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      'c3d09709-36b1-40b2-a985-26910d816ba4'::uuid,
      '66f4bd53-b048-4eae-ab89-37eb94be2036'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = '841a88cc-773c-44e5-97fa-6504f8667689'::uuid
      and content_key = 'apphycem-frq-036'
      and id <> '02ff8659-872a-482b-aa7c-84064b73a39e'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-036';
  end if;

  if not exists (
    select 1 from app.content_items where id = '02ff8659-872a-482b-aa7c-84064b73a39e'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '02ff8659-872a-482b-aa7c-84064b73a39e'::uuid,
      '841a88cc-773c-44e5-97fa-6504f8667689'::uuid,
      'apphycem-frq-036',
      'frq',
      'Discharging capacitor representations',
      'assigned',
      'long',
      'full_exam_frq',
      'Translation Between Representations'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, content_hash, status, review_status, rubric_type,
      evaluator_strategy
    ) values (
      '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid,
      '02ff8659-872a-482b-aa7c-84064b73a39e'::uuid,
      1,
      'Discharging capacitor representations: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A capacitor C is initially charged to potential V0. At t=0 it is disconnected from the source and connected across two parallel resistors R and 2R. Define q(t) as the charge on the initially positive plate and take current out of that plate as positive.',
      '{"content_key":"apphycem-frq-036","subject":"ap_physics_c_em","unit":11,"topic":"Electric Circuits","archetype":"Translation Between Representations","difficulty":"Hard","source_fact_pack_id":"1AwMAtwpUj798kRROyz4O8q9w36YubauEeB7122mrJM0","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Draw the discharge circuit, indicate current directions in both branches, and write the differential equation for q(t).","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Solve for q(t), the capacitor voltage, and each branch current. Verify current conservation at the junction.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Sketch q(t), total current, and power dissipated in resistor 2R versus time on labeled axes. Compare their decay constants.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Determine the fraction of the capacitor''s initial energy dissipated in resistor 2R over the entire discharge and justify without evaluating a time integral.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      'The parallel resistance is 2R/3, so q=CV0e^{-3t/(2RC)}. Both branch currents share that exponential. Power depends on voltage squared and therefore decays twice as fast. Since branch powers remain in a 2:1 ratio, the 2R resistor receives one third of the stored energy.',
      md5('Discharging capacitor representations: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('8c8f2bce-3795-451a-ae98-4dca1ba36c40'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-a-criterion-01', 'Shows R and 2R in parallel across C with conventional currents leaving the initially positive plate.', 1, 'The topology and current directions are correct.', 'Both resistors share the capacitor voltage.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('f8a3346a-73c3-422f-aaed-cab1c7c78294'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-a-criterion-02', 'Finds equivalent resistance R_eq=2R/3.', 1, 'The parallel combination is calculated correctly.', 'Use 1/R_eq=1/R+1/(2R).', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('e4823256-95d4-4908-a6ab-e772473f778d'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-a-criterion-03', 'Writes dq/dt=-q/(R_eq C)=-3q/(2RC).', 1, 'Charge conservation and the voltage-current relation give the correct differential equation.', 'Total outward current is -dq/dt=q/(R_eq C).', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('e626571b-c599-47e9-a906-a1ac54137cfb'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-b-criterion-01', 'Integrates the differential equation to obtain q=CV0e^{-3t/(2RC)}.', 1, 'The initial charge and time constant are correct.', 'Apply q(0)=CV0 after separating variables.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('dcf805f7-9a04-48cd-a97f-d94c93d6730b'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-b-criterion-02', 'Writes V_C=V0e^{-3t/(2RC)}.', 1, 'The voltage follows q/C.', 'Divide the charge expression by C.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('5a041f68-34a8-413d-a111-d609c6d3758c'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-b-criterion-03', 'Writes I_R=(V0/R)e^{-3t/(2RC)} and I_2R=(V0/(2R))e^{-3t/(2RC)}.', 1, 'Ohm''s law is correctly applied to both parallel branches.', 'Each resistor has the same instantaneous voltage.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('4114dfb1-564c-4f48-ac48-0bd7a1252c9b'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-b-criterion-04', 'Shows I_R+I_2R=(3V0/(2R))e^{-3t/(2RC)}=-dq/dt.', 1, 'The junction current relation is explicitly verified.', 'Add branch currents and differentiate q(t).', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('6cc40e8c-0aee-4ee9-a4f0-7e095cda1d62'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-c-criterion-01', 'Shows q decreasing exponentially from CV0 with time constant 2RC/3.', 1, 'The charge graph''s initial value and decay rate are correct.', 'Read τ=R_eqC from the solution.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('8483ba03-b4e7-4471-a2fd-6dcfee7c32fc'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-c-criterion-02', 'Shows total current decreasing exponentially from 3V0/(2R) with the same time constant 2RC/3.', 1, 'The current graph has correct scale and decay.', 'Current is proportional to q for this linear circuit.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('b9ea73d0-b0da-4fbc-a212-8efa0f4bb105'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-c-criterion-03', 'Shows P_2R=V0²/(2R)e^{-3t/(RC)}, with time constant RC/3, half the charge/current time constant.', 1, 'Squaring voltage correctly doubles the exponential decay rate.', 'Use P=V²/(2R).', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('c7135734-c60e-4c0a-ab57-7e672d6c4336'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-d-criterion-01', 'Recognizes that the two resistors always have the same voltage, so their powers are in ratio P_R:P_2R=2:1.', 1, 'The constant power ratio is correct.', 'Compare V²/R with V²/(2R).', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('6beb3eb5-1a31-417a-a021-555a0e98bba6'::uuid, '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid, 'part-d-criterion-02', 'Concludes that resistor 2R receives one third of the initial capacitor energy.', 1, 'The energy division follows the constant power ratio and complete discharge.', 'The two branch fractions sum to one in the ratio 2:1.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      'fb0aa42a-4599-44af-a9e7-9c1987c25283'::uuid,
      '7a2ec972-f5f1-490f-a5cd-f90f101e8e5f'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = '841a88cc-773c-44e5-97fa-6504f8667689'::uuid
      and content_key = 'apphycem-frq-037'
      and id <> '43ab78d7-2048-409d-aed0-c93f53192868'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-037';
  end if;

  if not exists (
    select 1 from app.content_items where id = '43ab78d7-2048-409d-aed0-c93f53192868'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '43ab78d7-2048-409d-aed0-c93f53192868'::uuid,
      '841a88cc-773c-44e5-97fa-6504f8667689'::uuid,
      'apphycem-frq-037',
      'frq',
      'Mapping the field inside a solenoid',
      'assigned',
      'long',
      'full_exam_frq',
      'Experimental Design and Analysis'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, content_hash, status, review_status, rubric_type,
      evaluator_strategy
    ) values (
      '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid,
      '43ab78d7-2048-409d-aed0-c93f53192868'::uuid,
      1,
      'Mapping the field inside a solenoid: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A long solenoid has unknown turns per unit length n. Available equipment includes the solenoid, an adjustable dc supply, an ammeter, a calibrated axial magnetic-field probe with stated reading uncertainty, a meterstick, and a stand. The probe can be positioned along the solenoid axis.',
      '{"content_key":"apphycem-frq-037","subject":"ap_physics_c_em","unit":10,"topic":"Magnetic Fields","archetype":"Experimental Design and Analysis","difficulty":"Hard","source_fact_pack_id":"1AwMAtwpUj798kRROyz4O8q9w36YubauEeB7122mrJM0","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"State the ideal-solenoid model to be tested and identify a graph whose slope determines n.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Describe how to collect data that test both the field-current model and the assumption that the interior field is spatially uniform.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Explain the analyses used to determine n and its uncertainty, to correct a constant ambient-field offset, and to identify the region where the ideal model is valid.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]},{"part_key":"part-d","prompt":"The ammeter reads 4 percent higher than the true current at every setting. Determine the direction of the resulting error in n and justify.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      'Inside a long solenoid, B=μ0nI. The slope of B versus I gives n, while zero-current data remove an additive offset. An axial scan identifies the uniform central region. A current reading biased high makes the fitted slope and n too small.',
      md5('Mapping the field inside a solenoid: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('1e21a604-1510-4f6d-a149-968f38969e83'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-a-criterion-01', 'States B=μ0nI well inside an ideal long solenoid.', 1, 'The theoretical field-current model is correct.', 'Use Ampère''s law result for the interior field.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('808aed98-e7ef-4c11-ae5c-66e184aaf7bc'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-a-criterion-02', 'Identifies a plot of axial B versus I with slope μ0n.', 1, 'The graph and slope interpretation are correct.', 'Match B=(μ0n)I to a linear graph.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('ce3c97a1-ecfe-4ccf-a1aa-5b741d6b4cc9'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-b-criterion-01', 'At a fixed central position, varies current over several safe values and records paired I and B, including a zero-current reading.', 1, 'The procedure tests linearity and provides an offset check.', 'Collect multiple current-field pairs and include I=0.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('bf31ecde-44f8-47ca-a51b-289e6b24d5a4'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-b-criterion-02', 'At one fixed nonzero current, measures B at several axial positions away from and near the ends while keeping probe orientation fixed.', 1, 'The procedure separately tests spatial uniformity.', 'Map the axial field without rotating the probe.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('01a4871f-d18b-4ae8-a209-2abb340d1c90'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-c-criterion-01', 'Fits B versus I at the center and calculates n=slope/μ0.', 1, 'The turns density is extracted from the correct fit.', 'Divide the best-fit slope by μ0.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('5e8457ba-b2ef-4663-ace1-e0ef9ab10de0'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-c-criterion-02', 'Uses slope uncertainty to report δn=δslope/μ0 and incorporates the probe uncertainty in the fit or error bars.', 1, 'A defensible parameter uncertainty is specified.', 'Propagate the fitted slope uncertainty through the constant factor.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('52f63fef-9d6c-4364-ac26-a96fe34373d9'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-c-criterion-03', 'Uses the I=0 intercept or zero-current reading to subtract a constant ambient/probe offset before interpreting B.', 1, 'The offset correction is physically and statistically appropriate.', 'Treat the nonzero zero-current field as an additive background.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('8b0aa189-d2a6-44b8-ad53-046d00ef37a6'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-c-criterion-04', 'Uses the axial map and uncertainty bars to identify a central interval where B is statistically consistent with a constant, excluding end regions.', 1, 'The ideal-model validity region is determined from data.', 'Define uniformity by agreement within measurement uncertainty.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('e5845e4e-2182-409f-aab0-9e1b2904e6db'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-d-criterion-01', 'States that the calculated n is too small.', 1, 'The direction of the calibration effect is correct.', 'Overstated horizontal-axis values reduce the fitted B-versus-I_read slope.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('677b0017-8d59-4002-a10a-3fc7cce7cade'::uuid, '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid, 'part-d-criterion-02', 'Justifies that slope_measured=B/I_read is smaller than B/I_true, so n=slope/μ0 is underestimated.', 1, 'The systematic error is traced through the graph calculation.', 'Compare the measured and true slopes explicitly.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      'd2a25a31-d786-4f20-a712-76a8910d84d0'::uuid,
      '3abd488b-a04d-45ed-a305-6a85bc641915'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = '841a88cc-773c-44e5-97fa-6504f8667689'::uuid
      and content_key = 'apphycem-frq-038'
      and id <> '6b9d6ac6-f532-4fb7-a4ab-92c3ca9c721d'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycem-frq-038';
  end if;

  if not exists (
    select 1 from app.content_items where id = '6b9d6ac6-f532-4fb7-a4ab-92c3ca9c721d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '6b9d6ac6-f532-4fb7-a4ab-92c3ca9c721d'::uuid,
      '841a88cc-773c-44e5-97fa-6504f8667689'::uuid,
      'apphycem-frq-038',
      'frq',
      'Magnetic braking of a sliding rod',
      'assigned',
      'long',
      'full_exam_frq',
      'Qualitative/Quantitative Translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, content_hash, status, review_status, rubric_type,
      evaluator_strategy
    ) values (
      '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid,
      '6b9d6ac6-f532-4fb7-a4ab-92c3ca9c721d'::uuid,
      1,
      'Magnetic braking of a sliding rod: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A conducting rod of length ℓ and mass m slides without mechanical friction on horizontal conducting rails. The rails are connected by a resistor R, forming a closed loop. A uniform magnetic field B points vertically downward. At t=0 the rod is moving right with speed v0. Neglect rail and rod resistance and self-inductance.',
      '{"content_key":"apphycem-frq-038","subject":"ap_physics_c_em","unit":13,"topic":"Electromagnetic Induction","archetype":"Qualitative/Quantitative Translation","difficulty":"Hard","source_fact_pack_id":"1AwMAtwpUj798kRROyz4O8q9w36YubauEeB7122mrJM0","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Predict the induced-current direction as viewed from above and the magnetic-force direction on the rod. Justify from flux change and energy.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Derive the differential equation for v(t) and solve for the rod''s speed.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Sketch speed and resistor power versus time on labeled axes, and determine the total energy dissipated in the resistor.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      'The increasing downward flux drives a counterclockwise current viewed from above, producing a leftward drag force. The equation m dv/dt=-(B²ℓ²/R)v gives exponential speed decay. All initial kinetic energy is ultimately dissipated in R.',
      md5('Magnetic braking of a sliding rod: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('f51ec9ff-ca3c-46e7-ab15-504ad23c3d41'::uuid, '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid, 'part-a-criterion-01', 'States that the current direction produces an upward magnetic field through the loop.', 1, 'Lenz''s law is applied to oppose increasing downward flux.', 'As the rod moves right, loop area and downward flux increase.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('dab3296e-9246-4c65-a4c7-7a54991d9a15'::uuid, '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid, 'part-a-criterion-02', 'Gives the corresponding current direction around the specified rail geometry, with an unambiguous description or diagram.', 1, 'The current direction is consistent with an upward induced field.', 'Use the right-hand rule for an upward field; counterclockwise as viewed from above.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('6bd3b291-4d3c-46f3-aee1-49d2ace01e7f'::uuid, '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid, 'part-a-criterion-03', 'States that the magnetic force on the rod is leftward and explains that it removes kinetic energy that becomes resistor heat.', 1, 'The force direction and energy interpretation are correct.', 'The induced force must oppose the motion in this passive circuit.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('1fb2e2f0-2683-4db1-a0ae-4c74167ef107'::uuid, '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid, 'part-b-criterion-01', 'Uses motional emf Bℓv and current I=Bℓv/R.', 1, 'The electromagnetic circuit relations are correct.', 'Apply motional emf and Ohm''s law.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('b61310b0-1fc1-4787-a77b-29f3ea31eda2'::uuid, '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid, 'part-b-criterion-02', 'Obtains m dv/dt=-(B²ℓ²/R)v.', 1, 'The magnetic force IℓB and opposing sign are correct.', 'Substitute current into the force on the rod.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('97e9e363-36db-4089-a561-96124e41aa60'::uuid, '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid, 'part-b-criterion-03', 'Solves v(t)=v0 exp[-B²ℓ²t/(mR)].', 1, 'The separable differential equation and initial condition are handled correctly.', 'Integrate dv/v=-[B²ℓ²/(mR)]dt.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('321d0222-e270-4199-a868-351f6a366ae3'::uuid, '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid, 'part-c-criterion-01', 'Shows v decaying exponentially from v0 with time constant mR/(B²ℓ²), while P=(B²ℓ²/R)v0² exp[-2B²ℓ²t/(mR)] decays twice as fast.', 1, 'Both representations have correct initial values and relative decay rates.', 'Use P=I²R and square the velocity exponential.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb),
      ('bf451fce-4fa8-4fa0-af38-ed8c6dffd2b8'::uuid, '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid, 'part-c-criterion-02', 'Determines total dissipated energy as (1/2)mv0².', 1, 'Energy conservation is applied to the rod coming asymptotically to rest.', 'All initial kinetic energy becomes resistor heat in the idealized system.', '["Equivalent calculus-based reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      '8418a8bb-e976-4e5f-a7b5-3ede542904b6'::uuid,
      '6ca9c518-7a58-41a7-a868-0153a0111e91'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;
end
$physics_full_scale$;
commit;
