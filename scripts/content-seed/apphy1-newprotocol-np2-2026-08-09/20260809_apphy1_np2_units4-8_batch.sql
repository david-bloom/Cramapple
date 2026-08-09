-- AP Physics 1 new-protocol batch np2 (Units 4-8) -- 2026-08-09.
--
-- Owner-directed: create 10 new FRQs + 10 new MCQs for AP Physics 1, using
-- the same grounded-authoring + full hand-verification protocol as the
-- np1 batch (docs: scripts/content-seed/apphy1-newprotocol-2026-08-08/),
-- specifically to give Ahmed Ali a controlled batch of never-before-seen
-- content to review, so his decisions on it can be compared against his
-- historical review pattern (50 decisions so far today: 4 approve, 46
-- approve_with_edits, 0 disapprove).
--
-- np1 covered Units 1-3 only; this batch (np2) covers Units 4-8
-- (Momentum, Rotational Dynamics, Rotational Energy/Angular Momentum,
-- Oscillations, Fluids) so the two batches don't overlap topically.
-- Grounded in docs/product/AP_PHYSICS_1_CED_FACT_PACK.md section 6
-- ("Units 4-8 deep-tier detail," added 2026-08-08). Every item traces to
-- a specific documented misconception, CED boundary statement, or CED
-- content claim -- see the authoring agent's per-item "Grounding" notes,
-- preserved in docs/research/APPHY1_NP2_CONTENT_BATCH_2026_08_09.md.
--
-- Point structure note: this batch uses 9 points/4 criteria per FRQ
-- (multi-point criteria), matching the Physics C 9-10 point convention
-- and the owner's explicit instruction. This diverges from np1 (1
-- point/criterion, 4-5 points total) and from most existing apphy1-*
-- items in Production (also 1 pt/criterion, 4-6 total) -- flagged, not
-- silently normalized, since no hard schema constraint requires 1 pt/
-- criterion and the divergence doesn't block insertion.
--
-- Inserted as status='draft' -- not assigned yet. A separate independent
-- §9 QA pass will verify this batch before it goes into Ahmed's queue.

begin;

-- ============================================================
-- FRQ 1: apphy1-frq-np2-001 (Unit 4, impulse-momentum, p=Ft misconception)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-001', 'frq', 'apphy1-frq-np2-001', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-impulse-momentum')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) Calculate the impulse delivered to the cart from t = 0 to t = 1.0 s, and calculate the cart''s momentum and speed at t = 1.0 s.\n\n(b) Calculate the cart''s momentum at t = 3.0 s.\n\n(c) A student claims that the cart''s momentum at t = 3.0 s is p = Ft = (2.0 N)(3.0 s) = 6.0 kg*m/s. Explain what is wrong with the student''s reasoning, and state the correct relationship between force, time, and momentum.\n\n(d) State the time at which the cart''s speed is greatest, give that speed, and justify your answer by reference to the direction of the net force.',
    'A 0.50 kg cart is at rest on a horizontal frictionless track at time t = 0. The net force exerted on the cart is directed in the +x direction with constant magnitude 4.0 N from t = 0 to t = 1.0 s, and is then directed in the -x direction with constant magnitude 2.0 N from t = 1.0 s to t = 3.0 s.',
    '{"modules":["unit-4-linear-momentum","topic-4.2","topic-4.3"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-impulse-momentum","difficulty":"Medium","content_key":"apphy1-frq-np2-001","total_points":9,"calculator_mode":"no-calculator"}'::jsonb,
    'draft',
    md5('apphy1-frq-np2-001-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly computes the impulse as +4.0 N*s from the area under the force-time graph, and uses it to obtain a momentum of 4.0 kg*m/s and a speed of 8.0 m/s at t = 1.0 s.', 2, 'Response shows J=(4.0)(1.0)=4.0 N*s, p=4.0 kg*m/s, and v=p/m=8.0 m/s.', 'Compute the impulse as the area under the force-time graph before converting to momentum and speed.', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly computes the second impulse as -4.0 N*s and adds it to the first to obtain a momentum of 0 at t = 3.0 s.', 2, 'Response shows J2=(-2.0)(2.0)=-4.0 N*s and p=4.0-4.0=0.', 'Assign a negative sign to the second interval''s impulse and add it to the momentum from part (a).', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly identifies that momentum is not given by p = Ft, states the impulse-momentum theorem Delta-p = F_avg*Delta-t as the correct relationship, and identifies at least one specific error in the student''s substitution.', 3, 'Response states Delta-p = F_avg*Delta-t, rejects p=Ft as a definition of momentum, and names a specific flaw in the student''s numbers.', 'Write the impulse-momentum theorem explicitly and use it to explain that force-times-time gives a CHANGE in momentum, not the momentum itself.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Correctly states that the speed is greatest at t = 1.0 s with a value of 8.0 m/s, and justifies this by noting that the net force reverses direction and thereafter opposes the cart''s velocity.', 2, 'Response gives t=1.0 s and 8.0 m/s with reasoning tied to the direction of the net force relative to the velocity.', 'State whether the net force is parallel or antiparallel to the velocity in each interval, and connect that to whether speed increases or decreases.', '[]'::jsonb from new_version;

-- ============================================================
-- FRQ 2: apphy1-frq-np2-002 (Unit 4, momentum conservation, elastic vs inelastic, COM invariance)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-002', 'frq', 'apphy1-frq-np2-002', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-momentum-conservation')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) In Experiment 1, the blocks stick together after the collision. Calculate the velocity of the combined blocks immediately after the collision.\n\n(b) Calculate the total kinetic energy of the two-block system immediately before and immediately after the Experiment 1 collision, and state whether that collision is elastic or inelastic.\n\n(c) In Experiment 2, the blocks do not stick together, and block A is observed to move at 2.0 m/s in the -x direction after the collision. Calculate block B''s velocity after this collision, and show by calculation whether this collision is elastic.\n\n(d) Determine the velocity of the two-block system''s center of mass before the collision and after the collision in each experiment. Explain what your results show about how the center-of-mass motion depends on the type of collision.',
    'Block A has mass 2.0 kg and slides along a horizontal frictionless surface at 6.0 m/s in the +x direction. Block B has mass 4.0 kg and is initially at rest on the same surface. Block A collides with block B. Two separate experiments are performed with these same initial conditions.',
    '{"modules":["unit-4-linear-momentum","topic-4.3","topic-4.4"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-momentum-conservation","difficulty":"Hard","content_key":"apphy1-frq-np2-002","total_points":9,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-frq-np2-002-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly applies conservation of momentum to obtain a total momentum of 12 kg*m/s and a common final velocity of 2.0 m/s in the +x direction.', 2, 'Response shows p_i=(2.0)(6.0)=12 kg*m/s set equal to (6.0 kg)v to obtain v=2.0 m/s.', 'Write the momentum-conservation equation with the combined mass on the final side before solving.', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly computes the initial kinetic energy as 36 J and the final kinetic energy as 12 J, and identifies the collision as inelastic because system kinetic energy decreases.', 2, 'Response shows 36 J and 12 J with the explicit conclusion inelastic tied to the decrease in system kinetic energy.', 'Compute both kinetic energies numerically and compare them, rather than asserting the collision type from the fact that the blocks stick together alone.', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly uses conservation of momentum with block A''s given rebound velocity of -2.0 m/s to obtain block B''s velocity of +4.0 m/s, and shows by computing a final kinetic energy of 36 J that this collision is elastic.', 3, 'Response shows 12 = (2.0)(-2.0) + (4.0)v_B giving v_B=+4.0 m/s, and shows K_f = 4.0 + 32 = 36 J equal to K_i.', 'Carry the negative sign on block A''s post-collision velocity into the momentum equation, then compute the post-collision kinetic energy and compare it to 36 J.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Correctly determines the center-of-mass velocity as 2.0 m/s both before and after the collision in both experiments, and explains that it is identical in the two cases because the absence of a net external force makes total system momentum constant regardless of collision type.', 2, 'Response gives v_cm=2.0 m/s for before and after in both experiments, and states explicitly that the center-of-mass motion is the same for the elastic and the inelastic case, justified by zero net external force.', 'Compute v_cm as total momentum divided by total mass for each case and note that the numerator and denominator are unchanged by the collision.', '[]'::jsonb from new_version;

-- ============================================================
-- FRQ 3: apphy1-frq-np2-003 (Unit 5, torque/rotational equilibrium, hinge force)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-003', 'frq', 'apphy1-frq-np2-003', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-rotational-equilibrium')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) Calculate the magnitude of the torque exerted on the beam by the gravitational force, about an axis through the hinge.\n\n(b) Calculate the magnitude of the tension in the cable.\n\n(c) Calculate the magnitude and direction of the force exerted on the beam by the hinge.\n\n(d) A student argues that the hinge force must be purely horizontal, since the cable "already holds the beam up." Explain why this cannot be correct, using your numerical results.',
    'A uniform beam of mass 12.0 kg and length 3.00 m is held in a horizontal position. Its left end is attached to a wall by a hinge. A cable is attached to the beam at a point 2.00 m from the hinge and runs upward to the wall, making an angle of 30.0 degrees with the beam. The beam is in static equilibrium. Use g = 10 m/s^2.',
    '{"modules":["unit-5-torque-and-rotational-dynamics","topic-5.3","topic-5.5"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-rotational-equilibrium","difficulty":"Very Hard","content_key":"apphy1-frq-np2-003","total_points":9,"calculator_mode":"calculator"}'::jsonb,
    'draft', md5('apphy1-frq-np2-003-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly computes the gravitational torque about the hinge as 180 N*m, using a weight of 120 N acting at the beam''s midpoint 1.50 m from the hinge.', 2, 'Response shows mg = 120 N and a lever arm of 1.50 m (half the beam length) giving 180 N-m.', 'Place the beam''s weight at its midpoint, 1.50 m from the hinge, before computing torque.', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly applies rotational equilibrium about the hinge, using only the perpendicular component of the tension, to obtain a tension of 180 N.', 2, 'Response shows (2.00)(T)(sin 30.0 deg) = 180 solved for T = 180 N.', 'Use only the component of tension perpendicular to the beam when computing the cable''s torque, not the full tension.', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly resolves the tension into components (90.0 N vertical, 155.9 N horizontal), applies both force-balance equations to obtain hinge components of 30.0 N upward and 155.9 N away from the wall, and reports a magnitude of approximately 159 N directed approximately 11 degrees above the horizontal.', 3, 'Response shows T_y = 90.0 N, T_x = 155.9 N, H_y = 30.0 N up, H_x = 155.9 N away from the wall, and a resultant near 159 N at about 11 degrees above horizontal.', 'Write both the vertical and the horizontal force-balance equations for the beam and solve each for the corresponding hinge component before combining them.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Correctly refutes the student by showing that the cable''s vertical component (90.0 N) is less than the beam''s weight (120 N), so the hinge must supply a 30.0 N upward component.', 2, 'Response contrasts the 90.0 N vertical tension component with the 120 N weight and concludes the hinge supplies 30.0 N upward.', 'Compare the cable''s vertical component to the beam''s weight numerically, and state what a purely horizontal hinge force would leave unbalanced.', '[]'::jsonb from new_version;

-- ============================================================
-- FRQ 4: apphy1-frq-np2-004 (Unit 5, rotational inertia, torque=I*alpha)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-004', 'frq', 'apphy1-frq-np2-004', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-rotational-inertia')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) Calculate the rotational inertia of the system about the given axis.\n\n(b) A force of magnitude 5.0 N is exerted on one end of the rod, in the horizontal plane and perpendicular to the rod. Calculate the magnitude of the torque exerted on the system and the magnitude of the resulting angular acceleration.\n\n(c) The same 5.0 N force is instead exerted at the same point but at an angle of 60.0 degrees to the rod, still in the horizontal plane. Calculate the magnitude of the torque and the resulting angular acceleration.\n\n(d) The two 3.0 kg objects are moved outward and refastened at the ends of the rod, alongside the 2.0 kg objects. Calculate the new rotational inertia, and determine the angular acceleration that the 5.0 N perpendicular force of part (b) would now produce. Explain how this result illustrates why a hoop has a greater rotational inertia than a solid disk of the same mass and radius.',
    'A rigid rod of negligible mass and length 1.20 m is free to rotate in a horizontal plane about a fixed vertical axis through its center. Four small objects, each of which may be treated as a point mass, are fastened to the rod: a 2.0 kg object at each end of the rod, and a 3.0 kg object at each of the two points located 0.200 m from the center.',
    '{"modules":["unit-5-torque-and-rotational-dynamics","topic-5.3","topic-5.4","topic-5.6"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-rotational-inertia","difficulty":"Hard","content_key":"apphy1-frq-np2-004","total_points":9,"calculator_mode":"calculator"}'::jsonb,
    'draft', md5('apphy1-frq-np2-004-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly computes the system''s rotational inertia as 1.68 kg*m^2, summing m*r^2 for all four point objects using r = 0.600 m for the end objects and r = 0.200 m for the inner objects.', 2, 'Response shows 2(2.0)(0.600)^2 + 2(3.0)(0.200)^2 = 1.44 + 0.24 = 1.68 kg*m^2.', 'Convert each object''s position into its distance from the central axis before squaring, and include both objects at each radius.', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly computes a torque of 3.00 N*m and an angular acceleration of approximately 1.79 rad/s^2 using Newton''s second law in rotational form.', 2, 'Response shows tau = (0.600)(5.0) = 3.00 N-m and alpha = tau/I = 3.00/1.68.', 'Divide the net torque by the rotational inertia from part (a) rather than by the total mass.', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly computes the torque as approximately 2.60 N*m using only the perpendicular component of the force, and the corresponding angular acceleration as approximately 1.55 rad/s^2.', 2, 'Response includes the sin(60.0 deg) factor, giving about 2.60 N-m, then divides by 1.68 kg-m^2.', 'Multiply the force by sin of the angle it makes with the rod, since only the perpendicular component produces torque.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Correctly computes the new rotational inertia as 3.60 kg*m^2 and the new angular acceleration as approximately 0.833 rad/s^2, and explains that total mass is unchanged while rotational inertia increases because it depends on the square of the distance from the axis.', 3, 'Response shows I'' = 3.60 kg-m^2 and alpha'' = 0.833 rad/s^2, and connects the increase to the r-squared dependence with the hoop-versus-disk comparison.', 'Recompute the sum of m*r^2 with all four objects at 0.600 m, then state explicitly that mass farther from the axis raises rotational inertia.', '[]'::jsonb from new_version;

-- ============================================================
-- FRQ 5: apphy1-frq-np2-005 (Unit 5, rotational kinematics, omega-t graph concavity)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-005', 'frq', 'apphy1-frq-np2-005', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-rotational-kinematics')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) Calculate the wheel''s angular speed at t = 3.0 s.\n\n(b) Calculate the angular displacement of the wheel during the 3.0 s interval, and the distance traveled along the rim by a point on the wheel''s edge during that interval.\n\n(c) Calculate the speed and the tangential acceleration of a point on the wheel''s rim at t = 3.0 s.\n\n(d) A second wheel, initially at rest, is acted on by a net torque that is in the counterclockwise direction at all times but whose magnitude decreases steadily toward zero as the wheel turns. Describe the shape of a graph of this wheel''s angular speed as a function of time, addressing both whether the angular speed increases or decreases and how the rate of that change behaves. Justify your description.',
    'A wheel of radius 0.50 m is mounted on a fixed axle through its center. Starting from rest, the wheel undergoes a constant angular acceleration of magnitude 4.0 rad/s^2 in the counterclockwise direction for 3.0 s.',
    '{"modules":["unit-5-torque-and-rotational-dynamics","topic-5.1","topic-5.2","topic-5.5"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-rotational-kinematics","difficulty":"Medium","content_key":"apphy1-frq-np2-005","total_points":9,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-frq-np2-005-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly computes the angular speed as 12 rad/s using the constant-angular-acceleration relationship with an initial angular speed of zero.', 2, 'Response shows omega = 0 + (4.0)(3.0) = 12 rad/s.', 'Substitute the initial angular speed of zero into omega = omega_0 + alpha*t.', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly computes the angular displacement as 18 rad and the rim distance as 9.0 m using Delta-s = r*Delta-theta with the angle in radians.', 2, 'Response shows 18 rad from the angular kinematic equation and 9.0 m from Delta-s = r*Delta-theta.', 'Use the angular displacement in radians directly in Delta-s = r*Delta-theta; do not convert to degrees or revolutions first.', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly computes the rim speed as 6.0 m/s using v = r*omega and the tangential acceleration as 2.0 m/s^2 using a_T = r*alpha.', 2, 'Response shows v = (0.50)(12) = 6.0 m/s and a_T = (0.50)(4.0) = 2.0 m/s^2.', 'Apply v = r*omega and a_T = r*alpha separately; do not use the angular values as if they were linear ones.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Correctly states that the angular speed increases throughout AND that the rate of increase decreases so the graph is concave down and levels off, with both features justified by the direction and decreasing magnitude of the net torque.', 3, 'Response asserts monotonically increasing angular speed AND concave-down (decreasing-slope) shape, each tied to the direction and the decreasing magnitude of the net torque.', 'After establishing that the angular speed increases, address separately how the DECREASING net torque affects the angular acceleration and therefore the steepness of the graph over time.', '[]'::jsonb from new_version;

-- ============================================================
-- FRQ 6: apphy1-frq-np2-006 (Unit 6, angular momentum conservation, nonrigid system)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-006', 'frq', 'apphy1-frq-np2-006', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-angular-momentum')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) Calculate the angular momentum of the system about the vertical axis before the student pulls her arms in.\n\n(b) Calculate the system''s angular speed after the student pulls her arms in.\n\n(c) Calculate the system''s rotational kinetic energy before and after. Account for any change in the kinetic energy.\n\n(d) Explain how the system''s angular speed can change while its angular momentum does not, referring specifically to the external torques acting on the system.',
    'A student sits on a stool that is free to rotate about a vertical axis with negligible friction. With her arms extended, the rotational inertia of the student-plus-stool system about the vertical axis is 6.00 kg*m^2, and the system is rotating at a constant angular speed of 2.00 rad/s. The student then pulls her arms in close to her body, and the rotational inertia of the system decreases to 2.40 kg*m^2.',
    '{"modules":["unit-6-energy-and-momentum-of-rotating-systems","topic-6.1","topic-6.3","topic-6.4"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-angular-momentum","difficulty":"Hard","content_key":"apphy1-frq-np2-006","total_points":9,"calculator_mode":"calculator"}'::jsonb,
    'draft', md5('apphy1-frq-np2-006-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly computes the initial angular momentum as 12.0 kg*m^2/s using L = I*omega.', 2, 'Response shows L = (6.00)(2.00) = 12.0 kg-m^2/s.', 'Multiply the rotational inertia by the angular speed.', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly applies conservation of angular momentum to obtain a final angular speed of 5.00 rad/s.', 2, 'Response sets I_i*omega_i = I_f*omega_f and solves for omega_f = 5.00 rad/s.', 'State that angular momentum is conserved and set the initial and final products I*omega equal.', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly computes rotational kinetic energies of 12.0 J and 30.0 J, identifies the 18.0 J increase, and attributes it to work done by the student''s muscles pulling her arms inward.', 3, 'Response shows 12.0 J and 30.0 J, states the increase is 18.0 J, and names the student''s muscles / internal work as the energy source.', 'Compute both kinetic energies from (1/2)I*omega^2 and then identify what does positive work on the system to supply the difference.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Correctly explains that the system is nonrigid, that the forces changing its shape are internal and exert no net external torque about the vertical axis, and that constant L = I*omega therefore forces omega to increase when I decreases.', 2, 'Response identifies the system as nonrigid, names the arm forces as internal, and states that zero net external torque keeps L constant so omega must rise as I falls.', 'Distinguish internal forces from external torques, and state why the external forces present exert no torque about the vertical axis.', '[]'::jsonb from new_version;

-- ============================================================
-- FRQ 7: apphy1-frq-np2-007 (Unit 7, spring period, half-cycle measurement error, amplitude independence)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-007', 'frq', 'apphy1-frq-np2-007', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-shm-period')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) Calculate the period and the frequency of the block''s oscillation.\n\n(b) Calculate the total mechanical energy of the block-spring system and the maximum speed of the block.\n\n(c) A student measures the time from the moment of release to the moment the block first arrives at the point 0.10 m on the opposite side of equilibrium, obtains 0.157 s, and reports this as the period. Identify the student''s error and state the correct period, explaining the relationship between the measured time and the true period.\n\n(d) The experiment is repeated with the block released from rest 0.20 m from equilibrium instead. Determine what happens to the period, the total mechanical energy, and the maximum speed. Support each answer with a calculation or an explicit statement of the relevant dependence.',
    'A block of mass 0.50 kg rests on a horizontal frictionless surface and is attached to a spring of spring constant 200 N/m whose other end is fixed to a wall. The block is pulled 0.10 m from its equilibrium position and released from rest at time t = 0.',
    '{"modules":["unit-7-oscillations","topic-7.2","topic-7.3","topic-7.4"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-shm-period","difficulty":"Hard","content_key":"apphy1-frq-np2-007","total_points":9,"calculator_mode":"no-calculator"}'::jsonb,
    'draft', md5('apphy1-frq-np2-007-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly computes the period as approximately 0.314 s and the frequency as approximately 3.18 Hz, using T = 2*pi*sqrt(m/k).', 2, 'Response shows T = 2*pi*sqrt(0.50/200) evaluated to about 0.314 s, and f as its reciprocal.', 'Substitute m and k into T = 2*pi*sqrt(m/k) and take the reciprocal for frequency.', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly computes the total mechanical energy as 1.00 J using E = (1/2)kA^2, and the maximum speed as 2.00 m/s.', 2, 'Response shows (1/2)(200)(0.10)^2 = 1.00 J and solves (1/2)(0.50)v^2 = 1.00 for v = 2.00 m/s.', 'Use the amplitude in E = (1/2)kA^2, then set that total energy equal to kinetic energy at the equilibrium position.', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly identifies that the student measured a half-cycle rather than a full cycle, states that the period is the time to return to the same position moving in the same direction, and gives the correct period of approximately 0.314 s as twice the measured value.', 3, 'Response names the measured interval as a half-cycle, defines the period as a full cycle returning to the same position moving the same direction, and reports 0.314 s = 2(0.157 s).', 'State where in the cycle the block is after 0.157 s and what still has to happen before one full cycle is complete.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Correctly states that the period is unchanged at 0.314 s because it does not depend on amplitude, that the total energy quadruples to 4.00 J because E is proportional to A^2, and that the maximum speed doubles to 4.00 m/s.', 2, 'Response gives unchanged period, 4.00 J, and 4.00 m/s, each supported by the relevant dependence.', 'Check whether the amplitude appears in each governing equation before deciding whether that quantity changes.', '[]'::jsonb from new_version;

-- ============================================================
-- FRQ 8: apphy1-frq-np2-008 (Unit 7, pendulum period, T=2pi*sqrt(m/k) misimport, precise terminology)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-008', 'frq', 'apphy1-frq-np2-008', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-pendulum-period')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) Calculate the period of the pendulum on Earth.\n\n(b) The same pendulum is taken to Planet X, where the free-fall acceleration near the surface is 4.0 m/s^2. Calculate the period of the pendulum on Planet X.\n\n(c) A student claims the period on Planet X can be found from T = 2*pi*sqrt(m/k), using the bob''s mass. Explain why this equation does not apply to this pendulum, and state what the pendulum''s period does and does not depend on.\n\n(d) A second student writes: "Gravity is smaller on Planet X, so the pendulum takes longer." Rewrite this justification so that it uses precise physical terminology, naming the specific quantity that changes and identifying the mechanism by which that change lengthens the period.',
    'A simple pendulum consists of a small bob of mass 0.80 kg hanging from a light string of length 1.60 m. On Earth, the free-fall acceleration near the surface is g = 10 m/s^2. The pendulum is set swinging with a small angular displacement.',
    '{"modules":["unit-7-oscillations","topic-7.2","topic-7.3"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-pendulum-period","difficulty":"Hard","content_key":"apphy1-frq-np2-008","total_points":9,"calculator_mode":"calculator"}'::jsonb,
    'draft', md5('apphy1-frq-np2-008-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly computes the Earth period as approximately 2.51 s using T = 2*pi*sqrt(l/g).', 2, 'Response shows 2*pi*sqrt(1.60/10) evaluated to about 2.51 s.', 'Substitute the string length and the local free-fall acceleration into T = 2*pi*sqrt(l/g).', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly computes the Planet X period as approximately 3.97 s by substituting g = 4.0 m/s^2 into the same relationship.', 2, 'Response shows 2*pi*sqrt(1.60/4.0) evaluated to about 3.97 s.', 'Change only g in the pendulum period equation; the length is unchanged.', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly explains that T = 2*pi*sqrt(m/k) applies to a spring-object oscillator and not to a pendulum, states that the pendulum''s period depends on string length and on the local free-fall acceleration, and states that it does not depend on the bob''s mass.', 2, 'Response identifies T = 2*pi*sqrt(m/k) as the spring-object result, and states the pendulum''s dependence on l and g and its independence of bob mass.', 'Name which oscillator each period equation belongs to, then list the quantities the pendulum period does and does not depend on.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Produces a rewritten justification that names the changed quantity precisely (free-fall acceleration g, distinguished from the gravitational force) and supplies a mechanism connecting the smaller g to a smaller restoring force/torque and hence a longer period, referencing T proportional to 1/sqrt(g).', 3, 'Rewritten justification names the free-fall acceleration or gravitational field magnitude explicitly and gives a restoring-force/torque mechanism plus the T proportional to 1/sqrt(g) dependence.', 'Replace the word gravity with the specific quantity that changed, then explain how that change alters the restoring force or torque on the bob.', '[]'::jsonb from new_version;

-- ============================================================
-- FRQ 9: apphy1-frq-np2-009 (Unit 8, density, absolute/gauge pressure, buoyant force)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-009', 'frq', 'apphy1-frq-np2-009', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-buoyancy')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) Calculate the density of the cube.\n\n(b) Calculate the absolute pressure and the gauge pressure of the water at the cube''s top face.\n\n(c) Calculate the magnitude of the buoyant force exerted on the cube, and the tension in the string.\n\n(d) Calculate the downward force the water exerts on the cube''s top face and the upward force the water exerts on the cube''s bottom face, and show that their difference is consistent with your answer to part (c). Then state how the buoyant force would change if the cube were lowered so that its top face is 2.00 m below the surface, and justify your answer.',
    'A solid cube of side length 0.200 m and mass 12.0 kg hangs from a light string and is held completely submerged and at rest in a tank of water, with its top face 0.500 m below the water surface and its faces horizontal and vertical. The density of water is 1000 kg/m^3, atmospheric pressure at the water surface is 1.0e5 Pa, and g = 10 m/s^2.',
    '{"modules":["unit-8-fluids","topic-8.1","topic-8.2","topic-8.3"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-buoyancy","difficulty":"Hard","content_key":"apphy1-frq-np2-009","total_points":9,"calculator_mode":"calculator"}'::jsonb,
    'draft', md5('apphy1-frq-np2-009-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly computes the cube''s volume as 8.00e-3 m^3 and its density as 1500 kg/m^3.', 2, 'Response shows V = 0.200^3 = 8.00e-3 m^3 and rho = 12.0/8.00e-3 = 1500 kg/m^3.', 'Cube the side length to get the volume before dividing the mass by it.', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly computes the absolute pressure at the top face as 1.05e5 Pa using P = P0 + rho*g*h, and correctly reports the gauge pressure as 5.00e3 Pa.', 2, 'Response shows 1.0e5 + (1000)(10)(0.500) = 1.05e5 Pa and identifies 5.00e3 Pa as the gauge value.', 'Add the atmospheric reference pressure to rho*g*h for the absolute value, and report rho*g*h alone as the gauge value.', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly computes the buoyant force as 80.0 N using the density of water and the displaced volume, and obtains a string tension of 40.0 N from force balance on the stationary cube.', 2, 'Response shows F_b = (1000)(8.00e-3)(10) = 80.0 N using the water density, and F_T = 120 - 80.0 = 40.0 N.', 'Use the density of the WATER, not of the cube, in F_b = rho*V*g, then balance tension, buoyancy, and weight on the stationary cube.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Correctly computes 4200 N down on the top face and 4280 N up on the bottom face, shows the 80.0 N difference matches part (c), and states that lowering the cube leaves the buoyant force unchanged because both face pressures rise by the same amount.', 3, 'Response shows 4200 N, 4280 N, a difference of 80.0 N matching part (c), and states the buoyant force is unchanged at greater depth with a supporting reason.', 'Compute the pressure at each face separately, multiply each by the face area, then subtract; then check whether depth appears anywhere in F_b = rho*V*g.', '[]'::jsonb from new_version;

-- ============================================================
-- FRQ 10: apphy1-frq-np2-010 (Unit 8, continuity, Bernoulli, Torricelli)
-- ============================================================
with new_item as (
  insert into app.content_items (exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
  values ('29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-frq-np2-010', 'frq', 'apphy1-frq-np2-010', 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564', 'long', 'targeted_drill', 'ap-physics-1-frq-fluid-dynamics')
  returning id
),
new_version as (
  insert into app.content_item_versions (content_item_id, version_num, stem, stimulus, prompt_json, status, content_hash)
  select id, 1,
    E'Answer all parts of the following question.\n\n(a) Calculate the volume flow rate of the water and the water''s speed in the narrow section.\n\n(b) Calculate the absolute pressure of the water in the narrow section.\n\n(c) In a separate apparatus, a large open tank is filled with the same water to a depth of 5.0 m. A small hole is opened in the side of the tank at the bottom. Calculate the speed at which water exits the hole, and state whether that speed would change if the tank were filled with a denser liquid to the same depth.\n\n(d) A student claims that in part (b) the pressure must be higher in the narrow section, "because the water is moving faster there and so pushes harder." Explain why this reasoning is incorrect, and give the correct physical account of the pressure change.',
    'Water of density 1000 kg/m^3 flows steadily through a horizontal pipe that is completely filled; the water may be treated as an ideal fluid. In the wide section of the pipe the cross-sectional area is 8.0e-3 m^2, the water''s speed is 2.0 m/s, and the absolute pressure is 1.8e5 Pa. The pipe then narrows to a cross-sectional area of 2.0e-3 m^2 at the same height. Use g = 10 m/s^2.',
    '{"modules":["unit-8-fluids","topic-8.4"],"subject":"ap_physics_1","frq_type":"long","archetype":"ap-physics-1-frq-fluid-dynamics","difficulty":"Hard","content_key":"apphy1-frq-np2-010","total_points":9,"calculator_mode":"calculator"}'::jsonb,
    'draft', md5('apphy1-frq-np2-010-v1')
  from new_item
  returning id
)
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select id, 'part-a-criterion-01', 'Correctly computes the volume flow rate as 1.6e-2 m^3/s and applies the continuity equation to obtain a narrow-section speed of 8.0 m/s.', 2, 'Response shows A1*v1 = 1.6e-2 m^3/s and v2 = 1.6e-2 / 2.0e-3 = 8.0 m/s.', 'Set the product of area and speed equal at the two sections and solve for the unknown speed.', '[]'::jsonb from new_version
union all select id, 'part-b-criterion-01', 'Correctly applies Bernoulli''s equation with the height terms cancelling, and obtains an absolute pressure of 1.5e5 Pa in the narrow section.', 3, 'Response shows P2 = 1.8e5 + 500(4.0 - 64.0) = 1.5e5 Pa, with the height terms explicitly dropped or cancelled.', 'Write the full Bernoulli equation, cancel the rho*g*y terms because the pipe is horizontal, and solve for P2.', '[]'::jsonb from new_version
union all select id, 'part-c-criterion-01', 'Correctly computes the exit speed as 10 m/s using v = sqrt(2*g*Delta-y), and correctly states that the exit speed is unchanged for a denser liquid at the same depth because density cancels from the energy-conservation derivation.', 2, 'Response shows sqrt(2*10*5.0) = 10 m/s and states the exit speed is independent of the fluid''s density.', 'Apply v = sqrt(2*g*delta-y) with the 5.0 m depth, then check whether density appears anywhere in that expression.', '[]'::jsonb from new_version
union all select id, 'part-d-criterion-01', 'Correctly refutes the student by invoking Bernoulli''s equation as conservation of energy at constant height, stating that an increase in (1/2)*rho*v^2 requires a decrease in P, and identifying the pressure difference as what does the work to accelerate the fluid into the narrow section.', 2, 'Response states that P + (1/2)*rho*v^2 is constant at fixed height, so higher speed requires lower pressure, and attributes the acceleration of the fluid to the pressure difference.', 'State what quantity Bernoulli''s equation holds constant, then reason about what must happen to pressure when the kinetic-energy term increases.', '[]'::jsonb from new_version;

commit;
