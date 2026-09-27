begin;

-- Add AP Physics 2 Unit 10 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 7 AP Physics 2 Unit 10 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_2_CED_FACT_PACK.md Unit 10 (Electric
-- Force, Field, and Potential). The fact pack confirms electric charge,
-- Coulomb law, conductors and insulators, charge conservation and charging,
-- electric fields and field-line maps, electrostatic-equilibrium conductor
-- behavior, electric potential energy, electric potential, equipotential lines,
-- parallel-plate capacitors, capacitor energy, dielectrics, and conservation of
-- electric energy. Scope boundaries include four-or-fewer charge calculations
-- unless symmetry is present, qualitative-only fields inside insulators, no
-- extended-charge potential-energy calculations, and required capacitor analysis
-- limited to parallel plates with edge effects ignored unless stated.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  ('ap_physics_2', 10, '10.1', 'Electric Charge and Electric Force', 'very-important', 'very-important',
   'Electric charge is a positive or negative property of matter, and charged objects exert forces on each other through Coulomb law.',
   'Electric force is the foundation for fields, potentials, capacitors, and circuits. It also explains why contact forces have microscopic electric origins.',
   'You earn points by identifying charge sign, using Coulomb law for magnitude, setting force direction along the line between charges, and vector-adding forces for four or fewer charges unless symmetry is given.',
   'Draw the line between charges first; then decide attraction or repulsion before calculating magnitude.',
   'Calculating the correct Coulomb magnitude but giving the force direction as if all charges repel.',
   '/learn/ap-physics-2/unit-10/electric-charge-and-electric-force'),
  ('ap_physics_2', 10, '10.2', 'Conservation of Electric Charge and the Process of Charging', 'very-important', 'very-important',
   'Net charge is conserved for an isolated system, while friction, contact, induction, and grounding redistribute or transfer charge.',
   'Charging processes explain how neutral objects polarize and how conductors share charge. Many AP points come from tracking electrons rather than inventing charge.',
   'You earn points by conserving total charge, distinguishing transfer from polarization, identifying electron movement, and explaining grounding as connection to a large neutral reservoir.',
   'Choose the system first; then track where electrons move and whether net charge changes or only redistributes.',
   'Saying a neutral object becomes charged by creating positive charge rather than by separating or transferring charge.',
   '/learn/ap-physics-2/unit-10/conservation-of-electric-charge-and-the-process-of-charging'),
  ('ap_physics_2', 10, '10.3', 'Electric Fields', 'very-important', 'very-important',
   'An electric field gives the force per unit positive test charge at each point and is found by vector superposition from source charges.',
   'Fields turn force interactions into maps. Field lines, conductor behavior, and test-charge reasoning are recurring AP representations.',
   'You earn points by using E = F_E/q, drawing field direction away from positive and toward negative sources, vector-adding fields for four or fewer charges unless symmetry is given, and applying conductor equilibrium facts.',
   'At the point of interest, draw each source field vector as if a positive test charge were placed there; then add vectors.',
   'Using the sign of the test charge to reverse the electric field direction instead of reversing only the force on that charge.',
   '/learn/ap-physics-2/unit-10/electric-fields'),
  ('ap_physics_2', 10, '10.4', 'Electric Potential Energy', 'very-important', 'very-important',
   'Electric potential energy is energy stored in a configuration of charges, with point-charge pairs contributing U_E = k q1 q2/r.',
   'Potential energy connects electric force to work, stability, and energy conservation. Sign matters because like and opposite charges form different energy configurations.',
   'You earn points by summing pairwise potential energies for four or fewer point charges, preserving charge signs, and connecting changes in U_E to work or kinetic energy.',
   'List every interacting pair once; then use signed charges in U_E before summing the total.',
   'Using absolute values in electric potential energy and losing the sign that tells whether the interaction is attractive or repulsive.',
   '/learn/ap-physics-2/unit-10/electric-potential-energy'),
  ('ap_physics_2', 10, '10.5', 'Electric Potential', 'very-important', 'very-important',
   'Electric potential is electric potential energy per unit charge, and potentials from point charges add as scalars.',
   'Potential and equipotential maps make electric-field reasoning faster. They connect batteries, charge movement, and field direction toward decreasing potential.',
   'You earn points by using V = k sum(q_i/r_i), applying Delta V = Delta U_E/q, reading equipotential spacing and direction, and remembering there is no field component along an equipotential line.',
   'Treat potential as a signed scalar first; then use field direction and equipotential geometry after the potential comparison is clear.',
   'Vector-adding electric potential the way electric field vectors are added.',
   '/learn/ap-physics-2/unit-10/electric-potential'),
  ('ap_physics_2', 10, '10.6', 'Capacitors', 'very-important', 'very-important',
   'A capacitor separates equal and opposite charge, with capacitance C = Q/Delta V set by geometry and material rather than by the amount of stored charge.',
   'Capacitors bridge electrostatics and circuits. Parallel plates create nearly uniform fields and store energy that can later be transferred.',
   'You earn points by using C = Q/Delta V, C = kappa epsilon_0 A/d for parallel plates, E = Q/(kappa epsilon_0 A), U_C = 1/2 Q Delta V, and dielectric effects within AP scope.',
   'Identify what is held fixed first: charge, voltage, geometry, or dielectric. Then decide how C, Q, Delta V, field, and energy respond.',
   'Saying capacitance increases because more charge was placed on the plates, instead of because geometry or dielectric changed.',
   '/learn/ap-physics-2/unit-10/capacitors'),
  ('ap_physics_2', 10, '10.7', 'Conservation of Electric Energy', 'very-important', 'very-important',
   'A charge moving through a potential difference changes electric potential energy by Delta U_E = q Delta V, with energy transferred to or from kinetic energy.',
   'This topic is the energy bridge from electrostatics to motion and circuits. It turns potential maps into speed, work, and stopping-distance reasoning.',
   'You earn points by using signed Delta U_E = q Delta V, applying energy conservation, and deciding whether the electric field speeds up or slows down the charge.',
   'Write the initial and final potentials, compute signed Delta U_E, then let energy conservation decide the kinetic-energy change.',
   'Assuming a positive potential difference always increases kinetic energy without checking the sign of the moving charge.',
   '/learn/ap-physics-2/unit-10/conservation-of-electric-energy')
),
explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  ('ap_physics_2', 10, '10.1', 'Electric Charge and Electric Force',
   'Electric forces act between charged objects along the line connecting them. Coulomb law gives the magnitude, while charge signs determine attraction or repulsion.',
   'Students need to separate magnitude from direction. The magnitude uses k|q1q2|/r^2, but the vector direction depends on whether the charges have the same sign or opposite signs. Electric forces can be much stronger than gravitational forces for charged particles, but large objects are often nearly neutral.',
   'Points come from drawing correct force directions, applying Newton third-law pairs consistently, using Coulomb law with distance squared, and vector-adding forces from no more than four charges unless the problem gives symmetry.',
   'Draw the line between charges first; then decide attraction or repulsion before calculating magnitude.',
   'A positive charge is placed to the left of a negative charge. What is the force direction on the positive charge?',
   'Left, because the positive charge pushes away from the negative charge.',
   'Right. Opposite charges attract, so the positive charge is pulled along the line toward the negative charge.',
   'Calculating the correct Coulomb magnitude but giving the force direction as if all charges repel.',
   'Back in practice, write attract or repel on the diagram before substituting into Coulomb law.'),
  ('ap_physics_2', 10, '10.2', 'Conservation of Electric Charge and the Process of Charging',
   'Charging changes where charge is located or which object has excess electrons, but total charge is conserved for an isolated system.',
   'Students need to distinguish charge transfer from polarization. Friction and contact can move electrons between objects. Induction can separate charge within a neutral object without changing its net charge. Grounding lets electrons move between an object and a much larger neutral reservoir.',
   'Points come from defining the system, conserving total charge, tracking electron motion, and explaining why neutral objects can be attracted to charged objects through induced separation.',
   'Choose the system first; then track where electrons move and whether net charge changes or only redistributes.',
   'A negatively charged rod is brought near a neutral metal sphere without touching it. Why can the sphere be attracted?',
   'The rod creates positive charge in the sphere, so the sphere becomes positive overall.',
   'The sphere remains neutral overall, but its charges separate. Electrons shift away from the rod, leaving the nearer side relatively positive, so attraction on the near side can dominate.',
   'Saying a neutral object becomes charged by creating positive charge rather than by separating or transferring charge.',
   'In practice, label net charge and charge distribution separately before answering charging questions.'),
  ('ap_physics_2', 10, '10.3', 'Electric Fields',
   'An electric field is a vector map of force per unit positive test charge, created by source charges and found by superposition.',
   'Students need to use a small positive test charge to define field direction. A positive source points field outward; a negative source points field inward. Conductors in electrostatic equilibrium have zero field inside, excess charge on the surface, and field perpendicular to the surface. Insulator interior fields are qualitative only in AP Physics 2.',
   'Points come from drawing field vectors correctly, interpreting line density as field strength, using E = F_E/q, adding field vectors, and applying conductor equilibrium rules.',
   'At the point of interest, draw each source field vector as if a positive test charge were placed there; then add vectors.',
   'At a point near a negative source charge, which way does the electric field point?',
   'Away from the negative charge because fields always point outward.',
   'Toward the negative charge. Electric field direction is the direction of force on a positive test charge, and a positive test charge is attracted to a negative source.',
   'Using the sign of the test charge to reverse the electric field direction instead of reversing only the force on that charge.',
   'Back in practice, use a positive test charge for field direction even if the actual particle in the problem is negative.'),
  ('ap_physics_2', 10, '10.4', 'Electric Potential Energy',
   'Electric potential energy belongs to a charge configuration, and the sign of U_E depends on the signs of the interacting charges.',
   'Students need to sum pair interactions carefully. For point charges, U_E = k q1 q2/r, and total electric potential energy is the sum of each unique pair. Like-charge pairs have positive potential energy; opposite-charge pairs have negative potential energy when the zero is chosen at infinite separation.',
   'Points come from identifying all pairs, using signed charges rather than absolute values, connecting external work to assembling the configuration, and linking decreases in U_E to possible increases in kinetic energy.',
   'List every interacting pair once; then use signed charges in U_E before summing the total.',
   'Two opposite charges move farther apart. Does their electric potential energy increase or decrease?',
   'It decreases because the charges are farther apart and the force is weaker.',
   'It increases toward zero. For opposite charges U_E is negative, and increasing separation makes k q1 q2/r less negative.',
   'Using absolute values in electric potential energy and losing the sign that tells whether the interaction is attractive or repulsive.',
   'In practice, write the sign of each pair term before doing any arithmetic.'),
  ('ap_physics_2', 10, '10.5', 'Electric Potential',
   'Electric potential is a signed scalar that tells electric potential energy per unit charge at a point, and equipotential lines show locations with the same potential.',
   'Students need to avoid treating potential like a vector. Potentials from point charges add algebraically. Electric field vectors point toward decreasing potential, and equipotential lines are perpendicular to field vectors. A charge moving along one equipotential has no change in electric potential energy from the electric field.',
   'Points come from scalar superposition, using Delta V = Delta U_E/q, interpreting equipotential spacing as field strength, and translating between field maps and equipotential maps.',
   'Treat potential as a signed scalar first; then use field direction and equipotential geometry after the potential comparison is clear.',
   'A particle moves along an equipotential line. What is the electric field work for that motion?',
   'It is positive because the particle is moving through an electric field.',
   'It is zero for motion exactly along the equipotential. Delta V is zero, so Delta U_E = q Delta V is zero and the electric field does no work for that displacement.',
   'Vector-adding electric potential the way electric field vectors are added.',
   'Back in practice, decide whether the quantity is field vector or potential scalar before adding contributions.'),
  ('ap_physics_2', 10, '10.6', 'Capacitors',
   'A capacitor stores separated charge and electric energy. Its capacitance is set by plate geometry and dielectric material, not by a one-time choice of charge.',
   'Students need to track what is controlled. For a parallel-plate capacitor, increasing area increases capacitance, increasing separation decreases capacitance, and inserting a dielectric increases capacitance by reducing the effective field for a given free charge. The AP required geometry is parallel plates, with edge effects ignored unless stated.',
   'Points come from applying C = Q/Delta V, C = kappa epsilon_0 A/d, E = Q/(kappa epsilon_0 A), U_C = 1/2 Q Delta V, and explaining changes under fixed-charge or fixed-voltage conditions.',
   'Identify what is held fixed first: charge, voltage, geometry, or dielectric. Then decide how C, Q, Delta V, field, and energy respond.',
   'A disconnected parallel-plate capacitor has its plate separation increased. What happens to its capacitance?',
   'The capacitance stays the same because the same charge remains on the plates.',
   'The capacitance decreases. Capacitance depends on geometry and material, and for parallel plates C = kappa epsilon_0 A/d, so larger d gives smaller C even if the charge is fixed.',
   'Saying capacitance increases because more charge was placed on the plates, instead of because geometry or dielectric changed.',
   'In practice, mark fixed Q or fixed Delta V before comparing capacitor variables.'),
  ('ap_physics_2', 10, '10.7', 'Conservation of Electric Energy',
   'A potential difference changes electric potential energy by q Delta V, and conservation of energy connects that change to kinetic energy or work by other forces.',
   'Students need to use signs deliberately. A positive charge moving to lower potential loses electric potential energy and can gain kinetic energy. A negative charge has the opposite sign relationship. The electric field alone converts energy; nonconservative forces or external agents must be included when present.',
   'Points come from computing signed Delta U_E = q Delta V, writing an energy-conservation statement, and explaining whether the charge speeds up, slows down, or requires external work.',
   'Write the initial and final potentials, compute signed Delta U_E, then let energy conservation decide the kinetic-energy change.',
   'A negative charge moves from 2 V to 6 V with no non-electric work. What happens to its electric potential energy?',
   'It increases because the final potential is higher.',
   'It decreases. Delta V is positive, but q is negative, so Delta U_E = q Delta V is negative. With only the electric field doing work, kinetic energy increases by the same amount.',
   'Assuming a positive potential difference always increases kinetic energy without checking the sign of the moving charge.',
   'Back in practice, calculate the sign of q Delta V before making the energy claim.')
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 10 Electric Force, Field, and Potential; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 10: electric charge and Coulomb law, conductors and insulators, charge conservation and charging by friction/contact/induction/grounding, electric fields and field-line maps, electrostatic-equilibrium conductor behavior, electric potential energy U_E=kq1q2/r, scalar electric potential and equipotentials, parallel-plate capacitors with C=Q/Delta V, C=kappa epsilon_0 A/d, E=Q/(kappa epsilon_0 A), capacitor energy, dielectrics, and conservation of electric energy with Delta U_E=q Delta V; scope boundaries include four-or-fewer charges unless symmetry is present, qualitative-only insulator interior fields, no extended-charge potential-energy calculations, and parallel-plate capacitor analysis with edge effects ignored unless stated; batch 2026-08-25-ap-physics-2-unit10-topic-guides; author=reviewer same session, no independent human review yet',
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
  ('ap_physics_2', 10, '10.1', 'Electric Charge and Electric Force',
   'Electric forces act between charged objects along the line connecting them. Coulomb law gives the magnitude, while charge signs determine attraction or repulsion.',
   'Students need to separate magnitude from direction. The magnitude uses k|q1q2|/r^2, but the vector direction depends on whether the charges have the same sign or opposite signs. Electric forces can be much stronger than gravitational forces for charged particles, but large objects are often nearly neutral.',
   'Points come from drawing correct force directions, applying Newton third-law pairs consistently, using Coulomb law with distance squared, and vector-adding forces from no more than four charges unless the problem gives symmetry.',
   'Draw the line between charges first; then decide attraction or repulsion before calculating magnitude.',
   'A positive charge is placed to the left of a negative charge. What is the force direction on the positive charge?',
   'Left, because the positive charge pushes away from the negative charge.',
   'Right. Opposite charges attract, so the positive charge is pulled along the line toward the negative charge.',
   'Calculating the correct Coulomb magnitude but giving the force direction as if all charges repel.',
   'Back in practice, write attract or repel on the diagram before substituting into Coulomb law.'),
  ('ap_physics_2', 10, '10.2', 'Conservation of Electric Charge and the Process of Charging',
   'Charging changes where charge is located or which object has excess electrons, but total charge is conserved for an isolated system.',
   'Students need to distinguish charge transfer from polarization. Friction and contact can move electrons between objects. Induction can separate charge within a neutral object without changing its net charge. Grounding lets electrons move between an object and a much larger neutral reservoir.',
   'Points come from defining the system, conserving total charge, tracking electron motion, and explaining why neutral objects can be attracted to charged objects through induced separation.',
   'Choose the system first; then track where electrons move and whether net charge changes or only redistributes.',
   'A negatively charged rod is brought near a neutral metal sphere without touching it. Why can the sphere be attracted?',
   'The rod creates positive charge in the sphere, so the sphere becomes positive overall.',
   'The sphere remains neutral overall, but its charges separate. Electrons shift away from the rod, leaving the nearer side relatively positive, so attraction on the near side can dominate.',
   'Saying a neutral object becomes charged by creating positive charge rather than by separating or transferring charge.',
   'In practice, label net charge and charge distribution separately before answering charging questions.'),
  ('ap_physics_2', 10, '10.3', 'Electric Fields',
   'An electric field is a vector map of force per unit positive test charge, created by source charges and found by superposition.',
   'Students need to use a small positive test charge to define field direction. A positive source points field outward; a negative source points field inward. Conductors in electrostatic equilibrium have zero field inside, excess charge on the surface, and field perpendicular to the surface. Insulator interior fields are qualitative only in AP Physics 2.',
   'Points come from drawing field vectors correctly, interpreting line density as field strength, using E = F_E/q, adding field vectors, and applying conductor equilibrium rules.',
   'At the point of interest, draw each source field vector as if a positive test charge were placed there; then add vectors.',
   'At a point near a negative source charge, which way does the electric field point?',
   'Away from the negative charge because fields always point outward.',
   'Toward the negative charge. Electric field direction is the direction of force on a positive test charge, and a positive test charge is attracted to a negative source.',
   'Using the sign of the test charge to reverse the electric field direction instead of reversing only the force on that charge.',
   'Back in practice, use a positive test charge for field direction even if the actual particle in the problem is negative.'),
  ('ap_physics_2', 10, '10.4', 'Electric Potential Energy',
   'Electric potential energy belongs to a charge configuration, and the sign of U_E depends on the signs of the interacting charges.',
   'Students need to sum pair interactions carefully. For point charges, U_E = k q1 q2/r, and total electric potential energy is the sum of each unique pair. Like-charge pairs have positive potential energy; opposite-charge pairs have negative potential energy when the zero is chosen at infinite separation.',
   'Points come from identifying all pairs, using signed charges rather than absolute values, connecting external work to assembling the configuration, and linking decreases in U_E to possible increases in kinetic energy.',
   'List every interacting pair once; then use signed charges in U_E before summing the total.',
   'Two opposite charges move farther apart. Does their electric potential energy increase or decrease?',
   'It decreases because the charges are farther apart and the force is weaker.',
   'It increases toward zero. For opposite charges U_E is negative, and increasing separation makes k q1 q2/r less negative.',
   'Using absolute values in electric potential energy and losing the sign that tells whether the interaction is attractive or repulsive.',
   'In practice, write the sign of each pair term before doing any arithmetic.'),
  ('ap_physics_2', 10, '10.5', 'Electric Potential',
   'Electric potential is a signed scalar that tells electric potential energy per unit charge at a point, and equipotential lines show locations with the same potential.',
   'Students need to avoid treating potential like a vector. Potentials from point charges add algebraically. Electric field vectors point toward decreasing potential, and equipotential lines are perpendicular to field vectors. A charge moving along one equipotential has no change in electric potential energy from the electric field.',
   'Points come from scalar superposition, using Delta V = Delta U_E/q, interpreting equipotential spacing as field strength, and translating between field maps and equipotential maps.',
   'Treat potential as a signed scalar first; then use field direction and equipotential geometry after the potential comparison is clear.',
   'A particle moves along an equipotential line. What is the electric field work for that motion?',
   'It is positive because the particle is moving through an electric field.',
   'It is zero for motion exactly along the equipotential. Delta V is zero, so Delta U_E = q Delta V is zero and the electric field does no work for that displacement.',
   'Vector-adding electric potential the way electric field vectors are added.',
   'Back in practice, decide whether the quantity is field vector or potential scalar before adding contributions.'),
  ('ap_physics_2', 10, '10.6', 'Capacitors',
   'A capacitor stores separated charge and electric energy. Its capacitance is set by plate geometry and dielectric material, not by a one-time choice of charge.',
   'Students need to track what is controlled. For a parallel-plate capacitor, increasing area increases capacitance, increasing separation decreases capacitance, and inserting a dielectric increases capacitance by reducing the effective field for a given free charge. The AP required geometry is parallel plates, with edge effects ignored unless stated.',
   'Points come from applying C = Q/Delta V, C = kappa epsilon_0 A/d, E = Q/(kappa epsilon_0 A), U_C = 1/2 Q Delta V, and explaining changes under fixed-charge or fixed-voltage conditions.',
   'Identify what is held fixed first: charge, voltage, geometry, or dielectric. Then decide how C, Q, Delta V, field, and energy respond.',
   'A disconnected parallel-plate capacitor has its plate separation increased. What happens to its capacitance?',
   'The capacitance stays the same because the same charge remains on the plates.',
   'The capacitance decreases. Capacitance depends on geometry and material, and for parallel plates C = kappa epsilon_0 A/d, so larger d gives smaller C even if the charge is fixed.',
   'Saying capacitance increases because more charge was placed on the plates, instead of because geometry or dielectric changed.',
   'In practice, mark fixed Q or fixed Delta V before comparing capacitor variables.'),
  ('ap_physics_2', 10, '10.7', 'Conservation of Electric Energy',
   'A potential difference changes electric potential energy by q Delta V, and conservation of energy connects that change to kinetic energy or work by other forces.',
   'Students need to use signs deliberately. A positive charge moving to lower potential loses electric potential energy and can gain kinetic energy. A negative charge has the opposite sign relationship. The electric field alone converts energy; nonconservative forces or external agents must be included when present.',
   'Points come from computing signed Delta U_E = q Delta V, writing an energy-conservation statement, and explaining whether the charge speeds up, slows down, or requires external work.',
   'Write the initial and final potentials, compute signed Delta U_E, then let energy conservation decide the kinetic-energy change.',
   'A negative charge moves from 2 V to 6 V with no non-electric work. What happens to its electric potential energy?',
   'It increases because the final potential is higher.',
   'It decreases. Delta V is positive, but q is negative, so Delta U_E = q Delta V is negative. With only the electric field doing work, kinetic energy increases by the same amount.',
   'Assuming a positive potential difference always increases kinetic energy without checking the sign of the moving charge.',
   'Back in practice, calculate the sign of q Delta V before making the energy claim.')
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 2 Unit 10 Electric Force, Field, and Potential; grounded in AP_PHYSICS_2_CED_FACT_PACK.md Unit 10: electric charge and Coulomb law, conductors and insulators, charge conservation and charging by friction/contact/induction/grounding, electric fields and field-line maps, electrostatic-equilibrium conductor behavior, electric potential energy U_E=kq1q2/r, scalar electric potential and equipotentials, parallel-plate capacitors with C=Q/Delta V, C=kappa epsilon_0 A/d, E=Q/(kappa epsilon_0 A), capacitor energy, dielectrics, and conservation of electric energy with Delta U_E=q Delta V; scope boundaries include four-or-fewer charges unless symmetry is present, qualitative-only insulator interior fields, no extended-charge potential-energy calculations, and parallel-plate capacitor analysis with edge effects ignored unless stated; batch 2026-08-25-ap-physics-2-unit10-topic-guides; author=reviewer same session, no independent human review yet',
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
  where subject_key = 'ap_physics_2'
    and unit_number = 10
    and topic_code in ('10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.7')
    and status = 'published';

  if v_briefs <> 7 then
    raise exception 'expected 7 published AP Physics 2 Unit 10 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_2'
    and unit_number = 10
    and topic_code in ('10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.7')
    and status = 'published';

  if v_explainers <> 7 then
    raise exception 'expected 7 published AP Physics 2 Unit 10 explainers, got %', v_explainers;
  end if;

  select count(*) into v_pairing_orphans
  from (
    select b.subject_key, b.topic_code
    from app.topic_point_briefs b
    left join app.topic_explainers e
      on e.subject_key = b.subject_key
     and e.topic_code = b.topic_code
     and e.status = 'published'
    where b.subject_key = 'ap_physics_2'
      and b.unit_number = 10
      and b.topic_code in ('10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.7')
      and b.status = 'published'
      and e.topic_code is null
    union all
    select e.subject_key, e.topic_code
    from app.topic_explainers e
    left join app.topic_point_briefs b
      on b.subject_key = e.subject_key
     and b.topic_code = e.topic_code
     and b.status = 'published'
    where e.subject_key = 'ap_physics_2'
      and e.unit_number = 10
      and e.topic_code in ('10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.7')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 10 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.7')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 10 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_2'
    and b.unit_number = 10
    and b.topic_code in ('10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.7')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-2/unit-10/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 10 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_2'
    and b.topic_code in ('10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.7')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 10 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select topic_explainer_id, mini_example_question, weak_answer, point_attaining_answer, practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_physics_2'
      and unit_number = 10
      and topic_code in ('10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.7')
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
      e.subject_key = 'ap_physics_2'
      and e.unit_number = 10
      and e.topic_code in ('10.1', '10.2', '10.3', '10.4', '10.5', '10.6', '10.7')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 2 Unit 10 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
