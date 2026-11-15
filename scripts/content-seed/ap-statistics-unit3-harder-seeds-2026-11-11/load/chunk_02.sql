begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-3.8-A','APSTATS-MCQ-H-3.8-B','APSTATS-MCQ-H-3.8-C','APSTATS-MCQ-H-3.9-A','APSTATS-MCQ-H-3.10-A','APSTATS-MCQ-H-3.11-A','APSTATS-MCQ-H-3.12-A','APSTATS-MCQ-H-3.13-A','APSTATS-MCQ-H-3.14-A'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- APSTATS-MCQ-H-3.8-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.8-A', 'mcq', 'Power and Type II error in context', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A test of H0: p = 0.50 versus Ha: p > 0.50 uses a significance level of alpha = 0.05. The test has power 0.70 against the alternative p = 0.60. Which statement is correct?', null, md5('APSTATS-MCQ-H-3.8-A'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is a 70% chance that the true proportion is 0.60.', false, 'Power is a probability about the test''s decision, computed for an assumed true value, not a probability about the parameter.' from version_ins
union all select gen_random_uuid(), id, 'B', 'If the true proportion is 0.50, there is a 70% chance that the test rejects H0.', false, 'Rejecting a true H0 is a Type I error, whose probability is alpha = 0.05.' from version_ins
union all select gen_random_uuid(), id, 'C', 'If the true proportion is 0.60, there is a 30% chance that the test fails to reject H0, which would be a Type II error.', true, 'Correct: Type II error probability = 1 - power = 0.30.' from version_ins
union all select gen_random_uuid(), id, 'D', 'If the true proportion is 0.60, there is a 5% chance that the test makes a Type II error.', false, '0.05 is the probability of a Type I error, not a Type II error.' from version_ins;
-- APSTATS-MCQ-H-3.8-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.8-B', 'mcq', 'Trade-off between Type I and Type II error', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher wants a test that has a smaller probability of a Type I error and also a smaller probability of a Type II error against a particular alternative value. Which plan can accomplish both?', null, md5('APSTATS-MCQ-H-3.8-B'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Lower alpha and keep the sample size the same.', false, 'With the sample size fixed, lowering alpha makes rejecting harder, which raises the Type II error probability.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Lower alpha and increase the sample size enough to shrink the standard error.', true, 'Correct: lowering alpha alone raises the Type II probability; a larger n shrinks the standard error and lowers the Type II probability, offsetting the loss.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Raise alpha and increase the sample size.', false, 'Raising alpha raises the Type I error probability.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Keep alpha the same and decrease the sample size.', false, 'A smaller sample increases the standard error and the Type II error probability, and leaves the Type I probability at alpha.' from version_ins;
-- APSTATS-MCQ-H-3.8-C
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.8-C', 'mcq', 'Type II error from a framed null hypothesis', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An airport tests each bag with a procedure that tests H0: the bag contains no prohibited item versus Ha: the bag contains a prohibited item. Rejecting H0 means the bag is flagged. Which statement correctly describes a Type II error?', null, md5('APSTATS-MCQ-H-3.8-C'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Type II error: a bag with a prohibited item is not flagged, so H0 is not rejected even though it is false.', true, 'Correct: Type II means failing to reject a false H0; here H0 (no prohibited item) is false when the bag contains one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Type II error: a bag with no prohibited item is flagged and searched, which delays the passenger.', false, 'Flagging a bag that has no prohibited item rejects a true H0, which is a Type I error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Type I error: a bag with a prohibited item is not flagged and is allowed through.', false, 'The situation described is right, but it is a Type II error, not a Type I error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Type II error: a bag with a prohibited item is flagged and removed.', false, 'Flagging a bag that contains a prohibited item is the correct decision, not an error.' from version_ins;
-- APSTATS-MCQ-H-3.9-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.9-A', 'mcq', 'Sampling distribution of a difference of sample proportions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Among all users of app A, 40% renew their subscription, and among all users of app B, 25% renew. Independent random samples of 200 users of app A and 150 users of app B are selected, and the difference in sample proportions (p-hat A - p-hat B) is recorded. Which statement describes its sampling distribution?', null, md5('APSTATS-MCQ-H-3.9-A'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Approximately normal with mean 0.15 and standard deviation 0.0700.', false, 'Added the two standard deviations instead of adding the two variances and taking the square root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Approximately normal with mean 0.15 and standard deviation 0.0495.', true, 'Correct: mean = 0.40 - 0.25 = 0.15; variance = 0.4(0.6)/200 + 0.25(0.75)/150 = 0.00245; SD = 0.0495; counts 80, 120, 37.5, 112.5 are all at least 10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Approximately normal with mean 1.6 and standard deviation 0.0495.', false, 'Divided the two proportions instead of subtracting them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Approximately normal with mean 0.15 and standard deviation 0.00245.', false, 'Reported the variance as the standard deviation.' from version_ins;
-- APSTATS-MCQ-H-3.10-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.10-A', 'mcq', 'Interpret an interval for a difference of proportions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An online retailer randomly assigns visitors to see site A or site B. A 95% confidence interval for p_A - p_B, where p_A and p_B are the proportions of all visitors who would make a purchase using site A and site B, is (0.02, 0.14). Which interpretation is correct?', null, md5('APSTATS-MCQ-H-3.10-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'We are 95% confident that the proportion of all visitors who purchase using site A is between 0.02 and 0.14 higher than the proportion using site B.', true, 'Correct: the interval is for p_A - p_B and is entirely positive, so p_A is larger.' from version_ins
union all select gen_random_uuid(), id, 'B', 'We are 95% confident that between 2% and 14% of all visitors make a purchase.', false, 'The interval estimates a difference between two proportions, not a single proportion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a 95% probability that p-hat A - p-hat B in a new sample will be between 0.02 and 0.14.', false, 'The confidence level refers to the method capturing the population difference, not to a future sample statistic.' from version_ins
union all select gen_random_uuid(), id, 'D', 'We are 95% confident that the proportion of all visitors who purchase using site B is between 0.02 and 0.14 higher than the proportion using site A.', false, 'Reversed the direction; a positive p_A - p_B means site A is higher.' from version_ins;
-- APSTATS-MCQ-H-3.11-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.11-A', 'mcq', 'Claim from an interval for a difference of proportions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company randomly samples users of its new app and its old app. A 95% confidence interval for p_new - p_old, the difference in the proportions of all users who renew, is (-0.11, -0.02). A manager claims the new app lowered the renewal rate. Which conclusion is best?', null, md5('APSTATS-MCQ-H-3.11-A'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The interval does not support the claim, because a proportion cannot be negative.', false, 'The interval is for a difference between proportions, which can be negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The interval shows the new app raised the renewal rate, because the interval is centered near zero.', false, 'Negative values mean the new proportion is smaller.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The interval supports the claim, because every plausible value of p_new - p_old is negative, so the new app''s renewal proportion is lower.', true, 'Correct: all plausible differences new - old are below 0; midpoint -0.065.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interval shows the renewal rate fell by exactly 6.5 percentage points.', false, 'The midpoint is the sample difference; the interval gives a range of plausible values for the population difference.' from version_ins;
-- APSTATS-MCQ-H-3.12-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.12-A', 'mcq', 'Hypotheses for a difference of proportions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A teacher wants to test whether the proportion of students who pass an exam is higher when students use study app A than when they use study app B. In independent random samples, 60 of 100 students using app A passed and 66 of 100 students using app B passed. Which hypotheses should the teacher test?', null, md5('APSTATS-MCQ-H-3.12-A'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: p_A - p_B = 0 versus Ha: p_A - p_B < 0, where p_A and p_B are the proportions of all students who would pass using each app.', false, 'Followed the sample result (app A is lower in the sample) instead of the question.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: p-hat A - p-hat B = 0 versus Ha: p-hat A - p-hat B > 0.', false, 'Hypotheses are about population parameters, not sample statistics.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: p_A - p_B = 0 versus Ha: p_A - p_B > 0, where p_A and p_B are the proportions of all students who would pass using each app.', true, 'Correct: the question is whether app A is higher; the null is no difference; the sample difference of -0.06 is data.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: p_A - p_B = -0.06 versus Ha: p_A - p_B > -0.06, where p_A and p_B are the proportions of all students who would pass using each app.', false, 'Used the sample difference as the null value, but the null value for a difference of proportions is 0.' from version_ins;
-- APSTATS-MCQ-H-3.13-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.13-A', 'mcq', 'Two-proportion z-test with pooled standard error', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In an email campaign, 84 of 150 customers randomly assigned to version A clicked a link, and 90 of 200 customers randomly assigned to version B clicked. A test of H0: p_A = p_B versus Ha: p_A != p_B uses the pooled proportion 174/350 = 0.497. For a standard normal distribution, P(Z > 2.04) = 0.021. Which result is correct at alpha = 0.05?', null, md5('APSTATS-MCQ-H-3.13-A'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'z = 2.04, p-value = 0.021; reject H0, so there is convincing evidence that the click rates differ.', false, 'Used a one-sided tail area for a two-sided alternative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'z = 2.04, p-value = 0.042; reject H0, so there is convincing evidence that the click rates differ.', true, 'Correct: p-hat A = 0.56, p-hat B = 0.45; SE = sqrt(0.497 x 0.503 x (1/150 + 1/200)) = 0.054; z = 0.11 / 0.054 = 2.04; two-sided p = 2(0.021) = 0.042 < 0.05.' from version_ins
union all select gen_random_uuid(), id, 'C', 'z = 4.12, p-value < 0.001; reject H0, so there is convincing evidence that the click rates differ.', false, 'Divided the pooled variance by n1 + n2 instead of using 1/n1 + 1/n2, which makes the standard error far too small.' from version_ins
union all select gen_random_uuid(), id, 'D', 'z = 2.04, p-value = 0.042; fail to reject H0, because 0.042 is greater than 0.025.', false, 'Split alpha across two tails twice; for a two-sided test the p-value is compared with alpha itself.' from version_ins;
-- APSTATS-MCQ-H-3.14-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-3.14-A', 'mcq', 'Homogeneity or independence, and degrees of freedom', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school district randomly selects 150 students from each of three high schools and asks each student to choose a preferred lunch option from four choices. The district wants to know whether the distribution of preferred lunch option is the same at all three schools. Which test and degrees of freedom are correct?', null, md5('APSTATS-MCQ-H-3.14-A'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A test of independence, with df = 6.', false, 'Independence applies when one sample is classified on two variables, not when separate samples are taken from each school.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A test of homogeneity, with df = 12.', false, 'Used rows times columns instead of (rows - 1)(columns - 1).' from version_ins
union all select gen_random_uuid(), id, 'C', 'A test of homogeneity, with df = 3 + 4 - 2 = 5.', false, 'Added the numbers of rows and columns minus 2, which is not how degrees of freedom are found for a table.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A test of homogeneity, with df = (3 - 1)(4 - 1) = 6.', true, 'Correct: separate random samples from three populations classified on one categorical variable gives homogeneity; df = (rows - 1)(columns - 1) = 2 x 3 = 6.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-3.8-A','APSTATS-MCQ-H-3.8-B','APSTATS-MCQ-H-3.8-C','APSTATS-MCQ-H-3.9-A','APSTATS-MCQ-H-3.10-A','APSTATS-MCQ-H-3.11-A','APSTATS-MCQ-H-3.12-A','APSTATS-MCQ-H-3.13-A','APSTATS-MCQ-H-3.14-A']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-H-3.8-A','APSTATS-MCQ-H-3.8-B','APSTATS-MCQ-H-3.8-C','APSTATS-MCQ-H-3.9-A','APSTATS-MCQ-H-3.10-A','APSTATS-MCQ-H-3.11-A','APSTATS-MCQ-H-3.12-A','APSTATS-MCQ-H-3.13-A','APSTATS-MCQ-H-3.14-A']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
