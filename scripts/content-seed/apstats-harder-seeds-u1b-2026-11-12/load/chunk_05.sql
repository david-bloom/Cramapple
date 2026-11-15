begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-h-1.12-b','apstats-mcq-b6-sv-h-1.12-b-v1','apstats-mcq-b6-sv-h-1.12-b-v2','apstats-mcq-b6-sv-h-1.12-b-v3','apstats-mcq-b6-h-1.13-a','apstats-mcq-b6-sv-h-1.13-a-v1','apstats-mcq-b6-sv-h-1.13-a-v2','apstats-mcq-b6-sv-h-1.13-a-v3','apstats-mcq-b6-h-1.13-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apstats-mcq-b6-h-1.12-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.12-b', 'mcq', 'choose a change that reduces bias and know that larger samples do not remove bias', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A radio station asks listeners to call in during one evening show to vote on whether the city should build a stadium. It receives 1,200 calls, and 71% favor the stadium. The station wants a more trustworthy estimate of the opinion of all city residents. Which plan would best reduce the bias?', null, md5('apstats-mcq-b6-h-1.12-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Keep the call-in format but let people call for a full week, so that many more calls are received.', false, 'A larger voluntary sample has the same bias, because the people who call are still those who chose to.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Keep the call-in format but have the host read the question in a more neutral way.', false, 'Neutral wording helps with response bias but does not fix the bias from self-selection.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Select 300 residents at random from the city''s voter registry and follow up with those who do not respond.', true, 'Correct: Random selection from a list covering the population, plus follow-up of nonrespondents, removes self-selection; more volunteers or neutral wording does not.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Randomly choose 300 of the 1,200 callers and use only their opinions.', false, 'A random sample of volunteers is still a sample of volunteers, so the self-selection bias remains.' from version_ins;
-- apstats-mcq-b6-sv-h-1.12-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.12-b-v1', 'mcq', 'choose a change that reduces bias and know that larger samples do not remove bias (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A county mails a survey about library hours to a random sample of 1,000 residents, and 150 return it. County staff worry about nonresponse bias. Which plan would best reduce the bias?', null, md5('apstats-mcq-b6-sv-h-1.12-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Follow up with a second mailing and phone calls to the residents who did not return the survey.', true, 'Correct: Nonresponse bias is reduced by following up with the people selected, not by getting more people who are easy to reach.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mail the survey to a random sample of 3,000 residents instead of 1,000.', false, 'A larger sample with the same low response rate has the same nonresponse bias; it only has more returned surveys.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Replace the nonresponders with volunteers who visit the library and agree to fill out a survey.', false, 'Volunteers at the library are different from nonresponders and introduce voluntary response bias.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Check that the survey question is worded neutrally.', false, 'Neutral wording helps with response bias but does not fix the fact that 85% of selected residents did not respond.' from version_ins;
-- apstats-mcq-b6-sv-h-1.12-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.12-b-v2', 'mcq', 'choose a change that reduces bias and know that larger samples do not remove bias (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student wants to estimate how many hours per week all residents of her town exercise. She surveys 100 people who are leaving a gym on weekday evenings. Which plan would best reduce the bias?', null, md5('apstats-mcq-b6-sv-h-1.12-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Select 100 residents at random from the town''s list of households and survey each of them.', true, 'Correct: A random sample from a list covering all residents gives every resident a chance to be chosen; a larger convenience sample does not.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Survey 500 people leaving the gym instead of 100.', false, 'A larger sample from the same gym entrance still excludes people who do not go to the gym, so the bias remains.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Survey people leaving the gym at several different times of day, including mornings.', false, 'This varies the time but still samples only gym members, who tend to exercise more than other residents.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ask the exercise question in a more neutral way.', false, 'Wording is not the main problem; the people who were chosen are not representative of the town.' from version_ins;
-- apstats-mcq-b6-sv-h-1.12-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.12-b-v3', 'mcq', 'choose a change that reduces bias and know that larger samples do not remove bias (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A poll of 200 customers selected by convenience at one store overestimates the proportion of all shoppers who prefer a brand. Researchers repeat the same procedure with 2,000 customers selected the same way. Which statement is expected to be true for the new estimate?', null, md5('apstats-mcq-b6-sv-h-1.12-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The estimates will vary less from sample to sample, but they will still be centered away from the true proportion.', true, 'Correct: Larger n reduces sampling variability around the center of the procedure''s estimates, but the center itself, which is off target, is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The bias will shrink toward zero, because the sample is larger.', false, 'Increasing the sample size reduces variability but does not remove bias that comes from how people are selected.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The estimate will be unbiased, because a large sample always represents the population.', false, 'A large sample drawn with a flawed method still systematically misses parts of the population.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The bias will increase, because convenience samples get worse as the sample grows.', false, 'The bias stays about the same; it does not get larger or smaller with the sample size.' from version_ins;
-- apstats-mcq-b6-h-1.13-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.13-a', 'mcq', 'find the confounding flaw in an experiment design and choose the best fix', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A coach tests whether a new warm-up reduces 100-meter sprint times. On one day, each of 12 sprinters runs once in the morning after the new warm-up and once in the afternoon after the standard warm-up. The mean time is 0.15 seconds faster in the morning. Which statement identifies the most serious problem and the best fix?', null, md5('apstats-mcq-b6-h-1.13-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sample is too small; she should use 120 sprinters but keep the same morning and afternoon plan.', false, 'A larger sample still has the new warm-up always in the morning, so the confounding with time of day remains.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Warm-up is confounded with time of day; she should randomly decide for each sprinter whether the new warm-up is used in the morning or the afternoon.', true, 'Correct: Every sprinter did the new warm-up in the morning and the standard warm-up in the afternoon, so time of day cannot be separated from the effect of the warm-up.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is no control group; she should give sprinters a fake warm-up that does nothing.', false, 'Using the same sprinters for both warm-ups already provides a comparison; the problem is the fixed order.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is no problem, because using the same sprinters in both conditions removes all differences.', false, 'Using the same sprinters controls for differences between people, but not for time of day or fatigue.' from version_ins;
-- apstats-mcq-b6-sv-h-1.13-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.13-a-v1', 'mcq', 'find the confounding flaw in an experiment design and choose the best fix (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school compares a new tutoring program with the usual program. All students in first period are placed in the new program and all students in second period get the usual program. At the end, first-period students score higher on a test. Which statement identifies the most serious problem and the best fix?', null, md5('apstats-mcq-b6-sv-h-1.13-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Program is confounded with class period; students should be randomly assigned to the programs regardless of period.', true, 'Correct: The two groups differ in more than the program, such as class period and teacher, so the observed difference cannot be attributed to the program.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is no control group; the usual program should be replaced by no tutoring.', false, 'The students in the usual program already act as a comparison group; the problem is how students were put into groups.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The students and teachers should be unaware of which program is the new one.', false, 'Blinding helps against bias in responses and evaluation, but the groups still differ systematically by class period.' from version_ins
union all select gen_random_uuid(), id, 'D', 'More students should be added to each period.', false, 'A larger number of students in each fixed group does not remove differences between the periods.' from version_ins;
-- apstats-mcq-b6-sv-h-1.13-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.13-a-v2', 'mcq', 'find the confounding flaw in an experiment design and choose the best fix (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers compare a new diet with the current diet. Sixty volunteers choose which diet to follow for 12 weeks, and the new-diet group loses more weight on average. Which statement identifies the most serious problem and the best fix?', null, md5('apstats-mcq-b6-sv-h-1.13-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The study should use a larger group of volunteers who each choose a diet.', false, 'More volunteers choosing their own diets still allow motivation to differ between the groups.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Participants should be asked to report their weight honestly.', false, 'Honest reporting does not remove the systematic difference between those who chose each diet.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Diet is confounded with participants'' motivation; volunteers should be randomly assigned to the diets.', true, 'Correct: When people choose their own treatment, those who choose differ in other ways such as motivation, so the groups are not comparable.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Every participant should follow the new diet first and the current diet second.', false, 'A fixed order confounds the diet with time, so this introduces another confounding variable.' from version_ins;
-- apstats-mcq-b6-sv-h-1.13-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.13-a-v3', 'mcq', 'find the confounding flaw in an experiment design and choose the best fix (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gym puts all 40 of its members on a new training program for 8 weeks. Their mean strength gain is 12 pounds, and the manager concludes that the program caused the gain. Which statement identifies the most serious problem and the best fix?', null, md5('apstats-mcq-b6-sv-h-1.13-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is no comparison group; some members should be randomly assigned to the new program and others to a comparison treatment at the same time.', true, 'Correct: Without a concurrently treated comparison group chosen at random, the gain cannot be attributed to the program.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is no problem, because the same members were measured before and after the program.', false, 'Before and after measurements cannot separate the program from other changes such as natural progress or the season.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The program should be extended to 16 weeks.', false, 'A longer program still has no comparison group and a longer period also allows more other changes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Only members who volunteer for the program should be used.', false, 'Using only volunteers adds selection issues and still provides no comparison group.' from version_ins;
-- apstats-mcq-b6-h-1.13-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.13-b', 'mcq', 'determine the scope of conclusions (cause, generalization) from random assignment and random selection', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers recruit 80 volunteer adult cyclists from one city and use a random number generator to assign 40 to a new electrolyte drink and 40 to a placebo drink. Time to exhaustion is significantly longer for the electrolyte group. Which conclusion is justified?', null, md5('apstats-mcq-b6-h-1.13-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The drink caused longer times, and the result can be generalized to all adult cyclists.', false, 'Generalizing requires random selection from the population, and these cyclists were volunteers.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is only an association, because volunteers rather than a random sample were used.', false, 'Random assignment supports a cause-and-effect conclusion for these participants, no matter how they were recruited.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The drink caused the longer times for volunteer cyclists like these, but the result cannot be generalized to all adult cyclists.', true, 'Correct: Random assignment allows a causal conclusion within the study group; volunteers limit the scope of inference to similar cyclists.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Nothing can be concluded, because the cyclists were not a random sample.', false, 'The lack of a random sample limits generalization but does not remove the cause-and-effect conclusion from random assignment.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-h-1.12-b','apstats-mcq-b6-sv-h-1.12-b-v1','apstats-mcq-b6-sv-h-1.12-b-v2','apstats-mcq-b6-sv-h-1.12-b-v3','apstats-mcq-b6-h-1.13-a','apstats-mcq-b6-sv-h-1.13-a-v1','apstats-mcq-b6-sv-h-1.13-a-v2','apstats-mcq-b6-sv-h-1.13-a-v3','apstats-mcq-b6-h-1.13-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b6-h-1.12-b','apstats-mcq-b6-sv-h-1.12-b-v1','apstats-mcq-b6-sv-h-1.12-b-v2','apstats-mcq-b6-sv-h-1.12-b-v3','apstats-mcq-b6-h-1.13-a','apstats-mcq-b6-sv-h-1.13-a-v1','apstats-mcq-b6-sv-h-1.13-a-v2','apstats-mcq-b6-sv-h-1.13-a-v3','apstats-mcq-b6-h-1.13-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
