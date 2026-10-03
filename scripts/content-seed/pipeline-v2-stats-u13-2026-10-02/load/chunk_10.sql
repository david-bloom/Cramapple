begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-095-v1','APSTATS-MCQ-SV-095-v2','APSTATS-MCQ-SV-095-v3','APSTATS-MCQ-SV-006-v1','APSTATS-MCQ-SV-006-v2','APSTATS-MCQ-SV-006-v3','APSTATS-MCQ-SV-011-v1','APSTATS-MCQ-SV-011-v2','APSTATS-MCQ-SV-011-v3','APSTATS-MCQ-SV-026-v1','APSTATS-MCQ-SV-026-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-095-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-095-v1', 'mcq', 'Two tests compare power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two researchers test the same hypotheses and the same true parameter value. Study X uses α = 0.10 with n = 400. Study Y uses α = 0.01 with n = 100. Which statement about their power is correct?', null, md5('APSTATS-MCQ-SV-095-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The studies have equal power, because they test the same hypotheses with the same true parameter value.', false, 'Power depends on n and α as well as the true value, and these two differ in both (400 vs 100, 0.10 vs 0.01).' from version_ins
union all select gen_random_uuid(), id, 'B', 'Study Y has lower power, because both its smaller α and smaller sample size reduce power.', true, 'A smaller α makes rejecting H₀ harder, and a smaller n gives a larger standard error; both lower the chance of detecting a false null, so Y has lower power.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Study X has lower power, because the larger α makes a Type I error more likely, which reduces power.', false, 'A larger α increases the chance of rejecting H₀, which raises power; it does not reduce it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Study X has lower power, because a larger sample size increases variability and so makes rejection less likely.', false, 'A larger sample size decreases the standard error, which increases power.' from version_ins;
-- APSTATS-MCQ-SV-095-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-095-v2', 'mcq', 'Which change increases power', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A test of H₀: p = 0.50 versus Hₐ: p > 0.50 uses n = 100 and α = 0.05, and the true proportion is p = 0.60. Which change would increase the power of the test?', null, md5('APSTATS-MCQ-SV-095-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Increasing the sample size to 400, which reduces the standard error.', true, 'A larger n shrinks the standard error of p̂, making a true difference easier to detect, so power increases.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Decreasing the sample size to 25, since a smaller sample has fewer chances for error.', false, 'A smaller sample gives a larger standard error, which lowers power; sample size reduction does not reduce error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Lowering α to 0.01, which makes the test more careful about rejecting.', false, 'A smaller α makes rejection harder, which reduces the probability of rejecting a false H₀ and so decreases power.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Using the hypothesized value 0.58 in place of 0.50, so the null is closer to the truth.', false, 'A smaller gap between the null value and the true value makes the difference harder to detect, which lowers power.' from version_ins;
-- APSTATS-MCQ-SV-095-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-095-v3', 'mcq', 'Power from Type II probability', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A significance test with α = 0.05 has a Type II error probability of 0.35 when the true proportion is 0.60. What is the power of the test against that alternative?', null, md5('APSTATS-MCQ-SV-095-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0175', false, 'This multiplies α by the Type II probability (0.05 × 0.35); power is found by subtraction, not multiplication.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.95', false, 'This is 1 − α = 0.95, which is the probability of not making a Type I error when H₀ is true, not power.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.35', false, 'This is the probability of a Type II error itself; power is its complement.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.65', true, 'Power is the probability of rejecting a false null, 1 − P(Type II error) = 1 − 0.35 = 0.65.' from version_ins;
-- APSTATS-MCQ-SV-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-006-v1', 'mcq', 'Blocking by sex in a drug trial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A medical team tests whether a new drug lowers systolic blood pressure more than a placebo. They enroll 36 patients, 18 men and 18 women, and randomly assign drug or placebo separately within the men and within the women, instead of randomizing all 36 patients together. What is the main statistical advantage of assigning treatments within each sex?', null, md5('APSTATS-MCQ-SV-006-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It lets the team conclude the drug works for all adults, since both sexes were included in the trial.', false, 'Blocking does not extend conclusions to a population; generalizing depends on how the 36 patients were selected, not on how treatments were assigned.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It makes the placebo group unnecessary, because sex differences are already accounted for.', false, 'A placebo or other comparison group is still needed to measure the drug effect; blocking adjusts only for sex differences.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It eliminates confounding from every lurking variable, including ones the team never measured.', false, 'Blocking only controls the blocked variable (sex); protection against unmeasured variables comes from random assignment, not from the blocks.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It removes blood-pressure variation that is due to sex from the drug-versus-placebo comparison, making a real drug effect easier to detect.', true, 'Sex is a known source of variability in the response. Comparing drug and placebo inside each sex block keeps that variation from blurring the treatment difference, which raises power.' from version_ins;
-- APSTATS-MCQ-SV-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-006-v2', 'mcq', 'Blocking by class period', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A teacher wants to compare a new study app with textbook review. She has 60 students: 30 in a morning section and 30 in an afternoon section. Within each section she randomly assigns half the students to the app and half to the textbook, rather than randomizing all 60 together. What is the primary benefit of this approach?', null, md5('APSTATS-MCQ-SV-006-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It allows the teacher to claim cause and effect, which complete randomization of all 60 students would not allow.', false, 'Random assignment, whether across all 60 students or within blocks, is what supports cause-and-effect conclusions; blocking is not required for that.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It guarantees the class period has no effect on test scores in either treatment group.', false, 'Blocking does not remove the effect of class period; it only prevents that effect from being mixed in with the treatment comparison.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It makes the app and textbook groups larger, which gives more data for the comparison.', false, 'Blocking splits the same 60 students into the same two treatment groups; it adds no students and does not enlarge either group.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It accounts for score differences caused by class period, so differences between the two study methods stand out more clearly.', true, 'Class period may affect scores. Randomizing within each section separates that effect from the app-versus-textbook comparison, reducing unexplained variability.' from version_ins;
-- APSTATS-MCQ-SV-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-006-v3', 'mcq', 'Blocking by dog size', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A veterinary researcher compares two diets for weight loss in 24 dogs: 12 small-breed dogs and 12 large-breed dogs. Diet is randomly assigned separately within the small-breed group and within the large-breed group. Compared with randomly assigning diets to all 24 dogs at once, what does this design mainly accomplish?', null, md5('APSTATS-MCQ-SV-006-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It makes the dogs and owners unaware of which diet each dog receives, so expectations cannot affect results.', false, 'Hiding treatment assignments is blinding, which is a separate feature; grouping dogs by size does not conceal anything from anyone.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It raises the number of dogs in the study from 24 to 48, which strengthens the evidence.', false, 'The same 24 dogs are used either way; splitting them into size groups does not increase the number of animals.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It removes the need for a second diet group because breed size is already being compared.', false, 'The two diets are still compared against each other; breed size is only used to organize the random assignment, not to replace a comparison.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It controls variation in weight loss that is related to breed size, so a real difference between the diets is easier to detect.', true, 'Breed size is expected to influence weight loss. Randomizing within each size group keeps that source of variation from hiding the diet effect.' from version_ins;
-- APSTATS-MCQ-SV-011-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-011-v1', 'mcq', '90% CI for teen proportion', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 600 teenagers in a school district is used to build a 90% confidence interval for the proportion of all teenagers in the district who own a laptop. The interval is (0.29, 0.35). Which statement is a correct interpretation?', null, md5('APSTATS-MCQ-SV-011-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '90% of teenagers in the district own a laptop, give or take 3 percentage points.', false, 'The interval estimates the single population proportion; it does not say that 90% of individuals have the characteristic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is a 90% probability that a new random sample of 600 teenagers will have a sample proportion between 0.29 and 0.35.', false, 'The confidence level does not give the probability that a future sample proportion falls in this particular interval; it concerns the method capturing the population proportion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Between 29% and 35% of the 600 sampled teenagers own a laptop, and we are 90% sure of this.', false, 'The sample proportion is known exactly from the data (and lies in the middle of the interval); the interval estimates the population proportion, not the sample''s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'We are 90% confident that the interval from 0.29 to 0.35 captures the proportion of all teenagers in the district who own a laptop.', true, 'The 90% describes how reliably the interval-building method captures the fixed population proportion over many random samples.' from version_ins;
-- APSTATS-MCQ-SV-011-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-011-v2', 'mcq', 'Meaning of a 95% confidence level', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A news site reports a 95% confidence interval of (0.53, 0.59) for the proportion of registered voters in a county who favor a school bond, using a random sample of 1,000 voters. Which statement correctly explains what the 95% confidence level means?', null, md5('APSTATS-MCQ-SV-011-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 95% of the 1,000 voters in the sample favor the school bond, give or take a few points.', false, 'The confidence level is not a percentage of individuals; the sample proportion of supporters is near 0.56, not 0.95.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 95% of intervals built this way from repeated random samples would contain the true proportion.', true, 'This describes the long-run capture rate of the interval-building method across repeated random samples, which is what the confidence level represents.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a 5% chance that this sample proportion lies outside the interval from 0.53 to 0.59.', false, 'The sample proportion is the midpoint of the interval, so it always lies inside it; the 5% refers to intervals that miss the population value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The probability is 0.95 that the true proportion of supporters in the county is exactly 0.56.', false, 'The true proportion is a single fixed value, and 0.56 is only the sample estimate at the interval''s center; the chance of exact equality is not 0.95.' from version_ins;
-- APSTATS-MCQ-SV-011-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-011-v3', 'mcq', '99% CI for customer satisfaction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company surveys a random sample of 1,200 of its customers and computes a 99% confidence interval of (0.72, 0.78) for the proportion of all its customers who are satisfied. Which statement is a correct interpretation of this interval?', null, md5('APSTATS-MCQ-SV-011-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 99% of the 1,200 surveyed customers gave a satisfaction rating between 0.72 and 0.78.', false, 'The interval gives plausible values for a population proportion; it does not describe how individual customers'' ratings are distributed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'We are 99% confident that the true proportion of all the company''s customers who are satisfied is between 0.72 and 0.78.', true, 'The 99% refers to the reliability of the method: about 99% of intervals constructed this way capture the true customer-satisfaction proportion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a 99% probability that the next customer surveyed will be satisfied.', false, 'The interval says nothing about 0.99 as a probability for one customer; the estimated proportion satisfied is about 0.75.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The true proportion of satisfied customers changes from sample to sample and falls between 0.72 and 0.78 in 99% of samples.', false, 'The population proportion is fixed; it is the interval that changes from sample to sample.' from version_ins;
-- APSTATS-MCQ-SV-026-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-026-v1', 'mcq', 'Birth weight percentile', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pediatrician tells a parent that a baby''s weight is at the 20th percentile for babies of the same age. What does this mean?', null, md5('APSTATS-MCQ-SV-026-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'This baby weighs 20% less than the average baby of the same age.', false, 'Percentile reflects rank within the group, not a percent difference from the mean weight.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 20% of babies that age weigh more than this baby.', false, 'If about 20% weigh more, the baby would be near the 80th percentile; at the 20th percentile it is about 80% who weigh at or above this baby.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 20% of babies that age weigh the same as or less than this baby.', true, 'A percentile gives the percentage of values at or below the given value, so the 20th percentile has about 20% of babies at or below it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'This baby''s weight is 20% of the way from the lightest to the heaviest baby.', false, 'Percentile counts the fraction of individuals at or below a value, not the position of the value within the range from minimum to maximum.' from version_ins;
-- APSTATS-MCQ-SV-026-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-026-v2', 'mcq', 'Computing a percentile from counts', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A class of 40 students takes a quiz. Exactly 32 of the 40 scores, including Dana''s, are less than or equal to Dana''s score. Which percentile is Dana''s score?', null, md5('APSTATS-MCQ-SV-026-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '80th percentile', true, 'Percentile = (number of scores at or below) / (total) x 100 = 32/40 x 100 = 80.' from version_ins
union all select gen_random_uuid(), id, 'B', '20th percentile', false, '8 scores are above Dana''s, and 8/40 = 20%; that is the percentage above her, not at or below.' from version_ins
union all select gen_random_uuid(), id, 'C', '8th percentile', false, '8 is the number of scores above Dana''s; using that count directly as the percentile is neither the percent at or below nor even a percent.' from version_ins
union all select gen_random_uuid(), id, 'D', '32nd percentile', false, '32 is the count of scores at or below Dana''s; it must be divided by 40 and converted to a percent.' from version_ins;
commit;
