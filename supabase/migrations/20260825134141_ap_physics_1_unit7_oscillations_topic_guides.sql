begin;

-- Add AP Physics 1 Unit 7 topic-guide pairs.
--
-- Production and Development coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 4 AP Physics 1 Unit 7 topics and 0 published point
-- briefs/explainers for the unit in each environment.
--
-- Grounding: docs/product/AP_PHYSICS_1_CED_FACT_PACK.md Unit 7 (Oscillations).
-- The fact pack confirms SHM as periodic motion from a restoring force whose
-- magnitude is proportional to displacement and whose direction is opposite
-- displacement, spring-object and small-angle pendulum period equations,
-- sinusoidal SHM representations, amplitude-independent period behavior,
-- graphical maxima/minima/zeros, and oscillator energy exchange with
-- E_total = 1/2 k A^2 for a spring-object system.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_1', 7, '7.1', 'Defining Simple Harmonic Motion (SHM)',
    'very-important', 'very-important',
    'Simple harmonic motion is periodic motion caused by a restoring force that points toward equilibrium and has magnitude proportional to displacement from equilibrium.',
    'This definition tells you when spring and small-angle pendulum models apply. It also explains why acceleration reverses direction across equilibrium instead of staying constant.',
    'You earn points by identifying equilibrium, displacement from equilibrium, restoring-force direction, and proportionality between restoring-force magnitude and displacement.',
    'Start by marking equilibrium, then state that the restoring force points opposite displacement and grows with distance from equilibrium.',
    'Calling any back-and-forth periodic motion SHM without showing a proportional restoring force.',
    '/learn/ap-physics-1/unit-7/defining-simple-harmonic-motion-shm'
  ),
  (
    'ap_physics_1', 7, '7.2', 'Frequency and Period of SHM',
    'very-important', 'very-important',
    'Period is the time for one complete cycle and frequency is cycles per second, with T = 1/f. For SHM, spring and small-angle pendulum periods come from system parameters.',
    'Period and frequency are the timing language of oscillations. The formulas show which variables matter: mass and spring constant for springs, length and g for small-angle pendulums.',
    'You earn points by using T = 1/f, selecting the correct period model, and explaining variable changes from the formula instead of from intuition about speed or amplitude.',
    'Identify the oscillator type first; use T_s = 2 pi sqrt(m/k) for a spring-object system and T_p = 2 pi sqrt(L/g) for a small-angle pendulum.',
    'Putting amplitude into the period formula or treating frequency and period as directly proportional.',
    '/learn/ap-physics-1/unit-7/frequency-and-period-of-shm'
  ),
  (
    'ap_physics_1', 7, '7.3', 'Representing and Analyzing SHM',
    'very-important', 'very-important',
    'SHM can be represented with sinusoidal position-time graphs such as x = A cos(2 pi f t) or x = A sin(2 pi f t), along with related velocity and acceleration behavior.',
    'Graphical SHM questions reward recognizing where displacement, velocity, and acceleration are maximum, minimum, or zero. The representation turns motion into timing and sign evidence.',
    'You earn points by reading amplitude, period, frequency, signs, extrema, and zero crossings from graphs and by connecting acceleration direction to displacement from equilibrium.',
    'Use the position graph as the anchor: amplitude is maximum displacement, one cycle gives period, and velocity is greatest as the oscillator passes equilibrium.',
    'Reading a large amplitude as a longer period even though changing amplitude does not change period for SHM.',
    '/learn/ap-physics-1/unit-7/representing-and-analyzing-shm'
  ),
  (
    'ap_physics_1', 7, '7.4', 'Energy of Simple Harmonic Oscillators',
    'very-important', 'very-important',
    'In an ideal simple harmonic oscillator, total mechanical energy stays constant while kinetic energy and potential energy trade back and forth during the cycle.',
    'Energy explains why speed is greatest at equilibrium and zero at turning points. For a spring-object oscillator, amplitude sets the total energy through E_total = 1/2 k A^2.',
    'You earn points by locating where K and U are maximum or minimum, using conservation of total energy, and relating larger amplitude to larger total oscillator energy.',
    'Mark turning points and equilibrium first; at turning points K = 0 and U is maximum, while at equilibrium spring PE is minimum and K is maximum.',
    'Saying energy is lost at the turning point because the oscillator momentarily stops.',
    '/learn/ap-physics-1/unit-7/energy-of-simple-harmonic-oscillators'
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
    'ap_physics_1', 7, '7.1', 'Defining Simple Harmonic Motion (SHM)',
    'SHM is not just repeated motion. It is the special case where displacement from equilibrium creates a restoring force back toward equilibrium, and the restoring-force magnitude is proportional to how far the object is displaced.',
    'Students need to separate periodic motion from simple harmonic motion. A system can repeat without being SHM; to justify SHM, the force or torque must pull toward equilibrium and scale with displacement. For a spring, this leads to ma_x = -k delta x. For a small-angle pendulum, the restoring torque is proportional to angular displacement.',
    'Points come from naming equilibrium, assigning displacement from that equilibrium, and explaining the restoring interaction with the correct direction and proportionality. The negative sign in the SHM relationship means acceleration points opposite displacement, not merely that the object is moving left.',
    'Start by marking equilibrium, then state that the restoring force points opposite displacement and grows with distance from equilibrium.',
    'A cart attached to a spring is pulled to the right of equilibrium and released. What must be true about the spring force for the motion to be modeled as SHM?',
    'The spring force has to make the cart move back and forth, so any changing force works.',
    'The spring force must be a restoring force: when the cart is to the right of equilibrium, the force is to the left, and its magnitude is proportional to the displacement from equilibrium. That is the SHM condition. The back-and-forth motion alone is not enough; the force relationship is what makes the motion simple harmonic.',
    'Calling any back-and-forth periodic motion SHM without showing a proportional restoring force.',
    'Back in practice, write two checks before using SHM equations: direction toward equilibrium and magnitude proportional to displacement.'
  ),
  (
    'ap_physics_1', 7, '7.2', 'Frequency and Period of SHM',
    'Period and frequency are reciprocals: T = 1/f. For common AP Physics 1 oscillators, the period depends on the system model: T_s = 2 pi sqrt(m/k) for a spring-object oscillator and T_p = 2 pi sqrt(L/g) for a small-angle pendulum.',
    'Students need to choose the formula from the physical oscillator, not from whatever variables appear in the prompt. A heavier spring-object oscillator has a longer period; a stiffer spring has a shorter period. A longer small-angle pendulum has a longer period. Amplitude is not part of either ideal SHM period formula.',
    'Points come from identifying one full cycle, converting between T and f, and using proportional reasoning from the correct period equation. If the question asks what happens when a variable changes, the formula should drive the comparison.',
    'Identify the oscillator type first; use T_s = 2 pi sqrt(m/k) for a spring-object system and T_p = 2 pi sqrt(L/g) for a small-angle pendulum.',
    'A mass on a spring oscillates with period T. The mass is replaced by a mass four times as large, using the same spring. What happens to the period?',
    'The period becomes four times as large because the mass is four times as large.',
    'For a spring-object oscillator, T_s = 2 pi sqrt(m/k). If m becomes 4m and k is unchanged, the square-root factor becomes sqrt(4m/k) = 2 sqrt(m/k). The period doubles, not quadruples. The square root in the period formula is the scoring detail.',
    'Putting amplitude into the period formula or treating frequency and period as directly proportional.',
    'In practice, circle the oscillator type before substituting. Then compare variables inside the square root carefully.'
  ),
  (
    'ap_physics_1', 7, '7.3', 'Representing and Analyzing SHM',
    'SHM graphs carry position, timing, and force information at once. Position varies sinusoidally, amplitude is maximum displacement from equilibrium, period is the time for one full repeat, and velocity and acceleration have predictable zeros and extrema during the cycle.',
    'Students need to read the graph as motion, not as decoration. At maximum displacement, velocity is zero and acceleration has maximum magnitude toward equilibrium. At equilibrium, displacement is zero, acceleration is zero for ideal SHM, and speed is maximum. Changing amplitude changes maximum displacement and speed/energy, but not the period of ideal SHM.',
    'Points are earned by identifying amplitude and period from the graph, mapping maxima/minima/zeros to physical states, and explaining signs from displacement relative to equilibrium. Many wrong answers come from treating taller waves as slower waves instead of reading the horizontal cycle spacing.',
    'Use the position graph as the anchor: amplitude is maximum displacement, one cycle gives period, and velocity is greatest as the oscillator passes equilibrium.',
    'Two position-time graphs for the same spring-object system have the same horizontal spacing between peaks, but one has twice the amplitude. Which graph has the larger period?',
    'The larger-amplitude graph has the larger period because the object travels farther.',
    'The periods are the same because the horizontal spacing between identical points in the cycle is the same. For ideal SHM of the same spring-object system, changing amplitude does not change the period. The larger-amplitude motion has greater total energy and can have greater maximum speed, but the cycle time is unchanged.',
    'Reading a large amplitude as a longer period even though changing amplitude does not change period for SHM.',
    'Back in practice, measure period horizontally and amplitude vertically. Mixing those two readings is the fastest way to lose the graph point.'
  ),
  (
    'ap_physics_1', 7, '7.4', 'Energy of Simple Harmonic Oscillators',
    'Energy in ideal SHM is conserved while changing form. At turning points the oscillator has maximum potential energy and zero kinetic energy; at equilibrium, kinetic energy is maximum and spring potential energy is minimum.',
    'Students need to avoid treating momentary rest as energy loss. When speed is zero at a turning point, the energy is stored as potential energy. For a spring-object oscillator, total energy equals 1/2 k A^2, so changing amplitude changes total energy even though it does not change period.',
    'Points come from applying total-energy conservation to compare positions in the cycle, identifying where K and U are maximum or minimum, and using E_total = 1/2 k A^2 for spring-object amplitude comparisons.',
    'Mark turning points and equilibrium first; at turning points K = 0 and U is maximum, while at equilibrium spring PE is minimum and K is maximum.',
    'A spring-object oscillator has amplitude A. If the amplitude is doubled while the same spring is used, what happens to the total mechanical energy?',
    'The energy doubles because the object moves twice as far from equilibrium.',
    'For a spring-object oscillator, total energy is E_total = 1/2 k A^2. If amplitude becomes 2A, the total energy becomes 1/2 k (2A)^2 = 4(1/2 k A^2). The energy quadruples. The squared amplitude is the key point.',
    'Saying energy is lost at the turning point because the oscillator momentarily stops.',
    'In practice, pair each position with the energy form: turning point means K is zero and U is largest; equilibrium means speed and K are largest.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 7 Oscillations; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 7: SHM restoring force proportional to displacement and opposite displacement, T=1/f, spring-object period, small-angle pendulum period, sinusoidal representations, amplitude-independent period behavior, graphical extrema/zeros, and oscillator energy exchange with E_total=1/2 k A^2 for springs; batch 2026-08-25-ap-physics-1-unit7-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_1', 7, '7.1', 'Defining Simple Harmonic Motion (SHM)',
    'SHM is not just repeated motion. It is the special case where displacement from equilibrium creates a restoring force back toward equilibrium, and the restoring-force magnitude is proportional to how far the object is displaced.',
    'Students need to separate periodic motion from simple harmonic motion. A system can repeat without being SHM; to justify SHM, the force or torque must pull toward equilibrium and scale with displacement. For a spring, this leads to ma_x = -k delta x. For a small-angle pendulum, the restoring torque is proportional to angular displacement.',
    'Points come from naming equilibrium, assigning displacement from that equilibrium, and explaining the restoring interaction with the correct direction and proportionality. The negative sign in the SHM relationship means acceleration points opposite displacement, not merely that the object is moving left.',
    'Start by marking equilibrium, then state that the restoring force points opposite displacement and grows with distance from equilibrium.',
    'A cart attached to a spring is pulled to the right of equilibrium and released. What must be true about the spring force for the motion to be modeled as SHM?',
    'The spring force has to make the cart move back and forth, so any changing force works.',
    'The spring force must be a restoring force: when the cart is to the right of equilibrium, the force is to the left, and its magnitude is proportional to the displacement from equilibrium. That is the SHM condition. The back-and-forth motion alone is not enough; the force relationship is what makes the motion simple harmonic.',
    'Calling any back-and-forth periodic motion SHM without showing a proportional restoring force.',
    'Back in practice, write two checks before using SHM equations: direction toward equilibrium and magnitude proportional to displacement.'
  ),
  (
    'ap_physics_1', 7, '7.2', 'Frequency and Period of SHM',
    'Period and frequency are reciprocals: T = 1/f. For common AP Physics 1 oscillators, the period depends on the system model: T_s = 2 pi sqrt(m/k) for a spring-object oscillator and T_p = 2 pi sqrt(L/g) for a small-angle pendulum.',
    'Students need to choose the formula from the physical oscillator, not from whatever variables appear in the prompt. A heavier spring-object oscillator has a longer period; a stiffer spring has a shorter period. A longer small-angle pendulum has a longer period. Amplitude is not part of either ideal SHM period formula.',
    'Points come from identifying one full cycle, converting between T and f, and using proportional reasoning from the correct period equation. If the question asks what happens when a variable changes, the formula should drive the comparison.',
    'Identify the oscillator type first; use T_s = 2 pi sqrt(m/k) for a spring-object system and T_p = 2 pi sqrt(L/g) for a small-angle pendulum.',
    'A mass on a spring oscillates with period T. The mass is replaced by a mass four times as large, using the same spring. What happens to the period?',
    'The period becomes four times as large because the mass is four times as large.',
    'For a spring-object oscillator, T_s = 2 pi sqrt(m/k). If m becomes 4m and k is unchanged, the square-root factor becomes sqrt(4m/k) = 2 sqrt(m/k). The period doubles, not quadruples. The square root in the period formula is the scoring detail.',
    'Putting amplitude into the period formula or treating frequency and period as directly proportional.',
    'In practice, circle the oscillator type before substituting. Then compare variables inside the square root carefully.'
  ),
  (
    'ap_physics_1', 7, '7.3', 'Representing and Analyzing SHM',
    'SHM graphs carry position, timing, and force information at once. Position varies sinusoidally, amplitude is maximum displacement from equilibrium, period is the time for one full repeat, and velocity and acceleration have predictable zeros and extrema during the cycle.',
    'Students need to read the graph as motion, not as decoration. At maximum displacement, velocity is zero and acceleration has maximum magnitude toward equilibrium. At equilibrium, displacement is zero, acceleration is zero for ideal SHM, and speed is maximum. Changing amplitude changes maximum displacement and speed/energy, but not the period of ideal SHM.',
    'Points are earned by identifying amplitude and period from the graph, mapping maxima/minima/zeros to physical states, and explaining signs from displacement relative to equilibrium. Many wrong answers come from treating taller waves as slower waves instead of reading the horizontal cycle spacing.',
    'Use the position graph as the anchor: amplitude is maximum displacement, one cycle gives period, and velocity is greatest as the oscillator passes equilibrium.',
    'Two position-time graphs for the same spring-object system have the same horizontal spacing between peaks, but one has twice the amplitude. Which graph has the larger period?',
    'The larger-amplitude graph has the larger period because the object travels farther.',
    'The periods are the same because the horizontal spacing between identical points in the cycle is the same. For ideal SHM of the same spring-object system, changing amplitude does not change the period. The larger-amplitude motion has greater total energy and can have greater maximum speed, but the cycle time is unchanged.',
    'Reading a large amplitude as a longer period even though changing amplitude does not change period for SHM.',
    'Back in practice, measure period horizontally and amplitude vertically. Mixing those two readings is the fastest way to lose the graph point.'
  ),
  (
    'ap_physics_1', 7, '7.4', 'Energy of Simple Harmonic Oscillators',
    'Energy in ideal SHM is conserved while changing form. At turning points the oscillator has maximum potential energy and zero kinetic energy; at equilibrium, kinetic energy is maximum and spring potential energy is minimum.',
    'Students need to avoid treating momentary rest as energy loss. When speed is zero at a turning point, the energy is stored as potential energy. For a spring-object oscillator, total energy equals 1/2 k A^2, so changing amplitude changes total energy even though it does not change period.',
    'Points come from applying total-energy conservation to compare positions in the cycle, identifying where K and U are maximum or minimum, and using E_total = 1/2 k A^2 for spring-object amplitude comparisons.',
    'Mark turning points and equilibrium first; at turning points K = 0 and U is maximum, while at equilibrium spring PE is minimum and K is maximum.',
    'A spring-object oscillator has amplitude A. If the amplitude is doubled while the same spring is used, what happens to the total mechanical energy?',
    'The energy doubles because the object moves twice as far from equilibrium.',
    'For a spring-object oscillator, total energy is E_total = 1/2 k A^2. If amplitude becomes 2A, the total energy becomes 1/2 k (2A)^2 = 4(1/2 k A^2). The energy quadruples. The squared amplitude is the key point.',
    'Saying energy is lost at the turning point because the oscillator momentarily stops.',
    'In practice, pair each position with the energy form: turning point means K is zero and U is largest; equilibrium means speed and K are largest.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 7 Oscillations; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 7: SHM restoring force proportional to displacement and opposite displacement, T=1/f, spring-object period, small-angle pendulum period, sinusoidal representations, amplitude-independent period behavior, graphical extrema/zeros, and oscillator energy exchange with E_total=1/2 k A^2 for springs; batch 2026-08-25-ap-physics-1-unit7-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 7
    and topic_code in ('7.1', '7.2', '7.3', '7.4')
    and status = 'published';

  if v_briefs <> 4 then
    raise exception 'expected 4 published AP Physics 1 Unit 7 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_1'
    and unit_number = 7
    and topic_code in ('7.1', '7.2', '7.3', '7.4')
    and status = 'published';

  if v_explainers <> 4 then
    raise exception 'expected 4 published AP Physics 1 Unit 7 explainers, got %', v_explainers;
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
      and b.unit_number = 7
      and b.topic_code in ('7.1', '7.2', '7.3', '7.4')
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
      and e.unit_number = 7
      and e.topic_code in ('7.1', '7.2', '7.3', '7.4')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 7 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('7.1', '7.2', '7.3', '7.4')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 7 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_1'
    and b.unit_number = 7
    and b.topic_code in ('7.1', '7.2', '7.3', '7.4')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-1/unit-7/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 7 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('7.1', '7.2', '7.3', '7.4')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 7 core_idea/what_it_is matches, got %', v_core_matches;
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
      and unit_number = 7
      and topic_code in ('7.1', '7.2', '7.3', '7.4')
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
      and e.unit_number = 7
      and e.topic_code in ('7.1', '7.2', '7.3', '7.4')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 7 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
