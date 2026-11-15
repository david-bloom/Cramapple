begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.6-b-v1','apprecalc-mcq-b7-sv-h-2.6-b-v2','apprecalc-mcq-b7-sv-h-2.6-b-v3','apprecalc-mcq-b7-h-2.7-a','apprecalc-mcq-b7-sv-h-2.7-a-v1','apprecalc-mcq-b7-sv-h-2.7-a-v2','apprecalc-mcq-b7-sv-h-2.7-a-v3','apprecalc-mcq-b7-h-2.7-b','apprecalc-mcq-b7-sv-h-2.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apprecalc-mcq-b7-sv-h-2.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.6-b-v1', 'mcq', 'choose between linear, quadratic and exponential models from a table by checking first differences, second differences a (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives values of a function f at equally spaced inputs: x = 0, 1, 2, 3, 4, 5 and f(x) = 5, 23, 37, 47, 53, 55, respectively. Which model is best supported by these values?', null, md5('apprecalc-mcq-b7-sv-h-2.6-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An exponential model, because the first differences are not constant', false, 'The first differences (18, 14, 10, 6, 2) are not constant, so the model is not linear, but that does not make it exponential. An exponential model needs a constant ratio between consecutive outputs, and these ratios (4.60, 1.61, 1.27, 1.13, 1.04) are not constant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A linear model, because the outputs always increase', false, 'This does not show the first differences are constant, which is what a linear model needs. The first differences are 18, 14, 10, 6, 2, so the rate of change is different from one step to the next.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A quadratic model, because the second differences are constant at −4', true, 'Correct: First differences: 18, 14, 10, 6, 2. Second differences: −4, −4, −4, −4, all equal to −4. The ratios of consecutive outputs (4.60, 1.61, 1.27, 1.13, 1.04) are not constant, so the data match a quadratic, not an exponential or linear model.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An exponential model with growth factor 23/5, because f(1)/f(0) = 23/5', false, 'This uses only the first ratio. For an exponential model every ratio of consecutive outputs must equal the same factor, but f(2)/f(1) = 37/23, which is different from 23/5.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.6-b-v2', 'mcq', 'choose between linear, quadratic and exponential models from a table by checking first differences, second differences a (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives values of a function f at equally spaced inputs: x = 0, 1, 2, 3, 4, 5 and f(x) = 13, 4, 1, 4, 13, 28, respectively. Which model is best supported by these values?', null, md5('apprecalc-mcq-b7-sv-h-2.6-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An exponential model, because the first differences are not constant', false, 'The first differences (−9, −3, 3, 9, 15) are not constant, so the model is not linear, but that does not make it exponential. An exponential model needs a constant ratio between consecutive outputs, and these ratios (0.31, 0.25, 4.00, 3.25, 2.15) are not constant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A linear model, because the average rate of change from x = 0 to x = 5, which is 3, is positive', false, 'This does not show the first differences are constant, which is what a linear model needs. The first differences are −9, −3, 3, 9, 15, so the rate of change is different from one step to the next.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A quadratic model, because the second differences are constant at 6', true, 'Correct: First differences: −9, −3, 3, 9, 15. Second differences: 6, 6, 6, 6, all equal to 6. The ratios of consecutive outputs (0.31, 0.25, 4.00, 3.25, 2.15) are not constant, so the data match a quadratic, not an exponential or linear model.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An exponential model with growth factor 4/13, because f(1)/f(0) = 4/13', false, 'This uses only the first ratio. For an exponential model every ratio of consecutive outputs must equal the same factor, but f(2)/f(1) = 1/4, which is different from 4/13.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.6-b-v3', 'mcq', 'choose between linear, quadratic and exponential models from a table by checking first differences, second differences a (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives values of a function f at equally spaced inputs: x = 0, 1, 2, 3, 4, 5 and f(x) = 30, 29, 26, 21, 14, 5, respectively. Which model is best supported by these values?', null, md5('apprecalc-mcq-b7-sv-h-2.6-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An exponential model, because the first differences are not constant', false, 'The first differences (−1, −3, −5, −7, −9) are not constant, so the model is not linear, but that does not make it exponential. An exponential model needs a constant ratio between consecutive outputs, and these ratios (0.97, 0.90, 0.81, 0.67, 0.36) are not constant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A linear model, because the outputs always decrease', false, 'This does not show the first differences are constant, which is what a linear model needs. The first differences are −1, −3, −5, −7, −9, so the rate of change is different from one step to the next.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An exponential model with growth factor 29/30, because f(1)/f(0) = 29/30', false, 'This uses only the first ratio. For an exponential model every ratio of consecutive outputs must equal the same factor, but f(2)/f(1) = 26/29, which is different from 29/30.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A quadratic model, because the second differences are constant at −2', true, 'Correct: First differences: −1, −3, −5, −7, −9. Second differences: −2, −2, −2, −2, all equal to −2. The ratios of consecutive outputs (0.97, 0.90, 0.81, 0.67, 0.36) are not constant, so the data match a quadratic, not an exponential or linear model.' from version_ins;
-- apprecalc-mcq-b7-h-2.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.7-a', 'mcq', 'find the domain of a composition by requiring the inner output to lie in the outer function''s domain, rather than using ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = √(x − 3) and g(x) = x² − 7. What is the domain of the composition f(g(x))?', null, md5('apprecalc-mcq-b7-h-2.7-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x ≥ 3', false, 'This is the domain of f alone. The inputs to f are the outputs g(x) = x² − 7, so the condition is x² − 7 ≥ 3, not x ≥ 3. For example x = −4 gives g(−4) = 9, and f(9) = √6 is defined, but −4 is not in this set.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x ≥ √10', false, 'This solves x² − 7 ≥ 3 but keeps only the positive solutions. The inequality x² ≥ 10 also holds for x ≤ −√10, and x = −4 is a valid input since g(−4) = 9 and f(9) = √6 is defined.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x ≤ −√7 or x ≥ √7', false, 'This requires only g(x) ≥ 0, ignoring the −3 inside f. The condition is g(x) − 3 ≥ 0. For example x = 3 gives g(3) = 2, and f(2) = √(−1) is undefined, but 3 is in this set.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x ≤ −√10 or x ≥ √10', true, 'Correct: f(g(x)) = √(x² − 7 − 3) = √(x² − 10), which requires x² ≥ 10, so x ≤ −√10 or x ≥ √10. For x = −4, g(−4) = 9 and f(9) = √6 is defined.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.7-a-v1', 'mcq', 'find the domain of a composition by requiring the inner output to lie in the outer function''s domain, rather than using  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 1/(x − 5) and g(x) = x² + 1. What is the domain of the composition f(g(x))?', null, md5('apprecalc-mcq-b7-sv-h-2.7-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'All real x except x = 5', false, 'This is the excluded value for f alone. The input to f is g(x) = x² + 1, so the excluded x-values are those where x² + 1 = 5. For example x = 2 gives g(2) = 5, and f(5) is undefined, but 2 is allowed by this set.' from version_ins
union all select gen_random_uuid(), id, 'B', 'All real x except x = 2 and x = −2', true, 'Correct: f(g(x)) = 1/(x² + 1 − 5) = 1/(x² − 4), which is undefined exactly when x² = 4, so x = 2 or x = −2. All other real x work.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All real x except x = 2', false, 'This finds x² + 1 = 5 but keeps only the positive solution. The equation x² = 4 also has x = −2, and g(−2) = 5 makes f(g(−2)) undefined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All real x except x = √5 and x = −√5', false, 'This solves x² = 5, forgetting the +1 in g. The excluded values are those where x² + 1 = 5, so x² = 4, and g(√5) = 6 gives f(6) = 1, which is defined.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.7-a-v2', 'mcq', 'find the domain of a composition by requiring the inner output to lie in the outer function''s domain, rather than using  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = √(6 − x) and g(x) = x² − 10. What is the domain of the composition f(g(x))?', null, md5('apprecalc-mcq-b7-sv-h-2.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x ≤ 6', false, 'This is the domain of f alone. The input to f is g(x) = x² − 10, so the condition is x² − 10 ≤ 6. For example x = 5 gives g(5) = 15, and f(15) = √(−9) is undefined, but 5 is in this set.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x ≤ −4 or x ≥ 4', false, 'This reverses the inequality. The condition 6 − (x² − 10) ≥ 0 gives x² ≤ 16, so x lies between −4 and 4. For example x = 0 gives g(0) = −10 and f(−10) = √16 = 4, which is defined.' from version_ins
union all select gen_random_uuid(), id, 'C', '−4 ≤ x ≤ 4', true, 'Correct: f(g(x)) = √(6 − (x² − 10)) = √(16 − x²), which requires x² ≤ 16, so −4 ≤ x ≤ 4. For x = 3, g(3) = −1 and f(−1) = √7 is defined.' from version_ins
union all select gen_random_uuid(), id, 'D', '−√6 ≤ x ≤ √6', false, 'This solves x² ≤ 6, forgetting the −10 inside g. The condition is 6 − (x² − 10) ≥ 0, so x² ≤ 16. For example x = 3 gives g(3) = −1 and f(−1) = √7, which is defined, but 3 is outside this set.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.7-a-v3', 'mcq', 'find the domain of a composition by requiring the inner output to lie in the outer function''s domain, rather than using  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = √(x + 4) and g(x) = x² − 13. What is the domain of the composition f(g(x))?', null, md5('apprecalc-mcq-b7-sv-h-2.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x ≤ −3 or x ≥ 3', true, 'Correct: f(g(x)) = √(x² − 13 + 4) = √(x² − 9), which requires x² ≥ 9, so x ≤ −3 or x ≥ 3. For x = 3, g(3) = −4 and f(−4) = 0 is defined.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x ≥ −4', false, 'This is the domain of f alone. The input to f is g(x) = x² − 13, so the condition is x² − 13 ≥ −4. For example x = 0 gives g(0) = −13, and f(−13) = √(−9) is undefined, but 0 is in this set.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3 ≤ x ≤ 3', false, 'This reverses the inequality. The condition x² − 13 + 4 ≥ 0 gives x² ≥ 9, which holds for x ≤ −3 or x ≥ 3. For example x = 4 gives g(4) = 3 and f(3) = √7, which is defined, but 4 is outside this set.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x ≤ −√13 or x ≥ √13', false, 'This requires only g(x) ≥ 0, ignoring the +4 inside f. The condition is g(x) + 4 ≥ 0. For example x = 3 gives g(3) = −4 and f(−4) = √0 = 0, which is defined, but 3 is outside this set.' from version_ins;
-- apprecalc-mcq-b7-h-2.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.7-b', 'mcq', 'solve an equation that sets two different compositions of the same functions equal, expanding the square of a linear exp', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 2x + 8 and g(x) = x². For which real values of x is f(g(x)) = g(f(x))?', null, md5('apprecalc-mcq-b7-h-2.7-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = −14 and x = −2', true, 'Correct: f(g(x)) = 2x² + 8 and g(f(x)) = (2x + 8)² = 4x² + 32x + 64. Setting them equal: 2x² + 32x + 56 = 0, which factors to give x = −14 or x = −2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is no real value of x', false, 'This drops the middle term when squaring, writing (f(x))² as 4x² + 64. Then f(g(x)) = g(f(x)) reduces to 2x² + 8 = 4x² + 64, which has no real solution, but the correct expansion is (2x + 8)² = 4x² + 32x + 64.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 2 and x = 14', false, 'This has the right size of solutions with the wrong signs. The equation is 2x² + 32x + 56 = 0, and substituting x = 2 gives 128 instead of 0, so these are not solutions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = −16 and x = 0', false, 'This squares the linear expression as 4x² + 32x + 8, using 8 instead of 8² = 64 for the last term. Then the equation is 2x² + 32x = 0, whose solutions are x = 0 and x = −16.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.7-b-v1', 'mcq', 'solve an equation that sets two different compositions of the same functions equal, expanding the square of a linear exp (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 3x + 6 and g(x) = x². For which real values of x is f(g(x)) = g(f(x))?', null, md5('apprecalc-mcq-b7-sv-h-2.7-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is no real value of x', false, 'This drops the middle term when squaring, writing (f(x))² as 9x² + 36. Then f(g(x)) = g(f(x)) reduces to 3x² + 6 = 9x² + 36, which has no real solution, but the correct expansion is (3x + 6)² = 9x² + 36x + 36.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 1 and x = 5', false, 'This has the right size of solutions with the wrong signs. The equation is 6x² + 36x + 30 = 0, and substituting x = 1 gives 72 instead of 0, so these are not solutions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = −5 and x = −1', true, 'Correct: f(g(x)) = 3x² + 6 and g(f(x)) = (3x + 6)² = 9x² + 36x + 36. Setting them equal: 6x² + 36x + 30 = 0, which factors to give x = −5 or x = −1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = −6 and x = 0', false, 'This squares the linear expression as 9x² + 36x + 6, using 6 instead of 6² = 36 for the last term. Then the equation is 6x² + 36x = 0, whose solutions are x = 0 and x = −6.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.6-b-v1','apprecalc-mcq-b7-sv-h-2.6-b-v2','apprecalc-mcq-b7-sv-h-2.6-b-v3','apprecalc-mcq-b7-h-2.7-a','apprecalc-mcq-b7-sv-h-2.7-a-v1','apprecalc-mcq-b7-sv-h-2.7-a-v2','apprecalc-mcq-b7-sv-h-2.7-a-v3','apprecalc-mcq-b7-h-2.7-b','apprecalc-mcq-b7-sv-h-2.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b7-sv-h-2.6-b-v1','apprecalc-mcq-b7-sv-h-2.6-b-v2','apprecalc-mcq-b7-sv-h-2.6-b-v3','apprecalc-mcq-b7-h-2.7-a','apprecalc-mcq-b7-sv-h-2.7-a-v1','apprecalc-mcq-b7-sv-h-2.7-a-v2','apprecalc-mcq-b7-sv-h-2.7-a-v3','apprecalc-mcq-b7-h-2.7-b','apprecalc-mcq-b7-sv-h-2.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
