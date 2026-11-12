begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.2-a-v1','apstats-mcq-b7-sv-h-1.2-a-v2','apstats-mcq-b7-sv-h-1.2-a-v3','apstats-mcq-b7-h-1.2-b','apstats-mcq-b7-sv-h-1.2-b-v1','apstats-mcq-b7-sv-h-1.2-b-v2','apstats-mcq-b7-sv-h-1.2-b-v3','apstats-mcq-b7-h-1.3-a','apstats-mcq-b7-sv-h-1.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apstats-mcq-b7-sv-h-1.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.2-a-v1', 'mcq', 'classify variables in a data set, recognizing numeric identifiers and ordered categories as categorical and counts as qu (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A clinic keeps these four items for each patient: a chart number, blood type (A, B, AB or O), resting heart rate in beats per minute, and number of visits last year. Which choice lists exactly the variables that are quantitative?', null, md5('apstats-mcq-b7-sv-h-1.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Chart number, resting heart rate and number of visits last year, because each is recorded as a number.', false, 'A chart number identifies a patient, so averaging chart numbers is meaningless and the variable is categorical.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only resting heart rate, because visits are counted in whole numbers and so are categorical.', false, 'A count of visits is numerical and averaging counts is meaningful, so it is quantitative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Resting heart rate and number of visits last year.', true, 'Correct: Averages make sense for heart rate and for visits, but not for chart numbers, which only identify patients, or for blood types, which are categories.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Blood type, resting heart rate and number of visits, because blood types can be listed in an order.', false, 'Blood type is a category regardless of any listing order, so it is not quantitative.' from version_ins;
-- apstats-mcq-b7-sv-h-1.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.2-a-v2', 'mcq', 'classify variables in a data set, recognizing numeric identifiers and ordered categories as categorical and counts as qu (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A youth league records these four items for each player: jersey number, skill level (Beginner, Intermediate or Advanced), minutes played in the last game, and number of fouls committed. Which choice lists exactly the variables that are quantitative?', null, md5('apstats-mcq-b7-sv-h-1.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Jersey number, minutes played and number of fouls, because each is written as a number.', false, 'A jersey number only labels a player, so the average jersey number says nothing and the variable is categorical.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only minutes played, because fouls are counted in whole numbers and so are categorical.', false, 'Fouls are a count, and counts are quantitative because their sums and averages are meaningful.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Skill level, minutes played and number of fouls, because the levels are ordered from low to high.', false, 'Skill level places players in ordered categories, but it is not recorded as a numerical amount, so it is categorical.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Minutes played and number of fouls committed.', true, 'Correct: A jersey number labels a player and skill level is an ordered category; minutes and fouls are numerical measures that can be averaged.' from version_ins;
-- apstats-mcq-b7-sv-h-1.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.2-a-v3', 'mcq', 'classify variables in a data set, recognizing numeric identifiers and ordered categories as categorical and counts as qu (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A car lot records these four items for each used car: a five-digit stock number, body style (sedan, SUV or truck), mileage on the odometer, and number of previous owners. Which choice lists exactly the variables that are quantitative?', null, md5('apstats-mcq-b7-sv-h-1.2-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mileage and number of previous owners.', true, 'Correct: Mileage and the count of owners can be averaged meaningfully, whereas a stock number is an identifier and body style is a category.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Stock number, mileage and number of previous owners, because each is recorded as a number.', false, 'A stock number labels a car, so arithmetic on stock numbers has no meaning and the variable is categorical.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only mileage, because the number of previous owners takes whole-number values and so is categorical.', false, 'A count of owners is quantitative, because it is numerical and its average can be interpreted.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Body style, mileage and number of previous owners, because the styles are listed in the order the lot sells them.', false, 'A body style is a category of car, and listing categories in some order does not make it a number.' from version_ins;
-- apstats-mcq-b7-h-1.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.2-b', 'mcq', 'identify the individuals and the type of each variable in a described data set, where one variable summarizes many subje', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher records data on 45 hospitals in a state. For each hospital she records its county, its number of beds, and the percentage of its patients who were readmitted within 30 days. Which statement correctly describes the data?', null, md5('apstats-mcq-b7-h-1.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The individuals are the hospitals; county is categorical, and number of beds and percentage readmitted are quantitative.', true, 'Correct: One row describes each hospital, so hospitals are the individuals; a county name is a category, while a bed count and a percentage readmitted are numerical values that can be averaged.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The individuals are the patients; county is categorical, and number of beds and percentage readmitted are quantitative.', false, 'The rows of data describe hospitals, and the patients are only summarized within each hospital, so they are not the individuals.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The individuals are the hospitals; county and number of beds are categorical, and only percentage readmitted is quantitative.', false, 'The number of beds is a count and is numerical, so it is quantitative; being a count does not make it a category.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The individuals are the hospitals; county and number of beds are quantitative, and percentage readmitted is categorical because each patient was either readmitted or not.', false, 'The data value recorded for each hospital is a percentage, which is numerical, even though each patient''s own outcome was yes or no.' from version_ins;
-- apstats-mcq-b7-sv-h-1.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.2-b-v1', 'mcq', 'identify the individuals and the type of each variable in a described data set, where one variable summarizes many subje (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher records data on 32 lakes. For each lake she records the state it lies in, its surface area in acres, and the percentage of fish sampled that had detectable mercury. Which statement correctly describes the data?', null, md5('apstats-mcq-b7-sv-h-1.2-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The individuals are the fish sampled; state is categorical, and surface area and percentage with mercury are quantitative.', false, 'The fish are only summarized within each lake, so the lakes, and not the fish, are the individuals described by each row.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The individuals are the lakes; state is categorical, and surface area and percentage with mercury are quantitative.', true, 'Correct: Each row is a lake, so lakes are the individuals; state names are categories, while an area and a percentage are numerical.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The individuals are the lakes; state and surface area are categorical, and only the percentage with mercury is quantitative.', false, 'Surface area is a measured amount that can be averaged, so it is quantitative rather than categorical.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The individuals are the lakes; state and surface area are quantitative, and the percentage with mercury is categorical because each fish either had mercury or did not.', false, 'The value recorded for each lake is a percentage, which is numerical, even though each fish was classified yes or no.' from version_ins;
-- apstats-mcq-b7-sv-h-1.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.2-b-v2', 'mcq', 'identify the individuals and the type of each variable in a described data set, where one variable summarizes many subje (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A state agency records data on 28 school districts. For each district it records the region (North, South, East or West), the number of students enrolled, and the percentage of students who graduated within four years. Which statement correctly describes the data?', null, md5('apstats-mcq-b7-sv-h-1.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The individuals are the students; region is categorical, and enrollment and graduation percentage are quantitative.', false, 'Students appear only through the district totals, so they are not the individuals that the rows describe.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The individuals are the districts; region and enrollment are categorical, and only graduation percentage is quantitative.', false, 'Enrollment is a count that can be averaged across districts, so it is quantitative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The individuals are the districts; region and enrollment are quantitative, and graduation percentage is categorical because each student either graduated or did not.', false, 'A district''s graduation percentage is a number, and the yes-or-no outcome of each student does not make this variable categorical.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The individuals are the districts; region is categorical, and enrollment and graduation percentage are quantitative.', true, 'Correct: One row describes each district, so districts are the individuals; a region is a category, and enrollment and a percentage are numerical.' from version_ins;
-- apstats-mcq-b7-sv-h-1.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.2-b-v3', 'mcq', 'identify the individuals and the type of each variable in a described data set, where one variable summarizes many subje (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An airport analyst records data on 36 flights on one day. For each flight she records the airline, the number of passengers, and the percentage of the scheduled seats that were filled. Which statement correctly describes the data?', null, md5('apstats-mcq-b7-sv-h-1.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The individuals are the airlines; airline is categorical, and number of passengers and percentage of seats filled are quantitative.', false, 'Several flights belong to the same airline, so an airline is a category of the flights and is not the individual described by each row.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The individuals are the flights; airline and number of passengers are categorical, and only percentage of seats filled is quantitative.', false, 'A passenger count is numerical and can be averaged over flights, so it is quantitative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The individuals are the flights; airline is categorical, and number of passengers and percentage of seats filled are quantitative.', true, 'Correct: Each row is one flight, so flights are the individuals; an airline name is a category, while a passenger count and a percentage are numerical.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The individuals are the flights; airline and number of passengers are quantitative, and percentage of seats filled is categorical because each seat was either filled or empty.', false, 'The value recorded for each flight is a percentage, which is numerical, even though each seat was either filled or empty.' from version_ins;
-- apstats-mcq-b7-h-1.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.3-a', 'mcq', 'use a relative frequency and a count to recover the total of a categorical table, then find a conditional percentage amo', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a survey about how they usually get to school, 27 students chose the bus, which was 18% of all students surveyed. Another 34% of all students surveyed chose a car. Among the students who did NOT choose the bus, what percent chose a car, to the nearest tenth of a percent?', null, md5('apstats-mcq-b7-h-1.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '41.5%', true, 'Correct: 27/0.18 = 150 students; 0.34(150) = 51 car riders; 150 − 27 = 123 non-bus students; 51/123 = 0.415.' from version_ins
union all select gen_random_uuid(), id, 'B', '34.0%', false, '34% is the percent of all 150 students who chose a car, and the question restricts attention to the 123 who did not choose the bus.' from version_ins
union all select gen_random_uuid(), id, 'C', '52.0%', false, 'Adding 18% and 34% combines the bus and car percentages, which does not answer a question about cars among non-bus riders.' from version_ins
union all select gen_random_uuid(), id, 'D', '51.0%', false, '51 is the number of car riders, not a percent, and it has not been divided by the 123 students in the group.' from version_ins;
-- apstats-mcq-b7-sv-h-1.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.3-a-v1', 'mcq', 'use a relative frequency and a count to recover the total of a categorical table, then find a conditional percentage amo (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An online pizzeria recorded the orders placed in one week. There were 45 delivery orders, which was 15% of all orders, and 40% of all orders were for pickup. Among the orders that were NOT for delivery, what percent were for pickup, to the nearest tenth of a percent?', null, md5('apstats-mcq-b7-sv-h-1.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40.0%', false, '40% is the share of all 300 orders; the question is about the 255 orders that were not for delivery.' from version_ins
union all select gen_random_uuid(), id, 'B', '55.0%', false, 'Adding 15% and 40% does not describe pickup orders within the non-delivery group.' from version_ins
union all select gen_random_uuid(), id, 'C', '47.1%', true, 'Correct: 45/0.15 = 300 orders; 0.40(300) = 120 pickup orders; 300 − 45 = 255 non-delivery orders; 120/255 = 0.471.' from version_ins
union all select gen_random_uuid(), id, 'D', '85.0%', false, '85% is the share of all orders that were not for delivery, not the share of those orders that were for pickup.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.2-a-v1','apstats-mcq-b7-sv-h-1.2-a-v2','apstats-mcq-b7-sv-h-1.2-a-v3','apstats-mcq-b7-h-1.2-b','apstats-mcq-b7-sv-h-1.2-b-v1','apstats-mcq-b7-sv-h-1.2-b-v2','apstats-mcq-b7-sv-h-1.2-b-v3','apstats-mcq-b7-h-1.3-a','apstats-mcq-b7-sv-h-1.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b7-sv-h-1.2-a-v1','apstats-mcq-b7-sv-h-1.2-a-v2','apstats-mcq-b7-sv-h-1.2-a-v3','apstats-mcq-b7-h-1.2-b','apstats-mcq-b7-sv-h-1.2-b-v1','apstats-mcq-b7-sv-h-1.2-b-v2','apstats-mcq-b7-sv-h-1.2-b-v3','apstats-mcq-b7-h-1.3-a','apstats-mcq-b7-sv-h-1.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
