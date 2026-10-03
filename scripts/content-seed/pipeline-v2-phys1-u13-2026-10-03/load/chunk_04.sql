begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphy1-mcq-sv-028-v2','apphy1-mcq-sv-028-v3','apphy1-mcq-sv-029-v1','apphy1-mcq-sv-029-v2','apphy1-mcq-sv-029-v3','apphy1-mcq-sv-030-v1','apphy1-mcq-sv-030-v2','apphy1-mcq-sv-030-v3','apphy1-mcq-sv-031-v1','apphy1-mcq-sv-031-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy1-mcq-sv-028-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-028-v2', 'mcq', 'Package dropped from a level-flying drone', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone flying level at 15 m/s, 80 m above the ground, releases a package. Neglect air resistance and use g = 10 m/s^2. How far horizontally from the release point does the package land?', null, md5('apphy1-mcq-sv-028-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 m', true, 'Fall time: 80 = (1/2)(10)t^2 gives t = 4.0 s. The package keeps the drone''s 15 m/s horizontally, so the distance is 15 x 4.0 = 60 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '42 m', false, 'This uses t = sqrt(h/g) = sqrt(8.0) = 2.83 s, omitting the factor 2; 15 x 2.83 = 42 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '80 m', false, 'This treats the 80 m height as the horizontal distance.' from version_ins
union all select gen_random_uuid(), id, 'D', '120 m', false, 'This takes t = h/g = 8.0 s (no square root, no factor 2), giving 15 x 8.0 = 120 m.' from version_ins;
-- apphy1-mcq-sv-028-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-028-v3', 'mcq', 'Marble rolling off a table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A marble rolls off the edge of a table 1.25 m high with a horizontal speed of 2.0 m/s. Neglect air resistance and use g = 10 m/s^2. How far from the base of the table does the marble land?', null, md5('apphy1-mcq-sv-028-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.0 m', true, 'Fall time: 1.25 = (1/2)(10)t^2 gives t = 0.50 s. Horizontal distance is 2.0 x 0.50 = 1.0 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.25 m', false, 'This treats the table height as the horizontal distance.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.25 m', false, 'This takes t = h/g = 0.125 s (no square root, no factor 2), giving 2.0 x 0.125 = 0.25 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.71 m', false, 'This uses t = sqrt(h/g) = sqrt(0.125) = 0.354 s, omitting the factor 2; 2.0 x 0.354 = 0.71 m.' from version_ins;
-- apphy1-mcq-sv-029-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-029-v1', 'mcq', 'Relative velocity of cars in opposite directions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On a straight north-south highway, car P travels north at 25 m/s and car Q travels south at 15 m/s. What is the velocity of Q relative to P?', null, md5('apphy1-mcq-sv-029-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40 m/s north', false, 'The magnitude is right but the direction is reversed; that is the velocity of P relative to Q (+25 - (-15) = +40 m/s).' from version_ins
union all select gen_random_uuid(), id, 'B', '10 m/s south', false, 'This subtracts the speeds, 25 - 15 = 10 m/s, as if the cars moved in the same direction, and keeps Q''s direction.' from version_ins
union all select gen_random_uuid(), id, 'C', '40 m/s south', true, 'Taking north as positive, v_Q = -15 m/s and v_P = +25 m/s. v_Q/P = v_Q - v_P = -15 - 25 = -40 m/s, i.e. 40 m/s south.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 m/s north', false, 'This subtracts the speeds, 25 - 15 = 10 m/s, as if the cars moved in the same direction, and keeps P''s direction.' from version_ins;
-- apphy1-mcq-sv-029-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-029-v2', 'mcq', 'Passenger walking in a moving train', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A train moves east at 32 m/s relative to the ground. A passenger walks toward the rear of the train at 2.0 m/s relative to the train. What is the passenger''s velocity relative to the ground?', null, md5('apphy1-mcq-sv-029-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.0 m/s west', false, 'This is the passenger''s velocity relative to the train, not relative to the ground.' from version_ins
union all select gen_random_uuid(), id, 'B', '32 m/s east', false, 'This reports only the train''s velocity and leaves out the passenger''s walking motion.' from version_ins
union all select gen_random_uuid(), id, 'C', '34 m/s east', false, 'This adds the speeds, 32 + 2.0 = 34, as if the passenger were walking toward the front.' from version_ins
union all select gen_random_uuid(), id, 'D', '30 m/s east', true, 'With east positive, v_passenger/ground = v_train/ground + v_passenger/train = +32 + (-2.0) = +30 m/s, i.e. 30 m/s east.' from version_ins;
-- apphy1-mcq-sv-029-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-029-v3', 'mcq', 'Relative velocity seen from the faster boat', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two boats move north on a straight channel. Boat X travels at 9.0 m/s and boat Y travels at 14 m/s. What is the velocity of X relative to Y?', null, md5('apphy1-mcq-sv-029-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.0 m/s south', true, 'Taking north as positive, v_X/Y = v_X - v_Y = 9.0 - 14 = -5.0 m/s, i.e. 5.0 m/s south: Y pulls ahead, so from Y, X appears to drift backward.' from version_ins
union all select gen_random_uuid(), id, 'B', '23 m/s north', false, 'This adds the speeds, 9.0 + 14 = 23, which applies to objects moving in opposite directions, and keeps the direction of motion.' from version_ins
union all select gen_random_uuid(), id, 'C', '23 m/s south', false, 'This adds the speeds, 9.0 + 14 = 23, which applies to objects moving in opposite directions, and then assigns a southward direction.' from version_ins
union all select gen_random_uuid(), id, 'D', '5.0 m/s north', false, 'The magnitude is right but the sign is reversed; +5.0 m/s north is the velocity of Y relative to X (14 - 9.0).' from version_ins;
-- apphy1-mcq-sv-030-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-030-v1', 'mcq', 'Bowling ball striking a pin', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bowling ball strikes a single pin that is much lighter than the ball. During the impact, how do the force of the ball on the pin and the force of the pin on the ball compare?', null, md5('apphy1-mcq-sv-030-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The pin''s force on the ball is larger, since the pin accelerates more', false, 'A larger acceleration comes from the smaller mass (a = F/m) with the same force; it does not mean a larger force. Both forces are equal in magnitude.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The ball''s force on the pin is larger, since the ball is heavier', false, 'Mass does not change the size of the interaction forces; they are equal. The heavier ball simply has a smaller acceleration than the pin.' from version_ins
union all select gen_random_uuid(), id, 'C', 'They are equal only if the two objects have equal accelerations', false, 'Third-law forces are equal in magnitude for any pair of interacting objects, whatever their accelerations or masses.' from version_ins
union all select gen_random_uuid(), id, 'D', 'They have equal magnitudes and opposite directions', true, 'Newton''s third law: F(ball on pin) = -F(pin on ball) at every instant, regardless of mass. The pin accelerates more only because its mass is smaller (a = F/m).' from version_ins;
-- apphy1-mcq-sv-030-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-030-v2', 'mcq', 'Person pushing on a wall', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A person standing on a skateboard pushes horizontally on a rigid wall and rolls backward away from it. Which statement about the forces between the person and the wall is correct?', null, md5('apphy1-mcq-sv-030-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The wall exerts no force on the person because the wall does not move', false, 'A wall that stays at rest still exerts a (normal) force; that force is what accelerates the person. Not moving only means the wall''s net force is zero, not that it exerts no force.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The wall pushes on the person with a force equal in size to the person''s push on the wall', true, 'The two forces are a third-law pair, equal in magnitude and opposite in direction. The wall''s push is the net horizontal force that accelerates the person backward.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The wall''s push on the person is smaller since the wall has no acceleration', false, 'The wall does not accelerate because other forces (from the ground and building) balance the person''s push on it; the interaction forces are still equal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The person''s push on the wall is larger because the person starts the interaction', false, 'Neither object ''starts'' the force; the two forces arise together and are always equal in magnitude.' from version_ins;
-- apphy1-mcq-sv-030-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-030-v3', 'mcq', 'Earth-Moon gravitational interaction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Earth exerts a gravitational force of magnitude F on the Moon. Which statement describes the gravitational force the Moon exerts on Earth?', null, md5('apphy1-mcq-sv-030-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It has magnitude F and is directed away from the Moon', false, 'Opposite directions in a third-law pair means each force points toward the other body (here the Moon''s pull on Earth points toward the Moon); gravity is always attractive, so a push away from the Moon is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It has magnitude F and is directed toward the Moon', true, 'The Moon-on-Earth force is the third-law partner of the Earth-on-Moon force: same magnitude F, opposite direction (toward the Moon rather than toward Earth).' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is smaller than F because the Moon has less mass', false, 'Gravity between two bodies is G m1 m2 / r^2, which is the same for each of them; the Moon''s smaller mass only makes its acceleration larger, not the force smaller.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is zero because Earth''s acceleration is negligible', false, 'Earth''s acceleration is tiny only because its mass is huge (a = F/m); the force on it from the Moon is still F, and it causes ocean tides.' from version_ins;
-- apphy1-mcq-sv-031-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-031-v1', 'mcq', 'Gravitational field at triple the radius', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At the surface of a planet, a distance R from its center, the gravitational field is 8.0 N/kg. What is the field at a distance of 3R from the planet''s center?', null, md5('apphy1-mcq-sv-031-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '72 N/kg', false, 'This multiplies by the square of the distance ratio, 8.0 x 3^2 = 72, instead of dividing.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.89 N/kg', true, 'The field varies as 1/r^2, so at 3R it is 8.0/3^2 = 8.0/9 = 0.89 N/kg.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.7 N/kg', false, 'This scales as 1/r, 8.0/3 = 2.7, missing the square on the distance.' from version_ins
union all select gen_random_uuid(), id, 'D', '24 N/kg', false, 'This scales the field directly with distance, 8.0 x 3 = 24.' from version_ins;
-- apphy1-mcq-sv-031-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-031-v2', 'mcq', 'Astronaut''s weight at altitude R', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An astronaut weighs 800 N at Earth''s surface. Her spacecraft orbits at an altitude equal to Earth''s radius R above the surface. What gravitational force does Earth exert on her there?', null, md5('apphy1-mcq-sv-031-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '400 N', false, 'This uses 800/2, an inverse-linear dependence on the distance 2R.' from version_ins
union all select gen_random_uuid(), id, 'B', '200 N', true, 'The altitude R above the surface places her 2R from Earth''s center. The force scales as 1/r^2, so F = 800/2^2 = 200 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '3200 N', false, 'This multiplies by 2^2 = 4 instead of dividing, 800 x 4 = 3200 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '800 N', false, 'This treats the altitude R as the distance from the center, so r = R and the force is unchanged.' from version_ins;
commit;
