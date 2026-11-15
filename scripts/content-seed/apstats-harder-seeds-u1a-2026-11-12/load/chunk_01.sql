begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-h-1.1-a','apstats-mcq-b7-sv-h-1.1-a-v1','apstats-mcq-b7-sv-h-1.1-a-v2','apstats-mcq-b7-sv-h-1.1-a-v3','apstats-mcq-b7-h-1.1-b','apstats-mcq-b7-sv-h-1.1-b-v1','apstats-mcq-b7-sv-h-1.1-b-v2','apstats-mcq-b7-sv-h-1.1-b-v3','apstats-mcq-b7-h-1.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apstats-mcq-b7-h-1.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.1-a', 'mcq', 'recognize a statistical question (one that anticipates variability in data) among questions that have a single fixed ans', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Maya wants to learn about how long it takes students at her school, Kestrel High, to get to school each morning. She plans to collect commute times from a sample of Kestrel students. Which of these is a statistical question that her data could help answer?', null, md5('apstats-mcq-b7-h-1.1-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'How long did Maya''s own commute take this morning?', false, 'This asks about one student on one morning, so the answer is a single value and there is no variability to investigate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'How many students attend Kestrel High?', false, 'Enrollment is one count that can be looked up in a school record, so no variation is anticipated and no sample of students is needed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'What is a typical morning commute time for Kestrel High students, and how much do the times vary from student to student?', true, 'Correct: A statistical question anticipates variability in the data, and only the question about typical commute time and variation among students does; the other three each have a single answer.' from version_ins
union all select gen_random_uuid(), id, 'D', 'What is the speed limit posted on the road in front of Kestrel High?', false, 'The posted limit is a fixed fact printed on a sign, so answering it does not require collecting data that vary.' from version_ins;
-- apstats-mcq-b7-sv-h-1.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.1-a-v1', 'mcq', 'recognize a statistical question (one that anticipates variability in data) among questions that have a single fixed ans (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A baker sells cupcakes advertised as weighing 85 grams. She wants to investigate whether that is accurate. Which of these is a statistical question that weighing a sample of her cupcakes could help answer?', null, md5('apstats-mcq-b7-sv-h-1.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'How much does the cupcake on the scale right now weigh?', false, 'This asks about one particular cupcake at one moment, so it has a single answer and no variability to study.' from version_ins
union all select gen_random_uuid(), id, 'B', 'What price is printed on the bakery''s cupcake menu?', false, 'A menu price is a fixed fact that is read off the menu, so it is not answered by studying data that vary.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Do the cupcakes she sells tend to weigh about 85 grams, and how much do the weights differ from cupcake to cupcake?', true, 'Correct: The question about the typical weight and the differences among cupcakes anticipates variability; the others ask for one measurement, one printed price or one count.' from version_ins
union all select gen_random_uuid(), id, 'D', 'How many cupcakes did the baker bake at 6 a.m. today?', false, 'A count of cupcakes baked at one time is a single number from the baker''s records, not a question about variation.' from version_ins;
-- apstats-mcq-b7-sv-h-1.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.1-a-v2', 'mcq', 'recognize a statistical question (one that anticipates variability in data) among questions that have a single fixed ans (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A counselor at Ridgeway Middle School wants to learn about the sleep students get on school nights. She will ask a sample of students how long they slept last night. Which of these is a statistical question that the responses could help answer?', null, md5('apstats-mcq-b7-sv-h-1.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'How many hours of sleep did the counselor get last night?', false, 'This concerns one person on one night, so the answer is one value and no variability is anticipated.' from version_ins
union all select gen_random_uuid(), id, 'B', 'How many hours are there between 10 p.m. and 6 a.m.?', false, 'The time between two clock times is fixed arithmetic, so no data need to be collected and none vary.' from version_ins
union all select gen_random_uuid(), id, 'C', 'What time does first period begin at Ridgeway?', false, 'A bell schedule is a fixed fact in the school handbook, not something that varies across the students surveyed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'How many hours of sleep do Ridgeway students typically get on a school night, and how do the amounts differ across students?', true, 'Correct: Only the question about typical sleep and differences among students has answers that vary from student to student and so needs data from a sample.' from version_ins;
-- apstats-mcq-b7-sv-h-1.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.1-a-v3', 'mcq', 'recognize a statistical question (one that anticipates variability in data) among questions that have a single fixed ans (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A biologist grows tomato plants for 30 days with a new fertilizer and grows other plants without it. Which of these is a statistical question that the plant heights could help answer?', null, md5('apstats-mcq-b7-sv-h-1.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'How tall is the plant in pot 7 today?', false, 'One plant on one day gives a single measurement, so there is no variability to describe or compare.' from version_ins
union all select gen_random_uuid(), id, 'B', 'What is the chemical formula of the main nutrient in the fertilizer?', false, 'A chemical formula is a fixed fact from a reference, not a question whose answer varies from plant to plant.' from version_ins
union all select gen_random_uuid(), id, 'C', 'How many pots are on the greenhouse shelf?', false, 'The number of pots is a single count, so nothing about it varies and no distribution of data is involved.' from version_ins
union all select gen_random_uuid(), id, 'D', 'How do the heights after 30 days of plants grown with the fertilizer compare, in center and spread, with the heights of plants grown without it?', true, 'Correct: Comparing the centers and spreads of two groups of heights anticipates plant-to-plant variability, while each other question has one fixed answer.' from version_ins;
-- apstats-mcq-b7-h-1.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.1-b', 'mcq', 'identify the population of interest from an investigative question and judge what a sample taken from a different group ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The Dunmore city council wants to know whether residents support longer public library hours. A researcher stands outside the central library on a Saturday and surveys 150 patrons as they leave; 117 of them say they support longer hours. Which statement correctly identifies the population of interest and what the survey result supports?', null, md5('apstats-mcq-b7-h-1.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The population of interest is all Dunmore residents; the 78% describes only the 150 patrons surveyed and may not represent all residents.', true, 'Correct: 117/150 = 0.78; the question concerns all residents, but the data come only from people who happened to be leaving the library, so 78% is a statistic for that group.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The population is the 150 patrons surveyed, so 78% is the exact proportion of the population who support longer hours.', false, 'The 150 patrons are a sample taken from the group the council cares about, not the population, so 78% is not the population proportion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The population is all Dunmore residents, and 78% is a parameter because it describes support among the residents.', false, 'A value computed from a sample is a statistic; a parameter is the value for the whole population, which is unknown here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The population is all Dunmore residents, and because 150 is a large sample the 78% can be generalized to every resident.', false, 'A large sample does not fix a sample that was not chosen to represent all residents, since library patrons may differ from other residents.' from version_ins;
-- apstats-mcq-b7-sv-h-1.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.1-b-v1', 'mcq', 'identify the population of interest from an investigative question and judge what a sample taken from a different group  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The principal of Harlow High wants to know whether Harlow students support starting school 30 minutes later. A researcher surveys 60 members of the school''s varsity sports teams during practice; 21 of them support the change. Which statement correctly identifies the population of interest and what the survey result supports?', null, md5('apstats-mcq-b7-sv-h-1.1-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The population is the 60 athletes, so 35% is the exact proportion of Harlow students who support the change.', false, 'The athletes are the sample that was observed, not the population the principal asks about, so 35% is not the school-wide proportion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The population of interest is all Harlow students; the 35% describes only the 60 athletes surveyed and may not represent all students.', true, 'Correct: 21/60 = 0.35; the population is every Harlow student, while the data come from athletes only, so 35% describes that group.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The population is all Harlow students, and 35% is a parameter because it describes the opinion of the students.', false, 'A number computed from the 60 athletes is a statistic, and the parameter is the unknown proportion for all students.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The population is all Harlow students, and because the teams include students from every grade, 35% can be generalized to every student.', false, 'Having every grade represented among athletes does not make them representative of all students on the issue of start times.' from version_ins;
-- apstats-mcq-b7-sv-h-1.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.1-b-v2', 'mcq', 'identify the population of interest from an investigative question and judge what a sample taken from a different group  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A county health office wants to know the typical resting blood pressure of adults in Calloway County. A nurse measures the 200 adults who attend a free health clinic one weekend and finds a mean systolic pressure of 132. Which statement correctly identifies the population of interest and what the result supports?', null, md5('apstats-mcq-b7-sv-h-1.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The population is the 200 adults measured, so 132 is the population mean for the county.', false, 'The 200 adults are the sample, and the county''s adults are the population the health office asks about.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The population of interest is all adults in Calloway County; the mean of 132 describes only the 200 clinic attendees and may differ from the county mean.', true, 'Correct: The county mean is a parameter for all adults; 132 is a statistic computed from adults who chose to attend a free clinic, who may not be typical.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The population is all adults in the county, and 132 is a parameter because it summarizes their blood pressures.', false, 'A parameter describes the entire population; a mean computed from 200 measured adults is a statistic.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The population is all adults in the county, and since 200 adults were measured, 132 can be generalized to the whole county.', false, 'Sample size cannot repair a sample of people who chose a health clinic, since they may differ from other adults in the county.' from version_ins;
-- apstats-mcq-b7-sv-h-1.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.1-b-v3', 'mcq', 'identify the population of interest from an investigative question and judge what a sample taken from a different group  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A park manager wants to know the typical length of the fish in Lake Verity. An angler uses a net with large mesh, catches 40 fish and measures them, finding a mean length of 31 cm. Which statement correctly identifies the population of interest and what the result supports?', null, md5('apstats-mcq-b7-sv-h-1.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The population is the 40 fish netted, so 31 cm is the mean length of the fish in the lake.', false, 'The netted fish are a sample from the lake''s fish, and the manager''s question is about all of the fish in the lake.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The population is all the fish in the lake, and 31 cm is a parameter because it describes the fish.', false, 'A mean from the 40 measured fish is a statistic; the lake-wide mean length is the unknown parameter.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The population of interest is all the fish in the lake; the 31 cm describes only the 40 fish netted and may overstate the lake''s typical length.', true, 'Correct: The question is about every fish in the lake, but a large-mesh net tends to keep only larger fish, so the sample mean of 31 cm may not describe the lake.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The population is all the fish in the lake, and since 40 fish were measured the 31 cm applies to the whole lake.', false, 'A sample of 40 does not make up for a net that tends to catch larger fish, so the result may not generalize.' from version_ins;
-- apstats-mcq-b7-h-1.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-h-1.2-a', 'mcq', 'classify variables in a data set, recognizing numeric identifiers and ordered categories as categorical and counts as qu', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A streaming service stores these four items for each subscriber: a 7-digit account ID, a plan tier (Basic, Standard or Premium), the number of hours watched last month, and the number of user profiles on the account. Which choice lists exactly the variables that are quantitative?', null, md5('apstats-mcq-b7-h-1.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Hours watched last month and number of user profiles.', true, 'Correct: A quantitative variable takes numerical values for which arithmetic such as averaging is meaningful; an ID is a label and a tier is an ordered category, while hours and a count of profiles can be averaged.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Account ID, hours watched last month and number of user profiles, because each is recorded as a number.', false, 'An ID number only labels subscribers, so the average of the IDs would be meaningless; being written with digits does not make it quantitative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only hours watched last month, because a count of profiles takes whole-number values and so is categorical.', false, 'A count of profiles is numerical and can be averaged, so it is quantitative even though it takes only whole-number values.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Plan tier, hours watched last month and number of user profiles, because the tiers can be put in order.', false, 'A plan tier is a category even though it can be ordered, so it is not quantitative; ordering alone does not make a variable numerical.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-h-1.1-a','apstats-mcq-b7-sv-h-1.1-a-v1','apstats-mcq-b7-sv-h-1.1-a-v2','apstats-mcq-b7-sv-h-1.1-a-v3','apstats-mcq-b7-h-1.1-b','apstats-mcq-b7-sv-h-1.1-b-v1','apstats-mcq-b7-sv-h-1.1-b-v2','apstats-mcq-b7-sv-h-1.1-b-v3','apstats-mcq-b7-h-1.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b7-h-1.1-a','apstats-mcq-b7-sv-h-1.1-a-v1','apstats-mcq-b7-sv-h-1.1-a-v2','apstats-mcq-b7-sv-h-1.1-a-v3','apstats-mcq-b7-h-1.1-b','apstats-mcq-b7-sv-h-1.1-b-v1','apstats-mcq-b7-sv-h-1.1-b-v2','apstats-mcq-b7-sv-h-1.1-b-v3','apstats-mcq-b7-h-1.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
