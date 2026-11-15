begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.3-a-v2','apstats-mcq-b7-sv-h-1.3-a-v3','apstats-mcq-b7-h-1.3-b','apstats-mcq-b7-sv-h-1.3-b-v1','apstats-mcq-b7-sv-h-1.3-b-v2','apstats-mcq-b7-sv-h-1.3-b-v3','apstats-mcq-b7-h-1.4-a','apstats-mcq-b7-sv-h-1.4-a-v1','apstats-mcq-b7-sv-h-1.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apstats-mcq-b7-sv-h-1.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.3-a-v2', 'mcq', 'use a relative frequency and a count to recover the total of a categorical table, then find a conditional percentage amo (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A librarian recorded the favorite genre of each student in a reading survey. Mystery was chosen by 18 students, which was 12% of all students surveyed, and fantasy was chosen by 28% of all students surveyed. Among the students who did NOT choose mystery, what percent chose fantasy, to the nearest tenth of a percent?', null, md5('apstats-mcq-b7-sv-h-1.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '28.0%', false, '28% is the share of all 150 students and ignores the condition that the student did not choose mystery.' from version_ins
union all select gen_random_uuid(), id, 'B', '40.0%', false, 'Adding 12% and 28% combines two categories and does not answer the question about fantasy among non-mystery students.' from version_ins
union all select gen_random_uuid(), id, 'C', '42.0%', false, '42 is the number of students who chose fantasy, not a percent, and it has not been divided by the 132 non-mystery students.' from version_ins
union all select gen_random_uuid(), id, 'D', '31.8%', true, 'Correct: 18/0.12 = 150 students; 0.28(150) = 42 fantasy fans; 150 − 18 = 132 non-mystery students; 42/132 = 0.318.' from version_ins;
-- apstats-mcq-b7-sv-h-1.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.3-a-v3', 'mcq', 'use a relative frequency and a count to recover the total of a categorical table, then find a conditional percentage amo (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a survey of pet ownership, 30 students said cat, which was 20% of all students surveyed, and 38% of all students surveyed said dog. Among the students who did NOT say cat, what percent said something other than dog, to the nearest tenth of a percent?', null, md5('apstats-mcq-b7-sv-h-1.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '47.5%', false, '47.5% is the percent of the non-cat students who said dog, the complement of what was asked.' from version_ins
union all select gen_random_uuid(), id, 'B', '52.5%', true, 'Correct: 30/0.20 = 150 students; 0.38(150) = 57 dog owners; 150 − 30 = 120 non-cat students; (120 − 57)/120 = 63/120 = 0.525.' from version_ins
union all select gen_random_uuid(), id, 'C', '62.0%', false, '62% is the percent of all 150 students who did not say dog, which ignores the condition that the student did not say cat.' from version_ins
union all select gen_random_uuid(), id, 'D', '80.0%', false, '80% is the percent of all students who did not say cat, which is not a percent of that group that avoided dog.' from version_ins;
-- apstats-mcq-b7-h-1.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.3-b', 'mcq', 'compare two groups of different sizes using relative frequencies, and distinguish a difference in percentage points from', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two towns were surveyed about a proposed park. In Town A, 120 of the 400 residents surveyed supported the plan. In Town B, 90 of the 225 residents surveyed supported it. Which statement about the survey results is correct?', null, md5('apstats-mcq-b7-h-1.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Support is stronger in Town A, because 120 supporters is more than 90 supporters.', false, 'Counts depend on how many people were surveyed, so more supporters in Town A comes from the larger group surveyed and does not show stronger support.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A larger share of the Town B residents surveyed supported the plan, 40% compared with 30%, even though Town A had more supporters.', true, 'Correct: Relative frequencies are 120/400 = 30% and 90/225 = 40%; the gap is 10 percentage points, while 40/30 is about a 33% relative increase.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The towns cannot be compared, because different numbers of residents were surveyed in each.', false, 'Relative frequencies adjust for different group sizes, so proportions can be compared even when the numbers surveyed differ.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Support in Town B is 10% greater than in Town A, because 40% minus 30% is 10%.', false, 'The 10 is a difference in percentage points; Town B''s share is about 33% greater in relative terms, so 10% misdescribes the comparison.' from version_ins;
-- apstats-mcq-b7-sv-h-1.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.3-b-v1', 'mcq', 'compare two groups of different sizes using relative frequencies, and distinguish a difference in percentage points from (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A district asked students at two schools whether they prefer an online option for a course. At School X, 84 of the 240 students asked said yes. At School Y, 60 of the 120 students asked said yes. Which statement about the results is correct?', null, md5('apstats-mcq-b7-sv-h-1.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A larger share of the School Y students asked preferred the online option, 50% compared with 35%, even though School X had more students saying yes.', true, 'Correct: The shares are 84/240 = 35% and 60/120 = 50%; the gap is 15 percentage points, and 50/35 is a relative increase of about 43%.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Preference is stronger at School X, because 84 students is more than 60 students.', false, 'More yes answers at School X come from asking twice as many students, which does not show that a larger share preferred the option.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The schools cannot be compared, because a different number of students was asked at each.', false, 'Percentages put the schools on a common scale, so they can be compared even though the group sizes differ.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Preference at School Y is 15% greater than at School X, because 50% minus 35% is 15%.', false, 'A gap of 15 is in percentage points; School Y''s share is about 43% greater in relative terms, so saying 15% greater misdescribes it.' from version_ins;
-- apstats-mcq-b7-sv-h-1.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.3-b-v2', 'mcq', 'compare two groups of different sizes using relative frequencies, and distinguish a difference in percentage points from (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A city surveyed residents of two wards about a new recycling schedule. In Ward 1, 66 of the 300 residents surveyed favored it. In Ward 2, 40 of the 160 residents surveyed favored it. Which statement about the results is correct?', null, md5('apstats-mcq-b7-sv-h-1.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Favor is higher in Ward 1, because 66 people is more than 40 people.', false, 'Ward 1 has more people in favor only because more residents were surveyed there; the counts do not compare the shares.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A larger share of the Ward 2 residents surveyed favored the schedule, 25% compared with 22%, even though Ward 1 had more people in favor.', true, 'Correct: The shares are 66/300 = 22% and 40/160 = 25%; the gap is 3 percentage points, and 25/22 is a relative increase of about 14%.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The wards cannot be compared, because the numbers of residents surveyed were not equal.', false, 'Proportions allow groups of unequal size to be compared fairly, so unequal numbers surveyed do not prevent a comparison.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Favor in Ward 2 is 3% greater than in Ward 1, because 25% minus 22% is 3%.', false, 'A gap of 3 is in percentage points; Ward 2''s share is about 14% greater in relative terms, so saying 3% greater is a misreading.' from version_ins;
-- apstats-mcq-b7-sv-h-1.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.3-b-v3', 'mcq', 'compare two groups of different sizes using relative frequencies, and distinguish a difference in percentage points from (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school surveyed two grades about a later start time. In Grade 9, 52 of the 130 students surveyed said yes. In Grade 10, 78 of the 260 students surveyed said yes. Which statement about the results is correct?', null, md5('apstats-mcq-b7-sv-h-1.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Support is stronger in Grade 10, because 78 students is more than 52 students.', false, 'More yes answers in Grade 10 come from surveying twice as many students and do not show that a larger share supported the change.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The grades cannot be compared, because a different number of students was surveyed in each grade.', false, 'Using percentages removes the effect of different group sizes, so the grades can be compared directly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A larger share of the Grade 9 students surveyed said yes, 40% compared with 30%, even though Grade 10 had more students saying yes.', true, 'Correct: The shares are 52/130 = 40% and 78/260 = 30%; the gap is 10 percentage points, and 40/30 is a relative increase of about 33%.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Support in Grade 9 is 10% greater than in Grade 10, because 40% minus 30% is 10%.', false, 'The gap is 10 percentage points; Grade 9''s share is about 33% greater in relative terms, so describing it as 10% greater is a misreading.' from version_ins;
-- apstats-mcq-b7-h-1.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.4-a', 'mcq', 'evaluate a claim drawn from a bar chart whose vertical axis does not start at zero, comparing visual height with the act', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bar chart shows the number of complaints received by two branches of a bank last month. The vertical axis starts at 40 instead of 0. The bar for Branch 1 reaches 46 complaints and the bar for Branch 2 reaches 52 complaints. A viewer says, "Branch 2''s bar is twice as tall as Branch 1''s, so Branch 2 had twice as many complaints." Which statement best evaluates the claim?', null, md5('apstats-mcq-b7-h-1.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because the bar for Branch 2 is twice as tall and the height of a bar shows how many times larger a count is.', false, 'Bar heights are proportional to counts only when the axis starts at zero; with an axis starting at 40, the picture exaggerates the difference.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is incorrect: the axis starts at 40, so the visible bar heights are 6 and 12, but Branch 2 had 52 complaints compared with 46, about 13% more.', true, 'Correct: Visible heights above the axis are 46 − 40 = 6 and 52 − 40 = 12; the counts compare as 52/46 = 1.13, so Branch 2 had about 13% more complaints.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect: Branch 2 had 6 more complaints than Branch 1, so Branch 2 had 6% more complaints.', false, 'The difference of 6 complaints is not a percent; as a fraction of Branch 1''s 46 complaints, it is about 13%.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect: Branch 1 had about 13% more complaints than Branch 2, because 52 divided by 46 is about 1.13.', false, '52/46 compares Branch 2 to Branch 1, so Branch 2, not Branch 1, had the larger count and the percent increase is for Branch 2.' from version_ins;
-- apstats-mcq-b7-sv-h-1.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.4-a-v1', 'mcq', 'evaluate a claim drawn from a bar chart whose vertical axis does not start at zero, comparing visual height with the act (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bar chart shows the sales, in thousands of dollars, of two stores last month. The vertical axis starts at 200 instead of 0. The bar for Store A reaches 215 and the bar for Store B reaches 230. A viewer says, "Store B''s bar is twice as tall as Store A''s, so Store B sold twice as much." Which statement best evaluates the claim?', null, md5('apstats-mcq-b7-sv-h-1.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because Store B''s bar is twice as tall, and a taller bar always shows proportionally greater sales.', false, 'Bars compare sizes in proportion only when the axis starts at 0, and starting at 200 makes the second bar look twice as large.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is incorrect: Store B sold 15 thousand dollars more than Store A, so it sold 15% more.', false, 'A difference of 15 thousand dollars is not 15%; relative to Store A''s 215 thousand, it is about 7%.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect: Store A sold about 7% more than Store B, because 230 divided by 215 is about 1.07.', false, '230/215 puts Store B over Store A, so it is Store B that sold about 7% more, and the claim reversed the stores.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect: the axis starts at 200, so the visible bar heights are 15 and 30, but Store B sold 230 thousand compared with 215 thousand, about 7% more.', true, 'Correct: Visible heights are 215 − 200 = 15 and 230 − 200 = 30, but the sales compare as 230/215 = 1.07, so Store B sold about 7% more.' from version_ins;
-- apstats-mcq-b7-sv-h-1.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.4-a-v2', 'mcq', 'evaluate a claim drawn from a bar chart whose vertical axis does not start at zero, comparing visual height with the act (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bar chart shows the number of defective parts produced by two machines in one shift. The vertical axis starts at 60 instead of 0. The bar for Machine 1 reaches 66 and the bar for Machine 2 reaches 78. A viewer says, "Machine 2''s bar is three times as tall as Machine 1''s, so Machine 2 made three times as many defective parts." Which statement best evaluates the claim?', null, md5('apstats-mcq-b7-sv-h-1.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is incorrect: the axis starts at 60, so the visible bar heights are 6 and 18, but Machine 2 made 78 defective parts compared with 66, about 18% more.', true, 'Correct: Visible heights are 66 − 60 = 6 and 78 − 60 = 18, which look like a ratio of 3, but 78/66 = 1.18, so Machine 2 made about 18% more defective parts.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because Machine 2''s bar is three times as tall, and bar height shows the size of the count directly.', false, 'Bars show ratios of counts only if the axis starts at 0; the axis here starts at 60, which stretches the visible difference.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect: Machine 2 made 12 more defective parts than Machine 1, so it made 12% more.', false, 'The difference of 12 parts is not a percent; relative to Machine 1''s 66, it is about 18%.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect: Machine 1 made about 18% more defective parts than Machine 2, because 78 divided by 66 is about 1.18.', false, '78/66 divides Machine 2 by Machine 1, so Machine 2 had the larger count; Machine 1 did not make 18% more.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.3-a-v2','apstats-mcq-b7-sv-h-1.3-a-v3','apstats-mcq-b7-h-1.3-b','apstats-mcq-b7-sv-h-1.3-b-v1','apstats-mcq-b7-sv-h-1.3-b-v2','apstats-mcq-b7-sv-h-1.3-b-v3','apstats-mcq-b7-h-1.4-a','apstats-mcq-b7-sv-h-1.4-a-v1','apstats-mcq-b7-sv-h-1.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b7-sv-h-1.3-a-v2','apstats-mcq-b7-sv-h-1.3-a-v3','apstats-mcq-b7-h-1.3-b','apstats-mcq-b7-sv-h-1.3-b-v1','apstats-mcq-b7-sv-h-1.3-b-v2','apstats-mcq-b7-sv-h-1.3-b-v3','apstats-mcq-b7-h-1.4-a','apstats-mcq-b7-sv-h-1.4-a-v1','apstats-mcq-b7-sv-h-1.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
