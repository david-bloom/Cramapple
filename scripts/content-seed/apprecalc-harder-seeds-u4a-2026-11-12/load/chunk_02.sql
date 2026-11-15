begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4a-sv-h-4.3-a-v1','apprecalc-mcq-b4a-sv-h-4.3-a-v2','apprecalc-mcq-b4a-sv-h-4.3-a-v3','apprecalc-mcq-b4a-h-4.4-a','apprecalc-mcq-b4a-sv-h-4.4-a-v1','apprecalc-mcq-b4a-sv-h-4.4-a-v2','apprecalc-mcq-b4a-sv-h-4.4-a-v3','apprecalc-mcq-b4a-h-4.5-a','apprecalc-mcq-b4a-sv-h-4.5-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apprecalc-mcq-b4a-sv-h-4.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.3-a-v1', 'mcq', 'separate the average rates of change of x(t) and y(t) with respect to t from the average rate of change of y with respec (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A skater''s horizontal position is x(t) = 5t − 2 feet and her height is y(t) = t² feet, where t is in seconds. What is the average rate of change of the height with respect to the horizontal position from t = 0 to t = 4?', null, md5('apprecalc-mcq-b4a-sv-h-4.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/4 feet of height per foot of horizontal distance', false, 'This inverts the ratio: the net change in height is 16 and the net change in horizontal position is 20, so the rate is 16/20 = 4/5.' from version_ins
union all select gen_random_uuid(), id, 'B', '4 feet per second', false, 'This is the average rate of change of the height with respect to time, 16/4 = 4, not with respect to horizontal position.' from version_ins
union all select gen_random_uuid(), id, 'C', '4/5 feet of height per foot of horizontal distance', true, 'Correct: From t = 0 to t = 4, Δy = 16 − 0 = 16 and Δx = 18 − (−2) = 20, so the average rate of change of y with respect to x is 16/20 = 4/5.' from version_ins
union all select gen_random_uuid(), id, 'D', '5 feet per second', false, 'This is the average rate of change of the horizontal position with respect to time, 20/4 = 5, not the height with respect to horizontal position.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.3-a-v2', 'mcq', 'separate the average rates of change of x(t) and y(t) with respect to t from the average rate of change of y with respec (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart''s horizontal position is x(t) = 4t meters and its height is y(t) = 2t² meters, where t is in seconds. What is the average rate of change of the height with respect to the horizontal position from t = 2 to t = 5?', null, md5('apprecalc-mcq-b4a-sv-h-4.3-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7/2 meters of height per meter of horizontal distance', true, 'Correct: From t = 2 to t = 5, Δy = 50 − 8 = 42 and Δx = 20 − 8 = 12, so the average rate of change of y with respect to x is 42/12 = 7/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '2/7 meters of height per meter of horizontal distance', false, 'This inverts the ratio: the net change in height is 42 and the net change in horizontal position is 12, so the rate is 42/12 = 7/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '14 meters per second', false, 'This is the average rate of change of the height with respect to time, 42/3 = 14, not with respect to horizontal position.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 meters per second', false, 'This is the average rate of change of the horizontal position with respect to time, 12/3 = 4, not the height with respect to horizontal position.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.3-a-v3', 'mcq', 'separate the average rates of change of x(t) and y(t) with respect to t from the average rate of change of y with respec (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bird''s horizontal position is x(t) = t² + 1 meters and its height is y(t) = 3t meters, where t is in seconds. What is the average rate of change of the height with respect to the horizontal position from t = 1 to t = 3?', null, md5('apprecalc-mcq-b4a-sv-h-4.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4/3 meters of height per meter of horizontal distance', false, 'This inverts the ratio: the net change in height is 6 and the net change in horizontal position is 8, so the rate is 6/8 = 3/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/4 meters of height per meter of horizontal distance', true, 'Correct: From t = 1 to t = 3, Δy = 9 − 3 = 6 and Δx = 10 − 2 = 8, so the average rate of change of y with respect to x is 6/8 = 3/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 meters per second', false, 'This is the average rate of change of the height with respect to time, 6/2 = 3, not with respect to horizontal position.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 meters per second', false, 'This is the average rate of change of the horizontal position with respect to time, 8/2 = 4, not the height with respect to horizontal position.' from version_ins;
-- apprecalc-mcq-b4a-h-4.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-h-4.4-a', 'mcq', 'read the center, radius, direction and period of circular motion directly from parametric equations.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bug walks around a circular track: position x(t) = 2 + 4cos(3t), y(t) = −1 − 4 sin(3t), with t in seconds. Which statement is correct?', null, md5('apprecalc-mcq-b4a-h-4.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The track has center (2, −1) and radius 4; the bug moves counterclockwise and completes one lap every 2π/3 seconds', false, 'The signs on the sine and cosine terms make the bug move clockwise: just after t = 0 it heads downward from the starting point on the track, as the check shows, so the opposite direction is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The track has center (2, −1) and radius 4; the bug moves clockwise and completes one lap every 2π/3 seconds', true, 'Correct: The terms 4cos(3t) and −4 sin(3t) satisfy ((x − 2)/4)² + ((y + 1)/4)² = 1, so center (2, −1), radius 4. The period is 2π/3. At t = 0 the bug is at (6, −1), the rightmost point, and y decreases for small t, so the motion is clockwise.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The track has center (2, −1) and radius 4; the bug moves clockwise and completes one lap every 2π seconds', false, 'The period is 2π divided by the coefficient of t inside the trigonometric functions, which is 2π/3, not 2π.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The track has center (−2, 1) and radius 4; the bug moves clockwise and completes one lap every 2π/3 seconds', false, 'The center is read from the constants added to the trigonometric terms, with their signs, so the signs of both coordinates cannot be flipped.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.4-a-v1', 'mcq', 'read the center, radius, direction and period of circular motion directly from parametric equations. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bug walks around a circular track: position x(t) = −3 + 2cos(4t), y(t) = 5 + 2 sin(4t), with t in seconds. Which statement is correct?', null, md5('apprecalc-mcq-b4a-sv-h-4.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The track has center (−3, 5) and radius 2; the bug moves counterclockwise and completes one lap every π/2 seconds', true, 'Correct: The terms satisfy ((x + 3)/2)² + ((y − 5)/2)² = 1, so center (−3, 5), radius 2. The period is 2π/4 = π/2. At t = 0 the bug is at (−1, 5), the rightmost point, and y increases for small t, so the motion is counterclockwise.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The track has center (−3, 5) and radius 2; the bug moves clockwise and completes one lap every π/2 seconds', false, 'The signs on the sine and cosine terms make the bug move counterclockwise: just after t = 0 it heads upward from the starting point on the track, as the check shows, so the opposite direction is wrong.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The track has center (−3, 5) and radius 2; the bug moves counterclockwise and completes one lap every 2π seconds', false, 'The period is 2π divided by the coefficient of t inside the trigonometric functions, which is π/2, not 2π.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The track has center (3, −5) and radius 2; the bug moves counterclockwise and completes one lap every π/2 seconds', false, 'The center is read from the constants added to the trigonometric terms, with their signs, so the signs of both coordinates cannot be flipped.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.4-a-v2', 'mcq', 'read the center, radius, direction and period of circular motion directly from parametric equations. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bug walks around a circular track: position x(t) = 1 + 6 sin(t/2), y(t) = −2 + 6cos(t/2), with t in seconds. Which statement is correct?', null, md5('apprecalc-mcq-b4a-sv-h-4.4-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The track has center (1, −2) and radius 6; the bug moves counterclockwise and completes one lap every 4π seconds', false, 'The signs on the sine and cosine terms make the bug move clockwise: just after t = 0 it heads downward from the starting point on the track, as the check shows, so the opposite direction is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The track has center (1, −2) and radius 6; the bug moves clockwise and completes one lap every 4π seconds', true, 'Correct: The terms satisfy ((x − 1)/6)² + ((y + 2)/6)² = 1, so center (1, −2), radius 6. The period is 2π ÷ (1/2) = 4π. At t = 0 the bug is at (1, 4), the top point, and x increases for small t, so the motion is clockwise.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The track has center (1, −2) and radius 6; the bug moves clockwise and completes one lap every π seconds', false, 'The period is 2π divided by the coefficient of t inside the trigonometric functions, which is 4π, not π.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The track has center (−1, 2) and radius 6; the bug moves clockwise and completes one lap every 4π seconds', false, 'The center is read from the constants added to the trigonometric terms, with their signs, so the signs of both coordinates cannot be flipped.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.4-a-v3', 'mcq', 'read the center, radius, direction and period of circular motion directly from parametric equations. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bug walks around a circular track: position x(t) = 5 + 3cos(πt), y(t) = 3 − 3 sin(πt), with t in seconds. Which statement is correct?', null, md5('apprecalc-mcq-b4a-sv-h-4.4-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The track has center (5, 3) and radius 3; the bug moves counterclockwise and completes one lap every 2 seconds', false, 'The signs on the sine and cosine terms make the bug move clockwise: just after t = 0 it heads downward from the starting point on the track, as the check shows, so the opposite direction is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The track has center (5, 3) and radius 3; the bug moves clockwise and completes one lap every 2π seconds', false, 'The period is 2π divided by the coefficient of t inside the trigonometric functions, which is 2, not 2π.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The track has center (5, 3) and radius 3; the bug moves clockwise and completes one lap every 2 seconds', true, 'Correct: The terms satisfy ((x − 5)/3)² + ((y − 3)/3)² = 1, so center (5, 3), radius 3. The period is 2π ÷ π = 2. At t = 0 the bug is at (8, 3), the rightmost point, and y decreases for small t, so the motion is clockwise.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The track has center (−5, −3) and radius 3; the bug moves clockwise and completes one lap every 2 seconds', false, 'The center is read from the constants added to the trigonometric terms, with their signs, so the signs of both coordinates cannot be flipped.' from version_ins;
-- apprecalc-mcq-b4a-h-4.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-h-4.5-a', 'mcq', 'test points against an implicit relation and use them to decide whether y is a function of x, without swapping coordinat', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the relation x² + 4y² = 20. Which statement is correct?', null, md5('apprecalc-mcq-b4a-h-4.5-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The points (1, 4) and (1, −4) both lie on the graph, so y is not a function of x', false, 'These points have the coordinates reversed: substituting x = 1, y = 4 gives 65, not 20.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The points (4, 1) and (4, −1) both lie on the graph, so y is not a function of x', true, 'Correct: Substituting (4, 1) gives 16 + 4 = 20, and (4, −1) gives the same value since y is squared. One input x = 4 then has two outputs, so y is not a function of x. Reversed coordinates (1, 4) give 65 ≠ 20.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The point (4, 1) lies on the graph but (4, −1) does not, so y is a function of x', false, 'Since y appears only as y², replacing y with −1 gives the same value 4, so (4, −1) also lies on the graph.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The points (4, 1) and (4, −1) both lie on the graph, and y is a function of x because the graph is symmetric about the x-axis', false, 'Symmetry about the x-axis is exactly what produces two outputs for one input: x = 4 has y = 1 and y = −1, which breaks the definition of a function.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.5-a-v1', 'mcq', 'test points against an implicit relation and use them to decide whether y is a function of x, without swapping coordinat (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the relation x² + 9y² = 45. Which statement is correct?', null, md5('apprecalc-mcq-b4a-sv-h-4.5-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The points (1, 6) and (1, −6) both lie on the graph, so y is not a function of x', false, 'These points have the coordinates reversed: substituting x = 1, y = 6 gives 325, not 45.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The point (6, 1) lies on the graph but (6, −1) does not, so y is a function of x', false, 'Since y appears only as y², replacing y with −1 gives the same value 9, so (6, −1) also lies on the graph.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The points (6, 1) and (6, −1) both lie on the graph, so y is not a function of x', true, 'Correct: Substituting (6, 1) gives 36 + 9 = 45, and (6, −1) gives the same value since y is squared. One input x = 6 then has two outputs, so y is not a function of x. Reversed coordinates (1, 6) give 325 ≠ 45.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The points (6, 1) and (6, −1) both lie on the graph, and y is a function of x because the graph is symmetric about the x-axis', false, 'Symmetry about the x-axis is exactly what produces two outputs for one input: x = 6 has y = 1 and y = −1, which breaks the definition of a function.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4a-sv-h-4.3-a-v1','apprecalc-mcq-b4a-sv-h-4.3-a-v2','apprecalc-mcq-b4a-sv-h-4.3-a-v3','apprecalc-mcq-b4a-h-4.4-a','apprecalc-mcq-b4a-sv-h-4.4-a-v1','apprecalc-mcq-b4a-sv-h-4.4-a-v2','apprecalc-mcq-b4a-sv-h-4.4-a-v3','apprecalc-mcq-b4a-h-4.5-a','apprecalc-mcq-b4a-sv-h-4.5-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b4a-sv-h-4.3-a-v1','apprecalc-mcq-b4a-sv-h-4.3-a-v2','apprecalc-mcq-b4a-sv-h-4.3-a-v3','apprecalc-mcq-b4a-h-4.4-a','apprecalc-mcq-b4a-sv-h-4.4-a-v1','apprecalc-mcq-b4a-sv-h-4.4-a-v2','apprecalc-mcq-b4a-sv-h-4.4-a-v3','apprecalc-mcq-b4a-h-4.5-a','apprecalc-mcq-b4a-sv-h-4.5-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
