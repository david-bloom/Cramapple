begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.3-a-v2','apprecalc-mcq-b7-sv-h-2.3-a-v3','apprecalc-mcq-b7-h-2.3-b','apprecalc-mcq-b7-sv-h-2.3-b-v1','apprecalc-mcq-b7-sv-h-2.3-b-v2','apprecalc-mcq-b7-sv-h-2.3-b-v3','apprecalc-mcq-b7-h-2.4-a','apprecalc-mcq-b7-sv-h-2.4-a-v1','apprecalc-mcq-b7-sv-h-2.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apprecalc-mcq-b7-sv-h-2.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.3-a-v2', 'mcq', 'work back from two non-adjacent values of an exponential function to its initial value, resisting linear extrapolation a (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An exponential function has the form f(x) = a·bˣ with b > 0, f(1) = 20, and f(4) = 2.5. What is f(0)?', null, md5('apprecalc-mcq-b7-sv-h-2.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20', false, 'This divides f(1) by b^0, which only steps back to x = 1, not to x = 0. Since f(1) = a·b^1, the initial value a requires dividing by b^1, and a·b = 20 is the value of f(1).' from version_ins
union all select gen_random_uuid(), id, 'B', '80', false, 'This divides f(1) by b^2, going one step past x = 0. Since f(1) = a·b^1, dividing by b^1 gives a, while dividing by b^2 gives a/b, which is f(−1).' from version_ins
union all select gen_random_uuid(), id, 'C', '155/6', false, 'This extends a straight line through the two given points, with a constant change of −35/6 per unit. An exponential function changes by a constant factor, not a constant amount, so its value at x = 0 is found by dividing out powers of b.' from version_ins
union all select gen_random_uuid(), id, 'D', '40', true, 'Correct: f(4)/f(1) = b^3 = 0.125, so b = 0.5. Then a = f(1)/b^1 = 20/0.5 = 40, so f(0) = 40.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.3-a-v3', 'mcq', 'work back from two non-adjacent values of an exponential function to its initial value, resisting linear extrapolation a (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function has the form f(x) = a·bˣ with b > 0, f(3) = 24, and f(5) = 96. What is f(0)?', null, md5('apprecalc-mcq-b7-sv-h-2.3-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', true, 'Correct: f(5)/f(3) = b^2 = 4, so b = 2. Then a = f(3)/b^3 = 24/8 = 3, so f(0) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This divides f(3) by b^2, which only steps back to x = 1, not to x = 0. Since f(3) = a·b^3, the initial value a requires dividing by b^3, and a·b = 6 is the value of f(1).' from version_ins
union all select gen_random_uuid(), id, 'C', '1.5', false, 'This divides f(3) by b^4, going one step past x = 0. Since f(3) = a·b^3, dividing by b^3 gives a, while dividing by b^4 gives a/b, which is f(−1).' from version_ins
union all select gen_random_uuid(), id, 'D', '−84', false, 'This extends a straight line through the two given points, with a constant change of 36 per unit. An exponential function changes by a constant factor, not a constant amount, so its value at x = 0 is found by dividing out powers of b.' from version_ins;
-- apprecalc-mcq-b7-h-2.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.3-b', 'mcq', 'combine the sign of the coefficient, the size of the base, and a vertical shift to describe monotonicity, range and y-in', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider g(x) = −3·(1/2)ˣ + 5. Which statement about g is true?', null, md5('apprecalc-mcq-b7-h-2.3-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is decreasing, its range is y < 5, and its y-intercept is (0, 2)', false, 'This decides increasing or decreasing from the base alone. Here the base is 0.5 and the coefficient is −3, so the negative coefficient reverses the usual behavior and g is increasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is increasing, its range is y > 5, and its y-intercept is (0, 2)', false, 'This puts the range on the wrong side of the horizontal asymptote y = 5. Since the coefficient −3 is negative, the exponential part is negative and g stays below y = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is increasing, its range is y < 5, and its y-intercept is (0, 2)', true, 'Correct: The asymptote is y = 5. The sign of the coefficient −3 and the base 0.5 make g increasing, and g stays below the asymptote. g(0) = −3 + 5 = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is increasing, its range is y < 5, and its y-intercept is (0, −3)', false, 'This reads the y-intercept as (0, −3) by forgetting the vertical shift. At x = 0 the exponential part equals −3, and adding the shift 5 gives g(0) = 2.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.3-b-v1', 'mcq', 'combine the sign of the coefficient, the size of the base, and a vertical shift to describe monotonicity, range and y-in (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider g(x) = −2·3ˣ + 7. Which statement about g is true?', null, md5('apprecalc-mcq-b7-sv-h-2.3-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is increasing, its range is y < 7, and its y-intercept is (0, 5)', false, 'This decides increasing or decreasing from the base alone. Here the base is 3 and the coefficient is −2, so the negative coefficient reverses the usual behavior and g is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is decreasing, its range is y < 7, and its y-intercept is (0, 5)', true, 'Correct: The asymptote is y = 7. The sign of the coefficient −2 and the base 3 make g decreasing, and g stays below the asymptote. g(0) = −2 + 7 = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is decreasing, its range is y > 7, and its y-intercept is (0, 5)', false, 'This puts the range on the wrong side of the horizontal asymptote y = 7. Since the coefficient −2 is negative, the exponential part is negative and g stays below y = 7.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is decreasing, its range is y < 7, and its y-intercept is (0, −2)', false, 'This reads the y-intercept as (0, −2) by forgetting the vertical shift. At x = 0 the exponential part equals −2, and adding the shift 7 gives g(0) = 5.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.3-b-v2', 'mcq', 'combine the sign of the coefficient, the size of the base, and a vertical shift to describe monotonicity, range and y-in (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider g(x) = 4·(1/3)ˣ + 1. Which statement about g is true?', null, md5('apprecalc-mcq-b7-sv-h-2.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is increasing, its range is y > 1, and its y-intercept is (0, 5)', false, 'This decides increasing or decreasing from the sign of the coefficient alone. Here the coefficient is 4 and the base is 1/3, which is less than 1, and the two together make g decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is decreasing, its range is y > 1, and its y-intercept is (0, 5)', true, 'Correct: The asymptote is y = 1. The sign of the coefficient 4 and the base 1/3 make g decreasing, and g stays above the asymptote. g(0) = 4 + 1 = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is decreasing, its range is y < 1, and its y-intercept is (0, 5)', false, 'This puts the range on the wrong side of the horizontal asymptote y = 1. Since the coefficient 4 is positive, the exponential part is positive and g stays above y = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is decreasing, its range is y > 1, and its y-intercept is (0, 4)', false, 'This reads the y-intercept as (0, 4) by forgetting the vertical shift. At x = 0 the exponential part equals 4, and adding the shift 1 gives g(0) = 5.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.3-b-v3', 'mcq', 'combine the sign of the coefficient, the size of the base, and a vertical shift to describe monotonicity, range and y-in (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider g(x) = −5·(1/3)ˣ − 2. Which statement about g is true?', null, md5('apprecalc-mcq-b7-sv-h-2.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is decreasing, its range is y < −2, and its y-intercept is (0, −7)', false, 'This decides increasing or decreasing from the base alone. Here the base is 1/3 and the coefficient is −5, so the negative coefficient reverses the usual behavior and g is increasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is increasing, its range is y > −2, and its y-intercept is (0, −7)', false, 'This puts the range on the wrong side of the horizontal asymptote y = −2. Since the coefficient −5 is negative, the exponential part is negative and g stays below y = −2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is increasing, its range is y < −2, and its y-intercept is (0, −7)', true, 'Correct: The asymptote is y = −2. The sign of the coefficient −5 and the base 1/3 make g increasing, and g stays below the asymptote. g(0) = −5 − 2 = −7.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is increasing, its range is y < −2, and its y-intercept is (0, −5)', false, 'This reads the y-intercept as (0, −5) by forgetting the vertical shift. At x = 0 the exponential part equals −5, and adding the shift −2 gives g(0) = −7.' from version_ins;
-- apprecalc-mcq-b7-h-2.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.4-a', 'mcq', 'rewrite an exponential with a fractional exponent and a horizontal shift in the form a·bᵗ, tracking both the new base an', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For all real t, N(t) = 40·8^((t − 6)/3). Which expression is equivalent to N(t) for every real t?', null, md5('apprecalc-mcq-b7-h-2.4-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40·2ᵗ', false, 'This takes the root correctly, 8^(1/3) = 2, but drops the shift in the exponent. Writing 2^(t − 6) = 2ᵗ·2^(−6) changes the coefficient from 40 to 5/8.' from version_ins
union all select gen_random_uuid(), id, 'B', '2560·2ᵗ', false, 'This applies the shift in the wrong direction. Since 2^(t − 6) = 2ᵗ·2^(−6), the coefficient is multiplied by 2^(−6) = 1/64, not by 64.' from version_ins
union all select gen_random_uuid(), id, 'C', '(5/8)·8ᵗ', false, 'This gets the coefficient right but keeps the base 8 instead of reducing it. Because the exponent is divided by 3, the factor per unit of t is 8^(1/3) = 2, not 8.' from version_ins
union all select gen_random_uuid(), id, 'D', '(5/8)·2ᵗ', true, 'Correct: 8^(1/3) = 2, so N(t) = 40·2^(t − 6) = 40·2^(−6)·2ᵗ = 5/8·2ᵗ.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.4-a-v1', 'mcq', 'rewrite an exponential with a fractional exponent and a horizontal shift in the form a·bᵗ, tracking both the new base an (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For all real t, N(t) = 162·9^((t − 4)/2). Which expression is equivalent to N(t) for every real t?', null, md5('apprecalc-mcq-b7-sv-h-2.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2·3ᵗ', true, 'Correct: 9^(1/2) = 3, so N(t) = 162·3^(t − 4) = 162·3^(−4)·3ᵗ = 2·3ᵗ.' from version_ins
union all select gen_random_uuid(), id, 'B', '162·3ᵗ', false, 'This takes the root correctly, 9^(1/2) = 3, but drops the shift in the exponent. Writing 3^(t − 4) = 3ᵗ·3^(−4) changes the coefficient from 162 to 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '13122·3ᵗ', false, 'This applies the shift in the wrong direction. Since 3^(t − 4) = 3ᵗ·3^(−4), the coefficient is multiplied by 3^(−4) = 1/81, not by 81.' from version_ins
union all select gen_random_uuid(), id, 'D', '2·9ᵗ', false, 'This gets the coefficient right but keeps the base 9 instead of reducing it. Because the exponent is divided by 2, the factor per unit of t is 9^(1/2) = 3, not 9.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.4-a-v2', 'mcq', 'rewrite an exponential with a fractional exponent and a horizontal shift in the form a·bᵗ, tracking both the new base an (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For all real t, N(t) = 5·(1/8)^((t − 2)/3). Which expression is equivalent to N(t) for every real t?', null, md5('apprecalc-mcq-b7-sv-h-2.4-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5·(1/2)ᵗ', false, 'This takes the root correctly, (1/8)^(1/3) = 1/2, but drops the shift in the exponent. Writing 1/2^(t − 2) = 1/2ᵗ·1/2^(−2) changes the coefficient from 5 to 20.' from version_ins
union all select gen_random_uuid(), id, 'B', '(5/4)·(1/2)ᵗ', false, 'This applies the shift in the wrong direction. Since 1/2^(t − 2) = 1/2ᵗ·1/2^(−2), the coefficient is multiplied by 1/2^(−2) = 4, not by 1/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '20·(1/8)ᵗ', false, 'This gets the coefficient right but keeps the base 1/8 instead of reducing it. Because the exponent is divided by 3, the factor per unit of t is 1/8^(1/3) = 1/2, not 1/8.' from version_ins
union all select gen_random_uuid(), id, 'D', '20·(1/2)ᵗ', true, 'Correct: 1/8^(1/3) = 1/2, so N(t) = 5·1/2^(t − 2) = 5·1/2^(−2)·1/2ᵗ = 20·1/2ᵗ.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.3-a-v2','apprecalc-mcq-b7-sv-h-2.3-a-v3','apprecalc-mcq-b7-h-2.3-b','apprecalc-mcq-b7-sv-h-2.3-b-v1','apprecalc-mcq-b7-sv-h-2.3-b-v2','apprecalc-mcq-b7-sv-h-2.3-b-v3','apprecalc-mcq-b7-h-2.4-a','apprecalc-mcq-b7-sv-h-2.4-a-v1','apprecalc-mcq-b7-sv-h-2.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b7-sv-h-2.3-a-v2','apprecalc-mcq-b7-sv-h-2.3-a-v3','apprecalc-mcq-b7-h-2.3-b','apprecalc-mcq-b7-sv-h-2.3-b-v1','apprecalc-mcq-b7-sv-h-2.3-b-v2','apprecalc-mcq-b7-sv-h-2.3-b-v3','apprecalc-mcq-b7-h-2.4-a','apprecalc-mcq-b7-sv-h-2.4-a-v1','apprecalc-mcq-b7-sv-h-2.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
