begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b2-h-3.7-b','apstats-mcq-b2-sv-h-3.7-b-v1','apstats-mcq-b2-sv-h-3.7-b-v2','apstats-mcq-b2-sv-h-3.7-b-v3','apstats-mcq-b2-h-3.12-b','apstats-mcq-b2-sv-h-3.12-b-v1','apstats-mcq-b2-sv-h-3.12-b-v2','apstats-mcq-b2-sv-h-3.12-b-v3','apstats-mcq-b2-h-3.14-b'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apstats-mcq-b2-h-3.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-h-3.7-b', 'mcq', 'One-proportion z-test: statistic, p-value, conclusion and p-value meaning', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company claims that 40% of its customers renew their subscription. A random sample of 150 customers, a small fraction of all customers, shows that 33% renewed. A manager tests H0: p = 0.40 versus Ha: p < 0.40 at the 5% significance level. Which choice gives the correct test statistic, p-value and conclusion?', null, md5('apstats-mcq-b2-h-3.7-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'z ≈ −1.75 and p ≈ 0.08, so there is not convincing evidence that fewer than 40% of customers renew.', false, 'The alternative is one-sided, so the p-value is not doubled; doubling gives 0.08 and reverses the conclusion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'z ≈ −1.75 and p ≈ 0.04, so there is convincing evidence that fewer than 40% of customers renew.', true, 'Correct: SE = sqrt(0.40 × 0.60 / 150) = 0.04; z = (0.33 − 0.40)/0.04 = −1.75; the lower-tail p-value is 0.040, which is below 0.05.' from version_ins
union all select gen_random_uuid(), id, 'C', 'z ≈ −1.75 and p ≈ 0.04, so there is a 4% probability that the company''s claim is true.', false, 'A p-value is the probability of a result this extreme if H0 is true, not the probability that H0 is true.' from version_ins
union all select gen_random_uuid(), id, 'D', 'z ≈ −1.75 and p ≈ 0.96, so there is not convincing evidence that fewer than 40% of customers renew.', false, 'The alternative p < 0.40 asks for the lower tail, and 0.96 is the upper tail.' from version_ins;
-- apstats-mcq-b2-sv-h-3.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-sv-h-3.7-b-v1', 'mcq', 'One-proportion z-test: statistic, p-value, conclusion and p-value meaning (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A supplier claims that 30% of its parts are defective. A random sample of 250 parts, a small fraction of the shipment, has 35% defective. An inspector tests H0: p = 0.30 versus Ha: p ≠ 0.30 at the 5% significance level. Which choice gives the correct test statistic, p-value and conclusion?', null, md5('apstats-mcq-b2-sv-h-3.7-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'z ≈ 1.72 and p ≈ 0.042, so there is convincing evidence that the proportion differs from 0.30.', false, 'The alternative is two-sided, so the tail area must be doubled; 0.042 is a one-tail area.' from version_ins
union all select gen_random_uuid(), id, 'B', 'z ≈ 1.72 and p ≈ 0.085, so the data prove that the proportion is 0.30.', false, 'Failing to reject does not prove that H0 is true.' from version_ins
union all select gen_random_uuid(), id, 'C', 'z ≈ 1.66 and p ≈ 0.098, so there is not convincing evidence that the proportion differs from 0.30.', false, 'This standard error uses p̂ instead of the hypothesized p0, which is not how a test of a proportion is done.' from version_ins
union all select gen_random_uuid(), id, 'D', 'z ≈ 1.72 and p ≈ 0.085, so there is not convincing evidence that the proportion differs from 0.30.', true, 'Correct: SE = sqrt(0.30 × 0.70 / 250) = 0.0290; z = 0.05/0.0290 = 1.72; the two-sided p-value is 2 × 0.0422 = 0.085 > 0.05.' from version_ins;
-- apstats-mcq-b2-sv-h-3.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-sv-h-3.7-b-v2', 'mcq', 'One-proportion z-test: statistic, p-value, conclusion and p-value meaning (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A town claims that 50% of voters support a measure. A random sample of 400 voters, a small fraction of all voters, has 54.5% in support. A researcher tests H0: p = 0.50 versus Ha: p > 0.50 at the 1% significance level. Which choice gives the correct test statistic, p-value and conclusion?', null, md5('apstats-mcq-b2-sv-h-3.7-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'z ≈ 1.80 and p ≈ 0.036, so there is not convincing evidence that more than 50% support the measure.', true, 'Correct: SE = sqrt(0.5 × 0.5 / 400) = 0.025; z = 0.045/0.025 = 1.80; the upper-tail p-value is 0.036, which is greater than 0.01.' from version_ins
union all select gen_random_uuid(), id, 'B', 'z ≈ 1.80 and p ≈ 0.036, so there is convincing evidence that more than 50% support the measure.', false, 'The p-value 0.036 is below 0.05 but not below the stated significance level of 0.01, so H0 is not rejected.' from version_ins
union all select gen_random_uuid(), id, 'C', 'z ≈ 1.80 and p ≈ 0.072, so there is not convincing evidence that more than 50% support the measure.', false, 'The alternative is one-sided, so the p-value is not doubled.' from version_ins
union all select gen_random_uuid(), id, 'D', 'z ≈ 0.09 and p ≈ 0.46, so there is not convincing evidence that more than 50% support the measure.', false, 'This leaves the sample size out of the standard error, which makes z far too small.' from version_ins;
-- apstats-mcq-b2-sv-h-3.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-sv-h-3.7-b-v3', 'mcq', 'One-proportion z-test: statistic, p-value, conclusion and p-value meaning (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A phone maker claims that 25% of its phones need a repair within a year. In a random sample of 120 phones, a small fraction of all phones, 18% needed a repair. For H0: p = 0.25 versus Ha: p < 0.25, the p-value is about 0.038. Which statement correctly interprets this p-value?', null, md5('apstats-mcq-b2-sv-h-3.7-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is a 3.8% probability that the true proportion is 0.25.', false, 'The p-value is computed assuming the null is true, so it is not the probability that the null is true.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The probability that exactly 18% of a sample of 120 phones need a repair is 3.8%.', false, 'The p-value is a tail probability for results at least this extreme, not the probability of exactly the observed value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'If the true proportion were 0.25, about 3.8% of samples of 120 phones would have a proportion of 0.18 or lower.', true, 'Correct: the p-value is P(p̂ ≤ 0.18 | p = 0.25); here z = (0.18 − 0.25)/sqrt(0.25 × 0.75/120) = −1.77 and the lower-tail area is 0.038.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is a 3.8% probability that the true proportion is less than 0.25.', false, 'A p-value is not the probability of the alternative hypothesis, since the parameter is fixed and not random.' from version_ins;
-- apstats-mcq-b2-h-3.12-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-h-3.12-b', 'mcq', 'Two-proportion z-test conditions and pooled proportion', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two independent random samples, each a small fraction of its population, are used to test H0: p1 − p2 = 0. Sample 1 has 6 successes out of 40 and sample 2 has 9 successes out of 50. Which statement about the large counts condition for the two-proportion z-test is correct?', null, md5('apstats-mcq-b2-h-3.12-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The condition is met, because each sample has at least 5 successes.', false, 'The counts to check are n·p̂c and n·(1 − p̂c) for each sample, and the threshold is 10, not 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The condition is not met, because with the pooled proportion 15/90 ≈ 0.167, the expected successes are 40(0.167) ≈ 6.7 and 50(0.167) ≈ 8.3, both less than 10.', true, 'Correct: pooled p̂c = (6 + 9)/(40 + 50) = 0.167; n1·p̂c = 6.67 and n2·p̂c = 8.33 are below 10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The condition is met, because both sample sizes are at least 30.', false, 'A sample size of at least 30 is not the large counts condition for proportions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The condition is not met, because the sample proportions 0.15 and 0.18 are not equal.', false, 'The sample proportions are not expected to be equal even when H0 is true, and equality is not a condition.' from version_ins;
-- apstats-mcq-b2-sv-h-3.12-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-sv-h-3.12-b-v1', 'mcq', 'Two-proportion z-test conditions and pooled proportion (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An analyst takes an independent random sample of 40 workers from a plant of 300 workers and a sample of 50 workers from a plant of 600 workers, and plans a two-proportion z-test of H0: p1 − p2 = 0. In sample 1, 18 workers are satisfied; in sample 2, 25 are satisfied. Which condition is NOT met?', null, md5('apstats-mcq-b2-sv-h-3.12-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The independence (10%) condition for sample 1, because 40 is more than 10% of 300.', true, 'Correct: 40/300 = 13.3% > 10%, while 50/600 = 8.3%; pooled p̂c = 43/90 = 0.478, so all counts are far above 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The large counts condition, because 18 is less than 25.', false, 'Large counts uses the pooled proportion with each sample size, and all those counts are well above 10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The random condition, because the plants have different sizes.', false, 'The plants can have different sizes, and the random condition is about how each sample was selected.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All conditions are met, because both samples are random.', false, 'The 10% condition fails for sample 1, so being random is not enough.' from version_ins;
-- apstats-mcq-b2-sv-h-3.12-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-sv-h-3.12-b-v2', 'mcq', 'Two-proportion z-test conditions and pooled proportion (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A statistician carries out a two-proportion z-test of H0: p1 − p2 = 0 and uses the pooled proportion in the standard error. Which statement best explains why the pooled proportion is used for the test?', null, md5('apstats-mcq-b2-sv-h-3.12-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The pooled proportion is always closer to the true value than either sample proportion, even when H0 is false.', false, 'When H0 is false the two populations differ, so a single pooled value does not estimate either population well.' from version_ins
union all select gen_random_uuid(), id, 'B', 'If H0 is true, both samples come from populations with the same proportion, so the combined sample gives the best single estimate of that proportion.', true, 'Correct: under H0 the common proportion p is estimated by total successes over total trials; the standard error is computed assuming H0 is true.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Pooling always makes the standard error larger, which guarantees that the test is conservative.', false, 'Pooling changes the standard error in either direction depending on the data, and it does not guarantee a conservative test.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The pooled proportion is also used for confidence intervals, so the test and the interval must agree.', false, 'A confidence interval for a difference does not assume equal proportions, so it uses the two sample proportions separately.' from version_ins;
-- apstats-mcq-b2-sv-h-3.12-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-sv-h-3.12-b-v3', 'mcq', 'Two-proportion z-test conditions and pooled proportion (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Volunteers are randomly assigned to two treatments: 30 of 60 improve with treatment 1 and 28 of 70 improve with treatment 2. A student plans a two-proportion z-test of H0: p1 − p2 = 0. Which statement is correct?', null, md5('apstats-mcq-b2-sv-h-3.12-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The conditions are met: the treatments were randomly assigned and, with the pooled proportion 58/130 ≈ 0.446, all expected counts are at least 10.', true, 'Correct: random assignment replaces random sampling in an experiment, so the 10% condition is not needed; 60(0.446) ≈ 26.8, 60(0.554) ≈ 33.2, 70(0.446) ≈ 31.2, 70(0.554) ≈ 38.8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The test cannot be done, because the volunteers were not randomly sampled from a population.', false, 'In an experiment, random assignment of treatments takes the place of random sampling for the conditions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The test is not appropriate, because 130 volunteers is not less than 10% of any population.', false, 'The 10% condition applies to sampling without replacement from a population, and not to randomly assigned groups.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The large counts condition is not met, because 28 is less than 30.', false, 'The large counts condition uses the pooled proportion, and all of those counts are above 10.' from version_ins;
-- apstats-mcq-b2-h-3.14-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-h-3.14-b', 'mcq', 'Chi-square hypotheses and expected-count condition', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 200 residents of a city is classified by age group (3 groups) and by usual transportation mode (4 modes). Which hypotheses are appropriate for a chi-square test?', null, md5('apstats-mcq-b2-h-3.14-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: In the sample, the proportion using each mode is the same in every age group. Ha: In the sample, the proportions differ.', false, 'Hypotheses are about the population, not the sample, and this setup would suit a test of homogeneity with separate samples.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: The four transportation modes are equally likely. Ha: The four transportation modes are not equally likely.', false, 'This describes a goodness-of-fit test for a single variable and does not involve two variables.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: Age group and transportation mode are independent in the population of residents. Ha: Age group and transportation mode are not independent.', true, 'Correct: one sample classified on two categorical variables calls for a test of independence, with hypotheses about the population.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: Age group and transportation mode are independent. Ha: Age group and transportation mode are positively correlated.', false, 'Correlation applies to quantitative variables, and the alternative for a chi-square test is only that the variables are not independent.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b2-h-3.7-b','apstats-mcq-b2-sv-h-3.7-b-v1','apstats-mcq-b2-sv-h-3.7-b-v2','apstats-mcq-b2-sv-h-3.7-b-v3','apstats-mcq-b2-h-3.12-b','apstats-mcq-b2-sv-h-3.12-b-v1','apstats-mcq-b2-sv-h-3.12-b-v2','apstats-mcq-b2-sv-h-3.12-b-v3','apstats-mcq-b2-h-3.14-b']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b2-h-3.7-b','apstats-mcq-b2-sv-h-3.7-b-v1','apstats-mcq-b2-sv-h-3.7-b-v2','apstats-mcq-b2-sv-h-3.7-b-v3','apstats-mcq-b2-h-3.12-b','apstats-mcq-b2-sv-h-3.12-b-v1','apstats-mcq-b2-sv-h-3.12-b-v2','apstats-mcq-b2-sv-h-3.12-b-v3','apstats-mcq-b2-h-3.14-b']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
