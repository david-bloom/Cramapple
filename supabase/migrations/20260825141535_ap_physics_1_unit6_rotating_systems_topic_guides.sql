begin;

-- Add AP Physics 1 Unit 6 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 6 AP Physics 1 Unit 6 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_1_CED_FACT_PACK.md Unit 6 (Energy and
-- Momentum of Rotating Systems). The fact pack confirms rotational kinetic
-- energy K = 1/2 I omega^2, torque work W = tau Delta theta and torque-vs-angle
-- area, angular momentum magnitudes L = I omega and L = rmv sin(theta), angular
-- impulse as torque-vs-time area and Delta L, conservation of angular momentum,
-- rolling kinetic energy and rolling-without-slipping constraints, and circular
-- and elliptical satellite energy/angular-momentum behavior. AP Physics 1 scope
-- boundaries preserved here: angular momentum and angular impulse direction are
-- beyond scope; rolling friction is beyond scope; slipping rolling is qualitative
-- rather than quantitatively modeled.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_1', 6, '6.1', 'Rotational Kinetic Energy',
    'very-important', 'very-important',
    'Rotational kinetic energy is the energy a system has because it rotates: K = 1/2 I omega^2. Total kinetic energy can include both translational and rotational parts.',
    'It connects energy conservation to rotation. A rolling or spinning object may have energy in center-of-mass motion and in motion of its parts about the center.',
    'You earn points by identifying every kinetic-energy term, using I about the correct axis, and adding 1/2 mv^2 and 1/2 I omega^2 only when both motions occur.',
    'Before writing energy conservation, list translational KE and rotational KE separately, then decide which terms belong before and after.',
    'Counting only 1/2 mv^2 for a rolling or spinning rigid object that also has rotational kinetic energy.',
    '/learn/ap-physics-1/unit-6/rotational-kinetic-energy'
  ),
  (
    'ap_physics_1', 6, '6.2', 'Torque and Work',
    'very-important', 'somewhat-important',
    'A torque does work when it acts through an angular displacement. For constant torque, W = tau Delta theta; for changing torque, work is area under a torque-vs-angle graph.',
    'This is the energy version of rotational dynamics. It explains how a force applied off-axis can transfer energy into rotation rather than only changing linear motion.',
    'You earn points by using angular displacement in radians, matching torque sign to the rotation, or finding signed area under a torque-position graph.',
    'Translate the situation into rotational work: identify tau, Delta theta, and whether graph area or tau Delta theta gives the energy transfer.',
    'Multiplying torque by linear distance instead of angular displacement, or treating graph height alone as work.',
    '/learn/ap-physics-1/unit-6/torque-and-work'
  ),
  (
    'ap_physics_1', 6, '6.3', 'Angular Momentum and Angular Impulse',
    'very-important', 'very-important',
    'Angular momentum measures rotational motion about a chosen axis or point. In AP Physics 1, use magnitudes such as L = I omega or L = rmv sin(theta).',
    'It is the rotational partner of momentum. The value depends on the reference axis or point, so choosing that reference is part of the physics.',
    'You earn points by naming the axis or point, using the correct magnitude expression, and connecting angular impulse to Delta L or area under a torque-vs-time graph.',
    'State the reference axis or point first; then use L = I omega for rotating rigid systems or L = rmv sin(theta) for a moving object about a point.',
    'Writing angular momentum without specifying the reference axis or point, then treating it as a universal object property.',
    '/learn/ap-physics-1/unit-6/angular-momentum-and-angular-impulse'
  ),
  (
    'ap_physics_1', 6, '6.4', 'Conservation of Angular Momentum',
    'very-important', 'very-important',
    'Angular momentum is conserved for a chosen system when the net external torque about the chosen axis is zero. Internal changes can redistribute angular momentum.',
    'This explains collisions, rotating platforms, and shape-changing systems. A system can spin faster or slower without external torque if its rotational inertia changes.',
    'You earn points by defining the system, checking external torque about the axis, and setting initial total angular momentum equal to final total angular momentum only when justified.',
    'Ask whether the external torque about the chosen axis is zero; if it is, conserve total angular momentum for the system, not necessarily angular speed.',
    'Conserving angular speed instead of angular momentum when rotational inertia changes.',
    '/learn/ap-physics-1/unit-6/conservation-of-angular-momentum'
  ),
  (
    'ap_physics_1', 6, '6.5', 'Rolling',
    'very-important', 'very-important',
    'Rolling motion combines translation of the center of mass with rotation about the center. Without slipping, v_cm = r omega and K_total = K_trans + K_rot.',
    'It joins force, rotation, and energy ideas in one model. Rolling without slipping gives useful constraints, while slipping breaks those direct mathematical links.',
    'You earn points by separating translational and rotational motion, applying v_cm = r omega only for rolling without slipping, and including both kinetic-energy terms when needed.',
    'Label whether the object rolls without slipping; then use v_cm = r omega and K = 1/2 mv_cm^2 + 1/2 I omega^2 only when that condition applies.',
    'Using v_cm = r omega for a slipping object, where center-of-mass motion and rotation are not directly linked.',
    '/learn/ap-physics-1/unit-6/rolling'
  ),
  (
    'ap_physics_1', 6, '6.6', 'Motion of Orbiting Satellites',
    'very-important', 'somewhat-important',
    'Orbiting-satellite motion uses gravitational potential energy, kinetic energy, and angular momentum for a satellite around a much more massive central object.',
    'It connects gravitation to conservation laws. Circular orbits keep energy terms constant, while elliptical orbits keep total energy and angular momentum constant as speed changes.',
    'You earn points by choosing the satellite-central-object system, using U_g = -Gm1m2/r with zero at infinity, and applying energy or angular-momentum conservation to the orbit type.',
    'Identify circular versus elliptical motion first, then decide which quantities are constant and which energy terms can change with orbital radius.',
    'Treating gravitational potential energy as zero at the planet surface or assuming speed is constant in every orbit.',
    '/learn/ap-physics-1/unit-6/motion-of-orbiting-satellites'
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
    'ap_physics_1', 6, '6.1', 'Rotational Kinetic Energy',
    'Rotational kinetic energy is energy stored in motion about an axis. For a rigid system, K_rot = 1/2 I omega^2, and a system can also have translational kinetic energy of its center of mass.',
    'Students need to decide whether the object is translating, rotating, or both. A wheel rolling across a surface has center-of-mass kinetic energy and rotational kinetic energy. A disk spinning in place can have rotational kinetic energy even while its center of mass is at rest.',
    'Points come from including all relevant energy terms, using rotational inertia about the correct axis, and not replacing a rotational term with a translational one. In energy conservation, missing K_rot usually changes the final speed or height result.',
    'Before writing energy conservation, list translational KE and rotational KE separately, then decide which terms belong before and after.',
    'A solid object rolls without slipping down a ramp. At the bottom, what kinetic-energy terms should appear in the energy equation?',
    'Only 1/2 mv^2 appears because the whole object is moving down the ramp.',
    'Both terms appear: 1/2 mv_cm^2 for motion of the center of mass and 1/2 I omega^2 for rotation about the center. Rolling without slipping lets v_cm and omega be related, but it does not erase the rotational energy term.',
    'Counting only 1/2 mv^2 for a rolling or spinning rigid object that also has rotational kinetic energy.',
    'Back in practice, mark each object as translating, rotating, or both before writing the conservation-of-energy equation.'
  ),
  (
    'ap_physics_1', 6, '6.2', 'Torque and Work',
    'A torque transfers energy when it acts through angular displacement. Constant torque gives W = tau Delta theta, while a varying torque requires the signed area under a torque-vs-angular-position graph.',
    'Students need to keep the rotational variables paired: torque with angular displacement, not force with angular displacement or torque with linear distance. The angular displacement must be in radians when used in W = tau Delta theta.',
    'Points come from identifying the torque that acts through the stated angle, using signs consistently for work that adds or removes rotational energy, and interpreting graph area as work when torque changes with angle.',
    'Translate the situation into rotational work: identify tau, Delta theta, and whether graph area or tau Delta theta gives the energy transfer.',
    'A constant counterclockwise torque tau acts through an angle Delta theta while the object rotates counterclockwise. What work does the torque do?',
    'The work is tau divided by Delta theta because torque is spread over the angle.',
    'The work is W = tau Delta theta and is positive if counterclockwise is the positive rotational direction. The torque acts in the same sense as the angular displacement, so it transfers energy into the rotating system.',
    'Multiplying torque by linear distance instead of angular displacement, or treating graph height alone as work.',
    'In practice, check the graph axes or the given displacement: torque-angle area gives work, while torque-time area gives angular impulse.'
  ),
  (
    'ap_physics_1', 6, '6.3', 'Angular Momentum and Angular Impulse',
    'Angular momentum is measured about a selected axis or point. For a rigid rotating system, its magnitude can be L = I omega; for a moving object about a point, its magnitude can be L = rmv sin(theta).',
    'Students need to separate reference choice from object identity. The same moving object can have different angular momentum values about different points. Angular impulse is the change in angular momentum caused by torque over time, equal to area under a torque-vs-time graph.',
    'Points come from naming the reference axis or point, choosing L = I omega or L = rmv sin(theta) appropriately, and using angular impulse = Delta L. AP Physics 1 uses one-dimensional sign conventions here; vector direction of angular momentum is beyond scope.',
    'State the reference axis or point first; then use L = I omega for rotating rigid systems or L = rmv sin(theta) for a moving object about a point.',
    'A puck of mass m moves past point P at speed v. At closest approach it is distance d from P. What determines the puck''s angular momentum magnitude about P?',
    'It is just mv because angular momentum is the same as linear momentum for a moving object.',
    'The angular momentum magnitude about P is L = rmv sin(theta). At closest approach the radius from P to the puck is perpendicular to velocity, so L = dmv. The reference point matters because d is measured from P.',
    'Writing angular momentum without specifying the reference axis or point, then treating it as a universal object property.',
    'Back in practice, write "about ___" next to every angular momentum statement before choosing an equation.'
  ),
  (
    'ap_physics_1', 6, '6.4', 'Conservation of Angular Momentum',
    'A system conserves total angular momentum about an axis when the net external torque about that axis is zero. Angular speed may still change if the system rotational inertia changes.',
    'Students need to define the system and distinguish internal interactions from external torques. Internal torques can change how angular momentum is shared among parts, but they cannot change the system total angular momentum. A nonrigid system can spin faster as mass moves closer to the axis because I decreases while L remains constant.',
    'Points come from justifying why external torque is zero or negligible, writing L_initial = L_final for the chosen system, and solving for a changed angular speed or rotation state without assuming I is constant.',
    'Ask whether the external torque about the chosen axis is zero; if it is, conserve total angular momentum for the system, not necessarily angular speed.',
    'A student on a low-friction rotating platform pulls two held masses closer to the rotation axis. With negligible external torque, what happens to angular momentum and angular speed?',
    'Both angular momentum and angular speed stay the same because no external torque acts.',
    'The system angular momentum stays constant, but angular speed increases. Pulling the masses inward reduces rotational inertia, so omega must increase to keep total L = I omega constant for the chosen system.',
    'Conserving angular speed instead of angular momentum when rotational inertia changes.',
    'In practice, write the system and external-torque check before using conservation. Then allow I and omega to change as long as total L is constant.'
  ),
  (
    'ap_physics_1', 6, '6.5', 'Rolling',
    'Rolling motion combines center-of-mass translation with rotation about the center. Rolling without slipping creates constraints such as v_cm = r omega, while slipping means those direct quantitative relationships no longer hold.',
    'Students need to identify the rolling condition before applying formulas. For ideal rolling without slipping, static friction can enforce the motion without dissipating energy. During slipping, kinetic friction dissipates energy and AP Physics 1 expects qualitative explanation rather than precise slipping kinematics.',
    'Points come from including translational and rotational energy, applying v_cm = r omega only when rolling without slipping is stated or justified, and explaining qualitatively how slipping changes linear and angular motion.',
    'Label whether the object rolls without slipping; then use v_cm = r omega and K = 1/2 mv_cm^2 + 1/2 I omega^2 only when that condition applies.',
    'A cylinder is rolling without slipping. If its center-of-mass speed is v_cm and radius is R, what angular speed should be used in rotational kinetic energy?',
    'Use any angular speed, because the translational kinetic energy already accounts for the rolling motion.',
    'Use omega = v_cm/R because rolling without slipping links center-of-mass speed and angular speed. The total kinetic energy still includes both 1/2 mv_cm^2 and 1/2 I omega^2.',
    'Using v_cm = r omega for a slipping object, where center-of-mass motion and rotation are not directly linked.',
    'Back in practice, circle the phrase "without slipping" when it appears. If it does not, justify the rolling constraint before using it.'
  ),
  (
    'ap_physics_1', 6, '6.6', 'Motion of Orbiting Satellites',
    'Satellite motion is analyzed as a gravitational system with energy and angular momentum. For a negligible-mass satellite around a massive central object, the central object can be treated as essentially fixed in AP Physics 1 models.',
    'Students need to distinguish circular and elliptical orbits. In circular orbits, gravitational potential energy, kinetic energy, total mechanical energy, and angular momentum are constant. In elliptical orbits, total mechanical energy and angular momentum are constant, but speed, kinetic energy, and gravitational potential energy change with position.',
    'Points come from choosing the satellite-central-object system, using U_g = -Gm1m2/r with zero at infinite separation, and applying conservation to the quantity that is actually constant. Escape speed follows from setting total mechanical energy equal to zero.',
    'Identify circular versus elliptical motion first, then decide which quantities are constant and which energy terms can change with orbital radius.',
    'A satellite moves in an elliptical orbit. As it gets closer to the central object, can its kinetic energy change if total mechanical energy is conserved?',
    'No. If total mechanical energy is conserved, kinetic energy must be constant too.',
    'Yes. In an elliptical orbit the total mechanical energy stays constant, but gravitational potential energy becomes more negative at smaller r. The kinetic energy increases so the sum K + U_g remains constant.',
    'Treating gravitational potential energy as zero at the planet surface or assuming speed is constant in every orbit.',
    'In practice, write which orbit type is given before choosing constants: circular keeps more quantities constant; elliptical keeps total energy and angular momentum constant while K and U_g can vary.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 6 Energy and Momentum of Rotating Systems; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 6: rotational kinetic energy K=1/2 I omega^2, total KE as translational plus rotational terms, torque work W=tau Delta theta and torque-vs-angle area, angular momentum magnitudes L=I omega and L=rmv sin(theta), angular impulse as Delta L and torque-vs-time area, angular momentum conservation, rolling without slipping constraints, qualitative slipping boundary, satellite orbital energy/angular momentum behavior, U_g=-Gm1m2/r, and escape-speed energy condition; batch 2026-08-25-ap-physics-1-unit6-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_1', 6, '6.1', 'Rotational Kinetic Energy',
    'Rotational kinetic energy is energy stored in motion about an axis. For a rigid system, K_rot = 1/2 I omega^2, and a system can also have translational kinetic energy of its center of mass.',
    'Students need to decide whether the object is translating, rotating, or both. A wheel rolling across a surface has center-of-mass kinetic energy and rotational kinetic energy. A disk spinning in place can have rotational kinetic energy even while its center of mass is at rest.',
    'Points come from including all relevant energy terms, using rotational inertia about the correct axis, and not replacing a rotational term with a translational one. In energy conservation, missing K_rot usually changes the final speed or height result.',
    'Before writing energy conservation, list translational KE and rotational KE separately, then decide which terms belong before and after.',
    'A solid object rolls without slipping down a ramp. At the bottom, what kinetic-energy terms should appear in the energy equation?',
    'Only 1/2 mv^2 appears because the whole object is moving down the ramp.',
    'Both terms appear: 1/2 mv_cm^2 for motion of the center of mass and 1/2 I omega^2 for rotation about the center. Rolling without slipping lets v_cm and omega be related, but it does not erase the rotational energy term.',
    'Counting only 1/2 mv^2 for a rolling or spinning rigid object that also has rotational kinetic energy.',
    'Back in practice, mark each object as translating, rotating, or both before writing the conservation-of-energy equation.'
  ),
  (
    'ap_physics_1', 6, '6.2', 'Torque and Work',
    'A torque transfers energy when it acts through angular displacement. Constant torque gives W = tau Delta theta, while a varying torque requires the signed area under a torque-vs-angular-position graph.',
    'Students need to keep the rotational variables paired: torque with angular displacement, not force with angular displacement or torque with linear distance. The angular displacement must be in radians when used in W = tau Delta theta.',
    'Points come from identifying the torque that acts through the stated angle, using signs consistently for work that adds or removes rotational energy, and interpreting graph area as work when torque changes with angle.',
    'Translate the situation into rotational work: identify tau, Delta theta, and whether graph area or tau Delta theta gives the energy transfer.',
    'A constant counterclockwise torque tau acts through an angle Delta theta while the object rotates counterclockwise. What work does the torque do?',
    'The work is tau divided by Delta theta because torque is spread over the angle.',
    'The work is W = tau Delta theta and is positive if counterclockwise is the positive rotational direction. The torque acts in the same sense as the angular displacement, so it transfers energy into the rotating system.',
    'Multiplying torque by linear distance instead of angular displacement, or treating graph height alone as work.',
    'In practice, check the graph axes or the given displacement: torque-angle area gives work, while torque-time area gives angular impulse.'
  ),
  (
    'ap_physics_1', 6, '6.3', 'Angular Momentum and Angular Impulse',
    'Angular momentum is measured about a selected axis or point. For a rigid rotating system, its magnitude can be L = I omega; for a moving object about a point, its magnitude can be L = rmv sin(theta).',
    'Students need to separate reference choice from object identity. The same moving object can have different angular momentum values about different points. Angular impulse is the change in angular momentum caused by torque over time, equal to area under a torque-vs-time graph.',
    'Points come from naming the reference axis or point, choosing L = I omega or L = rmv sin(theta) appropriately, and using angular impulse = Delta L. AP Physics 1 uses one-dimensional sign conventions here; vector direction of angular momentum is beyond scope.',
    'State the reference axis or point first; then use L = I omega for rotating rigid systems or L = rmv sin(theta) for a moving object about a point.',
    'A puck of mass m moves past point P at speed v. At closest approach it is distance d from P. What determines the puck''s angular momentum magnitude about P?',
    'It is just mv because angular momentum is the same as linear momentum for a moving object.',
    'The angular momentum magnitude about P is L = rmv sin(theta). At closest approach the radius from P to the puck is perpendicular to velocity, so L = dmv. The reference point matters because d is measured from P.',
    'Writing angular momentum without specifying the reference axis or point, then treating it as a universal object property.',
    'Back in practice, write "about ___" next to every angular momentum statement before choosing an equation.'
  ),
  (
    'ap_physics_1', 6, '6.4', 'Conservation of Angular Momentum',
    'A system conserves total angular momentum about an axis when the net external torque about that axis is zero. Angular speed may still change if the system rotational inertia changes.',
    'Students need to define the system and distinguish internal interactions from external torques. Internal torques can change how angular momentum is shared among parts, but they cannot change the system total angular momentum. A nonrigid system can spin faster as mass moves closer to the axis because I decreases while L remains constant.',
    'Points come from justifying why external torque is zero or negligible, writing L_initial = L_final for the chosen system, and solving for a changed angular speed or rotation state without assuming I is constant.',
    'Ask whether the external torque about the chosen axis is zero; if it is, conserve total angular momentum for the system, not necessarily angular speed.',
    'A student on a low-friction rotating platform pulls two held masses closer to the rotation axis. With negligible external torque, what happens to angular momentum and angular speed?',
    'Both angular momentum and angular speed stay the same because no external torque acts.',
    'The system angular momentum stays constant, but angular speed increases. Pulling the masses inward reduces rotational inertia, so omega must increase to keep total L = I omega constant for the chosen system.',
    'Conserving angular speed instead of angular momentum when rotational inertia changes.',
    'In practice, write the system and external-torque check before using conservation. Then allow I and omega to change as long as total L is constant.'
  ),
  (
    'ap_physics_1', 6, '6.5', 'Rolling',
    'Rolling motion combines center-of-mass translation with rotation about the center. Rolling without slipping creates constraints such as v_cm = r omega, while slipping means those direct quantitative relationships no longer hold.',
    'Students need to identify the rolling condition before applying formulas. For ideal rolling without slipping, static friction can enforce the motion without dissipating energy. During slipping, kinetic friction dissipates energy and AP Physics 1 expects qualitative explanation rather than precise slipping kinematics.',
    'Points come from including translational and rotational energy, applying v_cm = r omega only when rolling without slipping is stated or justified, and explaining qualitatively how slipping changes linear and angular motion.',
    'Label whether the object rolls without slipping; then use v_cm = r omega and K = 1/2 mv_cm^2 + 1/2 I omega^2 only when that condition applies.',
    'A cylinder is rolling without slipping. If its center-of-mass speed is v_cm and radius is R, what angular speed should be used in rotational kinetic energy?',
    'Use any angular speed, because the translational kinetic energy already accounts for the rolling motion.',
    'Use omega = v_cm/R because rolling without slipping links center-of-mass speed and angular speed. The total kinetic energy still includes both 1/2 mv_cm^2 and 1/2 I omega^2.',
    'Using v_cm = r omega for a slipping object, where center-of-mass motion and rotation are not directly linked.',
    'Back in practice, circle the phrase "without slipping" when it appears. If it does not, justify the rolling constraint before using it.'
  ),
  (
    'ap_physics_1', 6, '6.6', 'Motion of Orbiting Satellites',
    'Satellite motion is analyzed as a gravitational system with energy and angular momentum. For a negligible-mass satellite around a massive central object, the central object can be treated as essentially fixed in AP Physics 1 models.',
    'Students need to distinguish circular and elliptical orbits. In circular orbits, gravitational potential energy, kinetic energy, total mechanical energy, and angular momentum are constant. In elliptical orbits, total mechanical energy and angular momentum are constant, but speed, kinetic energy, and gravitational potential energy change with position.',
    'Points come from choosing the satellite-central-object system, using U_g = -Gm1m2/r with zero at infinite separation, and applying conservation to the quantity that is actually constant. Escape speed follows from setting total mechanical energy equal to zero.',
    'Identify circular versus elliptical motion first, then decide which quantities are constant and which energy terms can change with orbital radius.',
    'A satellite moves in an elliptical orbit. As it gets closer to the central object, can its kinetic energy change if total mechanical energy is conserved?',
    'No. If total mechanical energy is conserved, kinetic energy must be constant too.',
    'Yes. In an elliptical orbit the total mechanical energy stays constant, but gravitational potential energy becomes more negative at smaller r. The kinetic energy increases so the sum K + U_g remains constant.',
    'Treating gravitational potential energy as zero at the planet surface or assuming speed is constant in every orbit.',
    'In practice, write which orbit type is given before choosing constants: circular keeps more quantities constant; elliptical keeps total energy and angular momentum constant while K and U_g can vary.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 6 Energy and Momentum of Rotating Systems; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 6: rotational kinetic energy K=1/2 I omega^2, total KE as translational plus rotational terms, torque work W=tau Delta theta and torque-vs-angle area, angular momentum magnitudes L=I omega and L=rmv sin(theta), angular impulse as Delta L and torque-vs-time area, angular momentum conservation, rolling without slipping constraints, qualitative slipping boundary, satellite orbital energy/angular momentum behavior, U_g=-Gm1m2/r, and escape-speed energy condition; batch 2026-08-25-ap-physics-1-unit6-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 6
    and topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and status = 'published';

  if v_briefs <> 6 then
    raise exception 'expected 6 published AP Physics 1 Unit 6 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_1'
    and unit_number = 6
    and topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and status = 'published';

  if v_explainers <> 6 then
    raise exception 'expected 6 published AP Physics 1 Unit 6 explainers, got %', v_explainers;
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
    where e.subject_key = 'ap_physics_1'
      and e.unit_number = 6
      and e.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 6 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 6 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_1'
    and b.unit_number = 6
    and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-1/unit-6/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 6 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 6 core_idea/what_it_is matches, got %', v_core_matches;
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
      e.subject_key = 'ap_physics_1'
      and e.unit_number = 6
      and e.topic_code in ('6.1', '6.2', '6.3', '6.4', '6.5', '6.6')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 6 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
