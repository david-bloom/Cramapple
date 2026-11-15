begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-h-3.10-a','apprecalc-mcq-b3-sv-h-3.10-a-v1','apprecalc-mcq-b3-sv-h-3.10-a-v2','apprecalc-mcq-b3-sv-h-3.10-a-v3','apprecalc-mcq-b3-h-3.10-b','apprecalc-mcq-b3-sv-h-3.10-b-v1','apprecalc-mcq-b3-sv-h-3.10-b-v2','apprecalc-mcq-b3-sv-h-3.10-b-v3','apprecalc-mcq-b3-h-3.11-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apprecalc-mcq-b3-h-3.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.10-a', 'mcq', 'count the solutions of a trigonometric equation with a changed input coefficient on an interval, avoiding lost or extra ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'How many solutions does the equation 2 sin(3x) = √3 have on the interval 0 ≤ x < 2π?', null, md5('apprecalc-mcq-b3-h-3.10-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', true, 'Correct: Let u = 3x, so 0 ≤ u < 6π, three full cycles. sin u = √3/2 has two solutions per cycle (π/3 and 2π/3 plus multiples of 2π), so 2 × 3 = 6 solutions.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'Solving sin x = √3/2 gives only 2 solutions, but 3x runs through three full cycles on this interval, so this count is far too small.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'One solution per cycle is counted, but sin u = √3/2 has two solutions in every cycle (u = π/3 and u = 2π/3), so this is half the true count.' from version_ins
union all select gen_random_uuid(), id, 'D', '12', false, 'This lets 3x run to 12π instead of 6π, doubling the number of cycles, so the count is twice too large.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.10-a-v1', 'mcq', 'count the solutions of a trigonometric equation with a changed input coefficient on an interval, avoiding lost or extra  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'How many solutions does the equation 2 cos(2x) = −1 have on the interval 0 ≤ x < 2π?', null, md5('apprecalc-mcq-b3-sv-h-3.10-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'Solving cos x = −1/2 gives 2 solutions, but 2x runs through two full cycles, so the count must double.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', true, 'Correct: Let u = 2x, so 0 ≤ u < 4π, two full cycles. cos u = −1/2 has two solutions per cycle (2π/3 and 4π/3), so 2 × 2 = 4 solutions (x = π/3, 2π/3, 4π/3, 5π/3).' from version_ins
union all select gen_random_uuid(), id, 'C', '8', false, 'This counts four solutions per cycle of 2x, but cos u = −1/2 has only two solutions per cycle (2π/3 and 4π/3).' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'This drops one of the four solutions as if it fell outside the interval, but x = π/3, 2π/3, 4π/3 and 5π/3 all lie in [0, 2π).' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.10-a-v2', 'mcq', 'count the solutions of a trigonometric equation with a changed input coefficient on an interval, avoiding lost or extra  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'How many solutions does the equation sin(4x) = 1 have on the interval 0 ≤ x < 2π?', null, md5('apprecalc-mcq-b3-sv-h-3.10-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', false, 'This uses two solutions per cycle, as for most values of sine, but sin u = 1 occurs only once per cycle (u = π/2), at the top of the wave.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', true, 'Correct: Let u = 4x, so 0 ≤ u < 8π, four full cycles. sin u = 1 has exactly one solution per cycle (u = π/2 + 2πk), so 4 solutions (x = π/8, 5π/8, 9π/8, 13π/8).' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This solves sin x = 1 only (one solution per cycle) and forgets that 4x runs through four cycles.' from version_ins
union all select gen_random_uuid(), id, 'D', '16', false, 'This multiplies by 4 twice, once for the cycles and once for the coefficient, giving four times the true count.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.10-a-v3', 'mcq', 'count the solutions of a trigonometric equation with a changed input coefficient on an interval, avoiding lost or extra  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'How many solutions does the equation cos(3x) = 1/2 have on the interval 0 ≤ x ≤ π?', null, md5('apprecalc-mcq-b3-sv-h-3.10-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', false, 'This treats 3x as covering three full cycles, but 0 ≤ 3x ≤ 3π is only one and a half cycles.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This counts only the two solutions in the first cycle (u = π/3 and 5π/3) and ignores that 3x continues past 2π to 7π/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'Correct: Let u = 3x, so 0 ≤ u ≤ 3π. cos u = 1/2 at u = π/3, 5π/3 and 7π/3 (the next, 11π/3, exceeds 3π), so there are 3 solutions.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This lets 3x run to 4π instead of 3π, which picks up solutions at 11π/3 that lie outside the interval.' from version_ins;
-- apprecalc-mcq-b3-h-3.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.10-b', 'mcq', 'solve a trigonometric inequality on an interval, keeping every arc and reversing the inequality when dividing by a negat', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x < 2π, which gives the complete solution set of 2cos x + 1 > 0?', null, md5('apprecalc-mcq-b3-h-3.10-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(2π/3, 4π/3)', false, 'This is where cos x < −1/2; the inequality sign was reversed, so it gives the region the inequality excludes.' from version_ins
union all select gen_random_uuid(), id, 'B', '[0, 2π/3) ∪ (4π/3, 2π)', true, 'Correct: 2cos x + 1 > 0 gives cos x > −1/2. Cosine equals −1/2 at 2π/3 and 4π/3 and is larger outside the arc between them, so x is in [0, 2π/3) ∪ (4π/3, 2π).' from version_ins
union all select gen_random_uuid(), id, 'C', '[0, π/3) ∪ (5π/3, 2π)', false, 'This solves cos x > 1/2 by using the reference angle π/3 and ignoring the sign, but the inequality is cos x > −1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '[0, 2π/3)', false, 'This keeps only the part near 0 and loses the symmetric piece (4π/3, 2π) where cosine is also greater than −1/2.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.10-b-v1', 'mcq', 'solve a trigonometric inequality on an interval, keeping every arc and reversing the inequality when dividing by a negat (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x < 2π, which gives the complete solution set of sin x ≤ −√2/2?', null, md5('apprecalc-mcq-b3-sv-h-3.10-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 5π/4] ∪ [7π/4, 2π)', false, 'This is where sin x ≥ −√2/2; the inequality direction was reversed, so it describes the complement of the solution set.' from version_ins
union all select gen_random_uuid(), id, 'B', '[π/4, 3π/4]', false, 'This solves sin x ≥ √2/2 and drops the negative sign, so the arc lies in the upper half of the circle where sine is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', '[7π/6, 11π/6]', false, 'This uses the endpoints where sin x = −1/2 (reference angle π/6) instead of −√2/2 (reference angle π/4).' from version_ins
union all select gen_random_uuid(), id, 'D', '[5π/4, 7π/4]', true, 'Correct: sin x = −√2/2 at 5π/4 and 7π/4, and sine is at or below that value between them (down to −1 at 3π/2), so x is in [5π/4, 7π/4].' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.10-b-v2', 'mcq', 'solve a trigonometric inequality on an interval, keeping every arc and reversing the inequality when dividing by a negat (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x < 2π, which gives the complete solution set of 2sin x > 1?', null, md5('apprecalc-mcq-b3-sv-h-3.10-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, π/6) ∪ (5π/6, 2π)', false, 'This is where sin x < 1/2; it describes the region outside the arc where sine exceeds 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '(π/6, 5π/6)', true, 'Correct: 2sin x > 1 gives sin x > 1/2. Sine equals 1/2 at π/6 and 5π/6 and exceeds it between them, so x is in (π/6, 5π/6).' from version_ins
union all select gen_random_uuid(), id, 'C', '(π/3, 2π/3)', false, 'This uses the angles where sin x = √3/2 instead of 1/2, so it cuts off part of the solution set.' from version_ins
union all select gen_random_uuid(), id, 'D', '(π/6, π/2)', false, 'This stops at π/2, losing the portion (π/2, 5π/6) in the second quadrant where sine is still greater than 1/2.' from version_ins;
-- apprecalc-mcq-b3-sv-h-3.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-sv-h-3.10-b-v3', 'mcq', 'solve a trigonometric inequality on an interval, keeping every arc and reversing the inequality when dividing by a negat (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x < 2π, which gives the complete solution set of −2cos x > √3?', null, md5('apprecalc-mcq-b3-sv-h-3.10-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 5π/6) ∪ (7π/6, 2π)', false, 'This divides by −2 without reversing the inequality, solving cos x > −√3/2 instead of cos x < −√3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '(5π/6, 7π/6)', true, 'Correct: Dividing −2cos x > √3 by −2 reverses the inequality: cos x < −√3/2. Cosine equals −√3/2 at 5π/6 and 7π/6 and is smaller between them, so x is in (5π/6, 7π/6).' from version_ins
union all select gen_random_uuid(), id, 'C', '(π/6, 11π/6)', false, 'This reverses the inequality correctly but drops the negative sign, solving cos x < √3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3π/4, 5π/4)', false, 'This uses the angles where cos x = −√2/2 instead of −√3/2, so the arc is too wide.' from version_ins;
-- apprecalc-mcq-b3-h-3.11-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b3-h-3.11-a', 'mcq', 'find the range of a transformed secant or cosecant function by combining the |value| ≥ 1 restriction with a stretch, ref', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the range of the function y = 2csc x − 1?', null, md5('apprecalc-mcq-b3-h-3.11-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−∞, −3] ∪ [1, ∞)', true, 'Correct: csc x ≤ −1 or csc x ≥ 1. Doubling gives ≤ −2 or ≥ 2, and subtracting 1 gives y ≤ −3 or y ≥ 1, so the range is (−∞, −3] ∪ [1, ∞).' from version_ins
union all select gen_random_uuid(), id, 'B', '[−3, 1]', false, 'This treats csc x like a bounded wave with values between −1 and 1; the cosecant takes every value with magnitude at least 1, so it is unbounded.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−∞, −2] ∪ [2, ∞)', false, 'This applies the vertical stretch by 2 but forgets the shift down by 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−∞, −1] ∪ [3, ∞)', false, 'This shifts the stretched range up by 1 instead of down by 1.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b3-h-3.10-a','apprecalc-mcq-b3-sv-h-3.10-a-v1','apprecalc-mcq-b3-sv-h-3.10-a-v2','apprecalc-mcq-b3-sv-h-3.10-a-v3','apprecalc-mcq-b3-h-3.10-b','apprecalc-mcq-b3-sv-h-3.10-b-v1','apprecalc-mcq-b3-sv-h-3.10-b-v2','apprecalc-mcq-b3-sv-h-3.10-b-v3','apprecalc-mcq-b3-h-3.11-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b3-h-3.10-a','apprecalc-mcq-b3-sv-h-3.10-a-v1','apprecalc-mcq-b3-sv-h-3.10-a-v2','apprecalc-mcq-b3-sv-h-3.10-a-v3','apprecalc-mcq-b3-h-3.10-b','apprecalc-mcq-b3-sv-h-3.10-b-v1','apprecalc-mcq-b3-sv-h-3.10-b-v2','apprecalc-mcq-b3-sv-h-3.10-b-v3','apprecalc-mcq-b3-h-3.11-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
