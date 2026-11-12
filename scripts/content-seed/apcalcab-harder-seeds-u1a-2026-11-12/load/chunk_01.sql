begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-h-1.1-a','apcalcab-mcq-b6-sv-h-1.1-a-v1','apcalcab-mcq-b6-sv-h-1.1-a-v2','apcalcab-mcq-b6-sv-h-1.1-a-v3','apcalcab-mcq-b6-h-1.1-b','apcalcab-mcq-b6-sv-h-1.1-b-v1','apcalcab-mcq-b6-sv-h-1.1-b-v2','apcalcab-mcq-b6-sv-h-1.1-b-v3','apcalcab-mcq-b6-h-1.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b6-h-1.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.1-a', 'mcq', 'use average rates over shrinking intervals computed from position values to estimate an instantaneous rate and separate ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart''s position along a track is s(t) = 2t² + t meters at time t seconds. Its positions are s(3) = 21, s(3.1) = 22.32, s(3.01) = 21.1302, and s(3.001) = 21.013002. Using the average velocities over [3, 3 + h] for h = 0.1, 0.01, and 0.001, which value do these averages suggest for the instantaneous velocity at t = 3?', null, md5('apcalcab-mcq-b6-h-1.1-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13 meters per second', true, 'Correct: The average velocities over [3, 3 + h] are 1.32/0.1 = 13.2, 0.1302/0.01 = 13.02, and 0.013002/0.001 = 13.002. They approach 13 as h shrinks, so the instantaneous velocity at t = 3 is 13.' from version_ins
union all select gen_random_uuid(), id, 'B', '13.2 meters per second', false, 'The value 13.2 is only the average velocity over the longest interval, [3, 3.1]. Averages over shorter intervals are closer to the instantaneous velocity and keep moving toward 13.' from version_ins
union all select gen_random_uuid(), id, 'C', '13.002 meters per second', false, 'The value 13.002 is the average velocity over [3, 3.001], not an instantaneous velocity. The pattern of averages (13.2, 13.02, 13.002) shows they settle toward 13, which is the instantaneous velocity.' from version_ins
union all select gen_random_uuid(), id, 'D', '7 meters per second', false, 'The ratio s(3)/3 = 7 is the average velocity from t = 0 to t = 3, a long interval that says little about the velocity at the single instant t = 3.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.1-a-v1', 'mcq', 'use average rates over shrinking intervals computed from position values to estimate an instantaneous rate and separate  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The population of a bacteria culture is P(t) = 3t² − t hundred bacteria at time t hours. The values are P(1) = 2, P(1.1) = 2.53, P(1.01) = 2.0503, and P(1.001) = 2.005003. Using the average rates of change over [1, 1 + h] for h = 0.1, 0.01, and 0.001, which value do they suggest for the instantaneous rate of change of the population at t = 1?', null, md5('apcalcab-mcq-b6-sv-h-1.1-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5 hundred bacteria per hour', true, 'Correct: The average rates are 0.53/0.1 = 5.3, 0.0503/0.01 = 5.03, and 0.005003/0.001 = 5.003. They approach 5 as the interval shrinks, so the instantaneous rate at t = 1 is 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '5.3 hundred bacteria per hour', false, 'The value 5.3 is the average rate over the longest interval, [1, 1.1]. It is only the first, roughest approximation; shorter intervals give values closer to 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '5.003 hundred bacteria per hour', false, 'The value 5.003 is the average rate over [1, 1.001], not the instantaneous rate. The sequence of averages 5.3, 5.03, 5.003 approaches 5, which is the instantaneous rate.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 hundred bacteria per hour', false, 'The number 2 is P(1), the population itself in hundreds of bacteria. It is an amount, not a rate, and cannot be the rate of change per hour.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.1-a-v2', 'mcq', 'use average rates over shrinking intervals computed from position values to estimate an instantaneous rate and separate  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The volume of fuel in a tank is V(t) = t² + 4t liters at time t minutes. The values are V(2.9) = 20.01, V(2.99) = 20.9001, V(2.999) = 20.990001, and V(3) = 21. Using the average rates of change over [2.9, 3], [2.99, 3], and [2.999, 3], which value do they suggest for the instantaneous rate of change of volume at t = 3?', null, md5('apcalcab-mcq-b6-sv-h-1.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9.9 liters per minute', false, 'The value 9.9 is the average rate over the longest interval, [2.9, 3]. The averages over shorter intervals keep climbing toward 10.' from version_ins
union all select gen_random_uuid(), id, 'B', '9.999 liters per minute', false, 'The value 9.999 is an average rate over a tiny interval, not the instantaneous rate. The averages 9.9, 9.99, 9.999 approach 10, the instantaneous rate.' from version_ins
union all select gen_random_uuid(), id, 'C', '21 liters per minute', false, 'The number 21 is V(3), an amount of fuel in liters. It is not a rate, so it cannot answer a question about liters per minute.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 liters per minute', true, 'Correct: The average rates are 0.99/0.1 = 9.9, 0.0999/0.01 = 9.99, and 0.009999/0.001 = 9.999. They approach 10 from below, so the instantaneous rate at t = 3 is 10.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.1-a-v3', 'mcq', 'use average rates over shrinking intervals computed from position values to estimate an instantaneous rate and separate  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone''s height is h(t) = −4t² + 20t meters at time t seconds. The values are h(1) = 16, h(1.1) = 17.16, h(1.01) = 16.1196, and h(1.001) = 16.011996. Using the average velocities over [1, 1 + k] for k = 0.1, 0.01, and 0.001, which value do they suggest for the drone''s instantaneous velocity at t = 1?', null, md5('apcalcab-mcq-b6-sv-h-1.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '11.6 meters per second', false, 'The value 11.6 is the average velocity over the longest interval, [1, 1.1]. Shorter intervals give averages closer to 12.' from version_ins
union all select gen_random_uuid(), id, 'B', '11.996 meters per second', false, 'The value 11.996 is the average velocity over [1, 1.001], not the instantaneous velocity. The averages 11.6, 11.96, 11.996 approach 12, the instantaneous velocity.' from version_ins
union all select gen_random_uuid(), id, 'C', '16 meters per second', false, 'The number 16 is h(1), the drone''s height in meters. A height is a position, not a velocity in meters per second.' from version_ins
union all select gen_random_uuid(), id, 'D', '12 meters per second', true, 'Correct: The average velocities are 1.16/0.1 = 11.6, 0.1196/0.01 = 11.96, and 0.011996/0.001 = 11.996. They approach 12 from below, so the instantaneous velocity at t = 1 is 12.' from version_ins;
-- apcalcab-mcq-b6-h-1.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.1-b', 'mcq', 'reason about how a strictly monotone instantaneous rate relates to the average rate over an interval and to midpoint val', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A car''s velocity v(t), in meters per second, is continuous and strictly increasing for 0 ≤ t ≤ 10, where t is in seconds. The car''s position s satisfies s(0) = 0 and s(10) = 120 meters. Which statement must be true?', null, md5('apcalcab-mcq-b6-h-1.1-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'v(5) = 12', false, 'The velocity at the midpoint equals the average only when the velocity is linear in time. A strictly increasing velocity need not be linear, so nothing forces v(5) to equal 12.' from version_ins
union all select gen_random_uuid(), id, 'B', 'v(0) > 12 > v(10)', false, 'This reverses the order. When velocity strictly increases, the earliest velocity is the smallest and the latest is the largest, so the average sits between them in the order v(0) < 12 < v(10).' from version_ins
union all select gen_random_uuid(), id, 'C', 'v(t) = 12 for every t in [0, 10]', false, 'A constant velocity of 12 would have an average of 12, but the velocity is strictly increasing, so it cannot be constant. Only the average, not every instantaneous value, equals 12.' from version_ins
union all select gen_random_uuid(), id, 'D', 'v(0) < 12 < v(10)', true, 'Correct: The average velocity over [0, 10] is (120 − 0)/10 = 12 m/s. Because v is strictly increasing, every instantaneous velocity lies between v(0) and v(10), so the average lies strictly between them.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.1-b-v1', 'mcq', 'reason about how a strictly monotone instantaneous rate relates to the average rate over an interval and to midpoint val (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The number of bacteria in a culture is P(t) thousand at time t hours. The rate of change P′(t) is continuous and strictly decreasing for 0 ≤ t ≤ 6. Also P(0) = 500 and P(6) = 1100. Which statement must be true?', null, md5('apcalcab-mcq-b6-sv-h-1.1-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P′(3) = 100', false, 'The rate at the midpoint equals the average only for a constant or linear-in-time rate. A strictly decreasing P′ gives no reason for the midpoint value to equal 100.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P′(0) < 100 < P′(6)', false, 'This order fits a rate that is increasing. Here P′ is strictly decreasing, so the earliest rate is the largest and the latest is the smallest.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P(3) = 800', false, 'The value 800 is the midpoint of 500 and 1100, which would hold only if the culture grew at a constant rate. With a decreasing rate the culture grows faster early on, so P(3) is larger than 800.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P′(0) > 100 > P′(6)', true, 'Correct: The average rate over [0, 6] is (1100 − 500)/6 = 100 thousand per hour. Because P′ is strictly decreasing, it starts above its average and ends below it.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.1-b-v2', 'mcq', 'reason about how a strictly monotone instantaneous rate relates to the average rate over an interval and to midpoint val (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water drains from a tank, and the volume is V(t) liters at time t minutes. The rate of change V′(t) is continuous and strictly increasing for 0 ≤ t ≤ 8, with V(0) = 200 and V(8) = 80. Which statement must be true?', null, md5('apcalcab-mcq-b6-sv-h-1.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'V′(4) = −15', false, 'The rate at the midpoint equals the average only for a linear-in-time rate. A strictly increasing V′ gives no such guarantee.' from version_ins
union all select gen_random_uuid(), id, 'B', 'V′(0) > −15 > V′(8)', false, 'This order fits a rate that is decreasing. Here V′ is strictly increasing, so the earliest rate is the smallest (most negative) and the latest is the largest.' from version_ins
union all select gen_random_uuid(), id, 'C', 'V′(0) < −15 < V′(8)', true, 'Correct: The average rate over [0, 8] is (80 − 200)/8 = −15 liters per minute. Because V′ is strictly increasing, it starts below −15 and ends above −15.' from version_ins
union all select gen_random_uuid(), id, 'D', 'V(4) = 140', false, 'The value 140 is the midpoint of 200 and 80, which holds only if the tank drains at a constant rate. The draining slows over time, so more water is lost early and V(4) is less than 140.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.1-b-v3', 'mcq', 'reason about how a strictly monotone instantaneous rate relates to the average rate over an interval and to midpoint val (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone descends so that its altitude is A(t) meters at time t minutes. The rate of change A′(t) is continuous and strictly decreasing for 0 ≤ t ≤ 5, with A(0) = 400 and A(5) = 100. Which statement must be true?', null, md5('apcalcab-mcq-b6-sv-h-1.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A′(0) < −60 < A′(5)', false, 'This order fits a rate that is increasing. Here A′ is strictly decreasing, so the earliest rate is the largest (least negative) and the latest is the smallest.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A′(2.5) = −60', false, 'The rate at the midpoint equals the average only when the rate is linear in time. A strictly decreasing A′ gives no such guarantee.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A′(0) > −60 > A′(5)', true, 'Correct: The average rate over [0, 5] is (100 − 400)/5 = −60 meters per minute. Because A′ is strictly decreasing, it starts above −60 and ends below −60.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A(2.5) = 250', false, 'The value 250 is the midpoint of 400 and 100, true only for a constant descent rate. The descent speeds up over time, so the drone loses height more slowly early and A(2.5) is greater than 250.' from version_ins;
-- apcalcab-mcq-b6-h-1.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.2-a', 'mcq', 'evaluate a limit of f(g(x)) by determining from which side the inner expression approaches the point, using one-sided li', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies lim(x→1⁻) f(x) = 3, lim(x→1⁺) f(x) = −1, and f(1) = 7. What is lim(x→0) f(1 − x²)?', null, md5('apcalcab-mcq-b6-h-1.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', true, 'Correct: For x ≠ 0 near 0, 1 − x² is slightly less than 1, so the input to f approaches 1 from the left only. The limit is therefore the left-hand limit of f at 1, which is 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', false, 'The value −1 is the limit of f as its input approaches 1 from the right. Since 1 − x² is always less than 1, the input approaches 1 from the left, not the right.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'The value 7 is f(1), but the input 1 − x² never equals 1 when x ≠ 0. A limit depends on the nearby values of f, not on the value at the point.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'The limit would fail to exist if the input approached 1 from both sides, but 1 − x² approaches 1 only from below. Only the left-hand limit of f matters, and it is 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-h-1.1-a','apcalcab-mcq-b6-sv-h-1.1-a-v1','apcalcab-mcq-b6-sv-h-1.1-a-v2','apcalcab-mcq-b6-sv-h-1.1-a-v3','apcalcab-mcq-b6-h-1.1-b','apcalcab-mcq-b6-sv-h-1.1-b-v1','apcalcab-mcq-b6-sv-h-1.1-b-v2','apcalcab-mcq-b6-sv-h-1.1-b-v3','apcalcab-mcq-b6-h-1.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b6-h-1.1-a','apcalcab-mcq-b6-sv-h-1.1-a-v1','apcalcab-mcq-b6-sv-h-1.1-a-v2','apcalcab-mcq-b6-sv-h-1.1-a-v3','apcalcab-mcq-b6-h-1.1-b','apcalcab-mcq-b6-sv-h-1.1-b-v1','apcalcab-mcq-b6-sv-h-1.1-b-v2','apcalcab-mcq-b6-sv-h-1.1-b-v3','apcalcab-mcq-b6-h-1.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
