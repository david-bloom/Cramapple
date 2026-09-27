begin;

-- Add AP Physics C: Mechanics Unit 5 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 6 AP Physics C:Mechanics Unit 5 topics and 0
-- published point briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 5
-- (Torque and Rotational Dynamics). The fact pack confirms rotational
-- kinematics with derivative definitions omega = d theta/dt and alpha =
-- d omega/dt, rigid-body linear/angular relationships, torque magnitude and
-- full vector cross-product/right-hand-rule direction treatment, rotational
-- inertia sums and integrals, rotational equilibrium, and Newton's second law
-- in rotational form. Scope boundaries preserved here: rotational-kinematics
-- vector directions are limited to CW/CCW relative to a chosen axis, but torque
-- direction is in scope for Physics C: Mechanics; simultaneous rotation in
-- multiple planes is not expected.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_c_mechanics', 5, '5.1', 'Rotational Kinematics',
    'very-important', 'very-important',
    'Rotational kinematics describes angular position, velocity, and acceleration about an axis, with omega = d theta/dt and alpha = d omega/dt in Physics C: Mechanics.',
    'It extends linear kinematics into calculus-based rotation. Choosing an axis and sign convention lets angular derivatives, integrals, and constant-alpha equations describe rigid-body motion.',
    'You earn points by defining the axis and positive CW/CCW direction, using radians, connecting derivatives to graphs, and applying constant-angular-acceleration equations only when alpha is constant.',
    'Set the rotation axis and sign convention first; then treat omega as the derivative of theta and alpha as the derivative of omega before choosing equations.',
    'Using constant-alpha kinematics when alpha varies with time, instead of differentiating or integrating the given angular function.',
    '/learn/ap-physics-c-mechanics/unit-5/rotational-kinematics'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.2', 'Connecting Linear and Rotational Motion',
    'very-important', 'very-important',
    'Points in a rigid rotating system connect angular and linear quantities through Delta s = r Delta theta, v = r omega, and a_T = r alpha for the point radius r.',
    'This topic keeps rigid-body motion from collapsing into point-particle motion. Different points share omega and alpha but have different arc length, speed, and tangential acceleration.',
    'You earn points by identifying the exact point and its radius from the axis, using tangential quantities only for r alpha, and not confusing shared angular motion with shared linear motion.',
    'Choose the point on the rigid body before using any r relationship; the radius belongs to that point, not to the whole object generically.',
    'Giving every point on a rotating object the same linear speed because the rigid body has one angular speed.',
    '/learn/ap-physics-c-mechanics/unit-5/connecting-linear-and-rotational-motion'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.3', 'Torque',
    'very-important', 'very-important',
    'Torque measures a force''s rotational effect about an axis. In Physics C: Mechanics, torque is also a vector cross product, tau vector = r vector cross F vector.',
    'Torque is where Physics C differs sharply from AP Physics 1. Magnitude still depends on lever arm or perpendicular force, but direction by right-hand rule is assessable here.',
    'You earn points by choosing the axis, drawing the force application point, finding r cross F magnitude, and determining torque direction or sign with the right-hand rule when needed.',
    'Draw r from the axis to the force point, resolve the perpendicular part of F, then use the right-hand rule for the torque vector direction.',
    'Treating torque as only clockwise or counterclockwise and ignoring the vector direction required by a cross product.',
    '/learn/ap-physics-c-mechanics/unit-5/torque'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.4', 'Rotational Inertia',
    'very-important', 'very-important',
    'Rotational inertia measures resistance to angular acceleration about a chosen axis. For point masses I = sum m_i r_i^2; for continuous bodies, I = integral r^2 dm.',
    'This is the rotational analog of mass, but it depends on both the body and the axis. Physics C expects integral setup for continuous mass distributions when formulas are not simply supplied.',
    'You earn points by defining the axis, expressing r and dm consistently for the distribution, setting integration limits, or summing m r^2 terms for discrete masses.',
    'Start with the axis, then choose point-mass summation or I = integral r^2 dm based on whether the mass distribution is discrete or continuous.',
    'Using total mass times one radius squared without deriving how each mass element is distributed around the axis.',
    '/learn/ap-physics-c-mechanics/unit-5/rotational-inertia'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.5', 'Rotational Equilibrium and Newton''s First Law in Rotational Form',
    'very-important', 'very-important',
    'Rotational equilibrium means the net torque on a system is zero, so angular velocity is constant. It is separate from translational equilibrium.',
    'Many rigid-body problems require force balance and torque balance at the same time. A body can have zero net force but nonzero net torque, or the reverse, depending on where forces act.',
    'You earn points by choosing an axis, summing torques with signs or vector directions, setting net torque to zero for rotational equilibrium, and separately applying net force equations when needed.',
    'Write translational and rotational equilibrium as separate conditions: sum F = 0 for center-of-mass motion and sum tau = 0 for angular motion.',
    'Assuming zero net force automatically means zero net torque.',
    '/learn/ap-physics-c-mechanics/unit-5/rotational-equilibrium-and-newtons-first-law-in-rotational-form'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.6', 'Newton''s Second Law in Rotational Form',
    'very-important', 'very-important',
    'Newton''s second law in rotational form is alpha_sys = tau_net/I_sys for a rigid system about a fixed axis. Net torque causes angular acceleration.',
    'It is the dynamics bridge between torque, rotational inertia, and angular acceleration. Physics C problems often require separate translational and rotational equations joined by constraints.',
    'You earn points by summing torques about the correct axis, using the system rotational inertia about that same axis, and coupling linear and angular acceleration only through valid constraints.',
    'After the force diagram, write a torque equation about the rotation axis, then use alpha = tau_net/I and add constraint equations only when the geometry justifies them.',
    'Dividing net torque by mass or mixing torque about one axis with rotational inertia about another axis.',
    '/learn/ap-physics-c-mechanics/unit-5/newtons-second-law-in-rotational-form'
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
    'ap_physics_c_mechanics', 5, '5.1', 'Rotational Kinematics',
    'Rotational kinematics is calculus-based angular motion about a chosen axis. Angular velocity is d theta/dt and angular acceleration is d omega/dt, so graphs and functions of time can be differentiated or integrated just like in translational kinematics.',
    'Students need to choose a rotation axis and positive direction before interpreting signs. For rotational kinematics quantities, this course keeps direction descriptions to clockwise and counterclockwise relative to the chosen axis, even though later torque direction uses full cross-product reasoning.',
    'Points come from connecting angular position, angular velocity, and angular acceleration through derivatives or integrals; using radians; and reserving constant-alpha equations for cases where alpha is actually constant.',
    'Set the rotation axis and sign convention first; then treat omega as the derivative of theta and alpha as the derivative of omega before choosing equations.',
    'A disk has angular position theta(t) = Bt^3. What should be done to find angular velocity and angular acceleration at time t?',
    'Use the constant-angular-acceleration equations because the object is rotating.',
    'Differentiate the given function. Angular velocity is omega(t) = d theta/dt = 3Bt^2, and angular acceleration is alpha(t) = d omega/dt = 6Bt. Since alpha changes with time, constant-alpha kinematics are not justified.',
    'Using constant-alpha kinematics when alpha varies with time, instead of differentiating or integrating the given angular function.',
    'Back in practice, inspect the prompt first: a function of time points toward calculus; a stated constant alpha licenses the rotational kinematics equations.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.2', 'Connecting Linear and Rotational Motion',
    'A rigid body shares angular motion across its points, but each point has linear motion set by its own distance from the axis. The relationships Delta s = r Delta theta, v = r omega, and a_T = r alpha are point-specific.',
    'Students need to separate tangential quantities from total acceleration. The equation a_T = r alpha gives the tangential component only; radial or centripetal acceleration is a different component tied to v^2/r or r omega^2 when circular motion is present.',
    'Points come from identifying the point radius, using the same omega or alpha for all points in the rigid body, and then calculating each point linear quantity with its own r. A response should not imply that every point has the same speed.',
    'Choose the point on the rigid body before using any r relationship; the radius belongs to that point, not to the whole object generically.',
    'Two sensors on a spinning disk are at radii R and 3R. The disk has angular speed omega and angular acceleration alpha. Compare their tangential speeds and tangential accelerations.',
    'They are the same because the disk is rigid and shares one omega and one alpha.',
    'The points share omega and alpha, but their linear quantities differ. The outer sensor has v = 3R omega and a_T = 3R alpha, while the inner sensor has v = R omega and a_T = R alpha. The outer values are three times larger because r is three times larger.',
    'Giving every point on a rotating object the same linear speed because the rigid body has one angular speed.',
    'In practice, write shared quantities in one column and point-specific quantities in another before substituting radii.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.3', 'Torque',
    'Torque is the rotational effect of a force about an axis, and in Physics C: Mechanics it is a vector cross product: tau vector = r vector cross F vector. Its magnitude is rF sin(theta), and its direction follows the right-hand rule.',
    'Students need to track both magnitude and direction. The lever-arm shortcut is useful for magnitude, but a cross-product prompt can also ask for direction perpendicular to the plane defined by r and F. This is an in-scope Physics C distinction from AP Physics 1.',
    'Points come from drawing r from the axis to the point where the force is applied, using the perpendicular force component or lever arm for magnitude, and applying the right-hand rule or sign convention for direction.',
    'Draw r from the axis to the force point, resolve the perpendicular part of F, then use the right-hand rule for the torque vector direction.',
    'A force F points in the +y direction at a point whose position vector from the axis is in the +x direction. What is the direction of the torque vector?',
    'The torque is simply counterclockwise, so no vector direction is needed.',
    'Use tau vector = r vector cross F vector. With r in +x and F in +y, the right-hand rule gives torque in the +z direction. Counterclockwise may describe the rotation as viewed from +z, but the vector direction is the scored Physics C statement.',
    'Treating torque as only clockwise or counterclockwise and ignoring the vector direction required by a cross product.',
    'Back in practice, write r cross F before using a lever arm. That keeps both magnitude and direction visible.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.4', 'Rotational Inertia',
    'Rotational inertia depends on how mass is distributed relative to an axis. Discrete systems use sums of m r^2, while continuous systems use I = integral r^2 dm with a mass element chosen from the geometry.',
    'Students need to build the integral from the axis outward. The same object can have different rotational inertia about different axes. For a continuous body, dm must be written in terms of the integration variable, such as lambda dx for a uniform rod or sigma dA for a lamina.',
    'Points come from defining the axis, expressing r in the integral, replacing dm with a density expression, setting correct limits, and evaluating or comparing the result. Qualitative answers should still explain whether mass is closer to or farther from the axis.',
    'Start with the axis, then choose point-mass summation or I = integral r^2 dm based on whether the mass distribution is discrete or continuous.',
    'A uniform thin rod of length L rotates about an axis through one end, perpendicular to the rod. What is the setup idea for finding I if no formula is supplied?',
    'Use I = ML^2 because all of the mass is length L from the axis.',
    'Use I = integral r^2 dm. For a uniform rod, choose x measured from the axis and dm = (M/L) dx, so I = integral from 0 to L of x^2 (M/L) dx. Each bit of mass has its own distance x from the axis, not the same distance L.',
    'Using total mass times one radius squared without deriving how each mass element is distributed around the axis.',
    'In practice, draw the axis and a tiny mass element. Label its distance from the axis before writing dm.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.5', 'Rotational Equilibrium and Newton''s First Law in Rotational Form',
    'Rotational equilibrium requires zero net torque, which means angular velocity is constant. Translational equilibrium requires zero net force. Rigid-body statics often requires both, but they are different equations with different physical meanings.',
    'Students need to choose the torque axis strategically. If a force has an unknown magnitude and its line of action passes through the chosen axis, it produces zero torque about that axis and can drop out of the torque equation. That can make equilibrium problems solvable without unnecessary algebra.',
    'Points come from stating both equilibrium conditions when both are needed, choosing an axis, assigning torque signs or vector directions, and setting the sum of torques equal to zero. The course does not expect simultaneous rotation in multiple planes.',
    'Write translational and rotational equilibrium as separate conditions: sum F = 0 for center-of-mass motion and sum tau = 0 for angular motion.',
    'A horizontal beam has upward and downward forces whose vector sum is zero, but the forces act at different distances from a pivot. Is zero net force enough to prove rotational equilibrium?',
    'Yes. If the forces sum to zero, the beam cannot rotate.',
    'No. Zero net force proves translational equilibrium, not rotational equilibrium. The torques may fail to cancel if the forces have different lever arms. Rotational equilibrium requires sum tau = 0 about the chosen axis in addition to any needed force-balance equations.',
    'Assuming zero net force automatically means zero net torque.',
    'Back in practice, write sum F and sum tau on separate lines. If the prompt says equilibrium, decide whether it means translational, rotational, or both.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.6', 'Newton''s Second Law in Rotational Form',
    'Net torque produces angular acceleration according to alpha_sys = tau_net/I_sys for the relevant rigid system and axis. The torque and rotational inertia must be calculated about the same axis.',
    'Students need to combine rotational dynamics with translational dynamics carefully. A rolling object, pulley, or unwinding string can require sum F = ma for translation, sum tau = I alpha for rotation, and a constraint such as a = r alpha to connect them.',
    'Points come from drawing the forces, choosing the rotation axis, summing torques with signs or directions, using the correct I for that axis, and only then linking alpha to linear acceleration through a valid no-slip or string constraint.',
    'After the force diagram, write a torque equation about the rotation axis, then use alpha = tau_net/I and add constraint equations only when the geometry justifies them.',
    'A light string wrapped around a disk pulls with tension T at radius R. The disk rotates about a fixed axle with rotational inertia I. What equation gives the angular acceleration?',
    'Use alpha = T/m because tension is the force causing the motion.',
    'The torque from the tension is tau = RT if the string is tangent to the disk. About the axle, Newton''s second law in rotational form gives alpha = tau_net/I = RT/I. Mass alone is not the rotational resistance; the relevant quantity is I about the axle.',
    'Dividing net torque by mass or mixing torque about one axis with rotational inertia about another axis.',
    'In practice, check that every torque and every rotational inertia term refers to the same chosen axis before solving for alpha.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 5 Torque and Rotational Dynamics; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 5: derivative definitions omega=d theta/dt and alpha=d omega/dt, constant-angular-acceleration rotational kinematics, Delta s=r Delta theta, v=r omega, a_T=r alpha, torque magnitude rF_perp=rF sin(theta), lever arm reasoning, torque vector as r cross F with right-hand-rule direction in scope, point-mass rotational inertia sums, continuous-body I=integral r^2 dm, rotational equilibrium sum tau=0, alpha_sys=tau_net/I_sys, rotational-kinematics CW/CCW direction boundary, and no simultaneous multiple-plane rotation boundary; batch 2026-08-25-ap-physics-c-mechanics-unit5-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_c_mechanics', 5, '5.1', 'Rotational Kinematics',
    'Rotational kinematics is calculus-based angular motion about a chosen axis. Angular velocity is d theta/dt and angular acceleration is d omega/dt, so graphs and functions of time can be differentiated or integrated just like in translational kinematics.',
    'Students need to choose a rotation axis and positive direction before interpreting signs. For rotational kinematics quantities, this course keeps direction descriptions to clockwise and counterclockwise relative to the chosen axis, even though later torque direction uses full cross-product reasoning.',
    'Points come from connecting angular position, angular velocity, and angular acceleration through derivatives or integrals; using radians; and reserving constant-alpha equations for cases where alpha is actually constant.',
    'Set the rotation axis and sign convention first; then treat omega as the derivative of theta and alpha as the derivative of omega before choosing equations.',
    'A disk has angular position theta(t) = Bt^3. What should be done to find angular velocity and angular acceleration at time t?',
    'Use the constant-angular-acceleration equations because the object is rotating.',
    'Differentiate the given function. Angular velocity is omega(t) = d theta/dt = 3Bt^2, and angular acceleration is alpha(t) = d omega/dt = 6Bt. Since alpha changes with time, constant-alpha kinematics are not justified.',
    'Using constant-alpha kinematics when alpha varies with time, instead of differentiating or integrating the given angular function.',
    'Back in practice, inspect the prompt first: a function of time points toward calculus; a stated constant alpha licenses the rotational kinematics equations.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.2', 'Connecting Linear and Rotational Motion',
    'A rigid body shares angular motion across its points, but each point has linear motion set by its own distance from the axis. The relationships Delta s = r Delta theta, v = r omega, and a_T = r alpha are point-specific.',
    'Students need to separate tangential quantities from total acceleration. The equation a_T = r alpha gives the tangential component only; radial or centripetal acceleration is a different component tied to v^2/r or r omega^2 when circular motion is present.',
    'Points come from identifying the point radius, using the same omega or alpha for all points in the rigid body, and then calculating each point linear quantity with its own r. A response should not imply that every point has the same speed.',
    'Choose the point on the rigid body before using any r relationship; the radius belongs to that point, not to the whole object generically.',
    'Two sensors on a spinning disk are at radii R and 3R. The disk has angular speed omega and angular acceleration alpha. Compare their tangential speeds and tangential accelerations.',
    'They are the same because the disk is rigid and shares one omega and one alpha.',
    'The points share omega and alpha, but their linear quantities differ. The outer sensor has v = 3R omega and a_T = 3R alpha, while the inner sensor has v = R omega and a_T = R alpha. The outer values are three times larger because r is three times larger.',
    'Giving every point on a rotating object the same linear speed because the rigid body has one angular speed.',
    'In practice, write shared quantities in one column and point-specific quantities in another before substituting radii.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.3', 'Torque',
    'Torque is the rotational effect of a force about an axis, and in Physics C: Mechanics it is a vector cross product: tau vector = r vector cross F vector. Its magnitude is rF sin(theta), and its direction follows the right-hand rule.',
    'Students need to track both magnitude and direction. The lever-arm shortcut is useful for magnitude, but a cross-product prompt can also ask for direction perpendicular to the plane defined by r and F. This is an in-scope Physics C distinction from AP Physics 1.',
    'Points come from drawing r from the axis to the point where the force is applied, using the perpendicular force component or lever arm for magnitude, and applying the right-hand rule or sign convention for direction.',
    'Draw r from the axis to the force point, resolve the perpendicular part of F, then use the right-hand rule for the torque vector direction.',
    'A force F points in the +y direction at a point whose position vector from the axis is in the +x direction. What is the direction of the torque vector?',
    'The torque is simply counterclockwise, so no vector direction is needed.',
    'Use tau vector = r vector cross F vector. With r in +x and F in +y, the right-hand rule gives torque in the +z direction. Counterclockwise may describe the rotation as viewed from +z, but the vector direction is the scored Physics C statement.',
    'Treating torque as only clockwise or counterclockwise and ignoring the vector direction required by a cross product.',
    'Back in practice, write r cross F before using a lever arm. That keeps both magnitude and direction visible.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.4', 'Rotational Inertia',
    'Rotational inertia depends on how mass is distributed relative to an axis. Discrete systems use sums of m r^2, while continuous systems use I = integral r^2 dm with a mass element chosen from the geometry.',
    'Students need to build the integral from the axis outward. The same object can have different rotational inertia about different axes. For a continuous body, dm must be written in terms of the integration variable, such as lambda dx for a uniform rod or sigma dA for a lamina.',
    'Points come from defining the axis, expressing r in the integral, replacing dm with a density expression, setting correct limits, and evaluating or comparing the result. Qualitative answers should still explain whether mass is closer to or farther from the axis.',
    'Start with the axis, then choose point-mass summation or I = integral r^2 dm based on whether the mass distribution is discrete or continuous.',
    'A uniform thin rod of length L rotates about an axis through one end, perpendicular to the rod. What is the setup idea for finding I if no formula is supplied?',
    'Use I = ML^2 because all of the mass is length L from the axis.',
    'Use I = integral r^2 dm. For a uniform rod, choose x measured from the axis and dm = (M/L) dx, so I = integral from 0 to L of x^2 (M/L) dx. Each bit of mass has its own distance x from the axis, not the same distance L.',
    'Using total mass times one radius squared without deriving how each mass element is distributed around the axis.',
    'In practice, draw the axis and a tiny mass element. Label its distance from the axis before writing dm.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.5', 'Rotational Equilibrium and Newton''s First Law in Rotational Form',
    'Rotational equilibrium requires zero net torque, which means angular velocity is constant. Translational equilibrium requires zero net force. Rigid-body statics often requires both, but they are different equations with different physical meanings.',
    'Students need to choose the torque axis strategically. If a force has an unknown magnitude and its line of action passes through the chosen axis, it produces zero torque about that axis and can drop out of the torque equation. That can make equilibrium problems solvable without unnecessary algebra.',
    'Points come from stating both equilibrium conditions when both are needed, choosing an axis, assigning torque signs or vector directions, and setting the sum of torques equal to zero. The course does not expect simultaneous rotation in multiple planes.',
    'Write translational and rotational equilibrium as separate conditions: sum F = 0 for center-of-mass motion and sum tau = 0 for angular motion.',
    'A horizontal beam has upward and downward forces whose vector sum is zero, but the forces act at different distances from a pivot. Is zero net force enough to prove rotational equilibrium?',
    'Yes. If the forces sum to zero, the beam cannot rotate.',
    'No. Zero net force proves translational equilibrium, not rotational equilibrium. The torques may fail to cancel if the forces have different lever arms. Rotational equilibrium requires sum tau = 0 about the chosen axis in addition to any needed force-balance equations.',
    'Assuming zero net force automatically means zero net torque.',
    'Back in practice, write sum F and sum tau on separate lines. If the prompt says equilibrium, decide whether it means translational, rotational, or both.'
  ),
  (
    'ap_physics_c_mechanics', 5, '5.6', 'Newton''s Second Law in Rotational Form',
    'Net torque produces angular acceleration according to alpha_sys = tau_net/I_sys for the relevant rigid system and axis. The torque and rotational inertia must be calculated about the same axis.',
    'Students need to combine rotational dynamics with translational dynamics carefully. A rolling object, pulley, or unwinding string can require sum F = ma for translation, sum tau = I alpha for rotation, and a constraint such as a = r alpha to connect them.',
    'Points come from drawing the forces, choosing the rotation axis, summing torques with signs or directions, using the correct I for that axis, and only then linking alpha to linear acceleration through a valid no-slip or string constraint.',
    'After the force diagram, write a torque equation about the rotation axis, then use alpha = tau_net/I and add constraint equations only when the geometry justifies them.',
    'A light string wrapped around a disk pulls with tension T at radius R. The disk rotates about a fixed axle with rotational inertia I. What equation gives the angular acceleration?',
    'Use alpha = T/m because tension is the force causing the motion.',
    'The torque from the tension is tau = RT if the string is tangent to the disk. About the axle, Newton''s second law in rotational form gives alpha = tau_net/I = RT/I. Mass alone is not the rotational resistance; the relevant quantity is I about the axle.',
    'Dividing net torque by mass or mixing torque about one axis with rotational inertia about another axis.',
    'In practice, check that every torque and every rotational inertia term refers to the same chosen axis before solving for alpha.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 5 Torque and Rotational Dynamics; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 5: derivative definitions omega=d theta/dt and alpha=d omega/dt, constant-angular-acceleration rotational kinematics, Delta s=r Delta theta, v=r omega, a_T=r alpha, torque magnitude rF_perp=rF sin(theta), lever arm reasoning, torque vector as r cross F with right-hand-rule direction in scope, point-mass rotational inertia sums, continuous-body I=integral r^2 dm, rotational equilibrium sum tau=0, alpha_sys=tau_net/I_sys, rotational-kinematics CW/CCW direction boundary, and no simultaneous multiple-plane rotation boundary; batch 2026-08-25-ap-physics-c-mechanics-unit5-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 5
    and topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and status = 'published';

  if v_briefs <> 6 then
    raise exception 'expected 6 published AP Physics C:Mechanics Unit 5 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_c_mechanics'
    and unit_number = 5
    and topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and status = 'published';

  if v_explainers <> 6 then
    raise exception 'expected 6 published AP Physics C:Mechanics Unit 5 explainers, got %', v_explainers;
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
    where e.subject_key = 'ap_physics_c_mechanics'
      and e.unit_number = 5
      and e.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 5 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 5 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.unit_number = 5
    and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-c-mechanics/unit-5/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 5 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 5 core_idea/what_it_is matches, got %', v_core_matches;
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
      e.subject_key = 'ap_physics_c_mechanics'
      and e.unit_number = 5
      and e.topic_code in ('5.1', '5.2', '5.3', '5.4', '5.5', '5.6')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 5 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
