begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-010-CAL-v1','APSTATS-MCQ-SV-010-CAL-v2','APSTATS-MCQ-SV-010-CAL-v3','APSTATS-MCQ-SV-021-v1','APSTATS-MCQ-SV-021-v2','APSTATS-MCQ-SV-021-v3','APSTATS-MCQ-SV-025-v1','APSTATS-MCQ-SV-025-v2','APSTATS-MCQ-SV-025-v3','APSTATS-MCQ-SV-038-v1','APSTATS-MCQ-SV-038-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-010-CAL-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-010-CAL-v1', 'mcq', 'Hospital readmission large-counts', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A hospital analyst takes a random sample of n = 60 patients from a very large patient population in which the true readmission rate is p = 0.05. The analyst wants to use a normal approximation for the sampling distribution of the sample proportion who are readmitted. Why is this approximation not appropriate?', null, md5('APSTATS-MCQ-SV-010-CAL-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'p = 0.05 is below 0.5, so the sampling distribution of p-hat can only be approximately normal when p is at least 0.5.', false, 'Normality does not require p ≥ 0.5; with p = 0.05 a large enough n (such as 300, giving np = 15) would satisfy the counts condition.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sample size n = 60 is under 100, and a normal approximation needs at least 100 observations whatever the value of p.', false, 'There is no fixed minimum n of 100; the requirement is np ≥ 10 and n(1 − p) ≥ 10, which a sample of 60 could meet for a different p, such as 0.5 (np = 30).' from version_ins
union all select gen_random_uuid(), id, 'C', 'np = 60(0.05) = 3, which is less than 10, so the large-counts condition fails and the sampling distribution of p-hat is skewed right.', true, 'The normal approximation requires both np and n(1 − p) to be at least 10; here np = 3 fails, and with so few expected readmissions the distribution of p-hat is right-skewed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The true rate p is known, so the sampling distribution of p-hat has no standard deviation to approximate with a normal model.', false, 'Because p is given, σ of p-hat = √(0.05·0.95/60) ≈ 0.028 can be computed; the issue is the shape, since np = 3 < 10.' from version_ins;
-- APSTATS-MCQ-SV-010-CAL-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-010-CAL-v2', 'mcq', 'Seed germination large-counts', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A botanist plants a random sample of n = 50 seeds from a very large seed lot in which the true germination rate is p = 0.96. Which statement correctly evaluates using a normal approximation for the sampling distribution of the sample proportion that germinate?', null, md5('APSTATS-MCQ-SV-010-CAL-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximation is not appropriate, since n(1 − p) = 50(0.04) = 2 is less than 10, which leaves the distribution of p-hat skewed left.', true, 'Both np and n(1 − p) must be at least 10; here np = 48 passes but n(1 − p) = 2 fails, so the sampling distribution of p-hat is skewed to the left.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The approximation is appropriate, because n = 50 is at least 30, which is the sample-size requirement for normality.', false, 'The n ≥ 30 guideline applies to sample means; for proportions the condition is np ≥ 10 and n(1 − p) ≥ 10, and here n(1 − p) = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The approximation is inappropriate because p = 0.96 is greater than 0.5, and normal approximations require p ≤ 0.5.', false, 'There is no rule that p must be at most 0.5; the failure is due to n(1 − p) = 2 being under 10, and a larger n (such as 500) would work for p = 0.96.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximation is appropriate, because np = 50(0.96) = 48 is at least 10.', false, 'Checking only np is not enough; n(1 − p) = 50(0.04) = 2 is below 10, so the large-counts condition is not met.' from version_ins;
-- APSTATS-MCQ-SV-010-CAL-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-010-CAL-v3', 'mcq', 'Employee survey 10% condition', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A human resources office has 600 employees. It plans to take a simple random sample of n = 80 employees and use a normal model for the sampling distribution of the proportion who support a new schedule, where the true proportion is p = 0.40. Which statement identifies the problem with this plan?', null, md5('APSTATS-MCQ-SV-010-CAL-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is no problem: np = 32 and n(1 − p) = 48 are both at least 10, so every condition for a normal model is met.', false, 'The counts are fine, but the 10% condition also must hold, and n = 80 exceeds 10% of 600 (60), so one condition is not met.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Because p = 0.40 is not close to 0.50, the large-counts condition fails and a normal model cannot be used.', false, 'Large counts holds here: np = 80(0.40) = 32 and n(1 − p) = 48 are both at least 10; p does not need to be near 0.5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Since 80 is much smaller than 600, the sample is too small relative to the population for the sampling distribution to be normal.', false, 'Sample size relative to the population is not a lower-bound issue; the 10% condition limits how large the sample can be, and a small fraction of the population is desirable.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sample of 80 is more than 10% of the 600 employees (10% of 600 is 60), so the independence (10%) condition is not met.', true, 'The 10% condition requires the population to be at least 10 times the sample size, which would take at least 800 employees; with 600 the draws are not close enough to independent, even though np = 32 and n(1 − p) = 48 are fine.' from version_ins;
-- APSTATS-MCQ-SV-021-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-021-v1', 'mcq', 'Quiz score correction effect on mean', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A teacher has 15 quiz scores with a mean of 72. While rechecking, she corrects one score from 64 to 79 and recomputes the mean. How does the mean change?', null, md5('APSTATS-MCQ-SV-021-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It increases by 1.0, because the total of the scores rises by 15 and there are 15 scores.', true, 'The corrected score is 79 − 64 = 15 points higher, so the sum rises by 15 and the mean rises by 15/15 = 1.0 (from 72 to 73).' from version_ins
union all select gen_random_uuid(), id, 'B', 'It increases by about 1.07, because the total rises by 15 and is divided by 14.', false, 'The mean divides by the number of values, n = 15, not n − 1 = 14 (n − 1 is used for sample standard deviation); 15/15 = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It does not change, because changing one score does not affect the median.', false, 'The median may be unaffected, but the mean uses every value; the sum changes by +15, so the mean changes by +1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It increases by 15.', false, '15 is the change in the single score; the mean changes by that amount divided by the 15 scores, which is 1.' from version_ins;
-- APSTATS-MCQ-SV-021-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-021-v2', 'mcq', 'Commute data entry correction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A data set of 20 commute times (in minutes) has a mean of 55. One entry of 90 minutes is found to be a typing error and is corrected to 50 minutes. What happens to the mean?', null, md5('APSTATS-MCQ-SV-021-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It decreases by about 2.1, because the total drops by 40 and is divided by 19.', false, 'The mean divides by all 20 values, not 19; 40/20 = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It decreases by 40.', false, '40 is the change in the single entry; the mean changes by 40/20 = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It increases by 2, because the size of the change, 40, is divided by 20 values.', false, 'The magnitude 2 is right, but the entry went down, so the total and the mean go down, not up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It decreases by 2, because the total drops by 40 minutes and is shared among 20 values.', true, 'The corrected entry is 40 minutes lower, so the sum drops by 40 and the mean drops by 40/20 = 2 (from 55 to 53).' from version_ins;
-- APSTATS-MCQ-SV-021-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-021-v3', 'mcq', 'Replaced value in small data set', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A set of 8 measurements has a mean of 25. A lab technician replaces one measurement of 10 with a new measurement of 34. How does the mean change?', null, md5('APSTATS-MCQ-SV-021-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It increases by 3, because the total rises by 24 and there are 8 measurements.', true, 'The replacement raises the sum by 34 − 10 = 24, so the mean rises by 24/8 = 3 (from 25 to 28).' from version_ins
union all select gen_random_uuid(), id, 'B', 'It increases by 24.', false, '24 is how much the one measurement changed; the mean changes by 24/8 = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It increases by 2.4, because the 24-point change is spread over 10 measurements.', false, 'There are 8 measurements, not 10; 24/8 = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It increases by 4.5, because the new mean is the average of the old mean, 25, and the new value, 34.', false, 'Averaging 25 with 34 treats the new value as if it were half of the data. The old mean of 25 summarizes eight values and only one of them changed: the sum rises by 24, so the mean rises by 24/8 = 3.' from version_ins;
-- APSTATS-MCQ-SV-025-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-025-v1', 'mcq', 'Homework minutes upper fence', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A boxplot of the number of minutes students spent on homework has Q1 = 42 and Q3 = 58. Using the 1.5 × IQR rule, what is the upper fence for possible outliers?', null, md5('APSTATS-MCQ-SV-025-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24', false, 'This is only 1.5(IQR) = 1.5(16); the fence is found by adding it to Q3.' from version_ins
union all select gen_random_uuid(), id, 'B', '90', false, 'This uses 2(IQR) instead of 1.5(IQR): 58 + 2(16) = 90.' from version_ins
union all select gen_random_uuid(), id, 'C', '82', true, 'IQR = 58 − 42 = 16, so the upper fence is Q3 + 1.5(IQR) = 58 + 24 = 82.' from version_ins
union all select gen_random_uuid(), id, 'D', '66', false, 'This starts from Q1: 42 + 1.5(16) = 66, but the upper fence is measured from Q3.' from version_ins;
-- APSTATS-MCQ-SV-025-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-025-v2', 'mcq', 'Lower fence for delivery times', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a set of delivery times (in minutes), Q1 = 120 and Q3 = 150. Using the 1.5 × IQR rule, what is the lower fence for possible outliers?', null, md5('APSTATS-MCQ-SV-025-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '45', false, 'This is only 1.5(IQR) = 1.5(30); it must be subtracted from Q1.' from version_ins
union all select gen_random_uuid(), id, 'B', '90', false, 'This subtracts 1.0(IQR) instead of 1.5(IQR): 120 − 30 = 90.' from version_ins
union all select gen_random_uuid(), id, 'C', '195', false, 'This is the upper fence, Q3 + 1.5(IQR) = 150 + 45 = 195, not the lower fence.' from version_ins
union all select gen_random_uuid(), id, 'D', '75', true, 'IQR = 150 − 120 = 30, so the lower fence is Q1 − 1.5(IQR) = 120 − 45 = 75.' from version_ins;
-- APSTATS-MCQ-SV-025-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-025-v3', 'mcq', 'Which value is a possible outlier', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The daily change in temperature (in °F) for a city has Q1 = 20 and Q3 = 44. Using the 1.5 × IQR rule, which of the following values would be identified as a possible outlier?', null, md5('APSTATS-MCQ-SV-025-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '56', false, '56 = Q1 + 1.5(IQR) = 20 + 36, a fence built from the wrong quartile; it is below the actual upper fence of 80.' from version_ins
union all select gen_random_uuid(), id, 'B', '−10', false, '−10 is below Q1 = 20, but the lower fence is 20 − 1.5(24) = −16, and −10 is above it, so it is not flagged.' from version_ins
union all select gen_random_uuid(), id, 'C', '84', true, 'IQR = 44 − 20 = 24; the upper fence is 44 + 1.5(24) = 80, and the lower fence is 20 − 36 = −16. Since 84 > 80, it is a possible outlier.' from version_ins
union all select gen_random_uuid(), id, 'D', '68', false, '68 = Q3 + 1.0(IQR) = 44 + 24, which uses the wrong multiplier; it is below the upper fence of 80, so it is not flagged.' from version_ins;
-- APSTATS-MCQ-SV-038-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-038-v1', 'mcq', 'Library members stratified by branch type', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A county library system has members who mostly use urban branches, a smaller group who use suburban branches, and only about 8% who use rural branches. The system plans a satisfaction survey of 500 members. Why might a stratified random sample be better than a simple random sample here?', null, md5('APSTATS-MCQ-SV-038-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It guarantees that the small rural group is included in a planned amount, which a simple random sample could under-represent by chance.', true, 'Sampling within each branch type (stratum) fixes how many members come from each, so the 8% rural group cannot be missed or badly under-represented the way it could be in a simple random sample.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is the only method in which every library member has the same chance of being selected.', false, 'In a simple random sample every member also has an equal chance of selection (and so does every possible group of 500), so stratified sampling is not unique in this.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It lets surveyors hand-pick willing members within each branch type, which gives more complete responses.', false, 'Members within each stratum must still be chosen randomly; hand-picking willing members would introduce selection bias.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It removes sampling variability, so the sample percentages will equal the population percentages exactly.', false, 'Stratified samples still vary from sample to sample; stratification can reduce variability but never eliminates it.' from version_ins;
-- APSTATS-MCQ-SV-038-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-038-v2', 'mcq', 'Factory shifts stratified vs SRS', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A factory has 300 day-shift, 150 evening-shift, and 50 night-shift workers. A manager wants to compare job satisfaction across the three shifts using a sample of 60 workers. Why might stratified sampling be preferable to a simple random sample of 60?', null, md5('APSTATS-MCQ-SV-038-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It removes the need to randomize, because the shifts are already natural groups of workers.', false, 'Workers must still be selected randomly within each shift; the shifts only define the strata.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It selects entire shifts at random and surveys everyone in them, which saves time and travel.', false, 'That describes cluster sampling; stratified sampling takes a random sample from every shift rather than whole shifts.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It guarantees that no selected worker will refuse to answer, so the results are free of nonresponse bias.', false, 'Stratification does nothing to prevent nonresponse; selected workers can still decline to participate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Randomly sampling within each shift guarantees that the small night shift appears in the sample, so shifts can be compared.', true, 'A simple random sample of 60 from 500 would contain only about 6 night-shift workers on average and could contain very few; stratifying ensures each shift is represented.' from version_ins;
commit;
