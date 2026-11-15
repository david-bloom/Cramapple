begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.11-A-v3','APSTATS-MCQ-SV-H-3.12-A-v1','APSTATS-MCQ-SV-H-3.12-A-v2','APSTATS-MCQ-SV-H-3.12-A-v3','APSTATS-MCQ-SV-H-3.13-A-v1','APSTATS-MCQ-SV-H-3.13-A-v2','APSTATS-MCQ-SV-H-3.13-A-v3','APSTATS-MCQ-SV-H-3.14-A-v1','APSTATS-MCQ-SV-H-3.14-A-v2'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-3.11-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.11-A-v3', 'mcq', 'Claim from an interval for a difference of proportions (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 95% confidence interval for p_B - p_A, the difference in the proportions of all voters who support a candidate in group B and in group A, is (0.04, 0.12). A pollster claims that group A has the higher proportion. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.11-A-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is not supported; the interval suggests group B has the higher proportion, since every plausible value of p_B - p_A is positive.', true, 'Correct: p_B - p_A > 0 means B is higher.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is supported, because 0.04 and 0.12 are both positive.', false, 'Positive values of B - A mean B is larger, not A.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is not supported, because the interval does not contain 0.', false, 'The interval excluding 0 shows a difference, but its direction contradicts the claim.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim cannot be judged, because the interval does not say which group is larger.', false, 'The order in the subtraction tells which group is larger.' from version_ins;
-- APSTATS-MCQ-SV-H-3.12-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.12-A-v1', 'mcq', 'Hypotheses for a difference of proportions (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher wants to know whether the proportion of adults who exercise regularly is different for people who live in cities (population 1) and people who live in rural areas (population 2). In independent random samples, 90 of 150 city residents and 70 of 120 rural residents exercise regularly. Which hypotheses should be tested?', null, md5('APSTATS-MCQ-SV-H-3.12-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: p_1 - p_2 = 0 versus Ha: p_1 - p_2 > 0, where p_1 and p_2 are the proportions of all residents who exercise regularly in each setting.', false, 'The question asks about any difference, not only that city residents are higher.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: p_1 - p_2 = 0 versus Ha: p_1 - p_2 != 0, where p_1 and p_2 are the proportions of all residents who exercise regularly in each setting.', true, 'Correct: "different" is two-sided; sample proportions are 0.60 and 0.583.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: p-hat 1 = p-hat 2 versus Ha: p-hat 1 != p-hat 2.', false, 'Hypotheses are about population parameters, not statistics.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: p_1 - p_2 = 0.017 versus Ha: p_1 - p_2 != 0.017, where p_1 and p_2 are the proportions of all residents who exercise regularly in each setting.', false, 'Used the sample difference as the null value.' from version_ins;
-- APSTATS-MCQ-SV-H-3.12-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.12-A-v2', 'mcq', 'Hypotheses for a difference of proportions (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A factory manager wants evidence that a new process produces a lower proportion of defective items than the old process. In independent random samples, 24 of 200 items from the new process and 18 of 200 items from the old process were defective. Which hypotheses should be tested?', null, md5('APSTATS-MCQ-SV-H-3.12-A-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: p_new - p_old = 0 versus Ha: p_new - p_old < 0, where p_new and p_old are the proportions of all items that are defective.', true, 'Correct: the question asks whether new is lower than old, even though the sample has new (0.12) higher than old (0.09).' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: p_new - p_old = 0 versus Ha: p_new - p_old > 0, where p_new and p_old are the proportions of all items that are defective.', false, 'Followed the sample result (new was higher in the sample) instead of the question.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: p_new - p_old = 0.03 versus Ha: p_new - p_old < 0.03, where p_new and p_old are the proportions of all items that are defective.', false, 'Used the sample difference 0.03 as the null value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: p-hat new - p-hat old = 0 versus Ha: p-hat new - p-hat old < 0.', false, 'Hypotheses are about parameters, not statistics.' from version_ins;
-- APSTATS-MCQ-SV-H-3.12-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.12-A-v3', 'mcq', 'Hypotheses for a difference of proportions (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pollster wants to test whether the proportion of voters who support a measure is greater among voters under 30 (population 1) than among voters 30 and over (population 2). In independent random samples, 45 of 100 young voters and 60 of 120 older voters support the measure. Which hypotheses should be tested?', null, md5('APSTATS-MCQ-SV-H-3.12-A-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: p_1 - p_2 = 0 versus Ha: p_1 - p_2 < 0, where p_1 and p_2 are the proportions of all voters in each group who support the measure.', false, 'Followed the sample result (young voters were lower in the sample).' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: p_1 - p_2 = 0 versus Ha: p_1 - p_2 > 0, where p_1 and p_2 are the proportions of all voters in each group who support the measure.', true, 'Correct: the question asks whether young voters are higher; the sample proportions are 0.45 and 0.50.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: p_1 - p_2 = -0.05 versus Ha: p_1 - p_2 > -0.05, where p_1 and p_2 are the proportions of all voters in each group who support the measure.', false, 'Used the sample difference as the null value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: p_1 = p_2 versus Ha: p-hat 1 > p-hat 2.', false, 'Mixes a parameter statement in the null with a statistic statement in the alternative.' from version_ins;
-- APSTATS-MCQ-SV-H-3.13-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.13-A-v1', 'mcq', 'Two-proportion z-test with pooled standard error (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a random sample of 120 customers who received coupon A, 66 redeemed it; in an independent random sample of 100 customers who received coupon B, 45 redeemed it. A test of H0: p_A = p_B versus Ha: p_A > p_B uses the pooled proportion 111/220 = 0.505. For a standard normal distribution, P(Z > 1.48) = 0.069. Which result is correct at alpha = 0.05?', null, md5('APSTATS-MCQ-SV-H-3.13-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'z = 1.48, p-value = 0.139; fail to reject H0, so there is not convincing evidence that the redemption rate for coupon A is higher.', false, 'Doubled the tail area, but the alternative is one-sided.' from version_ins
union all select gen_random_uuid(), id, 'B', 'z = 1.48, p-value = 0.069; fail to reject H0, so there is not convincing evidence that the redemption rate for coupon A is higher.', true, 'Correct: p-hat A = 0.55, p-hat B = 0.45; SE = sqrt(0.505 x 0.495 x (1/120 + 1/100)) = 0.0677; z = 0.10 / 0.0677 = 1.48.' from version_ins
union all select gen_random_uuid(), id, 'C', 'z = 2.97, p-value = 0.001; reject H0, so there is convincing evidence that the redemption rate for coupon A is higher.', false, 'Divided the pooled variance by n1 + n2, which makes the standard error too small.' from version_ins
union all select gen_random_uuid(), id, 'D', 'z = 1.48, p-value = 0.069; reject H0, because 0.069 is close to 0.05.', false, 'A p-value above alpha means fail to reject, no matter how close it is.' from version_ins;
-- APSTATS-MCQ-SV-H-3.13-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.13-A-v2', 'mcq', 'Two-proportion z-test with pooled standard error (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a random sample of 130 members of group 1, 39 prefer a plan; in an independent random sample of 90 members of group 2, 54 prefer it. A test of H0: p_1 = p_2 versus Ha: p_1 != p_2 uses the pooled proportion 93/220 = 0.423. Which result is correct at alpha = 0.05?', null, md5('APSTATS-MCQ-SV-H-3.13-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'z = -9.01, p-value < 0.001; reject H0, so there is convincing evidence that the proportions differ.', false, 'Divided the pooled variance by n1 + n2, which makes the standard error too small.' from version_ins
union all select gen_random_uuid(), id, 'B', 'z = -4.43, p-value = 0.99; fail to reject H0.', false, 'Used the wrong tail of the distribution for a statistic far below 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'z = -4.58, p-value < 0.001; reject H0, so there is convincing evidence that the proportions differ.', false, 'Used separate (unpooled) proportions in the standard error; under H0: p_1 = p_2 the pooled proportion is used.' from version_ins
union all select gen_random_uuid(), id, 'D', 'z = -4.43, p-value < 0.001; reject H0, so there is convincing evidence that the proportions differ.', true, 'Correct: p-hat 1 = 0.30, p-hat 2 = 0.60; SE = sqrt(0.423 x 0.577 x (1/130 + 1/90)) = 0.0677; z = -0.30 / 0.0677 = -4.43.' from version_ins;
-- APSTATS-MCQ-SV-H-3.13-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.13-A-v3', 'mcq', 'Two-proportion z-test with pooled standard error (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a random sample of 160 patients given treatment X, 72 improved; in an independent random sample of 140 patients given treatment Y, 50 improved. A test of H0: p_X = p_Y versus Ha: p_X > p_Y uses the pooled proportion 122/300 = 0.407. For a standard normal distribution, P(Z > 1.63) = 0.052. Which result is correct at alpha = 0.05?', null, md5('APSTATS-MCQ-SV-H-3.13-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'z = 1.63, p-value = 0.103; fail to reject H0.', false, 'Doubled the tail area, but the alternative is one-sided.' from version_ins
union all select gen_random_uuid(), id, 'B', 'z = 3.27, p-value = 0.001; reject H0, so there is convincing evidence that X is better.', false, 'Divided the pooled variance by n1 + n2 instead of using 1/n1 + 1/n2, which makes the standard error too small.' from version_ins
union all select gen_random_uuid(), id, 'C', 'z = 1.63, p-value = 0.052; fail to reject H0, so there is not convincing evidence that treatment X has the higher improvement rate.', true, 'Correct: p-hat X = 0.45, p-hat Y = 0.357; SE = sqrt(0.407 x 0.593 x (1/160 + 1/140)) = 0.0568; z = 0.093 / 0.0568 = 1.63.' from version_ins
union all select gen_random_uuid(), id, 'D', 'z = 1.63, p-value = 0.052; reject H0, because 0.052 rounds to 0.05.', false, 'A p-value of 0.052 is not less than alpha = 0.05, so H0 is not rejected.' from version_ins;
-- APSTATS-MCQ-SV-H-3.14-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.14-A-v1', 'mcq', 'Homogeneity or independence, and degrees of freedom (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher randomly selects 400 adults from one city and records each adult''s age group (3 groups) and favorite social media platform (3 platforms). The researcher wants to know whether age group and favorite platform are associated. Which test and degrees of freedom are correct?', null, md5('APSTATS-MCQ-SV-H-3.14-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A test of independence, with df = (3 - 1)(3 - 1) = 4.', true, 'Correct: one sample classified on two variables gives independence; df = 2 x 2 = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A test of homogeneity, with df = 4.', false, 'Homogeneity applies to separate samples from different populations, and here there is one sample.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A test of independence, with df = 9.', false, 'Used rows times columns instead of (rows - 1)(columns - 1) for the degrees of freedom.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A test of independence, with df = 3.', false, 'Used the number of categories minus 1 for one variable only.' from version_ins;
-- APSTATS-MCQ-SV-H-3.14-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.14-A-v2', 'mcq', 'Homogeneity or independence, and degrees of freedom (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A health researcher takes independent random samples of 100 patients from each of two clinics and records whether each patient''s outcome is improved, unchanged or worse. The researcher wants to know whether the distribution of outcomes is the same at the two clinics. Which test and degrees of freedom are correct?', null, md5('APSTATS-MCQ-SV-H-3.14-A-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A test of independence, with df = 2.', false, 'Independence applies to one sample classified on two variables.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A test of homogeneity, with df = 5.', false, 'Used the number of cells minus 1, which is the degrees of freedom for a goodness-of-fit test, not for a two-way table.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A test of homogeneity, with df = (2 - 1)(3 - 1) = 2.', true, 'Correct: separate samples from two populations gives homogeneity; df = 1 x 2 = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A test of homogeneity, with df = 1.', false, 'Used the number of clinics minus 1 only.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.11-A-v3','APSTATS-MCQ-SV-H-3.12-A-v1','APSTATS-MCQ-SV-H-3.12-A-v2','APSTATS-MCQ-SV-H-3.12-A-v3','APSTATS-MCQ-SV-H-3.13-A-v1','APSTATS-MCQ-SV-H-3.13-A-v2','APSTATS-MCQ-SV-H-3.13-A-v3','APSTATS-MCQ-SV-H-3.14-A-v1','APSTATS-MCQ-SV-H-3.14-A-v2']) and status='draft')<>9 then raise exception 'chunk 8: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-3.11-A-v3','APSTATS-MCQ-SV-H-3.12-A-v1','APSTATS-MCQ-SV-H-3.12-A-v2','APSTATS-MCQ-SV-H-3.12-A-v3','APSTATS-MCQ-SV-H-3.13-A-v1','APSTATS-MCQ-SV-H-3.13-A-v2','APSTATS-MCQ-SV-H-3.13-A-v3','APSTATS-MCQ-SV-H-3.14-A-v1','APSTATS-MCQ-SV-H-3.14-A-v2']))<>36 then raise exception 'chunk 8: expected 36 choices'; end if;
end $$;
commit;
