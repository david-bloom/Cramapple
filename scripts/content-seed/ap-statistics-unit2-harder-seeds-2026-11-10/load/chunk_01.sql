begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-2.4-A','APSTATS-MCQ-H-2.4-B','APSTATS-MCQ-H-2.5-A','APSTATS-MCQ-H-2.5-B','APSTATS-MCQ-H-2.6-A','APSTATS-MCQ-H-2.6-B','APSTATS-MCQ-SV-H-2.4-A-v1','APSTATS-MCQ-SV-H-2.4-A-v2','APSTATS-MCQ-SV-H-2.4-A-v3'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- APSTATS-MCQ-H-2.4-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.4-A', 'mcq', 'Interpret a probability as a long-run proportion', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A phone manufacturer''s records over many thousands of phones show that 3% have a defective screen. A store receives a random shipment of 200 phones. The store manager says, "Since 3% are defective, exactly 6 phones in this shipment will have a defective screen." Which statement best evaluates the manager''s claim?', null, md5('APSTATS-MCQ-H-2.4-A'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because 3% of 200 is 6.', false, 'This confuses an expected count (3% of 200 = 6) with a guaranteed count; the actual number in one shipment varies.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is incorrect, because the manager should have used 97%, since most phones in the shipment are not defective.', false, 'This confuses the event with its complement; 97% describes phones that are not defective and does not address the manager''s claim of exactly 6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect, because a 3% rate applies only to shipments of 1,000 or more phones.', false, 'This invents a minimum shipment size; the 3% rate applies to every phone, so it applies to a shipment of 200.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect, because a probability describes the long-run proportion, so the number of defective phones in this particular shipment will vary around 6 and need not equal 6.', true, 'Correct: 3% is a long-run proportion, so the number of defective phones in one shipment of 200 varies around 6 and need not equal 6.' from version_ins;
-- APSTATS-MCQ-H-2.4-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.4-B', 'mcq', 'Complement rule with dice and coins', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two fair six-sided dice are rolled. What is the probability that the sum of the two dice is at least 4?', null, md5('APSTATS-MCQ-H-2.4-B'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/12', false, 'This is P(sum < 4) = 3/36 = 1/12, the complement; the question asks for sums of at least 4, which is 1 − 1/12.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/6', false, 'This counts a sum of 4 as excluded too (6 outcomes), so it finds P(sum > 4) = 30/36 = 5/6 instead of P(sum ≥ 4).' from version_ins
union all select gen_random_uuid(), id, 'C', '11/12', true, 'Correct: sums below 4 are (1,1), (1,2), (2,1): 3 of 36, so P = 1 − 3/36 = 33/36 = 11/12.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, 'This treats sums above and below the cutoff as equally likely, but the 36 outcomes are not split evenly.' from version_ins;
-- APSTATS-MCQ-H-2.5-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.5-A', 'mcq', 'Mutually exclusive versus independent from probabilities', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For two events A and B, P(A) = 0.50, P(B) = 0.30, and P(A or B) = 0.65. Which statement is correct?', null, md5('APSTATS-MCQ-H-2.5-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A and B are not mutually exclusive, because P(A and B) = 0.15 > 0, but they are independent, because 0.15 = (0.50)(0.30).', true, 'Correct: P(A and B) = 0.50 + 0.30 − 0.65 = 0.15 > 0, so the events are not mutually exclusive; 0.15 = (0.50)(0.30), so they are independent.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A and B are mutually exclusive, because P(A or B) = 0.65 is less than 1.', false, 'A union below 1 says nothing about whether the events overlap; here P(A and B) = 0.15 > 0, so they are not mutually exclusive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A and B are both mutually exclusive and independent, because P(A and B) equals P(A)P(B).', false, 'Mutually exclusive events with positive probabilities can never be independent, and these events are not mutually exclusive anyway because P(A and B) = 0.15.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A and B are neither mutually exclusive nor independent, because P(A or B) ≠ P(A) + P(B).', false, 'P(A or B) ≠ P(A) + P(B) shows the events overlap, not that they are dependent; independence requires P(A and B) = P(A)P(B), which holds here.' from version_ins;
-- APSTATS-MCQ-H-2.5-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.5-B', 'mcq', 'Addition rule with overlap, then the complement', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a school, 55% of students take Spanish, 30% take French, and 10% take both. What is the probability that a randomly selected student takes neither language?', null, md5('APSTATS-MCQ-H-2.5-B'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.15', false, 'This ignores the overlap: it adds 0.55 + 0.30 = 0.85 and takes 1 − 0.85, double counting students who take both.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.05', false, 'This adds the overlap (0.55 + 0.30 + 0.10 = 0.95) instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.25', true, 'Correct: P(Spanish or French) = 0.55 + 0.30 − 0.10 = 0.75; 1 − 0.75 = 0.25.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.45', false, 'This removes only the Spanish students (1 − 0.55) and forgets French students.' from version_ins;
-- APSTATS-MCQ-H-2.6-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.6-A', 'mcq', 'Independence from a two-way table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two hundred students were classified by whether they play a school sport and whether they are on the honor roll.
Athlete, On honor roll: 24
Athlete, Not on honor roll: 56
Not an athlete, On honor roll: 36
Not an athlete, Not on honor roll: 84
Which statement is correct?', null, md5('APSTATS-MCQ-H-2.6-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Being an athlete and being on the honor roll are independent, because P(honor roll | athlete) = 24/80 = 0.30 equals P(honor roll) = 60/200 = 0.30.', true, 'Correct: P(athlete) = 0.40, P(honor roll) = 0.30 and P(both) = 24/200 = 0.12 = (0.40)(0.30), so the variables are independent.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Being an athlete and being on the honor roll are not independent, because more non-athletes (36) than athletes (24) are on the honor roll.', false, 'This compares counts of unequal groups; independence must be judged from proportions within each group.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Being an athlete and being on the honor roll are not independent, because P(athlete | honor roll) = 0.40 is not equal to P(honor roll | athlete) = 0.30.', false, 'P(A | B) and P(B | A) are different quantities; they need not be equal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Being an athlete and being on the honor roll are independent, because P(athlete and honor roll) = 0.12 is smaller than both P(athlete) and P(honor roll).', false, 'A joint probability is always smaller than each marginal probability, so being smaller does not show independence.' from version_ins;
-- APSTATS-MCQ-H-2.6-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.6-B', 'mcq', 'Two draws without replacement', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bag contains 5 red marbles and 3 blue marbles. Two marbles are drawn at random, one after the other, without replacement. What is the probability that both marbles are the same color?', null, md5('APSTATS-MCQ-H-2.6-B'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '17/32', false, 'This uses replacement, (5/8)² + (3/8)² = 34/64 = 17/32, but the draws are made without replacement.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/14', false, 'This counts only two red marbles, (5/8)(4/7) = 5/14, and misses two blue marbles.' from version_ins
union all select gen_random_uuid(), id, 'C', '15/56', false, 'P(red then blue) = (5/8)(3/7), a different-colors outcome.' from version_ins
union all select gen_random_uuid(), id, 'D', '13/28', true, 'Correct: P(RR) = (5/8)(4/7) = 20/56; P(BB) = (3/8)(2/7) = 6/56; total 26/56 = 13/28.' from version_ins;
-- APSTATS-MCQ-SV-H-2.4-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.4-A-v1', 'mcq', 'Interpret a probability as a long-run proportion (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A hospital''s records over many years show that 12% of scheduled patients miss their appointment. Tomorrow 300 patients are scheduled. The scheduler says, "Exactly 36 patients will miss their appointment." Which statement best evaluates this claim?', null, md5('APSTATS-MCQ-SV-H-2.4-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is correct, because 12% of 300 is 36.', false, 'Treats the expected count (12% of 300 = 36) as a guaranteed count.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is incorrect, because 12% is a long-run proportion, so the number who miss tomorrow will vary around 36 and need not equal 36.', true, 'Correct: 12% is a long-run proportion, so the number of missed appointments out of 300 varies around 36 and need not equal 36.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect, because the scheduler should have used 88%, since most patients attend.', false, 'Confuses the event with its complement; 88% describes attendance and does not address why the claim of exactly 36 is wrong.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect, because a 12% rate applies only to clinics with at least 1,000 appointments in a day.', false, 'Invents a minimum number of appointments; a long-run rate applies to every individual appointment.' from version_ins;
-- APSTATS-MCQ-SV-H-2.4-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.4-A-v2', 'mcq', 'Interpret a probability as a long-run proportion (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A seed company reports that, over many tests, 90% of its tomato seeds germinate. A gardener plants 20 seeds. Which statement is the most reasonable?', null, md5('APSTATS-MCQ-SV-H-2.4-A-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 18 seeds are likely to germinate, but the actual number will vary from garden to garden.', true, 'Correct: 90% of 20 is 18, which is the expected count, but the actual number germinating varies from garden to garden.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Exactly 18 seeds will germinate, because 90% of 20 is 18.', false, 'Treats the expected count (18) as guaranteed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At least 18 seeds will germinate, because 90% is the minimum germination rate.', false, 'Reads 90% as a minimum; it is a long-run average rate, so a garden can fall below 18.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Nothing can be said about how many will germinate, because only 20 seeds are planted.', false, 'A small sample still has an expected count (0.90 × 20 = 18); it simply varies more than a large sample would.' from version_ins;
-- APSTATS-MCQ-SV-H-2.4-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.4-A-v3', 'mcq', 'Interpret a probability as a long-run proportion (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A streaming service finds that, over millions of plays, 2% of videos stall at least once. An engineer tests 500 plays and says, "Since 2% stall, exactly 10 of these 500 plays will stall." Which statement best evaluates the engineer''s claim?', null, md5('APSTATS-MCQ-SV-H-2.4-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is incorrect, because 2% is too small a probability to apply to 500 plays.', false, 'A small probability still applies to each play; 2% is not too small to apply to 500 plays.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because 2% of 500 is 10.', false, 'Treats the expected count (2% of 500 = 10) as guaranteed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is incorrect, because a probability is a long-run proportion, so the number of stalls in these 500 plays will vary around 10 and need not equal 10.', true, 'Correct: 2% is a long-run proportion, so the number of stalls in 500 plays varies around 10 and need not equal 10.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect, because the engineer should have used 98%, the probability that a play does not stall.', false, 'Uses the complement; 98% is the chance a play does not stall and is not the issue with the claim.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-2.4-A','APSTATS-MCQ-H-2.4-B','APSTATS-MCQ-H-2.5-A','APSTATS-MCQ-H-2.5-B','APSTATS-MCQ-H-2.6-A','APSTATS-MCQ-H-2.6-B','APSTATS-MCQ-SV-H-2.4-A-v1','APSTATS-MCQ-SV-H-2.4-A-v2','APSTATS-MCQ-SV-H-2.4-A-v3']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-H-2.4-A','APSTATS-MCQ-H-2.4-B','APSTATS-MCQ-H-2.5-A','APSTATS-MCQ-H-2.5-B','APSTATS-MCQ-H-2.6-A','APSTATS-MCQ-H-2.6-B','APSTATS-MCQ-SV-H-2.4-A-v1','APSTATS-MCQ-SV-H-2.4-A-v2','APSTATS-MCQ-SV-H-2.4-A-v3']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
