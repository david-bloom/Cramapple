begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4a-h-4.1-a','apprecalc-mcq-b4a-sv-h-4.1-a-v1','apprecalc-mcq-b4a-sv-h-4.1-a-v2','apprecalc-mcq-b4a-sv-h-4.1-a-v3','apprecalc-mcq-b4a-h-4.2-a','apprecalc-mcq-b4a-sv-h-4.2-a-v1','apprecalc-mcq-b4a-sv-h-4.2-a-v2','apprecalc-mcq-b4a-sv-h-4.2-a-v3','apprecalc-mcq-b4a-h-4.3-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apprecalc-mcq-b4a-h-4.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-h-4.1-a', 'mcq', 'eliminate the parameter from a trigonometric parametrization and identify exactly which part of the curve a restricted i', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle''s position at time t is x(t) = 4cos t and y(t) = 3 sin t for 0 ≤ t ≤ π. Which statement describes the path traced?', null, md5('apprecalc-mcq-b4a-h-4.1-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The entire ellipse x²/16 + y²/9 = 1, traced once', false, 'The elimination is right, since cos²t + sin²t = 1 gives x²/16 + y²/9 = 1, but 0 ≤ t ≤ π is only half a revolution, so only part of the ellipse is traced.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The upper half of the ellipse x²/9 + y²/16 = 1, traced from (3, 0) to (−3, 0)', false, 'This swaps the denominators: x = 4cos t means x² is divided by 16, and y = 3 sin t means y² is divided by 9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The lower half of the ellipse x²/16 + y²/9 = 1, traced from (4, 0) to (−4, 0)', false, 'On 0 < t < π we have sin t > 0, so y = 3 sin t is positive and the path is the upper half, not the lower half.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The upper half of the ellipse x²/16 + y²/9 = 1, traced from (4, 0) to (−4, 0)', true, 'Correct: cos t = x/4 and sin t = y/3, so x²/16 + y²/9 = 1. At t = 0 the point is (4, 0), at t = π/2 it is (0, 3), at t = π it is (−4, 0), and y = 3 sin t ≥ 0 throughout, so it is the upper half from right to left.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.1-a-v1', 'mcq', 'eliminate the parameter from a trigonometric parametrization and identify exactly which part of the curve a restricted i (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle''s position at time t is x(t) = 2 sin t and y(t) = 5 cos t for 0 ≤ t ≤ π. Which statement describes the path traced?', null, md5('apprecalc-mcq-b4a-sv-h-4.1-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The right half of the ellipse x²/4 + y²/25 = 1, traced from (0, 5) to (0, −5)', true, 'Correct: sin t = x/2 and cos t = y/5 give x²/4 + y²/25 = 1. At t = 0 the point is (0, 5), at t = π/2 it is (2, 0), at t = π it is (0, −5), and x = 2 sin t ≥ 0 throughout.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The entire ellipse x²/4 + y²/25 = 1, traced once', false, 'The equation x²/4 + y²/25 = 1 is correct, but the interval 0 ≤ t ≤ π is only half a revolution, so only half of the ellipse is traced.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The left half of the ellipse x²/4 + y²/25 = 1, traced from (0, 5) to (0, −5)', false, 'Because sin t ≥ 0 on [0, π], x = 2 sin t is never negative, so the path is on the right side of the y-axis, not the left.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The right half of the ellipse x²/25 + y²/4 = 1, traced from (0, 2) to (0, −2)', false, 'This swaps the denominators: x = 2 sin t gives x²/4 and y = 5 cos t gives y²/25, so the long axis is vertical with endpoints (0, ±5).' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.1-a-v2', 'mcq', 'eliminate the parameter from a trigonometric parametrization and identify exactly which part of the curve a restricted i (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle''s position at time t is x(t) = 3cos t and y(t) = 2 sin t for π ≤ t ≤ 2π. Which statement describes the path traced?', null, md5('apprecalc-mcq-b4a-sv-h-4.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The upper half of the ellipse x²/9 + y²/4 = 1, traced from (−3, 0) to (3, 0)', false, 'On π < t < 2π, sin t is negative, so y = 2 sin t is negative and the path lies below the x-axis.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The lower half of the ellipse x²/9 + y²/4 = 1, traced from (3, 0) to (−3, 0)', false, 'At t = π the point is (3cos π, 2 sin π) = (−3, 0), not (3, 0), so the motion starts at the left end and moves to the right.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The entire ellipse x²/9 + y²/4 = 1, traced once', false, 'The ellipse equation is correct, but the interval π ≤ t ≤ 2π is only half a revolution, so only the lower half is traced.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The lower half of the ellipse x²/9 + y²/4 = 1, traced from (−3, 0) to (3, 0)', true, 'Correct: x²/9 + y²/4 = cos²t + sin²t = 1. At t = π the point is (−3, 0), at t = 3π/2 it is (0, −2), and at t = 2π it is (3, 0), with y ≤ 0 throughout.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.1-a-v3', 'mcq', 'eliminate the parameter from a trigonometric parametrization and identify exactly which part of the curve a restricted i (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle''s position at time t is x(t) = 5 sin t and y(t) = 2cos t for 0 ≤ t ≤ π/2. Which statement describes the path traced?', null, md5('apprecalc-mcq-b4a-sv-h-4.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The part of the ellipse x²/25 + y²/4 = 1 in the first quadrant, traced from (5, 0) to (0, 2)', false, 'At t = 0 the point is (5 sin 0, 2cos 0) = (0, 2), so the motion starts on the y-axis and ends on the x-axis, not the reverse.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The part of the ellipse x²/4 + y²/25 = 1 in the first quadrant, traced from (0, 5) to (2, 0)', false, 'This swaps the denominators: x = 5 sin t means x² is divided by 25, and y = 2cos t means y² is divided by 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The entire ellipse x²/25 + y²/4 = 1, traced once', false, 'The ellipse equation is correct, but 0 ≤ t ≤ π/2 is only a quarter of a revolution, so only a quarter of the ellipse is traced.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The part of the ellipse x²/25 + y²/4 = 1 in the first quadrant, traced from (0, 2) to (5, 0)', true, 'Correct: x²/25 + y²/4 = sin²t + cos²t = 1. At t = 0 the point is (0, 2) and at t = π/2 it is (5, 0); both coordinates are nonnegative on [0, π/2], so the path is the first-quadrant quarter.' from version_ins;
-- apprecalc-mcq-b4a-h-4.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-h-4.2-a', 'mcq', 'decide when a moving particle is at a given point by requiring both coordinate equations to hold at the same time, inclu', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves in the plane with position x(t) = t² − 4 and y(t) = t³ − 4t for −3 ≤ t ≤ 3, with t in seconds. At which times is the particle at the origin?', null, md5('apprecalc-mcq-b4a-h-4.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = −2 and t = 2', true, 'Correct: x(t) = t² − 4 = 0 gives t = ±2. Then y(2) = 8 − 8 = 0 and y(−2) = −8 + 8 = 0, so the origin is reached at t = −2 and t = 2 (the path crosses itself there). At t = 0 the point is (−4, 0).' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 2 only', false, 'The equation x(t) = 0 gives t = 2 and also t = −2, and y(−2) = 0 as well, so the particle also reaches the origin at t = −2, which is in the interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = −2, t = 0 and t = 2', false, 'Solving y(t) = 0 alone gives t = 0, but at t = 0 the particle is at (-4, 0), not the origin, so both coordinates must be zero together.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At no time; the first zero of y is t = 0, where x = -4', false, 'At t = 0 the particle is at (-4, 0), but that does not rule out other times; both coordinates are zero at t = ±2.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.2-a-v1', 'mcq', 'decide when a moving particle is at a given point by requiring both coordinate equations to hold at the same time, inclu (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves in the plane with position x(t) = t² − 1 and y(t) = t³ − t for −2 ≤ t ≤ 2, with t in seconds. At which times is the particle at the origin?', null, md5('apprecalc-mcq-b4a-sv-h-4.2-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 1 only', false, 'The equation x(t) = 0 gives t = 1 and also t = −1, and y(−1) = 0 as well, so the particle also reaches the origin at t = −1, which is in the interval.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = −1, t = 0 and t = 1', false, 'Solving y(t) = 0 alone gives t = 0, but at t = 0 the particle is at (-1, 0), not the origin, so both coordinates must be zero together.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At no time; the first zero of y is t = 0, where x = -1', false, 'At t = 0 the particle is at (-1, 0), but that does not rule out other times; both coordinates are zero at t = ±1.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = −1 and t = 1', true, 'Correct: x(t) = t² − 1 = 0 gives t = ±1, and y(±1) = ±1 ∓ 1 = 0, so the origin is reached at t = −1 and t = 1. At t = 0 the point is (−1, 0).' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.2-a-v2', 'mcq', 'decide when a moving particle is at a given point by requiring both coordinate equations to hold at the same time, inclu (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves in the plane with position x(t) = t² − 9 and y(t) = t³ − 9t for −4 ≤ t ≤ 4, with t in seconds. At which times is the particle at the origin?', null, md5('apprecalc-mcq-b4a-sv-h-4.2-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = −3 and t = 3', true, 'Correct: x(t) = t² − 9 = 0 gives t = ±3, and y(3) = 27 − 27 = 0 and y(−3) = −27 + 27 = 0, so the origin is reached at t = −3 and t = 3. At t = 0 the point is (−9, 0).' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 3 only', false, 'The equation x(t) = 0 gives t = 3 and also t = −3, and y(−3) = 0 as well, so the particle also reaches the origin at t = −3, which is in the interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = −3, t = 0 and t = 3', false, 'Solving y(t) = 0 alone gives t = 0, but at t = 0 the particle is at (-9, 0), not the origin, so both coordinates must be zero together.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At no time; the first zero of y is t = 0, where x = -9', false, 'At t = 0 the particle is at (-9, 0), but that does not rule out other times; both coordinates are zero at t = ±3.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.2-a-v3', 'mcq', 'decide when a moving particle is at a given point by requiring both coordinate equations to hold at the same time, inclu (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves in the plane with position x(t) = 4 − t² and y(t) = 4t − t³ for −3 ≤ t ≤ 3, with t in seconds. At which times is the particle at the origin?', null, md5('apprecalc-mcq-b4a-sv-h-4.2-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 2 only', false, 'The equation x(t) = 0 gives t = 2 and also t = −2, and y(−2) = 0 as well, so the particle also reaches the origin at t = −2, which is in the interval.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = −2, t = 0 and t = 2', false, 'Solving y(t) = 0 alone gives t = 0, but at t = 0 the particle is at (4, 0), not the origin, so both coordinates must be zero together.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = −2 and t = 2', true, 'Correct: x(t) = 4 − t² = 0 gives t = ±2, and y(2) = 8 − 8 = 0 and y(−2) = −8 + 8 = 0, so the origin is reached at t = −2 and t = 2. At t = 0 the point is (4, 0).' from version_ins
union all select gen_random_uuid(), id, 'D', 'At no time; the first zero of y is t = 0, where x = 4', false, 'At t = 0 the particle is at (4, 0), but that does not rule out other times; both coordinates are zero at t = ±2.' from version_ins;
-- apprecalc-mcq-b4a-h-4.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-h-4.3-a', 'mcq', 'separate the average rates of change of x(t) and y(t) with respect to t from the average rate of change of y with respec', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone''s horizontal position is x(t) = 3t + 1 meters and its height is y(t) = t² meters, where t is in seconds. What is the average rate of change of the height with respect to the horizontal position from t = 1 to t = 3?', null, md5('apprecalc-mcq-b4a-h-4.3-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/4 meters of height per meter of horizontal distance', false, 'This inverts the ratio: the net change in height is 8 and the net change in horizontal position is 6, so the rate is 8/6 = 4/3, not 6/8.' from version_ins
union all select gen_random_uuid(), id, 'B', '4 meters per second', false, 'This is the average rate of change of the height with respect to time, (9 − 1)/2 = 4, not with respect to horizontal position.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 meters per second', false, 'This is the average rate of change of the horizontal position with respect to time, (10 − 4)/2 = 3, not the height with respect to horizontal position.' from version_ins
union all select gen_random_uuid(), id, 'D', '4/3 meters of height per meter of horizontal distance', true, 'Correct: From t = 1 to t = 3, Δy = 9 − 1 = 8 and Δx = 10 − 4 = 6, so the average rate of change of y with respect to x is 8/6 = 4/3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4a-h-4.1-a','apprecalc-mcq-b4a-sv-h-4.1-a-v1','apprecalc-mcq-b4a-sv-h-4.1-a-v2','apprecalc-mcq-b4a-sv-h-4.1-a-v3','apprecalc-mcq-b4a-h-4.2-a','apprecalc-mcq-b4a-sv-h-4.2-a-v1','apprecalc-mcq-b4a-sv-h-4.2-a-v2','apprecalc-mcq-b4a-sv-h-4.2-a-v3','apprecalc-mcq-b4a-h-4.3-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b4a-h-4.1-a','apprecalc-mcq-b4a-sv-h-4.1-a-v1','apprecalc-mcq-b4a-sv-h-4.1-a-v2','apprecalc-mcq-b4a-sv-h-4.1-a-v3','apprecalc-mcq-b4a-h-4.2-a','apprecalc-mcq-b4a-sv-h-4.2-a-v1','apprecalc-mcq-b4a-sv-h-4.2-a-v2','apprecalc-mcq-b4a-sv-h-4.2-a-v3','apprecalc-mcq-b4a-h-4.3-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
