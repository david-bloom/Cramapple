begin;

-- Add AP Physics 1 Unit 5 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 6 AP Physics 1 Unit 5 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_1_CED_FACT_PACK.md Unit 5 (Torque and
-- Rotational Dynamics). The fact pack confirms rotational kinematics analogs,
-- linear/rotational connections s=r theta, v=r omega, a_T=r alpha, torque
-- magnitude rF_perp = rF sin(theta), lever arm reasoning, point-mass rotational
-- inertia and parallel-axis theorem, rotational equilibrium, Newton's laws in
-- rotational form, and AP Physics 1 boundaries: CW/CCW direction descriptions,
-- torque direction beyond scope, five-or-fewer point-mass inertia calculations,
-- no need to memorize extended-body inertia, and no multiple-plane rotation.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_1', 5, '5.1', 'Rotational Kinematics',
    'very-important', 'very-important',
    'Rotational kinematics describes angular position, angular velocity, and angular acceleration for rotation about an axis, using clockwise or counterclockwise signs.',
    'It lets you reuse linear kinematics logic for rotating systems. The key is choosing an axis and angle convention before applying constant-angular-acceleration equations.',
    'You earn points by defining the rotation axis, choosing CW or CCW as positive, using radians, and applying angular kinematics equations with signs consistently.',
    'Choose the axis and positive rotational direction first; then use theta, omega, and alpha the same way you use x, v, and a in linear kinematics.',
    'Mixing clockwise and counterclockwise signs after writing the angular kinematics equation.',
    '/learn/ap-physics-1/unit-5/rotational-kinematics'
  ),
  (
    'ap_physics_1', 5, '5.2', 'Connecting Linear and Rotational Motion',
    'very-important', 'very-important',
    'Points on a rotating rigid system connect angular and linear motion through s = r theta, v = r omega, and a_T = r alpha.',
    'These relationships explain why all points on a rigid object share angular motion but points farther from the axis move through more distance and have larger tangential speed.',
    'You earn points by using the radius of the specific point, keeping angular quantities common to the rigid body, and using tangential acceleration rather than total acceleration.',
    'Identify the point and its distance from the axis before using v = r omega or a_T = r alpha.',
    'Using the same linear speed for every point on a rotating rigid object because they share the same angular speed.',
    '/learn/ap-physics-1/unit-5/connecting-linear-and-rotational-motion'
  ),
  (
    'ap_physics_1', 5, '5.3', 'Torque',
    'very-important', 'very-important',
    'Torque measures how effectively a force causes rotation about an axis. Its magnitude is tau = rF_perp = rF sin(theta), or force times lever arm.',
    'Torque is the rotational version of force, but location matters. The same force can produce different rotational effects depending on where and how it is applied.',
    'You earn points by identifying the axis, measuring r from axis to force point, using only the perpendicular force component or lever arm, and applying CW/CCW signs when needed.',
    'Draw the line of action of the force, find the perpendicular lever arm from the axis, then compute tau magnitude and assign CW or CCW tendency.',
    'Multiplying force by the full distance to the axis when the force is not perpendicular.',
    '/learn/ap-physics-1/unit-5/torque'
  ),
  (
    'ap_physics_1', 5, '5.4', 'Rotational Inertia',
    'very-important', 'very-important',
    'Rotational inertia measures resistance to angular acceleration. For point masses, I = mr^2 and total rotational inertia is the sum of each m r^2 term.',
    'Mass farther from the axis matters more because radius is squared. This is why objects with the same mass can rotate very differently depending on mass distribution.',
    'You earn points by measuring each mass distance from the rotation axis, summing m r^2 for allowed point-mass systems, and reasoning qualitatively about mass distribution.',
    'Locate the axis first, then compute each point mass contribution with its own radius before adding them.',
    'Using total mass times one average radius squared without checking each object distance from the axis.',
    '/learn/ap-physics-1/unit-5/rotational-inertia'
  ),
  (
    'ap_physics_1', 5, '5.5', 'Rotational Equilibrium and Newton''s First Law in Rotational Form',
    'very-important', 'very-important',
    'Rotational equilibrium means net torque is zero, so angular velocity is constant. A system can be in rotational equilibrium without being in translational equilibrium, or vice versa.',
    'Equilibrium questions require separate force and torque reasoning. Balanced forces do not automatically mean balanced torques because force locations relative to the axis matter.',
    'You earn points by choosing an axis, summing CW and CCW torques, setting net torque to zero for rotational equilibrium, and separately checking translational equilibrium if asked.',
    'Write one torque-balance equation about a chosen axis; use signs for CW and CCW tendencies and do not assume force balance alone is enough.',
    'Saying an object is in rotational equilibrium just because the net force is zero.',
    '/learn/ap-physics-1/unit-5/rotational-equilibrium-and-newtons-first-law-in-rotational-form'
  ),
  (
    'ap_physics_1', 5, '5.6', 'Newton''s Second Law in Rotational Form',
    'very-important', 'very-important',
    'Newton''s second law in rotational form is alpha = tau_net/I_sys. Net torque causes angular acceleration, with rotational inertia resisting the change.',
    'This topic connects torque, inertia, and angular acceleration into one model. Many rotating systems need force analysis and torque analysis performed independently.',
    'You earn points by finding net torque about the axis, using the system rotational inertia about that axis, and solving for angular acceleration with correct signs.',
    'After drawing forces, write tau_net about the rotation axis, then divide by I_sys to get alpha.',
    'Using net force divided by mass for a rotating object when the question asks for angular acceleration.',
    '/learn/ap-physics-1/unit-5/newtons-second-law-in-rotational-form'
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
    'ap_physics_1', 5, '5.1', 'Rotational Kinematics',
    'Rotational kinematics uses angular versions of familiar motion quantities. Angular displacement, angular velocity, and angular acceleration follow the same constant-acceleration structure as linear kinematics once an axis and sign convention are chosen.',
    'Students need to treat rotation as motion about a specified axis. A rigid object can be modeled as extended for one rotational question even if it was treated as a point object in a different motion context. AP Physics 1 limits direction descriptions to clockwise and counterclockwise with respect to the chosen axis.',
    'Points come from choosing CW or CCW positive, keeping radians in angular equations, and using omega = omega0 + alpha t or theta = theta0 + omega0 t + 1/2 alpha t^2 with signs that match the convention.',
    'Choose the axis and positive rotational direction first; then use theta, omega, and alpha the same way you use x, v, and a in linear kinematics.',
    'A wheel starts from rest and rotates counterclockwise with constant angular acceleration. If counterclockwise is positive, what sign should omega have after it speeds up?',
    'Omega should be negative because the wheel is rotating and rotation is usually negative.',
    'Omega should be positive because the chosen convention says counterclockwise is positive. The sign comes from the stated axis and direction convention, not from a universal rule. If clockwise had been chosen positive, the same motion would have negative omega.',
    'Mixing clockwise and counterclockwise signs after writing the angular kinematics equation.',
    'Back in practice, write +CW or +CCW next to the axis before substituting any angular quantity.'
  ),
  (
    'ap_physics_1', 5, '5.2', 'Connecting Linear and Rotational Motion',
    'Rigid objects share angular motion, not identical linear motion at every point. A point twice as far from the axis travels twice the arc length for the same angle and has twice the tangential speed for the same omega.',
    'Students need to identify which point on the object is being described. The angular velocity and angular acceleration are common to all points in a rigid system, but s, v, and tangential acceleration depend on that point distance r from the axis.',
    'Points come from selecting the correct radius, using s = r theta, v = r omega, and a_T = r alpha, and avoiding claims about total acceleration when only tangential acceleration is represented by r alpha.',
    'Identify the point and its distance from the axis before using v = r omega or a_T = r alpha.',
    'Two marks on a rotating disk are at radii R and 2R. The disk has angular speed omega. How do their tangential speeds compare?',
    'They have the same speed because they are on the same rigid disk.',
    'They have the same angular speed, but not the same tangential speed. Using v = r omega, the mark at 2R has speed 2R omega, twice the speed R omega of the inner mark. Shared omega does not mean shared v.',
    'Using the same linear speed for every point on a rotating rigid object because they share the same angular speed.',
    'In practice, label omega as shared and v as point-specific. Then plug in each point radius separately.'
  ),
  (
    'ap_physics_1', 5, '5.3', 'Torque',
    'Torque depends on force, where the force is applied, and how much of the force is perpendicular to the radius from the axis. A force through the axis creates no torque because its lever arm is zero.',
    'Students need to draw rotational force diagrams with both force vectors and application points. AP Physics 1 expects torque magnitude and CW/CCW tendency, while torque direction as a vector is beyond this course scope.',
    'Points come from choosing the axis, drawing the line of action, finding the perpendicular lever arm or F_perp, and assigning CW/CCW signs for a net-torque equation.',
    'Draw the line of action of the force, find the perpendicular lever arm from the axis, then compute tau magnitude and assign CW or CCW tendency.',
    'A force of magnitude F is applied at distance r from a hinge, but the force points directly along the rod toward the hinge. What torque does it exert about the hinge?',
    'The torque is rF because the force is applied a distance r from the hinge.',
    'The torque is zero. The force line of action passes through the hinge, so the perpendicular lever arm is zero. Equivalently, the perpendicular component of the force relative to the radius is zero, so tau = rF_perp = 0.',
    'Multiplying force by the full distance to the axis when the force is not perpendicular.',
    'Back in practice, draw the force line of action through the object. The lever arm is the perpendicular distance from the axis to that line, not always the object length.'
  ),
  (
    'ap_physics_1', 5, '5.4', 'Rotational Inertia',
    'Rotational inertia depends on both mass and distance from the rotation axis. For point masses, each contribution is m r^2, so moving mass farther from the axis can change I strongly.',
    'Students need to locate the axis before calculating. AP Physics 1 asks quantitative rotational inertia for systems of five or fewer point objects in a plane; extended rigid-body formulas are supplied if needed, but qualitative mass-distribution reasoning is still expected.',
    'Points come from measuring each radius from the actual axis, squaring that radius, summing m_i r_i^2, and using parallel-axis reasoning only when the provided or known center-of-mass inertia is being shifted.',
    'Locate the axis first, then compute each point mass contribution with its own radius before adding them.',
    'Two equal masses m are attached to a light rod. One is distance R from the axis and the other is distance 2R from the axis. What is the total rotational inertia?',
    'The total is 2mR^2 because there are two masses and the radius is R.',
    'The total is mR^2 + m(2R)^2 = 5mR^2. Each mass uses its own distance from the axis, and the distance is squared. The farther mass contributes four times as much as the mass at R.',
    'Using total mass times one average radius squared without checking each object distance from the axis.',
    'In practice, make a mini table with one row per mass: m, r, and m r^2. Then add the last column.'
  ),
  (
    'ap_physics_1', 5, '5.5', 'Rotational Equilibrium and Newton''s First Law in Rotational Form',
    'Rotational equilibrium is about torque balance, not force balance alone. If net torque is zero, angular velocity is constant; if the object was not rotating, it stays not rotating.',
    'Students need to separate translational equilibrium from rotational equilibrium. Net force zero controls center-of-mass acceleration. Net torque zero controls angular acceleration. A system can satisfy one condition without satisfying the other depending on the forces and where they act.',
    'Points are earned by choosing an axis, summing torques with CW/CCW signs, setting sum tau = 0 for rotational equilibrium, and separately writing sum F = 0 only if translational equilibrium is required.',
    'Write one torque-balance equation about a chosen axis; use signs for CW and CCW tendencies and do not assume force balance alone is enough.',
    'A rigid bar has two equal and opposite vertical forces applied at different distances from the pivot. The net force is zero. Must the bar be in rotational equilibrium?',
    'Yes, because equal and opposite forces mean the forces balance.',
    'Not necessarily. The net force can be zero while the net torque is not zero if the forces have different lever arms or create torques in the same rotational sense. Rotational equilibrium requires sum tau = 0 about the axis, not just sum F = 0.',
    'Saying an object is in rotational equilibrium just because the net force is zero.',
    'Back in practice, write force balance and torque balance on separate lines. Do not let one equation silently stand in for the other.'
  ),
  (
    'ap_physics_1', 5, '5.6', 'Newton''s Second Law in Rotational Form',
    'Net torque causes angular acceleration according to alpha = tau_net/I_sys. A larger net torque increases angular acceleration; a larger rotational inertia reduces it for the same torque.',
    'Students need to know when rotational analysis is independent from linear analysis. A rigid body can require a free-body diagram for translation and a torque equation about an axis for rotation. The same force may appear in both equations but with different roles.',
    'Points come from calculating net torque with signs, using the rotational inertia about the same axis, and solving alpha = tau_net/I_sys. If linear acceleration is also involved, connect it only through valid constraints such as a_T = r alpha.',
    'After drawing forces, write tau_net about the rotation axis, then divide by I_sys to get alpha.',
    'A net clockwise torque of magnitude tau acts on a wheel with rotational inertia I. If clockwise is positive, what is alpha?',
    'Alpha is tau divided by mass because torque is a force-like quantity.',
    'The angular acceleration is alpha = tau_net/I. With clockwise chosen positive, alpha = +tau/I. Mass alone is not the rotational resistance; the relevant quantity is rotational inertia about the axis.',
    'Using net force divided by mass for a rotating object when the question asks for angular acceleration.',
    'In practice, check the requested acceleration type. Linear acceleration points to net force over mass; angular acceleration points to net torque over rotational inertia.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 5 Torque and Rotational Dynamics; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 5: rotational kinematics analogs, s=r theta, v=r omega, a_T=r alpha, torque rF_perp=rF sin(theta), lever arm reasoning, point-mass rotational inertia and parallel-axis theorem, rotational equilibrium, alpha=tau_net/I, CW/CCW direction boundary, torque-vector direction beyond AP Physics 1 scope, five-or-fewer point-mass inertia calculation boundary, and no multiple-plane rotation boundary; batch 2026-08-25-ap-physics-1-unit5-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_1', 5, '5.1', 'Rotational Kinematics',
    'Rotational kinematics uses angular versions of familiar motion quantities. Angular displacement, angular velocity, and angular acceleration follow the same constant-acceleration structure as linear kinematics once an axis and sign convention are chosen.',
    'Students need to treat rotation as motion about a specified axis. A rigid object can be modeled as extended for one rotational question even if it was treated as a point object in a different motion context. AP Physics 1 limits direction descriptions to clockwise and counterclockwise with respect to the chosen axis.',
    'Points come from choosing CW or CCW positive, keeping radians in angular equations, and using omega = omega0 + alpha t or theta = theta0 + omega0 t + 1/2 alpha t^2 with signs that match the convention.',
    'Choose the axis and positive rotational direction first; then use theta, omega, and alpha the same way you use x, v, and a in linear kinematics.',
    'A wheel starts from rest and rotates counterclockwise with constant angular acceleration. If counterclockwise is positive, what sign should omega have after it speeds up?',
    'Omega should be negative because the wheel is rotating and rotation is usually negative.',
    'Omega should be positive because the chosen convention says counterclockwise is positive. The sign comes from the stated axis and direction convention, not from a universal rule. If clockwise had been chosen positive, the same motion would have negative omega.',
    'Mixing clockwise and counterclockwise signs after writing the angular kinematics equation.',
    'Back in practice, write +CW or +CCW next to the axis before substituting any angular quantity.'
  ),
  (
    'ap_physics_1', 5, '5.2', 'Connecting Linear and Rotational Motion',
    'Rigid objects share angular motion, not identical linear motion at every point. A point twice as far from the axis travels twice the arc length for the same angle and has twice the tangential speed for the same omega.',
    'Students need to identify which point on the object is being described. The angular velocity and angular acceleration are common to all points in a rigid system, but s, v, and tangential acceleration depend on that point distance r from the axis.',
    'Points come from selecting the correct radius, using s = r theta, v = r omega, and a_T = r alpha, and avoiding claims about total acceleration when only tangential acceleration is represented by r alpha.',
    'Identify the point and its distance from the axis before using v = r omega or a_T = r alpha.',
    'Two marks on a rotating disk are at radii R and 2R. The disk has angular speed omega. How do their tangential speeds compare?',
    'They have the same speed because they are on the same rigid disk.',
    'They have the same angular speed, but not the same tangential speed. Using v = r omega, the mark at 2R has speed 2R omega, twice the speed R omega of the inner mark. Shared omega does not mean shared v.',
    'Using the same linear speed for every point on a rotating rigid object because they share the same angular speed.',
    'In practice, label omega as shared and v as point-specific. Then plug in each point radius separately.'
  ),
  (
    'ap_physics_1', 5, '5.3', 'Torque',
    'Torque depends on force, where the force is applied, and how much of the force is perpendicular to the radius from the axis. A force through the axis creates no torque because its lever arm is zero.',
    'Students need to draw rotational force diagrams with both force vectors and application points. AP Physics 1 expects torque magnitude and CW/CCW tendency, while torque direction as a vector is beyond this course scope.',
    'Points come from choosing the axis, drawing the line of action, finding the perpendicular lever arm or F_perp, and assigning CW/CCW signs for a net-torque equation.',
    'Draw the line of action of the force, find the perpendicular lever arm from the axis, then compute tau magnitude and assign CW or CCW tendency.',
    'A force of magnitude F is applied at distance r from a hinge, but the force points directly along the rod toward the hinge. What torque does it exert about the hinge?',
    'The torque is rF because the force is applied a distance r from the hinge.',
    'The torque is zero. The force line of action passes through the hinge, so the perpendicular lever arm is zero. Equivalently, the perpendicular component of the force relative to the radius is zero, so tau = rF_perp = 0.',
    'Multiplying force by the full distance to the axis when the force is not perpendicular.',
    'Back in practice, draw the force line of action through the object. The lever arm is the perpendicular distance from the axis to that line, not always the object length.'
  ),
  (
    'ap_physics_1', 5, '5.4', 'Rotational Inertia',
    'Rotational inertia depends on both mass and distance from the rotation axis. For point masses, each contribution is m r^2, so moving mass farther from the axis can change I strongly.',
    'Students need to locate the axis before calculating. AP Physics 1 asks quantitative rotational inertia for systems of five or fewer point objects in a plane; extended rigid-body formulas are supplied if needed, but qualitative mass-distribution reasoning is still expected.',
    'Points come from measuring each radius from the actual axis, squaring that radius, summing m_i r_i^2, and using parallel-axis reasoning only when the provided or known center-of-mass inertia is being shifted.',
    'Locate the axis first, then compute each point mass contribution with its own radius before adding them.',
    'Two equal masses m are attached to a light rod. One is distance R from the axis and the other is distance 2R from the axis. What is the total rotational inertia?',
    'The total is 2mR^2 because there are two masses and the radius is R.',
    'The total is mR^2 + m(2R)^2 = 5mR^2. Each mass uses its own distance from the axis, and the distance is squared. The farther mass contributes four times as much as the mass at R.',
    'Using total mass times one average radius squared without checking each object distance from the axis.',
    'In practice, make a mini table with one row per mass: m, r, and m r^2. Then add the last column.'
  ),
  (
    'ap_physics_1', 5, '5.5', 'Rotational Equilibrium and Newton''s First Law in Rotational Form',
    'Rotational equilibrium is about torque balance, not force balance alone. If net torque is zero, angular velocity is constant; if the object was not rotating, it stays not rotating.',
    'Students need to separate translational equilibrium from rotational equilibrium. Net force zero controls center-of-mass acceleration. Net torque zero controls angular acceleration. A system can satisfy one condition without satisfying the other depending on the forces and where they act.',
    'Points are earned by choosing an axis, summing torques with CW/CCW signs, setting sum tau = 0 for rotational equilibrium, and separately writing sum F = 0 only if translational equilibrium is required.',
    'Write one torque-balance equation about a chosen axis; use signs for CW and CCW tendencies and do not assume force balance alone is enough.',
    'A rigid bar has two equal and opposite vertical forces applied at different distances from the pivot. The net force is zero. Must the bar be in rotational equilibrium?',
    'Yes, because equal and opposite forces mean the forces balance.',
    'Not necessarily. The net force can be zero while the net torque is not zero if the forces have different lever arms or create torques in the same rotational sense. Rotational equilibrium requires sum tau = 0 about the axis, not just sum F = 0.',
    'Saying an object is in rotational equilibrium just because the net force is zero.',
    'Back in practice, write force balance and torque balance on separate lines. Do not let one equation silently stand in for the other.'
  ),
  (
    'ap_physics_1', 5, '5.6', 'Newton''s Second Law in Rotational Form',
    'Net torque causes angular acceleration according to alpha = tau_net/I_sys. A larger net torque increases angular acceleration; a larger rotational inertia reduces it for the same torque.',
    'Students need to know when rotational analysis is independent from linear analysis. A rigid body can require a free-body diagram for translation and a torque equation about an axis for rotation. The same force may appear in both equations but with different roles.',
    'Points come from calculating net torque with signs, using the rotational inertia about the same axis, and solving alpha = tau_net/I_sys. If linear acceleration is also involved, connect it only through valid constraints such as a_T = r alpha.',
    'After drawing forces, write tau_net about the rotation axis, then divide by I_sys to get alpha.',
    'A net clockwise torque of magnitude tau acts on a wheel with rotational inertia I. If clockwise is positive, what is alpha?',
    'Alpha is tau divided by mass because torque is a force-like quantity.',
    'The angular acceleration is alpha = tau_net/I. With clockwise chosen positive, alpha = +tau/I. Mass alone is not the rotational resistance; the relevant quantity is rotational inertia about the axis.',
    'Using net force divided by mass for a rotating object when the question asks for angular acceleration.',
    'In practice, check the requested acceleration type. Linear acceleration points to net force over mass; angular acceleration points to net torque over rotational inertia.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 5 Torque and Rotational Dynamics; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 5: rotational kinematics analogs, s=r theta, v=r omega, a_T=r alpha, torque rF_perp=rF sin(theta), lever arm reasoning, point-mass rotational inertia and parallel-axis theorem, rotational equilibrium, alpha=tau_net/I, CW/CCW direction boundary, torque-vector direction beyond AP Physics 1 scope, five-or-fewer point-mass inertia calculation boundary, and no multiple-plane rotation boundary; batch 2026-08-25-ap-physics-1-unit5-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 5
    and topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and status = 'published';

  if v_briefs <> 6 then
    raise exception 'expected 6 published AP Physics 1 Unit 5 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_1'
    and unit_number = 5
    and topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and status = 'published';

  if v_explainers <> 6 then
    raise exception 'expected 6 published AP Physics 1 Unit 5 explainers, got %', v_explainers;
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
      and b.unit_number = 5
      and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
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
      and e.unit_number = 5
      and e.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 5 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 5 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_1'
    and b.unit_number = 5
    and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-1/unit-5/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 5 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 5 core_idea/what_it_is matches, got %', v_core_matches;
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
      and unit_number = 5
      and topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
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
      and e.unit_number = 5
      and e.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 5 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
