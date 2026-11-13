begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-h-1.5-b','apstats-mcq-b7-sv-h-1.5-b-v1','apstats-mcq-b7-sv-h-1.5-b-v2','apstats-mcq-b7-sv-h-1.5-b-v3','apstats-mcq-b7-h-1.6-a','apstats-mcq-b7-sv-h-1.6-a-v1','apstats-mcq-b7-sv-h-1.6-a-v2','apstats-mcq-b7-sv-h-1.6-a-v3','apstats-mcq-b7-h-1.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apstats-mcq-b7-h-1.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.5-b', 'mcq', 'read a relative frequency histogram, first recovering the sample size from two bars and then converting percentages of a', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A histogram shows the weights, in pounds, of packages shipped by a store. The bars give relative frequencies in percent, and each bin includes its left endpoint and excludes its right endpoint: 0–10: 5%; 10–20: 15%; 20–30: 30%; 30–40: 25%; 40–50: 15%; 50–60: 10%. The packages in the bars for 0–10 and 50–60 together number 18. How many packages weighed at least 20 pounds but less than 40 pounds?', null, md5('apstats-mcq-b7-h-1.5-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '55', false, '55 is the sum of the two bar heights read as a count, but the heights are percentages of the 120 packages.' from version_ins
union all select gen_random_uuid(), id, 'B', '36', false, '36 is 30% of 120 and counts only the 20–30 bar, leaving out the 30–40 bar.' from version_ins
union all select gen_random_uuid(), id, 'C', '84', false, '84 also includes the 40–50 bar, but a package of exactly 40 pounds falls in the 40–50 bin, and the question says less than 40 pounds.' from version_ins
union all select gen_random_uuid(), id, 'D', '66', true, 'Correct: 5% + 10% = 15% of the packages is 18, so there are 120 packages; the bars for 20–30 and 30–40 total 55% and 0.55(120) = 66.' from version_ins;
-- apstats-mcq-b7-sv-h-1.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.5-b-v1', 'mcq', 'read a relative frequency histogram, first recovering the sample size from two bars and then converting percentages of a (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A histogram shows the waiting times, in minutes, of customers at a service desk. The bars give relative frequencies in percent, and each bin includes its left endpoint and excludes its right endpoint: 0–5: 8%; 5–10: 20%; 10–15: 32%; 15–20: 24%; 20–25: 12%; 25–30: 4%. The customers in the bars for 0–5 and 25–30 together number 30. How many customers waited at least 10 minutes but less than 20 minutes?', null, md5('apstats-mcq-b7-sv-h-1.5-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '56', false, '56 is the total of the bar heights read as a count, but those heights are percentages of the 250 customers.' from version_ins
union all select gen_random_uuid(), id, 'B', '80', false, '80 is 32% of 250 and uses only the 10–15 bar, leaving out the 15–20 bar.' from version_ins
union all select gen_random_uuid(), id, 'C', '140', true, 'Correct: 8% + 4% = 12% of the customers is 30, so there are 250 customers; the bars for 10–15 and 15–20 total 56% and 0.56(250) = 140.' from version_ins
union all select gen_random_uuid(), id, 'D', '170', false, '170 adds the 20–25 bar as well, but a wait of exactly 20 minutes is in the 20–25 bin, and the question says less than 20.' from version_ins;
-- apstats-mcq-b7-sv-h-1.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.5-b-v2', 'mcq', 'read a relative frequency histogram, first recovering the sample size from two bars and then converting percentages of a (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A histogram shows the ages, in years, of visitors to a museum. The bars give relative frequencies in percent, and each bin includes its left endpoint and excludes its right endpoint: 0–20: 10%; 20–40: 15%; 40–60: 35%; 60–80: 25%; 80–100: 15%. The visitors in the bars for 0–20 and 80–100 together number 40. How many visitors were younger than 60?', null, md5('apstats-mcq-b7-sv-h-1.5-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60', false, '60 is the total of the three bar heights read as a count, but the heights are percentages of the 160 visitors.' from version_ins
union all select gen_random_uuid(), id, 'B', '56', false, '56 is 35% of 160 and uses only the tallest bar, leaving out the two younger bars.' from version_ins
union all select gen_random_uuid(), id, 'C', '96', true, 'Correct: 10% + 15% = 25% of the visitors is 40, so there are 160 visitors; the first three bars total 60% and 0.60(160) = 96.' from version_ins
union all select gen_random_uuid(), id, 'D', '136', false, '136 includes the 60–80 bar, but a visitor who is exactly 60 is in the 60–80 bin, and the question says younger than 60.' from version_ins;
-- apstats-mcq-b7-sv-h-1.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.5-b-v3', 'mcq', 'read a relative frequency histogram, first recovering the sample size from two bars and then converting percentages of a (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A histogram shows the scores of students on a 90-point exam. The bars give relative frequencies in percent, and each bin includes its left endpoint and excludes its right endpoint: 0–15: 4%; 15–30: 10%; 30–45: 26%; 45–60: 30%; 60–75: 20%; 75–90: 10%. The students in the bars for 15–30 and 75–90 together number 40. How many students scored at least 30 but less than 60?', null, md5('apstats-mcq-b7-sv-h-1.5-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '56', false, '56 is the total of the bar heights read as a count, but the heights are percentages of the 200 students.' from version_ins
union all select gen_random_uuid(), id, 'B', '52', false, '52 is 26% of 200 and uses only the 30–45 bar, leaving out the 45–60 bar.' from version_ins
union all select gen_random_uuid(), id, 'C', '152', false, '152 adds the 60–75 bar, but a score of exactly 60 is in the 60–75 bin, and the question says less than 60.' from version_ins
union all select gen_random_uuid(), id, 'D', '112', true, 'Correct: 10% + 10% = 20% of the students is 40, so there are 200 students; the bars for 30–45 and 45–60 total 56% and 0.56(200) = 112.' from version_ins;
-- apstats-mcq-b7-h-1.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.6-a', 'mcq', 'choose the description of a quantitative distribution that has shape, resistant center and spread, and unusual features,', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The annual salaries, in thousands of dollars, of the 38 employees of a small firm form a distribution with these features: most salaries are between 42 and 78, with a single peak, a median of 57, Q1 = 50 and Q3 = 64; two employees earn about 140 and 155, far above everyone else; the mean is about 63 and the standard deviation about 22. Which is the best description of the distribution of salaries?', null, md5('apstats-mcq-b7-h-1.6-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The salaries are roughly symmetric and centered near $63 thousand, and they typically vary from the center by about $22 thousand.', false, 'The mean and standard deviation are pulled up by the two high salaries, and the description ignores that outliers make the shape skewed to the right.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The distribution is skewed right, with a median of 57 and an interquartile range of 14.', false, 'This gives shape, center and spread but with no units or context and no mention of the two unusually high salaries, so it is not a complete description in context.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The salaries are skewed to the right by two high outliers (about $140 thousand and $155 thousand); the typical salary is about $57 thousand, and the middle 50% span about $14 thousand.', true, 'Correct: IQR = 64 − 50 = 14, and the fence 64 + 1.5(14) = 85 is below 140 and 155, so they are outliers; they pull the mean (63) above the median (57), so median and IQR describe the center and spread.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The salaries are bimodal, with one peak near $57 thousand and a second peak near $150 thousand.', false, 'Two isolated values do not form a second peak; they are unusual values (outliers) in a distribution that has one peak.' from version_ins;
-- apstats-mcq-b7-sv-h-1.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.6-a-v1', 'mcq', 'choose the description of a quantitative distribution that has shape, resistant center and spread, and unusual features, (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The scores of 30 students on a 100-point exam form a distribution with these features: most scores are between 72 and 96, with a single peak, a median of 85, Q1 = 80 and Q3 = 90; two students scored about 30 and 38, far below everyone else; the mean is about 80 and the standard deviation about 17. Which is the best description of the distribution of scores?', null, md5('apstats-mcq-b7-sv-h-1.6-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The scores are roughly symmetric and centered near 80 points, and they typically vary from the center by about 17 points.', false, 'The mean and standard deviation are distorted by the two low scores, and this description misses that they make the shape skewed to the left.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The distribution is skewed left, with a median of 85 and an interquartile range of 10.', false, 'This states shape, center and spread without any context or units and does not mention the two unusually low scores.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The scores are bimodal, with one peak near 85 points and a second peak near 34 points.', false, 'Two isolated low scores are unusual values (outliers), not a second peak in the distribution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The scores are skewed to the left by two low outliers (about 30 and 38 points); the typical score is about 85 points, and the middle 50% span about 10 points.', true, 'Correct: IQR = 90 − 80 = 10, and the fence 80 − 1.5(10) = 65 is above 30 and 38, so they are low outliers; they pull the mean (80) below the median (85), so median and IQR describe the center and spread.' from version_ins;
-- apstats-mcq-b7-sv-h-1.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.6-a-v2', 'mcq', 'choose the description of a quantitative distribution that has shape, resistant center and spread, and unusual features, (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The numbers of text messages sent in one day by 50 teenagers form a distribution with these features: a single peak at low values and a long tail to the right, a median of 40, Q1 = 22 and Q3 = 60; the largest values are 150 and 190; the mean is about 52. Which is the best description of the distribution?', null, md5('apstats-mcq-b7-sv-h-1.6-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The numbers of messages are skewed to the right; the typical number is about 52 messages, with no unusual values since the largest teens simply text the most.', false, 'The mean is pulled up by the long right tail, and the largest values are beyond the outlier fence, so this description misses an unusual feature.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The numbers of messages are roughly symmetric, with a center near 40 and a spread of about 38 messages.', false, 'A single peak with a long right tail is not symmetric, and the mean being above the median also indicates right skew.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The numbers of messages are skewed to the right with a median of 40, and the values 150 and 190 are not outliers because the mean is only 52.', false, 'The outlier rule uses the quartiles, not the mean, and 150 and 190 exceed the fence of 117.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The numbers of messages are skewed to the right; the typical number is about 40, the middle 50% span about 38 messages, and the two largest values, 150 and 190, are outliers.', true, 'Correct: IQR = 60 − 22 = 38, and the fence 60 + 1.5(38) = 117 is below 150 and 190, so both are high outliers; the mean (52) exceeds the median (40), consistent with right skew.' from version_ins;
-- apstats-mcq-b7-sv-h-1.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.6-a-v3', 'mcq', 'choose the description of a quantitative distribution that has shape, resistant center and spread, and unusual features, (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The heights of 40 adult visitors to a gym form a distribution with these features: a single peak, symmetric and mound-shaped, with mean 72 inches, standard deviation about 3 inches, Q1 = 70 and Q3 = 74; the smallest height is 65 and the largest is 79. Which is the best description of the distribution of heights?', null, md5('apstats-mcq-b7-sv-h-1.6-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The heights are skewed to the left because the smallest height, 65, is farther from the mean than the largest, 79.', false, 'The mean is 72, so 65 is 7 below it and 79 is 7 above it, which is symmetric and not skewed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The heights are roughly symmetric and mound-shaped with no outliers; the typical height is about 72 inches, and heights typically vary from the mean by about 3 inches.', true, 'Correct: IQR = 74 − 70 = 4, so the fences are 70 − 6 = 64 and 74 + 6 = 80, and 65 and 79 are inside them; with a symmetric mound shape the mean and standard deviation are appropriate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The heights are roughly symmetric with a median of 72 inches, but 65 and 79 are outliers because they are the most extreme heights.', false, 'The most extreme values are not outliers just because they are extreme; they must lie beyond the fences, and 65 and 79 do not.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The heights are roughly symmetric and mound-shaped, centered near 72, but a description cannot be given without the median.', false, 'For a roughly symmetric distribution with no outliers, the mean and standard deviation are appropriate summaries, so the median is not required.' from version_ins;
-- apstats-mcq-b7-h-1.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.6-b', 'mcq', 'interpret a bimodal distribution, recognizing that a single mean can fall where few observations lie and that the data m', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A teacher plots the exam scores of her 30 students. The histogram has two separate peaks, one near 60 and one near 90, with about 15 students at each peak and almost no scores between 70 and 80. The mean score is 75. Which interpretation is most appropriate?', null, md5('apstats-mcq-b7-h-1.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mean of 75 describes a typical student well, because the mean is the center of the distribution and most students scored near it.', false, 'A mean can fall in a region with almost no data, and here few students are near 75, so it does not represent a typical score.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Because the distribution has two peaks, it must be skewed, so the median should be reported in place of the mean.', false, 'A bimodal distribution with equal peaks is not skewed, and neither the mean nor the median would describe the two groups well.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean of 75 is a poor description of a typical student, because almost no one scored near 75; the class seems to consist of two groups that should be described separately.', true, 'Correct: Half of the scores cluster near 60 and half near 90, so the mean (75) lies in the gap where almost no student scored and is not a typical value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two peaks are outliers, so they should be removed before the class scores are described.', false, 'The peaks contain all of the students, so they are the main feature of the data and not unusual individual values to delete.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-h-1.5-b','apstats-mcq-b7-sv-h-1.5-b-v1','apstats-mcq-b7-sv-h-1.5-b-v2','apstats-mcq-b7-sv-h-1.5-b-v3','apstats-mcq-b7-h-1.6-a','apstats-mcq-b7-sv-h-1.6-a-v1','apstats-mcq-b7-sv-h-1.6-a-v2','apstats-mcq-b7-sv-h-1.6-a-v3','apstats-mcq-b7-h-1.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b7-h-1.5-b','apstats-mcq-b7-sv-h-1.5-b-v1','apstats-mcq-b7-sv-h-1.5-b-v2','apstats-mcq-b7-sv-h-1.5-b-v3','apstats-mcq-b7-h-1.6-a','apstats-mcq-b7-sv-h-1.6-a-v1','apstats-mcq-b7-sv-h-1.6-a-v2','apstats-mcq-b7-sv-h-1.6-a-v3','apstats-mcq-b7-h-1.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
