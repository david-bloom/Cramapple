begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.4-B-v1','APSTATS-MCQ-SV-H-2.4-B-v2','APSTATS-MCQ-SV-H-2.4-B-v3','APSTATS-MCQ-SV-H-2.5-A-v1','APSTATS-MCQ-SV-H-2.5-A-v2','APSTATS-MCQ-SV-H-2.5-A-v3','APSTATS-MCQ-SV-H-2.5-B-v1','APSTATS-MCQ-SV-H-2.5-B-v2','APSTATS-MCQ-SV-H-2.5-B-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-2.4-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.4-B-v1', 'mcq', 'Complement rule with dice and coins (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two fair six-sided dice are rolled. What is the probability that the sum is at least 5?', null, md5('APSTATS-MCQ-SV-H-2.4-B-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/6', false, 'This is the probability of the complementary event, not of the event the question asks about.' from version_ins
union all select gen_random_uuid(), id, 'B', '13/18', false, 'This counts a sum of 5 as excluded too (10 outcomes), so it finds P(sum > 5) = 26/36 = 13/18 instead of P(sum ≥ 5).' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', false, 'Treats the sum as equally likely to be at least 5 or less than 5; the 36 outcomes are not split evenly that way.' from version_ins
union all select gen_random_uuid(), id, 'D', '5/6', true, 'Correct: sums below 5 are (1,1), (1,2), (2,1), (1,3), (3,1), (2,2): 6 of 36, so 1 − 6/36 = 5/6.' from version_ins;
-- APSTATS-MCQ-SV-H-2.4-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.4-B-v2', 'mcq', 'Complement rule with dice and coins (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two fair six-sided dice are rolled. What is the probability that at least one die shows a number greater than 1?', null, md5('APSTATS-MCQ-SV-H-2.4-B-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/36', false, 'This is the probability of the complementary event, not of the event the question asks about.' from version_ins
union all select gen_random_uuid(), id, 'B', '25/36', false, 'This is the probability that both dice show more than 1, (5/6)² = 25/36; the question asks for at least one die above 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '35/36', true, 'Correct: the only outcome with no die above 1 is (1,1), so 1 − 1/36 = 35/36.' from version_ins
union all select gen_random_uuid(), id, 'D', '5/6', false, 'This considers only one die; with two dice the chance that at least one is above 1 is higher.' from version_ins;
-- APSTATS-MCQ-SV-H-2.4-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.4-B-v3', 'mcq', 'Complement rule with dice and coins (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fair coin is flipped 4 times. What is the probability of getting at least one tail?', null, md5('APSTATS-MCQ-SV-H-2.4-B-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/16', false, 'This is the probability of the complementary event, not of the event the question asks about.' from version_ins
union all select gen_random_uuid(), id, 'B', '15/16', true, 'Correct: only HHHH has no tail, so 1 − 1/16 = 15/16.' from version_ins
union all select gen_random_uuid(), id, 'C', '7/8', false, 'This uses 3 flips (1 − 1/8) instead of the 4 flips in the question.' from version_ins
union all select gen_random_uuid(), id, 'D', '3/4', false, 'This treats the four flips as one chance of 1/4 instead of multiplying the chances of four tails, (1/2)⁴ = 1/16.' from version_ins;
-- APSTATS-MCQ-SV-H-2.5-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.5-A-v1', 'mcq', 'Mutually exclusive versus independent from probabilities (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a high school, let C be the event that a randomly chosen student is in a club and J the event that the student has a job. P(C) = 0.40, P(J) = 0.25, and P(C or J) = 0.55. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.5-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C and J are mutually exclusive, because P(C or J) = 0.55 is less than 1.', false, 'A union below 1 says nothing about overlap; P(C and J) = 0.10 > 0, so the events are not mutually exclusive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C and J are not mutually exclusive, because P(C and J) = 0.10 > 0, but they are independent, because 0.10 = (0.40)(0.25).', true, 'Correct: P(C and J) = 0.40 + 0.25 − 0.55 = 0.10 > 0, so the events are not mutually exclusive; 0.10 = (0.40)(0.25), so they are independent.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C and J are mutually exclusive and independent, because P(C and J) equals P(C)P(J).', false, 'Mutually exclusive events have P(A and B) = 0; here P(C and J) = 0.10, so they overlap.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C and J are neither mutually exclusive nor independent, because P(C or J) ≠ P(C) + P(J).', false, 'P(C or J) differing from P(C) + P(J) shows overlap, not dependence; independence is tested with P(C)P(J) = P(C and J).' from version_ins;
-- APSTATS-MCQ-SV-H-2.5-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.5-A-v2', 'mcq', 'Mutually exclusive versus independent from probabilities (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For events A and B, P(A) = 0.35, P(B) = 0.40, and P(A or B) = 0.75. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.5-A-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A and B are not mutually exclusive, because P(A) + P(B) = 0.75 is less than 1.', false, 'A sum of probabilities under 1 does not show that the events overlap; here P(A and B) = 0, so they are mutually exclusive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A and B are mutually exclusive, because P(A and B) = 0, but they are not independent, because P(A)P(B) = 0.14 ≠ 0.', true, 'Correct: 0.35 + 0.40 − 0.75 = 0, so the events are mutually exclusive; (0.35)(0.40) = 0.14 ≠ 0, so they are not independent.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A and B are mutually exclusive and independent, because P(A and B) = 0 means one event does not affect the other.', false, 'This confuses mutually exclusive with independent; mutually exclusive events with positive probabilities strongly affect each other, because one happening rules out the other.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A and B are independent, because P(A or B) = P(A) + P(B).', false, 'P(A or B) = P(A) + P(B) is the exclusivity condition, not independence.' from version_ins;
-- APSTATS-MCQ-SV-H-2.5-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.5-A-v3', 'mcq', 'Mutually exclusive versus independent from probabilities (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For two events A and B, P(A) = 0.60, P(B) = 0.50, and P(A or B) = 0.85. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.5-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A and B are mutually exclusive, because P(A or B) < P(A) + P(B).', false, 'P(A or B) < P(A) + P(B) shows the events overlap, which means they are not mutually exclusive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A and B are independent, because P(A or B) = 0.85 is greater than both P(A) and P(B).', false, 'A union larger than each single probability is true of almost any pair of events and does not show independence.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A and B are not mutually exclusive, because P(A and B) = 0.25 > 0, and they are not independent, because P(A)P(B) = 0.30 ≠ 0.25.', true, 'Correct: P(A and B) = 0.60 + 0.50 − 0.85 = 0.25 > 0, so not mutually exclusive; 0.25 ≠ (0.60)(0.50) = 0.30, so not independent.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A and B are not mutually exclusive, but they are independent, because P(A and B) = 0.25 is positive.', false, 'Independence requires P(A and B) = P(A)P(B) = 0.30; here P(A and B) = 0.25, so they are dependent even though they overlap.' from version_ins;
-- APSTATS-MCQ-SV-H-2.5-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.5-B-v1', 'mcq', 'Addition rule with overlap, then the complement (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A survey of commuters finds that 45% bike to work, 25% take the bus, and 10% do both on different days. What is the probability that a randomly selected commuter does neither?', null, md5('APSTATS-MCQ-SV-H-2.5-B-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.30', false, 'This ignores the overlap: it adds 0.45 + 0.25 = 0.70 and takes 1 − 0.70.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.40', true, 'Correct: union 0.45 + 0.25 − 0.10 = 0.60; 1 − 0.60 = 0.40.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.55', false, 'This removes only the commuters who bike (1 − 0.45) and forgets those who take the bus.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.20', false, 'This adds the overlap (0.45 + 0.25 + 0.10 = 0.80) instead of subtracting it.' from version_ins;
-- APSTATS-MCQ-SV-H-2.5-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.5-B-v2', 'mcq', 'Addition rule with overlap, then the complement (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Among adults in a town, 38% read news online, 27% read a print paper, and 9% do both. What is the probability that a randomly selected adult reads neither?', null, md5('APSTATS-MCQ-SV-H-2.5-B-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.35', false, 'This ignores the overlap: it adds 0.38 + 0.27 = 0.65 and takes 1 − 0.65.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.26', false, 'This adds the overlap (0.38 + 0.27 + 0.09 = 0.74) instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.44', true, 'Correct: union 0.38 + 0.27 − 0.09 = 0.56; 1 − 0.56 = 0.44.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.62', false, 'This removes only the online readers (1 − 0.38) and forgets the print readers.' from version_ins;
-- APSTATS-MCQ-SV-H-2.5-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.5-B-v3', 'mcq', 'Addition rule with overlap, then the complement (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Of 200 students, 90 play soccer, 70 play basketball, and 30 play both. What is the probability that a randomly selected student plays neither sport?', null, md5('APSTATS-MCQ-SV-H-2.5-B-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.35', true, 'Correct: students in at least one sport = 90 + 70 − 30 = 130; 70/200 play neither, so 0.35.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.20', false, 'This ignores the overlap: it adds 90 + 70 = 160 students and takes 1 − 160/200.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.05', false, 'This adds the overlap (90 + 70 + 30 = 190) instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.55', false, '110/200, the students who do not play soccer.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.4-B-v1','APSTATS-MCQ-SV-H-2.4-B-v2','APSTATS-MCQ-SV-H-2.4-B-v3','APSTATS-MCQ-SV-H-2.5-A-v1','APSTATS-MCQ-SV-H-2.5-A-v2','APSTATS-MCQ-SV-H-2.5-A-v3','APSTATS-MCQ-SV-H-2.5-B-v1','APSTATS-MCQ-SV-H-2.5-B-v2','APSTATS-MCQ-SV-H-2.5-B-v3']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-2.4-B-v1','APSTATS-MCQ-SV-H-2.4-B-v2','APSTATS-MCQ-SV-H-2.4-B-v3','APSTATS-MCQ-SV-H-2.5-A-v1','APSTATS-MCQ-SV-H-2.5-A-v2','APSTATS-MCQ-SV-H-2.5-A-v3','APSTATS-MCQ-SV-H-2.5-B-v1','APSTATS-MCQ-SV-H-2.5-B-v2','APSTATS-MCQ-SV-H-2.5-B-v3']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
