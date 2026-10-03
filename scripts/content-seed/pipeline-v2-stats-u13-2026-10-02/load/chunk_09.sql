begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-054-v2','APSTATS-MCQ-SV-054-v3','APSTATS-MCQ-SV-060-v1','APSTATS-MCQ-SV-060-v2','APSTATS-MCQ-SV-060-v3','APSTATS-MCQ-SV-067-v1','APSTATS-MCQ-SV-067-v2','APSTATS-MCQ-SV-067-v3','APSTATS-MCQ-SV-078-v1','APSTATS-MCQ-SV-078-v2','APSTATS-MCQ-SV-078-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-054-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-054-v2', 'mcq', 'Union with larger probabilities', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For two events A and B, P(A) = 0.70, P(B) = 0.40, and P(A and B) = 0.35. What is P(A or B)?', null, md5('APSTATS-MCQ-SV-054-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.75', true, 'Using the addition rule, 0.70 + 0.40 − 0.35 = 0.75.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.35', false, 'This is only P(A and B), the intersection.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.28', false, 'This is 0.70 × 0.40, the probability of both under independence, not the probability of either.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.10', false, 'This adds the two probabilities without subtracting the overlap; a probability cannot exceed 1.' from version_ins;
-- APSTATS-MCQ-SV-054-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-054-v3', 'mcq', 'Laptop or tablet ownership counts', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Among 80 students surveyed, 50 own a laptop, 30 own a tablet, and 15 own both. What is the probability that a randomly selected student from this group owns a laptop or a tablet?', null, md5('APSTATS-MCQ-SV-054-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '80/80 = 1.0', false, 'This adds 50 and 30 without subtracting the 15 who own both, which would imply every student owns at least one device.' from version_ins
union all select gen_random_uuid(), id, 'B', '(50/80)(30/80) ≈ 0.234', false, 'This multiplies the individual probabilities, which would be the probability of both under independence, not the union.' from version_ins
union all select gen_random_uuid(), id, 'C', '15/80 = 0.1875', false, 'This is only the probability of owning both, the intersection.' from version_ins
union all select gen_random_uuid(), id, 'D', '65/80 = 0.8125', true, 'The number owning at least one is 50 + 30 − 15 = 65, so the probability is 65/80 = 0.8125.' from version_ins;
-- APSTATS-MCQ-SV-060-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-060-v1', 'mcq', 'Thermometer systematic error', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A new thermometer is tested thousands of times on liquids with known temperatures. Its readings are tightly clustered, but they average 2.3 degrees above the true temperature no matter how many readings are averaged. What is the main problem?', null, md5('APSTATS-MCQ-SV-060-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The estimator has high variability, since its readings are not equal to the true temperature.', false, 'Variability is the spread of readings; the stem says they are tightly clustered, so the problem is the off-center location, not scatter.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The readings are not independent, since each is above the true temperature.', false, 'Dependence between readings is not described; a consistent upward shift is a systematic error in the estimator, which is bias.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sample sizes are too small, since averaging more readings would remove the error.', false, 'The stem says the error remains no matter how many readings are averaged; more data cannot fix a systematic offset.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The estimator is biased, since its readings are centered above the true value.', true, 'An estimator whose values are systematically off target in one direction, even in the long run, is biased; here the center is about 2.3 degrees too high.' from version_ins;
-- APSTATS-MCQ-SV-060-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-060-v2', 'mcq', 'Biased but precise estimator', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In repeated random samples of size 100 from a population with true mean 50, a new estimator has a sampling distribution centered at 56 with a standard deviation of 1.5. Which statement best describes this estimator?', null, md5('APSTATS-MCQ-SV-060-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is unbiased with low variability, because its standard deviation is small.', false, 'A small standard deviation shows low variability only; unbiasedness requires the center to equal 50, and this one is centered at 56.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is biased with high variability, since its values are far from 50.', false, 'Being far from 50 is explained by the bias of about 6 units; the standard deviation of 1.5 shows the values are not widely scattered.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is unbiased but has high variability, since it often misses 50.', false, 'It misses 50 because its center is 56, which is bias; and a standard deviation of 1.5 is small, not large.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is biased but has low variability: its values cluster near 56 instead of 50.', true, 'The center of the sampling distribution, 56, is not the true value of 50, so it is biased; a standard deviation of 1.5 shows its values are tightly clustered.' from version_ins;
-- APSTATS-MCQ-SV-060-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-060-v3', 'mcq', 'Unbiased but variable estimator', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A statistician simulates 2,000 random samples to estimate a true proportion of 0.40. The 2,000 sample proportions average exactly 0.40, but individual values range from 0.25 to 0.55. Which statement is correct?', null, md5('APSTATS-MCQ-SV-060-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The estimator is unbiased but has high variability: its average is 0.40, yet single estimates are widely spread.', true, 'The sampling distribution is centered at the true value of 0.40, so there is no bias, but the wide range from 0.25 to 0.55 shows high variability.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The estimator is unbiased, so increasing the sample size cannot reduce how widely the estimates vary.', false, 'Increasing the sample size reduces the standard error, so larger samples would make the estimates cluster more tightly around 0.40.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The estimator is biased, because many individual estimates differ from the true proportion of 0.40.', false, 'Bias refers to the center of the sampling distribution, which is exactly 0.40; individual estimates differing from 0.40 reflects variability.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The estimator is unbiased with low variability, because its average equals 0.40.', false, 'The average only shows the center; the estimates range from 0.25 to 0.55, which is a wide spread, so variability is high.' from version_ins;
-- APSTATS-MCQ-SV-067-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-067-v1', 'mcq', 'Public transit hypotheses (left-tailed)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a random sample of 250 adults, 105 say they use public transit weekly. A researcher wants to know whether the proportion of all adults who use public transit weekly is less than 0.45. Which hypotheses should be tested?', null, md5('APSTATS-MCQ-SV-067-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H₀: p = 0.45, Hₐ: p < 0.45', true, 'The claim is that the population proportion is less than 0.45, so the null sets p equal to 0.45 and the alternative is left-tailed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H₀: p̂ = 0.45, Hₐ: p̂ < 0.45', false, 'Hypotheses are about the population parameter p, not the sample statistic p̂.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H₀: p = 0.45, Hₐ: p > 0.45', false, 'This is right-tailed, but the question asks whether the proportion is less than 0.45.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H₀: p = 0.45, Hₐ: p < 0.42', false, 'Hypotheses use the claimed value, not the sample proportion 105/250 = 0.42.' from version_ins;
-- APSTATS-MCQ-SV-067-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-067-v2', 'mcq', 'Chip defect rate two-sided hypotheses', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A manufacturer says 10% of its chips are defective. In a random sample of 300 chips, 45 are defective. A quality inspector wants to know whether the true defect rate differs from 10%. Which hypotheses are correct?', null, md5('APSTATS-MCQ-SV-067-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H₀: p = 0.15, Hₐ: p ≠ 0.15', false, '0.15 is the sample proportion 45/300; hypotheses use the claimed parameter value of 0.10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H₀: p = 0.10, Hₐ: p > 0.10', false, 'Although the sample proportion is above 0.10, the question asks about a difference in either direction, so a one-sided alternative does not match.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H₀: p = 0.10, Hₐ: p ≠ 0.10', true, 'The question asks whether the rate differs from 10% in either direction, so the null is p = 0.10 and the alternative is two-sided.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H₀: p ≠ 0.10, Hₐ: p = 0.10', false, 'The null and alternative are reversed; the null must contain the equality.' from version_ins;
-- APSTATS-MCQ-SV-067-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-067-v3', 'mcq', 'Candidate support right-tailed', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A candidate needs more than 40% of voters to win. In a random sample of 80 voters, 38 support the candidate. The campaign wants to test whether the proportion of all voters supporting the candidate exceeds 40%. Which hypotheses are correct?', null, md5('APSTATS-MCQ-SV-067-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H₀: p = 0.40, Hₐ: p > 0.40', true, 'The claim is that support exceeds 40%, so the alternative is right-tailed and the null sets p equal to 0.40.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H₀: p = 0.40, Hₐ: p = 0.475', false, 'The alternative should describe a range, here p > 0.40, not a single value taken from the sample.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H₀: p̂ = 0.475, Hₐ: p̂ > 0.475', false, 'Hypotheses concern the population parameter p and its claimed value of 0.40, not the sample proportion 38/80 = 0.475.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H₀: p ≥ 0.40, Hₐ: p < 0.40', false, 'This tests the opposite direction; the campaign wants evidence that support is greater than 0.40.' from version_ins;
-- APSTATS-MCQ-SV-078-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-078-v1', 'mcq', 'Free throws zero successes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A basketball player makes each free throw independently with probability 0.3. Let X be the number of free throws made in 4 attempts. What is P(X = 0)?', null, md5('APSTATS-MCQ-SV-078-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.7', false, 'This is the probability of missing a single shot, not of missing all 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.2401', true, 'X is binomial with n = 4 and p = 0.3, so P(X = 0) = (0.7)^4 = 0.2401.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.0081', false, 'This is (0.3)^4, the probability that all 4 shots are made, using p instead of 1 − p.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.7599', false, 'This is P(X ≥ 1) = 1 − 0.2401, the probability of at least one made shot.' from version_ins;
-- APSTATS-MCQ-SV-078-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-078-v2', 'mcq', 'Seeds that fail to sprout', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Each seed in a packet of 6 sprouts independently with probability 0.2. Let X be the number of seeds that sprout. What is P(X = 0)?', null, md5('APSTATS-MCQ-SV-078-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.2621', true, 'X is binomial with n = 6 and p = 0.2, so P(X = 0) = (0.8)^6 ≈ 0.2621.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.7379', false, 'This is P(X ≥ 1) = 1 − 0.2621, the probability that at least one seed sprouts.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.8', false, 'This is the probability a single seed fails to sprout, not that all 6 fail.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.0001', false, 'This is (0.2)^6 ≈ 0.000064, the probability that all 6 sprout, using p instead of 1 − p.' from version_ins;
-- APSTATS-MCQ-SV-078-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-078-v3', 'mcq', 'Survey calls with no answers', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pollster makes 8 independent phone calls. Each call is answered with probability 0.35. Let X be the number of calls that are answered. What is P(X = 0)?', null, md5('APSTATS-MCQ-SV-078-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0319', true, 'X is binomial with n = 8 and p = 0.35, so P(X = 0) = (0.65)^8 ≈ 0.0319.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.65', false, 'This is the probability that one call is unanswered, not that all 8 are.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.0002', false, 'This is (0.35)^8 ≈ 0.000225, the probability all 8 calls are answered, using p instead of 1 − p.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.9681', false, 'This is P(X ≥ 1) = 1 − 0.0319, the probability that at least one call is answered.' from version_ins;
commit;
