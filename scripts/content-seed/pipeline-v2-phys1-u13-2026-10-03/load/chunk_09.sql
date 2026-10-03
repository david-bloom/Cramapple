begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphy1-mcq-sv-np1-008-v1','apphy1-mcq-sv-np1-008-v2','apphy1-mcq-sv-np1-008-v3','apphy1-mcq-sv-np1-009-v1','apphy1-mcq-sv-np1-009-v2','apphy1-mcq-sv-np1-009-v3','apphy1-mcq-sv-np1-010-v1','apphy1-mcq-sv-np1-010-v2','apphy1-mcq-sv-np1-010-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy1-mcq-sv-np1-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-008-v1', 'mcq', 'Friction on two routes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A hockey puck is moved between two points on a rough horizontal surface, once along a straight line and once along a longer curved path. Kinetic friction acts on the puck the whole time. Which statement about the work done on the puck by friction is correct?', null, md5('apphy1-mcq-sv-np1-008-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The work is the same on both paths, because the endpoints are the same.', false, 'Equal endpoints fix the work only for conservative forces. Friction is nonconservative, and its work depends on path length.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The work is zero on both paths, because the surface is horizontal.', false, 'Horizontal motion makes the work done by gravity zero, not the work done by friction. Friction opposes the motion along the path and does negative work.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The work is larger in magnitude along the longer curved path.', true, 'Friction is nonconservative, so its work depends on the path. For constant kinetic friction the work is -f times the path length, so the longer path gives a larger magnitude.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The work is positive on both paths, because the friction force is pushing along the surface.', false, 'Kinetic friction points opposite the puck''s motion, so it does negative work on the puck.' from version_ins;
-- apphy1-mcq-sv-np1-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-008-v2', 'mcq', 'Thrown ball with air resistance', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball is thrown straight up, rises, and falls back to the height of the hand that threw it. Air resistance is not negligible. Which statement describes the net work done on the ball over the whole trip?', null, md5('apphy1-mcq-sv-np1-008-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Gravity does negative net work, and air resistance does zero net work.', false, 'This reverses the two forces. The conservative force, gravity, has zero net work over a closed trip, while air resistance does negative work throughout.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Gravity does zero net work, and air resistance does negative net work.', true, 'Gravity is conservative, so its net work over a closed trip back to the starting height is zero. Air resistance always opposes the motion, so it does negative work on the way up and on the way down.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both gravity and air resistance do zero net work, because the ball returns to its starting height.', false, 'A zero net work over a round trip holds only for conservative forces. Air resistance is nonconservative and does negative work on both parts of the trip.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both gravity and air resistance do negative net work, because both oppose the upward motion.', false, 'Gravity opposes the motion going up but helps going down, so the two contributions cancel, giving zero net work.' from version_ins;
-- apphy1-mcq-sv-np1-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-008-v3', 'mcq', 'Crate moved up a ramp by two routes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A crate is moved from the bottom of a rough ramp to a platform at the top by two different routes: a short straight slide and a long, winding slide. Both start and end at the same two points. Which statement is correct?', null, md5('apphy1-mcq-sv-np1-008-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The work done by gravity is the same for both routes, but the work done by friction is not.', true, 'Gravity is conservative, so its work depends only on the endpoints (the height change). Friction is nonconservative, so its work depends on how far the crate slides along each route.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The work done by gravity and the work done by friction are both the same for both routes.', false, 'Only the conservative force, gravity, has route-independent work. The longer route has more sliding distance and so friction does more negative work.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The work done by friction is the same for both routes, but the work done by gravity is not.', false, 'This reverses the two forces. Gravity''s work depends only on the height change, while friction''s work grows with the length of the route.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The work done by gravity and the work done by friction both differ between the routes.', false, 'Gravity''s work is fixed by the start and end heights, so it is the same for both routes even though friction''s work differs.' from version_ins;
-- apphy1-mcq-sv-np1-009-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-009-v1', 'mcq', 'Kinetic energy change of a cart', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.5 kg cart speeds up from 2 m/s to 6 m/s on a track. What is the change in the cart''s kinetic energy?', null, md5('apphy1-mcq-sv-np1-009-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3 J', false, 'This is only the initial kinetic energy, (1/2)(1.5)(2^2) = 3 J, not the change.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 J', false, 'This is (1/2)m(Delta v)^2 = (1/2)(1.5)(6 - 2)^2 = 12 J. The change in K is (1/2)m times the difference of the squared speeds, not the square of the speed change.' from version_ins
union all select gen_random_uuid(), id, 'C', '24 J', true, 'Delta K = (1/2)(1.5)(6^2) - (1/2)(1.5)(2^2) = 27 J - 3 J = 24 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '27 J', false, 'This is only the final kinetic energy, (1/2)(1.5)(6^2) = 27 J; the initial kinetic energy was not subtracted.' from version_ins;
-- apphy1-mcq-sv-np1-009-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-009-v2', 'mcq', 'Car doubling its speed', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An 800 kg car speeds up from 10 m/s to 20 m/s. What is the change in the car''s kinetic energy?', null, md5('apphy1-mcq-sv-np1-009-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '90,000 J', false, 'This is the kinetic energy at the average speed, (1/2)(800)(15^2) = 90,000 J. The change in K is the difference of the kinetic energies at 20 and 10 m/s, not the K at the mean speed.' from version_ins
union all select gen_random_uuid(), id, 'B', '40,000 J', false, 'This is (1/2)m(Delta v)^2 = (1/2)(800)(20 - 10)^2 = 40,000 J. It squares the speed change instead of taking the difference of the squared speeds.' from version_ins
union all select gen_random_uuid(), id, 'C', '120,000 J', true, 'Delta K = (1/2)(800)(20^2) - (1/2)(800)(10^2) = 160,000 J - 40,000 J = 120,000 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '160,000 J', false, 'This is only the final kinetic energy, (1/2)(800)(20^2) = 160,000 J; the initial kinetic energy was not subtracted.' from version_ins;
-- apphy1-mcq-sv-np1-009-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-009-v3', 'mcq', 'Ball slowing down', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.50 kg ball slows from 12 m/s to 8 m/s while sliding across a rough floor. What is the change in the ball''s kinetic energy?', null, md5('apphy1-mcq-sv-np1-009-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+16 J', false, 'This is only the final kinetic energy, (1/2)(0.50)(8^2) = 16 J; the initial kinetic energy was not subtracted.' from version_ins
union all select gen_random_uuid(), id, 'B', '+20 J', false, 'This has the right size but the wrong sign. The ball slows, so its final kinetic energy is less than its initial one and Delta K is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '-20 J', true, 'Delta K = (1/2)(0.50)(8^2) - (1/2)(0.50)(12^2) = 16 J - 36 J = -20 J. The negative sign shows the kinetic energy decreases.' from version_ins
union all select gen_random_uuid(), id, 'D', '-4 J', false, 'This is (1/2)m(Delta v)^2 = (1/2)(0.50)(4)^2 = 4 J with a negative sign attached. The change in K is (1/2)m times the difference of the squared speeds, which is 20 J in size.' from version_ins;
-- apphy1-mcq-sv-np1-010-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-010-v1', 'mcq', 'Tractor power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tractor pulls a plow with a constant force of 3000 N directed parallel to its motion. At one instant the tractor is moving at 2.5 m/s. What is the instantaneous power delivered by this force at that instant?', null, md5('apphy1-mcq-sv-np1-010-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1200 W', false, 'This is F/v = 3000/2.5. Power is the product of force and speed, not their quotient.' from version_ins
union all select gen_random_uuid(), id, 'B', '3002.5 W', false, 'This adds force and speed, 3000 + 2.5, which mixes unlike quantities. Power is the product Fv.' from version_ins
union all select gen_random_uuid(), id, 'C', '15000 W', false, 'This is 2Fv = 2(3000)(2.5). The power formula P = Fv has no extra factor of 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '7500 W', true, 'For a constant force parallel to the velocity, P = Fv = (3000 N)(2.5 m/s) = 7500 W.' from version_ins;
-- apphy1-mcq-sv-np1-010-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-010-v2', 'mcq', 'Rower power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rower pulls on the oars so that the force driving the boat forward is a constant 150 N, parallel to the boat''s velocity. At one instant the boat moves at 1.8 m/s. What is the instantaneous power of this force at that instant?', null, md5('apphy1-mcq-sv-np1-010-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '135 W', false, 'This is (1/2)Fv = (1/2)(150)(1.8). The factor of 1/2 belongs to kinetic energy, (1/2)mv^2, not to the power formula P = Fv.' from version_ins
union all select gen_random_uuid(), id, 'B', '270 W', true, 'P = Fv = (150 N)(1.8 m/s) = 270 W.' from version_ins
union all select gen_random_uuid(), id, 'C', '152 W', false, 'This adds force and speed, 150 + 1.8 = 151.8. Power is the product Fv, not the sum.' from version_ins
union all select gen_random_uuid(), id, 'D', '486 W', false, 'This is Fv^2 = (150)(1.8)^2 = 486. Power is force times speed, to the first power.' from version_ins;
-- apphy1-mcq-sv-np1-010-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-010-v3', 'mcq', 'Elevator cable power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cable pulls an elevator upward with a constant 12000 N force while the elevator rises at a constant speed of 0.75 m/s. What is the instantaneous power delivered by the cable''s force?', null, md5('apphy1-mcq-sv-np1-010-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9000 W', true, 'The force and velocity are parallel, so P = Fv = (12000 N)(0.75 m/s) = 9000 W.' from version_ins
union all select gen_random_uuid(), id, 'B', '6750 W', false, 'This is Fv^2 = (12000)(0.75)^2 = 6750. Power uses speed to the first power.' from version_ins
union all select gen_random_uuid(), id, 'C', '16000 W', false, 'This is F/v = 12000/0.75. Power is the product of force and speed, not the quotient.' from version_ins
union all select gen_random_uuid(), id, 'D', '4500 W', false, 'This is (1/2)Fv = (1/2)(12000)(0.75). The factor 1/2 comes from kinetic energy and does not appear in P = Fv.' from version_ins;
commit;
