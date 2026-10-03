begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-026-v3','APSTATS-MCQ-SV-039-v1','APSTATS-MCQ-SV-039-v2','APSTATS-MCQ-SV-039-v3','APSTATS-MCQ-SV-043-v1','APSTATS-MCQ-SV-043-v2','APSTATS-MCQ-SV-043-v3','APSTATS-MCQ-SV-047-v1','APSTATS-MCQ-SV-047-v2','APSTATS-MCQ-SV-047-v3','APSTATS-MCQ-SV-051-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-026-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-026-v3', 'mcq', 'Salary percentile', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An employee at a large company learns that her salary is at the 60th percentile of all salaries at the company. Which statement is correct?', null, md5('APSTATS-MCQ-SV-026-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 60% of employees at the company earn her salary or less.', true, 'The 60th percentile means about 60% of the values are at or below that value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 60% of employees at the company earn more than she does.', false, 'That would put her near the 40th percentile; at the 60th percentile about 40% earn more.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Her salary is 60% of the highest salary at the company.', false, 'Percentile compares the count of employees below, not her salary as a fraction of the maximum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'She has the 60th highest salary among the employees at the company.', false, 'Percentile is a percentage of the group, not a rank; the 60th highest in a large company would be a much higher percentile.' from version_ins;
-- APSTATS-MCQ-SV-039-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-039-v1', 'mcq', 'Vitamin D records study', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers examine the medical records of 500 adults, noting whether each person takes a daily vitamin D supplement and whether the person had a bone fracture in the past five years. The researchers do not tell anyone to start or stop taking supplements. What type of study is this?', null, md5('APSTATS-MCQ-SV-039-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A single-blind experiment', false, 'An experiment requires an imposed treatment, and nothing about blinding is described.' from version_ins
union all select gen_random_uuid(), id, 'B', 'An observational study', true, 'The researchers only record existing behavior and outcomes; no treatment is imposed on the adults.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A randomized block experiment', false, 'There are no blocks and no random assignment of any treatment.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A completely randomized experiment', false, 'No one is randomly assigned to supplements; people chose for themselves.' from version_ins;
-- APSTATS-MCQ-SV-039-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-039-v2', 'mcq', 'Self-selected study method', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A teacher lets her 40 students choose either flashcards or practice tests as their study method for a unit, then compares the two groups'' scores on the unit exam. What type of study is this?', null, md5('APSTATS-MCQ-SV-039-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A randomized block design, because the students form two groups.', false, 'Blocks are formed before treatments are randomly assigned within them; here the groups came from student choice.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A randomized experiment, because the teacher compared two study methods.', false, 'Comparing two groups is not enough; an experiment requires the researcher to assign treatments, ideally at random.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An observational study, because students chose their own study method instead of being assigned one.', true, 'The teacher did not impose the treatment; students self-selected into the groups, so this is observational and cannot show cause and effect.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A matched-pairs experiment, because every student took the same exam.', false, 'Matched pairs requires pairing subjects or measuring each subject twice under assigned conditions, which did not occur.' from version_ins;
-- APSTATS-MCQ-SV-039-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-039-v3', 'mcq', 'Diet assignment study', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers randomly assign 90 volunteers to one of three diets and measure each volunteer''s cholesterol level after eight weeks. What type of study is this?', null, md5('APSTATS-MCQ-SV-039-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An observational study, because cholesterol was only measured at the end.', false, 'Measuring a response does not make a study observational; what matters is that the researchers imposed the diets.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A randomized experiment, because the researchers assigned the diets to the volunteers at random.', true, 'The researchers imposed the treatments (diets) and used random assignment, which defines a randomized experiment.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An observational study, because the volunteers were not a random sample of adults.', false, 'Volunteer subjects limit generalization, but the study type depends on whether treatments are imposed, and they were.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A sample survey, because 90 people provided data.', false, 'A sample survey gathers opinions or facts from a sample without imposing treatments; here diets were assigned.' from version_ins;
-- APSTATS-MCQ-SV-043-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-043-v1', 'mcq', 'PTA directory mailing', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school district wants to learn parents'' opinions about school lunches. It mails questionnaires only to the families listed in the PTA directory. Which bias is most likely?', null, md5('APSTATS-MCQ-SV-043-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Voluntary response bias, because parents decide whether to fill out the form.', false, 'Voluntary response bias applies when people select themselves into the sample; here the district chose whom to mail.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Undercoverage bias, because parents not in the PTA directory have no chance to be selected.', true, 'Families missing from the directory are left out of the sampling frame, so the sample is likely to differ from all parents.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Nonresponse bias, because some mailed questionnaires will not be returned.', false, 'Nonresponse concerns selected people who do not reply; the main problem here is that many parents were never selected at all.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No bias, because every questionnaire was sent by the same method.', false, 'A uniform method does not fix a frame that omits parents; the sample is still unrepresentative.' from version_ins;
-- APSTATS-MCQ-SV-043-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-043-v2', 'mcq', 'Radio call-in poll', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A radio station asks listeners to call in during a morning show to vote on whether the city should build a new stadium, and it reports the percent of callers in favor. What is the most likely source of bias?', null, md5('APSTATS-MCQ-SV-043-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'No bias, because a large number of listeners will call in.', false, 'A large number of responses does not make a self-selected group representative; the bias remains however many call.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Voluntary response bias, because only listeners with strong opinions are likely to call.', true, 'Callers choose themselves, and people with strong feelings are more likely to respond, so the callers do not represent the city.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Placebo effect, because the callers believe their vote matters.', false, 'A placebo effect concerns responses to inactive treatments in experiments, not to opinion polls.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Confounding bias, because a lurking variable is mixed with the stadium vote.', false, 'Confounding is a feature of comparing treatments or groups; this is a single poll of opinion.' from version_ins;
-- APSTATS-MCQ-SV-043-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-043-v3', 'mcq', 'Low mail return rate', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A city randomly selects 1,000 households from a complete list of all households and mails each a survey about recycling. Only 220 households return it. Which bias is most likely?', null, md5('APSTATS-MCQ-SV-043-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Undercoverage bias, because 780 households are missing from the data.', false, 'Those 780 were in the frame and were selected; they are missing due to not responding, not because they were excluded from the frame.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Response bias, because the survey asked about recycling.', false, 'Response bias comes from untruthful or distorted answers, for example from wording; nothing in the setup points to that.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Nonresponse bias, because households that did not reply may differ from those that did.', true, 'All households had a chance to be chosen, but 780 chosen households did not respond, and the 220 who replied may not represent them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Convenience sampling bias, because mailed surveys are the cheapest approach.', false, 'The households were chosen randomly from a complete list, so the selection was not by convenience.' from version_ins;
-- APSTATS-MCQ-SV-047-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-047-v1', 'mcq', 'Independence of club and job', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a high school, a student is chosen at random. Let C be the event that the student is in a club and J the event that the student has a part-time job. P(C) = 0.50, P(J) = 0.20, and P(C and J) = 0.15. Are C and J independent?', null, md5('APSTATS-MCQ-SV-047-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'No, because P(C and J) = 0.15 is not equal to P(C) + P(J) = 0.70.', false, 'The addition of probabilities is not the independence check; the product is.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Yes, because P(C or J) = 0.55 is less than 1.', false, 'P(C or J) = 0.50 + 0.20 - 0.15 = 0.55 is a valid probability but says nothing about independence.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No, because P(C)P(J) = 0.10, which does not equal P(C and J) = 0.15.', true, 'Independence requires P(C and J) = P(C)P(J); 0.50 x 0.20 = 0.10, but the joint probability is 0.15.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Yes, because P(C and J) = 0.15 is smaller than both P(C) and P(J).', false, 'The joint probability is always at most each single probability; that does not test independence.' from version_ins;
-- APSTATS-MCQ-SV-047-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-047-v2', 'mcq', 'Bus and glasses conditional check', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a school, P(a student rides the bus) = 0.50 and P(a student wears glasses) = 0.20. Among students who ride the bus, 20% wear glasses. Are riding the bus and wearing glasses independent?', null, md5('APSTATS-MCQ-SV-047-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Yes, because P(glasses | bus) = 0.20 equals P(glasses) = 0.20.', true, 'If knowing a student rides the bus does not change the probability of wearing glasses, the events are independent.' from version_ins
union all select gen_random_uuid(), id, 'B', 'No, because P(glasses | bus) = 0.20 is much smaller than P(bus) = 0.50.', false, 'This compares probabilities of different events; independence compares P(glasses | bus) with P(glasses).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Yes, because P(bus) + P(glasses) = 0.70, which is less than 1.', false, 'A sum below 1 does not establish independence; the conditional probability equaling the marginal does.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No, because both events can occur together, with P(bus and glasses) = 0.10 > 0.', false, 'Events that can occur together may still be independent; here 0.50 x 0.20 = 0.10 matches the joint probability.' from version_ins;
-- APSTATS-MCQ-SV-047-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-047-v3', 'mcq', 'Independence from counts', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cafe records 300 orders. Of these, 120 included coffee, 90 included a pastry, and 45 included both. For a randomly chosen order, are ''includes coffee'' and ''includes a pastry'' independent?', null, md5('APSTATS-MCQ-SV-047-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'No, because 45 does not equal 120 + 90 = 210.', false, 'Independence is not tested by comparing the joint count to the sum of counts; the joint probability is compared with the product.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Yes, because 120 + 90 = 210, which is less than the 300 orders.', false, 'Whether the counts sum to less than the total says nothing about how the events relate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Yes, because the 45 orders with both are fewer than the 120 or the 90 orders with each item.', false, 'A joint count is smaller than each single count for almost any two events, so this says nothing about independence; independence compares the joint probability with the product of the individual probabilities.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No, because P(coffee and pastry) = 45/300 = 0.15, which differs from P(coffee)P(pastry) = 0.40 x 0.30 = 0.12.', true, 'Independence needs the joint probability to equal the product of the individual probabilities; 0.15 is not 0.12.' from version_ins;
-- APSTATS-MCQ-SV-051-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-051-v1', 'mcq', 'Senior and freshman exclusive', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student is chosen at random from a high school. Event S is that the student is a senior and event F is that the student is a freshman. Are S and F mutually exclusive?', null, md5('APSTATS-MCQ-SV-051-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Yes, because being a senior and being a freshman are independent events.', false, 'Mutually exclusive events with nonzero probabilities are never independent, since knowing one occurred makes the other impossible.' from version_ins
union all select gen_random_uuid(), id, 'B', 'No, because P(S) + P(F) is less than 1.', false, 'Mutually exclusive events need not add to 1; other grades make the sum less than 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No, because both groups belong to the same school.', false, 'Belonging to the same school does not matter; what matters is whether the events can occur at the same time, and a student has only one grade.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Yes, because a student cannot be both a senior and a freshman, so P(S and F) = 0.', true, 'Mutually exclusive events cannot occur together; one student has only one grade level.' from version_ins;
commit;
