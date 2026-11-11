begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.3-a-v2','apcalcbc-mcq-b5-sv-h-2.3-a-v3','apcalcbc-mcq-b5-h-2.3-b','apcalcbc-mcq-b5-sv-h-2.3-b-v1','apcalcbc-mcq-b5-sv-h-2.3-b-v2','apcalcbc-mcq-b5-sv-h-2.3-b-v3','apcalcbc-mcq-b5-h-2.4-a','apcalcbc-mcq-b5-sv-h-2.4-a-v1','apcalcbc-mcq-b5-sv-h-2.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b5-sv-h-2.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.3-a-v2', 'mcq', 'use monotonic f′ to place f′ at a point strictly between the adjacent secant slopes, rather than treating the centered e (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has a strictly increasing derivative on [2, 7]. The values f(2) = 1, f(4) = 5, and f(7) = 17 are known. Which statement about f′(4) must be true?', null, md5('apcalcbc-mcq-b5-sv-h-2.3-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f′(4) is strictly between 2 and 4.', true, 'Correct: Average slopes are (5 − 1)/2 = 2 on [2, 4] and (17 − 5)/3 = 4 on [4, 7]; with f′ increasing, 2 < f′(4) < 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f′(4) = 3.2 exactly.', false, 'The quotient (17 − 1)/(7 − 2) = 3.2 is only an estimate, and with the unequal spacing it need not equal f′(4).' from version_ins
union all select gen_random_uuid(), id, 'C', 'f′(4) > 4.', false, 'Increasing f′ places f′(4) below the average slope on [4, 7], which is 4, since f′ keeps growing after x = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f′(4) < 2.', false, 'Increasing f′ places f′(4) above the average slope on [2, 4], which is 2, since f′ was smaller before x = 4.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.3-a-v3', 'mcq', 'use monotonic f′ to place f′ at a point strictly between the adjacent secant slopes, rather than treating the centered e (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The price index P(t) is differentiable and is increasing at an increasing rate on [0, 6]. The values P(0) = 20, P(2) = 26, and P(6) = 50 are known. Which statement about P′(2) must be true?', null, md5('apcalcbc-mcq-b5-sv-h-2.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P′(2) = 5 exactly.', false, 'The quotient (50 − 20)/6 = 5 is the average rate over all of [0, 6], not the instantaneous rate at t = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P′(2) is strictly between 3 and 6.', true, 'Correct: Average rates are (26 − 20)/2 = 3 on [0, 2] and (50 − 26)/4 = 6 on [2, 6]; with P′ increasing, 3 < P′(2) < 6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P′(2) > 6.', false, 'Because P′ is increasing, P′(2) lies below the average rate on [2, 6], which is 6, not above it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P′(2) < 3.', false, 'Because P′ is increasing, P′(2) lies above the average rate on [0, 2], which is 3, not below it.' from version_ins;
-- apcalcbc-mcq-b5-h-2.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.3-b', 'mcq', 'estimate the derivative of a linear combination of two tabulated functions by applying the same difference quotient to t', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g have the values f(3) = 9, f(5) = 15, g(3) = 4, g(5) = 8 (x = 3 and x = 5 are the table inputs closest to 4 on either side). Let h(x) = f(x) − 2g(x). Estimate h′(4) with a difference quotient built from these values.', null, md5('apcalcbc-mcq-b5-h-2.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This subtracts the derivative estimates without the factor 2: f′ ≈ 3 and g′ ≈ 2 give 3 − 2, but the coefficient of g is 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', true, 'Correct: h(3) = 9 − 8 = 1 and h(5) = 15 − 16 = −1, so h′(4) ≈ (−1 − 1)/(5 − 3) = −1.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2', false, 'The change h(5) − h(3) = −1 − 1 = −2 is correct but is a change, not a rate; dividing by the width 2 gives −1.' from version_ins
union all select gen_random_uuid(), id, 'D', '7', false, 'This adds 2g′ ≈ 4 to f′ ≈ 3, using the wrong sign for the subtracted function.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.3-b-v1', 'mcq', 'estimate the derivative of a linear combination of two tabulated functions by applying the same difference quotient to t (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g have the values f(5) = 11, f(9) = 31, g(5) = 20, g(9) = 12 (x = 5 and x = 9 are the table inputs closest to 6 on either side). Let h(x) = 2f(x) + g(x). Estimate h′(6) with a difference quotient built from these values.', null, md5('apcalcbc-mcq-b5-sv-h-2.3-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', false, 'This forgets the coefficient 2 on f: f′ ≈ 5 and g′ ≈ −2 give 5 + (−2) = 3, but h = 2f + g gives 2·5 + (−2).' from version_ins
union all select gen_random_uuid(), id, 'B', '32', false, 'The change h(9) − h(5) = 2·20 + (−8) = 32 is correct but is a total change; dividing by the width 4 gives the rate.' from version_ins
union all select gen_random_uuid(), id, 'C', '8', true, 'Correct: h(5) = 22 + 20 = 42 and h(9) = 62 + 12 = 74, so h′(6) ≈ (74 − 42)/4 = 8.' from version_ins
union all select gen_random_uuid(), id, 'D', '12', false, 'This subtracts g′ ≈ −2 from 2f′ ≈ 10, which gives 12, but h = 2f + g adds g.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.3-b-v2', 'mcq', 'estimate the derivative of a linear combination of two tabulated functions by applying the same difference quotient to t (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cumulative amounts f(t) and g(t) are differentiable. The table values are f(6) = 18, f(12) = 36, g(6) = 15, g(12) = 21 (t = 6 and t = 12 are the table inputs closest to 10 on either side). Let h(t) = f(t) − g(t). Estimate h′(10) with a difference quotient built from these values.', null, md5('apcalcbc-mcq-b5-sv-h-2.3-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', false, 'This adds the rate estimates 3 and 1, but h = f − g subtracts them.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', false, 'The change h(12) − h(6) = 18 − 6 = 12 is correct but is a total change; it must be divided by the width 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This estimates only f′ ≈ 3 and omits the contribution of g, which must be subtracted.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', true, 'Correct: h(6) = 18 − 15 = 3 and h(12) = 36 − 21 = 15, so h′(10) ≈ (15 − 3)/6 = 2.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.3-b-v3', 'mcq', 'estimate the derivative of a linear combination of two tabulated functions by applying the same difference quotient to t (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Differentiable functions f and g have the values f(1) = 8, f(3) = 2, g(1) = −1, g(3) = 5 (x = 1 and x = 3 are the table inputs closest to 2 on either side). Let h(x) = 5f(x) − 2g(x). Estimate h′(2) with a difference quotient built from these values.', null, md5('apcalcbc-mcq-b5-sv-h-2.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6', false, 'This combines the rate estimates −3 and 3 without the coefficients 5 and 2, so it adds them with the wrong weights.' from version_ins
union all select gen_random_uuid(), id, 'B', '−21', true, 'Correct: f′ ≈ (2 − 8)/2 = −3 and g′ ≈ (5 − (−1))/2 = 3, so h′(2) ≈ 5(−3) − 2(3) = −21.' from version_ins
union all select gen_random_uuid(), id, 'C', '−9', false, 'This computes 5(−3) + 2(3) = −9, using the wrong sign on the 2g term even though h subtracts it.' from version_ins
union all select gen_random_uuid(), id, 'D', '−42', false, 'The change h(3) − h(1) = 5(−6) − 2(6) = −42 is correct but is a total change; dividing by the width 2 gives −21.' from version_ins;
-- apcalcbc-mcq-b5-h-2.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.4-a', 'mcq', 'identify which function is differentiable at a point by diagnosing corners, cusps, and vertical tangents among similar-l', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following functions is differentiable at x = 2?', null, md5('apcalcbc-mcq-b5-h-2.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = (x − 2)|x − 2|', true, 'Correct: For f(x) = (x − 2)|x − 2| the quotient (f(2 + h) − f(2))/h = |h|, which tends to 0, so f′(2) exists and equals 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = |x − 2|', false, 'This has a corner at x = 2: the one-sided difference quotients are −1 and +1, so the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = (x − 2)^(2/3)', false, 'This is continuous but has a cusp at x = 2; the difference quotient h^(−1/3) is unbounded as h approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = (x − 2)^(1/3)', false, 'This is continuous but has a vertical tangent at x = 2; the difference quotient h^(−2/3) grows without bound.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.4-a-v1', 'mcq', 'identify which function is differentiable at a point by diagnosing corners, cusps, and vertical tangents among similar-l (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following functions is differentiable at x = 0?', null, md5('apcalcbc-mcq-b5-sv-h-2.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = x^(4/3)', true, 'Correct: For f(x) = x^(4/3) the quotient (f(h) − f(0))/h = h^(1/3), which tends to 0, so f′(0) = 0 (matching (4/3)x^(1/3) at 0).' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = x^(1/3) + x²', false, 'The term x^(1/3) has a vertical tangent at 0, so the difference quotient grows without bound and f is not differentiable.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = |x| + x²', false, 'The term |x| has a corner at 0, so the one-sided quotients are −1 and +1 and the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = x^(2/3) + x', false, 'The term x^(2/3) has a cusp at 0, since its difference quotient h^(−1/3) is unbounded.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.4-a-v2', 'mcq', 'identify which function is differentiable at a point by diagnosing corners, cusps, and vertical tangents among similar-l (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following piecewise functions is differentiable at x = 0?', null, md5('apcalcbc-mcq-b5-sv-h-2.4-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = eˣ for x < 0 and f(x) = 2x + 1 for x ≥ 0', false, 'The pieces meet at 1, so f is continuous, but the slopes are 1 from the left and 2 from the right, a corner.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = eˣ for x < 0 and f(x) = x + 1 for x ≥ 0', true, 'Correct: Both pieces equal 1 at 0, and the one-sided derivatives are e⁰ = 1 on the left and 1 on the right, so f′(0) = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = eˣ for x < 0 and f(x) = x + 2 for x ≥ 0', false, 'The left limit is 1 and f(0) = 2, so f is not even continuous at 0, and it cannot be differentiable there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = eˣ for x < 0 and f(x) = 1 + x² for x ≥ 0', false, 'The pieces meet at 1, but the slope from the left is 1 and from the right is 0, a corner.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.3-a-v2','apcalcbc-mcq-b5-sv-h-2.3-a-v3','apcalcbc-mcq-b5-h-2.3-b','apcalcbc-mcq-b5-sv-h-2.3-b-v1','apcalcbc-mcq-b5-sv-h-2.3-b-v2','apcalcbc-mcq-b5-sv-h-2.3-b-v3','apcalcbc-mcq-b5-h-2.4-a','apcalcbc-mcq-b5-sv-h-2.4-a-v1','apcalcbc-mcq-b5-sv-h-2.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b5-sv-h-2.3-a-v2','apcalcbc-mcq-b5-sv-h-2.3-a-v3','apcalcbc-mcq-b5-h-2.3-b','apcalcbc-mcq-b5-sv-h-2.3-b-v1','apcalcbc-mcq-b5-sv-h-2.3-b-v2','apcalcbc-mcq-b5-sv-h-2.3-b-v3','apcalcbc-mcq-b5-h-2.4-a','apcalcbc-mcq-b5-sv-h-2.4-a-v1','apcalcbc-mcq-b5-sv-h-2.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
