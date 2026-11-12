begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.6-b-v1','apstats-mcq-b7-sv-h-1.6-b-v2','apstats-mcq-b7-sv-h-1.6-b-v3','apstats-mcq-b7-h-1.7-a','apstats-mcq-b7-sv-h-1.7-a-v1','apstats-mcq-b7-sv-h-1.7-a-v2','apstats-mcq-b7-sv-h-1.7-a-v3','apstats-mcq-b7-h-1.7-b','apstats-mcq-b7-sv-h-1.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apstats-mcq-b7-sv-h-1.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.6-b-v1', 'mcq', 'interpret a bimodal distribution, recognizing that a single mean can fall where few observations lie and that the data m (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A restaurant owner records the time, in minutes, it takes to prepare 40 orders. The histogram has two separate peaks, one near 5 minutes (simple drinks and sides) and one near 25 minutes (full meals), with about 20 orders at each peak and almost none between 12 and 18 minutes. The mean is 15 minutes. Which interpretation is most appropriate?', null, md5('apstats-mcq-b7-sv-h-1.6-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mean of 15 minutes is a poor description of a typical order, because almost no order took about 15 minutes; the orders appear to be two types that should be described separately.', true, 'Correct: About half of the orders took near 5 minutes and half near 25, so the mean of 15 lies in the gap where almost no order falls.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mean of 15 minutes describes a typical order well, because it is the center and most orders took about that long.', false, 'The mean falls in a region with almost no orders, so it is not a typical preparation time.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Because the distribution has two peaks, it must be skewed, so the median should be reported in place of the mean.', false, 'Two peaks of similar size do not make a distribution skewed, and the median would also fall in the gap and be unrepresentative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The orders near 5 and 25 minutes are outliers, so they should be removed before describing the times.', false, 'Each peak contains about half of the orders, so these are the main groups in the data and not unusual values.' from version_ins;
-- apstats-mcq-b7-sv-h-1.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.6-b-v2', 'mcq', 'interpret a bimodal distribution, recognizing that a single mean can fall where few observations lie and that the data m (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A biologist measures the lengths, in centimeters, of 60 fish from one pond. The histogram has two separate peaks, one near 10 cm and one near 22 cm, with about 30 fish at each peak and very few between 14 and 18 cm. The mean length is 16 cm. Which interpretation is most appropriate?', null, md5('apstats-mcq-b7-sv-h-1.6-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mean of 16 cm is a poor description of a typical fish, because very few fish are near 16 cm; the sample appears to combine two groups, such as young and adult fish.', true, 'Correct: Half of the fish are near 10 cm and half near 22 cm, so the mean of 16 cm lies in the gap and few fish are anywhere near it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mean of 16 cm describes a typical fish well, because the mean is the center and the fish are spread evenly around it.', false, 'A mean in a gap does not describe typical values, and the fish are clustered at two lengths rather than around 16 cm.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Because the distribution has two peaks, it must be skewed, so the median should be reported in place of the mean.', false, 'A distribution with two equal peaks is not skewed, and the median would also land in the gap between the groups.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The fish near 10 cm and near 22 cm are outliers, so they should be removed before the lengths are described.', false, 'Each cluster holds half of the fish, so they are the two main groups and not unusual observations to be dropped.' from version_ins;
-- apstats-mcq-b7-sv-h-1.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.6-b-v3', 'mcq', 'interpret a bimodal distribution, recognizing that a single mean can fall where few observations lie and that the data m (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school counselor records the number of hours per week that 50 students spend on homework. The histogram has two separate peaks, one near 2 hours and one near 12 hours, with about 25 students at each peak and almost none between 6 and 8 hours. The mean is 7 hours. Which interpretation is most appropriate?', null, md5('apstats-mcq-b7-sv-h-1.6-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mean of 7 hours is a poor description of a typical student, because almost no one studies about 7 hours; the students appear to form two groups that should be described separately.', true, 'Correct: Half of the students are near 2 hours and half near 12 hours, so the mean of 7 falls where almost no student''s time lies.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mean of 7 hours describes a typical student well, because the mean is the center and most students are close to it.', false, 'Few students are near 7 hours, so the mean is not a typical value for them even though it is the arithmetic center.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Because the distribution has two peaks, it must be skewed, so the median should be reported in place of the mean.', false, 'Two peaks of equal size are not a skewed shape, and the median would also fall between the groups.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The students near 2 hours and near 12 hours are outliers, so they should be removed before the homework times are described.', false, 'The two clusters include essentially all students, so they are the groups to describe and not outliers to delete.' from version_ins;
-- apstats-mcq-b7-h-1.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.7-a', 'mcq', 'determine how a linear change of units (multiply then add) changes the mean and standard deviation.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A test is scored out of 50 points. The raw scores x have mean 31 and standard deviation 4.5. The teacher reports each student''s percent score as y = 2x + 5. Which choice gives the mean and standard deviation of the reported scores y?', null, md5('apstats-mcq-b7-h-1.7-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean 67 and standard deviation 14', false, 'Adding 5 shifts every score and does not change the spread, so the standard deviation is 2(4.5) = 9, not 9 + 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean 67 and standard deviation 9', true, 'Correct: The mean is transformed like each value, 2(31) + 5 = 67; the standard deviation is multiplied by |2| and unaffected by adding 5, so it is 2(4.5) = 9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mean 62 and standard deviation 9', false, 'The mean must also reflect the added 5 points, so it is 2(31) + 5 = 67 and not 2(31) = 62.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean 36 and standard deviation 9.5', false, 'This applies only the addition and ignores the multiplication by 2, which doubles both the center and the spread.' from version_ins;
-- apstats-mcq-b7-sv-h-1.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.7-a-v1', 'mcq', 'determine how a linear change of units (multiply then add) changes the mean and standard deviation. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Daily high temperatures in a city, in degrees Celsius C, have mean 21 and standard deviation 3. Each temperature is converted to degrees Fahrenheit using F = 1.8C + 32. Which choice gives the mean and standard deviation of the temperatures in Fahrenheit?', null, md5('apstats-mcq-b7-sv-h-1.7-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean 69.8 and standard deviation 5.4', true, 'Correct: Mean: 1.8(21) + 32 = 69.8; standard deviation: 1.8(3) = 5.4, since adding 32 does not change the spread.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean 69.8 and standard deviation 37.4', false, 'Adding 32 shifts all the temperatures by the same amount and leaves the spread unchanged, so the standard deviation is 1.8(3) = 5.4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mean 37.8 and standard deviation 5.4', false, 'The mean also gets the 32 added, so the mean is 1.8(21) + 32 = 69.8 and not just 1.8(21).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean 53 and standard deviation 35', false, 'This adds 32 to the mean and the standard deviation and ignores the multiplication by 1.8 that rescales both.' from version_ins;
-- apstats-mcq-b7-sv-h-1.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.7-a-v2', 'mcq', 'determine how a linear change of units (multiply then add) changes the mean and standard deviation. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The hours worked in a week by the employees of a shop have median 34 hours and IQR 6 hours. Each employee''s weekly pay, in dollars, is y = 15x + 40, where x is hours worked. Which choice gives the median and IQR of the weekly pay?', null, md5('apstats-mcq-b7-sv-h-1.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Median 550 dollars and IQR 130 dollars', false, 'The fixed 40 raises every pay amount equally, so it does not change the IQR, which is 15(6) = 90.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Median 510 dollars and IQR 90 dollars', false, 'The median is also raised by the 40, so it is 15(34) + 40 = 550 and not 15(34) = 510.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Median 550 dollars and IQR 90 dollars', true, 'Correct: Median: 15(34) + 40 = 550; IQR: 15(6) = 90, because adding the fixed 40 does not change the distance between the quartiles.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Median 74 dollars and IQR 46 dollars', false, 'This only adds 40 to each summary and leaves out the multiplication by 15 that rescales both the center and the spread.' from version_ins;
-- apstats-mcq-b7-sv-h-1.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.7-a-v3', 'mcq', 'determine how a linear change of units (multiply then add) changes the mean and standard deviation. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quiz deducts 4 points for each error from a starting score of 100, so the score is y = 100 − 4x, where x is the number of errors. The numbers of errors have mean 6.5 and standard deviation 2.5. Which choice gives the mean and standard deviation of the quiz scores?', null, md5('apstats-mcq-b7-sv-h-1.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean 74 and standard deviation 10', true, 'Correct: Mean: 100 − 4(6.5) = 74; standard deviation: |−4|(2.5) = 10, since a standard deviation cannot be negative and adding 100 does not change it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean 74 and standard deviation −10', false, 'A standard deviation is a nonnegative measure of spread, so multiplying by −4 gives 4(2.5) = 10 and not a negative number.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mean 93.5 and standard deviation 10', false, 'The mean must reflect both the multiplication by −4 and the 100 points, so it is 100 − 4(6.5) = 74.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean 74 and standard deviation 90', false, 'The 100 shifts every score and leaves the spread unchanged, so the standard deviation is 10 and not 100 − 10.' from version_ins;
-- apstats-mcq-b7-h-1.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.7-b', 'mcq', 'find and interpret the mean of a combined group from the means and sizes of two subgroups, avoiding the unweighted avera', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Section 1 of a course has 12 students with a mean quiz score of 85, and Section 2 has 28 students with a mean quiz score of 75. The scores from both sections are combined. Which statement is correct?', null, md5('apstats-mcq-b7-h-1.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The combined mean is 80, the average of 85 and 75.', false, 'Averaging 85 and 75 gives each section equal weight, but Section 2 has more than twice as many students and so counts more.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The combined mean cannot be found without knowing the individual scores.', false, 'The sum of each section''s scores is its mean times its size, so the combined mean can be computed from the means and sizes alone.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The combined mean is 78, which is closer to 75 because Section 2 has more students.', true, 'Correct: Total points = 12(85) + 28(75) = 1020 + 2100 = 3120, and 3120/40 = 78; each mean is weighted by its number of students.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The combined mean is 78, and the combined median must also be 78.', false, 'The mean is 78, but the median of the combined scores cannot be determined from the means and sizes, and it need not equal the mean.' from version_ins;
-- apstats-mcq-b7-sv-h-1.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.7-b-v1', 'mcq', 'find and interpret the mean of a combined group from the means and sizes of two subgroups, avoiding the unweighted avera (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A factory has two production lines. Line 1 has 18 machines with a mean output of 240 units per day, and Line 2 has 42 machines with a mean output of 200 units per day. Which statement about the mean output of all 60 machines is correct?', null, md5('apstats-mcq-b7-sv-h-1.7-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mean output of all 60 machines is 220 units, the average of 240 and 200.', false, 'The simple average of 240 and 200 gives the two lines equal weight, but Line 2 has more than twice as many machines.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mean output of all 60 machines cannot be found without the output of each machine.', false, 'Each line''s total output is its mean times its number of machines, so the overall mean can be found from the given means and sizes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean output of all 60 machines is 212 units, and the median output of all 60 machines must also be 212.', false, 'The mean is 212, but the combined median cannot be determined from the means and sizes and need not equal the mean.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mean output of all 60 machines is 212 units, which is closer to 200 because Line 2 has more machines.', true, 'Correct: Total output = 18(240) + 42(200) = 4320 + 8400 = 12720, and 12720/60 = 212.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.6-b-v1','apstats-mcq-b7-sv-h-1.6-b-v2','apstats-mcq-b7-sv-h-1.6-b-v3','apstats-mcq-b7-h-1.7-a','apstats-mcq-b7-sv-h-1.7-a-v1','apstats-mcq-b7-sv-h-1.7-a-v2','apstats-mcq-b7-sv-h-1.7-a-v3','apstats-mcq-b7-h-1.7-b','apstats-mcq-b7-sv-h-1.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b7-sv-h-1.6-b-v1','apstats-mcq-b7-sv-h-1.6-b-v2','apstats-mcq-b7-sv-h-1.6-b-v3','apstats-mcq-b7-h-1.7-a','apstats-mcq-b7-sv-h-1.7-a-v1','apstats-mcq-b7-sv-h-1.7-a-v2','apstats-mcq-b7-sv-h-1.7-a-v3','apstats-mcq-b7-h-1.7-b','apstats-mcq-b7-sv-h-1.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
