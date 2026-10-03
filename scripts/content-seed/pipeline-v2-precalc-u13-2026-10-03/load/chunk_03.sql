begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-009-v2','apprecalc-mcq-sv-009-v3','apprecalc-mcq-sv-011-v1','apprecalc-mcq-sv-011-v2','apprecalc-mcq-sv-011-v3','apprecalc-mcq-sv-012-v1','apprecalc-mcq-sv-012-v2','apprecalc-mcq-sv-012-v3','apprecalc-mcq-sv-013-v1','apprecalc-mcq-sv-013-v2','apprecalc-mcq-sv-013-v3','apprecalc-mcq-sv-014-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-009-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-009-v2', 'mcq', 'Logarithmic equation with a coefficient inside', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution of log₅(2x) = 2?', null, md5('apprecalc-mcq-sv-009-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 25/2', true, 'Rewrite in exponential form: 2x = 5² = 25, so x = 25/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 5', false, 'Computes 5² as 5·2 = 10, then divides by 2: x = 10/2 = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 1', false, 'Sets 2x equal to the exponent 2 instead of 5², giving x = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 25', false, 'Rewrites correctly as 2x = 25 but forgets to divide by 2.' from version_ins;
-- apprecalc-mcq-sv-009-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-009-v3', 'mcq', 'Logarithmic equation requiring a product and a rejection', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution of log₄(x) + log₄(x − 6) = 2?', null, md5('apprecalc-mcq-sv-009-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 8', true, 'By the product property, log₄(x(x − 6)) = 2, so x(x − 6) = 4² = 16. Then x² − 6x − 16 = 0, (x − 8)(x + 2) = 0, so x = 8 or x = −2. Since x = −2 makes log₄(x) undefined, only x = 8 works. Check: log₄ 8 + log₄ 2 = 3/2 + 1/2 = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 3 + √11', false, 'Uses the product property but sets the argument equal to the exponent 2: x² − 6x = 2, so x = 3 ± √11, taking the positive root.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 8 or x = −2', false, 'Solves the quadratic correctly but does not reject x = −2, for which log₄(−2) is not defined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 11', false, 'Adds the arguments instead of multiplying them: x + (x − 6) = 16, so 2x − 6 = 16 and x = 11.' from version_ins;
-- apprecalc-mcq-sv-011-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-011-v1', 'mcq', 'Solve an exponential equation in base 3', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If 3^(4x + 2) = 20, then x equals', null, md5('apprecalc-mcq-sv-011-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(log₃20 + 2)/4', false, 'Adds 2 instead of subtracting it when isolating 4x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₃5 − 2', false, 'Divides the argument by 4, giving log₃(20/4) = log₃5, and then subtracts 2; coefficients on x cannot be removed by dividing the argument.' from version_ins
union all select gen_random_uuid(), id, 'C', '(log₃20)/4 − 2', false, 'Subtracts 2 from the right side but divides only log₃20 by 4, not the whole expression log₃20 − 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(log₃20 − 2)/4', true, 'Taking log base 3 gives 4x + 2 = log₃20. Subtract 2 and then divide by 4: x = (log₃20 − 2)/4.' from version_ins;
-- apprecalc-mcq-sv-011-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-011-v2', 'mcq', 'Solve with a shift in the exponent', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If 7^(x − 4) = 30, then x equals', null, md5('apprecalc-mcq-sv-011-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'log₇34', false, 'Adds 4 to the argument, 30 + 4 = 34, instead of adding 4 to the logarithm.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₇30 − 4', false, 'Subtracts 4 instead of adding it when isolating x.' from version_ins
union all select gen_random_uuid(), id, 'C', '4 log₇30', false, 'Multiplies by 4 instead of adding 4 to both sides.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 + log₇30', true, 'Taking log base 7 gives x − 4 = log₇30, so x = 4 + log₇30.' from version_ins;
-- apprecalc-mcq-sv-011-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-011-v3', 'mcq', 'Exponential equation with a coefficient and natural log', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If 2e^(3x) = 14, then x equals', null, md5('apprecalc-mcq-sv-011-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(ln 14)/3', false, 'Drops the factor 2, treating the equation as e^(3x) = 14, so 3x = ln 14. Check: x = (ln 14)/3 gives 2e^(ln 14) = 28, not 14.' from version_ins
union all select gen_random_uuid(), id, 'B', '3 ln 7', false, 'Multiplies ln 7 by 3 instead of dividing by 3 when solving 3x = ln 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '(ln 7)/3', true, 'Divide by 2 first: e^(3x) = 7. Then 3x = ln 7, so x = (ln 7)/3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ln(7/3)', false, 'Removes the 3 by dividing the argument, giving ln(7/3); the 3 multiplies x in the exponent and must come out as a divisor of ln 7.' from version_ins;
-- apprecalc-mcq-sv-012-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-012-v1', 'mcq', 'Random residuals, logarithmic fit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student fits a logarithmic model to a data set and graphs the residuals (actual output minus predicted output). The residual plot shows points scattered above and below zero with no visible pattern. This most strongly suggests that', null, md5('apprecalc-mcq-sv-012-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'the logarithmic model is a reasonable fit for the data', true, 'Residuals that are a mix of positive and negative values with no pattern indicate the model has captured the trend of the data; the leftover differences look like random variation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'the logarithmic model overestimates the output at every input', false, 'Overestimating at every input would make every residual (actual minus predicted) negative. The plot has points both above and below zero, so the model sometimes overestimates and sometimes underestimates.' from version_ins
union all select gen_random_uuid(), id, 'C', 'the logarithmic model is inappropriate because some residuals are not zero', false, 'Nonzero residuals are expected with real data. A poor model is signaled by a systematic pattern in the residuals, and this plot shows none.' from version_ins
union all select gen_random_uuid(), id, 'D', 'every data point lies exactly on the logarithmic curve', false, 'If every point were exactly on the curve, every residual would be 0. The plot shows residuals above and below zero, so some are positive and some negative.' from version_ins;
-- apprecalc-mcq-sv-012-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-012-v2', 'mcq', 'Sign pattern for a linear fit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear model is fit to 12 data points, and the residuals (actual minus predicted) are plotted against x. The first four residuals are negative, the next four are positive, and the last four are negative. This most strongly suggests that', null, md5('apprecalc-mcq-sv-012-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'the data have curvature that a linear model does not capture', true, 'A residual sign pattern of negative, positive, negative across the whole range is structured. It shows the line sits above the data at both ends and below it in the middle, which indicates the data curve away from a straight line.' from version_ins
union all select gen_random_uuid(), id, 'B', 'the slope of the linear model should be zero', false, 'The pattern points to curvature the line cannot follow. Nothing in a negative-positive-negative residual pattern implies the best line should be horizontal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'the data are exactly linear apart from a few outliers', false, 'Outliers would show up as a few isolated large residuals. Here the sign changes in a systematic run across the whole range (4 negative, 4 positive, 4 negative), which is a pattern, not isolated outliers.' from version_ins
union all select gen_random_uuid(), id, 'D', 'the data are decreasing as x increases', false, 'Residuals compare the data to the fitted line; they do not show the direction of the data. Increasing data and decreasing data can both produce this negative-positive-negative pattern, so it gives no evidence about direction.' from version_ins;
-- apprecalc-mcq-sv-012-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-012-v3', 'mcq', 'Comparing two residual plots', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two models are fit to the same data set. The residual plot for Model A shows points scattered randomly above and below zero. The residual plot for Model B shows residuals that are positive for small inputs, negative for middle inputs, and positive for large inputs. Which statement is best supported?', null, md5('apprecalc-mcq-sv-012-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Neither model is appropriate because neither has all residuals equal to zero', false, 'Real data almost never give all-zero residuals. Appropriateness is judged by whether the residuals show a pattern, and Model A''s do not.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Model A is more appropriate because its residuals show no pattern', true, 'Random scatter means Model A has captured the relationship. Model B''s positive-negative-positive pattern means it leaves systematic structure unexplained.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The models cannot be compared without a correlation coefficient r', false, 'The residual plots themselves are direct evidence about whether each model form is appropriate. A high r can coexist with a clear residual pattern, so r is not needed to see that Model B leaves structure unexplained.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Model B is more appropriate because its residuals follow a clear pattern', false, 'A clear residual pattern means the model is missing part of the relationship; it is evidence against the model, not for it.' from version_ins;
-- apprecalc-mcq-sv-013-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-013-v1', 'mcq', 'Isotope half-life fraction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of an isotope has half-life 4 years. What fraction of the sample remains after 20 years?', null, md5('apprecalc-mcq-sv-013-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/32', true, '20 years is 20/4 = 5 half-lives, so the fraction remaining is (1/2)^5 = 1/32.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/10', false, 'Multiplies the 5 half-lives by 2 to get the denominator, 5·2 = 10, instead of computing 2^5 = 32.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/25', false, 'Squares the number of half-lives, 5² = 25, instead of raising 2 to that power, 2^5 = 32.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/5', false, 'Uses the number of half-lives, 20/4 = 5, as the denominator instead of raising 1/2 to the 5th power. The correct value is (1/2)^5 = 1/32, not 1/5.' from version_ins;
-- apprecalc-mcq-sv-013-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-013-v2', 'mcq', 'Drug concentration percent', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drug''s concentration in the blood is cut in half every 6 hours. What percent of the original concentration remains after 24 hours?', null, md5('apprecalc-mcq-sv-013-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.25%', true, '24 hours is 24/6 = 4 half-lives, so the fraction is (1/2)^4 = 1/16 = 0.0625, or 6.25%.' from version_ins
union all select gen_random_uuid(), id, 'B', '12.5%', false, 'Counts only 24/6 − 1 = 3 half-lives, giving (1/2)^3 = 1/8 = 12.5%.' from version_ins
union all select gen_random_uuid(), id, 'C', '25%', false, 'Uses the number of half-lives, 4, as the denominator: 1/4 = 25%. The correct fraction is (1/2)^4 = 1/16.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.125%', false, 'Counts five half-lives by listing the times 0, 6, 12, 18, 24 as five periods, giving (1/2)^5 = 1/32 = 3.125%.' from version_ins;
-- apprecalc-mcq-sv-013-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-013-v3', 'mcq', 'Mass remaining of a sample', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A radioactive sample has mass 80 mg and loses half of its mass every 8 days. How many milligrams of the sample remain after 24 days?', null, md5('apprecalc-mcq-sv-013-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '26.7 mg', false, 'Divides the starting mass by the number of half-lives: 80/3 ≈ 26.7 mg, instead of by 2^3 = 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '10 mg', true, '24 days is 24/8 = 3 half-lives, so the mass is 80·(1/2)^3 = 80/8 = 10 mg.' from version_ins
union all select gen_random_uuid(), id, 'C', '56 mg', false, 'Subtracts the elapsed days from the starting mass: 80 − 24 = 56 mg, treating the decay as linear.' from version_ins
union all select gen_random_uuid(), id, 'D', '20 mg', false, 'Applies only two halvings: 80·(1/2)^2 = 20 mg. Three half-lives have passed.' from version_ins;
-- apprecalc-mcq-sv-014-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-014-v1', 'mcq', 'Domain of a base-3 logarithm', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the domain of g(x) = log₃(9 − x²)?', null, md5('apprecalc-mcq-sv-014-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3 < x < 3', true, 'The argument must be positive: 9 − x² > 0, so x² < 9, which gives −3 < x < 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3 ≤ x ≤ 3', false, 'Includes the endpoints, but at x = 3 the argument is 9 − 9 = 0, and log₃(0) is undefined. The inequality must be strict.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x < −3 or x > 3', false, 'Solves 9 − x² < 0 (the wrong direction). For x = 4 the argument is 9 − 16 = −7, which is negative, so log₃ is undefined there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x < 3', false, 'Reduces x² < 9 to x < 3 and forgets the lower bound. For x = −5 the argument is 9 − 25 = −16, which is negative, so −5 is not in the domain.' from version_ins;
commit;
