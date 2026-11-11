begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-3.15-A','APSTATS-MCQ-SV-H-3.1-A-v1','APSTATS-MCQ-SV-H-3.1-A-v2','APSTATS-MCQ-SV-H-3.1-A-v3','APSTATS-MCQ-SV-H-3.2-A-v1','APSTATS-MCQ-SV-H-3.2-A-v2','APSTATS-MCQ-SV-H-3.2-A-v3','APSTATS-MCQ-SV-H-3.3-A-v1','APSTATS-MCQ-SV-H-3.3-A-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- APSTATS-MCQ-H-3.15-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.15-A', 'mcq', 'Expected counts and chi-square conditions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 100 people was classified by group and response. Group 1 (20 people): 15 responded yes and 5 responded no. Group 2 (80 people): 75 responded yes and 5 responded no. A researcher plans a chi-square test. Which statement about the conditions is correct?', null, md5('APSTATS-MCQ-H-3.15-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The expected counts condition is not met, because the expected count for Group 1 and response no is 20(10)/100 = 2, which is less than 5.', true, 'Correct: column totals are 90 and 10; expected counts: Group 1: 18 and 2; Group 2: 72 and 8; the smallest is 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The conditions are met, because every observed count is at least 5.', false, 'The condition is on expected counts, and an expected count can be small even when all observed counts are at least 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The conditions are met, because the total sample size of 100 is greater than 30.', false, 'The sample-size rule of 30 does not replace checking expected counts.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The expected counts condition is not met, because Group 2 has more people than Group 1.', false, 'Unequal group sizes are not a violation; the condition is about expected counts.' from version_ins;
-- APSTATS-MCQ-SV-H-3.1-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.1-A-v1', 'mcq', 'Bias versus variability of an estimator (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A county health office estimates the proportion of residents who exercise weekly using an online sign-up poll. The poll is repeated many times, and each time about 5,000 people respond. The estimates are tightly clustered around 0.72, but the true proportion in the county is 0.55. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.1-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The estimator is unbiased, because the estimates are so consistent from poll to poll.', false, 'Consistent results show low variability, not accuracy.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The estimator is biased but has low variability, and asking even more volunteers in the same way would not remove the bias.', true, 'Correct: centered at 0.72, not 0.55 (biased); spread is small (low variability); a voluntary-response method is biased at any size.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The estimator has high variability, because its estimates are far from 0.55.', false, 'Variability is the spread of the estimates, not their distance from the truth.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The estimator is biased, but the bias would shrink if the poll used 50,000 volunteers.', false, 'Bias from the sampling method is not reduced by a larger sample of the same kind.' from version_ins;
-- APSTATS-MCQ-SV-H-3.1-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.1-A-v2', 'mcq', 'Bias versus variability of an estimator (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Statisticians compare two methods of estimating a true proportion of 0.40. Method P uses samples of size 100, and its sampling distribution has a mean of 0.40 and a standard deviation of 0.049. Method Q uses samples of size 400, and its sampling distribution has a mean of 0.40 and a standard deviation of 0.025. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.1-A-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Method Q is less biased than Method P, because its sample size is larger.', false, 'Sample size changes variability, not bias, and both methods already have zero bias.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Method P is better, because a smaller sample leaves less room for error.', false, 'Smaller samples give more variable estimates.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both methods are unbiased, but Method Q is more precise because its estimates vary less from sample to sample.', true, 'Correct: both means equal 0.40 (unbiased); SD 0.025 < 0.049.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two methods are equally good, because both are centered at 0.40.', false, 'Unbiasedness alone does not make estimators equally good; the more precise one is preferred.' from version_ins;
-- APSTATS-MCQ-SV-H-3.1-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.1-A-v3', 'mcq', 'Bias versus variability of an estimator (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Repeated random samples are used to estimate a true proportion of 0.50 with three estimators. Estimator R has a sampling distribution centered at 0.50 with a standard deviation of 0.08. Estimator S is centered at 0.58 with a standard deviation of 0.02. Estimator T is centered at 0.59 with a standard deviation of 0.09. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.1-A-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Estimator R is the only unbiased estimator, and Estimator S has the least variability but is biased.', true, 'Correct: only R is centered at 0.50; S has the smallest SD but is centered at 0.58.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Estimator S is the best choice, because it has the smallest standard deviation.', false, 'A small standard deviation does not make up for being centered at the wrong value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Estimator T is unbiased, because its large standard deviation means it sometimes hits 0.50.', false, 'Unbiasedness is about the center, not the spread.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Estimator R is biased, because it has a wider spread than Estimator S.', false, 'A wide spread of estimates is variability, and bias is about where the sampling distribution is centered.' from version_ins;
-- APSTATS-MCQ-SV-H-3.2-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.2-A-v1', 'mcq', 'Standardize a sample proportion (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'About 60% of the students at a large school own a laptop. A random sample of 150 students is selected, and 52% of the sample own a laptop. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.2-A-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sample proportion is about 24 standard deviations below 0.60, since the standard deviation of the sampling distribution is 0.0033.', false, 'Divided sqrt[p(1 - p)] by n instead of taking the square root of p(1 - p)/n, which makes the standard deviation far too small.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sample proportion is 0.08 below 0.60, which is too small a gap to ever be unusual.', false, 'Unusualness depends on the gap measured in standard deviations, not the raw gap.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sample proportion is about 2 standard deviations below 0.60, so a result this low would be fairly unusual if the true proportion were 0.60.', true, 'Correct: SD = sqrt(0.6 x 0.4 / 150) = 0.04; z = -0.08 / 0.04 = -2.0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sample proportion is about 50 standard deviations below 0.60, since the standard deviation of the sampling distribution is 0.0016.', false, 'Used the variance p(1 - p)/n as the standard deviation.' from version_ins;
-- APSTATS-MCQ-SV-H-3.2-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.2-A-v2', 'mcq', 'Standardize a sample proportion (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A hospital knows that 15% of its patients are readmitted within 30 days. In a random sample of 400 patients, 19% were readmitted. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.2-A-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sample proportion is only 0.04 above 0.15, so it is within normal sampling variability for a sample of any size.', false, 'The gap must be compared with the standard deviation, which is small for n = 400.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sample proportion is about 45 standard deviations above 0.15, since the standard deviation of the sampling distribution is 0.00089.', false, 'Divided sqrt[p(1 - p)] by n instead of taking the square root of p(1 - p)/n, which makes the standard deviation far too small.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sample proportion is about 2.2 standard deviations above 0.15, so a result this large would be somewhat unusual if the true proportion were 0.15.', true, 'Correct: SD = sqrt(0.15 x 0.85 / 400) = 0.01785; z = 0.04 / 0.01785 = 2.24.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sample proportion is about 125 standard deviations above 0.15, since the standard deviation of the sampling distribution is 0.00032.', false, 'Used p(1 - p)/n as the standard deviation.' from version_ins;
-- APSTATS-MCQ-SV-H-3.2-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.2-A-v3', 'mcq', 'Standardize a sample proportion (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A manufacturer reports that 45% of its tablets pass inspection on the first try. A random sample of 100 tablets gives a sample proportion of 0.50. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.2-A-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sample proportion is about 10 standard deviations above 0.45, since the standard deviation of the sampling distribution is 0.005.', false, 'Divided sqrt[p(1 - p)] by n instead of taking the square root of p(1 - p)/n, which makes the standard deviation far too small.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sample proportion is about 1 standard deviation above 0.45, so a result this large would not be unusual if the true proportion were 0.45.', true, 'Correct: SD = sqrt(0.45 x 0.55 / 100) = 0.0497; z = 0.05 / 0.0497 = 1.01.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sample proportion is 0.05 above 0.45, which is too large a gap to be ordinary sampling variability.', false, 'With n = 100 the standard deviation is about 0.05, so a gap of 0.05 is ordinary.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sample proportion is about 20 standard deviations above 0.45, since the standard deviation of the sampling distribution is 0.0025.', false, 'Used p(1 - p)/n as the standard deviation.' from version_ins;
-- APSTATS-MCQ-SV-H-3.3-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.3-A-v1', 'mcq', 'Margin of error under combined changes (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for a population proportion, based on a random sample of 625 people, has a margin of error of 0.03. A second interval uses a random sample of 2,500 people at a 90% confidence level, with about the same sample proportion. About what is its margin of error?', null, md5('APSTATS-MCQ-SV-H-3.3-A-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.025', false, 'Accounted for the lower confidence level but ignored the larger sample.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.015', false, 'Accounted for the larger sample but ignored the lower confidence level.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.013', true, 'Correct: n quadrupled so 0.03 / 2 = 0.015; critical value falls from 1.96 to 1.645 (factor 0.839); 0.015 x 0.839 = 0.0126.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.006', false, 'Divided by 4 instead of 2 for the sample size, then applied the critical value change.' from version_ins;
-- APSTATS-MCQ-SV-H-3.3-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.3-A-v2', 'mcq', 'Margin of error under combined changes (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for a population proportion, based on a random sample of 200 people, has a margin of error of 0.05. A second interval uses a random sample of 800 people at a 99% confidence level, with about the same sample proportion. About what is its margin of error?', null, md5('APSTATS-MCQ-SV-H-3.3-A-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.066', false, 'Accounted for the higher confidence level but ignored the larger sample.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.033', true, 'Correct: 0.05 / 2 = 0.025; 2.576 / 1.96 = 1.314; 0.025 x 1.314 = 0.0329.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.025', false, 'Accounted for the larger sample but ignored the higher confidence level.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.016', false, 'Divided by 4 for the sample size instead of 2, then applied the critical value change.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-3.15-A','APSTATS-MCQ-SV-H-3.1-A-v1','APSTATS-MCQ-SV-H-3.1-A-v2','APSTATS-MCQ-SV-H-3.1-A-v3','APSTATS-MCQ-SV-H-3.2-A-v1','APSTATS-MCQ-SV-H-3.2-A-v2','APSTATS-MCQ-SV-H-3.2-A-v3','APSTATS-MCQ-SV-H-3.3-A-v1','APSTATS-MCQ-SV-H-3.3-A-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-H-3.15-A','APSTATS-MCQ-SV-H-3.1-A-v1','APSTATS-MCQ-SV-H-3.1-A-v2','APSTATS-MCQ-SV-H-3.1-A-v3','APSTATS-MCQ-SV-H-3.2-A-v1','APSTATS-MCQ-SV-H-3.2-A-v2','APSTATS-MCQ-SV-H-3.2-A-v3','APSTATS-MCQ-SV-H-3.3-A-v1','APSTATS-MCQ-SV-H-3.3-A-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
