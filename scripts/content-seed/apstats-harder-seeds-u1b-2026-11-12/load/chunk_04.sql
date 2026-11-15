begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-sv-h-1.11-a-v3','apstats-mcq-b6-h-1.11-b','apstats-mcq-b6-sv-h-1.11-b-v1','apstats-mcq-b6-sv-h-1.11-b-v2','apstats-mcq-b6-sv-h-1.11-b-v3','apstats-mcq-b6-h-1.12-a','apstats-mcq-b6-sv-h-1.12-a-v1','apstats-mcq-b6-sv-h-1.12-a-v2','apstats-mcq-b6-sv-h-1.12-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apstats-mcq-b6-sv-h-1.11-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.11-a-v3', 'mcq', 'recognize why equal individual chances do not make a sample a simple random sample (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A teacher has 8 students and chooses a simple random sample of 2 students to present. What is the probability that Ana and Ben are both chosen?', null, md5('apstats-mcq-b6-sv-h-1.11-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4', false, 'This is the chance that one given student is chosen, 2/8, and not the chance that two given students are both chosen.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/56', false, 'This counts ordered pairs, 8 × 7 = 56, but the order of selection does not matter, so each pair has probability 1/28.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/16', false, 'This treats the two selections as independent with replacement, (1/4) × (1/4), but a sample without replacement has no repeats.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/28', true, 'Correct: There are C(8,2) = 28 equally likely pairs and the pair (Ana, Ben) is exactly one of them, so the probability is 1/28.' from version_ins;
-- apstats-mcq-b6-h-1.11-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.11-b', 'mcq', 'carry out simple random selection with a table of random digits, handling invalid labels and repeats', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A manager numbers 80 employees 01 to 80 and uses a table of random digits to select an SRS of 5. Reading two digits at a time from the left in the string 71298403715512904728, skipping invalid labels and repeats, which sample is selected?', null, md5('apstats-mcq-b6-h-1.11-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '71, 29, 03, 55, 12', true, 'Correct: Pairs: 71, 29, 84 (invalid), 03, 71 (repeat), 55, 12; the first five valid, distinct labels are 71, 29, 03, 55, 12.' from version_ins
union all select gen_random_uuid(), id, 'B', '71, 29, 03, 71, 55', false, 'This allows 71 to be chosen twice, but an SRS selects each individual at most once, so a repeat is skipped.' from version_ins
union all select gen_random_uuid(), id, 'C', '71, 29, 04, 03, 55', false, 'The pair 84 was changed to 04 by subtracting 80, but invalid labels should be skipped rather than converted.' from version_ins
union all select gen_random_uuid(), id, 'D', '7, 1, 2, 9, 8', false, 'These are single digits, but labels have two digits, so the digits must be read in pairs.' from version_ins;
-- apstats-mcq-b6-sv-h-1.11-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.11-b-v1', 'mcq', 'carry out simple random selection with a table of random digits, handling invalid labels and repeats (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A club numbers its 250 members 001 to 250 and uses a table of random digits to select an SRS of 4. Reading three digits at a time from the left in the string 812436091847225017199346, skipping invalid labels and repeats, which sample is selected?', null, md5('apstats-mcq-b6-sv-h-1.11-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '062, 186, 091, 097', false, 'These come from subtracting 250 from 812, 436 and 847, but invalid labels should be skipped, not converted.' from version_ins
union all select gen_random_uuid(), id, 'B', '091, 225, 017, 199', true, 'Correct: Triples: 812, 436 (invalid), 091, 847 (invalid), 225, 017, 199; the first four valid labels are 091, 225, 017, 199.' from version_ins
union all select gen_random_uuid(), id, 'C', '091, 225, 017, 346', false, 'The group 346 is not a valid label because it is above 250, and the sample should include 199 before it.' from version_ins
union all select gen_random_uuid(), id, 'D', '81, 24, 36, 09', false, 'These come from reading two digits at a time, but the labels have three digits.' from version_ins;
-- apstats-mcq-b6-sv-h-1.11-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.11-b-v2', 'mcq', 'carry out simple random selection with a table of random digits, handling invalid labels and repeats (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lab labels 50 samples 00 to 49 and uses a table of random digits to select an SRS of 4. Reading two digits at a time from the left in the string 6341872905534816207, skipping invalid labels and repeats, which sample is selected?', null, md5('apstats-mcq-b6-sv-h-1.11-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13, 41, 37, 29', false, 'These come from replacing 63 by 13 and 87 by 37, but invalid labels should be skipped, not reduced to valid ones.' from version_ins
union all select gen_random_uuid(), id, 'B', '41, 29, 05, 53', false, 'The pair 53 is not a valid label, because labels end at 49, and the sample should continue to 48.' from version_ins
union all select gen_random_uuid(), id, 'C', '6, 3, 4, 1', false, 'These are single digits, but labels have two digits, so digits must be read in pairs.' from version_ins
union all select gen_random_uuid(), id, 'D', '41, 29, 05, 48', true, 'Correct: Pairs: 63 (invalid), 41, 87 (invalid), 29, 05, 53 (invalid), 48; the first four valid labels are 41, 29, 05, 48.' from version_ins;
-- apstats-mcq-b6-sv-h-1.11-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.11-b-v3', 'mcq', 'carry out simple random selection with a table of random digits, handling invalid labels and repeats (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher numbers 60 people 01 to 60 and uses two-digit groups from a random digit table to select an SRS. The next two-digit group is 87. What should she do so that every person remains equally likely to be selected?', null, md5('apstats-mcq-b6-sv-h-1.11-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Use 87 − 60 = 27 so that no digits are wasted.', false, 'Then 27 could be chosen by 27 or by 87, so people numbered 01 to 27 would be more likely than others.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Select person 60 for any group above 60.', false, 'This gives person 60 a much greater chance of being selected than the others.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Skip 87 and read the next two-digit group.', true, 'Correct: Discarding invalid groups leaves all valid labels equally likely; converting or reassigning invalid groups does not.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Stop and restart the table from the beginning.', false, 'Restarting is unnecessary and can repeat earlier results; an invalid label is simply skipped.' from version_ins;
-- apstats-mcq-b6-h-1.12-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-h-1.12-a', 'mcq', 'identify the type of sampling bias in a scenario and the likely direction of the error', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A college estimates the mean number of hours its students work at paid jobs each week. It emails a survey to a random sample of 500 students and 90 respond. Students who work long hours often say they were too busy to respond. Which statement best describes the bias and its likely direction?', null, md5('apstats-mcq-b6-h-1.12-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Nonresponse bias; the sample mean likely overestimates the true mean.', false, 'The students who are missing work the most hours, so removing them lowers the mean, not raises it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Undercoverage; the sample mean likely underestimates the true mean.', false, 'The sample was selected randomly from the students, so there is no group left out of the sampling frame; the issue is that selected students did not respond.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Voluntary response bias; the sample mean likely overestimates the true mean.', false, 'The students did not volunteer to be in the sample; they were selected and then some did not respond.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Nonresponse bias; the sample mean likely underestimates the true mean.', true, 'Correct: Nonresponse bias arises when selected individuals do not respond; if heavy workers respond less, the average hours among respondents is too low.' from version_ins;
-- apstats-mcq-b6-sv-h-1.12-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.12-a-v1', 'mcq', 'identify the type of sampling bias in a scenario and the likely direction of the error (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher estimates the mean number of hours per week that all adults in a city stream video. She selects phone numbers at random from a landline directory, which lists only about 38% of households, and these households tend to be older. Which statement best describes the bias and its likely direction?', null, md5('apstats-mcq-b6-sv-h-1.12-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Undercoverage; the sample mean likely overestimates the true mean.', false, 'The omitted households are younger and stream more, so leaving them out lowers the estimate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Nonresponse bias; the sample mean likely underestimates the true mean.', false, 'The problem is that the sampling frame leaves out many households before anyone is selected, which is undercoverage.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Undercoverage; the sample mean likely underestimates the true mean.', true, 'Correct: A landline directory excludes younger households that stream more, so the average among those sampled is expected to be too low.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Response bias; the sample mean likely overestimates the true mean.', false, 'Response bias arises from wording or untruthful answers, and nothing in the question suggests this.' from version_ins;
-- apstats-mcq-b6-sv-h-1.12-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.12-a-v2', 'mcq', 'identify the type of sampling bias in a scenario and the likely direction of the error (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An online store adds an optional pop-up poll to its website asking visitors, "Do you enjoy shopping online?" The store reports the percent of respondents who answer yes as an estimate for all adults. Which statement best describes the bias and its likely direction?', null, md5('apstats-mcq-b6-sv-h-1.12-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Voluntary response bias; the sample proportion likely underestimates the proportion of all adults.', false, 'People who visit an online store and choose to answer are more likely to enjoy online shopping, so the estimate is too high.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Response bias; the sample proportion likely overestimates the proportion of all adults.', false, 'Response bias comes from the wording of a question or untruthful answers, and the question here is neutral.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Nonresponse bias; the sample proportion likely underestimates the proportion of all adults.', false, 'No random sample was selected, so there is no group of selected people who failed to respond; the respondents chose themselves.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Voluntary response bias; the sample proportion likely overestimates the proportion of all adults.', true, 'Correct: Visitors to an online store who choose to take the poll are likely to enjoy online shopping, so the sample percent is expected to be too high.' from version_ins;
-- apstats-mcq-b6-sv-h-1.12-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.12-a-v3', 'mcq', 'identify the type of sampling bias in a scenario and the likely direction of the error (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school randomly selects 120 students from the full roster and a teacher reads each of them the question, "Have you ever copied a classmate''s homework?" in front of other teachers, and everyone answers. The school reports the percent who answer yes as an estimate for all students. Which statement best describes the bias and its likely direction?', null, md5('apstats-mcq-b6-sv-h-1.12-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Response bias; the sample proportion likely overestimates the true proportion.', false, 'Students are likely to deny the behavior in front of teachers, so fewer yes answers are given and the estimate is too low.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Response bias; the sample proportion likely underestimates the true proportion.', true, 'Correct: Social pressure from the setting leads to untruthful answers, which is response bias, and denials make the proportion of yes answers too low.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Undercoverage; the sample proportion likely underestimates the true proportion.', false, 'Students were selected from the full roster, so no group is left out of the sampling frame.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Nonresponse bias; the sample proportion likely underestimates the true proportion.', false, 'Everyone selected answered, so the issue is the honesty of the answers, not missing responses.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-sv-h-1.11-a-v3','apstats-mcq-b6-h-1.11-b','apstats-mcq-b6-sv-h-1.11-b-v1','apstats-mcq-b6-sv-h-1.11-b-v2','apstats-mcq-b6-sv-h-1.11-b-v3','apstats-mcq-b6-h-1.12-a','apstats-mcq-b6-sv-h-1.12-a-v1','apstats-mcq-b6-sv-h-1.12-a-v2','apstats-mcq-b6-sv-h-1.12-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b6-sv-h-1.11-a-v3','apstats-mcq-b6-h-1.11-b','apstats-mcq-b6-sv-h-1.11-b-v1','apstats-mcq-b6-sv-h-1.11-b-v2','apstats-mcq-b6-sv-h-1.11-b-v3','apstats-mcq-b6-h-1.12-a','apstats-mcq-b6-sv-h-1.12-a-v1','apstats-mcq-b6-sv-h-1.12-a-v2','apstats-mcq-b6-sv-h-1.12-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
