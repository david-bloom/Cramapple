begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.7-A-v3','APSTATS-MCQ-SV-H-3.8-A-v1','APSTATS-MCQ-SV-H-3.8-A-v2','APSTATS-MCQ-SV-H-3.8-A-v3','APSTATS-MCQ-SV-H-3.8-B-v1','APSTATS-MCQ-SV-H-3.8-B-v2','APSTATS-MCQ-SV-H-3.8-B-v3','APSTATS-MCQ-SV-H-3.8-C-v1','APSTATS-MCQ-SV-H-3.8-C-v2'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-3.7-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.7-A-v3', 'mcq', 'Conditions for a one-sample z-test use p0 (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher wants to know whether more than half of the voters in a large state support a ballot measure. In a random sample of 100 voters, 62 support it. For a one-sample z-test of H0: p = 0.50 versus Ha: p > 0.50, which value is the test statistic?', null, md5('APSTATS-MCQ-SV-H-3.7-A-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'z = 0.24', false, 'Left n out of the standard error, dividing by sqrt[p0(1 - p0)] only.' from version_ins
union all select gen_random_uuid(), id, 'B', 'z = 2.40', true, 'Correct: z = (0.62 - 0.50) / sqrt(0.50 x 0.50 / 100) = 0.12 / 0.05 = 2.40.' from version_ins
union all select gen_random_uuid(), id, 'C', 'z = 2.47', false, 'Used p-hat in the standard error; in a test the standard error uses the hypothesized p0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'z = 24', false, 'Divided sqrt[p0(1 - p0)] by n instead of taking the square root of p0(1 - p0)/n.' from version_ins;
-- APSTATS-MCQ-SV-H-3.8-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.8-A-v1', 'mcq', 'Power and Type II error in context (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A significance test has power 0.85 against a particular alternative value of the parameter. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.8-A-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'If the null hypothesis is true, the probability of a Type I error is 0.15.', false, 'The Type I error probability is alpha and is not 1 minus the power.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The probability that the null hypothesis is false is 0.85.', false, 'Power is a conditional probability about the test''s decision, not a probability that the null is false.' from version_ins
union all select gen_random_uuid(), id, 'C', 'If that alternative is true, the probability of a Type II error is 0.15.', true, 'Correct: Type II probability = 1 - 0.85 = 0.15.' from version_ins
union all select gen_random_uuid(), id, 'D', 'If the null hypothesis is true, the probability that the test rejects it is 0.85.', false, 'If the null is true the probability of rejecting it is alpha.' from version_ins;
-- APSTATS-MCQ-SV-H-3.8-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.8-A-v2', 'mcq', 'Power and Type II error in context (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A test of H0: p = 0.50 versus Ha: p > 0.50 has power 0.70 against p = 0.60 for a particular sample size and significance level. With the same sample size and significance level, how would the power against p = 0.55 compare?', null, md5('APSTATS-MCQ-SV-H-3.8-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Greater than 0.70, because values closer to the null give a larger gap to detect.', false, 'A value closer to the null is a smaller gap, not a larger one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Equal to 0.70, because the sample size and significance level are the same.', false, 'Power also depends on how far the true value is from the null value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Equal to the significance level, because 0.55 is close to 0.50.', false, 'Power equals alpha only when the true value equals the null value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Less than 0.70, because a true value closer to the null value is harder to detect.', true, 'Correct: smaller effect size, same standard error, so less power.' from version_ins;
-- APSTATS-MCQ-SV-H-3.8-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.8-A-v3', 'mcq', 'Power and Type II error in context (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A test of H0: p = 0.30 versus Ha: p < 0.30 has a probability of 0.18 of failing to reject H0 when the true proportion is 0.20. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.8-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The test has power 0.18 against p = 0.20.', false, '0.18 is the Type II error probability, not the power.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The test has power 0.82, so there is an 82% chance that the true proportion is 0.20.', false, 'Power is not a probability that the parameter takes a value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The test has power 0.82, so there is an 82% chance the test rejects H0 if the true proportion is 0.20.', true, 'Correct: power = 1 - 0.18 = 0.82.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The test has power 0.82, so there is an 18% chance that H0 is true.', false, 'Power does not give the probability that H0 is true.' from version_ins;
-- APSTATS-MCQ-SV-H-3.8-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.8-B-v1', 'mcq', 'Trade-off between Type I and Type II error (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher increases the significance level from alpha = 0.01 to alpha = 0.10 and keeps the same sample size and the same true parameter value. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.8-B-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The probability of a Type I error decreases, and the probability of a Type II error increases.', false, 'Reversed the effect of raising alpha, which makes rejection easier and so raises the Type I probability and lowers the Type II probability.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The probabilities of both types of error decrease.', false, 'With the sample size fixed, the two error probabilities move in opposite directions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The probability of a Type I error increases, and the probability of a Type II error decreases.', true, 'Correct: a larger alpha makes rejection easier, so Type I goes up and power goes up (Type II goes down).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The probability of a Type I error increases, and the probability of a Type II error is unchanged.', false, 'Raising alpha makes rejection easier, which also lowers the Type II error probability.' from version_ins;
-- APSTATS-MCQ-SV-H-3.8-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.8-B-v2', 'mcq', 'Trade-off between Type I and Type II error (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drug company tests H0: the drug is not effective versus Ha: the drug is effective. A Type I error would approve an ineffective drug, which could harm patients. Which plan best addresses this concern while keeping the test useful?', null, md5('APSTATS-MCQ-SV-H-3.8-B-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Raise alpha to 0.10 so the test is more sensitive.', false, 'A larger alpha makes false approvals more likely.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Lower alpha to 0.01 and increase the sample size so the test keeps its power.', true, 'Correct: lowering alpha reduces false approvals; a larger n offsets the power loss.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Lower alpha to 0.01 and decrease the sample size to save cost.', false, 'A smaller sample would lower power further.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Keep alpha at 0.05 and decrease the sample size.', false, 'The sample size does not change the Type I error probability, which stays at alpha.' from version_ins;
-- APSTATS-MCQ-SV-H-3.8-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.8-B-v3', 'mcq', 'Trade-off between Type I and Type II error (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher doubles the sample size for a test while keeping the significance level and the true parameter value the same. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.8-B-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The probability of a Type I error decreases, and the probability of a Type II error stays the same.', false, 'The Type I error probability is set by alpha, and the Type II probability falls with a larger n.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The probabilities of both Type I and Type II errors decrease.', false, 'The Type I error probability is alpha and does not change with the sample size.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The probability of a Type I error stays at alpha, and the probability of a Type II error decreases.', true, 'Correct: alpha is chosen by the researcher; a larger n shrinks the standard error and raises power.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The probability of a Type I error stays at alpha, and the power decreases.', false, 'Power increases with a larger sample size.' from version_ins;
-- APSTATS-MCQ-SV-H-3.8-C-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.8-C-v1', 'mcq', 'Type II error from a framed null hypothesis (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A food plant tests each batch with H0: the batch is not contaminated versus Ha: the batch is contaminated. Rejecting H0 means the batch is discarded. Which statement correctly describes a Type I error?', null, md5('APSTATS-MCQ-SV-H-3.8-C-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Type I error: a clean batch is discarded even though it was not contaminated.', true, 'Correct: Type I means rejecting a true H0; H0 (not contaminated) is true for a clean batch.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Type I error: a contaminated batch is not discarded and is shipped to stores.', false, 'This describes failing to reject a false H0, which is a Type II error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Type II error: a clean batch is discarded.', false, 'Discarding a clean batch is a Type I error, not a Type II error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Type I error: a contaminated batch is discarded.', false, 'Discarding a contaminated batch is the correct decision.' from version_ins;
-- APSTATS-MCQ-SV-H-3.8-C-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.8-C-v2', 'mcq', 'Type II error from a framed null hypothesis (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cereal machine is set to fill boxes with a mean of 500 g. An inspector tests H0: mu = 500 versus Ha: mu != 500 and stops the machine when H0 is rejected. Which statement correctly describes a Type II error?', null, md5('APSTATS-MCQ-SV-H-3.8-C-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Type II error: the machine is not stopped even though its true mean is not 500 g.', true, 'Correct: a Type II error fails to reject a false H0; here H0 is false when the true mean differs from 500.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Type I error: the machine is stopped even though it is filling correctly.', false, 'Stopping a correct machine is a Type I error, and the question asks about a Type II error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Type II error: the machine is stopped even though it is filling correctly.', false, 'Stopping a correct machine rejects a true H0, which is a Type I error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Type II error: the machine is stopped because it is filling incorrectly.', false, 'Stopping an incorrect machine is the correct decision.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.7-A-v3','APSTATS-MCQ-SV-H-3.8-A-v1','APSTATS-MCQ-SV-H-3.8-A-v2','APSTATS-MCQ-SV-H-3.8-A-v3','APSTATS-MCQ-SV-H-3.8-B-v1','APSTATS-MCQ-SV-H-3.8-B-v2','APSTATS-MCQ-SV-H-3.8-B-v3','APSTATS-MCQ-SV-H-3.8-C-v1','APSTATS-MCQ-SV-H-3.8-C-v2']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-3.7-A-v3','APSTATS-MCQ-SV-H-3.8-A-v1','APSTATS-MCQ-SV-H-3.8-A-v2','APSTATS-MCQ-SV-H-3.8-A-v3','APSTATS-MCQ-SV-H-3.8-B-v1','APSTATS-MCQ-SV-H-3.8-B-v2','APSTATS-MCQ-SV-H-3.8-B-v3','APSTATS-MCQ-SV-H-3.8-C-v1','APSTATS-MCQ-SV-H-3.8-C-v2']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
