begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-4.3-A-v2','APSTATS-MCQ-SV-H-4.3-A-v3','APSTATS-MCQ-H-4.4-A','APSTATS-MCQ-SV-H-4.4-A-v1','APSTATS-MCQ-SV-H-4.4-A-v2','APSTATS-MCQ-SV-H-4.4-A-v3','APSTATS-MCQ-H-4.5-A','APSTATS-MCQ-SV-H-4.5-A-v1','APSTATS-MCQ-SV-H-4.5-A-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-4.3-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.3-A-v2', 'mcq', 'Claim from an interval for a mean (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for a population mean is (3.1, 4.9). A student tests H0: μ = 5 against Ha: μ ≠ 5 at the 5% significance level. Which conclusion follows from the interval?', null, md5('APSTATS-MCQ-SV-H-4.3-A-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The p-value is greater than 0.05, because 5 is close to the interval.', false, 'Closeness does not matter; any value outside the interval is rejected by the matching two-sided test.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The p-value is less than 0.05, because 5 is not in the interval.', true, 'Correct: a 95% interval and a two-sided test at the 5% level agree; 5 lies outside the interval, so H0 is rejected and p < 0.05.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The p-value equals 0.05, because the interval has 95% confidence.', false, 'The confidence level sets the cutoff of 0.05, but the p-value itself is below it when the value is outside the interval.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Nothing can be said, because intervals and tests are unrelated.', false, 'A confidence interval and a two-sided test at the matching level give the same decision.' from version_ins;
-- APSTATS-MCQ-SV-H-4.3-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.3-A-v3', 'mcq', 'Claim from an interval for a mean (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'To test whether a tutoring program changes test scores, researchers record the score difference (after - before) for each of 20 randomly chosen students. A 95% confidence interval for the population mean difference is (-3.4, 0.6) points. Which conclusion is justified?', null, md5('APSTATS-MCQ-SV-H-4.3-A-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The program lowers scores, because more of the interval is negative than positive.', false, 'The position of the center within the interval does not matter; any interval containing 0 allows no change as a plausible value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is not convincing evidence that the program changes the mean score, because 0 is in the interval.', true, 'Correct: 0 is inside (-3.4, 0.6), so a mean difference of 0 is plausible, but the data do not prove it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The program has no effect on scores.', false, 'Failing to find evidence of an effect is not the same as proving there is no effect.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 95% of students had a change between -3.4 and 0.6 points.', false, 'The interval is about the mean difference, not individual students.' from version_ins;
-- APSTATS-MCQ-H-4.4-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.4-A', 'mcq', 'Hypotheses for a mean', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cereal box states that the mean sodium per serving is 250 mg. An inspector suspects the true mean is higher and measures 30 randomly chosen servings, finding a sample mean of 262 mg. Which hypotheses should be tested, where μ is the true mean sodium per serving?', null, md5('APSTATS-MCQ-H-4.4-A'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: x-bar = 250 and Ha: x-bar > 250', false, 'Hypotheses are about the population parameter, not the sample mean.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: μ = 262 and Ha: μ > 262', false, 'The null value comes from the claim, not from the sample result.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: μ = 250 and Ha: μ > 250', true, 'Correct: the null states the claimed value and the alternative reflects the suspicion of a higher mean, both about the parameter μ.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: μ = 250 and Ha: μ ≠ 250', false, 'The inspector suspects the mean is higher, so a two-sided alternative does not match the question.' from version_ins;
-- APSTATS-MCQ-SV-H-4.4-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.4-A-v1', 'mcq', 'Hypotheses for a mean (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Twelve students take a test before and after a tutoring program. Let d = after - before for each student, and let μd be the population mean of these differences. The tutor believes the program improves scores. Which hypotheses should be tested?', null, md5('APSTATS-MCQ-SV-H-4.4-A-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: μd = 0 and Ha: μd < 0', false, 'This sign would describe a decrease; with d = after - before, improvement is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: μd > 0 and Ha: μd = 0', false, 'The null hypothesis must contain equality, and here it is placed on the wrong side.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: μd = 0 and Ha: μd ≠ 0', false, 'A two-sided alternative does not match the tutor''s belief that scores improve.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: μd = 0 and Ha: μd > 0', true, 'Correct: with d = after - before, an improvement means a positive mean difference, so the alternative is μd > 0.' from version_ins;
-- APSTATS-MCQ-SV-H-4.4-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.4-A-v2', 'mcq', 'Hypotheses for a mean (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A coffee shop labels its cups as holding 12 oz. A regulator wants to know whether the true mean fill differs from 12 oz and finds a mean of 11.8 oz in a random sample of 40 cups. Which hypotheses should be tested?', null, md5('APSTATS-MCQ-SV-H-4.4-A-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: μ = 12 and Ha: μ < 12', false, 'The sample mean is below 12, but the question was set before seeing the data, so the alternative must be two-sided.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: μ = 12 and Ha: μ ≠ 12', true, 'Correct: the regulator asks whether the mean differs from 12, which is two-sided, and the null uses the labeled value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: μ = 11.8 and Ha: μ ≠ 11.8', false, 'The null value is the labeled value, not the observed sample mean.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: μ ≠ 12 and Ha: μ = 12', false, 'The null hypothesis must contain equality, and the alternative states the difference.' from version_ins;
-- APSTATS-MCQ-SV-H-4.4-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.4-A-v3', 'mcq', 'Hypotheses for a mean (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A battery maker states that the mean life of its batteries is 10 hours. A consumer group suspects the mean life is shorter, and a random sample of 25 batteries has mean 9.4 hours. Which hypotheses should be tested?', null, md5('APSTATS-MCQ-SV-H-4.4-A-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: μ = 10 and Ha: μ > 10', false, 'The consumer group suspects a shorter life, so the alternative points the other way here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: μ = 10 and Ha: μ < 10', true, 'Correct: null is the stated mean; the alternative matches the suspicion of a shorter life.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: μ = 9.4 and Ha: μ < 9.4', false, 'The null value comes from the claim, not from the sample mean.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: μ < 10 and Ha: μ = 10', false, 'The null must hold the equality, and the suspicion belongs in the alternative.' from version_ins;
-- APSTATS-MCQ-H-4.5-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.5-A', 'mcq', 't test for a mean: statistic, p-value, conclusion', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cereal box states that the mean sodium per serving is 250 mg. An inspector tests H0: μ = 250 versus Ha: μ > 250 using a random sample of 25 servings, which has mean 262 mg and standard deviation 30 mg. The sampling distribution is approximately normal. Which is the correct result and conclusion at the 5% level?', null, md5('APSTATS-MCQ-H-4.5-A'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 0.40 and p ≈ 0.35, so there is not convincing evidence that the mean exceeds 250 mg.', false, 'Divided by s instead of the standard error, giving a t statistic far too small.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 2.00 and p ≈ 0.06, so there is not convincing evidence that the mean exceeds 250 mg.', false, 'Doubled the p-value for a two-sided test even though the alternative is one-sided.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 2.00 and p ≈ 0.03, so there is convincing evidence that the mean exceeds 250 mg.', true, 'Correct: SE = 30/√25 = 6; t = 12/6 = 2.00; df = 24; one-sided p = 0.0285 < 0.05, so reject H0.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 2.00 and p ≈ 0.03, so there is about a 3% chance that the mean is 250 mg.', false, 'A p-value is the probability of data this extreme if H0 is true, not the probability that H0 is true.' from version_ins;
-- APSTATS-MCQ-SV-H-4.5-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.5-A-v1', 'mcq', 't test for a mean: statistic, p-value, conclusion (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 16 observations from an approximately normal population has mean 47.2 and standard deviation 6. To test H0: μ = 50 versus Ha: μ ≠ 50, which is the correct result and conclusion at the 5% level?', null, md5('APSTATS-MCQ-SV-H-4.5-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = -1.87 and p ≈ 0.08, so there is not convincing evidence that the mean differs from 50.', true, 'Correct: SE = 6/√16 = 1.5; t = -2.8/1.5 = -1.87; df = 15; two-sided p = 0.082 > 0.05, so fail to reject H0.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = -1.87 and p ≈ 0.04, so there is convincing evidence that the mean differs from 50.', false, 'Used a single tail even though the alternative is two-sided, which halves the p-value and flips the conclusion.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = -0.47 and p ≈ 0.65, so there is not convincing evidence that the mean differs from 50.', false, 'Divided the difference by s instead of the standard error.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = -7.47 and p < 0.001, so there is convincing evidence that the mean differs from 50.', false, 'Divided s by n instead of √n, which inflates the t statistic.' from version_ins;
-- APSTATS-MCQ-SV-H-4.5-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.5-A-v2', 'mcq', 't test for a mean: statistic, p-value, conclusion (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ten randomly chosen students take a reading test before and after a program. The mean of the differences (after - before) is 3.1 points with a standard deviation of 4.0, and the differences are roughly symmetric with no outliers. To test H0: μd = 0 versus Ha: μd > 0, which is correct at the 5% level?', null, md5('APSTATS-MCQ-SV-H-4.5-A-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't = 0.78 and p ≈ 0.23, so there is not convincing evidence that the mean difference is positive.', false, 'Divided by the standard deviation instead of the standard error.' from version_ins
union all select gen_random_uuid(), id, 'B', 't = 2.45 and p ≈ 0.04 using a two-sided p-value, so the evidence is only borderline.', false, 'The alternative is one-sided, so the p-value is not doubled.' from version_ins
union all select gen_random_uuid(), id, 'C', 't = 2.45 with df = 9 and p ≈ 0.02, so there is convincing evidence that the mean difference is positive.', true, 'Correct: SE = 4.0/√10 = 1.265; t = 3.1/1.265 = 2.45; df = 9; one-sided p = 0.018 < 0.05.' from version_ins
union all select gen_random_uuid(), id, 'D', 't = 2.45 and p ≈ 0.02, so there is a 2% chance that the mean difference is 0.', false, 'The p-value is not the probability that the null hypothesis is true.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-4.3-A-v2','APSTATS-MCQ-SV-H-4.3-A-v3','APSTATS-MCQ-H-4.4-A','APSTATS-MCQ-SV-H-4.4-A-v1','APSTATS-MCQ-SV-H-4.4-A-v2','APSTATS-MCQ-SV-H-4.4-A-v3','APSTATS-MCQ-H-4.5-A','APSTATS-MCQ-SV-H-4.5-A-v1','APSTATS-MCQ-SV-H-4.5-A-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-4.3-A-v2','APSTATS-MCQ-SV-H-4.3-A-v3','APSTATS-MCQ-H-4.4-A','APSTATS-MCQ-SV-H-4.4-A-v1','APSTATS-MCQ-SV-H-4.4-A-v2','APSTATS-MCQ-SV-H-4.4-A-v3','APSTATS-MCQ-H-4.5-A','APSTATS-MCQ-SV-H-4.5-A-v1','APSTATS-MCQ-SV-H-4.5-A-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
