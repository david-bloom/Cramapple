begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-3.1-A','APSTATS-MCQ-H-3.2-A','APSTATS-MCQ-H-3.3-A','APSTATS-MCQ-H-3.3-B','APSTATS-MCQ-H-3.4-B','APSTATS-MCQ-H-3.5-A','APSTATS-MCQ-H-3.6-A','APSTATS-MCQ-H-3.6-B','APSTATS-MCQ-H-3.7-A'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- APSTATS-MCQ-H-3.1-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.1-A', 'mcq', 'Bias versus variability of an estimator', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A statistician simulates 1,000 random samples of size 50 from a population whose true proportion is 0.30 and records two estimators of that proportion. Estimator X has a sampling distribution centered at 0.30 with a standard deviation of 0.065. Estimator Y has a sampling distribution centered at 0.36 with a standard deviation of 0.020. The statistician then repeats the simulation with samples of size 200. Which statement is correct?', null, md5('APSTATS-MCQ-H-3.1-A'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Estimator Y is better, because its smaller standard deviation means its estimates are closer to 0.30 on average.', false, 'A small standard deviation measures consistency, not accuracy, and Y''s estimates cluster around 0.36, not 0.30.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Estimator X is unbiased but more variable; samples of size 200 should reduce its variability, but they would not remove Y''s bias.', true, 'Correct: X is centered at the true value 0.30 (unbiased); Y is centered 0.06 above it (biased). Larger n shrinks the spread, not the center.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Estimator X is biased, because many individual estimates differ from 0.30.', false, 'Bias refers to the center of the sampling distribution, and individual estimates varying around 0.30 is variability, not bias.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Estimator Y''s bias should disappear at n = 200, because larger samples remove bias.', false, 'Bias comes from the estimator or the sampling method, so a larger sample only makes Y cluster more tightly around 0.36.' from version_ins;
-- APSTATS-MCQ-H-3.2-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.2-A', 'mcq', 'Standardize a sample proportion', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a large city, 30% of households recycle. A random sample of 200 households is selected, and 38% of the sampled households recycle. Which statement is correct?', null, md5('APSTATS-MCQ-H-3.2-A'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sample proportion is about 35 standard deviations above 0.30, since the standard deviation of the sampling distribution is 0.0023.', false, 'Divided sqrt[p(1 - p)] by n instead of taking the square root of p(1 - p)/n, which makes the standard deviation far too small.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sample proportion is about 2.5 standard deviations above 0.30, so a result this large would be unusual if the true proportion were 0.30.', true, 'Correct: SD = sqrt(0.30 x 0.70 / 200) = 0.0324; z = 0.08 / 0.0324 = 2.47.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sample proportion is about 76 standard deviations above 0.30, since the standard deviation of the sampling distribution is 0.00105.', false, 'Used the variance p(1 - p)/n as if it were the standard deviation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sample proportion is only 0.08 above 0.30, so it is within normal sampling variability for any sample size.', false, 'Whether a difference is unusual depends on its size relative to the standard deviation, which shrinks as the sample size grows.' from version_ins;
-- APSTATS-MCQ-H-3.3-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.3-A', 'mcq', 'Margin of error under combined changes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 90% confidence interval for a population proportion, based on a random sample of 400 people, has a margin of error of 0.04. A second interval uses a random sample of 1,600 people from the same population, at a 99% confidence level, with about the same sample proportion. About what is its margin of error?', null, md5('APSTATS-MCQ-H-3.3-A'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.016', false, 'Divided by 4 for the sample size instead of 2, then applied the critical value change.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.063', false, 'Accounted for the higher confidence level but ignored the larger sample.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.020', false, 'Accounted for the larger sample but ignored the higher confidence level.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.031', true, 'Correct: quadrupling n halves the margin to 0.02; the critical value rises from 1.645 to 2.576, a factor of 1.566; 0.02 x 1.566 = 0.0313.' from version_ins;
-- APSTATS-MCQ-H-3.3-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.3-B', 'mcq', 'Sample size using a pilot estimate', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher wants a 95% confidence interval for a population proportion with a margin of error no larger than 0.04. A pilot study estimated the proportion to be about 0.20. Using z* = 1.96 and the pilot estimate, what is the smallest sample size that guarantees this margin of error?', null, md5('APSTATS-MCQ-H-3.3-B'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '601', false, 'Ignored the pilot estimate and used the conservative p = 0.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '384', false, 'Rounded 384.16 down, which would give a margin slightly above 0.04.' from version_ins
union all select gen_random_uuid(), id, 'C', '481', false, 'Used p = 0.20 in place of p(1 - p) = 0.16.' from version_ins
union all select gen_random_uuid(), id, 'D', '385', true, 'Correct: n >= 1.96^2 (0.20)(0.80) / 0.04^2 = 384.16, so n = 385.' from version_ins;
-- APSTATS-MCQ-H-3.4-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.4-B', 'mcq', 'Recover p-hat and margin from an interval, then judge a claim', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of adults is used to construct a 95% confidence interval for the proportion who prefer a new product to the current one. The interval is (0.44, 0.56). The marketing manager says, "A majority of adults prefer the new product." Which statement is correct?', null, md5('APSTATS-MCQ-H-3.4-B'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sample proportion was 0.50 with a margin of error of 0.06, and since 0.50 and values below it are plausible, the interval does not support a majority.', true, 'Correct: p-hat = (0.44 + 0.56)/2 = 0.50; margin of error = (0.56 - 0.44)/2 = 0.06; 0.44 to 0.50 are plausible values below a majority.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The interval supports the claim, because the upper endpoint 0.56 is above 0.50.', false, 'A claim is supported only when every plausible value agrees with it, and this interval also contains values at or below 0.50.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sample proportion was 0.56 and the margin of error was 0.12, so the claim is supported.', false, 'The sample proportion is the midpoint of the interval, and the margin of error is half its width.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interval shows that exactly 50% of adults prefer the new product, so the claim is false.', false, 'A confidence interval gives a range of plausible values, not a single exact value, so it cannot show that the proportion equals 0.50.' from version_ins;
-- APSTATS-MCQ-H-3.5-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.5-A', 'mcq', 'Hypotheses from the research question', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mayor claims that at most 30% of residents oppose a new bike lane. A reporter wants to test whether the true proportion who oppose it is greater than 30%. In a random sample of 150 residents, 40 oppose the bike lane (about 27%). Which hypotheses should the reporter test?', null, md5('APSTATS-MCQ-H-3.5-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: p = 0.30, Ha: p > 0.30, where p is the proportion of all residents who oppose the bike lane.', true, 'Correct: the question asks about more than 30%; the null sets p to the claimed 0.30; the sample 0.27 is data, not part of the hypotheses.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: p = 0.30, Ha: p < 0.30, where p is the proportion of all residents who oppose the bike lane.', false, 'Chose the direction suggested by the sample result (0.27 is below 0.30) instead of the question being asked.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: p = 0.27, Ha: p > 0.27, where p is the proportion of all residents who oppose the bike lane.', false, 'Set the null value equal to the sample proportion, but hypotheses use the claimed value, not data.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: p-hat = 0.30, Ha: p-hat > 0.30, where p-hat is the proportion of sampled residents who oppose the bike lane.', false, 'Hypotheses must be about the population parameter p, not about the sample statistic p-hat.' from version_ins;
-- APSTATS-MCQ-H-3.6-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.6-A', 'mcq', 'p-value for a one- or two-sided alternative', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A significance test of H0: p = 0.50 versus Ha: p != 0.50 gives a test statistic z = 1.80. For a standard normal distribution, P(Z > 1.80) = 0.036. Using a significance level of alpha = 0.05, which conclusion is correct?', null, md5('APSTATS-MCQ-H-3.6-A'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Reject H0, because the p-value is 0.036, which is less than 0.05.', false, 'Used a one-sided tail area for a two-sided alternative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fail to reject H0, because the two-sided p-value is 2(0.036) = 0.072, which is greater than 0.05.', true, 'Correct: for Ha: p != 0.50 the p-value counts both tails, 2 x 0.0359 = 0.072 > 0.05.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Reject H0, because z = 1.80 is greater than 1.', false, 'Compared z with 1 instead of comparing the p-value with alpha.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Fail to reject H0, because 0.072 means there is a 7.2% chance that H0 is true.', false, 'The decision is right, but a p-value is not the probability that H0 is true.' from version_ins;
-- APSTATS-MCQ-H-3.6-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.6-B', 'mcq', 'Statistical versus practical significance', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company claims that 50% of its customers renew their subscription. An analyst tests H0: p = 0.50 versus Ha: p != 0.50 using a random sample of 50,000 customers, of whom 50.6% renew. The p-value is about 0.007. Which conclusion is best?', null, md5('APSTATS-MCQ-H-3.6-B'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is convincing evidence that the renewal rate is far from 50%, because the p-value is so small.', false, 'A small p-value says the difference is unlikely to be chance, not that it is large; with n this big even a small difference is detectable.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is a 0.7% chance that the renewal rate is exactly 50%, so the company''s claim is nearly certainly false.', false, 'A p-value is computed assuming H0 is true, so it is not the probability that H0 is true.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is convincing evidence that the renewal rate differs from 50%, but the sample difference is only about 0.6 percentage points, so the difference may be too small to matter in practice.', true, 'Correct: SE = sqrt(0.5 x 0.5 / 50,000) = 0.00224; z = 0.006 / 0.00224 = 2.7; two-sided p about 0.007.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is no evidence of a difference, because 50.6% is very close to 50%.', false, 'The p-value of 0.007 is below common significance levels, so the evidence of a difference is convincing even though the difference is small.' from version_ins;
-- APSTATS-MCQ-H-3.7-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.7-A', 'mcq', 'Conditions for a one-sample z-test use p0', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A delivery company claims that 92% of its packages arrive on time. A random sample of 80 packages is selected from the company''s very large volume of shipments, and 70 of them (87.5%) arrive on time. An analyst plans a one-sample z-test of H0: p = 0.92 versus Ha: p < 0.92. Which statement about the conditions for the test is correct?', null, md5('APSTATS-MCQ-H-3.7-A'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The large counts condition is met, because np-hat = 70 and n(1 - p-hat) = 10 are both at least 10.', false, 'The conditions for a test use the hypothesized proportion p0, not the sample proportion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The large counts condition is not met, because n(1 - p0) = 80(0.08) = 6.4 is less than 10.', true, 'Correct: np0 = 73.6 and n(1 - p0) = 6.4; the 10% condition holds since the shipments are very numerous.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The large counts condition is met, because the sample size of 80 is greater than 30.', false, 'The sample-size rule of 30 is for means; for proportions the large counts condition is what matters.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The independence condition is not met, because the packages were sampled without replacement.', false, 'Sampling without replacement is fine when the sample is less than 10% of a very large population.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-3.1-A','APSTATS-MCQ-H-3.2-A','APSTATS-MCQ-H-3.3-A','APSTATS-MCQ-H-3.3-B','APSTATS-MCQ-H-3.4-B','APSTATS-MCQ-H-3.5-A','APSTATS-MCQ-H-3.6-A','APSTATS-MCQ-H-3.6-B','APSTATS-MCQ-H-3.7-A']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-H-3.1-A','APSTATS-MCQ-H-3.2-A','APSTATS-MCQ-H-3.3-A','APSTATS-MCQ-H-3.3-B','APSTATS-MCQ-H-3.4-B','APSTATS-MCQ-H-3.5-A','APSTATS-MCQ-H-3.6-A','APSTATS-MCQ-H-3.6-B','APSTATS-MCQ-H-3.7-A']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
