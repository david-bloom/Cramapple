begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-2.8-A','APSTATS-MCQ-SV-H-2.8-A-v1','APSTATS-MCQ-SV-H-2.8-A-v2','APSTATS-MCQ-SV-H-2.8-A-v3','APSTATS-MCQ-H-2.8-B','APSTATS-MCQ-SV-H-2.8-B-v1','APSTATS-MCQ-SV-H-2.8-B-v2','APSTATS-MCQ-SV-H-2.8-B-v3','APSTATS-MCQ-H-2.11-A'])) then raise exception 'chunk 9 already loaded'; end if;
end $$;
-- APSTATS-MCQ-H-2.8-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.8-A', 'mcq', 'Find the constant in a distribution, then a probability', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random variable X takes the values 1, 2, 3 and 4 with P(X = x) = kx. What is P(X ≥ 3)?', null, md5('APSTATS-MCQ-H-2.8-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.7', true, 'Correct: k + 2k + 3k + 4k = 10k = 1, so k = 0.1; P(X ≥ 3) = 0.3 + 0.4 = 0.7.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.3', false, 'This is P(X ≤ 2) = 0.1 + 0.2 = 0.3; the question asks for P(X ≥ 3).' from version_ins
union all select gen_random_uuid(), id, 'C', '0.4', false, 'This is P(X = 4) = 0.4 only; P(X ≥ 3) also includes P(X = 3) = 0.3.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.5', false, 'This treats the four values as equally likely, but P(X = x) = kx gives larger values larger probabilities.' from version_ins;
-- APSTATS-MCQ-SV-H-2.8-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.8-A-v1', 'mcq', 'Find the constant in a distribution, then a probability (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random variable X takes the values 0, 1, 2 and 3 with P(X = x) = k(x + 1). What is P(X < 2)?', null, md5('APSTATS-MCQ-SV-H-2.8-A-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.7', false, 'This is P(X ≥ 2) = 0.7, the complement of the event asked about.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.2', false, 'This is P(X = 1) = 0.2 only; P(X < 2) also includes P(X = 0) = 0.1.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.1', false, 'This is P(X = 0) = 0.1 only; P(X < 2) also includes P(X = 1) = 0.2.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.3', true, 'Correct: k + 2k + 3k + 4k = 10k = 1, so k = 0.1; P(X < 2) = 0.1 + 0.2 = 0.3.' from version_ins;
-- APSTATS-MCQ-SV-H-2.8-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.8-A-v2', 'mcq', 'Find the constant in a distribution, then a probability (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random variable X has P(X = 1) = 0.25, P(X = 2) = k, P(X = 3) = 2k, and P(X = 4) = 0.15. What is P(X ≥ 3)?', null, md5('APSTATS-MCQ-SV-H-2.8-A-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.35', false, 'This uses k instead of 2k for P(X = 3); P(X = 3) = 2k = 0.40.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.55', true, 'Correct: 0.25 + 3k + 0.15 = 1, so k = 0.20; P(X ≥ 3) = 0.40 + 0.15 = 0.55.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.45', false, 'This is P(X ≤ 2) = 0.25 + 0.20, the complement of the event asked about.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.40', false, 'This is P(X = 3) = 0.40 only; P(X ≥ 3) also includes P(X = 4) = 0.15.' from version_ins;
-- APSTATS-MCQ-SV-H-2.8-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.8-A-v3', 'mcq', 'Find the constant in a distribution, then a probability (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random variable X takes the values 2, 4, 6 and 8 with probabilities k, 2k, 3k and 4k. What is the mean of X?', null, md5('APSTATS-MCQ-SV-H-2.8-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'This is the simple average of the four values, but the values do not all have the same probability.' from version_ins
union all select gen_random_uuid(), id, 'B', '20', false, 'This is the sum of the values, which ignores the probabilities.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.25', false, 'This is the average of the probabilities, which is not the mean of X.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', true, 'Correct: k = 0.1; mean = 2(0.1) + 4(0.2) + 6(0.3) + 8(0.4) = 6.0.' from version_ins;
-- APSTATS-MCQ-H-2.8-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.8-B', 'mcq', 'Recognize a valid probability distribution', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which table shows a valid probability distribution for a random variable X?', null, md5('APSTATS-MCQ-H-2.8-B'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 0, 1, 2 with P(X = x) = 0.30, 0.50, 0.30', false, 'The probabilities sum to 1.10, so this is not a valid distribution.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 0, 1, 2 with P(X = x) = 0.20, 0.50, 0.30', true, 'Correct: the probabilities sum to 1.00 and every value is between 0 and 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0, 1, 2 with P(X = x) = 0.50, 0.60, −0.10', false, 'The probabilities sum to 1, but a probability cannot be negative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 0, 1, 2 with P(X = x) = 0.20, 0.40, 0.30', false, 'The probabilities sum to 0.90, not 1, so this is not a valid distribution.' from version_ins;
-- APSTATS-MCQ-SV-H-2.8-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.8-B-v1', 'mcq', 'Recognize a valid probability distribution (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which table shows a valid probability distribution for a random variable Y?', null, md5('APSTATS-MCQ-SV-H-2.8-B-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 1, 2, 3, 4 with P(Y = y) = 0.10, 0.25, 0.35, 0.35', false, 'The probabilities sum to 1.05, not 1, so this is not a valid distribution.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 1, 2, 3, 4 with P(Y = y) = 0.10, 0.25, 0.35, 0.30', true, 'Correct: the probabilities sum to 1.00 and every value is between 0 and 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 1, 2, 3, 4 with P(Y = y) = 0.15, 0.25, 0.35, 0.20', false, 'The probabilities sum to 0.95, not 1, so this is not a valid distribution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 1, 2, 3, 4 with P(Y = y) = 1.20, 0.30, −0.30, 0.80', false, 'The probabilities sum to 2.00 and include values outside 0 to 1, so it is not valid.' from version_ins;
-- APSTATS-MCQ-SV-H-2.8-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.8-B-v2', 'mcq', 'Recognize a valid probability distribution (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A table gives P(X = x) for x = 1, 2, 3, 4 as 0.40, 0.30, 0.20, 0.20. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.8-B-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is valid, because every probability is between 0 and 1.', false, 'Each probability being between 0 and 1 is necessary but not sufficient; they must also sum to 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is not valid, because the probabilities sum to 1.10, not 1.', true, 'Correct: 0.40 + 0.30 + 0.20 + 0.20 = 1.10, which is more than 1, so it is not valid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is valid, because the values of x are whole numbers.', false, 'Whole-number x values are irrelevant to whether the probabilities form a valid distribution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is not valid, because the first probability is greater than the others.', false, 'A probability being larger than the others is not a problem; the problem is the total of 1.10.' from version_ins;
-- APSTATS-MCQ-SV-H-2.8-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.8-B-v3', 'mcq', 'Recognize a valid probability distribution (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A table lists P(X = x) for x = 0, 1, 2, 3 as 0.15, 0.35, 0.30, 0.20. Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.8-B-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is not valid, because the probabilities are not all equal.', false, 'Probabilities do not have to be equal; a distribution only needs each value between 0 and 1 and a total of 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is not valid, because the probabilities do not decrease as x increases.', false, 'Probabilities need not decrease as x increases.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is not valid, because the mean of the probabilities is not 1.', false, 'The mean of the probabilities is not a validity condition; the probabilities themselves must sum to 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is valid, because every probability is between 0 and 1 and the probabilities sum to 1.', true, 'Correct: every probability is between 0 and 1 and 0.15 + 0.35 + 0.30 + 0.20 = 1.00.' from version_ins;
-- APSTATS-MCQ-H-2.11-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.11-A', 'mcq', 'Percentile cutoff from a normal distribution', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Heights of adult women in a region are approximately normal with mean 64 inches and standard deviation 3 inches. A clothing company wants to design a size that is at least as long as 90% of women are tall. About how tall is a woman at the 90th percentile?', null, md5('APSTATS-MCQ-H-2.11-A'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60.2 inches', false, 'This is the 10th percentile (z = −1.28), not the 90th.' from version_ins
union all select gen_random_uuid(), id, 'B', '67.8 inches', true, 'Correct: z = 1.2816; 64 + 1.2816(3) ≈ 67.84.' from version_ins
union all select gen_random_uuid(), id, 'C', '66.7 inches', false, 'This uses 0.90 as the z-score; the z-score for the 90th percentile is about 1.28, not 0.90.' from version_ins
union all select gen_random_uuid(), id, 'D', '68.9 inches', false, 'This uses z = 1.645, which is the 95th percentile, not the 90th.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-H-2.8-A','APSTATS-MCQ-SV-H-2.8-A-v1','APSTATS-MCQ-SV-H-2.8-A-v2','APSTATS-MCQ-SV-H-2.8-A-v3','APSTATS-MCQ-H-2.8-B','APSTATS-MCQ-SV-H-2.8-B-v1','APSTATS-MCQ-SV-H-2.8-B-v2','APSTATS-MCQ-SV-H-2.8-B-v3','APSTATS-MCQ-H-2.11-A']) and status='draft')<>9 then raise exception 'chunk 9: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-H-2.8-A','APSTATS-MCQ-SV-H-2.8-A-v1','APSTATS-MCQ-SV-H-2.8-A-v2','APSTATS-MCQ-SV-H-2.8-A-v3','APSTATS-MCQ-H-2.8-B','APSTATS-MCQ-SV-H-2.8-B-v1','APSTATS-MCQ-SV-H-2.8-B-v2','APSTATS-MCQ-SV-H-2.8-B-v3','APSTATS-MCQ-H-2.11-A']))<>36 then raise exception 'chunk 9: expected 36 choices'; end if;
end $$;
commit;
