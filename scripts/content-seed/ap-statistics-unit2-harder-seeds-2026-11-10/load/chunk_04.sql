begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.7-A-v3','APSTATS-MCQ-H-2.7-B','APSTATS-MCQ-SV-H-2.7-B-v1','APSTATS-MCQ-SV-H-2.7-B-v2','APSTATS-MCQ-SV-H-2.7-B-v3','APSTATS-MCQ-H-2.9-A','APSTATS-MCQ-SV-H-2.9-A-v1','APSTATS-MCQ-SV-H-2.9-A-v2','APSTATS-MCQ-SV-H-2.9-A-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-2.7-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.7-A-v3', 'mcq', 'Union of independent events (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Events A and B are independent, with P(A) = 0.50 and P(A or B) = 0.65. What is P(B)?', null, md5('APSTATS-MCQ-SV-H-2.7-A-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.30', true, 'Correct: 0.50 + P(B) − 0.50·P(B) = 0.65, so 0.50·P(B) = 0.15 and P(B) = 0.30.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.15', false, 'This subtracts P(A) from P(A or B), which ignores the overlap; independence gives P(A and B) = 0.50·P(B).' from version_ins
union all select gen_random_uuid(), id, 'C', '0.35', false, 'This is the complement, 1 − 0.65, not the probability the question asks about.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.50', false, 'This assumes P(B) = P(A) = 0.50, which does not satisfy 0.50 + P(B) − 0.50·P(B) = 0.65.' from version_ins;
-- APSTATS-MCQ-H-2.7-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.7-B', 'mcq', 'At least one of several independent events', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A building has two independent alarms. During a break-in, alarm 1 sounds with probability 0.90 and alarm 2 sounds with probability 0.80. What is the probability that at least one alarm sounds?', null, md5('APSTATS-MCQ-H-2.7-B'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.72', false, 'This is the probability that both alarms sound, (0.90)(0.80); the question asks for at least one.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.26', false, 'This is the probability that exactly one alarm sounds; at least one also includes the case that both sound.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.98', true, 'Correct: 1 − (0.10)(0.20) = 0.98.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.90', false, 'This uses only the better alarm; with a second alarm the chance that at least one sounds is higher.' from version_ins;
-- APSTATS-MCQ-SV-H-2.7-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.7-B-v1', 'mcq', 'At least one of several independent events (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A website has two independent servers. Server 1 responds to a request with probability 0.95 and server 2 with probability 0.90. What is the probability that at least one server responds?', null, md5('APSTATS-MCQ-SV-H-2.7-B-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.855', false, 'This is the probability that both servers respond, (0.95)(0.90); the question asks for at least one.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.14', false, 'This is the probability that exactly one server responds; at least one also includes the case that both respond.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.95', false, 'This uses only server 1; with a second server the chance that at least one responds is higher.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.995', true, 'Correct: 1 − (0.05)(0.10) = 0.995.' from version_ins;
-- APSTATS-MCQ-SV-H-2.7-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.7-B-v2', 'mcq', 'At least one of several independent events (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A security system uses three independent sensors. Each sensor detects an intruder with probability 0.70. What is the probability that at least one sensor detects the intruder?', null, md5('APSTATS-MCQ-SV-H-2.7-B-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.343', false, 'This is the probability that all three sensors detect, 0.7³; the question asks for at least one.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.189', false, 'This is the probability that exactly one sensor detects; at least one also includes two or three detecting.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.973', true, 'Correct: 1 − (0.30)³ = 0.973.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.700', false, 'This is the probability for a single sensor; with three sensors the chance that at least one detects is higher.' from version_ins;
-- APSTATS-MCQ-SV-H-2.7-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.7-B-v3', 'mcq', 'At least one of several independent events (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ana makes a free throw with probability 0.60 and Ben with probability 0.50. Each takes one shot, independently. What is the probability that at least one of them makes the shot?', null, md5('APSTATS-MCQ-SV-H-2.7-B-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.30', false, 'This is the probability that both players make the shot, (0.60)(0.50); the question asks for at least one.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.55', false, 'This averages the two probabilities, which is not a valid way to combine independent events.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.80', true, 'Correct: 1 − (0.40)(0.50) = 0.80.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.50', false, 'This is the probability that exactly one player makes the shot; at least one also includes the case that both make it.' from version_ins;
-- APSTATS-MCQ-H-2.9-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.9-A', 'mcq', 'Mean and SD after a linear change Y = aX + b', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random variable X has mean 4 and standard deviation 1.5. Let Y = 3X − 2. What are the mean and standard deviation of Y?', null, md5('APSTATS-MCQ-H-2.9-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean 10, standard deviation 4.5', true, 'Correct: mean 3(4) − 2 = 10; SD 3(1.5) = 4.5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean 10, standard deviation 2.5', false, 'This subtracts 2 from the SD; adding or subtracting a constant shifts the mean but does not change the SD.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mean 12, standard deviation 4.5', false, 'This forgets the −2: the mean of Y is 3(4) − 2 = 10, not 3(4).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean 10, standard deviation 13.5', false, 'This multiplies the SD by 9 (the square of 3); the SD is multiplied by 3, and only the variance by 9.' from version_ins;
-- APSTATS-MCQ-SV-H-2.9-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.9-A-v1', 'mcq', 'Mean and SD after a linear change Y = aX + b (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random variable X has mean 20 and standard deviation 4. Let Y = 0.5X + 10. What are the mean and standard deviation of Y?', null, md5('APSTATS-MCQ-SV-H-2.9-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean 20, standard deviation 12', false, 'This adds 10 to the SD; a constant added to every value shifts the mean but does not change the SD.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean 20, standard deviation 2', true, 'Correct: mean 0.5(20) + 10 = 20; SD 0.5(4) = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mean 20, standard deviation 4', false, 'Multiplying a random variable by a constant multiplies its standard deviation by that constant, so the SD does not stay unscaled.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean 30, standard deviation 2', false, 'This adds 10 to the original mean without scaling it by 0.5 first.' from version_ins;
-- APSTATS-MCQ-SV-H-2.9-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.9-A-v2', 'mcq', 'Mean and SD after a linear change Y = aX + b (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The number of items X in an online order has mean 3.2 and standard deviation 1.1. A shipping charge is C = 4 + 2.5X dollars. What are the mean and standard deviation of C?', null, md5('APSTATS-MCQ-SV-H-2.9-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean $8, standard deviation $2.75', false, 'This forgets the $4 base fee: the mean of C is 4 + 2.5(3.2) = 12, not 2.5(3.2) = 8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean $12, standard deviation $6.75', false, 'This adds the $4 base fee to the SD; a constant added to every value shifts the mean but does not change the SD.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mean $12, standard deviation $1.10', false, 'Multiplying a random variable by a constant multiplies its standard deviation by that constant, so the SD does not stay unscaled.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean $12, standard deviation $2.75', true, 'Correct: mean 4 + 2.5(3.2) = 12; SD 2.5(1.1) = 2.75.' from version_ins;
-- APSTATS-MCQ-SV-H-2.9-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.9-A-v3', 'mcq', 'Mean and SD after a linear change Y = aX + b (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random variable X has mean 15 and standard deviation 3. Let Y = 50 − 2X. What are the mean and standard deviation of Y?', null, md5('APSTATS-MCQ-SV-H-2.9-A-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mean 20, standard deviation 6', true, 'Correct: mean 50 − 2(15) = 20; SD |−2|(3) = 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mean 20, standard deviation −6', false, 'A standard deviation cannot be negative; multiplying by −2 multiplies the SD by |−2| = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mean 80, standard deviation 6', false, 'This adds 2(15) to 50 instead of subtracting it; Y = 50 − 2X, so the mean is 50 − 2(15) = 20.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mean 20, standard deviation 3', false, 'Multiplying a random variable by a constant multiplies its standard deviation by that constant, so the SD does not stay unscaled.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.7-A-v3','APSTATS-MCQ-H-2.7-B','APSTATS-MCQ-SV-H-2.7-B-v1','APSTATS-MCQ-SV-H-2.7-B-v2','APSTATS-MCQ-SV-H-2.7-B-v3','APSTATS-MCQ-H-2.9-A','APSTATS-MCQ-SV-H-2.9-A-v1','APSTATS-MCQ-SV-H-2.9-A-v2','APSTATS-MCQ-SV-H-2.9-A-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-2.7-A-v3','APSTATS-MCQ-H-2.7-B','APSTATS-MCQ-SV-H-2.7-B-v1','APSTATS-MCQ-SV-H-2.7-B-v2','APSTATS-MCQ-SV-H-2.7-B-v3','APSTATS-MCQ-H-2.9-A','APSTATS-MCQ-SV-H-2.9-A-v1','APSTATS-MCQ-SV-H-2.9-A-v2','APSTATS-MCQ-SV-H-2.9-A-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
