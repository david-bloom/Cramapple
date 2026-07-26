begin;
do $physics_full_scale$
declare
  v_max integer;
begin

  select coalesce(max((regexp_match(content_key, '([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^apphy1-frq-[0-9]+$';
  if v_max not between 34 and 38 then
    raise exception 'unexpected_live_max:apphy1:%', v_max;
  end if;

  select coalesce(max((regexp_match(content_key, '([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^apphy2-frq-[0-9]+$';
  if v_max not between 34 and 38 then
    raise exception 'unexpected_live_max:apphy2:%', v_max;
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = '29c719dc-701b-470f-9e49-fab981722d3f'::uuid
      and content_key = 'apphy1-frq-035'
      and id <> 'de650c07-ac1b-40cd-a4cd-2c17633ed7c3'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-035';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'de650c07-ac1b-40cd-a4cd-2c17633ed7c3'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'de650c07-ac1b-40cd-a4cd-2c17633ed7c3'::uuid,
      '29c719dc-701b-470f-9e49-fab981722d3f'::uuid,
      'apphy1-frq-035',
      'frq',
      'Spring launch on a rough track',
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
      '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid,
      'de650c07-ac1b-40cd-a4cd-2c17633ed7c3'::uuid,
      1,
      'Spring launch on a rough track: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A block of mass m is released from rest against a spring of constant k compressed a distance x. After losing contact with the spring, the block crosses a horizontal rough region of length L with kinetic-friction coefficient μ and then moves up a frictionless ramp. The zero of gravitational potential energy is the horizontal track. Express answers in terms of the given symbols and g.',
      '{"content_key":"apphy1-frq-035","subject":"ap_physics_1","unit":3,"topic":"Work, Energy, and Power","archetype":"Mathematical Routines","difficulty":"Hard","source_fact_pack_id":"1WTHwHrJujEuBzAXsL92zQdnHXlE-cvgsArE_FOVdR1g","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Derive an expression for the block''s maximum vertical height h above the horizontal track. Begin from a fundamental physics principle, and show the work done by friction.","points":7,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1},{"criterion_key":"part-a-criterion-05","points":1},{"criterion_key":"part-a-criterion-06","points":1},{"criterion_key":"part-a-criterion-07","points":1}]},{"part_key":"part-b","prompt":"A second trial uses compression 2x while all other quantities are unchanged. Determine the change in maximum height, h(2x)-h(x), and explain why doubling x does not merely double the height.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]}]}'::jsonb,
      'Using E_i+W_f=E_f gives (1/2)kx²-μmgL=mgh, so h=kx²/(2mg)-μL, provided the spring energy exceeds the frictional loss. With compression 2x, the height increase is 3kx²/(2mg) because elastic energy scales as x².',
      md5('Spring launch on a rough track: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('521f2324-e3c5-4324-a924-04de0b50f92b'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-a-criterion-01', 'States an energy relation connecting the initial spring energy, friction work, and final gravitational potential energy.', 1, 'The response explicitly uses energy conservation modified by nonconservative work.', 'Write an equation of the form E_i + W_nc = E_f.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('4bd8ea15-9604-414b-a908-a6222566004c'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-a-criterion-02', 'Writes the initial spring energy as (1/2)kx².', 1, 'The compression x is squared and the factor 1/2 is present.', 'Use the elastic-potential expression (1/2)kx².', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('5e8b6766-3cf3-4ec4-af87-5a9142700e56'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-a-criterion-03', 'Determines the kinetic-friction magnitude as μmg on the horizontal region.', 1, 'The normal force is correctly identified as mg.', 'Use f_k=μN and N=mg on the horizontal track.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('c1c7d25f-c45e-409e-a287-efa58949d039'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-a-criterion-04', 'Writes the work by friction as -μmgL.', 1, 'The work has the correct negative sign and distance L.', 'Include the negative sign because friction removes mechanical energy.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('3fc92ff8-5f47-4bf7-ac36-2430ef36b358'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-a-criterion-05', 'Writes the final energy at maximum height as mgh with zero kinetic energy.', 1, 'The turning point condition v=0 is used.', 'At the maximum height set kinetic energy to zero.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('86abcbdb-b997-48c2-a736-450351209136'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-a-criterion-06', 'Solves algebraically for h=(kx²)/(2m g)-μL.', 1, 'The symbolic result follows from the correct energy equation.', 'Isolate h and simplify both terms.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('f2ea1f4d-0d03-4b88-ac76-835f32dd6e5b'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-a-criterion-07', 'States the physical condition kx²/2>μmgL for the block to reach the ramp.', 1, 'The response recognizes when the derived positive height is physically attainable.', 'Compare the spring energy with the energy dissipated on the rough region.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('2f3e2554-fed0-49bd-aae7-d1688cf83753'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-b-criterion-01', 'Substitutes 2x into the derived height expression.', 1, 'The spring-energy term becomes proportional to (2x)².', 'Replace x by 2x before simplifying.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('b3ed161f-af08-47bd-a186-48a57940a49e'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-b-criterion-02', 'Obtains h(2x)-h(x)=3kx²/(2mg).', 1, 'The friction term cancels and the quadratic difference is correct.', 'Subtract the two complete height expressions.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('75169e93-c655-453c-a9de-771cbbea2459'::uuid, '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid, 'part-b-criterion-03', 'Explains that spring energy is proportional to compression squared while the frictional loss is unchanged.', 1, 'The explanation connects the nonlinear result to the energy model.', 'State both the x² dependence and the constant friction loss.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      'fbadfc55-0959-4194-ae7d-25977641d6d4'::uuid,
      '9a3baf89-9716-4e48-a3a2-2516591cb66a'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = '29c719dc-701b-470f-9e49-fab981722d3f'::uuid
      and content_key = 'apphy1-frq-036'
      and id <> '50ca16ab-e248-4864-a2c1-73c7fd24813a'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-036';
  end if;

  if not exists (
    select 1 from app.content_items where id = '50ca16ab-e248-4864-a2c1-73c7fd24813a'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '50ca16ab-e248-4864-a2c1-73c7fd24813a'::uuid,
      '29c719dc-701b-470f-9e49-fab981722d3f'::uuid,
      'apphy1-frq-036',
      'frq',
      'Cart force graph and motion representations',
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
      'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid,
      '50ca16ab-e248-4864-a2c1-73c7fd24813a'::uuid,
      1,
      'Cart force graph and motion representations: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A cart of mass m moves on a level track. At t=0 its velocity is +v0. The measured net force is +F0 from t=0 to T, decreases linearly from +F0 at T to -F0 at 3T, and is -F0 from 3T to 4T. Positive force and velocity are to the right.',
      '{"content_key":"apphy1-frq-036","subject":"ap_physics_1","unit":2,"topic":"Force and Translational Dynamics","archetype":"Translation Between Representations","difficulty":"Hard","source_fact_pack_id":"1WTHwHrJujEuBzAXsL92zQdnHXlE-cvgsArE_FOVdR1g","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"On axes of net force versus time, represent the described force from 0 to 4T and label every endpoint and zero crossing.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Translate the force representation into a velocity-versus-time graph from 0 to 4T. Label v(0), v(T), v(3T), and v(4T) in terms of m, v0, F0, and T, and show the correct curvature.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Construct a momentum-versus-time graph for the same interval. Explain one similarity and one difference between this graph and the velocity graph.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Determine whether the cart ever reverses direction during 0≤t≤4T. Justify your answer from either representation.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      'Velocity slope is F_net/m, while momentum slope is F_net. Signed force-time areas give endpoint changes. The middle positive and negative triangular impulses cancel, and the last interval cancels the first, so v(4T)=v0 and the cart never reverses.',
      md5('Cart force graph and motion representations: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('bd29f0d0-81f7-416c-a02f-fd367479ea97'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-a-criterion-01', 'Shows a horizontal segment at +F0 from 0 to T.', 1, 'The first interval has the correct value and duration.', 'Draw the constant +F0 interval through t=T.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('a8c5ed97-0e84-4680-a071-6b32fe5a4ff9'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-a-criterion-02', 'Shows a straight line from (T,+F0) through (2T,0) to (3T,-F0).', 1, 'The linear interval and zero crossing are correctly placed.', 'A linear change from equal positive to negative values crosses zero halfway.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('cf2a8538-3a49-4881-a38b-65ccfa2e2d0f'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-a-criterion-03', 'Shows a horizontal segment at -F0 from 3T to 4T with labeled axes.', 1, 'The final interval and signs are correct.', 'Complete the graph with the constant negative-force interval.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('ba39fd14-2fc7-4bfa-a424-c61e2c28533d'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-b-criterion-01', 'Uses slope dv/dt=F_net/m to connect the force and velocity graphs.', 1, 'The graph construction is explicitly tied to Newton''s second law.', 'Use acceleration, not force area alone, as the slope of velocity.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('1cd64e58-7fc4-4b9c-aa56-804ac575e902'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-b-criterion-02', 'Shows a straight increasing velocity segment with v(T)=v0+F0T/m.', 1, 'The first interval''s slope and endpoint are correct.', 'Use Δv=(F0/m)T for the constant-acceleration interval.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('f7c686e1-f0ca-4ead-a284-1a7c9f32365f'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-b-criterion-03', 'Shows velocity with concave-down curvature from T to 3T and a horizontal tangent at 2T.', 1, 'The slope follows the linearly decreasing force and becomes zero at 2T.', 'Match the sign and change of acceleration throughout the middle interval.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('f5fd3583-96f0-470c-a9b4-4a3940c8e145'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-b-criterion-04', 'Labels v(3T)=v0+F0T/m and v(4T)=v0.', 1, 'The zero net impulse from T to 3T and negative final impulse are applied correctly.', 'Use signed areas under the force-time graph for each endpoint.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('9843af8a-f3f5-4418-a166-386f2e647d4a'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-c-criterion-01', 'Constructs p(t)=mv(t) with the same qualitative shape as the velocity graph.', 1, 'All features occur at the same times and are scaled by m.', 'Multiply every velocity value by the constant mass.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('b781b9ae-f249-4324-afd2-4507b689b666'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-c-criterion-02', 'Labels p(0)=mv0 and p(T)=mv0+F0T, with the corresponding values at 3T and 4T.', 1, 'The momentum endpoints are consistent with impulse.', 'Use Δp equal to signed force-time area.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('1c36c414-eb60-46a2-a926-774fc600be1f'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-c-criterion-03', 'Explains that p and v have identical shape for constant mass but different vertical scales and units.', 1, 'Both a similarity and a difference are stated.', 'Mention constant proportionality p=mv and the scale or units.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('65b25e59-0b31-46bb-ad98-8ccdec459002'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-d-criterion-01', 'States that the cart does not reverse direction.', 1, 'The conclusion is consistent with v0>0 and the computed velocities.', 'Check the minimum velocity rather than only the final velocity.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('ba858e27-1b56-4e1e-a4b7-592ef82b8638'::uuid, 'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid, 'part-d-criterion-02', 'Justifies that velocity remains positive and returns to v0 at 4T; its maximum occurs at 2T.', 1, 'The signed impulse or graph is used correctly.', 'Use the velocity graph or cumulative impulse to show v never reaches zero.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      '7dbe64fd-20ae-43b2-a920-dcc912656d18'::uuid,
      'ac5a70bc-9803-4fcd-a840-7b9e4ad0ed8d'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = '29c719dc-701b-470f-9e49-fab981722d3f'::uuid
      and content_key = 'apphy1-frq-037'
      and id <> '702fca06-c833-4262-a4ca-c1bf76252a84'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-037';
  end if;

  if not exists (
    select 1 from app.content_items where id = '702fca06-c833-4262-a4ca-c1bf76252a84'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '702fca06-c833-4262-a4ca-c1bf76252a84'::uuid,
      '29c719dc-701b-470f-9e49-fab981722d3f'::uuid,
      'apphy1-frq-037',
      'frq',
      'Testing the pressure-depth model',
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
      '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid,
      '702fca06-c833-4262-a4ca-c1bf76252a84'::uuid,
      1,
      'Testing the pressure-depth model: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A student is given a tall transparent container, an unidentified liquid, a ruler, a movable pressure sensor that reports absolute pressure, a stand and clamps, and a barometer. The student must determine the liquid''s density without pouring out the liquid.',
      '{"content_key":"apphy1-frq-037","subject":"ap_physics_1","unit":8,"topic":"Fluids","archetype":"Experimental Design and Analysis","difficulty":"Hard","source_fact_pack_id":"1WTHwHrJujEuBzAXsL92zQdnHXlE-cvgsArE_FOVdR1g","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"State a testable model relating the measured absolute pressure P to sensor depth h, and identify the physical quantity represented by the model''s slope.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Describe how to collect pressure and depth data while controlling variables that could bias the result.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Specify the graph and analysis used to determine density. Include how the barometer reading is used, how uncertainty in the density is obtained, and one check for a systematic offset in the pressure sensor.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]},{"part_key":"part-d","prompt":"Suppose every recorded depth is larger than the true depth by the same constant amount. State whether the calculated density is too large, too small, or unchanged, and justify.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      'For a static liquid, P=P_atm+ρgh. A linear fit of P versus h has slope ρg and intercept P_atm. The density is slope/g, and a constant depth zero error shifts only the intercept.',
      md5('Testing the pressure-depth model: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('3f5a85c4-e404-461d-a234-c65a40006a79'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-a-criterion-01', 'States P=P_atm+ρgh for a liquid at rest.', 1, 'The model includes both atmospheric pressure and hydrostatic pressure.', 'Include the nonzero surface-pressure intercept.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('e4923d75-f6b2-46ab-a0fd-75bbdfe6157a'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-a-criterion-02', 'Identifies the slope of P versus h as ρg.', 1, 'The requested physical meaning is correct.', 'Use the change in pressure divided by the change in depth.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('8947e5c5-28eb-49f8-a846-91c3f9fc1b8f'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-b-criterion-01', 'Measures pressure at several known vertical depths from the liquid surface after readings stabilize.', 1, 'The procedure produces multiple paired data points over a useful range.', 'Record paired h and P values at several depths.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('a2ddd5a8-adf6-43a1-a9b5-93a1497c2330'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-b-criterion-02', 'Keeps the liquid at rest and uses the same calibrated sensor orientation while avoiding contact with the container.', 1, 'Relevant controls and a bias-reduction step are specified.', 'Control sensor setup and do not disturb the fluid during readings.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('5305f5ad-f49a-422c-af34-ba742903267a'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-c-criterion-01', 'Plots absolute pressure P on the vertical axis against depth h on the horizontal axis and fits a straight line.', 1, 'Axes and linear analysis match the model.', 'Graph P versus h and use a best-fit line.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('be522b02-a79c-4c15-a921-5ba8ababdd76'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-c-criterion-02', 'Calculates density as ρ=slope/g.', 1, 'The slope is converted to density with correct units.', 'Divide the fitted slope by g.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('eb001289-de20-4591-a7c8-b2f4d618550c'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-c-criterion-03', 'Uses slope uncertainty to report δρ=δslope/g, or an equivalent high-low slope method.', 1, 'The density uncertainty is propagated from the fit.', 'Convert the fit''s slope uncertainty using the same factor 1/g.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('8e92af17-f65e-4d5b-a9cf-e1e92d5b5cad'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-c-criterion-04', 'Compares the fitted intercept with the barometer''s P_atm to diagnose a pressure-sensor zero offset.', 1, 'The independent atmospheric measurement is used as a systematic check.', 'The h=0 intercept should agree with atmospheric pressure within uncertainty.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('e2e33f99-920a-473b-af18-1b681faba81a'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-d-criterion-01', 'States that the calculated density is unchanged.', 1, 'The conclusion correctly distinguishes a constant horizontal offset from a scale error.', 'A constant shift of all h values does not change a fitted slope.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('563ee049-9fe1-44b6-a699-b8259ddb7bfb'::uuid, '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid, 'part-d-criterion-02', 'Justifies that the depth offset changes the intercept but not the slope of P versus recorded h.', 1, 'The effect is explained using the linear graph.', 'Rewrite the model using h_recorded=h_true+constant.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      '360fa9f5-e107-41dd-ac59-909b50f551ff'::uuid,
      '394b39f1-f73d-4e43-a67f-b19ff0e51315'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = '29c719dc-701b-470f-9e49-fab981722d3f'::uuid
      and content_key = 'apphy1-frq-038'
      and id <> '10507b47-e925-46aa-a244-c72613b623c2'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-038';
  end if;

  if not exists (
    select 1 from app.content_items where id = '10507b47-e925-46aa-a244-c72613b623c2'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '10507b47-e925-46aa-a244-c72613b623c2'::uuid,
      '29c719dc-701b-470f-9e49-fab981722d3f'::uuid,
      'apphy1-frq-038',
      'frq',
      'Mass-spring amplitude and speed',
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
      'b6c26224-709c-4d25-af9d-6c1570536176'::uuid,
      '10507b47-e925-46aa-a244-c72613b623c2'::uuid,
      1,
      'Mass-spring amplitude and speed: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A cart of mass m attached to an ideal horizontal spring of constant k oscillates with amplitude A on a frictionless track. At one instant the cart is at x=A/2 and moving toward equilibrium. A second otherwise identical system has amplitude 2A.',
      '{"content_key":"apphy1-frq-038","subject":"ap_physics_1","unit":7,"topic":"Oscillations","archetype":"Qualitative/Quantitative Translation","difficulty":"Medium","source_fact_pack_id":"1WTHwHrJujEuBzAXsL92zQdnHXlE-cvgsArE_FOVdR1g","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Without first calculating a numerical speed, predict whether the first cart''s kinetic energy at x=A/2 is less than, equal to, or greater than its spring potential energy. Justify using an energy representation.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Derive the speed of the first cart at x=A/2. Then determine the speed of the second cart when it is at x=A, and compare the two speeds.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"A student claims that doubling amplitude doubles the oscillation period because the cart travels twice as far. Evaluate the claim and explain the flaw.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      'At x=A/2 the spring stores one quarter of the total energy, so kinetic energy is three quarters. Energy gives v1=(A/2)sqrt(3k/m); for amplitude 2A at x=A, v2=A sqrt(3k/m)=2v1. The ideal period is amplitude independent.',
      md5('Mass-spring amplitude and speed: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('4eb2ac2b-4d9d-496a-a576-9fca77936707'::uuid, 'b6c26224-709c-4d25-af9d-6c1570536176'::uuid, 'part-a-criterion-01', 'States that the kinetic energy is greater than the spring potential energy.', 1, 'The qualitative comparison is correct.', 'Compare each energy with the fixed total energy.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('af9404c6-2d2e-44f0-af16-8b93e917602b'::uuid, 'b6c26224-709c-4d25-af9d-6c1570536176'::uuid, 'part-a-criterion-02', 'Uses total energy E=(1/2)kA² and spring energy U=(1/2)k(A/2)²=E/4.', 1, 'The energy fractions are correctly represented.', 'Evaluate the spring energy at x=A/2 relative to the amplitude energy.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('079ba7c0-5ab0-4bf7-a585-2dffe5c89987'::uuid, 'b6c26224-709c-4d25-af9d-6c1570536176'::uuid, 'part-a-criterion-03', 'Concludes K=E-U=3E/4, so K>U.', 1, 'The comparison follows explicitly from conservation of energy.', 'Subtract the potential-energy fraction from the total.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('e63e1879-d6e7-4ea4-a500-650e209b06e2'::uuid, 'b6c26224-709c-4d25-af9d-6c1570536176'::uuid, 'part-b-criterion-01', 'Writes (1/2)kA²=(1/2)k(A/2)²+(1/2)mv² for the first cart.', 1, 'The correct energy equation is established.', 'Include both spring and kinetic energy at x=A/2.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('15f9468c-8625-4405-ae6b-bf02e40300b7'::uuid, 'b6c26224-709c-4d25-af9d-6c1570536176'::uuid, 'part-b-criterion-02', 'Obtains v_1=(A/2)sqrt(3k/m).', 1, 'The algebra and square root are correct.', 'Solve the energy equation for the positive speed magnitude.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('972895ec-d96b-41b0-aceb-ffb9f4994b64'::uuid, 'b6c26224-709c-4d25-af9d-6c1570536176'::uuid, 'part-b-criterion-03', 'Obtains v_2=A sqrt(3k/m) at x=A for amplitude 2A and states v_2=2v_1.', 1, 'The second energy calculation and comparison are correct.', 'Use total energy (1/2)k(2A)² and position A.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('88fbefc1-7b4d-4b8d-a7d3-14d8d9602f19'::uuid, 'b6c26224-709c-4d25-af9d-6c1570536176'::uuid, 'part-c-criterion-01', 'States that the claim is incorrect and the period remains 2πsqrt(m/k).', 1, 'The ideal mass-spring period is correctly identified as amplitude independent.', 'Use the period relation for an ideal spring.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('94c7befc-5ae0-4f3b-ab4b-e318c3bd0abd'::uuid, 'b6c26224-709c-4d25-af9d-6c1570536176'::uuid, 'part-c-criterion-02', 'Explains that speeds also scale with amplitude, so the increased distance does not imply increased period.', 1, 'The flaw is addressed physically rather than only by citing a formula.', 'Relate the larger path length to proportionally larger characteristic speeds.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      '8868f785-d7bc-45f4-a89e-b6a3bdbaacae'::uuid,
      'b6c26224-709c-4d25-af9d-6c1570536176'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = 'f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid
      and content_key = 'apphy2-frq-035'
      and id <> '697568c3-dbf3-4b26-ad4f-9f7d99a30153'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-035';
  end if;

  if not exists (
    select 1 from app.content_items where id = '697568c3-dbf3-4b26-ad4f-9f7d99a30153'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '697568c3-dbf3-4b26-ad4f-9f7d99a30153'::uuid,
      'f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,
      'apphy2-frq-035',
      'frq',
      'Charging a capacitor through two resistors',
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
      'a55a9278-aabe-4ad0-a600-478513233e04'::uuid,
      '697568c3-dbf3-4b26-ad4f-9f7d99a30153'::uuid,
      1,
      'Charging a capacitor through two resistors: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'An initially uncharged capacitor C is connected in series with resistors R and 2R and an ideal battery of emf ε. At t=0 an ideal switch is closed. Calculus is not required; you may use the standard charging form q(t)=Q_f(1-e^{-t/τ}).',
      '{"content_key":"apphy2-frq-035","subject":"ap_physics_2","unit":11,"topic":"Electric Circuits","archetype":"Mathematical Routines","difficulty":"Hard","source_fact_pack_id":"10jX6Pmtd6vxhg-iqKAPh56UCyjy5l4kLFZC2AOaUo84","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Derive expressions for the final capacitor charge Q_f, the circuit time constant τ, the current I(t), and the voltage across the resistor 2R as functions of time. Show that Kirchhoff''s loop rule is satisfied.","points":7,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1},{"criterion_key":"part-a-criterion-05","points":1},{"criterion_key":"part-a-criterion-06","points":1},{"criterion_key":"part-a-criterion-07","points":1}]},{"part_key":"part-b","prompt":"Determine the time when the capacitor stores one quarter of its final energy, and determine the energy dissipated in both resistors combined by that time.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]}]}'::jsonb,
      'The series resistance is 3R, so τ=3RC, q=Cε(1-e^{-t/τ}), and I=(ε/3R)e^{-t/τ}. At one quarter of final capacitor energy, V_C=ε/2 and t=3RC ln2. Battery work minus stored energy gives 3Cε²/8 dissipated.',
      md5('Charging a capacitor through two resistors: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('4b126d28-c722-480e-a211-680e68163a22'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-a-criterion-01', 'Identifies the series equivalent resistance as 3R.', 1, 'The two series resistances are added correctly.', 'Add R and 2R because the same current passes through both.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('3dfdc90d-0344-4146-a721-17632fd74854'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-a-criterion-02', 'Identifies the final capacitor voltage as ε and Q_f=Cε.', 1, 'The long-time open-circuit condition is correctly used.', 'At steady state the current is zero, so the capacitor spans the battery emf.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('7f26146a-4a58-4d40-a83a-a73f78759cad'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-a-criterion-03', 'Obtains τ=(3R)C.', 1, 'The RC time constant uses the equivalent series resistance.', 'Use τ=R_eq C.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('ee36eded-d72d-489b-a97a-a31ca3880003'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-a-criterion-04', 'Writes q(t)=Cε(1-e^{-t/(3RC)}).', 1, 'The standard charging form has the correct final charge and time constant.', 'Substitute Q_f and τ into the provided form.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('56ab2d4c-c9b4-4c02-a47d-28c48bd1e6b7'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-a-criterion-05', 'Writes I(t)=ε/(3R)e^{-t/(3RC)}.', 1, 'The charging current has correct initial value and exponential decay.', 'Use I=(ε/3R)e^{-t/τ} or the charge change per time from the standard result.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('e988677b-6812-48c9-a747-4ecc3c093a5a'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-a-criterion-06', 'Writes V_2R(t)=(2ε/3)e^{-t/(3RC)}.', 1, 'Ohm''s law is correctly applied to resistor 2R.', 'Multiply the series current by 2R.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('86e47684-fde9-4409-af64-f44c0179cb1f'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-a-criterion-07', 'Shows V_R+V_2R+V_C=ε at all times.', 1, 'The resistor drops sum to εe^{-t/τ} and the capacitor drop is ε(1-e^{-t/τ}).', 'Substitute all three voltage expressions into the loop equation.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('f07efd33-ec17-435d-a8e3-8bd5c88647e0'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-b-criterion-01', 'Uses U_C/U_final=(V_C/ε)²=1/4 to obtain V_C=ε/2.', 1, 'The quadratic dependence of capacitor energy is applied.', 'One quarter energy corresponds to one half the final voltage.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('67a5eb90-b548-4f3f-a1f8-d62a1fc77eaa'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-b-criterion-02', 'Obtains t=3RC ln 2 from 1-e^{-t/(3RC)}=1/2.', 1, 'The time calculation is algebraically correct.', 'Solve the exponential equation for t.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('04801582-7eed-4f91-a4f1-3775f8cca599'::uuid, 'a55a9278-aabe-4ad0-a600-478513233e04'::uuid, 'part-b-criterion-03', 'Finds combined resistor dissipation E_diss=(1/2)Cε²-(1/8)Cε²=3Cε²/8.', 1, 'Energy delivered/stored is accounted for correctly for the charging process up to this state.', 'Use battery work εq=Cε²/2 at q=Cε/2, then subtract stored energy Cε²/8.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      'a4c0f4b6-59b0-4bed-ad92-719849393316'::uuid,
      'a55a9278-aabe-4ad0-a600-478513233e04'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = 'f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid
      and content_key = 'apphy2-frq-036'
      and id <> 'b827a1b9-7d24-40d7-a50a-2ab74960b081'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-036';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'b827a1b9-7d24-40d7-a50a-2ab74960b081'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'b827a1b9-7d24-40d7-a50a-2ab74960b081'::uuid,
      'f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,
      'apphy2-frq-036',
      'frq',
      'Ideal-gas cycle representations',
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
      '9b662897-f962-449c-ab4b-32d812927ce3'::uuid,
      'b827a1b9-7d24-40d7-a50a-2ab74960b081'::uuid,
      1,
      'Ideal-gas cycle representations: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A fixed amount of monatomic ideal gas begins at state A=(V0,P0). It expands isobarically to B=(2V0,P0), cools isochorically to C=(2V0,P0/2), and returns to A along a straight line in a pressure-versus-volume diagram. Use the convention that work done by the gas is positive.',
      '{"content_key":"apphy2-frq-036","subject":"ap_physics_2","unit":13,"topic":"Thermodynamics","archetype":"Translation Between Representations","difficulty":"Hard","source_fact_pack_id":"10jX6Pmtd6vxhg-iqKAPh56UCyjy5l4kLFZC2AOaUo84","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Draw the complete cycle on labeled P-V axes, indicate its direction, and rank the temperatures at A, B, and C.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Calculate the work done by the gas on each leg and the net work for one cycle. Relate the sign of the net work to the geometry of the P-V graph.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Represent the same cycle on a temperature-versus-volume graph. State whether each segment is linear, horizontal, or curved and justify from the ideal-gas law.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Determine the net heat added to the gas over one complete cycle and explain without calculating heat separately for all three legs.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      'Temperatures follow PV. The net work is the clockwise enclosed area: P0V0-3P0V0/4=P0V0/4. Because the gas returns to its initial state, ΔU_cycle=0 and Q_net=W_net.',
      md5('Ideal-gas cycle representations: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ded23fa0-d8fa-4da5-a0da-60932264bf00'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-a-criterion-01', 'Plots A, B, and C at the specified coordinates and connects them with the stated path shapes.', 1, 'The isobaric, isochoric, and straight-line processes are represented correctly.', 'Place each state first, then draw the three distinct process segments.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('d22f43b5-b9f9-45fb-adf6-c5c2a32299aa'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-a-criterion-02', 'Indicates the cycle direction A→B→C→A.', 1, 'Arrows follow the described sequence.', 'Add direction arrows to all three legs.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('f8de4033-8f79-4d37-a8b7-8f4fbb978948'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-a-criterion-03', 'Uses T∝PV to conclude T_B is greatest and T_A=T_C.', 1, 'The ranking follows the ideal-gas law.', 'Compare the product PV at each labeled state.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('bb1717cc-686a-40c8-a113-f0ad3c1af163'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-b-criterion-01', 'Finds W_AB=P0V0.', 1, 'The isobaric rectangular area is correct.', 'Use W=PΔV on A→B.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('6fb1b9dc-2e79-493a-abb1-961b173f86f9'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-b-criterion-02', 'Finds W_BC=0.', 1, 'The isochoric process has zero volume change.', 'No boundary work occurs at constant volume.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('a4b51823-cc20-455e-af09-2bd4a0593629'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-b-criterion-03', 'Finds W_CA=-(3/4)P0V0 using the average pressure along the straight path.', 1, 'The signed trapezoid area is correct.', 'For a linear P(V), multiply average pressure 3P0/4 by ΔV=-V0.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('f5024283-40fc-4c12-a809-321d27b732d4'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-b-criterion-04', 'Obtains W_net=(1/4)P0V0 and identifies it as the enclosed clockwise area.', 1, 'The net value and positive sign are correct.', 'Sum the three works and connect the result to cycle orientation.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('de43672e-4868-40bc-a866-44a15adce089'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-c-criterion-01', 'Shows A→B as a straight increasing line T=(P0/nR)V.', 1, 'The isobaric relation and endpoints are correct.', 'At constant pressure, temperature is proportional to volume.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('374b493a-b775-4099-abd6-8a1c857089a1'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-c-criterion-02', 'Shows B→C as a vertical segment at V=2V0.', 1, 'The constant-volume path and decreasing temperature are correct.', 'Volume is the horizontal coordinate and remains fixed.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('0221fe53-ac08-4c8e-a5e6-418921f33fe4'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-c-criterion-03', 'Shows C→A as a curved path with T=PV/(nR) using the linearly varying P(V), not as a straight line.', 1, 'The representation correctly translates the straight P-V leg into a generally quadratic T-V relation.', 'Substitute the line equation P(V) into T=PV/(nR).', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('bc3be766-6297-46cb-a92f-a8d93e506d9b'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-d-criterion-01', 'States that the total internal-energy change over a complete cycle is zero.', 1, 'The gas returns to its initial thermodynamic state.', 'Internal energy is a state function.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('faa94964-a7c9-480d-ad4e-a1828d6b9796'::uuid, '9b662897-f962-449c-ab4b-32d812927ce3'::uuid, 'part-d-criterion-02', 'Uses ΔU=Q-W to obtain Q_net=W_net=(1/4)P0V0.', 1, 'The first-law sign convention and final result are correct.', 'Set cycle ΔU to zero and use the calculated net work.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      '2676b634-c037-4979-aca4-589c38dd3752'::uuid,
      '9b662897-f962-449c-ab4b-32d812927ce3'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = 'f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid
      and content_key = 'apphy2-frq-037'
      and id <> 'f50fd54a-da0b-4b47-a981-805c29fe3eb9'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-037';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'f50fd54a-da0b-4b47-a981-805c29fe3eb9'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'f50fd54a-da0b-4b47-a981-805c29fe3eb9'::uuid,
      'f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,
      'apphy2-frq-037',
      'frq',
      'Determining a converging lens focal length',
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
      '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid,
      'f50fd54a-da0b-4b47-a981-805c29fe3eb9'::uuid,
      1,
      'Determining a converging lens focal length: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A student has a converging lens of unknown focal length, an illuminated object, a movable screen, an optical bench with a meter scale, and a ruler. The student can obtain several sharply focused real images.',
      '{"content_key":"apphy2-frq-037","subject":"ap_physics_2","unit":14,"topic":"Geometric Optics","archetype":"Experimental Design and Analysis","difficulty":"Medium","source_fact_pack_id":"10jX6Pmtd6vxhg-iqKAPh56UCyjy5l4kLFZC2AOaUo84","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"State a linearized model based on the thin-lens equation and identify graph variables whose slope or intercept can determine the focal length.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Describe a procedure for obtaining sufficient data, including how object and image distances are measured and how focus is judged.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Explain the graphing analysis, how f and its uncertainty are reported, and two checks that would reveal a measurement or model problem.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]},{"part_key":"part-d","prompt":"The ruler''s zero is displaced by the same amount for every bench-position reading. Determine whether this affects the calculated focal length and justify.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      'Linearizing the thin-lens equation gives 1/d_i=-1/d_o+1/f. The intercept is 1/f and the expected slope is -1. A common bench-coordinate offset cancels from measured separations.',
      md5('Determining a converging lens focal length: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('4fa5dada-44ec-4e29-afb5-65c2ac535a5c'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-a-criterion-01', 'Starts from 1/f=1/d_o+1/d_i and rearranges to a linear relation such as 1/d_i=-1/d_o+1/f.', 1, 'The thin-lens equation is correctly linearized.', 'Choose reciprocal distance variables.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('3c7d0f41-2ddf-4f8f-ad8e-d990e409f036'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-a-criterion-02', 'Identifies a plot of 1/d_i versus 1/d_o with slope -1 and vertical intercept 1/f.', 1, 'The graph variables and parameter extraction are correct.', 'Match the rearranged equation to y=mx+b.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('89f453ba-59f2-4da6-a972-1586d44d7c7b'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-b-criterion-01', 'Uses several object positions with d_o>f, moves the screen to the sharpest image, and records paired d_o and d_i values.', 1, 'The procedure yields multiple real-image data pairs.', 'Vary object distance and refocus the screen for every trial.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('9fd909ca-d1e0-4e25-aec3-7c4511377f60'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-b-criterion-02', 'Measures both distances from the lens''s optical center along the bench and uses a repeatable sharpness criterion.', 1, 'Reference points and focus judgment reduce systematic ambiguity.', 'Use a consistent lens reference and minimize image blur.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('0f8850f6-62d4-4cf7-ab5c-149fbec617c3'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-c-criterion-01', 'Plots 1/d_i vertically versus 1/d_o horizontally and obtains a best-fit line.', 1, 'The reciprocal data and linear fit are correctly specified.', 'Transform every distance pair before fitting.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('dd111a6b-0b59-40fa-a3c5-2ad15d8b74fc'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-c-criterion-02', 'Calculates f=1/b from the fitted vertical intercept b.', 1, 'The focal length is extracted correctly.', 'Take the reciprocal of the intercept, with consistent units.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('08a3291d-e96b-4f41-afb5-facac5a2ff0c'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-c-criterion-03', 'Propagates intercept uncertainty as δf≈δb/b² or uses reciprocal bounds from acceptable extreme fits.', 1, 'A defensible focal-length uncertainty is reported.', 'Convert the intercept uncertainty through f=1/b.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('b3012a02-e197-48e0-a4c5-2c5b763b40a6'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-c-criterion-04', 'Checks that the fitted slope is consistent with -1 and that residuals show no systematic curvature or position trend.', 1, 'Two valid model-quality checks are identified.', 'Compare the slope with theory and inspect residual structure.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('1d3c27e3-9c6e-4f87-a16a-5e05c8c343f0'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-d-criterion-01', 'States that a common additive offset in all absolute position readings does not affect d_o or d_i.', 1, 'The conclusion recognizes that distances are differences of positions.', 'Subtracting two readings cancels the shared zero offset.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('32dd958c-ed09-45da-ad17-6eed290e7b18'::uuid, '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid, 'part-d-criterion-02', 'Concludes that the calculated focal length is unchanged, assuming the lens-center reference is located consistently.', 1, 'The effect on the final analysis is correctly stated with its condition.', 'Connect cancellation of the position offset to unchanged distance pairs.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      'c1e7f944-3a93-45d3-a1de-7d38ebe9adcb'::uuid,
      '91917d13-b66d-4d87-ae62-36fad1da9a7f'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;

  if exists (
    select 1
    from app.content_items
    where exam_pack_version_id = 'f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid
      and content_key = 'apphy2-frq-038'
      and id <> '05a2e860-f468-47d5-aa20-714be34ddfdf'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-038';
  end if;

  if not exists (
    select 1 from app.content_items where id = '05a2e860-f468-47d5-aa20-714be34ddfdf'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '05a2e860-f468-47d5-aa20-714be34ddfdf'::uuid,
      'f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,
      'apphy2-frq-038',
      'frq',
      'Loop entering a magnetic field',
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
      'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid,
      '05a2e860-f468-47d5-aa20-714be34ddfdf'::uuid,
      1,
      'Loop entering a magnetic field: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.',
      'A square conducting loop of side length ℓ and resistance R moves right at constant speed v into a region of uniform magnetic field B directed into the page. At the instant shown, a length x of the loop is inside the field, where 0<x<ℓ. Neglect self-inductance.',
      '{"content_key":"apphy2-frq-038","subject":"ap_physics_2","unit":12,"topic":"Magnetism and Electromagnetic Induction","archetype":"Qualitative/Quantitative Translation","difficulty":"Hard","source_fact_pack_id":"10jX6Pmtd6vxhg-iqKAPh56UCyjy5l4kLFZC2AOaUo84","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["physics-full-scale-frq-structure-2026-07-25"],"parts":[{"part_key":"part-a","prompt":"Predict the direction of the induced current while the loop enters the field and the direction of the magnetic force on the loop. Justify both directions qualitatively.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Derive expressions for the induced current magnitude and the external power required to keep the speed constant while 0<x<ℓ.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Sketch induced current magnitude versus time from before the loop enters until after it is fully inside the uniform field. Explain the principal features.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]}]}'::jsonb,
      'The increasing into-page flux induces a counterclockwise current and a leftward magnetic drag force. During entry, |emf|=Bℓv, I=Bℓv/R, and the required power equals I²R=B²ℓ²v²/R.',
      md5('Loop entering a magnetic field: Answer all mandatory subparts. Show reasoning and calculations clearly. Use standard AP Physics notation and justify qualitative claims.'),
      'assigned',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('97edcd93-c800-4ccd-aec2-89f9d51f553d'::uuid, 'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid, 'part-a-criterion-01', 'States that the induced current is counterclockwise.', 1, 'The current creates a field out of the page.', 'Use Lenz''s law to oppose the increasing into-page flux.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('f33fbf0d-c60a-4e6d-a5fb-58736ac86087'::uuid, 'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid, 'part-a-criterion-02', 'Justifies the current direction by noting that into-page magnetic flux is increasing.', 1, 'The flux change, not merely the field direction, is identified.', 'State how the area inside the field changes.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('339c700c-578c-4114-acac-81f183906bcc'::uuid, 'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid, 'part-a-criterion-03', 'States that the net magnetic force is leftward, opposing the imposed motion.', 1, 'The direction is consistent with magnetic braking and the force on the leading vertical segment.', 'Apply the right-hand rule to the current in the segment inside the field.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('2cecde37-2d41-48f5-aae3-e9ca1d7cf48d'::uuid, 'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid, 'part-b-criterion-01', 'Writes magnetic flux magnitude Φ=Bℓx and dΦ/dt=Bℓv.', 1, 'The changing overlap area is correctly represented.', 'Use overlap area ℓx and dx/dt=v.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('b43acda1-752e-4c5a-a2b4-f30f951d5544'::uuid, 'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid, 'part-b-criterion-02', 'Obtains induced current I=Bℓv/R.', 1, 'Faraday''s law and Ohm''s law are applied correctly.', 'Divide the induced emf Bℓv by R.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('1988346d-ec8e-4b83-a28f-048d5636a98b'::uuid, 'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid, 'part-b-criterion-03', 'Obtains required external power P=B²ℓ²v²/R, using P=I²R or Fv.', 1, 'The mechanical input equals the electrical dissipation at constant speed.', 'Substitute the induced current into I²R.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('85c760f8-19b9-4a91-ae22-e21675d650df'::uuid, 'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid, 'part-c-criterion-01', 'Shows zero current before entry, a constant nonzero plateau during entry lasting ℓ/v, and zero after full entry.', 1, 'The graph has correct levels and timing for the stated interval.', 'Current exists only while the overlap area changes at a constant rate.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb),
      ('8be1f4c5-f985-4f7c-a802-c893a9c3b3a2'::uuid, 'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid, 'part-c-criterion-02', 'Explains that flux is constant both before entry and once the loop is wholly inside the uniform field.', 1, 'The zero-current regions are justified by dΦ/dt=0.', 'Distinguish nonzero flux from changing flux.', '["Equivalent algebraically correct reasoning with consistent signs and units earns credit."]'::jsonb);

    insert into app.content_review_assignments (
      content_review_assignment_id, content_item_version_id, reviewer_id,
      review_stage, status, review_kind
    ) values (
      'e7f6f0bd-2678-401b-ae02-ff033e4acddb'::uuid,
      'a4927b83-25f4-4a24-a539-e5676a9133f7'::uuid,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid,
      'tutor_question',
      'pending',
      'frq'
    );
  end if;
end
$physics_full_scale$;
commit;
