begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-024-v3','APSTATS-MCQ-SV-037-v1','APSTATS-MCQ-SV-037-v2','APSTATS-MCQ-SV-037-v3','APSTATS-MCQ-SV-041-v1','APSTATS-MCQ-SV-041-v2','APSTATS-MCQ-SV-041-v3','APSTATS-MCQ-SV-045-v1','APSTATS-MCQ-SV-045-v2','APSTATS-MCQ-SV-045-v3','APSTATS-MCQ-SV-049-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-024-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-024-v3', 'mcq', 'Median of twelve ordered values', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The monthly rainfall totals (mm) for a city, sorted from least to greatest, are 4, 6, 6, 9, 10, 12, 13, 15, 18, 21, 25, 40. What is the median?', null, md5('APSTATS-MCQ-SV-024-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.5', false, 'This is the average of the positions 6 and 7, not of the values stored at those positions.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', false, 'This is only the 6th value; with 12 values the median averages the 6th and 7th.' from version_ins
union all select gen_random_uuid(), id, 'C', '12.5', true, 'With n = 12 the middle values are the 6th (12) and 7th (13), so the median is (12 + 13)/2 = 12.5.' from version_ins
union all select gen_random_uuid(), id, 'D', '14.9', false, 'This is the mean of all 12 values (179/12, about 14.9), pulled up by the value 40; it is not the median.' from version_ins;
-- APSTATS-MCQ-SV-037-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-037-v1', 'mcq', 'Simple random sample from a registry', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A city council wants a simple random sample of 40 residents from a registry listing 2,000 residents. Which procedure best accomplishes this?', null, md5('APSTATS-MCQ-SV-037-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Interview the first 40 people who walk into city hall on Monday morning.', false, 'This is a convenience sample: people at city hall on a Monday are not randomly chosen and are unlikely to represent all residents.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Take the first 40 residents on the registry, which is sorted by last name.', false, 'The first 40 names alphabetically are a fixed group, not randomly chosen; most residents have no chance of selection.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Number the residents 1 to 2,000 and use a random number generator to draw 40 different numbers.', true, 'Numbering every resident and drawing distinct random numbers gives each resident, and each group of 40, the same chance of selection, which defines a simple random sample.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mail a survey to all residents and use the first 40 that are returned.', false, 'Those who respond first are self-selected, so this is a voluntary response sample that is prone to bias.' from version_ins;
-- APSTATS-MCQ-SV-037-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-037-v2', 'mcq', 'Random sample of gym members', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gym has 250 members and wants feedback from a simple random sample of 25 of them. Which plan is best?', null, md5('APSTATS-MCQ-SV-037-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Post a sign inviting members to take a survey and use the first 25 who respond.', false, 'Members who volunteer are self-selected, which creates voluntary response bias rather than a random sample.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ask the 25 members who are nearest the front desk at noon on Tuesday.', false, 'Whoever is convenient at one time and place is a convenience sample; most members have no chance of being chosen.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Survey the 25 members who visit the gym most often.', false, 'Frequent visitors differ systematically from other members, so this non-random choice builds in bias.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Give each member an ID from 1 to 250 and have software pick 25 different IDs at random.', true, 'Random selection from a complete numbered list gives every member and every group of 25 the same chance of being chosen, which is the definition of an SRS.' from version_ins;
-- APSTATS-MCQ-SV-037-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-037-v3', 'mcq', 'Random sample of seniors', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A principal wants a simple random sample of 50 seniors from the 400 students in the senior class. Which method should she use?', null, md5('APSTATS-MCQ-SV-037-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Select the 50 seniors who have the highest grade point averages.', false, 'Choosing by GPA is a deliberate, non-random rule that excludes lower-GPA students and biases the sample.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Number the seniors 1 to 400 and use a random number generator for 50 distinct numbers.', true, 'Each senior is equally likely to be chosen, and every set of 50 seniors is equally likely, so this is a simple random sample.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Announce a pizza party and take the first 50 seniors who sign up for it.', false, 'Students who sign up are self-selected, so this voluntary response sample is not random.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ask each of the 10 homeroom teachers to hand-pick the 5 students they prefer.', false, 'Teachers choose by their own judgment, so students are not selected by chance and bias is likely.' from version_ins;
-- APSTATS-MCQ-SV-041-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-041-v1', 'mcq', 'Confounder for ice cream and drownings', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Public health data show that in months when ice cream sales are higher, more drownings occur. Which of the following is a plausible confounding variable for this association?', null, md5('APSTATS-MCQ-SV-041-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The year in which the data were recorded, with no link to either quantity', false, 'A year with no link to either swimming or ice cream sales does not influence both quantities, so it cannot explain the association and is not a confounder.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The correlation between the monthly ice cream sales and drownings', false, 'The correlation is a summary of the association, not a separate variable acting on both measurements.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Hot weather, which draws more people to swim and also increases ice cream purchases', true, 'A confounder is linked to both variables. Warm weather leads to more swimming (more drownings) and to more ice cream sales, which can produce the association without either causing the other.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The number of drownings reported in each month', false, 'This is the response variable itself, not a third variable that influences both quantities.' from version_ins;
-- APSTATS-MCQ-SV-041-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-041-v2', 'mcq', 'Confounder for piano lessons and math scores', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school district finds that students who take piano lessons score higher on math tests than students who do not. Which is a plausible confounding variable?', null, md5('APSTATS-MCQ-SV-041-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The p-value from comparing the math scores of the two groups', false, 'The p-value summarizes evidence from the data; it does not affect who takes lessons or how well students do.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Family income, which could affect both lesson enrollment and math scores', true, 'A third variable that influences both who takes lessons and how students do in math can create the observed association with no causal effect of lessons.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The total number of students included in the district study', false, 'Sample size affects precision of estimates, but it does not influence both lesson-taking and math scores for individual students.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average math score earned by the group of students taking lessons', false, 'This is a summary of the response variable for one group, not a separate variable influencing both lessons and scores.' from version_ins;
-- APSTATS-MCQ-SV-041-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-041-v3', 'mcq', 'Confounder for fitness trackers and BMI', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An observational study finds that adults who wear fitness trackers have lower body mass index (BMI), on average, than adults who do not. Which is a plausible confounding variable?', null, md5('APSTATS-MCQ-SV-041-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Health consciousness, causing people to wear trackers and keep a lower BMI', true, 'A trait that affects both tracker use and BMI could explain the association even if trackers have no effect on BMI.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The test statistic used to compare BMI between the two groups', false, 'A test statistic summarizes the data after collection and cannot influence who wears a tracker or their BMI.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The BMI values that were measured for the adults in the study', false, 'BMI is the response variable being compared, not a third variable influencing both groups'' tracker use and outcome.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The number of adults who were included in the study sample group', false, 'Sample size influences precision, but it does not drive both tracker use and BMI.' from version_ins;
-- APSTATS-MCQ-SV-045-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-045-v1', 'mcq', 'Inspecting every restaurant', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A city health department inspects every one of the 312 restaurants in the city. Which term best describes the way these data were collected?', null, md5('APSTATS-MCQ-SV-045-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A census, because every restaurant in the population was included', true, 'A census collects data from every member of the population of interest; here all 312 restaurants were inspected.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A cluster sample, because restaurants are grouped by neighborhood', false, 'A cluster sample includes only some selected clusters; here every restaurant was inspected, so nothing was sampled.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A systematic sample, because inspectors go through restaurants in street-address order', false, 'A systematic sample takes every kth unit; here all units are taken, so it is a census, not a sample.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A convenience sample, because easy-to-reach restaurants were inspected', false, 'A convenience sample takes only readily available units; here all restaurants were inspected, not only the easy ones.' from version_ins;
-- APSTATS-MCQ-SV-045-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-045-v2', 'mcq', 'Employee satisfaction survey', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company with 1,200 employees emails its satisfaction survey to every employee. What is the best name for this data collection method?', null, md5('APSTATS-MCQ-SV-045-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A census of the company''s employees', true, 'Every employee in the population of interest was asked to participate, so it is a census, even though some may not respond.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A stratified random sample by department', false, 'Stratified sampling selects some units from each stratum; here all employees are contacted.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A voluntary response sample', false, 'In a voluntary response sample, people choose whether to be included by responding to an open invitation; here the company contacts every employee, so there is no sampling.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A simple random sample of 1,200 employees', false, 'The company has only 1,200 employees, so choosing 1,200 of them is not a random draw but everyone.' from version_ins;
-- APSTATS-MCQ-SV-045-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-045-v3', 'mcq', 'Weighing every giraffe', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A zoo veterinarian weighs all 15 giraffes at the zoo to describe the herd. What is this called?', null, md5('APSTATS-MCQ-SV-045-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A random sample of giraffes', false, 'A random sample uses chance to pick only some members of the population; here all 15 were measured.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A census of the herd', true, 'All 15 giraffes in the population of interest were measured, so no sampling was involved.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An experiment', false, 'An experiment imposes treatments on subjects; simply weighing animals imposes none, so it is an observational census.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A convenience sample', false, 'A convenience sample would include only easy-to-reach animals; here every giraffe was weighed.' from version_ins;
-- APSTATS-MCQ-SV-049-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-049-v1', 'mcq', 'Expected winnings on a prize wheel', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a school carnival, a prize wheel pays $20 with probability 0.15, $5 with probability 0.30, and $0 otherwise. What are a player''s expected winnings per spin?', null, md5('APSTATS-MCQ-SV-049-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '$9.00', false, 'This multiplies the largest prize by the total probability of any win: 20 x 0.45 = 9, overstating the value of the $5 prize.' from version_ins
union all select gen_random_uuid(), id, 'B', '$8.33', false, 'This is the unweighted mean of the three payouts, (20 + 5 + 0)/3, which ignores their probabilities.' from version_ins
union all select gen_random_uuid(), id, 'C', '$3.00', false, 'This counts only the $20 prize (20 x 0.15) and leaves out the $5 prize''s contribution of $1.50.' from version_ins
union all select gen_random_uuid(), id, 'D', '$4.50', true, 'E(X) = 20(0.15) + 5(0.30) + 0(0.55) = 3.00 + 1.50 = 4.50.' from version_ins;
commit;
