begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.4-a-v3','apstats-mcq-b7-h-1.4-b','apstats-mcq-b7-sv-h-1.4-b-v1','apstats-mcq-b7-sv-h-1.4-b-v2','apstats-mcq-b7-sv-h-1.4-b-v3','apstats-mcq-b7-h-1.5-a','apstats-mcq-b7-sv-h-1.5-a-v1','apstats-mcq-b7-sv-h-1.5-a-v2','apstats-mcq-b7-sv-h-1.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apstats-mcq-b7-sv-h-1.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.4-a-v3', 'mcq', 'evaluate a claim drawn from a bar chart whose vertical axis does not start at zero, comparing visual height with the act (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bar chart shows the enrollment of two regional campuses. The vertical axis starts at 1000 instead of 0. The bar for Campus 1 reaches 1100 students and the bar for Campus 2 reaches 1250 students. A viewer says, "Campus 2''s bar is two and a half times as tall as Campus 1''s, so Campus 2 enrolls two and a half times as many students." Which statement best evaluates the claim?', null, md5('apstats-mcq-b7-sv-h-1.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because the bar for Campus 2 is two and a half times as tall as the bar for Campus 1 and bar heights show enrollment.', false, 'Heights reflect the counts proportionally only when the axis begins at 0; here the axis cuts off most of each bar.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is incorrect: Campus 2 enrolls 150 more students than Campus 1, so it enrolls 150% more students.', false, 'A difference of 150 students is not 150 percent; relative to Campus 1''s 1100 students, it is about 14%.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect: Campus 1 enrolls about 14% more students than Campus 2, because 1250 divided by 1100 is about 1.14.', false, '1250/1100 places Campus 2 over Campus 1, so Campus 2 is the larger campus and Campus 1 does not enroll 14% more.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect: the axis starts at 1000, so the visible bar heights are 100 and 250, but Campus 2 enrolls 1250 students compared with 1100, about 14% more.', true, 'Correct: Visible heights are 1100 − 1000 = 100 and 1250 − 1000 = 250, but 1250/1100 = 1.136, so Campus 2 has about 14% more students.' from version_ins;
-- apstats-mcq-b7-h-1.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.4-b', 'mcq', 'choose a display for a categorical variable that allows multiple responses, recognizing when a pie chart is inappropriat', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A survey of 200 students asked them to mark every after-school activity they take part in. The results: sports 120 students, music 90, art 70 and coding 50 (students could mark more than one). The researcher wants a graph showing the percent of the 200 students who take part in each activity. Which display is most appropriate?', null, md5('apstats-mcq-b7-h-1.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A pie chart with slices labeled 60%, 45%, 35% and 25%.', false, 'Slices of a pie must add to 100%, and these percents sum to 165%, so they cannot be slices because students are counted in several categories.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A bar graph with one bar per activity showing 60%, 45%, 35% and 25%.', true, 'Correct: The percents 60 + 45 + 35 + 25 = 165% exceed 100%, so the categories are not parts of one whole and a pie chart cannot represent them; separate bars can.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A histogram with four touching bars of heights 120, 90, 70 and 50.', false, 'A histogram displays a quantitative variable in intervals, and the activities are categories, so touching bars are not appropriate here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A pie chart with slices proportional to the counts 120, 90, 70 and 50, which total 330.', false, 'A pie of the 330 marks shows each activity''s share of all marks, not the percent of the 200 students who do each activity, so it does not answer the question.' from version_ins;
-- apstats-mcq-b7-sv-h-1.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.4-b-v1', 'mcq', 'choose a display for a categorical variable that allows multiple responses, recognizing when a pie chart is inappropriat (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A store surveyed 150 customers and asked which ways they have shopped there this year; customers could choose more than one. The counts: online 105, in store 75, by phone 60. The manager wants a graph showing the percent of the 150 customers who used each method. Which display is most appropriate?', null, md5('apstats-mcq-b7-sv-h-1.4-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A pie chart with slices labeled 70%, 50% and 40%.', false, 'Pie slices must total 100%, and these total 160% because customers appear in several categories.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A histogram with three touching bars of heights 105, 75 and 60.', false, 'Shopping methods are categories, and a histogram is meant for a quantitative variable grouped in intervals.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A bar graph with one bar per method showing 70%, 50% and 40%.', true, 'Correct: The percents 70 + 50 + 40 = 160% exceed 100%, which means the methods overlap and cannot be slices of one pie, while a bar graph can show each.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A pie chart with slices proportional to the counts 105, 75 and 60, which total 240.', false, 'A pie of the 240 marks gives each method''s share of all marks and not the percent of the 150 customers who used it.' from version_ins;
-- apstats-mcq-b7-sv-h-1.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.4-b-v2', 'mcq', 'choose a display for a categorical variable that allows multiple responses, recognizing when a pie chart is inappropriat (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cable provider surveyed 250 households and asked which streaming services they subscribe to; households could name more than one. The counts: Service P 175, Service Q 125, Service R 100, Service S 25. The provider wants a graph showing the percent of the 250 households that subscribe to each service. Which display is most appropriate?', null, md5('apstats-mcq-b7-sv-h-1.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A pie chart with slices labeled 70%, 50%, 40% and 10%.', false, 'The slices of a pie represent parts of one whole and would have to sum to 100%, but these sum to 170%.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A bar graph with one bar per service showing 70%, 50%, 40% and 10%.', true, 'Correct: The percents 70 + 50 + 40 + 10 = 170%, more than 100%, so a household can fall in several categories and a pie chart would misrepresent the data.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A histogram with four touching bars of heights 175, 125, 100 and 25.', false, 'The services are categories, and a histogram is for a quantitative variable, so it is not the right display for them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A pie chart with slices proportional to the counts 175, 125, 100 and 25, which total 425.', false, 'A pie of the 425 subscriptions shows shares of subscriptions, not the percent of the 250 households that subscribe to each service.' from version_ins;
-- apstats-mcq-b7-sv-h-1.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.4-b-v3', 'mcq', 'choose a display for a categorical variable that allows multiple responses, recognizing when a pie chart is inappropriat (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A clinic recorded the symptoms of 80 patients with a virus; each patient could have several symptoms. The counts: fatigue 48, cough 56, fever 32, sore throat 24. The clinic wants a graph showing the percent of the 80 patients who had each symptom. Which display is most appropriate?', null, md5('apstats-mcq-b7-sv-h-1.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A bar graph with one bar per symptom showing 60%, 70%, 40% and 30%.', true, 'Correct: The percents 60 + 70 + 40 + 30 = 200%, so patients are counted under several symptoms and the categories do not make up one whole.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A pie chart with slices labeled 60%, 70%, 40% and 30%.', false, 'A pie requires slices that total 100%, and these total 200% because many patients have more than one symptom.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A histogram with four touching bars of heights 48, 56, 32 and 24.', false, 'Symptoms are categories, and histograms apply to quantitative data grouped into intervals.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A pie chart with slices proportional to the counts 48, 56, 32 and 24, which total 160.', false, 'A pie of the 160 symptoms reports shares of all symptoms, not the percent of the 80 patients who had each one.' from version_ins;
-- apstats-mcq-b7-h-1.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.5-a', 'mcq', 'locate the interval containing the median from the bar heights of a histogram, avoiding the tallest-bar and axis-midpoin', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A histogram shows the daily screen time, in minutes, of 60 students. Each bin includes its left endpoint and excludes its right endpoint. The bar heights (numbers of students) are: 0–30: 3; 30–60: 7; 60–90: 12; 90–120: 11; 120–150: 15; 150–180: 6; 180–210: 4; 210–240: 2. Which statement about the median screen time is correct?', null, md5('apstats-mcq-b7-h-1.5-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The median is in the interval 120–150 minutes, because that bar is the tallest.', false, 'The tallest bar marks the mode, not the median; only 33 students are below 120, so the 30th and 31st values are in the earlier interval.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The median is exactly 120 minutes, because 120 is the midpoint of the horizontal axis from 0 to 240.', false, 'The middle of the axis is not the middle of the data; the median is determined by how many values lie on each side.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The median cannot be located from a histogram, because the individual data values are not shown.', false, 'A histogram does not show exact values but does show how many values lie in each interval, which is enough to locate the interval containing the median.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The median is in the interval 90–120 minutes.', true, 'Correct: With 60 students the median is the mean of the 30th and 31st values; the cumulative counts are 3, 10, 22, 33, so both are in 90–120.' from version_ins;
-- apstats-mcq-b7-sv-h-1.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.5-a-v1', 'mcq', 'locate the interval containing the median from the bar heights of a histogram, avoiding the tallest-bar and axis-midpoin (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A histogram shows the one-way commute times, in minutes, of 80 workers. Each bin includes its left endpoint and excludes its right endpoint. The bar heights (numbers of workers) are: 0–5: 4; 5–10: 10; 10–15: 18; 15–20: 14; 20–25: 16; 25–30: 10; 30–35: 6; 35–40: 2. Which statement about the median commute time is correct?', null, md5('apstats-mcq-b7-sv-h-1.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The median is in the interval 10–15 minutes, because that bar is the tallest.', false, 'The tallest bar shows the most common interval, not the median; only 32 workers have times below 15, which is fewer than 40.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The median is in the interval 15–20 minutes.', true, 'Correct: With 80 workers the median is the mean of the 40th and 41st values; the cumulative counts are 4, 14, 32, 46, so both are in 15–20.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The median is exactly 20 minutes, because 20 is the midpoint of the horizontal axis from 0 to 40.', false, 'The midpoint of the axis is not the median, which depends on the counts of values on each side of it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The median cannot be located from a histogram, because the individual commute times are not shown.', false, 'A histogram does give the number of values in each interval, so the interval holding the 40th and 41st values can be found.' from version_ins;
-- apstats-mcq-b7-sv-h-1.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.5-a-v2', 'mcq', 'locate the interval containing the median from the bar heights of a histogram, avoiding the tallest-bar and axis-midpoin (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A histogram shows the waiting times, in minutes, of 50 patients at a clinic. Each bin includes its left endpoint and excludes its right endpoint. The bar heights (numbers of patients) are: 0–10: 3; 10–20: 13; 20–30: 10; 30–40: 8; 40–50: 6; 50–60: 4; 60–70: 3; 70–80: 2; 80–90: 0; 90–100: 1. Which statement about the median waiting time is correct?', null, md5('apstats-mcq-b7-sv-h-1.5-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The median is in the interval 20–30 minutes.', true, 'Correct: With 50 patients the median is the mean of the 25th and 26th values; the cumulative counts are 3, 16, 26, so both lie in 20–30.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The median is in the interval 10–20 minutes, because that bar is the tallest.', false, 'The tallest bar is the most common interval, but only 16 patients waited less than 20 minutes, so the 25th value is not in that interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The median is exactly 50 minutes, because 50 is the midpoint of the horizontal axis from 0 to 100.', false, 'The center of the axis does not locate the median; the median has half of the patients on each side.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The median cannot be located from a histogram, because the individual waiting times are not shown.', false, 'Bar heights give the number of patients in each interval, so the interval containing the median can be identified.' from version_ins;
-- apstats-mcq-b7-sv-h-1.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.5-a-v3', 'mcq', 'locate the interval containing the median from the bar heights of a histogram, avoiding the tallest-bar and axis-midpoin (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A histogram shows the scores of 100 students on a 90-point exam. Each bin includes its left endpoint and excludes its right endpoint. The bar heights (numbers of students) are: 50–55: 2; 55–60: 4; 60–65: 6; 65–70: 10; 70–75: 14; 75–80: 16; 80–85: 20; 85–90: 28. Which statement about the median score is correct?', null, md5('apstats-mcq-b7-sv-h-1.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The median is in the interval 85–90 points, because that bar is the tallest.', false, 'The tallest bar shows where the most scores are, but 72 students score below 85 and the 50th and 51st scores are lower than that.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The median is in the interval 75–80 points.', true, 'Correct: With 100 students the median is the mean of the 50th and 51st scores; the cumulative counts are 2, 6, 12, 22, 36, 52, so both are in 75–80.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The median is exactly 70 points, because 70 is the midpoint of the horizontal axis from 50 to 90.', false, 'The midpoint of the axis is not the median, which is determined by the number of scores on each side.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The median cannot be located from a histogram, because the individual scores are not shown.', false, 'A histogram shows how many scores fall in each interval, so it is possible to find the interval that holds the middle scores.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.4-a-v3','apstats-mcq-b7-h-1.4-b','apstats-mcq-b7-sv-h-1.4-b-v1','apstats-mcq-b7-sv-h-1.4-b-v2','apstats-mcq-b7-sv-h-1.4-b-v3','apstats-mcq-b7-h-1.5-a','apstats-mcq-b7-sv-h-1.5-a-v1','apstats-mcq-b7-sv-h-1.5-a-v2','apstats-mcq-b7-sv-h-1.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b7-sv-h-1.4-a-v3','apstats-mcq-b7-h-1.4-b','apstats-mcq-b7-sv-h-1.4-b-v1','apstats-mcq-b7-sv-h-1.4-b-v2','apstats-mcq-b7-sv-h-1.4-b-v3','apstats-mcq-b7-h-1.5-a','apstats-mcq-b7-sv-h-1.5-a-v1','apstats-mcq-b7-sv-h-1.5-a-v2','apstats-mcq-b7-sv-h-1.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
