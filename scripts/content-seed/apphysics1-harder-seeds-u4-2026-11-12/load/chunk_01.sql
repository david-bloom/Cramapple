begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b4-h-4.1-a','apphysics1-mcq-b4-sv-h-4.1-a-v1','apphysics1-mcq-b4-sv-h-4.1-a-v2','apphysics1-mcq-b4-sv-h-4.1-a-v3','apphysics1-mcq-b4-h-4.1-b','apphysics1-mcq-b4-sv-h-4.1-b-v1','apphysics1-mcq-b4-sv-h-4.1-b-v2','apphysics1-mcq-b4-sv-h-4.1-b-v3','apphysics1-mcq-b4-h-4.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apphysics1-mcq-b4-h-4.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-h-4.1-a', 'mcq', 'compare momentum and kinetic energy of two moving objects to predict stopping time and stopping distance', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cart X has mass 2 kg and moves at 6 m/s. Cart Y has mass 6 kg and moves at 2 m/s. Each cart is brought to rest by the same constant braking force. Which statement is correct?', null, md5('apphysics1-mcq-b4-h-4.1-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both stop in the same time and travel the same distance, because their momenta are equal.', false, 'Equal momentum (12 kg·m/s each) does give equal stopping times, but the distance depends on kinetic energy, which is 36 J for X and only 12 J for Y.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Y takes three times as long to stop and travels farther, because it has more mass.', false, 'Mass alone does not set the stopping time. The impulse needed is the momentum, 12 kg·m/s for both carts, so with the same force the times are equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X takes three times as long to stop and travels three times as far, because it moves three times as fast.', false, 'This uses speed alone and ignores mass. The momenta are equal, so the stopping times are equal even though the distance ratio of three is right.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both stop in the same time, but X travels three times as far.', true, 'Correct: p = mv = 12 kg·m/s for both, so t = p/F is the same. Work-energy: F·d = KE; KE_X = ½(2)(36) = 36 J, KE_Y = ½(6)(4) = 12 J, so d_X = 3 d_Y.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.1-a-v1', 'mcq', 'compare momentum and kinetic energy of two moving objects to predict stopping time and stopping distance (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Block P has mass 3 kg and moves at 8 m/s. Block Q has mass 12 kg and moves at 2 m/s. Each block is brought to rest by the same constant force. Which statement is correct?', null, md5('apphysics1-mcq-b4-sv-h-4.1-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both stop in the same time and travel the same distance, because their momenta are equal.', false, 'Equal momentum (24 kg·m/s each) gives equal stopping times only. The stopping distance depends on kinetic energy, 96 J for P versus 24 J for Q.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Q takes four times as long to stop and travels farther, because it has four times the mass.', false, 'The stopping time depends on momentum, not mass alone. Both blocks have 24 kg·m/s, so the same force stops them in the same time.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P takes four times as long to stop and travels four times as far, because it moves four times as fast.', false, 'This counts speed but ignores mass in the momentum. The momenta are equal so the times are equal, although the distance ratio of four is right.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both stop in the same time, but P travels four times as far.', true, 'Correct: p = 24 kg·m/s for both, so t = p/F is equal. KE_P = ½(3)(64) = 96 J, KE_Q = ½(12)(4) = 24 J, and d = KE/F gives d_P = 4 d_Q.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.1-a-v2', 'mcq', 'compare momentum and kinetic energy of two moving objects to predict stopping time and stopping distance (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 500 kg car moves at 12 m/s and a 1500 kg truck moves at 4 m/s. Each is brought to rest over the same stopping distance by a constant braking force. How do the braking forces compare?', null, md5('apphysics1-mcq-b4-sv-h-4.1-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The forces are equal, because the car and truck have the same momentum.', false, 'Equal momentum means equal impulse, which fixes the stopping time for equal forces. Over the same distance the force depends on kinetic energy, 36000 J for the car versus 12000 J.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The force on the car is three times the force on the truck.', true, 'Correct: F·d = KE for each. KE_car = ½(500)(144) = 36000 J, KE_truck = ½(1500)(16) = 12000 J. With equal d, F_car/F_truck = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The force on the truck is three times the force on the car, because the truck has three times the mass.', false, 'Greater mass does not mean greater force here. F = KE/d and the car has three times the kinetic energy, so the car needs the larger force.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The force on the car is nine times the force on the truck, because the car is three times as fast.', false, 'This squares the speed ratio but ignores the masses. KE depends on mv², and the truck''s mass of three times offsets part of it, leaving a ratio of three.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.1-a-v3', 'mcq', 'compare momentum and kinetic energy of two moving objects to predict stopping time and stopping distance (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Block P has mass 1 kg and moves at 8 m/s. Block Q has mass 4 kg and moves at 4 m/s. The same constant force brings each block to rest. Which statement is correct?', null, md5('apphysics1-mcq-b4-sv-h-4.1-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q takes twice as long to stop, and both blocks travel the same distance.', true, 'Correct: KE_P = ½(1)(64) = 32 J, KE_Q = ½(4)(16) = 32 J, so d = KE/F is equal. p_P = 8, p_Q = 16 kg·m/s, so t = p/F is twice as long for Q.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both blocks stop in the same time and travel the same distance, because their kinetic energies are equal.', false, 'Equal kinetic energy (32 J each) gives equal stopping distances, but the momenta differ (8 versus 16 kg·m/s), so the stopping times are not equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P takes twice as long to stop, and both blocks travel the same distance.', false, 'This reverses the time comparison. Q has twice the momentum (16 versus 8 kg·m/s), so it needs twice the impulse and takes longer.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q takes twice as long to stop and travels twice as far, because it has twice the momentum.', false, 'Time does follow momentum, but the distance follows kinetic energy, which is equal (32 J each). The distance is therefore the same for both blocks.' from version_ins;
-- apphysics1-mcq-b4-h-4.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-h-4.1-b', 'mcq', 'find the velocity of the center of mass of a system with signed momenta, and recognize that an internal collision does n', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three carts ride on a frictionless horizontal track. Cart 1 (2 kg) moves at +3 m/s, cart 2 (1 kg) moves at −2 m/s and cart 3 (1 kg) moves at +4 m/s. Carts 2 and 3 collide and stick together before anything else happens. What is the velocity of the center of mass of the three-cart system after that collision?', null, md5('apphysics1-mcq-b4-h-4.1-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+1.0 m/s', false, 'This is the velocity of the stuck pair alone (carts 2 and 3 have total momentum +2 kg·m/s and mass 2 kg). The center of mass of the whole system includes cart 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '+1.67 m/s', false, 'This averages the three velocities without weighting by mass. The center of mass velocity is total momentum divided by total mass.' from version_ins
union all select gen_random_uuid(), id, 'C', '+2.0 m/s', true, 'Correct: Total p = 2(3) + 1(−2) + 1(4) = +8 kg·m/s, M = 4 kg, so v_cm = +2.0 m/s. The collision between carts 2 and 3 is internal, so v_cm is the same before and after.' from version_ins
union all select gen_random_uuid(), id, 'D', '+3.0 m/s', false, 'This adds the momenta as if all were positive, ignoring that cart 2 moves in the negative direction, then divides by the total mass of 4 kg.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.1-b-v1', 'mcq', 'find the velocity of the center of mass of a system with signed momenta, and recognize that an internal collision does n (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three skaters glide on frictionless ice. Skater 1 (50 kg) moves at +2 m/s, skater 2 (30 kg) moves at −3 m/s and skater 3 (20 kg) moves at +1 m/s. Skaters 2 and 3 push off each other, and nobody else is touched. What is the velocity of the center of mass of the three-skater system after the push?', null, md5('apphysics1-mcq-b4-sv-h-4.1-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1.4 m/s', false, 'This is the center of mass velocity of skaters 2 and 3 only (total momentum −70 kg·m/s, mass 50 kg). Skater 1 must be included in the system.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.0 m/s', false, 'This averages the three velocities, (2 − 3 + 1)/3 = 0, without weighting by mass, and so does not give the true center of mass velocity.' from version_ins
union all select gen_random_uuid(), id, 'C', '+0.30 m/s', true, 'Correct: Total p = 50(2) + 30(−3) + 20(1) = 100 − 90 + 20 = +30 kg·m/s. M = 100 kg, so v_cm = +0.30 m/s. The push is an internal interaction and does not change it.' from version_ins
union all select gen_random_uuid(), id, 'D', '+2.1 m/s', false, 'This adds the magnitudes of the momenta as if all were positive, giving 210 kg·m/s, and divides by 100 kg. Signs must be kept for momentum.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.1-b-v2', 'mcq', 'find the velocity of the center of mass of a system with signed momenta, and recognize that an internal collision does n (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three pucks slide on a frictionless air table. Puck 1 (0.4 kg) moves at +5 m/s, puck 2 (0.2 kg) moves at −10 m/s and puck 3 (0.4 kg) moves at +2.5 m/s. Pucks 1 and 2 collide elastically before anything else happens. What is the velocity of the center of mass of the three-puck system after that collision?', null, md5('apphysics1-mcq-b4-sv-h-4.1-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+1.0 m/s', true, 'Correct: Total p = 0.4(5) + 0.2(−10) + 0.4(2.5) = 2 − 2 + 1 = +1 kg·m/s; M = 1.0 kg; v_cm = +1.0 m/s, unchanged by the internal collision.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 m/s', false, 'Pucks 1 and 2 have a total momentum of zero, but puck 3 is also part of the system and carries +1 kg·m/s, so the system as a whole is not at rest.' from version_ins
union all select gen_random_uuid(), id, 'C', '−0.83 m/s', false, 'This averages the velocities without weighting by mass. The center of mass velocity is total momentum divided by total mass.' from version_ins
union all select gen_random_uuid(), id, 'D', '+5.0 m/s', false, 'This adds the magnitudes of the three momenta (2 + 2 + 1 kg·m/s) and divides by the total mass of 1 kg. The momentum of puck 2 is negative and must subtract.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.1-b-v3', 'mcq', 'find the velocity of the center of mass of a system with signed momenta, and recognize that an internal collision does n (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three blocks slide on a frictionless track. Block 1 (1 kg) moves at +6 m/s, block 2 (3 kg) moves at −2 m/s and block 3 (2 kg) moves at +3 m/s. Blocks 2 and 3 collide and stick together before anything else happens. What is the velocity of the center of mass of the three-block system after that collision?', null, md5('apphysics1-mcq-b4-sv-h-4.1-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 m/s', false, 'Blocks 2 and 3 have total momentum of zero, so the stuck pair stops, but block 1 is part of the system and still carries +6 kg·m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '+1.0 m/s', true, 'Correct: Total p = 1(6) + 3(−2) + 2(3) = 6 − 6 + 6 = +6 kg·m/s; M = 6 kg; v_cm = +1.0 m/s, the same before and after the internal collision.' from version_ins
union all select gen_random_uuid(), id, 'C', '+2.3 m/s', false, 'This averages the three velocities without weighting by mass. The center of mass velocity must be total momentum divided by total mass.' from version_ins
union all select gen_random_uuid(), id, 'D', '+3.0 m/s', false, 'This adds the magnitudes of the momenta, 6 + 6 + 6 = 18 kg·m/s, and divides by 6 kg. Block 2 moves in the negative direction, so its momentum subtracts.' from version_ins;
-- apphysics1-mcq-b4-h-4.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-h-4.2-a', 'mcq', 'use the area under a force-time record with a sign change and the initial velocity to find a final velocity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2 kg cart moves along a frictionless track with an initial velocity of −3 m/s. The net force on it, along the track, is +8 N from t = 0 to t = 3 s and then −5 N from t = 3 s to t = 7 s. What is the velocity of the cart at t = 7 s?', null, md5('apphysics1-mcq-b4-h-4.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1 m/s', true, 'Correct: J = (+8)(3) + (−5)(4) = 24 − 20 = +4 N·s. Δv = J/m = +2 m/s. v_f = −3 + 2 = −1 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '+2 m/s', false, 'This finds the velocity change, J/m = +2 m/s, but treats the cart as starting from rest instead of adding the initial velocity of −3 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '+5 m/s', false, 'This finds the +2 m/s change but adds it to +3 m/s, dropping the negative sign of the initial velocity. Momentum and velocity are signed quantities.' from version_ins
union all select gen_random_uuid(), id, 'D', '+1 m/s', false, 'This adds the net impulse of +4 N·s directly to the initial velocity without dividing by the 2 kg mass, giving 4 − 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b4-h-4.1-a','apphysics1-mcq-b4-sv-h-4.1-a-v1','apphysics1-mcq-b4-sv-h-4.1-a-v2','apphysics1-mcq-b4-sv-h-4.1-a-v3','apphysics1-mcq-b4-h-4.1-b','apphysics1-mcq-b4-sv-h-4.1-b-v1','apphysics1-mcq-b4-sv-h-4.1-b-v2','apphysics1-mcq-b4-sv-h-4.1-b-v3','apphysics1-mcq-b4-h-4.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b4-h-4.1-a','apphysics1-mcq-b4-sv-h-4.1-a-v1','apphysics1-mcq-b4-sv-h-4.1-a-v2','apphysics1-mcq-b4-sv-h-4.1-a-v3','apphysics1-mcq-b4-h-4.1-b','apphysics1-mcq-b4-sv-h-4.1-b-v1','apphysics1-mcq-b4-sv-h-4.1-b-v2','apphysics1-mcq-b4-sv-h-4.1-b-v3','apphysics1-mcq-b4-h-4.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
