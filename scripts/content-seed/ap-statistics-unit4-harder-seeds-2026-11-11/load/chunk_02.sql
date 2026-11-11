begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-4.2-A-v1','APSTATS-MCQ-SV-H-4.2-A-v2','APSTATS-MCQ-SV-H-4.2-A-v3','APSTATS-MCQ-H-4.2-B','APSTATS-MCQ-SV-H-4.2-B-v1','APSTATS-MCQ-SV-H-4.2-B-v2','APSTATS-MCQ-SV-H-4.2-B-v3','APSTATS-MCQ-H-4.3-A','APSTATS-MCQ-SV-H-4.3-A-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-4.2-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.2-A-v1', 'mcq', 't interval for a mean from summary statistics (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lab measures the concentration of a chemical in 6 independent water samples. The data are roughly symmetric with no outliers; the mean is 52 and the standard deviation is 8. For df = 5, t* = 2.015 at 90% confidence. What is the 90% confidence interval for the mean concentration?', null, md5('APSTATS-MCQ-SV-H-4.2-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(45.42, 58.58)', true, 'Correct: SE = 8/√6 = 3.266; margin = 2.015 x 3.266 = 6.58; interval (45.42, 58.58).' from version_ins
union all select gen_random_uuid(), id, 'B', '(46.63, 57.37)', false, 'Used z* = 1.645, which ignores the extra uncertainty from estimating the standard deviation with a sample of 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '(35.88, 68.12)', false, 'Used the standard deviation instead of the standard error, so the margin is much too large.' from version_ins
union all select gen_random_uuid(), id, 'D', '(49.31, 54.69)', false, 'Divided s by n instead of √n when computing the standard error.' from version_ins;
-- APSTATS-MCQ-SV-H-4.2-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.2-A-v2', 'mcq', 't interval for a mean from summary statistics (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The lengths of 12 randomly selected trout from a lake have mean 14.2 inches and standard deviation 3.0 inches, and the data are roughly symmetric with no outliers. For df = 11, t* = 3.106 at 99% confidence. What is the 99% confidence interval for the mean length?', null, md5('APSTATS-MCQ-SV-H-4.2-A-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(11.97, 16.43)', false, 'Used z* = 2.576 instead of the t critical value, so the interval is too narrow.' from version_ins
union all select gen_random_uuid(), id, 'B', '(11.51, 16.89)', true, 'Correct: SE = 3.0/√12 = 0.866; margin = 3.106 x 0.866 = 2.69; interval (11.51, 16.89).' from version_ins
union all select gen_random_uuid(), id, 'C', '(4.88, 23.52)', false, 'Used the standard deviation instead of the standard error.' from version_ins
union all select gen_random_uuid(), id, 'D', '(13.42, 14.98)', false, 'Divided s by n instead of √n, which makes the standard error much too small.' from version_ins;
-- APSTATS-MCQ-SV-H-4.2-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.2-A-v3', 'mcq', 't interval for a mean from summary statistics (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of 8 measurements from an approximately normal population has mean 30 and standard deviation 5. For df = 7, t* = 2.998 at 98% confidence. What is the 98% confidence interval for the population mean?', null, md5('APSTATS-MCQ-SV-H-4.2-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(25.89, 34.11)', false, 'Used z* = 2.326 instead of the t critical value.' from version_ins
union all select gen_random_uuid(), id, 'B', '(28.13, 31.87)', false, 'Divided s by n instead of √n, which makes the standard error and the margin far too small.' from version_ins
union all select gen_random_uuid(), id, 'C', '(24.70, 35.30)', true, 'Correct: SE = 5/√8 = 1.768; margin = 2.998 x 1.768 = 5.30; interval (24.70, 35.30).' from version_ins
union all select gen_random_uuid(), id, 'D', '(15.01, 44.99)', false, 'Used the standard deviation in place of the standard error, so the margin is much too wide.' from version_ins;
-- APSTATS-MCQ-H-4.2-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.2-B', 'mcq', 'Sample size and width of an interval for a mean', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher plans a 95% confidence interval for a population mean. A pilot study suggests the population standard deviation is about 10, and she wants a margin of error of at most 2. Using z* = 1.96 for planning, what is the smallest sample size that guarantees this margin of error?', null, md5('APSTATS-MCQ-H-4.2-B'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '97', true, 'Correct: n >= (1.96 x 10 / 2)^2 = 96.04, so n = 97.' from version_ins
union all select gen_random_uuid(), id, 'B', '25', false, 'Left out the critical value, computing (10/2)^2.' from version_ins
union all select gen_random_uuid(), id, 'C', '10', false, 'Found 1.96 x 10/2 = 9.8 but forgot to square it.' from version_ins
union all select gen_random_uuid(), id, 'D', '96', false, 'Rounded 96.04 down, which would give a margin slightly larger than 2.' from version_ins;
-- APSTATS-MCQ-SV-H-4.2-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.2-B-v1', 'mcq', 'Sample size and width of an interval for a mean (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher plans a 90% confidence interval for a population mean. A pilot study suggests the population standard deviation is about 15, and she wants a margin of error of at most 3. Using z* = 1.645, what is the smallest sample size that guarantees this margin of error?', null, md5('APSTATS-MCQ-SV-H-4.2-B-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '25', false, 'Left out the critical value, computing (15/3)^2.' from version_ins
union all select gen_random_uuid(), id, 'B', '68', true, 'Correct: n >= (1.645 x 15 / 3)^2 = 67.65, so n = 68.' from version_ins
union all select gen_random_uuid(), id, 'C', '67', false, 'Rounded 67.65 down, which gives a margin slightly above 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '9', false, 'Computed 1.645 x 15/3 = 8.2 and rounded it up without squaring.' from version_ins;
-- APSTATS-MCQ-SV-H-4.2-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.2-B-v2', 'mcq', 'Sample size and width of an interval for a mean (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for a population mean based on a random sample of 36 has a width of 6. About how large a sample is needed to get a 95% interval of width 3, assuming the sample standard deviation stays about the same?', null, md5('APSTATS-MCQ-SV-H-4.2-B-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '144', true, 'Correct: halving the width halves the margin of error, which requires four times the sample size: 36 x 4 = 144.' from version_ins
union all select gen_random_uuid(), id, 'B', '72', false, 'Doubling n divides the margin by only √2, not 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '108', false, 'Tripling n divides the margin by √3, not 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '18', false, 'This reduces the sample size, which would widen the interval.' from version_ins;
-- APSTATS-MCQ-SV-H-4.2-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.2-B-v3', 'mcq', 'Sample size and width of an interval for a mean (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for a population mean, based on a random sample of 25 from an approximately normal population, is (40, 48). Use t* = 2.064 for 95% and t* = 2.797 for 99% (df = 24). If a 99% interval is built from the same data, which interval results?', null, md5('APSTATS-MCQ-SV-H-4.2-B-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(40, 48)', false, 'The interval depends on the confidence level, so changing from 95% to 99% changes the endpoints.' from version_ins
union all select gen_random_uuid(), id, 'B', '(41.0, 47.0)', false, 'Higher confidence needs a larger critical value and a wider interval, not a narrower one.' from version_ins
union all select gen_random_uuid(), id, 'C', '(38.58, 49.42)', true, 'Correct: the 95% margin is 4, so SE = 4/2.064 = 1.938; the 99% margin is 2.797 x 1.938 = 5.42; interval 44 ± 5.42 = (38.58, 49.42).' from version_ins
union all select gen_random_uuid(), id, 'D', '(39.83, 48.17)', false, 'Scaled the margin by 99/95, but the margin scales with the ratio of critical values, 2.797/2.064.' from version_ins;
-- APSTATS-MCQ-H-4.3-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-4.3-A', 'mcq', 'Claim from an interval for a mean', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company claims that the mean life of its batteries is 14 hours. A random sample of batteries is tested, and a 95% confidence interval for the mean life is (11.2, 13.8) hours. Which conclusion is justified?', null, md5('APSTATS-MCQ-H-4.3-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Because 14 is not in the interval, 14 is not a plausible value for the mean life, so there is convincing evidence the mean differs from 14 hours.', true, 'Correct: 14 lies outside (11.2, 13.8), so a two-sided test at the 5% level would reject a mean of 14.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is still supported, because 14 is only 0.2 above the upper endpoint.', false, 'A value just outside the interval is still outside, so it is not a plausible value at this confidence level.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a 5% chance that the claim is true.', false, 'The interval does not give a probability that a claimed value is true; the parameter is fixed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 95% of these batteries last between 11.2 and 13.8 hours, so the claim is false.', false, 'The interval describes the population mean, not the spread of individual battery lives.' from version_ins;
-- APSTATS-MCQ-SV-H-4.3-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-4.3-A-v1', 'mcq', 'Claim from an interval for a mean (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A coach claims that the mean time to finish a run is 50 minutes. A 95% confidence interval for the mean time, from a random sample of runners, is (46.1, 52.7) minutes. Which conclusion is justified?', null, md5('APSTATS-MCQ-SV-H-4.3-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is not convincing evidence that the mean differs from 50 minutes, because 50 is a plausible value in the interval.', true, 'Correct: 50 is inside (46.1, 52.7), so it is a plausible value and the data do not contradict the claim; the data do not prove it either.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The data prove the mean is 50 minutes.', false, 'An interval that contains the claimed value fails to contradict it but cannot prove it, since many other values are also plausible.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean is more likely to be 50 than any other value, because 50 is close to the middle of the interval.', false, 'Every value in the interval is plausible, and the interval does not rank values by probability.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 95% of the runners finish between 46.1 and 52.7 minutes.', false, 'The interval is about the population mean, not the spread of individual finishing times.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-4.2-A-v1','APSTATS-MCQ-SV-H-4.2-A-v2','APSTATS-MCQ-SV-H-4.2-A-v3','APSTATS-MCQ-H-4.2-B','APSTATS-MCQ-SV-H-4.2-B-v1','APSTATS-MCQ-SV-H-4.2-B-v2','APSTATS-MCQ-SV-H-4.2-B-v3','APSTATS-MCQ-H-4.3-A','APSTATS-MCQ-SV-H-4.3-A-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-4.2-A-v1','APSTATS-MCQ-SV-H-4.2-A-v2','APSTATS-MCQ-SV-H-4.2-A-v3','APSTATS-MCQ-H-4.2-B','APSTATS-MCQ-SV-H-4.2-B-v1','APSTATS-MCQ-SV-H-4.2-B-v2','APSTATS-MCQ-SV-H-4.2-B-v3','APSTATS-MCQ-H-4.3-A','APSTATS-MCQ-SV-H-4.3-A-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
