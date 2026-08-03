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
  where ep.exam_code = 'ap_physics_c_mechanics'
    and epv.status = 'published';

  if v_epv_count <> 1 then
    raise exception 'expected_exactly_one_published_exam_pack_version:%:%', 'ap_physics_c_mechanics', v_epv_count;
  end if;

  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_physics_c_mechanics'
    and epv.status = 'published';

  select coalesce(max((regexp_match(content_key, '-frq-([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^apphycm-frq-[0-9]+$';
  if v_max <> 38 then
    raise exception 'unexpected_live_max:apphycm:expected=38:actual=%', v_max;
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-039'
      and id <> '956b409a-bb83-4ae8-ab86-971218981c09'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-039';
  end if;

  if not exists (
    select 1 from app.content_items where id = '956b409a-bb83-4ae8-ab86-971218981c09'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '956b409a-bb83-4ae8-ab86-971218981c09'::uuid,
      v_epv_id,
      'apphycm-frq-039',
      'frq',
      'apphycm-frq-039',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '3ec5acb0-0a30-4f51-a3db-e7a6d108750d'::uuid,
      '956b409a-bb83-4ae8-ab86-971218981c09'::uuid,
      1,
      'Answer all parts of the following question.

(a) Derive expressions for the car''s velocity and position as functions of time, and evaluate both at t = 3.00 s.

(b) Explain how the shape of the car''s velocity-versus-time graph confirms the constant-acceleration assumption used in part (a).',
      'A car starts at position x0 = 2.00 m with initial velocity v0 = 4.00 m/s and moves with constant acceleration 2.50 m/s^2.',
      '{"modules":["unit-1-kinematics","practice-1"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-math","difficulty":"Easy","content_key":"apphycm-frq-039","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Derive expressions for the car''s velocity and position as functions of time, and evaluate both at t = 3.00 s.

(b) Explain how the shape of the car''s velocity-versus-time graph confirms the constant-acceleration assumption used in part (a).'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('0c9392c4-8c79-4617-ac7a-bfa2b1e21e2f'::uuid, '3ec5acb0-0a30-4f51-a3db-e7a6d108750d'::uuid, 'part-a', 'Derives v(t) = v0 + at and x(t) = x0 + v0t + (1/2)at^2, and evaluates v = 11.5 m/s and x = 25.25 m at t = 3.00 s.', 1, 'Both v(t) and x(t) shown with correct numeric evaluation (11.5 m/s and 25.25 m)', 'Substitute t = 3.00 s into v = v0 + at and x = x0 + v0t + (1/2)at^2.', '[]'::jsonb),
      ('365b1a26-d889-40f3-ae41-19315e45f0c0'::uuid, '3ec5acb0-0a30-4f51-a3db-e7a6d108750d'::uuid, 'part-b', 'Explains that a straight-line (constant-slope) velocity-time graph confirms constant acceleration.', 1, 'References constant slope of v-t graph equaling constant acceleration', 'State that the slope of a v-t graph is acceleration, so a straight line means acceleration does not change.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-040'
      and id <> '1a967d2e-89ee-4da7-a56f-7a550e461e00'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-040';
  end if;

  if not exists (
    select 1 from app.content_items where id = '1a967d2e-89ee-4da7-a56f-7a550e461e00'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '1a967d2e-89ee-4da7-a56f-7a550e461e00'::uuid,
      v_epv_id,
      'apphycm-frq-040',
      'frq',
      'apphycm-frq-040',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '9a593723-c834-41d7-a642-185169ff86b6'::uuid,
      '1a967d2e-89ee-4da7-a56f-7a550e461e00'::uuid,
      1,
      'Answer all parts of the following question.

(a) Derive the net force on the box and its acceleration, and evaluate the numeric values.

(b) Explain how Newton''s second law and the constant friction force justify why the box''s acceleration remains constant while it moves.',
      'A 4.00 kg box is pushed horizontally by a 20.0 N applied force while a constant 8.00 N kinetic friction force acts opposite to its motion.',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-2"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-math","difficulty":"Easy","content_key":"apphycm-frq-040","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Derive the net force on the box and its acceleration, and evaluate the numeric values.

(b) Explain how Newton''s second law and the constant friction force justify why the box''s acceleration remains constant while it moves.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('68301437-1899-4144-ab80-244b47b21a78'::uuid, '9a593723-c834-41d7-a642-185169ff86b6'::uuid, 'part-a', 'Derives the net force (12.0 N) and acceleration (3.00 m/s^2).', 1, '12.0 N and 3.00 m/s^2 both shown', 'Subtract friction from the applied force, then divide by mass.', '[]'::jsonb),
      ('ee005b44-4dfc-4c13-a5b7-9cb227ea3a49'::uuid, '9a593723-c834-41d7-a642-185169ff86b6'::uuid, 'part-b', 'Explains the result using Newton''s second law with constant kinetic friction.', 1, 'References F_net = ma and the constant friction assumption', 'State that constant friction gives constant net force, hence constant acceleration.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-041'
      and id <> '15149dc3-1c0e-41b1-a7d6-261b1a438a13'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-041';
  end if;

  if not exists (
    select 1 from app.content_items where id = '15149dc3-1c0e-41b1-a7d6-261b1a438a13'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '15149dc3-1c0e-41b1-a7d6-261b1a438a13'::uuid,
      v_epv_id,
      'apphycm-frq-041',
      'frq',
      'apphycm-frq-041',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '0848b0ee-13be-4237-a309-0d95aa2b5011'::uuid,
      '15149dc3-1c0e-41b1-a7d6-261b1a438a13'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the work done on the cart and use the work-energy theorem to determine its final speed.

(b) Explain why the work-energy theorem correctly predicts this speed even though the cart''s acceleration was never explicitly calculated.',
      'A 2.00 kg cart, initially at rest, is pushed by a constant net force of 6.00 N over a distance of 3.00 m along a frictionless track.',
      '{"modules":["unit-3-work-energy-and-power","practice-3"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-representation","difficulty":"Easy","content_key":"apphycm-frq-041","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the work done on the cart and use the work-energy theorem to determine its final speed.

(b) Explain why the work-energy theorem correctly predicts this speed even though the cart''s acceleration was never explicitly calculated.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('a8100ebc-401f-4653-a61e-59cdd622d610'::uuid, '0848b0ee-13be-4237-a309-0d95aa2b5011'::uuid, 'part-a', 'Calculates W = 18.0 J and uses W = (1/2)mv^2 to find v = 4.24 m/s.', 1, 'W = 18.0 J and v ≈ 4.24 m/s both shown', 'Multiply force by distance for work, then set equal to (1/2)mv^2 and solve for v.', '[]'::jsonb),
      ('3509d161-c936-4422-a16b-cf5298243ab6'::uuid, '0848b0ee-13be-4237-a309-0d95aa2b5011'::uuid, 'part-b', 'Explains that the work-energy theorem relates net work directly to the change in kinetic energy regardless of whether acceleration is constant.', 1, 'References W_net = ΔKE as valid independent of the force/acceleration profile', 'State that W_net = ΔKE holds generally, so acceleration need not be found separately.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-042'
      and id <> '5693c8b9-7070-4de1-a6e4-b776e175b8d1'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-042';
  end if;

  if not exists (
    select 1 from app.content_items where id = '5693c8b9-7070-4de1-a6e4-b776e175b8d1'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '5693c8b9-7070-4de1-a6e4-b776e175b8d1'::uuid,
      v_epv_id,
      'apphycm-frq-042',
      'frq',
      'apphycm-frq-042',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '8523a45f-72e6-4a1e-ab82-c6be2f8a0b56'::uuid,
      '5693c8b9-7070-4de1-a6e4-b776e175b8d1'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the projectile''s horizontal range.

(b) Predict, with justification, whether the range would increase, decrease, or remain the same if the launch angle were instead 60.0 degrees, without recalculating the exact numeric range.',
      'A projectile is launched from ground level at 25.0 m/s at an angle of 30.0 degrees above the horizontal and lands at the same height it was launched from.',
      '{"modules":["unit-1-kinematics","practice-4"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-translation","difficulty":"Medium","content_key":"apphycm-frq-042","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the projectile''s horizontal range.

(b) Predict, with justification, whether the range would increase, decrease, or remain the same if the launch angle were instead 60.0 degrees, without recalculating the exact numeric range.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('010a0d33-6e81-400b-a4ac-d0d68c18fab2'::uuid, '8523a45f-72e6-4a1e-ab82-c6be2f8a0b56'::uuid, 'a-range', 'Calculates the range R = v^2 sin(2θ)/g ≈ 55.2 m.', 1, 'R ≈ 55.2 m shown with correct formula', 'Use R = v^2 sin(2θ)/g with θ = 30.0 degrees.', '[]'::jsonb),
      ('dbb95b3b-e25f-411e-ad5e-df7caac2857a'::uuid, '8523a45f-72e6-4a1e-ab82-c6be2f8a0b56'::uuid, 'b-prediction', 'Predicts the range stays the same at 60.0 degrees.', 1, 'States range is unchanged', 'Compare sin(2*60°) to sin(2*30°).', '[]'::jsonb),
      ('85f720d0-d9f7-4061-afa7-2b986fce5593'::uuid, '8523a45f-72e6-4a1e-ab82-c6be2f8a0b56'::uuid, 'b-justification', 'Justifies using sin(120°) = sin(60°) = sin(2*30°), so complementary launch angles give equal range.', 1, 'References equal sine values for complementary angle pairs', 'Note that 30° and 60° are complementary, and sin(2θ) is the same for complementary θ values.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-043'
      and id <> '01e497ea-2480-44ce-ad9b-f0d8655554a4'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-043';
  end if;

  if not exists (
    select 1 from app.content_items where id = '01e497ea-2480-44ce-ad9b-f0d8655554a4'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '01e497ea-2480-44ce-ad9b-f0d8655554a4'::uuid,
      v_epv_id,
      'apphycm-frq-043',
      'frq',
      'apphycm-frq-043',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '646c17f2-7b63-4a1b-a8f2-fbd82fbda7c2'::uuid,
      '01e497ea-2480-44ce-ad9b-f0d8655554a4'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the block''s acceleration down the incline.

(b) Predict, with justification, how the acceleration would change if the incline angle were increased to 40.0 degrees, and state whether the new acceleration would still be less than g.',
      'A 5.00 kg block slides down a frictionless incline angled at 20.0 degrees above the horizontal.',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-1"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-translation","difficulty":"Medium","content_key":"apphycm-frq-043","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the block''s acceleration down the incline.

(b) Predict, with justification, how the acceleration would change if the incline angle were increased to 40.0 degrees, and state whether the new acceleration would still be less than g.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('dab8ac48-3278-4e68-a0ee-0b050e4031ae'::uuid, '646c17f2-7b63-4a1b-a8f2-fbd82fbda7c2'::uuid, 'a-accel', 'Calculates a = g sin(20°) ≈ 3.35 m/s^2.', 1, 'a ≈ 3.35 m/s^2 shown', 'Use a = g sin(θ) for a frictionless incline.', '[]'::jsonb),
      ('b0d1a5a7-ab2a-4c64-a18e-64e35584bb88'::uuid, '646c17f2-7b63-4a1b-a8f2-fbd82fbda7c2'::uuid, 'b-prediction', 'Predicts the acceleration increases (to about 6.30 m/s^2 at 40°).', 1, 'States acceleration increases with angle', 'Recognize sin(θ) increases as θ increases toward 90°.', '[]'::jsonb),
      ('66a2b9ec-573e-48ec-aa06-ab95d6fdae04'::uuid, '646c17f2-7b63-4a1b-a8f2-fbd82fbda7c2'::uuid, 'b-justification', 'Justifies that a = g sin(θ) remains less than g for any θ < 90° since sin(θ) < 1.', 1, 'References sin(θ) < 1 bounding a below g', 'State that sin(θ) never exceeds 1 for θ < 90°, so a < g always.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-044'
      and id <> '588b2384-9412-433f-a814-14df06bba9d9'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-044';
  end if;

  if not exists (
    select 1 from app.content_items where id = '588b2384-9412-433f-a814-14df06bba9d9'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '588b2384-9412-433f-a814-14df06bba9d9'::uuid,
      v_epv_id,
      'apphycm-frq-044',
      'frq',
      'apphycm-frq-044',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'dec516e7-9c5c-4658-ad3c-c10660dde060'::uuid,
      '588b2384-9412-433f-a814-14df06bba9d9'::uuid,
      1,
      'Answer all parts of the following question.

(a) Use energy conservation to calculate the mass''s maximum speed after leaving the spring.

(b) Predict, with justification, by what factor the maximum speed would change if the compression were instead doubled to 0.200 m.',
      'A 0.500 kg mass on a spring (k = 200 N/m) is compressed 0.100 m from equilibrium and released from rest on a frictionless surface.',
      '{"modules":["unit-3-work-energy-and-power","practice-2"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-translation","difficulty":"Medium","content_key":"apphycm-frq-044","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Use energy conservation to calculate the mass''s maximum speed after leaving the spring.

(b) Predict, with justification, by what factor the maximum speed would change if the compression were instead doubled to 0.200 m.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('f0f44609-efc4-451a-a805-bf741278028e'::uuid, 'dec516e7-9c5c-4658-ad3c-c10660dde060'::uuid, 'a-speed', 'Calculates PE = 1.00 J and v = 2.00 m/s using (1/2)kx^2 = (1/2)mv^2.', 1, 'v = 2.00 m/s shown', 'Set spring PE equal to kinetic energy and solve for v.', '[]'::jsonb),
      ('d21a3039-fa67-4596-a558-429cf0c3c260'::uuid, 'dec516e7-9c5c-4658-ad3c-c10660dde060'::uuid, 'b-factor', 'Predicts the speed doubles to 4.00 m/s.', 1, 'States speed doubles', 'Recognize PE scales with x^2, so quadrupling PE (doubling x) doubles v.', '[]'::jsonb),
      ('2741e83e-e302-4aeb-acaf-4dbf4195925b'::uuid, 'dec516e7-9c5c-4658-ad3c-c10660dde060'::uuid, 'b-justification', 'Justifies that since PE ∝ x^2 and KE = PE, v ∝ x, so doubling compression doubles speed.', 1, 'References v = sqrt(2PE/m) ∝ x', 'Show v = sqrt(kx^2/m) = x*sqrt(k/m), which is linear in x.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-045'
      and id <> '589b39e1-6fdb-45ab-a2aa-5494e85f7f1c'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-045';
  end if;

  if not exists (
    select 1 from app.content_items where id = '589b39e1-6fdb-45ab-a2aa-5494e85f7f1c'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '589b39e1-6fdb-45ab-a2aa-5494e85f7f1c'::uuid,
      v_epv_id,
      'apphycm-frq-045',
      'frq',
      'apphycm-frq-045',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '9b1a8589-e0f4-42f8-ad4a-74ec1151884f'::uuid,
      '589b39e1-6fdb-45ab-a2aa-5494e85f7f1c'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a feasible procedure to test this relation, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain why assuming negligible friction and a constant incline angle throughout each trial justifies applying this kinematics equation to extract the acceleration.',
      'A student wants to experimentally verify the kinematics relation Δx = v0t + (1/2)at^2 for a cart released from rest on an incline.',
      '{"modules":["unit-1-kinematics","practice-3"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-experimental","difficulty":"Medium","content_key":"apphycm-frq-045","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a feasible procedure to test this relation, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain why assuming negligible friction and a constant incline angle throughout each trial justifies applying this kinematics equation to extract the acceleration.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('df285fe2-6c61-47c8-a4fe-f638c853fcaa'::uuid, '9b1a8589-e0f4-42f8-ad4a-74ec1151884f'::uuid, 'a-independent', 'Identifies a valid independent variable.', 1, 'e.g., elapsed time or incline angle', 'Name the variable the experimenter deliberately changes across trials.', '[]'::jsonb),
      ('da9b731c-68dd-424d-a384-026240af44ce'::uuid, '9b1a8589-e0f4-42f8-ad4a-74ec1151884f'::uuid, 'a-dependent', 'Identifies a valid dependent variable.', 1, 'e.g., distance traveled by the cart', 'Name the measured outcome variable.', '[]'::jsonb),
      ('5ebaa3c3-eeec-486d-a104-157ffbec6d5c'::uuid, '9b1a8589-e0f4-42f8-ad4a-74ec1151884f'::uuid, 'a-control', 'Identifies at least one control variable.', 1, 'e.g., cart mass, track surface held fixed', 'Name a variable held fixed across trials.', '[]'::jsonb),
      ('874118e6-d2c8-4cd7-ac32-9608e2c360d2'::uuid, '9b1a8589-e0f4-42f8-ad4a-74ec1151884f'::uuid, 'b-justification', 'Explains that negligible friction and constant angle ensure constant acceleration, which is required for the kinematics equation to apply.', 1, 'References the constant-acceleration assumption underlying the equation', 'State that the equation only holds when acceleration is constant throughout the trial.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-046'
      and id <> 'b6143654-bb3e-47fc-a08f-0d886fed2d39'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-046';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'b6143654-bb3e-47fc-a08f-0d886fed2d39'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'b6143654-bb3e-47fc-a08f-0d886fed2d39'::uuid,
      v_epv_id,
      'apphycm-frq-046',
      'frq',
      'apphycm-frq-046',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'e31750ea-1fb9-4c65-ac1a-84cb64e1ba90'::uuid,
      'b6143654-bb3e-47fc-a08f-0d886fed2d39'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a feasible procedure, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain how the relation μs = tan(θc), obtained from the block''s free-body diagram at the critical angle, justifies extracting μs from the measured critical angle.',
      'A student wants to measure the coefficient of static friction between a wooden block and a ramp by slowly raising the ramp''s angle until the block just begins to slide.',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-4"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-experimental","difficulty":"Medium","content_key":"apphycm-frq-046","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a feasible procedure, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain how the relation μs = tan(θc), obtained from the block''s free-body diagram at the critical angle, justifies extracting μs from the measured critical angle.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('5c0dc18f-83bb-4a39-a189-553b4e792022'::uuid, 'e31750ea-1fb9-4c65-ac1a-84cb64e1ba90'::uuid, 'a-independent', 'Identifies a valid independent variable.', 1, 'e.g., ramp angle', 'Name the variable the experimenter deliberately changes.', '[]'::jsonb),
      ('9f665f42-fe3c-4e3a-a8cd-daab58c87f90'::uuid, 'e31750ea-1fb9-4c65-ac1a-84cb64e1ba90'::uuid, 'a-dependent', 'Identifies a valid dependent variable.', 1, 'e.g., whether the block slides, or the critical angle', 'Name the measured outcome variable.', '[]'::jsonb),
      ('7d3d0f78-93f2-4928-a441-910df9b7c8d5'::uuid, 'e31750ea-1fb9-4c65-ac1a-84cb64e1ba90'::uuid, 'a-control', 'Identifies at least one control variable.', 1, 'e.g., block mass, surface materials held fixed', 'Name a variable held fixed across trials.', '[]'::jsonb),
      ('c971281e-168a-43ca-a52e-ea7a2b8a1cfc'::uuid, 'e31750ea-1fb9-4c65-ac1a-84cb64e1ba90'::uuid, 'b-justification', 'Explains that at the critical angle, mg sin(θc) = μs mg cos(θc), giving μs = tan(θc).', 1, 'References the free-body diagram balance at the critical angle', 'Show that setting the friction force equal to the gravity component along the incline at the critical angle yields μs = tan(θc).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-047'
      and id <> '6492c242-c4b3-4f2e-a48e-88140611d53d'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-047';
  end if;

  if not exists (
    select 1 from app.content_items where id = '6492c242-c4b3-4f2e-a48e-88140611d53d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '6492c242-c4b3-4f2e-a48e-88140611d53d'::uuid,
      v_epv_id,
      'apphycm-frq-047',
      'frq',
      'apphycm-frq-047',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'bc2f6a20-bd16-4ac0-a975-7619f80212b2'::uuid,
      '6492c242-c4b3-4f2e-a48e-88140611d53d'::uuid,
      1,
      'Answer all parts of the following question.

(a) Derive an expression for the particle''s position x(t) by integrating v(t), and evaluate x at t = 2.00 s.

(b) Derive an expression for the particle''s acceleration a(t) by differentiating v(t), and evaluate it at t = 2.00 s.',
      'A particle moves along the x-axis with velocity v(t) = 3.00t^2 - 2.00t (SI units), starting at x(0) = 1.00 m.',
      '{"modules":["unit-1-kinematics","practice-1"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-math","difficulty":"Medium","content_key":"apphycm-frq-047","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Derive an expression for the particle''s position x(t) by integrating v(t), and evaluate x at t = 2.00 s.

(b) Derive an expression for the particle''s acceleration a(t) by differentiating v(t), and evaluate it at t = 2.00 s.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ffeff9bd-8411-4d56-ad51-6ae43d5b9bbf'::uuid, 'bc2f6a20-bd16-4ac0-a975-7619f80212b2'::uuid, 'a-integral', 'Integrates v(t) to get x(t) = 1.00 + t^3 - t^2.', 1, 'Correct antiderivative with constant of integration fixed by x(0) = 1.00 m', 'Integrate 3t^2 - 2t term by term and add the constant from the initial condition.', '[]'::jsonb),
      ('c604b1c6-5fc9-4eca-a99b-51789211ce43'::uuid, 'bc2f6a20-bd16-4ac0-a975-7619f80212b2'::uuid, 'a-evaluate', 'Evaluates x(2.00 s) = 5.00 m.', 1, 'x = 5.00 m shown', 'Substitute t = 2.00 s into x(t).', '[]'::jsonb),
      ('497af8ff-fe71-4efa-a7b5-b02d405f07a6'::uuid, 'bc2f6a20-bd16-4ac0-a975-7619f80212b2'::uuid, 'b-derivative', 'Differentiates v(t) to get a(t) = 6.00t - 2.00.', 1, 'Correct derivative shown', 'Take dv/dt of 3t^2 - 2t.', '[]'::jsonb),
      ('b828176d-6e6f-4c1d-a2dc-8c241c0855fc'::uuid, 'bc2f6a20-bd16-4ac0-a975-7619f80212b2'::uuid, 'b-evaluate', 'Evaluates a(2.00 s) = 10.0 m/s^2.', 1, 'a = 10.0 m/s^2 shown', 'Substitute t = 2.00 s into a(t).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-048'
      and id <> 'f7c08bcc-1793-4010-a88a-f1d5bb7e3679'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-048';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'f7c08bcc-1793-4010-a88a-f1d5bb7e3679'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'f7c08bcc-1793-4010-a88a-f1d5bb7e3679'::uuid,
      v_epv_id,
      'apphycm-frq-048',
      'frq',
      'apphycm-frq-048',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'ac0cef4b-5aa4-48f3-a2ca-973ad5359492'::uuid,
      'f7c08bcc-1793-4010-a88a-f1d5bb7e3679'::uuid,
      1,
      'Answer all parts of the following question.

(a) Derive expressions for the system''s acceleration and the string tension, and evaluate their numeric values.

(b) Explain, using Newton''s second law applied to each block, why the tension is not equal to either block''s weight.',
      'Two blocks, m1 = 3.00 kg and m2 = 5.00 kg, are connected by a light string over a frictionless, massless pulley (an Atwood machine).',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-2"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-math","difficulty":"Medium","content_key":"apphycm-frq-048","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Derive expressions for the system''s acceleration and the string tension, and evaluate their numeric values.

(b) Explain, using Newton''s second law applied to each block, why the tension is not equal to either block''s weight.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('f4a6387f-9990-465d-a264-44907c19dfc2'::uuid, 'ac0cef4b-5aa4-48f3-a2ca-973ad5359492'::uuid, 'a-accel', 'Derives a = (m2 - m1)g/(m1 + m2) and evaluates a ≈ 2.45 m/s^2.', 1, 'a ≈ 2.45 m/s^2 shown', 'Apply Newton''s second law to the two-block system to isolate a.', '[]'::jsonb),
      ('b44a6580-bb33-478e-a54b-0dec920d2003'::uuid, 'ac0cef4b-5aa4-48f3-a2ca-973ad5359492'::uuid, 'a-tension', 'Derives the tension and evaluates T ≈ 36.75 N.', 1, 'T ≈ 36.75 N shown, consistent for both blocks', 'Apply Newton''s second law to one block alone using the acceleration found in part (a).', '[]'::jsonb),
      ('7b54422a-966c-474a-aaf4-43b23c35f2fc'::uuid, 'ac0cef4b-5aa4-48f3-a2ca-973ad5359492'::uuid, 'b-explanation', 'Explains that since both blocks accelerate, the net force on each is nonzero, so tension must differ from each block''s weight.', 1, 'References m1(g+a) = m2(g-a) = T ≠ m1g, m2g', 'Apply F_net = ma to each block individually and show T is not equal to either weight.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-049'
      and id <> 'ceb5ccb4-7b72-4473-ae9b-88fe38ad0124'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-049';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'ceb5ccb4-7b72-4473-ae9b-88fe38ad0124'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'ceb5ccb4-7b72-4473-ae9b-88fe38ad0124'::uuid,
      v_epv_id,
      'apphycm-frq-049',
      'frq',
      'apphycm-frq-049',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f'::uuid,
      'ceb5ccb4-7b72-4473-ae9b-88fe38ad0124'::uuid,
      1,
      'Answer all parts of the following question.

(a) Derive an expression for the work done by this force as the particle moves from x = 0 to a general position x, and evaluate the work done from x = 0 to x = 2.00 m.

(b) Using the work-energy theorem, derive an expression for the particle''s speed as a function of x, and evaluate the speed at x = 2.00 m.

(c) Determine the position x at which the particle''s kinetic energy is maximum, and justify your answer using the force expression.',
      'A particle of mass 2.00 kg moves along the x-axis under a force F(x) = -4.00x + 10.0 (SI units), starting at x = 0 with v0 = 1.00 m/s.',
      '{"modules":["unit-3-work-energy-and-power","practice-3"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-math","difficulty":"Hard","content_key":"apphycm-frq-049","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Derive an expression for the work done by this force as the particle moves from x = 0 to a general position x, and evaluate the work done from x = 0 to x = 2.00 m.

(b) Using the work-energy theorem, derive an expression for the particle''s speed as a function of x, and evaluate the speed at x = 2.00 m.

(c) Determine the position x at which the particle''s kinetic energy is maximum, and justify your answer using the force expression.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('7592dc56-e8fb-46be-aeaa-cafb08f308c9'::uuid, 'abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f'::uuid, 'a-integral-setup', 'Sets up W(x) = ∫0^x F(x'') dx'' = ∫0^x (-4.00x'' + 10.0) dx''.', 1, 'Correct integral of the given force expression', 'Integrate F(x) with respect to position from 0 to x.', '[]'::jsonb),
      ('a9507465-1d9f-424b-aa15-fc6fe9796b37'::uuid, 'abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f'::uuid, 'a-evaluate', 'Evaluates W(x) = -2.00x^2 + 10.0x and finds W(0→2.00 m) = 12.0 J.', 1, 'W = 12.0 J shown', 'Substitute x = 2.00 m into the antiderivative -2x^2 + 10x.', '[]'::jsonb),
      ('a7b4f50c-b018-48c2-a50b-405c17130169'::uuid, 'abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f'::uuid, 'b-express-vx', 'Uses the work-energy theorem KE(x) = KE0 + W(x) to derive v(x) = sqrt(1.00 - 2.00x^2 + 10.0x).', 1, 'Correct expression combining initial KE and W(x)', 'Add W(x) to the initial kinetic energy (1.00 J) and solve (1/2)mv^2 = KE(x) for v.', '[]'::jsonb),
      ('5cbd1800-a845-4f18-a09d-1cead51a8ac8'::uuid, 'abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f'::uuid, 'b-evaluate', 'Evaluates v(2.00 m) = sqrt(13.0) ≈ 3.61 m/s.', 1, 'v ≈ 3.61 m/s shown', 'Substitute x = 2.00 m into v(x).', '[]'::jsonb),
      ('7f8b9a6b-20b3-4e2e-a60d-a248b2405a4c'::uuid, 'abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f'::uuid, 'c-identify-justify', 'Determines KE (and speed) is maximum at x = 2.50 m, justified because F(x) = 0 there (net force changes from positive to negative).', 1, 'x = 2.50 m identified with reasoning that dKE/dx = F(x) = 0 at a maximum', 'Set F(x) = 0 and solve for x, noting F is positive before and negative after this point.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-050'
      and id <> '56afb2f1-0a71-407f-ae78-48a417ccdf92'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-050';
  end if;

  if not exists (
    select 1 from app.content_items where id = '56afb2f1-0a71-407f-ae78-48a417ccdf92'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '56afb2f1-0a71-407f-ae78-48a417ccdf92'::uuid,
      v_epv_id,
      'apphycm-frq-050',
      'frq',
      'apphycm-frq-050',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '8e3d19be-4792-4fc0-a1d4-32d4a3c889d3'::uuid,
      '56afb2f1-0a71-407f-ae78-48a417ccdf92'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the tension in the string at the top of the circle, and calculate the minimum speed at the top required to keep the string taut.

(b) Explain, using Newton''s second law, why the string''s tension is smallest at the top of the circle compared to other points along the path.

(c) Using energy conservation, calculate the ball''s speed at the bottom of the circle and the string tension there.',
      'A 0.400 kg ball on a string moves in a vertical circle of radius 0.800 m, passing through the top of the circle with speed 3.00 m/s.',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-4"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-representation","difficulty":"Hard","content_key":"apphycm-frq-050","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the tension in the string at the top of the circle, and calculate the minimum speed at the top required to keep the string taut.

(b) Explain, using Newton''s second law, why the string''s tension is smallest at the top of the circle compared to other points along the path.

(c) Using energy conservation, calculate the ball''s speed at the bottom of the circle and the string tension there.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('7b37c11c-0cdf-44af-a705-58802b22b762'::uuid, '8e3d19be-4792-4fc0-a1d4-32d4a3c889d3'::uuid, 'a-tension-top', 'Calculates tension at the top T = mv^2/r - mg ≈ 0.58 N.', 1, 'T ≈ 0.58 N shown using both gravity and tension pointing toward center', 'At the top, both gravity and tension point toward the center, so mg + T = mv^2/r.', '[]'::jsonb),
      ('5afedc40-3ad1-48cd-ae17-b9c0d170a972'::uuid, '8e3d19be-4792-4fc0-a1d4-32d4a3c889d3'::uuid, 'a-vmin', 'Calculates the minimum speed v_min = sqrt(gr) ≈ 2.80 m/s (where T = 0).', 1, 'v_min ≈ 2.80 m/s shown', 'Set T = 0 in mg = mv^2/r and solve for v.', '[]'::jsonb),
      ('56ab7eb0-a6a9-4b62-a84c-0ccc4de2fa56'::uuid, '8e3d19be-4792-4fc0-a1d4-32d4a3c889d3'::uuid, 'b-explanation', 'Explains tension is smallest at the top because gravity contributes toward the centripetal force there, requiring less tension to supply the same net centripetal force.', 1, 'References gravity assisting centripetal force at the top versus opposing it at the bottom', 'Compare the free-body diagram at the top (gravity helps) to the bottom (gravity opposes tension).', '[]'::jsonb),
      ('f1da00ef-0461-4f4c-a2e8-45051db8d969'::uuid, '8e3d19be-4792-4fc0-a1d4-32d4a3c889d3'::uuid, 'c-vbottom', 'Uses energy conservation (v_bottom^2 = v_top^2 + 4gr) to find v_bottom ≈ 6.35 m/s.', 1, 'v_bottom ≈ 6.35 m/s shown', 'Apply conservation of energy between the top and bottom, a height difference of 2r.', '[]'::jsonb),
      ('8e2c2c33-28cd-449f-ada6-af3e02049c04'::uuid, '8e3d19be-4792-4fc0-a1d4-32d4a3c889d3'::uuid, 'c-tension-bottom', 'Calculates the tension at the bottom T = mg + mv_bottom^2/r ≈ 24.1 N.', 1, 'T ≈ 24.1 N shown', 'At the bottom, tension and gravity are opposite, so T - mg = mv_bottom^2/r.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-051'
      and id <> '3a8b2b19-753a-4069-a536-f8b513054019'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-051';
  end if;

  if not exists (
    select 1 from app.content_items where id = '3a8b2b19-753a-4069-a536-f8b513054019'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '3a8b2b19-753a-4069-a536-f8b513054019'::uuid,
      v_epv_id,
      'apphycm-frq-051',
      'frq',
      'apphycm-frq-051',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9'::uuid,
      '3a8b2b19-753a-4069-a536-f8b513054019'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the spring''s initial potential energy, the work done by friction over the 0.200 m contact distance, and the block''s speed as it leaves the spring.

(b) Explain, in terms of energy conservation with a non-conservative force present, why the block''s kinetic energy at departure is less than the spring''s initial potential energy, and identify what happens to the missing energy.',
      'A 1.50 kg block is pushed against a spring (k = 300 N/m), compressing it 0.200 m, then released on a horizontal surface where a 0.250 coefficient of kinetic friction acts over the 0.200 m distance the block travels while in contact with the spring.',
      '{"modules":["unit-3-work-energy-and-power","practice-1"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-representation","difficulty":"Hard","content_key":"apphycm-frq-051","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the spring''s initial potential energy, the work done by friction over the 0.200 m contact distance, and the block''s speed as it leaves the spring.

(b) Explain, in terms of energy conservation with a non-conservative force present, why the block''s kinetic energy at departure is less than the spring''s initial potential energy, and identify what happens to the missing energy.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('51832ac5-ddb9-4a62-a47f-8235234fecbd'::uuid, 'e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9'::uuid, 'a-pe', 'Calculates spring PE = (1/2)kx^2 = 6.00 J.', 1, 'PE = 6.00 J shown', 'Substitute k = 300 N/m and x = 0.200 m into (1/2)kx^2.', '[]'::jsonb),
      ('4415efe8-e0a9-4ac0-a1cf-e51abd6c7cd1'::uuid, 'e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9'::uuid, 'a-friction-work', 'Calculates the magnitude of friction''s work, |W_friction| = μmg(0.200 m) ≈ 0.735 J.', 1, 'W_friction ≈ 0.735 J shown', 'Compute the friction force μmg, then multiply by the 0.200 m distance.', '[]'::jsonb),
      ('2cda746b-1c23-4320-a433-b923525bb549'::uuid, 'e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9'::uuid, 'a-speed', 'Uses KE_final = PE - |W_friction| to find v ≈ 2.65 m/s.', 1, 'v ≈ 2.65 m/s shown', 'Subtract the friction work from the spring PE, then solve (1/2)mv^2 = KE_final for v.', '[]'::jsonb),
      ('320e916b-9fdb-4b9a-acb1-c98e96c3a077'::uuid, 'e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9'::uuid, 'b-explanation', 'Explains that friction removes mechanical energy from the block-spring system, converting it to thermal energy, so KE_final < PE_initial.', 1, 'References energy conservation with a non-conservative (friction) force and conversion to thermal energy', 'State that mechanical energy is not conserved when friction does negative work; the lost energy becomes heat.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-052'
      and id <> 'd297ccd0-25a7-4d0c-a9b1-e7f69a3a3ca0'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-052';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'd297ccd0-25a7-4d0c-a9b1-e7f69a3a3ca0'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'd297ccd0-25a7-4d0c-a9b1-e7f69a3a3ca0'::uuid,
      v_epv_id,
      'apphycm-frq-052',
      'frq',
      'apphycm-frq-052',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '9ce7016b-120e-40b3-ae00-389655a71989'::uuid,
      'd297ccd0-25a7-4d0c-a9b1-e7f69a3a3ca0'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a feasible procedure to determine how the terminal speed of the falling filters depends on their total weight, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain how comparing measured terminal speed squared to weight would allow the student to test whether the drag force is proportional to speed squared rather than to speed.',
      'A student wants to experimentally determine how the drag force on a falling coffee filter depends on its speed, using stacked filters to vary weight while keeping shape and cross-sectional area constant.',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-2"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-experimental","difficulty":"Hard","content_key":"apphycm-frq-052","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a feasible procedure to determine how the terminal speed of the falling filters depends on their total weight, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain how comparing measured terminal speed squared to weight would allow the student to test whether the drag force is proportional to speed squared rather than to speed.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('9c5ddcc5-cbf4-432d-a6f3-72604672eaf4'::uuid, '9ce7016b-120e-40b3-ae00-389655a71989'::uuid, 'a-independent', 'Identifies a valid independent variable.', 1, 'e.g., number of stacked filters (total weight)', 'Name the variable the experimenter deliberately changes.', '[]'::jsonb),
      ('01d93974-bfee-4770-af7c-f4b9a0cff927'::uuid, '9ce7016b-120e-40b3-ae00-389655a71989'::uuid, 'a-dependent', 'Identifies a valid dependent variable.', 1, 'e.g., measured terminal (constant) fall speed', 'Name the measured outcome variable.', '[]'::jsonb),
      ('f2cc98a7-904c-424b-a8b8-c70bed730230'::uuid, '9ce7016b-120e-40b3-ae00-389655a71989'::uuid, 'a-control', 'Identifies at least one control variable.', 1, 'e.g., filter shape, cross-sectional area, drop height held fixed', 'Name a variable held fixed across trials.', '[]'::jsonb),
      ('b5e79fdb-4e82-48d3-a6c3-06d6372d3af2'::uuid, '9ce7016b-120e-40b3-ae00-389655a71989'::uuid, 'b-explanation', 'Explains that at terminal speed, weight equals drag, so if drag ∝ v^2, weight should be proportional to v_terminal^2 (a linear relationship when plotted); a linear-drag model instead predicts weight ∝ v_terminal.', 1, 'References mg = drag at terminal velocity and comparing the two proposed proportionalities against the data trend', 'Plot weight versus v_terminal^2 and versus v_terminal, and see which produces a straight line through the origin.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-053'
      and id <> '96c7ea12-4141-4750-a40e-76e008df1852'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-053';
  end if;

  if not exists (
    select 1 from app.content_items where id = '96c7ea12-4141-4750-a40e-76e008df1852'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '96c7ea12-4141-4750-a40e-76e008df1852'::uuid,
      v_epv_id,
      'apphycm-frq-053',
      'frq',
      'apphycm-frq-053',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '7e27c05d-5357-440a-ad64-4e8b0fbbc4b5'::uuid,
      '96c7ea12-4141-4750-a40e-76e008df1852'::uuid,
      1,
      'Answer all parts of the following question.

(a) Solve the differential equation by separation of variables to derive v(t), and evaluate the terminal velocity as t approaches infinity.

(b) Predict, with justification using your derived expression, how the time needed to reach 90% of terminal velocity would change if b were doubled while m is held fixed.',
      'A 0.200 kg object falls from rest through a fluid where the net force is F_net = mg - bv, with b = 2.00 kg/s, giving m(dv/dt) = mg - bv.',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-3"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-translation","difficulty":"Hard","content_key":"apphycm-frq-053","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Solve the differential equation by separation of variables to derive v(t), and evaluate the terminal velocity as t approaches infinity.

(b) Predict, with justification using your derived expression, how the time needed to reach 90% of terminal velocity would change if b were doubled while m is held fixed.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('d96ff0d0-5ab3-496d-a8bd-31bb3e6508f2'::uuid, '7e27c05d-5357-440a-ad64-4e8b0fbbc4b5'::uuid, 'a-separate', 'Separates variables as dv/(g - (b/m)v) = dt in preparation for integration.', 1, 'Correct separated differential form shown', 'Divide both sides of m(dv/dt) = mg - bv by m and rearrange to isolate dv and dt.', '[]'::jsonb),
      ('310017ac-5a39-44c4-aa26-48f3b3a44691'::uuid, '7e27c05d-5357-440a-ad64-4e8b0fbbc4b5'::uuid, 'a-solve', 'Solves to get v(t) = (mg/b)(1 - e^(-(b/m)t)).', 1, 'Correct exponential solution shown', 'Integrate both sides and apply the initial condition v(0) = 0 to fix the constant.', '[]'::jsonb),
      ('f5f31254-ed62-4ad4-a391-3c04e4ca117a'::uuid, '7e27c05d-5357-440a-ad64-4e8b0fbbc4b5'::uuid, 'a-vterminal', 'Evaluates v_terminal = mg/b ≈ 0.98 m/s as t → ∞.', 1, 'v_terminal ≈ 0.98 m/s shown', 'Take the limit of v(t) as t → ∞, noting the exponential term vanishes.', '[]'::jsonb),
      ('458f6240-87e9-49cb-a825-e7e0a6eda8cf'::uuid, '7e27c05d-5357-440a-ad64-4e8b0fbbc4b5'::uuid, 'b-prediction', 'Predicts the time to reach 90% of terminal velocity would be halved if b doubles.', 1, 'States the time is cut in half', 'Use t_90% = ln(10)/(b/m) and see how it changes when b doubles with m fixed.', '[]'::jsonb),
      ('f9466f2c-2b4b-4982-aea6-a2ae04204c3e'::uuid, '7e27c05d-5357-440a-ad64-4e8b0fbbc4b5'::uuid, 'b-justification', 'Justifies using t_90% = m ln(10)/b, which is inversely proportional to b, so doubling b halves t_90%.', 1, 'References the inverse proportionality between t_90% and b', 'Derive t_90% by setting 1 - e^(-(b/m)t) = 0.90 and solving for t explicitly in terms of b and m.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-054'
      and id <> '943c36a0-15c7-47fd-a62c-8020696f4352'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-054';
  end if;

  if not exists (
    select 1 from app.content_items where id = '943c36a0-15c7-47fd-a62c-8020696f4352'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '943c36a0-15c7-47fd-a62c-8020696f4352'::uuid,
      v_epv_id,
      'apphycm-frq-054',
      'frq',
      'apphycm-frq-054',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a8f725f4-0a18-480c-ac25-53ea5b5fa382'::uuid,
      '943c36a0-15c7-47fd-a62c-8020696f4352'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a feasible procedure to measure the person''s average power output while climbing the stairs, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain how the relation P_avg = mgh/Δt, obtained from the work-energy principle, justifies computing power from the measured quantities.',
      'A student wants to measure the average power a person delivers while climbing a flight of stairs of known height, using a stopwatch and the person''s mass.',
      '{"modules":["unit-3-work-energy-and-power","practice-4"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-experimental","difficulty":"Hard","content_key":"apphycm-frq-054","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a feasible procedure to measure the person''s average power output while climbing the stairs, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain how the relation P_avg = mgh/Δt, obtained from the work-energy principle, justifies computing power from the measured quantities.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('82137986-8197-4933-a1c3-d04342deadbb'::uuid, 'a8f725f4-0a18-480c-ac25-53ea5b5fa382'::uuid, 'a-independent', 'Identifies a valid independent variable.', 1, 'e.g., person climbing, or number of stairs climbed', 'Name the variable the experimenter deliberately changes or manipulates across trials.', '[]'::jsonb),
      ('802b64a8-39fd-47d4-a86e-3c25e0d43b2e'::uuid, 'a8f725f4-0a18-480c-ac25-53ea5b5fa382'::uuid, 'a-dependent', 'Identifies a valid dependent variable.', 1, 'e.g., time to climb the stairs', 'Name the measured outcome variable.', '[]'::jsonb),
      ('da55d0de-618a-4a79-af3a-d0bca4fbda9d'::uuid, 'a8f725f4-0a18-480c-ac25-53ea5b5fa382'::uuid, 'a-control', 'Identifies at least one control variable.', 1, 'e.g., stair height, climbing method held fixed', 'Name a variable held fixed across trials.', '[]'::jsonb),
      ('74e50e15-0896-4108-a3be-8b57b6899f0e'::uuid, 'a8f725f4-0a18-480c-ac25-53ea5b5fa382'::uuid, 'b-explanation', 'Explains that the work done against gravity is mgh, and dividing by the time interval gives average power, consistent with P = W/Δt.', 1, 'References W = mgh and P_avg = W/Δt', 'Show that the work-energy principle gives W = mgh for a height gain h, then divide by the elapsed time to get average power.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-055'
      and id <> 'a57ce191-b361-492f-a5f6-55c1ee997251'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-055';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'a57ce191-b361-492f-a5f6-55c1ee997251'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'a57ce191-b361-492f-a5f6-55c1ee997251'::uuid,
      v_epv_id,
      'apphycm-frq-055',
      'frq',
      'apphycm-frq-055',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '2831a162-0225-4ad1-a1f2-ec02af4d0edd'::uuid,
      'a57ce191-b361-492f-a5f6-55c1ee997251'::uuid,
      1,
      'Answer all parts of the following question.

(a) Derive expressions for v(t) and x(t), and evaluate both at t = 3.00 s.

(b) Determine the first time t > 0 at which the particle''s velocity is zero, and state whether the particle is speeding up or slowing down immediately after that instant, justifying your answer using the sign of the acceleration at that time.',
      'A particle moves along the x-axis with acceleration a(t) = 6.00t - 4.00 (SI units), starting at x(0) = 0 and v(0) = 1.00 m/s.',
      '{"modules":["unit-1-kinematics","practice-1"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-math","difficulty":"Hard","content_key":"apphycm-frq-055","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Derive expressions for v(t) and x(t), and evaluate both at t = 3.00 s.

(b) Determine the first time t > 0 at which the particle''s velocity is zero, and state whether the particle is speeding up or slowing down immediately after that instant, justifying your answer using the sign of the acceleration at that time.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('40b9efb3-df94-482d-ac3e-c31871545e5d'::uuid, '2831a162-0225-4ad1-a1f2-ec02af4d0edd'::uuid, 'a-vt-formula', 'Integrates a(t) to derive v(t) = 1.00 + 3.00t^2 - 4.00t.', 1, 'Correct antiderivative with v(0) = 1.00 m/s applied', 'Integrate a(t) with respect to t and use v(0) = 1.00 m/s to fix the constant.', '[]'::jsonb),
      ('49aff40f-4244-4fdc-afad-9e4d24c76345'::uuid, '2831a162-0225-4ad1-a1f2-ec02af4d0edd'::uuid, 'a-xt-formula', 'Integrates v(t) to derive x(t) = t + t^3 - 2.00t^2.', 1, 'Correct antiderivative with x(0) = 0 applied', 'Integrate v(t) with respect to t and use x(0) = 0 to fix the constant.', '[]'::jsonb),
      ('fa443169-6a80-41cd-ae66-61baebc0ce89'::uuid, '2831a162-0225-4ad1-a1f2-ec02af4d0edd'::uuid, 'a-evaluate', 'Evaluates v(3.00 s) = 16.0 m/s and x(3.00 s) = 12.0 m.', 1, 'Both v = 16.0 m/s and x = 12.0 m shown', 'Substitute t = 3.00 s into v(t) and x(t).', '[]'::jsonb),
      ('a8dfc73a-8b1d-4652-ab51-4e02357cfd2c'::uuid, '2831a162-0225-4ad1-a1f2-ec02af4d0edd'::uuid, 'b-find-t', 'Solves 3.00t^2 - 4.00t + 1.00 = 0 to find the first positive root t = 1/3 s.', 1, 't = 1/3 s ≈ 0.333 s identified as the first zero of v(t)', 'Set v(t) = 0 and solve the quadratic, taking the smaller positive root.', '[]'::jsonb),
      ('cd40475e-8052-49ca-ad07-76ec664b9bf4'::uuid, '2831a162-0225-4ad1-a1f2-ec02af4d0edd'::uuid, 'b-justify', 'States the particle speeds up after t = 1/3 s because a(1/3 s) = -2.00 m/s^2 is nonzero, so the particle immediately accelerates away from rest in the negative x-direction.', 1, 'References the nonzero acceleration at t = 1/3 s causing speed to increase from zero', 'Evaluate a(t) at t = 1/3 s and note that a nonzero acceleration at v = 0 means the object cannot remain at rest and its speed increases.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-056'
      and id <> '8b4fd9b0-70fe-46fb-af5f-f147665e3fcf'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-056';
  end if;

  if not exists (
    select 1 from app.content_items where id = '8b4fd9b0-70fe-46fb-af5f-f147665e3fcf'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '8b4fd9b0-70fe-46fb-af5f-f147665e3fcf'::uuid,
      v_epv_id,
      'apphycm-frq-056',
      'frq',
      'apphycm-frq-056',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7'::uuid,
      '8b4fd9b0-70fe-46fb-af5f-f147665e3fcf'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a feasible procedure using measured maximum block speeds for several different initial compressions to distinguish between the linear (Hookean) model and the model including the cubic term, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain how comparing the measured relationship between maximum speed and compression distance to the work-energy-theorem prediction (1/2)mv_max^2 = ∫0^x0 F(x) dx, evaluated for each candidate model, allows the student to determine whether β is significantly different from zero.

(c) Explain why testing multiple compression distances, rather than just one, is essential for distinguishing the two models, given that both models predict nearly identical potential energy at sufficiently small x0.',
      'A student has a spring-like device suspected of exerting a nonlinear restoring force F(x) = -kx - βx^3 rather than an ideal Hookean force, and wants to test this using a block sliding on a frictionless horizontal track.',
      '{"modules":["unit-3-work-energy-and-power","practice-2"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-experimental","difficulty":"Very Hard","content_key":"apphycm-frq-056","total_points":6}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a feasible procedure using measured maximum block speeds for several different initial compressions to distinguish between the linear (Hookean) model and the model including the cubic term, identifying the independent variable, the dependent variable, and one control variable.

(b) Explain how comparing the measured relationship between maximum speed and compression distance to the work-energy-theorem prediction (1/2)mv_max^2 = ∫0^x0 F(x) dx, evaluated for each candidate model, allows the student to determine whether β is significantly different from zero.

(c) Explain why testing multiple compression distances, rather than just one, is essential for distinguishing the two models, given that both models predict nearly identical potential energy at sufficiently small x0.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('c0e25894-4e06-42ab-a0b5-3389633dc4ad'::uuid, 'dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7'::uuid, 'a-independent', 'Identifies a valid independent variable.', 1, 'e.g., initial compression distance x0', 'Name the variable the experimenter deliberately changes across trials.', '[]'::jsonb),
      ('24a8bffc-af43-4a0f-aec2-b92261eae299'::uuid, 'dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7'::uuid, 'a-dependent', 'Identifies a valid dependent variable.', 1, 'e.g., measured maximum speed of the block', 'Name the measured outcome variable.', '[]'::jsonb),
      ('9ff43991-89b9-4c32-a59e-c09f7de1b7de'::uuid, 'dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7'::uuid, 'a-control', 'Identifies at least one control variable.', 1, 'e.g., block mass, track friction held fixed/negligible', 'Name a variable held fixed across trials.', '[]'::jsonb),
      ('f2226810-c07b-4fd4-ae4b-eecf626763ce'::uuid, 'dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7'::uuid, 'b-setup', 'Explains that integrating F(x) for each candidate model (with and without the βx^3 term) over the same compression predicts different work-energy-theorem values of v_max, giving two testable curves of v_max versus x0.', 1, 'References computing ∫F(x)dx for both models and converting to predicted v_max via the work-energy theorem', 'Integrate each candidate F(x) from 0 to x0 and set the result equal to (1/2)mv_max^2 to predict v_max(x0) for each model.', '[]'::jsonb),
      ('a079c97b-950f-477b-ac40-128e4647ce6d'::uuid, 'dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7'::uuid, 'b-determine-beta', 'Explains that comparing the measured v_max(x0) curve to the two predicted curves reveals whether the data deviates from the linear-only prediction, indicating β ≠ 0.', 1, 'References statistically comparing measured data to both model predictions to assess deviation', 'Check whether the measured curve matches the linear-only prediction or systematically deviates in the direction predicted by the cubic term.', '[]'::jsonb),
      ('2a68c508-a6b8-4028-afc4-1d14072d7e0f'::uuid, 'dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7'::uuid, 'c-multiple-distances', 'Explains that at small x0 the x^3 term is negligible compared to the linear term, so the two models are indistinguishable there; only at larger x0 does the cubic term produce a measurable deviation, so multiple compressions spanning a range are needed.', 1, 'References the x^3 term becoming significant only at larger compressions', 'Note that βx0^3 is much smaller than kx0 when x0 is small, so the two models only diverge noticeably at larger x0.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-057'
      and id <> 'ab10b48b-f368-4696-a04d-58358ed35299'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-057';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'ab10b48b-f368-4696-a04d-58358ed35299'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'ab10b48b-f368-4696-a04d-58358ed35299'::uuid,
      v_epv_id,
      'apphycm-frq-057',
      'frq',
      'apphycm-frq-057',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '545aac5a-734b-4824-a159-45cb002d3744'::uuid,
      'ab10b48b-f368-4696-a04d-58358ed35299'::uuid,
      1,
      'Answer all parts of the following question.

(a) Using Newton''s second law written as mv(dv/dx) = -cv^2, derive by separation of variables an expression for the car''s speed as a function of distance traveled after braking begins, and evaluate the distance required for the speed to drop to half its initial value (10.0 m/s).

(b) Predict, with justification using your derived expression, whether the distance needed to reach half speed would change if the initial speed were instead 40.0 m/s.',
      'A 1000 kg car moving at 20.0 m/s experiences a speed-dependent braking force F(v) = -cv^2, with c = 2.50 kg/m, once the brakes are applied.',
      '{"modules":["unit-3-work-energy-and-power","practice-3"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-translation","difficulty":"Very Hard","content_key":"apphycm-frq-057","total_points":6}'::jsonb,
      md5('Answer all parts of the following question.

(a) Using Newton''s second law written as mv(dv/dx) = -cv^2, derive by separation of variables an expression for the car''s speed as a function of distance traveled after braking begins, and evaluate the distance required for the speed to drop to half its initial value (10.0 m/s).

(b) Predict, with justification using your derived expression, whether the distance needed to reach half speed would change if the initial speed were instead 40.0 m/s.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('9edad81c-910a-4121-a8f6-3ab375a06302'::uuid, '545aac5a-734b-4824-a159-45cb002d3744'::uuid, 'a-separate', 'Divides both sides of mv(dv/dx) = -cv^2 by v to get m(dv/dx) = -cv, then separates variables as dv/v = -(c/m)dx.', 1, 'Correct separated differential form shown', 'Cancel one factor of v from both sides before separating dv and dx.', '[]'::jsonb),
      ('91874d45-48f1-406c-a9eb-a0d4ef41aba0'::uuid, '545aac5a-734b-4824-a159-45cb002d3744'::uuid, 'a-integrate', 'Integrates both sides to get ln(v) = -(c/m)x + C.', 1, 'Correct indefinite integral shown', 'Integrate dv/v on the left and -(c/m)dx on the right.', '[]'::jsonb),
      ('28b53e4b-2e13-43d0-af9e-cc1c21f6bdfa'::uuid, '545aac5a-734b-4824-a159-45cb002d3744'::uuid, 'a-solve-vx', 'Solves for v(x) = v0 * e^(-(c/m)x) using the initial condition v(0) = v0.', 1, 'Correct exponential expression shown', 'Apply v(0) = v0 to evaluate the integration constant and exponentiate both sides.', '[]'::jsonb),
      ('0cda2944-037f-4f80-a4c0-08f182d5fa68'::uuid, '545aac5a-734b-4824-a159-45cb002d3744'::uuid, 'a-evaluate-distance', 'Sets v(x) = v0/2 and evaluates x = (m/c)ln(2) ≈ 277 m.', 1, 'x ≈ 277 m shown', 'Substitute v = v0/2 into v(x), solve for x, then plug in m = 1000 kg and c = 2.50 kg/m.', '[]'::jsonb),
      ('ce5a2027-2eb6-47a3-a892-d12874757f63'::uuid, '545aac5a-734b-4824-a159-45cb002d3744'::uuid, 'b-prediction', 'Predicts the distance to reach half speed stays the same (≈277 m) even if v0 is doubled.', 1, 'States distance is unchanged', 'Recompute x = (m/c)ln(2) and note it does not contain v0.', '[]'::jsonb),
      ('e06d8fbd-5369-4aef-aec6-60024495d8c4'::uuid, '545aac5a-734b-4824-a159-45cb002d3744'::uuid, 'b-justification', 'Justifies that x = (m/c)ln(2) is independent of v0, since v0 cancels out of the ratio v/v0 = 1/2 used to find x.', 1, 'References the cancellation of v0 in the derived formula for x', 'Show algebraically that solving v0*e^(-(c/m)x) = v0/2 for x eliminates v0 from both sides.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphycm-frq-058'
      and id <> 'e51a47ae-4b51-45a1-a164-c9c6dbbbbb11'::uuid
  ) then
    raise exception 'material_content_key_collision:apphycm-frq-058';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'e51a47ae-4b51-45a1-a164-c9c6dbbbbb11'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'e51a47ae-4b51-45a1-a164-c9c6dbbbbb11'::uuid,
      v_epv_id,
      'apphycm-frq-058',
      'frq',
      'apphycm-frq-058',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-c-mechanics-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '36735503-4f12-44af-ae24-259573cc7bfb'::uuid,
      'e51a47ae-4b51-45a1-a164-c9c6dbbbbb11'::uuid,
      1,
      'Answer all parts of the following question.

(a) Derive x(t) by integration, and calculate the particle''s net displacement over the interval as well as the total distance traveled, accounting for any change in direction.

(b) Explain, using the sign of v(t), why the total distance traveled exceeds the magnitude of the net displacement, and identify the physical meaning of the times when v(t) = 0.',
      'A particle moves along the x-axis with velocity v(t) = t^2 - 4.00t + 3.00 (SI units) for 0 ≤ t ≤ 4.00 s, starting at x(0) = 0.',
      '{"modules":["unit-1-kinematics","practice-4"],"subject":"ap_physics_c_mechanics","frq_type":"short","archetype":"ap-physics-c-mechanics-frq-representation","difficulty":"Very Hard","content_key":"apphycm-frq-058","total_points":7}'::jsonb,
      md5('Answer all parts of the following question.

(a) Derive x(t) by integration, and calculate the particle''s net displacement over the interval as well as the total distance traveled, accounting for any change in direction.

(b) Explain, using the sign of v(t), why the total distance traveled exceeds the magnitude of the net displacement, and identify the physical meaning of the times when v(t) = 0.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ee4b45cd-16e6-455f-ac8a-92f43aeb33f0'::uuid, '36735503-4f12-44af-ae24-259573cc7bfb'::uuid, 'a-integrate', 'Integrates v(t) to get x(t) = t^3/3 - 2.00t^2 + 3.00t.', 1, 'Correct antiderivative with x(0) = 0 applied', 'Integrate v(t) term by term and use x(0) = 0 to fix the constant.', '[]'::jsonb),
      ('2e860537-3c63-4981-a156-e7eec13b5848'::uuid, '36735503-4f12-44af-ae24-259573cc7bfb'::uuid, 'a-net-displacement', 'Calculates the net displacement x(4.00 s) - x(0) = 4/3 m ≈ 1.33 m.', 1, 'Net displacement ≈ 1.33 m shown', 'Evaluate x(t) at t = 4.00 s and subtract x(0).', '[]'::jsonb),
      ('761c7cb4-2d1a-4368-a116-a5820aa844ad'::uuid, '36735503-4f12-44af-ae24-259573cc7bfb'::uuid, 'a-turning-points', 'Identifies that v(t) = 0 at t = 1.00 s and t = 3.00 s by factoring v(t) = (t-1)(t-3).', 1, 't = 1.00 s and t = 3.00 s identified', 'Factor the quadratic v(t) or use the quadratic formula to find its roots.', '[]'::jsonb),
      ('e5d0efd9-a189-4f0f-a8ff-b74d13f4a478'::uuid, '36735503-4f12-44af-ae24-259573cc7bfb'::uuid, 'a-segment-distances', 'Computes the position at each turning point (x(1) ≈ 1.33 m, x(3) = 0) to find the distance traveled in each monotonic segment (each segment magnitude ≈ 1.33 m).', 1, 'Each of the three segment distances shown as ≈1.33 m', 'Evaluate x(t) at t = 0, 1, 3, 4 and take the absolute value of the displacement in each sub-interval.', '[]'::jsonb),
      ('d81c449f-e0b9-48e7-aa64-7b10a74e4bfa'::uuid, '36735503-4f12-44af-ae24-259573cc7bfb'::uuid, 'a-total-distance', 'Sums the segment magnitudes to get total distance ≈ 4.00 m.', 1, 'Total distance ≈ 4.00 m shown, contrasted with net displacement ≈ 1.33 m', 'Add the absolute values of the three segment displacements found above.', '[]'::jsonb),
      ('1979930b-546f-481f-ab2a-8a244505ead3'::uuid, '36735503-4f12-44af-ae24-259573cc7bfb'::uuid, 'b-sign-explanation', 'Explains that because v(t) changes sign (positive, then negative, then positive), the particle reverses direction, causing some displacement to cancel in the net sum while all of it counts toward total distance.', 1, 'References sign changes in v(t) causing partial cancellation in net displacement but not in total distance', 'State that total distance sums |Δx| over each sub-interval, while net displacement allows positive and negative Δx to cancel.', '[]'::jsonb),
      ('71b021f5-2972-462b-a47e-5576bb93534c'::uuid, '36735503-4f12-44af-ae24-259573cc7bfb'::uuid, 'b-zero-velocity-meaning', 'Identifies that v(t) = 0 at t = 1.00 s and t = 3.00 s marks the instants when the particle is momentarily at rest and reverses its direction of motion.', 1, 'References momentary rest and direction reversal at the turning points', 'Note that v = 0 with a nonzero acceleration at that instant corresponds to the particle turning around.', '[]'::jsonb);
  end if;
end
$physics_units1_3$;
commit;
