begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-h-2.1-a','apcalcab-mcq-b5-sv-h-2.1-a-v1','apcalcab-mcq-b5-sv-h-2.1-a-v2','apcalcab-mcq-b5-sv-h-2.1-a-v3','apcalcab-mcq-b5-h-2.1-b','apcalcab-mcq-b5-sv-h-2.1-b-v1','apcalcab-mcq-b5-sv-h-2.1-b-v2','apcalcab-mcq-b5-sv-h-2.1-b-v3','apcalcab-mcq-b5-h-2.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b5-h-2.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.1-a', 'mcq', 'relate the average rate of change over an interval to the instantaneous rate for a quadratic position function, solving ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line so that its position is s(t) = t² − 5t + 3 meters at time t seconds. At what time t, with 1 < t < 7, is the instantaneous velocity equal to the average velocity over the interval [1, 7]?', null, md5('apcalcab-mcq-b5-h-2.1-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 3 seconds', false, 'The number 3 is the value of the average velocity in meters per second, not a time. The time comes from solving s′(t) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 5/2 seconds', false, 'Solving s′(t) = 2t − 5 = 0 finds when the particle is momentarily at rest, which is a different question from matching the average velocity.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 23/2 seconds', false, 'This solves 2t − 5 = 18, using the total change s(7) − s(1) = 18 without dividing by the interval length 6. The result also lies outside the interval (1, 7).' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 4 seconds', true, 'Correct: The average velocity is (s(7) − s(1))/6 = (17 − (−1))/6 = 3. Setting s′(t) = 2t − 5 = 3 gives t = 4, which lies in (1, 7).' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.1-a-v1', 'mcq', 'relate the average rate of change over an interval to the instantaneous rate for a quadratic position function, solving  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cyclist''s position along a straight road is s(t) = t² − 6t + 1 meters at time t seconds. At what time t, with 2 < t < 8, is the instantaneous velocity equal to the average velocity over the interval [2, 8]?', null, md5('apcalcab-mcq-b5-sv-h-2.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 4 seconds', false, 'The value 4 is the average velocity in meters per second, not a time. The time comes from solving s′(t) = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 3 seconds', false, 'Solving 2t − 6 = 0 gives the instant the cyclist is momentarily at rest, not the instant that matches the average velocity.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 5 seconds', true, 'Correct: The average velocity is (s(8) − s(2))/6 = (17 − (−7))/6 = 4. Setting s′(t) = 2t − 6 = 4 gives t = 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 15 seconds', false, 'This solves 2t − 6 = 24, using the total change s(8) − s(2) = 24 without dividing by the length 6 of the interval. The answer is also outside (2, 8).' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.1-a-v2', 'mcq', 'relate the average rate of change over an interval to the instantaneous rate for a quadratic position function, solving  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball is thrown upward from the ground so that its height is h(t) = −5t² + 30t meters after t seconds. At what time t, with 0 < t < 4, is the instantaneous velocity equal to the average velocity over the interval [0, 4]?', null, md5('apcalcab-mcq-b5-sv-h-2.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 2 seconds', true, 'Correct: The average velocity is (h(4) − h(0))/4 = 40/4 = 10. Setting h′(t) = −10t + 30 = 10 gives t = 2, which lies in (0, 4).' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 10 seconds', false, 'The number 10 is the average velocity in meters per second, not a time. The time comes from solving h′(t) = 10.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 3 seconds', false, 'Solving −10t + 30 = 0 gives t = 3, the time of the ball''s highest point, where the velocity is zero. That is not the instant matching the average velocity.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 4 seconds', false, 'The endpoint t = 4 is where the interval ends. The average over [0, 4] says nothing about the endpoint velocity, which is h′(4) = −10, not the average 10.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.1-a-v3', 'mcq', 'relate the average rate of change over an interval to the instantaneous rate for a quadratic position function, solving  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The volume of liquid in a vat is V(t) = 3t² − 12t liters after t minutes. At what time t, with 0 < t < 5, is the instantaneous rate of change of volume equal to the average rate of change over [0, 5]?', null, md5('apcalcab-mcq-b5-sv-h-2.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 3 minutes', false, 'The value 3 is the average rate in liters per minute, not a time. The time comes from solving V′(t) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 2 minutes', false, 'Solving 6t − 12 = 0 gives the minimum volume at t = 2, where the rate is zero. That is a different condition from matching the average rate.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 9/2 minutes', false, 'This solves 6t − 12 = 15, using V(5) − V(0) = 15 without dividing by the interval length 5 to form the average rate.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 5/2 minutes', true, 'Correct: The average rate is (V(5) − V(0))/5 = 15/5 = 3. Setting V′(t) = 6t − 12 = 3 gives t = 5/2.' from version_ins;
-- apcalcab-mcq-b5-h-2.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.1-b', 'mcq', 'decide what a net change over an interval does and does not tell you: average rate, not instantaneous rate or constant r', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The amount of water in a tank is W(t) gallons, where t is measured in hours. It is known that W(2) = 90 and W(8) = 60. Which statement must be true?', null, md5('apcalcab-mcq-b5-h-2.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The net change in the water from t = 2 to t = 8 is −30 gallons, so the average rate of change over that interval is −5 gallons per hour.', true, 'Correct: The net change is W(8) − W(2) = −30 gallons over 6 hours, so the average rate is −30/6 = −5 gallons per hour. Only this average is guaranteed by two data points.' from version_ins
union all select gen_random_uuid(), id, 'B', 'W′(5) = −5 gallons per hour.', false, 'The average rate over [2, 8] need not equal the instantaneous rate at the midpoint. W′(5) could be any value, since only the two endpoint values are known.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The tank lost exactly 5 gallons during every hour from t = 2 to t = 8.', false, 'An average of −5 gallons per hour is compatible with a leak that speeds up and slows down. The data do not show a constant rate in each hour.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average rate of change of the water from t = 2 to t = 8 is −30 gallons per hour.', false, 'The net change −30 is the change in gallons, not a rate. It must be divided by the interval length 6 hours to get the average rate in gallons per hour.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.1-b-v1', 'mcq', 'decide what a net change over an interval does and does not tell you: average rate, not instantaneous rate or constant r (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature of an oven is T(t) degrees Celsius after t minutes. It is known that T(10) = 180 and T(25) = 255. Which statement must be true?', null, md5('apcalcab-mcq-b5-sv-h-2.1-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The temperature rose by a net 75 degrees Celsius from t = 10 to t = 25, an average of 5 degrees Celsius per minute.', true, 'Correct: The net change is T(25) − T(10) = 75 degrees over 15 minutes, so the average rate of change is 75/15 = 5 degrees Celsius per minute.' from version_ins
union all select gen_random_uuid(), id, 'B', 'T′(17.5) = 5 degrees Celsius per minute.', false, 'The midpoint of [10, 25] is 17.5, but an average rate over an interval does not force the instantaneous rate at the midpoint to equal it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The oven was heating at 5 degrees Celsius per minute at the moment t = 25.', false, 'The average over [10, 25] says nothing specific about the rate at the endpoint t = 25, where the oven could be heating faster or slower.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average rate of change of temperature on [10, 25] is 75 degrees Celsius per minute.', false, 'The change of 75 degrees must be divided by the 15-minute length of the interval. As a rate, 75 degrees per minute is far too large.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.1-b-v2', 'mcq', 'decide what a net change over an interval does and does not tell you: average rate, not instantaneous rate or constant r (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The number of subscribers to a service is N(m) thousand, where m is the number of months since launch. It is known that N(4) = 120 and N(10) = 84. Which statement must be true?', null, md5('apcalcab-mcq-b5-sv-h-2.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The number of subscribers grew by an average of 6 thousand per month from m = 4 to m = 10.', false, 'The values show a decrease: N(10) − N(4) = −36. Reporting the average as positive is a sign error from subtracting in the wrong order.' from version_ins
union all select gen_random_uuid(), id, 'B', 'N′(7) = −6 thousand subscribers per month.', false, 'The average rate over [4, 10] does not determine the instantaneous rate at the midpoint m = 7, which can differ from the average.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The number of subscribers fell by a net 36 thousand from m = 4 to m = 10, an average of 6 thousand per month.', true, 'Correct: N(10) − N(4) = −36 thousand over 6 months, so the average rate is −6 thousand per month. Neither the midpoint value nor the midpoint rate is determined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'N(7) = 102 thousand subscribers.', false, 'N(7) = 102 assumes the number changed linearly between the two data points. With only two values, N(7) could be anything.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.1-b-v3', 'mcq', 'decide what a net change over an interval does and does not tell you: average rate, not instantaneous rate or constant r (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The depth of a river is D(x) meters at a point x meters from the bank. It is known that D(2) = 3.5 and D(10) = 1.5. Which statement must be true?', null, md5('apcalcab-mcq-b5-sv-h-2.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The depth decreases by exactly 0.25 meter for each meter moved from x = 2 to x = 10.', false, 'The average rate −0.25 does not mean the depth falls at that rate over every single meter. The riverbed may be steep in places and flat in others.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average rate of change of depth on [2, 10] is −2 meters per meter.', false, 'The net change −2 meters must be divided by the 8-meter length of the interval. Its average rate is −2/8 = −0.25 meter per meter.' from version_ins
union all select gen_random_uuid(), id, 'C', 'D(6) = 2.5 meters.', false, 'D(6) = 2.5 assumes the depth changes linearly between the two readings. Two values do not determine the depth at x = 6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The depth decreases by a net 2 meters from x = 2 to x = 10, an average of 0.25 meter of depth per meter of distance.', true, 'Correct: The net change is D(10) − D(2) = −2 meters over 8 meters of distance, an average rate of −2/8 = −0.25 meter per meter (a decrease of 0.25).' from version_ins;
-- apcalcab-mcq-b5-h-2.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.2-a', 'mcq', 'identify the function and point behind a difference-quotient limit and evaluate it as a derivative.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The limit lim(x→3) (x⁴ − 81)/(x − 3) equals f′(a) for some function f and number a. What is the value of the limit?', null, md5('apcalcab-mcq-b5-h-2.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '108', true, 'Correct: With f(x) = x⁴ and a = 3, the limit is f′(3) = 4 · 3³ = 108.' from version_ins
union all select gen_random_uuid(), id, 'B', '81', false, 'The number 81 is f(3) for f(x) = x⁴, not the derivative. The limit is the slope f′(3), not the function value.' from version_ins
union all select gen_random_uuid(), id, 'C', '324', false, 'This differentiates x⁴ as 4x⁴, keeping the exponent 4 instead of lowering it to 3. The correct power rule gives 4x³.' from version_ins
union all select gen_random_uuid(), id, 'D', '12', false, 'This computes 4 · 3 instead of 4 · 3³. It lowers the exponent in the original function but then forgets to apply it to the evaluated point.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-h-2.1-a','apcalcab-mcq-b5-sv-h-2.1-a-v1','apcalcab-mcq-b5-sv-h-2.1-a-v2','apcalcab-mcq-b5-sv-h-2.1-a-v3','apcalcab-mcq-b5-h-2.1-b','apcalcab-mcq-b5-sv-h-2.1-b-v1','apcalcab-mcq-b5-sv-h-2.1-b-v2','apcalcab-mcq-b5-sv-h-2.1-b-v3','apcalcab-mcq-b5-h-2.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b5-h-2.1-a','apcalcab-mcq-b5-sv-h-2.1-a-v1','apcalcab-mcq-b5-sv-h-2.1-a-v2','apcalcab-mcq-b5-sv-h-2.1-a-v3','apcalcab-mcq-b5-h-2.1-b','apcalcab-mcq-b5-sv-h-2.1-b-v1','apcalcab-mcq-b5-sv-h-2.1-b-v2','apcalcab-mcq-b5-sv-h-2.1-b-v3','apcalcab-mcq-b5-h-2.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
