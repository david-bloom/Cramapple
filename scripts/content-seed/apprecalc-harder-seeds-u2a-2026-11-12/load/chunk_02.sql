begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.2-a-v1','apprecalc-mcq-b7-sv-h-2.2-a-v2','apprecalc-mcq-b7-sv-h-2.2-a-v3','apprecalc-mcq-b7-h-2.2-b','apprecalc-mcq-b7-sv-h-2.2-b-v1','apprecalc-mcq-b7-sv-h-2.2-b-v2','apprecalc-mcq-b7-sv-h-2.2-b-v3','apprecalc-mcq-b7-h-2.3-a','apprecalc-mcq-b7-sv-h-2.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apprecalc-mcq-b7-sv-h-2.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.2-a-v1', 'mcq', 'decide where an exponential function lies relative to the line through two of its points, using concavity rather than th (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear function L and an exponential function E satisfy L(0) = E(0) = 100 and L(2) = E(2) = 25. Which statement about their values at x = 1 and x = 3 is true?', null, md5('apprecalc-mcq-b7-sv-h-2.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'E(1) > L(1) and E(3) > L(3)', false, 'This assumes an exponential function is larger than a linear one everywhere. Because the two graphs meet at x = 0 and x = 2, the concave-up exponential lies below the line between those points: E(1) = 50 is less than L(1) = 62.5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'E(1) > L(1) and E(3) < L(3)', false, 'This is the pattern for a concave-down curve. An exponential function is concave up, so it lies below the line through two of its points between them and above the line outside them; here E(3) = 12.5 exceeds L(3) = −12.5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'E(1) < L(1) and E(3) > L(3)', true, 'Correct: E(x) = 100·(1/2)ˣ and L(x) = (−75/2)x + 100. E(1) = 50 < L(1) = 62.5, and E(3) = 12.5 > L(3) = −12.5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'E(1) = L(1) and E(3) > L(3)', false, 'This assumes the two functions agree at the midpoint of their two meeting points. Exponential values are not averaged that way: E(1) = 50 while L(1) = 62.5, so they differ even though they agree at x = 0 and x = 2.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.2-a-v2', 'mcq', 'decide where an exponential function lies relative to the line through two of its points, using concavity rather than th (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear function L and an exponential function E satisfy L(0) = E(0) = 5 and L(3) = E(3) = 40. Which statement about their values at x = 1 and x = 4 is true?', null, md5('apprecalc-mcq-b7-sv-h-2.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'E(1) > L(1) and E(4) > L(4)', false, 'This assumes an exponential function is larger than a linear one everywhere. Because the two graphs meet at x = 0 and x = 3, the concave-up exponential lies below the line between those points: E(1) = 10 is less than L(1) = 16.7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'E(1) > L(1) and E(4) < L(4)', false, 'This is the pattern for a concave-down curve. An exponential function is concave up, so it lies below the line through two of its points between them and above the line outside them; here E(4) = 80 exceeds L(4) = 51.7.' from version_ins
union all select gen_random_uuid(), id, 'C', 'E(1) = L(1) and E(4) > L(4)', false, 'This assumes the two functions agree at the midpoint of their two meeting points. Exponential values are not averaged that way: E(1) = 10 while L(1) = 16.7, so they differ even though they agree at x = 0 and x = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'E(1) < L(1) and E(4) > L(4)', true, 'Correct: E(x) = 5·2ˣ and L(x) = (35/3)x + 5. E(1) = 10 < L(1) = 16.7, and E(4) = 80 > L(4) = 51.7.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.2-a-v3', 'mcq', 'decide where an exponential function lies relative to the line through two of its points, using concavity rather than th (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear function L and an exponential function E satisfy L(1) = E(1) = 12 and L(3) = E(3) = 48. Which statement about their values at x = 2 and x = 4 is true?', null, md5('apprecalc-mcq-b7-sv-h-2.2-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'E(2) > L(2) and E(4) > L(4)', false, 'This assumes an exponential function is larger than a linear one everywhere. Because the two graphs meet at x = 1 and x = 3, the concave-up exponential lies below the line between those points: E(2) = 24 is less than L(2) = 30.' from version_ins
union all select gen_random_uuid(), id, 'B', 'E(2) < L(2) and E(4) > L(4)', true, 'Correct: E(x) = 6·2ˣ and L(x) = 18x − 6. E(2) = 24 < L(2) = 30, and E(4) = 96 > L(4) = 66.' from version_ins
union all select gen_random_uuid(), id, 'C', 'E(2) > L(2) and E(4) < L(4)', false, 'This is the pattern for a concave-down curve. An exponential function is concave up, so it lies below the line through two of its points between them and above the line outside them; here E(4) = 96 exceeds L(4) = 66.' from version_ins
union all select gen_random_uuid(), id, 'D', 'E(2) = L(2) and E(4) > L(4)', false, 'This assumes the two functions agree at the midpoint of their two meeting points. Exponential values are not averaged that way: E(2) = 24 while L(2) = 30, so they differ even though they agree at x = 1 and x = 3.' from version_ins;
-- apprecalc-mcq-b7-h-2.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.2-b', 'mcq', 'use the fact that average rates of change of an exponential over equal-length intervals form a geometric pattern with ra', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An exponential function f is defined for all real x. The average rate of change of f over the interval [0, 2] is 6, and over [2, 4] it is 54. What is the average rate of change of f over [4, 6]?', null, md5('apprecalc-mcq-b7-h-2.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '102', false, 'This continues an arithmetic pattern, adding the same amount (48) again. Average rates of change of an exponential function over equal-length intervals are multiplied by a constant factor, here 9, not increased by a constant amount.' from version_ins
union all select gen_random_uuid(), id, 'B', '486', true, 'Correct: Each average rate is ab^x(b^2 − 1)/2 evaluated at the left end, so over consecutive intervals of length 2 the rates are multiplied by b^2. Here 54/6 = 9, so the next rate is 54·9 = 486.' from version_ins
union all select gen_random_uuid(), id, 'C', '162', false, 'This multiplies by the growth factor per unit input, 3, but the intervals have length 2. Over 2 units the rates are multiplied by 3^2 = 9, which is the ratio 54/6 already shown.' from version_ins
union all select gen_random_uuid(), id, 'D', '63', false, 'This adds the ratio 9 to the previous rate instead of multiplying by it. The two given rates differ by a factor of 9, so the next rate is 54 times 9.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.2-b-v1', 'mcq', 'use the fact that average rates of change of an exponential over equal-length intervals form a geometric pattern with ra (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An exponential function f models a quantity measured in thousands, with input in hours. The average rate of change of f over the interval [0, 3] is 5, and over [3, 6] it is 40. What is the average rate of change of f over [6, 9]?', null, md5('apprecalc-mcq-b7-sv-h-2.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '75', false, 'This continues an arithmetic pattern, adding the same amount (35) again. Average rates of change of an exponential function over equal-length intervals are multiplied by a constant factor, here 8, not increased by a constant amount.' from version_ins
union all select gen_random_uuid(), id, 'B', '80', false, 'This multiplies by the growth factor per unit input, 2, but the intervals have length 3. Over 3 units the rates are multiplied by 2^3 = 8, which is the ratio 40/5 already shown.' from version_ins
union all select gen_random_uuid(), id, 'C', '320', true, 'Correct: Each average rate is ab^x(b^3 − 1)/3 evaluated at the left end, so over consecutive intervals of length 3 the rates are multiplied by b^3. Here 40/5 = 8, so the next rate is 40·8 = 320.' from version_ins
union all select gen_random_uuid(), id, 'D', '48', false, 'This adds the ratio 8 to the previous rate instead of multiplying by it. The two given rates differ by a factor of 8, so the next rate is 40 times 8.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.2-b-v2', 'mcq', 'use the fact that average rates of change of an exponential over equal-length intervals form a geometric pattern with ra (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A decaying exponential function f is defined for all real x. The average rate of change of f over the interval [0, 2] is −48, and over [2, 4] it is −12. What is the average rate of change of f over [4, 6]?', null, md5('apprecalc-mcq-b7-sv-h-2.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24', false, 'This continues an arithmetic pattern, adding the same amount (36) again. Average rates of change of an exponential function over equal-length intervals are multiplied by a constant factor, here 0.25, not increased by a constant amount.' from version_ins
union all select gen_random_uuid(), id, 'B', '−6', false, 'This multiplies by the growth factor per unit input, 0.5, but the intervals have length 2. Over 2 units the rates are multiplied by 0.5^2 = 0.25, which is the ratio −12/−48 already shown.' from version_ins
union all select gen_random_uuid(), id, 'C', '−11.75', false, 'This adds the ratio 0.25 to the previous rate instead of multiplying by it. The two given rates differ by a factor of 0.25, so the next rate is −12 times 0.25.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3', true, 'Correct: Each average rate is ab^x(b^2 − 1)/2 evaluated at the left end, so over consecutive intervals of length 2 the rates are multiplied by b^2. Here −12/−48 = 0.25, so the next rate is −12·0.25 = −3.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.2-b-v3', 'mcq', 'use the fact that average rates of change of an exponential over equal-length intervals form a geometric pattern with ra (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An exponential function f models the height of a plant in centimeters, with input in weeks. The average rate of change of f over the interval [0, 2] is 8, and over [2, 4] it is 18. What is the average rate of change of f over [4, 6]?', null, md5('apprecalc-mcq-b7-sv-h-2.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40.5', true, 'Correct: Each average rate is ab^x(b^2 − 1)/2 evaluated at the left end, so over consecutive intervals of length 2 the rates are multiplied by b^2. Here 18/8 = 2.25, so the next rate is 18·2.25 = 40.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '28', false, 'This continues an arithmetic pattern, adding the same amount (10) again. Average rates of change of an exponential function over equal-length intervals are multiplied by a constant factor, here 2.25, not increased by a constant amount.' from version_ins
union all select gen_random_uuid(), id, 'C', '27', false, 'This multiplies by the growth factor per unit input, 1.5, but the intervals have length 2. Over 2 units the rates are multiplied by 1.5^2 = 2.25, which is the ratio 18/8 already shown.' from version_ins
union all select gen_random_uuid(), id, 'D', '20.25', false, 'This adds the ratio 2.25 to the previous rate instead of multiplying by it. The two given rates differ by a factor of 2.25, so the next rate is 18 times 2.25.' from version_ins;
-- apprecalc-mcq-b7-h-2.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.3-a', 'mcq', 'work back from two non-adjacent values of an exponential function to its initial value, resisting linear extrapolation a', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function has the form f(x) = a·bˣ with b > 0, f(2) = 18, and f(5) = 486. What is f(0)?', null, md5('apprecalc-mcq-b7-h-2.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', true, 'Correct: f(5)/f(2) = b^3 = 27, so b = 3. Then a = f(2)/b^2 = 18/9 = 2, so f(0) = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This divides f(2) by b^1, which only steps back to x = 1, not to x = 0. Since f(2) = a·b^2, the initial value a requires dividing by b^2, and a·b = 6 is the value of f(1).' from version_ins
union all select gen_random_uuid(), id, 'C', '2/3', false, 'This divides f(2) by b^3, going one step past x = 0. Since f(2) = a·b^2, dividing by b^2 gives a, while dividing by b^3 gives a/b, which is f(−1).' from version_ins
union all select gen_random_uuid(), id, 'D', '−294', false, 'This extends a straight line through the two given points, with a constant change of 156 per unit. An exponential function changes by a constant factor, not a constant amount, so its value at x = 0 is found by dividing out powers of b.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.3-a-v1', 'mcq', 'work back from two non-adjacent values of an exponential function to its initial value, resisting linear extrapolation a (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a function of the form f(x) = a·bˣ with b > 0, f(1) = −12, and f(4) = −324. What is f(0)?', null, md5('apprecalc-mcq-b7-sv-h-2.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12', false, 'This divides f(1) by b^0, which only steps back to x = 1, not to x = 0. Since f(1) = a·b^1, the initial value a requires dividing by b^1, and a·b = −12 is the value of f(1).' from version_ins
union all select gen_random_uuid(), id, 'B', '−4/3', false, 'This divides f(1) by b^2, going one step past x = 0. Since f(1) = a·b^1, dividing by b^1 gives a, while dividing by b^2 gives a/b, which is f(−1).' from version_ins
union all select gen_random_uuid(), id, 'C', '−4', true, 'Correct: f(4)/f(1) = b^3 = 27, so b = 3. Then a = f(1)/b^1 = −12/3 = −4, so f(0) = −4.' from version_ins
union all select gen_random_uuid(), id, 'D', '92', false, 'This extends a straight line through the two given points, with a constant change of −104 per unit. An exponential function changes by a constant factor, not a constant amount, so its value at x = 0 is found by dividing out powers of b.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.2-a-v1','apprecalc-mcq-b7-sv-h-2.2-a-v2','apprecalc-mcq-b7-sv-h-2.2-a-v3','apprecalc-mcq-b7-h-2.2-b','apprecalc-mcq-b7-sv-h-2.2-b-v1','apprecalc-mcq-b7-sv-h-2.2-b-v2','apprecalc-mcq-b7-sv-h-2.2-b-v3','apprecalc-mcq-b7-h-2.3-a','apprecalc-mcq-b7-sv-h-2.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b7-sv-h-2.2-a-v1','apprecalc-mcq-b7-sv-h-2.2-a-v2','apprecalc-mcq-b7-sv-h-2.2-a-v3','apprecalc-mcq-b7-h-2.2-b','apprecalc-mcq-b7-sv-h-2.2-b-v1','apprecalc-mcq-b7-sv-h-2.2-b-v2','apprecalc-mcq-b7-sv-h-2.2-b-v3','apprecalc-mcq-b7-h-2.3-a','apprecalc-mcq-b7-sv-h-2.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
