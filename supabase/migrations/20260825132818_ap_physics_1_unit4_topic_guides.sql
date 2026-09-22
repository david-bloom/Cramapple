begin;

-- Add AP Physics 1 Unit 4 topic-guide pairs.
--
-- Production coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 4 AP Physics 1 Unit 4 topics and 0 published point
-- briefs/explainers for the unit.
--
-- Grounding: docs/product/AP_PHYSICS_1_CED_FACT_PACK.md Unit 4 (Linear
-- Momentum). The fact pack confirms p = mv as a vector, impulse as change in
-- momentum and area under a net-force-vs-time graph, conservation of system
-- momentum when net external impulse is zero, center-of-mass velocity
-- invariance, AP Physics 1's 1-D quantitative / 2-D semiquantitative boundary,
-- and the elastic/inelastic/perfectly-inelastic distinction.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_physics_1', 4, '4.1', 'Linear Momentum',
    'very-important', 'very-important',
    'Linear momentum is p = mv: mass times velocity. Because velocity is a vector, momentum is also a vector in the same direction as the object velocity.',
    'Momentum is the language of collisions and explosions. It lets you compare motion before and after a short interaction where internal forces dominate and external forces can often be ignored.',
    'You earn points by computing momentum with velocity signs or directions, summing system momentum as a vector quantity, and recognizing that momentum is linear momentum unless the prompt says otherwise.',
    'Set a positive direction before writing p = mv; then attach that sign or direction to each object momentum before adding system totals.',
    'Adding momentum magnitudes and losing the direction of one object motion.',
    '/learn/ap-physics-1/unit-4/linear-momentum'
  ),
  (
    'ap_physics_1', 4, '4.2', 'Change in Momentum and Impulse',
    'very-important', 'very-important',
    'Impulse is the change in momentum: J = delta p = F_avg delta t. On a net-force-versus-time graph, impulse is the signed area under the curve.',
    'Impulse connects force-time details to momentum change. It is why a small force over a long time and a large force over a short time can produce the same change in motion.',
    'You earn points by calculating delta p as final momentum minus initial momentum, finding impulse from average force times time or graph area, and matching impulse direction to net force direction.',
    'Write delta p = p_f - p_i before using any impulse equation; if a force-time graph is given, find signed area instead of multiplying one force reading by total time.',
    'Using p = Ft as if momentum equals force times time, instead of impulse or change in momentum equaling force-time area.',
    '/learn/ap-physics-1/unit-4/change-in-momentum-and-impulse'
  ),
  (
    'ap_physics_1', 4, '4.3', 'Conservation of Linear Momentum',
    'very-important', 'very-important',
    'Total momentum of a chosen system stays constant when the net external impulse on that system is zero. Internal forces can exchange momentum between objects but cannot change the system total.',
    'This is the core collision rule. Correct system choice determines whether momentum is conserved, and center-of-mass motion stays constant when no net external force acts.',
    'You earn points by defining the system, checking external impulse, summing initial and final momentum with signs, and using conservation only for the selected system.',
    'Draw a boundary around the system first; if the net external impulse is zero, set total initial momentum equal to total final momentum and keep directions signed.',
    'Saying momentum is conserved for one object during a collision instead of for the whole interacting system.',
    '/learn/ap-physics-1/unit-4/conservation-of-linear-momentum'
  ),
  (
    'ap_physics_1', 4, '4.4', 'Elastic and Inelastic Collisions',
    'very-important', 'very-important',
    'Collisions are classified by kinetic energy behavior. Elastic collisions conserve system kinetic energy; inelastic collisions do not; perfectly inelastic collisions are the special case where objects stick together and share one final velocity.',
    'The exam often asks you to combine momentum conservation with an energy comparison. Momentum can be conserved in both elastic and inelastic collisions, but kinetic energy separates the categories.',
    'You earn points by conserving momentum for the system, checking whether total kinetic energy is the same before and after, and identifying perfectly inelastic collisions from shared final motion.',
    'Use momentum conservation to find or compare final velocities, then separately compare total kinetic energy to classify the collision; do not use kinetic-energy conservation unless the collision is elastic.',
    'Assuming momentum is not conserved in inelastic collisions because kinetic energy decreases.',
    '/learn/ap-physics-1/unit-4/elastic-and-inelastic-collisions'
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
    'ap_physics_1', 4, '4.1', 'Linear Momentum',
    'Momentum is mass times velocity, so it inherits velocity direction. A 2 kg cart moving left and a 2 kg cart moving right have equal momentum magnitudes but opposite momentum vectors if right is chosen positive.',
    'Students need to treat momentum as a signed or directional quantity from the first line of work. The word momentum means linear momentum unless the prompt explicitly shifts to angular momentum in a later unit.',
    'Points come from setting a direction convention, computing each p = mv with that sign, and adding momenta as vector quantities. In collision setups, that signed total is the quantity that may stay constant for the system.',
    'Set a positive direction before writing p = mv; then attach that sign or direction to each object momentum before adding system totals.',
    'Cart A has mass 2 kg and moves right at 3 m/s. Cart B has mass 1 kg and moves left at 6 m/s. If right is positive, what is the total momentum of the two-cart system?',
    'Both carts have momentum 6 kg m/s, so the total momentum is 12 kg m/s.',
    'Cart A has p_A = (2)(+3) = +6 kg m/s. Cart B has p_B = (1)(-6) = -6 kg m/s because it moves left. The total system momentum is +6 + (-6) = 0 kg m/s. The equal magnitudes cancel because momentum is a vector; adding magnitudes alone gives the wrong system total.',
    'Adding momentum magnitudes and losing the direction of one object motion.',
    'Back in practice, write a sign on every velocity before multiplying by mass. Momentum errors usually start before the multiplication, not after it.'
  ),
  (
    'ap_physics_1', 4, '4.2', 'Change in Momentum and Impulse',
    'Impulse is not a new kind of momentum; it is the transfer that changes momentum. For a constant average net force, J = F_avg delta t; for a changing net force, J is the signed area under the net-force-versus-time graph.',
    'Students need to connect three equivalent ideas: impulse, change in momentum, and force-time area. The force direction sets the impulse direction, and delta p must be final momentum minus initial momentum.',
    'Points come from computing delta p with signs, reading or estimating area under a force-time graph, and recognizing that Newtons times seconds are the same momentum units as kg m/s.',
    'Write delta p = p_f - p_i before using any impulse equation; if a force-time graph is given, find signed area instead of multiplying one force reading by total time.',
    'A 0.50 kg cart moving right at 4 m/s is brought to rest by a leftward net force. What impulse acts on the cart if right is positive?',
    'The impulse is (0.50)(4) = +2 kg m/s because the cart had that much momentum at first.',
    'Initial momentum is p_i = (0.50)(+4) = +2 kg m/s. Final momentum is p_f = 0 because the cart stops. Delta p = p_f - p_i = 0 - 2 = -2 kg m/s, so the impulse is -2 N s. The negative sign matters: the impulse is leftward, opposite the cart initial motion.',
    'Using p = Ft as if momentum equals force times time, instead of impulse or change in momentum equaling force-time area.',
    'In practice, write both p_i and p_f, then subtract. If you jump straight to force times time, it is easy to miss the sign and the fact that impulse is a change.'
  ),
  (
    'ap_physics_1', 4, '4.3', 'Conservation of Linear Momentum',
    'Momentum conservation is a system claim. During a collision, each object can experience a large impulse from the other object, but those impulses are equal and opposite inside the system. If external impulse is negligible, the system total momentum stays constant.',
    'Students need to choose the system boundary before writing a conservation equation. One object momentum usually changes; the two-object system momentum can remain constant. Center-of-mass velocity also remains constant when no net external force acts.',
    'Points are earned by identifying the conserved system, summing initial and final momenta with signs, and using conservation for immediately-before and immediately-after states of a collision or explosion.',
    'Draw a boundary around the system first; if the net external impulse is zero, set total initial momentum equal to total final momentum and keep directions signed.',
    'Two carts collide on a nearly frictionless track. Cart A slows down during the collision. A student says momentum was not conserved because Cart A lost momentum. Evaluate the claim.',
    'The student is right because if one cart loses momentum, conservation has been broken.',
    'The claim confuses one object with the system. Cart A can lose momentum while Cart B gains the same amount of momentum from the equal-and-opposite interaction impulse. If the two carts are the system and external impulse from friction is negligible during the short collision, total system momentum before the collision equals total system momentum after the collision. Momentum conservation applies to the selected system, not to each object separately.',
    'Saying momentum is conserved for one object during a collision instead of for the whole interacting system.',
    'Back in practice, write the system name in the conservation equation: p_system,before = p_system,after. That keeps object-level changes from masquerading as conservation failures.'
  ),
  (
    'ap_physics_1', 4, '4.4', 'Elastic and Inelastic Collisions',
    'Momentum conservation and kinetic-energy conservation answer different questions. Momentum can be conserved in elastic, inelastic, and perfectly inelastic collisions if external impulse is negligible; kinetic energy is conserved only in elastic collisions. Perfectly inelastic means the objects stick and share one final velocity.',
    'Students need to classify collisions after checking energy, not from whether momentum was conserved. The 2024 AP Physics 1 collision evidence highlights this: many students missed that the center-of-mass motion can be identical in elastic and inelastic versions of the same isolated collision.',
    'Points come from first using momentum conservation to determine final motion, then comparing total kinetic energy before and after. If objects stick together, one final velocity is required, but the system momentum equation still applies.',
    'Use momentum conservation to find or compare final velocities, then separately compare total kinetic energy to classify the collision; do not use kinetic-energy conservation unless the collision is elastic.',
    'Two carts stick together after colliding on a nearly frictionless track. A student says momentum cannot be conserved because kinetic energy is lost. What is wrong with that reasoning?',
    'The student is right: if kinetic energy is lost, momentum must be lost too.',
    'Kinetic energy and momentum are different system quantities. In a perfectly inelastic collision, some kinetic energy is transformed into other forms, so total kinetic energy decreases. But if the track is nearly frictionless and external impulse is negligible, total system momentum is still conserved. The stuck-together final velocity is found from momentum conservation, not from kinetic-energy conservation.',
    'Assuming momentum is not conserved in inelastic collisions because kinetic energy decreases.',
    'In practice, separate the two tests: first ask whether external impulse is negligible for momentum, then ask whether total kinetic energy stayed the same for collision type.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 4 Linear Momentum; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 4: p=mv vector momentum, impulse-momentum theorem and force-time graph area, conservation of total system momentum under zero net external impulse, AP Physics 1 one-dimensional quantitative/two-dimensional semiquantitative boundary, center-of-mass invariance, and elastic/inelastic/perfectly-inelastic collision distinctions; batch 2026-08-25-ap-physics-1-unit4-topic-guides; author=reviewer same session, no independent human review yet',
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
    'ap_physics_1', 4, '4.1', 'Linear Momentum',
    'Momentum is mass times velocity, so it inherits velocity direction. A 2 kg cart moving left and a 2 kg cart moving right have equal momentum magnitudes but opposite momentum vectors if right is chosen positive.',
    'Students need to treat momentum as a signed or directional quantity from the first line of work. The word momentum means linear momentum unless the prompt explicitly shifts to angular momentum in a later unit.',
    'Points come from setting a direction convention, computing each p = mv with that sign, and adding momenta as vector quantities. In collision setups, that signed total is the quantity that may stay constant for the system.',
    'Set a positive direction before writing p = mv; then attach that sign or direction to each object momentum before adding system totals.',
    'Cart A has mass 2 kg and moves right at 3 m/s. Cart B has mass 1 kg and moves left at 6 m/s. If right is positive, what is the total momentum of the two-cart system?',
    'Both carts have momentum 6 kg m/s, so the total momentum is 12 kg m/s.',
    'Cart A has p_A = (2)(+3) = +6 kg m/s. Cart B has p_B = (1)(-6) = -6 kg m/s because it moves left. The total system momentum is +6 + (-6) = 0 kg m/s. The equal magnitudes cancel because momentum is a vector; adding magnitudes alone gives the wrong system total.',
    'Adding momentum magnitudes and losing the direction of one object motion.',
    'Back in practice, write a sign on every velocity before multiplying by mass. Momentum errors usually start before the multiplication, not after it.'
  ),
  (
    'ap_physics_1', 4, '4.2', 'Change in Momentum and Impulse',
    'Impulse is not a new kind of momentum; it is the transfer that changes momentum. For a constant average net force, J = F_avg delta t; for a changing net force, J is the signed area under the net-force-versus-time graph.',
    'Students need to connect three equivalent ideas: impulse, change in momentum, and force-time area. The force direction sets the impulse direction, and delta p must be final momentum minus initial momentum.',
    'Points come from computing delta p with signs, reading or estimating area under a force-time graph, and recognizing that Newtons times seconds are the same momentum units as kg m/s.',
    'Write delta p = p_f - p_i before using any impulse equation; if a force-time graph is given, find signed area instead of multiplying one force reading by total time.',
    'A 0.50 kg cart moving right at 4 m/s is brought to rest by a leftward net force. What impulse acts on the cart if right is positive?',
    'The impulse is (0.50)(4) = +2 kg m/s because the cart had that much momentum at first.',
    'Initial momentum is p_i = (0.50)(+4) = +2 kg m/s. Final momentum is p_f = 0 because the cart stops. Delta p = p_f - p_i = 0 - 2 = -2 kg m/s, so the impulse is -2 N s. The negative sign matters: the impulse is leftward, opposite the cart initial motion.',
    'Using p = Ft as if momentum equals force times time, instead of impulse or change in momentum equaling force-time area.',
    'In practice, write both p_i and p_f, then subtract. If you jump straight to force times time, it is easy to miss the sign and the fact that impulse is a change.'
  ),
  (
    'ap_physics_1', 4, '4.3', 'Conservation of Linear Momentum',
    'Momentum conservation is a system claim. During a collision, each object can experience a large impulse from the other object, but those impulses are equal and opposite inside the system. If external impulse is negligible, the system total momentum stays constant.',
    'Students need to choose the system boundary before writing a conservation equation. One object momentum usually changes; the two-object system momentum can remain constant. Center-of-mass velocity also remains constant when no net external force acts.',
    'Points are earned by identifying the conserved system, summing initial and final momenta with signs, and using conservation for immediately-before and immediately-after states of a collision or explosion.',
    'Draw a boundary around the system first; if the net external impulse is zero, set total initial momentum equal to total final momentum and keep directions signed.',
    'Two carts collide on a nearly frictionless track. Cart A slows down during the collision. A student says momentum was not conserved because Cart A lost momentum. Evaluate the claim.',
    'The student is right because if one cart loses momentum, conservation has been broken.',
    'The claim confuses one object with the system. Cart A can lose momentum while Cart B gains the same amount of momentum from the equal-and-opposite interaction impulse. If the two carts are the system and external impulse from friction is negligible during the short collision, total system momentum before the collision equals total system momentum after the collision. Momentum conservation applies to the selected system, not to each object separately.',
    'Saying momentum is conserved for one object during a collision instead of for the whole interacting system.',
    'Back in practice, write the system name in the conservation equation: p_system,before = p_system,after. That keeps object-level changes from masquerading as conservation failures.'
  ),
  (
    'ap_physics_1', 4, '4.4', 'Elastic and Inelastic Collisions',
    'Momentum conservation and kinetic-energy conservation answer different questions. Momentum can be conserved in elastic, inelastic, and perfectly inelastic collisions if external impulse is negligible; kinetic energy is conserved only in elastic collisions. Perfectly inelastic means the objects stick and share one final velocity.',
    'Students need to classify collisions after checking energy, not from whether momentum was conserved. The 2024 AP Physics 1 collision evidence highlights this: many students missed that the center-of-mass motion can be identical in elastic and inelastic versions of the same isolated collision.',
    'Points come from first using momentum conservation to determine final motion, then comparing total kinetic energy before and after. If objects stick together, one final velocity is required, but the system momentum equation still applies.',
    'Use momentum conservation to find or compare final velocities, then separately compare total kinetic energy to classify the collision; do not use kinetic-energy conservation unless the collision is elastic.',
    'Two carts stick together after colliding on a nearly frictionless track. A student says momentum cannot be conserved because kinetic energy is lost. What is wrong with that reasoning?',
    'The student is right: if kinetic energy is lost, momentum must be lost too.',
    'Kinetic energy and momentum are different system quantities. In a perfectly inelastic collision, some kinetic energy is transformed into other forms, so total kinetic energy decreases. But if the track is nearly frictionless and external impulse is negligible, total system momentum is still conserved. The stuck-together final velocity is found from momentum conservation, not from kinetic-energy conservation.',
    'Assuming momentum is not conserved in inelastic collisions because kinetic energy decreases.',
    'In practice, separate the two tests: first ask whether external impulse is negligible for momentum, then ask whether total kinetic energy stayed the same for collision type.'
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
  'cramapple-authored; new coverage 2026-08-25 for AP Physics 1 Unit 4 Linear Momentum; grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 4: p=mv vector momentum, impulse-momentum theorem and force-time graph area, conservation of total system momentum under zero net external impulse, AP Physics 1 one-dimensional quantitative/two-dimensional semiquantitative boundary, center-of-mass invariance, and elastic/inelastic/perfectly-inelastic collision distinctions; batch 2026-08-25-ap-physics-1-unit4-topic-guides; author=reviewer same session, no independent human review yet',
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
    and unit_number = 4
    and topic_code in ('4.1', '4.2', '4.3', '4.4')
    and status = 'published';

  if v_briefs <> 4 then
    raise exception 'expected 4 published AP Physics 1 Unit 4 briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_physics_1'
    and unit_number = 4
    and topic_code in ('4.1', '4.2', '4.3', '4.4')
    and status = 'published';

  if v_explainers <> 4 then
    raise exception 'expected 4 published AP Physics 1 Unit 4 explainers, got %', v_explainers;
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
      and b.unit_number = 4
      and b.topic_code in ('4.1', '4.2', '4.3', '4.4')
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
      and e.unit_number = 4
      and e.topic_code in ('4.1', '4.2', '4.3', '4.4')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 4 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('4.1', '4.2', '4.3', '4.4')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 4 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_physics_1'
    and b.unit_number = 4
    and b.topic_code in ('4.1', '4.2', '4.3', '4.4')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-physics-1/unit-4/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 4 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_physics_1'
    and b.topic_code in ('4.1', '4.2', '4.3', '4.4')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 4 core_idea/what_it_is matches, got %', v_core_matches;
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
      and unit_number = 4
      and topic_code in ('4.1', '4.2', '4.3', '4.4')
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
      and e.unit_number = 4
      and e.topic_code in ('4.1', '4.2', '4.3', '4.4')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 4 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
