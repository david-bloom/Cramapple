begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.11-a-v3','apprecalc-mcq-b9-h-1.11-b','apprecalc-mcq-b9-sv-h-1.11-b-v1','apprecalc-mcq-b9-sv-h-1.11-b-v2','apprecalc-mcq-b9-sv-h-1.11-b-v3','apprecalc-mcq-b9-h-1.12-a','apprecalc-mcq-b9-sv-h-1.12-a-v1','apprecalc-mcq-b9-sv-h-1.12-a-v2','apprecalc-mcq-b9-sv-h-1.12-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apprecalc-mcq-b9-sv-h-1.11-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.11-a-v3', 'mcq', 'work backward from an equivalent quotient-plus-remainder form to the polynomial numerator and combine its coefficients. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x ≠ 4, the expression (x² + bx + c)/(x − 4) is equivalent to x + 5 − 3/(x − 4), where b and c are constants. What is the value of b + c?', null, md5('apprecalc-mcq-b9-sv-h-1.11-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '26', false, 'This expands (x + 5)(x + 4) − 3, using the wrong sign on the divisor''s constant. The divisor is (x − 4), so the product to expand is (x + 5)(x − 4) − 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−19', false, 'This multiplies the quotient by the divisor but leaves out the remainder term 3. The remainder over (x − 4) is part of the expression, so it must be added to the constant term, which gives c = −23.' from version_ins
union all select gen_random_uuid(), id, 'C', '−16', false, 'This applies the opposite sign to the remainder term when clearing the fraction. Since the expression contains − 3/(x − 4), the product must be adjusted by −3, making c = −23.' from version_ins
union all select gen_random_uuid(), id, 'D', '−22', true, 'Correct: Multiply by (x − 4): x² + bx + c = (x + 5)(x − 4) − 3 = x² + x − 23. So b = 1, c = −23, and b + c = −22.' from version_ins;
-- apprecalc-mcq-b9-h-1.11-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.11-b', 'mcq', 'factor a cubic numerator by grouping to see that a rational function equals a line with holes, and find the holes'' heigh', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider f(x) = (x³ + 2x² − 9x − 18)/(x² − 9). Which statement correctly describes the graph of f?', null, md5('apprecalc-mcq-b9-h-1.11-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is the line y = x + 2 with vertical asymptotes at x = 3 and x = −3.', false, 'This treats the zeros of the denominator as vertical asymptotes. The factor x² − 9 also appears in the numerator and cancels, so those x-values are holes, not asymptotes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is the line y = x + 2 with holes at (3, 5) and (−3, −1).', true, 'Correct: Grouping gives x³ + 2x² − 9x − 18 = (x + 2)(x² − 9), so f(x) = x + 2 for x ≠ ±3. The cancelled factors give holes at heights 5 and −1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is the line y = x + 2 with holes at (3, 1) and (−3, −5).', false, 'This finds the holes at the right x-values but computes their heights using the wrong sign on 2. Substituting x = 3 and x = −3 into x + 2 gives 5 and −1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is the line y = x + 2 with no breaks, so f is defined for every real x.', false, 'This cancels the common factor and then forgets the original domain restriction. The original expression is undefined at x = 3 and x = −3, so the line has a hole at each of those values.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.11-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.11-b-v1', 'mcq', 'factor a cubic numerator by grouping to see that a rational function equals a line with holes, and find the holes'' heigh (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x³ − x² − 16x + 16)/(x² − 16). Which statement correctly describes the graph of f?', null, md5('apprecalc-mcq-b9-sv-h-1.11-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is the line y = x − 1 with vertical asymptotes at x = 4 and x = −4.', false, 'This treats the zeros of the denominator as vertical asymptotes. The factor x² − 16 also appears in the numerator and cancels, so those x-values are holes, not asymptotes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is the line y = x − 1 with holes at (4, 5) and (−4, −3).', false, 'This finds the holes at the right x-values but computes their heights using the wrong sign on 1. Substituting x = 4 and x = −4 into x − 1 gives 3 and −5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is the line y = x − 1 with holes at (4, 3) and (−4, −5).', true, 'Correct: Grouping gives x³ − x² − 16x + 16 = (x − 1)(x² − 16), so f(x) = x − 1 for x ≠ ±4. The cancelled factors give holes at heights 3 and −5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is the line y = x − 1 with no breaks, so f is defined for every real x.', false, 'This cancels the common factor and then forgets the original domain restriction. The original expression is undefined at x = 4 and x = −4, so the line has a hole at each of those values.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.11-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.11-b-v2', 'mcq', 'factor a cubic numerator by grouping to see that a rational function equals a line with holes, and find the holes'' heigh (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x³ + 3x² − 4x − 12)/(x² − 4). Which statement correctly describes the graph of f?', null, md5('apprecalc-mcq-b9-sv-h-1.11-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is the line y = x + 3 with vertical asymptotes at x = 2 and x = −2.', false, 'This treats the zeros of the denominator as vertical asymptotes. The factor x² − 4 also appears in the numerator and cancels, so those x-values are holes, not asymptotes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is the line y = x + 3 with holes at (2, 5) and (−2, 1).', true, 'Correct: Grouping gives x³ + 3x² − 4x − 12 = (x + 3)(x² − 4), so f(x) = x + 3 for x ≠ ±2. The cancelled factors give holes at heights 5 and 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is the line y = x + 3 with holes at (2, −1) and (−2, −5).', false, 'This finds the holes at the right x-values but computes their heights using the wrong sign on 3. Substituting x = 2 and x = −2 into x + 3 gives 5 and 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is the line y = x + 3 with no breaks, so f is defined for every real x.', false, 'This cancels the common factor and then forgets the original domain restriction. The original expression is undefined at x = 2 and x = −2, so the line has a hole at each of those values.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.11-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.11-b-v3', 'mcq', 'factor a cubic numerator by grouping to see that a rational function equals a line with holes, and find the holes'' heigh (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider f(x) = (x³ − 2x² − 25x + 50)/(x² − 25). Which statement correctly describes the graph of f?', null, md5('apprecalc-mcq-b9-sv-h-1.11-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is the line y = x − 2 with holes at (5, 3) and (−5, −7).', true, 'Correct: Grouping gives x³ − 2x² − 25x + 50 = (x − 2)(x² − 25), so f(x) = x − 2 for x ≠ ±5. The cancelled factors give holes at heights 3 and −7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is the line y = x − 2 with vertical asymptotes at x = 5 and x = −5.', false, 'This treats the zeros of the denominator as vertical asymptotes. The factor x² − 25 also appears in the numerator and cancels, so those x-values are holes, not asymptotes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is the line y = x − 2 with holes at (5, 7) and (−5, −3).', false, 'This finds the holes at the right x-values but computes their heights using the wrong sign on 2. Substituting x = 5 and x = −5 into x − 2 gives 3 and −7.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is the line y = x − 2 with no breaks, so f is defined for every real x.', false, 'This cancels the common factor and then forgets the original domain restriction. The original expression is undefined at x = 5 and x = −5, so the line has a hole at each of those values.' from version_ins;
-- apprecalc-mcq-b9-h-1.12-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.12-a', 'mcq', 'find the image of a point under a combined horizontal and vertical transformation by solving the input rule for x and ap', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of a function f is shifted and stretched to produce another function. The graph of f contains the point (4, 4). The function g is defined by g(x) = −2f(3x − 5) + 1. Which point must lie on the graph of g?', null, md5('apprecalc-mcq-b9-h-1.12-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(7, −7)', false, 'This feeds 4 through the input rule, computing 3·4 − 5. The input of f is 3x − 5, so the x-coordinate of g is the x that makes 3x − 5 equal 4, namely 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−1/3, −7)', false, 'This adds −5 to 4 when undoing the input change, instead of subtracting it. Solving 3x − 5 = 4 for x gives 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(3, −10)', false, 'This applies the vertical shift before the vertical stretch, computing (−2)(4 + 1). The output rule multiplies f by −2 first and then adds 1, so the output is −7.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3, −7)', true, 'Correct: A point on g needs 3x − 5 = 4, so x = (4 + 5)/3 = 3; the output is (−2)·4 + 1 = −7.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.12-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.12-a-v1', 'mcq', 'find the image of a point under a combined horizontal and vertical transformation by solving the input rule for x and ap (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider a function f and a function g that is built from it. The graph of f contains the point (5, −1). The function g is defined by g(x) = 3f(2x + 1) − 4. Which point must lie on the graph of g?', null, md5('apprecalc-mcq-b9-sv-h-1.12-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(11, −7)', false, 'This feeds 5 through the input rule, computing 2·5 + 1. The input of f is 2x + 1, so the x-coordinate of g is the x that makes 2x + 1 equal 5, namely 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '(2, −7)', true, 'Correct: A point on g needs 2x + 1 = 5, so x = (5 − 1)/2 = 2; the output is 3·(−1) − 4 = −7.' from version_ins
union all select gen_random_uuid(), id, 'C', '(3, −7)', false, 'This adds 1 to 5 when undoing the input change, instead of subtracting it. Solving 2x + 1 = 5 for x gives 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(2, −15)', false, 'This applies the vertical shift before the vertical stretch, computing 3(−1 − 4). The output rule multiplies f by 3 first and then adds −4, so the output is −7.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.12-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.12-a-v2', 'mcq', 'find the image of a point under a combined horizontal and vertical transformation by solving the input rule for x and ap (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f models a quantity, and g is a transformed version of it. The graph of f contains the point (6, 3). The function g is defined by g(x) = −f(4x − 6) + 5. Which point must lie on the graph of g?', null, md5('apprecalc-mcq-b9-sv-h-1.12-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(3, 2)', true, 'Correct: A point on g needs 4x − 6 = 6, so x = (6 + 6)/4 = 3; the output is (−1)·3 + 5 = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '(18, 2)', false, 'This feeds 6 through the input rule, computing 4·6 − 6. The input of f is 4x − 6, so the x-coordinate of g is the x that makes 4x − 6 equal 6, namely 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(0, 2)', false, 'This adds −6 to 6 when undoing the input change, instead of subtracting it. Solving 4x − 6 = 6 for x gives 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3, −8)', false, 'This applies the vertical shift before the vertical stretch, computing (−1)(3 + 5). The output rule multiplies f by −1 first and then adds 5, so the output is 2.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.12-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.12-a-v3', 'mcq', 'find the image of a point under a combined horizontal and vertical transformation by solving the input rule for x and ap (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a function and let g be defined from f. The graph of f contains the point (−1, 5). The function g is defined by g(x) = 2f(−2x + 3) + 4. Which point must lie on the graph of g?', null, md5('apprecalc-mcq-b9-sv-h-1.12-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(5, 14)', false, 'This feeds −1 through the input rule, computing (−2)·−1 + 3. The input of f is −2x + 3, so the x-coordinate of g is the x that makes −2x + 3 equal −1, namely 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '(2, 14)', true, 'Correct: A point on g needs −2x + 3 = −1, so x = (−1 − 3)/(−2) = 2; the output is 2·5 + 4 = 14.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−1, 14)', false, 'This adds 3 to −1 when undoing the input change, instead of subtracting it. Solving −2x + 3 = −1 for x gives 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(2, 18)', false, 'This applies the vertical shift before the vertical stretch, computing 2(5 + 4). The output rule multiplies f by 2 first and then adds 4, so the output is 14.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.11-a-v3','apprecalc-mcq-b9-h-1.11-b','apprecalc-mcq-b9-sv-h-1.11-b-v1','apprecalc-mcq-b9-sv-h-1.11-b-v2','apprecalc-mcq-b9-sv-h-1.11-b-v3','apprecalc-mcq-b9-h-1.12-a','apprecalc-mcq-b9-sv-h-1.12-a-v1','apprecalc-mcq-b9-sv-h-1.12-a-v2','apprecalc-mcq-b9-sv-h-1.12-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b9-sv-h-1.11-a-v3','apprecalc-mcq-b9-h-1.11-b','apprecalc-mcq-b9-sv-h-1.11-b-v1','apprecalc-mcq-b9-sv-h-1.11-b-v2','apprecalc-mcq-b9-sv-h-1.11-b-v3','apprecalc-mcq-b9-h-1.12-a','apprecalc-mcq-b9-sv-h-1.12-a-v1','apprecalc-mcq-b9-sv-h-1.12-a-v2','apprecalc-mcq-b9-sv-h-1.12-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
