begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.6-b-v1','apphysics1-mcq-b5-sv-h-2.6-b-v2','apphysics1-mcq-b5-sv-h-2.6-b-v3','apphysics1-mcq-b5-h-2.7-a','apphysics1-mcq-b5-sv-h-2.7-a-v1','apphysics1-mcq-b5-sv-h-2.7-a-v2','apphysics1-mcq-b5-sv-h-2.7-a-v3','apphysics1-mcq-b5-h-2.7-b','apphysics1-mcq-b5-sv-h-2.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apphysics1-mcq-b5-sv-h-2.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.6-b-v1', 'mcq', 'compare gravitational forces and accelerations of two bodies: equal forces give accelerations inversely proportional to  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two isolated spheres, of mass 1.0 kg and 9.0 kg, are released from rest in deep space a short distance apart. No other bodies act on them. Which statement about their gravitational forces and initial accelerations is correct?', null, md5('apphysics1-mcq-b5-sv-h-2.6-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The force on the 9.0 kg sphere is nine times greater, so it accelerates nine times as fast.', false, 'The attraction is mutual and the two forces are equal. The heavier sphere accelerates less.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The forces are equal in magnitude, and the 1.0 kg sphere accelerates nine times as much as the 9.0 kg sphere.', true, 'Correct: Third law: the forces are equal. a = F/m, so a₁ : a₉ = 9.0 : 1.0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The forces are equal, so both spheres accelerate equally.', false, 'Equal forces on unequal masses give unequal accelerations, since a = F/m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The force on the 9.0 kg sphere is nine times greater, but both spheres accelerate equally.', false, 'The equal-acceleration idea belongs to free fall near a planet, where the planet''s mass is huge. For two comparable masses the lighter one accelerates much more.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.6-b-v2', 'mcq', 'compare gravitational forces and accelerations of two bodies: equal forces give accelerations inversely proportional to  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two isolated asteroids have masses 6.0 × 10⁶ kg and 2.0 × 10⁶ kg and start at rest a fixed distance apart, far from everything else. Which statement about their gravitational forces and initial accelerations is correct?', null, md5('apphysics1-mcq-b5-sv-h-2.6-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The larger asteroid feels the larger force and so has the larger acceleration.', false, 'The forces are equal because they are a third-law pair. The larger mass makes the same force produce a smaller acceleration.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The forces are equal and the accelerations are equal.', false, 'With equal forces the accelerations are inversely proportional to the masses, so they differ by a factor of three.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The smaller asteroid feels the larger force, three times as much, so it accelerates three times as much.', false, 'Gravitational attraction is mutual and equal in magnitude; the smaller body does not feel a larger force. Its larger acceleration comes from its smaller mass.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The forces are equal in magnitude, and the smaller asteroid accelerates three times as much as the larger one.', true, 'Correct: The forces are a third-law pair and equal. a = F/m, so a_small/a_large = 6.0/2.0 = 3.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.6-b-v3', 'mcq', 'compare gravitational forces and accelerations of two bodies: equal forces give accelerations inversely proportional to  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A planet has 50 times the mass of its small moon. Ignoring all other bodies, which statement about the gravitational forces between them and their accelerations is correct?', null, md5('apphysics1-mcq-b5-sv-h-2.6-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The force on the planet is 50 times greater, so the planet accelerates 50 times as much.', false, 'The two forces are equal and opposite. The planet''s much larger mass gives it a much smaller acceleration.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The forces are equal, so the planet and moon accelerate equally.', false, 'Equal forces on very different masses give very different accelerations, in the inverse ratio of the masses.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The forces are equal in magnitude, and the moon''s acceleration is 50 times the planet''s acceleration.', true, 'Correct: The gravitational forces form a third-law pair, so they are equal. a = F/m gives a_moon/a_planet = 50.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The force on the planet is 50 times greater, yet both accelerate equally, as in free fall.', false, 'Free-fall equality applies to small objects near a planet. Here the two forces are equal, and the moon''s far smaller mass gives it the far larger acceleration.' from version_ins;
-- apphysics1-mcq-b5-h-2.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.7-a', 'mcq', 'find kinetic friction when the applied force has a vertical component that changes the normal force', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 10 kg crate is pulled across a level floor by a rope that exerts a 50 N force directed 37° above the horizontal. The kinetic friction coefficient is 0.40, and the crate is already sliding. Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s². What is the crate''s acceleration?', null, md5('apphysics1-mcq-b5-h-2.7-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 m/s², because friction equals 0.40 × 100 N = 40 N, which balances the horizontal pull.', false, 'This takes the normal force as the full weight. The rope''s upward component of 30 N reduces the normal force to 70 N, so friction is only 28 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.2 m/s², because the horizontal force is the full 50 N.', false, 'Only the horizontal component of the rope force, 40 N, drives the crate forward. Using 50 N overstates the net force.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.2 m/s²', true, 'Correct: N = 100 − 50(0.60) = 70 N, f = 0.40 × 70 = 28 N, and F_x = 50(0.80) = 40 N. a = (40 − 28)/10 = 1.2 m/s².' from version_ins
union all select gen_random_uuid(), id, 'D', '0.6 m/s², because the horizontal pull is 30 N and the normal force is 60 N.', false, 'This swaps sine and cosine. The horizontal component is 50 cos 37° = 40 N and the vertical is 30 N, giving N = 70 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.7-a-v1', 'mcq', 'find kinetic friction when the applied force has a vertical component that changes the normal force (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 20 kg crate is pushed across a level floor by a force of 100 N directed 37° below the horizontal. The kinetic friction coefficient is 0.20, and the crate is already sliding. Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s². What is the crate''s acceleration?', null, md5('apphysics1-mcq-b5-sv-h-2.7-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.4 m/s²', true, 'Correct: N = 200 + 100(0.60) = 260 N, f = 0.20 × 260 = 52 N, F_x = 80 N. a = (80 − 52)/20 = 1.4 m/s².' from version_ins
union all select gen_random_uuid(), id, 'B', '2.0 m/s², because friction is 0.20 × 200 N = 40 N.', false, 'The downward component of the push, 60 N, increases the normal force to 260 N. Friction is then 52 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.6 m/s², because the push reduces the normal force and so reduces friction.', false, 'A push directed downward adds to the normal force rather than reducing it. The 60 N downward component raises N to 260 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.4 m/s², because the horizontal force is the full 100 N.', false, 'Only the horizontal component, 80 N, drives the crate along the floor. Using 100 N overstates the net force.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.7-a-v2', 'mcq', 'find kinetic friction when the applied force has a vertical component that changes the normal force (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 40 kg sled is pulled across level ice-covered ground by a rope with 200 N force directed 37° above the horizontal. The kinetic friction coefficient is 0.25, and the sled is already sliding. Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s². What is the sled''s acceleration?', null, md5('apphysics1-mcq-b5-sv-h-2.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.5 m/s², because friction is 0.25 × 400 N = 100 N.', false, 'The rope''s upward component of 120 N lowers the normal force to 280 N, so friction is 70 N, not 100 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.25 m/s², because the horizontal force is the full 200 N.', false, 'Only the horizontal component of 160 N drives the sled. Using the full 200 N overstates the net force.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.25 m/s²', true, 'Correct: N = 400 − 200(0.60) = 280 N, f = 0.25 × 280 = 70 N, F_x = 160 N. a = (160 − 70)/40 = 2.25 m/s².' from version_ins
union all select gen_random_uuid(), id, 'D', '0.75 m/s², because the rope''s vertical component adds to the normal force.', false, 'An upward-angled rope reduces the normal force. It does not add to it, so friction is smaller, not larger.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.7-a-v3', 'mcq', 'find kinetic friction when the applied force has a vertical component that changes the normal force (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 6.0 kg block is pulled across a level table by a string that exerts a 30 N force directed 53° above the horizontal. The kinetic friction coefficient is 0.50, and the block is already sliding. Use sin 53° = 0.80, cos 53° = 0.60 and g = 10 m/s². What is the block''s acceleration?', null, md5('apphysics1-mcq-b5-sv-h-2.7-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It slows down at 2.0 m/s², because friction is 0.50 × 60 N = 30 N.', false, 'The string''s upward component of 24 N lowers the normal force to 36 N, so friction is only 18 N and balances the 18 N horizontal pull.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 m/s², so it keeps moving at constant velocity.', true, 'Correct: N = 60 − 30(0.80) = 36 N, f = 0.50 × 36 = 18 N, and F_x = 30(0.60) = 18 N. The net force is zero, so a = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It speeds up at 2.0 m/s², because the horizontal force is the full 30 N.', false, 'Only the horizontal component of 18 N pulls the block forward. Using 30 N overstates the net force.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It speeds up at 0.5 m/s², because the horizontal pull is 24 N and the normal force is 42 N.', false, 'This swaps sine and cosine. The horizontal component is 30 cos 53° = 18 N and the vertical is 24 N, giving N = 36 N and f = 18 N.' from version_ins;
-- apphysics1-mcq-b5-h-2.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.7-b', 'mcq', 'use static friction as a supporting force: the normal force comes from the pushing force, not the weight, when a block i', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg block is pressed against a rough vertical wall by a horizontal force F; no other force is applied. The static friction coefficient is 0.40. What is the minimum F that keeps the block from sliding down? Use g = 10 m/s².', null, md5('apphysics1-mcq-b5-h-2.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8 N, because the maximum friction is 0.40 × 20 N.', false, 'This takes the normal force to be the weight. The normal force from the wall equals the horizontal push F, so the friction limit is 0.40 F.' from version_ins
union all select gen_random_uuid(), id, 'B', '20 N, because the push must equal the weight.', false, 'The push is horizontal and cannot balance the vertical weight directly. Friction must supply 20 N upward, and its maximum value is 0.40 F.' from version_ins
union all select gen_random_uuid(), id, 'C', '50 N', true, 'Correct: The normal force N = F, and static friction must balance the weight: μ_s F ≥ mg. F ≥ 20/0.40 = 50 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '28 N, because the push must exceed the weight by the friction coefficient.', false, 'Adding the friction coefficient to the weight has no physical meaning. Friction supplies the 20 N, so 0.40 F ≥ 20 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.7-b-v1', 'mcq', 'use static friction as a supporting force: the normal force comes from the pushing force, not the weight, when a block i (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 5.0 kg block is pressed against a rough vertical wall by a horizontal force F; no other force is applied. The static friction coefficient is 0.50. What is the minimum F that keeps the block from sliding down? Use g = 10 m/s².', null, md5('apphysics1-mcq-b5-sv-h-2.7-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '25 N, because the maximum friction is 0.50 × 50 N.', false, 'The normal force is the horizontal push, not the weight. Friction can be at most 0.50 F.' from version_ins
union all select gen_random_uuid(), id, 'B', '50 N, because the push must equal the weight.', false, 'A horizontal push cannot directly balance the weight. Friction must carry the 50 N, so it must equal 0.50 F.' from version_ins
union all select gen_random_uuid(), id, 'C', '100 N', true, 'Correct: N = F and μ_s F ≥ mg, so F ≥ 50/0.50 = 100 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '75 N, because the push must exceed the weight by half.', false, 'Adding half the weight has no basis. The condition is 0.50 F ≥ 50 N.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.6-b-v1','apphysics1-mcq-b5-sv-h-2.6-b-v2','apphysics1-mcq-b5-sv-h-2.6-b-v3','apphysics1-mcq-b5-h-2.7-a','apphysics1-mcq-b5-sv-h-2.7-a-v1','apphysics1-mcq-b5-sv-h-2.7-a-v2','apphysics1-mcq-b5-sv-h-2.7-a-v3','apphysics1-mcq-b5-h-2.7-b','apphysics1-mcq-b5-sv-h-2.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b5-sv-h-2.6-b-v1','apphysics1-mcq-b5-sv-h-2.6-b-v2','apphysics1-mcq-b5-sv-h-2.6-b-v3','apphysics1-mcq-b5-h-2.7-a','apphysics1-mcq-b5-sv-h-2.7-a-v1','apphysics1-mcq-b5-sv-h-2.7-a-v2','apphysics1-mcq-b5-sv-h-2.7-a-v3','apphysics1-mcq-b5-h-2.7-b','apphysics1-mcq-b5-sv-h-2.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
