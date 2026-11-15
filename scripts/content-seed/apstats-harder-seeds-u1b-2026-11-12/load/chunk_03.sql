begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-sv-h-1.10-a-v2','apstats-mcq-b6-sv-h-1.10-a-v3','apstats-mcq-b6-h-1.10-b','apstats-mcq-b6-sv-h-1.10-b-v1','apstats-mcq-b6-sv-h-1.10-b-v2','apstats-mcq-b6-sv-h-1.10-b-v3','apstats-mcq-b6-h-1.11-a','apstats-mcq-b6-sv-h-1.11-a-v1','apstats-mcq-b6-sv-h-1.11-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apstats-mcq-b6-sv-h-1.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.10-a-v2', 'mcq', 'distinguish parameters from statistics and explain why statistics vary from sample to sample (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company has 5,000 employees. In a random sample of 100 employees, 42 commute by car. Which of the following describes a parameter?', null, md5('apstats-mcq-b6-sv-h-1.10-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The proportion 0.42 of the sampled employees who commute by car.', false, 'This value is computed from the sample, so it is a statistic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The number of employees in the sample, which is 100.', false, 'A sample size describes the data collection, not a characteristic of the population.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The proportion of all 5,000 employees who commute by car.', true, 'Correct: A parameter is a fixed numerical summary of the whole population, here the proportion of all 5,000 employees who commute by car.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The difference between the sample proportion and the proportion of all employees.', false, 'This is the sampling error, which varies from sample to sample and cannot be computed because the population value is unknown.' from version_ins;
-- apstats-mcq-b6-sv-h-1.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.10-a-v3', 'mcq', 'distinguish parameters from statistics and explain why statistics vary from sample to sample (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two different random samples of 50 students are taken from the same school and each is asked whether they own a laptop. In the first sample 30% own one and in the second sample 38% own one. Which statement best explains the difference?', null, md5('apstats-mcq-b6-sv-h-1.10-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sample proportions vary from sample to sample, while the population proportion is a single fixed value.', true, 'Correct: A statistic changes with the sample drawn; a parameter does not, and this natural variation does not by itself indicate bias.' from version_ins
union all select gen_random_uuid(), id, 'B', 'One of the two samples must be biased, because random samples from one population give the same proportion.', false, 'Random samples from the same population typically give different statistics because of sampling variability, not necessarily bias.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The population proportion changed between the two samples.', false, 'The population proportion is fixed at the time of sampling; it is the statistics that change.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sample with 38% is closer to the true proportion, because it is the larger value.', false, 'Size alone does not show which sample is closer; the true proportion is unknown.' from version_ins;
-- apstats-mcq-b6-h-1.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.10-b', 'mcq', 'judge whether a data-collection plan matches the population, groups and variable named in the question', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A principal wants to know the typical number of hours per night that all 1,800 students at her school sleep. She surveys the 28 students in her first-period AP Calculus class. Which statement best describes how well this plan matches her question?', null, md5('apstats-mcq-b6-h-1.10-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The plan matches the question, because any sample of students estimates the whole school.', false, 'Only a sample selected in a way that represents the population can be used to estimate it; one class is not chosen that way.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The plan matches the question, as long as the 28 students answer honestly.', false, 'Honest answers do not fix a sample that does not represent the population in the question.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The plan does not match the question only because 28 is fewer than 30 students.', false, 'The problem is who is included, not a threshold on the sample size.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The question is about all 1,800 students, but the data come from only one class, so the results cannot be used to describe all students.', true, 'Correct: The population in the question is all 1,800 students; a single advanced class is a different, narrower group, so the data answer a different question.' from version_ins;
-- apstats-mcq-b6-sv-h-1.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.10-b-v1', 'mcq', 'judge whether a data-collection plan matches the population, groups and variable named in the question (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A coach wants to know whether students who play a sport sleep more on school nights than students who do not play a sport. She records sleep hours for 60 randomly chosen athletes only. Which statement best describes how well this plan matches her question?', null, md5('apstats-mcq-b6-sv-h-1.10-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The plan is sufficient, because she can compare the athletes'' mean sleep with the recommended 8 hours.', false, 'An outside benchmark does not answer the question about athletes compared with non-athletes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The plan would be sufficient with a larger sample of athletes.', false, 'More athletes still give no information about non-athletes, so it cannot answer a comparison.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The plan is sufficient, because random selection makes the athletes'' data representative of all students.', false, 'Random selection of athletes represents athletes only, not students who do not play a sport.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The question compares two groups, so the plan fails to collect data from students who do not play a sport.', true, 'Correct: A comparison question needs data on both groups; the plan measures only one of them.' from version_ins;
-- apstats-mcq-b6-sv-h-1.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.10-b-v2', 'mcq', 'judge whether a data-collection plan matches the population, groups and variable named in the question (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A city wants to estimate the average amount of water that a household uses in a day. It records the total dollar amount on the most recent water bill for each household in a random sample of 200 households. Which statement best describes how well this plan matches the question?', null, md5('apstats-mcq-b6-sv-h-1.10-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The plan matches the question, because the bill is proportional to the water used for every household.', false, 'Bills include fixed fees and different rates, so the amount owed is not simply proportional to the volume used.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The plan matches the question, because 200 households is a large enough sample.', false, 'The sample size does not matter if the wrong variable is measured.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The variable recorded, a dollar amount, is not the variable in the question, since rate schedules and fees differ among households.', true, 'Correct: The question concerns volume of water used, but bills measure money, so the data do not answer the question as asked.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The plan does not match the question, because a random sample cannot be used for a mean.', false, 'Random samples are suitable for estimating means; the issue is the variable, not the method of selection.' from version_ins;
-- apstats-mcq-b6-sv-h-1.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.10-b-v3', 'mcq', 'judge whether a data-collection plan matches the population, groups and variable named in the question (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A park manager wants to know the typical number of visitors on a day throughout the year. She counts the visitors on every Saturday in July. Which statement best describes how well this plan matches her question?', null, md5('apstats-mcq-b6-sv-h-1.10-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The plan matches the question, because every Saturday in July was counted, so there is no sampling error.', false, 'Counting all July Saturdays gives no information about days outside that time, which is the problem of the match.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The plan matches the question, because the number of visitors is a quantitative variable.', false, 'The type of variable is correct, but the days observed are not representative of the whole year.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The question covers every day of the year, but the data come only from summer Saturdays, which are likely not typical of other days.', true, 'Correct: The population is all days of the year; one weekday type in one month covers a small, unrepresentative part of it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The plan does not match the question, because a typical value cannot be found from counts.', false, 'Typical values such as a mean or median can be found from counts; the issue is which days were observed.' from version_ins;
-- apstats-mcq-b6-h-1.11-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.11-a', 'mcq', 'recognize why equal individual chances do not make a sample a simple random sample', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school has 600 students in 24 homerooms of 25 students each. The principal randomly selects 2 homerooms and surveys all 50 students in them. Every student has the same chance, 1/12, of being selected. Is this sample a simple random sample of 50 students?', null, md5('apstats-mcq-b6-h-1.11-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'No, because only groups made of two complete homerooms are possible, so not every group of 50 students has a chance of being chosen.', true, 'Correct: 2 of 24 homerooms gives each student probability 2/24 = 1/12, but only C(24,2) = 276 of the possible groups of 50 students can occur.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Yes, because every student has the same chance of being selected.', false, 'An SRS requires every group of the given size to be equally likely, not just every individual.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No, because the homerooms were not chosen using chance.', false, 'The homerooms were chosen randomly; the sample is a cluster sample, not a non-random one.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Yes, because the sample was drawn without bias in the selection of homerooms.', false, 'Equal individual chances do not make a sample an SRS; many groups of 50, such as ones with students from 10 different homerooms, cannot occur.' from version_ins;
-- apstats-mcq-b6-sv-h-1.11-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.11-a-v1', 'mcq', 'recognize why equal individual chances do not make a sample a simple random sample (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A list of 400 students is in alphabetical order. A researcher chooses a random starting number from 1 to 10 and then selects every 10th student after that, giving a sample of 40. Every student has a 1/10 chance of being selected. Is this a simple random sample of 40 students?', null, md5('apstats-mcq-b6-sv-h-1.11-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Yes, because every student has the same chance of being selected.', false, 'Equal individual chances are not enough for an SRS; every possible group of 40 must be equally likely.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Yes, because the starting point was chosen at random.', false, 'Using a random start gives equal chances but still allows only 10 possible samples, instead of all groups of 40.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No, because an alphabetical list makes the sample biased toward certain letters.', false, 'The order of the list matters only if it is related to the response; the reason this is not an SRS is that most groups of 40 are impossible.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No, because two students who are next to each other in the list can never both be chosen, so not every group of 40 is possible.', true, 'Correct: Only 10 different samples are possible (one per starting number), while an SRS of 40 from 400 allows all C(400,40) groups.' from version_ins;
-- apstats-mcq-b6-sv-h-1.11-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.11-a-v2', 'mcq', 'recognize why equal individual chances do not make a sample a simple random sample (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school has 1,000 students, with 250 in each of four grades. A researcher takes a simple random sample of 15 students from each grade, for a total of 60. Every student has the same chance, 15/250, of being selected. Is the combined sample a simple random sample of 60 students from the school?', null, md5('apstats-mcq-b6-sv-h-1.11-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Yes, because every student has the same chance of being selected.', false, 'Equal individual chances are not enough for an SRS; every possible group of 60 must be equally likely.' from version_ins
union all select gen_random_uuid(), id, 'B', 'No, because the number of students from each grade is fixed at 15, so groups with, for example, 30 freshmen are impossible.', true, 'Correct: Stratification fixes 15 per grade, so only some of the possible groups of 60 can occur; an SRS allows all of them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Yes, because each grade was sampled using a simple random sample.', false, 'Using an SRS within each grade makes this a stratified random sample, which is different from an SRS of the whole school.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No, because stratified sampling is not a random method.', false, 'A stratified sample uses chance within strata; it is random, just not an SRS.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-sv-h-1.10-a-v2','apstats-mcq-b6-sv-h-1.10-a-v3','apstats-mcq-b6-h-1.10-b','apstats-mcq-b6-sv-h-1.10-b-v1','apstats-mcq-b6-sv-h-1.10-b-v2','apstats-mcq-b6-sv-h-1.10-b-v3','apstats-mcq-b6-h-1.11-a','apstats-mcq-b6-sv-h-1.11-a-v1','apstats-mcq-b6-sv-h-1.11-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b6-sv-h-1.10-a-v2','apstats-mcq-b6-sv-h-1.10-a-v3','apstats-mcq-b6-h-1.10-b','apstats-mcq-b6-sv-h-1.10-b-v1','apstats-mcq-b6-sv-h-1.10-b-v2','apstats-mcq-b6-sv-h-1.10-b-v3','apstats-mcq-b6-h-1.11-a','apstats-mcq-b6-sv-h-1.11-a-v1','apstats-mcq-b6-sv-h-1.11-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
