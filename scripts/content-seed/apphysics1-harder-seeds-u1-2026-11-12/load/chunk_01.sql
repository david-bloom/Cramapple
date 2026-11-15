begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-h-1.1-a','apphysics1-mcq-b6-sv-h-1.1-a-v1','apphysics1-mcq-b6-sv-h-1.1-a-v2','apphysics1-mcq-b6-sv-h-1.1-a-v3','apphysics1-mcq-b6-h-1.1-b','apphysics1-mcq-b6-sv-h-1.1-b-v1','apphysics1-mcq-b6-sv-h-1.1-b-v2','apphysics1-mcq-b6-sv-h-1.1-b-v3','apphysics1-mcq-b6-h-1.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apphysics1-mcq-b6-h-1.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.1-a', 'mcq', 'distinguish average speed (path length) from average velocity (signed displacement) when the motion reverses direction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A runner on a straight track uses an x-axis pointing east. She starts at x = +3 m, runs to x = +11 m in 4 s, then reverses and runs to x = −1 m in another 6 s. For the whole 10 s, which choice gives her average speed and average velocity?', null, md5('apphysics1-mcq-b6-h-1.1-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Average speed 2.0 m/s; average velocity +0.4 m/s.', false, 'Average velocity has the same sign as the net displacement, which is −4 m on this axis, so its sign is −. Reversing it describes the opposite displacement.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Average speed 2.0 m/s; average velocity −0.4 m/s.', true, 'Correct: Displacement = −4 m, path length = 20 m, time = 10 s. Speed = 20/10 = 2.0 m/s; velocity = −4/10 = −0.4 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Average speed 0.4 m/s; average velocity −0.4 m/s.', false, 'Average speed is total path length divided by time, 20 m over 10 s. Using the 4 m net displacement drops the back-and-forth part of the path.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Average speed 2.0 m/s; average velocity +2.0 m/s.', false, 'Average velocity uses the net displacement of −4 m, not the 20 m path length. Speed and velocity agree only when the motion never reverses.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.1-a-v1', 'mcq', 'distinguish average speed (path length) from average velocity (signed displacement) when the motion reverses direction (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart on a straight track starts at x = −5 m, rolls to x = +7 m in 3 s, then reverses and rolls to x = +1 m in the next 3 s. Using the track''s x-axis, which choice gives the cart''s average speed and average velocity over the full 6 s?', null, md5('apphysics1-mcq-b6-sv-h-1.1-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Average speed 3.0 m/s; average velocity −1.0 m/s.', false, 'Average velocity has the same sign as the net displacement, which is +6 m on this axis, so its sign is +. Reversing it describes the opposite displacement.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Average speed 3.0 m/s; average velocity +1.0 m/s.', true, 'Correct: Displacement = +6 m, path length = 18 m, time = 6 s. Speed = 18/6 = 3.0 m/s; velocity = +6/6 = +1.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Average speed 1.0 m/s; average velocity +1.0 m/s.', false, 'Average speed is total path length divided by time, 18 m over 6 s. Using the 6 m net displacement drops the back-and-forth part of the path.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Average speed 3.0 m/s; average velocity +3.0 m/s.', false, 'Average velocity uses the net displacement of +6 m, not the 18 m path length. Speed and velocity agree only when the motion never reverses.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.1-a-v2', 'mcq', 'distinguish average speed (path length) from average velocity (signed displacement) when the motion reverses direction (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An elevator car is described with a y-axis pointing up. It starts at y = +20 m, descends to y = 0 m in 8 s, then rises to y = +8 m in the next 2 s. Which choice gives its average speed and average velocity over the 10 s?', null, md5('apphysics1-mcq-b6-sv-h-1.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Average speed 2.8 m/s; average velocity −1.2 m/s.', true, 'Correct: Displacement = −12 m, path length = 28 m, time = 10 s. Speed = 28/10 = 2.8 m/s; velocity = −12/10 = −1.2 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Average speed 2.8 m/s; average velocity +1.2 m/s.', false, 'Average velocity has the same sign as the net displacement, which is −12 m on this axis, so its sign is −. Reversing it describes the opposite displacement.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Average speed 1.2 m/s; average velocity −1.2 m/s.', false, 'Average speed is total path length divided by time, 28 m over 10 s. Using the 12 m net displacement drops the back-and-forth part of the path.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Average speed 2.8 m/s; average velocity +2.8 m/s.', false, 'Average velocity uses the net displacement of −12 m, not the 28 m path length. Speed and velocity agree only when the motion never reverses.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.1-a-v3', 'mcq', 'distinguish average speed (path length) from average velocity (signed displacement) when the motion reverses direction (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball rolls along a straight groove with an x-axis pointing right. It starts at x = +4 m, reaches x = −6 m after 5 s, then turns and reaches x = −2 m after another 5 s. Which choice gives its average speed and average velocity for the 10 s?', null, md5('apphysics1-mcq-b6-sv-h-1.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Average speed 1.4 m/s; average velocity +0.6 m/s.', false, 'Average velocity has the same sign as the net displacement, which is −6 m on this axis, so its sign is −. Reversing it describes the opposite displacement.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Average speed 0.6 m/s; average velocity −0.6 m/s.', false, 'Average speed is total path length divided by time, 14 m over 10 s. Using the 6 m net displacement drops the back-and-forth part of the path.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Average speed 1.4 m/s; average velocity −0.6 m/s.', true, 'Correct: Displacement = −6 m, path length = 14 m, time = 10 s. Speed = 14/10 = 1.4 m/s; velocity = −6/10 = −0.6 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Average speed 1.4 m/s; average velocity +1.4 m/s.', false, 'Average velocity uses the net displacement of −6 m, not the 14 m path length. Speed and velocity agree only when the motion never reverses.' from version_ins;
-- apphysics1-mcq-b6-h-1.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.1-b', 'mcq', 'predict how reversing the axis direction or origin changes signed quantities (position, displacement, velocity, accelera', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball is tossed straight up from a hand, rises to its highest point, and is caught back at the same height. A student first describes the rise from release to the peak with upward as the positive direction, then describes the same rise with downward as the positive direction and the same origin. Which statement correctly compares the two descriptions?', null, md5('apphysics1-mcq-b6-h-1.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Displacement and average velocity for the rise change sign, while distance traveled and average speed keep their values.', true, 'Correct: Reversing the axis flips the sign of every vector component, so displacement and average velocity change sign. Path length and speed are magnitudes, so they do not change.' from version_ins
union all select gen_random_uuid(), id, 'B', 'All four quantities change sign, because the axis direction was reversed.', false, 'Distance traveled and average speed are magnitudes built from path length, so they have no sign to flip. Only the vector quantities depend on which way the axis points.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Displacement changes sign, but average velocity keeps its sign because the ball''s motion is unchanged.', false, 'Average velocity is displacement divided by a positive time interval, so it must take the sign of the displacement. If one flips, the other flips.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No quantity changes, since the ball''s physical motion is identical in both descriptions.', false, 'The motion is the same, but the numerical value of a vector component depends on the axis direction. Reversing the axis reverses the signs of displacement and velocity.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.1-b-v1', 'mcq', 'predict how reversing the axis direction or origin changes signed quantities (position, displacement, velocity, accelera (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart rolling to the right slows steadily and comes to rest. One student takes right as positive and another takes left as positive. Which statement about their descriptions of the slowing-down interval is correct?', null, md5('apphysics1-mcq-b6-sv-h-1.1-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both students record a negative acceleration, because slowing down always means negative acceleration.', false, 'The sign of acceleration depends on the axis direction. For the student with left positive, the cart''s velocity change points left, so the acceleration is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Velocity and acceleration both flip sign, so for the second student the cart is speeding up.', false, 'When both flip, they still have opposite signs relative to each other. Opposite signs of velocity and acceleration mean slowing down in either description.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two students'' velocities have opposite signs and their accelerations have opposite signs, yet both agree the cart is slowing down.', true, 'Correct: Right-positive: v > 0 and a < 0. Left-positive: v < 0 and a > 0. Opposite signs of v and a mean slowing down in both.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Only the acceleration flips sign; the velocity is positive for both students because the cart moves forward.', false, 'Velocity is a vector whose sign depends on the chosen axis, so the left-positive student records the cart''s velocity as negative.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.1-b-v2', 'mcq', 'predict how reversing the axis direction or origin changes signed quantities (position, displacement, velocity, accelera (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone hovers 10 m above the ground and rises to 25 m above the ground. Student P measures position upward from the ground. Student Q places the origin on a roof 40 m above the ground and takes downward as positive. Which choice gives Student Q''s initial position, final position, and displacement?', null, md5('apphysics1-mcq-b6-sv-h-1.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Initial +30 m, final +15 m, displacement +15 m, because the drone still climbs 15 m.', false, 'The displacement is the final position minus the initial position, which is 15 − 30 = −15 m on a downward-positive axis. Climbing is motion in the negative direction here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Initial −30 m, final −15 m, displacement +15 m, because the drone is below the origin.', false, 'With downward as positive, a point below the origin has a positive coordinate. Calling it negative ignores the axis direction Student Q chose.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Initial +30 m, final +15 m, displacement −15 m.', true, 'Correct: Roof origin, down positive: initial = 40 − 10 = +30 m, final = 40 − 25 = +15 m, displacement = 15 − 30 = −15 m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Initial +10 m, final +25 m, displacement −15 m, because positions do not depend on the origin.', false, 'Positions are measured from the chosen origin, so they differ between students. Only the displacement magnitude of 15 m is shared.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.1-b-v3', 'mcq', 'predict how reversing the axis direction or origin changes signed quantities (position, displacement, velocity, accelera (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bird leaves a perch, flies 6.0 m north along a straight line, then flies 6.0 m south back to the perch, taking 4.0 s in all. Student M takes north as positive and Student N takes south as positive. Which statement about the round trip is correct?', null, md5('apphysics1-mcq-b6-sv-h-1.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Student M finds an average velocity of +3.0 m/s and Student N finds −3.0 m/s.', false, 'The bird ends where it started, so the displacement is zero for both students. A nonzero average velocity would require a net change in position.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both students find an average velocity of 3.0 m/s, since the speed is the same for them.', false, 'Average speed uses the 12 m path length, but average velocity uses the net displacement, which is zero. The two quantities are not interchangeable.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both students find zero average velocity and zero average speed, because the bird returns to the perch.', false, 'Returning to the start makes displacement zero, not distance. The bird flew 12 m in 4.0 s, so its average speed is 3.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both students find zero displacement and zero average velocity, and both find an average speed of 3.0 m/s.', true, 'Correct: Net displacement is 0, so average velocity is 0 for either axis. Path length is 12 m, so average speed = 12/4.0 = 3.0 m/s.' from version_ins;
-- apphysics1-mcq-b6-h-1.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.2-a', 'mcq', 'use the relative signs of velocity and acceleration to decide speeding up or slowing down, then apply v = v0 + at throug', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart moves along a straight track with the positive axis pointing right. At t = 0 its velocity is −3 m/s and its acceleration is a constant −2 m/s². Which choice correctly describes the cart at t = 0 and gives its velocity at t = 2.0 s?', null, md5('apphysics1-mcq-b6-h-1.2-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Moving left and slowing down; v = +1 m/s.', false, 'A negative acceleration does not by itself mean slowing down. Velocity and acceleration here share the same sign, so the speed grows rather than shrinks.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Moving left and speeding up; v = +7 m/s.', false, 'Speeding up to a speed of 7 m/s leftward still gives a negative velocity on this axis. The positive sign would mean the cart is moving right.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Moving left and speeding up; v = −7 m/s.', true, 'Correct: v = v0 + at = −3 + (−2)(2.0) = -7 m/s. Velocity and acceleration have the same sign, so the speed increases.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Moving left and speeding up; v = −5 m/s.', false, 'The velocity change is a·t = (−2)(2.0) = −4 m/s, the full interval. Using only half the time reaches −5 m/s, which is not the velocity at 2.0 s.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-h-1.1-a','apphysics1-mcq-b6-sv-h-1.1-a-v1','apphysics1-mcq-b6-sv-h-1.1-a-v2','apphysics1-mcq-b6-sv-h-1.1-a-v3','apphysics1-mcq-b6-h-1.1-b','apphysics1-mcq-b6-sv-h-1.1-b-v1','apphysics1-mcq-b6-sv-h-1.1-b-v2','apphysics1-mcq-b6-sv-h-1.1-b-v3','apphysics1-mcq-b6-h-1.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b6-h-1.1-a','apphysics1-mcq-b6-sv-h-1.1-a-v1','apphysics1-mcq-b6-sv-h-1.1-a-v2','apphysics1-mcq-b6-sv-h-1.1-a-v3','apphysics1-mcq-b6-h-1.1-b','apphysics1-mcq-b6-sv-h-1.1-b-v1','apphysics1-mcq-b6-sv-h-1.1-b-v2','apphysics1-mcq-b6-sv-h-1.1-b-v3','apphysics1-mcq-b6-h-1.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
