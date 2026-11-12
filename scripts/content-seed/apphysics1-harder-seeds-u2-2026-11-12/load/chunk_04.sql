begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.4-a-v3','apphysics1-mcq-b5-h-2.4-b','apphysics1-mcq-b5-sv-h-2.4-b-v1','apphysics1-mcq-b5-sv-h-2.4-b-v2','apphysics1-mcq-b5-sv-h-2.4-b-v3','apphysics1-mcq-b5-h-2.5-a','apphysics1-mcq-b5-sv-h-2.5-a-v1','apphysics1-mcq-b5-sv-h-2.5-a-v2','apphysics1-mcq-b5-sv-h-2.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apphysics1-mcq-b5-sv-h-2.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.4-a-v3', 'mcq', 'use constant velocity (net force zero) to find an unknown force by vector balance, not by assuming constant velocity nee (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A barge moves at constant velocity on a still canal. Tug 1 pulls with 300 N toward the north and tug 2 pulls with 400 N toward the east. These tugs and the water drag are the only horizontal forces. What is the drag force from the water?', null, md5('apphysics1-mcq-b5-sv-h-2.4-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '500 N, directed toward the north and east.', false, 'The drag must oppose the sum of the tug forces. Pointing the same way as the sum would accelerate the barge.' from version_ins
union all select gen_random_uuid(), id, 'B', '500 N, directed toward the south and west.', true, 'Correct: Net force zero: the tugs combine to √(300² + 400²) = 500 N toward 37° east of north, so the water drag is 500 N toward the opposite direction (south-west).' from version_ins
union all select gen_random_uuid(), id, 'C', '700 N, directed toward the south and west.', false, 'Perpendicular forces combine as √(300² + 400²) = 500 N, not by adding magnitudes.' from version_ins
union all select gen_random_uuid(), id, 'D', '100 N, directed toward the east.', false, 'This subtracts 300 from 400 as if the tugs pulled along one line. The tugs pull at right angles to each other.' from version_ins;
-- apphysics1-mcq-b5-h-2.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.4-b', 'mcq', 'link motion to the net force: constant velocity means balanced forces in any direction, and speeding up or slowing down ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An 800 kg elevator car is lifted by a cable. It starts from rest at the bottom and speeds up for 3 s, then rises at a constant 4 m/s for 5 s, then slows to rest during the last 3 s. How does the cable tension T compare with the car''s weight W in the three intervals, in order?', null, md5('apphysics1-mcq-b5-h-2.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'T > W in all three intervals, because the car moves upward the whole time.', false, 'Upward motion does not require a net upward force. At constant velocity the net force is zero, so T = W, and while slowing T is less than W.' from version_ins
union all select gen_random_uuid(), id, 'B', 'T > W, then T = W, then T < W.', true, 'Correct: Upward acceleration needs T > W; constant velocity needs T = W; slowing while moving up means a downward acceleration, so T < W.' from version_ins
union all select gen_random_uuid(), id, 'C', 'T > W, then T > W, then T < W, because a force larger than the weight is needed to keep moving upward.', false, 'This is the idea that force is needed to maintain motion. At constant velocity the forces balance and T equals W.' from version_ins
union all select gen_random_uuid(), id, 'D', 'T > W, then T = W, then T > W, because the car is moving upward at the end.', false, 'While slowing the acceleration is downward, so the net force is downward and T is less than W. The direction of motion does not set the sign of the net force.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.4-b-v1', 'mcq', 'link motion to the net force: constant velocity means balanced forces in any direction, and speeding up or slowing down  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 900 kg mine cage is lowered on a cable. It starts from rest and speeds up downward for 4 s, then descends at a constant 3 m/s for 6 s, then slows to rest during the last 4 s. How does the cable tension T compare with the cage''s weight W in the three intervals, in order?', null, md5('apphysics1-mcq-b5-sv-h-2.4-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'T < W in all three intervals, because the cage moves downward the whole time.', false, 'Downward motion alone does not make T less than W. At constant velocity the net force is zero, so T = W, and while slowing T must exceed W.' from version_ins
union all select gen_random_uuid(), id, 'B', 'T < W, then T < W, then T > W, because gravity must pull the cage along to keep it descending.', false, 'Constant velocity requires zero net force, so no extra net downward force is needed. T equals W in that interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'T > W, then T = W, then T < W, because the tension is larger when the motion starts.', false, 'Speeding up downward means a downward acceleration, so T must be less than W at the start. The order of the first and last intervals is reversed here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'T < W, then T = W, then T > W.', true, 'Correct: Speeding up downward: net force down, T < W. Constant velocity: T = W. Slowing while moving down: acceleration up, so T > W.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.4-b-v2', 'mcq', 'link motion to the net force: constant velocity means balanced forces in any direction, and speeding up or slowing down  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 60 kg person stands on a scale in an elevator that rises. It speeds up at 1.5 m/s², then moves at constant speed, then slows at 1.5 m/s² as it stops. Use g = 10 m/s². What does the scale read in the three intervals, in order?', null, md5('apphysics1-mcq-b5-sv-h-2.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '690 N, then 690 N, then 510 N, because the scale reads more whenever the elevator moves upward.', false, 'At constant velocity the net force is zero, so the scale reads the weight, 600 N. Motion alone does not change the reading.' from version_ins
union all select gen_random_uuid(), id, 'B', '690 N, then 600 N, then 510 N.', true, 'Correct: N = m(g + a): 60(11.5) = 690 N while speeding up, 600 N at constant speed, and 60(8.5) = 510 N while slowing with a downward acceleration.' from version_ins
union all select gen_random_uuid(), id, 'C', '600 N, then 600 N, then 600 N, because the person''s weight does not change.', false, 'The weight stays 600 N, but the scale reading is the normal force, which changes with acceleration.' from version_ins
union all select gen_random_uuid(), id, 'D', '690 N, then 600 N, then 690 N, because the elevator is moving upward at the end.', false, 'While slowing, the acceleration is downward: N = 60(10 − 1.5) = 510 N, less than the weight.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.4-b-v3', 'mcq', 'link motion to the net force: constant velocity means balanced forces in any direction, and speeding up or slowing down  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 5.0 kg block hangs from a spring scale that is lowered. The block speeds up downward at 2.0 m/s², then moves down at constant speed, then slows at 2.0 m/s² until it stops. Use g = 10 m/s². What does the scale read in the three intervals, in order?', null, md5('apphysics1-mcq-b5-sv-h-2.4-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40 N, then 40 N, then 60 N, because the scale reads less whenever the block moves down.', false, 'At constant velocity the forces balance and the scale reads the weight, 50 N. Downward motion alone does not reduce the reading.' from version_ins
union all select gen_random_uuid(), id, 'B', '40 N, then 50 N, then 60 N.', true, 'Correct: T = m(g + a) with a = −2.0 m/s² gives 5.0(8.0) = 40 N while speeding up downward, 50 N at constant speed, and 5.0(12) = 60 N while slowing.' from version_ins
union all select gen_random_uuid(), id, 'C', '50 N, then 50 N, then 50 N, because the block''s weight does not change.', false, 'The scale reads the tension, which changes with acceleration. It is 50 N only at constant speed.' from version_ins
union all select gen_random_uuid(), id, 'D', '60 N, then 50 N, then 40 N, because the first interval has the largest force.', false, 'The block accelerates downward at first, so the tension is less than the weight. The order of the first and last intervals is reversed here.' from version_ins;
-- apphysics1-mcq-b5-h-2.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.5-a', 'mcq', 'apply Newton''s second law separately to connected objects to find the tension, which is not simply the weight of the han', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3.0 kg block rests on a frictionless horizontal table. A light string runs from it over a light, frictionless pulley at the table''s edge to a 2.0 kg block that hangs vertically. The system is released from rest. What is the tension in the string while the blocks move?', null, md5('apphysics1-mcq-b5-h-2.5-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 N, the weight of the hanging block.', false, 'The hanging block accelerates downward, so the tension must be less than its weight. The tension equals the weight only if the block is at rest or at constant velocity.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 N', true, 'Correct: a = 20/(3.0 + 2.0) = 4.0 m/s². Table block: T = 3.0 × 4.0 = 12 N. Check: 20 − T = 2.0 × 4.0, so T = 12 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '8 N, the hanging block''s mass times the system''s acceleration.', false, 'The net force on the hanging block is its weight minus the tension, and that equals m·a = 8 N. The tension itself is 20 − 8 = 12 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '30 N, the weight of the block on the table.', false, 'The table block''s weight is balanced by the normal force and does not pull the string. Only the horizontal tension affects its motion.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.5-a-v1', 'mcq', 'apply Newton''s second law separately to connected objects to find the tension, which is not simply the weight of the han (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.0 kg block rests on a horizontal table with a kinetic friction coefficient of 0.25. A light string runs from it over a light, frictionless pulley at the table''s edge to a 6.0 kg block that hangs vertically. The system is released from rest and the blocks move. What is the tension in the string?', null, md5('apphysics1-mcq-b5-sv-h-2.5-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '30 N', true, 'Correct: a = (60 − 10)/(4.0 + 6.0) = 5.0 m/s². Hanging block: 60 − T = 6.0 × 5.0, so T = 30 N. Check: T − 10 = 4.0 × 5.0 gives T = 30 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '60 N, the weight of the hanging block.', false, 'The hanging block accelerates downward, so the tension is less than its weight.' from version_ins
union all select gen_random_uuid(), id, 'C', '20 N, the table block''s mass times the acceleration.', false, 'The net force on the table block is T − friction = 20 N, so T is 20 N plus the 10 N friction force.' from version_ins
union all select gen_random_uuid(), id, 'D', '50 N, the net force on the whole system.', false, 'The system''s net force is 60 − 10 = 50 N, but that is not the tension. The tension acts only between the two blocks and is found from one block''s equation.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.5-a-v2', 'mcq', 'apply Newton''s second law separately to connected objects to find the tension, which is not simply the weight of the han (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg block and a 6.0 kg block hang from opposite ends of a light string that passes over a light, frictionless pulley. The system is released from rest. What is the tension in the string while the blocks move?', null, md5('apphysics1-mcq-b5-sv-h-2.5-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 N, the weight of the lighter block.', false, 'The lighter block accelerates upward, so the tension must exceed its weight.' from version_ins
union all select gen_random_uuid(), id, 'B', '60 N, the weight of the heavier block.', false, 'The heavier block accelerates downward, so the tension must be less than its weight.' from version_ins
union all select gen_random_uuid(), id, 'C', '40 N, the net force on the system.', false, 'The 40 N is the weight difference, which drives the system. The tension is found from one block''s equation of motion.' from version_ins
union all select gen_random_uuid(), id, 'D', '30 N', true, 'Correct: a = (60 − 20)/8.0 = 5.0 m/s². Lighter block: T − 20 = 2.0 × 5.0, so T = 30 N. Heavier block: 60 − 30 = 6.0 × 5.0.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.5-a-v3', 'mcq', 'apply Newton''s second law separately to connected objects to find the tension, which is not simply the weight of the han (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.0 kg block sits on a frictionless incline that makes 30° with the horizontal. A light string runs from it up the incline and over a light, frictionless pulley at the top to a 1.0 kg block that hangs vertically. The system is released from rest and the blocks move. What is the tension in the string?', null, md5('apphysics1-mcq-b5-sv-h-2.5-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 N', true, 'Correct: Down-slope pull is 4.0 × 10 × 0.50 = 20 N, which beats 10 N, so a = (20 − 10)/5.0 = 2.0 m/s². Hanging block rises: T − 10 = 1.0 × 2.0 gives T = 12 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '10 N, the weight of the hanging block.', false, 'The hanging block accelerates upward, so the tension is larger than its weight.' from version_ins
union all select gen_random_uuid(), id, 'C', '20 N, the component of the 4.0 kg block''s weight along the incline.', false, 'The 20 N pulls the block down the slope, but the string tension is less than that because the block accelerates down the slope.' from version_ins
union all select gen_random_uuid(), id, 'D', '8 N, the tension found by assuming the hanging block accelerates downward.', false, 'The component along the incline is 20 N, greater than the 10 N hanging weight, so the hanging block goes up and T = 10 + 1.0 × 2.0 = 12 N, not 8 N.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.4-a-v3','apphysics1-mcq-b5-h-2.4-b','apphysics1-mcq-b5-sv-h-2.4-b-v1','apphysics1-mcq-b5-sv-h-2.4-b-v2','apphysics1-mcq-b5-sv-h-2.4-b-v3','apphysics1-mcq-b5-h-2.5-a','apphysics1-mcq-b5-sv-h-2.5-a-v1','apphysics1-mcq-b5-sv-h-2.5-a-v2','apphysics1-mcq-b5-sv-h-2.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b5-sv-h-2.4-a-v3','apphysics1-mcq-b5-h-2.4-b','apphysics1-mcq-b5-sv-h-2.4-b-v1','apphysics1-mcq-b5-sv-h-2.4-b-v2','apphysics1-mcq-b5-sv-h-2.4-b-v3','apphysics1-mcq-b5-h-2.5-a','apphysics1-mcq-b5-sv-h-2.5-a-v1','apphysics1-mcq-b5-sv-h-2.5-a-v2','apphysics1-mcq-b5-sv-h-2.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
