begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-001-v1','APSTATS-MCQ-SV-001-v2','APSTATS-MCQ-SV-001-v3','APSTATS-MCQ-SV-019-v1','APSTATS-MCQ-SV-019-v2','APSTATS-MCQ-SV-019-v3','APSTATS-MCQ-SV-023-v1','APSTATS-MCQ-SV-023-v2','APSTATS-MCQ-SV-023-v3','APSTATS-MCQ-SV-027-v1','APSTATS-MCQ-SV-027-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-001-v1', 'mcq', 'Reporting delays on a commuter rail line', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A transit agency records the delay (in minutes) of each of 60 commuter trains in one month. The histogram is strongly right-skewed: most delays are under 10 minutes, but a handful exceed two hours. An analyst wants one measure of center and one measure of spread that will not be distorted by those extreme delays. Which pair should the analyst report, and why?', null, md5('APSTATS-MCQ-SV-001-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean and IQR, because the mean gives the total delay spread evenly across all trains.', false, 'The IQR is resistant, but the mean is still pulled toward the long right tail; a resistant spread does not fix a non-resistant center, and the mean would sit above what a typical train experiences.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Median and range, because the range shows how bad the worst delays were.', false, 'The median is resistant, but the range is determined only by the shortest and longest delays, so it is the spread measure most affected by the two-hour outliers.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Median and IQR, because both depend only on the ordered middle of the data and are not moved by a few very long delays.', true, 'The median is the middle value and the IQR (Q3 - Q1) covers the middle 50% of delays, so a few two-hour delays barely change either one; they are the resistant choices for a right-skewed distribution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean and standard deviation, because they take every train''s delay into account and so reflect the whole month.', false, 'The mean and SD are both pulled upward by the few delays over two hours; including every value is a drawback, not an advantage, when the distribution is skewed with extreme values.' from version_ins;
-- APSTATS-MCQ-SV-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-001-v2', 'mcq', 'Text messages sent by teens', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school counselor asks 80 teens how many text messages they sent yesterday. The distribution is strongly right-skewed with a five-number summary of: Min = 0, Q1 = 12, Median = 30, Q3 = 66, Max = 410. Which description of typical value and variation is most appropriate?', null, md5('APSTATS-MCQ-SV-001-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A median of 30 texts and a range of 410 texts, because the range shows the full spread of the data.', false, 'The median is resistant, but the range 410 - 0 = 410 is determined entirely by the single extreme maximum and so is not resistant to the skew.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A median of 30 texts and an IQR of 36 texts, because the IQR is the distance from the median to Q3.', false, 'The IQR is Q3 - Q1 = 66 - 12 = 54, not Q3 - median = 66 - 30 = 36; 36 is only the upper half of the middle 50%.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A median of 30 texts and an IQR of 54 texts, because neither is pulled by the few extremely high counts.', true, 'IQR = Q3 - Q1 = 66 - 12 = 54. The median (30) and IQR (54) depend on the middle of the ordered data, so the maximum of 410 does not distort them in this skewed distribution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A mean and standard deviation, because they use all 80 reported values.', false, 'The mean and SD are both inflated by the few very high counts like 410; using every value is not a strength for a strongly skewed distribution.' from version_ins;
-- APSTATS-MCQ-SV-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-001-v3', 'mcq', 'Home prices in a neighborhood', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A real estate agent reports that for homes sold in one neighborhood last year, the mean sale price was $410,000 and the median sale price was $325,000. A buyer asks for the single value that best represents a typical home price. Which response is best?', null, md5('APSTATS-MCQ-SV-001-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Report either one, because the mean and median always give the same typical value.', false, 'Here they differ by $85,000, and a mean well above the median indicates right skew; the two are close mainly when the distribution is roughly symmetric.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Report the mean of $410,000, because it accounts for every home''s sale price.', false, 'Including every value is exactly why the mean is dragged upward by a few very expensive homes; $410,000 is higher than half of the homes sold and so overstates a typical price.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Report the median of $325,000, because the mean is pulled above the typical home by a few very expensive sales.', true, 'Mean greater than median signals right skew; the median is resistant to the few high-priced homes, so $325,000 better represents a typical sale.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Report the mean of $410,000, because the median ignores half of the data.', false, 'The median is found from the ordered values, so extreme sale prices cannot pull it up or down. That resistance to outliers is why it better represents a typical home here; it is not a reason to prefer the mean.' from version_ins;
-- APSTATS-MCQ-SV-019-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-019-v1', 'mcq', 'Apartment rents in a city', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Monthly rents for apartments listed in a city are strongly right-skewed because a few luxury units cost far more than the rest. A housing researcher wants to describe the typical rent and how much rents vary. Which pair of statistics is most appropriate?', null, md5('APSTATS-MCQ-SV-019-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Median and range, since the range includes all of the listings.', false, 'Although the median is resistant, the range depends only on the cheapest and most expensive unit, so the luxury listings dominate it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean and IQR, since the IQR is the only resistant spread measure.', false, 'The IQR is resistant, but the mean is pulled toward the luxury rents, so this pair is only half-resistant.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mean and standard deviation, since they are the most commonly used.', false, 'Popularity is not the criterion; the luxury units inflate both the mean and SD in a right-skewed distribution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Median and IQR, since luxury listings barely affect either one.', true, 'Both are resistant: they depend on the middle of the ordered rents, so the few luxury units do not change them much.' from version_ins;
-- APSTATS-MCQ-SV-019-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-019-v2', 'mcq', 'Wingspans of a bird species', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A biologist measures the wingspan of 120 randomly captured adults of one bird species. A histogram is symmetric and mound-shaped with no outliers. Which pair of statistics is most appropriate to describe the center and spread?', null, md5('APSTATS-MCQ-SV-019-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean and SD, since a symmetric distribution without outliers does not distort them.', true, 'With symmetry and no outliers, the mean and SD summarize center and spread well and use all of the data.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean and range, since the range reports the distance between the two extreme wingspans.', false, 'The range uses only the two most extreme values and gives no information about how the middle of the data varies; SD is the better partner for the mean.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Median and IQR, since they should always be used no matter what shape the data have.', false, 'Median and IQR are preferred for skewed distributions or outliers, but nothing requires them for a symmetric distribution; mean and SD are appropriate here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Median and range, since the range is the easiest spread measure to compute.', false, 'Ease of computing is not the criterion, and the range uses only two values, discarding most of the information about spread.' from version_ins;
-- APSTATS-MCQ-SV-019-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-019-v3', 'mcq', 'Waiting times at an urgent care clinic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The waiting times (in minutes) of 150 patients at an urgent care clinic are strongly right-skewed with five-number summary: Min = 2, Q1 = 10, Median = 14, Q3 = 19, Max = 90. Which pair of values best describes the center and spread of the waiting times?', null, md5('APSTATS-MCQ-SV-019-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Median = 14 minutes and IQR = 9 minutes, since neither is affected much by the 90-minute wait.', true, 'IQR = Q3 - Q1 = 19 - 10 = 9. The median and IQR are resistant, so they describe the typical wait well despite the extreme 90.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Median = 14 minutes and range = 88 minutes, since the range shows the full spread.', false, 'The range is 90 - 2 = 88 but it is determined only by the two extremes, so the 90-minute wait dominates it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Median = 14 minutes and spread = 17 minutes, since that is the distance from the minimum to Q3.', false, '19 - 2 = 17 uses the minimum instead of Q1; the IQR is Q3 - Q1 = 9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Median = 14 minutes and spread = 5 minutes, since that is the distance from the median to Q3.', false, '19 - 14 = 5 covers only the upper half of the middle 50%; the IQR is Q3 - Q1 = 9.' from version_ins;
-- APSTATS-MCQ-SV-023-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-023-v1', 'mcq', 'Effect of replacing the largest value', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quiz has these scores: 5, 6, 6, 7, 8, 9, 9, 52. If the largest score were changed from 52 to 520, which summary would stay exactly the same?', null, md5('APSTATS-MCQ-SV-023-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The standard deviation, which stays near 16.', false, 'The SD is about 15.9 now and would rise to about 181 because 520 lies far from the new mean of 71.25; SD depends on every value''s distance from the mean.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The range, which stays at 47.', false, 'The range is max - min: 52 - 5 = 47 becomes 520 - 5 = 515, so it changes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean, which stays at 12.75.', false, 'The mean uses every value: the sum rises from 102 to 570, so the mean changes from 12.75 to 71.25.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The median, which stays at 7.5.', true, 'The median is the average of the middle two values (7 and 8) = 7.5, and neither of those changes when the largest value is replaced.' from version_ins;
-- APSTATS-MCQ-SV-023-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-023-v2', 'mcq', 'Lab timing with a recording error', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A technician records the times (in seconds) for 8 lab trials: 12, 14, 15, 15, 16, 18, 19, 30. The 30 was later found to be a typing error for 300. Which statistic would be least affected by this error?', null, md5('APSTATS-MCQ-SV-023-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The range, because it only involves the two ends of the data.', false, 'Being based on the ends is why it is affected: the range changes from 30 - 12 = 18 to 300 - 12 = 288.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The standard deviation, because it measures typical deviation from the mean.', false, 'The mean itself rises sharply and the 300 is far from it, so the SD increases dramatically.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean, because averaging dilutes one value among eight.', false, 'The sum changes from 139 to 409, so the mean goes from 17.375 to 51.125; dilution does not make it resistant.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The IQR, which is 4 seconds with either value.', true, 'Q1 = (14 + 15)/2 = 14.5 and Q3 = (18 + 19)/2 = 18.5 either way, so IQR = 4; the largest value is not used in either quartile.' from version_ins;
-- APSTATS-MCQ-SV-023-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-023-v3', 'mcq', 'Adding a very low score', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A teacher''s quiz scores are 62, 68, 71, 74, 75, 77, 79 (mean about 72.3, median 74). A late student then turns in a quiz with a score of 3. Which statement about the effect of the new score is correct?', null, md5('APSTATS-MCQ-SV-023-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Neither the mean nor the median changed, since only one score was added.', false, 'Adding a score changes the mean to 63.625 and shifts the middle of eight values to (71 + 74)/2 = 72.5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mean and median both fell by about 8.7 points, since both measure center.', false, 'The median is determined by the middle positions: it only changes from 74 to 72.5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The median fell by about 8.7 points while the mean fell only 1.5, since the median is the middle value.', false, 'The values are swapped: it is the mean that falls by about 8.7 (to 63.6); the median only moves to 72.5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mean fell by about 8.7 points to 63.6, while the median fell by only 1.5 points to 72.5.', true, 'New mean = 509/8 = 63.625 (from 506/7 = 72.29, a drop of 8.66); new median = (71 + 74)/2 = 72.5 (a drop of 1.5). The median is resistant.' from version_ins;
-- APSTATS-MCQ-SV-027-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-027-v1', 'mcq', 'Interpreting reported mean and median', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the lengths of 200 randomly selected leaves, a botanist reports a mean of 52.4 mm, a median of 52.1 mm, and a standard deviation of 6.0 mm. Which conclusion about the shape is most reasonable?', null, md5('APSTATS-MCQ-SV-027-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The distribution is right-skewed, since the mean is larger than the median.', false, 'Any skew rule needs a meaningful gap; a 0.3 mm difference relative to SD 6.0 is negligible and not evidence of right skew.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The distribution is left-skewed, since the median is close to the mean rather than far above it.', false, 'Left skew pulls the mean below the median by a notable amount; a nearly equal mean and median do not show that.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Nothing can be said about shape, since the mean and median describe only center.', false, 'Comparing the mean to the median gives evidence of symmetry or skew, so these two summaries do provide information about shape.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The distribution is roughly symmetric, since the mean and median are nearly equal compared to the spread.', true, 'A 0.3 mm gap is tiny relative to an SD of 6.0 mm, which is consistent with a roughly symmetric distribution.' from version_ins;
-- APSTATS-MCQ-SV-027-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-027-v2', 'mcq', 'Commute time shape from summary statistics', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The commute times of 300 workers have a mean of 38 minutes and a median of 29 minutes. Which description of the distribution is most consistent with these values?', null, md5('APSTATS-MCQ-SV-027-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Left-skewed, because most workers have commutes shorter than the mean.', false, 'Having more than half of values below the mean is consistent with right skew, not left.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Left-skewed, because the mean is greater than the median.', false, 'In left-skewed data the mean is pulled below the median, not above.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Symmetric, because the mean and median are both measures of center.', false, 'In a symmetric distribution the two would be close; a 9-minute gap indicates skew.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Right-skewed, because a few long commutes pull the mean above the median.', true, 'Mean (38) greater than median (29) by 9 minutes is the signature of a long right tail.' from version_ins;
commit;
