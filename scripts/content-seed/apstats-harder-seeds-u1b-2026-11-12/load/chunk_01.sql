begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-h-1.8-a','apstats-mcq-b6-sv-h-1.8-a-v1','apstats-mcq-b6-sv-h-1.8-a-v2','apstats-mcq-b6-sv-h-1.8-a-v3','apstats-mcq-b6-h-1.8-b','apstats-mcq-b6-sv-h-1.8-b-v1','apstats-mcq-b6-sv-h-1.8-b-v2','apstats-mcq-b6-sv-h-1.8-b-v3','apstats-mcq-b6-h-1.9-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apstats-mcq-b6-h-1.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.8-a', 'mcq', 'reason about how correcting an outlying value changes (and does not change) a modified boxplot, fences, whiskers and sum', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A data set of 40 delivery times (minutes) has minimum 6, Q1 15, median 19, Q3 27 and maximum 61, and the next-largest value is 33. The value 61 was a data-entry error, and the correct value is 38. After the correction, which statement about the modified boxplot is correct?', null, md5('apstats-mcq-b6-h-1.8-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Only the maximum of the five-number summary changes, the point at 61 is no longer plotted, and the upper whisker now ends at 38.', true, 'Correct: IQR = 27 − 15 = 12, upper fence = 27 + 1.5(12) = 45; 61 was beyond it but 38 is not, and 38 exceeds 33, so it becomes the largest non-outlier.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The upper whisker ends at the upper fence of 45, because 38 is inside the fence.', false, 'A whisker ends at the largest actual data value inside the fence, not at the fence itself, so it ends at 38.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The IQR decreases, so the box becomes shorter, because the maximum value decreased.', false, 'The IQR is Q3 minus Q1 and the corrected value lies above Q3 both before and after, so the box does not change.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The median decreases, because the corrected value is smaller than the original one.', false, 'The median depends on the position of the middle value, and the changed value stays above the median, so the median stays at 19.' from version_ins;
-- apstats-mcq-b6-sv-h-1.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.8-a-v1', 'mcq', 'reason about how correcting an outlying value changes (and does not change) a modified boxplot, fences, whiskers and sum (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A data set of 50 service times (minutes) has minimum 5, Q1 14, median 18, Q3 26 and maximum 70, and the next-largest value is 35. The value 70 was a typing error, and the correct value is 53. After the correction, which statement about the modified boxplot is correct?', null, md5('apstats-mcq-b6-sv-h-1.8-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The point is no longer an outlier, because 53 is smaller than 70, and the whisker extends to 53.', false, 'Being smaller than before does not remove an outlier; the upper fence is 44 and 53 is still beyond it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The point is still plotted as an outlier, now at 53, the upper whisker still ends at 35, and the box is unchanged.', true, 'Correct: IQR = 26 − 14 = 12, upper fence = 26 + 18 = 44; 53 > 44 so it remains an outlier and the whisker still ends at the largest value inside the fence, 35.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The upper whisker extends to the fence at 44, because the maximum moved closer to it.', false, 'Whiskers end at actual data values, and the largest value inside the fence is 35, so the whisker stays at 35.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q3 decreases, so the box becomes shorter, because the maximum decreased.', false, 'The changed value stays above Q3, so the third quartile and the box are exactly as before.' from version_ins;
-- apstats-mcq-b6-sv-h-1.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.8-a-v2', 'mcq', 'reason about how correcting an outlying value changes (and does not change) a modified boxplot, fences, whiskers and sum (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A set of 50 quiz scores has minimum 5, Q1 62, median 71, Q3 80 and maximum 99. The minimum of 5 was a recording error, and the correct score is 38. Which statement about the numerical summaries after the correction is correct?', null, md5('apstats-mcq-b6-sv-h-1.8-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mean, median, Q1, Q3 and standard deviation all stay the same, because only the minimum changes.', false, 'The mean and standard deviation use every value, so replacing 5 with 38 changes them even though the quartiles are resistant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The median, Q1, Q3 and IQR do not change, the mean increases, and the standard deviation decreases.', true, 'Correct: Both 5 and 38 lie below Q1, so the order positions of Q1, median and Q3 are unchanged; replacing 5 by 38 raises the sum and removes a large deviation from the mean.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The median increases, because the mean increases.', false, 'The median depends only on the middle position, and the corrected value stays below the median, so the median does not move.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The IQR decreases, because the range of the data decreases.', false, 'The IQR comes from Q1 and Q3 only, and both stay the same; only the range shrinks.' from version_ins;
-- apstats-mcq-b6-sv-h-1.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.8-a-v3', 'mcq', 'reason about how correcting an outlying value changes (and does not change) a modified boxplot, fences, whiskers and sum (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A boxplot of 60 daily step counts (in thousands) has Q1 6.0, median 8.5 and Q3 11.0, the upper whisker ends at 15.5, and one point at 21.0 is plotted as an outlier. The 21.0 is correct. Suppose instead that this participant had recorded 40.0. Which statement is correct?', null, md5('apstats-mcq-b6-sv-h-1.8-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The upper fence moves above 40.0, because the maximum is larger, so the point may no longer be an outlier.', false, 'The fence is computed from Q3 and the IQR, not from the maximum, so one larger value does not move it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The upper whisker extends to 40.0, because a whisker always ends at the maximum.', false, 'A whisker ends at the largest value inside the fence; 40.0 is beyond the fence at 18.5 so it is plotted separately.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The upper fence stays at 18.5 and the quartiles stay the same, so the point is still an outlier but is plotted higher.', true, 'Correct: IQR = 11.0 − 6.0 = 5.0, upper fence = 11.0 + 7.5 = 18.5; both 21.0 and 40.0 exceed it, and replacing one value above Q3 leaves the quartiles unchanged.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q3 and the IQR increase, because the data now contain a larger value.', false, 'The quartiles are resistant to one extreme value that stays above Q3, so Q3 and the IQR are unchanged.' from version_ins;
-- apstats-mcq-b6-h-1.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.8-b', 'mcq', 'interpret what a boxplot does and does not show about proportions of data, skew and shape', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A boxplot of 200 exam scores shows a minimum of 43, Q1 55, median 62, Q3 84 and a maximum of 98, with no outliers. Which statement is best supported by the boxplot?', null, md5('apstats-mcq-b6-h-1.8-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fewer students scored between 55 and 62 than between 62 and 84, because the first interval is shorter.', false, 'Each section between consecutive quartiles holds about 25% of the data regardless of its length, so both hold about 50 students.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Half of the students scored above 62, and those scores are spread over a wider interval than the scores below 62, which suggests the distribution is skewed right.', true, 'Correct: Quartile gaps: 62 − 55 = 7 below the median and 84 − 62 = 22 above it; each quarter of the data lies between consecutive summary values, so the upper quarters are stretched out.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About half of the students scored between 62 and 84, because that interval is the right part of the box.', false, 'The whole box from 55 to 84 holds about 50% of the data, so 62 to 84 holds only about 25%.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The distribution is bimodal, because the median line splits the box into two parts.', false, 'A boxplot does not display peaks, so it cannot show that a distribution has two modes.' from version_ins;
-- apstats-mcq-b6-sv-h-1.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.8-b-v1', 'mcq', 'interpret what a boxplot does and does not show about proportions of data, skew and shape (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A boxplot of 150 phone-battery lifetimes (hours) shows a minimum of 9, Q1 31, median 38, Q3 42 and a maximum of 47. Which statement is best supported by the boxplot?', null, md5('apstats-mcq-b6-sv-h-1.8-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The distribution is skewed right, because most of the lifetimes are bunched at the high end.', false, 'Skew is named by the direction of the longer tail; the longer tail here is on the low side, so the distribution is skewed left.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 75% of the batteries last between 31 and 42 hours, because that interval is the box.', false, 'The box from Q1 to Q3 holds only about 50% of the data, not 75%.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean battery life is greater than 38 hours, because the median is closer to Q3 than to Q1.', false, 'With the long tail on the low side, the mean is pulled below the median, so it is expected to be less than 38.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 75% of the batteries last longer than 31 hours, and the long lower whisker suggests the distribution is skewed left.', true, 'Correct: Q1 = 31 means about 75% of values are above 31; the lower whisker spans 31 − 9 = 22 hours while the upper whisker spans only 47 − 42 = 5 hours.' from version_ins;
-- apstats-mcq-b6-sv-h-1.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.8-b-v2', 'mcq', 'interpret what a boxplot does and does not show about proportions of data, skew and shape (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A boxplot summarizes 120 reaction times (milliseconds). Which of the following can NOT be determined from the boxplot alone?', null, md5('apstats-mcq-b6-sv-h-1.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximate value of the median reaction time.', false, 'The median is marked by the line inside the box, so it can be read from the plot.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Whether the distribution of reaction times has one peak or two peaks.', true, 'Correct: A boxplot shows only the five-number summary and flagged outliers, so features such as modes require a histogram or dotplot.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Whether any reaction times would be flagged as outliers by the 1.5 IQR rule.', false, 'Modified boxplots show flagged values as separate points beyond the whiskers, so these can be seen.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximate size of the IQR.', false, 'The IQR is the length of the box, from Q1 to Q3, so it can be read from the plot.' from version_ins;
-- apstats-mcq-b6-sv-h-1.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.8-b-v3', 'mcq', 'interpret what a boxplot does and does not show about proportions of data, skew and shape (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A boxplot of 80 delivery times (minutes) has Q1 31, median 40 and Q3 52. About how many of the 80 deliveries took between 31 and 52 minutes?', null, md5('apstats-mcq-b6-sv-h-1.8-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 20 deliveries.', false, 'One quarter of the data lies between 31 and 40, but the interval from 31 to 52 contains two quarters, not one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 40 deliveries.', true, 'Correct: Q1 to Q3 contains the middle 50% of the data, so 0.50 × 80 = 40 deliveries.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 60 deliveries.', false, 'Three quarters of the data lie below Q3, but the question asks only about the part above Q1, which is the middle 50%.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 21 deliveries.', false, 'The difference 52 − 31 = 21 is a length in minutes, not a count of deliveries.' from version_ins;
-- apstats-mcq-b6-h-1.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.9-a', 'mcq', 'choose resistant or non-resistant summaries to compare two distributions given skew and outliers', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Commute times (minutes) are recorded for two routes. Route A: mean 31, median 27, standard deviation 14, IQR 10, skewed right with two very long trips. Route B: mean 29, median 29, standard deviation 6, IQR 8, roughly symmetric with no outliers. Which comparison is most appropriate?', null, md5('apstats-mcq-b6-h-1.9-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Typical commutes are slightly shorter on Route A (median 27 compared with 29), its higher mean comes from a few very long trips, and its middle half is only a little more spread out.', true, 'Correct: Medians 27 and 29 show A is typically shorter; mean 31 above median 27 signals right skew; IQRs 10 and 8 compare the middle halves, while SD 14 reflects the outliers.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Route B has the shorter typical commute, because its mean of 29 is smaller than the mean of 31.', false, 'For a right-skewed distribution with outliers the mean is pulled upward, so the medians are the better measure of typical commute.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The middle half of Route A''s commutes is more than twice as spread out as Route B''s, because 14 is more than twice 6.', false, 'The standard deviation is inflated by the long trips; the IQRs, 10 and 8, show the middle halves are similar in spread.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two routes cannot be compared, because only one of the distributions is skewed.', false, 'Distributions with different shapes can still be compared on center, spread and unusual values using resistant measures.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-h-1.8-a','apstats-mcq-b6-sv-h-1.8-a-v1','apstats-mcq-b6-sv-h-1.8-a-v2','apstats-mcq-b6-sv-h-1.8-a-v3','apstats-mcq-b6-h-1.8-b','apstats-mcq-b6-sv-h-1.8-b-v1','apstats-mcq-b6-sv-h-1.8-b-v2','apstats-mcq-b6-sv-h-1.8-b-v3','apstats-mcq-b6-h-1.9-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b6-h-1.8-a','apstats-mcq-b6-sv-h-1.8-a-v1','apstats-mcq-b6-sv-h-1.8-a-v2','apstats-mcq-b6-sv-h-1.8-a-v3','apstats-mcq-b6-h-1.8-b','apstats-mcq-b6-sv-h-1.8-b-v1','apstats-mcq-b6-sv-h-1.8-b-v2','apstats-mcq-b6-sv-h-1.8-b-v3','apstats-mcq-b6-h-1.9-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
