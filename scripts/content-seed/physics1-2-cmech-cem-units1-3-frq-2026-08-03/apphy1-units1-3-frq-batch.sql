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
  where ep.exam_code = 'ap_physics_1'
    and epv.status = 'published';

  if v_epv_count <> 1 then
    raise exception 'expected_exactly_one_published_exam_pack_version:%:%', 'ap_physics_1', v_epv_count;
  end if;

  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_physics_1'
    and epv.status = 'published';

  select coalesce(max((regexp_match(content_key, '-frq-([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^apphy1-frq-[0-9]+$';
  if v_max <> 38 then
    raise exception 'unexpected_live_max:apphy1:expected=38:actual=%', v_max;
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-039'
      and id <> '68132f28-e9ca-44ef-ad80-1bc233070c7e'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-039';
  end if;

  if not exists (
    select 1 from app.content_items where id = '68132f28-e9ca-44ef-ad80-1bc233070c7e'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '68132f28-e9ca-44ef-ad80-1bc233070c7e'::uuid,
      v_epv_id,
      'apphy1-frq-039',
      'frq',
      'apphy1-frq-039',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '70941980-e6c3-4be0-a44e-ad720ad8405c'::uuid,
      '68132f28-e9ca-44ef-ad80-1bc233070c7e'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the time for the ball to reach the ground and its speed just before impact.

(b) Explain why the ball''s acceleration remains constant throughout the fall.',
      'A ball is dropped from rest from a height of 20.0 m above the ground (g = 9.80 m/s^2, ignore air resistance).',
      '{"modules":["unit-1-kinematics","practice-1"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-math","difficulty":"Easy","content_key":"apphy1-frq-039","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the time for the ball to reach the ground and its speed just before impact.

(b) Explain why the ball''s acceleration remains constant throughout the fall.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('70c196a1-be07-4777-a38a-d2942eefc065'::uuid, '70941980-e6c3-4be0-a44e-ad720ad8405c'::uuid, 'part-a', 'Calculates the fall time (2.02 s) and impact speed (19.8 m/s).', 1, '2.02 s and 19.8 m/s both shown', 'Use h=½gt² to find time, then v=gt (or v²=2gh) to find speed.', '[]'::jsonb),
      ('42dc53cb-23cc-49e4-ae85-fc25054a9c22'::uuid, '70941980-e6c3-4be0-a44e-ad720ad8405c'::uuid, 'part-b', 'Explains that gravity is the only force acting on the ball, so by Newton''s second law the acceleration stays constant at g.', 1, 'References Newton''s second law and gravity as the sole force', 'State that gravity is the only force present, giving constant acceleration g throughout the fall.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-040'
      and id <> 'c1b5017e-2e2e-4a9e-a697-19c12e9205fd'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-040';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'c1b5017e-2e2e-4a9e-a697-19c12e9205fd'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'c1b5017e-2e2e-4a9e-a697-19c12e9205fd'::uuid,
      v_epv_id,
      'apphy1-frq-040',
      'frq',
      'apphy1-frq-040',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'fe984fb5-5127-498b-a96c-890967daf3c3'::uuid,
      'c1b5017e-2e2e-4a9e-a697-19c12e9205fd'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the friction force acting on the crate and its resulting deceleration.

(b) Predict how the deceleration changes if the coefficient of kinetic friction is doubled to 0.400, calculate the new deceleration, and explain why the deceleration is directly proportional to the coefficient of friction.',
      'A 5.00 kg crate slides across a floor with a coefficient of kinetic friction of 0.200 (g = 9.80 m/s^2).',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-2"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-translation","difficulty":"Easy","content_key":"apphy1-frq-040","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the friction force acting on the crate and its resulting deceleration.

(b) Predict how the deceleration changes if the coefficient of kinetic friction is doubled to 0.400, calculate the new deceleration, and explain why the deceleration is directly proportional to the coefficient of friction.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('9bb1134a-368d-4dd1-a408-3265236681e3'::uuid, 'fe984fb5-5127-498b-a96c-890967daf3c3'::uuid, 'part-a', 'Calculates the friction force (9.80 N) and deceleration (1.96 m/s^2).', 1, '9.80 N and 1.96 m/s^2 shown', 'Use f=μmg for friction force, then a=f/m.', '[]'::jsonb),
      ('9d2f1b1b-fe00-4b6f-acbf-89a7ec5ca47b'::uuid, 'fe984fb5-5127-498b-a96c-890967daf3c3'::uuid, 'part-b', 'Predicts and calculates that doubling μ doubles the deceleration to 3.92 m/s^2, and explains the direct proportionality using a=μg.', 1, '3.92 m/s^2 shown with proportionality reasoning', 'Recompute a=μg with the new μ and note mass cancels, so a is directly proportional to μ.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-041'
      and id <> 'fc1ed479-20aa-4803-a110-eee861b5397a'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-041';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'fc1ed479-20aa-4803-a110-eee861b5397a'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'fc1ed479-20aa-4803-a110-eee861b5397a'::uuid,
      v_epv_id,
      'apphy1-frq-041',
      'frq',
      'apphy1-frq-041',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '89384eea-b90a-43ba-a9d4-f103db292515'::uuid,
      'fc1ed479-20aa-4803-a110-eee861b5397a'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a feasible measurement: identify the independent variable and the dependent variable in this experiment.

(b) Identify one variable that must be held constant as a control, and explain why controlling it is necessary to isolate the relationship being tested.',
      'A student wants to measure how the power output required to climb a fixed staircase depends on the time taken to climb it.',
      '{"modules":["unit-3-work-energy-and-power","practice-3"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-experimental","difficulty":"Easy","content_key":"apphy1-frq-041","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a feasible measurement: identify the independent variable and the dependent variable in this experiment.

(b) Identify one variable that must be held constant as a control, and explain why controlling it is necessary to isolate the relationship being tested.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('32a4eed9-b273-41bb-ad8b-a726ec7f1eae'::uuid, '89384eea-b90a-43ba-a9d4-f103db292515'::uuid, 'a-variables', 'Identifies a valid independent variable (e.g., climbing time or pace) and a valid dependent variable (e.g., calculated power output).', 1, 'e.g., time varied, power computed from mgh/t', 'State that climbing time (or pace) is deliberately varied and power output (computed from mgh/t) is measured.', '[]'::jsonb),
      ('8bcbcfb1-9e1c-4c33-a4af-0fe3e188ebd4'::uuid, '89384eea-b90a-43ba-a9d4-f103db292515'::uuid, 'b-control', 'Identifies a control variable (e.g., climber''s mass or stairwell height) and explains why holding it constant isolates the effect of climbing time on power.', 1, 'e.g., mass or height held fixed, with reasoning', 'Name a variable held fixed across trials and explain that changing it would confound the power calculation.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-042'
      and id <> '02b9352a-83e8-40d3-a8c7-07b58aa28ea1'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-042';
  end if;

  if not exists (
    select 1 from app.content_items where id = '02b9352a-83e8-40d3-a8c7-07b58aa28ea1'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '02b9352a-83e8-40d3-a8c7-07b58aa28ea1'::uuid,
      v_epv_id,
      'apphy1-frq-042',
      'frq',
      'apphy1-frq-042',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '345a4fd7-8724-406e-a57e-d9f91f2c19d0'::uuid,
      '02b9352a-83e8-40d3-a8c7-07b58aa28ea1'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the car''s velocity and displacement at the end of the 6.00 s interval.

(b) Identify the time at which the car is momentarily at rest, and explain what the negative initial velocity together with this turnaround means about the car''s direction of motion before and after that instant.',
      'A car moving along a straight road has an initial velocity of -12.0 m/s and a constant acceleration of +4.00 m/s^2 for 6.00 s.',
      '{"modules":["unit-1-kinematics","practice-4"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-representation","difficulty":"Medium","content_key":"apphy1-frq-042","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the car''s velocity and displacement at the end of the 6.00 s interval.

(b) Identify the time at which the car is momentarily at rest, and explain what the negative initial velocity together with this turnaround means about the car''s direction of motion before and after that instant.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('53dd4aef-3c78-43b4-a23d-2fa55248117b'::uuid, '345a4fd7-8724-406e-a57e-d9f91f2c19d0'::uuid, 'a-velocity-displacement', 'Calculates the final velocity (12.0 m/s) and displacement (0 m) over the interval.', 1, '12.0 m/s and 0 m shown', 'Use v=v0+at for velocity and Δx=v0t+½at² for displacement.', '[]'::jsonb),
      ('6771e4b5-83f5-4119-a89b-065d5b8afa83'::uuid, '345a4fd7-8724-406e-a57e-d9f91f2c19d0'::uuid, 'b-turnaround-time', 'Identifies that the car is momentarily at rest at t=3.00 s.', 1, '3.00 s shown, from v=0', 'Set v0+at=0 and solve for t.', '[]'::jsonb),
      ('0d0935bb-5211-4db0-a10d-60a7097855ca'::uuid, '345a4fd7-8724-406e-a57e-d9f91f2c19d0'::uuid, 'b-explanation', 'Explains that the negative initial velocity means the car starts moving in the negative direction, decelerates under the positive acceleration, momentarily stops at t=3.00 s, then reverses to move in the positive direction.', 1, 'Explanation references direction reversal at t=3.00 s', 'State that the car moves negative, then positive, direction reversing at the instant v=0.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-043'
      and id <> 'e16deef1-cb7a-41a9-ad27-4559eb4056b0'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-043';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'e16deef1-cb7a-41a9-ad27-4559eb4056b0'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'e16deef1-cb7a-41a9-ad27-4559eb4056b0'::uuid,
      v_epv_id,
      'apphy1-frq-043',
      'frq',
      'apphy1-frq-043',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'db0e2d26-9ff2-4c62-a841-723c632c9cd8'::uuid,
      'e16deef1-cb7a-41a9-ad27-4559eb4056b0'::uuid,
      1,
      'Answer all parts of the following question.

(a) Derive expressions for the block''s acceleration down the incline and the normal force on it, and evaluate their numeric values.

(b) Explain why the acceleration does not depend on the block''s mass.',
      'A 4.00 kg block slides down a frictionless incline angled at 30.0° above horizontal (g = 9.80 m/s^2).',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-1"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-math","difficulty":"Medium","content_key":"apphy1-frq-043","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Derive expressions for the block''s acceleration down the incline and the normal force on it, and evaluate their numeric values.

(b) Explain why the acceleration does not depend on the block''s mass.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('bb324778-0938-4294-ad79-e5cec5e8f2e4'::uuid, 'db0e2d26-9ff2-4c62-a841-723c632c9cd8'::uuid, 'part-a', 'Derives a=g sinθ (4.90 m/s^2) and N=mg cosθ (33.9 N).', 1, '4.90 m/s^2 and 33.9 N shown', 'Resolve gravity along and perpendicular to the incline to get a=g sinθ and N=mg cosθ.', '[]'::jsonb),
      ('fd0cb527-14b5-4402-a600-717e9e6b105e'::uuid, 'db0e2d26-9ff2-4c62-a841-723c632c9cd8'::uuid, 'part-b', 'Explains that mass cancels from Newton''s second law along the incline (both the gravitational component and inertia scale with mass), so acceleration is mass-independent.', 1, 'References mass canceling in F=ma', 'Show that ma=mg sinθ reduces to a=g sinθ, independent of m.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-044'
      and id <> 'ad105418-ee59-4654-afe4-2243b0171f6c'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-044';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'ad105418-ee59-4654-afe4-2243b0171f6c'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'ad105418-ee59-4654-afe4-2243b0171f6c'::uuid,
      v_epv_id,
      'apphy1-frq-044',
      'frq',
      'apphy1-frq-044',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '8a24e2ec-5604-4100-a3f9-565a0ed16d5b'::uuid,
      'ad105418-ee59-4654-afe4-2243b0171f6c'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the block''s speed at the bottom of the ramp using conservation of energy.

(b) Predict how the speed at the bottom changes if the height is doubled to 2.50 m, calculate the new speed, and explain why the speed does not simply double.',
      'A 2.00 kg block starts from rest and slides down a frictionless ramp from a height of 1.25 m (g = 9.80 m/s^2).',
      '{"modules":["unit-3-work-energy-and-power","practice-2"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-translation","difficulty":"Medium","content_key":"apphy1-frq-044","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the block''s speed at the bottom of the ramp using conservation of energy.

(b) Predict how the speed at the bottom changes if the height is doubled to 2.50 m, calculate the new speed, and explain why the speed does not simply double.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('d0935480-12cf-44bd-afb6-0955a956d50e'::uuid, '8a24e2ec-5604-4100-a3f9-565a0ed16d5b'::uuid, 'a-original', 'Calculates the original speed (4.95 m/s) using mgh=½mv².', 1, '4.95 m/s shown', 'Set mgh=½mv² and solve for v=√(2gh).', '[]'::jsonb),
      ('28a1a49e-a24e-4a08-adef-e479e8a92b91'::uuid, '8a24e2ec-5604-4100-a3f9-565a0ed16d5b'::uuid, 'b-new', 'Calculates the new speed (7.00 m/s) for the doubled height.', 1, '7.00 m/s shown', 'Recompute v=√(2gh) using h=2.50 m.', '[]'::jsonb),
      ('820a4f1c-076c-4c6b-a899-6ac93cf68443'::uuid, '8a24e2ec-5604-4100-a3f9-565a0ed16d5b'::uuid, 'b-explanation', 'Explains that v is proportional to √h, so doubling h increases v by a factor of √2 (≈1.41), not by a factor of 2, because kinetic energy depends on v².', 1, 'References √2 scaling and v² dependence', 'State that v=√(2gh) means v scales with the square root of h, not linearly.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-045'
      and id <> '6f76e68b-1534-4c5b-a620-178b21990107'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-045';
  end if;

  if not exists (
    select 1 from app.content_items where id = '6f76e68b-1534-4c5b-a620-178b21990107'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '6f76e68b-1534-4c5b-a620-178b21990107'::uuid,
      v_epv_id,
      'apphy1-frq-045',
      'frq',
      'apphy1-frq-045',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '36c5c2c9-3781-4224-a449-bf5ac8279db1'::uuid,
      '6f76e68b-1534-4c5b-a620-178b21990107'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design the experiment: identify the independent variable, the dependent variable, and one variable to hold constant as a control.

(b) Explain why holding the launch speed constant across trials is necessary to isolate the effect of angle on range.',
      'A student launches a ball from a spring launcher at various angles to study how launch angle affects horizontal range.',
      '{"modules":["unit-1-kinematics","practice-3"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-experimental","difficulty":"Medium","content_key":"apphy1-frq-045","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design the experiment: identify the independent variable, the dependent variable, and one variable to hold constant as a control.

(b) Explain why holding the launch speed constant across trials is necessary to isolate the effect of angle on range.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('d1616ed4-a7dc-4f96-a05d-a13dc6d1d694'::uuid, '36c5c2c9-3781-4224-a449-bf5ac8279db1'::uuid, 'a-independent', 'Identifies launch angle as the independent variable.', 1, 'launch angle named', 'State that launch angle is the variable deliberately changed.', '[]'::jsonb),
      ('17c06810-c4ca-49aa-a2a8-c0df0470bd0d'::uuid, '36c5c2c9-3781-4224-a449-bf5ac8279db1'::uuid, 'a-dependent', 'Identifies horizontal range as the dependent variable.', 1, 'range named', 'State that horizontal range is the measured outcome.', '[]'::jsonb),
      ('a362cc36-c80a-443d-af0a-9ca318ef4ab1'::uuid, '36c5c2c9-3781-4224-a449-bf5ac8279db1'::uuid, 'a-control', 'Identifies launch speed (e.g., spring compression) as a control variable.', 1, 'launch speed/compression named', 'Name launch speed as a variable held fixed across trials.', '[]'::jsonb),
      ('cb272a04-d035-41ee-a444-2bf7fdbafa66'::uuid, '36c5c2c9-3781-4224-a449-bf5ac8279db1'::uuid, 'b-justification', 'Explains that varying launch speed would confound the angle-range relationship, since range depends on both launch speed and angle (range = v²sin(2θ)/g).', 1, 'References range''s dependence on both v and θ', 'State that if speed varied along with angle, changes in range could not be attributed to angle alone.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-046'
      and id <> 'dcc448ec-14be-40fd-a31d-6efb71d72d0d'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-046';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'dcc448ec-14be-40fd-a31d-6efb71d72d0d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'dcc448ec-14be-40fd-a31d-6efb71d72d0d'::uuid,
      v_epv_id,
      'apphy1-frq-046',
      'frq',
      'apphy1-frq-046',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '6c7a92ce-64fa-479f-a947-d9ce02e8ce0d'::uuid,
      'dcc448ec-14be-40fd-a31d-6efb71d72d0d'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the maximum acceleration of the two-block system before the top block begins to slip.

(b) Explain, using Newton''s second law applied to the top block, what happens if the applied acceleration exceeds this maximum.',
      'A 2.00 kg block rests on top of a 6.00 kg block on a frictionless table; the coefficient of static friction between the blocks is 0.250 (g = 9.80 m/s^2). A horizontal force is applied to the lower block.',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-4"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-representation","difficulty":"Medium","content_key":"apphy1-frq-046","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the maximum acceleration of the two-block system before the top block begins to slip.

(b) Explain, using Newton''s second law applied to the top block, what happens if the applied acceleration exceeds this maximum.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('1bd6a22e-ebc3-415d-aa2e-ced9d41dfb0c'::uuid, '6c7a92ce-64fa-479f-a947-d9ce02e8ce0d'::uuid, 'part-a', 'Calculates the maximum acceleration (2.45 m/s^2) using a_max=μg.', 1, '2.45 m/s^2 shown', 'Set the maximum static friction force on the top block equal to m_top a and solve for a=μg.', '[]'::jsonb),
      ('d0be546c-3abe-4790-ad71-d044b97e0247'::uuid, '6c7a92ce-64fa-479f-a947-d9ce02e8ce0d'::uuid, 'part-b', 'Explains that exceeding a_max means the friction force needed to accelerate the top block with the system would exceed the maximum available static friction, so the top block slips and kinetic friction (which provides less force) takes over.', 1, 'References insufficient friction and slipping', 'State that the required force would exceed μN, so the top block can no longer keep pace and slides relative to the bottom block.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-047'
      and id <> '4256c29a-928e-45e8-a1cb-a457e6aa51ff'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-047';
  end if;

  if not exists (
    select 1 from app.content_items where id = '4256c29a-928e-45e8-a1cb-a457e6aa51ff'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '4256c29a-928e-45e8-a1cb-a457e6aa51ff'::uuid,
      v_epv_id,
      'apphy1-frq-047',
      'frq',
      'apphy1-frq-047',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '6ccbc304-b200-4f94-a847-b8ddb2b8ddd2'::uuid,
      '4256c29a-928e-45e8-a1cb-a457e6aa51ff'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the work done on the cyclist and the average power output over this interval.

(b) Explain why the average power is less than the instantaneous power output at t = 5.00 s.',
      'A 70.0 kg cyclist accelerates from rest to 8.00 m/s in 5.00 s on level ground; assume negligible resistive forces.',
      '{"modules":["unit-3-work-energy-and-power","practice-1"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-math","difficulty":"Medium","content_key":"apphy1-frq-047","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the work done on the cyclist and the average power output over this interval.

(b) Explain why the average power is less than the instantaneous power output at t = 5.00 s.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('0b5aec58-a357-4886-a4d4-5872fdff8f9c'::uuid, '6ccbc304-b200-4f94-a847-b8ddb2b8ddd2'::uuid, 'a-work', 'Calculates the work done (2240 J) using the work-energy theorem.', 1, '2240 J shown', 'Compute ΔKE=½mv_f²-½mv_i².', '[]'::jsonb),
      ('87447f0e-997a-46ae-a4e8-2303c31945c4'::uuid, '6ccbc304-b200-4f94-a847-b8ddb2b8ddd2'::uuid, 'a-power', 'Calculates the average power (448 W).', 1, '448 W shown', 'Divide the work done by the elapsed time.', '[]'::jsonb),
      ('d126d0cd-2126-440c-af35-7cd77e45b3c5'::uuid, '6ccbc304-b200-4f94-a847-b8ddb2b8ddd2'::uuid, 'b-explanation', 'Explains that instantaneous power P=Fv grows as the cyclist''s speed increases (force constant), so the power at t=5.00 s (896 W) exceeds the average over the interval, since power increases roughly linearly with time from zero.', 1, 'References P=Fv increasing with v and 896 W > 448 W', 'Note that power increases with speed, so the final instantaneous power exceeds the time-averaged power.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-048'
      and id <> '7b739aba-0777-4293-a51f-4ad2b8da70b5'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-048';
  end if;

  if not exists (
    select 1 from app.content_items where id = '7b739aba-0777-4293-a51f-4ad2b8da70b5'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '7b739aba-0777-4293-a51f-4ad2b8da70b5'::uuid,
      v_epv_id,
      'apphy1-frq-048',
      'frq',
      'apphy1-frq-048',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '1b735c8c-111f-4bda-a8fd-f432da070c0e'::uuid,
      '7b739aba-0777-4293-a51f-4ad2b8da70b5'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the time for car B to catch up to car A.

(b) Predict how the catch-up time changes if car B''s speed increases to 32.0 m/s, calculate the new catch-up time, and explain the relationship between closing speed and catch-up time.',
      'Car A travels at a constant 20.0 m/s eastward. Car B, 300 m behind car A on the same road, travels at a constant 28.0 m/s eastward, both starting at t=0.',
      '{"modules":["unit-1-kinematics","practice-2"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-translation","difficulty":"Medium","content_key":"apphy1-frq-048","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the time for car B to catch up to car A.

(b) Predict how the catch-up time changes if car B''s speed increases to 32.0 m/s, calculate the new catch-up time, and explain the relationship between closing speed and catch-up time.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('94992750-3fdd-48d9-a77a-62a97debb7c1'::uuid, '1b735c8c-111f-4bda-a8fd-f432da070c0e'::uuid, 'a-catchup', 'Calculates the catch-up time (37.5 s) using the relative (closing) speed of 8.00 m/s over the 300 m gap.', 1, '37.5 s shown', 'Divide the 300 m gap by the closing speed (28.0-20.0 m/s).', '[]'::jsonb),
      ('eb87c6d0-00b8-4292-a226-1578a5834f57'::uuid, '1b735c8c-111f-4bda-a8fd-f432da070c0e'::uuid, 'b-new', 'Calculates the new catch-up time (25.0 s) using the new closing speed of 12.0 m/s.', 1, '25.0 s shown', 'Divide 300 m by the new closing speed (32.0-20.0 m/s).', '[]'::jsonb),
      ('0496c76b-9a73-4471-a4be-d8768b5564e8'::uuid, '1b735c8c-111f-4bda-a8fd-f432da070c0e'::uuid, 'b-explanation', 'Explains that catch-up time is inversely proportional to the closing speed, so increasing car B''s speed increases the closing speed and decreases the time needed to catch up.', 1, 'References inverse proportionality between closing speed and time', 'State that t=Δx/(v_B-v_A), so a larger relative speed gives a smaller time.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-049'
      and id <> 'daf8dc45-7984-4ae5-ab97-593e2f79d678'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-049';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'daf8dc45-7984-4ae5-ab97-593e2f79d678'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'daf8dc45-7984-4ae5-ab97-593e2f79d678'::uuid,
      v_epv_id,
      'apphy1-frq-049',
      'frq',
      'apphy1-frq-049',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a4381c24-cc70-4bc8-a929-159fab937a0b'::uuid,
      'daf8dc45-7984-4ae5-ab97-593e2f79d678'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design the experiment: identify the independent variable, the dependent variable, and two variables to hold constant as controls.

(b) Explain how a graph of the collected data would be used to determine the spring constant, and why this method requires the spring to remain within its elastic (Hookean) region.',
      'A student wants to determine the spring constant of an unknown spring by hanging various known masses from it and measuring the resulting extension.',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-3"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-experimental","difficulty":"Hard","content_key":"apphy1-frq-049","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design the experiment: identify the independent variable, the dependent variable, and two variables to hold constant as controls.

(b) Explain how a graph of the collected data would be used to determine the spring constant, and why this method requires the spring to remain within its elastic (Hookean) region.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('c48802c3-2b7d-4a3d-ab48-5dbf4dff48de'::uuid, 'a4381c24-cc70-4bc8-a929-159fab937a0b'::uuid, 'a-independent', 'Identifies the hanging mass (or applied weight) as the independent variable.', 1, 'mass/weight named', 'State that the hanging mass is the variable deliberately varied.', '[]'::jsonb),
      ('bf8bf18c-46d6-49c7-a2fd-8c9dea617d29'::uuid, 'a4381c24-cc70-4bc8-a929-159fab937a0b'::uuid, 'a-dependent', 'Identifies the spring''s extension as the dependent variable.', 1, 'extension named', 'State that the measured spring extension is the outcome variable.', '[]'::jsonb),
      ('477b8b03-66a2-457f-a924-6dff3c655a53'::uuid, 'a4381c24-cc70-4bc8-a929-159fab937a0b'::uuid, 'a-control1', 'Identifies the same spring (fixed unstretched length/identity) as a control held constant across trials.', 1, 'same spring/unstretched length named', 'State that the same spring is used for every trial.', '[]'::jsonb),
      ('cba1231d-d047-41aa-addf-37c2431b7311'::uuid, 'a4381c24-cc70-4bc8-a929-159fab937a0b'::uuid, 'a-control2', 'Identifies a second control (e.g., consistent measurement method, orientation, or temperature) held constant across trials.', 1, 'second control named', 'Name an additional variable, such as measurement technique or orientation, held fixed.', '[]'::jsonb),
      ('420bdf5f-37b5-4c31-a02d-1852902cdec6'::uuid, 'a4381c24-cc70-4bc8-a929-159fab937a0b'::uuid, 'b-explanation', 'Explains that plotting applied weight (F=mg) versus extension x gives a line with slope k (from F=kx), valid only while the spring behaves elastically (Hookean region).', 1, 'References slope=k and Hookean assumption', 'State that the graph''s slope equals k, and this only holds if the spring hasn''t been stretched beyond its elastic limit.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-050'
      and id <> 'f42b6500-d7a7-4689-a87d-1de3c580cea5'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-050';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'f42b6500-d7a7-4689-a87d-1de3c580cea5'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'f42b6500-d7a7-4689-a87d-1de3c580cea5'::uuid,
      v_epv_id,
      'apphy1-frq-050',
      'frq',
      'apphy1-frq-050',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'bf6d9327-74b0-4d91-a023-f1f1d9d13bb1'::uuid,
      'f42b6500-d7a7-4689-a87d-1de3c580cea5'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the car''s initial potential energy, final kinetic energy, and the total nonconservative work done on the car during the descent.

(b) Explain the physical meaning of the sign of this nonconservative work and what it implies about the car''s mechanical energy.',
      'A 400 kg roller-coaster car starts from rest at the top of a 20.0 m hill and reaches a speed of 18.0 m/s at the bottom, where friction and air resistance act on the car (g = 9.80 m/s^2).',
      '{"modules":["unit-3-work-energy-and-power","practice-4"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-representation","difficulty":"Hard","content_key":"apphy1-frq-050","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the car''s initial potential energy, final kinetic energy, and the total nonconservative work done on the car during the descent.

(b) Explain the physical meaning of the sign of this nonconservative work and what it implies about the car''s mechanical energy.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('752106ff-6556-4bc7-a3cf-f336c6ad2652'::uuid, 'bf6d9327-74b0-4d91-a023-f1f1d9d13bb1'::uuid, 'a-PE', 'Calculates the initial gravitational potential energy (78,400 J).', 1, '78400 J shown', 'Compute PE=mgh at the top of the hill.', '[]'::jsonb),
      ('e608a9af-a5e2-4ad4-aa0d-7fd5dfe443c6'::uuid, 'bf6d9327-74b0-4d91-a023-f1f1d9d13bb1'::uuid, 'a-KE', 'Calculates the final kinetic energy (64,800 J).', 1, '64800 J shown', 'Compute KE=½mv² at the bottom.', '[]'::jsonb),
      ('f5f77763-2981-43e6-a08c-d414034e0fe8'::uuid, 'bf6d9327-74b0-4d91-a023-f1f1d9d13bb1'::uuid, 'a-Wnc', 'Calculates the nonconservative work (-13,600 J) as the change in mechanical energy.', 1, '-13600 J shown', 'Subtract the initial mechanical energy from the final mechanical energy (KE_f - PE_i).', '[]'::jsonb),
      ('8b1daf07-6bb0-47bd-ac66-87bf04121852'::uuid, 'bf6d9327-74b0-4d91-a023-f1f1d9d13bb1'::uuid, 'b-explanation', 'Explains that the negative sign indicates nonconservative forces (friction, air resistance) removed energy from the car, converting mechanical energy into thermal or other non-mechanical forms, so total mechanical energy decreased.', 1, 'References energy removed/converted and decreased mechanical energy', 'State that negative W_nc means mechanical energy was lost to friction/air resistance.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-051'
      and id <> '91b25cfc-758e-4781-a865-2eb050337fb9'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-051';
  end if;

  if not exists (
    select 1 from app.content_items where id = '91b25cfc-758e-4781-a865-2eb050337fb9'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '91b25cfc-758e-4781-a865-2eb050337fb9'::uuid,
      v_epv_id,
      'apphy1-frq-051',
      'frq',
      'apphy1-frq-051',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '35bc00c8-4d7a-4cad-a8c2-00e900902ec6'::uuid,
      '91b25cfc-758e-4781-a865-2eb050337fb9'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the velocity reached at the end of the acceleration phase and the distance covered during that phase.

(b) Calculate the distance covered during the constant-velocity phase.

(c) Calculate the sprinter''s total distance and average velocity over the entire 8.00 s.',
      'A sprinter accelerates from rest at 4.00 m/s^2 for 2.00 s, then continues at the constant velocity reached for an additional 6.00 s.',
      '{"modules":["unit-1-kinematics","practice-1"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-math","difficulty":"Hard","content_key":"apphy1-frq-051","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the velocity reached at the end of the acceleration phase and the distance covered during that phase.

(b) Calculate the distance covered during the constant-velocity phase.

(c) Calculate the sprinter''s total distance and average velocity over the entire 8.00 s.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('0ca11c97-ab4e-45f3-ad90-aa99b3c8ecc1'::uuid, '35bc00c8-4d7a-4cad-a8c2-00e900902ec6'::uuid, 'a-velocity', 'Calculates the velocity at the end of the acceleration phase (8.00 m/s).', 1, '8.00 m/s shown', 'Use v=at with a=4.00 m/s² and t=2.00 s.', '[]'::jsonb),
      ('610ee683-ad83-4ced-ae87-0bad485708b2'::uuid, '35bc00c8-4d7a-4cad-a8c2-00e900902ec6'::uuid, 'a-distance', 'Calculates the distance covered during the acceleration phase (8.00 m).', 1, '8.00 m shown', 'Use Δx=½at² for the first 2.00 s.', '[]'::jsonb),
      ('01d4b269-5591-4781-a84d-f34fa3df44ae'::uuid, '35bc00c8-4d7a-4cad-a8c2-00e900902ec6'::uuid, 'b-distance2', 'Calculates the distance covered during the constant-velocity phase (48.0 m).', 1, '48.0 m shown', 'Multiply the constant velocity (8.00 m/s) by 6.00 s.', '[]'::jsonb),
      ('618178a5-2868-47ae-ab8f-11fcc15c2a3f'::uuid, '35bc00c8-4d7a-4cad-a8c2-00e900902ec6'::uuid, 'c-totaldistance', 'Calculates the total distance traveled (56.0 m).', 1, '56.0 m shown', 'Add the distances from both phases.', '[]'::jsonb),
      ('fb8c3049-145b-490c-a52a-f8a96c20af47'::uuid, '35bc00c8-4d7a-4cad-a8c2-00e900902ec6'::uuid, 'c-avgvelocity', 'Calculates the average velocity over the full 8.00 s (7.00 m/s).', 1, '7.00 m/s shown', 'Divide total distance by total time (8.00 s).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-052'
      and id <> 'a62fadd8-e17c-4b5e-a7eb-02a1b9ece1b4'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-052';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'a62fadd8-e17c-4b5e-a7eb-02a1b9ece1b4'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'a62fadd8-e17c-4b5e-a7eb-02a1b9ece1b4'::uuid,
      v_epv_id,
      'apphy1-frq-052',
      'frq',
      'apphy1-frq-052',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '8ba6a3a8-8352-41d4-a91f-75fda05996fe'::uuid,
      'a62fadd8-e17c-4b5e-a7eb-02a1b9ece1b4'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the acceleration of the system and the tension in the string.

(b) Predict how the acceleration changes if the 5.00 kg mass is increased to 7.00 kg (the 3.00 kg mass unchanged), calculate the new acceleration, and explain the trend.',
      'An Atwood machine has masses of 3.00 kg and 5.00 kg connected by a light string over a frictionless, massless pulley (g = 9.80 m/s^2).',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-2"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-translation","difficulty":"Hard","content_key":"apphy1-frq-052","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the acceleration of the system and the tension in the string.

(b) Predict how the acceleration changes if the 5.00 kg mass is increased to 7.00 kg (the 3.00 kg mass unchanged), calculate the new acceleration, and explain the trend.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('14fc8906-6b1b-479b-ad73-01688c9f235c'::uuid, '8ba6a3a8-8352-41d4-a91f-75fda05996fe'::uuid, 'a-accel', 'Calculates the acceleration (2.45 m/s^2) using a=(m2-m1)g/(m1+m2).', 1, '2.45 m/s^2 shown', 'Apply a=(m2-m1)g/(m1+m2) with m1=3.00 kg, m2=5.00 kg.', '[]'::jsonb),
      ('33cbfddf-dd3e-4477-a3a6-a134ef84f311'::uuid, '8ba6a3a8-8352-41d4-a91f-75fda05996fe'::uuid, 'a-tension', 'Calculates the tension (36.8 N).', 1, '36.8 N (or 36.75 N) shown', 'Apply T=m1(g+a) or T=m2(g-a).', '[]'::jsonb),
      ('2a17e1c3-3b8d-4e15-a5c6-a684f739b776'::uuid, '8ba6a3a8-8352-41d4-a91f-75fda05996fe'::uuid, 'b-new', 'Calculates the new acceleration (3.92 m/s^2) after increasing m2 to 7.00 kg.', 1, '3.92 m/s^2 shown', 'Recompute a=(m2-m1)g/(m1+m2) with m2=7.00 kg.', '[]'::jsonb),
      ('b87fe1f4-e6a6-4e1a-a111-26fcae753053'::uuid, '8ba6a3a8-8352-41d4-a91f-75fda05996fe'::uuid, 'b-explanation', 'Explains that the acceleration increases because the mass imbalance (m2-m1) grows faster, relative to the total system mass (m1+m2), increasing the net driving force per unit mass.', 1, 'References growing imbalance relative to total mass', 'Compare how (m2-m1) and (m1+m2) both change and note the net effect increases a.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-053'
      and id <> '82a7f071-ca1e-4260-a61b-62411cd4d79d'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-053';
  end if;

  if not exists (
    select 1 from app.content_items where id = '82a7f071-ca1e-4260-a61b-62411cd4d79d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '82a7f071-ca1e-4260-a61b-62411cd4d79d'::uuid,
      v_epv_id,
      'apphy1-frq-053',
      'frq',
      'apphy1-frq-053',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '9b01a377-711e-4f93-a431-c899d6f72b99'::uuid,
      '82a7f071-ca1e-4260-a61b-62411cd4d79d'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design the experiment: identify the independent variable, the dependent variable, and one variable to hold constant as a control.

(b) Derive an expression for the coefficient of kinetic friction in terms of the initial speed and stopping distance using the work-energy theorem, and explain why the block''s mass does not need to be known.',
      'A student wants to determine the coefficient of kinetic friction between a block and a horizontal surface by giving the block an initial push and measuring how far it slides before stopping.',
      '{"modules":["unit-3-work-energy-and-power","practice-3"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-experimental","difficulty":"Hard","content_key":"apphy1-frq-053","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design the experiment: identify the independent variable, the dependent variable, and one variable to hold constant as a control.

(b) Derive an expression for the coefficient of kinetic friction in terms of the initial speed and stopping distance using the work-energy theorem, and explain why the block''s mass does not need to be known.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('a75a09a3-d601-45d2-ae56-9deb9408f928'::uuid, '9b01a377-711e-4f93-a431-c899d6f72b99'::uuid, 'a-independent', 'Identifies the block''s initial speed as the independent variable.', 1, 'initial speed named', 'State that initial launch speed is deliberately varied.', '[]'::jsonb),
      ('49fe0d81-cb5d-4a33-a1eb-ef191b3aa603'::uuid, '9b01a377-711e-4f93-a431-c899d6f72b99'::uuid, 'a-dependent', 'Identifies the stopping distance as the dependent variable.', 1, 'stopping distance named', 'State that the measured stopping distance is the outcome variable.', '[]'::jsonb),
      ('adc8de81-963c-491e-af47-230e9cbcfaa2'::uuid, '9b01a377-711e-4f93-a431-c899d6f72b99'::uuid, 'a-control', 'Identifies the surface/block pair (or surface texture) as a control held constant across trials.', 1, 'surface or block material named', 'State that the same surface and block are used in every trial.', '[]'::jsonb),
      ('17cfc021-0feb-416f-a6bc-3a4473ec9068'::uuid, '9b01a377-711e-4f93-a431-c899d6f72b99'::uuid, 'b-derivation', 'Derives μk = v0²/(2gd) by setting the initial kinetic energy equal to the work done by friction.', 1, 'μk=v0²/(2gd) shown', 'Set ½mv0²=μk mg d and solve for μk.', '[]'::jsonb),
      ('0f768c53-5ad0-4bbf-a72d-6fae6c7161b8'::uuid, '9b01a377-711e-4f93-a431-c899d6f72b99'::uuid, 'b-massexplanation', 'Explains that mass cancels from both sides of the energy equation (kinetic energy and friction work are both proportional to mass), so μk can be found without knowing the block''s mass.', 1, 'References mass canceling in the derivation', 'Show m appearing on both sides of ½mv0²=μkmgd and cancel it.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-054'
      and id <> '73ed86fc-fcd5-4834-a409-9c15eaa2cce3'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-054';
  end if;

  if not exists (
    select 1 from app.content_items where id = '73ed86fc-fcd5-4834-a409-9c15eaa2cce3'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '73ed86fc-fcd5-4834-a409-9c15eaa2cce3'::uuid,
      v_epv_id,
      'apphy1-frq-054',
      'frq',
      'apphy1-frq-054',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '557ba080-3a9b-4754-ad13-8cb3c9ebbd15'::uuid,
      '73ed86fc-fcd5-4834-a409-9c15eaa2cce3'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the maximum height reached, the total time of flight, and the horizontal range of the projectile.

(b) Explain why the maximum height depends only on the initial vertical velocity component, not on the horizontal component.',
      'A projectile is launched from level ground at 25.0 m/s at an angle of 40.0° above the horizontal (g = 9.80 m/s^2, ignore air resistance).',
      '{"modules":["unit-1-kinematics","practice-4"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-representation","difficulty":"Hard","content_key":"apphy1-frq-054","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the maximum height reached, the total time of flight, and the horizontal range of the projectile.

(b) Explain why the maximum height depends only on the initial vertical velocity component, not on the horizontal component.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('dba4b480-ce93-4179-a522-cad1cf29171f'::uuid, '557ba080-3a9b-4754-ad13-8cb3c9ebbd15'::uuid, 'a-height', 'Calculates the maximum height (13.2 m).', 1, '13.2 m shown', 'Use h_max=(v0 sinθ)²/(2g).', '[]'::jsonb),
      ('7e31a607-5bf0-450f-ab1f-ed933da69063'::uuid, '557ba080-3a9b-4754-ad13-8cb3c9ebbd15'::uuid, 'a-time', 'Calculates the total time of flight (3.28 s).', 1, '3.28 s shown', 'Use t=2(v0 sinθ)/g.', '[]'::jsonb),
      ('6ede0f23-03d1-4ccf-a9ab-64993aa9d947'::uuid, '557ba080-3a9b-4754-ad13-8cb3c9ebbd15'::uuid, 'a-range', 'Calculates the horizontal range (62.8 m).', 1, '62.8 m shown', 'Multiply the horizontal velocity component by the total time of flight.', '[]'::jsonb),
      ('8ff51ab3-5296-4f2d-acd0-3fc58da7102d'::uuid, '557ba080-3a9b-4754-ad13-8cb3c9ebbd15'::uuid, 'b-explanation', 'Explains that vertical motion is governed only by gravity and the vertical velocity component, independent of horizontal motion, so maximum height depends solely on v0 sinθ.', 1, 'References independence of vertical and horizontal motion', 'State that horizontal velocity has no effect on the vertical acceleration or vertical velocity component.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-055'
      and id <> '6e5b7671-b5b0-4e4f-a221-d771e3be97b6'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-055';
  end if;

  if not exists (
    select 1 from app.content_items where id = '6e5b7671-b5b0-4e4f-a221-d771e3be97b6'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '6e5b7671-b5b0-4e4f-a221-d771e3be97b6'::uuid,
      v_epv_id,
      'apphy1-frq-055',
      'frq',
      'apphy1-frq-055',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'c565c13b-b3b4-41f0-ab4c-206673372e1b'::uuid,
      '6e5b7671-b5b0-4e4f-a221-d771e3be97b6'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the tension in the string and the radius of the ball''s circular path.

(b) Calculate the ball''s speed and the period of its circular motion.',
      'A 0.500 kg ball attached to a 1.20 m string moves in a horizontal circle as a conical pendulum, with the string making a 25.0° angle with the vertical (g = 9.80 m/s^2).',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-1"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-math","difficulty":"Hard","content_key":"apphy1-frq-055","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the tension in the string and the radius of the ball''s circular path.

(b) Calculate the ball''s speed and the period of its circular motion.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('64b29fd9-0f15-4954-ae00-c28cfad2b8bf'::uuid, 'c565c13b-b3b4-41f0-ab4c-206673372e1b'::uuid, 'a-tension', 'Calculates the tension (5.41 N) using vertical equilibrium (T cosθ = mg).', 1, '5.41 N shown', 'Set T cosθ = mg and solve for T.', '[]'::jsonb),
      ('187f9944-d3d5-4bd5-a21d-ad937ec546d3'::uuid, 'c565c13b-b3b4-41f0-ab4c-206673372e1b'::uuid, 'a-radius', 'Calculates the radius (0.507 m) using r = L sinθ.', 1, '0.507 m shown', 'Use r = L sinθ with L=1.20 m.', '[]'::jsonb),
      ('6f2faeaa-4e48-4075-a41b-8e87cedfb2ee'::uuid, 'c565c13b-b3b4-41f0-ab4c-206673372e1b'::uuid, 'b-speed', 'Calculates the speed (1.52 m/s) using the horizontal net-force equation (T sinθ = mv²/r).', 1, '1.52 m/s shown', 'Solve T sinθ = mv²/r for v, or use v²=rg tanθ.', '[]'::jsonb),
      ('e1ee44f4-2e01-4d69-a434-1a6454293934'::uuid, 'c565c13b-b3b4-41f0-ab4c-206673372e1b'::uuid, 'b-period', 'Calculates the period (2.09 s) using T_p = 2πr/v.', 1, '2.09 s shown', 'Divide the circumference 2πr by the speed v.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-056'
      and id <> '5f786d3e-b282-4b93-a2d2-b3218d39bdc4'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-056';
  end if;

  if not exists (
    select 1 from app.content_items where id = '5f786d3e-b282-4b93-a2d2-b3218d39bdc4'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '5f786d3e-b282-4b93-a2d2-b3218d39bdc4'::uuid,
      v_epv_id,
      'apphy1-frq-056',
      'frq',
      'apphy1-frq-056',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '9d10a3c0-0a04-4673-aec7-f798e67dfde1'::uuid,
      '5f786d3e-b282-4b93-a2d2-b3218d39bdc4'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the block''s speed at the bottom of the first incline, then calculate the maximum height it reaches on the second incline, accounting for friction.

(b) Predict how the maximum height on the second incline changes if the friction coefficient is doubled to 0.600, calculate the new maximum height, and explain the trend.',
      'A 3.00 kg block starts from rest at the top of a 2.00 m high frictionless incline, slides to the bottom, then travels up a second incline that makes a 30.0° angle with horizontal and has a kinetic friction coefficient of 0.300 (g = 9.80 m/s^2).',
      '{"modules":["unit-3-work-energy-and-power","practice-2"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-translation","difficulty":"Very Hard","content_key":"apphy1-frq-056","total_points":6}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the block''s speed at the bottom of the first incline, then calculate the maximum height it reaches on the second incline, accounting for friction.

(b) Predict how the maximum height on the second incline changes if the friction coefficient is doubled to 0.600, calculate the new maximum height, and explain the trend.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('c9b3aaf7-c3f8-48d0-ab35-5149cba25e73'::uuid, '9d10a3c0-0a04-4673-aec7-f798e67dfde1'::uuid, 'a-speed', 'Calculates the speed at the bottom of the first incline (6.26 m/s) using energy conservation.', 1, '6.26 m/s shown', 'Set mgh=½mv² for the frictionless first incline and solve for v.', '[]'::jsonb),
      ('e7d5a7e2-5b3c-4534-a335-caba2db243c7'::uuid, '9d10a3c0-0a04-4673-aec7-f798e67dfde1'::uuid, 'a-setup', 'Sets up an energy equation for the second incline that includes both the gravitational potential energy gained and the energy lost to friction over the incline distance.', 1, 'Equation includes mgh2 term and μk mg cosθ (h2/sinθ) friction term', 'Write KE_bottom = mgh2 + μk mg cosθ (h2/sinθ).', '[]'::jsonb),
      ('73856a64-6e06-4f7e-a140-e4162371f0fb'::uuid, '9d10a3c0-0a04-4673-aec7-f798e67dfde1'::uuid, 'a-height', 'Calculates the maximum height reached on the second incline (1.32 m).', 1, '1.32 m shown', 'Solve the energy equation from the previous step for h2.', '[]'::jsonb),
      ('cae68bd9-ede0-4071-a6d2-622793dac186'::uuid, '9d10a3c0-0a04-4673-aec7-f798e67dfde1'::uuid, 'b-prediction', 'Predicts that the maximum height on the second incline decreases when the friction coefficient is doubled.', 1, 'States height decreases before or with the calculation', 'State that more friction removes more energy, so the block should not climb as high.', '[]'::jsonb),
      ('ebb08027-8c17-4f53-a2e5-115c46445950'::uuid, '9d10a3c0-0a04-4673-aec7-f798e67dfde1'::uuid, 'b-newvalue', 'Calculates the new maximum height (0.981 m) with the doubled friction coefficient.', 1, '0.981 m shown', 'Repeat the energy-balance calculation with μk=0.600.', '[]'::jsonb),
      ('2dac29d4-7f34-4cf4-a1de-702932ba6aab'::uuid, '9d10a3c0-0a04-4673-aec7-f798e67dfde1'::uuid, 'b-explanation', 'Explains that the relationship is not simply inversely proportional, since doubling μk changes both the deceleration and the distance traveled up the incline in a nonlinear way, so the height does not simply halve.', 1, 'References nonlinear/non-proportional relationship between μk and height', 'Note that height depends on μk through a combined term with cosθ/sinθ, not a simple inverse relationship.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-057'
      and id <> 'c5e5ce69-5365-4551-a9eb-4832cf4066f9'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-057';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'c5e5ce69-5365-4551-a9eb-4832cf4066f9'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'c5e5ce69-5365-4551-a9eb-4832cf4066f9'::uuid,
      v_epv_id,
      'apphy1-frq-057',
      'frq',
      'apphy1-frq-057',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '70ad425b-6af7-4e46-a11c-d43c5b5580ee'::uuid,
      'c5e5ce69-5365-4551-a9eb-4832cf4066f9'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design the experiment: identify the independent variable, the dependent variable, and two variables to hold constant as controls.

(b) Explain what result would confirm the independence of horizontal and vertical motion, and explain why negligible air resistance is a necessary assumption for this conclusion to hold.

(c) Calculate the predicted fall time for both balls, and explain why this time should be the same for both balls regardless of horizontal launch speed.',
      'A student wants to experimentally verify that the horizontal and vertical motions of a projectile are independent by comparing a ball projected horizontally off a 0.800 m table to an identical ball simply dropped from the same height at the same instant (g = 9.80 m/s^2).',
      '{"modules":["unit-1-kinematics","practice-3"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-experimental","difficulty":"Very Hard","content_key":"apphy1-frq-057","total_points":7}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design the experiment: identify the independent variable, the dependent variable, and two variables to hold constant as controls.

(b) Explain what result would confirm the independence of horizontal and vertical motion, and explain why negligible air resistance is a necessary assumption for this conclusion to hold.

(c) Calculate the predicted fall time for both balls, and explain why this time should be the same for both balls regardless of horizontal launch speed.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('0077ec68-3505-4e41-a98c-d3084affa397'::uuid, '70ad425b-6af7-4e46-a11c-d43c5b5580ee'::uuid, 'a-independent', 'Identifies the presence/absence (or magnitude) of horizontal launch velocity as the independent variable.', 1, 'horizontal launch velocity named', 'State that horizontal launch speed is the variable being compared between the two balls.', '[]'::jsonb),
      ('d2b8dcf3-77bb-4211-a832-6c6458806d1a'::uuid, '70ad425b-6af7-4e46-a11c-d43c5b5580ee'::uuid, 'a-dependent', 'Identifies the time for each ball to hit the ground as the dependent variable.', 1, 'fall time named', 'State that the measured fall time is the outcome variable.', '[]'::jsonb),
      ('76e8d8d1-2ab4-4a2a-a4c1-36fdaf4bea1e'::uuid, '70ad425b-6af7-4e46-a11c-d43c5b5580ee'::uuid, 'a-control1', 'Identifies the release height (table height) as a control held constant for both balls.', 1, 'release height named', 'State that both balls are released from the same height.', '[]'::jsonb),
      ('e8dd1167-e571-4e6e-a46a-ef73b0bc06b0'::uuid, '70ad425b-6af7-4e46-a11c-d43c5b5580ee'::uuid, 'a-control2', 'Identifies a second control (e.g., simultaneous release, identical ball mass/size) held constant.', 1, 'second control named', 'Name an additional variable, such as release timing or ball type, held constant for both balls.', '[]'::jsonb),
      ('fbb81c11-620f-4de4-afdf-c6906d64fcda'::uuid, '70ad425b-6af7-4e46-a11c-d43c5b5580ee'::uuid, 'b-confirmation', 'Explains that both balls landing at the same time despite different horizontal speeds would confirm that vertical motion is unaffected by horizontal motion.', 1, 'References equal landing times confirming independence', 'State that identical fall times for both balls is the result that supports independence.', '[]'::jsonb),
      ('fe0dd260-aca2-4b9e-a450-45b4719e48aa'::uuid, '70ad425b-6af7-4e46-a11c-d43c5b5580ee'::uuid, 'b-airresistance', 'Explains that negligible air resistance is necessary because drag would couple horizontal speed to vertical deceleration, which would make landing times differ and break the independence.', 1, 'References drag depending on speed and coupling the two directions', 'State that air resistance depends on total speed, which would let horizontal motion affect vertical motion if not negligible.', '[]'::jsonb),
      ('f364bcfb-85d7-4ac1-abd6-fed98180b607'::uuid, '70ad425b-6af7-4e46-a11c-d43c5b5580ee'::uuid, 'c-time', 'Calculates the fall time (0.404 s) and explains it is independent of horizontal launch speed because the vertical acceleration (g) is unaffected by horizontal velocity.', 1, '0.404 s shown with independence reasoning', 'Use h=½gt² to solve for t, and note horizontal speed does not appear in this equation.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy1-frq-058'
      and id <> '7b12123c-0fc2-4310-afd0-cae0ac31aceb'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy1-frq-058';
  end if;

  if not exists (
    select 1 from app.content_items where id = '7b12123c-0fc2-4310-afd0-cae0ac31aceb'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '7b12123c-0fc2-4310-afd0-cae0ac31aceb'::uuid,
      v_epv_id,
      'apphy1-frq-058',
      'frq',
      'apphy1-frq-058',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-1-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '9c407a96-167e-4df5-aeeb-bff5af43ad0a'::uuid,
      '7b12123c-0fc2-4310-afd0-cae0ac31aceb'::uuid,
      1,
      'Answer all parts of the following question.

(a) Apply Newton''s second law to each mass, and calculate the acceleration of the system and the tension in the string.

(b) Explain the physical meaning of the sign of the acceleration you calculated, calculate the threshold hanging mass at which the direction of motion would reverse, and explain what happens if the hanging mass is reduced below that threshold.',
      'A 4.00 kg block on a frictionless 20.0° incline is connected by a light string over a frictionless pulley at the top of the incline to a hanging 2.00 kg mass (g = 9.80 m/s^2).',
      '{"modules":["unit-2-force-and-translational-dynamics","practice-4"],"subject":"ap_physics_1","frq_type":"short","archetype":"ap-physics-1-frq-representation","difficulty":"Very Hard","content_key":"apphy1-frq-058","total_points":6}'::jsonb,
      md5('Answer all parts of the following question.

(a) Apply Newton''s second law to each mass, and calculate the acceleration of the system and the tension in the string.

(b) Explain the physical meaning of the sign of the acceleration you calculated, calculate the threshold hanging mass at which the direction of motion would reverse, and explain what happens if the hanging mass is reduced below that threshold.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('80297353-7183-4ee7-a6ff-895fff73bcea'::uuid, '9c407a96-167e-4df5-aeeb-bff5af43ad0a'::uuid, 'a-setup', 'Writes Newton''s second law equations for both the incline block and the hanging mass, correctly including the incline component of gravity and the string tension.', 1, 'Two equations shown: T - m1 g sinθ = m1 a and m2 g - T = m2 a', 'Write one equation for each mass relating tension, gravity component, and acceleration.', '[]'::jsonb),
      ('afab9de8-e1b7-4f53-a1e8-cc784eb0d1d2'::uuid, '9c407a96-167e-4df5-aeeb-bff5af43ad0a'::uuid, 'a-accel', 'Calculates the acceleration (1.03 m/s^2).', 1, '1.03 m/s^2 shown', 'Solve the two Newton''s-second-law equations simultaneously for a.', '[]'::jsonb),
      ('d0a01b17-8846-43b6-a932-b0b0b7259ebe'::uuid, '9c407a96-167e-4df5-aeeb-bff5af43ad0a'::uuid, 'a-tension', 'Calculates the tension (17.5 N).', 1, '17.5 N shown', 'Substitute a back into either equation to solve for T.', '[]'::jsonb),
      ('0b747689-757a-4b21-a66d-1bf4e7df254c'::uuid, '9c407a96-167e-4df5-aeeb-bff5af43ad0a'::uuid, 'b-directionmeaning', 'Explains that the positive result confirms the assumed direction: the hanging mass descends while the block slides up the incline.', 1, 'References confirmed direction of motion', 'State that a positive a in the assumed direction means the system actually moves that way.', '[]'::jsonb),
      ('c8b44ba3-1955-4b72-af47-f2daeb4f0ac0'::uuid, '9c407a96-167e-4df5-aeeb-bff5af43ad0a'::uuid, 'b-threshold', 'Calculates the threshold hanging mass (1.37 kg) at which m2 g equals m1 g sinθ and the net force becomes zero.', 1, '1.37 kg shown', 'Set m2 g = m1 g sinθ and solve for m2.', '[]'::jsonb),
      ('185966f2-dccc-4fcc-aedf-26d64ca18f88'::uuid, '9c407a96-167e-4df5-aeeb-bff5af43ad0a'::uuid, 'b-reduced', 'Explains that if the hanging mass is reduced below this threshold, the net force reverses, so the block would instead slide down the incline while pulling the hanging mass upward.', 1, 'References reversed direction of motion below threshold', 'State that below the threshold mass, m1 g sinθ exceeds m2 g, reversing the direction of acceleration.', '[]'::jsonb);
  end if;
end
$physics_units1_3$;
commit;
