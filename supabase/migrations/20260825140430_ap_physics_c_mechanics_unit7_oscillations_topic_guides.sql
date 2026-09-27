begin;

-- Add AP Physics C: Mechanics Unit 7 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 5 AP Physics C:Mechanics Unit 7 topics and 0
-- published point briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 7
-- (Oscillations). The fact pack confirms SHM from restoring force proportional
-- to displacement, T=2pi/omega=1/f, spring-object and small-angle pendulum
-- periods, sinusoidal position as a differential-equation solution, oscillator
-- energy exchange and spring total energy 1/2 k A^2, physical pendulum torque
-- and small-angle differential-equation derivation, and documented 2025 spring
-- period/energy mass-dependence misconceptions. Topic 7.5 is CED-verified but
-- lacks released-FRQ misconception evidence in the checked sources.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_c_mechanics', 7, '7.1', 'Defining Simple Harmonic Motion (SHM)',
    'very-important', 'very-important',
    'SHM occurs when net restoring force is proportional to displacement from equilibrium and opposite in direction, producing ma_x = -k delta x.',
    'This definition turns force analysis into a differential-equation model for oscillation. It is the bridge from dynamics to sinusoidal motion in Physics C.',
    'You earn points by identifying equilibrium, deriving or recognizing a linear restoring-force relation, and connecting the negative sign to acceleration opposite displacement.',
    'Start from net force, express it in terms of displacement from equilibrium, and show it has the form m d2x/dt2 = -k x.',
    'Calling motion SHM because it repeats without proving the restoring force is linear in displacement.',
    '/learn/ap-physics-c-mechanics/unit-7/defining-simple-harmonic-motion-shm'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.2', 'Frequency and Period of SHM',
    'very-important', 'very-important',
    'SHM timing is described by angular frequency, period, and frequency: T = 2 pi/omega = 1/f. Springs and small-angle pendulums have characteristic period formulas.',
    'Period questions often come from the coefficient in the SHM differential equation. Physics C expects you to connect force constants, inertia, and omega before comparing periods.',
    'You earn points by identifying omega from d2x/dt2 = -omega^2 x, using T = 2 pi/omega, and applying the correct spring or pendulum period dependence.',
    'Reduce the equation of motion to SHM form first; then read omega squared and convert to period with T = 2 pi/omega.',
    'Treating period as directly proportional to mass instead of proportional to the square root of the inertia-to-restoring-constant ratio.',
    '/learn/ap-physics-c-mechanics/unit-7/frequency-and-period-of-shm'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.3', 'Representing and Analyzing SHM',
    'very-important', 'very-important',
    'SHM position can be represented sinusoidally, such as x = A cos(2 pi f t) or x = A sin(2 pi f t), as the solution to a second-order differential equation.',
    'Graphs and functions show the same physics: displacement, velocity, and acceleration have linked extrema and zeros. The differential-equation form explains why the motion repeats sinusoidally.',
    'You earn points by reading amplitude and period, differentiating or reasoning to velocity and acceleration behavior, and matching phase to the stated initial conditions.',
    'Use the given initial position and velocity to choose sine/cosine phase, then connect acceleration to -omega^2 x.',
    'Reading a position maximum as a velocity maximum instead of a turning point with zero velocity.',
    '/learn/ap-physics-c-mechanics/unit-7/representing-and-analyzing-shm'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.4', 'Energy of Simple Harmonic Oscillators',
    'very-important', 'very-important',
    'In ideal SHM, total mechanical energy is constant while kinetic and potential energy exchange. For a spring oscillator, E_total = 1/2 k A^2.',
    'Energy reasoning explains amplitude, speed, and turning points without solving the full motion function. It also exposes common mistakes about mass and period versus energy.',
    'You earn points by using conservation of energy, identifying where K or U is maximum or zero, and linking amplitude changes to total energy through A squared.',
    'Mark equilibrium and turning points; then write K + U = constant and use the correct spring or oscillator potential-energy expression.',
    'Saying a heavier mass has more oscillator energy just because the spring-block period changes with mass.',
    '/learn/ap-physics-c-mechanics/unit-7/energy-of-simple-harmonic-oscillators'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.5', 'Simple and Physical Pendulums',
    'very-important', 'very-important',
    'A physical pendulum is a rigid body oscillating about a fixed axis. For small angles, torque creates an SHM equation for angular displacement.',
    'This Physics C-only topic uses rotational dynamics to derive oscillation period. The small-angle approximation turns restoring torque into a linear angular SHM equation.',
    'You earn points by writing torque about the pivot, using sin(theta) approximately theta for small angles, forming I alpha = -mgd theta, and identifying omega and period.',
    'Choose the pivot, write restoring torque, apply the small-angle approximation, then reduce to d2theta/dt2 = -omega^2 theta.',
    'Using the simple-pendulum period for every pendulum without checking rotational inertia and center-of-mass distance.',
    '/learn/ap-physics-c-mechanics/unit-7/simple-and-physical-pendulums'
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
    'ap_physics_c_mechanics', 7, '7.1', 'Defining Simple Harmonic Motion (SHM)',
    'SHM is a dynamics claim before it is a graph shape. If displacement from equilibrium produces a restoring force proportional to that displacement and opposite in direction, Newton''s second law becomes a second-order equation with acceleration proportional to -x.',
    'Students need to show why the motion is simple harmonic. Repetition alone is not enough. The selected coordinate must measure displacement from equilibrium, and the net force must reduce to a linear restoring form such as m d2x/dt2 = -k x or d2x/dt2 = -omega^2 x.',
    'Points come from defining equilibrium, writing the net force or torque in terms of displacement, preserving the sign, and connecting that equation to SHM rather than simply naming it.',
    'Start from net force, express it in terms of displacement from equilibrium, and show it has the form m d2x/dt2 = -k x.',
    'A mass moves back and forth, but the net force is proportional to -x^3 instead of -x. Can you identify the motion as SHM from that force law?',
    'Yes, because the force points back toward equilibrium and the motion repeats.',
    'No. A restoring direction is necessary but not sufficient for SHM. The force must be proportional to displacement itself, giving acceleration proportional to -x. A force proportional to -x^3 is restoring, but it does not produce the standard linear SHM differential equation.',
    'Calling motion SHM because it repeats without proving the restoring force is linear in displacement.',
    'Back in practice, underline the coordinate measured from equilibrium and look for a first-power displacement term with a minus sign.'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.2', 'Frequency and Period of SHM',
    'The period comes from the angular frequency in the equation of motion. Once the motion is written as d2x/dt2 = -omega^2 x, the period is T = 2 pi/omega and the frequency is f = 1/T.',
    'Students need to recognize that different oscillators hide omega in different places. For a spring, omega squared is k/m. For a small-angle simple pendulum, omega squared is g/L. In more complex systems, the ratio is often restoring constant over inertia, which is why period scales with a square root.',
    'Points come from deriving or identifying omega, converting between omega, T, and f, and making proportional comparisons from the square-root dependence rather than from linear intuition.',
    'Reduce the equation of motion to SHM form first; then read omega squared and convert to period with T = 2 pi/omega.',
    'A spring-block oscillator has mass m and period T. If the mass becomes 9m and the spring is unchanged, how does the period change?',
    'The period becomes 9T because the mass is nine times larger.',
    'For a spring-block oscillator, T = 2 pi sqrt(m/k). Replacing m with 9m multiplies the square root by 3, so the period becomes 3T. The dependence is square-root, not linear.',
    'Treating period as directly proportional to mass instead of proportional to the square root of the inertia-to-restoring-constant ratio.',
    'In practice, compare period by reading what is inside the square root. Most wrong answers skip that square-root step.'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.3', 'Representing and Analyzing SHM',
    'A sinusoidal SHM function is a solution to the SHM differential equation. Position, velocity, and acceleration are phase-linked: acceleration is always opposite displacement, and velocity is zero at displacement extrema.',
    'Students need to connect representations. A graph gives amplitude and period; a function gives phase and angular frequency; derivatives give velocity and acceleration. Initial conditions determine whether sine, cosine, or a shifted form is the cleanest representation.',
    'Points are earned by extracting amplitude and period from a graph, differentiating correctly when a function is given, identifying zeros and extrema, and matching signs to displacement from equilibrium.',
    'Use the given initial position and velocity to choose sine/cosine phase, then connect acceleration to -omega^2 x.',
    'An oscillator is at x = +A at t = 0 and released from rest. Which starting form is natural for x(t)?',
    'Use x = A sin(omega t) because SHM is sinusoidal.',
    'Use x = A cos(omega t) for this phase choice. At t = 0, cosine gives x = A and velocity v = dx/dt = -A omega sin(omega t) = 0. A sine form without phase shift would start at x = 0, not at the positive turning point.',
    'Reading a position maximum as a velocity maximum instead of a turning point with zero velocity.',
    'Back in practice, plug t = 0 into the proposed function and its derivative. Initial position and initial velocity should both match.'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.4', 'Energy of Simple Harmonic Oscillators',
    'Energy in ideal SHM is conserved while moving between kinetic and potential forms. Amplitude sets the total energy for a spring oscillator through E_total = 1/2 k A^2, while mass affects period but not that spring energy expression for a fixed amplitude and spring.',
    'Students need to separate timing from energy. The 2025 Mechanics evidence flags mass-dependence mistakes: changing mass changes spring-block period through sqrt(m), but it does not automatically make the oscillator energy larger if k and A are unchanged.',
    'Points come from using K + U = constant, identifying K maximum at equilibrium and zero at turning points, using the correct potential-energy model, and comparing amplitude through A squared.',
    'Mark equilibrium and turning points; then write K + U = constant and use the correct spring or oscillator potential-energy expression.',
    'A spring-block oscillator has the same spring and same amplitude, but the mass is doubled. Does the total spring-oscillator energy double?',
    'Yes. A larger mass means larger energy because the period changes.',
    'No. For a spring-block oscillator with the same spring and amplitude, E_total = 1/2 k A^2, so the total energy is unchanged. Doubling mass changes the period and maximum speed relationship, but not the total energy set by k and A.',
    'Saying a heavier mass has more oscillator energy just because the spring-block period changes with mass.',
    'In practice, write the energy expression and the period expression separately. Mass appears in the spring period formula, not in 1/2 k A^2.'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.5', 'Simple and Physical Pendulums',
    'A physical pendulum turns rotational dynamics into SHM. For small angles, gravitational torque about the pivot is approximately -mgd theta, so I d2theta/dt2 = -mgd theta and omega squared is mgd/I.',
    'Students need to know when the simple-pendulum formula is a special case and when a rigid body needs its rotational inertia. The pivot, center-of-mass distance d, and moment of inertia about the pivot all enter the physical-pendulum period. This topic is CED-verified, but the fact pack notes no released-FRQ misconception evidence for 7.5 in the checked sources.',
    'Points are earned by choosing the pivot, writing the restoring torque, applying sin(theta) approximately theta only for small amplitudes, forming the angular SHM equation, and reading omega to get the period.',
    'Choose the pivot, write restoring torque, apply the small-angle approximation, then reduce to d2theta/dt2 = -omega^2 theta.',
    'A uniform rod pivots about one end and oscillates with small amplitude. Why is T = 2 pi sqrt(L/g) not the right formula to use directly?',
    'It is a pendulum, so every pendulum uses T = 2 pi sqrt(L/g).',
    'A rod pivoting about one end is a physical pendulum, not a point-mass simple pendulum. Its period depends on the rod moment of inertia about the pivot and the center-of-mass distance from the pivot. The setup should begin with tau = I alpha and small-angle torque, then identify omega squared = mgd/I.',
    'Using the simple-pendulum period for every pendulum without checking rotational inertia and center-of-mass distance.',
    'Back in practice, ask whether the oscillator is a point mass on a light string or a rigid body. Rigid body means physical pendulum and I about the pivot.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 7 Oscillations; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 7: SHM restoring force proportional to displacement, T=2pi/omega=1/f, spring and small-angle pendulum periods, sinusoidal solution to a second-order differential equation, oscillator energy and E_total=1/2 k A^2, physical pendulum torque/small-angle derivation, documented 2025 mass-dependence misconceptions, and note that topic 7.5 lacks released-FRQ misconception evidence in checked sources; batch 2026-08-25-ap-physics-c-mechanics-unit7-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_c_mechanics', 7, '7.1', 'Defining Simple Harmonic Motion (SHM)',
    'SHM is a dynamics claim before it is a graph shape. If displacement from equilibrium produces a restoring force proportional to that displacement and opposite in direction, Newton''s second law becomes a second-order equation with acceleration proportional to -x.',
    'Students need to show why the motion is simple harmonic. Repetition alone is not enough. The selected coordinate must measure displacement from equilibrium, and the net force must reduce to a linear restoring form such as m d2x/dt2 = -k x or d2x/dt2 = -omega^2 x.',
    'Points come from defining equilibrium, writing the net force or torque in terms of displacement, preserving the sign, and connecting that equation to SHM rather than simply naming it.',
    'Start from net force, express it in terms of displacement from equilibrium, and show it has the form m d2x/dt2 = -k x.',
    'A mass moves back and forth, but the net force is proportional to -x^3 instead of -x. Can you identify the motion as SHM from that force law?',
    'Yes, because the force points back toward equilibrium and the motion repeats.',
    'No. A restoring direction is necessary but not sufficient for SHM. The force must be proportional to displacement itself, giving acceleration proportional to -x. A force proportional to -x^3 is restoring, but it does not produce the standard linear SHM differential equation.',
    'Calling motion SHM because it repeats without proving the restoring force is linear in displacement.',
    'Back in practice, underline the coordinate measured from equilibrium and look for a first-power displacement term with a minus sign.'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.2', 'Frequency and Period of SHM',
    'The period comes from the angular frequency in the equation of motion. Once the motion is written as d2x/dt2 = -omega^2 x, the period is T = 2 pi/omega and the frequency is f = 1/T.',
    'Students need to recognize that different oscillators hide omega in different places. For a spring, omega squared is k/m. For a small-angle simple pendulum, omega squared is g/L. In more complex systems, the ratio is often restoring constant over inertia, which is why period scales with a square root.',
    'Points come from deriving or identifying omega, converting between omega, T, and f, and making proportional comparisons from the square-root dependence rather than from linear intuition.',
    'Reduce the equation of motion to SHM form first; then read omega squared and convert to period with T = 2 pi/omega.',
    'A spring-block oscillator has mass m and period T. If the mass becomes 9m and the spring is unchanged, how does the period change?',
    'The period becomes 9T because the mass is nine times larger.',
    'For a spring-block oscillator, T = 2 pi sqrt(m/k). Replacing m with 9m multiplies the square root by 3, so the period becomes 3T. The dependence is square-root, not linear.',
    'Treating period as directly proportional to mass instead of proportional to the square root of the inertia-to-restoring-constant ratio.',
    'In practice, compare period by reading what is inside the square root. Most wrong answers skip that square-root step.'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.3', 'Representing and Analyzing SHM',
    'A sinusoidal SHM function is a solution to the SHM differential equation. Position, velocity, and acceleration are phase-linked: acceleration is always opposite displacement, and velocity is zero at displacement extrema.',
    'Students need to connect representations. A graph gives amplitude and period; a function gives phase and angular frequency; derivatives give velocity and acceleration. Initial conditions determine whether sine, cosine, or a shifted form is the cleanest representation.',
    'Points are earned by extracting amplitude and period from a graph, differentiating correctly when a function is given, identifying zeros and extrema, and matching signs to displacement from equilibrium.',
    'Use the given initial position and velocity to choose sine/cosine phase, then connect acceleration to -omega^2 x.',
    'An oscillator is at x = +A at t = 0 and released from rest. Which starting form is natural for x(t)?',
    'Use x = A sin(omega t) because SHM is sinusoidal.',
    'Use x = A cos(omega t) for this phase choice. At t = 0, cosine gives x = A and velocity v = dx/dt = -A omega sin(omega t) = 0. A sine form without phase shift would start at x = 0, not at the positive turning point.',
    'Reading a position maximum as a velocity maximum instead of a turning point with zero velocity.',
    'Back in practice, plug t = 0 into the proposed function and its derivative. Initial position and initial velocity should both match.'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.4', 'Energy of Simple Harmonic Oscillators',
    'Energy in ideal SHM is conserved while moving between kinetic and potential forms. Amplitude sets the total energy for a spring oscillator through E_total = 1/2 k A^2, while mass affects period but not that spring energy expression for a fixed amplitude and spring.',
    'Students need to separate timing from energy. The 2025 Mechanics evidence flags mass-dependence mistakes: changing mass changes spring-block period through sqrt(m), but it does not automatically make the oscillator energy larger if k and A are unchanged.',
    'Points come from using K + U = constant, identifying K maximum at equilibrium and zero at turning points, using the correct potential-energy model, and comparing amplitude through A squared.',
    'Mark equilibrium and turning points; then write K + U = constant and use the correct spring or oscillator potential-energy expression.',
    'A spring-block oscillator has the same spring and same amplitude, but the mass is doubled. Does the total spring-oscillator energy double?',
    'Yes. A larger mass means larger energy because the period changes.',
    'No. For a spring-block oscillator with the same spring and amplitude, E_total = 1/2 k A^2, so the total energy is unchanged. Doubling mass changes the period and maximum speed relationship, but not the total energy set by k and A.',
    'Saying a heavier mass has more oscillator energy just because the spring-block period changes with mass.',
    'In practice, write the energy expression and the period expression separately. Mass appears in the spring period formula, not in 1/2 k A^2.'
  ),
  (
    'ap_physics_c_mechanics', 7, '7.5', 'Simple and Physical Pendulums',
    'A physical pendulum turns rotational dynamics into SHM. For small angles, gravitational torque about the pivot is approximately -mgd theta, so I d2theta/dt2 = -mgd theta and omega squared is mgd/I.',
    'Students need to know when the simple-pendulum formula is a special case and when a rigid body needs its rotational inertia. The pivot, center-of-mass distance d, and moment of inertia about the pivot all enter the physical-pendulum period. This topic is CED-verified, but the fact pack notes no released-FRQ misconception evidence for 7.5 in the checked sources.',
    'Points are earned by choosing the pivot, writing the restoring torque, applying sin(theta) approximately theta only for small amplitudes, forming the angular SHM equation, and reading omega to get the period.',
    'Choose the pivot, write restoring torque, apply the small-angle approximation, then reduce to d2theta/dt2 = -omega^2 theta.',
    'A uniform rod pivots about one end and oscillates with small amplitude. Why is T = 2 pi sqrt(L/g) not the right formula to use directly?',
    'It is a pendulum, so every pendulum uses T = 2 pi sqrt(L/g).',
    'A rod pivoting about one end is a physical pendulum, not a point-mass simple pendulum. Its period depends on the rod moment of inertia about the pivot and the center-of-mass distance from the pivot. The setup should begin with tau = I alpha and small-angle torque, then identify omega squared = mgd/I.',
    'Using the simple-pendulum period for every pendulum without checking rotational inertia and center-of-mass distance.',
    'Back in practice, ask whether the oscillator is a point mass on a light string or a rigid body. Rigid body means physical pendulum and I about the pivot.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics C:Mechanics Unit 7 Oscillations; grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 7: SHM restoring force proportional to displacement, T=2pi/omega=1/f, spring and small-angle pendulum periods, sinusoidal solution to a second-order differential equation, oscillator energy and E_total=1/2 k A^2, physical pendulum torque/small-angle derivation, documented 2025 mass-dependence misconceptions, and note that topic 7.5 lacks released-FRQ misconception evidence in checked sources; batch 2026-08-25-ap-physics-c-mechanics-unit7-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 7
    and topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5')
    and status = 'published';

  if v_briefs <> 5 then
    raise exception 'expected 5 published AP Physics C:Mechanics Unit 7 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_c_mechanics'
    and unit_number = 7
    and topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5')
    and status = 'published';

  if v_explainers <> 5 then
    raise exception 'expected 5 published AP Physics C:Mechanics Unit 7 explainers, got %', v_explainers;
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
      and b.unit_number = 7
      and b.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5')
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
      and e.unit_number = 7
      and e.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 7 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 7 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.unit_number = 7
    and b.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-c-mechanics/unit-7/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 7 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_c_mechanics'
    and b.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 7 core_idea/what_it_is matches, got %', v_core_matches;
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
      and unit_number = 7
      and topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5')
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
      and e.unit_number = 7
      and e.topic_code in ('7.1', '7.2', '7.3', '7.4', '7.5')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics C:Mechanics Unit 7 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
