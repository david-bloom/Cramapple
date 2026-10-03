begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-052-v2','APSTATS-MCQ-SV-052-v3','APSTATS-MCQ-SV-058-v1','APSTATS-MCQ-SV-058-v2','APSTATS-MCQ-SV-058-v3','APSTATS-MCQ-SV-063-v1','APSTATS-MCQ-SV-063-v2','APSTATS-MCQ-SV-063-v3','APSTATS-MCQ-SV-074-v1','APSTATS-MCQ-SV-074-v2','APSTATS-MCQ-SV-074-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-052-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-052-v2', 'mcq', 'Justifying a binomial model', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quality inspector randomly selects 12 bulbs from a very large shipment, where each bulb is independently defective with probability 0.03. Let X be the number of defective bulbs. Which statement correctly justifies that X is binomial?', null, md5('APSTATS-MCQ-SV-052-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'X is binomial because the defect probability is small.', false, 'Small p is not a condition; the four conditions are required.' from version_ins
union all select gen_random_uuid(), id, 'B', 'X is binomial because it takes whole-number values.', false, 'Many discrete variables take whole numbers without being binomial.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There are a fixed 12 trials, each with two outcomes, independent, with constant P(defective) = 0.03.', true, 'These match all binomial conditions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'X is binomial because the sample is large enough for X to be approximately normal.', false, '12 bulbs with p = 0.03 is not large enough, and normality is not what makes X binomial.' from version_ins;
-- APSTATS-MCQ-SV-052-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-052-v3', 'mcq', 'Why a count is not binomial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A teacher randomly picks 6 students one at a time, without replacement, from a class of 20 students (10 girls and 10 boys). Let X be the number of girls selected. Why is X not binomial?', null, md5('APSTATS-MCQ-SV-052-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The probability of selecting a girl, 0.5, is too large for a binomial model.', false, 'Binomials allow any p.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Picking without replacement from a small class makes trials dependent, so P(girl) shifts.', true, 'After one girl is picked P(girl) is 9/19; after a boy 10/19.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The number of picks is not fixed in advance by the teacher.', false, 'Exactly 6 students are picked.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Each pick has more than two possible outcomes for the student chosen.', false, 'Each pick is a girl or a boy, two outcomes.' from version_ins;
-- APSTATS-MCQ-SV-058-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-058-v1', 'mcq', 'Quadrupling a poll''s sample size', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 90% confidence interval for a population proportion, based on a random sample of 400 voters, has a margin of error of 0.04. If the pollsters instead sampled 1600 voters, with the same confidence level and about the same sample proportion, what would the margin of error be approximately?', null, md5('APSTATS-MCQ-SV-058-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.02', true, 'Quadrupling n halves the standard error (SE is proportional to 1/√n), so MOE = 0.04/2 = 0.02.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.04', false, 'Sample size appears in SE = sqrt(p̂(1-p̂)/n), so MOE cannot stay at 0.04 when n changes from 400 to 1600.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.01', false, 'Dividing 0.04 by 4 treats MOE as proportional to 1/n instead of 1/√n.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.08', false, 'Doubling 0.04 goes the wrong direction; a larger sample reduces SE and MOE.' from version_ins;
-- APSTATS-MCQ-SV-058-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-058-v2', 'mcq', 'Raising confidence level', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A poll of 500 randomly chosen adults gives a 90% confidence interval for a population proportion. If the pollster keeps the same data but reports a 99% confidence interval, what happens to the margin of error?', null, md5('APSTATS-MCQ-SV-058-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It gets larger, because the critical value z* increases from about 1.645 to about 2.576.', true, 'MOE = z*·SE and SE is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It stays the same, because the standard error depends only on n and p̂.', false, 'z* changes with confidence level.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It gets smaller, because greater confidence means a more precise estimate.', false, 'Greater confidence widens the interval.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It gets larger, because 99% confidence needs a larger sample.', false, 'The sample is unchanged; the increase comes from z*.' from version_ins;
-- APSTATS-MCQ-SV-058-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-058-v3', 'mcq', 'Required sample size for a margin of error', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher wants a 95% confidence interval for a population proportion with a margin of error no larger than 0.03, and has no prior estimate of the proportion. Using z* = 1.96 and the most conservative p̂ = 0.5, what is the minimum sample size?', null, md5('APSTATS-MCQ-SV-058-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '278', false, '0.25/0.03² = 277.8 omits z*².' from version_ins
union all select gen_random_uuid(), id, 'B', '545', false, '1.96(0.25)/0.03² = 544.4 forgets to square z*.' from version_ins
union all select gen_random_uuid(), id, 'C', '1068', true, 'n = (1.96)²(0.5)(0.5)/(0.03)² ≈ 1067.1, which must be rounded up to 1068.' from version_ins
union all select gen_random_uuid(), id, 'D', '1067', false, 'Rounding down gives a margin of error slightly above 0.03.' from version_ins;
-- APSTATS-MCQ-SV-063-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-063-v1', 'mcq', 'Power from a Type II error probability', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A significance test of H0: p = 0.5 at α = 0.05 has a 0.32 probability of failing to reject H0 when the true proportion is 0.6. What is the power of the test against p = 0.6?', null, md5('APSTATS-MCQ-SV-063-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.95', false, '0.95 = 1 - α is the probability of correctly not rejecting a true H0, not power against p = 0.6.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.32', false, '0.32 is β, the Type II error probability; power is its complement, 1 - 0.32 = 0.68.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.68', true, 'Power = 1 - β = 1 - 0.32 = 0.68.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.05', false, '0.05 is the significance level (the Type I error rate α), not the power. Power is the probability of rejecting H0 when p = 0.6, which is 1 − 0.32 = 0.68.' from version_ins;
-- APSTATS-MCQ-SV-063-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-063-v2', 'mcq', 'What increases power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher tests H0: p = 0.50 against Ha: p > 0.50 with n = 100 and α = 0.05. Which change would increase the power of the test against the true value p = 0.60?', null, md5('APSTATS-MCQ-SV-063-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Decreasing the sample size to 25.', false, 'Cutting n from 100 to 25 doubles the standard error, so the sampling distributions overlap more and power decreases.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Increasing the sample size to 400.', true, 'Quadrupling n from 100 to 400 halves the standard error of p-hat, so the sampling distributions under H0 and under p = 0.60 overlap less and rejection is more likely.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Testing against a true value closer to H0, such as 0.52.', false, 'A true value of 0.52 is only 0.02 above the null value 0.50, much harder to detect than a gap of 0.10, so power decreases.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Decreasing α to 0.01.', false, 'Lowering α from 0.05 to 0.01 moves the rejection cutoff farther from 0.50, making rejection harder even when p = 0.60, so power decreases while Type I risk falls.' from version_ins;
-- APSTATS-MCQ-SV-063-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-063-v3', 'mcq', 'Defining power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pharmaceutical company tests H0: the new drug has no effect on blood pressure, against Ha: the drug lowers blood pressure. Which statement correctly describes the power of this test?', null, md5('APSTATS-MCQ-SV-063-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The probability of failing to reject H0 when the drug does lower blood pressure.', false, 'Failing to reject H0 when the drug does lower blood pressure is a Type II error, whose probability is β = 1 - power.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The probability that the drug lowers blood pressure given that H0 was rejected.', false, 'This reverses the conditional: power is P(reject H0 | alternative true), not P(alternative true | H0 rejected).' from version_ins
union all select gen_random_uuid(), id, 'C', 'The probability of rejecting H0 when the drug has no effect.', false, 'Rejecting H0 when the drug has no effect (H0 true) is a Type I error, whose probability is α, not power.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The probability of rejecting H0 when the drug really does lower blood pressure by a specific amount.', true, 'Power = P(reject H0 | the stated alternative is true) = 1 - β, here the chance the test detects a real blood-pressure reduction of the specified size.' from version_ins;
-- APSTATS-MCQ-SV-074-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-074-v1', 'mcq', 'Which machine made a defective item', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A plant has three machines. Machine A makes 50% of items with a 2% defect rate; Machine B makes 30% with a 3% defect rate; Machine C makes 20% with a 5% defect rate. A randomly selected item is defective. What is the probability it came from Machine B?', null, md5('APSTATS-MCQ-SV-074-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.030', false, 'This is P(defective | B), the reverse of the requested conditional probability P(B | defective).' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 0.300', false, 'This is Machine B''s 30% production share, ignoring the information that the item is defective; Machine B has a 3% rate vs 2% and 5% for others, so the probability changes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 0.009', false, 'This is the joint probability P(B and defective) = 0.30 x 0.03; it must be divided by P(defective) = 0.029.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 0.310', true, 'P(B | defective) = (0.30)(0.03) / (0.50(0.02) + 0.30(0.03) + 0.20(0.05)) = 0.009/0.029 ≈ 0.310.' from version_ins;
-- APSTATS-MCQ-SV-074-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-074-v2', 'mcq', 'Formula for a reversed conditional probability', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school tracks whether students studied and whether they passed. Which expression correctly gives P(studied | passed)?', null, md5('APSTATS-MCQ-SV-074-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P(studied)P(passed)', false, 'This is P(studied and passed) only if the events are independent, and it is not a conditional probability.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P(passed | studied)P(passed)', false, 'This multiplies by P(passed) rather than dividing by it, so it does not equal P(studied | passed).' from version_ins
union all select gen_random_uuid(), id, 'C', 'P(studied) / P(passed | studied)', false, 'The denominator should be the marginal P(passed) and the numerator should be P(passed | studied)P(studied); this inverts the structure.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P(passed | studied)P(studied) / P(passed)', true, 'P(studied and passed)/P(passed), with the numerator rewritten via the multiplication rule.' from version_ins;
-- APSTATS-MCQ-SV-074-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-074-v3', 'mcq', 'Conditional probability from a table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school surveyed 400 commuters, grouped by mode, and recorded who arrived late this month: Bus 160 (24 late), Bike 100 (15 late), Car 140 (11 late). Among all students who arrived late, what is the probability a randomly chosen late arrival is a bike rider?', null, md5('APSTATS-MCQ-SV-074-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.15', false, 'P(late | bike) = 15/100.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.0375', false, 'P(bike and late) = 15/400.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.25', false, 'P(bike) = 100/400.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.30', true, 'P(bike | late) = 15/50 = 0.30.' from version_ins;
commit;
