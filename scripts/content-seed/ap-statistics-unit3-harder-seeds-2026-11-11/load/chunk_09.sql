begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.14-A-v3','APSTATS-MCQ-SV-H-3.15-A-v1','APSTATS-MCQ-SV-H-3.15-A-v2','APSTATS-MCQ-SV-H-3.15-A-v3'])) then raise exception 'chunk 9 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-3.14-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.14-A-v3', 'mcq', 'Homogeneity or independence, and degrees of freedom (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 300 students is classified by grade level (freshman, sophomore, junior, senior) and by whether the student owns a car (yes or no). The researcher wants to know whether grade level and car ownership are related. Which test and degrees of freedom are correct?', null, md5('APSTATS-MCQ-SV-H-3.14-A-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A test of independence, with df = (4 - 1)(2 - 1) = 3.', true, 'Correct: one sample classified on two variables gives independence; df = 3 x 1 = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A test of independence, with df = 8.', false, 'Used rows times columns instead of (rows - 1)(columns - 1) for the degrees of freedom.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A test of homogeneity, with df = 3.', false, 'Homogeneity applies to separate samples from different populations, and here there is one sample.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A test of independence, with df = 5.', false, 'Added the numbers of rows and columns minus 1.' from version_ins;
-- APSTATS-MCQ-SV-H-3.15-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.15-A-v1', 'mcq', 'Expected counts and chi-square conditions (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 100 people was classified by group and response. Group 1 (40 people): 4 responded yes and 36 responded no. Group 2 (60 people): 16 responded yes and 44 responded no. A researcher plans a chi-square test. Which statement about the conditions is correct?', null, md5('APSTATS-MCQ-SV-H-3.15-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The expected counts condition is met, because every expected count is at least 5; the smallest is 40(20)/100 = 8.', true, 'Correct: column totals 20 and 80; expected counts: 8, 32, 12, 48.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The conditions are not met, because the observed count of 4 is less than 5.', false, 'The condition applies to expected counts, and an observed count below 5 does not violate it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The conditions are not met, because the two groups are not the same size.', false, 'Groups of different sizes do not violate any condition, because the check is on expected counts.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The expected counts condition is met, because the observed counts add to 100.', false, 'The total being 100 does not by itself guarantee every expected count is at least 5.' from version_ins;
-- APSTATS-MCQ-SV-H-3.15-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.15-A-v2', 'mcq', 'Expected counts and chi-square conditions (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chi-square test of independence is planned for a random sample of 200 people classified in a 3 x 3 table. The row totals are 30, 50 and 120, and the column totals are 10, 90 and 100. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-3.15-A-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The expected counts condition is met, because the sample size of 200 is large.', false, 'The total sample size does not guarantee that every expected count is large.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The expected counts condition is met, because every row total is at least 30.', false, 'The condition is about expected counts in every cell, not row totals.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The expected counts condition is not met, because some expected counts are less than 5; for example, 30(10)/200 = 1.5.', true, 'Correct: expected count for row 1, column 1 = 1.5 < 5; row 2, column 1 = 2.5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The expected counts condition is not met, because the column totals are not equal.', false, 'Unequal column totals do not violate the condition, because the check is on each expected count.' from version_ins;
-- APSTATS-MCQ-SV-H-3.15-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-3.15-A-v3', 'mcq', 'Expected counts and chi-square conditions (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chi-square test of independence on a 3 x 3 table gives a test statistic of 11.5. For a chi-square distribution with 4 degrees of freedom, P(chi-square > 9.49) = 0.05 and P(chi-square > 13.28) = 0.01. Which conclusion is correct at alpha = 0.05?', null, md5('APSTATS-MCQ-SV-H-3.15-A-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Reject H0, because 11.5 is greater than 9.49; the p-value is between 0.01 and 0.05, so there is convincing evidence of an association.', true, 'Correct: df = (3 - 1)(3 - 1) = 4; 9.49 < 11.5 < 13.28.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fail to reject H0, because 11.5 is less than 13.28.', false, 'Compared with the critical value for 0.01 instead of alpha = 0.05.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Reject H0, because the test statistic is greater than 4, the number of degrees of freedom.', false, 'The comparison is with a critical value or p-value, not with the degrees of freedom.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Reject H0, because 11.5 proves that the two variables are related by cause and effect.', false, 'A significant association does not establish cause and effect.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-3.14-A-v3','APSTATS-MCQ-SV-H-3.15-A-v1','APSTATS-MCQ-SV-H-3.15-A-v2','APSTATS-MCQ-SV-H-3.15-A-v3']) and status='draft')<>4 then raise exception 'chunk 9: expected 4 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-3.14-A-v3','APSTATS-MCQ-SV-H-3.15-A-v1','APSTATS-MCQ-SV-H-3.15-A-v2','APSTATS-MCQ-SV-H-3.15-A-v3']))<>16 then raise exception 'chunk 9: expected 16 choices'; end if;
end $$;
commit;
