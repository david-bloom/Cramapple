begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.2-a-v1','apcalcbc-mcq-b4-sv-h-4.2-a-v2','apcalcbc-mcq-b4-sv-h-4.2-a-v3','apcalcbc-mcq-b4-h-4.2-b','apcalcbc-mcq-b4-sv-h-4.2-b-v1','apcalcbc-mcq-b4-sv-h-4.2-b-v2','apcalcbc-mcq-b4-sv-h-4.2-b-v3','apcalcbc-mcq-b4-h-4.3-a','apcalcbc-mcq-b4-sv-h-4.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b4-sv-h-4.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.2-a-v1', 'mcq', 'decide when a particle is speeding up by comparing the signs of velocity and acceleration, not either sign alone. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with velocity v(t) = t² − 6t + 8 for 0 ≤ t ≤ 6. On which time intervals is the particle speeding up?', null, md5('apcalcbc-mcq-b4-sv-h-4.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 < t < 2 and 4 < t < 6', false, 'These are the intervals where v is positive; on 0 < t < 2 the acceleration a = 2t − 6 is negative while v is positive, so the particle is slowing down there.' from version_ins
union all select gen_random_uuid(), id, 'B', '3 < t < 6', false, 'This is where a is positive, but on 3 < t < 4 the velocity is negative while the acceleration is positive, so the particle is slowing down on that stretch.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 < t < 3 and 4 < t < 6', true, 'Correct: v = (t − 2)(t − 4) and a = 2t − 6. Both are negative on 2 < t < 3 and both are positive on 4 < t < 6, so the particle speeds up exactly there.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 < t < 4', false, 'This is where v is negative, so the particle moves left, but moving left does not mean speeding up; on 3 < t < 4 the acceleration is positive and the speed falls.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.2-a-v2', 'mcq', 'decide when a particle is speeding up by comparing the signs of velocity and acceleration, not either sign alone. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with velocity v(t) = 2cos t for 0 ≤ t ≤ 2π. On which time intervals is the particle speeding up?', null, md5('apcalcbc-mcq-b4-sv-h-4.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 < t < π/2 and 3π/2 < t < 2π', false, 'These are the intervals where v is positive; on 0 < t < π/2 the acceleration a = −2sin t is negative while v is positive, so the particle is slowing down there.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π < t < 2π', false, 'This is where a is positive, but on π < t < 3π/2 the velocity is negative while the acceleration is positive, so the particle is slowing down on that stretch.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/2 < t < 3π/2', false, 'This is where v is negative, but moving left is not the same as speeding up; on π < t < 3π/2 the acceleration is positive, so the speed is falling.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/2 < t < π and 3π/2 < t < 2π', true, 'Correct: a = −2sin t. v and a are both negative on π/2 < t < π (cos t < 0, sin t > 0) and both positive on 3π/2 < t < 2π (cos t > 0, sin t < 0).' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.2-a-v3', 'mcq', 'decide when a particle is speeding up by comparing the signs of velocity and acceleration, not either sign alone. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with velocity v(t) = −t² + 6t − 5 for 0 ≤ t ≤ 7. On which time intervals is the particle speeding up?', null, md5('apcalcbc-mcq-b4-sv-h-4.2-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1 < t < 3 and 5 < t < 7', true, 'Correct: v = −(t − 1)(t − 5) and a = −2t + 6. Both are positive on 1 < t < 3 and both are negative on 5 < t < 7, so the particle speeds up exactly there.' from version_ins
union all select gen_random_uuid(), id, 'B', '1 < t < 5', false, 'This is where v is positive, so the particle moves right, but moving right is not the same as speeding up; on 3 < t < 5 the acceleration a = −2t + 6 is negative and the speed falls.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 < t < 3', false, 'This is where a is positive, but on 0 < t < 1 the velocity is negative while the acceleration is positive, so the particle is slowing down there.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 < t < 1 and 5 < t < 7', false, 'These are the intervals where v is negative, so the particle moves left; on 0 < t < 1 the acceleration is positive, so the speed is falling and not rising.' from version_ins;
-- apcalcbc-mcq-b4-h-4.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.2-b', 'mcq', 'distinguish total distance traveled from displacement and final position when velocity changes sign.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a horizontal line with velocity v(t) = 3t² − 12t + 9 for 0 ≤ t ≤ 4. Its position at t = 0 is x(0) = 2. What is the total distance traveled by the particle from t = 0 to t = 4?', null, md5('apcalcbc-mcq-b4-h-4.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12', true, 'Correct: v = 3(t − 1)(t − 3), and an antiderivative is t³ − 6t² + 9t, which equals 0 at t = 0, 4 at t = 1, 0 at t = 3 and 4 at t = 4. Distance = |4 − 0| + |0 − 4| + |4 − 0| = 12.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This is the displacement x(4) − x(0); it lets the leftward motion on 1 < t < 3 cancel part of the rightward motion instead of adding to the distance.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'This is the final position x(4) = 2 + 4, which includes the starting position and is not a distance traveled.' from version_ins
union all select gen_random_uuid(), id, 'D', '8', false, 'This counts only 0 ≤ t ≤ 3 and leaves out the final stretch 3 ≤ t ≤ 4, where the particle moves right again by 4 units.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.2-b-v1', 'mcq', 'distinguish total distance traveled from displacement and final position when velocity changes sign. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a horizontal line with velocity v(t) = 6t² − 30t + 24 for 0 ≤ t ≤ 5. Its position at t = 0 is x(0) = 3. What is the total distance traveled by the particle from t = 0 to t = 5?', null, md5('apcalcbc-mcq-b4-sv-h-4.2-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'This is the size of the displacement x(5) − x(0) = −5; the rightward and leftward motion partly cancel in displacement but both count toward distance.' from version_ins
union all select gen_random_uuid(), id, 'B', '49', true, 'Correct: v = 6(t − 1)(t − 4), and an antiderivative is 2t³ − 15t² + 24t, which equals 0 at t = 0, 11 at t = 1, −16 at t = 4 and −5 at t = 5. Distance = 11 + 27 + 11 = 49.' from version_ins
union all select gen_random_uuid(), id, 'C', '22', false, 'This adds only the two stretches where v is positive, 11 each, and omits the 27 units traveled while the particle moves left.' from version_ins
union all select gen_random_uuid(), id, 'D', '38', false, 'This adds the first two stretches, 11 and 27, but leaves out the final stretch 4 ≤ t ≤ 5, where the particle moves right by another 11 units.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.2-b-v2', 'mcq', 'distinguish total distance traveled from displacement and final position when velocity changes sign. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a horizontal line with velocity v(t) = cos t for 0 ≤ t ≤ 3π/2. Its position at t = 0 is x(0) = 5. What is the total distance traveled by the particle from t = 0 to t = 3π/2?', null, md5('apcalcbc-mcq-b4-sv-h-4.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This is the size of the displacement, sin(3π/2) − sin 0 = −1, in which the leftward and rightward motion cancel; distance adds them instead.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This counts only the leftward motion on π/2 < t < 3π/2 and leaves out the 1 unit traveled right on 0 < t < π/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This is the final position x(3π/2) = 5 − 1, which includes the starting position and is not a distance traveled.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'Correct: The integral of |cos t| splits at t = π/2: ∫ from 0 to π/2 of cos t dt = 1 and ∫ from π/2 to 3π/2 of |cos t| dt = 2. Total distance = 1 + 2 = 3.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.2-b-v3', 'mcq', 'distinguish total distance traveled from displacement and final position when velocity changes sign. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a horizontal line with velocity v(t) = 4 − t² for 0 ≤ t ≤ 4. Its position at t = 0 is x(0) = 1. What is the total distance traveled by the particle from t = 0 to t = 4?', null, md5('apcalcbc-mcq-b4-sv-h-4.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16/3', false, 'This is the size of the net change in position, −16/3, in which the rightward and leftward motion partly cancel; distance counts both stretches in full.' from version_ins
union all select gen_random_uuid(), id, 'B', '32/3', false, 'This counts only the leftward motion on 2 < t < 4 and leaves out the 16/3 units traveled right on 0 < t < 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '16', true, 'Correct: An antiderivative is 4t − t³/3, which equals 0 at t = 0, 16/3 at t = 2 and −16/3 at t = 4. Distance = 16/3 + |−16/3 − 16/3| = 16/3 + 32/3 = 16.' from version_ins
union all select gen_random_uuid(), id, 'D', '13/3', false, 'This is the size of the final position x(4) = 1 − 16/3 = −13/3, which includes the starting position and is not a distance traveled.' from version_ins;
-- apcalcbc-mcq-b4-h-4.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.3-a', 'mcq', 'combine marginal revenue and marginal cost into a marginal profit and read the sign of the second derivative as the tren', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company''s revenue from selling x hundred units is R(x) = 50x − 0.5x² thousand dollars and its cost is C(x) = 20 + 12x + 0.1x² thousand dollars. Which statement is correct at x = 20?', null, md5('apcalcbc-mcq-b4-h-4.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Profit is increasing at 14 thousand dollars per hundred units, and that rate of increase is itself decreasing.', true, 'Correct: P(x) = R(x) − C(x), so P′(x) = (50 − x) − (12 + 0.2x) = 38 − 1.2x and P′(20) = 14 > 0. P″(x) = −1.2 < 0, so the rate of profit increase is itself decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Profit is increasing at 30 thousand dollars per hundred units, and that rate of increase is itself decreasing.', false, 'R′(20) = 30 is only the marginal revenue; the marginal profit also subtracts the marginal cost C′(20) = 16.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Profit is increasing at 14 thousand dollars per hundred units, and that rate of increase is itself increasing.', false, 'P″ = R″ − C″ = −1 − 0.2 = −1.2 is negative, so the marginal profit is falling; claiming that the rate of increase is itself increasing gets the sign of P″ wrong.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Profit is increasing at 46 thousand dollars per hundred units, and that rate of increase is itself decreasing.', false, '46 = 30 + 16 adds marginal revenue and marginal cost; profit is revenue minus cost, so the marginal cost must be subtracted.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.3-a-v1', 'mcq', 'combine marginal revenue and marginal cost into a marginal profit and read the sign of the second derivative as the tren (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bakery''s revenue from selling x cakes in a day is R(x) = 9x − 0.04x² dollars and its cost is C(x) = 30 + 2x + 0.03x² dollars. Which statement is correct at x = 90?', null, md5('apcalcbc-mcq-b4-sv-h-4.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Profit is decreasing at $7.40 per cake, and it is decreasing faster as x increases.', false, '7.40 is the marginal cost C′(90) alone; the marginal profit also includes the marginal revenue R′(90) = 1.80.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Profit is decreasing at $5.60 per cake, but it is decreasing more slowly as x increases.', false, 'P″ = R″ − C″ = −0.08 − 0.06 = −0.14 is negative, so the profit rate keeps falling; a negative P′ with a negative P″ means the decline is speeding up.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Profit is decreasing at $5.60 per cake, and it is decreasing faster as x increases.', true, 'Correct: P′(x) = (9 − 0.08x) − (2 + 0.06x) = 7 − 0.14x, so P′(90) = −5.6. P″(x) = −0.14 < 0, so the rate of profit change keeps falling and profit declines faster.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Profit is increasing at $9.20 per cake, and it is decreasing faster as x increases.', false, '9.20 = 1.80 + 7.40 adds marginal revenue and marginal cost; profit is revenue minus cost, so marginal cost is subtracted, giving a negative rate.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.2-a-v1','apcalcbc-mcq-b4-sv-h-4.2-a-v2','apcalcbc-mcq-b4-sv-h-4.2-a-v3','apcalcbc-mcq-b4-h-4.2-b','apcalcbc-mcq-b4-sv-h-4.2-b-v1','apcalcbc-mcq-b4-sv-h-4.2-b-v2','apcalcbc-mcq-b4-sv-h-4.2-b-v3','apcalcbc-mcq-b4-h-4.3-a','apcalcbc-mcq-b4-sv-h-4.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b4-sv-h-4.2-a-v1','apcalcbc-mcq-b4-sv-h-4.2-a-v2','apcalcbc-mcq-b4-sv-h-4.2-a-v3','apcalcbc-mcq-b4-h-4.2-b','apcalcbc-mcq-b4-sv-h-4.2-b-v1','apcalcbc-mcq-b4-sv-h-4.2-b-v2','apcalcbc-mcq-b4-sv-h-4.2-b-v3','apcalcbc-mcq-b4-h-4.3-a','apcalcbc-mcq-b4-sv-h-4.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
