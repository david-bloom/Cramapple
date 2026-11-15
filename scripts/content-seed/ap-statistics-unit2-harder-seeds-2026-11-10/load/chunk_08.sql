begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.2-B-v3','APSTATS-MCQ-H-2.3-A','APSTATS-MCQ-SV-H-2.3-A-v1','APSTATS-MCQ-SV-H-2.3-A-v2','APSTATS-MCQ-SV-H-2.3-A-v3','APSTATS-MCQ-H-2.3-B','APSTATS-MCQ-SV-H-2.3-B-v1','APSTATS-MCQ-SV-H-2.3-B-v2','APSTATS-MCQ-SV-H-2.3-B-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-2.2-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.2-B-v3', 'mcq', 'Conditional probability from joint proportions (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A library asked members whether they use e-books (A) and whether they attend events (B). Proportions of all members: A and B 0.18; A only 0.12; B only 0.32; neither 0.38. Among members who attend events, what proportion use e-books?', null, md5('APSTATS-MCQ-SV-H-2.2-B-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.36', true, 'Correct: P(attends events) = 0.18 + 0.32 = 0.50, so P(uses e-books | attends events) = 0.18/0.50 = 0.36.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.18', false, 'This is the joint proportion of the whole group for both categories, not the proportion within the group the question names.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.30', false, 'This is P(uses e-books), the overall proportion, not the proportion among members who attend events.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.60', false, 'This is P(attends events | uses e-books) = 0.18/0.30, the reverse of what the question asks.' from version_ins;
-- APSTATS-MCQ-H-2.3-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.3-A', 'mcq', 'Simulation design: waiting for the first success', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cereal company puts a prize in 25% of its boxes, randomly and independently. A student plans to use a table of random digits to estimate the probability that it takes at least 4 boxes to get the first prize. Which simulation design is valid?', null, md5('APSTATS-MCQ-H-2.3-A'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Let digits 0, 1 and 2 represent a prize. Read single digits until a prize appears, record the number of digits read, and repeat many times.', false, 'Three of the ten digits is 30%, not 25%, so the simulated prize rate is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Let two-digit numbers 01 to 25 represent a prize. One trial is reading two-digit numbers until a prize appears, recording the number of boxes; repeat many times and find the proportion of trials needing at least 4 boxes.', true, 'Correct: 01 to 25 is exactly 25 of the 100 two-digit numbers, and a trial reads numbers until the first prize, so repeating many trials estimates the proportion needing at least 4 boxes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Let two-digit numbers 01 to 25 represent a prize. One trial is a single two-digit number. Do the trial 4 times and record the proportion of prizes.', false, 'This estimates the proportion of boxes with a prize (about 25%), not the probability that it takes at least 4 boxes to get the first one.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Let two-digit numbers 01 to 25 represent a prize. One trial is four two-digit numbers; record whether none of them is a prize; repeat many times.', false, 'Recording "no prize in four boxes" estimates the chance of needing at least 5 boxes, not at least 4.' from version_ins;
-- APSTATS-MCQ-SV-H-2.3-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.3-A-v1', 'mcq', 'Simulation design: waiting for the first success (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scratch-off game wins on 20% of tickets, randomly and independently. A student wants to estimate the probability that it takes at least 3 tickets to get the first winner, using random digits. Which design is valid?', null, md5('APSTATS-MCQ-SV-H-2.3-A-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Let digits 0, 1 and 2 represent a winner. Read digits until a winner appears, record the count, repeat many times.', false, 'Digits 0, 1 and 2 are 30% of the digits, not the stated 20%.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Let digits 0 and 1 represent a winner. One trial is three digits; record whether none is a winner; repeat many times.', false, 'Recording "no winner in three tickets" estimates the chance of needing at least 4 tickets, not at least 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Let digits 0 and 1 represent a winner. One trial is reading digits until a winner appears, recording the count; repeat many times and find the proportion of trials needing at least 3 tickets.', true, 'Correct: digits 0 and 1 give exactly 20%, and a trial reads digits until the first winner, so repeating many trials estimates the proportion needing at least 3 tickets.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Let digits 0 and 1 represent a winner. One trial is a single digit; repeat 3 times and record the proportion of winners.', false, 'This estimates the proportion of tickets that win (about 20%), not the probability that it takes at least 3 tickets to get the first winner.' from version_ins;
-- APSTATS-MCQ-SV-H-2.3-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.3-A-v2', 'mcq', 'Simulation design: waiting for the first success (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A basketball player makes 40% of her shots, independently. A student wants to estimate the probability that she makes exactly 2 of her next 5 shots, using random digits. Which design is valid?', null, md5('APSTATS-MCQ-SV-H-2.3-A-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Let digits 0 to 3 represent a made shot. One trial is five digits; record whether exactly 2 are made; repeat many times.', true, 'Correct: digits 0 to 3 give exactly 40%, and a trial of five digits records whether exactly 2 are made; repeating many trials estimates the probability.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Let digits 0 to 4 represent a made shot. One trial is five digits; record whether exactly 2 are made; repeat many times.', false, 'Digits 0 to 4 are 50% of the digits, not the stated 40%.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Let digits 0 to 3 represent a made shot. One trial is two digits; record whether both are made; repeat many times.', false, 'This simulates two shots and asks for both, but the question is about exactly 2 of 5 shots.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Let digits 0 to 3 represent a made shot. One trial is five digits; record whether at least 2 are made; repeat many times.', false, 'This records at least 2 made shots, but the question asks for exactly 2.' from version_ins;
-- APSTATS-MCQ-SV-H-2.3-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.3-A-v3', 'mcq', 'Simulation design: waiting for the first success (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The chance of rain on any day in a region is 35%, independently from day to day. A student wants to estimate the probability that it rains on exactly 2 of the next 3 days, using random digits. Which design is valid?', null, md5('APSTATS-MCQ-SV-H-2.3-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Let digits 0 to 3 represent rain. One trial is three digits; record whether exactly 2 are rain; repeat many times.', false, 'Digits 0 to 3 are 40% of the digits, not the stated 35%.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Let two-digit numbers 00 to 34 represent rain. One trial is two numbers; record whether both are rain; repeat many times.', false, 'This simulates two days, but the question is about the next 3 days.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Let two-digit numbers 00 to 34 represent rain. One trial is three numbers; record whether at least 2 are rain; repeat many times.', false, 'This records at least 2 rainy days, but the question asks for exactly 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Let two-digit numbers 00 to 34 represent rain. One trial is three numbers; record whether exactly 2 are rain; repeat many times.', true, 'Correct: 00 to 34 is exactly 35 of the 100 two-digit numbers, and a trial of three numbers records whether exactly 2 are rain; repeating many trials estimates the probability.' from version_ins;
-- APSTATS-MCQ-H-2.3-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.3-B', 'mcq', 'Estimate and reliability from simulation results', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student simulates flipping a fair coin 5 times and records the number of heads, repeating this for 100 trials.
Heads = 0: 3 trials
Heads = 1: 15 trials
Heads = 2: 32 trials
Heads = 3: 30 trials
Heads = 4: 16 trials
Heads = 5: 4 trials
Based on this simulation, what is the estimated probability of at least 4 heads, and which statement about it is best?', null, md5('APSTATS-MCQ-H-2.3-B'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.20; it is the exact probability, because 100 trials were used.', false, 'Simulation results are estimates, not exact probabilities, regardless of how many trials are run.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.16; it is an estimate that would change in a new simulation, and more trials would make it more reliable.', false, 'This is the estimate for exactly 4 heads (16/100), not for at least 4 heads, which also includes 5 heads.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.20; it is an estimate that would change in a new simulation, and more trials would make it more reliable.', true, 'Correct: (16 + 4)/100 = 0.20; a simulation gives an estimate that changes from run to run and becomes more reliable with more trials.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.20; it is an estimate, and fewer trials would make it more reliable.', false, 'Fewer trials make an estimate less reliable, not more.' from version_ins;
-- APSTATS-MCQ-SV-H-2.3-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.3-B-v1', 'mcq', 'Estimate and reliability from simulation results (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student simulates a basketball player who makes 70% of her shots, taking 4 shots per trial, for 200 trials.
Shots made = 0: 2 trials
Shots made = 1: 18 trials
Shots made = 2: 50 trials
Shots made = 3: 80 trials
Shots made = 4: 50 trials
What is the estimated probability that she makes at least 3 of 4 shots, and which statement is best?', null, md5('APSTATS-MCQ-SV-H-2.3-B-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.65; it is an estimate that would change in a new simulation, and more trials would make it more reliable.', true, 'Correct: (80 + 50)/200 = 0.65; a simulation gives an estimate that changes from run to run and becomes more reliable with more trials.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.40; it is an estimate that would change in a new simulation, and more trials would make it more reliable.', false, 'This is the estimate for exactly 3 made shots (80/200); at least 3 also includes 4 made shots.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.65; it is the exact probability, because the player''s 70% rate is known.', false, 'A simulation result is an estimate even when the true shooting percentage is known.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.65; it is an estimate, and fewer trials would make it more reliable.', false, 'Fewer trials make an estimate less reliable, not more.' from version_ins;
-- APSTATS-MCQ-SV-H-2.3-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.3-B-v2', 'mcq', 'Estimate and reliability from simulation results (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student simulates choosing 3 bulbs at random from a large shipment and records how many are defective, for 50 trials.
Defective bulbs = 0: 30 trials
Defective bulbs = 1: 15 trials
Defective bulbs = 2: 4 trials
Defective bulbs = 3: 1 trials
What is the estimated probability that at least one chosen bulb is defective, and which statement is best?', null, md5('APSTATS-MCQ-SV-H-2.3-B-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.30; it is an estimate that would change in a new simulation, and more trials would make it more reliable.', false, 'This is the estimate for exactly one defective bulb (15/50); at least one also includes 2 and 3 defective bulbs.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.40; it is the exact probability, because all 50 trials are counted.', false, 'Counting every trial does not make a simulation result exact; it is still an estimate.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.40; it is an estimate, and fewer trials would make it more reliable.', false, 'Fewer trials make an estimate less reliable, not more.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.40; it is an estimate that would change in a new simulation, and more trials would make it more reliable.', true, 'Correct: (15 + 4 + 1)/50 = 0.40; a simulation gives an estimate that changes from run to run and becomes more reliable with more trials.' from version_ins;
-- APSTATS-MCQ-SV-H-2.3-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.3-B-v3', 'mcq', 'Estimate and reliability from simulation results (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student simulates families with 4 children, recording the number of boys, for 250 trials.
Boys = 0: 14 trials
Boys = 1: 63 trials
Boys = 2: 92 trials
Boys = 3: 61 trials
Boys = 4: 20 trials
What is the estimated probability of at least 3 boys, and which statement is best?', null, md5('APSTATS-MCQ-SV-H-2.3-B-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.368; it is an estimate that would change in a new simulation, and more trials would make it more reliable.', false, 'This is the estimate for exactly 2 boys (92/250), not for at least 3 boys.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.324; it is an estimate that would change in a new simulation, and more trials would make it more reliable.', true, 'Correct: (61 + 20)/250 = 0.324; a simulation gives an estimate that changes from run to run and becomes more reliable with more trials.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.324; it is the exact probability, because 250 trials is a large number.', false, 'A large number of trials improves reliability but does not make the result exact.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.324; it is an estimate, and fewer trials would make it more reliable.', false, 'Fewer trials make an estimate less reliable, not more.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.2-B-v3','APSTATS-MCQ-H-2.3-A','APSTATS-MCQ-SV-H-2.3-A-v1','APSTATS-MCQ-SV-H-2.3-A-v2','APSTATS-MCQ-SV-H-2.3-A-v3','APSTATS-MCQ-H-2.3-B','APSTATS-MCQ-SV-H-2.3-B-v1','APSTATS-MCQ-SV-H-2.3-B-v2','APSTATS-MCQ-SV-H-2.3-B-v3']) and status='draft')<>9 then raise exception 'chunk 8: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-2.2-B-v3','APSTATS-MCQ-H-2.3-A','APSTATS-MCQ-SV-H-2.3-A-v1','APSTATS-MCQ-SV-H-2.3-A-v2','APSTATS-MCQ-SV-H-2.3-A-v3','APSTATS-MCQ-H-2.3-B','APSTATS-MCQ-SV-H-2.3-B-v1','APSTATS-MCQ-SV-H-2.3-B-v2','APSTATS-MCQ-SV-H-2.3-B-v3']))<>36 then raise exception 'chunk 8: expected 36 choices'; end if;
end $$;
commit;
