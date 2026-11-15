begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-h-1.8-a','apprecalc-mcq-b9-sv-h-1.8-a-v1','apprecalc-mcq-b9-sv-h-1.8-a-v2','apprecalc-mcq-b9-sv-h-1.8-a-v3','apprecalc-mcq-b9-h-1.8-b','apprecalc-mcq-b9-sv-h-1.8-b-v1','apprecalc-mcq-b9-sv-h-1.8-b-v2','apprecalc-mcq-b9-sv-h-1.8-b-v3','apprecalc-mcq-b9-h-1.9-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apprecalc-mcq-b9-h-1.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.8-a', 'mcq', 'find the sum of the real zeros of a rational function after recognizing that a numerator zero shared with the denominato', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the rational function f(x) = (x − 4)(x + 2)(x + 5) / [(x + 2)(x² + 9)] for real x in its domain. What is the sum of all real zeros of f?', null, md5('apprecalc-mcq-b9-h-1.8-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3', false, 'This adds every zero of the numerator, 4, −2 and −5. But x = −2 makes the denominator zero as well, so f is undefined there and it is a hole rather than a zero.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This reads each factor with the wrong sign, taking (x − 4) to mean x = −4 and so on. The factor (x − 4) is zero when x = 4, so the zeros are 4 and −5.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', true, 'Correct: The factor (x + 2) cancels, so the numerator zero x = −2 is a hole, not a zero; x² + 9 has no real roots. The zeros are x = 4 and x = −5, with sum −1.' from version_ins
union all select gen_random_uuid(), id, 'D', '−20', false, 'This multiplies the zeros 4 and −5 instead of adding them, giving −20. The question asks for their sum, which is −1.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.8-a-v1', 'mcq', 'find the sum of the real zeros of a rational function after recognizing that a numerator zero shared with the denominato (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A signal model is f(x) = (x − 6)(x + 1)(x + 4) / [(x + 1)(x² + 2)] for real x in its domain. What is the sum of all real zeros of f?', null, md5('apprecalc-mcq-b9-sv-h-1.8-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This adds every zero of the numerator, 6, −1 and −4. But x = −1 makes the denominator zero as well, so f is undefined there and it is a hole rather than a zero.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2', false, 'This reads each factor with the wrong sign, taking (x − 6) to mean x = −6 and so on. The factor (x − 6) is zero when x = 6, so the zeros are 6 and −4.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', true, 'Correct: The factor (x + 1) cancels, so the numerator zero x = −1 is a hole, not a zero; x² + 2 has no real roots. The zeros are x = 6 and x = −4, with sum 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−24', false, 'This multiplies the zeros 6 and −4 instead of adding them, giving −24. The question asks for their sum, which is 2.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.8-a-v2', 'mcq', 'find the sum of the real zeros of a rational function after recognizing that a numerator zero shared with the denominato (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x + 2)(x − 3)(x − 7) / [(x − 3)(x² + 5)] for real x in its domain. What is the sum of all real zeros of f?', null, md5('apprecalc-mcq-b9-sv-h-1.8-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', false, 'This adds every zero of the numerator, −2, 3 and 7. But x = 3 makes the denominator zero as well, so f is undefined there and it is a hole rather than a zero.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5', false, 'This reads each factor with the wrong sign, taking (x + 2) to mean x = 2 and so on. The factor (x + 2) is zero when x = −2, so the zeros are −2 and 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '−14', false, 'This multiplies the zeros −2 and 7 instead of adding them, giving −14. The question asks for their sum, which is 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', true, 'Correct: The factor (x − 3) cancels, so the numerator zero x = 3 is a hole, not a zero; x² + 5 has no real roots. The zeros are x = −2 and x = 7, with sum 5.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.8-a-v3', 'mcq', 'find the sum of the real zeros of a rational function after recognizing that a numerator zero shared with the denominato (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rational model is f(x) = (x − 1)(x + 6)(x + 3) / [(x + 6)(x² + 8)] for real x in its domain. What is the sum of all real zeros of f?', null, md5('apprecalc-mcq-b9-sv-h-1.8-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−8', false, 'This adds every zero of the numerator, 1, −6 and −3. But x = −6 makes the denominator zero as well, so f is undefined there and it is a hole rather than a zero.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This reads each factor with the wrong sign, taking (x − 1) to mean x = −1 and so on. The factor (x − 1) is zero when x = 1, so the zeros are 1 and −3.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3', false, 'This multiplies the zeros 1 and −3 instead of adding them, giving −3. The question asks for their sum, which is −2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−2', true, 'Correct: The factor (x + 6) cancels, so the numerator zero x = −6 is a hole, not a zero; x² + 8 has no real roots. The zeros are x = 1 and x = −3, with sum −2.' from version_ins;
-- apprecalc-mcq-b9-h-1.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.8-b', 'mcq', 'find where the difference of two rational expressions is zero by clearing denominators and distributing correctly, then ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = 2/(x − 1) − 3/(x + 2). For which value of x is g(x) = 0?', null, md5('apprecalc-mcq-b9-h-1.8-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', true, 'Correct: Setting 2/(x − 1) = 3/(x + 2) and cross-multiplying gives 2(x + 2) = 3(x − 1), so x = (2·(−2) − 3·1)/(2 − 3) = 7, which is not 1 or −2, so it is allowed.' from version_ins
union all select gen_random_uuid(), id, 'B', '−8', false, 'This pairs each numerator with its own denominator when cross-multiplying, writing 2(x − 1) = 3(x + 2). Clearing fractions requires 2 times the other denominator, (x + 2), on the left side.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/5', false, 'This changes the sign on 3 when clearing denominators, as if the equation were 2/(x − 1) + 3/(x + 2) = 0. The equation is a difference, so the two fractions must be equal.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'This forgets to distribute 2 and 3 across the factors, writing 2x + 2 = 3x − 1. Each constant must multiply the whole factor, giving 7.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.8-b-v1', 'mcq', 'find where the difference of two rational expressions is zero by clearing denominators and distributing correctly, then  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The net rate of two processes is modeled by g(x) = 3/(x + 1) − 4/(x − 2). For which value of x is g(x) = 0?', null, md5('apprecalc-mcq-b9-sv-h-1.8-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '11', false, 'This pairs each numerator with its own denominator when cross-multiplying, writing 3(x + 1) = 4(x − 2). Clearing fractions requires 3 times the other denominator, (x − 2), on the left side.' from version_ins
union all select gen_random_uuid(), id, 'B', '−10', true, 'Correct: Setting 3/(x + 1) = 4/(x − 2) and cross-multiplying gives 3(x − 2) = 4(x + 1), so x = (3·2 − 4·(−1))/(3 − 4) = −10, which is not −1 or 2, so it is allowed.' from version_ins
union all select gen_random_uuid(), id, 'C', '2/7', false, 'This changes the sign on 4 when clearing denominators, as if the equation were 3/(x + 1) + 4/(x − 2) = 0. The equation is a difference, so the two fractions must be equal.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3', false, 'This forgets to distribute 3 and 4 across the factors, writing 3x − 2 = 4x + 1. Each constant must multiply the whole factor, giving −10.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.8-b-v2', 'mcq', 'find where the difference of two rational expressions is zero by clearing denominators and distributing correctly, then  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider g(x) = 5/(x − 2) − 2/(x + 3). For which value of x is g(x) = 0?', null, md5('apprecalc-mcq-b9-sv-h-1.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16/3', false, 'This pairs each numerator with its own denominator when cross-multiplying, writing 5(x − 2) = 2(x + 3). Clearing fractions requires 5 times the other denominator, (x + 3), on the left side.' from version_ins
union all select gen_random_uuid(), id, 'B', '−19/3', true, 'Correct: Setting 5/(x − 2) = 2/(x + 3) and cross-multiplying gives 5(x + 3) = 2(x − 2), so x = (5·(−3) − 2·2)/(5 − 2) = −19/3, which is not 2 or −3, so it is allowed.' from version_ins
union all select gen_random_uuid(), id, 'C', '−11/7', false, 'This changes the sign on 2 when clearing denominators, as if the equation were 5/(x − 2) + 2/(x + 3) = 0. The equation is a difference, so the two fractions must be equal.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5/3', false, 'This forgets to distribute 5 and 2 across the factors, writing 5x + 3 = 2x − 2. Each constant must multiply the whole factor, giving −19/3.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.8-b-v3', 'mcq', 'find where the difference of two rational expressions is zero by clearing denominators and distributing correctly, then  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A difference of two rates is g(x) = 4/(x − 3) − 6/(x + 1). For which value of x is g(x) = 0?', null, md5('apprecalc-mcq-b9-sv-h-1.8-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−9', false, 'This pairs each numerator with its own denominator when cross-multiplying, writing 4(x − 3) = 6(x + 1). Clearing fractions requires 4 times the other denominator, (x + 1), on the left side.' from version_ins
union all select gen_random_uuid(), id, 'B', '7/5', false, 'This changes the sign on 6 when clearing denominators, as if the equation were 4/(x − 3) + 6/(x + 1) = 0. The equation is a difference, so the two fractions must be equal.' from version_ins
union all select gen_random_uuid(), id, 'C', '11', true, 'Correct: Setting 4/(x − 3) = 6/(x + 1) and cross-multiplying gives 4(x + 1) = 6(x − 3), so x = (4·(−1) − 6·3)/(4 − 6) = 11, which is not 3 or −1, so it is allowed.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, 'This forgets to distribute 4 and 6 across the factors, writing 4x + 1 = 6x − 3. Each constant must multiply the whole factor, giving 11.' from version_ins;
-- apprecalc-mcq-b9-h-1.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.9-a', 'mcq', 'describe the unbounded behavior of a rational function at a vertical asymptote from an even-multiplicity factor and at o', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x − 1)/[(x + 2)²(x − 3)]. Which statement correctly describes the graph of f near its two vertical asymptotes?', null, md5('apprecalc-mcq-b9-h-1.9-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) → ∞ as x → −2 from either side, and f(x) → −∞ as x → 3 from the left', true, 'Correct: Near x = −2: the squared factor is positive, and the other factors have the sign of (−2 − 1)/(−2 − 3) = −3/−5, which is positive, so f → ∞ from both sides. Near x = 3 from the left: numerator sign +, squared factor +, and (x − 3) is negative, so f → −∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) → −∞ as x → −2 from either side, and f(x) → −∞ as x → 3 from the left', false, 'This treats the squared factor as if it changed sign across x = −2, so the sign at that asymptote is reversed. A squared factor is positive on both sides, so the sign there is set by the remaining factors and f → ∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) → ∞ as x → −2 from either side, and f(x) → ∞ as x → 3 from the left', false, 'This gives the right behavior at x = −2 but takes the sign on the wrong side of x = 3. The factor (x − 3) is negative on the left, which makes f → −∞ there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) → −∞ as x → −2 from either side, and f(x) → ∞ as x → 3 from the left', false, 'This reverses the sign of f at both asymptotes, as if the numerator (x − 1) were evaluated with the wrong sign. At x = −2 the sign is positive and just left of x = 3 it is negative.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-h-1.8-a','apprecalc-mcq-b9-sv-h-1.8-a-v1','apprecalc-mcq-b9-sv-h-1.8-a-v2','apprecalc-mcq-b9-sv-h-1.8-a-v3','apprecalc-mcq-b9-h-1.8-b','apprecalc-mcq-b9-sv-h-1.8-b-v1','apprecalc-mcq-b9-sv-h-1.8-b-v2','apprecalc-mcq-b9-sv-h-1.8-b-v3','apprecalc-mcq-b9-h-1.9-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b9-h-1.8-a','apprecalc-mcq-b9-sv-h-1.8-a-v1','apprecalc-mcq-b9-sv-h-1.8-a-v2','apprecalc-mcq-b9-sv-h-1.8-a-v3','apprecalc-mcq-b9-h-1.8-b','apprecalc-mcq-b9-sv-h-1.8-b-v1','apprecalc-mcq-b9-sv-h-1.8-b-v2','apprecalc-mcq-b9-sv-h-1.8-b-v3','apprecalc-mcq-b9-h-1.9-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
