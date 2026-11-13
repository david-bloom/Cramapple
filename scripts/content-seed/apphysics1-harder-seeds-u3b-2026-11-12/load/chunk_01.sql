begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-h-3.1-a','apphysics1-mcq-b2-sv-h-3.1-a-v1','apphysics1-mcq-b2-sv-h-3.1-a-v2','apphysics1-mcq-b2-sv-h-3.1-a-v3','apphysics1-mcq-b2-h-3.1-b','apphysics1-mcq-b2-sv-h-3.1-b-v1','apphysics1-mcq-b2-sv-h-3.1-b-v2','apphysics1-mcq-b2-sv-h-3.1-b-v3','apphysics1-mcq-b2-h-3.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apphysics1-mcq-b2-h-3.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.1-a', 'mcq', 'compare kinetic energies when both mass and speed differ, and avoid confusing kinetic energy with momentum or with speed', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4000 kg truck travels at 10 m/s and a 1000 kg car travels at 25 m/s. Which statement correctly compares their motion?', null, md5('apphysics1-mcq-b2-h-3.1-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The truck has the greater kinetic energy because it has the greater momentum.', false, 'The truck does have more momentum (40000 versus 25000 kg·m/s), but kinetic energy depends on mv², so the faster car wins.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The car has the greater kinetic energy, about 1.6 times that of the truck.', true, 'Correct: Truck K = ½(4000)(10²) = 200 kJ; car K = ½(1000)(25²) = 312.5 kJ; ratio 1.56. Truck momentum 40000 exceeds car momentum 25000, but momentum does not set kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The car has the greater kinetic energy, 2.5 times that of the truck.', false, 'A ratio of 2.5 is just the speed ratio; this ignores that the truck has four times the mass, which partly offsets the speed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The car has the greater kinetic energy, about 6 times that of the truck.', false, 'A ratio of 6.25 comes from squaring the speed ratio and ignoring the mass difference entirely.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.1-a-v1', 'mcq', 'compare kinetic energies when both mass and speed differ, and avoid confusing kinetic energy with momentum or with speed (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cart X has mass 2 kg and moves at 6 m/s. Cart Y has mass 6 kg and moves at 2 m/s, so the two carts have equal momentum. Which statement is correct?', null, md5('apphysics1-mcq-b2-sv-h-3.1-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both carts have the same kinetic energy because their momenta are equal.', false, 'Equal momentum does not imply equal kinetic energy; K = p²/2m, so the smaller mass has the larger K.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cart X has 3 times the kinetic energy of cart Y.', true, 'Correct: K_X = ½(2)(36) = 36 J; K_Y = ½(6)(4) = 12 J; the ratio is 3. Equal momentum with different mass means different kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cart Y has the greater kinetic energy because it has more mass.', false, 'Mass alone does not decide it; kinetic energy depends on v², and Y''s speed is only one third of X''s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cart X has 9 times the kinetic energy of cart Y.', false, 'A factor of 9 is the square of the speed ratio only; it forgets that Y has three times the mass.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.1-a-v2', 'mcq', 'compare kinetic energies when both mass and speed differ, and avoid confusing kinetic energy with momentum or with speed (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.2 kg ball is thrown at 30 m/s and a 0.8 kg ball is thrown at 15 m/s. Which statement is correct?', null, md5('apphysics1-mcq-b2-sv-h-3.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The balls have equal kinetic energy, and the heavier ball has the greater momentum.', true, 'Correct: K = ½(0.2)(900) = 90 J and ½(0.8)(225) = 90 J, equal. Momenta are 6 and 12 kg·m/s, so the heavier ball has more.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The faster ball has the greater kinetic energy.', false, 'The faster ball has four times the v² but only one quarter of the mass, so the two effects cancel in K.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The heavier ball has the greater kinetic energy and the greater momentum.', false, 'The heavier ball does have more momentum, but its kinetic energy is not larger; it equals the lighter ball''s 90 J.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The balls have equal kinetic energy and equal momentum.', false, 'The kinetic energies are equal, but the momenta are 6 and 12 kg·m/s, so they are not equal.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.1-a-v3', 'mcq', 'compare kinetic energies when both mass and speed differ, and avoid confusing kinetic energy with momentum or with speed (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1000 kg car accelerates from rest to 10 m/s, and later from 10 m/s to 20 m/s. Ignoring all resistance, how do the net work needed in the two stages compare?', null, md5('apphysics1-mcq-b2-sv-h-3.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The two stages need equal work because the speed increases by the same 10 m/s.', false, 'Work equals the change in kinetic energy, which depends on v², not on the size of the change in speed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The second stage needs twice as much work as the first.', false, 'A factor of 2 would match the final speed doubling, but K at 20 m/s minus K at 10 m/s is 150 kJ against 50 kJ.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The second stage needs 3 times as much work as the first.', true, 'Correct: Stage 1: ΔK = ½(1000)(100) = 50 kJ. Stage 2: ΔK = ½(1000)(400 − 100) = 150 kJ. Ratio 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The second stage needs 4 times as much work as the first.', false, 'A factor of 4 is the ratio of the final K values (200 kJ to 50 kJ), not the ratio of the two changes in K.' from version_ins;
-- apphysics1-mcq-b2-h-3.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.1-b', 'mcq', 'treat kinetic energy as a scalar: change in K depends on the speeds only, not on the direction change or the vector chan', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.40 kg ball strikes a wall at 10 m/s and rebounds along the same line at 6 m/s. What is the change in the ball''s kinetic energy?', null, md5('apphysics1-mcq-b2-h-3.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12.8 J', true, 'Correct: ΔK = ½(0.40)(6² − 10²) = 0.20(36 − 100) = −12.8 J; direction does not enter K.' from version_ins
union all select gen_random_uuid(), id, 'B', '+12.8 J', false, 'The sign is wrong; the ball ends with less speed, so its kinetic energy decreases and ΔK is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '+51.2 J', false, '51.2 J uses the change in velocity (−16 m/s) squared, treating velocity as if the vector difference sets ΔK.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3.2 J', false, '3.2 J uses the change in speed (4 m/s) squared; K depends on the square of each speed, not on the square of their difference.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.1-b-v1', 'mcq', 'treat kinetic energy as a scalar: change in K depends on the speeds only, not on the direction change or the vector chan (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg puck moves east at 4.0 m/s. After a collision it moves north at 3.0 m/s. What is its change in kinetic energy?', null, md5('apphysics1-mcq-b2-sv-h-3.1-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+7.0 J', false, 'The puck slows down, so ΔK cannot be positive; 7.0 J has the right size but the wrong sign.' from version_ins
union all select gen_random_uuid(), id, 'B', '+25 J', false, '25 J comes from taking the magnitude of the vector change in velocity (5 m/s) and squaring it; that is not how K changes.' from version_ins
union all select gen_random_uuid(), id, 'C', '−7.0 J', true, 'Correct: ΔK = ½(2.0)(3.0² − 4.0²) = −7.0 J. Only the speeds matter.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1.0 J', false, '1.0 J squares the change in speed (1 m/s) instead of subtracting the squares of the two speeds.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.1-b-v2', 'mcq', 'treat kinetic energy as a scalar: change in K depends on the speeds only, not on the direction change or the vector chan (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.25 kg ball moving at 8.0 m/s strikes a wall perpendicularly and rebounds at 8.0 m/s. Which statement about the ball is correct?', null, md5('apphysics1-mcq-b2-sv-h-3.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Its kinetic energy and its momentum are both unchanged.', false, 'Momentum is a vector; reversing the direction changes it from +2.0 to −2.0 kg·m/s even though the speed is the same.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Its kinetic energy increases by 32 J and its momentum is unchanged.', false, 'Kinetic energy does not increase; 32 J comes from squaring the vector velocity change of −16 m/s, which is not how K behaves.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Its kinetic energy is unchanged, but its momentum changes by 4.0 kg·m/s in magnitude.', true, 'Correct: K = ½(0.25)(64) = 8.0 J before and after, so ΔK = 0. Momentum goes from +2.0 to −2.0 kg·m/s, a change of 4.0 in magnitude.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Its kinetic energy decreases by 8.0 J and its momentum is unchanged.', false, 'Kinetic energy depends only on speed, which did not change, so K does not drop by 8.0 J; the momentum also does change.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.1-b-v3', 'mcq', 'treat kinetic energy as a scalar: change in K depends on the speeds only, not on the direction change or the vector chan (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3.0 kg object moves in a horizontal circle at a constant 5.0 m/s. During a quarter of a revolution its velocity changes direction by 90°. What is the net work done on the object during that quarter turn?', null, md5('apphysics1-mcq-b2-sv-h-3.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '37.5 J', false, '37.5 J is the value of K itself (½mv²), not a change in K; K did not change.' from version_ins
union all select gen_random_uuid(), id, 'B', '75 J', false, '75 J comes from using the size of the vector change in velocity (about 7.1 m/s) in ½mv²; kinetic energy depends on speed only.' from version_ins
union all select gen_random_uuid(), id, 'C', '−37.5 J', false, 'A negative net work would mean the object is slowing down, but its speed stays 5.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 J', true, 'Correct: Speed is constant, so ΔK = 0 and by the work-energy theorem the net work is 0 J (the net force is perpendicular to the motion).' from version_ins;
-- apphysics1-mcq-b2-h-3.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.2-a', 'mcq', 'find the work done by an individual force when several forces act and the object moves at constant speed or along an inc', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A crate is dragged 5.0 m across a rough floor at constant speed by a rope with tension 100 N directed 37° above the horizontal (cos 37° = 0.80). What is the work done on the crate by the friction force of the floor?', null, md5('apphysics1-mcq-b2-h-3.2-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−500 J', false, '500 J would be the rope''s work if the full tension acted along the motion; the rope''s horizontal component is only 80 N, so friction does −400 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 J', false, 'Friction does not do zero work; it opposes the motion, and zero net work comes from friction canceling the rope''s positive work.' from version_ins
union all select gen_random_uuid(), id, 'C', '−400 J', true, 'Correct: Constant speed means ΔK = 0, so net work is zero. Normal force and gravity do no work, so W_friction = −W_rope = −(100)(5.0)(0.80) = −400 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '+400 J', false, 'Friction opposes the displacement, so its work is negative; a positive 400 J belongs to the rope.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-h-3.1-a','apphysics1-mcq-b2-sv-h-3.1-a-v1','apphysics1-mcq-b2-sv-h-3.1-a-v2','apphysics1-mcq-b2-sv-h-3.1-a-v3','apphysics1-mcq-b2-h-3.1-b','apphysics1-mcq-b2-sv-h-3.1-b-v1','apphysics1-mcq-b2-sv-h-3.1-b-v2','apphysics1-mcq-b2-sv-h-3.1-b-v3','apphysics1-mcq-b2-h-3.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b2-h-3.1-a','apphysics1-mcq-b2-sv-h-3.1-a-v1','apphysics1-mcq-b2-sv-h-3.1-a-v2','apphysics1-mcq-b2-sv-h-3.1-a-v3','apphysics1-mcq-b2-h-3.1-b','apphysics1-mcq-b2-sv-h-3.1-b-v1','apphysics1-mcq-b2-sv-h-3.1-b-v2','apphysics1-mcq-b2-sv-h-3.1-b-v3','apphysics1-mcq-b2-h-3.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
