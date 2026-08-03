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
  where ep.exam_code = 'ap_physics_2'
    and epv.status = 'published';

  if v_epv_count <> 1 then
    raise exception 'expected_exactly_one_published_exam_pack_version:%:%', 'ap_physics_2', v_epv_count;
  end if;

  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_physics_2'
    and epv.status = 'published';

  select coalesce(max((regexp_match(content_key, '-frq-([0-9]+)$'))[1]::integer), 0)
    into v_max
  from app.content_items
  where content_key ~ '^apphy2-frq-[0-9]+$';
  if v_max <> 38 then
    raise exception 'unexpected_live_max:apphy2:expected=38:actual=%', v_max;
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-039'
      and id <> '9689f2d5-a9c4-4c91-a8a6-f0c118b69a2c'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-039';
  end if;

  if not exists (
    select 1 from app.content_items where id = '9689f2d5-a9c4-4c91-a8a6-f0c118b69a2c'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '9689f2d5-a9c4-4c91-a8a6-f0c118b69a2c'::uuid,
      v_epv_id,
      'apphy2-frq-039',
      'frq',
      'apphy2-frq-039',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '939b6018-9388-4a8a-aef1-1ccb5a7264ef'::uuid,
      '9689f2d5-a9c4-4c91-a8a6-f0c118b69a2c'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the volume of the container.

(b) Calculate the pressure of the gas after it is heated to 400 K at constant volume.',
      'A rigid, sealed 0.500 mol sample of an ideal gas is at a pressure of 1.50×10^5 Pa and a temperature of 250 K.',
      '{"modules":["unit-9-thermodynamics","practice-1"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-math","difficulty":"Easy","content_key":"apphy2-frq-039","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the volume of the container.

(b) Calculate the pressure of the gas after it is heated to 400 K at constant volume.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('fa2af18b-144a-4c1b-a4cb-eb27d89259f4'::uuid, '939b6018-9388-4a8a-aef1-1ccb5a7264ef'::uuid, 'part-a', 'Calculates the correct volume of the container using the ideal gas law.', 1, 'V = nRT/P gives approximately 6.93×10^-3 m^3', 'Apply PV=nRT and solve for V using the given n, T, and P.', '[]'::jsonb),
      ('76d31451-fc27-48b4-a848-efa18e0cd037'::uuid, '939b6018-9388-4a8a-aef1-1ccb5a7264ef'::uuid, 'part-b', 'Calculates the correct final pressure using the constant-volume relationship between pressure and temperature.', 1, 'P2 = P1(T2/T1) gives 2.40×10^5 Pa', 'Apply P1/T1 = P2/T2 at constant volume and solve for P2.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-040'
      and id <> '932d1043-7af0-447a-a1bb-dcdd0a00e48e'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-040';
  end if;

  if not exists (
    select 1 from app.content_items where id = '932d1043-7af0-447a-a1bb-dcdd0a00e48e'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '932d1043-7af0-447a-a1bb-dcdd0a00e48e'::uuid,
      v_epv_id,
      'apphy2-frq-040',
      'frq',
      'apphy2-frq-040',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'f8e4cff2-3d73-4d52-ad0c-615a3debb92e'::uuid,
      '932d1043-7af0-447a-a1bb-dcdd0a00e48e'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the work done by the gas and the resulting change in internal energy of the gas.

(b) Predict and calculate the work done by the gas if the volume instead increases to 0.0800 m^3 (doubling the original volume change) at the same constant pressure, and explain how work depends on the volume change at constant pressure.',
      'A 2.00 mol sample of ideal gas expands at a constant pressure of 1.00×10^5 Pa, with its volume increasing from 0.0400 m^3 to 0.0600 m^3 while absorbing 900 J of heat.',
      '{"modules":["unit-9-thermodynamics","practice-2"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-translation","difficulty":"Medium","content_key":"apphy2-frq-040","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the work done by the gas and the resulting change in internal energy of the gas.

(b) Predict and calculate the work done by the gas if the volume instead increases to 0.0800 m^3 (doubling the original volume change) at the same constant pressure, and explain how work depends on the volume change at constant pressure.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('42b12ac9-a605-4159-a017-5bd74214f825'::uuid, 'f8e4cff2-3d73-4d52-ad0c-615a3debb92e'::uuid, 'a-work', 'Calculates the correct work done by the gas during the original expansion.', 1, 'W = PΔV gives 2000 J', 'Apply W=PΔV using the given pressure and volume change.', '[]'::jsonb),
      ('ee4cb7d1-0441-4c7c-a5c4-7cb887833471'::uuid, 'f8e4cff2-3d73-4d52-ad0c-615a3debb92e'::uuid, 'a-deltaU', 'Calculates the correct change in internal energy using the first law of thermodynamics.', 1, 'ΔU = Q - W gives -1100 J', 'Apply the first law ΔU=Q-W using the given heat and the calculated work.', '[]'::jsonb),
      ('59caf73f-d6bb-4d6e-a6fc-1076796f6f56'::uuid, 'f8e4cff2-3d73-4d52-ad0c-615a3debb92e'::uuid, 'b-prediction', 'Predicts that doubling the volume change doubles the work done by the gas at constant pressure.', 1, 'States the doubling relationship before or alongside the calculation', 'State that W is directly proportional to ΔV at constant pressure, so doubling ΔV doubles W.', '[]'::jsonb),
      ('63c2d341-0489-49c4-a41c-68eca65b9e76'::uuid, 'f8e4cff2-3d73-4d52-ad0c-615a3debb92e'::uuid, 'b-calc', 'Calculates the correct new work done by the gas for the doubled volume change.', 1, 'W2 = PΔV with ΔV=0.0400 m^3 gives 4000 J', 'Apply W=PΔV using the new volume change of 0.0400 m^3.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-041'
      and id <> '6266c45c-58da-4434-ac18-9f9f93b50a0e'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-041';
  end if;

  if not exists (
    select 1 from app.content_items where id = '6266c45c-58da-4434-ac18-9f9f93b50a0e'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '6266c45c-58da-4434-ac18-9f9f93b50a0e'::uuid,
      v_epv_id,
      'apphy2-frq-041',
      'frq',
      'apphy2-frq-041',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'ad215006-88e8-4637-a7b3-4153806e1c3d'::uuid,
      '6266c45c-58da-4434-ac18-9f9f93b50a0e'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a procedure using this equipment to determine the specific heat of the metal; identify the independent variable, dependent variable, and one control variable.

(b) Explain why the calorimeter must be well insulated to obtain an accurate value for the specific heat.',
      'A student has an unknown metal sample, a calorimeter containing water, a thermometer, a balance, and a heat source.',
      '{"modules":["unit-9-thermodynamics","practice-3"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-experimental","difficulty":"Medium","content_key":"apphy2-frq-041","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a procedure using this equipment to determine the specific heat of the metal; identify the independent variable, dependent variable, and one control variable.

(b) Explain why the calorimeter must be well insulated to obtain an accurate value for the specific heat.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('c1d393c7-5769-41fa-a8ed-831338b36f4c'::uuid, 'ad215006-88e8-4637-a7b3-4153806e1c3d'::uuid, 'a-independent', 'Identifies the mass of the metal sample (varied across trials) as the independent variable.', 1, 'Names the metal''s mass or the heated metal''s initial temperature as the variable deliberately changed', 'State that the mass of the metal sample is varied across trials.', '[]'::jsonb),
      ('d90b4557-f8e5-43a7-a1b5-8c0b0f1874d5'::uuid, 'ad215006-88e8-4637-a7b3-4153806e1c3d'::uuid, 'a-dependent', 'Identifies the final equilibrium temperature of the water-metal system as the dependent variable.', 1, 'Names the measured equilibrium temperature used to compute specific heat', 'State that the final equilibrium temperature of the water and metal is measured.', '[]'::jsonb),
      ('06514233-b4d5-43e0-aae7-161de7eead8d'::uuid, 'ad215006-88e8-4637-a7b3-4153806e1c3d'::uuid, 'a-control', 'Identifies a control variable, such as the mass or initial temperature of the water, held constant across trials.', 1, 'Names a fixed variable such as water mass or initial water temperature', 'Name a variable, such as the water''s mass or initial temperature, held constant across trials.', '[]'::jsonb),
      ('10ac9b98-a06a-428a-a864-1f4dbc875ebb'::uuid, 'ad215006-88e8-4637-a7b3-4153806e1c3d'::uuid, 'b-insulation', 'Explains that insulation prevents heat exchange with the surroundings so that conservation of energy applies only between the metal and water.', 1, 'References energy conservation being violated by heat loss to the surroundings without insulation', 'Explain that without insulation, heat lost to the surroundings would make the calculated specific heat inaccurate.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-042'
      and id <> '2076318d-f18b-40af-a7f3-d70c554699bb'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-042';
  end if;

  if not exists (
    select 1 from app.content_items where id = '2076318d-f18b-40af-a7f3-d70c554699bb'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '2076318d-f18b-40af-a7f3-d70c554699bb'::uuid,
      v_epv_id,
      'apphy2-frq-042',
      'frq',
      'apphy2-frq-042',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'ca8d79cd-6ea4-4dcc-a3b2-83679d7f1208'::uuid,
      '2076318d-f18b-40af-a7f3-d70c554699bb'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the change in entropy of the ice-water system and the change in entropy of the room, and calculate the total entropy change of the ice-water system and the room combined.

(b) Explain, using the total entropy change, why this heat transfer process is irreversible.',
      'A 0.250 kg block of ice at 273 K completely melts as it absorbs 8.35×10^4 J of heat from a large room maintained at a constant 293 K.',
      '{"modules":["unit-9-thermodynamics","practice-4"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-representation","difficulty":"Hard","content_key":"apphy2-frq-042","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the change in entropy of the ice-water system and the change in entropy of the room, and calculate the total entropy change of the ice-water system and the room combined.

(b) Explain, using the total entropy change, why this heat transfer process is irreversible.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ca7f55b3-166c-458c-a353-11bc9b6d7ab7'::uuid, 'ca8d79cd-6ea4-4dcc-a3b2-83679d7f1208'::uuid, 'a-ice', 'Calculates the correct entropy change of the ice-water system.', 1, 'ΔS = Q/T gives approximately +306 J/K', 'Apply ΔS=Q/T using the heat absorbed and the ice''s constant melting temperature of 273 K.', '[]'::jsonb),
      ('cd4d3d24-4a9f-472c-abb1-993dd702f686'::uuid, 'ca8d79cd-6ea4-4dcc-a3b2-83679d7f1208'::uuid, 'a-room', 'Calculates the correct entropy change of the room.', 1, 'ΔS = -Q/T gives approximately -285 J/K', 'Apply ΔS=-Q/T using the heat lost and the room''s temperature of 293 K.', '[]'::jsonb),
      ('fc0672a4-51a2-48b6-a46e-111c8c29d651'::uuid, 'ca8d79cd-6ea4-4dcc-a3b2-83679d7f1208'::uuid, 'a-total', 'Calculates the correct total (net) entropy change as positive.', 1, 'Sum of the two entropy changes gives approximately +21 J/K', 'Add the entropy change of the ice-water system and the room to get the total entropy change.', '[]'::jsonb),
      ('45791292-546b-435b-aaa2-c8c8d0a73c9e'::uuid, 'ca8d79cd-6ea4-4dcc-a3b2-83679d7f1208'::uuid, 'b-irreversible', 'Explains that the positive total entropy change indicates the process is irreversible, consistent with the second law of thermodynamics.', 1, 'References the second law: total entropy of an isolated system increases for irreversible processes', 'Explain that a positive total entropy change means the process cannot spontaneously reverse, per the second law of thermodynamics.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-043'
      and id <> '152ae5d9-ede5-41cd-ae10-b47663d34b04'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-043';
  end if;

  if not exists (
    select 1 from app.content_items where id = '152ae5d9-ede5-41cd-ae10-b47663d34b04'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '152ae5d9-ede5-41cd-ae10-b47663d34b04'::uuid,
      v_epv_id,
      'apphy2-frq-043',
      'frq',
      'apphy2-frq-043',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'e9cd44d3-c700-4f41-af41-92f394bec05f'::uuid,
      '152ae5d9-ede5-41cd-ae10-b47663d34b04'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the net work done by the gas during one complete cycle.

(b) Calculate the thermal efficiency of the cycle, given that the total heat input during the cycle is 1.80×10^4 J.',
      'A monatomic ideal gas follows a rectangular cycle on a pressure-volume diagram between pressures 1.00×10^5 Pa and 2.00×10^5 Pa and volumes 2.00×10^-2 m^3 and 5.00×10^-2 m^3, absorbing a total of 1.80×10^4 J of heat during the cycle.',
      '{"modules":["unit-9-thermodynamics","practice-1"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-math","difficulty":"Hard","content_key":"apphy2-frq-043","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the net work done by the gas during one complete cycle.

(b) Calculate the thermal efficiency of the cycle, given that the total heat input during the cycle is 1.80×10^4 J.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('fb7dd376-2a22-48b0-af1f-e6ef57c3a5ae'::uuid, 'e9cd44d3-c700-4f41-af41-92f394bec05f'::uuid, 'a-method', 'Recognizes that the net work equals the area enclosed by the rectangular cycle on the PV diagram, ΔP times ΔV.', 1, 'States W_net = ΔP·ΔV', 'State that the net work equals the enclosed rectangular area, ΔP times ΔV.', '[]'::jsonb),
      ('5adc48dc-b8ee-4ff9-a74b-18c95172e3d6'::uuid, 'e9cd44d3-c700-4f41-af41-92f394bec05f'::uuid, 'a-value', 'Calculates the correct numeric value of the net work.', 1, 'W_net = (1.00×10^5 Pa)(3.00×10^-2 m^3) = 3.00×10^3 J', 'Multiply the pressure difference by the volume difference to get 3.00×10^3 J.', '[]'::jsonb),
      ('ef627142-a3da-4797-a175-aa6ecfc07b90'::uuid, 'e9cd44d3-c700-4f41-af41-92f394bec05f'::uuid, 'b-formula', 'Uses the correct thermal efficiency formula relating net work to heat input.', 1, 'States e = W_net/Q_in', 'State that efficiency equals net work divided by heat input.', '[]'::jsonb),
      ('699a0037-04f2-4cb1-a3b0-564dc2e0d57a'::uuid, 'e9cd44d3-c700-4f41-af41-92f394bec05f'::uuid, 'b-value', 'Calculates the correct numeric efficiency.', 1, 'e = 3.00×10^3 J / 1.80×10^4 J ≈ 16.7%', 'Divide the net work by the given heat input to get approximately 16.7%.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-044'
      and id <> '1ff8ddc1-07ef-41a4-a093-060d933c2cf0'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-044';
  end if;

  if not exists (
    select 1 from app.content_items where id = '1ff8ddc1-07ef-41a4-a093-060d933c2cf0'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '1ff8ddc1-07ef-41a4-a093-060d933c2cf0'::uuid,
      v_epv_id,
      'apphy2-frq-044',
      'frq',
      'apphy2-frq-044',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '831b54bf-8ebc-4d69-af98-af9f6fc3ab64'::uuid,
      '1ff8ddc1-07ef-41a4-a093-060d933c2cf0'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the magnitude of the electric force between the charges.

(b) Predict and calculate how the force changes if the separation is increased to 0.600 m, and explain the relationship using Coulomb''s law.',
      'Two point charges, +4.00 μC and +6.00 μC, are separated by 0.300 m.',
      '{"modules":["unit-10-electric-force-field-and-potential","practice-2"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-translation","difficulty":"Easy","content_key":"apphy2-frq-044","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the magnitude of the electric force between the charges.

(b) Predict and calculate how the force changes if the separation is increased to 0.600 m, and explain the relationship using Coulomb''s law.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('016a260e-b308-45f5-a55b-2142855d8705'::uuid, '831b54bf-8ebc-4d69-af98-af9f6fc3ab64'::uuid, 'part-a', 'Calculates the correct original electric force using Coulomb''s law.', 1, 'F = kq1q2/r^2 gives approximately 2.40 N', 'Apply F=kq1q2/r^2 with the given charges and separation.', '[]'::jsonb),
      ('45d81153-5900-45a8-a664-bb3254a466a6'::uuid, '831b54bf-8ebc-4d69-af98-af9f6fc3ab64'::uuid, 'part-b', 'Predicts and calculates that doubling the separation reduces the force to one-fourth its original value.', 1, 'States F is inversely proportional to r^2, giving a new force of approximately 0.599 N', 'Explain that doubling r reduces F by a factor of 4 (since F∝1/r^2) and calculate the new force as approximately 0.600 N.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-045'
      and id <> '1e765098-fa26-453c-a580-dafc725065ce'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-045';
  end if;

  if not exists (
    select 1 from app.content_items where id = '1e765098-fa26-453c-a580-dafc725065ce'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '1e765098-fa26-453c-a580-dafc725065ce'::uuid,
      v_epv_id,
      'apphy2-frq-045',
      'frq',
      'apphy2-frq-045',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a882a6c1-54d5-4b42-a3d9-01b24a913261'::uuid,
      '1e765098-fa26-453c-a580-dafc725065ce'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a procedure using this equipment to determine the magnitude of the electric field between the plates; identify the independent variable, dependent variable, and one control variable.

(b) Explain why using a test charge of very small magnitude minimizes error in the field measurement.',
      'A student has two parallel conducting plates connected to a variable DC power supply, a small charged test sphere of known charge and mass, and tools to observe the sphere''s motion between the plates.',
      '{"modules":["unit-10-electric-force-field-and-potential","practice-3"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-experimental","difficulty":"Medium","content_key":"apphy2-frq-045","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a procedure using this equipment to determine the magnitude of the electric field between the plates; identify the independent variable, dependent variable, and one control variable.

(b) Explain why using a test charge of very small magnitude minimizes error in the field measurement.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('9d019010-bfc6-432c-a401-86980bd5e6b4'::uuid, 'a882a6c1-54d5-4b42-a3d9-01b24a913261'::uuid, 'a-independent', 'Identifies the applied voltage across the plates as the independent variable.', 1, 'Names the voltage as the variable deliberately varied across trials', 'State that the applied voltage across the plates is varied across trials.', '[]'::jsonb),
      ('4e6faaca-2fc3-48de-abf3-ca613ffdcecc'::uuid, 'a882a6c1-54d5-4b42-a3d9-01b24a913261'::uuid, 'a-dependent', 'Identifies the resulting acceleration (or deflection) of the test charge as the dependent variable.', 1, 'Names the measured acceleration or deflection used to compute the field', 'State that the acceleration or deflection of the test charge is measured.', '[]'::jsonb),
      ('cf449218-baaa-4a9b-abe7-cc2f218f914e'::uuid, 'a882a6c1-54d5-4b42-a3d9-01b24a913261'::uuid, 'a-control', 'Identifies a control variable, such as the plate separation or the test charge''s magnitude, held constant across trials.', 1, 'Names plate separation or test charge magnitude as fixed', 'Name a variable, such as plate separation, held constant across trials.', '[]'::jsonb),
      ('dfd91c60-8689-48b1-a4d1-5c5e690e5905'::uuid, 'a882a6c1-54d5-4b42-a3d9-01b24a913261'::uuid, 'b-disturbance', 'Explains that a small test charge minimizes the field it produces, avoiding significant disturbance of the original field being measured.', 1, 'References minimizing distortion of the field under measurement', 'Explain that a small test charge contributes a negligible field of its own, so it does not significantly alter the field being measured.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-046'
      and id <> 'c822b7f1-7ef5-438c-a47c-639fc2cce2b9'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-046';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'c822b7f1-7ef5-438c-a47c-639fc2cce2b9'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'c822b7f1-7ef5-438c-a47c-639fc2cce2b9'::uuid,
      v_epv_id,
      'apphy2-frq-046',
      'frq',
      'apphy2-frq-046',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '2f8fee7c-b30e-406a-afe2-33884e1a9bc3'::uuid,
      'c822b7f1-7ef5-438c-a47c-639fc2cce2b9'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the electric potential energy of the charge at this point.

(b) Explain why no work is done by the electric force on the charge as it moves along an equipotential surface passing through this point.',
      'A +5.00 μC charge is placed at a point where the electric potential due to other charges is 2.00×10^4 V relative to infinity.',
      '{"modules":["unit-10-electric-force-field-and-potential","practice-4"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-representation","difficulty":"Medium","content_key":"apphy2-frq-046","total_points":3}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the electric potential energy of the charge at this point.

(b) Explain why no work is done by the electric force on the charge as it moves along an equipotential surface passing through this point.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('1359b42f-c13f-423c-aea3-87d6662ed028'::uuid, '2f8fee7c-b30e-406a-afe2-33884e1a9bc3'::uuid, 'part-a', 'Calculates the correct electric potential energy.', 1, 'U = qV gives 0.100 J', 'Apply U=qV using the given charge and potential.', '[]'::jsonb),
      ('f57c2a3f-2cc3-4aa7-a585-55cae164daf7'::uuid, '2f8fee7c-b30e-406a-afe2-33884e1a9bc3'::uuid, 'b-zero-deltaV', 'States that work equals qΔV and that ΔV is zero along an equipotential surface, so no work is done.', 1, 'References W=qΔV and ΔV=0 on an equipotential surface', 'State that the potential does not change along an equipotential surface, so W=qΔV=0.', '[]'::jsonb),
      ('e7a65bd2-3506-4a9e-abdb-da3804c43314'::uuid, '2f8fee7c-b30e-406a-afe2-33884e1a9bc3'::uuid, 'b-perpendicular', 'Explains that the electric field is perpendicular to equipotential surfaces, so the electric force does no work along the surface.', 1, 'References the electric force being perpendicular to the displacement along the surface', 'Explain that because the field is always perpendicular to an equipotential surface, the force does no work on a charge moving along it.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-047'
      and id <> '54be84ec-b48a-484c-a16a-68a79c5cfe1d'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-047';
  end if;

  if not exists (
    select 1 from app.content_items where id = '54be84ec-b48a-484c-a16a-68a79c5cfe1d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '54be84ec-b48a-484c-a16a-68a79c5cfe1d'::uuid,
      v_epv_id,
      'apphy2-frq-047',
      'frq',
      'apphy2-frq-047',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'ea541250-d391-4ad2-a875-51a4ac249858'::uuid,
      '54be84ec-b48a-484c-a16a-68a79c5cfe1d'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the magnitude and direction of the electric field at point P due to each charge separately.

(b) Calculate the net electric field at point P.',
      'A +3.00 μC charge is located at the origin and a -6.00 μC charge is located at x = 0.400 m; point P is located at x = 1.00 m on the same axis.',
      '{"modules":["unit-10-electric-force-field-and-potential","practice-1"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-math","difficulty":"Hard","content_key":"apphy2-frq-047","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the magnitude and direction of the electric field at point P due to each charge separately.

(b) Calculate the net electric field at point P.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('5e982128-af62-44e2-adaf-5fabd58f4587'::uuid, 'ea541250-d391-4ad2-a875-51a4ac249858'::uuid, 'a-E1', 'Calculates the correct magnitude and direction of the field at P due to the +3.00 μC charge.', 1, 'E1 = kq1/r1^2 with r1=1.00 m gives approximately 2.70×10^4 N/C, pointing in the +x direction away from the positive charge', 'Apply E=kq/r^2 for the positive charge and state the field points away from it, in the +x direction.', '[]'::jsonb),
      ('8eb94fda-bf8f-45f5-a9b8-d0d40222cd33'::uuid, 'ea541250-d391-4ad2-a875-51a4ac249858'::uuid, 'a-E2', 'Calculates the correct magnitude and direction of the field at P due to the -6.00 μC charge.', 1, 'E2 = kq2/r2^2 with r2=0.600 m gives approximately 1.50×10^5 N/C, pointing in the -x direction toward the negative charge', 'Apply E=kq/r^2 for the negative charge and state the field points toward it, in the -x direction.', '[]'::jsonb),
      ('869ec4c5-6202-45e3-a6b4-8bd5f783e4ea'::uuid, 'ea541250-d391-4ad2-a875-51a4ac249858'::uuid, 'b-net-magnitude', 'Calculates the correct magnitude of the net electric field by combining the two fields as vectors.', 1, 'E_net = E2 - E1 ≈ 1.23×10^5 N/C', 'Subtract the smaller field from the larger field since they point in opposite directions.', '[]'::jsonb),
      ('1067ad7c-01f4-4df9-aac9-e7801488b2d9'::uuid, 'ea541250-d391-4ad2-a875-51a4ac249858'::uuid, 'b-net-direction', 'States the correct direction of the net electric field.', 1, 'Net field points in the -x direction, the same direction as the larger contribution from the negative charge', 'State that the net field points in the -x direction, since the field from the negative charge is larger.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-048'
      and id <> '9fa7b4b4-4b15-47ef-a50a-43111ee6018d'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-048';
  end if;

  if not exists (
    select 1 from app.content_items where id = '9fa7b4b4-4b15-47ef-a50a-43111ee6018d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '9fa7b4b4-4b15-47ef-a50a-43111ee6018d'::uuid,
      v_epv_id,
      'apphy2-frq-048',
      'frq',
      'apphy2-frq-048',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'cadd1022-c206-43a6-a894-de9085488219'::uuid,
      '9fa7b4b4-4b15-47ef-a50a-43111ee6018d'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the electric potential at this location and the potential energy of the +1.00 μC charge placed there.

(b) Predict and calculate the new potential and potential energy if the distance is decreased to 0.250 m, and explain the inverse relationship between electric potential and distance for a point charge.',
      'A point charge of +2.00 μC creates an electric potential at a location 0.500 m away, where a +1.00 μC charge is placed.',
      '{"modules":["unit-10-electric-force-field-and-potential","practice-2"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-translation","difficulty":"Hard","content_key":"apphy2-frq-048","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the electric potential at this location and the potential energy of the +1.00 μC charge placed there.

(b) Predict and calculate the new potential and potential energy if the distance is decreased to 0.250 m, and explain the inverse relationship between electric potential and distance for a point charge.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ab023455-897d-40cb-a343-5da4e7111fa1'::uuid, 'cadd1022-c206-43a6-a894-de9085488219'::uuid, 'a-V1', 'Calculates the correct original electric potential.', 1, 'V = kq/r gives approximately 3.60×10^4 V', 'Apply V=kq/r using the given charge and distance.', '[]'::jsonb),
      ('18a532db-8799-4116-a466-c0bcabd503a1'::uuid, 'cadd1022-c206-43a6-a894-de9085488219'::uuid, 'a-U1', 'Calculates the correct original potential energy.', 1, 'U = qV gives approximately 3.60×10^-2 J', 'Apply U=qV using the second charge and the calculated potential.', '[]'::jsonb),
      ('11a98066-0a5d-4a30-a7e0-1e1632df24d0'::uuid, 'cadd1022-c206-43a6-a894-de9085488219'::uuid, 'b-prediction', 'Predicts that halving the distance doubles both the potential and the potential energy.', 1, 'States the doubling relationship before or alongside the calculation', 'State that V and U are inversely proportional to r, so halving r doubles both.', '[]'::jsonb),
      ('6e517a43-d287-4460-a8e5-7be6c23f52e2'::uuid, 'cadd1022-c206-43a6-a894-de9085488219'::uuid, 'b-calc', 'Calculates the correct new potential and potential energy after halving the distance.', 1, 'V2 ≈ 7.19×10^4 V and U2 ≈ 7.19×10^-2 J, each double the original values', 'Apply V=kq/r and U=qV using the new distance of 0.250 m.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-049'
      and id <> 'acd7c8ef-363c-41ae-ac67-2efff4c32264'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-049';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'acd7c8ef-363c-41ae-ac67-2efff4c32264'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'acd7c8ef-363c-41ae-ac67-2efff4c32264'::uuid,
      v_epv_id,
      'apphy2-frq-049',
      'frq',
      'apphy2-frq-049',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '49602ce5-c66a-4a8b-a028-f02f48d610c3'::uuid,
      'acd7c8ef-363c-41ae-ac67-2efff4c32264'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a procedure using the power supply and electrometer to verify that the charge stored on the capacitor is directly proportional to the applied voltage; identify the independent variable, dependent variable, and one control variable.

(b) Calculate the capacitance of the capacitor with vacuum between its plates.

(c) Calculate the new capacitance and the percent increase in capacitance when a dielectric slab with dielectric constant κ = 4.00 completely fills the gap, and explain, in terms of the dielectric''s effect on the internal electric field, why the capacitance increases.',
      'A parallel-plate capacitor with plate area 0.0200 m^2 and plate separation 1.00 mm has vacuum between its plates and is connected to a variable DC power supply; a student also has an electrometer and a set of dielectric slabs of known dielectric constant.',
      '{"modules":["unit-10-electric-force-field-and-potential","practice-3"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-experimental","difficulty":"Very Hard","content_key":"apphy2-frq-049","total_points":7}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a procedure using the power supply and electrometer to verify that the charge stored on the capacitor is directly proportional to the applied voltage; identify the independent variable, dependent variable, and one control variable.

(b) Calculate the capacitance of the capacitor with vacuum between its plates.

(c) Calculate the new capacitance and the percent increase in capacitance when a dielectric slab with dielectric constant κ = 4.00 completely fills the gap, and explain, in terms of the dielectric''s effect on the internal electric field, why the capacitance increases.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('5fa3b655-135e-4db9-ac1f-58b59cdb4685'::uuid, '49602ce5-c66a-4a8b-a028-f02f48d610c3'::uuid, 'a-independent', 'Identifies the applied voltage as the independent variable.', 1, 'Names voltage as the variable deliberately varied across trials', 'State that the applied voltage is varied across trials.', '[]'::jsonb),
      ('d80a87bf-6642-4c1e-af30-50b7f674883b'::uuid, '49602ce5-c66a-4a8b-a028-f02f48d610c3'::uuid, 'a-dependent', 'Identifies the stored charge, measured via the electrometer, as the dependent variable.', 1, 'Names the measured charge used to test proportionality with voltage', 'State that the charge stored on the capacitor is measured for each applied voltage.', '[]'::jsonb),
      ('98a27a7f-b4cd-470b-a8a4-6c7053915402'::uuid, '49602ce5-c66a-4a8b-a028-f02f48d610c3'::uuid, 'a-control', 'Identifies a control variable, such as plate area or plate separation, held constant across trials.', 1, 'Names plate area or separation as fixed', 'Name a variable, such as plate area or separation, held constant across trials.', '[]'::jsonb),
      ('0354fa12-0964-454f-a8fb-235ba3318b63'::uuid, '49602ce5-c66a-4a8b-a028-f02f48d610c3'::uuid, 'b-C0', 'Calculates the correct capacitance with vacuum between the plates.', 1, 'C0 = ε0A/d gives approximately 1.77×10^-10 F', 'Apply C=ε0A/d using the given plate area and separation.', '[]'::jsonb),
      ('3c18fc6e-9e34-48d8-a65b-c5fe8c3a8c06'::uuid, '49602ce5-c66a-4a8b-a028-f02f48d610c3'::uuid, 'c-Cnew', 'Calculates the correct capacitance with the dielectric inserted.', 1, 'C = κC0 gives approximately 7.08×10^-10 F', 'Multiply the vacuum capacitance by the dielectric constant κ=4.00.', '[]'::jsonb),
      ('0d7da8aa-3fbf-467b-a004-eb55bc7913dd'::uuid, '49602ce5-c66a-4a8b-a028-f02f48d610c3'::uuid, 'c-percent', 'Calculates the correct percent increase in capacitance.', 1, 'Percent increase = (κ-1)×100% = 300%', 'Calculate the percent change between the new and original capacitance values.', '[]'::jsonb),
      ('8de50449-e5a0-4145-a5bb-26a083891396'::uuid, '49602ce5-c66a-4a8b-a028-f02f48d610c3'::uuid, 'c-explanation', 'Explains that the dielectric polarizes and reduces the net internal electric field for a given charge, allowing more charge to be stored per volt.', 1, 'References polarization of the dielectric reducing the internal field, increasing capacitance', 'Explain that the dielectric''s polarization reduces the internal electric field for a given charge, which increases the capacitance.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-050'
      and id <> '095b5c28-a6b6-41f9-a026-c47b39b90246'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-050';
  end if;

  if not exists (
    select 1 from app.content_items where id = '095b5c28-a6b6-41f9-a026-c47b39b90246'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '095b5c28-a6b6-41f9-a026-c47b39b90246'::uuid,
      v_epv_id,
      'apphy2-frq-050',
      'frq',
      'apphy2-frq-050',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '3c1319bd-51ed-4d7e-a1a3-fd46df6078c2'::uuid,
      '095b5c28-a6b6-41f9-a026-c47b39b90246'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the equivalent resistance and total current from the battery in each configuration.

(b) Explain why the resistors dissipate more total power in the parallel configuration than in the series configuration.',
      'Two identical 20.0 Ω resistors are connected first in series and then in parallel across the same 12.0 V battery.',
      '{"modules":["unit-11-electric-circuits","practice-4"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-representation","difficulty":"Easy","content_key":"apphy2-frq-050","total_points":2}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the equivalent resistance and total current from the battery in each configuration.

(b) Explain why the resistors dissipate more total power in the parallel configuration than in the series configuration.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('e6f8df26-b9a9-4007-aaea-0607f5c082ab'::uuid, '3c1319bd-51ed-4d7e-a1a3-fd46df6078c2'::uuid, 'part-a', 'Calculates the correct equivalent resistance and current for both the series and parallel configurations.', 1, 'Series: 40.0 Ω and 0.300 A; Parallel: 10.0 Ω and 1.20 A', 'Apply series and parallel resistance formulas, then use I=V/R for each configuration.', '[]'::jsonb),
      ('b5e82845-0186-4990-a541-cbd4c569fada'::uuid, '3c1319bd-51ed-4d7e-a1a3-fd46df6078c2'::uuid, 'part-b', 'Explains that the parallel configuration has a lower equivalent resistance, giving each resistor the full battery voltage and drawing more total current, so more total power is dissipated.', 1, 'References lower equivalent resistance and/or full voltage across each resistor in parallel leading to greater total power', 'Explain that the parallel configuration has lower equivalent resistance, so total current (and total power) from the battery is greater.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-051'
      and id <> '509476f9-cee6-4fa1-a1d8-b53d00a98b1c'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-051';
  end if;

  if not exists (
    select 1 from app.content_items where id = '509476f9-cee6-4fa1-a1d8-b53d00a98b1c'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '509476f9-cee6-4fa1-a1d8-b53d00a98b1c'::uuid,
      v_epv_id,
      'apphy2-frq-051',
      'frq',
      'apphy2-frq-051',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '87493b10-06c4-4e5e-a42e-0187697261a7'::uuid,
      '509476f9-cee6-4fa1-a1d8-b53d00a98b1c'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the equivalent resistance of the circuit.

(b) Calculate the total current supplied by the battery and the current through the 4.00 Ω resistor.',
      'A 6.00 Ω resistor is connected in series with a parallel combination of a 4.00 Ω and a 12.00 Ω resistor, all connected across a 9.00 V battery.',
      '{"modules":["unit-11-electric-circuits","practice-1"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-math","difficulty":"Medium","content_key":"apphy2-frq-051","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the equivalent resistance of the circuit.

(b) Calculate the total current supplied by the battery and the current through the 4.00 Ω resistor.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('fcd4fc5a-71e3-480c-a538-19577d46c788'::uuid, '87493b10-06c4-4e5e-a42e-0187697261a7'::uuid, 'a-parallel', 'Calculates the correct equivalent resistance of the parallel combination.', 1, '(4.00)(12.00)/(4.00+12.00) = 3.00 Ω', 'Apply the parallel resistance formula to the 4.00 Ω and 12.00 Ω resistors.', '[]'::jsonb),
      ('312fa17b-1d65-4ab7-ae4f-e0700db73433'::uuid, '87493b10-06c4-4e5e-a42e-0187697261a7'::uuid, 'a-Req', 'Calculates the correct total equivalent resistance of the circuit.', 1, '6.00 Ω + 3.00 Ω = 9.00 Ω', 'Add the series resistor to the parallel combination''s equivalent resistance.', '[]'::jsonb),
      ('e2887b67-41bd-4012-aacd-b158933893e9'::uuid, '87493b10-06c4-4e5e-a42e-0187697261a7'::uuid, 'b-Itotal', 'Calculates the correct total current supplied by the battery.', 1, 'I = V/Req = 9.00 V / 9.00 Ω = 1.00 A', 'Apply I=V/Req using the battery voltage and total equivalent resistance.', '[]'::jsonb),
      ('b11487d8-3aeb-4ae8-a2bf-c8767f6bda7b'::uuid, '87493b10-06c4-4e5e-a42e-0187697261a7'::uuid, 'b-I4', 'Calculates the correct current through the 4.00 Ω resistor.', 1, 'Voltage across the parallel section is 3.00 V, giving 3.00 V / 4.00 Ω = 0.750 A', 'Find the voltage across the parallel section, then divide by 4.00 Ω to get the current through that branch.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-052'
      and id <> '088dd484-8f7e-4122-af39-056de0322097'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-052';
  end if;

  if not exists (
    select 1 from app.content_items where id = '088dd484-8f7e-4122-af39-056de0322097'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '088dd484-8f7e-4122-af39-056de0322097'::uuid,
      v_epv_id,
      'apphy2-frq-052',
      'frq',
      'apphy2-frq-052',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '970cd470-be4b-4892-a293-67a8923c5430'::uuid,
      '088dd484-8f7e-4122-af39-056de0322097'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the current supplied by the battery.

(b) Predict and calculate the new total current if a second 15.0 Ω resistor is connected in parallel with the first, and explain why adding a resistor in parallel decreases the equivalent resistance of the circuit.',
      'A single 15.0 Ω resistor is connected across a 30.0 V ideal battery.',
      '{"modules":["unit-11-electric-circuits","practice-2"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-translation","difficulty":"Medium","content_key":"apphy2-frq-052","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the current supplied by the battery.

(b) Predict and calculate the new total current if a second 15.0 Ω resistor is connected in parallel with the first, and explain why adding a resistor in parallel decreases the equivalent resistance of the circuit.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ff8a7a12-9280-4c02-abc0-f5a4ab6071bc'::uuid, '970cd470-be4b-4892-a293-67a8923c5430'::uuid, 'a-I1', 'Calculates the correct original current.', 1, 'I = V/R = 30.0 V / 15.0 Ω = 2.00 A', 'Apply I=V/R using the given voltage and resistance.', '[]'::jsonb),
      ('0b82c290-9ae4-4ee9-acb5-3df9e25f5ed3'::uuid, '970cd470-be4b-4892-a293-67a8923c5430'::uuid, 'b-prediction', 'Predicts that the total current increases (doubles) when the second resistor is added in parallel.', 1, 'States the doubling relationship before or alongside the calculation', 'State that adding a parallel resistor increases the total current drawn from the battery.', '[]'::jsonb),
      ('c7f85651-0fb0-477e-abd8-00600dc1b8db'::uuid, '970cd470-be4b-4892-a293-67a8923c5430'::uuid, 'b-I2', 'Calculates the correct new total current.', 1, 'Parallel Req = 7.50 Ω, giving I = 30.0 V / 7.50 Ω = 4.00 A', 'Calculate the new parallel equivalent resistance, then apply I=V/Req.', '[]'::jsonb),
      ('8a965e05-28c9-42ba-a906-9ba9edc12df0'::uuid, '970cd470-be4b-4892-a293-67a8923c5430'::uuid, 'b-explanation', 'Explains that adding a parallel resistor provides an additional current path, decreasing the equivalent resistance since 1/Req=1/R1+1/R2.', 1, 'References the parallel resistance formula or an additional path for current reducing equivalent resistance', 'Explain that a parallel path adds an additional route for current, so 1/Req increases and Req decreases.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-053'
      and id <> '0998b891-8e04-471c-acab-4b0a7bcf8c04'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-053';
  end if;

  if not exists (
    select 1 from app.content_items where id = '0998b891-8e04-471c-acab-4b0a7bcf8c04'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '0998b891-8e04-471c-acab-4b0a7bcf8c04'::uuid,
      v_epv_id,
      'apphy2-frq-053',
      'frq',
      'apphy2-frq-053',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'b1b319ca-59c1-4d05-a793-c9a1fac8a7ff'::uuid,
      '0998b891-8e04-471c-acab-4b0a7bcf8c04'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a procedure to determine the EMF and internal resistance of the battery by varying the external resistance and measuring terminal voltage and current; identify the independent variable, dependent variable, and one control variable.

(b) Explain how a graph of terminal voltage versus current can be used to determine both the EMF and the internal resistance of the battery.',
      'A student has a battery of unknown EMF and internal resistance, a variable resistor, an ammeter, and a voltmeter.',
      '{"modules":["unit-11-electric-circuits","practice-3"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-experimental","difficulty":"Hard","content_key":"apphy2-frq-053","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a procedure to determine the EMF and internal resistance of the battery by varying the external resistance and measuring terminal voltage and current; identify the independent variable, dependent variable, and one control variable.

(b) Explain how a graph of terminal voltage versus current can be used to determine both the EMF and the internal resistance of the battery.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('59ee98b9-191e-408e-a418-79402f7e5098'::uuid, 'b1b319ca-59c1-4d05-a793-c9a1fac8a7ff'::uuid, 'a-independent', 'Identifies the external resistance as the independent variable.', 1, 'Names the variable resistor setting as deliberately varied across trials', 'State that the external resistance is varied across trials using the variable resistor.', '[]'::jsonb),
      ('aab94aa8-26ff-4fa5-a3b8-6e6a133efa62'::uuid, 'b1b319ca-59c1-4d05-a793-c9a1fac8a7ff'::uuid, 'a-dependent', 'Identifies the terminal voltage and current as the dependent variables measured.', 1, 'Names terminal voltage and current as the measured quantities', 'State that the terminal voltage and current are measured for each external resistance value.', '[]'::jsonb),
      ('09381952-94a7-4f02-abbc-b9e2d7eb7a05'::uuid, 'b1b319ca-59c1-4d05-a793-c9a1fac8a7ff'::uuid, 'a-control', 'Identifies a control variable, such as using the same battery throughout and minimizing temperature change.', 1, 'Names the battery identity or ambient temperature as held constant', 'Name a control, such as keeping ambient temperature constant or using the same battery for all trials.', '[]'::jsonb),
      ('9e8e34da-8435-4bf4-a2ef-29289c1c9a09'::uuid, 'b1b319ca-59c1-4d05-a793-c9a1fac8a7ff'::uuid, 'b-intercept', 'Explains that the y-intercept of a terminal voltage versus current graph gives the EMF.', 1, 'References V=EMF-Ir and that as I approaches zero, V approaches EMF', 'Explain that extrapolating the graph to zero current gives a voltage equal to the EMF.', '[]'::jsonb),
      ('c0536f2f-0c67-4050-af0d-87662c2be3dc'::uuid, 'b1b319ca-59c1-4d05-a793-c9a1fac8a7ff'::uuid, 'b-slope', 'Explains that the magnitude of the slope of the graph gives the internal resistance.', 1, 'References the slope of V vs I equaling -r', 'Explain that the magnitude of the graph''s slope equals the internal resistance r.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-054'
      and id <> 'ee001517-678f-41c6-a9d1-412185539648'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-054';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'ee001517-678f-41c6-a9d1-412185539648'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'ee001517-678f-41c6-a9d1-412185539648'::uuid,
      v_epv_id,
      'apphy2-frq-054',
      'frq',
      'apphy2-frq-054',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '333c3af2-768a-4c43-aa07-68a4a21d44bb'::uuid,
      'ee001517-678f-41c6-a9d1-412185539648'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the current in the circuit using Kirchhoff''s loop rule.

(b) Calculate the power delivered by the 24.0 V battery, the power delivered to the 6.00 V battery, and the power dissipated in the resistors, and explain, in terms of energy conservation, how these three quantities are related.',
      'A series circuit contains a 24.0 V battery, a 6.00 V battery oriented to oppose the current, and two resistors of 4.00 Ω and 5.00 Ω.',
      '{"modules":["unit-11-electric-circuits","practice-4"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-representation","difficulty":"Hard","content_key":"apphy2-frq-054","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the current in the circuit using Kirchhoff''s loop rule.

(b) Calculate the power delivered by the 24.0 V battery, the power delivered to the 6.00 V battery, and the power dissipated in the resistors, and explain, in terms of energy conservation, how these three quantities are related.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('abfd3ae0-35c5-41a4-a100-5d55a8293a5a'::uuid, '333c3af2-768a-4c43-aa07-68a4a21d44bb'::uuid, 'a-current', 'Calculates the correct current using the loop rule with the net EMF and total resistance.', 1, 'I = (24.0 V - 6.00 V)/(4.00 Ω + 5.00 Ω) = 2.00 A', 'Apply the loop rule with the net EMF (24.0 V - 6.00 V) divided by the total resistance.', '[]'::jsonb),
      ('7aacab95-1bf3-4775-a7a4-97d2a92811a5'::uuid, '333c3af2-768a-4c43-aa07-68a4a21d44bb'::uuid, 'b-P24', 'Calculates the correct power delivered by the 24.0 V battery.', 1, 'P = εI = (24.0 V)(2.00 A) = 48.0 W', 'Multiply the 24.0 V battery''s EMF by the current.', '[]'::jsonb),
      ('f95d65b7-f154-4791-a4f6-e0b3c28bc37c'::uuid, '333c3af2-768a-4c43-aa07-68a4a21d44bb'::uuid, 'b-P6', 'Calculates the correct power delivered to the 6.00 V battery.', 1, 'P = εI = (6.00 V)(2.00 A) = 12.0 W', 'Multiply the 6.00 V battery''s EMF by the current.', '[]'::jsonb),
      ('7fde07b8-402a-417a-a57a-2226f5c77724'::uuid, '333c3af2-768a-4c43-aa07-68a4a21d44bb'::uuid, 'b-Pdissipated', 'Calculates the correct total power dissipated in the resistors.', 1, 'P = I^2(R_total) = (2.00 A)^2(9.00 Ω) = 36.0 W', 'Apply P=I^2R using the total resistance of 9.00 Ω.', '[]'::jsonb),
      ('844aa6a4-7af6-49db-aafb-eec71d92e388'::uuid, '333c3af2-768a-4c43-aa07-68a4a21d44bb'::uuid, 'b-conservation', 'Explains that the power delivered by the 24.0 V battery equals the sum of the power delivered to the opposing battery and the power dissipated in the resistors, consistent with energy conservation.', 1, 'References 48.0 W = 12.0 W + 36.0 W as a statement of energy conservation via Kirchhoff''s loop rule', 'Explain that the loop rule expresses conservation of energy, so the larger battery''s delivered power equals the sum of the other two powers.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-055'
      and id <> '9d5b4f78-6d00-456e-aa16-632783f9157d'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-055';
  end if;

  if not exists (
    select 1 from app.content_items where id = '9d5b4f78-6d00-456e-aa16-632783f9157d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '9d5b4f78-6d00-456e-aa16-632783f9157d'::uuid,
      v_epv_id,
      'apphy2-frq-055',
      'frq',
      'apphy2-frq-055',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-math'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '547e904c-4caf-4a1e-a3e7-cded2ad33e86'::uuid,
      '9d5b4f78-6d00-456e-aa16-632783f9157d'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the total current supplied by the battery.

(b) Calculate the terminal voltage of the battery.

(c) Calculate the current through the 6.00 Ω resistor and the power dissipated in the battery''s internal resistance.',
      'A battery with EMF 12.0 V and internal resistance 0.500 Ω is connected to an external circuit consisting of a 2.50 Ω resistor in series with a parallel combination of a 6.00 Ω and a 3.00 Ω resistor.',
      '{"modules":["unit-11-electric-circuits","practice-1"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-math","difficulty":"Very Hard","content_key":"apphy2-frq-055","total_points":6}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the total current supplied by the battery.

(b) Calculate the terminal voltage of the battery.

(c) Calculate the current through the 6.00 Ω resistor and the power dissipated in the battery''s internal resistance.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('598eb709-624a-4ba5-af9e-1ef9b868c51a'::uuid, '547e904c-4caf-4a1e-a3e7-cded2ad33e86'::uuid, 'a-parallel', 'Calculates the correct equivalent resistance of the 6.00 Ω and 3.00 Ω parallel combination.', 1, '(6.00)(3.00)/(6.00+3.00) = 2.00 Ω', 'Apply the parallel resistance formula to the 6.00 Ω and 3.00 Ω resistors.', '[]'::jsonb),
      ('f21da4d3-9649-4837-a113-e725bbdbc52a'::uuid, '547e904c-4caf-4a1e-a3e7-cded2ad33e86'::uuid, 'a-totalR', 'Calculates the correct total circuit resistance, including the internal resistance.', 1, '2.50 Ω + 2.00 Ω + 0.500 Ω = 5.00 Ω', 'Add the series resistor, the parallel combination, and the internal resistance.', '[]'::jsonb),
      ('6cc939b7-5d19-4305-a956-84d781502f83'::uuid, '547e904c-4caf-4a1e-a3e7-cded2ad33e86'::uuid, 'a-current', 'Calculates the correct total current supplied by the battery.', 1, 'I = EMF/R_total = 12.0 V / 5.00 Ω = 2.40 A', 'Apply I=EMF/R_total using the total circuit resistance.', '[]'::jsonb),
      ('b86355f5-5aa0-445d-a399-7c40f7633fe1'::uuid, '547e904c-4caf-4a1e-a3e7-cded2ad33e86'::uuid, 'b-terminal', 'Calculates the correct terminal voltage of the battery.', 1, 'V_terminal = EMF - Ir = 12.0 V - (2.40 A)(0.500 Ω) = 10.8 V', 'Apply V_terminal=EMF-Ir using the total current and internal resistance.', '[]'::jsonb),
      ('728b4820-db3c-4444-a7b5-51bf79b66860'::uuid, '547e904c-4caf-4a1e-a3e7-cded2ad33e86'::uuid, 'c-I6', 'Calculates the correct current through the 6.00 Ω resistor.', 1, 'Voltage across the parallel section is 4.80 V, giving 4.80 V / 6.00 Ω = 0.800 A', 'Find the voltage across the parallel section, then divide by 6.00 Ω to get the current through that branch.', '[]'::jsonb),
      ('c838d558-8d4a-41f1-aba0-19d60d15a743'::uuid, '547e904c-4caf-4a1e-a3e7-cded2ad33e86'::uuid, 'c-Pinternal', 'Calculates the correct power dissipated in the battery''s internal resistance.', 1, 'P = I^2r = (2.40 A)^2(0.500 Ω) = 2.88 W', 'Apply P=I^2r using the total current and the internal resistance.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-056'
      and id <> '96733741-2d3a-463e-a153-efb13489c91c'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-056';
  end if;

  if not exists (
    select 1 from app.content_items where id = '96733741-2d3a-463e-a153-efb13489c91c'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '96733741-2d3a-463e-a153-efb13489c91c'::uuid,
      v_epv_id,
      'apphy2-frq-056',
      'frq',
      'apphy2-frq-056',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-translation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'e666eb10-1fc5-4553-af2b-9636a1b42a40'::uuid,
      '96733741-2d3a-463e-a153-efb13489c91c'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the rate of heat conduction through the rod.

(b) Predict and calculate the new rate of heat conduction if the length of the rod is doubled with all else unchanged, and explain why increasing the rod''s length decreases the rate of heat transfer.',
      'A metal rod of length 0.500 m and cross-sectional area 2.00×10^-4 m^2, with thermal conductivity 200 W/(m·K), conducts heat between its ends held at 80.0°C and 20.0°C.',
      '{"modules":["unit-9-thermodynamics","practice-2"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-translation","difficulty":"Medium","content_key":"apphy2-frq-056","total_points":4}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the rate of heat conduction through the rod.

(b) Predict and calculate the new rate of heat conduction if the length of the rod is doubled with all else unchanged, and explain why increasing the rod''s length decreases the rate of heat transfer.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('1ca02676-a7dc-48d5-aded-2911aa214ddb'::uuid, 'e666eb10-1fc5-4553-af2b-9636a1b42a40'::uuid, 'a-H1', 'Calculates the correct original rate of heat conduction.', 1, 'H = kAΔT/L gives 4.80 W', 'Apply H=kAΔT/L using the given conductivity, area, temperature difference, and length.', '[]'::jsonb),
      ('041ea7d3-e135-439b-a59d-2198a79e3ec7'::uuid, 'e666eb10-1fc5-4553-af2b-9636a1b42a40'::uuid, 'b-prediction', 'Predicts that doubling the rod''s length halves the rate of heat conduction.', 1, 'States the halving relationship before or alongside the calculation', 'State that H is inversely proportional to L, so doubling L halves H.', '[]'::jsonb),
      ('c6b0c2b3-68a3-4749-a21e-e2345aed911a'::uuid, 'e666eb10-1fc5-4553-af2b-9636a1b42a40'::uuid, 'b-H2', 'Calculates the correct new rate of heat conduction.', 1, 'H2 = kAΔT/(2L) gives 2.40 W', 'Apply H=kAΔT/L using the doubled length of 1.00 m.', '[]'::jsonb),
      ('5d47bbc4-0aee-4c86-a333-effcfc5276a3'::uuid, 'e666eb10-1fc5-4553-af2b-9636a1b42a40'::uuid, 'b-explanation', 'Explains that a longer rod has greater thermal resistance for the same temperature difference, reducing the conduction rate.', 1, 'References H being inversely proportional to L in the conduction equation', 'Explain that increasing L increases the rod''s thermal resistance, which reduces the rate of heat conduction for the same ΔT.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-057'
      and id <> '70592cd3-99dd-4d0b-a335-c4b9d9e2c5cf'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-057';
  end if;

  if not exists (
    select 1 from app.content_items where id = '70592cd3-99dd-4d0b-a335-c4b9d9e2c5cf'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '70592cd3-99dd-4d0b-a335-c4b9d9e2c5cf'::uuid,
      v_epv_id,
      'apphy2-frq-057',
      'frq',
      'apphy2-frq-057',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-experimental'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a12d4926-f0e6-486c-aee7-461714bfbdd2'::uuid,
      '70592cd3-99dd-4d0b-a335-c4b9d9e2c5cf'::uuid,
      1,
      'Answer all parts of the following question.

(a) Design a procedure to test whether the electric force follows an inverse-square relationship with separation distance; identify the independent variable, dependent variable, and one control variable.

(b) Explain how graphing force versus the inverse square of the distance, rather than force versus distance, provides a more direct test of the inverse-square relationship.',
      'A student has a charged conducting sphere on an insulating stand, a small charged test sphere mounted on a sensitive force sensor, and a meter stick to vary and measure the separation between the spheres.',
      '{"modules":["unit-10-electric-force-field-and-potential","practice-3"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-experimental","difficulty":"Hard","content_key":"apphy2-frq-057","total_points":5}'::jsonb,
      md5('Answer all parts of the following question.

(a) Design a procedure to test whether the electric force follows an inverse-square relationship with separation distance; identify the independent variable, dependent variable, and one control variable.

(b) Explain how graphing force versus the inverse square of the distance, rather than force versus distance, provides a more direct test of the inverse-square relationship.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('1e3d967f-fcb7-414f-a351-8275159c1a7f'::uuid, 'a12d4926-f0e6-486c-aee7-461714bfbdd2'::uuid, 'a-independent', 'Identifies the separation distance between the spheres as the independent variable.', 1, 'Names distance as the variable deliberately varied across trials', 'State that the separation distance between the spheres is varied across trials.', '[]'::jsonb),
      ('ecaa3b7d-ec79-4756-aca1-de868a6bff73'::uuid, 'a12d4926-f0e6-486c-aee7-461714bfbdd2'::uuid, 'a-dependent', 'Identifies the measured force as the dependent variable.', 1, 'Names the force reading from the sensor as the measured quantity', 'State that the force between the spheres, measured by the force sensor, is the dependent variable.', '[]'::jsonb),
      ('3b87ac9f-bca1-4d1f-af61-5673b0262c6e'::uuid, 'a12d4926-f0e6-486c-aee7-461714bfbdd2'::uuid, 'a-control', 'Identifies a control variable, such as the charge on each sphere, held constant across trials.', 1, 'Names the charge magnitude on the spheres as held fixed', 'Name a control, such as keeping the charge on both spheres constant across trials (not recharging between trials).', '[]'::jsonb),
      ('3f2d615a-6404-4923-a962-69cb8da2e054'::uuid, 'a12d4926-f0e6-486c-aee7-461714bfbdd2'::uuid, 'b-linearization', 'Explains that plotting force versus 1/r^2 should yield a straight line through the origin if the inverse-square relationship holds.', 1, 'References a linear graph through the origin as evidence of the inverse-square law', 'Explain that if F∝1/r^2, then F plotted against 1/r^2 should be a straight line through the origin.', '[]'::jsonb),
      ('3622c27a-fa77-4984-a5d9-854f09784c4f'::uuid, 'a12d4926-f0e6-486c-aee7-461714bfbdd2'::uuid, 'b-slope', 'Explains that the slope of this linear graph corresponds to kq1q2, providing a quantitative check of the relationship.', 1, 'References the slope equaling kq1q2', 'Explain that the slope of the F versus 1/r^2 graph should equal kq1q2.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apphy2-frq-058'
      and id <> 'ac1f47cf-4fc4-42d8-a53c-b0873cc24e7c'::uuid
  ) then
    raise exception 'material_content_key_collision:apphy2-frq-058';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'ac1f47cf-4fc4-42d8-a53c-b0873cc24e7c'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'ac1f47cf-4fc4-42d8-a53c-b0873cc24e7c'::uuid,
      v_epv_id,
      'apphy2-frq-058',
      'frq',
      'apphy2-frq-058',
      'draft',
      'short',
      'targeted_drill',
      'ap-physics-2-frq-representation'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '330318cb-800d-4255-a7a2-90169863be65'::uuid,
      'ac1f47cf-4fc4-42d8-a53c-b0873cc24e7c'::uuid,
      1,
      'Answer all parts of the following question.

(a) Calculate the heat required for each of the three stages (warming the ice, melting the ice, and warming the liquid water), and the total heat required.

(b) Explain why the temperature of the ice-water system remains constant at 0°C during melting even though heat continues to be added.

(c) Explain, in terms of intermolecular bonds, why melting requires additional heat energy beyond what is needed merely to raise the ice''s temperature, even though the temperature does not change during melting.',
      'A 0.300 kg sample of ice at -20.0°C is heated until it becomes liquid water at 100°C, passing through the solid and liquid phases (specific heat of ice = 2.10×10^3 J/(kg·K), latent heat of fusion = 3.34×10^5 J/kg, specific heat of water = 4.19×10^3 J/(kg·K)).',
      '{"modules":["unit-9-thermodynamics","practice-4"],"subject":"ap_physics_2","frq_type":"short","archetype":"ap-physics-2-frq-representation","difficulty":"Very Hard","content_key":"apphy2-frq-058","total_points":6}'::jsonb,
      md5('Answer all parts of the following question.

(a) Calculate the heat required for each of the three stages (warming the ice, melting the ice, and warming the liquid water), and the total heat required.

(b) Explain why the temperature of the ice-water system remains constant at 0°C during melting even though heat continues to be added.

(c) Explain, in terms of intermolecular bonds, why melting requires additional heat energy beyond what is needed merely to raise the ice''s temperature, even though the temperature does not change during melting.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('47826a51-4198-4537-aeba-408f2a88a89b'::uuid, '330318cb-800d-4255-a7a2-90169863be65'::uuid, 'a-Q1', 'Calculates the correct heat required to warm the ice from -20.0°C to 0°C.', 1, 'Q1 = mc_ice ΔT gives approximately 1.26×10^4 J', 'Apply Q=mcΔT using the ice''s specific heat and the 20.0 K temperature change.', '[]'::jsonb),
      ('956eeaae-6cde-4126-ab37-8c0f91294695'::uuid, '330318cb-800d-4255-a7a2-90169863be65'::uuid, 'a-Q2', 'Calculates the correct heat required to melt the ice at 0°C.', 1, 'Q2 = mL_f gives approximately 1.00×10^5 J', 'Apply Q=mL_f using the given mass and latent heat of fusion.', '[]'::jsonb),
      ('155f8da2-5e66-446d-a6fb-8c3eca99f564'::uuid, '330318cb-800d-4255-a7a2-90169863be65'::uuid, 'a-Q3', 'Calculates the correct heat required to warm the liquid water from 0°C to 100°C.', 1, 'Q3 = mc_water ΔT gives approximately 1.26×10^5 J', 'Apply Q=mcΔT using water''s specific heat and the 100 K temperature change.', '[]'::jsonb),
      ('52afddef-7712-40ef-afd8-4fe1b9258157'::uuid, '330318cb-800d-4255-a7a2-90169863be65'::uuid, 'a-total', 'Calculates the correct total heat required by summing the three stages.', 1, 'Sum of Q1, Q2, and Q3 gives approximately 2.39×10^5 J', 'Add the heat values from all three stages to find the total heat required.', '[]'::jsonb),
      ('9b21f9ea-00ff-4ce0-aab9-52377538045c'::uuid, '330318cb-800d-4255-a7a2-90169863be65'::uuid, 'b-constantT', 'Explains that during the phase change, added heat goes into breaking intermolecular bonds rather than increasing average kinetic energy, so temperature stays constant until melting is complete.', 1, 'References heat being used to change phase rather than raise temperature during melting', 'Explain that during melting, added heat breaks intermolecular bonds instead of increasing the average kinetic energy of the molecules, so temperature does not rise.', '[]'::jsonb),
      ('b2f32cb8-33d7-4524-a26f-a0465cb90419'::uuid, '330318cb-800d-4255-a7a2-90169863be65'::uuid, 'c-bonds', 'Explains that the latent heat of melting overcomes attractive intermolecular forces to transform the rigid solid structure into a liquid, which is energy beyond what a simple temperature increase requires.', 1, 'References breaking or weakening intermolecular bonds during the phase transition as the additional energy requirement', 'Explain that melting requires extra energy to overcome the intermolecular bonds holding the solid structure together, beyond simply raising temperature.', '[]'::jsonb);
  end if;
end
$physics_units1_3$;
commit;
