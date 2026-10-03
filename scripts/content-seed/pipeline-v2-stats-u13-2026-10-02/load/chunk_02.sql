begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-027-v3','APSTATS-MCQ-SV-040-v1','APSTATS-MCQ-SV-040-v2','APSTATS-MCQ-SV-040-v3','APSTATS-MCQ-SV-044-v1','APSTATS-MCQ-SV-044-v2','APSTATS-MCQ-SV-044-v3','APSTATS-MCQ-SV-048-v1','APSTATS-MCQ-SV-048-v2','APSTATS-MCQ-SV-048-v3','APSTATS-MCQ-SV-052-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-027-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-027-v3', 'mcq', 'Retirement age distribution', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The ages at which employees at a large company retired form a left-skewed distribution, with a few people retiring in their early forties and most retiring in their sixties. Which statement is most likely true?', null, md5('APSTATS-MCQ-SV-027-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mean and median retirement ages are exactly equal.', false, 'Equality is expected only for symmetric distributions; skew separates them.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mean retirement age is greater than the median retirement age.', false, 'This is the pattern for right skew; the low tail pulls the mean down in a left-skewed distribution.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean retirement age is less than the median retirement age.', true, 'The few very early retirements pull the mean toward the low tail while the median stays near the bulk of the data.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The median is pulled further toward the early retirees than the mean is.', false, 'The median is resistant to the early retirements and is pulled less than the mean.' from version_ins;
-- APSTATS-MCQ-SV-040-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-040-v1', 'mcq', 'Blocking in a fertilizer experiment', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gardener wants to compare two fertilizers using 24 tomato plants in a garden where half the plants are in full sun and half are in shade, and sunlight strongly affects growth. Which plan uses blocking?', null, md5('APSTATS-MCQ-SV-040-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Apply fertilizer A to all sun plants and fertilizer B to all shade plants.', false, 'Fertilizer is completely confounded with sunlight, so differences cannot be attributed to fertilizer; no random assignment within blocks.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Separate the plants into sun and shade groups, then randomly assign fertilizers within each group.', true, 'Sunlight is a known source of variability; random assignment within sun and shade blocks balances it across both fertilizers, so sunlight cannot be confounded with fertilizer.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Flip a coin for each plant to choose its fertilizer, ignoring sunlight.', false, 'This is a completely randomized design; no blocks are formed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Use only the sun plants and randomly assign the two fertilizers.', false, 'This controls sunlight by restricting the study, but it is not blocking since shade plants are not included and results do not extend to shade.' from version_ins;
-- APSTATS-MCQ-SV-040-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-040-v2', 'mcq', 'Purpose of blocking in a study-method experiment', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers compare two study methods using students whose prior GPAs vary widely, and they place students into ''high GPA'' and ''low GPA'' blocks before randomly assigning methods within each block. What is the main purpose of blocking here?', null, md5('APSTATS-MCQ-SV-040-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'To remove variation due to prior GPA so method differences are easier to detect.', true, 'Blocking removes variation tied to GPA from the comparison between methods, making treatment differences clearer.' from version_ins
union all select gen_random_uuid(), id, 'B', 'To remove the need for random assignment of methods to students.', false, 'Random assignment is still done within each block.' from version_ins
union all select gen_random_uuid(), id, 'C', 'To make sure the sample is representative of every student in the school.', false, 'Representativeness comes from random sampling, not blocking.' from version_ins
union all select gen_random_uuid(), id, 'D', 'To make sure neither the students nor the graders know which method was used.', false, 'That describes blinding; blocking concerns grouping similar units.' from version_ins;
-- APSTATS-MCQ-SV-040-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-040-v3', 'mcq', 'Identifying the design type', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'To compare two exercise programs, a researcher separates 60 volunteers into a male group and a female group, then within each group uses a random number generator to assign half to Program 1 and half to Program 2. Which description is most accurate?', null, md5('APSTATS-MCQ-SV-040-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A randomized block experiment, with sex as the blocking variable.', true, 'Subjects are grouped by sex and treatments are randomly assigned within each block.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A completely randomized design, since random assignment was used.', false, 'In a completely randomized design all subjects are randomized together; here randomization is within sex groups.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A stratified random sample, since subjects were grouped by sex.', false, 'Stratified sampling is about selecting units for a sample; here the researcher assigns treatments, so it is an experiment.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An observational study, since sex cannot be assigned.', false, 'The researcher imposes the exercise programs, so it is an experiment; sex is only a blocking variable.' from version_ins;
-- APSTATS-MCQ-SV-044-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-044-v1', 'mcq', 'Single-blind scoring in a tutoring study', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Students are randomly assigned to use a tutoring app or a traditional workbook. The final tests are scored by a teacher who is not told which students used which method. What is the main benefit of having the scorer blinded?', null, md5('APSTATS-MCQ-SV-044-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It prevents the scorer''s expectations about the app from influencing the scores.', true, 'Blinding evaluators keeps expectations from biasing measurements.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It removes confounding variables such as prior ability.', false, 'Confounding is handled by random assignment and design, not by blinding.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It prevents the students'' expectations from affecting their performance.', false, 'The students know which method they used, so blinding the scorer does not address student expectations.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It makes the sample representative of all students.', false, 'Representativeness comes from random sampling.' from version_ins;
-- APSTATS-MCQ-SV-044-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-044-v2', 'mcq', 'Measuring the placebo effect', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a study of a headache remedy, a placebo group''s pain score improved by an average of 4.1 points, while a no-treatment group''s pain score improved by an average of 1.3 points. Using the definition of placebo effect as the difference between the average placebo response and the average no-treatment response, what is the placebo effect?', null, md5('APSTATS-MCQ-SV-044-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.4 points', false, '4.1 + 1.3 = 5.4 adds the two averages rather than taking the difference.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.1 points', false, 'This is the placebo group''s full average improvement; part of it (1.3) would have happened with no treatment.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.8 points', true, '4.1 - 1.3 = 2.8, the extra improvement attributable to receiving a placebo rather than nothing.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 points, because a placebo contains no active ingredient.', false, 'A placebo effect can occur even without an active ingredient; here the placebo group improved 2.8 points more than the no-treatment group.' from version_ins;
-- APSTATS-MCQ-SV-044-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-044-v3', 'mcq', 'Identifying a double-blind design', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which setup for a trial of a new cholesterol drug is double-blind?', null, md5('APSTATS-MCQ-SV-044-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Identical-looking capsules coded by pharmacy; neither patients nor the clinicians recording outcomes know assignments.', true, 'Hiding assignments from both patients and outcome evaluators makes it double-blind, reducing placebo effects and observer bias.' from version_ins
union all select gen_random_uuid(), id, 'B', 'All patients receive the drug and both patients and clinicians know it.', false, 'Giving everyone the drug with everyone aware has no comparison group and no blinding, so it is neither single- nor double-blind.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Patients are unaware of what they receive, but the clinician recording outcomes knows each assignment.', false, 'Since the clinician recording outcomes knows each assignment, only one party is blinded, so the design is single-blind.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Patients choose between the drug and a placebo, but clinicians do not know who chose which.', false, 'Patients choosing their own treatment is not random assignment and the patients are not blinded, so it is not double-blind.' from version_ins;
-- APSTATS-MCQ-SV-048-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-048-v1', 'mcq', 'Email open and click probabilities', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a marketing email, 45% of recipients open the message. Among those who open it, 20% click the link. What is the probability that a randomly selected recipient both opens the email and clicks the link?', null, md5('APSTATS-MCQ-SV-048-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.11', false, '0.55 × 0.20 = 0.11 uses the probability of not opening.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.09', true, 'P(open and click) = P(open) × P(click | open) = 0.45 × 0.20 = 0.09.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.65', false, '0.45 + 0.20 = 0.65 adds the probabilities rather than multiplying along the path.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.25', false, '0.45 - 0.20 = 0.25 subtracts instead of multiplying.' from version_ins;
-- APSTATS-MCQ-SV-048-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-048-v2', 'mcq', 'Passing two exams in sequence', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student passes the first exam of a course with probability 0.80. If the student passes the first exam, the probability of passing the second exam is 0.75. What is the probability that the student passes both exams?', null, md5('APSTATS-MCQ-SV-048-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.20', false, '0.80 × 0.25 = 0.20 is the probability of passing the first and failing the second.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.95', false, 'This treats the problem as finding the chance of passing at least one exam with an addition-rule calculation. The question asks for passing both, which uses the multiplication rule: 0.80 × 0.75 = 0.60.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.75', false, 'This is only the conditional probability of passing the second exam given the first.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.60', true, 'P(both) = 0.80 × 0.75 = 0.60.' from version_ins;
-- APSTATS-MCQ-SV-048-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-048-v3', 'mcq', 'Three-stage multiplication', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a three-step security check, 50% of travelers pass step 1. Of those, 40% pass step 2. Of those who pass steps 1 and 2, 90% pass step 3. What proportion of all travelers pass all three steps?', null, md5('APSTATS-MCQ-SV-048-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.02', false, '0.50 × 0.40 × 0.10 = 0.02 uses the failure proportion for step 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.18', true, '0.50 × 0.40 × 0.90 = 0.18.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.60', false, 'The average of 0.50, 0.40, 0.90 is 0.60, not a probability of all three.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.20', false, '0.50 × 0.40 = 0.20 stops after two steps.' from version_ins;
-- APSTATS-MCQ-SV-052-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-052-v1', 'mcq', 'Identify the binomial scenario', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following random variables has a binomial distribution?', null, md5('APSTATS-MCQ-SV-052-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The number of heads in 15 flips of a fair coin.', true, 'A fixed 15 independent trials, two outcomes, constant p = 0.5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The number of flips needed until the first head appears.', false, 'The number of trials is not fixed in advance.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sum of the faces in 10 rolls of a fair die.', false, 'A sum is not a count of successes; each roll has six outcomes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The number of hearts in a 5-card hand dealt without replacement from a standard deck.', false, 'Trials are dependent and P(heart) changes after each card.' from version_ins;
commit;
