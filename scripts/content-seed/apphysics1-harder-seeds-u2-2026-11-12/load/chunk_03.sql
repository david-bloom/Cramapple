begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.3-a-v2','apphysics1-mcq-b5-sv-h-2.3-a-v3','apphysics1-mcq-b5-h-2.3-b','apphysics1-mcq-b5-sv-h-2.3-b-v1','apphysics1-mcq-b5-sv-h-2.3-b-v2','apphysics1-mcq-b5-sv-h-2.3-b-v3','apphysics1-mcq-b5-h-2.4-a','apphysics1-mcq-b5-sv-h-2.4-a-v1','apphysics1-mcq-b5-sv-h-2.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apphysics1-mcq-b5-sv-h-2.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.3-a-v2', 'mcq', 'combine Newton''s second and third laws: the contact force between two pushed blocks is found from the acceleration of th (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two blocks touch on a frictionless horizontal table. A horizontal 30 N force pushes on the 2.0 kg block, which pushes against a 3.0 kg block, and the blocks accelerate together. What is the magnitude of the force that the 3.0 kg block exerts on the 2.0 kg block?', null, md5('apphysics1-mcq-b5-sv-h-2.3-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18 N', true, 'Correct: a = 30/5.0 = 6.0 m/s². The 2.0 kg block pushes the 3.0 kg block with 3.0 × 6.0 = 18 N, so the 3.0 kg block pushes back with 18 N. Check: 30 − 18 = 2.0 × 6.0.' from version_ins
union all select gen_random_uuid(), id, 'B', '30 N, because the push is transmitted undiminished through the blocks.', false, 'Part of the push accelerates the 2.0 kg block itself, so less than 30 N reaches the other block.' from version_ins
union all select gen_random_uuid(), id, 'C', '12 N, because that is the net force on the 2.0 kg block.', false, 'The 12 N is the net force on the 2.0 kg block (30 N minus the contact force). The contact force is 18 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '15 N, because the push is shared equally between the two blocks.', false, 'The share is proportional to mass, not equal. The 3.0 kg block takes 3/5 of the push, which is 18 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.3-a-v3', 'mcq', 'combine Newton''s second and third laws: the contact force between two pushed blocks is found from the acceleration of th (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two blocks touch on a frictionless horizontal table. A horizontal 15 N force pushes on the 5.0 kg block, which pushes against a 10 kg block, and the blocks accelerate together. What is the magnitude of the force that the 5.0 kg block exerts on the 10 kg block?', null, md5('apphysics1-mcq-b5-sv-h-2.3-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15 N, because the push is transmitted undiminished through the blocks.', false, 'The 5.0 kg block uses part of the push itself, so the force it passes on is smaller than 15 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '5 N, because that is the net force on the 5.0 kg block.', false, 'The 5 N is the net force on the 5.0 kg block (15 N minus the contact force). The contact force on the 10 kg block is 10 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '7.5 N, because the push is shared equally between the two blocks.', false, 'Equal halves ignore the different masses. The 10 kg block needs twice the force the 5.0 kg block needs.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 N', true, 'Correct: a = 15/15 = 1.0 m/s². The 5.0 kg block pushes the 10 kg block with 10 × 1.0 = 10 N, and the third law gives the same 10 N back. Check: 15 − 10 = 5.0 × 1.0.' from version_ins;
-- apphysics1-mcq-b5-h-2.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.3-b', 'mcq', 'keep third-law pairs distinct from balanced forces: contact forces stay equal and opposite even when the surface and obj', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 5.0 kg box rests on the floor of an elevator that is accelerating upward at 2.0 m/s². Which statement about the forces between the box and the floor is correct?', null, md5('apphysics1-mcq-b5-h-2.3-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The floor pushes up on the box with 60 N, and the box pushes down on the floor with 50 N, its weight.', false, 'The box''s push on the floor is the third-law partner of the floor''s push on the box, so it is 60 N. The 50 N weight is a different force, exerted by Earth.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The floor''s 60 N push and the box''s 50 N weight form a third-law pair, and they are unequal because the box accelerates.', false, 'Third-law pairs always involve two objects acting on each other and are always equal. Weight and the normal force act on the same object and are not a pair.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both forces are 50 N, because acceleration does not change the contact force.', false, 'The floor must supply the net upward force: N − 50 = 5.0 × 2.0 gives 60 N. The contact force changes with acceleration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The floor pushes up on the box with 60 N, and the box pushes down on the floor with 60 N.', true, 'Correct: Newton''s second law: N − mg = ma gives N = 5.0(10 + 2.0) = 60 N. The third law makes the box''s downward push on the floor 60 N as well; the weight is 50 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.3-b-v1', 'mcq', 'keep third-law pairs distinct from balanced forces: contact forces stay equal and opposite even when the surface and obj (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.0 kg box rests on the floor of an elevator that is accelerating downward at 3.0 m/s². Which statement about the forces between the box and the floor is correct?', null, md5('apphysics1-mcq-b5-sv-h-2.3-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The floor pushes up on the box with 28 N, and the box pushes down on the floor with 40 N, its weight.', false, 'The reaction to the floor''s push is the box''s push on the floor, which equals 28 N. The weight is a separate force from Earth.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The floor''s 28 N push and the box''s 40 N weight form a third-law pair, and they are unequal because the box accelerates.', false, 'Weight and the normal force act on one object, so they cannot be a third-law pair. Third-law partners are equal even when accelerating.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The floor pushes up on the box with 28 N, and the box pushes down on the floor with 28 N.', true, 'Correct: N − mg = ma with a = −3.0 m/s² gives N = 4.0(10 − 3.0) = 28 N. The third law gives the same 28 N downward on the floor; the weight is 40 N.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both forces are 40 N, because the floor always supports the full weight.', false, 'The normal force equals the weight only when there is no vertical acceleration. Here N = 4.0(10 − 3.0) = 28 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.3-b-v2', 'mcq', 'keep third-law pairs distinct from balanced forces: contact forces stay equal and opposite even when the surface and obj (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 60 kg person stands on a bathroom scale in an elevator that is moving upward but slowing down at 2.0 m/s². Which statement about the forces between the person and the scale is correct?', null, md5('apphysics1-mcq-b5-sv-h-2.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The scale pushes up on the person with 480 N, and the person pushes down on the scale with 600 N, the person''s weight.', false, 'The person''s push on the scale is the partner of the scale''s push on the person, so it is also 480 N. The 600 N weight is a force from Earth.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The scale pushes up on the person with 480 N, and the person pushes down on the scale with 480 N.', true, 'Correct: Taking up as positive, a = −2.0 m/s²: N − 600 = 60(−2.0) gives N = 480 N. By the third law the person pushes down on the scale with 480 N.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The scale and the person exert 600 N on each other, because the elevator is still moving upward.', false, 'Upward motion does not set the contact force; acceleration does. The elevator''s acceleration is downward, so the scale reads less than 600 N.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The scale''s 480 N force and the person''s 600 N weight are a third-law pair, unequal because the elevator is slowing.', false, 'These two forces act on the same object, the person, so they cannot be a third-law pair. The actual pair is the two contact forces of 480 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.3-b-v3', 'mcq', 'keep third-law pairs distinct from balanced forces: contact forces stay equal and opposite even when the surface and obj (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An 8.0 kg instrument rests on the floor of a rocket that is accelerating straight upward at 5.0 m/s². Which statement about the forces between the instrument and the floor is correct?', null, md5('apphysics1-mcq-b5-sv-h-2.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The floor pushes up with 120 N, and the instrument pushes down on the floor with 80 N, its weight.', false, 'The downward push on the floor is the third-law partner of the upward 120 N force, so it is 120 N. The 80 N weight is exerted by Earth.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The floor pushes up on the instrument with 120 N, and the instrument pushes down on the floor with 120 N.', true, 'Correct: N − mg = ma gives N = 8.0(10 + 5.0) = 120 N. The third law gives 120 N downward on the floor, while the weight is 80 N.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both forces are 80 N, because the instrument''s weight does not depend on the rocket''s motion.', false, 'The contact force depends on the acceleration, not only on weight. N − 80 = 8.0 × 5.0 gives N = 120 N.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The floor''s 120 N push and the 80 N weight are a third-law pair, unequal because of the rocket''s acceleration.', false, 'A third-law pair always has equal magnitudes and acts on two different objects. Weight and the floor''s push both act on the instrument.' from version_ins;
-- apphysics1-mcq-b5-h-2.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.4-a', 'mcq', 'use constant velocity (net force zero) to find an unknown force by vector balance, not by assuming constant velocity nee', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A puck moves at a constant velocity of 3 m/s toward the east on frictionless ice while exactly three horizontal forces act on it. One force is 6 N toward the east and another is 8 N toward the north. What is the third force?', null, md5('apphysics1-mcq-b5-h-2.4-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10 N, directed toward the north and east.', false, 'This points the same way as the sum of the first two forces and would add to the net force instead of cancelling it. The third force must be opposite to that sum.' from version_ins
union all select gen_random_uuid(), id, 'B', '14 N, directed toward the south and west.', false, 'Forces at right angles combine by the Pythagorean theorem, not by adding magnitudes. The resultant of 6 N and 8 N is 10 N, so the third force is 10 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 N, directed toward the south.', false, 'This subtracts 6 N from 8 N, which treats perpendicular forces as if they were along one line. Perpendicular forces cannot cancel each other.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 N, directed toward the south and west.', true, 'Correct: Constant velocity means a net force of zero. The first two forces give √(6² + 8²) = 10 N toward 53° north of east, so the third is 10 N toward 53° south of west.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.4-a-v1', 'mcq', 'use constant velocity (net force zero) to find an unknown force by vector balance, not by assuming constant velocity nee (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled slides at constant velocity across a level frozen lake while exactly three horizontal forces act on it. One force is 5 N toward the west and another is 12 N toward the south. What is the third force?', null, md5('apphysics1-mcq-b5-sv-h-2.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13 N, directed toward the north and east.', true, 'Correct: Net force is zero. The first two forces give √(5² + 12²) = 13 N toward south-west, so the third force is 13 N toward north-east.' from version_ins
union all select gen_random_uuid(), id, 'B', '13 N, directed toward the south and west.', false, 'This is the direction of the sum of the first two forces, which would add to the net force. The third force must point the opposite way.' from version_ins
union all select gen_random_uuid(), id, 'C', '17 N, directed toward the north and east.', false, 'Perpendicular forces combine by the Pythagorean theorem, not by adding magnitudes. The resultant of 5 N and 12 N is 13 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '7 N, directed toward the north.', false, 'Subtracting 5 from 12 treats perpendicular forces as collinear. They cannot cancel one another, so a force at an angle is needed.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.4-a-v2', 'mcq', 'use constant velocity (net force zero) to find an unknown force by vector balance, not by assuming constant velocity nee (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg drone flies at constant velocity. The only forces on it are its weight, a horizontal wind force of 15 N directed toward the west, and the thrust from its rotors. What is the thrust?', null, md5('apphysics1-mcq-b5-sv-h-2.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '25 N, directed upward and toward the east.', true, 'Correct: Net force zero: thrust vertical component = weight = 20 N and horizontal component = 15 N toward the east. Magnitude √(20² + 15²) = 25 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '20 N, directed straight up, because the thrust only needs to cancel the weight.', false, 'The wind force of 15 N also needs cancelling, and straight-up thrust cannot do that. The thrust needs an eastward component.' from version_ins
union all select gen_random_uuid(), id, 'C', '35 N, directed upward and toward the east.', false, 'Perpendicular components of 20 N and 15 N combine as √(20² + 15²) = 25 N, not by adding magnitudes.' from version_ins
union all select gen_random_uuid(), id, 'D', '25 N, directed upward and toward the west.', false, 'A westward component would add to the westward wind force. The thrust must have an eastward component of 15 N.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.3-a-v2','apphysics1-mcq-b5-sv-h-2.3-a-v3','apphysics1-mcq-b5-h-2.3-b','apphysics1-mcq-b5-sv-h-2.3-b-v1','apphysics1-mcq-b5-sv-h-2.3-b-v2','apphysics1-mcq-b5-sv-h-2.3-b-v3','apphysics1-mcq-b5-h-2.4-a','apphysics1-mcq-b5-sv-h-2.4-a-v1','apphysics1-mcq-b5-sv-h-2.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b5-sv-h-2.3-a-v2','apphysics1-mcq-b5-sv-h-2.3-a-v3','apphysics1-mcq-b5-h-2.3-b','apphysics1-mcq-b5-sv-h-2.3-b-v1','apphysics1-mcq-b5-sv-h-2.3-b-v2','apphysics1-mcq-b5-sv-h-2.3-b-v3','apphysics1-mcq-b5-h-2.4-a','apphysics1-mcq-b5-sv-h-2.4-a-v1','apphysics1-mcq-b5-sv-h-2.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
