begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-051-v2','APSTATS-MCQ-SV-051-v3','APSTATS-MCQ-SV-057-v2','APSTATS-MCQ-SV-061-v1','APSTATS-MCQ-SV-061-v2','APSTATS-MCQ-SV-061-v3','APSTATS-MCQ-SV-071-v1','APSTATS-MCQ-SV-071-v2','APSTATS-MCQ-SV-071-v3','APSTATS-MCQ-SV-080-v1','APSTATS-MCQ-SV-080-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-051-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-051-v2', 'mcq', 'Soccer and orchestra overlap', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student is chosen at random from a school. Event S is that the student plays on the soccer team and event O is that the student plays in the school orchestra. Are S and O mutually exclusive?', null, md5('APSTATS-MCQ-SV-051-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'No, but only if S and O are independent.', false, 'Whether they overlap does not depend on independence; the events can occur together in either case.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Yes, because P(S and O) must equal P(S)P(O).', false, 'P(S and O) = P(S)P(O) is the independence condition, not a test for exclusive events, whose joint probability is 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Yes, because soccer and orchestra are different activities.', false, 'Different activities do not prevent overlap; a student can do both, so P(S and O) can be greater than 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No, because a student can play on the soccer team and also play in the orchestra.', true, 'Events are mutually exclusive only if they cannot occur together; nothing prevents one student from doing both.' from version_ins;
-- APSTATS-MCQ-SV-051-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-051-v3', 'mcq', 'Addition rule for exclusive events', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bag holds marbles of several colors. One marble is drawn at random. The probability it is red is 0.30 and the probability it is blue is 0.45. What is the probability that the marble is red or blue?', null, md5('APSTATS-MCQ-SV-051-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.15', false, 'This is the difference 0.45 - 0.30 and does not represent the chance of either color.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.615', false, 'This subtracts 0.135 as if red and blue could overlap, but a marble cannot be both, so nothing is subtracted.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.135', false, 'This multiplies the probabilities (0.30 x 0.45), which would apply to independent events occurring together, not to ''or'' for exclusive events.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.75', true, 'A marble cannot be both red and blue, so the events are mutually exclusive and P(red or blue) = 0.30 + 0.45 = 0.75.' from version_ins;
-- APSTATS-MCQ-SV-057-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-057-v2', 'mcq', 'Small vs large samples from skewed population', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population of household incomes is strongly right-skewed. A statistician draws many random samples of size n = 2 and many of size n = 100, and plots the sample means from each. Which statement is correct?', null, md5('APSTATS-MCQ-SV-057-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The means from n = 100 will look approximately normal, but the means from n = 2 will still be noticeably right-skewed.', true, 'The CLT needs a sufficiently large sample size; with n = 2 the sampling distribution retains much of the population''s skew.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The n = 2 means will look more normal than the n = 100 means, because small samples contain less skew.', false, 'Normality of the sampling distribution improves as n increases, so n = 100 is much closer to normal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both sets of sample means will look approximately normal, because every mean is an average.', false, 'Averaging alone is not enough; with a sample as small as 2 the shape stays close to the skewed population.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither set will look normal, because a skewed population cannot give a normal sampling distribution.', false, 'The CLT says that for a large enough n, the sampling distribution of means is approximately normal for nearly any population shape.' from version_ins;
-- APSTATS-MCQ-SV-061-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-061-v1', 'mcq', 'SE of p-hat for p=0.3', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose 30% of all students at a university commute by bike. A random sample of n = 200 students is selected. What is the standard deviation (standard error) of the sampling distribution of the sample proportion of bike commuters?', null, md5('APSTATS-MCQ-SV-061-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sqrt[0.3(0.7)]/200 ~ 0.0023', false, 'The division by n belongs inside the square root; sqrt(0.21)/200 is about 0.0023.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.3(0.7)/200 ~ 0.0011', false, 'This is the variance 0.00105; the square root was not taken.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sqrt[0.3(0.7)/200] ~ 0.032', true, 'sqrt(p(1-p)/n) = sqrt(0.21/200) = sqrt(0.00105) ~ 0.032.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sqrt[0.3/200] ~ 0.039', false, 'This omits the factor (1 - p); sqrt(0.3/200) is about 0.039.' from version_ins;
-- APSTATS-MCQ-SV-061-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-061-v2', 'mcq', 'SE of p-hat for p=0.55', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a large city, 55% of residents support a new park. A random sample of n = 150 residents is taken. Find the standard deviation of the sampling distribution of the sample proportion in favor.', null, md5('APSTATS-MCQ-SV-061-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sqrt[0.55(0.45)]/150 ~ 0.0033', false, 'n must be inside the radical; sqrt(0.2475)/150 is about 0.0033.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sqrt[0.55/150] ~ 0.061', false, 'This leaves out (1 - p); sqrt(0.55/150) is about 0.061.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sqrt[0.55(0.45)/150] ~ 0.041', true, 'sqrt(0.55 x 0.45 / 150) = sqrt(0.2475/150) = sqrt(0.00165) ~ 0.041.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.55(0.45)/150 ~ 0.0017', false, 'This is the variance 0.00165; the square root is missing.' from version_ins;
-- APSTATS-MCQ-SV-061-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-061-v3', 'mcq', 'SE of p-hat for p=0.12', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A factory knows that 12% of its widgets are defective. An inspector randomly selects n = 400 widgets. What is the standard deviation of the sampling distribution of the sample proportion of defective widgets?', null, md5('APSTATS-MCQ-SV-061-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sqrt[0.12(0.88)/400] ~ 0.016', true, 'sqrt(0.12 x 0.88 / 400) = sqrt(0.1056/400) = sqrt(0.000264) ~ 0.016.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.12(0.88)/sqrt(400) ~ 0.0053', false, 'The square root applies to the whole fraction p(1-p)/n, not just to n; the correct value is about 0.016.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sqrt[0.12/400] ~ 0.017', false, 'This drops (1 - p); sqrt(0.12/400) is about 0.017, which is not the correct standard error.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.12(0.88)/400 ~ 0.0003', false, 'This is the variance 0.000264; the square root was never taken.' from version_ins;
-- APSTATS-MCQ-SV-071-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-071-v1', 'mcq', 'Power and significance level', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two researchers test the same hypotheses about a population proportion using the same sample size and the same true proportion. Researcher 1 uses a significance level of alpha = 0.10 and Researcher 2 uses alpha = 0.01. Which test has greater power?', null, md5('APSTATS-MCQ-SV-071-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Researcher 2''s test, because a lower Type I error rate also means a lower Type II error rate.', false, 'Lowering alpha raises the chance of a Type II error, so power falls.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Researcher 1''s test, because a larger alpha makes rejecting the null hypothesis easier when it is false.', true, 'Increasing alpha enlarges the rejection region, which raises the probability of rejecting a false null, so power is higher.' from version_ins
union all select gen_random_uuid(), id, 'C', 'They have equal power, because both use the same hypotheses and sample size.', false, 'Power also depends on alpha; changing it changes the rejection region and therefore the power.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Researcher 2''s test, because a smaller alpha requires stronger evidence.', false, 'Demanding stronger evidence makes it harder to reject, which lowers power.' from version_ins;
-- APSTATS-MCQ-SV-071-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-071-v2', 'mcq', 'Power and distance from the null', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two tests of H0: p = 0.50 vs Ha: p > 0.50 use the same sample size and significance level. In one situation the true proportion is 0.55, and in the other the true proportion is 0.70. Which situation gives the test greater power?', null, md5('APSTATS-MCQ-SV-071-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'They have the same power, because the sample size and alpha are the same.', false, 'Power also depends on how far the true value is from the null, so these two situations differ.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The situation with true p = 0.55, because it is closer to the null value.', false, 'A smaller gap is harder to detect, which lowers power.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The situation with true p = 0.70, because a larger gap from the null value makes a false null easier to detect.', true, 'The farther the true parameter lies from the hypothesized value, the greater the probability of rejecting H0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The situation with true p = 0.55, because power equals the Type I error probability alpha.', false, 'Power is the probability of rejecting a false null (1 minus Type II error), not alpha.' from version_ins;
-- APSTATS-MCQ-SV-071-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-071-v3', 'mcq', 'Meaning of power (tutoring)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school district tests H0: a new tutoring program does not change mean reading scores against Ha: the program raises mean reading scores. In this setting, what does the power of the test measure for a particular size of improvement?', null, md5('APSTATS-MCQ-SV-071-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The chance the test rejects H0 when the program has no effect on scores.', false, 'Rejecting a true null hypothesis is a Type I error, and its probability is alpha, not power.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The chance the test rejects H0 when the program truly raises scores by that amount.', true, 'Power is the probability that the test correctly rejects the null hypothesis when the alternative is true for a specific effect size; it equals 1 minus beta.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The chance that the program truly raises reading scores, given the data.', false, 'Power is a probability about the test''s decision for a given true effect, not the probability that the alternative hypothesis is true.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The chance the test fails to reject H0 when the program truly raises scores.', false, 'Failing to reject a false null hypothesis is a Type II error with probability beta; power is 1 minus beta.' from version_ins;
-- APSTATS-MCQ-SV-080-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-080-v1', 'mcq', 'p=0.03 vs alpha=0.05', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A test of whether a new bus route changes the proportion of on-time arrivals gives p = 0.03 with alpha = 0.05. Which conclusion is correct?', null, md5('APSTATS-MCQ-SV-080-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Reject H0; there is convincing statistical evidence for the alternative hypothesis at the 0.05 level.', true, 'Because p = 0.03 is less than alpha = 0.05, the result is statistically significant and the data provide convincing evidence for Ha.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Reject H0, which proves the alternative hypothesis is true.', false, 'A test gives evidence, not proof; the conclusion should use language such as convincing evidence.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fail to reject H0, because 0.03 is smaller than 0.05 and so the evidence is too weak.', false, 'A p-value smaller than alpha is evidence against H0; it leads to rejection, not failure to reject.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Reject H0; the probability that H0 is true is 0.03.', false, 'The p-value is computed assuming H0 is true; it is not the probability that H0 is true.' from version_ins;
-- APSTATS-MCQ-SV-080-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-080-v3', 'mcq', 'p=0.047 vs alpha=0.01', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A hospital tests whether a new protocol reduces readmission rates and uses alpha = 0.01. The test gives p = 0.047. Which conclusion is correct?', null, md5('APSTATS-MCQ-SV-080-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Reject H0, since p = 0.047 is below the common 0.05 cutoff.', false, 'The cutoff for this test is alpha = 0.01, set in advance, not 0.05.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fail to reject H0, which means H0 is true with probability 1 - 0.047 = 0.953.', false, 'The p-value does not give the probability that H0 is true, and failing to reject does not prove it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fail to reject H0; there is not convincing evidence at the 0.01 level.', true, 'Because p = 0.047 is greater than alpha = 0.01, the evidence is not strong enough at this level.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Reject H0, since 0.047 is close to 0.01.', false, 'Being close to alpha does not justify rejection; the rule is to reject only if p is less than alpha.' from version_ins;
commit;
