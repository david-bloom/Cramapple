begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-049-v2','APSTATS-MCQ-SV-049-v3','APSTATS-MCQ-SV-076-v1','APSTATS-MCQ-SV-076-v2','APSTATS-MCQ-SV-076-v3','APSTATS-MCQ-SV-092-v1','APSTATS-MCQ-SV-092-v2','APSTATS-MCQ-SV-092-v3','APSTATS-MCQ-SV-005-CAL-v1','APSTATS-MCQ-SV-005-CAL-v2','APSTATS-MCQ-SV-005-CAL-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-049-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-049-v2', 'mcq', 'Mean of a discrete random variable', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The number of pets X owned by a randomly chosen student has this distribution: P(X = 0) = 0.1, P(X = 1) = 0.4, P(X = 2) = 0.3, P(X = 3) = 0.2. What is the expected value of X?', null, md5('APSTATS-MCQ-SV-049-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.0', false, 'This is the most likely value (mode), not the probability-weighted mean of the distribution.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.5', false, 'This is the unweighted mean of the values 0, 1, 2, 3, which ignores the probabilities.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.6', true, 'E(X) = 0(0.1) + 1(0.4) + 2(0.3) + 3(0.2) = 0 + 0.4 + 0.6 + 0.6 = 1.6.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.25', false, 'This is the average of the four probabilities (1/4), not a probability-weighted average of the values.' from version_ins;
-- APSTATS-MCQ-SV-049-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-049-v3', 'mcq', 'Insurer''s expected profit per policy', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An insurance company sells a policy for $60. With probability 0.02 it pays a claim of $2,000, and otherwise it pays nothing. What is the company''s expected profit per policy, after the claim cost but including the $60 premium?', null, md5('APSTATS-MCQ-SV-049-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '$20', true, 'Expected claim cost = 2,000(0.02) = $40, so expected profit = 60 - 40 = $20.' from version_ins
union all select gen_random_uuid(), id, 'B', '$40', false, 'This is the expected claim cost, 2,000(0.02) = $40, not the expected profit. Profit also includes the $60 premium: 60 − 40 = $20.' from version_ins
union all select gen_random_uuid(), id, 'C', '-$20', false, 'The sign is reversed: expected profit is premium minus expected claim cost, 60 - 40 = +20, not 40 - 60.' from version_ins
union all select gen_random_uuid(), id, 'D', '$60', false, 'This is only the premium; the expected payout of $40 per policy was not subtracted.' from version_ins;
-- APSTATS-MCQ-SV-076-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-076-v1', 'mcq', 'Expected count from marginal totals', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a chi-square test of independence, one cell of the table has row total 60, column total 90, and the table total is 300. What is the expected count for that cell?', null, md5('APSTATS-MCQ-SV-076-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18', true, 'Expected count = (row total x column total)/table total = (60 x 90)/300 = 5400/300 = 18.' from version_ins
union all select gen_random_uuid(), id, 'B', '5,400', false, 'This multiplies the row and column totals (60 x 90) but never divides by the table total of 300.' from version_ins
union all select gen_random_uuid(), id, 'C', '150', false, 'This adds the row and column totals (60 + 90) instead of multiplying them and dividing by the table total.' from version_ins
union all select gen_random_uuid(), id, 'D', '36', false, 'This divides by 150, half of the table total, instead of 300: (60 x 90)/150 = 36.' from version_ins;
-- APSTATS-MCQ-SV-076-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-076-v2', 'mcq', 'Expected count in a 2 by 3 table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of students was classified by class year and favorite study method:
Study method: Flash cards | Notes | Videos | Row total
Freshman: 30 | 45 | 25 | 100
Sophomore: 40 | 55 | 45 | 140
Column total: 70 | 100 | 70 | table total 240
If class year and study method are independent, what is the expected count for freshmen who prefer videos?', null, md5('APSTATS-MCQ-SV-076-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 29.2', true, 'Expected count = (row total x column total)/table total = (100 x 70)/240 = about 29.2.' from version_ins
union all select gen_random_uuid(), id, 'B', '35', false, 'This is the Videos column total divided by 2 rows (70/2), which ignores that the rows have different totals.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 33.3', false, 'This is the freshman row total divided by 3 columns (100/3), which assumes equal splits across methods rather than using column totals.' from version_ins
union all select gen_random_uuid(), id, 'D', '25', false, 'This is the observed count for freshmen who prefer videos, not the expected count.' from version_ins;
-- APSTATS-MCQ-SV-076-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-076-v3', 'mcq', 'Expected count when observed is given', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chi-square test of independence for 500 survey respondents focuses on one cell. The observed count in that cell is 48, its row total is 200, its column total is 150, and the table total is 500. What is the expected count for this cell?', null, md5('APSTATS-MCQ-SV-076-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '350', false, 'This adds the row and column totals (200 + 150), which is not how expected counts are computed.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.12', false, 'This is (200/500) x (150/500), the expected proportion; it must be multiplied by 500 to get an expected count of 60.' from version_ins
union all select gen_random_uuid(), id, 'C', '48', false, 'This is the observed count in the cell, not the expected count under independence.' from version_ins
union all select gen_random_uuid(), id, 'D', '60', true, 'Expected count = (200 x 150)/500 = 30,000/500 = 60.' from version_ins;
-- APSTATS-MCQ-SV-092-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-092-v1', 'mcq', 'Type I error in a drug trial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a clinical trial, researchers test H0: the new drug has no effect on blood pressure. They conclude the drug lowers blood pressure, but in fact the drug has no effect. Which type of error did they make?', null, md5('APSTATS-MCQ-SV-092-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Type II error, because the drug was wrongly judged effective', false, 'Type II error is failing to reject a false null; here H0 was rejected, so it cannot be Type II.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Type I error, because a true null hypothesis was rejected', true, 'Concluding the drug works when it truly has no effect means H0 (no effect) was true but rejected, which is a Type I error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sampling bias, because the researchers used a sample', false, 'Taking a sample is not itself an error; the incorrect decision about H0 is called a Type I error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No error, because the conclusion followed from the sample results', false, 'A conclusion that follows from the data can still be wrong about the population; here H0 was true and was rejected, which is an error.' from version_ins;
-- APSTATS-MCQ-SV-092-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-092-v2', 'mcq', 'Identifying a Type II error', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quality inspector tests H0: mu = 500 g for the mean fill of cereal boxes. The machine has actually drifted so that the true mean is not 500 g, but the inspector fails to reject H0. What type of error is this?', null, md5('APSTATS-MCQ-SV-092-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Type I error, because the machine was not repaired', false, 'Whether the machine is repaired is not what defines Type I; that error requires rejecting a true H0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Type I error, because the inspector reached the wrong conclusion', false, 'Type I error is rejecting a true null; here H0 was false and was not rejected.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Type II error, because a false null hypothesis was not rejected', true, 'H0 (mean = 500 g) is false, and the inspector failed to reject it; that is a Type II error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No error, because failing to reject H0 is the safe decision', false, 'Failing to reject a false null leaves a real change undetected, which is an error even though no rejection occurred.' from version_ins;
-- APSTATS-MCQ-SV-092-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-092-v3', 'mcq', 'Probability of a Type I error', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher tests H0 at significance level alpha = 0.05 and obtains a p-value of 0.03, so H0 is rejected. If H0 is actually true, what is the probability that this testing procedure produces a Type I error?', null, md5('APSTATS-MCQ-SV-092-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.05, which is the significance level alpha', true, 'The Type I error rate of a test is alpha; when H0 is true the procedure rejects with probability alpha = 0.05.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.97, which is 1 - the p-value', false, '1 - 0.03 is not a probability associated with a Type I error; the Type I error rate is alpha = 0.05.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.03, which is the observed p-value', false, 'The p-value describes this particular sample result; the Type I error rate of the procedure is set by alpha = 0.05.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.95, which is 1 - alpha', false, '1 - alpha = 0.95 is the probability of not rejecting a true H0, not of rejecting it.' from version_ins;
-- APSTATS-MCQ-SV-005-CAL-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-005-CAL-v1', 'mcq', 'Sleep duration and GPA survey', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A university health center reports that students who sleep at least 8 hours per night have a higher mean GPA than students who sleep less. The report is based on an email survey in which 320 students chose to respond and reported their own sleep and GPA. Which conclusion is appropriately supported by this study design?', null, md5('APSTATS-MCQ-SV-005-CAL-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Since sleep was not randomly assigned, the survey shows no relationship between sleep and GPA among respondents.', false, 'Lack of random assignment limits causal claims, not the description of association; the respondents'' mean GPAs did differ between the two sleep groups, so an association exists in the sample.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sleeping at least 8 hours per night causes students to earn higher GPAs.', false, 'This draws a causal conclusion from an observational survey; without random assignment, confounding variables (for example, motivation or course load) could explain the GPA difference.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Because 320 respondents is a large sample, the data show that more sleep causes a higher GPA.', false, 'A large sample reduces sampling variability but does not remove confounding or the self-selection of respondents; only random assignment supports causal claims.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sleep duration and GPA are associated among these respondents, but a cause-and-effect conclusion is not supported because sleep was not randomly assigned.', true, 'The study is observational with self-selected respondents and no random assignment of sleep habits, so it can describe an association but cannot rule out confounders such as study habits or workload.' from version_ins;
-- APSTATS-MCQ-SV-005-CAL-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-005-CAL-v2', 'mcq', 'Herbal tea randomized insomnia trial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A clinic recruits 90 volunteers with mild insomnia and uses a random number generator to assign 45 to drink a new herbal tea nightly and 45 to drink a placebo tea. After four weeks, the tea group fell asleep an average of 12 minutes faster, and a significance test shows this difference is very unlikely to be due to chance alone. Which conclusion is best supported?', null, md5('APSTATS-MCQ-SV-005-CAL-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The tea very likely caused faster sleep onset among these volunteers, because treatments were randomly assigned and the difference is unlikely to be due to chance.', true, 'Random assignment balances other variables across the two groups, and the significant difference rules out chance as the explanation, so a cause-and-effect conclusion is supported for the volunteers in the study.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The tea would cause faster sleep onset for all adults with insomnia, because random assignment makes the volunteers representative of them.', false, 'Random assignment supports causation within the study, not generalization; representativeness requires random selection from the target population, and these were volunteers.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Because the participants were volunteers, no cause-and-effect conclusion is possible for anyone in the study.', false, 'Volunteering limits generalization to a larger population, but causal conclusions within the study depend on random assignment of treatments, which was used here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Because only 90 people took part, no cause-and-effect conclusion can be drawn from this study.', false, 'A smaller sample does not prevent causal inference; the significant result already accounts for sample size, and random assignment is what supports causation.' from version_ins;
-- APSTATS-MCQ-SV-005-CAL-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-005-CAL-v3', 'mcq', 'Coffee and heart disease county sample', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers select a simple random sample of 800 adults from a county and record how many cups of coffee each drinks per day and whether each has been diagnosed with heart disease. Adults who drink 3 or more cups a day have a lower rate of diagnosed heart disease than those who drink fewer. Which conclusion is appropriate?', null, md5('APSTATS-MCQ-SV-005-CAL-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The association cannot be generalized to the county''s adults, because coffee drinking was not randomly assigned.', false, 'Generalization depends on how subjects were selected, and these adults were randomly selected, so the association can be extended to the county''s adults even though causation cannot be claimed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Drinking 3 or more cups of coffee a day lowers the risk of heart disease, because the sample was randomly selected.', false, 'Random selection of subjects supports generalizing the association to the county; it does not establish cause and effect, which requires random assignment of the explanatory variable.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Random selection ensures that age, diet, and other variables are balanced between heavy and light coffee drinkers, so differences are due to coffee.', false, 'Balancing lurking variables is the job of random assignment; in a random sample, heavy and light drinkers can still differ systematically in age, diet, and more.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is an association in the county''s adults that can be generalized because of the random sample, but causation cannot be concluded because coffee drinking was not assigned.', true, 'Random selection supports generalizing to the county, but with no random assignment of coffee consumption, confounders such as age or diet cannot be ruled out, so only association can be claimed.' from version_ins;
commit;
