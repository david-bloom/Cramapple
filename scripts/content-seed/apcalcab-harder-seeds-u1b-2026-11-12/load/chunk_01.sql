begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-h-1.9-a','apcalcab-mcq-b7-sv-h-1.9-a-v1','apcalcab-mcq-b7-sv-h-1.9-a-v2','apcalcab-mcq-b7-sv-h-1.9-a-v3','apcalcab-mcq-b7-h-1.9-b','apcalcab-mcq-b7-sv-h-1.9-b-v1','apcalcab-mcq-b7-sv-h-1.9-b-v2','apcalcab-mcq-b7-sv-h-1.9-b-v3','apcalcab-mcq-b7-h-1.10-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b7-h-1.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.9-a', 'mcq', 'evaluate a limit of a composite g(f(x)) by combining a verbally described graph of f with a piecewise rule for g, tracki', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f near x = 2 is described as follows: as x approaches 2 from either side, f(x) increases toward 3 but always stays below 3, and the point on the graph at x = 2 is (2, 5). The function g is defined by g(u) = 2u + 1 for u < 3 and g(u) = u² − 1 for u ≥ 3. What is lim(x→2) g(f(x))?', null, md5('apcalcab-mcq-b7-h-1.9-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', true, 'Correct: Since f(x) → 3 from below, g(f(x)) → lim(u→3−) g(u) = 2(3) + 1 = 7. The values g(3) = 8 and g(f(2)) = g(5) = 24 are not what the limit follows.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', false, 'This evaluates the piece of g that applies at u = 3 itself, u² − 1 = 8, but the inputs f(x) stay below 3, so the left-hand piece of g governs the limit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'G has different one-sided limits at u = 3, but here the inputs f(x) approach 3 only from below, so only the left-hand piece matters and the limit does exist.' from version_ins
union all select gen_random_uuid(), id, 'D', '24', false, 'This substitutes f(2) = 5 into g. The limit depends on how f(x) behaves near x = 2, not on the single value f(2).' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.9-a-v1', 'mcq', 'evaluate a limit of a composite g(f(x)) by combining a verbally described graph of f with a piecewise rule for g, tracki (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A graph of f near x = 4 is described as follows: as x approaches 4 from either side, f(x) decreases toward −1 but always stays above −1, and the point on the graph at x = 4 is (4, 2). The function g is defined by g(u) = u + 5 for u ≤ −1 and g(u) = u² + 2 for u > −1. What is lim(x→4) g(f(x))?', null, md5('apcalcab-mcq-b7-sv-h-1.9-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', true, 'Correct: f(x) → −1 from above, so g(f(x)) → lim(u→−1+) (u² + 2) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This uses the piece u + 5 that applies at u = −1 itself, giving 4, but the inputs f(x) stay above −1, so the right-hand piece u² + 2 governs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'G has a jump at u = −1, but the inputs f(x) approach −1 only from above, so only one piece matters and the limit exists.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This substitutes f(4) = 2 into g to get g(2) = 6. The limit depends on the behaviour of f near x = 4, not on the value f(4).' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.9-a-v2', 'mcq', 'evaluate a limit of a composite g(f(x)) by combining a verbally described graph of f with a piecewise rule for g, tracki (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Near x = −3 the function f satisfies f(x) > 2 for every x ≠ −3, f(x) approaches 2 as x → −3, and f(−3) = 2. The function g is given by g(u) = (u² − 4)/(u − 2) for u ≠ 2 and g(2) = 7. What is lim(x→−3) g(f(x))?', null, md5('apcalcab-mcq-b7-sv-h-1.9-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', false, 'This uses g(2) = 7. The inputs f(x) approach 2 but are never equal to 2 for x ≠ −3, so the limit follows the formula (u² − 4)/(u − 2) = u + 2, not the single value g(2).' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This is lim f(x), the inner limit, not the limit of g(f(x)). The inner limit must still be fed through g.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'After cancelling, g(u) = u + 2 for u ≠ 2, which is continuous near 2 in the limit sense, so the limit exists and the answer is not DNE.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', true, 'Correct: For u ≠ 2, g(u) = u + 2, and f(x) ≠ 2 near −3, so g(f(x)) = f(x) + 2 → 4.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.9-a-v3', 'mcq', 'evaluate a limit of a composite g(f(x)) by combining a verbally described graph of f with a piecewise rule for g, tracki (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A graph of f near x = 0 is described as follows: as x approaches 0 from either side, f(x) increases toward 1 but always stays below 1, and f(0) = 4. The function g is defined by g(u) = |u − 1|/(u − 1) for u ≠ 1. What is lim(x→0) g(f(x))?', null, md5('apcalcab-mcq-b7-sv-h-1.9-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This is the value of g for u > 1 (and also g(f(0)) = g(4) = 1). The inputs f(x) approach 1 from below, where |u − 1| = −(u − 1), so the quotient is −1.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This averages the one-sided limits −1 and 1 of g at u = 1. Limits are not averaged, and here the inputs reach 1 only from below, so only −1 matters.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'G has different one-sided limits at u = 1, but f(x) approaches 1 only from below, so only the left-hand limit is used and the limit exists.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1', true, 'Correct: f(x) < 1 near 0, so |f(x) − 1| = −(f(x) − 1) and g(f(x)) = −1 for every x near 0, giving −1.' from version_ins;
-- apcalcab-mcq-b7-h-1.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.9-b', 'mcq', 'evaluate a one-sided limit of f(c − x) or f(c·x) from limits of f at a point, recognising that a negative inside factor ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies lim(x→2−) f(x) = 5, lim(x→2+) f(x) = −1, and f(2) = 3. What is lim(x→−2+) f(−x)?', null, md5('apcalcab-mcq-b7-h-1.9-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1', false, 'This reads the right-hand limit of f at 2. As x → −2 from the right, −x approaches 2 from the left, so the left-hand limit 5 is the one needed.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'This is f(2), the function value. The limit depends on the nearby values, not on the value at the point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'The two-sided limit of f at 2 does not exist, but the question asks about one side only, which is determined.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', true, 'Correct: If x → −2+, then x > −2, so −x < 2 and −x → 2−. So the limit is lim(u→2−) f(u) = 5.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.9-b-v1', 'mcq', 'evaluate a one-sided limit of f(c − x) or f(c·x) from limits of f at a point, recognising that a negative inside factor  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies lim(x→2−) f(x) = 4, lim(x→2+) f(x) = 0, and f(2) = 7. What is lim(x→1−) f(3 − x)?', null, md5('apcalcab-mcq-b7-sv-h-1.9-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', false, 'This reads the left-hand limit at 2. As x → 1 from the left, x < 1, so 3 − x > 2 and the input approaches 2 from the right.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'This is f(2), the function value. The limit depends on nearby values only.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'The two-sided limit of f at 2 does not exist, but only one side is involved here, so the one-sided limit exists.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', true, 'Correct: x → 1− gives 3 − x → 2+, so the limit is lim(u→2+) f(u) = 0.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.9-b-v2', 'mcq', 'evaluate a one-sided limit of f(c − x) or f(c·x) from limits of f at a point, recognising that a negative inside factor  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies lim(x→6−) f(x) = −3, lim(x→6+) f(x) = 2, and f(6) = 1. What is lim(x→−3+) f(−2x)?', null, md5('apcalcab-mcq-b7-sv-h-1.9-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'This reads the right-hand limit at 6. As x → −3 from the right, x > −3, so −2x < 6 and the input approaches 6 from the left.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This is f(6), the function value, which does not determine the limit.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3', true, 'Correct: x > −3 gives −2x < 6, so −2x → 6−. The limit is lim(u→6−) f(u) = −3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'F has no two-sided limit at 6, but the one-sided approach here is fixed from the left, so the limit exists.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.9-b-v3', 'mcq', 'evaluate a one-sided limit of f(c − x) or f(c·x) from limits of f at a point, recognising that a negative inside factor  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies lim(x→2−) f(x) = 6, lim(x→2+) f(x) = 2, and f(2) = 4. What is lim(x→−1) f(1 − x)?', null, md5('apcalcab-mcq-b7-sv-h-1.9-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', false, 'This uses only the left-hand limit. As x → −1 from the left, 1 − x approaches 2 from the right, giving 2; from the right it gives 6. The two sides disagree.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This uses only one side. The inputs 1 − x approach 2 from both sides as x → −1, so both one-sided limits of f at 2 are involved.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', true, 'Correct: x → −1 from either side makes 1 − x approach 2 from both sides, and the one-sided limits 6 and 2 differ, so the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This is f(2), the function value. The limit is decided by nearby values, which give 6 and 2.' from version_ins;
-- apcalcab-mcq-b7-h-1.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.10-a', 'mcq', 'classify discontinuities of a rational function containing an absolute value by comparing one-sided limits, distinguishi', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = |x − 3|/(x² − 9). Which of the following correctly describes the discontinuities of f?', null, md5('apcalcab-mcq-b7-h-1.10-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A jump discontinuity at x = 3 and an infinite discontinuity at x = −3', true, 'Correct: At x = 3 the one-sided limits are −1/6 and 1/6 (jump); at x = −3 the numerator is 6 and the denominator tends to 0 (infinite).' from version_ins
union all select gen_random_uuid(), id, 'B', 'A removable discontinuity at x = 3 and an infinite discontinuity at x = −3', false, 'This cancels x − 3 without handling the absolute value. For x > 3 the quotient is 1/(x + 3), but for x < 3 it is −1/(x + 3), so the one-sided limits are 1/6 and −1/6, not equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Infinite discontinuities at both x = 3 and x = −3', false, 'At x = 3 the factor x − 3 cancels in magnitude, leaving finite one-sided limits ±1/6. Only x = −3 makes the quotient unbounded.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A jump discontinuity at x = 3 and a removable discontinuity at x = −3', false, 'At x = −3 the numerator is |−6| = 6, which is not 0, while the denominator tends to 0, so the quotient is unbounded rather than approaching a finite limit.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-h-1.9-a','apcalcab-mcq-b7-sv-h-1.9-a-v1','apcalcab-mcq-b7-sv-h-1.9-a-v2','apcalcab-mcq-b7-sv-h-1.9-a-v3','apcalcab-mcq-b7-h-1.9-b','apcalcab-mcq-b7-sv-h-1.9-b-v1','apcalcab-mcq-b7-sv-h-1.9-b-v2','apcalcab-mcq-b7-sv-h-1.9-b-v3','apcalcab-mcq-b7-h-1.10-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b7-h-1.9-a','apcalcab-mcq-b7-sv-h-1.9-a-v1','apcalcab-mcq-b7-sv-h-1.9-a-v2','apcalcab-mcq-b7-sv-h-1.9-a-v3','apcalcab-mcq-b7-h-1.9-b','apcalcab-mcq-b7-sv-h-1.9-b-v1','apcalcab-mcq-b7-sv-h-1.9-b-v2','apcalcab-mcq-b7-sv-h-1.9-b-v3','apcalcab-mcq-b7-h-1.10-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
