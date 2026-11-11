begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.5-A-v3','APSTATS-MCQ-SV-H-3.6-A-v1','APSTATS-MCQ-SV-H-3.6-A-v2','APSTATS-MCQ-SV-H-3.6-A-v3','APSTATS-MCQ-SV-H-3.6-B-v1','APSTATS-MCQ-SV-H-3.6-B-v2','APSTATS-MCQ-SV-H-3.6-B-v3','APSTATS-MCQ-SV-H-3.7-A-v1','APSTATS-MCQ-SV-H-3.7-A-v2'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-3.5-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.5-A-v3', 'mcq', 'Hypotheses from the research question (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A candidate needs more than 50% of the vote to win. A campaign wants to test whether the proportion of all voters supporting the candidate exceeds 50%. In a random sample of 400 voters, 188 support the candidate (47%). Which hypotheses should the campaign test?', null, md5('APSTATS-MCQ-SV-H-3.5-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: p = 0.50, Ha: p < 0.50, where p is the proportion of all voters who support the candidate.', false, 'Followed the sample result (47% is below 50%) instead of the question.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: p >= 0.50, Ha: p = 0.50, where p is the proportion of all voters who support the candidate.', false, 'The alternative hypothesis never contains equality.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: p = 0.47, Ha: p > 0.47, where p is the proportion of all voters who support the candidate.', false, 'Used the sample proportion as the null value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: p = 0.50, Ha: p > 0.50, where p is the proportion of all voters who support the candidate.', true, 'Correct: the question is whether support exceeds 50%.' from version_ins;
-- APSTATS-MCQ-SV-H-3.6-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.6-A-v1', 'mcq', 'p-value for a one- or two-sided alternative (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A significance test of H0: p = 0.30 versus Ha: p != 0.30 gives a test statistic z = 2.10. For a standard normal distribution, P(Z > 2.10) = 0.018. Using a significance level of alpha = 0.01, which conclusion is correct?', null, md5('APSTATS-MCQ-SV-H-3.6-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fail to reject H0, because the two-sided p-value is 2(0.018) = 0.036, which is greater than 0.01.', true, 'Correct: two-sided p = 0.036 > 0.01.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Reject H0, because 0.018 is less than 0.05.', false, 'Compared with the wrong significance level, 0.05.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Reject H0, because z = 2.10 is greater than 2.', false, 'Compared z with a number instead of comparing the p-value with alpha.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Fail to reject H0, because 0.036 is the probability that H0 is true.', false, 'The decision is right, but a p-value is not the probability that H0 is true.' from version_ins;
-- APSTATS-MCQ-SV-H-3.6-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.6-A-v2', 'mcq', 'p-value for a one- or two-sided alternative (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A significance test of H0: p = 0.40 versus Ha: p > 0.40 gives a test statistic z = 1.70. For a standard normal distribution, P(Z > 1.70) = 0.045. Using a significance level of alpha = 0.05, which conclusion is correct?', null, md5('APSTATS-MCQ-SV-H-3.6-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fail to reject H0, because the two-sided p-value is 2(0.045) = 0.090.', false, 'Doubled the tail area, but the alternative is one-sided.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fail to reject H0, because z = 1.70 is smaller than 1.96.', false, '1.96 applies to a two-sided 5% test, not to this one-sided test.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Reject H0, because 0.045 is the probability that H0 is true.', false, 'The decision is right, but a p-value is not the probability that H0 is true.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Reject H0, because the p-value for this one-sided alternative is 0.045, which is less than 0.05.', true, 'Correct: Ha is one-sided so the p-value is the single tail, 0.045 < 0.05.' from version_ins;
-- APSTATS-MCQ-SV-H-3.6-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.6-A-v3', 'mcq', 'p-value for a one- or two-sided alternative (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A significance test of H0: p = 0.25 versus Ha: p != 0.25 gives a test statistic z = -2.40. For a standard normal distribution, P(Z < -2.40) = 0.008. Using a significance level of alpha = 0.01, which conclusion is correct?', null, md5('APSTATS-MCQ-SV-H-3.6-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Reject H0, because the p-value is 0.008, which is less than 0.01.', false, 'Used a one-sided tail for a two-sided alternative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fail to reject H0, because the test statistic is negative.', false, 'The sign of z only gives the direction, and the p-value depends on the size of z.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Reject H0, because 0.016 is smaller than 0.05.', false, 'Compared with 0.05 although alpha is 0.01.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Fail to reject H0, because the two-sided p-value is 2(0.008) = 0.016, which is greater than 0.01.', true, 'Correct: two-sided p = 0.016 > 0.01.' from version_ins;
-- APSTATS-MCQ-SV-H-3.6-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.6-B-v1', 'mcq', 'Statistical versus practical significance (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A principal claims that 40% of students walk to school. A researcher tests H0: p = 0.40 versus Ha: p != 0.40 using a random sample of only 40 students, 21 of whom (52.5%) walk. The p-value is about 0.11. Using alpha = 0.05, which conclusion is best?', null, md5('APSTATS-MCQ-SV-H-3.6-B-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is convincing evidence that exactly 40% of students walk, because the test failed to reject H0.', false, 'Failing to reject H0 does not show that H0 is true.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is convincing evidence that the proportion differs from 40%, because 65% is much larger than 40%.', false, 'The p-value of 0.11 is above 0.05, and a small sample can produce a large gap by chance.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is an 11% chance that the principal is correct.', false, 'A p-value is computed assuming H0 is true; it is not the probability that H0 is true.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is not convincing evidence of a difference at the 0.05 level, but the sample was small and the gap of 12.5 percentage points is sizable, so a larger sample would be informative.', true, 'Correct: z = 0.125 / sqrt(0.4 x 0.6 / 40) = 1.61; two-sided p = 0.107; np0 = 16 and n(1 - p0) = 24 so the z-test is valid.' from version_ins;
-- APSTATS-MCQ-SV-H-3.6-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.6-B-v2', 'mcq', 'Statistical versus practical significance (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A city claims that 80% of its buses run on time. A transit analyst tests H0: p = 0.80 versus Ha: p != 0.80 using a random sample of 100,000 bus trips, 79.5% of which were on time. The p-value is about 0.0001. Which conclusion is best?', null, md5('APSTATS-MCQ-SV-H-3.6-B-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is convincing evidence that the on-time rate is much lower than 80%, because the p-value is tiny.', false, 'A small p-value says the gap is unlikely to be chance, not that it is large.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sample is too large to be trusted, so no conclusion can be drawn.', false, 'Large samples give more reliable estimates, and the evidence of a difference is real.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is a 0.01% chance that the city''s claim of 80% is correct.', false, 'A p-value is computed assuming H0 is true, not the probability that H0 is true.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is convincing evidence that the on-time rate differs from 80%, but a half-percentage-point gap is small, so it may not matter in practice.', true, 'Correct: SE = sqrt(0.8 x 0.2 / 100,000) = 0.00126; z = -0.005 / 0.00126 = -3.95; two-sided p about 0.0001.' from version_ins;
-- APSTATS-MCQ-SV-H-3.6-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.6-B-v3', 'mcq', 'Statistical versus practical significance (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two researchers each test H0: p = 0.50 about different populations. Researcher 1 finds a p-value of about 0.005 with a sample proportion of 0.51 from 20,000 people. Researcher 2 finds a p-value of about 0.005 with a sample proportion of 0.70 from 50 people. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.6-B-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The evidence against H0 is equally strong, but Researcher 1''s difference is much smaller and may not matter in practice.', true, 'Correct: z = 0.01 / sqrt(0.25 / 20,000) = 2.83 and z = 0.20 / sqrt(0.25 / 50) = 2.83, so both p-values are about 0.005; the sample differences are 0.01 and 0.20.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Researcher 2 has stronger evidence, because 0.70 is farther from 0.50 than 0.51.', false, 'Strength of evidence is measured by the p-value, which is the same.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two results have equal evidence against H0 and equal practical importance, because the p-values are the same.', false, 'The same p-value does not mean the same size of effect.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Researcher 1 has stronger evidence, because the sample size is larger.', false, 'The p-values already incorporate sample size.' from version_ins;
-- APSTATS-MCQ-SV-H-3.7-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.7-A-v1', 'mcq', 'Conditions for a one-sample z-test use p0 (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A phone company claims that 20% of its customers use a certain feature. A random sample of 100 customers is selected from the company''s very large customer base, and only 6 of them use the feature. An analyst plans a one-sample z-test of H0: p = 0.20 versus Ha: p < 0.20. Which statement about the large counts condition is correct?', null, md5('APSTATS-MCQ-SV-H-3.7-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The condition is met, because np0 = 100(0.20) = 20 and n(1 - p0) = 100(0.80) = 80 are both at least 10.', true, 'Correct: the test uses p0 = 0.20: np0 = 20 and n(1 - p0) = 80.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The condition is not met, because only 6 sampled customers use the feature, which is less than 10.', false, 'The condition uses the hypothesized proportion, not the sample count of successes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The condition is not met, because p0 = 0.20 is less than 0.50.', false, 'The proportion does not need to be at least 0.50; both expected counts must be at least 10.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The condition is met, because 6 sampled customers is at least 5.', false, 'The rule of 5 applies to expected counts in chi-square tests, and this check uses np0 and n(1 - p0) with a threshold of 10.' from version_ins;
-- APSTATS-MCQ-SV-H-3.7-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.7-A-v2', 'mcq', 'Conditions for a one-sample z-test use p0 (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A town has 500 households. A resident claims that 40% of its households recycle. A random sample of 80 households is selected, and 30 of them (37.5%) recycle. An analyst plans a one-sample z-test of H0: p = 0.40 versus Ha: p < 0.40. Which statement about the conditions is correct?', null, md5('APSTATS-MCQ-SV-H-3.7-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'All conditions are met, because np0 = 32 and n(1 - p0) = 48 are both at least 10.', false, 'The counts condition is met, but the 10% condition also has to be checked.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The large counts condition is not met, because p-hat = 0.375 does not equal 0.40.', false, 'The test statistic compares p-hat with p0; the two need not be equal for conditions to hold.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The random condition is not met, because a sample of 80 is too small.', false, 'The condition is about how the sample was selected, not about its size alone.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The independence (10%) condition is not met, because the sample of 80 is more than 10% of the 500 households.', true, 'Correct: 10% of 500 = 50 < 80; np0 = 32 and n(1 - p0) = 48 are fine.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.5-A-v3','APSTATS-MCQ-SV-H-3.6-A-v1','APSTATS-MCQ-SV-H-3.6-A-v2','APSTATS-MCQ-SV-H-3.6-A-v3','APSTATS-MCQ-SV-H-3.6-B-v1','APSTATS-MCQ-SV-H-3.6-B-v2','APSTATS-MCQ-SV-H-3.6-B-v3','APSTATS-MCQ-SV-H-3.7-A-v1','APSTATS-MCQ-SV-H-3.7-A-v2']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-3.5-A-v3','APSTATS-MCQ-SV-H-3.6-A-v1','APSTATS-MCQ-SV-H-3.6-A-v2','APSTATS-MCQ-SV-H-3.6-A-v3','APSTATS-MCQ-SV-H-3.6-B-v1','APSTATS-MCQ-SV-H-3.6-B-v2','APSTATS-MCQ-SV-H-3.6-B-v3','APSTATS-MCQ-SV-H-3.7-A-v1','APSTATS-MCQ-SV-H-3.7-A-v2']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
