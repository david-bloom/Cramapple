begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.12-A-v2','APSTATS-MCQ-SV-H-2.12-A-v3','APSTATS-MCQ-H-2.12-B','APSTATS-MCQ-SV-H-2.12-B-v1','APSTATS-MCQ-SV-H-2.12-B-v2','APSTATS-MCQ-SV-H-2.12-B-v3'])) then raise exception 'chunk 11 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-2.12-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.12-A-v2', 'mcq', 'Probability about a sample mean (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population has mean 8.5 and standard deviation 2.4. A random sample of n = 64 is taken. Assuming the conditions are met, what is P(7.9 < x̄ < 9.1)?', null, md5('APSTATS-MCQ-SV-H-2.12-A-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.9545', true, 'Correct: SD of x̄ = 2.4/8 = 0.3; z = ±2; area between = 0.9545.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.9772', false, 'This is P(Z < 2), the area below the upper cutoff only; the question asks for the area between the two cutoffs.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.1974', false, 'This uses σ = 2.4 instead of σ/√n = 0.3, which gives a probability about one individual, not about a sample mean.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.0455', false, 'This is the area outside the two cutoffs, the complement of the area asked about.' from version_ins;
-- APSTATS-MCQ-SV-H-2.12-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.12-A-v3', 'mcq', 'Probability about a sample mean (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population has mean 30 and standard deviation 10. A random sample of n = 100 is taken. Assuming the conditions are met, what is P(x̄ > 31.2)?', null, md5('APSTATS-MCQ-SV-H-2.12-A-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.4522', false, 'This uses σ = 10 instead of σ/√n = 1, which gives a probability about one individual, not about a sample mean.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.8849', false, 'This is the area below 31.2, not above it.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.2301', false, 'This doubles the tail area into a two-sided area, but the question asks for one tail only.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.1151', true, 'Correct: SD of x̄ = 10/10 = 1; z = 1.2; P(Z > 1.2) = 0.1151.' from version_ins;
-- APSTATS-MCQ-H-2.12-B
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.12-B', 'mcq', 'How sample size changes the SD of the sample mean', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population of delivery times has standard deviation 20 minutes. A researcher takes random samples and computes the sample mean. When the sample size is 25, the standard deviation of the sampling distribution of x̄ is 4 minutes. If the sample size is increased to 100, which statement is correct?', null, md5('APSTATS-MCQ-H-2.12-B'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The standard deviation of x̄ decreases from 4 to 2, because it is proportional to 1/√n.', true, 'Correct: the standard deviation of x̄ is σ/√n, so it goes from 20/√25 = 4 to 20/√100 = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The standard deviation of x̄ decreases from 4 to 1, because four times as many observations make it one-fourth as large.', false, 'Quadrupling n halves the standard deviation of x̄ (it depends on √n), it does not quarter it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The standard deviation of x̄ stays at 4, because the population standard deviation is still 20.', false, 'The population standard deviation is unchanged, but the standard deviation of x̄ is σ/√n, which shrinks as n grows.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The standard deviation of x̄ increases, because a larger sample has more observations that can vary.', false, 'Larger samples have less variable means, so the standard deviation of x̄ decreases.' from version_ins;
-- APSTATS-MCQ-SV-H-2.12-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.12-B-v1', 'mcq', 'How sample size changes the SD of the sample mean (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population has standard deviation 18. The standard deviation of x̄ for samples of size 9 is 6. If the sample size is increased to 36, what is the standard deviation of x̄?', null, md5('APSTATS-MCQ-SV-H-2.12-B-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.5', false, 'The standard deviation depends on √n, so quadrupling n halves it; it does not divide it by 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'The standard deviation of the sample mean is σ/√n, so it changes when n changes.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'Correct: the standard deviation of x̄ is σ/√n, so it goes from 18/√9 = 6 to 18/√36 = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '9', false, 'Larger samples give less variable sample means, so the standard deviation decreases rather than increases.' from version_ins;
-- APSTATS-MCQ-SV-H-2.12-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.12-B-v2', 'mcq', 'How sample size changes the SD of the sample mean (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A population has standard deviation 30. With samples of size 16, the standard deviation of x̄ is 7.5. If the sample size is increased to 64, what happens to the standard deviation of x̄?', null, md5('APSTATS-MCQ-SV-H-2.12-B-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It increases to 15.', false, 'Larger samples give less variable sample means, so the standard deviation decreases rather than increases.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It decreases to about 1.9.', false, 'The standard deviation depends on √n, so quadrupling n halves it; it does not divide it by 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It decreases to 3.75.', true, 'Correct: the standard deviation of x̄ is σ/√n, so it goes from 30/√16 = 7.5 to 30/√64 = 3.75.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It stays 7.5.', false, 'The standard deviation of x̄ is σ/√n and shrinks as n grows, so it cannot stay at 7.5.' from version_ins;
-- APSTATS-MCQ-SV-H-2.12-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.12-B-v3', 'mcq', 'How sample size changes the SD of the sample mean (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher wants to reduce the standard deviation of x̄ to one-third of its current value. By what factor must the sample size be multiplied?', null, md5('APSTATS-MCQ-SV-H-2.12-B-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', false, 'This forgets the square root: multiplying n by 3 divides the standard deviation by √3, not by 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'Multiplying n by 6 divides the standard deviation by √6, about 2.45, not by 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '9', true, 'Correct: the standard deviation of x̄ is proportional to 1/√n, so reducing it to one-third requires √n to triple, which means n is multiplied by 9.' from version_ins
union all select gen_random_uuid(), id, 'D', '27', false, 'This multiplies n by 27, which divides the standard deviation by √27 ≈ 5.2, not by 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.12-A-v2','APSTATS-MCQ-SV-H-2.12-A-v3','APSTATS-MCQ-H-2.12-B','APSTATS-MCQ-SV-H-2.12-B-v1','APSTATS-MCQ-SV-H-2.12-B-v2','APSTATS-MCQ-SV-H-2.12-B-v3']) and status='draft')<>6 then raise exception 'chunk 11: expected 6 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-2.12-A-v2','APSTATS-MCQ-SV-H-2.12-A-v3','APSTATS-MCQ-H-2.12-B','APSTATS-MCQ-SV-H-2.12-B-v1','APSTATS-MCQ-SV-H-2.12-B-v2','APSTATS-MCQ-SV-H-2.12-B-v3']))<>24 then raise exception 'chunk 11: expected 24 choices'; end if;
end $$;
commit;
