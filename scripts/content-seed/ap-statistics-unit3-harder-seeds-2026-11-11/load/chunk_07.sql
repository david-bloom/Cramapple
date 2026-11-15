begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.8-C-v3','APSTATS-MCQ-SV-H-3.9-A-v1','APSTATS-MCQ-SV-H-3.9-A-v2','APSTATS-MCQ-SV-H-3.9-A-v3','APSTATS-MCQ-SV-H-3.10-A-v1','APSTATS-MCQ-SV-H-3.10-A-v2','APSTATS-MCQ-SV-H-3.10-A-v3','APSTATS-MCQ-SV-H-3.11-A-v1','APSTATS-MCQ-SV-H-3.11-A-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-3.8-C-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.8-C-v3', 'mcq', 'Type II error from a framed null hypothesis (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher tests H0: the new teaching method is no better than the current method versus Ha: the new method is better. Which statement correctly describes a Type I error?', null, md5('APSTATS-MCQ-SV-H-3.8-C-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The researcher concludes the new method is no better when it is actually better.', false, 'Failing to find an effect that exists is a Type II error.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The researcher concludes the new method is no better when it is actually no better.', false, 'Concluding no benefit when there is none is a correct decision, not an error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The researcher concludes the new method is better when it is actually better.', false, 'Concluding a benefit when there really is one is a correct decision, not an error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The researcher concludes the new method is better when it is actually no better.', true, 'Correct: Type I means rejecting a true H0.' from version_ins;
-- APSTATS-MCQ-SV-H-3.9-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.9-A-v1', 'mcq', 'Sampling distribution of a difference of sample proportions (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In one large school district 70% of students walk to school, and in another 55% walk. Independent random samples of 120 students from the first district and 100 students from the second district are selected. Which statement describes the sampling distribution of p-hat 1 - p-hat 2?', null, md5('APSTATS-MCQ-SV-H-3.9-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Approximately normal with mean 0.15 and standard deviation 0.0916.', false, 'Added the two standard deviations instead of adding the two variances and taking the square root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Approximately normal with mean 0.15 and standard deviation 0.0650.', true, 'Correct: variance = 0.7(0.3)/120 + 0.55(0.45)/100 = 0.00422; SD = 0.065; counts 84, 36, 55, 45 are at least 10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Approximately normal with mean 0.15 and standard deviation 0.00422.', false, 'Reported the variance as the standard deviation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Approximately normal with mean 1.27 and standard deviation 0.0650.', false, 'Divided the proportions instead of subtracting them.' from version_ins;
-- APSTATS-MCQ-SV-H-3.9-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.9-A-v2', 'mcq', 'Sampling distribution of a difference of sample proportions (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In each of two large cities, 30% of residents support a new tax. Independent random samples of 80 residents are taken from each city. Which statement describes the sampling distribution of p-hat 1 - p-hat 2?', null, md5('APSTATS-MCQ-SV-H-3.9-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Approximately normal with mean 0.30 and standard deviation 0.0725.', false, 'Used the common proportion as the mean instead of the difference.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Approximately normal with mean 0 and standard deviation 0.00525.', false, 'Reported the variance as the standard deviation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Approximately normal with mean 0 and standard deviation 0.1025.', false, 'Added the two standard deviations instead of adding the two variances and taking the square root.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Approximately normal with mean 0 and standard deviation 0.0725.', true, 'Correct: mean = 0; variance = 2 x 0.3(0.7)/80 = 0.00525; SD = 0.0725; counts 24 and 56 are at least 10.' from version_ins;
-- APSTATS-MCQ-SV-H-3.9-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.9-A-v3', 'mcq', 'Sampling distribution of a difference of sample proportions (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In population 1, 90% of members have a trait, and in population 2, 80% have it. Independent random samples of 40 members from population 1 and 60 from population 2 are taken. Which statement describes the sampling distribution of p-hat 1 - p-hat 2?', null, md5('APSTATS-MCQ-SV-H-3.9-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Approximately normal with mean 0.10 and standard deviation 0.0701, since the sample sizes are both at least 30.', false, 'The rule of 30 does not apply; the large counts condition fails for population 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean 0.10 and standard deviation 0.0991, and not approximately normal, since 40(0.10) = 4 is less than 10.', false, 'The shape conclusion is right, but the standard deviation was found by adding the two standard deviations.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Approximately normal with mean 0.10 and standard deviation 0.00492.', false, 'Reported the variance as the standard deviation and ignored the large counts condition.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean 0.10 and standard deviation 0.0701, but not approximately normal, since 40(0.10) = 4 is less than 10.', true, 'Correct: variance = 0.9(0.1)/40 + 0.8(0.2)/60 = 0.00492; SD = 0.0701; n1(1 - p1) = 4 < 10.' from version_ins;
-- APSTATS-MCQ-SV-H-3.10-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.10-A-v1', 'mcq', 'Interpret an interval for a difference of proportions (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tutoring company compares a new curriculum with its old curriculum. A 95% confidence interval for p_new - p_old, the difference in the proportions of all students who would pass an exam, is (-0.12, -0.03). Which interpretation is correct?', null, md5('APSTATS-MCQ-SV-H-3.10-A-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'We are 95% confident that between 3% and 12% of all students pass.', false, 'The interval estimates a difference between two proportions, not a single proportion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'We are 95% confident that the proportion of all students who pass with the old curriculum is between 0.03 and 0.12 lower than with the new curriculum.', false, 'Reversed the direction; negative new - old means the old proportion is higher.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a 95% chance that a student is between 3% and 12% less likely to pass with the new curriculum.', false, 'The interval is about population proportions, not about the chance for one student.' from version_ins
union all select gen_random_uuid(), id, 'D', 'We are 95% confident that the proportion of all students who pass with the new curriculum is between 0.03 and 0.12 lower than the proportion with the old curriculum.', true, 'Correct: the interval is for new - old and is negative, so new is lower.' from version_ins;
-- APSTATS-MCQ-SV-H-3.10-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.10-A-v2', 'mcq', 'Interpret an interval for a difference of proportions (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 90% confidence interval for p_T - p_C, the difference in the proportions of all patients who recover with a treatment and with a control, is (0.05, 0.19). Which interpretation is correct?', null, md5('APSTATS-MCQ-SV-H-3.10-A-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'We are 90% confident that the proportion of all patients who recover with the treatment is between 0.05 and 0.19 higher than with the control.', true, 'Correct: the interval for T - C is entirely positive, so the treatment proportion is higher.' from version_ins
union all select gen_random_uuid(), id, 'B', 'We are 90% confident that between 5% and 19% of all patients recover.', false, 'The interval describes a difference, not a single proportion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Between 5% and 19% of patients in the sample recovered with the treatment.', false, 'The interval is about the populations, not the patients in the sample.' from version_ins
union all select gen_random_uuid(), id, 'D', 'We are 90% confident that the proportion who recover with the control is between 0.05 and 0.19 higher than with the treatment.', false, 'Reversed the direction of the comparison, since a positive T - C means the treatment proportion is the higher one.' from version_ins;
-- APSTATS-MCQ-SV-H-3.10-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.10-A-v3', 'mcq', 'Interpret an interval for a difference of proportions (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for p_1 - p_2, the difference in the proportions of all adults in two cities who favor a plan, is (-0.04, 0.08). Which interpretation is correct?', null, md5('APSTATS-MCQ-SV-H-3.10-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'We are 95% confident that p_1 equals p_2, because the interval contains 0.', false, 'An interval containing 0 shows that no difference is plausible, not that the proportions are equal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'We are 95% confident that p_1 is between 4% and 8% higher than p_2.', false, 'The interval includes negative values, so p_1 could be lower than p_2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'We are 95% confident that p_1 - p_2 is between -0.04 and 0.08, so a difference of zero is a plausible value.', true, 'Correct: the interval contains 0 so equal proportions are plausible but not proven.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is a 95% probability that p-hat 1 - p-hat 2 in a new sample falls between -0.04 and 0.08.', false, 'The confidence level refers to the method capturing the population difference.' from version_ins;
-- APSTATS-MCQ-SV-H-3.11-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.11-A-v1', 'mcq', 'Claim from an interval for a difference of proportions (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for p_1 - p_2, the difference in the proportions of all customers in two regions who prefer a product, is (0.03, 0.17). A manager claims that the proportion in region 1 is at least 0.10 higher than in region 2. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.11-A-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The interval supports the claim, because the whole interval is positive.', false, 'A positive interval supports a positive difference, not a difference of at least 0.10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The interval supports the claim, because the center of the interval, 0.10, equals 0.10.', false, 'The midpoint is the sample difference; the claim needs every plausible value to be at least 0.10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The interval does not show region 1 is higher, because the lower endpoint 0.03 is close to 0.', false, 'Any interval entirely above 0 supports a positive difference.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interval shows region 1 is higher, but it does not support the claim of at least 0.10, because values below 0.10 are plausible.', true, 'Correct: all plausible differences are positive; 0.03 to 0.10 are plausible and below the claimed value.' from version_ins;
-- APSTATS-MCQ-SV-H-3.11-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.11-A-v2', 'mcq', 'Claim from an interval for a difference of proportions (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 90% confidence interval for p_1 - p_2 is (0.01, 0.15), and a 99% confidence interval computed from the same data is (-0.03, 0.19). A researcher claims p_1 is greater than p_2. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.11-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is supported at both confidence levels, because the 99% interval is wider.', false, 'The 99% interval contains 0, so it does not rule out no difference.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is not supported at either level, because the intervals are different.', false, 'Different intervals from different levels do not contradict each other; each answers its own level.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is supported at the 99% level but not at the 90% level, because higher confidence is stronger evidence.', false, 'A higher confidence level makes the interval wider, which makes it harder to exclude 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is supported at the 90% confidence level but not at the 99% level, because 0 is plausible in the 99% interval.', true, 'Correct: 90% interval excludes 0; 99% interval contains 0.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.8-C-v3','APSTATS-MCQ-SV-H-3.9-A-v1','APSTATS-MCQ-SV-H-3.9-A-v2','APSTATS-MCQ-SV-H-3.9-A-v3','APSTATS-MCQ-SV-H-3.10-A-v1','APSTATS-MCQ-SV-H-3.10-A-v2','APSTATS-MCQ-SV-H-3.10-A-v3','APSTATS-MCQ-SV-H-3.11-A-v1','APSTATS-MCQ-SV-H-3.11-A-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-3.8-C-v3','APSTATS-MCQ-SV-H-3.9-A-v1','APSTATS-MCQ-SV-H-3.9-A-v2','APSTATS-MCQ-SV-H-3.9-A-v3','APSTATS-MCQ-SV-H-3.10-A-v1','APSTATS-MCQ-SV-H-3.10-A-v2','APSTATS-MCQ-SV-H-3.10-A-v3','APSTATS-MCQ-SV-H-3.11-A-v1','APSTATS-MCQ-SV-H-3.11-A-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
