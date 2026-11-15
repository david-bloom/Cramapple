begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-h-2.5-b','apphysics1-mcq-b5-sv-h-2.5-b-v1','apphysics1-mcq-b5-sv-h-2.5-b-v2','apphysics1-mcq-b5-sv-h-2.5-b-v3','apphysics1-mcq-b5-h-2.6-a','apphysics1-mcq-b5-sv-h-2.6-a-v1','apphysics1-mcq-b5-sv-h-2.6-a-v2','apphysics1-mcq-b5-sv-h-2.6-a-v3','apphysics1-mcq-b5-h-2.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apphysics1-mcq-b5-h-2.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.5-b', 'mcq', 'compare accelerations in opposite directions of travel when a resistive force reverses direction with the velocity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.50 kg ball is thrown straight up. At every instant of motion the air exerts a drag force of constant magnitude 1.0 N opposite the ball''s velocity. Use g = 10 m/s². What are the magnitude and direction of the ball''s acceleration while it rises and while it falls?', null, md5('apphysics1-mcq-b5-h-2.5-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10 m/s² downward in both cases, because every object in flight accelerates at g.', false, 'The acceleration is g only if gravity is the only force. Drag adds to gravity on the way up and subtracts on the way down.' from version_ins
union all select gen_random_uuid(), id, 'B', '8.0 m/s² downward while rising; 12 m/s² downward while falling.', false, 'This swaps the two cases. Drag points down on the way up, adding to the weight, so the rising acceleration is the larger one.' from version_ins
union all select gen_random_uuid(), id, 'C', '12 m/s² downward while rising; 8.0 m/s² downward while falling.', true, 'Correct: Rising: net force = 5.0 + 1.0 = 6.0 N down, a = 12 m/s². Falling: net force = 5.0 − 1.0 = 4.0 N down, a = 8.0 m/s².' from version_ins
union all select gen_random_uuid(), id, 'D', '8.0 m/s² downward in both cases, because drag reduces the net downward force.', false, 'Drag reduces the downward force only on the way down. On the way up it points down, adding to the weight.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.5-b-v1', 'mcq', 'compare accelerations in opposite directions of travel when a resistive force reverses direction with the velocity (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg block slides up a rough incline of 37° with a kinetic friction coefficient of 0.50, momentarily stops and then slides back down. Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s². What are the block''s accelerations while sliding up and while sliding down?', null, md5('apphysics1-mcq-b5-sv-h-2.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.0 m/s² down the incline in both directions, because friction does not change the acceleration.', false, 'Friction changes the net force along the incline. It adds to the pull of gravity going up and subtracts from it going down.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.0 m/s² down the incline while sliding up; 10 m/s² down the incline while sliding down.', false, 'This swaps the cases. Friction acts down the slope when the block moves up, so the sliding-up acceleration is larger.' from version_ins
union all select gen_random_uuid(), id, 'C', '10 m/s² down the incline in both directions, because friction always opposes gravity''s pull.', false, 'Friction opposes the motion, not gravity. When the block moves down, friction points up the slope and reduces the net force.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 m/s² down the incline while sliding up; 2.0 m/s² down the incline while sliding down.', true, 'Correct: Sliding up: a = g sin θ + μ g cos θ = 6.0 + 4.0 = 10 m/s². Sliding down: a = 6.0 − 4.0 = 2.0 m/s². Both are directed down the incline.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.5-b-v2', 'mcq', 'compare accelerations in opposite directions of travel when a resistive force reverses direction with the velocity (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.0 kg ball is tossed straight up. At every instant of motion the air exerts a drag force of constant magnitude 6.0 N opposite the ball''s velocity. Use g = 10 m/s². What are the magnitude and direction of the ball''s acceleration while it rises and while it falls?', null, md5('apphysics1-mcq-b5-sv-h-2.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10 m/s² downward in both cases, because every object in flight accelerates at g.', false, 'Gravity alone gives 10 m/s² only when there is no drag. Here drag adds to the net force on the way up and reduces it on the way down.' from version_ins
union all select gen_random_uuid(), id, 'B', '11.5 m/s² downward while rising; 8.5 m/s² downward while falling.', true, 'Correct: Rising: (40 + 6.0)/4.0 = 11.5 m/s² down. Falling: (40 − 6.0)/4.0 = 8.5 m/s² down.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.5 m/s² downward while rising; 11.5 m/s² downward while falling.', false, 'This swaps the two cases. Drag points downward while the ball rises, so the net force is larger on the way up.' from version_ins
union all select gen_random_uuid(), id, 'D', '8.5 m/s² downward in both cases, because drag is upward.', false, 'Drag points opposite the velocity, so it is upward only while the ball falls. On the way up it points down and adds to the weight.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.5-b-v3', 'mcq', 'compare accelerations in opposite directions of travel when a resistive force reverses direction with the velocity (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.20 kg stone is thrown straight up. At every instant of motion the air exerts a drag force of constant magnitude 0.50 N opposite the stone''s velocity. Use g = 10 m/s². What are the magnitude and direction of the stone''s acceleration while it rises and while it falls?', null, md5('apphysics1-mcq-b5-sv-h-2.5-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10 m/s² downward in both cases, because every object in flight accelerates at g.', false, 'The acceleration equals g only without drag. Here drag changes the net force differently on the way up and on the way down.' from version_ins
union all select gen_random_uuid(), id, 'B', '12.5 m/s² downward while rising; 7.5 m/s² downward while falling.', true, 'Correct: Rising: (2.0 + 0.50)/0.20 = 12.5 m/s² down. Falling: (2.0 − 0.50)/0.20 = 7.5 m/s² down.' from version_ins
union all select gen_random_uuid(), id, 'C', '7.5 m/s² downward while rising; 12.5 m/s² downward while falling.', false, 'This swaps the two cases. On the way up drag points down and adds to the weight, so the acceleration is greater.' from version_ins
union all select gen_random_uuid(), id, 'D', '7.5 m/s² downward in both cases, because drag subtracts from the weight.', false, 'Drag subtracts from the weight only when the stone falls. While rising, drag is directed downward and adds to the weight.' from version_ins;
-- apphysics1-mcq-b5-h-2.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.6-a', 'mcq', 'find where the net gravitational force from two masses cancels, using the inverse-square dependence rather than a simple', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small probe lies on the straight line between two large fixed bodies of masses M and 4M whose centers are a distance d apart. At the probe''s position the net gravitational force from the two bodies is zero. How far is the probe from the body of mass M?', null, md5('apphysics1-mcq-b5-h-2.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd/2, because the forces from the two bodies must be equal at the midpoint.', false, 'The forces are equal only at the point where G·M/x² = G·4M/(d − x)². At the midpoint the heavier body pulls four times as hard.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd/3', true, 'Correct: Set M/x² = 4M/(d − x)². Then (d − x) = 2x, so x = d/3 from the smaller mass.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd/5, because the distances must be in the ratio of the masses, 1 to 4.', false, 'This treats the force as inversely proportional to distance. The force varies as 1/r², so the distances are in the ratio 1 to 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '2d/3, because the probe must be nearer the heavier body.', false, 'The probe must be nearer the lighter body, since the heavier body pulls more strongly at equal distances. The 2d/3 is the distance from the heavier body.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.6-a-v1', 'mcq', 'find where the net gravitational force from two masses cancels, using the inverse-square dependence rather than a simple (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small probe lies on the straight line between two large fixed bodies of masses M and 9M whose centers are a distance d apart. At the probe''s position the net gravitational force from the two bodies is zero. How far is the probe from the body of mass M?', null, md5('apphysics1-mcq-b5-sv-h-2.6-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd/4', true, 'Correct: Set M/x² = 9M/(d − x)². Then (d − x) = 3x, so x = d/4 from the smaller mass.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd/2, because the forces from the two bodies must be equal at the midpoint.', false, 'At the midpoint the heavier body pulls nine times as hard, so the forces do not cancel there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd/10, because the distances must be in the ratio of the masses, 1 to 9.', false, 'The force falls off as 1/r², so the distances are in the ratio of the square roots of the masses, 1 to 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3d/4, because the probe must be nearer the heavier body.', false, 'The probe must be nearer the lighter body to compensate for its smaller mass. The 3d/4 is its distance from the heavier body.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.6-a-v2', 'mcq', 'find where the net gravitational force from two masses cancels, using the inverse-square dependence rather than a simple (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small probe lies on the straight line between two large fixed bodies of masses 16M and M whose centers are a distance d apart. At the probe''s position the net gravitational force from the two bodies is zero. How far is the probe from the smaller body, of mass M?', null, md5('apphysics1-mcq-b5-sv-h-2.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd/2, because the forces from the two bodies must be equal at the midpoint.', false, 'At the midpoint the heavier body pulls sixteen times as hard, so there is no cancellation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd/17, because the distances must be in the ratio of the masses, 1 to 16.', false, 'The force varies as 1/r², so the distances are in the ratio of the square roots of the masses, 1 to 4, not 1 to 16.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd/5', true, 'Correct: Set M/x² = 16M/(d − x)². Then (d − x) = 4x, so x = d/5 from the smaller mass.' from version_ins
union all select gen_random_uuid(), id, 'D', '4d/5, because the probe must be nearer the heavier body.', false, 'The probe must sit nearer the lighter body. The 4d/5 is its distance from the heavier body, not from the smaller one.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.6-a-v3', 'mcq', 'find where the net gravitational force from two masses cancels, using the inverse-square dependence rather than a simple (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small probe lies on the straight line between two large fixed bodies of masses 4M and 9M whose centers are a distance d apart. At the probe''s position the net gravitational force from the two bodies is zero. How far is the probe from the body of mass 4M?', null, md5('apphysics1-mcq-b5-sv-h-2.6-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd/2, because the forces from the two bodies must be equal at the midpoint.', false, 'At the midpoint the 9M body pulls more strongly, so the net force is not zero there.' from version_ins
union all select gen_random_uuid(), id, 'B', '4d/13, because the distances must be in the ratio of the masses, 4 to 9.', false, 'The force falls as 1/r², so the distances are in the ratio of the square roots of the masses, 2 to 3, not 4 to 9.' from version_ins
union all select gen_random_uuid(), id, 'C', '3d/5, because the probe must be nearer the heavier body.', false, 'The probe must be nearer the lighter body. The 3d/5 is the probe''s distance from the heavier body.' from version_ins
union all select gen_random_uuid(), id, 'D', '2d/5', true, 'Correct: Set 4M/x² = 9M/(d − x)². Then (d − x)/x = 3/2, so x = 2d/5 from the 4M body.' from version_ins;
-- apphysics1-mcq-b5-h-2.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.6-b', 'mcq', 'compare gravitational forces and accelerations of two bodies: equal forces give accelerations inversely proportional to ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two isolated spheres, of mass 2.0 kg and 8.0 kg, are released from rest in deep space with their centers 1.0 m apart. No other bodies act on them. Which statement about their gravitational forces and initial accelerations is correct?', null, md5('apphysics1-mcq-b5-h-2.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The force on the 8.0 kg sphere is four times greater, so it accelerates four times as fast.', false, 'The two gravitational forces are a third-law pair and are equal. A larger mass with the same force has a smaller acceleration.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The forces are equal, so both spheres have equal accelerations.', false, 'Equal forces give equal accelerations only for equal masses. With a = F/m the 2.0 kg sphere accelerates four times as much.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The forces are equal in magnitude, and the 2.0 kg sphere has an acceleration four times as large as the 8.0 kg sphere.', true, 'Correct: Third law: the forces are equal, F = Gm₁m₂/r². a = F/m gives a₂ : a₈ = 8.0 : 2.0 = 4 : 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The force on the 8.0 kg sphere is four times greater, but the accelerations are equal because all objects fall with the same acceleration.', false, 'The same-acceleration result holds near a planet''s surface, where g does not depend on the falling mass. It does not hold for two comparable masses attracting each other.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-h-2.5-b','apphysics1-mcq-b5-sv-h-2.5-b-v1','apphysics1-mcq-b5-sv-h-2.5-b-v2','apphysics1-mcq-b5-sv-h-2.5-b-v3','apphysics1-mcq-b5-h-2.6-a','apphysics1-mcq-b5-sv-h-2.6-a-v1','apphysics1-mcq-b5-sv-h-2.6-a-v2','apphysics1-mcq-b5-sv-h-2.6-a-v3','apphysics1-mcq-b5-h-2.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b5-h-2.5-b','apphysics1-mcq-b5-sv-h-2.5-b-v1','apphysics1-mcq-b5-sv-h-2.5-b-v2','apphysics1-mcq-b5-sv-h-2.5-b-v3','apphysics1-mcq-b5-h-2.6-a','apphysics1-mcq-b5-sv-h-2.6-a-v1','apphysics1-mcq-b5-sv-h-2.6-a-v2','apphysics1-mcq-b5-sv-h-2.6-a-v3','apphysics1-mcq-b5-h-2.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
