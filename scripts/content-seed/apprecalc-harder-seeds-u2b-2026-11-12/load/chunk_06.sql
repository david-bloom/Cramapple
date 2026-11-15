begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.14-b-v1','apprecalc-mcq-b8-sv-h-2.14-b-v2','apprecalc-mcq-b8-sv-h-2.14-b-v3','apprecalc-mcq-b8-h-2.15-a','apprecalc-mcq-b8-sv-h-2.15-a-v1','apprecalc-mcq-b8-sv-h-2.15-a-v2','apprecalc-mcq-b8-sv-h-2.15-a-v3','apprecalc-mcq-b8-h-2.15-b','apprecalc-mcq-b8-sv-h-2.15-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apprecalc-mcq-b8-sv-h-2.14-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.14-b-v1', 'mcq', 'compare average rates of change of a logarithmic model on two intervals that each span one multiplication of the input,  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model gives depth D(t) = 3 + 6log₃(t), t in minutes, in meters. Which pair correctly gives the average rates of change of D over [1, 3] and over [9, 27]?', null, md5('apprecalc-mcq-b8-sv-h-2.14-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3 meters per minute on [1, 3] and 1/3 meters per minute on [9, 27]', true, 'Correct: Each interval multiplies the input by 3, so the output rises by 6. Rates: 6/2 = 3 and 6/18 = 1/3; the rate falls as the interval moves right.' from version_ins
union all select gen_random_uuid(), id, 'B', '6 meters per minute on [1, 3] and 6 meters per minute on [9, 27]', false, 'Over each interval the output rises by 6, because the input is multiplied by 3 each time, but a rate divides that change by the interval width: 2 and 18, which are different.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/3 meters per minute on [1, 3] and 3 meters per minute on [9, 27]', false, 'This swaps the two rates. The later interval is wider (18 units) for the same rise of 6, so its rate must be the smaller of the two.' from version_ins
union all select gen_random_uuid(), id, 'D', '3 meters per minute on [1, 3] and 2/9 meters per minute on [9, 27]', false, 'The rate on [9, 27] divides the rise 6 by the interval''s width, 27 − 9 = 18, not by its right endpoint 27.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.14-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.14-b-v2', 'mcq', 'compare average rates of change of a logarithmic model on two intervals that each span one multiplication of the input,  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model gives signal M(t) = 5 + 12log₂(t), t in seconds, in units. Which pair correctly gives the average rates of change of M over [2, 4] and over [8, 16]?', null, md5('apprecalc-mcq-b8-sv-h-2.14-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6 units per second on [2, 4] and 3/2 units per second on [8, 16]', true, 'Correct: Each interval multiplies the input by 2, so the output rises by 12. Rates: 12/2 = 6 and 12/8 = 3/2; the rate falls as the interval moves right.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 units per second on [2, 4] and 12 units per second on [8, 16]', false, 'Over each interval the output rises by 12, because the input is multiplied by 2 each time, but a rate divides that change by the interval width: 2 and 8, which are different.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/2 units per second on [2, 4] and 6 units per second on [8, 16]', false, 'This swaps the two rates. The later interval is wider (8 units) for the same rise of 12, so its rate must be the smaller of the two.' from version_ins
union all select gen_random_uuid(), id, 'D', '6 units per second on [2, 4] and 3/4 units per second on [8, 16]', false, 'The rate on [8, 16] divides the rise 12 by the interval''s width, 16 − 8 = 8, not by its right endpoint 16.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.14-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.14-b-v3', 'mcq', 'compare average rates of change of a logarithmic model on two intervals that each span one multiplication of the input,  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model gives reading E(t) = 1 + 6log₄(t), t in days, in units. Which pair correctly gives the average rates of change of E over [1, 4] and over [4, 16]?', null, md5('apprecalc-mcq-b8-sv-h-2.14-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 units per day on [1, 4] and 1/2 units per day on [4, 16]', true, 'Correct: Each interval multiplies the input by 4, so the output rises by 6. Rates: 6/3 = 2 and 6/12 = 1/2; the rate falls as the interval moves right.' from version_ins
union all select gen_random_uuid(), id, 'B', '6 units per day on [1, 4] and 6 units per day on [4, 16]', false, 'Over each interval the output rises by 6, because the input is multiplied by 4 each time, but a rate divides that change by the interval width: 3 and 12, which are different.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2 units per day on [1, 4] and 2 units per day on [4, 16]', false, 'This swaps the two rates. The later interval is wider (12 units) for the same rise of 6, so its rate must be the smaller of the two.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 units per day on [1, 4] and 3/8 units per day on [4, 16]', false, 'The rate on [4, 16] divides the rise 6 by the interval''s width, 16 − 4 = 12, not by its right endpoint 16.' from version_ins;
-- apprecalc-mcq-b8-h-2.15-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.15-a', 'mcq', 'recover the exponential model y = a·bˣ from two points on a semi-log line, using the slope for b and the vertical interc', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A semi-log plot of log₂(y) against x is a straight line through the points (1, 5) and (4, 11). Which exponential function y = f(x) do the data follow?', null, md5('apprecalc-mcq-b8-h-2.15-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3·4ˣ', false, 'The base is right, but a is the value of y at x = 0, which is 2 raised to the vertical intercept, not the intercept itself; here a = 8, not 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '8·4ˣ', true, 'Correct: Slope = (11 − 5)/(4 − 1) = 2, so b = 2^2 = 4. Intercept 3 gives a = 2^3 = 8. Check: f(1) = 8·4^1 = 2^5.' from version_ins
union all select gen_random_uuid(), id, 'C', '32·4ˣ', false, 'This uses the given value 5 at x = 1 (2⁵ = 32) as a. The constant a is found at x = 0 from the line''s intercept, not from a data point at a nonzero x.' from version_ins
union all select gen_random_uuid(), id, 'D', '8·2ˣ', false, 'This uses the slope of the line as b. The slope is the exponent of the base, so b = 2^slope = 4, not the slope itself.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.15-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.15-a-v1', 'mcq', 'recover the exponential model y = a·bˣ from two points on a semi-log line, using the slope for b and the vertical interc (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A semi-log plot of log₃(y) against x is a straight line through the points (2, 5) and (4, 9). Which exponential function y = f(x) do the data follow?', null, md5('apprecalc-mcq-b8-sv-h-2.15-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3·9ˣ', true, 'Correct: Slope = (9 − 5)/(4 − 2) = 2, so b = 3^2 = 9. Intercept 1 gives a = 3^1 = 3. Check: f(2) = 3·9^2 = 3^5.' from version_ins
union all select gen_random_uuid(), id, 'B', '1·9ˣ', false, 'The base is right, but a is the value of y at x = 0, which is 3 raised to the vertical intercept, not the intercept itself; here a = 3, not 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '243·9ˣ', false, 'This uses the given value 5 at x = 2 (3⁵ = 243) as a. The constant a is found at x = 0 from the line''s intercept, not from a data point at a nonzero x.' from version_ins
union all select gen_random_uuid(), id, 'D', '3·2ˣ', false, 'This uses the slope of the line as b. The slope is the exponent of the base, so b = 3^slope = 9, not the slope itself.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.15-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.15-a-v2', 'mcq', 'recover the exponential model y = a·bˣ from two points on a semi-log line, using the slope for b and the vertical interc (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A semi-log plot of log₂(y) against x is a straight line through the points (1, 4) and (3, 10). Which exponential function y = f(x) do the data follow?', null, md5('apprecalc-mcq-b8-sv-h-2.15-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1·8ˣ', false, 'The base is right, but a is the value of y at x = 0, which is 2 raised to the vertical intercept, not the intercept itself; here a = 2, not 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '16·8ˣ', false, 'This uses the given value 4 at x = 1 (2⁴ = 16) as a. The constant a is found at x = 0 from the line''s intercept, not from a data point at a nonzero x.' from version_ins
union all select gen_random_uuid(), id, 'C', '2·8ˣ', true, 'Correct: Slope = (10 − 4)/(3 − 1) = 3, so b = 2^3 = 8. Intercept 1 gives a = 2^1 = 2. Check: f(1) = 2·8^1 = 2^4.' from version_ins
union all select gen_random_uuid(), id, 'D', '2·3ˣ', false, 'This uses the slope of the line as b. The slope is the exponent of the base, so b = 2^slope = 8, not the slope itself.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.15-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.15-a-v3', 'mcq', 'recover the exponential model y = a·bˣ from two points on a semi-log line, using the slope for b and the vertical interc (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A semi-log plot of log₁₀(y) against x is a straight line through the points (2, 1.4) and (5, 2.3). Which exponential function y = f(x) do the data follow?', null, md5('apprecalc-mcq-b8-sv-h-2.15-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10^0.8·10^(0.3x)', true, 'Correct: Slope = (2.3 − 1.4)/(5 − 2) = 0.3, so b = 10^0.3. Intercept = 1.4 − 0.3·2 = 0.8, so a = 10^0.8. Check at x = 2: 10^0.8·10^0.6 = 10^1.4.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.8·10^(0.3x)', false, 'This uses the vertical intercept 0.8 directly as a. The intercept is the value of log₁₀(y) at x = 0, so a = 10^0.8.' from version_ins
union all select gen_random_uuid(), id, 'C', '10^1.4·10^(0.3x)', false, 'This uses the given log value 1.4 at x = 2 to find a. The constant a must come from the line''s intercept at x = 0, which is 0.8.' from version_ins
union all select gen_random_uuid(), id, 'D', '10^0.8·0.3ˣ', false, 'This uses the slope 0.3 as the base. The slope is the power of 10 in the base, so b = 10^0.3, not 0.3.' from version_ins;
-- apprecalc-mcq-b8-h-2.15-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.15-b', 'mcq', 'interpret the slope of a semi-log line as growth per unit of time and use it to find a doubling or tripling time.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A semi-log plot of log₁₀(N) against time in days for a bacterial culture is a straight line with slope 0.15. Using log₁₀(2) ≈ 0.301, about how many days does it take to double?', null, md5('apprecalc-mcq-b8-h-2.15-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.5', false, 'This divides the slope by 0.301, which is the reverse of the needed quotient. The time is the required change in the log, 0.301, divided by the slope 0.15.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.7', false, 'This divides 1 by the slope, which would give the time for a tenfold increase. Doubling adds log₁₀(2) ≈ 0.301 to the vertical value, not 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.0', true, 'Correct: The vertical value must rise by log₁₀(2) ≈ 0.301. At 0.15 per day, the time is 0.301/0.15 ≈ 2.0 days.' from version_ins
union all select gen_random_uuid(), id, 'D', '13.3', false, 'This divides 2 by the slope, using the factor 2 as if it were the change in the logarithm. The required change is log₁₀(2) ≈ 0.301.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.15-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.15-b-v1', 'mcq', 'interpret the slope of a semi-log line as growth per unit of time and use it to find a doubling or tripling time. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A semi-log plot of log₁₀(F) against time in days for a social media account''s followers is a straight line with slope 0.06. Using log₁₀(2) ≈ 0.301, about how many days does it take to double?', null, md5('apprecalc-mcq-b8-sv-h-2.15-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.2', false, 'This divides the slope by 0.301, which is the reverse of the needed quotient. The time is the required change in the log, 0.301, divided by the slope 0.06.' from version_ins
union all select gen_random_uuid(), id, 'B', '16.7', false, 'This divides 1 by the slope, which would give the time for a tenfold increase. Doubling adds log₁₀(2) ≈ 0.301 to the vertical value, not 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '33.3', false, 'This divides 2 by the slope, using the factor 2 as if it were the change in the logarithm. The required change is log₁₀(2) ≈ 0.301.' from version_ins
union all select gen_random_uuid(), id, 'D', '5.0', true, 'Correct: The vertical value must rise by log₁₀(2) ≈ 0.301. At 0.06 per day, the time is 0.301/0.06 ≈ 5.0 days.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.14-b-v1','apprecalc-mcq-b8-sv-h-2.14-b-v2','apprecalc-mcq-b8-sv-h-2.14-b-v3','apprecalc-mcq-b8-h-2.15-a','apprecalc-mcq-b8-sv-h-2.15-a-v1','apprecalc-mcq-b8-sv-h-2.15-a-v2','apprecalc-mcq-b8-sv-h-2.15-a-v3','apprecalc-mcq-b8-h-2.15-b','apprecalc-mcq-b8-sv-h-2.15-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b8-sv-h-2.14-b-v1','apprecalc-mcq-b8-sv-h-2.14-b-v2','apprecalc-mcq-b8-sv-h-2.14-b-v3','apprecalc-mcq-b8-h-2.15-a','apprecalc-mcq-b8-sv-h-2.15-a-v1','apprecalc-mcq-b8-sv-h-2.15-a-v2','apprecalc-mcq-b8-sv-h-2.15-a-v3','apprecalc-mcq-b8-h-2.15-b','apprecalc-mcq-b8-sv-h-2.15-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
