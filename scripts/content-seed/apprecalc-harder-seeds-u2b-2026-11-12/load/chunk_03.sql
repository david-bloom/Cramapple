begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.11-a-v2','apprecalc-mcq-b8-sv-h-2.11-a-v3','apprecalc-mcq-b8-h-2.11-b','apprecalc-mcq-b8-sv-h-2.11-b-v1','apprecalc-mcq-b8-sv-h-2.11-b-v2','apprecalc-mcq-b8-sv-h-2.11-b-v3','apprecalc-mcq-b8-h-2.12-a','apprecalc-mcq-b8-sv-h-2.12-a-v1','apprecalc-mcq-b8-sv-h-2.12-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apprecalc-mcq-b8-sv-h-2.11-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.11-a-v2', 'mcq', 'describe increasing or decreasing behavior, concavity, and the vertical asymptote of a transformed logarithmic function  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement correctly describes h(x) on its domain, where h(x) = 2·ln(5 − x) + 1?', null, md5('apprecalc-mcq-b8-sv-h-2.11-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is increasing and concave down, with vertical asymptote x = 5.', false, 'As x increases, 5 − x decreases, so ln(5 − x) falls; the function cannot increase, even though ln itself is an increasing function.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is decreasing and concave up, with vertical asymptote x = 5.', false, 'The second derivative is −2/(5 − x)², which is negative, so the graph is concave down; the reflection in the input does not flip the concavity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is decreasing and concave down, with vertical asymptote x = −5.', false, 'The input 5 − x is zero at x = 5, so the vertical asymptote is x = 5; the function is defined for x < 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is decreasing and concave down, with vertical asymptote x = 5.', true, 'Correct: 5 − x > 0 gives x < 5 and asymptote x = 5. h′(x) = −2/(5 − x) < 0 and h″(x) = −2/(5 − x)² < 0 there.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.11-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.11-a-v3', 'mcq', 'describe increasing or decreasing behavior, concavity, and the vertical asymptote of a transformed logarithmic function  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement correctly describes k(x) on its domain, where k(x) = log_(1/2)(x − 2) + 3?', null, md5('apprecalc-mcq-b8-sv-h-2.11-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is increasing and concave down, with vertical asymptote x = 2.', false, 'A base between 0 and 1 gives a decreasing logarithm, since log_(1/2)(x) = −log₂(x); it is not increasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is decreasing and concave up, with vertical asymptote x = 2.', true, 'Correct: log_(1/2)(u) = −log₂(u), so k decreases and is concave up on x > 2, with vertical asymptote x = 2 from x − 2 > 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is decreasing and concave down, with vertical asymptote x = 2.', false, 'Because log_(1/2)(x) = −log₂(x), the concavity flips along with the direction: it is concave up, not concave down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is decreasing and concave up, with vertical asymptote x = −2.', false, 'The input is x − 2, which is zero at x = 2, not x = −2, so the vertical asymptote is at x = 2.' from version_ins;
-- apprecalc-mcq-b8-h-2.11-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.11-b', 'mcq', 'interpret the coefficient of a logarithmic model as a change per multiplication of the input, and find the factor that p', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A loudness meter produces a calibration reading modeled by g(x) = 5 + 4log₂(x) for x > 0. By what factor must x be multiplied for g(x) to increase by 10?', null, md5('apprecalc-mcq-b8-h-2.11-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/2', false, 'This treats 10/4 = 5/2 as the multiplier of x. Multiplying x by a factor k adds 4·log₂(k) to the output, so 4log₂(k) = 10 must be solved for k.' from version_ins
union all select gen_random_uuid(), id, 'B', '4√2', true, 'Correct: g(kx) − g(x) = 4log₂(k) = 10, so log₂(k) = 5/2 and k = 2^(5/2) = 4√2 ≈ 5.66.' from version_ins
union all select gen_random_uuid(), id, 'C', '256', false, 'This computes 2^10 ÷ 4. The exponent must be divided by 4 first: log₂(k) = 5/2, so k = 2^(5/2), not 2^10 ÷ 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1024', false, 'This sets log₂(k) = 10 and ignores the coefficient 4. The increase is 4log₂(k), so log₂(k) = 5/2, not 10.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.11-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.11-b-v1', 'mcq', 'interpret the coefficient of a logarithmic model as a change per multiplication of the input, and find the factor that p (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor produces a sensor value modeled by h(x) = 2 + 4log₃(x) for x > 0. By what factor must x be multiplied for h(x) to increase by 6?', null, md5('apprecalc-mcq-b8-sv-h-2.11-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3√3', true, 'Correct: h(kx) − h(x) = 4log₃(k) = 6, so log₃(k) = 3/2 and k = 3^(3/2) = 3√3 ≈ 5.20.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/2', false, 'This treats 6/4 = 3/2 as the multiplier of x. Multiplying x by a factor k adds 4·log₃(k) to the output, so 4log₃(k) = 6 must be solved for k.' from version_ins
union all select gen_random_uuid(), id, 'C', '729/4', false, 'This computes 3^6 ÷ 4. The exponent must be divided by 4 first: log₃(k) = 3/2, so k = 3^(3/2), not 3^6 ÷ 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '729', false, 'This sets log₃(k) = 6 and ignores the coefficient 4. The increase is 4log₃(k), so log₃(k) = 3/2, not 6.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.11-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.11-b-v2', 'mcq', 'interpret the coefficient of a logarithmic model as a change per multiplication of the input, and find the factor that p (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rating system produces a rating modeled by R(x) = 7 + 6log₂(x) for x > 0. By what factor must x be multiplied for R(x) to increase by 9?', null, md5('apprecalc-mcq-b8-sv-h-2.11-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/2', false, 'This treats 9/6 = 3/2 as the multiplier of x. Multiplying x by a factor k adds 6·log₂(k) to the output, so 6log₂(k) = 9 must be solved for k.' from version_ins
union all select gen_random_uuid(), id, 'B', '2√2', true, 'Correct: R(kx) − R(x) = 6log₂(k) = 9, so log₂(k) = 3/2 and k = 2^(3/2) = 2√2 ≈ 2.83.' from version_ins
union all select gen_random_uuid(), id, 'C', '256/3', false, 'This computes 2^9 ÷ 6. The exponent must be divided by 6 first: log₂(k) = 3/2, so k = 2^(3/2), not 2^9 ÷ 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '512', false, 'This sets log₂(k) = 9 and ignores the coefficient 6. The increase is 6log₂(k), so log₂(k) = 3/2, not 9.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.11-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.11-b-v3', 'mcq', 'interpret the coefficient of a logarithmic model as a change per multiplication of the input, and find the factor that p (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A receiver produces a signal level modeled by S(x) = 1 + 2log₁₀(x) for x > 0. By what factor must x be multiplied for S(x) to increase by 5?', null, md5('apprecalc-mcq-b8-sv-h-2.11-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/2', false, 'This treats 5/2 = 5/2 as the multiplier of x. Multiplying x by a factor k adds 2·log₁₀(k) to the output, so 2log₁₀(k) = 5 must be solved for k.' from version_ins
union all select gen_random_uuid(), id, 'B', '50000', false, 'This computes 10^5 ÷ 2. The exponent must be divided by 2 first: log₁₀(k) = 5/2, so k = 10^(5/2), not 10^5 ÷ 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '100√10', true, 'Correct: S(kx) − S(x) = 2log₁₀(k) = 5, so log₁₀(k) = 5/2 and k = 10^(5/2) = 100√10 ≈ 316.23.' from version_ins
union all select gen_random_uuid(), id, 'D', '100000', false, 'This sets log₁₀(k) = 5 and ignores the coefficient 2. The increase is 2log₁₀(k), so log₁₀(k) = 5/2, not 5.' from version_ins;
-- apprecalc-mcq-b8-h-2.12-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.12-a', 'mcq', 'decide which logarithm-property rewrite is valid for every x in the domain of the original expression, recognizing that ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the expression log₂(x²). Which equation is true for every real number x for which log₂(x²) is defined?', null, md5('apprecalc-mcq-b8-h-2.12-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'log₂(x²) = 2log₂(x)', false, 'At x = −3, log₂(x²) = log₂(9) is defined, but log₂(−3) does not exist, so 2log₂(x) cannot match for negative x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₂(x²) = 2log₂|x|', true, 'Correct: The power rule needs |x| because x² and x⁴ are positive even when x is negative. Test points: negative x defined on the left but not for a plain log(x); the absolute-value form agrees at x = -3 and x = 8.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₂(x²) = (log₂ x)²', false, 'At x = 8, log₂(64) = 6, but (log₂ 8)² = 9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₂(x²) = log₂(2x)', false, 'At x = 8, log₂(64) = 6, but log₂(16) = 4.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.12-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.12-a-v1', 'mcq', 'decide which logarithm-property rewrite is valid for every x in the domain of the original expression, recognizing that  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the expression log₃(x⁴). Which equation is true for every real number x for which log₃(x⁴) is defined?', null, md5('apprecalc-mcq-b8-sv-h-2.12-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'log₃(x⁴) = 4log₃(x)', false, 'At x = −2, log₃(x⁴) = log₃(16) is defined, but log₃(−2) does not exist, so 4log₃(x) cannot match for negative x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₃(x⁴) = (log₃ x)⁴', false, 'At x = 27, log₃(27⁴) = 12, but (log₃ 27)⁴ = 81.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₃(x⁴) = log₃(4x)', false, 'At x = 27, log₃(27⁴) = 12, but log₃(108) ≈ 4.27.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₃(x⁴) = 4log₃|x|', true, 'Correct: The power rule needs |x| because x² and x⁴ are positive even when x is negative. Test points: negative x defined on the left but not for a plain log(x); the absolute-value form agrees at x = -2 and x = 27.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.12-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.12-a-v2', 'mcq', 'decide which logarithm-property rewrite is valid for every x in the domain of the original expression, recognizing that  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the expression log₂((x − 1)²). Which equation is true for every real number x for which log₂((x − 1)²) is defined?', null, md5('apprecalc-mcq-b8-sv-h-2.12-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'log₂((x − 1)²) = 2log₂|x − 1|', true, 'Correct: The power rule needs |x| because x² and x⁴ are positive even when x is negative. Test points: negative x defined on the left but not for a plain log(x); the absolute-value form agrees at x = -1 and x = 9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₂((x − 1)²) = 2log₂(x − 1)', false, 'At x = −1, log₂((x − 1)²) = log₂(4) is defined, but log₂(−2) does not exist, so 2log₂(x − 1) cannot match for x < 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₂((x − 1)²) = (log₂(x − 1))²', false, 'At x = 9, log₂(64) = 6, but (log₂ 8)² = 9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₂((x − 1)²) = log₂(2x − 2)', false, 'At x = 9, log₂(64) = 6, but log₂(16) = 4.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.11-a-v2','apprecalc-mcq-b8-sv-h-2.11-a-v3','apprecalc-mcq-b8-h-2.11-b','apprecalc-mcq-b8-sv-h-2.11-b-v1','apprecalc-mcq-b8-sv-h-2.11-b-v2','apprecalc-mcq-b8-sv-h-2.11-b-v3','apprecalc-mcq-b8-h-2.12-a','apprecalc-mcq-b8-sv-h-2.12-a-v1','apprecalc-mcq-b8-sv-h-2.12-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b8-sv-h-2.11-a-v2','apprecalc-mcq-b8-sv-h-2.11-a-v3','apprecalc-mcq-b8-h-2.11-b','apprecalc-mcq-b8-sv-h-2.11-b-v1','apprecalc-mcq-b8-sv-h-2.11-b-v2','apprecalc-mcq-b8-sv-h-2.11-b-v3','apprecalc-mcq-b8-h-2.12-a','apprecalc-mcq-b8-sv-h-2.12-a-v1','apprecalc-mcq-b8-sv-h-2.12-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
