begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-038-v3','APSTATS-MCQ-SV-042-v1','APSTATS-MCQ-SV-042-v2','APSTATS-MCQ-SV-042-v3','APSTATS-MCQ-SV-046-v1','APSTATS-MCQ-SV-046-v2','APSTATS-MCQ-SV-046-v3','APSTATS-MCQ-SV-050-v1','APSTATS-MCQ-SV-050-v2','APSTATS-MCQ-SV-050-v3','APSTATS-MCQ-SV-054-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-038-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-038-v3', 'mcq', 'Statewide poll stratified by region precision', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pollster will survey 600 voters in a state whose regions differ sharply in their support for a ballot measure, while voters within a region tend to share similar views. Why might sampling randomly within each region give a more precise estimate than a simple random sample of 600?', null, md5('APSTATS-MCQ-SV-038-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It ensures that every possible group of 600 voters has the same chance of being selected, as in a simple random sample.', false, 'Only a simple random sample gives every possible group of 600 equal chance; a stratified sample allows only groups with the planned count from each region.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The pollster can choose the most typical voters in each region, which makes the sample more precise.', false, 'Handpicking typical voters is non-random and introduces bias; stratified sampling still selects voters randomly within each region.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It guarantees that the sample proportion for the state equals the true statewide proportion.', false, 'Stratified estimates still vary from sample to sample; they are only less variable, not exact.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Voters within each region are alike, so sampling within regions reduces variability in the statewide estimate compared with a simple random sample of 600.', true, 'When strata are internally similar but differ from each other, stratifying removes the between-region variation from the estimate, so the sample proportion varies less from sample to sample.' from version_ins;
-- APSTATS-MCQ-SV-042-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-042-v1', 'mcq', 'Running coach random assignment', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A track coach randomly assigns 24 runners to either a new stretching routine or the usual warm-up, then compares their 5K times at the end of the season. What does random assignment help with most?', null, md5('APSTATS-MCQ-SV-042-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Making sure the 24 runners are representative of all runners in the league.', false, 'Representativeness comes from random selection of subjects from the population; random assignment only decides which treatment each subject gets.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Guaranteeing that the two groups have exactly the same mean 5K time before the routines begin.', false, 'Random assignment balances groups on average, but chance can still leave differences; it does not guarantee identical means.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Keeping the runners from knowing which routine they received.', false, 'Hiding the treatment from subjects is blinding, which is a separate design feature from random assignment.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Making the two groups similar in traits like fitness level, so a time difference can reasonably be attributed to the routine.', true, 'Chance assignment tends to spread fitness, age, and other traits evenly across groups, so the routine is the main systematic difference, supporting a cause-and-effect conclusion.' from version_ins;
-- APSTATS-MCQ-SV-042-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-042-v2', 'mcq', 'Skin cream random assignment', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pharmacy randomly assigns 60 volunteers with a mild rash to use either a new cream or the standard cream for two weeks and then rates how much each rash improved. What does random assignment help with most?', null, md5('APSTATS-MCQ-SV-042-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ensuring that each cream group contains exactly the same number of men as women.', false, 'Random assignment does not guarantee equal counts in subgroups; getting equal numbers by sex would require blocking.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Tending to balance known and unknown variables, like age and skin sensitivity, across the cream groups.', true, 'Because every volunteer is equally likely to land in either group, chance tends to even out all other variables, including ones the researchers did not think to measure.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Removing measurement error from the rash-improvement ratings.', false, 'Random assignment does not affect how accurately improvement is measured; measurement error comes from the rating process.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Making sure the volunteers represent all adults who develop rashes.', false, 'These are volunteers; representing all adults would require random selection from that population, not random assignment.' from version_ins;
-- APSTATS-MCQ-SV-042-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-042-v3', 'mcq', 'Website layout random assignment', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A software company randomly shows each visitor to its site either layout A or layout B and compares the percent of visitors who sign up for a trial. What does random assignment help with most?', null, md5('APSTATS-MCQ-SV-042-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Making sure the visitors tested match the company''s overall customer base.', false, 'Matching the customer base depends on how the visitors were selected, not on how they were assigned to layouts.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Making visitors who see layout A comparable to those who see B, so a difference in sign-up rates can be attributed to the layout.', true, 'Random assignment tends to equalize visitor characteristics, such as device or interest level, across the layouts, which makes the layout the likely explanation for a large difference.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ensuring the visitors cannot tell that two layouts are being compared, making the study blind.', false, 'Concealing the comparison from subjects is blinding, which random assignment does not provide.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Guaranteeing that both layout groups contain exactly the same number of returning customers.', false, 'Chance can leave different counts of returning customers in each group; random assignment only balances such traits in the long run.' from version_ins;
-- APSTATS-MCQ-SV-046-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-046-v1', 'mcq', 'Employee carpool and early arrival', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Of 60 employees at a company, 15 carpool to work and 20 arrive early. Six employees both carpool and arrive early. What is P(arrives early | carpools)?', null, md5('APSTATS-MCQ-SV-046-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6/15 = 0.40', true, 'Given that the employee carpools, the denominator is the 15 carpoolers; 6 of them arrive early, so 6/15 = 0.40.' from version_ins
union all select gen_random_uuid(), id, 'B', '6/9 ≈ 0.67', false, 'The 9 is the number of carpoolers who do NOT arrive early (15 − 6); the denominator should be all 15 carpoolers.' from version_ins
union all select gen_random_uuid(), id, 'C', '6/20 = 0.30', false, 'This divides by the number who arrive early, which is P(carpools | arrives early), the reversed conditional.' from version_ins
union all select gen_random_uuid(), id, 'D', '6/60 = 0.10', false, 'This divides by all employees, giving the joint probability P(carpools and arrives early) rather than a conditional probability.' from version_ins;
-- APSTATS-MCQ-SV-046-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-046-v2', 'mcq', 'Band and orchestra membership', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a school of 120 students, 48 are in band and 30 are in orchestra. Eighteen students are in both. What is P(in orchestra | in band)?', null, md5('APSTATS-MCQ-SV-046-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18/48 = 0.375', true, 'Given the student is in band, the sample space is the 48 band members; 18 of them are in orchestra, so 18/48 = 0.375.' from version_ins
union all select gen_random_uuid(), id, 'B', '30/120 = 0.25', false, 'This is the unconditional probability P(orchestra); knowing the student is in band changes the probability.' from version_ins
union all select gen_random_uuid(), id, 'C', '18/30 = 0.60', false, 'This uses orchestra members as the denominator, which is P(band | orchestra), the reversed conditional.' from version_ins
union all select gen_random_uuid(), id, 'D', '18/120 = 0.15', false, 'This is the joint probability P(band and orchestra), using the whole school as the denominator.' from version_ins;
-- APSTATS-MCQ-SV-046-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-046-v3', 'mcq', 'Online purchases by age two-way table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A store surveyed 200 customers and recorded age group and whether they bought online. The results are below.
Under 30, bought online: 50
Under 30, did not buy online: 30
30 or older, bought online: 40
30 or older, did not buy online: 80
What is P(under 30 | bought online)?', null, md5('APSTATS-MCQ-SV-046-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '50/80 = 0.625', false, 'This divides by the 80 under-30 customers, which is P(bought online | under 30), the reversed conditional.' from version_ins
union all select gen_random_uuid(), id, 'B', '90/200 = 0.45', false, '90/200 = 0.45 is the marginal probability of buying online. The question asks what fraction of online buyers are under 30, so the numerator must be the 50 under-30 online buyers, not all 90 buyers.' from version_ins
union all select gen_random_uuid(), id, 'C', '50/200 = 0.25', false, 'This divides by all 200 customers, giving the joint probability instead of the conditional probability.' from version_ins
union all select gen_random_uuid(), id, 'D', '50/90 ≈ 0.56', true, 'Among the 50 + 40 = 90 customers who bought online, 50 are under 30, so P = 50/90 ≈ 0.56.' from version_ins;
-- APSTATS-MCQ-SV-050-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-050-v1', 'mcq', 'Defective bulb complement', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The probability that a randomly selected bulb from a production line is defective is 0.08. What is the probability that the bulb is not defective?', null, md5('APSTATS-MCQ-SV-050-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−0.92', false, 'This subtracts in the wrong order (0.08 − 1); a probability cannot be negative, and the complement is 1 − 0.08 = 0.92.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.92', true, 'The complement rule gives P(not defective) = 1 − 0.08 = 0.92.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.20', false, 'This comes from treating 0.08 as 0.8 and computing 1 − 0.8; the complement of 0.08 is 0.92.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.08', false, 'This repeats the probability of a defective bulb rather than its complement.' from version_ins;
-- APSTATS-MCQ-SV-050-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-050-v2', 'mcq', 'Flight on-time complement', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The probability that a certain flight arrives on time is 0.82. What is the probability that the flight does not arrive on time?', null, md5('APSTATS-MCQ-SV-050-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.18', true, 'By the complement rule, 1 − 0.82 = 0.18.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.08', false, 'This subtracts 0.82 from 0.90 instead of from 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.82', false, 'This is the probability of arriving on time, not its complement.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.82', false, 'This adds 0.82 to 1; a probability cannot exceed 1, and the complement is 1 − 0.82.' from version_ins;
-- APSTATS-MCQ-SV-050-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-050-v3', 'mcq', 'Snow forecast complement', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A forecaster says there is a 40% chance of snow tomorrow. What is the probability that it does not snow?', null, md5('APSTATS-MCQ-SV-050-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.60', true, 'Writing 40% as 0.40, the complement is 1 − 0.40 = 0.60.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.96', false, 'This converts 40% to 0.04 and then computes 1 − 0.04; 40% is 0.40, so the complement is 0.60.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.40', false, 'This repeats the probability of snow instead of finding its complement.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.50', false, 'This assumes snow and no snow are equally likely, which ignores the given 40% chance.' from version_ins;
-- APSTATS-MCQ-SV-054-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-054-v1', 'mcq', 'Spanish or music union', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a school, the probability that a randomly selected student takes Spanish is 0.45, the probability the student takes music is 0.30, and the probability the student takes both is 0.10. What is the probability that a randomly selected student takes Spanish or music (or both)?', null, md5('APSTATS-MCQ-SV-054-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.65', true, 'By the addition rule, P(Spanish or music) = 0.45 + 0.30 − 0.10 = 0.65.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.55', false, 'This subtracts the overlap twice: 0.45 + 0.30 − 2(0.10) = 0.55.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.135', false, 'This multiplies 0.45 × 0.30, which would be the probability of both only if the events were independent, and it is not the union.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.75', false, 'This adds 0.45 and 0.30 without subtracting the overlap, so students taking both are counted twice.' from version_ins;
commit;
