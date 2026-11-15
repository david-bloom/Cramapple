begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-4.8-A','APSTATS-MCQ-SV-H-4.8-A-v1','APSTATS-MCQ-SV-H-4.8-A-v2','APSTATS-MCQ-SV-H-4.8-A-v3','APSTATS-MCQ-H-4.9-A','APSTATS-MCQ-SV-H-4.9-A-v1','APSTATS-MCQ-SV-H-4.9-A-v2','APSTATS-MCQ-SV-H-4.9-A-v3','APSTATS-MCQ-H-4.10-A'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- APSTATS-MCQ-H-4.8-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.8-A', 'mcq', 'Claim from an interval for a difference of means', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a randomized experiment, a 95% confidence interval for μtreatment - μcontrol, the difference in mean weight loss in kilograms, is (-0.4, 6.8). A manager claims the treatment increases mean weight loss. Which conclusion is justified?', null, md5('APSTATS-MCQ-H-4.8-A'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The treatment increases weight loss, because most of the interval is positive.', false, 'The proportion of the interval that is positive does not matter; if 0 is in the interval, no difference is plausible.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The treatment has no effect on weight loss.', false, 'Failing to find convincing evidence of a difference does not prove there is no difference.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is not convincing evidence of a difference, because 0 is in the interval.', true, 'Correct: the interval contains 0, so no difference is a plausible value and the claim of an increase is not justified at this confidence level.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is a 95% chance that the true difference is positive.', false, 'The interval does not give the probability that the true difference is positive.' from version_ins;
-- APSTATS-MCQ-SV-H-4.8-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.8-A-v1', 'mcq', 'Claim from an interval for a difference of means (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for μA - μB, the difference in mean reaction time in milliseconds between two groups, is (1.2, 5.4). Which conclusion is justified?', null, md5('APSTATS-MCQ-SV-H-4.8-A-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The difference in the sample means is exactly 5.4 milliseconds.', false, 'The interval gives a range, and the sample difference is its midpoint, 3.3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Every individual in group A is slower than every individual in group B.', false, 'The interval concerns the difference in means, not each individual.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is no convincing evidence of a difference, because the interval is narrow.', false, 'The width of the interval does not decide the conclusion; whether it contains 0 does.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is convincing evidence that group A has a greater mean reaction time than group B.', true, 'Correct: the interval lies entirely above 0, so μA - μB > 0 at the 95% level.' from version_ins;
-- APSTATS-MCQ-SV-H-4.8-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.8-A-v2', 'mcq', 'Claim from an interval for a difference of means (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a study of two teaching methods, a 95% confidence interval for the mean score under method 1 is (62.0, 70.0) and a 95% confidence interval for the mean score under method 2 is (68.0, 76.0). The two samples have the same size and similar variability, and the intervals overlap. A student concludes there is no convincing evidence of a difference. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-4.8-A-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The student is correct, because overlapping intervals always mean no difference.', false, 'Overlapping separate intervals do not prove there is no difference, because the standard error of the difference is smaller than the sum of the two standard errors.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student is wrong, because method 2 has a higher mean in the samples.', false, 'A larger sample mean in one group is not enough; the decision depends on the interval for the difference.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The conclusion is not justified, because the interval for the difference must be examined, and it can exclude 0 even when the separate intervals overlap.', true, 'Correct: each separate interval has margin 4, so each standard error is about 2.04; the difference in sample means is 72 - 66 = 6, and the standard error of the difference is sqrt(2.04² + 2.04²) = 2.89, so the interval for the difference is about 6 ± 1.96(2.89) = (0.3, 11.7), which excludes 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The student is correct, because two 95% intervals together give 90% confidence.', false, 'The confidence level of the difference interval is set by its own construction, not by combining two intervals.' from version_ins;
-- APSTATS-MCQ-SV-H-4.8-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.8-A-v3', 'mcq', 'Claim from an interval for a difference of means (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for μ1 - μ2 is (-5.1, -0.9). A researcher tests H0: μ1 - μ2 = 0 versus Ha: μ1 - μ2 ≠ 0 at the 5% level. Which conclusion follows from the interval?', null, md5('APSTATS-MCQ-SV-H-4.8-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fail to reject H0, because the interval includes negative values.', false, 'Negative values are not a reason to retain H0; what matters is whether 0 is in the interval.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Reject H0, and there is convincing evidence that μ1 is greater than μ2.', false, 'A negative difference μ1 - μ2 means the second mean is larger.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fail to reject H0, because the interval is entirely on one side.', false, 'An interval that lies entirely on one side of 0 is evidence against H0, not for it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Reject H0, and there is convincing evidence that μ2 is greater than μ1.', true, 'Correct: the interval excludes 0 and is entirely negative, so μ1 - μ2 < 0, which means μ2 is greater than μ1.' from version_ins;
-- APSTATS-MCQ-H-4.9-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.9-A', 'mcq', 'Two-sample or paired setup and hypotheses', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher randomly assigns 40 volunteers to two groups of 20. One group uses a new study app and the other uses an old one, and each volunteer''s weekly study time is recorded. The researcher wants to know whether the new app leads to a lower mean study time than the old app. Which setup is appropriate, where μN and μO are the true mean study times?', null, md5('APSTATS-MCQ-H-4.9-A'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A paired t test, because there are two sets of study times.', false, 'A paired test requires that each observation in one group be linked to one in the other, which is not the case when volunteers are randomly split.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A two-sample t test with H0: μN - μO = 0 and Ha: μN - μO > 0.', false, 'The researcher expects the new app to give a lower mean, so a greater-than alternative points the wrong way.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A two-sample t test with H0: x-bar_N - x-bar_O = 0 and Ha: x-bar_N - x-bar_O < 0.', false, 'Hypotheses are about the population means, not the sample means.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A two-sample t test with H0: μN - μO = 0 and Ha: μN - μO < 0.', true, 'Correct: the groups are independent, so a two-sample t test applies; "lower" means μN - μO < 0.' from version_ins;
-- APSTATS-MCQ-SV-H-4.9-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.9-A-v1', 'mcq', 'Two-sample or paired setup and hypotheses (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'To compare two running shoes, 15 pairs of identical twins are used. In each pair, one twin is randomly assigned to shoe A and the other to shoe B, and each runs the same course. Which setup is appropriate?', null, md5('APSTATS-MCQ-SV-H-4.9-A-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A two-sample t test, because there are two groups of runners.', false, 'Two groups exist, but the observations are matched by pair, so they are not independent samples.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A two-proportion z test comparing runners who finish.', false, 'The response is a time, which is quantitative, not a proportion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A two-sample t test, because the runners in the two groups are different people.', false, 'Different people does not mean independent; the twin pairs link the two groups.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A paired t test on the 15 within-pair differences.', true, 'Correct: each twin in one group is matched to a twin in the other, so the data are paired and the analysis uses the differences.' from version_ins;
-- APSTATS-MCQ-SV-H-4.9-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.9-A-v2', 'mcq', 'Two-sample or paired setup and hypotheses (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher compares the mean wait times at two clinics using independent random samples of 12 patients from one clinic and 15 from the other. Dotplots of each sample show roughly symmetric shapes with no outliers. Which statement about the conditions for a two-sample t procedure is correct?', null, md5('APSTATS-MCQ-SV-H-4.9-A-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The conditions are not met, because the sample sizes differ.', false, 'The two sample sizes can differ; the unpooled t procedure does not require equal sizes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The conditions are not met, because the two standard deviations are not known to be equal.', false, 'The unpooled two-sample t procedure does not require equal standard deviations.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The conditions are met, because the samples are random and independent, and each sample is roughly symmetric with no outliers.', true, 'Correct: a two-sample t procedure requires random, independent samples, and each sample should not show strong skew or outliers when n is small.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The conditions are met only if the combined data from both clinics look approximately normal.', false, 'Normality is checked for each sample separately, not for the combined data.' from version_ins;
-- APSTATS-MCQ-SV-H-4.9-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.9-A-v3', 'mcq', 'Two-sample or paired setup and hypotheses (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Random samples of 40 vegetarians and 40 non-vegetarians have mean cholesterol levels of 182 and 191 mg/dL. A researcher wants to know whether mean cholesterol differs between the two populations. Which hypotheses should be tested, where μV and μN are the population mean cholesterol levels?', null, md5('APSTATS-MCQ-SV-H-4.9-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: x-bar_V = x-bar_N and Ha: x-bar_V ≠ x-bar_N', false, 'Hypotheses concern the population means, not the sample means.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: μV - μN = 0 and Ha: μV - μN < 0', false, 'The sample direction should not decide the alternative; the question asks only whether the means differ.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: μV - μN = 9 and Ha: μV - μN ≠ 9', false, 'The null value is 0, the no-difference value, not the observed sample difference.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: μV - μN = 0 and Ha: μV - μN ≠ 0', true, 'Correct: the question asks whether the means differ, so the alternative is two-sided and the null difference is 0.' from version_ins;
-- APSTATS-MCQ-H-4.10-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.10-A', 'mcq', 'Two-sample t test: statistic, p-value, conclusion', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two independent random samples of 40 students from two schools give test scores: school 1 has mean 78 and standard deviation 10; school 2 has mean 73 and standard deviation 12. Both samples are roughly symmetric. To test H0: μ1 - μ2 = 0 versus Ha: μ1 - μ2 > 0, which is the correct result and conclusion at the 5% level?', null, md5('APSTATS-MCQ-H-4.10-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 2.02 and p ≈ 0.02, so there is convincing evidence that the mean score at school 1 is higher.', true, 'Correct: SE = sqrt(100/40 + 144/40) = 2.47; t = 5/2.47 = 2.02; df ≈ 76; one-sided p = 0.023.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 0.32 and p ≈ 0.37, so there is not convincing evidence that school 1 has the higher mean.', false, 'Forgot to divide the variances by the sample sizes, so the standard error and the t value are wrong.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 2.86 and p ≈ 0.003, using a standard error of 1.75.', false, 'Divided the combined variance by the total sample size, which understates the standard error.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 2.02 and p ≈ 0.02, so there is a 2% chance that the two means are equal.', false, 'A p-value is not the probability that the null hypothesis is true.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-4.8-A','APSTATS-MCQ-SV-H-4.8-A-v1','APSTATS-MCQ-SV-H-4.8-A-v2','APSTATS-MCQ-SV-H-4.8-A-v3','APSTATS-MCQ-H-4.9-A','APSTATS-MCQ-SV-H-4.9-A-v1','APSTATS-MCQ-SV-H-4.9-A-v2','APSTATS-MCQ-SV-H-4.9-A-v3','APSTATS-MCQ-H-4.10-A']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-H-4.8-A','APSTATS-MCQ-SV-H-4.8-A-v1','APSTATS-MCQ-SV-H-4.8-A-v2','APSTATS-MCQ-SV-H-4.8-A-v3','APSTATS-MCQ-H-4.9-A','APSTATS-MCQ-SV-H-4.9-A-v1','APSTATS-MCQ-SV-H-4.9-A-v2','APSTATS-MCQ-SV-H-4.9-A-v3','APSTATS-MCQ-H-4.10-A']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
