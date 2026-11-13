begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.2-a-v1','apprecalc-mcq-b10-sv-h-1.2-a-v2','apprecalc-mcq-b10-sv-h-1.2-a-v3','apprecalc-mcq-b10-h-1.2-b','apprecalc-mcq-b10-sv-h-1.2-b-v1','apprecalc-mcq-b10-sv-h-1.2-b-v2','apprecalc-mcq-b10-sv-h-1.2-b-v3','apprecalc-mcq-b10-h-1.3-a','apprecalc-mcq-b10-sv-h-1.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apprecalc-mcq-b10-sv-h-1.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.2-a-v1', 'mcq', 'combine the average rates over two adjacent unequal intervals into the average rate over the union, weighting by interva (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The water level L(d) of a reservoir, in centimeters, has average rate of change −4 cm per day over 0 ≤ d ≤ 2 and 3 cm per day over 2 ≤ d ≤ 7. What is the average rate of change of L over 0 ≤ d ≤ 7, in cm per day?', null, md5('apprecalc-mcq-b10-sv-h-1.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−0.5', false, 'This averages the two rates, −4 and 3, as if the two subintervals had equal length. The subintervals have lengths 2 and 5, so each rate must be weighted by its length.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', false, 'This adds the two average rates. Rates cannot be added across consecutive intervals; the combined rate is the total change divided by the total length 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', true, 'Correct: Change over [0,2] is −4·2 = −8; change over [2,7] is 3·5 = 15. Total change 7 over length 7 gives 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '7', false, 'This is the total change, −4·2 + 3·5 = 7, but it was never divided by the length 7 of the whole interval, so it is a change and not a rate.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.2-a-v2', 'mcq', 'combine the average rates over two adjacent unequal intervals into the average rate over the union, weighting by interva (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company''s profit P(q), in thousands of dollars, has average rate of change −6 thousand dollars per unit over 3 ≤ q ≤ 5 and 5 thousand dollars per unit over 5 ≤ q ≤ 8. What is the average rate of change of P over 3 ≤ q ≤ 8, in thousand dollars per unit?', null, md5('apprecalc-mcq-b10-sv-h-1.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−0.5', false, 'This averages the two rates, −6 and 5, as if the two subintervals had equal length. The subintervals have lengths 2 and 3, so each rate must be weighted by its length.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', false, 'This adds the two average rates. Rates cannot be added across consecutive intervals; the combined rate is the total change divided by the total length 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This is the total change, −6·2 + 5·3 = 3, but it was never divided by the length 5 of the whole interval, so it is a change and not a rate.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.6', true, 'Correct: Change over [3,5] is −6·2 = −12; change over [5,8] is 5·3 = 15. Total change 3 over length 5 gives 0.6.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.2-a-v3', 'mcq', 'combine the average rates over two adjacent unequal intervals into the average rate over the union, weighting by interva (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tree''s height H(y), in centimeters, has average rate of change 7 cm per year over 0 ≤ y ≤ 4 and −2 cm per year over 4 ≤ y ≤ 10. What is the average rate of change of H over 0 ≤ y ≤ 10, in cm per year?', null, md5('apprecalc-mcq-b10-sv-h-1.2-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.6', true, 'Correct: Change over [0,4] is 7·4 = 28; change over [4,10] is −2·6 = −12. Total change 16 over length 10 gives 1.6.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.5', false, 'This averages the two rates, 7 and −2, as if the two subintervals had equal length. The subintervals have lengths 4 and 6, so each rate must be weighted by its length.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This adds the two average rates. Rates cannot be added across consecutive intervals; the combined rate is the total change divided by the total length 10.' from version_ins
union all select gen_random_uuid(), id, 'D', '16', false, 'This is the total change, 7·4 + −2·6 = 16, but it was never divided by the length 10 of the whole interval, so it is a change and not a rate.' from version_ins;
-- apprecalc-mcq-b10-h-1.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.2-b', 'mcq', 'work backward from a given average rate of change of a quadratic to a missing coefficient, tracking the cancellation of ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The cost function C(x) = x² + kx + 40 models the cost, in dollars, of producing x items, where k is a constant. The average rate of change of C over 1 ≤ x ≤ 5 is 4 dollars per item. What is the value of k?', null, md5('apprecalc-mcq-b10-h-1.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2', true, 'Correct: The constant 40 cancels. The average rate is ((5² + 5k) − (1² + 1k))/4 = 6 + k. Setting 6 + k = 4 gives k = −2.' from version_ins
union all select gen_random_uuid(), id, 'B', '10', false, 'This has a sign error. The average rate of change of x² + kx + 40 over [1,5] equals 1 + 5 + k, so k = 4 − 6, not 4 + 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5', false, 'This sets the total change f(5) − f(1) equal to 4 without dividing by the interval length 4. The condition is on the average rate, which is that change divided by 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This simplifies (f(5) − f(1))/4 incorrectly, using the width 4 where the sum of the endpoints 6 belongs, because the x² terms give (5² − 1²)/4 = 6.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.2-b-v1', 'mcq', 'work backward from a given average rate of change of a quadratic to a missing coefficient, tracking the cancellation of  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The height of a ball is modeled by h(t) = t² + kt + 9, in feet, for t in seconds, where k is a constant. The average rate of change of h over 2 ≤ t ≤ 5 is 6 feet per second. What is the value of k?', null, md5('apprecalc-mcq-b10-sv-h-1.2-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13', false, 'This has a sign error. The average rate of change of x² + kx + 9 over [2,5] equals 2 + 5 + k, so k = 6 − 7, not 6 + 7.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', true, 'Correct: The constant 9 cancels. The average rate is ((5² + 5k) − (2² + 2k))/3 = 7 + k. Setting 7 + k = 6 gives k = −1.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5', false, 'This sets the total change f(5) − f(2) equal to 6 without dividing by the interval length 3. The condition is on the average rate, which is that change divided by 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'This simplifies (f(5) − f(2))/3 incorrectly, using the width 3 where the sum of the endpoints 7 belongs, because the x² terms give (5² − 2²)/3 = 7.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.2-b-v2', 'mcq', 'work backward from a given average rate of change of a quadratic to a missing coefficient, tracking the cancellation of  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor reading is modeled by r(x) = x² + kx + 15, where k is a constant. The average rate of change of r over 1 ≤ x ≤ 7 is 9. What is the value of k?', null, md5('apprecalc-mcq-b10-sv-h-1.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '17', false, 'This has a sign error. The average rate of change of x² + kx + 15 over [1,7] equals 1 + 7 + k, so k = 9 − 8, not 9 + 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '−6.5', false, 'This sets the total change f(7) − f(1) equal to 9 without dividing by the interval length 6. The condition is on the average rate, which is that change divided by 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This simplifies (f(7) − f(1))/6 incorrectly, using the width 6 where the sum of the endpoints 8 belongs, because the x² terms give (7² − 1²)/6 = 8.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', true, 'Correct: The constant 15 cancels. The average rate is ((7² + 7k) − (1² + 1k))/6 = 8 + k. Setting 8 + k = 9 gives k = 1.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.2-b-v3', 'mcq', 'work backward from a given average rate of change of a quadratic to a missing coefficient, tracking the cancellation of  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The profit P(n) = n² + kn − 20, in dollars, is earned when n bags are sold, where k is a constant. The average rate of change of P over 3 ≤ n ≤ 5 is 2 dollars per bag. What is the value of k?', null, md5('apprecalc-mcq-b10-sv-h-1.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10', false, 'This has a sign error. The average rate of change of x² + kx + -20 over [3,5] equals 3 + 5 + k, so k = 2 − 8, not 2 + 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '−7', false, 'This sets the total change f(5) − f(3) equal to 2 without dividing by the interval length 2. The condition is on the average rate, which is that change divided by 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−6', true, 'Correct: The constant -20 cancels. The average rate is ((5² + 5k) − (3² + 3k))/2 = 8 + k. Setting 8 + k = 2 gives k = −6.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This simplifies (f(5) − f(3))/2 incorrectly, using the width 2 where the sum of the endpoints 8 belongs, because the x² terms give (5² − 3²)/2 = 8.' from version_ins;
-- apprecalc-mcq-b10-h-1.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.3-a', 'mcq', 'infer concavity from average rates over intervals of unequal width, not from raw changes in output.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor reading f is recorded at the times x = 0, 1, 3, 7, with corresponding readings 0, 2, 5, 8. Assume the graph of f is continuous and has the same concavity throughout this interval. Which description of f is supported by the average rates of change?', null, md5('apprecalc-mcq-b10-h-1.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is increasing and concave down', true, 'Correct: The average rates on the three intervals are 2, 1.5, 0.75. They are positive and decreasing, so f is increasing and concave down.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is increasing and concave up', false, 'This compares the changes in output (2, 3, 3) instead of the average rates. The input intervals have different widths, so the changes mislead; the rates are 2, 1.5, 0.75, which are decreasing, so f is concave down.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is decreasing and concave up', false, 'This gets the direction wrong and takes concavity from the raw output changes (2, 3, 3) rather than from the rates (2, 1.5, 0.75). The rates show f is increasing and concave down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is decreasing and concave down', false, 'This has the right concavity but the wrong direction. Every average rate (2, 1.5, 0.75) is positive, so f is increasing.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.3-a-v1', 'mcq', 'infer concavity from average rates over intervals of unequal width, not from raw changes in output. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tank''s water level f is measured at the times x = 0, 4, 6, 7, with corresponding levels 10, 6, 2, −1. Assume the graph of f is continuous and has the same concavity throughout this interval. Which description of f is supported by the average rates of change?', null, md5('apprecalc-mcq-b10-sv-h-1.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is increasing and concave up', false, 'This gets the direction wrong and takes concavity from the raw output changes (−4, −4, −3) rather than from the rates (−1, −2, −3). The rates show f is decreasing and concave down.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is increasing and concave down', false, 'This has the right concavity but the wrong direction. Every average rate (−1, −2, −3) is negative, so f is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is decreasing and concave down', true, 'Correct: The average rates on the three intervals are −1, −2, −3. They are negative and decreasing, so f is decreasing and concave down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is decreasing and concave up', false, 'This compares the changes in output (−4, −4, −3) instead of the average rates. The input intervals have different widths, so the changes mislead; the rates are −1, −2, −3, which are decreasing, so f is concave down.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.2-a-v1','apprecalc-mcq-b10-sv-h-1.2-a-v2','apprecalc-mcq-b10-sv-h-1.2-a-v3','apprecalc-mcq-b10-h-1.2-b','apprecalc-mcq-b10-sv-h-1.2-b-v1','apprecalc-mcq-b10-sv-h-1.2-b-v2','apprecalc-mcq-b10-sv-h-1.2-b-v3','apprecalc-mcq-b10-h-1.3-a','apprecalc-mcq-b10-sv-h-1.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b10-sv-h-1.2-a-v1','apprecalc-mcq-b10-sv-h-1.2-a-v2','apprecalc-mcq-b10-sv-h-1.2-a-v3','apprecalc-mcq-b10-h-1.2-b','apprecalc-mcq-b10-sv-h-1.2-b-v1','apprecalc-mcq-b10-sv-h-1.2-b-v2','apprecalc-mcq-b10-sv-h-1.2-b-v3','apprecalc-mcq-b10-h-1.3-a','apprecalc-mcq-b10-sv-h-1.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
