begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-h-1.1-a','apprecalc-mcq-b10-sv-h-1.1-a-v1','apprecalc-mcq-b10-sv-h-1.1-a-v2','apprecalc-mcq-b10-sv-h-1.1-a-v3','apprecalc-mcq-b10-h-1.1-b','apprecalc-mcq-b10-sv-h-1.1-b-v1','apprecalc-mcq-b10-sv-h-1.1-b-v2','apprecalc-mcq-b10-sv-h-1.1-b-v3','apprecalc-mcq-b10-h-1.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apprecalc-mcq-b10-h-1.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.1-a', 'mcq', 'decide how subtracting a function from a constant changes both its direction and its concavity, using successive changes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A store records f(t), its cumulative sales in thousands of dollars, at the end of weeks t = 0, 1, 2, 3, 4 of a promotion: 4, 9, 13, 16, 18. Let g(t) = 30 − f(t) be the sales still needed to reach a 30-thousand-dollar goal. Assume f changes smoothly between the table entries. Which statement describes g on 0 ≤ t ≤ 4?', null, md5('apprecalc-mcq-b10-h-1.1-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is increasing and concave up', false, 'This has the concavity of g but the direction of f. Since g(t) = 30 − f(t), the outputs of g fall as f rises, so g is decreasing, not increasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is increasing and concave down', false, 'This is the behavior of f itself, not of g. Subtracting f from a constant negates every change, so the changes in g (−5, −4, −3, −2) reverse both the direction and the concavity of f.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is decreasing and concave up', true, 'Correct: The changes in f are 5, 4, 3, 2, so f is increasing and concave down. For g = 30 − f the values are 26, 21, 17, 14, 12, with changes −5, −4, −3, −2, so g is decreasing and concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is decreasing and concave down', false, 'This reverses the direction as it should but carries over the concavity of f. The successive changes in g are −5, −4, −3, −2, which are the negatives of the changes in f, so g is concave up, not concave down.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.1-a-v1', 'mcq', 'decide how subtracting a function from a constant changes both its direction and its concavity, using successive changes (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cup of liquid cools, and f(t) is its temperature in °C at minutes t = 0, 1, 2, 3, 4: 40, 28, 20, 15, 12. Let g(t) = 60 − f(t) be the number of degrees by which f lies below a 60 °C reference line. Assume f changes smoothly between readings. Which statement describes g on 0 ≤ t ≤ 4?', null, md5('apprecalc-mcq-b10-sv-h-1.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is increasing and concave up', false, 'This reverses the direction as it should but carries over the concavity of f. The successive changes in g are 12, 8, 5, 3, which are the negatives of the changes in f, so g is concave down, not concave up.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is decreasing and concave up', false, 'This is the behavior of f itself, not of g. Subtracting f from a constant negates every change, so the changes in g (12, 8, 5, 3) reverse both the direction and the concavity of f.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is increasing and concave down', true, 'Correct: The changes in f are −12, −8, −5, −3, so f is decreasing and concave up. For g = 60 − f the values are 20, 32, 40, 45, 48, with changes 12, 8, 5, 3, so g is increasing and concave down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is decreasing and concave down', false, 'This has the concavity of g but the direction of f. Since g(t) = 60 − f(t), the outputs of g rise as f falls, so g is increasing, not decreasing.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.1-a-v2', 'mcq', 'decide how subtracting a function from a constant changes both its direction and its concavity, using successive changes (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives f(t), the number of followers of a new account, in hundreds, at weeks t = 0, 1, 2, 3, 4: 2, 3, 5, 9, 17. A forecasting sheet tracks g(t) = 25 − f(t), the gap to a 25-hundred target. Assume f changes smoothly between table entries. Which statement describes g on 0 ≤ t ≤ 4?', null, md5('apprecalc-mcq-b10-sv-h-1.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is increasing and concave up', false, 'This is the behavior of f itself, not of g. Subtracting f from a constant negates every change, so the changes in g (−1, −2, −4, −8) reverse both the direction and the concavity of f.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is increasing and concave down', false, 'This has the concavity of g but the direction of f. Since g(t) = 25 − f(t), the outputs of g fall as f rises, so g is decreasing, not increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is decreasing and concave up', false, 'This reverses the direction as it should but carries over the concavity of f. The successive changes in g are −1, −2, −4, −8, which are the negatives of the changes in f, so g is concave down, not concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is decreasing and concave down', true, 'Correct: The changes in f are 1, 2, 4, 8, so f is increasing and concave up. For g = 25 − f the values are 23, 22, 20, 16, 8, with changes −1, −2, −4, −8, so g is decreasing and concave down.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.1-a-v3', 'mcq', 'decide how subtracting a function from a constant changes both its direction and its concavity, using successive changes (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diver''s depth f(t), in feet below the surface, is recorded at seconds t = 0, 1, 2, 3, 4: 50, 46, 40, 32, 22. Let g(t) = 80 − f(t) be the diver''s height above a marker 80 feet below the surface. Assume f changes smoothly between recorded times. Which statement describes g on 0 ≤ t ≤ 4?', null, md5('apprecalc-mcq-b10-sv-h-1.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is increasing and concave down', false, 'This reverses the direction as it should but carries over the concavity of f. The successive changes in g are 4, 6, 8, 10, which are the negatives of the changes in f, so g is concave up, not concave down.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is decreasing and concave up', false, 'This has the concavity of g but the direction of f. Since g(t) = 80 − f(t), the outputs of g rise as f falls, so g is increasing, not decreasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is decreasing and concave down', false, 'This is the behavior of f itself, not of g. Subtracting f from a constant negates every change, so the changes in g (4, 6, 8, 10) reverse both the direction and the concavity of f.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is increasing and concave up', true, 'Correct: The changes in f are −4, −6, −8, −10, so f is decreasing and concave down. For g = 80 − f the values are 30, 34, 40, 48, 58, with changes 4, 6, 8, 10, so g is increasing and concave up.' from version_ins;
-- apprecalc-mcq-b10-h-1.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.1-b', 'mcq', 'combine the direction and concavity of two functions to decide which features of their sum are forced and which are not.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x ≤ 10, f(x) models the yearly revenue of one product and g(x) the yearly revenue of a second product, and s(x) = f(x) + g(x) is the combined revenue. On this interval f is increasing and concave down and g is increasing and concave up. Which statement about s must be true?', null, md5('apprecalc-mcq-b10-h-1.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 's is increasing, but its concavity cannot be determined from the information given.', true, 'Correct: When two functions are both increasing on an interval, every average rate of change of s = f + g is the sum of two rates of the same sign, so s is increasing. Because f is concave down and g is concave up, the change in the rates of s is a sum of a positive and a negative amount, so concavity is undetermined.' from version_ins
union all select gen_random_uuid(), id, 'B', 's is increasing and concave up.', false, 'This is not forced. One summand is concave down and the other is concave up, so how s bends depends on which one curves more sharply; concave up is possible but so is concave down.' from version_ins
union all select gen_random_uuid(), id, 'C', 's is increasing and concave down.', false, 'This is not forced. One summand is concave down and the other is concave up, so how s bends depends on which one curves more sharply; concave down is possible but so is concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither the direction nor the concavity of s can be determined.', false, 'The direction is determined. When two functions are both increasing on an interval, every average rate of change of s = f + g is the sum of two rates of the same sign, so s is increasing. Only the concavity is left open.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.1-b-v1', 'mcq', 'combine the direction and concavity of two functions to decide which features of their sum are forced and which are not. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two pipes drain a reservoir. Over 0 ≤ t ≤ 8, the volume f(t) from the first pipe''s tank is decreasing and concave up, and the volume g(t) in the second pipe''s tank is decreasing and concave down. Let s(t) = f(t) + g(t) be the total volume remaining. Which statement about s must be true?', null, md5('apprecalc-mcq-b10-sv-h-1.1-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 's is decreasing and concave up.', false, 'This is not forced. One summand is concave up and the other is concave down, so how s bends depends on which one curves more sharply; concave up is possible but so is concave down.' from version_ins
union all select gen_random_uuid(), id, 'B', 's is decreasing, but its concavity cannot be determined from the information given.', true, 'Correct: When two functions are both decreasing on an interval, every average rate of change of s = f + g is the sum of two rates of the same sign, so s is decreasing. Because f is concave up and g is concave down, the change in the rates of s is a sum of a positive and a negative amount, so concavity is undetermined.' from version_ins
union all select gen_random_uuid(), id, 'C', 's is decreasing and concave down.', false, 'This is not forced. One summand is concave up and the other is concave down, so how s bends depends on which one curves more sharply; concave down is possible but so is concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither the direction nor the concavity of s can be determined.', false, 'The direction is determined. When two functions are both decreasing on an interval, every average rate of change of s = f + g is the sum of two rates of the same sign, so s is decreasing. Only the concavity is left open.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.1-b-v2', 'mcq', 'combine the direction and concavity of two functions to decide which features of their sum are forced and which are not. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A runner''s distance f(t) and a cyclist''s distance g(t) from a starting line are modeled for 0 ≤ t ≤ 5, with f increasing and concave up and g decreasing and concave up. Let s(t) = f(t) + g(t) be the sum of their distances. Which statement about s must be true?', null, md5('apprecalc-mcq-b10-sv-h-1.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 's is increasing and concave up.', false, 'This is not forced. One summand is increasing and the other is decreasing, so the sum of their rates of change can be positive on one part of the interval and negative on another; increasing is possible but so is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 's is concave up, but whether it is increasing or decreasing cannot be determined from the information given.', true, 'Correct: Both functions are concave up, so the rates of change of f and of g are each increasing and the rates of s = f + g, which are their sums, are increasing too. Because f is increasing and g is decreasing, the sign of f''s rate plus g''s rate depends on which is larger, so the direction is undetermined.' from version_ins
union all select gen_random_uuid(), id, 'C', 's is decreasing and concave up.', false, 'This is not forced. One summand is increasing and the other is decreasing, so the sum of their rates of change can be positive on one part of the interval and negative on another; decreasing is possible but so is increasing.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither the direction nor the concavity of s can be determined.', false, 'The concavity is determined. Both functions are concave up, so the rates of change of f and of g are each increasing and the rates of s = f + g, which are their sums, are increasing too. Only the direction is left open.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.1-b-v3', 'mcq', 'combine the direction and concavity of two functions to decide which features of their sum are forced and which are not. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Over 1 ≤ x ≤ 9, the function f represents the depth of a lake basin at a point and g the depth at another point, with f decreasing and concave down and g increasing and concave down. Let s(x) = f(x) + g(x). Which statement about s must be true?', null, md5('apprecalc-mcq-b10-sv-h-1.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 's is increasing and concave down.', false, 'This is not forced. One summand is decreasing and the other is increasing, so the sum of their rates of change can be positive on one part of the interval and negative on another; increasing is possible but so is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 's is decreasing and concave down.', false, 'This is not forced. One summand is decreasing and the other is increasing, so the sum of their rates of change can be positive on one part of the interval and negative on another; decreasing is possible but so is increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 's is concave down, but whether it is increasing or decreasing cannot be determined from the information given.', true, 'Correct: Both functions are concave down, so the rates of change of f and of g are each decreasing and the rates of s = f + g, which are their sums, are decreasing too. Because f is decreasing and g is increasing, the sign of f''s rate plus g''s rate depends on which is larger, so the direction is undetermined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither the direction nor the concavity of s can be determined.', false, 'The concavity is determined. Both functions are concave down, so the rates of change of f and of g are each decreasing and the rates of s = f + g, which are their sums, are decreasing too. Only the direction is left open.' from version_ins;
-- apprecalc-mcq-b10-h-1.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.2-a', 'mcq', 'combine the average rates over two adjacent unequal intervals into the average rate over the union, weighting by interva', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone''s altitude h(t), in meters, has average rate of change 6 meters per second over 1 ≤ t ≤ 4 and −2 meters per second over 4 ≤ t ≤ 6. What is the average rate of change of h over 1 ≤ t ≤ 6, in meters per second?', null, md5('apprecalc-mcq-b10-h-1.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.8', true, 'Correct: Change over [1,4] is 6·3 = 18; change over [4,6] is −2·2 = −4. Total change 14 over length 5 gives 2.8.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This averages the two rates, 6 and −2, as if the two subintervals had equal length. The subintervals have lengths 3 and 2, so each rate must be weighted by its length.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This adds the two average rates. Rates cannot be added across consecutive intervals; the combined rate is the total change divided by the total length 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '14', false, 'This is the total change, 6·3 + −2·2 = 14, but it was never divided by the length 5 of the whole interval, so it is a change and not a rate.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-h-1.1-a','apprecalc-mcq-b10-sv-h-1.1-a-v1','apprecalc-mcq-b10-sv-h-1.1-a-v2','apprecalc-mcq-b10-sv-h-1.1-a-v3','apprecalc-mcq-b10-h-1.1-b','apprecalc-mcq-b10-sv-h-1.1-b-v1','apprecalc-mcq-b10-sv-h-1.1-b-v2','apprecalc-mcq-b10-sv-h-1.1-b-v3','apprecalc-mcq-b10-h-1.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b10-h-1.1-a','apprecalc-mcq-b10-sv-h-1.1-a-v1','apprecalc-mcq-b10-sv-h-1.1-a-v2','apprecalc-mcq-b10-sv-h-1.1-a-v3','apprecalc-mcq-b10-h-1.1-b','apprecalc-mcq-b10-sv-h-1.1-b-v1','apprecalc-mcq-b10-sv-h-1.1-b-v2','apprecalc-mcq-b10-sv-h-1.1-b-v3','apprecalc-mcq-b10-h-1.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
