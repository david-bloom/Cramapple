begin;

-- Add AP Physics C: Mechanics Unit 2 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 10 AP Physics C:Mechanics Unit 2 topics and 0
-- published point briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 2
-- (Force and Translational Dynamics). The fact pack confirms continuous center
-- of mass integrals, FBD arrow conventions, Newton's laws, massive-string
-- tension as in scope, universal gravitation and shell-theorem results, static
-- friction as an inequality, series/parallel spring constants, resistive-force
-- differential equations, terminal velocity, and circular-motion force models.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_physics_c_mechanics', 2, '2.1', 'Systems and Center of Mass', 'very-important', 'very-important',
   'A system is the chosen collection of objects. Center of mass locates the system average position, using sums for particles or integrals for continuous mass distributions.',
   'System choice controls which forces are internal and whether a complex object can be treated as one body. Center of mass connects distributed mass to translational dynamics.',
   'You earn points by defining the system, writing the correct mass-weighted sum or integral, choosing density and limits, and using center-of-mass motion for external-force analysis.',
   'Draw the system boundary first; then choose a particle sum or r_cm = integral r dm over integral dm based on whether the mass is discrete or continuous.',
   'Using a geometric midpoint as center of mass without checking the mass distribution.',
   '/learn/ap-physics-c-mechanics/unit-2/systems-and-center-of-mass'),
  ('ap_physics_c_mechanics', 2, '2.2', 'Forces and Free-Body Diagrams', 'very-important', 'very-important',
   'Forces are vector interactions exerted on an object or system. A free-body diagram shows individual force arrows from the center-of-mass dot, not components.',
   'Correct force diagrams are the entry point for nearly every dynamics problem. Missing or invented forces usually cause the algebra to fail before it begins.',
   'You earn points by drawing only forces exerted on the selected object, labeling interaction partners when useful, keeping same-direction forces side by side, and choosing helpful axes.',
   'Choose the object, then draw one arrow for each external force on it before resolving components in equations.',
   'Drawing component arrows on the FBD as if they were additional forces.',
   '/learn/ap-physics-c-mechanics/unit-2/forces-and-free-body-diagrams'),
  ('ap_physics_c_mechanics', 2, '2.3', 'Newton''s Third Law', 'very-important', 'very-important',
   'Newton''s third law pairs are equal-magnitude, opposite-direction forces exerted on different objects. Internal third-law pairs do not change system center-of-mass motion.',
   'It separates interaction pairs from force balance. Physics C also allows non-ideal string cases where tension may vary along a massive string.',
   'You earn points by identifying which object each force acts on, excluding internal forces from a system net-force sum, and not assuming massive-string tension is uniform.',
   'Name both objects in the interaction pair: force by A on B and force by B on A. Then decide whether each force is internal or external to the chosen system.',
   'Putting both third-law forces on the same free-body diagram for one object.',
   '/learn/ap-physics-c-mechanics/unit-2/newtons-third-law'),
  ('ap_physics_c_mechanics', 2, '2.4', 'Newton''s First Law', 'very-important', 'very-important',
   'Newton''s first law says velocity is constant in an inertial frame when net force is zero. Balanced forces can apply in one direction while another direction accelerates.',
   'It is the logic behind translational equilibrium and inertial reference frames. It keeps students from treating rest, constant velocity, and zero force as different laws.',
   'You earn points by setting the vector net force to zero only for directions in equilibrium and by stating when an observer frame can be treated as inertial.',
   'Check each axis separately: if acceleration is zero along that axis, write sum F for that axis equals zero.',
   'Assuming an object moving at constant speed in one direction has zero net force in every direction.',
   '/learn/ap-physics-c-mechanics/unit-2/newtons-first-law'),
  ('ap_physics_c_mechanics', 2, '2.5', 'Newton''s Second Law', 'very-important', 'very-important',
   'Newton''s second law connects net external force to center-of-mass acceleration: a_sys = F_net/m_sys for constant-mass systems.',
   'It is the main equation for translational dynamics. In Physics C, system choice and component equations matter because forces may vary or couple to constraints.',
   'You earn points by summing external forces on the selected system, writing component equations, matching acceleration directions, and using mass of the system represented by the equation.',
   'After the FBD, write sum F_x = m a_x and sum F_y = m a_y for the same object or system; keep constraints on separate lines.',
   'Mixing forces from different objects into one equation without defining a system.',
   '/learn/ap-physics-c-mechanics/unit-2/newtons-second-law'),
  ('ap_physics_c_mechanics', 2, '2.6', 'Gravitational Force', 'very-important', 'very-important',
   'Gravitational force is attractive and follows F_g = Gm1m2/r^2 along the line between centers of mass. Gravitational field is g = GM/r^2.',
   'This topic connects weight, apparent weight, shell theorem results, and orbital force models. Physics C can use shell-theorem consequences without requiring proof of the theorem.',
   'You earn points by choosing the interacting masses and separation, distinguishing weight from normal force, and applying shell-theorem results only for spherical mass distributions.',
   'Identify whether the question asks for force, field, weight, or apparent weight; then choose mg, GMm/r^2, or a shell-theorem result accordingly.',
   'Treating apparent weight as always equal to gravitational force even when the object accelerates.',
   '/learn/ap-physics-c-mechanics/unit-2/gravitational-force'),
  ('ap_physics_c_mechanics', 2, '2.7', 'Kinetic and Static Friction', 'very-important', 'very-important',
   'Kinetic friction has magnitude mu_k F_N and opposes sliding. Static friction adjusts up to a maximum: F_s <= mu_s F_N, reaching equality only at impending slip.',
   'Friction is a frequent source of wrong equations. Static friction is not automatically maximum, and Physics C can require quantitative friction in circular or rotational setups.',
   'You earn points by deciding whether the contact is sliding or not, using kinetic friction as an equality, using static friction as an inequality, and finding its direction from relative motion tendency.',
   'Ask whether the surfaces slide. If not, solve for the static friction needed first, then compare it to mu_s F_N only as a limit.',
   'Setting F_s = mu_s F_N in every static-friction problem.',
   '/learn/ap-physics-c-mechanics/unit-2/kinetic-and-static-friction'),
  ('ap_physics_c_mechanics', 2, '2.8', 'Spring Forces', 'very-important', 'very-important',
   'An ideal spring exerts F_s = -k Delta x toward equilibrium. Equivalent spring constants can be found for purely series or purely parallel spring systems.',
   'Springs connect force, energy, and oscillation topics. The effective spring constant determines the force model before later energy or SHM equations are valid.',
   'You earn points by identifying displacement from equilibrium, assigning the restoring-force direction, and using series or parallel formulas only for those allowed arrangements.',
   'Draw how the springs share force or displacement; then choose k_parallel = sum k_i or 1/k_series = sum 1/k_i.',
   'Treating parallel springs as if their equivalent constant follows the series reciprocal rule.',
   '/learn/ap-physics-c-mechanics/unit-2/spring-forces'),
  ('ap_physics_c_mechanics', 2, '2.9', 'Resistive Forces', 'very-important', 'very-important',
   'Resistive forces depend on velocity and oppose motion, such as F_r = -kv. Newton''s second law becomes a differential equation for velocity.',
   'This calculus-only topic is live exam content. Separation of variables, exponential time behavior, and terminal velocity are central point-earning moves.',
   'You earn points by writing the net-force differential equation, separating variables with correct limits, solving for v(t) or a related quantity, and identifying terminal velocity from net force zero.',
   'Start with sum F = m dv/dt including the velocity-dependent force; then separate variables instead of using constant-acceleration kinematics.',
   'Using constant-acceleration equations when the net force depends on velocity.',
   '/learn/ap-physics-c-mechanics/unit-2/resistive-forces'),
  ('ap_physics_c_mechanics', 2, '2.10', 'Circular Motion', 'very-important', 'very-important',
   'Circular motion has centripetal acceleration v^2/r toward the center plus any tangential acceleration when speed changes. Forces or force components supply the inward net force.',
   'It ties force diagrams to curved motion, banked curves, conical pendulums, vertical loops, and circular orbits. Physics C does not carry the Physics 1 qualitative-only banked-friction cap.',
   'You earn points by drawing the FBD, resolving radial and tangential components, setting sum F_radial = mv^2/r, and using period/orbit relations only under their assumptions.',
   'Choose inward as the radial positive direction, then write the radial net-force equation separately from any tangential equation.',
   'Calling centripetal force a new force instead of the inward net force from real interactions.',
   '/learn/ap-physics-c-mechanics/unit-2/circular-motion')
),
explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  ('ap_physics_c_mechanics', 2, '2.1', 'Systems and Center of Mass',
   'System choice decides which interactions are internal and where the center-of-mass model applies. For continuous bodies, Physics C uses r_cm = integral r dm over integral dm, with dm built from a density function.',
   'Students need to decide whether the internal structure matters. If not, the system can be treated through its center of mass. For a nonuniform object, the center of mass is not automatically the geometric center; it follows the mass distribution.',
   'Points come from defining the system, choosing a coordinate, writing dm in terms of density and the integration variable, and using total mass in the denominator. For particles, the same logic becomes a mass-weighted sum.',
   'Draw the system boundary first; then choose a particle sum or r_cm = integral r dm over integral dm based on whether the mass is discrete or continuous.',
   'A thin rod has linear density lambda(x) that increases toward the right end. Where should the center-of-mass setup begin?',
   'Use the midpoint because a rod center of mass is always at L/2.',
   'Use x_cm = integral x dm over integral dm with dm = lambda(x) dx. Because the density increases toward the right, the center of mass will be right of the geometric midpoint. The setup must follow mass distribution, not just shape.',
   'Using a geometric midpoint as center of mass without checking the mass distribution.',
   'Back in practice, write the system boundary and dm expression before doing any center-of-mass algebra.'),
  ('ap_physics_c_mechanics', 2, '2.2', 'Forces and Free-Body Diagrams',
   'A free-body diagram represents real external forces exerted on one selected object or system. The arrows begin at the dot and point in the force direction; components are resolved later in equations, not drawn as extra forces.',
   'Students need to keep force diagrams tied to interactions. Gravity, normal force, tension, friction, spring force, and applied forces may appear, but motion arrows, acceleration arrows, or components are not additional forces on the FBD.',
   'Points come from selecting the object, drawing every real external force once, labeling forces clearly, and then choosing axes that simplify the component equations. Same-direction forces should be drawn side by side rather than overlapping.',
   'Choose the object, then draw one arrow for each external force on it before resolving components in equations.',
   'A block slides down a rough incline. Should the diagram include both gravity and the component of gravity down the ramp as separate arrows?',
   'Yes. The component down the ramp is a force that helps the block move.',
   'No. The FBD should show the gravitational force mg downward, plus normal and friction forces from the surface. Components of mg are mathematical parts used in the chosen axes; drawing them as additional forces double-counts gravity.',
   'Drawing component arrows on the FBD as if they were additional forces.',
   'In practice, draw forces first in physical directions, then make a separate component equation table.'),
  ('ap_physics_c_mechanics', 2, '2.3', 'Newton''s Third Law',
   'Third-law forces are equal and opposite forces on two different objects. When both objects are inside the selected system, those forces are internal and cancel from the system net external force.',
   'Students need to avoid confusing third-law pairs with balanced forces on one object. A force on object A and the partner force on object B cannot both belong on A''s free-body diagram. Physics C also permits reasoning about non-ideal strings where tension can vary along the string.',
   'Points come from naming the interaction pair precisely, assigning each force to the object it acts on, and using system boundaries to decide whether the pair affects center-of-mass motion.',
   'Name both objects in the interaction pair: force by A on B and force by B on A. Then decide whether each force is internal or external to the chosen system.',
   'A hand pulls a rope, and the rope pulls a cart. Where is the third-law partner to the rope-on-cart force?',
   'It is the cart weight because both act on the cart in different directions.',
   'The partner to the rope-on-cart force is the cart-on-rope force. The two forces act on different objects and are equal in magnitude and opposite in direction. The cart weight is a different interaction, between Earth and the cart.',
   'Putting both third-law forces on the same free-body diagram for one object.',
   'Back in practice, say "force of X on Y" for every force. The object after "on" tells you which FBD receives the arrow.'),
  ('ap_physics_c_mechanics', 2, '2.4', 'Newton''s First Law',
   'Newton''s first law is the zero-net-force condition for constant velocity in an inertial frame. Translational equilibrium is vector equilibrium: each component of net force that corresponds to zero acceleration must sum to zero.',
   'Students need to separate directions. An object can have no acceleration vertically while accelerating horizontally, so one force component equation can equal zero while another equals ma. The frame is assumed inertial unless a prompt says otherwise.',
   'Points come from linking zero acceleration to sum F = 0 along the relevant axis and avoiding claims that motion at constant speed necessarily means no forces act. Balanced forces can still be present.',
   'Check each axis separately: if acceleration is zero along that axis, write sum F for that axis equals zero.',
   'A cart accelerates horizontally while staying on a level track with no vertical motion. What should the vertical force equation say?',
   'There should be no vertical forces because the cart is moving horizontally.',
   'The vertical net force is zero, not the individual vertical forces. The normal force and weight can balance so sum F_y = 0 while the horizontal net force is nonzero and causes horizontal acceleration.',
   'Assuming an object moving at constant speed in one direction has zero net force in every direction.',
   'In practice, write acceleration components before force equations. Zero acceleration in one component licenses equilibrium only in that component.'),
  ('ap_physics_c_mechanics', 2, '2.5', 'Newton''s Second Law',
   'Newton''s second law connects the selected system net external force to center-of-mass acceleration. For constant mass in components, sum F_x = m a_x and sum F_y = m a_y.',
   'Students need to make every force equation refer to one object or one defined system. Constraints such as shared acceleration, pulley motion, or string length connect equations, but they do not let forces from different bodies be casually mixed.',
   'Points come from drawing the FBD, selecting axes, summing forces component by component, using the correct mass for that equation, and stating any acceleration constraints separately.',
   'After the FBD, write sum F_x = m a_x and sum F_y = m a_y for the same object or system; keep constraints on separate lines.',
   'Two blocks are connected by a light string. A student writes one equation using the pull on block A, friction on block B, and only the mass of block A. What is wrong?',
   'Nothing, because all the forces are part of the connected-block situation.',
   'A force equation must match a selected object or system. If the equation is for block A, use only forces on block A and mass A. If it is for both blocks as a system, use external forces on the two-block system and the total mass. Mixing forces from both blocks with one block mass breaks Newton''s second law.',
   'Mixing forces from different objects into one equation without defining a system.',
   'Back in practice, write the equation subject in the margin, such as "block A" or "two-block system," before summing forces.'),
  ('ap_physics_c_mechanics', 2, '2.6', 'Gravitational Force',
   'Gravity is an attractive interaction between masses. Near a surface it is often represented by weight mg; at larger scale it uses F = GMm/r^2 and field g = GM/r^2. Apparent weight is the normal force, not gravity itself.',
   'Students need to choose the model that matches the situation. Shell theorem results let spherical mass distributions act like point masses outside the sphere, give zero field inside a thin shell, and produce a linear restoring-force result inside a uniform sphere; proving the theorem is not required.',
   'Points come from identifying the two masses and separation, choosing force versus field, distinguishing normal force from weight, and applying spherical shell results only when the mass distribution supports them.',
   'Identify whether the question asks for force, field, weight, or apparent weight; then choose mg, GMm/r^2, or a shell-theorem result accordingly.',
   'A rider in an elevator accelerating upward says their apparent weight increased. Which force changed directly?',
   'Gravity increased because the rider feels heavier.',
   'The normal force from the floor increased. The rider''s gravitational force is still approximately mg near Earth, but apparent weight is the normal-force magnitude, which changes when the elevator accelerates.',
   'Treating apparent weight as always equal to gravitational force even when the object accelerates.',
   'In practice, label F_g and F_N separately. If the prompt says scale reading or apparent weight, look for the normal force.'),
  ('ap_physics_c_mechanics', 2, '2.7', 'Kinetic and Static Friction',
   'Kinetic friction has a fixed model while sliding, F_k = mu_k F_N. Static friction is adjustable, F_s <= mu_s F_N, and reaches mu_s F_N only at the threshold of slipping.',
   'Students need to infer direction and magnitude from motion or impending motion. The 2025 Mechanics guidance flags the max-static-friction assumption as a real scoring failure: static friction is often whatever value is needed up to its maximum.',
   'Points come from identifying kinetic versus static contact, solving for static friction when there is no slipping, checking against the maximum, and using kinetic friction only after sliding occurs.',
   'Ask whether the surfaces slide. If not, solve for the static friction needed first, then compare it to mu_s F_N only as a limit.',
   'A block rests on a rough horizontal surface while a small horizontal force P is applied and the block does not move. What is the static friction magnitude?',
   'It is always mu_s F_N because the block is static.',
   'The static friction magnitude is P, opposite the applied force, as long as P <= mu_s F_N. The expression mu_s F_N is the maximum possible static friction, not the value automatically present.',
   'Setting F_s = mu_s F_N in every static-friction problem.',
   'Back in practice, write "needed static friction" first, then compare it with "maximum static friction."'),
  ('ap_physics_c_mechanics', 2, '2.8', 'Spring Forces',
   'An ideal spring exerts a restoring force proportional to displacement from equilibrium: F_s = -k Delta x. Equivalent spring constants depend on whether springs share the same displacement in parallel or the same force in series.',
   'Students need to identify the arrangement before using formulas. Parallel springs add stiffness directly; series springs combine by reciprocal sum. Mixed series-and-parallel equivalent constants are outside the expected scope for this topic.',
   'Points come from choosing the equilibrium displacement, assigning restoring direction, identifying pure series or pure parallel structure, and avoiding formula swapping between arrangements.',
   'Draw how the springs share force or displacement; then choose k_parallel = sum k_i or 1/k_series = sum 1/k_i.',
   'Two identical springs pull on the same block side by side so both stretch by the same amount. What is the equivalent spring constant?',
   'Use the series formula, so the equivalent constant is k/2.',
   'The springs are in parallel because they share the same displacement and their forces add. The equivalent constant is k_eq = k + k = 2k. The reciprocal formula belongs to springs in series, where the same force passes through each spring.',
   'Treating parallel springs as if their equivalent constant follows the series reciprocal rule.',
   'In practice, ask what is shared: same stretch points to parallel; same force through each spring points to series.'),
  ('ap_physics_c_mechanics', 2, '2.9', 'Resistive Forces',
   'A resistive force depends on velocity and points opposite motion, so Newton''s second law becomes a differential equation such as m dv/dt = mg - kv. The solution often approaches terminal velocity exponentially.',
   'Students need to abandon constant-acceleration shortcuts. Because the force changes as velocity changes, acceleration changes too. Separation of variables with correct limits is the point-earning route for many Physics C resistive-force prompts.',
   'Points come from writing the force law with signs, forming the differential equation, separating variables, integrating over the actual initial and final values, and finding terminal velocity from net force zero.',
   'Start with sum F = m dv/dt including the velocity-dependent force; then separate variables instead of using constant-acceleration kinematics.',
   'An object falls downward with resistive force magnitude kv upward. Why should constant-acceleration kinematics not be used for v(t)?',
   'Because gravity is constant, the acceleration is constant, so kinematics works.',
   'The net force is mg - kv, so as v changes the net force and acceleration change. The correct setup is m dv/dt = mg - kv, then separation of variables. Terminal velocity occurs when mg - kv = 0.',
   'Using constant-acceleration equations when the net force depends on velocity.',
   'Back in practice, if a force contains v, write a differential equation before thinking about kinematics equations.'),
  ('ap_physics_c_mechanics', 2, '2.10', 'Circular Motion',
   'Circular motion requires inward centripetal acceleration v^2/r plus any tangential acceleration when speed changes. The inward net force is supplied by real forces or components of real forces, not by a separate centripetal force.',
   'Students need to choose radial and tangential axes. Banked curves, conical pendulums, vertical loops, and circular orbits all use the same radial-force idea, but the force supplying the radial net force changes by situation.',
   'Points come from drawing the FBD, resolving real forces into radial and tangential components, writing sum F_radial = mv^2/r, and keeping Kepler first and second laws out of required reasoning.',
   'Choose inward as the radial positive direction, then write the radial net-force equation separately from any tangential equation.',
   'A car moves around a flat circular track. What force provides the centripetal acceleration if the tires do not slip?',
   'There is a centripetal force in addition to friction, pointing toward the center.',
   'Static friction is the real horizontal force that points toward the center and supplies the radial net force. The equation is sum F_radial = f_s = mv^2/r, with f_s limited by mu_s F_N. Centripetal force is not an extra interaction.',
   'Calling centripetal force a new force instead of the inward net force from real interactions.',
   'In practice, circle the real force or component that points inward before writing mv^2/r.')
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 2 Force and Translational Dynamics; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 2: system boundaries, discrete and continuous center of mass, FBD arrow conventions, Newton third-law pairs and massive-string tension, translational equilibrium, Newton second law component equations, universal gravitation, gravitational field, apparent weight, shell-theorem results, kinetic friction equality, static friction inequality, spring forces and series/parallel equivalent constants, resistive-force differential equations and terminal velocity, circular-motion radial/tangential equations, vertical-loop minimum speed, circular Kepler relation, and no Physics 1-style qualitative-only banked-friction cap; batch 2026-08-25-ap-physics-c-mechanics-unit2-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_physics_c_mechanics', 2, '2.1', 'Systems and Center of Mass',
   'System choice decides which interactions are internal and where the center-of-mass model applies. For continuous bodies, Physics C uses r_cm = integral r dm over integral dm, with dm built from a density function.',
   'Students need to decide whether the internal structure matters. If not, the system can be treated through its center of mass. For a nonuniform object, the center of mass is not automatically the geometric center; it follows the mass distribution.',
   'Points come from defining the system, choosing a coordinate, writing dm in terms of density and the integration variable, and using total mass in the denominator. For particles, the same logic becomes a mass-weighted sum.',
   'Draw the system boundary first; then choose a particle sum or r_cm = integral r dm over integral dm based on whether the mass is discrete or continuous.',
   'A thin rod has linear density lambda(x) that increases toward the right end. Where should the center-of-mass setup begin?',
   'Use the midpoint because a rod center of mass is always at L/2.',
   'Use x_cm = integral x dm over integral dm with dm = lambda(x) dx. Because the density increases toward the right, the center of mass will be right of the geometric midpoint. The setup must follow mass distribution, not just shape.',
   'Using a geometric midpoint as center of mass without checking the mass distribution.',
   'Back in practice, write the system boundary and dm expression before doing any center-of-mass algebra.'),
  ('ap_physics_c_mechanics', 2, '2.2', 'Forces and Free-Body Diagrams',
   'A free-body diagram represents real external forces exerted on one selected object or system. The arrows begin at the dot and point in the force direction; components are resolved later in equations, not drawn as extra forces.',
   'Students need to keep force diagrams tied to interactions. Gravity, normal force, tension, friction, spring force, and applied forces may appear, but motion arrows, acceleration arrows, or components are not additional forces on the FBD.',
   'Points come from selecting the object, drawing every real external force once, labeling forces clearly, and then choosing axes that simplify the component equations. Same-direction forces should be drawn side by side rather than overlapping.',
   'Choose the object, then draw one arrow for each external force on it before resolving components in equations.',
   'A block slides down a rough incline. Should the diagram include both gravity and the component of gravity down the ramp as separate arrows?',
   'Yes. The component down the ramp is a force that helps the block move.',
   'No. The FBD should show the gravitational force mg downward, plus normal and friction forces from the surface. Components of mg are mathematical parts used in the chosen axes; drawing them as additional forces double-counts gravity.',
   'Drawing component arrows on the FBD as if they were additional forces.',
   'In practice, draw forces first in physical directions, then make a separate component equation table.'),
  ('ap_physics_c_mechanics', 2, '2.3', 'Newton''s Third Law',
   'Third-law forces are equal and opposite forces on two different objects. When both objects are inside the selected system, those forces are internal and cancel from the system net external force.',
   'Students need to avoid confusing third-law pairs with balanced forces on one object. A force on object A and the partner force on object B cannot both belong on A''s free-body diagram. Physics C also permits reasoning about non-ideal strings where tension can vary along the string.',
   'Points come from naming the interaction pair precisely, assigning each force to the object it acts on, and using system boundaries to decide whether the pair affects center-of-mass motion.',
   'Name both objects in the interaction pair: force by A on B and force by B on A. Then decide whether each force is internal or external to the chosen system.',
   'A hand pulls a rope, and the rope pulls a cart. Where is the third-law partner to the rope-on-cart force?',
   'It is the cart weight because both act on the cart in different directions.',
   'The partner to the rope-on-cart force is the cart-on-rope force. The two forces act on different objects and are equal in magnitude and opposite in direction. The cart weight is a different interaction, between Earth and the cart.',
   'Putting both third-law forces on the same free-body diagram for one object.',
   'Back in practice, say "force of X on Y" for every force. The object after "on" tells you which FBD receives the arrow.'),
  ('ap_physics_c_mechanics', 2, '2.4', 'Newton''s First Law',
   'Newton''s first law is the zero-net-force condition for constant velocity in an inertial frame. Translational equilibrium is vector equilibrium: each component of net force that corresponds to zero acceleration must sum to zero.',
   'Students need to separate directions. An object can have no acceleration vertically while accelerating horizontally, so one force component equation can equal zero while another equals ma. The frame is assumed inertial unless a prompt says otherwise.',
   'Points come from linking zero acceleration to sum F = 0 along the relevant axis and avoiding claims that motion at constant speed necessarily means no forces act. Balanced forces can still be present.',
   'Check each axis separately: if acceleration is zero along that axis, write sum F for that axis equals zero.',
   'A cart accelerates horizontally while staying on a level track with no vertical motion. What should the vertical force equation say?',
   'There should be no vertical forces because the cart is moving horizontally.',
   'The vertical net force is zero, not the individual vertical forces. The normal force and weight can balance so sum F_y = 0 while the horizontal net force is nonzero and causes horizontal acceleration.',
   'Assuming an object moving at constant speed in one direction has zero net force in every direction.',
   'In practice, write acceleration components before force equations. Zero acceleration in one component licenses equilibrium only in that component.'),
  ('ap_physics_c_mechanics', 2, '2.5', 'Newton''s Second Law',
   'Newton''s second law connects the selected system net external force to center-of-mass acceleration. For constant mass in components, sum F_x = m a_x and sum F_y = m a_y.',
   'Students need to make every force equation refer to one object or one defined system. Constraints such as shared acceleration, pulley motion, or string length connect equations, but they do not let forces from different bodies be casually mixed.',
   'Points come from drawing the FBD, selecting axes, summing forces component by component, using the correct mass for that equation, and stating any acceleration constraints separately.',
   'After the FBD, write sum F_x = m a_x and sum F_y = m a_y for the same object or system; keep constraints on separate lines.',
   'Two blocks are connected by a light string. A student writes one equation using the pull on block A, friction on block B, and only the mass of block A. What is wrong?',
   'Nothing, because all the forces are part of the connected-block situation.',
   'A force equation must match a selected object or system. If the equation is for block A, use only forces on block A and mass A. If it is for both blocks as a system, use external forces on the two-block system and the total mass. Mixing forces from both blocks with one block mass breaks Newton''s second law.',
   'Mixing forces from different objects into one equation without defining a system.',
   'Back in practice, write the equation subject in the margin, such as "block A" or "two-block system," before summing forces.'),
  ('ap_physics_c_mechanics', 2, '2.6', 'Gravitational Force',
   'Gravity is an attractive interaction between masses. Near a surface it is often represented by weight mg; at larger scale it uses F = GMm/r^2 and field g = GM/r^2. Apparent weight is the normal force, not gravity itself.',
   'Students need to choose the model that matches the situation. Shell theorem results let spherical mass distributions act like point masses outside the sphere, give zero field inside a thin shell, and produce a linear restoring-force result inside a uniform sphere; proving the theorem is not required.',
   'Points come from identifying the two masses and separation, choosing force versus field, distinguishing normal force from weight, and applying spherical shell results only when the mass distribution supports them.',
   'Identify whether the question asks for force, field, weight, or apparent weight; then choose mg, GMm/r^2, or a shell-theorem result accordingly.',
   'A rider in an elevator accelerating upward says their apparent weight increased. Which force changed directly?',
   'Gravity increased because the rider feels heavier.',
   'The normal force from the floor increased. The rider''s gravitational force is still approximately mg near Earth, but apparent weight is the normal-force magnitude, which changes when the elevator accelerates.',
   'Treating apparent weight as always equal to gravitational force even when the object accelerates.',
   'In practice, label F_g and F_N separately. If the prompt says scale reading or apparent weight, look for the normal force.'),
  ('ap_physics_c_mechanics', 2, '2.7', 'Kinetic and Static Friction',
   'Kinetic friction has a fixed model while sliding, F_k = mu_k F_N. Static friction is adjustable, F_s <= mu_s F_N, and reaches mu_s F_N only at the threshold of slipping.',
   'Students need to infer direction and magnitude from motion or impending motion. The 2025 Mechanics guidance flags the max-static-friction assumption as a real scoring failure: static friction is often whatever value is needed up to its maximum.',
   'Points come from identifying kinetic versus static contact, solving for static friction when there is no slipping, checking against the maximum, and using kinetic friction only after sliding occurs.',
   'Ask whether the surfaces slide. If not, solve for the static friction needed first, then compare it to mu_s F_N only as a limit.',
   'A block rests on a rough horizontal surface while a small horizontal force P is applied and the block does not move. What is the static friction magnitude?',
   'It is always mu_s F_N because the block is static.',
   'The static friction magnitude is P, opposite the applied force, as long as P <= mu_s F_N. The expression mu_s F_N is the maximum possible static friction, not the value automatically present.',
   'Setting F_s = mu_s F_N in every static-friction problem.',
   'Back in practice, write "needed static friction" first, then compare it with "maximum static friction."'),
  ('ap_physics_c_mechanics', 2, '2.8', 'Spring Forces',
   'An ideal spring exerts a restoring force proportional to displacement from equilibrium: F_s = -k Delta x. Equivalent spring constants depend on whether springs share the same displacement in parallel or the same force in series.',
   'Students need to identify the arrangement before using formulas. Parallel springs add stiffness directly; series springs combine by reciprocal sum. Mixed series-and-parallel equivalent constants are outside the expected scope for this topic.',
   'Points come from choosing the equilibrium displacement, assigning restoring direction, identifying pure series or pure parallel structure, and avoiding formula swapping between arrangements.',
   'Draw how the springs share force or displacement; then choose k_parallel = sum k_i or 1/k_series = sum 1/k_i.',
   'Two identical springs pull on the same block side by side so both stretch by the same amount. What is the equivalent spring constant?',
   'Use the series formula, so the equivalent constant is k/2.',
   'The springs are in parallel because they share the same displacement and their forces add. The equivalent constant is k_eq = k + k = 2k. The reciprocal formula belongs to springs in series, where the same force passes through each spring.',
   'Treating parallel springs as if their equivalent constant follows the series reciprocal rule.',
   'In practice, ask what is shared: same stretch points to parallel; same force through each spring points to series.'),
  ('ap_physics_c_mechanics', 2, '2.9', 'Resistive Forces',
   'A resistive force depends on velocity and points opposite motion, so Newton''s second law becomes a differential equation such as m dv/dt = mg - kv. The solution often approaches terminal velocity exponentially.',
   'Students need to abandon constant-acceleration shortcuts. Because the force changes as velocity changes, acceleration changes too. Separation of variables with correct limits is the point-earning route for many Physics C resistive-force prompts.',
   'Points come from writing the force law with signs, forming the differential equation, separating variables, integrating over the actual initial and final values, and finding terminal velocity from net force zero.',
   'Start with sum F = m dv/dt including the velocity-dependent force; then separate variables instead of using constant-acceleration kinematics.',
   'An object falls downward with resistive force magnitude kv upward. Why should constant-acceleration kinematics not be used for v(t)?',
   'Because gravity is constant, the acceleration is constant, so kinematics works.',
   'The net force is mg - kv, so as v changes the net force and acceleration change. The correct setup is m dv/dt = mg - kv, then separation of variables. Terminal velocity occurs when mg - kv = 0.',
   'Using constant-acceleration equations when the net force depends on velocity.',
   'Back in practice, if a force contains v, write a differential equation before thinking about kinematics equations.'),
  ('ap_physics_c_mechanics', 2, '2.10', 'Circular Motion',
   'Circular motion requires inward centripetal acceleration v^2/r plus any tangential acceleration when speed changes. The inward net force is supplied by real forces or components of real forces, not by a separate centripetal force.',
   'Students need to choose radial and tangential axes. Banked curves, conical pendulums, vertical loops, and circular orbits all use the same radial-force idea, but the force supplying the radial net force changes by situation.',
   'Points come from drawing the FBD, resolving real forces into radial and tangential components, writing sum F_radial = mv^2/r, and keeping Kepler first and second laws out of required reasoning.',
   'Choose inward as the radial positive direction, then write the radial net-force equation separately from any tangential equation.',
   'A car moves around a flat circular track. What force provides the centripetal acceleration if the tires do not slip?',
   'There is a centripetal force in addition to friction, pointing toward the center.',
   'Static friction is the real horizontal force that points toward the center and supplies the radial net force. The equation is sum F_radial = f_s = mv^2/r, with f_s limited by mu_s F_N. Centripetal force is not an extra interaction.',
   'Calling centripetal force a new force instead of the inward net force from real interactions.',
   'In practice, circle the real force or component that points inward before writing mv^2/r.')
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 2 Force and Translational Dynamics; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 2: system boundaries, discrete and continuous center of mass, FBD arrow conventions, Newton third-law pairs and massive-string tension, translational equilibrium, Newton second law component equations, universal gravitation, gravitational field, apparent weight, shell-theorem results, kinetic friction equality, static friction inequality, spring forces and series/parallel equivalent constants, resistive-force differential equations and terminal velocity, circular-motion radial/tangential equations, vertical-loop minimum speed, circular Kepler relation, and no Physics 1-style qualitative-only banked-friction cap; batch 2026-08-25-ap-physics-c-mechanics-unit2-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 2
    and topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9', '2.10')
    and status = 'published';

  if v_briefs <> 10 then
    raise exception 'expected 10 published AP Physics C:Mechanics Unit 2 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_c_mechanics'
    and unit_number = 2
    and topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9', '2.10')
    and status = 'published';

  if v_explainers <> 10 then
    raise exception 'expected 10 published AP Physics C:Mechanics Unit 2 explainers, got %', v_explainers;
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
      and b.unit_number = 2
      and b.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9', '2.10')
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
      and e.unit_number = 2
      and e.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9', '2.10')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 2 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9', '2.10')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 2 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.unit_number = 2
    and b.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9', '2.10')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-c-mechanics/unit-2/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 2 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9', '2.10')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 2 core_idea/what_it_is matches, got %', v_core_matches;
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
      and unit_number = 2
      and topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9', '2.10')
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
      and e.unit_number = 2
      and e.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9', '2.10')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 2 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
