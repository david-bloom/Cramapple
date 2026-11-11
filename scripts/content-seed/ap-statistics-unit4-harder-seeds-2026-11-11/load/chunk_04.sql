begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-4.5-A-v3','APSTATS-MCQ-H-4.6-A','APSTATS-MCQ-SV-H-4.6-A-v1','APSTATS-MCQ-SV-H-4.6-A-v2','APSTATS-MCQ-SV-H-4.6-A-v3','APSTATS-MCQ-H-4.7-A','APSTATS-MCQ-SV-H-4.7-A-v1','APSTATS-MCQ-SV-H-4.7-A-v2','APSTATS-MCQ-SV-H-4.7-A-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-4.5-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.5-A-v3', 'mcq', 't test for a mean: statistic, p-value, conclusion (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 36 observations has mean 102.5 and standard deviation 15. To test H0: μ = 100 versus Ha: μ ≠ 100, which is the correct result and conclusion at the 5% level?', null, md5('APSTATS-MCQ-SV-H-4.5-A-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 1.00 and p ≈ 0.16, so there is convincing evidence that the mean differs from 100.', false, 'Used one tail for a two-sided alternative, and a p of 0.16 would still not be below 0.05.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 1.00 and p ≈ 0.32, so there is not convincing evidence that the mean differs from 100.', true, 'Correct: SE = 15/√36 = 2.5; t = 2.5/2.5 = 1.00; df = 35; two-sided p = 0.324.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 1.00 and p ≈ 0.32, so the data show that the mean equals 100.', false, 'Failing to reject does not prove the null; it only means the data are consistent with it.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 6.00 and p < 0.001, so there is convincing evidence that the mean differs from 100.', false, 'Divided s by n instead of √n, which inflates the t statistic.' from version_ins;
-- APSTATS-MCQ-H-4.6-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.6-A', 'mcq', 'Sampling distribution of a difference of sample means', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Population 1 has mean 70 and standard deviation 12, and population 2 has mean 64 and standard deviation 10. An independent random sample of 36 is taken from population 1 and a random sample of 25 from population 2. What are the mean and standard deviation of the sampling distribution of x-bar1 - x-bar2?', null, md5('APSTATS-MCQ-H-4.6-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean 6, standard deviation 2.83.', true, 'Correct: mean = 70 - 64 = 6; SD = sqrt(144/36 + 100/25) = sqrt(4 + 4) = 2.83.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean 6, standard deviation 2.0.', false, 'This pools everything as if both samples were one combined group instead of adding the two variances.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mean 6, standard deviation 8.', false, 'This is the variance 4 + 4 and was never square-rooted.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean 6, standard deviation 4.', false, 'Added the two standard errors, 2 + 2, instead of adding the variances and taking the square root.' from version_ins;
-- APSTATS-MCQ-SV-H-4.6-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.6-A-v1', 'mcq', 'Sampling distribution of a difference of sample means (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Population 1 has mean 70 and standard deviation 12, and population 2 has mean 64 and standard deviation 10. Independent random samples of 36 and 25 are taken, respectively, and both sampling distributions are approximately normal. What is the probability that the sample mean from population 1 is greater than the sample mean from population 2?', null, md5('APSTATS-MCQ-SV-H-4.6-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.98, because x-bar1 - x-bar2 has mean 6 and standard deviation 2.83.', true, 'Correct: P(x-bar1 - x-bar2 > 0) = P(Z > -6/2.83) = P(Z > -2.12) = 0.983.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 0.50, because the samples are the same kind of random sample.', false, 'The two means differ by 6 and the standard deviation of the difference is only 2.83, so a result above 0 is far from a coin flip.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 0.65, using the population standard deviations without dividing by the sample sizes.', false, 'This uses the spread of individual values, sqrt(144 + 100) = 15.6, instead of the spread of the sample means.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 0.02, because the difference is more likely to be negative.', false, 'This reverses the direction; the mean difference is positive, so the sample difference is likely to be positive.' from version_ins;
-- APSTATS-MCQ-SV-H-4.6-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.6-A-v2', 'mcq', 'Sampling distribution of a difference of sample means (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two independent random samples, each of size 30, are taken from two populations. If both sample sizes are doubled to 60 and the population standard deviations stay the same, what happens to the standard deviation of x-bar1 - x-bar2?', null, md5('APSTATS-MCQ-SV-H-4.6-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is cut in half.', false, 'Halving the standard deviation would require four times the sample sizes, not two times.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It stays the same, since the population standard deviations did not change.', false, 'The sample sizes appear in the standard deviation of the difference, so changing them changes it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It doubles.', false, 'Larger samples reduce the spread of the difference; they do not increase it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is multiplied by about 0.71, which is 1/√2.', true, 'Correct: SD = sqrt(σ1²/n1 + σ2²/n2); doubling both n divides the inside by 2, so SD is multiplied by 1/√2 = 0.71.' from version_ins;
-- APSTATS-MCQ-SV-H-4.6-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.6-A-v3', 'mcq', 'Sampling distribution of a difference of sample means (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two independent random samples of sizes 12 and 14 are taken from two strongly right-skewed populations. Which statement is correct about using a normal model for x-bar1 - x-bar2?', null, md5('APSTATS-MCQ-SV-H-4.6-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is justified, because the samples are independent and random.', false, 'Independence and randomness are needed, but they do not make a small sample from a skewed population approximately normal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is justified, because the combined sample size is more than 25.', false, 'The sample sizes are checked separately for each sample; adding them does not help.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is justified, because the difference of two skewed distributions is always symmetric.', false, 'Subtracting two skewed distributions does not remove the skewness of each sample mean.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is not justified, because both samples are small and both populations are strongly skewed.', true, 'Correct: with small samples from strongly skewed populations, the Central Limit Theorem does not yet apply to either sample mean.' from version_ins;
-- APSTATS-MCQ-H-4.7-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.7-A', 'mcq', 'Two-sample t interval', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Independent random samples of 30 students from each of two schools give the following test scores. School 1 has mean 82 and standard deviation 10; school 2 has mean 76 and standard deviation 12. Both samples are roughly symmetric. Using t* = 2.00, which is the 95% confidence interval for μ1 - μ2?', null, md5('APSTATS-MCQ-H-4.7-A'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(-2.03, 14.03)', false, 'Added the two separate standard errors, 1.83 + 2.19, instead of adding the variances and taking the square root.' from version_ins
union all select gen_random_uuid(), id, 'B', '(-25.24, 37.24)', false, 'Forgot to divide by the sample sizes inside the square root, so the standard error is far too large.' from version_ins
union all select gen_random_uuid(), id, 'C', '(-11.70, -0.30)', false, 'Subtracted in the wrong order; the question asks for μ1 - μ2 with school 1 first.' from version_ins
union all select gen_random_uuid(), id, 'D', '(0.30, 11.70)', true, 'Correct: SE = sqrt(100/30 + 144/30) = 2.85; margin = 2.00 x 2.85 = 5.70; interval 6 ± 5.70 = (0.30, 11.70).' from version_ins;
-- APSTATS-MCQ-SV-H-4.7-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.7-A-v1', 'mcq', 'Two-sample t interval (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Independent random samples give these results: sample 1 has n = 40, mean 15.2, standard deviation 3.0; sample 2 has n = 35, mean 13.9, standard deviation 2.4. Both are roughly symmetric. Using t* = 1.68, which is the 90% confidence interval for μ1 - μ2?', null, md5('APSTATS-MCQ-SV-H-4.7-A-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0.65, 1.95)', false, 'Added the two variances over n but did not take the square root, so the margin is too small.' from version_ins
union all select gen_random_uuid(), id, 'B', '(-2.35, -0.25)', false, 'Subtracted in the wrong order, giving the interval for μ2 - μ1.' from version_ins
union all select gen_random_uuid(), id, 'C', '(0.25, 2.35)', true, 'Correct: SE = sqrt(9/40 + 5.76/35) = 0.624; margin = 1.68 x 0.624 = 1.05; interval 1.3 ± 1.05 = (0.25, 2.35).' from version_ins
union all select gen_random_uuid(), id, 'D', '(-0.18, 2.78)', false, 'Added the two standard errors instead of adding the variances first, which widens the interval across 0.' from version_ins;
-- APSTATS-MCQ-SV-H-4.7-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.7-A-v2', 'mcq', 'Two-sample t interval (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for μA - μB, where μA and μB are the mean completion times in seconds for two tasks, is (2.1, 7.9). Which interpretation is correct?', null, md5('APSTATS-MCQ-SV-H-4.7-A-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 95% of individual A times are 2.1 to 7.9 seconds greater than individual B times.', false, 'The interval is about the difference in means, not about individual times.' from version_ins
union all select gen_random_uuid(), id, 'B', 'We are 95% confident that the mean time for A is greater than the mean time for B by between 2.1 and 7.9 seconds.', true, 'Correct: the interval estimates the difference in population means, μA - μB.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a 95% probability that the difference in sample means is between 2.1 and 7.9 seconds.', false, 'The sample difference is known, and the interval is a statement about the population difference.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mean time for A is between 2.1 and 7.9 seconds.', false, 'The interval is for the difference between the two means, not for the mean of A.' from version_ins;
-- APSTATS-MCQ-SV-H-4.7-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.7-A-v3', 'mcq', 'Two-sample t interval (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for μ1 - μ2 is (-1.2, 5.6). What are the difference in sample means and the margin of error?', null, md5('APSTATS-MCQ-SV-H-4.7-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Difference 2.2 and margin of error 6.8.', false, 'Used the full width of the interval as the margin of error instead of half the width.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Difference 3.4 and margin of error 2.2.', false, 'Swapped the center and the half-width, treating the margin of error as the difference in sample means.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Difference 2.2 and margin of error 3.4.', true, 'Correct: the center is (-1.2 + 5.6)/2 = 2.2 and the half-width is (5.6 - (-1.2))/2 = 3.4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Difference 5.6 and margin of error 1.2.', false, 'Used the endpoints as the difference and margin of error.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-4.5-A-v3','APSTATS-MCQ-H-4.6-A','APSTATS-MCQ-SV-H-4.6-A-v1','APSTATS-MCQ-SV-H-4.6-A-v2','APSTATS-MCQ-SV-H-4.6-A-v3','APSTATS-MCQ-H-4.7-A','APSTATS-MCQ-SV-H-4.7-A-v1','APSTATS-MCQ-SV-H-4.7-A-v2','APSTATS-MCQ-SV-H-4.7-A-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-4.5-A-v3','APSTATS-MCQ-H-4.6-A','APSTATS-MCQ-SV-H-4.6-A-v1','APSTATS-MCQ-SV-H-4.6-A-v2','APSTATS-MCQ-SV-H-4.6-A-v3','APSTATS-MCQ-H-4.7-A','APSTATS-MCQ-SV-H-4.7-A-v1','APSTATS-MCQ-SV-H-4.7-A-v2','APSTATS-MCQ-SV-H-4.7-A-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
