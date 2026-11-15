begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-2.9-B','APSTATS-MCQ-SV-H-2.9-B-v1','APSTATS-MCQ-SV-H-2.9-B-v2','APSTATS-MCQ-SV-H-2.9-B-v3','APSTATS-MCQ-H-2.10-A','APSTATS-MCQ-SV-H-2.10-A-v1','APSTATS-MCQ-SV-H-2.10-A-v2','APSTATS-MCQ-SV-H-2.10-A-v3','APSTATS-MCQ-H-2.10-B'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- APSTATS-MCQ-H-2.9-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.9-B', 'mcq', 'Expected net gain with a cost', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A charity sells 400 raffle tickets at $10 each. There is one grand prize of $1,000 and three prizes of $200. What is the expected net gain for a person who buys one ticket?', null, md5('APSTATS-MCQ-H-2.9-B'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '$4.00', false, 'This leaves out the $10 ticket price; the expected prize is $4, but the net gain is 4 − 10.' from version_ins
union all select gen_random_uuid(), id, 'B', '−$6.00', true, 'Correct: expected prize = (1,000 + 3 × 200)/400 = 4.00; net = 4.00 − 10 = −6.00.' from version_ins
union all select gen_random_uuid(), id, 'C', '−$7.50', false, 'This counts only the $1,000 grand prize (expected $2.50) and leaves out the three $200 prizes.' from version_ins
union all select gen_random_uuid(), id, 'D', '−$10.00', false, 'This assumes the whole $10 is lost; the prizes return an expected $4 per ticket, so the net is −$6.' from version_ins;
-- APSTATS-MCQ-SV-H-2.9-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.9-B-v1', 'mcq', 'Expected net gain with a cost (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A school fair sells 500 tickets at $4 each. There is one prize of $600 and two prizes of $100. What is the expected net gain for a person who buys one ticket?', null, md5('APSTATS-MCQ-SV-H-2.9-B-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '$1.60', false, 'This leaves out the $4 ticket price; the expected prize is $1.60, but the net gain is 1.60 − 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '−$2.40', true, 'Correct: expected prize (600 + 200)/500 = 1.60; net 1.60 − 4 = −2.40.' from version_ins
union all select gen_random_uuid(), id, 'C', '−$2.80', false, 'This counts only the $600 prize (expected $1.20) and leaves out the two $100 prizes.' from version_ins
union all select gen_random_uuid(), id, 'D', '−$4.00', false, 'Treats the ticket price as simply lost; the winnings reduce that loss.' from version_ins;
-- APSTATS-MCQ-SV-H-2.9-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.9-B-v2', 'mcq', 'Expected net gain with a cost (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A carnival game costs $5 to play. A fair six-sided die is rolled: a 6 pays $12, a 5 pays $6, and any other roll pays $0. What is the expected net gain per play?', null, md5('APSTATS-MCQ-SV-H-2.9-B-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '$3.00', false, 'This leaves out the $5 cost; the expected payout is $3, but the net gain is 3 − 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '−$2.00', true, 'Correct: expected payout 12(1/6) + 6(1/6) = 3.00; net 3.00 − 5 = −2.00.' from version_ins
union all select gen_random_uuid(), id, 'C', '−$3.00', false, 'This counts only the $12 prize (expected $2) and leaves out the $6 prize.' from version_ins
union all select gen_random_uuid(), id, 'D', '−$5.00', false, 'Treats the $5 cost as the net result and ignores the expected $3 payout.' from version_ins;
-- APSTATS-MCQ-SV-H-2.9-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.9-B-v3', 'mcq', 'Expected net gain with a cost (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An insurance company charges a $120 premium. With probability 0.10 it pays a $500 claim, with probability 0.02 it pays a $2,000 claim, and otherwise it pays nothing. What is the company''s expected profit per policy?', null, md5('APSTATS-MCQ-SV-H-2.9-B-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '$90', false, 'This is the company''s expected payout ($90), not its profit; profit is the $120 premium minus the payout.' from version_ins
union all select gen_random_uuid(), id, 'B', '−$30', false, 'This has the sign reversed; the company''s profit is the premium minus the payout, 120 − 90 = $30.' from version_ins
union all select gen_random_uuid(), id, 'C', '$70', false, 'This counts only the $500 claims (expected $50) and leaves out the $2,000 claims.' from version_ins
union all select gen_random_uuid(), id, 'D', '$30', true, 'Correct: expected payout 0.10(500) + 0.02(2,000) = 90; profit 120 − 90 = 30.' from version_ins;
-- APSTATS-MCQ-H-2.10-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.10-A', 'mcq', 'Is sampling without replacement approximately binomial', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a large school of 1,800 students, 10% are left-handed. A teacher randomly selects 25 students, and X is the number who are left-handed. Which statement is correct?', null, md5('APSTATS-MCQ-H-2.10-A'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'X is not binomial, because the students are selected without replacement.', false, 'Sampling without replacement does not make X non-binomial here: a sample of 25 from 1,800 students is small enough that the trials are nearly independent.' from version_ins
union all select gen_random_uuid(), id, 'B', 'X is approximately binomial, because the sample is a small fraction of the school, so the trials are nearly independent with nearly constant P(left-handed).', true, 'Correct: 25 is a small fraction of 1,800, so the selections are nearly independent with P(left-handed) nearly constant at 0.10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X is not binomial, because the probability of being left-handed, 0.10, is too small.', false, 'A binomial setting has no minimum value for p; 0.10 is perfectly acceptable.' from version_ins
union all select gen_random_uuid(), id, 'D', 'X is exactly binomial, because the number of trials is fixed at 25.', false, 'A fixed number of trials is only one condition; the trials must also be independent with a constant probability, which holds only approximately here.' from version_ins;
-- APSTATS-MCQ-SV-H-2.10-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.10-A-v1', 'mcq', 'Is sampling without replacement approximately binomial (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A city has 5,000 registered voters, and 52% favor a ballot measure. A pollster randomly selects 50 voters, and X is the number who favor the measure. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.10-A-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'X is binomial only if the pollster samples with replacement.', false, 'Sampling without replacement from a large population is still approximately binomial; replacement is not required.' from version_ins
union all select gen_random_uuid(), id, 'B', 'X is not binomial, because 0.52 is not equal to 0.50.', false, 'A binomial probability does not need to equal 0.50; any constant p works.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X is approximately binomial, because 50 is a small fraction of 5,000, so the trials are nearly independent with P(favor) nearly constant at 0.52.', true, 'Correct: 50 is a small fraction of 5,000, so the trials are nearly independent with P(favor) nearly constant at 0.52.' from version_ins
union all select gen_random_uuid(), id, 'D', 'X is exactly binomial, because there are only two possible responses.', false, 'Two possible responses is only one of the conditions; the trials must also be independent with constant probability.' from version_ins;
-- APSTATS-MCQ-SV-H-2.10-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.10-A-v2', 'mcq', 'Is sampling without replacement approximately binomial (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A class of 30 students includes 12 who are left-handed. A teacher randomly selects 10 students from the class without replacement, and X is the number who are left-handed. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.10-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'X is binomial, because there are exactly 10 trials with two outcomes each.', false, 'A fixed number of trials with two outcomes is not enough; the trials must also be independent.' from version_ins
union all select gen_random_uuid(), id, 'B', 'X is binomial, because the probability of selecting a left-handed student on the first pick is 12/30 = 0.40.', false, 'The probability on the first pick is 0.40, but it changes after each pick without replacement from a small group.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X is not binomial, because the students can be left-handed or right-handed but not both.', false, 'Having two categories is what a binomial setting requires, so this is not a reason the setting fails.' from version_ins
union all select gen_random_uuid(), id, 'D', 'X is not approximately binomial, because the sample is one-third of the class, so each pick changes the probability for the next.', true, 'Correct: 10 of 30 is a third of the class, so each pick changes the probability for the next and the trials are not approximately independent.' from version_ins;
-- APSTATS-MCQ-SV-H-2.10-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.10-A-v3', 'mcq', 'Is sampling without replacement approximately binomial (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A town has 12,000 residents, and 20% own an electric vehicle. A researcher randomly selects 30 residents, and X is the number who own an electric vehicle. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.10-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'X is not binomial, because sampling without replacement always makes trials dependent.', false, 'Sampling without replacement does not always break independence; with a small sample from a large population it is approximately binomial.' from version_ins
union all select gen_random_uuid(), id, 'B', 'X is exactly binomial, because the number of residents sampled is fixed.', false, 'A fixed number of trials is not enough by itself; independence and constant probability are also needed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X is approximately binomial, because 30 is a small fraction of 12,000, so P(owns an electric vehicle) stays nearly 0.20 on every pick.', true, 'Correct: 30 is a small fraction of 12,000, so P(owns an electric vehicle) stays nearly 0.20 on every pick.' from version_ins
union all select gen_random_uuid(), id, 'D', 'X is binomial only if 30 is at least half the town.', false, 'There is no requirement that the sample be half the town; the opposite, a small sample, is what makes it approximately binomial.' from version_ins;
-- APSTATS-MCQ-H-2.10-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.10-B', 'mcq', 'Cumulative binomial probability (at least k)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Each of 6 independent customers buys an upgrade with probability 0.25. Let X be the number who buy the upgrade. What is P(X ≥ 2)?', null, md5('APSTATS-MCQ-H-2.10-B'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.2966', false, 'This is P(X = 2) only; P(X ≥ 2) also includes 3, 4, 5 and 6 successes.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.8220', false, 'This is P(X ≥ 1) = 1 − P(0); the question asks for at least 2, so P(1) must also be subtracted.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.5339', false, 'This is P(X ≤ 1), the complement of the event asked about.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.4661', true, 'Correct: P(0) = 0.75⁶ = 0.1780; P(1) = 6(0.25)(0.75)⁵ = 0.3560; 1 − 0.1780 − 0.3560 = 0.4661.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-2.9-B','APSTATS-MCQ-SV-H-2.9-B-v1','APSTATS-MCQ-SV-H-2.9-B-v2','APSTATS-MCQ-SV-H-2.9-B-v3','APSTATS-MCQ-H-2.10-A','APSTATS-MCQ-SV-H-2.10-A-v1','APSTATS-MCQ-SV-H-2.10-A-v2','APSTATS-MCQ-SV-H-2.10-A-v3','APSTATS-MCQ-H-2.10-B']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-H-2.9-B','APSTATS-MCQ-SV-H-2.9-B-v1','APSTATS-MCQ-SV-H-2.9-B-v2','APSTATS-MCQ-SV-H-2.9-B-v3','APSTATS-MCQ-H-2.10-A','APSTATS-MCQ-SV-H-2.10-A-v1','APSTATS-MCQ-SV-H-2.10-A-v2','APSTATS-MCQ-SV-H-2.10-A-v3','APSTATS-MCQ-H-2.10-B']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
