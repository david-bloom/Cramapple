begin;

-- Add AP Physics C: Mechanics Unit 4 topic-guide pairs.
--
-- Production coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 4 AP Physics C:Mechanics Unit 4 topics and 0
-- published point briefs/explainers for the unit.
--
-- Grounding: docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 4
-- (Linear Momentum). The fact pack confirms p = mv as a vector, impulse as
-- the integral of net force over time, F_net = dp/dt, variable-mass systems
-- as in-scope, conservation of system momentum with 1-D and 2-D quantitative
-- collisions in scope, and elastic/inelastic/perfectly-inelastic collision
-- energy distinctions.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_c_mechanics', 4, '4.1', 'Linear Momentum',
    'very-important', 'very-important',
    'Linear momentum is p = mv, a vector in the same direction as velocity. In this calculus-based course, momentum is the state quantity used to model collisions and explosions from immediately-before to immediately-after states.',
    'Momentum is the bridge between Newton''s laws and interactions. It lets you analyze short collisions where internal forces dominate and sets up impulse as an integral in 4.2.',
    'You earn points by assigning vector signs or components to every momentum term, summing system momentum component-by-component, and keeping the selected system clear.',
    'Choose axes first, write each object''s momentum as a signed component or vector, then sum components before applying any collision model.',
    'Adding momentum magnitudes or speeds directly instead of adding vector components.',
    '/learn/ap-physics-c-mechanics/unit-4/linear-momentum'
  ),
  (
    'ap_physics_c_mechanics', 4, '4.2', 'Change in Momentum and Impulse',
    'very-important', 'very-important',
    'Impulse is change in momentum: J = delta p = integral F_net dt. Net force is the time derivative of momentum, F_net = dp/dt, with variable-mass systems in scope for Physics C: Mechanics.',
    'This is where the calculus version separates from algebra-based momentum. Time-varying forces, force-time integrals, and momentum derivatives are central exam moves, not optional decoration.',
    'You earn points by setting up the definite integral of net force over the correct time interval, preserving direction/sign, and using F_net = dp/dt when momentum changes as a function of time.',
    'If force varies with time, write J = integral from t_i to t_f of F_net(t) dt before substituting; do not replace the whole interaction with one force value unless an average force is actually given.',
    'Using one force value times total time for a time-varying force instead of integrating F(t).',
    '/learn/ap-physics-c-mechanics/unit-4/change-in-momentum-and-impulse'
  ),
  (
    'ap_physics_c_mechanics', 4, '4.3', 'Conservation of Linear Momentum',
    'very-important', 'very-important',
    'Total momentum of a selected system is constant when net external impulse is zero. Physics C: Mechanics treats 1-D and 2-D collisions quantitatively, while 3-D collisions are qualitative only.',
    'This topic is where system choice, vector components, and simultaneous equations come together. Unlike AP Physics 1, full quantitative 2-D collision analysis is in scope here.',
    'You earn points by defining the system, checking external impulse, writing momentum conservation separately for each component, and solving consistently for unknown final velocities.',
    'Draw the system boundary, then write p_x before = p_x after and p_y before = p_y after separately; solve the component equations rather than collapsing a 2-D collision into one scalar equation.',
    'Writing one momentum equation for a two-dimensional collision and losing a component constraint.',
    '/learn/ap-physics-c-mechanics/unit-4/conservation-of-linear-momentum'
  ),
  (
    'ap_physics_c_mechanics', 4, '4.4', 'Elastic and Inelastic Collisions',
    'very-important', 'very-important',
    'Elastic collisions conserve total system kinetic energy; inelastic collisions decrease total system kinetic energy; perfectly inelastic collisions are the sticking-together case with one shared final velocity.',
    'The exam can require combining vector momentum conservation with an energy equation. Momentum conservation determines allowed final velocities; kinetic energy determines whether the collision is elastic.',
    'You earn points by applying momentum conservation to the system, then adding kinetic-energy conservation only when the collision is elastic or comparing kinetic energy to classify the collision.',
    'Set up the momentum equations first; only add K_before = K_after if the prompt identifies an elastic collision or asks you to test for one.',
    'Using kinetic-energy conservation in an inelastic collision because momentum is conserved.',
    '/learn/ap-physics-c-mechanics/unit-4/elastic-and-inelastic-collisions'
  )
),
explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  (
    'ap_physics_c_mechanics', 4, '4.1', 'Linear Momentum',
    'Momentum is a vector state quantity: p = mv. In Physics C: Mechanics, the vector language matters because collision and explosion problems often move quickly from one-dimensional signed motion into two-dimensional component equations.',
    'Students need to treat each object''s momentum as a vector contribution to a system total. Momentum is useful because a short interaction can be analyzed from initial and final states when internal forces are much larger than external forces during the interaction.',
    'Points come from defining axes, writing p_x and p_y components for each object when needed, and summing by component. A scalar momentum magnitude by itself rarely proves conservation or gives a complete system equation.',
    'Choose axes first, write each object''s momentum as a signed component or vector, then sum components before applying any collision model.',
    'Two pucks have equal masses. One moves east at speed v and the other moves north at speed v. A student says the total momentum magnitude is 2mv because both pucks have momentum mv. What is missing?',
    'The student just needs to add the two momentum magnitudes: mv + mv = 2mv.',
    'The two momenta are perpendicular vectors. If east is x and north is y, the system momentum is mv in the x direction plus mv in the y direction. Its magnitude is sqrt((mv)^2 + (mv)^2) = sqrt(2)mv, not 2mv, and its direction is 45 degrees between east and north. Adding magnitudes loses vector direction information.',
    'Adding momentum magnitudes or speeds directly instead of adding vector components.',
    'Back in practice, write momentum in components before adding. If two objects move in different directions, magnitude addition is almost always the trap.'
  ),
  (
    'ap_physics_c_mechanics', 4, '4.2', 'Change in Momentum and Impulse',
    'Impulse is the accumulated effect of net force over time, J = integral F_net dt, and it equals delta p. The reverse relationship is F_net = dp/dt, so a momentum-time graph has force as its slope. Physics C also keeps variable-mass systems in scope, so dp/dt cannot always be simplified blindly to ma without checking mass behavior.',
    'Students need to use calculus when force or momentum varies continuously. The 2025 Mechanics momentum FRQ showed that many students recognized an integral was needed but did not execute the definite integral correctly; the setup and limits matter.',
    'Points come from writing the correct integral, using the actual bounds of the interaction, carrying vector signs, and evaluating before equating to delta p. A correct idea without the definite integral can miss the scored mathematical routine.',
    'If force varies with time, write J = integral from t_i to t_f of F_net(t) dt before substituting; do not replace the whole interaction with one force value unless an average force is actually given.',
    'A net force on a cart is F(t) = Ct in the +x direction from t = 0 to t = T. What impulse is delivered?',
    'The impulse is F(T) times T, so J = CT^2 in the +x direction.',
    'Because the force changes with time, impulse is the area under F(t): J = integral_0^T Ct dt = (1/2)CT^2 in the +x direction. Multiplying the final force CT by the full time treats the whole triangle under the force-time graph as a rectangle and doubles the impulse.',
    'Using one force value times total time for a time-varying force instead of integrating F(t).',
    'In practice, sketch the force-time graph before integrating. If the force ramps, the area is not final force times total time.'
  ),
  (
    'ap_physics_c_mechanics', 4, '4.3', 'Conservation of Linear Momentum',
    'Momentum conservation is applied component by component. For an isolated two-dimensional collision, total p_x and total p_y are each conserved separately; those two equations can be solved together for unknown final velocity components or magnitudes/directions.',
    'Students need to distinguish the Physics C scope from the algebra-based boundary. Two-dimensional quantitative collisions and simultaneous equations are allowed here, while only three-dimensional collisions are qualitative.',
    'Points are earned by naming the system, stating why external impulse is negligible or zero, and writing separate conservation equations for each component before solving. One scalar equation cannot replace two component equations in 2-D.',
    'Draw the system boundary, then write p_x before = p_x after and p_y before = p_y after separately; solve the component equations rather than collapsing a 2-D collision into one scalar equation.',
    'A puck moving east collides with an identical puck initially at rest, and afterward the two pucks move off at angles above and below the original eastward line. What conservation equations should be written before solving?',
    'Use one equation: initial momentum magnitude equals final momentum magnitude.',
    'Momentum is conserved as a vector, so write separate component equations. In the x direction, the initial eastward momentum equals the sum of the final x components of both pucks. In the y direction, the initial momentum is zero, so the final y components must sum to zero. These two equations are the starting point; a single magnitude equation loses the direction information needed for a 2-D collision.',
    'Writing one momentum equation for a two-dimensional collision and losing a component constraint.',
    'Back in practice, make a two-line conservation setup for every 2-D collision: one x equation and one y equation. That habit keeps the vector nature visible.'
  ),
  (
    'ap_physics_c_mechanics', 4, '4.4', 'Elastic and Inelastic Collisions',
    'Collision type is about kinetic energy, not about whether momentum is conserved. In an isolated system, momentum conservation can hold for elastic, inelastic, and perfectly inelastic collisions; only elastic collisions also conserve total kinetic energy.',
    'Students need to decide when an energy equation is permitted. If the collision is perfectly inelastic, the shared final velocity comes from momentum conservation, and kinetic energy decreases. If the collision is elastic, momentum and kinetic energy equations are both available.',
    'Points come from using the right pair of equations for the stated collision type. For a two-object elastic collision, momentum conservation plus kinetic-energy conservation can determine final speeds; for a sticking collision, only momentum conservation plus the shared-final-velocity condition applies.',
    'Set up the momentum equations first; only add K_before = K_after if the prompt identifies an elastic collision or asks you to test for one.',
    'Two carts stick together after a collision on a frictionless track. A student writes both p_before = p_after and K_before = K_after to solve for the shared final speed. Identify the error.',
    'Both equations are valid because friction is absent, so no energy leaves the system.',
    'The momentum equation is valid for the two-cart system because the external impulse is negligible. The kinetic-energy equation is not valid because sticking together makes the collision perfectly inelastic; some kinetic energy is transformed into internal energy, sound, deformation, or thermal energy. The shared final speed should be found from momentum conservation and the condition that both carts have the same final velocity, not from K_before = K_after.',
    'Using kinetic-energy conservation in an inelastic collision because momentum is conserved.',
    'In practice, ask two separate questions: Is external impulse negligible for momentum? Is the collision explicitly elastic for kinetic energy? Only the second question licenses K conservation.'
  )
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, practice_subject_key,
  practice_unit_number, practice_topic_code, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, subject_key,
  unit_number, topic_code, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 4 Linear Momentum; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 4: p=mv vector momentum, impulse as integral F dt, F_net=dp/dt, variable-mass systems in scope, component-wise conservation of system momentum in 1-D and 2-D quantitative collisions, and elastic/inelastic/perfectly-inelastic collision distinctions; batch 2026-08-25-ap-physics-c-mechanics-unit4-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_point_briefs.published_at, excluded.published_at);

with explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  (
    'ap_physics_c_mechanics', 4, '4.1', 'Linear Momentum',
    'Momentum is a vector state quantity: p = mv. In Physics C: Mechanics, the vector language matters because collision and explosion problems often move quickly from one-dimensional signed motion into two-dimensional component equations.',
    'Students need to treat each object''s momentum as a vector contribution to a system total. Momentum is useful because a short interaction can be analyzed from initial and final states when internal forces are much larger than external forces during the interaction.',
    'Points come from defining axes, writing p_x and p_y components for each object when needed, and summing by component. A scalar momentum magnitude by itself rarely proves conservation or gives a complete system equation.',
    'Choose axes first, write each object''s momentum as a signed component or vector, then sum components before applying any collision model.',
    'Two pucks have equal masses. One moves east at speed v and the other moves north at speed v. A student says the total momentum magnitude is 2mv because both pucks have momentum mv. What is missing?',
    'The student just needs to add the two momentum magnitudes: mv + mv = 2mv.',
    'The two momenta are perpendicular vectors. If east is x and north is y, the system momentum is mv in the x direction plus mv in the y direction. Its magnitude is sqrt((mv)^2 + (mv)^2) = sqrt(2)mv, not 2mv, and its direction is 45 degrees between east and north. Adding magnitudes loses vector direction information.',
    'Adding momentum magnitudes or speeds directly instead of adding vector components.',
    'Back in practice, write momentum in components before adding. If two objects move in different directions, magnitude addition is almost always the trap.'
  ),
  (
    'ap_physics_c_mechanics', 4, '4.2', 'Change in Momentum and Impulse',
    'Impulse is the accumulated effect of net force over time, J = integral F_net dt, and it equals delta p. The reverse relationship is F_net = dp/dt, so a momentum-time graph has force as its slope. Physics C also keeps variable-mass systems in scope, so dp/dt cannot always be simplified blindly to ma without checking mass behavior.',
    'Students need to use calculus when force or momentum varies continuously. The 2025 Mechanics momentum FRQ showed that many students recognized an integral was needed but did not execute the definite integral correctly; the setup and limits matter.',
    'Points come from writing the correct integral, using the actual bounds of the interaction, carrying vector signs, and evaluating before equating to delta p. A correct idea without the definite integral can miss the scored mathematical routine.',
    'If force varies with time, write J = integral from t_i to t_f of F_net(t) dt before substituting; do not replace the whole interaction with one force value unless an average force is actually given.',
    'A net force on a cart is F(t) = Ct in the +x direction from t = 0 to t = T. What impulse is delivered?',
    'The impulse is F(T) times T, so J = CT^2 in the +x direction.',
    'Because the force changes with time, impulse is the area under F(t): J = integral_0^T Ct dt = (1/2)CT^2 in the +x direction. Multiplying the final force CT by the full time treats the whole triangle under the force-time graph as a rectangle and doubles the impulse.',
    'Using one force value times total time for a time-varying force instead of integrating F(t).',
    'In practice, sketch the force-time graph before integrating. If the force ramps, the area is not final force times total time.'
  ),
  (
    'ap_physics_c_mechanics', 4, '4.3', 'Conservation of Linear Momentum',
    'Momentum conservation is applied component by component. For an isolated two-dimensional collision, total p_x and total p_y are each conserved separately; those two equations can be solved together for unknown final velocity components or magnitudes/directions.',
    'Students need to distinguish the Physics C scope from the algebra-based boundary. Two-dimensional quantitative collisions and simultaneous equations are allowed here, while only three-dimensional collisions are qualitative.',
    'Points are earned by naming the system, stating why external impulse is negligible or zero, and writing separate conservation equations for each component before solving. One scalar equation cannot replace two component equations in 2-D.',
    'Draw the system boundary, then write p_x before = p_x after and p_y before = p_y after separately; solve the component equations rather than collapsing a 2-D collision into one scalar equation.',
    'A puck moving east collides with an identical puck initially at rest, and afterward the two pucks move off at angles above and below the original eastward line. What conservation equations should be written before solving?',
    'Use one equation: initial momentum magnitude equals final momentum magnitude.',
    'Momentum is conserved as a vector, so write separate component equations. In the x direction, the initial eastward momentum equals the sum of the final x components of both pucks. In the y direction, the initial momentum is zero, so the final y components must sum to zero. These two equations are the starting point; a single magnitude equation loses the direction information needed for a 2-D collision.',
    'Writing one momentum equation for a two-dimensional collision and losing a component constraint.',
    'Back in practice, make a two-line conservation setup for every 2-D collision: one x equation and one y equation. That habit keeps the vector nature visible.'
  ),
  (
    'ap_physics_c_mechanics', 4, '4.4', 'Elastic and Inelastic Collisions',
    'Collision type is about kinetic energy, not about whether momentum is conserved. In an isolated system, momentum conservation can hold for elastic, inelastic, and perfectly inelastic collisions; only elastic collisions also conserve total kinetic energy.',
    'Students need to decide when an energy equation is permitted. If the collision is perfectly inelastic, the shared final velocity comes from momentum conservation, and kinetic energy decreases. If the collision is elastic, momentum and kinetic energy equations are both available.',
    'Points come from using the right pair of equations for the stated collision type. For a two-object elastic collision, momentum conservation plus kinetic-energy conservation can determine final speeds; for a sticking collision, only momentum conservation plus the shared-final-velocity condition applies.',
    'Set up the momentum equations first; only add K_before = K_after if the prompt identifies an elastic collision or asks you to test for one.',
    'Two carts stick together after a collision on a frictionless track. A student writes both p_before = p_after and K_before = K_after to solve for the shared final speed. Identify the error.',
    'Both equations are valid because friction is absent, so no energy leaves the system.',
    'The momentum equation is valid for the two-cart system because the external impulse is negligible. The kinetic-energy equation is not valid because sticking together makes the collision perfectly inelastic; some kinetic energy is transformed into internal energy, sound, deformation, or thermal energy. The shared final speed should be found from momentum conservation and the condition that both carts have the same final velocity, not from K_before = K_after.',
    'Using kinetic-energy conservation in an inelastic collision because momentum is conserved.',
    'In practice, ask two separate questions: Is external impulse negligible for momentum? Is the collision explicitly elastic for kinetic energy? Only the second question licenses K conservation.'
  )
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 4 Linear Momentum; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 4: p=mv vector momentum, impulse as integral F dt, F_net=dp/dt, variable-mass systems in scope, component-wise conservation of system momentum in 1-D and 2-D quantitative collisions, and elastic/inelastic/perfectly-inelastic collision distinctions; batch 2026-08-25-ap-physics-c-mechanics-unit4-topic-guides; author=reviewer same session, no independent human review yet',
  now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  core_idea = excluded.core_idea,
  what_students_need_to_understand = excluded.what_students_need_to_understand,
  how_this_becomes_points = excluded.how_this_becomes_points,
  answer_move = excluded.answer_move,
  mini_example_question = excluded.mini_example_question,
  weak_answer = excluded.weak_answer,
  point_attaining_answer = excluded.point_attaining_answer,
  common_point_loss = excluded.common_point_loss,
  practice_bridge = excluded.practice_bridge,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_explainers.published_at, excluded.published_at);

do $$
declare
  v_briefs integer;
  v_explainers integer;
  v_pairing_orphans integer;
  v_unit_mismatches integer;
  v_route_mismatches integer;
  v_core_matches integer;
  v_duplicate_explainer_fields integer;
begin
  select count(*) into v_briefs
  from app.topic_point_briefs
  where subject_key = 'ap_physics_c_mechanics'
    and unit_number = 4
    and topic_code in ('4.1', '4.2', '4.3', '4.4')
    and status = 'published';

  if v_briefs <> 4 then
    raise exception 'expected 4 published AP Physics C:Mechanics Unit 4 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_c_mechanics'
    and unit_number = 4
    and topic_code in ('4.1', '4.2', '4.3', '4.4')
    and status = 'published';

  if v_explainers <> 4 then
    raise exception 'expected 4 published AP Physics C:Mechanics Unit 4 explainers, got %', v_explainers;
  end if;

  select count(*) into v_pairing_orphans
  from (
    select b.subject_key, b.topic_code
    from app.topic_point_briefs b
    left join app.topic_explainers e
      on e.subject_key = b.subject_key
     and e.topic_code = b.topic_code
     and e.status = 'published'
    where b.subject_key = 'ap_physics_c_mechanics'
      and b.unit_number = 4
      and b.topic_code in ('4.1', '4.2', '4.3', '4.4')
      and b.status = 'published'
      and e.topic_code is null
    union all
    select e.subject_key, e.topic_code
    from app.topic_explainers e
    left join app.topic_point_briefs b
      on b.subject_key = e.subject_key
     and b.topic_code = e.topic_code
     and b.status = 'published'
    where e.subject_key = 'ap_physics_c_mechanics'
      and e.unit_number = 4
      and e.topic_code in ('4.1', '4.2', '4.3', '4.4')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 4 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('4.1', '4.2', '4.3', '4.4')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 4 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.unit_number = 4
    and b.topic_code in ('4.1', '4.2', '4.3', '4.4')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-c-mechanics/unit-4/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 4 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('4.1', '4.2', '4.3', '4.4')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 4 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select
      topic_explainer_id,
      mini_example_question,
      weak_answer,
      point_attaining_answer,
      practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_physics_c_mechanics'
      and unit_number = 4
      and topic_code in ('4.1', '4.2', '4.3', '4.4')
      and status = 'published'
  ),
  field_values as (
    select 'mini_example_question' as field_name, mini_example_question as value from new_explainers
    union all
    select 'weak_answer', weak_answer from new_explainers
    union all
    select 'point_attaining_answer', point_attaining_answer from new_explainers
    union all
    select 'practice_bridge', practice_bridge from new_explainers
  )
  select count(*) into v_duplicate_explainer_fields
  from field_values fv
  join app.topic_explainers e
    on (
      e.mini_example_question = fv.value
      or e.weak_answer = fv.value
      or e.point_attaining_answer = fv.value
      or e.practice_bridge = fv.value
    )
  where e.status = 'published'
    and not (
      e.subject_key = 'ap_physics_c_mechanics'
      and e.unit_number = 4
      and e.topic_code in ('4.1', '4.2', '4.3', '4.4')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 4 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
