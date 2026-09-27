begin;

-- Add AP Physics 1 Unit 8 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 4 AP Physics 1 Unit 8 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_1_CED_FACT_PACK.md Unit 8 (Fluids).
-- The fact pack confirms density rho=m/V; ideal fluids are incompressible and
-- nonviscous; pressure is scalar with P=F_perp/A, P=P0+rho gh, and gauge
-- pressure rho gh; buoyant force equals the weight of displaced fluid; and
-- continuity, Bernoulli, and Torricelli relationships apply for ideal fluids
-- in completely filled pipes unless otherwise stated. It also notes no
-- released FRQ-level Fluids misconception evidence as of the checked sources.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_1', 8, '8.1', 'Internal Structure and Density',
    'very-important', 'very-important',
    'Density is mass per volume, rho = m/V, and a fluid is a substance with no fixed shape. An ideal fluid is modeled as incompressible and nonviscous.',
    'Density and ideal-fluid assumptions set the starting conditions for pressure, buoyancy, and flow. They tell you what can be treated as constant before applying later fluid equations.',
    'You earn points by distinguishing solids, liquids, and gases by particle interactions, computing density from mass and volume, and naming both ideal-fluid assumptions when used.',
    'State rho = m/V with units, then decide whether the situation allows the ideal-fluid model: incompressible and no viscosity.',
    'Treating ideal fluid as only incompressible and forgetting the no-viscosity assumption.',
    '/learn/ap-physics-1/unit-8/internal-structure-and-density'
  ),
  (
    'ap_physics_1', 8, '8.2', 'Pressure',
    'very-important', 'very-important',
    'Pressure is perpendicular force per area, P = F_perp/A, and it is a scalar. In a static fluid, pressure can increase with depth as P = P0 + rho gh.',
    'Pressure connects microscopic fluid-surface interactions to macroscopic forces. Depth, density, and reference pressure explain why fluid forces change with location.',
    'You earn points by using perpendicular force, area, density, depth, and reference pressure correctly and by distinguishing absolute pressure from gauge pressure.',
    'Draw the surface area receiving the force, use the perpendicular component, and choose P = P0 + rho gh or P_gauge = rho gh based on what the prompt asks.',
    'Using total force direction or object volume instead of perpendicular force over contact area.',
    '/learn/ap-physics-1/unit-8/pressure'
  ),
  (
    'ap_physics_1', 8, '8.3', 'Fluids and Newton''s Laws',
    'very-important', 'very-important',
    'Newton''s laws still apply to fluids and objects in fluids. Buoyant force is the upward net force from fluid interactions and equals the weight of displaced fluid.',
    'This topic turns fluid interactions into force diagrams. Floating, sinking, and acceleration questions depend on comparing weight, buoyant force, and any other external forces.',
    'You earn points by drawing forces on the object or fluid element, applying Newton''s second law to the selected object/system, and calculating buoyant force as rho V g for displaced fluid.',
    'Start with a force diagram: weight downward, buoyant force upward, and any applied or contact forces; then write net force from those forces.',
    'Using the object mass in the buoyant-force expression instead of the displaced fluid density and displaced volume.',
    '/learn/ap-physics-1/unit-8/fluids-and-newtons-laws'
  ),
  (
    'ap_physics_1', 8, '8.4', 'Fluids and Conservation Laws',
    'very-important', 'very-important',
    'Conservation laws describe ideal-fluid flow: continuity conserves mass flow rate, A1 v1 = A2 v2, and Bernoulli relates pressure, height, and speed along a flow.',
    'Flow questions combine geometry with conservation. Narrower regions can have greater speed, and pressure differences, height changes, and speed changes trade through energy conservation.',
    'You earn points by checking ideal-fluid and filled-pipe assumptions, applying continuity between cross sections, and using Bernoulli or Torricelli with consistent heights and pressures.',
    'Use continuity first when areas and speeds are linked; then apply Bernoulli between two points with clearly chosen y values, pressures, and speeds.',
    'Assuming higher speed always means higher pressure without applying Bernoulli with height and reference points.',
    '/learn/ap-physics-1/unit-8/fluids-and-conservation-laws'
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
    'ap_physics_1', 8, '8.1', 'Internal Structure and Density',
    'Density links matter to volume, and the fluid model starts by deciding what shape and compressibility assumptions are allowed. In AP Physics 1, an ideal fluid must be treated as both incompressible and nonviscous.',
    'Students need to distinguish a material property from an object size. Density is mass divided by volume, so two samples of the same uniform material can have different masses and volumes but the same density. Ideal-fluid assumptions then let later pressure and flow equations ignore volume compression and viscous energy losses.',
    'Points come from writing rho = m/V with correct units, recognizing that liquids and gases have no fixed shape, and explicitly naming both ideal-fluid assumptions before using equations that depend on them.',
    'State rho = m/V with units, then decide whether the situation allows the ideal-fluid model: incompressible and no viscosity.',
    'Two sealed containers hold the same liquid. Container A has twice the liquid volume and twice the liquid mass of container B. How do their densities compare?',
    'Container A has greater density because it has more mass.',
    'The densities are the same if the liquid is uniform. Density is rho = m/V, so doubling both mass and volume leaves the ratio unchanged. More mass alone is not enough; density compares mass to volume.',
    'Treating ideal fluid as only incompressible and forgetting the no-viscosity assumption.',
    'Back in practice, write density as a ratio before comparing samples. Then list both ideal-fluid assumptions before using fluid-flow equations.'
  ),
  (
    'ap_physics_1', 8, '8.2', 'Pressure',
    'Pressure is force spread over area, using only the force component perpendicular to the surface. In a fluid at rest, pressure at a point depends on reference pressure plus rho gh below that reference level, while gauge pressure reports only the rho gh part.',
    'Students need to treat pressure as a scalar even though it creates forces on surfaces. Larger depth or larger fluid density increases hydrostatic pressure. An incompressible fluid has constant volume and density even when pressure changes, so pressure change does not automatically mean density change.',
    'Points come from selecting F_perp, using area in the denominator, identifying whether absolute or gauge pressure is requested, and measuring depth vertically from the chosen reference level.',
    'Draw the surface area receiving the force, use the perpendicular component, and choose P = P0 + rho gh or P_gauge = rho gh based on what the prompt asks.',
    'A horizontal plate of area A is under water at depth h. The water pressure at that depth is P0 + rho gh. What fluid force magnitude acts perpendicular to the plate?',
    'The force is rho gh because pressure already includes the force of the water.',
    'Pressure is force per area, so the force magnitude is F = PA = (P0 + rho gh)A if absolute pressure is acting on that side. If the question asks only for the extra force due to the water column compared with atmosphere, the gauge part is rho gh A. The area must be included to convert pressure to force.',
    'Using total force direction or object volume instead of perpendicular force over contact area.',
    'In practice, label whether you are using absolute pressure or gauge pressure before multiplying by area.'
  ),
  (
    'ap_physics_1', 8, '8.3', 'Fluids and Newton''s Laws',
    'Fluids exert forces that fit Newton''s laws. The buoyant force is an upward net force from pressure differences in the fluid, and its magnitude equals the weight of the displaced fluid: F_b = rho_fluid V_displaced g.',
    'Students need to avoid treating buoyancy as a property of the object alone. The surrounding fluid density and displaced fluid volume determine the buoyant force. The object weight still depends on the object mass, so floating, sinking, and accelerating depend on the net force comparison.',
    'Points are earned by drawing a force diagram, identifying the displaced volume, using the fluid density in F_b, and applying Newton''s second law to the chosen object or system. Equilibrium means net force is zero; acceleration means the force difference is not zero.',
    'Start with a force diagram: weight downward, buoyant force upward, and any applied or contact forces; then write net force from those forces.',
    'A block is fully submerged in water and held at rest by a string. What determines the buoyant force magnitude on the block?',
    'The buoyant force is the block mass times g because the block is at rest.',
    'The buoyant force equals the weight of the displaced water: F_b = rho_water V_displaced g. The block being at rest tells you the net force is zero after including weight and string force, but it does not make buoyant force equal to the block weight unless the other forces and densities make that true.',
    'Using the object mass in the buoyant-force expression instead of the displaced fluid density and displaced volume.',
    'Back in practice, write rho_fluid and V_displaced in the buoyant-force line. That keeps buoyancy separate from the object weight line.'
  ),
  (
    'ap_physics_1', 8, '8.4', 'Fluids and Conservation Laws',
    'For ideal incompressible flow in a filled tube, continuity says volume flow rate is conserved, so A1 v1 = A2 v2. Bernoulli applies conservation of mechanical energy along the flow using pressure, gravitational potential energy per volume, and kinetic energy per volume.',
    'Students need to choose which conservation law answers the question. Continuity links area and speed. Bernoulli links pressure, height, and speed. Torricelli''s result follows from energy conservation for fluid exiting from a height difference. The CED boundary assumes ideal fluids and completely filled pipes unless the prompt says otherwise.',
    'Points come from checking assumptions, matching two points in the same flow, keeping height references consistent, and not using a single shortcut such as faster means lower pressure unless height and energy terms have been accounted for.',
    'Use continuity first when areas and speeds are linked; then apply Bernoulli between two points with clearly chosen y values, pressures, and speeds.',
    'An ideal incompressible fluid flows through a horizontal pipe that narrows from area 2A to area A. If the speed in the wider section is v, what is the speed in the narrow section?',
    'The speed stays v because the same fluid is flowing through the pipe.',
    'Continuity requires A1 v1 = A2 v2 for incompressible flow. With A1 = 2A, v1 = v, and A2 = A, the narrow-section speed is v2 = 2v. The same volume per time must pass through each cross section, so smaller area means larger speed.',
    'Assuming higher speed always means higher pressure without applying Bernoulli with height and reference points.',
    'In practice, use continuity for area-speed changes before Bernoulli. Then use Bernoulli only after choosing the two points and height reference.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 8 Fluids; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 8: density rho=m/V, ideal fluid incompressible and nonviscous assumptions, pressure P=F_perp/A plus P=P0+rho gh and gauge pressure rho gh, buoyant force as displaced-fluid weight, continuity, Bernoulli, Torricelli, ideal-fluid/filled-pipe boundary, and explicit note that no released FRQ-level Fluids misconception evidence was available in checked sources; batch 2026-08-25-ap-physics-1-unit8-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_1', 8, '8.1', 'Internal Structure and Density',
    'Density links matter to volume, and the fluid model starts by deciding what shape and compressibility assumptions are allowed. In AP Physics 1, an ideal fluid must be treated as both incompressible and nonviscous.',
    'Students need to distinguish a material property from an object size. Density is mass divided by volume, so two samples of the same uniform material can have different masses and volumes but the same density. Ideal-fluid assumptions then let later pressure and flow equations ignore volume compression and viscous energy losses.',
    'Points come from writing rho = m/V with correct units, recognizing that liquids and gases have no fixed shape, and explicitly naming both ideal-fluid assumptions before using equations that depend on them.',
    'State rho = m/V with units, then decide whether the situation allows the ideal-fluid model: incompressible and no viscosity.',
    'Two sealed containers hold the same liquid. Container A has twice the liquid volume and twice the liquid mass of container B. How do their densities compare?',
    'Container A has greater density because it has more mass.',
    'The densities are the same if the liquid is uniform. Density is rho = m/V, so doubling both mass and volume leaves the ratio unchanged. More mass alone is not enough; density compares mass to volume.',
    'Treating ideal fluid as only incompressible and forgetting the no-viscosity assumption.',
    'Back in practice, write density as a ratio before comparing samples. Then list both ideal-fluid assumptions before using fluid-flow equations.'
  ),
  (
    'ap_physics_1', 8, '8.2', 'Pressure',
    'Pressure is force spread over area, using only the force component perpendicular to the surface. In a fluid at rest, pressure at a point depends on reference pressure plus rho gh below that reference level, while gauge pressure reports only the rho gh part.',
    'Students need to treat pressure as a scalar even though it creates forces on surfaces. Larger depth or larger fluid density increases hydrostatic pressure. An incompressible fluid has constant volume and density even when pressure changes, so pressure change does not automatically mean density change.',
    'Points come from selecting F_perp, using area in the denominator, identifying whether absolute or gauge pressure is requested, and measuring depth vertically from the chosen reference level.',
    'Draw the surface area receiving the force, use the perpendicular component, and choose P = P0 + rho gh or P_gauge = rho gh based on what the prompt asks.',
    'A horizontal plate of area A is under water at depth h. The water pressure at that depth is P0 + rho gh. What fluid force magnitude acts perpendicular to the plate?',
    'The force is rho gh because pressure already includes the force of the water.',
    'Pressure is force per area, so the force magnitude is F = PA = (P0 + rho gh)A if absolute pressure is acting on that side. If the question asks only for the extra force due to the water column compared with atmosphere, the gauge part is rho gh A. The area must be included to convert pressure to force.',
    'Using total force direction or object volume instead of perpendicular force over contact area.',
    'In practice, label whether you are using absolute pressure or gauge pressure before multiplying by area.'
  ),
  (
    'ap_physics_1', 8, '8.3', 'Fluids and Newton''s Laws',
    'Fluids exert forces that fit Newton''s laws. The buoyant force is an upward net force from pressure differences in the fluid, and its magnitude equals the weight of the displaced fluid: F_b = rho_fluid V_displaced g.',
    'Students need to avoid treating buoyancy as a property of the object alone. The surrounding fluid density and displaced fluid volume determine the buoyant force. The object weight still depends on the object mass, so floating, sinking, and accelerating depend on the net force comparison.',
    'Points are earned by drawing a force diagram, identifying the displaced volume, using the fluid density in F_b, and applying Newton''s second law to the chosen object or system. Equilibrium means net force is zero; acceleration means the force difference is not zero.',
    'Start with a force diagram: weight downward, buoyant force upward, and any applied or contact forces; then write net force from those forces.',
    'A block is fully submerged in water and held at rest by a string. What determines the buoyant force magnitude on the block?',
    'The buoyant force is the block mass times g because the block is at rest.',
    'The buoyant force equals the weight of the displaced water: F_b = rho_water V_displaced g. The block being at rest tells you the net force is zero after including weight and string force, but it does not make buoyant force equal to the block weight unless the other forces and densities make that true.',
    'Using the object mass in the buoyant-force expression instead of the displaced fluid density and displaced volume.',
    'Back in practice, write rho_fluid and V_displaced in the buoyant-force line. That keeps buoyancy separate from the object weight line.'
  ),
  (
    'ap_physics_1', 8, '8.4', 'Fluids and Conservation Laws',
    'For ideal incompressible flow in a filled tube, continuity says volume flow rate is conserved, so A1 v1 = A2 v2. Bernoulli applies conservation of mechanical energy along the flow using pressure, gravitational potential energy per volume, and kinetic energy per volume.',
    'Students need to choose which conservation law answers the question. Continuity links area and speed. Bernoulli links pressure, height, and speed. Torricelli''s result follows from energy conservation for fluid exiting from a height difference. The CED boundary assumes ideal fluids and completely filled pipes unless the prompt says otherwise.',
    'Points come from checking assumptions, matching two points in the same flow, keeping height references consistent, and not using a single shortcut such as faster means lower pressure unless height and energy terms have been accounted for.',
    'Use continuity first when areas and speeds are linked; then apply Bernoulli between two points with clearly chosen y values, pressures, and speeds.',
    'An ideal incompressible fluid flows through a horizontal pipe that narrows from area 2A to area A. If the speed in the wider section is v, what is the speed in the narrow section?',
    'The speed stays v because the same fluid is flowing through the pipe.',
    'Continuity requires A1 v1 = A2 v2 for incompressible flow. With A1 = 2A, v1 = v, and A2 = A, the narrow-section speed is v2 = 2v. The same volume per time must pass through each cross section, so smaller area means larger speed.',
    'Assuming higher speed always means higher pressure without applying Bernoulli with height and reference points.',
    'In practice, use continuity for area-speed changes before Bernoulli. Then use Bernoulli only after choosing the two points and height reference.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 8 Fluids; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 8: density rho=m/V, ideal fluid incompressible and nonviscous assumptions, pressure P=F_perp/A plus P=P0+rho gh and gauge pressure rho gh, buoyant force as displaced-fluid weight, continuity, Bernoulli, Torricelli, ideal-fluid/filled-pipe boundary, and explicit note that no released FRQ-level Fluids misconception evidence was available in checked sources; batch 2026-08-25-ap-physics-1-unit8-topic-guides; author=reviewer same session, no independent human review yet',
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
  where subject_key = 'ap_physics_1'
    and unit_number = 8
    and topic_code in ('8.1', '8.2', '8.3', '8.4')
    and status = 'published';

  if v_briefs <> 4 then
    raise exception 'expected 4 published AP Physics 1 Unit 8 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_1'
    and unit_number = 8
    and topic_code in ('8.1', '8.2', '8.3', '8.4')
    and status = 'published';

  if v_explainers <> 4 then
    raise exception 'expected 4 published AP Physics 1 Unit 8 explainers, got %', v_explainers;
  end if;

  select count(*) into v_pairing_orphans
  from (
    select b.subject_key, b.topic_code
    from app.topic_point_briefs b
    left join app.topic_explainers e
      on e.subject_key = b.subject_key
     and e.topic_code = b.topic_code
     and e.status = 'published'
    where b.subject_key = 'ap_physics_1'
      and b.unit_number = 8
      and b.topic_code in ('8.1', '8.2', '8.3', '8.4')
      and b.status = 'published'
      and e.topic_code is null
    union all
    select e.subject_key, e.topic_code
    from app.topic_explainers e
    left join app.topic_point_briefs b
      on b.subject_key = e.subject_key
     and b.topic_code = e.topic_code
     and b.status = 'published'
    where e.subject_key = 'ap_physics_1'
      and e.unit_number = 8
      and e.topic_code in ('8.1', '8.2', '8.3', '8.4')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 8 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('8.1', '8.2', '8.3', '8.4')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 8 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_1'
    and b.unit_number = 8
    and b.topic_code in ('8.1', '8.2', '8.3', '8.4')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-1/unit-8/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 8 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('8.1', '8.2', '8.3', '8.4')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 8 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select
      topic_explainer_id,
      mini_example_question,
      weak_answer,
      point_attaining_answer,
      practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_physics_1'
      and unit_number = 8
      and topic_code in ('8.1', '8.2', '8.3', '8.4')
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
      e.subject_key = 'ap_physics_1'
      and e.unit_number = 8
      and e.topic_code in ('8.1', '8.2', '8.3', '8.4')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 8 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
