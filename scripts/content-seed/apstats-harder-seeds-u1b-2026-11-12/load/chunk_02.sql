begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-sv-h-1.9-a-v1','apstats-mcq-b6-sv-h-1.9-a-v2','apstats-mcq-b6-sv-h-1.9-a-v3','apstats-mcq-b6-h-1.9-b','apstats-mcq-b6-sv-h-1.9-b-v1','apstats-mcq-b6-sv-h-1.9-b-v2','apstats-mcq-b6-sv-h-1.9-b-v3','apstats-mcq-b6-h-1.10-a','apstats-mcq-b6-sv-h-1.10-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apstats-mcq-b6-sv-h-1.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.9-a-v1', 'mcq', 'choose resistant or non-resistant summaries to compare two distributions given skew and outliers (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Scores on a final exam are recorded for two classes. Class 1: mean 74, median 80, standard deviation 15, IQR 12, skewed left with three very low scores. Class 2: mean 77, median 77, standard deviation 8, IQR 11, roughly symmetric. Which comparison is most appropriate?', null, md5('apstats-mcq-b6-sv-h-1.9-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Class 2 has the higher typical score, because its mean of 77 is greater than 74.', false, 'In a left-skewed distribution the mean is pulled below the typical value, so the medians give the fairer comparison of typical score.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The typical score is higher in Class 1 (median 80 compared with 77), its mean is pulled down by a few very low scores, and the middle halves have similar spread.', true, 'Correct: Median 80 > 77 gives Class 1 the higher typical value; mean below median signals left skew; IQR 12 versus 11 compares the middle halves.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The middle half of Class 1 is nearly twice as wide as that of Class 2, because 15 is nearly twice 8.', false, 'The standard deviation is inflated by the very low scores; the IQRs, 12 and 11, show the middle halves are similar.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Most students in Class 1 scored below most students in Class 2, because the Class 1 mean is lower.', false, 'A lower mean caused by a few extreme scores does not mean most students scored lower; the Class 1 median is actually higher.' from version_ins;
-- apstats-mcq-b6-sv-h-1.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.9-a-v2', 'mcq', 'choose resistant or non-resistant summaries to compare two distributions given skew and outliers (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two machines fill bottles, and the fill volumes (mL) are roughly symmetric with no outliers for each. Machine X: mean 500.2, median 500.1, standard deviation 0.8, IQR 1.1. Machine Y: mean 500.3, median 500.3, standard deviation 2.4, IQR 3.2. Which comparison is best supported?', null, md5('apstats-mcq-b6-sv-h-1.9-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The machines are essentially the same, because their means differ by only 0.1 mL.', false, 'Similar centers say nothing about spread; the standard deviations and IQRs differ by a factor of about three.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The centers are nearly the same, but Machine Y''s fill volumes are about three times as variable as Machine X''s.', true, 'Correct: Ratios: 2.4/0.8 = 3.0 and 3.2/1.1 ≈ 2.9, while the means 500.2 and 500.3 are almost equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Machine Y fills each bottle about 2.4 mL more than Machine X.', false, 'A standard deviation measures typical distance from the mean within one machine, not a shift between machines.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Machine X is the more variable machine, because its mean is the smaller of the two.', false, 'The size of the mean says nothing about spread; both SD and IQR are much smaller for Machine X, so it is less variable.' from version_ins;
-- apstats-mcq-b6-sv-h-1.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.9-a-v3', 'mcq', 'choose resistant or non-resistant summaries to compare two distributions given skew and outliers (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Wait times (minutes) for two bus routes are summarized. Route 1: minimum 2, Q1 5, median 7, Q3 10, maximum 30, where 30 is the only flagged outlier. Route 2: minimum 1, Q1 4, median 8, Q3 14, maximum 16, with no outliers. Which statement about variability is best supported?', null, md5('apstats-mcq-b6-sv-h-1.9-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Route 1 is more variable, because its range of 28 is larger than the range of 15 for Route 2.', false, 'The range depends only on the two extreme values and is inflated by one outlier; the IQRs describe the bulk of the data.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Route 1 has longer typical waits, because its maximum of 30 is larger than 16.', false, 'Typical wait is measured by a center such as the median; the medians are 7 and 8, so Route 1 is not typically longer.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Typical waits are more variable on Route 2, because its IQR is 10 compared with 5, while Route 1''s larger range of 28 comes from a single outlier.', true, 'Correct: IQR1 = 10 − 5 = 5, IQR2 = 14 − 4 = 10; range1 = 30 − 2 = 28 and range2 = 16 − 1 = 15.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The routes have the same variability, because their medians differ by only 1 minute.', false, 'Medians describe center, not spread; the IQRs of 5 and 10 differ by a factor of two.' from version_ins;
-- apstats-mcq-b6-h-1.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.9-b', 'mcq', 'compare two distributions from five-number summaries without confusing box size, extremes and sample size', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Final scores for two classes are summarized by five-number summaries. Class P: 40, 58, 66, 78, 96. Class Q: 62, 72, 80, 86, 94. Which statement is supported?', null, md5('apstats-mcq-b6-h-1.9-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Class Q''s median of 80 is above Class P''s third quartile of 78, so more than half of Class Q''s scores are higher than about 75% of Class P''s scores.', true, 'Correct: P''s third quartile is 78 and Q''s median is 80 > 78; the overlap (62 below 66, 94 and 96 near the top) rules out a complete separation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Every student in Class Q scored higher than every student in Class P.', false, 'The distributions overlap; for example Class Q''s minimum of 62 is below Class P''s median of 66.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Class P''s typical score is higher, because Class P''s maximum of 96 is above Class Q''s maximum of 94.', false, 'Typical score is described by the median, not the maximum, and Class Q''s median is 80 compared with 66.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Class P has more students, because its boxplot is wider.', false, 'The width or length of a boxplot reflects spread of values, not the number of observations.' from version_ins;
-- apstats-mcq-b6-sv-h-1.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.9-b-v1', 'mcq', 'compare two distributions from five-number summaries without confusing box size, extremes and sample size (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Reaction times (milliseconds, lower is faster) for two groups are summarized by five-number summaries. Group P: 210, 240, 260, 290, 340. Group Q: 190, 215, 232, 250, 280. Which statement is supported?', null, md5('apstats-mcq-b6-sv-h-1.9-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Every time in Group Q is faster than every time in Group P.', false, 'Group Q''s slowest time of 280 is slower than Group P''s fastest time of 210, so the distributions overlap.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Group P is typically faster, because its box is longer.', false, 'A longer box means greater spread, not faster times; the median of 260 is slower than Group Q''s median of 232.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Group Q has the larger spread in times, because its maximum of 280 is the smaller maximum.', false, 'A smaller maximum does not imply a larger spread; the IQR is 35 for Group Q compared with 50 for Group P.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At least 75% of Group Q''s times are below Group P''s median of 260 milliseconds.', true, 'Correct: Group Q''s third quartile is 250 < 260, the median of P, so at least 75% of Q is below it.' from version_ins;
-- apstats-mcq-b6-sv-h-1.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.9-b-v2', 'mcq', 'compare two distributions from five-number summaries without confusing box size, extremes and sample size (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Heights (cm) of plants in two groups are summarized by five-number summaries. Group 1: 12, 18, 22, 26, 38. Group 2: 14, 21, 25, 27, 30. Which statement is supported?', null, md5('apstats-mcq-b6-sv-h-1.9-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Group 1 has the higher median, because its maximum of 38 is larger.', false, 'The median is the middle value; the median of Group 1 is 22 and that of Group 2 is 25, so a large maximum does not raise it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The groups have the same center, because the boxes overlap.', false, 'Overlapping boxes do not make the medians equal; the medians are 22 and 25.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Group 2 has the higher median and less variability, with both a smaller IQR and a smaller range.', true, 'Correct: IQR1 = 26 − 18 = 8, IQR2 = 27 − 21 = 6; range1 = 26, range2 = 16; medians 22 and 25.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Group 2 is more variable, because its Q1 of 21 is higher than the Q1 of 18.', false, 'A higher quartile is a shift in location, not more spread; the IQRs are 8 for Group 1 and 6 for Group 2.' from version_ins;
-- apstats-mcq-b6-sv-h-1.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.9-b-v3', 'mcq', 'compare two distributions from five-number summaries without confusing box size, extremes and sample size (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Daily step counts (thousands) are recorded for two people. Person A: minimum 3, Q1 6, median 8, Q3 11, maximum 14, no outliers. Person B: the same Q1, median and Q3, but two days at 25 and 27 are plotted as outliers, and the whisker ends at 14. Which statement is correct?', null, md5('apstats-mcq-b6-sv-h-1.9-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Person B''s mean must equal Person A''s mean, because the boxes are identical.', false, 'The mean uses every value, so two extremely high days raise B''s mean even though the quartiles are the same.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Person B has a larger IQR, because B''s range is larger.', false, 'The IQR depends on Q1 and Q3 only, and these are identical, so the IQRs are equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The centers and middle-half spreads are the same, but Person B has two unusually high days that Person A does not, and these raise B''s mean.', true, 'Correct: Both IQRs are 11 − 6 = 5 and both medians are 8; the outliers affect only the mean and the range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Person B''s median is higher, because of the two high days.', false, 'The median is resistant to extreme values, and both medians are 8.' from version_ins;
-- apstats-mcq-b6-h-1.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.10-a', 'mcq', 'distinguish parameters from statistics and explain why statistics vary from sample to sample', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A county health office wants to know what proportion of the 8,400 households in the county have a working smoke detector. Inspectors visit a random sample of 350 households and find working detectors in 301 of them. Which choice correctly identifies the parameter and the statistic?', null, md5('apstats-mcq-b6-h-1.10-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Parameter: the proportion of all 8,400 households with a working detector. Statistic: 301/350 = 0.86 from the sample.', true, 'Correct: The population is all 8,400 households, the parameter is its true proportion, and the statistic is the sample proportion 301/350 = 0.86.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Parameter: 301/350 = 0.86. Statistic: the proportion of all 8,400 households with a working detector.', false, 'The roles are reversed; a parameter describes the whole population and a statistic describes the sample.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Parameter: the 350 households inspected. Statistic: the 301 households with working detectors.', false, 'Neither is a numerical summary of the right kind; the parameter is a proportion for all households, not the sample itself.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Parameter: the proportion of all 8,400 households with a working detector. Statistic: the count 301.', false, 'The statistic should be the sample proportion 301/350, since the parameter is a proportion and the count 301 depends on the sample size.' from version_ins;
-- apstats-mcq-b6-sv-h-1.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.10-a-v1', 'mcq', 'distinguish parameters from statistics and explain why statistics vary from sample to sample (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A call center wants to know the mean wait time of all 2,000 calls it received last month. A random sample of 60 of these calls has a mean wait of 7.4 minutes. Which choice correctly identifies the parameter and the statistic?', null, md5('apstats-mcq-b6-sv-h-1.10-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Parameter: the sample mean of 7.4 minutes. Statistic: the mean wait time of all 2,000 calls.', false, 'The roles are reversed; the parameter describes the population and the statistic describes the sample.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Parameter: the 2,000 calls. Statistic: the 60 calls.', false, 'Groups of calls are the population and sample; the parameter and statistic are numerical values computed from them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Parameter: the sample size of 60. Statistic: the mean of 7.4 minutes.', false, 'The sample size is not the parameter; the parameter is the unknown mean wait time for all 2,000 calls.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Parameter: the mean wait time of all 2,000 calls. Statistic: the sample mean of 7.4 minutes.', true, 'Correct: The parameter is the population mean for all 2,000 calls, and the statistic is the mean of the 60 sampled calls, 7.4 minutes.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-sv-h-1.9-a-v1','apstats-mcq-b6-sv-h-1.9-a-v2','apstats-mcq-b6-sv-h-1.9-a-v3','apstats-mcq-b6-h-1.9-b','apstats-mcq-b6-sv-h-1.9-b-v1','apstats-mcq-b6-sv-h-1.9-b-v2','apstats-mcq-b6-sv-h-1.9-b-v3','apstats-mcq-b6-h-1.10-a','apstats-mcq-b6-sv-h-1.10-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b6-sv-h-1.9-a-v1','apstats-mcq-b6-sv-h-1.9-a-v2','apstats-mcq-b6-sv-h-1.9-a-v3','apstats-mcq-b6-h-1.9-b','apstats-mcq-b6-sv-h-1.9-b-v1','apstats-mcq-b6-sv-h-1.9-b-v2','apstats-mcq-b6-sv-h-1.9-b-v3','apstats-mcq-b6-h-1.10-a','apstats-mcq-b6-sv-h-1.10-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
