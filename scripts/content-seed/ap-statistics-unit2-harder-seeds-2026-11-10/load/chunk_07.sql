begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.1-B-v2','APSTATS-MCQ-SV-H-2.1-B-v3','APSTATS-MCQ-H-2.2-A','APSTATS-MCQ-SV-H-2.2-A-v1','APSTATS-MCQ-SV-H-2.2-A-v2','APSTATS-MCQ-SV-H-2.2-A-v3','APSTATS-MCQ-H-2.2-B','APSTATS-MCQ-SV-H-2.2-B-v1','APSTATS-MCQ-SV-H-2.2-B-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-2.1-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.1-B-v2', 'mcq', 'Choose a display for groups of different sizes (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An inspector samples items from three factories that produce very different volumes and records whether each item is acceptable, minor defect, or major defect. The inspector wants to see whether the defect pattern differs by factory. Which display is most appropriate?', null, md5('APSTATS-MCQ-SV-H-2.1-B-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A segmented bar graph of the percent of each factory''s sampled items in each defect category.', true, 'Correct: percents within each factory put factories of very different volumes on a common scale.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A pie chart of the defect types for all sampled items combined.', false, 'A combined pie chart hides differences between the factories.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A bar chart of the number of items sampled from each factory.', false, 'The number sampled from each factory says nothing about defect patterns.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A side-by-side bar graph of the number of items in each defect category for each factory.', false, 'Counts of defects are not comparable across factories of very different volumes.' from version_ins;
-- APSTATS-MCQ-SV-H-2.1-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.1-B-v3', 'mcq', 'Choose a display for groups of different sizes (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A segmented bar graph shows, for each of four age groups, the percent who prefer each of three streaming services. If the two variables (age group and service preference) are not associated, what would the graph show?', null, md5('APSTATS-MCQ-SV-H-2.1-B-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The segments would be split in nearly the same proportions in every bar.', true, 'Correct: if the variables are not associated, the distribution of service preference is nearly the same within every age group, so every bar is split in about the same proportions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Four bars of equal height, each split into three equal segments.', false, 'In a segmented bar graph of percents every bar is the same height (100%), but equal splits of exactly one third are not required for no association.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The segments in each bar would be the same size as the group''s sample size.', false, 'Segment size reflects a percent of the group, not the group''s sample size.' from version_ins
union all select gen_random_uuid(), id, 'D', 'One service would take up the largest segment in exactly one of the bars.', false, 'One segment being largest in only one bar would indicate that the distribution differs by group, which suggests association.' from version_ins;
-- APSTATS-MCQ-H-2.2-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.2-A', 'mcq', 'Association from conditional proportions in a two-way table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a clinical study of 500 patients, 200 received Treatment A and 300 received Treatment B.
Treatment A, Recovered: 120
Treatment A, Did not recover: 80
Treatment B, Recovered: 120
Treatment B, Did not recover: 180
Which statement is correct?', null, md5('APSTATS-MCQ-H-2.2-A'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is no association, because the same number of patients (120) recovered under each treatment.', false, 'Equal counts of recovered patients do not mean equal rates when the groups have different sizes (200 versus 300).' from version_ins
union all select gen_random_uuid(), id, 'B', 'Treatment B has the higher recovery rate, because more patients received B (300) than A (200).', false, 'Group size does not determine the recovery rate; B has more patients but a lower rate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The recovery rate is 48% for both treatments, because 240/500 = 0.48.', false, '48% is the overall recovery rate and hides the difference between the treatments.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is an association: 120/200 = 60% of patients on A recovered, compared with 120/300 = 40% on B.', true, 'Correct: 120/200 = 60% of patients on A recovered versus 120/300 = 40% on B, so recovery differs by treatment.' from version_ins;
-- APSTATS-MCQ-SV-H-2.2-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.2-A-v1', 'mcq', 'Association from conditional proportions in a two-way table (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school tracked 400 students: 150 used tutoring and 250 did not.
Tutoring, Passed: 105
Tutoring, Did not pass: 45
No tutoring, Passed: 125
No tutoring, Did not pass: 125
Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.2-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Tutoring does not help, because more students passed without tutoring (125) than with it (105).', false, 'Compares counts of groups of different sizes; the tutored group is smaller but has the higher pass rate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is an association: 105/150 = 70% of tutored students passed, compared with 125/250 = 50% of the others.', true, 'Correct: 105/150 = 70% of tutored students passed versus 125/250 = 50% of the others.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The pass rate is 57.5% for both groups, because 230/400 = 0.575.', false, '57.5% is the overall pass rate and hides the difference between the two groups.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is no association, because 105 and 125 are close.', false, 'Close counts (105 and 125) do not mean close rates; the groups have different sizes.' from version_ins;
-- APSTATS-MCQ-SV-H-2.2-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.2-A-v2', 'mcq', 'Association from conditional proportions in a two-way table (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A delivery company recorded 500 deliveries by area and whether the delivery was late.
City, Late: 90
City, On time: 210
Suburb, Late: 60
Suburb, On time: 140
Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.2-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is an association, because more city deliveries (90) than suburb deliveries (60) were late.', false, 'More late deliveries in the city (90 versus 60) reflects its larger volume, not a higher late rate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The suburb has the lower late rate, because it has fewer deliveries.', false, 'Having fewer deliveries does not make a late rate lower; the rates are equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Lateness is related to area, because 150 of the 500 deliveries were late.', false, 'The overall late rate (30%) matches each group''s rate, which shows no relationship, not one.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is no association in these data: 90/300 = 30% of city deliveries and 60/200 = 30% of suburb deliveries were late.', true, 'Correct: 90/300 = 30% of city and 60/200 = 30% of suburb deliveries were late, so lateness is not associated with area here.' from version_ins;
-- APSTATS-MCQ-SV-H-2.2-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.2-A-v3', 'mcq', 'Association from conditional proportions in a two-way table (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A health app study followed 300 adults: 180 used a sleep app and 120 did not.
Used app, Improved sleep: 72
Used app, Did not improve: 108
Did not use app, Improved sleep: 66
Did not use app, Did not improve: 54
Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.2-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'App users did better, because more app users improved (72) than non-users (66).', false, 'Compares counts of unequal groups; there are more app users, so more can improve even though a smaller share does.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is no association, because 138/300 = 46% improved overall.', false, '46% is the overall improvement rate and hides the difference between the groups.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is an association, and non-users did better: 66/120 = 55% of non-users improved, compared with 72/180 = 40% of app users.', true, 'Correct: 66/120 = 55% of non-users improved versus 72/180 = 40% of app users, so non-users did better in these data.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The app has no effect, because 72 and 66 are nearly equal.', false, 'Nearly equal counts (72 and 66) do not mean equal rates when the group sizes are 180 and 120.' from version_ins;
-- APSTATS-MCQ-H-2.2-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.2-B', 'mcq', 'Conditional probability from joint proportions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A survey classified adults by age group and phone type. The table shows the proportion of all adults in each category.
Under 30, iOS: 0.30
Under 30, Android: 0.20
30 or older, iOS: 0.15
30 or older, Android: 0.35
Among adults who use iOS, what proportion are under 30?', null, md5('APSTATS-MCQ-H-2.2-B'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.30', false, 'This is the joint proportion of the whole group for both categories, not the proportion within the group the question names.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.45', false, 'This is P(iOS), the proportion who use iOS, not the proportion of iOS users who are under 30.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.60', false, 'This is P(iOS | under 30) = 0.30/0.50, the proportion of under-30 adults who use iOS; the question asks for the reverse.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.67', true, 'Correct: P(iOS) = 0.30 + 0.15 = 0.45, so P(under 30 | iOS) = 0.30/0.45 ≈ 0.67.' from version_ins;
-- APSTATS-MCQ-SV-H-2.2-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.2-B-v1', 'mcq', 'Conditional probability from joint proportions (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A study classified adults by exercise habit and sleep. The table gives the proportion of all adults in each category.
Exercises regularly, Sleeps 8+ hours: 0.24
Exercises regularly, Sleeps less: 0.16
Does not exercise regularly, Sleeps 8+ hours: 0.21
Does not exercise regularly, Sleeps less: 0.39
Among adults who sleep 8 or more hours, what proportion exercise regularly?', null, md5('APSTATS-MCQ-SV-H-2.2-B-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.24', false, 'This is the joint proportion of the whole group for both categories, not the proportion within the group the question names.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.60', false, 'This is P(sleeps 8+ | exercises) = 0.24/0.40, the reverse of what the question asks.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.40', false, 'This is P(exercises), the overall proportion who exercise, not the proportion among those who sleep 8 or more hours.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.53', true, 'Correct: P(sleeps 8+) = 0.24 + 0.21 = 0.45, so P(exercises | sleeps 8+) = 0.24/0.45 ≈ 0.53.' from version_ins;
-- APSTATS-MCQ-SV-H-2.2-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.2-B-v2', 'mcq', 'Conditional probability from joint proportions (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A study classified adults by exercise habit and sleep. The table gives the proportion of all adults in each category.
Exercises regularly, Sleeps 8+ hours: 0.24
Exercises regularly, Sleeps less: 0.16
Does not exercise regularly, Sleeps 8+ hours: 0.21
Does not exercise regularly, Sleeps less: 0.39
Among adults who do not exercise regularly, what proportion sleep 8 or more hours?', null, md5('APSTATS-MCQ-SV-H-2.2-B-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.35', true, 'Correct: P(does not exercise) = 0.21 + 0.39 = 0.60, so P(sleeps 8+ | does not exercise) = 0.21/0.60 = 0.35.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.21', false, 'This is the joint proportion of the whole group for both categories, not the proportion within the group the question names.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.47', false, '0.21/0.45 = P(not exercise | sleeps 8+) ≈ 0.467.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.45', false, 'This is P(sleeps 8+), the overall proportion, not the proportion among those who do not exercise.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.1-B-v2','APSTATS-MCQ-SV-H-2.1-B-v3','APSTATS-MCQ-H-2.2-A','APSTATS-MCQ-SV-H-2.2-A-v1','APSTATS-MCQ-SV-H-2.2-A-v2','APSTATS-MCQ-SV-H-2.2-A-v3','APSTATS-MCQ-H-2.2-B','APSTATS-MCQ-SV-H-2.2-B-v1','APSTATS-MCQ-SV-H-2.2-B-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-2.1-B-v2','APSTATS-MCQ-SV-H-2.1-B-v3','APSTATS-MCQ-H-2.2-A','APSTATS-MCQ-SV-H-2.2-A-v1','APSTATS-MCQ-SV-H-2.2-A-v2','APSTATS-MCQ-SV-H-2.2-A-v3','APSTATS-MCQ-H-2.2-B','APSTATS-MCQ-SV-H-2.2-B-v1','APSTATS-MCQ-SV-H-2.2-B-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
