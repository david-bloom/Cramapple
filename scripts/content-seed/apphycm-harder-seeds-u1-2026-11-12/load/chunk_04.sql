begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-sv-h-1.4-a-v3','apphycm-mcq-b6-h-1.4-b','apphycm-mcq-b6-sv-h-1.4-b-v1','apphycm-mcq-b6-sv-h-1.4-b-v2','apphycm-mcq-b6-sv-h-1.4-b-v3','apphycm-mcq-b6-h-1.5-a','apphycm-mcq-b6-sv-h-1.5-a-v1','apphycm-mcq-b6-sv-h-1.5-a-v2','apphycm-mcq-b6-sv-h-1.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apphycm-mcq-b6-sv-h-1.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.4-a-v3', 'mcq', 'use relative (closing) speed in one dimension for pursuit and approach, then convert time back to ground-frame distance  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two boats on a straight canal start 200 m apart and head straight toward each other. Boat A moves at 25 m/s and boat B at 15 m/s, both relative to the shore and constant. How far does boat B travel relative to the shore before they meet?', null, md5('apphycm-mcq-b6-sv-h-1.4-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '125 m', false, 'This is the distance traveled by the other object during the same time. The question asks for the distance for the named object, found from its own speed multiplied by the common time.' from version_ins
union all select gen_random_uuid(), id, 'B', '75 m', true, 'Correct: Closing speed = 40 m/s; t = 200/40 = 5 s; distance = 15·5 = 75 m. Other object: 25·5 = 125 m. Wrong closing speed 10: t = 20 s → 300 m. Gap = 200 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '300 m', false, 'The closing speed was found by subtracting the speeds, which applies only when the objects move the same way. Here they approach each other, so the gap closes at the sum of the speeds.' from version_ins
union all select gen_random_uuid(), id, 'D', '200 m', false, 'This is only the initial separation. Each object keeps moving while the gap closes, so the distance traveled by one object is its own speed multiplied by the time until they meet, not the gap itself.' from version_ins;
-- apphycm-mcq-b6-h-1.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.4-b', 'mcq', 'resolve a river-crossing problem into independent perpendicular motions in the ground frame: crossing time from the boat', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A river is 120 m wide and flows east at 3 m/s relative to the banks. A boat has a speed of 4 m/s relative to the water, and its heading is kept pointed directly north, perpendicular to the banks. Which choice gives the crossing time and the downstream drift when it reaches the far bank?', null, md5('apphycm-mcq-b6-h-1.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Crossing time 30 s; downstream drift 90 m.', true, 'Correct: Heading straight across: t = W/u = 120/4 = 30 s; drift = w·t = 3·30 = 90 m. Resultant speed 5: t = 24, drift = 72. Swapped: t = 40, drift = 160. Boat speed × t = 120.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Crossing time 24 s; downstream drift 72 m.', false, 'The boat''s speed relative to the water, not the resultant speed relative to the bank, sets the crossing time, because only the boat''s heading component across the river carries it across. Using the resultant speed over the width is too fast.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Crossing time 40 s; downstream drift 160 m.', false, 'This swaps the roles of the speeds. The crossing time is the river width divided by the boat''s speed across the river, and the drift is the current speed multiplied by that time.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Crossing time 30 s; downstream drift 120 m.', false, 'The crossing time is right, but the drift is found with the boat''s speed instead of the current''s. The sideways drift comes from the current carrying the boat downstream during the crossing.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.4-b-v1', 'mcq', 'resolve a river-crossing problem into independent perpendicular motions in the ground frame: crossing time from the boat (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A canal 150 m wide has water flowing east at 8 m/s relative to the ground. A motorboat moves at 6 m/s relative to the water and is steered with its bow pointed directly across, perpendicular to the banks. Which choice gives the crossing time and the downstream drift?', null, md5('apphycm-mcq-b6-sv-h-1.4-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Crossing time 15 s; downstream drift 120 m.', false, 'The boat''s speed relative to the water, not the resultant speed relative to the bank, sets the crossing time, because only the boat''s heading component across the river carries it across. Using the resultant speed over the width is too fast.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Crossing time 18.8 s; downstream drift 112.5 m.', false, 'This swaps the roles of the speeds. The crossing time is the river width divided by the boat''s speed across the river, and the drift is the current speed multiplied by that time.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Crossing time 25 s; downstream drift 200 m.', true, 'Correct: Heading straight across: t = W/u = 150/6 = 25 s; drift = w·t = 8·25 = 200 m. Resultant speed 10: t = 15, drift = 120. Swapped: t = 18.75, drift = 112.5. Boat speed × t = 150.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Crossing time 25 s; downstream drift 150 m.', false, 'The crossing time is right, but the drift is found with the boat''s speed instead of the current''s. The sideways drift comes from the current carrying the boat downstream during the crossing.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.4-b-v2', 'mcq', 'resolve a river-crossing problem into independent perpendicular motions in the ground frame: crossing time from the boat (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A swimmer crosses a 60 m wide stream whose water flows downstream at 2.0 m/s relative to the shore. She swims at 1.5 m/s relative to the water, always pointed straight across, perpendicular to the shore. Which choice gives her crossing time and how far downstream she lands from the point directly opposite her start?', null, md5('apphycm-mcq-b6-sv-h-1.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Crossing time 24 s; downstream drift 48 m.', false, 'The boat''s speed relative to the water, not the resultant speed relative to the bank, sets the crossing time, because only the boat''s heading component across the river carries it across. Using the resultant speed over the width is too fast.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Crossing time 40 s; downstream drift 80 m.', true, 'Correct: Heading straight across: t = W/u = 60/1.5 = 40 s; drift = w·t = 2·40 = 80 m. Resultant speed 2.5: t = 24, drift = 48. Swapped: t = 30, drift = 45. Boat speed × t = 60.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Crossing time 30 s; downstream drift 45 m.', false, 'This swaps the roles of the speeds. The crossing time is the river width divided by the boat''s speed across the river, and the drift is the current speed multiplied by that time.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Crossing time 40 s; downstream drift 60 m.', false, 'The crossing time is right, but the drift is found with the boat''s speed instead of the current''s. The sideways drift comes from the current carrying the boat downstream during the crossing.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.4-b-v3', 'mcq', 'resolve a river-crossing problem into independent perpendicular motions in the ground frame: crossing time from the boat (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ferry points its bow straight across a 120 m wide river. The ferry''s speed relative to the water is 8 m/s, and the river flows at 15 m/s relative to the banks. Which choice gives the crossing time and the downstream drift?', null, md5('apphycm-mcq-b6-sv-h-1.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Crossing time 15 s; downstream drift 225 m.', true, 'Correct: Heading straight across: t = W/u = 120/8 = 15 s; drift = w·t = 15·15 = 225 m. Resultant speed 17: t = 7.059, drift = 105.882. Swapped: t = 8, drift = 64. Boat speed × t = 120.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Crossing time 7.1 s; downstream drift 105.9 m.', false, 'The boat''s speed relative to the water, not the resultant speed relative to the bank, sets the crossing time, because only the boat''s heading component across the river carries it across. Using the resultant speed over the width is too fast.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Crossing time 8 s; downstream drift 64 m.', false, 'This swaps the roles of the speeds. The crossing time is the river width divided by the boat''s speed across the river, and the drift is the current speed multiplied by that time.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Crossing time 15 s; downstream drift 120 m.', false, 'The crossing time is right, but the drift is found with the boat''s speed instead of the current''s. The sideways drift comes from the current carrying the boat downstream during the crossing.' from version_ins;
-- apphycm-mcq-b6-h-1.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.5-a', 'mcq', 'solve two-dimensional projectile motion launched from a height with a quadratic for the time of flight, using separate h', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball is launched from the top of a 20 m cliff with a speed of 25 m/s at 37° above the horizontal (take sin 37° = 0.60 and cos 37° = 0.80). Neglect air resistance and use g = 10 m/s². How far from the base of the cliff, horizontally, does the ball land on the level ground below?', null, md5('apphycm-mcq-b6-h-1.5-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 m', false, 'This uses the flight time for a launch and landing at the same height. The landing point is lower than the launch point, so the ball stays in the air longer and travels farther.' from version_ins
union all select gen_random_uuid(), id, 'B', '80 m', true, 'Correct: Taking up as positive, y: h + vy·t − 5t² = 0 with h = 20, vy = 15; t = 4 s. Range = 20·4 = 80 m. Free-fall time √(2h/g) = 2 s → 40 m. Flat-ground time = 2·15/10 = 3 s → 60 m. Launch speed 25·t = 100 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '40 m', false, 'This uses only the time to fall the height h from rest. The ball first rises, so its vertical motion starts with an upward velocity and the total time is longer than a drop from rest.' from version_ins
union all select gen_random_uuid(), id, 'D', '100 m', false, 'The horizontal distance is the horizontal velocity component times time, not the launch speed times time. The launch speed includes the vertical component, which does not move the ball horizontally.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.5-a-v1', 'mcq', 'solve two-dimensional projectile motion launched from a height with a quadratic for the time of flight, using separate h (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A stone is thrown from the edge of a 15 m high roof with a horizontal velocity component of 12 m/s and an upward velocity component of 10 m/s. Neglect air resistance and use g = 10 m/s². At what horizontal distance from the building''s wall does it land on level ground?', null, md5('apphycm-mcq-b6-sv-h-1.5-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '36 m', true, 'Correct: Taking up as positive, y: h + vy·t − 5t² = 0 with h = 15, vy = 10; t = 3 s. Range = 12·3 = 36 m. Free-fall time √(2h/g) = 1.732 s → 20.78 m. Flat-ground time = 2·10/10 = 2 s → 24 m. Launch speed 15.62·t = 46.86 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '24 m', false, 'This uses the flight time for a launch and landing at the same height. The landing point is lower than the launch point, so the ball stays in the air longer and travels farther.' from version_ins
union all select gen_random_uuid(), id, 'C', '20.8 m', false, 'This uses only the time to fall the height h from rest. The ball first rises, so its vertical motion starts with an upward velocity and the total time is longer than a drop from rest.' from version_ins
union all select gen_random_uuid(), id, 'D', '46.9 m', false, 'The horizontal distance is the horizontal velocity component times time, not the launch speed times time. The launch speed includes the vertical component, which does not move the ball horizontally.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.5-a-v2', 'mcq', 'solve two-dimensional projectile motion launched from a height with a quadratic for the time of flight, using separate h (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A package is thrown from a balcony 30 m above level ground with a horizontal velocity component of 12 m/s and a downward velocity component of 5 m/s. Neglect air resistance and use g = 10 m/s². How far from the point directly below the balcony does the package land?', null, md5('apphycm-mcq-b6-sv-h-1.5-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '29.4 m', false, 'This uses the time to fall height h from rest, ignoring the initial downward velocity. The initial downward component makes the ball reach the ground sooner than a drop from rest.' from version_ins
union all select gen_random_uuid(), id, 'B', '36 m', false, 'This treats the initial vertical velocity as upward instead of downward. A downward launch shortens the time of flight, while an upward launch would lengthen it.' from version_ins
union all select gen_random_uuid(), id, 'C', '24 m', true, 'Correct: Taking up as positive, y: h + vy·t − 5t² = 0 with h = 30, vy = −5; t = 2 s. Range = 12·2 = 24 m. Free-fall time √(2h/g) = 2.449 s → 29.39 m. Sign-error time (initial vy upward) = 3 s → 36 m. Launch speed 13·t = 26 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '26 m', false, 'The horizontal distance is the horizontal velocity component times time, not the launch speed times time. The launch speed includes the vertical component, which does not move the object horizontally.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.5-a-v3', 'mcq', 'solve two-dimensional projectile motion launched from a height with a quadratic for the time of flight, using separate h (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone releases a ball from a height of 69 m by throwing it at 10 m/s at an angle of 53° below the horizontal (take sin 53° = 0.80 and cos 53° = 0.60). Neglect air resistance and use g = 10 m/s². How far, horizontally, does the ball land from the release point?', null, md5('apphycm-mcq-b6-sv-h-1.5-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18 m', true, 'Correct: Taking up as positive, y: h + vy·t − 5t² = 0 with h = 69, vy = −8; t = 3 s. Range = 6·3 = 18 m. Free-fall time √(2h/g) = 3.715 s → 22.29 m. Sign-error time (initial vy upward) = 4.6 s → 27.6 m. Launch speed 10·t = 30 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '22.3 m', false, 'This uses the time to fall height h from rest, ignoring the initial downward velocity. The initial downward component makes the ball reach the ground sooner than a drop from rest.' from version_ins
union all select gen_random_uuid(), id, 'C', '27.6 m', false, 'This treats the initial vertical velocity as upward instead of downward. A downward launch shortens the time of flight, while an upward launch would lengthen it.' from version_ins
union all select gen_random_uuid(), id, 'D', '30 m', false, 'The horizontal distance is the horizontal velocity component times time, not the launch speed times time. The launch speed includes the vertical component, which does not move the object horizontally.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-sv-h-1.4-a-v3','apphycm-mcq-b6-h-1.4-b','apphycm-mcq-b6-sv-h-1.4-b-v1','apphycm-mcq-b6-sv-h-1.4-b-v2','apphycm-mcq-b6-sv-h-1.4-b-v3','apphycm-mcq-b6-h-1.5-a','apphycm-mcq-b6-sv-h-1.5-a-v1','apphycm-mcq-b6-sv-h-1.5-a-v2','apphycm-mcq-b6-sv-h-1.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-b6-sv-h-1.4-a-v3','apphycm-mcq-b6-h-1.4-b','apphycm-mcq-b6-sv-h-1.4-b-v1','apphycm-mcq-b6-sv-h-1.4-b-v2','apphycm-mcq-b6-sv-h-1.4-b-v3','apphycm-mcq-b6-h-1.5-a','apphycm-mcq-b6-sv-h-1.5-a-v1','apphycm-mcq-b6-sv-h-1.5-a-v2','apphycm-mcq-b6-sv-h-1.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
