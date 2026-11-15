begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.3-a-v2','apcalcab-mcq-b5-sv-h-2.3-a-v3','apcalcab-mcq-b5-h-2.3-b','apcalcab-mcq-b5-sv-h-2.3-b-v1','apcalcab-mcq-b5-sv-h-2.3-b-v2','apcalcab-mcq-b5-sv-h-2.3-b-v3','apcalcab-mcq-b5-h-2.4-a','apcalcab-mcq-b5-sv-h-2.4-a-v1','apcalcab-mcq-b5-sv-h-2.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcab-mcq-b5-sv-h-2.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.3-a-v2', 'mcq', 'estimate acceleration from a table of velocity values with uneven spacing, then use the signs of velocity and accelerati (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The velocity v(t), in feet per second, of a boat on a river is given in the table for selected times t in seconds.
t (seconds):   0   4   10   16
v(t) (ft/s):   −20   −14   −5   −2
Using the table values closest to t = 7, which statement is best at t = 7?', null, md5('apcalcab-mcq-b5-sv-h-2.3-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The acceleration is about 1.5 ft/s² and the boat is slowing down.', true, 'Correct: a(7) ≈ (v(10) − v(4))/(10 − 4) = (−5 − (−14))/6 = 1.5 ft/s². Since v < 0 and a > 0, the speed is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The acceleration is about 1.5 ft/s² and the boat is speeding up.', false, 'The velocity is negative and the acceleration positive, so the velocity is moving toward zero and the speed is decreasing. A positive acceleration does not always mean speeding up.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The acceleration is about 9 ft/s² and the boat is slowing down.', false, 'The change in velocity over [4, 10] is 9, but it must be divided by the interval length 6 to estimate acceleration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The acceleration is about 0.5 ft/s² and the boat is slowing down.', false, 'This uses the interval [10, 16], which does not contain t = 7. The estimate needs the interval [4, 10].' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.3-a-v3', 'mcq', 'estimate acceleration from a table of velocity values with uneven spacing, then use the signs of velocity and accelerati (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The velocity v(t), in centimeters per second, of a robot arm is given in the table for selected times t in seconds.
t (seconds):   0   5   8   14
v(t) (cm/s):   3   8   20   26
Using the table values closest to t = 6, which statement is best at t = 6?', null, md5('apcalcab-mcq-b5-sv-h-2.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The acceleration is about 4 cm/s² and the arm is slowing down.', false, 'Velocity and acceleration are both positive, so the speed is increasing. Calling it slowing down confuses a positive acceleration with a deceleration.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The acceleration is about 4 cm/s² and the arm is speeding up.', true, 'Correct: a(6) ≈ (v(8) − v(5))/(8 − 5) = (20 − 8)/3 = 4 cm/s². Since v > 0 and a > 0, the speed is increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The acceleration is about 12 cm/s² and the arm is speeding up.', false, 'The change in velocity over [5, 8] is 12, but it must be divided by the interval length 3 to estimate acceleration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The acceleration is about 1 cm/s² and the arm is speeding up.', false, 'This uses the interval [8, 14], which does not contain t = 6. The estimate needs the interval [5, 8].' from version_ins;
-- apcalcab-mcq-b5-h-2.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.3-b', 'mcq', 'use the monotonic behaviour of f′ to bracket f′(a) between the slopes of secant lines on either side of a.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives selected values of a differentiable function f. It is also known that f′ is increasing on the interval [2, 10].
x:   2   5   10
f(x):   7   13   31
Which statement about f′(5) must be true?', null, md5('apcalcab-mcq-b5-h-2.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f′(5) = 2.8', false, 'The average of the two secant slopes is 2.8, but with only three data points nothing forces f′(5) to equal it.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 < f′(5) < 3.6', true, 'Correct: The secant slope on [2, 5] is (13 − 7)/3 = 2 and on [5, 10] is (31 − 13)/5 = 3.6. With f′ increasing, f′(5) lies strictly between them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f′(5) > 3.6', false, 'The slope of the secant over [5, 10] is 3.6. Since f′ is increasing, f′(5) is below the average of f′ on [5, 10], so f′(5) < 3.6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f′(5) < 2', false, 'The slope of the secant over [2, 5] is 2. Since f′ is increasing, f′(5) is above the average of f′ on [2, 5], so f′(5) > 2.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.3-b-v1', 'mcq', 'use the monotonic behaviour of f′ to bracket f′(a) between the slopes of secant lines on either side of a. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives selected values of a differentiable function f. It is also known that f′ is decreasing on the interval [1, 9].
x:   1   4   9
f(x):   10   25   40
Which statement about f′(4) must be true?', null, md5('apcalcab-mcq-b5-sv-h-2.3-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f′(4) = 4', false, 'The average of the two secant slopes is 4, but nothing in the data forces f′(4) to equal it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f′(4) > 5', false, 'The slope of the secant over [1, 4] is 5. Since f′ is decreasing, f′(4) is below the average of f′ on [1, 4], so f′(4) < 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 < f′(4) < 5', true, 'Correct: The secant slopes are (25 − 10)/3 = 5 on [1, 4] and (40 − 25)/5 = 3 on [4, 9]. With f′ decreasing, f′(4) lies between 3 and 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f′(4) < 3', false, 'The slope of the secant over [4, 9] is 3. Since f′ is decreasing, f′(4) is above the average of f′ on [4, 9], so f′(4) > 3.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.3-b-v2', 'mcq', 'use the monotonic behaviour of f′ to bracket f′(a) between the slopes of secant lines on either side of a. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives selected values of a differentiable function g. It is also known that g′ is increasing on the interval [0, 4].
x:   0   3   4
g(x):   2   8   12
Which statement about g′(3) must be true?', null, md5('apcalcab-mcq-b5-sv-h-2.3-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g′(3) = 2.5', false, 'The slope of the secant over [0, 4] is 2.5, but the endpoint-to-endpoint slope is not guaranteed to equal g′(3) at an interior point.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g′(3) > 4', false, 'The slope of the secant over [3, 4] is 4. Since g′ is increasing, g′(3) is below the average of g′ on [3, 4], so g′(3) < 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g′(3) < 2', false, 'The slope of the secant over [0, 3] is 2. Since g′ is increasing, g′(3) is above the average of g′ on [0, 3], so g′(3) > 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 < g′(3) < 4', true, 'Correct: The secant slopes are (8 − 2)/3 = 2 on [0, 3] and (12 − 8)/1 = 4 on [3, 4]. With g′ increasing, g′(3) lies between 2 and 4.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.3-b-v3', 'mcq', 'use the monotonic behaviour of f′ to bracket f′(a) between the slopes of secant lines on either side of a. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives the population P(t), in thousands, of a town at selected times t in years. It is also known that P′ is decreasing on the interval [2, 8].
t:   2   6   8
P(t):   50   90   100
Which statement about P′(6) must be true?', null, md5('apcalcab-mcq-b5-sv-h-2.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P′(6) = 7.5', false, 'The average of the two secant slopes is 7.5, but the data do not force P′(6) to equal it.' from version_ins
union all select gen_random_uuid(), id, 'B', '5 < P′(6) < 10', true, 'Correct: The secant slopes are (90 − 50)/4 = 10 on [2, 6] and (100 − 90)/2 = 5 on [6, 8]. With P′ decreasing, P′(6) lies between 5 and 10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P′(6) > 10', false, 'The slope of the secant over [2, 6] is 10 thousand per year. Since P′ is decreasing, P′(6) is below the average of P′ on [2, 6], so P′(6) < 10.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P′(6) < 5', false, 'The slope of the secant over [6, 8] is 5 thousand per year. Since P′ is decreasing, P′(6) is above the average of P′ on [6, 8], so P′(6) > 5.' from version_ins;
-- apcalcab-mcq-b5-h-2.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.4-a', 'mcq', 'choose constants that make a piecewise function both continuous and differentiable at the join, using the slopes and val', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = x³ for x ≤ 1 and f(x) = ax + b for x > 1. For which values of a and b is f differentiable at x = 1?', null, md5('apcalcab-mcq-b5-h-2.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 3 and b = −2', true, 'Correct: Continuity needs a(1) + b = 1³ = 1. Equal slopes need a = 3x² at x = 1, so a = 3, and then b = 1 − 3 = −2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 3 and b = 1', false, 'Matching the slope gives a = 3, but b = 1 leaves the pieces disconnected: 3 + 1 = 4 does not equal f(1) = 1, so f is not even continuous.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 1 and b = 0', false, 'Continuity alone holds with a + b = 1, but the slopes are 3 and 1, so the graph has a corner at x = 1 and f is not differentiable there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 3 and b = 2', false, 'This sets a = 3 correctly but solves a − b = 1 instead of a + b = 1. At x = 1 the right piece is 3 + 2 = 5, not 1.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.4-a-v1', 'mcq', 'choose constants that make a piecewise function both continuous and differentiable at the join, using the slopes and val (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = ax² + b for x ≤ 2 and f(x) = x³ − 2x for x > 2. For which values of a and b is f differentiable at x = 2?', null, md5('apcalcab-mcq-b5-sv-h-2.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 5/2 and b = −6', true, 'Correct: Continuity needs 4a + b = 2³ − 2(2) = 4. Equal slopes need 2a(2) = 3(2²) − 2 = 10, so a = 5/2, and then b = 4 − 10 = −6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 1 and b = 0', false, 'Continuity needs 4a + b = 4, which a = 1, b = 0 satisfies, but the slopes are 4 and 10, so f has a corner at x = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 5/2 and b = 4', false, 'This matches the slopes with a = 5/2 but sets b equal to the right-hand value 4, forgetting that b = 4 − 4a. Then 4a + b = 14, so f jumps.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 5/2 and b = −14', false, 'This matches the slopes but solves 4a + b = −4 instead of 4. The pieces then disagree at x = 2, so f is not continuous.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.4-a-v2', 'mcq', 'choose constants that make a piecewise function both continuous and differentiable at the join, using the slopes and val (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = ax + b for x ≤ 2 and f(x) = 1/x for x > 2. For which values of a and b is f differentiable at x = 2?', null, md5('apcalcab-mcq-b5-sv-h-2.4-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = −1/4 and b = 1/2', false, 'The slope matches with a = −1/4, but b = 1/2 is the value of 1/x at 2 and ignores that the left piece must equal 1/2 at x = 2, which requires 2a + b = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = −1/4 and b = 1', true, 'Correct: Continuity needs 2a + b = 1/2. Equal slopes need a = −1/x² at x = 2, so a = −1/4, and then b = 1/2 + 1/2 = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 1/4 and b = 0', false, 'This uses the slope of 1/x with the wrong sign. The derivative of 1/x is −1/x², which is −1/4 at x = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = −1/4 and b = 0', false, 'With a = −1/4 and b = 0 the left piece equals −1/2 at x = 2, not 1/2, so f is not continuous.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.3-a-v2','apcalcab-mcq-b5-sv-h-2.3-a-v3','apcalcab-mcq-b5-h-2.3-b','apcalcab-mcq-b5-sv-h-2.3-b-v1','apcalcab-mcq-b5-sv-h-2.3-b-v2','apcalcab-mcq-b5-sv-h-2.3-b-v3','apcalcab-mcq-b5-h-2.4-a','apcalcab-mcq-b5-sv-h-2.4-a-v1','apcalcab-mcq-b5-sv-h-2.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b5-sv-h-2.3-a-v2','apcalcab-mcq-b5-sv-h-2.3-a-v3','apcalcab-mcq-b5-h-2.3-b','apcalcab-mcq-b5-sv-h-2.3-b-v1','apcalcab-mcq-b5-sv-h-2.3-b-v2','apcalcab-mcq-b5-sv-h-2.3-b-v3','apcalcab-mcq-b5-h-2.4-a','apcalcab-mcq-b5-sv-h-2.4-a-v1','apcalcab-mcq-b5-sv-h-2.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
