begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.11-A-v1','APSTATS-MCQ-SV-H-2.11-A-v2','APSTATS-MCQ-SV-H-2.11-A-v3','APSTATS-MCQ-H-2.11-B','APSTATS-MCQ-SV-H-2.11-B-v1','APSTATS-MCQ-SV-H-2.11-B-v2','APSTATS-MCQ-SV-H-2.11-B-v3','APSTATS-MCQ-H-2.12-A','APSTATS-MCQ-SV-H-2.12-A-v1'])) then raise exception 'chunk 10 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-2.11-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.11-A-v1', 'mcq', 'Percentile cutoff from a normal distribution (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Scores on a placement exam are approximately normal with mean 500 and standard deviation 100. A scholarship goes to students at or above the 75th percentile. About what score is needed?', null, md5('APSTATS-MCQ-SV-H-2.11-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '567.4', true, 'Correct: z = 0.6745; 500 + 67.45 ≈ 567.4.' from version_ins
union all select gen_random_uuid(), id, 'B', '432.6', false, 'This is the 25th percentile (z = −0.67), not the 75th.' from version_ins
union all select gen_random_uuid(), id, 'C', '575.0', false, 'This uses 0.75 as the z-score; the z-score for the 75th percentile is about 0.67, not 0.75.' from version_ins
union all select gen_random_uuid(), id, 'D', '664.5', false, 'This uses z = 1.645, which is the 95th percentile, not the 75th.' from version_ins;
-- APSTATS-MCQ-SV-H-2.11-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.11-A-v2', 'mcq', 'Percentile cutoff from a normal distribution (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Birth weights of a species of puppy are approximately normal with mean 120 ounces and standard deviation 15 ounces. A vet flags the lightest 5% for extra monitoring. About what weight is the cutoff?', null, md5('APSTATS-MCQ-SV-H-2.11-A-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '144.7 ounces', false, 'This is the 95th percentile (z = +1.645), but the question asks for the lowest 5%.' from version_ins
union all select gen_random_uuid(), id, 'B', '95.3 ounces', true, 'Correct: z = −1.645; 120 − 1.645(15) ≈ 95.3.' from version_ins
union all select gen_random_uuid(), id, 'C', '105.0 ounces', false, 'This uses z = −1, which is about the 16th percentile, not the 5th.' from version_ins
union all select gen_random_uuid(), id, 'D', '100.8 ounces', false, 'This uses z = −1.28, which is the 10th percentile, not the 5th.' from version_ins;
-- APSTATS-MCQ-SV-H-2.11-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.11-A-v3', 'mcq', 'Percentile cutoff from a normal distribution (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Reaction times in a game are approximately normal with mean 0.25 seconds and standard deviation 0.04 seconds. A trainer wants the cutoff for the slowest 10% of times. About what time is the cutoff?', null, md5('APSTATS-MCQ-SV-H-2.11-A-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.199 seconds', false, 'This is the cutoff for the fastest 10% (z = −1.28), not the slowest 10%.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.301 seconds', true, 'Correct: z = 1.2816; 0.25 + 1.2816(0.04) ≈ 0.301.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.254 seconds', false, 'This uses 0.1 as the z-score; the z-score for the 90th percentile is about 1.28.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.316 seconds', false, 'This uses z = 1.645, which is the 95th percentile, not the 90th.' from version_ins;
-- APSTATS-MCQ-H-2.11-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.11-B', 'mcq', 'Find the mean from a percentile', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A machine fills bags with a weight that is approximately normal with a standard deviation of 10 grams. The weight is below 40 grams in 20% of bags. What is the mean weight?', null, md5('APSTATS-MCQ-H-2.11-B'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '31.6 grams', false, 'This subtracts the z-score offset; 40 is below the mean (20% of bags are lighter), so the mean must be above 40.' from version_ins
union all select gen_random_uuid(), id, 'B', '48.4 grams', true, 'Correct: z for the 20th percentile = −0.8416; 40 = μ − 0.8416(10), so μ ≈ 48.4.' from version_ins
union all select gen_random_uuid(), id, 'C', '42.0 grams', false, 'This uses 0.2 as the z-score; the z-score for the 20th percentile is about −0.84.' from version_ins
union all select gen_random_uuid(), id, 'D', '52.8 grams', false, 'This uses z = 1.28, which belongs to the 90th percentile, not the 20th.' from version_ins;
-- APSTATS-MCQ-SV-H-2.11-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.11-B-v1', 'mcq', 'Find the mean from a percentile (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Test scores are approximately normal with a standard deviation of 8. Exactly 25% of scores are below 60. What is the mean?', null, md5('APSTATS-MCQ-SV-H-2.11-B-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '54.6', false, 'This subtracts the z-score offset; 60 is below the mean (25% of scores are lower), so the mean must be above 60.' from version_ins
union all select gen_random_uuid(), id, 'B', '62.0', false, 'This uses 0.25 as the z-score; the z-score for the 25th percentile is about −0.67.' from version_ins
union all select gen_random_uuid(), id, 'C', '70.3', false, 'This uses z = 1.28, which belongs to the 90th percentile, not the 25th.' from version_ins
union all select gen_random_uuid(), id, 'D', '65.4', true, 'Correct: z = −0.6745; μ = 60 + 0.6745(8) ≈ 65.4.' from version_ins;
-- APSTATS-MCQ-SV-H-2.11-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.11-B-v2', 'mcq', 'Find the mean from a percentile (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The lengths of a part are approximately normal with a standard deviation of 4 mm. Exactly 10% of parts are longer than 50 mm. What is the mean length?', null, md5('APSTATS-MCQ-SV-H-2.11-B-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '55.1 mm', false, 'This adds the z-score offset; 50 is above the mean (10% of parts are longer), so the mean must be below 50.' from version_ins
union all select gen_random_uuid(), id, 'B', '49.6 mm', false, 'This uses 0.1 as the z-score; the z-score for the top 10% is about 1.28.' from version_ins
union all select gen_random_uuid(), id, 'C', '43.4 mm', false, 'This uses z = 1.645, which cuts off the top 5%, not the top 10%.' from version_ins
union all select gen_random_uuid(), id, 'D', '44.9 mm', true, 'Correct: z = +1.2816 above the mean; 50 = μ + 1.2816(4), so μ ≈ 44.9.' from version_ins;
-- APSTATS-MCQ-SV-H-2.11-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.11-B-v3', 'mcq', 'Find the mean from a percentile (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Commute times are approximately normal with a standard deviation of 15 minutes. About 30% of commutes are shorter than 100 minutes. What is the mean commute time?', null, md5('APSTATS-MCQ-SV-H-2.11-B-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '107.9 minutes', true, 'Correct: z = −0.5244; μ = 100 + 0.5244(15) ≈ 107.9.' from version_ins
union all select gen_random_uuid(), id, 'B', '92.1 minutes', false, 'This subtracts the z-score offset; 100 is below the mean (30% of commutes are shorter), so the mean must be above 100.' from version_ins
union all select gen_random_uuid(), id, 'C', '104.5 minutes', false, 'This uses 0.3 as the z-score; the z-score for the 30th percentile is about −0.52.' from version_ins
union all select gen_random_uuid(), id, 'D', '112.6 minutes', false, 'This uses z = 0.84, which belongs to the 80th percentile, not the 30th.' from version_ins;
-- APSTATS-MCQ-H-2.12-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.12-A', 'mcq', 'Probability about a sample mean', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population has mean 50 and standard deviation 12. A random sample of n = 36 is taken, and x̄ is the sample mean. Assuming the conditions for the Central Limit Theorem are met, what is P(x̄ > 53)?', null, md5('APSTATS-MCQ-H-2.12-A'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.4013', false, 'This uses σ = 12 instead of σ/√n = 2, which gives a probability about one individual, not about a sample mean.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.9332', false, 'This is P(Z < 1.5), the area below the cutoff; the question asks for the area above it.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.1336', false, 'This doubles the tail area into a two-sided area, but the question asks for one tail only.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.0668', true, 'Correct: SD of x̄ = 12/√36 = 2; z = (53 − 50)/2 = 1.5; P(Z > 1.5) = 0.0668.' from version_ins;
-- APSTATS-MCQ-SV-H-2.12-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.12-A-v1', 'mcq', 'Probability about a sample mean (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population has mean 100 and standard deviation 15. A random sample of n = 25 is taken. Assuming the conditions are met, what is P(x̄ < 94)?', null, md5('APSTATS-MCQ-SV-H-2.12-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0228', true, 'Correct: SD of x̄ = 15/5 = 3; z = −2; P = 0.0228.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.3446', false, 'This uses σ = 15 instead of σ/√n = 3, which gives a probability about one individual, not about a sample mean.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.9772', false, 'This is the area above 94, not below it.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.0455', false, 'This doubles the tail area into a two-sided area, but the question asks for one tail only.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.11-A-v1','APSTATS-MCQ-SV-H-2.11-A-v2','APSTATS-MCQ-SV-H-2.11-A-v3','APSTATS-MCQ-H-2.11-B','APSTATS-MCQ-SV-H-2.11-B-v1','APSTATS-MCQ-SV-H-2.11-B-v2','APSTATS-MCQ-SV-H-2.11-B-v3','APSTATS-MCQ-H-2.12-A','APSTATS-MCQ-SV-H-2.12-A-v1']) and status='draft')<>9 then raise exception 'chunk 10: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-2.11-A-v1','APSTATS-MCQ-SV-H-2.11-A-v2','APSTATS-MCQ-SV-H-2.11-A-v3','APSTATS-MCQ-H-2.11-B','APSTATS-MCQ-SV-H-2.11-B-v1','APSTATS-MCQ-SV-H-2.11-B-v2','APSTATS-MCQ-SV-H-2.11-B-v3','APSTATS-MCQ-H-2.12-A','APSTATS-MCQ-SV-H-2.12-A-v1']))<>36 then raise exception 'chunk 10: expected 36 choices'; end if;
end $$;
commit;
