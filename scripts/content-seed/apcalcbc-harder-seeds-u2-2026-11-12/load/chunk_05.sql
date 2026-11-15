begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-h-2.5-b','apcalcbc-mcq-b5-sv-h-2.5-b-v1','apcalcbc-mcq-b5-sv-h-2.5-b-v2','apcalcbc-mcq-b5-sv-h-2.5-b-v3','apcalcbc-mcq-b5-h-2.6-a','apcalcbc-mcq-b5-sv-h-2.6-a-v1','apcalcbc-mcq-b5-sv-h-2.6-a-v2','apcalcbc-mcq-b5-sv-h-2.6-a-v3','apcalcbc-mcq-b5-h-2.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b5-h-2.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.5-b', 'mcq', 'rewrite a product or quotient of radicals as a single power before differentiating, and avoid differentiating each facto', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = √x · ∛x for x > 0. What is f′(64)?', null, md5('apcalcbc-mcq-b5-h-2.5-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/768', false, 'This multiplies the two derivatives (1/(2√x))·(1/(3x^(2/3))) instead of using the product rule, giving (1/16)(1/48).' from version_ins
union all select gen_random_uuid(), id, 'B', '1/192', false, 'This multiplies the exponents instead of adding them, writing f(x) = x^(1/6), and then differentiates that.' from version_ins
union all select gen_random_uuid(), id, 'C', '80/3', false, 'This writes f(x) = x^(5/6) correctly but forgets to lower the exponent in the derivative, giving (5/6)x^(5/6) = (5/6)(32).' from version_ins
union all select gen_random_uuid(), id, 'D', '5/12', true, 'Correct: f(x) = x^(5/6), so f′(x) = (5/6)x^(−1/6) and f′(64) = (5/6)(1/2) = 5/12.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.5-b-v1', 'mcq', 'rewrite a product or quotient of radicals as a single power before differentiating, and avoid differentiating each facto (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x²/∛x for x > 0. What is f′(8)?', null, md5('apcalcbc-mcq-b5-sv-h-2.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '192', false, 'This divides the derivative of the numerator by the derivative of the denominator, 2x/((1/3)x^(−2/3)), instead of simplifying or using the quotient rule.' from version_ins
union all select gen_random_uuid(), id, 'B', '112/3', false, 'This adds 1/3 to the exponent 2 instead of subtracting it, writing f(x) = x^(7/3).' from version_ins
union all select gen_random_uuid(), id, 'C', '10/3', false, 'This writes the derivative correctly as (5/3)x^(2/3) but evaluates x^(2/3) at 8 as 2 instead of 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '20/3', true, 'Correct: f(x) = x^(5/3), so f′(x) = (5/3)x^(2/3) and f′(8) = (5/3)(4) = 20/3.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.5-b-v2', 'mcq', 'rewrite a product or quotient of radicals as a single power before differentiating, and avoid differentiating each facto (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 1/(x√x) for x > 0. What is f′(4)?', null, md5('apcalcbc-mcq-b5-sv-h-2.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3/16', false, 'This differentiates x^(−3/2) as (−3/2)x^(−3/2), forgetting to lower the exponent, which gives (−3/2)(1/8).' from version_ins
union all select gen_random_uuid(), id, 'B', '−3/64', true, 'Correct: f(x) = x^(−3/2), so f′(x) = (−3/2)x^(−5/2) and f′(4) = (−3/2)(1/32) = −3/64.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/64', false, 'The magnitude is right, but the exponent −3/2 is negative, so the derivative is negative.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/256', false, 'This multiplies the derivatives of the two factors x^(−1) and x^(−1/2) instead of combining them into x^(−3/2).' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.5-b-v3', 'mcq', 'rewrite a product or quotient of radicals as a single power before differentiating, and avoid differentiating each facto (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = ∛(x²) · √x for x > 0. What is f′(64)?', null, md5('apcalcbc-mcq-b5-sv-h-2.5-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7/6', false, 'This forgets the factor x^(1/6) in f′(x) = (7/6)x^(1/6); at x = 64 that factor is 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/48', false, 'This multiplies the exponents 2/3 and 1/2 to get x^(1/3), instead of adding them, and then differentiates that.' from version_ins
union all select gen_random_uuid(), id, 'C', '7/3', true, 'Correct: f(x) = x^(2/3 + 1/2) = x^(7/6), so f′(x) = (7/6)x^(1/6) and f′(64) = (7/6)(2) = 7/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '448/3', false, 'This writes f(x) = x^(7/6) but forgets to lower the exponent, giving (7/6)x^(7/6) = (7/6)(128).' from version_ins;
-- apcalcbc-mcq-b5-h-2.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.6-a', 'mcq', 'find the tangent line to a linear combination of functions from the tangent lines of the pieces, combining slopes and va', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of f at x = 2 is y = 3x − 1, and the tangent line to the graph of g at x = 2 is y = −x + 5. Let h(x) = 2f(x) − g(x). Which is an equation of the tangent line to the graph of h at x = 2?', null, md5('apcalcbc-mcq-b5-h-2.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 7x − 12', false, 'The slope 7 is right, but this uses h(2) = f(2) − g(2) = 2 and forgets to double f(2) = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 7x − 7', true, 'Correct: f(2) = 5, f′(2) = 3, g(2) = 3, g′(2) = −1, so h(2) = 7 and h′(2) = 6 + 1 = 7; the tangent is y − 7 = 7(x − 2).' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 5x − 3', false, 'This computes the slope as 2(3) − 1 = 5, using g′(2) = −1 with the wrong sign for a subtracted function.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 7x − 6', false, 'This doubles the 3x in f''s tangent line but not its constant −1, writing 2(3x) − 1 − (−x + 5).' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.6-a-v1', 'mcq', 'find the tangent line to a linear combination of functions from the tangent lines of the pieces, combining slopes and va (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of f at x = 3 is y = −2x + 9, and the tangent line to the graph of g at x = 3 is y = x − 1. Let h(x) = 3f(x) + 2g(x). Which is an equation of the tangent line to the graph of h at x = 3?', null, md5('apcalcbc-mcq-b5-sv-h-2.6-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −4x + 25', true, 'Correct: f(3) = 3, f′(3) = −2, g(3) = 2, g′(3) = 1, so h(3) = 13 and h′(3) = −6 + 2 = −4; the tangent is y − 13 = −4(x − 3).' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = −5x + 28', false, 'This forgets to double g′(3): 3(−2) + 1 = −5 gives the slope, and the line is then built through (3, 13).' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = −4x + 17', false, 'The slope −4 is right, but this uses h(3) = f(3) + g(3) = 5 and ignores the coefficients 3 and 2 on the values.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −x + 8', false, 'This adds the two tangent line equations without the coefficients, (−2x + 9) + (x − 1).' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.6-a-v2', 'mcq', 'find the tangent line to a linear combination of functions from the tangent lines of the pieces, combining slopes and va (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of f at x = 1 is y = 4x + 2, and the tangent line to the graph of g at x = 1 is y = −2x + 3. Let h(x) = f(x) − 3g(x) + x². Which is an equation of the tangent line to the graph of h at x = 1?', null, md5('apcalcbc-mcq-b5-sv-h-2.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 10x − 6', false, 'This treats x² as a constant in the derivative, so the 2x term is left out and the slope is 4 + 6 = 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 12x − 9', false, 'The slope 12 is right, but this uses h(1) = f(1) − 3g(1) = 3 and leaves out the value 1² = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 12x − 8', true, 'Correct: f(1) = 6, f′(1) = 4, g(1) = 1, g′(1) = −2, so h(1) = 6 − 3 + 1 = 4 and h′(1) = 4 + 6 + 2 = 12; the tangent is y − 4 = 12(x − 1).' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 4', false, 'This adds 3g′(1) instead of subtracting it, so the slope becomes 4 − 6 + 2 = 0.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.6-a-v3', 'mcq', 'find the tangent line to a linear combination of functions from the tangent lines of the pieces, combining slopes and va (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tangent line to the graph of f at x = 0 is y = 2x + 1, and the tangent line to the graph of g at x = 0 is y = −x + 4. Let h(x) = g(x) − 2f(x) + 3eˣ. Which is an equation of the tangent line to the graph of h at x = 0?', null, md5('apcalcbc-mcq-b5-sv-h-2.6-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 5', false, 'This forgets to double f′(0): the slope becomes −1 − 2 + 3 = 0 instead of −1 − 4 + 3 = −2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 6x + 5', false, 'This adds 2f′(0) instead of subtracting it, so the slope becomes −1 + 4 + 3 = 6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = −2x + 2', false, 'The slope is right, but this leaves out the 3e⁰ = 3 in h(0), using h(0) = g(0) − 2f(0) = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −2x + 5', true, 'Correct: f(0) = 1, f′(0) = 2, g(0) = 4, g′(0) = −1, so h(0) = 4 − 2 + 3 = 5 and h′(0) = −1 − 4 + 3 = −2; the tangent is y = −2x + 5.' from version_ins;
-- apcalcbc-mcq-b5-h-2.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.6-b', 'mcq', 'use f′ = c·g′ (or f′ = g′ + k) to conclude that a related combination of f and g is constant, rather than that f and g a', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are differentiable for all real x, and f′(x) = g′(x) for all x. Which statement must be true?', null, md5('apcalcbc-mcq-b5-h-2.6-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) − g(x) is constant.', true, 'Correct: (f − g)′ = f′ − g′ = 0 for all x, so f − g is constant, but that constant need not be 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = g(x) for all x.', false, 'Functions with the same derivative can differ by a vertical shift; for example f(x) = x² and g(x) = x² + 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f and g have the same zeros.', false, 'A vertical shift moves the zeros; x² has a zero at 0, but x² + 1 has none.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(0) = g(0).', false, 'Equal derivatives do not force equal values at any point, for example f(x) = x and g(x) = x + 5.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-h-2.5-b','apcalcbc-mcq-b5-sv-h-2.5-b-v1','apcalcbc-mcq-b5-sv-h-2.5-b-v2','apcalcbc-mcq-b5-sv-h-2.5-b-v3','apcalcbc-mcq-b5-h-2.6-a','apcalcbc-mcq-b5-sv-h-2.6-a-v1','apcalcbc-mcq-b5-sv-h-2.6-a-v2','apcalcbc-mcq-b5-sv-h-2.6-a-v3','apcalcbc-mcq-b5-h-2.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b5-h-2.5-b','apcalcbc-mcq-b5-sv-h-2.5-b-v1','apcalcbc-mcq-b5-sv-h-2.5-b-v2','apcalcbc-mcq-b5-sv-h-2.5-b-v3','apcalcbc-mcq-b5-h-2.6-a','apcalcbc-mcq-b5-sv-h-2.6-a-v1','apcalcbc-mcq-b5-sv-h-2.6-a-v2','apcalcbc-mcq-b5-sv-h-2.6-a-v3','apcalcbc-mcq-b5-h-2.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
