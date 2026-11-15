begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.3-A-v3','APSTATS-MCQ-SV-H-3.3-B-v1','APSTATS-MCQ-SV-H-3.3-B-v2','APSTATS-MCQ-SV-H-3.3-B-v3','APSTATS-MCQ-SV-H-3.4-B-v1','APSTATS-MCQ-SV-H-3.4-B-v2','APSTATS-MCQ-SV-H-3.4-B-v3','APSTATS-MCQ-SV-H-3.5-A-v1','APSTATS-MCQ-SV-H-3.5-A-v2'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-3.3-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.3-A-v3', 'mcq', 'Margin of error under combined changes (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 99% confidence interval for a population proportion, based on a random sample of 500 people, has a margin of error of 0.02. A second interval uses a random sample of only 125 people at a 90% confidence level, with about the same sample proportion. About what is its margin of error?', null, md5('APSTATS-MCQ-SV-H-3.3-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.040', false, 'Accounted for the smaller sample but ignored the lower confidence level.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.013', false, 'Accounted for the lower confidence level but ignored the smaller sample.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.051', false, 'Multiplied by 4 instead of 2 for the sample-size change, then applied the critical value change.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.026', true, 'Correct: n cut to a quarter, so the margin doubles to 0.04; 1.645 / 2.576 = 0.639; 0.04 x 0.639 = 0.0255.' from version_ins;
-- APSTATS-MCQ-SV-H-3.3-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.3-B-v1', 'mcq', 'Sample size using a pilot estimate (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher wants a 90% confidence interval for a population proportion with a margin of error no larger than 0.05. A pilot study estimated the proportion to be about 0.35. Using z* = 1.645 and the pilot estimate, what is the smallest sample size that guarantees this margin of error?', null, md5('APSTATS-MCQ-SV-H-3.3-B-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '271', false, 'Ignored the pilot estimate and used p = 0.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '247', true, 'Correct: n >= 1.645^2 (0.35)(0.65) / 0.05^2 = 246.25, so n = 247.' from version_ins
union all select gen_random_uuid(), id, 'C', '246', false, 'Rounded 246.25 down to 246, but any value with a fractional part must be rounded up to guarantee the margin of error.' from version_ins
union all select gen_random_uuid(), id, 'D', '379', false, 'Used p = 0.35 in place of p(1 - p) = 0.2275.' from version_ins;
-- APSTATS-MCQ-SV-H-3.3-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.3-B-v2', 'mcq', 'Sample size using a pilot estimate (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher wants a 99% confidence interval for a population proportion with a margin of error no larger than 0.02. A pilot study estimated the proportion to be about 0.10. Using z* = 2.576 and the pilot estimate, what is the smallest sample size that guarantees this margin of error?', null, md5('APSTATS-MCQ-SV-H-3.3-B-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4,148', false, 'Ignored the pilot estimate and used p = 0.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '1,494', true, 'Correct: n >= 2.576^2 (0.10)(0.90) / 0.02^2 = 1493.05, so n = 1,494.' from version_ins
union all select gen_random_uuid(), id, 'C', '1,493', false, 'Rounded 1,493.05 down to 1,493, but any value with a fractional part must be rounded up to guarantee the margin of error.' from version_ins
union all select gen_random_uuid(), id, 'D', '1,659', false, 'Used p = 0.10 in place of p(1 - p) = 0.09.' from version_ins;
-- APSTATS-MCQ-SV-H-3.3-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.3-B-v3', 'mcq', 'Sample size using a pilot estimate (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher wants a 95% confidence interval for a population proportion with a margin of error no larger than 0.03. A pilot study estimated the proportion to be about 0.70. Using z* = 1.96 and the pilot estimate, what is the smallest sample size that guarantees this margin of error?', null, md5('APSTATS-MCQ-SV-H-3.3-B-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1,068', false, 'Ignored the pilot estimate and used p = 0.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '896', false, 'Rounded 896.37 down to 896, but any value with a fractional part must be rounded up to guarantee the margin of error.' from version_ins
union all select gen_random_uuid(), id, 'C', '897', true, 'Correct: n >= 1.96^2 (0.70)(0.30) / 0.03^2 = 896.37, so n = 897.' from version_ins
union all select gen_random_uuid(), id, 'D', '2,988', false, 'Used p = 0.70 in place of p(1 - p) = 0.21.' from version_ins;
-- APSTATS-MCQ-SV-H-3.4-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.4-B-v1', 'mcq', 'Recover p-hat and margin from an interval, then judge a claim (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of voters is used to construct a 95% confidence interval for the proportion who support a school bond. The interval is (0.52, 0.64). A board member claims that a majority of voters support the bond. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.4-B-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The interval does not support the claim, because the interval does not capture the sample proportion exactly.', false, 'The sample proportion is the midpoint of the interval by construction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is a 95% probability that more than half of all voters support the bond.', false, 'The true proportion is a fixed number, so probability statements describe the method, not this interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The interval supports the claim, because every plausible value for the population proportion is above 0.50.', true, 'Correct: lower endpoint 0.52 > 0.50, so all plausible values exceed one half.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interval supports the claim only for the 95% of voters inside the interval.', false, 'The interval is about a population proportion, not about subsets of voters.' from version_ins;
-- APSTATS-MCQ-SV-H-3.4-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.4-B-v2', 'mcq', 'Recover p-hat and margin from an interval, then judge a claim (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 900 teenagers is used to construct a 99% confidence interval for the proportion who text while walking. The interval is (0.31, 0.39). A safety group claims that the proportion is 0.30. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.4-B-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is not supported, because 0.30 is not a plausible value; every plausible value is above 0.30.', true, 'Correct: 0.30 lies below the lower endpoint 0.31.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is supported, because 0.30 is close to the lower endpoint 0.31.', false, 'Being close to an endpoint is not the same as being inside the interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is supported, because the interval is centered at 0.35 and that is near 0.30.', false, 'The center of the interval is the sample proportion, and the claim must be a plausible value for the population.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is not supported, because 99% of teenagers are outside the interval.', false, 'A confidence level does not describe the share of teenagers.' from version_ins;
-- APSTATS-MCQ-SV-H-3.4-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.4-B-v3', 'mcq', 'Recover p-hat and margin from an interval, then judge a claim (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 250 customers is used to construct a 90% confidence interval for the proportion who are satisfied. The interval is (0.33, 0.43). A manager claims that fewer than 40% of customers are satisfied. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.4-B-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is supported, because the sample proportion of 0.38 is less than 0.40.', false, 'A claim about a population cannot be judged from the sample proportion alone.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is supported, because most of the interval is below 0.40.', false, 'The whole range of plausible values must agree with the claim.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is not supported, because values from 0.40 to 0.43 are plausible for the population proportion.', true, 'Correct: the interval contains 0.40 and values above it; p-hat = 0.38.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is not supported, because the interval would need to be a 95% interval to be used.', false, 'A 90% interval can be used to evaluate a claim; the level only sets the level of confidence.' from version_ins;
-- APSTATS-MCQ-SV-H-3.5-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.5-A-v1', 'mcq', 'Hypotheses from the research question (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school claims that at least 70% of its graduates enroll in college. A skeptical reporter wants to test whether the true proportion is less than 70%. In a random sample of 120 graduates, 90 enrolled in college (75%). Which hypotheses should the reporter test?', null, md5('APSTATS-MCQ-SV-H-3.5-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: p = 0.70, Ha: p > 0.70, where p is the proportion of all graduates who enroll in college.', false, 'Followed the direction of the sample result instead of the question.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: p = 0.70, Ha: p < 0.70, where p is the proportion of all graduates who enroll in college.', true, 'Correct: the reporter''s question is "less than 70%"; the sample 75% is data.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: p = 0.75, Ha: p < 0.75, where p is the proportion of all graduates who enroll in college.', false, 'Used the sample proportion as the null value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: p-hat = 0.70, Ha: p-hat < 0.70, where p-hat is the proportion of sampled graduates who enroll.', false, 'Hypotheses are about the population parameter, not the statistic.' from version_ins;
-- APSTATS-MCQ-SV-H-3.5-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.5-A-v2', 'mcq', 'Hypotheses from the research question (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A manufacturer says that 4% of its batteries are defective. An inspector suspects the true defect rate is different from 4%. In a random sample of 500 batteries, 24 are defective (4.8%). Which hypotheses should the inspector test?', null, md5('APSTATS-MCQ-SV-H-3.5-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: p = 0.048, Ha: p != 0.048, where p is the proportion of all batteries that are defective.', false, 'Used the sample proportion as the null value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: p = 0.04, Ha: p > 0.04, where p is the proportion of all batteries that are defective.', false, 'The inspector''s suspicion is a difference in either direction, not just an increase.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: p-hat = 0.04, Ha: p-hat != 0.04, where p-hat is the proportion of sampled batteries that are defective.', false, 'Hypotheses are about the population parameter, not the statistic.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: p = 0.04, Ha: p != 0.04, where p is the proportion of all batteries that are defective.', true, 'Correct: "different from" is two-sided and the null uses the manufacturer''s 4%.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.3-A-v3','APSTATS-MCQ-SV-H-3.3-B-v1','APSTATS-MCQ-SV-H-3.3-B-v2','APSTATS-MCQ-SV-H-3.3-B-v3','APSTATS-MCQ-SV-H-3.4-B-v1','APSTATS-MCQ-SV-H-3.4-B-v2','APSTATS-MCQ-SV-H-3.4-B-v3','APSTATS-MCQ-SV-H-3.5-A-v1','APSTATS-MCQ-SV-H-3.5-A-v2']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-3.3-A-v3','APSTATS-MCQ-SV-H-3.3-B-v1','APSTATS-MCQ-SV-H-3.3-B-v2','APSTATS-MCQ-SV-H-3.3-B-v3','APSTATS-MCQ-SV-H-3.4-B-v1','APSTATS-MCQ-SV-H-3.4-B-v2','APSTATS-MCQ-SV-H-3.4-B-v3','APSTATS-MCQ-SV-H-3.5-A-v1','APSTATS-MCQ-SV-H-3.5-A-v2']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
