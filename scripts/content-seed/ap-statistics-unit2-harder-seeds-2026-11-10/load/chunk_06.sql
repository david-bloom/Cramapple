begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.10-B-v1','APSTATS-MCQ-SV-H-2.10-B-v2','APSTATS-MCQ-SV-H-2.10-B-v3','APSTATS-MCQ-H-2.1-A','APSTATS-MCQ-SV-H-2.1-A-v1','APSTATS-MCQ-SV-H-2.1-A-v2','APSTATS-MCQ-SV-H-2.1-A-v3','APSTATS-MCQ-H-2.1-B','APSTATS-MCQ-SV-H-2.1-B-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-2.10-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.10-B-v1', 'mcq', 'Cumulative binomial probability (at least k) (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Each of 8 independent seeds sprouts with probability 0.30. Let X be the number that sprout. What is P(X ≥ 2)?', null, md5('APSTATS-MCQ-SV-H-2.10-B-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.2965', false, 'This is P(X = 2) only; P(X ≥ 2) includes every value from 2 to 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.9424', false, 'This is P(X ≥ 1); the question asks for at least 2, so P(1) must also be subtracted.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.2553', false, 'This is P(X ≤ 1), the complement of the event asked about.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.7447', true, 'Correct: 1 − 0.7⁸ − 8(0.3)(0.7)⁷ = 0.7447.' from version_ins;
-- APSTATS-MCQ-SV-H-2.10-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.10-B-v2', 'mcq', 'Cumulative binomial probability (at least k) (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Each of 10 independent calls is answered with probability 0.20. Let X be the number answered. What is P(X ≥ 3)?', null, md5('APSTATS-MCQ-SV-H-2.10-B-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.2013', false, 'This is P(X = 3) only; P(X ≥ 3) includes every value from 3 to 10.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.8791', false, 'This is P(X ≤ 3), which includes the values the question excludes.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.3222', true, 'Correct: 1 − P(0) − P(1) − P(2) = 0.3222.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.1209', false, 'This is P(X ≥ 4); the boundary is off by one, because the question asks for at least 3.' from version_ins;
-- APSTATS-MCQ-SV-H-2.10-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.10-B-v3', 'mcq', 'Cumulative binomial probability (at least k) (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Each of 5 independent free throws is made with probability 0.40. Let X be the number made. What is P(X ≥ 4)?', null, md5('APSTATS-MCQ-SV-H-2.10-B-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0768', false, 'This is P(X = 4) only; P(X ≥ 4) also includes P(X = 5).' from version_ins
union all select gen_random_uuid(), id, 'B', '0.0870', true, 'Correct: P(4) + P(5) = 0.0768 + 0.0102 = 0.0870.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.3174', false, 'This is P(X ≥ 3); the boundary is off by one, because the question asks for at least 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.9898', false, 'This is P(X ≤ 4), which is nearly everything; the question asks for 4 or more.' from version_ins;
-- APSTATS-MCQ-H-2.1-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.1-A', 'mcq', 'Compare groups by within-group percent, not counts', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school surveyed 200 students about whether they prefer online meetings.
Freshman, Prefer online: 45
Freshman, Prefer in person: 15
Senior, Prefer online: 56
Senior, Prefer in person: 84
A student says, "More seniors (56) than freshmen (45) prefer online, so seniors are more likely to prefer online." Which is the best evaluation?', null, md5('APSTATS-MCQ-H-2.1-A'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because 56 is greater than 45.', false, 'Compares counts of groups of different sizes; there are far more seniors, so more seniors can prefer online even if a smaller share does.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because 56/200 = 28% of all students are seniors who prefer online, compared with 45/200 = 22.5% for freshmen.', false, 'Uses the percent of all 200 students, which still depends on group size; the fair comparison is within each group.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect, because the groups differ in size: 45/60 = 75% of freshmen prefer online, compared with 56/140 = 40% of seniors.', true, 'Correct: 45/60 = 75% of freshmen prefer online, compared with 56/140 = 40% of seniors, so freshmen are more likely.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect, because 101 of the 200 students prefer online, which is more than half.', false, 'The overall rate (101/200) does not say which group is more likely to prefer online.' from version_ins;
-- APSTATS-MCQ-SV-H-2.1-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.1-A-v1', 'mcq', 'Compare groups by within-group percent, not counts (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A club coordinator recorded whether 250 members attended weekend events.
Art Club, Attended: 60
Art Club, Did not attend: 20
Chess Club, Attended: 85
Chess Club, Did not attend: 85
A member says, "More Chess Club members (85) than Art Club members (60) attended, so Chess Club members are more likely to attend." Which is the best evaluation?', null, md5('APSTATS-MCQ-SV-H-2.1-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is incorrect, because the clubs differ in size: 60/80 = 75% of Art Club members attended, compared with 85/170 = 50% of Chess Club members.', true, 'Correct: 60/80 = 75% of Art Club members attended, compared with 85/170 = 50% of Chess Club members.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because 85 is greater than 60.', false, 'Compares counts of clubs of different sizes; Chess Club is more than twice as large.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect, because 145 of the 250 members attended, which is more than half.', false, 'The overall attendance rate (145/250) does not compare the two clubs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is correct, because 85/250 = 34% of all members are Chess Club attendees, compared with 60/250 = 24% for Art Club.', false, 'Uses the percent of all 250 members, which depends on group size; the fair comparison is within each club.' from version_ins;
-- APSTATS-MCQ-SV-H-2.1-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.1-A-v2', 'mcq', 'Compare groups by within-group percent, not counts (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A survey of 300 commuters recorded where they live and whether they use transit weekly.
Urban, Use transit: 130
Urban, Do not: 70
Rural, Use transit: 20
Rural, Do not: 80
A reporter says, "Urban residents are more likely to use transit, because 130 urban residents do, compared with only 20 rural residents." Which is the best evaluation?', null, md5('APSTATS-MCQ-SV-H-2.1-A-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is wrong, because the group counts cannot be compared at all, so no conclusion is possible.', false, 'Group counts can be compared once they are converted to within-group percentages, so a conclusion is possible.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because 130 is greater than 20, which shows urban residents are more likely.', false, 'The conclusion happens to be right, but a larger count alone is not valid evidence when the groups differ in size.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The conclusion is correct, but the reasoning should compare percentages within each group: 130/200 = 65% of urban residents versus 20/100 = 20% of rural residents.', true, 'Correct: the conclusion holds (65% of urban versus 20% of rural), but the support for it should be the within-group percentages, not the raw counts.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect, because 150 of the 300 commuters use transit, which is exactly half.', false, 'The overall rate of 150/300 does not compare urban and rural residents.' from version_ins;
-- APSTATS-MCQ-SV-H-2.1-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.1-A-v3', 'mcq', 'Compare groups by within-group percent, not counts (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gym has 300 members: 200 are over 40 and 100 are 40 or under. Members were asked whether they use the gym''s app.
Over 40, Use app: 65
Over 40, Do not: 135
40 or under, Use app: 55
40 or under, Do not: 45
A manager says, "About 54% of app users are over 40, so members over 40 are more likely to use the app." Which is the best evaluation?', null, md5('APSTATS-MCQ-SV-H-2.1-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because 54% is greater than 50%.', false, 'A share above 50% of app users is meaningless without comparing it with the group''s share of all members.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because 65 over-40 members use the app, compared with 55 members who are 40 or under.', false, 'Compares counts of unequal groups; there are twice as many over-40 members.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect, because only 120 of the 300 members, or 40%, use the app.', false, 'The overall app-use rate (40%) does not compare the two age groups.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect: over-40 members are 200/300 ≈ 67% of all members, so 54% of app users is below their share; within groups, 65/200 = 32.5% of over-40 members use the app versus 55/100 = 55% of the others.', true, 'Correct: over-40 members are about 67% of all members, so 54% of app users is below their share; within groups, 32.5% of over-40 members use the app versus 55% of the others.' from version_ins;
-- APSTATS-MCQ-H-2.1-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.1-B', 'mcq', 'Choose a display for groups of different sizes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher surveys 1,000 commuters in four cities with very different populations (the smallest sample is 50 people and the largest is 600). Each person reports whether they usually commute by car, transit, or bike. The researcher wants to compare commuting patterns across the four cities. Which display is most appropriate?', null, md5('APSTATS-MCQ-H-2.1-B'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A single pie chart of all 1,000 responses.', false, 'A single pie chart of all 1,000 responses combines the cities and hides the comparison.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A bar chart of the number of people surveyed in each city.', false, 'Showing only how many were surveyed in each city says nothing about commuting patterns.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A segmented bar graph showing, for each city, the percent of that city''s respondents using each commuting mode.', true, 'Correct: a segmented bar graph of within-city percents puts the four cities on a common scale despite very different sample sizes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A side-by-side bar graph showing the number of people using each mode in each city.', false, 'Counts are not comparable across cities of very different sizes; the larger cities will dominate regardless of pattern.' from version_ins;
-- APSTATS-MCQ-SV-H-2.1-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.1-B-v1', 'mcq', 'Choose a display for groups of different sizes (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A coach records the position (guard, forward, center) played by students on three school teams of very different sizes and wants to compare position patterns across the teams. Which display is most appropriate?', null, md5('APSTATS-MCQ-SV-H-2.1-B-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A segmented bar graph of the percent of each team''s students at each position.', true, 'Correct: percents within each team put teams of very different sizes on a common scale.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A bar chart of the number of students on each team.', false, 'The number of students on each team says nothing about the positions played.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A pie chart of all students'' positions combined.', false, 'A combined pie chart hides differences between the teams.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A side-by-side bar graph of the number of students at each position on each team.', false, 'Counts of positions are not comparable across teams of very different sizes.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.10-B-v1','APSTATS-MCQ-SV-H-2.10-B-v2','APSTATS-MCQ-SV-H-2.10-B-v3','APSTATS-MCQ-H-2.1-A','APSTATS-MCQ-SV-H-2.1-A-v1','APSTATS-MCQ-SV-H-2.1-A-v2','APSTATS-MCQ-SV-H-2.1-A-v3','APSTATS-MCQ-H-2.1-B','APSTATS-MCQ-SV-H-2.1-B-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-2.10-B-v1','APSTATS-MCQ-SV-H-2.10-B-v2','APSTATS-MCQ-SV-H-2.10-B-v3','APSTATS-MCQ-H-2.1-A','APSTATS-MCQ-SV-H-2.1-A-v1','APSTATS-MCQ-SV-H-2.1-A-v2','APSTATS-MCQ-SV-H-2.1-A-v3','APSTATS-MCQ-H-2.1-B','APSTATS-MCQ-SV-H-2.1-B-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
