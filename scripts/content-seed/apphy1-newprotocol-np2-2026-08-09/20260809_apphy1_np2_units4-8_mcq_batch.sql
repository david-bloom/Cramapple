-- AP Physics 1 new-protocol batch np2 -- MCQs (Units 4-8) -- 2026-08-09.
-- Companion to 20260809_apphy1_np2_units4-8_batch.sql (the 10 FRQs).
-- See that file's header for full context.

begin;

-- MCQ 1: apphy1-mcq-np2-001 (Unit 4, p=Ft momentum misconception) -- answer D
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-001', 'mcq', 'apphy1-mcq-np2-001', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'A 2.0 kg cart is at rest on a horizontal frictionless track at time t = 0. The net force exerted on the cart is 3.0 N in the +x direction from t = 0 to t = 2.0 s, and then 3.0 N in the -x direction from t = 2.0 s to t = 4.0 s. What is the magnitude of the cart''s momentum at t = 4.0 s?\n\nA. 12 kg*m/s\nB. 6.0 kg*m/s\nC. 3.0 kg*m/s\nD. 0',
    '{"modules":["unit-4-linear-momentum","topic-4.2"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Medium","content_key":"apphy1-mcq-np2-001","total_points":1,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-001-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', '12 kg*m/s', false, 'This applies p = Ft, using the force magnitude 3.0 N and the total elapsed time 4.0 s. Force times time gives the CHANGE in momentum over the interval that force actually acts, not the momentum itself; and this force does not act in one direction for all 4.0 s.' from new_version
union all select id, 'B', '6.0 kg*m/s', false, 'This accounts only for the impulse delivered during the first 2.0 s. The reversed force during the second interval delivers an equal and opposite impulse of -6.0 N*s, which must also be included.' from new_version
union all select id, 'C', '3.0 kg*m/s', false, '3.0 is the cart''s speed in m/s at t = 2.0 s, not a momentum, and it is evaluated at the wrong time. Momentum and velocity are different quantities with different units.' from new_version
union all select id, 'D', '0', true, 'The impulse-momentum theorem gives Delta-p = sum(F_i*Delta-t_i) = (+3.0)(2.0) + (-3.0)(2.0) = 0. The two signed areas under the net-force-vs-time graph cancel exactly, so the cart returns to zero momentum, the same as it started with.' from new_version;

-- MCQ 2: apphy1-mcq-np2-002 (Unit 4, 2D momentum boundary statement) -- answer B
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-002', 'mcq', 'apphy1-mcq-np2-002', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'Two pucks collide on a frictionless horizontal surface and move off along different directions, neither of which is along either puck''s original line of motion. According to the AP Physics 1 course framework, which of the following is a student expected to be able to do for this two-dimensional collision?\n\nA. Solve the resulting system of simultaneous equations to determine both components of both pucks'' final velocities.\nB. Correctly set up the momentum-conservation equations for each direction, and reason about how changing a given mass, speed, or angle would affect the other quantities.\nC. Nothing -- two-dimensional momentum problems are entirely outside the scope of AP Physics 1.\nD. Apply conservation of momentum only along the direction of the larger initial momentum, since the perpendicular component is negligible.',
    '{"modules":["unit-4-linear-momentum","topic-4.3"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Medium","content_key":"apphy1-mcq-np2-002","total_points":1,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-002-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', 'Solve the resulting system of simultaneous equations to determine both components of both pucks'' final velocities.', false, 'The CED states explicitly that exam questions involving solution of simultaneous equations are not included in AP Physics 1. A full quantitative treatment of two-dimensional momentum with an unknown final velocity belongs to AP Physics 2.' from new_version
union all select id, 'B', 'Correctly set up the momentum-conservation equations for each direction, and reason about how changing a given mass, speed, or angle would affect the other quantities.', true, 'This is the semiquantitative treatment the CED specifies for two dimensions: students set up the equations properly and reason about dependencies, without being asked to solve the resulting system.' from new_version
union all select id, 'C', 'Nothing -- two-dimensional momentum problems are entirely outside the scope of AP Physics 1.', false, 'The CED includes a semiquantitative treatment of conservation of momentum in two dimensions. Only the full quantitative solution is deferred to AP Physics 2; the topic itself is in scope.' from new_version
union all select id, 'D', 'Apply conservation of momentum only along the direction of the larger initial momentum, since the perpendicular component is negligible.', false, 'Momentum is a vector and is conserved independently in each direction whenever the net external force in that direction is zero. A perpendicular component is not negligible simply because it is smaller, and no such rule exists in the framework.' from new_version;

-- MCQ 3: apphy1-mcq-np2-003 (Unit 4, Newton's 3rd law / equal-opposite impulse) -- answer C
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-003', 'mcq', 'apphy1-mcq-np2-003', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'A 1200 kg truck traveling east at 20 m/s collides head-on with a 600 kg car traveling west at 10 m/s. Which of the following correctly compares the magnitude of the truck''s change in momentum during the collision to the magnitude of the car''s change in momentum during the collision?\n\nA. The truck''s change in momentum is twice the car''s, because the truck''s mass is twice the car''s.\nB. The truck''s change in momentum is half the car''s, because the car undergoes the larger acceleration.\nC. The magnitudes are equal, and the changes are in opposite directions.\nD. The truck''s change in momentum is four times the car''s, because the truck has four times the initial momentum.',
    '{"modules":["unit-4-linear-momentum","topic-4.3"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Hard","content_key":"apphy1-mcq-np2-003","total_points":1,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-003-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', 'The truck''s change in momentum is twice the car''s, because the truck''s mass is twice the car''s.', false, 'The mass ratio governs the ratio of the accelerations the two vehicles experience, not the ratio of their momentum changes. Delta-p = F*Delta-t, and both vehicles experience the same force magnitude for the same duration.' from new_version
union all select id, 'B', 'The truck''s change in momentum is half the car''s, because the car undergoes the larger acceleration.', false, 'The car does undergo the larger acceleration (same force, smaller mass), but acceleration is not momentum change. Multiplying the larger acceleration by the smaller mass returns exactly the same force, and hence exactly the same Delta-p magnitude.' from new_version
union all select id, 'C', 'The magnitudes are equal, and the changes are in opposite directions.', true, 'By Newton''s third law the two vehicles exert equal-magnitude, opposite forces on each other for the same contact time, so the impulses are equal and opposite. Since impulse equals the change in momentum, the momentum changes are equal in magnitude and opposite in direction -- independent of the masses and speeds.' from new_version
union all select id, 'D', 'The truck''s change in momentum is four times the car''s, because the truck has four times the initial momentum.', false, 'The initial momenta are indeed 24,000 and 6,000 kg*m/s, a 4:1 ratio, but a momentum change is set by the impulse delivered during the interaction, not by how much momentum an object had beforehand.' from new_version;

-- MCQ 4: apphy1-mcq-np2-004 (Unit 5, torque = rF*sin(theta)) -- answer A
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-004', 'mcq', 'apphy1-mcq-np2-004', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'A wrench of length 0.50 m is used to turn a bolt. A force of magnitude 20 N is applied at the far end of the wrench, in the plane of rotation, at an angle of 30 degrees to the wrench handle. What is the magnitude of the torque exerted on the bolt?\n\nA. 5.0 N*m\nB. 8.7 N*m\nC. 10 N*m\nD. 2.5 N*m',
    '{"modules":["unit-5-torque-and-rotational-dynamics","topic-5.3"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Medium","content_key":"apphy1-mcq-np2-004","total_points":1,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-004-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', '5.0 N*m', true, 'Only the component of the force perpendicular to the wrench produces torque: tau = rF*sin(theta) = (0.50)(20)(sin30) = (10)(0.500) = 5.0 N*m.' from new_version
union all select id, 'B', '8.7 N*m', false, 'This uses cos30 = 0.866 in place of sin30. The cosine gives the component of the force along the handle, which is parallel to the position vector and produces no torque at all.' from new_version
union all select id, 'C', '10 N*m', false, 'This is rF with the angle ignored, which is the torque only when the force is applied perpendicular to the handle. Here the force is at 30 degrees, so only half its magnitude contributes.' from new_version
union all select id, 'D', '2.5 N*m', false, 'This applies the sine factor twice -- once to shorten the position vector to a lever arm and again to the force. The angle should be accounted for exactly once.' from new_version;

-- MCQ 5: apphy1-mcq-np2-005 (Unit 5, translational vs rotational equilibrium independence) -- answer B
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-005', 'mcq', 'apphy1-mcq-np2-005', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'A uniform rod rests on a frictionless horizontal surface. The vector sum of all forces exerted on the rod is zero, yet the rod is observed to rotate with steadily increasing angular speed about its center of mass. Which of the following is true?\n\nA. This situation is impossible, because a zero net force necessarily implies a zero net torque.\nB. The rod is in translational equilibrium but not in rotational equilibrium; two equal and opposite forces applied at different points give zero net force but a nonzero net torque.\nC. The rod is in rotational equilibrium but not in translational equilibrium.\nD. There must be a nonzero net force applied at the rod''s center of mass.',
    '{"modules":["unit-5-torque-and-rotational-dynamics","topic-5.5"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Hard","content_key":"apphy1-mcq-np2-005","total_points":1,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-005-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', 'This situation is impossible, because a zero net force necessarily implies a zero net torque.', false, 'Net force and net torque are independent conditions. Torque depends on where each force is applied, not just on the vector sum of the forces, so forces can cancel while their torques do not.' from new_version
union all select id, 'B', 'The rod is in translational equilibrium but not in rotational equilibrium; two equal and opposite forces applied at different points give zero net force but a nonzero net torque.', true, 'Zero net force gives zero center-of-mass acceleration (translational equilibrium). Rotational equilibrium is the separate condition net-torque=0, which is not met here -- a couple produces net torque with zero net force, so the angular speed changes.' from new_version
union all select id, 'C', 'The rod is in rotational equilibrium but not in translational equilibrium.', false, 'This reverses the two conditions. Increasing angular speed means the net torque is nonzero, so the rod is NOT in rotational equilibrium; and the stated zero net force means it IS in translational equilibrium.' from new_version
union all select id, 'D', 'There must be a nonzero net force applied at the rod''s center of mass.', false, 'This contradicts the given information that the vector sum of the forces is zero. It also would not explain rotation: a force applied at the center of mass has zero lever arm about that point and produces no torque about it.' from new_version;

-- MCQ 6: apphy1-mcq-np2-006 (Unit 6, angular momentum L=rmv*sin(theta) about a point, straight-line motion) -- answer D
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-006', 'mcq', 'apphy1-mcq-np2-006', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'A 0.50 kg ball moves in a straight line at a constant speed of 4.0 m/s. At a particular instant, the ball is 3.0 m from a fixed point P, and the angle between the line from P to the ball and the ball''s velocity is 30 degrees. What is the magnitude of the ball''s angular momentum about point P at that instant?\n\nA. 0, because the ball travels in a straight line and is not rotating.\nB. 6.0 kg*m^2/s\nC. 5.2 kg*m^2/s\nD. 3.0 kg*m^2/s',
    '{"modules":["unit-6-energy-and-momentum-of-rotating-systems","topic-6.3"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Hard","content_key":"apphy1-mcq-np2-006","total_points":1,"calculator_mode":"calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-006-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', '0, because the ball travels in a straight line and is not rotating.', false, 'Angular momentum is defined about a chosen point and does not require the object to be spinning or following a curved path. An object moving in a straight line has nonzero angular momentum about any point not lying on its line of motion.' from new_version
union all select id, 'B', '6.0 kg*m^2/s', false, 'This is rmv with the angle factor omitted, which would be correct only if the velocity were perpendicular to the line from P to the ball. Here the angle is 30 degrees, so only half of that value contributes.' from new_version
union all select id, 'C', '5.2 kg*m^2/s', false, 'This uses cos30 in place of sin30. The cosine picks out the component of velocity along the line from P, which carries the ball directly toward or away from P and contributes nothing to angular momentum about P.' from new_version
union all select id, 'D', '3.0 kg*m^2/s', true, 'L = rmv*sin(theta) = (3.0)(0.50)(4.0)(sin30) = (6.0)(0.500) = 3.0 kg*m^2/s. Only the component of velocity perpendicular to the line from P contributes.' from new_version;

-- MCQ 7: apphy1-mcq-np2-007 (Unit 7, amplitude independence of period, E~A^2) -- answer C
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-007', 'mcq', 'apphy1-mcq-np2-007', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'A block attached to an ideal spring oscillates on a frictionless horizontal surface with amplitude A, period T, and total mechanical energy E. The block is then brought to rest, pulled out to a new displacement 2A, and released from rest. In terms of T and E, what are the new period and the new total mechanical energy?\n\nA. Period 2T; energy 2E\nB. Period T; energy 2E\nC. Period T; energy 4E\nD. Period T/2; energy 4E',
    '{"modules":["unit-7-oscillations","topic-7.3","topic-7.4"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Medium","content_key":"apphy1-mcq-np2-007","total_points":1,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-007-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', 'Period 2T; energy 2E', false, 'This assumes both quantities scale directly with amplitude. The period of a mass-spring oscillator depends only on m and k, and the energy depends on the square of the amplitude, so neither factor is 2.' from new_version
union all select id, 'B', 'Period T; energy 2E', false, 'The period is correctly identified as unchanged, but the energy relationship E = (1/2)kA^2 is quadratic in amplitude, not linear. Doubling A multiplies the stored energy by four, not by two.' from new_version
union all select id, 'C', 'Period T; energy 4E', true, 'T = 2*pi*sqrt(m/k) is independent of amplitude, so the period is unchanged. E_total = (1/2)kA^2 is proportional to A^2, so doubling the amplitude quadruples the total mechanical energy.' from new_version
union all select id, 'D', 'Period T/2; energy 4E', false, 'The energy is correct, but the period does not change with amplitude. A larger amplitude means the block travels farther and moves faster, and for simple harmonic motion these two effects cancel exactly, leaving the period fixed.' from new_version;

-- MCQ 8: apphy1-mcq-np2-008 (Unit 8, buoyant force depends on displaced fluid, not object mass/density/depth) -- answer B
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-008', 'mcq', 'apphy1-mcq-np2-008', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'Two solid cubes have the same volume, but cube X has twice the mass of cube Y. Both cubes are completely submerged and held at rest in a large tank of water: cube X at a depth of 1.0 m and cube Y at a depth of 3.0 m. How do the magnitudes of the buoyant forces on the two cubes compare?\n\nA. The buoyant force on X is twice that on Y, because X has twice the mass.\nB. The buoyant forces are equal, because the cubes displace equal volumes of water.\nC. The buoyant force on Y is greater, because water pressure increases with depth.\nD. The buoyant force on X is greater, because X has the greater density.',
    '{"modules":["unit-8-fluids","topic-8.3"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Medium","content_key":"apphy1-mcq-np2-008","total_points":1,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-008-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', 'The buoyant force on X is twice that on Y, because X has twice the mass.', false, 'The buoyant force depends on the weight of the displaced fluid, not on the weight of the object. The two cubes displace identical volumes of water, so the mass difference affects their weights and the tension needed to hold them, not the buoyant force.' from new_version
union all select id, 'B', 'The buoyant forces are equal, because the cubes displace equal volumes of water.', true, 'F_b = rho_fluid * V_displaced * g. Both cubes are fully submerged with the same volume in the same fluid, so both displace the same weight of water and experience the same buoyant force.' from new_version
union all select id, 'C', 'The buoyant force on Y is greater, because water pressure increases with depth.', false, 'Absolute pressure does increase with depth, but the buoyant force comes from the pressure difference between the bottom and top faces. Lowering a submerged object raises both pressures by the same amount, leaving the difference -- and hence the buoyant force -- unchanged.' from new_version
union all select id, 'D', 'The buoyant force on X is greater, because X has the greater density.', false, 'Only the fluid''s density appears in F_b = rho*V*g. The object''s density determines whether it sinks or floats, but it does not change the buoyant force on a fully submerged object of a given volume.' from new_version;

-- MCQ 9: apphy1-mcq-np2-009 (Unit 8, continuity + Bernoulli, faster=lower pressure) -- answer A
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-009', 'mcq', 'apphy1-mcq-np2-009', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'An ideal fluid flows steadily through a completely filled horizontal pipe. In the wide section the cross-sectional area is 6.0e-3 m^2 and the fluid''s speed is 1.5 m/s. Farther along, at the same height, the pipe narrows to a cross-sectional area of 2.0e-3 m^2. Compared with the wide section, in the narrow section the fluid''s speed and absolute pressure are:\n\nA. 4.5 m/s and lower\nB. 4.5 m/s and higher\nC. 0.50 m/s and higher\nD. 4.5 m/s and unchanged',
    '{"modules":["unit-8-fluids","topic-8.4"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Hard","content_key":"apphy1-mcq-np2-009","total_points":1,"calculator_mode":"calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-009-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', '4.5 m/s and lower', true, 'Continuity gives v2 = A1*v1/A2 = 4.5 m/s. Since the pipe is horizontal, Bernoulli''s equation reduces to P + (1/2)*rho*v^2 = constant, so the increase in the kinetic-energy term requires the pressure to decrease.' from new_version
union all select id, 'B', '4.5 m/s and higher', false, 'The speed is right, but the pressure relationship is inverted. Bernoulli''s equation is a statement of energy conservation: at constant height, an increase in (1/2)*rho*v^2 must be paid for by a decrease in P.' from new_version
union all select id, 'C', '0.50 m/s and higher', false, 'This treats speed as proportional to area rather than inversely proportional to it. Continuity requires that the same volume per second pass every cross-section, so a smaller area forces a LARGER speed, not a smaller one.' from new_version
union all select id, 'D', '4.5 m/s and unchanged', false, 'This treats pressure as depending only on height, so that a horizontal pipe would have uniform pressure. Bernoulli''s equation has three terms, and the velocity term changes here even though the height term does not.' from new_version;

-- MCQ 10: apphy1-mcq-np2-010 (Unit 8, static pressure is a scalar, depends only on depth) -- answer C
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, practice_format)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-np2-010', 'mcq', 'apphy1-mcq-np2-010', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', null)
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, prompt_json, status, content_hash)
  select id, 1,
    E'A large tank of water is open to the atmosphere. Point A and point B are both located 2.0 m below the water''s free surface, but point B is 3.0 m horizontally from point A and lies just next to the tank''s side wall. The density of water is 1000 kg/m^3, atmospheric pressure is 1.0e5 Pa, and g = 10 m/s^2. Which of the following is true?\n\nA. The absolute pressure at each point is 2.0e4 Pa.\nB. The pressure at B is greater than the pressure at A, because near the wall the fluid pushes sideways against the tank.\nC. The absolute pressure at each point is 1.2e5 Pa, because pressure in a static fluid depends only on depth below the free surface.\nD. The pressures are equal only if the tank''s walls are vertical; a tank with sloped walls would give a different pressure at B.',
    '{"modules":["unit-8-fluids","topic-8.2"],"subject":"ap_physics_1","frq_type":null,"archetype":"ap-physics-1-mcq","difficulty":"Medium","content_key":"apphy1-mcq-np2-010","total_points":1,"calculator_mode":"calculator"}'::jsonb,
    'draft', md5('apphy1-mcq-np2-010-v1')
  from new_item
  returning id
)
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select id, 'A', 'The absolute pressure at each point is 2.0e4 Pa.', false, '2.0e4 Pa is the gauge pressure, rho*g*h, which measures pressure relative to atmospheric. The tank is open to the atmosphere, so the absolute pressure must also include the 1.0e5 Pa reference pressure pushing down on the free surface.' from new_version
union all select id, 'B', 'The pressure at B is greater than the pressure at A, because near the wall the fluid pushes sideways against the tank.', false, 'Pressure is a scalar quantity with no direction of its own. At a given point in a static fluid the pressure is the same regardless of the orientation of the surface it acts on, so proximity to a wall does not change it.' from new_version
union all select id, 'C', 'The absolute pressure at each point is 1.2e5 Pa, because pressure in a static fluid depends only on depth below the free surface.', true, 'P = P0 + rho*g*h = 1.0e5 + (1000)(10)(2.0) = 1.2e5 Pa. Both points are at the same depth in the same connected fluid, so both are at the same absolute pressure; horizontal position is irrelevant.' from new_version
union all select id, 'D', 'The pressures are equal only if the tank''s walls are vertical; a tank with sloped walls would give a different pressure at B.', false, 'Pressure at a point in a static fluid is set by the depth below the free surface, not by the shape of the container or the total volume of water above that point.' from new_version;

commit;
