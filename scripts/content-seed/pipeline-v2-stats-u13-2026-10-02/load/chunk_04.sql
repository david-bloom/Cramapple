begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-081-v1','APSTATS-MCQ-SV-081-v2','APSTATS-MCQ-SV-081-v3','APSTATS-MCQ-SV-002-v1','APSTATS-MCQ-SV-002-v2','APSTATS-MCQ-SV-002-v3','APSTATS-MCQ-SV-020-v1','APSTATS-MCQ-SV-020-v2','APSTATS-MCQ-SV-020-v3','APSTATS-MCQ-SV-024-v1','APSTATS-MCQ-SV-024-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-081-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-081-v1', 'mcq', 'Expected prize', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A raffle ticket pays $10 with probability 0.5, $20 with probability 0.3, and $30 with probability 0.2. What is the expected payout of a ticket?', null, md5('APSTATS-MCQ-SV-081-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '$20', false, 'Unweighted mean of 10, 20, 30.' from version_ins
union all select gen_random_uuid(), id, 'B', '$60', false, 'Sum of the payouts.' from version_ins
union all select gen_random_uuid(), id, 'C', '$10', false, 'The most likely value.' from version_ins
union all select gen_random_uuid(), id, 'D', '$17', true, '10(0.5)+20(0.3)+30(0.2)=5+6+6=17.' from version_ins;
-- APSTATS-MCQ-SV-081-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-081-v2', 'mcq', 'Expected winnings of a game', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a carnival game, a player wins $5 with probability 0.1, wins $1 with probability 0.3, and loses $2 with probability 0.6. What is the expected net winnings per play?', null, md5('APSTATS-MCQ-SV-081-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '$1.33', false, 'Unweighted mean of 5, 1, -2.' from version_ins
union all select gen_random_uuid(), id, 'B', '$0.40', false, 'Sign error.' from version_ins
union all select gen_random_uuid(), id, 'C', '-$0.40', true, '5(0.1)+1(0.3)+(-2)(0.6)=0.5+0.3-1.2=-0.40.' from version_ins
union all select gen_random_uuid(), id, 'D', '$2.00', false, 'Treats loss as +2.' from version_ins;
-- APSTATS-MCQ-SV-081-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-081-v3', 'mcq', 'Mean with a missing probability', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random variable X takes values 0, 2, and 5 with P(X = 0) = 0.25 and P(X = 2) = 0.35. What is E(X)?', null, md5('APSTATS-MCQ-SV-081-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'Most likely value.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.33', false, 'Unweighted mean.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.7', false, 'Omits the 5 term.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.7', true, 'P(X=5)=0.40; E=0+0.7+2.0=2.7.' from version_ins;
-- APSTATS-MCQ-SV-002-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-002-v1', 'mcq', 'Comparing exam performances by z-score', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Priya scored 83 on a chemistry exam whose scores have mean 74 and standard deviation 6. Marcus scored 68 on a history exam whose scores have mean 61 and standard deviation 4. Which student performed better relative to the other students who took the same exam?', null, md5('APSTATS-MCQ-SV-002-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Marcus, because his z-score of 1.75 is higher than Priya''s z-score of 1.5.', true, 'Priya''s z = (83 - 74)/6 = 1.5. Marcus''s z = (68 - 61)/4 = 1.75. Standardizing puts the two exams on a common scale, and Marcus is farther above his own mean in standard-deviation units.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Priya, because her score is about 1.12 times her exam''s mean, compared with about 1.11 times for Marcus.', false, 'Dividing a score by its mean is not standardizing: 83/74 is about 1.12 and 68/61 is about 1.11, but this ignores the SDs. Using z-scores, Marcus (1.75) beats Priya (1.5).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Priya, because she is 9 points above her mean while Marcus is only 7 points above his.', false, 'Raw distances from the mean ignore the spread of each exam. Priya''s 9 points is 9/6 = 1.5 SDs, while Marcus''s 7 points is 7/4 = 1.75 SDs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Priya, because her raw score of 83 is higher than Marcus''s raw score of 68.', false, 'The exams have different means and standard deviations, so raw scores cannot be compared directly; 83 corresponds to z = 1.5 while 68 corresponds to z = 1.75.' from version_ins;
-- APSTATS-MCQ-SV-002-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-002-v2', 'mcq', 'Salary relative to company pay distributions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Lena earns $52,000 at a firm where salaries have mean $45,000 and standard deviation $4,000. Omar earns $61,000 at a different firm where salaries have mean $50,000 and standard deviation $7,000. Relative to the pay at their own firms, who is paid better?', null, md5('APSTATS-MCQ-SV-002-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Omar, because his salary is 22% above his firm''s mean while Lena''s is only 16% above hers.', false, 'Percent above the mean (11,000/50,000 = 22% and 7,000/45,000 = about 16%) is not a standardized comparison because it ignores SDs. Using z-scores, Lena (1.75) is higher than Omar (about 1.57).' from version_ins
union all select gen_random_uuid(), id, 'B', 'Omar, because he earns $11,000 above his firm''s mean while Lena earns only $7,000 above hers.', false, 'Dollar distances from the mean ignore each firm''s spread. $7,000 is 1.75 SDs of Lena''s firm; $11,000 is only about 1.57 SDs of Omar''s firm.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Omar, because $61,000 is a larger salary than $52,000.', false, 'The firms have different pay distributions, so raw salaries are not comparable. Standardizing gives z = 1.75 for Lena and about 1.57 for Omar.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Lena, because her z-score of 1.75 exceeds Omar''s z-score of about 1.57.', true, 'Lena''s z = (52,000 - 45,000)/4,000 = 1.75. Omar''s z = (61,000 - 50,000)/7,000 = about 1.57. Lena sits farther above her firm''s mean in standard-deviation units.' from version_ins;
-- APSTATS-MCQ-SV-002-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-002-v3', 'mcq', 'Which result is more unusual', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Tom scored 35 on a placement test with mean 50 and standard deviation 10. Sue scored 58 on a different placement test with mean 50 and standard deviation 4. Whose result is farther from the typical score on her or his own test, measured in standard deviations?', null, md5('APSTATS-MCQ-SV-002-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sue''s, because her z-score of 2.0 is larger in absolute value than Tom''s z-score of -1.5.', true, 'Tom''s z = (35 - 50)/10 = -1.5, so he is 1.5 SDs below the mean. Sue''s z = (58 - 50)/4 = 2.0, so she is 2.0 SDs above the mean. Distance from the mean in SD units is the absolute z-score, and 2.0 > 1.5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Tom''s, because 35 is lower than 58.', false, 'Which raw score is lower does not determine distance from the mean in SD units; Tom is 1.5 SDs from his mean and Sue is 2.0 SDs from hers.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Tom''s, because he is 15 points from his mean while Sue is only 8 points from hers.', false, 'Raw point distances ignore the spreads. Tom''s 15 points is 1.5 SDs while Sue''s 8 points is 2.0 SDs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither, because Tom''s negative z-score of -1.5 shows he performed worse than Sue and the two cannot be compared.', false, 'A z-score of -1.5 and one of 2.0 can be compared by magnitude: the question asks for distance from the mean, which is |z|. |-1.5| = 1.5 is smaller than |2.0| = 2.0.' from version_ins;
-- APSTATS-MCQ-SV-020-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-020-v1', 'mcq', 'z-score of a plant below the mean', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The heights of seedlings in a greenhouse have mean 35 cm and standard deviation 4 cm. What is the z-score of a seedling that is 29 cm tall?', null, md5('APSTATS-MCQ-SV-020-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.5', false, 'The magnitude is right but the sign is wrong: 29 is below the mean of 35, so the z-score must be negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '-6', false, 'This is only the raw difference 29 - 35; it was not divided by the standard deviation of 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '-1.5', true, 'z = (29 - 35)/4 = -6/4 = -1.5; the seedling is 1.5 SDs below the mean.' from version_ins
union all select gen_random_uuid(), id, 'D', '-0.17', false, 'This divides the difference by the mean (-6/35, about -0.17) instead of by the standard deviation 4.' from version_ins;
-- APSTATS-MCQ-SV-020-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-020-v2', 'mcq', 'z-score of a delivery time', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Package delivery times for a courier have mean 64 minutes and standard deviation 5 minutes. A particular delivery took 72 minutes. What is its z-score?', null, md5('APSTATS-MCQ-SV-020-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.6', true, 'z = (72 - 64)/5 = 8/5 = 1.6.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.125', false, 'This is 72/64, a ratio of the value to the mean, rather than (72 - 64)/5.' from version_ins
union all select gen_random_uuid(), id, 'C', '8', false, 'This is the raw difference 72 - 64; it was never divided by the standard deviation 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '14.4', false, 'This is 72/5: the value was divided by the SD without first subtracting the mean 64.' from version_ins;
-- APSTATS-MCQ-SV-020-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-020-v3', 'mcq', 'z-score of a fast run', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The time for a school''s students to finish a puzzle has mean 12.5 minutes and standard deviation 2.5 minutes. A student finishes in 10 minutes. Find the z-score for this student.', null, md5('APSTATS-MCQ-SV-020-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-2.5', false, 'This is only the difference 10 - 12.5; it was not divided by the SD of 2.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '-1.0', true, 'z = (10 - 12.5)/2.5 = -2.5/2.5 = -1.0.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.0', false, 'The size is correct but the student finished faster than the mean, so the z-score must be negative.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.0', false, 'This is 10/2.5: the value was divided by the SD without subtracting the mean first.' from version_ins;
-- APSTATS-MCQ-SV-024-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-024-v1', 'mcq', 'Median of six ordered values', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Six commute times (in minutes), listed in order, are 3, 5, 7, 8, 12, 15. What is the median commute time?', null, md5('APSTATS-MCQ-SV-024-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7.5', true, 'With n = 6 the median is the mean of the 3rd and 4th values: (7 + 8)/2 = 7.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '15', false, 'This adds the two middle values (7 + 8 = 15) without dividing by 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'This takes only the 3rd value; with an even number of values, the median must average the two middle ones.' from version_ins
union all select gen_random_uuid(), id, 'D', '8.3', false, 'This is the mean of all six values (50/6, about 8.3), not the median.' from version_ins;
-- APSTATS-MCQ-SV-024-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-024-v2', 'mcq', 'Median position for 30 ordered values', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher has 30 test scores arranged from smallest to largest. Which description locates the median of these scores?', null, md5('APSTATS-MCQ-SV-024-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 15th ordered score alone.', false, 'Using only the 15th value would be right only if the middle position (n + 1)/2 were exactly 15, which needs n = 29. With 30 values the median averages the 15th and 16th.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mean of the 15th and 16th ordered scores.', true, 'With 30 values, the two middle positions are 15 and 16, and the median is their average.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean of the 1st and 30th ordered scores.', false, 'This is the midrange (average of min and max), which is not the median.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The 16th ordered score alone, since 30/2 + 1 = 16.', false, 'The position (n + 1)/2 = 15.5 falls halfway between the 15th and 16th values, so both must be averaged.' from version_ins;
commit;
