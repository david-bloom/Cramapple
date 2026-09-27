begin;

-- Add AP Physics 1 Unit 2 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 9 AP Physics 1 Unit 2 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_1_CED_FACT_PACK.md Unit 2 (Force and
-- Translational Dynamics). The fact pack confirms systems and center of mass,
-- FBD conventions, Newton's laws, gravitational force/field/apparent weight,
-- kinetic and static friction, Hooke's-law spring forces, and circular motion.
-- Physics 1 boundaries preserved here: center-of-mass calculations are capped
-- to five or fewer particles or high symmetry; FBDs show forces, not force
-- components; massive-string tension is qualitative only; action-at-distance
-- forces are gravity-only; banked curves with friction are qualitative only;
-- Kepler's first and second laws are out of scope.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_physics_1', 2, '2.1', 'Systems and Center of Mass', 'very-important', 'very-important',
   'A system is the selected object or group of objects. Center of mass is the mass-weighted average position of that system.',
   'System choice decides which forces are internal and whether the motion can be modeled through the center of mass. AP Physics 1 keeps center-of-mass calculations limited in scope.',
   'You earn points by defining the system, using mass-weighted position sums, and staying within the five-particle or high-symmetry center-of-mass boundary.',
   'Draw the system boundary first, then write the center-of-mass sum with each mass and position that belongs inside the system.',
   'Using the geometric middle as center of mass without checking where the mass is located.',
   '/learn/ap-physics-1/unit-2/systems-and-center-of-mass'),
  ('ap_physics_1', 2, '2.2', 'Forces and Free-Body Diagrams', 'very-important', 'very-important',
   'A free-body diagram shows the real forces exerted on one object, drawn as arrows from the object dot. Components are not drawn as extra force arrows.',
   'Good force diagrams drive every dynamics equation. Missing forces, extra component arrows, or arrows in the wrong direction can make later reasoning impossible.',
   'You earn points by choosing the object, drawing each external force once, labeling forces clearly, and resolving components only after the FBD is complete.',
   'Start with the object dot and draw only real forces on that object; make component equations separately.',
   'Drawing both a force and its components on the FBD, which double-counts the interaction.',
   '/learn/ap-physics-1/unit-2/forces-and-free-body-diagrams'),
  ('ap_physics_1', 2, '2.3', 'Newton''s Third Law', 'very-important', 'very-important',
   'Newton''s third law pairs are equal-magnitude, opposite-direction forces exerted on different objects in the same interaction.',
   'It prevents two common mistakes: putting both partner forces on one object diagram and treating internal forces as changing system center-of-mass motion.',
   'You earn points by naming force pairs as A on B and B on A, assigning each force to the object it acts on, and identifying internal versus external forces for a system.',
   'Write the two object names in every interaction pair before deciding which free-body diagram receives each force.',
   'Putting both action-reaction forces on the same free-body diagram.',
   '/learn/ap-physics-1/unit-2/newtons-third-law'),
  ('ap_physics_1', 2, '2.4', 'Newton''s First Law', 'very-important', 'very-important',
   'Newton''s first law says velocity is constant when net force is zero in an inertial frame. Equilibrium can apply in one direction while another direction accelerates.',
   'It connects balanced forces to constant velocity, not just to rest. It also supports separate horizontal and vertical force reasoning.',
   'You earn points by linking zero acceleration to zero net force along the relevant axis and by not erasing balanced forces that still act on the object.',
   'Check acceleration component by component; if acceleration is zero along an axis, set the net force along that axis to zero.',
   'Saying there are no forces because the object moves with constant velocity.',
   '/learn/ap-physics-1/unit-2/newtons-first-law'),
  ('ap_physics_1', 2, '2.5', 'Newton''s Second Law', 'very-important', 'very-important',
   'Newton''s second law connects net force to acceleration: a_sys = F_net/m_sys. The force sum must match the object or system mass in the equation.',
   'It is the main model for translational dynamics. Correct equations require one object or one clearly defined system at a time.',
   'You earn points by drawing the FBD, writing component net-force equations for the selected object or system, and using constraints only on separate lines.',
   'After the FBD, write sum F = ma for the same object or system named in the diagram.',
   'Mixing forces from different objects into one equation without using the total system mass.',
   '/learn/ap-physics-1/unit-2/newtons-second-law'),
  ('ap_physics_1', 2, '2.6', 'Gravitational Force', 'very-important', 'very-important',
   'Gravitational force is attractive, acts along the line between centers of mass, and can be modeled as F_g = Gm1m2/r^2 or as weight mg near Earth.',
   'This topic connects weight, gravitational field, apparent weight, and planetary comparisons. Apparent weight is the normal force, not gravity itself.',
   'You earn points by distinguishing force, field, weight, and apparent weight, using the correct masses and separation, and remembering that larger planet mass increases g at the same radius.',
   'Identify what the question asks for: gravitational force, gravitational field, weight, or apparent weight; then choose the matching equation.',
   'Confusing mass with weight or treating apparent weight as always equal to mg.',
   '/learn/ap-physics-1/unit-2/gravitational-force'),
  ('ap_physics_1', 2, '2.7', 'Kinetic and Static Friction', 'very-important', 'very-important',
   'Kinetic friction is mu_k F_N while surfaces slide. Static friction adjusts up to a maximum, so F_s is less than or equal to mu_s F_N.',
   'Friction questions often turn on whether surfaces are sliding, about to slide, or staying at rest relative to each other. Static friction is not automatically maximum.',
   'You earn points by deciding kinetic versus static contact, setting kinetic friction as an equality, solving for needed static friction first, and checking it against its maximum.',
   'Ask whether the surfaces slide; if they do not, solve for the static friction needed before comparing to mu_s F_N.',
   'Setting static friction equal to mu_s F_N whenever the object is not moving.',
   '/learn/ap-physics-1/unit-2/kinetic-and-static-friction'),
  ('ap_physics_1', 2, '2.8', 'Spring Forces', 'very-important', 'somewhat-important',
   'An ideal spring exerts a restoring force F_s = -k Delta x, directed toward the spring-system equilibrium position.',
   'Spring force is the force model that later supports energy and oscillation reasoning. Direction matters because the spring force points opposite displacement from equilibrium.',
   'You earn points by measuring displacement from equilibrium, using the spring constant, and assigning the restoring direction before writing force equations.',
   'Mark equilibrium first, then draw the spring force back toward equilibrium and use magnitude k Delta x in the force equation.',
   'Using total spring length instead of displacement from equilibrium.',
   '/learn/ap-physics-1/unit-2/spring-forces'),
  ('ap_physics_1', 2, '2.9', 'Circular Motion', 'very-important', 'very-important',
   'Circular motion has centripetal acceleration v^2/r toward the center. Real forces or force components provide the inward net force.',
   'This topic covers vertical loops, banked curves, conical pendulums, and circular orbits. It replaces the old standalone circular-motion-and-gravitation unit label.',
   'You earn points by drawing real forces on the FBD, choosing inward as radial, writing sum F_radial = mv^2/r, and not drawing centripetal force as an extra force.',
   'Draw the FBD first, then choose inward as positive and identify which real force or component supplies the radial net force.',
   'Adding a separate centripetal-force arrow to the FBD instead of using real forces.',
   '/learn/ap-physics-1/unit-2/circular-motion')
),
explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  ('ap_physics_1', 2, '2.1', 'Systems and Center of Mass',
   'A system boundary tells you what objects are being modeled together. Center of mass is the mass-weighted average position of that system, so it shifts toward larger masses or clusters of mass.',
   'Students need to know that AP Physics 1 center-of-mass calculations are limited to systems of five or fewer particles in two dimensions or highly symmetrical systems. The point is not advanced integration; it is choosing the system and weighting positions by mass.',
   'Points come from naming the system, including only masses in that system, and writing x_cm = sum m_i x_i over sum m_i or the matching y expression. Qualitative answers should say which side has more mass or farther mass.',
   'Draw the system boundary first, then write the center-of-mass sum with each mass and position that belongs inside the system.',
   'Two carts of equal mass are at x = 0 m and x = 6 m. A third equal-mass cart is at x = 6 m. Where is the center of mass?',
   'It is at x = 3 m because the endpoints are 0 m and 6 m.',
   'It is at x = 4 m. Use the mass-weighted average: (m(0)+m(6)+m(6))/(3m)=4 m. The center of mass shifts toward the side with more mass, so the geometric midpoint is not enough.',
   'Using the geometric middle as center of mass without checking where the mass is located.',
   'Back in practice, list each mass position before averaging. If one side has more mass, expect the center of mass to move toward that side.'),
  ('ap_physics_1', 2, '2.2', 'Forces and Free-Body Diagrams',
   'A free-body diagram is a force inventory for one object. It should show each real external force once as a straight arrow from the dot, while components are saved for the equations.',
   'Students need to separate physical forces from mathematical components. Gravity, normal force, friction, tension, spring force, and applied forces can appear. Velocity, acceleration, kinetic energy, momentum, and force components are not separate FBD forces.',
   'Points come from choosing the object, drawing each force in its physical direction, and avoiding extra arrows. A correct FBD often earns credit before any equation is written.',
   'Start with the object dot and draw only real forces on that object; make component equations separately.',
   'A block on an incline has weight mg. Should the FBD also include mg sin(theta) down the ramp as another force?',
   'Yes, because mg sin(theta) is the force pulling the block down the ramp.',
   'No. Draw the full weight mg downward, plus normal force and friction if present. The component mg sin(theta) is part of resolving the weight into axes; drawing it as another arrow double-counts gravity.',
   'Drawing both a force and its components on the FBD, which double-counts the interaction.',
   'In practice, finish the FBD before drawing components. Components belong beside equations, not as extra forces on the dot.'),
  ('ap_physics_1', 2, '2.3', 'Newton''s Third Law',
   'Newton''s third law pairs are two forces from one interaction: A on B and B on A. They are equal in magnitude and opposite in direction, but they act on different objects.',
   'Students need to avoid using third-law pairs as if they cancel on one object. They cancel only when both objects are inside the chosen system and the pair is internal. For AP Physics 1, massive-string tension is described qualitatively rather than calculated in detail.',
   'Points come from naming both objects, assigning each force to the object it acts on, and using system boundaries to decide whether the pair belongs inside or outside a net-force equation.',
   'Write the two object names in every interaction pair before deciding which free-body diagram receives each force.',
   'A book pushes down on a table. What is the third-law partner force?',
   'The weight of the book, because both forces act downward or upward around the book.',
   'The partner is the table pushing up on the book. The book-on-table force and table-on-book force are equal and opposite and act on different objects. The book weight is Earth pulling on the book, a different interaction.',
   'Putting both action-reaction forces on the same free-body diagram.',
   'Back in practice, phrase every force as "force by ___ on ___." Third-law partners swap the two blanks.'),
  ('ap_physics_1', 2, '2.4', 'Newton''s First Law',
   'Newton''s first law says constant velocity requires zero net force in an inertial frame. Zero net force can coexist with real forces if they balance.',
   'Students need to think component by component. A block can have vertical force balance while accelerating horizontally, or horizontal force balance while moving at constant horizontal velocity. Rest is just the zero-speed case of constant velocity.',
   'Points come from connecting zero acceleration to sum F = 0 along the relevant direction and explaining that balanced forces do not disappear. If acceleration is nonzero, first-law equilibrium does not apply in that direction.',
   'Check acceleration component by component; if acceleration is zero along an axis, set the net force along that axis to zero.',
   'A sled moves right at constant velocity on level ground while being pulled. What must be true about the horizontal forces?',
   'There are no horizontal forces because the velocity is constant.',
   'The net horizontal force is zero. The pulling force can be balanced by friction, so the sled continues at constant velocity. Constant velocity means balanced forces, not no forces.',
   'Saying there are no forces because the object moves with constant velocity.',
   'In practice, write whether acceleration is zero before discussing forces. Constant velocity points to net force zero, not force absence.'),
  ('ap_physics_1', 2, '2.5', 'Newton''s Second Law',
   'Newton''s second law is a system-matched statement: the net external force on the selected object or system equals that object or system mass times its acceleration.',
   'Students need to keep force equations organized. A force on block A belongs in block A equation; a force on the two-block system belongs in the system equation. Constraints can connect accelerations, but they do not merge unrelated force lists.',
   'Points come from drawing the FBD, choosing axes, summing forces by component, and matching the mass and acceleration to the same selected object or system.',
   'After the FBD, write sum F = ma for the same object or system named in the diagram.',
   'Two connected blocks accelerate together. A student writes friction on block B and tension on block A but multiplies only by mass A. What is the issue?',
   'That is fine because the blocks are connected and share an acceleration.',
   'The equation mixes objects. If the equation is for block A, use forces on block A and mass A. If it is for both blocks, use external forces on both blocks and total mass. Shared acceleration is a constraint, not permission to mix force lists.',
   'Mixing forces from different objects into one equation without using the total system mass.',
   'Back in practice, label each force equation with its object or system before substituting mass.'),
  ('ap_physics_1', 2, '2.6', 'Gravitational Force',
   'Gravity can be modeled as a force between masses or as a field. Near Earth, weight is mg; apparent weight is the normal-force magnitude a scale would read.',
   'Students need to distinguish mass, weight, gravitational field, and normal force. The fact that an object feels heavier or lighter in an accelerating elevator means the normal force changed, not that its mass changed.',
   'Points come from using F_g = Gm1m2/r^2 or mg in the right context, using g = F_g/m as field strength, and explaining apparent weight through the normal force.',
   'Identify what the question asks for: gravitational force, gravitational field, weight, or apparent weight; then choose the matching equation.',
   'A student says a planet with more mass must have a smaller gravitational field because g = F_g/m. What is wrong?',
   'The equation shows dividing by mass makes g smaller when planet mass gets larger.',
   'The m in g = F_g/m is the test object mass, not the planet mass. For a planet, g = GM/r^2, so increasing planet mass M at the same radius increases gravitational field strength. Do not confuse object mass, planet mass, and weight.',
   'Confusing mass with weight or treating apparent weight as always equal to mg.',
   'In practice, label which mass belongs to the planet and which belongs to the object before using a gravity equation.'),
  ('ap_physics_1', 2, '2.7', 'Kinetic and Static Friction',
   'Kinetic friction has a fixed model during sliding, while static friction adjusts to prevent slipping up to a maximum. Static friction equals mu_s F_N only at the threshold of slipping.',
   'Students need to infer both direction and size from the contact condition. Static friction can be less than its maximum or even zero if no tangential slipping tendency exists.',
   'Points come from identifying sliding versus non-sliding contact, using F_k = mu_k F_N for kinetic friction, solving for needed static friction, and comparing it with F_s,max = mu_s F_N.',
   'Ask whether the surfaces slide; if they do not, solve for the static friction needed before comparing to mu_s F_N.',
   'A box stays at rest while a small horizontal push P is applied. What is the static friction magnitude if P is below the slipping threshold?',
   'It is mu_s F_N because the box is static.',
   'It is P, opposite the push. Static friction adjusts to whatever value is needed to prevent slipping, up to the maximum mu_s F_N. The maximum is a limit, not the automatic value.',
   'Setting static friction equal to mu_s F_N whenever the object is not moving.',
   'Back in practice, write "needed F_s" and "maximum F_s" as two separate quantities.'),
  ('ap_physics_1', 2, '2.8', 'Spring Forces',
   'A spring force is a restoring force: it points toward equilibrium and has magnitude k times the displacement from equilibrium.',
   'Students need to measure stretch or compression relative to equilibrium, not total length. The sign in F_s = -k Delta x means the force opposes displacement from equilibrium.',
   'Points come from identifying equilibrium, finding Delta x, drawing the restoring force in the correct direction, and using the spring force in a net-force equation when dynamics are involved.',
   'Mark equilibrium first, then draw the spring force back toward equilibrium and use magnitude k Delta x in the force equation.',
   'A spring is stretched to the right from equilibrium. Which way does the spring force on the object point?',
   'To the right, because the spring has been stretched to the right.',
   'The spring force points left, back toward equilibrium. A spring force is restoring: when displacement is to the right, the force is in the opposite direction.',
   'Using total spring length instead of displacement from equilibrium.',
   'In practice, draw the equilibrium position as a reference mark before deciding the force direction.'),
  ('ap_physics_1', 2, '2.9', 'Circular Motion',
   'Circular motion needs inward centripetal acceleration v^2/r. The inward net force comes from real forces such as tension, gravity, normal force, or friction; centripetal force is not an extra force.',
   'Students need to draw the FBD before writing mv^2/r. At the top of a vertical loop, both gravity and the normal force can point toward the center, which means the normal force points downward there.',
   'Points come from identifying the center direction, resolving real forces radially, writing sum F_radial = mv^2/r, and respecting AP Physics 1 limits on banked curves with friction and Kepler laws.',
   'Draw the FBD first, then choose inward as positive and identify which real force or component supplies the radial net force.',
   'At the top of a vertical loop, which way does the normal force on the object point if the track is pushing on it?',
   'Upward, because normal force usually points up from a surface.',
   'Downward, toward the center of the loop. The normal force is perpendicular to the track surface and points from the track toward the object; at the top, the center is below the object, so the normal force and gravity can both point inward.',
   'Adding a separate centripetal-force arrow to the FBD instead of using real forces.',
   'Back in practice, mark the center of the circle before drawing forces. Then check which real forces point inward.')
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 2 Force and Translational Dynamics; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 2: system boundaries and center of mass, FBD force-arrow convention, Newton third-law pairs, translational equilibrium, Newton second law, gravitational force/field/weight/apparent weight, kinetic friction equality, static friction inequality, Hooke spring force, circular-motion radial/tangential acceleration, vertical-loop normal-force misconception, banked-curve friction qualitative-only boundary, and Kepler first/second law exclusion; batch 2026-08-25-ap-physics-1-unit2-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_physics_1', 2, '2.1', 'Systems and Center of Mass',
   'A system boundary tells you what objects are being modeled together. Center of mass is the mass-weighted average position of that system, so it shifts toward larger masses or clusters of mass.',
   'Students need to know that AP Physics 1 center-of-mass calculations are limited to systems of five or fewer particles in two dimensions or highly symmetrical systems. The point is not advanced integration; it is choosing the system and weighting positions by mass.',
   'Points come from naming the system, including only masses in that system, and writing x_cm = sum m_i x_i over sum m_i or the matching y expression. Qualitative answers should say which side has more mass or farther mass.',
   'Draw the system boundary first, then write the center-of-mass sum with each mass and position that belongs inside the system.',
   'Two carts of equal mass are at x = 0 m and x = 6 m. A third equal-mass cart is at x = 6 m. Where is the center of mass?',
   'It is at x = 3 m because the endpoints are 0 m and 6 m.',
   'It is at x = 4 m. Use the mass-weighted average: (m(0)+m(6)+m(6))/(3m)=4 m. The center of mass shifts toward the side with more mass, so the geometric midpoint is not enough.',
   'Using the geometric middle as center of mass without checking where the mass is located.',
   'Back in practice, list each mass position before averaging. If one side has more mass, expect the center of mass to move toward that side.'),
  ('ap_physics_1', 2, '2.2', 'Forces and Free-Body Diagrams',
   'A free-body diagram is a force inventory for one object. It should show each real external force once as a straight arrow from the dot, while components are saved for the equations.',
   'Students need to separate physical forces from mathematical components. Gravity, normal force, friction, tension, spring force, and applied forces can appear. Velocity, acceleration, kinetic energy, momentum, and force components are not separate FBD forces.',
   'Points come from choosing the object, drawing each force in its physical direction, and avoiding extra arrows. A correct FBD often earns credit before any equation is written.',
   'Start with the object dot and draw only real forces on that object; make component equations separately.',
   'A block on an incline has weight mg. Should the FBD also include mg sin(theta) down the ramp as another force?',
   'Yes, because mg sin(theta) is the force pulling the block down the ramp.',
   'No. Draw the full weight mg downward, plus normal force and friction if present. The component mg sin(theta) is part of resolving the weight into axes; drawing it as another arrow double-counts gravity.',
   'Drawing both a force and its components on the FBD, which double-counts the interaction.',
   'In practice, finish the FBD before drawing components. Components belong beside equations, not as extra forces on the dot.'),
  ('ap_physics_1', 2, '2.3', 'Newton''s Third Law',
   'Newton''s third law pairs are two forces from one interaction: A on B and B on A. They are equal in magnitude and opposite in direction, but they act on different objects.',
   'Students need to avoid using third-law pairs as if they cancel on one object. They cancel only when both objects are inside the chosen system and the pair is internal. For AP Physics 1, massive-string tension is described qualitatively rather than calculated in detail.',
   'Points come from naming both objects, assigning each force to the object it acts on, and using system boundaries to decide whether the pair belongs inside or outside a net-force equation.',
   'Write the two object names in every interaction pair before deciding which free-body diagram receives each force.',
   'A book pushes down on a table. What is the third-law partner force?',
   'The weight of the book, because both forces act downward or upward around the book.',
   'The partner is the table pushing up on the book. The book-on-table force and table-on-book force are equal and opposite and act on different objects. The book weight is Earth pulling on the book, a different interaction.',
   'Putting both action-reaction forces on the same free-body diagram.',
   'Back in practice, phrase every force as "force by ___ on ___." Third-law partners swap the two blanks.'),
  ('ap_physics_1', 2, '2.4', 'Newton''s First Law',
   'Newton''s first law says constant velocity requires zero net force in an inertial frame. Zero net force can coexist with real forces if they balance.',
   'Students need to think component by component. A block can have vertical force balance while accelerating horizontally, or horizontal force balance while moving at constant horizontal velocity. Rest is just the zero-speed case of constant velocity.',
   'Points come from connecting zero acceleration to sum F = 0 along the relevant direction and explaining that balanced forces do not disappear. If acceleration is nonzero, first-law equilibrium does not apply in that direction.',
   'Check acceleration component by component; if acceleration is zero along an axis, set the net force along that axis to zero.',
   'A sled moves right at constant velocity on level ground while being pulled. What must be true about the horizontal forces?',
   'There are no horizontal forces because the velocity is constant.',
   'The net horizontal force is zero. The pulling force can be balanced by friction, so the sled continues at constant velocity. Constant velocity means balanced forces, not no forces.',
   'Saying there are no forces because the object moves with constant velocity.',
   'In practice, write whether acceleration is zero before discussing forces. Constant velocity points to net force zero, not force absence.'),
  ('ap_physics_1', 2, '2.5', 'Newton''s Second Law',
   'Newton''s second law is a system-matched statement: the net external force on the selected object or system equals that object or system mass times its acceleration.',
   'Students need to keep force equations organized. A force on block A belongs in block A equation; a force on the two-block system belongs in the system equation. Constraints can connect accelerations, but they do not merge unrelated force lists.',
   'Points come from drawing the FBD, choosing axes, summing forces by component, and matching the mass and acceleration to the same selected object or system.',
   'After the FBD, write sum F = ma for the same object or system named in the diagram.',
   'Two connected blocks accelerate together. A student writes friction on block B and tension on block A but multiplies only by mass A. What is the issue?',
   'That is fine because the blocks are connected and share an acceleration.',
   'The equation mixes objects. If the equation is for block A, use forces on block A and mass A. If it is for both blocks, use external forces on both blocks and total mass. Shared acceleration is a constraint, not permission to mix force lists.',
   'Mixing forces from different objects into one equation without using the total system mass.',
   'Back in practice, label each force equation with its object or system before substituting mass.'),
  ('ap_physics_1', 2, '2.6', 'Gravitational Force',
   'Gravity can be modeled as a force between masses or as a field. Near Earth, weight is mg; apparent weight is the normal-force magnitude a scale would read.',
   'Students need to distinguish mass, weight, gravitational field, and normal force. The fact that an object feels heavier or lighter in an accelerating elevator means the normal force changed, not that its mass changed.',
   'Points come from using F_g = Gm1m2/r^2 or mg in the right context, using g = F_g/m as field strength, and explaining apparent weight through the normal force.',
   'Identify what the question asks for: gravitational force, gravitational field, weight, or apparent weight; then choose the matching equation.',
   'A student says a planet with more mass must have a smaller gravitational field because g = F_g/m. What is wrong?',
   'The equation shows dividing by mass makes g smaller when planet mass gets larger.',
   'The m in g = F_g/m is the test object mass, not the planet mass. For a planet, g = GM/r^2, so increasing planet mass M at the same radius increases gravitational field strength. Do not confuse object mass, planet mass, and weight.',
   'Confusing mass with weight or treating apparent weight as always equal to mg.',
   'In practice, label which mass belongs to the planet and which belongs to the object before using a gravity equation.'),
  ('ap_physics_1', 2, '2.7', 'Kinetic and Static Friction',
   'Kinetic friction has a fixed model during sliding, while static friction adjusts to prevent slipping up to a maximum. Static friction equals mu_s F_N only at the threshold of slipping.',
   'Students need to infer both direction and size from the contact condition. Static friction can be less than its maximum or even zero if no tangential slipping tendency exists.',
   'Points come from identifying sliding versus non-sliding contact, using F_k = mu_k F_N for kinetic friction, solving for needed static friction, and comparing it with F_s,max = mu_s F_N.',
   'Ask whether the surfaces slide; if they do not, solve for the static friction needed before comparing to mu_s F_N.',
   'A box stays at rest while a small horizontal push P is applied. What is the static friction magnitude if P is below the slipping threshold?',
   'It is mu_s F_N because the box is static.',
   'It is P, opposite the push. Static friction adjusts to whatever value is needed to prevent slipping, up to the maximum mu_s F_N. The maximum is a limit, not the automatic value.',
   'Setting static friction equal to mu_s F_N whenever the object is not moving.',
   'Back in practice, write "needed F_s" and "maximum F_s" as two separate quantities.'),
  ('ap_physics_1', 2, '2.8', 'Spring Forces',
   'A spring force is a restoring force: it points toward equilibrium and has magnitude k times the displacement from equilibrium.',
   'Students need to measure stretch or compression relative to equilibrium, not total length. The sign in F_s = -k Delta x means the force opposes displacement from equilibrium.',
   'Points come from identifying equilibrium, finding Delta x, drawing the restoring force in the correct direction, and using the spring force in a net-force equation when dynamics are involved.',
   'Mark equilibrium first, then draw the spring force back toward equilibrium and use magnitude k Delta x in the force equation.',
   'A spring is stretched to the right from equilibrium. Which way does the spring force on the object point?',
   'To the right, because the spring has been stretched to the right.',
   'The spring force points left, back toward equilibrium. A spring force is restoring: when displacement is to the right, the force is in the opposite direction.',
   'Using total spring length instead of displacement from equilibrium.',
   'In practice, draw the equilibrium position as a reference mark before deciding the force direction.'),
  ('ap_physics_1', 2, '2.9', 'Circular Motion',
   'Circular motion needs inward centripetal acceleration v^2/r. The inward net force comes from real forces such as tension, gravity, normal force, or friction; centripetal force is not an extra force.',
   'Students need to draw the FBD before writing mv^2/r. At the top of a vertical loop, both gravity and the normal force can point toward the center, which means the normal force points downward there.',
   'Points come from identifying the center direction, resolving real forces radially, writing sum F_radial = mv^2/r, and respecting AP Physics 1 limits on banked curves with friction and Kepler laws.',
   'Draw the FBD first, then choose inward as positive and identify which real force or component supplies the radial net force.',
   'At the top of a vertical loop, which way does the normal force on the object point if the track is pushing on it?',
   'Upward, because normal force usually points up from a surface.',
   'Downward, toward the center of the loop. The normal force is perpendicular to the track surface and points from the track toward the object; at the top, the center is below the object, so the normal force and gravity can both point inward.',
   'Adding a separate centripetal-force arrow to the FBD instead of using real forces.',
   'Back in practice, mark the center of the circle before drawing forces. Then check which real forces point inward.')
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 2 Force and Translational Dynamics; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 2: system boundaries and center of mass, FBD force-arrow convention, Newton third-law pairs, translational equilibrium, Newton second law, gravitational force/field/weight/apparent weight, kinetic friction equality, static friction inequality, Hooke spring force, circular-motion radial/tangential acceleration, vertical-loop normal-force misconception, banked-curve friction qualitative-only boundary, and Kepler first/second law exclusion; batch 2026-08-25-ap-physics-1-unit2-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 2
    and topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9')
    and status = 'published';

  if v_briefs <> 9 then
    raise exception 'expected 9 published AP Physics 1 Unit 2 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_1'
    and unit_number = 2
    and topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9')
    and status = 'published';

  if v_explainers <> 9 then
    raise exception 'expected 9 published AP Physics 1 Unit 2 explainers, got %', v_explainers;
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
      and b.unit_number = 2
      and b.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9')
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
      and e.unit_number = 2
      and e.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 2 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 2 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_1'
    and b.unit_number = 2
    and b.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-1/unit-2/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 2 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 2 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_physics_1'
      and unit_number = 2
      and topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9')
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
      and e.unit_number = 2
      and e.topic_code in ('2.1', '2.2', '2.3', '2.4', '2.5', '2.6', '2.7', '2.8', '2.9')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 2 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
