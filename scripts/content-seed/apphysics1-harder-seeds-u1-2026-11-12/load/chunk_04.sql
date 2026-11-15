begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-sv-h-1.4-a-v3','apphysics1-mcq-b6-h-1.4-b','apphysics1-mcq-b6-sv-h-1.4-b-v1','apphysics1-mcq-b6-sv-h-1.4-b-v2','apphysics1-mcq-b6-sv-h-1.4-b-v3','apphysics1-mcq-b6-h-1.5-a','apphysics1-mcq-b6-sv-h-1.5-a-v1','apphysics1-mcq-b6-sv-h-1.5-a-v2','apphysics1-mcq-b6-sv-h-1.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apphysics1-mcq-b6-sv-h-1.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.4-a-v3', 'mcq', 'combine and subtract signed velocities in one dimension across two or three reference frames (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A river flows east at 3.0 m/s relative to the ground. A boat moves directly upstream, heading west, at 5.0 m/s relative to the water. A log floats freely with the current. Which choice gives the boat''s velocity relative to the ground and the log''s velocity relative to the boat?', null, md5('apphysics1-mcq-b6-sv-h-1.4-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Boat: 8.0 m/s west; log relative to boat: 11 m/s east.', false, 'The current opposes the boat''s westward motion since the boat heads upstream. The velocities subtract, giving 5.0 − 3.0 = 2.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Boat: 2.0 m/s west; log relative to boat: 5.0 m/s east.', true, 'Correct: East positive: v_boat/ground = −5.0 + 3.0 = −2.0 m/s. v_log/boat = +3.0 − (−2.0) = +5.0 m/s. The log moves with the water, so v_log/boat equals the boat''s speed through the water.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Boat: 2.0 m/s west; log relative to boat: 5.0 m/s west.', false, 'The log drifts east relative to the ground while the boat moves west. From the boat, the log therefore moves east, not west.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Boat: 5.0 m/s west; log relative to boat: 8.0 m/s east.', false, 'The boat''s 5.0 m/s is measured relative to the water, not to the ground. The current has to be added in to find the ground velocity.' from version_ins;
-- apphysics1-mcq-b6-h-1.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.4-b', 'mcq', 'identify which quantities are invariant between frames moving at constant relative velocity (acceleration, time) and whi', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A train car moves east at a constant 20 m/s on straight, level track. A passenger tosses a ball straight up relative to the car, and it comes back to her hand. An observer on the ground watches the same flight. Which pair of quantities has the same value for both observers?', null, md5('apphysics1-mcq-b6-h-1.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The ball''s acceleration and its time of flight.', true, 'Correct: Frames moving at constant relative velocity agree on acceleration (10 m/s² down) and elapsed time, but disagree on velocities, positions, and path shape.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The ball''s speed at the highest point and its acceleration.', false, 'At the top, the passenger sees zero speed, but the ground observer sees the ball still moving east at 20 m/s. The speeds differ even though the acceleration agrees.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The shape of the ball''s path and its initial velocity.', false, 'The passenger sees a straight vertical path, while the ground observer sees a parabola. The initial velocities also differ by the 20 m/s of the train.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The ball''s velocity at release and its time of flight.', false, 'The ground observer measures a horizontal component of 20 m/s that the passenger does not. The time of flight agrees, but the release velocity does not.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.4-b-v1', 'mcq', 'identify which quantities are invariant between frames moving at constant relative velocity (acceleration, time) and whi (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An elevator rises at a constant 3.0 m/s. A rider releases a coin from rest, relative to the elevator, and it falls to the floor. An observer outside the shaft watches the same event. Which pair of quantities has the same value for both observers?', null, md5('apphysics1-mcq-b6-sv-h-1.4-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The coin''s initial velocity and its acceleration.', false, 'The rider sees the coin start from rest, but the outside observer sees it start moving upward at 3.0 m/s. The initial velocities do not agree.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The coin''s displacement and the time it takes to reach the floor.', false, 'The elevator rises during the fall, so the outside observer sees a different displacement for the coin than the rider does.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The coin''s acceleration and the time it takes to reach the floor.', true, 'Correct: The elevator moves at constant velocity, so both frames measure a = 10 m/s² downward and the same fall time. Velocities and displacements differ by the elevator''s 3.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The coin''s speed when it reaches the floor and its acceleration.', false, 'The speeds differ at impact because the observers measure velocity relative to different frames. Only the change in velocity is shared.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.4-b-v2', 'mcq', 'identify which quantities are invariant between frames moving at constant relative velocity (acceleration, time) and whi (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A boat moves at a constant 4.0 m/s east on calm water. A sailor throws a ball straight up relative to the boat, and she catches it at the same point on the deck. Someone on a stationary pier watches the flight. Which statement about the two observers'' measurements is correct?', null, md5('apphysics1-mcq-b6-sv-h-1.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'They agree on the ball''s horizontal velocity but disagree about its acceleration.', false, 'The pier observer sees the ball move east at 4.0 m/s, while the sailor sees no horizontal motion. The acceleration is 10 m/s² downward for both.' from version_ins
union all select gen_random_uuid(), id, 'B', 'They agree on the ball''s acceleration and its flight time but disagree about its horizontal velocity.', true, 'Correct: Constant relative velocity means the frames differ only by a constant velocity: a and t are shared, horizontal velocity (0 versus 4.0 m/s) is not.' from version_ins
union all select gen_random_uuid(), id, 'C', 'They agree on the distance the ball travels but disagree about its flight time.', false, 'The pier observer sees a longer, curved path, so the distance differs. The flight time is the same in both frames.' from version_ins
union all select gen_random_uuid(), id, 'D', 'They agree on nothing about the ball''s motion, since the frames are moving relative to each other.', false, 'Frames moving at constant velocity relative to each other agree on accelerations and on elapsed time. Disagreement is limited to velocity and position values.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.4-b-v3', 'mcq', 'identify which quantities are invariant between frames moving at constant relative velocity (acceleration, time) and whi (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart rolls east at a constant 2.0 m/s along a lab bench. A spring in the cart launches a marble straight up, relative to the cart, and the marble lands back in the cart. A student at rest next to the bench also records the flight. Which choice lists quantities that are the same for both students?', null, md5('apphysics1-mcq-b6-sv-h-1.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The marble''s acceleration and the time of flight.', true, 'Correct: A cart moving at constant velocity is an inertial frame, so both students measure a = 10 m/s² and the same time. The horizontal velocity differs by 2.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The marble''s acceleration and the horizontal distance it travels.', false, 'The student at the bench sees the marble travel east with the cart, while the student riding the cart sees no horizontal travel. The distances differ.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The marble''s speed at launch and the time of flight.', false, 'The bench student sees a launch speed that combines the upward speed with the cart''s 2.0 m/s. The launch speeds therefore differ.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The marble''s speed at the top of its path and its acceleration.', false, 'At the top, the cart student measures zero speed, while the bench student measures 2.0 m/s. The speeds differ.' from version_ins;
-- apphysics1-mcq-b6-h-1.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.5-a', 'mcq', 'resolve projectile velocity into independent horizontal (constant) and vertical (g-accelerated) components past the apex', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball is kicked from level ground with an initial horizontal velocity component of 12 m/s and an initial vertical component of 16 m/s. Neglecting air resistance, which choice gives the ball''s speed and acceleration at t = 2.4 s, which is after it has passed its highest point?', null, md5('apphysics1-mcq-b6-h-1.5-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Speed 8 m/s; acceleration 10 m/s² downward.', false, 'The horizontal velocity component stays at 12 m/s, so it must be included. The speed is the magnitude of both components combined, not just the vertical one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Speed about 14.4 m/s; acceleration 10 m/s² downward.', true, 'Correct: The object peaks at t = 1.6 s. At t = 2.4 s, v_y = 16 − 10(2.4) = -8 m/s, v_x = 12 m/s, speed = sqrt(12² + -8²) = 14.4 m/s. The acceleration is 10 m/s² down all the way.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Speed 12 m/s; acceleration 10 m/s² downward.', false, 'The horizontal component is constant, but the vertical component is now 8 m/s, which is not zero at this instant. The speed combines both.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Speed 20 m/s; acceleration 10 m/s² downward.', false, 'Speed is the magnitude of the vector, found by combining perpendicular components with the Pythagorean theorem. Adding the components directly overestimates it.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.5-a-v1', 'mcq', 'resolve projectile velocity into independent horizontal (constant) and vertical (g-accelerated) components past the apex (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A stone leaves a launcher on level ground with horizontal component 15 m/s and vertical component 20 m/s. Neglecting air resistance, which choice gives the stone''s speed and acceleration at t = 3.0 s, after it has passed its highest point?', null, md5('apphysics1-mcq-b6-sv-h-1.5-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Speed about 18.0 m/s; acceleration 10 m/s² downward.', true, 'Correct: The object peaks at t = 2.0 s. At t = 3.0 s, v_y = 20 − 10(3.0) = -10 m/s, v_x = 15 m/s, speed = sqrt(15² + -10²) = 18.0 m/s. The acceleration is 10 m/s² down all the way.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Speed 10 m/s; acceleration 10 m/s² downward.', false, 'The horizontal velocity component stays at 15 m/s, so it must be included. The speed is the magnitude of both components combined, not just the vertical one.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Speed 15 m/s; acceleration 10 m/s² downward.', false, 'The horizontal component is constant, but the vertical component is now 10 m/s, which is not zero at this instant. The speed combines both.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Speed 25 m/s; acceleration 10 m/s² downward.', false, 'Speed is the magnitude of the vector, found by combining perpendicular components with the Pythagorean theorem. Adding the components directly overestimates it.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.5-a-v2', 'mcq', 'resolve projectile velocity into independent horizontal (constant) and vertical (g-accelerated) components past the apex (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A soccer ball leaves the ground with horizontal component 8.0 m/s and vertical component 6.0 m/s. Neglecting air resistance, which choice gives its speed and acceleration at t = 1.0 s, after it has passed its highest point?', null, md5('apphysics1-mcq-b6-sv-h-1.5-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Speed 4 m/s; acceleration 10 m/s² downward.', false, 'The horizontal velocity component stays at 8 m/s, so it must be included. The speed is the magnitude of both components combined, not just the vertical one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Speed 8 m/s; acceleration 10 m/s² downward.', false, 'The horizontal component is constant, but the vertical component is now 4 m/s, which is not zero at this instant. The speed combines both.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Speed about 8.9 m/s; acceleration 10 m/s² downward.', true, 'Correct: The object peaks at t = 0.6 s. At t = 1.0 s, v_y = 6 − 10(1.0) = -4 m/s, v_x = 8 m/s, speed = sqrt(8² + -4²) = 8.9 m/s. The acceleration is 10 m/s² down all the way.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Speed 12 m/s; acceleration 10 m/s² downward.', false, 'Speed is the magnitude of the vector, found by combining perpendicular components with the Pythagorean theorem. Adding the components directly overestimates it.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.5-a-v3', 'mcq', 'resolve projectile velocity into independent horizontal (constant) and vertical (g-accelerated) components past the apex (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rocket-powered toy is launched from level ground, after which it is a free projectile with horizontal component 40 m/s and vertical component 30 m/s. Neglecting air resistance, which choice gives its speed and acceleration at t = 4.0 s, after it has passed its highest point?', null, md5('apphysics1-mcq-b6-sv-h-1.5-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Speed about 41.2 m/s; acceleration 10 m/s² downward.', true, 'Correct: The object peaks at t = 3.0 s. At t = 4.0 s, v_y = 30 − 10(4.0) = -10 m/s, v_x = 40 m/s, speed = sqrt(40² + -10²) = 41.2 m/s. The acceleration is 10 m/s² down all the way.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Speed 10 m/s; acceleration 10 m/s² downward.', false, 'The horizontal velocity component stays at 40 m/s, so it must be included. The speed is the magnitude of both components combined, not just the vertical one.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Speed 40 m/s; acceleration 10 m/s² downward.', false, 'The horizontal component is constant, but the vertical component is now 10 m/s, which is not zero at this instant. The speed combines both.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Speed 50 m/s; acceleration 10 m/s² downward.', false, 'Speed is the magnitude of the vector, found by combining perpendicular components with the Pythagorean theorem. Adding the components directly overestimates it.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-sv-h-1.4-a-v3','apphysics1-mcq-b6-h-1.4-b','apphysics1-mcq-b6-sv-h-1.4-b-v1','apphysics1-mcq-b6-sv-h-1.4-b-v2','apphysics1-mcq-b6-sv-h-1.4-b-v3','apphysics1-mcq-b6-h-1.5-a','apphysics1-mcq-b6-sv-h-1.5-a-v1','apphysics1-mcq-b6-sv-h-1.5-a-v2','apphysics1-mcq-b6-sv-h-1.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b6-sv-h-1.4-a-v3','apphysics1-mcq-b6-h-1.4-b','apphysics1-mcq-b6-sv-h-1.4-b-v1','apphysics1-mcq-b6-sv-h-1.4-b-v2','apphysics1-mcq-b6-sv-h-1.4-b-v3','apphysics1-mcq-b6-h-1.5-a','apphysics1-mcq-b6-sv-h-1.5-a-v1','apphysics1-mcq-b6-sv-h-1.5-a-v2','apphysics1-mcq-b6-sv-h-1.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
