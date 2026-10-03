begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphy1-mcq-sv-008-v3','apphy1-mcq-sv-019-v1','apphy1-mcq-sv-019-v2','apphy1-mcq-sv-019-v3','apphy1-mcq-sv-020-v1','apphy1-mcq-sv-020-v3','apphy1-mcq-sv-027-v1','apphy1-mcq-sv-027-v2','apphy1-mcq-sv-027-v3','apphy1-mcq-sv-028-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy1-mcq-sv-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-008-v3', 'mcq', 'Ramp potential energy loss', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg block slides down a frictionless ramp that is 5.0 m long and drops 1.5 m in vertical height from top to bottom. Use g = 10 m/s². The decrease in the block''s gravitational potential energy is', null, md5('apphy1-mcq-sv-008-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15 J', false, 'Drops the mass and multiplies g by the vertical drop: 10 × 1.5 = 15 J. The energy change is proportional to the block''s mass.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.0 J', false, 'Leaves out g and multiplies mass by height: 2.0 × 1.5 = 3.0 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '30 J', true, 'Only the vertical drop matters: ΔU_g = mgΔh = 2.0 × 10 × 1.5 = 30 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '100 J', false, 'Uses the 5.0 m length of the ramp as the height: 2.0 × 10 × 5.0 = 100 J. Gravitational potential energy depends on the change in vertical height, 1.5 m.' from version_ins;
-- apphy1-mcq-sv-019-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-019-v1', 'mcq', 'Hammer head tightening', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A loose hammer head can be tightened by banging the bottom of the handle down onto a workbench. When the handle suddenly stops, the head keeps moving down on the handle because', null, md5('apphy1-mcq-sv-019-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'the head''s inertia keeps it moving downward at its original velocity', true, 'An object keeps moving at constant velocity unless a net force changes its motion (Newton''s first law). The handle stops, but the head tends to continue moving down, which wedges it tighter onto the handle.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a downward force carried over from the handle''s motion keeps acting on the head', false, 'Forces are not stored or carried by an object; they are interactions that exist only while objects interact. The head keeps moving because of its inertia, not because a leftover force acts.' from version_ins
union all select gen_random_uuid(), id, 'C', 'air pressure pushes the head down onto the handle', false, 'Air exerts no meaningful net downward push on the head here, and nothing in the stopping of the handle creates one. The head continues downward because of inertia.' from version_ins
union all select gen_random_uuid(), id, 'D', 'the head''s weight increases when the handle stops', false, 'The head''s weight, mg, does not change when the handle stops, and a larger weight is not what keeps it moving. Its inertia keeps it moving.' from version_ins;
-- apphy1-mcq-sv-019-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-019-v2', 'mcq', 'Passenger pushed back in seat', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'When a car at rest suddenly accelerates forward, passengers feel pressed back into their seats because', null, md5('apphy1-mcq-sv-019-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'their inertia makes them tend to stay at rest', true, 'Newton''s first law: a body at rest tends to remain at rest unless acted on by a net force. The seat must push the passenger forward to accelerate them, which is felt as being pressed into the seat.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a backward force pushes on them as the car speeds up', false, 'No actual backward force acts on the passengers. They are not pushed back; the car and seat accelerate forward and the seat pushes them forward, while their inertia resists the change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'gravity pulls toward the rear of the car', false, 'Gravity points toward Earth''s center, not toward the rear of the car, and it does not change direction when the car accelerates.' from version_ins
union all select gen_random_uuid(), id, 'D', 'their mass decreases when the car speeds up', false, 'A person''s mass does not change with the car''s motion. The sensation comes from inertia, which depends on the unchanged mass.' from version_ins;
-- apphy1-mcq-sv-019-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-019-v3', 'mcq', 'Vase and pulled tablecloth', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tablecloth is yanked quickly out from under a vase, and the vase stays nearly in place. This happens mainly because', null, md5('apphy1-mcq-sv-019-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'inertia resists changes in the vase''s motion, and the cloth''s force is brief', true, 'The vase tends to remain at rest (Newton''s first law). The cloth acts on the vase for only a very short time, so the friction impulse is small and the vase''s velocity barely changes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'gravity holds the vase to the table, so friction cannot move it', false, 'Gravity does not prevent friction from acting; the vase would move if the friction force acted long enough. The vase stays nearly in place because of its inertia and the brief interaction.' from version_ins
union all select gen_random_uuid(), id, 'C', 'the cloth exerts no force at all on the vase', false, 'The cloth does exert a friction force on the vase while it slides underneath; what limits the vase''s motion is that the force acts for only a very short time. A force of zero is not required to explain why the vase barely moves.' from version_ins
union all select gen_random_uuid(), id, 'D', 'the vase gains extra mass while the cloth slides', false, 'The vase''s mass does not change while the cloth slides. Its inertia is the same; the brief interaction just cannot change its motion much.' from version_ins;
-- apphy1-mcq-sv-020-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-020-v1', 'mcq', 'Sign of tension''s work while lowering a box', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student lowers a box from a shelf to the floor at constant speed using a rope. The rope''s tension does negative work on the box. Which statement explains why the work is negative?', null, md5('apphy1-mcq-sv-020-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The box''s speed stays constant during the descent', false, 'Constant speed means the NET work is zero (gravity does +mgd, tension does -mgd). It does not by itself make the tension''s work negative; the sign comes from the tension opposing the displacement.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The tension is smaller than the box''s weight', false, 'At constant speed the net force is zero, so T = mg exactly; the statement is false. Even if it were true, the sign of work depends on the angle between force and displacement, not on the force''s size relative to weight.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The downward displacement counts as the negative direction', false, 'The sign of work is set by the relative orientation of force and displacement, not by which way displacement points in a coordinate system. Gravity also points down along the downward displacement and does positive work (+mgd).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The tension points upward, opposite the box''s downward displacement', true, 'Work is F d cos(theta). The rope pulls up while the box moves down, so theta = 180 degrees and cos(theta) = -1, making the tension''s work negative (-mg d, since T = mg at constant speed).' from version_ins;
-- apphy1-mcq-sv-020-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-020-v3', 'mcq', 'Gravity''s work on a ball while it falls', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball is thrown straight up. While the ball is rising, gravity does negative work on it. Which statement correctly describes the work done by gravity on the ball while it falls from its highest point back down to the launch height?', null, md5('apphy1-mcq-sv-020-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Zero, since the ball''s displacement over the full trip is zero', false, 'The full round trip does have zero net displacement and zero net work by gravity, but the question concerns only the fall, where the displacement is downward by h and the work is +mgh.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Positive, since the gravitational force and the displacement both point downward', true, 'Over the fall the force (down) and the displacement (down) are in the same direction, so W = +mg h, equal in magnitude to the negative work done during the rise.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Negative, since gravity always opposes the ball''s motion', false, 'Gravity acts downward always; it opposes the motion only while the ball rises. During the fall the ball moves in the direction of the force, so the work is positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Zero, since the ball''s speed is zero at the top of its path', false, 'Speed is zero only for an instant at the top. During the fall the ball moves down a distance h under a downward force, so the work is mgh, not zero.' from version_ins;
-- apphy1-mcq-sv-027-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-027-v1', 'mcq', 'Distance while a car speeds up uniformly', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A car''s speed increases uniformly from 0 to 18 m/s in 5.0 s. How far does the car travel during these 5.0 s?', null, md5('apphy1-mcq-sv-027-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.6 m', false, 'This is the acceleration, 18 m/s / 5.0 s = 3.6 m/s^2, which is reported as though it were a distance.' from version_ins
union all select gen_random_uuid(), id, 'B', '90 m', false, 'This uses the full rectangle 18 m/s x 5.0 s = 90 m, as if the car had been at 18 m/s the entire time.' from version_ins
union all select gen_random_uuid(), id, 'C', '45 m', true, 'Displacement equals the area under the velocity-time graph, a triangle: (1/2)(5.0 s)(18 m/s) = 45 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.0 m', false, 'The average speed is (0 + 18)/2 = 9.0 m/s; reporting this speed as a distance leaves out multiplication by the 5.0 s.' from version_ins;
-- apphy1-mcq-sv-027-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-027-v2', 'mcq', 'Distance for a sled slowing but not stopping', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled glides over snow and its speed decreases uniformly from 9.0 m/s to 3.0 m/s in 6.0 s. How far does the sled travel in this time?', null, md5('apphy1-mcq-sv-027-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '54 m', false, 'This uses the initial speed for the whole interval: 9.0 m/s x 6.0 s = 54 m, ignoring that the sled slows.' from version_ins
union all select gen_random_uuid(), id, 'B', '27 m', false, 'This takes a triangle from 9.0 m/s down to zero, (1/2)(9.0)(6.0) = 27 m, ignoring that the sled still moves at 3.0 m/s at the end.' from version_ins
union all select gen_random_uuid(), id, 'C', '36 m', true, 'The average speed for uniform change is (9.0 + 3.0)/2 = 6.0 m/s, so the distance is 6.0 m/s x 6.0 s = 36 m (the trapezoid area under the velocity-time graph).' from version_ins
union all select gen_random_uuid(), id, 'D', '18 m', false, 'This uses the final speed for the whole interval: 3.0 m/s x 6.0 s = 18 m, ignoring that the sled was faster earlier.' from version_ins;
-- apphy1-mcq-sv-027-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-027-v3', 'mcq', 'Distance during a runner''s acceleration', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A runner speeds up uniformly from 2.0 m/s to 8.0 m/s with an acceleration of 1.5 m/s^2. How far does the runner travel while speeding up?', null, md5('apphy1-mcq-sv-027-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 m', true, 'The time is (8.0 - 2.0)/1.5 = 4.0 s. The average speed is (2.0 + 8.0)/2 = 5.0 m/s, so the distance is 5.0 x 4.0 = 20 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '16 m', false, 'This computes a triangle from rest, (1/2)(8.0)(4.0) = 16 m, leaving out the area from the 2.0 m/s starting speed.' from version_ins
union all select gen_random_uuid(), id, 'C', '32 m', false, 'This uses the final speed for the whole 4.0 s: 8.0 x 4.0 = 32 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '8.0 m', false, 'This uses the initial speed for the whole 4.0 s: 2.0 x 4.0 = 8.0 m.' from version_ins;
-- apphy1-mcq-sv-028-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-028-v1', 'mcq', 'Stone thrown horizontally from a bridge', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A stone is thrown horizontally at 12 m/s from a bridge 45 m above a river. Neglect air resistance and use g = 10 m/s^2. How far horizontally from the point of release does the stone hit the water?', null, md5('apphy1-mcq-sv-028-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '54 m', false, 'This takes t = h/g = 4.5 s (no square root, no factor 2), giving 12 x 4.5 = 54 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '36 m', true, 'Fall time: 45 = (1/2)(10)t^2 gives t = 3.0 s. Horizontal speed is constant, so the range is 12 x 3.0 = 36 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '45 m', false, 'This treats the 45 m height as the horizontal distance.' from version_ins
union all select gen_random_uuid(), id, 'D', '25 m', false, 'This uses t = sqrt(h/g) = sqrt(4.5) = 2.12 s, dropping the factor of 2 in h = (1/2)g t^2; 12 x 2.12 = 25 m.' from version_ins;
commit;
