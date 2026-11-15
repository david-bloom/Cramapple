begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-4.1-A','APSTATS-MCQ-SV-H-4.1-A-v1','APSTATS-MCQ-SV-H-4.1-A-v2','APSTATS-MCQ-SV-H-4.1-A-v3','APSTATS-MCQ-H-4.1-B','APSTATS-MCQ-SV-H-4.1-B-v1','APSTATS-MCQ-SV-H-4.1-B-v2','APSTATS-MCQ-SV-H-4.1-B-v3','APSTATS-MCQ-H-4.2-A'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- APSTATS-MCQ-H-4.1-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.1-A', 'mcq', 'Standardize a sample mean', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The lifetimes of a certain brand of battery have a strongly right-skewed distribution with mean 120 hours and standard deviation 24 hours. A random sample of 64 batteries is selected. What is the approximate probability that the sample mean lifetime is greater than 125 hours?', null, md5('APSTATS-MCQ-H-4.1-A'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.42, using a normal model for individual lifetimes with a standard deviation of 24 hours.', false, 'This treats x-bar like a single battery and uses the population standard deviation, so the spread is far too large.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Essentially 0, using a standard deviation of 24/64 = 0.375 hours for the sample mean.', false, 'Divided by n instead of the square root of n, which makes the standard deviation of x-bar too small.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 0.05, using a normal model for the sample mean with a standard deviation of 24/√64 = 3 hours.', true, 'Correct: SD of x-bar = 24/8 = 3; z = (125 - 120)/3 = 1.67; P(Z > 1.67) = 0.048. With n = 64 the Central Limit Theorem justifies the normal model.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It cannot be approximated with a normal model because the population is strongly skewed.', false, 'The Central Limit Theorem makes the sampling distribution of x-bar approximately normal for a large sample even when the population is skewed.' from version_ins;
-- APSTATS-MCQ-SV-H-4.1-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.1-A-v1', 'mcq', 'Standardize a sample mean (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Scores on a placement test are normally distributed with mean 50 and standard deviation 9. A random sample of 9 students is selected. What is the probability that the sample mean score is below 48?', null, md5('APSTATS-MCQ-SV-H-4.1-A-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.41, using a standard deviation of 9 for the sample mean.', false, 'This uses the standard deviation of individual scores, not the standard deviation of the sample mean.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 0.02, using a standard deviation of 9/9 = 1 for the sample mean.', false, 'Divided by n instead of the square root of n, so the standard deviation of x-bar is too small.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It cannot be found because the sample size is less than 30.', false, 'The sample size matters only when the population is not normal, and here the population is normal so x-bar is normal for any n.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 0.25, using a standard deviation of 9/√9 = 3 for the sample mean.', true, 'Correct: SD of x-bar = 9/3 = 3; z = (48 - 50)/3 = -0.67; P(Z < -0.67) = 0.252. The population is normal, so x-bar is exactly normal for any n.' from version_ins;
-- APSTATS-MCQ-SV-H-4.1-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.1-A-v2', 'mcq', 'Standardize a sample mean (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The weights of cereal boxes from a production line have mean 120 grams and standard deviation 24 grams, and the distribution is strongly skewed. A random sample of 100 boxes is selected. What is the approximate probability that the sample mean weight is between 118 and 122 grams?', null, md5('APSTATS-MCQ-SV-H-4.1-A-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.60, using a normal model with a standard deviation of 24/√100 = 2.4 grams.', true, 'Correct: SD of x-bar = 2.4; z = ±2/2.4 = ±0.83; P(-0.83 < Z < 0.83) = 0.595.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 0.07, using a standard deviation of 24 grams for the sample mean.', false, 'This uses the population standard deviation, which describes individual boxes, not the spread of sample means.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 1.00, using a standard deviation of 24/100 = 0.24 grams.', false, 'Divided by n instead of the square root of n, making the standard deviation of x-bar much too small and the probability nearly 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 0.68, because 118 and 122 are within one standard deviation of 120.', false, 'The 68% rule applies to one standard deviation of the sampling distribution, which is 2.4 grams, not the 24 grams of the population.' from version_ins;
-- APSTATS-MCQ-SV-H-4.1-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.1-A-v3', 'mcq', 'Standardize a sample mean (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The weights of cereal boxes from a production line have mean 120 grams and standard deviation 24 grams, and the distribution is strongly right-skewed. A random sample of only 20 boxes is selected. Which statement about finding P(x-bar > 125) is correct?', null, md5('APSTATS-MCQ-SV-H-4.1-A-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.18, because x-bar is approximately normal with a standard deviation of 24/√20 = 5.4 grams.', false, 'The standard deviation of 5.4 is right, but the normal shape is not justified for n = 20 from a strongly skewed population.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A normal calculation is not justified, because the sample is small and the population is strongly skewed.', true, 'Correct: with n = 20 and strong skew, the Central Limit Theorem does not yet justify a normal model, so any normal probability, including 0.18 from a standard deviation of 5.4, is not trustworthy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 0.42, because x-bar has a standard deviation of 24 grams.', false, 'This also uses the wrong standard deviation, the population value, for the sample mean.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Essentially 0, because x-bar has a standard deviation of 24/20 = 1.2 grams.', false, 'Divided by n instead of the square root of n, which gives a standard deviation far too small.' from version_ins;
-- APSTATS-MCQ-H-4.1-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.1-B', 'mcq', 'Center and spread of the sampling distribution of x-bar', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population has mean 40 and standard deviation 12. Ana takes many random samples of size 25 and Ben takes many random samples of size 100, and each records the sample mean from every sample. Which statement is correct?', null, md5('APSTATS-MCQ-H-4.1-B'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both sets of sample means have a standard deviation of 12, because sample means vary as much as individual values do.', false, 'The standard deviation of x-bar is the population value divided by the square root of n, so it is smaller than 12.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ben''s sample means vary less: their standard deviation is 1.2, compared with 2.4 for Ana''s, and both sets are centered at 40.', true, 'Correct: SD for Ana = 12/5 = 2.4; SD for Ben = 12/10 = 1.2; both sampling distributions have mean 40 because x-bar is unbiased.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ana''s sample means have a standard deviation of 0.48 and Ben''s have 0.12, because the standard deviation is divided by n.', false, 'Divided by n instead of the square root of n.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ben''s sample means are centered closer to 40 than Ana''s, because a larger sample reduces bias.', false, 'X-bar is unbiased at every sample size, so both distributions are centered at 40 and a larger n only reduces the spread.' from version_ins;
-- APSTATS-MCQ-SV-H-4.1-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.1-B-v1', 'mcq', 'Center and spread of the sampling distribution of x-bar (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population has standard deviation 15. A researcher currently uses samples of size 25, so the standard deviation of the sample mean is 3. How large must the samples be to cut the standard deviation of the sample mean to 1.5?', null, md5('APSTATS-MCQ-SV-H-4.1-B-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '50', false, 'Doubling n only divides the standard deviation by √2, not by 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '100', true, 'Correct: 15/√n = 1.5 gives √n = 10, so n = 100. Halving the standard deviation requires four times the sample size.' from version_ins
union all select gen_random_uuid(), id, 'C', '75', false, 'Tripling n does not halve the standard deviation, since the spread falls with the square root of n.' from version_ins
union all select gen_random_uuid(), id, 'D', '625', false, 'Squared the original n, but halving the spread needs a factor of 4 on n, not n squared.' from version_ins;
-- APSTATS-MCQ-SV-H-4.1-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.1-B-v2', 'mcq', 'Center and spread of the sampling distribution of x-bar (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Scores on a standardized test are normally distributed with mean 50 and standard deviation 10. Compare P(one randomly chosen student scores above 54) with P(the mean of 25 randomly chosen students is above 54). Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-4.1-B-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both probabilities are about 0.34, because the mean and the individual have the same distribution.', false, 'The mean of 25 scores varies much less than one score, so extreme means are rarer than extreme individuals.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The first is about 0.02 and the second is about 0.34, because larger samples make high values more likely.', false, 'This reverses the two probabilities; averaging makes a value 4 above the mean harder to reach, not easier.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both probabilities are about 0.02, because averaging only changes the center.', false, 'Averaging does not change the center, but it shrinks the spread, which changes the probability for the individual value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The first is about 0.34 and the second is about 0.02, because the sample mean has a standard deviation of 2.', true, 'Correct: individual z = 4/10 = 0.4, P = 0.345; sample mean z = 4/(10/5) = 2.0, P = 0.023.' from version_ins;
-- APSTATS-MCQ-SV-H-4.1-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.1-B-v3', 'mcq', 'Center and spread of the sampling distribution of x-bar (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Repeated random samples of size 36 are taken from a population with mean 80 and standard deviation 18. Which statement describes the sampling distribution of the sample mean?', null, md5('APSTATS-MCQ-SV-H-4.1-B-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Its mean is 80 and its standard deviation is 18.', false, 'The standard deviation of x-bar is not the population standard deviation; it is divided by the square root of n.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Its mean is 13.3 and its standard deviation is 3.', false, 'The center of x-bar equals the population mean and is not divided by anything.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Its mean is 80 and its standard deviation is 3.', true, 'Correct: mean of x-bar = 80; SD = 18/√36 = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Its mean is 80 and its standard deviation is 0.5.', false, 'Divided 18 by n = 36 instead of by its square root.' from version_ins;
-- APSTATS-MCQ-H-4.2-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.2-A', 'mcq', 't interval for a mean from summary statistics', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher measures the nightly sleep, in hours, of a random sample of 9 college students. The sample values are roughly symmetric with no outliers, and the sample has mean 6.8 hours and standard deviation 1.2 hours. For df = 8, t* = 2.306 at 95% confidence. What is the 95% confidence interval for the population mean?', null, md5('APSTATS-MCQ-H-4.2-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(5.88, 7.72)', true, 'Correct: SE = 1.2/√9 = 0.4; margin = 2.306 x 0.4 = 0.92; interval 6.8 ± 0.92 = (5.88, 7.72).' from version_ins
union all select gen_random_uuid(), id, 'B', '(4.03, 9.57)', false, 'Used the standard deviation instead of the standard error, so the margin is far too wide.' from version_ins
union all select gen_random_uuid(), id, 'C', '(6.02, 7.58)', false, 'Used z* = 1.96 in place of the t critical value, which understates the margin for a sample this small.' from version_ins
union all select gen_random_uuid(), id, 'D', '(6.49, 7.11)', false, 'Divided s by n instead of the square root of n when finding the standard error.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-4.1-A','APSTATS-MCQ-SV-H-4.1-A-v1','APSTATS-MCQ-SV-H-4.1-A-v2','APSTATS-MCQ-SV-H-4.1-A-v3','APSTATS-MCQ-H-4.1-B','APSTATS-MCQ-SV-H-4.1-B-v1','APSTATS-MCQ-SV-H-4.1-B-v2','APSTATS-MCQ-SV-H-4.1-B-v3','APSTATS-MCQ-H-4.2-A']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-H-4.1-A','APSTATS-MCQ-SV-H-4.1-A-v1','APSTATS-MCQ-SV-H-4.1-A-v2','APSTATS-MCQ-SV-H-4.1-A-v3','APSTATS-MCQ-H-4.1-B','APSTATS-MCQ-SV-H-4.1-B-v1','APSTATS-MCQ-SV-H-4.1-B-v2','APSTATS-MCQ-SV-H-4.1-B-v3','APSTATS-MCQ-H-4.2-A']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
