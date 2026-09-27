begin;

-- Add AP Physics C: Mechanics Unit 6 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 6 AP Physics C:Mechanics Unit 6 topics and 0
-- published point briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 6
-- (Energy and Momentum of Rotating Systems). The fact pack confirms rotational
-- kinetic energy, total kinetic energy as translational plus rotational terms,
-- torque work as an integral over angular position, full vector angular
-- momentum L = r cross p, angular impulse as integral tau dt and Delta L,
-- angular momentum conservation, rolling without slipping and slipping cases,
-- circular/elliptical satellite energy behavior, circular-orbit K=-1/2 U and
-- E_total=-GMm/2r, and escape-speed energy reasoning. Scope boundaries
-- preserved here: angular momentum/impulse vector direction is in scope for
-- Physics C: Mechanics; rolling friction is out of scope, but the Physics 1
-- qualitative-only slipping boundary does not apply here.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_c_mechanics', 6, '6.1', 'Rotational Kinetic Energy',
    'very-important', 'very-important',
    'Rotational kinetic energy is K_rot = 1/2 I omega^2. A rigid system can have translational kinetic energy, rotational kinetic energy, or both.',
    'It lets conservation of energy handle rolling, spinning, and orbiting systems. Physics C responses must keep the rotational inertia axis and angular speed tied to the same motion.',
    'You earn points by listing every kinetic-energy term, using I about the correct axis, and relating v_cm and omega only when a valid constraint such as rolling without slipping applies.',
    'Before applying energy conservation, split the kinetic energy into translational and rotational terms and check whether a constraint connects v and omega.',
    'Dropping the rotational kinetic-energy term for a rigid object that is translating and rotating.',
    '/learn/ap-physics-c-mechanics/unit-6/rotational-kinetic-energy'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.2', 'Torque and Work',
    'very-important', 'very-important',
    'Torque does work as it acts through angular displacement. In Physics C: Mechanics, rotational work is W = integral from theta1 to theta2 of tau dtheta.',
    'This is the calculus form of rotational energy transfer. A changing torque requires an integral or torque-vs-angle area, not just tau times total angle.',
    'You earn points by setting up the angular integral with correct limits, using signed torque consistently, and interpreting area under a torque-vs-angular-position graph as work.',
    'Write W = integral tau(theta) dtheta when torque varies with angle; use tau Delta theta only after confirming torque is constant.',
    'Multiplying the final torque by the full angular displacement when torque changes with angle.',
    '/learn/ap-physics-c-mechanics/unit-6/torque-and-work'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.3', 'Angular Momentum and Angular Impulse',
    'very-important', 'very-important',
    'Angular momentum can be L = I omega about an axis or the vector cross product L = r cross p about a point. Angular impulse is integral tau dt = Delta L.',
    'Physics C treats angular momentum and angular impulse as vectors. Reference point, direction, and torque-time integration are part of the assessed reasoning.',
    'You earn points by naming the axis or point, using r cross p or I omega appropriately, applying the right-hand rule when needed, and using integral tau dt for changing torque.',
    'State the reference point or axis first, then decide whether the situation calls for I omega, r cross p, or an angular-impulse integral.',
    'Using only the magnitude rmv sin(theta) and omitting the vector direction or reference point in a Physics C angular-momentum response.',
    '/learn/ap-physics-c-mechanics/unit-6/angular-momentum-and-angular-impulse'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.4', 'Conservation of Angular Momentum',
    'very-important', 'very-important',
    'Total angular momentum of a selected system is conserved when net external torque about the chosen axis is zero. Internal interactions can redistribute angular momentum among parts.',
    'This explains rotating collisions, shape-changing systems, and orbit motion. Physics C responses must justify the zero-external-torque condition before conserving L.',
    'You earn points by defining the system, choosing the axis, checking external torque, and conserving total angular momentum rather than angular speed when rotational inertia changes.',
    'Write the external-torque test before the conservation equation; if tau_ext is zero, equate total initial and final angular momentum for the system.',
    'Conserving angular speed or one object angular momentum instead of total system angular momentum.',
    '/learn/ap-physics-c-mechanics/unit-6/conservation-of-angular-momentum'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.5', 'Rolling',
    'very-important', 'very-important',
    'Rolling motion combines center-of-mass translation with rotation about the center. Without slipping, v_cm = r omega and a_cm = r alpha; slipping breaks those simple constraints.',
    'Physics C can require force, torque, energy, and constraint reasoning in one rolling problem. Unlike Physics 1, quantitative slipping analysis is not broadly excluded here.',
    'You earn points by separating translation and rotation, using rolling-without-slipping constraints only when valid, and accounting for kinetic-friction energy loss during slipping.',
    'Label the rolling condition first; then decide whether to use v_cm = r omega, write separate a_cm and alpha equations, or include kinetic-friction work.',
    'Applying no-slip constraints to a slipping object or assuming friction never dissipates energy in rolling situations.',
    '/learn/ap-physics-c-mechanics/unit-6/rolling'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.6', 'Motion of Orbiting Satellites',
    'very-important', 'very-important',
    'Satellite motion uses gravitational potential energy, kinetic energy, and angular momentum for a small satellite orbiting a much more massive central object.',
    'It ties gravitation to conservation laws. Circular orbits have constant radius and speed, while elliptical orbits conserve total energy and angular momentum as K and U change.',
    'You earn points by choosing the satellite-central-object system, using U = -GMm/r with zero at infinity, and applying circular-orbit or energy-conservation relationships only when justified.',
    'Identify circular versus elliptical orbit first; then choose constants, energy equations, and angular-momentum reasoning that match that orbit type.',
    'Using surface-level gravitational potential energy or assuming kinetic energy is constant for every bound orbit.',
    '/learn/ap-physics-c-mechanics/unit-6/motion-of-orbiting-satellites'
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
    'ap_physics_c_mechanics', 6, '6.1', 'Rotational Kinetic Energy',
    'Rotational kinetic energy is the energy of motion about an axis: K_rot = 1/2 I omega^2. For a rigid system whose center of mass moves, total kinetic energy can include both 1/2 mv_cm^2 and 1/2 I_cm omega^2.',
    'Students need to identify the axis for I and the motion represented by omega. A rigid body rolling down a ramp is not just a point mass; its center of mass translates while its material points also rotate about the center of mass.',
    'Points come from including every required kinetic-energy term and using constraints such as v_cm = r omega only when the object rolls without slipping. Missing K_rot makes energy conservation predict the wrong speed or height.',
    'Before applying energy conservation, split the kinetic energy into translational and rotational terms and check whether a constraint connects v and omega.',
    'A disk rolls without slipping across a table. What kinetic-energy terms should be included in the total kinetic energy?',
    'Use only 1/2 mv^2 because the disk center is moving across the table.',
    'Use both 1/2 mv_cm^2 and 1/2 I_cm omega^2. The first term describes translation of the center of mass; the second describes rotation about the center. Rolling without slipping can relate v_cm and omega, but it does not remove the rotational energy.',
    'Dropping the rotational kinetic-energy term for a rigid object that is translating and rotating.',
    'Back in practice, write K_trans and K_rot as separate placeholders before substituting numbers or constraints.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.2', 'Torque and Work',
    'Rotational work is the accumulated energy transfer by torque over angular displacement. In Physics C, W = integral from theta1 to theta2 of tau(theta) dtheta, so a variable torque requires calculus or graph area.',
    'Students need to distinguish torque-angle area from torque-time area. Torque integrated over angle gives work and changes rotational energy; torque integrated over time gives angular impulse and changes angular momentum.',
    'Points come from writing the correct integral with angular limits, evaluating signed area under a torque-vs-theta graph, and using constant-torque shortcuts only when the prompt supports them.',
    'Write W = integral tau(theta) dtheta when torque varies with angle; use tau Delta theta only after confirming torque is constant.',
    'A torque on a wheel varies with angle as tau(theta) = C theta from theta = 0 to theta = Theta. What expression gives the work done?',
    'The work is CTheta times Theta because the final torque acts through the whole angle.',
    'The work is W = integral_0^Theta C theta dtheta = (1/2)CTheta^2. The torque grows with angle, so final torque times total angle treats the triangular torque-angle area as a rectangle.',
    'Multiplying the final torque by the full angular displacement when torque changes with angle.',
    'In practice, check whether the horizontal axis is angle or time. Torque-angle area is work; torque-time area is angular impulse.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.3', 'Angular Momentum and Angular Impulse',
    'Angular momentum is a vector measured about a selected point or axis. For a rigid rotating object L can be I omega about the axis; for a particle about a point, L vector = r vector cross p vector. Angular impulse is integral tau dt = Delta L.',
    'Students need to track the reference point and vector direction. Physics C does not use the Physics 1 magnitude-only boundary here: right-hand-rule direction and torque/angular-momentum vector relationships are in scope.',
    'Points come from choosing the point or axis, using the correct angular-momentum expression, applying cross-product direction when needed, and integrating torque over time if torque changes.',
    'State the reference point or axis first, then decide whether the situation calls for I omega, r cross p, or an angular-impulse integral.',
    'A particle has position vector in the +x direction from point O and momentum in the +y direction. What is the direction of its angular momentum about O?',
    'Angular momentum is just positive because the particle is moving counterclockwise about O.',
    'Use L vector = r vector cross p vector. With r in +x and p in +y, the right-hand rule gives L in the +z direction about point O. The reference point and vector direction are part of the Physics C answer.',
    'Using only the magnitude rmv sin(theta) and omitting the vector direction or reference point in a Physics C angular-momentum response.',
    'Back in practice, write "about ___" and then draw r and p before deciding on the sign or vector direction.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.4', 'Conservation of Angular Momentum',
    'Angular momentum conservation is a system statement: total L about a chosen axis stays constant when the net external torque about that axis is zero. Internal torques can exchange angular momentum among parts but cannot change the system total.',
    'Students need to avoid conserving the wrong quantity. If rotational inertia changes, angular speed may change even though total angular momentum remains constant. In collisions or shape changes, the system boundary and external-torque check decide whether conservation applies.',
    'Points come from defining the system, choosing the axis, stating why external torque is zero or negligible, and writing total initial angular momentum equal to total final angular momentum. The equation should include all rotating or orbiting parts that carry L.',
    'Write the external-torque test before the conservation equation; if tau_ext is zero, equate total initial and final angular momentum for the system.',
    'A rotating platform-student system has negligible external torque. The student pulls a mass inward toward the axis. What is conserved, and what can change?',
    'Angular speed is conserved because no external torque acts.',
    'Total angular momentum of the selected system is conserved. The angular speed can change because the rotational inertia changes when the mass moves inward. If I decreases, omega increases so total L remains constant.',
    'Conserving angular speed or one object angular momentum instead of total system angular momentum.',
    'In practice, underline "system" in the prompt or define one yourself. Conservation applies to the system total, not automatically to each part.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.5', 'Rolling',
    'Rolling combines translation of the center of mass and rotation about the center. Rolling without slipping gives v_cm = r omega and a_cm = r alpha; slipping requires separate translational and rotational analysis and can dissipate energy through kinetic friction.',
    'Students need to decide whether the no-slip constraint is physically valid. In ideal rolling without slipping, friction need not dissipate energy. During slipping, kinetic friction acts at a contact point that moves relative to the surface, so mechanical energy can decrease. Physics C can still ask for quantitative force/torque relationships during slipping.',
    'Points come from separating force and torque equations, adding the no-slip constraint only when valid, and including friction work or energy loss when kinetic friction acts through slipping motion.',
    'Label the rolling condition first; then decide whether to use v_cm = r omega, write separate a_cm and alpha equations, or include kinetic-friction work.',
    'A sphere is sliding and rotating on a rough surface but is not yet rolling without slipping. Should v_cm = R omega be used immediately?',
    'Yes. Any object that is rolling or rotating on a surface must satisfy v = R omega.',
    'No. While the sphere is slipping, center-of-mass motion and rotation are not tied by v_cm = R omega. Write separate translational and rotational equations using kinetic friction, and use the no-slip relation only after the slipping condition ends or is explicitly stated.',
    'Applying no-slip constraints to a slipping object or assuming friction never dissipates energy in rolling situations.',
    'Back in practice, write one line for translation and one for rotation before adding constraints. Constraints come from contact conditions, not from the word "rolling" alone.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.6', 'Motion of Orbiting Satellites',
    'Orbiting satellites are analyzed with gravitational potential energy, kinetic energy, total mechanical energy, and angular momentum for the satellite-central-object system. The zero of gravitational potential energy is at infinite separation.',
    'Students need to distinguish circular from elliptical orbits. In circular orbit, K, U, total energy, and angular momentum are constant, with K = -1/2 U and E_total = -GMm/2r. In elliptical orbit, total energy and angular momentum stay constant while K and U vary with position.',
    'Points come from choosing the right system, using U = -GMm/r, applying circular-orbit relationships only for circular motion, and using total energy equal to zero for escape-speed reasoning.',
    'Identify circular versus elliptical orbit first; then choose constants, energy equations, and angular-momentum reasoning that match that orbit type.',
    'A satellite in an elliptical orbit moves closer to the planet. What happens to kinetic energy if total mechanical energy is conserved?',
    'Kinetic energy stays constant because total mechanical energy is conserved.',
    'Kinetic energy increases. As r decreases, U = -GMm/r becomes more negative. Total mechanical energy remains constant, so K must increase to compensate. Angular momentum is also conserved for the orbiting system in the absence of external torque.',
    'Using surface-level gravitational potential energy or assuming kinetic energy is constant for every bound orbit.',
    'In practice, write the orbit type beside the energy equation. Circular-orbit shortcuts should not silently migrate into elliptical-orbit reasoning.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 6 Energy and Momentum of Rotating Systems; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 6: rotational kinetic energy K_rot=1/2 I omega^2, total KE as translational plus rotational terms, torque work W=integral tau dtheta, torque-vs-angle area, angular momentum L=I omega and vector L=r cross p, angular impulse as integral tau dt and Delta L, angular momentum conservation, rolling without slipping constraints, slipping analysis with kinetic friction energy loss, circular and elliptical satellite energy/angular momentum behavior, U=-GMm/r, circular-orbit K=-1/2 U and E_total=-GMm/2r, and escape-speed energy condition; batch 2026-08-25-ap-physics-c-mechanics-unit6-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_c_mechanics', 6, '6.1', 'Rotational Kinetic Energy',
    'Rotational kinetic energy is the energy of motion about an axis: K_rot = 1/2 I omega^2. For a rigid system whose center of mass moves, total kinetic energy can include both 1/2 mv_cm^2 and 1/2 I_cm omega^2.',
    'Students need to identify the axis for I and the motion represented by omega. A rigid body rolling down a ramp is not just a point mass; its center of mass translates while its material points also rotate about the center of mass.',
    'Points come from including every required kinetic-energy term and using constraints such as v_cm = r omega only when the object rolls without slipping. Missing K_rot makes energy conservation predict the wrong speed or height.',
    'Before applying energy conservation, split the kinetic energy into translational and rotational terms and check whether a constraint connects v and omega.',
    'A disk rolls without slipping across a table. What kinetic-energy terms should be included in the total kinetic energy?',
    'Use only 1/2 mv^2 because the disk center is moving across the table.',
    'Use both 1/2 mv_cm^2 and 1/2 I_cm omega^2. The first term describes translation of the center of mass; the second describes rotation about the center. Rolling without slipping can relate v_cm and omega, but it does not remove the rotational energy.',
    'Dropping the rotational kinetic-energy term for a rigid object that is translating and rotating.',
    'Back in practice, write K_trans and K_rot as separate placeholders before substituting numbers or constraints.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.2', 'Torque and Work',
    'Rotational work is the accumulated energy transfer by torque over angular displacement. In Physics C, W = integral from theta1 to theta2 of tau(theta) dtheta, so a variable torque requires calculus or graph area.',
    'Students need to distinguish torque-angle area from torque-time area. Torque integrated over angle gives work and changes rotational energy; torque integrated over time gives angular impulse and changes angular momentum.',
    'Points come from writing the correct integral with angular limits, evaluating signed area under a torque-vs-theta graph, and using constant-torque shortcuts only when the prompt supports them.',
    'Write W = integral tau(theta) dtheta when torque varies with angle; use tau Delta theta only after confirming torque is constant.',
    'A torque on a wheel varies with angle as tau(theta) = C theta from theta = 0 to theta = Theta. What expression gives the work done?',
    'The work is CTheta times Theta because the final torque acts through the whole angle.',
    'The work is W = integral_0^Theta C theta dtheta = (1/2)CTheta^2. The torque grows with angle, so final torque times total angle treats the triangular torque-angle area as a rectangle.',
    'Multiplying the final torque by the full angular displacement when torque changes with angle.',
    'In practice, check whether the horizontal axis is angle or time. Torque-angle area is work; torque-time area is angular impulse.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.3', 'Angular Momentum and Angular Impulse',
    'Angular momentum is a vector measured about a selected point or axis. For a rigid rotating object L can be I omega about the axis; for a particle about a point, L vector = r vector cross p vector. Angular impulse is integral tau dt = Delta L.',
    'Students need to track the reference point and vector direction. Physics C does not use the Physics 1 magnitude-only boundary here: right-hand-rule direction and torque/angular-momentum vector relationships are in scope.',
    'Points come from choosing the point or axis, using the correct angular-momentum expression, applying cross-product direction when needed, and integrating torque over time if torque changes.',
    'State the reference point or axis first, then decide whether the situation calls for I omega, r cross p, or an angular-impulse integral.',
    'A particle has position vector in the +x direction from point O and momentum in the +y direction. What is the direction of its angular momentum about O?',
    'Angular momentum is just positive because the particle is moving counterclockwise about O.',
    'Use L vector = r vector cross p vector. With r in +x and p in +y, the right-hand rule gives L in the +z direction about point O. The reference point and vector direction are part of the Physics C answer.',
    'Using only the magnitude rmv sin(theta) and omitting the vector direction or reference point in a Physics C angular-momentum response.',
    'Back in practice, write "about ___" and then draw r and p before deciding on the sign or vector direction.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.4', 'Conservation of Angular Momentum',
    'Angular momentum conservation is a system statement: total L about a chosen axis stays constant when the net external torque about that axis is zero. Internal torques can exchange angular momentum among parts but cannot change the system total.',
    'Students need to avoid conserving the wrong quantity. If rotational inertia changes, angular speed may change even though total angular momentum remains constant. In collisions or shape changes, the system boundary and external-torque check decide whether conservation applies.',
    'Points come from defining the system, choosing the axis, stating why external torque is zero or negligible, and writing total initial angular momentum equal to total final angular momentum. The equation should include all rotating or orbiting parts that carry L.',
    'Write the external-torque test before the conservation equation; if tau_ext is zero, equate total initial and final angular momentum for the system.',
    'A rotating platform-student system has negligible external torque. The student pulls a mass inward toward the axis. What is conserved, and what can change?',
    'Angular speed is conserved because no external torque acts.',
    'Total angular momentum of the selected system is conserved. The angular speed can change because the rotational inertia changes when the mass moves inward. If I decreases, omega increases so total L remains constant.',
    'Conserving angular speed or one object angular momentum instead of total system angular momentum.',
    'In practice, underline "system" in the prompt or define one yourself. Conservation applies to the system total, not automatically to each part.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.5', 'Rolling',
    'Rolling combines translation of the center of mass and rotation about the center. Rolling without slipping gives v_cm = r omega and a_cm = r alpha; slipping requires separate translational and rotational analysis and can dissipate energy through kinetic friction.',
    'Students need to decide whether the no-slip constraint is physically valid. In ideal rolling without slipping, friction need not dissipate energy. During slipping, kinetic friction acts at a contact point that moves relative to the surface, so mechanical energy can decrease. Physics C can still ask for quantitative force/torque relationships during slipping.',
    'Points come from separating force and torque equations, adding the no-slip constraint only when valid, and including friction work or energy loss when kinetic friction acts through slipping motion.',
    'Label the rolling condition first; then decide whether to use v_cm = r omega, write separate a_cm and alpha equations, or include kinetic-friction work.',
    'A sphere is sliding and rotating on a rough surface but is not yet rolling without slipping. Should v_cm = R omega be used immediately?',
    'Yes. Any object that is rolling or rotating on a surface must satisfy v = R omega.',
    'No. While the sphere is slipping, center-of-mass motion and rotation are not tied by v_cm = R omega. Write separate translational and rotational equations using kinetic friction, and use the no-slip relation only after the slipping condition ends or is explicitly stated.',
    'Applying no-slip constraints to a slipping object or assuming friction never dissipates energy in rolling situations.',
    'Back in practice, write one line for translation and one for rotation before adding constraints. Constraints come from contact conditions, not from the word "rolling" alone.'
  ),
  (
    'ap_physics_c_mechanics', 6, '6.6', 'Motion of Orbiting Satellites',
    'Orbiting satellites are analyzed with gravitational potential energy, kinetic energy, total mechanical energy, and angular momentum for the satellite-central-object system. The zero of gravitational potential energy is at infinite separation.',
    'Students need to distinguish circular from elliptical orbits. In circular orbit, K, U, total energy, and angular momentum are constant, with K = -1/2 U and E_total = -GMm/2r. In elliptical orbit, total energy and angular momentum stay constant while K and U vary with position.',
    'Points come from choosing the right system, using U = -GMm/r, applying circular-orbit relationships only for circular motion, and using total energy equal to zero for escape-speed reasoning.',
    'Identify circular versus elliptical orbit first; then choose constants, energy equations, and angular-momentum reasoning that match that orbit type.',
    'A satellite in an elliptical orbit moves closer to the planet. What happens to kinetic energy if total mechanical energy is conserved?',
    'Kinetic energy stays constant because total mechanical energy is conserved.',
    'Kinetic energy increases. As r decreases, U = -GMm/r becomes more negative. Total mechanical energy remains constant, so K must increase to compensate. Angular momentum is also conserved for the orbiting system in the absence of external torque.',
    'Using surface-level gravitational potential energy or assuming kinetic energy is constant for every bound orbit.',
    'In practice, write the orbit type beside the energy equation. Circular-orbit shortcuts should not silently migrate into elliptical-orbit reasoning.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 6 Energy and Momentum of Rotating Systems; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 6: rotational kinetic energy K_rot=1/2 I omega^2, total KE as translational plus rotational terms, torque work W=integral tau dtheta, torque-vs-angle area, angular momentum L=I omega and vector L=r cross p, angular impulse as integral tau dt and Delta L, angular momentum conservation, rolling without slipping constraints, slipping analysis with kinetic friction energy loss, circular and elliptical satellite energy/angular momentum behavior, U=-GMm/r, circular-orbit K=-1/2 U and E_total=-GMm/2r, and escape-speed energy condition; batch 2026-08-25-ap-physics-c-mechanics-unit6-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 6
    and topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and status = 'published';

  if v_briefs <> 6 then
    raise exception 'expected 6 published AP Physics C:Mechanics Unit 6 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_c_mechanics'
    and unit_number = 6
    and topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and status = 'published';

  if v_explainers <> 6 then
    raise exception 'expected 6 published AP Physics C:Mechanics Unit 6 explainers, got %', v_explainers;
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
      and b.unit_number = 6
      and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
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
      and e.unit_number = 6
      and e.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 6 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 6 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.unit_number = 6
    and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-c-mechanics/unit-6/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 6 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 6 core_idea/what_it_is matches, got %', v_core_matches;
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
      and unit_number = 6
      and topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
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
      and e.unit_number = 6
      and e.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 6 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
